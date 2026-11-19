# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# For mixed.s only: apply readelf -wf's decoded CIE/FDE operations at the addresses it resolved.
# Emit one effective row per PC, independent of where the producer placed the initial instructions.
BEGIN {
    split("1 1 2 3 4 5 6 1 5 1", expected_cie)
}
function fail(message) {
    print "mixed frames: " message > "/dev/stderr"
    failed = 1
    exit 1
}
function row() {
    rows[section]++
    print section, fdes[section], range, pc, return_col, signal, reg, offset, rip
}
function finish() {
    if (kind == "CIE") {
        regs[id] = reg
        offsets[id] = offset
        rips[id] = rip
        returns[id] = return_col
        signals[id] = signal
    } else if (kind == "FDE") {
        row()
    }
    kind = ""
}
$1 == "Contents" {
    finish()
    section = $4
}
$4 == "CIE" {
    finish()
    kind = "CIE"
    id = section SUBSEP $1
    ordinal[id] = ++cies[section]
    reg = offset = rip = return_col = signal = "unset"
}
$1 == "Return" && $2 == "address" { return_col = $NF }
$1 == "Augmentation:" { signal = index($2, "S") != 0 }
$4 == "FDE" {
    finish()
    kind = "FDE"
    fdes[section]++
    id = section SUBSEP substr($5, 5)
    if (!(id in regs)) fail("unknown CIE " $5)
    if (buster && ordinal[id] != expected_cie[fdes[section]]) fail("unexpected CIE for FDE " fdes[section])
    reg = regs[id]; offset = offsets[id]; rip = rips[id]; return_col = returns[id]; signal = signals[id]
    range = substr($6, 4)
    split(range, bounds, /\.\./)
    pc = bounds[1]
}
$1 == "DW_CFA_def_cfa:" { reg = $2; offset = $NF; next }
$1 == "DW_CFA_def_cfa_offset:" { offset = $NF; next }
$1 == "DW_CFA_offset:" && $2 == "r16" { rip = $NF; next }
$1 == "DW_CFA_advance_loc:" && kind == "FDE" { row(); pc = $NF; next }
$1 ~ /^DW_CFA_/ && $1 != "DW_CFA_nop" { fail("unexpected instruction " $0) }
END {
    if (failed) exit 1
    finish()
    if (fdes[".eh_frame"] != 10 || fdes[".debug_frame"] != 10 ||
        rows[".eh_frame"] != 11 || rows[".debug_frame"] != 11) fail("incomplete FDE coverage")
    if (buster && (cies[".eh_frame"] != 6 || cies[".debug_frame"] != 6)) fail("unexpected CIE count")
}
