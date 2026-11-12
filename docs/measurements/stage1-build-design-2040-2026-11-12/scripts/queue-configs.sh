#!/bin/bash
# The build's other structures and configurations, after the queue named by $1 ends, each build its own hold of the
# lock, in clones of their own:
#   units-only   today's Release build of the eleven main.c units alone (no benchmark or tool object, no link): what a
#                clean build would take with those objects built on demand; then the rest, the 32 other objects and the link
#   g0           Release without debug information (BUSTER_DEBUG_INFO=0), as CI builds
#   debug        the Debug configuration (-O0 -g)
#   o1           the developer configuration the task asks about: -O1 without -g (the `o1` clone, whose description says
#                -O1 where main's says -O3, for the units and for their parts' code generation)
# each a clean build twice and the checker's edit twice; then the trees restored and rebuilt for the tests' runs.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
echo $$ > queue-configs.pid
while kill -0 "$(cat "${1:-queue-self}.pid" 2>/dev/null)" 2>/dev/null; do sleep 5; done
revision=c5f0efb20199618a542f0d8de61951916c15d76c
for tree in cfg o1; do
    [ -d $tree ] || { git clone -q src $tree && git -C $tree checkout -q $revision; }
done
sed -i 's/set(optimization -O3)/set(optimization -O1)/' o1/cmake/BusterSettings.cmake
sed -i 's/-fno-stack-protector -O3 -Wall -Werror/-fno-stack-protector -O1 -Wall -Werror/' o1/cmake/BusterCodegen.cmake
git -C o1 diff > logs/o1.patch
one() { scripts/lock.sh scripts/run.sh "$@"; }
units=(--target buster_main --target Release/codegen/main_unit_checker/native.o --target Release/codegen/main_unit_backend/native.o)
for unit in x86 frontend assembler link executable dynamic types check_builtins; do units+=(--target buster_main_unit_$unit); done
for rep in 1 2; do
    one configs cfg units-only clean - $rep "${units[@]}"
    one configs cfg rest none - $rep
done
export BUSTER_DEBUG_INFO=0
for rep in 1 2; do one configs cfg g0-clean clean - $rep; done
for rep in 1 2; do one configs cfg g0-checker append c_check_input.c $rep; done
unset BUSTER_DEBUG_INFO
for rep in 1 2; do one configs cfg debug-clean clean - $rep --config Debug; done
for rep in 1 2; do one configs cfg debug-checker append c_check_input.c $rep --config Debug; done
git -C cfg checkout -q -- src
one configs cfg debug-restore none - 0 --config Debug
export BUSTER_DEBUG_INFO=0
for rep in 1 2; do one configs o1 o1-clean clean - $rep; done
for rep in 1 2; do one configs o1 o1-checker append c_check_input.c $rep; done
git -C o1 checkout -q -- src
one configs o1 o1-restore none - 0
unset BUSTER_DEBUG_INFO
scripts/lock.sh scripts/tests.sh o1 "$d/o1/build/compiler"
scripts/lock.sh scripts/tests.sh debug "$d/cfg/build/compiler" 1 7
echo done >> results/configs.txt
