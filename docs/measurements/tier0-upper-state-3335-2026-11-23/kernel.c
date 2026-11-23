// #3335's kernel, compiled by Tier 0 at -march=znver5: the issue's sum16, which writes zmm0, zmm1 and ymm2, and a scalar
// saxpy, whose float code Tier 0 writes in legacy SSE (base) or VEX (with #3335) forms.
#include <immintrin.h>
float sum16(const float* p) { __m512 v = _mm512_loadu_ps(p); return _mm512_reduce_add_ps(_mm512_add_ps(v, v)); }
void saxpy(float* y, const float* x, float a, int n)
{
    for (int i = 0; i < n; i++)
    {
        y[i] = a * x[i] + y[i];
    }
}
// A 512-bit add stored to memory, which returns with wide values still in zmm0 and zmm1 (sum16 narrows its registers
// back to xmm before it returns).
void add16(float* o, const float* p) { _mm512_storeu_ps(o, _mm512_add_ps(_mm512_loadu_ps(p), _mm512_loadu_ps(p + 16))); }
