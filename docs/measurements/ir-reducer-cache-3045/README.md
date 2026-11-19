# IR reducer observation-cache work

The structural reducer in `buster14a/buster#3045` now follows successive bits of the existing 64-bit candidate hash to find a cached observation. The stress reduction visited 97.2% fewer cache entries. The 342-instruction scheduling function visited 28 entries on base and 16 on head. The measurements count work in the `reduce-ir` command.

| Input through `reduce-ir` | Candidates tried | Entries visited, base → head | Full-key comparisons, each | Predicate runs, each | Cache hits, each | Cache bytes used, each |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Buster `test_deal_makespan`, verifier injection | 6,852 | 28 → 16 | 0 | 8 | 0 | 57,595 |
| Buster `test_deal_memory_fits`, verifier injection | 312 | 1 → 1 | 0 | 2 | 0 | 2,445 |
| Generated arithmetic chain, memory injection | 2,379 | 210,404 → 5,957 | 128 | 649 | 128 | 4,166,606 |
| Same chain, 1 MiB tool budget, verifier injection | 11,178 | 210 → 59 | 0 | 20 | 0 | 128,654 |

An entry visit reads an occupied node. A full-key comparison calls `memcmp` after the 64-bit hash and serialized length match. Predicate runs include the original observation and every admitted cache miss. Each published bundle also passed an independent predicate replay, which bypasses the cache. Candidate counts include edits rejected before observation.

## Inputs and results

- `inputs.sh` asks Buster to print the promoted IR of two functions from its production test scheduler, `src/buster/compiler/test_deal.h`. Base and head emitted byte-identical inputs. The larger function has 37 blocks and 342 instructions. The smaller has nine blocks and 53 instructions.
- Neither scheduling function reproduced a natural optimizer failure on the supplied arguments. With default zero arguments and a 5,000-step limit on the 17 checked-in optimizer before-fixtures, 12 returned `IR_REDUCE_NOT_FAILING` and five returned `IR_REDUCE_ORACLE_UNAVAILABLE`. The archived #733 reproducer also uses an injected observation. The positive reductions here use the reducer’s existing explicit injections.
- `stress.c` writes 128 constants and dependent additions. The sum determines whether an unsigned division is defined. The following volatile store supplies the memory-observer injection. Lowering any individual live constant makes the original execution unavailable, and repeated simplification choices revisit exact keys. Both builds reduced 267 instructions to 265 in 2,379 tries, executed 649 distinct observations and reused 128. The reduced text has SHA-256 `92c1cfb2fad6dd366bfff1b9b76069c4d048bdee0f5e8b74b7779c52bf536e36`.
- The 1 MiB command-line budget gives the cache 131,072 bytes. Both builds stopped at candidate 11,178 after 20 recorded predicates and 128,654 cache bytes. Both published the same 266-instruction partial result, SHA-256 `240e2ba32797e240147ec0e265d45d28836ef442744d518a9ea6e9581703e168`. The verifier injection isolates this boundary from the interpreter’s own memory requirement. A separate run with argument 1 made the first predicate unavailable and returned exit 2 with no bundle.
- The private collision fixture gives two different byte strings the same full hash and length. It checks rejection one byte short, exact-fit insertion, the restored scratch mark, and reuse of the saved observation after the cache is full. The cache entry has a 48-byte header on both revisions. Each key immediately follows its header. The space previously occupied by the stored key pointer holds the second child pointer.

## Verification and reproduction

Base `b847801169f2b73aed6496c8fa23e9a5499c94e7` and head `d9eb19fb7c2260c20ed46105f5b7bf578365f07e` ran on one GitHub-hosted Ubuntu 26.04 AMD EPYC 9V74 VM after the repository's complete AVX-512 probe passed. Both used Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2 with the plain vector Release configuration. The two `print-compile-flags` outputs compared byte for byte, SHA-256 `d5a902986d56adaa6813f7f4a369c9458a8e6b274188dfbcbe0402ba30483aff`. The default `test-ir-reduce` passed 231 checks on base and 232 on head. With seed 733 and 64 generated cases, it passed 287 and 288. [Hosted comparison](https://github.com/buster14a/buster-performance/actions/runs/44614176144/job/135878318768).

From a disposable compiler checkout and a sibling checkout of this measurement repository, run

```sh
git switch --detach b847801169f2b73aed6496c8fa23e9a5499c94e7
bash ../buster-performance/docs/measurements/ir-reducer-cache-3045/run.sh d9eb19fb7c2260c20ed46105f5b7bf578365f07e
```

Each revision runs clean first. The driver then applies that revision's temporary counter patch and repeats the CLI cases. It compares exit statuses, diagnostics, canonical original and reduced bytes, and all manifest fields apart from compiler identity and source revision. The instrumented runs also compare the ordered sequence of observation hashes, key lengths, acceptance of the lookup and complete predicate outcomes. `run.log` contains the feature probe, compiler identity and workload output from the successful hosted job. No wall-clock performance measurement was taken.

Recorded by OpenAI Codex session `6aff4fff-8d60-8191-a1e0-ea9d8084004a`, OpenAI / GPT-6 (Codex).
