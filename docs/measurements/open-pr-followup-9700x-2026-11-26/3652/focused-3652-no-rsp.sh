set -euo pipefail
out="$PWD/followup-9700x/3652/without-rsp"
mkdir -p "$out"
sed -e '/^static int stack_input(int n)$/,/^}$/d' -e 's/ + stack_input(n + i)//' \
    pr3652/tests/checker/programs/asm-directive-placement/directives.c > "$out/directives.c"
for side in base3652 pr3652; do
    printf '%s %s\n' "$side" "$(git -C "$side" rev-parse HEAD)" >> "$out/identity.txt"
    if ! "$side/build/compiler" --tier1 --verify --tier1-report -march=znver5 -c "$out/directives.c" -o "$out/$side-directives.o" > "$out/$side.report" 2>&1; then
        touch "$out/$side-build-failed"
        continue
    fi
    clang -O2 -march=znver5 -no-pie remaining-directive-driver.c "$out/$side-directives.o" -o "$out/$side-directives.bin"
    size "$out/$side-directives.o" >> "$out/object-sizes.txt"
    nm "$out/$side-directives.o" > "$out/$side.symbols"
    objdump -dr "$out/$side-directives.o" > "$out/$side.asm"
done
clang -O2 -march=znver5 -no-pie remaining-directive-driver.c "$out/directives.c" -o "$out/clang-directives.bin"
taskset -c 2 "$out/clang-directives.bin" > "$out/oracle.out"
for round in 0 1 2 3 4; do
    sides=(base3652 pr3652)
    if ((round % 2)); then sides=(pr3652 base3652); fi
    for side in "${sides[@]}"; do
        if [[ ! -x "$out/$side-directives.bin" ]]; then continue; fi
        label="$out/directives-$round-$side"
        status=0
        taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$label.csv" -- "$out/$side-directives.bin" > "$label.out" || status=$?
        printf "%s %s %s\n" "$round" "$side" "$status" >> "$out/exits.tsv"
        cmp "$label.out" "$out/oracle.out" || touch "$out/$side-oracle-mismatch"
    done
done
