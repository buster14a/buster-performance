#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(void) { return tolower('A') + toupper('z') + tolower(-1) + toupper(255) + tolower(256) + toupper(-129); }
