// starttrace SYMBOLS OUT COMMAND...: runs COMMAND with a breakpoint at the entry of every function of its executable
// (SYMBOLS is `readelf -sW` of it: the FUNC symbols with a size) and appends to OUT a line `trace` and then the address
// of each function the command ran, one a line, in the order they first ran. A breakpoint is removed as it is hit, so
// each function stops the command once. The command's threads and the processes that share its address space (the exit
// helper) are traced too. Exits with the command's status.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct Entry Entry;
struct Entry
{
    uint64_t address;
    uint8_t original;
    uint8_t armed;
};

static int compare(const void* a, const void* b)
{
    const Entry* x = a;
    const Entry* y = b;
    return (x->address > y->address) - (x->address < y->address);
}

// The FUNC symbols with a size in `readelf -sW`'s text, as breakpoints sorted by address, one an address.
static Entry* read_symbols(const char* path, uint64_t* count)
{
    FILE* file = fopen(path, "r");
    uint64_t capacity = 1 << 16;
    uint64_t length = 0;
    Entry* entries = malloc(capacity * sizeof(Entry));
    char line[4096];
    while (file != 0 && fgets(line, sizeof(line), file) != 0)
    {
        unsigned long long number = 0;
        unsigned long long value = 0;
        char size[64];
        char type[64];
        char bind[64];
        char visibility[64];
        char index[64];
        if (sscanf(line, " %llu: %llx %63s %63s %63s %63s %63s", &number, &value, size, type, bind, visibility, index) == 7 && strcmp(type, "FUNC") == 0 &&
            strcmp(index, "UND") != 0 && strtoull(size, 0, 0) != 0)
        {
            if (length == capacity)
            {
                capacity *= 2;
                entries = realloc(entries, capacity * sizeof(Entry));
            }
            entries[length] = (Entry){ .address = value };
            length += 1;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    qsort(entries, length, sizeof(Entry), compare);
    uint64_t unique = 0;
    for (uint64_t i = 0; i < length; i += 1)
    {
        if (unique == 0 || entries[unique - 1].address != entries[i].address)
        {
            entries[unique] = entries[i];
            unique += 1;
        }
    }
    *count = unique;
    return entries;
}

static Entry* find(Entry* entries, uint64_t count, uint64_t address)
{
    uint64_t low = 0;
    uint64_t high = count;
    while (low < high)
    {
        const uint64_t middle = low + (high - low) / 2;
        if (entries[middle].address < address)
        {
            low = middle + 1;
        }
        else
        {
            high = middle;
        }
    }
    return low < count && entries[low].address == address ? &entries[low] : 0;
}

int main(int argc, char** argv)
{
    int status = 2;
    uint64_t count = 0;
    Entry* entries = argc >= 4 ? read_symbols(argv[1], &count) : 0;
    FILE* out = count != 0 ? fopen(argv[2], "a") : 0;
    if (out != 0)
    {
        const pid_t child = fork();
        if (child == 0)
        {
            ptrace(PTRACE_TRACEME, 0, 0, 0);
            execv(argv[3], argv + 3);
            _exit(127);
        }
        int wait_status = 0;
        // The stop at the exec's end, before the new image's first instruction.
        bool traced = child > 0 && waitpid(child, &wait_status, 0) == child && WIFSTOPPED(wait_status);
        char path[64];
        snprintf(path, sizeof(path), "/proc/%d/mem", (int)child);
        const int memory = traced ? open(path, O_RDWR | O_CLOEXEC) : -1;
        traced = traced && memory >= 0 &&
                 ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_TRACECLONE | PTRACE_O_TRACEFORK | PTRACE_O_TRACEVFORK | PTRACE_O_EXITKILL) == 0;
        // The breakpoints, a page of the image at a time.
        uint64_t armed = 0;
        for (uint64_t i = 0; traced && i < count;)
        {
            const uint64_t page = entries[i].address & ~4095ull;
            uint8_t bytes[4096];
            uint64_t end = i;
            while (end < count && (entries[end].address & ~4095ull) == page)
            {
                end += 1;
            }
            if (pread(memory, bytes, sizeof(bytes), (off_t)page) == (ssize_t)sizeof(bytes))
            {
                for (uint64_t e = i; e < end; e += 1)
                {
                    entries[e].original = bytes[entries[e].address - page];
                    entries[e].armed = 1;
                    bytes[entries[e].address - page] = 0xcc;
                }
                if (pwrite(memory, bytes, sizeof(bytes), (off_t)page) == (ssize_t)sizeof(bytes))
                {
                    armed += end - i;
                }
                else
                {
                    for (uint64_t e = i; e < end; e += 1)
                    {
                        entries[e].armed = 0;
                    }
                }
            }
            i = end;
        }
        fprintf(out, "trace\n");
        uint64_t ran = 0;
        int live = traced ? 1 : 0;
        if (traced)
        {
            ptrace(PTRACE_CONT, child, 0, 0);
        }
        while (live > 0)
        {
            const pid_t stopped = waitpid(-1, &wait_status, __WALL);
            if (stopped < 0)
            {
                break;
            }
            if (WIFEXITED(wait_status) || WIFSIGNALED(wait_status))
            {
                live -= 1;
                if (stopped == child)
                {
                    status = WIFEXITED(wait_status) ? WEXITSTATUS(wait_status) : 128 + WTERMSIG(wait_status);
                }
            }
            else if (WIFSTOPPED(wait_status))
            {
                const int signal_number = WSTOPSIG(wait_status);
                const int event = wait_status >> 16;
                int deliver = signal_number;
                if (signal_number == SIGTRAP && event != 0)
                {
                    // A clone, fork or vfork: the new task is traced, and stops once before it runs.
                    live += 1;
                    deliver = 0;
                }
                else if (signal_number == SIGTRAP)
                {
                    struct user_regs_struct registers;
                    Entry* entry = ptrace(PTRACE_GETREGS, stopped, 0, &registers) == 0 ? find(entries, count, registers.rip - 1) : 0;
                    if (entry != 0)
                    {
                        // A thread may reach a breakpoint another has just removed: its instruction is back, so it runs
                        // again from there too.
                        if (entry->armed)
                        {
                            pwrite(memory, &entry->original, 1, (off_t)entry->address);
                            entry->armed = 0;
                            fprintf(out, "0x%llx\n", (unsigned long long)entry->address);
                            ran += 1;
                        }
                        registers.rip = entry->address;
                        ptrace(PTRACE_SETREGS, stopped, 0, &registers);
                        deliver = 0;
                    }
                }
                else if (signal_number == SIGSTOP && stopped != child)
                {
                    // A new task's first stop.
                    deliver = 0;
                }
                ptrace(PTRACE_CONT, stopped, 0, deliver);
            }
        }
        fclose(out);
        fprintf(stderr, "starttrace: %llu of %llu breakpoints set, %llu functions ran, status %d\n", (unsigned long long)armed, (unsigned long long)count,
                (unsigned long long)ran, status);
    }
    else
    {
        fprintf(stderr, "usage: starttrace SYMBOLS OUT COMMAND...\n");
    }
    return status;
}
