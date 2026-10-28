#!/bin/bash
# Campaign B, shortened to three rounds: waits for chainB.sh to finish round 2 (172 runs, the end of a batch, in its
# pause between batches), stops it (its session), then runs round 3 in two lock holds (queue2.sh) and c-testsuite's
# sweep (queueCT.sh).
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/chainB2.pid"
until [ "$(grep -c '^== round' logB.txt)" -ge 172 ] && tail -1 logB.txt | grep -q '^exit='; do
    sleep 2
done
old=$(cat "$D/chainB.pid")
if [ "$(ps -o sid= -p "$old" | tr -d ' ')" = "$old" ]; then
    kill -- -"$old"
fi
echo "stopped chainB after round 2: $(date -Is)" >> "$D/builds.txt"
sleep 2
"$D/queue2.sh" jobsB.txt logB.txt 3 22 40 3
"$D/queueCT.sh"
