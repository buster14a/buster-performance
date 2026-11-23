#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/resource.h>
#include <x86intrin.h>
int main(void)
{
    char buffer[4096];
    uint64_t best_r = UINT64_MAX, best_p = UINT64_MAX;
    for (int i = 0; i < 200; i += 1)
    {
        uint64_t a = __rdtsc();
        struct rusage u;
        getrusage(RUSAGE_SELF, &u);
        uint64_t b = __rdtsc();
        int fd = open("/proc/self/status", O_RDONLY);
        ssize_t n = read(fd, buffer, sizeof(buffer));
        close(fd);
        uint64_t c = __rdtsc();
        (void)n;
        if (b - a < best_r) best_r = b - a;
        if (c - b < best_p) best_p = c - b;
    }
    printf("getrusage %llu ticks, /proc/self/status %llu ticks\n", (unsigned long long)best_r, (unsigned long long)best_p);
    return 0;
}
