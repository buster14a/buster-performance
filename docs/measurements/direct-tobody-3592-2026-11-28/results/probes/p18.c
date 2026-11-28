#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(unsigned char c) { return toupper(c) == 'A'; }
