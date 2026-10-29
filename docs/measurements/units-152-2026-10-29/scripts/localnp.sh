#!/bin/bash
export CORES_TITLE="solve #152 multi-file driver (peak instruction cost)" CORES_LINK="https://github.com/buster14a/buster/issues/152"
L=~/.cache/claude-152/localnp
mkdir -p $L
for v in main np; do
    T=~/.cache/claude-152/tree-$v
    (cd $T && nice -n 19 cores -n 4 -- ./build.sh > $L/build-$v.log 2>&1; echo "build exit=$?" >> $L/build-$v.log)
done
SQ=~/.cache/claude-152/inputs/sqlite3.c
cores -n 1 -- bash -c "for r in 1 2 3; do for v in main p1 np; do for w in syntax c; do C=~/.cache/claude-152/tree-\$v/build/compiler; if [ \$w = c ]; then a='-c -o /dev/null'; else a='-fsyntax-only'; fi; perf stat -x, -e instructions:u -o $L/stat.csv \$C --lanes 1 \$a $SQ > /dev/null 2>&1; echo \"r\$r \$v \$w \$(grep instructions $L/stat.csv | cut -d, -f1)\"; done; done; done" > $L/instructions.log 2>&1
echo all-done >> $L/instructions.log
