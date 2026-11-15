#!/bin/bash
# Local: each code part of out-new with the MSan part flags and -ftime-trace (granularity 0), 4 at once.
cd ~/.cache/claude-2639/local
for p in 0 1 2 3 4 5 6 7; do
    ( start=$EPOCHREALTIME
      clang -x ir --target=x86_64-unknown-linux-gnu -march=znver5 -gline-tables-only -mllvm -experimental-debug-variable-locations=false -fno-stack-protector -fsanitize=memory -fsanitize-memory-track-origins=2 -fno-sanitize-recover=all -fno-sanitize-trap=all -fno-omit-frame-pointer -fno-optimize-sibling-calls -fPIE -O3 -Wall -Werror -Xclang -disable-llvm-passes -Wno-unused-command-line-argument -c out-new/part$p.bc -o trace-memory/part$p.o -ftime-trace=trace-memory/part$p.json -ftime-trace-granularity=0
      echo "$? $(python3 -c "print($EPOCHREALTIME - $start)")" > trace-memory/part$p.time ) &
    if (( p % 4 == 3 )); then wait; fi
done
wait
echo finished > trace-memory/done
