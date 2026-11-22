# Buster #2850 discarded-statement qualification

The corrected compiler at `805579ad802c57f8151c1d435109a555d62f86e8` matched the reference in 6,164 compiler comparisons on Linux x86-64. The trials exercised the 8,192-token threshold, including the original native exception-return and typed-dump regressions. The 112 executions in the fully sequenced native suite also matched Clang 23.1.4.

The reference executable came from `fbef2d68dfc952c269d7a2fd008220341428e727`. Its `src/` tree is identical to the candidate's parent before this series, `0e1d5b825801135bf50e79da9d546bc95209ab30`. The correction landed in `7afa8ba723efe888c41cfef3005d194f9c202afc`. The final commit adds its regression test. `compilers.json` records the executable and predefined-header SHA-256 values.

| Suite | Source units | Comparisons | What was checked |
| --- | ---: | ---: | --- |
| Focused | 28 | 336 | Native objects, text assembly, typed dumps, debug information, poison arenas, verification, Tier 1 and diagnostics across 12 modes |
| Driver options | 30 | 420 | The 28 focused units plus two diagnostic pragma units across 14 option sets, including scalar, attested, deferred and selection census |
| Warnings | 128 | 384 | 8,464 generated expression statements, with three diagnostic policies per unit |
| Repository fixtures | 2,400 | 4,800 | Native compile and `-Weverything` syntax checks. The reference emitted 1,191 native objects and 3,266 nonempty diagnostic streams |
| Original native generator | 28 | 112 | Native object and runtime comparison in four modes. The reference and candidate also matched Clang in 48 runs |
| Sequenced native generator | 28 | 112 | Same four modes with the GNU statement-expression and `_Generic` results assigned to temporaries before updating the accumulator. All 112 executions matched Clang |

Each source has a generated prefix of 2,050 to 2,055 four-token typedef declarations. `sources.jsonl.gz` stores the source body, prefix parameters and full source hash. The 2,400 repository fixtures also identify their source file in `src/buster/compiler` and the character offset of their C string literal. `modes.json` specifies the exact flags. The package includes 2,614 source records because the driver options reuse the focused cases.

The comparison checks process status, stdout, diagnostics and native output bytes. A rejected source can exercise diagnostic parity. Exactly 26 successful selection censuses emitted cycle measurements. Their `selection-census-ticks` lines varied between executions. Every remaining census line matched byte for byte, as did the accompanying objects. The raw stderr comparison and stable stderr comparison are both retained. This package measures correctness. It contains no throughput timings.

## Validate the published receipts

From this directory, run the following commands with Python 3.9 or later.

```sh
sha256sum -c SHA256SUMS
python3 -B verify_receipts.py
```

`receipts/` contains the six original compressed tables and the earlier failing cases. `receipts/real.tsv.gz` records the reference status and SHA-256 digests together with the byte comparison. The other tables have a row for each compiler. `receipts/sequence.tsv.gz` includes the actual output and Clang's expected output for every native execution.

## Replay locally

Use the two built Buster executables with their usual `build/predefines.h`, and a native Clang driver that can link and run x86-64 executables against the host C library. The executable names below are placeholders for their absolute paths. On a host managed by `cores`, prefix the Python invocation with `cores -n 1 --`.

```sh
python3 replay.py \
    --reference /path/to/reference/build/compiler \
    --candidate /path/to/candidate/build/compiler \
    --clang /path/to/llvm-23.1.4/bin/clang \
    --output /tmp/buster-2850-replay
```

The output directory must be new or empty. The command writes `replay.tsv`, prints totals per suite, and exits nonzero on a compiler divergence or sequenced Clang mismatch. A subset can be selected with `--suite focused --case ehreturn`. Exact debug-object digests may depend on the working path. The runner compiles identical paths with both executables and compares the resulting bytes directly.

## Historical regressions

Two earlier candidates lost a numbered implicit void row from `--dump-typed -c` for `x++`. The earlier binaries also changed the native object for `(void)__builtin_eh_return(offset, target)`. The first two historical binaries in `compilers.json` have production source identical to `5180639ec` and `642dd7c7f` respectively. Their individual checkouts add only checker-test inventory changes. The later bitmap and statement-head revisions were tested at their exact hashes.

| Historical production revision | Increment dump | Standalone call dump | Explicit void-cast exception-return object |
| --- | --- | --- | --- |
| `5180639ec` | Changed | Matched | Changed |
| `642dd7c7f` | Changed | Changed | Changed |
| `49bb4d89d` | Changed | Changed | Changed |
| `e822b812e` | Changed | Changed | Changed |

The same dump differences occurred under `--scalar`. For the historical exception-return source, all four emitted object SHA-256 `6e25f09762fcbba1c8e437566c35c9256230aba367c850aef8e0f62a1ea8d9bb`. The reference emitted `5254b6695e1bf615c356e98363c2f49ffc3c889fc7126e886ba402ef645d255b`. The three historical inputs, five native objects and selected typed outputs are in `receipts/historical-witnesses.tar.gz`.

## Fixture attribution

The repository fixtures come from Buster checker tests at `fbef2d68dfc952c269d7a2fd008220341428e727`, copyright 2026 David Gonzalez Martin, under Apache-2.0 WITH LLVM-exception. See `LICENSE` and `LICENSES/LLVM-exception.txt`.
