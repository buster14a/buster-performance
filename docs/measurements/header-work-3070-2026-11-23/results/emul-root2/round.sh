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
