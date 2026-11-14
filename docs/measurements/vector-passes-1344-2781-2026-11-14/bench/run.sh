#!/usr/bin/env bash
# buster#1344 census on the 9700X: c_tokenize of the compiler's vector lexer by Tier 1's pass variants (the default,
# LICM and value numbering unrestricted, and restricted to vector and mask values by the prototype's
# BUSTER_PROTO_VECTORS), by clang -O2 and by GCC -O2 with 32, 16, 15 and 8 vector registers.
# Every build and run takes the 9700X's lock for itself; the rounds are interleaved and pinned to CPU 2.
set -u
D=$HOME/buster-fast-bench/1344-droid
B=$D/buster
hold() { EXCLUSIVE_OWNER=droid-1344 EXCLUSIVE_TITLE="Issue 1344: Tier 1 vector lexer census" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1344 $HOME/buster-fast-bench/exclusive.sh "$@"; }
step() { echo "$(date -u +%FT%TZ) $*"; }
cd $D || exit 1
if [ "${1:-all}" = all ]; then
    step "clone"
    [ -d $B/.git ] || git clone -q --depth 1 --branch droid/vector-passes-1344 https://github.com/buster14a/buster $B || exit 1
    git -C $B rev-parse HEAD > $D/commit.txt
    { uname -r; grep -m1 'model name' /proc/cpuinfo; clang --version | head -1; gcc --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; } > $D/host.txt 2>&1
    step "build"
    (cd $B && hold timeout -k 5 1200 ./build.sh --config Release) > $D/build.log 2>&1 || { step "build failed"; tail -5 $D/build.log; exit 1; }
    step "variants"
    hold timeout -k 5 900 $D/run.sh variants > $D/variants.log 2>&1 || { step "variants failed"; tail -5 $D/variants.log; exit 1; }
    step "rounds"
    hold timeout -k 5 600 $D/run.sh rounds > $D/rounds.log 2>&1 || { step "rounds failed"; tail -5 $D/rounds.log; exit 1; }
    step "done"
    exit 0
fi
FLAGS="-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing"
if [ "$1" = variants ]; then
    cd $B || exit 1
    clang -O2 -c -o $D/lexer-main.o $D/lexer-main.c || exit 1
    clang -O2 $FLAGS -c -o $D/lexer-clang2.o src/buster/compiler/c_lexer_benchmark.c || exit 1
    hi=""; for r in $(seq 16 31); do hi="$hi -ffixed-xmm$r"; done
    mid=""; for r in $(seq 8 15); do mid="$mid -ffixed-xmm$r"; done
    gcc -O2 $FLAGS -c -o $D/lexer-gcc32.o src/buster/compiler/c_lexer_benchmark.c 2> $D/gcc32.err || exit 1
    gcc -O2 $FLAGS $hi -c -o $D/lexer-gcc16.o src/buster/compiler/c_lexer_benchmark.c 2> $D/gcc16.err || exit 1
    gcc -O2 $FLAGS $hi -ffixed-xmm15 -c -o $D/lexer-gcc15.o src/buster/compiler/c_lexer_benchmark.c 2> $D/gcc15.err || exit 1
    gcc -O2 $FLAGS $hi $mid -c -o $D/lexer-gcc8.o src/buster/compiler/c_lexer_benchmark.c 2> $D/gcc8.err || exit 1
    tier1() { # name passes environment
        local opt=""; [ "$2" != default ] && opt="--tier1-passes=$2"
        env $3 perf stat -x, -e cycles:u,instructions:u -o $D/lexer-$1.compile taskset -c 2 ./build/compiler --lanes 1 --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS $opt -c -o $D/lexer-$1.o src/buster/compiler/c_lexer_benchmark.c > $D/lexer-$1.report 2>&1 || { echo "$1: compile failed"; tail -3 $D/lexer-$1.report; return 1; }
    }
    tier1 default default X=1 || exit 1
    tier1 licm +licm X=1 || exit 1
    tier1 gvn +gvn X=1 || exit 1
    tier1 licm-gvn +licm,+gvn X=1 || exit 1
    tier1 vlicm +licm BUSTER_PROTO_VECTORS=1 || exit 1
    tier1 vgvn +gvn BUSTER_PROTO_VECTORS=1 || exit 1
    tier1 vlicm-vgvn +licm,+gvn BUSTER_PROTO_VECTORS=1 || exit 1
    for n in clang2 gcc32 gcc16 gcc15 gcc8 default licm gvn licm-gvn vlicm vgvn vlicm-vgvn; do
        clang -o $D/lexer-$n $D/lexer-main.o $D/lexer-$n.o || exit 1
    done
    sha256sum $D/lexer-*.o > $D/objects.sha256
    for n in default licm gvn licm-gvn vlicm vgvn vlicm-vgvn; do
        echo "$n: compile $(cut -d, -f1,3 $D/lexer-$n.compile | grep -v '^#' | tr '\n' ' ') $(tr '\t' '\n' < $D/lexer-$n.report | grep -E '^(records|spill_stores|spill_loads|rematerializations|edge_moves|licm_moved|gvn_removed)=' | tr '\n' ' ')"
    done
    exit 0
fi
if [ "$1" = rounds ]; then
    OUT=$D/rounds.tsv
    { echo "before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; }
    printf 'round\tbuild\tcycles_per_byte\tinstructions_per_byte\tstatus\n' > $OUT
    for r in $(seq 1 ${ROUNDS:-15}); do
        for n in clang2 gcc32 gcc16 gcc15 gcc8 default licm gvn licm-gvn vlicm vgvn vlicm-vgvn; do
            l=$(taskset -c 2 $D/lexer-$n $D/mid200.c 2>&1); s=$?
            set -- $(echo "$l" | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g')
            printf '%s\t%s\t%s\t%s\t%s\n' $r $n $6 $9 $s >> $OUT
        done
    done
    { echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; }
    python3 - $OUT <<'PY'
import sys, collections, statistics
rows = collections.defaultdict(list); ins = {}; bad = collections.Counter()
for line in open(sys.argv[1]).read().splitlines()[1:]:
    r, b, c, i, s = line.split("\t"); rows[b].append(float(c)); ins[b] = i; bad[b] += s != "0"
print(f"{'build':14s} {'min':>7s} {'median':>7s} {'max':>7s} {'instr/B':>8s} failed")
for b, v in rows.items():
    print(f"{b:14s} {min(v):7.3f} {statistics.median(v):7.3f} {max(v):7.3f} {ins[b]:>8s} {bad[b]}")
PY
    exit 0
fi
