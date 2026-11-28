#define _GNU_SOURCE
#include <ctype.h>
#include <locale.h>
enum { E = tolower(300) }; int g(void) { return E; }
