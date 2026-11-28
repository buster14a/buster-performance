#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(locale_t l, int c) { return tolower_l(c, l) + toupper_l((unsigned char)c, l); }
