#!/bin/bash
# queue-xs6.sh: the frozen code's readings (xs6.patch: seven, as the specification's gates ask, then eight more of the
# same executable under another suffix), then the final list's every fault from its start up. One after another: no
# fault round beside a timing job.
cd "$(dirname "$0")"
./job-xs.sh xs6 xs6.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 7 -a > job-xs6.log 2>&1
./job-xs.sh xs6 xs6.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 8 -b > job-xs6b.log 2>&1
./job-faults-values.sh xsf6 xs6.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 Develop round6 faults-sides-5.py $(seq 0 141) > job-xsf6.log 2>&1
echo "queue finished"
