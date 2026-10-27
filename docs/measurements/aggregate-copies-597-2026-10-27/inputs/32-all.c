struct S{unsigned char bytes[32];};
void copy(struct S*d,const struct S*s){*d=*s;}
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[31];}
void same(struct S*d){*d=*d;}
