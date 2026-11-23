#!/bin/bash
# corpus-san-bodies.sh WORKTREE SANITIZER: the sanitizer build with --node-bodies forced (BUSTER_TEST_NODE_BODIES=1) on real inputs (sqlite3.c -c, main.c -fsyntax-only -Wall, 40 libc units -c),
# each object compared with the plain Develop build's of the same tree; no report file may appear.
set -uo pipefail
tree=$1; san=$2
export PATH="$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
sym=$(command -v llvm-symbolizer)
cd "$tree"
out="$tree/corpus-san-bodies/$san"; rm -rf "$out"; mkdir -p "$out"
export ASAN_SYMBOLIZER_PATH="$sym" MSAN_SYMBOLIZER_PATH="$sym"
export ASAN_OPTIONS="halt_on_error=1:abort_on_error=0:exitcode=86:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:check_initialization_order=1:symbolize=1:log_path=$out/report"
export LSAN_OPTIONS="exitcode=86:print_suppressions=1:log_path=$out/report"
export UBSAN_OPTIONS="halt_on_error=1:exitcode=86:print_stacktrace=1:symbolize=1:external_symbolizer_path=$sym:log_path=$out/report"
export MSAN_OPTIONS="halt_on_error=1:exitcode=86:symbolize=1:external_symbolizer_path=$sym:log_path=$out/report"
C=$HOME/dev/buster-corpus
plain="$tree/build/cmake/native/Develop/compiler"
cc="$tree/sanitizer-$san/compiler"
fail=0
compiled=0
run() # NAME ARGS...
{
    local name=$1; shift
    "$plain" "$@" -o "$out/$name.plain.o" > "$out/$name.plain.txt" 2>&1; local a=$?
    BUSTER_TEST_NODE_BODIES=1 "$cc" "$@" -o "$out/$name.san.o" > "$out/$name.san.txt" 2>&1; local b=$?
    if [ $a -ne $b ] || ! cmp -s "$out/$name.plain.txt" "$out/$name.san.txt"; then
        echo "DIFFERENT: $name (exit $a / $b)"; fail=1
    elif [ $a -eq 0 ] && ! cmp -s "$out/$name.plain.o" "$out/$name.san.o"; then
        echo "DIFFERENT OBJECT: $name"; fail=1
    fi
    [ $a -eq 0 ] && compiled=$((compiled + 1))
    rm -f "$out/$name.plain.o" "$out/$name.san.o"
}
run sqlite --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c
run sqlite-wall --lanes 1 -c -Wall -Wextra -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $C/sqlite/sqlite3.c
"$plain" -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/main.plain.txt" 2>&1; a=$?
"$cc" -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > "$out/main.san.txt" 2>&1; b=$?
if [ $a -ne $b ] || ! cmp -s "$out/main.plain.txt" "$out/main.san.txt"; then echo "DIFFERENT: main.c (exit $a / $b)"; fail=1; fi
n=0
for f in $HOME/.cache/claude-2850/inputs/lua-5.4.8/src/*.c; do
    n=$((n + 1))
    run "lua-$n" --lanes 1 -c "$f"
done
M=$C/libc/musl; G=$C/musl-generated
for f in $(find $M/src -name '*.c' | sort | awk 'NR % 4 == 1' | head -400); do
    n=$((n + 1))
    run "musl-$n" --lanes 1 -c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$M/arch/x86_64 -I$M/arch/generic -I$G/obj/src/internal -I$M/src/include -I$M/src/internal -I$G/obj/include -I$M/include "$f"
done
echo "$san: units=$((n + 3)) compiled-to-an-object=$compiled failures=$fail reports=$(ls "$out" | grep -c '^report')"
