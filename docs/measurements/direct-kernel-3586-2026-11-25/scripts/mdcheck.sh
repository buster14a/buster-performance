#!/bin/bash
# mdcheck.sh BASE HEAD: the corpus (equiv/run.sh) by both builds, then -MD -MF of sqlite3.c, a few header units and
# every musl unit by -std=gnu99 (most of them the direct path's), comparing each rule file and object.
set -uo pipefail
d=$HOME/buster-fast-bench/3586-claude
cd $d/equiv
if [ -z "${MD_ONLY:-}" ]; then
    ./run.sh $d/bin/compiler-$1 $1.tsv > $1.summary 2>&1
    ./run.sh $d/bin/compiler-$2 $2.tsv > $2.summary 2>&1
fi
cat $2.summary
if cmp -s $1.tsv $2.tsv; then echo "EQUIVALENT: $(wc -l < $2.tsv) units, $(awk -F'\t' '$6=="direct"' $2.tsv | wc -l) direct"; else echo "DIFFERENT:"; diff $1.tsv $2.tsv | head -20; fi
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658; M=$C/libc/musl
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
mflags=(-std=gnu99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
t=$(mktemp -d /dev/shm/md-3586.XXXXXX)
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\n#include <math.h>\nint main(void) { return 0; }\n' > $t/six.c
one() {  # NAME SOURCE ARGS...
    local n=$1 src=$2; shift 2
    for b in $B $H; do
        # Both builds write the same paths, which the rule names, then the files are set aside by the build's name.
        rm -f $t/out.o $t/out.d
        (cd $t && "$d/bin/compiler-$b" "$@" -MD -MF $t/out.d -c "$src" -o $t/out.o > $t/$b.err 2>&1; echo $? > $t/$b.st)
        mv -f $t/out.d $t/$b.d 2>/dev/null; mv -f $t/out.o $t/$b.o 2>/dev/null
        [ -f $t/$b.o ] && readelf -p .comment $t/$b.o 2>/dev/null | grep -q 'buster direct' && echo direct > $t/$b.path || echo full > $t/$b.path
    done
    if cmp -s $t/$B.d $t/$H.d && cmp -s $t/$B.o $t/$H.o && cmp -s $t/$B.st $t/$H.st && cmp -s $t/$B.err $t/$H.err; then same=$((same+1)); [ "$(cat $t/$H.path)" = direct ] && direct=$((direct+1)); else echo "MD DIFFERS: $n"; fi
    rm -f $t/$B.* $t/$H.*
}
B=$1; H=$2; same=0; direct=0
one sqlite $C/sqlite/sqlite3.c "${base[@]}" "${sys[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite
one six $t/six.c "${base[@]}" "${sys[@]}"
for f in "$M"/src/*/*.c; do one "$f" "$f" "${mflags[@]}"; done
echo "-MD: $same units the same ($direct by the direct path)"
rm -rf $t
