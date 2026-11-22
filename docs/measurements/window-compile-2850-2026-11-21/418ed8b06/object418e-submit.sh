#!/bin/bash
set -eu
cd "$(dirname "$0")"
bash build-label.sh object418e 0e1d5b825801135bf50e79da9d546bc95209ab30 object418e.patch
for group in sqlite main;do bash object418e-one.sh "$group";done
echo COMPLETE
