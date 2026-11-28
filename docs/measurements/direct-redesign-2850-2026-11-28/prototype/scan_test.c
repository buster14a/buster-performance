// Pass A against the scalar reference: a file's masks and directive lines, or random texts.
#define _GNU_SOURCE
#include "ref.h"
#include "scan.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <x86intrin.h>

static uint64_t rng_state = 0x9E3779B97F4A7C15ull;
static uint64_t rng(void) { rng_state ^= rng_state << 13; rng_state ^= rng_state >> 7; rng_state ^= rng_state << 17; return rng_state; }

static uint64_t chunk_scans, chunk_rescans, chunk_decided;

static bool check(const uint8_t* text, size_t n, const char* what, bool report, uint64_t* slow, double* ticks_per_byte)
{
    const uint64_t blocks = (n + 63u) / 64u;
    Scan sc = { 0 };
    sc.masks = calloc(2u * blocks + 4u, 8); sc.directives = calloc(n / 2u + 16u, 4);
    uint8_t* mode = calloc(n + 64u, 1);
    uint32_t* dirs = calloc(n / 2u + 16u, 4);
    size_t unterminated = 0;
    const size_t dir_count = ref_modes(text, n, mode, dirs, n / 2u + 16u, &unterminated);
    scan_text(text, n, &sc);
    uint64_t best = UINT64_MAX;
    if (ticks_per_byte != NULL)
    {
        for (int r = 0; r < 31; r += 1)
        {
            const uint64_t t0 = __rdtsc();
            scan_text(text, n, &sc);
            const uint64_t t1 = __rdtsc();
            if (t1 - t0 < best) { best = t1 - t0; }
        }
        *ticks_per_byte = (double)best / (double)n;
    }
    bool ok = true;
    for (size_t i = 0; i < n && ok; i += 1)
    {
        const bool c = ((sc.masks[2u * (i >> 6)] >> (i & 63u)) & 1u) != 0;
        const bool t = ((sc.masks[2u * (i >> 6) + 1u] >> (i & 63u)) & 1u) != 0;
        if (c != (mode[i] == M_COMMENT) || t != (mode[i] == M_TAIL))
        {
            ok = false;
            if (report) { fprintf(stderr, "%s: byte %zu (block %zu, bit %zu): comment %d tail %d, the reference's mode %d\n", what, i, i >> 6, i & 63u, c, t, mode[i]); }
        }
    }
    if (ok && (sc.directive_count != dir_count || memcmp(sc.directives, dirs, dir_count * 4u) != 0))
    {
        ok = false;
        if (report)
        {
            fprintf(stderr, "%s: %u directive lines, the reference %zu\n", what, sc.directive_count, dir_count);
            for (size_t i = 0; i < dir_count && i < sc.directive_count; i += 1) { if (sc.directives[i] != dirs[i]) { fprintf(stderr, "  first difference at %zu: %u, the reference %u\n", i, sc.directives[i], dirs[i]); break; } }
        }
    }
    // The same text scanned in chunks, each from a guess, and joined: the same masks and directive lines, for a few
    // counts of chunks.
    static const uint32_t counts[] = { 2, 3, 5, 8, 13 };
    for (uint32_t k = 0; k < sizeof(counts) / sizeof(counts[0]) && ok; k += 1)
    {
        const uint32_t chunk_count = counts[k];
        Scan joined = { 0 };
        joined.masks = calloc(2u * blocks + 4u, 8); joined.directives = calloc(n / 2u + 16u, 4);
        ScanChunk* chunks = calloc(chunk_count, sizeof(ScanChunk));
        for (uint32_t c = 0; c < chunk_count; c += 1)
        {
            chunks[c].first = blocks * c / chunk_count;
            chunks[c].last = blocks * (c + 1u) / chunk_count;
            chunks[c].directives = calloc((chunks[c].last - chunks[c].first) * 32u + 16u, 4);
        }
        // Any order: a chunk's scan reads no other chunk's masks.
        for (uint32_t c = chunk_count; c > 0; c -= 1) { scan_chunk(text, n, joined.masks, chunks + (c - 1u)); }
        uint32_t rescans = 0;
        uint32_t decided = 0;
        scan_join(text, n, chunks, chunk_count, &joined, &rescans, &decided);
        chunk_rescans += rescans; chunk_decided += decided; chunk_scans += chunk_count - 1u;
        if (memcmp(joined.masks, sc.masks, 2u * blocks * 8u) != 0 || joined.directive_count != sc.directive_count || memcmp(joined.directives, sc.directives, (size_t)sc.directive_count * 4u) != 0)
        {
            ok = false;
            if (report)
            {
                uint64_t b = 0;
                while (b < 2u * blocks && joined.masks[b] == sc.masks[b]) { b += 1; }
                fprintf(stderr, "%s: in %u chunks: the masks' first difference in block %llu (%u directive lines, %u in one scan; %u chunks scanned again)\n", what, chunk_count,
                        (unsigned long long)(b / 2u), joined.directive_count, sc.directive_count, rescans);
            }
        }
        for (uint32_t c = 0; c < chunk_count; c += 1) { free(chunks[c].directives); }
        free(chunks); free(joined.masks); free(joined.directives);
    }
    if (slow != NULL) { *slow = sc.slow_blocks; }
    if (ticks_per_byte != NULL) { printf("rare blocks %llu of %llu\n", (unsigned long long)sc.rare_blocks, (unsigned long long)blocks); }
    free(sc.masks); free(sc.directives); free(mode); free(dirs);
    return ok;
}

int main(int argc, char** argv)
{
    if (argc >= 3 && strcmp(argv[1], "--fuzz") == 0)
    {
        const long rounds = atol(argv[2]);
        static const char alphabet[] = "/*/*\"'\\\n\n#  ab(;/*\"'\\\n/ *\n//";
        uint8_t* buffer = malloc(1u << 16);
        long failed = 0;
        for (long r = 0; r < rounds && failed < 5; r += 1)
        {
            const size_t n = 1 + rng() % ((r & 15) == 0 ? 20000u : 600u);
            memset(buffer, '\n', 256);
            uint8_t* text = buffer + 256;
            const uint32_t density = 1u + (uint32_t)(rng() % 8u);
            for (size_t i = 0; i < n; i += 1) { text[i] = (rng() % 8u) < density ? (uint8_t)alphabet[rng() % (sizeof(alphabet) - 1u)] : (uint8_t)('a' + rng() % 3u); }
            memset(text + n, '\n', 256);
            if (!check(text, n, "fuzz", failed == 0, NULL, NULL))
            {
                failed += 1;
                if (failed == 1)
                {
                    FILE* f = fopen("fuzz-fail.txt", "wb"); fwrite(text, 1, n, f); fclose(f);
                    uint8_t* mode = calloc(n + 64u, 1); uint32_t* dirs = calloc(n + 16u, 4); size_t un = 0;
                    ref_modes(text, n, mode, dirs, n, &un);
                    Scan sc = { 0 }; const uint64_t blocks = (n + 63u) / 64u;
                    sc.masks = calloc(2u * blocks + 4u, 8); sc.directives = calloc(n + 16u, 4);
                    scan_text(text, n, &sc);
                    for (uint64_t b = 0; b < blocks; b += 1)
                    {
                        fprintf(stderr, "block %llu\n  text ", (unsigned long long)b);
                        for (uint32_t i = 0; i < 64u; i += 1) { const uint8_t c = text[b * 64u + i]; fputc(c == '\n' ? '$' : c, stderr); }
                        fprintf(stderr, "\n  ref  ");
                        for (uint32_t i = 0; i < 64u && b * 64u + i < n; i += 1) { fputc("-CQT"[mode[b * 64u + i]], stderr); }
                        fprintf(stderr, "\n  scan ");
                        for (uint32_t i = 0; i < 64u && b * 64u + i < n; i += 1) { fputc(((sc.masks[2u * b] >> i) & 1u) != 0 ? 'C' : ((sc.masks[2u * b + 1u] >> i) & 1u) != 0 ? 'T' : '-', stderr); }
                        fprintf(stderr, "\n");
                    }
                }
            }
        }
        printf("fuzz: %ld rounds, %ld failed; chunks that started from a guess %llu, scanned again %llu, '#' decided at a join %llu\n", rounds, failed,
               (unsigned long long)chunk_scans, (unsigned long long)chunk_rescans, (unsigned long long)chunk_decided);
        return failed != 0;
    }
    if (argc >= 4 && strcmp(argv[1], "--time") == 0)
    {
        // The scan alone, N times, for a counter around the process (the difference of two counts of N).
        const long rounds = atol(argv[2]);
        const int fd = open(argv[3], O_RDONLY);
        struct stat st;
        if (fd < 0 || fstat(fd, &st) != 0) { return 2; }
        const size_t n = (size_t)st.st_size;
        uint8_t* buffer = malloc(n + 1024u);
        memset(buffer, '\n', 320);
        if (read(fd, buffer + 320, n) != (ssize_t)n) { return 2; }
        memset(buffer + 320 + n, '\n', 512);
        const uint64_t blocks = (n + 63u) / 64u;
        Scan sc = { 0 };
        sc.masks = calloc(2u * blocks + 4u, 8); sc.directives = calloc(n / 2u + 16u, 4);
        uint64_t best = UINT64_MAX;
        for (long r = 0; r < rounds; r += 1)
        {
            const uint64_t t0 = __rdtsc();
            scan_text(buffer + 320, n, &sc);
            const uint64_t t1 = __rdtsc();
            if (t1 - t0 < best) { best = t1 - t0; }
        }
        printf("rounds %ld, bytes %zu, blocks %llu, rare %llu, slow %llu, directives %u, best %.4f ticks a byte\n", rounds, n, (unsigned long long)blocks,
               (unsigned long long)sc.rare_blocks, (unsigned long long)sc.slow_blocks, sc.directive_count, (double)best / (double)n);
        return 0;
    }
    int bad = 0;
    for (int a = 1; a < argc; a += 1)
    {
        const int fd = open(argv[a], O_RDONLY);
        struct stat st;
        if (fd < 0 || fstat(fd, &st) != 0 || !S_ISREG(st.st_mode)) { if (fd >= 0) { close(fd); } continue; }
        const size_t n = (size_t)st.st_size;
        uint8_t* buffer = malloc(n + 512u);
        memset(buffer, '\n', 256);
        if (read(fd, buffer + 256, n) != (ssize_t)n) { close(fd); free(buffer); continue; }
        memset(buffer + 256 + n, '\n', 256);
        close(fd);
        uint64_t slow = 0;
        double ticks = 0;
        const bool timed = argc == 2;
        const bool ok = check(buffer + 256, n, argv[a], true, &slow, timed ? &ticks : NULL);
        if (!ok) { bad += 1; }
        if (timed || !ok) { printf("%s: %s, %zu bytes, %llu of %zu blocks by the scalar machine (%.2f%%), %.3f ticks a byte\n", argv[a], ok ? "ok" : "DIFFERS", n, (unsigned long long)slow, (n + 63u) / 64u, 100.0 * (double)slow / (double)((n + 63u) / 64u), ticks); }
        free(buffer);
    }
    if (argc > 2) { printf("%d files, %d differ\n", argc - 1, bad); }
    printf("chunks that started from a guess %llu, scanned again %llu, '#' decided at a join %llu\n", (unsigned long long)chunk_scans, (unsigned long long)chunk_rescans,
           (unsigned long long)chunk_decided);
    return bad != 0;
}
