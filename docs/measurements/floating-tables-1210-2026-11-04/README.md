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

## The fallback's last costs: 1a1a09d4 to 188d0a10

The review asked for the late fallback's remaining cost to be accepted or optimized; it was optimized. A profile at
`65f678d9` (perf on the 9700X) put that cost in gathering every element's spelling before any conversion
(`check_input_spelling`: an arena push, a range search and a splice scan each, then 16 bytes of columns): the table
step 3.24%, `pp_without_splices` 0.96%, `pp_spelling` 0.58%. The heads since:

- `1a1a09d4` (not timed): elements read in place (`check_literal_table_element`): a number token in one source range
  without a splice is spelled by its bytes there, the range searched for once; an element shorter than 8 bytes (16 for
  `double`) passed on its length; a longer one classified by one masked 64-byte load (`check_literal_table_classify`).
- `39f13edfa9de46096cd17d9fc61a09e7e7a34734` (`head6-1210`, executable
  `6dad31b92ef338907d12f8ce0b3e9892e31f979cd8c1a91d004b8030e4fad7f7`): one scan of the bytes from the table's first
  number to its last clears them of splices (`check_literal_table_span`).
- `8abc6cbf7b89972d7550d4760ae4319927facc9b` (`head7-1210`, executable
  `9f5513b7ff02113a8b398699eb23ac31c3342571f4c6de8cbdc6000c1d2f42e3`): short numbers and in-span spellings without a
  call; the classifier stops at a '.' or an exponent.
- `188d0a10bbcba60c4559fbb0a08df2db06dc83e4` (`head8-1210`): a long number in the span classified without a call.

A further input, `t_float_xfallback_*.c`, is the `x` table with a last element `16777217`, so that every element before
the refusal is long and read (SHA-256: 128 `e37ac0fd89f6c5880f26b73da0f0ec71f4afd2a4811fc670c5c771cd52ec14ce`, 4,096
`6b5d8de11747e6be2690866a8d016b254b204f53773092e25c61b95b60bf7a95`, 200,000
`22394d5d609ff605518c88748e686e16a4e7cebc6e68239d5f64bdecb2d29ebb`, the same bytes as `float_fallback_200000.c`
above).

`scripts/run-v6.sh` and `scripts/run-v7.sh` time main, the previous head and the new one against main again, in one
`time-runs --copies 3` process for the 200,000-element tables (15 runs) and one for the others (60 runs), pinned to
CPU 2 under the lock (`raw/ab-1210-v6-*.txt`, `raw/ab-1210-v7-*.txt`). Against main, the late fallbacks:

| head | `fallback` 128 | 4,096 | 200,000 | `xfallback` 128 | 4,096 | 200,000 |
| --- | --- | --- | --- | --- | --- | --- |
| `65f678d9` (v6) | +1.58% | +3.60% | +5.23% | +1.08% | +3.32% | +5.02% |
| `39f13edf` (v6) | +1.41% | +0.47% | +1.19% | +1.04% | +1.14% | +2.19% |
| `8abc6cbf` (v7) | +0.16% | +0.07% | +1.27% | −0.01% | +1.03% | +2.49% |

The accepted tables gained at each step: at `8abc6cbf`, 200,000 elements −55.30% (`x`) to −77.07% (`s`), 4,096
−33.24% to −50.11%, 128 −7.49% to −10.87%. In a profile of `8abc6cbf` (`perf record` of five compiles, under the
lock), the table step of the long-integer fallback is 0.40% and that of the rounded fallback 0.63%, plus 0.62% in
`check_literal_table_element`, which `188d0a10` inlines.

The same code at other addresses runs up to 2% faster or slower on the 9700X (#509), more than the remaining fallback
costs, so the last head was timed as the 9700X workflow's checker A/B times one: `scripts/run-v8.sh` links main and
`188d0a10` at four placements of `main_unit_checker.c`'s code (`./build.sh shifts`: 0, 1,088, 2,112 and 3,136 bytes)
and times them over their placements with main's placements again as the floor (`raw/ab-1210-v8-*.txt`; executables'
SHA-256, main: `7af605913d1a83f28587bb2c56248250fe0ccd0dfac07c19baa1e198f4888dca`,
`349c74e9672fcb2409ca8862c794a56258124a198ecf18c8d28485a78f09af2a`,
`3360f9b24f66927ed5df0ac68a37764efcc7d1a828fe0179aedc6f9be78f4c14`,
`9e0dc8e59ffff08019e6a199b86a3c195f2da06f1a6b67fac7c0e600e49182ae`; `188d0a10`:
`103321964fc167d6a24bb59b0905206f5984d29fb5767d608efc9dcd82222838`,
`8ab5eb43ba37e25c353e004dd1ca63807aa5b2e2723cd4b1d8f3e0e03de8c581`,
`4b559defbec2afc5f60ef3c52dad23e976e85a578c07d54369e2edfb1e52defd`,
`1d7a38d92d4e7c2d984dfa14383b1e3f5e943b435d4365018574edf505fc4cad`). Wall time against main, the range over
placements:

| table | 128 | 4,096 | 200,000 |
| --- | --- | --- | --- |
| `float` `f` | −7.13% (−16.22% to −3.42%) | −42.69% (−46.53% to −40.37%) | −66.11% (−66.30% to −65.84%) |
| `float` `x` | −6.15% (−13.44% to −2.13%) | −35.39% (−37.52% to −33.70%) | −55.95% (−56.25% to −55.43%) |
| `float` `s` | −8.04% (−14.68% to −4.34%) | −48.72% (−50.90% to −47.15%) | −77.17% (−77.44% to −76.97%) |
| `float` `l` | −5.06% (−12.17% to −1.59%) | −32.06% (−34.77% to −30.12%) | −57.72% (−58.39% to −56.94%) |
| `float` `m` | −6.00% (−13.00% to −2.50%) | −38.29% (−40.74% to −36.67%) | −63.16% (−63.34% to −62.91%) |
| `double` `x` | −7.48% (−14.40% to −3.99%) | −41.94% (−44.00% to −40.66%) | −64.19% (−64.32% to −63.84%) |
| `float` `fallback` | +1.52% (−5.71% to +5.64%) | +0.83% (−3.36% to +3.28%) | +1.00% (−0.11% to +1.45%) |
| `float` `xfallback` | +1.83% (−5.32% to +5.47%) | +1.55% (−2.05% to +3.41%) | +1.05% (+0.48% to +1.82%) |

The floor (`main-again`, main's placements timed again) is within −0.45% to +0.47% of main, and its placements range
from −7.44% to +7.01% at 128 elements, −4.72% to +7.01% at 4,096 and −2.29% to +1.31% at 200,000. A table refused at
its last element now costs about 1% more than main at 200,000 elements, against 27.8% at `e2024897`; at 128 and 4,096
elements the difference is within the spread of placements.
