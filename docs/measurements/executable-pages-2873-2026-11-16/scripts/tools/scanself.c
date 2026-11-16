// scanself FILE WINDOWS: maps FILE's first 48 MB read-only at a 2 MB boundary, reads a byte in each of its first WINDOWS
// 64 KB windows, then asks the kernel how those pages are mapped (PAGEMAP_SCAN of /proc/self/pagemap: present pages, and
// whether by a huge page), 5 times, and prints the regions of the first scan and each scan's cycles (open, ioctl, close).
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <linux/fs.h>
#include <x86intrin.h>

#define HUGE (2ull << 20)

int main(int argc, char** argv)
{
    const int file = argc == 3 ? open(argv[1], O_RDONLY | O_CLOEXEC) : -1;
    const uint64_t bytes = 48ull << 20;
    const uint64_t windows = argc == 3 ? strtoull(argv[2], 0, 0) : 0;
    uint8_t* reserved = mmap(0, bytes + HUGE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    uint8_t* at = (uint8_t*)(((uintptr_t)reserved + HUGE - 1) & ~(uintptr_t)(HUGE - 1));
    uint8_t* mapping = file >= 0 ? mmap(at, bytes, PROT_READ, MAP_PRIVATE | MAP_FIXED, file, 0) : MAP_FAILED;
    int status = 1;
    if (mapping != MAP_FAILED)
    {
        volatile uint8_t sink = 0;
        for (uint64_t w = 0; w < windows; w += 1)
        {
            sink = mapping[w * 65536 * 3 % bytes];
        }
        (void)sink;
        static struct page_region regions[1024];
        for (int round = 0; round < 5; round += 1)
        {
            const uint64_t t0 = __rdtsc();
            const int pagemap = open("/proc/self/pagemap", O_RDONLY | O_CLOEXEC);
            const uint64_t t1 = __rdtsc();
            struct pm_scan_arg scan = {
                .size = sizeof(scan),
                .start = (uint64_t)(uintptr_t)mapping,
                .end = (uint64_t)(uintptr_t)mapping + bytes,
                .vec = (uint64_t)(uintptr_t)regions,
                .vec_len = 1024,
                .category_mask = PAGE_IS_PRESENT,
                .return_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
            };
            const long count = ioctl(pagemap, PAGEMAP_SCAN, &scan);
            const uint64_t t2 = __rdtsc();
            close(pagemap);
            const uint64_t t3 = __rdtsc();
            uint64_t huge = 0;
            uint64_t base = 0;
            for (long r = 0; r < count; r += 1)
            {
                const uint64_t pages = (regions[r].end - regions[r].start) / 4096;
                if (regions[r].categories & PAGE_IS_HUGE) huge += pages; else base += pages;
            }
            printf("scan %d: %ld regions (%llu pages by huge pages, %llu by base pages), walk to +%llu MB; open %llu, ioctl %llu, close %llu TSC ticks\n", round, count,
                   (unsigned long long)huge, (unsigned long long)base, (unsigned long long)((scan.walk_end - scan.start) >> 20), (unsigned long long)(t1 - t0),
                   (unsigned long long)(t2 - t1), (unsigned long long)(t3 - t2));
        }
        status = 0;
    }
    return status;
}
