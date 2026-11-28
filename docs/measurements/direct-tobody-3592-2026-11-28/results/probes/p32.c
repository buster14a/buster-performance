#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { return __builtin_constant_p(tolower(c)) + __builtin_constant_p(tolower(300)); }
