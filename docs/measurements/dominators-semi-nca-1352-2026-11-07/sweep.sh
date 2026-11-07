#!/bin/sh
# Generate #1352's inputs, then measure every point with scale.sh under its own lock hold; results in scale.tsv,
# each point's lock wait and holder lines in scale-locks.log.
cd ~/buster-fast-bench/1352-claude || exit 1
mkdir -p inputs
for N in 1000 2000 4000 8000 16000; do sh ./gen.sh inputs $N; done
: > scale.tsv
: > scale-locks.log
for shape in gotos ifs ternary; do
  for N in 1000 2000 4000 8000 16000; do
    for mode in tier1 default; do
      for build in base semi new; do
        ./run.sh scale-run.log ./scale.sh $build $shape $N $mode
        grep -a '^base\|^semi\|^new\|^FAIL' scale-run.log >> scale.tsv
        grep -av '^base\|^semi\|^new' scale-run.log >> scale-locks.log
      done
    done
  done
done
echo done >> scale.tsv
