// Original ELF64 audit: compare all allocated section metadata/bytes and report every nonallocated difference.
#include <elf.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct Image Image;
struct Image { const uint8_t* bytes; size_t size; Elf64_Ehdr header; Elf64_Shdr names; };
static bool range(uint64_t at, uint64_t count, uint64_t size) { return at <= size && count <= size - at; }
static Elf64_Shdr section(const Image* image, unsigned index)
{
    Elf64_Shdr result;
    memcpy(&result, image->bytes + image->header.e_shoff + (uint64_t)index * sizeof(result), sizeof(result));
    return result;
}
static const char* name(const Image* image, Elf64_Shdr entry)
{
    return (const char*)image->bytes + image->names.sh_offset + entry.sh_name;
}
static bool open_image(const char* path, Image* image)
{
    const int fd = open(path, O_RDONLY);
    struct stat metadata;
    if (fd < 0) return false;
    const bool valid = fstat(fd, &metadata) == 0 && metadata.st_size >= (off_t)sizeof(Elf64_Ehdr);
    if (!valid) { close(fd); return false; }
    image->size = (size_t)metadata.st_size;
    image->bytes = mmap(NULL, image->size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);
    if (image->bytes == MAP_FAILED) { image->bytes = NULL; return false; }
    memcpy(&image->header, image->bytes, sizeof(image->header));
    const Elf64_Ehdr* h = &image->header;
    if (memcmp(h->e_ident, ELFMAG, SELFMAG) != 0 || h->e_ident[EI_CLASS] != ELFCLASS64 || h->e_ident[EI_DATA] != ELFDATA2LSB ||
        h->e_machine != EM_X86_64 || h->e_type != ET_EXEC || h->e_ehsize != sizeof(*h) ||
        h->e_shentsize != sizeof(Elf64_Shdr) || h->e_shnum == 0 || h->e_shstrndx >= h->e_shnum ||
        !range(h->e_shoff, (uint64_t)h->e_shnum * sizeof(Elf64_Shdr), image->size) || h->e_phentsize != sizeof(Elf64_Phdr) ||
        !range(h->e_phoff, (uint64_t)h->e_phnum * sizeof(Elf64_Phdr), image->size)) return false;
    image->names = section(image, h->e_shstrndx);
    if (image->names.sh_type != SHT_STRTAB || !range(image->names.sh_offset, image->names.sh_size, image->size)) return false;
    for (unsigned index = 0; index < h->e_shnum; index += 1)
    {
        const Elf64_Shdr entry = section(image, index);
        if (entry.sh_name >= image->names.sh_size || memchr(name(image, entry), 0, (size_t)(image->names.sh_size - entry.sh_name)) == NULL ||
            (entry.sh_type != SHT_NOBITS && !range(entry.sh_offset, entry.sh_size, image->size))) return false;
    }
    return true;
}
static bool find(const Image* image, const char* wanted, Elf64_Shdr* result)
{
    unsigned matches = 0;
    for (unsigned index = 1; index < image->header.e_shnum; index += 1)
    {
        const Elf64_Shdr entry = section(image, index);
        if (strcmp(name(image, entry), wanted) == 0) { *result = entry; matches += 1; }
    }
    return matches == 1;
}
int main(int argc, char** argv)
{
    Image images[2] = { 0 };
    const bool debug_only = argc == 4 && strcmp(argv[3], "--debug-only") == 0;
    bool valid = (argc == 3 || debug_only) && open_image(argv[1], &images[0]) && open_image(argv[2], &images[1]);
    valid = valid && images[0].header.e_phnum == images[1].header.e_phnum && images[0].header.e_shnum == images[1].header.e_shnum &&
            images[0].header.e_entry == images[1].header.e_entry &&
            memcmp(images[0].bytes + images[0].header.e_phoff, images[1].bytes + images[1].header.e_phoff,
                   (size_t)images[0].header.e_phnum * sizeof(Elf64_Phdr)) == 0;
    bool allocated_equal = valid, nonallocated_allowed = true;
    unsigned allocated = 0, nonallocated_differences = 0;
    for (unsigned index = 1; valid && index < images[0].header.e_shnum; index += 1)
    {
        const Elf64_Shdr a = section(&images[0], index);
        const char* title = name(&images[0], a);
        Elf64_Shdr b;
        valid = find(&images[1], title, &b);
        if (!valid) break;
        const bool metadata_equal = a.sh_type == b.sh_type && a.sh_flags == b.sh_flags && a.sh_addr == b.sh_addr &&
            a.sh_offset == b.sh_offset && a.sh_size == b.sh_size && a.sh_link == b.sh_link && a.sh_info == b.sh_info &&
            a.sh_addralign == b.sh_addralign && a.sh_entsize == b.sh_entsize;
        const bool bytes_equal = a.sh_type == b.sh_type && a.sh_size == b.sh_size &&
            (a.sh_type == SHT_NOBITS || memcmp(images[0].bytes + a.sh_offset, images[1].bytes + b.sh_offset, (size_t)a.sh_size) == 0);
        if ((a.sh_flags | b.sh_flags) & SHF_ALLOC)
        {
            allocated += 1;
            allocated_equal &= metadata_equal && bytes_equal;
            printf("ALLOC %s metadata_equal=%u bytes_equal=%u size=%llu\n", title, metadata_equal, bytes_equal, (unsigned long long)a.sh_size);
            if (!bytes_equal && a.sh_size == b.sh_size && a.sh_type != SHT_NOBITS && b.sh_type != SHT_NOBITS)
            {
                uint64_t differences = 0;
                for (uint64_t at = 0; at < a.sh_size; at += 1)
                {
                    if (images[0].bytes[a.sh_offset + at] == images[1].bytes[b.sh_offset + at]) continue;
                    if (differences < 8) printf("  offset=0x%llx vaddr=0x%llx old=%02x new=%02x\n",
                        (unsigned long long)(a.sh_offset + at), (unsigned long long)(a.sh_addr + at),
                        images[0].bytes[a.sh_offset + at], images[1].bytes[b.sh_offset + at]);
                    differences += 1;
                }
                printf("  section_differing_bytes=%llu\n", (unsigned long long)differences);
            }
        }
        else if (!metadata_equal || !bytes_equal)
        {
            nonallocated_differences += 1;
            const bool debug = strcmp(title, ".debug_info") == 0 || strcmp(title, ".debug_line") == 0;
            const bool stable = a.sh_type == b.sh_type && a.sh_flags == b.sh_flags && a.sh_addr == b.sh_addr &&
                a.sh_link == b.sh_link && a.sh_info == b.sh_info && a.sh_addralign == b.sh_addralign && a.sh_entsize == b.sh_entsize;
            nonallocated_allowed &= stable && (debug || bytes_equal);
            printf("NONALLOC %s metadata_equal=%u bytes_equal=%u size_old=%llu size_new=%llu\n", title, metadata_equal,
                   bytes_equal, (unsigned long long)a.sh_size, (unsigned long long)b.sh_size);
        }
    }
    valid &= allocated_equal && (!debug_only || nonallocated_allowed);
    printf("ELF allocated equality: valid=%u allocated_sections=%u nonallocated_differences=%u debug_only_checked=%u\n", valid, allocated, nonallocated_differences, debug_only);
    for (unsigned index = 0; index < 2; index += 1) if (images[index].bytes != NULL) munmap((void*)images[index].bytes, images[index].size);
    return !valid;
}
