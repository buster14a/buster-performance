# Checking large C initializer tables a window at a time

The source-first reader checked 19 of the Buster compiler's file-scope initializer tables in 955 windows. These declarations contain 773,157 checker nodes. The largest window had 974 nodes. Checking a full declaration previously required a 347,286-node graph for a single table. The largest declaration still handled as a unit has 16,716 nodes. The translation-unit expression graph held zero nodes in both source processes. [Buster partitions](main.partitions.tsv)

| Input | Declarations | Whole-unit checker nodes | Windowed declarations | Windows | Mismatched partitions or declarations |
| --- | ---: | ---: | ---: | ---: | ---: |
| Frozen SQLite 3.53.2 | 7,298 | 323,623 | 0 | 0 | 0 |
| Frozen Buster compiler | 12,518 | 1,407,416 | 19 | 955 | 0 |

The reader recognizes single file-scope initializers with explicitly braced rows. It verifies the parser's brace and comma ancestry, consumes complete rows near a 1,024-token boundary, and emits each row's ordinary value-discard conversions at the declaration terminator. Its per-window graphs are recycled. The independent control first builds and checks the ordinary whole-unit graph, reads back each matching partition, and compares graph, operand, checked value, conversion and effect fingerprints. The verifier also accounts for all declaration nodes and all candidates. SQLite exercised the unchanged whole-declaration path. [Verifier](verify.py), [SQLite source log](sqlite.source.log.xz), [ordinary SQLite log](sqlite.whole.log.xz), [Buster source log](main.source.log.xz) and [ordinary Buster log](main.whole.log.xz)

On the Buster input, Linux mincore found 1,540,096 bytes resident in the reusable graph, 1,814,528 bytes in the checked stream and 94,208 bytes in scratch after all declarations. These counts apply only to those three mappings. The experiment returns after the checker. Its separate whole-unit control produces the reference ELF object. Ordinary compile throughput requires an integrated measurement. [Buster source process](main.source.log.xz) and [object and build hashes](provenance.tsv)

Apply source.patch to the base recorded in provenance.tsv and build with the normal native Develop configuration. windows.patch isolates the change to the prior source-first reader. Run reproduce.py with the compiler, output directory, workload name and the source/flags used by the ordinary compiler. The previous source-first receipt includes the frozen workload revisions, SQLite defines and Buster predefines. [Full source](source.patch), [window changes](windows.patch), [reproduction driver](reproduce.py) and [workload provenance](../4bd73ecaf/provenance.tsv)

A directed follow-up found that this first revision emitted surplus terminator conversions for seven of eight generated declarations. The whole-graph and SQLite/Buster observations above still match on their original inputs. The corrected source checks the intervening declarator before emitting any conversions. All eight independent fixtures and both frozen units matched at that revision. [Corrected implementation and regressions](../22e730966/)
