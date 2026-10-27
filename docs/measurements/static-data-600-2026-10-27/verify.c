// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent ELF data/relocation oracle for original #600 fixtures.
#include <elf.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

static bool span(uint64_t offset, uint64_t length, uint64_t size)
{
    return offset <= size && length <= size - offset;
}

int main(int argc, char** argv)
{
    bool valid = argc == 5;
    const char* mode = valid ? argv[1] : "";
    const uint64_t size = valid ? strtoull(argv[2], 0, 10) : 0;
    const uint64_t count = valid ? strtoull(argv[3], 0, 10) : 0;
    const int file = valid ? open(argv[4], O_RDONLY) : -1;
    struct stat status = { 0 };
    valid = valid && file != -1 && fstat(file, &status) == 0 && status.st_size >= (off_t)sizeof(Elf64_Ehdr);
    uint8_t* bytes = valid ? mmap(0, (size_t)status.st_size, PROT_READ, MAP_PRIVATE, file, 0) : MAP_FAILED;
    valid = valid && bytes != MAP_FAILED;
    uint64_t checked = 0;
    uint64_t references = 0;
    const bool literal = strcmp(mode, "literal") == 0;
    const bool relocation = strcmp(mode, "relocation") == 0;
    const bool readonly = strcmp(mode, "readonly") == 0;
    if (valid)
    {
        const Elf64_Ehdr* header = (const Elf64_Ehdr*)bytes;
        valid = memcmp(header->e_ident, ELFMAG, SELFMAG) == 0 && header->e_ident[EI_CLASS] == ELFCLASS64 &&
                header->e_ident[EI_DATA] == ELFDATA2LSB && header->e_machine == EM_X86_64 && header->e_type == ET_REL &&
                header->e_shentsize == sizeof(Elf64_Shdr) && header->e_shnum != 0 && header->e_shstrndx < header->e_shnum &&
                span(header->e_shoff, (uint64_t)header->e_shnum * sizeof(Elf64_Shdr), (uint64_t)status.st_size);
        const Elf64_Shdr* sections = valid ? (const Elf64_Shdr*)(bytes + header->e_shoff) : 0;
        for (uint32_t section = 0; valid && section < header->e_shnum; section += 1)
        {
            const Elf64_Shdr* s = sections + section;
            valid = s->sh_type == SHT_NOBITS || span(s->sh_offset, s->sh_size, (uint64_t)status.st_size);
            if (valid && literal && s->sh_type == SHT_PROGBITS && (s->sh_flags & SHF_ALLOC) != 0 &&
                (s->sh_flags & (SHF_WRITE | SHF_EXECINSTR)) == 0 && s->sh_size == size)
            {
                bool exact = true;
                for (uint64_t byte = 0; exact && byte < size; byte += 1)
                {
                    exact = bytes[s->sh_offset + byte] == (byte + 1 == size ? 0 : 'x');
                }
                checked += exact;
            }
            if (valid && !literal && s->sh_type == SHT_SYMTAB)
            {
                valid = s->sh_link < header->e_shnum && s->sh_entsize == sizeof(Elf64_Sym) && s->sh_size % sizeof(Elf64_Sym) == 0;
                const Elf64_Sym* symbols = (const Elf64_Sym*)(bytes + s->sh_offset);
                const Elf64_Shdr* strings = valid ? sections + s->sh_link : 0;
                valid = valid && span(strings->sh_offset, strings->sh_size, (uint64_t)status.st_size);
                for (uint64_t symbol = 1; valid && symbol < s->sh_size / sizeof(Elf64_Sym); symbol += 1)
                {
                    const Elf64_Sym* entry = symbols + symbol;
                    const char* name = entry->st_name < strings->sh_size ? (const char*)bytes + strings->sh_offset + entry->st_name : 0;
                    valid = name != 0 && memchr(name, 0, strings->sh_size - entry->st_name) != 0;
                    if (valid && strncmp(name, "object_", 7) == 0)
                    {
                        valid = entry->st_size == size && entry->st_shndx < header->e_shnum && ELF64_ST_TYPE(entry->st_info) == STT_OBJECT;
                        const Elf64_Shdr* data = valid ? sections + entry->st_shndx : 0;
                        valid = valid && data->sh_type == SHT_PROGBITS && (data->sh_flags & SHF_ALLOC) != 0 &&
                                ((data->sh_flags & SHF_WRITE) == 0) == readonly && span(entry->st_value, size, data->sh_size) &&
                                span(data->sh_offset, data->sh_size, (uint64_t)status.st_size);
                        for (uint64_t byte = 0; valid && byte < size; byte += 1)
                        {
                            valid = bytes[data->sh_offset + entry->st_value + byte] == (!relocation && byte == 0 ? 1 : 0);
                        }
                        checked += valid;
                    }
                }
            }
            if (valid && !literal && s->sh_type == SHT_RELA)
            {
                valid = s->sh_entsize == sizeof(Elf64_Rela) && s->sh_size % sizeof(Elf64_Rela) == 0 &&
                        s->sh_link < header->e_shnum && s->sh_info < header->e_shnum;
                const Elf64_Shdr* table = valid ? sections + s->sh_link : 0;
                valid = valid && table->sh_link < header->e_shnum && span(table->sh_offset, table->sh_size, (uint64_t)status.st_size);
                const Elf64_Shdr* strings = valid ? sections + table->sh_link : 0;
                valid = valid && span(strings->sh_offset, strings->sh_size, (uint64_t)status.st_size);
                const Elf64_Rela* relas = (const Elf64_Rela*)(bytes + s->sh_offset);
                const Elf64_Sym* symbols = valid ? (const Elf64_Sym*)(bytes + table->sh_offset) : 0;
                for (uint64_t i = 0; valid && i < s->sh_size / sizeof(Elf64_Rela); i += 1)
                {
                    const uint64_t symbol = ELF64_R_SYM(relas[i].r_info);
                    valid = relocation && symbol < table->sh_size / sizeof(Elf64_Sym) &&
                            ELF64_R_TYPE(relas[i].r_info) == R_X86_64_64 && relas[i].r_addend == 0 &&
                            relas[i].r_offset % size == 0 && relas[i].r_offset / size < count;
                    const uint64_t name = valid ? symbols[symbol].st_name : 0;
                    valid = valid && name < strings->sh_size && strings->sh_size - name >= 7 &&
                            memcmp(bytes + strings->sh_offset + name, "target", 7) == 0;
                    references += valid;
                }
            }
        }
    }
    valid = valid && checked == count && (literal || references == (relocation ? count : 0));
    printf("VERIFY\t%s\t%llu\t%llu\t%s\t%s\n", mode, (unsigned long long)size, (unsigned long long)count,
           valid ? "PASS" : "FAIL", argc == 5 ? argv[4] : "");
    if (bytes != MAP_FAILED)
    {
        munmap(bytes, (size_t)status.st_size);
    }
    if (file != -1)
    {
        close(file);
    }
    return valid ? 0 : 1;
}
