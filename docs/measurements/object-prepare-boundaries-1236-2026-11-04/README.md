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

### The one-line `-c`'s user cycles

`time-runs` reads `head`'s user cycles 2% to 3.5% over `base`'s, net of the floor, in both campaigns, with 253 fewer
user instructions. Placement doesn't explain it: in `abc` each of `head`'s six placements took 2.134 to 2.196 million
user cycles, and each of `base`'s 2.069 to 2.115. `perf stat` doesn't reproduce it:

- back to back (`raw/stat.log`, `-r 51`): `base` 1.22–1.27 million user cycles, `head` 1.16–1.22; L1 dTLB misses
  3,176–3,204 against 2,152–2,153; demand fills 13,025–13,059 against 12,984–13,002, of them from DRAM 42–50 against
  44; branch mispredictions 12,709–12,771 against 12,571–12,623; instruction-cache fill misses 21,404–21,529 against
  21,380–21,428.
- alternating (`raw/statb-medians.txt`, 39 to 41 processes per tree and round): `head` +0.88%, −0.59% and −0.78%
  in user cycles, `base-again` −0.36%, −0.20% and −2.26%; user instructions −0.02%; L1 dTLB misses −32.6% against
  the floor's −10.1% to −10.3%; kernel cycles (multiplexed, 10 to 17 processes each) −21.5%, −32.8% and −26.9%, the
  floor's −1.8%, −18.8% and −6.7%.

So the wall time falls by 0.8% to 2.6% on the one-line `-c`, 8 to 21 µs of its medians, with the kernel's huge-page
clear gone; the user-cycle reading depends on the harness, and this record doesn't say why `time-runs` reads it
higher.

## Limitations

- One machine and kernel for the timings; the smaps were also taken on the 7940HS (`raw/local-7940hs.txt`, where
  `head` with `scripts/old-bound.patch`, main's bound, holds the same two huge pages as `base`, and fails
  `test-object-writer`'s new check).
- The lock was contended: batches waited for CI jobs and another session between them, though none ran during one.
- `perf stat`'s sixth counter was multiplexed (`cycles:k` and `ls_bad_status2.stli_other` were often not counted), and
  four of `raw/statb.log`'s processes read `cycles:u=0`; `scripts/medians.py` leaves those out.
