# #2924 phase D: census of the scalar fallbacks (2026-11-23)

A census of the data-selected scalar routes left in buster's compiler: scalar code that a vector route falls into,
chosen by the input rather than by `--scalar` or a path flag. It was made by reading the code of main `968a085f`
(two read-only agents of #2924's coordinating session, one for the front end and one for the back end), not by
measurement: "who reaches it" comes from each site's conditions and from the repository's docs. Line numbers are
`968a085f`'s; the functions' names are the stable reference.

#2924's coordinating session files phase D's issues from these two lists, one issue for a module's routes, with each
route a checklist item. The twins found here that the handoff's macro inventory missed (the foreign linker's
`FOREIGN_PATH_EXACT`, bind's `BIND_PATH_EXACT`, `ExecutableOptions.exact`, debug's `exact`, inflate's Adler-32 twin,
and the x86 tables' effects, form choice, target forms and Zen 5 lookup twins) are phase C, assigned to child sessions
on #2924.

- [`front-end.md`](front-end.md): the lexer, preprocessor, refinement and intern, parser, bindings and types, checker.
- [`back-end.md`](back-end.md): SSA, the IR optimizer and verifier, Tier 0, Tier 1, the x86 tables, the encoder,
  disassembler and assembler, the linker's inputs, the executable, unwind, debug, inflate and emission metadata.
