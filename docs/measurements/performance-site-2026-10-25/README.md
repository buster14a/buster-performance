# Performance data validation, 2026-10-25

Source implementation: Buster PR #414, head
`4a6fa84b643cf75b49aa838a54a7eeda431f0872`. The native source in its first
commit `754a2af4ad216b703111ae75cb1d5c0c4bb100a0` is unchanged by the browser
commit. Fixture integration pin: `2c26fc75c9d54396af201348ba7572d0d2ab1774`;
original archive input: `d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea`.

The C reader validates **300 foreign-string rows / 7,308 typed cells** plus
**two arbitrary rows / 12 typed cells**, preserving uint64 maximum, exact
decimal scales, legitimate zero and null/reason. The 56-case native suite
passes locally, with ASan/UBSan/leak detection, and on the approved Ryzen 7
9700X. Builds and execution on that host took separate existing shared locks;
execution was pinned to CPU 2. These are correctness checks, not throughput
measurements or production-profile qualification.

The actual Chromium 151.0.7922.34 reader passes **25 browser checks** at the
`/buster/tests/` subpath, including the same 302 rows / 7,320 cells, exact
Unicode/spaced/prototype-like field names, missing/zero values, comparison
eligibility controls and zero/negative baselines. The data checks ran with
Apache Arrow JavaScript 21.1.0 and Playwright 1.62.1. No Pages site or embedded
profile inspector is claimed by this reader test.

Reproduce from the Buster source and this archive:

```sh
bash tools/performance/build.sh
bash tools/performance/build.sh --tests
build/performance/bmf-test /path/to/buster-performance
BUSTER_PERFORMANCE_CFLAGS='-O1 -fsanitize=address,undefined -fno-omit-frame-pointer' bash tools/performance/build.sh --tests
ASAN_OPTIONS=detect_leaks=1 build/performance/bmf-test /path/to/buster-performance
```

Browser setup and execution are reproduced by `.github/workflows/performance.yml`
at the exact source head. Normal logs contain expected diagnostics from planted
invalid datasets; the final JSON reports zero failures. The 9700X native source
and executable hashes are in `9700x-native-provenance.txt`. The transferred
source/fixture archive had SHA-256
`0a4be6c2c841162a792721bb9c2cb6bccda5b99b9c8389b06e72e101d5cd5e7c`.

Exact-head hosted results: performance resources
[`40177287756`](https://github.com/buster14a/buster/actions/runs/40177287756),
required compiler qualification
[`40177287762`](https://github.com/buster14a/buster/actions/runs/40177287762),
and measurement storage
[`40177287708`](https://github.com/buster14a/buster/actions/runs/40177287708)
passed. Integration and post-merge main validation remain separate events.

Original report/receipt material follows the existing project default terms.
Native dependency sources and licenses remain in the pinned Buster source;
this directory imports no additional third-party implementation.
