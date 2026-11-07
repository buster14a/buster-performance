#!/bin/bash
# chain11.sh: the pull request's two commits (31bf2e97, a bundle's local/marks-pr) on main 87ef0550: the scratch given back
# after the reader past 96 bytes a token, the common warnings' scratch popped, and the reader's rare columns in base
# pages for a reading in source order, whose vector path reads none of 64 bytes no write claimed. After chain10, clones
# and builds main5/ and pr/, each under its own hold, then the per-process A/B of -c sqlite3.c with the compile_time
# step's options (7 rounds) and with -w (5), then each tree's objects and diagnostics in six modes, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
until grep -q chain10-done objects10.log 2>/dev/null; do sleep 30; done
git -C main fetch -q origin main || exit 1
git -C main fetch -q ../pr.bundle local/marks-pr:refs/heads/local-marks-pr || exit 1
for t in main5 pr; do [ -d $t ] || git clone -q main $t; git -C $t fetch -q ../main local-marks-pr main 2>/dev/null; done
git -C main5 checkout -q --detach 87ef05501cf011c5bbf1f5fe112d66f97b9674cf
git -C pr checkout -q --detach 31bf2e97c93d32f19501188bb8bbf74409efb211
git -C main5 log -1 --format='main5 %H'; git -C pr log -1 --format='pr %H'
[ "$(git -C main5 rev-parse HEAD | cut -c1-8)" = 87ef0550 ] || { echo "main5 is not 87ef0550"; exit 1; }
[ "$(git -C pr rev-parse HEAD~2)" = "$(git -C main5 rev-parse HEAD)" ] || { echo "pr is not two commits on main5"; exit 1; }
./build.sh main5
./build.sh pr
echo chain11-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main5 pr ab11 7 -- "${options[@]}" > ab11.log 2>&1
./ab-grants.sh main5 pr ab11w 5 -- "${options[@]}" -w > ab11w.log 2>&1
mkdir -p objects11
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main5 pr; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects11/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects11/$tree-$mode.o" > "objects11/$tree-$mode.lock" 2> "objects11/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects11/main5-$mode.o objects11/pr-$mode.o && echo "same object $mode"
    diff <(f objects11/main5-$mode.err) <(f objects11/pr-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects11/pr-$mode.err | wc -l) lines)"
done > objects11.log 2>&1
sha256sum objects11/*.o >> objects11.log
cat objects11/*.status | tr '\n' ' ' >> objects11.log
echo >> objects11.log
./receipts.sh main5 pr > receipts11.txt 2>&1
echo chain11-done >> objects11.log
