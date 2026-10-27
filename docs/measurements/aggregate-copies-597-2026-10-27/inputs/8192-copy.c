struct S{unsigned char bytes[8192];};
void copy(struct S*d,const struct S*s){*d=*s;}
