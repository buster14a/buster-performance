#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p inputs results outputs
bash campaign/build-drivers.sh
{
    date -Is
    uname -a
    lscpu
    clang --version
    ld.lld --version
    llvm-dwarfdump --version
    gdb --version
    objcopy --version
    sha256sum base/build/compiler campaign/dwarf607 campaign/dwarf607.c campaign/driver-base campaign/driver-merge campaign/candidate.patch
    stat -f -c 'filesystem=%T' outputs
} > results/identity.txt
for shape in duplicate unique; do
    for count in 10 100 1000; do
        dir="inputs/$shape-$count"
        campaign/dwarf607 generate "$dir" "$count" "$shape"
        mkdir -p "$dir/plain" "$dir/zlib"
        for source in "$dir"/*.c; do
            object="$(basename "${source%.c}").o"
            clang -g -gdwarf-5 -O0 -ffreestanding -fno-stack-protector -c "$source" -o "$dir/plain/$object"
            objcopy --compress-debug-sections=zlib "$dir/plain/$object" "$dir/zlib/$object"
        done
    done
done
dir=inputs/dwarf64-10
campaign/dwarf607 generate "$dir" 10 duplicate
mkdir -p "$dir/plain" "$dir/zlib"
for source in "$dir"/*.c; do
    object="$(basename "${source%.c}").o"
    clang -g -gdwarf-5 -gdwarf64 -O0 -ffreestanding -fno-stack-protector -c "$source" -o "$dir/plain/$object"
    objcopy --compress-debug-sections=zlib "$dir/plain/$object" "$dir/zlib/$object"
done
mkdir -p inputs/real/plain inputs/real/zlib
sqlite="${SQLITE_607_DIRECTORY:-$HOME/buster-fast-bench/linker-corpus86/sqlite3532-20261023}"
for name in sqlite3 check; do
    clang -g -gdwarf-5 -O1 -c "$sqlite/$name.c" -o "inputs/real/plain/$name.o"
    objcopy --compress-debug-sections=zlib "inputs/real/plain/$name.o" "inputs/real/zlib/$name.o"
done
sha256sum "$sqlite/sqlite3.c" "$sqlite/sqlite3.h" "$sqlite/check.c" > results/real-sources.sha256
find inputs -name '*.c' -o -name '*.h' -o -name '*.o' | LC_ALL=C sort | xargs sha256sum > results/inputs.sha256
printf 'setup complete\n'
