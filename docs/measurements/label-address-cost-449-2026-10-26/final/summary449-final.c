// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Final receipt/identity checks around the unchanged prototype's parsing and metric arithmetic.
// Place in record/final/ beside the retained record/summary449.c. Build this file with -O2 -Wall -Wextra -Werror -lm.
// Usage: summary449-final RAW_DIRECTORY FROZEN_LUA_SOURCE_MANIFEST; --self-test uses synthetic parser fixtures only.
#include <stdio.h>
static FILE* final_metric_fopen(const char* path, const char* mode);
#define fopen final_metric_fopen
#define main prototype_main
#include "../summary449.c"
#undef main
#undef fopen
#include <dirent.h>

enum { BUSTER_LUA_FILES = 61, BUSTER_ID_FILES = 68, BUSTER_ID_PATH = 512, BUSTER_CONFIG_FIELDS = 9 };
static const char* lua_root = "/home/david/buster-fast-bench/x87-136/lua/";
static const char* corpus_root = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658";
static const char* config_keys[BUSTER_CONFIG_FIELDS] =
{
    "online CPUs:", "clang version ", "Target:", "Thread model:", "InstalledDir:",
    "scaling_driver:", "scaling_governor:", "scaling_min_freq:", "scaling_max_freq:",
};

typedef struct IdentityRow IdentityRow;
struct IdentityRow
{
    char hash[65];
    char path[BUSTER_ID_PATH];
};

typedef struct Snapshot Snapshot;
struct Snapshot
{
    IdentityRow rows[BUSTER_ID_FILES];
    unsigned count;
    char config[BUSTER_CONFIG_FIELDS][256];
};

static void trim_line(char* line)
{
    line[strcspn(line, "\r\n")] = 0;
}

static bool parse_hash(const char* line, IdentityRow* row)
{
    bool valid = strlen(line) >= 67;
    for (unsigned byte = 0; valid && byte < 64; byte += 1)
    {
        valid = isxdigit((unsigned char)line[byte]) != 0;
    }
    valid = valid && isspace((unsigned char)line[64]) != 0 && isspace((unsigned char)line[65]) != 0;
    if (valid)
    {
        const char* path = line + 66;
        valid = *path != 0 && strlen(path) < sizeof(row->path);
        if (valid)
        {
            for (unsigned byte = 0; byte < 64; byte += 1)
            {
                row->hash[byte] = (char)tolower((unsigned char)line[byte]);
            }
            row->hash[64] = 0;
            strcpy(row->path, path);
        }
    }
    return valid;
}

static const char* find_hash(const IdentityRow* rows, unsigned count, const char* path)
{
    const char* result = NULL;
    for (unsigned row = 0; row < count; row += 1)
    {
        if (strcmp(rows[row].path, path) == 0)
        {
            result = rows[row].hash;
        }
    }
    return result;
}

static bool metadata(FILE* file, const char* command, unsigned kind)
{
    const char* lists[4] =
    {
        "-fsyntax-only --predefines /var/lib/buster-9700x/corpora/preprocessor-391e729af658/provenance/gnu17-pinned-predefines.txt --clang-features -march=znver5 -std=gnu17 -nostdinc -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/lib/clang/23/include -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/local/include -isystem /var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr/include /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c",
        "-c /home/david/buster-fast-bench/x87-136/lua/lstrlib.c -o /dev/null",
        "-c -U__ELF__ /home/david/buster-fast-bench/x87-136/lua/lparser.c -o /dev/null",
        "-fsyntax-only label-dispatch-128.c",
    };
    char* line = NULL;
    size_t capacity = 0;
    unsigned commands = 0;
    unsigned summaries = 0;
    unsigned counters = 0;
    bool valid = true;
    while (getline(&line, &capacity, file) >= 0)
    {
        trim_line(line);
        if (strncmp(line, "command:", 8) == 0)
        {
            commands += 1;
            valid = strcmp(line + 8, command) == 0 && valid;
        }
        if (kind == 0 && strncmp(line, "list ", 5) == 0)
        {
            unsigned list = 0;
            const char* begin = strchr(line, '[');
            const char* end = begin != NULL ? strstr(begin, "]: ") : NULL;
            const bool index = sscanf(line, "list %u [", &list) == 1 && list >= 1 && list <= 4;
            valid = index && begin != NULL && end != NULL && valid;
            if (index && begin != NULL && end != NULL)
            {
                summaries += 1;
                const size_t length = (size_t)(end - begin - 1);
                valid = length == strlen(lists[list - 1]) && strncmp(begin + 1, lists[list - 1], length) == 0 && valid;
            }
        }
        if (kind == 1)
        {
            char* end = NULL;
            (void)strtod(line, &end);
            if (end != line && *end == ',')
            {
                counters += 1;
                const char* instructions = strstr(end, ",instructions:u,");
                const char* cycles = strstr(end, ",cycles:u,");
                valid = (instructions != NULL || cycles != NULL) && valid;
            }
        }
    }
    valid = !ferror(file) && commands == 1 && (kind != 0 || summaries == 4) && (kind != 1 || counters == 2) && valid;
    free(line);
    rewind(file);
    return valid;
}

static FILE* open_checked(const char* path, const char* command, unsigned kind)
{
    FILE* file = fopen(path, "r");
    if (file != NULL && !metadata(file, command, kind))
    {
        fclose(file);
        file = NULL;
    }
    return file;
}

// The unchanged prototype asks for its original preflight aliases. Map only these eight explicit names;
// measurement names stay unchanged, and their command must identify head449-final rather than the prototype.
static FILE* final_metric_fopen(const char* path, const char* mode)
{
    const char* name = strrchr(path, '/');
    name = name != NULL ? name + 1 : path;
    const size_t prefix = (size_t)(name - path);
    const char* trees[2] = { "base", "head449" };
    const char* actual[2] = { "base", "head449-final" };
    const char* units[4] = { "sqlite", "lstrlib", "lparser", "labels" };
    const char* names[3] = { "process", "perf", "labels-perf" };
    const char* commands[3] = { "process", "perf", "perf-labels" };
    char candidate[128];
    char mapped[4096] = { 0 };
    char command[256] = { 0 };
    unsigned kind = 2;
    bool found = false;
    for (unsigned tree = 0; tree < 2; tree += 1)
    {
        for (unsigned unit = 0; unit < 4; unit += 1)
        {
            snprintf(candidate, sizeof(candidate), "preflight-%s-%s.log", trees[tree], units[unit]);
            if (strcmp(name, candidate) == 0)
            {
                const int length = snprintf(mapped, sizeof(mapped), "%.*spreflight-%s-%s.log", (int)prefix, path, units[unit], actual[tree]);
                found = length > 0 && (size_t)length < sizeof(mapped);
                snprintf(command, sizeof(command), " bash commands449.sh %s %s", units[unit], actual[tree]);
            }
        }
        for (unsigned round = 1; round <= BUSTER_ROUNDS; round += 1)
        {
            for (unsigned metric = 0; metric < 3; metric += 1)
            {
                snprintf(candidate, sizeof(candidate), "%s-%u-%s.log", names[metric], round, trees[tree]);
                if (strcmp(name, candidate) == 0)
                {
                    const int length = snprintf(mapped, sizeof(mapped), "%s", path);
                    found = length > 0 && (size_t)length < sizeof(mapped);
                    kind = metric == 0 ? 0 : 1;
                    snprintf(command, sizeof(command), " bash commands449.sh %s %s", commands[metric], actual[tree]);
                }
            }
        }
    }
    FILE* file = found && strcmp(mode, "r") == 0 ? open_checked(mapped, command, kind) : NULL;
    return file;
}

static bool receipt_file(const char* directory, const char* name, const char* command)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/%s.log", directory, name);
    FILE* file = length > 0 && (size_t)length < sizeof(path) ? open_checked(path, command, 2) : NULL;
    bool valid = file != NULL;
    if (file != NULL)
    {
        valid = preflight_log(file);
        valid = fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "summary449-final: incomplete/unsuccessful or unexpected receipt: %s\n", name);
    }
    return valid;
}

static bool lua_manifest(const char* path, IdentityRow rows[BUSTER_LUA_FILES])
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    char* line = NULL;
    size_t capacity = 0;
    unsigned count = 0;
    while (file != NULL && getline(&line, &capacity, file) >= 0)
    {
        trim_line(line);
        IdentityRow one;
        const bool parsed = parse_hash(line, &one);
        valid = parsed && count < BUSTER_LUA_FILES && valid;
        if (parsed && count < BUSTER_LUA_FILES)
        {
            const char* relative = strncmp(one.path, "./", 2) == 0 ? one.path + 2 : one.path;
            char absolute[BUSTER_ID_PATH];
            const int length = snprintf(absolute, sizeof(absolute), "%s%s", lua_root, relative);
            valid = *relative != '/' && strstr(relative, "..") == NULL && length > 0 && (size_t)length < sizeof(absolute) &&
                    find_hash(rows, count, absolute) == NULL && valid;
            strcpy(rows[count].hash, one.hash);
            if (length > 0 && (size_t)length < sizeof(absolute))
            {
                strcpy(rows[count].path, absolute);
            }
            count += 1;
        }
    }
    if (file != NULL)
    {
        const bool read = !ferror(file);
        valid = fclose(file) == 0 && read && valid;
    }
    free(line);
    return valid && count == BUSTER_LUA_FILES;
}

static bool snapshot(const char* directory, const char* name, Snapshot* result)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s.log", directory, name);
    FILE* file = open_checked(path, " bash provenance449-final.sh", 2);
    bool valid = file != NULL;
    char* line = NULL;
    size_t capacity = 0;
    unsigned base = 0;
    unsigned head = 0;
    bool config[BUSTER_CONFIG_FIELDS] = { false };
    if (file != NULL)
    {
        valid = preflight_log(file) && valid;
        rewind(file);
    }
    while (file != NULL && getline(&line, &capacity, file) >= 0)
    {
        trim_line(line);
        if (strncmp(line, "base commit:", 12) == 0)
        {
            base += 1;
            valid = strcmp(line, "base commit: 9de3d30ba437b381394095d7a77635a2e877435d") == 0 && valid;
        }
        if (strncmp(line, "head commit:", 12) == 0)
        {
            head += 1;
            valid = strcmp(line, "head commit: f7af14f10cfb38fcbc384dcb2584ed846fe33860") == 0 && valid;
        }
        IdentityRow row;
        if (parse_hash(line, &row))
        {
            const bool room = result->count < BUSTER_ID_FILES && find_hash(result->rows, result->count, row.path) == NULL;
            valid = room && valid;
            if (room)
            {
                result->rows[result->count++] = row;
            }
        }
        for (unsigned field = 0; field < BUSTER_CONFIG_FIELDS; field += 1)
        {
            if (strncmp(line, config_keys[field], strlen(config_keys[field])) == 0)
            {
                valid = !config[field] && strlen(line) < sizeof(result->config[field]) && valid;
                config[field] = true;
                if (strlen(line) < sizeof(result->config[field]))
                {
                    strcpy(result->config[field], line);
                }
            }
        }
    }
    if (file != NULL)
    {
        const bool read = !ferror(file);
        valid = fclose(file) == 0 && read && valid;
    }
    free(line);
    for (unsigned field = 0; field < BUSTER_CONFIG_FIELDS; field += 1)
    {
        valid = config[field] && valid;
    }
    return valid && base == 1 && head == 1 && result->count == BUSTER_ID_FILES;
}

static bool same_rows(const IdentityRow* before, const IdentityRow* after, unsigned count)
{
    bool valid = true;
    for (unsigned row = 0; row < count; row += 1)
    {
        const char* hash = find_hash(after, count, before[row].path);
        valid = hash != NULL && strcmp(hash, before[row].hash) == 0 && valid;
    }
    return valid;
}

static bool identities(const char* directory, const char* manifest)
{
    Snapshot before = { 0 };
    Snapshot after = { 0 };
    IdentityRow lua[BUSTER_LUA_FILES] = { 0 };
    bool valid = lua_manifest(manifest, lua);
    valid = snapshot(directory, "provenance-before", &before) && valid;
    valid = snapshot(directory, "provenance-after", &after) && valid;
    valid = same_rows(before.rows, after.rows, BUSTER_ID_FILES) && valid;
    const char* paths[7] = { "base.tar", "head449-final.tar", "base/build/compiler", "head449-final/build/compiler", "label-dispatch-128.c", "sqlite/sqlite3.c", "provenance/gnu17-pinned-predefines.txt" };
    const char* expected[7] =
    {
        NULL,
        "afbf05f18d99176033a23261ce0cbc0e2e716a66c9c65bfc1de7b829108986a6",
        "a5faaad818d33f1ea44a31be5550f9988db009d323ef09a13f7def702c782de5",
        "f20ac86eeb71787112c4e26ce290dc62223c7ac703f924d0919472b8e2c0b6f2",
        "b6d81b2fefd5bffa8ee5607589f959a1dbcfd520ea8ca7eba2b8555858821dc6",
        "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d",
        "a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33",
    };
    for (unsigned row = 0; row < 7; row += 1)
    {
        char path[BUSTER_ID_PATH];
        snprintf(path, sizeof(path), "%s%s%s", row >= 5 ? corpus_root : "", row >= 5 ? "/" : "", paths[row]);
        const char* hash = find_hash(before.rows, before.count, path);
        valid = hash != NULL && (expected[row] == NULL || strcmp(hash, expected[row]) == 0) && valid;
    }
    for (unsigned row = 0; row < BUSTER_LUA_FILES; row += 1)
    {
        const char* hash = find_hash(before.rows, before.count, lua[row].path);
        valid = hash != NULL && strcmp(hash, lua[row].hash) == 0 && valid;
    }
    for (unsigned field = 0; field < BUSTER_CONFIG_FIELDS; field += 1)
    {
        valid = strcmp(before.config[field], after.config[field]) == 0 && valid;
    }
    // The successful native retry is separate from the retained, pre-compilation first-attempt failure.
    char path[4096];
    snprintf(path, sizeof(path), "%s/build.log", directory);
    FILE* build = open_checked(path, " bash /home/david/buster-fast-bench/codex-449-450-451-20261026/build449-final.sh", 2);
    valid = build != NULL && valid;
    char* line = NULL;
    size_t capacity = 0;
    unsigned binaries = 0;
    if (build != NULL)
    {
        valid = preflight_log(build) && valid;
        rewind(build);
    }
    while (build != NULL && getline(&line, &capacity, build) >= 0)
    {
        trim_line(line);
        IdentityRow row;
        if (parse_hash(line, &row) && strcmp(row.path, "build/compiler") == 0)
        {
            binaries += 1;
            const char* hash = find_hash(before.rows, before.count, "head449-final/build/compiler");
            valid = hash != NULL && strcmp(hash, row.hash) == 0 && valid;
        }
    }
    if (build != NULL)
    {
        const bool read = !ferror(build);
        valid = fclose(build) == 0 && read && valid;
    }
    free(line);
    valid = binaries == 1 && valid;
    if (!valid)
    {
        fputs("summary449-final: source/build/input/config identity validation failed\n", stderr);
    }
    return valid;
}

static bool allowed_measurement(const char* name)
{
    const char* trees[2] = { "base", "head449" };
    const char* actual[2] = { "base", "head449-final" };
    const char* units[4] = { "sqlite", "lstrlib", "lparser", "labels" };
    const char* kinds[3] = { "perf", "labels-perf", "process" };
    bool allowed = strcmp(name, "group-preflight.log") == 0;
    char candidate[128];
    for (unsigned tree = 0; tree < 2; tree += 1)
    {
        for (unsigned unit = 0; unit < 4; unit += 1)
        {
            snprintf(candidate, sizeof(candidate), "preflight-%s-%s.log", units[unit], actual[tree]);
            allowed = strcmp(name, candidate) == 0 || allowed;
        }
        for (unsigned round = 1; round <= BUSTER_ROUNDS; round += 1)
        {
            snprintf(candidate, sizeof(candidate), "group-%u.log", round);
            allowed = strcmp(name, candidate) == 0 || allowed;
            for (unsigned kind = 0; kind < 3; kind += 1)
            {
                snprintf(candidate, sizeof(candidate), "%s-%u-%s.log", kinds[kind], round, trees[tree]);
                allowed = strcmp(name, candidate) == 0 || allowed;
            }
        }
    }
    return allowed;
}

static bool no_extra_measurements(const char* directory)
{
    DIR* dir = opendir(directory);
    bool valid = dir != NULL;
    struct dirent* entry = NULL;
    while (dir != NULL && (entry = readdir(dir)) != NULL)
    {
        const char* name = entry->d_name;
        const bool measurement = strncmp(name, "perf-", 5) == 0 || strncmp(name, "labels-perf-", 12) == 0 ||
                                 strncmp(name, "process-", 8) == 0 || strncmp(name, "preflight-", 10) == 0 || strncmp(name, "group-", 6) == 0;
        if (measurement && !allowed_measurement(name))
        {
            fprintf(stderr, "summary449-final: unexpected measurement file %s\n", name);
            valid = false;
        }
    }
    if (dir != NULL)
    {
        valid = closedir(dir) == 0 && valid;
    }
    return valid;
}

static bool final_self_test(void)
{
    const char* hash = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    char line[700];
    snprintf(line, sizeof(line), "%s  ./file.c", hash);
    IdentityRow row;
    bool valid = parse_hash(line, &row) && strcmp(row.hash, hash) == 0 && strcmp(row.path, "./file.c") == 0;
    line[4] = 'z';
    valid = !parse_hash(line, &row) && valid;
    valid = !parse_hash("a  short.c", &row) && valid;
    IdentityRow before[2] = { { .path = "one" }, { .path = "two" } };
    strcpy(before[0].hash, hash);
    strcpy(before[1].hash, hash);
    IdentityRow after[2] = { before[1], before[0] };
    valid = same_rows(before, after, 2) && valid;
    after[0].hash[0] = 'b';
    valid = !same_rows(before, after, 2) && valid;
    valid = allowed_measurement("perf-5-head449.log") && allowed_measurement("preflight-sqlite-head449-final.log") &&
            !allowed_measurement("perf-6-head449.log") && !allowed_measurement("process-1-diag449.log") &&
            !allowed_measurement("preflight-head449-sqlite.log") && valid;
    fprintf(stderr, "summary449-final identity/filename self-test: %s (synthetic only)\n", valid ? "passed" : "FAILED");
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    int status = 1;
    if (argc == 2 && strcmp(argv[1], "--self-test") == 0)
    {
        valid = self_test();
        valid = final_self_test() && valid;
        status = valid ? 0 : 1;
    }
    else if (valid)
    {
        valid = no_extra_measurements(argv[1]);
        valid = identities(argv[1], argv[2]) && valid;
        valid = receipt_file(argv[1], "label-dispatch-acceptance", " taskset -c 2 bash acceptance449-final.sh") && valid;
        valid = receipt_file(argv[1], "group-preflight", " timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh preflight") && valid;
        char name[64];
        char command[256];
        for (unsigned round = 1; round <= BUSTER_ROUNDS; round += 1)
        {
            snprintf(name, sizeof(name), "group-%u", round);
            snprintf(command, sizeof(command), " timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh %u", round);
            valid = receipt_file(argv[1], name, command) && valid;
        }
        if (valid)
        {
            char* arguments[3] = { argv[0], argv[1], NULL };
            status = prototype_main(2, arguments);
        }
    }
    else
    {
        fputs("usage: summary449-final RAW_DIRECTORY LUA_SOURCE_MANIFEST | --self-test\n", stderr);
    }
    return status;
}
