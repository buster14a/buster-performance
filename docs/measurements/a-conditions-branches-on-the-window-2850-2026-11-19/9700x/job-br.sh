#!/bin/bash
# job-br.sh: the branches piece on the 9700X, two jobs in turn, each run its own hold of the lock:
#   1. the piece's build (br1: contexts-br1.patch on the revision upd4 was built on) against the build before (upd4),
#      as job-call-final.sh runs them;
#   2. one executable with the experiment's switch (br1x: contexts-br1x.patch), the branches' block on and off, as
#      job-upd-knob.sh runs it.
cd "$(dirname "$0")"
./job-call-final.sh br1 contexts-br1.patch upd4 || echo "job 1 FAILED"
./job-upd-knob.sh br1x contexts-br1x.patch upd4 || echo "job 2 FAILED"
echo both jobs finished
