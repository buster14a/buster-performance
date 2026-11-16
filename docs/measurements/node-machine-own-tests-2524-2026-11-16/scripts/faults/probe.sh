#!/bin/bash
# probe.sh COMPILER PROBES: for the faults that showed on no test and no corpus, one-line programs (PROBES/pN.c), each
# run by the build with the faults' knob (knobs.py) with no fault and with its fault, the own form beside the census's
# code: a line a pair with the expressions the tests ran on and refused without the fault, and the status and the
# expressions whose bits differ (counted in both of the reader's passes) with it.
compiler=$1; probes=$2
probe() {
    fault=$1; file=$2; shift 2
    r0=$(BUSTER_NODE_TESTS_FAULT=0 $compiler measure-node-machine --shadow --front-own-tests --verify "$@" $probes/$file.c 2>&1); s0=$?
    r1=$(BUSTER_NODE_TESTS_FAULT=$fault $compiler measure-node-machine --shadow --front-own-tests --verify "$@" $probes/$file.c 2>&1); s1=$?
    d1=$(echo "$r1" | grep -o "compared-with-the-census.s-code differences=[0-9]*" | grep -o '[0-9]*$')
    e=$(echo "$r0" | grep -o 'reader-time tests expressions=[0-9]* refused=[0-9]*')
    echo "fault $fault $file $*: without: status $s0 ($e); with: status $s1, differences ${d1:-?}"
}
for spec in "1 p1" "6 p58" "6 p40" "10 p10" "11 p11" "11 p11 -Wall -Wextra" "17 p17" "22 p58" "25 p17" "28 p40" "28 p43" "34 p34" "36 p36" "38 p38" "39 p39" "40 p40" "42 p42" "43 p43" \
            "43 p43 -Wall -Wextra" "49 p49" "53 p17" "56 p11" "56 p11 -Wall -Wextra" "58 p58" "65 p65" "66 p66" "72 p72" "74 p74" "81 p81" "82 p81" "83 p81" "84 p84" "91 p91" "94 p94" \
            "97 p97" "97 p97 -Wall -Wextra"; do
    probe $spec
done
