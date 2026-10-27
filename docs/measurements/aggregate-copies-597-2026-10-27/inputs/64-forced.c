struct S{unsigned char bytes[64];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,64UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,64UL))[63];}
void same(struct S*d){memmove(d,d,64UL);}
