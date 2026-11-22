#!/bin/bash
set -eu
cd "$(dirname "$0")"
while [[ ! -f results/objectrelas/.built ]]; do
  if grep -Eq '^build failed|^patch failed' objectrelas.log;then exit 1;fi
  sleep 2
done
for group in sqlite main;do bash objectstandalone-one.sh "$group";done
echo COMPLETE
