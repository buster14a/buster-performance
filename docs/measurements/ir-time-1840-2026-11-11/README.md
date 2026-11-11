# #1840 item 8: self-built Tier 1 compilers' stage times (2026-11-11)

Package B3 of buster#1840 decoded SIMD machine rows into IR (lane ops, the ternary operand with vpermt2, ternlog,
compress/expand, AES). This record checks the compile-time effect: does the self-built compiler that Tier 1 makes from
the stack run its frontend any differently from one made from main?

- Base: main `bd4e767163790afecb678f696871ad5c305186b4`.
- Head: `ir/1840-aes` `a99f0769162b58420d818924a9fb3bdc1639d06c` (the top of the stack: #2208, #2333, #2338, #2340, #2343).
- Each tree was built by `build.sh` (`BUSTER_HOST_ARCH=znver5`). That compiler then built all 43 of its own units with
  `-c --tier1 -march=znver5`, and clang linked them (`selfbuild.sh`). Both links succeeded. The missing `bc` only broke
  the duration print in `log.txt`.
- Each self-built compiler ran `-fsyntax-only --time-stages --lanes 1 -march=znver5 ... src/buster/compiler/main.c`.
  - It was pinned to CPU 2.
  - There were 11 rounds, alternating which compiler went first.
  - Each run had its own hold of the 9700X lock (`run-time.sh`).
  - The raw outputs are in `stages/`.

## Medians (ms, n = 11 each)

| stage | base | head | head − base |
| --- | ---: | ---: | ---: |
| preprocess | 297.4 | 297.1 | −0.3 |
| preprocess.lex | 84.8 | 85.8 | +1.0 |
| preprocess.refine | 53.9 | 53.6 | −0.3 |
| preprocess.main-loop | 152.9 | 151.7 | −1.2 |
| parse | 229.2 | 229.3 | +0.1 |
| check-input | 1072.9 | 1069.3 | −3.6 |
| check-expressions | 188.4 | 186.8 | −1.6 |
| check-declarations | 228.8 | 225.8 | −3.0 |
| check-program | 510.4 | 511.5 | +1.1 |
| total | 2528.0 | 2521.2 | −6.8 (−0.3%) |

The two compilers' stage times are within noise of each other: the gap is no more than 1.3% in any stage and 0.3% in
total. This is what we expected. The frontend's hot paths reach Tier 1 mostly as scalar code, and the stack changes how
SIMD rows are selected, not how many there are on those paths. The stack's gain is in the IR instead: machine rows
left in `main_unit_frontend.c`/`main_unit_backend.c` at znver5 fell from 660/967 to 234/557 (records
`ir-*-1840-*`). Those rows are now visible to the IR's optimizers.
