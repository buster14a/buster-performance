#!/usr/bin/env bash
# #3070 step 2b: what attested header definitions would leave. usage: emul2.sh ROUNDS BINARY OUT   (a round a hold of the lock)
# musl's 1,336 units on one lane as preprocessed text: every item (all), without the header function definitions the
# unit's code doesn't reach (defs), the same with the two definitions that warn kept wherever they are (kept), and
# build-images-2026-11-19's reduced units (red); each with -w too.
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
rounds=$1; C=$2; out=$3
mkdir -p "$out"
cat > "$out/round.sh" <<'INNER'
#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2; round=$3
export LC_ALL=C
work=/dev/shm/3070-claude-euler-emul2
events=cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
run() { # LABEL COMMAND...
    local label=$1; shift
    rm -rf "$work"; mkdir -p "$work"
    (cd "$work" && perf stat -x, -e "$events" -o "$out/perf-$label.$round.csv" -- taskset -c 2 "$@" > /dev/null 2> "$out/err-$label.$round.txt")
    echo "$label round $round status $? objects $(ls "$work" | wc -l)" >> "$out/status.txt"
}
order=(all defs kept red all-w defs-w kept-w red-w)
for ((k = 0; k < 8; k += 1)); do
    name=${order[$(( (k + round) % 8 ))]}
    dir=${name%-w}; w=(); [ "$name" != "$dir" ] && w=(-w)
    case $dir in all) units=("$D"/red2/all/*.c) ;; defs) units=("$D"/red2/defs/*.c) ;; kept) units=("$D"/red2/defsw/*.c) ;; red) units=("$D"/red/c/*.c) ;; esac
    run $name "$C" -c --lanes 1 -std=c99 -ffreestanding "${w[@]}" "${units[@]}"
done
INNER
chmod +x "$out/round.sh"
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 2b: what attested header definitions would leave" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
for ((r = 1; r <= rounds; r += 1)); do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 "$out/round.sh" "$C" "$out" "$r" 2>> "$out/exclusive.txt"
done
echo "emul2 done" >> "$out/status.txt"
