# The order's mutants again, after the fixture gained its line of stores, calls and updates of later-code operands:
# each (name, old, new, which occurrence). The first changes nothing: the fixture's own pins.
MUTATIONS = [
    ("no change", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", 0),
    ("a store not a round after its later operand", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", "(operand >> 4) + ((operand & 0x0fu) > code && code != BUSTER_NODE_FACTS_CODE_STORE ? 1u : 0u);", 0),
    ("a call or an update not a round after its later operand", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", "(operand >> 4) + ((operand & 0x0fu) > code && code != BUSTER_NODE_FACTS_CODE_CALL && code != BUSTER_NODE_FACTS_CODE_UPDATE ? 1u : 0u);", 0),
]
