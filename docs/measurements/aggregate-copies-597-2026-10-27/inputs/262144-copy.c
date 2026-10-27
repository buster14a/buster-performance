struct S{unsigned char bytes[262144];};
void copy(struct S*d,const struct S*s){*d=*s;}
