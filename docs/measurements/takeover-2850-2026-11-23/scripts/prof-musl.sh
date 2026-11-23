#!/bin/bash
# prof-musl.sh TREE NAME: a cycles profile (user and kernel) of musl's 1,336 units as one command, one lane on CPU 2,
# three perf record runs in one hold of the lock, by symbol: results/profmusl-NAME/by-function.txt.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
tree=$1; name=$2
cc="$dir/trees/$tree/build/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
out="$dir/results/profmusl-$name"
rm -rf "$out"; mkdir -p "$out/scratch"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
args=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" "${files[@]}")
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: profile of musl's command, $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
cd "$out/scratch"
"$HOME/buster-fast-bench/exclusive.sh" bash -c '
    cc=$1; out=$2; shift 2
    taskset -c 2 "$cc" --lanes 1 -c "$@" > /dev/null 2>&1
    for i in 1 2 3; do
        taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/perf-$i.data" -- "$cc" --lanes 1 -c "$@" > /dev/null 2>&1
    done
    taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -r 3 -o "$out/stat.csv" -- "$cc" --lanes 1 -c "$@" > /dev/null 2>&1
' run "$cc" "$out" "${args[@]}" 2> "$out/lock.log"
cd "$out"; rm -rf scratch
for i in 1 2 3; do perf report -i perf-$i.data --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > report-$i.txt; done
rm -f perf-*.data
python3 - <<'PY' > by-function.txt
import glob, collections, re
tot = collections.Counter(); runs = 0; total = 0
for f in sorted(glob.glob('report-*.txt')):
    runs += 1
    for line in open(f):
        m = re.match(r'\s*([0-9.]+)%\s+(\d+)\s+\[(.)\]\s+(\S+)', line)
        if m:
            name = m.group(4).replace('.buster_split', '')
            tot[(m.group(3), name)] += int(m.group(2)); total += int(m.group(2))
print(f'total periods {total / runs / 1e6:.1f} M cycles a run over {runs} runs')
k = sum(v for (w, n), v in tot.items() if w == 'k')
print(f'kernel {100 * k / total:.1f}%')
for (w, n), v in tot.most_common():
    print(f'{v / runs / 1e6:9.3f} M {100 * v / total:6.2f}%  [{w}] {n}')
PY
echo done > complete
