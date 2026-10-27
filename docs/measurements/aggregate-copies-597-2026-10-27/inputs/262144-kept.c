struct S{unsigned char bytes[262144];};
unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[262143];}
