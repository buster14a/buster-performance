# The fronts' calls in a unit with `no_builtin`, and the kernel's `*f` of a function's designator (buster#2968, buster#2970): 2026-11-18

Two things found while counting the calls' rule on the compiler's own source
([the third piece's record](../window-tests-calls-2850-2026-11-18/README.md), section 7), both in the shadow's code
alone, and their fixes. Part of buster14a/buster#2850's step 2.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading (`job-pair.sh` and
  the other scripts are the earlier records': [the second piece's](../window-tests-listing-2850-2026-11-18/scripts)
  and [the first half's](../window-tests-2850-2026-11-17/scripts); `tables3.py` is
  [the third piece's](../window-tests-calls-2850-2026-11-18/scripts)).
- The base is the third piece's head on main `5fa4e76c3` (`h1`, buster14a/buster#2969). `h2` and `h3` are the fixes on
  it, patches against that main: `h3` is the pull request's sources, and `h2` the same with a strip of a function
  type's qualifiers that section 5's faults showed to do nothing.

## 1. One `no_builtin` function left every call of its unit unmade (buster#2968)

The node machine's fronts left a call where its unit had clang's `no_builtin` attribute anywhere
(`c_check_node_machine_front.c`: `left = ... || input->no_builtin`; `c_check_node_machine_flat.c`: `refused`). The
compiler's own source has one such function since `e2da9f0fd` (2026-10-21), `dataflow_liveness_vector_one`. The
third piece's record has the counts on main and with the term lifted in a copy of the tree
(`results/cloud/no-builtin` there).

`probes/no-builtin.c` has five functions, the second with `no_builtin("memset")` and the fourth with `no_builtin`:

| `--window-tests --verify` | main `8d4025fbf` | with the fixes |
| --- | ---: | ---: |
| expressions the tests on the window run on | 1 | 11 |
| calls left out, each checked | 0 | 10 |
| library calls T asks about at reader time, that differ | 0, 0 | 7, 0 |
| expressions the reference refuses for their callee | 7 | 7 |

The seven refused are the library calls with semantics of their own outside the attribute's reach (`memset` in the
three functions without it, `memcpy` in the one that names `memset`, `strlen("abc")` and `strlen(p)`); the calls of
`memset` in both functions with the attribute, and of `memcpy`, `(&memset)` and `strlen` in the one that names
nothing, are their declarations' calls and are taken. Fourteen modes of the shadow exit 0 on it with the fixes, the
whole front's two orders among them.

## 2. `*f` of a function's designator had no type (buster#2970)

`node_facts_dereference` converts its operand as T does, a function's designator to a pointer to it, and read what
that points at from the operand's own row; a function type's row has no element.

| `--window-tests --verify` | main `8d4025fbf` | with the fixes |
| --- | ---: | ---: |
| `probes/designator.c` (`(*k0)(a, b)`, `(**k0)(a, b)`, `(&k0)(a, b)`, `(*&k0)(a, b)`): exit status | 1 | 0 |
| records the kernel makes in place, left, that differ | 34, 2, 4 | 36, 0, 0 |
| `probes/library.c` (library functions by name, `&name` and `*name`): exit status | 1 | 0 |
| records the kernel makes in place, left, that differ | 15, 2, 4 | 17, 0, 0 |
| `probes/qualified.c` (`const` and `volatile` on a function type): exit status | | 0 |

## 3. The cloud container's checks (`results/cloud/final`)

The fixes on the third piece's head (the work branch's `9418ec86b`; 4 CPUs, native host, Release):

- `test-checker`, all eight parts: 842,789 checks, 0 failures.
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 12 modes: 48 runs, each status 0. Beside
  `--verify`, the compiler's own source before (the third piece's run) and with the fixes:

  | | before | with the fixes |
  | --- | ---: | ---: |
  | expressions the tests on the window run on | 38,155 | 52,015 |
  | their records, and the chunks | 226,623, 1,083 | 371,332, 1,118 |
  | calls listed | 0 | 4,393 |
  | calls the rule leaves out, each checked | 0 | 12,484 |
  | of them with a test, or with a constant argument the rule doesn't take | | 0 |
  | casts in the asks' list | 0 | 4,140 |
  | declarations asked whether they want their result | 0 | 723 |
  | expressions with nothing listed, each checked | 18,255 | 24,063 |
  | with every warning | 7,931 | 11,812 |
  | of them with another verdict | 0 | 0 |
  | library calls T asks about at reader time, that differ | 0, 0 | 1,171, 0 |
  | expressions C and X compared, that differ | 13,831, 0 | 19,450, 0 |
  | records the kernel makes in place, left, that differ | 185,936, 5,828, 0 | 310,953, 8,881, 0 |

  `sqlite3.c`, Lua and musl have the third piece's counts (12,067, 3,509 and 7,227 calls left out; 35,070, 5,731 and
  26,760 expressions with nothing listed).
- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver: one heading fails, as on main in this container ("Test the preprocessor on the repository's
  translation units against clang", 45 of 66 files, each by the container's clang's resource directory's path).
- The sanitizer rows a pull request's checks don't run (`sanitizers-progress.txt`; native memory, address and thread,
  on the work branch's `a1669aa1e`, the same sources): a build each, `test-checker --part 5/8` (210,342 checks, 0
  failures), and for memory and address the shadow with `--window-tests --verify` and with
  `--window-tests --verify -Wall -Wextra` on `sqlite3.c`, Lua and the compiler's own source, its calls made. Every run
  status 0, no report.

The pull request's head, the same diff on main `28298ce7f` (`results/cloud/head`: the session branch's `5aaf65f14`,
before the documents' correction for buster14a/buster#2967 was added to the commit): a build, `test-checker --part
5/8` (210,342 checks, 0 failures), the self-check, and twenty `--window-tests` runs (the four corpora in five modes),
each status 0 with no difference.

## 4. On the 9700X (`results/9700x/h2`, `h3`, `h1`; `patches/`)

Each build in turn with `h1` in its own job (`job-pair.sh`):

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | `h1` | the build | `h1` | the build | `h1` | the build |
| `h3`, the pull request's sources: the tests on the window | 35.36 | 35.76 | 53.14 | 53.52 | 99.74 | 100.34 |
| bytes | 9.23 | 9.26 | 10.73 | 10.73 | 18.60 | 20.21 |
| loop | 1.59 | 1.63 | 2.29 | 2.31 | 5.04 | 4.84 |
| part | 9.57 | 9.67 | 9.73 | 9.74 | 16.27 | 17.20 |
| rest | 14.94 | 15.15 | 30.43 | 30.58 | 58.92 | 57.51 |
| with every warning | 62.85 | 63.51 | 70.93 | 71.13 | 124.78 | 127.69 |
| beside `--verify` (one reading) | | 85.08 | | 103.73 | | 177.42 |
| the kernel in place, without the tests | 16.40 | 16.45 | 20.84 | 20.90 | 19.09 | 19.19 |
| the front with the window | 53.02 | 53.09 | 71.57 | 71.06 | 88.82 | 92.13 |
| the names' pass, ticks a name | 22.46 | 22.84 | 93.99 | 94.09 | 68.73 | 67.98 |
| `h2`: the tests on the window | 35.65 | 35.59 | 53.21 | 52.85 | 95.15 | 95.81 |
| with every warning | 63.11 | 63.75 | 70.50 | 71.78 | 121.89 | 121.70 |
| the kernel in place, without the tests | 16.36 | 16.54 | 20.89 | 20.81 | 19.07 | 19.12 |
| the front with the window | 52.65 | 53.01 | 71.20 | 70.57 | 89.64 | 89.35 |

Readings of the tests: `h3` 35.4 to 36.0 for 35.1 to 35.9 on `sqlite3.c`, 53.0 to 59.0 for 52.8 to 53.4 on Lua, 95.7
to 111.6 for 97.1 to 111.9 on musl; `h2` 35.3 to 35.8 for 35.3 to 35.9, 52.5 to 58.7 for 52.8 to 53.3, 92.8 to 102.9
for 93.6 to 109.8.

`-c sqlite3.c` as whole processes (21 runs of each of three copies, twice): `h3` wall +0.17% and +0.02%, user cycles
+0.26% and +0.02%, where `h1` against itself reads -0.02% and -0.08%, +0.01% and -0.16%; `h2` wall -0.11% and -0.12%,
user cycles -0.00% and -0.11%, where `h1` against itself reads -0.29% and -0.11%, -0.24% and -0.16%. No compile runs
the code the fixes change.

## 5. Faults (`faults/`)

Nine faults put into the two fixes, one at a time, in a copy of the tree (`round1.py`: the Debug compiler built, then
`test-checker --seed 133 --part 5/8`). Eight fail the tests:

- the fronts' unit-wide term put back, in the lean front (`f-front-unit`: the twelfth fixture's tests run on one
  expression for eleven) and in the flat one (`f-flat-unit`: the flat front lacks the calls the lean one makes);
- the whole front's library mark asked of no function (`f-library-unmasked`: fifteen records differ from the walk's);
- the designator's type, word and category read from its own row's element (`d-type-row`, `d-word-row`,
  `d-category-word`), and the designator taken for a pointer or for every operand (`d-kind-pointer`, `d-kind-always`).

The ninth, `d-type-qualified`, took a strip of the designator's type's qualifiers out, and changed no result: the
type table gives a function type no qualifier (`type_qualify` in `c_types.c`: "none on a function type, whose
qualifiers clang drops"), and `probes/qualified.c` reads the same with the strip and without
(`qualified-fixed.txt`, `qualified-without-the-strip.txt`). The strip is gone from the pull request's sources.
