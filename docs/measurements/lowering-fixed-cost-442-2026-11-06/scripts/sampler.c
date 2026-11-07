// #442 off-host profiler: SIGPROF samples of the interrupted RIP, written as hex to $SAMPLER_OUT at exit.
#define _GNU_SOURCE
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/time.h>
#include <ucontext.h>
#include <time.h>
static uint64_t samples[1 << 22];
static uint64_t callers[1 << 22];
static volatile uint32_t count;
static void handler(int s, siginfo_t* i, void* c)
{
    (void)s; (void)i;
    ucontext_t* u = c;
    if (count < (1u << 22)) { callers[count] = *(uint64_t*)u->uc_mcontext.gregs[REG_RSP]; samples[count++] = (uint64_t)u->uc_mcontext.gregs[REG_RIP]; }
}
static void dump(void)
{
    const char* p = getenv("SAMPLER_OUT");
    FILE* f = p ? fopen(p, "w") : 0;
    for (uint32_t k = 0; f && k < count; k += 1) fprintf(f, "%lx %lx\n", (unsigned long)samples[k], (unsigned long)callers[k]);
    if (f) fclose(f);
    char m[4096]; snprintf(m, sizeof m, "%s.maps", p ? p : "x");
    FILE* in = fopen("/proc/self/maps", "r"); FILE* out = p ? fopen(m, "w") : 0; int ch;
    while (in && out && (ch = fgetc(in)) != EOF) fputc(ch, out);
    if (in) fclose(in); if (out) fclose(out);
}
__attribute__((constructor)) static void start(void)
{
    struct sigaction a = { 0 };
    a.sa_sigaction = handler;
    a.sa_flags = SA_SIGINFO | SA_RESTART;
    sigaction(SIGPROF, &a, 0);
    struct sigevent e = { 0 };
    e.sigev_notify = SIGEV_SIGNAL;
    e.sigev_signo = SIGPROF;
    timer_t timer;
    timer_create(CLOCK_MONOTONIC, &e, &timer);
    const char* period = getenv("SAMPLER_NS");
    long ns = period ? atol(period) : 100000;
    struct itimerspec t = { { 0, ns }, { 0, ns } };
    timer_settime(timer, 0, &t, 0);
    atexit(dump);
}
