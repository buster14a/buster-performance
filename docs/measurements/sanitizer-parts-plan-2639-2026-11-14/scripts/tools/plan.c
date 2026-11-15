// plan PARTS RULE < "cost alignment section" lines: split.c's plan (split_cover/split_boundaries) of the functions in
// order; prints each part's start index. RULE 0 drops the alignment rule.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
static uint64_t* cost; static uint32_t* al; static int* sec; static uint32_t n;
static uint32_t cover(uint64_t limit, int rule, uint32_t* to, uint32_t* prev)
{
    to[0] = 0;
    for (uint32_t j = 1; j <= n; j++) to[j] = UINT32_MAX;
    for (uint32_t i = 0; i < n; i++)
    {
        uint32_t first[3] = { 0 }, greatest[3] = { 0 };
        uint64_t c = 0;
        int valid = to[i] != UINT32_MAX;
        for (uint32_t j = i; j < n && valid; j++)
        {
            int s = sec[j];
            c += cost[j];
            first[s] = first[s] == 0 ? al[j] : first[s];
            greatest[s] = al[j] > greatest[s] ? al[j] : greatest[s];
            valid = c <= limit && (!rule || first[s] >= greatest[s]);
            if (valid && to[i] + 1 < to[j + 1]) { to[j + 1] = to[i] + 1; prev[j + 1] = i; }
        }
    }
    return to[n];
}
int main(int argc, char** argv)
{
    uint32_t parts = atoi(argv[1]); int rule = atoi(argv[2]);
    uint32_t cap = 1 << 16; cost = malloc(cap * 8); al = malloc(cap * 4); sec = malloc(cap * 4);
    unsigned long long c; unsigned a; int s;
    while (scanf("%llu %u %d", &c, &a, &s) == 3) { cost[n] = c; al[n] = a; sec[n] = s; n++; }
    uint64_t total = 0, largest = 0;
    for (uint32_t i = 0; i < n; i++) { total += cost[i]; largest = cost[i] > largest ? cost[i] : largest; }
    uint32_t* to = calloc(n + 1, 4); uint32_t* prev = calloc(n + 1, 4);
    uint64_t lo = largest, hi = total;
    while (lo < hi) { uint64_t mid = lo + (hi - lo) / 2; if (cover(mid, rule, to, prev) <= parts) hi = mid; else lo = mid + 1; }
    uint32_t used = cover(lo, rule, to, prev);
    uint32_t starts[64]; uint32_t at = n;
    for (uint32_t p = used; p > 0; p--) { at = prev[at]; starts[p - 1] = at; }
    for (uint32_t p = 0; p < used; p++) printf("%u\n", starts[p]);
    return 0;
}
