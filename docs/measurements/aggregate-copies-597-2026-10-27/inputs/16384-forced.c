struct S{unsigned char bytes[16384];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,16384UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,16384UL))[16383];}
void same(struct S*d){memmove(d,d,16384UL);}
