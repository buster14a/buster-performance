#include <stdint.h>
extern uint32_t dirty_u32(uint32_t);
extern void touch_u32(void);
float c_parameter_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x; }
float c_load_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return *a; }
float c_sum_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x + key; }
float c_xor_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x ^ key; }
float c_dirtycall_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return dirty_u32(x); }
float c_volatileload_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return *(const volatile uint32_t*)a; }
float c_aftercall_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { uint32_t n=*a; touch_u32(); return n; }
float c_mixed_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { uint32_t n; if(key&1)n=x;else n=*(const volatile uint32_t*)a;return n; }
float c_signedview_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { int32_t n=*(const int32_t*)a; *side=(int64_t)n; return (uint32_t)n; }
float c_rotate_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return (x << (key&31)) | (x >> ((0u-key)&31)); }
double c_parameter_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x; }
double c_load_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return *a; }
double c_sum_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x + key; }
double c_xor_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return x ^ key; }
double c_dirtycall_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return dirty_u32(x); }
double c_volatileload_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return *(const volatile uint32_t*)a; }
double c_aftercall_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { uint32_t n=*a; touch_u32(); return n; }
double c_mixed_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { uint32_t n; if(key&1)n=x;else n=*(const volatile uint32_t*)a;return n; }
double c_signedview_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { int32_t n=*(const int32_t*)a; *side=(int64_t)n; return (uint32_t)n; }
double c_rotate_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side) { return (x << (key&31)) | (x >> ((0u-key)&31)); }
