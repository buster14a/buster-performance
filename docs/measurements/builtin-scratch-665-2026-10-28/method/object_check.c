// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original byte audit for every retained warm/timed object. Protocol/order/completeness are checked by stats.c.
#define main qa_command_main
#include "qa.c"
#undef main

int main(int argc, char** argv)
{
    int status = argc > 1 ? 0 : 1;
    unsigned total = 0;
    for (int input = 1; status == 0 && input < argc; input += 1)
    {
        FILE* file = fopen(argv[input], "r");
        bool valid = file != NULL;
        char directory[4096];
        snprintf(directory, sizeof(directory), "%s", argv[input]);
        char* slash = strrchr(directory, '/');
        valid = valid && slash != NULL;
        if (slash != NULL)
        {
            *slash = 0;
        }
        char references[2][4096] = { 0 };
        unsigned counts[2] = { 0 };
        char line[16384];
        while (valid && fgets(line, sizeof(line), file) != NULL)
        {
            if (line[0] != '#')
            {
                unsigned index = 0;
                unsigned warm = 0;
                unsigned role = 0;
                valid = sscanf(line, "%u %u %u", &index, &warm, &role) == 3 && role < 2 && index < 403;
                if (valid)
                {
                    char path[4096];
                    const int length = snprintf(path, sizeof(path), "%s/r%04u-role%u.o", directory, index, role);
                    struct stat info;
                    valid = length > 0 && (size_t)length < sizeof(path) && stat(path, &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0;
                    if (valid && counts[role] == 0)
                    {
                        snprintf(references[role], sizeof(references[role]), "%s", path);
                    }
                    valid = valid && equal(references[role], path);
                    counts[role] += valid;
                }
            }
        }
        if (file != NULL)
        {
            valid = valid && !ferror(file);
            fclose(file);
        }
        valid = valid && counts[0] > 0 && counts[1] > 0;
        if (valid && strstr(directory, "/aa-") != NULL)
        {
            valid = equal(references[0], references[1]);
        }
        printf("object_byte_proof=%u directory=%s role0=%u role1=%u\n", valid, directory, counts[0], counts[1]);
        total += counts[0] + counts[1];
        status = valid ? status : 1;
    }
    printf("object_byte_proof_total=%u status=%d\n", total, status);
    return status;
}
