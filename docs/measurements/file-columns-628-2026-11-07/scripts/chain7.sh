#!/bin/bash
# chain7.sh: the files' token columns given back after the run and -Wempty-body's lone invocations placed without the
# history, commit fb2b4af1 on main 4d6562be: clones and builds main3/ (4d6562be) and cols/ (fb2b4af1), each under its
# own hold, then the per-process A/B of -c sqlite3.c with the compile_time step's options (7 rounds) and with -w (5),
# then each tree's objects and diagnostics by default, -Wall -Wextra, --scalar, --lanes 8, the deferred reader on 8
# lanes and -g, each compile under its own grant, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
[ -d main3 ] || git clone -q main main3
[ -d cols ] || git clone -q main cols
git -C main3 checkout -q --detach 4d6562be1681b01929c8eb7afb7e6185acecc8e9
git -C cols checkout -q --detach fb2b4af1b93a2122add77ebb434916e21ba4ae6a
git -C main3 log -1 --format='main3 %H'; git -C cols log -1 --format='cols %H'
[ "$(git -C main3 rev-parse HEAD | cut -c1-8)" = 4d6562be ] || { echo "main3 is not 4d6562be"; exit 1; }
[ "$(git -C cols rev-parse HEAD^ | cut -c1-8)" = 4d6562be ] || { echo "cols's parent is not 4d6562be"; exit 1; }
./build.sh main3
./build.sh cols
echo chain7-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main3 cols ab7 7 -- "${options[@]}" > ab7.log 2>&1
./ab-grants.sh main3 cols ab7w 5 -- "${options[@]}" -w > ab7w.log 2>&1
mkdir -p objects7
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main3 cols; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects7/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects7/$tree-$mode.o" > "objects7/$tree-$mode.lock" 2> "objects7/$tree-$mode.err"
    done
done
for mode in default wall scalar lanes deferred g; do
    cmp objects7/main3-$mode.o objects7/cols-$mode.o && echo "same object $mode"
    cmp objects7/main3-$mode.err objects7/cols-$mode.err && echo "same diagnostics $mode ($(wc -l < objects7/cols-$mode.err) lines)"
done > objects7.log 2>&1
sha256sum objects7/*.o >> objects7.log
cat objects7/*.status | tr '\n' ' ' >> objects7.log
echo >> objects7.log
./receipts.sh main3 cols > receipts7.txt 2>&1
echo chain7-done >> objects7.log
