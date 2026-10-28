// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original validity gate: every actual hot symbol must move by the requested prefix and keep its size.
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef struct Symbol Symbol;
struct Symbol
{
    uint64_t address;
    uint64_t size;
    bool seen;
};

int main(int argc, char** argv)
{
    int result = argc != 2;
    FILE* file = result == 0 ? fopen(argv[1], "r") : NULL;
    result |= file == NULL;
    Symbol symbols[2][6][4] = { 0 };
    const unsigned shifts[6] = { 0, 688, 1376, 2064, 2752, 3440 };
    const char* names[4] = { "check_input_run", "check_input_expressions", "check_graph_run", "check_graph_validate_vector" };
    unsigned role = 2;
    unsigned placement = 6;
    char line[8192];
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char label[16];
        unsigned shift;
        if (sscanf(line, "variant=%15s shift=%u", label, &shift) == 2)
        {
            role = strcmp(label, "base") == 0 ? 0 : strcmp(label, "head") == 0 ? 1 : 2;
            placement = 6;
            for (unsigned p = 0; p < 6; p += 1)
            {
                placement = shifts[p] == shift ? p : placement;
            }
            result |= role >= 2 || placement >= 6;
        }
        else if (role < 2 && placement < 6 && strlen(line) > 16 && line[16] == ' ')
        {
            uint64_t address;
            uint64_t size;
            char type;
            char name[128];
            if (sscanf(line, "%16" SCNx64 " %16" SCNx64 " %c %127s", &address, &size, &type, name) == 4)
            {
                for (unsigned n = 0; n < 4; n += 1)
                {
                    if (strcmp(name, names[n]) == 0)
                    {
                        Symbol* symbol = &symbols[role][placement][n];
                        // check_graph_run also has a later synthetic benchmark copy. The production copy is first.
                        if (!symbol->seen || address < symbol->address)
                        {
                            *symbol = (Symbol){ .address = address, .size = size, .seen = true };
                        }
                    }
                }
            }
        }
    }
    if (file != NULL)
    {
        result |= fclose(file) != 0;
    }
    for (unsigned r = 0; r < 2; r += 1)
    {
        for (unsigned p = 0; p < 6; p += 1)
        {
            for (unsigned n = 0; n < 4; n += 1)
            {
                const Symbol* symbol = &symbols[r][p][n];
                const Symbol* zero = &symbols[r][0][n];
                const bool valid = symbol->seen && zero->seen && symbol->size != 0 && symbol->size == zero->size &&
                                   symbol->address == zero->address + shifts[p];
                result |= !valid;
                printf("%s shift=%u %s address=%016" PRIx64 " size=%" PRIu64 " delta=%" PRId64 " valid=%u\n",
                       r == 0 ? "base" : "head", shifts[p], names[n], symbol->address, symbol->size,
                       (int64_t)symbol->address - (int64_t)zero->address, valid);
            }
        }
    }
    return result;
}
