#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { return toupper(tolower(c)) == toupper(c); }
