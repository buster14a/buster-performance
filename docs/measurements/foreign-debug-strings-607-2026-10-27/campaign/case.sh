#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
case_name="$1"
compression="$2"
rounds="${3:-11}"
key="$case_name-$compression"
objects=(inputs/"$case_name"/"$compression"/*.o)
mkdir -p "results/$key"
: > "results/$key/process.tsv"
extra=()
if [[ "$case_name" == real ]]; then
    # Raw dynamic PIE link line with the installed C runtime; identical for Buster/lld.
    extra=(-pie --dynamic-linker /lib64/ld-linux-x86-64.so.2 "$(clang -print-file-name=Scrt1.o)" "$(clang -print-file-name=crti.o)" "$(clang -print-file-name=crtbeginS.o)" "${objects[@]}" -L/usr/lib -L"$(dirname "$(clang -print-file-name=libgcc.a)")" -lc -lm -lgcc "$(clang -print-file-name=crtendS.o)" "$(clang -print-file-name=crtn.o)")
else
    extra=("${objects[@]}")
fi
printf '%s\n' "${extra[@]}" > "results/$key/link-arguments.txt"
pool_objects=()
for argument in "${extra[@]}"; do
    if [[ "$argument" == *.o && -f "$argument" ]]; then
        pool_objects+=("$argument")
    fi
done
sha256sum "${pool_objects[@]}" > "results/$key/link-inputs.sha256"
for ((round=0; round<=rounds; round++)); do
    if (( round % 2 == 0 )); then
        order=(buster lld driver-base driver-merge)
    else
        order=(driver-merge driver-base lld buster)
    fi
    for linker in "${order[@]}"; do
        if [[ "$linker" == buster ]]; then
            command=(base/build/compiler link-foreign --lanes 1 --time)
        elif [[ "$linker" == lld ]]; then
            command=(/usr/bin/ld.lld --threads=1)
        else
            command=(campaign/"$linker" --lanes 1 --time)
        fi
        # Discard one run of the same executable after every binary switch.
        taskset -c 2 "${command[@]}" -o "outputs/$key-$linker" "${extra[@]}" > /dev/null 2> "results/$key/$linker-warm.stderr"
        taskset -c 2 campaign/dwarf607 run "results/$key/$linker-$round.stderr" "$linker" "$round" "${command[@]}" -o "outputs/$key-$linker" "${extra[@]}" >> "results/$key/process.tsv"
    done
done
# Optimistic producer screen: input opening/decompression is outside timed samples.
taskset -c 2 campaign/dwarf607 pool "$rounds" "outputs/$key-pool" "${pool_objects[@]}" > "results/$key/pool.tsv" 2> "results/$key/pool-resource.txt"
cmp "outputs/$key-pool.0.vector" "outputs/$key-pool.0.exact"
cmp "outputs/$key-pool.1.vector" "outputs/$key-pool.1.exact"
campaign/driver-merge --lanes 1 --scalar -o "outputs/$key-merge-exact" "${extra[@]}" > "results/$key/exact.stdout" 2> "results/$key/exact.stderr"
campaign/driver-merge --lanes 8 -o "outputs/$key-merge-lanes" "${extra[@]}" > "results/$key/lanes.stdout" 2> "results/$key/lanes.stderr"
cmp "outputs/$key-driver-merge" "outputs/$key-merge-exact"
cmp "outputs/$key-driver-merge" "outputs/$key-merge-lanes"
for linker in buster lld driver-base driver-merge; do
    llvm-readelf -SW "outputs/$key-$linker" > "results/$key/$linker-sections.txt"
    llvm-dwarfdump --verify "outputs/$key-$linker" > "results/$key/$linker-verify.txt" 2>&1
    llvm-dwarfdump --statistics "outputs/$key-$linker" > "results/$key/$linker-statistics.json"
    grep -Ev '"file":|"#bytes in \.debug_(str|line_str)"' "results/$key/$linker-statistics.json" | LC_ALL=C sort > "results/$key/$linker-statistics-normalized.json"
    llvm-dwarfdump --debug-info --debug-line "outputs/$key-$linker" | campaign/decoded | gzip -n > "results/$key/$linker-decoded-strings.txt.gz"
    status=0
    "./outputs/$key-$linker" > "results/$key/$linker-program.bin" || status=$?
    expected_status=0
    [[ "$case_name" != real ]] || expected_status=42
    [[ "$status" == "$expected_status" ]]
    if [[ "$case_name" == real ]]; then
        grep -q '^SQLite foreign-link corpus: pass count=10000 ' "results/$key/$linker-program.bin"
    fi
    if [[ "$case_name" != real ]]; then
        count="${case_name##*-}"
        [[ "$(od -An -tu8 "results/$key/$linker-program.bin" | tr -d ' ')" == "$((count * (count - 1)))" ]]
        identity=0
        [[ "$case_name" != unique-* ]] || identity=10
        gdb -q -nx -batch -ex 'set debuginfod enabled off' -ex 'set startup-with-shell off' -ex 'break function_0009' -ex run -ex 'print x' -ex next -ex "print local.integer_member_with_a_long_descriptive_debug_member_name_${identity}_31" -ex 'ptype local' -ex bt "outputs/$key-$linker" > "results/$key/$linker-gdb.txt" 2>&1
        [[ "$(grep -c '^\$[12] = 9$' "results/$key/$linker-gdb.txt")" == 2 ]]
        grep -q "type = struct shared_nested_structure_with_a_long_descriptive_debug_type_name_${identity}_31" "results/$key/$linker-gdb.txt"
        grep -q '^#0 .*function_0009' "results/$key/$linker-gdb.txt"
        grep -q '^#1 .*_start' "results/$key/$linker-gdb.txt"
        expected_line="$(grep -n -m1 'return local' "inputs/$case_name/unit_0009.c" | cut -d: -f1)"
        grep -q "unit_0009.c:$expected_line" "results/$key/$linker-gdb.txt"
    fi
done
sha256sum outputs/"$key"-* > "results/$key/outputs.sha256"
cmp "results/$key/buster-program.bin" "results/$key/lld-program.bin"
cmp "results/$key/driver-base-program.bin" "results/$key/driver-merge-program.bin"
cmp "results/$key/buster-program.bin" "results/$key/driver-base-program.bin"
for linker in lld driver-base driver-merge; do
    cmp "results/$key/buster-statistics-normalized.json" "results/$key/$linker-statistics-normalized.json"
    cmp "results/$key/buster-decoded-strings.txt.gz" "results/$key/$linker-decoded-strings.txt.gz"
done
printf '%s complete\n' "$key"
