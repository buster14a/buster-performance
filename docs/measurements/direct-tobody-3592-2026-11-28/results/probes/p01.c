#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
int f(int c) { switch (c) { case tolower(300): return 1; } return 0; }
