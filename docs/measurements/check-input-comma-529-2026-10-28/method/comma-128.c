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
 return x; }
int main(void) { printf("%u\n",comma_body(42)); return 0; }
