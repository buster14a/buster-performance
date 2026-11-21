extern int f(int); int g(int x){{int(*f)(int)=0;if(x) return f(6);}return f(x);}
