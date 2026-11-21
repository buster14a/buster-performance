# Discarded calls with one pointer argument

Private #2850 experiment at `1b616e18bb785ab4fc9f4f3b3ea2e33ae5e58222`. Apply `prototype.patch` to `39cd1b6ce77f2289a56ec0d1de2f5044e1607979` to reproduce the entire source tree difference. The local Develop compiler SHA256 is `49ed4ac89672326a678c11c748dcd14578e8fa8ba2bb18b30c907c88e8e2cc62`.

The scanner recognizes a complete block statement calling an ordinary direct System V void prototype with one unqualified automatic pointer variable, including parameters, when the argument type equals the formal type. It retains the relocated native local read, the native call, the referenced function object, and the ABI parameter TypeId. Deferred or debug bodies, local function pointers, nonidentity conversions, attributed callees, final statement-expression values and unsupported source shapes follow the ordinary path. This prototype independently checks the bounded signature. The general SIMD call type/conversion proof is a separate experiment.

## Results

| Frozen corpus | Translation units | Calls admitted per policy |
|---|---:|---:|
| SQLite | 1 | 673 |
| Lua | 34 | 103 |
| musl | 1,336 | 8 |

All 4,113 translation-unit and warning-policy combinations compiled on both paths with identical diagnostics and full ELF bytes. The policies were default, `-Wall -Wextra`, and `-Weverything`. The compressed per-unit tables contain both SHA256 digests. SQLite eliminated 2,019 of 319,066 graph nodes. The stage counts and object receipt are in `sqlite-stages.tsv`.

The focused 215-cell fixture matrix matched the prior window mode and matched ordinary graph construction in a separate 215-cell run. A further 696 declaration attribute, placement and return-flow cells also matched. Removing the read event changed four warning cells, including a missing uninitialized-variable warning and a spurious unused-but-set-parameter warning. Changing the pointer read to a 32-bit typed entry caused 60 formerly clean cells to fail. Dropping the callee reference independently caused 60 to fail. The positive cross-TU executable took six calls and computed 38 and 44, matching GCC and the ordinary compiler. Both the width and reference mutations were caught during emission.

The Clang AST shape ceilings for this simple pointer-read pattern were 696 SQLite, 175 Lua, and 14 musl. Actual Buster admissions above also require the scanner, declaration/attribute and local binding checks. `discard-pointers.py` accepts a text Clang AST through stdin and counts sole LValueToRValue pointer arguments to syntactically direct discarded void calls.

## Reproduction

Build using `./build.sh --config Develop`. The only experimental selection for positive corpus and timing comparisons is `BUSTER_DISCARD_PTR=1` alongside `--node-window`. Clear all BUSTER_CALL_* and BUSTER_PTR_* controls for timings. Keep BUSTER_CALL_PROTO unset to isolate this feature from the earlier integer-returning call probe. For focused fixtures and the runtime oracle, supply the compiler path.

```sh
python3 test.py /path/to/compiler
PTR_ORDINARY_BASE=1 PTR_TABLE=ordinary.tsv python3 test.py /path/to/compiler
BUSTER_PTR_OMIT_READ=1 PTR_TABLE=read.tsv python3 test.py /path/to/compiler
BUSTER_PTR_NARROW=1 PTR_TABLE=narrow.tsv python3 test.py /path/to/compiler
python3 attributes.py /path/to/compiler
python3 runtime.py /path/to/compiler
BUSTER_CORPUS_ROOT=/path/to/frozen-corpora CALL_CC=/path/to/compiler python3 corpus.py sqlite lua musl
```

`test.py` also runs the omitted-callee-reference mutation, controlled by `BUSTER_CALL_OMIT_REFERENCE`. `BUSTER_CALL_LOG=1` writes one ptr-row line per admission. The qualification scripts remove those lines before comparing diagnostics. Set BUSTER_PTR_CFLAGS and CALL_RUN to repeat corpus pairs under a different policy.
