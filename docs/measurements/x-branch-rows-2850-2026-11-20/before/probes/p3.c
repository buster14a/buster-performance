struct s { _Bool flag; unsigned char byte; }; int f(const struct s* p, int b) { if (p->flag && b) return 1; return 0; }
