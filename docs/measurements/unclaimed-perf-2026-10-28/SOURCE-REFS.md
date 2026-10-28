# Frozen source references

These public refs preserve exact measurement or qualification snapshots. They are not proposals to merge the snapshots as a batch. Published fix PRs are refreshed separately; old measurements never become later-head measurements merely because a function matches.

| Scope | Disposition | Source commit | Public ref |
| --- | --- | --- | --- |
| 590 | qualification | [8b815992](https://github.com/buster14a/buster/tree/8b815992da557a33b91c5efee809723d4e7f2df6) | codex/qualification-20261028-590 |
| 628 | qualification | [dc15a18e](https://github.com/buster14a/buster/tree/dc15a18ed3ad273888ae1cb87e903969e876acfa) | codex/qualification-20261028-628 |
| 636 | qualification | [60ff4b25](https://github.com/buster14a/buster/tree/60ff4b259cc98912f819ade74f92b864e723eb25) | codex/qualification-20261028-636 |
| 641 | qualification | [7c1f0b09](https://github.com/buster14a/buster/tree/7c1f0b09b7e68b28f8281f06580d5c33540d21ae) | codex/qualification-20261028-641 |
| 647 | qualification | [b1975e31](https://github.com/buster14a/buster/tree/b1975e3135b72705ef2b12c9804c2df4ce7c4149) | codex/qualification-20261028-647 |
| 649 | qualification | [123d22ae](https://github.com/buster14a/buster/tree/123d22aef6f9298541dbe869ba00e794805322c4) | codex/qualification-20261028-649 |
| 652 | qualification | [24e9c1f8](https://github.com/buster14a/buster/tree/24e9c1f8d9c8fb32d06768b08cd6867d1252bc32) | codex/qualification-20261028-652 |
| 657 | qualification | [086c24b1](https://github.com/buster14a/buster/tree/086c24b121e4834b821a47974069d2af8b9ed2fc) | codex/qualification-20261028-657 |
| 658 | qualification | [e056a429](https://github.com/buster14a/buster/tree/e056a4297c98c7ee3ef3c5c113834f63acbf448b) | codex/qualification-20261028-658 |
| 664 | qualification | [be441ff8](https://github.com/buster14a/buster/tree/be441ff8786d47f56cc2d6e05bb416e8091d1bdc) | codex/qualification-20261028-664 |
| 673 | qualification | [1d076d67](https://github.com/buster14a/buster/tree/1d076d6736df9b7350610ec646dc1fe1ef39f7dc) | codex/qualification-20261028-673 |
| 674 | qualification | [7274e1bc](https://github.com/buster14a/buster/tree/7274e1bc47dfa60c80a584bc01f270af5a7d420b) | codex/qualification-20261028-674 |
| 641 | experiment | [a29b4072](https://github.com/buster14a/buster/tree/a29b4072c5dc2a5834e4ffce6ab1e274d9afd20b) | codex/experiment-20261028-641 |
| 653 | experiment | [d8a4b936](https://github.com/buster14a/buster/tree/d8a4b93663deac305e11d9a59c43610ef27f03ee) | codex/experiment-20261028-653 |
| 451 | experiment | [68e113ee](https://github.com/buster14a/buster/tree/68e113ee445af2a80296412a2b8791d3bf9098a6) | codex/experiment-20261028-451 |
| combined | qualification | [d74d8736](https://github.com/buster14a/buster/tree/d74d87366e2f7458bc7997b2314d94b0f5cdf96b) | codex/qualification-20261028-compat |

The combined snapshot records functional native/generic and qemu64 qualification against pinned main/#678 sources. Its workflow and fixture state is historical; later publication-only gate corrections and review adjustments have their own commits and CI. Rejected experiment refs preserve negative evidence, not accepted optimizations.
