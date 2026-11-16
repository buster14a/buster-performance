unsigned long f11(int a) { unsigned long n = sizeof(a++); return n; }
unsigned long f11b(void) { return sizeof(int) + _Alignof(long); }
unsigned long f11c(int a) { unsigned long n; n = sizeof a; return n + 1; }
