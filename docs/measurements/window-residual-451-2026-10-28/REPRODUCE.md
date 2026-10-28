# #451 record layout and reproduction

`RESULTS.md` is the disposition/report. `LOCAL-RESULTS.md` describes local
acceptance only. `NATIVE-PLAN.md` binds the exact native binary, source,
toolchain, input directories and environment; its commands preserve the
distinction between a configuration comparison and a source optimization.

`native-commands.txt` contains every fully expanded whole/phase command and
lock invocation. `native-gate-commands.txt` contains the three native gate
commands. `native-layout-gate-command.txt` is the separate byte-identical
proper-layout rerun of the PP gate; it does not replace the negative original
tag. `native-audit-commands.txt` preserves both status-schema audit attempts.
The per-operation `*.receipt`/`*.log` files retain lock receipts, command
arguments, UTC bounds and diagnostics. Complete native child stdout, stderr,
status and strict summaries are in the separately transferred native raw
archive. A failed pipeline stops the runner; it does not silently skip a cell.

The original C work-count helpers are `harness/make451.c`, `prepare451.c` and
`deps451.c`. `make451` is passed the exact compiler source directory and an
output directory; it copies main and the preprocessor, preserving all text
except the explicitly guarded linkage/include substitutions and counters.
It requires exactly one match for each substitution. Never use the generated
copies as a performance candidate. Counter values describe logical ranges.

A source-level reproduction recipe for the helper (not a claim that changing
paths/debug prefixes recreates the exact recorded ELF bytes) is:

```sh
# Run on a compatible x86-64 host; SRC, RUN and TOOL follow NATIVE-PLAN.md.
export PATH="$TOOL/bin:$PATH"
export LD_LIBRARY_PATH="$TOOL/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export SOURCE_DATE_EPOCH=1
export BUSTER_CLANG_RESOURCE_DIR="$("$TOOL/bin/clang" -print-resource-dir)"
unset MAKEFLAGS MFLAGS GNUMAKEFLAGS
cd "$SRC"
"$TOOL/bin/clang" -O2 -Wall -Wextra -Werror "$RUN/harness/make451.c" -o "$RUN/harness/make451"
"$RUN/harness/make451" "$SRC/src/buster/compiler" "$RUN/harness"
"$TOOL/bin/clang" -O2 -g -march=native -Isrc -Isrc/buster/compiler \
  -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror \
  -ffunction-sections -fdata-sections "$RUN/harness/prepare451.c" \
  -Wl,--gc-sections -lm -ldl -o "$RUN/harness/prepare451-native"
```

The direct-file helper takes paths to SQL, the current encoder and the two
generated inputs. It checks whole/scalar/window records and token line queries
at 64, 4096 and 131072-byte windows. Its `--preprocess` route takes the ordinary
`-E` argument list in NATIVE-PLAN.md, including a distinct `-o` file. The printed
`status=1` in this route is the internal boolean true; the recorded process
status must be zero, and the complete output must match the compiler output.
Whole mode has zero *window-domain* range counters, not zero total lexer work.

The generator `generate451.c` is copied unchanged from the first-party #486
record. Inputs `long-lines OUTPUT 8000000 451` and `spliced OUTPUT 8000000 451`
reproduce the historical hashes in RESULTS.md. Current source-file sizes and
include closures differ from the older campaign and must not be substituted
for its source-attribution experiments.

`whole451.c` reads one raw 21-pair stdout log. It rejects nonzero statuses,
missing/duplicate cells or footer, invalid fields and mixed executable labels.
It retains all resource fields and disables PMU aggregates when any counter
is unavailable. `phase451.c` takes four distinct process stdout paths in the
order windows1, whole1, whole2, windows2, checks complete 21-pass results and
equal token counts, then reports both process ranges. Both readers are small
original C programs; compile with `clang -O2 -Wall -Wextra -Werror ... -lm`.

`negative451.c` injects one explicit protocol fault into a saved log. The
`local/analyzer-controls` receipts are method tests: the tiny valid local
cohort and duplicated local phase-shape inputs never count as native timing
samples. Four whole-log negatives and two phase negatives must be rejected;
the explicit unavailable-PMU marker is accepted with PMU aggregates suppressed.

Original helper code uses Apache-2.0 WITH LLVM-exception. Generated source
copies retain their source notices and exact e7 provenance. Their transitive
compiler includes retain the component inventory and notices at that source
pin; they are not relabeled as entirely first-party. No external implementation
or fixture corpus was imported for the new helpers. The SQL/header/tool
packages remain external dependencies, with their original terms.
