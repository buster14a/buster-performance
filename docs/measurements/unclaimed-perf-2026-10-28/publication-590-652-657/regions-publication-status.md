# Focused publication status

All three drafts use main 321f5976d5af2b4c54fa45a639895739f2b8a8c9.
The frozen branches and historical evidence remain unchanged. Bodies link the
immutable evidence commit4df43f7d7a685133b6beade655d9e9a306947081 and distinguish
historical timings from current-head local tests and CI.

| Issue | Draft PR | Head | Current local validation |
| --- | --- | --- | --- |
| #657 | https://github.com/buster14a/buster/pull/691 | ed73205fa8298dffafdd8e4552a31e9a764fbc59 | build41, region12332/0, driver21648/0 |
| #590 | https://github.com/buster14a/buster/pull/689 | d1a9070b300ed95f517d3373b6b70b6abc00fef7 | build41, lanes2295/0 including startup150/0, driver21648/0 |
| #652 | https://github.com/buster14a/buster/pull/687 | a08583d3ef27672309a9f3ee42f1212ba4cab69d | build41, driver21653/0, parser/Clang cleanup passes, call graph0disallowed/3allowed/0split |

Each created PR was attached to the task. As verified immediately after
publication, all are open drafts and conflict-free; measurement storage and
changes checks pass, and their exact-head Ryzen7 9700X jobs are queued.
No merges, force pushes or issue comments were performed. Parent owns claim
updates. #590 and #652 address completed slices without auto-closing their
broader remaining setup work; #657 fixes its bounded-transfer issue.

Logs and binary/source identities are in the per-issue subdirectories here.
There are no active local test sessions from this publication work.
