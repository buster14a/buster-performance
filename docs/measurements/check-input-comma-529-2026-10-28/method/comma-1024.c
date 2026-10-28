extern int printf(const char*, ...);
static unsigned mix(unsigned x, unsigned y) { return x * 1664525u + y + 1013904223u; }
unsigned comma_body(unsigned x) {
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^17u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=2u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^18u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=3u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^19u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=4u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^20u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=5u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^21u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=6u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^22u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=7u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^23u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=8u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^24u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=9u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^25u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=10u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^26u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=11u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^27u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=12u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^28u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=13u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^29u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=14u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^30u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=15u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^31u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=16u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^32u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=17u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^33u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=18u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^34u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=19u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^35u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=20u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^36u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=21u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^37u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=22u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^38u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=23u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^39u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=24u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^40u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=25u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^41u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=26u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^42u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=27u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^43u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=28u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^44u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=29u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^45u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=30u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^46u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=31u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^47u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=32u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^48u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=33u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^49u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=34u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^50u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=35u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^51u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=36u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^52u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=37u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^53u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=38u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^54u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=39u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^55u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=40u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^56u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=41u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^57u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=42u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^58u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=43u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^59u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=44u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^60u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=45u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^61u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=46u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^62u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=47u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^63u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=48u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^64u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=49u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^65u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=50u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^66u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=51u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^67u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=52u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^68u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=53u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^69u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=54u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^70u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=55u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^71u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=56u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^72u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=57u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^73u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=58u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^74u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=59u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^75u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=60u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^76u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=61u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^77u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=62u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^78u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=63u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^79u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=64u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^80u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=65u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^81u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=66u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^82u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=67u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^83u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=68u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^84u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=69u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^85u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=70u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^86u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=71u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^87u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=72u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^88u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=73u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^89u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=74u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^90u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=75u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^91u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=76u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^92u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=77u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^93u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=78u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^94u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=79u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^95u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=80u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^96u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=81u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^97u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=82u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^98u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=83u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^99u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=84u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^100u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=85u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^101u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=86u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^102u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=87u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^103u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=88u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^104u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=89u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^105u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=90u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^106u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=91u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^107u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=92u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^108u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=93u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^109u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=94u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^110u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=95u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^111u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=96u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^112u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=97u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^113u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=98u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^114u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=99u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^115u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=100u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^116u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=101u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^117u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=102u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^118u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=103u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^119u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=104u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^120u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=105u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^121u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=106u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^122u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=107u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^123u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=108u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^124u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=109u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^125u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=110u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^126u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=111u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^127u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=112u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^128u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=113u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^129u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=114u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^130u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=115u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^131u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=116u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^132u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=117u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^133u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=118u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^134u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=119u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^135u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=120u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^136u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=121u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^137u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=122u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^138u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=123u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^139u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=124u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^140u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=125u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^141u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=126u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^142u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=127u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^143u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=128u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^144u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=129u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^145u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=130u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^146u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=131u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^147u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=132u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^148u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=133u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^149u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=134u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^150u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=135u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^151u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=136u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^152u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=137u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^153u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=138u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^154u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=139u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^155u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=140u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^156u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=141u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^157u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=142u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^158u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=143u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^159u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=144u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^160u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=145u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^161u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=146u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^162u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=147u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^163u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=148u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^164u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=149u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^165u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=150u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^166u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=151u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^167u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=152u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^168u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=153u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^169u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=154u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^170u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=155u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^171u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=156u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^172u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=157u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^173u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=158u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^174u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=159u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^175u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=160u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^176u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=161u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^177u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=162u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^178u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=163u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^179u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=164u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^180u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=165u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^181u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=166u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^182u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=167u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^183u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=168u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^184u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=169u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^185u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=170u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^186u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=171u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^187u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=172u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^188u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=173u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^189u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=174u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^190u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=175u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^191u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=176u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^192u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=177u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^193u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=178u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^194u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=179u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^195u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=180u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^196u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=181u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^197u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=182u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^198u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=183u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^199u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=184u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^200u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=185u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^201u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=186u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^202u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=187u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^203u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=188u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^204u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=189u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^205u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=190u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^206u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=191u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^207u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=192u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^208u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=193u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^209u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=194u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^210u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=195u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^211u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=196u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^212u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=197u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^213u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=198u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^214u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=199u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^215u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=200u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^216u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=201u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^217u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=202u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^218u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=203u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^219u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=204u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^220u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=205u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^221u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=206u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^222u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=207u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^223u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=208u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^224u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=209u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^225u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=210u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^226u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=211u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^227u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=212u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^228u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=213u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^229u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=214u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^230u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=215u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^231u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=216u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^232u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=217u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^233u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=218u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^234u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=219u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^235u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=220u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^236u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=221u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^237u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=222u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^238u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=223u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^239u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=224u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^240u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=225u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^241u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=226u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^242u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=227u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^243u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=228u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^244u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=229u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^245u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=230u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^246u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=231u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^247u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=232u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^248u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=233u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^249u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=234u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^250u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=235u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^251u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=236u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^252u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=237u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^253u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=238u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^254u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=239u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^255u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=240u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^256u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=241u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^257u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=242u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^258u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=243u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^259u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=244u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^260u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=245u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^261u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=246u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^262u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=247u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^263u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=248u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^264u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=249u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^265u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=250u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^266u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=251u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^267u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=252u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^268u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=253u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^269u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=254u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^270u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=255u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^271u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=256u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^272u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=257u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^273u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=258u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^274u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=259u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^275u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=260u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^276u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=261u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^277u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=262u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^278u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=263u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^279u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=264u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^280u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=265u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^281u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=266u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^282u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=267u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^283u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=268u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^284u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=269u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^285u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=270u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^286u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=271u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^287u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=272u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^288u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=273u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^289u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=274u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^290u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=275u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^291u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=276u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^292u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=277u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^293u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=278u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^294u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=279u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^295u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=280u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^296u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=281u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^297u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=282u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^298u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=283u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^299u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=284u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^300u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=285u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^301u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=286u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^302u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=287u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^303u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=288u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^304u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=289u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^305u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=290u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^306u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=291u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^307u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=292u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^308u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=293u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^309u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=294u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^310u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=295u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^311u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=296u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^312u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=297u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^313u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=298u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^314u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=299u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^315u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=300u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^316u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=301u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^317u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=302u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^318u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=303u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^319u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=304u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^320u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=305u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^321u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=306u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^322u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=307u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^323u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=308u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^324u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=309u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^325u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=310u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^326u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=311u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^327u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=312u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^328u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=313u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^329u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=314u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^330u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=315u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^331u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=316u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^332u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=317u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^333u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=318u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^334u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=319u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^335u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=320u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^336u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=321u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^337u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=322u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^338u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=323u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^339u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=324u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^340u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=325u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^341u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=326u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^342u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=327u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^343u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=328u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^344u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=329u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^345u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=330u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^346u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=331u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^347u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=332u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^348u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=333u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^349u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=334u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^350u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=335u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^351u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=336u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^352u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=337u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^353u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=338u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^354u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=339u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^355u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=340u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^356u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=341u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^357u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=342u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^358u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=343u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^359u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=344u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^360u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=345u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^361u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=346u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^362u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=347u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^363u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=348u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^364u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=349u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^365u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=350u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^366u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=351u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^367u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=352u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^368u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=353u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^369u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=354u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^370u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=355u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^371u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=356u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^372u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=357u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^373u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=358u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^374u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=359u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^375u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=360u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^376u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=361u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^377u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=362u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^378u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=363u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^379u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=364u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^380u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=365u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^381u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=366u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^382u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=367u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^383u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=368u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^384u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=369u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^385u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=370u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^386u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=371u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^387u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=372u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^388u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=373u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^389u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=374u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^390u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=375u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^391u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=376u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^392u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=377u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^393u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=378u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^394u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=379u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^395u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=380u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^396u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=381u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^397u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=382u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^398u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=383u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^399u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=384u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^400u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=385u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^401u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=386u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^402u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=387u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^403u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=388u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^404u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=389u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^405u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=390u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^406u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=391u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^407u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=392u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^408u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=393u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^409u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=394u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^410u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=395u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^411u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=396u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^412u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=397u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^413u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=398u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^414u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=399u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^415u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=400u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^416u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=401u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^417u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=402u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^418u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=403u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^419u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=404u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^420u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=405u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^421u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=406u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^422u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=407u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^423u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=408u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^424u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=409u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^425u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=410u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^426u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=411u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^427u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=412u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^428u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=413u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^429u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=414u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^430u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=415u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^431u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=416u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^432u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=417u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^433u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=418u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^434u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=419u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^435u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=420u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^436u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=421u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^437u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=422u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^438u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=423u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^439u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=424u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^440u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=425u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^441u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=426u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^442u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=427u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^443u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=428u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^444u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=429u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^445u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=430u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^446u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=431u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^447u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=432u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^448u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=433u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^449u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=434u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^450u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=435u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^451u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=436u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^452u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=437u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^453u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=438u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^454u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=439u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^455u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=440u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^456u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=441u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^457u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=442u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^458u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=443u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^459u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=444u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^460u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=445u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^461u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=446u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^462u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=447u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^463u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=448u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^464u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=449u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^465u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=450u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^466u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=451u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^467u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=452u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^468u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=453u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^469u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=454u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^470u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=455u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^471u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=456u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^472u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=457u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^473u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=458u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^474u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=459u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^475u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=460u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^476u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=461u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^477u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=462u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^478u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=463u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^479u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=464u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^480u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=465u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^481u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=466u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^482u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=467u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^483u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=468u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^484u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=469u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^485u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=470u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^486u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=471u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^487u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=472u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^488u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=473u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^489u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=474u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^490u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=475u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^491u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=476u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^492u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=477u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^493u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=478u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^494u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=479u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^495u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=480u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^496u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=481u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^497u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=482u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^498u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=483u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^499u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=484u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^500u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=485u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^501u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=486u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^502u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=487u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^503u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=488u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^504u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=489u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^505u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=490u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^506u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=491u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^507u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=492u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^508u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=493u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^509u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=494u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^510u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=495u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^511u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=496u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^512u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=497u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^513u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=498u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^514u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=499u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^515u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=500u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^516u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=501u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^517u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=502u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^518u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=503u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^519u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=504u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^520u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=505u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^521u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=506u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^522u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=507u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^523u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=508u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^524u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=509u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^525u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=510u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^526u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=511u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^527u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=512u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^528u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=513u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^529u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=514u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^530u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=515u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^531u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=516u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^532u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=517u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^533u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=518u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^534u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=519u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^535u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=520u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^536u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=521u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^537u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=522u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^538u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=523u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^539u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=524u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^540u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=525u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^541u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=526u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^542u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=527u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^543u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=528u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^544u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=529u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^545u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=530u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^546u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=531u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^547u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=532u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^548u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=533u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^549u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=534u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^550u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=535u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^551u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=536u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^552u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=537u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^553u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=538u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^554u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=539u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^555u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=540u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^556u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=541u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^557u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=542u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^558u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=543u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^559u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=544u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^560u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=545u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^561u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=546u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^562u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=547u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^563u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=548u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^564u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=549u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^565u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=550u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^566u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=551u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^567u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=552u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^568u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=553u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^569u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=554u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^570u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=555u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^571u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=556u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^572u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=557u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^573u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=558u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^574u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=559u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^575u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=560u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^576u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=561u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^577u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=562u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^578u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=563u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^579u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=564u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^580u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=565u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^581u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=566u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^582u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=567u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^583u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=568u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^584u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=569u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^585u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=570u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^586u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=571u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^587u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=572u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^588u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=573u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^589u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=574u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^590u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=575u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^591u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=576u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^592u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=577u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^593u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=578u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^594u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=579u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^595u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=580u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^596u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=581u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^597u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=582u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^598u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=583u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^599u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=584u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^600u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=585u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^601u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=586u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^602u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=587u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^603u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=588u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^604u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=589u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^605u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=590u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^606u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=591u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^607u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=592u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^608u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=593u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^609u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=594u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^610u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=595u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^611u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=596u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^612u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=597u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^613u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=598u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^614u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=599u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^615u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=600u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^616u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=601u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^617u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=602u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^618u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=603u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^619u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=604u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^620u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=605u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^621u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=606u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^622u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=607u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^623u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=608u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^624u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=609u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^625u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=610u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^626u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=611u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^627u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=612u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^628u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=613u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^629u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=614u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^630u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=615u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^631u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=616u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^632u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=617u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^633u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=618u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^634u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=619u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^635u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=620u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^636u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=621u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^637u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=622u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^638u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=623u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^639u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=624u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^640u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=625u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^641u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=626u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^642u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=627u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^643u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=628u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^644u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=629u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^645u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=630u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^646u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=631u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^647u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=632u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^648u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=633u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^649u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=634u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^650u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=635u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^651u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=636u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^652u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=637u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^653u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=638u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^654u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=639u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^655u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=640u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^656u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=641u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^657u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=642u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^658u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=643u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^659u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=644u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^660u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=645u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^661u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=646u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^662u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=647u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^663u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=648u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^664u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=649u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^665u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=650u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^666u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=651u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^667u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=652u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^668u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=653u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^669u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=654u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^670u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=655u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^671u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=656u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^672u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=657u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^673u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=658u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^674u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=659u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^675u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=660u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^676u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=661u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^677u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=662u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^678u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=663u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^679u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=664u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^680u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=665u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^681u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=666u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^682u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=667u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^683u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=668u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^684u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=669u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^685u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=670u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^686u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=671u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^687u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=672u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^688u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=673u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^689u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=674u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^690u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=675u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^691u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=676u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^692u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=677u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^693u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=678u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^694u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=679u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^695u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=680u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^696u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=681u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^697u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=682u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^698u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=683u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^699u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=684u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^700u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=685u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^701u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=686u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^702u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=687u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^703u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=688u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^704u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=689u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^705u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=690u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^706u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=691u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^707u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=692u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^708u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=693u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^709u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=694u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^710u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=695u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^711u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=696u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^712u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=697u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^713u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=698u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^714u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=699u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^715u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=700u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^716u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=701u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^717u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=702u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^718u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=703u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^719u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=704u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^720u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=705u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^721u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=706u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^722u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=707u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^723u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=708u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^724u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=709u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^725u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=710u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^726u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=711u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^727u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=712u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^728u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=713u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^729u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=714u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^730u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=715u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^731u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=716u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^732u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=717u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^733u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=718u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^734u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=719u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^735u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=720u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^736u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=721u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^737u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=722u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^738u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=723u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^739u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=724u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^740u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=725u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^741u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=726u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^742u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=727u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^743u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=728u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^744u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=729u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^745u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=730u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^746u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=731u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^747u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=732u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^748u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=733u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^749u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=734u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^750u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=735u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^751u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=736u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^752u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=737u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^753u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=738u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^754u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=739u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^755u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=740u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^756u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=741u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^757u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=742u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^758u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=743u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^759u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=744u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^760u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=745u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^761u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=746u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^762u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=747u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^763u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=748u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^764u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=749u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^765u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=750u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^766u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=751u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^767u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=752u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^768u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=753u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^769u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=754u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^770u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=755u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^771u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=756u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^772u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=757u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^773u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=758u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^774u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=759u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^775u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=760u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^776u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=761u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^777u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=762u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^778u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=763u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^779u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=764u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^780u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=765u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^781u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=766u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^782u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=767u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^783u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=768u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^784u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=769u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^785u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=770u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^786u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=771u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^787u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=772u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^788u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=773u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^789u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=774u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^790u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=775u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^791u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=776u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^792u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=777u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^793u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=778u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^794u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=779u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^795u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=780u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^796u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=781u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^797u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=782u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^798u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=783u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^799u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=784u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^800u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=785u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^801u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=786u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^802u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=787u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^803u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=788u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^804u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=789u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^805u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=790u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^806u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=791u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^807u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=792u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^808u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=793u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^809u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=794u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^810u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=795u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^811u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=796u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^812u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=797u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^813u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=798u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^814u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=799u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^815u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=800u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^816u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=801u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^817u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=802u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^818u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=803u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^819u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=804u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^820u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=805u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^821u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=806u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^822u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=807u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^823u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=808u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^824u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=809u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^825u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=810u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^826u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=811u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^827u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=812u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^828u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=813u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^829u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=814u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^830u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=815u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^831u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=816u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^832u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=817u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^833u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=818u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^834u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=819u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^835u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=820u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^836u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=821u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^837u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=822u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^838u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=823u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^839u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=824u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^840u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=825u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^841u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=826u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^842u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=827u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^843u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=828u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^844u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=829u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^845u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=830u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^846u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=831u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^847u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=832u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^848u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=833u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^849u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=834u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^850u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=835u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^851u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=836u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^852u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=837u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^853u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=838u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^854u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=839u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^855u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=840u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^856u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=841u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^857u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=842u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^858u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=843u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^859u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=844u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^860u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=845u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^861u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=846u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^862u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=847u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^863u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=848u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^864u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=849u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^865u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=850u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^866u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=851u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^867u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=852u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^868u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=853u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^869u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=854u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^870u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=855u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^871u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=856u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^872u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=857u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^873u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=858u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^874u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=859u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^875u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=860u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^876u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=861u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^877u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=862u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^878u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=863u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^879u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=864u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^880u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=865u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^881u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=866u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^882u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=867u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^883u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=868u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^884u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=869u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^885u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=870u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^886u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=871u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^887u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=872u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^888u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=873u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^889u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=874u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^890u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=875u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^891u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=876u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^892u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=877u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^893u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=878u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^894u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=879u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^895u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=880u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^896u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=881u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^897u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=882u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^898u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=883u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^899u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=884u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^900u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=885u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^901u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=886u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^902u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=887u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^903u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=888u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^904u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=889u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^905u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=890u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^906u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=891u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^907u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=892u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^908u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=893u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^909u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=894u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^910u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=895u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^911u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=896u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^912u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=897u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^913u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=898u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^914u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=899u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^915u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=900u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^916u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=901u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^917u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=902u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^918u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=903u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^919u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=904u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^920u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=905u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^921u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=906u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^922u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=907u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^923u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=908u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^924u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=909u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^925u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=910u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^926u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=911u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^927u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=912u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^928u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=913u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^929u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=914u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^930u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=915u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^931u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=916u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^932u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=917u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^933u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=918u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^934u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=919u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^935u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=920u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^936u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=921u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^937u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=922u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^938u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=923u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^939u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=924u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^940u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=925u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^941u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=926u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^942u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=927u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^943u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=928u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^944u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=929u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^945u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=930u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^946u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=931u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^947u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=932u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^948u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=933u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^949u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=934u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^950u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=935u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^951u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=936u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^952u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=937u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^953u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=938u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^954u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=939u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^955u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=940u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^956u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=941u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^957u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=942u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^958u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=943u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^959u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=944u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^960u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=945u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^961u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=946u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^962u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=947u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^963u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=948u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^964u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=949u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^965u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=950u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^966u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=951u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^967u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=952u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^968u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=953u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^969u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=954u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^970u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=955u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^971u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=956u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^972u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=957u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^973u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=958u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^974u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=959u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^975u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=960u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^976u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=961u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^977u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=962u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^978u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=963u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^979u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=964u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^980u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=965u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^981u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=966u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^982u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=967u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^983u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=968u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^984u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=969u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^985u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=970u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^986u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=971u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^987u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=972u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^988u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=973u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^989u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=974u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^990u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=975u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^991u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=976u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^992u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=977u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^993u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=978u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^994u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=979u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^995u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=980u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^996u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=981u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^997u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=982u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^998u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=983u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^999u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=984u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1000u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=985u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1001u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=986u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1002u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=987u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1003u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=988u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1004u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=989u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1005u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=990u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1006u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=991u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1007u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=992u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1008u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=993u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1009u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=994u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1010u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=995u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1011u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=996u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1012u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=997u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1013u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=998u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1014u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=999u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1015u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1000u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1016u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1001u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1017u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1002u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1018u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1003u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1019u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1004u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1020u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1005u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1021u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1006u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1022u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1007u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1023u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1008u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1024u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1009u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1025u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1010u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1026u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1011u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1027u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1012u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1028u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1013u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1029u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1014u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1030u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1015u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1031u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1016u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1032u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1017u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1033u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1018u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1034u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1019u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1035u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1020u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1036u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1021u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1037u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1022u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1038u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1023u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1039u}; x=a[((x>>1u),x&1u)]; }
 { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=1024u,x),(j,k));
 x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);
 x+=(unsigned)sizeof((x+=99u,x));
 unsigned a[2]={x,x^1040u}; x=a[((x>>1u),x&1u)]; }
 return x; }
int main(void) { printf("%u\n",comma_body(42)); return 0; }
