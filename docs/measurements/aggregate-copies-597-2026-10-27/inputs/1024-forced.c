struct S{unsigned char bytes[1024];};
extern void*memmove(void*,const void*,unsigned long);
void copy(struct S*d,const struct S*s){memmove(d,s,1024UL);}
unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,1024UL))[1023];}
void same(struct S*d){memmove(d,d,1024UL);}
