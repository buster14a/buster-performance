#include <immintrin.h>
typedef struct { __m512i v; } U512;
typedef union { __m512i v; unsigned long long q[8]; } V512;
void lit(U512* out, __m512i x) { *out = (U512){ .v = x }; }
void decl(U512* out, __m512i x) { U512 r = { x }; *out = r; }
void uni(V512* out, __m512i x) { V512 r = { .v = x }; *out = r; }
