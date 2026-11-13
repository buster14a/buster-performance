#!/bin/bash
# After queue2 (the split builds): each sanitizer's whole and split executables compared.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue2.sh > /dev/null; do sleep 10; done
./identity.sh identity-memory memory
./identity.sh identity-address address
./identity.sh identity-thread thread
