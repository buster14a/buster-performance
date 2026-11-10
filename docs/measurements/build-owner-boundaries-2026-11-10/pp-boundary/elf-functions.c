#include <assert.h>
#include <elf.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Object
{
    unsigned char* bytes;
    size_t size;
    const Elf64_Shdr* sections;
    const Elf64_Sym* symbols;
    const char* names;
    size_t count;
} Object;

static Object object_read(const char* path)
{
    FILE* file = fopen(path, "rb");
    assert(file);
    assert(fseek(file, 0, SEEK_END) == 0);
    long length = ftell(file);
    assert(length >= (long)sizeof(Elf64_Ehdr));
    rewind(file);
    Object object = { .bytes = malloc((size_t)length), .size = (size_t)length };
    assert(object.bytes && fread(object.bytes, 1, object.size, file) == object.size);
    fclose(file);
    const Elf64_Ehdr* header = (const Elf64_Ehdr*)object.bytes;
    assert(!memcmp(header->e_ident, ELFMAG, SELFMAG) && header->e_ident[EI_CLASS] == ELFCLASS64 && header->e_machine == EM_X86_64);
    assert(header->e_shoff + (uint64_t)header->e_shnum * header->e_shentsize <= object.size && header->e_shentsize == sizeof(Elf64_Shdr));
    object.sections = (const Elf64_Shdr*)(object.bytes + header->e_shoff);
    for (size_t i = 0; i < header->e_shnum; i++)
    {
        const Elf64_Shdr* section = &object.sections[i];
        if (section->sh_type == SHT_SYMTAB)
        {
            assert(section->sh_entsize == sizeof(Elf64_Sym) && section->sh_offset + section->sh_size <= object.size && section->sh_link < header->e_shnum);
            object.symbols = (const Elf64_Sym*)(object.bytes + section->sh_offset);
            object.count = section->sh_size / sizeof(Elf64_Sym);
            const Elf64_Shdr* strings = &object.sections[section->sh_link];
            assert(strings->sh_offset + strings->sh_size <= object.size);
            object.names = (const char*)(object.bytes + strings->sh_offset);
        }
    }
    assert(object.symbols && object.names);
    return object;
}

static const void* function_bytes(const Object* object, const Elf64_Sym* symbol)
{
    const Elf64_Shdr* section = &object->sections[symbol->st_shndx];
    assert(section->sh_offset + symbol->st_value + symbol->st_size <= object->size);
    return object->bytes + section->sh_offset + symbol->st_value;
}

int main(int argc, char** argv)
{
    assert(argc == 3);
    Object base = object_read(argv[1]), candidate = object_read(argv[2]);
    size_t total = 0, equal = 0, changed = 0, resized = 0, missing = 0, added = 0;
    puts("name\tbase_size\tcandidate_size\tbytes_equal\tbase_offset\tcandidate_offset");
    for (size_t i = 0; i < base.count; i++)
    {
        const Elf64_Sym* before = &base.symbols[i];
        if (ELF64_ST_TYPE(before->st_info) != STT_FUNC || !before->st_size || before->st_shndx == SHN_UNDEF) continue;
        total++;
        const char* name = base.names + before->st_name;
        const Elf64_Sym* after = 0;
        for (size_t j = 0; j < candidate.count; j++)
        {
            const Elf64_Sym* current = &candidate.symbols[j];
            if (ELF64_ST_TYPE(current->st_info) == STT_FUNC && !strcmp(name, candidate.names + current->st_name)) { assert(!after); after = current; }
        }
        bool same_size = after && before->st_size == after->st_size;
        bool same_bytes = same_size && !memcmp(function_bytes(&base, before), function_bytes(&candidate, after), before->st_size);
        equal += same_bytes;
        changed += after && !same_bytes;
        resized += after && !same_size;
        missing += !after;
        printf("%s\t%llu\t%llu\t%s\t%llu\t%llu\n", name, (unsigned long long)before->st_size, after ? (unsigned long long)after->st_size : 0,
               same_bytes ? "yes" : "NO", (unsigned long long)before->st_value, after ? (unsigned long long)after->st_value : 0);
    }
    for (size_t j = 0; j < candidate.count; j++)
    {
        const Elf64_Sym* after = &candidate.symbols[j];
        if (ELF64_ST_TYPE(after->st_info) != STT_FUNC || !after->st_size || after->st_shndx == SHN_UNDEF) continue;
        bool found = false;
        for (size_t i = 0; i < base.count; i++) found |= ELF64_ST_TYPE(base.symbols[i].st_info) == STT_FUNC && !strcmp(candidate.names + after->st_name, base.names + base.symbols[i].st_name);
        if (!found) { fprintf(stderr, "added: %s\n", candidate.names + after->st_name); added++; }
    }
    fprintf(stderr, "functions=%zu bytes_equal=%zu changed=%zu resized=%zu missing=%zu added=%zu\n", total, equal, changed, resized, missing, added);
    free(base.bytes);
    free(candidate.bytes);
    return missing || added ? 1 : 0;
}
