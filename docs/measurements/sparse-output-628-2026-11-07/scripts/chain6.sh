#!/bin/bash
# chain6.sh: the reader's sparse output in base pages, commit dd32e723 on main faef1f98 (main2/, built by chain5): builds
# sparse/ under a hold, then the per-process A/B of -c sqlite3.c (the compile_time step's options), then each tree's
# objects by default, --scalar, --lanes 8, the deferred reader on 8 lanes, and -g, each compile under its own grant,
# then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main2 log -1 --format='main2 %H'; git -C sparse log -1 --format='sparse %H'
[ "$(git -C main2 rev-parse HEAD)" = faef1f98d2f8a59fea2d1a091813cb3b9191d2e3 ] || { echo "main2 is not faef1f98"; exit 1; }
[ "$(git -C sparse rev-parse HEAD | cut -c1-8)" = dd32e723 ] || { echo "sparse is not dd32e723"; exit 1; }
./build.sh sparse
echo chain6-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main2 sparse ab6 7 -- "${options[@]}" > ab6.log 2>&1
mkdir -p objects6
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main2 sparse; do
    for mode in default scalar lanes deferred g; do
        case $mode in default) extra=();; scalar) extra=(--scalar);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects6/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects6/$tree-$mode.o" > "objects6/$tree-$mode.lock" 2> "objects6/$tree-$mode.err"
    done
done
for mode in default scalar lanes deferred g; do
    cmp objects6/main2-$mode.o objects6/sparse-$mode.o && echo "same object $mode"
done > objects6.log 2>&1
sha256sum objects6/*.o >> objects6.log
cat objects6/*.status | tr '\n' ' ' >> objects6.log
echo >> objects6.log
./receipts.sh main2 sparse > receipts6.txt 2>&1
echo chain6-done >> objects6.log
