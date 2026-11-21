#define LABEL(x) ({__label__ end; int z=0; if(x) goto end; z=1; end:z;})
int a(int x){return LABEL(x)+LABEL(x-1);} static int k;
int sx(int x){if(0)k=4; if(1&&0)k=8; if(x){k=9;} return 1+(2*3);}
static int closed(int k){k=2;return k;}
