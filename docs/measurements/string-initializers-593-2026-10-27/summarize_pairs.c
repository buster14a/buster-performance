// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for compare.c's summaries. All times in the output table are milliseconds.
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef struct Report Report;
struct Report
{
    double values[5][4];
    unsigned fields;
};

int main(int argc, char** argv)
{
    static const char* const kinds[] = { "strings", "repeated", "wide", "records", "pointers", "characters", "integers" };
    static const char* const variants[] = { "base", "head", "tcc", "base-stages", "head-stages" };
    static const char* const fields[] = { "wall", "input", "declarations", "peak" };
    static const unsigned counts[] = { 20000, 40000, 80000, 160000 };
    bool valid = argc == 2;
    for (unsigned kind = 0; valid && kind < 7; kind += 1)
    {
        Report reports[4] = { 0 };
        for (unsigned part = 0; valid && part < 2; part += 1)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/logs/comparison-%s-%u.csv", argv[1], kinds[kind], part == 0 ? 0 : 3);
            FILE* file = fopen(path, "r");
            valid = file != NULL || (part == 1 && reports[3].fields == (1u << 20) - 1);
            char line[8192];
            while (valid && file != NULL && fgets(line, sizeof(line), file) != NULL)
            {
                char name[80];
                unsigned count = 0;
                int offset = 0;
                if (sscanf(line, "summary,%79[^,],%u,%n", name, &count, &offset) == 2 && offset != 0)
                {
                    unsigned size = 0;
                    while (size < 4 && counts[size] != count)
                    {
                        size += 1;
                    }
                    valid = size < 4 && strcmp(name, kinds[kind]) == 0 && reports[size].fields == 0;
                    for (char* token = valid ? strtok(line + offset, ",\n") : NULL; token != NULL; token = strtok(NULL, ",\n"))
                    {
                        char key[80];
                        double value = 0;
                        valid = valid && sscanf(token, "%79[^=]=%lf", key, &value) == 2;
                        for (unsigned variant = 0; valid && variant < 5; variant += 1)
                        {
                            for (unsigned field = 0; field < 4; field += 1)
                            {
                                char expected[80];
                                snprintf(expected, sizeof(expected), "%s_%s", variants[variant], fields[field]);
                                if (strcmp(expected, key) == 0)
                                {
                                    reports[size].values[variant][field] = value;
                                    reports[size].fields |= 1u << (variant * 4 + field);
                                }
                            }
                        }
                    }
                }
            }
            if (file != NULL)
            {
                valid = valid && !ferror(file);
                fclose(file);
            }
        }
        printf("\n%s\n\n", kinds[kind]);
        puts("| N | Base wall | Head wall | tcc wall | Speedup | Base input | Head input | Base declarations | Head declarations | Base/head RSS KiB |");
        puts("| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |");
        for (unsigned size = 0; valid && size < 4; size += 1)
        {
            const Report* r = reports + size;
            valid = r->fields == (1u << 20) - 1;
            if (valid)
            {
                printf("| %u | %.3f | %.3f | %.3f | %.2fx | %.3f | %.3f | %.3f | %.3f | %.0f / %.0f |\n", counts[size],
                       r->values[0][0], r->values[1][0], r->values[2][0], r->values[0][0] / r->values[1][0],
                       r->values[3][1], r->values[4][1], r->values[3][2], r->values[4][2], r->values[0][3], r->values[1][3]);
            }
        }
    }
    if (!valid)
    {
        fputs("incomplete or invalid comparison summaries\n", stderr);
    }
    return valid ? 0 : 1;
}
