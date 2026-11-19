# Tier 1 integer comparisons against the true encoding

A strict Tier 1 C compile of two return-value kernels removes a second integer comparison and its `setcc`. The signed relation stays `setl` and the unsigned inverse becomes `setae`.

| Function | Base instructions | Head instructions | Base bytes | Head bytes |
| --- | ---: | ---: | ---: | ---: |
| `truth_eq` | 7 | 4 | 19 | 8 |
| `truth_ne` | 8 | 4 | 24 | 8 |

Instruction counts include `ret` and symbol sizes come from `nm -S`, excluding alignment padding. Both revisions agree with Clang on all 162 return values for the nine input values in `oracle.c`.

The frozen SQLite 3.53.2 amalgamation with FTS4 enabled compiled all 1,529 functions at Tier 1 on each revision. The complete 1,722,184-byte `.text` was identical, SHA-256 `7ba9ec61fd4da721c02506e11c2daee44a2f211d9c465ede11a1f500442fd070`. This run measured emitted code. Compiler throughput and program runtime were unmeasured.

## Reproduction

Base `6427879e1143026a12fb0388a20bdea1fe4b2bc5`, head `ecec17211fcd3458e01ae808f86f9b6e019fa450`. Both used the same GitHub-hosted Ubuntu 26.04 VM (AMD EPYC 9V74), CI's Clang 23.1.4 and a vector Release compiler. `tools/ci/vector-probe.c` passed before either build.

From each Buster checkout, with `record` set to the absolute path of this directory and the pinned toolchain on `PATH`, use the following commands.

```sh
BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none ./build.sh --config Release
./build/compiler --tier1 --tier1-strict --verify --lanes 1 -O2 -march=x86-64 -std=c17 -c "$record/probe.c" -o build/truth-probe.o
objdump -d build/truth-probe.o
nm -S --defined-only build/truth-probe.o
clang -std=c17 -O2 -Dtruth_eq=ref_eq -Dtruth_ne=ref_ne -c "$record/probe.c" -o build/truth-ref.o
clang -O2 "$record/oracle.c" build/truth-ref.o build/truth-probe.o -o build/truth-oracle
./build/truth-oracle
./build/compiler test-ir-optimize
for name in tier1_truth tier1_patterns; do
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "tests/driver/$name.c" -o "build/test-$name"
    "build/test-$name" build/compiler "$(command -v clang)"
done
bash tools/ci/fetch-corpus.sh build/truth-corpus
./build/compiler --tier1 --tier1-report --lanes 1 -O2 -march=x86-64 -std=gnu17 -DSQLITE_ENABLE_FTS4 -Ibuild/truth-corpus/sqlite -c build/truth-corpus/sqlite/sqlite3.c -o build/truth-sqlite.o
objcopy -j .text -O binary build/truth-sqlite.o build/truth-sqlite.text
sha256sum build/truth-sqlite.text
```

`test-ir-optimize` passed 290,949 checks on base and 290,952 on head. The new before/after fixture checks seven rewrites and preserves the mismatching encodings, floating comparison, truncation and unrelated integer. Both native suites passed each of their existing driver modes on both revisions.

The disassembly, test results and hashes are in [results.txt](results.txt). [Hosted run](https://github.com/buster14a/buster/actions/runs/44603761056) · [exact job and inputs](https://github.com/buster14a/buster/blob/e78351d312e5b393bb49dd7db9152f9898f3810d/.github/workflows/3036-hosted-evidence.yml) · [baseline before implementation](https://github.com/buster14a/buster/actions/runs/44601052250) · [Buster issue #3036](https://github.com/buster14a/buster/issues/3036).

The replay C sources are original to this investigation. Agent session `6aff4f4e-efe8-8191-962e-7e31e37ac079`, OpenAI / GPT-6 (Codex).
