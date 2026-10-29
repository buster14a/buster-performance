// How /proc/vmstat counts huge pages that faults allocate: 10 rounds of a 64 MB mapping advised MADV_HUGEPAGE, a byte
// written in each 2 MB of it (or read, then written), then unmapped; thp_fault_alloc, pgalloc_normal and
// thp_split_pmd printed before and after each way.
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
static long vmstat(const char* name)
{
    FILE* file = fopen("/proc/vmstat", "r");
    char key[128];
    long value = -1;
    long v;
    while (file != NULL && fscanf(file, "%127s %ld", key, &v) == 2)
    {
        if (strcmp(key, name) == 0)
        {
            value = v;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return value;
}
static void run(int read_first)
{
    const char* names[3] = { "thp_fault_alloc", "pgalloc_normal", "thp_split_pmd" };
    long before[3];
    for (int i = 0; i < 3; i += 1)
    {
        before[i] = vmstat(names[i]);
    }
    volatile uint64_t sink = 0;
    for (int round = 0; round < 10; round += 1)
    {
        const uint64_t bytes = UINT64_C(64) << 20;
        uint8_t* raw = mmap(0, bytes + (UINT64_C(2) << 20), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
        uint8_t* base = (uint8_t*)(((uintptr_t)raw + (UINT64_C(2) << 20) - 1) & ~((uintptr_t)(UINT64_C(2) << 20) - 1));
        madvise(base, bytes, MADV_HUGEPAGE);
        for (uint64_t offset = 0; offset < bytes; offset += UINT64_C(2) << 20)
        {
            if (read_first)
            {
                sink += base[offset + 4096];
            }
            base[offset + 4096] = 1;
        }
        munmap(raw, bytes + (UINT64_C(2) << 20));
    }
    printf("%s:", read_first ? "read then write" : "write");
    for (int i = 0; i < 3; i += 1)
    {
        printf(" %s %+ld", names[i], vmstat(names[i]) - before[i]);
    }
    printf(" (320 regions)\n");
}
int main(void)
{
    run(0);
    run(1);
    return 0;
}
