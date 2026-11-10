# Production build ownership boundaries — 2026-11-10

The final candidate reduces expanded input across the eleven unity units by
**43.6573% for the scalar build and 43.9689% for the vector build**. It removes
2,517 repository dependency edges in each configuration and substantially narrows
the actual Ninja edit plans for preprocessor, executable, source-checking and
backend implementations. **All 86 Release objects and both complete baked
compiler executables are byte-identical to the baseline.**

These are correctness and structural-work measurements from a cloud
**AMD EPYC 9V74** Linux/x86-64 executor. This packet supplies no Ryzen 7 9700X
elapsed-time or runtime-performance qualification. Preprocessed byte reductions
and fewer compilation commands are not elapsed-time speedup percentages.

## Source and build identity

| Item | Identity |
|---|---|
| Source repository | [buster14a/buster](https://github.com/buster14a/buster) |
| Baseline | [`39506e8609750fa31ef5a443dea12f0d545a27c6`](https://github.com/buster14a/buster/tree/39506e8609750fa31ef5a443dea12f0d545a27c6) |
| Measured candidate | Baseline plus [candidate.patch.gz](candidate.patch.gz), identified by [source-inputs.sha256](source-inputs.sha256); no final source commit had been created when these receipts were captured |
| Native compiler | Clang 23.1.4 |
| Build tools | CMake 4.4.3; Ninja 1.13.2 |
| Configurations | Ordinary Release, `BUSTER_DEBUG_INFO=0`, `BUSTER_HOST_ARCH=x86-64` and `BUSTER_HOST_ARCH=znver5` |
| Native build scope | 43 source objects per configuration, including eleven unity units; ordinary static executable configuration |
| Environment record | [toolchain.txt](toolchain.txt), with source and flag inventories in [input-captures.tar.gz](input-captures.tar.gz) |

The source manifest and compressed patch are the candidate's reproducible
identity. The manifest covers 1,023 tracked source/build inputs, including the
new implementations and regression tools. A subsequent source commit must
match those inputs before these measurements are attributed to it. The source
PR may add a documentation link back to this frozen packet after capture; that
link does not change any measured source/build input.

## Change being measured

The preprocessor's public types, declarations and shared readers remain in
`c_preprocessor.c` and `c_preprocessor_history.c`. Private implementations and
tables move into `c_preprocessor_impl.c` and
`c_preprocessor_history_impl.c`. FRONTEND retains the original emitted entry
points and definition order. Its private include closure also owns the literal
evaluator. Standalone PP/files/parser consumers retain their complete source.

`executable.c` retains its shared writer interface, hash helpers and unwind/debug
readers. `executable_impl.c` contains the private layout, patching and output
bodies. DYNAMIC remains the emitted writer's home, and EXECUTABLE retains its
direct tests. The executable, link and snapshot benchmarks retain their
standalone implementation access.

The main include graph now limits source-input and whole-program checking
families to CHECKER; backend/code-generation families to CHECKER and BACKEND;
and shared semantic checker/builtin helpers to CHECKER, BACKEND and
CHECK_BUILTINS. The configured fuzz DRIVER retains its original complete module
access for both the default callback and `BUSTER_FUZZ_ENTRY` overrides.

The change preserves existing entry-point homes and runtime call boundaries,
optimization flags and runtime algorithms. Shared nonowner references preserve
normal warning checks in implementation owners and standalone consumers.
Production ownership assertions, include-closure checks and change selectors
cover the new private paths and the narrowed consumer sets.

## Expanded input and dependencies

The collector obtains the source and compiler-flag inventories from `build.sh`,
adds the same source-prefix mapping used by native CMake object commands, then
uses the selected Clang to preprocess every source with `-E -P` and capture
its dependency file. The unity total sums the eleven `main.c` units; the
all-source total includes all 43 registered compilation inputs in the selected
configuration. Baseline and candidate source inventories are checked for exact
equality. Repeating all four primary captures with explicit prefix normalization
left every per-source byte count unchanged. See [metrics/](metrics/), the
normalization receipt and the complete input archive.

| Measurement | Scalar baseline | Scalar candidate | Scalar reduction | Vector baseline | Vector candidate | Vector reduction |
|---|---:|---:|---:|---:|---:|---:|
| Unity preprocessed bytes | 294,948,285 | 166,181,948 | 128,766,337 (43.6573%) | 296,701,206 | 166,244,882 | 130,456,324 (43.9689%) |
| All 43 sources, preprocessed bytes | 364,063,946 | 235,297,609 | 128,766,337 (35.3692%) | 422,226,502 | 291,782,598 | 130,443,904 (30.8943%) |
| Repository dependency edges | 4,956 | 2,443 | 2,513 net (50.7062%) | 5,221 | 2,717 | 2,504 net (47.9602%) |

An edge is one compilation source depending on one repository path under
`src/`, `tests/` or `tools/`; system-header edges are excluded from this count.
Both configurations remove **2,517 existing edges** across **270 changed
dependency paths**. The three new implementation paths add four scalar edges
and thirteen vector edges, accounting for the difference between removed and
net edges. The exact owner names are retained in the dependency TSVs.

The PP-only proof under [pp-boundary/](pp-boundary/) isolates that component's
contribution and source/object preservation. Its intermediate input totals are
not the final combined totals above. The same distinction applies to isolated
executable and fuzz-boundary receipts.

## Actual incremental edit plans

The C harness starts from a completely built tree, takes the build-tree lock,
requires an initial no-op, changes one existing source's mtime, and captures
`ninja -C TREE -f build-Release.ninja -n compiler`. It restores the source and
requires another no-op before proceeding. It never executes the planned
commands or writes source bytes. The exact compiled source names and raw Ninja
outputs are in [edit-plans/](edit-plans/).

The table contains all thirteen samples. Counts are compilation commands only;
each edited plan also contains exactly one link and one bake/post-link step.
`F` means FRONTEND, `D` DYNAMIC, `E` EXECUTABLE, `C` CHECKER, `B` BACKEND and
`CB` CHECK_BUILTINS.

| Candidate edit | Baseline implementation container or same-path sample | Scalar before → after | Vector before → after | Candidate unity consumers |
|---|---|---:|---:|---|
| `c_preprocessor_literal.c` | Same path | 11 → 1 | 14 → 4 | F |
| `c_preprocessor.c` | Same path, shared-interface control | 11 → 11 | 14 → 14 | All eleven |
| `c_preprocessor_history.c` | Same path, shared-interface control | 11 → 11 | 14 → 14 | All eleven |
| `c_preprocessor_impl.c` | `c_preprocessor.c` | 11 → 1 | 14 → 4 | F |
| `c_preprocessor_history_impl.c` | `c_preprocessor_history.c` | 11 → 1 | 14 → 4 | F |
| `executable.c` | Same path, shared-interface control | 11 → 11 | 14 → 14 | All eleven |
| `executable_impl.c` | `executable.c` | 11 → 2 | 14 → 5 | D, E |
| `c_check_input.c` | Same path | 11 → 1 | 11 → 1 | C |
| `c_check_actions.c` | Same path | 11 → 3 | 12 → 4 | B, CB, C |
| `c_checker_test.c` | Same path | 11 → 3 | 11 → 3 | B, CB, C |
| `ir_dataflow.c` | Same path | 11 → 2 | 11 → 2 | B, C |
| `ir_if_convert.c` | Same path | 11 → 2 | 11 → 2 | B, C |
| `tier0.c` | Same path | 11 → 2 | 13 → 4 | B, C |

All paths above are under `src/buster/compiler/`. The three new private files
are explicitly marked absent in baseline receipts and mapped to the old files
that contained their definitions. The separate shared-interface controls show
that genuine interface edits still select every required consumer.

Vector standalone consumers are preserved exactly:

| Sample family | Additional vector compilation sources |
|---|---|
| PP literal, interfaces and private implementations | `c_preprocessor_benchmark.c`, `c_files_benchmark.c`, `c_parser_benchmark.c` |
| Executable interface and private implementation | `executable_benchmark.c`, `link_benchmark.c`, `snapshot_benchmark.c` |
| Checker actions | `c_checker_benchmark.c` |
| Tier 0 | `tier0_benchmark.c`, `tier1_select_benchmark.c` |

The other sampled edits select no standalone compilation step. Scalar plans
have no standalone step for these samples. Every initial/restored control in
all four runs was a no-op; there were no unexpected commands. Source contents,
inode, size, mode and nanosecond atime/mtime were checked and restored. ctime
changes as required by the timestamp operation. Compiler hashes remained
unchanged, and the harness released its locks before further validation began.

## Release output preservation

Both ordinary native builds completed successfully. Every one of the 43 objects
in each configuration is byte-identical to its baseline counterpart, and the
complete baked compiler executables match as well. The per-object comparisons
and compiler SHA256 receipts are under [objects/](objects/).

| Configuration | Shared baseline/candidate compiler SHA256 |
|---|---|
| x86-64 | `c8ec3987c2df856b80140bfb4edff4c3cb27f917fae14095fe8fb40a78785be6` |
| znver5 | `015b2b5cbaad2b14de61d9ab91983895143953aea032d610beb3e96106439d14` |

The PP definition audit independently verifies that all 563 original functions
and 27 original data definitions occur exactly once with identical bytes;
438 definitions moved, and there are zero mismatches. The additional nonowner
reference bridge is identified separately. The isolated FRONTEND object audit
also retains per-function and full-object comparisons. These checks preserve
the recorded Release outputs and definition contents; other configurations
have their own validation scope below.

## Validation status

| Check | Recorded status and scope |
|---|---|
| Scalar/vector Release builds | Passed; 86 matching objects and two matching complete executables |
| Ordinary ownership-only regression | Passed in both selected Release configurations |
| Change-selector self-tests | 1,716 checks, zero failures |
| Final ordinary vector syntax | All eleven integrated unity units passed with `-Wall -Werror` |
| Incremental plans | Baseline/candidate scalar/vector passed, including restoration and no-op controls |
| Existing full incremental workflow | Both configurations passed all 96 exact-dependent cases, publication/JSON checks and the actual model-unit-only compile/link/bake |
| PP definition preservation | 590 original definitions preserved exactly once; zero mismatches |
| Executable definition preservation | All 164 original functions preserved exactly once; 151 private and 13 shared |
| Configured fuzz boundary | 22 scalar/vector unity syntax checks, custom-callback syntax, native DRIVER compilation and dependency/ownership checks completed; see [fuzz-boundary/](fuzz-boundary/) |
| Debug | Complete vector Debug build and bake/canary passed; selected Debug ownership gate passed |
| Runtime commands | Fifteen correctly invoked checks passed, covering parser/PP, writer/dynamic output, checker requests/builtins, IR, Tier 1 selection/masks and source preparation |
| Production call graph | 43 translation units; 36,668 functions and 228,067 calls; zero unapproved cycles, three existing allowed cycles, zero split variables |
| Full fuzz executable link/run | Not performed; the checks above do not establish this result |

The full incremental workflow is invoked through a small evidence-only C
adapter around the unchanged `check_incremental()` function. The vector tree
contains both Release and Debug. After the workflow, Debug needed only its
filtered compilation database refreshed; the separate recovery receipt shows
exactly that metadata output and no compilation/linking. A later configuration
operation again made that database stale. The initial ownership refusal and
the exact metadata recovery are retained alongside the passing final Debug
ownership receipt. Native outputs remained unchanged.

The runtime record preserves an initial invocation mistake: `test-parser
--mutations 20` requires an input file and returned a usage failure. The correct
default `test-parser` invocation then passed. This was not a candidate parser
failure. The separate original `fixtures/source-probe.c` exercises BACKEND's
external checker preparation entry with scalar and vector functions; all three
functions were prepared, with zero failed/refused/disagreed results.

Debug always retains `-g` in this build system even with `BUSTER_DEBUG_INFO=0`,
which controls Release. Its source paths and relocated definition coordinates
therefore differ between checkouts; this packet makes the byte-identity claim
for the two Release configurations only. Debug validation is build, bake and
ownership validation.

Approved 9700X clean/incremental build timings and runtime-performance
qualification remain outside this cloud packet. Ordinary elapsed times in
development logs, if retained, are diagnostic observations only.

### Development corrections retained in the record

The first integrated source-pruning link identified DRIVER's external IR scan
counter and baked BURS tables, which had been excluded along with unneeded
kernels. The final code retains those original data definitions at their
original homes and positions. An integrated vector compile then exposed eight
shared PP helpers whose former callers were excluded; explicit references in
the existing nonowner bridge preserve the intended diagnostic policy. Both
initial failure logs are retained under `validation/development-*`; the final
builds, all 86 matching objects, runtime checks and call-graph proof follow those
corrections. No ordinary optimization or diagnostic setting was relaxed.

## Preventing dependency growth

The source change extends production ownership assertions to the private PP and
executable implementations and to source/checker/backend consumers. The checks
reject missing or wider owners, unknown or duplicate owner names, missing
fixture classifications, and changes to approved shared structures. Standalone
preprocessing verifies private entry points remain available without a unity
selector. Fuzz access is selected from the actual configured build cache, so
ordinary builds do not gain an extra owner accidentally.

The selector tests follow canonical literal include paths through the newly
extracted implementation files. The edit-plan evidence includes both the
narrowed private implementation paths and broad shared-interface controls.
Future changes must update these explicit ownership contracts deliberately;
new literal includes cannot silently broaden the protected consumer sets.

## Packet layout and reproduction

| Path | Contents |
|---|---|
| [metrics/](metrics/) | Final before/after expansion and dependency summaries and exact dependency-owner TSVs |
| [objects/](objects/) | Release build/object comparisons and complete compiler hashes |
| [edit-plans/](edit-plans/) | Four actual Ninja plan runs, comparison table, source-restoration journals and method notes |
| [validation/](validation/) | Ownership, selector, integrated syntax, full incremental workflow and Debug/runtime/call-graph receipts |
| [pp-boundary/](pp-boundary/) | Isolated PP definition and object-preservation proofs with their own scope notes |
| [executable-boundary/](executable-boundary/) | Isolated executable split review and preservation evidence |
| [fuzz-boundary/](fuzz-boundary/) | Configured/default/custom fuzz source-access checks and explicit limits |
| [tools/](tools/) | Original C capture, comparison, edit-plan and proof helpers |
| [input-captures.tar.gz](input-captures.tar.gz) | Baseline/final scalar/vector captures plus the separately identified isolated PP captures: dependency files, NUL source/flag inventories and per-source totals |
| [source-inputs.sha256](source-inputs.sha256), [candidate.patch.gz](candidate.patch.gz) | Measured candidate input identity against the pinned baseline |
| [toolchain.txt](toolchain.txt) | Executor and external toolchain identity |
| [PROVENANCE.md](PROVENANCE.md) | Source relocation, existing generated-data terms and external tool/input distinctions |
| [commands.txt](commands.txt), [SHA256SUMS](SHA256SUMS) | Reproduction commands and the complete packet's content manifest |

Reproduce from separate baseline and candidate Buster checkouts with the recorded
toolchain and configuration. Decompress and apply the candidate patch to the pinned baseline,
verify the source-input hashes, and use each checkout's `build.sh` to obtain the
source/flag inventory and build the two ordinary Release configurations. The
original C collectors then repeat preprocessing/dependency capture and compare
matching source inventories. Compare every object and complete compiler by
SHA256. Run the incremental harness only after each selected tree is a no-op;
its README records the exact invocation, locking and timestamp-restoration
contract. Each proof helper documents its own arguments and retained inputs.

Large object binaries, expanded `.i` files, toolchain archives and system-header
contents are not needed in this packet: hashes, dependency records, source
identity and original reproduction tools retain the relevant evidence.
