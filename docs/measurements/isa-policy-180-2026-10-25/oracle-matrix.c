// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Diagnostic driver: append the frozen x86_target_test_gas function and the main below to this preamble.
// It isolates the repository's exact architecture differential from unrelated frontend/backend compilation.
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wmissing-field-initializers"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_encoder_test.c"
#include "buster/compiler/x86_target_forms.c"
#pragma clang diagnostic pop

static bool pp_test_read_output(FILE* file, char** text, size_t* length)
{
    bool passed = fflush(file) == 0 && fseek(file, 0, SEEK_END) == 0;
    const long bytes = passed ? ftell(file) : -1;
    passed &= bytes >= 0 && bytes < 16 * 1024 * 1024;
    char* buffer = passed ? malloc((size_t)bytes + 1) : 0;
    passed &= buffer != 0;
    if (passed)
    {
        passed = fseek(file, 0, SEEK_SET) == 0 && fread(buffer, 1, (size_t)bytes, file) == (size_t)bytes && !ferror(file);
    }
    if (passed)
    {
        buffer[bytes] = 0;
        *text = buffer;
        *length = (size_t)bytes;
    }
    else
    {
        free(buffer);
    }
    return passed;
}
static bool x86_target_test_gas(const char* directory)
{
    // GAS 2.47's dual FMA/AVX512F templates admit these explicit EVEX forms without AVX512VL. Keep the
    // architectural policy strict: the independent minimal-feature tests above require F and VL for every row.
    // Count this external-oracle gap only where GAS accepts it; a corrected assembler follows the normal check.
    static const uint8_t gas_vl_fma[X86_FORM_COUNT] = {
#define BUSTER_X86_TARGET_GAS_VL(name, ...) [X86_FORM_##name] = 1,
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFMADD, "vfmadd", 0x98)
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFMSUB, "vfmsub", 0x9a)
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFNMADD, "vfnmadd", 0x9c)
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFNMSUB, "vfnmsub", 0x9e)
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFMADDSUB, "vfmaddsub", 0x96)
        BUSTER_X86_AVX512VL_FMA_PACKED_FORMS(BUSTER_X86_TARGET_GAS_VL, VFMSUBADD, "vfmsubadd", 0x97)
#undef BUSTER_X86_TARGET_GAS_VL
    };
    static const struct
    {
        const char* profile;
        const char* cpu;
        uint64_t disabled;
    } configurations[] = {
        { "znver5", "znver5", 0 }, // Syntax/operand control, before any negative architecture case.
        { "x86-64", "generic64", 0 },
        // GAS tracks FISTTP separately from SSE3, without an extension option. Nocona supplies both; remove MONITOR.
        { "x86-64-v2", "nocona+nomonitor+sse3+ssse3+sse4.1+sse4.2+popcnt+cx16+lahf_sahf", 0 },
        { "x86-64-v3", "nocona+nomonitor+sse3+ssse3+sse4.1+sse4.2+popcnt+cx16+lahf_sahf+avx+avx2+bmi+bmi2+f16c+fma+lzcnt+movbe+xsave", 0 },
        { "x86-64-v4", "nocona+nomonitor+sse3+ssse3+sse4.1+sse4.2+popcnt+cx16+lahf_sahf+avx+avx2+bmi+bmi2+f16c+fma+lzcnt+movbe+xsave+avx512f+avx512bw+avx512cd+avx512dq+avx512vl", 0 },
        { "znver5", "znver5+nofma", BUSTER_X86_FEATURE(FMA) },
        { "znver5", "znver5+noavx512vl", BUSTER_X86_FEATURE(AVX512VL) },
        { "znver5", "znver5+noavx512bw", BUSTER_X86_FEATURE(AVX512BW) },
        { "znver5", "znver5+noavx512dq", BUSTER_X86_FEATURE(AVX512DQ) },
        { "znver5", "znver5+nobmi2", BUSTER_X86_FEATURE(BMI2) },
        { "znver5", "znver5+nopopcnt", BUSTER_X86_FEATURE(POPCNT) },
    };
    char source[4096];
    snprintf(source, sizeof(source), "%s/forms.s", directory);
    FILE* file = fopen(source, "w");
    bool passed = file != 0;
    uint16_t forms[X86_FORM_COUNT];
    uint32_t count = 0;
    uint64_t random = 180;
    if (file != 0)
    {
        fputs(".intel_syntax noprefix\n.text\n", file);
        for (uint32_t form = 1; form < X86_FORM_COUNT; form += 1)
        {
            if (x86_target_requirements[form] != 0)
            {
                X86Instruction instruction = x86_random_instruction(&random, (uint16_t)form, true);
                // This oracle checks canonical forms. Optional FS/GS prefixes have no separate ISA requirement,
                // and GAS warns when one has no effect (LEA). Flagged records are covered by the raw-form tests.
                instruction.form = (uint16_t)form;
                // The printer spells absolute memory with DS even without a form override. LEA ignores that
                // segment too; use a RIP-relative operand with the same ISA requirement for the control.
                if ((form == X86_FORM_LEA_R16_M || form == X86_FORM_LEA_R32_M || form == X86_FORM_LEA_R64_M) && instruction.mode == BUSTER_X86_MEMORY_ABSOLUTE)
                {
                    instruction.mode = BUSTER_X86_MEMORY_RIP;
                }
                passed &= x86_validate(&instruction, 1) == 1;
                x86_print_instruction(file, &instruction, 0);
                fputc('\n', file);
                forms[count++] = (uint16_t)form;
            }
        }
        passed &= ferror(file) == 0;
        passed &= fclose(file) == 0;
    }
    uint64_t checks = 0;
    uint32_t gaps = 0;
    for (uint32_t c = 0; passed && c < BUSTER_ARRAY_LENGTH(configurations); c += 1)
    {
        char march[512];
        snprintf(march, sizeof(march), "-march=%s", configurations[c].cpu);
        FILE* errors = tmpfile();
        fflush(0);
        const pid_t child = errors != 0 ? fork() : -1;
        if (child == 0)
        {
            if (setenv("LC_ALL", "C", 1) != 0 || dup2(fileno(errors), STDERR_FILENO) < 0)
            {
                _exit(126);
            }
            execlp("as", "as", "--64", march, "-o", "/dev/null", source, (char*)0);
            _exit(127);
        }
        int status = 0;
        pid_t waited;
        do
        {
            waited = child > 0 ? waitpid(child, &status, 0) : -1;
        }
        while (child > 0 && waited < 0 && errno == EINTR);
        char* diagnostics = 0;
        size_t length = 0;
        bool ready = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) <= 1 && errors != 0 && pp_test_read_output(errors, &diagnostics, &length);
        uint8_t rejected[X86_FORM_COUNT] = {0};
        uint32_t refusals = 0;
        char* cursor = diagnostics;
        while (ready && cursor != 0 && *cursor != 0)
        {
            char* end = strchr(cursor, '\n');
            if (end != 0)
            {
                *end = 0;
            }
            if (strstr(cursor, "Error:") != 0)
            {
                const size_t prefix = strlen(source);
                char* number = strncmp(cursor, source, prefix) == 0 && cursor[prefix] == ':' ? cursor + prefix + 1 : 0;
                char* after = 0;
                const unsigned long line = number != 0 ? strtoul(number, &after, 10) : 0;
                const bool placed = line >= 3 && line - 3 < count && after != number && after != 0 && *after == ':';
                // GAS also uses its ordinary error category for an internal assembler failure.
                const bool internal = placed && strncmp(after, ": Error: internal error", sizeof(": Error: internal error") - 1) == 0;
                const bool refusal = placed && c != 0 && !internal && strncmp(after, ": Error: ", sizeof(": Error: ") - 1) == 0;
                ready &= refusal;
                if (refusal)
                {
                    rejected[line - 3] = 1;
                    refusals += 1;
                }
                else
                {
                    fprintf(stderr, "target GAS %s: unexpected diagnostic: %s\n", march, cursor);
                }
            }
            else if (*cursor != 0)
            {
                const size_t prefix = strlen(source);
                const bool header = strncmp(cursor, source, prefix) == 0 && strcmp(cursor + prefix, ": Assembler messages:") == 0;
                if (!header)
                {
                    fprintf(stderr, "target GAS %s: unexpected diagnostic: %s\n", march, cursor);
                    ready = false;
                }
            }
            cursor = end != 0 ? end + 1 : 0;
        }
        ready &= WEXITSTATUS(status) == (refusals != 0 ? 1 : 0);
        ready &= c != 0 || refusals == 0;
        X86Target target = {0};
        ready &= x86_target_parse(configurations[c].profile, strlen(configurations[c].profile), &target);
        target.features &= ~configurations[c].disabled;
        uint8_t allowed[X86_FORM_COUNT];
        x86_target_forms(&target, allowed);
        for (uint32_t i = 0; ready && i < count; i += 1)
        {
            const bool gap = configurations[c].disabled == BUSTER_X86_FEATURE(AVX512VL) && gas_vl_fma[forms[i]] && !rejected[i];
            if (gap)
            {
                passed &= allowed[forms[i]] == 0;
                gaps += 1;
            }
            else if ((allowed[forms[i]] != 0) == (rejected[i] != 0))
            {
                fprintf(stderr, "target GAS %s: form %u (%s), policy %u, oracle %u\n", march, forms[i], x86_form_descriptions[forms[i]].mnemonic, allowed[forms[i]], !rejected[i]);
                passed = false;
            }
            checks += !gap;
        }
        passed &= ready;
        if (errors != 0)
        {
            fclose(errors);
        }
        free(diagnostics);
    }
    unlink(source);
    printf("target forms against GAS architecture gate: %s (%llu comparisons, %u explicit GAS AVX512VL/FMA gaps; independent feature removals)\n", passed ? "pass" : "FAIL", (unsigned long long)checks, gaps);
    return passed;
}
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
int main(void)
{
    char directory[] = "/tmp/buster-180-oracle-XXXXXX";
    bool passed = x86_encoder_initialize() && mkdtemp(directory) != 0;
    if (passed)
    {
        passed = x86_target_test_gas(directory);
        passed &= rmdir(directory) == 0;
    }
    return passed ? 0 : 1;
}
