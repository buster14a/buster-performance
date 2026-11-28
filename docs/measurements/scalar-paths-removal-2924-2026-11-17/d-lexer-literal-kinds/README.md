# Lexer output for prefixed literals and unknown tokens

This record covers the rare scalar writes after token-kind compression in the normal lexer at cc7d4ffb4. The byte lookup classifies the L, u and U lanes together, overrides u8 from the second byte, uses the quote to select string versus character, and applies unknown and start-of-line masks before compression. The nine-vector deferred source snapshot provides the two lookahead bytes at the end of a chunk.

## Reach in the preprocessor

The unmodified dispatch was instrumented first. Windowing can split a literal and change the number of unknown lanes presented to a single write. The dense input contains 65 of each of the eight named literal kinds.

| Corpus | Default chunks | Prefixes | Unknown | 4 KiB chunks | Prefixes | Unknown |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 26942 | 170 | 0 | 27869 | 170 | 0 |
| sqlite | 19788 | 10 | 2 | 20506 | 10 | 20 |
| musl | 191548 | 3356 | 0 | 199261 | 3356 | 3 |
| dense | 37 | 520 | 0 | 39 | 520 | 0 |

## Source boundaries and token output

Three seeded comparisons each checked 3,600 complete token streams over 90 source lengths and ten input shapes. The unmodified scalar tokenizer supplies the expected token kinds, starts and ends. The source ends at an inaccessible page. A separate 2,560-case test checks the eight named literal classes and two malformed spellings, on every byte lane at two vector boundaries and with both start-of-line states. The expected kinds, spellings and columns were verified by Clang's raw token dump. Changing the UTF-8 kind or suppressing string kinds makes this test fail.

The replay captures real chunk classifications and reuses the identical source vectors and token masks in all implementations. Its checks compare the kind bytes and both independently sized start and end streams. Measurements ran on CPU 2 of the locked Ryzen 7 9700X. Each cell uses the median of nine alternating measurements per seed, followed by the median of the three candidate/parent ratios. Each entry gives the number of cells at least as fast as the parent and the median ratio. Only cells reached on all three seeds enter this table. The archive includes every seed's reached cells.

| Implementation | All nonempty captured inputs | Inputs with a captured prefix or unknown lane |
| --- | ---: | ---: |
| Mask comparisons | 799/859, 0.671× | 501/501, 0.356× |
| Byte lookup | 840/859, 0.627× | 501/501, 0.328× |
| Quote offset | 840/859, 0.636× | 501/501, 0.334× |

| Source shape | Complete tokenizer | All captured chunks | Affected chunks only |
| --- | ---: | ---: | ---: |
| Spaces | 68/90, 0.999× | 89/89, 0.906× | — |
| Ordinary C tokens | 79/90, 0.997× | 89/89, 0.949× | — |
| Wide strings | 89/90, 0.963× | 89/89, 0.148× | 88/88, 0.148× |
| Eight literal kinds | 89/90, 0.964× | 89/89, 0.158× | 87/87, 0.155× |
| Sparse prefixes | 90/90, 0.996× | 89/89, 0.944× | 24/24, 0.630× |
| Unterminated literals | 90/90, 0.994× | 89/89, 0.671× | 89/89, 0.673× |
| Shifted prefixes | 89/90, 0.978× | 89/89, 0.270× | 74/74, 0.205× |
| Similar identifiers and dot-numbers | 73/90, 0.997× | 70/89, 0.957× | 4/4, 0.825× |
| Comment delimiters | 58/90, 0.998× | 58/58, 0.417× | 47/47, 0.416× |
| Mixed lines | 90/90, 0.966× | 89/89, 0.384× | 88/88, 0.384× |

The Release compiler passed the C, C++, raw-string and C99 raw-string lexer suites with 200,000 fuzz inputs on each of three seeds in each mode. The preprocessing oracle passed all 419 fixtures, 128 Clang fuzz comparisons and the 1/2/3/8-lane determinism suite.

## Production preprocessing and lexing

Five paired rounds of three processes per executable measured complete preprocessing in default, whole-file and 4 KiB modes. The outputs and diagnostics matched for every row shown. The final column separately compares three pairs of 21-pass complete tokenizer benchmarks on Lua's sources, the SQLite amalgamation or musl's public headers.

| Corpus | Default -E | Whole-file -E | 4 KiB -E | Complete lexer cycles/byte |
| --- | ---: | ---: | ---: | ---: |
| lua | +0.562% | +0.238% | +0.359% | -0.092% |

[Source changes, census, correctness controls, locked benchmark drivers and raw results](lexer-literal-kinds.tar.xz)
