#!/bin/bash
# Builds, then the measurements; every build and measured run takes its own hold (lock.sh).
cd ~/buster-fast-bench/1549-claude
./build.sh base && ./build.sh head || { echo "build failed"; exit 1; }
./host.sh
./measure.sh && ./compile.sh && ./self.sh || { echo "measurement failed"; exit 1; }
echo done
