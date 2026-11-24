#!/bin/bash
# The page policy's checks on the 9700X, which is no virtual machine (one hold of the lock): the lane tests, the deferred
# reader's page test, the driver test's part with the policy's cases, and a compile with the busy test and the knob's
# reading forced, whose object must be the idle compile's.
# smoke12.sh TREE PART
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
tree=${1:?tree}; part=${2:?part}
out=$dir/results/pages-smoke
mkdir -p "$out"
cd "$dir/$tree"
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the arenas' 64 KB pages, tests"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
cat > "$out/hold.sh" <<'EOS'
#!/bin/bash
out=$1; part=$2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./build/compiler test-lanes > "$out/test-lanes.txt" 2>&1; echo "test-lanes $?" > "$out/status.txt"
./build/compiler test-checker-deferred > "$out/test-checker-deferred.txt" 2>&1; echo "test-checker-deferred $?" >> "$out/status.txt"
./build/compiler test-checker-driver --executable ./build/compiler --part "$part" > "$out/test-checker-driver.txt" 2>&1; echo "test-checker-driver --part $part $?" >> "$out/status.txt"
for mode in idle busy medium; do
    case $mode in idle) b=0; m=0 ;; busy) b=1; m=0 ;; medium) b=1; m=1 ;; esac
    BUSTER_TEST_HOST_BUSY=$b BUSTER_TEST_MEDIUM_PAGES=$m ./build/compiler --time-stages --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/$mode.o" > "$out/$mode.report" 2> "$out/$mode.err"
    echo "compile $mode $? $(grep -h 'huge-pages' "$out/$mode.report" "$out/$mode.err" | tr '\t' ' ')" >> "$out/status.txt"
done
sha256sum "$out"/*.o | awk '{print $1}' | sort | uniq -c > "$out/objects.txt"
EOS
chmod +x "$out/hold.sh"
~/buster-fast-bench/exclusive.sh "$out/hold.sh" "$out" "$part" 2> "$out/lock.err"
cat "$out/status.txt" "$out/objects.txt"
echo SMOKE-DONE
