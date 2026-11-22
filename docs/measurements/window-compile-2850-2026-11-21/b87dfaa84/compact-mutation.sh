#!/bin/bash
set -eu
cd "$(dirname "$0")";d=$PWD
for a in clang production chain poison mutation;do
  envs=();case "$a" in clang) cc=clang;;production) cc=../main-fbef-clean/build/compiler;;chain) cc=./compiler;envs=(BUSTER_CONTROL_MEMBER_OPERANDS=1);;poison) cc=./compiler;envs=(BUSTER_CONTROL_MEMBER_OPERANDS=1 BUSTER_CHAIN_POISON=1);; mutation) cc=./compiler;envs=(BUSTER_CONTROL_MEMBER_OPERANDS=1 BUSTER_CHAIN_MUTATE_TOKEN=75);;esac
  env "${envs[@]}" "$cc" -c probe.c -o "probe-$a.o"
  clang probe-driver.c "probe-$a.o" -o "probe-$a"
  "./probe-$a" > "probe-$a.stdout"
  env "${envs[@]}" "$cc" --dump-typed probe.c -o "$d/probe-$a.typed.o" >"probe-$a.typed" 2>"probe-$a.typed.err" || [[ "$a" == clang ]]
done
cmp probe-production.o probe-chain.o
cmp probe-chain.o probe-poison.o
cmp probe-production.typed probe-chain.typed
cmp probe-chain.typed probe-poison.typed
cmp probe-clang.stdout probe-poison.stdout
if cmp -s probe-poison.stdout probe-mutation.stdout;then exit 1;fi
if cmp -s probe-poison.o probe-mutation.o;then exit 1;fi
