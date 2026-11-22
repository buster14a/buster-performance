# `-E`'s output modes after main's merge (buster#2925), 2026-11-22

[buster#2925](https://github.com/buster14a/buster/pull/2925) adds `-C`, `-CC`, `-dD`, `-dI` and `-dN` to `-E`
([buster#1380](https://github.com/buster14a/buster/issues/1380)). Its branch `claude/gallant-mccarthy-83mog5` was merged
with main `d5fbf14e` on 2026-11-22. #2924 had removed the scalar printer, so the merge also moved `-CC`'s printing into
`pp_print_vector_mode`. That adds a mask a chunk, under `-C` and `-CC` only, and an OR into the chunk's line starts.

This record is a short A/B of the branch against its merge base, without `-C`, plus one `-C` run of the branch for
information. The earlier record of this PR, before the merge, is
[e-output-modes-1380-2026-11-17](../e-output-modes-1380-2026-11-17/README.md).

## How it was measured

- **Host:** the 9700X (`benchpress`), CPU 2. Every build and every run held the host's lock alone (`exclusive.sh`).
- **Trees** (`~/buster-fast-bench/1380-claude-2925/`):
  - `base` is main `d5fbf14ee609dd306f6efc607bb556833b2e9c83`, the branch's merge base;
  - `head` is the branch at `570138a079c3bdf428581d1a89742d08a7d49706`.

  Both are `./build.sh --config Release` builds with CI's Clang 23.1.4 (`results/build-*.log`, `scripts/builds.sh`).
  The executables' hashes are in `results/executables.sha256`.
- **Runs:** `scripts/measure.sh` runs `head/build/compiler ab --rounds 6 --cpu 2 --lock scripts/lockps.sh ../base ../head`
  with three lists, from the head tree, so both builds read the same inputs:
  - AGENTS.md's smoke, `benchmark-preprocessor --clang -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c`.
    Its `-E -P with printing` is the printer without line markers. Its `clang -E` is the host's clang 23.1.1.
  - The same with `--markers` in place of `--clang`: `-E`'s default printing, with line markers.
  - `benchmark-preprocessor --tables src`.
- **Order:** `ab` runs the trees in a Williams order, so each tree goes first in half the rounds.
- **Load and processes:** `lockps.sh` takes the lock for each run. Inside the hold it writes the load and the busiest
  processes before and after the run (`results/ab.log`). Only kernel workers, at 0.1% CPU or less, were listed.
  `exclusive.sh` listed no busy process.
- **The `-C` run:** one `benchmark-preprocessor -E -C` run of the head, under the same lock wrapper (`results/head-C.log`).
- **Each run:** each `benchmark-preprocessor` run reports the medians of 21 passes after a warm-up. `scripts/extract.awk`
  takes the vectorized arm's medians into `results/runs.tsv`. Its columns are round, tree, list, run (ms), instructions
  an input token, the run with printing (ms) and the printing (ms). For `--tables` they are the tables' ms and cycles a
  token.

## Results

The table gives the medians over the 6 rounds. Each spread is the largest round's median over the smallest's.

| `main.c` (2,175,202 input tokens) | base | head | head against base |
| --- | ---: | ---: | ---: |
| `-E -P` run without printing | 44.466 ms (spread 0.29%) | 45.060 ms (0.62%) | +1.34% |
| instructions an input token | 388.55 | 388.99 | +0.11% |
| `-E -P` with printing | 50.698 ms (0.33%) | 51.535 ms (0.57%) | +1.65% |
| printing alone, `-P` | 6.236 ms (0.90%) | 6.463 ms (1.18%) | +3.64% |
| `-E` run without printing (`--markers`) | 37.764 ms (0.52%) | 37.977 ms (0.59%) | +0.56% |
| instructions an input token (`--markers`) | 327.17 | 327.57 | +0.12% |
| `-E` with printing, line markers | 46.320 ms (0.41%) | 46.618 ms (0.57%) | +0.64% |
| printing alone, line markers | 8.577 ms (0.79%) | 8.613 ms (0.41%) | +0.42% |
| `--tables src` | 0.285 ms (1.76%) | 0.287 ms (1.41%) | +0.70% |

- **Every row but `--tables`:** head is slower than base in all 6 rounds, and the two builds' ranges don't overlap.
  - That is beyond the rounds' spread for `-E -P` (+1.65% with printing) and for `-E` with line markers (+0.64%).
  - It is one placement of each build's code, with no shifts and no copies. So this A/B can't tell code from
    placement: on this host a placement alone has moved a compile by up to 2% (buster#502).
- **The runs without printing** take 0.11% to 0.12% more instructions, which the branch's preprocessor changes add.
  Their time rises 0.56% to 1.34%, more than the instructions do.
- **Printing without line markers** is 3.6% slower: 0.23 ms of `main.c`'s 6.2 ms.
- **`--tables`:** within its spread.
- **`-E -C`, head alone, for information:**
  - 75.937 ms without printing, with lex 24.596 ms against 4.05 ms without `-C`;
  - 83.548 ms with `-P`'s printing, of which printing is 7.638 ms;
  - 2,233,584 input tokens and 2,499,063 output tokens, comments among them.

Nothing was optimized after this measurement.
