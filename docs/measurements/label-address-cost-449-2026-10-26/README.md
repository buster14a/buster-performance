# Checker label-address cost (#449): final candidate and evidence

Five final paired rounds at exact source `f7af14f` reduce frozen SQLite user
instructions by 30,175,536 (1.7557%), wall time by 0.7698% and peak RSS by 92 KiB.
Every paired SQLite wall result improves. The other required workloads show no
consistent wall or RSS regression; label-dispatch cycles vary in sign and do
not establish an improvement. Final native receipts and identities validate.
The broader existing checker/sanitizer findings and submitted-head CI remain
separate qualification limits below.

[#449](https://github.com/buster14a/buster/issues/449) is claimed on
[`codex/449-label-address-hot-loops`](https://github.com/buster14a/buster/issues/449#issuecomment-6413010319).
The candidate removes unnecessary label-address work on ordinary C inputs while
preserving GNU labels as values and computed goto. It reuses kind/role facts,
counts resolved label addresses, omits the addressed-label table when none exist,
and uses exact SIMD event masks within the two existing control walks. The
control-event filter adds no pass or allocation, parser heuristic or dependency.
Units with addresses use a separate bounded kind/role scan to mark their label
targets, replacing the unconditional predicate in the existing program loop;
the computed-goto dispatch workload measures that tradeoff as well.

The first candidate, its measurements and reader remain in
[prototype-README.md](prototype-README.md), root [raw/](raw/) and
[summary.tsv](summary.tsv). The deliberately invalid helper ablation remains
under [attribution/](attribution/README.md). Final production-candidate data
belongs to [final/raw/](final/raw/) and [final/summary.tsv](final/summary.tsv).
The three comparisons must not be conflated.

## Exact source, build and host identities

| Artifact | Identity |
| --- | --- |
| Baseline source | `9de3d30ba437b381394095d7a77635a2e877435d` |
| Baseline Git tree | `e8bfeabd5bd58467f46a29d639e0ddc2c7d38427` |
| Baseline archive SHA256 | `77ba06bc5aafb4625317e7bc3aa3db6ea83ec8ea0a55997579bde308f4fd0817` |
| Final candidate source | `f7af14f10cfb38fcbc384dcb2584ed846fe33860` |
| Candidate source archive | `experimental-449-control-masks.tar`, transferred as `head449-final.tar` |
| Candidate archive SHA256 | `afbf05f18d99176033a23261ce0cbc0e2e716a66c9c65bfc1de7b829108986a6` |
| Native baseline executable SHA256 | `a5faaad818d33f1ea44a31be5550f9988db009d323ef09a13f7def702c782de5` |
| Native final executable SHA256 | `f20ac86eeb71787112c4e26ce290dc62223c7ac703f924d0919472b8e2c0b6f2` |
| Local final validation executable SHA256 | `ca36f9342024f26282ef63bfe41ce6c14bdcfd2c2888ccb62d1ed2e74185ce09` |

The native baseline is reused from the coordinated campaigns, not rebuilt for
each workload. The final candidate is built separately from measurements with
Clang 23.1.1, `BUSTER_DEBUG_INFO=0`, `-O3 -march=native -Isrc -fwrapv
-funsigned-char -fno-strict-aliasing -Wall -Werror`. The manual build is confined
to CPUs `0,1,3,4,5,6` and caps wild's worker count to its host budget. Compiler
flags and link order are unchanged. Source transfer checks the archive digest;
before/after provenance records both archives, both executables and the inputs.

The first native build attempt stopped before compilation because the transferred
bounded-linker wrapper lacked execute permission. The coordinator corrected its
mode inside the actual shared lock and reused the verified source archive. The
successful retry compiled all 42 sources in 34.0 seconds and printed the final
executable hash above. Both attempts are preserved separately in
[first-attempt-build.log](final/first-attempt-build.log) and
[the successful retry](final/raw/build.log).

The separate 9700X host has Linux `6.18.50-2-lts`, perf 7.2.9-1 and CPU 10
offline. The original host observation reports `amd-pstate-epp` and the
`performance` governor; final provenance repeats the online CPUs, Clang identity
and CPU 2's frequency settings. Every driver/perf measurement is pinned to CPU 2.
See the [shared host receipt](../coordination-449-450-451-2026-10-26/raw/host.txt)
and [coordination record](../coordination-449-450-451-2026-10-26/README.md).
Only the coordinator executed Benchpress work.

Separate CI guards on this branch serialize heavy test commands, cap call-graph
captures to a positive allowed-core count, and serialize/pin the pragma oracle
and full builds. They retain compiler flags, test semantics and timeouts. They
are resource controls, not a weakening of qualification or a performance result.

## Methods and reproducibility

The user authorized paired benchmark groups capped at 60 seconds. The final
queue enters the actual shared `~/buster-fast-bench/exclusive.sh` lock for each
group, with `timeout --signal=TERM --kill-after=1s 55s` around the group body.
This gives a 55-second work limit and a one-second kill grace inside the
approved ceiling. Each unit still runs in its own process. Lock owner/title/link
and completion receipts remain in the raw logs; no incompatible private lock
exists. Builds, source preparation and acceptance occupy separate holds.

The final queue requires, in order:

1. Successful source/binary/input provenance before measurement.
2. Independent runtime acceptance of the original generated label-dispatch
   program. Its `main` checks the expected sum `128 * 34122`.
3. One capped preflight group with eight independent processes: baseline and
   final candidate on SQLite, Lua `lstrlib.c`, Lua `lparser.c` and label dispatch.
4. Five capped paired-round groups, alternating the baseline/candidate order.
   Each tree runs SQLite perf, dispatch perf and the four-list process runner.
5. Successful provenance afterward, with unchanged SHA rows.

[queue449-final.sh](final/queue449-final.sh),
[group449-final.sh](final/group449-final.sh),
[build449-final.sh](final/build449-final.sh),
[provenance449-final.sh](final/provenance449-final.sh) and
[acceptance449-final.sh](final/acceptance449-final.sh) retain the exact final
orchestration; [commands449.sh](commands449.sh) retains the workload authority.
The process runner uses 21 measured runs and two warmups, rotating its four
lists within each run. Across five rounds that is 105 measured processes per
workload/tree, 840 measured processes overall and 80 warmups. Perf uses
`perf stat -x, -e instructions:u,cycles:u -r 11`: 220 counted processes overall.

Wall/RSS/fault results are medians of five per-round medians, each based on
21 process rows. Perf prints means across its 11 repetitions; its results are
medians of five round means, not individual-run medians. Paired ranges compare
the same numbered round. The reader does not infer statistical confidence from
these ranges, treat TSC ticks as core cycles, or invent unavailable samples.

| Workload | Exact shape |
| --- | --- |
| Frozen SQLite | `-fsyntax-only`, pinned predefines, `--clang-features -march=znver5 -std=gnu17 -nostdinc`, three frozen system include roots |
| Lua string library | `-c /home/david/buster-fast-bench/x87-136/lua/lstrlib.c -o /dev/null` |
| Lua parser | `-c -U__ELF__ /home/david/buster-fast-bench/x87-136/lua/lparser.c -o /dev/null` |
| Label dispatch | `-fsyntax-only label-dispatch-128.c` |

The environment fixes `SOURCE_DATE_EPOCH=1792454400` and unsets `CPATH`,
`C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH`. Frozen system-header and predefine
identities are retained in the shared record's
[frozen configuration](../coordination-449-450-451-2026-10-26/frozen-config/).
Lua is 5.4.8, verified from `lua.h`; its 61 local source/header files and the
Clang dependency closures of 94/96 paths are retained in
[Lua provenance](../coordination-449-450-451-2026-10-26/lua-provenance/).
No Lua implementation is imported by this change.

| Principal input | SHA256 |
| --- | --- |
| Frozen `sqlite3.c` | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| Pinned GNU17 predefines | `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33` |
| Lua `lstrlib.c` | `3257cd857653560773947d70b65c8b8bf8ef43f920ed449587fa662224d859e1` |
| Lua `lparser.c` | `c5507307586c1a2336a7722229f7b350ae9c548b854933b370ad150e9e6e7f84` |
| Label-dispatch unit | `b6d81b2fefd5bffa8ee5607589f959a1dbcfd520ea8ca7eba2b8555858821dc6` |

The generated unit has 81,030 bytes and 43,537 tokens. Its original generator
and generated source stay beside this record. It expands the project's runtime
dispatch fixture into 128 functions with static address tables, conditional
computed gotos, address comparisons and VLA exits. Regeneration uses
`clang -O2 -Wall -Wextra -Werror label-dispatch-gen.c -o label-dispatch-gen`, then
`./label-dispatch-gen 128 > label-dispatch-128.c`.

## Final native results

The strict final reader accepts all 48 required receipts, 68 unchanged SHA rows,
61 Lua source/header identities and nine unchanged host/configuration fields.
All 840 timed processes and 220 perf-counted processes return status zero, as do
the eight preflights. The independent native label-dispatch result matches
`128 * 34122`. No major fault occurs. On Linux the runner's raw `KB peak` field
is `ru_maxrss` in KiB; it is presented as KiB here.

| Workload | Wall base → final (ms) | Paired wall range | Peak RSS base → final (KiB) | Minor faults base → final |
| --- | ---: | ---: | ---: | ---: |
| SQLite checking | 147.964 → 146.825 (−0.7698%) | −1.2389% to −0.6361% | 598,300 → 598,208 | 1,448 → 1,447 |
| Lua `lstrlib.c`, `-c` | 10.046 → 10.041 (−0.0498%) | −0.9660% to +0.2587% | 80,924 → 80,888 | 780 → 779 |
| Lua `lparser.c`, `-c` | 8.443 → 8.347 (−1.1370%) | −2.3204% to −0.1189% | 72,376 → 72,304 | 730 → 730 |
| Label-dispatch checking | 8.613 → 8.610 (−0.0348%) | −0.3590% to +0.2802% | 81,224 → 81,204 | 686 → 686 |

| Input | Instructions base → final | Change | Cycles base → final | Paired cycle range |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1,718,752,973 → 1,688,577,437 | −30,175,536 (−1.7557%) | 681,847,644 → 675,708,301 (−0.9004%) | −1.6117% to −0.7685% |
| Label dispatch | 108,016,028 → 106,435,121 | −1,580,907 (−1.4636%) | 28,755,255 → 28,933,615 (+0.6203%) | −1.2176% to +1.0435% |

SQLite instructions are stable within a few counts across all rounds, with
lower wall time and cycles in every pair. Lua parser wall time also improves
in every pair. String-library and dispatch wall changes are effectively flat:
their median-of-round medians falls slightly, while their median paired change
is slightly positive and the paired ranges cross zero. Dispatch's cycle median
increases by 0.6203%, with both signs across pairs, so no dispatch cycle win is
claimed. Peak RSS is lower in every pair for all four workloads, by small
amounts (20–92 KiB in the aggregate). Round-median minor-fault changes are at
most two pages;
individual user/system time partitions vary and do not establish separate phase
improvements. Full metrics and paired ranges remain in [final/summary.tsv](final/summary.tsv).

## Current-base attribution and the historical 13.3 million

The older #431 comparison cited in #449 used `2cb9299` and `79cdafe` and found
approximately 13.3 million extra SQLite instructions. Today's source context is
different. Subtracting those old totals from today's totals would mix other
changes, rather than isolate the feature.

The initial `c79bc86` candidate saved about 2.315 million instructions in its
first campaign. A separate three-round, same-base causal experiment then made
only `check_input_label_address` and `check_input_indirect_goto` constant false
at `9de3d30`, retaining the original addressed-array allocation, clearing and
consumer. It ran only on the label-free inputs and never entered production.

| Image in that causal comparison | Median of three perf-round means |
| --- | ---: |
| Baseline `9de3d30` | 1,718,753,972 |
| First candidate `c79bc86` | 1,716,439,871 |
| Predicate-disabled diagnostic | 1,710,036,895 |

The same-base predicate cost was 8,717,077 instructions, and the first candidate
was still 6,402,976 above the diagnostic. This motivated filtering events in the
two existing walks. The diagnostic is invalid for labels as values, so it is an
attribution reference, never a correctness or production acceptance candidate.
Its exact patch, hashes, limits, raw observations and static-image analysis are
in [attribution/](attribution/README.md).

The final production candidate saves 30.176 million instructions against its
contemporaneous baseline and falls below that helper-disabled reference.
Filtering events also removes ordinary per-token control-walk work that
predates labels as values; the additional saving cannot all be assigned to
the two helper predicates or the historical 13.3 million. Static inspection
also shows that the native compiler had already reused some source-level
kind/role loads; the ordinary-name exclusion is unchanged and lies outside the
helper-only diagnostic. The causal current-base experiment and the complete
final A/B result therefore support the optimization without claiming an exact
reconstruction of the older #431 delta.

## Why skipping tokens preserves semantics

The first mask selects `OPEN_BODY`, `LABEL`, `OPEN_CASE`, every `GOTO` and prefix
`AMPAMP`; these contain every semantic write/call in the first walk. The only
effect on an omitted token is expiring local `body` after `close`. No consumer
observes that local between selected events, so expiring it before the next
selected event gives exactly the same body. `OPEN_BODY` itself is selected and
retains both state updates. The second mask selects every `GOTO`, prefix
`AMPAMP` and every `SEMI`, covering every effect in its walk.

The original consumer bodies, branch priorities and deferred-mask early
`continue` remain. Masks are unions, including overlapping kind/role values;
low-bit extraction and increasing blocks retain source order. The scalar option
retains the original full traversals without the filter. The called helpers
never mutate the parser's kind/role columns, so prefetching a block is safe.
Input ownership keeps those columns separate from the scratch/output writes.

Loads are masked to `min(count - after, 64)` bytes, assuming no padding. The
64-byte case avoids shifting by 64; bounded advancement reaches `count` without
u32 wrap. The iterator's terminal `count` is checked before the outer increment.
No arena/lifetime contract, asm-goto behavior, label namespace, region/VLA
constraint or diagnostic order changes. The existing addressed-label table is
still omitted only when the unit's resolved address count is zero.
The [experimental design note](final/experimental-design.md) retains the full proof.

## Validation and its limits

Local validation used the actual shared `cores` FIFO and the team's single
heavy-command permit. Builds/captures used two physical cores, 200% quota and
8 GiB memory maximum; suites used four physical cores/eight SMT CPUs and 800%,
with only one test command at a time. Wild was capped to the grant. All local
jobs completed and released their slots. No coding agent ran on the 9700X.

- Full local production build: passed. The 1,989 new focused checks pass in
  normal and ASan+UBSan builds with halt-on-error and no findings. They use the
  actual production kernels, not copied implementations.
- Guarded masks cover tails 0–64 and independently listed overlapping cases;
  iterator checks cover word boundaries, gaps and the u32 terminal boundary.
  Six complete-walk comparisons against the original scalar traversal check
  ownership, label/case targets, address/indirect-goto counts and every diagnostic
  in order, including deferred masks, function gaps, asm-goto and body expiry.
- Full checker: 251,307 checks, with four floating-classification oracle
  mismatches. The unchanged baseline independently reproduces exactly those four
  locally. All new checks and runtime label-dispatch fixtures pass.
- Parser with Clang passes. Tier 0 cross-check: 152,136 checks, zero failures.
  All 220 c-testsuite programs and the harness self-test pass.
- Deferred fixtures: 703 checks, zero failures. Deferred comparison agrees on
  all 220 c-testsuite files and all 2,608 SQLite bodies with eight lanes.
- Full call graph/split-state gate: 42 units, 23,478 functions, zero disallowed
  cycles and zero split variables; compiler captures were bounded to two cores.
- Earlier full checker ASan+UBSan runs on both baseline and first candidate
  reproduced two unchanged null/zero-length `qsort` contract violations at
  `c_lowering_symbols.c:180` and `:398`, in addition to the same four oracle
  mismatches. Those runs were not sanitizer-clean. The final focused kernel
  sanitizer result does not erase these broader existing findings.
- Frozen SQLite acceptance/diagnostics agree with Clang. Its earlier `--symbols`
  model remains unsupported for one existing type/operation; this record does
  not claim symbol qualification.

The final candidate's raw local logs and commands are in
[final/local-validation/](final/local-validation/); prototype baseline/sanitizer
comparisons remain in root [local-validation/](local-validation/). Native runtime
acceptance, image identities and final measurements all pass the strict reader.
CI status must be checked on the eventual submitted head. No tests or thresholds
are weakened, and no PR is automatically merged.

## Recompute final results

Build the final C reader from the measurement record's root:

```sh
clang -O2 -Wall -Wextra -Werror final/summary449-final.c -o summary449-final -lm
./summary449-final --self-test
./summary449-final final/raw ../coordination-449-450-451-2026-10-26/lua-provenance/source.sha256 > final/summary.tsv
```

The adapter includes the unchanged root `summary449.c` (SHA256
`e70f1d6134c36b7da60b8f2f7a6ec95847795928dd53434cd0f0b58fbd66ad2f`),
keeping its process medians, perf round means and paired arithmetic identical.
It validates all 48 required receipt files: 30 measurement logs, eight individual
preflights, six capped-group receipts, two provenance snapshots, runtime
acceptance and the successful build. The wrapper checks exact commands, the
four workload argument lists, both expected perf events, the fixed source and
executable identities, all 68 before/after SHA rows, the independent 61-file Lua
manifest and nine matching host/configuration observations. It rejects extra
measurement files and emits no partial table on failure. Undefined percentage
changes at zero baseline fault count remain `NA`.

The retained prototype's synthetic parser tests and the adapter's identity/name
checks pass. Eighteen additional temporary synthetic campaigns verify missing
and failed groups/preflights, changed hashes/configuration/manifests, incorrect
builds/commands, extra counters/files and malformed provenance. The valid
synthetic campaign reproduces the prototype's TSV byte-for-byte. These fixture
tests are reader validation, not benchmark observations; temporary data is
deleted. The same tests pass with ASan+UBSan and halt-on-error, with no findings.
The captured final data passes this reader. The issue's writer independently
recomputed its TSV and compared it byte-for-byte with the coordinator's summary.
