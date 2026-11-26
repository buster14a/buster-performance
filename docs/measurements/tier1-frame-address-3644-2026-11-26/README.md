# Tier 1 frame-address placement: correctness evidence for #3644

This record validates [buster#3644](https://github.com/buster14a/buster/issues/3644) and [PR #3656](https://github.com/buster14a/buster/pull/3656). It contains correctness checks and structural live-range counts from a cloud Intel Xeon Platinum 8370C. **It contains no throughput measurements or 9700X performance claims.**

Source base: `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.
Validated head: `b5173a16957f9ff2afff543e869816027a9640aa`.
Repository: `buster14a/buster`, ID `1421805693`.

The change sinks a stable frame address to its sole remaining selected consumer after memory operands have folded. This removes entry-to-late-scope address live ranges from the initialized-buffer reproducer. Truly shared addresses and dynamic stack allocations retain their existing representation. The selected address recipe also supplies the frame-object identity needed by rematerialization.

## Results

| Check | Result | Raw record |
|---|---|---|
| Focused owning address-sink tests, head | 1,031 checks, zero failures; exit 0 | [log](logs/frame-tests-head.run.log), [receipt](logs/frame-tests-head.json) |
| Identical tests over exact base selector/emitter source | 1,029 checks, 46 failures; exit 1 | [log](logs/frame-tests-base.run.log), [receipt](logs/frame-tests-base.json) |
| Full owning selector suite | 1,464,468 checks, zero failures; 5,957 plans, unchanged digest `d15b788da26467e5` | [log](logs/selector-tests-head.run.log), [receipt](logs/selector-tests-head.json) |
| Full owning emitter suite | 258,152 checks, zero failures | [log](logs/emitter-tests-head.run.log), [receipt](logs/emitter-tests-head.json) |
| Original generated source, retained baseline product, 1,536 scopes | Strict Tier 1 refuses with `cause=cfg-allocation error=2` | [log](logs/frame-1536-baseline.compile.log), [receipt](logs/frame-1536-baseline.json) |
| Original generated source, retained baseline product, 8,000 scopes | Same strict refusal | [log](logs/frame-8000-baseline.compile.log), [receipt](logs/frame-8000-baseline.json) |
| Permanent 1,536-scope source test, retained baseline product | Same strict refusal with `--verify` | [log](logs/frame-scopes-baseline.compile.log), [receipt](logs/frame-scopes-baseline.json) |
| Original generated source, head, 64 / 1,536 / 8,000 scopes | All accept strict Tier 1 with `--verify`; all emitted code certified; both read-only and mutating observations equal the compact Clang references | [summary](head-semantic-results.tsv), [64](logs/frame-64-head.compile.log), [1,536](logs/frame-1536-head.compile.log), [8,000](logs/frame-8000-head.compile.log) |
| Permanent 1,536-scope source test, head, rematerialization on / off | Both certify and match the independent 16-case model: `frame-scopes ecbeb1bc52a71b2e` | [on](logs/frame-scopes-head-remat.compile.log), [off](logs/frame-scopes-head-no-remat.compile.log), [outputs](outputs/) |

The full compiler is the verified hosted vector/O3/Release product, whose PR merge source tree equals the exact head tree. At 8,000 scopes it emits 144,004 records, a 40-byte frame, zero spill stores/loads, and zero fallback or resource failures. This is observed generated-code structure, not a runtime-speed claim. All full-compiler observations in [outputs/](outputs/) byte-match their corresponding independent [references/](references/); [runtime-outputs.sha256](runtime-outputs.sha256) preserves their identities. [The run log](logs/head-semantics.run.log) and individual JSON receipts record the successful invocations.

Hosted CI [run 45811955266](https://github.com/buster14a/buster/actions/runs/45811955266) completed successfully. Its four assigned vector/none/O3 correctness jobs, row verdict, integration qualification, static analysis and policy/glue checks passed. [hosted-ci-summary.json](hosted-ci-summary.json) records their job links and actual execution steps; unassigned probe candidates are excluded from coverage. This run selected no sanitizer rows, and its native Benchpress job was skipped. [dco-head.txt](dco-head.txt) records both head commits' sign-off audit with zero missing trailers or findings.

### Live-range growth

The new synthetic fixture runs real selection, effective-use rebuilding, selected CFG construction and interval preparation. The large variants stop before register assignment; the small variants exercise allocation and native output.

| Scopes | Live memberships | Intervals |
|---:|---:|---:|
| 1,536 | 6,146 | 9,218 |
| 3,072 | 12,290 | 18,434 |

Both counts satisfy the permanent `<= 16 * scopes` limits and the doubled-size bound. The observed values are `4 * scopes + 2` memberships and `6 * scopes + 2` intervals. The allocator's existing capacity is unchanged. The base run has two fewer assertions because both large preparations fail before their bounded-count checks.

The 60 new small variants cover copies, pointer-to-integer conversions, indexed and constant-offset addresses, multiple selected uses, phi edges, direct call uses, dynamic stack allocations, and a later-layout dominating conversion reached by the pending traversal. Each uses ordinary, kept-frame-pointer and realigned frames with rematerialization on and off. The 54 stable-frame variants certify emitted code and execute natively. The six dynamic-stack variants retain the already documented `TIER1_CERT_EMITTED_DYNAMIC` boundary; their allocations certify and their generated code executes against the same oracle. The full emitter suite also retains its existing certificate mutation and native execution coverage.

## Reproduction

Use a host that satisfies the compiler's `host_isa.h` requirements, the pinned Clang 23.1.4 toolchain, and the head checkout. `tools/ci/session-toolchain.sh stage` prepares the official toolchain; its output is a PATH prefix. The two scripts write only to their output directories. They do not run benchmarks, change the checkout, dispatch workflows, or use the benchmark host.

```sh
# Run from an exact-head buster checkout; EVIDENCE is this directory.
export BUSTER_VALIDATION_CLANG=/absolute/path/to/clang
bash "$EVIDENCE/run-standalone.sh" "$PWD" /tmp/frame-address-standalone
bash "$EVIDENCE/run-source.sh" "$PWD" /absolute/path/to/head/compiler \
    /tmp/frame-address-source /absolute/path/to/retained-baseline/compiler
```

The baseline compiler argument is optional; its omission skips the expected source refusals. The source script regenerates the original 64-, 1,536- and 8,000-scope subjects, compact independent references and separate observation drivers from [validate1384.c](validate1384.c). It compiles references and drivers separately with Clang `-std=c17 -O2`, then links each Buster object to the same driver without LTO. Each count has 15 boundary/early-return inputs and hashes the full initialized byte observations and call order. It repeats execution with [frame-mutate.c](frame-mutate.c), which changes the first and last bytes after observing the array, so a post-call stale read cannot satisfy the reference comparison.

All head source compiler commands use `--lanes 1 -std=c17 --tier1 --tier1-strict --tier1-report --verify`. The permanent source regression uses those options with rematerialization both on and off, and independently checks 16 inputs including `INT_MIN`, `INT_MAX` and boundaries inside the 1,536 scopes. Its compact reference prints `frame-scopes ecbeb1bc52a71b2e`. Successful head runs must report `compiled=1`, `code_certified=1`, `code_uncertified=0`, `fallbacks=0` and `resource_failures=0` and exactly match the reference output.

The standalone C drivers compile the owning production modules and unchanged test helpers directly at `-O0`. [run-standalone.sh](run-standalone.sh) records every compiler flag. [frame-tests.c](frame-tests.c) invokes the owning focused fixture; [selector-tests.c](selector-tests.c) invokes the full owning selector/emitter suites. The baseline overlay takes only `tier1_select.c`, `tier1_emit.c` and `tier1_emit_cfg.c` from the exact base. Including `tier1_emit.c` ensures its relative include resolves the base CFG emitter. Both builds use the identical current regression fixture; no live checkout files are reverted.

To repeat the permanent fixture's baseline refusal separately:

```sh
"$BASE_COMPILER" --lanes 1 -std=c17 --tier1 --tier1-strict --tier1-report --verify \
    -c tests/driver/tier1_frame_scopes.c -o /tmp/frame-scopes-baseline.o
# Expected: exit 1, cause=cfg-allocation error=2, Tier 0 fallback forbidden.
```

## Identity and provenance

[head-source.sha256](head-source.sha256) identifies all six changed source/test files. [standalone-binaries.sha256](standalone-binaries.sha256) records the three local standalone executables; the binaries are not redistributed. [generated-source.sha256](generated-source.sha256) identifies the reproducible generated sources, compact references and drivers, which are omitted to keep this record small. JSON receipts preserve exact argv, process exit/signal, and Linux `wait4().ru_maxrss` in KiB. RSS accounting is not a timing or throughput result.

The head compiler comes from [hosted run 45811955266](https://github.com/buster14a/buster/actions/runs/45811955266), artifact `15112674205`. Its embedded revision is the PR merge `7352f9e3fd850ead4876474c156ff6eabc803ef6`, whose parents are the original base and head above. The merge/product tree and exact head tree are both `65ddeb08ed3375bb2f2f63d90397d4f8b375d529`; the revision strings are intentionally distinct. The compiler SHA-256 is `eed1c6c1aedca3fc050f38f594ae419fe5d8a79bec740d0aab0bafeb22082ba3`. The artifact ZIP hash is `368346afebcdfa5bfbffd0a43cfa339866903f5cc75b89b91d0c4823f2b6a72b`; the inner product archive hash is `e25678a6f307ab6943a3ee2a619525dba834f2792547eb8b595f1f6ef8d8ee66`. [The verification receipt](head-product/verification.json), [build identity](head-product/identity/summary), [complete manifest](head-product/files.sha256), [all 16 successful file checks](head-product/manifest-verification.txt), and [local ISA probe](head-product/local-vector-probe.tsv) record the qualification. No completed local Release compiler build is claimed: the redundant local build was stopped after this verified hosted product became available.

The retained source baseline is the official unsanitized vector/O3/Release product from run `45779319802`, revision `8e4d32879e17b7d9548cad54257a2f8461328366`, compiler SHA-256 `c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff`. [Artifact identity](baseline-product/artifact.json), [build identity](baseline-product/summary) and its complete [16-file product manifest](baseline-product/files.sha256) are retained. All 16 entries were verified. [Base equivalence](baseline-product/base-equivalence.txt) shows that the relevant selector, CFG emitter, CFG preparation, allocator and lowering modules are byte-identical between that product's revision and the exact source base. The separate standalone red/green comparison uses the exact source base itself.

`validate1384.c` is copied unchanged from the original issue-evidence harness, SHA-256 `c9cba71c389d795e3d4d8052e5d51be0fa3c155ce54db71154621ca882f0089a`. It was original agent-authored work under `Apache-2.0 WITH LLVM-exception`; no external fixture implementation was imported. Standalone helper excerpts come unchanged from the identified base repository and preserve their license notices. `frame-mutate.c`, orchestration scripts and this report are original work in the current session under the same terms. Clang is an external compiler and behavioral oracle; no LLVM implementation is included.

No toolchain binary, large compiler product, target preprocessor snapshot, credential or transient signed download URL is retained here. The full product manifests identify omitted product files. [files.sha256](files.sha256) inventories this evidence directory, excluding itself.

Agent session: `6b081372-0618-83eb-b653-a98a1442107e` (OpenAI session ID; no share URL exposed). Contributing task: `/root/validation_setup`; root and regression-test agents own the code/test changes and hosted product verification. Model: OpenAI / GPT-6 Astra Pro.
