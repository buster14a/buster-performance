A measured answer for the vector half of this policy, from #1344's census: restricting both passes to values of vector or mask type gives the vector lexer 5.38 cycles/B against the default's 10.31 and the unrestricted passes' 5.75 (desktop, 9700X run in progress), with 31 hoists and 4,172 merges instead of 1,886 and 57,071, and leaves `sqlite3.c`'s and Lua's `--tier1` objects byte-identical, so it cannot cost speedtest1 or Lua anything at run time. Filed with the design as #2781; the scalar half (pressure-aware hoists and merges of general-register values) stays here.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
