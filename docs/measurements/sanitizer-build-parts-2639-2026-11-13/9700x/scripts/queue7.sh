#!/bin/bash
# After queue6: the split builds again on the branch's final join (954db1d5, the merge flags kept for wild), and
# their executables compared with the whole builds' (src) again.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue6.sh > /dev/null; do sleep 10; done
TREE=split ./build-clean.sh final-split-memory memory
TREE=split ./build-clean.sh final-split-address address
TREE=split ./build-clean.sh final-split-thread thread
./identity.sh final-identity-memory memory
./identity.sh final-identity-address address
./identity.sh final-identity-thread thread
./sections.sh final-sections
