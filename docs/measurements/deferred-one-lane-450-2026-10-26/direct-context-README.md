# Deferred checker: one lane without affinity calls (#450)

Record date: 2026-10-26. The `31c4ced2`/`e2de00e9` helper comparison completed
and **did not pass performance acceptance**. Correctness and source identity
passed, but positive whole-reader changes persisted. The bounded
`d4db297d` experiment outlined the existing deferred-only phase and also failed
native timing acceptance; its complete results are retained under [outlined/](outlined/README.md).
Neither direct-path experiment is accepted. Further work is assessing the issue's
existing-lane-path alternative. Source-order normalization is not acceptance.

The change runs an adaptive one-lane reading on the calling thread in a saved
one-lane context. It preserves the caller's `Lane` and unfinished `lane_take`
counter, resets the reading's counter, calls the existing lane entry, and
restores both. More than one lane still uses `lane_run` and its supplied CPUs.
The lane-count rule, arenas, body ordering, merge and reader output are
unchanged. `arrived_ns`, `dispatch_ns`, `wake_ns`, `active` and `copies` retain
their existing meanings. The measured dispatch includes the context helper;
it is not replaced with a synthetic zero.

## Exact revisions and builds

| Role | Buster revision |
| --- | --- |
| Initial baseline, diagnostic history | `9de3d30ba437b381394095d7a77635a2e877435d` |
| Initial direct-context prototype | `b14e096a2c72db145143123f4b566da3729ab102` |
| Helper diagnostic before the prerequisite merge | `a4331f3a4ed0eb89e489a8f8fc7ef97ace8c4a86` |
| Final baseline, including #469 | `31c4ced26abcf0393e8c8f4f138e42dfe1952ee4` |
| Final helper candidate | `e2de00e9c0a485c4e13cfd0ff13489b67066fa99` |

The final candidate merges the exact #469 main revision, retaining its private
`enum_fixed` lane state, tag initialization and four GNU23 fixtures. Later
unrelated main revisions are outside this comparison. The initial baseline
and prototype remain diagnostic history rather than a substitute for the
required comparison on top of the overlapping fix.

| Final artifact | SHA-256 |
| --- | --- |
| Baseline source archive (`base450-final.tar`) | `51c7483ad050bae15783dfa32314cc785ed8b5e06310a06006cff155230636cd` |
| Candidate source archive (`head450-final.tar`) | `abd5139e19c0f0a81598b8ec539d22a73bcc705d51bb31fc3f189c467874a624` |
| Baseline `build/compiler` | `2a30c27d0d94cd692a8559ef47f400458021e11f02f32d8848b46254f84ce218` |
| Candidate `build/compiler` | `e899c199ed90a57822aea6d4ce7fb4e315829738ba5de88fbe9c0a5918fc3911` |

Both native builds completed separately from measurements, under the actual
9700X lock. `build-diagnostic.sh` used:

```sh
taskset -c 0,1,3,4,5,6 env BUSTER_DEBUG_INFO=0 OMP_NUM_THREADS=1 ./build.sh
```

The checked-in build uses Clang, `-O3 -march=native -Isrc -fwrapv
-funsigned-char -fno-strict-aliasing -Wall -Werror`, without debug information
for these builds, and selected `/usr/bin/wild`. Its reports show 42 translation
units compiled in 34.1 s for the baseline and 34.2 s for the candidate. Those
are compile-phase preparation times, excluding the link, and are not a
runtime performance result. Exact toolchain versions, CPU settings and
before/after identities belong in the final provenance receipts.

## Inputs and measurement method

The frozen SQLite source is
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`,
SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
The pinned GNU17 predefines have SHA-256
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
The c-testsuite revision used for the pinned corpus is
`5c7275656d751de0e68b2d340a95b5681858ed07`. Final provenance records all
220 source hashes and verifies that the six historical small inputs are the
same bytes as their c-testsuite counterparts. The frozen header manifests
and complete command lines must accompany the logs.

`commands450.sh` invokes each unit in a process of its own:

```sh
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
"$tree/build/compiler" benchmark-checker-deferred \
    --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 \
    --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" \
    --clang-features --no-default-config --target=x86_64-linux-gnu \
    -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$file"
```

Each process preprocesses its input once. Its 24 passes use four complete
cycles of the benchmark's six permutations of source-order, one-lane and
adaptive readings. Each reading therefore has the same preceding-reading
positions. No additional warmup process, discarded timing pass or
`--after-scalar` conditioning was added. A printed `whole` value is the
checker reader's nanoseconds per token; preprocessing, startup and the
separately reported parse are outside that interval. The printed medians are
not 24 independent process repetitions.

The final paired set is eleven units: `00001.c`, `00169.c`, `00213.c`,
`00200.c`, `00182.c`, `00204.c`, SQLite, and the four initial sweep outliers
`00066.c`, `00038.c`, `00075.c`, `00062.c`. Each has five independent process
pairs. The order is baseline/candidate in rounds 1, 3 and 5 and
candidate/baseline in rounds 2 and 4. Each process reports both requested
lane counts, with actual `active` and `copies` values retained.

The sweep contains 219 eligible programs, one independent pair per program,
with build order alternating by program. `00078.c` is an existing
source-order fallback because a body declares something with linkage; it is
included in all-220-program correctness acceptance and explicitly excluded
from deferred timing. The final timing campaign therefore plans 110 paired
processes plus 438 sweep processes: **548 process invocations**.

The coordinator alone schedules native work. The retained initial queue
records completed fixture/corpus acceptance; `resume450-final.sh` and
`batch450-final.sh` perform the corrected SQLite acceptance and final timing
groups. They take the existing `~/buster-fast-bench/exclusive.sh` lock, backed by
`/var/lib/buster-9700x/lock`; `held.sh` records the real owner, command,
timestamps and status. It supplies no private replacement lock. Correctness
commands have separate holds. With the user's explicit approval for bounded
measurement groups, two paired groups cover rounds 1–3 and 4–5, and three
sweep groups cover at most 80 eligible program pairs each. These five
measurement holds each use a 55 s command timeout plus a 1 s forced cleanup
allowance.
Processes within a group execute sequentially. CI and other sessions can
acquire the shared lock between groups. No build or unrelated test runs
during a measurement group. The benchmark pins the calling thread to CPU 2
and its multi-lane team to the documented CPU list.

Before/after provenance records the two binaries and archives, online and
allowed CPUs, Clang version, CPU 2's frequency driver/governor/limits, input
hashes and complete corpus inventory. Record those observed values rather
than assuming configuration from an earlier campaign.

## Prototype diagnosis and the helper

The initial five-round comparison on `9de3d30b`/`b14e096` removed the three
one-lane affinity system calls. Median one-lane dispatch fell from 451–1,253 ns
to 20 ns across the six small cases, and from 6,733 to 120 ns on SQLite.
Single-lane wake remained zero. Nevertheless, SQLite's whole-reader medians
rose by 0.314% on one lane and 0.492% on eight, so the prototype was not
declared accepted.

The source-order control's median also rose, from 102.94 to 103.62 ns/token
(+0.6606%). Median paired changes in `whole/source_order` were −0.3117% for
one lane and −0.2338% for eight. These ratios are diagnostic controls, not a
replacement for raw times or a reason to discard a positive raw delta.

The first sweep had no one-lane increase above 2% among the 62 programs with
at least 1,000 tokens. Its worst positive changes were confined to tiny
programs. The four cases repeated in the final campaign include the largest
one-lane outliers (`00066.c`, +3.48%; `00038.c`, +3.47%) and largest adaptive
outliers (`00075.c`, +4.65%; `00062.c`, +4.24%). Those initial values came
from one process pair and are retained rather than silently discarded.

Exact native disassembly supplied an attributable implementation difference:
`check_deferred_bodies` was inlined into the common `check_input_run`, and
its saved `Lane` enlarged that function's unconditional stack allocation from
`0x808` to `0x818`. Source-order calls use that same frame even when they do
not execute the deferred branch. The lane callback itself was not inlined;
it remained a separate 25,838-byte function in both initial images. The
common function grew by 124 bytes of code. This proves the frame change,
not that it alone caused every timing difference.

The candidate moves the identical save/reset/call/restore operations into
the 89-byte `check_deferred_one_lane` helper, explicitly `noinline`. It adds
one small direct call only on the one-lane path and keeps its saved context
out of the common reader's frame. This avoids changing generic `lane_run`
contracts or adding an affinity query to decide whether affinity work can
be skipped. The final native baseline and candidate both allocate `0x808`
in the common reader; their code sizes are `0x13ae2` and `0x13b02` (+32 bytes).
The final callback is unchanged between those builds. Fresh paired data on
the #469 baseline must decide acceptance; the original diagnostic timing
cannot be carried forward as the final result.

## Correctness and resource validation

Exact `e2de00e9` local validation on the separate 7940HS desktop passed:

| Check | Result |
| --- | --- |
| Focused optimized checker object, production compile flags | Compiled; common reader frame `0x808`, helper `0x59` bytes |
| Focused ASan + UBSan, leak detection enabled, halt on error | 49 fixtures, 772 checks, 480 merged, 6,084 bodies read apart; zero failures or sanitizer findings |
| Fresh exact-source call-graph capture and gate | 42 translation units, 23,569 functions, 139,100 calls; zero disallowed cycles, three existing allowed cycles, zero split variables |

The sanitizer harness uses the existing unity sources with module homes
made static in an untracked copy; it was compiled at `-O1` with
`-fsanitize=address,undefined -fno-omit-frame-pointer`. It exercises the
candidate implementation, not a separately rewritten context algorithm.
`ASAN_OPTIONS=detect_leaks=1:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1` were used. The call-graph gate used the
unchanged existing analyzer against newly captured IR from exact candidate
source, at the build's normal optimization level with LLVM passes disabled;
it did not reuse the prototype's IR or require a duplicate full relink.

The timed 400-body check covers ordinary one-lane and eight-lane readings
and a one-lane reading inside another lane group. The latter has a nonzero
unfinished `lane_take` counter and an unusable CPU pin target. It must merge
to source order's result, restore the original group and counter, perform
no pinning, retain active/copy semantics, and keep dispatch plus wake inside
the lane span. #469's four GNU23 cases remain present and select their own
language standard.

All exact-source local multicore validation entered the installed global `cores`
FIFO and the coordinator's one-heavy-job permit. Compiles/captures requested
two physical cores with a 200% CPU quota; lane tests requested four physical
cores/eight SMT CPUs with an 800% quota. Each scope had an 8 GiB memory cap
and niceness 19, inherited only its granted CPU list and capped linker
parallelism. Long waits were allowed rather than bypassing the queue.
Queued jobs for the older source were cancelled and their ticket removed
before merging #469. The final commands reject changed source before
compiling or testing. Earlier local prototype runs remain historical; the
initial two-CPU fixture scheduling was corrected by an eight-CPU rerun and
is not timing acceptance evidence.

Separate supporting CI commits serialize the test runner with `--jobs 1`,
serialize the external pragma oracle and compiler builds, restrict those
commands and descendants to the established 9700X pool 0–7, and cap
call-graph captures to the allowed core count with a fail-closed positive
budget check. They preserve compiler flags, test commands, timeouts and
benchmark affinities. The CI test-list body and entire benchmark tail are
byte-identical to the `31c4ced2` baseline. The shared resource-guard changes
also appear in the independent #449 branch so that each PR's CI is bounded
before either is merged.

## Helper comparison e2de00e9 — not accepted

The complete `31c4ced2`/`e2de00e9` process rows and summaries are in
`final/rows.tsv` and `final/summary.tsv`. All 548 invocations and five bounded
holds exited successfully, the longest hold was 38 s, and the before/after
identity manifests match. These process-status checks do not negate the
timing regressions.

| Native acceptance | Final result |
| --- | --- |
| Exact candidate `test-checker-deferred` | Passed: 49 fixtures, 772 checks, zero failures |
| All 220 c-testsuite programs, `--deferred 8` | Passed: 220 programs, zero differences |
| Frozen SQLite, `--deferred 8 --symbols` | Passed: one accepted unit, 706,237 tokens, 2,608 bodies; zero deferred, acceptance, path, resource or preprocessing differences. Existing symbols refusal: one unsupported type/operation |
| Before/after source, binary and input identities | Passed: manifests identical before and after all measurements |

The first final SQLite acceptance invocation incorrectly supplied
`--predefines`, which the corpus harness rejects. It processed no source
file, and its failed receipt is retained as an invocation error. The
corrected exact CI corpus command without that option passed. `--predefines`
remains valid for the benchmark command above. The successful native fixture
and c-testsuite runs are reused rather than repeated.

The corrected SQLite acceptance command is:

```sh
head450-final/build/compiler test-checker-corpus --clang /usr/bin/clang \
    --deferred 8 --symbols --no-default-config --target=x86_64-linux-gnu \
    -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
```

The complete linked summary reports all eleven cases at both requested lane
counts, their actual lanes/copies, dispatch/wake and ranges. SQLite's one-lane whole
median is 121.13 → 121.89 ns/token (+0.627%); its paired median change is
+0.594%, range +0.453% to +0.735%. Eight lanes are 105.92 → 106.40 ns/token
(+0.453%), with paired range +0.387% to +0.698%. The source-order control also
rose by 1.504%, while whole/source-order ratios fell; that does not establish
no regression. The 219-program sweep has 39 requested-lane rows above +2%,
including programs with several thousand tokens. The result is therefore
retained as negative evidence, not explained away as tiny-input noise.

The bounded follow-up outlines `check_deferred_bodies` and moves the exact
context operations into that existing phase, removing the separate helper.
Its local optimized common reader shrinks from 80,642 to 49,884 bytes and
from a 0x808 to 0x6c8 stack allocation. It passed the same 772 sanitizer checks
and a fresh call-graph gate. Native correctness and all 548 measurement processes
passed, but SQLite whole medians increased by 1.127% on one lane and 1.072% on
eight, with positive changes in every paired round. This candidate is rejected;
[the complete outlined-phase record](outlined/README.md) preserves its results.
[The static assessment](outlined/assessment.md) records the evidence and limitations;
no padding or alignment heuristic was attempted.

CI/PR submission and merge readiness remain blocked on performance
qualification. No automatic merge is authorized. Milliseconds reconstructed
from printed ns/token retain that rounding label; no numerical gate is
weakened or replaced by normalization.
