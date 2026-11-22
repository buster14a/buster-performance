#!/bin/bash
set -eu
cd "$(dirname "$0")"
bash build-label.sh objectrelas 0e1d5b825801135bf50e79da9d546bc95209ab30 objectrelas.patch
for group in sqlite main;do bash objectrelas-one.sh "$group";done
echo COMPLETE
