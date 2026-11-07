#!/bin/bash
# chain13.sh: chain12's pull request (924e4eb8) plus a139719f, whose gated vector loads of the rare columns read a static line
# of zeros rather than loads masked to no lanes, on main 87ef0550 (main5/). Builds pr3/ under its own hold, then the
# per-process A/B of -c sqlite3.c with the compile_time step's options (7 rounds) and with -w (5), then each tree's
# objects and diagnostics in six modes, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q ../pr3.bundle local/marks-line:refs/heads/local-marks-line || exit 1
[ -d pr3 ] || git clone -q main pr3
git -C pr3 fetch -q ../main local-marks-line main 2>/dev/null
git -C pr3 checkout -q --detach a139719f
git -C main5 log -1 --format='main5 %H'; git -C pr3 log -1 --format='pr3 %H'
[ "$(git -C pr3 rev-parse HEAD~3)" = "$(git -C main5 rev-parse HEAD)" ] || { echo "pr3 is not three commits on main5"; exit 1; }
./build.sh pr3
echo chain13-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh main5 pr3 ab13 7 -- "${options[@]}" > ab13.log 2>&1
echo chain13-ab
./ab-grants.sh main5 pr3 ab13w 5 -- "${options[@]}" -w > ab13w.log 2>&1
mkdir -p objects13
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in main5 pr3; do
    for mode in default wall scalar lanes deferred g; do
        case $mode in default) extra=();; wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects13/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects13/$tree-$mode.o" > "objects13/$tree-$mode.lock" 2> "objects13/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in default wall scalar lanes deferred g; do
    cmp objects13/main5-$mode.o objects13/pr3-$mode.o && echo "same object $mode"
    diff <(f objects13/main5-$mode.err) <(f objects13/pr3-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects13/pr3-$mode.err | wc -l) lines)"
done > objects13.log 2>&1
sha256sum objects13/*.o >> objects13.log
cat objects13/*.status | tr '\n' ' ' >> objects13.log
echo >> objects13.log
./receipts.sh main5 pr3 > receipts13.txt 2>&1
echo chain13-done >> objects13.log
