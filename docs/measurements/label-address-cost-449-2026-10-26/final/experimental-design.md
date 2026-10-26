# Existing control-walk candidate masks: experimental revision

Revision: `f7af14f10cfb38fcbc384dcb2584ed846fe33860`.
Archive: `experimental-449-control-masks.tar`.
SHA256: `afbf05f18d99176033a23261ce0cbc0e2e716a66c9c65bfc1de7b829108986a6`.
This revision remains experimental until the coordinator measures and qualifies
the exact native image. It has not been pushed.

## Why this experiment is warranted

The first candidate `c79bc86` removed four unconditional helper evaluations and
the unused addressed-label table, but saved only about 2.315 million SQLite
instructions in its first five-round paired campaign. The separate same-base
diagnostic then disabled only `check_input_label_address` and
`check_input_indirect_goto` at compile time, retaining the baseline's addressed
allocation and all other source. That ablation is invalid for GNU label-using
programs and is not production code.

The coordinator's three rotating-round comparison of 11-repeat perf means gave:

| Exact image | Median user instructions |
| --- | ---: |
| Baseline `9de3d30` | 1,718,753,972 |
| First candidate `c79bc86` | 1,716,439,871 |
| Same-base no-predicate diagnostic | 1,710,036,895 |

Thus the baseline has 8,717,077 instructions above this same-base reference, and
the first candidate still has 6,402,976 above it. Those are the causal current
comparison's values; they are not obtained by subtracting the issue's older
13.3 million between different revisions. The original five-round results stay
as history. The diagnostic observations are in the coordinator's
`work/campaign/attribution/logs/449-attribution`.

Read-only disassembly of the exact native baseline/candidate images also showed
that LLVM already makes some apparent helper calls into loaded-register or
kind-first comparisons. The rewritten first control loop combines a kind/role
test with XOR/OR instructions, trading integer work for branches. Ordinary-name
exclusion is unchanged. `STATIC449.txt` and its eight disassembly files retain
the addresses and image hashes; no Zen 5 image was executed locally.

## Change and correctness argument

The vector path now filters events inside the two existing control walks. It
does not add a token pass, allocate a list or add parser metadata. A concrete
16-byte iterator holds the next block boundary and its remaining exact mask.
The scalar option retains each original full `for token < count` traversal and
never calls this candidate filter.

The first mask includes `OPEN_BODY`, `LABEL`, `OPEN_CASE`, every `GOTO`, and
prefix `AMPAMP`. These are all branches that write state/output or call a
semantic helper in that loop. The original body remains unchanged. Its only
effect on other tokens is expiring local `body` when `token > close`; no
consumer observes that local between selected events. Expiring it before the
next selected event therefore supplies exactly the same body to every label,
goto or address consumer. `OPEN_BODY` itself is selected, so function transitions
and their `close` changes are retained.

The second mask includes every `GOTO`, prefix `AMPAMP`, and every `SEMI`. Those
are all branches with effects in that loop. The existing asm-goto exclusions,
attribute checks, table resolution, region constraints, count updates and later
computed-goto/VLA processing remain unchanged.

Both masks are unions, including overlapping synthetic kind/role values. The
consumer still evaluates the original `if`/`else if` chain, preserving branch
priority. Set bits are consumed by their lowest bit, and blocks advance in
increasing order, so diagnostics retain pass order and source order. The
existing deferred-mask early `continue` is evaluated after token selection,
before body changes, exactly as in the scalar traversal.

The parser's kind and role columns are immutable in these walks. The called
report, label lookup and region-transfer helpers only read parser columns and
write/read the checker's output or scratch state; none rewrites a prefetched
block. The normal parser/input lifetime contract keeps those columns distinct
from the scratch/output storage written here.

Each load is masked to `min(count - after, 64)` bytes, with no padding assumed.
The count-64 mask is handled separately, avoiding a shift by 64. Updating
`after` by that bounded length reaches `count` exactly without u32 wrap. A
selected bit is within its loaded block, and the iterator returns `count` as
its terminal sentinel, which the outer loop checks before its increment.

## Local validation

The local 7940HS build ran through the actual shared `cores` FIFO, under the
team's one-heavy-command permit, with two physical cores, 200% CPU quota and an
8 GiB memory maximum. All later test commands ran one at a time inside a
four-core/eight-SMT grant, with an 800% quota and the same memory maximum.
Wild's worker count was capped to the grant. No Benchpress command was launched
by this agent.

- Full production `-O3`, no-debug build: passed; executable SHA256
  `ca36f9342024f26282ef63bfe41ce6c14bdcfd2c2888ccb62d1ed2e74185ce09`.
- Focused real-kernel harness: 1,989 checks, zero failures. These cover both
  masks over all tails 0–64 at protected pages, independently listed overlapping
  kind/role cases, source order across empty spans and 64-token boundaries,
  and a final preloaded u32-limit word/sentinel.
- The harness also compares the complete filtered walks with the original full
  scalar traversal under six deferred-mask variants. It compares ownership,
  target and case columns, address/computed-goto counts, and every diagnostic in
  order. Independently stated outcomes cover same-name labels in two functions,
  an expired body, asm-goto exclusion, computed goto and attributed semicolons.
- Focused ASan+UBSan harness with halt-on-error: all 1,989 checks pass without
  findings. The harness uses the exact production kernels, not a copied mask.
- Full checker with Clang: 251,307 checks, four fpclassify oracle mismatches,
  exactly the four already independently reproduced on unchanged `9de3d30`.
  All new checks and runtime label-dispatch fixtures pass.
- Parser with Clang: passed. Tier 0 cross-check: 152,136 checks, zero failures.
  C test suite: 220/220 passed; harness self-test passed.
- Deferred-body fixtures: 703 checks, zero failures. Deferred comparison agrees
  on all 220 c-testsuite files, and on all 2,608 SQLite bodies with eight lanes.
- Full call graph/split-state gate: 42 units, 23,478 functions, zero disallowed
  cycles and zero split variables. Captures were limited to two cores.

Commands and raw output are in `control-mask-production-build.log`,
`control-mask-test.log`, `control-mask-sanitize.log`,
`control-mask-tests.list`, `control-mask-suites.log` and
`control-mask-call-graph.log`. The diagnostic's earlier syntax-only check also
completed with status 0 after its global FIFO wait; no duplicate full local
diagnostic build was made.

No performance acceptance is claimed here. The coordinator will compare the
exact committed native image with the baseline and retain the earlier candidate
and diagnostic as separate evidence.
