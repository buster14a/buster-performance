extern int fetch(char*,int); int g(int a){char tmp[a];char *p; p=tmp; p[0]=42;return fetch(p,a);}
