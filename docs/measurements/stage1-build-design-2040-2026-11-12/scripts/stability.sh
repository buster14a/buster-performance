#!/bin/bash
# Local stability check of the prototype's parts (not a timing): the checker's unit before and after an edit of
# c_check_input.c, by debug information level: how many of the 25 parts' bitcode files change.
set -u
S=/tmp/claude-0/-home-user-buster/b7674301-5589-53a9-8832-8d0d8ba7e4ba/scratchpad
cd $S/proto
file=src/buster/compiler/c_check_input.c
probe=$'\n__attribute__((used)) static const char* buster_2040_probe_local(void)\n{\n    return "buster_2040_probe local";\n}\n'
compile() { clang $2 -march=native -I$S/proto/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O3 -fmacro-prefix-map=$S/proto/= -emit-llvm -Xclang -disable-llvm-passes -c src/buster/compiler/main_unit_checker.c -o $S/dev/stab/$1.bc; }
middle=$(awk 'NR > 1250 && $0 == "}" { print NR; exit }' $file)
for level in "$@"; do
    case $level in
        g5) flag="-g" ;;
        g4) flag="-g -gdwarf-4" ;;
        g1) flag="-gdwarf-4 -gline-tables-only" ;;
        g0) flag="" ;;
    esac
    git checkout -q -- $file
    compile base-$level "$flag"
    printf '%s\n' "$probe" >> $file
    compile append-$level "$flag"
    git checkout -q -- $file
    { head -n "$middle" $file; printf '%s\n' "$probe"; tail -n "+$((middle + 1))" $file; } > $file.new && mv $file.new $file
    compile middle-$level "$flag"
    git checkout -q -- $file
    { printf '%s\n' "$probe"; cat $file; } > $file.new && mv $file.new $file
    compile top-$level "$flag"
    git checkout -q -- $file
    for v in base append middle top; do
        rm -rf $S/dev/stab/$v-$level; mkdir -p $S/dev/stab/$v-$level
        $S/dev/presplit $S/dev/stab/$v-$level.bc 24 $S/dev/stab/$v-$level --anchor 24 --import 100 ${SPLIT_OPTIONS:-} > /dev/null 2>&1
        (cd $S/dev/stab/$v-$level && sha256sum part*.bc > ../$v-$level.sums)
    done
    for v in append middle top; do
        echo "$level, $v (line $middle of $(wc -l < $file)): $(diff $S/dev/stab/base-$level.sums $S/dev/stab/$v-$level.sums | grep -c '^>') of $(wc -l < $S/dev/stab/base-$level.sums) parts differ"
    done
done
