# The row's unit parts: emit-setup, code-atoms, publish-data, object-build (buster#3393), 2026-11-23

[buster#3393](https://github.com/buster14a/buster/issues/3393) is step 4's piece 6 of
[buster#2874](https://github.com/buster14a/buster/issues/2874): the four stages after Tier 0's code that make a unit's
link and object, from 2.24 ms to 1.2 ms or less on `sqlite3.c`, every object byte-identical. This is the record of the
pull request's measurements: the result against the gate, how each change was found and what it bought.

## The result against the gate

**Not met.** The four stages' sum went from **2.242 ms to 1.670 ms** (−0.572 ms, −25.5%); the gate is 1.2 ms or less,
refuted above 1.6 ms. Every object is the same as main's.

`-c sqlite3.c`, the 9700X, CPU 2, one hold, medians of 7 (`results/final-base`, `results/final-f1`; min and max of the
seven in brackets):

| stage | main `f758fca1` | the branch | change |
| --- | ---: | ---: | ---: |
| `emit-setup` | 1.024 (1.000–1.097) | 0.660 (0.649–0.685) | −0.364 |
| `code-atoms` | 0.312 (0.307–0.316) | 0.299 (0.289–0.305) | −0.013 |
| `publish-data` | 0.495 (0.485–0.504) | 0.305 (0.304–0.307) | −0.190 |
| `object-build` | 0.411 (0.403–0.418) | 0.406 (0.398–0.415) | −0.005 |
| **the four** | **2.242** | **1.670** | **−0.572** |

Lua 5.4.8 and musl, a process a file, the four stages summed over the units, each unit's median of 3 rounds
(`results/units-base.tar.zst`, `results/units-f1.tar.zst`; `scripts/units.sh`, `units-table.py`; `units-main.tar.zst` is the same with `c7809112`). They don't gate:

| corpus | units | main | the branch |
| --- | ---: | ---: | ---: |
| Lua 5.4.8 (`src/*.c`) | 34 | 3.563 ms | 2.569 ms |
| musl (`src/string`, `src/stdio`) | 188 | 8.838 ms | 6.080 ms |

A unit's fixed part moved with the rest: about 105 to 76 µs a Lua unit and 47 to 32 µs a musl one.

## What was measured

- **Revisions:** buster main `f758fca1` (the branch's base) and the pull request's head `9ef48248`, Release,
  `BUSTER_HOST_ARCH=znver5`, built in a cloud container with CI's staged toolchain (LLVM 23.1.4) and copied stripped.
  `binaries.sha256`: `base` (main `f758fca1`), `f1` (the head). The step runs (`results/steps`) and the first profile
  compared with `main`, a build of `c7809112`, the main of the session's start: its objects and these four stages are the
  same as `f758fca1`'s (`results/steps/main-*` against `results/final-base`).
- **Input:** the frozen corpus (`tools/ci/fetch-corpus.sh`), `sqlite3.c` with `--predefines
  provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc` and the corpus's three `-isystem`
  directories (`scripts/stages.sh`): 706,216 tokens, 2,602 bodies, 4,700 symbols, 2,036 data objects, 22,406 fixups.
- **Holds:** every 9700X run under `exclusive.sh`, a hold a set of runs.

## Exactness

- **Objects:** `scripts/objs.sh` compiles 3,166 inputs with main's binary and the head's, each with no flags, `-g`,
  `-funwind-tables` and both (12,664 compiles), and compares every object's SHA-256 and every exit status: `sqlite3.c`,
  Lua 5.4.8's 34 units, musl's 1,355 units with its build's options, the compiler's own `main.c` (a frozen copy of main's
  `src/`, since the branch changes the sources it compiles), c-testsuite's subset and `tests/**/*.c`. No difference at
  any step (`results/exactness/main`, `results/exactness/head`, `inputs.txt`); 2,172 inputs make an object, the others
  stop where main's stop. These ran on the cloud container's Sapphire Rapids with `native` builds.
- **On the 9700X:** every gate and step run's `sqlite3.c` object is `11db5412…`, main's; the Lua and musl objects are
  main's (each archive's `objects-*.txt`).
- **The correctness inventory's blocks** for the emission, the link and the object writer (`results/exactness/
  inventory.tests`, run by the head's `parallel`, `inventory.log.zst`): the functions' lanes, the link representation,
  the lanes, the runtime snapshot, the static executables, the dynamic PIEs, the direct path's executables, the
  semantic driver against clang (all 8 parts), musl's and `main.c`'s functions and objects against clang -O0, the
  emission metadata, the tier-neutral emitted function and the object writer. All pass but the object writer's
  `--cross-check`, whose 44 failures are this container's: its clang 23.1.6 refuses `-fuse-ld=wild`. Main's binary fails
  the same 44 (`object-writer-cross-check-main.log.zst` against `-head`); every other check of the block passes.
- `./build.sh check-call-graph`: 0 cycles (`call-graph.txt`).

## The changes, and what each bought

The stage clock of each step's head against main in the same hold (`results/steps`, four stages):

| step | head | main | the four |
| --- | --- | ---: | ---: |
| one list of the attributed declarations; the given names hashed eight at a time and added at once | t12 | 2.219 | 2.012 |
| the static data's plan reads the live parts its preparation found; the string pool's candidates once | t4 | 2.242 | 1.926 |
| the scans' misses in flight (prefetch); the numbered names without `snprintf` | t7 | 2.236 | 1.777 |
| a table's parts with their type's shape once; `link_check` over the atoms with fixups; the report after the object | t11 | 2.230 | 1.700 |
| the symbols' prefetch to the bodies' sparse block and the identifiers' spans | t12p | 2.205 | 1.659 |
| the relocations read the count's codes; the dead callees' walk only with candidates | t13 | 2.241 | 1.664 |

1. **The attributed declarations' scan, once.** `check_tier1_inline_marks` and the symbols' attribute pass each walked
   `CheckInput.attributes`; `check_program_attributed` lists the 2,577 attributed declaring tokens once with a byte of
   what their 3,261 records hold for each reader (a table by kind). As one loop it still took 215 cycles a declaration,
   a chain of misses (the directory, the block, the attributes, the records): it now lists the directory's slots first
   (`check_sparse_wide_slots`, prefetching each block), compresses each group's declaring tokens by a vector compare,
   then prefetches every attributes record before reading them. 101 → about 47 µs, and the second walk is gone.
2. **The given names.** One pass over the symbols decides which names the source gives (`check_program_emit_makes_name`
   ran twice a symbol), lists their spellings, hashes them with `link_hash_names` and, in a unit that makes names, adds
   them with `link_add_names`: one push, a masked 64-byte copy a name. The NameIds and the name arena's bytes are the
   same as before.
3. **The live parts.** `check_data_prepare` already runs `check_initializer_live` for each initializer's references;
   `check_initializer_references_live` keeps its marks with the object (`CheckDataObject.live_parts`), and the plan
   reads them instead of running it again.
4. **A table's parts.** `check_data_plan_scalar` is its type's shape, its symbol and its value; an initializer's parts
   reuse the shape of a run of one type and the object's symbol. The parts' loop: 119 → 85 µs.
5. **Prefetch in the symbols' passes.** The names pass, the main symbols loop and `check_program_object_access`'s last
   loop read columns at each symbol's declaration (a token anywhere in the unit): each prefetches the declaration 16
   symbols ahead, its columns 8 ahead and the sparse block and intern span they lead to 4 ahead. The main loop: 162 →
   about 100 µs.
6. **`snprintf`.** The literals', jump tables', cases' and the other made symbols' names are a prefix and a number:
   `check_program_emit_numbered` writes them (about 3,000 a unit here).
7. **Smaller ones:** the static objects' scan tests each 64 tokens' bits and kinds with two masked byte loads; a private
   size wrapper's test reads attributes of inline functions only; `link_check` visits only the atoms with fixups, 16 at a
   time; the lowering's coverage line (`--time-stages`' own write to stderr) is printed after the object's stages; the
   relocations read the codes `object_count_symbols` found; `check_tier1_inline_dead` skips its walk without candidates;
   a code fixup's form is described once and its placeholder cleared by a masked store.

### What didn't pay

- **A vector `link_add_code_fixups`** (eight references a batch: the references, instructions, form descriptions, kinds
  and fixup ends gathered, ten gathers a batch) made the bodies' atoms' loop 158 → 227 µs: Zen 5 issues gathers slowly
  and a body has 8.6 references on average, so the batches are short. Reverted; the scalar loop says why.
- **The static objects' scan, 16 tokens a chunk** whenever any of 64 had the static bit: 43 → 104 µs. Replaced by the
  64-token byte masks above, under the scalar loop's cost.

## Where the 1.67 ms is

Lap runs (`results/laps`, the experiment's `BUSTER_XLAP` laps: `scripts/xlap.py` inserts them, `laps.py` reads them,
each lap's 7 ns subtracted; `xlap6` is the step before t13). Approximate µs on the 9700X:

- **`emit-setup` (0.66):** the main symbols loop ~100, the names' pass and their hashing and copies ~130, the attributed
  list ~47, the static objects ~50, the inline table ~50, the dead callees and literals ~35, the jump tables' and cases'
  symbols ~23, and the stage clock's marks (below).
- **`code-atoms` (0.30):** the bodies' atoms' loop ~125, most of it `link_add_code_fixups`' 22,406 references; the
  windows' copies of each body's references and records out of the window.
- **`publish-data` (0.31):** the parts' loop ~85, the string pool ~53, the plans' fixups ~20.
- **`object-build` (0.41), unchanged:** `object_count_symbols`' fixups ~86, `object_fill_relocations` ~80,
  `link_check`'s atoms ~83, `object_fill_sections` ~56 (copying about a megabyte of atoms' bytes into the object),
  `object_prepare` ~31. The relocations' reuse of the count's codes and `link_check`'s skip of atoms without fixups
  moved nothing measurable: these passes are per fixup and per byte, and already vectorized where their owners found it
  paid.

**The stage clock's own cost.** Each `check_clock_mark` reads `getrusage` and `/proc/self/status` and charges both to the
stage it marks: about 15 µs on the 9700X (the lap around a mark, `xlap6`'s lap 22; `scripts/markcost.c` measures the
two reads alone). These four stages take about eight marks, so about 0.12 ms of both columns is the clock's. The branch
doesn't change the clock: the comparison would move without the compile's work changing.

## Files

- `scripts/stages.sh`, `table.sh`: the stage clock (the row record's, its directory renamed); `units.sh`,
  `units-table.py`: Lua and musl; `xlap.sh`: a lap run; `ship.sh`, `mklap.sh`, `result.sh`: the cloud side's build, copy
  and launch of a run; `xlap.py`, `fn.sh`: the laps' insertion (`lap-experiment-main-c.patch`: the laps' counters);
  `laps.py`, `agg.py`: their table and a profile's by symbol and line; `objs.sh`, `cmp.sh`: the objects' comparison;
  `markcost.c`: a mark's two reads; `profile.sh`, `profile-post.sh`: the first profile.
- `results/final-*`: the gate; `results/f1`, `main-f1`: the head against `c7809112`'s main, the same objects and within a few µs; `results/units-*.tar.zst`: Lua and musl; `results/steps`: each step's set; `results/laps`: the lap
  runs with their maps (`laps.map`: lap number, the line it precedes); `results/prof-main`: the first `cycles:u` profile's
  busy files (the samples aren't kept); `results/exactness`: the objects' lists, the inventory's log and its blocks.
