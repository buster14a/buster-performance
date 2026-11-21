int from_uninitialized(int x) { int n; for (x = n; x < 2; ++x) { } return x; }
int assigned_parameter(int x) { for (x = 24; ; ) { break; } return 1; }
int pure_condition(int n, int x) { for (; (x = n); ) { return x; } return x; }
int untouched(int i, int n) { for (i = n; i < 5; ) { n = n; } return i; }
int self(int x) { for (x = x; x <= 6; ++x) { } return x; }
int merged(int x,int n) { for (x = n; x > 0; --x) { if (x==11) break; } return x; }
int expression(int x) { return ({ for (x = 0; x < 3; ++x) { } x; }); }
int declaration(void) { for (int k=2; k>0; k--) { } return 3; }
