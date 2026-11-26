// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const IrParseTestCase reachable_cases[] = {
        {
            "function () -> i64 {\nslot $0 size=8 align=8 type=i64 flags=0x00\nb0:\n%0 = stack_addr.ptr $0\n%1 = const.i64 0x1\n%2 = ret.void %1\nb1:\n%3 = load.i64 %0 align=8\n%4 = ret.void %3\n}\n",
            IR_PARSE_OK,
        },
        {
            "function (i1) -> i64 {\nb0:\n%0 = param.i1 0\n%1 = cbr.void %0, b1, b2\nb1:\n%2 = const.i64 0x7\n%3 = br.void b3\nb2:\n%4 = br.void b3\nb3:\n%5 = ret.void %2\n}\n",
            IR_PARSE_VERIFY,
        },
        {
            "function () -> i64 {\nb0:\n%0 = br.void b2\nb1:\n%1 = const.i64 0x7\n%2 = br.void b2\nb2:\n%3 = ret.void %1\n}\n",
            IR_PARSE_VERIFY,
        },
        {
            "function () -> i64 {\nb0:\n%0 = const.i64 0x1\n%1 = br.void b2\nb1:\n%2 = const.i64 0x2\n%3 = br.void b2\nb2:\n%4 = phi.i64 [%0, b0], [%2, b1]\n%5 = ret.void %4\n}\n",
            IR_PARSE_OK,
        },
    };
