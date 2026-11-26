// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#define main dump_sources_main
#include "dump_driver.c"
#undef main

static bool text_file(const char* root, const char* name, const char* bytes)
{
    return write_bytes(root, name, bytes, strlen(bytes));
}

int main(int argc, char** argv)
{
    bool ok = dump_sources_main(argc, argv) == 0;
    if (ok)
    {
        ok &= text_file(argv[1], "setjmp-held/catalog.tsv",
            "buster-fixtures v1 driver-programs\tprogram.c\tpolicy.expected\n"
            "deep-expression\t0001.c\t0001.expected\n"
            "held-long-double\t0002.c\t0002.expected\n"
            "unheld-long-double\t0003.c\t0003.expected\n");
        ok &= text_file(argv[1], "setjmp-held/0001.expected", "0\t-\ta deep expression held across __builtin_setjmp compiles\tthe same, scalar\n");
        ok &= text_file(argv[1], "setjmp-held/0002.expected", "0\t-\ta long double held across __builtin_setjmp compiles\tthe same, scalar\n");
        ok &= text_file(argv[1], "setjmp-held/0003.expected", "0\t-\ta long double not held across __builtin_setjmp compiles\tthe same, scalar\n");
        ok &= text_file(argv[1], "static-label/catalog.tsv",
            "buster-fixtures v1 driver-programs\tprogram.c\tpolicy.expected\n"
            "static-first\t0001.c\t0001.expected\n"
            "label-first\t0002.c\t0002.expected\n"
            "labelled-definition\t0003.c\t0003.expected\n"
            "unrelated-dotted-label\t0004.c\t0004.expected\n");
        for (unsigned i = 0; i < 4; ++i)
        {
            char name[128];
            char policy[1024];
            snprintf(name, sizeof(name), "static-label/%04u.expected", i + 1);
            if (i < 3)
            {
                snprintf(policy, sizeof(policy),
                         "1\tunsupported: an asm label naming a block-scope static's symbol, which clang joins to the static by its emission order\t"
                         "an asm label naming a block-scope static's symbol, shape %u, is refused by name\t"
                         "an asm label naming a block-scope static's symbol, shape %u, is refused by name, scalar\n", i, i);
            }
            else
            {
                snprintf(policy, sizeof(policy), "0\t-\tan asm label of a dotted name no static has compiles\tan asm label of a dotted name no static has compiles, scalar\n");
            }
            ok &= text_file(argv[1], name, policy);
        }
        ok &= text_file(argv[1], "stack-protector/catalog.tsv",
            "buster-fixtures v1 driver-programs\trules.c\tinlining.c\tdifferences.c\tsmash.c\tdefault.expected\tstrong.expected\n"
            "guards\trules.c\tinlining.c\tdifferences.c\tsmash.c\tdefault.expected\tstrong.expected\n");
        ok &= text_file(argv[1], "stack-protector/default.expected", "d_alloca_small ");
        ok &= text_file(argv[1], "stack-protector/strong.expected", "d_aligned d_alloca_small d_union_padding ");
        ok &= text_file(argv[1], "cf-protection/catalog.tsv",
            "buster-fixtures v1 driver-programs\trules.c\tprogram.c\n"
            "indirect-targets\trules.c\tprogram.c\n");
        ok &= text_file(argv[1], "cf-protection-policy/catalog.tsv",
            "buster-fixtures v1 driver-programs\tprogram.c\tpolicy.expected\n"
            "nocf-full\t0001.c\t0001.expected\n"
            "nocf-branch\t0002.c\t0002.expected\n"
            "nocf-return\t0003.c\t0003.expected\n"
            "setjmp-return\t0004.c\t0004.expected\n"
            "longjmp-full\t0005.c\t0005.expected\n"
            "multiversion-branch\t0006.c\t0006.expected\n"
            "multiversion-return\t0007.c\t0007.expected\n");
        ok &= text_file(argv[1], "branch-truth/catalog.tsv",
            "buster-fixtures v2 driver-programs\tprogram.c\tcounts.expected\n"
            "rules\trules.c\t0001.expected\n"
            "wrapped\twrapped.c\t0002.expected\n"
            "cfg-issue\t@checker/cfg-pruning/issue.c\t0003.expected\n"
            "cfg-runtime\t@checker/cfg-pruning/runtime.c\t0004.expected\n"
            "cfg-shapes\t@checker/cfg-pruning/shapes.c\t0005.expected\n"
            "cfg-tautologies\t@checker/cfg-pruning/tautologies.c\t0006.expected\n");
        ok &= text_file(argv[1], "quiet-roots/catalog.tsv",
            "buster-fixtures v1 driver-programs\tprogram.c\tcounts.expected\tmessages.expected\n"
            "root-kinds\tprogram.c\tcounts.expected\tmessages.expected\n");
        ok &= text_file(argv[1], "quiet-roots/counts.expected", "45\t23\t45\t23\n");
    }
    return ok ? 0 : 1;
}
