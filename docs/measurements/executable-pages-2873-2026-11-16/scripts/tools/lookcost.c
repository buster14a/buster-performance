// lookcost N: what a short-lived process pays to ask how its own pages are mapped, N children one after the other,
// each timing (TSC ticks) its first open of /proc/self/pagemap, a PAGEMAP_SCAN of this executable's 2 MB around main,
// the close, then a move_pages query of one address (no file), and a second of each; the parent prints the medians.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>
#include <linux/fs.h>
#include <x86intrin.h>

#define STEPS 8

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    const int count = argc == 2 ? atoi(argv[1]) : 200;
    static uint64_t samples[STEPS][4096];
    static const char* const names[STEPS] = { "open /proc/self/pagemap", "PAGEMAP_SCAN of 2 MB", "close", "move_pages of one address", "open again", "scan again", "close again", "move_pages again" };
    int done = 0;
    for (int i = 0; i < count && i < 4096; i += 1)
    {
        int pipes[2];
        if (pipe(pipes) != 0)
        {
            break;
        }
        const pid_t child = fork();
        if (child == 0)
        {
            uint64_t ticks[STEPS];
            const uint64_t base = (uint64_t)(uintptr_t)&main & ~((2ull << 20) - 1);
            void* address = (void*)(uintptr_t)&main;
            int status = 0;
            struct page_region regions[16];
            for (int pass = 0; pass < 2; pass += 1)
            {
                const uint64_t t0 = __rdtsc();
                const int pagemap = open("/proc/self/pagemap", O_RDONLY | O_CLOEXEC);
                const uint64_t t1 = __rdtsc();
                struct pm_scan_arg scan = {
                    .size = sizeof(scan),
                    .start = base,
                    .end = base + (2ull << 20),
                    .vec = (uint64_t)(uintptr_t)regions,
                    .vec_len = 16,
                    .category_mask = PAGE_IS_PRESENT,
                    .return_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
                };
                ioctl(pagemap, PAGEMAP_SCAN, &scan);
                const uint64_t t2 = __rdtsc();
                close(pagemap);
                const uint64_t t3 = __rdtsc();
                syscall(SYS_move_pages, 0, 1ul, &address, 0, &status, 0);
                const uint64_t t4 = __rdtsc();
                ticks[pass * 4 + 0] = t1 - t0;
                ticks[pass * 4 + 1] = t2 - t1;
                ticks[pass * 4 + 2] = t3 - t2;
                ticks[pass * 4 + 3] = t4 - t3;
            }
            ticks[0] += status < 0 ? 0 : 0;
            (void)!write(pipes[1], ticks, sizeof(ticks));
            _exit(status >= 0 ? 0 : 1);
        }
        uint64_t ticks[STEPS];
        close(pipes[1]);
        if (read(pipes[0], ticks, sizeof(ticks)) == (ssize_t)sizeof(ticks))
        {
            for (int s = 0; s < STEPS; s += 1)
            {
                samples[s][done] = ticks[s];
            }
            done += 1;
        }
        close(pipes[0]);
        int status = 0;
        waitpid(child, &status, 0);
        if (i == 0)
        {
            printf("move_pages status of the first child: %d\n", WIFEXITED(status) ? WEXITSTATUS(status) : -1);
        }
    }
    for (int s = 0; s < STEPS && done != 0; s += 1)
    {
        qsort(samples[s], (size_t)done, sizeof(uint64_t), compare);
        printf("%-28s median %6llu ticks (quartiles %llu to %llu) of %d\n", names[s], (unsigned long long)samples[s][done / 2], (unsigned long long)samples[s][done / 4],
               (unsigned long long)samples[s][done * 3 / 4], done);
    }
    return done != 0 ? 0 : 1;
}
