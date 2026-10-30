<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Retained component texts and private snapshot disposition

`Apache-2.0-with-LLVM-exception.txt` is the complete project default copied from
this performance repository's `LICENSE`. Existing Buster component records are
unchanged copies of its `LICENSES/` texts. They preserve the
component terms and attribution already identified by Buster; they do not
relicense the final compiler, source snapshot, system headers or output objects
as a single original work.

Final Buster source and binary archives must carry the final source's own
`LICENSE`, `LICENSING.md`, `THIRD_PARTY_NOTICES.md`, complete `LICENSES/` and
in-source notices. The exact source SHA and reproducible archive identity are in the report.

`Clang-23.1.4-official-LICENSE.TXT` is the exact staged release's file. Four
`Clang-*-notice.txt` files preserve MIT-style notices from the actual included
headers. The GPL/LGPL texts were copied from the measurement host's
`/usr/share/licenses/spdx`; `Linux-syscall-note.txt` is its installed kernel
package's full exception text. `glibc-sys-ttydefaults-notice.txt` preserves that
included header's BSD-style copyright, conditions and disclaimer.

Exact text hashes, host origin paths and package versions are retained under
[../external-inventory/](../external-inventory/). These describe the prior
attempt's external inputs; the final 378-file input-identity comparison succeeded.
The mixed preprocessed snapshot remains private on the host and is not included
in this publication. See [../PROVENANCE.md](../PROVENANCE.md).
