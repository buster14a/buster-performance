// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #599 runtime inputs; compile this file separately from runtime.c.
#ifdef BUSTER_EXTERNAL_LIBC
void *memcpy(void *, const void *, unsigned long);
void *memmove(void *, const void *, unsigned long);
void *memset(void *, int, unsigned long);
int memcmp(const void *, const void *, unsigned long);
unsigned long strlen(const char *);
#define COPY memcpy
#define MOVE memmove
#define SET memset
#define COMPARE memcmp
#define LENGTH strlen
#else
#define COPY __builtin_memcpy
#define MOVE __builtin_memmove
#define SET __builtin_memset
#define COMPARE __builtin_memcmp
#define LENGTH __builtin_strlen
#endif
void *bench_copy_d(void *d, const void *s, unsigned long n) { return COPY(d, s, n); }
void *bench_move_d(void *d, const void *s, unsigned long n) { return MOVE(d, s, n); }
void *bench_set_d(void *d, int v, unsigned long n) { return SET(d, v, n); }
int bench_compare_d(const void *a, const void *b, unsigned long n) { return COMPARE(a, b, n); }
unsigned long bench_length_d(const char *s) { return LENGTH(s); }
#define FIXED(N) \
void *bench_copy_##N(void *d, const void *s, unsigned long n) { (void)n; return COPY(d, s, N); } \
void *bench_move_##N(void *d, const void *s, unsigned long n) { (void)n; return MOVE(d, s, N); } \
void *bench_set_##N(void *d, int v, unsigned long n) { (void)n; return SET(d, v, N); } \
int bench_compare_##N(const void *a, const void *b, unsigned long n) { (void)n; return COMPARE(a, b, N); }
FIXED(0)
FIXED(1)
FIXED(8)
FIXED(16)
FIXED(32)
FIXED(64)
FIXED(256)
FIXED(4096)
FIXED(1048576)
