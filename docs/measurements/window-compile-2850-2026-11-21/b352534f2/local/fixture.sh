#!/bin/bash
set -eu
cd "$(dirname "$0")"
for arm in clang ordinary source;do
 case $arm in clang) clang -c fixture.c -o clang.o;; ordinary) ../main-fbef-clean/build/compiler --lanes 1 -c fixture.c -o ordinary.o;; source) BUSTER_CONTROL_SOURCE_NATIVE=1 BUSTER_CONTROL_SOURCE_AUDIT=1 ./compiler --lanes 1 -c fixture.c -o source.o 2>fixture.log;; esac
 clang "$arm.o" -o "$arm-run"; "./$arm-run"
done
cmp source.o ordinary.o
