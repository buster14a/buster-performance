struct S{unsigned char bytes[8192];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,8192UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,8192UL))[8191];}
void same(struct S*d){memmove(d,d,8192UL);}
