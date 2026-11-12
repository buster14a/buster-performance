#!/bin/bash
# Builds the record's C tools against the host's LLVM (to be run inside the lock): tools/function_files and
# tools/object_functions.
set -eu
d=$HOME/buster-fast-bench/2040-claude
cd "$d/tools"
clang -O2 -Wall -Wextra -Werror $(llvm-config --cflags) -c function_files.c -o function_files.o
clang++ -o function_files function_files.o $(llvm-config --ldflags) $(llvm-config --link-shared --libs core bitreader)
clang -O2 -Wall -Wextra -Werror object_functions.c -o object_functions
ls -la function_files object_functions
