#!/bin/bash
# text-identity.sh NAME A B: whether two linked executables hold the same loaded bytes, section by section (the code,
# the read-only data, the data, the unwind tables), for a build whose debug information alone was meant to change.
# Results in results/identity-NAME.txt. Not a timed run.
set -u
export LC_ALL=C
name=$1; a=$2; b=$3
d=$HOME/buster-fast-bench/2040-claude
mkdir -p "$d/scratch/identity"
out=$d/results/identity-$name.txt
{
    echo "A $a $(stat -c %s "$a") bytes"
    echo "B $b $(stat -c %s "$b") bytes"
    for section in .text .rodata .data .eh_frame .eh_frame_hdr .init_array .data.rel.ro .tdata; do
        llvm-objcopy -O binary --only-section="$section" "$a" "$d/scratch/identity/a.bin" 2> /dev/null
        llvm-objcopy -O binary --only-section="$section" "$b" "$d/scratch/identity/b.bin" 2> /dev/null
        ha=$(sha256sum < "$d/scratch/identity/a.bin" | cut -c1-16)
        hb=$(sha256sum < "$d/scratch/identity/b.bin" | cut -c1-16)
        verdict=different
        [ "$ha" != "$hb" ] || verdict=same
        echo "$section $(stat -c %s "$d/scratch/identity/a.bin") $(stat -c %s "$d/scratch/identity/b.bin") $ha $hb $verdict"
    done
} > "$out" 2>&1
cat "$out"
