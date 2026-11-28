#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { int x = tolower(c) ? 1 : 2; return x; }
