#include "host_isa.h"
void narrow(void* p,__mmask8 k,__m512i a,int width)
{
 if(width==8)_mm512_mask_cvtepi64_storeu_epi8(p,k,a);
 else if(width==16)_mm512_mask_cvtepi64_storeu_epi16(p,k,a);
 else _mm512_mask_cvtepi64_storeu_epi32(p,k,a);
}
