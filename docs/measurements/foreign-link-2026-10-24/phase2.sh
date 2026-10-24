#!/bin/bash
# #86's validation and measurements on the 9700X, on tree2: each step its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
cd $base/tree2 || exit 1
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/86
L=~/buster-fast-bench/exclusive.sh
log=$base/logs2; mkdir -p $log
echo "build start $(date -Is)" > $log/status
EXCLUSIVE_TITLE="Issue 80: foreign linker build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 80: foreign linker call graph" $L ./build.sh check-call-graph > $log/callgraph.log 2>&1; echo "callgraph=$? $(date -Is)" >> $log/status
sed -n "/<<'TESTS'$/,/^ *TESTS$/{//!{s/^ \{10\}//;p}}" .github/workflows/9700x.yml > $log/tests.txt
EXCLUSIVE_TITLE="Issue 80: foreign linker tests" $L bash -c "clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h && ./build/compiler parallel --timeout 180 $log/tests.txt" > $log/tests.log 2>&1; echo "tests=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 80: foreign corpus against lld and mold" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
rm -rf /tmp/buster-link-benchmark-*
EXCLUSIVE_TITLE="Issue 80: link benchmark with link-foreign" $L ./build/compiler benchmark-link --kinds dynamic --keep > $log/link.log 2>&1; echo "link=$? $(date -Is)" >> $log/status
work=$(ls -dt /tmp/buster-link-benchmark-* | head -1)
gccdir=$(dirname $(gcc -print-libgcc-file-name))
crt=$(dirname $(gcc -print-file-name=Scrt1.o))
loader=/lib64/ld-linux-x86-64.so.2
objs=$(ls $work/objects/unit_*.o | sort -t_ -k3 -n | tr '\n' ' ')
cmd="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections -pie -dynamic-linker $loader -o $work/foreign.out $crt/Scrt1.o $crt/crti.o $gccdir/crtbeginS.o -L$gccdir -L/usr/lib $objs -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $gccdir/crtendS.o $crt/crtn.o"
echo "$cmd" > $log/foreign-command.txt
C=$base/tree2/build/compiler
EXCLUSIVE_TITLE="Issue 80: link-foreign phases and profile" $L bash -c "cd $work && for i in 1 2 3 4 5 6 7; do taskset -c 2 $C link-foreign --time --lanes=1 $cmd || exit 1; done; for i in 1 2 3 4 5 6 7; do taskset -c 0-7 $C link-foreign --time --lanes=8 $cmd || exit 1; done; $work/foreign.out > /dev/null; echo run=\$?; perf record -F 20000 -g -o $work/perf.data -- taskset -c 2 $C link-foreign --lanes=1 $cmd; for i in 1 2 3; do perf stat -e task-clock,cycles,instructions,page-faults -- taskset -c 2 $C link-foreign --lanes=1 $cmd; done" > $log/perf.log 2>&1; echo "perf=$? $(date -Is)" >> $log/status
perf report -i $work/perf.data --no-children --percent-limit 0.3 --stdio -g none > $log/perf-report.txt 2>&1
perf report -i $work/perf.data --children --percent-limit 1.5 --stdio -g none > $log/perf-children.txt 2>&1
mkdir -p $base/interp && cd $base/interp
printf '#include <stdio.h>\nint main(void) { puts("hello"); return 0; }\n' > hello.c && gcc -O2 -c hello.c -o hello.o
small="--hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now -pie $crt/Scrt1.o $crt/crti.o $gccdir/crtbeginS.o -L$gccdir -L/usr/lib hello.o -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $gccdir/crtendS.o $crt/crtn.o"
EXCLUSIVE_TITLE="Issue 80: link-foreign interpreter discovery cost" $L bash -c "for i in \$(seq 41); do a=\$(date +%s%N); taskset -c 2 $C link-foreign $small -o discovered.out || exit 1; b=\$(date +%s%N); taskset -c 2 $C link-foreign $small -dynamic-linker $loader -o explicit.out || exit 1; c=\$(date +%s%N); echo \$((b-a)) \$((c-b)); done; ./discovered.out && ./explicit.out && cmp discovered.out explicit.out && echo identical; for i in 1 2 3; do taskset -c 2 $C link-foreign --time $small -o timed.out; done" > $log/interp.log 2>&1; echo "interp=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status
