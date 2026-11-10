# Executable writer boundary evidence

Baseline: `39506e8609750fa31ef5a443dea12f0d545a27c6`. Toolchain: Clang 23.1.4.
The object comparisons use ordinary Release with `BUSTER_DEBUG_INFO=0`, for
`x86-64` and `znver5`. This packet proves source and object preservation for
the isolated writer split. The parent packet supplies final integrated build
and edit-plan evidence. No runtime campaign or elapsed-time result is claimed.

## Selected proof

- `final-root-definition-preservation.txt` rechecks the final integrated source:
  all 164 original function definitions occur exactly once and are byte-identical;
  13 remain shared and 151 move into the implementation. `functions.tsv` records
  the original helper-closure classification and definition sizes.
- `scalar-object-identity.txt` records identical complete objects for DYNAMIC,
  EXECUTABLE, DRIVER and the scalar executable-benchmark stub.
  `vector-object-identity.txt` records identical DYNAMIC, EXECUTABLE, DRIVER,
  executable-benchmark, snapshot-benchmark and link-benchmark objects.
  `vector-standalone-builds.log` records the three successful standalone checks.
- `symbols/*.txt` contains the `executable_` symbol subset of those candidate
  objects, from `llvm-nm --format=posix`. Empty files mean no matching symbols.
  The full-object SHA256 comparisons above cover all other code and data too.
- `baseline-vector-owners.txt` records the original 11 unity plus 3 standalone
  dependencies. The parent packet's final dependency and edit-plan captures
  check the narrowed owners, including the configured fuzz DRIVER.
- Source SHA256 records distinguish the baseline, isolated source snapshot and
  final integrated writer files. `*-flags.argv` contains NUL-separated common
  flags reproduced from the unchanged build settings used for the object checks.

The isolated ordinary object checks preceded the final fuzz fallback and
canonical include spelling. Those later changes preserve the audited function
definitions; the final integrated object comparisons and fuzz packet cover the
combined candidate. The original receipt paths describe their capture locations.

## Reproduction

From a candidate compiler checkout, with the pinned compiler on `PATH` and the
repository's machine/core rules observed, set `proof` to this directory:

```sh
proof=/absolute/path/to/executable-boundary-selected
validation_output="$(mktemp -d)"
git show 39506e8609750fa31ef5a443dea12f0d545a27c6:src/buster/compiler/executable.c > "$validation_output/original.c"
clang -std=c17 -O2 -Wall -Wextra -Werror "$proof/tools/verify.c" -o "$validation_output/verify"
"$validation_output/verify" "$validation_output/original.c" src/buster/compiler/executable.c src/buster/compiler/executable_impl.c
BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags > "$validation_output/flags.argv"
mapfile -d '' -t flags < "$validation_output/flags.argv"
clang "${flags[@]}" -c src/buster/compiler/main_unit_dynamic.c -o "$validation_output/main_unit_dynamic.o"
sha256sum "$validation_output/main_unit_dynamic.o"
```

Repeat the final compilation for the units listed above and for `znver5`;
compare each object with its matching baseline Release-g0 object using `cmp`
and SHA256. The original C scanner is in `tools/split.c`, included by
`tools/verify.c`. Its extraction entry point and `tools/extract.c` preserve the
exploratory extraction procedure, before the final fuzz and include-spelling
adjustments; they are not final-source generators. Only the verifier is used
by the reproduction command. These original proof tools use the project's
default terms; no external implementation is imported.
