struct S{unsigned char bytes[32];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[31];}
