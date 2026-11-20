# Recheck after merging measured parent costs

This receipt covers compiler PR #3132 at `b2cef4d33570a884021e19b71217e842fb1e21a4`. The [four compiler suites](suites/) passed. All 1,336 release musl objects were byte-identical before and after incorporating the calibrated parent. [musl comparison](musl-objects.tsv.gz).

The [truncation oracles](oracle/) agreed across all four output architectures. The language comparison recorded 893,440 checks per binary and the machine comparison recorded 2,752,512, including trapping and guard-page behavior.
