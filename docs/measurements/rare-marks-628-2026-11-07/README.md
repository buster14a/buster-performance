# The rare columns read only where written (buster#628), 2026-11-07

This record holds the 9700X measurements of buster's pull request from `claude/practical-tesla-2lgodi` and of the
versions before it. The pull request gives the checker's scratch back after the reader past what the next stages push
again, and puts a reading in source order's rare columns (`check_input_sparse_arena`'s token columns) in base pages. A
bit per 64 bytes of those columns marks what a write claimed. The vector path's hot reads give 0 where no bit is set,
without touching the page. `scratch-rare-628-2026-11-07` found the reasons for both and measured the variants without
the marks.

The first three versions of the marks lowered the peak by 9,464 to 9,676 KiB and the kernel's cycles by 1.6 to 2.3 M,
but each cost 4.0 to 5.0 ms of task clock. It was in the expressions' classes' pass, which took 5.3 ms rather than 0.48:
its vector loads of the columns, gated off by a mask of no lanes, cost far more than a load at the pages nothing had
touched. `masked/` measures that load alone. The fourth version reads a static line of zeros instead, and is faster
than main.

## Sources

| tree | commit | what |
| --- | --- | --- |
| `main4` | [`4e5abcb0`](https://github.com/buster14a/buster/tree/4e5abcb0a0ec0e888d45c5ab9844a525fbcff4cd) | main |
| `marks` | `36ceed09ee63c4d2f45e627f68d2b3c770c97d33` | marks by page, on `main4`, with both scratch changes (`patches/marks`) |
| `main5` | [`87ef0550`](https://github.com/buster14a/buster/tree/87ef05501cf011c5bbf1f5fe112d66f97b9674cf) | main |
| `pr` | `31bf2e97c93d32f19501188bb8bbf74409efb211` | the scratch, then marks by 64 bytes, whose gates branch (`patches/pr`) |
| `pr2` | `924e4eb87193dd26a72f7b8ccaec1d21fffdb4ee` | `pr` with gates by masks, a scalar read's index and a vector load's lanes (`patches/pr2`) |
| `pr3` | `a139719f3e788719e29bad55794a5d312ccc83e7` | `pr2` whose gated vector loads read a static line of zeros (`patches/pr3`) |
| `main6` | [`872cb8fe`](https://github.com/buster14a/buster/tree/872cb8fe34b5b009698ccd1a81688f4a94f1e3ee) | main |
| `pr4` | `ffb2cfaebbdc6c768958e127c2d328bd331053b3` | `pr3` on `main6`, the pull request's code (`patches/pr4`) |

The commits reached the host as git bundles; `patches/` holds each as `git format-patch` made it. The pull request's
commits are `pr4`'s with the measured numbers in the docs and the text of a comment: built on the VM, their `.text`,
`.rodata` and `.data` are `pr4`'s bytes, and only the debug information's checksums of the sources differ.
The receipts (`run/receipts10.txt` to `run/receipts13.txt`, and `run/receipts15.txt`; `chain14.sh` reran
`chain13.sh`'s trees) have the host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting, clang's and
perf's versions, every executable's SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options.

## Method

As in `scratch-rare-628-2026-11-07`: each tree built with `BUSTER_HOST_ARCH=znver5` under one hold of the lock, then
`ab-grants.sh` with **one grant of the lock per measured compiler process**, `taskset -c 2 perf stat` of each compile
with `--time-stages`, the order alternating by round. Each chain then compiled with both trees in six modes (the
step's options, `-Wall -Wextra`, `--scalar -Wall -Wextra`, `--lanes 8`, `--lanes 8 --deferred-bodies` and `-g`) and
compared the objects and the diagnostics, leaving out `exclusive.sh`'s notices of whoever held the lock.

| chain | A | B | runs |
| --- | --- | --- | --- |
| `chain10.sh` | `main4` | `marks` | `run/ab10/` (7 rounds), `run/ab10w/` (`-w`, 5), `run/objects10/` |
| `chain11.sh` | `main5` | `pr` | `run/ab11/` (7), `run/ab11w/` (5), `run/objects11/` |
| `chain12.sh` | `main5` | `pr2` | `run/ab12/` (7), `run/ab12w/` (5), `run/objects12/` |
| `chain13.sh` | `main5` | `pr3` | `run/ab13/` (7), `run/ab13w/` (5), `run/objects13/` |
| `chain14.sh` | `main5` | `pr3` | `run/ab14/` (9) |
| `chain15.sh` | `main6` | `pr4` | `run/ab15/` (9), `run/ab15w/` (5), `run/objects15/` |

`chain14.sh` repeats `chain13.sh`'s A/B with the step's options. In `chain13.sh`'s round 2 the host had no huge pages
to give either tree (38,151 and 32,141 faults in `check-input`, against 3,375 and 4,188), which its medians leave out.

`masked/masked_loads.c` times AVX-512 loads, one a page, over 16,384 base pages (`MADV_NOHUGEPAGE`) mapped for each
of 9 rounds. It ran on CPU 2 under one grant of the lock (`masked/run.owner`), built by the host's clang 23.1.1 with
`-O2 -march=znver5`.

## Results

Every run completed under its own grant. Every object is the same bytes as its main's in all six modes, and so are
the diagnostics. Medians:

| B against A | rounds | peak RSS (KiB) | task clock (ms) | user cycles (M) | kernel cycles (M) | faults |
| --- | ---: | --- | --- | --- | --- | --- |
| `marks` | 7 | 258,208 → 248,744 | 123.22 → 127.94 | 595.69 → 624.40 | 87.77 → 86.12 | 5,842 → 6,680 |
| `marks`, `-w` | 5 | 258,208 → 248,744 | 107.90 → 112.88 | 513.21 → 542.37 | 85.29 → 83.42 | 5,838 → 6,673 |
| `pr` | 7 | 258,020 → 248,344 | 123.58 → 127.99 | 597.27 → 626.01 | 86.67 → 84.38 | 5,838 → 6,639 |
| `pr`, `-w` | 5 | 258,020 → 248,348 | 108.31 → 112.97 | 513.01 → 540.78 | 86.78 → 84.94 | 5,834 → 6,633 |
| `pr2` | 7 | 258,020 → 248,352 | 123.35 → 127.30 | 595.58 → 620.53 | 87.25 → 85.39 | 5,837 → 6,650 |
| `pr2`, `-w` | 5 | 258,020 → 248,348 | 107.55 → 111.75 | 510.74 → 534.70 | 85.92 → 84.31 | 5,834 → 6,642 |
| `pr3` | 7 | 257,968 → 248,300 | 123.26 → 122.86 | 596.48 → 593.93 | 87.02 → 85.58 | 5,838 → 6,649 |
| `pr3`, `-w` | 5 | 258,020 → 248,348 | 108.05 → 105.92 | 511.81 → 502.82 | 86.08 → 84.36 | 5,834 → 6,642 |
| `pr3` (`chain14.sh`) | 9 | 258,020 → 248,348 | 123.33 → 122.28 | 596.44 → 591.37 | 86.74 → 84.97 | 5,837 → 6,649 |
| `pr4` | 9 | 258,196 → 248,284 | 122.03 → 120.43 | 591.42 → 582.72 | 86.08 → 84.25 | 5,840 → 6,650 |
| `pr4`, `-w` | 5 | 258,200 → 248,284 | 107.02 → 105.72 | 507.43 → 500.72 | 86.33 → 84.62 | 5,838 → 6,643 |

- **`marks`, `pr` and `pr2`** each cost 4.0 to 5.0 ms. `--time-stages` puts it in `check-input` (47.1 to 47.4 ms
  against 51.2 to 51.9, medians by A/B), and in it in the expressions' classes' pass (`time-check
  expressions.classes`): 0.48 to 0.49 ms of main's compile against 5.27 to 5.40 ms of each of the three. Clang had
  made `pr`'s gates branches, which `pr2`'s masks avoid, saving 0.5 ms of the 4.4.
- **The classes' pass** loads `builtins` and `specifier_finishes` at every token, ten 64-byte loads per 64 tokens, and
  `pr2` gated each by its mask of lanes, all clear where no write claimed the 64 bytes. Those loads reach the pages
  nothing writes, and stay there: a masked-off lane doesn't fault the page in, so the next load finds it missing again.
- **`pr3`** loads a static line of zeros instead (`check_input_rare_line`). Its classes' pass takes 0.41 to 0.53 ms
  in `chain14.sh`'s runs, and `check-input` 45.7 ms rather than 47.4 (medians). It is faster than `main5` in each of
  `chain14.sh`'s 9 rounds, by 0.88 to 2.42 ms, in 6 of `chain13.sh`'s 7, and in each of the 5 with `-w`.
- **`pr4`**, the pull request's code on `main6`, is faster in each of the 9 rounds, by 1.06 to 2.39 ms, and in each of
  the 5 with `-w`, by 0.75 to 2.20 ms. Its peak is 9,912 KiB lower and its kernel's cycles 1.8 M fewer, for 810 more
  faults, since base pages fault 4 KiB at a time. `check-input` takes 44.77 ms rather than 46.70, and the classes' pass
  0.43 rather than 0.48 (medians).

### The load alone

`masked/run.txt`, ticks of the 3,792.8 MHz TSC:

| load, one a page | TSC ticks a load |
| --- | ---: |
| all lanes, written pages | 35.5 |
| no lanes, written pages | 37.5 |
| no lanes, pages a read mapped to the zero page | 8.4 |
| no lanes, untouched pages | 174.1 |

At a written page, a load masked to no lanes costs what a load of every lane costs. At an untouched page it costs five
times as much, and every later load there costs the same, since a masked-off lane maps nothing. Each load here is at a
new page, so every one misses the TLB.
