#!/bin/bash
# chain12.sh: the pull request's two commits with branch-free gates (924e4eb8, a bundle's local/marks-pr) on main
# 87ef0550 (main5/, built by chain11): the scratch given back after the reader past 96 bytes a token, the common warnings'
# scratch popped, and the reader's rare columns in base pages for a reading in source order, whose vector path reads
# none of 64 bytes no write claimed, by masks rather than branches. Builds pr2/ under its own hold, then the per-process
# A/B of -c sqlite3.c with the compile_time step's options (7 rounds) and with -w (5), then each tree's objects and
# diagnostics in six modes, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q ../pr2.bundle local/marks-pr:refs/heads/local-marks-pr2 || exit 1
[ -d pr2 ] || git clone -q main pr2
git -C pr2 fetch -q ../main local-marks-pr2 main 2>/dev/null
git -C pr2 checkout -q --detach 924e4eb87193dd26a72f7b8ccaec1d21fffdb4ee
git -C main5 log -1 --format='main5 %H'; git -C pr2 log -1 --format='pr2 %H'
[ "$(git -C pr2 rev-parse HEAD~2)" = "$(git -C main5 rev-parse HEAD)" ] || { echo "pr2 is not two commits on main5"; exit 1; }
./build.sh pr2
echo chain12-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main5 pr2 ab12 7 -- "${options[@]}" > ab12.log 2>&1
./ab-grants.sh main5 pr2 ab12w 5 -- "${options[@]}" -w > ab12w.log 2>&1
mkdir -p objects12
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main5 pr2; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects12/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects12/$tree-$mode.o" > "objects12/$tree-$mode.lock" 2> "objects12/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects12/main5-$mode.o objects12/pr2-$mode.o && echo "same object $mode"
    diff <(f objects12/main5-$mode.err) <(f objects12/pr2-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects12/pr2-$mode.err | wc -l) lines)"
done > objects12.log 2>&1
sha256sum objects12/*.o >> objects12.log
cat objects12/*.status | tr '\n' ' ' >> objects12.log
echo >> objects12.log
./receipts.sh main5 pr2 > receipts12.txt 2>&1
echo chain12-done >> objects12.log
