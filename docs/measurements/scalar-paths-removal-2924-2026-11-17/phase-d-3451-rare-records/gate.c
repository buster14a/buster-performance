// Gate for #3451's rare records: main's x86_instructions_effects(_opmasks) (old: the vector lanes, then
// x86_instruction_resolve for each rare record) against the branch's (new: a block with a rare lane computed again by
// the vector block with its rare terms), one executable, rdtsc a call. Every dumped real call (dump.diff) is checked
// for identical reads, writes and opmasks, then timed by count bin, apart for calls with a rare record and without;
// 21 passes alternating which side goes first, the median of each bin's ticks a call.
//   gate FILE...
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
bool old_side_initialize(void);
bool new_side_initialize(void);
void old_side_effects(const void*, uint64_t, uint64_t*, uint64_t*, uint16_t*);
void new_side_effects(const void*, uint64_t, uint64_t*, uint64_t*, uint16_t*);
uint32_t old_side_rare(const void*, uint64_t, bool);
typedef struct { uint32_t count; uint32_t opmasks; const uint8_t* records; uint32_t rare; } Call;
#define PASSES 21
#define RECORD 16
static int cmp(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return x < y ? -1 : x > y; }
static uint64_t mismatches;
static uint64_t *r0, *w0, *r1, *w1;
static uint16_t *o0, *o1;
static void check(const Call* call)
{
    memset(o0, 0, call->count * 2ull); memset(o1, 0, call->count * 2ull);
    old_side_effects(call->records, call->count, r0, w0, call->opmasks ? o0 : 0);
    new_side_effects(call->records, call->count, r1, w1, call->opmasks ? o1 : 0);
    mismatches += memcmp(r0, r1, call->count * 8ull) != 0 || memcmp(w0, w1, call->count * 8ull) != 0 || memcmp(o0, o1, call->count * 2ull) != 0;
}
static void time_calls(const Call* calls, uint32_t n, double* old_ticks, double* new_ticks, uint32_t repeat)
{
    double samples[2][PASSES];
    for (uint32_t pass = 0; pass < PASSES; pass += 1)
    {
        for (uint32_t order = 0; order < 2; order += 1)
        {
            const uint32_t side = order ^ (pass & 1);
            uint64_t total = 0;
            for (uint32_t r = 0; r < repeat; r += 1)
            {
                for (uint32_t i = 0; i < n; i += 1)
                {
                    const Call* c = &calls[i];
                    const uint64_t before = __rdtsc();
                    if (side == 0) old_side_effects(c->records, c->count, r0, w0, c->opmasks ? o0 : 0);
                    else new_side_effects(c->records, c->count, r0, w0, c->opmasks ? o0 : 0);
                    total += __rdtsc() - before;
                    __asm__ volatile("" : : : "memory");
                }
            }
            samples[side][pass] = (double)total / ((double)n * repeat);
        }
    }
    qsort(samples[0], PASSES, sizeof(double), cmp);
    qsort(samples[1], PASSES, sizeof(double), cmp);
    *old_ticks = samples[0][PASSES / 2];
    *new_ticks = samples[1][PASSES / 2];
}
static uint32_t bin_of(uint32_t count)
{
    uint32_t bin = 0;
    while (bin < 9 && count > (1u << bin)) bin += 1;
    return bin; // 1, 2, 3-4, 5-8, ..., 129-256, 257+
}
static const char* bin_names[10] = { "1", "2", "3-4", "5-8", "9-16", "17-32", "33-64", "65-128", "129-256", "257+" };
int main(int argc, char** argv)
{
    if (argc < 2 || !old_side_initialize() || !new_side_initialize()) return 2;
    const uint64_t capacity = 1u << 22;
    r0 = malloc(capacity * 8); w0 = malloc(capacity * 8); r1 = malloc(capacity * 8); w1 = malloc(capacity * 8);
    o0 = malloc(capacity * 2); o1 = malloc(capacity * 2);
    int status = 0;
    for (int a = 1; a < argc; a += 1)
    {
        FILE* f = fopen(argv[a], "rb");
        if (!f) return 1;
        fseek(f, 0, SEEK_END); long bytes = ftell(f); fseek(f, 0, SEEK_SET);
        uint8_t* data = aligned_alloc(64, ((uint64_t)bytes + 64) & ~63ull);
        if (fread(data, 1, bytes, f) != (size_t)bytes) return 1;
        fclose(f);
        uint64_t at = 0; uint32_t n = 0;
        Call* calls = malloc(sizeof(Call) * ((uint64_t)bytes / 24 + 1));
        uint64_t records = 0, rare_records = 0;
        while (at + 8 <= (uint64_t)bytes)
        {
            uint32_t header[2]; memcpy(header, data + at, 8);
            Call c = { header[0], header[1], data + at + 8, 0 };
            if (c.count > capacity || at + 8 + (uint64_t)c.count * RECORD > (uint64_t)bytes) break;
            c.rare = old_side_rare(c.records, c.count, c.opmasks != 0);
            at += 8 + (uint64_t)c.count * RECORD;
            records += c.count; rare_records += c.rare;
            calls[n++] = c;
        }
        mismatches = 0;
        for (uint32_t i = 0; i < n; i += 1) check(&calls[i]);
        printf("replay file=%s calls=%u records=%llu rare_records=%llu mismatches=%llu\n", argv[a], n, (unsigned long long)records, (unsigned long long)rare_records,
               (unsigned long long)mismatches);
        status |= mismatches != 0;
        Call* group = malloc(sizeof(Call) * n);
        double all[2][2] = { { 0, 0 }, { 0, 0 } };
        for (uint32_t kind = 0; kind < 2; kind += 1)
        {
            for (uint32_t bin = 0; bin < 10; bin += 1)
            {
                uint32_t k = 0;
                for (uint32_t i = 0; i < n; i += 1) if (bin_of(calls[i].count) == bin && (calls[i].rare != 0) == (kind == 1)) group[k++] = calls[i];
                if (k == 0) continue;
                double o, w;
                time_calls(group, k, &o, &w, k < 256 ? 256 / k + 1 : 1);
                all[kind][0] += o * k; all[kind][1] += w * k;
                printf("  %s count=%s calls=%u old_ticks=%.1f new_ticks=%.1f new/old=%.3f\n", kind ? "rare" : "plain", bin_names[bin], k, o, w, w / o);
                fflush(stdout);
            }
        }
        printf("  plain all new/old=%.3f  rare all new/old=%.3f  every call new/old=%.3f\n", all[0][1] / all[0][0], all[1][0] > 0 ? all[1][1] / all[1][0] : 0.0,
               (all[0][1] + all[1][1]) / (all[0][0] + all[1][0]));
        free(group); free(calls); free(data);
    }
    return status;
}
