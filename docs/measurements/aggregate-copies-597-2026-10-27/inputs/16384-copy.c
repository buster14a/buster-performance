struct S{unsigned char bytes[16384];};
void copy(struct S*d,const struct S*s){*d=*s;}
