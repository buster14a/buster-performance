#!/bin/bash
# #2924 C12b's gate: the parser's own scalar sites, each alone, on C12a's head 5afd0cb8c plus c12b-areas-knob.patch
# (EXPERIMENT ONLY: the executable takes its sites' bits from its file's name, compiler-areasN).
# Sites (bit k, mask 1<<k): 20 the whole unit by parse_scalar (the "scalar parser alone" mode), 21 the handoff's
# conversion (parse_tokens_from_output_scalar), 22 clang's scope numbers' scan (parse_clang_scope_numbers), 23 the GNU
# records' candidates and collection (gnu_syntax_build); all four (15728640); and a control bit no site reads (1 << 24).
# Release, every run under the lock on CPU 2:
# 1. -c objects of sqlite3.c, Lua's units and musl's units by every build, compared with no bit's byte by byte;
# 2. ab, three rounds, around time-runs of the seven builds (three runs of three copies), one list at a time:
#    `parse -fsyntax-only` of sqlite3.c and of buster's main.c (one file each), -fsyntax-only of Lua's units and musl's
#    units, and -c of sqlite3.c and musl's units;
# 3. benchmark-parser (the stock paths and the kernels' twins) on sqlite3.c, buster's main.c, one Lua unit and one musl
#    unit, three times each.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs compilers
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach 5afd0cb8c && git -C src reset -q --hard
(cd src && patch -p1 < "$D/c12b-areas-knob.patch" > "$D/logs/patch.log" 2>&1) || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
names=(none whole handoff scopes gnu all control)
masks=(0 1048576 2097152 4194304 8388608 15728640 16777216)
for m in "${masks[@]}"; do cp src/build/compiler compilers/compiler-areas$m; done
sha256sum compilers/* > logs/compilers.sha256
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
# 1. Objects.
objects=/dev/shm/claude-2924-c12b-objects
rm -rf "$objects"
for i in "${!masks[@]}"; do
    exe="$D/compilers/compiler-areas${masks[$i]}"
    cur=$objects/${names[$i]}
    mkdir -p "$cur/sqlite" "$cur/lua" "$cur/musl"
    (cd "$cur/sqlite" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} sqlite: $?" >> logs/status.txt
    (cd "$cur/lua" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "$lua"/*.c > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} lua: $?" >> logs/status.txt
    (cd "$cur/musl" && $L timeout -k 5 1500 "$exe" -c --lanes 1 "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr-${names[$i]}.txt"); echo "objects ${names[$i]} musl: $?" >> logs/status.txt
done
for i in "${!masks[@]}"; do
    n=0; d=0
    while read -r f; do
        n=$((n+1))
        cmp -s "$objects/none/$f" "$objects/${names[$i]}/$f" || d=$((d+1))
    done < <(cd "$objects/none" && find . -name '*.o' | sort)
    echo "objects ${names[$i]}: $n compared, $d differ" >> logs/status.txt
done
rm -rf "$objects"
# 2. Whole runs.
time=/dev/shm/claude-2924-c12b
BUILDS=()
for i in "${!masks[@]}"; do BUILDS+=(--build "${names[$i]}" "$D/compilers/compiler-areas${masks[$i]}"); done
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$D/predefines.h"
for list in parse-sqlite parse-buster syntax-lua syntax-musl c-sqlite c-musl; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        parse-sqlite) args=(parse -fsyntax-only "${S[@]}");;
        parse-buster) args=(parse -fsyntax-only -march=znver5 -I"$D/src/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src/src/buster/compiler/main.c");;
        syntax-lua) args=(-fsyntax-only "$lua"/*.c);;
        syntax-musl) args=(-fsyntax-only "${M[@]}" "${files[@]}");;
        c-sqlite) args=(-c --lanes 1 "${S[@]}" -o "$time/sqlite3.o");;
        c-musl) args=(-c --lanes 1 "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$D/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/compiler-areas0" \
        -- time-runs --runs 3 --copies 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs/status.txt
done
rm -rf "$time"
# 3. The kernels' twins, large units and small.
B=(-march=znver5 -I"$D/src/src" -fwrapv -funsigned-char --predefines "$D/predefines.h" -DBUSTER_COMPLETE_DRIVER=1 "$D/src/src/buster/compiler/main.c")
for round in 1 2 3; do
    for input in sqlite buster lua-one musl-one; do
        case $input in
            sqlite) args=("${S[@]}");;
            buster) args=("${B[@]}");;
            lua-one) args=("$lua/lapi.c");;
            musl-one) args=("${M[@]}" "$musl/src/string/strlen.c");;
        esac
        cp compilers/compiler-areas0 compilers/bench-run
        $L timeout -k 5 900 taskset -c 2 ./compilers/bench-run benchmark-parser "${args[@]}" > "logs/bench-$round-$input.log" 2>&1; echo "bench $round $input: $?" >> logs/status.txt
        rm -f compilers/bench-run
    done
done
echo done >> logs/status.txt
date -u +%FT%TZ > logs/.done
