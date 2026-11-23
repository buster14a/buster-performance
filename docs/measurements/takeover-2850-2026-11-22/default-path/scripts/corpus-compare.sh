#!/bin/bash
# corpus-compare.sh MAIN BRANCH TREE OUT [EXTRA...]: each unit of the four corpora compiled to an object with --lanes 1 by
# main's compiler, by the branch's, and by the branch's with BUSTER_TEST_DEFAULT_PATH_LOG set: the objects, the
# diagnostics and the exit statuses compared, and the check's counts summed. TREE has the compiler's own source (src) and
# build/predefines.h, the same input for both.
set -uo pipefail
a=$1; b=$2; tree=$3; out=$4; shift 4
corpus=$HOME/dev/buster-corpus
musl=$corpus/libc/musl
sq=$corpus/sqlite
lua=$HOME/.cache/claude-2850/inputs/lua-5.4.8/src
mkdir -p "$out"
: > "$out/check.log"
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    n=${f##*/}
    if [[ -z ${seen[$n]:-} ]]; then seen[$n]=1; files+=("$f"); fi
done
run()
{
    local name=$1; shift
    local list="$out/$name.files"
    local units=0 same=0 differ=0 status_differ=0 diag_differ=0 failed=0 warned=0
    : > "$out/$name.differences"
    while IFS= read -r f; do
        units=$((units + 1))
        "$a" --lanes 1 "$@" -c "$f" -o "$out/a.o" > "$out/a.err" 2>&1; local s0=$?
        "$b" --lanes 1 "$@" -c "$f" -o "$out/b.o" > "$out/b.err" 2>&1; local s1=$?
        BUSTER_TEST_DEFAULT_PATH_LOG="$out/check.log" "$b" --lanes 1 "$@" -c "$f" -o "$out/c.o" > "$out/c.err" 2>&1; local s2=$?
        [[ $s0 -ne 0 ]] && failed=$((failed + 1))
        [[ -s $out/a.err ]] && warned=$((warned + 1))
        if [[ $s0 -ne $s1 || $s0 -ne $s2 ]]; then status_differ=$((status_differ + 1)); echo "status $f: $s0 $s1 $s2" >> "$out/$name.differences"; fi
        if ! cmp -s "$out/a.err" "$out/b.err" || ! cmp -s "$out/a.err" "$out/c.err"; then diag_differ=$((diag_differ + 1)); echo "diagnostics $f" >> "$out/$name.differences"; fi
        if [[ $s0 -eq 0 ]]; then
            if cmp -s "$out/a.o" "$out/b.o" && cmp -s "$out/a.o" "$out/c.o"; then same=$((same + 1)); else differ=$((differ + 1)); echo "object $f" >> "$out/$name.differences"; fi
        fi
    done < "$list"
    echo "$name: units=$units failed=$failed with-diagnostics=$warned objects-same=$same objects-different=$differ statuses-different=$status_differ diagnostics-different=$diag_differ"
}
echo "$sq/sqlite3.c" > "$out/sqlite.files"
ls "$lua"/*.c > "$out/lua.files"
echo "$tree/src/buster/compiler/main.c" > "$out/main.files"
printf '%s\n' "${files[@]}" > "$out/musl.files"
run sqlite "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq"
run lua "$@"
run main "$@" -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h"
run musl "$@" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
python3 - "$out/check.log" <<'PY'
import re, sys
names = None; sums = None; lines = 0
for line in open(sys.argv[1], errors='replace'):
    m = re.findall(r"([a-z'-]+)=(\d+)", line)
    if not line.startswith('default-path:') or not m: continue
    lines += 1
    if sums is None: names = [k for k, _ in m]; sums = [0] * len(m)
    for i, (_, v) in enumerate(m): sums[i] += int(v)
print(f"check: commands={lines} " + (' '.join(f"{n}={v}" for n, v in zip(names, sums)) if sums else "no line"))
PY
echo finished
