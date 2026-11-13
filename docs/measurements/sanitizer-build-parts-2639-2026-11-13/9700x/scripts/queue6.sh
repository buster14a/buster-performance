#!/bin/bash
# After queue5: the checker unit traced alone under ASan and TSan, as queue2 traced it under MSan.
cd ~/buster-fast-bench/2639-claude
while pgrep -x queue5.sh > /dev/null; do sleep 10; done
./trace-unit.sh trace-address-checker address main_unit_checker.c
./trace-unit.sh trace-thread-checker thread main_unit_checker.c
