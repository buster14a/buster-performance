#!/bin/bash
# The record's run (#1057): the preparation cost of buster14a/buster#1141, which made the C driver and the real-source
# benchmarks share one request's configuration (c_check_request.c) and one source preparation (c_check_source_prepare.c).
# Builds main before it (754475d4, the merge's first parent) and the merge (4670b2eb), each in a hold of the 9700X's
# lock, then in one more hold measures them interleaved (time-runs, whole processes in a rotating order, one warm-up,
# CPU 2): a tiny file by -c and by -fsyntax-only, a small real file (tools/ci/changes.c) by -c, the frozen corpus's
# sqlite3.c by -c and by -fsyntax-only, and the source benchmarks whose preparation the merge shares
# (benchmark-backend-source and benchmark-lowering-source over sqlite3.c). Every object -c writes is compared
# byte for byte between the builds. Logs into $R/logs; writes $R/logs/done at its end.
#
# The trees are `git archive` of each commit, sent to the host by tar into $R/trees/tree-XXXXXXXX before this runs;
# trees/manifest-XXXXXXXX.txt are their sha256sums made before sending, which the host's must equal.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1057-claude/record
MAIN=754475d4cc8f27813cf0b2f029fbae0012ab11fe
HEAD=4670b2ebf5ca104feb5c902015ad6a2179d8c2e7
L=$R/logs; mkdir -p "$L" "$R/out" "$R/trees" "$R/inputs"
lock() { EXCLUSIVE_OWNER=claude-1057 EXCLUSIVE_TITLE="#1057 preparation cost record" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1057 ~/buster-fast-bench/exclusive.sh "$@"; }
# The frozen corpus, where the host keeps it.
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
[ -d "$C" ] || C=$HOME/buster-fast-bench/corpus-391e729af658
echo "corpus $C" >> "$L/receipts.txt"
for commit in $MAIN $HEAD; do
    t=$R/trees/tree-${commit:0:8}
    (cd "$t" && find . -type f ! -name COMMIT ! -path './build/*' -print0 | sort -z | xargs -0 sha256sum > "$L/host-manifest-${commit:0:8}.txt")
    cmp -s "$L/host-manifest-${commit:0:8}.txt" "$R/trees/manifest-${commit:0:8}.txt" && m=matches || m=DIFFERS
    echo "tree-${commit:0:8}: $(cat "$t/COMMIT"), $(wc -l < "$L/host-manifest-${commit:0:8}.txt") files, manifest $m" >> "$L/receipts.txt"
    (cd "$t" && lock env BUSTER_DEBUG_INFO=0 ./build.sh > "$L/build-${commit:0:8}.log" 2>&1; echo "tree-${commit:0:8} build status $?" >> "$L/receipts.txt")
done
cat > "$L/measure.sh" <<INNER
#!/bin/bash
set -u
main=$R/trees/tree-${MAIN:0:8}/build/compiler; head=$R/trees/tree-${HEAD:0:8}/build/compiler
C=$C
{ date -u; uname -a; clang --version | head -1; cat /sys/kernel/mm/transparent_hugepage/enabled
  for c in 0 1 2 3 4 5 6 7; do echo "cpu\$c \$(cat /sys/devices/system/cpu/cpu\$c/cpufreq/scaling_governor) \$(cat /sys/devices/system/cpu/cpu\$c/cpufreq/energy_performance_preference)"; done
  sha256sum \$main \$head; sha256sum \$C/sqlite/sqlite3.c; } >> $L/receipts.txt
# The tiny file: no header, one function.
printf 'int main(void)\n{\n    return 0;\n}\n' > $R/inputs/tiny.c
cp $R/trees/tree-${MAIN:0:8}/tools/ci/changes.c $R/inputs/changes.c
sha256sum $R/inputs/tiny.c $R/inputs/changes.c >> $L/receipts.txt
runs() { local name=\$1; shift; taskset -c 2 \$main time-runs --warmups 1 --build main \$main --build head \$head "\$@" > $L/\$name.log 2>&1; echo "\$name time-runs status \$?" >> $L/receipts.txt; }
# A tiny file and a small real one: the driver's per-command work, which #1141 moved into check_request_scan and
# check_request_refusal (the same comparisons per argument) and check_request_program_options.
runs tiny --runs 41 --list -c -o $R/out/tiny-run.o $R/inputs/tiny.c --list -fsyntax-only $R/inputs/tiny.c
runs changes --runs 21 --list -c -o $R/out/changes-run.o $R/inputs/changes.c
# The representative corpus: the frozen sqlite3.c with its pinned predefines and headers, as the 9700X workflow passes them.
sqlite=(--predefines \$C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem \$C/headers/usr/lib/clang/23/include -isystem \$C/headers/usr/local/include -isystem \$C/headers/usr/include \$C/sqlite/sqlite3.c)
runs sqlite --runs 11 --list -c -o $R/out/sqlite-run.o "\${sqlite[@]}" --list -fsyntax-only "\${sqlite[@]}"
# The source benchmarks that share the preparation, as whole processes (their preparation is outside their own timed
# regions, which they print): benchmark-backend-source and benchmark-lowering-source over sqlite3.c.
bench=(--predefines \$C/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem \$C/headers/usr/lib/clang/23/include -isystem \$C/headers/usr/local/include -isystem \$C/headers/usr/include \$C/sqlite/sqlite3.c)
runs backend-source --runs 5 --list benchmark-backend-source "\${bench[@]}"
runs lowering-source --runs 5 --list benchmark-lowering-source "\${bench[@]}"
# The objects, byte for byte: each build's -c of each file.
for b in main head; do exe=\$main; [ \$b = head ] && exe=\$head
    taskset -c 2 \$exe -c -o $R/out/tiny-\$b.o $R/inputs/tiny.c; echo "tiny -c \$b status \$?" >> $L/receipts.txt
    taskset -c 2 \$exe -c -o $R/out/changes-\$b.o $R/inputs/changes.c; echo "changes -c \$b status \$?" >> $L/receipts.txt
    taskset -c 2 \$exe -c -o $R/out/sqlite-\$b.o "\${sqlite[@]}"; echo "sqlite -c \$b status \$?" >> $L/receipts.txt
done
for f in tiny changes sqlite; do cmp $R/out/\$f-main.o $R/out/\$f-head.o && echo "\$f objects identical" >> $L/receipts.txt || echo "\$f OBJECTS DIFFER" >> $L/receipts.txt; done
sha256sum $R/out/*-main.o $R/out/*-head.o >> $L/receipts.txt
INNER
chmod +x "$L/measure.sh"
lock "$L/measure.sh" > "$L/measure-hold.log" 2>&1; echo "measure hold status $?" >> "$L/receipts.txt"
touch "$L/done"
