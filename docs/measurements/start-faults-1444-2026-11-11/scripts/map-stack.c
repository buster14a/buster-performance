// Whether MAP_STACK maps a region VM_NOHUGEPAGE ("nh" in smaps' VmFlags), and whether MADV_HUGEPAGE later replaces it.
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <stdint.h>

static void flags(const char* what, void* address)
{
    FILE* f = fopen("/proc/self/smaps", "r");
    char line[512];
    int in = 0;
    while (fgets(line, sizeof line, f))
    {
        unsigned long a, b;
        if (sscanf(line, "%lx-%lx", &a, &b) == 2 && strchr(line, '-') == line + strspn(line, "0123456789abcdef"))
        {
            in = (uintptr_t)address >= a && (uintptr_t)address < b;
            if (in) printf("%s: %lx-%lx ", what, a, b);
        }
        if (in && strncmp(line, "VmFlags:", 8) == 0) printf("%s", line);
    }
    fclose(f);
}

int main(void)
{
    uint8_t* m = mmap(0, 64ull << 20, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_STACK, -1, 0);
    flags("reserved", m);
    mprotect(m + 4096, 8 << 20, PROT_READ | PROT_WRITE);
    flags("committed", m + 4096);
    madvise(m + (4 << 20), 60ull << 20, MADV_HUGEPAGE);
    flags("past", m + (4 << 20));
    flags("before", m + 4096);
    return 0;
}
