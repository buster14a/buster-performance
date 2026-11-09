// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
//
// Prepare #149's three compile-only cases without running the compiler. The frozen corpus's
// pinned manifests are checked by sha256sum, executed directly with argv; its inventories must
// match the manifests exactly. The synthetic directory must contain the generator's 512 units
// of 200 named function definitions, with no extra files. Shape checks do not certify the seed:
// the campaign must retain the same compiler's generation command and successful exit.
//
// Layout: bounded containers and paths; hashing/inventories; musl replacement selection and
// synth shape; case manifests and publication; isolated original fixtures for --self-test.
// This cold file-preparation tool performs no timed compiler work or shared-host coordination.

#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUSTER_PREPARE_MAX_FILES 65536u
#define BUSTER_PREPARE_SYNTH_UNITS 512u
#define BUSTER_PREPARE_SYNTH_FUNCTIONS 200u
#define BUSTER_PREPARE_MUSL_UNITS 1309u
#define BUSTER_PREPARE_HASH_BATCH 64u
#define BUSTER_PREPARE_MAX_SOURCE_BYTES (4u * 1024u * 1024u)

typedef struct Strings Strings;
struct Strings
{
    char** items;
    size_t count;
    size_t capacity;
};

typedef struct Digest Digest;
struct Digest
{
    char* path;
    char hash[65];
};

typedef struct Digests Digests;
struct Digests
{
    Digest* items;
    size_t count;
    size_t capacity;
};

typedef struct Pin Pin;
struct Pin
{
    const char* path;
    const char* hash;
};

static const Pin corpus_pins[] = {
    {
        .path = "MANIFESTS.sha256",
        .hash = "391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd",
    },
    {
        .path = "manifests/headers.sha256",
        .hash = "8e6e646951cbd08c07bbc76ff46d6796a83a58e9b1c4959278b60193718cd10c",
    },
    {
        .path = "manifests/headers-bundle.sha256",
        .hash = "e307b836448ef20e603a617a4b5023831c72ff5f307f614c50f4f8833088717c",
    },
    {
        .path = "manifests/sqlite.sha256",
        .hash = "9179b7ad7db7366d12a214b562e478ac703e7ec0376f38f4516756bcf7ee0047",
    },
    {
        .path = "manifests/libc.sha256",
        .hash = "bf593a94954f3ed9431dd12e60233ec0229f7226a1fc270a701614a20f86baeb",
    },
    {
        .path = "manifests/musl-generated.sha256",
        .hash = "89dbe35f0324cf08d0cb9cf31ecf15092fc20783a9e470e80e5f41b1d48251d3",
    },
    {
        .path = "sqlite/sqlite3.c",
        .hash = "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d",
    },
    {
        .path = "provenance/gnu17-pinned-predefines.txt",
        .hash = "a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33",
    },
};

typedef struct Corpus Corpus;
struct Corpus
{
    char root[PATH_MAX];
    Digests pins;
    Digests headers;
    Digests sqlite;
    Digests libc;
    Digests generated;
};

typedef struct MuslSelection MuslSelection;
struct MuslSelection
{
    Strings sources;
    Strings exclusions;
    size_t generic_count;
    size_t replacement_count;
    size_t architecture_c_count;
};

typedef struct PreparedCase PreparedCase;
struct PreparedCase
{
    const char* name;
    Strings arguments;
    Strings outputs;
    Strings provenance;
    Digests dependencies;
};

static char preparation_error[PATH_MAX + 256];

static bool fail(const char* format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    vsnprintf(preparation_error, sizeof(preparation_error), format, arguments);
    va_end(arguments);
    return false;
}

static bool safe_text(const char* text)
{
    bool valid = text != NULL && text[0] != 0;
    for (size_t i = 0; valid && text[i] != 0; i += 1)
    {
        const unsigned char byte = (unsigned char)text[i];
        valid = byte >= 32 && byte != 127 && byte != '\\';
    }
    return valid;
}

static bool relative_path(const char* path)
{
    bool valid = safe_text(path) && path[0] != '/';
    const char* component = path;
    while (valid && *component != 0)
    {
        const char* slash = strchr(component, '/');
        const size_t length = slash != NULL ? (size_t)(slash - component) : strlen(component);
        valid = length != 0 && !(length == 1 && component[0] == '.') && !(length == 2 && component[0] == '.' && component[1] == '.');
        if (slash != NULL)
        {
            valid = valid && slash[1] != 0;
        }
        component += length + (slash != NULL ? 1u : 0u);
    }
    return valid;
}

static bool path_join(char* output, const char* root, const char* path)
{
    const int length = snprintf(output, PATH_MAX, "%s/%s", root, path);
    const bool valid = length > 0 && length < PATH_MAX && safe_text(output);
    return valid || fail("path is too long or contains an unsupported control/backslash: %s / %s", root, path);
}

static bool directory_path(const char* input, char* resolved)
{
    struct stat info;
    bool valid = input != NULL && input[0] == '/' && safe_text(input);
    valid = valid && realpath(input, resolved) != NULL && safe_text(resolved);
    valid = valid && lstat(resolved, &info) == 0 && S_ISDIR(info.st_mode);
    return valid || fail("expected an existing absolute directory: %s", input != NULL ? input : "(missing)");
}

static bool regular_file(const char* path, bool nonempty)
{
    struct stat info;
    const bool valid = lstat(path, &info) == 0 && S_ISREG(info.st_mode) && (!nonempty || info.st_size > 0);
    return valid || fail("expected a%s regular file: %s", nonempty ? " nonempty" : "", path);
}

static bool strings_add(Strings* list, const char* value)
{
    bool valid = list->count < BUSTER_PREPARE_MAX_FILES && safe_text(value);
    if (valid && list->count == list->capacity)
    {
        const size_t capacity = list->capacity == 0 ? 32 : list->capacity * 2;
        char** items = realloc(list->items, capacity * sizeof(*items));
        valid = items != NULL;
        if (valid)
        {
            list->items = items;
            list->capacity = capacity;
        }
    }
    if (valid)
    {
        char* copy = strdup(value);
        valid = copy != NULL;
        if (valid)
        {
            list->items[list->count++] = copy;
        }
    }
    return valid || fail("could not retain a bounded text entry");
}

static bool strings_format(Strings* list, const char* format, ...)
{
    char buffer[PATH_MAX * 2 + 512];
    va_list arguments;
    va_start(arguments, format);
    const int length = vsnprintf(buffer, sizeof(buffer), format, arguments);
    va_end(arguments);
    const bool valid = length > 0 && (size_t)length < sizeof(buffer) && strings_add(list, buffer);
    return valid || fail("could not format a bounded text entry");
}

static void strings_free(Strings* list)
{
    const size_t count = list->count;
    for (size_t i = 0; i < count; i += 1)
    {
        free(list->items[i]);
    }
    free(list->items);
    *list = (Strings){ 0 };
}

static int compare_strings(const void* left, const void* right)
{
    return strcmp(*(const char* const*)left, *(const char* const*)right);
}

static void strings_sort(Strings* list)
{
    if (list->count > 1)
    {
        qsort(list->items, list->count, sizeof(*list->items), compare_strings);
    }
}

static bool strings_contains(const Strings* list, const char* key)
{
    size_t low = 0;
    size_t high = list->count;
    while (low < high)
    {
        const size_t middle = low + (high - low) / 2;
        const int order = strcmp(list->items[middle], key);
        if (order < 0)
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    return low < list->count && strcmp(list->items[low], key) == 0;
}

static bool digests_add(Digests* list, const char* path, const char* hash)
{
    bool valid = list->count < BUSTER_PREPARE_MAX_FILES && safe_text(path) && strlen(hash) == 64;
    if (valid && list->count == list->capacity)
    {
        const size_t capacity = list->capacity == 0 ? 32 : list->capacity * 2;
        Digest* items = realloc(list->items, capacity * sizeof(*items));
        valid = items != NULL;
        if (valid)
        {
            list->items = items;
            list->capacity = capacity;
        }
    }
    if (valid)
    {
        char* copy = strdup(path);
        valid = copy != NULL;
        if (valid)
        {
            Digest* entry = &list->items[list->count++];
            entry->path = copy;
            memcpy(entry->hash, hash, 65);
        }
    }
    return valid || fail("could not retain a bounded digest entry");
}

static void digests_free(Digests* list)
{
    const size_t count = list->count;
    for (size_t i = 0; i < count; i += 1)
    {
        free(list->items[i].path);
    }
    free(list->items);
    *list = (Digests){ 0 };
}

static int compare_digests(const void* left, const void* right)
{
    return strcmp(((const Digest*)left)->path, ((const Digest*)right)->path);
}

static bool digests_sort(Digests* list, bool allow_identical)
{
    if (list->count > 1)
    {
        qsort(list->items, list->count, sizeof(*list->items), compare_digests);
    }
    bool valid = true;
    size_t written = 0;
    const size_t count = list->count;
    for (size_t i = 0; i < count; i += 1)
    {
        if (written != 0 && strcmp(list->items[written - 1].path, list->items[i].path) == 0)
        {
            valid = (allow_identical && strcmp(list->items[written - 1].hash, list->items[i].hash) == 0) && valid;
            free(list->items[i].path);
            list->items[i].path = NULL;
        }
        else
        {
            if (written != i)
            {
                list->items[written] = list->items[i];
                list->items[i].path = NULL;
            }
            written += 1;
        }
    }
    list->count = written;
    return valid || fail("duplicate or contradictory paths in a digest inventory");
}

static bool digests_copy(Digests* destination, const Digests* source, const char* prefix)
{
    bool valid = true;
    const size_t count = source->count;
    const size_t prefix_length = prefix != NULL ? strlen(prefix) : 0;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        const Digest* item = &source->items[i];
        if (prefix == NULL || (strncmp(item->path, prefix, prefix_length) == 0 && item->path[prefix_length] == '/'))
        {
            valid = digests_add(destination, item->path, item->hash);
        }
    }
    return valid;
}

// No shell interprets a path, even one containing spaces, quotes or dollar signs. The parent
// owns the optional descriptors and waits for this particular child's successful exit.
static bool run_sha256(const char* directory, char* const* arguments, int input, int output)
{
    const pid_t child = fork();
    if (child == 0)
    {
        const int in = input >= 0 ? input : open("/dev/null", O_RDONLY);
        const int out = output >= 0 ? output : open("/dev/null", O_WRONLY);
        bool ready = in >= 0 && out >= 0 && (directory == NULL || chdir(directory) == 0);
        ready = ready && dup2(in, STDIN_FILENO) >= 0 && dup2(out, STDOUT_FILENO) >= 0;
        if (in > STDERR_FILENO)
        {
            close(in);
        }
        if (out > STDERR_FILENO && out != in)
        {
            close(out);
        }
        if (ready)
        {
            execvp(arguments[0], arguments);
        }
        _exit(127);
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
    const bool valid = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    return valid || fail("sha256sum did not exit successfully for %s", directory != NULL ? directory : "absolute input paths");
}

static bool verify_pins(const char* root, Digests* identities)
{
    FILE* input = tmpfile();
    bool valid = input != NULL;
    const size_t count = sizeof(corpus_pins) / sizeof(corpus_pins[0]);
    for (size_t i = 0; valid && i < count; i += 1)
    {
        char path[PATH_MAX];
        valid = path_join(path, root, corpus_pins[i].path) && regular_file(path, true);
        valid = valid && fprintf(input, "%s  %s\n", corpus_pins[i].hash, corpus_pins[i].path) > 0;
        if (valid && identities != NULL)
        {
            valid = digests_add(identities, path, corpus_pins[i].hash);
        }
    }
    if (valid)
    {
        valid = fflush(input) == 0 && fseek(input, 0, SEEK_SET) == 0;
        char* arguments[] = { "sha256sum", "--strict", "--check", "--status", NULL };
        valid = valid && run_sha256(root, arguments, fileno(input), -1);
    }
    if (input != NULL)
    {
        valid = fclose(input) == 0 && valid;
    }
    return valid || fail("frozen-corpus pin verification failed");
}

// Names are collected without following links; the explicit directory list avoids recursive
// traversal. An extra file, link, device or FIFO is not a frozen-corpus input.
static bool inventory_tree(const char* root, Strings* files, bool flat)
{
    Strings directories = { 0 };
    bool valid = strings_add(&directories, root);
    for (size_t index = 0; valid && index < directories.count; index += 1)
    {
        const char* directory = directories.items[index];
        DIR* stream = opendir(directory);
        valid = stream != NULL;
        bool finished = false;
        while (valid && !finished)
        {
            errno = 0;
            const struct dirent* entry = readdir(stream);
            if (entry == NULL)
            {
                valid = errno == 0;
                finished = true;
            }
            else if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
            {
                char path[PATH_MAX];
                struct stat info;
                valid = path_join(path, directory, entry->d_name) && lstat(path, &info) == 0;
                if (valid && S_ISDIR(info.st_mode) && !flat)
                {
                    valid = strings_add(&directories, path);
                }
                else if (valid && S_ISREG(info.st_mode))
                {
                    valid = strings_add(files, path);
                }
                else if (valid)
                {
                    valid = fail("unexpected directory or non-regular input: %s", path);
                }
            }
        }
        if (stream != NULL)
        {
            valid = closedir(stream) == 0 && valid;
        }
    }
    strings_free(&directories);
    strings_sort(files);
    return valid || fail("could not inventory regular files under %s", root);
}

static bool read_digests(FILE* file, const char* root, Digests* result)
{
    char* line = NULL;
    size_t capacity = 0;
    bool valid = true;
    ssize_t length = 0;
    while (valid && (length = getline(&line, &capacity, file)) >= 0)
    {
        valid = length >= 68 && length < PATH_MAX + 70 && line[length - 1] == '\n' && strlen(line) == (size_t)length;
        valid = valid && line[64] == ' ' && (line[65] == ' ' || line[65] == '*');
        char hash[65] = { 0 };
        for (size_t i = 0; valid && i < 64; i += 1)
        {
            const char value = line[i];
            valid = (value >= '0' && value <= '9') || (value >= 'a' && value <= 'f');
            hash[i] = value;
        }
        if (valid)
        {
            line[length - 1] = 0;
            const char* name = line + 66;
            if (root != NULL && strncmp(name, "./", 2) == 0)
            {
                name += 2;
            }
            char path[PATH_MAX];
            valid = root != NULL ? relative_path(name) && path_join(path, root, name) : name[0] == '/' && safe_text(name) && strlen(name) < PATH_MAX;
            if (valid)
            {
                valid = digests_add(result, root != NULL ? path : name, hash);
            }
        }
    }
    valid = !ferror(file) && valid && result->count != 0;
    free(line);
    valid = digests_sort(result, false) && valid;
    return valid || fail("malformed, empty, escaping or duplicate hash manifest");
}

static bool verify_group(const char* root, const char* directory_name, const char* manifest_name, Digests* records)
{
    char directory[PATH_MAX];
    char manifest[PATH_MAX];
    bool valid = path_join(directory, root, directory_name) && path_join(manifest, root, manifest_name);
    FILE* input = valid ? fopen(manifest, "r") : NULL;
    valid = valid && input != NULL;
    if (input != NULL)
    {
        valid = read_digests(input, directory, records) && valid;
        valid = fclose(input) == 0 && valid;
    }
    Strings files = { 0 };
    valid = valid && inventory_tree(directory, &files, false);
    valid = valid && files.count == records->count;
    const size_t count = files.count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        valid = strcmp(files.items[i], records->items[i].path) == 0;
    }
    if (valid)
    {
        char* arguments[] = { "sha256sum", "--strict", "--check", "--status", manifest, NULL };
        valid = run_sha256(directory, arguments, -1, -1);
    }
    strings_free(&files);
    return valid || fail("corpus hashes or exact inventory failed: %s", directory_name);
}

static bool corpus_read(const char* input, Corpus* corpus)
{
    bool valid = directory_path(input, corpus->root) && verify_pins(corpus->root, &corpus->pins);
    Digests header_subset = { 0 };
    valid = valid && verify_group(corpus->root, "headers/usr", "manifests/headers.sha256", &header_subset);
    valid = valid && verify_group(corpus->root, "headers", "manifests/headers-bundle.sha256", &corpus->headers);
    valid = valid && verify_group(corpus->root, "sqlite", "manifests/sqlite.sha256", &corpus->sqlite);
    valid = valid && verify_group(corpus->root, "libc", "manifests/libc.sha256", &corpus->libc);
    valid = valid && verify_group(corpus->root, "musl-generated", "manifests/musl-generated.sha256", &corpus->generated);
    digests_free(&header_subset);
    return valid;
}

static void corpus_free(Corpus* corpus)
{
    digests_free(&corpus->pins);
    digests_free(&corpus->headers);
    digests_free(&corpus->sqlite);
    digests_free(&corpus->libc);
    digests_free(&corpus->generated);
}

// Hash in bounded batches, directly into an anonymous file. All input paths are absolute, and
// "--" separates them from options. The output parser preserves literal spaces in each path.
static bool hash_files(const Strings* files, Digests* hashes)
{
    FILE* output = tmpfile();
    bool valid = output != NULL && files->count != 0;
    const size_t count = files->count;
    for (size_t first = 0; valid && first < count; first += BUSTER_PREPARE_HASH_BATCH)
    {
        char* arguments[BUSTER_PREPARE_HASH_BATCH + 3];
        arguments[0] = "sha256sum";
        arguments[1] = "--";
        const size_t remaining = count - first;
        const size_t batch = remaining < BUSTER_PREPARE_HASH_BATCH ? remaining : BUSTER_PREPARE_HASH_BATCH;
        for (size_t i = 0; i < batch; i += 1)
        {
            arguments[i + 2] = files->items[first + i];
        }
        arguments[batch + 2] = NULL;
        valid = run_sha256(NULL, arguments, -1, fileno(output));
    }
    if (valid)
    {
        valid = fseek(output, 0, SEEK_SET) == 0 && read_digests(output, NULL, hashes);
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    return valid || fail("could not hash the complete input inventory");
}

static bool suffix(const char* value, const char* ending)
{
    const size_t length = strlen(value);
    const size_t ending_length = strlen(ending);
    return length >= ending_length && memcmp(value + length - ending_length, ending, ending_length) == 0;
}

static bool select_musl(const char* root, const Strings* files, MuslSelection* selection)
{
    Strings generic = { 0 };
    Strings architecture = { 0 };
    Strings replaced = { 0 };
    char source_root[PATH_MAX];
    bool valid = path_join(source_root, root, "src");
    const size_t prefix = valid ? strlen(source_root) : 0;
    const size_t count = files->count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        const char* file = files->items[i];
        if (strncmp(file, source_root, prefix) == 0 && file[prefix] == '/')
        {
            const char* relative = file + prefix + 1;
            const char* category = strchr(relative, '/');
            if (category != NULL && category != relative)
            {
                const char* rest = category + 1;
                if (strchr(rest, '/') == NULL && suffix(rest, ".c"))
                {
                    valid = strings_add(&generic, file);
                }
                else if (strncmp(rest, "x86_64/", 7) == 0 && strchr(rest + 7, '/') == NULL &&
                         (suffix(rest, ".c") || suffix(rest, ".s") || suffix(rest, ".S")))
                {
                    char counterpart[PATH_MAX];
                    const size_t category_length = (size_t)(category - relative);
                    const size_t name_length = strlen(rest + 7);
                    const int written = snprintf(counterpart, sizeof(counterpart), "%s/%.*s/%.*s.c", source_root, (int)category_length, relative,
                                                 (int)(name_length - 2), rest + 7);
                    valid = written > 0 && (size_t)written < sizeof(counterpart);
                    valid = valid && strings_add(&replaced, counterpart) && strings_add(&architecture, file);
                }
            }
        }
    }
    strings_sort(&generic);
    strings_sort(&architecture);
    strings_sort(&replaced);
    const size_t replacement_count = replaced.count;
    for (size_t i = 1; valid && i < replacement_count; i += 1)
    {
        valid = strcmp(replaced.items[i - 1], replaced.items[i]) != 0 || fail("ambiguous x86_64 musl replacements for %s", replaced.items[i]);
    }
    selection->generic_count = generic.count;
    selection->replacement_count = replacement_count;
    const size_t generic_count = generic.count;
    for (size_t i = 0; valid && i < generic_count; i += 1)
    {
        if (strings_contains(&replaced, generic.items[i]))
        {
            valid = strings_format(&selection->exclusions, "excluded-generic-architecture-replacement=%s", generic.items[i]);
        }
        else
        {
            valid = strings_add(&selection->sources, generic.items[i]);
        }
    }
    const size_t architecture_count = architecture.count;
    for (size_t i = 0; valid && i < architecture_count; i += 1)
    {
        if (suffix(architecture.items[i], ".c"))
        {
            selection->architecture_c_count += 1;
            valid = strings_add(&selection->sources, architecture.items[i]);
        }
        else
        {
            valid = strings_format(&selection->exclusions, "assembly-replacement-outside-C-only-cohort=%s", architecture.items[i]);
        }
    }
    strings_sort(&selection->sources);
    strings_sort(&selection->exclusions);
    strings_free(&generic);
    strings_free(&architecture);
    strings_free(&replaced);
    return valid;
}

static void selection_free(MuslSelection* selection)
{
    strings_free(&selection->sources);
    strings_free(&selection->exclusions);
}

static bool decimal(const char** cursor, size_t maximum, size_t* value)
{
    const char* at = *cursor;
    bool valid = *at >= '0' && *at <= '9';
    size_t result = 0;
    while (valid && *at >= '0' && *at <= '9')
    {
        const size_t digit = (size_t)(*at - '0');
        valid = result <= maximum / 10 && (result < maximum / 10 || digit <= maximum % 10);
        if (valid)
        {
            result = result * 10 + digit;
            at += 1;
        }
    }
    *cursor = at;
    *value = result;
    return valid;
}

static bool synth_shape(const char* path, size_t unit, size_t functions)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL && functions != 0 && functions <= BUSTER_PREPARE_SYNTH_FUNCTIONS;
    bool seen[BUSTER_PREPARE_SYNTH_FUNCTIONS] = { false };
    size_t definitions = 0;
    size_t tables = 0;
    size_t bytes = 0;
    bool stdio = false;
    char table[128];
    const int table_length = snprintf(table, sizeof(table), "unsigned (*const table_%zu[%zu])(unsigned, unsigned) = {", unit, functions);
    valid = valid && table_length > 0 && (size_t)table_length < sizeof(table);
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length = 0;
    while (valid && (length = getline(&line, &capacity, file)) >= 0)
    {
        valid = length > 0 && bytes <= BUSTER_PREPARE_MAX_SOURCE_BYTES && (size_t)length <= BUSTER_PREPARE_MAX_SOURCE_BYTES - bytes;
        valid = valid && strlen(line) == (size_t)length;
        if (valid)
        {
            bytes += (size_t)length;
            stdio = stdio || strcmp(line, "#include <stdio.h>\n") == 0;
            tables += strncmp(line, table, (size_t)table_length) == 0;
            if (strncmp(line, "unsigned function_", 18) == 0 && suffix(line, "(unsigned depth, unsigned x)\n"))
            {
                const char* cursor = line + 18;
                size_t declared_unit = 0;
                size_t function = 0;
                valid = decimal(&cursor, BUSTER_PREPARE_SYNTH_UNITS - 1, &declared_unit) && *cursor == '_';
                if (valid)
                {
                    cursor += 1;
                    valid = decimal(&cursor, functions - 1, &function) && strcmp(cursor, "(unsigned depth, unsigned x)\n") == 0;
                }
                valid = valid && declared_unit == unit && !seen[function];
                if (valid)
                {
                    seen[function] = true;
                    definitions += 1;
                    length = getline(&line, &capacity, file);
                    valid = length == 2 && line[0] == '{' && line[1] == '\n' && bytes <= BUSTER_PREPARE_MAX_SOURCE_BYTES - 2;
                    bytes += valid ? 2u : 0u;
                }
            }
        }
    }
    if (file != NULL)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    free(line);
    valid = valid && stdio && definitions == functions && tables == 1;
    return valid || fail("synthetic unit does not have the expected %zu named definitions and table: %s", functions, path);
}

static bool synth_inventory(const char* root, size_t count, size_t functions, Strings* sources)
{
    Strings inventory = { 0 };
    Strings expected = { 0 };
    bool valid = inventory_tree(root, &inventory, true) && inventory.count == count;
    for (size_t unit = 0; valid && unit < count; unit += 1)
    {
        char name[64];
        char path[PATH_MAX];
        snprintf(name, sizeof(name), "unit_%zu.c", unit);
        valid = path_join(path, root, name) && strings_contains(&inventory, path) && regular_file(path, true);
        valid = valid && synth_shape(path, unit, functions) && strings_add(&expected, path);
    }
    if (valid)
    {
        *sources = expected;
        expected = (Strings){ 0 };
    }
    strings_free(&expected);
    strings_free(&inventory);
    return valid || fail("synth must contain exactly unit_0.c through unit_%zu.c, with no extra entries", count - 1);
}

static bool source_outputs(const Strings* sources, Strings* outputs)
{
    bool valid = sources->count != 0;
    Strings sorted = { 0 };
    const size_t count = sources->count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        const char* slash = strrchr(sources->items[i], '/');
        const char* name = slash != NULL ? slash + 1 : sources->items[i];
        const size_t length = strlen(name);
        valid = length > 2 && length < NAME_MAX && suffix(name, ".c") && strstr(name, "..") == NULL;
        for (size_t c = 0; valid && c < length; c += 1)
        {
            const unsigned char byte = (unsigned char)name[c];
            const bool simple = (byte >= 'a' && byte <= 'z') || (byte >= 'A' && byte <= 'Z') || (byte >= '0' && byte <= '9') || byte == '_';
            valid = simple || (c != 0 && (byte == '.' || byte == '-'));
        }
        if (valid)
        {
            char output[NAME_MAX + 1];
            memcpy(output, name, length + 1);
            output[length - 1] = 'o';
            valid = strings_add(outputs, output) && strings_add(&sorted, output);
        }
    }
    strings_sort(&sorted);
    for (size_t i = 1; valid && i < sorted.count; i += 1)
    {
        valid = strcmp(sorted.items[i - 1], sorted.items[i]) != 0 || fail("two sources would write %s", sorted.items[i]);
    }
    strings_free(&sorted);
    return valid || fail("source inventory has invalid or duplicate object basenames");
}

static bool argument_path(Strings* arguments, const char* option, const char* root, const char* relative)
{
    char path[PATH_MAX];
    return path_join(path, root, relative) && strings_add(arguments, option) && strings_add(arguments, path);
}

static bool common_arguments(Strings* arguments, const Corpus* corpus, bool musl)
{
    // These arguments go to Buster, not Clang: its driver rejects Clang's --no-default-config.
    static const char* const common[] = { "-c", "--target=x86_64-linux-gnu", "-march=znver5", "-nostdinc" };
    bool valid = true;
    for (size_t i = 0; valid && i < sizeof(common) / sizeof(common[0]); i += 1)
    {
        valid = strings_add(arguments, common[i]);
    }
    valid = valid && strings_add(arguments, musl ? "-std=c99" : "-std=gnu17");
    if (musl)
    {
        static const char* const includes[] = {
            "libc/musl/arch/x86_64",
            "libc/musl/arch/generic",
            "musl-generated/obj/src/internal",
            "libc/musl/src/include",
            "libc/musl/src/internal",
            "musl-generated/obj/include",
            "libc/musl/include",
        };
        valid = valid && strings_add(arguments, "-ffreestanding") && strings_add(arguments, "-D_XOPEN_SOURCE=700");
        for (size_t i = 0; valid && i < sizeof(includes) / sizeof(includes[0]); i += 1)
        {
            valid = argument_path(arguments, "-I", corpus->root, includes[i]);
        }
    }
    else
    {
        valid = valid && argument_path(arguments, "--predefines", corpus->root, "provenance/gnu17-pinned-predefines.txt");
        static const char* const includes[] = {
            "headers/usr/lib/clang/23/include",
            "headers/usr/local/include",
            "headers/usr/include",
        };
        for (size_t i = 0; valid && i < sizeof(includes) / sizeof(includes[0]); i += 1)
        {
            valid = argument_path(arguments, "-isystem", corpus->root, includes[i]);
        }
    }
    return valid;
}

static bool case_base(PreparedCase* item, const char* name, const Corpus* corpus, const Strings* sources, bool musl)
{
    item->name = name;
    bool valid = common_arguments(&item->arguments, corpus, musl) && source_outputs(sources, &item->outputs);
    valid = valid && digests_copy(&item->dependencies, &corpus->pins, NULL);
    valid = valid && strings_add(&item->provenance, "schema=buster-multicore-149-case-v1");
    valid = valid && strings_format(&item->provenance, "case=%s", name);
    valid = valid && strings_add(&item->provenance, "scope=compile-only (-c); all listed objects, no archive, executable or link timing");
    valid = valid && strings_add(&item->provenance, "target=x86_64-linux-gnu; generated-code-isa=znver5; host-build-identity=campaign receipt");
    valid = valid && strings_format(&item->provenance, "corpus-root=%s", corpus->root);
    valid = valid && strings_add(&item->provenance, "corpus=preprocessor-391e729af658; archive-sha256=ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2");
    valid = valid && strings_format(&item->provenance, "source-count=%zu", sources->count);
    valid = valid && strings_add(&item->provenance, "corpus-verification=pinned manifests and SQLite/predefines; full headers/libc/sqlite/musl-generated SHA-256 and exact regular-file inventories");
    valid = valid && strings_add(&item->provenance, "header-scope=explicit frozen directories; -nostdinc; caller must clear CPATH/C_INCLUDE_PATH/CPLUS_INCLUDE_PATH");
    valid = valid && strings_add(&item->provenance, "source-date-epoch=0 (runner must set SOURCE_DATE_EPOCH)");
    valid = valid && strings_add(&item->provenance, "lanes-and-time-stages=owned by runner; absent from args.txt");
    return valid;
}

static bool append_sources(PreparedCase* item, const Strings* sources)
{
    bool valid = true;
    const size_t count = sources->count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        valid = strings_add(&item->arguments, sources->items[i]);
    }
    return valid;
}

static bool make_cases(const Corpus* corpus, const char* synth_root, const Strings* synth, const Digests* synth_hashes, const MuslSelection* musl, PreparedCase* cases)
{
    char sqlite_path[PATH_MAX];
    char musl_root[PATH_MAX];
    Strings sqlite = { 0 };
    bool valid = path_join(sqlite_path, corpus->root, "sqlite/sqlite3.c") && strings_add(&sqlite, sqlite_path);
    valid = valid && path_join(musl_root, corpus->root, "libc/musl");
    valid = valid && case_base(&cases[0], "sqlite", corpus, &sqlite, false);
    static const char* const sqlite_options[] = {
        "-DSQLITE_OMIT_LOAD_EXTENSION",
        "-DSQLITE_THREADSAFE=0",
        "-DSQLITE_ENABLE_MEMSYS5",
        "-DSQLITE_ENABLE_RTREE",
    };
    for (size_t i = 0; valid && i < sizeof(sqlite_options) / sizeof(sqlite_options[0]); i += 1)
    {
        valid = strings_add(&cases[0].arguments, sqlite_options[i]);
    }
    valid = valid && argument_path(&cases[0].arguments, "-I", corpus->root, "sqlite");
    valid = valid && append_sources(&cases[0], &sqlite) && digests_copy(&cases[0].dependencies, &corpus->headers, NULL);
    valid = valid && digests_copy(&cases[0].dependencies, &corpus->sqlite, NULL);
    valid = valid && strings_add(&cases[0].provenance, "input=SQLite 3.53.2 amalgamation; options follow the compile-time workload with frozen headers/predefines");
    valid = valid && case_base(&cases[1], "synth", corpus, synth, false) && append_sources(&cases[1], synth);
    valid = valid && digests_copy(&cases[1].dependencies, &corpus->headers, NULL) && digests_copy(&cases[1].dependencies, synth_hashes, NULL);
    valid = valid && strings_format(&cases[1].provenance, "synth-root=%s", synth_root);
    valid = valid && strings_add(&cases[1].provenance, "required-generator=the campaign's pinned compiler test-check-units --generate DIR --units 512 --functions 200 --seed 149");
    valid = valid && strings_add(&cases[1].provenance, "shape-verified=unit_0.c through unit_511.c only; each has 200 distinct named function definitions and its 200-entry table declaration; no generated header");
    valid = valid && strings_add(&cases[1].provenance, "seed=149 required; seed and generator revision are not inferred from shape or re-executed here; retain the campaign's generation receipt");
    valid = valid && case_base(&cases[2], "musl", corpus, &musl->sources, true) && append_sources(&cases[2], &musl->sources);
    valid = valid && digests_copy(&cases[2].dependencies, &corpus->libc, musl_root) && digests_copy(&cases[2].dependencies, &corpus->generated, NULL);
    valid = valid && strings_add(&cases[2].provenance, "input=frozen Zig 0.14.1 libc tree's patched musl 1.2.5 and generated x86_64 header overlay");
    valid = valid && strings_add(&cases[2].provenance, "selection=src/*/*.c minus generic counterparts of src/*/x86_64/*.[csS], plus src/*/x86_64/*.c; bytewise path order");
    valid = valid && strings_add(&cases[2].provenance, "selection-is-not-a-supported-subset=every selected C input must compile; assembly implementations and other architecture/helper files are outside this C-only cohort");
    valid = valid && strings_format(&cases[2].provenance, "generic-C-count=%zu; architecture-replacements=%zu; architecture-C-count=%zu; selected-C-count=%zu",
                                    musl->generic_count, musl->replacement_count, musl->architecture_c_count, musl->sources.count);
    const size_t exclusions = musl->exclusions.count;
    for (size_t i = 0; valid && i < exclusions; i += 1)
    {
        valid = strings_add(&cases[2].provenance, musl->exclusions.items[i]);
    }
    for (size_t i = 0; valid && i < 3; i += 1)
    {
        valid = digests_sort(&cases[i].dependencies, true);
        valid = valid && strings_format(&cases[i].provenance, "dependency-count=%zu; includes conservative header/source supersets and frozen manifest identities", cases[i].dependencies.count);
    }
    strings_free(&sqlite);
    return valid;
}

static void case_free(PreparedCase* item)
{
    strings_free(&item->arguments);
    strings_free(&item->outputs);
    strings_free(&item->provenance);
    digests_free(&item->dependencies);
}

static bool write_lines(const char* directory, const char* name, const Strings* lines)
{
    char path[PATH_MAX];
    bool valid = path_join(path, directory, name);
    FILE* output = valid ? fopen(path, "wx") : NULL;
    valid = valid && output != NULL && lines->count != 0;
    const size_t count = lines->count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        valid = fprintf(output, "%s\n", lines->items[i]) > 0;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    return valid || fail("could not write %s", name);
}

static bool write_case(const char* root, const PreparedCase* item)
{
    char directory[PATH_MAX];
    char manifest[PATH_MAX];
    bool valid = path_join(directory, root, item->name) && mkdir(directory, 0755) == 0;
    valid = valid && write_lines(directory, "args.txt", &item->arguments) && write_lines(directory, "outputs.txt", &item->outputs);
    valid = valid && write_lines(directory, "provenance.txt", &item->provenance) && path_join(manifest, directory, "sources.sha256");
    FILE* output = valid ? fopen(manifest, "wx") : NULL;
    valid = valid && output != NULL;
    const size_t count = item->dependencies.count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        valid = fprintf(output, "%s  %s\n", item->dependencies.items[i].hash, item->dependencies.items[i].path) > 0;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    return valid || fail("could not write case %s", item->name);
}

static void discard_cases(const char* root)
{
    static const char* const cases[] = { "sqlite", "synth", "musl" };
    static const char* const files[] = { "args.txt", "outputs.txt", "sources.sha256", "provenance.txt" };
    for (size_t c = 0; c < 3; c += 1)
    {
        char directory[PATH_MAX];
        if (path_join(directory, root, cases[c]))
        {
            for (size_t f = 0; f < 4; f += 1)
            {
                char path[PATH_MAX];
                if (path_join(path, directory, files[f]))
                {
                    unlink(path);
                }
            }
            rmdir(directory);
        }
    }
    rmdir(root);
}

// Publish only a complete new directory. A concurrent creator is respected by RENAME_NOREPLACE;
// on failure only the private temporary directory and the files this tool created are removed.
static bool publish_cases(const char* requested, const PreparedCase* cases)
{
    bool valid = safe_text(requested) && strlen(requested) < PATH_MAX;
    char parent[PATH_MAX];
    char output[PATH_MAX];
    char temporary[PATH_MAX] = { 0 };
    char* copy = valid ? strdup(requested) : NULL;
    valid = valid && copy != NULL;
    char* slash = valid ? strrchr(copy, '/') : NULL;
    const char* name = slash != NULL ? slash + 1 : copy;
    if (valid && slash != NULL)
    {
        *slash = 0;
    }
    valid = valid && name != NULL && relative_path(name) && strchr(name, '/') == NULL;
    const char* parent_name = slash != NULL ? (copy[0] != 0 ? copy : "/") : ".";
    valid = valid && realpath(parent_name, parent) != NULL && safe_text(parent) && path_join(output, parent, name);
    struct stat info;
    if (valid)
    {
        valid = lstat(output, &info) < 0 && errno == ENOENT;
    }
    const int written = valid ? snprintf(temporary, sizeof(temporary), "%s/.multicore-149-XXXXXX", parent) : -1;
    valid = valid && written > 0 && (size_t)written < sizeof(temporary);
    bool created = false;
    if (valid)
    {
        created = mkdtemp(temporary) != NULL;
        valid = created;
    }
    for (size_t i = 0; valid && i < 3; i += 1)
    {
        valid = write_case(temporary, &cases[i]);
    }
    if (valid)
    {
        valid = renameat2(AT_FDCWD, temporary, AT_FDCWD, output, RENAME_NOREPLACE) == 0;
    }
    if (created && !valid)
    {
        discard_cases(temporary);
    }
    free(copy);
    return valid || fail("could not publish a complete, previously nonexistent case directory: %s", requested);
}

static bool prepare(const char* corpus_name, const char* synth_name, const char* output, bool fixture_only)
{
    Corpus corpus = { 0 };
    char synth_root[PATH_MAX];
    Strings synth = { 0 };
    Strings musl_files = { 0 };
    Digests synth_hashes = { 0 };
    MuslSelection musl = { 0 };
    PreparedCase cases[3] = { 0 };
    bool valid = directory_path(synth_name, synth_root) && corpus_read(corpus_name, &corpus);
    valid = valid && synth_inventory(synth_root, BUSTER_PREPARE_SYNTH_UNITS, BUSTER_PREPARE_SYNTH_FUNCTIONS, &synth);
    valid = valid && hash_files(&synth, &synth_hashes);
    char musl_root[PATH_MAX];
    valid = valid && path_join(musl_root, corpus.root, "libc/musl");
    const size_t libc_count = corpus.libc.count;
    for (size_t i = 0; valid && i < libc_count; i += 1)
    {
        valid = strings_add(&musl_files, corpus.libc.items[i].path);
    }
    valid = valid && select_musl(musl_root, &musl_files, &musl);
    valid = valid && (musl.sources.count == BUSTER_PREPARE_MUSL_UNITS || fail("expected 1309 selected frozen musl C units, found %zu", musl.sources.count));
    valid = valid && make_cases(&corpus, synth_root, &synth, &synth_hashes, &musl, cases);
    if (fixture_only)
    {
        for (size_t i = 0; valid && i < 3; i += 1)
        {
            valid = strings_add(&cases[i].provenance, "qualification-fixture-only=not a generated benchmark corpus and not acceptance evidence");
        }
    }
    valid = valid && verify_pins(corpus.root, NULL) && publish_cases(output, cases);
    if (valid)
    {
        printf("prepare: sqlite=1 synth=%zu musl=%zu; frozen inputs verified; %s\n", synth.count, musl.sources.count,
               fixture_only ? "qualification fixture only" : "case manifests written; retain the generator receipt");
    }
    for (size_t i = 0; i < 3; i += 1)
    {
        case_free(&cases[i]);
    }
    selection_free(&musl);
    digests_free(&synth_hashes);
    strings_free(&musl_files);
    strings_free(&synth);
    corpus_free(&corpus);
    return valid;
}

// The fixtures below are original tiny C text used only to exercise inventory and transport.
// They are not compiler workloads, imported musl sources, or performance results.
typedef struct Test Test;
struct Test
{
    size_t checks;
    size_t failures;
};

static void test_expect(Test* test, bool condition, const char* name)
{
    test->checks += 1;
    test->failures += !condition;
    if (!condition)
    {
        fprintf(stderr, "prepare self-test: FAIL %s (%s)\n", name, preparation_error);
    }
}

static bool test_file(const char* root, const char* relative, const char* text)
{
    char path[PATH_MAX];
    bool valid = path_join(path, root, relative);
    const size_t start = strlen(root) + 1;
    for (size_t i = start; valid && path[i] != 0; i += 1)
    {
        if (path[i] == '/')
        {
            path[i] = 0;
            valid = mkdir(path, 0700) == 0 || errno == EEXIST;
            path[i] = '/';
        }
    }
    FILE* file = valid ? fopen(path, "w") : NULL;
    valid = valid && file != NULL;
    if (file != NULL)
    {
        valid = fputs(text, file) >= 0 && valid;
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool test_synth(const char* root, size_t units, size_t functions)
{
    bool valid = mkdir(root, 0700) == 0 || errno == EEXIST;
    for (size_t unit = 0; valid && unit < units; unit += 1)
    {
        char name[64];
        char path[PATH_MAX];
        snprintf(name, sizeof(name), "unit_%zu.c", unit);
        valid = path_join(path, root, name);
        FILE* file = valid ? fopen(path, "w") : NULL;
        valid = valid && file != NULL;
        if (valid)
        {
            valid = fprintf(file, "#include <stdio.h>\n/* Original preparation fixture; not a measured program. */\n") > 0;
        }
        for (size_t function = 0; valid && function < functions; function += 1)
        {
            valid = fprintf(file, "unsigned function_%zu_%zu(unsigned depth, unsigned x)\n{\n    return depth ^ x ^ %zuu;\n}\n", unit, function, function) > 0;
        }
        if (valid)
        {
            valid = fprintf(file, "unsigned (*const table_%zu[%zu])(unsigned, unsigned) = { 0 };\n", unit, functions) > 0;
        }
        if (file != NULL)
        {
            valid = fclose(file) == 0 && valid;
        }
    }
    return valid;
}

static void test_cleanup(const char* root)
{
    Strings directories = { 0 };
    bool valid = strings_add(&directories, root);
    for (size_t i = 0; valid && i < directories.count; i += 1)
    {
        DIR* stream = opendir(directories.items[i]);
        valid = stream != NULL;
        bool finished = false;
        while (valid && !finished)
        {
            errno = 0;
            const struct dirent* entry = readdir(stream);
            if (entry == NULL)
            {
                valid = errno == 0;
                finished = true;
            }
            else if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
            {
                char path[PATH_MAX];
                struct stat info;
                valid = path_join(path, directories.items[i], entry->d_name) && lstat(path, &info) == 0;
                if (valid)
                {
                    valid = S_ISDIR(info.st_mode) ? strings_add(&directories, path) : unlink(path) == 0;
                }
            }
        }
        if (stream != NULL)
        {
            valid = closedir(stream) == 0 && valid;
        }
    }
    for (size_t i = directories.count; i != 0; i -= 1)
    {
        rmdir(directories.items[i - 1]);
    }
    strings_free(&directories);
}

static bool count_lines(const char* root, const char* relative, size_t expected)
{
    char path[PATH_MAX];
    bool valid = path_join(path, root, relative);
    FILE* file = valid ? fopen(path, "r") : NULL;
    valid = valid && file != NULL;
    size_t count = 0;
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length = 0;
    while (valid && (length = getline(&line, &capacity, file)) >= 0)
    {
        valid = length > 1 && line[length - 1] == '\n' && strlen(line) == (size_t)length;
        count += 1;
    }
    if (file != NULL)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    free(line);
    return valid && count == expected;
}

static int self_test(const char* corpus)
{
    Test test = { 0 };
    const char* temporary = getenv("TMPDIR");
    temporary = temporary != NULL && temporary[0] != 0 ? temporary : "/tmp";
    char parent[PATH_MAX];
    char directory[PATH_MAX];
    const bool parent_valid = directory_path(temporary, parent);
    const int length = parent_valid ? snprintf(directory, sizeof(directory), "%s/multicore-149-prepare-XXXXXX", parent) : -1;
    const bool created = length > 0 && (size_t)length < sizeof(directory) && mkdtemp(directory) != NULL;
    test_expect(&test, created, "create isolated fixture directory");
    test_expect(&test, relative_path("src/math/a.c") && !relative_path("../escape") && !relative_path("/absolute") &&
                         !relative_path("a//b") && !relative_path("a/./b") && !relative_path("a\nb") && !relative_path("a\\b"), "manifest path boundaries");
    if (created)
    {
        Corpus argument_corpus = { 0 };
        const int root_length = snprintf(argument_corpus.root, sizeof(argument_corpus.root), "%s", directory);
        for (unsigned musl = 0; musl < 2; musl += 1)
        {
            Strings arguments = { 0 };
            const bool built = root_length > 0 && (size_t)root_length < sizeof(argument_corpus.root) && common_arguments(&arguments, &argument_corpus, musl != 0);
            strings_sort(&arguments);
            test_expect(&test, built && strings_contains(&arguments, "-c") && strings_contains(&arguments, "-nostdinc") &&
                                 !strings_contains(&arguments, "--no-default-config"), "Buster arguments exclude the Clang-only default-config flag");
            strings_free(&arguments);
        }
        static const char* const names[] = {
            "musl/src/math/plain.c",
            "musl/src/math/a.c",
            "musl/src/math/b.c",
            "musl/src/math/c.c",
            "musl/src/math/x86_64/a.c",
            "musl/src/math/x86_64/b.s",
            "musl/src/math/x86_64/c.S",
            "musl/src/math/aarch64/plain.c",
            "musl/src/string/other.c",
        };
        bool fixture = true;
        for (size_t i = 0; fixture && i < sizeof(names) / sizeof(names[0]); i += 1)
        {
            fixture = test_file(directory, names[i], "/* Original inventory fixture. */\n");
        }
        char musl_root[PATH_MAX];
        fixture = fixture && path_join(musl_root, directory, "musl");
        Strings files = { 0 };
        MuslSelection first = { 0 };
        MuslSelection reverse = { 0 };
        fixture = fixture && inventory_tree(musl_root, &files, false) && select_musl(musl_root, &files, &first);
        test_expect(&test, fixture && first.sources.count == 3 && first.generic_count == 5 && first.replacement_count == 3 &&
                             first.architecture_c_count == 1 && first.exclusions.count == 5, "C, s and S architecture replacement selection");
        for (size_t i = 0; i < files.count / 2; i += 1)
        {
            char* swap = files.items[i];
            files.items[i] = files.items[files.count - 1 - i];
            files.items[files.count - 1 - i] = swap;
        }
        bool stable = fixture && select_musl(musl_root, &files, &reverse) && first.sources.count == reverse.sources.count;
        for (size_t i = 0; stable && i < first.sources.count; i += 1)
        {
            stable = strcmp(first.sources.items[i], reverse.sources.items[i]) == 0;
        }
        test_expect(&test, stable, "selection order independent of directory order");
        Strings outputs = { 0 };
        test_expect(&test, fixture && source_outputs(&first.sources, &outputs) && outputs.count == 3, "unique expected object names");
        strings_free(&outputs);
        char duplicate[PATH_MAX];
        bool duplicate_ready = path_join(duplicate, musl_root, "src/string/plain.c") && strings_add(&first.sources, duplicate);
        test_expect(&test, duplicate_ready && !source_outputs(&first.sources, &outputs), "duplicate object names refused");
        strings_free(&outputs);
        strings_free(&files);
        selection_free(&first);
        selection_free(&reverse);

        char synth[PATH_MAX];
        fixture = path_join(synth, directory, "synth with spaces") && test_synth(synth, 3, 2);
        Strings sources = { 0 };
        test_expect(&test, fixture && synth_inventory(synth, 3, 2, &sources) && sources.count == 3, "exact synthetic inventory and named definitions");
        strings_free(&sources);
        char path[PATH_MAX];
        bool removed = path_join(path, synth, "unit_1.c") && unlink(path) == 0;
        test_expect(&test, removed && !synth_inventory(synth, 3, 2, &sources), "missing synthetic unit refused");
        strings_free(&sources);
        fixture = test_synth(synth, 3, 2) && test_file(synth, "extra.c", "int extra;\n");
        test_expect(&test, fixture && !synth_inventory(synth, 3, 2, &sources), "extra synthetic source refused");
        strings_free(&sources);
        if (path_join(path, synth, "extra.c"))
        {
            unlink(path);
        }
        fixture = test_file(synth, "common.h", "/* No generated header exists in this recipe. */\n");
        test_expect(&test, fixture && !synth_inventory(synth, 3, 2, &sources), "unexpected synthetic header refused");
        strings_free(&sources);
        if (path_join(path, synth, "common.h"))
        {
            unlink(path);
        }
        fixture = path_join(path, synth, "unit_1.c") && unlink(path) == 0 && symlink("unit_0.c", path) == 0;
        test_expect(&test, fixture && !synth_inventory(synth, 3, 2, &sources), "symlink synthetic input refused");
        strings_free(&sources);
        if (path_join(path, synth, "unit_1.c"))
        {
            unlink(path);
        }
        fixture = test_synth(synth, 3, 1);
        test_expect(&test, fixture && !synth_inventory(synth, 3, 2, &sources), "wrong function count refused");
        strings_free(&sources);

        fixture = test_file(directory, "literal ' dollar$(false).txt", "abc") && path_join(path, directory, "literal ' dollar$(false).txt");
        Strings hash_inputs = { 0 };
        Digests hashes = { 0 };
        fixture = fixture && strings_add(&hash_inputs, path) && hash_files(&hash_inputs, &hashes);
        test_expect(&test, fixture && hashes.count == 1 && strcmp(hashes.items[0].path, path) == 0 &&
                             strcmp(hashes.items[0].hash, "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad") == 0, "literal argv hashing with spaces and shell metacharacters");
        strings_free(&hash_inputs);
        digests_free(&hashes);
        FILE* malformed = tmpfile();
        fixture = malformed != NULL;
        if (fixture)
        {
            fixture = fputs("0000000000000000000000000000000000000000000000000000000000000000  ../escape\n", malformed) >= 0 &&
                      fflush(malformed) == 0 && fseek(malformed, 0, SEEK_SET) == 0;
        }
        test_expect(&test, fixture && !read_digests(malformed, directory, &hashes), "hash manifest traversal refused");
        if (malformed != NULL)
        {
            fclose(malformed);
        }
        digests_free(&hashes);

        if (corpus != NULL)
        {
            char full_synth[PATH_MAX];
            char cases[PATH_MAX];
            fixture = path_join(full_synth, directory, "full synthetic fixture") && path_join(cases, directory, "cases");
            fixture = fixture && test_synth(full_synth, BUSTER_PREPARE_SYNTH_UNITS, BUSTER_PREPARE_SYNTH_FUNCTIONS);
            fixture = fixture && prepare(corpus, full_synth, cases, true);
            test_expect(&test, fixture, "full frozen-corpus preparation with an original test-only stand-in");
            test_expect(&test, fixture && count_lines(cases, "sqlite/outputs.txt", 1) && count_lines(cases, "synth/outputs.txt", 512) &&
                                 count_lines(cases, "musl/outputs.txt", 1309), "prepared 1/512/1309 object inventories");
            Strings case_files = { 0 };
            test_expect(&test, fixture && inventory_tree(cases, &case_files, false) && case_files.count == 12, "complete four-file contract for each case");
            strings_free(&case_files);
            PreparedCase empty[3] = { 0 };
            test_expect(&test, fixture && !publish_cases(cases, empty), "existing output directory never overwritten");
            static const char* const case_names[] = { "sqlite", "synth", "musl" };
            for (size_t i = 0; fixture && i < 3; i += 1)
            {
                char case_directory[PATH_MAX];
                char manifest[PATH_MAX];
                fixture = path_join(case_directory, cases, case_names[i]) && path_join(manifest, case_directory, "sources.sha256");
                char* arguments[] = { "sha256sum", "--strict", "--check", "--status", manifest, NULL };
                test_expect(&test, fixture && run_sha256(NULL, arguments, -1, -1), "prepared dependency manifest validates every referenced byte");
            }
        }
        if (test.failures == 0)
        {
            test_cleanup(directory);
        }
        else
        {
            fprintf(stderr, "prepare self-test: retained fixtures at %s\n", directory);
        }
    }
    printf("prepare self-test: %zu checks, %zu failures%s\n", test.checks, test.failures, corpus != NULL ? " (including frozen corpus; no compiler executed)" : "");
    return test.failures == 0 ? 0 : 1;
}

int main(int argc, char** argv)
{
    const char* corpus = NULL;
    const char* synth = NULL;
    const char* output = NULL;
    bool testing = false;
    bool parsed = true;
    for (int i = 1; parsed && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--self-test") == 0 && !testing)
        {
            testing = true;
        }
        else if (strcmp(argv[i], "--corpus") == 0 && corpus == NULL && i + 1 < argc)
        {
            corpus = argv[++i];
        }
        else if (strcmp(argv[i], "--synth") == 0 && synth == NULL && i + 1 < argc)
        {
            synth = argv[++i];
        }
        else if (strcmp(argv[i], "--output") == 0 && output == NULL && i + 1 < argc)
        {
            output = argv[++i];
        }
        else
        {
            parsed = false;
        }
    }
    parsed = parsed && (testing ? synth == NULL && output == NULL : corpus != NULL && synth != NULL && output != NULL);
    int result = 2;
    if (!parsed)
    {
        fprintf(stderr, "usage: prepare --corpus ABS_FROZEN_ROOT --synth ABS_GENERATED_DIR --output NEW_CASES_DIR\n"
                        "       prepare --self-test [--corpus ABS_FROZEN_ROOT]\n");
    }
    else if (testing)
    {
        result = self_test(corpus);
    }
    else
    {
        const bool valid = prepare(corpus, synth, output, false);
        if (!valid)
        {
            fprintf(stderr, "prepare: %s\n", preparation_error);
        }
        result = valid ? 0 : 1;
    }
    return result;
}
