#!/bin/bash
# setup.sh: this directory's clone of buster (src, main fetched) and its tools, built with the host's cc.
set -u
cd "$(dirname "$0")"
[ -d src ] || git clone -q ~/buster-fast-bench/2850-facts-claude/src src || exit 1
git -C src fetch -q https://github.com/buster14a/buster main || exit 1
git -C src rev-parse FETCH_HEAD
for t in abstat collapse faultsec peakrss waitall; do cc -O2 -o tools/$t tools/$t.c || exit 1; done
[ -e w/tools ] || ln -s ../tools w/tools
ls -la tools | awk '{print $9}' | tr '\n' ' '
echo setup done
