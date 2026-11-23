// #1373's leftovers: plain memmove of 33 to 128 constant bytes and __builtin_copysign/copysignf, in loops.
#include <string.h>
// Moves within one buffer whose ranges overlap by a varying amount, forward and backward.
void loop_move40(char *b, int n) { for (int i = 0; i < n; i++) memmove(b + (i & 15), b + ((i >> 4) & 15) + 8, 40); }
void loop_move64(char *b, int n) { for (int i = 0; i < n; i++) memmove(b + (i & 15), b + ((i >> 4) & 15) + 8, 64); }
void loop_move128(char *b, int n) { for (int i = 0; i < n; i++) memmove(b + (i & 15), b + ((i >> 4) & 15) + 8, 128); }
// Loops over 4,096 elements of the builtins' copysign.
double sum_copysign(const double *p, const double *q, int n) { double s = 0; for (int i = 0; i < n; i++) s += __builtin_copysign(p[i], q[i]); return s; }
float sum_copysignf(const float *p, const float *q, int n) { float s = 0; for (int i = 0; i < n; i++) s += __builtin_copysignf(p[i], q[i]); return s; }
// Moves from one region to another, never reading what a recent move stored: their throughput, not a chain's latency.
void loop_far64(char *b, int n) { for (int i = 0; i < n; i++) memmove(b + ((i * 67) & 4095), b + 4352 + ((i * 131) & 4095), 64); }
void loop_far128(char *b, int n) { for (int i = 0; i < n; i++) memmove(b + ((i * 67) & 4095), b + 4352 + ((i * 131) & 4095), 128); }
