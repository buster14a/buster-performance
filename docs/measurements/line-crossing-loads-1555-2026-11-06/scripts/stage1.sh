#!/bin/bash
cd ~/buster-fast-bench/1555-claude/run
./profile.sh main ls_misal_loads.ma64:u 997
./counters.sh 3 main
