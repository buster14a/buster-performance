void used_and_set(int i, int n) { for (; i<n; i++) { } }
void unused_update(int i) { i++; i--; }
int uninitialized_update(void) { int x; x++; return x; }
void initialized_unused(void) { int x=0; x++; }
int unreachable(int x) { if (0) { x++; } return 1; }
int statement_value(int x) { return ({ x++; }); }
void braced_init(int i) { int q[] = { ({ i++; i; }) }; (void)q; }
int repeated_reads(int n) { int x; x++; x--; return n ? x : 4; }
int for_mutation(int i) { for (; i<4; i++) { } return i; }
int conditional_update(int i) { return i++ ? i : 2; }
