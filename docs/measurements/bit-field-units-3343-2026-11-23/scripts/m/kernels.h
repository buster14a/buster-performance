// #1372's leftovers: the records whose bit-fields' accesses the change moves to clang's units.
struct B { unsigned x : 3, y : 7, z : 13, w : 9; };
union U { unsigned x : 3; unsigned y : 17; unsigned long long z : 40; };
struct __attribute__((ms_struct)) M { unsigned x : 3; unsigned y : 7; unsigned short z : 5; unsigned char w : 4; };
struct __attribute__((packed)) Q { unsigned a : 30, b : 30, c : 30; };
