inline int f(void);
int g(void){return f();}
inline int f(void){return 7;}
extern int f(void);
