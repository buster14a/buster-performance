// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded object-equivalence qualification for #613. No timings are reported by this test.
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

static bool compile(const char* executable, const char* source, const char* object, bool sqlite)
{
    char* arguments[32];
    unsigned count = 0;
    arguments[count++] = (char*)executable;
    arguments[count++] = "--lanes";
    arguments[count++] = "1";
    arguments[count++] = "-c";
    if (sqlite)
    {
        arguments[count++] = "--predefines";
        arguments[count++] = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/provenance/gnu17-pinned-predefines.txt";
        arguments[count++] = "--clang-features";
        arguments[count++] = "--target=x86_64-linux-gnu";
        arguments[count++] = "-march=znver5";
        arguments[count++] = "-std=gnu17";
        arguments[count++] = "-nostdinc";
        arguments[count++] = "-isystem";
        arguments[count++] = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/lib/clang/23/include";
        arguments[count++] = "-isystem";
        arguments[count++] = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/local/include";
        arguments[count++] = "-isystem";
        arguments[count++] = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/include";
    }
    arguments[count++] = (char*)source;
    arguments[count++] = "-o";
    arguments[count++] = (char*)object;
    arguments[count] = NULL;
    const pid_t child = fork();
    if (child == 0)
    {
        execv(executable, arguments);
        _exit(127);
    }
    int status = 0;
    pid_t waited;
    do
    {
        waited = child > 0 ? waitpid(child, &status, 0) : -1;
    }
    while (waited < 0 && errno == EINTR);
    const bool valid = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    if (!valid)
    {
        fprintf(stderr, "verify: %s refused %s (wait status %d)\n", executable, source, status);
    }
    return valid;
}

static bool same_file(const char* left, const char* right)
{
    const int a = open(left, O_RDONLY);
    const int b = open(right, O_RDONLY);
    bool valid = a >= 0 && b >= 0;
    unsigned char first[4096];
    unsigned char second[4096];
    bool more = valid;
    while (more)
    {
        const ssize_t x = read(a, first, sizeof(first));
        const ssize_t y = read(b, second, sizeof(second));
        valid = x >= 0 && x == y && memcmp(first, second, x > 0 ? (size_t)x : 0) == 0;
        more = valid && x != 0;
    }
    if (a >= 0)
    {
        close(a);
    }
    if (b >= 0)
    {
        close(b);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    const char* shapes[] = { "chain", "reverse", "wide", "large-chain" };
    const char* bodies[] = { "empty", "body" };
    const unsigned counts[] = { 2000, 4000, 8000, 16000 };
    char source[4096];
    char base[4096];
    char head[4096];
    if (valid)
    {
        const int a = snprintf(base, sizeof(base), "%s/objects/verify-base.o", argv[3]);
        const int b = snprintf(head, sizeof(head), "%s/objects/verify-head.o", argv[3]);
        valid = a > 0 && (unsigned)a < sizeof(base) && b > 0 && (unsigned)b < sizeof(head);
    }
    unsigned checked = 0;
    for (unsigned shape = 0; valid && shape < 4; shape += 1)
    {
        for (unsigned body = 0; valid && body < 2; body += 1)
        {
            for (unsigned size = 0; valid && size < 4; size += 1)
            {
                const int length = snprintf(source, sizeof(source), "%s/inputs/%s-%s-%u.c", argv[3], shapes[shape], bodies[body], counts[size]);
                valid = length > 0 && (unsigned)length < sizeof(source) && compile(argv[1], source, base, false) &&
                        compile(argv[2], source, head, false) && same_file(base, head);
                printf("%s %s %u: %s\n", shapes[shape], bodies[body], counts[size], valid ? "status 0, identical objects" : "FAILED");
                checked += valid;
            }
        }
    }
    if (valid)
    {
        const char* sqlite = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c";
        valid = compile(argv[1], sqlite, base, true) && compile(argv[2], sqlite, head, true) && same_file(base, head);
        printf("sqlite: %s\n", valid ? "status 0, identical objects" : "FAILED");
        checked += valid;
    }
    printf("verify: %u of 33 cases passed\n", checked);
    return valid && checked == 33 ? 0 : 1;
}
