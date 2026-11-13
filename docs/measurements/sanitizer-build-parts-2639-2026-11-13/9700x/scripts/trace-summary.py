#!/usr/bin/env python3
# trace-summary.py TRACE.json: clang -ftime-trace's phases, its "Total" rows, and the functions and sources that took
# longest, in seconds.
import collections, json, sys
data = json.load(open(sys.argv[1]))
events = [e for e in data["traceEvents"] if e.get("ph") == "X"]
def seconds(us): return us / 1e6
main = max((e for e in events if e["name"] == "ExecuteCompiler"), key=lambda e: e["dur"], default=None)
print("== phases (tid of ExecuteCompiler)")
for name in ("ExecuteCompiler", "Frontend", "Backend", "Optimizer", "CodeGenPasses", "OptModule", "PerFunctionPasses", "PerModulePasses"):
    total = sum(e["dur"] for e in events if e["name"] == name and (main is None or e["tid"] == main["tid"]))
    if total: print(f"{name:24s} {seconds(total):9.2f}")
print("== Total rows (top 30)")
totals = sorted((e for e in events if e["name"].startswith("Total ")), key=lambda e: -e["dur"])
for e in totals[:30]: print(f"{seconds(e['dur']):9.2f}  {e['name'][6:]}")
by = collections.defaultdict(lambda: collections.Counter())
for e in events:
    detail = e.get("args", {}).get("detail")
    if detail: by[e["name"]][detail] += e["dur"]
for name in ("OptFunction", "RunLoopPass", "Source", "ParseFunctionDefinition", "CodeGen Function", "ParseDeclarationOrFunctionDefinition"):
    if name in by:
        print(f"== {name}: total {seconds(sum(by[name].values())):.2f}, top 12")
        for detail, dur in by[name].most_common(12): print(f"{seconds(dur):9.2f}  {detail[:140]}")
# Per-function codegen: machine passes carry the function as detail in recent LLVM ("RunPass" with detail pass name,
# nested in a per-function event). Report the details of the most expensive pass-named events.
print("== event names by total (top 25)")
names = collections.Counter()
for e in events:
    if not e["name"].startswith("Total "): names[e["name"]] += e["dur"]
for name, dur in names.most_common(25): print(f"{seconds(dur):9.2f}  {name}")
