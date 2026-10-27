struct S{unsigned char bytes[255];};
void copy(struct S*d,const struct S*s){*d=*s;}
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[254];}
void same(struct S*d){*d=*d;}
