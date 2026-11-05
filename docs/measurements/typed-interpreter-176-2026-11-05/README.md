# Typed interpreter acceptance for Buster #176

Main acceptance source: [Buster PR #1331](https://github.com/buster14a/buster/pull/1331),
`4813ca6fe55ec242e7f796a2e0094ed6c34c9f31`, including main through
`76ad7ebe`. This is correctness qualification, with no throughput claim.
All builds and executions used benchpress's shared `exclusive.sh` lock, one
invocation at a time. The host is a Ryzen 7 9700X, Linux/x86-64; complete host
and tool identities are retained in `logs/`.

Follow-up `abba33f61edda10fc3a51d5c8068bc83e02e3c6c` preserves unresolved weak
function/object addresses as null values without granting memory or a callable
target. It extends the linked-unit fixture and corrects a dispatch comment.
The final build and targeted normal/sanitizer regressions pass, recorded
separately as `final-*` logs; the full C-suite and generator results below
identify their original tested revision rather than being relabeled.

## Current-main integration

Revision `3f2750451ed333940551ffe840e54993b4f5589a` merges main through
`e7d3fc79` and adapts host-symbol lookup to main's static compiler linkage.
A static compiler binds only its own table (including `div` for the aggregate
return fixture), avoiding a second C library through `libgcc_s`.

At this revision the full normal acceptance passes again: all 220 C-suite
programs, all 48 generated C programs, source controls, source/native/unit
fixtures and every suite in `reproduction/acceptance.tests`. The native-bridge
suite now has 48 checks, including the new main tests. The additional linked
weak-symbol checks pass with undefined-byte checking and against Clang, Tier 0
and Tier 1. The call graph reports 42 units, 33,437 functions, 205,002 calls,
zero unapproved cycles and zero split variables. The final DCO audit reports
seven signed commits, zero missing trailers and zero findings.

The final-head bounded seed-176 smoke passes both Csmith and YARPGen: two
cases generated, two passed, and two receive interpreter campaign credit.
Its separate receipt is `campaigns/campaign-ibPPF1`, with all five execution
modes retained. This does not erase any earlier failed seed.

All eight hosted correctness shards pass in [run 42078033414, attempt
2](https://github.com/buster14a/buster/actions/runs/42078033414/attempts/2),
with six successful shards preserved while two stalled Ubuntu-package installs
were canceled and retried on fresh runners. Both self-host configurations pass
in [run 42077674473](https://github.com/buster14a/buster/actions/runs/42077674473).
The native hardware job and local sanitizer repetition remain queued behind
shared-machine CI jobs; they are not reported as complete.

## Earlier acceptance results

| Check | Result |
| --- | --- |
| Direct typed C-suite execution, compared with the three IR forms and expected output | 220/220 programs, 430 functions; zero exclusions or failures |
| Generated C, compared with Clang and the three IR forms | 48/48 programs, 288 functions; zero exclusions, failed builds or disagreements |
| Typed aggregate/variadic/computed-goto source fixture | Pass, including a 520-byte by-value object, a hidden result, a native `div` result, 128-byte aligned variadic data, named stack arguments and ignored libc pointer results |
| Native source fixture | Clang, Tier 0 and Tier 1 give the expected output and successful status |
| Linked typed units | Pass; local-name collisions, shared data, a cross-unit function-pointer relocation, aggregate calls and strong-over-weak selection |
| Default typed interpreter | 865 checks, zero failures |
| Native bridge / Link materialization | 42 / 33 checks, zero failures |
| Shared IR interpreter / IR lowering | 963 / 761,111 checks, zero failures |
| SSA adapter / external differential harness fixtures | 3,797 / 227 checks, zero failures; fixture campaigns receive no compiler acceptance credit |
| Call graph | 42 translation units, 33,409 functions, 204,918 calls; zero unapproved cycles and zero split variables |

The normal build is Release, `BUSTER_DEBUG_INFO=0`, host `native`, with
Clang 23.1.1. The diagnostic build adds `BUSTER_SANITIZER=address` and
`BUSTER_SANITIZER_OPTIMIZATION=1`: AddressSanitizer, UndefinedBehaviorSanitizer
and bounds instrumentation, with leak detection and fatal reports enabled.
Both binaries' SHA-256 identifiers and their exact flags are recorded.

The sanitizer build passes the interpreter, native bridge, Link, shared IR,
lowering, SSA and differential-harness suites, the source-process controls,
16 generated C programs, the aggregate/variadic source fixture and the linked
unit fixture. `sanitizer-tests.log` retains the complete run. No sanitizer
failure is treated as an expected program result.

`test-ir-lowering` runs the production typed consumer on generated integer
aggregate and dynamic-stack programs, alongside its independent fixture
machine, IR execution and Tier 0 native execution. It also runs all five
scalar variadic-frame fixtures through the typed consumer and compares their
values, copies, canaries, named arguments and cursor movement with native
execution. These comparisons execute the original typed streams without an
IR detour.

## External generators

The installed tools report Csmith 2.4.0 (`0cdc710`) and YARPGen 2.0
(`1adb290`). The requested source revisions are
`0cdc710315cfee9035e22ef4363ca479270d1934` and
`1adb290f453505838f3aa33dc571f292b0c1810f`; the installed binaries' hashes
are retained rather than claiming they were rebuilt in this session.
Csmith's matching external runtime headers are not vendored here.

The default Csmith seed 176 completes through Clang -O0/-O2, Tier 0, Tier 1
and the typed interpreter. The two-seed default campaign then times out on
seed 177 under **both Clang references and both compiled Buster tiers**, each
after 120 seconds. The interpreter's run was interrupted to release the shared
host before one invocation held it for ten minutes. The campaign then completes
both YARPGen cases: **three of four cases pass**, and the campaign remains
failed with `clang-o0-run:timeout`. It establishes no result for Csmith seed
177's interrupted typed run.

The bounded follow-up uses Csmith `--max-funcs 4 --max-block-depth 2
--max-expr-complexity 6`, with ordinary YARPGen generation, seeds 176–179,
one program per generator per invocation and a 30-second process deadline.
Each seed's campaign separately takes and releases the host lock. Results and
complete command/configuration/output receipts are retained under `campaigns/`.
Seeds 176, 177 and 179 pass both generators: **six of eight cases pass**. Seed
178's Csmith program times out under both Clang references; YARPGen's program
exceeds the small code model's relocation range when linked by Clang and Buster.
Those two cases remain failures, with zero interpreter campaign credit. The
sample establishes agreement on completed cases, not a wholly passing sweep.
The interpreter runs as `interpret-c`, with each YARPGen source unit separate;
it is not an executable wrapper or a native fallback. Replay configurations
retain `--interpreter` and summaries distinguish interpreter campaign credit.

Csmith's installed binary initially lacked `libbsd.so.0` on benchpress.
Task-local copies of `libbsd.so.0` and its `libmd.so.0` dependency were supplied
from the agent machine's `/usr/lib`, with hashes retained in
`binary-sha256.txt`. `LD_LIBRARY_PATH` is confined to the task scripts; no host
package or global setting changed. These libraries and generator binaries are
not redistributed in this record.

## Retained diagnostic boundary

The older synthetic generator's expanded `test-interpreter --count 256
--seed 176` campaign is not source acceptance. Baseline `41f7eefd` reproduces
64 failed checks with arithmetic diagnostics, consistent with the generator's
already documented out-of-range floating-to-integer/CVTT boundary. Acceptance revision `4813ca6f` also reports 64 failures in the same expanded campaign. The interpreter keeps
its arithmetic diagnostics; no test or detector suppression was introduced.
The baseline log and final diagnostic log are retained separately from passing
acceptance runs. A baseline executable hash was not captured before rebuilding.

## Reproduction and scope

`reproduction/` retains the exact invocation scripts and command inventories.
They use the task's absolute benchpress paths; supply equivalent checkout,
corpus and tool paths when reproducing. C-suite input is pinned at
`5c7275656d751de0e68b2d340a95b5681858ed07`, with the source revision's
`tests/c-testsuite/subset.txt` selecting all 220 programs. The generated-source
campaign uses `test-ssa-source --typed --generate 48 --seed 176 --clang
/usr/bin/clang`.

Campaign receipts omit emitted executables and external generated source/header
files. The generator commands, revisions, input identities and outputs remain;
regenerate the input from those recorded seeds/options before using replay.
These bounded samples do not establish every Csmith/YARPGen configuration.
Source preparation still uses the compiler's existing retained-stream/emission
adapter. Execution itself uses only the typed streams and materialized data,
with registered host-library calls. SIMD machine rows, inline assembly,
frame-address/tail-call intrinsics, callbacks into interpreted code, threads
and signals are not newly qualified here.

Original report, glue and project fixtures use Apache-2.0 WITH LLVM-exception.
External tools and input installations keep their own terms and were used as
oracles/inputs; no third-party implementation is imported by this record.
