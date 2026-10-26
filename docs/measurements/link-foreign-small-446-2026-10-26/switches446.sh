#!/bin/bash
# switches446.sh: where the affected case's context switches happen. After tmpfs446.sh, under one hold of the shared
# lock, for main (base) then the head (switches446.list: the threaded 2,000-worker dynamic PIE's command line, unpinned,
# without --time), perf records every context switch (-e context-switches -c 1) of 21 links, 20 ms apart, with kernel
# and user call chains (dwarf), into switches-base.data and switches-head.data; perf script then writes
# switches-base.txt and switches-head.txt.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
while pgrep -f "phases446|tmpfs446.sh" > /dev/null; do sleep 10; done
cat > switches446-run.sh <<'INNER'
#!/bin/bash
set -u
cd ~/buster-fast-bench/perf-445-446-claude
while read -r t command; do
    perf record -q -e context-switches -c 1 --call-graph dwarf,16384 -o "switches-$t.data" -- \
        bash -c "for i in \$(seq 22); do sleep 0.02; $command || exit 1; done" || exit 1
done < switches446.list
INNER
chmod +x switches446-run.sh
~/buster-fast-bench/exclusive.sh ./switches446-run.sh > switches446.out 2>&1
echo "record status $? $(date -Is)" >> switches446.log
for t in base head; do
    perf script -i "switches-$t.data" -F comm,pid,tid,time,ip,sym,dso --comm compiler > "switches-$t.txt" 2> "switches-$t.err"
done
echo "done $(date -Is)" >> switches446.log
