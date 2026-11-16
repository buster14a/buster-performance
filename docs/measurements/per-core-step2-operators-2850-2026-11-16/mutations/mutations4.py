# Two more single changes, of the classes' order itself, after the lists' twin gained its order check: each (name, old,
# new, which occurrence). The first is in the function the kernel and the twin share; the second makes only `=` early,
# which sets the decoys' flag itself.
MUTATIONS = [
    ("an operand's later code not a round more", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", "(operand >> 4) + ((operand & 0x0fu) > code ? 0u : 0u);", 0),
    ("a store not a round after its later operand", "(operand >> 4) + ((operand & 0x0fu) > code ? 1u : 0u);", "(operand >> 4) + ((operand & 0x0fu) > code && code != BUSTER_NODE_FACTS_CODE_STORE ? 1u : 0u);", 0),
]
