# The Zen 5 model's FLD1 row (buster#1387, buster#3345)

buster#3140 emits `FLD1` for a positive x87 one, but the model (`x86_zen5_rows.c`) had no `FLD1/REGISTER` row.
buster#3345 adds the case: `FLDZ`'s fixture (a push and the `fstp st0` that pops it) and a row of `U` values, which this
measurement fills.

## Method

- Host: benchpress, Ryzen 7 9700X, CPU 2, under the host lock (`exclusive.sh`), 2026-11-23 00:22 UTC.
- Build: buster main `4704727a179ef530eb9a7b61a4276c8b06508166` with [`fld1.patch`](fld1.patch) applied,
  `BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, Clang 23.1.4 (the 9700X job's toolchain).
- One process: `taskset -c 2 ./bin/fld1 measure-x86-zen5 --missing --table`, then `--only FLD1/REGISTER` and
  `--only FLDZ/REGISTER` (scripts [`all.sh`](all.sh) and [`build2.sh`](build2.sh)).
- benchpress's root filesystem was full (`df /`: 473 G of 475 G, 64 KiB free at one point), so the tree was built in
  tmpfs (`/tmp/c1341`) and only the executable kept. The executable doesn't depend on where it was built.

## Result

[`zen5-missing-table.txt`](zen5-missing-table.txt) is the whole rows file as the process printed it; its one new row:

```
X(FLD1, REGISTER, U, 280, 256, U, U, 256, 256, 0x40, 0x26, 0x19)
```

That's `FLDZ`'s row exactly. [`zen5.out`](zen5.out) has the `--only` runs: in both forms, a push and its pop take
1.105 cycles independently and 1.109–1.150 in the mixes, with 2.00 retired ops and 2.00 FP ops per unit. The load
average at the start was 4.32 (`zen5.out`'s first line); `exclusive.sh` listed no other busy processes as it took the lock.
`zen5-missing.err` is empty.
