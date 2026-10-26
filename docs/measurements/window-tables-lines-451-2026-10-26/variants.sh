#!/usr/bin/env bash
# #451 part 2: the screening build's switches (BUSTER_451_VARIANT: 1 the places by vpcompressb, 2 the finish's prefetch),
# benchmark-preprocessor --only vectorized's phases and sub-phases, windowed and whole, on #408's frozen sqlite3.c and
# main.c, pinned to CPU 2. ROUNDS rounds of every case as a process each, rotating; one hold of the lock per round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="$1"
tree="$2"
export EXCLUSIVE_OWNER=claude-perf-451 EXCLUSIVE_TITLE="#451 parts 2-3: windowed directive tables, long spliced lines" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/451
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
inputs=/home/david/buster-fast-bench/refine-116-claude/inputs
cases=()
for input in sqlite main; do
    for spec in windows:0 windows:1 windows:2 windows:3 whole:0 whole:2; do
        cases+=("$input:$spec")
    done
done
cat > "$root/variants-round.sh" <<'ROUND'
#!/usr/bin/env bash
compiler="$1"; inputs="$2"; round="$3"; shift 3
for spec in "$@"; do
    IFS=: read -r input variant switch <<< "$spec"
    extra=()
    [ "$variant" = whole ] && extra=(--window-bytes 2000000000)
    echo "== round $round case $spec $(date +%T)"
    if [ "$input" = sqlite ]; then
        BUSTER_451_VARIANT=$switch taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "${extra[@]}" "$inputs/sqlite3.c" 2>&1
    else
        (cd "$inputs/mainc" && BUSTER_451_VARIANT=$switch taskset -c 2 "$compiler" benchmark-preprocessor --only vectorized "${extra[@]}" -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c 2>&1)
    fi
    echo "== status $?"
done
ROUND
chmod +x "$root/variants-round.sh"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$root/variants-round.sh" "$root/$tree/build/compiler" "$inputs" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
