# Statement lowering on the current main parent

The exact PR head `a984e44fad2a993acace8b1fa1265cd6bf60b529` and its direct main parent `63a709e0d4a67e71e86ffb15fb8382124fac3570` agreed on all 6,164 differential compilations. Tests compared exit status, diagnostics, object bytes, typed output and native execution according to each mode. In the legacy runtime generator both Buster arms agreed in all 112 runs, and matched Clang in 48. The revised generator sequenced the side effects explicitly and matched Clang in all 112 runs. The suite also includes 2,400 repository fixtures with two modes apiece.

A local Develop build used binary SHA-256 `2b44b26eea30e068e79f06fe4406e1ba5cfe32955d3969e8507984863e549f2c` for the candidate and `f4a485eed4eeb9a7c5bc25e84e95c07c7975058c8f12e178db61e1d7e462ae33` for the parent. Clang 23.1.4 had SHA-256 `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`. The new permanent test uses the same filename for small and padded input and requires the typed void cast at the third physical row.

[Exact comparison rows](exact-head-source.tsv.gz) · [Reusable source generator and replay](../../7afa8ba72/qualification/adversarial/)
