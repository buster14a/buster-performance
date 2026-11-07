#!/bin/bash
# ab-grants.sh A B OUT ROUNDS -- ARGUMENT...: interleaved A/B of `-c`-style compiles by tree A's and tree B's compilers,
# one grant of the 9700X's lock per measured compiler process (exclusive.sh), CPU 2. Each run is
# `perf stat -x,` of the compiler with `--time-stages`, its object written to its own file. For every run it keeps the
# lock's owner line as the run saw it (positive receipt), the exact command, the exit status, perf's output, the stage
# report and the object's SHA-256. Rounds alternate the order. It fails (exit 1) on any run that didn't complete or whose
# object differs from A's first.
set -u
a=$1 b=$2 out=$3 rounds=$4
shift 4
[ "$1" = "--" ] && shift
base=~/buster-fast-bench/628-claude-tesla
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: per-process A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
events=task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults
sha256sum "$base/$a/build/compiler" "$base/$b/build/compiler" > "$out/binaries.sha256"
printf '%s\n' "$@" > "$out/arguments.txt"
failed=0
reference=""
for round in $(seq 1 "$rounds"); do
    if [ $((round % 2)) = 1 ]; then order="A B"; else order="B A"; fi
    for v in $order; do
        if [ $v = A ]; then tree=$a; else tree=$b; fi
        exe="$base/$tree/build/compiler"
        run="$out/$v-$round"
        printf '%q ' taskset -c 2 perf stat -x, -e "$events" -o "$run.perf" -- "$exe" "$@" --time-stages -o "$run.o" > "$run.command"
        ~/buster-fast-bench/exclusive.sh bash -c '
            run=$1; exe=$2; events=$3; shift 3
            cat /var/lib/buster-9700x/owner > "$run.owner"
            taskset -c 2 perf stat -x, -e "$events" -o "$run.perf" -- "$exe" "$@" --time-stages -o "$run.o" 2> "$run.stages"
            echo $? > "$run.status"' grant "$run" "$exe" "$events" "$@" > "$run.lock" 2>&1
        status=$(cat "$run.status" 2>/dev/null || echo missing)
        sum=$(sha256sum "$run.o" 2>/dev/null | cut -d' ' -f1)
        echo "$sum" > "$run.o.sha256"
        rm -f "$run.o"
        reference=${reference:-$sum}
        if [ "$status" != 0 ] || [ -z "$sum" ] || [ "$sum" != "$reference" ] || ! grep -q "claude-628-tesla" "$run.owner"; then
            echo "run $v $round: status $status, object $sum, owner $(head -1 "$run.owner" 2>/dev/null)" >> "$out/failures.txt"
            failed=1
        fi
    done
done
summarize() {
    awk -F, -v v=$1 '$3 ~ /^instructions:u/ { i[++n] = $1 } $3 ~ /^cycles:u/ { c[++m] = $1 } $3 ~ /^task-clock/ { t[++k] = $1 } $3 ~ /^cycles:k/ { kc[++q] = $1 } $3 ~ /^page-faults/ { pf[++p] = $1 }
        END { printf "%s: task-clock %.3f ms, cycles:u %.2f M, instructions:u %.2f M, cycles:k %.2f M, faults %d (medians of %d runs)\n", v, med(t, k), med(c, m) / 1e6, med(i, n) / 1e6, med(kc, q) / 1e6, med(pf, p), k }
        function med(a, n,   i, j, x) { for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { x = a[i]; a[i] = a[j]; a[j] = x } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }' "$out"/$1-*.perf
    for f in "$out"/$1-*.stages; do awk -F'\t' '$2 == "peak-rss-kb" { print $3 }' "$f"; done | sort -n | awk -v v=$1 '{ a[++n] = $1 } END { printf "%s: peak-rss-kb median %d (min %d, max %d, %d runs)\n", v, n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2, a[1], a[n], n }'
}
summarize A > "$out/summary.txt"
summarize B >> "$out/summary.txt"
for r in $(seq 1 "$rounds"); do
    printf 'round %s: ' $r
    for v in A B; do awk -F, -v v=$v '$3 ~ /^task-clock/ { printf "%s %.2f ms  ", v, $1 }' "$out/$v-$r.perf"; done
    echo
done >> "$out/summary.txt"
cat "$out/summary.txt"
[ $failed = 0 ] && echo "all runs complete, every object the same" || { echo "FAILED runs:"; cat "$out/failures.txt"; }
exit $failed
