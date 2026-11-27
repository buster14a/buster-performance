// Gate for #3450's frame radix: main's tier1_frame_plan (old: the scalar radix sort past 8 classes or 64 events)
// against the branch's (new: the vector radix), one executable, rdtsc a plan.
//   gate replay FILE...  every dumped real frame once a pass, in order, by object-count bin, 21 passes alternating
//   gate synth           per object count, 64 distinct random frames (classes 1 to 24), 21 passes
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
typedef uint32_t Side(const uint32_t*, const uint32_t*, const uint32_t*, const uint32_t*, const uint32_t*, const uint32_t*, const void*, const uint32_t**, const int32_t**);
Side old_side;
Side new_side;
typedef struct { const uint32_t* header; const uint32_t *start, *end, *size, *alignment, *indices; const void* calls; } Frame;
#define PASSES 21
static int cmp(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return x < y ? -1 : x > y; }
static uint64_t mismatches;
static uint32_t plan(int side, const Frame* f, const uint32_t** s, const int32_t** o)
{
    return (side == 0 ? old_side : new_side)(f->header, f->start, f->end, f->size, f->alignment, f->indices, f->calls, s, o);
}
static void check(const Frame* f)
{
    const uint32_t* s; const int32_t* o;
    const uint32_t a = plan(0, f, &s, &o);
    const uint32_t n = f->header[0];
    uint32_t* keep = malloc(n * 8ull + 8);
    if (a != UINT32_MAX && n) { memcpy(keep, s, n * 4ull); memcpy(keep + n, o, n * 4ull); }
    const uint32_t b = plan(1, f, &s, &o);
    mismatches += a != b || (a != UINT32_MAX && n && (memcmp(keep, s, n * 4ull) || memcmp(keep + n, o, n * 4ull)));
    free(keep);
}
static void time_frames(const Frame* frames, uint32_t k, uint32_t repeat, double* old_ticks, double* new_ticks)
{
    double samples[2][PASSES];
    for (uint32_t pass = 0; pass < PASSES; pass += 1)
        for (uint32_t order = 0; order < 2; order += 1)
        {
            const int side = (int)(order ^ (pass & 1));
            uint64_t total = 0;
            for (uint32_t r = 0; r < repeat; r += 1)
                for (uint32_t i = 0; i < k; i += 1)
                {
                    const uint32_t* s; const int32_t* o;
                    const uint64_t before = __rdtsc();
                    const uint32_t c = plan(side, &frames[i], &s, &o);
                    total += __rdtsc() - before;
                    __asm__ volatile("" : : "r"(c), "r"(s) : "memory");
                }
            samples[side][pass] = (double)total / ((double)k * repeat);
        }
    qsort(samples[0], PASSES, sizeof(double), cmp);
    qsort(samples[1], PASSES, sizeof(double), cmp);
    *old_ticks = samples[0][PASSES / 2];
    *new_ticks = samples[1][PASSES / 2];
}
static uint32_t bin_of(uint32_t n) { uint32_t b = 0; while (b < 12 && n > (b == 0 ? 0u : 1u << (b - 1))) b += 1; return b; }
static uint64_t state = 3450;
static uint32_t rnd(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return (uint32_t)(state >> 16); }
int main(int argc, char** argv)
{
    if (argc >= 3 && strcmp(argv[1], "replay") == 0)
    {
        for (int file = 2; file < argc; file += 1)
        {
            FILE* fp = fopen(argv[file], "rb");
            if (!fp) return 1;
            fseek(fp, 0, SEEK_END); long bytes = ftell(fp); fseek(fp, 0, SEEK_SET);
            uint32_t* w = malloc(bytes + 64);
            if (fread(w, 1, bytes, fp) != (size_t)bytes) return 1;
            fclose(fp);
            uint64_t length = bytes / 4, at = 0; uint32_t n = 0;
            Frame* frames = malloc(sizeof(Frame) * (length / 6 + 1));
            while (at + 6 <= length)
            {
                Frame f; f.header = w + at; at += 6;
                const uint32_t rows = f.header[2] ? f.header[1] : f.header[0];
                f.start = w + at; f.end = w + at + rows; f.size = w + at + 2 * rows; f.alignment = w + at + 3 * rows; at += 4ull * rows;
                f.indices = f.header[2] ? w + at : 0; if (f.header[2]) at += f.header[0];
                f.calls = w + at; at += 4ull * f.header[3];
                frames[n++] = f;
            }
            mismatches = 0;
            for (uint32_t i = 0; i < n; i += 1) check(&frames[i]);
            printf("replay file=%s frames=%u mismatches=%llu\n", argv[file], n, (unsigned long long)mismatches);
            Frame* group = malloc(sizeof(Frame) * n);
            const char* names[] = {"0", "1", "2", "3-4", "5-8", "9-16", "17-32", "33-64", "65-128", "129-256", "257-512", "513-1024", "1025+"};
            double all_old = 0, all_new = 0;
            for (uint32_t b = 0; b <= 12; b += 1)
            {
                uint32_t k = 0;
                for (uint32_t i = 0; i < n; i += 1) if (bin_of(frames[i].header[0]) == b) group[k++] = frames[i];
                if (!k) continue;
                double o, nw;
                time_frames(group, k, k < 64 ? 64 / k + 1 : 1, &o, &nw);
                all_old += o * k; all_new += nw * k;
                printf("  bin=%s frames=%u old_ticks=%.1f new_ticks=%.1f new/old=%.3f\n", names[b], k, o, nw, nw / o);
            }
            printf("  all new/old=%.3f\n", all_new / all_old);
            if (mismatches) return 1;
        }
        return 0;
    }
    if (argc == 2 && strcmp(argv[1], "synth") == 0)
    {
        const uint32_t counts[] = { 33, 40, 48, 64, 96, 128, 256, 512, 1024, 4096, 32768 };
        const uint32_t classes[] = { 4, 12 };
        for (uint32_t ci = 0; ci < sizeof(counts) / sizeof(counts[0]); ci += 1)
            for (uint32_t cl = 0; cl < 2; cl += 1)
            {
                const uint32_t n = counts[ci];
                const uint32_t k = n <= 1024 ? 64 : 4;
                Frame* frames = malloc(sizeof(Frame) * k);
                for (uint32_t i = 0; i < k; i += 1)
                {
                    uint32_t* h = calloc(6 + 5ull * n, 4);
                    h[0] = n; h[1] = n; h[2] = 1; h[3] = 0; h[4] = 0; h[5] = 0;
                    uint32_t* c = h + 6;
                    for (uint32_t j = 0; j < n; j += 1)
                    {
                        const uint32_t r = rnd();
                        c[j] = r % (n * 4); c[n + j] = c[j] + 1 + (r >> 16) % 64;
                        const uint32_t cls = rnd() % classes[cl];
                        c[2 * n + j] = 8 * (1 + cls % 6); c[3 * n + j] = 1u << (cls / 6 + 2);
                        c[4 * n + j] = n - 1 - j;
                    }
                    frames[i] = (Frame){ h, c, c + n, c + 2 * n, c + 3 * n, c + 4 * n, 0 };
                    check(&frames[i]);
                }
                double o, nw;
                time_frames(frames, k, n <= 128 ? 4 : 1, &o, &nw);
                printf("synth objects=%u classes<=%u frames=%u old_ticks=%.1f new_ticks=%.1f new/old=%.3f mismatches=%llu\n", n, classes[cl], k, o, nw, nw / o, (unsigned long long)mismatches);
                fflush(stdout);
                for (uint32_t i = 0; i < k; i += 1) free((void*)frames[i].header);
                free(frames);
            }
        return mismatches != 0;
    }
    return 2;
}
