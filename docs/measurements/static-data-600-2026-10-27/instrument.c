// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original, diagnostic-only source rewriter for #600. Never used for timing.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Replacement Replacement;
struct Replacement
{
    const char* before;
    const char* after;
};

static bool rewrite(const char* source, const char* target, const char* prefix, const Replacement* replacements, size_t count)
{
    FILE* input = fopen(source, "rb");
    FILE* output = fopen(target, "wb");
    bool valid = input != 0 && output != 0;
    long size = 0;
    if (valid)
    {
        valid = fseek(input, 0, SEEK_END) == 0 && (size = ftell(input)) >= 0 && fseek(input, 0, SEEK_SET) == 0;
    }
    char* text = valid ? malloc((size_t)size + 1) : 0;
    valid = valid && text != 0 && fread(text, 1, (size_t)size, input) == (size_t)size;
    if (valid)
    {
        text[size] = 0;
        fputs(prefix, output);
        for (size_t at = 0; at < (size_t)size;)
        {
            size_t match = count;
            for (size_t i = 0; match == count && i < count; i += 1)
            {
                const size_t length = strlen(replacements[i].before);
                if (length <= (size_t)size - at && memcmp(text + at, replacements[i].before, length) == 0)
                {
                    match = i;
                }
            }
            if (match != count)
            {
                fputs(replacements[match].after, output);
                at += strlen(replacements[match].before);
            }
            else
            {
                fputc(text[at], output);
                at += 1;
            }
        }
        valid = !ferror(output);
    }
    free(text);
    if (input != 0)
    {
        fclose(input);
    }
    if (output != 0)
    {
        valid = fclose(output) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    const Replacement main_replacements[] = {
        { "#define BUSTER_LINKER_ENTRY BUSTER_HOME_DYNAMIC", "#define BUSTER_LINKER_ENTRY static" },
        { "#include \"buster/compiler/c_check_data.c\"", "#include \"probe_data.h\"" },
    };
    const Replacement data_replacements[] = {
        { "BUSTER_ARENA_PUSH_ARRAY(", "DATA_PUSH_ARRAY(" },
        { "arena_push(", "data_push(" },
        { "arena_pop_to(", "data_pop(" },
        { "memset(", "data_clear(" },
        { "memcpy(", "data_copy(" },
        { "const bool initialized = nonzero != 0 || plan->fixup_count != 0;", "data_scanned += plan->bytes != 0 ? plan->size : 0; const bool initialized = nonzero != 0 || plan->fixup_count != 0;" },
        { "const __m512i block = _mm512_loadu_si512(bytes + byte);", "data_scanned += 64; const __m512i block = _mm512_loadu_si512(bytes + byte);" },
        { "const __m512i tail = _mm512_maskz_loadu_epi8(mask, bytes + byte);", "data_scanned += size - byte; const __m512i tail = _mm512_maskz_loadu_epi8(mask, bytes + byte);" },
        { "status = references == CHECK_INIT_OK", "data_observe(scratch); status = references == CHECK_INIT_OK" },
    };
    bool valid = argc == 3;
    char source[4096];
    char target[4096];
    if (valid)
    {
        snprintf(source, sizeof(source), "%s/src/buster/compiler/main.c", argv[1]);
        snprintf(target, sizeof(target), "%s/probe_main.h", argv[2]);
        valid = rewrite(source, target, "", main_replacements, sizeof(main_replacements) / sizeof(main_replacements[0]));
        snprintf(source, sizeof(source), "%s/src/buster/compiler/c_check_data.c", argv[1]);
        snprintf(target, sizeof(target), "%s/probe_data.h", argv[2]);
        valid = rewrite(source, target, "#include \"probe_support.h\"\n", data_replacements, sizeof(data_replacements) / sizeof(data_replacements[0])) && valid;
    }
    return valid ? 0 : 1;
}
