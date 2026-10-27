struct S{unsigned char bytes[65536];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[65535];}
