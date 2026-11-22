#!/usr/bin/env bash
# #3070 step 1: one round per lock hold. usage: measure.sh ROUNDS OUTDIR LABEL=COMPILER...
# Each round, under one hold: for each build in a rotated order, 1,336 empty units (one lane), musl's 1,336 units on
# one lane and on four, Lua's 34 units on one lane: perf stat user and kernel cycles, user instructions, faults.
set -u
D=$HOME/buster-fast-bench/3070-claude
rounds=$1; out=$2; shift 2
builds=("$@")
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do b=${f##*/}; if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi; done
lua=("$D"/lua/src/*.c)
luaopts=(-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
export LC_ALL=C
work=/dev/shm/3070-claude
events=cycles:u,cycles:k,instructions:u,page-faults,task-clock
cat > "$out/round.sh" <<'INNER'
#!/usr/bin/env bash
set -u
out=$1 round=$2 work=$3 events=$4; shift 4
. "$out/vars.sh"
{ uname -r; cat /proc/loadavg; } > "$out/host-$round.txt"
run() { # LABEL BUILD CPUS ARGS...
    local label=$1 build=$2 cpus=$3; shift 3
    rm -rf "$work/o"; mkdir -p "$work/o"
    (cd "$work/o" && perf stat -x, -e "$events" -o "$out/perf-$label-$build.$round.csv" -- taskset -c "$cpus" "$@" > /dev/null 2> "$out/err-$label-$build.$round.txt")
    echo "$label $build round $round status $?" >> "$out/status.txt"
}
n=${#builds[@]}
for ((k = 0; k < n; k += 1)); do
    i=$(( (k + round) % n )); b=${builds[$i]}; name=${b%%=*}; C=${b#*=}
    run empty $name 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c
    run musl1 $name 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}"
    run musl4 $name 2,3,4,5 "$C" -c --lanes 4 "${opts[@]}" "${units[@]}"
    run lua1 $name 2 "$C" -c --lanes 1 "${luaopts[@]}" "${lua[@]}"
done
INNER
chmod +x "$out/round.sh"
{ declare -p D opts units lua luaopts builds; } > "$out/vars.sh"
export EXCLUSIVE_OWNER=claude-3070 EXCLUSIVE_TITLE="#3070 step 1: warm lanes, root image" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
for ((r = 1; r <= rounds; r += 1)); do
    timeout 600 ~/buster-fast-bench/exclusive.sh "$out/round.sh" "$out" "$r" "$work" "$events" 2>> "$out/exclusive.txt"
done
echo "measure done" >> "$out/status.txt"
