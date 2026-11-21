enum E { A, B, C = 4, D, E1 = D };
int good(enum E e) { switch(e) { case A: case B: case C: case D: return 1; } return 0; }
int missing(enum E e) { switch(e) { case A: return 2; } return 0; }
int outside(enum E e) { switch(e) { case 8: case 9: case 10: default: return 3; } }
int ranges(enum E e) { switch(e) { case 1 ... 3: case 6 ... 8: return 4; } return 0; }
int badrange(enum E e) { switch(e) { case 7 ... 6: default: return 5; } }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
int ignored(enum E e) { switch(e) { case 6: return 6; } return 0; }
#pragma clang diagnostic pop
int later(enum E e) { switch(e) { case A: case B: case C: case D: default: return 7; } }
