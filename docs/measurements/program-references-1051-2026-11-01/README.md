# #1051: descending bitset reference pass — negative result (2026-11-01)

`buster14a/buster#1051` proposed replacing the per-body depth-first reference
walk in `c_check_program.c` with one descending pass over a bitset, exploiting
the graph's postorder (operands are always below their node). Three
implementations were built and measured; none reached the walk's time, so the
branch was discarded and the issue closed as not planned.

## Setup

- Base: `bad0b433` (worktree build, `BUSTER_DEBUG_INFO=0`).
- Head: `bad0b433` + the descending pass (kind table per op; `reached` bitset
  over the body's node span; set bits consumed via `63-clzll` from the top;
  marks below the register word spilled to memory; epoch written with 4x
  `_mm512_mask_storeu_epi32` per visited word; span memset per body; inline
  VALUE leaf handling; RULES nodes reuse the walk's expansion with pushes
  drained into the marks; fallback to the walk with epoch bit 30 on any
  inversion — 0 fallbacks in sqlite's 2,674 bodies).
- Host: Zen 4 7940HS (local correctness/proxy machine; not the 9700X), pinned
  to CPU 4 with `taskset`, 11 runs per role, `--time-stages` medians of the
  `check-program` stage on `-c sqlite3.c` with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE`.
- Correctness held throughout: test-checker 718,807 checks / 0 failures;
  identical objects between vector and scalar paths on sqlite3.c, all Lua
  5.4.8 sources and a compound-literal/statement-expression fixture (the
  scalar path runs the walk, so the two cross-check).

## Stage medians (`check-program`, ms)

| build | median | min | max |
| --- | --- | --- | --- |
| base (session A) | 16.658 | 16.394 | 17.466 |
| base (session B) | 16.858 | 16.471 | 17.615 |
| v1: per-word store-back + separate AVX-512 leaf pass | 17.89 | — | — |
| v2: set-bits-only loop, masked epoch stores | 18.134 | 17.283 | 18.888 |
| v3: hoisted mark helper, no operand array | 17.441 | 16.981 | 18.679 |

Raw runs for session B: `stage-base.txt`, `stage-head.txt` (v3).

## Where the time goes (rdtsc instrumentation, relative tick counts per sqlite compile)

- Walk ≈ 21.6M ticks: 17.1M inside the 301,733 expansion calls (≈57/node:
  operand column loads, overload binary searches, region roots, VALUE leaf
  tests) plus ≈12M of stack/epoch loop around them (partially overlapped).
- Descending pass ≈ 21.4M ticks: 2.3M in the shared roots scan, 4.0M in the
  17,941 RULES expansions (≈221/call), ≈17M in the bit loop (≈31 ticks per
  cleared position even with no operand array — the loads and per-node
  dispatch remain).

The 9700X profile that motivated the issue attributed ≈38 cycles/node
(≈1.8% of the sqlite compile) to the walk. The experiment shows those cycles
are dominated by per-node semantic work and its loads, which any traversal
order pays; the DFS's push/pop and epoch stores are a minor part, so a
traversal-mechanics swap has a ceiling well under 1.8% and measured slower.

## Directions that could still pay

- Produce reference lists during graph construction (nodes arrive in
  postorder there already); that is #1050's area.
- Shrink what each visited node touches (overload search, region-root paths
  inside expansions), not how nodes are visited.
