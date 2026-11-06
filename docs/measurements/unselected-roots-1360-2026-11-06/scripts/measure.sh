#!/bin/bash
# #1360/#1341 A/B on the 9700X: base 866e087a against head, CPU 2, one lock hold per round, variants alternating.
set -u
cd ~/buster-fast-bench/1360-opencode || exit 2
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
export EXCLUSIVE_OWNER=opencode-1360 EXCLUSIVE_TITLE="opencode #1360/#1341 unselected roots A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
unset CPATH C_INCLUDE_PATH
BASE=$PWD/$(ls -d base-* | head -1)
HEAD=$PWD/$(ls -d head-* | head -1)
SQ=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c
ROUNDS=${ROUNDS:-7}
mkdir -p inputs out
sha256sum "$SQ" > inputs/sqlite3.c.sha256
{ uname -a; clang --version | head -1; perf --version; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference;
  grep -m1 'model name' /proc/cpuinfo; for d in "$BASE" "$HEAD"; do echo "$d $(cat "$d/COMMIT")"; sha256sum "$d/build/compiler"; done; } > host.txt 2>&1
for n in 1000 2000 4000 8000; do
    [[ -f inputs/asserts-$n.c ]] || { echo '#include <assert.h>'; echo 'int g(int x) {'; for ((i = 0; i < n; i++)); do echo "assert(x != $i);"; done; echo 'return x; }'; } > inputs/asserts-$n.c
    [[ -f inputs/generic-$n.c ]] || for ((i = 0; i < n; i++)); do echo "int f$i(int x) { int y = _Generic(x, int: x + 1, long: x - 1, default: 0); return y * 2 + x; }"; done > inputs/generic-$n.c
done
if [[ ! -d inputs/lua-5.4.8 ]]; then
    mkdir -p inputs/lua-5.4.8 && cp -r ~/buster-fast-bench/1109-claude/inputs/lua-5.4.8/src inputs/lua-5.4.8/ || exit 2
fi
(cd inputs && sha256sum lua-5.4.8/src/* > lua-5.4.8.sha256)
if [[ ! -f inputs/self-main.i ]]; then
    clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > inputs/predefines-znver5.h
    (cd "$BASE" && ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler -E -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing \
        --predefines ../inputs/predefines-znver5.h -o ../inputs/self-main.i src/buster/compiler/main.c) || exit 2
    echo "$(cat "$BASE/COMMIT") base -E of src/buster/compiler/main.c" > inputs/self-main.i.source
fi
SQOPTS="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
SELFOPTS="-fsyntax-only --predefines $PWD/inputs/predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing"
# workload name, then its arguments (the input last); "-o OBJECT" is added for -c.
workloads=(
    "sq-ci|$SQOPTS $SQ"
    "sq-ci-w|$SQOPTS -w $SQ"
    "sq-debug|$SQOPTS -DSQLITE_DEBUG $SQ"
    "sq-debug-w|$SQOPTS -DSQLITE_DEBUG -w $SQ"
    "self|$SELFOPTS $PWD/inputs/self-main.i"
    "asserts-1000|-c $PWD/inputs/asserts-1000.c"
    "asserts-2000|-c $PWD/inputs/asserts-2000.c"
    "asserts-4000|-c $PWD/inputs/asserts-4000.c"
    "asserts-8000|-c $PWD/inputs/asserts-8000.c"
    "generic-1000|-fsyntax-only $PWD/inputs/generic-1000.c"
    "generic-2000|-fsyntax-only $PWD/inputs/generic-2000.c"
    "generic-4000|-fsyntax-only $PWD/inputs/generic-4000.c"
    "generic-8000|-fsyntax-only $PWD/inputs/generic-8000.c"
    "lua|"
    "lua-w|-w"
    "lua-assert|-DLUAI_ASSERT"
    "lua-assert-w|-DLUAI_ASSERT -w"
)
cat > round.sh <<'ROUND'
#!/bin/bash
# One round inside the hold: every workload by both builds, the order alternating by round and workload.
set -u
round=$1; shift
BASE=$1 HEAD=$2; shift 2
printf 'round %s: %s\n' "$round" "$(head -1 /var/lib/buster-9700x/owner)" >> holds.txt
k=0
for entry in "$@"; do
    name=${entry%%|*}; args=${entry#*|}
    order="base head"; (( (round + k) % 2 )) && order="head base"
    k=$((k + 1))
    for v in $order; do
        [[ $name == sq-debug && $v == base && $round -gt 3 ]] && continue
        X=$BASE/build/compiler; [[ $v == head ]] && X=$HEAD/build/compiler
        obj=out/$name-$v.o
        start=$EPOCHREALTIME
        if [[ $name == lua* ]]; then
            perf stat -x, -e instructions:u,cycles:u -o out/$name-$v.perf taskset -c 2 ./lua-all.sh "$X" $args > out/$name-$v.stdout 2> out/$name-$v.stderr
        else
            perf stat -x, -e instructions:u,cycles:u -o out/$name-$v.perf taskset -c 2 "$X" $args -o "$obj" --time-stages > out/$name-$v.stdout 2> out/$name-$v.stderr
        fi
        status=$?
        end=$EPOCHREALTIME
        counters=$(awk -F, '$3=="instructions:u"{i=$1} $3=="cycles:u"{c=$1} END{printf "%s\t%s", i, c}' out/$name-$v.perf)
        wall=$(awk -v s=$start -v e=$end 'BEGIN{printf "%.1f", (e - s) * 1000}')
        stages=$(awk '$1=="time-stage"&&$2=="total"{t=$3} $1=="time-stage"&&$2=="check-program"{c=$3} END{printf "%s\t%s", t, c}' out/$name-$v.stderr)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$round" "$name" "$v" "$status" "$wall" "$stages" "$counters"
        if [[ $round == 1 ]]; then
            cp out/$name-$v.stderr out/first-$name-$v.stderr
            [[ -f $obj ]] && cp "$obj" out/first-$name-$v.o
        fi
    done
done
ROUND
chmod +x round.sh
[[ -f results.tsv ]] || printf 'round\tworkload\tvariant\tstatus\twall_ms\ttotal_ms\tcheck_program_ms\tinstructions_u\tcycles_u\n' > results.tsv
for ((r = 1; r <= ROUNDS; r++)); do
    if grep -q "^$r	" results.tsv; then continue; fi
    ~/buster-fast-bench/exclusive.sh ./round.sh "$r" "$BASE" "$HEAD" "${workloads[@]}" > round-$r.tsv 2> round-$r.err || echo "round $r failed" >&2
    cat round-$r.tsv >> results.tsv
    sleep 20
done
echo "done" > measure.done
