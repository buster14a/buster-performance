# Provenance

- Compiler source: `buster14a/buster` commit
  `599c03ed63d9f50a3dfa75d240f08432371bef41`, tree
  `086cc7a52776d03e9fb8f2aecf1c38184d5d587a`. A clean clone supplies the
  complete source, component-specific notices and license files. Only the
  generated main prefix is copied into this record.
- `adapter/focus-main.c`: original Buster task helper, recovered byte-for-byte
  from the stopped worker's `704-work/focus-main.c`. It reads that revision's
  `src/buster/compiler/main.c`, stops before `main_command`, and changes the
  single `BUSTER_ELSEWHERE` definition so one test adapter can link the actual
  compiler module bodies. Its output is retained as `adapter/focused-main.c`.
- `adapter/const-focused-sanitize.c`: original Buster task wrapper, recovered
  byte-for-byte from the exact-source qualification directory. It selects
  actual permanent const/value/alias/program/driver/recovery test functions
  and releases their oracle/scratch state. It changes no compiler module.
- The wrapper, generator and copied original main prefix retain their
  `Copyright (c) 2026 David Gonzalez Martin` notices and
  `Apache-2.0 WITH LLVM-exception` identifiers. Local reports and identity
  records use those project-default terms. Repository `LICENSE` and
  `LICENSES/` retain the applicable complete license texts.
- System Clang 23.1.4 is an external build tool and behavioral oracle. Its
  implementation and resource/system headers are not copied. Source fixtures
  run by this adapter belong to the pinned Buster source; no external corpus
  is imported. Included Buster components retain the pinned compiler's own
  component-specific licensing, rather than being relabeled by the wrapper.
- Published result logs preserve the adapter's output after filtering only
  `cores:` scheduling lines. Original local log hashes and both executed
  binary hashes are retained. The executables themselves are intentionally
  omitted. Host/tool metadata was captured after replay during publication.
- No new compiler test execution, compiler source edit, benchmark or
  historical certification was added while publishing this record. Buster's
  compiler-only standing sign-off authorization is not extended to this
  evidence repository.
