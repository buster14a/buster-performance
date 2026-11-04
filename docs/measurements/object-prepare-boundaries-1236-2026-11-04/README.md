# object_prepare's part boundaries sized by the units (#1236)

Evidence for [buster14a/buster#1236](https://github.com/buster14a/buster/issues/1236): every `-c` cleared a 2 MB huge
page in the driver's scratch arena, because `object_prepare` pushed `BUSTER_LANE_MAX_PARTS + 1` part boundaries
(131,080 bytes) for its one unit, which took the arrays after them past the arena's 64 KB of base pages. The change
sizes them by the parts `lane_parts_by_cost` can cut, `min(units, BUSTER_LANE_MAX_PARTS) + 1`: two for `-c`.

## Sources

| tree | source | what |
| --- | --- | --- |
| `base` | `cdee12f2ee9dbb03ccc87071fe76f278a369ec70`'s `git archive` | main, the branch's merge-base |
| `head` | `84d0b572eaf8773c586bf1ea8bb64bd915e1e99b`'s `git archive` | the change, with its test and guide |
| `swch` | `head` with `scripts/switch.patch` | a measurement switch, not committed: main's bound where `BUSTER_1236_OLD_BOUND` is set |

Each tree was extracted into an empty directory on the 9700X and built there with `BUSTER_HOST_ARCH=znver5
./build.sh`, each build under the machine's lock. The executables' and inputs' SHA-256 are in `raw/ab.log`, and the
shifted builds' in `raw/abc.log`. `tiny.c` is `int f(int x) { return x + 1; }`; `sqlite3.c` is the frozen file the #652
record times (`fewer-arenas-652-2026-11-03`), SHA-256 `0a409f16...5e23d`.

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, gdb 18.1, transparent huge pages `always` with defrag
`madvise`, CPU 2's governor and EPP `performance`. Timed processes pinned to CPU 2. Every build and every batch ran
under the shared 9700X lock, taken per batch. `raw/local-7940hs.txt` comes from a Ryzen 9 7940HS (Linux 7.3.1,
transparent huge pages `always`) with that machine's native builds.

## Runs

- `scripts/ab1236.sh` (`raw/ab.log`): both builds; a drive check (each tree's `-c` of both inputs, status and object
  compared); `scripts/smaps.gdb` with `scripts/smaps.py`, which list the anonymous mappings and their huge pages at
  `exit_group`, for each tree's one-line `-c`; three rounds of `perf stat -x, -r 51 -e
  task-clock,page-faults,instructions:u,instructions:k` of that `-c`. Its `ab` runs failed at once: `time-runs` needs its
  copies' directory to exist, and it didn't.
- `scripts/ab1236b.sh` (`raw/abb.log`): those `ab` runs again, `ab --rounds 3 --cpu 2` of `time-runs --copies 3` with
  `base`, `head` and `base-again` (base's executable again, the floor): the one-line `-c` (31 runs) and `sqlite3.c`'s
  `-c` (7 runs).
- `scripts/ab1236c.sh` (`raw/abc.log`): the builds over their code's placements (#509): each tree's checker unit
  (`main_unit_checker.c`, which holds the `-c` driver and `object_writer.c`) linked at shifts of 0, 704, 1,408, 2,048,
  2,752 and 3,456 bytes, then `ab --rounds 3` of `time-runs --copies 3` over the six placements of each of `base`,
  `head` and `base-again`: the one-line `-c` (11 runs) and `sqlite3.c`'s `-c` (1 run). Its first attempt
  (`raw/abc-failed-shifts.log`) asked for shifts that aren't multiples of the unit's `.text` alignment, 64, which
  `build.sh shifts` refused; nothing was timed.
- `scripts/stat1236.sh` (`raw/stat.log`): three rounds of `perf stat -r 51` of each tree's one-line `-c`, back to back,
  in two groups of user-mode events (L1 dTLB misses, demand fills and those from DRAM, retired branch mispredictions,
  instruction-cache fill misses, all fills and hardware prefetch fills).
- `scripts/stat1236b.sh` (`raw/statb.log`, summarized by `scripts/medians.py` in `raw/statb-medians.txt`): `perf stat`
  of one process at a time, the executables alternating as `time-runs` alternates them (`base`, `head`, and a copy of
  base's executable as `base-again`, rotated by iteration), 41 iterations a round, three rounds.
- `scripts/ab1236d.sh` (`raw/abd.log`): one `ab --rounds 3` of three `time-runs` lists of the one-line `-c`: copies on
  tmpfs, copies on `~/.cache` (btrfs with zstd compression, as `abb` and `abc` had them), and no copies.
- `scripts/ab1236e.sh` (`raw/abe.log`): the copies' and the no-copies list, each with transparent huge pages on and off
  for every measured process (`scripts/thpoff.c`), and `/proc/vmstat`'s THP and compaction counters around each.
- `scripts/ab1236f.sh` (`raw/abf.log`, `raw/abf-cases.txt` by `scripts/cases.py`): a third tree, `swch` (below), and
  the copies' and no-copies lists of `base`, `head`, `swch` and `base-again`, each with the switch unset and set.
- `scripts/ab1236g.sh` (`raw/abg.log`, `raw/abg-cases.txt`): each file's mappings of itself at a `-c`'s exit
  (`scripts/smapsfile.gdb`, `scripts/smapsfile.py`), then lists with copies in three orders, and the usual order with the
  branch predictors flushed between processes (`scripts/ibpb.c`).
- `scripts/ab1236h.sh` (`raw/abh.log`, `raw/abh-cases.txt`): `abf`'s copies' lists with the predictors flushed.

The logs keep every line the scripts, `ab`, `time-runs` and `perf` print; the lock's waiting notices, which name other
sessions, were dropped, and nothing else was.

## Results

At exit, the one-line `-c` holds 5,488 KB of anonymous memory with two huge pages (4,096 KB of `AnonHugePages`) on
`base`, and 3,440 KB with one on `head`, at the same address on both machines. On the 7940HS, gdb on `arena_commit`
finds that page to be the identifier table's (`intern_lay_out` commits 1 MB; #1237's description finds it touches 964
KB on an empty file), and no commit past the scratch arena's base pages on `head`. The drive check wrote the same
objects on both trees for both inputs.

`perf stat -r 51` of the one-line `-c` (`raw/ab.log`), three rounds:

| tree | task-clock | page faults | user instructions | kernel instructions |
| --- | ---: | ---: | ---: | ---: |
| base | 0.59–0.61 ms | 472 | 1,545,222–1,545,226 | 3,612,750–3,621,334 |
| head | 0.57 ms | 468 | 1,544,980–1,544,982 | 3,530,306–3,535,962 |

`time-runs` medians against `base`, per round (wall time; user cycles):

| run | input | head, wall | base-again, wall | head, user cycles | base-again, user cycles |
| --- | --- | --- | --- | --- | --- |
| `abb` | one-line `-c` (31 × 3) | −2.02%, −1.03%, −2.57% | −1.31%, +1.78%, −0.79% | +3.74%, +4.50%, +3.44% | +1.29%, +0.97%, +0.81% |
| `abb` | `sqlite3.c` `-c` (7 × 3) | −0.14%, +0.12%, +0.03% | +0.01%, +0.03%, −0.09% | −0.22%, +0.10%, +0.10% | +0.01%, +0.02%, +0.06% |
| `abc` | one-line `-c` (11 × 6 × 3) | −1.75%, −0.80%, −1.11% | −0.08%, +0.66%, +0.92% | +3.22%, +3.70%, +3.06% | +1.18%, +1.61%, +1.05% |
| `abc` | `sqlite3.c` `-c` (1 × 6 × 3) | −0.00%, −0.02%, −0.04% | +0.01%, −0.02%, −0.19% | +0.12%, −0.06%, +0.06% | −0.01%, +0.03%, −0.16% |

`abb`'s wall-time medians for the one-line `-c`: `base` 0.818, 0.810 and 0.819 ms, `head` 0.802, 0.802 and 0.798, and
`base-again` 0.807, 0.825 and 0.813. Per process (`abb`'s `run` lines, all 279 or 63 of each tree), the one-line `-c`
makes 484 to 488 minor faults on `head` against 488 to 492 on `base`, and peaks at 14,512 to 14,684 KiB against 16,720
to 16,996; `sqlite3.c`'s `-c` 6,397 to 6,401 faults against 6,400 to 6,404, at 295,780 to 295,960 KiB against 295,968
to 296,140, with about 6,800 fewer user instructions (1,863,543,528 to 1,863,543,713 against 1,863,550,306 to
1,863,550,512).

### The one-line `-c`'s user cycles: the harness, not the change

`time-runs` reads `head`'s user cycles 2% to 3.5% over `base`'s, net of the floor, in both campaigns, with 253 fewer
user instructions, and in `abc` each of `head`'s six placements took more (2.134 to 2.196 million) than each of
`base`'s (2.069 to 2.115). `perf stat` doesn't reproduce it:

- back to back (`raw/stat.log`, `-r 51`): `base` 1.22–1.27 million user cycles, `head` 1.16–1.22; L1 dTLB misses
  3,176–3,204 against 2,152–2,153; demand fills 13,025–13,059 against 12,984–13,002, of them from DRAM 42–50 against
  44; branch mispredictions 12,709–12,771 against 12,571–12,623; instruction-cache fill misses 21,404–21,529 against
  21,380–21,428.
- alternating (`raw/statb-medians.txt`, 39 to 41 processes per tree and round): `head` +0.88%, −0.59% and −0.78%
  in user cycles, `base-again` −0.36%, −0.20% and −2.26%; user instructions −0.02%; L1 dTLB misses −32.6% against
  the floor's −10.1% to −10.3%; kernel cycles (multiplexed, 10 to 17 processes each) −21.5%, −32.8% and −26.9%, the
  floor's −1.8%, −18.8% and −6.7%.

The runs below (`scripts/ab1236d.sh` to `ab1236h.sh`) take the reading apart. It has three parts, none of them the
change's work.

**The floor is biased by the order (branch predictors).** `time-runs` takes its slots in one cyclic order
([buster14a/buster#1311](https://github.com/buster14a/buster/issues/1311)), so `base` always runs right after `base-again`,
the same non-PIE code at the same virtual addresses, and every other build after another's code. Mitigations here are
"IBPB: conditional", so nothing flushes the branch predictors between these processes. `raw/abg-cases.txt`, with copies:

| order | base-again, user cycles | head, user cycles |
| --- | --- | --- |
| base, head, base-again (the usual) | +1.29%, +1.09%, +2.41% | +2.79%, +2.95%, +3.99% |
| base, base-again, head | −0.98%, −1.67%, −1.41% | +2.12%, +1.12%, +3.82% |
| base, base-again | −0.95%, −0.72%, +1.21% | |
| the usual, predictors flushed between processes (`ibpb`) | +0.39%, −0.90%, −0.23% | +2.53%, +2.30%, +1.96% |

`scripts/ibpb.c` force-disables indirect branch speculation (`PR_SPEC_FORCE_DISABLE`) for `ab` and everything it runs,
so the kernel issues an IBPB when it switches between them. With it the floor is 0 within a point; so the usual floor's
+1% to +2.4%, and 0.5 to 2 points of `head`'s reading (+2.79% to +3.99% before, +1.96% to +2.53% after), is `base`
running on the predictions its twin left.

**The bound itself costs no user cycles.** `swch` is `head` with `scripts/switch.patch`, one executable that takes main's
bound where `BUSTER_1236_OLD_BOUND` is set; only `swch` reads it, so each round runs the same lists with it unset and set
(`raw/abf-cases.txt` without `ibpb`, `raw/abh-cases.txt` with it). `swch`'s readings against `base`, new bound minus old:

| run | wall | user cycles |
| --- | --- | --- |
| copies (`abf`) | −2.21, −1.38, −2.75 points | +1.23, +0.44, −0.43 points |
| no copies (`abf`) | −3.46, −2.25, −2.26 points | −0.16, +0.64, −1.16 points |
| copies, `ibpb` (`abh`) | −4.23, −2.76, −1.43 points | −0.63, −0.99, +0.38 points |

The rest is `head`'s executable: with the predictors flushed, `head` read 0.8 to 1.3 points over `swch` with the same
bound (`abh`, the switch unset). `abc`'s shifts, multiples of the unit's 64-byte alignment, moved the unit within its
pages but kept its code's packing into cache lines. By the symbol tables (`nm`, functions present in both), the
executables' code differs in more than that: `head`'s functions sit about a page after `base`'s (4,366 of them exactly
4,096 bytes; the most common other shifts are 4,080, 4,448, 4,400, 4,512 and 4,336), and `swch`'s mostly within −48 to
+128 bytes of `head`'s (3,303 of them at 0; the most common others are −32, +112, +128, −48 and −16). That is #509's
placement noise, on the one-line `-c`'s cold code.

**It shows only with fresh copies.** `raw/abd.log` runs three lists each round: copies on tmpfs, copies on `~/.cache`
(btrfs, zstd), and no copies. With copies `head` reads +2.65% to +3.97% in user cycles (floor +0.61% to +2.90%);
without, −0.53% to +1.12% (floor −1.93% to +0.63%). A copy's code is in physical pages no recent process touched, so
each process starts colder: 1.6 to 1.7 million user cycles against 1.24 to 1.41 without copies, where code placement
weighs more. `raw/abe.log` runs the same with transparent huge pages off for every measured process (`scripts/thpoff.c`,
`PR_SET_THP_DISABLE`, inherited): `head` still reads +2.56% to +4.55% with copies (floor +1.05% to +2.66%), so the huge
page isn't the cause either. Its `/proc/vmstat` deltas (rounds 2 and 3; round 1's include other work while it waited for
the lock) count the expected huge-page faults, 482 per list with copies (96 processes each of 2 + 1 + 2) and 161
without, no fallbacks and no compaction stalls.

**Without copies, `head`'s own file is fast for another reason.** There `head` reads −9.8% to −10.6% in wall time with
430 or 431 faults a process, against `swch`'s −2.4% to −3.2% with 485 to 487 (`abf`). `../head/build/compiler` is also
`ab`'s and `time-runs`' own executable, which stays mapped while they run, and the kernel (`CONFIG_READ_ONLY_THP_FOR_FS`,
khugepaged) has collapsed its read-only segment into file-backed huge pages: at exit a `head` process maps 6,144 KB of
it with `FilePmdMapped`, where `base`'s and `swch`'s files, base's copy and a fresh copy of `head` map none
(`raw/abg.log`'s `== text` lines, `scripts/smapsfile.py`). With copies, `time-runs` avoids that.

So, with one executable for both bounds, the change takes 1.4% to 4.2% off the one-line `-c`'s wall time and leaves its
user cycles within 1.2 points either way; the 2% to 3.5% that `time-runs` read was its order's bias and the two
executables' code placement.

## Limitations

- One machine and kernel for the timings; the smaps were also taken on the 7940HS (`raw/local-7940hs.txt`, where
  `head` with `scripts/old-bound.patch`, main's bound, holds the same two huge pages as `base`, and fails
  `test-object-writer`'s new check).
- The lock was contended: batches waited for CI jobs and another session between them, though none ran during one.
- `swch` is a throwaway patch, measured but not committed, and its code sits apart from `head`'s as above; `ibpb` also
  slows every switch between the measured processes, which reads in their wall times, not in their user cycles alone.
- The order and setting experiments (`abd` to `abh`) have three rounds each, one `time-runs` process per list and round.
- `perf stat`'s sixth counter was multiplexed (`cycles:k` and `ls_bad_status2.stli_other` were often not counted), and
  four of `raw/statb.log`'s processes read `cycles:u=0`; `scripts/medians.py` leaves those out.
