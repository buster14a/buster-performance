#!/bin/bash
# switches501.sh PID: after the campaign (queue501.sh, process PID), where the threaded 2,000-worker dynamic PIE's
# context switches happen, by main (m1), the head (hd) and the switch build keeping its workers' scratch arenas (kp):
# under one hold of the shared lock, perf records every context switch (-e context-switches -c 1) of 22 links each,
# 20 ms apart, with kernel and user call chains (dwarf), into switches-LABEL.data, each link's command line as
# small-threads.list has it; perf script then writes switches-LABEL.txt (analyze501s.py leaves each first link out).
set -u
D=~/buster-fast-bench/perf-501-claude
export EXCLUSIVE_OWNER=claude-501
export EXCLUSIVE_TITLE="Solve #501: link-foreign's lane team"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/501
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
while kill -0 "$1" 2> /dev/null; do sleep 10; done
for t in m1 hd kp; do
    line=$(grep "^$t-d2000-8|" small-threads.list)
    scratch=$(echo "$line" | sed 's/.*BUSTER_501_SCRATCH=\([a-z]*\).*/\1/')
    command=${line#*|}
    command=${command#*|}
    echo "$t $scratch $command"
done > switches501.list
cat > switches501-run.sh <<'INNER'
#!/bin/bash
set -u
cd ~/buster-fast-bench/perf-501-claude
while read -r t scratch command; do
    BUSTER_501_SCRATCH=$scratch perf record -q -e context-switches -c 1 --call-graph dwarf,16384 -o "switches-$t.data" -- \
        bash -c "for i in \$(seq 22); do sleep 0.02; $command || exit 1; done" || exit 1
done < switches501.list
INNER
chmod +x switches501-run.sh
~/buster-fast-bench/exclusive.sh ./switches501-run.sh > switches501.out 2>&1
echo "record status $? $(date -Is)" >> switches501.log
for t in m1 hd kp; do
    perf script -i "switches-$t.data" -F comm,pid,tid,time,ip,sym,dso --comm compiler > "switches-$t.txt" 2> "switches-$t.err"
done
python3 analyze501s.py switches-m1.txt switches-hd.txt switches-kp.txt > analysis501-switches.txt 2>&1
echo "done $(date -Is)" >> switches501.log
