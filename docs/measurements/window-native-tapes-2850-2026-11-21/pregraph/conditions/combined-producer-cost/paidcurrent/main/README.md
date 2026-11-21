# Buster self-compilation

The experimental source-condition producer removed 8,178 graph nodes and 79 call arguments from Buster’s self-compile. Its native stream of 3,906,526 bytes was identical with the producer disabled and enabled. All three executables emitted the same object. The enabled producer added a median 153.188 million user instructions and 19.2635 ms relative to the independently built public compiler. Every round regressed. The paired elapsed range was +19.0195 to +22.2535 ms.

On the same patched executable, enabling production added 142.941 million instructions and 23.413 ms. One producer-disabled PMU round had an elevated fault count that affected its total-cycle comparison. The separate elapsed series was slower with production enabled in each round. Across 4,116 local frozen translation-unit and warning-policy comparisons on SQLite, Lua, musl and Buster, the producer and the public compiler matched status, stdout, diagnostics and objects.

This uses the commands, source and oracle formats from the [SQLite experiment](../). [Graph and native counts](oracles.tsv) · [Paired measurements](paired.tsv) · [Original PMU and elapsed output](native-receipts.tar.xz)
