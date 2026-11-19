/* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
/* The prefix ends immediately before LDTILECFG; the assembly jumps back to captured. */
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef void Prefix(void);
extern void capture(const uint64_t args[6], void* entry, uint64_t registers[9], Prefix* prefix);
#define BUSTER_CBUILTIN_AMX(id, ...) extern Prefix prefix_##id;
#include "c_builtin_amx_leaves.inc"
#undef BUSTER_CBUILTIN_AMX
extern Prefix bad_guard, bad_reserved, bad_argument;

typedef enum { ZERO, LOAD, STORE, DOT, ROW } Family;
static const struct { const char* name; Family family; Prefix* prefix; } cases[] = {
#define BUSTER_CBUILTIN_AMX(id, name, family, ...) { #id, family, prefix_##id },
#include "c_builtin_amx_leaves.inc"
#undef BUSTER_CBUILTIN_AMX
};

enum { IMAGE = 1, GUARD = 2, REGISTERS = 4 };
static unsigned run(Prefix* prefix, Family family, uint64_t m, uint64_t n, uint64_t k, unsigned residue, FILE* output)
{
    _Alignas(64) uint8_t stack[384];
    uint8_t expected[sizeof(stack)];
    const unsigned entry = 192 + residue;
    const unsigned frame = (entry - 8 - 64) & ~63u;
    const uint64_t saved_fp = UINT64_C(0xfedcba9876543210);
    const uint64_t output_pointer = UINT64_C(0x5123456789abcdef);
    const uint64_t args[6] = { m, n, family == DOT ? k : family == ZERO ? output_pointer : UINT64_C(0x234567891100),
                               family == ROW ? 2 : UINT64_C(0x345678912200), UINT64_C(0x456789123300), UINT64_C(0x567891234400) };
    uint64_t registers[9];
    memset(stack, 0xa5, sizeof(stack));
    memcpy(stack + entry + 8, &output_pointer, 8);
    memcpy(expected, stack, sizeof(stack));
    memcpy(expected + entry - 8, &saved_fp, 8);
    uint8_t* cfg = expected + frame;
    memset(cfg, 0, 64);
    cfg[0] = 1;
    cfg[16] = (uint8_t)n;
    cfg[17] = (uint8_t)(n >> 8);
    cfg[48] = (uint8_t)m;
    if (family == DOT)
    {
        cfg[18] = (uint8_t)k;
        cfg[19] = (uint8_t)(k >> 8);
        cfg[20] = (uint8_t)n;
        cfg[21] = (uint8_t)(n >> 8);
        cfg[49] = (uint8_t)m;
        cfg[50] = (uint8_t)(k >> 2);
    }
    capture(args, stack + entry, registers, prefix);
    unsigned errors = 0;
    if (memcmp(stack + frame, cfg, 64) != 0) errors |= IMAGE;
    if (memcmp(stack, expected, frame) || memcmp(stack + frame + 64, expected + frame + 64, sizeof(stack) - frame - 64)) errors |= GUARD;
    if (registers[0] != (uintptr_t)(stack + frame) || registers[1] != (uintptr_t)(stack + entry - 8) ||
        memcmp(registers + 2, args, sizeof(args)) || registers[8] != (family == DOT ? output_pointer : UINT64_C(0x8989898989898989)))
        errors |= REGISTERS;
    if (output && fwrite(stack + frame, 1, 64, output) != 64) errors |= IMAGE;
    return errors;
}

int main(int argc, char** argv)
{
    if (argc != 2) return 1;
    FILE* output = fopen(argv[1], "wb");
    if (output == NULL) return 1;
    static const uint16_t dims[][3] = { {0,0,0}, {1,4,4}, {3,20,12}, {16,64,64}, {7,37,22}, {0x123,0x12ab,0x3456} };
    unsigned snapshots = 0;
    for (size_t i = 0; i < sizeof(cases) / sizeof(*cases); ++i)
        for (size_t d = 0; d < sizeof(dims) / sizeof(*dims); ++d)
            for (unsigned residue = 8; residue < 64; residue += 16)
            {
                unsigned errors = run(cases[i].prefix, cases[i].family, dims[d][0], dims[d][1], dims[d][2], residue, output);
                if (errors) { fprintf(stderr, "%s dimensions %zu, RSP mod 64 = %u, error bits %u\n", cases[i].name, d, residue, errors); return 1; }
                ++snapshots;
            }
    if (fclose(output)) return 1;
    if (run(bad_guard, ZERO, 3, 20, 12, 56, NULL) != GUARD || run(bad_reserved, ZERO, 3, 20, 12, 56, NULL) != IMAGE ||
        run(bad_argument, ZERO, 3, 20, 12, 56, NULL) != REGISTERS) return 1;
    printf("%u exact 64-byte captures; surrounding stack and live GPRs match. Three injected faults detected.\n", snapshots);
    return 0;
}
