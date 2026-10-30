# Method scope addendum — 2026-10-30

The six numeric rows (`0`, `16`, `64`, `256`, `1024`, `2048`) in the preserved
#624 record are six **ordinary checker-unit text-padding conditions**. The
retained candidate disassemblies place `check_lower_drain` at **`0x8c2030`**
in the standard build and every numeric condition. They therefore do not
demonstrate six different placements of that hot lowering function.

This note clarifies the scope of the existing record. Every historical
README, raw sample, A/A control, negative-design result, object check, harness
and disassembly is preserved unchanged. The recorded timings and correctness
results remain evidence for their recorded source, input, toolchain, machine
and layout conditions. This clarification neither globally invalidates that
evidence nor calls for repeating its campaigns.

## Immutable record and collector binding

The audited packet is
[`lowering-624-2026-10-27` at performance commit `86411090a53e05f68a16e0d8b7edaf9c2305c115`](https://github.com/buster14a/buster-performance/tree/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27).
It names compiler baseline `92c025e71856d13eb34247477c5294d2cead139e` and
qualified implementation `07df7873cde737d6bae914ff4eb81a75bf8c4f72`.

The disassemblies are bound to the selected candidate paths, rather than to
one normal binary copied into every report directory:

- [`compare-layout.sh`, lines 8–20](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/compare-layout.sh#L8-L20), selects the normal or numeric baseline/candidate paths and records their SHA-256 values.
- [Lines 35–36](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/compare-layout.sh#L35-L36) disassemble that same selected `$candidate` into the corresponding sample directory.
- [`compare.c`, lines 156–162](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/compare.c#L156-L162), copies the supplied baseline/candidate paths; [lines 167–191](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/compare.c#L167-L191) execute those copies.

In the table, each layout links its retained collector log. Each address
links the corresponding `lower-drain.s`; its header at line 2 names the
selected candidate path, and line 13 records the entry address. The hashes
below are the candidate hashes recorded by those logs, not newly recomputed
hashes of historical executables. The seven hashes are distinct.

| Recorded condition | Actual selected candidate path | Recorded candidate SHA-256 | Candidate drain entry |
| --- | --- | --- | --- |
| [standard](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-standard.log) | `/home/david/buster-fast-bench/issue624/layout/build/compiler` | `e8fa4de380819f167706ebf511474c41973dc84135184950cfa64acdc07e6b0d` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-standard/lower-drain.s#L13) |
| [0](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-0.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-0` | `ced727cdd983c904fa14463504215dbc819bb2888efe85c60814e2fbd260f000` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-0/lower-drain.s#L13) |
| [16](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-16.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-16` | `999136fead2cba89a26f259c25f8c52725dbb0f51e9eb9bf659cfb720eb133b6` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-16/lower-drain.s#L13) |
| [64](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-64.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-64` | `5531d67e0ff6603ced6991078efc5a57fb17bd144f7098ad00054c5940eeb47e` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-64/lower-drain.s#L13) |
| [256](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-256.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-256` | `f363a644f0cf7cdc18512c9c0fc0ef389390cdabbd403c01374e64d0bd3cb90e` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-256/lower-drain.s#L13) |
| [1024](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-1024.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-1024` | `1cf545edcb27b25b39c7c66124bc7f54c21b1ecb0eda23951db9da28b8870438` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-1024/lower-drain.s#L13) |
| [2048](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/compare-layout-2048.log) | `/home/david/buster-fast-bench/issue624/placements-layout/compiler-2048` | `569ba26196a45b4f8f46ec2ab12e265e4e32f8ba484501880254494f4d943a02` | [`0x8c2030`](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/samples-layout-2048/lower-drain.s#L13) |

These address receipts are **candidate-only**. The collector also records
baseline binary hashes and uses two baseline copies for A/A controls, but
its `lower-drain.s` command disassembles the candidate. This table does not
invent baseline function-address receipts, prove every hot function's
placement, or identify the placement of functions absent from the retained
disassemblies. The packet does not incorporate the executable binaries; this
is an audit of its retained source, collector and report evidence, with no
new binary execution.

## Why ordinary text padding has this scope

The exact historical baseline and qualified implementation share `build.sh`
blob **`7a63637121a7fe65999c85686e28a69414401033`**. Its
[`link_shifted`, lines 190–216](https://github.com/buster14a/buster/blob/07df7873cde737d6bae914ff4eb81a75bf8c4f72/build.sh#L190-L216),
reads the selected object's ordinary `.text` alignment and inserts a retained
external `.text.buster_shift_padding` object. The retained
[candidate build log](https://github.com/buster14a/buster-performance/blob/86411090a53e05f68a16e0d8b7edaf9c2305c115/docs/measurements/lowering-624-2026-10-27/target/build-layout.log)
reports that ordinary `.text` alignment as 16 bytes.

Both historical source revisions already put hot checker code in
`.text.buster_checker`, explicitly page-aligned with `.p2align 12`:
[baseline `main.c`, lines 325–330](https://github.com/buster14a/buster/blob/92c025e71856d13eb34247477c5294d2cead139e/src/buster/compiler/main.c#L325-L330)
and [qualified `main.c`, lines 325–330](https://github.com/buster14a/buster/blob/07df7873cde737d6bae914ff4eb81a75bf8c4f72/src/buster/compiler/main.c#L325-L330).
A retained padding symbol and distinct executable hashes establish that the
padding variants exist; they do not establish displacement of the hot
checker section. The constant candidate drain entry above is the direct
address boundary supported by the retained reports.

The earlier reviewed
[#502 placement packet at `dd92b91a3a98f57b505cc76ea13cbd74d23edffa`](https://github.com/buster14a/buster-performance/tree/dd92b91a3a98f57b505cc76ea13cbd74d23edffa/docs/measurements/checker-placement-502-2026-10-27)
already distinguishes external text padding from its separate inside-section
experiment. Its
[`link.sh`](https://github.com/buster14a/buster-performance/blob/dd92b91a3a98f57b505cc76ea13cbd74d23edffa/docs/measurements/checker-placement-502-2026-10-27/scripts/link.sh)
accepts an `INSIDE` value after the hot section's page alignment, and its
[address receipts](https://github.com/buster14a/buster-performance/blob/dd92b91a3a98f57b505cc76ea13cbd74d23edffa/docs/measurements/checker-placement-502-2026-10-27/logs/sweep/addresses3.txt)
separate those conditions. That historical distinction supplies context; it
does not add an unrecorded inside-section sweep to #624.

## Interpretation and preservation

Read the preserved README's phrase “all six checker code placements” as the
six recorded ordinary text-padding conditions, with the candidate-only
address limitation above. Keep the raw lower-stage and wall-time samples,
paired A/A controls, negative-design observations, object comparisons and
original source/workload/toolchain limits exactly as recorded. This note
makes no new speedup, corpus-wide, causal-component or acceptance claim.

At the audited immutable packet commit, the 1,326 existing paths have subtree
identity **`e86277a2afbdcd510c06f33126c2afd74957a9d3`**. The same historical
subtree is present in the fresh performance base used for this addendum,
`86f1ce63163c1f6cee5698d326e8a1d986a2be92`. This dated note is the only
addition; it changes none of those existing files or retained notices.
No new program, compiler build, test, measurement or historical campaign was
run for this editorial review.
