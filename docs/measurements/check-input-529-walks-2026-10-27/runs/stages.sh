#!/bin/bash
# stages.sh A B OUT: under one hold of the 9700X's lock, CPU 2, #520's measure-compile of `-c` of the frozen sqlite3.c
# by tree A's compiler with B's as its reference, then by B's with A's: each one's stage table and wall, user and system
# times against the other's, in rotating order. Both trees have #520's stage clock merged in.
set -e
base=~/buster-fast-bench/check-input-529b
out=$base/$3
mkdir -p "$out"
cat > "$out/inner.sh" <<'INNER'
#!/bin/bash
set -e
a=$1; b=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$a" measure-compile --runs 11 --directory "$out" --reference "$b" -- "${options[@]}" > "$out/measure-A.txt" 2>&1
taskset -c 2 "$b" measure-compile --runs 11 --directory "$out" --reference "$a" -- "${options[@]}" > "$out/measure-B.txt" 2>&1
INNER
chmod +x "$out/inner.sh"
$base/lock.sh "$out/inner.sh" "$base/$1/build/compiler" "$base/$2/build/compiler" "$out" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
for v in A B; do echo "== $v"; grep -vE '^run [0-9]' "$out/measure-$v.txt" | head -80; done
