void apart32(float x, float *negative, float *original)
{
    *negative = -x;
    *original = x;
}
void apart64(double x, double *negative, double *original)
{
    *negative = -x;
    *original = x;
}
float same32(float x) { return -x; }
double same64(double x) { return -x; }
void array32(float *a, float *b, const float *input, unsigned n)
{
    for (unsigned i = 0; i < n; ++i) {
        float x = input[i];
        a[i] = -x;
        b[i] = x;
    }
}
void array64(double *a, double *b, const double *input, unsigned n)
{
    for (unsigned i = 0; i < n; ++i) {
        double x = input[i];
        a[i] = -x;
        b[i] = x;
    }
}
