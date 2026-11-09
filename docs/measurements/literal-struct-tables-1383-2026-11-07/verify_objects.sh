#!/bin/bash
set -eu
if test -f object-proof.sha256 && sha256sum --check --status object-proof.sha256; then
    echo "Reused complete-object equivalence: the four inputs and both compiler binaries match the retained hashes"
    exit 0
fi
for input in file250000.c local250000.c flat1000000.c float50000.c; do
    for revision in base head; do
        "./bin/$revision" -c -o "$revision.$input.o" "$input"
        "./bin/$revision" check --scalar -c -o "$revision.$input.scalar.o" "$input"
        cmp "$revision.$input.o" "$revision.$input.scalar.o"
    done
    cmp "base.$input.o" "head.$input.o"
    echo "$input: base/head and scalar/vector complete objects identical"
done
sha256sum ./*.c ./*.o > fixture-object-hashes.txt
if test -f receipt.txt && ! test -f receipt-715bc7d4.txt; then
    mv receipt.txt receipt-715bc7d4.txt
fi
bash receipt.sh
sha256sum file250000.c local250000.c flat1000000.c float50000.c bin/base bin/head > object-proof.sha256
