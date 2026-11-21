struct S { int x:3; }; int f(struct S *p,int i){return (int)(unsigned long)&p[i].x;}
