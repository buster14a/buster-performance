// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original diagnostic-source generator for #451. Copies retain all upstream source notices.
// Only module linkage and work counters change; no lexical, refinement or line-counting algorithm changes.
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static bool generate_file(const char* input_path, const char* output_path, bool main_source)
{
    FILE* input = fopen(input_path, "r");
    FILE* output = input != NULL ? fopen(output_path, "w") : NULL;
    bool valid = output != NULL;
    char line[32768];
    uint32_t linkage = 0;
    uint32_t include = 0;
    uint32_t lexed = 0;
    uint32_t pages = 0;
    bool page_function = false;
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        valid = strchr(line, '\n') != NULL || feof(input);
        const char* text = line;
        if (main_source && strcmp(line, "#define BUSTER_ELSEWHERE inline __attribute__((noinline))\n") == 0)
        {
            text = "#define BUSTER_ELSEWHERE\n";
            linkage += 1;
        }
        else if (main_source && strcmp(line, "#include \"buster/compiler/c_preprocessor.c\"\n") == 0)
        {
            text = "#include \"preprocessor451.c\"\n";
            include += 1;
        }
        else if (!main_source && strstr(line, "        const int64_t lexed = cut > at ? c_tokenize_lines(") == line)
        {
            valid = fputs("        measure451_lexed_bytes += cut > at ? cut - at : 0;\n"
                          "        measure451_lexer_calls += cut > at;\n", output) >= 0;
            lexed += 1;
        }
        else if (!main_source && strstr(line, "static void pp_count_page_lines(") == line)
        {
            text = "static void pp_count_page_lines_original451(const PPFileData* data, uint64_t begin, uint64_t end, uint32_t* pages, uint32_t* lines)\n";
            page_function = true;
            pages += 1;
        }
        valid = valid && fputs(text, output) >= 0;
        if (!main_source && page_function && strcmp(line, "}\n") == 0)
        {
            valid = valid && fputs("\nstatic void pp_count_page_lines(const PPFileData* data, uint64_t begin, uint64_t end, uint32_t* pages, uint32_t* lines)\n"
                                  "{\n"
                                  "    measure451_page_calls += 1;\n"
                                  "    measure451_page_bytes += end - begin;\n"
                                  "    pp_count_page_lines_original451(data, begin, end, pages, lines);\n"
                                  "}\n", output) >= 0;
            page_function = false;
        }
    }
    if (input != NULL)
    {
        valid = ferror(input) == 0 && valid;
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    valid = valid && (main_source ? linkage == 1 && include == 1 : lexed == 1 && pages == 1 && !page_function);
    return valid;
}

int main(int argc, char** argv)
{
    char input[PATH_MAX];
    char output[PATH_MAX];
    bool valid = argc == 3;
    if (valid)
    {
        const int in = snprintf(input, sizeof(input), "%s/main.c", argv[1]);
        const int out = snprintf(output, sizeof(output), "%s/main451.c", argv[2]);
        valid = in > 0 && (unsigned)in < sizeof(input) && out > 0 && (unsigned)out < sizeof(output) && generate_file(input, output, true);
    }
    if (valid)
    {
        const int in = snprintf(input, sizeof(input), "%s/c_preprocessor.c", argv[1]);
        const int out = snprintf(output, sizeof(output), "%s/preprocessor451.c", argv[2]);
        valid = in > 0 && (unsigned)in < sizeof(input) && out > 0 && (unsigned)out < sizeof(output) && generate_file(input, output, false);
    }
    return !valid;
}
