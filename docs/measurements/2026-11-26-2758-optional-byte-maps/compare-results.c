// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original evidence utility for buster #2758. Compare retained test-ssa-source --typed --tier1 runs.
// InterpreterResult is 40 bytes on the measured x86-64 ABI; bytes 28..31 are padding and are ignored.
// Empty records are valid for programs that exit themselves. Their process statuses are checked by the suite.
#define _POSIX_C_SOURCE 200809L
#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define BUSTER_COMPARE_PATH 4096

static bool problem(const char* path, const char* message)
{
    fprintf(stderr, "%s: %s\n", path, message);
    return false;
}

static bool join_path(char* path, const char* root, const char* name)
{
    const int length = snprintf(path, BUSTER_COMPARE_PATH, "%s/%s", root, name);
    const bool valid = length >= 0 && length < BUSTER_COMPARE_PATH;
    return valid || problem(root, "path exceeds the comparison buffer");
}

// Require exactly the expected run-* directories; the caller visits every expected name. Unrelated root entries
// and program-created files inside runs are not comparison inputs. Native programs and compile logs are optional.
static bool inventory(const char* root, uint64_t expected)
{
    DIR* directory = opendir(root);
    bool valid = directory != 0 || problem(root, "cannot open directory");
    uint64_t count = 0;
    while (valid)
    {
        errno = 0;
        const struct dirent* entry = readdir(directory);
        if (entry == 0)
        {
            valid = errno == 0 || problem(root, "cannot read directory");
            break;
        }
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
        {
            continue;
        }
        if (strncmp(entry->d_name, "run-", 4) != 0)
        {
            continue;
        }
        char path[BUSTER_COMPARE_PATH];
        struct stat metadata;
        valid = join_path(path, root, entry->d_name);
        if (valid)
        {
            valid = (lstat(path, &metadata) == 0 && S_ISDIR(metadata.st_mode)) || problem(path, "run entry is not a directory");
        }
        count += 1;
    }
    valid = (directory == 0 || closedir(directory) == 0 || problem(root, "cannot close directory")) && valid;
    if (valid && count != expected)
    {
        valid = problem(root, "missing or extra entries");
    }
    return valid;
}

static FILE* open_regular(const char* path)
{
    struct stat metadata;
    FILE* file = lstat(path, &metadata) == 0 && S_ISREG(metadata.st_mode) ? fopen(path, "rb") : 0;
    return file;
}

static bool compare_output(const char* base, const char* head)
{
    FILE* left = open_regular(base);
    FILE* right = open_regular(head);
    bool valid = (left != 0 && right != 0) || problem(left == 0 ? base : head, "cannot open output");
    while (valid && !feof(left))
    {
        unsigned char a[16384];
        unsigned char b[16384];
        const size_t na = fread(a, 1, sizeof(a), left);
        const size_t nb = fread(b, 1, sizeof(b), right);
        valid = (!ferror(left) && !ferror(right) && na == nb && memcmp(a, b, na) == 0) || problem(head, "output bytes differ or cannot be read");
    }
    valid = (left == 0 || fclose(left) == 0 || problem(base, "cannot close output")) && valid;
    valid = (right == 0 || fclose(right) == 0 || problem(head, "cannot close output")) && valid;
    return valid;
}

typedef struct Record Record;
struct Record
{
    // Named fields in TSV order: status, low, high, function, entry, steps.
    uint64_t fields[6];
    bool empty;
};

static bool read_record(const char* path, Record* record)
{
    FILE* file = open_regular(path);
    bool valid = file != 0;
    if (valid)
    {
        unsigned char bytes[41];
        const size_t count = fread(bytes, 1, sizeof(bytes), file);
        valid = !ferror(file) && (count == 0 || count == 40);
        record->empty = count == 0;
        const uint8_t offsets[] = { 16, 0, 8, 20, 24, 32 };
        const uint8_t widths[] = { 4, 8, 8, 4, 4, 8 };
        for (uint32_t field = 0; valid && !record->empty && field < 6; field += 1)
        {
            uint64_t value = 0;
            for (uint32_t byte = 0; byte < widths[field]; byte += 1)
            {
                value |= (uint64_t)bytes[offsets[field] + byte] << (8 * byte);
            }
            record->fields[field] = value;
        }
        valid = fclose(file) == 0 && valid;
    }
    return valid || problem(path, "record must be readable and exactly 0 or 40 bytes");
}

int main(int argc, char** argv)
{
    char* end = 0;
    errno = 0;
    const uintmax_t expected = argc == 4 ? strtoumax(argv[3], &end, 10) : 0;
    const bool arguments = argc == 4 && end != argv[3] && *end == 0 && errno == 0 && expected != 0 && expected <= UINT32_MAX / 5;
    bool valid = arguments;
    uint64_t outputs = 0;
    uint64_t records = 0;
    uint64_t empty = 0;
    const char* const forms[] = { "memory", "ssa", "typed", "tier1-vector", "tier1-scalar" };
    if (!valid)
    {
        fprintf(stderr, "usage: %s BASE_ROOT HEAD_ROOT PROGRAM_COUNT\n", argv[0]);
    }
    if (valid)
    {
        valid = inventory(argv[1], expected * 5) && inventory(argv[2], expected * 5);
        printf("program\tform\tstatus\tlow\thigh\tfunction\tentry\tsteps\n");
    }
    for (uint32_t program = 0; valid && program < expected; program += 1)
    {
        for (uint32_t form = 0; valid && form < 5; form += 1)
        {
            char name[64];
            char directories[2][BUSTER_COMPARE_PATH];
            char paths[2][BUSTER_COMPARE_PATH];
            const bool interpreted = form < 3;
            snprintf(name, sizeof(name), "run-%" PRIu32 "-%s", program, forms[form]);
            for (uint32_t side = 0; valid && side < 2; side += 1)
            {
                valid = join_path(directories[side], argv[side + 1], name) &&
                        join_path(paths[side], directories[side], interpreted ? "ssa-source.out" : "output");
            }
            valid = valid && compare_output(paths[0], paths[1]);
            outputs += valid;
            if (valid && interpreted)
            {
                Record result[2] = { 0 };
                for (uint32_t side = 0; valid && side < 2; side += 1)
                {
                    valid = join_path(paths[side], directories[side], "ssa-source.record") && read_record(paths[side], &result[side]);
                }
                valid = valid && result[0].empty == result[1].empty;
                for (uint32_t field = 0; valid && !result[0].empty && field < 6; field += 1)
                {
                    valid = result[0].fields[field] == result[1].fields[field];
                }
                if (!valid)
                {
                    problem(name, "interpreter record fields or emptiness differ");
                }
                else if (result[0].empty)
                {
                    printf("%" PRIu32 "\t%s\tempty\t-\t-\t-\t-\t-\n", program, forms[form]);
                }
                else
                {
                    const uint64_t* f = result[0].fields;
                    printf("%" PRIu32 "\t%s\t%" PRIu64 "\t%016" PRIx64 "\t%016" PRIx64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", program, forms[form], f[0], f[1], f[2], f[3], f[4], f[5]);
                }
                records += valid;
                empty += valid && result[0].empty;
            }
        }
    }
    if (valid)
    {
        printf("totals\tprograms\t%" PRIuMAX "\toutputs\t%" PRIu64 "\trecords\t%" PRIu64 "\tempty_records\t%" PRIu64 "\n", expected, outputs, records, empty);
        valid = outputs == expected * 5 && records == expected * 3 && fflush(stdout) == 0 && !ferror(stdout);
    }
    return valid ? 0 : arguments ? 1 : 2;
}
