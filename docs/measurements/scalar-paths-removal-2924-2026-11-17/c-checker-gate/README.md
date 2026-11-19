# C12c's gate: the checker and the program, area by area (#2924)

C12's gate ([`../c-front-end-gate`](../c-front-end-gate)) sent the checker and the program to their scalar paths as whole
stages: +1.5% to +3.8% and +2.1% to +5.2% of user cycles. A part whose vector path loses could hide in either. This gate
gives every part its own bit, in one experiment executable, as C12a's did for the preprocessor
([`../c-preprocessor-gate`](../c-preprocessor-gate)).

## The executable

Main `1962b1f73` (#3024's merge) plus [`c12c-areas-knob.patch`](c12c-areas-knob.patch), EXPERIMENT ONLY. The executable
takes its bits from its file's name (`compiler-areasN`, `/proc/self/exe`), so copies of one executable are the settings.
The patch is made by two scripts from the tree and C12's root patch:

- [`knob2.py`](knob2.py) gates the flag **where its name is defined**, so every read in a function agrees:
  - a definition's `bool scalar` parameter becomes `scalar_raw`, and the body starts with
    `const bool scalar = scalar_raw || buster_scalar_area(FILE_BIT);`;
  - a local that holds the flag (`const bool scalar = parser->options.scalar;`) gets the same pair;
  - what leaves a function goes raw: a whole call argument or a store of `scalar` becomes `scalar_raw` (a callee in
    the checker gates itself with its own file's bit), and a callee in another module gets that module's foreign bit;
  - a read of the flag's field (`parser->options.scalar`, `options->scalar`, `writer->scalar`) takes the file's bit in
    a branch and stays raw as a whole argument or a store;
  - C12's roots (the driver's `scalar || buster_scalar_area(N)`) read `scalar_raw`.
  What the rules don't decide it lists (`knob2.residue`).
- [`hand.py`](hand.py) makes the hand edits from that list, each with its count: the twin choices of other modules'
  functions (the bindings' sort, the type table's lookups, the builtins' fold and lowering, Tier 0, the IR's promotion,
  the assembler, the unwind tables) take a foreign bit, and two stores that leave the checker stay raw.

| Bit | Area | Files |
| --- | --- | --- |
| 10 | the reader | `c_check_input.c`, `c_check_*_input.c`, `c_check_source_prepare.c`, `c_check_string_pool.c` |
| 11 | the bindings | `c_check_binding.c`, `c_check_body_bindings.c` |
| 12 | the warnings | `c_check_common_warnings.c`, `c_check_warning_graph.c`, `c_check_warning_undefined.c`, and six more |
| 13 | the attested declarations | `c_check_attested.c` |
| 14 | the checker's core | every other `c_check_*.c` and `c_checker.c` |
| 15 | the program | `c_check_program.c`, `c_check_program_*.c` not below, `c_check_tier0_inline.c` |
| 16 | its lowering | `c_check_program_lower.c`, `c_check_lower_inventory.c` |
| 17 | its aliases | `c_check_program_alias.c` |
| 18 | its emission | `c_check_program_emit.c` |
| 19 | selection | `c_check_program_select.c` |
| 20 | its asm | `c_check_program_asm.c` |
| 21 | the driver | `c_checker_driver.c`, `c_checker_units.c`, `c_check_corpus.c` |
| 22 | foreign: the front end's | the bindings' sort and resolution, the type table's lookups, the builtins' fold and filter |
| 23 | the static data | `c_check_data*.c` |
| 24 | the lazy planner | `c_check_lazy*.c` |
| 25 | the node machine | `c_check_node_*.c` |
| 26 | the checker's Tier 1 | `c_check_tier1*.c` |
| 27 | foreign: the builtins' lowering | `cbuiltin_*lower_scalar` |
| 28 | foreign: emission's | Tier 0's compile and validation, the IR's promotion, the assembler, the unwind tables, the debug metadata |

Bits 2 to 7 are C12's roots (the parser's flag, the lazy planner, the checker, the static data, the program, selection),
kept for the closure check.

## Checks, before any timing ([`checks.sh`](checks.sh))

1. **Objects:** `-c --lanes 1` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c` by main and by the knob
   executable with no bit, each bit alone, the roots together and the areas together, every object compared with main's.
   A difference means a gated name that is not the flag, or a mode made in one area and read in another (two areas
   to merge).
2. **Closure:** the roots together and the areas together are one executable's two routes to the same scalar paths, so
   their instructions must be equal to noise on every list; a gap is a read the rewrite missed.

## The verdict rule, written before the run ([`gate.sh`](gate.sh))

`ab`, three rounds, around `time-runs` (three runs each) of a group of builds with two no-bit copies, one group and one
list at a time: sqlite3.c, Lua's units and musl's units, `-c --lanes 1`, under the lock on CPU 2.

- **The control:** `none-again` against `none` in every group, and the lazy planner's bit (24), whose code doesn't run
  without `-flazy-system-headers`. Their spread is the control's.
- **An area's vector path wins** where its scalar path reads more user cycles than `none` in every round of every list
  on which its instructions differ.
- **At parity** where its rounds stay within the control's spread: listed for David with selection's parity
  (6993671884), in one batch, before its twins go.
- **It loses** where its scalar path reads fewer cycles than `none` beyond the control's spread in every round of a
  list: it goes to David first, as the body scan did (7006161887).
- A list on which an area's instructions are equal to `none`'s (its code doesn't run there) judges nothing.
- The node machine (25), the checker's Tier 1 (26, the frame colorer's #2699), the static data (23) and the lazy
  planner (24) are measured and reported apart.

## The checks' results

Everything the 9700X wrote is in [`logs.tar.gz`](logs.tar.gz): `logs/` (the timed executable's), `logs-run1/` (the
first knob's), `locate/`, `stages/` and `trace/`.

**Objects** (`logs/status.txt`): every setting's 1,372 objects are byte-identical to main's, no bit,
each bit alone, the roots and the areas, on both executables below.

**The knob's own cost, found by the closure check.** The first executable (`logs-run1/`) kept C12's
`buster_scalar_area`, an out-of-line function at many of the ~1,000 gated sites. `scalar_raw || buster_scalar_area(N)`
calls it on every evaluation where the raw flag is false and skips it where true, so the areas alone retired more
instructions than the areas with the roots: sqlite3.c +35.28 M, Lua +13.99 M, musl +94.74 M. Exact counts with one
root at a time put 31.7 M of sqlite3.c's on the parser's flag; `compiler start-trace` of the two showed the same
functions run, with only the out-of-line `buster_scalar_area` first running at a different point
(`locate/` holds the `perf record` profiles that couldn't tell: fixed periods moved big functions by two
points from run to run). The executable timed below (`hand.py`'s last edit) makes the knob a load, a shift and a mask of
a global its constructor sets. It also gates the one local that held the parser's flag under another name
(`c_check_literal_table_input.c`'s `scalar_store`).

**Closure, on the executable timed** (`logs/closure5-*.log`, one run each, instructions):

| | sqlite3.c | Lua | musl |
| --- | --- | --- | --- |
| No bit against main (the knob's cost) | +12.43 M (+0.92%) | +4.40 M (+0.51%) | +31.79 M (+0.47%) |
| The areas against the areas with the roots | +4.78 M | +1.93 M | +13.19 M |
| The areas with the roots against the roots with the driver's bit | +0.10 M | +0.60 M | +14.41 M |

The roots alone reach less than the areas: the driver's own uses of the command's flag (bit 21) have no root. With it,
the roots and the areas reach the same to 0.1 M, 0.6 M and 14 M (0.09% of musl's), and adding the roots to the areas
changes 0.1%: the gates' loads where the raw flag is false. The knob costs no bit 0.5% to 0.9% of instructions against
main, the same in every setting.

## The gate's results

`logs/time-g*-*.log`, summarized by [`gate_parse.py`](gate_parse.py) ([`table.txt`](table.txt)): user cycles
against `none`, round by round, and the instructions' median against `none`'s.

| Area (bit) | sqlite3.c | Lua | musl | Instructions (sqlite3.c, Lua, musl) |
| --- | --- | --- | --- | --- |
| none again (control) | +0.37%, −0.34%, −0.12% | −0.16%, −0.10%, −0.46% | −0.19%, +0.22%, −0.06% | +0.00 M, −0.00 M, −0.02 M |
| driver (21) | +15.19%, +15.70%, +15.58% | +8.10%, +8.18%, +7.95% | +5.11%, +5.31%, +5.18% | +355.95 M, +96.65 M, +484.02 M |
| reader (10) | +70.45%, +71.73%, +71.41% | +43.23%, +43.44%, +43.16% | +34.80%, +35.05%, +34.85% | +1700.72 M, +631.61 M, +4163.37 M |
| core (14) | +15.51%, +15.58%, +15.56% | +3.41%, +3.49%, +3.17% | +1.54%, +2.00%, +2.03% | +405.77 M, +55.09 M, +235.56 M |
| bindings (11) | +1.41%, +2.01%, +1.46% | +1.32%, +1.38%, +1.17% | +1.35%, +1.39%, +1.37% | +30.84 M, +12.09 M, +89.54 M |
| attested (13) | −0.27%, +0.20%, +0.28% | +22.90%, +23.08%, +22.85% | +23.10%, +23.05%, +23.17% | +0.00 M, +268.43 M, +2400.90 M |
| warnings (12) | +36.91%, +37.92%, +37.86% | +17.70%, +17.63%, +17.34% | +13.85%, +13.98%, +14.00% | +868.72 M, +267.50 M, +1812.41 M |
| asm (20) | −0.12%, −0.13%, −0.19% | +0.17%, +0.08%, −0.11% | +0.15%, +0.09%, +0.29% | +0.00 M, +0.01 M, +0.02 M |
| program (15) | +3.83%, +3.87%, +3.40% | +2.26%, +2.43%, +2.08% | +1.80%, +1.90%, +2.03% | +99.89 M, +35.90 M, +248.61 M |
| selection (19) | +0.79%, +0.44%, +0.26% | +0.63%, +0.49%, +0.31% | +0.53%, +0.71%, +0.59% | +18.13 M, +7.72 M, +53.87 M |
| lowering (16) | +6.72%, +6.59%, +6.44% | +3.97%, +3.83%, +3.22% | +3.12%, +2.93%, +2.93% | +175.09 M, +52.82 M, +358.79 M |
| emission (18) | +15.91%, +16.19%, +15.33% | +8.08%, +7.99%, +7.98% | +5.97%, +6.05%, +5.62% | +342.81 M, +90.98 M, +450.72 M |
| aliases (17) | +0.35%, +0.34%, +0.08% | +0.15%, +0.13%, −0.05% | +0.77%, +0.67%, +0.33% | +9.53 M, +2.46 M, +18.04 M |
| foreign: emission (28) | +10.07%, +11.07%, +10.22% | +4.83%, +4.90%, +4.92% | +2.29%, +2.08%, +1.91% | +192.39 M, +45.60 M, +91.62 M |
| foreign: front end (22) | +0.31%, +0.46%, +0.30% | −0.10%, −0.03%, −0.05% | +0.01%, +0.09%, +0.16% | +1.71 M, +1.23 M, +5.13 M |
| foreign: builtins lowering (27) | −0.09%, +0.33%, −0.01% | −0.33%, −0.17%, −0.08% | +0.10%, −0.09%, −0.19% | +0.08 M, +0.01 M, −0.18 M |
| static data (23) | +0.23%, +1.04%, +0.33% | +0.03%, +0.16%, +0.21% | +0.45%, +0.40%, +0.11% | +5.71 M, +2.51 M, +17.03 M |
| checker Tier 1 (26) | +0.08%, +0.15%, +0.06% | −0.32%, −0.22%, −0.30% | −0.14%, −0.21%, −0.21% | +0.01 M, +0.00 M, −0.01 M |
| lazy planner (control) (24) | −0.38%, +0.25%, −0.16% | −0.04%, −0.07%, −0.20% | +0.12%, +0.24%, −0.06% | +0.01 M, +0.01 M, +0.02 M |
| node machine (25) | −0.50%, +0.36%, +0.02% | −0.30%, +0.06%, −0.21% | −0.09%, −0.18%, −0.26% | +0.01 M, +0.00 M, +0.02 M |
| all areas | +135.64%, +134.97%, +135.18% | +99.88%, +99.93%, +99.43% | +83.68%, +83.81%, +83.89% | +3268.43 M, +1367.77 M, +9425.18 M |
| C12 roots | +119.57%, +119.68%, +120.21% | +91.94%, +92.02%, +91.50% | +78.59%, +78.94%, +78.88% | +2907.60 M, +1268.61 M, +8913.90 M |

The control's spread: `none-again` reads −0.46% to +0.37%, the lazy planner's bit (which doesn't run) −0.38% to +0.25%.

**This table measures overlapping areas; it decides nothing.** The solo deltas' instructions sum to 4,207 M, 1,571 M
and 10,430 M against the areas together's 3,268 M, 1,368 M and 9,425 M, and leave-one-out (the areas together against
the areas without one bit, exact counts) reads about zero for the lowering, the aliases, the emission, selection, the
driver and emission's foreign twins: another bit already drives their code. [`table2.txt`](table2.txt) has this
executable's `--tier1` and `-flazy-system-headers` runs ([`gate2.sh`](gate2.sh)), with the same caveat.

## The overlap, and the third executable

A gated value crossed area boundaries in forms rule 3 didn't make raw: a path macro around the flag
(`BUSTER_SCALAR_PATH(scalar)`, `!BUSTER_SCALAR_PATH(parser->options.scalar)`) as a whole argument or a store, and gated
locals of other names (`vector`) handed to another area's functions. The driver's
`check_program_emit_timed(..., BUSTER_SCALAR_PATH(scalar), ...)` put the program's emission under the driver's bit, the
emission's `check_lower_prepare(..., BUSTER_SCALAR_PATH(scalar), ...)` the lowering under the emission's, and so on.

[`knob3.py`](knob3.py) and [`hand3.py`](hand3.py) make the third executable
([`c12c-areas-knob3.patch`](c12c-areas-knob3.patch)): every whole argument or store that is the flag in any of its forms
crosses raw, and the function it reaches gates the parameter it arrives in with its own file's bit, whatever the
parameter's name (`exact`, `vector`: `P = P_raw && !area` for the vector sense). [`leaks.py`](leaks.py) lists what still
leaves an area; what it lists on the third executable is inside its own area (the flag's locals, the reader's modes,
the roots and the foreign wraps). [`all3.sh`](all3.sh) runs the checks, the closure, leave-one-out and the gate again.
Results follow.

