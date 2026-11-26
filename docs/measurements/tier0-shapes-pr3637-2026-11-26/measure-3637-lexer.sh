set -euo pipefail
variant=$1
root=$PWD
out="$root/evidence-3637-lexer/$variant"
mkdir -p "$out/build"
cat /proc/loadavg > "$out/load-before.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-before.txt"
compiler="$root/base/build/compiler"
if [[ "$variant" == head-* ]]; then compiler="$root/pr3637/build/compiler"; fi
shapes=()
if [[ "$variant" == *-shapes ]]; then shapes=(--tier0-inline-shapes); fi
cd "$root/pr3637"
mapfile -d '' raw_flags < <(./build.sh print-compile-flags --config Release)
mapfile -d '' sources < <(./build.sh print-sources)
flags=()
for flag in "${raw_flags[@]}"; do
    case "$flag" in -O3|-Wall|-Werror|-g) ;; *) flags+=("$flag") ;; esac
done
objects=()
for source in "${sources[@]}"; do
    object="$out/build/$(basename "$source" .c).o"
    taskset -c 2 "$compiler" --lanes 1 "${shapes[@]}" "${flags[@]}" -c -o "$object" "$source"
    objects+=("$object")
done
clang -no-pie -o "$out/build/compiler" "${objects[@]}" -lm -ldl -lpthread
sha256sum "$compiler" "$out/build/compiler" > "$out/identity.txt"
for repetition in 1 2 3; do
    taskset -c 2 "$out/build/compiler" benchmark-lexer src > "$out/lexer-$repetition.txt"
done
cat /proc/loadavg > "$out/load-after.txt"
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> "$out/load-after.txt"
