// #1444: a process that touches MEGABYTES of anonymous memory in base pages, writes one byte to standard error and exits
// (exit_group), with the threads its name's last character says: '0' none, '1' to '7' that many parked on a futex, 'j'
// one created and joined before the write; 'p' none, but the process's private futex hash given 16 slots first
// (prctl PR_FUTEX_HASH, Linux 6.16); 'q' its hash given 16 slots then 32; 'r' 32 at once; 's' one thread joined, then
// 32 slots. For phases.c, through links named exits-0 and so on, to see what the process has as
// it exits that moves its address space's teardown off its exit.
//   exits-N MEGABYTES
#define _GNU_SOURCE
#include <linux/futex.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/prctl.h>
#include <unistd.h>

static uint32_t exits_never;

static void* exits_park(void* argument)
{
    (void)argument;
    while (1)
    {
        syscall(SYS_futex, &exits_never, FUTEX_WAIT_PRIVATE, 0, 0, 0, 0);
    }
    return 0;
}

static void* exits_return(void* argument)
{
    return argument;
}

int main(int argc, char** argv)
{
    const size_t length = strlen(argv[0]);
    const char mode = length != 0 ? argv[0][length - 1] : '0';
    const long megabytes = argc > 1 ? strtol(argv[1], 0, 10) : 0;
    const size_t bytes = (size_t)(megabytes > 0 ? megabytes : 1) << 20;
    char* memory = mmap(0, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    int result = memory != MAP_FAILED ? 0 : 1;
    if (result == 0)
    {
        madvise(memory, bytes, MADV_NOHUGEPAGE);
        for (size_t i = 0; i < bytes; i += 4096)
        {
            memory[i] = 1;
        }
    }
    const int threads = mode >= '1' && mode <= '7' ? mode - '0' : 0;
    if (result == 0 && mode == 'p')
    {
        // PR_FUTEX_HASH (78), PR_FUTEX_HASH_SET_SLOTS (1): 16 slots.
        result = prctl(78, 1, 16, 0, 0) == 0 ? 0 : 1;
    }
    if (result == 0 && mode == 'q')
    {
        // The private futex hash replaced: 16 slots, then 32.
        result = prctl(78, 1, 16, 0, 0) == 0 && prctl(78, 1, 32, 0, 0) == 0 ? 0 : 1;
    }
    if (result == 0 && mode == 'r')
    {
        // The private futex hash of 32 slots from the start.
        result = prctl(78, 1, 32, 0, 0) == 0 ? 0 : 1;
    }
    if (result == 0 && mode == 's')
    {
        // One thread created and joined, then the hash replaced by 32 slots.
        pthread_t thread;
        result = pthread_create(&thread, 0, exits_return, 0) == 0 && pthread_join(thread, 0) == 0 && prctl(78, 1, 32, 0, 0) == 0 ? 0 : 1;
    }
    for (int i = 0; result == 0 && i < threads; i += 1)
    {
        pthread_t thread;
        result = pthread_create(&thread, 0, exits_park, 0) == 0 ? 0 : 1;
    }
    if (result == 0 && mode == 'j')
    {
        pthread_t thread;
        result = pthread_create(&thread, 0, exits_return, 0) == 0 && pthread_join(thread, 0) == 0 ? 0 : 1;
    }
    // Every parked thread is asleep before the write: they slept at once, and this one waits a little for them.
    usleep(threads != 0 ? 1000 : 0);
    result = result == 0 && write(2, "x", 1) == 1 ? 0 : 1;
    return result;
}
