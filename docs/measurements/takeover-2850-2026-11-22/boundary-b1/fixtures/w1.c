static int undefined_internal(void);
int tentative[];
int uses(int a) { return a + undefined_internal(); }
int other(int a) { return a * 2; }
