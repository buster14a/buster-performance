#!/bin/bash
# EXPERIMENT ONLY (#2924 C12c's gate), in the container: the knob executable with each bit alone against no bit, on
# c-testsuite's single-exec programs (-c, -c --tier1) and buster's main.c (-c --lanes 1): any crash or object that
# differs is a site the rewrite got wrong or two areas that must merge.
set -u
T=/root/.cache/claude-c7/c12c/tree
O=/tmp/claude-0/-home-user/a5cf9d3c-54b3-5f35-a2b2-f7ae4ba74bd8/scratchpad/c12c-local
rm -rf $O; mkdir -p $O/bin
BITS=${BITS:-"0 2 3 4 5 6 7 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28"}
for b in $BITS; do
    mask=$(( b == 0 ? 0 : 1 << b ))
    cp $T/build/compiler $O/bin/compiler-areas$mask
done
for b in $BITS; do
    mask=$(( b == 0 ? 0 : 1 << b ))
    exe=$O/bin/compiler-areas$mask
    for mode in t0 t1; do
        dir=$O/obj/$b/$mode; mkdir -p $dir
        opt=(); [ $mode = t1 ] && opt=(--tier1)
        fails=0
        for c in /root/.cache/c-testsuite/tests/single-exec/*.c; do
            n=$(basename $c .c)
            (cd $dir && timeout 60 "$exe" -c "${opt[@]}" "$c" -o $n.o > /dev/null 2> $n.err); s=$?
            [ $s -ge 124 ] && { fails=$((fails+1)); echo "bit $b $mode $n: exit $s" >> $O/crashes.txt; }
            echo "$n $s" >> $dir/../$mode.status
        done
    done
    mkdir -p $O/obj/$b/main
    (cd $O/obj/$b/main && timeout 600 "$exe" -c --lanes 1 -march=znver5 -I$T/src -fwrapv -funsigned-char -fno-strict-aliasing $T/src/buster/compiler/main.c -o main.o > /dev/null 2> main.err); s=$?
    echo "bit $b main: exit $s" >> $O/status.txt
done
for b in $BITS; do
    [ $b = 0 ] && continue
    d=0; n=0
    for mode in t0 t1 main; do
        for f in $O/obj/0/$mode/*.o; do
            n=$((n+1))
            g=$O/obj/$b/$mode/$(basename $f)
            cmp -s $f $g || { d=$((d+1)); echo "bit $b differs: $mode $(basename $f)" >> $O/differs.txt; }
        done
    done
    cmp -s $O/obj/0/t0.status $O/obj/$b/t0.status && cmp -s $O/obj/0/t1.status $O/obj/$b/t1.status || echo "bit $b: exit statuses differ" >> $O/status.txt
    echo "bit $b: $n compared, $d differ" >> $O/status.txt
done
echo done >> $O/status.txt
