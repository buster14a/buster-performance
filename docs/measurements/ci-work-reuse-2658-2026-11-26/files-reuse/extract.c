// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Extracts the current helper implementations and their negative controls without copying an algorithm into the harness.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Mutation Mutation;
struct Mutation
{
    const char* name;
    const char* before;
    const char* after;
};

static const char* const functions[] = {
    "files_test_same_id(",
    "files_test_same_value(",
    "files_test_same_stream(",
    "files_test_same_text(",
    "files_test_mark_used(",
    "files_test_unused(",
    "files_test_comparisons(",
};

static const Mutation mutations[] = {
    {
        .name = "kind_column",
        .before = "memcmp(a->kinds, b->kinds, count) == 0",
        .after = "true",
    },
    {
        .name = "flag_column",
        .before = "memcmp(a->flags, b->flags, count) == 0",
        .after = "true",
    },
    {
        .name = "value_column",
        .before = "memcmp(a->values, b->values, (uint64_t)count * sizeof(uint32_t)) == 0",
        .after = "true",
    },
    {
        .name = "location_column",
        .before = "memcmp(a->locations, b->locations, (uint64_t)count * sizeof(uint32_t)) == 0",
        .after = "true",
    },
    {
        .name = "run_status",
        .before = "a->ran == b->ran && a->errors",
        .after = "true && a->errors",
    },
    {
        .name = "opaque_spelling",
        .before = "files_test_same_id(x, y, opaque, a, b) : a == b",
        .after = "files_test_same_id(x, y, false && opaque, a, b) : a == b",
    },
    {
        .name = "diagnostic_content",
        .before = "(a_length == 0 || memcmp(a, b, a_length) == 0)",
        .after = "true",
    },
    {
        .name = "bitmap_growth",
        .before = "memset(grown + *used_count, 0, (size_t)record_count - *used_count);",
        .after = "memset(grown, 0, (size_t)record_count);",
    },
    {
        .name = "unprepared_mark",
        .before = "record < record_count && datas[d].prepared",
        .after = "record < record_count",
    },
};

static char* read_text(const char* path)
{
    FILE* file = fopen(path, "rb");
    char* text = NULL;
    if (file != NULL && fseek(file, 0, SEEK_END) == 0)
    {
        const long length = ftell(file);
        if (length >= 0 && fseek(file, 0, SEEK_SET) == 0)
        {
            text = malloc((size_t)length + 1);
            if (text != NULL)
            {
                const bool complete = fread(text, 1, (size_t)length, file) == (size_t)length;
                text[length] = 0;
                if (!complete)
                {
                    free(text);
                    text = NULL;
                }
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return text;
}

// Braces inside C strings, character literals and comments do not delimit the function.
static const char* function_end(const char* body)
{
    unsigned depth = 0;
    unsigned state = 0;
    const char* end = NULL;
    for (const char* at = body; *at != 0 && end == NULL; at += 1)
    {
        const char next = at[1];
        if (state == 1 || state == 2)
        {
            if (*at == '\\' && next != 0)
            {
                at += 1;
            }
            else if (*at == (state == 1 ? '"' : '\''))
            {
                state = 0;
            }
        }
        else if (state == 3)
        {
            state = *at == '\n' ? 0 : state;
        }
        else if (state == 4)
        {
            if (*at == '*' && next == '/')
            {
                at += 1;
                state = 0;
            }
        }
        else if (*at == '"' || *at == '\'')
        {
            state = *at == '"' ? 1 : 2;
        }
        else if (*at == '/' && (next == '/' || next == '*'))
        {
            state = next == '/' ? 3 : 4;
            at += 1;
        }
        else if (*at == '{')
        {
            depth += 1;
        }
        else if (*at == '}')
        {
            depth -= 1;
            end = depth == 0 ? at + 1 : NULL;
        }
    }
    return end;
}

int main(int argc, char** argv)
{
    bool success = argc == 4;
    char* source = success ? read_text(argv[1]) : NULL;
    char* prefix = success ? read_text(argv[2]) : NULL;
    success = success && source != NULL && prefix != NULL;
    char path[8192];
    FILE* output = NULL;
    if (success)
    {
        const int length = snprintf(path, sizeof(path), "%s/harness.c", argv[3]);
        success = length >= 0 && (size_t)length < sizeof(path);
        output = success ? fopen(path, "wb") : NULL;
        success = output != NULL && fputs(prefix, output) >= 0;
    }
    for (size_t i = 0; success && i < sizeof(functions) / sizeof(functions[0]); i += 1)
    {
        const char* found = strstr(source, functions[i]);
        const char* begin = found;
        while (begin != NULL && begin > source && begin[-1] != '\n')
        {
            begin -= 1;
        }
        const char* brace = found != NULL ? strchr(found, '{') : NULL;
        const char* semicolon = found != NULL ? strchr(found, ';') : NULL;
        const char* end = brace != NULL ? function_end(brace) : NULL;
        success = begin != NULL && strncmp(begin, "static ", 7) == 0 && end != NULL && (semicolon == NULL || semicolon > brace);
        if (success)
        {
            success = fwrite(begin, 1, (size_t)(end - begin), output) == (size_t)(end - begin) && fputs("\n\n", output) >= 0;
        }
        if (!success)
        {
            fprintf(stderr, "cannot extract definition %s\n", functions[i]);
        }
    }
    if (success)
    {
        success = fputs("int main(void) { return files_test_comparisons() ? 0 : 1; }\n", output) >= 0;
    }
    if (output != NULL)
    {
        success = fclose(output) == 0 && success;
    }
    char* harness = success ? read_text(path) : NULL;
    success = success && harness != NULL;
    for (size_t i = 0; success && i < sizeof(mutations) / sizeof(mutations[0]); i += 1)
    {
        const Mutation* mutation = &mutations[i];
        const char* found = strstr(harness, mutation->before);
        success = found != NULL && strstr(found + strlen(mutation->before), mutation->before) == NULL;
        const int length = snprintf(path, sizeof(path), "%s/mutant_%s.c", argv[3], mutation->name);
        success = success && length >= 0 && (size_t)length < sizeof(path);
        output = success ? fopen(path, "wb") : NULL;
        success = success && output != NULL;
        if (success)
        {
            success = fwrite(harness, 1, (size_t)(found - harness), output) == (size_t)(found - harness) &&
                      fputs(mutation->after, output) >= 0 && fputs(found + strlen(mutation->before), output) >= 0;
        }
        if (output != NULL)
        {
            success = fclose(output) == 0 && success;
        }
        printf("%s\t%s\n", mutation->name, success ? "generated one replacement" : "FAILED");
    }
    free(harness);
    free(prefix);
    free(source);
    if (!success)
    {
        fprintf(stderr, "usage: extract C_FILES_TEST_C PLUMBING_H OUTPUT_DIRECTORY; every definition and mutation must match exactly once\n");
    }
    return success ? 0 : 1;
}
