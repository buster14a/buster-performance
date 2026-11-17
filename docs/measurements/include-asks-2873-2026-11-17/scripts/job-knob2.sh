#!/bin/bash
# job-knob2.sh: after job-knob.sh. Builds against builds, to tell a build's placement from its asks: main's build
# (base2) against the knob build with its asks at the third miss and with them never made, and the commit's build (fin)
# against the knob build, both asking at the third miss: two builds of the same asks. musl's units, a process each,
# 11 rounds; the environment's size the same on both sides.
cd "$(dirname "$0")"
until [ -s job-knob.done ]; do sleep 10; done
: > job-knob2.done
log=knob2.log
: > "$log"
for spec in base2:knob:3 base2:knob:0 fin:knob:3 base2:knob:3:again base2:knob:0:again fin:knob:3:again; do
    IFS=: read -r a b asks again <<< "$spec"
    label=musl-$a-$b-$asks${again:+-$again}
    start=$(date +%s)
    A_ENV=BUSTER_ASKS=$asks B_ENV=BUSTER_ASKS=$asks ./lock.sh timeout -k 10 900 ./ab.sh "results/abk-$label" musl 11 "$a=$PWD/$a/build/compiler" "$b=$PWD/$b/build/compiler" > "results/abk-$label.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s $label" >> "$log"
    tools/abstat "results/abk-$label" "$a" "$b" > "results/abstatk-$label.txt" 2>&1
done
echo done >> "$log"
echo finished > job-knob2.done
