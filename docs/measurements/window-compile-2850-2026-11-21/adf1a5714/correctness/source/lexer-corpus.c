#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "c_lexer.c"

int main(int argc, char** argv)
{
    assert(argc >= 4);
    int mode = atoi(argv[1]);
    uint32_t flags = (uint32_t)strtoul(argv[2], 0, 0);
    for (int f=3; f<argc; ++f) {
    FILE *file = fopen(argv[f], "rb");
    assert(file && !fseek(file, 0, SEEK_END));
    long size = ftell(file);
    assert(size >= 0 && !fseek(file, 0, SEEK_SET));
    uint8_t *bytes = malloc((size_t)size + 1);
    assert(bytes && fread(bytes, 1, size, file) == (size_t)size);
    fclose(file);
    size_t n = BUSTER_C_TOKENIZER_CAPACITY(size);
    uint8_t *kinds = malloc(n);
    uint32_t *starts = malloc(n * sizeof(*starts));
    uint32_t *ends = malloc(n * sizeof(*ends));
    assert(kinds && starts && ends);
    if (mode == 3) {
        for (int r = 0; r < 15; ++r) {
            _mm_lfence(); uint64_t begin = __rdtsc();
            int64_t n = c_tokenize(bytes, size, kinds, starts, ends, flags);
            __asm__ volatile("" : : "r"(kinds), "r"(starts), "r"(ends) : "memory");
            _mm_lfence(); uint64_t end = __rdtsc();
            if (r >= 2) printf("%d %lld %llu\n", r, (long long)n, (unsigned long long)(end - begin));
        }
        return 0;
    }
    int64_t count = mode == 1 ? c_tokenize_scalar(bytes, size, kinds, starts, ends, flags) :
                    mode == 2 ? c_tokenize_vectorized(bytes, size, kinds, starts, ends, flags) :
                                c_tokenize(bytes, size, kinds, starts, ends, flags);
    fwrite(&count, sizeof(count), 1, stdout);
    if (count > 0) {
        fwrite(kinds, 1, count, stdout);
        fwrite(starts, sizeof(*starts), count, stdout);
        fwrite(ends, sizeof(*ends), count, stdout);
    }
    free(kinds); free(starts); free(ends); free(bytes);
    }
    return ferror(stdout);
}
