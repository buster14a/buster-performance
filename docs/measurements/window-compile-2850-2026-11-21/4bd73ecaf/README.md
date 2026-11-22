# Function-local source graphs and checked outputs

The experimental reader checks one complete external declaration at a time. On SQLite 3.53.2 and the frozen Buster compiler it reproduced every ordinary graph node, typed checker report and checked effect fingerprint. The unit-wide expression graph had one slot and held zero nodes throughout. The complete ordinary compiler produced matching ELF objects in a separate process. The experimental source path stopped at the checked rows. [Per-declaration comparisons and object hashes](oracle/totals.tsv)

| Input | Functions checked | Function nodes | All external declarations | All nodes | Largest function | Largest declaration |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,674 | 319,280 | 7,298 | 323,623 | 14,820 | 14,820 |
| Buster | 8,667 | 586,965 | 12,518 | 1,407,416 | 5,379 | 347,286 |

The producer keeps token identities, declarations, bindings and a shared mutable C type table. It runs the existing expression reader from each postorder root into a recyclable graph and then runs the production checker. It retires graph, stream and scratch together. Its type comparison uses C structure, qualifiers, function ABI and nominal tags to account for differences in the order of interning. A file-scope assertion in Buster requires a derived array-decay type to persist from one declaration into another. [Implementation patch](implementation.patch)

The oracle checks graph operators, source identities, all three fixed operands, call argument edges and tokens, source ranges, FP context, warning suppression, types, leaves and constant-evaluation flags. For checked output it includes every value, conversion, member offset, primary diagnostic, warning and typed report. It includes all fields of the store, varargs, misc, floating, query, atomic, vector, x86, bit-cast, overload and overload-address effect records. It also checks constant-warning requests and published checker warning events. Every row is keyed by its closing parser token. Each compressed TSV carries both fingerprints. The accompanying compressed stderr files preserve the original process output in each mode. [SQLite receipts](oracle/sqlite/) and [Buster receipts](oracle/buster/)

The supplemental observer computed an independent field fingerprint for each side record in source order. The source-local sequence and whole-unit sequence match byte-for-byte for all 1,597 SQLite entries and all 11,446 Buster entries. These include zero counts for unexercised families. Each record names its closing source token, family and normalized owner node. The observer adds only receipt emission under an environment switch. [Counts by effect kind](effects/counts.tsv), [SQLite records](effects/sqlite/) and [Buster records](effects/buster/)

## Resident memory

The per-process Linux smaps audit ran at the same source-reader boundary, immediately after producing and checking all declarations. Both paths used fresh processes on a Ryzen 9 7940HS with zero anonymous huge pages in the captured mappings. The checker translation unit used an unoptimized debugging build for this attribution. Counts are live KiB at that boundary. [Per-mapping RSS and huge pages](residency/mapping.tsv)

| Input | Whole graph and checker | Per-declaration graph and checker | Difference |
| --- | ---: | ---: | ---: |
| SQLite | 199,600 KiB | 158,508 KiB | −41,092 KiB |
| Buster | 960,696 KiB | 799,680 KiB | −161,016 KiB |

SQLite's largest function, sqlite3VdbeExec, contains 28,599 tokens. Its local graph, stream and scratch mappings retained 1,708,032, 2,326,528 and 106,496 bytes respectively after all functions. Buster's largest function by node count is lane_test_arenas. The corresponding mappings retained 831,488, 851,968 and 94,208 bytes. Buster's monolithic static initializer accounts for the 347,286-node external declaration and increases the three all-declaration mappings to 25,481,216, 49,303,552 and 348,160 bytes. [Raw source-mode summaries](oracle/buster/declarations.source.stderr.xz)

The parser and token-indexed declaration passes still own whole-unit state. At the SQLite source-mode exit the reader's output and scratch alone held 31,544 and 70,896 KiB. Buster retained 335,624 and 251,372 KiB respectively. The source-first witness ends before the remaining source finalizers, driver warning rendering, lowering and ELF writing. [SQLite mapping capture](residency/sqlite/mapping-source.stderr) and [Buster mapping capture](residency/buster/mapping-source.stderr)

## Reproduction

The source patch applies to Buster commit `0e1d5b825801135bf50e79da9d546bc95209ab30` and reconstructs the tracked tree of `4bd73ecaf27519017ab6d710a3d7c0d4d49071aa`. The corpus uses a clean Buster checkout at `84a7d3d76891d6c393497e62e6aff38f2b162fc2` and the 9,507,037-byte SQLite 3.53.2 amalgamation. The script checks the frozen SQLite and predefines hashes. Independent checkouts can embed different absolute source path strings in the compiler ELF. Each comparison checks both compiler outputs in the same checkout. [Input and toolchain identities](provenance.tsv)

From the performance-record directory, use the following with an unmodified Buster source checkout, an empty target directory for each worktree, and an extracted SQLite amalgamation.

```sh
record=$PWD
git -C "$BUSTER_REPO" worktree add --detach "$PATCHED_BUSTER" 0e1d5b825801135bf50e79da9d546bc95209ab30
git -C "$PATCHED_BUSTER" apply "$record/implementation.patch"
git -C "$BUSTER_REPO" worktree add --detach "$FROZEN_BUSTER" 84a7d3d76891d6c393497e62e6aff38f2b162fc2
(cd "$PATCHED_BUSTER" && ./build.sh)
python3 reproduce.py --compiler "$PATCHED_BUSTER/build/compiler" --base-compiler "$BASE_BUSTER_COMPILER" \
  --self-source "$FROZEN_BUSTER" --sqlite "$SQLITE_AMALGAMATION/sqlite3.c" --output "$RESULTS/oracle"
python3 stages.py --compiler "$PATCHED_BUSTER/build/compiler" --self-source "$FROZEN_BUSTER" \
  --sqlite "$SQLITE_AMALGAMATION/sqlite3.c" --maps --rounds 0 --output "$RESULTS/residency"
```

The oracle and mapping files above used a local one-core functional witness with an unoptimized checker translation unit and the ordinary Develop build for the other partitions. The baseline executable came from commit `fbef2d68dfc952c269d7a2fd008220341428e727`, whose source directory matches the patch base. The driver used normal source compilation and one lane in all cases. [Exact binary hashes](oracle/binaries.json)

To reproduce the side-record files from the same checkout, apply `effect-observer.patch` on top of `implementation.patch`, rebuild and run `effects.py` with the same `--compiler`, `--sqlite` and `--self-source` paths and a new output directory. The supplemental patch reconstructs commit `804a88de19c8ca325609b0286208b3483a4927c7`. [Observer patch](effect-observer.patch) and [verification script](effects.py)
