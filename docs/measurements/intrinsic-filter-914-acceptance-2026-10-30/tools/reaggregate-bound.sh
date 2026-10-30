#!/usr/bin/env bash
set -euo pipefail
packet=$(realpath "$1")
binary=$(realpath -m "$2")
mkdir -p "$packet/bindings/corpus" "$(dirname "$binary")"
exec > "$packet/bindings/corpus/execution-receipt.txt" 2>&1
date -u
printf 'BUILD: clang -std=c17 -O2 -Wall -Wextra -Werror %s/tools/c-testsuite-aggregate.c -o %s\n' "$packet" "$binary"
clang --version
sha256sum /usr/bin/clang "$packet/tools/c-testsuite-aggregate.c" "$packet/corpus/raw/time.log"
clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/c-testsuite-aggregate.c" -o "$binary"
sha256sum "$binary"
printf 'EXECUTE: %s 3 220 %s/corpus/raw/time.log\n' "$binary" "$packet"
LC_ALL=C "$binary" 3 220 "$packet/corpus/raw/time.log" > "$packet/bindings/corpus/reaggregated.csv"
cmp "$packet/corpus/time-totals.csv" "$packet/bindings/corpus/reaggregated.csv"
sha256sum "$packet/bindings/corpus/reaggregated.csv"
for control in valid duplicate failed missing negative numeric-overflow sum-overflow uncounted; do
    input="$packet/corpus/aggregate-controls/$control.log"
    sha256sum "$input"
    status=0
    LC_ALL=C "$binary" 1 2 "$input" > "$packet/bindings/corpus/$control.csv" 2> "$packet/bindings/corpus/$control.stderr" || status=$?
    printf 'CONTROL %s status=%s\n' "$control" "$status"
    if [ "$control" = valid ]; then
        test "$status" = 0
        cmp "$packet/corpus/aggregate-controls/valid.csv" "$packet/bindings/corpus/valid.csv"
    else
        test "$status" = 1
    fi
done
sha256sum /usr/bin/clang "$packet/tools/c-testsuite-aggregate.c" "$binary" "$packet/corpus/raw/time.log"
printf 'complete 660-pair aggregation and eight bound controls passed\n'
