#!/bin/bash
# Per-symbol user cycles of base and head on sqlite3.c -c --lanes 1, 15 compiles each, CPU 2, under the lock.
cd ~/buster-fast-bench/2924-program/tails
export EXCLUSIVE_OWNER=claude-2924-c12c4 EXCLUSIVE_TITLE="buster #2924: phase D, the checker tails (#3448)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3448
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$corpus" "$corpus/sqlite3.c")
mkdir -p perf
cat > perf/loop.sh <<'L'
#!/bin/bash
exe=$1; shift
for i in $(seq 1 15); do "$exe" -c --lanes 1 "$@" -o /dev/shm/claude-tails-perf.o > /dev/null 2>&1; done
L
chmod +x perf/loop.sh
~/buster-fast-bench/exclusive.sh bash -c "
for t in base head; do taskset -c 2 perf record -q -F 25000 -e cycles:u -o perf/\$t.data -- perf/loop.sh compilers/\$t ${S[*]} ; done" > perf/record.log 2>&1
for t in base head; do perf report -q -i perf/$t.data --no-children --sort sym --percent-limit 0.05 2>/dev/null | head -80 > perf/$t.txt; done
echo done > perf/status
