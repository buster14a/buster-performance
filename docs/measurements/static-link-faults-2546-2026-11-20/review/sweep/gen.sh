#!/bin/sh
# gen.sh N: a static hello world with N bytes of initialized data.
cat <<EOC
#include <stdio.h>
static const unsigned char blob[$1] = { 1, 2, 3 };
int main(int argc, char** argv) { printf("hello %d\n", blob[argc]); return 0; }
EOC
