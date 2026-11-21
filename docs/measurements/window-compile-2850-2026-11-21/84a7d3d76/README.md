# Real opt-in compilation of frozen SQLite at 84a7d3d76

The real `-c --node-window` path compiled 1,507 returns from window rows. It replaced 3,068 ordinary graph nodes with 1,507 summary nodes, a net reduction of 1,561. The resulting graph contained 322,062 nodes. All three builds or modes produced the same 2,061,192-byte ELF object on every measured invocation. Its SHA-256 is efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa.

| Frozen SQLite compilation | User + kernel cycles per token | User instructions per compile | CPU task time, ms |
| --- | ---: | ---: | ---: |
| Parent compiler, ordinary `-c` | 931.74 | 1,341,881,650.5 | 120.46 |
| Candidate, ordinary `-c` | 934.19 | 1,343,670,221.5 | 120.68 |
| Same candidate with `--node-window` | 933.85 | 1,338,659,446.5 | 120.62 |

The paired opt-in minus flag-off median is −0.62 cycles per token across seven rounds, ranging from −4.27 to +1.33. Each round retired fewer user instructions with the switch enabled, with a median reduction of 5,010,775 and a range of 5,009,677 to 5,010,798.5. Against the independent parent binary, the opt-in path used a median +2.11 cycles per token, ranging from −3.21 to +4.64. The full-compile target is 73 cycles per token. This first admission slice therefore establishes reduced work and exact object parity while leaving throughput gains unresolved. [One-core design and budget](https://github.com/buster14a/buster/issues/2850)

## Source and method

The candidate is 84a7d3d76891d6c393497e62e6aff38f2b162fc2 on parent 0647d69ba8af4e466c89df2519dea0b382524d37. The included source.patch reproduces the candidate from this parent and has SHA-256 4c7f8ef6c8d77e8c6a6e94688a68fc5540013315d0e79cb0cadf08fff7e86aae. Release builds used Clang 23.1.4 on Ryzen 7 9700X. The candidate executable SHA-256 is 6c759fbecddbe800f2519a4d161930458ec4b62257c48643e9741afe009a8dfe. The [parent executable](../../tests-holes-2850-2026-11-21/9700x/observed/README.md) has SHA-256 52ca540f809a625561b992dbdd6adb31c1a9393bb0161e9e4be3921f09e21ceb.

The source is the frozen 9,507,037-byte sqlite3.c, SHA-256 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d. The front end reported 716,136 tokens and one lane. The defines and include directory match the [original one-core baseline](../../one-core-design-672-2026-11-12/scripts/baseline.sh). The output file was on tmpfs and removed before each invocation. Three separate stage-instrumented compiles supplied the admission counts and confirmed output parity.

The 42 timed compiles ran on CPU 2 under the shared host lock, twice per mode per round. Odd rounds used parent, off, on, on, off, parent. Even rounds used on, parent, off, off, parent, on. User and kernel cycles and instructions were collected together at 100% enabled time with `perf stat`. Per-mode medians use each round's mean of the two identical mode samples. Deltas are per-round differences of the two means, so subtracting the displayed medians gives a slightly different result.

`pmu.tsv` contains all 42 samples and their output hashes. `process-counters.tar.xz` contains perf output, diagnostics, object sizes and digests, and the three stage reports. The archived perf version returned zero for its duration_time tool event. The table reports perf's CPU task time. The scripts preserve the exact argument lists, mode order, timestamp collection and per-run locking convention.

## Driver coverage

On the development machine, 1,231 tracked C files and 13,880 C fixtures extracted from checker test source ran through ordinary and opt-in driver modes. Each input used `-fsyntax-only` and `-c`, with default warnings and with `-Wall -Wextra`. The comparison checked exit status, diagnostic bytes, standard output and SHA-256 of each successfully compiled object.

| Sources | Pairs | Successful object pairs | Differences |
| --- | ---: | ---: | ---: |
| Tracked C files | 4,924 | 784 | 0 |
| Extracted fixtures | 55,520 | 12,869 | 0 |
| Total | 60,444 | 13,653 | 0 |

The development executable had SHA-256 2da794e2760b9a38c2a9a5bc82d9eea86b35fed0e49ab6159be1dfac6d47f99f and the production source at 84a7d3d76. `driver-parity.tar.xz` contains the path-normalized comparison log for every pair and each campaign summary. `actual-window-check.py` is the local campaign driver.

The same production source at successor 55700f5a4ca30d139fd406bb36dc3ee38adf7ffd also passed 90,000 ordinary/opt-in generated compiler comparisons and 8,009 object comparisons on the targeted probes. The [campaign definitions and receipts](generator-and-probes/README.md) include the comparison modes and exact-byte checks.
