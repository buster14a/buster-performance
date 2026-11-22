#pragma GCC system_header
struct Inner { short a; char b; };
static int unused(int x) { struct Inner (*p)[7] = 0; unsigned char **q = 0; long double _Complex *z = 0; return x + (p != 0) + (q != 0) + (z != 0); }
