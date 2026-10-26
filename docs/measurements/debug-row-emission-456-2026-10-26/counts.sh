#!/usr/bin/env bash
# #456: user instructions and cycles of the emission, without the raw rows (--path scalar) and with them (--path vector),
# per emission: the difference between --runs 30 and --runs 10 over 20. One hold of the shared lock, pinned to CPU 2.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
export EXCLUSIVE_OWNER=claude-perf-456 EXCLUSIVE_TITLE="#456 debug-row emission overhead" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/456
export TMPDIR="$root/tmp"
mkdir -p "$TMPDIR"
cat > "$root/counts-round.sh" <<'ROUND'
#!/usr/bin/env bash
root="$1"; shift
for spec in "$@"; do
    tree="${spec%%:*}"; variant="${spec#*:}"
    [ "$variant" = "$spec" ] && variant=""
    for path in scalar vector; do
        for runs in 10 30; do
            line=$(cd "$root/$tree" && env ${variant:+BUSTER_456_VARIANT=$variant} perf stat -x, -e instructions:u,cycles:u taskset -c 2 ./build/compiler benchmark-check-debug --only emit --path $path --runs $runs 2>&1 >/dev/null | grep -E "instructions|cycles" | cut -d, -f1 | tr '\n' ' ')
            echo "counts $spec $path $runs $line"
        done
    done
done
ROUND
chmod +x "$root/counts-round.sh"
~/buster-fast-bench/exclusive.sh "$root/counts-round.sh" "$root" "$@"
echo "== done $(date +%T)"
