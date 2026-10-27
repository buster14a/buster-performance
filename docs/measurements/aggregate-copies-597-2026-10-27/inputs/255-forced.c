struct S{unsigned char bytes[255];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,255UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,255UL))[254];}
void same(struct S*d){memmove(d,d,255UL);}
