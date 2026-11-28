#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
static int x = tolower(300); int g(void) { return x; }
