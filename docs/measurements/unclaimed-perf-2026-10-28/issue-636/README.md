# Diagnostic batching, issue 636

Local work from Buster `bc1b486150850fe00bad1361a19f57d67706bb3b`, 2026-10-28.
Implementation: `60ff4b259cc98912f819ade74f92b864e723eb25`.
The source change and all fixtures/helpers are original project material under
Apache-2.0 WITH LLVM-exception. Clang, libc, strace and tcc execute externally;
no external implementation or input corpus is incorporated.

`probe.c` generates three original 4,000-diagnostic workloads and records fresh
process wall time, user/system CPU time, peak RSS and successful exit status.
The two roles rotate each round. `file` overwrites a regular diagnostic file;
`pipe` drains stderr through a pipe in the parent. The timed interval includes
process creation, full `-c`, real object output, diagnostic writes and teardown.
It does not include strace. Basename `tcc` selects its ordinary `-c` interface;
other executables use Buster's explicit `--lanes 1` control.

Build the helper with:

```sh
clang -std=c17 -D_DEFAULT_SOURCE -O2 -Wall -Wextra -Werror probe.c -o probe
./probe generate DIRECTORY 4000
./probe measure BASELINE CANDIDATE DIRECTORY/warnings-4000.c file 11 DIRECTORY
./probe measure BASELINE CANDIDATE DIRECTORY/warnings-4000.c pipe 11 DIRECTORY
```

Repeat for `redefinitions-4000.c` and `overflow-4000.c`. For a tcc reference,
compare CANDIDATE and the absolute tcc path (tcc emits no overflow warnings,
so that case is not an equal diagnostic workload).

Collect syscall records independently for each compiler/workload:

```sh
strace -qq -f -e trace=write,writev,pwrite64 -o TRACE COMPILER --lanes 1 \
  -c INPUT -o OBJECT >STDOUT 2>STDERR
```

Count only `write(2,` records for stderr, keeping object writes separate.
Compare both STDOUT/STDERR and OBJECT bytes between baseline and candidate.
Do every target build/test/measurement through the 9700X shared exclusive lock,
one run per lock acquisition, with CPU 2 for single-threaded measurements.
Local laptop timings are screening evidence, not target qualification.

## Completed local checks

- Full 41-unit `BUSTER_DEBUG_INFO=0` build and final syntax check pass.
- `test-preprocessor --clang` passes, including all 36 exact Clang history
  diagnostic fixtures, both kernels, all 90 buffer cases and 3,000 C17/C23
  differential fuzz cases.
- The focused buffer adapter passes ASan/UBSan with leak detection and
  undefined-behavior halt enabled.
- All three workload objects, stdout and stderr are byte-identical to the
  baseline. Stderr syscall counts are warning **16,000 → 4,000**,
  redefinition plus note **23,994 → 3,999**, and overflow **16,000 → 4,000**.
  These count exactly one stderr write per primary diagnostic with its notes.
- Eleven rotated fresh-process samples per role and workload/sink are in
  `local-*.jsonl`; `local-tcc-*.jsonl` retains the external tcc orientation.
  Runs used the busy shared Ryzen 9 7940HS, without target timing isolation.
  `local-medians.json` has per-role wall/user/system/RSS medians. The new
  compiler's system time falls on all three workloads with either sink.
- The no-diagnostic `int a;` control is retained separately. The initial busy
  laptop screen was 3.672 → 4.200 ms; a later granted-core 41-pair screen was
  3.398 → 3.657 ms (system CPU 2.014 → 2.280 ms). Rendering is unused on this
  input, and executable placement changes, but these observations do not
  establish neutral startup. An isolated target control is required before
  accepting a no-regression claim.
- `build.log` is an incomplete development build that observed a test edit
  before it was finished; its errors are not current-head failures.
  `build-final.log` records the successful complete build.

The permanent `test-preprocessor` checks include 90 buffer/message-size cases
against independent piecewise stdio rendering, a caller-supplied unbuffered
stream, immediate output, quiet counters and a primary line plus attached note.
Existing Clang history fixtures check actual includes, presumed locations,
macro origin notes and explicit definition notes on both paths.

`buffer_sanitize.c` is a focused adapter to those permanent tests. It includes
the actual repository implementation, rather than maintaining a copy. Build
from the compiler checkout with `-O1 -g -march=native -Isrc -fwrapv
-funsigned-char -fno-strict-aliasing -Wall -Werror -fsanitize=address,undefined
-ffunction-sections -fdata-sections`, linking `-Wl,--gc-sections -lm -pthread`.
