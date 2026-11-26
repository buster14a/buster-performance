// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// Original #2886 inspection helper. Runs COMMAND under ptrace, reads its executable's selected data sections from
// /proc/PID/pagemap immediately before exit_group (or exit), then lets it exit normally. This records resident pages,
// not fault addresses: file fault-around can map pages the command never read. Bit 61 is file/shared-anonymous;
// inside these private ELF mappings, clear bit 61 identifies anonymous/COW pages. Exclusive and soft-dirty are
// reported independently; neither alone proves a program write. Section boundary pages may count in two sections.
//
//   datapages [--pause] [--all-pages] [--base-pages] OUTPUT.tsv COMMAND [ARG...]
// --pause uses Buster's existing BUSTER_TEST_EXIT_HELPER_PAUSE hook instead of ptrace: an inherited notification
// descriptor closes at its exit-helper setup, then /proc/PID/syscall confirms its final nanosleep. The parent stops
// its own child with SIGSTOP, reads the census, and continues it. It is a subreaper and waits for every descendant.
// No executable bytes change. Commands that start lanes or cannot start their exit helper cannot use this mode.
// --all-pages includes nonresident pages, and zero-present symbols, too.
// --base-pages disables THP in the supervisor before fork/exec and verifies the inherited policy in the child before
// exec. This removes huge mappings created during loader startup, before Buster reads BUSTER_HUGE_PAGES. The default
// leaves that policy unchanged for captures that deliberately exercise executable huge pages.
// The child keeps its standard streams. OUTPUT is the census; the helper exits with the child's exit status (or
// 128 + signal), except a census/ptrace failure on an otherwise successful child returns 125. No children are traced.
#define _GNU_SOURCE
#include <elf.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <poll.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/ptrace.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PAGE_BYTES UINT64_C(4096)
#define PAGE_PRESENT (UINT64_C(1) << 63)
#define PAGE_SWAPPED (UINT64_C(1) << 62)
#define PAGE_FILE (UINT64_C(1) << 61)
#define PAGE_EXCLUSIVE (UINT64_C(1) << 56)
#define PAGE_DIRTY (UINT64_C(1) << 55)

static bool all_pages;

typedef struct Image Image;
struct Image
{
    uint8_t* bytes;
    size_t size;
    const Elf64_Ehdr* header;
    const Elf64_Shdr* sections;
    const char* names;
    uint64_t names_size;
    uint64_t bias;
};

typedef struct Census Census;
struct Census
{
    uint64_t* entries;
    uint64_t first;
    uint64_t count;
};

typedef struct Counts Counts;
struct Counts
{
    uint64_t present;
    uint64_t anonymous;
    uint64_t exclusive;
    uint64_t dirty;
    uint64_t swapped;
    uint64_t windows;
    uint64_t ranges;
};

static bool within(uint64_t begin, uint64_t size, uint64_t limit)
{
    return begin <= limit && size <= limit - begin;
}

static bool read_all(int file, void* output, size_t length, uint64_t offset)
{
    size_t done = 0;
    bool good = offset <= INT64_MAX && length <= INT64_MAX - offset;
    while (good && done < length)
    {
        const ssize_t got = pread(file, (uint8_t*)output + done, length - done, (off_t)(offset + done));
        if (got < 0 && errno == EINTR)
        {
            continue;
        }
        good = got > 0;
        done += got > 0 ? (size_t)got : 0;
    }
    return good && done == length;
}

static const char* name_at(const char* names, uint64_t size, uint64_t offset)
{
    return offset < size && memchr(names + offset, 0, (size_t)(size - offset)) ? names + offset : NULL;
}

static bool selected(const char* name, const Elf64_Shdr* section)
{
    const bool allocated = name && section->sh_size && (section->sh_flags & SHF_ALLOC) && !(section->sh_flags & SHF_TLS);
    return allocated && (!strncmp(name, ".bss", 4) || !strncmp(name, ".data.rel.ro", 12) ||
                         !strcmp(name, "buster_baked") || !strcmp(name, ".data") || !strncmp(name, ".got", 4));
}

static bool load_image(Image* image, pid_t child)
{
    char path[80];
    snprintf(path, sizeof(path), "/proc/%d/exe", child);
    const int file = open(path, O_RDONLY | O_CLOEXEC);
    struct stat status;
    bool good = file >= 0 && !fstat(file, &status) && status.st_size >= (off_t)sizeof(Elf64_Ehdr);
    image->size = good ? (size_t)status.st_size : 0;
    image->bytes = good ? mmap(NULL, image->size, PROT_READ, MAP_PRIVATE, file, 0) : MAP_FAILED;
    if (file >= 0)
    {
        close(file);
    }
    good = good && image->bytes != MAP_FAILED;
    image->header = good ? (const Elf64_Ehdr*)image->bytes : NULL;
    const Elf64_Ehdr* header = image->header;
    good = good && !memcmp(header->e_ident, ELFMAG, SELFMAG) && header->e_ident[EI_CLASS] == ELFCLASS64 &&
           header->e_ident[EI_DATA] == ELFDATA2LSB && header->e_machine == EM_X86_64 &&
           (header->e_type == ET_EXEC || header->e_type == ET_DYN) && header->e_shnum &&
           header->e_shentsize == sizeof(Elf64_Shdr) && header->e_phentsize == sizeof(Elf64_Phdr) &&
           within(header->e_shoff, (uint64_t)header->e_shnum * sizeof(Elf64_Shdr), image->size) &&
           within(header->e_phoff, (uint64_t)header->e_phnum * sizeof(Elf64_Phdr), image->size) &&
           header->e_shstrndx < header->e_shnum;
    image->sections = good ? (const Elf64_Shdr*)(image->bytes + header->e_shoff) : NULL;
    const Elf64_Shdr* names = good ? image->sections + header->e_shstrndx : NULL;
    good = good && within(names->sh_offset, names->sh_size, image->size);
    image->names = good ? (const char*)image->bytes + names->sh_offset : NULL;
    image->names_size = good ? names->sh_size : 0;
    if (good && header->e_type == ET_DYN)
    {
        snprintf(path, sizeof(path), "/proc/%d/auxv", child);
        const int auxiliary = open(path, O_RDONLY | O_CLOEXEC);
        Elf64_auxv_t item;
        uint64_t address = 0;
        for (uint64_t at = 0; auxiliary >= 0 && read_all(auxiliary, &item, sizeof(item), at); at += sizeof(item))
        {
            address = item.a_type == AT_PHDR ? item.a_un.a_val : address;
            if (item.a_type == AT_NULL)
            {
                break;
            }
        }
        if (auxiliary >= 0)
        {
            close(auxiliary);
        }
        const Elf64_Phdr* segments = (const Elf64_Phdr*)(image->bytes + header->e_phoff);
        bool found = false;
        for (uint32_t index = 0; index < header->e_phnum; index += 1)
        {
            const Elf64_Phdr* segment = segments + index;
            if (segment->p_type == PT_LOAD && header->e_phoff >= segment->p_offset &&
                within(header->e_phoff - segment->p_offset, (uint64_t)header->e_phnum * sizeof(Elf64_Phdr), segment->p_filesz))
            {
                const uint64_t unrelocated = segment->p_vaddr + header->e_phoff - segment->p_offset;
                found = address >= unrelocated;
                image->bias = found ? address - unrelocated : 0;
            }
        }
        good = found;
    }
    return good;
}

static Counts counts_for(const Census* census, uint64_t begin, uint64_t bytes)
{
    Counts result = { 0 };
    const uint64_t first = begin & ~(PAGE_BYTES - 1);
    const uint64_t end = begin + bytes;
    uint64_t last_window = UINT64_MAX;
    uint64_t last_range = UINT64_MAX;
    for (uint64_t page = first; page < end; page += PAGE_BYTES)
    {
        const uint64_t index = (page - census->first) / PAGE_BYTES;
        if (page < census->first || index >= census->count)
        {
            continue;
        }
        const uint64_t entry = census->entries[index];
        result.swapped += (entry & PAGE_SWAPPED) != 0;
        if (entry & PAGE_PRESENT)
        {
            result.present += 1;
            result.anonymous += !(entry & PAGE_FILE);
            result.exclusive += (entry & PAGE_EXCLUSIVE) != 0;
            result.dirty += (entry & PAGE_DIRTY) != 0;
            result.windows += page >> 16 != last_window;
            result.ranges += page >> 21 != last_range;
            last_window = page >> 16;
            last_range = page >> 21;
        }
    }
    return result;
}

static void print_counts(FILE* output, const char* kind, const char* section, const char* name, uint64_t address, uint64_t size, Counts counts)
{
    fprintf(output, "%s\t%s\t%s\t0x%016" PRIx64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64
            "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", kind, section, name, address, size,
            counts.present, counts.anonymous, counts.exclusive, counts.dirty, counts.swapped, counts.windows, counts.ranges);
}

static bool census_section(FILE* output, const Image* image, int pagemap, uint32_t number)
{
    const Elf64_Shdr* section = image->sections + number;
    const char* section_name = name_at(image->names, image->names_size, section->sh_name);
    const uint64_t address = section->sh_addr + image->bias;
    bool good = address >= image->bias && section->sh_size <= UINT64_MAX - address - (PAGE_BYTES - 1);
    Census census = { .first = address & ~(PAGE_BYTES - 1) };
    census.count = good ? ((address + section->sh_size + PAGE_BYTES - 1) / PAGE_BYTES) - census.first / PAGE_BYTES : 0;
    good = good && census.count <= SIZE_MAX / sizeof(uint64_t);
    census.entries = good ? malloc((size_t)census.count * sizeof(uint64_t)) : NULL;
    good = good && census.entries && read_all(pagemap, census.entries, (size_t)census.count * sizeof(uint64_t), census.first / PAGE_BYTES * sizeof(uint64_t));
    for (uint64_t index = 0; good && index < census.count; index += 1)
    {
        const uint64_t entry = census.entries[index];
        if ((entry & PAGE_PRESENT) || all_pages)
        {
            const uint64_t page = census.first + index * PAGE_BYTES;
            fprintf(output, "PAGE\t%s\t0x%016" PRIx64 "\t%u\t%u\t%u\t%u\t%u\t0x%016" PRIx64 "\t0x%016" PRIx64 "\n",
                    section_name, page, (unsigned)((entry & PAGE_PRESENT) != 0), (unsigned)((entry & PAGE_FILE) != 0), (unsigned)((entry & PAGE_EXCLUSIVE) != 0),
                    (unsigned)((entry & PAGE_DIRTY) != 0), (unsigned)((entry & PAGE_SWAPPED) != 0), page & ~UINT64_C(65535), page & ~UINT64_C(2097151));
        }
    }
    if (good)
    {
        print_counts(output, "SECTION", section_name, "-", address, section->sh_size, counts_for(&census, address, section->sh_size));
    }
    for (uint32_t table = 0; good && table < image->header->e_shnum; table += 1)
    {
        const Elf64_Shdr* symbols = image->sections + table;
        if (symbols->sh_type != SHT_SYMTAB)
        {
            continue;
        }
        good = symbols->sh_entsize == sizeof(Elf64_Sym) && symbols->sh_size % sizeof(Elf64_Sym) == 0 &&
               symbols->sh_link < image->header->e_shnum && within(symbols->sh_offset, symbols->sh_size, image->size);
        const Elf64_Shdr* names = good ? image->sections + symbols->sh_link : NULL;
        good = good && within(names->sh_offset, names->sh_size, image->size);
        const Elf64_Sym* rows = good ? (const Elf64_Sym*)(image->bytes + symbols->sh_offset) : NULL;
        for (uint64_t index = 0; good && index < symbols->sh_size / sizeof(Elf64_Sym); index += 1)
        {
            const Elf64_Sym* symbol = rows + index;
            if (symbol->st_shndx != number || !symbol->st_size || ELF64_ST_TYPE(symbol->st_info) != STT_OBJECT)
            {
                continue;
            }
            good = symbol->st_value >= section->sh_addr && within(symbol->st_value - section->sh_addr, symbol->st_size, section->sh_size);
            const char* name = name_at((const char*)image->bytes + names->sh_offset, names->sh_size, symbol->st_name);
            good = good && name;
            if (good)
            {
                const Counts counts = counts_for(&census, symbol->st_value + image->bias, symbol->st_size);
                if (counts.present || all_pages)
                {
                    print_counts(output, "SYMBOL", section_name, name, symbol->st_value + image->bias, symbol->st_size, counts);
                }
            }
        }
    }
    free(census.entries);
    return good;
}

static bool census(FILE* output, pid_t child)
{
    Image image = { 0 };
    char path[80];
    snprintf(path, sizeof(path), "/proc/%d/pagemap", child);
    const int pagemap = open(path, O_RDONLY | O_CLOEXEC);
    bool good = pagemap >= 0 && load_image(&image, child);
    char executable[4096];
    snprintf(path, sizeof(path), "/proc/%d/exe", child);
    const ssize_t length = readlink(path, executable, sizeof(executable) - 1);
    executable[length >= 0 ? length : 0] = 0;
    fprintf(output, "EXECUTABLE\t%s\nBIAS\t0x%016" PRIx64 "\n", executable, image.bias);
    fprintf(output, "# PAGE: section address present file_or_shared_anon exclusive soft_dirty swapped window_64K range_2M\n");
    fprintf(output, "# SECTION/SYMBOL: section name address size present anonymous exclusive soft_dirty swapped windows_64K ranges_2M\n");
    fprintf(output, "# Present pages may be mapped by fault-around without being read. A symbol's pages can overlap other symbols.\n");
    for (uint32_t index = 0; good && index < image.header->e_shnum; index += 1)
    {
        const Elf64_Shdr* section = image.sections + index;
        const char* name = name_at(image.names, image.names_size, section->sh_name);
        good = name != NULL;
        if (good && selected(name, section))
        {
            good = census_section(output, &image, pagemap, index);
        }
    }
    if (image.bytes && image.bytes != MAP_FAILED)
    {
        munmap(image.bytes, image.size);
    }
    if (pagemap >= 0)
    {
        close(pagemap);
    }
    fprintf(output, "CENSUS_OK\t%d\n", good);
    fflush(output);
    return good && !ferror(output);
}

static int command_status(int status)
{
    return WIFEXITED(status) ? WEXITSTATUS(status) : WIFSIGNALED(status) ? 128 + WTERMSIG(status) : 125;
}

static pid_t wait_child(pid_t child, int* status, int flags, struct rusage* usage)
{
    pid_t waited;
    do
    {
        waited = wait4(child, status, flags, usage);
    } while (waited < 0 && errno == EINTR);
    return waited;
}

static bool final_sleep(pid_t child)
{
    char path[80];
    snprintf(path, sizeof(path), "/proc/%d/syscall", child);
    const int file = open(path, O_RDONLY | O_CLOEXEC);
    char text[256] = { 0 };
    const ssize_t length = file >= 0 ? read(file, text, sizeof(text) - 1) : -1;
    if (file >= 0)
    {
        close(file);
    }
    char* end = NULL;
    const long call = length > 0 ? strtol(text, &end, 10) : -1;
    return end && end != text && (call == SYS_nanosleep || call == SYS_clock_nanosleep);
}

static double now(void)
{
    struct timespec time = { 0 };
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (double)time.tv_sec + (double)time.tv_nsec * 1e-9;
}

static bool pause_census(FILE* output, pid_t child, int notification, int* status, struct rusage* usage)
{
    const double deadline = now() + 600;
    bool closed = false;
    bool finished = false;
    bool recorded = false;
    bool good = true;
    while (good && !finished && !recorded && now() < deadline)
    {
        struct pollfd descriptor = { .fd = notification, .events = POLLIN | POLLHUP };
        if (!closed)
        {
            const int event = poll(&descriptor, 1, 20);
            good = event >= 0 || errno == EINTR;
            closed = event > 0 && (descriptor.revents & POLLHUP);
        }
        else
        {
            const struct timespec delay = { .tv_nsec = 1000000 };
            nanosleep(&delay, NULL);
        }
        const pid_t waited = wait_child(child, status, WNOHANG, usage);
        good = good && waited >= 0;
        finished = waited == child;
        if (good && !finished && closed && final_sleep(child))
        {
            good = kill(child, SIGSTOP) == 0 && wait_child(child, status, WUNTRACED, usage) == child;
            finished = good && !WIFSTOPPED(*status);
            if (good && !finished)
            {
                recorded = true;
                good = census(output, child);
                // Census failure must still let the authorized command finish.
                const bool continued = kill(child, SIGCONT) == 0;
                good = good && continued;
            }
        }
    }
    if (!recorded)
    {
        fprintf(stderr, "datapages: command did not enter its final BUSTER_TEST_EXIT_HELPER_PAUSE sleep (threads, refused clone, or deadline)\n");
        good = false;
        if (!finished)
        {
            kill(child, SIGKILL);
        }
    }
    if (!finished)
    {
        const bool waited = wait_child(child, status, 0, usage) == child;
        good = good && waited;
    }
    return good && recorded;
}

static bool traced_census(FILE* output, pid_t child, int* status, struct rusage* usage)
{
    bool stopped = wait_child(child, status, 0, usage) == child && WIFSTOPPED(*status);
    bool good = stopped && ptrace(PTRACE_SETOPTIONS, child, NULL, PTRACE_O_TRACESYSGOOD | PTRACE_O_TRACEEXEC | PTRACE_O_EXITKILL) == 0;
    bool recorded = false;
    bool read = false;
    int delivered = 0;
    while (good && stopped)
    {
        good = ptrace(PTRACE_SYSCALL, child, NULL, (void*)(intptr_t)delivered) == 0 && wait_child(child, status, 0, usage) == child;
        stopped = good && WIFSTOPPED(*status);
        delivered = 0;
        if (stopped && WSTOPSIG(*status) == (SIGTRAP | 0x80))
        {
            struct user_regs_struct registers;
            good = ptrace(PTRACE_GETREGS, child, NULL, &registers) == 0;
            if (good && !recorded && (registers.orig_rax == SYS_exit_group || registers.orig_rax == SYS_exit))
            {
                recorded = true;
                read = census(output, child);
            }
        }
        else if (stopped && (*status >> 16) == PTRACE_EVENT_EXEC)
        {
            // The post-exec trap is a ptrace event, not a signal to the executable.
        }
        else if (stopped)
        {
            delivered = WSTOPSIG(*status);
        }
    }
    if (!good && stopped)
    {
        const int saved = errno;
        kill(child, SIGKILL);
        wait_child(child, status, 0, usage);
        fprintf(stderr, "datapages: ptrace/wait failed: %s\n", strerror(saved));
    }
    return good && recorded && read;
}

int main(int argc, char** argv)
{
    bool paused = false;
    bool base_pages = false;
    int first = 1;
    while (first < argc && (!strcmp(argv[first], "--pause") || !strcmp(argv[first], "--all-pages") || !strcmp(argv[first], "--base-pages")))
    {
        paused |= !strcmp(argv[first], "--pause");
        all_pages |= !strcmp(argv[first], "--all-pages");
        base_pages |= !strcmp(argv[first], "--base-pages");
        first += 1;
    }
    FILE* output = argc >= first + 2 ? fopen(argv[first], "w") : NULL;
    int result = 125;
    if (!output)
    {
        fprintf(stderr, "usage: datapages [--pause] [--all-pages] [--base-pages] OUTPUT.tsv COMMAND [ARG...]\n");
    }
    else
    {
        // A forced exit helper must never leave an orphan to a PID 1 that does not reap.
        const bool reaper = prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0) == 0;
        const int before = prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0);
        const bool set = !base_pages || prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0) == 0;
        const int inherited = prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0);
        const bool policy = set && (!base_pages || inherited == 1);
        fprintf(output, "BASE_PAGES_CONTROL\t%d\nTHP_DISABLE_BEFORE\t%d\nTHP_DISABLE_BEFORE_EXEC\t%d\n", base_pages, before, inherited);
        int notification[2] = { -1, -1 };
        bool good = reaper && policy && (!paused || pipe2(notification, O_CLOEXEC) == 0);
        good = good && fcntl(fileno(output), F_SETFD, FD_CLOEXEC) == 0;
        const pid_t child = good ? fork() : -1;
        if (!child)
        {
            if (base_pages && prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0) != 1)
            {
                _exit(125);
            }
            if (paused)
            {
                close(notification[0]);
                if (fcntl(notification[1], F_SETFD, 0) < 0 || setenv("BUSTER_EXIT_HELPER", "1", 1) || setenv("BUSTER_TEST_EXIT_HELPER_PAUSE", "2000", 1))
                {
                    _exit(125);
                }
            }
            else if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) < 0 || raise(SIGSTOP))
            {
                perror("datapages: ptrace TRACEME");
                _exit(125);
            }
            execvp(argv[first + 1], argv + first + 1);
            perror(argv[first + 1]);
            _exit(127);
        }
        if (notification[1] >= 0)
        {
            close(notification[1]);
        }
        int status = 125 << 8;
        struct rusage usage = { 0 };
        fprintf(output, "MODE\t%s\n", paused ? "existing-exit-helper-pause" : "ptrace-at-exit");
        good = child > 0 && (paused ? pause_census(output, child, notification[0], &status, &usage) : traced_census(output, child, &status, &usage));
        if (notification[0] >= 0)
        {
            close(notification[0]);
        }
        const int exited = command_status(status);
        fprintf(output, "EXIT_STATUS\t%d\nRUSAGE_MINOR_FAULTS\t%ld\nRUSAGE_MAJOR_FAULTS\t%ld\n", exited, usage.ru_minflt, usage.ru_majflt);
        uint32_t descendants = 0;
        long descendant_faults = 0;
        struct rusage descendant_usage = { 0 };
        int descendant_status = 0;
        while (wait_child(-1, &descendant_status, 0, &descendant_usage) > 0)
        {
            descendants += 1;
            descendant_faults += descendant_usage.ru_minflt;
            fprintf(output, "DESCENDANT_STATUS\t%d\n", command_status(descendant_status));
        }
        fprintf(output, "REAPED_DESCENDANTS\t%u\nDESCENDANT_MINOR_FAULTS\t%ld\n", descendants, descendant_faults);
        result = exited != 0 ? exited : good ? 0 : 125;
        if (fclose(output) && result == 0)
        {
            result = 125;
        }
    }
    return result;
}
