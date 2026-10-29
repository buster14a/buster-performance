# Code generation's check of target features, Buster #775

Compiler branch: `claude/target-features-775` of buster14a/buster, for
[this claim on #775](https://github.com/buster14a/buster/issues/775#issuecomment-6491343378).

Clang's code generation refuses a call that would inline a function into one without that function's target features
(`always_inline` or `flatten` beside a `target` attribute), at `-c` only. The branch makes `-c` and the direct path
check those calls after selection, as clang does. This record keeps:

1. the cost on the 9700X: `-c` of the frozen `sqlite3.c`, a unit without a target attribute, and of stb_image at
   `-march=native`, whose `<emmintrin.h>` intrinsics have target attributes, main against three heads: the first
   (`first/`), the one after this record's attribution (`second/`), and the final one (`last/`);
2. the reported attribution of the first head's extra instructions, by local counts on a 7940HS (`attribution/`;
   raw local session receipts are absent, as distinguished below);
3. historical filtered diagnostic comparisons with clang 23 on 18 small units (`calibration/`; compiler statuses
   and full output were not retained, so these are not acceptance or crash-freedom receipts);
4. the mutation check of the check's tests (`mutants/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **base:** `6a713e5b61691751a18b1224dcd1f6ffbeb6e3aa`, main, the branch's merge-base;
- **head:** `effd18f6425bcad76de5add7460358c248aa1ca1`, the check (`f4f1e8cd`) with main merged in;
- **final:** `1a0360260d0a39439e3511d1245321024c7cf3c9`, head with one pass over a declaration's attributes, the new
  helpers kept out of line, the walk's filter's shortcuts and the host's features reused;
- **last:** `5cf49b030ae9850b6f57c63cd1119a0b558ff455`, final with the errors in clang's emission order (a for loop's
  increment after its body).

The source pull request's head when this record was made, `b0d76846f235db5123d2baace55b7de200ebbc1a`, is last with a fix to `test-checker-driver`'s
every-error check, which the mutation check found (below): test code alone, which `-c` doesn't run.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path), and
`compare.txt` the comparison with the trees on the 9700X: the same files and bytes, but for `build/`, `COMMIT` and
`build.log`. stb_image is the same unit and header as
[buster#759's record's survey's](../sse-builtins-148-2026-10-28/survey/): `stb/stb_image.c` (SHA-256 `40bcca3e…`)
includes `stb_image.h` (`594c2fe3…`, stb_image 2.30) with `STB_IMAGE_IMPLEMENTATION`.

## Method

`scripts/queue.sh`, `queue-final.sh` and `queue-last.sh` built each tree (`scripts/build-tree.sh`,
`BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds) and ran `scripts/measure.sh`, each in a hold of the host's
lock of its own. `measure.sh` takes two trees and, in one hold, logs the receipts (the date, `uname -a`, the CPU, CPU 2's
governor, clang's and perf's versions, the lock's owner line, the trees' commits, and the SHA-256 of both executables and
of the inputs), compiles each unit with each tree once (its status, and the two objects compared), then runs 8 rounds
in which each tree, in an order alternated by round, compiles each unit 3 times under `perf stat -e
instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's exit status beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is each run's `analysis.txt`. The lock's waiting messages went
to separate files, which this record leaves out: they name other jobs.

## Results

Every build exits 0 (`build-*.log`, with each executable's SHA-256), every timed run exits 0, and each tree writes
the base's objects, byte for byte (`measure.log`).

Against main, the medians of the rounds' means' differences, with the per-round ratios' median and range for the times:

| `-c` of | head | instructions | cycles | task clock |
|---|---|---:|---:|---:|
| `sqlite3.c` | first, `effd18f6` | +557,735 (+0.042%) | +0.00% (−0.60% to +1.04%) | +0.01% (−0.75% to +1.08%) |
| | second, `1a036026` | −49,343 (−0.004%) | +0.22% (−0.32% to +0.50%) | +0.27% (−0.17% to +0.54%) |
| | last, `5cf49b03` | −53,324 (−0.004%) | −0.45% (−0.80% to −0.21%) | −0.34% (−0.64% to −0.01%) |
| stb_image `-march=native` | first, `effd18f6` | +416,509 (+0.22%) | −0.26% (−2.67% to +1.06%) | +0.16% (−1.97% to +1.61%) |
| | second, `1a036026` | +206,879 (+0.11%) | +0.39% (−0.55% to +0.87%) | −0.12% (−0.70% to +0.11%) |
| | last, `5cf49b03` | +202,005 (+0.11%) | −0.14% (−0.95% to +0.62%) | −0.25% (−0.92% to +1.43%) |

In the last run, main's medians are 1,314,296,513 instructions, 602.5 M cycles and 127.48 ms for `sqlite3.c`, and
187,409,859 instructions, 70.6 M cycles and 18.38 ms for stb_image (`last/analysis.txt`). A tree's instructions vary
by at most 2,679 within a round. `sqlite3.c` has no target attribute, so the check returns at once there, and the
static objects' pass reads each attributed declaration's records once where main read them twice. stb_image's
instructions are the check's work on about 800 keys of `<emmintrin.h>`'s intrinsics' declarations, which a unit
compiled for its intrinsics' features calls without an error.

The instructions are the precise comparison; one executable per tree is one placement of each build's code, and
[buster#509's record](../placements-509-2026-10-26/) read heads that change no code these commands run at −0.46% to
+0.36% in time that way.

## The first head's instructions

The first head ran 557,735 more instructions than main on `sqlite3.c`, where the check returns at once, and 416,509
more on stb_image (`first/analysis.txt`). `attribution/counts.md` reports local counts of builds on a 7940HS
(Zen 4, clang 23.1.4), each tree's sources a step from the one before (`attribution/*.diff`). These are manual
reported attribution data, without raw local perf/session or executable receipts, unlike the primary 9700X data.
Their table is preserved and the inconsistent prose baseline range is corrected by showing each row's implied
denominator. The session count, repeatability and measured extrema cannot be independently recovered from it.
The original account associates the following changes with the reported local counts; it does not uniquely isolate
placement from work:

- a third pass over each attributed declaration's records, beside #772's target pass and the naked one, was 214,000
  of `sqlite3.c`'s; one pass now gives all three;
- the rest went with how clang compiled the passes the change touched: a build with the check's calls compiled out
  ran 451,149 more instructions than main, more than the build with them. Keeping the two new cold helpers out of line
  (`noinline`) took `sqlite3.c` to 69,932 fewer instructions than main (`attribution/sizes.txt` lists the functions
  whose sizes changed);
- on stb_image, the check itself reads about 800 keys of the intrinsics' declarations, sorts them and runs its filter
  over the bodies' references; skipping the search for callers without a key, keeping each callee's answer for the
  callers without an attribute of their own, and reusing the host's features #772's pass read took it from +407,557 to
  +220,192.

Per-symbol samples (`scripts/sample-symbols.sh`, `perf record -e instructions:u -c N`) reportedly moved by millions of
instructions between functions whose code didn't change when N went from 10,007 to 9,973, so they attribute nothing at
this size; the local build-count table is the retained attribution account.

## Calibration

The original script, preserved byte for byte as `calibration/compare-legacy.sh`, compiled each of 18 small units at
`-march=x86-64` by this compiler (both paths) and clang 23.1.4, then compared only filtered `: error:` lines
(`calibration/results.txt`, from `5cf49b03`'s build). Sixteen retained filtered texts are the same. That script did
not retain the compiler exit statuses or full output and did not check their acceptance classes. In particular, the
five apparent no-error matches (c2/c3/c6/c7/c8) do not establish successful compilation, and empty filtered text
cannot exclude a silent failure or signal. No actual compiler failure is alleged; no missing status is reconstructed.
`c16.c` to `c19.c` are loops, a conditional and a statement expression, whose errors' order `1a036026` had wrong for
a for loop's increment (`calibration/results-1a036026.txt`: `c16.c` and `c19.c`), which clang emits after the body.
Two differ, as expected:

- `c12.c` (`target("arch=haswell")`): both name a feature the caller lacks; clang's is `movbe`, the first of its
  `StringMap`, and this compiler's `avx`, the first of `predefines_features`. The branch documents the difference;
- `c4.c` (`always_inline` with `target("default")`): clang's semantic analysis refuses the attributes together, at
  `-fsyntax-only` too, which this compiler's checker doesn't; that is
  [buster#839](https://github.com/buster14a/buster/issues/839), outside the code-generation check.

For future capture only, the corrected `calibration/compare.sh COMPILER NEW_RECEIPT_DIRECTORY` requires a new,
nonexistent receipt directory and the complete 18-source set. It retains each exact command, full combined output,
exit status, filtered errors and acceptance check, with hashes of the compilers, script, sources and reference errors.
Expected-success commands must exit 0 without error lines; expected rejections must exit 1 with an error. Signals,
setup failures and silent failures are invalid regardless of text equality. Both Buster paths must match each other.
The two known differences must match the exact historical filtered diagnostic references in `calibration/expected/`,
which are expectations copied from `results.txt`, not new receipts. Any other process/class/text mismatch makes the
script exit nonzero. This corrected harness has not been executed here; it does not retrospectively validate the
unchanged historical results or request another campaign.

## Mutation check

`scripts/mutants.sh` builds 17 mutants on a 7940HS, each a copy of `b0d76846`'s tracked files with one change
(`mutants/*.diff`), and runs `test-checker-driver --executable` on each (`mutants/results.txt` has the host's receipts
and each result). 16 fail it:

- the check skipped (`no-check`), its callee's attributes read past the call (`callee-limit`), a call through the
  address taken as direct (`indirect-direct`), `flatten` callers not checked (`no-flatten`), the caller's attribute's
  branch dropped (`no-caller-branch`), the callee's attribute's own features not first (`table-order`), and the
  always_inline attribute left out of the keys (`inline-bit-dropped`);
- which functions' errors are reported: every function taken as externally visible, the deferred ones too
  (`source-order`), every external function's (`no-stop`), the deferred pass after an external function's errors
  (`deferred-after-errors`), and the deferred pass stopped at its first function with errors (`stop-deferred`);
- where and in which order: the errors placed at their calls (`publication-at-call`), the statements' order dropped
  (`statement-order-dropped`), and a statement expression's controls ordered as their own statements
  (`region-statement-own`);
- the filter's shortcuts: a kept answer that never fails (`answer-kept-false`), and callers never keyed
  (`caller-never-keyed`).

`node-order` passes: it orders a body's calls by node rather than by end before the statements' pass
(`scripts/mutant-node-order.sh`, with the sort's `varying` from the same keys). Within a statement the graph is in
postorder, which is the calls' order of ends, so the two are the same order. Its extra c16/c19 comparisons retained
matching filtered diagnostic text only: `scripts/mutant-node-order.sh` has the same status-blind filtering pattern,
so that textual comparison does not independently establish those compilations' statuses. The retained
`test-checker-driver` exit 0 and the static equivalence argument remain separately scoped evidence.

The check found a gap in the test before this run: `test-checker-driver`'s every-error comparison joined each side's
lines into 1,024 bytes and dropped the rest unread, so `region-statement-own`, whose errors differ from clang's in the
loops fixture's last two lines, passed. `b0d76846` reads every line, and fails the check on a line it can't hold.
