extern int g, h; extern void die(void) __attribute__((noreturn));
static int unused(int x) { return x + 243; }
static inline int unused_i(int x) { return x + 244; }
static __attribute__((unused)) int unused_a(int x) { return x ^ 245; }
static int unused_const(void) { return 25^8; }
static int unused_global(void) { return h+g; }
int straight(int x) { x=6; return x+1; }
int go(int x) { goto stop; x=1; stop: return x+6; }
int conditional_go(int x) { if(x)goto stop; x=6; stop: return x+2; }
int earlier_return(int x) { return x+1; x=6; return x+4; }
int earlier_if(int x) { if(1) return x+4; x=8; return x+5; }
int earlier_if2(int x) { if(1) { return x+3; } x=9; return x+5; }
int earlier_die(int x) { die(); x=6; return x+7; }
int earlier_loop(int x) { for(;;) g++; x=6; return x+8; }
int earlier_loop2(int x) { while(1) g++; x=6; return x+8; }
int cond0(int x) { if(0) { x=2; return x+3; } return x+5; }
int cond1(int x) { if(1) { x=2; return x+3; } else { x=6; return x+5; } }
int cond_and(int x) { if(0 && x) { x=3;return x+3; } return x+6; }
int cond_or(int x) { if(1 || x) { x=3;return x+3; } else {x=2;return x+5;} }
int nested(int x) { if(x) { if(0 && x) {x=2;} } return x+4; }
int for0(int x) { for(;0;) { x=6; } return x+5; }
int while0(int x) { while(0) { x=6; } return x+5; }
int do0(int x) { do { x=6; } while(0); return x+5; }
int switchx(int x) { switch(1) {case 0: x=4; break; case 1:x=2;break;default:x=8;} return x+6; }
