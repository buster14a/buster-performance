// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// object_functions FILE.o: every function symbol of a relocatable x86-64 ELF object, one a line, tab-separated: its
// name, its section's name, its size and a hash of its code: its bytes, and each relocation in its range (its offset
// within the function, its type, its addend, and the name of the symbol it refers to, or for a section symbol the
// section's name). Two builds of a unit give a function the same line when its machine code is the same wherever the
// function and what it refers to were placed, which is how buster#2040's record counts the functions a lever changes.
// A relocation against a section (clang's assembler refers so to local functions and data) or against a numbered local
// label hashes as what it reaches: the function or the object that holds the address, by name, and the offset inside
// it; where no symbol holds it (a string, a constant pool entry, a private table), the section's name alone. So a
// function's line doesn't change because something before its callee or its constant grew; nor, which is this
// comparison's blind spot, when it refers to another unnamed constant of the same section with the same instruction.
#include <elf.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

static uint64_t mix(uint64_t hash, const void* data, uint64_t length)
{
    const uint8_t* bytes = data;
    for (uint64_t i = 0; i < length; i += 1)
    {
        hash = (hash ^ bytes[i]) * UINT64_C(0x100000001b3);
    }
    return hash;
}

typedef struct Relocation
{
    uint64_t offset;
    uint64_t info;
    int64_t addend;
} Relocation;

typedef struct Range
{
    uint64_t start;
    uint64_t end;
    uint32_t section;
    uint32_t name;
} Range;

static int compare_ranges(const void* a, const void* b)
{
    const Range* left = a;
    const Range* right = b;
    return left->section != right->section ? (left->section < right->section ? -1 : 1) : left->start < right->start ? -1 : left->start > right->start;
}

// The function or object symbol of `section` that holds `address`, or 0.
static const Range* find_range(const Range* ranges, uint64_t count, uint32_t section, uint64_t address)
{
    uint64_t low = 0;
    uint64_t high = count;
    while (low < high)
    {
        const uint64_t middle = low + (high - low) / 2;
        const Range* range = &ranges[middle];
        if (range->section < section || (range->section == section && range->end <= address))
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    return low < count && ranges[low].section == section && ranges[low].start <= address && address < ranges[low].end ? &ranges[low] : 0;
}

static int compare_relocations(const void* a, const void* b)
{
    const Relocation* left = a;
    const Relocation* right = b;
    return left->offset < right->offset ? -1 : left->offset > right->offset;
}

int main(int argc, char** argv)
{
    int status = 1;
    struct stat information;
    const int descriptor = argc == 2 ? open(argv[1], O_RDONLY) : -1;
    if (descriptor < 0 || fstat(descriptor, &information) != 0)
    {
        fprintf(stderr, "usage: object_functions FILE.o\n");
    }
    else
    {
        const uint8_t* file = mmap(0, (size_t)information.st_size, PROT_READ, MAP_PRIVATE, descriptor, 0);
        const Elf64_Ehdr* header = (const Elf64_Ehdr*)file;
        const Elf64_Shdr* sections = (const Elf64_Shdr*)(file + header->e_shoff);
        const char* section_names = (const char*)(file + sections[header->e_shstrndx].sh_offset);
        const Elf64_Shdr* symbol_section = 0;
        for (uint32_t i = 0; i < header->e_shnum; i += 1)
        {
            if (sections[i].sh_type == SHT_SYMTAB)
            {
                symbol_section = &sections[i];
            }
        }
        if (file == MAP_FAILED || memcmp(header->e_ident, ELFMAG, SELFMAG) != 0 || header->e_type != ET_REL || symbol_section == 0)
        {
            fprintf(stderr, "object_functions: %s isn't a relocatable ELF object with a symbol table\n", argv[1]);
        }
        else
        {
            const Elf64_Sym* symbols = (const Elf64_Sym*)(file + symbol_section->sh_offset);
            const uint64_t symbol_count = symbol_section->sh_size / sizeof(Elf64_Sym);
            const char* names = (const char*)(file + sections[symbol_section->sh_link].sh_offset);
            // Each section's relocations, sorted by offset.
            Relocation** relocations = calloc(header->e_shnum, sizeof(Relocation*));
            uint64_t* relocation_counts = calloc(header->e_shnum, sizeof(uint64_t));
            for (uint32_t i = 0; i < header->e_shnum; i += 1)
            {
                if (sections[i].sh_type == SHT_RELA && sections[i].sh_info < header->e_shnum)
                {
                    const Elf64_Rela* entries = (const Elf64_Rela*)(file + sections[i].sh_offset);
                    const uint64_t count = sections[i].sh_size / sizeof(Elf64_Rela);
                    Relocation* sorted = malloc((count + 1) * sizeof(Relocation));
                    for (uint64_t r = 0; r < count; r += 1)
                    {
                        sorted[r] = (Relocation){ .offset = entries[r].r_offset, .info = entries[r].r_info, .addend = entries[r].r_addend };
                    }
                    qsort(sorted, count, sizeof(Relocation), compare_relocations);
                    relocations[sections[i].sh_info] = sorted;
                    relocation_counts[sections[i].sh_info] = count;
                }
            }
            // The named functions and objects, by section and address, without the split's aliases.
            Range* ranges = malloc((symbol_count + 1) * sizeof(Range));
            uint64_t range_count = 0;
            for (uint64_t s = 0; s < symbol_count; s += 1)
            {
                const Elf64_Sym* symbol = &symbols[s];
                const unsigned type = ELF64_ST_TYPE(symbol->st_info);
                const char* name = names + symbol->st_name;
                const size_t length = strlen(name);
                const int alias = length > 13 && strcmp(name + length - 13, ".buster_split") == 0;
                if ((type == STT_FUNC || type == STT_OBJECT) && symbol->st_size != 0 && symbol->st_shndx != SHN_UNDEF && symbol->st_shndx < header->e_shnum && !alias &&
                    strncmp(name, ".L", 2) != 0)
                {
                    ranges[range_count] = (Range){ .start = symbol->st_value, .end = symbol->st_value + symbol->st_size, .section = symbol->st_shndx, .name = symbol->st_name };
                    range_count += 1;
                }
            }
            qsort(ranges, range_count, sizeof(Range), compare_ranges);
            for (uint64_t s = 0; s < symbol_count; s += 1)
            {
                const Elf64_Sym* symbol = &symbols[s];
                if (ELF64_ST_TYPE(symbol->st_info) == STT_FUNC && symbol->st_shndx != SHN_UNDEF && symbol->st_shndx < header->e_shnum)
                {
                    const Elf64_Shdr* section = &sections[symbol->st_shndx];
                    uint64_t hash = mix(UINT64_C(0xcbf29ce484222325), file + section->sh_offset + symbol->st_value, symbol->st_size);
                    const Relocation* list = relocations[symbol->st_shndx];
                    const uint64_t count = relocation_counts[symbol->st_shndx];
                    uint64_t low = 0;
                    uint64_t high = count;
                    while (low < high)
                    {
                        const uint64_t middle = low + (high - low) / 2;
                        if (list[middle].offset < symbol->st_value)
                        {
                            low = middle + 1;
                        }
                        else
                        {
                            high = middle;
                        }
                    }
                    for (uint64_t r = low; r < count && list[r].offset < symbol->st_value + symbol->st_size; r += 1)
                    {
                        const uint64_t offset = list[r].offset - symbol->st_value;
                        const uint32_t type = (uint32_t)ELF64_R_TYPE(list[r].info);
                        const Elf64_Sym* target = &symbols[ELF64_R_SYM(list[r].info)];
                        hash = mix(hash, &offset, sizeof(offset));
                        hash = mix(hash, &type, sizeof(type));
                        const char* target_name = names + target->st_name;
                        const int numbered = ELF64_ST_TYPE(target->st_info) == STT_SECTION || target_name[0] == 0 || strncmp(target_name, ".L", 2) == 0;
                        if (numbered && target->st_shndx != SHN_UNDEF && target->st_shndx < header->e_shnum)
                        {
                            const Elf64_Shdr* target_section = &sections[target->st_shndx];
                            const char* name = section_names + target_section->sh_name;
                            const uint64_t at = target->st_value + (uint64_t)list[r].addend + (type == R_X86_64_PC32 || type == R_X86_64_PLT32 ? 4 : 0);
                            const Range* range = find_range(ranges, range_count, target->st_shndx, at);
                            const int code = (target_section->sh_flags & SHF_EXECINSTR) != 0;
                            // A PC-relative reference to data counts from the instruction's end, which an immediate
                            // operand after the displacement puts 1, 2 or 4 bytes further: the object is the one a
                            // candidate address starts, else the one that holds the plain address, and its name alone
                            // is hashed, since the offset inside it is known only up to that immediate.
                            for (uint64_t extra = 1; !code && extra <= 4; extra *= 2)
                            {
                                const Range* candidate = find_range(ranges, range_count, target->st_shndx, at + extra);
                                if (candidate != 0 && candidate->start == at + extra && (range == 0 || range->start != at))
                                {
                                    range = candidate;
                                }
                            }
                            if (range != 0)
                            {
                                const uint64_t inside = code ? at - range->start : 0;
                                hash = mix(hash, names + range->name, strlen(names + range->name));
                                hash = mix(hash, &inside, sizeof(inside));
                            }
                            else
                            {
                                hash = mix(hash, name, strlen(name));
                            }
                        }
                        else
                        {
                            hash = mix(hash, target_name, strlen(target_name));
                            hash = mix(hash, &list[r].addend, sizeof(list[r].addend));
                        }
                    }
                    printf("%s\t%s\t%llu\t%016llx\n", names + symbol->st_name, section_names + section->sh_name, (unsigned long long)symbol->st_size, (unsigned long long)hash);
                }
            }
            status = 0;
        }
    }
    return status;
}
