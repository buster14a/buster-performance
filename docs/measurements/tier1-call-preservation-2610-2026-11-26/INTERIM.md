# Tier 1 call preservation and frame recipes (#2610), 2026-11-26

Reproduction and validation evidence for [buster#2610](https://github.com/buster14a/buster/issues/2610).
The production review is [buster#3630](https://github.com/buster14a/buster/pull/3630); the separate
measurement-only compiler is [buster#3639](https://github.com/buster14a/buster/pull/3639).

This packet records the original baseline, the folded-frame recipe candidate, and bounded experimental
call-preservation policies. Guarded-policy generated-program validation and compact completed accounting are
included in separate sections/directories so that later candidates can be added without replacing these results.
The compiler identities, source patches and candidate labels distinguish experimental policies from production code.
No experiment is qualified solely by fewer call-save instructions. This is an interim record: no measured policy
is accepted for production, and the policy investigation continues.

## Recorded comparisons

| Mask | Measurement behavior |
| ---: | --- |
| 0 | Exact original baseline, with origin sidecars |
| 1 | Folded-frame recipe discovery correction |
| 2 | Soft caller-register avoidance for nonrecipe intervals crossing a call |
| 3 | Recipe correction and soft avoidance |
| 5 | Recipe correction and resident caller registers for every nonphi crossing recipe |
| 6 | Soft avoidance and broader residency of existing recipes, without the recipe correction |
| 7 | Recipe correction, soft avoidance and broader recipe residency |
| 11 | Recipe correction and soft avoidance requiring two crossed calls |
| 18 | New compiler: soft avoidance with a guard against strict interior multi-entry joins |
| 34 | New compiler: soft avoidance confined to a single basic block |
| 128 | Later compiler: complete physical caller/callee register permutation after allocation |

All eleven listed masks are built and native-verified. Masks 6/18/34 were built with the guarded compiler;
128 uses the later exchange compiler. Their source and results must be read from their own compiler/validation
receipts. Masks 10 and 64 were not measured.

The original measurement compiler's masks **0 and 1 reproduce the complete baseline and recipe-head ELF files
byte for byte** for both programs. This establishes that their tags describe the original generated programs.
Every initial mask passed the frozen SQLite verification hash and all five fixed-seed Lua output comparisons.
Each also compiled the existing frame-address fixture with `--tier1 --verify`: six functions compiled and
code-certified, none uncertified or falling back, and native output equal to Clang -O0.

Compilation coverage is unchanged throughout all eleven masks: SQLite 2709/2709 functions by Tier 1;
Lua 1086/1087, with only the original `luaD_rawrunprotected` unsupported-lowering fallback. Internal and resource
failure counts are zero. `local/static-summary.tsv` preserves the complete static comparison.

The guarded compiler's controls 0/2 reproduce the complete original baseline/soft-only executables and origin
sidecars exactly. It is a merge with advanced main, not the original branch tree: `compilers/guarded/` records
both parents, the exact source difference and the parity evidence. Masks 6/18/34 preserve the same corpus coverage
and pass the same native checks. Mask 18 additionally passes the full emitter suite (257194 checks, zero failures)
and full SQLite `--tier1 --verify`, with whole-ELF/sidecar equality to its measured build. SQLite's emitted-code
certificate coverage is 2351 certified and 74 uncertified, exactly matching a mask-0 control; this is not a claim
of all-function emitted-code coverage. `local/guarded/` holds those reports.

The exchange compiler is a further advanced-main merge, including Tier0 transport changes. Its 0/2 controls
again reproduce the complete original executables and origin sidecars. Mask 128 passes 257194 emitter checks
and full SQLite `--verify`, with unchanged 2351/74 certificate coverage and exact measured/verified ELF and
sidecar equality. `compilers/exchange/` and `local/exchange/` retain its separate source identity and receipts.
This frozen experiment is distinct from a later production-shape refinement of the same map.

## What the rejected candidates reveal

The recipe-only change recognizes a valid missing recipe, and its focused correctness regressions pass.
However, it makes `sqlite3RunParser` recompute a frequently used frame address inside a conditional token loop.
The selected instruction accounting records **574,662 more target instructions** in that function. The relevant
value, intervals, blocks and instruction sites are retained in `diagnosis/`.

Soft avoidance without the recipe change removes much of `yy_reduce`'s call preservation, but increases its
edge and spill traffic. A last handler's long interval includes the shared return block; promotion pressure in
that handler leaves a spilled entry convention at the common return. Unrelated predecessors then store values
to satisfy it. The complete diagnosis, including costs in Lua's interpreter loop and SQLite's hottest functions,
is `diagnosis/regression-2610.txt`. This motivated the later guarded experiments. Both guards also failed the
workload performance criteria: mask 18 adds substantial SQLite instruction/transport traffic; mask 34 reduces
SQLite transport but adds frame traffic and regresses several Lua workloads. Completed normalized summaries and
audits for 0/2/3/6/11/18/34 are in `measurements/`. Mask 6 reduces target overhead relative to soft avoidance
but adds 95,758,716 total SQLite instructions (4.25%) and 43,854,110 union-transport instructions; all five Lua
workloads also regress. Broader recipe residency adds 28,379,766 dynamic rematerialization instructions in SQLite.
`measurements/comparison-vs-baseline.tsv` gives every workload's exact total, transport, call-preservation,
rematerialization and frame deltas. These are rejected experimental outcomes, not a production policy
recommendation. The summaries retain every origin, including frame operations and rematerialization, so reductions
in C/R alone cannot conceal other added work.

The single-block guard's Lua regression is traced in `diagnosis/lua34-diagnosis.txt`. The first changed placement
is the incoming `L` value in return handler B1047. Its last placement then becomes the convention at B1048 and
propagates through later anchor and phi hints into the common fetch path. The trap phi web moves from RBP to RBX
and spills when `pc+4` takes RBX. The added store and reload each execute 3,813,727 times in `calls.lua`, adding
7,627,454 instructions although the neighboring tracing calls do not execute. Selected CFG rows and the exact
instruction sites are retained alongside the diagnosis. Eligibility confined to one block did not confine the
resulting register convention.

Mask 128 preserves the original fragments, spill slots, edge order and register equalities through a complete
physical-register permutation. Its static ordinary spills/reloads, rematerializations and edge moves are exactly
baseline. It reduces SQLite's executed instruction total by 3,248,124 and union transport by 7,726,515, but leaves
`yy_reduce` and `sqlite3VdbeExec` unchanged and increases Lua closures by 4,625,292 instructions. Arithmetic and
calls also add 91 and 144 respectively; strings and tables decrease. The static score charged entry copies once
and estimated call savings, while unconditional parameter-entry copies also execute when a function's cold hooked
call does not. These results do not meet the intended criteria. `measurements/e128/` preserves exact per-workload,
per-function and ABI/call-origin deltas; `diagnosis/` retains the selected closures instruction sites.

The filtered diagnostic instruction counts retain their original total/unmatched headers. Those totals refer
to the complete capture, while the file contains only selected function rows. Do not sum a filtered file as if
it contained the complete program. This packet includes compact completed summaries/audits, not raw captures. During a later executor restart,
the temporary directory containing the complete Callgrind captures and disassembly joins was cleared. Those
original raw files are no longer retained. The recorded results, input/program identities and selected diagnostic
rows survive; fresh baseline/candidate captures are required for the final acceptance comparison.

## Frozen inputs and methods

- SQLite 3.53.2 comes from Buster's frozen `preprocessor-391e729af658` corpus. `speedtest1.c` is fixed to SQLite
  Git commit `ccc132c5be20ab5c755c97a08d06b1b592fef330`.
- Lua is the unmodified 5.4.8 release. `-Dluai_makeseed(L)=0` uses its source-supported hash-seed override,
  removing the address-derived hash variation documented by the older #2553 record.
- The five Lua scripts are fixed to buster-performance commit `818cfbbc0be238da287c16d8e2a91fd7275cf228`.
- The source unit order, one lane, resource-header override, SQLite options and `-fno-asynchronous-unwind-tables`
  match across candidates. `PROVENANCE.md`, `inputs/SHA256SUMS` and the archived scripts contain exact identities.
- Compilers are sanctioned hosted Release vector products with one toolchain identity. Local full compiler
  builds failed under shared-container memory pressure, so no local build-time comparison is made.

The program builds and native checks ran in an Intel Xeon Platinum 8370C cloud container, Linux 6.18.57,
Debian glibc 2.41. Origin instruction counts use Valgrind 3.24.0. These are generated-program instruction
counts and correctness checks; incidental build/test durations are not compiler or program timing evidence.
No 9700X or benchpress resource was accessed.

The format follows the earlier
[#2553 record](https://github.com/buster14a/buster-performance/tree/ddb5213da1fce7ac9325afbf6364a797bbc63b5b/docs/measurements/tier1-dominator-places-2553-2026-11-12).
Its origin tags were adapted without changing the category meanings. `C/R` are call stores/loads;
`S/L` ordinary spills/reloads; `e/h/x` edge copies; `T/t` edge stores; `U/u` edge reloads.
Other categories include argument, prologue/frame, rematerialization, register and jump records.

## Validation and its limits

The corrected recipe-only production commit `4e89739c94b77a76ccedf3c064f2ac4fbc455910` completed hosted
[run 45789038744](https://github.com/buster14a/buster/actions/runs/45789038744) successfully. The API receipt
is in `ci/`. An earlier fixture expectation caused exactly two failures; its correction changed the fixture's
dynamic-frame setup, not the production recipe logic. That earlier compiler generated the recipe-head corpus.

The baseline CI compiler locally passed `test-tier1-emit` with 257194 checks. The local
`test-tier1-pipeline --cross-check` had four pre-existing failures: private-subreaper descendant collection,
detached-grandchild collection, the cleanup deadline, and consequent missing Clang coverage. It recorded
3959 checks and 1088 native results. This packet does not present that local pipeline command as passing.
The exact baseline log is retained; the independent hosted production result is recorded separately.

Focused regression validation is retained under `validation/`: recipe discovery/native frame modes,
experiment gating, soft-policy allocator/CFG/certificate checks, and the later join guard with its failing
unguarded mutation. These focused tests preserve the production algorithm bodies and replace only unrelated
command dispatch in their private harnesses; the construction and exact commands are archived.

`validation/exchange/` preserves the exact frozen128 mapping snapshot: 81 map checks, 62 native checks,
32 executions and six before/after CFG certificates pass without failures or skips. The mutation that retains
an incoming ABI binding fails nine map and two native-emission checks. `validation/exchange-refined/` is a
separate, later unpublished source snapshot: moving the exchange after the order check and retaining the
allocation on optional memory failure passes 81 map and 70 native checks. Its additional failure probes check
unchanged old bytes, structures and arena lengths. Those focused results do not establish corpus ELF equality
between the refinement and the measured128 compiler.

One inspection correction is recorded in the original recipe receipt: an initial section-dump command rewrote
both Lua ELF metadata. Both files were restored from the retained original checksum-verified binary before
accepted parity/control captures. All later section dumps explicitly write their output ELF to `/dev/null`
and verify source hashes before and after. The later instrumented whole-ELF parity gates independently confirm
the original executable identities.

## Reproduction and contents

`scripts/reproduce.sh` accepts the frozen input directory, pinned LLVM bin directory and extracted baseline,
recipe and measurement compiler paths, with optional guarded and exchange products. It makes fresh paired
references at one shared source path, builds the
variants sequentially, checks compiler certificates and native outputs, and records byte/text parity. The portable
wrapper itself was syntax-checked; its constituent commands were executed in the recorded scripts and receipts. Exact
original commands and absolute paths are also preserved under `scripts/recorded/` and `local/`.

Keep Buster and buster-performance as separate checkouts. Acquire external inputs using the immutable locations
in `PROVENANCE.md`; check `inputs/SHA256SUMS` from the input root. Compiler binaries are external hosted artifacts,
identified by source tree, workflow/artifact ID and SHA256 in `compilers.json`; they are not redistributed here.
The same system headers and libraries are required to reproduce the recorded binary hashes exactly. A different
host may reproduce paired comparisons while producing different absolute binary identities.

- `compilers/`, `compilers.json`, `ci/`: source/build identities, original product manifests and CI receipts.
- `inputs/`: input digests, tiny existing fixture/unity source, and reference outputs. Full third-party source is external.
- `local/variants/`, `local/guarded/`: compressed per-function compiler reports and origin sidecars, native output and parity receipts.
- `measurements/`, `measurement-protocol/`: compact completed stable-path summaries/audits and the C accounting helpers/protocol.
- `validation/`: focused harness source, commands, checks and mutation results; no executables.
- `diagnosis/`: compact RunParser disassembly/counts and selected RunParser/yy_reduce CFG rows with source hashes.
- `scripts/`: instrumentation patches, reproduction helpers and the exact original orchestration scripts.

`SHA256SUMS` checks every included file. Original manifests inside compiler or validation receipts may also name
omitted external executables; those remain provenance records. `scripts/import-variant.sh` adds bounded text
receipts for another variant, and `scripts/refresh-manifest.sh` refreshes the packet after further results or final
stable measurement accounting are added. `EXCLUDED.md` records intentional omissions.
Component attributions are in `THIRD_PARTY_NOTICES.md` and `licenses/`.

## Trace-only follow-up and executor restart

The diagnostic compiler at head `7b6f0a5ce11496dbc74732b379a63ef204ca5bf9` changes no allocation decisions.
Its entire SQLite executable and origin sidecar reproduce mask 128 exactly. `compilers/trace/` records the
hosted product identity, exact diagnostic patch, trace, command and parity receipt.

`yy_reduce` supports all 617 calls for exchange scoring. Its only forbidden register is RCX (sequence mask
0x2; fixed and ASM masks both zero). RDI/RSI exchanges with R14/R15 pass the raw live-mask subset condition
but are vetoed by one additional argument shuffle at an individual call: RDI at node 2464, position 4929;
RSI at node 1989, position 3979. The full diagnostic identifies the remaining pairs' subset witnesses.
This is a local-cost veto, not a missing-parameter, unsupported-argument or fixed-register eligibility defect.

An in-progress replacement counts the emitter's actual lazy save/restore epochs and uses uniform successor
probabilities to estimate execution costs. The exact epoch prototype passed 838 focused checks, including
an emitted/certified counterexample to the raw estimator. A subsequent production-shaped API refactor and
shared transition-state helper had not completed recompilation when the executor restarted; no validation
claim attaches that older result to the later source. The isolated frequency core passed 1,100 checks and
converged on the original 1,910-block yy_reduce CFG in 49 sweeps (230,336 bounded work units, all Q32 entry
mass absorbed). Its new arena adapter tests were also pending restored tools. `investigation/` preserves
these sources/logs with their provisional status; they are not an accepted or measured compiler policy.

The restart preserved `/workspace` artifacts but cleared temporary captures and the installed compiler cache.
The original compact measurements remain historical results from the recorded environment. A final candidate
must be compared against a freshly captured baseline in the restored environment, with compressed raw captures
saved immediately after each run. No Benchpress/9700X work was dispatched.
