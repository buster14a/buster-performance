// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent ELF consumer for the synthetic relocation expressions in offsets.sh.
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <elf.h>
int main(int argc, char** argv)
{
    bool valid = argc == 2;
    FILE* file = valid ? fopen(argv[1], "rb") : 0;
    valid = valid && file != 0 && fseek(file, 0, SEEK_END) == 0;
    const long size = valid ? ftell(file) : 0;
    uint8_t* bytes = valid && size > 0 ? malloc((size_t)size) : 0;
    valid = valid && bytes != 0 && fseek(file, 0, SEEK_SET) == 0 && fread(bytes, 1, (size_t)size, file) == (size_t)size;
    if (file != 0)
    {
        fclose(file);
    }
    Elf64_Ehdr elf = { 0 };
    if (valid && size >= (long)sizeof(elf))
    {
        memcpy(&elf, bytes, sizeof(elf));
    }
    valid = valid && elf.e_shoff < (uint64_t)size && (uint64_t)elf.e_shnum * sizeof(Elf64_Shdr) <= (uint64_t)size - elf.e_shoff && elf.e_shstrndx < elf.e_shnum;
    const Elf64_Shdr* sections = valid ? (const Elf64_Shdr*)(bytes + elf.e_shoff) : 0;
    const char* names = valid ? (const char*)bytes + sections[elf.e_shstrndx].sh_offset : 0;
    const Elf64_Shdr* info = 0;
    const Elf64_Shdr* strings = 0;
    for (uint32_t i = 0; valid && i < elf.e_shnum; i += 1)
    {
        valid = sections[i].sh_type == SHT_NOBITS || (sections[i].sh_offset <= (uint64_t)size && sections[i].sh_size <= (uint64_t)size - sections[i].sh_offset);
        if (strcmp(names + sections[i].sh_name, ".debug_info") == 0)
        {
            info = &sections[i];
        }
        if (strcmp(names + sections[i].sh_name, ".debug_str") == 0)
        {
            strings = &sections[i];
        }
    }
    valid = valid && info != 0 && strings != 0 && info->sh_size == 40;
    const char* expected[3] = { "suffix", "uffix", "duplicate_shared_string" };
    for (uint32_t object = 0; valid && object < 2; object += 1)
    {
        const uint32_t fields[3] = { 0, 4, 12 };
        for (uint32_t i = 0; valid && i < 3; i += 1)
        {
            uint64_t offset = 0;
            memcpy(&offset, bytes + info->sh_offset + 20 * object + fields[i], i == 0 ? 4 : 8);
            const uint64_t length = strlen(expected[i]) + 1;
            valid = offset < strings->sh_size && length <= strings->sh_size - offset && memcmp(bytes + strings->sh_offset + offset, expected[i], length) == 0;
        }
    }
    printf("offsets: %s, six 32/64-bit references, interior and negative cross-entry addends\n", valid ? "PASS" : "FAIL");
    free(bytes);
    return valid ? 0 : 1;
}
