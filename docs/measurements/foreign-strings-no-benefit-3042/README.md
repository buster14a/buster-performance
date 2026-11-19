# Foreign string merging when no pool is smaller

[Issue #3042](https://github.com/buster14a/buster/issues/3042) tracks work at the opt-in foreign linker's string-pooling stage. On 19 November 2026 the same GitHub-hosted Ubuntu 26.04 VM built base `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and head `97cdd5ef0c828e60d890adff6a5aac6ec68adb39` with Clang 23.1.4. The VM reported an AMD EPYC 9V74 and passed the repository's complete AVX-512 probe. The job used `BUSTER_HOST_ARCH=vector`, `BUSTER_SANITIZER=none`, `BUSTER_DEBUG_INFO=0` and `./build.sh --config Release`. The inputs were built once. [Hosted execution](https://github.com/buster14a/buster-performance/actions/runs/44603990535/job/135842685300)

## Work per link

The cells show base → head. The original ELF symbol pass fell from one to zero in both no-benefit workloads. The winning pool kept its original ELF pass over 35 rows and its two Link-symbol passes over 34 and 33 rows.

| Input | ELF symbol rows visited | ELF records read | Arrays | Bytes cleared | Pool bytes copied | Scratch peak (B) | Combined peak (B) | Retained (B) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| libgcc popcount | 4 → 0 | 4 → 0 | 16 → 0 | 68 → 0 | 0 → 0 | 92 → 0 | 141 → 0 | 0 → 0 |
| Buster vector probe | 94 → 0 | 90 → 0 | 16 → 13 | 781 → 464 | 191 → 0 | 1,016 → 880 | 1,696 → 1,368 | 0 → 0 |
| 4,096 ordinary symbols | 4,100 → 0 | 4,100 → 0 | 16 → 0 | 4,184 → 0 | 0 → 0 | 4,196 → 0 | 4,261 → 0 | 0 → 0 |
| 4,096 unique strings | 4,100 → 0 | 4,100 → 0 | 16 → 13 | 77,928 → 32,856 | 40,960 → 0 | 118,936 → 114,816 | 209,117 → 164,036 | 0 → 0 |
| 1-, 2-, 4-byte duplicates | 35 → 35 | 35 → 35 | 19 → 18 | 630 → 615 | 51 → 51 | 1,208 → 1,152 | 1,602 → 1,546 | 394 → 394 |
| Unterminated input | 4 → 0 | 4 → 0 | 7 → 5 | 104 → 88 | 0 → 0 | 124 → 104 | 172 → 152 | 0 → 0 |

This measures work inside one call to `foreign_strings_merge` from the ordinary `link-foreign --merge-strings` command. Each link ran on one lane. The counters cover the adapter, the pool builder and the transaction that applies a winning pool.

- **Symbol rows** counts iterations of the original ELF symbol-map traversal. **ELF reads** counts original symbol records actually fetched after unmapped rows were skipped. A completed traversal across all input objects counts as one pass. The duplicate fixture also traverses Link's symbol table to validate translations and then publish them.
- **Arrays** counts successful array pushes into either arena. **Cleared** counts bytes passed to explicit array or pool clears. **Copied** counts literal payload bytes copied into the prospective pool. These counters exclude automatic local initialization.
- **Scratch peak** measures the largest increase in the scratch arenas' live lengths, including alignment. **Combined peak** measures their largest simultaneous increase with the caller's output arena. **Retained** measures the caller's arena delta on return. The measurements are in bytes and exclude preexisting conversion storage, reserved address space, and process RSS.

The normal driver supplied every object. The small no-eligible case calls the system libgcc implementation of `__popcountdi2`. The real all-unique case links and executes Buster's unmodified `tools/ci/vector-probe.c` with the system startup objects and libraries, then compares its output with GCC's executable. The stress cases add 4,096 exported symbols to an ordinary section or a mergeable string section. The positive case uses the existing `fs_entry` and supported `fs_second` assembly from the repository. A separate input contains a mergeable section without a terminating zero.

The probe has 22 feature labels, two verdict strings and one format string. The 25 distinct, terminated strings total 191 bytes. Both revisions planned 191 bytes. With 4,096 distinct ten-byte entries, both planned 40,960 bytes.

## Output and error behavior

The script compared every complete ELF and program stdout from the clean head and both instrumented builds against the clean base. All comparisons passed. Popcount and both 4,096-symbol programs exited 8. The vector probe exited 0 and matched GCC's probe output. The duplicate program exited 42. Its pool retained the same interior aliases and alignment and occupied 57 of the original 117 literal bytes. The malformed link exited 1 with the same diagnostic and left the destination absent.

`test-foreign --cross-check` passed on both clean builds, including the GNU ld and lld comparisons. The string executable handoff reported 553 checks on base and 563 on head, with zero failures on both. The added checks cover successful empty/unique output descriptors, original size reporting, invalid paths, partial wide units, poisoned outputs and arena marks. The measurements qualify executable equivalence and foreign-linker work. Zen 5 throughput remains unmeasured.

## Reproduction

Use a disposable checkout of `buster14a/buster` on a GitHub-hosted AVX-512 Linux runner with the foreign cross-check dependencies. Keep a checkout of this record alongside it. From the compiler checkout, run the following commands with `record` set to this record's absolute directory.

```sh
git checkout --detach 6427879e1143026a12fb0388a20bdea1fe4b2bc5
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_DEBUG_INFO=0
export PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
bash "$record/harness/compare.sh" "$(mktemp -d)" 97cdd5ef0c828e60d890adff6a5aac6ec68adb39
```

The harness instruments only temporary builds. Its scripts contain the input generation, exact linker commands and counters. The raw output includes the input and ELF hashes, symbol addresses, counted operations and suite results. [Raw measurement output](hosted-results.txt) · [Harness](harness)

---
Agent session: 6aff4faa-f81c-8191-b774-1f83557ea046 (OpenAI Codex session ID, no private session URL exposed)
Model: OpenAI / GPT-6 (Codex)
