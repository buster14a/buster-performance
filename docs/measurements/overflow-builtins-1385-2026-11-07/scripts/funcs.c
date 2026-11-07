#include <stdint.h>
int add_i32(int a, int b, int *r) { return __builtin_add_overflow(a, b, r); }
int add_u32(unsigned a, unsigned b, unsigned *r) { return __builtin_add_overflow(a, b, r); }
int add_i64(long a, long b, long *r) { return __builtin_add_overflow(a, b, r); }
int add_u64(unsigned long a, unsigned long b, unsigned long *r) { return __builtin_add_overflow(a, b, r); }
int sub_i32(int a, int b, int *r) { return __builtin_sub_overflow(a, b, r); }
int sub_u64(unsigned long a, unsigned long b, unsigned long *r) { return __builtin_sub_overflow(a, b, r); }
int sub_i64(long a, long b, long *r) { return __builtin_sub_overflow(a, b, r); }
int mul_i32(int a, int b, int *r) { return __builtin_mul_overflow(a, b, r); }
int mul_u32(unsigned a, unsigned b, unsigned *r) { return __builtin_mul_overflow(a, b, r); }
int mul_i64(long a, long b, long *r) { return __builtin_mul_overflow(a, b, r); }
int mul_u64(unsigned long a, unsigned long b, unsigned long *r) { return __builtin_mul_overflow(a, b, r); }
int add_i8(signed char a, signed char b, signed char *r) { return __builtin_add_overflow(a, b, r); }
int mul_i64_mixed(long a, unsigned long b, long *r) { return __builtin_mul_overflow(a, b, r); }
int add_mixed(long a, unsigned long b, int *r) { return __builtin_add_overflow(a, b, r); }
