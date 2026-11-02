#!/usr/bin/env bash
# The record's receipts: host, tools, binaries' and trees' hashes, and every build's objects compared with main's.
set -uo pipefail
R=$HOME/buster-fast-bench/claude-880
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
cd "$R"
echo "== host"; uname -a; grep -m1 'model name' /proc/cpuinfo
echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
echo "== tools"; clang --version | head -1; ld.lld --version | head -1; wild --version 2>&1 | head -1; perf --version; llvm-profdata --version 2>&1 | grep -i version | head -1
echo "== executables"; sha256sum shifts/*/compiler-* exp/base/compiler exp/d/compiler exp/e/compiler tree-base/build/compiler tree-pgo/build/compiler tree-self/build/compiler
echo "== profiles"; sha256sum tree-pgo/build/compiler.profdata tree-self/build/compiler.profdata tree-headpgo/build/compiler.profdata
echo "== trees (src/ and build.sh manifests)"
for t in tree-main tree-head tree-headpgo tree-base tree-pgo tree-self exp/e; do
    (cd "$t" && find src build.sh -type f | LC_ALL=C sort | xargs sha256sum | sha256sum | sed "s|-\$|$t|")
done
echo "== objects"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
BASE=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include"
      -isystem "$C/headers/usr/include" -I"$C/sqlite")
mapfile -t MF < "$R/musl-corpus-139.txt"
MUSL=(-march=znver5 -x c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700
      -I "$C/libc/musl/arch/x86_64" -I "$C/libc/musl/arch/generic" -I "$C/musl-generated/obj/src/internal"
      -I "$C/libc/musl/src/include" -I "$C/libc/musl/src/internal" -I "$C/musl-generated/obj/include" -I "$C/libc/musl/include"
      "${MF[@]/#/$C/libc/musl/}")
for v in main head headpgo; do
    mkdir -p "$T/$v"
    "$R/shifts/$v/compiler-0" -c "${BASE[@]}" -o "$T/$v/sqlite3.o" "$C/sqlite/sqlite3.c"; echo "$v sqlite3.c -c status $?"
    (cd "$T/$v" && "$R/shifts/$v/compiler-0" -c "${MUSL[@]}"); echo "$v musl -c status $?"
    echo "$v: $(ls "$T/$v" | wc -l) objects, $(cat "$T/$v"/*.o | sha256sum | cut -c1-16)"
done
for v in head headpgo; do diff -r -q "$T/main" "$T/$v" && echo "$v: every object byte for byte main's"; done
