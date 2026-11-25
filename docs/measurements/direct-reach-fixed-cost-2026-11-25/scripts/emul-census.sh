#!/bin/bash
# run.sh NAME OVERLAY...: musl's units by -std=c99 through the direct path with the overlay directories first; prints
# direct/full counts and the bail reasons.
name=$1; shift
C=/home/user/corpora; M=$C/libc/musl
ov=(); for o in "$@"; do ov+=(-I "/home/user/work/emul/$o"); done
inc=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 "${ov[@]}" -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
export CMD="BUSTER_EXPERIMENT_DIRECT_TRACE=1 /home/user/keep/compiler-trace2 -c --lanes 1 -std=gnu99 $(printf '%q ' "${inc[@]}")"
/home/user/work/musl-list.sh | xargs -P 4 -I{} bash -c 'o=/dev/shm/emul-$$.o; eval "$CMD {} -o $o" 2>&1 >/dev/null | grep "^direct-bail" | cut -f3,4 | head -1; if grep -qa "buster direct" $o 2>/dev/null; then echo DIRECT; fi; rm -f $o' > $name.out
echo "$name: direct $(grep -c '^DIRECT' $name.out), left $(grep -vc '^DIRECT' $name.out)"
grep -v '^DIRECT' $name.out | awk -F'\t' '{print $1}' | sort | uniq -c | sort -rn | head -8
