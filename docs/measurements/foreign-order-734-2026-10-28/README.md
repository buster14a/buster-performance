# Foreign symbol order: functional and cost qualification

Compiler issue [#734](https://github.com/buster14a/buster/issues/734) fixes
observable output order that previously followed hash-partition name IDs.
This record couples the functional controls and the cost of retaining/sorting
first-record keys. It does not propose a general performance optimization.

## Frozen inputs

- Baseline: `abc6bf2455c6d1d78f16bc2d494276380c546a79`.
- Frozen measurement candidate: `732b79132a52264683abdd0b757053c3901e622b`.
- Published source: [compiler PR #747](https://github.com/buster14a/buster/pull/747),
  initially integrated with main as `74430099d12c2dde80e1b7fd10c9973b93c1d901`.
  Its foreign production/tests and determinism documentation are byte-identical
  to the qualified candidate. The integration's CI is separately attributed;
  the timing experiment keeps the coherent frozen baseline/candidate pair.
- Subsequent public correction: `85629e6c4d616613ceb07124b95facee21c56449`
  changes the conversion gather and its guards to address own-source checking.
  Its resolver radix is unchanged. The cohort below does not qualify the
  changed conversion helper or transfer whole-command timing to this head.
- Target: Ryzen 7 9700X, Linux/x86-64, unchanged host clock policy.
- Toolchain: official LLVM/Clang 23.1.4, release
  `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`.
- Official `LLVM-23.1.4-Linux-X64.tar.zst` SHA256:
  `efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378`.
- Release license SHA256:
  `8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee`.

The archive and license were verified under one bounded staging lease. The
read-only installation is
`/home/david/buster-fast-bench/codex-734-20261028/toolchain/official`.
Its `stage.log` receipt SHA256 is
`9eea3a750c0d8bd887e8ab49402d5b69635b9455c0a9ee39995f369d73ebb430`.
Source, output and evidence directories belong to this issue alone. Other
agents may use the frozen toolchain read-only; they retain separate workspaces.

## Protocol

Every target build, test and benchmark obtains its own
`~/buster-fast-bench/exclusive.sh` lease, with owner/title/issue link. There is
no campaign-wide lease. Local multicore and long serial runs use `cores` per
run. Source snapshots are immutable while a build/test reads them. Failed
setups, rejected fixture controls and superseded-source results are retained
with their original identity; they are never relabeled as final-head passes.

Production builds use `build.sh`, `BUSTER_DEBUG_INFO=0`, its ordinary
`-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror`
flags and the official toolchain. The portable build uses `-march=x86-64`.
Focused actual-module sanitizer adapters use the same source/ABI flags with
`-O0 -g0 -fsanitize=address,undefined -ffunction-sections -fdata-sections`, and
link with `--gc-sections -pthread -ldl -lm`. Their main-header override emits
module entry points locally and defines the otherwise shared target table;
the explicit thread context starts with one lane. Raw-driver children dispatch
to the actual `run_foreign_link` function.

`harness/foreign-cost.c` includes the pinned original
`src/buster/compiler/foreign_benchmark.c`. A noinline qsort wrapper records each
u64 sample before the benchmark sorts it for a median. The hook executes only
after that resolution loop's timed intervals have ended. Run without
`--linkers`, which has double-valued external-linker samples. The original
input generator, one warm-up, clock boundaries, phase collection, exact/vector
comparison and lane placement remain in use. The warm-up is excluded by the
original benchmark and is not invented as a timed sample.

The executed plain matrix is the benchmark's default 1/2,000/102,400 workers
(8/8/64 filler instructions), dynamic/static/archive-member kinds, 1/8 lanes,
vector/exact paths and 21 timed samples per row. The one-worker member kind is
inapplicable. Thus each process must preserve **320 groups / 6,720 samples**.
`harness/foreign-samples.c` rejects a missing, malformed or duplicate group/run;
it emits per-row minimum, median, maximum and mean without discarding samples.
Several baseline/candidate processes and repeated baseline controls distinguish
an observed cost from drift. Normal production `benchmark-link` foreign rows
provide a separate whole-command check. No tiny fixture establishes universal
neutrality, current-main performance, or an additive speedup.

The final bounded identity lease completed at 22:12 UTC, exit 0. Its
[source manifest](raw/receipts/source.sha256) covers 1,072 files across the two
snapshots, the [binary manifest](raw/receipts/binaries.sha256) identifies both
compilers and both adapters, and the
[input/output manifest](raw/receipts/inputs-and-outputs.sha256) covers 5,222
retained files. Their SHA256s and host/tool versions are retained in
[the lease receipt](raw/target-manifest-dispatch.log) and
[identity log](raw/receipts/identity.log).

Removing only dataset/temp-directory prefixes proves all 525 generated
resolver object/archive input hashes agree across all six processes, and all
512 retained largest-model command object hashes agree across all four
processes. The command reuses its object directory, so earlier smaller-model
object bytes are overwritten; their generator parameters/output summaries
remain recorded, without claiming a final hash of those overwritten inputs.
Internal runtime snapshot files differ between baseline/candidate source and
repeat identically within each source; their exact hashes are retained.

## Result status

Correctness at the frozen candidate is qualified:

- Target official 23.1.4 native build: all 41 units, full
  `test-foreign --cross-check`, zero failures. The new canonical-order group
  passes **2,113 checks / 0 failures**.
- Local native and baseline x86-64 actual-module ASan/UBSan/leak runs each
  pass **2,113 / 0**, including fresh raw-driver child processes.
- The identical functional test body on unchanged baseline foreign production
  fails **336 of 1,143 checks**. The 970 new-kernel checks are omitted because
  that older source does not expose their ordering helpers. The three old
  production files are byte-for-byte baseline blobs; only test registration
  and the callable harness are added.
- The full portable 41-unit build passed at `97c47417`, whose foreign production
  is identical to the frozen candidate. The final vocabulary witness is
  covered by the exact-candidate portable sanitizer execution. Both-host
  whole-main warning-as-error syntax passes on integration `74430099`.

The frozen cost cohort is complete: three baseline/candidate resolver pairs
and two whole-command pairs. All six resolver matrices contain exactly 6,720
timed samples. The reader rejects empty, truncated and duplicate controls with
status 1. Independent read-only recomputation found no mismatch in all 1,920
derived min/median/max rows or the comparison arithmetic. No sample was removed.

The added ordering cost is material: the largest resolver cases add about
0.93–1.11 ms in the winners phase. The production command's repeated forced
eight-lane medians add 0.73–1.64 ms (2.1–5.0%) on its largest cases, and
0.38–0.48 ms (13.0–21.2%) on its medium cases. The largest pinned-one-lane
command medians are lower in both repeats. This is a measured tradeoff for
deterministic output, without a general neutrality or speedup claim. See
[the full results and limits](RESULTS.md), [commands](COMMANDS.md),
[all phase comparisons](raw/phase-comparison.csv) and
[all whole-command comparisons](raw/whole-comparison.csv).

Initial integration `74430099` has a separately recorded CI blocker: the native
own-translation-unit checker rejects the existing catalog builtin underlying
the new unsigned-safe gather. Hosted baseline and the 2,113-check foreign group
pass; native hosted fails, the physical build prerequisite fails and its
benchmark is skipped. The coordinator subsequently published the split-base
gather correction `85629e6c`; its exact source qualification and genuine CI
remain separate from this cohort. At receipt collection, hosted native and
x86-64 jobs are in progress; changes/storage policy pass. The prior separate
checker-admission proposal is an alternative under reviewer coordination. See
[the review](https://github.com/buster14a/buster/pull/747#pullrequestreview-5690176941)
and [the correction handoff](https://github.com/buster14a/buster/pull/747#issuecomment-6481872037).

Rejected/superseded records remain distinguishable:

- `old-regression.log` (968/328) and `harness/old-regression.c` are an initial
  negative control, superseded by `old-final-functional.log` (1,143/336).
  Its static GOT assertions did not account for legal assembler relaxation,
  and its one-name ID witness could remain unchanged. Do not use that initial
  total as a production-failure count.
- `rejected-candidate1-run.log` (1,936/64) is the corresponding rejected
  qualification control. Final fixtures force real GOT slots and check all 301
  fixed-spelling IDs for the perturbation witness.
- Candidate 2 standalone/native and portable build failures are retained:
  an unused conversion-only helper under `-Werror`, and a missing baseline
  implementation of the new i64-index gather. Final source has an explicit
  scalar-host fallback and keeps the standalone benchmark warning-clean.

No earlier receipt is relabeled as a later-source pass. Exact integration CI,
the frozen before/after cost comparison and the reviewer's acceptance of the
measured tradeoff remain separate decisions. Compiler PR #747 stays draft.

The original reports, adapters and fixtures here use Apache-2.0 WITH
LLVM-exception. They include pinned Buster source under its retained terms;
the existing MIT lane component remains governed by its notice. The official
LLVM archive, system CRT/libc/libgcc and external compilers/linkers are tools
or runtime inputs, not source implementation imported into this record.
