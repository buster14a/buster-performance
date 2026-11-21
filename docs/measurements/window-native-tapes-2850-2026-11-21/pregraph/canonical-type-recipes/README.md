# Source type recipes preserve the ordinary checker's type numbering

A pointer type can be absent when the source window reads a direct call, although C already determines the callee's conversion. The durable key is the declaration's function type. For address-of and array decay the key also carries the appropriate pointee qualifiers. The four potentially affected fields in the source proof are the value's own type, either operand conversion, and the type part of an argument conversion.

On SQLite the first private direct-callee experiment retained raw provisional IDs in the shadow comparison. Recording the pointee before the view expires, then resolving the recipe in the completed ordinary table, removed all 6,342 conversion differences across 209,003 checked records. This change leaves the set of native tapes identical. It leaves the complete 57,094,544-byte ordinary graph capture and the 2,061,200-byte ELF identical as well.

Two source implementations run with the post-numbering reference type pass disabled throughout the file.

- The general private view creates only address, array-decay and function-decay pointers requested by source operands and direct call signatures. It supplies isolated fact rows and restores the type table at the end of each window. A stable pointee key survives through operands, values and call arguments. No proposed root result on this SQLite input escaped as a provisional type.
- The direct-call implementation requires no temporary type view or type interning. For a direct function designator T calculates the return type, inherited flags, prototype and arguments from its declaration. It records the callee conversion as a pointee recipe. The ordinary checker's independently interned pointer is looked up only to verify the recipe after the comparison run. This variant provides a smaller subset than the general private view.

| Frozen SQLite comparison | Reached native roots | Native entries | Direct calls | ABI arguments | Checked records | Differing native roots / checked records |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Private direct-callee view | 25,337 | 122,836 | 6,979 | 16,071 | 209,003 | 0 / 0 |
| General private view with source string names | 28,440 | 149,391 | 9,173 | 22,683 | 254,493 | 0 / 0 |
| Direct-callee recipe without interning | 25,278 | 122,473 | 6,963 | 16,011 | 208,610 | 0 / 0 |

The general view retained 28,452 tapes, including 9,175 calls. Twelve of the retained roots never reached ordinary lowering. It matched 28,990 conversions of call arguments at the T comparison. In a fresh `-c`, all 9,175 retained native callee keys resolved to the ordinary callee conversion type and flags. On the direct recipe run the corresponding fresh-compile verifier also checked the complete T prefix, including calls outside the native subset, and matched 9,379 distinct call sites.

Two independent mutations distinguish semantic fields from emitted code. Keeping the older string table left the same 254,493 checked records exact and made 737 of the 28,440 native roots disagree. Publishing string objects from the current source chunk corrected all 737. Conversely, replacing every newly derived first-operand pointee key by the type `int` left all native entries equal but caused 8,681 checked-record differences in 8,456 roots. The capture hashes and normal diagnostics comparisons document the ordinary output separately.

With the general private view the default Lua run matched 44,332 checked records and 24,765 native entries including 2,135 calls. The musl run matched 153,801 checked records and 38,198 native entries including 2,242 calls. Counts are over the shadow's actual comparisons. Untested warning census classifications are reported in their own channels when the reference hooks are disabled. These are source producer and native-oracle measurements. The ordinary compacting path, the actual compulsory native splice counts, and compiler throughput are separately measured.

The symbolic and general views also ran separately on all four corpora under default, `-Wall -Wextra` and `-Weverything -Wno-c++-compat`. Each of the 24 source/policy/mode runs returned success with zero checked-record or native differences. Under the broadest policy the general view matched 16,024 reached SQLite roots and 62,670 native entries. The per-file ground-truth checks and corpus totals are in the archive.

In 25 generated ordinary CLI fixtures under four policies and four compiler modes, a VLA assignment exposed two changed ELF files (default and debug). The post-check graphs already agreed. The compiler stores a VLA address in a slot, and the generic native consumer had emitted the address of that slot. Applying `vla-address.patch` to the private producer sends its retained symbolic address through the compiler’s ordinary address lowering. All 400 fixed invocations agree on status, diagnostics, graph and ELF. Both complete receipt sets and the generator are included.

## Reproduction

Start at `84a7d3d76891d6c393497e62e6aff38f2b162fc2` and apply `../private-callee-types/base-to-checkpoint.patch`, followed by exactly one of this directory's `private.patch` or `symbolic.patch`. Build with the Buster toolchain. Use the frozen arguments from the parent pregraph record and the flags `NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_SOURCE_ROWS=1 NODE_PROOF_NATIVE=1`.

For the general view use `NODE_CROSS_TYPE_VIEW=1 NODE_CROSS_TYPE_WIDE=1 NODE_SOURCE_STRINGS=1`. Omitting the wide switch gives the private direct-only run. The direct symbolic variant uses `NODE_CROSS_SYMBOLIC_CALLEE=1`. For semantic and native comparison set `NODE_CROSS_CHUNK=b` and run `measure-node-machine --shadow --window-rows --front-first --passes 0`. This mode binds records after numbering for comparison and skips the reference type pass. For ordinary emission set `NODE_CROSS_CHUNK=n NODE_SPLICE_FRONT=1 NODE_SPLICE_ENABLE=1` and run `--lanes 1 -c`. Set `NODE_SOURCE_GRAPH_ORACLE` to a distinct filename to capture the complete checked graph. Omitting `NODE_SOURCE_STRINGS` or adding `NODE_CROSS_MUTATE_KEY=1` exercises the independent controls. The raw per-chunk and per-translation-unit receipts preserve the denominators in each comparison.
