#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
typedef struct CheckTest CheckTest;
struct CheckTest { unsigned passed; unsigned failed; };
static void check_test_expect(CheckTest* test, bool valid, const char* name)
{
    test->passed += valid;
    test->failed += !valid;
    if (!valid) { fprintf(stderr, "%s\n", name); }
}
