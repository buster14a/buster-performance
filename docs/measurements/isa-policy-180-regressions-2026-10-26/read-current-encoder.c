// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Completeness/status/capture gate for the frozen campaign. No summary is written for incomplete or invalid input.
#define _POSIX_C_SOURCE 200809L
#include <math.h>
#include <dirent.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define SAMPLE_COUNT 1728
#define GROUP_COUNT 72
#ifndef BUSTER_RECEIPT_BATCH_SIZE
#define BUSTER_RECEIPT_BATCH_SIZE 12
#endif
#ifndef BUSTER_RECEIPT_PLAIN_BATCH_SIZE
#define BUSTER_RECEIPT_PLAIN_BATCH_SIZE BUSTER_RECEIPT_BATCH_SIZE
#endif
#ifndef BUSTER_RECEIPT_AFTER_MS
#define BUSTER_RECEIPT_AFTER_MS 100
#endif
_Static_assert(BUSTER_RECEIPT_BATCH_SIZE > 0 && BUSTER_RECEIPT_BATCH_SIZE < 64, "receipt mask capacity");
_Static_assert(BUSTER_RECEIPT_PLAIN_BATCH_SIZE > 0 && BUSTER_RECEIPT_PLAIN_BATCH_SIZE < 64, "plain receipt mask capacity");

typedef struct Sample
{
    unsigned round;
    unsigned condition;
    unsigned flags;
    unsigned role;
    unsigned placement;
    unsigned copy;
    double values[9];
} Sample;

static bool line_end(const char* text)
{
    return text[0] == '\n' && text[1] == 0;
}

static bool empty_file(const char* path)
{
    FILE* file = fopen(path, "rb");
    bool okay = file != 0 && fgetc(file) == EOF && !ferror(file);
    if (file != 0)
    {
        okay &= fclose(file) == 0;
    }
    return okay;
}

static bool unsigned_number(const char* text, uint64_t* result)
{
    uint64_t value = 0;
    bool okay = *text != 0;
    for (const char* c = text; okay && *c != 0; c += 1)
    {
        const unsigned digit = (unsigned char)*c - (unsigned)'0';
        okay = digit < 10 && value <= (UINT64_MAX - digit) / 10;
        if (okay)
        {
            value = value * 10 + digit;
        }
    }
    *result = value;
    return okay;
}

static bool fields_split(char* text, char** fields, unsigned count)
{
    char* cursor = text;
    bool okay = true;
    for (unsigned i = 0; okay && i < count; i += 1)
    {
        fields[i] = cursor;
        char* end = strchr(cursor, i + 1 < count ? '\t' : '\n');
        okay = end != 0 && (i + 1 < count || end[1] == 0);
        if (okay)
        {
            *end = 0;
            cursor = end + 1;
        }
    }
    return okay;
}

static double median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[count / 2];
}

static bool complete_batch(const char* root, const char* batch, unsigned batch_count)
{
    char path[2048];
    const char* metadata[] = {"image-identities.sha256", "image-inodes.txt", "harness-check.log", "commands.list"};
    bool okay = true;
    for (unsigned i = 0; i < sizeof(metadata) / sizeof(metadata[0]); i += 1)
    {
        snprintf(path, sizeof(path), "%s/%s/%s", root, batch, metadata[i]);
        FILE* file = fopen(path, "rb");
        okay &= file != 0 && fgetc(file) != EOF;
        if (file != 0)
        {
            okay &= !ferror(file);
            okay &= fclose(file) == 0;
        }
    }
    snprintf(path, sizeof(path), "%s/%s", root, batch);
    DIR* directory = opendir(path);
    okay &= directory != 0;
    unsigned files = 0;
    errno = 0;
    struct dirent* entry = directory != 0 ? readdir(directory) : 0;
    while (entry != 0)
    {
        if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
        {
            snprintf(path, sizeof(path), "%s/%s/%s", root, batch, entry->d_name);
            struct stat status;
            okay &= lstat(path, &status) == 0 && S_ISREG(status.st_mode);
            files += 1;
        }
        errno = 0;
        entry = readdir(directory);
    }
    if (directory != 0)
    {
        okay &= errno == 0;
        okay &= closedir(directory) == 0;
    }
    return okay && files == 2 * batch_count + 7;
}

static bool read_sample(const char* root, const char* batch, unsigned command, const char* label, Sample* sample)
{
    const unsigned batch_count = sample->condition != 0 ? BUSTER_RECEIPT_BATCH_SIZE : BUSTER_RECEIPT_PLAIN_BATCH_SIZE;
    char path[2048];
    char line[4096] = {0};
    snprintf(path, sizeof(path), "%s/%s/exit.txt", root, batch);
    FILE* file = fopen(path, "r");
    bool okay = file != 0 && fgets(line, sizeof(line), file) != 0 && strcmp(line, "0\n") == 0 && fgetc(file) == EOF;
    if (file != 0)
    {
        okay &= !ferror(file);
        okay &= fclose(file) == 0;
    }
    snprintf(path, sizeof(path), "%s/%s/harness.err", root, batch);
    okay &= empty_file(path);
    snprintf(path, sizeof(path), "%s/%s/%u-%s-0.err", root, batch, sample->round, label);
    okay &= empty_file(path);
    snprintf(path, sizeof(path), "%s/%s/processes.tsv", root, batch);
    file = fopen(path, "r");
    okay &= file != 0 && fgets(line, sizeof(line), file) != 0 && strcmp(line, "round\tcommand\tlabel\trun\twarmup\tstatus\twall_ns\tuser_us\tsys_us\tminflt\tmajflt\tnvcsw\tnivcsw\tmaxrss_kb\thuge_kb\trss_kb\tstart_stack\tcounters\n") == 0;
    uint64_t seen = 0;
    unsigned matches = 0;
    while (file != 0 && fgets(line, sizeof(line), file) != 0)
    {
        char* fields[17] = {0};
        uint64_t values[14] = {0};
        bool parsed = fields_split(line, fields, 17);
        for (unsigned i = 0; parsed && i < 14; i += 1)
        {
            if (i != 2)
            {
                parsed &= unsigned_number(fields[i], &values[i]);
            }
        }
        const uint64_t index = values[1];
        okay &= parsed && values[0] == sample->round && index < batch_count && (seen & (UINT64_C(1) << index)) == 0 && values[3] == 0 && values[4] == 0 && values[5] == 0 && values[6] != 0 && values[6] <= UINT64_C(90000000000) && values[7] != 0 && values[7] <= UINT64_C(90000000) && values[8] <= UINT64_C(90000000) && values[9] != 0 && values[13] != 0 && strcmp(fields[14], "-1") == 0 && strcmp(fields[15], "-1") == 0 && strcmp(fields[16], "-1") == 0;
        if (parsed && index < batch_count)
        {
            seen |= UINT64_C(1) << index;
        }
        if (parsed && index == command)
        {
            okay &= strcmp(fields[2], label) == 0;
            matches += 1;
            sample->values[4] = (double)values[6];
            sample->values[5] = (double)values[13];
            sample->values[6] = (double)values[9];
            sample->values[7] = (double)(values[7] + values[8]);
            sample->values[8] = (double)values[10];
        }
    }
    okay &= seen == (UINT64_C(1) << batch_count) - 1 && matches == 1;
    if (file != 0)
    {
        okay &= !ferror(file);
        okay &= fclose(file) == 0;
    }
    snprintf(path, sizeof(path), "%s/%s/%u-%s-0.out", root, batch, sample->round, label);
    file = fopen(path, "r");
    const char prefix[] = "65537 mixed instructions, 259736 bytes (3.96 per instruction), in calls of 129";
    okay &= file != 0 && fgets(line, sizeof(line), file) != 0 && strncmp(line, prefix, sizeof(prefix) - 1) == 0;
    if (file != 0)
    {
        char fixups[96] = {0};
        uint64_t marked = 0;
        if ((sample->flags & 2) != 0)
        {
            const char* start = strstr(line, ", with fixup ends (");
            const char* number = start != 0 ? start + strlen(", with fixup ends (") : 0;
            const char* end = number != 0 ? strchr(number, ' ') : 0;
            char digits[32] = {0};
            const bool bounded = end != 0 && (size_t)(end - number) < sizeof(digits);
            if (bounded)
            {
                memcpy(digits, number, (size_t)(end - number));
            }
            okay &= bounded && unsigned_number(digits, &marked) && marked != 0 && marked <= 65537;
            snprintf(fixups, sizeof(fixups), ", with fixup ends (%llu marked)", (unsigned long long)marked);
        }
        char expected[1024];
        char after[96] = {0};
        if (sample->condition != 0)
        {
            snprintf(after, sizeof(after), ", each after %u ms of the scalar loop", BUSTER_RECEIPT_AFTER_MS);
        }
        snprintf(expected, sizeof(expected), "%s%s%s; 21 interleaved passes of 64 runs%s, medians (cycles also min-max):\n", prefix, (sample->flags & 1) != 0 ? ", with offsets" : "", fixups, after);
        okay &= strcmp(line, expected) == 0;
        double throughput = 0, bandwidth = 0, low = 0, high = 0, ipc = 0;
        int end = 0;
        const bool present = fgets(line, sizeof(line), file) != 0;
        const int fields = present ? sscanf(line, " x86_encode_16 %lf ns %lf M/s %lf GB/s %lf cycles [%lf-%lf] %lf instructions IPC %lf throttle %lf%n", &sample->values[0], &throughput, &bandwidth, &sample->values[1], &low, &high, &sample->values[2], &ipc, &sample->values[3], &end) : 0;
        okay &= fields == 9 && line_end(line + end) && sample->values[0] > 0 && sample->values[1] > 0 && sample->values[2] > 0 && sample->values[3] >= 0 && throughput > 0 && bandwidth > 0 && low > 0 && low <= sample->values[1] && sample->values[1] <= high && ipc > 0;
        for (unsigned i = 0; i < 9; i += 1)
        {
            okay &= isfinite(sample->values[i]);
        }
        okay &= isfinite(throughput) && isfinite(bandwidth) && isfinite(low) && isfinite(high) && isfinite(ipc);
        okay &= fgets(line, sizeof(line), file) != 0 && strcmp(line, "  (per encoded instruction; GB/s of machine code; throttle: PMCx1A0 umask 0x08, read as the dispatch slots the power cap takes)\n") == 0 && fgetc(file) == EOF;
        okay &= !ferror(file);
        okay &= fclose(file) == 0;
    }
    return okay;
}

int main(int argc, char** argv)
{
    static Sample samples[SAMPLE_COUNT];
    static bool slots[3][2][4][3][12][3];
    bool okay = argc == 3;
    FILE* manifest = okay ? fopen(argv[2], "r") : 0;
    okay &= manifest != 0;
    char line[4096];
    unsigned count = 0;
    unsigned groups[GROUP_COUNT] = {0};
    while (okay && fgets(line, sizeof(line), manifest) != 0)
    {
        char batch[128] = {0}, label[128] = {0};
        char* fields[9] = {0};
        uint64_t numbers[8] = {0};
        bool parsed = fields_split(line, fields, 9);
        for (unsigned i = 1; parsed && i < 8; i += 1)
        {
            parsed &= unsigned_number(fields[i], &numbers[i]);
        }
        Sample sample = {0};
        const unsigned batch_count = numbers[2] != 0 ? BUSTER_RECEIPT_BATCH_SIZE : BUSTER_RECEIPT_PLAIN_BATCH_SIZE;
        okay = parsed && strlen(fields[0]) < sizeof(batch) && strlen(fields[8]) < sizeof(label) && numbers[1] >= 1 && numbers[1] <= 3 && numbers[2] <= 1 && numbers[3] <= 3 && numbers[4] <= 2 && numbers[5] < 12 && numbers[6] < (numbers[2] != 0 ? 1u : 3u) && numbers[7] < batch_count && count < SAMPLE_COUNT;
        if (okay)
        {
            strcpy(batch, fields[0]);
            strcpy(label, fields[8]);
            sample.round = (unsigned)numbers[1];
            sample.condition = (unsigned)numbers[2];
            sample.flags = (unsigned)numbers[3];
            sample.role = (unsigned)numbers[4];
            sample.placement = (unsigned)numbers[5];
            sample.copy = (unsigned)numbers[6];
            const unsigned command = (unsigned)numbers[7];
            bool* slot = &slots[sample.round - 1][sample.condition][sample.flags][sample.role][sample.placement][sample.copy];
            okay = !*slot && complete_batch(argv[1], batch, batch_count) && read_sample(argv[1], batch, command, label, &sample);
            *slot = true;
            groups[(((sample.round - 1) * 2 + sample.condition) * 4 + sample.flags) * 3 + sample.role] += 1;
            samples[count++] = sample;
        }
        if (!okay)
        {
            fprintf(stderr, "invalid/incomplete receipt, manifest row %u: %s", count, line);
        }
    }
    if (manifest != 0)
    {
        okay &= !ferror(manifest);
        okay &= fclose(manifest) == 0;
    }
    okay &= count == SAMPLE_COUNT;
    for (unsigned group = 0; group < GROUP_COUNT; group += 1)
    {
        okay &= groups[group] == ((group / 12) % 2 == 0 ? 36u : 12u);
    }
    if (okay)
    {
        puts("round\tcondition\tflags\trole\tmetric\tsamples\tmedian\tplacement_min\tplacement_max\tcopy_min\tcopy_max");
        for (unsigned group = 0; group < GROUP_COUNT; group += 1)
        {
            for (unsigned metric = 0; metric < 9; metric += 1)
            {
                double values[36], placements[12], copies[36];
                unsigned n = 0;
                for (unsigned i = 0; i < count; i += 1)
                {
                    const Sample* sample = &samples[i];
                    if ((((sample->round - 1) * 2 + sample->condition) * 4 + sample->flags) * 3 + sample->role == group)
                    {
                        values[n] = sample->values[metric];
                        copies[n++] = sample->values[metric];
                    }
                }
                for (unsigned placement = 0; placement < 12; placement += 1)
                {
                    double same[3];
                    unsigned p = 0;
                    for (unsigned i = 0; i < count; i += 1)
                    {
                        const Sample* sample = &samples[i];
                        if ((((sample->round - 1) * 2 + sample->condition) * 4 + sample->flags) * 3 + sample->role == group && sample->placement == placement)
                        {
                            same[p++] = sample->values[metric];
                        }
                    }
                    placements[placement] = median(same, p);
                }
                const double middle = median(values, n);
                median(placements, 12);
                median(copies, n);
                printf("%u\t%u\t%u\t%u\t%u\t%u\t%.9f\t%.9f\t%.9f\t%.9f\t%.9f\n", group / 24 + 1, (group / 12) % 2, (group / 3) % 4, group % 3, metric, n, middle, placements[0], placements[11], copies[0], copies[n - 1]);
            }
        }
        okay = fflush(stdout) == 0 && !ferror(stdout);
    }
    else
    {
        fprintf(stderr, "encoder campaign rejected: %u of %u observations\n", count, SAMPLE_COUNT);
    }
    return okay ? 0 : 1;
}
