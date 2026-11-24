#!/bin/bash
# perf-r2.sh: perf record of rbase and rhead2 compiling musl (--tier1 -c, one lane, CPU 2), then the SSA symbols' shares.
D=~/buster-fast-bench/2924-c9h
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C EXCLUSIVE_OWNER=claude-2924-c9h EXCLUSIVE_TITLE="buster #3449: SSA routes (C9h)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3449
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
mkdir -p $D/perf && cd $D/perf
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
for n in rbase rhead2 rbase rhead2; do
  mkdir -p o-$n; cd o-$n
  perf record -q -F 20000 -o ../$n.data -- taskset -c 2 '$D'/compiler-$n -c --tier1 --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I '$musl'/arch/x86_64 -I '$musl'/arch/generic -I '$corpus'/musl-generated/obj/src/internal -I '$musl'/src/include -I '$musl'/src/internal -I '$corpus'/musl-generated/obj/include -I '$musl'/include "$@" > /dev/null 2>&1
  cd ..
done' _ "${files[@]}"
for n in rbase rhead2; do echo "== $n"; perf report -q -i $n.data --no-children --sort symbol 2>/dev/null | grep -i 'ssa\|arena\|dominator\|dataflow\|memset\|memcpy' | head -20; done
