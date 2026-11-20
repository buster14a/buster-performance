#include <stdint.h>
#include <stddef.h>
struct packed_f { char gap; float x; } __attribute__((packed));
struct packed_d { char gap; double x; } __attribute__((packed));
#define LEAVES(tag,T,R,P) \
R tag(const T *p){return (R)*p;} \
R tag##_indexed(const T *p,size_t i){return (R)p[i];} \
R tag##_packed(const struct P *p){return (R)p->x;} \
R tag##_volatile(const volatile T *p){return (R)*p;} \
R tag##_shared(const T *p,T *other){T x=*p;*other=x;return (R)x;} \
R tag##_across_store(T *p,T *q,T replacement){T x=*p;*q=replacement;return (R)x;} \
R tag##_negative(const T *p,size_t i){return (R)p[i-1];}
LEAVES(f_i32,float,int32_t,packed_f)
LEAVES(d_i32,double,int32_t,packed_d)
LEAVES(f_i64,float,int64_t,packed_f)
LEAVES(d_i64,double,int64_t,packed_d)
LEAVES(f_u32,float,uint32_t,packed_f)
LEAVES(d_u32,double,uint32_t,packed_d)
