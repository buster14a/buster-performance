# Comparing builds over code placements and copies, for #509

2026-10-26 and 27. [buster14a/buster#509](https://github.com/buster14a/buster/issues/509)
asked that an A/B of two builds average over where each build's code sits and
over copies of each executable, since on the 9700X either alone moves
`-fsyntax-only` of `sqlite3.c` by more than most changes do (#502's
measurements). [buster14a/buster#527](https://github.com/buster14a/buster/pull/527)
adds both to the tools: `time-runs --build NAME PATH --copies N` and
`./build.sh shifts DIRECTORY SOURCE SHIFT...`. This record holds the runs that
measured those tools on main against the pull request's head.

## Sources and executables

- main `e04462c1` (`Merge pull request #505`), the pull request's base;
- the head `b36288b5` (campaign 1) and `337fd15a` (campaign 2), the pull
  request's two code commits. Its later commits change documentation only.

Both trees were built on the 9700X by the head's `build.sh` (main's has no
`shifts`; the two commits' source lists are the same), without `-g`
(`BUSTER_DEBUG_INFO=0`, as the 9700X job builds), linked by wild 0.10.0, clang
23.1.1. Each tree was built twice per campaign: once shifting the checker's
unit (`main_unit_checker.c`) and once shifting the encoder benchmark's unit
(`x86_64_encoder_benchmark.c`), each of whose `.text` is aligned to 16. Each
build's six executables, `compiler-SHIFT`, are the same objects linked with
SHIFT bytes of padding before the unit. `campaign*/sha256.txt` has every
executable's sha256, and `campaign*/build-*.txt` what `build.sh` printed.

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`, every
timed process pinned to CPU 2 (`ab --cpu 2`), each `time-runs` process under the
shared lock alone (`ab --lock ~/buster-fast-bench/exclusive.sh`), its copies in
`/tmp` (tmpfs). The input is the frozen SQLite amalgamation of #117's
acceptance (`preprocessor-corpora-astra-01a158dd`, `sqlite3.c` sha256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`) with the
options in `scripts/args.sh`; the benchmark is `benchmark-x86-encoder --only
x86_encode_16`. The lock's waiting messages are filtered out of the outputs (they
name other sessions' pages).

## Runs

Each campaign (`scripts/queue.sh`, `scripts/queue3.sh`) runs, from the head's
`compiler-0` as the tool:

- `*-placements.txt`: `ab --rounds 3`, each round one `time-runs` process with
  three builds, main, the head and main again (main's executables under another
  name: the comparison's own floor), each at its six placements, each executable
  from three copies made fresh for the round: 54 processes per build per round,
  3 runs each after a warm-up (5 for the encoder benchmark: 90 per build);
- `*-old.txt`: the old way, each tree's unshifted executable, no copies,
  `ab --rounds 3` of `time-runs --runs 11` (21 for the encoder benchmark).

Every process's line, every executable's and copy's medians and each round's
comparison are in the files; the comparison's lines are what the tables below
take.

## Campaign 1: the shifts did nothing

Campaign 1 shifted the units by 0, 16, 48, 128, 512 and 2,048 bytes (the
encoder's by 0, 64, 192, 512, 1,024 and 2,048), with `b36288b5`'s padding: a
`.text` section kept by `-Wl,-u`. wild 0.10, the 9700X's, dropped it anyway
(wild 0.11, on the laptop, keeps it), so each tree's six "placements" were the
unshifted executable again, byte for byte: `campaign1/sha256.txt` has one
digest per tree. Its "placements" are six more copies, and its comparisons
(whose ranges pair placements by number, as `b36288b5` did) are a comparison
over 18 copies of one placement per tree.

`scripts/padtest.sh` (run under the lock) found the padding that every linker
keeps in place: a section of its own, `.text.buster_shift_padding`, with
`SHF_GNU_RETAIN` and the unit's alignment, which wild 0.10 and 0.11, lld, mold
and GNU ld put right before the next object's `.text`; `--no-gc-sections` kept
it too but moved everything else. `337fd15a` makes the padding so, fails
`build.sh shifts` when the linker drops it, and compares placements without
pairing them by number. `scripts/queue2.sh` was an offset check over campaign
1's binaries, stopped before it ran anything once the digests showed the
problem.

Campaign 1's numbers, as copies of one placement (user cycles, millions; the
head against main, and main again against main):

| Round | sqlite head | sqlite main again | encoder head | encoder main again |
| --- | --- | --- | --- | --- |
| 1 | −0.13% | +0.13% | +2.26% | −0.08% |
| 2 | −0.16% | −0.03% | +2.10% | −0.38% |
| 3 | −0.03% | +0.05% | +2.38% | +0.15% |

The encoder benchmark ran 2.1 to 2.4% slower in the head over 18 copies, at the
same instructions (1,250,217,0xx to 1,250,217,4xx per process in both): one
placement of the head's code, which campaign 2 shows is placement.

## Campaign 2: six placements over a page

Shifts of 0, 688, 1,376, 2,064, 2,752 and 3,440 bytes, spread over a 4 KB page,
for both units: six distinct executables per build (`campaign2/sha256.txt`).

`-fsyntax-only` of `sqlite3.c`, user cycles (millions), `sqlite-placements.txt`:

| Round | main median, placements' spread | head against main (over placements) | main again against main (over placements) |
| --- | --- | --- | --- |
| 1 | 675.1, 0.95% | −0.11% (−1.00% to +1.03%) | +0.06% (−0.87% to +1.25%) |
| 2 | 676.0, 0.65% | +0.03% (−0.60% to +1.27%) | −0.08% (−0.88% to +1.15%) |
| 3 | 674.7, 1.02% | +0.01% (−1.22% to +0.74%) | −0.10% (−1.21% to +1.23%) |

Wall time: the head −0.11%, +0.06% and −0.13%, main again +0.08%, −0.01% and
−0.08%. One placement's copies' medians (3 runs each) were within 0.65 to
1.27% of each other in user cycles. The old way (`sqlite-old.txt`) read the head +0.20%,
+0.13% and +0.36% in user cycles, every round the same sign: what one
placement of each tree gives.

`benchmark-x86-encoder --only x86_encode_16`, user cycles (millions),
`encoder-placements.txt`:

| Round | main median, placements' spread | head against main (over placements) | main again against main (over placements) |
| --- | --- | --- | --- |
| 1 | 295.5, 6.27% | +1.31% (−2.89% to +4.79%) | −0.11% (−4.72% to +5.51%) |
| 2 | 296.7, 4.37% | +0.87% (−2.43% to +3.06%) | −0.77% (−4.33% to +3.99%) |
| 3 | 295.8, 3.62% | +0.65% (−2.18% to +3.24%) | −0.36% (−3.47% to +4.32%) |

Main's placement of 2,064 bytes ran 2.3 to 3.8% slower than the median of its
others in every round (301.7 to 306.4 against 288.3 to 298.8), and the head's
placements spread 1.2 to 1.9%. The old way (`encoder-old.txt`) read the head +1.33%, +1.00% and
+1.56% (campaign 1's head, another placement, +3.04% to +4.45%).

## What it shows

- The head changes `profile.c` and `build.sh`, which neither command runs: its
  instructions per process are main's within 0.0005% (2,000 more per
  `-fsyntax-only` of 1.684 billion for `337fd15a`, 8,000 for `b36288b5`, from
  the driver's unit's own layout), and the
  encoder benchmark's unit is the same source. Every difference here is where
  the code sits.
- The old way finds differences that aren't: the encoder benchmark +1.0% to
  +4.5% depending on the head's commit, `-fsyntax-only` +0.13% to +0.36% for one
  commit and −0.46% to +0.05% for the other (campaign 1's `sqlite-old.txt`).
- Over six placements and three copies each, `-fsyntax-only`'s difference is
  within ±0.11% and its range over placements about ±1%, as main's against
  itself; the encoder benchmark's is +0.65% to +1.31%, with ranges over
  placements of −2.9% to +4.8%, against main's own −0.8% to −0.1%. A benchmark
  whose code is this sensitive (one placement in six up to 3.8% slower) needs more
  placements than six to resolve 1%.

## Limitations

- Six placements sample a page coarsely; a unit's code moves the code after it
  too, and data after `.text` moves with it, but `.rodata` (before `.text`)
  doesn't.
- Three runs per executable and copy make a copy's median noisy: "copies within"
  includes the runs' own spread.
- The stack's page offset under address space randomization varies per
  process (#445's record) and isn't controlled; the copies' paths have one
  length, so `argv[0]` doesn't add to it.
- The tool's comparison in campaign 1 is `b36288b5`'s, which paired placements
  by number; campaign 2's is the pull request's.
