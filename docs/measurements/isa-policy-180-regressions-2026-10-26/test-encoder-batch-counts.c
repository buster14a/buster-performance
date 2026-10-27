// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Synthetic parser fixtures only; these values are never performance receipts.
#define _GNU_SOURCE
#define BUSTER_RECEIPT_BATCH_SIZE 36
#define BUSTER_RECEIPT_PLAIN_BATCH_SIZE 54
#define BUSTER_RECEIPT_AFTER_MS 30
#define main receipt_reader_main
#include "read-current-encoder.c"
#undef main
#include <unistd.h>

static bool write_processes(const char* directory, unsigned count, unsigned mutation)
{
    char path[2048];
    snprintf(path, sizeof(path), "%s/processes.tsv", directory);
    FILE* file = fopen(path, "wb");
    bool okay = file != 0;
    if (okay)
    {
        okay &= fprintf(file, "round\tcommand\tlabel\trun\twarmup\tstatus\twall_ns\tuser_us\tsys_us\tminflt\tmajflt\tnvcsw\tnivcsw\tmaxrss_kb\thuge_kb\trss_kb\tstart_stack\tcounters\n") > 0;
        const unsigned rows = count + (mutation == 1 || mutation == 2) - (mutation == 3);
        for (unsigned i = 0; okay && i < rows; i += 1)
        {
            const unsigned index = i == count && mutation == 2 ? count - 1 : i;
            okay &= fprintf(file, "1\t%u\tfixture-%u\t0\t0\t0\t1000\t1\t0\t1\t0\t0\t0\t1\t-1\t-1\t-1\n", index, index) > 0;
        }
        okay &= fclose(file) == 0;
    }
    return okay;
}

static bool write_fixture(const char* root, const char* batch, unsigned count, bool conditioned)
{
    char directory[1024], path[2048];
    snprintf(directory, sizeof(directory), "%s/%s", root, batch);
    bool okay = mkdir(directory, 0700) == 0;
    const char* names[] = {"image-identities.sha256", "image-inodes.txt", "harness-check.log", "commands.list", "exit.txt", "harness.err"};
    for (unsigned i = 0; okay && i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        snprintf(path, sizeof(path), "%s/%s", directory, names[i]);
        FILE* file = fopen(path, "wb");
        okay &= file != 0;
        if (file != 0)
        {
            okay &= i == 5 || fputs(i == 4 ? "0\n" : "synthetic fixture\n", file) >= 0;
            okay &= fclose(file) == 0;
        }
    }
    for (unsigned i = 0; okay && i < count; i += 1)
    {
        snprintf(path, sizeof(path), "%s/1-fixture-%u-0.out", directory, i);
        FILE* file = fopen(path, "wb");
        okay &= file != 0;
        if (file != 0)
        {
            okay &= fprintf(file, "65537 mixed instructions, 259736 bytes (3.96 per instruction), in calls of 129; 21 interleaved passes of 64 runs%s, medians (cycles also min-max):\n", conditioned ? ", each after 30 ms of the scalar loop" : "") > 0;
            okay &= fputs(" x86_encode_16 1 ns 1 M/s 1 GB/s 1 cycles [1-1] 1 instructions IPC 1 throttle 0\n  (per encoded instruction; GB/s of machine code; throttle: PMCx1A0 umask 0x08, read as the dispatch slots the power cap takes)\n", file) >= 0;
            okay &= fclose(file) == 0;
        }
        snprintf(path, sizeof(path), "%s/1-fixture-%u-0.err", directory, i);
        file = fopen(path, "wb");
        okay &= file != 0 && fclose(file) == 0;
    }
    okay &= write_processes(directory, count, 0);
    return okay;
}

static bool remove_fixture(const char* root, const char* batch)
{
    char directory[1024], path[2048];
    snprintf(directory, sizeof(directory), "%s/%s", root, batch);
    DIR* handle = opendir(directory);
    bool okay = handle != 0;
    struct dirent* entry = handle != 0 ? readdir(handle) : 0;
    while (entry != 0)
    {
        if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
        {
            snprintf(path, sizeof(path), "%s/%s", directory, entry->d_name);
            okay &= unlink(path) == 0;
        }
        entry = readdir(handle);
    }
    if (handle != 0)
    {
        okay &= closedir(handle) == 0;
    }
    okay &= rmdir(directory) == 0;
    return okay;
}

int main(void)
{
    char temporary[] = "/tmp/buster421-counts-XXXXXX";
    char* root = mkdtemp(temporary);
    bool okay = root != 0;
    unsigned checks = 0;
    const char* batches[] = {"plain54", "conditioned36"};
    for (unsigned condition = 0; okay && condition < 2; condition += 1)
    {
        const unsigned count = condition != 0 ? 36 : 54;
        const char* batch = batches[condition];
        char directory[1024], label[64];
        snprintf(directory, sizeof(directory), "%s/%s", root, batch);
        snprintf(label, sizeof(label), "fixture-%u", count - 1);
        Sample sample = {.round = 1, .condition = condition};
        okay &= write_fixture(root, batch, count, condition != 0);
        okay &= complete_batch(root, batch, count) && !complete_batch(root, batch, condition != 0 ? 54 : 36);
        checks += 1;
        okay &= read_sample(root, batch, count - 1, label, &sample);
        checks += 1;
        for (unsigned mutation = 1; mutation <= 3; mutation += 1)
        {
            okay &= write_processes(directory, count, mutation) && !read_sample(root, batch, count - 1, label, &sample);
            checks += 1;
        }
        okay &= write_processes(directory, count, 0);
        sample.condition ^= 1;
        okay &= !read_sample(root, batch, count - 1, label, &sample);
        checks += 1;
    }
    if (root != 0)
    {
        for (unsigned i = 0; i < 2; i += 1)
        {
            okay &= remove_fixture(root, batches[i]);
        }
        okay &= rmdir(root) == 0;
    }
    printf("54-plain/36-conditioned synthetic reader fixtures: %s (%u checks)\n", okay ? "pass" : "FAIL", checks);
    return okay ? 0 : 1;
}
