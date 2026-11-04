# Compact float and double literal tables (#658)

Evidence for [buster14a/buster#1210](https://github.com/buster14a/buster/pull/1210), part of
[#658](https://github.com/buster14a/buster/issues/658): file-scope `float` and `double` tables of literals published as
one bytes part, with whole-table fallback to the ordinary path.

## Sources

| tree | revision | executable's SHA-256 |
| --- | --- | --- |
| `main` | `c79fd0076fc8ee3ba0a43d02f94dca417a7557ea` (the main merged into the PR) | `984ee8de5365e49ef0b72fef2e6c100f6fa5286a5a02ee26834abedd6ad339b4` |
| `head` | `e20248976702bf4c3242a4dbd7f3abaeb278a97c` (the PR's head) | `0229f9dbcf2b7692648fffbf211f38ca42db3f8292cb27f49de02ca1ec202125` |

`main-again` is `main`'s executable timed again, the floor. Each tree was a `git worktree` built on the 9700X with
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, each build under the machine's lock.

The inputs are 200,000-element tables that `scripts/gen.c` writes (values of a 32-bit LCG scaled to [−0.5, 0.5), eight
to a line); `scripts/run.sh` has the commands:

| input | what | SHA-256 |
| --- | --- | --- |
| `float_f_200000.c` | `float`, each value with an `f` suffix (`%.9gf`) | `90f8ab21c19a36db702e17d2ff5cb8917f770ed6dc38a29cedf4b0eceb757f67` |
| `float_x_200000.c` | `float`, double literals of a third of each value (`%.17g`), which round to float | `f0083f289aa9ec124489409a33630b51e8e6c3267c6d0d137054b39086fbebb8` |
| `double_x_200000.c` | `double`, the same literals | `52d3cd54dcd9136396521f61aa83b77ee8d602bb8dfeb626a48dcc95364fff00` |
| `float_fallback_200000.c` | `float_x_200000.c` with a last element `16777217`, which float can't hold, so the whole table falls back | `22394d5d609ff605518c88748e686e16a4e7cebc6e68239d5f64bdecb2d29ebb` |
| `scripts/gen.c` | the generator | `737b9323bc5123a45a3b036333989802fe3e8a2a64f7204b24b5b57511538c01` |

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`, defrag `madvise`. Timed
processes pinned to CPU 2 (`taskset -c 2`); the `time-runs` process ran under the shared 9700X lock.

## Runs

`raw/ab-1210-large.txt`: one `time-runs --runs 15 --warmups 2 --copies 3` process with `main`, `head` and `main-again`,
five lists. The log keeps only what `time-runs` prints; the lock's waiting notice, which names another job, was dropped.

## Results

Wall time, the median of each build's 45 runs, the range over its copies, and the peak resident set (copy 1):

| input | `main` | `head` | `head` against `main` | `main-again` (floor) | peak KiB `main` → `head` |
| --- | ---: | ---: | --- | --- | --- |
| `float_f` `-fsyntax-only` | 92.272 ms | 32.069 ms | −65.25% (−65.34% to −65.12%) | −0.11% | 275,672 → 114,980 |
| `float_x` `-fsyntax-only` | 96.010 ms | 44.093 ms | −54.08% (−54.16% to −54.00%) | −0.28% | 277,160 → 116,564 |
| `double_x` `-fsyntax-only` | 95.981 ms | 36.158 ms | −62.33% (−62.36% to −62.20%) | −0.16% | 277,208 → 116,456 |
| `float_fallback` `-fsyntax-only` | 96.234 ms | 122.999 ms | **+27.81%** (+27.61% to +28.08%) | −0.26% | 277,160 → 279,240 |
| `float_x` `-c` | 104.172 ms | 44.565 ms | −57.22% (−57.49% to −56.58%) | +0.32% | 281,788 → 116,804 |

User instructions per process (copy 1): `float_f` 1,890 M → 588 M, `float_x` 1,946 M → 796 M, `double_x` 1,947 M →
644 M, `float_fallback` 1,946 M → 2,517 M.

## The fallback's cost

A table that the compact path refuses at its last element converts every element before it, then discards them, and
the ordinary path does it all again: 571 M more instructions (2,855 for each of the 199,999 elements converted in
vain), 27 ms more wall time. The other refusals that the grammar's scan doesn't catch first (a literal's range warning,
an imaginary or bit-precise constant, a malformed spelling) cost the same when they come late. Refusals by shape
(designators, expressions, nested braces) are caught before any conversion.

## Limits

- One session's run of one `time-runs` process; the floor's spread is the comparison's noise.
- The first run timed only 200,000-element tables; the later heads, below, add 128 and 4,096.
- `sqlite3.c` has no such tables; the PR's CI A/B on it (Benchpress, run 41845398921) was neutral.

## Later heads: f754e1a8 and 65f678d9

The PR's review asked for the fallback's cost to be cut and for accepted tables of every kind and size to be measured
again. Two heads since:

- `f754e1a87aebc987484762e11926d21d90f17d9a` (`head3-1210`, executable
  `99c27d17fa2ce39b3d6827bbffe218d42eb83d1b2c2613c88e3b552f833e4e44`): the table's spellings are gathered once,
  and every integer of four characters or more is converted before the other elements.
- `65f678d9b73cd7ecf8bb6b84f17dc8d53279f3d8` (`head4-1210`, executable
  `4675a9fedb6460fe12694d06ee3c1df13760e85a1042b369ad633fc268da48d4`): only the integers whose digits allow a value
  the format can't hold are converted first (more than 7 decimal digits for `float`, 15 for `double`, and the like).

`main` is the same `c79fd007` executable as above. `scripts/run-v2.sh` has the commands; `scripts/gen2.c` writes the
inputs (SHA-256 `5adf031fc610745942c69e725b82c1ad2801a90bb12e08f71fdf9e6c8b33e86c`), each at 128, 4,096 and 200,000
elements: `float` with `f` suffixes (`f`), rounded double literals (`x`), integers of at most three digits (`s`),
integers of four to seven digits (`l`), all of those and hexadecimal integers in turn (`m`), `double` (`double_x`), and
the `l` table with a last element `16777217` (`fallback`). The inputs' SHA-256 are in `SHA256SUMS` below. Each head
was timed by two `time-runs --copies 3` processes under the lock, pinned to CPU 2: the 200,000-element tables with 15
runs (`raw/ab-1210-v*-large.txt`), the others with 60 (`raw/ab-1210-v*-small.txt`).

Wall time against main (the range over copies), `65f678d9`:

| table | 128 | 4,096 | 200,000 |
| --- | --- | --- | --- |
| `float` `f` | −8.12% (−8.74% to −6.89%) | −42.91% (−45.36% to −41.51%) | −64.91% (−65.02% to −64.75%) |
| `float` `x` | −6.41% (−7.51% to −4.82%) | −34.69% (−34.84% to −34.40%) | −53.90% (−53.96% to −53.66%) |
| `float` `s` | −8.39% (−8.64% to −8.19%) | −49.61% (−49.76% to −49.45%) | −76.83% (−76.97% to −76.80%) |
| `float` `l` | −4.77% (−5.16% to −4.47%) | −29.50% (−29.69% to −29.16%) | −53.74% (−53.87% to −53.65%) |
| `float` `m` | −6.53% (−6.67% to −6.26%) | −38.14% (−38.37% to −37.79%) | −61.51% (−61.64% to −61.39%) |
| `double` `x` | −7.62% (−7.82% to −7.35%) | −41.20% (−41.33% to −41.00%) | −62.05% (−62.14% to −61.99%) |
| `float` `fallback` | **+3.04%** (+2.37% to +3.58%) | **+4.51%** (+4.08% to +5.04%) | **+6.32%** (+5.34% to +6.71%) |

The floors (`main-again` against `main`) are within −1.34% to +0.36%. The late fallback at `f754e1a8`, whose pre-pass
converted every integer of four characters or more and so all of the `l` table's before its last element refused it:
+3.65% at 128, +16.90% at 4,096 and +22.96% at 200,000 elements. The accepted tables at `f754e1a8` are within about a
point of `65f678d9`'s (`raw/ab-1210-v2-*.txt`).

Peak resident set (copy 1), 200,000 elements, `main` → `65f678d9`: `f` 275,700 → 114,980 KiB, `x` 277,156 → 118,640,
`s` 273,920 → 113,248, `l` 274,644 → 114,284, `m` 268,960 → 108,424, `double` 277,156 → 118,496, `fallback` 274,708 →
276,720. At 128 elements 19.3 MB → 16.7–17.0 MB, and at 4,096 elements 23.7 MB → 21.2–21.5 MB; the fallback tables
are within 0.7% of main's. The spellings kept in scratch until a table is decided are inside these peaks.

The remaining fallback cost is the spellings gathered before the last element refuses the table: about 23 ns for each
element at 200,000 elements.
