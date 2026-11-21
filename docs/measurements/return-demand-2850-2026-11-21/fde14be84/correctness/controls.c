typedef struct { unsigned a, b; } Pair;
extern _Noreturn void quit(void);
extern void declared(void);
extern int foreign(int);
typedef int (*callback)(void);

int cond_return(int n) { if (n) return n; }
int sealed(int n) { if (n < 0) return 2; return 8; }
int goto_end(int n) { if (n) goto out; return 2; out: ; }
int terminal_call(int n) { if (n) return 3; quit(); }
int unknown_edge(callback fn) { fn(); }
int nested_call(callback fn, int n) { if (n) return foreign(fn()); }
int switch_late(int n) { switch (n) { case 1: return n; default: break; } }
int loop(int n) { for (;;) { if (n) return n; } }
int unevaluated(int n) { (void)sizeof(foreign(n)); if (n) return 1; }
int conditional(int n, callback fn) { (n ? fn() : 1); if (n) return n; }
int statements(int x) { return ({ int y=x+2; y; }); }
Pair aggregate_ok(int n) { Pair a = {1,2}; if (n) return a; return (Pair){2,1}; }
Pair aggregate_late(int n) { if (n) return (Pair){1,2}; }
_Noreturn void warning_nonreturn(int n) { if (n) quit(); }
_Noreturn void right_nonreturn(void) { quit(); }

int deep(int x) { if (x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x+x) return x; }
