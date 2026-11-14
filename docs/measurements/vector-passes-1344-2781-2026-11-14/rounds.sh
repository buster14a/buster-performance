#!/bin/sh
# Interleaved rounds of the lexer programs on one CPU of a granted core: cycles/B and instructions/B of c_tokenize.
set -u
W=/home/david/.cache/droid-vector-census
D=$(ls -d $W/rows/measure-tier1-rows-*)
CPU=$(grep Cpus_allowed_list /proc/self/status | cut -f2 | cut -d, -f1 | cut -d- -f1)
ROUNDS=${ROUNDS:-9}
OUT=$W/rounds-$(date +%H%M%S).tsv
echo "cpu $CPU, rounds $ROUNDS, output $OUT"
printf 'round\tbuild\tcycles_per_byte\tinstructions_per_byte\tstatus\n' > $OUT
for r in $(seq 1 $ROUNDS); do
  for b in $D/lexer-clang2 $W/gcc/lexer-gcc32 $W/gcc/lexer-gcc16 $W/gcc/lexer-gcc15 $W/gcc/lexer-gcc8 $W/proto/lexer-default $W/proto/lexer-licm $W/proto/lexer-gvn $W/proto/lexer-licm-gvn $W/proto/lexer-vlicm $W/proto/lexer-vgvn $W/proto/lexer-vlicm-vgvn; do
    l=$(taskset -c $CPU $b $W/mid200.c 2>&1); s=$?
    set -- $(echo "$l" | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g')
    printf '%s\t%s\t%s\t%s\t%s\n' $r $(basename $b) $6 ${10} $s >> $OUT
  done
done
python3 - $OUT <<'PY'
import sys, collections, statistics
rows = collections.defaultdict(list); ins = {}; bad = collections.Counter()
for line in open(sys.argv[1]).read().splitlines()[1:]:
    r, b, c, i, s = line.split("\t"); rows[b].append(float(c)); ins[b] = i; bad[b] += s != "0"
print(f"{'build':22s} {'min':>7s} {'median':>7s} {'max':>7s} {'instr/B':>8s} failed")
for b, v in rows.items():
    print(f"{b:22s} {min(v):7.3f} {statistics.median(v):7.3f} {max(v):7.3f} {ins[b]:>8s} {bad[b]}")
PY
