## What the compiler's own tests had and no corpus

[The
record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/tests-holes-2850-2026-11-21).
`measure-node-machine --shadow --window-rows` ([the
guide](commands/lowering.md#the-tests-holes-and-the-objects-side-2850);
[the design's
section](node-machine.md#what-the-compilers-own-tests-had-and-no-corpus)).

The pieces before were gated on four corpora, their fixtures and their one-statement programs: code that warns of
nothing. Every C string literal of the compiler's test files that is a program
({{=n(v['programs']['inline'])}}) and every file under `tests/` ({{=n(v['programs']['tests'])}}), each through the
shadow under three warning sets, found {{=n(v['before']['programs'])}} programs whose reader-time answers were not
the pipeline's, in fifteen kinds ([#3201](https://github.com/buster14a/buster/issues/3201),
[#3202](https://github.com/buster14a/buster/issues/3202), [#3203](https://github.com/buster14a/buster/issues/3203),
[#3205](https://github.com/buster14a/buster/issues/3205), [#3206](https://github.com/buster14a/buster/issues/3206),
[#3207](https://github.com/buster14a/buster/issues/3207)): four of them expressions taken with a warning, one a
tape that lost a segment's override. This piece closes them. No compile takes any of it.

### What it is

- **The tests:** a pointer's ordered comparison with an integer has a test of its own, and what converts to a
  pointer (an array, a function) is tested as one; a declaration that inherits a list of conditions is a callee to
  ask; a unit with x86's `interrupt` or `noderef` is refused whole; an initializer's tokens begin after its object's
  name at reader time too; a `return` under a cleanup has another control's root there; a value in a segment's
  address space is of a type the machine has no kind for. A test's verdict stays one piece of code at both times,
  and the window's loop only lists for it: what it gained is one mask, which leaves out an ordered comparison of two
  pointers, a loop's `p < end`.
- **The objects' side:** what the reader settles after the bodies is asked in a form both times have before them
  (whether the unit has an overload's candidates; an asm label the asm pass will ignore), or refused (a library
  builtin's call in a unit with a rename pragma). A weak name is the name's from a token on: the reader's list is in
  its output, searched eight records a step by the reader and by the kernel, and only a declaration whose name the
  unit notes has its line made again at every use.

### What it measured

{{file:cost_short}}

### What it means

- **Nothing a corpus took is lost, and nothing more is taken** ({{=four('rows_taken')}} tapes whole, as before): the
  holes were in what the corpora do not have.
- **The inputs that say "exact" are five now:** the corpora, the fixtures, the one-statement programs, the
  generator's, and the compiler's own tests' programs with a trigger a warning. In the shadow the last is a
  campaign's sweep; with the first compile behind its option the tests' own drivers run through the machine.
- **Next:** the walk's truth through a cast ([#3204](https://github.com/buster14a/buster/issues/3204)), then the
  first compile that takes expressions, behind an option.

