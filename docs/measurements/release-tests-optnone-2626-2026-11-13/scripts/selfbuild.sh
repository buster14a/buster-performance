#!/bin/bash
# #2630 step 1 on the 9700X: the base tree's Release executable (2626-claude/placements/base/compiler-0: a11e44ac,
# znver5, no debug information) compiles every unit at --tier1 with the build's flags less -O3, -Wall and -Werror; the
# tree's own Release link joins them (stage2-t1); then test-tier0 by it. Each step its own hold of the lock.
set -u
d=$HOME/buster-fast-bench/2626-claude
L=$d/scripts/lock.sh
out=$d/self
mkdir -p "$out/t1"
cd "$d/base" || exit 2
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0
mapfile -t options < <(./build.sh print-compile-flags --config Release | tr '\0' '\n' | grep -vx -- '-O3\|-Wall\|-Werror')
printf '%s\n' "${options[@]}" > "$out/options.txt"
./build.sh print-sources | tr '\0' '\n' > "$out/sources.txt"
cat > "$out/compile.sh" <<'INNER'
#!/bin/bash
out=$1
cd "$(dirname "$out")/base" || exit 2
mapfile -t options < "$out/options.txt"
compile_one()
{
    local name
    name=$(basename "$1" .c)
    if "$(dirname "$out")/placements/base/compiler-0" --tier1 "${options[@]}" -c -o "$out/t1/$name.o" "$1" > "$out/t1/$name.log" 2>&1; then echo "ok $name"; else echo "FAILED $name"; fi
}
export -f compile_one
export out
xargs -a "$out/sources.txt" -P 8 -I{} bash -c 'mapfile -t options < "$out/options.txt"; compile_one "$@"' _ {} > "$out/compile.txt"
INNER
chmod +x "$out/compile.sh"
"$L" "$out/compile.sh" "$out"
echo "compiled $(grep -c '^ok' "$out/compile.txt"), failed $(grep -c FAILED "$out/compile.txt")"
tree=$(dirname "$(dirname "$(./build.sh print-output --config Release)")")
command=$(ninja -C "$tree" -f build-Release.ninja -t commands Release/compiler.link | tail -1)
command=${command#*&& }
rewritten=""
for word in $command; do
    case $word in
        CMakeFiles/buster_*.c.o) object=$(basename "$word" .c.o) ;;
        Release/codegen/*/native.o) object=$(basename "$(dirname "$word")") ;;
        *) object="" ;;
    esac
    [ -z "$object" ] || word=$out/t1/$object.o
    rewritten="$rewritten $word"
done
rewritten=${rewritten/-o Release\/compiler.link/-o $out/stage2-t1}
printf '%s\n' "$rewritten" > "$out/link.txt"
"$L" bash -c "cd '$tree' && $rewritten" > "$out/link.log" 2>&1
echo "link $?"
"$L" bash -c "cd '$d/base' && timeout 900 '$out/stage2-t1' test-tier0" > "$out/test-tier0.log" 2>&1
echo "test-tier0 $?"
tail -2 "$out/test-tier0.log"
