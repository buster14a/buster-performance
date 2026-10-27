struct S{unsigned char bytes[512];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,512UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,512UL))[511];}
void same(struct S*d){memmove(d,d,512UL);}
