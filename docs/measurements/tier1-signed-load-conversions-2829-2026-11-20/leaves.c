#include <stdint.h>
float i32f(const int32_t *a) { return (float)*a; }
double i32d(const int32_t *a) { return (double)*a; }
float i64f(const int64_t *a) { return (float)*a; }
double i64d(const int64_t *a) { return (double)*a; }
double scaled(const int64_t *a, unsigned long i) { return (double)a[i+1]; }
static int src = 7;
float static_ref(void) { return (float)src; }
float stack_ref(int x) { volatile int y = x; return (float)y; }
float vol(const volatile int32_t *a) { return (float)*a; }
float shared(const int32_t *a, int32_t *out) { int x=*a; *out=x; return (float)x; }
double uns(const uint32_t *a) { return (double)*a; }
double narrow(const int16_t *a) { return (double)*a; }
double stored(int *a) { int x = *a; *a=7; return (double)x; }
