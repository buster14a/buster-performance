// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const struct
    {
        const char* file;
        unsigned conditions;
        unsigned kept;
        unsigned decided;
        unsigned events;
    } frozen[] = {
        { NULL, 99, 54, 47, 23 },
        { "", 6, 3, 3, 0 },
        { "checker/cfg-pruning/issue.c", 24, 20, 17, 10 },
        { "checker/cfg-pruning/runtime.c", 2, 2, 1, 0 },
        { "checker/cfg-pruning/shapes.c", 78, 46, 31, 23 },
        { "checker/cfg-pruning/tautologies.c", 57, 34, 22, 34 },
    };
