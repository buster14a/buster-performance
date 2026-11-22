#!/bin/bash
# pair2.sh PARENT CANDIDATE WORKLOAD [ROUNDS] [EXTRA_CANDIDATE_OPTIONS]: paired fresh-process readings of one workload
# (sqlite, main, lua or musl), one lane on CPU 2. Each round runs parent and candidate in ABBA or BAAB order; each
# position takes the lock once and runs a warm-up, a wall-clock run (its faults recorded) and a counters run. Every
# run's objects and diagnostics are hashed: they must be one set.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
parent=$1
candidate=$2
workload=$3
rounds=${4:-7}
extra=${5:-}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$dir/inputs/lua-5.4.8/src
export LC_ALL=C
case $workload in
    sqlite) args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o unit.o); tokens=716136;;
    main) args=(-march=native "-I$dir/inputs/pooled-main-source/src" -fwrapv -funsigned-char --predefines "$dir/inputs/proof-predefines.h" "$dir/inputs/pooled-main-source/src/buster/compiler/main.c" -o unit.o); tokens=0;;
    lua) args=("$lua"/*.c); tokens=0;;
    musl)
        files=()
        declare -A seen
        for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            b=${f##*/}
            if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
        done
        args=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}"); tokens=0;;
    *) echo "unknown workload $workload" >&2; exit 2;;
esac
out="$dir/results/pair2-$workload-$parent-$candidate${extra:+-$(printf '%s' "$extra" | tr -c 'a-zA-Z0-9' '_')}"
rm -rf "$out"
mkdir -p "$out/scratch"
printf '%q ' "${args[@]}" > "$out/arguments.txt"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: paired $workload, $parent against $candidate $extra" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
cat > "$out/one.sh" <<'ONE'
#!/bin/bash
# one.sh COMPILER KEY EXTRA -- ARGUMENT...: a warm-up, a wall run and a counters run of one compile, in the scratch directory.
set -uo pipefail
cc=$1; key=$2; extra=$3; shift 4
out=$(dirname "$0")
cd "$out/scratch"
manifest() { find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -d' ' -f1; }
cat /proc/loadavg > "$out/$key.load"
rm -f ./*.o
taskset -c 2 "$cc" $extra --lanes 1 -c "$@" > /dev/null 2> "$out/$key.warm.stderr"
rm -f ./*.o
taskset -c 2 python3 "$out/../../wallrun.py" "$out/$key" -- "$cc" $extra --lanes 1 -c "$@"
manifest > "$out/$key.sha"
find . -maxdepth 1 -name '*.o' | wc -l > "$out/$key.objects"
rm -f ./*.o
taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -o "$out/$key.perf" -- "$cc" $extra --lanes 1 -c "$@" > /dev/null 2>&1
manifest >> "$out/$key.sha"
cat "$out/$key.stdout" "$out/$key.stderr" | sha256sum | cut -d' ' -f1 > "$out/$key.diag"
rm -f ./*.o
ONE
chmod +x "$out/one.sh"
one()
{
    local arm=$1 key=$2 rev options
    if [[ $arm = parent ]]; then rev=$parent; options=""; else rev=$candidate; options=$extra; fi
    "$HOME/buster-fast-bench/exclusive.sh" "$out/one.sh" "$dir/trees/$rev/build/compiler" "$key" "$options" -- "${args[@]}" 2>> "$out/lock.log"
}
for i in $(seq 1 "$rounds"); do
    if (( i % 2 )); then order="parent candidate candidate parent"; else order="candidate parent parent candidate"; fi
    pos=0
    for arm in $order; do
        one "$arm" "r$i.p$pos.$arm"
        pos=$((pos + 1))
    done
done
rm -rf "$out/scratch"
echo "$tokens" > "$out/tokens"
echo done > "$out/complete"
