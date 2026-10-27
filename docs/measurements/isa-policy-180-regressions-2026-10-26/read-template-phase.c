// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Gate complete private diagnostic captures. This is not production acceptance.
#define main legacy_encoder_receipt_main
#include "read-current-encoder.c"
#undef main
#include <inttypes.h>

typedef struct PhaseMeasurement
{
    uint64_t phase;
    uint64_t step;
    uint64_t order;
    uint64_t address;
    uint64_t modulo;
    uint64_t allocations;
    uint64_t identity;
    double values[9];
} PhaseMeasurement;

static bool phase_decimal(const char* text, double* value)
{
    char* end = 0;
    errno = 0;
    *value = strtod(text, &end);
    return text[0] != 0 && end != text && *end == 0 && errno == 0 && isfinite(*value);
}

static bool phase_header(const char* line, uint64_t flags, uint64_t after)
{
    char digits[4][32] = {{0}};
    uint64_t numbers[3] = {0};
    int end = 0;
    const int fields = sscanf(line, "%31[0-9] mixed instructions, %31[0-9] bytes (%31[0-9.] per instruction), in calls of %31[0-9]%n", digits[0], digits[1], digits[2], digits[3], &end);
    bool okay = fields == 4 && unsigned_number(digits[0], &numbers[0]) && unsigned_number(digits[1], &numbers[1]) && unsigned_number(digits[3], &numbers[2]);
    okay &= numbers[0] == 65536 && numbers[2] == 65536 && numbers[1] == 259726;
    char fixups[96] = {0};
    if (okay && (flags & 2) != 0)
    {
        const char* marker = strstr(line + end, ", with fixup ends (");
        char marked_text[32] = {0};
        uint64_t marked = 0;
        okay &= marker != 0 && sscanf(marker, ", with fixup ends (%31[0-9] marked)", marked_text) == 1 && unsigned_number(marked_text, &marked) && marked == 3825;
        snprintf(fixups, sizeof(fixups), ", with fixup ends (%" PRIu64 " marked)", marked);
    }
    char expected[1024];
    snprintf(expected, sizeof(expected), "65536 mixed instructions, %" PRIu64 " bytes (%.2f per instruction), in calls of 65536%s%s; 21 interleaved passes of 64 runs%s, medians (cycles also min-max):\n", numbers[1], (double)numbers[1] / 65536.0,
             (flags & 1) != 0 ? ", with offsets" : "", fixups, after != 0 ? ", each after 30 ms of the scalar loop" : "");
    okay &= strcmp(line, expected) == 0;
    return okay;
}

int main(int argc, char** argv)
{
    bool okay = argc == 5 && strlen(argv[1]) < 1800;
    uint64_t options[3] = {0};
    for (unsigned i = 0; okay && i < 3; i += 1)
    {
        okay &= unsigned_number(argv[i + 2], &options[i]);
    }
    okay &= options[0] < 3 && options[1] < 4 && (options[2] == 0 || options[2] == 30);
    char path[2048], line[4096] = {0};
    FILE* file = 0;
    if (okay)
    {
        snprintf(path, sizeof(path), "%s/exit.txt", argv[1]);
        file = fopen(path, "rb");
        okay &= file != 0 && fgets(line, sizeof(line), file) != 0 && strcmp(line, "0\n") == 0 && fgetc(file) == EOF;
        if (file != 0)
        {
            okay &= !ferror(file);
            okay &= fclose(file) == 0;
        }
        snprintf(path, sizeof(path), "%s/stderr.log", argv[1]);
        okay &= empty_file(path);
        snprintf(path, sizeof(path), "%s/stdout.log", argv[1]);
        file = okay ? fopen(path, "rb") : 0;
        okay &= file != 0;
    }
    PhaseMeasurement samples[64] = {0};
    uint64_t seen = 0, base = 0, allocation_identity = 0;
    char first_header[4096] = {0};
    const unsigned strides[] = {17, 19, 23};
    const unsigned shifts[] = {0, 21, 43};
    for (unsigned step = 0; okay && step < 64; step += 1)
    {
        PhaseMeasurement* sample = &samples[step];
        char digits[5][32] = {{0}};
        int end = 0;
        okay &= fgets(line, sizeof(line), file) != 0 && sscanf(line, "phase=%31[0-9] step=%31[0-9] order=%31[0-9] template=%31[0-9] mod4096=%31[0-9]%n", digits[0], digits[1], digits[2], digits[3], digits[4], &end) == 5 && line_end(line + end);
        uint64_t* integers[] = {&sample->phase, &sample->step, &sample->order, &sample->address, &sample->modulo};
        for (unsigned i = 0; okay && i < 5; i += 1)
        {
            okay &= unsigned_number(digits[i], integers[i]);
        }
        char expected[1024];
        snprintf(expected, sizeof(expected), "phase=%" PRIu64 " step=%" PRIu64 " order=%" PRIu64 " template=%" PRIu64 " mod4096=%" PRIu64 "\n", sample->phase, sample->step, sample->order, sample->address, sample->modulo);
        okay &= strcmp(line, expected) == 0 && sample->step == step && sample->order == options[0] && sample->phase < 64;
        if (okay)
        {
            okay &= sample->phase == ((step * strides[options[0]] + shifts[options[0]]) & 63) && (seen & (UINT64_C(1) << sample->phase)) == 0 && sample->address >= 64 * sample->phase && sample->modulo == (sample->address & 4095);
            const uint64_t current_base = sample->address - 64 * sample->phase;
            if (step == 0)
            {
                base = current_base;
            }
            okay &= current_base == base && (base & 4095) == 64;
            seen |= UINT64_C(1) << sample->phase;
        }
        okay &= fgets(line, sizeof(line), file) != 0 && phase_header(line, options[1], options[2]);
        if (step == 0)
        {
            memcpy(first_header, line, sizeof(first_header));
        }
        okay &= strcmp(line, first_header) == 0;
        char decimal[9][64] = {{0}};
        end = 0;
        okay &= fgets(line, sizeof(line), file) != 0 && sscanf(line, " x86_encode_16 %63[0-9.] ns %63[0-9.] M/s %63[0-9.] GB/s %63[0-9.] cycles [%63[0-9.]-%63[0-9.]] %63[0-9.] instructions IPC %63[0-9.] throttle %63[0-9.]%n", decimal[0], decimal[1], decimal[2], decimal[3], decimal[4], decimal[5], decimal[6], decimal[7], decimal[8], &end) == 9 && line_end(line + end);
        for (unsigned i = 0; okay && i < 9; i += 1)
        {
            okay &= phase_decimal(decimal[i], &sample->values[i]) && (i == 8 ? sample->values[i] >= 0 : sample->values[i] > 0);
        }
        okay &= sample->values[4] <= sample->values[3] && sample->values[3] <= sample->values[5];
        okay &= fgets(line, sizeof(line), file) != 0 && strcmp(line, "  (per encoded instruction; GB/s of machine code; throttle: PMCx1A0 umask 0x08, read as the dispatch slots the power cap takes)\n") == 0;
        end = 0;
        okay &= fgets(line, sizeof(line), file) != 0 && sscanf(line, "phase allocations: %31[0-9] identity=%31[0-9] stable=%31[0-9]%n", digits[0], digits[1], digits[2], &end) == 3 && line_end(line + end);
        uint64_t stable = 0;
        okay &= unsigned_number(digits[0], &sample->allocations) && unsigned_number(digits[1], &sample->identity) && unsigned_number(digits[2], &stable);
        snprintf(expected, sizeof(expected), "phase allocations: %" PRIu64 " identity=%" PRIu64 " stable=%" PRIu64 "\n", sample->allocations, sample->identity, stable);
        okay &= strcmp(line, expected) == 0 && sample->allocations == 46 && stable == 1;
        if (step == 0)
        {
            allocation_identity = sample->identity;
        }
        okay &= sample->identity == allocation_identity;
    }
    if (file != 0)
    {
        okay &= seen == UINT64_MAX && fgets(line, sizeof(line), file) != 0 && strcmp(line, "phase scan: pass; 64 phases, fixed executable and allocation addresses\n") == 0 && fgetc(file) == EOF && !ferror(file);
        okay &= fclose(file) == 0;
    }
    if (okay)
    {
        okay &= printf("phase,step,order,mod4096,ns,cycles,instructions,throttle,allocation_identity\n") >= 0;
        for (unsigned i = 0; okay && i < 64; i += 1)
        {
            const PhaseMeasurement* sample = &samples[i];
            okay &= printf("%" PRIu64 ",%" PRIu64 ",%" PRIu64 ",%" PRIu64 ",%.9g,%.9g,%.9g,%.9g,%" PRIu64 "\n", sample->phase, sample->step, sample->order, sample->modulo, sample->values[0], sample->values[3], sample->values[6], sample->values[8], sample->identity) >= 0;
        }
        okay &= fflush(stdout) == 0 && !ferror(stdout);
    }
    return okay ? 0 : 1;
}
