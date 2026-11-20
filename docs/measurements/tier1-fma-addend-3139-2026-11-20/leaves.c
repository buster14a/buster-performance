// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// The contracted expression goes through IR_FMA on a target with FMA3.
#define LEAVES(suffix, type) \
 type fma_a_##suffix(type a, type c, const type *b) { return a * *b + c; } \
 type fma_c_##suffix(type c, type a, const type *b) { return a * *b + c; } \
 void fma_fresh_##suffix(type a, type c, const type *b, type *out) { out[0]=a * *b + c; out[1]=a; out[2]=c; } \
 type fma_scaled_##suffix(type a, type c, const type *b, unsigned long i) { return a * b[i+1] + c; } \
 type fma_first_##suffix(type b, type c, const type *a) { return *a * b + c; } \
 type fma_addend_##suffix(type a, type b, const type *c) { return a * b + *c; } \
 type fma_store_##suffix(type a, type c, type *b) { type old=*b; *b=c; return a * old + c; }
LEAVES(f32,float)
LEAVES(f64,double)

#define ADDENDS(s,t) \
 t add_b_##s(t b,t a,const t *c) { return a*b+*c; } \
 void add_fresh_##s(t b,t a,const t *c,t *out) { out[0]=a*b+*c;out[1]=a;out[2]=b; } \
 t add_index_##s(t b,t a,const t *c,unsigned long i) { return a*b+c[i+1]; } \
 t add_volatile_##s(t a,t b,const volatile t *c) { return a*b+*c; } \
 t add_barrier_##s(t b,t a,t *c) { t old=*c;*c=b;return a*b+old; } \
 t add_multi_##s(t a,t b,const t *c,t *out) { t v=*c;*out=v;return a*b+v; }
ADDENDS(f32,float)
ADDENDS(f64,double)
