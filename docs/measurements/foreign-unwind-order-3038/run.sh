#!/usr/bin/env bash
set -euo pipefail
q=$(cd -- "$(dirname -- "$0")" && pwd)
out="$RUNNER_TEMP/unwind3038"
inputs="$out/inputs"
mkdir -p "$inputs"
printf "%s\n" src/buster/compiler/foreign_unwind.c > "$inputs/paths"
git rev-parse HEAD
./build.sh print-compile-flags --config Release | tr '\0' '\n' > "$out/flags"
sha256sum "$out/flags"
flags=(-O1 -fPIC -ffunction-sections -fdata-sections -fasynchronous-unwind-tables)
g++ -std=c++17 "${flags[@]}" -fno-inline -c "$q/sort_a.cc" -o "$inputs/sort_a.o"
g++ -std=c++17 "${flags[@]}" -fno-inline -c "$q/sort_b.cc" -o "$inputs/sort_b.o"
gcc -std=gnu17 "${flags[@]}" -c tools/ci/changes.c -o "$inputs/changes.o"
sha256sum "$inputs"/*.o | tee "$out/inputs.sha256"
for o in "$inputs"/*.o; do
    readelf -Wr "$o" > "$o.relocations"
    readelf -wf "$o" > "$o.frames"
    echo "INPUT $(basename "$o")"
    grep 'rela.eh_frame' "$o.relocations"
    awk '/^Relocation section / { use = ($3 == "\047.rela.eh_frame\047") } use && $1 ~ /^[[:xdigit:]]+$/ {
        k = "x" $1; if (seen && k < prev) inversions++; if (seen && k == prev) ties++; prev=k; seen++
    } END { print "eh_frame relas", seen, "adjacent inversions", inversions+0, "ties", ties+0; exit !seen }' "$o.relocations"
    printf 'CIEs %s FDEs %s\n' "$(grep -c ' CIE' "$o.frames")" "$(grep -c ' FDE cie=' "$o.frames")"
done
# Reverse just the .rela.eh_frame entries of the losing C++ object as an unordered control.
read -r hex_offset hex_size < <(readelf -WS "$inputs/sort_b.o" | awk '{for(i=1;i<=NF;i++) if($i==".rela.eh_frame" && $(i+1)=="RELA") print $(i+3), $(i+4)}')
offset=$((16#$hex_offset))
size=$((16#$hex_size))
test "$size" -gt 24 && test "$((size % 24))" = 0
cp "$inputs/sort_b.o" "$inputs/reversed.o"
for ((i=size-24; i>=0; i-=24)); do
    dd if="$inputs/sort_b.o" bs=1 skip="$((offset+i))" count=24 status=none
done > "$inputs/reversed.rela"
dd if="$inputs/reversed.rela" of="$inputs/reversed.o" bs=1 seek="$offset" conv=notrunc status=none
gccdir=$(dirname "$(gcc -print-libgcc-file-name)")
libdir=$(dirname "$(gcc -print-file-name=libc.so)")
begin=(-pie --eh-frame-hdr "$(gcc -print-file-name=Scrt1.o)" "$(gcc -print-file-name=crti.o)" "$(gcc -print-file-name=crtbeginS.o)")
end=(-L "$gccdir" -L "$libdir" -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed "$(gcc -print-file-name=crtendS.o)" "$(gcc -print-file-name=crtn.o)")
build()
{
    echo "BUILD $1"
    ./build.sh --config Release --jobs "$(nproc)" > "$out/$1.build" 2>&1 || { tail -100 "$out/$1.build"; return 1; }
}
capture()
{
    local version=$1 workload=$2 sub="$out/$1-$2" rc=0
    local -a args
    if [ "$workload" != changes ]; then
        local second="$inputs/sort_b.o"
        if [ "$workload" = reverse ]; then second="$inputs/reversed.o"; fi
        args=("$inputs/sort_a.o" "$second" -L "$gccdir" -L "$libdir" -lstdc++ -lm)
    else
        args=(--gc-sections "$inputs/changes.o")
    fi
    UNWIND_PLAN="$sub.plan" build/compiler link-foreign --lanes 1 -o "$sub.elf" "${begin[@]}" "${args[@]}" "${end[@]}" 2>"$sub.counts" || rc=$?
    cat "$sub.counts"
    test "$rc" = 0
    if [ "$version" = clean ]; then
        cmp "$out/base-$workload.elf" "$sub.elf"
    else
        test -s "$sub.plan"
        grep -q '^PRUNE ' "$sub.counts"
        sha256sum "$sub.plan"
    fi
    readelf -wf "$sub.elf" > "$sub.frames"
    objcopy -O binary --only-section=.eh_frame "$sub.elf" "$sub.eh"
    objcopy -O binary --only-section=.eh_frame_hdr "$sub.elf" "$sub.hdr"
    objcopy -O binary --only-section=.text "$sub.elf" "$sub.text"
    readelf -Wr "$sub.elf" > "$sub.relocs"
    if [ "$workload" != changes ]; then
        rc=0
        "$sub.elf" > "$sub.stdout" 2> "$sub.stderr" || rc=$?
        test "$rc" = 42
        echo "$workload exit $rc"
    else
        "$sub.elf" --event merge_group --files "$inputs/paths" --workflow .github/workflows/9700x.yml --root . --output "$sub.outputs" > "$sub.stdout" 2> "$sub.stderr" || { cat "$sub.stderr"; return 1; }
        echo "changes selector exit 0"
    fi
    sha256sum "$sub".{elf,eh,hdr,text,frames,relocs}
}
for linker in bfd lld; do
    g++ -fuse-ld="$linker" "$inputs/sort_a.o" "$inputs/sort_b.o" -o "$out/$linker.sort"
    gcc -fuse-ld="$linker" -Wl,--gc-sections "$inputs/changes.o" -o "$out/$linker.changes"
    code=0
    "$out/$linker.sort" || code=$?
    test "$code" = 42
    "$out/$linker.changes" --event merge_group --files "$inputs/paths" --workflow .github/workflows/9700x.yml --root . --output "$out/$linker.outputs"
    echo "$linker: sort exit 42, selector exit 0"
done
if [ -f "$q/head.patch" ]; then
    git apply --include='src/buster/compiler/foreign_unwind_test.c' "$q/head.patch"
fi
git apply "$q/base-probe.patch"
build base-instrumented
if [ -f "$q/head.patch" ]; then
    mkdir "$out/base-foreign"
    build/compiler test-foreign --cross-check --directory "$out/base-foreign" --keep > "$out/base.foreign" 2>&1 || { cat "$out/base.foreign"; exit 1; }
    cat "$out/base.foreign"
fi
capture base sort
capture base reverse
capture base changes
if [ ! -f "$q/head.patch" ]; then exit 0; fi
git apply -R "$q/base-probe.patch"
git apply --include='src/buster/compiler/foreign_unwind.c' "$q/head.patch"
build head-clean
mkdir "$out/full-foreign"
build/compiler test-foreign --cross-check --directory "$out/full-foreign" --keep > "$out/head.foreign" 2>&1 || { cat "$out/head.foreign"; exit 1; }
cat "$out/head.foreign"
for workload in sort reverse changes; do capture clean "$workload"; done
git apply "$q/head-probe.patch"
build head-instrumented
for workload in sort reverse changes; do
    capture head "$workload"
    for ext in plan elf eh hdr text frames relocs stdout stderr; do
        cmp "$out/base-$workload.$ext" "$out/head-$workload.$ext"
    done
done
cmp "$out/base-changes.outputs" "$out/head-changes.outputs"
cmp "$out/bfd.outputs" "$out/head-changes.outputs"
cmp "$out/lld.outputs" "$out/head-changes.outputs"
before=$(find "$out/base-foreign" -name fw_runtime_output_1_1 -print -quit)
after=$(find "$out/full-foreign" -name fw_runtime_output_1_1 -print -quit)
cmp "$before" "$after"
readelf -wf "$before" > "$out/base-throw.frames"
readelf -wf "$after" > "$out/head-throw.frames"
cmp "$out/base-throw.frames" "$out/head-throw.frames"
sha256sum "$before" "$after" "$out/head-throw.frames"
sha256sum -c "$out/inputs.sha256"
for workload in sort changes; do
    awk '
        $1 == "PRUNE" {
            g = (FILENAME == ARGV[1]) ? 1 : 2
            for(i=2;i<=NF;i++) { split($i, kv, "="); m[g,kv[1]] += kv[2] }
        }
        END {
            for(g=1;g<=2;g++) {
                owner[g]=m[g,"binary_cmp"]+m[g,"cursor_end_cmp"]
                total[g]=owner[g]+m[g,"order_cmp"]+m[g,"merge_cmp"]+m[g,"overlap_cmp"]
            }
            printf "aggregate owner %d -> %d, sort passes %d -> %d, all counted offset comparisons %d -> %d\n", owner[1], owner[2], m[1,"merge_passes"], m[2,"merge_passes"], total[1], total[2]
            exit !(owner[2] < owner[1] && m[2,"merge_passes"] < m[1,"merge_passes"] && total[2] < total[1])
        }' "$out/base-$workload.counts" "$out/head-$workload.counts"
done
echo 'All paired plan, compact bytes/RELA, linked ELF, frame/header, decoded frames, final relocation and execution comparisons passed.'
