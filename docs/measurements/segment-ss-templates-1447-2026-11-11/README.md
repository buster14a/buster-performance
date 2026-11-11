# SS's segment override as a fourth encoder template set, Buster #1447 (PR #2158)

PR [#2158](https://github.com/buster14a/buster/pull/2158) gives the x86 encoder a fourth template set, SS's (`36`,
address space 258), for the 7,694 form rows that fit under the fixup flag in bit 15 of `X86Instruction.form`. Its
marked copies grow the baked table by 492,416 bytes (`test-baked-tables`: 5,378,496 to 5,870,912). This record checks
that segment-free compiles and the encoder's loop are unchanged, base against head, on the 9700X.

## Sources and host

- **base:** main `1236be12193ad224529e78fb4242474a5ce1e8ba`, the branch's base.
- **head:** `42fdf39a2d67c0dc49113cc7857639c1536fbf38`, #2158's commit.

Each tree is a fresh clone at its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock.
`logs/receipt.txt` has the executables' SHA-256 and sizes (67,138,096 against 67,653,816 bytes), the CPU (AMD Ryzen 7
9700X), the kernel, clang and CPU 2's governor. The inputs are the 9700X job's frozen `sqlite3.c`, with the job's `-D`
options, and the base tree's `src/buster/compiler/main.c` (`-c -march=native -I... -fwrapv -funsigned-char
-fno-strict-aliasing`), the same source for both compilers.

## Method

- `scripts/setup.sh` and `scripts/all.sh`, each build and run under the lock on its own:
  - both builds;
  - `test-baked-tables` and `test-x86-encoder` on each (`logs/tests.log`);
  - `-c` of each input by both trees, pinned to CPU 2 (`logs/compile.log`), and the objects' SHA-256 (`logs/objects.sha256`);
  - three interleaved rounds of `benchmark-x86-encoder` (`logs/encoder.txt`).
  - `all.sh`'s final `ab --rounds 15` was killed while waiting on the shared lock (exit 143), after no completed run.
- `scripts/perf.sh`: five interleaved rounds of `perf stat -e instructions:u,cycles:u,task-clock` of the same `-c`,
  pinned to CPU 2, each run under the lock on its own (`logs/perf.tsv`: round, tree, input, instructions, cycles,
  task-clock in ms).

## Results

- **Objects:** byte-identical base against head: sqlite3.c `5c6e1e7b…a628ca`, main.c `b40097cf…a437f`. Both trees
  pass `test-baked-tables` and `test-x86-encoder`.
- **`-c` instructions (user), five rounds:**
  - sqlite3.c: base 1,279,914,391–969,376 against head 1,279,914,412–915,264. Base's first round is 55k high; the others
    agree to within 30.
  - main.c: base 10,016,840,261–866,310 against head 10,016,651,871–678,014, −180,000 (−0.002%).
- **Time (task-clock, ms):**
  - sqlite3.c: rounds 2–5 are 118.07–119.08 against 118.01–119.10. Round 1 is 148.95 against 125.49, a cold first run.
  - main.c: 654.73–661.44 against 652.38–657.23.
  - No difference past the rounds' spread.
- **`benchmark-x86-encoder`, ns per instruction over three rounds:**

  | variant | base | head |
  |---|---|---|
  | `x86_encode_16`, production | 0.526 / 0.541 / 0.535 | 0.547 / 0.560 / 0.545 |
  | `x86_encode_64` | 0.543 / 0.549 / 0.540 | 0.551 / 0.545 / 0.539 |
  | scalar | 12.88 / 12.84 / 12.88 | 12.57 / 12.62 / 12.61 |

  - Every variant executes the same instructions per encoded instruction in both, for example 12.63 for `x86_encode_16`.
  - `x86_encode_16`'s rounds don't overlap (head about 2–3% slower), `x86_encode_64` doesn't move, and the scalar encoder
    is 2% faster. That pattern is placement, not work, and the compiles above don't show it.

## Limitations

Five rounds on a lock shared with CI and other sessions. The timing claim is only that no difference shows at this
spread. The `ab` run that `all.sh` started did not complete.
