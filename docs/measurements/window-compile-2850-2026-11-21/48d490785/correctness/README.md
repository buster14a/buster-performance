# Exact-main validation for unused-binding diagnostic elision

Candidate `48d490785424237f088dab9eaa925f7afdbe0117` was tested against an independent uninstrumented build of its parent `6e9c51b9d238734468dccc03ab1b6c715449804e`. The pinned Clang 23.1.4 eight-driver-part total is 210,901 checks. The fifth checker part made 210,495 checks. All passed.

The 200-pair portable reproducer from the preceding source's correctness package ran on this binary pair and matched status, stdout, stderr, output-file presence and complete bytes. The ledger records 55 delivered object pairs. An additional 21 pairs compared ordinary and debug linking, debug objects, attestation in on/verify mode and typed/static dumps with bare, enabled, or fatal unused diagnostics. The extra mode record shows the options, status, bytes of stdout, bytes of stderr and delivered output size.

The supplementary five-unit census used the original diagnostic instrumentation on `f0a204a9c`, independent of current-main validation. Each source matched in all four warning-policy pairs. On default Lua lvm.c it removed 418,757 bytes of unused-analysis scratch. On musl vfprintf.c and strtod.c it elided one ignored raw unused event apiece while preserving the program's externally observable diagnostics. The frozen SQLite has a separate native hardware record.
