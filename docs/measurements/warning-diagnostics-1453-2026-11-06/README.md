# Declaration-diagnostic warning costs (#1453)

These measurements investigate [buster PR #1453](https://github.com/buster14a/buster/pull/1453) against repaired main on a Ryzen 7 9700X. They are a blocker investigation for one frozen SQLite workload, not a corpus-wide throughput result.

Three interleaved pairs compiled the same source with `-fsyntax-only` using separately locked processes pinned to CPU 2, the same flags and executable path, and `perf stat` for user instructions and cycles. Each event ran for 100% of its measurement interval. The original head and base had the same compiler diagnostics and empty stdout; lock-wait messages in the captured stderr are separate from compiler diagnostics.

| Build | Median instructions | Median user cycles | Comparison |
| --- | ---: | ---: | --- |
| Repaired main `a581e20b` | 1,363,327,409 | 566,173,391 | Original comparison base |
| Integrated diagnostic head `2a50a209` | 1,478,453,340 | 624,702,957 | +8.44% instructions; +10.34% cycles |
| Repaired main `a581e20b` | 1,363,327,818 | 567,625,093 | Confirmation comparison base |
| Reach-pruned head `96d1c2c7` | 1,461,386,139 | 617,774,108 | +7.19% instructions; +8.83% cycles |

The confirmation also consists of three interleaved pairs. For every sample, diagnostics after removing lock-wait messages hash to `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`; stdout is empty. Reach pruning improves this workload but leaves a material increase. The two comparisons were separate batches, so cycle differences between the two head rows are not a paired estimate.

Single-pair controls on the original integrated head yielded base/head 1,179,253,447 / 1,183,483,362 instructions with `-w`, and 1,354,158,709 / 1,448,260,900 with `-Wno-return-type`. Relative to the default pair, these implicate warning-enabled work and approximately 21 million instructions of difference associated with return-type warning analysis for this input. The controls change the enabled diagnostics and are not an A/B replacement or a general causal decomposition.

One instruction-sampling profile each for base, original head, and reach-pruned head pointed to `check_common_emit_run`, `check_driver_common_warnings`, `check_input_run`, and `check_program_return_flow` as places for further inspection. These profiles have about 8,000 samples apiece; percentages are directional, affected by sampling and binary layout, and cannot assign the observed instruction difference precisely. The raw perf captures are retained; their text reports have trailing whitespace removed for repository checks. No optimization is claimed for other inputs or machines.

## Identities and method

- Base commit `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6`; executable SHA-256 `5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04`.
- Original head `2a50a2098904af6f6c4e47b7493e0434571037bd`; executable SHA-256 `8abf5b322ee339e2d27982b84aa566f447d74468e0863ce557b82643a5e085f5`.
- Reach-pruned head `96d1c2c718909dcf920b4f6ef32502012f9fc43e`; executable SHA-256 `64514305582cd07ab1c9588ae835e42116beaa342e2d1c48948850026bb0223a`.
- Frozen SQLite `sqlite3.c` SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Compiler invocations and source location are preserved in the scripts. All tested commands exited successfully.
- Linux `6.18.50-2-lts`, CPU governor `performance`; Clang 23.1.1, Release O3, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`. Builds and each measured process used separate shared-host lock grants.
- Raw `perf stat` files, build/source identities, output hashes, profiling reports, and exact scripts are in [raw](raw/). The candidate was measured first in a separate three-run batch and then in the interleaved confirmation; the latter is used in the table above.
