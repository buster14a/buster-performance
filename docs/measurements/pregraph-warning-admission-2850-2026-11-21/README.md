# Warning eligibility before expression graph allocation

The experimental compiler selected complete integer and pointer returns and discarded expressions from a source window before the reader assigned graph node numbers for the chunk. Every admitted expression in the four corpora and 45,327 fixture compilations had a successful ordinary T and C/X result, zero warning and ownership refusal keys, and zero checked stream warning bits. Its pregraph values matched the checked stream comparison. The code runs in the diagnostic shadow. [Buster #2850](https://github.com/buster14a/buster/issues/2850)

| Default warning configuration | Return roots | Discard roots | Records across both kinds | Unsafe admissions |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 3,041 | 23,329 | 137,236 | 0 |
| Lua | 699 | 3,297 | 20,860 | 0 |
| musl | 8,843 | 5,591 | 55,549 | 0 |
| Buster compiler | 1,274 | 8,284 | 56,080 | 0 |

The old reader first populated its root list after ordinary T accepted an expression. The window tests also consulted the typed flag indexed by its graph root. The context pass selected only expressions with a recorded ordinary C run. These conditions were unavailable before graph construction.

The probe enumerates new front roots with complete operand spans. It consumes the pregraph typed records, per-token declaration and FP metadata, parser root roles, function regions, warning policy, and events already present at unit setup. It keeps separate declaration and line caches. The existing vector warning and C kernels run on these columns before the normal walk. A root with a warning or context operation that requires a later detailed check falls back. The pregraph admission bit is `state->proof_select[root_record] & 16u`. Graph root numbers first enter the comparison when the ordinary reader binds the stored decisions after the chunk.

The unit-wide terminal builtin guard and the body guard for GNU statement expressions model the lowering owner's tracked-stack flag. A call eligible for library substitution, a call without a prototype and an expression in a strict FP source context also fall back. The warning-span code sees only diagnostic events already present before the expression graph. This conservative selection leaves some expressions for the ordinary path. The per-corpus tables include those counts. This experiment measures eligibility. A native row-product comparison needs the independent caller, symbol, argument and conversion outputs for these same roots.

## Warning-policy coverage

| Input group | Programs | Completed / rejected per policy | Default roots | Wall/Wextra roots | Weverything/Wno-c++-compat roots |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tracked C fixtures | 1,230 | 409 / 821 | 425 returns, 566 discards | 411 returns, 347 discards | 383 returns, 346 discards |
| Extracted C programs | 13,879 | 6,633 / 7,246 | 3,052 returns, 1,456 discards | 2,958 returns, 705 discards | 2,886 returns, 686 discards |

The compressed JSONL files preserve each invocation's exit status and every emitted selection counter. No invocation exited abnormally. Some completed translation units had no eligible root. The extractor, fixture source revision and original rejection outcomes come from the exact #3214 campaign. [Original fixture campaign](https://github.com/buster14a/buster-performance/tree/b43a954034780926844f2ef45ab6689454e14f9f/docs/measurements/cast-truth-3204-2026-11-21/24c16e298/campaign)

## Negative controls

The initial blind selector admitted 42 SQLite discards whose ordinary callee received special treatment. Checking the source declaration and prototype removed them. In the first compiler-self run after that change, 140 admissions had the tracked-owner refusal. Source metadata identifies the function owning each statement expression and the translation unit containing a terminal builtin. The final executable exposed one unsafe admission in each of two focused programs when this owner veto was omitted.

The source-context omission admitted 16 ordinary integer return statements under file-scope FENV_ACCESS ON in `cast_conditions.c`. Disabling the declaration warning-event bitmap admitted an ignored statement attribute and a CPU dispatch stub in the two focused event controls. A broad force-admission control exposed three unsafe roots in `controls.c`. Every corresponding control with all guards enabled reported zero. The unguarded intermediate corpus summaries and final per-expression mutation results are included.

## Reproduce

Use Buster at `84a7d3d76891d6c393497e62e6aff38f2b162fc2`. From that checkout, set `record` to this directory's absolute path. The generated pregraph value proof and the eligibility probe are separate patches.

```sh
gzip -dc "$record/typed-window-probe.patch.gz" | git apply -
gzip -dc "$record/warning-selection.patch.gz" | git apply -
./build.sh
export NODE_PROOF_POINTERS=1 NODE_PROOF_NO_FP=1 NODE_PROOF_CALLS=1
build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "$record/owners.c"
NODE_PROBE_OMIT_TRACK=1 build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "$record/owners.c"
```

The Develop executable used for the reported results had SHA-256 `65fe7c402c67cae83e9b9f2bf50f62e637ad99400bcb1d13a52c03c6cf8e5a8a`. The patches and compressed raw tables have file hashes in `SHA256SUMS`. Compiler hashes depend on the build environment.

For the tracked and extracted sweeps, use a second Buster source checkout at `24c16e298bc7a5235711ff566fe652402d32173b`. Set `compiler` to the built executable and `fixtures` to this second checkout's absolute path. Use the original extractor from the performance repository at `b43a954034780926844f2ef45ab6689454e14f9f`. [Extractor](https://github.com/buster14a/buster-performance/blob/b43a954034780926844f2ef45ab6689454e14f9f/docs/measurements/tests-holes-2850-2026-11-21/sweep/extract.py)

```sh
python3 "$record/sweep.py" "$compiler" "$fixtures" "$record/tracked.list" tests.jsonl
python3 "$record/report.py" < tests.jsonl
cd "$fixtures"
python3 "$extractor" "$scratch/inline" src/buster/compiler/*_test.c
find "$scratch/inline" -name '*.c' | LC_ALL=C sort > "$scratch/inline.list"
python3 "$record/sweep.py" "$compiler" "$fixtures" "$scratch/inline.list" "$scratch/inline.jsonl"
python3 "$record/report.py" < "$scratch/inline.jsonl"
```

The corpus manifest names every C source and header in the input directories. Source `corpus-arguments.sh` from their common root in Bash for the original SQLite, Lua and musl flags. Decompress `predefines.h.gz` before using its header. The compiler-self input is the untouched source at the same `84a7d3d76` revision, with `-march=native -Isrc -fwrapv -funsigned-char --predefines "$record/predefines.h" src/buster/compiler/main.c`. The earlier exploratory compiler-self summaries used the instrumented checkout. The final table uses the untouched source.

Each successful case displays the independent decision and counts in stderr lines starting with `probe-select kind=`. An unsafe admission prints its token, ordinary refusal keys and source position. To recheck a stored fixture table, run `gzip -dc tests.jsonl.gz | python3 report.py`.
