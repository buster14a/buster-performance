# Build regression completion — head 424417e

The final outstanding hosted workflow for
[PR #3654](https://github.com/buster14a/buster/pull/3654) **passed**.
[Build run 45803637355](https://github.com/buster14a/buster/actions/runs/45803637355)
reports success, including the actual
[regression job 139853179017](https://github.com/buster14a/buster/actions/runs/45803637355/job/139853179017)
and the [row verdict 139869284027](https://github.com/buster14a/buster/actions/runs/45803637355/job/139869284027).

This completes the pending Build gate explicitly left open in the completed-hosted
checkpoint at performance commit `11906981c9fbc30518d542b492b5ff47edfeeadd`.
It is a separate supplement, so that checkpoint and its source attributions remain
unchanged.

## Source and runner

- PR head: `424417e5c33d0aa9c671ec0e530a75f2c6529cf5`.
- Actual workflow checkout: `fd50d1860b30332987d0add3df40df8ec5e9df24`.
- Matching head/merge source tree: `44d0938f11936a12161fa7e28bb5fd609f6c1f61`.
- Tested base: `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

At the final observation, main still named that base and the PR remained mergeable.
The job ran on the GitHub-hosted `ubuntu-26.04` image, Ubuntu 26.04.1, on an AMD
EPYC 9V45 96-Core Processor with four available CPUs. It used the workflow's
Clang 23/native regression route and installed the pinned Clang 23.1.4 toolchain.
This job exercises build/configuration transitions; it is not a new sanitizer or
hardware benchmark qualification.

## Observed results

The complete regression step succeeded. Its raw report contains **169
`build-regression: ok:` records**, including:

- compiler and toolchain publication contracts, fresh/incremental builds, exact dependency ownership and compiled-fixture boundaries;
- Debug/Release/Develop switching, post-link-only bake changes and linker-only transitions;
- isolated edits to native parts, self-built Develop units, unchanged-output reuse and equality with clean builds;
- rejected failed compiles, failed post-link work, interrupts, termination and invalid settings without publishing an incomplete compiler;
- clean/configuration behavior, presets, executable shifts, a separate lexer-variant tree, and the final full compiler built in parts with bake/canary checks.

The earlier exact-source runtime fixture controls and actual data-only dependency
proof are in the `hosted-424417e` checkpoint: 128 controls passed, and source,
expectation and catalog mutations/additions caused zero compile/link/bake work.
This Build completion adds the broader build-regression gate; it does not replace
or reattribute those earlier raw logs.

All three primary workflows for this head now report success:

| Workflow | Result | Permanent run |
| --- | --- | --- |
| Tests and Zen 5 benchmarks, hosted route | Success | [45803637857](https://github.com/buster14a/buster/actions/runs/45803637857) |
| Self-host qualification | Success | [45803637310](https://github.com/buster14a/buster/actions/runs/45803637310) |
| Build regressions | Success | [45803637355](https://github.com/buster14a/buster/actions/runs/45803637355) |

The Tests workflow's 9700X job was explicitly skipped. The previous head's Build
workflow was superseded/cancelled; only this completed run closes the gate for
the stated source.

## Files

- `build-regression.log` is the complete contiguous regression command/output block from job 139853179017, ending immediately before its evidence-publication step. Timestamped lines and tool output are unchanged.
- `runner-configuration.log` preserves selected unchanged checkout, image and CPU lines from that same job; the successful pinned-toolchain installation step is recorded in `qualification.json`.
- `qualification.json` preserves completed job/step conclusions, source identity and the three final workflow results retrieved from GitHub.
- `SHA256SUMS` identifies these packaged files.

No binary or benchmark measurement is included. Raw timestamps and any timing
fields in tool output are retained solely as original functional evidence.

Session: `6b07f058-e5f4-83ed-b42f-8d487dbec053`; model: OpenAI / GPT-6 Astra Pro.
Collected by `/root/checker_audit`, with integration and publication by `/root`.
