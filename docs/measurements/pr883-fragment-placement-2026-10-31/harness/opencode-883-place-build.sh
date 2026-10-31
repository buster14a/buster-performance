#!/usr/bin/env bash
# Build one source tree's compiler objects and link the same objects at several
# .text base addresses. The normal link must reproduce build/compiler byte for
# byte; each shifted link moves every .text address by SHIFT bytes.
set -euo pipefail
tree=$1
out=$2
cd "$tree"
shift 2
shifts=("$@")
jobs=${JOBS:-8}
clang=${CLANG:-clang}
linker=${LINKER:-/usr/bin/wild}
mkdir -p "$out/objects"
mapfile -d '' flags < <("$tree/build.sh" print-compile-flags)
mapfile -d '' sources < <("$tree/build.sh" print-sources)
printf '%s\0' "${flags[@]}" > "$out/flags.nul"
printf '%s\0' "${sources[@]}" > "$out/sources.nul"
pids=()
statuses=()
for i in "${!sources[@]}"; do
    [ -s "$out/objects/$i.o" ] && continue
    "$clang" -c "${sources[$i]}" -o "$out/objects/$i.o" -MJ "$out/objects/$i.json" "${flags[@]}" &
    pids[$i]=$!
    if [ "${#pids[@]}" -ge "$jobs" ]; then
        # Wait for the oldest running compile.
        for j in "${!pids[@]}"; do
            if [ -n "${pids[$j]}" ]; then
                wait "${pids[$j]}" || { echo "place-build: compile $j failed" >&2; exit 1; }
                pids[$j]=""
                break
            fi
        done
    fi
done
for j in "${!pids[@]}"; do
    [ -n "${pids[$j]}" ] && { wait "${pids[$j]}" || { echo "place-build: compile $j failed" >&2; exit 1; }; }
done
objects=()
for i in "${!sources[@]}"; do
    objects+=("$out/objects/$i.o")
done
# The normal link: no placement override.
"$clang" -no-pie --ld-path="$linker" "${objects[@]}" -lm -ldl -o "$out/compiler-0"
if [ -x "$tree/build/compiler" ]; then
    if ! cmp -s "$tree/build/compiler" "$out/compiler-0"; then
        echo "place-build: normal relink differs from build/compiler" >&2
        exit 1
    fi
fi
# Every other placement moves .text itself; find its normal address first.
text_addr=$(readelf -SW "$out/compiler-0" | awk '$0 ~ /\] \.text / { if (!found) { print $5; found = 1 } }')
text_addr=0x$(printf '%x' "0x$text_addr")
[ -n "$text_addr" ] || { echo "place-build: no .text address" >&2; exit 1; }
for shift in "${shifts[@]}"; do
    [ "$shift" = 0 ] && continue
    addr=$(printf '0x%x' $((text_addr + shift)))
    "$clang" -no-pie --ld-path="$linker" -Wl,--section-start=.text="$addr" "${objects[@]}" -lm -ldl -o "$out/compiler-$shift"
    got=$(readelf -SW "$out/compiler-$shift" | awk '$0 ~ /\] \.text / { if (!found) { print $5; found = 1 } }')
    got=0x$(printf '%x' "0x$got")
    [ $((got)) -eq $((text_addr + shift)) ] || { echo "place-build: shift $shift gave .text $got, wanted $addr" >&2; exit 1; }
done
{
    printf 'text=%s\n' "$text_addr"
    for symbol in check_lower_drain check_lower_batch_classify check_lower_fragment check_program_emit; do
        printf '%s' "$symbol"
        for shift in "${shifts[@]}"; do
            file="$out/compiler-$shift"
            value=$(nm -n "$file" | awk -v s="$symbol" '$3 == s { print $1; exit }')
            printf '\t%s=%s' "$shift" "${value:-missing}"
        done
        printf '\n'
    done
} > "$out/addresses.tsv"
cat "$out/addresses.tsv"
