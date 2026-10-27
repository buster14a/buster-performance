struct S{unsigned char bytes[128];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[127];}
