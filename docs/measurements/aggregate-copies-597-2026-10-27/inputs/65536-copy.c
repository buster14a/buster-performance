struct S{unsigned char bytes[65536];};
void copy(struct S*d,const struct S*s){*d=*s;}
