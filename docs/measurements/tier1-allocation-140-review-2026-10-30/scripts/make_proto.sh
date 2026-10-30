#!/bin/bash
# Writes proto_impl.c from buster's tier1_allocate.c: tier1_allocate_impl, renamed proto_allocate_impl, with a variant
# parameter whose bit 0 replaces the prefix sum and pointer-jumping coloring with harness.c's proto_color and whose
# bit 1 replaces tier1_allocate_scan with harness.c's proto_scan. Nothing else changes.
# Usage: make_proto.sh PATH/TO/tier1_allocate.c OUTPUT.c
set -e
sed -n '/^static Tier1AllocationError tier1_allocate_impl/,/^}/p' "$1" | sed \
    -e 's/^static Tier1AllocationError tier1_allocate_impl(const Tier1AllocationInput\* input, Arena\* arena, bool vector, Tier1Allocation\* result)$/static Tier1AllocationError proto_allocate_impl(const Tier1AllocationInput* input, Arena* arena, bool vector, uint32_t variant, Tier1Allocation* result)/' \
    -e 's/^\( *\)tier1_allocation_pressure(deltas, class_event_count, pressure);$/\1if ((variant \& 1) == 0) { tier1_allocation_pressure(deltas, class_event_count, pressure);/' \
    -e 's/^\( *\)tier1_allocation_color(input, class, class_events, pressure, class_event_count, parents, next, regs);$/\1tier1_allocation_color(input, class, class_events, pressure, class_event_count, parents, next, regs); } else { proto_color(input, class, class_events, class_event_count, regs); }/' \
    -e 's/^\( *\)assigned = tier1_allocate_scan(input, class, events, event_count, allowed, regs, split, kinds);$/\1assigned = (variant \& 2) != 0 ? proto_scan(input, class, events, event_count, allowed, regs, split, kinds) : tier1_allocate_scan(input, class, events, event_count, allowed, regs, split, kinds);/' \
    > "$2"
# The three substitutions must all have applied.
test "$(grep -c 'proto_allocate_impl\|proto_color\|proto_scan' "$2")" -eq 3
