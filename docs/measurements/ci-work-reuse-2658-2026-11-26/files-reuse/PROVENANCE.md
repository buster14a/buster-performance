# Source provenance and retained terms

The source snapshot `run/c_files_test.c` is an unchanged copy of
[`src/buster/compiler/c_files_test.c` in buster at
`4d1f2024095f233cba19e8f8135dd99b17b9e264`](https://github.com/buster14a/buster/blob/4d1f2024095f233cba19e8f8135dd99b17b9e264/src/buster/compiler/c_files_test.c).
Its source header is retained: copyright (c) 2026 David Gonzalez Martin,
`Apache-2.0 WITH LLVM-exception`. The compiler's pinned
[licensing scope](https://github.com/buster14a/buster/blob/4d1f2024095f233cba19e8f8135dd99b17b9e264/LICENSING.md)
and [portion inventory](https://github.com/buster14a/buster/blob/4d1f2024095f233cba19e8f8135dd99b17b9e264/THIRD_PARTY_NOTICES.md)
record the project grant and component exceptions; the file retains its
first-party source header above. The complete
Apache License 2.0 and LLVM exception are retained in the performance
repository's root `LICENSE`; no license text or scope is changed by this record.

`run/harness.c` is a generated adaptation: the seven helpers/control definitions
listed in `README.md` are extracted without body edits and combined with
`plumbing.h` and a small `main`. `run/mutant_*.c` each intentionally change one
comparison or marking condition, as recorded in `extract.c` and the result
table. They retain the same copyright and terms. These are validation inputs,
not alternate production implementations.

`original/harness.c` and `original/files-2658-mutant-*.c` retain the exact bytes of
the initial one-off helper experiment. They have the same helper origin and
first-party stub plumbing described above. This notice supplies their source,
copyright and license attribution without editing those archived inputs.

`extract.c`, `plumbing.h`, `allocation-failure.c` and `reproduce.sh` were authored
for this issue by the directed OpenAI agent session identified below, for David
Gonzalez Martin, under `Apache-2.0 WITH LLVM-exception`; their SPDX/copyright
headers are retained. The original harness/control code in the compiler was
authored in the same session. Clang is used externally to compile and check the
helpers. No LLVM implementation code, external fixture corpus or third-party
measurement data is copied into these harnesses.

The empty compile/runtime logs and populated failure logs in `run/` are retained
as captured output. The recorded source hash, compiler identity, commands,
generated sources and deliberate transformations make the results reproducible.
This evidence publication supplies no new human DCO certification and does not
extend the compiler repository's standing certification to this repository.

---
Agent session: 6b07eee5-9a58-83ed-88f1-9e324a97a063 (OpenAI session ID; no share URL is exposed)
Agent task: /root/test_work_reuse
Model: OpenAI / GPT-6 Astra Pro
