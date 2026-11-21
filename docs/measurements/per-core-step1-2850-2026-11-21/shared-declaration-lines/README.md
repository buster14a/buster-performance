# Sharing declaration records between uses

This experiment compares direct reads of private per-use records with an index into shared declaration records. A third build expands the shared rows into per-use storage before handing the window to its consumer. The timed complete pass includes the mapping work. Three rounds per corpus and mode rotate the process order then reverse it. The 108 locked 9700X invocations matched on taken identifiers and lookups, with zero record, list, or decoy differences.

On SQLite the lean reference took 26.165 cycles per taken identifier or lookup. Shared rows took 27.980 and materializing them took 30.590. Including preparation, those alternatives cost an additional 0.915 and 2.280 cycles per window record in the paired medians, and lost all three rounds. This result describes the measured shadow layout. [Paired measurements](paired.tsv) · [Builds](builds.tsv) · [Raw measurements](measurements.tar.xz)
