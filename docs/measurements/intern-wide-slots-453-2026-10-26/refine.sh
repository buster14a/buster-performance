#!/usr/bin/env bash
# #453: the intern table's two layouts (wide: three 20-byte slots of a 16-byte prefix; narrow: the same code with main's
# four 16-byte slots, a control for the builds' layout) against main, pinned to CPU 2: benchmark-preprocessor
# --only vectorized on #408's frozen sqlite3.c and main.c, and benchmark-refinement --only refine_tokens_64 on sqlite3.c
# and the C library, back to back and with --after-scalar 100. ROUNDS rounds of every tree and case as a process each, in
# an order that rotates by round; one hold of the shared lock per round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="$1"
shift
export EXCLUSIVE_OWNER=claude-perf-453 EXCLUSIVE_TITLE="#453 intern-table slots with 16-byte prefixes" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/453
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/refine-116-claude/inputs
cases=()
for tree in "$@"; do
    for c in pp-sqlite pp-main refine-sqlite refine-libc refine-sqlite-after refine-libc-after; do
        cases+=("$tree:$c")
    done
done
cat > "$root/refine-round.sh" <<'ROUND'
#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    tree="${spec%%:*}"; c="${spec#*:}"
    compiler="$root/$tree/build/compiler"
    echo "== round $round case $spec $(date +%T)"
    case "$c" in
        pp-sqlite) taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "$inputs/sqlite3.c" 2>&1 ;;
        pp-main) (cd "$inputs/mainc" && taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
        refine-sqlite) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 "$inputs/sqlite3.c" 2>&1 ;;
        refine-libc) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 /home/david/azp-bench/c-tokenizer/corpus/libc 2>&1 ;;
        refine-sqlite-after) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 --after-scalar 100 "$inputs/sqlite3.c" 2>&1 ;;
        refine-libc-after) taskset -c 2 "$compiler" benchmark-refinement --only refine_tokens_64 --after-scalar 100 /home/david/azp-bench/c-tokenizer/corpus/libc 2>&1 ;;
    esac
    echo "== status $?"
done
ROUND
chmod +x "$root/refine-round.sh"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$root/refine-round.sh" "$root" "$inputs" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
