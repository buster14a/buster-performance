# Integer result columns on the ordinary checker loop

Buster `4d99d818a2db9fbfdf9b2fc56f4901da71e4e857` applies the integer arithmetic, predicate, store and implicit conversion checker in normal single-translation-unit compilation. It groups the candidate operators within the existing graph walk and calls a separate checked-integer helper to share the original scalar fallback. The frozen control is the unmodified main revision `40ae34f9d77afc42face58eff3338b7b1d1ba469`. Both ordinary native executables use the same native Develop toolchain and each invocation compiles source directly to an ELF object. [Change](implementation.patch) and [compiler and predefines identities](builds.tsv).

The directed and real-source qualification used 136 input/option combinations across both compilers and found 0 differences in status, stdout, diagnostic locations and text, dumps or ELF. The four frozen workloads provided 4,116 per-file builds with default, Wall/Wextra and Weverything policies. 0 differed. Eight checker shards completed 558,754 assertions. [Directed comparisons](oracle/comparisons.tsv), [directed C sources](directed-cases.tar.gz), [raw diagnostic and dump streams](oracle/raw.tar.gz), [complete per-file outputs](per-file/raw.tar.gz) and [full checker-shard logs](checker-shards.tar.gz).

A separate executable evaluates 196 functions over all ordered pairs of fourteen integer types. It checks assignments, initialization, comparison, arithmetic and logical negation against the native Clang 23 and ordinary Buster parent under nine runtime inputs. The comparison recorded 0 runtime comparison failures across the 27 invocations. [Execution outcomes](runtime/results.tsv) and [source and compiler streams](runtime/raw.tar.gz).

| Input | Paired full-object wall | Faster rounds | Paired user cycles | Paired user instructions |
| --- | ---: | ---: | ---: | ---: |
| sqlite | +1.653 ms | 2/5 | -474,856 | -14,660,642 |
| buster | -11.740 ms | 3/5 | +42,240,512 | -6,490,374 |

Five alternating ABBA/BAAB rounds measured each fresh ordinary compiler process on one local Ryzen 9 7940HS core. Three separate rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [raw wall and counter values](stage/samples.tsv) and [perf and compiler reports](stage/raw.tar.gz).

A second execution matrix exercises the same 196 type pairs with negative values and inputs across char and short conversion boundaries. Clang, main and the candidate agreed on all nine answers. [Per-compiler answers](runtime-edges/results.tsv) and [full source](runtime-edges/raw.tar.gz).

The executable debugger control reached the specialized integer row in an ordinary native compile. The debugger control recorded 0 differences from the untreated ELF and execution result. Skipping publication of the first checked result produced 1 differing ELF or execution outcome. [Outcomes](mutation/outcomes.tsv), [source and debugger transcripts](mutation/raw.tar.gz) and [reproduction driver](mutate.py).

Use `git apply implementation.patch` in the candidate checkout at the recorded main revision. Compile both checkouts with `./build.sh --config Develop --target compiler --jobs 1`. With the frozen 9,507,037-byte SQLite amalgamation and Buster source checkout at `84a7d3d76891d6c393497e62e6aff38f2b162fc2`, the [standalone reproduction script](reproduce.py) runs the ordinary paired native oracle using `python3 reproduce.py --base BASE/build/compiler --candidate HEAD/build/compiler --sqlite SQLITE/sqlite3.c --buster-source FROZEN_BUSTER --out results`. The script verifies the SQLite SHA-256 and retains stdout, stderr, compiler status and ELF hashes.

The standalone reproduction completed 136 paired cases with zero differences. [Replay output](replay.txt) and [replayed ELF and stream hashes](replay.tsv).

## Independent SQLite repeat

One additional 7940HS core ran the same three ordinary native binaries over all six forward-and-reverse orders. Eighteen wall rounds used three cycles of the six permutations. Six separate rounds took user cycles and instructions. Every invocation used the same SQLite source and produced the same complete ELF hash. Each mirrored sequence supplies two observations per binary, centered within the round. [Paired summaries](sqlite-repeat/paired.tsv), [per-process timings, switches and output hashes](sqlite-repeat/samples.tsv) and [raw counters and outputs](sqlite-repeat/raw.tar.gz).

| Candidate | Paired wall | Faster rounds | Paired user cycles | Paired user instructions |
| --- | ---: | ---: | ---: | ---: |
| default-integer-transfers | +1.873 ms | 7/18 | -337,841 | -20,559,812 |
| default-ordered-integers | +1.156 ms | 7/18 | -7,567,486 | -14,660,723 |

The separated candidate emitted a 28,209-byte checker routine containing its own ordinary scalar fallback. Sharing that fallback with the ordinary checker left a 2,464-byte specialized helper. The compact compiler’s total text sections were 192 bytes larger than main. [Compiler and helper text sizes](sqlite-repeat/size.tsv).
