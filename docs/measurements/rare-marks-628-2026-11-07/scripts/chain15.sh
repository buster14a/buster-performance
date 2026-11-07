#!/bin/bash
# chain15.sh: the pull request rebased on main 872cb8fe (main6/): b6a81b4e, the scratch given back after the reader past
# 96 bytes a token, and ffb2cfae, the rare columns in base pages read only where written, whose gated vector loads read a
# static line of zeros (pr4/). Builds both under their own holds, then the per-process A/B of -c sqlite3.c with the
# compile_time step's options (9 rounds) and with -w (5), then each tree's objects and diagnostics in six modes, then the
# receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q ../pr4.bundle claude/practical-tesla-2lgodi:refs/heads/local-pr4 || exit 1
for tree in main6 pr4; do [ -d $tree ] || git clone -q main $tree; git -C $tree fetch -q ../main local-pr4 2>/dev/null; done
git -C main6 checkout -q --detach 872cb8fe
git -C pr4 checkout -q --detach ffb2cfae
git -C main6 log -1 --format='main6 %H'; git -C pr4 log -1 --format='pr4 %H'
[ "$(git -C pr4 rev-parse HEAD~2)" = "$(git -C main6 rev-parse HEAD)" ] || { echo "pr4 is not two commits on main6"; exit 1; }
./build.sh main6
./build.sh pr4
echo chain15-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main6 pr4 ab15 9 -- "${options[@]}" > ab15.log 2>&1
echo chain15-ab
./ab-grants.sh main6 pr4 ab15w 5 -- "${options[@]}" -w > ab15w.log 2>&1
mkdir -p objects15
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main6 pr4; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects15/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects15/$tree-$mode.o" > "objects15/$tree-$mode.lock" 2> "objects15/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects15/main6-$mode.o objects15/pr4-$mode.o && echo "same object $mode"
    diff <(f objects15/main6-$mode.err) <(f objects15/pr4-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects15/pr4-$mode.err | wc -l) lines)"
done > objects15.log 2>&1
sha256sum objects15/*.o >> objects15.log
cat objects15/*.status | tr '\n' ' ' >> objects15.log
echo >> objects15.log
./receipts.sh main6 pr4 > receipts15.txt 2>&1
echo chain15-done >> objects15.log
