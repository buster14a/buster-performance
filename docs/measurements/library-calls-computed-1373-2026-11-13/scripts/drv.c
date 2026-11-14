// Calls each kernel 20 M times (the loops 5,000 times over 4,096 elements) and prints each loop's best of 5 repetitions.
#include <stdio.h>
#include <stdint.h>
#include <time.h>
void copies(char *d, const char *s); uint32_t load32(const void *p); void moves(char *d);
long absolutes(int x, long y); double signs(double x);
long sum_abs(const int *p, int n); long sum_labs(const long *p, int n); double sum_fabs(const double *p, int n);
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e3 + t.tv_nsec / 1e6; }
enum { CALLS = 20000000, ELEMENTS = 4096, PASSES = 5000, KINDS = 8 };
static int ints[ELEMENTS]; static long longs[ELEMENTS]; static double doubles[ELEMENTS];
int main(void)
{
    static char d[96], s[64];
    uint64_t x = 88172645463325252ull, h = 0; double sum = 0;
    for (int i = 0; i < 64; i++) s[i] = (char)i;
    for (int i = 0; i < ELEMENTS; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; ints[i] = (int)(x >> 40) - (1 << 23); longs[i] = (long)x >> 3; doubles[i] = (double)(int64_t)x * 1e-12; }
    double best[KINDS]; for (int k = 0; k < KINDS; k++) best[k] = 1e18;
    for (int r = 0; r < 5; r++)
    {
        double t[KINDS + 1]; int k = 0;
        t[k++] = now(); for (int i = 0; i < CALLS; i++) { copies(d + (i & 7), s + (i & 3)); h += (unsigned char)d[i & 31]; }
        t[k++] = now(); for (int i = 0; i < CALLS; i++) h += load32(s + (i & 7));
        t[k++] = now(); for (int i = 0; i < CALLS; i++) { moves(d + (i & 7)); h += (unsigned char)d[i & 15]; }
        t[k++] = now(); for (int i = 0; i < CALLS; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; h += (uint64_t)absolutes((int)x, (long)(x >> 1) - (long)(x >> 2)); }
        t[k++] = now(); for (int i = 0; i < CALLS; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; sum += signs((double)(int64_t)x); }
        t[k++] = now(); for (int i = 0; i < PASSES; i++) h += (uint64_t)sum_abs(ints, ELEMENTS);
        t[k++] = now(); for (int i = 0; i < PASSES; i++) h += (uint64_t)sum_labs(longs, ELEMENTS);
        t[k++] = now(); for (int i = 0; i < PASSES; i++) sum += sum_fabs(doubles, ELEMENTS);
        t[k] = now();
        for (int j = 0; j < KINDS; j++) if (t[j + 1] - t[j] < best[j]) best[j] = t[j + 1] - t[j];
    }
    printf("copies %.1f load32 %.1f moves %.1f absolutes %.1f signs %.1f sum_abs %.1f sum_labs %.1f sum_fabs %.1f (%llu %g)\n",
           best[0], best[1], best[2], best[3], best[4], best[5], best[6], best[7], (unsigned long long)h, sum);
    return 0;
}
