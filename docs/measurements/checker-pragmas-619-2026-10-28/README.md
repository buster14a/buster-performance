# The checker's `#pragma clang section` and `#pragma clang optimize`: what they cost checking and lowering, 2026-10-28

Branch `claude/loving-carson-j9sz52` (buster14a/buster) takes `main.c`'s two pragmas in the checker (#619):
`#pragma clang section`, its settings, errors and section type conflicts (`c_check_section_input.c`), and
`#pragma clang optimize`, which #681 put around the checker unit's tests (`c_check_optimize_input.c`). It adds
`__builtin_ia32_ucmpd128_mask` to the own-main builtin inventory, and a step in the 9700X job that runs `-fsyntax-only`
of every unit `build.sh` compiles. The walk records a section event per declarator only from the unit's first setting or
section attribute on. The frozen `sqlite3.c` has neither, so this measures what that test, and the rest of the branch's
code that a unit without them runs, cost there:

| Measure (`sqlite3.c`) | main (`241fcb3e`) | head (`77c45e33`) | change |
| --- | --- | --- | --- |
| `-fsyntax-only`, user instructions (`perf stat`) | 995,717,363 | 996,071,769 | +354,406 (+0.036%) |
| `-fsyntax-only`, user cycles | 465.964 M | 466.381 M | +0.09% |
| `-fsyntax-only`, wall (`time-runs`) | 102.137 ms | 102.100 ms | -0.04% |
| `-fsyntax-only`, peak resident set | 374,988 KB | 375,056 KB | +68 KB |
| `-c`, user instructions | 1,256,935,354 | 1,257,306,912 | +371,558 (+0.030%) |
| `-c`, user cycles | 584.183 M | 587.209 M | +0.52% |
| `-c`, wall (`time-runs`) | 124.467 ms | 124.998 ms | +0.43% |
| `-c`, peak resident set | 389,540 KB | 389,484 KB | -56 KB |

The `perf stat` rows are the medians of three rounds of `-r 11` (`perf.log`); the `time-runs` rows are the medians of
five rounds of 11 processes each, the trees in turn (`ab.log`). Both trees' `-c` wrote the same object
(`inputs.sha256`: `lower_base.o`, `lower_head.o`). main's checker refuses `main.c` at its first section pragma
(`main_c_base.log`, `342:1: error: construct is not yet supported by the type checker`), and the head checks it
(`main_c_head.log`, status 0).

The compile-wall increase is an observed cost: all five paired round medians are positive, from +0.253% to +0.481%,
and the ratio of the five-round medians is +0.426619%. The record has no same-binary A/A control or independent code
placements. It does not establish a placement-independent causal estimate or general performance neutrality.

`-c` runs 371,558 more instructions (+0.03%). The same change measured fewer cycles on the base before
main's merge: -0.44% (`572471f4`) and -0.58% (head 3) against main `4165454e` (`history/perf3.log`), and -0.44% and
-0.28% wall (`history/ab2.log`, `history/ab3.log`). The new sources sit among the checker's own, in
`.text.buster_checker`, and move every function clang emits after them within that section. #502 measured that such
a shift of the checker's code moves `sqlite3.c`'s whole compile by up to 2%. The section's page alignment keeps the
code before it from moving it, which leaves `build.sh shifts` (padding before a unit) unable to sample this
placement, so placement is a possible contributor that this record does not separate. The earlier measurements use
different source compositions and cannot cancel or normalize away the current positive compile-wall cost.

Where the instructions go (`profile.sh`, 100 runs of `-fsyntax-only` per tree at one sample per 1,000,003 user
instructions, `functions_*_drive.txt`): none of the new functions has an observed sample. At this period, one sample
nominally corresponds to about 10,000 instructions per run averaged across 100 runs; zero observed samples are not a
proof of zero execution or a hard upper bound. `check_input_declaration`, whose walk tests the guard, has 18 more
samples in 100 runs (a nominal estimate of about 180,000 instructions a run). Thousands of samples move between other
functions with no change in their sources:
`check_literal_string_unit` 725 → 140, `check_graph_run` 3,168 → 2,626, `check_input_declarator_step` 1,814 → 2,194,
`check_graph_validate_node` 179 → 5. Differences in Clang's inlining and sample attribution are possible explanations,
not a causal result established by these aggregate counts. The new sources call
existing helpers (`pp_token_is_name`, `check_input_retained_pragma`, `pp_spelling`, the arena's), which can change
those decisions; this record doesn't isolate which change moves which. The archived function-count summaries and
controller do not include the underlying perf.data, address lists or symbol tables, so independent re-decoding of
the profile and attribution is unavailable from this record. The whole-command counters and retained wall trials
remain the direct cost evidence.

On the 9700X the head passes `test-checker --seed 133` (464,879 checks), `test-checker-driver --executable
./build/compiler` (22,042, the section and optimize pragmas' fixtures among them), `test-checker-deferred` (84
fixtures, 1,489 checks), `test-check-builtins-x86` (5,621) and `test-builtin-intrinsic-catalog` (46,125), with 0
failures against clang 23.1.1 (`test_*.log`). The job's new step, `-fsyntax-only` of the 31 units with `build.sh`'s
flags, passes all 31 in 4.36 s on one CPU (`test_units.log`).

## The walk's guard

The handoff's walk called the section reader for every declarator with attributes, to look among them for a section
attribute, and in `sqlite3.c` the system headers give most declarations attributes. Each guard, against main
`4165454e` in its session (`history/`, `perf stat` medians of three rounds of `-r 11`):

| Tree | Guard | `-fsyntax-only` instructions | `-c` instructions | Log |
| --- | --- | --- | --- | --- |
| head 1 (`8379300f`) | none: every declarator | +633,376 (+0.064%) | +662,684 (+0.053%) | `perf.log` |
| head 2 (`572471f4`) | declarators with attributes, or after the first setting or attribute | +528,393 (+0.053%) | +557,916 (+0.044%) | `perf2.log` |
| head 2, again | the same | +528,606 | +558,109 | `perf3.log` |
| head 3 (`45dd5034` with `head3.diff`) | as head 2, but attributes only once the reader has read a section attribute | +413,826 (+0.042%) | +443,161 (+0.035%) | `perf3.log` |

The pull request's head has a third guard (`c205abb8`): the attribute reader lowers the walk's start to each section
attribute's token as it reads one, so that the walk tests one compare per declarator. It was measured only after main's
merge, in the table above, against another main. Head 3's guard saved 114,780 instructions of head 2's 528,606, a
fifth. Each session's main runs a few hundred instructions apart from the others' (995,723,056 to 995,723,527 for
`-fsyntax-only`): the scripts and their environments differ, so each head is read against its own session's main.
The time-runs rounds are in `history/ab.log` (head 1), `ab2.log` (head 2) and `ab3.log` (head 3). On the 9700X, head
3 passed the same suites (`history/test3_*.log`, `history/tests619.log`), and head 1 passed `test-checker`,
`test-checker-driver`, `test-checker-deferred`, `test-check-builtins-x86` and `test-builtin-intrinsic-catalog`
(`history/test-*.log`).

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`241fcb3e`](https://github.com/buster14a/buster/tree/241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7) | main when measured, the branch's merge |
| `head` | [`77c45e33`](https://github.com/buster14a/buster/tree/77c45e33427beece95816c69d7214b957467cce4) | the measured pull request head, with main `241fcb3e` merged |
| `history/base` | [`4165454e`](https://github.com/buster14a/buster/tree/4165454e) | main before, the branch's first merge |
| `history/head` | [`8379300f`](https://github.com/buster14a/buster/tree/8379300f) | the branch before the guards |
| `history/head2` | [`572471f4`](https://github.com/buster14a/buster/tree/572471f4) | the first guard |
| `history/head3` | `45dd5034` and `history/head3.diff` | the optimize pragma's fix, and the second guard, which no commit has |

`base` and `head` were `git archive` of their commits, sent by tar into empty directories. The history's trees' files
are their commits' (`history/source-*.sha256` matches `git archive` of each), and head 3's are `45dd5034`'s with
`history/head3.diff` applied. Each `source-*.sha256` holds the SHA-256 of every file, and `inputs.sha256` those of
the executables, the objects, the input and its predefines, and the host's kernel and clang. Each was built with
`BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh` (`build_*.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build, test and
run took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126-cloud`); the lock's waiting messages, which name other
sessions' and CI's runs, are removed from the logs, which leaves the logs of runs that printed nothing
(`drive_*.log`, `lower_*.log`, `main_c_head*.log`) empty.

## Method

`ab619e.sh` ran the main comparison (`ab619e.log` is its output), and `history/ab619.sh`, `ab619b.sh`, `ab619c.sh` and
`ab619d.sh` the history's (`history/tests619.sh` its suites on head 3). The inputs and options are those of
[#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor oracle's frozen `sqlite/sqlite3.c` with
the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system directories,
`SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset; with `--clang-features` for `-fsyntax-only`, without
it for `-c`:

- each tree's `-fsyntax-only` of `main.c` with `build.sh`'s flags, and its `-fsyntax-only` and `-c` of `sqlite3.c`
  once, whose objects compare equal;
- the head's suites on CPUs 0 to 7, as the job runs them, with the oracle cache off, and the job's new step on CPU 2;
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole `-fsyntax-only` and of `-c -o /dev/null`;
- `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of `time-runs --runs 11
  --list -fsyntax-only ... --list -c -o /dev/null ...`;
- `profile.sh`: `perf record -e instructions:u -c 1000003` of 100 runs of `-fsyntax-only` by each tree, each sample's
  address resolved against the tree's own symbol table (`nm`): perf records no build ID for these executables, whose
  are 32 bytes. The script's comment suspects perf's caches of resolving them wrong, but perf's report and this
  resolution gave the same counts on an earlier profile. A shorter period, 20,011 or 200,003, was throttled at the
  kernel's 63,300 samples a second, which dropped 3.5% of the samples unevenly, and those profiles aren't kept.

## Limits

One input and one placement per tree. The observed +0.426619% compile-wall cost is retained; placement and inlining
remain hypotheses rather than a neutrality waiver. The original controller filters lock-owner/wait messages and
does not archive an acquire/release receipt or before/after CPU-policy identities; the protocol requires the shared
lock and CPU 2, but those omitted receipts cannot be independently reconstructed here. The profile's per-run command
failures are not propagated by its loop, and only aggregate function counts are retained, so it supplies limited
attribution context. The history's trees predate the measured merge (`77c45e33`), whose deferred reader (#683) and
ISA policy (#421) the measured head and main share. Later review changes and hosted-workflow integration have no new
timing claim from this frozen record. A review compared all 669 base-manifest files and 671 head-manifest files with
`git archive` of the full commits above; every path and hash matched. Original raw logs and manifests are unchanged.
