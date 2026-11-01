#!/usr/bin/env bash
# queue11.sh: #1060's head after merging main, 512167d (3463e0f's overflow-area fix, 39ee814's #178 fix and 6e5abdc's
# tests from the review, merged with main), against that main, 7c77948: both trees exported from the fetched commits,
# their builds, the programs and #142's campaign at seeds 4900 to 4939. The PR's own 9700X job runs the suites.
cd ~/buster-fast-bench/claude-141-remaining || exit 1
git -C repo fetch -q https://github.com/buster14a/buster main claude/exciting-pascal-9qb5m7 || exit 1
for pair in base-7c77948:7c77948 head-512167d:512167d; do
    tree=${pair%%:*}
    commit=${pair##*:}
    rm -rf $tree && mkdir -p $tree && git -C repo archive $commit | tar -x -C $tree
done
./build.sh base-7c77948 head-512167d && ./programs.sh base-7c77948 head-512167d && ./campaign.sh head-512167d 512167d 4900 4939
echo queue-finished
