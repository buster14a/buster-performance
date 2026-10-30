// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Generate an UNTIMED diagnostic clone of #920's original lowering source.
// Every replacement requires one complete exact anchor. Production sources
// and previously created output files are never overwritten.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char producer_original[] =
    "        // In reverse, so that a node's declaration is its first token and each body's locals are linked in token order.\n"
    "        for (uint32_t d = check_program_declaring(input->declarations, input->initializer_nodes, nodes, count, declaring, BUSTER_SCALAR_PATH(scalar)); d-- > 0;)\n";

static const char producer_retained[] =
    "        const uint32_t declaring_count = check_program_declaring(input->declarations, input->initializer_nodes, nodes, count, declaring, BUSTER_SCALAR_PATH(scalar));\n"
    "        // In reverse, so that a node's declaration is its first token and each body's locals are linked in token order.\n"
    "        for (uint32_t d = declaring_count; d-- > 0;)\n";

static const char runtime_original[] =
    "        for (uint32_t declaration = 0; spelled && declaration < input->token_count; declaration += 1)\n"
    "        {\n"
    "            const uint32_t object = input->objects[declaration];\n"
    "            const uint32_t name = program->parser->tokens.names[declaration];\n"
    "            if (name != 0 && input->declarations[declaration] == declaration && input->linkage[declaration] == 2 && object != 0 && object < program->object_count)\n"
    "            {\n"
    "                for (uint32_t r = CHECK_LOWER_RUNTIME_ERRNO + 1; r < CHECK_LOWER_RUNTIMES; r += 1)\n"
    "                {\n"
    "                    if (identifiers[r] == name && shared->declared_runtimes[r] == 0)\n"
    "                    {\n"
    "                        shared->declared_runtimes[r] = program->object_symbols[object];\n"
    "                    }\n"
    "                }\n"
    "            }\n"
    "        }\n";

static const char runtime_candidate[] =
    "        if (spelled)\n"
    "        {\n"
    "            check_lower_declared_runtimes(program, declaring, declaring_count, identifiers, shared->declared_runtimes, BUSTER_SCALAR_PATH(scalar));\n"
    "        }\n";

static const char trace_base[] =
    "        // Untimed #920 diagnostic only: reuse the original producer's retained result.\n"
    "        fprintf(stderr, \"runtime-scan mode=base scalar=%u spelled=%u full=%u compact=%u visited=%u errno-index=%u\\n\",\n"
    "                (unsigned)BUSTER_SCALAR_PATH(scalar), (unsigned)spelled, input->token_count, declaring_count, spelled ? input->token_count : 0,\n"
    "                (unsigned)CHECK_LOWER_RUNTIME_ERRNO);\n";

static const char trace_candidate[] =
    "        // Untimed #920 diagnostic only: compare both traversals on this exact checked program.\n"
    "        SymbolId runtime_oracle[CHECK_LOWER_RUNTIMES];\n"
    "        memcpy(runtime_oracle, shared->declared_runtimes, sizeof(runtime_oracle));\n"
    "        if (spelled)\n"
    "        {\n"
    "            check_lower_declared_runtimes(program, NULL, declaring_count, identifiers, runtime_oracle, true);\n"
    "            check_lower_declared_runtimes(program, declaring, declaring_count, identifiers, shared->declared_runtimes, BUSTER_SCALAR_PATH(scalar));\n"
    "        }\n"
    "        const bool runtime_equal = memcmp(runtime_oracle, shared->declared_runtimes, sizeof(runtime_oracle)) == 0;\n"
    "        fprintf(stderr, \"runtime-scan mode=candidate scalar=%u spelled=%u full=%u compact=%u visited=%u errno-index=%u oracle-equal=%u\\n\",\n"
    "                (unsigned)BUSTER_SCALAR_PATH(scalar), (unsigned)spelled, input->token_count, declaring_count,\n"
    "                spelled ? (BUSTER_SCALAR_PATH(scalar) ? input->token_count : declaring_count) : 0, (unsigned)CHECK_LOWER_RUNTIME_ERRNO,\n"
    "                (unsigned)runtime_equal);\n"
    "        if (!runtime_equal)\n"
    "        {\n"
    "            fprintf(stderr, \"runtime-scan full-token oracle mismatch\\n\");\n"
    "            abort();\n"
    "        }\n";

static const char oracle_compare[] =
    "        const bool runtime_equal = memcmp(runtime_oracle, shared->declared_runtimes, sizeof(runtime_oracle)) == 0;\n";

static const char oracle_mutation[] =
    "        // Untimed negative control only: corrupt one copied oracle slot.\n"
    "        _Static_assert(CHECK_LOWER_RUNTIMES > 0 && CHECK_LOWER_RUNTIME_ERRNO >= 0 && CHECK_LOWER_RUNTIME_ERRNO < CHECK_LOWER_RUNTIMES,\n"
    "                       \"the negative-control runtime slot must exist\");\n"
    "        runtime_oracle[CHECK_LOWER_RUNTIME_ERRNO] ^= (SymbolId)1;\n";

static const char slots_base[] =
    "        fprintf(stderr, \"runtime-slots mode=base\");\n"
    "        for (uint32_t r = 0; r < CHECK_LOWER_RUNTIMES; r += 1)\n"
    "        {\n"
    "            fprintf(stderr, \" %u:%llu:%llu\", (unsigned)r, (unsigned long long)identifiers[r], (unsigned long long)shared->declared_runtimes[r]);\n"
    "        }\n"
    "        fputc('\\n', stderr);\n";

static const char slots_candidate[] =
    "        fprintf(stderr, \"runtime-slots mode=candidate\");\n"
    "        for (uint32_t r = 0; r < CHECK_LOWER_RUNTIMES; r += 1)\n"
    "        {\n"
    "            fprintf(stderr, \" %u:%llu:%llu\", (unsigned)r, (unsigned long long)identifiers[r], (unsigned long long)shared->declared_runtimes[r]);\n"
    "        }\n"
    "        fputc('\\n', stderr);\n";

static size_t occurrences(const char* source, const char* anchor)
{
    size_t count = 0;
    const size_t length = strlen(anchor);
    const char* cursor = source;
    const char* found;
    while ((found = strstr(cursor, anchor)) != NULL)
    {
        count += 1;
        cursor = found + length;
    }
    return count;
}

static char* read_source(const char* path, size_t* length)
{
    char* source = NULL;
    FILE* input = fopen(path, "rb");
    if (input != NULL && fseek(input, 0, SEEK_END) == 0)
    {
        const long size = ftell(input);
        if (size >= 0 && (uintmax_t)size < SIZE_MAX && fseek(input, 0, SEEK_SET) == 0)
        {
            *length = (size_t)size;
            source = malloc(*length + 1);
            if (source != NULL && fread(source, 1, *length, input) == *length && memchr(source, 0, *length) == NULL)
            {
                source[*length] = 0;
            }
            else
            {
                free(source);
                source = NULL;
            }
        }
    }
    if (input != NULL)
    {
        if (fclose(input) != 0)
        {
            free(source);
            source = NULL;
        }
    }
    return source;
}

static bool replace_once(char** source, size_t* length, const char* anchor, const char* const* parts, size_t count)
{
    bool valid = occurrences(*source, anchor) == 1;
    const size_t anchor_length = strlen(anchor);
    size_t replacement_length = 0;
    for (size_t p = 0; valid && p < count; p += 1)
    {
        const size_t part_length = strlen(parts[p]);
        valid = part_length <= SIZE_MAX - replacement_length;
        if (valid)
        {
            replacement_length += part_length;
        }
    }
    valid = valid && anchor_length <= *length && replacement_length <= SIZE_MAX - 1 - (*length - anchor_length);
    if (valid)
    {
        const char* found = strstr(*source, anchor);
        const size_t prefix = (size_t)(found - *source);
        const size_t suffix = *length - prefix - anchor_length;
        const size_t new_length = *length - anchor_length + replacement_length;
        char* result = malloc(new_length + 1);
        valid = result != NULL;
        if (valid)
        {
            memcpy(result, *source, prefix);
            size_t written = prefix;
            for (size_t p = 0; p < count; p += 1)
            {
                const size_t part_length = strlen(parts[p]);
                memcpy(result + written, parts[p], part_length);
                written += part_length;
            }
            memcpy(result + written, found + anchor_length, suffix + 1);
            free(*source);
            *source = result;
            *length = new_length;
        }
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    const bool base = valid && strcmp(argv[1], "base") == 0;
    const bool mutant = valid && strcmp(argv[1], "candidate-mutant") == 0;
    const bool candidate = valid && (strcmp(argv[1], "candidate") == 0 || mutant);
    valid = valid && (base || candidate);
    size_t length = 0;
    char* source = valid ? read_source(argv[2], &length) : NULL;
    valid = valid && source != NULL;
    const size_t original_length = length;
    if (valid)
    {
        valid = strstr(source, "runtime-scan mode=") == NULL && occurrences(source, "static bool check_lower_prepare(") == 1 &&
            occurrences(source, "static void check_lower_declared_runtimes(") == (candidate ? 1u : 0u) &&
            occurrences(source, producer_original) == (base ? 1u : 0u) &&
            occurrences(source, producer_retained) == (candidate ? 1u : 0u) &&
            occurrences(source, runtime_original) == (base ? 1u : 0u) &&
            occurrences(source, runtime_candidate) == (candidate ? 1u : 0u);
    }
    if (valid && base)
    {
        const char* retained[] = { producer_retained };
        const char* traced[] = { trace_base, runtime_original, slots_base };
        valid = replace_once(&source, &length, producer_original, retained, 1) &&
            replace_once(&source, &length, runtime_original, traced, 3);
    }
    if (valid && candidate)
    {
        const char* traced[] = { trace_candidate, slots_candidate };
        valid = replace_once(&source, &length, runtime_candidate, traced, 2);
    }
    if (valid && mutant)
    {
        const char* mutated[] = { oracle_mutation, oracle_compare };
        valid = replace_once(&source, &length, oracle_compare, mutated, 2);
    }
    FILE* output = valid ? fopen(argv[3], "wbx") : NULL;
    valid = valid && output != NULL;
    if (output != NULL)
    {
        const bool wrote = fwrite(source, 1, length, output) == length;
        const bool closed = fclose(output) == 0;
        valid = valid && wrote && closed;
        if (!valid)
        {
            remove(argv[3]);
        }
    }
    free(source);
    if (valid)
    {
        printf("mode=%s input-bytes=%zu output-bytes=%zu exact-replacements=%u diagnostic-only=1 timed=0\n", argv[1], original_length, length, base || mutant ? 2u : 1u);
    }
    else
    {
        fprintf(stderr, "runtime_probe_source refused: MODE must be base/candidate/candidate-mutant; input must have every unique exact anchor; output must not exist\n");
    }
    return valid ? 0 : 1;
}
