#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
cd "$Q"
clang -std=c17 -O2 -Wall -Wextra -Werror scripts/counter-summary.c -o counter-summary
./counter-summary evidence > evidence/counter-summary.txt
cat evidence/counter-summary.txt
for variant in base candidate; do
    (cd "$variant" && ./build.sh print-compile-flags) > "evidence/compile-flags-$variant.argv0"
    (cd "$variant" && ./build.sh print-sources) > "evidence/compile-sources-$variant.argv0"
done
objdump --version | head -1
perf list ex_ret_ucode
sha256sum "$TC/bin/clang" "$TC/LICENSE.TXT" /usr/bin/wild base/build/compiler candidate/build/compiler
python3 scripts/elf_proof.py object objects-base-0/main_unit_checker.c.o objects-base-64/main_unit_checker.c.o --shift 0 > evidence/negative-object-wrong-shift.json && exit 1
grep -q '"passed": false' evidence/negative-object-wrong-shift.json
python3 scripts/check_linked.py objects-base-0/main_unit_checker.c.o base/build/compiler hot-base-64/build/compiler --shift 512 > evidence/negative-linked-wrong-shift.json && exit 1
grep -q '"passed": false' evidence/negative-linked-wrong-shift.json
echo 'wrong-shift object and linked negative controls rejected'
