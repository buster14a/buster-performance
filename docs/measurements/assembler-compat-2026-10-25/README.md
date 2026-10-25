# Assembler compiler-output compatibility, 2026-10-25

Qualification for [Buster #233](https://github.com/buster14a/buster/issues/233)
and [PR #416](https://github.com/buster14a/buster/pull/416).

## Source and provenance

- Implementation: `5bd90fd2fb011d5bff37c9769759343b5787aca9`.
- First complete PR head: `de1de66d3f898f1f9d6df2f1b21976b0eeed0527`, including main
  `19764052487c941cb88e8de391471daeffe39f05`.
- That head's required CI tested merge `3cf651d126718e556fe894539f9c4e4c44561482`. Its complete
  tree and the PR head's are both `60fcb057608f870ec891113493aaacd7a657537b`.
- Grouping checkpoint: `9e31c96eda74e04fe8b53ae2d68c1c765f4a4012`.
- Review correction: `0812f29cf0269cf849aec643a3d5d81505e63888`. It sizes CFI
  output from events/headers/actual escape bytes, sizes CIE scratch independently
  from the largest initial program, and retains local targets in explicit
  mergeable non-string constant pools as well as strings. Its complete compiler
  manifest is `source-bounded.sha256`; its receipts are `bounded-*`/`final-*`.
- The grouping checkpoint's required CI tested merge `86538a5749d2cef11070cd70b28ec419feb86bf9`
  against main `1789f659332c2814ebfce5a782e3c4c3000a8956`. The complete merge
  tree is `9924db91a551c10fb7b51c441519f193cdf08f77`, identical to the locally
  reproduced normal merge.
- The review correction's required CI tested merge
  `b4e07f406bd39f2278b44ec9b82e12f849e51074` against main
  `cefcb28d0457755f5ffea20e7ca80e782327ae19`. Its complete merge tree is
  `0b3728adb68ca0ba697e2fc718f50557519af65a`, identical to the locally reproduced
  normal merge. Its compiler/example/build-script files equal
  `source-bounded.sha256`.
- `source.sha256` covers the grouping checkpoint's compiler sources, examples and build script;
  `source-before-grouping.sha256` covers the earlier complete head.
  Every hash was checked against the independent target checkout before final
  qualification. The merge from main changed no file in this source manifest.

The original syntax/corpus implementation was recovered from benchpress's
stopped `assembler-compat-233` directory and reconciled against the old
assembler-owner checkpoint `2e36d2b6b9603fed5872dd2cfad4259bdb439181` and current
main. `recovered-source.sha256` identifies the retrieved files. The issue's old
local commit `20da30132cef44991c726bc50e7f217d5ec2323a` was unavailable locally;
the recovered directory is not asserted to be byte-identical to that commit.
It initially had 38 failing pending section/CFI checks, not passing acceptance.

The C corpus, caller, generator and adapters are original repository work under
Apache-2.0 WITH LLVM-exception. GCC, Clang, GNU as, the linker and the system
unwinder run externally. No external implementation or fixture corpus is
incorporated. The generated assembly/objects here come only from the original C
fixture at the qualified revision. Linked executables and system startup/runtime
objects are not redistributed. GNU's section/CFI documentation and observable
encodings supply behavior/format facts; its CIE escape/saved-state boundary was
also checked against the published `gas/dw2gencfi.c` behavior and a target oracle.

## Host and executable identities

Approved host: benchpress, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, x86-64.
Clang 23.1.1 built Buster, GCC 16.2.1 (20260810) and Clang 23.1.1 generated the
corpus, and GNU Binutils 2.47 supplied `as`.

| Executable | SHA-256 |
| --- | --- |
| Earlier complete Buster, `BUSTER_DEBUG_INFO=0 ./build.sh` | `d7b1cc1e2c16e5250245e259300ac023e813a543ec2001d0b74283f5a2801b38` |
| Earlier complete focused ASan/UBSan assembler | `e8fadc9e0abb937e7fc83b8d60b209bbdee256551ece72cd9495064d013364c2` |
| Grouping checkpoint Buster | `5bc433d413233dc3a72a2c579d11eec7fd6c7ad5a64b07f4de791297a40622ba` |
| Grouping checkpoint focused ASan/UBSan assembler | `8eb1af1ff7c590e9269f7abdc99a7aa31d0343b9a75536b63992a1c88895e0fe` |
| Review-corrected Buster, `0812f29` | `1384ea96c7f2108d0ef7b0e5bc17295d4209fa20ec9277b6c8f8237a0b465c95` |
| Review-corrected focused ASan/UBSan assembler | `9f54db8f8dd5f0e8b26bbbc04dac9ff9a9abcbc09e4e252d9ddf58ae48235d9b` |
| Whole-process resource helper | `f3373dbd14b48fce26b4baefff52d2fcddac2bfed3cc7df09ed13bc6e2c96fc7` |
| Current-main baseline Buster, `5863eed` | `9e74bdb733704bdd6298659fe739ecd819182c8728e429ca187af0e55c6a621e` |

Every target build, test and measurement acquired
`~/buster-fast-bench/exclusive.sh` separately, with an owner, title and PR/issue
link. No lock spans a sequence of runs. Measurements use CPU 2; no host settings
were changed. CI acquired the same lock through its runner hooks.

## Earlier complete head's correctness

- Final optimized `test-assembler --cross-check --keep --seed 233 --fuzz 20000`:
  **1,909,846 checks, zero failures**.
- Focused ASan/UBSan `test-assembler --seed 233 --fuzz 20000`:
  **1,909,473 checks, zero failures**, with leak detection and immediate UB failure.
  `sanitized.c` includes the real assembly unit and tests; the complete executable
  separately qualifies production commands/preprocessing and external tools.
- Default writer `test-object-writer --cross-check`: **844 external comparison
  checks, zero failures**, in addition to its internal invariants/determinism
  checks. Default/function sections, many units, extended section indices,
  IFUNCs, linker consumers and unchanged-destination errors passed.
- [Required 9700X CI run 40178272935](https://github.com/buster14a/buster/actions/runs/40178272935):
  **74 commands passed, zero failed/not started**, plus required benchmark steps.
  Its assembler run passed 1,873,773 checks at seed 1/fuzz 2000. The separate
  Measurement storage policy check also passed.

All 16 compiler cases passed: GCC/Clang, O0/O2, AT&T/Intel, ordinary/separate
sections. Each requires equal scalar/vector objects, comparison with GNU as,
and independent execution of all three objects. The unwind callback must
identify the assembled `corpus_call` and caller `main` by
`_Unwind_GetRegionStart`, as well as reach the required depth. The original
fixture inputs are `examples/assembler/compiler-corpus.c` and
`examples/assembler/compiler-caller.c` at the source pin.

`corpus/` retains each generated source and its reference/vector/scalar object.
GNU relocation records are sorted only in the in-memory comparison copy; the
archived reference objects are the original outputs. Comparison checks section
properties/bytes, global symbols, relocation offsets/types/targets/addends. This
uses the existing comparator's metadata allowances; it is not byte-for-byte ELF
identity with GNU as. Scalar and vector ELF files must be byte-identical.

Compiler corpus options: `-march=x86-64 -fcf-protection=none -fno-pic -fno-pie`,
O0/O2, AT&T/Intel and ordinary/separate sections. Clang additionally uses
`-fno-integrated-as` for GNU-compatible spelling. LLVM-only address-significance
annotations have separate acceptance tests. The corpus does not establish all
PIC/TLS/ISA/debug or CFI augmentation support.

Focused cases cover expression operator pairs, aliases, uppercase Intel words,
parenthesized address registers, constants/quoted names, note handling, symbol
elision, weak/global/cross-section branches, unsigned whole-width immediates,
and narrow LEA, including execution with an external address at `0x80000000`.
CFI cases cover common/different CIEs, simple/signal frames, state transitions,
extended/signed rules, all location-advance widths, relaxation/alignment and
128 separate sections with 17 reused initial CIE programs. Short metadata
tables are rejected before allocating output.

## Reproduction

From the qualified Buster checkout on the target, each command under its own
lock with `EXCLUSIVE_OWNER`, `EXCLUSIVE_TITLE` and `EXCLUSIVE_LINK` set:

```sh
BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
~/buster-fast-bench/exclusive.sh ./build/compiler test-assembler --cross-check --keep --seed 233 --fuzz 20000
~/buster-fast-bench/exclusive.sh ./build/compiler test-object-writer --cross-check
~/buster-fast-bench/exclusive.sh clang -O1 -g -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all /path/to/sanitized.c -no-pie -lm -ldl -o build/assembler-sanitized
ASAN_OPTIONS=detect_leaks=1 UBSAN_OPTIONS=halt_on_error=1 ~/buster-fast-bench/exclusive.sh ./build/assembler-sanitized test-assembler --seed 233 --fuzz 20000
```

`logs/recovered-test.log`, `cfi-test.log`, `cfi-v2-test.log` and
`complete-test.log` are development diagnostics from intermediate dirty source,
not additional qualified revisions. They preserve the initial missing features,
the section-type correction, the LEA correction and raw-escape CIE boundary.
Only the named final logs, source manifest and CI establish final acceptance.

## Grouping checkpoint's acceptance

- Optimized `test-assembler --cross-check --keep --seed 233 --fuzz 20000`:
  **1,909,851 checks, zero failures**, including all 16 compiler corpus cases.
- Focused ASan/UBSan run, with the same seed/fuzz count:
  **1,909,477 checks, zero failures**, no sanitizer diagnostics.
- [Required 9700X CI run 40179587776](https://github.com/buster14a/buster/actions/runs/40179587776):
  **74 commands passed, zero failed/not started**, with every required benchmark
  step successful. Its assembler run passed 1,873,778 checks at seed 1/fuzz 2000.
  Measurement storage policy also passed for the exact head.
- `corpus-grouped/` retains the grouping checkpoint's corpus source and all three objects per
  case. `corpus-identity.txt` is the empty successful recursive comparison against
  the earlier complete corpus: **all 16 source files and 48 object files are
  byte-identical** across the grouping correction, in addition to the final GNU
  semantic comparison and independently executed results/unwind checks.

The additional interleaved-section regression switches to data/rodata inside a
CFI procedure, returns to code, then relaxes a branch and aligns code before the final
rule. It checks the new emission batches and the inserted CFI fragment together.
The frozen 32/2,048-function measurement inputs also produce byte-identical
objects across both implementations, as recorded in `logs/grouped-identity.log`.

## Review-corrected head's acceptance

The final implementation head is `0812f29cf0269cf849aec643a3d5d81505e63888`.

- Optimized `test-assembler --cross-check --keep --seed 233 --fuzz 20000`:
  **1,909,868 checks, zero failures**, including all 16 compiler corpus cases.
- Focused ASan/UBSan with leak detection and immediate UB failure:
  **1,909,493 checks, zero failures**, no sanitizer diagnostics.
- [Required 9700X CI run 40181171865](https://github.com/buster14a/buster/actions/runs/40181171865):
  **74 commands passed, zero failed/not started**, with every required benchmark
  step successful. Its assembler run passed 1,873,795 checks at seed 1/fuzz 2000.
  [Measurement storage policy 40181171807](https://github.com/buster14a/buster/actions/runs/40181171807)
  also passed for this exact head.
- The GNU-as differential fixture for `.rodata.cst8,"aM",@progbits,8` passes
  with a local RIP-relative code reference and an addended data reference. This
  directly checks retention of local targets in mergeable non-string sections.
- A sparse-CFI stress fixture pads the same short procedure with unrelated
  source text: both **63-byte and 1,048,623-byte sources reserve 149,336 bytes**
  in the retained work arena and emit a **48-byte `.eh_frame`**. Optimized,
  sanitizer and CI runs all print these values. This is logical retained arena
  usage, not peak RSS or the scratch arena's high-water mark.
- `corpus-bounded/` retains all 16 generated sources and 48 objects at this head.
  The empty `corpus-bounded-identity.txt` records their successful byte comparison
  against `corpus-grouped/`; the GNU semantic comparison and native
  execution/unwind checks ran again, independently.

CFI output now reserves `64 * events + 128 * procedures + actual escape bytes`;
temporary CIE construction reserves `64 + 64 * largest initial-event count`.
Neither bound includes unrelated source length. Escape/saved-state events stay
in the FDE and are not part of CIE candidate scratch.

## Pipeline measurements and grouping correction

The first large-input measurements exposed a quadratic emission scan in the
earlier complete head: it visited the entire source fragment stream for each
named section. Its 2,048-function input spent roughly 46 ms in encode/Link,
although CFI itself took only about 0.061 ms. Functional tests alone did not
expose this scaling cost.

The final grouping change retains the stable section partition already needed
for layout and hands it directly to emission. One reserved slot accommodates
the single post-layout CFI fragment, preserving original fragment IDs and each
section's order. Encoding can batch instructions whose code bytes are adjacent
even when declarations of other sections intervene in the source. The two
executables use separate immutable target directories; the input files and
component benchmark are frozen. This comparison is against the intermediate
compatible implementation, not against main's earlier unsupported corpus path.

`generate.c` creates original synthetic C functions with external calls and
conditional arithmetic. GCC O2 emits baseline AT&T assembly with function/data
sections. The two inputs contain 32 and 2,048 functions; the benchmark prints
zero as its unknown function count instead of inferring it from assembly.
The input hashes are in `logs/workload-preparation.log`.

`benchmark-assembler --input` reads each source once outside timing, then checks
complete scalar/vector object equality while measuring lexing, parsing,
matching, final layout, encoding/Link handoff, object preparation/build and total
time. Its CFI column is a subset of encode/Link, never added to total. Work-arena
bytes include retained/reserved tables and emitted data, but exclude scratch
arenas and are not an RSS measurement. The comparison qualifies the bounded
grouping correction; it is not a general compiler speedup claim.

Measurement commands, each with a separate lock: the large input repeats three
fresh processes per binary/state; the small input has one process per
binary/state as a descriptive control:

```sh
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-assembler --input probes/small.s
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-assembler --input probes/large.s
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-assembler --input probes/small.s --after-scalar 200
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-assembler --input probes/large.s --after-scalar 200
```

Each process reports 21 interleaved-pass medians after warmup. Conditioned runs
perform 200 ms of scalar assembly before each sample, outside timing. Individual
21 samples are not printed by this benchmark; preserved logs contain each
process's phase medians at the tool's 0.001 ms output precision. CFI event byte
emission retains ordered state and scalar record stores, while indexed section/
CIE identities and batched fragment layout avoid downstream reconstruction or
quadratic searches. Its measured share is reported with the complete pipeline.

### Grouping checkpoint results

Milliseconds: median of three process medians, with the process range in
brackets. The paired inputs, generator and benchmark are unchanged. These rows
compare `de1de66` with `9e31c96`, before the later allocation-bound review fix.

| State/path, 2,048 functions | Before total | Grouped total | Before encode/Link | Grouped encode/Link |
| --- | --- | --- | --- | --- |
| Plain scalar | 54.801 [54.764, 54.945] | 8.748 [8.726, 8.760] | 46.707 [46.690, 46.784] | 0.747 [0.743, 0.748] |
| Plain vector | 50.870 [50.825, 50.957] | 5.202 [5.181, 5.208] | 46.161 [46.129, 46.206] | 0.413 [0.411, 0.414] |
| After 200 ms scalar, scalar | 54.747 [54.610, 54.817] | 8.783 [8.764, 8.947] | 46.726 [46.665, 46.759] | 0.743 [0.742, 0.747] |
| After 200 ms scalar, vector | 50.894 [50.843, 51.025] | 5.215 [5.203, 5.221] | 46.143 [46.128, 46.179] | 0.412 [0.411, 0.414] |

Every grouped process was faster than every before process in the same state
and path. CFI itself remained approximately 0.060–0.061 ms: about 1.2% of the
complete vector pipeline. This supports retaining scalar CFI record emission
at this boundary while removing the substantially larger repeated scan; it is
not an assertion that CFI cannot be vectorized further.

The retained work arena grows from 88,232,056 to 88,428,728 bytes for the large
input: 196,672 bytes (0.22%) for the persistent ranges, excluding scratch arenas.
Both produce exactly the same 695,224-byte object. The single-process 32-function
control has 11,112-byte objects and vector totals 0.089 -> 0.081 ms plain; its
recorded 200 ms conditioned values and scalar/phase rows are in the raw logs.
That tiny control is descriptive, not a statistical speedup claim.

## Final whole-process resource controls

`resources.c` is an original C `fork`/`execvp`/`wait4` wrapper, compiled with
`clang -O2 -Wall -Werror` under its own target lock. It measures monotonic wall
time and Linux `ru_maxrss` for the entire benchmark process, including startup,
warmup and all samples. These are distinct from the assembler's per-operation
phase medians and retained arena bytes. It inherits the child's stdout/stderr;
separate `.rss.txt` reports preserve exit status, command, page faults and CPU
time. The target had no `/usr/bin/time`; failed attempts to invoke that missing
tool did not run a benchmark and supply no measurements.

Each control process runs pinned to CPU 2 under a separate lock, for example:

```sh
~/buster-fast-bench/exclusive.sh clang -O2 -Wall -Werror resources.c -o resources
~/buster-fast-bench/exclusive.sh /path/to/resources r-final-mixed.rss.txt taskset -c 2 ./build/compiler benchmark-assembler
~/buster-fast-bench/exclusive.sh /path/to/resources r-final-registers.rss.txt taskset -c 2 ./build/compiler benchmark-assembler --workload registers
~/buster-fast-bench/exclusive.sh /path/to/resources r-final-writer.rss.txt taskset -c 2 ./build/compiler benchmark-object-writer
~/buster-fast-bench/exclusive.sh /path/to/resources r-final-large.rss.txt taskset -c 2 ./build/compiler benchmark-assembler --input probes/large.s
```

The supported mixed/register-only single-section controls and shared default
writer are paired against current main `5863eeda331dacaa1371e1fe9ca1456e9d0039ca`,
built independently with the same optimized build options. The frozen compiler
assembly with nonzero CFI is paired against the earlier complete compatible
implementation `de1de66`; main cannot accept that source or the `--input`
benchmark option. Additional `de1de66` mixed/register/writer controls are retained
to distinguish the compatibility implementation from the grouping correction.

These final controls have one fresh process per revision/workload. Their
internal 21-pass medians and whole-process resource readings are descriptive,
not repeated-process statistical bounds or a general regression-free claim.
Only the earlier three-process frozen-input campaign qualifies the grouping
speedup. Object-byte counts are reported alongside timing; assembler-local
symbol elision legitimately changes synthetic object metadata from main.
