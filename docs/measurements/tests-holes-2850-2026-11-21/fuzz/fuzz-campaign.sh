#!/bin/bash
# fuzz-campaign.sh COMPILER OUT [COUNT]: the generator's six runs of the side facts' record (seeds 61 to 66), COUNT
# programs each (15000): plain; several statements with padding; the FENV_ACCESS pragma; -Wall -Wextra; a share of
# operands of the wrong kind; and that with several statements and padding. Three at a time.
compiler=$1; out=$2; count=${3:-15000}
fuzz=/home/user/keep/fuzz/fuzz.py
mkdir -p "$out"
cd /home/user/buster-values
(python3 $fuzz $compiler 61 $count $out/plain > $out/run-61.log 2>&1) &
(FUZZ_SEVERAL=1 FUZZ_PAD=1 python3 $fuzz $compiler 62 $count $out/several > $out/run-62.log 2>&1) &
(FUZZ_PRAGMA=1 python3 $fuzz $compiler 63 $count $out/fenv > $out/run-63.log 2>&1) &
wait
(python3 $fuzz $compiler 64 $count $out/wall -Wall -Wextra > $out/run-64.log 2>&1) &
(FUZZ_SLOPPY=0.12 python3 $fuzz $compiler 65 $count $out/sloppy > $out/run-65.log 2>&1) &
(FUZZ_SLOPPY=0.12 FUZZ_SEVERAL=1 FUZZ_PAD=1 python3 $fuzz $compiler 66 $count $out/sloppy-padded > $out/run-66.log 2>&1) &
wait
echo "campaign exit 0" > $out/done.txt
