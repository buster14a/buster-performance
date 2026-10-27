struct S{unsigned char bytes[257];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[256];}
