#include <stddef.h>
struct wide_packed { char pad; double value; } __attribute__((packed));
struct narrow_packed { char pad; float value; } __attribute__((packed));
double to_double(const float *p) { return *p; }
float to_float(const double *p) { return *p; }
double to_double_index(const float *p,size_t i) { return p[i+2]; }
float to_float_index(const double *p,size_t i) { return p[i+2]; }
double to_double_packed(const struct narrow_packed *p) { return p->value; }
float to_float_packed(const struct wide_packed *p) { return p->value; }
void to_double_stream(double *out,const float *in,unsigned n) { for(unsigned i=0;i<n;i++)out[i]=(double)in[i]; }
void to_float_stream(float *out,const double *in,unsigned n) { for(unsigned i=0;i<n;i++)out[i]=(float)in[i]; }
