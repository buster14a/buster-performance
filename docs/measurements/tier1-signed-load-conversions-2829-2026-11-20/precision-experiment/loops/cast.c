#if WIDTH == 32
typedef float Input;
typedef double Output;
#else
typedef double Input;
typedef float Output;
#endif
void stream(Output *out, const Input *in, unsigned n)
{
    unsigned i = 0;
#if UNROLL == 8
    for (; n - i >= 8; i += 8) {
        out[i] = (Output)in[i];
        out[i+1] = (Output)in[i+1];
        out[i+2] = (Output)in[i+2];
        out[i+3] = (Output)in[i+3];
        out[i+4] = (Output)in[i+4];
        out[i+5] = (Output)in[i+5];
        out[i+6] = (Output)in[i+6];
        out[i+7] = (Output)in[i+7];
    }
#endif
    for (; i<n; i++) out[i] = (Output)in[i];
}
