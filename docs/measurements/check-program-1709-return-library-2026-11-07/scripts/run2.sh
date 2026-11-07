#!/bin/bash
cd ~/buster-fast-bench/1709-claude
s=scripts
$s/prof.sh final final > run-final.log 2>&1 || exit 1
$s/same.sh main final same-final > run-same-final.log 2>&1
$s/suites.sh final suites-final > run-suites-final.log 2>&1
$s/ab.sh main final ab-final 8 > run-ab-final.log 2>&1
echo done > run2.done
