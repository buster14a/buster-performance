#!/usr/bin/env bash
# #3070 step 2: the headers' work with the root image. usage: emul.sh ROUNDS BINARY OUT   (takes the lock itself, a round a hold)
# musl's 1,336 units on one lane: as they are, with -w, and the reduced units (build-images-2026-11-19's reduce.py) with -w and without.
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
rounds=$1; C=$2; out=$3
mkdir -p "$out"
cat > "$out/round.sh" <<'INNER'
#!/usr/bin/env bash
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
C=$1; out=$2; round=$3
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi; done
reds=("$D"/red/c/*.c)
export LC_ALL=C
work=/dev/shm/3070-claude-euler-emul
events=cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
run() { # LABEL COMMAND...
    local label=$1; shift
    rm -rf "$work"; mkdir -p "$work"
    (cd "$work" && perf stat -x, -e "$events" -o "$out/perf-$label.$round.csv" -- taskset -c 2 "$@" > /dev/null 2> "$out/err-$label.$round.txt")
    echo "$label round $round status $? objects $(ls "$work" | wc -l)" >> "$out/status.txt"
}
order=(full fullw red redw)
for ((k = 0; k < 4; k += 1)); do
    case ${order[$(( (k + round) % 4 ))]} in
        full) run full "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" ;;
        fullw) run fullw "$C" -c --lanes 1 -w "${opts[@]}" "${units[@]}" ;;
        red) run red "$C" -c --lanes 1 -std=c99 -ffreestanding "${reds[@]}" ;;
        redw) run redw "$C" -c --lanes 1 -std=c99 -ffreestanding -w "${reds[@]}" ;;
    esac
done
INNER
chmod +x "$out/round.sh"
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 2: where the headers' work goes" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
for ((r = 1; r <= rounds; r += 1)); do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 "$out/round.sh" "$C" "$out" "$r" 2>> "$out/exclusive.txt"
done
echo "emul done" >> "$out/status.txt"
