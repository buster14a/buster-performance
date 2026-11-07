#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/x86_64_encoder.c"
#define N(name, ...) #name,
static const char* const names[X86_FORM_COUNT] = { BUSTER_X86_FORMS(N, N) };
int main(void) { for (int i = 0; i < X86_FORM_COUNT; i++) printf("%d %s\n", i, names[i]); return 0; }
