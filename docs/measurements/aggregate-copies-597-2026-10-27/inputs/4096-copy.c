struct S{unsigned char bytes[4096];};
void copy(struct S*d,const struct S*s){*d=*s;}
