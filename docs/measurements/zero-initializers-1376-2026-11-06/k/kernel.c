struct Big { long a[40]; int flags; };
int k_array(int i) { int a[256] = { 0 }; a[i & 255] = i; return a[(i * 7) & 255]; }
long k_partial(int i) { long a[64] = { 1, 2, 3 }; a[i & 63] = i; return a[(i * 7) & 63]; }
long k_struct(int i) { struct Big b = { 0 }; b.a[i & 31] = i; return b.a[(i * 3) & 31] + b.flags; }
long k_literal(int i) { struct Big b = (struct Big){ .flags = i }; b.a[i & 31] = i; return b.a[(i * 3) & 31] + b.flags; }
long k_copy(const struct Big* p, int i) { struct Big b = *p; b.a[i & 31] = i; return b.a[(i * 3) & 31] + b.flags; }
struct Big k_make(int);
long k_return(int i) { struct Big b = k_make(i); b.a[i & 31] = i; return b.a[(i * 3) & 31] + b.flags; }
