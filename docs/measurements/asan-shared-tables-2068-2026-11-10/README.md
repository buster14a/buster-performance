# The address row with shared x86 tables (buster#2068), 2026-11-10

These are the measurements behind buster PR #2068's change. Under AddressSanitizer, the units of their own share main.c's x86
encoder and semantics tables instead of keeping 33 private copies (117 MB of `.bss` that LeakSanitizer reads at every
process's exit). Host, options and method are the same as in `asan-driver-2030-2026-11-10`: an AMD Ryzen 9 7940HS
laptop (Zen 4), CI's sanitizer options, each run on cores of its own through the `cores` queue.

## Executables

`trees.txt`: `compiler-fixed4` is the address build of buster PR #2067's head; `compiler-2068` is the address build of
the #2068 branch, which is on a later main (`ded03162`) plus the change. The comparison therefore also spans main's
commits between the two. None of those commits changes the startup or the encoder.

| | `compiler-fixed4` | `compiler-2068` |
|---|---:|---:|
| `.bss` | 201.9 MB | 84.6 MB |
| `x86_template_storage*` copies | 38 (134.1 MB) | 5 (17.6 MB) |

## Results (`scripts/check-2068.sh`)

- **Per process** (`results/percall-2068.txt`): 40 `-c` compiles of a two-function file, alternating, two rounds.
  With THP on: 70.4 and 70.9 ms against 48.3 and 49.3 ms. Without THP: 72.9 and 76.0 ms against 48.3 and 52.0 ms.
- **Driver part 1/16** (`results/driver-part1.txt`): both builds at the same time on two cores, without THP, two
  rounds: 108.9 and 113.3 s against 82.1 and 83.2 s, 2,427 checks each, 0 failures.
- **Units of their own under ASan** (`results/units-2068.txt`): `test-baked-tables`, `test-tier1-select --manifest`
  then `measure-tier1-model --verify` (1,518 cases), `benchmark-x86-encoder --count 4096` in 64-, 32- and 16-bit
  modes, and `benchmark-x86-semantics --requests 4096 --functions 256`. All exit 0, with 0 sanitizer reports.

## Plain builds

The change is a preprocessor condition on `__has_feature(address_sanitizer)`. A benchmark unit
(`bind_benchmark.c`), `main_unit_checker.c` and `tier1_model_measure.c` were preprocessed with the plain flags from
copies of `src` before and after the change. After normalizing `assert`'s file argument (the copies' directories) and
line number (the change adds lines), the output is the same. With the address flags, only the benchmark unit's
`BUSTER_X86_SHARED` declarations differ (`static` to `extern hidden`). That comparison was run by hand and not kept as
a file.

## Limitations

- One laptop, not a hosted runner.
- The two executables' trees differ by main's intervening commits, besides the change.
