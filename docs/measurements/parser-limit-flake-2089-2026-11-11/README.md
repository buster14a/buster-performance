# test-parser's driver-limit check: the stack's page (buster#2089)

The record behind buster's branch `claude/parser-limit-flake-2089` (commits `e499b2c3a`, `05246107f`, on `28653e0f5`).

**Cause.** `parse_test_driver_limits` ran the driver from `parse_test_drive`'s frame, each child from
`parse_test_probe`'s, 64 bytes deeper. When the parent's lowest stack page boundary fell within those 64 bytes, the
child's `[stack]` mapping grew by a page and its `VmSize` came out 4,096 bytes above the parent's. The kernel offsets the
stack's top at random within a page in 16-byte steps, so each file whose run goes deeper than the earlier files' fails
about 1 run in 64: about 3 in 64 for test-parser.

- `patches/depth.patch`, `patches/fixdepth.patch`: the experiment builds (not committed to buster) that painted the
  stack below `parse_test_driver_limits` and found each run's deepest overwritten byte (`logs/depth-*.txt`,
  `logs/fixdepth-*.txt`, `logs/9700x-depth-0.txt`): every child ran exactly 64 bytes deeper than its parent's run, on
  the container and on the 9700X; with the fix, the warm run, the unlimited child and the deepest walk child reach the
  same depth.
- `patches/instrumented.patch`, `logs/instr-norand-*.txt`, `logs/main-norand-1408.txt`: with ASLR off (`setarch -R`)
  and the stack moved by one environment variable's size, main fails every time; only `[stack]` differs
  (`7ffffffd8000` → `7ffffffd7000`), the descriptors don't.
- `patches/leak.patch`, `logs/leak-1.txt`: a temporary build that leaked a mapping and a descriptor in the child, to
  check the kept report names both.
- `patches/final.patch`: the committed change, against `base_c_parser_test.c` (main's file).
- `logs/results-*.tsv` (offset or run, status): `before-main` (64 offsets 64 bytes apart, ASLR off: 3 failures, at
  1280, 3776 and 3904), `before-main-512`, `base-main` (random ASLR under `perf record`, 44 runs, 0 failures),
  `after-fix` (64 offsets across the page and the four 16-byte alignment classes) and `after-fix-fine` (8 at 16-byte
  steps): 0 failures in 72; `fix-random` (19) and `fix-random-perf` (8): 0 failures. perf's data files are left out.
- `scripts/`: the loops and campaigns as run, with the session's scratch paths left in.

The 9700X's runs (main fails at pad 1344 and passes at 1472; the fix passes at both; the depth log) are on benchpress
under `~/buster-fast-bench/2089-claude/logs/`; `logs/9700x-depth-0.txt` is the depth one.
