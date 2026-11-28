#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int *f(int *p) { return &tolower(*p); }
