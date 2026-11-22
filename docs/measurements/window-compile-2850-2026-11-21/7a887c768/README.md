# Ordinary native compilation using integer result columns

Buster `7a887c768143ee609b2bfabb01dbdbc48eb5b34b` applies the integer arithmetic, predicate, store and implicit conversion checker in normal single-translation-unit compilation. The frozen control is its unmodified main parent `40ae34f9d77afc42face58eff3338b7b1d1ba469`. Both ordinary native executables use the same native Develop toolchain and each invocation compiles source directly to an ELF object. [Change](implementation.patch) and [compiler and predefines identities](builds.tsv).

The directed and real-source qualification used 136 input/option combinations across both compilers and found 0 differences in status, stdout, diagnostic locations and text, dumps or ELF. The four frozen workloads provided 4,116 per-file builds with default, Wall/Wextra and Weverything policies. 0 differed. Eight checker shards completed 850,926 assertions. [Directed comparisons](oracle/comparisons.tsv), [directed C sources](directed-cases.tar.gz), [raw diagnostic and dump streams](oracle/raw.tar.gz), [complete per-file outputs](per-file/raw.tar.gz) and [full checker-shard logs](checker-shards.tar.gz).

A separate executable evaluates 196 functions over all ordered pairs of fourteen integer types. It checks assignments, initialization, comparison, arithmetic and logical negation against the native Clang 23 and ordinary Buster parent under nine runtime inputs. The comparison recorded 0 runtime comparison failures across the 27 invocations. [Execution outcomes](runtime/results.tsv) and [source and compiler streams](runtime/raw.tar.gz).

| Input | Paired full-object wall | Faster rounds | Paired user cycles | Paired user instructions |
| --- | ---: | ---: | ---: | ---: |
| sqlite | +3.729 ms | 2/5 | -8,739,764 | -20,559,604 |
| buster | +7.362 ms | 2/5 | -52,357,456 | -36,356,858 |

Five alternating ABBA/BAAB rounds measured each fresh ordinary compiler process on one local Ryzen 9 7940HS core. Three separate rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [raw wall and counter values](stage/samples.tsv) and [perf and compiler reports](stage/raw.tar.gz).

Use `git apply implementation.patch` in the candidate checkout at the recorded main parent. Compile both checkouts with `./build.sh --config Develop --target compiler --jobs 1`. With the frozen 9,507,037-byte SQLite amalgamation and Buster source checkout at `84a7d3d76891d6c393497e62e6aff38f2b162fc2`, the [standalone reproduction script](reproduce.py) runs the ordinary paired native oracle using `python3 reproduce.py --base BASE/build/compiler --candidate HEAD/build/compiler --sqlite SQLITE/sqlite3.c --buster-source FROZEN_BUSTER --out results`. The script verifies the SQLite SHA-256 and retains stdout, stderr, compiler status and ELF hashes.

The standalone reproduction completed 136 paired cases with zero differences. [Replay output](replay.txt) and [replayed ELF and stream hashes](replay.tsv).
