# Native 9700X qualification of issue 647

Frozen source b1975e3135b72705ef2b12c9804c2df4ce7c4149, based on pure main
4165454ebadf9b96c2b40ab99c55f4c0b28ba975. No PR, push or issue comment was
made by this agent. Source and output remain private/local to this campaign.

Every target staging/build/test/benchmark acquired the shared exclusive.sh
lock independently, with EXCLUSIVE_OWNER, EXCLUSIVE_TITLE and EXCLUSIVE_LINK.
The logs retain actual start/end UTC timestamps after acquisition. No host
settings were changed. The native image is from Clang 23.1.1, debug info off,
normal O3/march=native flags, 41 units built on cores0–7 in 28.7 s.

Candidate image SHA-256:
64125716e03a8e6a3aa2d35b87cb2bb02bddbfc4c0a120534e53bb40fde65998
Pure-main416 baseline image, independently verified again under the lock:
46bec1e120ca54b1ae99502136988cea0890e96f4af8eb704cdcd2b6cef748ed

The build's source identity, full CPU topology, kernel and compiler version
are in target-build.log. Target path is
~/buster-fast-bench/unclaimed-perf-20261028/issue-647-b1975e31/build/compiler.

## Acceptance

All eight target invocations complete successfully (the malformed CLI case
intentionally returns1, which its wrapper requires):

- test-streaming --units8 on cores0–7: 188 checks, zero failures.
- Candidate on CPU2, requested8 lanes: selected1, only the three serial rows
  validate and report; both parallel rows explicitly print not run.
- Candidate on CPUs2,3 with requested8 and writer2,3: selected2; all five
  variants validate and report.
- Candidate on cores0–7 with requested8 and writer2,3: selected8; all five
  variants validate and report.
- Candidate on CPUs2,3 with writer0,1: writer is unavailable and omitted;
  direct parallel row still validates/reports on the inherited two CPUs.
- Candidate rejects trailing text in --cpus2,3junk with status1.
- Exact new workflow shell from YAML runs successfully on the target. It
  intersects online CPUs with inherited affinity, selects physical cores
  0,1,2,3,4,5,6,7 from allowed0–9,11–15, passes eight lanes and writer0,1,
  and all five variants validate and report.
- Pure main416 negative configuration control on CPU2 reproduces the issue:
  its nominal eight-lane row reports71.700ms after the last function,
  versus0.558ms for its one-lane row. The candidate omits that unavailable
  row; properly placed candidate rows report0.532ms on two CPUs and0.567ms
  on eight. These compare configurations, not compiler revisions' speed.

Performance screens use100 generated units,32 functions each, seed88 and
five rotating passes, with the benchmark's existing output-runtime and exact
schedule-byte preflight oracles. The unavailable/invalid CLI control uses
three units/four functions/one pass. The final workflow command also uses
100 units/five passes. No sample from a skipped row is computed or reported.

All raw output is retained in target-*.log; target-summary.tsv is a mechanical
extraction of each reported row, with explicit skipped-row status. These are
configuration/behavior checks, not a fresh whole-compiler throughput claim
or a statistical baseline/candidate speedup. Full #678 runtime qualification
remains with the parent's separate compatibility campaign; the #647 full
source patch applies cleanly to that private tree without modifying it.

Runs completed between12:57:26 and13:02:58UTC, after all previously reported
unlocked packaging windows. Staging/build and every test/benchmark held the
lock; no target compression or packaging was performed by this agent.
