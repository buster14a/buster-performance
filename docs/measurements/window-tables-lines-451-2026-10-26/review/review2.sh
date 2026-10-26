#!/usr/bin/env bash
# #451 review, the bound: benchmark-preprocessor --only vectorized, a window at a time and whole (--window-bytes 2000000000), on
# #408's frozen sqlite3.c and main.c and on generated sources of sparse line ends (generate451: long-lines.c, lines of 5
# to 12 KB; spliced.c, macros spliced over 20 to 200 KB), pinned to CPU 2. ROUNDS rounds of every tree, input and
# variant as a process each, in an order that rotates by round; one hold of the shared lock per round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="$1"
shift
export EXCLUSIVE_OWNER=claude-perf-451 EXCLUSIVE_TITLE="#451 review: the cut's bound, 4 or 16 KB" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/486
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/refine-116-claude/inputs
cases=()
for tree in "$@"; do
    for input in sqlite main long-lines spliced; do
        for variant in windows; do
            cases+=("$tree:$input:$variant")
        done
    done
done
cat > "$root/review2-round.sh" <<'ROUND'
#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r tree input variant <<< "$spec"
    extra=()
    [ "$variant" = whole ] && extra=(--window-bytes 2000000000)
    echo "== round $round case $spec $(date +%T)"
    case "$input" in
        sqlite) taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "$inputs/sqlite3.c" 2>&1 ;;
        main) (cd "$inputs/mainc" && taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "${extra[@]}" -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
        *) taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "$root/review-inputs/$input.c" 2>&1 ;;
    esac
    echo "== status $?"
done
ROUND
chmod +x "$root/review2-round.sh"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$root/review2-round.sh" "$root" "$inputs" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
