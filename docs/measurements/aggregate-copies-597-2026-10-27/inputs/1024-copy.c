struct S{unsigned char bytes[1024];};
void copy(struct S*d,const struct S*s){*d=*s;}
