# Cost of producing condition tapes from the source window

These five locked Ryzen 7 9700X rounds compare fresh ordinary compiles of the frozen SQLite source. Each round includes two observations per build in symmetric order. The reference (`off`) uses the ordinary graph. The four other builds pay for the reader-time producer and consume its independent condition tape where the complete root is proven. The scalar native stream, object and diagnostics matched for every build.

| Candidate vs reference | Paired wall difference | Faster rounds | Paired user instructions |
| --- | ---: | ---: | ---: |
| Initial replacement vs off | +19.0350 ms | 0/5 | +158.69 M |
| Restrict type checking to candidate subtrees vs initial replacement | −1.6075 ms | 5/5 | −11.26 M |
| Parser-owned expression boundaries vs restricted type checking | −0.0780 ms | 3/5 | −0.22 M |
| Earlier ownership checks vs parser boundaries | −1.2130 ms | 5/5 | −0.12 M |
| Earlier ownership checks vs off | +15.8600 ms | 0/5 | +147.09 M |

The ordinary graph contains 323,623 nodes and 34,220 argument entries. Initial replacement and restricted checking produced identical 311,157-node graphs. The parser-boundary and ownership cases both emitted the same 310,975-node graph, with 33,720 argument entries. The reduced graph avoided 12,648 nodes, while the source producer cost more time than it saved downstream.

[Paired estimates and ranges](sqlite/paired.tsv), [graph and native hashes](sqlite/oracles.tsv), [timing logs and object receipts](sqlite/native-receipts.tar.xz), [patches and reproduction commands](source-and-builds.tar.xz).
