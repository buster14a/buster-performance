#!/usr/bin/env bash
# #456: benchmark-check-debug's emission, without and with the raw rows, in each tree (and the screening tree's
# variants, BUSTER_456_VARIANT), pinned to CPU 2. ROUNDS rounds; each round is one hold of the shared lock running
# every case once as a process of its own, in an order that rotates by round.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
rounds="${1:-5}"
shift
export EXCLUSIVE_OWNER=claude-perf-456 EXCLUSIVE_TITLE="#456 debug-row emission overhead" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/456
export TMPDIR="$root/tmp"
mkdir -p "$TMPDIR"
cases=("$@")
round_script="$root/round.sh"
cat > "$round_script" <<'ROUND'
#!/usr/bin/env bash
root="$1"; round="$2"; shift 2
for spec in "$@"; do
    tree="${spec%%:*}"; variant="${spec#*:}"
    [ "$variant" = "$spec" ] && variant=""
    echo "== round $round case $spec $(date +%T)"
    (cd "$root/$tree" && env ${variant:+BUSTER_456_VARIANT=$variant} taskset -c 2 ./build/compiler benchmark-check-debug --only emit --runs 101 2>&1)
    echo "== status $?"
done
ROUND
chmod +x "$round_script"
n=${#cases[@]}
for ((r = 0; r < rounds; r += 1)); do
    order=()
    for ((i = 0; i < n; i += 1)); do order+=("${cases[$(( (i + r) % n ))]}"); done
    ~/buster-fast-bench/exclusive.sh "$round_script" "$root" "$r" "${order[@]}"
    sleep 20
done
echo "== done $(date +%T)"
