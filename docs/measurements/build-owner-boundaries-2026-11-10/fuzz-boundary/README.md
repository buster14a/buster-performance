# Final integrated fuzz interface evidence

This selection validates the final source/backend, preprocessor and executable
boundaries against the production/build-input SHA256 manifest included here.
The base is `39506e8609750fa31ef5a443dea12f0d545a27c6`; the parent packet identifies
the integrated candidate. Tools were Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2.
No complete fuzz executable was linked or run, and no runtime campaign or
elapsed-time result is claimed.

## Scope and records

The default scalar DRIVER compiled to a native object using the supported
address, undefined-behavior and bounds sanitizers, use-after-scope/return checks,
libFuzzer coverage, `-O3` and line tables. All eleven default fuzz unity units
also passed syntax checking for both `x86-64` and `znver5`.

Warnings are preserved according to the supported host policy. The scalar
configuration intentionally suppresses unused vector-helper and ABI warnings;
the vector configuration retains them. These are the same settings in the
actual CMake builds and in `print-compile-flags`:

| Host | Original default/custom fuzz flags and actual CMake flags |
| --- | --- |
| `x86-64` | `-Wall -Werror -Wno-unused-function -Wno-psabi` |
| `znver5` | `-Wall -Werror`, with neither suppression |

The final vector checks were also repeated with explicit `-Wunused-function`
and `-Wpsabi` appended after the printed flags: all eleven default unity units and
the custom callback passed. The original scalar and vector receipts retain
their original printed-flag scope. No warning policy or source was changed.

`custom_entry.c` reuses the default callback's checker pipeline and accesses
private token storage, history and executable helpers. Its syntax check passed
with the real custom-entry flags in both host modes. This is a compile-only
compatibility probe, not a separately executed fuzz campaign.

- `final-validation.txt` records completion and the native object hash;
  `native-object.sha256` retains the raw hash receipt. The object is excluded.
- `*-flags.argv` and `sources.argv` retain the exact NUL-separated arguments
  and build source inventory. Absolute entry paths identify the original
  snapshot; regenerate flags when reproducing in a different checkout.
- `final-source-sha256.sorted.txt` and `current-root-source-sha256.sorted.txt`
  are identical production/build-input manifests captured at validation.
- `final-x86-64/` and `final-znver5/` hold all eleven actual preprocessing
  dependency records and their preprocessing/syntax logs. Logs are empty on
  successful compilation. `final-owner-subset.tsv` gives the key owner sets.
- `main-final-default.d` is the native DRIVER's dependency record; it equals
  `final-x86-64/main.c.d`. Native and custom-entry compiler logs are retained.
- `main-final-default-symbols-selected.txt` identifies the callback, main and
  sanitizer/coverage references. The `.txt.gz` file retains the complete
  `llvm-nm` text; `uncompressed-symbols.sha256` identifies its original bytes.
- `warning-policy/` contains actual ordinary and fuzz CMake DRIVER rules,
  decoded printed flags, the settings source excerpt, configure logs and exact
  comparison receipts. The fuzz CMake `FLAGS` strings match the printed default
  flags after decoding Ninja quote escaping, converting the absolute include
  path to `-Isrc`, and removing CMake's source-path mapping. CMake's separate
  generated `CMAKE_INTDIR` definition is visible in the retained rules.
- `znver5-*-strict-flags.argv`, `strict-znver5/` and
  `vector-explicit-warning-exit-status.tsv` retain the explicit vector warning
  rerun arguments and all twelve successful results.
- `unsupported-scalar-warning-override/` records the exploratory scalar DRIVER
  syntax failure caused by overriding both intended suppressions. It stopped
  on unused vector helpers. This is outside the supported scalar settings;
  no native build was attempted under the override and no baseline control
  was run. It does not invalidate the supported scalar compilation above.
- `warning-policy-validation.txt` records this final diagnostic review, and
  `strict-root-source-sha256.sorted.txt` confirms the production/build inputs
  still match the validated snapshot.

The full source patches and older intermediate checks are omitted. The source
manifests and parent packet identify the tested candidate; the patch hash in
the original validation receipt records the local frozen snapshot operation.

## Reproduction

From the candidate compiler checkout, with the pinned tools on `PATH`, observe
the repository's machine/core rules and run one compiler process at a time:

```bash
proof=/absolute/path/to/fuzz-boundary-selected
validation_output="$(mktemp -d)"
for arch in x86-64 znver5; do
    BUSTER_HOST_ARCH="$arch" BUSTER_FUZZ_AVAILABLE=1 BUSTER_SANITIZER=address \
        ./build.sh configure
    BUSTER_HOST_ARCH="$arch" BUSTER_FUZZ_AVAILABLE=1 BUSTER_SANITIZER=address \
        ./build.sh print-compile-flags > "$validation_output/$arch.argv"
    mapfile -d '' -t flags < "$validation_output/$arch.argv"
    if [ "$arch" = znver5 ]; then flags+=(-Wunused-function -Wpsabi); fi
    for source in src/buster/compiler/main.c src/buster/compiler/main_unit_*.c; do
        clang "${flags[@]}" -fsyntax-only "$source"
        clang "${flags[@]}" -E -MD -MF "$validation_output/$arch-${source##*/}.d" \
            -MT "${source##*/}.o" "$source" -o /dev/null
    done
    BUSTER_HOST_ARCH="$arch" BUSTER_FUZZ_AVAILABLE=1 BUSTER_SANITIZER=address \
        BUSTER_FUZZ_ENTRY="$proof/custom_entry.c" ./build.sh print-compile-flags > "$validation_output/$arch-custom.argv"
    mapfile -d '' -t flags < "$validation_output/$arch-custom.argv"
    if [ "$arch" = znver5 ]; then flags+=(-Wunused-function -Wpsabi); fi
    clang "${flags[@]}" -fsyntax-only src/buster/compiler/main.c
done
mapfile -d '' -t flags < "$validation_output/x86-64.argv"
clang "${flags[@]}" -MD -MF "$validation_output/main.d" -MT main.c.o \
    -c src/buster/compiler/main.c -o "$validation_output/main.o"
llvm-nm "$validation_output/main.o" > "$validation_output/main-symbols.txt"
```

Line tables and sanitizer metadata contain source locations, so a different
checkout path can change the object hash. Compare source identities, successful
compilation, interfaces, dependency sets and instrumentation records under the
same toolchain and flags. The custom probe is original project material under
the default terms and imports no external implementation.
