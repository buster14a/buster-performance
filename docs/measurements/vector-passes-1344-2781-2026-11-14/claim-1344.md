**Claim (research and design, not #2744 or #2745):** a census by cause of what Tier 1's `c_tokenize` still executes beyond clang -O2's on current main (`45cd9aec`, after #2742), for the part the filed follow-ups do not explain, and a design for the largest unfiled cause.

Why this scope: by #2744's own count (`c_tokenize`, 9,076 bytes, 122,190 instructions after the quadword splats), the 1,824 stack-built constants and their loads are about 22 K instructions, and #2745's zeroed objects about 4 K. That leaves roughly 96 K instructions, 10.6 per byte against clang's 3.06, that no open issue names. I will count them by cause (vector and mask moves, spills and reloads, loads that could be operands, logic that could be one `vpternlog`, constants rebuilt inside loops, and whatever else shows up) and post each finding here or as its own issue as soon as it has numbers.

The record goes to buster-performance's `main`; the design goes to a pull request here. I am not claiming #2744 or #2745 and will not touch their code.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
