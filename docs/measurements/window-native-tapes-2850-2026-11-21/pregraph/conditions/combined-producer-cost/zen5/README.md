# Combined predicate producer on the locked 9700X

On frozen SQLite the disabled Release image took 121.5335 ms, the producer retaining the graph took 138.755 ms, and the image replacing eligible operands took 140.444 ms. The replacement added 146.28 total cycles/token and 18.905 ms against the disabled image in the median pair. All five pairs regressed on both measures. The replacement removed 12,466 checker nodes while preserving the native witness and complete ELF. [Paired timings](paired.tsv) · [Object, graph and native witnesses](oracles.tsv)

On Buster's own translation unit the replacement removed 8,168 nodes, took 30.19 ms longer and added 271.53 million user instructions against the disabled build. Against graph retention alone, its median change was +0.918 ms. All modes matched under default and warning-enabled compilation. [Individual samples](samples.tsv)

Each round ran the three independently compiled binaries twice in symmetric order on CPU 2. PMU and true process wall measurements used separate runs. The workload, options, binary checksums, per-run ELF hashes, clock readings and full counter receipts identify the result. The patches match the [local Release experiment](../). [Native receipts and scripts](native-receipts.tar.gz)
