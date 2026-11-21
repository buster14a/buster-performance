# Packed expression-value chains

The compiler keeps an expression's single graph node directly in its token's head slot. A multi-value list uses an index into a table of immutable head, tail and count triples. The ordinary full-unit experiment removes the dense per-token tail and count columns. SQLite allocated 26,547 multi-value records and the largest table held 32,768 records. The previous pair of columns occupied 5,729,096 bytes.

The source patch in this archive recreates candidate `3a2de3f1000b796d36d34157049b30ebd7ef3357` from Buster `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5`. The separate `a55d1a92c` follow-up restricts tagging to graph capacities below 2³¹ and dense chains for deferred-part readers.

Run `./build.sh` after applying the patch. The same executable uses ordinary chains by default or packed chains when `BUSTER_CHAIN_PACKED=1`. The optional `BUSTER_CHAIN_POISON=1` deliberately dirties head storage for validation. The comparison script uses the compiler under the worktree's build directory. Run `source/chain-suite-packed.py RESULTS_DIR` from the checkout. The script compared 1,282 tracked C sources under five policy combinations, finding identical statuses, diagnostics and successful object hashes for 6,410 pairs. Three inputs exited by the same signal in both modes. The packed checker part 5 passed 210,487 checks and the driver warning suite passed 1,585 checks.

The workstation PMU sample used one pinned core on a Ryzen 9 7940HS with seven alternating-order rounds. SQLite compiled with one lane and the frozen amalgamation SHA-256 was `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The compiler flags and preprocessor definitions match the graph-storage oracle. For ordinary compilation the paired packed delta was −730,096 retired user instructions and −1,715 minor faults. Kernel cycles were lower in all seven rounds. User cycles spanned both signs. All 28 successful native compilations produced the same object bytes.

The per-column page samples and stage reports came from independent invocations. Setting `BUSTER_GRAPH_STORAGE=path` enables those reports and changes the workload.
