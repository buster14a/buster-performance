#include_next <ctype.h>
#undef __tobody
#define __tobody(c, f, a, args) ((int) (sizeof (c) > 1 ? (__builtin_constant_p (c) ? ((int) (c) < -128 || (int) (c) > 255 ? (int) (c) : (a)[(int) (c)]) : f args) : (a)[(int) (c)]))
