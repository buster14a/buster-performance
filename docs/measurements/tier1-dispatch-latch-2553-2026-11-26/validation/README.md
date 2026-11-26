<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->

# #2553: CFG convention regression and certificate validation

This record contains correctness and regression evidence for the carried-phi
convention change in `buster14a/buster`. It contains no runtime performance or
compile-throughput measurements. It does not establish #2553's 9700X acceptance
criteria, and the session did not access or queue that host.

## Source and environment

- Date: 2026-11-26.
- Candidate: `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167`.
- Base: `8e4d32879e17b7d9548cad54257a2f8461328366`.
- Host: a cloud VM reporting Intel Xeon Platinum 8370C, x86-64, with the
  AVX-512 extensions required by `src/buster/compiler/host_isa.h`.
- Kernel reported by the environment: Linux 6.18.57.
- Clang: 23.1.4, LLVM revision
  `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, target
  `x86_64-unknown-linux-gnu`.
- All runs were single-process standalone CFG test programs. They did not
  exercise the complete compiler driver or compile SQLite/Lua.

Source file SHA-256:

| Revision | File | SHA-256 |
| --- | --- | --- |
| Candidate | `src/buster/compiler/tier1_cfg.c` | `061ae54b6bb7298f555b9fb3c5723fba020707102c538c1e150cdb9d12d5d246` |
| Candidate | `src/buster/compiler/tier1_cfg_test.c` | `12cbadb6c0680799b892eb1c4871719005fc182640899b25bc62f625ff7c686e` |
| Base | `src/buster/compiler/tier1_cfg.c` | `9a90d0604d2692932596b5b61746054492754a7d0b62dfe4ef26dd3821493770` |
| Base | `src/buster/compiler/tier1_cfg_test.c` | `b6496a16481af3e720e28dd0749fa140aa0c4e13d326e2ba056fc6958d6fdde8` |

The focused fixtures were added by the candidate, so the focused executable
must use that revision's test file. The negative-control run disables the new
production branch in a temporary source copy; it is a mutant of the candidate,
not a second complete compiler built from the base.

## Recorded results

| Run | Build | Result |
| --- | --- | --- |
| Full CFG suite, seed 140, count 2000, oracle every 16 | `-O3` | 107,813 checks, 0 failures; exit 0 |
| Focused helper and loop fixtures, both certificate checkers | `-O3` | 304 checks, 0 failures; exit 0 |
| Same focused cases under ASan and UBSan | `-O1`, address/undefined sanitizers, no recover | 304 checks, 0 failures; exit 0 |
| Same focused cases with the new carried-operand branch disabled | `-O0` | 304 checks, 4 expected failures; exit 1 |

The full suite produced 1,884 allocations whose certificates were proved,
including 171 also checked by the independent slow oracle. Dense and sparse
liveness produced the same allocations in 2,072 cases, and 2,003 sparse live
lists matched the independent walk. Its existing mutation checks rejected all
1,863 interference, 716 ordering, 206 definition, 28 split-destination, 1,586
opmask-k0 and 598 shared-slot mutants. The complete tallies are in
`logs/cfg-full.log`.

LeakSanitizer cannot inspect threads under this container's ptrace restrictions.
The successful sanitizer run therefore used `ASAN_OPTIONS=detect_leaks=0`.
AddressSanitizer and UndefinedBehaviorSanitizer remained enabled; this record
does not claim leak checking.

## What the focused tests check

`tier1_cfg_test_dispatch_latch` builds an eight-block loop. Three handlers pass
the dispatch header's phi unchanged into its latch, while the nearest
predecessor in layout supplies a different recipe. The cold path moves the
carried value to another register, so the existing settled-register alternate
cannot choose the original convention by itself. A phi in the cold block keeps
its interval separate from the preceding handlers' interval: an exit hint names
an interval's closing register.

The fixture runs with the cold predecessor first and last in the predecessor
row. The positive variants require the unchanged handler edges and the latch to
header edge to move nothing. Negative variants replace one unchanged input with
`undef`, leaving two out of four inputs; they must retain the ordinary
predecessor convention. The independent verifier, the allocation certificate
checker and its slow oracle check the allocations and the existing mutants.

`tier1_cfg_test_carried_predecessors` places both input columns immediately
before inaccessible pages. It checks row lengths 0, 1, 2, 3, 15, 16, 17, 31, 32
and 33, strict ties, zero-valued operands, predecessor block zero, reversed
predecessor ordering, and the absence of an earlier matching predecessor.

The negative-control run fails the two positive allocation assertions in each
predecessor ordering. Its other focused checks remain passing. In the retained
trace, latch interval 3, value 3, spans `[40,48)`:

- Candidate: value hint 4, EXIT interval 4 over `[8,32)`, encoded
  `0x80000004`.
- New branch disabled: value hint 2, EXIT interval 2 over `[37,40)`, encoded
  `0x80000002`.
- Both retain alternate interval 4.

These observations concern the synthetic regression's allocation. They are not
SQLite/Lua instruction counts or hardware timing results.

## Files and provenance

`cfg-validation.c` is an original small driver under
Apache-2.0 WITH LLVM-exception. It includes the implementation and independent
tests from the pinned compiler checkout; it imports no third-party compiler
implementation or fixture. Included compiler components retain the licenses
recorded in that checkout's `LICENSING.md` and `THIRD_PARTY_NOTICES.md`, including
the MIT terms for `lane.c`.

`logs/original/` preserves the recorded stdout/stderr files. The original O3 and
mutant drivers also printed the seven interval trace rows shown above, using a
temporary copy of the test source with only those `printf` calls added. The logs
directly under `logs/` remove only lines beginning `trace: interval `; all test
results and diagnostics are retained. The packaged driver uses the unchanged
candidate test source and does not print that incidental trace.

The packaged driver was rebuilt against the pinned candidate and run with each
recipe below. All four resulting logs matched the corresponding cleaned logs
byte for byte, including the mutant's expected exit status of 1. `SHA256SUMS`
covers the driver, this document and both sets of logs.

## Reproduce

Use a separate checkout at the exact candidate commit and an AVX-512 host with
the required extensions. Set absolute paths for the compiler checkout, this
record and Clang 23.1.4. The commands below leave the compiler checkout's tracked
files untouched.

```sh
cfg_buster=/absolute/path/to/buster
cfg_record=/absolute/path/to/this/record
cfg_clang=/absolute/path/to/clang-23.1.4/bin/clang
cfg_work=$(mktemp -d)
cd "$cfg_buster"
test "$(git rev-parse HEAD)" = d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167
"$cfg_clang" --version
sha256sum src/buster/compiler/tier1_cfg.c src/buster/compiler/tier1_cfg_test.c

"$cfg_clang" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O3 -Wall -Werror -Wno-unused-function \
    -Isrc "$cfg_record/cfg-validation.c" \
    -o "$cfg_work/cfg-validation" -lpthread -lm
"$cfg_work/cfg-validation" --focused > "$cfg_work/focused.log" 2>&1
"$cfg_work/cfg-validation" --seed 140 --count 2000 --oracle-every 16 \
    > "$cfg_work/full.log" 2>&1
```

The expected successful counts are 304 and 107,813 respectively. No wall-clock
threshold is imposed.

For the focused sanitizer run:

```sh
"$cfg_clang" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O1 -gline-tables-only -Wall -Werror \
    -Wno-unused-function -fsanitize=address,undefined \
    -fno-sanitize-recover=all -fno-omit-frame-pointer \
    -DBUSTER_CFG_FOCUSED_ONLY=1 -Isrc "$cfg_record/cfg-validation.c" \
    -o "$cfg_work/cfg-sanitize" -lpthread -lm
ASAN_OPTIONS=detect_leaks=0 "$cfg_work/cfg-sanitize" \
    > "$cfg_work/sanitize.log" 2>&1
```

For the negative control, disable only the new carried-operand branch in a
temporary copy. The helper remains available to its direct bounds tests:

```sh
sed 's/const bool carried = along \&\&/const bool carried = false \&\& along \&\&/' \
    src/buster/compiler/tier1_cfg.c > "$cfg_work/tier1_cfg_no_carried.c"
test "$(rg -c 'const bool carried = false' "$cfg_work/tier1_cfg_no_carried.c")" = 1
"$cfg_clang" -march=native -std=gnu17 -fwrapv -funsigned-char \
    -fno-strict-aliasing -O0 -Wall -Werror -Wno-unused-function \
    "-DBUSTER_CFG_SOURCE=\"$cfg_work/tier1_cfg_no_carried.c\"" \
    -Isrc -Isrc/buster/compiler "$cfg_record/cfg-validation.c" \
    -o "$cfg_work/cfg-mutant" -lpthread -lm
cfg_status=0
"$cfg_work/cfg-mutant" --focused > "$cfg_work/mutant.log" 2>&1 || cfg_status=$?
test "$cfg_status" -eq 1
cat "$cfg_work/mutant.log"
```

The expected result is `checks=304 failures=4`, with the two positive assertion
messages repeated once for each predecessor ordering.
