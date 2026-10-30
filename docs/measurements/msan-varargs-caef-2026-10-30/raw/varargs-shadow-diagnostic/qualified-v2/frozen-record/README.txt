FROZEN DESCRIPTIVE CAEF BACKEND IR RECORD

This directory records a completed, legitimate IR-only compiler invocation and
read-only inspection. It is not a functional fix, runtime reproduction, passing
CI certification or authorization for another operation. See ANALYSIS.txt for
the cause-unknown conclusion and exact scope of prior mistakes/restrictions.

Verify all included regular metadata/context files from THIS directory with:
  sha256sum -c METADATA-SHA256SUMS

The full195MB IR is intentionally external and remains unchanged one directory
above. Verify that retained payload from the qualified-v2 parent CWD with:
  sha256sum -c frozen-record/IR-PAYLOAD-SHA256SUMS

invocation.initial.json and scheduler-active.json are byte copies of original
records. invocation.completed.json adds actual terminal0 and exact postchecks.
build stdout/stderr are byte copies, both empty. context-* files are bounded
derived excerpts of the hashed first-party generated IR, not full producer
outputs. source-context.txt uses verified original source line numbers. Original
large IR, wrong-TU/fallback v1, optional unexecuted C source and their records
remain at their owning paths; none is replaced by this metadata freeze.

No corpus, source/toolchain archive, executable, stand-in source, LLVM pass
implementation or live placement/timing output is copied here. The source/
generator terms and retained excerpt notices are in PROVENANCE and NOTICES.
