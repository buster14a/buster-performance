#!/usr/bin/env bash
# 2784: balance_nonroot's cycles by instruction, base against the slot stamps alone, shift 0: one perf record of ten
# runs each, pinned to CPU 2; one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2784-claude
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/prof3 && cd $W/prof3 || exit 1
for t in base nohints; do
    cat > run-$t.sh <<RUN
#!/usr/bin/env bash
for k in 1 2 3 4 5 6 7 8 9 10; do
    d=\$(mktemp -d /dev/shm/st2784.XXXXXX) && mkdir \$d/db \$d/tmp
    (cd \$d/db && SQLITE_TMPDIR=\$d/tmp $W/exe/st-$t-s0 $STOPTS speedtest1.db > /dev/null 2>&1)
    rm -rf \$d
done
RUN
    chmod +x run-$t.sh
    taskset -c 2 perf record -q -F 25000 -e cycles:u -o $t.data ./run-$t.sh > /dev/null 2>&1
    perf annotate -q -i $t.data --stdio -s balance_nonroot 2>/dev/null > $t-balance.txt
    perf annotate -q -i $t.data --stdio -s sqlite3VdbeExec 2>/dev/null | awk '$1+0 >= 0.3' > $t-vdbe.txt
done
