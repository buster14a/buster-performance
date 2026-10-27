#!/bin/sh
set -eu
for direction in read write; do
    BENCH_LABEL="df-umc-$direction" perf stat -a -C 0-7 -j --no-big-num --metric-no-group \
        -o "results/df-umc-$direction.perf.json" \
        -M "dram_${direction}_bandwidth_for_local_or_remote_socket" \
        -e 'amd_umc_0/umc_cas_cmd.rd/,amd_umc_0/umc_cas_cmd.wr/,amd_umc_1/umc_cas_cmd.rd/,amd_umc_1/umc_cas_cmd.wr/' \
        -- ./microarch-v9 bench compile 8 64 1 0 0 ./compiler-native \
        > "results/df-umc-$direction.work.json" \
        2> "results/df-umc-$direction.log"
done
