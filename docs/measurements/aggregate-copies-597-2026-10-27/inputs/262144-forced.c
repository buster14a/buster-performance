struct S{unsigned char bytes[262144];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,262144UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,262144UL))[262143];}
void same(struct S*d){memmove(d,d,262144UL);}
