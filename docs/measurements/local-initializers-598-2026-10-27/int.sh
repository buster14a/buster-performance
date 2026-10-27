#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
clang -std=c17 -O2 -Wall -Wextra -Werror generate_int.c -o generate_int
clang -std=c17 -O2 -Wall -Wextra -Werror runtime_int.c -ldl -o runtime_int
mkdir -p cases-int logs-int logs-int-default
for n in 32 33 128 512 2048 8192 40000; do
    ./generate_int "$n" > "cases-int/int-$n.c"
done
sha256sum cases-int/*.c > int-inputs.sha256
for n in 32 33 128 512 2048 8192 40000; do
    input="cases-int/int-$n.c"
    ./compile ../base/build/compiler ../head/build/compiler "$input" int "$n" logs-int
    for variant in base head; do
        object="logs-int/$variant-int-$n.o"
        size -A "$object" > "logs-int/$variant-int-$n.sections"
        objdump -dr "$object" > "logs-int/$variant-int-$n.disasm"
        clang -shared -Wl,-Bsymbolic-functions "$object" -o "logs-int/$variant-int-$n.so"
        ../"$variant"/build/compiler benchmark-backend-source --only encode "$input" > "logs-int/$variant-int-$n.backend" 2>&1
    done
    ./runtime_int "./logs-int/base-int-$n.so" "./logs-int/head-int-$n.so" int "$n"
done
for n in 32 40000; do
    ./compile ../base/build/compiler ../head/build/compiler "cases-int/int-$n.c" int "$n" logs-int-default default >> int-default.log
done
./summarize int.log logs-int > int.csv
./summarize int-default.log logs-int-default > int-default.csv
