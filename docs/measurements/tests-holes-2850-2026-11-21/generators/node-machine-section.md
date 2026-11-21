### What the compiler's own tests had and no corpus

The pieces before were gated on four inputs: `sqlite3.c`, Lua, musl and the
compiler's own source, with each piece's fixture and its one-statement
programs. All of it is code that warns of nothing and spells few attributes.
The side facts' freeze found five differences in three other inputs, and
three of them were the earlier pieces'
([#3201](https://github.com/buster14a/buster/issues/3201),
[#3202](https://github.com/buster14a/buster/issues/3202),
[#3203](https://github.com/buster14a/buster/issues/3203)). A compile that
takes expressions cannot have one. This piece looks for the rest where the
compiler's own tests keep them, and closes what it finds
([the tests' specification](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784),
[the objects'](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314);
[the guide](commands/lowering.md#the-tests-holes-and-the-objects-side-2850);
[the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/tests-holes-2850-2026-11-21)).
No compile takes any of it.

**The input.** Every C string literal of `src/buster/compiler/*_test.c`
that is a program ({{=n(v['programs']['inline'])}}, of which the compiler
accepts {{=n(v['programs']['inline_accepted'])}} with no option), a file
each, and every file under `tests/` ({{=n(v['programs']['tests'])}};
{{=n(v['programs']['tests_accepted'])}}), through
`measure-node-machine --shadow --window-rows --passes 0`, whose status is
the oracle, under three warning sets: none, `-Wall -Wextra`, and
`-Weverything -Wno-c++-compat` (`-Wc++-compat` is a warning no test stands
for, which refuses every expression). The three sets are
{{=round(v['sweep_seconds'] / 60)}} minutes of four cores with a Develop
build. And one program for each warning the tests stand
for, written to warn ({{=n(v['triggers']['tested'])}} warnings:
{{=n(v['triggers']['written'])}} written, {{=n(v['triggers']['from_piles'])}}
found in the programs above, {{=n(v['triggers']['none'])}} with none:
`-Wavailability`, which no Linux target raises).

**What it found** on the code before, main `{{=v['before_revision']}}`:
{{=n(v['before']['programs'])}} programs with status 1 under each of the
three sets{{=must(v['before']['same_in_every_set'])}}, in fifteen kinds (a
program can have several).

| what differs | programs | where | the issue |
| --- | ---: | --- | --- |
| a multiversioned function's object, which the program makes for itself; in {{=n(v['before']['kinds']['callee-taken'])}} of them a call reader time takes and the program refuses, and its summary | {{=n(v['before']['kinds']['object-declaration'])}} | T's objects and calls | [#3203](https://github.com/buster14a/buster/issues/3203) |
| a call in a function with x86's `interrupt` (`-Wexcessive-regsave`): **taken with a warning** | {{=n(v['before']['kinds']['interrupt-call'])}} | the tests | [#3201](https://github.com/buster14a/buster/issues/3201) |
| a `return` under a cleanup, whose value's root is no return's | {{=n(v['before']['kinds']['cleanup-return'])}} | the tests' root's kind | [#3202](https://github.com/buster14a/buster/issues/3202) |
| an asm label on a declaration after the object's definition, which the asm pass ignores after the bodies | {{=n(v['before']['kinds']['label-kept'])}} | T's objects | [#3207](https://github.com/buster14a/buster/issues/3207) |
| **a load or a store in a segment's address space, whose override the tape loses: wrong code if taken** | {{=n(v['before']['kinds']['tape-entries'])}} | X's tape, after the pipeline too | [#3205](https://github.com/buster14a/buster/issues/3205) |
| a weak name's value, where another declaration or a `weakref` makes it weak | {{=n(v['before']['kinds']['fact-words'])}} | the kernel | [#3206](https://github.com/buster14a/buster/issues/3206) |
| a pointer's ordered comparison with an integer: **taken with a warning** | {{=n(v['before']['kinds']['ordered-comparison'])}} | the tests | #3201 |
| a dereference of a `noderef` pointer through a typedef: **taken with a warning** | {{=n(v['before']['kinds']['noderef'])}} | the tests | #3201 |
| a declarator's warning among its initializer's tokens | {{=n(v['before']['kinds']['declarator-event'])}} | the tests' span | #3201 |
| a call of a function whose middle redeclaration has `diagnose_if`: **taken with a warning** | {{=n(v['before']['kinds']['diagnose-if'])}} | the tests | #3201 |
| an initializer whose cast's type has braces, read as a brace initializer | {{=n(v['before']['kinds']['brace-kind'])}} | the tests' root's kind | #3202 |
| a label a rename pragma makes when the reader is done | {{=n(v['before']['kinds']['label-missed'])}} | T's objects | #3207 |
| the returned-address test on a sum of more than 64 operands, refused after the pipeline and taken on the window | {{=n(v['before']['kinds']['window-tests'])}} | the tests | #3201 |

The generator's programs with operands of the wrong kind had found the
pointer's cast and comparison and a function designator's
({{=n(v['fuzz_before']['found'])}} of {{=n(v['fuzz_before']['programs'])}}
programs on the code before).

**Where a test goes.** Each unsound take was a warning that some pass
raises after the graph's run, by a rule of its own that no test of the
census's mirrored. A test's verdict is the census's code's, at both times
(`node_census_node`, `node_census_root_tests`). The machine's own form and
the window's loop only list the records sent to that code, by an
operator's class and its operands' bytes, and a type's byte is made once a
type and read by all three. So a new test is a rule in one place, a bit in
the tables for what sends a record to it, and, where the loop can say more
from the bytes it has, a mask that leaves a record out.

- **A pointer's ordered comparison with an integer**
  (`check_warning_ordered_event`) is a test of its own: exactly one operand
  a pointer as the action converts it, the other an integer that is no
  null pointer constant. The tables send `<`, `<=`, `>` and `>=` for an
  operand that converts to a pointer. That would list every loop's
  `p < end`, so the loop leaves out a comparison whose two operands both
  convert to one, where nothing else sends it and its operator has no test
  whatever its operands: {{=four('orders_left_out')}} comparisons of the
  four corpora, each checked ({{=four('orders_left_out', n, True)}} with
  `-Wall -Wextra`, where the sign comparison's test keeps every ordered
  comparison listed).
- **What converts to a pointer** is a pointer, an array or a function. A
  function's type's byte has the pointer's bit and the void pointee's, as
  `nullptr_t`'s has: `(int)function` and `(char)array` are sent to the
  cast's test, and `*function` no more reads as a pointer's dereference
  with nothing to ask. musl's expressions with nothing listed fall by
  {{=n(v['corpora_before']['musl']['nothing_listed'] - v['corpora']['musl']['nothing_listed'])}}
  ({{=n(v['corpora_before']['musl']['nothing_listed'])}} to
  {{=n(v['corpora']['musl']['nothing_listed'])}}): calls through `(*f)`.
- **A list of conditions** is a declaration's own or one it inherits from
  an earlier redeclaration (`CheckInput.condition_declarations`), which no
  attribute of the declaration at hand says: such a declaration is a callee
  to ask.
- **Two attributes are a unit's.** x86's `interrupt` on any declaration
  makes every other call in such a body warn, and `noderef` warns by a
  declaration's type's annotation, which a typedef, a member or a cast may
  carry and no node's type says. A unit with either has every expression
  refused, as one with a warning no test stands for has.
- **An initializer's tokens** begin after its object's name after the
  pipeline ([#3017](https://github.com/buster14a/buster/issues/3017)) and
  began at its value at reader time: a declarator's warning that the
  reader has raised by then refuses it at both times now. One the reader
  raises after the body, that it ignores an automatic object's asm label,
  is not there yet when the walk reads the initializer: the declaration
  itself refuses its initializer (in a body, with no linkage, neither
  `static` nor `register`; musl's system calls' `register long r10
  __asm__("r10") = a4;` are taken as before).
- **A `return` under a cleanup** has another control's root after the
  pipeline, where the program computes the value, runs the cleanups and
  then returns. Reader time says the same by a search of the unit's
  cleanups, which keep the furthest end of the scopes up to each.
- **A value in a segment's address space** is of a type the machine has no
  kind for, at both times and after the pipeline: its loads and stores
  have an override the rows have no entry for. Refused, not made: no
  corpus has one, and x86's segments are a kernel's and a runtime's few
  lines.

**The objects' side**: what T and the kernel read of an object that the
reader settles only after the bodies. The machine at reader time begins
before them.

- **Overloads.** T refuses every call of a unit whose graph has an
  overload's candidates, and a function multiversioned by target strings
  gets its calls' candidates after the last body. One answer both times
  have before the bodies: the candidates made so far (an overloadable
  function's declarations) or the unit declaring a function multiversioned
  so. The program's own object for a multiversioned function (by target
  strings, by `target_clones` or by `cpu_dispatch`), its versions'
  reference, is compared apart: reader time must have nothing for it.
- **An asm label** decides one answer of T's, whether a plain library
  builtin's call is computed in place or called by its label. The asm
  pass, after the bodies, ignores a label on a declaration that follows
  the object's definition; the machine applies that rule to the
  declarations in their order where it makes the objects' facts. A rename
  pragma's label is chosen when the reader is done, by the labels the asm
  pass kept and the uses the bodies made: in a unit with such a pragma T
  refuses every library builtin's call at both times and asks no label.
  No corpus has the pragma.
- **A weak name** is the name's from a token on, not a declaration's: the
  reader notes it at a `weak`, `weakref` or `weak_import` attribute on any
  declaration of the name. The kernel asked the use's own declaration for
  a `weak` attribute, and missed a function declared weak and then
  defined, a `weakref` and a block's weak declaration of a name another
  declaration has. The reader's list is in its output now, and the reader
  and the kernel ask one search of it, eight records a step. A declaration
  whose name is noted anywhere can change its line at another
  declaration's token, so its line is made again at every use; any other's
  last line is taken by one load and one test as before.

{{file:tables}}

{{file:cost}}

**Against its gates** (H1 to H6 the tests' specification's, O1 to O5 the
objects')

{{file:gates}}

**What stays a record at a time, and why**

{{file:scalar}}

**What it means**

{{file:means}}

**What is next:** the walk's truth through a cast
([#3204](https://github.com/buster14a/buster/issues/3204)), then the
first compile that takes expressions, behind an option, where the sweeps'
cost by the chunk is read.

