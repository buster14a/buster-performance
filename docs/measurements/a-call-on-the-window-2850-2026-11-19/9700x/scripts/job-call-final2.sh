#!/bin/bash
# job-call-final2.sh BASE REVISION HEAD PATCH: the build BASE of the main revision REVISION, then job-call-final.sh's
# readings of HEAD (PATCH on it) against it.
cd "$(dirname "$0")"
base=$1; revision=$2; head=$3; patch=$4
./build-label.sh "$base" "$revision" || exit 1
./job-call-final.sh "$head" "$patch" "$base"
