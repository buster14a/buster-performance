# Tier 1's native edge moves (#140, step 4), 2026-10-31

Evidence for buster#140's step 4: Tier 1's CFG consumer (`tier1_emit_cfg.c`), the selector's phi rule, the CFG
allocator's definition requirement and back-edge hints, and the pipeline fixtures' run time by Tier 1, Tier 0 and clang.
By Claude, at David's request. The parent directory's README covers steps 1 to 3 and the hosts.

## Revisions

| Role | Commit | Branch |
| --- | --- | --- |
| base | `b9b8bbeadd1ed8aed56b49a7d2f7cee32094c427` | `claude/140-cfg-allocation` (steps 1 to 3, merged with main) |
| first head | `8b5638c2c90bcd7830d82ec1be9c5966d3d9e4af` | `claude/140-edge-moves`: step 4 |
| second head | `e2527d0d7566fa414c17a206dde4f954c5534312` | phi operands' own loop, the CFG path out of line |
| final head | `d4ee142c1aa91c6dbe9216d0d6c35af036cde672` | back-edge hints, the lone stub's layout, `benchmark-tier1-pipeline` |

`9700x/receipts.txt` has each tree's commit, the SHA-256 of its sorted file hashes (matching `git archive` of the
commit: `6088bbc2...`, `ada98cee...`, `0a14ab99...`, `72fc535d...`) and of its `build/compiler`. The base tree was built
by each run. The branch's later commits change docs only.

## Commands

On the 9700X, every step one hold of the shared lock, timed runs on CPU 2:
- `9700x/queue-b.sh BASE HEAD`: both builds (`BUSTER_DEBUG_INFO=0`), then `benchmark-tier1-select` five rounds and
  `benchmark-tier1-cfg-source` on the frozen `sqlite3.c` three rounds, the two trees in alternating order per round. Run
  for each head (`9700x/logs-b-tree-8b5638c2/`, `logs-b-tree-e2527d0d/`, `logs-b-tree-d4ee142c/`).
- `9700x/queue-run.sh HEAD`: `benchmark-tier1-pipeline` five processes (`9700x/logs-run-tree-d4ee142c/`).

Locally (deterministic outputs only): the Tier 1 test group and `test-tier1-cfg-source` on the three corpora, on the
second head (`local/tier1-tests-e2527d0d/`; corpora on the first head, `local/corpora-8b5638c2/`, which the second
doesn't reach) and on the final head (`local/tier1-tests-d4ee142c/`, `local/corpora-d4ee142c/`); the selector's manifest
cut to its last lines.

## Results

### What step 4 costs the straight-line paths

`benchmark-tier1-select`, ns per IR instruction (the CSV's `ns/IR`), medians of five processes, base against the final
head. Its synthetic shapes are straight-line, so they keep the straight-line consumer:

| Shape | Phase | Path | base | head | Change | base's range | head's range |
| --- | --- | --- | ---: | ---: | ---: | --- | --- |
| chain | selection | scalar | 26.20 | 26.37 | +0.7% | 26.17–27.69 | 26.31–26.72 |
| chain | selection | vector | 27.76 | 28.02 | +0.9% | 27.66–29.18 | 27.82–28.05 |
| chain | complete | scalar | 89.47 | 89.65 | +0.2% | 89.29–90.70 | 89.15–89.85 |
| chain | complete | vector | 78.50 | 78.55 | +0.1% | 78.35–79.86 | 78.31–79.06 |
| wide | selection | scalar | 27.93 | 28.15 | +0.8% | 27.75–28.08 | 28.02–28.22 |
| wide | selection | vector | 24.61 | 24.67 | +0.2% | 24.50–24.72 | 24.48–24.81 |
| wide | complete | scalar | 103.56 | 103.67 | +0.1% | 100.15–103.76 | 100.64–104.22 |
| wide | complete | vector | 73.66 | 73.21 | −0.6% | 70.31–73.78 | 72.46–73.89 |
| pressure | selection | scalar | 27.31 | 27.52 | +0.8% | 27.27–28.21 | 27.39–27.65 |
| pressure | selection | vector | 26.39 | 26.68 | +1.1% | 26.36–27.23 | 26.55–26.84 |
| pressure | complete | scalar | 167.22 | 167.66 | +0.3% | 166.10–168.00 | 167.22–168.44 |
| pressure | complete | vector | 128.13 | 128.78 | +0.5% | 127.64–128.79 | 128.41–129.06 |

The first head ran these 1.7% to 5.3% slower in selection and 1.3% to 5.6% in the whole pipeline: its phi tests were in
the plan's loop over every node's operands, and the CFG path's code inside `tier1_emit_function`. The second head gave
phi operands a loop of their own and kept the CFG path out of line (+0.3% to +1.5%, `logs-b-tree-e2527d0d/`).

`benchmark-tier1-cfg-source` on `sqlite3.c`, cycles per IR instruction, medians of three processes, base against the
final head: 814.87 → 809.50 (vector), 1,461.46 → 1,456.46 (scalar), 245.19 → 241.53 (the interval allocation alone,
vector), 889.30 → 886.79 (scalar). The back-edge hints move fewer values: the corpora's moves went from 187 to 130
(c-testsuite), 70,982 to 70,251 (`sqlite3.c`) and 22,004 to 21,554 (musl).

### Run time of the pipeline's fixtures

`benchmark-tier1-pipeline`, ns per call, medians of five processes (each the median of 21 passes of 64,000 calls):

| Fixture | Shape | Tier 1 | Tier 0 | clang -O0 | clang -O2 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 0 | 1.262 | 1.262 | 1.262 | 1.262 |
| 1 | 1 | 2.676 | 3.040 | 18.071 | 9.208 |
| 2 | 2 | 2.041 | 2.084 | 24.152 | 1.546 |
| 3 | 3 | 1.264 | 1.264 | 1.265 | 1.264 |
| 4 | 7 | 2.129 | 2.129 | 2.114 | 1.262 |
| 5 | 9 | 2.120 | 2.134 | 2.141 | 2.124 |
| 6 | 10 | 1.443 | 1.628 | 1.262 | 1.262 |
| 7 | 11 | 1.262 | 1.262 | 1.768 | 1.262 |
| 8 (early return) | 4 | 1.267 | 1.576 | 1.437 | 1.262 |
| 9 (loop back to the entry) | 5 | 9.620 | 11.409 | 15.916 | 9.564 |
| 10 (phi join) | 6 | 1.442 | 1.443 | 1.262 | 1.262 |
| 11 (swap loop) | 12 | 2.683 | 2.683 | 4.613 | 1.989 |
| 12 (pressure around a loop) | 13 | 5.051 | 4.439 | 30.135 | 3.723 |
| 13 (call in a loop) | 14 | 4.710 | 4.800 | 4.741 | 4.259 |
| 14 (critical edge) | 15 | 1.442 | 1.352 | 1.352 | 1.262 |
| geometric mean | | 2.176 | 2.248 | 3.552 | 2.079 |

Every compile's results equal the typed interpreter's on all 32 inputs before timing. One process each of fixture 11
ran 42% (Tier 1, 3.82) and 50% (Tier 0, 4.02) slower than the other four; the medians take all five. Before the
back-edge hints, fixture 9's Tier 1 loop moved its two values through a stub on the back edge each round (a local
sanity run measured it at twice Tier 0's time); it is `lea`, `shr`, `test` and `jne` now, as Tier 0's.

## Limitations

- The selector benchmark's shapes are synthetic straight-line functions: they measure what step 4 costs the paths it
  leaves alone, not the CFG consumer's own speed, which no corpus reaches yet (the selector doesn't take general source
  functions, #141).
- The run-time fixtures are fifteen original typed-stream kernels of a few instructions to a 64-round loop, called
  through a function pointer: a call's cost is a large part of the shortest ones'. Run time on programs needs Tier 1 end
  to end (#138).
- The local machine is Zen 4; it gives counts only.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
