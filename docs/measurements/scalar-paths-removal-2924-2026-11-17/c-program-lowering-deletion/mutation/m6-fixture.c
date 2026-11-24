struct S{long v[4];};static void clean(long*p){*p=0;}
static __attribute__((noinline)) struct S make(long n){struct S s={{n,n*3,n+7,n^5}};return s;}
struct S g0(long n){{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g1(long n){n+=1;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g2(long n){n+=1;n+=2;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g3(long n){n+=1;n+=2;n+=3;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g4(long n){n+=1;n+=2;n+=3;n+=4;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g5(long n){n+=1;n+=2;n+=3;n+=4;n+=5;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g6(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g7(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g8(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g9(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g10(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g11(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g12(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g13(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g14(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g15(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g16(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;n+=16;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g17(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;n+=16;n+=17;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g18(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;n+=16;n+=17;n+=18;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g19(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;n+=16;n+=17;n+=18;n+=19;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
struct S g20(long n){n+=1;n+=2;n+=3;n+=4;n+=5;n+=6;n+=7;n+=8;n+=9;n+=10;n+=11;n+=12;n+=13;n+=14;n+=15;n+=16;n+=17;n+=18;n+=19;n+=20;{__attribute__((cleanup(clean)))long c=n;if(n&1)return make(c+1);}return make(n+5);}
