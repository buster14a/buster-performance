#!/bin/bash
# #2924 C12a's gate, the macros' area split (it read 0.4% to 0.8% faster by its scalar arms on musl's units): 19
# pp_is_macro, 20 the parameter indexes, 21 pp_define's body scan; c12a-macros-knob.patch on 22f3d4625 (EXPERIMENT ONLY).
# Every run under the lock on CPU 2: -E outputs compared with no bit's; ab, three rounds, around time-runs of none, the
# three together, each alone and a control bit no site reads, on -E of musl's units and Lua's units.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the preprocessor's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p macros/logs macros/compilers
if [ ! -d macros/src ]; then git clone -q --shared $D/../c11pr/src-head macros/src || exit 1; fi
git -C macros/src checkout -q --detach 22f3d4625 && git -C macros/src reset -q --hard
(cd macros/src && patch -p1 < "$D/c12a-macros-knob.patch" > "$D/macros/logs/patch.log" 2>&1) || { echo "patch failed" >> macros/logs/status.txt; exit 1; }
(cd macros/src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/macros/logs/build.log" 2>&1) || { echo "build failed" >> macros/logs/status.txt; exit 1; }
names=(none macros is-macro parameters define control)
masks=(0 3670016 524288 1048576 2097152 4194304)
for m in "${masks[@]}"; do cp macros/src/build/compiler macros/compilers/compiler-areas$m; done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12a-macros
rm -rf "$out"; mkdir -p "$out"
for i in "${!masks[@]}"; do
    exe="$D/macros/compilers/compiler-areas${masks[$i]}"
    $L timeout -k 5 900 bash -c '"$0" -E "$@"' "$exe" "${M[@]}" "${files[@]}" > "$out/${names[$i]}-musl.i" 2>> "$D/macros/logs/stderr.txt"; echo "output ${names[$i]} musl: $?" >> macros/logs/status.txt
    cmp -s "$out/none-musl.i" "$out/${names[$i]}-musl.i"; echo "same output ${names[$i]} musl: $?" >> macros/logs/status.txt
done
rm -rf "$out"
time=/dev/shm/claude-2924-c12a-macros-time
BUILDS=()
for i in "${!masks[@]}"; do BUILDS+=(--build "${names[$i]}" "$D/macros/compilers/compiler-areas${masks[$i]}"); done
for list in musl lua; do
    rm -rf "$time"; mkdir -p "$time"
    case $list in
        lua) args=(-E "$lua"/*.c);;
        musl) args=(-E "${M[@]}" "${files[@]}");;
    esac
    (cd "$time" && "$D/macros/compilers/compiler-areas0" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/macros/compilers/compiler-areas0" \
        -- time-runs --runs 3 --directory "$time" "${BUILDS[@]}" --list "${args[@]}" > "$D/macros/logs/time-$list.log" 2>&1)
    echo "time $list: $?" >> macros/logs/status.txt
done
rm -rf "$time"
echo done >> macros/logs/status.txt
date -u +%FT%TZ > macros/logs/.done
