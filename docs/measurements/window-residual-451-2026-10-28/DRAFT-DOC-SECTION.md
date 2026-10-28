### Completion and residual costs (#451, 2026-10-28)

The three original criteria are covered by #462's whole-process/release
record and #486's directive attribution and bounded long-line cut above.
The current-main record (immutable evidence link pending publication)
confirms their contracts at `e7f89091648f68940b595aadd648841c1ffc3ec5`
without a new preparation algorithm. It uses one debug-enabled native
executable built with official Clang 23.1.4. Its default 128 KiB windows
and forced whole-file mode are configurations of the same executable;
these values are not source deltas from the older release builds.

Each of the four original workloads ran one windows/windows control,
one windows/whole cohort and its reverse, with 21 timed processes per
role and two warmups: 504 timed children, all exit zero, with zero major
faults and complete user-cycle/instruction counts. Every invocation
used a separate shared-lock grant on CPU 2. Raw process medians, ms:

| Workload | Windows/whole cohort | Reverse whole/windows cohort | Peak RSS difference, windows minus whole |
| --- | ---: | ---: | ---: |
| SQLite `-E` | 18.343 / 18.557 | 18.431 / 18.344 | +2160 KiB in both |
| SQLite syntax, one lane | 99.581 / 100.037 | 99.906 / 99.621 | +2020 / +2048 KiB |
| Main `-E` | 95.409 / 95.438 | 95.398 / 95.343 | -44 / -36 KiB |
| Main parse/syntax | 97.001 / 96.725 | 97.015 / 97.099 | +1900 / +2096 KiB |

Paired ratios and their within-cohort bootstrap ranges are in the record;
they differ from ratios of independent medians. SQLite favors windows in
both orders, with varying magnitude. Main `-E` is within the controls and
reverse-order spread; parsing shows a small window cost whose reverse
interval includes zero. There is no new general throughput claim.

Two alternating process pairs per input, each with the benchmark's existing
21 passes, retain every preparation phase, printing and release. Whole to
windows preprocessing totals, ms, are SQLite 10.7605 to 10.0825, main
55.2565 to 55.2505, long-lines 5.0890 to 4.9625 and spliced 4.6815 to 4.7655.
The synthetic spliced cost remains a negative control. Main's process ranges
overlap. Release is measured separately: SQLite 0.4615 to 0.4110 ms and main
1.7330 to 1.7240 ms; this reusable-call cleanup is not process exit or an
assurance that every retained scratch mapping is unmapped. The whole-process
measurements include exit.

An original diagnostic helper counts existing lexer/page ranges without
changing the cut or line algorithms. Scalar, whole and window records and
every token's physical line query match, including 64/4096-byte stress
windows, under local sanitizers and on the native host. At default windows,
main's 18 windowed files cover 8,173,523 bytes and request 8,188,156 lexer
bytes, or 14,633 bytes replayed (0.179%). Their covered sum independently
matches the dependency-file inventory. The current encoder replays 7,764
bytes; the exact historical long-lines and spliced inputs reproduce #486's
245,073 and 76,034 replayed bytes. These are logical requested ranges,
not memory-traffic counters.

Short line replay remains deliberate. Current main spends about 0.049 ms
more lexing windows than whole but has neutral total preparation in these
two pairs. The sparse generated spliced case still costs about 0.174 ms
in lexing, partly offset by refinement. The later page-line fusion at
`68e113ee` was rejected: neutral preparation/whole-process results within
controls and +2188 KiB RSS; its alias refinement emitted identical assembly
and was reverted. This record does not integrate or retune it. The scratch
words and line pages keep the lifetime/query purpose described above, and
their roughly 2 MiB measured peak tradeoff remains explicit. No qualified
replacement mechanism has been demonstrated by this completion record.

Native PP/Clang/window/line checks, refinement on 520 files, and one/two-lane
file/resource checks pass. All complete `-E` outputs match across both modes
and the helper. The record retains two configuration-negative families:
the older SQL header pack lacks main's `linux/audit.h`, and the separately
stored shared executable cannot find its own headers by the fixture's
`tree/build/compiler` path assumption. A regular byte-identical copy in the
expected private layout passes; no timed argument or shared source changed.
