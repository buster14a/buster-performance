# Recheck after merging measured parent costs

This receipt covers compiler PR #3139 at `9fd852303cb0acd7c04999a58fc8726c4fd329cd`. The [four compiler suites](suites/) passed. All 1,336 release musl objects were byte-identical before and after incorporating the calibrated parent. [musl comparison](musl-objects.tsv.gz).

Each of eight target and scheduler configurations passed 360,448 hardware result and raw MXCSR checks. The [hardware comparison](hardware-values.tsv) identifies every binary. All 578 Opus objects across portable and dispatched builds for both output architectures matched their previous candidate hashes. [Object comparison](opus-objects.tsv.gz). The [ordered NaN and exception oracle](ordered-oracle/) also passed 1,703,936 checks per binary.
