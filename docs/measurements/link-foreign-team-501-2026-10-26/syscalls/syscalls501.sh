#!/bin/bash
# syscalls501.sh: system calls of one link-foreign process (strace -f -c), main against the head and the switch build's
# two settings, on the dry run's 2,000-worker program, dynamic and static, on 8 lanes. Each variant runs 5 times; the
# counts of clone3, mmap, munmap, madvise, mprotect and futex are each run's.
set -u
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-pr-464-review-e61025/5b49ed78-8b52-4daf-b75c-a350c66befc2/scratchpad
DRY=$HOME/.cache/claude-501-dry
O=$(echo $DRY/links2000/buster-link-benchmark-*/objects)
G=/usr/lib/gcc/x86_64-pc-linux-gnu/16
objects=$(ls $O/unit_*.o | sort -V | tr '\n' ' ')
mkdir -p $S/sys501
for kind in d s; do
    for v in m1:$S/trees/v0/build/compiler:free hd:/home/david/dev/ai/claude/buster/.claude/worktrees/pr-464-review-e61025/build/compiler:free rl:$S/trees/v2/build/compiler:free kp:$S/trees/v2/build/compiler:keep; do
        label=${v%%:*}; rest=${v#*:}; exe=${rest%%:*}; scratch=${rest##*:}
        for run in 1 2 3 4 5; do
            if [ $kind = d ]; then
                args="-pie -dynamic-linker /usr/lib/ld-linux-x86-64.so.2 -o $S/sys501/out-$label-$kind /usr/lib64/Scrt1.o /usr/lib64/crti.o $G/crtbeginS.o -L$G -L/usr/lib64 $objects -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $G/crtendS.o /usr/lib64/crtn.o"
            else
                args="-static -o $S/sys501/out-$label-$kind /usr/lib64/crt1.o /usr/lib64/crti.o $G/crtbeginT.o -L$G -L/usr/lib64 $objects --start-group -lgcc -lgcc_eh -lc --end-group $G/crtend.o /usr/lib64/crtn.o"
            fi
            BUSTER_501_SCRATCH=$scratch strace -f -c -o $S/sys501/$label-$kind-$run.txt $exe link-foreign --hash-style=gnu --build-id --eh-frame-hdr -m elf_x86_64 -z now --no-gc-sections --lanes=8 $args || echo "failed $label $kind"
            printf '%s %s %s' $label $kind $run
            for call in clone3 mmap munmap madvise mprotect futex; do
                printf ' %s=%s' $call "$(awk -v c=$call '$NF == c {print ($4 ~ /^[0-9]+$/ ? $4 : $5)}' $S/sys501/$label-$kind-$run.txt | head -1)"
            done
            printf '\n'
        done
    done
done
sha256sum $S/sys501/out-* | awk '{print $1}' | sort | uniq -c
