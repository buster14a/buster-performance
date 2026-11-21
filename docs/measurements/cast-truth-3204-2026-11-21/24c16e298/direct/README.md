# Exact-head cast and scratch correctness

The three source-level differential generators in driver/ compare the candidate and predecessor with Clang 23.1.4. Their argument order is baseline Buster, candidate Buster, Clang, output directory. The smaller cast-matrix.py takes Clang followed by Buster. The language-mode logs record the complete diagnostics of the checked-in driver fixture in GNU17 and C23.

Seven branch-truth mutations were rebuilt from the recorded revision. Four changed the diagnostics under the ordinary source tests. A fifth changed results when the branch walker replayed a checked CAST as CONVERT. Two variants remained indistinguishable on the tested sources. The separate 4,200-case address oracle also exercised the surviving mutations. Outputs in faults/source.tsv and faults/implicit-replay.tsv match the predecessor campaign at 90d2af699.

The far-lane check poisons all eight scratch rows at the start of the actual C window. Its two negative controls independently omit writes selected by the far consumer mask and the far left-operand mask. Each fixture reaches at least one far operand. faults/far.tsv records exit status and differences against the ordinary C pass. The control binary includes the unmodified branch and window behavior by default.

Reproduce the mutations on a scratch checkout of the recorded candidate SHA. Set BUSTER_QA_CLANG to a Clang 23.1.4 executable.

```sh
python3 faults/prepare-faults.py "$TREE" "$SHA" "$OUT/faults.json"
python3 faults/prepare-far.py "$TREE"
(cd "$TREE" && ./build.sh --config Develop)
python3 faults/check-faults.py "$TREE" "$TREE/build/compiler" "$OUT/source" --manifest "$OUT/faults.json"
BUSTER_QA_IMPLICIT_REPLAY=1 python3 faults/check-faults.py "$TREE" "$TREE/build/compiler" "$OUT/implicit" --manifest "$OUT/faults.json"
python3 faults/check-far.py "$TREE/build/compiler" faults/far
```
