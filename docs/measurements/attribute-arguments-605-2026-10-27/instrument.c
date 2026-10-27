// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original temporary source instrumentation. Instrumented builds supply operation counts only, never timings.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* replace(char* source, const char* needle, const char* replacement, bool all)
{
    size_t offset = 0;
    char* found = strstr(source, needle);
    while (found != NULL)
    {
        offset = (size_t)(found - source);
        const size_t length = strlen(source) + strlen(replacement) - strlen(needle);
        char* output = malloc(length + 1);
        if (output == NULL)
        {
            abort();
        }
        memcpy(output, source, offset);
        memcpy(output + offset, replacement, strlen(replacement));
        strcpy(output + offset + strlen(replacement), found + strlen(needle));
        free(source);
        source = output;
        found = all ? strstr(source + offset + strlen(replacement), needle) : NULL;
    }
    return source;
}

static char* enter(char* source, const char* function, const char* statement)
{
    const char* at = strstr(source, function);
    const char* body = at != NULL ? strchr(at, '{') : NULL;
    if (body == NULL)
    {
        abort();
    }
    const size_t bytes = (size_t)(body - at) + 1;
    char* needle = malloc(bytes + 1);
    char* replacement = malloc(bytes + strlen(statement) + 1);
    if (needle == NULL || replacement == NULL)
    {
        abort();
    }
    memcpy(needle, at, bytes);
    needle[bytes] = 0;
    strcpy(replacement, needle);
    strcat(replacement, statement);
    source = replace(source, needle, replacement, false);
    free(replacement);
    free(needle);
    return source;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    FILE* input = valid ? fopen(argv[1], "rb") : NULL;
    valid = input != NULL;
    char* source = NULL;
    if (valid)
    {
        valid = fseek(input, 0, SEEK_END) == 0;
        const long bytes = ftell(input);
        valid = valid && bytes > 0 && fseek(input, 0, SEEK_SET) == 0;
        source = valid ? malloc((size_t)bytes + 1) : NULL;
        valid = valid && source != NULL && fread(source, 1, (size_t)bytes, input) == (size_t)bytes;
        if (valid)
        {
            source[bytes] = 0;
        }
        fclose(input);
    }
    if (valid)
    {
        source = enter(source, "static bool check_input_attribute_argument(", "\n    probe_calls += 1;");
        source = enter(source, "static uint32_t check_input_attribute_after_group(", "\n    probe_visits += 1;");
        source = enter(source, "static bool check_input_attribute_argument_value(", "\n    probe_evaluations += 1;");
        source = replace(source, "if (parser->tokens.kinds[i] == PARSE_KIND_COMMA)\n        {",
                         "if (parser->tokens.kinds[i] == PARSE_KIND_COMMA)\n        {\n            probe_visits += 1;", true);
        source = replace(source, "attribute->argument_ends[argument] = end;",
                         "attribute->argument_ends[argument] = end;\n            probe_visits += 1;", false);
        FILE* output = fopen(argv[2], "wb");
        valid = output != NULL;
        if (valid)
        {
            fputs("static unsigned long long probe_calls, probe_visits, probe_evaluations;\n"
                  "static void __attribute__((destructor)) probe_report(void)\n{\n"
                  "    if (probe_calls || probe_visits)\n    {\n"
                  "        fprintf(stderr, \"attribute-probe calls=%llu boundary-visits=%llu numeric-evaluations=%llu\\n\", probe_calls, probe_visits, probe_evaluations);\n"
                  "    }\n}\n", output);
            valid = fputs(source, output) >= 0 && fclose(output) == 0;
        }
    }
    free(source);
    return valid ? 0 : 1;
}
