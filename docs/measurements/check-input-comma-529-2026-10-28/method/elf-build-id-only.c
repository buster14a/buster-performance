// Original strict executable comparison. The only permitted byte differences are GNU build-ID descriptor bytes.
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
struct Image { const uint8_t* bytes; size_t size; uint64_t id_offset, id_size; };
static bool range(uint64_t offset, uint64_t bytes, uint64_t size) { return offset <= size && bytes <= size - offset; }
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
    Elf64_Ehdr header;
    memcpy(&header, image->bytes, sizeof(header));
    if (memcmp(header.e_ident, ELFMAG, SELFMAG) != 0 || header.e_ident[EI_CLASS] != ELFCLASS64 ||
        header.e_ident[EI_DATA] != ELFDATA2LSB || header.e_machine != EM_X86_64 || header.e_type != ET_EXEC ||
        header.e_ehsize != sizeof(header) || header.e_shentsize != sizeof(Elf64_Shdr) || header.e_shnum == 0 ||
        header.e_shstrndx >= header.e_shnum || !range(header.e_shoff, (uint64_t)header.e_shnum * sizeof(Elf64_Shdr), image->size)) return false;
    Elf64_Shdr strings;
    memcpy(&strings, image->bytes + header.e_shoff + (uint64_t)header.e_shstrndx * sizeof(strings), sizeof(strings));
    if (strings.sh_type != SHT_STRTAB || !range(strings.sh_offset, strings.sh_size, image->size)) return false;
    unsigned found = 0;
    for (unsigned index = 0; index < header.e_shnum; index += 1)
    {
        Elf64_Shdr section;
        memcpy(&section, image->bytes + header.e_shoff + (uint64_t)index * sizeof(section), sizeof(section));
        if (section.sh_name >= strings.sh_size) return false;
        const char* name = (const char*)image->bytes + strings.sh_offset + section.sh_name;
        if (memchr(name, 0, (size_t)(strings.sh_size - section.sh_name)) == NULL) return false;
        if (strcmp(name, ".note.gnu.build-id") != 0) continue;
        if (section.sh_type != SHT_NOTE || !range(section.sh_offset, section.sh_size, image->size) || section.sh_size < sizeof(Elf64_Nhdr) + 4) return false;
        Elf64_Nhdr note;
        memcpy(&note, image->bytes + section.sh_offset, sizeof(note));
        if (note.n_namesz != 4 || note.n_type != NT_GNU_BUILD_ID || note.n_descsz == 0 || note.n_descsz > 64 ||
            memcmp(image->bytes + section.sh_offset + sizeof(note), "GNU", 4) != 0 ||
            !range(sizeof(note) + 4, note.n_descsz, section.sh_size)) return false;
        image->id_offset = section.sh_offset + sizeof(note) + 4;
        image->id_size = note.n_descsz;
        found += 1;
    }
    return found == 1;
}

int main(int argc, char** argv)
{
    Image images[2] = { 0 };
    bool valid = argc == 3 && open_image(argv[1], &images[0]) && open_image(argv[2], &images[1]);
    valid = valid && images[0].size == images[1].size && images[0].id_offset == images[1].id_offset && images[0].id_size == images[1].id_size;
    uint64_t id_differences = 0, other_differences = 0;
    for (size_t at = 0; valid && at < images[0].size; at += 1)
    {
        if (images[0].bytes[at] == images[1].bytes[at]) continue;
        if (at >= images[0].id_offset && at - images[0].id_offset < images[0].id_size) id_differences += 1;
        else
        {
            if (other_differences < 8) printf("unexpected difference at file offset %zu\n", at);
            other_differences += 1;
        }
    }
    valid = valid && other_differences == 0;
    printf("ELF build-ID-only comparison: valid=%u file_bytes=%zu build_id_offset=%llu build_id_bytes=%llu differing_id_bytes=%llu differing_other_bytes=%llu\n",
           valid, images[0].size, (unsigned long long)images[0].id_offset, (unsigned long long)images[0].id_size,
           (unsigned long long)id_differences, (unsigned long long)other_differences);
    for (unsigned index = 0; index < 2; index += 1) if (images[index].bytes != NULL) munmap((void*)images[index].bytes, images[index].size);
    return !valid;
}
