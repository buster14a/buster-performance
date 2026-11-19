struct s { int a; int b; };
int f01(void) { if (*(int*)4096) return 1; return 0; }
int f02(void) { if (*(volatile int*)4096) return 1; return 0; }
int f03(int a) { if (*(int*)4096 && a) return 1; return 0; }
int f04(int a) { if (a && *(int*)4096) return 1; return 0; }
int f05(int a) { if (*(int*)4096 || a) return 1; return 0; }
int f06(void) { return *(int*)4096 ? 3 : 4; }
int f07(void) { return *(int*)4096 && 1; }
int f08(void) { return !*(int*)4096; }
int f09(void) { while (*(int*)4096) { } return 0; }
int f10(void) { int n = 0; do { n++; } while (*(int*)4096); return n; }
int f11(void) { int n = 0; for (; *(int*)4096; ) { n++; } return n; }
int f12(void) { return *(int*)4096 != 0; }
int f13(void) { return (_Bool)*(int*)4096; }
int f14(void) { return ((struct s*)4096)->b ? 1 : 0; }
int f15(void) { return ((int*)4096)[3] ? 1 : 0; }
int f16(void) { if (*(int*)0) return 1; return 0; }
int f17(void) { return *(char*)4096 ? 1 : 0; }
int f18(void) { return *(int**)4096 ? 1 : 0; }
int f19(void) { return *(double*)4096 ? 1 : 0; }
int f20(void) { if (!*(int*)4096) return 1; return 0; }
