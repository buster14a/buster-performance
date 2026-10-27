#!/usr/bin/env bash
set -euo pipefail
source_root=$1
output=$2
cat "$(dirname "$0")/sanitize-prefix.h" > "$output.c"
awk '/^static void check_data_bit_field_value/{copy=1} /^static CheckDataStatus check_data_plan_object/{copy=0} copy' "$source_root/src/buster/compiler/c_check_data.c" >> "$output.c"
awk '/^static void check_data_test_bit_field_reference/{copy=1} /^static void check_data_test_bit_field_plans/{copy=0} copy' "$source_root/src/buster/compiler/c_check_data_bit_field_test.c" >> "$output.c"
cat >> "$output.c" <<'C'
int main(void)
{
    CheckTest test = {0};
    check_data_test_bit_field_tails(&test);
    printf("bit-field sanitizers: %u passed, %u failed\n", test.passed, test.failed);
    return test.failed != 0;
}
C
clang -O1 -g -std=c17 -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer "$output.c" -o "$output"
"$output"
