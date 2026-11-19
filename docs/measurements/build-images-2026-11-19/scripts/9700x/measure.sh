#!/usr/bin/env bash
# One hold of the 9700X's lock: what a build's units cost with and without their headers' work (the reduced units'
# emulation), on 1 and 4 lanes; per-unit fixed cost (empty units); a process's floor; the image kernels on 1 and 4 lanes.
set -u
D=$HOME/buster-fast-bench/build-images-claude
C=$D/tree/build/compiler
R=$D/results/$(date -u +%Y%m%dT%H%M%S)
mkdir -p "$R"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
opts=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic"
    -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal"
    -I "$corpus/musl-generated/obj/include" -I "$musl/include")
declare -A seen
units=()
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; units+=("$f"); fi
done
export LC_ALL=C
lua=("$D"/lua/src/*.c)
work=/dev/shm/build-images-claude
rm -rf "$work"; mkdir -p "$work/o"
# The reduced units, made here from this build's own -E output (reduce.py: a unit's own items and the header items its
# own code reaches by name), named as their originals.
mkdir -p "$work/musl-i" "$work/musl-red" "$work/musl-red2" "$work/lua-i" "$work/lua-red" "$work/lua-red2"
for u in "${units[@]}"; do e=$(echo "$u" | sed 's|.*/src/||; s|/|_|g'); "$C" -E "${opts[@]}" -o "$work/musl-i/$e.i" "$u"; done
for f in "${lua[@]}"; do "$C" -E -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$work/lua-i/${f##*/}.i" "$f"; done
python3 -I "$D/census/reduce.py" "$work/musl-red" "$work/musl-i"/*.i > "$R/musl-red.tsv" 2> "$R/musl-red-total.txt"
python3 -I "$D/census/reduce.py" "$work/lua-red" "$work/lua-i"/*.i > "$R/lua-red.tsv" 2> "$R/lua-red-total.txt"
for u in "${units[@]}"; do e=$(echo "$u" | sed 's|.*/src/||; s|/|_|g'); cp "$work/musl-red/$e.c" "$work/musl-red2/${u##*/}"; done
for f in "${lua[@]}"; do cp "$work/lua-red/${f##*/}.c" "$work/lua-red2/${f##*/}"; done
reds=("$work"/musl-red2/*.c)
luareds=("$work"/lua-red2/*.c)
{ echo "units ${#units[@]} reduced ${#reds[@]} lua ${#lua[@]} lua-reduced ${#luareds[@]}"; uname -r; cat /proc/loadavg;
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$R/host-before.txt" 2>&1
events=cycles:u,cycles:k,instructions:u,instructions:k,page-faults,task-clock
run() { # LABEL CPUS ARGS...
    local label=$1 cpus=$2; shift 2
    rm -f "$work"/o/*.o
    (cd "$work/o" && perf stat -x, -e "$events" -o "$R/perf-$label.$round.csv" -- taskset -c "$cpus" "$@" > /dev/null 2> "$R/err-$label.$round.txt")
    echo "$label round $round status $?" >> "$R/status.txt"
}
for round in 1 2 3 4 5; do
    run musl-orig-1 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}"
    run musl-red-1 2 "$C" -c --lanes 1 -std=c99 -ffreestanding -w "${reds[@]}"
    run musl-orig-4 2,3,4,5 "$C" -c --lanes 4 "${opts[@]}" "${units[@]}"
    run musl-red-4 2,3,4,5 "$C" -c --lanes 4 -std=c99 -ffreestanding -w "${reds[@]}"
    run lua-orig-1 2 "$C" -c --lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "${lua[@]}"
    run lua-red-1 2 "$C" -c --lanes 1 -std=gnu99 -O2 -w "${luareds[@]}"
    run lua-orig-4 2,3,4,5 "$C" -c --lanes 4 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "${lua[@]}"
    run lua-red-4 2,3,4,5 "$C" -c --lanes 4 -std=gnu99 -O2 -w "${luareds[@]}"
    run musl-empty-1 2 "$C" -c --lanes 1 "${opts[@]}" "$D"/empty/*.c
done
# The objects of the last round's reduced units against the originals': .text, .data, .rodata.
rm -rf "$work/a" "$work/b"; mkdir -p "$work/a" "$work/b"
(cd "$work/a" && taskset -c 2 "$C" -c --lanes 1 "${opts[@]}" "${units[@]}" 2> /dev/null)
(cd "$work/b" && taskset -c 2 "$C" -c --lanes 1 -std=c99 -ffreestanding -w "${reds[@]}")
same=0; differ=0
for o in "$work/a"/*.o; do b=${o##*/}; for s in .text .data .rodata; do
    x=$(objcopy -O binary --only-section=$s "$o" /dev/stdout 2> /dev/null | sha1sum); y=$(objcopy -O binary --only-section=$s "$work/b/$b" /dev/stdout 2> /dev/null | sha1sum)
    if [[ "$x" == "$y" ]]; then same=$((same+1)); else differ=$((differ+1)); fi; done; done
echo "musl sections same $same differ $differ" > "$R/objects.txt"
rm -rf "$work/a" "$work/b"; mkdir -p "$work/a" "$work/b"
(cd "$work/a" && taskset -c 2 "$C" -c --lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "${lua[@]}" 2> /dev/null)
(cd "$work/b" && taskset -c 2 "$C" -c --lanes 1 -std=gnu99 -O2 -w "${luareds[@]}")
same=0; differ=0
for o in "$work/a"/*.o; do b=${o##*/}; for s in .text .data .rodata; do
    x=$(objcopy -O binary --only-section=$s "$o" /dev/stdout 2> /dev/null | sha1sum); y=$(objcopy -O binary --only-section=$s "$work/b/$b" /dev/stdout 2> /dev/null | sha1sum)
    if [[ "$x" == "$y" ]]; then same=$((same+1)); else differ=$((differ+1)); fi; done; done
echo "lua sections same $same differ $differ" >> "$R/objects.txt"
# A process's floor: a static process that only exits, /usr/bin/true, and the compiler's -c of an empty file.
cc -O2 -static -nostdlib -o "$work/tiny" "$D/spawn/tiny.c" && cc -O2 -o "$work/spawnbench" "$D/spawn/spawnbench.c"
(cd "$work/o" && for p in tiny true; do taskset -c 2 "$work/spawnbench" 3000 $([[ $p == tiny ]] && echo "$work/tiny" || echo /usr/bin/true); done;
 taskset -c 2 "$work/spawnbench" 1000 "$C" -c "${opts[@]}" "$D/empty/e1.c") > "$R/spawn.txt" 2>&1
# A process a unit, one after another, as a build tool runs them on one core: one round each.
for label in orig red; do
    rm -f "$work"/o/*.o
    if [[ $label == orig ]]; then
        (cd "$work/o" && perf stat -x, -e "$events" -o "$R/perf-musl-process-$label.csv" -- taskset -c 2 bash -c 'for u; do "'"$C"'" -c '"$(printf '%q ' "${opts[@]}")"' "$u" 2>/dev/null || exit 1; done' _ "${units[@]}")
    else
        (cd "$work/o" && perf stat -x, -e "$events" -o "$R/perf-musl-process-$label.csv" -- taskset -c 2 bash -c 'for u; do "'"$C"'" -c -std=c99 -ffreestanding -w "$u" || exit 1; done' _ "${reds[@]}")
    fi
    echo "process-$label status $?" >> "$R/status.txt"
done
# The image kernels: 1 lane on CPU 2, 4 lanes on CPUs 2-5; observed names an image from the census.
cc -O2 -march=native -pthread -o "$work/image_kernels" "$D/kernels/image_kernels.c"
for obs in ${OBSERVED:-12 51 160}; do
    taskset -c 2 "$work/image_kernels" 1 2 "$obs" 22 37 256 600 20000 >> "$R/kernels.txt" 2>&1
    taskset -c 2,3,4,5 "$work/image_kernels" 4 2,3,4,5 "$obs" 22 37 256 600 20000 >> "$R/kernels.txt" 2>&1
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$R/host-after.txt" 2>&1
rm -rf "$work"
echo "results $R"
