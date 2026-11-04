# tally.py PASSDIR: one line per program of a campaign pass, as the 9700X record's campaign.tsv has them:
# chunk, program, status, sig=signature, then each step's status:exit_code in the harness's order.
import json, os, sys
STEPS = ["buster-tier0-compile", "buster-tier0-run", "buster-tier1-compile", "buster-tier1-run", "clang-o0-compile", "clang-o0-run", "clang-o2-compile", "clang-o2-run"]
root = sys.argv[1]
lines = []
for chunk in sorted(d for d in os.listdir(root) if d.startswith("chunk-") and os.path.isdir(os.path.join(root, d))):
    for campaign in sorted(os.listdir(os.path.join(root, chunk))):
        base = os.path.join(root, chunk, campaign)
        if not os.path.isdir(base):
            continue
        for program in sorted(os.listdir(base)):
            result = os.path.join(base, program, "result.json")
            if program == "preflight" or not os.path.exists(result):
                continue
            r = json.load(open(result))
            steps = []
            for step in STEPS:
                p = os.path.join(base, program, step + ".json")
                if os.path.exists(p):
                    s = json.load(open(p))
                    steps.append("%s=%s:%d" % (step, s["status"], s["exit_code"]))
            lines.append(" ".join([chunk, program, r["status"], "sig=" + (r.get("signature") or "none")] + steps))
print("\n".join(lines))
