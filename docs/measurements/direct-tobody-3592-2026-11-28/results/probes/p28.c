#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { int (*p)(int) = tolower; return p(c); }
