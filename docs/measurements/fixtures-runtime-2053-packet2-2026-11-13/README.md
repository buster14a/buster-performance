# Ten test files' source tables as runtime data (2026-11-13)

[buster#2053](https://github.com/buster14a/buster/issues/2053)'s second packet. Ten test files' own
`CheckSourceFixture` tables, 596 cases, moved to a directory a suite under `tests/checker/` (`catalog.tsv` and a file
a case), in the first packet's format. `check_test_suite` (`c_checker_test.c`) reads and runs each suite as the tables'
own loops did. Sources: `buster14a/buster` at `32560e46` (main, after #2633).

| Suite | Cases | Test file |
| --- | ---: | --- |
| `align` | 67 | `c_check_program_align_test.c` |
| `classify` | 20 | `c_check_program_classify_test.c` |
| `cleanup` | 71 | `c_check_cleanup_test.c` |
| `const-alias` | 53 | `c_check_const_alias_test.c` |
| `float-constants` | 8 | `c_check_program_constants_test.c` |
| `generic-builtins` | 268 | `c_check_program_generic_builtins_test.c` |
| `library` | 21 | `c_check_program_library_test.c` |
| `musttail` | 63 | `c_check_musttail_test.c` |
| `transparent` | 8 | `c_check_transparent_test.c` |
| `transparent-types` | 17 | `c_check_transparent_type_test.c` |

## Why these ten

Of the 31 test files that use `CheckSourceFixture`, these are the ones whose table is literals alone, read by one loop:

- **The loop** writes each case's source, runs clang `-fsyntax-only -std=gnu17` on them all, compares each case's
  acceptance with clang's, and runs `check_test_source`. Every one of the ten runs clang with the same arguments.
- **Its expectation** is the case's `rejected`, or `rejected && (!unsupported || undecided)`. The two agree for a case
  without `unsupported`, so the shared runner takes the second.

The rest stay in C for now. They build their sources at run time (`c_check_constant_test.c`, `c_check_vla_test.c`,
`c_check_const_source_test.c`, `c_check_enum_test.c`), pair a case with data of their own (`c_check_overload_test.c`,
`c_check_function_name_test.c`, `c_check_integer_extension_test.c`), or pick cases by index
(`c_check_program_bits_test.c`, `c_check_typeof_compound_test.c`).

## The extraction check

**The dump.** `dump.c` is the ten tables, copied verbatim from buster's tree, with each one's file and line in a
comment. They sit inside a program that does two things:

- writes each case's source bytes, to its first NUL as the runner wrote them (`parse_test_write(path, source,
  strlen(source))`), to `SUITE/NNNN.c`;
- prints its metadata to `metadata.tsv`: suite, number, rejected, unsupported, extension, standard, unsigned char,
  undecided, overload tables, capacity, name.

It was built by the official Clang 23.1.4 (`clang -std=gnu17 -O0 -w`), so the bytes are clang's decoding of the
literals, not Buster's. No table holds a macro or a directive, only literals.

**The result.** The committed files were written from the dump, and `extraction-check.txt` compares each committed
file with the dump's (`cmp`): **596 of 596 the same**, and no other file. `dump-sha256.txt` has each file's SHA-256.

**The flags.** No case uses a type capacity or the overload tables: 420 are rejected, 174 plain, 1 rejected and
unsupported, 1 gnu23.

**The comments.** The tables' 77 comment lines (56 of them in `generic-builtins`) are `#` lines of the catalogs, above
the cases they described.

## Checks and controls

On the 4-CPU cloud container, with Develop's executables, `test-checker` with its default seed (`controls/`,
`controls.sh`):

| Run | Checks | Failures | Exit |
| --- | ---: | ---: | ---: |
| `main` before the move (`base`) | 834,408 | 0 | 0 |
| after it (`head`) | 834,418 | 0 | 0 |
| `cleanup`'s first case flipped to `rejected` (`flag`) | 834,418 | 3 | 1 |
| `generic-builtins`' `0100.c` removed (`missing`) | 828,102 | 2 | 1 |
| a case added to `musttail` as a file and a line (`added`) | 834,447 | 0 | 0 |

The 10 checks more after the move are the ten catalogs' loads.

- **A missing file** fails the run and names it. None of its suite's 268 cases run, 6,316 fewer checks, rather than
  fewer of them.
- **The added case** ran its 29 checks with the same executable.
- **No rebuild.** After the move, an edit of `tests/checker/cleanup/0002.c` left `./build.sh` with `ninja: no work to
  do.` and 0 units compiled (`controls/rebuild-after-edit.txt`).

**Sizes.** The ten test files lose 1,658 lines and gain 20. The moved data is 72,353 bytes of sources in 596 files,
and 44,814 bytes of catalogs.
