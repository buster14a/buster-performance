// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original end-to-end acceptance tests and adversarial reader fixture.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static unsigned checks;
static unsigned failures;

static void test_expect(bool valid, const char* name)
{
    checks += 1;
    failures += !valid;
    if (!valid) fprintf(stderr, "profile gate: %s\n", name);
}

static bool test_contains(const char* path, const char* expected)
{
    FILE* input = fopen(path, "r");
    char text[8192] = { 0 };
    const size_t bytes = input != NULL ? fread(text, 1, sizeof(text) - 1, input) : 0;
    bool valid = input != NULL && bytes < sizeof(text) - 1 && !ferror(input);
    if (input != NULL) valid = fclose(input) == 0 && valid;
    return valid && strstr(text, expected) != NULL;
}

static bool test_copy(const char* source, const char* destination)
{
    FILE* input = fopen(source, "rb");
    FILE* output = input != NULL ? fopen(destination, "wb") : NULL;
    bool valid = input != NULL && output != NULL;
    unsigned char bytes[4096];
    size_t count = 0;
    while (valid && (count = fread(bytes, 1, sizeof(bytes), input)) != 0)
    {
        valid = fwrite(bytes, 1, count, output) == count;
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL) valid = fclose(output) == 0 && valid;
    return valid;
}

static bool test_equal(const char* first, const char* second)
{
    FILE* left = fopen(first, "rb");
    FILE* right = fopen(second, "rb");
    unsigned char a[4096], b[4096];
    const size_t ac = left != NULL ? fread(a, 1, sizeof(a), left) : 0;
    const size_t bc = right != NULL ? fread(b, 1, sizeof(b), right) : 0;
    bool valid = left != NULL && right != NULL && ac == bc && ac != sizeof(a) && memcmp(a, b, ac) == 0;
    if (left != NULL)
    {
        valid = !ferror(left) && valid;
        valid = fclose(left) == 0 && valid;
    }
    if (right != NULL)
    {
        valid = !ferror(right) && valid;
        valid = fclose(right) == 0 && valid;
    }
    return valid;
}

static int test_run(char* const* command, const char* log, const char* mode, bool closed_stdio)
{
    const pid_t child = fork();
    if (child == 0)
    {
        if (mode != NULL) setenv("PROFILE_GATE_FAKE", mode, 1);
        const int output = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        if (output < 0) _exit(125);
        if (closed_stdio)
        {
            close(STDIN_FILENO);
            close(STDOUT_FILENO);
            close(STDERR_FILENO);
        }
        else if (dup2(output, STDOUT_FILENO) < 0 || dup2(output, STDERR_FILENO) < 0)
        {
            _exit(125);
        }
        if (output > STDERR_FILENO) close(output);
        execv(command[0], command);
        _exit(127);
    }
    int status = 0;
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
    }
    return waited == child && child > 0 && WIFEXITED(status) ? WEXITSTATUS(status) : 128;
}

static int test_reader(int argc, char** argv)
{
    const char* mode = getenv("PROFILE_GATE_FAKE");
    mode = mode != NULL ? mode : "clean";
    int result = 0;
    if (argc >= 2 && strcmp(argv[1], "--version") == 0)
    {
        puts("perf version original-test-reader");
        if (strcmp(mode, "version-error") == 0) fputs("reader error\n", stderr);
    }
    else if (argc >= 2 && strcmp(argv[1], "evlist") == 0)
    {
        if (strcmp(mode, "attributes-empty") != 0) puts("fixture");
        if (strcmp(mode, "attributes-extra") == 0) puts("extra");
        if (strncmp(mode, "multi-", 6) == 0) puts("other");
        if (strcmp(mode, "attributes-tip") == 0) puts("# Tip: fixture reader advice");
    }
    else if (argc >= 2 && strcmp(argv[1], "report") == 0)
    {
        if (strcmp(mode, "timeout") == 0)
        {
            for (;;) pause();
        }
        if (strcmp(mode, "signal") == 0) kill(getpid(), SIGKILL);
        if (strcmp(mode, "output-limit") == 0)
        {
            const char bytes[4096] = { 0 };
            for (;;) (void)fwrite(bytes, 1, sizeof(bytes), stdout);
        }
        if (strcmp(mode, "report-no-loss") != 0)
        {
            printf("# Total Lost Samples: %u\n", strcmp(mode, "report-loss") == 0 ? 1 : 0);
        }
        if (strcmp(mode, "report-no-sections") != 0)
        {
            puts(strcmp(mode, "report-section-garbage") == 0 ? "# Samples: garbage" :
                 strcmp(mode, "report-section-name") == 0 ? "# Samples: 1 of event 'wrong'" : "# Samples: 1 of event 'fixture'");
        }
        if (strcmp(mode, "header-zero") != 0)
        {
            if (strcmp(mode, "report-empty-columns") == 0) puts("1;;");
            else if (strcmp(mode, "report-overflow") == 0) puts("18446744073709551615 1;[.] one;fixture.so");
            else printf("%u;[.] one;fixture.so\n", strcmp(mode, "partial-zero") == 0 ? 0 :
                        strcmp(mode, "report-extra") == 0 || strcmp(mode, "multi-swapped") == 0 ? 2 : 1);
        }
        if (strncmp(mode, "multi-", 6) == 0)
        {
            puts(strcmp(mode, "multi-duplicate") == 0 ? "# Samples: 2 of event 'fixture'" : "# Samples: 2 of event 'other'");
            printf("%u;[.] two;fixture.so\n", strcmp(mode, "multi-swapped") == 0 ? 1 : 2);
        }
        if (strcmp(mode, "descendant-error") == 0 || strcmp(mode, "descendant-timeout") == 0)
        {
            fflush(NULL);
            const pid_t child = fork();
            if (child == 0)
            {
                if (strcmp(mode, "descendant-timeout") == 0) for (;;) pause();
                const struct timespec delay = { .tv_nsec = 200000000 };
                nanosleep(&delay, NULL);
                (void)write(STDERR_FILENO, "late reader error\n", 18);
                _exit(0);
            }
            if (child < 0) return 125;
        }
        if (strcmp(mode, "error-zero") == 0)
        {
            fputs("0x123 [0x90]: processing failed for event of type: READ (8) [Bad address]\nError:\nfailed to process sample\n", stderr);
        }
        if (strcmp(mode, "report-garbage") == 0) puts("unexpected reader output");
        if (strcmp(mode, "exit-nonzero") == 0) result = 7;
    }
    else if (argc >= 2 && strcmp(argv[1], "script") == 0)
    {
        bool debug = false;
        for (int i = 2; i < argc; i += 1) debug = debug || strcmp(argv[i], "-d") == 0;
        if (debug)
        {
            if (strcmp(mode, "order-missing") != 0)
            {
                fprintf(stderr, "Misordered timestamps: %u\n", strcmp(mode, "order-bad") == 0 ? 1 : 0);
            }
            if (strcmp(mode, "order-extra") == 0) fputs("reader warning\n", stderr);
            if (strcmp(mode, "order-output") == 0) puts("fixture:");
        }
        else
        {
            if (strcmp(mode, "events-short") != 0)
            {
                puts(strcmp(mode, "events-wrong") == 0 ? "other:" : strcmp(mode, "events-error") == 0 ? "Error:" : "fixture:");
            }
            if (strcmp(mode, "events-extra") == 0) puts("fixture:");
            if (strncmp(mode, "multi-", 6) == 0) { puts("other:"); puts("other:"); }
        }
    }
    else result = 2;
    return result;
}

static void test_gate(const char* gate, const char* self, const char* root, const char* data, const char* name,
                      const char* mode, int expected, const char* reason, bool require_duty, bool closed_stdio)
{
    char directory[PATH_MAX], log[PATH_MAX], receipt[PATH_MAX + 32], snapshot[PATH_MAX + 32];
    snprintf(directory, sizeof(directory), "%s/%s", root, name);
    snprintf(log, sizeof(log), "%s/%s.log", root, name);
    snprintf(receipt, sizeof(receipt), "%s/acceptance.json", directory);
    snprintf(snapshot, sizeof(snapshot), "%s/capture.data", directory);
    char* command[16];
    unsigned n = 0;
    command[n++] = (char*)gate;
    command[n++] = "--data";
    command[n++] = (char*)data;
    command[n++] = "--output-dir";
    command[n++] = directory;
    command[n++] = "--perf";
    command[n++] = (char*)self;
    command[n++] = "--timeout";
    command[n++] = "1";
    if (require_duty) command[n++] = "--require-duty";
    command[n] = NULL;
    const int result = test_run(command, log, mode, closed_stdio);
    test_expect(result == expected, name);
    test_expect(test_contains(receipt, expected == 0 ? "\"accepted\":true" : "\"accepted\":false"), "receipt agrees with exit status");
    char expected_reason[256];
    snprintf(expected_reason, sizeof(expected_reason), "\"reason\":\"%s\"", reason);
    test_expect(test_contains(receipt, expected_reason), "receipt carries the tested rejection reason");
    if (strcmp(reason, "input_snapshot_failed") != 0) test_expect(test_equal(data, snapshot), "source bytes preserved in private snapshot");
}

int main(int argc, char** argv)
{
    const bool reader = argc >= 2 && (strcmp(argv[1], "--version") == 0 || strcmp(argv[1], "evlist") == 0 ||
                                     strcmp(argv[1], "report") == 0 || strcmp(argv[1], "script") == 0);
    int result = 2;
    if (reader)
    {
        result = test_reader(argc, argv);
    }
    else if (argc == 3)
    {
        char root[] = "profile-gate-test-XXXXXX";
        char self[PATH_MAX];
        const ssize_t length = readlink("/proc/self/exe", self, sizeof(self) - 1);
        bool ready = length > 0 && (size_t)length < sizeof(self) && mkdtemp(root) != NULL;
        if (length > 0 && (size_t)length < sizeof(self)) self[length] = 0;
        char clean[PATH_MAX], partial[PATH_MAX], zero[PATH_MAX], two[PATH_MAX], log[PATH_MAX];
        snprintf(clean, sizeof(clean), "%s/clean.data", root);
        snprintf(partial, sizeof(partial), "%s/partial.data", root);
        snprintf(zero, sizeof(zero), "%s/zero.data", root);
        snprintf(two, sizeof(two), "%s/two.data", root);
        snprintf(log, sizeof(log), "%s/emitter.log", root);
        char* emit_clean[] = {
            argv[2],
            "--emit-clean",
            clean,
            NULL,
        };
        char* emit_partial[] = {
            argv[2],
            "--emit-partial-duty",
            partial,
            NULL,
        };
        char* emit_zero[] = {
            argv[2],
            "--emit-zero-duty",
            zero,
            NULL,
        };
        char* emit_two[] = { argv[2], "--emit-two-clean", two, NULL };
        ready = ready && test_run(emit_two, log, NULL, false) == 0 && test_run(emit_clean, log, NULL, false) == 0 && test_run(emit_partial, log, NULL, false) == 0 &&
                test_run(emit_zero, log, NULL, false) == 0;
        test_expect(ready, "original synthetic binary fixtures emitted");
        if (ready)
        {
            test_gate(argv[1], self, root, clean, "clean", "clean", 0, "complete_profile", false, false);
            static const char* modes[] = {
                "error-zero",
                "header-zero",
                "partial-zero",
                "exit-nonzero",
                "signal",
                "timeout",
                "output-limit",
                "report-loss",
                "report-no-loss",
                "report-no-sections",
                "report-overflow",
                "report-extra",
                "report-garbage",
                "report-section-garbage",
                "report-section-name",
                "report-empty-columns",
                "descendant-error",
                "descendant-timeout",
            };
            for (unsigned i = 0; i < sizeof(modes) / sizeof(modes[0]); i += 1)
            {
                test_gate(argv[1], self, root, clean, modes[i], modes[i], 1, "reader_report_incomplete", false, false);
            }
            test_gate(argv[1], self, root, two, "multi-clean", "multi-clean", 0, "complete_profile", false, false);
            test_gate(argv[1], self, root, two, "multi-swapped", "multi-swapped", 1, "reader_report_incomplete", false, false);
            test_gate(argv[1], self, root, two, "multi-duplicate", "multi-duplicate", 1, "reader_report_incomplete", false, false);
            static const char* sample_modes[] = {
                "events-short",
                "events-extra",
                "events-wrong",
                "events-error",
            };
            for (unsigned i = 0; i < sizeof(sample_modes) / sizeof(sample_modes[0]); i += 1)
            {
                test_gate(argv[1], self, root, clean, sample_modes[i], sample_modes[i], 1, "reader_sample_population_incomplete", false, false);
            }
            static const char* order_modes[] = {
                "order-bad",
                "order-missing",
                "order-extra",
                "order-output",
            };
            for (unsigned i = 0; i < sizeof(order_modes) / sizeof(order_modes[0]); i += 1)
            {
                test_gate(argv[1], self, root, clean, order_modes[i], order_modes[i], 1, "reader_ordering_unqualified", false, false);
            }
            test_gate(argv[1], self, root, clean, "version-error", "version-error", 1, "reader_version_failed", false, false);
            test_gate(argv[1], self, root, clean, "attributes-empty", "attributes-empty", 1, "reader_attributes_incomplete", false, false);
            test_gate(argv[1], self, root, clean, "attributes-extra", "attributes-extra", 1, "reader_attributes_incomplete", false, false);
            test_gate(argv[1], self, root, clean, "attributes-tip", "attributes-tip", 0, "complete_profile", false, false);
            test_gate(argv[1], self, root, partial, "partial-duty", "clean", 1, "counter_duty_incomplete", false, false);
            test_gate(argv[1], self, root, clean, "missing-duty", "clean", 1, "counter_duty_unavailable", true, false);
            test_gate(argv[1], self, root, zero, "zero-duty", "clean", 0, "complete_profile", false, false);
            test_gate(argv[1], self, root, zero, "zero-duty-required", "clean", 1, "counter_duty_unavailable", true, false);
            test_gate(argv[1], self, root, clean, "closed-stdio", "clean", 0, "complete_profile", false, true);
            test_gate(argv[1], self, root, clean, "quote-'\"-é", "clean", 0, "complete_profile", false, false);
            char utf8_argv[PATH_MAX];
            snprintf(utf8_argv, sizeof(utf8_argv), "%s/quote-'\"-é/report.argv.json", root);
            test_expect(test_contains(utf8_argv, "é"), "JSON argv preserves UTF-8 instead of relabeling its bytes");
            char corrupt[PATH_MAX];
            snprintf(corrupt, sizeof(corrupt), "%s/corrupt.data", root);
            test_expect(test_copy(clean, corrupt), "corrupt fixture copy");
            FILE* file = fopen(corrupt, "r+b");
            test_expect(file != NULL && fputc('X', file) != EOF && fclose(file) == 0, "bad magic authored independently");
            test_gate(argv[1], self, root, corrupt, "bad-magic", "clean", 1, "binary_rejected", false, false);
            char truncated[PATH_MAX];
            snprintf(truncated, sizeof(truncated), "%s/truncated.data", root);
            struct stat source;
            test_expect(stat(clean, &source) == 0 && test_copy(clean, truncated) && truncate(truncated, source.st_size - 1) == 0,
                        "truncated fixture authored independently");
            test_gate(argv[1], self, root, truncated, "truncated", "clean", 1, "binary_rejected", false, false);
            test_gate(argv[1], self, root, root, "nonregular", "clean", 1, "input_snapshot_failed", false, false);
            char fifo[PATH_MAX];
            snprintf(fifo, sizeof(fifo), "%s/input.fifo", root);
            test_expect(mkfifo(fifo, 0600) == 0, "FIFO source fixture");
            test_gate(argv[1], self, root, fifo, "fifo", "clean", 1, "input_snapshot_failed", false, false);
            char huge[PATH_MAX];
            snprintf(huge, sizeof(huge), "%s/oversize.data", root);
            const int large = open(huge, O_WRONLY | O_CREAT | O_EXCL, 0600);
            test_expect(large >= 0 && ftruncate(large, (UINT64_C(1) << 30) + 1) == 0 && close(large) == 0,
                        "sparse oversized input fixture");
            test_gate(argv[1], self, root, huge, "oversize", "clean", 1, "input_snapshot_failed", false, false);
            char existing[PATH_MAX];
            snprintf(existing, sizeof(existing), "%s/clean", root);
            char* reuse[] = {
                argv[1],
                "--data",
                clean,
                "--output-dir",
                existing,
                "--perf",
                self,
                NULL,
            };
            test_expect(test_run(reuse, log, "clean", false) == 2, "existing evidence directory is never overwritten");
        }
        printf("profile gate: %u checks, %u failures; retained %s\n", checks, failures, root);
        result = failures != 0;
    }
    else
    {
        fprintf(stderr, "usage: profile_gate_test PROFILE_GATE PERF_DATA_TEST\n");
    }
    return result;
}
