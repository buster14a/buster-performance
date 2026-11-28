#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { tolower(c) = 1; return c; }
