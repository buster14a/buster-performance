#!/bin/bash
# Local: each code part of the two new plans with the MSan part flags, 4 at once; wall seconds per part.
cd ~/.cache/claude-2639/local
for d in out-codegencosts out-codegencostspaddedstarts; do
    for p in 0 1 2 3 4 5 6 7; do
        ( start=$EPOCHREALTIME
          clang -x ir --target=x86_64-unknown-linux-gnu -march=znver5 -gline-tables-only -mllvm -experimental-debug-variable-locations=false -fno-stack-protector -fsanitize=memory -fsanitize-memory-track-origins=2 -fno-sanitize-recover=all -fno-sanitize-trap=all -fno-omit-frame-pointer -fno-optimize-sibling-calls -fPIE -O3 -Wall -Werror -Xclang -disable-llvm-passes -Wno-unused-command-line-argument -c $d/part$p.bc -o $d/part$p.o
          echo "$? $(python3 -c "print($EPOCHREALTIME - $start)")" > $d/part$p.time ) &
        if (( p % 4 == 3 )); then wait; fi
    done
done
wait
echo finished > plans.done
