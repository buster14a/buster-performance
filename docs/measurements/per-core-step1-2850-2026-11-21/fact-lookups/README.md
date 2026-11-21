# Body-window leaf and lookup costs on f4f8dd9a1

The current reference and both experiments matched the checked records, the independently reconstructed lists and the decoy tests on all three inputs in both modes. Neither experiment reached the 10-cycle Step 1 gate. SQLite's lean reference measured 28.95 cycles per taken leaf or lookup across these runs.

| Input and mode | Reference | Staggered class lists | Combined member row |
| --- | ---: | ---: | ---: |
| SQLite lean | 28.950 | 29.365 | 30.455 |
| SQLite whole | 30.415 | 30.520 | 31.065 |
| Lua lean | 22.345 | 22.795 | 22.875 |
| Lua whole | 23.070 | 23.360 | 23.230 |
| musl lean | 19.455 | 19.620 | 19.765 |
| musl whole | 20.490 | 20.650 | 20.265 |

The staggered layout chooses an odd number of cache lines between class lists when the window allows. The member variant indexes a combined type and member result by operand type, member name and operation, and checks the source position and operand standing on each use. Its cache only operates in the after-pipeline shadow. The positive musl whole result did not carry to the other cells.

Each table cell is the median of three round means on Ryzen 7 9700X CPU 2, with two run positions per variant per round. All 108 measurement processes ran the existing five-pass body-window benchmark. The benchmark reports the difference between running each window with and without the fact kernel, normalized by taken leaves and lookups. SQLite had 2,918 windows of at most 384 records. The three inputs and exact build revisions are recorded alongside the results. This experiment measures a shadow stage.

[Paired estimates](paired.tsv), [per-process results](samples.tsv), [native output](measurements.tar.xz), [build hashes](builds.tsv), [list layout](stride.patch), [member lookup](members.patch) and [measurement command](facts-batch-pair.sh).
