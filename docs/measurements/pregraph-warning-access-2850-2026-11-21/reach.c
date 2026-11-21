extern int ident(int);
int after_return(void) { int x; return 0; return x; }
int reachable_read(void) { int x; return x; }
int dead_assignment(void) { int x; goto live; x=1; live: return x; }
int live_assignment(void) { int x; x=1; return x; }
int cond_read(int c) { int x; if (c) return 0; return x; }
int set_only(int a) { a++; return 0; }
int use_update(int a) { return a++; }
