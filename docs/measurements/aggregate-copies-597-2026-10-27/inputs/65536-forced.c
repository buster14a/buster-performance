struct S{unsigned char bytes[65536];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,65536UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,65536UL))[65535];}
void same(struct S*d){memmove(d,d,65536UL);}
