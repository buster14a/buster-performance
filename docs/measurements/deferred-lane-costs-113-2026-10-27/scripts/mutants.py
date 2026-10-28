# Each mutant: a name, the suites that must fail ("lanes", "deferred"), and replacements (file, old, new) that must each
# match exactly once in the branch's source.
M = [
  ("m1-order-first-part", ["lanes"], [
    ("src/buster/compiler/lane.c", "        costliest = cost > most ? part : costliest;\n", "        costliest = cost > most ? 0 : costliest;\n"),
  ]),
  ("m2-parts-lane-count", ["lanes", "deferred"], [
    ("src/buster/compiler/lane.c", "    const uint64_t parts = lane_part_count_for(count, lanes < BUSTER_LANE_MAX_COUNT ? lanes : BUSTER_LANE_MAX_COUNT);\n", "    const uint64_t parts = lane_part_count_for(count, lanes < BUSTER_LANE_MAX_COUNT ? lanes + 1 : BUSTER_LANE_MAX_COUNT);\n"),
  ]),
  ("m2b-parts-unbounded", ["lanes"], [
    ("src/buster/compiler/lane.c", "    const uint64_t parts = lane_part_count_for(count, lanes < BUSTER_LANE_MAX_COUNT ? lanes : BUSTER_LANE_MAX_COUNT);\n", "    const uint64_t parts = lane_part_count_for(count, lanes);\n"),
  ]),
  ("m3-first-lane-races", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "    uint64_t taken = index == 0 ? 0 : 1 + lane_take(parts - 1);\n", "    uint64_t taken = lane_take(parts);\n"),
    ("src/buster/compiler/c_check_deferred.c", "    for (; taken < parts; taken = 1 + lane_take(parts - 1))\n", "    for (; taken < parts; taken = lane_take(parts))\n"),
  ]),
  ("m4-parts-for-every-lane", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "parts_by_cost(deferred->costs, deferred->body_count, active, deferred->boundaries, deferred->order)", "parts_by_cost(deferred->costs, deferred->body_count, deferred->lanes, deferred->boundaries, deferred->order)"),
  ]),
  ("m5-no-reservation", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "        check_deferred_lane_arenas(deferred->memory.lanes + lane);\n    }\n    const uint64_t lanes_begin", "        (void)lane;\n    }\n    const uint64_t lanes_begin"),
  ]),
  ("m6-release-keeps-mapping", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "            munmap(arenas->mapping, BUSTER_CHECK_DEFERRED_LANE_BYTES);\n", "            (void)arenas;\n"),
  ]),
  ("m7-memory-not-kept", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "        .memory = memory,\n", "        .memory = (CheckDeferredMemory){ .arena = memory.arena },\n"),
  ]),
  ("m8-stamps-not-cleared", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "        memset(lane->stamps, 0, (uint64_t)names * sizeof(uint32_t));\n", "        (void)names;\n"),
  ]),
  ("m9-mask-not-cleared", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "        memset(mask, 0, (uint64_t)count + 1);\n", "        (void)count;\n"),
  ]),

  ("r1-largest-twice", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "    const uint64_t path = deferred->largest_body > second ? deferred->largest_body : second;\n", "    const uint64_t path = (uint64_t)deferred->largest_body * 2 + 0 * second;\n"),
  ]),
  ("r2-largest-alone", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "    const uint64_t path = deferred->largest_body > second ? deferred->largest_body : second;\n", "    const uint64_t path = deferred->largest_body + 0 * second;\n"),
  ]),
  ("r3-no-top-share", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "    deferred->lane_tokens = BUSTER_CHECK_DEFERRED_LANE_TOKENS + deferred->top_tokens / BUSTER_CHECK_DEFERRED_LANE_TOP_TOKENS;\n", "    deferred->lane_tokens = BUSTER_CHECK_DEFERRED_LANE_TOKENS + 0 * deferred->top_tokens / BUSTER_CHECK_DEFERRED_LANE_TOP_TOKENS;\n"),
  ]),
  ("r4-ceiling", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "1 + (total > path ? total - path : 0) / deferred->lane_tokens;\n", "1 + ((total > path ? total - path : 0) + deferred->lane_tokens - 1) / deferred->lane_tokens;\n"),
  ]),
  ("r5-every-lane-ignored", ["deferred"], [
    ("src/buster/compiler/c_check_deferred.c", "    const uint64_t paid = deferred->every_lane ? UINT64_MAX : 1 +", "    const uint64_t paid = deferred->every_lane && false ? UINT64_MAX : 1 +"),
  ]),
]
