# Live Benchpress profiling smoke for Buster PR 3664

Ran `dev.sh --9700x` from the checkout at `ebf4500953c3754c2345f2c91fcfb31f758adb4f`. The session routed the script's `tailscale ssh david@benchpress` invocation through its authenticated SSH transport into the same tailnet host. Both commands executed on the actual Ryzen 7 9700X using CPU 2 and the shared lock. Both returned their result directories to the client.

`paths --only tier0 --runs 5 --run --events cycles:u,instructions:u` compiled the [documented self-checking workload](workload.c) using the existing Release compiler at `dd308d43064fcb349ed8fb2ac06996d474c6c1bc`. All five compile and runtime samples succeeded. The median compile was 0.705 ms wall and 1,384,567 user cycles. Median program runtime was 1.026 ms wall and 5,170,196 user cycles. The measured Tier 0 object was 1,240 bytes. These are smoke-test timings for one compiler and one workload.

`asm` disassembled the exact sized `mix` function from the generated object on Benchpress. It returned the instruction bytes for `imul`, `inc` and `ret`.

[Compile samples](paths/compile.txt) · [Runtime samples](paths/runtime.txt) · [Disassembly](asm/function.txt)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
