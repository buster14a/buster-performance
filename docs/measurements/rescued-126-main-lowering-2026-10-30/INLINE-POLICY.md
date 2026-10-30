<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Source-only audit of all-mode coverage

All 11 successful main.c-only process reports define 15,489 function bodies and
select 15,431 in all mode. The 58-body difference is entirely the inline-only
external policy below. All 161,056 data objects are selected in all mode. This
audit uses the source predicates and observed counts; it does not infer names,
instrument the compiler, filter headers or run another compilation.

At measured source `20e01ceb`, the vector
[seed at c_lowering.c:261](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_lowering.c#L261)
sets eligibility to the valid-definition mask minus `INLINE_ONLY`; in ALL mode
every eligible bit is a root. The independent scalar
[predicate at line 387](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_lowering.c#L387)
is `(flags & BUSTER_C_LOWERING_INLINE_ONLY) == 0`, followed by
`eligible && (mode == C_LOWERING_ALL || root_flags)`. Thus root attributes do
not override inline-only status and there is no additional all-mode filter for
names, target ISA support, builtin catalogue, function size or reachability.

The producer constructs that flag at
[c_check_program_select.c:430–444](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_check_program_select.c#L430).
For a definition with a declaration and external linkage (`linkage == 2`), it
starts `inline_only=false`; only a function can make it true. For that function:

1. `gnu` is true when declaration rules contain a nonignored `gnu_inline`
   attribute or `predefines_gnu_inline` selects GNU semantics for the options.
2. In GNU mode, inline-only means the definition's spelling contains both
   INLINE and EXTERN, **and no plain inline declaration** was recorded.
3. Otherwise inline-only is rule mask `0x01`, initialized true and cleared by a
   qualifying function declaration whose `declaration_bodies[token]` is NONE
   and which either lacks INLINE or contains EXTERN.

The [declaration scan](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_check_program_select.c#L372)
initializes mask `0x01`, accumulates `gnu_inline` in `0x02`, and records any plain inline
spelling in `0x04`. Plain-inline handling includes declarations before or after
the definition. A nonexternal definition never receives INLINE_ONLY here; a
data object never receives it. The exhaustive exclusion condition is therefore
external function linkage **and** the applicable GNU/C99 inline-only predicate.

The benchmark measured one file both ways with zero failures and stable counts;
an unsupported required all-mode emission would not produce that successful
main.c-only result. Consequently `15,489 - 15,431 = 58` counts exclusions by this
predicate, not backend refusals or unsupported-ISA pruning. Both modes check all
bodies; calls/addresses of inline-only external bodies retain the external-symbol
contract. This is the language's emission eligibility, not 58 guessed names or
58 silently omitted header intrinsics.
