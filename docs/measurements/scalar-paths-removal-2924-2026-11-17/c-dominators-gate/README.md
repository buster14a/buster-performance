# Dominators' gate (#2924, C4): main `aa09d1a04`, the three paths

Before deleting a path, its gate: on the 9700X, does any AVX-512 path beat SEMI-NCA and the scalar loop bodies?
Main's Release build (`aa09d1a04`; `dominators.c` is the same through `295417ae7`), every run under the lock on CPU 2
([`gate.sh`](gate.sh)):
- `test-ir-source --dominators-cfg` exported sqlite3.c's 7,806 CFGs (2,602 functions, three forms each);
- `benchmark-dominators --cfg` on them, `--outputs tree` and `all`, `--only scalar`, `vector` and `auto`, three
  processes of each in turn;
- `benchmark-dominators` on the synthetic shapes, both paths, three processes.

Every run agreed: "scalar, vector and AUTO agree on all 23418 analyses". [`summary.txt`](summary.txt) has the medians.

## The tree (`--outputs tree`)

`scalar` and `auto` are both SEMI-NCA. The bit matrix (`vector`) loses everywhere:

| CFGs | Matrix / SEMI-NCA |
| --- | --- |
| 2–8 blocks | 1.27–1.37× |
| 8–128 blocks | 1.35–1.94× |
| 128–512 blocks | 2.00–2.05× |
| 512–1,024 blocks | 2.70× |
| 1,024–2,048 blocks (`sqlite3VdbeExec`, 1,577 blocks) | 3.29× |
| all | 1.44× (39.8 against 27.6 ns per block) |

## Every output (`--outputs all`)

| Path | ns per block, all CFGs | Against SEMI-NCA with scalar loops |
| --- | --- | --- |
| SEMI-NCA, scalar loop bodies (`scalar`) | 46.3 | — |
| SEMI-NCA, the vector loop sweep where its matrices fit (`auto`, the default) | 48.6 | +4.8%; +10% to +15% above 128 blocks |
| The matrix and the vector loop sweep (`vector`) | 60.5 | +31% |

## Synthetic shapes (analysis phase, the matrix against SEMI-NCA)

| Shape | Tree | Every output |
| --- | --- | --- |
| diamonds, 16 blocks | 1.59× | 1.43× |
| nested, 256 | 4.84× | 2.11× |
| irreducible, 513 | 6.82× | 2.90× |
| dispatch, 2,049 | 2.72× | 1.44× |
| ladder, 8,192 | 31.0× | 1.47× |
| nested-ifs, 8,192 | 56.1× | 32.6× |
| fan-in, 8,192 | 89.7× | 56.5× |

No AVX-512 path wins anywhere, so dominators keeps SEMI-NCA and the scalar loop bodies as its one implementation
(David, 2026-11-17), and #2953 tracks a data-parallel design that beats them.
