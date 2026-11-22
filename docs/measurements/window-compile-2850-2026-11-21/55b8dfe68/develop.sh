#!/bin/bash
set -eu
cd "$(dirname "$0")"; b=$PWD/../source-early-release/build/compiler
sha256sum "$b" >develop-binary.sha
python paired.py develop ordinary="$b" source="$b" early="$b" release="$b" --rounds 7
