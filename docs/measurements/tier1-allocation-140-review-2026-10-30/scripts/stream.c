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

static __attribute__((noinline)) bool stream_assign(Stream* stream, uint32_t gpr_mask, uint32_t vector_mask)
{
    const Stream s = *stream;
    uint64_t free = gpr_mask | ((uint64_t)vector_mask << 32);
    uint64_t lost = 0;
    for (uint32_t i = 0; i < s.count; i += 1)
    {
        for (uint32_t k = 0; k < SLOTS; k += 1)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint32_t bit = s.value_register[s.ops[slot]];
            s.physical[slot] = (uint8_t)(bit & 31);
            free |= (uint64_t)s.kill[slot] << bit;
        }
        const uint64_t class_mask = s.classes[i] != 0 ? 0xffffffff00000000u : 0xffffffffu;
        const uint64_t available = free & class_mask;
        lost |= available == 0;
        const uint32_t bit = (uint32_t)__builtin_ctzll(available | 0x8000000000000000u);
        free &= ~(1ull << bit);
        s.value_register[i] = (uint8_t)bit;
        s.def_physical[i] = (uint8_t)(bit & 31);
    }
    return lost == 0;
}

// The same assignment, with the last two definitions' registers forwarded in registers: a use of one of them doesn't
// wait for its store to reach the load (store-to-load forwarding on the def-to-use chain).
static __attribute__((noinline)) bool stream_assign_forward(Stream* stream, uint32_t gpr_mask, uint32_t vector_mask)
{
    const Stream s = *stream;
    uint64_t free = gpr_mask | ((uint64_t)vector_mask << 32);
    uint64_t lost = 0;
    uint32_t value1 = UINT32_MAX;
    uint32_t value2 = UINT32_MAX;
    uint32_t bit1 = 0;
    uint32_t bit2 = 0;
    for (uint32_t i = 0; i < s.count; i += 1)
    {
        for (uint32_t k = 0; k < SLOTS; k += 1)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint32_t v = s.ops[slot];
            const uint32_t stored = s.value_register[v];
            const uint32_t bit = v == value1 ? bit1 : v == value2 ? bit2 : stored;
            s.physical[slot] = (uint8_t)(bit & 31);
            free |= (uint64_t)s.kill[slot] << bit;
        }
        const uint64_t class_mask = s.classes[i] != 0 ? 0xffffffff00000000u : 0xffffffffu;
        const uint64_t available = free & class_mask;
        lost |= available == 0;
        const uint32_t bit = (uint32_t)__builtin_ctzll(available | 0x8000000000000000u);
        free &= ~(1ull << bit);
        s.value_register[i] = (uint8_t)bit;
        s.def_physical[i] = (uint8_t)(bit & 31);
        value2 = value1;
        bit2 = bit1;
        value1 = i;
        bit1 = bit;
    }
    return lost == 0;
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

static uint64_t random_state = 0x9e3779b97f4a7c15u;
static uint32_t random_next(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 7;
    random_state ^= random_state << 17;
    return (uint32_t)(random_state >> 11);
}

// The lifetimes of harness.c's shapes 4 (temps-fit: 5% long values) and 6 (one chain): value i is read once, by the
// instruction where its interval [2i+1, 2(i+length)) ends, or by the next one with a free slot.
static void generate(Stream* s, uint32_t shape, uint32_t count)
{
    random_state = 0x9e3779b97f4a7c15u;
    s->count = count;
    s->none = count;
    for (uint32_t slot = 0; slot < count * SLOTS; slot += 1)
    {
        s->ops[slot] = s->none;
    }
    uint8_t* used = calloc(count, 1);
    for (uint32_t i = 0; i < count; i += 1)
    {
        uint32_t length = 1;
        uint8_t class = 0;
        if (shape == 4)
        {
            const uint32_t percent = random_next() % 100;
            length = percent < 5 ? 10 + random_next() % 190 : 1 + random_next() % 3;
            class = (uint8_t)(i % 4 == 0 ? 1 : 0);
        }
        s->classes[i] = class;
        uint32_t reader = i + length;
        while (reader < count && used[reader] == SLOTS)
        {
            reader += 1;
        }
        if (reader < count)
        {
            s->ops[reader * SLOTS + used[reader]] = i;
            used[reader] += 1;
        }
    }
    s->classes[s->none] = 0;
    s->value_register[s->none] = 0;
    free(used);
}

int main(void)
{
    const int descriptor = cycles_open();
    const uint32_t shapes[] = { 4, 4, 6, 6 };
    const uint32_t counts[] = { 4096, 65536, 4096, 65536 };
    const char* names[] = { "temps-fit", "temps-fit", "one-chain", "one-chain" };
    bool valid = true;
    printf("instruction-stream allocation, %u use slots per instruction, 16 registers per class: cycles per instruction (harness.c's per-interval unit), median of %u\n", SLOTS, SAMPLES);
    for (uint32_t w = 0; valid && w < 4; w += 1)
    {
        const uint32_t count = counts[w];
        Stream s = { 0 };
        s.ops = malloc((uint64_t)count * SLOTS * 4);
        s.classes = malloc((uint64_t)count + 1);
        s.kill = malloc((uint64_t)count * SLOTS);
        s.physical = malloc((uint64_t)count * SLOTS);
        s.def_physical = malloc(count);
        s.live = malloc((uint64_t)count + 1);
        s.last = malloc(((uint64_t)count + 1) * 4);
        s.value_register = malloc((uint64_t)count + 1);
        generate(&s, shapes[w], count);
        uint8_t* kill_copy = malloc((uint64_t)count * SLOTS);
        stream_kills_backward(&s);
        memcpy(kill_copy, s.kill, (uint64_t)count * SLOTS);
        stream_kills_last(&s);
        valid = memcmp(kill_copy, s.kill, (uint64_t)count * SLOTS) == 0;
        valid = valid && stream_assign(&s, 0xffff, 0xffff) && stream_check(&s);
        uint32_t repetitions = 1;
        uint64_t elapsed = 0;
        while (valid && elapsed < 2000000)
        {
            const uint64_t begin = now_ns();
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                stream_kills_backward(&s);
                valid &= stream_assign(&s, 0xffff, 0xffff);
            }
            elapsed = now_ns() - begin;
            repetitions = elapsed < 2000000 ? repetitions * 2 : repetitions;
        }
        double backward[SAMPLES];
        double last[SAMPLES];
        double assign[SAMPLES];
        double forward[SAMPLES];
        for (uint32_t pass = 0; valid && pass < SAMPLES; pass += 1)
        {
            const uint64_t c0 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                stream_kills_backward(&s);
            }
            const uint64_t c1 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                stream_kills_last(&s);
            }
            const uint64_t c2 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign(&s, 0xffff, 0xffff);
            }
            const uint64_t c3 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_forward(&s, 0xffff, 0xffff);
            }
            const uint64_t c4 = cycles_read(descriptor);
            forward[pass] = (double)(c4 - c3) / repetitions / count;
            backward[pass] = (double)(c1 - c0) / repetitions / count;
            last[pass] = (double)(c2 - c1) / repetitions / count;
            assign[pass] = (double)(c3 - c2) / repetitions / count;
        }
        valid = valid && stream_check(&s);
        uint8_t* physical_copy = malloc((uint64_t)count * SLOTS);
        memcpy(physical_copy, s.physical, (uint64_t)count * SLOTS);
        valid = valid && stream_assign(&s, 0xffff, 0xffff) && stream_check(&s);
        valid = valid && memcmp(physical_copy, s.physical, (uint64_t)count * SLOTS) == 0;
        free(physical_copy);
        printf("%-10s %6u instructions: kills backward %.2f, kills by last reader %.2f, assignment %.2f, with forwarding %.2f cycles/instruction\n", names[w], count, median(backward), median(last), median(assign), median(forward));
        free(kill_copy);
    }
    return valid ? 0 : 1;
}
