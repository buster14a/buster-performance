#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { if (0) return tolower(c); return toupper(toupper(c)); }
