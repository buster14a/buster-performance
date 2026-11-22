// Cost of the release's kernel calls on an arena-like mapping: 64 GB PROT_NONE, its first 16 MB writable, 4 pages
// written. TSC ticks per call, medians of 2001.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <x86intrin.h>
typedef struct { uint64_t size, flags, start, end, walk_end, vector, vector_length, max_pages, category_inverted, category_mask, category_anyof_mask, return_mask; } Scan;
typedef struct { uint64_t start, end, categories; } Region;
typedef struct { uint64_t size, query_flags, query_addr, vma_start, vma_end, vma_flags, vma_page_size, vma_offset, inode; uint32_t dev_major, dev_minor, vma_name_size, build_id_size; uint64_t vma_name_addr, build_id_addr; } Query;
_Static_assert(sizeof(Query) == 104, "procmap_query");
#define PAGEMAP_SCAN 0xc0606610ull
#define PROCMAP_QUERY 0xc0686611ull
static int cmp(const void* a, const void* b) { uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b; return x < y ? -1 : x > y; }
#define N 2001
static uint64_t t[N];
static uint64_t median(void) { qsort(t, N, sizeof(t[0]), cmp); return t[N / 2]; }
static void touch(uint8_t* p) { for (int i = 0; i < 4; i += 1) p[i * 4096 * 3] = 1; }
int main(void)
{
    const uint64_t bytes = 64ull << 30, rw = 16ull << 20;
    uint8_t* m = mmap(0, bytes, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    mprotect(m + 4096, rw, PROT_READ | PROT_WRITE);
    uint8_t* base = m + 4096;
    int pm = open("/proc/self/pagemap", O_RDONLY), maps = open("/proc/self/maps", O_RDONLY);
    Region regions[32];
    for (int i = 0; i < N; i += 1) { touch(base); uint64_t a = __rdtsc(); madvise(m, bytes, MADV_DONTNEED); t[i] = __rdtsc() - a; }
    printf("madvise whole 64 GB:        %llu\n", (unsigned long long)median());
    for (int i = 0; i < N; i += 1) { touch(base); uint64_t a = __rdtsc(); madvise(base, rw, MADV_DONTNEED); t[i] = __rdtsc() - a; }
    printf("madvise 16 MB:              %llu\n", (unsigned long long)median());
    touch(base);
    for (int i = 0; i < N; i += 1) { Scan s = { sizeof(s), 0, (uint64_t)m, (uint64_t)m + bytes, 0, (uint64_t)regions, 32, 0, 0, 0, 24, 32 }; uint64_t a = __rdtsc(); long r = ioctl(pm, PAGEMAP_SCAN, &s); t[i] = __rdtsc() - a; if (r < 0) { perror("scan"); return 1; } }
    printf("scan whole 64 GB:           %llu\n", (unsigned long long)median());
    for (int i = 0; i < N; i += 1) { Scan s = { sizeof(s), 0, (uint64_t)base, (uint64_t)base + rw, 0, (uint64_t)regions, 32, 0, 0, 0, 24, 32 }; uint64_t a = __rdtsc(); ioctl(pm, PAGEMAP_SCAN, &s); t[i] = __rdtsc() - a; }
    printf("scan 16 MB:                 %llu\n", (unsigned long long)median());
    for (int i = 0; i < N; i += 1) { Query q = { .size = sizeof(q), .query_flags = 0x02 | 0x10, .query_addr = (uint64_t)m }; uint64_t a = __rdtsc(); long r = ioctl(maps, PROCMAP_QUERY, &q); t[i] = __rdtsc() - a; if (r < 0) { perror("query"); return 1; } if (i == 0) printf("  query: %llx-%llx (base %llx, rw end %llx)\n", (unsigned long long)q.vma_start, (unsigned long long)q.vma_end, (unsigned long long)(uint64_t)base, (unsigned long long)((uint64_t)base + rw)); }
    printf("procmap query:              %llu\n", (unsigned long long)median());
    for (int i = 0; i < N; i += 1) { uint64_t a = __rdtsc(); memset(base, 0, 4 * 4096 * 3); t[i] = __rdtsc() - a; }
    printf("memset 48 KB (warm):        %llu\n", (unsigned long long)median());
    for (int i = 0; i < N; i += 1) { madvise(base, rw, MADV_DONTNEED); uint64_t a = __rdtsc(); touch(base); t[i] = __rdtsc() - a; }
    printf("4 faults after a discard:   %llu\n", (unsigned long long)median());
    // A tables-like mapping: 10 GB writable whole, a page written at the start of each of its 10 GB.
    const uint64_t tb = 10ull << 30;
    uint8_t* tm = mmap(0, tb, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    for (int i = 0; i < N; i += 1) { for (int g = 0; g < 10; g += 1) tm[(uint64_t)g << 30] = 1; uint64_t a = __rdtsc(); madvise(tm, tb, MADV_DONTNEED); t[i] = __rdtsc() - a; }
    printf("tables: madvise 10 GB:      %llu\n", (unsigned long long)median());
    for (int g = 0; g < 10; g += 1) tm[(uint64_t)g << 30] = 1;
    for (int i = 0; i < N; i += 1) { Scan s = { sizeof(s), 0, (uint64_t)tm, (uint64_t)tm + tb, 0, (uint64_t)regions, 32, 0, 0, 0, 24, 32 }; uint64_t a = __rdtsc(); ioctl(pm, PAGEMAP_SCAN, &s); t[i] = __rdtsc() - a; }
    printf("tables: scan 10 GB:         %llu\n", (unsigned long long)median());
    return 0;
}
