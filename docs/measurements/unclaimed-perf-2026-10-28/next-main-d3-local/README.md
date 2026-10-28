# Next-main local integration qualification

Final source and built-production identities are in IDENTITY.txt. The branch
starts at da22a8a1, removing all #653 directory snapshots, then cherry-picks
qualified #628 parser source 050dbfcd as 4413c2eb and #647 b1975e31 as f8e9bbdc.
Signed 06658836 corrects docs/c-checker.md's stale tree_only contract. After all
bounded checks, signed doc-only #673 commit 30658d64 is cherry-picked as d3c1d45d.
The latter changes only docs/function-lanes.md; production source and build.sh
are byte-identical to the built/tested 06658836 source. No repeat build was
needed or run for that documentation delta.

The #628 owner confirmed no newer qualified source. All three parser files
match the owner's exact416 freeze 1b98b195. The unqualified asm_ids slice was
excluded. Reader traversal and its coupled vector size derivation are untouched.

Every local build/test/compile control used a separate cores -n 2 grant, with
CPATH/C_INCLUDE_PATH unset for tests. Full build passes 41 units in 113.7 s.

| Check | Result |
| --- | --- |
| test-parser --clang | pass, including borrowed scratch and tree-only modes |
| test-preprocessor --clang --jobs 2 | pass,90 diagnostic-buffer cases, 325 printer batches, 3,000 C17/C23 fuzz cases,zero differences/unverified |
| test-streaming --units8 | 188 checks, 0 failures |
| test-checker-driver --executable ./build/compiler | 21,660 checks, 0 failures |
| same driver with --lazy-system-headers | 21,660 checks, 0 failures |
| test-check-lanes --executable ./build/compiler | 3,159 checks, 0 failures; worker budget 186 checks, 0 failures |
| test-checker-deferred | 72 fixtures, 1,147 checks, 0 failures |
| test-files --lanes 1,2 |pass |
| frozen c-testsuite subset --jobs 2 --cross-check | 220/220 passed; 0 unsupported/failed/not-run |
| call graph | 41 units, 25,415 functions, 151,337 calls, 0 cycles, 3 existing allowed, 0 split variables |

The full checker is intentionally **not reported as passing**: candidate
`test-checker --seed 20261028` reports 488,765 checks, 4 failures. Fresh pure416
control on the same Clang 23.1.4 reports 464,837 checks, the same 4 failures and
identical observed disagreement values. Both repeat
fpclassify-conditional-selector-effects twice (512434 vs512344) and
fpclassify-known-category-effects twice (1512430 vs1512340). No extra candidate
failure appears. Both complete raw outputs are retained. The preprocessor log's
"fuzz failed comparison: a case without a result" line is its intentional
negative self-test; its command exits 0 and both 1,500-case campaigns report 0
without a result and 0 differences.

Frozen c-testsuite revision: 5c7275656d751de0e68b2d340a95b5681858ed07 at
/home/david/Documents/Codex/2026-10-27/sol-11/work/c-testsuite.

SQLite controls use the exact frozen corpus under
/home/david/Documents/Codex/2026-10-27/exp/work/corpus. Source SHA-256:
0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d.
Pinned GNU17 predefines SHA-256:
a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33.
Pure416, candidate vector/one lane, scalar/one lane and vector/two lanes all
compile successfully and give byte-identical objects:
1cafbadf926eed2245cb6a81ac1ee511f42d300995c2b2144c98e495d8c394d6.
Raw objects, command outputs and identities are retained. Exact flags are in
commands.txt. These are correctness/byte-identity checks, not performance data.

Root owns native target qualification. No target action was taken for this
integration. Existing frozen b8 and compatibility branches remain outside this
checkout; no PR, push or issue comment was made. All new commits retain the
maintainer's opted-in sign-off. source-d3c1d45d.tar is a convenient immutable
source transfer artifact, not a blob intended for the performance Git history.
