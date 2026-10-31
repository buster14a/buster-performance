# #883 bounded nested integer fragments: placement and timing, 2026-10-31

This record answers the outstanding #883 acceptance gates with a repeated,
placement-controlled measurement on the approved Ryzen 7 9700X. It reports a
negative timing result: the candidate batches 641 more SQLite expression
occurrences but does not speed the compiler up.

- Baseline: `c1c5ed0267d6cfb9f5caca966f9a902090738d39` (main).
- Candidate: `7c7b9ddadc5e45d96f2403546a27f224703be0f1` (`#883` head).
  Its only source differences from baseline are the four fragment files
  (`c_check_program_batch.c`, its test, `c_check_program_fragment.c` and its
  test); the takeover also restored main's non-candidate files that the earlier
  `c644a2a5` merge had reverted.
- Compiler host: Clang 23.1.4 (pinned hash in `toolchain.txt`), Wild 0.10.0,
  `-march=znver5 -O3`, `BUSTER_DEBUG_INFO=0`, `SOURCE_DATE_EPOCH=1792454400`.
- Inputs: frozen SQLite 3.53.2 amalgamation and Lua 5.4.8 `lua.c`, hashes in
  `inputs/`.
- Placements: six links of the same objects, with 0/16/64/256/1024/2048 bytes
  inserted at the start of `.text.buster_checker` and its 4096-byte alignment
  preserved. `geometry/` records the hot addresses, sizes and internal branch
  offsets; every internal branch offset is identical across placements.
- Semantics: all 18 placement images produce byte-identical
  objects; baseline and candidate objects are also identical. `identity/`
  lists every digest and the lowering-node counts.
- Timing: 18 rounds per block, all 18 images rotated each round, paired by
  placement and round. `sqlite-lanes1` is the serial lowering metric;
  `sqlite-default` is the normal 8-lane whole process; `sqlite-lanes1-scalar`
  is the scalar control; `sqlite-lanes1-copies` repeats the serial block from
  fresh executable copies; `lua-lanes1` is the second input.

The candidate lowers slower: SQLite serial `lower` is +0.196 ms median
(95% CI +0.165 to +0.233) over 108 paired samples, and +0.220 ms from fresh
copies; the baseline A/A control is -0.042 ms. Whole-process default 8-lane
wall is +0.179 ms (CI -0.061 to +0.603), indistinguishable from the A/A
+0.205 ms. Lua's `lower` moves +0.0035 ms. No speedup is claimed, and the
candidate should not land as-is. The likely cause is the attempt-first
classification: `classified` rises from 13,885 to 17,442 (+25.6%) for 641
extra batched occurrences.

No `exclusive.sh` lock logs, other sessions' commands or private links are
included. The base2/candidate build logs were not captured by the foreground
takeover runner; `harness/commands.txt` and `toolchain.txt` record their exact
build recipe and identities. The images themselves are not copied; `images/sha256.txt` pins them.
