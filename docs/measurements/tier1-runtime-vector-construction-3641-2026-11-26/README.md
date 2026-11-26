# Runtime integer vector construction — #3641

This record supports [buster#3641](https://github.com/buster14a/buster/issues/3641) and [PR #3658](https://github.com/buster14a/buster/pull/3658).

## Revisions and environment

- Exact baseline: `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.
- Final source head: `3d48a78e9f6ee277c8d041022da296086c6a84f3`.
- Final source tree: `2c883af0541e98986981553d29e5209777c57935`.
- Local host: Linux/x86-64 cloud container, Intel Xeon Platinum 8370C.
- Official pinned Clang 23.1.4, LLVM revision `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`; CMake 4.4.3 and Ninja 1.13.2, staged through the repository's toolchain script.
- Host build: `BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-g0 ./build.sh --config Debug --jobs 1`. The new constructor unit's **output** target is `-march=znver5`; the older scalar-pattern unit keeps its original output target.
- Final hosted PR run: [45815176903](https://github.com/buster14a/buster/actions/runs/45815176903), testing merge `684d208a15e2c3b682c93274458ffda5d2b2aecc`. Its completed result is recorded separately after qualification.

This is correctness and generated-code evidence. No timing benchmark, 9700X access, benchpress job, or hardware dispatch was requested or started. Build-log durations are bookkeeping, with head builds incremental; they are not performance measurements.

The first executor ran out of shared memory and restarted before producing a usable compiler. Patches were recovered and checkpointed. All results here were rerun after that restart using the exact locally built baseline and final head. Earlier exploratory results from another hosted revision are not used.

## Result

Private, fully defined integer vector construction uses existing lane insertion and widening operations. Each runtime lane must come from one intact aligned scalar store; constant and runtime provenance are tracked separately. The pass preserves source SSA values and their effects, refuses escaped/observable construction objects and incomplete or torn lanes, and removes construction stores only when every load has been recovered.

A low scalar followed by zeros is widened directly. Other shapes build independent 128-bit pieces and combine them in a balanced tree. The target-aware C paths enable this representation only with AVX512F/BW/DQ/VL. Ordinary and inlined bodies are covered, including inlining explicitly disabled.

| Constructor | Baseline stack accesses | Head stack accesses |
| --- | ---: | ---: |
| Single scalar + zero tail | 10 | 0 |
| Alternating scalars | 17 | 0 |
| Inlined two-scalar helper + zero tail | 11 | 0 |
| Mixed constants/scalars | 17 | 0 |
| Eight distinct inputs | 17 | 2 |
| First/last runtime lanes | 17 | 0 |
| 8-, 16- and 32-bit lane forms | 13 each | 0 each |

The two accesses in the eight-input case save and restore the output pointer. The matcher permits only an incoming `%rdi` save, a restore from the identical stack address, and the sole output vector store through that restored, unchanged pointer. There are no scalar construction-lane stack stores or vector stack reloads. Every other pure constructor requires zero stack accesses and no call.

The exact baseline passes the independent byte/effect oracle and strict Tier 1 reports but fails precisely nine new constructor shapes. Existing splat and legacy shapes pass. The final head passes all shapes. See `patterns-base.log`, `patterns-head.log`, their assembly captures, and both units' reports.

## Validation

| Check | Final result |
| --- | --- |
| `test-ir-inline` | 128,963 checks, zero failures; frozen digest unchanged |
| `test-ir-sroa` | 23,708 checks, zero failures |
| `test-ir-optimize` | 337,934 checks, zero failures |
| Construction IR matrix | 168 fixtures: four integer lane widths × three vector widths × fourteen forms; 2,808 interpreter executions against independently expected bytes |
| Shared call-descriptor fixture | Three calls share one input descriptor; original, reconstructed and promoted bytes/effect traces agree on six inputs |
| Strict native pattern harness | All four existing-mode × inline-on/off combinations pass; 897 constructor byte comparisons per execution plus effect checks |
| Existing subject report | 38/38 functions compiled, zero fallbacks |
| Constructor report, inline enabled | 15/15 compiled and certified, one inline expansion, zero fallbacks |
| Constructor report, inline disabled | 16/16 compiled and certified, no inline expansion, zero fallbacks |
| #3311 aggregates | 32 functions, interpreter and both strict native paths pass; existing assembly conditions pass |
| Target gate probe | Four runtime forms at x86-64-v3; 256 byte comparisons each with Clang, baseline and head; baseline/head objects byte-identical |
| Shape matcher mutations | Original assembly accepted; wrong saved register, wrong restore slot and EVEX-prefixed stack lane insertion all rejected |
| DCO | Three commits signed; no missing trailers or findings |

The 168-case matrix covers zero tails, alternating and distinct values, mixed constants, reversed store order, whole-lane overwrite, source mutation across calls, volatile reads, torn stores, incomplete definitions, volatile construction accesses, escapes and predecessor-only definitions. Original, reconstructed and promoted functions are compared with an independent byte oracle. Disabled construction preserves the constant/splat cases and refuses the new mixed/distinct path. Output/scratch shortages check rollback and an unchanged result descriptor.

The focused review additionally found that valid IR may share call metadata. The new rewrite now sizes its call table by **call instructions**, because its remapper emits one descriptor per instruction. The dedicated regression keeps a live constant immediately after the table, so the former under-allocation is observable, and checks ordered volatile call effects.

## Lower-output-target boundary

The original `target-gate.c` probe isolates low-lane/zero-tail, alternating, mixed-constant and eight-distinct-input construction. Clang, baseline and head all pass its 256 independent byte comparisons. Both Buster compilers select all four functions strictly, and the baseline/head object hashes are equal.

The **full** constructor unit does not pass at x86-64-v3: both baseline and head encounter the existing `patterns_construct_splat` vector-splitting refusal (`wide`, IR error 12, instruction 3, detail 0). Their diagnostics are byte-identical and retained as `constructors-base-v3.log` and `constructors-head-v3.log`. This record makes no broader v3 support claim.

## Reproduction and artifacts

- `commands.txt`: exact source/build, IR, aggregate and DCO commands.
- `native-commands.txt`: supervisor, per-unit captures, inline-disabled and target-gate commands, plus matcher mutation commands.
- `native-sha256.txt`: compiler, fixture, assembly and target-gate object hashes.
- `source-identities.txt`: exact final tracked-file blob identities.
- `build-base.log` / `build-head.log`: successful pinned-toolchain builds.
- `ir-*.log`: final IR suites.
- `patterns-*.log`, `patterns-*.asm`, `constructors-*.txt` and inline-disabled captures: strict selection, native bytes/effects and code shape.
- `register-aggregates.log` / `register-aggregates.s`: #3311 preservation.
- `target-gate.c`, reports, logs and assembly: lower-target compatibility.
- `shape-check.c`, original/mutated assembly and logs: checks that the narrow pointer exception and encoding-prefix parsing fail closed.
- `dco-audit.log` and API input snapshots: complete three-commit sign-off audit.

The native pattern fixture and IR regressions are committed in the compiler repository at the final source head. The small supplementary target-gate and shape-check probes are original C, retained here. No third-party implementation was imported; Clang is an external oracle.

---
Agent session: 6b081363-0e34-83ed-a298-c8acc059b07f (OpenAI session ID; no share URL is exposed)
Contributing agent threads: 6b0813c5-7aa0-83ed-a3e8-af56a4a38052; 6b0813cf-d8bc-83ed-84cc-51368a9a8056; 6b0813d9-dc64-83ed-846b-d9c5df1cb042 (no share URLs are exposed)
Model: OpenAI / GPT-6 Astra Pro (all contributing agents)
