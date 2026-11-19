#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Instrument a clean copy of the private-value compiler for a one-lane census."""
from pathlib import Path
import subprocess
import sys

root = Path(sys.argv[1]).resolve()
directory = root / "src/buster/compiler"
revision = "b63551526c488dd08cd2138f7d9aa95e655af3e5"
demand_revision = "3dc3d4f6d74ba353c07101ff614600416272817f"
def original(rev, name):
    return subprocess.check_output(
        ["git", "-C", str(root), "show", f"{rev}:src/buster/compiler/{name}"],
        text=True,
    )
def insert(text, before, addition):
    if text.count(before) != 1:
        raise ValueError(f"unexpected number of occurrences of {before!r}")
    return text.replace(before, addition + before)

adapter = directory / "ssa_ir.c"
frontier = directory / "ssa_ir_private.c"
probe = directory / "placement_demand_probe.c"
a = adapter.read_text()
f = frontier.read_text()
if a != original(revision, adapter.name) or f != original(revision, frontier.name) or probe.exists():
    raise SystemExit("use a clean copy of the measured frontier revision")
d = original(demand_revision, "ssa_ir_demand.c").replace("ssa_ir_", "probe_demand_")
d = d.replace("ssa_bounded_accesses(work, &tape)", "ssa_bounded_accesses(work, &tape, true)")
a = a.replace('#include "ssa_ir_private.c"', '#include "ssa_ir_private.c"\n#include "placement_demand_probe.c"')
a = insert(a, "    if (check.error == IR_OK)\n    {\n        if (BUSTER_TIER1_PRIVATE_VALUES)\n",
           "    const uint64_t census_start = scratch == NULL ? 0 : scratch->length;\n")
a = a.replace("ssa_ir_construct_frontier(&work.work, rename_vector)",
              '(getenv("BUSTER_PROBE_DEMAND") != NULL ? probe_demand_construct_demanded(&work.work) : ssa_ir_construct_frontier(&work.work, rename_vector))')
a = insert(a, "    if (check.error == IR_OK)\n    {\n        check.error = ssa_ir_error(ssa_simplify(&work.work));",
           "    const uint64_t census_end = scratch == NULL ? 0 : scratch->length;\n")
a = insert(a, "    if (check.error == IR_OK && verified != 0)\n", '''    if (check.error == IR_OK)
    {
        fprintf(stderr, "SSA-PLACEMENT %u %u %u %u %u %u %llu\\n", input->block_count, work.source.local_count,
                work.work.phi_count, work.work.operand_count, work.ssa.phi_count, work.ssa.operand_count,
                (unsigned long long)(census_end - census_start));
    }
''')
f = insert(f, "                                ok = false;\n",
           '                                fprintf(stderr, "SSA-BUDGET %u %u\\n", blocks, pairs);\n')
f = insert(f, "        error = ssa_construct_bounded(work, rename_vector);\n",
           '        fprintf(stderr, "SSA-BOUNDED %u %u\\n", work->input->block_count, (unsigned)error);\n')
probe.write_text(d)
adapter.write_text(a)
frontier.write_text(f)
