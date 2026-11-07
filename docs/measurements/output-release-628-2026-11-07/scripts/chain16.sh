#!/bin/bash
# chain16.sh: the pull request on main 73fcf006 (main7/): 22c7647f, the preprocessor's output given back before the
# backend (pp_release_output), which a replay gives back to a reader that asks (pr5/). Builds both under their own holds,
# then the per-process A/B of -c sqlite3.c with the compile_time step's options (9 rounds) and with -w (5), then each
# tree's objects and diagnostics in six modes, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q ../pr5.bundle +claude/practical-tesla-2lgodi:refs/heads/local-pr5 || exit 1
for tree in main7 pr5; do [ -d $tree ] || git clone -q main $tree; git -C $tree fetch -q ../main +local-pr5:local-pr5 2>/dev/null; done
git -C main7 checkout -q --detach 73fcf006
git -C pr5 checkout -q --detach 22c7647f
git -C main7 log -1 --format='main7 %H'; git -C pr5 log -1 --format='pr5 %H'
[ "$(git -C pr5 rev-parse HEAD~1)" = "$(git -C main7 rev-parse HEAD)" ] || { echo "pr5 is not one commit on main7"; exit 1; }
./build.sh main7
./build.sh pr5
echo chain16-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main7 pr5 ab16 9 -- "${options[@]}" > ab16.log 2>&1
echo chain16-ab
./ab-grants.sh main7 pr5 ab16w 5 -- "${options[@]}" -w > ab16w.log 2>&1
mkdir -p objects16
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main7 pr5; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects16/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects16/$tree-$mode.o" > "objects16/$tree-$mode.lock" 2> "objects16/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects16/main7-$mode.o objects16/pr5-$mode.o && echo "same object $mode"
    diff <(f objects16/main7-$mode.err) <(f objects16/pr5-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects16/pr5-$mode.err | wc -l) lines)"
done > objects16.log 2>&1
sha256sum objects16/*.o >> objects16.log
cat objects16/*.status | tr '\n' ' ' >> objects16.log
echo >> objects16.log
./receipts.sh main7 pr5 > receipts16.txt 2>&1
echo chain16-done >> objects16.log
