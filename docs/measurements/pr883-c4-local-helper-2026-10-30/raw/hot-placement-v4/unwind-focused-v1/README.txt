Focused C4 standard .eh_frame UNWIND controls and PLT32 regressions

New UNWIND controls: 52/52 strict and 52/52 ASan+UBSan+leaks passed.
Changed-component PLT32 regressions: 53/53 strict and 53/53 sanitized passed.
All four compiles and four runs, the traced inner invocation and outer tool
invocation exited 0. No sanitizer diagnostic appeared.

invocation.json preserves exact exec_command arguments. The asynchronous
start (chunk10ca91/session59109) and terminal result (chunk1988b2/exit0) are
retained separately as invocation-start-result.json and
invocation-poll-result.json. focused-full.log contains the complete trace,
all outcomes, actual cores grant and unchanged pre/post source-manifest
checks. outer-status.txt also records exit0.

All five consumed first-party source/header files are copied read-only into
source/ and pinned in SHA256SUMS. The original ELF control source supplies
byte constructors through a renamed main; the old full suite is not called.
The old plt32-focused-v1 modulea6cb/53-case evidence is unchanged.

Parent-authored module SHA256:
f1b50a922721bd23f18d2d52979a38c7f8a9c176aa3f177477b40cec2f40a42c
New UNWIND control SHA256:
496fadfc0eaa8ba7a9769c780b35c1e8f620ab36b6a25a255d934600bc9f2aeb
Unchanged PLT32 control SHA256:
4bb5d6148133793847209e978f2e526473317613944ca29b165c9e6ce46600c8

The local supporting-tool compiler /usr/bin/clang-23 SHA256 is
b53890006355553d68159ddeafd47586f74d9bf8febee4132763fa0ec84e3b44;
this is not the privately staged remote production Clang binary. Both modes
use --no-default-config and the C17/policy/warning flags in the trace.
Ordinary cores is invoked outside env -i with inherited XDG_RUNTIME_DIR;
the trace attests grant1, CPUs2,10, genuine ticket000000000709 and
XDG_RUNTIME_DIR=/run/user/1000. No HELD/core state is fabricated.

Fixtures preserve raw .eh_frame content including the relocation field
bytes and non-field bytes, section metadata, PC32 hot/ordinary target
tuples, field bounds/overlap and unsupported profile refusal.
The synthetic unwind payload is opaque bytes; no CFI interpretation or
runtime unwinding claim is made. Existing PROGBITS .eh_frame acceptance is
retained as a positive control; a cross-type mutation still refuses.

No actual objects/helper, production compiler/assembler/linker/Buster image,
remote operation or timing ran. No unchanged broader campaign ran. This
component evidence does not qualify actual binaries or runtime semantics.
