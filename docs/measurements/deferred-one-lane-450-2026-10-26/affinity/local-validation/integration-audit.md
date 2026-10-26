# #450 read-only integration audit

Candidate remains `638442081ae1b9134ed2dee1ca0fcc8b3933e4b0`.
Fetched main snapshot: `35f26f68d7caa9bf5f6248822100a51c06e2c878`.
The GitHub integration independently confirms #491 merged as
`8177fdf9986c282337ede1d16b33a5fc85121b52`.

Only fetch and `git merge-tree --write-tree --messages` were used. No checkout,
production source, branch history, commit, push or performance-host action was
changed. The pre-existing documentation draft is still the only worktree
modification and is not part of the committed candidate preview.

Merge base: `31c4ced26abcf0393e8c8f4f138e42dfe1952ee4`.
Virtual merged tree: `4a0c20a7ab1e17ca2dd2265dab046b91069c5b6f`.
The merge-tree command exited zero with no conflicts.

The shared resource guards are already in main via #491. Both the virtual
merged workflow and build script are byte-identical to current main:

- `.github/workflows/9700x.yml`: blob
  `219d7526bed5888196b77e9415029a0816985729`.
- `build.sh`: blob `9909122edfe1459305d8dc0efabd49805939f025`.

Thus the latest main selectors, test list, qualification pins and resource
guards survive without restoring an older workflow. The virtual #450 diff
against main has only six paths: AGENTS, deferred documentation, the corpus
test harness, deferred tests, lane implementation and lane tests. It adds no
workflow or build-script diff.

Current main's label-address checker files are preserved byte for byte in
the virtual merged tree, as is `c_check_deferred.c`. Main has also acquired
prototype-scope fixes (including `prototype_depth` reset), plain-char
signedness propagation, seven additional deferred fixtures, and other
preprocessor/runtime/DWARF changes. All those changes remain in the preview;
#450's added timed/pinned test does not replace the newer fixtures.

Consequently, the exact `63844208` versus `31c4ced2` campaign is evidence for
that source pair. It is not exact-head validation of the virtual merged
result. An eventual integrated head must retain these newer fixes and
fixtures and receive integration correctness/CI; any final performance
claim on that integrated source needs appropriately identified baseline and
candidate evidence. No integration or production acceptance is claimed by
this audit.
