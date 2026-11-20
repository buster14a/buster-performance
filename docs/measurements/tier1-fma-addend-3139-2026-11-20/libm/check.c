// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <complex.h>
#include <fenv.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#pragma STDC FENV_ACCESS ON
typedef double (*unary_function)(double);
typedef float (*unary_function_f)(float);
typedef struct {
    const char *name;
    unary_function f64;
    unary_function_f f32;
} Entry;

static const Entry functions[] = {
    {"sin", sin, sinf}, {"cos", cos, cosf}, {"tan", tan, tanf},
    {"asin", asin, asinf}, {"acos", acos, acosf}, {"atan", atan, atanf},
    {"cbrt", cbrt, cbrtf}, {"erf", erf, erff}, {"erfc", erfc, erfcf},
    {"exp", exp, expf}, {"exp2", exp2, exp2f}, {"expm1", expm1, expm1f},
    {"log", log, logf}, {"log2", log2, log2f}, {"log10", log10, log10f},
    {"log1p", log1p, log1pf}, {"j0", j0, j0f}, {"j1", j1, j1f},
    {"lgamma", lgamma, lgammaf}
};

static uint64_t state = UINT64_C(0xd928dae210cbfe3f);
static uint64_t random_bits(void)
{
    state ^= state >> 12;
    state ^= state << 25;
    state ^= state >> 27;
    return state * UINT64_C(2685821657736338717);
}

static void sample(uint32_t index, double *wide, float *narrow)
{
    static const uint64_t wide_special[] = {
        0,UINT64_C(0x8000000000000000),1,UINT64_C(0x8000000000000001),
        UINT64_C(0x0010000000000000),UINT64_C(0x7fefffffffffffff),
        UINT64_C(0x3ff0000000000000),UINT64_C(0xbff0000000000000),
        UINT64_C(0x3fefffffffffffff),UINT64_C(0x3ff0000000000001),
        UINT64_C(0x400921fb54442d18),UINT64_C(0x3ff921fb54442d18),
        UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),
        UINT64_C(0x7ff8123456789abc),UINT64_C(0xfff0000000012345)
    };
    static const uint32_t narrow_special[] = {
        0,0x80000000,1,0x80000001,0x00800000,0x7f7fffff,0x3f800000,0xbf800000,
        0x3f7fffff,0x3f800001,0x40490fdb,0x3fc90fdb,0x7f800000,0xff800000,0x7fc12345,0xff801234
    };
    uint64_t a = random_bits();
    uint32_t b = (uint32_t)random_bits();
    if (index<16) {
        a=wide_special[index]; b=narrow_special[index];
    } else if (index%3==0) {
        a=(a&UINT64_C(0x800fffffffffffff)) | ((UINT64_C(991)+(index%64))<<52);
        b=(b&UINT32_C(0x807fffff)) | ((UINT32_C(95)+(index%64))<<23);
    } else if (index%3==1) {
        a=(a&UINT64_C(0x800fffffffffffff)) | (UINT64_C(1022)<<52);
        b=(b&UINT32_C(0x807fffff)) | (UINT32_C(126)<<23);
    }
    memcpy(wide,&a,sizeof(a)); memcpy(narrow,&b,sizeof(b));
}

static void write_value(FILE *out, const void *value, size_t bytes)
{
    const uint32_t flags=(uint32_t)fetestexcept(FE_ALL_EXCEPT);
    uint64_t raw=0;
    memcpy(&raw,value,bytes);
    fwrite(&raw,sizeof(raw),1,out);
    fwrite(&flags,sizeof(flags),1,out);
}

int main(int argc, char **argv)
{
    if (argc!=2) return 2;
    FILE *out=fopen(argv[1],"wb");
    if (!out) return 3;
    const int rounding[]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};
    const uint32_t n=4096;
    for (uint32_t mode=0;mode<4;++mode) {
        if (fesetround(rounding[mode])!=0) return 4;
        state=UINT64_C(0xd928dae210cbfe3f);
        for (uint32_t i=0;i<n;++i) {
            double a,b; float x,y;
            sample(i,&a,&x); sample(i+1,&b,&y);
            for (size_t f=0;f<sizeof(functions)/sizeof(functions[0]);++f) {
                feclearexcept(FE_ALL_EXCEPT);
                const double wide=functions[f].f64(a);
                write_value(out,&wide,sizeof(wide));
                feclearexcept(FE_ALL_EXCEPT);
                const float narrow=functions[f].f32(x);
                write_value(out,&narrow,sizeof(narrow));
            }
            feclearexcept(FE_ALL_EXCEPT);
            const double power = pow(a,b); write_value(out,&power,sizeof(power));
            feclearexcept(FE_ALL_EXCEPT);
            const float powerf = powf(x,y); write_value(out,&powerf,sizeof(powerf));
            feclearexcept(FE_ALL_EXCEPT);
            const double complex z = catan(CMPLX(a,b)); write_value(out,&z,sizeof(double));
            double z_im=cimag(z); write_value(out,&z_im,sizeof(z_im));
            feclearexcept(FE_ALL_EXCEPT);
            const float complex w = catanf(CMPLXF(x,y)); write_value(out,&w,sizeof(float));
            float w_im=cimagf(w); write_value(out,&w_im,sizeof(w_im));
        }
    }
    const int failed=ferror(out);
    return fclose(out)!=0 || failed;
}
