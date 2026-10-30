// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Run diagnostic-only compiler adapters in rotating order. Parse all complete
// intrinsic_setup_ns rows from bounded stderr, sum them with overflow checks,
// and reject compiler/pipe/protocol failures. No wall time is measured here.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define SETUP_STDERR_CAPACITY (UINT32_C(4) * 1024 * 1024)
#define SETUP_ARGUMENT_CAPACITY 1024

static bool setup_parse(const char* bytes, size_t length, uint64_t* total, uint64_t* rows)
{
    const char prefix[] = "intrinsic_setup_ns=";
    const size_t prefix_length = sizeof(prefix) - 1;
    size_t first = 0;
    bool valid = true;
    *total = 0;
    *rows = 0;
    while (valid && first < length)
    {
        const char* newline = memchr(bytes + first, '\n', length - first);
        const size_t end = newline == NULL ? length : (size_t)(newline - bytes);
        const size_t line_length = end - first;
        if (line_length >= prefix_length && memcmp(bytes + first, prefix, prefix_length) == 0)
        {
            valid = newline != NULL && line_length > prefix_length;
            uint64_t value = 0;
            for (size_t i = first + prefix_length; valid && i < end; i += 1)
            {
                const unsigned char byte = (unsigned char)bytes[i];
                valid = byte >= '0' && byte <= '9';
                const uint64_t digit = valid ? byte - '0' : 0;
                valid = valid && value <= (UINT64_MAX - digit) / 10;
                if (valid)
                {
                    value = value * 10 + digit;
                }
            }
            valid = valid && *total <= UINT64_MAX - value && *rows != UINT64_MAX;
            if (valid)
            {
                *total += value;
                *rows += 1;
            }
        }
        else
        {
            // A displaced marker is malformed, not an ordinary diagnostic line.
            for (size_t i = first; valid && i + prefix_length <= end; i += 1)
            {
                valid = memcmp(bytes + i, prefix, prefix_length) != 0;
            }
        }
        first = newline == NULL ? length : end + 1;
    }
    valid = valid && *rows != 0;
    return valid;
}

static bool setup_run(char* const* arguments, uint64_t* total, uint64_t* rows)
{
    int descriptors[2] = { -1, -1 };
    bool valid = pipe(descriptors) == 0;
    pid_t child = valid ? fork() : -1;
    valid = valid && child >= 0;
    if (child == 0)
    {
        close(descriptors[0]);
        const int null_output = open("/dev/null", O_WRONLY);
        bool redirected = null_output >= 0 && dup2(null_output, STDOUT_FILENO) == STDOUT_FILENO &&
                          dup2(descriptors[1], STDERR_FILENO) == STDERR_FILENO;
        if (null_output >= 0)
        {
            close(null_output);
        }
        close(descriptors[1]);
        if (redirected)
        {
            execv(arguments[0], arguments);
            perror("setup runner exec");
        }
        _exit(127);
    }
    char* captured = valid ? malloc((size_t)SETUP_STDERR_CAPACITY + 1) : NULL;
    valid = valid && captured != NULL;
    if (descriptors[1] >= 0)
    {
        close(descriptors[1]);
    }
    size_t length = 0;
    bool truncated = false;
    bool read_ok = true;
    if (child > 0)
    {
        char overflow[4096];
        bool finished = false;
        while (read_ok && !finished)
        {
            const bool store = captured != NULL && length < SETUP_STDERR_CAPACITY;
            char* destination = store ? captured + length : overflow;
            size_t capacity = store ? SETUP_STDERR_CAPACITY - length : sizeof(overflow);
            if (capacity > sizeof(overflow))
            {
                capacity = sizeof(overflow);
            }
            const ssize_t received = read(descriptors[0], destination, capacity);
            if (received > 0)
            {
                if (store)
                {
                    length += (size_t)received;
                }
                else
                {
                    truncated = true;
                }
            }
            else if (received == 0)
            {
                finished = true;
            }
            else if (errno != EINTR)
            {
                read_ok = false;
            }
        }
    }
    if (descriptors[0] >= 0)
    {
        close(descriptors[0]);
    }
    int status = 0;
    pid_t waited = -1;
    if (child > 0)
    {
        do
        {
            waited = waitpid(child, &status, 0);
        } while (waited < 0 && errno == EINTR);
    }
    valid = valid && read_ok && !truncated && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    valid = valid && setup_parse(captured, length, total, rows);
    if (!valid)
    {
        fprintf(stderr, "setup runner rejected compiler=%s exit_status=%d captured=%zu truncated=%d read_ok=%d\n",
                arguments[0], status, length, truncated, read_ok);
        if (captured != NULL && length != 0)
        {
            const size_t shown = length < 4096 ? length : 4096;
            fwrite(captured, 1, shown, stderr);
        }
    }
    free(captured);
    return valid;
}

static bool setup_count(const char* text, uint32_t maximum, uint32_t* output)
{
    char* end = NULL;
    errno = 0;
    const unsigned long value = strtoul(text, &end, 10);
    const bool valid = text[0] != '\0' && end != NULL && *end == '\0' && errno == 0 && value >= 1 && value <= maximum;
    if (valid)
    {
        *output = (uint32_t)value;
    }
    return valid;
}

static bool setup_self_test(void)
{
    struct SetupParseCase
    {
        const char* text;
        bool accepted;
        uint64_t total;
        uint64_t rows;
    };
    const struct SetupParseCase cases[] =
    {
        { "intrinsic_setup_ns=0\n", true, 0, 1 },
        { "ordinary warning\nintrinsic_setup_ns=10\nintrinsic_setup_ns=20\n", true, 30, 2 },
        { "intrinsic_setup_ns=18446744073709551615\n", true, UINT64_MAX, 1 },
        { "", false, 0, 0 },
        { "ordinary diagnostic\n", false, 0, 0 },
        { "intrinsic_setup_ns=\n", false, 0, 0 },
        { "intrinsic_setup_ns=-1\n", false, 0, 0 },
        { "intrinsic_setup_ns=1garbage\n", false, 0, 0 },
        { "intrinsic_setup_ns=1", false, 0, 0 },
        { " prefix intrinsic_setup_ns=1\n", false, 0, 0 },
        { "intrinsic_setup_ns=18446744073709551616\n", false, 0, 0 },
        { "intrinsic_setup_ns=18446744073709551615\nintrinsic_setup_ns=1\n", false, 0, 0 },
    };
    bool valid = true;
    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); i += 1)
    {
        uint64_t total = 0;
        uint64_t rows = 0;
        const bool accepted = setup_parse(cases[i].text, strlen(cases[i].text), &total, &rows);
        valid = valid && accepted == cases[i].accepted && (!accepted || (total == cases[i].total && rows == cases[i].rows));
    }
    printf("setup parser self-test: %zu cases, %s\n", sizeof(cases) / sizeof(cases[0]), valid ? "passed" : "FAILED");
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = true;
    if (argc == 2 && strcmp(argv[1], "--self-test") == 0)
    {
        valid = setup_self_test();
    }
    else
    {
        uint32_t rounds = 0;
        uint32_t expected_rows = 0;
        valid = argc >= 7 && argc <= SETUP_ARGUMENT_CAPACITY && strcmp(argv[5], "--") == 0 &&
                setup_count(argv[3], 10000, &rounds) && setup_count(argv[4], UINT32_MAX, &expected_rows);
        char** arguments = valid ? calloc((size_t)argc - 4, sizeof(*arguments)) : NULL;
        valid = valid && arguments != NULL;
        if (valid)
        {
            for (int i = 6; i < argc; i += 1)
            {
                arguments[i - 5] = argv[i];
            }
            printf("source,round,order,intrinsic_setup_ns,rows\n");
            for (uint32_t round = 0; valid && round < rounds; round += 1)
            {
                for (uint32_t order = 0; valid && order < 2; order += 1)
                {
                    const uint32_t version = (round + order) % 2;
                    arguments[0] = argv[1 + version];
                    uint64_t total = 0;
                    uint64_t rows = 0;
                    valid = setup_run(arguments, &total, &rows);
                    if (valid && rows != expected_rows)
                    {
                        fprintf(stderr, "setup runner rejected compiler=%s expected_rows=%u actual_rows=%" PRIu64 "\n", arguments[0], expected_rows, rows);
                        valid = false;
                    }
                    if (valid)
                    {
                        printf("%s,%u,%u,%" PRIu64 ",%" PRIu64 "\n", version == 0 ? "base" : "fixed", round, order, total, rows);
                    }
                }
            }
        }
        free(arguments);
    }
    if (!valid)
    {
        fprintf(stderr, "usage: setup_runner BASE FIXED ROUNDS EXPECTED_ROWS -- COMPILER_ARGS...\n");
    }
    return valid ? 0 : 1;
}
