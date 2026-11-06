#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
enum { PARSE_KIND_NUMBER = 3, PARSE_KIND_COMMA = 7, PARSE_KIND_MINUS = 9, PARSE_KIND_L_BRACE = 11, PARSE_KIND_R_BRACE = 12 };
#include "extract.h"
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
int main(int argc, char** argv)
{
    const uint32_t columns = argc > 1 ? (uint32_t)atoi(argv[1]) : 4;
    const uint32_t rows = argc > 2 ? (uint32_t)atoi(argv[2]) : 12000;
    uint8_t* kinds = malloc((size_t)rows * (3 * columns + 3));
    uint32_t n = 0;
    srand(1);
    for (uint32_t r = 0; r < rows; r += 1)
    {
        kinds[n++] = PARSE_KIND_L_BRACE;
        for (uint32_t c = 0; c < columns; c += 1)
        {
            if (rand() % 2 == 0) kinds[n++] = PARSE_KIND_MINUS;
            kinds[n++] = PARSE_KIND_NUMBER;
            if (c + 1 < columns) kinds[n++] = PARSE_KIND_COMMA;
        }
        kinds[n++] = PARSE_KIND_R_BRACE;
        kinds[n++] = PARSE_KIND_COMMA;
    }
    for (int scalar = 1; scalar >= 0; scalar -= 1)
    {
        double best = 1e30; uint32_t got = 0;
        for (int rep = 0; rep < 50; rep += 1)
        {
            const double s = now();
            got = check_literal_table_rows(kinds, 0, n, columns, scalar);
            const double e = now();
            best = e - s < best ? e - s : best;
        }
        printf("%-6s columns %2u rows %6u tokens %7u count %7u: %8.1f us, %.2f ns/token\n", scalar ? "scalar" : "vector", columns, rows, n, got, best / 1e3, best / n);
    }
    return 0;
}
