// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent raw-environ controls of the actual static cleanup helper only.
// No Bash, producer, subprocess, target image or persistent environment change.
#include "../hp_common.c"

#include <assert.h>

static unsigned raw_count;
static unsigned raw_failures;

static void raw_check(bool passed, const char *name)
{
    raw_count += 1;
    raw_failures += !passed;
    printf("%s %s\n", passed ? "PASS" : "FAIL", name);
    return;
}

static void raw_case(char **fixture, char **expected, bool success, const char *name)
{
    char **saved = environ;
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    environ = fixture;
    bool accepted = hp_clear_bash_functions(error);
    bool passed = accepted == success && (success ? error[0] == 0 : error[0] != 0);
    size_t index = 0;
    while (passed && expected != NULL && expected[index] != NULL)
    {
        passed = environ != NULL && environ[index] != NULL && strcmp(environ[index], expected[index]) == 0;
        index += 1;
    }
    if (passed)
    {
        passed = expected == NULL ? environ == NULL : environ != NULL && environ[index] == NULL;
    }
    environ = saved;
    raw_check(passed, name);
    return;
}

int main(void)
{
    char keep[] = "KEEP=stable";
    char later[] = "LATER=stable";
    char first[] = "BASH_FUNC_first%%=() { :; }";
    char duplicate[] = "BASH_FUNC_first%%=() { false; }";
    char second[] = "BASH_FUNC_second%%=() { :; }";
    char third[] = "BASH_FUNC_third%%=() { :; }";
    char *retained[] =
    {
        keep,
        later,
        NULL
    };
    char *consecutive[] =
    {
        first,
        second,
        third,
        keep,
        later,
        NULL
    };
    raw_case(consecutive, retained, true, "consecutive-leading-functions-no-index-skip");
    char *interleaved[] =
    {
        keep,
        first,
        duplicate,
        second,
        later,
        third,
        NULL
    };
    raw_case(interleaved, retained, true, "duplicate-and-interleaved-functions-all-removed");
    char shortest[] = "BASH_FUNC_=value";
    char *minimum[] =
    {
        shortest,
        NULL
    };
    char *empty[] =
    {
        NULL
    };
    raw_case(minimum, empty, true, "minimum-prefix-name-is-removable-no-noop-loop");
    char multiple_equals[] = "BASH_FUNC_multi%%=alpha=beta=gamma";
    char *multiple[] =
    {
        multiple_equals,
        keep,
        later,
        NULL
    };
    raw_case(multiple, retained, true, "name-stops-at-first-equals");
    char almost[] = "BASH_FUNCS_first=value";
    char value_only[] = "VALUE=BASH_FUNC_first%%=() { :; }";
    char *ordinary[] =
    {
        almost,
        value_only,
        NULL
    };
    char *ordinary_expected[] =
    {
        almost,
        value_only,
        NULL
    };
    raw_case(ordinary, ordinary_expected, true, "near-prefix-and-function-like-values-preserved");
    raw_case(NULL, NULL, true, "NULL-environ-is-empty");
    raw_case(empty, empty, true, "empty-environ-terminates");
    char malformed[] = "BASH_FUNC_missing_equals";
    char *bad[] =
    {
        malformed,
        second,
        NULL
    };
    char *bad_expected[] =
    {
        malformed,
        second,
        NULL
    };
    raw_case(bad, bad_expected, false, "malformed-function-entry-fails-closed");
    char boundary[BUSTER_HP_PATH_CAPACITY + 3];
    memset(boundary, 'a', sizeof(boundary));
    memcpy(boundary, "BASH_FUNC_", 10);
    boundary[BUSTER_HP_PATH_CAPACITY - 1] = '=';
    boundary[BUSTER_HP_PATH_CAPACITY] = 'x';
    boundary[BUSTER_HP_PATH_CAPACITY + 1] = 0;
    char *maximal[] =
    {
        boundary,
        keep,
        later,
        NULL
    };
    raw_case(maximal, retained, true, "4095-byte-name-copied-and-removed-exactly");
    boundary[BUSTER_HP_PATH_CAPACITY - 1] = 'a';
    boundary[BUSTER_HP_PATH_CAPACITY] = '=';
    boundary[BUSTER_HP_PATH_CAPACITY + 1] = 'x';
    boundary[BUSTER_HP_PATH_CAPACITY + 2] = 0;
    char *oversized[] =
    {
        boundary,
        second,
        NULL
    };
    char *oversized_expected[] =
    {
        boundary,
        second,
        NULL
    };
    raw_case(oversized, oversized_expected, false, "4096-byte-name-refused-without-copy-or-loop");
    printf("Independent raw-environ controls: %u cases, %u failures; cleanup helper only, no subprocesses.\n", raw_count, raw_failures);
    return raw_failures != 0;
}
