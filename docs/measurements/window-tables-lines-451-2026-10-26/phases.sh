#!/usr/bin/env bash
# #451 parts 2 and 3: benchmark-preprocessor --only vectorized's phases, and the screening builds' sub-phases of the
# directive tables and lexed bytes (printed at exit), with windows and whole (--window-bytes 2000000000), on #408's
# frozen sqlite3.c and main.c, pinned to CPU 2. ROUNDS rounds of every tree, input and variant as a process each, in an
# order that rotates by round; one hold of the shared lock per round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="$1"
shift
export EXCLUSIVE_OWNER=claude-perf-451 EXCLUSIVE_TITLE="#451 parts 2-3: windowed directive tables, long spliced lines" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/451
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/refine-116-claude/inputs
cases=()
for tree in "$@"; do
    for input in sqlite main; do
        for variant in windows whole; do
            cases+=("$tree:$input:$variant")
        done
    done
done
cat > "$root/phases-round.sh" <<'ROUND'
#!/usr/bin/env bash
root="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r tree input variant <<< "$spec"
    extra=()
    [ "$variant" = whole ] && extra=(--window-bytes 2000000000)
    echo "== round $round case $spec $(date +%T)"
    if [ "$input" = sqlite ]; then
        taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "$inputs/sqlite3.c" 2>&1
    else
        (cd "$inputs/mainc" && taskset -c 2 "$root/$tree/build/compiler" benchmark-preprocessor --only vectorized "${extra[@]}" -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1)
    fi
    echo "== status $?"
done
ROUND
chmod +x "$root/phases-round.sh"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$root/phases-round.sh" "$root" "$inputs" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
