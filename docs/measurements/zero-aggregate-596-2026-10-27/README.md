# Symbolic zero aggregate data, Buster #596

Compiler PR: [#627](https://github.com/buster14a/buster/pull/627).

Frozen sources:

- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Candidate: `dc527d1e0480cde1459ae196767ee44069e1d57b`.

The candidate validates and serializes scalar writes once, keeps all-zero writes
and CLEAR ranges symbolic, and uses last-writer ownership of bit intervals when
overwrites can remove earlier nonzero bytes. It materializes an aggregate only
when a nonzero byte or relocation survives. Const zero data keeps RODATA.

## Results

The 256 MiB explicit-zero compile falls from **18.248 to 1.751 ms** (90.4% less
wall time, 10.42x on this input), and peak RSS from **282,056 to 23,860 KiB**.
All 1,848 timed compiles exit zero. Medians pool 21 fresh processes per variant:

| Explicit-zero N | Base wall, ms | Candidate wall, ms | Base peak RSS, KiB | Candidate peak RSS, KiB |
| --- | ---: | ---: | ---: | ---: |
| 1 MiB | 1.464 | 1.462 | 21,912 | 23,856 |
| 4 MiB | 1.550 | 1.470 | 24,044 | 23,848 |
| 16 MiB | 2.216 | 1.808 | 36,292 | 23,848 |
| 64 MiB | 5.776 | 1.692 | 85,444 | 23,856 |
| 256 MiB | 18.248 | 1.751 | 282,056 | 23,860 |

The separately clocked 256 MiB publication stage falls from a median **16.055
to 0.005 ms**, with 131 versus one minor fault charged to that stage. Its median
added peak RSS falls from 260,132 KiB to zero. Whole-process resource values are
in `summary.tsv`; sub-millisecond reported system CPU times are quantized, so a
zero median does not mean the process performed no kernel work.

At 256 MiB, TLS zero falls 18.502→1.885 ms, designated zero 18.263→1.721 ms,
overwrite-to-zero 18.580→1.919 ms, cleared bit-fields 18.255→1.769 ms, and the
discarded-relocation case 25.255→1.841 ms. The const-zero case keeps a full
256 MiB RODATA payload: its 268,436,736-byte object is unchanged, and wall time
falls 102.257→84.719 ms. The writable zero object stays 1,280 bytes with a
268,435,456-byte NOBITS section. Section listings and object sizes are retained.

For a 256 MiB explicit-zero object, the data emitter's logical scratch demand
falls from **268,435,504 bytes to 112 bytes**, clearing from **536,870,920 to 8
bytes**, and reducer reads from **268,435,457 to 2 bytes**. The same 112-byte
peak holds from 1 through 256 MiB for the zero and TLS plans. Overwrite-to-zero
plans peak at 264 bytes across those sizes. Both versions publish the expected
BSS/TBSS size with no payload or relocation. These are instrumented work counts,
not wall-time or RSS results (`scratch-work.tsv`).

The final source passes all three GitHub checks. The [9700X job](https://github.com/buster14a/buster/actions/runs/40574974495)
passes **82/82 commands**, including the checker at **332,797 checks, zero
failures**. Its graph check reports 41 translation units, 23,962 functions,
zero unallowed cycles, three existing allowed cycles and zero split variables.
The job checks out `668039232331791f28d0d94fa009a7908332be2f`, the test merge of
the final candidate into the frozen baseline. Its tree is
`83fd85419e2cbe846207efea99ef15a97fd3671e`, identical to the candidate's tree.
`ci-full.log` retains the complete
1,320,285-byte receipt, SHA-256
`92aead7c3d5e7504de9d17172ec13a729532a71a4598aec97989bf65136c3bba`.

All 43 synthetic objects **and SQLite** are byte-identical between the two
compilers. All **86 Buster/Clang runtime checks pass**, including separate
pthread TLS storage, const data and negative zero (`verify.txt`).

### Costs and controls

This is a targeted large-zero improvement, with measured costs on other shapes:

| Control | Base wall, ms | Candidate wall, ms | Pooled change | Base/candidate peak RSS, KiB |
| --- | ---: | ---: | ---: | ---: |
| Dense 65,536-byte array | 21.425 | 21.743 | +1.49% | 166,532 / 168,488 |
| Dense array ending in zero | 21.403 | 21.799 | +1.85% | 166,532 / 168,416 |
| SQLite compile | 144.187 | 144.355 | +0.12% | 506,016 / 507,992 |

The dense input's three round changes are +1.34%, +1.26%, +1.39%; the
tail-zero input's are +2.38%, +4.30%, +1.47%. Its separately clocked publication
stage is also slower (dense median 1.003→1.261 ms). The new encoded-write cache
and second source-part traversal are charged to these results. Ordinary BSS
controls show +0.55–1.29% pooled wall time and about 1.9 MiB higher peak RSS in
this image comparison; negative-zero wall time is +1.25%. These small-input
memory costs remain even when there is no object-sized zero buffer to remove.
SQLite's round changes are +0.20%, +0.30%, −0.08%; they establish neither a
speedup nor timing neutrality across compiler layouts. No corpus-wide speedup
is claimed.

Static cost: `check_data_emit` grows from 8,276 to 14,026 machine-code bytes,
including the inlined overlap fallback. `function-sizes.txt` and
`check-data-emit.asm` retain that cost and the emitted bounded scan. Timing
controls above expose the common-path costs. No instruction-count or generated
program-speed claim is made.

## Method and scope

The target is the shared AMD Ryzen 7 9700X, Clang 23.1.1, native release builds
from separate `git archive` snapshots with `BUSTER_DEBUG_INFO=0 ./build.sh`.
Every build, test and measurement acquires `~/buster-fast-bench/exclusive.sh`
with an issue/PR owner label. Each fresh-process comparison round is a separate
lock hold, pinned to CPU 2. No host setting is changed.

`generate.c` creates original source inputs for implicit BSS, `{0}`, TLS `{0}`,
final designated zero, overwrites to zero, cleared bit-fields, a discarded pointer
relocation, and const `{0}` at N = 1, 4, 16, 64 and 256 MiB. It also creates a
negative-zero double array and two 65,536-byte dense arrays, one ending in zero.
Every object is externally visible and is used by `get`; `get_size` exposes its
size for runtime checking. The inputs are generated outside timing.

`compare.c` runs each compiler with `--lanes 1 -c INPUT -o OBJECT`. Three rounds
each discard one warmup per executable/input and retain seven fresh-process
samples per variant. Variant order alternates by repetition and round; input
order rotates by round. Each child is reaped with `wait4`. Wall time includes
fork/exec and publication; system time, faults and peak RSS are the child's
resource usage. A separate `--time-stages` compile per variant/input/round records
`publish-data` time and stage resource deltas, outside the default-path samples.
The SQLite control uses the existing frozen amalgamation at the path recorded
by `control.sh`, with its hash retained before and after the campaign. SQLite
samples also alternate variant order. These are compile-time measurements;
generated-program speed is not measured.

`report.c` requires all 1,848 status-zero timed rows, 264 discarded warmups and
44 cases. It rejects duplicate/missing timed samples and malformed rows. Summary
round 3 pools all 21 retained samples per variant; rounds 0–2 show each round
separately. **Every timed sample is retained**, including one candidate TLS
256 MiB sample with one major fault (`round-2.tsv:4`, also listed in
`major-fault-samples.txt`). Its 1.885 ms elapsed time is included in the medians;
the summary reports major-fault totals explicitly. No timing samples are
dropped or replaced. The initially planned stricter `summarize.c` reader
rejected that row; its rejection is retained in `summary-validation-initial.txt`.
The final report therefore makes no claim that all samples were free of
file-backed page faults. Repeated processes at one binary layout do not
establish a small speed difference across compiler placements. A synthetic
large-zero result is not a corpus-wide compiler-speed claim.

## Work and allocation audit

`prepare-audit.c` reconstructs an overlay of each exact compiler tree. It wraps
only `c_check_data.c`'s arena requests, `memset` and `memcpy` calls and instruments
its byte reducers. `audit.h` counts successful scratch bytes requested, maximum
scratch length, logical bytes cleared/copied in scratch and logical bytes
examined by reducers, including repeated ranges. These are algorithmic work
counters, not cache-line traffic or PMU events. Arena pushes inside the separate
reference-liveness module are not wrapped; the audited zero/TLS/overwrite
inputs contain no symbolic-reference candidates and that module allocates none.
Stack temporaries and output-arena writes are outside these scratch counters.

The audit uses the production `check_data_emit` with the real types, Link and
arena implementations. Its zero/TLS/overwrite plans mirror the checked writes;
the all-zero scalar's offset is irrelevant to allocation demand. Both variants
must publish the expected BSS/TBSS size and no payload or fixup. The audit images
are used only for work counts; timing uses the unmodified release images.

Nonzero aggregate planning caches 32 bytes per checked part, plus existing
relocation metadata. The overlap-analysis fallback needs additional storage
proportional to checked parts and is released before object materialization.
Zero plans release all their unused write/reference caches before the next
object is planned. The focused suite proves that a batch of 1,024 zero objects
fits 64 KiB scratch. As a negative control, compiling the final focused tests
with `e387c64b`'s `c_check_data.c` instead fails exactly that batch test
(`cache-lifetime-negative-control.txt`). The cache cost for nonzero objects is included in the
end-to-end dense-array and SQLite measurements.

## Correctness and provenance

`verify.sh` compares all 43 synthetic baseline/candidate objects and SQLite byte for byte, retains
`readelf` section/symbol/relocation listings, and runs separately linked Buster
and Clang objects against `verify.c`'s independent size/byte expectations. TLS
also runs in a new pthread to check separate zero-initialized storage. Const
data and negative zero are checked alongside writable BSS. Object binaries and
the large generated inputs are reconstructed by the harness rather than stored
in this repository; hashes identify them.

The local Zen 4/Clang 23.1.4 focused entry point (`focused.c`) passes 66,358 checks
under ASan/UBSan. Ten compiled-program shapes pass the same runtime oracle
locally. The initial local integration build's driver, object writer and Tier 0
suites pass; that build predates the final cache-lifetime change and four extra
rollback fixtures. The final focused sanitizer run covers all new regressions.
The local checker reports four floating-classification oracle mismatches. The unchanged
baseline reproduces the same four failures with identical printed results
(`local-baseline-checker.txt` versus `local-checker.txt`); they are not introduced
by this change. Authoritative target qualification is recorded separately.
The first candidate `e387c64b` was built, but its target measurement-tools job
was stopped while still waiting for the lock, before collecting any timing.
The final candidate adds immediate zero-cache release and its batch regression;
the first build/queue logs are retained under `superseded-e387`.

After all timing and runtime checks passed, the optional duplicate manual test
runner rejected the initial controller's list format before starting any test
(`tests.txt`); the subsequent standalone graph command was not reached. Full
native qualification comes from the successful 82-command CI job and graph
check above, not that manual wrapper. The controller exited and leaves no
queued process. `executed-harness/` preserves the exact executed scripts and
sources; from that directory, `sha256sum -c ../harness.sha256` verifies all ten
files. The top-level `control.sh` corrects the list's headings and executable
prefixes for future reproduction; the timing commands are unchanged.

All new harnesses and synthetic C inputs are original project material under
Apache-2.0 WITH LLVM-exception. They include the compiler at the pinned revisions
and retain its existing component licenses, including lane.c's MIT terms.
Clang, the system linker, pthreads and readelf are external oracles/runtime tools;
their implementation is not incorporated. SQLite is an external existing
benchmark input and is not redistributed here. No third-party implementation or
generated instruction database is imported.

## Reproduction

Create sibling `base`, `head` and `record` folders, extract the two source commits
to `base`/`head`, and copy this directory's harnesses to `record`. On the approved
host, build each tree under the shared lock with `BUSTER_DEBUG_INFO=0 ./build.sh`.
`build-tools.sh` builds the measurement-only audit images and controller,
generates the synthetic inputs, and records identities/environment. Run it
under the same lock. `executed-harness/control.sh` records the executed sequence;
the corrected top-level `control.sh` supplies the same timing/verification path
and a working optional manual test list. Its host paths must be adjusted if
using a different private campaign directory.

Recompute the retained summaries locally:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror report.c -o /path/to/work/report
/path/to/work/report round-0.tsv round-1.tsv round-2.tsv > summary.tsv
```

For the focused local sanitizer check, from the candidate source root:

```sh
clang -O1 -g -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing \
  -ffunction-sections -fdata-sections -Wl,--gc-sections \
  -fsanitize=address,undefined -fno-omit-frame-pointer \
  /path/to/record/focused.c -o /path/to/work/focused -lm -pthread
ASAN_OPTIONS=detect_leaks=1 /path/to/work/focused
```

Use `cores` for multicore local runs where installed, as the compiler's guide
requires. Local correctness results supply no 9700X performance evidence.
