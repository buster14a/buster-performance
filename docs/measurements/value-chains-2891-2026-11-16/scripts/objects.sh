#!/bin/bash
# objects.sh LABEL: each corpus's objects' totals (the objects compile-all.sh left in /dev/shm/claude-2891-o-LABEL):
# files, bytes, sections, the bytes of .text*, of the sections with contents, of .eh_frame, the relocations (the RELA
# sections' entries) and the symbols. No lock: readelf over 1,371 small files, CPU 7 at niceness 19.
# results/LABEL/objects.txt and the lists scratch/objects-LABEL-CORPUS.txt.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1
out=/dev/shm/claude-2891-o-$label
mkdir -p scratch
for c in sqlite3 lua musl; do
    corpus_files "$c" | sed 's|.*/||; s|\.c$|.o|' | sort -u | sed "s|^|$out/|" > scratch/objects-$label-$c.txt
    bytes=$(xargs -a scratch/objects-$label-$c.txt stat -c %s | awk '{ s += $1 } END { print s + 0 }')
    xargs -a scratch/objects-$label-$c.txt -n 64 taskset -c 7 nice -n 19 readelf -S -W 2>/dev/null | awk -v c="$c" -v files="$(wc -l < scratch/objects-$label-$c.txt)" -v bytes="$bytes" '
        /^ *\[ *[0-9]+\] / {
            line = $0; sub(/^ *\[ *[0-9]+\] /, "", line); n = split(line, f, " ")
            if (f[1] ~ /^(NULL|PROGBITS|SYMTAB|STRTAB|RELA|NOBITS|X86_64_UNWIND|GROUP|INIT_ARRAY|FINI_ARRAY|NOTE)$/) { name = ""; type = f[1]; size = strtonum("0x" f[4]) } else { name = f[1]; type = f[2]; size = strtonum("0x" f[5]) }
            if (type == "NULL") next
            sections += 1
            if (type == "RELA") relocations += size / 24
            if (type == "SYMTAB") symbols += size / 24
            if (name ~ /^\.text/) text += size
            if (name == ".eh_frame") frames += size
            if (type != "NOBITS" && type != "RELA" && type != "SYMTAB" && type != "STRTAB") contents += size
        }
        END { printf "%s objects %d bytes %d sections %d text %d contents %d eh_frame %d relocations %d symbols %d\n", c, files, bytes, sections, text, contents, frames, relocations, symbols }'
done | tee results/$label/objects.txt
