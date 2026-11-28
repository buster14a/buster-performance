#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { __typeof__(tolower(c)) y = 0; return y; }
