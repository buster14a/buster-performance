extern volatile int marker; long double x87_pending(void) { return 0.5L + (marker = 1, 2.0L); }
void x87_add(long double *out, const long double *p) { *out = p[0] + p[1]; }
void x87_chain(long double *out, const long double *p) { *out = p[0] * p[1] + p[2]; }
void x87_order(long double *out, const long double *p) { *out = (p[0] - p[1]) / (p[2] - p[3]); }
void x87_affine(long double *out, const long double *p) { *out = p[0] * 0.5L + p[1]; }
long double x87_single_min(void) { return 0x1p-126L; }
long double x87_single_max(void) { return -0x1.fffffep127L; }
long double x87_negative_zero(void) { return -0.0L; }
long double x87_below_single_normal(void) { return 0x1p-127L; }
long double x87_above_single_max(void) { return 0x1p128L; }
long double x87_extra_fraction(void) { return 0x1.000001p0L; }
long double x87_double_min(void) { return -0x1p-1022L; }
long double x87_double_max(void) { return 0x1.fffffffffffffp1023L; }
long double x87_below_double_normal(void) { return -0x1p-1023L; }
long double x87_above_double_max(void) { return 0x1p1024L; }
long double x87_beyond_double_precision(void) { return 0x1.00000000000008p0L; }
void x87_literals(long double *out) {
out[0]=0.0L; out[1]=-0.0L; out[2]=0.5L; out[3]=-1.5L;
out[4]=0x1.0000000000000002p+0L; out[5]=0x1p-16382L; out[6]=0x1p-16445L; }
long double x87_join(int choice) { return choice ? 0x1.0000000000000002p+0L : -0.5L; }
long double x87_external(long double);
long double x87_call(long double value) { return x87_external(value) + 0.5L; }
void x87_trap(volatile int *marker, long double *out, const long double *p) { *out=p[0]*p[1]+p[2]; *marker=1; }
void x87_alias(long double *p) { long double old = *p; *p = 2.0L; *p = old + *p; }
