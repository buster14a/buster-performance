#!/bin/bash
# callers.sh NAME...: each stage 2 compiler's default-tier compile of the frozen sqlite3.c, pinned to CPU 2, sampled with
# its user-mode calls' branch records (perf record -j any_call,u): which DSO and symbol the hot addresses are in, and the
# sampled call edges by caller and callee. Run inside one hold of the lock. results/selfhost/callers-NAME-*.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/selfhost
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-2541-callers.XXXXXX)
for b in "$@"; do
    compiler=scratch/selfhost/$b/compiler
    taskset -c 2 perf record -q -o "$tmp/$b.data" -e cycles:u -c 200003 -- "$compiler" --lanes 1 "${options[@]}" -o "$tmp/out.o" > /dev/null 2> "$out/callers-$b-record.log"
    perf report -i "$tmp/$b.data" --no-children --sort dso,sym --stdio -q --percent-limit 0.5 > "$out/callers-$b-dso.txt" 2>> "$out/callers-$b-record.log"
    taskset -c 2 perf record -q -o "$tmp/$b-calls.data" -j any_call,u -e cycles:u -c 200003 -- "$compiler" --lanes 1 "${options[@]}" -o "$tmp/out.o" > /dev/null 2>> "$out/callers-$b-record.log"
    perf report -i "$tmp/$b-calls.data" --no-children --sort symbol_from,symbol_to,dso_to --stdio -q --percent-limit 0.3 > "$out/callers-$b-edges.txt" 2>> "$out/callers-$b-record.log"
done
rm -rf "$tmp"
