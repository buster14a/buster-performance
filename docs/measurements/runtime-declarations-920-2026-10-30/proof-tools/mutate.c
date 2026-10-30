// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Test-only mutations of a retained ELF input. No compiler output is executed.
#include <elf.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int same_name(const char* strings, uint64_t length, uint32_t a, uint32_t b)
{
    int equal = 0;
    if (a < length && b < length && memchr(strings + a, 0, (size_t)(length - a)) && memchr(strings + b, 0, (size_t)(length - b)))
    {
        equal = strcmp(strings + a, strings + b) == 0;
    }
    return equal;
}

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 5)
    {
        FILE* input = fopen(argv[1], "rb");
        if (input && fseek(input, 0, SEEK_END) == 0)
        {
            const long length = ftell(input);
            rewind(input);
            unsigned char* bytes = length > 0 ? malloc((size_t)length) : 0;
            if (bytes && fread(bytes, 1, (size_t)length, input) == (size_t)length && (size_t)length >= sizeof(Elf64_Ehdr))
            {
                Elf64_Ehdr* header = (Elf64_Ehdr*)bytes;
                if (memcmp(header->e_ident, ELFMAG, SELFMAG) == 0 && header->e_ident[EI_CLASS] == ELFCLASS64 &&
                    header->e_shentsize == sizeof(Elf64_Shdr) && header->e_shoff <= (size_t)length &&
                    header->e_shnum <= ((size_t)length - header->e_shoff) / sizeof(Elf64_Shdr))
                {
                    Elf64_Shdr* sections = (Elf64_Shdr*)(bytes + header->e_shoff);
                    unsigned changed = 0;
                    for (uint32_t i = 0; i < header->e_shnum && !changed; i += 1)
                    {
                        Elf64_Shdr* section = sections + i;
                        if (section->sh_offset > (size_t)length || section->sh_size > (size_t)length - section->sh_offset)
                        {
                            break;
                        }
                        if (strcmp(argv[3], "site") == 0 && section->sh_type == SHT_PROGBITS)
                        {
                            const uint64_t site = strtoull(argv[4], 0, 0);
                            if (site >= section->sh_addr && site - section->sh_addr <= section->sh_size &&
                                4 <= section->sh_size - (site - section->sh_addr))
                            {
                                unsigned char* field = bytes + section->sh_offset + site - section->sh_addr;
                                int32_t value;
                                memcpy(&value, field, sizeof(value));
                                value += 4;
                                memcpy(field, &value, sizeof(value));
                                changed = 1;
                            }
                        }
                        if (strcmp(argv[3], "addend") == 0 && section->sh_type == SHT_RELA &&
                            section->sh_entsize == sizeof(Elf64_Rela) && section->sh_link < header->e_shnum)
                        {
                            Elf64_Shdr* table = sections + section->sh_link;
                            if (table->sh_offset <= (size_t)length && table->sh_size <= (size_t)length - table->sh_offset &&
                                table->sh_entsize == sizeof(Elf64_Sym))
                            {
                                Elf64_Sym* symbols = (Elf64_Sym*)(bytes + table->sh_offset);
                                Elf64_Rela* relocs = (Elf64_Rela*)(bytes + section->sh_offset);
                                for (uint64_t j = 0; j < section->sh_size / sizeof(Elf64_Rela) && !changed; j += 1)
                                {
                                    const uint64_t symbol = ELF64_R_SYM(relocs[j].r_info);
                                    if (symbol < table->sh_size / sizeof(Elf64_Sym) && ELF64_R_TYPE(relocs[j].r_info) == R_X86_64_PLT32 &&
                                        ELF64_ST_TYPE(symbols[symbol].st_info) == STT_SECTION && ELF64_ST_BIND(symbols[symbol].st_info) == STB_LOCAL &&
                                        symbols[symbol].st_shndx == 4)
                                    {
                                        relocs[j].r_addend += strtoll(argv[4], 0, 0);
                                        changed = 1;
                                    }
                                }
                            }
                        }
                    }
                    if (!changed && (strcmp(argv[3], "symbol") == 0 || strcmp(argv[3], "duplicate") == 0))
                    {
                        const uint64_t address = strtoull(argv[4], 0, 0);
                        for (uint32_t i = 0; i < header->e_shnum && !changed; i += 1)
                        {
                            Elf64_Shdr* section = sections + i;
                            if (section->sh_type == SHT_SYMTAB && section->sh_entsize == sizeof(Elf64_Sym) &&
                                section->sh_offset <= (size_t)length && section->sh_size <= (size_t)length - section->sh_offset &&
                                section->sh_link < header->e_shnum)
                            {
                                const Elf64_Shdr* names = sections + section->sh_link;
                                if (names->sh_type != SHT_STRTAB || names->sh_offset > (size_t)length || names->sh_size > (size_t)length - names->sh_offset)
                                {
                                    break;
                                }
                                const char* strings = (const char*)bytes + names->sh_offset;
                                Elf64_Sym* symbols = (Elf64_Sym*)(bytes + section->sh_offset);
                                const uint64_t count = section->sh_size / sizeof(Elf64_Sym);
                                for (uint64_t j = 0; j < count && !changed; j += 1)
                                {
                                    if (ELF64_ST_TYPE(symbols[j].st_info) == STT_FUNC && symbols[j].st_value == address)
                                    {
                                        if (strcmp(argv[3], "symbol") == 0)
                                        {
                                            symbols[j].st_value += 16;
                                            changed = 1;
                                        }
                                        else
                                        {
                                            for (uint64_t k = 0; k < count && !changed; k += 1)
                                            {
                                                if (same_name(strings, names->sh_size, symbols[k].st_name, symbols[j].st_name) && symbols[k].st_info == symbols[j].st_info &&
                                                    symbols[k].st_other == symbols[j].st_other && symbols[k].st_size == symbols[j].st_size &&
                                                    symbols[k].st_value != address)
                                                {
                                                    symbols[k].st_value = address;
                                                    symbols[k].st_shndx = symbols[j].st_shndx;
                                                    changed = 1;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (!changed && strcmp(argv[3], "null") == 0)
                    {
                        const unsigned mode = (unsigned)strtoul(argv[4], 0, 0);
                        if (mode == 1)
                        {
                            sections[0].sh_addr += 4096;
                            changed = 1;
                        }
                        if (mode == 2)
                        {
                            sections[0].sh_link = 1;
                            changed = 1;
                        }
                        if (mode == 3)
                        {
                            sections[0].sh_flags = SHF_ALLOC;
                            sections[0].sh_addr = 0x400000;
                            changed = 1;
                        }
                    }
                    if (changed)
                    {
                        FILE* output = fopen(argv[2], "wb");
                        if (output)
                        {
                            status = fwrite(bytes, 1, (size_t)length, output) != (size_t)length;
                            status |= fclose(output) != 0;
                        }
                    }
                }
            }
            free(bytes);
        }
        if (input)
        {
            fclose(input);
        }
    }
    return status;
}
