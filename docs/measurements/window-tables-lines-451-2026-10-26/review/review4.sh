#!/usr/bin/env bash
# #451 review, one binary: benchmark-preprocessor --only vectorized a window at a time on #408's frozen sqlite3.c and
# main.c and on generate451's sources (long-lines.c, spliced.c), pinned to CPU 2, with switch451.py's BUSTER_451_MAIN at
# 0 (the pull request), 1 (main's window rule), 2 (main's places loop) and 3 (both main's). ROUNDS rounds of every input
# and switch as a process each, in an order that rotates by round; one hold of the shared lock per round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="$1"
tree="$2"
export EXCLUSIVE_OWNER=claude-perf-451 EXCLUSIVE_TITLE="#451 review: main's cut and places switched in one binary" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/486
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/refine-116-claude/inputs
cases=()
for switch in 0 1 2 3; do
    for input in sqlite main long-lines spliced; do
        cases+=("$tree:$input:$switch")
    done
done
cat > "$root/review4-round.sh" <<'ROUND'
#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r tree input switch <<< "$spec"
    echo "== round $round case $tree:$input:main$switch $(date +%T)"
    case "$input" in
        sqlite) BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$inputs/sqlite3.c" 2>&1 ;;
        main) (cd "$inputs/mainc" && BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1) ;;
        *) BUSTER_451_MAIN=$switch taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "$root/review-inputs/$input.c" 2>&1 ;;
    esac
    echo "== status $?"
done
ROUND
chmod +x "$root/review4-round.sh"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$root/review4-round.sh" "$root" "$inputs" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
