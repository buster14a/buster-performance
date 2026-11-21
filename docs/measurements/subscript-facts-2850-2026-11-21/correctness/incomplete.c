struct X; int f(struct X *p) {return (int)(unsigned long)&p[1];} struct X{int x;};
