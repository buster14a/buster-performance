#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int g(int); int f(int c) { return tolower(g(c)); }
