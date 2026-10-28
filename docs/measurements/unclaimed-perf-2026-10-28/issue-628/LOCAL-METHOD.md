# Frozen local commands and identities

Shared current controls are immutable archives of their exact Git commits:

- `work/baseline-a62c2df7/build/compiler`: source
  `a62c2df766da50910c9ba8d9735f3bb6b801deba`, SHA-256
  `ca5ffe98ce1d1087ff0ea342fc813a4d20ecaf18235933a855d45eb33ba8732d`.
- `work/baseline-4165454e/build/compiler`: source
  `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`, SHA-256
  `89ad9b0cb59f3a16d4b981294a656179d428c5f4c42d94150828c852764657f8`.

Each uses local Clang 23.1.4, a separate two-core grant, and
`env BUSTER_DEBUG_INFO=0 ./build.sh`. The script fixes O3, native ISA,
`-fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Isrc`.
Full source archives remain in the control directories with `SOURCE_COMMIT`;
build logs, identity hashes and `compile_commands.json` copies are retained
here with `current-base-*` and `main416-base-*` prefixes. No control was reused
across source revisions without recording it.

From the private compiler candidate worktree, the exact ordinary SQLite
compile command is below. Both images receive identical arguments and source
paths. Replace only the compiler executable and output file when comparing.

```sh
task_corpus=/home/david/Documents/Codex/2026-10-27/exp/work/corpus
./build/compiler --lanes 1 -c \
  -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 \
  --predefines "$task_corpus/gnu17-pinned-predefines.txt" \
  --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc \
  -isystem "$task_corpus/headers/usr/lib/clang/23/include" \
  -isystem "$task_corpus/headers/usr/local/include" \
  -isystem "$task_corpus/headers/usr/include" \
  -I"$task_corpus/sqlite" "$task_corpus/sqlite/sqlite3.c" -o OUTPUT.o
```

The process/RSS screens use the candidate's `measure-compile --runs 5 --warmups 1`
with the exact frozen `--reference` executable, `--directory ../evidence-628
--keep`, then `--` and the compiler arguments above without `-o` (the tool
owns output paths). Each gets `cores -n 2` separately. These shared-development
machine screens are not 9700X timing acceptance. Default/stage objects are
checked by the tool, and the retained default/reference objects are compared
separately in full.

Local parser-only checks: `test-parser --clang --seed 628`, full
`test-checker --seed 628`, and `benchmark-parser --passes 1 --only stages` on
the original `../evidence-658/uchar-100000.c`. The checker retains the same four
known local fpclassify oracle disagreements; native qualification has none.
Focused sanitizer adapters and their exact main copies are original local C
helpers, compiled with ASan/UBSan and section garbage collection so only the
selected permanent checks execute. Dirty and copied arenas are tested; no
fresh-zero/high-water assumption is introduced.

The standalone #628 slice did not run c-testsuite. The parent owns integrated
c-testsuite coverage and its separately frozen corpus path.
