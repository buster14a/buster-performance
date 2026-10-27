#!/usr/bin/env bash
# Run only the committed copy regressions, with all compiler entry points in one test translation unit.
# The production compiler and its normal release build are unchanged by this test wrapper.
set -euo pipefail
source_tree=$(realpath "$1")
output_dir=$(realpath "$2")
mkdir -p "$output_dir"
{
    echo '#define main buster_unused_main'
    sed -E 's/(#define BUSTER_HOME_(DRIVER|FRONTEND|DYNAMIC)) BUSTER_ELSEWHERE/\1 static/' "$source_tree/src/buster/compiler/main.c"
    cat <<'C'
#undef main
int main(void)
{
    CheckTest test = { .random = 133 };
    check_test_program_copies(&test, "clang");
    check_test_program_build_release();
    printf("aggregate-copy regressions: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
C
} > "$output_dir/focused.c"
clang -O0 -march=native -I"$source_tree/src" -fwrapv -funsigned-char -fno-strict-aliasing -ffunction-sections -fdata-sections -Wl,--gc-sections "$output_dir/focused.c" -pthread -lm -o "$output_dir/focused"
"$output_dir/focused"
