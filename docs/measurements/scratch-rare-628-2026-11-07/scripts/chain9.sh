#!/bin/bash
# chain9.sh: two refinements of chain8's follow-up, each on cols (fb2b4af1), from a bundle (local-next3, local-next4):
# exp4/ (3a999dd4), the reader's rare columns in base pages, populated, alone; exp3/ (20a125ed), with them the scratch
# given back after the reader past what the stages up to check_program push again (96 bytes a token), and the common
# warnings' scratch popped without a discard. Builds each under its own hold, then per-process A/Bs of -c sqlite3.c with
# the compile_time step's options against cols, 7 rounds each, then each tree's objects, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q ../exp.bundle local/next3:refs/heads/local-next3 local/next4:refs/heads/local-next4 || exit 1
for t in exp3 exp4; do [ -d $t ] || git clone -q main $t; git -C $t fetch -q ../main local-next3 local-next4; done
git -C exp3 checkout -q --detach 20a125edc3c45e9deafd9252db3abdc0306394ff
git -C exp4 checkout -q --detach 3a999dd43117027300eda50e03a282af474afecb
git -C exp3 log -1 --format='exp3 %H'; git -C exp4 log -1 --format='exp4 %H'
for t in exp3 exp4; do [ "$(git -C $t rev-parse HEAD^)" = fb2b4af1b93a2122add77ebb434916e21ba4ae6a ] || { echo "$t's parent is not fb2b4af1"; exit 1; }; done
./build.sh exp4
./build.sh exp3
echo chain9-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh cols exp3 ab9 7 -- "${options[@]}" > ab9.log 2>&1
./ab-grants.sh cols exp4 ab9r 7 -- "${options[@]}" > ab9r.log 2>&1
mkdir -p objects9
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in exp3; do
    for mode in wall scalar lanes deferred g; do
        case $mode in wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects9/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects9/$tree-$mode.o" > "objects9/$tree-$mode.lock" 2> "objects9/$tree-$mode.err"
    done
done
f() { grep -v -E "^exclusive.sh: |^  (title|link|pull request): " "$1"; }
for mode in wall scalar lanes deferred g; do
    cmp objects8/cols-$mode.o objects9/exp3-$mode.o && echo "same object $mode"
    diff <(f objects8/cols-$mode.err) <(f objects9/exp3-$mode.err) > /dev/null && echo "same diagnostics $mode ($(f objects9/exp3-$mode.err | wc -l) lines)"
done > objects9.log 2>&1
sha256sum objects9/*.o >> objects9.log
cat objects9/*.status | tr '\n' ' ' >> objects9.log
echo >> objects9.log
./receipts.sh cols exp3 exp4 > receipts9.txt 2>&1
echo chain9-done >> objects9.log
