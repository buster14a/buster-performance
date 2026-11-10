// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define main original_regression_main
#include "tools/ci/build_regression.c"
#undef main
int main(void)
{
    const char* source = "src/buster/compiler/profile_test.c";
    const struct stat before = status_of(source);
    const struct timespec times[2] = { before.st_atim, before.st_mtim };
    if (utimensat(AT_FDCWD, source, 0, 0) != 0) { return 1; }
    char* arguments[] = { "../build-regression", "--ownership-only", "build/cmake/x86-64-g0/Release/compiler", 0 };
    const int stale = run("../ownership-stale-negative.log", 0, arguments);
    if (utimensat(AT_FDCWD, source, times, 0) != 0) { return 2; }
    Text text = read_file("../ownership-stale-negative.log");
    const bool rejected = stale != 0 && strstr(text.data, "ownership requires an up-to-date Release compiler") != 0;
    free(text.data);
    if (!rejected) { return 3; }
    char* copy[] = { "cp", "build/cmake/x86-64-g0/Release/compiler", "../detached-compiler", 0 };
    if (run(0, 0, copy) != 0) { return 4; }
    arguments[2] = "../detached-compiler";
    const int detached = run("../ownership-detached-negative.log", 0, arguments);
    unlink("../detached-compiler");
    text = read_file("../ownership-detached-negative.log");
    const bool copy_rejected = detached != 0 && strstr(text.data, "detached compiler copy") != 0;
    free(text.data);
    if (!copy_rejected) { return 5; }
    puts("actual pending source edit and detached compiler copy both rejected; original source timestamps restored");
    return 0;
}
