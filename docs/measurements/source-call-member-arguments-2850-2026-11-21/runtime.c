#include <stddef.h>
struct operand { int low; char pad[19]; int beyond; struct operand *next; };
static int state;
static int collect(int a, int b, int c) { state=state*5+a*3+b*7+c*13; return state; }
static int checked(struct operand *a,struct operand *b) {return collect(a->beyond,b->low,a->low);}
static int side(struct operand *a) {int old=a->beyond; a->beyond+=17; return old;}
static int mixed(struct operand *a,struct operand *b) {return collect(b->low,side(a),a->low);}
int main(void) {
 struct operand a={2,{0},7,NULL},b={3,{0},11,NULL};
 int expect=7*3+3*7+2*13;
 if(checked(&a,&b)!=expect) return 1;
 expect=expect*5+3*3+7*7+2*13;
 if(mixed(&a,&b)!=expect || a.beyond!=24) return 2;
 expect=expect*5+24*3+3*7+2*13;
 if(checked(&a,&b)!=expect) return 3;
 return 0;
}
