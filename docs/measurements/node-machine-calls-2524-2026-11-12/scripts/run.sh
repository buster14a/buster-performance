#!/bin/bash
# run.sh BASE_REV HEAD_REV: the whole record, each step's runs in holds of their own: both compilers built, the corpora
# compared by each (the machine-taken share before and after), each timed, and -c A/B.
set -u
cd "$(dirname "$0")"
./build.sh main "$1"
./build.sh calls "$2"
./corpora.sh main
./corpora.sh calls
./time.sh main
./time.sh calls
./ab.sh main calls
date -u +%FT%TZ > results/.all-done
