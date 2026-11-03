#!/usr/bin/env bash
# gap.sh BUILDS OUT: main-96b6cbcd's TSVs and tables from the record's inputs, into OUT, by tools/gap.c. BUILDS holds
# the four executables st-t1, lua-t1, st-clang2 and lua-clang2, whose SHA-256s main-96b6cbcd/inputs.sha256 gives with
# their disassemblies' (GNU objdump 2.42's); main-96b6cbcd/callgrind.tar.zst holds their callgrind runs. Each output is
# compared with the record's.
set -eu
R=$(cd "$(dirname "$0")/.." && pwd)
M=$R/main-96b6cbcd
B=$(readlink -f "$1")
mkdir -p "$2"
O=$(readlink -f "$2")
cc -O2 -o "$O/gap" "$R/tools/gap.c"
cd "$O"
for b in st-t1 lua-t1 st-clang2 lua-clang2; do
    cp "$B/$b" .
    objdump -d --no-show-raw-insn $b > $b.dis
done
sha256sum -c "$M/inputs.sha256" || echo "gap.sh: an input differs from the record's (another build, or another objdump's text)"
zstd -dc "$M/callgrind.tar.zst" | tar -xf -
# clang's executables are named in callgrind's output by the path they ran at, the first word of its "cmd:" line;
# Buster's, whose symbols valgrind doesn't read, are "???" at 0x108000.
object() { sed -n 's/^cmd: *\([^ ]*\).*/\1/p' "$1"; }
./gap count st-t1.dis cg/st-t1.txt.cg '???' 0x108000 "$M/st.kinds" > st-t1.tsv
./gap count st-clang2.dis cg/st-clang2.txt.cg "$(object cg/st-clang2.txt.cg)" 0 > st-clang2.tsv
scripts="calls tables strings arithmetic closures"
for s in $scripts; do
    ./gap count lua-t1.dis cg/$s-t1.txt.cg '???' 0x108000 "$M/lua.kinds" > $s-t1.tsv
    ./gap count lua-clang2.dis cg/$s-clang2.txt.cg "$(object cg/$s-clang2.txt.cg)" 0 > $s-clang2.tsv
done
./gap table st-t1.tsv -- st-clang2.tsv > st-table.md
./gap table $(for s in $scripts; do echo $s-t1.tsv; done) -- $(for s in $scripts; do echo $s-clang2.tsv; done) > lua-table.md
for f in st-t1.tsv st-clang2.tsv $(for s in $scripts; do echo $s-t1.tsv $s-clang2.tsv; done) st-table.md lua-table.md; do
    cmp -s $f "$M/$f" && echo "$f: the record's" || echo "$f: DIFFERS from the record's"
done
