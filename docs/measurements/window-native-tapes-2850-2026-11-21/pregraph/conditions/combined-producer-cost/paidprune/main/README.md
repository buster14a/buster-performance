# Buster compiler self-compilation

Five symmetric rounds compared five compiler builds. Early ownership checks and parser-range pruning reduced the paired median cost over the reference from 28.4035 ms for the initial producer to 23.4940 ms for the combined changes. The latter still retired 252.401 million more user instructions per compile than the reference.

The reference recorded 1,407,402 graph nodes and 86,427 arguments. The combined producer recorded 1,399,224 nodes and 86,348 arguments. Native entries, output object bytes and the diagnostic comparisons matched on Ryzen 7 9700X CPU 2.

[Paired estimates](paired.tsv) · [Individual measurements](samples.tsv) · [Graph and native hashes](oracles.tsv) · [Native receipts](native-receipts.tar.xz)
