#!/bin/bash
# queue-xs5.sh: the frozen code's readings (xs5.patch: seven, as the specification's gates ask, then eight more of the
# same executable under another suffix), then the experiment build's (xse1.patch, when it is there), then the final
# list's every fault from its start up. One after another: no fault round beside a timing job.
cd "$(dirname "$0")"
./job-xs.sh xs5 xs5.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 7 -a > job-xs5.log 2>&1
./job-xs.sh xs5 xs5.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 8 -b > job-xs5b.log 2>&1
test -f xse1.patch && ./job-xse.sh xse1 xse1.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 5 -a > job-xse1.log 2>&1
./job-faults-values.sh xsf5 xs5.patch 0dbba56f8ace9c73b5126d89f72c074f5bd5ca18 Develop round5 faults-sides-4.py $(seq 0 135) > job-xsf5.log 2>&1
echo "queue finished"
