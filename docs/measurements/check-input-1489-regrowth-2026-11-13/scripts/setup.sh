#!/bin/bash
# setup.sh: #1489's trees and run root on the 9700X (no lock: clones only).
set -eu
W=~/buster-fast-bench/1489-claude
mkdir -p $W/root/bin $W/scratch $W/ab
cd $W
if [ ! -d main ]; then
    git clone -q --reference-if-able ~/buster-fast-bench/2658-claude/glue --dissociate https://github.com/buster14a/buster main
fi
git -C main fetch -q origin main
git -C main checkout -q --detach b7a95eedbe16fbd8434654f192f8f7aab76c56e5
git -C main rev-parse HEAD > main/COMMIT
ln -sfn ~/buster-fast-bench/1340-droid/root/corpus root/corpus
cp main/tools/microarch/workloads.sh root/workloads.sh
ln -sfn ~/buster-fast-bench/1340-droid/root/bin/compiler-pre1049-znver5 root/bin/compiler-old-aca9e53a
ln -sfn ~/buster-fast-bench/1340-droid/root/bin/compiler-main-znver5 root/bin/compiler-old-0eca996a
ls -la root root/bin
cat main/COMMIT
