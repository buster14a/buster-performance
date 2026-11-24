#!/bin/bash
# An A/B of a revision of buster and the same revision with a patch on the 9700X: both built here as the job builds,
# then sqlite3.c's --lanes 1 -c compile with the default warnings and with -w, base and head interleaved in three
# rounds (forward, reverse, forward) of 11 runs each. One hold. Usage: ab-patch.sh NAME BASE_REF PATCH_FILE
set -u
name=$1; base=$2; patch=$(realpath "$3")
cd ~/buster-fast-bench/2850-claude-vjgaob/buster
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=$HOME/buster-fast-bench/2850-claude-vjgaob/results/ab-$name
rm -rf "$out"; mkdir -p "$out"
{ date -u; cat /proc/loadavg; } > "$out/before.txt"
git checkout -q -- . && git fetch -q origin "$base" && base_sha=$(git rev-parse FETCH_HEAD) || { echo "fetch failed" > "$out/failed"; exit 1; }
echo "base=$base_sha head=base+$(sha256sum "$patch" | cut -c1-16) ($(basename "$patch"))" > "$out/revisions.txt"; cp "$patch" "$out/"
build() {
    git checkout -q -- . && git checkout -q --detach "$base_sha" || return 1
    if [ "$1" = head ]; then git apply "$patch" || return 1; fi
    local start; start=$(date +%s)
    BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/build-$1.log" 2>&1 || return 1
    echo "seconds=$(( $(date +%s) - start ))" >> "$out/build-$1.log"
    cp "$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-output --config Release 2>/dev/null)" "$out/compiler-$1" && chmod +x "$out/compiler-$1" && "$out/compiler-$1" --version > /dev/null 2>&1
}
build base "$base_sha" || { echo "base build failed" > "$out/failed"; exit 1; }
build head patched || { echo "head build failed" > "$out/failed"; exit 1; }
git checkout -q -- .
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
cd "$out"
E=cycles:u,instructions:u,task-clock,L1-dcache-load-misses:u,cache-misses:u,branch-misses:u
variants=(base head base-w head-w)
for v in "${variants[@]}"; do
    extra=(); [[ $v == *-w ]] && extra=(-w)
    taskset -c 2 "./compiler-${v%-w}" "${extra[@]}" "${O[@]}" -o "$v.o" 2> "$v.err"; echo "status=$?" >> "$v.err"
done
cmp -s base.o head.o && echo "default objects identical" > identity.txt || echo "DEFAULT OBJECTS DIFFER" > identity.txt
cmp -s base-w.o head-w.o && echo "-w objects identical" >> identity.txt || echo "-w OBJECTS DIFFER" >> identity.txt
cmp -s base.err head.err && echo "default diagnostics identical ($(grep -vc '^status=' base.err) lines)" >> identity.txt || echo "DEFAULT DIAGNOSTICS DIFFER" >> identity.txt
run() {
    local v=$1 round=$2 extra=()
    [[ $v == *-w ]] && extra=(-w)
    taskset -c 2 perf stat -x, -e $E -r 11 -o "stat-$v-$round.csv" -- "./compiler-${v%-w}" "${extra[@]}" "${O[@]}" -o x.o > /dev/null 2> "err-$v-$round.txt"
    echo "status=$?" >> "err-$v-$round.txt"
    cmp -s x.o "$v.o" || echo "$v round $round: object differs" >> differs.txt
}
for i in 0 1 2 3; do run "${variants[$i]}" 1; done
for i in 3 2 1 0; do run "${variants[$i]}" 2; done
for i in 0 1 2 3; do run "${variants[$i]}" 3; done
rm -f x.o
{ date -u; cat /proc/loadavg; } > after.txt
echo done > complete
