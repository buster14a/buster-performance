#!/bin/bash
# first.sh LABEL REVISION PATCH: LABEL built, then its kernels' first figures and profiles on sqlite3.c
cd "$(dirname "$0")"
label=$1; revision=$2; patch=$3
./build-label.sh $label "$revision" "$patch" || exit 1
./facts.sh $label "-ops" 1 --facts-operators --passes 5 --list 20
./facts.sh $label "-opspacked" 1 --facts-operators --facts-packed --passes 5 --list 20
./facts.sh $label "" 1 --passes 5 --list 20
./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20
./profiles.sh $label ops 40 --facts-operators
./profiles.sh $label opspacked 40 --facts-operators --facts-packed
echo first-done
