# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# The owner's Ryzen 9 7940HS (Zen 4) desktop. Every run takes a grant from the
# `cores` queue (~/dev/scripts/cores, AGENTS.md "Sharing the owner's machines'
# cores"): one core for single-core steps, at normal priority, the pool (6 of 8
# cores while the owner keeps two) for the scaling steps.
HOST=zen4-7940hs
NATIVE=znver4
VARIANTS=${VARIANTS:-"znver4 znver5 x86-64"}
SWEEP_VARIANTS=${SWEEP_VARIANTS:-"znver4"}
SELF_VARIANTS=${SELF_VARIANTS:-"znver4 znver5"}
TD_WIDTH=6
TD_RESYNC=resyncs_or_nc_redirects
SCALING_LANES="1 2 4 6"
FANOUT_WORKERS="1 2 4 6"
SWEEP_CHUNK=100
METRIC_CHUNK=60
PAUSE=0
UNCORE=0
TITLE=${TITLE:-"Micro-architecture analysis 2026-11-04 (two hosts)"}
LINK=${LINK:-"Claude Code desktop session 13c4c6ec-bedd-4c3c-8259-227a893edce8"}

hold() { CORES_TITLE="$TITLE" CORES_LINK="$LINK" cores -n 1 --priority normal -- "$@"; }
hold_multi() { CORES_TITLE="$TITLE" CORES_LINK="$LINK" cores -n 6 --priority normal -- "$@"; }
receipt() { echo "$(date -Is) cores grant CORES_CPUS=${CORES_CPUS:-unset} CORES=${CORES:-unset}"; }
