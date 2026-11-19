#!/bin/bash
set -uo pipefail
D=~/buster-fast-bench/2924-c-df-claude/c12apr
cd $D
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor, C12a" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
mkdir -p prof3
cat > prof3/runs.sh <<'INNER'
#!/bin/bash
# $1 = side; the rest the compile's arguments: 20 runs, period 100003 + 2i.
side=$1; shift
for i in $(seq 0 19); do
    perf record -q -e instructions:u -c $((100003 + 2 * i)) -o prof3/$side-$i.data ./prof3/$side-exe "$@" > /dev/null 2>> prof3/$side.err
done
INNER
chmod +x prof3/runs.sh
for side in base head; do
    cp compilers/$side prof3/$side-exe
    $L timeout -k 5 1200 taskset -c 2 ./prof3/runs.sh $side -E "${M[@]}" "${files[@]}"
    echo "prof $side: $?" >> prof3/status.txt
    for i in $(seq 0 19); do
        perf report -i prof3/$side-$i.data --no-children --sort sym -F sample,sym --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > prof3/$side-$i.txt
        perf report -i prof3/$side-$i.data --no-children --sort sym --stdio --header-only 2> /dev/null | grep -i 'sample\|lost' | head -3 >> prof3/$side-header.txt
        rm -f prof3/$side-$i.data
    done
done
echo done >> prof3/status.txt
