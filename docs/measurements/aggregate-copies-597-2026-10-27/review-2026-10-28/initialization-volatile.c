struct S{unsigned char bytes[513];};
void destination(const struct S*s){volatile struct S r=*s;}
void source(const volatile struct S*s){struct S r=*s;}
struct S returning(const volatile struct S*s){return *s;}
