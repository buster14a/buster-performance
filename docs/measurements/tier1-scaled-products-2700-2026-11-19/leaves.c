unsigned long scaled2(unsigned long x, unsigned long y) { return x + y * 2; }
unsigned long scaled4(unsigned long x, unsigned long y) { return x + 4 * y; }
unsigned long scaled8(unsigned long x, unsigned long y) { return y * 8 + x; }
unsigned scaled32(unsigned x, unsigned y) { return x + y * 4; }
unsigned long shifted(unsigned long x, unsigned long y) { return x + (y << 2); }
unsigned long large(unsigned long x, unsigned long y) { return x + y * 16; }
unsigned long shared(unsigned long x, unsigned long y, unsigned long *out) { unsigned long p = y * 4; *out = p; return x + p; }
