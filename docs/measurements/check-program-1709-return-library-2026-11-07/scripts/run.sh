#!/bin/bash
cd ~/buster-fast-bench/1709-claude
s=scripts
$s/prof.sh main main > run-main.log 2>&1 || exit 1
$s/prof.sh head head > run-head.log 2>&1 || exit 1
$s/same.sh main head same > run-same.log 2>&1
$s/suites.sh head suites > run-suites.log 2>&1
$s/ab.sh main head ab 8 > run-ab.log 2>&1
echo done > run.done
