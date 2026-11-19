// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.

// Compare production C callers and their raw-bit leaves with the system libm.
#define _GNU_SOURCE
#include <errno.h>
#include <immintrin.h>
#include <inttypes.h>
#include <math.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <ucontext.h>
#include <unistd.h>

extern double root64(double);
extern float root32(float);
extern uint64_t raw64(uint64_t, int *);
extern uint64_t raw32(uint64_t, int *);

static const struct
{
    uint64_t d;
    uint32_t f;
} inputs[] = {
    {0, 0},
    {0x8000000000000000, 0x80000000}, // signed zeros
    {0x3ff0000000000000, 0x3f800000},
    {0x4010000000000000, 0x40800000}, // 1, 4
    {0x4000000000000000, 0x40000000},
    {0xbff0000000000000, 0xbf800000}, // 2, -1
    {0x7ff0000000000000, 0x7f800000},
    {0xfff0000000000000, 0xff800000}, // infinities
    {0x7ff8123456789abc, 0x7fc12345},
    {0xfff8123456789abc, 0xffc12345}, // qNaNs
    {0x7ff0123456789abc, 0x7f812345},
    {0xfff0123456789abc, 0xff812345}, // sNaNs
    {1, 1},
    {0x8000000000000001, 0x80000001}, // smallest subnormals
    {0x000fffffffffffff, 0x007fffff},
    {0x800fffffffffffff, 0x807fffff}, // largest subnormals
    {0x0010000000000000, 0x00800000},
    {0x7fefffffffffffff, 0x7f7fffff}, // smallest/largest normals
    {0x3ff0000000000001, 0x3f800001}, // 1 + 1 ulp
};

enum
{
    NORMAL,
    RAW,
    LIBM,
    SENTINEL = 0x1357
};
typedef struct
{
    uint64_t bits;
    uint32_t csr;
    int error;
} Observation;

static Observation observe(unsigned width, unsigned path, uint64_t bits, unsigned csr)
{
    Observation o = {0};
    struct
    {
        int before, value, after;
    } cell = {0x2468, SENTINEL, 0x369a};
    errno = SENTINEL;
    _mm_setcsr(csr);
    if (path == RAW)
    {
        o.bits = width == 32 ? raw32(UINT64_C(0xa5c35a9600000000) | bits, &cell.value) : raw64(bits, &cell.value);
    }
    else if (width == 32)
    {
        uint32_t u = (uint32_t)bits;
        float f;
        memcpy(&f, &u, sizeof(f));
        f = path == NORMAL ? root32(f) : sqrtf(f);
        memcpy(&u, &f, sizeof(u));
        o.bits = u;
    }
    else
    {
        double d;
        memcpy(&d, &bits, sizeof(d));
        d = path == NORMAL ? root64(d) : sqrt(d);
        memcpy(&o.bits, &d, sizeof(d));
    }
    o.csr = _mm_getcsr();
    o.error = path == RAW ? cell.value : errno;
    if (cell.before != 0x2468 || cell.after != 0x369a || (path == RAW && errno != SENTINEL))
    {
        _exit(3);
    }
    return o;
}

// On a negative finite input the invalid trap must see EDOM. A signaling NaN
// traps at UCOMIS with the sentinel still present.
static int *trap_cell;
static int trap_expected;
static void invalid_trap(int sig, siginfo_t *info, void *data)
{
    ucontext_t *ctx = data;
    unsigned csr = ctx->uc_mcontext.fpregs->mxcsr;
    _exit(sig == SIGFPE && info->si_code == FPE_FLTINV && (csr & 0x81) == 1 && *trap_cell == trap_expected ? 0 : 4);
}

static int check_trap(unsigned width, unsigned path, unsigned nan, unsigned csr)
{
    pid_t pid = fork();
    if (pid == 0)
    {
        struct sigaction act = {0};
        act.sa_sigaction = invalid_trap;
        act.sa_flags = SA_SIGINFO;
        sigemptyset(&act.sa_mask);
        if (sigaction(SIGFPE, &act, NULL) != 0)
        {
            _exit(5);
        }
        int cell = SENTINEL;
        errno = SENTINEL;
        trap_cell = path == RAW ? &cell : &errno;
        trap_expected = nan ? SENTINEL : EDOM;
        uint64_t bits = width == 32 ? inputs[nan ? 10 : 5].f : inputs[nan ? 10 : 5].d;
        _mm_setcsr(csr & ~0x80u);
        if (path == RAW)
        {
            if (width == 32)
            {
                raw32(bits, &cell);
            }
            else
            {
                raw64(bits, &cell);
            }
        }
        else
        {
            observe(width, NORMAL, bits, csr & ~0x80u);
        }
        _exit(6);
    }
    int status = 0;
    return pid > 0 && waitpid(pid, &status, 0) == pid && WIFEXITED(status) && WEXITSTATUS(status) == 0;
}

int main(void)
{
    const unsigned seeds[] = {0, 0x20, 0x15, 0x3f};
    const unsigned original = _mm_getcsr();
    const unsigned initial = (original & ~0xe07fu) | 0x1f80u;
    _Alignas(16) unsigned char saved[512];
    __asm__ volatile("fxsave %0" : "=m"(saved));
    uint32_t mask;
    memcpy(&mask, saved + 28, sizeof(mask));
    if (mask == 0)
    {
        mask = 0xffbf;
    }
    unsigned rows = 0, modes = 0, traps = 0;
    for (unsigned rc = 0; rc < 4; ++rc)
    {
        for (unsigned mode = 0; mode < 4; ++mode)
        {
            unsigned config = (rc << 13) | ((mode & 1) ? 0x40u : 0) | ((mode & 2) ? 0x8000u : 0);
            if ((config & ~mask) != 0)
            {
                continue;
            }
            ++modes;
            for (unsigned f = 0; f < sizeof(seeds) / sizeof(seeds[0]); ++f)
            {
                unsigned csr = initial | config | seeds[f];
                for (unsigned w = 32; w <= 64; w += 32)
                {
                    for (unsigned i = 0; i < sizeof(inputs) / sizeof(inputs[0]); ++i)
                    {
                        uint64_t bits = w == 32 ? inputs[i].f : inputs[i].d;
                        Observation n = observe(w, NORMAL, bits, csr);
                        Observation r = observe(w, RAW, bits, csr);
                        Observation l = observe(w, LIBM, bits, csr);
                        _mm_setcsr(original);
                        int domain = i == 5 || i == 7 || ((i == 13 || i == 15) && !(config & 0x40));
                        printf("%u %04x %02x %016" PRIx64 " %016" PRIx64 " %04x %d\n", w, config, seeds[f], bits, n.bits, n.csr,
                               n.error);
                        if (n.bits != r.bits || n.bits != l.bits || n.csr != r.csr || n.csr != l.csr || n.error != r.error ||
                            n.error != l.error || n.error != (domain ? EDOM : SENTINEL) || ((n.csr ^ csr) & ~0x3fu) ||
                            (n.csr & seeds[f]) != seeds[f])
                        {
                            fprintf(stderr,
                                    "mismatch w=%u i=%u csr=%04x normal=%016" PRIx64 "/%04x/%d raw=%016" PRIx64
                                    "/%04x/%d libm=%016" PRIx64 "/%04x/%d\n",
                                    w, i, csr, n.bits, n.csr, n.error, r.bits, r.csr, r.error, l.bits, l.csr, l.error);
                            return 1;
                        }
                        ++rows;
                    }
                }
            }
        }
    }
    for (unsigned w = 32; w <= 64; w += 32)
    {
        for (unsigned path = NORMAL; path <= RAW; ++path)
        {
            for (unsigned nan = 0; nan < 2; ++nan)
            {
                if (check_trap(w, path, nan, initial))
                {
                    ++traps;
                }
            }
        }
    }
    fprintf(stderr, "%u observations, %u MXCSR modes, mask=%08x; %u/8 invalid-trap checks\n", rows, modes, mask, traps);
    return traps == 8 ? 0 : 2;
}
