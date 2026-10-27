struct S{unsigned char bytes[257];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,257UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,257UL))[256];}
void same(struct S*d){memmove(d,d,257UL);}
