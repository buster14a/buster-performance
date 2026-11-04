# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# The shared Ryzen 7 9700X (Zen 5), benchpress. Every step runs under the
# machine's lock (~/buster-fast-bench/exclusive.sh), held per step chunk (about a
# minute) with a pause between holds, so that CI and other sessions get the
# machine (AGENTS.md "Sharing the 9700X"). Single-core steps run on CPU 2, the
# one CPU with the performance governor and EPP, whose SMT sibling (10) is offline.
HOST=zen5-9700x
NATIVE=znver5
VARIANTS=${VARIANTS:-"znver5 znver4 x86-64"}
SWEEP_VARIANTS=${SWEEP_VARIANTS:-"znver5 znver4"}
SELF_VARIANTS=${SELF_VARIANTS:-"znver5 znver4"}
TD_WIDTH=8
TD_RESYNC=bp_redirects.resync
SCALING_LANES="1 2 4 8"
FANOUT_WORKERS="1 2 4 8"
SWEEP_CHUNK=100
METRIC_CHUNK=60
PAUSE=${PAUSE:-30}
UNCORE=1
TITLE=${TITLE:-"Micro-architecture analysis 2026-11-04 (two hosts)"}
LINK=${LINK:-"Claude Code desktop session 13c4c6ec-bedd-4c3c-8259-227a893edce8"}

hold() { EXCLUSIVE_OWNER=claude-uarch-1104 EXCLUSIVE_TITLE="$TITLE" EXCLUSIVE_LINK="$LINK" ~/buster-fast-bench/exclusive.sh "$@"; }
hold_multi() { hold "$@"; }
receipt() { head -1 /var/lib/buster-9700x/owner; }
