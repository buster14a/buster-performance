# Direct integer return-call rows

Private source experiment for Buster issue #2850. `prototype.patch` applies to `39cd1b6ce77f2289a56ec0d1de2f5044e1607979` and reproduces the tree at `566a5293e85c8463a4c60dfeacf8ccf5cd9c9e05`. The ordinary and experimental variants run in the same executable under `--node-window`. The experiment retains the optional integer constant, a native CALL row, the function-object reference and the integer call/argument ABI descriptor for a complete `return f();` or `return f(integer_literal);`. The callee must bind directly to a plain System V prototype returning int. Every parameter and literal must be int, and function attributes exclude the entity across redeclarations. The debugger and unsupported spellings follow the ordinary reader. General typed-call transfer remains a separate experiment.

## Reproduction

Apply the patch and run `./build.sh --config Develop` in the checkout. The following checks take the path to its compiler. The source expressions and diagnostics include distinct ABI, target, visibility, alias, local binding, no-return, warning, unknown declaration, invalid argument, wrapper and selection cases.

```sh
export BUSTER_CALL_GUARD=1
python3 proto-tests.py /path/to/compiler
python3 attribute-grid.py /path/to/compiler final
python3 runtime.py /path/to/compiler
BUSTER_CORPUS_ROOT=/path/to/frozen-corpora CALL_CC=/path/to/compiler python3 corpus.py sqlite lua musl
```

`BUSTER_CALL_PROTO=1` enables admissions and `BUSTER_CALL_LOG=1` emits one row per admission. The scripts strip those rows before comparing diagnostics and hash complete object bytes. `BUSTER_CALL_OMIT_REFERENCE=1` is a negative control which retains native rows and suppresses the selected-symbol side fact. The independent native test links to GCC-compiled functions and checks six observable return values.

The matrix runs each named fixture with default settings, debug information, `-Wall -Wextra`, `-Weverything`, and `-O2`. The attribute grid places 27 attributes or controls on direct, earlier, later, block-scope, defining, or unrelated declarations, with two argument values. `proto-unguarded.tsv` and `grid-unguarded.tsv` are intermediate negative controls. `proto-guard1.tsv` and `grid-guard1.tsv` retain only the first guard against linked declaration attributes and inline or noreturn flags. That first guard leaves an `ms_abi` typedef counterexample. The canonical function-ABI check closes it.

`ast-shapes.tsv` counts direct calls immediately under a Clang ReturnStmt or CompoundStmt. The raw inputs and options come from `corpora.sh`. For a single corpus, pipe `clang -w -fsyntax-only -Xclang -ast-dump "${args[@]}"` into `python3 clang-shapes.py results.tsv` with the corresponding argument array. AST counts include otherwise unsupported sites and describe an upper bound for the scanner.


## Results

The final Develop compiler had SHA256 `e3ea6ee7cfbf45e806e82524a29ad18077a712e34cb4dab60171b93b1d3aa343`. The two final differential grids cover 340 and 324 cells. Each cell matched ordinary verdict, diagnostics, and full object bytes. Running all 340 named cells again with ordinary graph construction (no window option) as the reference gave the same outcome. Set `BUSTER_ORDINARY_BASE=1` on the named test script to repeat this control.

The ordinary unguarded splice diverged in 28 named cells, including 24 accepted instead of rejected. Its independent declaration grid diverged in 22 cells, including 18 accepted instead of rejected. Examples include a `diagnose_if` error or warning, a missing AVX2 feature for `always_inline`, and a non-System-V target call. The linked-object attribute guard reduced the named differences to four. Those four placed `ms_abi` on a typedef in four compiler modes. Checking the canonical function ABI closed the four differences. The reference-removal mutation failed emission in 76 initially successful cells on the guarded binary. The six GCC-linked runtime values were 56, 245, 96, −25, 53 and 32.

All 1,371 frozen C translation units compiled in both configurations. Each pair matched verdict, diagnostics, and full ELF digest. SQLite's one unit took 119 call summaries, Lua's 34 units took zero, and musl's 1,336 units took two (inotify.c and epoll.c). SQLite eliminated 355 of 319,066 graph nodes, about 0.11%. The stage counters, unit receipts, and runtime output are included. These counts measure this access path and signature. The 829 direct SQLite statement calls passing one plain local or parameter to a void-returning callee need additional type, local read and reference evidence.
