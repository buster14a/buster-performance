# Fresh SQLite parser-stage timing

Seven independent rounds ran four instrumented ordinary SQLite compilations apiece on Ryzen 7 9700X CPU 2. The starting compiler alternated between rounds, with the order reversed at each round’s midpoint. Every process produced the same complete ELF object. The [per-process times](samples.tsv), [paired stage medians](summary.tsv), [complete stage reports](reports.tar.xz), [object manifest](objects.tsv) and [command](command.sh) record the comparison. The parent directory reports uninstrumented elapsed time separately.

The baseline was 18eca8d81, with seeded precedence windows. The candidate emits reader-visible parameter roles from the current syntax-check block and uses its local classes for the attribute walk.

Each individual instrumented compiler invocation acquired and released the shared hardware lock.
