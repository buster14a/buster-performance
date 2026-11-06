#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <x86intrin.h>
#include "host_isa.h" /* from src/buster/compiler, with -I */
#include "extract.h"
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
int main(int argc, char** argv)
{
    FILE* f = fopen(argv[1], "rb"); static uint8_t src[8 << 20]; size_t n = fread(src, 1, sizeof src, f); fclose(f);
    // collect parts: lines of the form    "....."
    static CheckStringPart parts[100000]; uint32_t count = 0;
    for (size_t i = 0; i < n; i++) if (src[i] == '"' && (i == 0 || src[i-1] == ' ')) { size_t j = i + 1; while (src[j] != '\n') j++; parts[count++] = (CheckStringPart){ .bytes = src + i, .length = (uint32_t)(j - i) }; i = j; }
    static uint8_t out[8 << 20];
    for (int scalar = 1; scalar >= 0; scalar--) {
        double best = 1e18;
        for (int r = 0; r < 15; r++) {
            uint64_t len = 0; double s = now();
            for (uint32_t k = 0; k < count; k++) check_literal_string_part(&parts[k], CHECK_STRING_ORDINARY, true, scalar, out, &len);
            double e = now() - s; if (e < best) best = e;
        }
        printf("%s %s: %u parts, %.3f ms, %.1f ns/part\n", argv[1], scalar ? "scalar" : "vector", count, best / 1e6, best / count);
    }
}
