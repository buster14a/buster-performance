Python development history only: not approved for producer use

Root applied Buster ce1 AGENTS.md:137-139: supporting tools/tests/automation
must be C unless the goal explicitly requires/disallows another language.
There is no Python exception for this work/performance prototype. A fresh C
port and its own controls/actual-code review are required.

frozen-b0/ preserves the reviewed complete.patch snapshot b0f11689b5ee1e22f5197c5f338a07ded47375266c2bb8e1e5a008b453457580.
The 233-line method.py was reconstructed solely by applying that retained
new-file diff; its original SHA0608 and every retained manifest entry validate.
This version has the 35/39/26=100 pure-control development results and scoped
logic reviews. They never qualified a real compiler/assembler image or the C port.

pending-driver-refresh/ preserves the actual 284-line pre-port working method
with the environment/default/effective-driver refresh requested by pr882.
It differs from frozen-b0 and has NOT received a refreshed exact-code review
or matching new driver/environment controls. Its old copied manifest is kept
as history and intentionally does not attest the changed method.py. Its exact
current method hash and diff are separately pinned in this directory.

The original work/hot-placement and elf-controls directories are also left
untouched. No Python producer execution, assembler, Buster image or remote
operation occurred during derivative preparation. New functional code and
controls are being written separately under hot-placement-c/.
