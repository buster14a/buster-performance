struct S{unsigned char bytes[16384];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[16383];}
