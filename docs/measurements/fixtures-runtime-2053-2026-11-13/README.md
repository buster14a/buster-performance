# The checker's shared source fixtures as runtime data (2026-11-13)

[buster#2053](https://github.com/buster14a/buster/issues/2053)'s first packet: test-checker's shared source fixtures
(`check_test_sources`), 418 cases and 3,183 lines of `c_checker_test.c`'s table, moved to `tests/checker/sources/`
(`catalog.tsv` and a file a case), which the test reads when it runs.

## The extraction check

`dump.c` is the pre-migration table (buster at `0a55fb99`, `c_checker_test.c` lines 2625 to 5807) inside a program
that writes each case's source bytes, to its first NUL as the runner wrote them (`parse_test_write(path, source,
strlen(source))`), to `NNNN.c`, and its metadata to stdout (`dump-metadata.tsv`: number, rejected, unsupported,
extension, standard, unsigned char, undecided, overload tables, name). It was built by the official Clang 23.1.4
(`clang -std=gnu17 -O0 -w`), so the bytes are clang's decoding of the literals, not Buster's. The committed files were
written from it, and `extraction-check.txt` compares each committed file with the dump's (`cmp`): **418 of 418 the
same**. `dump-sha256.txt` has each file's SHA-256. No case uses a type capacity or the overload tables; 215 are
rejected-only, 148 plain, 24 gnu23, 12 rejected and unsupported, 5 unsigned-char, 3 undecided.

## Checks and controls

On the 4-CPU cloud container, Develop's executable, `test-checker` with its default seed (`controls/`):

| Run | Checks | Failures | Exit |
| --- | ---: | ---: | ---: |
| before the move (`base`) | 829,706 | 0 | 0 |
| after it (the same run in buster's commit message) | 829,707 | 0 | 0 |
| a case's flag flipped to `rejected` (`flag`) | 829,707 | 3 | 1 |
| a case's file removed (`missing`) | 817,765 | 1 | 1 |
| a file no line names (`orphan`) | 817,765 | 1 | 1 |
| two lines with one ID (`duplicate`) | 817,765 | 1 | 1 |
| a case added as a file and a line (`added`) | 829,736 | 0 | 0 |

The one check more after the move is the catalog's load. A missing, orphan or duplicate entry fails the run and names
it, and runs none of the cases (11,942 fewer checks), rather than fewer of them. The added case ran its 29 checks.

**No rebuild.** After the move, an edit of `tests/checker/sources/0002.c` left `./build.sh` with `ninja: no work to
do.` and 0 units compiled; the `added` control ran a new case with the same executable.

**Sizes.** `c_checker_test.c`: 338,509 to 210,033 bytes (7,204 to 4,327 lines). The moved data: 61,647 bytes of
sources in 418 files, and a 26,874-byte catalog.
