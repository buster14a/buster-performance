# Tier 1 jump threading on wide phi joins

Buster `main` at `6427879e1143026a12fb0388a20bdea1fe4b2bc5` searches a phi backward for each eligible conditional predecessor. With one phi and N distinct reachable conditional predecessors, the measured lookup loop inspects N(N+1)/2 incoming predecessor keys. Commit `6af2ca0d196e49c2cd7f593b742dc31ef92660cd` indexes each wide phi once. Its first phi reuses the CFG successor storage after reachability. A second or later phi stores its values in the first phi’s predecessor order.

## Verified fixtures

Each comparison in a chain tests the parameter against a distinct integer. Every predecessor can enter the same join, on alternating true and false branch arms. The verifier accepts both the input and the output. In the single-phi case every predecessor redirects in one round. A second variant reverses the order of its second phi, keeps one undecidable edge, permits a collapse and forwards the second phi through a successor phi.

| Conditional predecessors | Base pairs scanned | Head pairs indexed | Head direct value reads | Base peak scratch bytes | Head peak scratch bytes |
|---:|---:|---:|---:|---:|---:|
| 32 | 528 | 32 | 32 | 4,420 | 4,420 |
| 64 | 2,080 | 64 | 64 | 7,748 | 7,748 |
| 128 | 8,256 | 128 | 128 | 14,020 | 14,020 |
| 256 | 32,896 | 256 | 256 | 26,564 | 26,564 |
| 512 | 131,328 | 512 | 512 | 51,652 | 51,652 |

Counters increment inside the reverse-search loop, the index construction loop and the indexed lookup. A direct lookup of the first phi reads the value at its known position. The base and head both perform the pass’s ordinary reachability, escape and rewrite work. Peak scratch is `Arena.peak - entry_length` measured around `ir_thread` alone, with the prior high-water mark preserved across the measurement.

The 512-way two-phi fixture took 394,497 search visits on base. Head visited 1,024 pairs building the index, made 1,536 direct lookups and inspected 513 pairs in the successor’s unindexed small phi. Peak scratch was 51,648 bytes on base and 57,856 on head. The raw rows include widths 2, 31 and 33 and both phi arrangements. [Fixture counts](fixtures.tsv)

## Frozen SQLite compile

The single-lane `--tier1 -c` compile of the repository’s frozen `sqlite3.c` (SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`) made 2,668 calls to the threading pass. The compiler reported 1,389 emitted Tier 1 functions and zero fallbacks. Across all rounds there were 16,611 visits to phi-bearing blocks, 4,797 shape candidates and 146 candidates where at least one conditional predecessor was evaluated. Their fan-ins 1 through 6 occurred 35, 55, 28, 23, 1 and 4 times respectively. Twelve phi-block visits had fan-in at least 32, three each at 33, 43, 105 and 156. All twelve failed the threading shape check. Both revisions made 4,418 lookups and inspected 11,487 pairs. [Fan-in distribution](sqlite-fanin.tsv) · [Pass totals](sqlite-operations.tsv)

The harness used `diff` on all 16 printed fixture outputs and `cmp` on all changed SQLite threading results in function order, including the per-function threading decisions. The SQLite transformed IR was 21,063,085 bytes, SHA-256 `e53ace79e8fcd8746c1fe977d360185c80df2351f8b4eeea5e59e13b6a70457a`. The emitted `.text` and the complete ELF object also compared byte for byte. SQLite `.text` contained 1,502,792 bytes. Its SHA-256 was `be8dd68aabdda5b1c4ae3d02d0556ddf3123dc1cf5df336330dc37d0cd6e0d74`. [Output hashes](outputs.sha256)

## Runs and reproduction

The paired compile and MSan ran with Clang 23.1.4 on a GitHub-hosted AMD EPYC 9V45 `ubuntu-26.04` runner after the repository’s complete AVX-512 CPU and OS probe passed. The normal uninstrumented `test-ir-optimize` and the uninstrumented native Release MemorySanitizer build each passed 290,998 checks. The fixture sweeps the scratch capacity through the allocations of a 32-way two-phi join and checks rollback of the result and arena lengths. [Paired outputs and MSan](https://github.com/buster14a/buster-performance/actions/runs/44601454605) · [Uninstrumented commit](https://github.com/buster14a/buster-performance/actions/runs/44601776268) · [Captured IR, objects and logs](https://github.com/buster14a/buster-performance/actions/runs/44601454605/artifacts/14567968815)

The workflow and its four patches are pinned in the [experiment revision](https://github.com/buster14a/buster-performance/tree/b64ad8523dcb49bfcf0945f6dfbecf9b11521539/docs/measurements/ir-thread-phi-2026-11-19). From a clean Buster checkout at the base commit on a qualifying GitHub-hosted runner, `bash /path/to/record/run.sh` reproduces the paired measurements. `RUNNER_TEMP` must name a writable temporary directory. It uses the published input archive and the repository’s pinned toolchain.
