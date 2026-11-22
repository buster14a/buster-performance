#!/bin/bash
set -eu
cd "$(dirname "$0")"
bash build-label.sh object1a55 0e1d5b825801135bf50e79da9d546bc95209ab30 object1a55.patch
for group in sqlite main;do bash object1a55-one.sh "$group";done
echo COMPLETE
