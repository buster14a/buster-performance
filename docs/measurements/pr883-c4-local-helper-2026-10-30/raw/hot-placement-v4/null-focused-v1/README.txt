Focused C4 NULL-section-header reader controls and affected regressions

New NULL-header controls: 42/42 strict and 42/42 ASan+UBSan+leaks passed.
Affected PLT32 component: 53/53 strict and 53/53 sanitized passed.
Affected UNWIND component: 52/52 strict and 52/52 sanitized passed.
Total: 147 cases in each mode, zero failures or sanitizer diagnostics.
All six compiles, six runs, inner invocation and outer tool exit are zero.

invocation.json retains exact exec_command arguments. Asynchronous start
de1d3b/session68950 and terminal4c3516/exit0 are retained separately as
invocation-start-result.json and invocation-poll-result.json. The complete
trace, outcomes, explicit statuses, actual grant and pre/post consumed-source
manifest checks are in focused-full.log. outer-status.txt also records exit0.

The six actual first-party source/header dependencies are copied read-only
under source/ and pinned by SHA256SUMS. Existing constructor code supplies
synthetic bytes through a renamed unused original main. The unchanged old
full ELF suite is never called. Parent authored the production module.
Provisional module3d93 was never built/run here; final tests bind80c00.

Module SHA256:
80c00c482687d8106e2021d63e31d5e936c2d2bab3ad88f99349857bc228bcf1
NULL control SHA256:
f429425bc95efc585af30d4a0f4d5a00c9f0ec4a7e09b3f7619a6e95caefe86b
PLT32 control SHA256:
4bb5d6148133793847209e978f2e526473317613944ca29b165c9e6ce46600c8
UNWIND control SHA256:
496fadfc0eaa8ba7a9769c780b35c1e8f620ab36b6a25a255d934600bc9f2aeb

The local supporting compiler /usr/bin/clang-23 SHA256 is
b53890006355553d68159ddeafd47586f74d9bf8febee4132763fa0ec84e3b44,
distinct from the privately staged official remote production compiler.
Both modes use --no-default-config plus the exact C17/policy/warning flags
recorded in the trace. Ordinary cores runs outside env -i with inherited
XDG_RUNTIME_DIR=/run/user/1000. Trace attests genuine ticket000000000722,
grant1 and CPUs2,10. No HELD or core state was fabricated.

New cases preserve legacy allzero NULL rows under REL/EXEC/DYN, admit only
the exact Wild EXEC flags2/address400000 row, and check that parsed flags
and address are retained. Every input byte stays unchanged. Each unknown
row field/profile, extended numbering, malformed header/table bound and
truncation case must refuse with empty reader output. Accepting EXEC/DYN
metadata still does not authorize ET_REL object comparison.

Earlier plt32-focused-v1 and unwind-focused-v1 snapshots/binaries remain
unchanged. No actual artifact, copy/helper, production compiler/assembler/
linker/Buster image, remote/support producer or timing ran. No unchanged
broader campaign ran. Root's stop before further actual-artifact or remote
use remains in force. These reader/component controls do not qualify actual
executables, resolved relocation values, loading or runtime semantics.
