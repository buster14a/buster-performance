#!/bin/bash
# #2924 branch sizing PR: emission's objects, main against head2, default and --scalar: sqlite3.c's -c and musl's first
# 200 units, each object compared byte for byte. Then the disassembly diffs of the functions whose change the summary
# didn't explain.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: branch sizing PR, objects" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
mkdir -p logs3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
out=/dev/shm/claude-2924-objects
rm -rf "$out"; mkdir -p "$out"
{
    for mode in default scalar; do
        extra=(); [ $mode = scalar ] && extra=(--scalar)
        for side in main head2; do
            mkdir -p "$out/$side-$mode"
            "$D/compilers/$side" -c "${extra[@]}" "${S[@]}" -o "$out/$side-$mode/sqlite3.o" 2> "$out/$side-$mode/sqlite3.err"; echo "sqlite3.c $side $mode exit $?"
        done
        cmp -s "$out/main-$mode/sqlite3.o" "$out/head2-$mode/sqlite3.o" && echo "sqlite3.c $mode: same objects" || echo "sqlite3.c $mode: objects DIFFER"
        same=0; differ=0; failed=0
        for f in "${files[@]:0:200}"; do
            b=${f##*/}; b=${b%.c}
            ok=1
            for side in main head2; do
                "$D/compilers/$side" -c "${extra[@]}" --lanes 1 "${M[@]}" "$f" -o "$out/$side-$mode/$b.o" 2>/dev/null || ok=0
            done
            if [ $ok = 0 ]; then failed=$((failed + 1)); elif cmp -s "$out/main-$mode/$b.o" "$out/head2-$mode/$b.o"; then same=$((same + 1)); else differ=$((differ + 1)); echo "musl $b $mode: objects DIFFER"; fi
        done
        echo "musl, 200 units, $mode: $same same, $differ differ, $failed failed on a side"
    done
} > logs3/objects.txt 2>&1
rm -rf "$out"
python3 - > logs3/function-diffs.txt <<'PY'
import json, difflib
a = json.load(open('logs/main.json')); b = json.load(open('logs/head.json'))
names = ['check_mangle_name', 'check_input_count_tokens.specialized.2', 'tier1_call_compile', 'run_tier0_tests', 'tier0_test_build', 'tier0_test_mask_build', 'stream_compile', 'asm_assemble', 'check_program_emit_timed', 'check_program_emit_code_half', 'dataflow_generate']
for n in names:
    if n in a and n in b:
        d = list(difflib.unified_diff(a[n], b[n], 'main', 'head', n=1, lineterm=''))
        print(f'== {n}: {len(a[n])} -> {len(b[n])} instructions, {sum(1 for l in d if l[:1] in "+-" and l[:3] not in ("+++", "---"))} changed lines')
        print('\n'.join(d[:60]))
PY
date -u +%FT%TZ > logs3/.done
