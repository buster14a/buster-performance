#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Usage: run1.sh COMPILER MARCH CASE.c -> "name ok", "name fail <first error>", or "name clangfail" where clang -O0 -c
# refuses it too. Run per case, e.g.: ls cases/*.c | xargs -P4 -n1 ./run1.sh build/compiler x86-64 | sort
# run1.sh COMPILER MARCH CASE -> "name status message"
c=$1; m=$2; f=$3; n=$(basename $f .c)
if clang -O0 -march=$m -w -c -o /dev/null $f 2>/dev/null; then
  msg=$($c -c -march=$m -w -o ${TMPDIR:-/tmp}/run1.$$.o $f 2>&1 | grep -m1 -o "error: .*" ); rm -f ${TMPDIR:-/tmp}/run1.$$.o
  if [ -z "$msg" ]; then echo "$n ok"; else echo "$n fail $msg"; fi
else echo "$n clangfail"; fi
