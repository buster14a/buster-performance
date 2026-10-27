#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
sha256sum generate.c compare.c audit.c audit.h prepare-audit.c summarize.c build-tools.sh control.sh verify.c verify.sh > harness.sha256
clang -std=c17 -O2 -Wall -Wextra -Werror generate.c -o generate
clang -std=c17 -O2 -Wall -Wextra -Werror compare.c -o compare
clang -std=c17 -O2 -Wall -Wextra -Werror prepare-audit.c -o prepare-audit
mkdir -p inputs objects
for role in base head; do
    mkdir -p "overlay-$role/buster/compiler"
    ./prepare-audit "../$role" "overlay-$role"
    clang -O3 -march=native -I"overlay-$role" -I"../$role/src" -I"../$role/src/buster/compiler" -I. \
        -fwrapv -funsigned-char -fno-strict-aliasing -ffunction-sections -fdata-sections -Wl,--gc-sections \
        audit.c -o "audit-$role" -lm -pthread
done
for mode in bss zero tls designated overwrite bits reloc const; do
    for size in 1048576 4194304 16777216 67108864 268435456; do
        ./generate "$mode" "$size" > "inputs/$mode-$size.c"
    done
done
./generate negative 16 > inputs/negative-16.c
./generate dense 65536 > inputs/dense-65536.c
./generate dense-tail-zero 65536 > inputs/dense-tail-zero-65536.c
sha256sum ../base/build/compiler ../head/build/compiler inputs/*.c > identities.txt
sha256sum "$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c" >> identities.txt
for role in base head; do
    "../$role/build/compiler" --lanes 1 -c "$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c" -o "objects/preflight-$role.o"
done
find ../base ../head -type f ! -path '*/build/*' -print0 | sort -z | xargs -0 sha256sum > source-files.sha256
objdump -d -Mintel --disassemble=check_data_emit ../head/build/compiler > check-data-emit.asm
nm -S ../base/build/compiler | grep ' check_data_emit$' > function-sizes.txt
nm -S ../head/build/compiler | grep ' check_data_emit$' >> function-sizes.txt
uname -a > environment.txt
clang --version >> environment.txt
lscpu >> environment.txt
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor >> environment.txt
cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference >> environment.txt
for role in base head; do
    for mode in zero tls overwrite; do
        for size in 1048576 4194304 16777216 67108864 268435456; do
            printf '%s\t' "$role"
            ./audit-"$role" "$mode" "$size"
        done
    done
done > scratch-work.tsv
