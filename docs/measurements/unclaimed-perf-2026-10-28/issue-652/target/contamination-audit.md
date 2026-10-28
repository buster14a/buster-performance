# Target packaging overlap audit, 2026-10-28 UTC

Parent relayed two conservative possible unlocked target-compression
windows from the #673 owner: 11:51:35–11:51:44 and 12:08:16–12:08:24.
Exact target compression bounds were unavailable. The owner's original
account is preserved in `../../evidence-673-spawn/contamination-audit.txt`.
A later notice from the #658 owner adds extraction-derived conservative
windows 11:46:01–11:46:10 and 12:06:56–12:07:12, also without exact target
compression bounds. All four windows are screened below.
A separate parent-reported 12:27:37.850–12:27:40.604 window is later than
every measurement considered here.

No raw receipt was deleted, replaced or selectively excluded by this audit.
Every export/hash in this child's own QA used the shared target lock.
The archived per-process mtimes retain one-second precision, not nanosecond
target precision; this limitation is explicit in the bounds below.

## Accepted performance qualification

- #657: all 110 process ends are 11:49:43 UTC or 11:56:46–12:06:02 UTC.
  `../../evidence-657/target/cohort-timestamps.tsv` groups every child by
  case. Each raw cohort is shorter than one second; its full elapsed clock
  is retained in its case log. Even expanding each inferred process
  interval by two seconds to cover tar timestamp precision and collector
  close/print overhead leaves all four windows outside every interval.
- #590: all 220 process ends are 11:56:46–12:06:32 UTC, as recorded in
  `../../evidence-590/target/cohort-timestamps.tsv`. Each full cohort is
  shorter than one second. The same two-second expansion leaves all four
  windows outside every interval. The isolated head/TCC campaigns have
  retained lock-wait lower bounds at or after 12:04:16 and final mtimes no later
  than 12:06:10, so none of the four windows intersects them.
- #652 accepted isolated A/A, A/B and B/A: first lock-wait metadata is
  no earlier than 11:58:17; all final log/exit mtimes are 12:04:47–12:06:32.
  The wait occurs before the exclusive wrapper executes time-runs, so this
  brackets actual execution without inventing per-row absolute timestamps.
  None of the four compression windows intersects those campaign bounds.
- #652 original SQL A/B completes at 11:42:02, before all four windows. SQL
  reverse has a separate waiting peer's retained lock record proving grant
  at 11:53:43 and final receipt at 11:53:53. See
  `peer-lock-timestamps.txt`, copied from the #673 native build receipt.
  This interval also excludes all four windows. SQL remains a neutral control,
  not an accepted speedup.

Thus no accepted performance result depends on a potentially overlapping
campaign, and no replacement is necessary on this evidence.

## Retained contextual receipts

The mixed four-list A/A `aa.log` was opened while waiting on an 11:47:09
lock holder and ends at 11:54:06. It lacks absolute timestamps for its
first/individual rows, so its conservative known campaign bounds enclose
the 11:51:35–11:51:44 window. It is marked **possible overlap; exact overlap unknown**.
Its attractive tiny numbers were already superseded by isolated matched
A/A and reversed A/B for source-effect qualification. The deterministic
predecessor-order source finding in ORDER-METHOD.md remains valid, but this
mixed receipt must not be presented as a precisely timestamped clean
hardware-mechanism experiment. It does not underpin the accepted gains.

The base preprocessing syscall receipt's pre-lock argv/stderr time is
11:48:08 and completion is 11:55:34; its conservative bracket also encloses
11:51:35–11:51:44. No syscall duration from that run is used for performance
qualification. strace follows only the invoked compiler process tree, so
an unrelated compressor does not add mmap/madvise/munmap calls to its
counts, and output identity/exit status remain valid.

Similarly, base syntax's pre-lock receipt at 11:41:12 and completion at
11:48:08 conservatively bracket the 11:46:01–11:46:10 window. Its syscall
durations are not performance evidence; the process-tree counts, output
identity and successful exit do not require a replacement. All accepted
stage/tiny-control intervals exclude the new 12:06:56–12:07:12 window:
the final child end is 12:06:32, at least 24 seconds earlier, far beyond
the two-second precision expansion.

The initial mixed #590/TCC screen has a peer lock receipt proving grant
at 11:49:43 and ends at 11:49:44; mixed #652 small/SQL A/B screens end at
11:42:02. Neither intersects any of the four windows. They remain
contextual because of the independent predecessor-order method limitation.

All original samples and caveats remain available. Future timing harnesses
should retain absolute per-run timestamps as well as monotonic elapsed
clocks so that later overlap audits need not rely on these bounds.
