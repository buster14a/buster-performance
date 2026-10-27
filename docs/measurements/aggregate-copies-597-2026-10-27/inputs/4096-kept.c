struct S{unsigned char bytes[4096];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[4095];}
