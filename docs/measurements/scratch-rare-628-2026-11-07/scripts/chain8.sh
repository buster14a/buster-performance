#!/bin/bash
# chain8.sh: after chain7, the follow-up on cols (fb2b4af1): next1/ (ec47b7eb, the scratch given back after the reader and
# after the common warnings) and next2/ (f7f9f8de, with the reader's rare columns in base pages, populated), from
# local-next (a bundle). Builds each under its own hold, then per-process A/Bs of -c sqlite3.c with the compile_time
# step's options: cols against next2 (7 rounds) and cols against next1 (5), then the objects, then the receipts.
cd ~/buster-fast-bench/628-claude-tesla
until grep -q chain7-done objects7.log 2>/dev/null; do sleep 30; done
[ -d next1 ] || git clone -q main next1
[ -d next2 ] || git clone -q main next2
git -C next1 fetch -q ../main local-next 2>/dev/null
git -C next2 fetch -q ../main local-next 2>/dev/null
git -C next1 checkout -q --detach ec47b7eb
git -C next2 checkout -q --detach f7f9f8de619c0ec6f56e7b212a1ebc6d2f561835
git -C next1 log -1 --format='next1 %H'; git -C next2 log -1 --format='next2 %H'
[ "$(git -C next1 rev-parse HEAD^)" = fb2b4af1b93a2122add77ebb434916e21ba4ae6a ] || { echo "next1's parent is not fb2b4af1"; exit 1; }
[ "$(git -C next2 rev-parse HEAD^)" = "$(git -C next1 rev-parse HEAD)" ] || { echo "next2's parent is not next1"; exit 1; }
./build.sh next1
./build.sh next2
echo chain8-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
./ab-grants.sh cols next2 ab8 7 -- "${options[@]}" > ab8.log 2>&1
./ab-grants.sh cols next1 ab8n1 5 -- "${options[@]}" > ab8n1.log 2>&1
mkdir -p objects8
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
for tree in cols next2; do
    for mode in wall scalar lanes deferred g; do
        case $mode in wall) extra=(-Wall -Wextra);; scalar) extra=(--scalar -Wall -Wextra);; lanes) extra=(--lanes 8);; deferred) extra=(--lanes 8 --deferred-bodies);; g) extra=(-g);; esac
        if [ $mode = lanes ] || [ $mode = deferred ]; then pin=(); else pin=(taskset -c 2); fi
        ~/buster-fast-bench/exclusive.sh bash -c 'run=$1; shift; cat /var/lib/buster-9700x/owner > "$run.owner"; "$@"; echo $? > "$run.status"' grant "objects8/$tree-$mode" \
            "${pin[@]}" "$tree/build/compiler" "${options[@]}" "${extra[@]}" -o "objects8/$tree-$mode.o" > "objects8/$tree-$mode.lock" 2> "objects8/$tree-$mode.err"
    done
done
for mode in wall scalar lanes deferred g; do
    cmp objects8/cols-$mode.o objects8/next2-$mode.o && echo "same object $mode"
    cmp objects8/cols-$mode.err objects8/next2-$mode.err && echo "same diagnostics $mode ($(wc -l < objects8/next2-$mode.err) lines)"
done > objects8.log 2>&1
sha256sum objects8/*.o >> objects8.log
cat objects8/*.status | tr '\n' ' ' >> objects8.log
echo >> objects8.log
./receipts.sh cols next1 next2 > receipts8.txt 2>&1
echo chain8-done >> objects8.log
