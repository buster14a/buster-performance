typedef int P(int);
typedef void V(int);
static int state;
extern V emit;
extern P choose;
P *known;
V *known_void;
void f(int a){ if (a) { emit(a); } else { emit(1); } }
int g(int b) { while (b--) { emit(b); } return choose(b); }
int e(int n){switch(n) {case 3: {emit(n); break;} default: {emit(1);break;} } return choose(n); }
int q(int j){int k=({choose(j);});return k;}
int m(int v){label: emit(v); if (v--) goto label; return v;}
int u(int v){ if (0) {emit(v);} return sizeof(choose(v)); }
