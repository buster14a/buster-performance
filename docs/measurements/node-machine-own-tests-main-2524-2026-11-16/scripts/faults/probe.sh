#!/bin/bash
# probe.sh FAULT FILE [OPTIONS...]: the own form beside the census's code on FILE, without the fault and with it.
compiler=/home/user/buster-0003/build/compiler
fault=$1; file=$2; shift 2
r0=$(BUSTER_NODE_TESTS_FAULT=0 $compiler measure-node-machine --shadow --front-own-tests --verify -nostdinc "$@" $file 2>&1); s0=$?
r1=$(BUSTER_NODE_TESTS_FAULT=$fault $compiler measure-node-machine --shadow --front-own-tests --verify -nostdinc "$@" $file 2>&1); s1=$?
d1=$(echo "$r1" | grep -o "compared-with-the-census.s-code differences=[0-9]*" | grep -o '[0-9]*$')
e=$(echo "$r0" | grep -o 'reader-time tests expressions=[0-9]* refused=[0-9]*')
echo "fault $fault $(basename $file) $*: without: status $s0 ($e); with: status $s1, differences ${d1:-?}"
