# Completing calls in source order

Finishing each callee and its arguments together reduced SQLite’s lean median from 28.513 to 26.995 cycles per taken leaf or lookup. Each of the four paired rounds improved, by 0.605 to 1.985 cycles. The complete pass including the given records improved in every round as well. The 10-cycle gate remains open.

| Input | Mode | Six-op dispatch | Complete call together | Fuse argument visits | Run lookups in postorder |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | whole | 29.33 | 28.2775 | 28.445 | 31.5025 |
| sqlite | lean | 28.5125 | 26.995 | 27.065 | 28.76 |
| lua | whole | 22.735 | 23.7925 | 22.235 | 22.16 |
| lua | lean | 22.33 | 21.8475 | 21.6225 | 20.6675 |
| musl | whole | 20.1225 | 20.185 | 19.3 | 18.16 |
| musl | lean | 19.1625 | 18.5675 | 18.1925 | 16.54 |

All four implementations use live operands for lookup results and the original graph and actions for comparison. The first call variant completes each call before a dependent call can read it. The second additionally combines the visits that inspect an argument and determine its conversion. The postorder variant executes the compact mixed lookup list directly, including immediate scalar fallback, in place of class dispatch. Postorder improved Lua and musl lean medians but raised SQLite’s whole-mode median by 2.1725 cycles within round.

The locked Ryzen 7 9700X on CPU 2 ran four symmetric rotations of four executables. Each process ran five passes. All 192 processes agreed on full record, list, decoy and failure checks, with the original denominator for each mode. The table shows the median of four round means for the kernel after subtraction of the given-record-only pass. The observations include both the aggregate pass and the subtraction. [Builds and patches](builds.tsv) · [Measurements](samples.tsv) · [Paired results](paired.tsv) · [Original output](measurements.tar.xz)
