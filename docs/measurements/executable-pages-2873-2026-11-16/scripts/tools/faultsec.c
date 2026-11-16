// faultsec EXECUTABLE < ADDRESSES: counts the fault addresses on standard input (one hexadecimal address a line, perf
// script -F addr) by the section of EXECUTABLE (a static, non-PIE ELF64) that holds each: faults, the 64 KB windows and
// the 2 MB ranges they fall in. Addresses in no allocated section are counted by kind: the stack and the mappings near it
// (above 0x7f0000000000), and the rest (the arenas, the heap).
#include <elf.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct Section Section;
struct Section
{
    const char* name;
    uint64_t address;
    uint64_t size;
    uint64_t faults;
    uint64_t windows;
    uint64_t ranges;
    uint64_t last_window;
    uint64_t last_range;
};

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    int status = 1;
    const int file = argc == 2 ? open(argv[1], O_RDONLY | O_CLOEXEC) : -1;
    struct stat info;
    const uint8_t* image = file >= 0 && fstat(file, &info) == 0 ? mmap(0, (size_t)info.st_size, PROT_READ, MAP_PRIVATE, file, 0) : MAP_FAILED;
    if (image != MAP_FAILED)
    {
        const Elf64_Ehdr* header = (const Elf64_Ehdr*)image;
        const Elf64_Shdr* headers = (const Elf64_Shdr*)(image + header->e_shoff);
        const char* names = (const char*)(image + headers[header->e_shstrndx].sh_offset);
        Section* sections = calloc(header->e_shnum + 2u, sizeof(Section));
        uint32_t count = 0;
        for (uint32_t i = 0; i < header->e_shnum; i += 1)
        {
            if ((headers[i].sh_flags & SHF_ALLOC) != 0 && headers[i].sh_size != 0 && (headers[i].sh_flags & SHF_TLS) == 0)
            {
                sections[count] = (Section){ .name = names + headers[i].sh_name, .address = headers[i].sh_addr, .size = headers[i].sh_size, .last_window = UINT64_MAX, .last_range = UINT64_MAX };
                count += 1;
            }
        }
        Section stack = { .name = "(the stack and mappings near it)", .last_window = UINT64_MAX, .last_range = UINT64_MAX };
        Section other = { .name = "(other: the arenas, the heap)", .last_window = UINT64_MAX, .last_range = UINT64_MAX };
        uint64_t capacity = 1 << 16;
        uint64_t length = 0;
        uint64_t* addresses = malloc(capacity * sizeof(uint64_t));
        char line[256];
        while (fgets(line, sizeof(line), stdin) != 0)
        {
            char* end = 0;
            const uint64_t address = strtoull(line, &end, 16);
            if (end != line)
            {
                if (length == capacity)
                {
                    capacity *= 2;
                    addresses = realloc(addresses, capacity * sizeof(uint64_t));
                }
                addresses[length] = address;
                length += 1;
            }
        }
        qsort(addresses, length, sizeof(uint64_t), compare);
        for (uint64_t i = 0; i < length; i += 1)
        {
            const uint64_t address = addresses[i];
            Section* section = address >= 0x7f0000000000ull ? &stack : &other;
            for (uint32_t s = 0; s < count; s += 1)
            {
                // A section's faults reach to its last page's end: the bytes after it there are its segment's.
                const uint64_t end = (sections[s].address + sections[s].size + 4095) & ~4095ull;
                if (address >= (sections[s].address & ~4095ull) && address < end)
                {
                    section = &sections[s];
                }
            }
            section->faults += 1;
            section->windows += (address >> 16) != section->last_window;
            section->ranges += (address >> 21) != section->last_range;
            section->last_window = address >> 16;
            section->last_range = address >> 21;
        }
        printf("section\taddress\tKB\tfaults\twindows-64K\tranges-2M\n");
        sections[count] = stack;
        sections[count + 1] = other;
        uint64_t all = 0;
        for (uint32_t s = 0; s < count + 2; s += 1)
        {
            all += sections[s].faults;
            if (sections[s].faults != 0)
            {
                printf("%s\t0x%llx\t%llu\t%llu\t%llu\t%llu\n", sections[s].name, (unsigned long long)sections[s].address, (unsigned long long)(sections[s].size >> 10),
                       (unsigned long long)sections[s].faults, (unsigned long long)sections[s].windows, (unsigned long long)sections[s].ranges);
            }
        }
        printf("all\t\t\t%llu\n", (unsigned long long)all);
        status = 0;
    }
    else
    {
        fprintf(stderr, "usage: faultsec EXECUTABLE < ADDRESSES\n");
    }
    return status;
}
