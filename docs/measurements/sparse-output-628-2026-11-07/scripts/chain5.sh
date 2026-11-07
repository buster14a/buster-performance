#!/bin/bash
# chain5.sh: after chain3, the reader's sparse output in base pages (commit dd32e723 on main faef1f98): builds
# main2/ (faef1f98) and sparse/ under a hold each, the per-process A/B of -c sqlite3.c (the compile_time step's options),
# then each tree's objects by default, --scalar, --lanes 8, the deferred reader on 8 lanes, and -g, each compile under
# its own grant.
cd ~/buster-fast-bench/628-claude-tesla
while ! grep -q chain3-done objects3.log 2>/dev/null; do sleep 15; done
[ -d main2 ] || git clone -q main main2
git -C main2 fetch -q https://github.com/buster14a/buster main && git -C main2 checkout -q faef1f98
git -C sparse fetch -q ../sparse2.bundle local/sparse-rebase:local/sparse-rebase && git -C sparse checkout -q local/sparse-rebase
git -C main2 log -1 --format='main2 %H'; git -C sparse log -1 --format='sparse %H'
./build.sh main2
./build.sh sparse
echo chain5-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main2 sparse ab5 7 -- "${options[@]}" > ab5.log 2>&1
mkdir -p objects4b
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main2 sparse; do
    for mode in default scalar lanes deferred g; do
        case $mode in default) extra=();; scalar) extra=(--scalar);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        pin=(taskset -c 2); [ $mode = lanes ] || [ $mode = deferred ] && pin=()
        [ $mode = default ] || [ $mode = scalar ] || [ $mode = g ] && pin=(taskset -c 2)
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects4b/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects4b/$tree-$mode.o" > "objects4b/$tree-$mode.lock" 2> "objects4b/$tree-$mode.err"
    done
done
for mode in default scalar lanes deferred g; do
    cmp objects4b/main2-$mode.o objects4b/sparse-$mode.o && echo "same object $mode"
done > objects4b.log 2>&1
sha256sum objects4b/*.o >> objects4b.log
cat objects4b/*.status | tr '\n' ' ' >> objects4b.log
echo >> objects4b.log
echo chain5-done >> objects4b.log
