struct S{unsigned char bytes[4096];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,4096UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,4096UL))[4095];}
void same(struct S*d){memmove(d,d,4096UL);}
