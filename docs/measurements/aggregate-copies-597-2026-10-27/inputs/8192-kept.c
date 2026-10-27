struct S{unsigned char bytes[8192];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[8191];}
