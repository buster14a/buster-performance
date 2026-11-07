#!/bin/bash
# chain3.sh: after round3's builds, the per-process A/B of -c sqlite3.c (the compile_time step's options), with and
# without -w, then each tree's objects by default, --scalar, --lanes 8 and -g, each compile under its own grant.
cd ~/buster-fast-bench/628-claude-tesla
while ! grep -q round3-built round3.log; do sleep 15; done
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main branch ab3 7 -- "${options[@]}" > ab3.log 2>&1
./ab-grants.sh main branch ab3w 7 -- "${options[@]}" -w > ab3w.log 2>&1
mkdir -p objects3
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main branch; do
    for mode in default scalar lanes g; do
        case $mode in default) extra=();; scalar) extra=(--scalar);; lanes) extra=(--lanes 8);; g) extra=(-g);; esac
        pin=(taskset -c 2); [ $mode = lanes ] && pin=()
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects3/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects3/$tree-$mode.o" > "objects3/$tree-$mode.lock" 2> "objects3/$tree-$mode.err"
    done
done
for mode in default scalar lanes g; do
    cmp objects3/main-$mode.o objects3/branch-$mode.o && echo "same object $mode"
done > objects3.log 2>&1
sha256sum objects3/*.o >> objects3.log
echo chain3-done >> objects3.log
