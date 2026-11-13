// #1549's kernels: #1376's k_return (a 328-byte struct by hidden pointer), the same behind a cleanup label, and the
// same as a one-member wrapper's initializer.
struct Big { long a[40]; int flags; };
struct Outer { struct Big b; };
struct Big k_make(int);
long k_return(int i) { struct Big b = k_make(i); b.a[i & 31] = i; return b.a[(i * 3) & 31] + b.flags; }
long k_cleanup(int i) { long r = -1; struct Big b = k_make(i); if (i < 0) goto out; b.a[i & 31] = i; r = b.a[(i * 3) & 31] + b.flags; out: return r; }
long k_wrapped(int i) { struct Outer o = { k_make(i) }; o.b.a[i & 31] = i; return o.b.a[(i * 3) & 31] + o.b.flags; }
