# Already-pinned affinity-check trial: not accepted

Candidate `638442081ae1b9134ed2dee1ca0fcc8b3933e4b0` was compared with exact
baseline `31c4ced26abcf0393e8c8f4f138e42dfe1952ee4`. Correctness passed, but this
trial does **not** establish #450's performance acceptance. The dispatcher skips
two affinity writes for an unchanged singleton, while retaining two reads and
restoration if a callback changes affinity or the final read fails. SQLite still
has 4.439 us of one-lane dispatch, and two repeated whole-reader comparisons
increase in every pair. Source-order controls do not waive those observations.

The candidate restores the deferred checker source byte-for-byte to the baseline;
its generic lane change and test-only guarded masks/four forked syscall cases
are described in [local-validation/README.md](local-validation/README.md).
The existing MIT/RAD Debugger notices in lane.c remain intact. No dependency or
external implementation is added.

## Identity, correctness and scheduling

| Artifact | SHA-256 |
| --- | --- |
| Baseline archive | `51c7483ad050bae15783dfa32314cc785ed8b5e06310a06006cff155230636cd` |
| Candidate archive | `98b16a865d35e9518fe4256b7babf6e67280d35f41086696365d510ff09a7902` |
| Baseline native compiler | `2a30c27d0d94cd692a8559ef47f400458021e11f02f32d8848b46254f84ce218` |
| Candidate native compiler | `fbe675d378a04cd61856dad3d161490781da2e7d8722be29da8aa3464b5ddd3a` |

The native candidate build compiled 42 translation units in 34.2 s separately
from measurements, under the actual shared lock and six-CPU/six-linker-worker
budget; see [native-preparation.log](native-preparation.log) and
[build450-check.sh](build450-check.sh). The baseline executable is reused.
Clang is 23.1.1, using the existing O3/native flags and no debug information.

Local exact-source ASan/UBSan/leak lane and deferred suites pass, including
four affinity cases and 49 fixtures/772 checks; the fresh 42-unit call graph has
no disallowed cycles or split variables. Native lane tests, the same deferred
fixtures, all 220 C programs and frozen SQLite pass. The latter has 706,237
tokens, 2,608 bodies and zero deferred differences; its existing one unsupported
symbol/type-operation result remains. See [acceptance/](acceptance/) and
[local-validation/](local-validation/).

All 226 archive, executable and input digest rows are byte-identical in the
[before](acceptance/provenance-before.log) and [after](acceptance/provenance-after.log)
receipts. Online CPUs, allowed CPUs, Clang and CPU2 frequency settings also agree:
`0-9,11-15`, `amd-pstate-epp`, `performance`, 605310–5582301 kHz.

The unchanged deferred method uses 24 passes/four complete six-order cycles,
five alternating independent process pairs for each of eleven units, plus
one alternating pair for all 219 eligible C programs. Each unit is its own
process; no new warmups or discarded passes are introduced. Full commands,
frozen SQLite/predefines/header identities and corpus revision are specified
in [the retained direct-context record](../direct-context-README.md).
`00078.c` remains included in correctness and excluded from timing for its
existing source-order fallback.

The coordinator alone used the actual `exclusive.sh`/`/var/lib/buster-9700x/lock`.
Five deferred groups and three supplemental generic-lane pairs were sequential,
with actual hold durations **37, 25, 2, 2, 4, 5, 5, 4 seconds**, all exit zero.
The approved cap is 60 s; each group has a 55 s timeout plus 1 s kill allowance.
Builds, correctness and identity captures use separate holds. CI and other
owners interleave only between holds. No private lock or unheld measurement
is used. Collection waited behind another CI job; no load was introduced to
accelerate it.

## Deferred results

There are 548 independent deferred processes, all exit zero, with 1,096 lane
rows and 460 paired/sweep summaries. The existing original C reader
[summary450.c](../summary450.c) generates [summary.tsv](summary.tsv) and
[rows.tsv](rows.tsv) from [raw/](raw/). Whole times below are medians of five
process medians, printed ns/token; the paired range is computed from the five
actual process pairs. They are not confidence intervals from 24 independent
process runs.

| Program / requested lanes | Whole baseline → candidate, ns/token | Median change | Full paired range |
| --- | --- | ---: | --- |
| SQLite / 1 | 121.20 → 121.49 | +0.2393% | −1.3384% to +0.6601% |
| SQLite / 8 | 105.94 → 106.06 | +0.1133% | −0.7591% to +0.4059% |
| 00182.c / 1 | 85.94 → 86.87 | +1.0822% | +0.7738% to +2.4448% |
| 00204.c / 8 (actual 1) | 91.84 → 92.36 | +0.5662% | +0.0868% to +0.7513% |
| 00001.c / 1, 9 tokens | 4698.78 → 4816.78 | +2.5113% | −3.1065% to +12.5565% |

The last tiny case illustrates disagreement between a ratio of medians and
the paired median (−0.5248%); both are retained. SQLite's source-order median
is 103.47 → 103.57 ns/token (+0.0966%). The all-positive repeated regressions
above are not accepted by dividing them by their source-order controls.

One-lane dispatch falls 411 → 210 ns on 00001.c and 7,013 → 4,439 ns on
SQLite, with zero wake time. The other small repeated dispatch medians fall
from 421–1,243 ns to 201–672 ns. On adaptive SQLite, eight-lane dispatch is
14,097 → 14,286 ns and wake is 20,930 → 20,779 ns. The table retains every
active/copy count and every other repeated-case result.

The single-pair sweep has 57 lane rows above +2%, one with at least 1,000
tokens: 00056.c/one lane, 86.78 → 88.52 ns/token (+2.0051%). The maximum is
00089.c/requested eight, actual one: 609.60 → 653.67 (+7.2293%, 78 tokens).
These are single process pairs and remain observations to repeat, not proof
of repeatability or samples to discard. Whole-process instruction counts
and RSS are not outputs of this checker timing harness.

## Supplemental tables and next diagnostic

All six complete `lanes-ROUND-{base,head450}.log` tables are retained in raw/.
Each runs the unchanged eight-lane generic benchmark with the same CPU order,
20,000 rounds, existing warmup and 21 passes. These six processes also exit
zero. They measure cold startup, collectives, waits, balance and arenas;
they do not isolate persistent-team dispatch. No performance acceptance or
generic speedup is claimed from this rejected candidate.

Read-only native baseline inspection finds no separate lane_run_cold symbol;
the checker instance of lane_run reserves an unconditional 0x2380-byte frame,
including its inlined cold path. The exact symbols and first instructions are
in [baseline-lane-symbols.txt](baseline-lane-symbols.txt) and
[baseline-checker-lane-entry.asm](baseline-checker-lane-entry.asm). This is
code-shape evidence, not proof of the cause of measured timings.

A new bounded diagnostic will assess the existing count-one unpinned cold
utility instead of changing generic team affinity contracts. It uses a new
baseline containing merged #449/current checker fixes. Its source, correctness
and measurements must be qualified separately; none of this trial's timings
can qualify that new code.
