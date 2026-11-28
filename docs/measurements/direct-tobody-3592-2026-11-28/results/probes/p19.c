#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { if (tolower(c) == 'a') return 1; return 0; }
