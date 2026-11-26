// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void convert(const char* root, const char* name, const char* destination, uint32_t kind)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/original/%s.txt", root, name);
    FILE* input = fopen(path, "rb");
    FILE* output = fopen(destination, "wb");
    if (input == NULL || output == NULL)
    {
        exit(1);
    }
    fprintf(output, "buster-fixtures v%u %s\n", kind == 1 ? 3 : kind == 3 ? 1 : 2, kind == 3 ? "malformed-calls" : "checker-warnings");
    char line[2048];
    uint32_t row = 0;
    uint32_t count = 0;
    while (fgets(line, sizeof(line), input) != NULL)
    {
        if (line[0] == '#')
        {
            continue;
        }
        char source[128];
        char language[16];
        char options[4][128];
        unsigned warnings = 0, errors = 0, notes = 0, c23 = 0;
        row += 1;
        if (kind == 0)
        {
            if (sscanf(line, "%127s %u %u %u %u", source, &warnings, &errors, &notes, &c23) != 5)
            {
                exit(1);
            }
            for (uint32_t standard = c23; standard < 2; standard += 1)
            {
                fprintf(output, "%s-%s\t%s.c\t%u\t%u\t%u\t%s\t-\t%s\n", source, standard ? "c23" : "gnu17", source,
                        warnings, errors, notes, standard ? "c23" : "-", source);
                count += 1;
            }
        }
        else if (kind == 1)
        {
            if (sscanf(line, "%127s %u %u %u %127s %127s %127s %127s", source, &warnings, &errors, &notes,
                       options[0], options[1], options[2], options[3]) != 8)
            {
                exit(1);
            }
            const bool headers = strcmp(options[0], "-isystem") == 0;
            for (uint32_t standard = 0; standard < 2; standard += 1)
            {
                fprintf(output, "%04u-%s\t%s.c\t%u\t%u\t%u\t%s\t", row, standard ? "c23" : "gnu17", source,
                        warnings, errors, notes, standard ? "c23" : "-");
                bool any = false;
                for (uint32_t option = 0; option < 4; option += 1)
                {
                    if (strcmp(options[option], "-") != 0)
                    {
                        fprintf(output, "%s%s", any ? " " : "", headers && option == 1 ? "@suite" : options[option]);
                        any = true;
                    }
                }
                fprintf(output, "%s\t%s\t%s\n", any ? "" : "-", headers ? "system-records.h" : "-", source);
                count += 1;
            }
        }
        else if (kind == 2)
        {
            if (sscanf(line, "%127s %15s %u %u %u", source, language, &warnings, &errors, &notes) != 5)
            {
                exit(1);
            }
            fprintf(output, "%s-%s\t%s.c\t%u\t%u\t%u\t%s\t-\timaginary bit-precise %s, -std=%s\n", source, language,
                    source, warnings, errors, notes, strcmp(language, "c23") == 0 ? "c23" : "-", source, language);
            count += 1;
        }
        else
        {
            unsigned id = 0, later = 0, accepted = 0, languages = 0;
            if (sscanf(line, "%u %u %u %u", &id, &later, &accepted, &languages) != 4)
            {
                exit(1);
            }
            fprintf(output, "%u\tmalformed-calls.c\t%u\t%u\t%u\n", id, later, accepted, languages);
            count += 1;
        }
    }
    if (ferror(input) || fclose(input) != 0 || fclose(output) != 0)
    {
        exit(1);
    }
    printf("%s\t%u original rows\t%u runtime rows\n", name, row, count);
}

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        return 1;
    }
    char path[4096];
    snprintf(path, sizeof(path), "%s/tests/driver/auto-qualifiers/catalog.tsv", argv[2]);
    convert(argv[1], "auto-qualifiers", path, 0);
    snprintf(path, sizeof(path), "%s/tests/driver/record-extensions/catalog.tsv", argv[2]);
    convert(argv[1], "record-extensions", path, 1);
    snprintf(path, sizeof(path), "%s/tests/driver/imaginary-bit-int/diagnostics/catalog.tsv", argv[2]);
    convert(argv[1], "imaginary-bit-int", path, 2);
    snprintf(path, sizeof(path), "%s/tests/checker/parse-recovery/malformed-calls/catalog.tsv", argv[2]);
    convert(argv[1], "malformed-calls", path, 3);
    return 0;
}
