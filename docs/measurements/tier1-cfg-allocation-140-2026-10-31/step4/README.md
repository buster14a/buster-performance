# Tier 1's native edge moves (#140, step 4), 2026-10-31

Evidence for buster#140's step 4: Tier 1's CFG consumer (`tier1_emit_cfg.c`), the selector's phi rule and the CFG
allocator's definition requirement. By Claude, at David's request. The parent directory's README covers steps 1 to 3 and
the hosts.

## Revisions

| Role | Commit | Branch |
| --- | --- | --- |
| base | `b9b8bbeadd1ed8aed56b49a7d2f7cee32094c427` | `claude/140-cfg-allocation` (steps 1 to 3, merged with main) |
| head, first | `8b5638c2c90bcd7830d82ec1be9c5966d3d9e4af` | `claude/140-edge-moves`: step 4 |
| head, final | `e2527d0d7566fa414c17a206dde4f954c5534312` | `claude/140-edge-moves`: phi operands' own loop, the CFG path out of line |

`9700x/receipts.txt` has each tree's commit, the SHA-256 of its sorted file hashes (matching `git archive` of the
commit: `6088bbc2...`, `ada98cee...`, `0a14ab99...`) and of its `build/compiler`. The base tree was built by both runs.

## Commands

`9700x/queue-b.sh BASE HEAD` on the 9700X, every step one hold of the shared lock, timed runs on CPU 2: both builds
(`BUSTER_DEBUG_INFO=0`), then `benchmark-tier1-select` five rounds and `benchmark-tier1-cfg-source` on the frozen
`sqlite3.c` three rounds, the two trees in alternating order per round. Run for the first head
(`9700x/logs-b-tree-8b5638c2/`) and the final one (`9700x/logs-b-tree-e2527d0d/`).

Locally (deterministic outputs only): the Tier 1 test group on the final head (`local/tier1-tests-e2527d0d/`, the
selector's manifest cut to its last lines), and `test-tier1-cfg-source` on the three corpora on the first head
(`local/corpora-8b5638c2/`; the final head's change doesn't reach it).

## Results

`benchmark-tier1-select`, ns per IR instruction (the CSV's `ns/IR`), medians of five processes, base against the final
head. Its synthetic shapes are straight-line, so they keep the straight-line consumer:

| Shape | Phase | Path | base | head | Change | base's range | head's range |
| --- | --- | --- | ---: | ---: | ---: | --- | --- |
| chain | selection | scalar | 26.19 | 26.55 | +1.3% | 26.12–27.85 | 26.45–26.72 |
| chain | selection | vector | 27.72 | 28.10 | +1.4% | 27.62–29.15 | 27.97–28.34 |
| chain | complete | scalar | 88.74 | 89.22 | +0.5% | 88.73–90.89 | 88.77–89.65 |
| chain | complete | vector | 78.43 | 78.64 | +0.3% | 78.06–79.91 | 77.61–78.75 |
| wide | selection | scalar | 27.89 | 28.26 | +1.3% | 27.70–29.65 | 28.04–28.50 |
| wide | selection | vector | 24.57 | 24.76 | +0.8% | 24.27–26.37 | 24.67–25.21 |
| wide | complete | scalar | 100.18 | 100.97 | +0.8% | 99.81–102.01 | 100.48–101.54 |
| wide | complete | vector | 70.02 | 72.52 | +3.6% | 69.87–73.17 | 69.69–73.16 |
| pressure | selection | scalar | 27.37 | 27.69 | +1.2% | 27.19–28.69 | 27.55–27.73 |
| pressure | selection | vector | 26.39 | 26.77 | +1.5% | 26.18–27.31 | 26.70–27.11 |
| pressure | complete | scalar | 166.78 | 168.22 | +0.9% | 166.25–169.07 | 167.99–168.67 |
| pressure | complete | vector | 128.10 | 129.27 | +0.9% | 127.26–130.47 | 128.61–129.85 |

The first head ran these 1.7% to 5.3% slower in selection and 1.3% to 5.6% in the whole pipeline: its phi tests were in
the plan's loop over every node's operands, and the CFG path's code in `tier1_emit_function`. The final head gives phi
operands a loop of their own and keeps the CFG path out of line. The remaining selection cost is about 0.35 ns per IR
instruction; the wide shape's +3.6% has ranges that overlap.

`benchmark-tier1-cfg-source` on `sqlite3.c`, cycles per IR instruction, medians of three processes: 814.55 against
811.17 (vector), 1,458.87 against 1,457.68 (scalar), 244.97 against 245.13 (the interval allocation alone, vector) and
888.93 against 889.55 (scalar): unchanged within 0.4%.

The Tier 1 tests on the final head pass, `test-tier1-pipeline --cross-check` with 1,920 native results and 960 clang
results all agreeing with the typed interpreter, 28 functions through the CFG consumer, 114 edge-move records and 8
stubs.

## Limitations

- The selector benchmark's shapes are synthetic straight-line functions: they measure what step 4 costs the paths it
  leaves alone, not the CFG consumer's own speed, which no corpus reaches yet (the selector doesn't take general source
  functions, #141).
- The executed CFG fixtures are seven original typed-stream programs, not a corpus.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
