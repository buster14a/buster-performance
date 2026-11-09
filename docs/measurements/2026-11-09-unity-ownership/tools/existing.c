// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define main build_regression_original_main
#include "tools/ci/build_regression.c"
#undef main
int main(int argc, char** argv)
{
    if (getcwd(root, sizeof(root)) == 0) { return 2; }
    if (realpath("..", work) == 0) { return 3; }
    strcat(work, "/existing-XXXXXX");
    if (mkdtemp(work) == 0) { return 3; }
    signal(SIGINT, on_signal);
    signal(SIGTERM, on_signal);
    char* output[] = { "./build.sh", "print-output", 0 };
    char* output_debug[] = { "./build.sh", "print-output", "--config", "Debug", 0 };
    capture_line(output, release, sizeof(release));
    capture_line(output_debug, debug, sizeof(debug));
    snprintf(tree, sizeof(tree), "%s", release);
    *strrchr(tree, '/') = 0;
    *strrchr(tree, '/') = 0;
    snprintf(ninja_log, sizeof(ninja_log), "%s/.ninja_log", tree);
    if (argc == 1 || strcmp(argv[1], "standalone") == 0) { check_standalone_preprocessing(); }
    if (argc == 1 || strcmp(argv[1], "incremental") == 0) { check_incremental(); }
    if (argc == 1 || strcmp(argv[1], "configurations") == 0) { check_configurations(); }
    char* remove[] = { "rm", "-rf", work, 0 };
    run(0, 0, remove);
    return 0;
}
