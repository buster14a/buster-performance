int f94(int *a, int i) { a[i++] = i; return i; }
int f94b(int i) { return i + i++; }
int f94c(int i) { i = i++; return i; }
