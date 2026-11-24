#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p input
clang -std=c17 -O2 -Wall -Wextra -Werror fixture.c -o input/generate
while read -r label fields rows group; do
    input/generate "$fields" "$rows" "$group" source > "input/$label.c"
    input/generate "$fields" "$rows" "$group" bytes > "input/$label.expected"
done < shapes.txt
