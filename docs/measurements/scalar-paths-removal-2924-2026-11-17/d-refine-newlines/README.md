# Preceding newlines across 128-byte token windows

The preprocessor’s refinement pass tests the byte before each token start for CR or LF. The candidate at `0be909471` keeps the compact byte permutation, packs two distant bytes for a two-token group and gathers dwords for three to sixteen distant tokens. This removes the scalar loop on spans greater than 128 bytes. Base is `6ac6c1d5a`. [Compiler issue #3440](https://github.com/buster14a/buster/issues/3440)

## Isolated gate

Nine interleaved rounds ran on CPU 2 of the Ryzen 7 9700X under its exclusive lock, with Clang 23.1.4, `-O3 -march=znver5`. Each call used between one and sixteen starts. The matrix covers seven strides (5, 64, 127, 128, 129, 165 and 4097) and three placements (interior, near the beginning, ending at the input boundary). Both kernels agree with an independently computed mask before timing. Each table entry divides median candidate cycles by median base cycles for an individual cell, then reports the range. [Raw samples](samples.tsv) · [Harness](gate.c) · [Replay script](replay.sh)

| Starts | Cells | Range |
| --- | ---: | ---: |
| 1 | 21 | 0.468–0.957 |
| 2 | 21 | 0.460–0.946 |
| 3–4 | 42 | 0.460–0.953 |
| 5–8 | 84 | 0.432–0.957 |
| 9–16 | 168 | 0.366–0.949 |

An independent replay extracted both kernels from the published Git revisions. All 336 cells passed again, including every wide-span size. [Replay samples](replay-samples.tsv)

The base census reached wide spans in 1,170 of 5,521 SQLite calls, 5,675 of 24,454 Lua calls and 1,017 of 129,078 musl calls. Every wide call had sixteen active starts. The integrated refinement suite passed 560 guarded lookup cases, 20,000 random inputs, 50,570 spellings, 9,600 existing page-edge inputs and 1,171 source files. Guarded fixtures cover both ends of the buffer, 32-bit signed index boundaries and differences in inactive lanes.

## Complete preprocessing

Both executables produced identical stdout and stderr for SQLite, all 34 Lua units and all 1,336 musl units. The table gives each of three rounds’ changes in median user cycles. The control ran the base executable a second time. The first comparison used three runs per executable. Each placement round used six frontend unit offsets (0, 704, 1408, 2112, 2816 and 3520), three fresh executable copies at each offset, and two runs per copy. [Raw driver results, controls and output digests](driver-logs.tar.gz)

| Corpus | Single layout | Single control | Six layouts | Six-layout control |
| --- | --- | --- | --- | --- |
| SQLite | +0.92%, +0.01%, +0.64% | +0.50%, −0.27%, +0.44% | +0.65%, +1.35%, +0.42% | +0.80%, −0.30%, +0.23% |
| Lua | +0.91%, +1.13%, +0.66% | +0.27%, +0.43%, +0.21% | +0.30%, +0.35%, +0.01% | −0.08%, +0.10%, +0.01% |
| musl | −0.01%, +0.42%, +0.23% | +0.01%, −0.14%, +0.46% | −0.11%, +0.01%, −0.14% | −0.02%, −0.12%, −0.02% |

The isolated gate passed all 336 cells. SQLite took more cycles in each placement round, and Lua took more in each original round. The whole-driver gate stays open for this revision.

## Same-binary and standalone follow-ups

The same-binary experiment put the baseline, inline candidate and out-of-line candidate in one compiler. Seven rounds per corpus alternated the order of all three and a second selection of the baseline. The table compares median user cycles on CPU 2 under the exclusive lock.

| Corpus | Baseline control | Inline candidate | Out-of-line candidate |
| --- | ---: | ---: | ---: |
| lua | +0.11% | +0.02% | +0.13% |
| sqlite | +0.68% | +0.06% | +1.20% |
| musl | +0.10% | -0.08% | +0.49% |

Two further standalone builds kept the original output on the three corpora. Screening source chunks for plausible splices increased Lua cycles by 0.64–0.80% and musl by 0.91–1.50%. Restricting lookups to token lanes with continued gaps increased Lua cycles by 0.54–1.08%, with baseline controls of −0.06% to +0.50%. The per-size kernel improvement has yet to clear the whole-preprocessor gate. [Runs, source patches and hardware counters](followups.tar.xz)
