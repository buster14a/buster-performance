#define _GNU_SOURCE
#include <assert.h>
#include <complex.h>
#include <ctype.h>
#include <errno.h>
#include <fenv.h>
#include <float.h>
#include <inttypes.h>
#include <iso646.h>
#include <limits.h>
#include <locale.h>
#include <math.h>
#include <setjmp.h>
#include <signal.h>
#include <stdalign.h>
#include <stdarg.h>
#include <stdatomic.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdnoreturn.h>
#include <string.h>
#include <tgmath.h>
#include <time.h>
#include <uchar.h>
#include <wchar.h>
#include <wctype.h>
#include <dirent.h>
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <poll.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

struct item
{
    char name[32];
    double value;
    int count;
};

static int compare_items(const void* a, const void* b)
{
    const struct item* x = a;
    const struct item* y = b;
    return x->value < y->value ? -1 : x->value > y->value;
}

static void* worker(void* argument)
{
    atomic_int* counter = argument;
    for (int i = 0; i < 1000; i += 1)
    {
        atomic_fetch_add(counter, 1);
    }
    return NULL;
}

static double norm(double complex z)
{
    return cabs(z);
}

int main(int argc, char** argv)
{
    struct item items[8];
    for (int i = 0; i < 8; i += 1)
    {
        snprintf(items[i].name, sizeof(items[i].name), "item%d", i);
        items[i].value = sin((double)i) * 10.0;
        items[i].count = i * i;
    }
    qsort(items, 8, sizeof(items[0]), compare_items);
    atomic_int counter = 0;
    pthread_t threads[2];
    for (int i = 0; i < 2; i += 1)
    {
        pthread_create(&threads[i], NULL, worker, &counter);
    }
    for (int i = 0; i < 2; i += 1)
    {
        pthread_join(threads[i], NULL);
    }
    struct timeval now;
    gettimeofday(&now, NULL);
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    char buffer[64];
    struct in_addr address;
    inet_pton(AF_INET, "127.0.0.1", &address);
    inet_ntop(AF_INET, &address, buffer, sizeof(buffer));
    wchar_t wide[16];
    mbstowcs(wide, "hello", 16);
    int upper = 0;
    for (int i = 0; wide[i] != 0; i += 1)
    {
        upper += iswupper((wint_t)towupper((wint_t)wide[i]));
    }
    double complex z = 3.0 + 4.0 * I;
    jmp_buf jump;
    int jumped = setjmp(jump);
    if (jumped == 0)
    {
        longjmp(jump, 1);
    }
    struct stat status;
    int found = stat(argc > 0 ? argv[0] : ".", &status) == 0;
    uint64_t big = UINT64_C(1) << 40;
    printf("%s %.3f %d %" PRIu64 " %s %d %.1f %d %d %ld\n", items[0].name, items[0].value, atomic_load(&counter), big, buffer,
           upper, norm(z), jumped, found, (long)(now.tv_sec > 0));
    feclearexcept(FE_ALL_EXCEPT);
    setlocale(LC_ALL, "C");
    assert(isalpha('a'));
    errno = 0;
    char* end = NULL;
    long parsed = strtol("42", &end, 10);
    static_assert(sizeof(int) >= 2, "int");
    return parsed == 42 && *end == 0 && fabs(sqrt(4.0) - 2.0) < DBL_EPSILON ? 0 : 1;
}
