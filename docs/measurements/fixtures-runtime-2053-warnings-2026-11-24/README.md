# Runtime warning fixtures for Buster #2053

Buster PR [#3520](https://github.com/buster14a/buster/pull/3520) compares `2d20b1826` and `e2da02147` on a four-vCPU-quota Linux cloud VM, with the pinned Clang 23.1.4 toolchain, vector Release and BUSTER_DEBUG_INFO=0.

## Extraction and controls

The C dumper contains the original 58 tables and their source initializers' compile-time lengths. Compile with `clang -std=gnu17 dump.c -o dump`. It writes length-prefixed fields for each case in inventory order. All 1,165 records matched the catalog and raw source bytes, including names, diagnostic counts, comparison switches and options. The inventory records SHA-256 per input. The 18 already external auto-address sources have 36 runtime dialect rows.

The normal call-count focus with --in-process ran 12 cases both times. The added check validates the catalog. With a populated build, the unchanged binary failed on an incorrect source, count, missing file, orphan file, invalid row, duplicate ID and empty inventory. Adding a valid thirteenth row executed the case. Source edits, metadata edits, adding a case and restoration all produced Ninja's “no work to do” and retained the candidate compiler's SHA-256. Touching the warning runner scheduled its checker owner, link and bake. Restoring the original timestamp returned to zero commands.

## Size and builds

Across the changed host C files the net reduction was 643,126 bytes. The Release checker object went from 30,935,944 to 30,478,232 bytes. The published executable went from 74,109,920 to 74,102,008 bytes. The before and after files record their hashes.

Both clean builds compiled 43 units. Ninja reported 175.5 s before and 233.0 s after. The after run shared this cloud VM with another build. These are build observations under different loads. The incremental fixture controls above measure scheduled commands. The runner positive control and its actual incremental build are recorded separately.

Commit `fa263aba2` accepts the plus sign in `-Wc++-compat`. All 16 local driver shards passed on that revision (243,117 checks). The `corrected` files record its executable and object.
