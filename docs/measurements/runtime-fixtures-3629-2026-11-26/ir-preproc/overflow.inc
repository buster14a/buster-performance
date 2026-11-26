// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const char* const overflows[] = {
        "function () -> void {\nb0:\n%4294967296 = ret.void\n}\n",
        "function () -> void {\nb0:\n%0 = const.i128 0x100000000000000000000000000000000\n%1 = ret.void\n}\n",
        "function () -> void {\nslot $0 size=18446744073709551616 align=1 type=void flags=0x00\nb0:\n%0 = ret.void\n}\n",
        "function () -> void {\nb0:\n%0 = undef.ptr\n%1 = address.ptr %0 offset=-9223372036854775809\n%2 = ret.void\n}\n",
        "function () -> void {\nb0:\n%0 = undef.ptr\n%1 = address.ptr %0 offset=9223372036854775808\n%2 = ret.void\n}\n",
    };
