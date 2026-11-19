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
sha256sum "$inputs"/*.o
for o in "$inputs"/*.o; do
    readelf -Wr "$o" > "$o.relocations"
    readelf -wf "$o" > "$o.frames"
    echo "INPUT $(basename "$o")"
    grep 'rela.eh_frame' "$o.relocations"
    printf 'CIEs %s FDEs %s\n' "$(grep -c ' CIE' "$o.frames")" "$(grep -c ' FDE cie=' "$o.frames")"
done
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
    if [ "$workload" = sort ]; then
        args=("$inputs/sort_a.o" "$inputs/sort_b.o" -L "$gccdir" -L "$libdir" -lstdc++ -lm)
    else
        args=(--gc-sections "$inputs/changes.o")
    fi
    UNWIND_PLAN="$sub.plan" build/compiler link-foreign --lanes 1 -o "$sub.elf" "${begin[@]}" "${args[@]}" "${end[@]}" 2>"$sub.counts" || rc=$?
    cat "$sub.counts"
    test "$rc" = 0
    test -s "$sub.plan"
    grep -q '^PRUNE ' "$sub.counts"
    readelf -wf "$sub.elf" > "$sub.frames"
    objcopy -O binary --only-section=.eh_frame "$sub.elf" "$sub.eh"
    objcopy -O binary --only-section=.eh_frame_hdr "$sub.elf" "$sub.hdr"
    readelf -Wr "$sub.elf" > "$sub.relocs"
    if [ "$workload" = sort ]; then
        rc=0
        "$sub.elf" > "$sub.stdout" 2> "$sub.stderr" || rc=$?
        test "$rc" = 42
        echo "sort exit $rc"
    else
        "$sub.elf" --event merge_group --files "$inputs/paths" --workflow .github/workflows/9700x.yml --root . --output "$sub.outputs" > "$sub.stdout" 2> "$sub.stderr" || { cat "$sub.stderr"; return 1; }
        echo "changes selector exit 0"
    fi
    sha256sum "$sub".{plan,elf,eh,hdr,frames,relocs}
}
git apply "$q/base-probe.patch"
build base-instrumented
capture base sort
capture base changes
if [ ! -f "$q/head.patch" ]; then exit 0; fi
git apply -R "$q/base-probe.patch"
git apply "$q/head.patch"
build head-clean
mkdir "$out/full-foreign"
build/compiler test-foreign --cross-check --directory "$out/full-foreign" --keep > "$out/head.foreign" 2>&1 || { cat "$out/head.foreign"; exit 1; }
cat "$out/head.foreign"
git apply "$q/head-probe.patch"
build head-instrumented
for workload in sort changes; do
    capture head "$workload"
    for ext in plan elf eh hdr frames relocs stdout stderr; do
        cmp "$out/base-$workload.$ext" "$out/head-$workload.$ext"
    done
done
cmp "$out/base-changes.outputs" "$out/head-changes.outputs"
echo 'All paired plan, compact bytes/RELA, linked ELF, frame/header, decoded frames, final relocation and execution comparisons passed.'
