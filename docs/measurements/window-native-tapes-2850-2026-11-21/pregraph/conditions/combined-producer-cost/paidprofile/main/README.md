# Buster compiler self-compilation

Three symmetric rounds compared three compiler builds. Against the preceding producer the revised producer removed 95.757 million user instructions in all three rounds and reduced paired median elapsed time by 2.5545 ms, with two faster rounds. It still took an additional 22.2565 ms and 156.652 million user instructions against the ordinary reference.

The reference recorded 1,407,402 graph nodes and 86,427 arguments. The combined producer recorded 1,399,224 nodes and 86,348 arguments. Native entries, output object bytes and the diagnostic comparisons matched on Ryzen 7 9700X CPU 2.

[Paired estimates](paired.tsv) · [Individual measurements](samples.tsv) · [Graph and native hashes](oracles.tsv) · [Native receipts](native-receipts.tar.xz)
