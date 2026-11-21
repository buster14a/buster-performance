#!/bin/bash
set -euo pipefail
bin=$(realpath "$1")
src=$(realpath "$2")
dir=$(realpath "$3")
clang=${CLANG:-clang}
cd "$dir"
cat > use.c <<'C'
extern int different_type;
extern int different_kind;
int object_alias(void);

int main(void)
{
    return !(different_type == 1 && different_kind == 1 && object_alias() == 2);
}
C
"$clang" -c use.c -o consumer.o
"$bin" -g -c "$src" -o aliases.o
"$clang" aliases.o consumer.o -o linked
./linked
"$bin" -g "$src" use.c -o via_driver
./via_driver
echo 'all three weak aliases resolve through the object and direct multi-unit links'
