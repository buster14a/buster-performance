#!/bin/bash
# chain10.sh: the rare columns' page marks (36ceed09, a bundle's local/marks) on main 4e5abcb0: the reader's rare columns
# in base pages for a reading in source order, whose vector path reads none of a page no write claimed; the scratch given
# back after the reader past 96 bytes a token; and the common warnings' scratch popped. Clones and builds main4/ and
# marks/, each under its own hold, then the per-process A/B of -c sqlite3.c with the compile_time step's options (7
# rounds) and with -w (5), then each tree's objects and diagnostics in six modes, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q origin main || exit 1
git -C main fetch -q ../marks.bundle local/marks:refs/heads/local-marks || exit 1
for t in main4 marks; do [ -d $t ] || git clone -q main $t; git -C $t fetch -q ../main local-marks main 2>/dev/null; done
git -C main4 checkout -q --detach 4e5abcb03b0d82a00ec6bd1d5cad1f16fb3d6765 2>/dev/null || git -C main4 checkout -q --detach 4e5abcb0
git -C marks checkout -q --detach 36ceed09ee63c4d2f45e627f68d2b3c770c97d33
git -C main4 log -1 --format='main4 %H'; git -C marks log -1 --format='marks %H'
[ "$(git -C main4 rev-parse HEAD | cut -c1-8)" = 4e5abcb0 ] || { echo "main4 is not 4e5abcb0"; exit 1; }
git -C marks merge-base --is-ancestor "$(git -C main4 rev-parse HEAD)" HEAD || { echo "marks is not on main4"; exit 1; }
./build.sh main4
./build.sh marks
echo chain10-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main4 marks ab10 7 -- "${options[@]}" > ab10.log 2>&1
./ab-grants.sh main4 marks ab10w 5 -- "${options[@]}" -w > ab10w.log 2>&1
mkdir -p objects10
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main4 marks; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects10/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects10/$tree-$mode.o" > "objects10/$tree-$mode.lock" 2> "objects10/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects10/main4-$mode.o objects10/marks-$mode.o && echo "same object $mode"
    diff <(f objects10/main4-$mode.err) <(f objects10/marks-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects10/marks-$mode.err | wc -l) lines)"
done > objects10.log 2>&1
sha256sum objects10/*.o >> objects10.log
cat objects10/*.status | tr '\n' ' ' >> objects10.log
echo >> objects10.log
./receipts.sh main4 marks > receipts10.txt 2>&1
echo chain10-done >> objects10.log
