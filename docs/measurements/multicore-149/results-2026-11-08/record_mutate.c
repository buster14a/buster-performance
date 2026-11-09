// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Mutation helper for explicitly marked copies; never accepts an original campaign directory.
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static char* fixture;
static unsigned rebased;

static void insist(bool valid, const char* message)
{
    if (!valid)
    {
        fprintf(stderr, "fixture helper: %s\n", message);
        exit(1);
    }
}

static char* join(const char* a, const char* b)
{
    char* p = NULL;
    insist(asprintf(&p, "%s/%s", a, b) > 0, "path allocation");
    return p;
}

static char* load(const char* name)
{
    FILE* f = fopen(name, "rb");
    struct stat s;
    insist(f != NULL && fstat(fileno(f), &s) == 0 && S_ISREG(s.st_mode) && s.st_size >= 0 && s.st_size < (16 << 20), "read bounded file");
    char* text = calloc((size_t)s.st_size + 1, 1);
    insist(text != NULL && fread(text, 1, (size_t)s.st_size, f) == (size_t)s.st_size && !ferror(f) && fclose(f) == 0, "read file bytes");
    return text;
}

static void save(const char* name, const char* text)
{
    char* actual = realpath(name, NULL);
    insist(actual != NULL && strncmp(actual, fixture, strlen(fixture)) == 0 && actual[strlen(fixture)] == '/', "target escapes marked copy");
    char* temporary = NULL;
    insist(asprintf(&temporary, "%s.mutation-XXXXXX", actual) > 0, "temporary name");
    int fd = mkstemp(temporary);
    insist(fd >= 0, "create replacement");
    size_t remaining = strlen(text), written = 0;
    while (remaining != 0)
    {
        ssize_t n = write(fd, text + written, remaining);
        if (n < 0 && errno == EINTR) continue;
        insist(n > 0, "write replacement");
        written += (size_t)n; remaining -= (size_t)n;
    }
    insist(close(fd) == 0 && rename(temporary, actual) == 0, "publish copy replacement");
}

static void replace_identity(const char* name, const char* old)
{
    char* text = load(name);
    size_t count = 0, old_size = strlen(old), new_size = strlen(fixture);
    for (const char* p = text; (p = strstr(p, old)) != NULL; p += old_size) count += 1;
    insist(count == 4 && old_size > 0, "identity must contain four frozen-case paths");
    size_t capacity = strlen(text) + count * new_size + 1;
    char* output = calloc(capacity, 1);
    insist(output != NULL, "identity allocation");
    const char* read = text;
    char* write = output;
    const char* found;
    while ((found = strstr(read, old)) != NULL)
    {
        memcpy(write, read, (size_t)(found - read)); write += found - read;
        memcpy(write, fixture, new_size); write += new_size;
        read = found + old_size;
    }
    strcpy(write, read);
    save(name, output);
    rebased += 1;
}

static void rebase(const char* directory, const char* old)
{
    DIR* d = opendir(directory);
    insist(d != NULL, "open marked-copy directory");
    struct dirent* e;
    while ((e = readdir(d)) != NULL)
    {
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
        char* name = join(directory, e->d_name);
        struct stat s;
        insist(lstat(name, &s) == 0 && !S_ISLNK(s.st_mode), "reject symbolic-link fixtures");
        if (S_ISDIR(s.st_mode)) rebase(name, old);
        else if (strcmp(e->d_name, "identity.before.txt") == 0 || strcmp(e->d_name, "identity.after.txt") == 0) replace_identity(name, old);
    }
    insist(closedir(d) == 0, "close marked-copy directory");
}

static void field(const char* name, unsigned row, unsigned column, const char* value, const char* prefix)
{
    char* text = load(name);
    char* begin = text;
    if (prefix != NULL)
    {
        unsigned count = 0;
        for (char* p = text; *p != 0;)
        {
            if (strncmp(p, prefix, strlen(prefix)) == 0) { begin = p; count += 1; }
            char* next = strchr(p, '\n'); insist(next != NULL, "line termination"); p = next + 1;
        }
        insist(count == 1, "prefix row must be unique");
    }
    else for (unsigned i = 0; i < row; i += 1) { begin = strchr(begin, '\n'); insist(begin != NULL, "row exists"); begin += 1; }
    char* end = strchr(begin, '\n');
    insist(end != NULL, "row terminator");
    char* cell = begin;
    for (unsigned i = 0; i < column; i += 1) { cell = strchr(cell, '\t'); insist(cell != NULL && cell < end, "column exists"); cell += 1; }
    char* stop = strchr(cell, '\t');
    if (stop == NULL || stop > end) stop = end;
    char* output = NULL;
    insist(asprintf(&output, "%.*s%s%s", (int)(cell - text), text, value, stop) > 0, "field replacement allocation");
    save(name, output);
}

int main(int argc, char** argv)
{
    insist(argc >= 4, "usage: fixture ROOT rebase OLD | field FILE ROW COLUMN VALUE | prefix-field FILE PREFIX COLUMN VALUE | flip FILE | append FILE TEXT");
    fixture = realpath(argv[1], NULL);
    insist(fixture != NULL, "fixture root exists");
    char* marker = load(join(fixture, "INDEPENDENT-REVIEW-FIXTURE"));
    insist(strcmp(marker, "independent-review-copy\n") == 0, "explicit copy marker required");
    if (strcmp(argv[2], "rebase") == 0)
    {
        insist(argc == 4, "rebase arguments"); rebase(fixture, argv[3]); insist(rebased == 166, "all 166 identity receipts rebased");
        printf("rebased-copy-identities=%u\n", rebased);
    }
    else
    {
        char* name = join(fixture, argv[3]);
        if (strcmp(argv[2], "field") == 0) { insist(argc == 7, "field arguments"); field(name, (unsigned)strtoul(argv[4], NULL, 10), (unsigned)strtoul(argv[5], NULL, 10), argv[6], NULL); }
        else if (strcmp(argv[2], "prefix-field") == 0) { insist(argc == 7, "prefix arguments"); field(name, 0, (unsigned)strtoul(argv[5], NULL, 10), argv[6], argv[4]); }
        else if (strcmp(argv[2], "flip") == 0) { insist(argc == 4, "flip arguments"); char* text = load(name); insist(text[0] != 0, "nonempty hash"); text[0] = text[0] == '0' ? '1' : '0'; save(name, text); }
        else if (strcmp(argv[2], "append") == 0) { insist(argc == 5, "append arguments"); char* output = NULL; insist(asprintf(&output, "%s%s", load(name), argv[4]) > 0, "append allocation"); save(name, output); }
        else insist(false, "unknown mutation");
    }
    return 0;
}
