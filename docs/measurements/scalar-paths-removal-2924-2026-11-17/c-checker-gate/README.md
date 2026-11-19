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

## Results

Pending.
