# The checker's unit in pieces: a measured prototype (buster#2627)

[buster#2627](https://github.com/buster14a/buster/issues/2627) is lever 4 of `docs/stage1-build-design.md`: compile
the largest `main.c` units in pieces along their files, so that an edit pays one piece's front end rather than the
whole unit's. The issue's numbers were an estimate. This record builds the checker's unit (`main_unit_checker.c`,
721 of buster's own files, 41.5 MB of source) in 8 pieces with a prototype, checks the result, and times
edits against Develop's whole unit on the 9700X. Sources: `buster14a/buster` at `a11e44ac` (buster#2633's
fixtures commit), CI's toolchain (LLVM 23.1.4).

## The prototype (`prototype/`)

Nothing in it is in buster's tree; it reads a configured, built Develop tree and writes its own.

- **`pieces.py`** rewrites the unit's own files into 8 trees, one per piece. A piece's files are a contiguous run of
  the unit's include order, balanced by bytes (`assignment.txt`). In piece *k*'s tree:
  - the files of piece *k* are whole;
  - every other file's function bodies are blanked to declarations, keeping their lines, unless the function is
    inline (by any declaration of it, or a macro whose value in this unit is inline) or takes an attribute only a
    definition may (`no_builtin`);
  - a `static` function that isn't inline, and a mutable one-line file-scope variable, become hidden and external
    (`BUSTER_PIECE_HIDDEN`) everywhere, defined only in their own piece; a tentative definition is weak, as two
    files may repeat one;
  - constant tables, inline functions and everything else stay as they are, in every piece.

  The unit's macros (`macros.h`, clang `-dM -E` of the unit) decide which macros expand to `static` or `inline`
  (`main.c`'s `BUSTER_HOME_*` differ by unit). A per-file cache rewrites only the files that changed: 0.2 s after an
  edit, 7.3 s from nothing, in Python.
- **`piece-cc.sh`**: the unit's Develop front end on one piece's tree, its files mapped back to the source tree's names
  (`-fmacro-prefix-map`, `-fdebug-prefix-map`), so that `__FILE__` and the line tables, by which `presplit` groups a
  file's functions, are the source tree's.
- **`piece_rename.c`** (LLVM's C API), on each piece's bitcode before its split:
  - a named local variable (a constant table, an inline function's `static`) is defined by one piece alone, the first
    that defines it (`owners.sh`, from `llvm-nm`). The others read a constant `available_externally` and declare a
    mutable one. Each object then has one address. Copies per piece broke `test-checker` with a bus error: an
    index computed by subtracting one piece's copy of `check_builtin_atomic_rmw_rules` from a pointer into another's;
  - local functions (inline copies) and clang's private variables are renamed `pK.NAME`, each piece's own.
- **`gen.sh`** writes a Ninja build. For each piece it runs the front end, `piece_rename`, then `presplit` with Develop's
  options (via `BusterCodegenSplit.cmake`) into 6 code parts and a data part, and each part's `-O3` job. It then joins
  all 56 parts with `BusterCodegenMerge.cmake`, with the whole unit's exports, and runs the tree's Develop link and
  bake with that object in the checker's place. Every step writes its outputs only when they change (`restat`), and
  the pieces' trees are the transform's outputs, so that an edit repeats only what it changed.

Joining the pieces' bitcode before one split (llvm-link, 53 MB) took 13.3 s in the cloud container, more than an
edit saves, so each piece is split on its own.

- **`SMALL=10`** (`pieces.py`'s option; `n10`): a `static` function whose body has at most 10 lines stays whole in every
  piece, as an inline one does, unless an attribute keeps it (`used`, a constructor). 5,033 functions are then whole
  everywhere, against 424 inline ones.

## Correctness

The pieced Develop executable passes `test-checker` with **829,707 checks, 0 failures**, the count of the tree's own
executable. That holds on both hosts, and with `SMALL=10` too:
- the cloud container, 4 CPUs, `-march=native`: `local/test-checker.txt` and `local/test-checker10.log`;
- the 9700X, `znver5`: `results/test-checker.log` and `results/test-checker10.log`.

The executables are 77.2 MB, and 78.8 MB with `SMALL=10`, against the whole unit's 71.4 MB on the 9700X
(`results/runtime-compilers.txt`): each piece's copies of inline functions and tables, and their parts.

## Edits on the 9700X (`prototype/edits.sh`, `results/edits.tsv`, `logs/`)

The tree is `a11e44ac`'s, built in Develop (`results/develop-build.log`: 26.5 s, the checker's unit 7.0 s of it).

- **The two sides.** Each round is one hold of the lock, and both sides use Ninja on 8 jobs, up to the same link and
  bake.
  - **whole:** the tree's own Develop build.
  - **pieces:** `gen.sh`'s build.
- **The two edits**, both to `c_check_input.c`:
  - **append:** #2624's, a function added at the file's end;
  - **body:** one string of `check_input_invalid_redefinition_note` changed, with no line moved.

| Edit | whole | pieces | pieces, `SMALL=10` |
| --- | --- | --- | --- |
| append | 14.79, 14.04, 12.25 s (25, 21, 13 parts) | **4.56, 4.53, 4.56 s** (8 front ends, 1 part) | 5.04, 4.99 s |
| body | 12.26, 12.28, 12.28 s (1 part) | **6.36, 6.35 s** (1 front end, 1 part) | 6.50, 6.50 s |

The pieces' first body round (7.07 s, 8 front ends) is left out. The transform's cache then forgot what it had
written, so every piece's copy was rewritten; it has been fixed since.

- **Where the time goes** (`results/*-ninja-log-tail.txt`, a body edit's rebuild):

  | Step | whole | pieces |
  | --- | ---: | ---: |
  | transform | | 0.13 s |
  | front end | 5.1 s | 1.17 s |
  | owners and rename | | 0.45 s |
  | split | 3.4 s | 0.37 s |
  | the edited function's code part, `-O3` | 3.1 s | 3.35 s |
  | merge | 0.5 s | 0.71 s |
  | link and bake | 0.13 s | 0.14 s |

  The code part is now the largest cost. More, smaller code parts per piece would cut it.
- **An appended function** reaches every piece as a declaration, so all 8 front ends run, at once. Their bitcode
  is unchanged but for the piece that defines it, so the rest stops there.
- **The front end's work rises.** In the latest rebuild of all 8 pieces, they took 1.13 to 1.60 s each, 11.4 s in
  all (12.5 s with `SMALL=10`), against the whole unit's 5.1 s. A clean build pays that. The prototype has no
  whole-tree clean build to measure it end to end.

## Develop's run time (`prototype/runtime.sh`, `results/runtime.tsv`, `results/runtime10.tsv`)

Buster#2624's workloads on CPU 2, three rounds, each one hold, user instructions and cycles:

| Workload | whole | pieces | pieces, `SMALL=10` |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c`, instructions | 1,392.3 M | 1,461.5 M, **+4.97%** | 1,397.4 M, **+0.36%** |
| `-c sqlite3.c`, cycles (median) | 612.0 M | 644.8 M, +5.4% | 618.9 M, +1.1% |
| checker's unit, instructions | 21,271 M | 22,696 M, **+6.70%** | 21,542 M, **+1.27%** |
| checker's unit, cycles (median) | 8,270 M | 8,757 M, +5.9% | 8,236 M, −0.4% |

- **Why pieces run slower:** a `static` helper defined in another piece can't be inlined, as `presplit` imports bodies
  only from within its own module.
- **What `SMALL=10` does:** it keeps short bodies in every piece, and takes most of that back for about 0.15 to 0.5 s
  per edit.

## What it says about buster#2627

- **The edit.** An edit of the checker's unit falls from 12.3–14.0 s to 4.5–6.5 s. The front end and split together
  fall from 8.5 s to about 2 s, which is what the issue estimated. The edit is then bound by the edited function's code
  part.
- **The cost.**
  - The front end's work: 2.2 to 2.5× the unit's.
  - Larger executables.
  - Develop's run time: +0.4% to +1.3% instructions with `SMALL=10`.
- **Release** can keep its whole units. Nothing here changes its commands.
- **Production would need:**
  - the transform in C, with the build owning the piece trees;
  - `piece_rename` beside `presplit`;
  - the pieces' Ninja rules in `BusterCodegen.cmake`;
  - a stable rule for which file is in which piece (here, byte balance in include order);
  - the transform's limits: line-shaped definitions (the code style's), one-line mutable variables, and macros
    resolved by the unit's `-dM` values.
