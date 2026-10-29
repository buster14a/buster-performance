# Worker ownership publication

Draft PR: https://github.com/buster14a/buster/pull/695
Branch codex/pub-673; source35d22324a5407e653dcb46b9a59f6953f1daabc0 on main321f5976d5af2b4c54fa45a639895739f2b8a8c9. Compiler SHA256520d6fb3fa00247c987259db027cf6a3bfeba0ed3889b297cbd4ddef38368345.

Fresh local Clang23.1.4 native release build passes41units, through cores-n2. Tests at this publication source: lanes3200/0 (worker protocol186/0), driver21648/0, callgraph41units25415functions151027calls/0disallowedcycles/3allowed/0split, CIselector1131/0. Raw commands/grant receipts/results accompany this report. Worker protocol and regression source files byte-match frozen1d076d67; driver/main integration is refreshed against321.

These are correctness checks, not a new timing measurement. The immutable historical native ownership matrix, balanced large/uneven controls and rejected fork/mixed-order screens remain in issue-673-spawn/REPORT.md of this campaign record. Uneven-tail cost and broader tail rebalancing remain explicit.

Exact publication-head native CI is independently tracked by the PR. This session created a draft and has performed no merge. No older pipeline's measured gain is transferred to35d22324.
