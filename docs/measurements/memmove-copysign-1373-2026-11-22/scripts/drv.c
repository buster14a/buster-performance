// Runs each memmove loop for 20 M moves (the overlapping ones within 192 bytes, the far ones between two 4 KB regions) and each copysign loop 5,000 times over 4,096 elements; prints each loop's
// best of 5 repetitions in ms.
#include <stdio.h>
#include <stdint.h>
#include <time.h>
void loop_move40(char *b, int n); void loop_far64(char *b, int n); void loop_far128(char *b, int n); void loop_move64(char *b, int n); void loop_move128(char *b, int n);
double sum_copysign(const double *p, const double *q, int n); float sum_copysignf(const float *p, const float *q, int n);
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e3 + t.tv_nsec / 1e6; }
enum { MOVES = 20000000, ELEMENTS = 4096, PASSES = 5000, KINDS = 7 };
static double dp[ELEMENTS], dq[ELEMENTS]; static float fp[ELEMENTS], fq[ELEMENTS]; static char buffer[192]; static char far[8704];
int main(void)
{
    uint64_t x = 88172645463325252ull, h = 0; double sum = 0;
    for (int i = 0; i < 192; i++) buffer[i] = (char)(i * 7);
    for (int i = 0; i < 8704; i++) far[i] = (char)(i * 13);
    for (int i = 0; i < ELEMENTS; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; dp[i] = (double)(int64_t)x * 1e-12; dq[i] = (double)(int64_t)(x * 3) * 1e-12; fp[i] = (float)dp[i]; fq[i] = (float)dq[i]; }
    double best[KINDS]; for (int k = 0; k < KINDS; k++) best[k] = 1e18;
    for (int r = 0; r < 5; r++)
    {
        double t[KINDS + 1]; int k = 0;
        t[k++] = now(); loop_move40(buffer, MOVES); h += (unsigned char)buffer[r];
        t[k++] = now(); loop_move64(buffer, MOVES); h += (unsigned char)buffer[r + 1];
        t[k++] = now(); loop_move128(buffer, MOVES); h += (unsigned char)buffer[r + 2];
        t[k++] = now(); loop_far64(far, MOVES); h += (unsigned char)far[r];
        t[k++] = now(); loop_far128(far, MOVES); h += (unsigned char)far[r + 1];
        t[k++] = now(); for (int i = 0; i < PASSES; i++) sum += sum_copysign(dp, dq, ELEMENTS);
        t[k++] = now(); for (int i = 0; i < PASSES; i++) sum += sum_copysignf(fp, fq, ELEMENTS);
        t[k] = now();
        for (int j = 0; j < KINDS; j++) if (t[j + 1] - t[j] < best[j]) best[j] = t[j + 1] - t[j];
    }
    for (int i = 0; i < 192; i++) h = (h ^ (unsigned char)buffer[i]) * 1099511628211ull;
    for (int i = 0; i < 8704; i++) h = (h ^ (unsigned char)far[i]) * 1099511628211ull;
    printf("move40 %.1f move64 %.1f move128 %.1f far64 %.1f far128 %.1f sum_copysign %.1f sum_copysignf %.1f (%llx %g)\n", best[0], best[1], best[2], best[3], best[4], best[5], best[6], (unsigned long long)h, sum);
    return 0;
}
