#!/usr/bin/env bash
# #3070: a process a unit, which the root image must leave as it was. usage: single.sh ROUNDS OUTDIR LABEL=COMPILER...
# Each round, under one hold of the lock: for each compiler in a rotated order, 300 commands of one empty unit each
# (musl's options, -c) and 100 of one musl unit each, on CPU 2: perf stat of the loop, user and kernel cycles.
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
rounds=$1; out=$2; shift 2
builds=("$@")
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
units=("$musl"/src/string/*.c)
units=("${units[@]:0:100}")
export LC_ALL=C
work=/dev/shm/3070-claude-euler-single
cat > "$out/loop.sh" <<'INNER'
#!/usr/bin/env bash
# usage: loop.sh COMPILER KIND   (run inside perf stat)
. "$(dirname "$0")/vars.sh"
C=$1
if [ "$2" = empty ]; then for ((i = 1; i <= 300; i += 1)); do "$C" -c "${opts[@]}" "$D/empty/e$i.c"; done
else for u in "${units[@]}"; do "$C" -c "${opts[@]}" "$u" 2> /dev/null; done; fi
INNER
cat > "$out/round.sh" <<'INNER'
#!/usr/bin/env bash
set -u
out=$1 round=$2 work=$3; shift 3
. "$out/vars.sh"
{ uname -r; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } > "$out/host-$round.txt"
n=${#builds[@]}
for ((k = 0; k < n; k += 1)); do
    i=$(( (k + round) % n )); b=${builds[$i]}; name=${b%%=*}; C=${b#*=}
    for kind in empty musl; do
        rm -rf "$work/o"; mkdir -p "$work/o"
        (cd "$work/o" && perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o "$out/perf-$kind-$name.$round.csv" -- taskset -c 2 bash "$out/loop.sh" "$C" $kind)
        echo "$kind $name round $round status $?" >> "$out/status.txt"
        (cd "$work/o" && cat *.o | sha256sum | cut -c1-16) > "$out/sum-$kind-$name.$round.txt" 2>&1
    done
done
INNER
chmod +x "$out/round.sh" "$out/loop.sh"
{ declare -p D opts units builds; } > "$out/vars.sh"
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 1: the root image" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
for ((r = 1; r <= rounds; r += 1)); do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 900 "$out/round.sh" "$out" "$r" "$work" 2>> "$out/exclusive.txt"
done
echo "single done" >> "$out/status.txt"
