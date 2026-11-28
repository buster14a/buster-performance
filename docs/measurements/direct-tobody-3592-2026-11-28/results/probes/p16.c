#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { return _Generic(tolower(c), int: 1, default: 2); }
