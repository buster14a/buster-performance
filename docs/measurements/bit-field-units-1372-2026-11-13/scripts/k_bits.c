// #1372's kernel, as the issue gives it: two read-modify-writes of a 32-bit run of bit-fields, then four reads.
struct B { unsigned x : 3, y : 7, z : 13, w : 9; };
unsigned k_bits(struct B *b) { b->y += b->x; b->z ^= b->w; return b->x + b->y + b->z + b->w; }
