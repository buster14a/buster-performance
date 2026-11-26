set -eu
out="$PWD/followup-9700x/3656"
source=pr3656/tests/driver/tier1_frame_scopes.c
cp "$source" "$out/scopes-1536.c"
sed -e 's/^    BUSTER_FRAME_SCOPES_1024(0)$/    BUSTER_FRAME_SCOPES_64(0)/' -e '/^    BUSTER_FRAME_SCOPES_512(1024)$/d' "$source" > "$out/scopes-64.c"
printf 'scopes round side status\n' > "$out/scopes-status.tsv"
for n in 64 1536; do
    for round in 0 1 2 3 4; do
        sides=(base3597 pr3656)
        if ((round % 2)); then sides=(pr3656 base3597); fi
        for side in "${sides[@]}"; do
            label="$out/scopes-$n-$round-$side"
            status=0
            taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$label.csv" -- "$side/build/compiler" --tier1 --tier1-strict --verify --tier1-report -O2 -march=znver5 -c "$out/scopes-$n.c" -o "$label.o" > "$label.out" 2>&1 || status=$?
            printf '%s %s %s %s\n' "$n" "$round" "$side" "$status" >> "$out/scopes-status.tsv"
            if [[ "$side" == pr3656 || "$n" == 64 ]]; then test "$status" -eq 0; fi
        done
    done
done
