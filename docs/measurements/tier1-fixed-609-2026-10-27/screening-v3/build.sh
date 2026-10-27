#!/usr/bin/env bash
# Run under the shared host lock. Arguments are the baseline and candidate source trees.
set -euo pipefail
cd "$(dirname "$0")"
base=${1:?baseline source directory}
head=${2:?candidate source directory}
flags=(-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror)
clang "${flags[@]}" -I"$base/src" -c baseline.c -o baseline.o
clang "${flags[@]}" -I"$head/src" measure.c baseline.o -pthread -o measure
clang "${flags[@]}" -I"$head/src" allocation-tests.c -pthread -o allocation-tests
clang -O2 -Wall -Wextra -Werror campaign.c -o campaign
date -u
clang --version
lscpu
sha256sum measure allocation-tests campaign baseline.o measure.c baseline.c allocation-tests.c campaign.c "$base/src/buster/compiler/tier1_allocate.c" "$head/src/buster/compiler/tier1_allocate.c" "$head/src/buster/compiler/tier1_allocate_test.c"
objdump -d --disassemble=tier1_allocation_filter_fixed measure > fixed-filter.s
