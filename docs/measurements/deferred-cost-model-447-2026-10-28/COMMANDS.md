# Commands and reproduction

Run in this record's working directory, beside the frozen compiler checkout
`../next-447` at `e7f89091648f68940b595aadd648841c1ffc3ec5`.
All helper implementation is C. Shell syntax below is invocation glue.

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror prepare_profile.c -o prepare_profile
./prepare_profile ../next-447/src/buster/compiler/main.c main-profile-copy.c \
  ../next-447/src/buster/compiler/c_check_deferred.c deferred-profile-copy.c
CORES_TITLE='447 offline profiler GNU dialect' \
CORES_LINK='https://github.com/buster14a/buster/issues/447' cores -n 1 -- \
  clang -std=gnu17 -O2 -g0 -D_GNU_SOURCE -march=native -fwrapv -funsigned-char \
  -fno-strict-aliasing -ffunction-sections -fdata-sections -Wall -Werror \
  -Wno-unused-function -I../next-447/src -I../next-447/src/buster/compiler \
  profile.c -Wl,--gc-sections -lm -ldl -pthread -o profile
```

Each c-testsuite profile command was `./profile PATH/UNIT.c`, with units
`00001 00056 00131 00140 00169 00182 00200 00204 00213 00215`, in one
`cores -n 1` invocation, stdout and stderr separately retained per unit.
`PATH=/home/david/Documents/Codex/2026-10-27/sol-11/work/c-testsuite/tests/single-exec`.

SQLite, under its own `cores -n 1` grant, with
`S=/home/david/Documents/Codex/2026-10-27/exp/work/corpus`:

```sh
./profile --predefines "$S/gnu17-pinned-predefines.txt" --clang-features \
  -std=gnu17 -nostdinc -isystem "$S/headers/usr/lib/clang/23/include" \
  -isystem "$S/headers/usr/local/include" -isystem "$S/headers/usr/include" \
  -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 \
  -DSQLITE_ENABLE_RTREE -I"$S/sqlite" "$S/sqlite/sqlite3.c"
```

Each of five musl source units, under one separate `cores -n 1` grant, with
`M=/home/david/Documents/Codex/2026-10-28/take-over-all-x20/work/review678-inputs/libc/musl`,
`G=/home/david/Documents/Codex/2026-10-28/take-over-all-x20/work/review678-inputs/musl-generated`:

```sh
./profile -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
  -I"$M/arch/x86_64" -I"$M/arch/generic" -I"$G/obj/src/internal" \
  -I"$M/src/include" -I"$M/src/internal" -I"$G/obj/include" -I"$M/include" \
  "$M/src/UNIT.c"
```

`UNIT` values: `string/wmemcpy string/memcmp stdlib/abs ctype/isalpha math/fabs`.

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror fit.c -lm -o fit
clang -std=c17 -O1 -g -fsanitize=address,undefined -Wall -Wextra -Werror fit.c -lm -o fit-sanitized
./fit-sanitized --self-test
./fit train.tsv held-out-tests.tsv
./fit train.tsv profiles/sqlite.tsv
./fit train.tsv held-out-musl.tsv
./fit-sanitized invalid-short.tsv train.tsv   # expected status 1
./fit-sanitized invalid-count.tsv invalid-count.tsv   # expected status 1
clang -std=c17 -O2 -Wall -Wextra -Werror absolute.c -o absolute
./absolute historical/docs/measurements/deferred-lane-costs-113-2026-10-27/tables/summaryB2.tsv
```

Training/held-out concatenation order and complete rows are retained in
`train.tsv`, `held-out-tests.tsv`, `held-out-musl.tsv`. Duplicate headers are
accepted only when the complete kind list agrees. No held-out rows enter the
fixed training table. All three coefficient suffixes byte-compare identical.
