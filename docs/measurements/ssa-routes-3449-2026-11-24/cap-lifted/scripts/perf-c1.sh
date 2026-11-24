#!/bin/bash
# perf-c1.sh: instructions and cycles of crows and ccap compiling musl (--tier1 -c, one lane, CPU 2), alternating five times.
D=~/buster-fast-bench/2924-c9h
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C EXCLUSIVE_OWNER=claude-2924-c9h EXCLUSIVE_TITLE="buster #3449: SSA routes (C9h)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3449
files=(); declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi; done
mkdir -p $D/perfc1 && cd $D/perfc1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
for r in 1 2 3 4 5; do for n in crows ccap; do
  perf stat -x, -e instructions:u,cycles:u -o '$D'/perfc1/$n-$r.txt taskset -c 2 '$D'/compiler-$n -c --tier1 --lanes 1 -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I '$musl'/arch/x86_64 -I '$musl'/arch/generic -I '$corpus'/musl-generated/obj/src/internal -I '$musl'/src/include -I '$musl'/src/internal -I '$corpus'/musl-generated/obj/include -I '$musl'/include "$@" > /dev/null 2>&1 || echo "run $n $r failed"
done; done' _ "${files[@]}"
for n in crows ccap; do echo "== $n"; for r in 1 2 3 4 5; do grep -h 'instructions\|cycles' $D/perfc1/$n-$r.txt | cut -d, -f1,3 | tr '\n' ' '; echo; done; done
