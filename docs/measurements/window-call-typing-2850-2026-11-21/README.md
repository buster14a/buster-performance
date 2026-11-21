# Typing direct calls before the reader creates the expression graph

The [source patch](experiment.patch) applies to [84a7d3d76](https://github.com/buster14a/buster/commit/84a7d3d76891d6c393497e62e6aff38f2b162fc2). It adds a diagnostic experiment to the window shadow. The experiment types a chunk from its front's postorder records, declaration lines, prepared type rows and argument distances before the ordinary reader emits that chunk's expression graph. It uses a separate cold-initialized cache for call argument conversions. A later pass binds those independent answers to graph nodes and compares them with the ordinary checked stream.

| Corpus | Roots with calls disabled | Roots with direct calls enabled | Calls | Argument conversions checked | Complete value records checked |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 33,089 | 41,897 | 9,064 | 21,691 | 229,526 |
| Lua | 4,308 | 5,755 | 1,491 | 3,207 | 32,612 |
| musl | 22,976 | 23,484 | 522 | 1,134 | 98,041 |
| Buster compiler main | 19,897 | 24,820 | 5,395 | 11,922 | 166,717 |

All checked records matched the ordinary 96-byte checked value, including the inactive integer payload, complete floating storage and fault fields. The probe also compared ordinary operand-conversion types and flags, member offsets, token identity and every accepted call argument's conversion type and flags. All comparisons agreed. A mutation flipped a type bit or a flag bit in one independent argument for each accepted nonempty call. On SQLite the resulting 8,960 argument differences were detected in 8,713 roots, with unchanged values and coverage. [Per-corpus and per-fixture counts](summary.tsv) · [Full diagnostics and census output](runs.tar.xz).

The selector requires a named function designator with its own type row and independently typed arguments. It excludes indirect calls, unprototyped calls and floating subtrees in the tested mode. Zero-, one-, two-argument, nested and variadic fixtures all had positive cases. The shortest combined fixture had no accepted calls, while 64 repeated functions had 526 accepted calls. A declaration's presence alone is insufficient for a prepared derivation. The `noreturn`, `const` and target-attributed fixtures all provide positive typing cases. Using one of these results in a real compiler still requires the caller's ABI and reference data and its attribute, control-flow and target diagnostics. The measured unit here is a comparison in the shadow.

## Reproduction

Apply the patch to the base and build on a supported Zen 4/5 host using the repository toolchain. Enable `NODE_PROOF_POINTERS=1`, `NODE_PROOF_NO_FP=1` and optionally `NODE_PROOF_CALLS=1`. Invoke `build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0` with each corpus argument list. [corpora.sh](scripts/corpora.sh) expects the frozen SQLite, Lua and musl source layout used by the earlier [independent typing experiment](../window-compile-2850-2026-11-21/independent-t/). For Buster use the repository main translation unit with its native predefines, `-Isrc -march=native -fwrapv -funsigned-char`. [Original invocation script](scripts/original-runner.sh) · [Build and patch digests](build.txt).

Run [generate.py](scripts/generate.py) to write the generated fixtures beside the script. Re-run SQLite with `NODE_PROOF_FAULT_ARGUMENT=1` for the directed mutation. An input with zero eligible roots can omit the comparison line. Use the file census's status together with the counters.
