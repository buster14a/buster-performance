#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(const char *s) { int n = 0; while (*s) { n += tolower((unsigned char)*s); s++; } return n; }
