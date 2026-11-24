#!/usr/bin/env bash
# Paths to the base and candidate compiler, the
# private work directory and the frozen Lua 5.4.8 source directory are arguments.
set -euo pipefail
base=$(realpath "$1")
candidate=$(realpath "$2")
work=$(realpath -m "$3")
lua=$(realpath "$4")
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER="${EXCLUSIVE_OWNER:-tree-columns-replay}"
export EXCLUSIVE_TITLE="${EXCLUSIVE_TITLE:-Tree traversal correctness}"
export EXCLUSIVE_LINK="${EXCLUSIVE_LINK:-https://github.com/buster14a/buster/issues/2850}"
run() { "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 160 taskset -c 2 bash -c 'exec "$@" 2>&3' _ "$@" 3>&2 2>>"$work/locks.log"; }
mkdir -p "$work/base" "$work/candidate"
test -s "$lua/lapi.c"
printf 'input hashes\n'
sha256sum "$sqlite/sqlite3.c" "$base" "$candidate"
cat > "$work/smoke.c" <<'C'
#include "sqlite3.h"
#include <stdio.h>
int main(void)
{
    sqlite3 *db = NULL;
    sqlite3_stmt *q = NULL;
    if (sqlite3_open(":memory:", &db) != SQLITE_OK ||
        sqlite3_exec(db, "CREATE TABLE t(x); INSERT INTO t VALUES(5),(8),(13);", NULL, NULL, NULL) != SQLITE_OK ||
        sqlite3_prepare_v2(db, "SELECT sum(x) FROM t", -1, &q, NULL) != SQLITE_OK ||
        sqlite3_step(q) != SQLITE_ROW || sqlite3_column_int(q, 0) != 26 ||
        sqlite3_step(q) != SQLITE_DONE || sqlite3_finalize(q) != SQLITE_OK ||
        sqlite3_close(db) != SQLITE_OK)
    {
        return 1;
    }
    puts("sum = 26");
    return 0;
}
C
cat > "$work/invalid.c" <<'C'
struct pair { int x; int y; };
int wrong(struct pair p) { return p.z; }
C
for arm in base candidate; do
    if [[ $arm == base ]]; then cc=$base; else cc=$candidate; fi
    cd "$work/$arm"
    run "$cc" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
        "-I$sqlite" "$sqlite/sqlite3.c" -o sqlite.o > sqlite.stdout 2> sqlite.stderr
    run "$cc" --lanes 1 -c "$lua"/*.c > lua.stdout 2> lua.stderr
    if run "$cc" --lanes 1 -c "$work/invalid.c" -o invalid.o > invalid.stdout 2> invalid.stderr; then
        exit 1
    else
        echo "$?" > invalid.status
    fi
    test -s invalid.stderr
    test ! -e invalid.o
    run cc -I"$sqlite" "$work/smoke.c" sqlite.o -lm -o sqlite-smoke
    run ./sqlite-smoke > smoke.txt
    sha256sum ./*.o ./*.std{out,err} invalid.status smoke.txt > manifest.txt
done
diff -u "$work/base/manifest.txt" "$work/candidate/manifest.txt"
cat "$work/candidate/manifest.txt" "$work/candidate/smoke.txt"
