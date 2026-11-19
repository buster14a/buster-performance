// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Check the two passes of all-keys.s in one emitted section. The second pass visits the keys in reverse.
// Inputs are the section's objcopy dump and that section's readelf relocation rows from measure.sh.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static uint32_t u32(const uint8_t* bytes)
{
    return (uint32_t)bytes[0] | (uint32_t)bytes[1] << 8 | (uint32_t)bytes[2] << 16 | (uint32_t)bytes[3] << 24;
}

static bool record(FILE* input, uint8_t bytes[32], uint32_t* size)
{
    bool okay = fread(bytes, 1, 4, input) == 4;
    if (okay)
    {
        uint32_t length = u32(bytes);
        okay = length >= 4 && length <= 28 && fread(bytes + 4, 1, length, input) == length;
        *size = okay ? length + 4 : 0;
    }
    return okay;
}

static bool zeros(const uint8_t* bytes, uint32_t begin, uint32_t end)
{
    bool okay = begin <= end;
    for (uint32_t i = begin; okay && i < end; ++i)
    {
        okay = bytes[i] == 0;
    }
    return okay;
}

static bool cie(const uint8_t* bytes, uint32_t size, uint32_t key, bool debug)
{
    const bool signal = (key & 2) != 0;
    const char* augmentation = debug ? (signal ? "S" : "") : (signal ? "zRS" : "zR");
    const uint32_t aug_size = (uint32_t)strlen(augmentation) + 1;
    const uint32_t fields = 9 + aug_size;
    uint32_t at = fields + 3;
    bool okay = size >= at && u32(bytes + 4) == (debug ? UINT32_MAX : 0) && bytes[8] == 1 &&
                memcmp(bytes + 9, augmentation, aug_size) == 0 && bytes[fields] == 1 &&
                bytes[fields + 1] == 0x78 && bytes[fields + 2] == key / 4;
    if (okay && !debug)
    {
        okay = size >= at + 2 && bytes[at] == 1 && bytes[at + 1] == 0x1b;
        at += 2;
    }
    if (okay && (key & 1) == 0)
    {
        // DW_CFA_def_cfa rsp,8 and DW_CFA_offset rip,1, with data alignment -8.
        static const uint8_t rules[] = {0x0c, 7, 8, 0x90, 1};
        okay = size >= at + sizeof(rules) && memcmp(bytes + at, rules, sizeof(rules)) == 0;
        at += sizeof(rules);
    }
    const uint32_t alignment = debug ? 8 : 4;
    return okay && size == (at + alignment - 1) / alignment * alignment && zeros(bytes, at, size);
}

static bool relocation(FILE* input, uint32_t place, const char* type, const char* symbol, uint32_t addend)
{
    char line[256];
    char actual_type[32];
    char actual_symbol[32];
    unsigned int actual_place;
    unsigned int actual_addend;
    return fgets(line, sizeof(line), input) && sscanf(line, "%x %31s %31s + %x", &actual_place, actual_type, actual_symbol, &actual_addend) == 4 &&
           actual_place == place && !strcmp(actual_type, type) && !strcmp(actual_symbol, symbol) && actual_addend == addend;
}

static bool check(FILE* frames, FILE* relocs, bool debug)
{
    uint32_t first[1024];
    uint32_t offset = 0;
    uint32_t i = 0;
    bool okay = true;
    for (; okay && i < 2048; ++i)
    {
        const uint32_t key = i < 1024 ? i : 2047 - i;
        uint8_t bytes[32];
        uint32_t size = 0;
        if (i < 1024)
        {
            first[key] = offset;
            okay = record(frames, bytes, &size) && cie(bytes, size, key, debug);
            offset += size;
        }
        okay = okay && record(frames, bytes, &size);
        if (okay && debug)
        {
            okay = size == 24 && zeros(bytes, 4, 16) && u32(bytes + 16) == 1 && u32(bytes + 20) == 0 &&
                   relocation(relocs, offset + 4, "R_X86_64_32", ".debug_frame", first[key]) &&
                   relocation(relocs, offset + 8, "R_X86_64_64", ".text", i);
        }
        else if (okay)
        {
            const uint32_t alignment = i == 2047 ? 8 : 4;
            const uint32_t end = (offset + 17 + alignment - 1) / alignment * alignment;
            okay = offset + size == end && u32(bytes + 4) == offset + 4 - first[key] && u32(bytes + 8) == 0 &&
                   u32(bytes + 12) == 1 && zeros(bytes, 16, size) && relocation(relocs, offset + 8, "R_X86_64_PC32", ".text", i);
        }
        if (!okay)
        {
            fprintf(stderr, "%s: unexpected record or relocation for function %u, identity %u, at %#x\n", debug ? ".debug_frame" : ".eh_frame", i, key, offset);
        }
        offset += size;
    }
    return okay && fgetc(frames) == EOF && !ferror(frames) && fgetc(relocs) == EOF && !ferror(relocs);
}

int main(int argc, char** argv)
{
    bool okay = argc == 4 && (!strcmp(argv[1], "debug_frame") || !strcmp(argv[1], "eh_frame"));
    FILE* frames = okay ? fopen(argv[2], "rb") : NULL;
    FILE* relocs = okay ? fopen(argv[3], "r") : NULL;
    okay = frames && relocs && check(frames, relocs, !strcmp(argv[1], "debug_frame"));
    if (frames) fclose(frames);
    if (relocs) fclose(relocs);
    return okay ? 0 : 1;
}
