# Local #657 evidence and target recipe

Frozen final target qualification is complete in `target/README.md`:
native checker 392,578/0, 55/55 object pairs identical, and deep check-input
growth reduced substantially. The target report supersedes the pending
target instructions below. Current-main compatibility is a separate tested
merge and is not assigned these frozen timings.

Source base: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Implementation: `19db0cf727010973289f49e58e542f17d626a7c6`.
Observable regression follow-up: `a50e29847b6483518095d4f04b3ce8bd86e95995`.

All added implementation, fixtures and harnesses are original project material.
Clang runs externally as the semantic oracle; no external implementation or
fixtures are imported. Source extracts `base-region.c`/`head-region.c` come from
the respective project revisions and retain the project license. They are the
exact helper, used by `region_work.c` to validate the regression's sensitivity.

The local machine is Ryzen 9 7940HS (Zen 4), so local timings are screening,
not target 9700X evidence. Release build uses BUSTER_DEBUG_INFO=0 and normal
`build.sh` flags. `build.log` records successful 41-unit build. The final test
invariant assertions, zero-region source-position skip and noinline regression
call boundary were added after that release checker unit's preprocessing; the
focused sanitizer adapter reads final source. The parent integrates and builds
both final commits before target qualification.

The exact-source bounded-work adapter shows:

- baseline: 65,533 transfers in a depth-65,536 chain take 2.548/2.513 CPU s
  with no region / one enclosing region; it exits 1 against the 1 s bound;
- head: 0.118/0.247 ms, same accepted counts, exit 0.

`generate.c` writes nested switch, outward-goto and local-goto programs, with
or without an enclosing GNU statement expression. CLI:

```
./generate switch 16000 region > switch-region-16000.c
./generate local 16000 region > local-region-16000.c
./generate outward 16000 plain > outward-plain-16000.c
```

Target runs should compile both source identities normally under the shared
9700X lock, and use one lock hold per run. Pin scalar timings to CPU 2. Compare
`--lanes 1 --time-stages -c INPUT -o OBJECT` on both at depths
1000/2000/4000/8000/16000, rotating build order, at least three samples per row.
Check each exit status and compare object bytes. Retain stdout/stderr,
`check-input` stage time, whole-process time, rusage and exact binary identities.
The wrapper-region rows are necessary: a no-region-only campaign would test
only the trivial bypass. Also screen frozen SQLite and small units for costs.

`region_checks.c` runs the permanent exhaustive token-pair equivalence,
postorder-interval invariant and bounded-work tests under ASan/UBSan. Its
`main-standalone.c` is the project's `main.c` with BUSTER_ELSEWHERE empty so
module entry points exist in one translation unit; its renamed driver is
removed by linker garbage collection. No production source is changed for it.

Local screening record `time-runs.log` (three rotated samples after one warmup,
48 successful processes total) uses the first release binary described above:

| Shape | Depth | Base whole compile ms | Head whole compile ms |
| --- | ---: | ---: | ---: |
| switches, plain | 4,000 | 72.364 | 24.416 |
| switches, plain | 16,000 | 807.674 | 92.450 |
| switches, enclosing region | 4,000 | 75.476 | 34.673 |
| switches, enclosing region | 16,000 | 804.903 | 106.993 |
| local gotos, enclosing region | 4,000 | 40.765 | 36.136 |
| local gotos, enclosing region | 16,000 | 398.686 | 225.577 |

`time-runs` suppresses the children's stderr. Separate direct stage-clock
screens are retained as `*screen.stderr`. The local-goto depth-16k head and
base object bytes compare equal; check-input is 20.283 versus 178.745 ms in
that separate screen, while other work remains significant. These screens
are not final-head or 9700X timing claims.

The first release full checker run exited 139 at the existing synthetic
control-walk fixture. That reader has no regions or postorder column; the
stale executable loaded the postorder column before testing the region count.
The committed production helper guards that load, so the source has already
fixed the stale-build failure. A fresh final release build/qualification is
required and tracked separately as `final-build.log`/`final-checker.log`.
The focused sanitizer adapter passes 3,083 checks with zero failures; it
contains the final production helper but was preprocessed before the
noinline-only test sensitivity follow-up. The independent `region_work.c`
adapter proves that follow-up's sensitivity using exact helper extracts.

Final release at `086c24b121e4834b821a47974069d2af8b9ed2fc` builds all 41
translation units successfully (`final-build.log`; binary identity in
`final-compiler.sha256`). Its completed qualification is:

- `test-checker --seed 657`: 392,578 checks, four failures, all the known
  laptop Clang `fpclassify` generated-program oracle disagreements. No crash;
  all region/control assertions pass. This is not reported as a full-suite pass.
- `test-checker-driver --executable ./build/compiler`: 21,639 checks, zero failures.
- `test-checker-asm`: 992 checks, zero failures across 632 source fixtures.
- `test-checker-deferred`: 1,113 checks, zero failures (70 fixtures, 6,492 bodies
  read separately).

No PR or remote branch was created. Controlled 9700X measurements remain with
the parent session. The local branch is `codex/perf-657` with three commits:
`19db0cf7`, `a50e2984`, `086c24b1`.
