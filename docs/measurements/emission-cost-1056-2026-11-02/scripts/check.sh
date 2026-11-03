# Correctness before timing: each build compiles both workloads, into the same object bytes.
set -e
source ~/buster-fast-bench/1056-claude/common.sh
cd $root
printf "%s  %s\n" 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
rm -rf out && mkdir -p out
for tree in base head; do
    mkdir -p out/$tree/musl
    $lock taskset -c 2 $root/$tree/build/compiler "${sqlite_options[@]}" -o out/$tree/sqlite3.o
    (cd out/$tree/musl && $lock taskset -c 2 $root/$tree/build/compiler -c "${musl_flags[@]}" "${musl_files[@]}")
    ls out/$tree/musl | wc -l
done
cmp out/base/sqlite3.o out/head/sqlite3.o && echo "sqlite3.o: same bytes"
diff -r out/base/musl out/head/musl && echo "musl: same bytes"
sha256sum out/base/sqlite3.o out/head/sqlite3.o
size out/head/sqlite3.o
echo CHECK-DONE
