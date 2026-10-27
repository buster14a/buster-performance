// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original #607 decision harness. Build against the pinned Buster source.
// `pool` times the existing exact-string producer, excluding ELF reading,
// decompression and every relocation-map consumer: an optimistic cost screen.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>
#include <spawn.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <elf.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
extern char** environ;
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/link.c"
#include "buster/compiler/link_program.c"
#include "buster/compiler/object_writer.c"
#include "buster/compiler/import.c"
#include "buster/compiler/runtime.c"
#include "buster/compiler/foreign.c"
#include "buster/compiler/inflate.c"
#include "buster/compiler/foreign_strings.c"

static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000 + (uint64_t)t.tv_nsec;
}

static FILE* create(const char* directory, const char* name)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s", directory, name);
    FILE* result = fopen(path, "w");
    if (result == 0)
    {
        perror(path);
        exit(1);
    }
    return result;
}

static void header(FILE* f, uint32_t identity)
{
    for (uint32_t i = 0; i < 32; i += 1)
    {
        fprintf(f, "struct shared_nested_structure_with_a_long_descriptive_debug_type_name_%u_%02u {\n", identity, i);
        if (i != 0)
        {
            fprintf(f, "struct shared_nested_structure_with_a_long_descriptive_debug_type_name_%u_%02u nested_member_with_a_long_descriptive_debug_name_%u_%02u;\n", identity, i - 1, identity, i);
        }
        fprintf(f, "long integer_member_with_a_long_descriptive_debug_member_name_%u_%02u;\n};\n", identity, i);
    }
}

static bool generate(const char* directory, uint32_t count, bool unique)
{
    mkdir(directory, 0755);
    FILE* shared = create(directory, "shared.h");
    header(shared, 0);
    fclose(shared);
    FILE* start = create(directory, "start.c");
    for (uint32_t i = 0; i < count; i += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "unit_%04u.c", i);
        FILE* unit = create(directory, name);
        const uint32_t identity = unique ? i + 1 : 0;
        if (unique)
        {
            header(unit, identity);
        }
        else
        {
            fprintf(unit, "#include \"shared.h\"\n");
        }
        fprintf(unit, "long function_%04u(long x) {\nstruct shared_nested_structure_with_a_long_descriptive_debug_type_name_%u_31 local;\nlocal.integer_member_with_a_long_descriptive_debug_member_name_%u_31 = x;\nreturn local.integer_member_with_a_long_descriptive_debug_member_name_%u_31 + %u;\n}\n", i, identity, identity, identity, i);
        fclose(unit);
        fprintf(start, "long function_%04u(long);\n", i);
    }
    fprintf(start, "__attribute__((noreturn)) void _start(void) { long result = 0;\n");
    for (uint32_t i = 0; i < count; i += 1)
    {
        fprintf(start, "result += function_%04u(%u);\n", i, i);
    }
    fprintf(start, "__asm__ volatile(\"syscall\" : : \"a\"(1L), \"D\"(1L), \"S\"(&result), \"d\"(8L) : \"rcx\", \"r11\", \"memory\");\n__asm__ volatile(\"syscall\" : : \"a\"(60L), \"D\"(0L) : \"rcx\", \"r11\", \"memory\");\n__builtin_unreachable(); }\n");
    fclose(start);
    return true;
}

typedef struct Input Input;
struct Input
{
    ForeignStringInput string;
    uint32_t kind;
};

static int compare_strings(const void* a, const void* b)
{
    return strcmp(*(const char* const*)a, *(const char* const*)b);
}

// Independent strcmp/sort model and boundary/interior mapped suffixes, outside timing.
static bool validate(const ForeignStringInput* inputs, uint32_t count, const ForeignStrings* pool)
{
    const char** rows = calloc((uint64_t)pool->count + 1, sizeof(*rows));
    bool valid = rows != 0;
    uint32_t strings = 0;
    uint64_t unique_bytes = 0;
    uint64_t unique_count = 0;
    for (uint32_t i = 0; valid && i < count; i += 1)
    {
        uint32_t begin = 0;
        while (valid && begin < inputs[i].size)
        {
            const uint8_t* zero = memchr(inputs[i].bytes + begin, 0, inputs[i].size - begin);
            valid = zero != 0 && strings < pool->count;
            if (valid)
            {
                rows[strings++] = (const char*)inputs[i].bytes + begin;
                const uint32_t end = (uint32_t)(zero - inputs[i].bytes) + 1;
                // Check boundaries and an interior byte of every complete string.
                const uint32_t offsets[3] = { begin, begin + (end - begin) / 2, end - 1 };
                for (uint32_t j = 0; valid && j < 3; j += 1)
                {
                    uint32_t mapped = 0;
                    valid = foreign_strings_offset(pool, i, offsets[j], &mapped) && mapped < pool->size &&
                            end - offsets[j] <= pool->size - mapped && memcmp(inputs[i].bytes + offsets[j], pool->bytes + mapped, end - offsets[j]) == 0;
                }
                begin = end;
            }
        }
    }
    if (valid)
    {
        qsort(rows, strings, sizeof(*rows), compare_strings);
        for (uint32_t i = 0; i < strings; i += 1)
        {
            if (i == 0 || strcmp(rows[i - 1], rows[i]) != 0)
            {
                unique_count += 1;
                unique_bytes += strlen(rows[i]) + 1;
            }
        }
        valid = strings == pool->count && unique_bytes == pool->size;
        printf("model\tstrings=%u\tdistinct=%llu\tdistinct_bytes=%llu\tvalid=%u\n", strings, (unsigned long long)unique_count, (unsigned long long)unique_bytes, valid);
    }
    free(rows);
    return valid;
}

static bool pool(int argc, char** argv)
{
    const uint32_t runs = (uint32_t)strtoul(argv[0], 0, 10);
    const char* prefix = argv[1];
    Arena data = arena_reserve(1ull << 34);
    Arena output = arena_reserve(1ull << 34);
    Input* all = BUSTER_ARENA_PUSH_ARRAY(&data, Input, (uint64_t)argc * 4);
    uint32_t count = 0;
    uint64_t input_bytes[2] = { 0 };
    uint64_t stored_bytes[2] = { 0 };
    uint64_t object_bytes = 0;
    uint64_t relocations = 0;
    uint64_t compressed = 0;
    bool valid = runs != 0 && data.base != 0 && output.base != 0 && all != 0;
    for (int file = 2; valid && file < argc; file += 1)
    {
        struct stat st;
        valid = stat(argv[file], &st) == 0 && st.st_size > 0;
        FILE* stream = valid ? fopen(argv[file], "rb") : 0;
        char* bytes = valid ? arena_push(&data, (uint64_t)st.st_size, 8) : 0;
        valid = stream != 0 && bytes != 0 && fread(bytes, 1, (size_t)st.st_size, stream) == (size_t)st.st_size;
        if (stream != 0)
        {
            fclose(stream);
        }
        ImportElf elf = { 0 };
        valid = valid && import_elf(&elf, (String8){ .pointer = bytes, .length = (uint64_t)st.st_size }, ET_REL).error == IMPORT_ERROR_NONE;
        object_bytes += valid ? (uint64_t)st.st_size : 0;
        for (uint32_t s = 1; valid && s < elf.section_count; s += 1)
        {
            const Elf64_Shdr section = import_section_header(&elf, s);
            const char* name = section.sh_name < elf.section_names.length ? elf.section_names.pointer + section.sh_name : "";
            const uint32_t kind = strcmp(name, ".debug_str") == 0 ? 0 : strcmp(name, ".debug_line_str") == 0 ? 1 : 2;
            if (section.sh_type == SHT_RELA && section.sh_info < elf.section_count)
            {
                const Elf64_Shdr target = import_section_header(&elf, section.sh_info);
                const char* target_name = elf.section_names.pointer + target.sh_name;
                relocations += strncmp(target_name, ".debug_", 7) == 0 ? section.sh_size / sizeof(Elf64_Rela) : 0;
            }
            if (kind < 2)
            {
                String8 content = import_section_bytes(&elf, &section);
                const bool zipped = (section.sh_flags & SHF_COMPRESSED) != 0;
                Elf64_Chdr ch = { 0 };
                if (zipped && content.length >= sizeof(ch))
                {
                    memcpy(&ch, content.pointer, sizeof(ch));
                    uint8_t* expanded = arena_push(&data, ch.ch_size, 8);
                    valid = ch.ch_type == ELFCOMPRESS_ZLIB && expanded != 0 && inflate_zlib((const uint8_t*)content.pointer + sizeof(ch), content.length - sizeof(ch), expanded, ch.ch_size) == INFLATE_ERROR_NONE;
                    content = (String8){ .pointer = (char*)expanded, .length = ch.ch_size };
                    compressed += 1;
                }
                const uint64_t alignment = zipped ? ch.ch_addralign : section.sh_addralign;
                valid = valid && count < (uint32_t)argc * 4 && content.length <= UINT32_MAX && alignment == 1 && section.sh_entsize == 1 &&
                        (section.sh_flags & (SHF_MERGE | SHF_STRINGS)) == (SHF_MERGE | SHF_STRINGS);
                if (valid)
                {
                    all[count++] = (Input){ .string = { .bytes = (const uint8_t*)content.pointer, .size = (uint32_t)content.length }, .kind = kind };
                    input_bytes[kind] += content.length;
                    stored_bytes[kind] += section.sh_size;
                }
            }
        }
    }
    if (valid)
    {
        printf("input\tobjects=%d\tobject_bytes=%llu\tstr_bytes=%llu\tline_str_bytes=%llu\tstored_str_bytes=%llu\tstored_line_str_bytes=%llu\tdebug_relocations=%llu\tcompressed_string_sections=%llu\n", argc - 2, (unsigned long long)object_bytes, (unsigned long long)input_bytes[0], (unsigned long long)input_bytes[1], (unsigned long long)stored_bytes[0], (unsigned long long)stored_bytes[1], (unsigned long long)relocations, (unsigned long long)compressed);
    }
    ForeignStringInput* inputs = BUSTER_ARENA_PUSH_ARRAY(&data, ForeignStringInput, (uint64_t)count + 1);
    valid = valid && inputs != 0;
    for (uint32_t kind = 0; valid && kind < 2; kind += 1)
    {
        uint32_t n = 0;
        for (uint32_t i = 0; i < count; i += 1)
        {
            if (all[i].kind == kind)
            {
                inputs[n++] = all[i].string;
            }
        }
        for (uint32_t run = 0; valid && run <= runs; run += 1)
        {
            for (uint32_t position = 0; valid && position < 2; position += 1)
            {
                const bool exact = ((position + run) & 1) != 0;
                const ForeignPath path = exact ? FOREIGN_PATH_EXACT : FOREIGN_PATH_VECTOR;
                ForeignStrings strings = { 0 };
                arena_pop_to(&output, 0);
                const uint64_t start = now();
                const ForeignStringsError error = foreign_strings_build(inputs, n, path, &output, &strings);
                const uint64_t stop = now();
                valid = error == FOREIGN_STRINGS_ERROR_NONE;
                if (valid && run != 0)
                {
                    printf("pool\tkind=%u\trun=%u\tpath=%s\tns=%llu\tinput=%llu\toutput=%u\tentries=%u\tretained_arena=%llu\n", kind, run, exact ? "exact" : "vector", (unsigned long long)(stop - start), (unsigned long long)input_bytes[kind], strings.size, strings.count, (unsigned long long)output.length);
                }
                if (valid && run == 0)
                {
                    valid = validate(inputs, n, &strings);
                    char path_name[4096];
                    snprintf(path_name, sizeof(path_name), "%s.%u.%s", prefix, kind, exact ? "exact" : "vector");
                    FILE* file = fopen(path_name, "wb");
                    valid = valid && file != 0;
                    if (file != 0)
                    {
                        valid = fwrite(strings.bytes, 1, strings.size, file) == strings.size && valid;
                        fclose(file);
                    }
                }
            }
        }
    }
    printf("result\tvalid=%u\n", valid);
    struct rusage usage = { 0 };
    getrusage(RUSAGE_SELF, &usage);
    printf("resources\trss_kib=%ld\tuser_us=%llu\tsystem_us=%llu\n", usage.ru_maxrss, (unsigned long long)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec, (unsigned long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec);
    arena_release(&output);
    arena_release(&data);
    return valid;
}

static bool run(char** argv)
{
    const char* log = argv[0];
    const char* label = argv[1];
    const char* iteration = argv[2];
    const uint64_t start = now();
    const pid_t pid = fork();
    if (pid == 0)
    {
        const int fd = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        const int sink = open("/dev/null", O_WRONLY);
        if (fd >= 0 && sink >= 0)
        {
            dup2(fd, STDERR_FILENO);
            dup2(sink, STDOUT_FILENO);
            close(fd);
            close(sink);
            execvp(argv[3], argv + 3);
        }
        _exit(127);
    }
    int status = 0;
    struct rusage usage = { 0 };
    const bool waited = pid > 0 && wait4(pid, &status, 0, &usage) == pid;
    const uint64_t stop = now();
    const bool valid = waited && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    printf("process\tlabel=%s\trun=%s\twall_ns=%llu\tuser_us=%llu\tsystem_us=%llu\trss_kib=%ld\tvalid=%u\n", label, iteration, (unsigned long long)(stop - start), (unsigned long long)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec, (unsigned long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec, usage.ru_maxrss, valid);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = false;
    if (argc == 5 && strcmp(argv[1], "generate") == 0)
    {
        valid = generate(argv[2], (uint32_t)strtoul(argv[3], 0, 10), strcmp(argv[4], "unique") == 0);
    }
    else if (argc >= 5 && strcmp(argv[1], "pool") == 0)
    {
        valid = pool(argc - 2, argv + 2);
    }
    else if (argc >= 7 && strcmp(argv[1], "run") == 0)
    {
        valid = run(argv + 2);
    }
    else
    {
        fprintf(stderr, "usage: dwarf607 generate DIR COUNT duplicate|unique\n       dwarf607 pool RUNS PREFIX OBJECT...\n       dwarf607 run STDERR LABEL ROUND COMMAND ARG...\n");
    }
    return valid ? 0 : 1;
}
