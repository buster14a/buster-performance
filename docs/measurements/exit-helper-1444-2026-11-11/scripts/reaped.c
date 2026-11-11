// #1444: lane_exit_reaped's parse, outside the compiler, on this machine's /proc/1/stat.
#define _GNU_SOURCE
#include <fcntl.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
// /proc/1/stat's fields 32 to 34, the signals PID 1 blocks, ignores and catches, in decimal, after its command's
// parenthesis (which may hold spaces) and its state (field 3, a letter).
static bool lane_exit_reaped(void)
{
    char text[1024];
    const int fd = open("/proc/1/stat", O_RDONLY | O_CLOEXEC);
    const ssize_t length = fd >= 0 ? read(fd, text, sizeof(text) - 1) : -1;
    if (fd >= 0)
    {
        close(fd);
    }
    text[length > 0 ? length : 0] = 0;
    const char* parenthesis = length > 0 ? strrchr(text, ')') : 0;
    const char* at = parenthesis != 0 ? parenthesis + 1 : 0;
    uint64_t handled = 0;
    uint32_t parsed = 0;
    // Each field from 3 on follows one space: past a number's digits, or for the state, at the next space.
    for (uint32_t field = 3; at != 0 && *at == ' ' && field <= 34; field += 1)
    {
        at += 1;
        char* after = 0;
        const unsigned long long value = strtoull(at, &after, 10);
        const bool number = after != at;
        handled |= field >= 32 && number ? (uint64_t)value : 0;
        parsed += field >= 32 && number ? 1 : 0;
        at = number ? after : strchr(at, ' ');
    }
    return parsed == 3 && (handled & (UINT64_C(1) << (SIGCHLD - 1))) != 0;
}
int main(void)
{
    printf("%d\n", lane_exit_reaped());
    return 0;
}
