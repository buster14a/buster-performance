# Source-CFG dominator qualification and measurement (#174, PR #940), 2026-10-31

buster14a/buster's pull request [#940](https://github.com/buster14a/buster/pull/940) extends the dominator
module to real C-source CFGs: `test-ir-source --dominators` rebuilds every accepted source function's CFG in
its lowered and both promoted IR forms, forces the scalar and vector solvers and AUTO to agree completely, and
checks an independent definition oracle; `--dominators-cfg NEW_FILE` exports every qualified CFG in the
`buster-dominators-v1` text format; `benchmark-dominators --cfg` imports the export and measures the three
paths on the real CFGs. This record is the pinned-corpus qualification and locked-9700X measurement the PR's
review required.

## Sources

- measured head: `5ebf340c39e12f27d0425810d1eefdd4cd2b3db7`
  (`Validate dominator CFG export completeness and qualify its importer`)
- PR head when this record was written: `32ee7208` — `5ebf340c` plus a merge of main's `b651971a`
  (tier1/callee-saved work only; no dominator, export or benchmark file differs, so the measurements carry
  over unchanged)

The tree is a clone of the repository at `5ebf340c`, built on the host with `./build.sh`
(`BUSTER_HOST_ARCH` default/native, which is `znver5` on this host; 41 sources in 40.2 s under the lock).
The executable's SHA-256 is `cbce034a...` in `logs/hostinfo.out`.

## Host

`logs/hostinfo.out`: AMD Ryzen 7 9700X (16 CPUs listed, CPU 10 off-line), Linux 6.18.50-2-lts, clang 23.1.1.
Every run took the host's shared lock alone (`~/buster-fast-bench/exclusive.sh`, one acquisition per command);
the timed benchmark ran under `taskset -c 2`.

## Corpus

The pinned CI corpus `preprocessor-391e729af658`:

- `sqlite/sqlite3.c`, 7,062,204 tokens after preprocessing with the CI's pinned options
  (`--predefines provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu
  -march=znver5 -std=gnu17 -nostdinc -isystem headers/usr/lib/clang/23/include
  -isystem headers/usr/local/include -isystem headers/usr/include`)
- `libc/musl`, all of `src/*/*.c` and `src/*/x86_64/*.c` (1,355 files) with the CI's pinned musl options
  (`-std=c99 -ffreestanding -D_XOPEN_SOURCE=700 -Os` plus its generated include tree)

## Commands and results

`scripts/reproduce.sh` has the exact commands.

### Qualification (`test-ir-source --dominators` / `--dominators-cfg`)

`logs/sqlite-ir-source-dominators.log`: `sqlite3.c` — 2,602 functions, 7,806 forms (three per function:
lowered, promoted-vector, promoted-scalar), 45,616,080 dominator checks, 0 failures, scalar/vector/AUTO
agreeing on every form and the oracle passing; the export `sqlite3-dom.cfg` is 2,614,292 bytes
(SHA-256 `58d13710...` in `logs/hostinfo.out`).

`logs/musl-ir-source-dominators.log`: musl — 1,355 files, 2,883 functions, 8,649 forms, 11,059,480
dominator checks, 0 failures, 0 files excluded, 0 failed.

### Measurement (`benchmark-dominators --cfg`, CPU 2)

`logs/benchmark-dominators-cfg-run2.log`: the importer reads the export, reports
`files=1 producer-supplied, functions=2602`, verifies scalar/vector/AUTO agreement on all 23,418 analyses,
then times each path on every bucket and the largest functions. A second run (summary below) repeated the
first session run within ~0.5%.

Whole corpus (`set=all`, all outputs, 7,806 CFGs, 137,120 blocks, 171,175 edges — 1.25 edges/block):

| run | scalar ns/block | vector ns/block | auto ns/block | vector/scalar |
|-----|-----------------|-----------------|---------------|---------------|
| 1   | 43.122          | 56.303          | 56.274        | 1.306         |
| 2   | 43.214          | 56.189          | 56.179        | 1.300         |

Largest CFG, `sqlite3VdbeExec` (1,759 blocks, 2,614 edges), `all` outputs, run 2: scalar 25.03, vector 59.71,
auto 59.67 ns/block — vector/scalar 2.386. `tree` output alone: scalar 13.68 vs vector 43.78 — 3.20×.

Per-bucket `vector/scalar` rises with block count: 1.21 in blocks[2,4) through 2.34 in blocks[1024,2048)
(`all` outputs; the log has every `tree`/`loops`/`all` row).

## Finding for #174's AUTO policy

On real source CFGs — sparse, ~1.25 edges/block — **the scalar solver beats the vector solver on every
measured bucket and every largest function** (1.2×–3.2× slower vector), yet **AUTO chose the vector solver
for all 7,806 of 7,806 CFGs**. AUTO's current selection rule therefore costs ~1.3× on this corpus, ~2.4× on
`sqlite3VdbeExec`. This PR changes no production threshold; this record is the measurement evidence for the
follow-up selection-policy change on #174. (On synthetic benchmark CFGs, where vector wins at sufficient
density, AUTO's rule was tuned; real CFGs' sparsity lands on the wrong side of it.)

Both runs' checksums differ (`291287062003859273`, `291458587332734537`) because the checksum counts
executed analyses and warm-up repetitions are time-budgeted; the per-repetition analysis results are
verified equal by the agreement check before timing, not by checksum equality across runs.
