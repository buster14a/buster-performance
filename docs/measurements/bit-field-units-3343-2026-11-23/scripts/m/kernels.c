// #1372's kernels: the issue's (k_bits, two read-modify-writes of struct B's run, then four reads) and one for each
// shape whose accesses the leftovers change: a local's initializer then a copy of the whole record (k_init), a union's
// fields (k_union), an ms_struct record's (k_ms) and a packed run of 12 bytes (k_wide).
#include "kernels.h"
unsigned k_bits(struct B* b) { b->y += b->x; b->z ^= b->w; return b->x + b->y + b->z + b->w; }
unsigned k_init(struct B* out, unsigned n) { struct B v = { n, n + 1, n + 2, n + 3 }; *out = v; return out->y; }
unsigned k_union(union U* u) { u->y += u->x; u->z += u->y; return u->x + u->y; }
unsigned k_ms(struct M* m) { m->y += m->x; m->z ^= m->w; return m->x + m->y + m->z + m->w; }
unsigned k_wide(struct Q* q) { q->b += q->a; q->c ^= q->b; return q->a + q->b + q->c; }
