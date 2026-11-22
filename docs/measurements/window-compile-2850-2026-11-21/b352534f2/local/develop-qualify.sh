#!/bin/bash
set -eu
cd "$(dirname "$0")"; d=$PWD; b=$d/../native-source-costs/build/compiler
"$b" --version >binary-version.txt 2>&1 || :
sha256sum "$b" >binary.sha
python paired.py develop ordinary="$b" native0="$b" native1="$b" native2="$b" native3="$b" profile0="$b" profile3="$b" --rounds 5
python report.py develop >develop-phases.tsv
