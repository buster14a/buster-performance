#!/bin/bash
# Runs the lines of queue/tasks.txt in order, one at a time, removing each as it starts and logging it to
# queue/done.txt; waits for more when the file is empty, and ends at a line that says END. Each line is a shell command
# that takes the 9700X's lock itself (scripts/lock.sh ...), so every run is its own hold. The list can be edited while
# this runs, under flock queue/tasks.lock.
d=$HOME/buster-fast-bench/2040-claude
cd "$d" || exit 2
mkdir -p queue
echo $$ > queue/master.pid
while :; do
    line=$(flock queue/tasks.lock bash -c 'line=$(head -n 1 queue/tasks.txt 2> /dev/null); [ -z "$line" ] || sed -i 1d queue/tasks.txt; printf "%s" "$line"')
    if [ "$line" = END ]; then
        break
    elif [ -z "$line" ]; then
        sleep 10
    else
        echo "$(date -Is) start: $line" >> queue/done.txt
        bash -c "$line" >> queue/master.out 2>&1
        echo "$(date -Is) status $?: $line" >> queue/done.txt
    fi
done
