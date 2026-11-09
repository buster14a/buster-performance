#!/bin/bash
set -eu
clang -O2 -Wall -Wextra -Werror measure_struct_tables.c -o measure_struct_tables
./measure_struct_tables generate file250000.c 250000 0
./measure_struct_tables generate local250000.c 250000 1
./measure_struct_tables generate flat1000000.c 1000000 2
./measure_struct_tables generate float50000.c 50000 3
