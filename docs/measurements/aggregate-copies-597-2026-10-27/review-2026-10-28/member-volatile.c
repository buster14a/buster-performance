struct S{unsigned char bytes[512];volatile unsigned char last;};
void copy(struct S*d,const struct S*s){*d=*s;}
void same(struct S*d){*d=*d;}
struct S initialize(const struct S*s){struct S r=*s;return r;}
void destination(volatile struct S*d,const struct S*s){*d=*s;}
