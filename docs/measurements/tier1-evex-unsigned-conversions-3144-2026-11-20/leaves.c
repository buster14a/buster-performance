typedef unsigned long long U;
__attribute__((noinline)) float uf(U x) { return (float)x; }
__attribute__((noinline)) double ud(U x) { return (double)x; }
__attribute__((noinline)) float fl(const U *x, unsigned i) { return (float)x[i]; }
__attribute__((noinline)) double dl(const U *x, unsigned i) { return (double)x[i]; }
__attribute__((noinline)) float fsel(U x, U y, unsigned take) { if (take) return (float)x; return (float)y; }
__attribute__((noinline)) double dsel(U x, U y, unsigned take) { if (take) return (double)x; return (double)y; }
__attribute__((noinline)) void both(U x, U y, U z, U a, U b, U c, U d, U e, float *f, double *g) {
    const U value = x ^ y ^ z ^ a ^ b ^ c ^ d ^ e;
    *f = (float)value;
    *g = (double)value;
}
