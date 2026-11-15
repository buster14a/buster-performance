// #1382's kernels, each called from bench.c's loop in another object.
#include <stdbool.h>
int k_null(int a, int b) { return a ^ b; }
int k_max(int a, int b) { return a > b ? a : b; }
int k_clamp(int x) { return x < 0 ? 0 : x > 255 ? 255 : x; }
bool k_and(int a, int b) { return a < 128 && b < 128; }
bool k_andor(int a, int b, int c) { return (a < b) && (b < c || c == 0); }
long k_condsum(const int* a, int n) { long s = 0; for (int i = 0; i < n; i++) if (a[i] > 128) s += a[i]; return s; }
long k_abssum(const int* a, int n) { long s = 0; for (int i = 0; i < n; i++) s += a[i] > 128 ? a[i] : -a[i]; return s; }
int k_runmax(const int* a, int n) { int m = 0; for (int i = 0; i < n; i++) m = a[i] > m ? a[i] : m; return m; }
