#!/bin/bash
# job-where2.sh: where --node-bodies' cost on musl's 1,336 units is. After job-regress1. The same binary (b0ee1afaa) with
# and without the option, in turn; each position takes the lock once: a warm-up, a perf record run and a counters run.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
until grep -q "^job-complete\|setup failed\|no compiler" job-regress1.log; do sleep 60; done
rev=b0ee1afaa
cc="$dir/trees/$rev/build/compiler"
[[ -x $cc ]] || { echo "no compiler"; exit 1; }
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
out="$dir/results/where-musl-$rev"
mkdir -p "$out/scratch"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
printf '%s\n' "${files[@]}" > "$out/files.txt"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: where --node-bodies' cost is on musl, $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
cat > "$out/one.sh" <<'ONE'
#!/bin/bash
# one.sh COMPILER KEY MUSL CORPUS [OPTION]: a warm-up, a profile and a counters run of musl's units, one process.
set -uo pipefail
cc=$1; key=$2; musl=$3; corpus=$4; extra=${5:-}
out=$(dirname "$0")
cd "$out/scratch"
mapfile -t files < "$out/files.txt"
args=(--lanes 1 -c -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}")
cat /proc/loadavg > "$out/$key.load"
rm -f ./*.o
taskset -c 2 "$cc" $extra "${args[@]}" > /dev/null 2> "$out/$key.warm.stderr"
find . -maxdepth 1 -name '*.o' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -d' ' -f1 > "$out/$key.sha"
rm -f ./*.o
taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/$key.data" -- "$cc" $extra "${args[@]}" > /dev/null 2>&1
rm -f ./*.o
taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,branch-misses:u,L1-dcache-load-misses:u,dTLB-load-misses:u,cache-misses:u -o "$out/$key.stat" -- "$cc" $extra "${args[@]}" > /dev/null 2>&1
rm -f ./*.o
ONE
chmod +x "$out/one.sh"
for i in 1 2 3; do
    if (( i % 2 )); then order="plain bodies"; else order="bodies plain"; fi
    for arm in $order; do
        extra=""; [[ $arm == bodies ]] && extra="--node-bodies"
        "$HOME/buster-fast-bench/exclusive.sh" "$out/one.sh" "$cc" "$arm-$i" "$musl" "$corpus" $extra 2>> "$out/lock.log"
        echo "round $i $arm done $(date -u +%H:%M:%S)"
    done
done
cd "$out"
for f in *.data; do perf report -i "$f" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > "${f%.data}.report"; done
sort -u ./*.sha | wc -l > distinct-objects.txt
echo job-complete
