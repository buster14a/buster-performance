// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "stack_literals.h"
#include "cet_literals.h"
#include "branch_literals.h"
#include "quiet_literals.h"
#include "setjmp_literals.h"
#include "label_literals.h"
#include "cet_policy_literals.h"
#include "quiet_expected_literals.h"
#include "branch_frozen_literals.h"

static bool write_bytes(const char* root, const char* name, const char* bytes, size_t length)
{
    char path[4096];
    const int n = snprintf(path, sizeof(path), "%s/%s", root, name);
    bool ok = n > 0 && (size_t)n < sizeof(path);
    for (char* at = path + strlen(root) + 1; ok && *at != 0; ++at)
    {
        if (*at == '/')
        {
            *at = 0;
            (void)mkdir(path, 0700);
            *at = '/';
        }
    }
    FILE* file = ok ? fopen(path, "wb") : NULL;
    ok = file != NULL && fwrite(bytes, 1, length, file) == length;
    if (file != NULL)
    {
        ok &= fclose(file) == 0;
    }
    if (!ok)
    {
        fprintf(stderr, "cannot write %s\n", name);
    }
    return ok;
}

#define DUMP(path, value) (ok &= write_bytes(argv[1], path, value, sizeof(value) - 1))
int main(int argc, char** argv)
{
    bool ok = argc == 2;
    if (ok)
    {
        DUMP("stack-protector/rules.c", check_test_stack_protector_rules_source);
        DUMP("stack-protector/inlining.c", check_test_stack_protector_inlining_source);
        DUMP("stack-protector/differences.c", check_test_stack_protector_differences_source);
        DUMP("stack-protector/smash.c", check_test_stack_protector_smash_source);
        DUMP("cf-protection/rules.c", check_test_cf_protection_rules_source);
        DUMP("cf-protection/program.c", check_test_cf_protection_program_source);
        DUMP("branch-truth/rules.c", check_driver_truth_rules);
        DUMP("branch-truth/wrapped.c", check_driver_truth_wrapped);
        DUMP("quiet-roots/program.c", check_driver_quiet_roots_unit);
        for (unsigned i = 0; i < sizeof(setjmp_sources) / sizeof(setjmp_sources[0]); ++i)
        {
            char name[128];
            snprintf(name, sizeof(name), "setjmp-held/%04u.c", i + 1);
            ok &= write_bytes(argv[1], name, setjmp_sources[i], strlen(setjmp_sources[i]));
        }
        for (unsigned i = 0; i < sizeof(static_label_sources) / sizeof(static_label_sources[0]); ++i)
        {
            char name[128];
            snprintf(name, sizeof(name), "static-label/%04u.c", i + 1);
            ok &= write_bytes(argv[1], name, static_label_sources[i], strlen(static_label_sources[i]));
        }
        for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i)
        {
            char name[128];
            snprintf(name, sizeof(name), "cf-protection-policy/%04u.c", i + 1);
            ok &= write_bytes(argv[1], name, cases[i].source, strlen(cases[i].source));
            char policy[1024];
            const int n = snprintf(policy, sizeof(policy), "%s\t%d\t%s\t%s\n", cases[i].option, cases[i].status,
                                   cases[i].message != NULL ? cases[i].message : "-", cases[i].label);
            snprintf(name, sizeof(name), "cf-protection-policy/%04u.expected", i + 1);
            ok &= n > 0 && (size_t)n < sizeof(policy) && write_bytes(argv[1], name, policy, (size_t)n);
        }
        char messages[8192];
        size_t used = 0;
        for (unsigned i = 0; i < sizeof(expected) / sizeof(expected[0]); ++i)
        {
            const int n = snprintf(messages + used, sizeof(messages) - used, "%s\n", expected[i]);
            ok &= n > 0 && (size_t)n < sizeof(messages) - used;
            used += ok ? (size_t)n : 0;
        }
        ok &= write_bytes(argv[1], "quiet-roots/messages.expected", messages, used);
        for (unsigned i = 0; i < sizeof(frozen) / sizeof(frozen[0]); ++i)
        {
            char name[128];
            snprintf(name, sizeof(name), "branch-truth/%04u.expected", i + 1);
            const char* label = frozen[i].file == NULL ? "the rules' unit" : frozen[i].file[0] == 0 ? "the wrapped _Bool's unit" : frozen[i].file;
            char counts[1024];
            const int n = snprintf(counts, sizeof(counts), "%u\t%u\t%u\t%u\t%s\n", frozen[i].conditions, frozen[i].kept,
                                   frozen[i].decided, frozen[i].events, label);
            ok &= n > 0 && (size_t)n < sizeof(counts) && write_bytes(argv[1], name, counts, (size_t)n);
        }
    }
    return ok ? 0 : 1;
}
