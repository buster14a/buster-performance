# Optional byte-definedness maps in the interpreters

Evidence for [Buster issue 2758](https://github.com/buster14a/buster/issues/2758)
and [PR 3626](https://github.com/buster14a/buster/pull/3626), collected on
2026-11-26. This is cloud correctness and diagnostic timing evidence. No
9700X/benchpress work was requested or run, and these timings are not Zen 5
benchmark qualification.

## Change and deterministic benefit

When undefined-byte checking is disabled, static typed locals, IR slots,
copied aggregate parameters, and variadic anchor storage now omit their
byte-definedness maps. This extends the existing policy for dynamic stack
and native heap allocations. Actual payload initialization, registered
extents, writable permissions, frame ownership, and IR instruction/phi
definedness remain unchanged. Generic copy helpers still propagate maps
when callers explicitly provide them.

An unchecked typed execution omits `16 * max_locals` bytes: 1,048,576 bytes
at the default 65,536-local limit. This is arena allocation/capacity, not a
measured RSS reduction. The regression fixture asserts an exact
16,384-byte difference for 1,024 locals, the same result and four steps in
both modes, successful execution at the unchecked arena peak, and failure
one byte below it. A separate fixture asserts the exact 17-byte saving for
an addressable object. IR fixtures verify absent maps and smaller arena
footprints; their exact footprint differences are not printed measurements.

## Source and product identities

| Role | Revision | Source tree |
| --- | --- | --- |
| Exact baseline main | `8e4d32879e17b7d9548cad54257a2f8461328366` | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` |
| Map implementation | `ba5b06dd13308e6fc37487de12e6fc03ba8ba808` | `5da9f8b1795f916d097ffa18ce22711c4edbe8cd` |
| Maps plain CI merge revision | `76a344a702fa61373e9ac618fd257194e77f2bc0` | `5da9f8b1795f916d097ffa18ce22711c4edbe8cd` |
| Temporary sanitizer workflow | `c3d1b38eba50df2e9d0dc0a4e2231789ddab3407` | `584873dbc58e30e87182b5162e60f9c6b2806f13` |
| Inline follow-up and three-product workflow | `5bf7f27e3e45f21aa80572624677c780c6a5bc6a` | `25105ad00f6acd14471ffba378083285bcf2e543` |
| Final implementation, temporary workflow removed | `96d8cc67c7508146cbb0ea6ef68817c9233b26d9` | `e074f9208ef6fedc080e0998e4f6cb52cb7fbcdb` |
| Final plain CI merge revision | `adf3bb3324ba6b62c98fbaf33c2127e7502566c8` | `47d594aee9aab0437b0d9d182378e00b08ef97d8` |

The first temporary workflow changes no compiler, fixture, or input file
relative to the map implementation. Its source is retained as
`hosted-evidence-maps.yml`. The follow-up adds an inline annotation to the
IR argument helper and retains its three-product workflow separately as
`hosted-evidence-inline.yml`. The final implementation differs from the
tested inline revision only by deleting the temporary workflow; compiler,
fixture, and input sources are identical. `final-source-identity.txt`
records the final commit, tree, and changed-source blob identities.

All products use the official Clang 23.1.4 release, revision
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, Release at O3, and the explicit
vector host target. The product toolchain digest is
`eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.
Sanitizer products use `BUSTER_DEBUG_INFO=0`, `BUSTER_LINKER=lld`, normal
automatic parallel code generation, and the unmodified sanitizer policy.

Baseline products come from successful exact-main run
[45779319802](https://github.com/buster14a/buster/actions/runs/45779319802).
The first plain map implementation product comes from
[45787060080](https://github.com/buster14a/buster/actions/runs/45787060080).

| Product | Artifact ID | `product.tar.zst` SHA-256 |
| --- | ---: | --- |
| Base plain | 15097652285 | `83c4deb352dd5d861287ce0aea6159775aa2b074b4b89886ad28a8871da6f2ef` |
| Maps plain | 15101147294 | `d94b8621e61df7088bb60d4ba71f03ed0f3911062ca513410e9d2774144f50b1` |
| Base MSan | 15098445611 | `c968476b5d82cd0fa7dc15ebc63aba527e8659cbfd1fe889257e47918fd43095` |
| Base ASan/UBSan/LSan | 15097554139 | `aff205c5e15ea0ebaac98cd04f6314895c388b040ba893d483c2db37de0241ad` |
| Base TSan | 15097299102 | `77a78d957e6397a3f8e8b1c3c217f33ee7fd0d13e59d91786c5819811b7d5d4c` |

The plain compiler SHA-256 values are
`c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff`
(base) and
`1938cd23ff80573fca5be03e4ec6d0f3143523191fb78f575ab0f0fc3293a3e3`
(maps). Both products have identical compile-command and compile-flag
manifests. Product identities, complete file manifests, and their verification
logs are retained with the raw evidence. Executable payloads are omitted.

The final plain artifact comes from normal CI run
[45796461739](https://github.com/buster14a/buster/actions/runs/45796461739),
artifact `15104823111`. Its ZIP SHA-256 is
`83dcafd43cca33e1b549f2d3362a5d895eab9ec3aae06df2930f6fb7094dfb96`
and compiler SHA-256 is
`0993aa3ef784489e5e0f6db06782ed20a9266e4f650bfaf863fac7838e2755e2`.
The workflow head is the final implementation above, but the product builds
the listed PR merge revision against main
`5ce76f08c3ce7ed298009437d699bbc9c90471a4`. That merge includes additional
checker/direct-warning changes and their tests/docs. Interpreter and shared
interpreter ABI/type sources are identical to the final branch. This
artifact supports final code-generation inspection; it is not an isolated
same-tree performance comparison with the earlier plain products.

## Plain execution and regression coverage

Run from the implementation repository root with the verified plain maps
compiler, the following commands pass:

| Command | Result |
| --- | --- |
| `test-interpreter` | 927 checks, 0 failed |
| `test-ir-interpreter` | 2,294 checks, 0 failed |
| `test-interpreter-native` | 52 checks, 0 failures |
| `test-interpreter-link` | 39 passed, 0 failed |
| `test-ssa-source --typed --tier1 --self-test` | All execution and native harness controls pass |

The first four commands total 3,312 checks. The change adds 161 checks:
19 typed and 142 IR. They cover checked/unchecked values, partial copies,
bounds, read-only ranges, expired frames, repeated frame reuse, variadic
register/overflow regions, aggregate padding, exact resource boundaries,
and failure rollback. An existing zero-initialization assertion is also
strengthened.

The unchanged c-testsuite input is pinned to
`5c7275656d751de0e68b2d340a95b5681858ed07`. Plain base and maps both pass
`test-ssa-source --typed --tier1 --keep .../00040.c` with four CPUs, three
interpreted forms, and both strict native paths. The per-form steps agree
exactly:

| Form | Steps |
| --- | ---: |
| Memory | 1,350,907,667 |
| SSA | 1,086,721,021 |
| Typed | 1,044,385,698 |

The current source has three interpreter forms; the four-form totals in
the original issue predate the current implementation. No input,
interpreter step, or native comparison is removed by this change.

Plain Release disassembly independently confirms the allocation/store
bypasses. The generic `interpreter_memory_access` routine is 749 bytes
and has the same 209-instruction sequence after normalizing addresses.
Payload stores and bounds/permission checks remain. Clang also outlines
IR argument preparation in the initial maps product, adding a call boundary
on that path. The inline follow-up below addresses this observation;
assembly inspection alone does not establish a speedup. The full symbol-size
table, commands, and disassembly are retained in the local evidence archive.

## First trial: optional maps

The evidence run is
[45790253923](https://github.com/buster14a/buster/actions/runs/45790253923).
Each qualified Ubuntu 26.04 candidate builds a complete head product with
the official hosted setup and proves every enabled sanitizer detector.
It compares one base/head pair for `00040.c` and one for the complete
220-program subset, retaining all three interpreter records and all five
program outputs per case. Candidate 2 uses head then base; candidates 1
and 3 use base then head. Settings, counts, normalized statuses, step totals,
and output hashes must match, and any real sanitizer report fails the run.

Host qualification accepted MSan candidates 1/2, ASan candidates 1/2/3,
and TSan candidates 2/3. MSan candidate 3 and TSan candidate 1 did not
support the complete vector ISA and performed no compiler tests.
All seven qualified candidates completed successfully. Each passed all
3,312 focused checks, source harness controls, 48 generated programs,
24 generated lifetime cases, both complete workload comparisons, and all
real-execution sanitizer-report audits. All three address candidates also
proved the leak detector. Every full-subset execution passed 220/220
interpreted programs and 220/220 native comparisons.

The independent C utility verified all retained pairs: 1,100 matching output
files and 660 matching named interpreter records per full-subset pair,
plus five outputs and three records per isolated-case pair. No full-subset
record was empty. The full memory/SSA/typed step totals are
`1358276690 / 1093063222 / 1050173007` in every product and candidate.

The following table presents baseline then maps, regardless of execution
order. These are single-pair, four-CPU hosted measurements. Full wall,
user and system times, execution order, job IDs, artifact IDs, detector
results, and original ZIP hashes are in `maps-run.json`.

| Sanitizer / candidate | CPU | 00040 wall seconds | Full 220 wall seconds |
| --- | --- | ---: | ---: |
| Address 1 | AMD EPYC 9V45 | 31.400 → 30.971 | 47.489 → 47.182 |
| Address 2 | Intel Xeon Platinum 8573C | 55.928 → 53.375 | 82.842 → 81.376 |
| Address 3 | Intel Xeon Platinum 8370C | 66.241 → 66.040 | 101.356 → 99.168 |
| Memory 1 | Intel Xeon Platinum 8573C | 78.935 → 77.882 | 130.818 → 130.579 |
| Memory 2 | AMD EPYC 9V74 | 119.636 → 124.259 | 154.312 → 156.575 |
| Thread 2 | AMD EPYC 9V45 | 64.807 → 64.693 | 97.819 → 97.945 |
| Thread 3 | AMD EPYC 9V74 | 99.051 → 97.759 | 133.461 → 133.599 |

This trial establishes correctness and identical workloads, not a uniform
speedup. Memory candidate 2 was 3.864% slower on 00040 and 1.467% slower
on the full subset. Thread candidate 2 also used more CPU on 00040 despite
similar elapsed time. The measurements are retained without dropping the
slower results. The fixed allocation reduction is independent of these
variable elapsed-time observations.

## Controlled inline follow-up

Plain assembly shows that the map implementation outlines
`ir_interpreter_arguments`, while the baseline inlines it. The new direct
aggregate-map fixture adds a second caller in the unity product; that and
the helper's small body growth could affect Clang's inlining decision.
The observed outlined path has an 80-byte outgoing argument area, copies
the 32-byte `IrCall`, saves six registers, and reserves 184 bytes in the
callee. These are instructions observed in the plain product, not a cycle
estimate or proof of what caused the sanitizer timing variation.

The follow-up uses the same `static inline __attribute__((always_inline))`
form as adjacent helpers. It changes no algorithm, payload, map policy,
fixture or input. The purpose is to preserve the baseline's inline call
preparation while keeping the new regression fixture.

The final plain product has no `ir_interpreter_arguments` symbol and no
call to that helper in `ir_interpret`: the general argument-transfer call
boundary is removed. The IR dispatcher is 26,463 bytes, compared with
26,703 in the baseline and 26,188 for the initial maps dispatcher plus its
outlined helper. The normalized instruction sequences of
`interpreter_typed_enter`, `interpreter_typed_run`, `ir_interpreter_frame`,
and `interpreter_memory_access` match the initial maps product.

One smaller outline remains: `arena_push_array` is called for 12-byte
`IrPassed` entries in the fallback variadic places array. That path requires
a variadic target and missing call ABI records; it does not run for ordinary
scalar interpreted calls or each interpreter step. This is not a claim that
every new call boundary is absent. The merge-source caveat above applies,
and neither symbol sizes nor these instructions establish a runtime speedup.
Commands and disassembly are retained with
`inline-plain-assembly-findings.txt` in the raw evidence.

Run [45795556535](https://github.com/buster14a/buster/actions/runs/45795556535)
completed successfully and compared three products on each qualified VM:
the exact baseline, pinned maps revision `c3d1b38...`, and the inline
follow-up. It first built and preserved the maps product, then rebuilt the
final head incrementally in the same build directory. All three recorded
configurations matched. Candidates 1/3 ran base, maps, head; candidate 2
ran head, maps, base. Each product ran both complete workloads once,
and final head also ran
all focused regressions. The maps/head source comparison isolates the
annotation from the map policy; the single timing samples do not establish
its stable runtime effect.

Host qualification accepted ASan candidate 1, MSan candidates 1/3, and TSan
candidates 2/3. All five qualified lanes passed. ASan candidates 2/3, MSan
candidate 2, and TSan candidate 1 lacked the complete vector ISA and ran no
compiler tests. Each qualified final head passed the same 3,312 focused
checks, including all 161 added checks, source harness controls, 48 generated
programs, 24 generated lifetime cases, and final sanitizer-report audits.
The enabled detectors were proved on every qualified host, including the
leak detector for the address lane. All three products passed both workloads;
each full-subset execution passed 220/220 interpreted programs and 220/220
native comparisons with the same statuses, output hashes, and step totals.

The independent C utility passed all 20 retained comparisons: base/head
and maps/head for both workloads on each of five qualified hosts. Each
full-subset pair contains 1,100 matching output files and 660 matching named
interpreter records, with no empty record. Each isolated pair contains five
matching outputs and three matching records. All nine original candidate
ZIP hashes and retained content manifests were independently verified.

This table always lists base, maps, head, irrespective of execution order.
These are single-execution, four-CPU hosted wall times. Complete wall/user/
system times, execution order, product hashes, job/artifact identities,
detector proofs, and comparisons are recorded in `inline-run.json`.

| Sanitizer / candidate | CPU | 00040 wall seconds: base → maps → head | Full 220 wall seconds: base → maps → head |
| --- | --- | ---: | ---: |
| Address 1 | AMD EPYC 9V74 | 45.861 → 46.441 → 48.669 | 67.282 → 67.188 → 66.428 |
| Memory 1 | AMD EPYC 9V45 | 53.062 → 55.001 → 51.210 | 83.471 → 84.308 → 82.010 |
| Memory 3 | Intel Xeon Platinum 8573C | 70.087 → 66.518 → 69.604 | 110.521 → 111.041 → 111.771 |
| Thread 2 | AMD EPYC 9V74 | 91.443 → 99.798 → 95.407 | 135.411 → 133.805 → 134.055 |
| Thread 3 | AMD EPYC 9V74 | 89.820 → 90.626 → 91.091 | 134.027 → 133.302 → 135.209 |

The timing conclusions remain mixed. Relative to base, final head is
6.123% slower on isolated 00040 in the address lane, 4.335% slower in thread
candidate 2, and 1.415% slower in thread candidate 3. Both memory lanes are
faster on that case, while full-subset head/base changes range from 1.750%
faster to 1.131% slower. Relative to maps, the annotation also has mixed
results: isolated head changes range from 6.893% faster to 4.797% slower,
and full-subset changes from 2.726% faster to 1.431% slower. These runs
support correctness, identical work, and the fixed allocation reduction.
They establish neither a uniform speedup nor completion of the broader
interpreter-throughput issue, and provide no Zen 5 performance qualification.

## Final normal CI

Normal CI run
[45796461739](https://github.com/buster14a/buster/actions/runs/45796461739)
completed successfully for final head `96d8cc67...`. All 39 jobs were
accounted for: 22 succeeded and 17 were skipped, with no pending or failed
job. The Vector row verdict, Integration qualification, and Coverage record
gates all passed. The Benchpress/Ryzen 7 9700X job was explicitly skipped.
`final-normal-ci.json` retains the complete job inventory and gate results.
Its PR snapshot was taken while the PR was open, unmerged, and draft; a
subsequent ready-for-review transition is outside that snapshot.

## Local environment limitations and corrections

The shared cloud workspace killed official full MSan builds, including a
single-job split-code-generation attempt. A reduced backend-only driver
was also killed during compilation, before linking. Those attempts are
retained as failed attempts and are not presented as test passes.

Local MSan and TSan detector canaries pass. Local ASan/UBSan canaries pass
with leak detection disabled, while LSan's clean probe fails because the
container does not permit its ptrace operation. No container policy was
changed. The hosted sanitizer comparisons retain the full detector policy,
including LSan.

The first local baseline interpreter invocation used the product directory
as its working directory, so one relative fixture could not be found.
Rerunning from the repository root passes all 908 baseline checks without
sanitizer reports. The first local source comparison lacked the relocated
Clang resource directory and could not preprocess `stddef.h`; the recorded
successful comparison sets `BUSTER_CLANG_RESOURCE_DIR` to the official
local Clang's resource directory. These are environment setup failures,
not discarded semantic mismatches. Local wall times are not reported.

The first temporary workflow was rejected before any job ran because a
job-level environment expression used a runner-only context. The corrected
workflow initializes that path within its probe step. The failed validation
run is [45789774590](https://github.com/buster14a/buster/actions/runs/45789774590).

## Reproduction and raw evidence

The two `hosted-evidence-*.yml` files contain exact acquisition, build,
probe, execution, comparison, and retention commands. `compare-results.c` independently
compares retained output bytes and the named `InterpreterResult` fields;
it ignores structure padding and checks both complete and empty records.
The workflow's normalized logs also compare native wait statuses and
coverage. An empty interpreter record alone is not a success assertion.

`local-evidence.tar.gz` retains the initial local checks, product identities,
assembly inspection, detector probes, environment failures and corrected
executions. `hosted-maps-evidence.tar.xz` retains every first-trial candidate,
including unsupported CPUs, with original content manifests, integrity
check logs and the independent result tables.
`hosted-inline-evidence.tar.xz` retains all nine final-trial candidates,
including unsupported CPUs, and all 20 independent C comparison pairs. Its
SHA-256 is
`a636c9fe8d31c9cc5e0968d22cd405092383c9105fd9fdfbed2d1ec3e17f4596`.
Identical file contents are deduplicated with tar hardlinks; all content
manifests were reverified after
deduplication. Archive file timestamps are not timing evidence. The recorded
`time.tsv` files are the elapsed/user/system measurements.

Build and use the independent comparison utility as follows, supplying
the two retained `ssa-source-*` roots and the expected program count:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror compare-results.c -o compare-results
./compare-results BASE_ROOT HEAD_ROOT 220 > records.tsv
./compare-results MAPS_ROOT HEAD_ROOT 220 > maps-head-records.tsv
```

Use program count `1` for the corresponding isolated 00040 roots. The
follow-up has three pinned source revisions: base `8e4d328...`, maps
`c3d1b38...`, and head `5bf7f27...`. Final branch `96d8cc67...` has identical
compiler and fixture sources to that head, with the temporary workflow
removed. After the original hosted products expire, rebuild all three
revisions with the official toolchain and the recorded Release/vector/
sanitizer settings rather than relying on the archived workflow's artifact
download step. Keep the complete 220-case subset, all three interpreter
forms, both native paths, and the four-CPU execution budget unchanged.

All new compiler changes, tests, and this evidence utility are original
contributions. The c-testsuite revision is an external runtime input; its
source is not copied into this record. Existing project tools retain their
repository provenance.

---
Agent session: 6b07eed1-e59c-83ed-acd0-abd2ad40e07b (OpenAI Codex session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
