Focused C4 PLT32 pure-memory controls

53/53 strict and 53/53 ASan+UBSan+leaks cases passed. Both compiles, both
runs, the traced inner invocation and outer tool invocation exited 0.
The immediate completed tool result is invocation-start-result.json;
there was no asynchronous session to resume. invocation.json preserves
the exact exec_command arguments. focused-full.log preserves the complete
combined trace, outcomes and unchanged pre/post consumed-source manifest.
outer-status.txt independently records the outer command's exit.

Only the four first-party files in source/ are consumed by these two builds.
The original ELF constructor source is included with its main renamed;
the original suite is never called. hp_common.c/.h are not dependencies.
All four frozen source files are read-only and match SHA256SUMS.
The live authored test source is ../plt32_controls.c; hp_elf.c was edited
by the parent task, not the focused-control author.

Actual module SHA256:
a6cb069f4a50932f9b9b1b791413ca07bf5a8757a9af2d75fde8559063e5dcb0
Actual focused test source SHA256:
4bb5d6148133793847209e978f2e526473317613944ca29b165c9e6ce46600c8

This is a local supporting-tool build using /usr/bin/clang-23, SHA256
b53890006355553d68159ddeafd47586f74d9bf8febee4132763fa0ec84e3b44.
It is not the official privately staged remote producer binary. Both modes
use --no-default-config and the strict C17/policy flags recorded in the
invocation and trace. The ordinary inherited-XDG cores wrapper is invoked
outside env -i; no CORES/HELD or lock variables are fabricated. The caller
had empty CORES_HELD, CORES, CORES_CPUS and CORES_STATE, and
XDG_RUNTIME_DIR=/run/user/1000. cores wrapper SHA256:
3c1b30208561cd560d7e7e42e0905b61aa3072eab747baceccf40bb689b13c4c

The fixtures are in-memory ELF bytes. They cover every approved shift,
first-hot-byte addend -4, executable auxiliary/hot relocation sites,
local/global named PLT32 preservation and focused malformed/refusal cases.
No actual-artifact helper, production compiler, assembler, linker, Buster
image, remote operation or timing ran. No unchanged broader campaign ran.
No actual binary/object qualification or runtime equivalence is claimed.
