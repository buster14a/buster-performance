#!/bin/sh
# gen.sh N [static|strings]: a function whose local array has an N-element brace initializer (#1349's generator).
N=$1; S=${2:-}
if [ "$S" = strings ]; then
    printf 'const char *g(unsigned i) { const char *t[] = {'; i=0; seq -f '"str%.0f"' -s, 0 $((N - 1)) | tr -d '\n'; printf '}; return t[i %% %d]; }\n' "$N"
elif [ "$S" = static ]; then
    printf 'int g(unsigned i) { static const int t[] = {'; seq -s, 0 $((N - 1)) | tr -d '\n'; printf '}; return t[i %% %d]; }\n' "$N"
else
    printf 'int g(unsigned i) { const int t[] = {'; seq -s, 0 $((N - 1)) | tr -d '\n'; printf '}; return t[i %% %d]; }\n' "$N"
fi
