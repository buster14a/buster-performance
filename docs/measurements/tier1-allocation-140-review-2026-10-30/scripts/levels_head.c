// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Measurement harness for buster #140's review (buster-performance record).
// Scratch prototype for the #140 review: the same lifetimes as harness.c's temps/one-chain workloads, given to an
// allocator as the instruction stream the selector already has, with two fixed use slots per instruction, instead of
// as intervals. Kills: last-use bits, either from a backward liveness scan or from a forward "last writer" store pass
// followed by a compare pass (no loop-carried dependency). Assignment: one 64-bit free mask held in a register (GPRs
// in bits 0..31, vectors in 32..63); killed uses free their register, each definition takes the lowest free one, and
// physical registers are written beside the operands. No sort, no events, no fragments. An independent simulation
// checks that every use reads the value it names.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <time.h>
#include <unistd.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <immintrin.h>

#define SAMPLES 11
#define SLOTS 2

typedef struct Stream Stream;
struct Stream
{
    uint32_t count;           // instructions; instruction i defines value i
    uint32_t none;            // the value id of an empty slot (count): always live, never killed
    uint32_t* ops;            // SLOTS use slots per instruction
    uint8_t* classes;         // per value, plus the empty slot's
    uint8_t* kill;            // per slot
    uint8_t* physical;        // per slot
    uint8_t* def_physical;    // per instruction
    uint8_t* live;            // scratch, per value
    uint32_t* last;           // scratch, per value: the last slot that reads it
    uint8_t* value_register;  // scratch, per value: register + 32 * class
};

static uint64_t now_ns(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000u + (uint64_t)time.tv_nsec;
}

static int cycles_open(void)
{
    struct perf_event_attr attributes = {
        .type = PERF_TYPE_HARDWARE,
        .size = sizeof(struct perf_event_attr),
        .config = PERF_COUNT_HW_CPU_CYCLES,
        .exclude_kernel = 1,
        .exclude_hv = 1,
    };
    return (int)syscall(SYS_perf_event_open, &attributes, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
}

static uint64_t cycles_read(int descriptor)
{
    uint64_t cycles = 0;
    if (descriptor < 0 || read(descriptor, &cycles, sizeof(cycles)) != sizeof(cycles))
    {
        cycles = 0;
    }
    return cycles;
}

static double median(double* samples)
{
    for (uint32_t i = 1; i < SAMPLES; i += 1)
    {
        for (uint32_t j = i; j > 0 && samples[j - 1] > samples[j]; j -= 1)
        {
            const double swap = samples[j];
            samples[j] = samples[j - 1];
            samples[j - 1] = swap;
        }
    }
    return samples[SAMPLES / 2];
}

// Kills by a backward scan: a use kills when its value isn't live after the instruction.
static __attribute__((noinline)) void stream_kills_backward(Stream* stream)
{
    const Stream s = *stream;
    memset(s.live, 0, s.count);
    s.live[s.none] = 1;
    for (uint32_t i = s.count; i-- > 0;)
    {
        s.live[i] = 0;
        for (uint32_t k = SLOTS; k-- > 0;)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint32_t v = s.ops[slot];
            s.kill[slot] = (uint8_t)(s.live[v] ^ 1);
            s.live[v] = 1;
        }
        s.live[s.none] = 1;
    }
}

// Kills by two independent passes: the last store to last[v] is its last reader's slot; a slot kills iff it is that.
static __attribute__((noinline)) void stream_kills_last(Stream* stream)
{
    const Stream s = *stream;
    const uint32_t slots = s.count * SLOTS;
    for (uint32_t slot = 0; slot < slots; slot += 1)
    {
        s.last[s.ops[slot]] = slot;
    }
    s.last[s.none] = UINT32_MAX;
    for (uint32_t slot = 0; slot < slots; slot += 1)
    {
        s.kill[slot] = s.last[s.ops[slot]] == slot;
    }
}


static bool stream_check(const Stream* s)
{
    uint32_t owner[2][32];
    memset(owner, 0xff, sizeof(owner));
    bool valid = true;
    for (uint32_t i = 0; valid && i < s->count; i += 1)
    {
        for (uint32_t k = 0; valid && k < SLOTS; k += 1)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint32_t v = s->ops[slot];
            valid = v == s->none || (s->physical[slot] < 32 && owner[s->classes[v]][s->physical[slot]] == v);
        }
        valid = valid && s->def_physical[i] < 32;
        if (valid)
        {
            owner[s->classes[i]][s->def_physical[i]] = i;
        }
    }
    return valid;
}

