#!/bin/bash
cd ~/buster-fast-bench/3360-claude
./build.sh fix
grep -q "fix exit 0" build.status && ./kernels.sh && ./compile.sh
echo "all done" >> chain.log
