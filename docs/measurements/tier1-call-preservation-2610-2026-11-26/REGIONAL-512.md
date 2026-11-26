# Frozen-interval experiment 512 — rejected

Issue #2610 remains unsolved. This checkpoint records the complete hosted,
correctness, and two-workload dynamic result of experimental bit 512. It is not
a production qualification or a hardware timing result.

## Result

| Workload | Fresh baseline | Bit 512 | Difference |
| --- | ---: | ---: | ---: |
| SQLite mix1 target instructions | 2,250,814,969 | 2,250,878,521 | +63,552 |
| Lua arithmetic target instructions | 865,590,587 | 865,590,291 | -296 |
| SQLite yy_reduce instructions | 103,295,056 | 103,265,821 | -29,235 |
| SQLite yy_reduce C + R | 3,923,938 | 3,809,328 | -114,610 |

The primary acceptance limit is 660,000 yy_reduce C/R records. The candidate
misses that limit and increases SQLite's overall instruction count, so it is
rejected. No further bit-512 dynamic Lua captures were run after these failures
were established. All five fixed-seed native Lua output oracles passed.

SQLite's C/R decreases by 3,069,821 records, but edge copies increase by
2,963,883 and ABI argument copies increase by 170,638. Branch records decrease
by 1,120 and ordinary-node records decrease by 28. Spill, rematerialization,
frame, and entry-copy category counts are unchanged. Arithmetic has 936 fewer
C/R records, 576 more edge records, and 64 more argument copies.

The largest SQLite function regressions are sqlite3VdbeMemGrow (+163,297),
sqlite3BtreeInsert (+151,386), clearSelect (+54,138), and sqlite3Select (+28,852).
These are measured function totals, not estimates. Per-function C/R, argument,
edge, and total comparisons are retained beside the full joined count TSVs.
The positive uniform-CFG score does not establish profitability on the paths
that the workload actually executes.

## Candidate and exact source identity

- Requested head: b3c0232157bcaaa1621216c8c599afe9a26eae13.
- Requested head tree: 3cfdb625a5227269ae2036c5d202db3bdcaa347e.
- Actual hosted test merge: ebcfa4950065c2b72b4a178cfee917a1cd2f50fa.
- Actual merge tree: 13708a5ba2a14cb5b28b7a9fff08368bab378b3f.
- Merge parents, in order: 74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe and
  b3c0232157bcaaa1621216c8c599afe9a26eae13.
- Hosted run: 45829398832; product artifact: 15121702942.
- ZIP: 84,815,091 bytes, SHA256
  649629599a73f8c432bba34b5ad8b889f2801ad81e4929373295dd62c4cc0bbc.
- Product tar SHA256:
  13024ac43d9b414075b3c3a6c7d15dc7d9f34f7d02850cf3b4d3cb6abce63aa7.
- Compiler SHA256:
  dbb40417ac38cec2c9e51a3ea53572001f1ec3b0522c6aa2595c49914f182ce3.

All 13 staged compiler source blobs match the actual merge tree. The product's
embedded revision, tree, run, row, compiler hash, and selected-file manifest
match the retrieved artifact. The source and product receipts are in regional-ci.
The compiler binary itself is reproducible from the pinned artifact and is not
duplicated inside this evidence archive; the generated candidate programs are.

Main advanced to 1e1ca2dd68ea36d95b714a533a9e60ba6ce53f85 with substantial
unrelated compiler changes and conflicts in the temporary measurement branch.
Draft PR #3639 was retargeted to codex/2610-measurement-base, pinned at the
previously verified main revision 74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe.
The next push generated ordinary pull-request CI. No workflow, gate, permission,
or hardware dispatch was changed. This qualifies the frozen measurement pair;
it does not qualify integration with later main. This temporary PR must be
closed without merging. The separate production draft #3630 remains unaccepted.

## Policy and focused proof

Bit 512 preserves the entire existing allocation except for a bound incoming
parameter's complete post-definition interval. It moves that interval into an
already-used callee register only when that register is free throughout the
interval. It reconstructs affected semantic edge moves and refuses added edge
memory traffic, recipes, temporary slots, critical-edge stubs, fixed roles, and
ordinary-instruction endpoint aliases. The exact lazy epoch walk is rerun for
the candidate: saved-row ownership can influence later blocks.

The score uses exact preservation, argument, and edge-copy counts weighted by
the qualified uniform CFG flow. Equal total scores prefer lower preservation
only when every external admission must reach a strict-interior call. The
measured regressions establish that this tie guard is insufficient: even a
strict positive expected saving can add traffic on frequently executed paths.

Final staged checker syntax and the combined focused build are clean. The
final policy SHA256 is
a439497828a3263438e9e4eafbfc8adc723f18828faae2b40e1ab0ec80864b00.
The combined run passes 195 transformer plus 202 native/policy checks, with
64 hostile-call executions, allocation/machine certificates, real parallel
move cycles, temporary-row counterexamples, endpoint aliases, cold ties,
transactional capacity cuts, and a real bounded-search prefix. The earlier
policy snapshot is explicitly distinguished from this final work-accounting
refinement in the proof archive.

The separate structural call-path helper passes 254 checks across 23 cases.
Its property is only that a call must be reached on every admission. It does
not certify that every path gains instructions.

The target trace models all 617 calls. It reports supported=1, bounded=0,
selected=31, published=1, considered=302, trials=302, endpoint_refusals=0,
edge_refusals=109, and work=133717101. All selected intervals belong to v6/RDI:
24 use RBX, five RBP, and two R14. The search exhausts its structural-work
budget before reaching RSI or R9. Its estimated savings are
0.008928572061 total and 0.094531258103 preservation records per invocation.
The budget is a bound on modeled structural visits, not CPU instructions.

The retained, independently checked feasibility packets are not performance
results. The 301 visible call-result sites in the earlier CFG census omit
void-call sites; the complete emitter trace has 617 calls. A separate contained
role-exchange transformer has passed 209 generic plus 288 native/policy checks,
including 128 hostile executions, but has no hosted or corpus result in this
checkpoint. Its full source and proof are frozen separately. It must not be
confused with measured bit 512.

## Hosted compiler and corpus correctness gates

Controls 0 and 256 reproduce the complete frozen SQLite and Lua executables
and origin sidecars byte for byte. This proves the pinned base and optional
512 code have not changed those control outputs.

Candidate 512 has the original SQLite coverage of 2,709 compiled functions
with no fallback, internal failure, or resource failure. Lua retains 1,086
compiled functions and the single original unsupported luaD_rawrunprotected
fallback. The six frame-fixture functions are machine certified. SQLite's
verification hash and all five fixed-seed Lua outputs match the frozen oracles.

The complete test-tier1-emit suite passes 257,194 checks with zero failures.
SQLite --verify reports 2,351 certified and 74 uncertified functions, unchanged
from the control; its full executable and sidecar equal the ordinary 512 build.
These are correctness qualifications, not evidence that the cost policy wins.

## Dynamic protocol and retained raw evidence

The unchanged driver is measure-2610.c, SHA256
61af44ef005df0d31bc4ad68ad0d00ab68965f9f68c7e51548433717304d4ab9.
The unchanged joiner gap-2610.c has SHA256
73763316ae4d87024397fb207b6a8d3ce69d93c1c3bab65c80eb217e0721e76b.
The programs come from regional-artifacts/512 and were copied into the new
/tmp/buster-2610-measurements/e512 directory with their sidecars.

The driver was run from /workspace/scratch/f0b04b7641b0:

```text
./measure-2610 run-pair /tmp/buster-2610-measurements/e512 /workspace/scratch/f0b04b7641b0/buster/build/2610-inputs/lua-evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua /workspace/scratch/f0b04b7641b0/tools-local/valgrind/usr/bin/valgrind /workspace/scratch/f0b04b7641b0/tools-local/valgrind/usr/libexec/valgrind /workspace/scratch/f0b04b7641b0/measurement-regional-2610/e512
```

The historical 9700x directory in that path identifies frozen script inputs;
it is not a hardware execution. The driver holds the exclusive suite lock
under /tmp/buster-2610-current, uses the same executable paths, SQLite database
and temporary paths, program arguments, cwd, and environment settings as the
regenerated baseline, and compresses each completed raw capture and output
before its worker exits. Both native and counted children succeeded.

Each program was disassembled with objdump -d --no-show-raw-insn. The tagged
join used GAP_EXECUTABLE=PROGRAM and:

```text
./gap-2610 count DISASSEMBLY CAPTURE '???' 0x108000 KINDS
./measure-2610 summary-file JOINED_TSV WORKLOAD
```

Both joins pass exact origin accounting and fitted-tag checks with zero
unmatched executable instructions. The outside-object counts are 15 for
SQLite and 25 for arithmetic, identical to the fresh baseline. The raw gzip
captures, native/counted stdout/stderr, compressed disassemblies, complete
joined TSVs, audit output, and per-function comparisons are retained in e512.
comparison-vs-fresh-baseline.tsv records every category and derived-count delta.

The baseline is the regenerated six-workload baseline preserved in checkpoint
4a73c26f47466385aafec8a91c32cb8a6b6b2c9b. That checkpoint's explicit historical
restart limitations still apply; these are new captures in the restored
environment, not replacements for lost earlier raw files.

## Next work and limitations

The concrete remaining problems are repeated global scoring/reconstruction
work, competition for callee registers, and profitability that depends on
actual paths. Ongoing isolated work is investigating cached exact replay,
contained role exchanges, and a path-wise cost certificate. Those changes
are not measured or accepted by this checkpoint. A later result must preserve
the same controls, full evidence, and whole-corpus regression requirements.

Benchpress/9700X has remained idle throughout this session. Neither PR is ready
for review or merge, and no hardware qualification is asserted.

---
Agent session: 6b07eef1-3474-83ed-9c43-8fe10b12d07a (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
