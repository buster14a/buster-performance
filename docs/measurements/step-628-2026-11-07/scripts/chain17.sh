#!/bin/bash
# chain17.sh: #628's "Done when", as #518's compile_time step measures it. The step's own commands (measure-compile
# --runs 11 against tcc, then perf stat -r 11 of the compiler, CPU 2) for main 2a852f20, #617's merge, which the
# issue's 393,140 KB was measured from (base617/), and main 94e166ec, #1695's merge (main8/), each run under its own
# grant of the lock, in the order base, main, main, base.
set -u
cd ~/buster-fast-bench/628-claude-tesla
git -C main fetch -q origin main || exit 1
for tree in base617 main8; do [ -d $tree ] || git clone -q main $tree; git -C $tree fetch -q origin main 2>/dev/null || git -C $tree fetch -q ../main main; done
git -C base617 checkout -q --detach 2a852f20
git -C main8 checkout -q --detach 94e166ec
git -C base617 log -1 --format='base617 %H %s'; git -C main8 log -1 --format='main8 %H %s'
./build.sh base617
./build.sh main8
echo chain17-built
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tcc="$(command -v tcc)"
"$tcc" -v
printf '%s  %s\n' 49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082 "$tcc" | sha256sum --check || exit 1
mkdir -p step17
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: the compile_time step" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
events=task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u
round=0
for tree in base617 main8 main8 base617; do
    round=$((round + 1))
    run=step17/$round-$tree
    ~/buster-fast-bench/exclusive.sh bash -c '
        run=$1; tree=$2; tcc=$3; events=$4; shift 4
        cat /var/lib/buster-9700x/owner > "$run.owner"
        taskset -c 2 "$tree/build/compiler" measure-compile --runs 11 --reference "$tcc" -- "$@" > "$run.measure" 2>&1
        echo $? > "$run.measure.status"
        taskset -c 2 perf stat -r 11 -e "$events" -o "$run.stat" -- "$tree/build/compiler" "$@" -o "$run.o" > /dev/null 2>&1
        echo $? > "$run.stat.status"
        sha256sum "$run.o" > "$run.o.sha256"; rm -f "$run.o"' grant "$run" "$tree" "$tcc" "$events" "${options[@]}" > "$run.lock" 2>&1
    echo "round $round $tree: measure $(cat $run.measure.status) stat $(cat $run.stat.status)"
done
./receipts.sh base617 main8 > receipts17.txt 2>&1
echo chain17-done
