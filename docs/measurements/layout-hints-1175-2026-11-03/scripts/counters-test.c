// Network-free synthetic fixtures for #1175's counter reader. These are not hardware measurements.
// cc -std=c17 -O2 -Wall -Wextra -Werror counters-test.c -o /tmp/counters-test && /tmp/counters-test
#define BUSTER_COUNTERS_TEST
#include "counters.c"

typedef enum
{
    TEST_VALID,
    TEST_REVERSE,
    TEST_MISSING_SAMPLE,
    TEST_MISSING_BUILD,
    TEST_MISSING_PLACEMENT,
    TEST_MISSING_MODE,
    TEST_MISSING_EVENT,
    TEST_MISSING_RUN,
    TEST_DUPLICATE,
    TEST_VALUE,
    TEST_ROW,
    TEST_EMPTY,
    TEST_MANIFEST_MISSING,
    TEST_MANIFEST_DUPLICATE,
    TEST_MANIFEST_ROW,
    TEST_MANIFEST_EMPTY,
    TEST_MANIFEST_SINGLE_BUILD,
    TEST_MANIFEST_RUN_GAP,
} TestKind;

typedef struct
{
    const char* name;
    TestKind kind;
    const char* replacement;
    bool valid;
} Test;

static void fixture(FILE* manifest, FILE* input, TestKind kind, const char* replacement)
{
    const char* bs[] = {"main", "head"};
    const char* ps[] = {"0-0", "688-256", "1376-512", "2064-768"};
    const char* ms[] = {"syntax", "sqlite-c", "musl-c"};
    const char* es[] = {"instructions:u", "cycles:u", "ex_ret_brn_tkn:u"};
    for (int b = 0; b < 2; b += 1)
    {
        for (int p = 0; p < 4; p += 1)
        {
            for (int m = 0; m < 3; m += 1)
            {
                for (int r = 1; r <= 3; r += 1)
                {
                    for (int e = 0; e < 3; e += 1)
                    {
                        const bool first = b == 0 && p == 0 && m == 0 && r == 1 && e == 0;
                        const bool omit_expected = kind == TEST_MANIFEST_EMPTY ||
                            (kind == TEST_MANIFEST_MISSING && first) ||
                            (kind == TEST_MANIFEST_SINGLE_BUILD && b == 1) ||
                            (kind == TEST_MANIFEST_RUN_GAP && r == 2);
                        if (!omit_expected)
                        {
                            if (kind == TEST_MANIFEST_ROW && first)
                            {
                                fprintf(manifest, "%s\n", replacement);
                            }
                            else
                            {
                                fprintf(manifest, "%s %s %s %d %s\n", bs[b], ps[p], ms[m], r, es[e]);
                            }
                            if (kind == TEST_MANIFEST_DUPLICATE && first)
                            {
                                fprintf(manifest, "%s %s %s %d %s\n", bs[b], ps[p], ms[m], r, es[e]);
                            }
                        }
                        const bool omit = kind == TEST_EMPTY ||
                            (kind == TEST_MISSING_SAMPLE && first) ||
                            (kind == TEST_MISSING_BUILD && b == 1) ||
                            (kind == TEST_MISSING_PLACEMENT && p == 1) ||
                            (kind == TEST_MISSING_MODE && m == 1) ||
                            (kind == TEST_MISSING_EVENT && e == 1) ||
                            (kind == TEST_MISSING_RUN && r == 2);
                        const int actual_build = kind == TEST_REVERSE ? 1 - b : b;
                        const int value = 100 - actual_build * 20 + p * 10 + m * 40 + e * 5 + 3 - r;
                        if (!omit)
                        {
                            if (kind == TEST_ROW && first)
                            {
                                fprintf(input, "%s\n", replacement);
                            }
                            else if (kind == TEST_VALUE && first)
                            {
                                fprintf(input, "%s %s %s %d %s %s\n", bs[b], ps[p], ms[m], r, es[e], replacement);
                            }
                            else
                            {
                                fprintf(input, "%s %s %s %d %s %d\n", bs[actual_build], ps[p], ms[m], r, es[e], value);
                            }
                            if (kind == TEST_DUPLICATE && first)
                            {
                                fprintf(input, "%s %s %s %d %s %d\n", bs[b], ps[p], ms[m], r, es[e], value - 1);
                            }
                        }
                    }
                }
            }
        }
    }
    rewind(manifest);
    rewind(input);
}

static int run_test(const Test* test)
{
    int failures = 0;
    FILE* manifest = tmpfile();
    FILE* input = tmpfile();
    FILE* output = tmpfile();
    FILE* errors = tmpfile();
    if (manifest == NULL || input == NULL || output == NULL || errors == NULL)
    {
        fprintf(stderr, "fixture setup failed: %s\n", test->name);
        failures = 1;
    }
    else
    {
        fixture(manifest, input, test->kind, test->replacement);
        const int status = counters(manifest, input, output, errors);
        const long bytes = ftell(output);
        rewind(output);
        char result[8192];
        const size_t size = fread(result, 1, sizeof(result) - 1, output);
        result[size] = 0;
        if ((status == 0) != test->valid || (!test->valid && bytes != 0) ||
            (test->valid && (strstr(result, "mean over 4 placements; the change against main") == NULL ||
                            strstr(result, "-17.391% (-38.462% to +10.000%)") == NULL)))
        {
            fprintf(stderr, "FAIL %s: status=%d, output=%ld bytes\n", test->name, status, bytes);
            failures = 1;
        }
    }
    if (manifest != NULL)
    {
        fclose(manifest);
    }
    if (input != NULL)
    {
        fclose(input);
    }
    if (output != NULL)
    {
        fclose(output);
    }
    if (errors != NULL)
    {
        fclose(errors);
    }
    return failures;
}

int main(void)
{
    const Test tests[] =
    {
        {"complete grid", TEST_VALID, NULL, true},
        {"reference comes from manifest, not observation order", TEST_REVERSE, NULL, true},
        {"one missing sample", TEST_MISSING_SAMPLE, NULL, false},
        {"whole missing build", TEST_MISSING_BUILD, NULL, false},
        {"whole missing placement", TEST_MISSING_PLACEMENT, NULL, false},
        {"whole missing mode", TEST_MISSING_MODE, NULL, false},
        {"whole missing event", TEST_MISSING_EVENT, NULL, false},
        {"whole missing repetition", TEST_MISSING_RUN, NULL, false},
        {"duplicate with a lower count", TEST_DUPLICATE, NULL, false},
        {"empty observations", TEST_EMPTY, NULL, false},
        {"nan", TEST_VALUE, "nan", false},
        {"signed nan", TEST_VALUE, "-nan", false},
        {"infinity", TEST_VALUE, "inf", false},
        {"negative infinity", TEST_VALUE, "-inf", false},
        {"overflow", TEST_VALUE, "1e999", false},
        {"underflow", TEST_VALUE, "1e-999", false},
        {"zero", TEST_VALUE, "0", false},
        {"negative count", TEST_VALUE, "-1", false},
        {"sub-unit count", TEST_VALUE, "0.5", false},
        {"outside uint64 range", TEST_VALUE, "18446744073709551616", false},
        {"not counted", TEST_VALUE, "<not counted>", false},
        {"not supported", TEST_VALUE, "<not supported>", false},
        {"numeric suffix", TEST_VALUE, "100x", false},
        {"extra value", TEST_VALUE, "100 extra", false},
        {"empty value", TEST_VALUE, "", false},
        {"unknown build", TEST_ROW, "other 0-0 syntax 1 instructions:u 102", false},
        {"unknown placement", TEST_ROW, "main 123-456 syntax 1 instructions:u 102", false},
        {"unknown mode", TEST_ROW, "main 0-0 other 1 instructions:u 102", false},
        {"unknown event", TEST_ROW, "main 0-0 syntax 1 other:u 102", false},
        {"unknown run", TEST_ROW, "main 0-0 syntax 4 instructions:u 102", false},
        {"run zero", TEST_ROW, "main 0-0 syntax 0 instructions:u 102", false},
        {"negative run", TEST_ROW, "main 0-0 syntax -1 instructions:u 102", false},
        {"run suffix", TEST_ROW, "main 0-0 syntax 1x instructions:u 102", false},
        {"run overflow", TEST_ROW, "main 0-0 syntax 999999999999999999999 instructions:u 102", false},
        {"run outside mask", TEST_ROW, "main 0-0 syntax 33 instructions:u 102", false},
        {"short row", TEST_ROW, "main 0-0 syntax 1", false},
        {"blank row", TEST_ROW, "", false},
        {"incomplete manifest", TEST_MANIFEST_MISSING, NULL, false},
        {"duplicate manifest", TEST_MANIFEST_DUPLICATE, NULL, false},
        {"empty manifest", TEST_MANIFEST_EMPTY, NULL, false},
        {"no comparison build", TEST_MANIFEST_SINGLE_BUILD, NULL, false},
        {"manifest run gap", TEST_MANIFEST_RUN_GAP, NULL, false},
        {"manifest extra column", TEST_MANIFEST_ROW, "main 0-0 syntax 1 instructions:u 102", false},
        {"manifest bad run", TEST_MANIFEST_ROW, "main 0-0 syntax bad instructions:u", false},
        {"manifest short row", TEST_MANIFEST_ROW, "main 0-0 syntax", false},
        {"decimal notation", TEST_VALUE, "102.0", true},
        {"scientific notation", TEST_VALUE, "1.02e2", true},
    };
    int failures = 0;
    const size_t count = sizeof(tests) / sizeof(tests[0]);
    for (size_t i = 0; i < count; i += 1)
    {
        failures += run_test(&tests[i]);
    }
    char long_row[2048];
    memset(long_row, 'x', sizeof(long_row) - 1);
    long_row[sizeof(long_row) - 1] = 0;
    const Test oversized = {"oversized row", TEST_ROW, long_row, false};
    failures += run_test(&oversized);
    printf("counters: %zu tests, %d failures (synthetic fixtures, no hardware measurements)\n", count + 1, failures);
    return failures != 0;
}
