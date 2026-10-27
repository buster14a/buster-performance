struct S{unsigned char bytes[1024];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[1023];}
