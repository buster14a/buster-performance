// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Synthetic protocol fixtures only. No values here are measurements.
#define _POSIX_C_SOURCE 200809L
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static bool fixture(const char* root, unsigned mutation, unsigned order, unsigned flags, unsigned after)
{
    char path[2048];
    snprintf(path, sizeof(path), "%s/exit.txt", root);
    FILE* file = fopen(path, "wb");
    bool okay = file != 0 && fputs(mutation == 1 ? "1\n" : "0\n", file) >= 0;
    if (file != 0)
    {
        okay &= fclose(file) == 0;
    }
    snprintf(path, sizeof(path), "%s/stderr.log", root);
    file = fopen(path, "wb");
    okay &= file != 0;
    if (file != 0)
    {
        okay &= mutation != 2 || fputs("counter unavailable\n", file) >= 0;
        okay &= fclose(file) == 0;
    }
    snprintf(path, sizeof(path), "%s/stdout.log", root);
    file = fopen(path, "wb");
    okay &= file != 0;
    for (unsigned step = 0; okay && step < 64; step += 1)
    {
        if (mutation == 4 && step == 63)
        {
            continue;
        }
        const unsigned strides[] = {17, 19, 23};
        const unsigned shifts[] = {0, 21, 43};
        const unsigned phase = mutation == 3 && step == 1 ? 0 : mutation == 10 && step == 1 ? 64 : (step * strides[order] + shifts[order]) & 63;
        const uint64_t address = UINT64_C(4160) + 64 * phase + (mutation == 5 && step == 1 ? 4096 : 0);
        if (mutation == 9 && step == 1)
        {
            okay &= fprintf(file, "phase=18446744073709551616 step=%u order=%u template=%" PRIu64 " mod4096=%" PRIu64 "\n", step, order, address, address & 4095) > 0;
        }
        else
        {
            okay &= fprintf(file, "phase=%u step=%u order=%u template=%" PRIu64 " mod4096=%" PRIu64 "\n", phase, step, order, address, address & 4095) > 0;
        }
        const unsigned bytes = (mutation == 11 && step == 1) || mutation == 18 ? 259727 : 259726;
        const char* fixups = (flags & 2) != 0 ? mutation == 19 ? ", with fixup ends (3826 marked)" : ", with fixup ends (3825 marked)" : "";
        okay &= fprintf(file, "65536 mixed instructions, %u bytes (3.96 per instruction), in calls of 65536%s%s; 21 interleaved passes of 64 runs%s, medians (cycles also min-max):\n", bytes, (flags & 1) != 0 ? ", with offsets" : "", fixups, after != 0 ? ", each after 30 ms of the scalar loop" : "") > 0;
        okay &= fprintf(file, " x86_encode_16 %s ns 1 M/s 1 GB/s %u cycles [%u-%u] %u instructions IPC 1 throttle 0", mutation == 8 && step == 1 ? "nan" : "1", mutation == 7 && step == 1 ? 0 : 1, mutation == 7 && step == 1 ? 0 : 1, mutation == 7 && step == 1 ? 0 : 1, mutation == 15 && step == 1 ? 0 : 1) > 0;
        if (mutation == 17 && step == 1)
        {
            okay &= fwrite("\0ignored", 1, 8, file) == 8;
        }
        okay &= fputc('\n', file) != EOF;
        okay &= fputs("  (per encoded instruction; GB/s of machine code; throttle: PMCx1A0 umask 0x08, read as the dispatch slots the power cap takes)\n", file) >= 0;
        okay &= fprintf(file, "phase allocations: %u identity=%u stable=%u\n", mutation == 14 && step == 1 ? 47 : 46, mutation == 6 && step == 1 ? 43 : 42, mutation == 16 && step == 1 ? 0 : 1) > 0;
    }
    if (file != 0)
    {
        okay &= fprintf(file, "phase scan: %s; 64 phases, fixed executable and allocation addresses\n", mutation == 12 ? "FAIL" : "pass") > 0;
        okay &= mutation != 13 || fputs("extra\n", file) >= 0;
        okay &= fclose(file) == 0;
    }
    return okay;
}

static bool run_reader(const char* executable, const char* root, unsigned mutation, unsigned option, bool full, unsigned order, unsigned flags, unsigned after)
{
    char output[2048], error[2048];
    snprintf(output, sizeof(output), "%s/summary.csv", root);
    snprintf(error, sizeof(error), "%s/reader.err", root);
    const pid_t child = fork();
    if (child == 0)
    {
        const int out = open(full ? "/dev/full" : output, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        const int err = open(error, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        if (out < 0 || err < 0 || dup2(out, STDOUT_FILENO) < 0 || dup2(err, STDERR_FILENO) < 0)
        {
            _exit(127);
        }
        close(out);
        close(err);
        char order_text[16], flags_text[16], after_text[16];
        snprintf(order_text, sizeof(order_text), "%u", option == 1 ? 1 : order);
        snprintf(flags_text, sizeof(flags_text), "%u", option == 2 ? 3 : flags);
        snprintf(after_text, sizeof(after_text), "%u", option == 3 ? 30 : after);
        execl(executable, executable, root, order_text, flags_text, after_text, (char*)0);
        _exit(127);
    }
    int status = 0;
    bool okay = child > 0 && waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == (mutation == 0 && option == 0 && !full ? 0 : 1);
    struct stat info;
    okay &= stat(error, &info) == 0 && info.st_size == 0;
    if (!full)
    {
        FILE* file = fopen(output, "rb");
        okay &= file != 0;
        unsigned lines = 0;
        if (file != 0)
        {
            int c;
            while ((c = fgetc(file)) != EOF)
            {
                lines += c == '\n';
            }
            okay &= !ferror(file) && fclose(file) == 0;
        }
        okay &= lines == (mutation == 0 && option == 0 ? 65u : 0u);
    }
    return okay;
}

int main(int argc, char** argv)
{
    char temporary[] = "/tmp/buster421-phase-reader-XXXXXX";
    char* root = argc == 2 ? mkdtemp(temporary) : 0;
    bool okay = root != 0;
    unsigned checks = 0;
    for (unsigned mutation = 0; okay && mutation <= 19; mutation += 1)
    {
        const unsigned flags = mutation == 19 ? 2 : 0;
        okay &= fixture(root, mutation, 0, flags, 0) && run_reader(argv[1], root, mutation, 0, false, 0, flags, 0);
        checks += 1;
    }
    for (unsigned option = 1; okay && option <= 3; option += 1)
    {
        okay &= fixture(root, 0, 0, 0, 0) && run_reader(argv[1], root, 0, option, false, 0, 0, 0);
        checks += 1;
    }
    if (okay)
    {
        okay &= fixture(root, 0, 0, 0, 0) && run_reader(argv[1], root, 0, 0, true, 0, 0, 0);
        checks += 1;
    }
    for (unsigned order = 0; okay && order < 3; order += 1)
    {
        for (unsigned flags = 0; okay && flags < 4; flags += 1)
        {
            for (unsigned power = 0; okay && power < 2; power += 1)
            {
                const unsigned after = power != 0 ? 30 : 0;
                okay &= fixture(root, 0, order, flags, after) && run_reader(argv[1], root, 0, 0, false, order, flags, after);
                checks += 1;
            }
        }
    }
    if (root != 0)
    {
        const char* names[] = {"exit.txt", "stderr.log", "stdout.log", "summary.csv", "reader.err"};
        char path[2048];
        for (unsigned i = 0; i < sizeof(names) / sizeof(names[0]); i += 1)
        {
            snprintf(path, sizeof(path), "%s/%s", root, names[i]);
            okay &= unlink(path) == 0;
        }
        okay &= rmdir(root) == 0;
    }
    fprintf(stderr, "phase reader synthetic fixtures: %s (%u checks)\n", okay ? "pass" : "FAIL", checks);
    return okay ? 0 : 1;
}
