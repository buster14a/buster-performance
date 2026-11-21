struct S {int x;}; enum E{STEP=2}; typedef int integer;
#pragma STDC FENV_ACCESS ON
extern int iv; int y(int x){ const int c=4; volatile int o=iv; register int r=x; int a=0; a=c; if(o) a=r; return a; }
int z(int x){ int v[x+1]; v[x]=1; return v[x]+STEP; } int w(struct S a){return a.x;}
