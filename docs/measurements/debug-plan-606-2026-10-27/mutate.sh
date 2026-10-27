#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p mutants
sed 's#"buster/src/buster/compiler/debug.c"#"mutant_debug.c"#' plan_sanitize.c > mutant_test.c
for mutation in bases addresses fields sizes; do
    case $mutation in
        bases) sed 's/memcmp(plan->bases, output->bases, sizeof(plan->bases)) == 0 ? DEBUG_OK : DEBUG_ERROR_INPUT/DEBUG_OK/' buster/src/buster/compiler/debug.c > mutant_debug.c ;;
        addresses) sed 's/if (plan->unit.function_count > output->address_capacity || (plan->unit.function_count != 0 \&\& output->line_addresses == 0))/if (false)/' buster/src/buster/compiler/debug.c > mutant_debug.c ;;
        fields) sed '/DebugError result = memcmp(plan->bases/i\    output->fields[0] = 0;' buster/src/buster/compiler/debug.c > mutant_debug.c ;;
        sizes) sed 's/plan->sizes\[section\] = measured\[section\].size;/plan->sizes[section] = measured[section].size + 1;/' buster/src/buster/compiler/debug.c > mutant_debug.c ;;
    esac
    clang -O1 -g -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fsanitize=address,undefined mutant_test.c -o mutants/test
    if ./mutants/test > "mutants/$mutation.log" 2>&1; then
        echo "SURVIVED $mutation"
        exit 1
    fi
    echo "caught $mutation"
done
