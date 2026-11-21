Part of #2850 (step 2). Fixes #3201, #3202, #3203, #3205, #3206 and #3207. [The tests' specification](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784), [the objects'](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314), [the piece before](https://github.com/buster14a/buster/pull/3199), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/tests-holes-2850-2026-11-21).

> {{file:summary}}

## What it is

The pieces before were gated on four corpora, their fixtures and their one-statement programs: code that warns of nothing. This one runs the shadow over the compiler's own tests' programs (every C string literal of `src/buster/compiler/*_test.c` that is a program, {{=n(v['programs']['inline'])}}, and `tests/`'s {{=n(v['programs']['tests'])}} files, under three warning sets) and closes what they show: {{=n(v['before']['programs'])}} programs with status 1 on main, in fifteen kinds. **No compile takes any of it**; what changes outside the shadow is the reader's list of weak names, which moves to its output and is searched eight records a step, and a field of a cleanup's record.

**The tests** (`c_check_node_census.c`). A test's verdict is the census's code's at both times; the machine's own form and the window's loop list the records sent to it.

- **A pointer's ordered comparison with an integer** is a test of its own (`pointer-integer-order`), by the warning's own rule. The tables send `<`, `<=`, `>` and `>=` for an operand that converts to a pointer, and the loop leaves out a comparison of two such operands, a loop's `p < end`, where nothing else sends it.
- **What converts to a pointer** is a pointer, an array or a function: a function's type's byte has the pointer's bit and the void pointee's, as `nullptr_t`'s has.
- **A declaration that inherits a list of conditions** from an earlier redeclaration (`diagnose_if`, `enable_if`) is a callee to ask.
- **A unit with x86's `interrupt` on a declaration, or that spells `noderef`**, has every expression refused.
- **An initializer's tokens** begin after its object's name at reader time too; its braces are looked for up to its first token; and an automatic object with an asm label refuses its initializer.
- **A `return` under a cleanup** has another control's root at reader time too, by a search of the cleanups' records, which keep the furthest end of the scopes up to each.
- **A returned address** is followed through every operand.
- **A value in a segment's address space** is of a type the machine has no kind for (#3205: its tape lost the segment's override).

**The objects' side** (`c_check_node_machine*.c`): what T and the kernel read of an object that the reader settles after the bodies.

- **Overloads:** one answer both times have before the bodies, the candidates made so far or the unit declaring a function multiversioned by target strings. The program's own object for such a function is compared apart.
- **An asm label** the asm pass will ignore is none at reader time, by the pass's own rule over the declarations in their order. In a unit with a rename pragma T refuses every library builtin's call and asks no label.
- **A weak name** is the name's from a token on: the kernel reads the reader's own list. A declaration whose name the unit notes can change its line at another declaration's token, so its line is made again at every use; any other's last line is taken by one load and one test as before.

**The shadow's report** adds `pointers'-ordered-comparisons-left-out=N checked=N of-them-with-a-test=0`, `the-program's-own-objects=N objects-a-pragma-labelled=N`, and the uses that asked for a declaration's line the long way.

## Measured

{{file:measured}}

## Against its gates

{{file:gates}}

## What stays a record at a time, and why

{{file:scalar}}

## What it means

{{file:means}}

## Tests

`test-checker` part 5 of 8. Six fixtures more for the tests, run as the census's others are (after the pipeline and at reader time, in the census's form and on the window, each line's verdict annotated and each count pinned): the holes' (ordered comparisons by each operator with a pointer on either side, an array and a function; casts of what converts to a pointer; a redeclared condition's call; initializers whose declarator warns, in a body and at file scope, with a cast's braces, with an automatic object's label, a register variable's and a static local's; returns under each kind of cleanup's scope, in a later function, of an aggregate, and before one; a dereference of a function that returns void; a sum of 72 operands), a segment's address space, x86's `interrupt`, `noderef`, the comparisons under `-Wsign-compare`, and with `-w`. Seven fixtures for the objects' side, a unit each, with the whole shadow as the command runs it and its counts pinned (`node_objects_test_fixture`): labels kept and ignored, a rename pragma, a weak pragma, a multiversioned function called and not called, an overloadable one, and the weak names. And two direct tests: the weak names' search over lists of every length to 20, and the shadow's own comparisons (an object's facts, a pragma's label, a name's line), a row a case.

## Checks

{{file:checks}}

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
