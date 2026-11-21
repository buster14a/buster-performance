typedef int F(void); int f(F *p,int n){return p[n]();}
