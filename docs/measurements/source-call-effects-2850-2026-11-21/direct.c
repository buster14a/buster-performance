extern int target(int);
__attribute__((target("no-avx2"), flatten))
int needs_check(void) { return target(1); }
