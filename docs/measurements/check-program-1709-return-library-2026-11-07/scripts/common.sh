# Sourced by the scripts below: paths, the lock's identity, and held(), which runs a command inside one hold of the
# 9700X's lock and records, inside that hold, the owner file and BUSTER_9700X_HELD as its receipt.
base=~/buster-fast-bench/1709-claude
export EXCLUSIVE_OWNER=claude-1709 EXCLUSIVE_TITLE="#1709 check-program's builtin lookups" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1709
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite504="$base/inputs/sqlite-amalgamation-3500400"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
held()
{
    local receipt="$1"; shift
    $ex bash -c 'receipt="$1"; shift; { date -u +%FT%T.%NZ; printf "held=%s\n" "${BUSTER_9700X_HELD:-}"; cat /var/lib/buster-9700x/owner; } > "$receipt"; "$@"; status=$?; printf "status=%s\n" "$status" >> "$receipt"; exit $status' held "$receipt" "$@"
}
