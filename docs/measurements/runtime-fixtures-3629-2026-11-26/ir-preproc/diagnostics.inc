// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const struct
    {
        const char* text;
        const char* rejected;
        uint32_t line;
        uint32_t column;
    } names[] = {
        { "function (i12) -> void {\n", "i12", 1, 11 },
        { "function () ->   {\n", "{", 1, 18 },
        { "function () -> void {\nb0:\n  %0 = .i32\n", ".", 3, 8 },
        { "function () -> void {\nb0:\n  %0 = call_indirec.void\n", "call_indirec", 3, 8 },
        { "function () -> void {\nb0:\n  %0 = call_indirectx.void\n", "call_indirectx", 3, 8 },
        { "function () -> void {\nb0:\n  %0 = fence.void acq_relaxed\n", "acq_relaxed", 3, 19 },
    };
