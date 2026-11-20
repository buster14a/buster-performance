#!/bin/bash
# gen.sh: every write-up from the runs' files: the values, the two design sections (into the tree), the pull request's
# description and the result note.
set -eu
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
G=/home/user/keep/logical/generators
P=/home/user/keep/logical/pr
X=$S/xl3
python3 /home/user/keep/logical/faults/account.py /home/user/keep/logical/faults/round1/joined.txt /home/user/keep/logical/faults/round2/joined.txt > $X/faults.json
python3 $G/values.py $X/table.txt $S/xl1/table.txt $S/xl2/table.txt > $X/values.json
python3 $G/derive.py $X/values.json $X/faults.json $S/lpf $S/lchecks/shadow /home/user/buster-values/src/buster/compiler/c_check_node_census_test.c $S/lchecks $S/lsan $S/own > $X/all.json
python3 $G/table.py $X/all.json > $X/table.md
python3 $G/table.py $X/all.json short > $X/table-short.md
python3 $G/beside.py $X/all.json > $X/beside.md
python3 $G/fill.py $G/node-machine-section.md $X/all.json table=$X/table.md beside=$X/beside.md > $X/node-machine-section.out.md
python3 $G/fill.py $G/one-core-path-section.md $X/all.json table=$X/table-short.md > $X/one-core-path-section.out.md
python3 $P/extract.py $X/node-machine-section.out.md 'main with it merged' '**Measured.**' > $X/part-builds.md
python3 $P/extract.py $X/node-machine-section.out.md '**Against its gates.**' 'Beside the gates' > $X/part-gates.md
python3 $P/extract.py $X/node-machine-section.out.md '**What stays a record at a time, and why.**' '**What it means.**' > $X/part-scalar.md
python3 $P/extract.py $X/node-machine-section.out.md '**What it means.**' '**What is next:**' > $X/part-means.md
python3 $G/fill.py $P/body-template.md $X/all.json table=$X/table-short.md beside=$X/beside.md builds=$X/part-builds.md gates=$X/part-gates.md scalar=$X/part-scalar.md means=$X/part-means.md tests=$P/tests.md > $X/pr-body.md
python3 $P/extract.py $X/one-core-path-section.out.md '### Against its gates' '### What stays a record at a time' > $X/part-short-gates.md
python3 $P/extract.py $X/one-core-path-section.out.md '### What it means' '- **Next:**' > $X/part-short-means.md
if [ -n "${PR:-}" ]; then
    python3 - $X/all.json "$PR" <<'PY'
import json, sys
v = json.load(open(sys.argv[1])); v['derived']['pr'] = int(sys.argv[2]); json.dump(v, open(sys.argv[1], 'w'), indent=1)
PY
    python3 $G/fill.py $P/result-note-template.md $X/all.json table=$X/table-short.md beside=$X/beside.md gates=$X/part-short-gates.md means=$X/part-short-means.md > $X/result-note.md
fi
python3 $G/fill.py $P/readme-template.md $X/all.json table=$X/table.md beside=$X/beside.md builds=$X/part-builds.md gates=$X/part-gates.md > $X/README.md
python3 $G/apply-docs.py /home/user/buster-values $X/node-machine-section.out.md $X/one-core-path-section.out.md
wc -c $X/README.md $X/pr-body.md $X/node-machine-section.out.md $X/one-core-path-section.out.md
