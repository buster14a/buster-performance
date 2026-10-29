# Current-main #672 rebaseline

Source: e7f89091648f68940b595aadd648841c1ffc3ec5, including merged #678/#682/#703 and this campaign's landed changes. This is an integrated current-main observation; it will not assign gains to individual PRs or multiply their earlier improvements.

Use a new immutable native build on Benchpress, the normal Clang/native/O3 build with debug information, with exact tool, source, binary, CPU, kernel, corpus/header/predefine and affinity identities. Preserve the older 296e5b05 and historical 92c025e7 records separately. The historical compiler build may differ; no causal before/after claim follows from a simple throughput comparison.

First run short checker/ABI/graph and SQLite smoke correctness controls. Then run the unchanged historical `microarch.c` throughput method: five rotating rounds at 1/2/4/8 physical workers and 15 permitted logical CPUs, four fresh full compilations per worker, one compiler lane each, real object writes, warm header pages. Its CPU inventory and actual selected affinities are retained. Every child status/resource record and diagnostic log is retained, together with one real object per cohort. Counter errors or less than full scheduling coverage qualify the affected numbers; they never become zero-cost work. Peak RSS is per child, not summed or simultaneous peak.

Retain user cycles/instructions/branches and generic raw retired-op measurements as observed data with coverage and event identity. Do not call an exposed event valid solely because it schedules. No new uncore collection or physical-traffic claim: performance#49's event-selector/CAS-unit validation remains incomplete. No hardware, permission, frequency, module, license or host settings changes.

Every substantial remote staging, build, test, timing, hashing and packaging operation goes through the existing per-run exclusive lock with #672 ownership metadata. Bound each run, release between invocations and retain failures. Local runs use the owner's core allocator. Raw evidence belongs in buster-performance; compiler documentation gets only a design summary and evidence links.

The method and smoke helper are byte-identical reuse of original first-party files from buster-performance `e2377fd2d3d01e8c89efc8b68e7b2acc3444e7bd`, `docs/measurements/microarchitecture-9700x-2026-10-27/method/`. They run the external frozen SQLite corpus as an input; SQLite source and tool implementations are not incorporated. New performance-repository commits have no human DCO trailer under the compiler-only standing certification.
