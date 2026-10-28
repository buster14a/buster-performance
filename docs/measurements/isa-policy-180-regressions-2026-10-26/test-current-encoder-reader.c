// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#define _GNU_SOURCE
#define main receipt_reader_main
#include "read-current-encoder.c"
#undef main
#include <sys/stat.h>
#include <unistd.h>

static bool fixture_copy(const char* source, const char* destination, unsigned mutation)
{
    char text[32768];
    FILE* input = fopen(source, "rb");
    size_t size = input != 0 ? fread(text, 1, sizeof(text) - 1, input) : 0;
    bool okay = input != 0 && size != 0 && size < sizeof(text) - 1 && !ferror(input) && fgetc(input) == EOF;
    if (input != 0)
    {
        fclose(input);
    }
    text[size] = 0;
    if (okay && mutation == 1)
    {
        char* cursor = strchr(text, '\n');
        for (unsigned tab = 0; cursor != 0 && tab < 6; tab += 1)
        {
            cursor = strchr(cursor + 1, '\t');
        }
        okay &= cursor != 0 && cursor[-1] == '0';
        if (cursor != 0)
        {
            cursor[-1] = '1'; // First child's exit status.
        }
    }
    else if (okay && mutation == 2)
    {
        char* cursor = strstr(text, "x86_encode_16");
        cursor = cursor != 0 ? cursor + strlen("x86_encode_16") : 0;
        while (cursor != 0 && *cursor == ' ')
        {
            cursor += 1;
        }
        char* end = cursor != 0 ? strchr(cursor, ' ') : 0;
        okay &= end != 0;
        for (char* c = cursor; end != 0 && c < end; c += 1)
        {
            if (*c >= '0' && *c <= '9')
            {
                *c = '0'; // Zero timing must never enter a summary.
            }
        }
    }
    else if (okay && mutation == 3)
    {
        char* cursor = strstr(text, BUSTER_RECEIPT_FULL_GROUPS ? "65536" : "65537");
        okay &= cursor != 0;
        if (cursor != 0)
        {
            cursor[4] = BUSTER_RECEIPT_FULL_GROUPS ? '5' : '6';
        }
    }
    else if (okay && mutation == 4)
    {
        const char* section = BUSTER_RECEIPT_FULL_GROUPS ? "in calls of 65536" : "in calls of 129";
        char expected[64];
        snprintf(expected, sizeof(expected), "%s;", section);
        char* cursor = strstr(text, expected);
        okay &= cursor != 0;
        if (cursor != 0)
        {
            cursor[strlen(section)] = '0';
        }
    }
    else if (okay && (mutation == 5 || mutation == 6))
    {
        char* cursor = strchr(text, '\n');
        for (unsigned tab = 0; cursor != 0 && tab < 6; tab += 1)
        {
            cursor = strchr(cursor + 1, '\t');
        }
        okay &= cursor != 0;
        if (cursor != 0 && mutation == 5)
        {
            cursor[1] = '-';
        }
        else if (cursor != 0)
        {
            char* first = cursor + 1;
            char* last = strchr(first, '\t');
            const char overflow[] = "18446744073709551616";
            okay &= last != 0 && (size_t)(last - first) <= sizeof(overflow) - 1 && size + sizeof(overflow) < sizeof(text);
            if (okay)
            {
                const size_t delta = sizeof(overflow) - 1 - (size_t)(last - first);
                memmove(last + delta, last, strlen(last) + 1);
                memcpy(first, overflow, sizeof(overflow) - 1);
                size += delta;
            }
        }
    }
    else if (okay && mutation == 7)
    {
        char* cursor = strstr(text, "x86_encode_16");
        cursor = cursor != 0 ? cursor + strlen("x86_encode_16") : 0;
        while (cursor != 0 && *cursor == ' ')
        {
            cursor += 1;
        }
        char* end = cursor != 0 ? strchr(cursor, ' ') : 0;
        okay &= end != 0 && end - cursor >= 3;
        if (okay)
        {
            memset(cursor, ' ', (size_t)(end - cursor));
            memcpy(cursor, "nan", 3);
        }
    }
    else if (okay && (mutation == 8 || mutation == 9))
    {
        char* cursor = strchr(text, '\n');
        okay &= cursor != 0 && cursor[1] == '1';
        while (okay && cursor != 0 && cursor[1] != 0)
        {
            okay &= cursor[1] == '1';
            cursor[1] = '3';
            cursor = mutation == 9 ? strchr(cursor + 1, '\n') : 0;
        }
    }
    else if (okay && mutation == 10)
    {
        char* cursor = strstr(text, "x86_encode_16");
        cursor = cursor != 0 ? strchr(cursor, '\n') : 0;
        okay &= cursor != 0 && size + 8 < sizeof(text);
        if (okay)
        {
            memmove(cursor + 8, cursor, strlen(cursor) + 1);
            memcpy(cursor, "\0ignored", 8);
            size += 8;
        }
    }
    FILE* output = okay ? fopen(destination, "wb") : 0;
    okay &= output != 0 && fwrite(text, 1, size, output) == size;
    if (output != 0)
    {
        okay &= fclose(output) == 0;
    }
    return okay;
}

int main(int argc, char** argv)
{
    bool okay = argc == 2 || argc == 3;
    char temporary[] = "/tmp/buster421-reader-XXXXXX";
    char* root = okay ? mkdtemp(temporary) : 0;
    okay &= root != 0;
    const char* batch = argc == 3 ? argv[2] : "current-encoder-r1-plain-f0-b00";
    char directory[1024], source[2048], destination[2048];
    if (okay)
    {
        snprintf(directory, sizeof(directory), "%s/%s", root, batch);
        okay &= mkdir(directory, 0700) == 0;
    }
    const char* names[] = {"exit.txt", "processes.tsv", "1-main-p00-c0-0.out"};
    for (unsigned i = 0; okay && i < 3; i += 1)
    {
        snprintf(source, sizeof(source), "%s/%s/%s", argv[1], batch, names[i]);
        snprintf(destination, sizeof(destination), "%s/%s", directory, names[i]);
        okay &= fixture_copy(source, destination, 0);
    }
    const char* empty[] = {"harness.err", "1-main-p00-c0-0.err"};
    for (unsigned i = 0; okay && i < 2; i += 1)
    {
        snprintf(destination, sizeof(destination), "%s/%s", directory, empty[i]);
        FILE* file = fopen(destination, "wb");
        okay &= file != 0 && fclose(file) == 0;
    }
    unsigned checks = 0;
    Sample sample = {.round = 1};
    if (okay)
    {
        okay &= complete_batch(argv[1], batch, BUSTER_RECEIPT_PLAIN_BATCH_SIZE) && !complete_batch(root, batch, BUSTER_RECEIPT_PLAIN_BATCH_SIZE);
        checks += 1;
        okay &= !complete_batch(argv[1], batch, BUSTER_RECEIPT_PLAIN_BATCH_SIZE + 1);
        checks += 1;
        okay &= !empty_file(root);
        checks += 1;
        okay &= read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
        sample.flags = 1;
        okay &= !read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
        sample.flags = 0;
        for (unsigned mutation = 1; mutation <= 8; mutation += 1)
        {
            const char* name = mutation == 1 || mutation == 5 || mutation == 6 || mutation == 8 ? "processes.tsv" : "1-main-p00-c0-0.out";
            snprintf(source, sizeof(source), "%s/%s/%s", argv[1], batch, name);
            snprintf(destination, sizeof(destination), "%s/%s", directory, name);
            okay &= fixture_copy(source, destination, mutation) && !read_sample(root, batch, 0, "main-p00-c0", &sample);
            checks += 1;
            okay &= fixture_copy(source, destination, 0);
        }
        snprintf(source, sizeof(source), "%s/%s/1-main-p00-c0-0.out", argv[1], batch);
        snprintf(destination, sizeof(destination), "%s/1-main-p00-c0-0.out", directory);
        okay &= fixture_copy(source, destination, 10) && !read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
        okay &= fixture_copy(source, destination, 0);
        // --first 3 numbers both captures and TSV rows as round 3. These are
        // temporary parser fixtures, never measured campaign receipts.
        snprintf(source, sizeof(source), "%s/%s/1-main-p00-c0-0.out", argv[1], batch);
        snprintf(destination, sizeof(destination), "%s/3-main-p00-c0-0.out", directory);
        okay &= fixture_copy(source, destination, 0);
        snprintf(destination, sizeof(destination), "%s/3-main-p00-c0-0.err", directory);
        FILE* third_error = fopen(destination, "wb");
        okay &= third_error != 0 && fclose(third_error) == 0;
        snprintf(source, sizeof(source), "%s/%s/processes.tsv", argv[1], batch);
        snprintf(destination, sizeof(destination), "%s/processes.tsv", directory);
        okay &= fixture_copy(source, destination, 9);
        sample.round = 3;
        okay &= read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
        okay &= fixture_copy(source, destination, 0) && !read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
        sample.round = 1;
        const char* numbers[] = {"0", "18446744073709551615", "18446744073709551616", "-1", "+1", " 1", "1x", ""};
        for (unsigned i = 0; i < sizeof(numbers) / sizeof(numbers[0]); i += 1)
        {
            uint64_t value = 0;
            okay &= unsigned_number(numbers[i], &value) == (i < 2);
            okay &= i != 0 || value == 0;
            okay &= i != 1 || value == UINT64_MAX;
            checks += 1;
        }
        double even[] = {4, 1, 3, 2};
        double odd[] = {3, 1, 2};
        okay &= median(even, 4) == 3 && median(odd, 3) == 2;
        checks += 1;
        snprintf(destination, sizeof(destination), "%s/1-main-p00-c0-0.out", directory);
        okay &= unlink(destination) == 0 && !read_sample(root, batch, 0, "main-p00-c0", &sample);
        checks += 1;
    }
    if (root != 0)
    {
        for (unsigned i = 0; i < 3; i += 1)
        {
            snprintf(destination, sizeof(destination), "%s/%s", directory, names[i]);
            unlink(destination);
        }
        for (unsigned i = 0; i < 2; i += 1)
        {
            snprintf(destination, sizeof(destination), "%s/%s", directory, empty[i]);
            unlink(destination);
        }
        snprintf(destination, sizeof(destination), "%s/3-main-p00-c0-0.out", directory);
        unlink(destination);
        snprintf(destination, sizeof(destination), "%s/3-main-p00-c0-0.err", directory);
        unlink(destination);
        rmdir(directory);
        rmdir(root);
    }
    printf("receipt reader: %s (%u checks)\n", okay ? "pass" : "FAIL", checks);
    return okay ? 0 : 1;
}
