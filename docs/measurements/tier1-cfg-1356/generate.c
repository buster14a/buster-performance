// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original fixtures for Buster #1356. No external implementation is incorporated.
// Emit one dispatch function, or its separate exhaustive driver. The independent
// returns in generated g deliberately preserve the issue's CFG shape.

#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define BUSTER_CFG_MAX_CASES 65536u

static bool parse_count(const char* text, unsigned* count)
{
    bool valid = text[0] != 0;
    unsigned value = 0;
    for (size_t i = 0; valid && text[i] != 0; i += 1)
    {
        const unsigned digit = (unsigned)(unsigned char)text[i] - (unsigned)'0';
        valid = digit <= 9 && value <= (BUSTER_CFG_MAX_CASES - digit) / 10;
        if (valid)
        {
            value = value * 10 + digit;
        }
    }
    valid = valid && value != 0;
    if (valid)
    {
        *count = value;
    }
    return valid;
}

static void emit_switch(unsigned count)
{
    puts("int g(int a)\n{\n    switch (a)\n    {");
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("        case %u: return %u;\n", i, i * 7);
    }
    puts("    }\n    return 0;\n}");
}

static void emit_label_table(unsigned count)
{
    puts("int g(int a)\n{\n    static void* t[] =\n    {");
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("        &&L%u,\n", i);
    }
    puts("    };\n    goto *t[a];");
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("L%u: return %u;\n", i, i);
    }
    puts("}");
}

static void emit_driver(unsigned count, bool switches)
{
    puts("#include <limits.h>\n#include <stdio.h>\n\nint g(int a);\n\nint main(void)\n{\n    int result = 0;");
    printf("    for (int i = 0; i < %u; i += 1)\n", count);
    puts("    {\n        const int actual = g(i);");
    printf("        const int expected = i * %u;\n", switches ? 7u : 1u);
    puts("        if (actual != expected)\n        {\n            fprintf(stderr, \"g(%d): got %d, expected %d\\n\", i, actual, expected);\n            result = 1;\n        }\n    }");
    if (switches)
    {
        puts("    const int outside[] =\n    {\n        -1,");
        printf("        %u,\n        %u,\n", count, count + 1);
        puts("        INT_MIN,\n        INT_MAX,\n    };");
        puts("    for (size_t i = 0; i < sizeof(outside) / sizeof(outside[0]); i += 1)\n    {\n        const int input = outside[i];\n        const int actual = g(input);");
        puts("        if (actual != 0)\n        {\n            fprintf(stderr, \"g(%d): got %d, expected 0\\n\", input, actual);\n            result = 1;\n        }\n    }");
    }
    puts("    return result;\n}");
}

int main(int argc, char** argv)
{
    unsigned count = 0;
    const bool driver = argc == 4 && strcmp(argv[3], "--driver") == 0;
    const bool arguments = argc == 3 || driver;
    const bool switches = arguments && strcmp(argv[1], "switch") == 0;
    const bool labels = arguments && strcmp(argv[1], "label-table") == 0;
    const bool valid = (switches || labels) && parse_count(argv[2], &count);
    int result = 2;
    if (valid)
    {
        if (driver)
        {
            emit_driver(count, switches);
        }
        else if (switches)
        {
            emit_switch(count);
        }
        else
        {
            emit_label_table(count);
        }
        result = fflush(stdout) == 0 && !ferror(stdout) ? 0 : 1;
        if (result != 0)
        {
            fputs("generate: output failed\n", stderr);
        }
    }
    else
    {
        fprintf(stderr, "usage: generate switch|label-table N [--driver]\n  N is a decimal integer from 1 through %u\n", BUSTER_CFG_MAX_CASES);
    }
    return result;
}
