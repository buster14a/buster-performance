#!/usr/bin/env python3
# equal15.py CHUNK OUT TREE: each program of one of #142's campaign chunks at c5f4863a, compiled again by its recorded Tier 1
# command (buster-tier1-compile.json's argv and cwd, --scalar where the campaign passed it) with c5f4863a's build and
# with TREE's (head-b6d9570c, head-1b073842), each into a scratch executable. One line per program to OUT: the recorded
# status and exit code, each rerun's exit code, and whether each rerun's executable equals the campaign's
# buster-tier1.exe, and TREE's c5's, byte for byte (stderr likewise where a compile is refused).
import glob, json, os, subprocess, sys
chunk, out = sys.argv[1], sys.argv[2]
rundir = "/tmp/claude-141-wide"
trees = ["head-c5f4863a", sys.argv[3]]
base = os.path.expanduser("~/buster-fast-bench/claude-141-wide")
with open(out, "a") as log:
    for step in sorted(glob.glob(os.path.join(chunk, "campaign-*", "*", "buster-tier1-compile.json"))):
        program = os.path.dirname(step)
        recorded = json.load(open(step))
        argv = recorded["argv"]
        o = argv.index("-o")
        results = []
        for tree in trees:
            target = os.path.join(rundir, "equal15-%s.exe" % tree)
            if os.path.exists(target):
                os.remove(target)
            command = [os.path.join(base, tree, "build", "compiler")] + argv[1:o + 1] + [target] + argv[o + 2:]
            try:
                done = subprocess.run(command, cwd=recorded["cwd"], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, timeout=120)
                code, stderr = done.returncode, done.stderr
            except subprocess.TimeoutExpired:
                code, stderr = "timeout", b""
            image = open(target, "rb").read() if code == 0 and os.path.exists(target) else None
            results.append((code, image, stderr))
        campaign_path = os.path.join(program, "buster-tier1.exe")
        campaign = open(campaign_path, "rb").read() if os.path.exists(campaign_path) else None
        recorded_stderr = open(os.path.join(program, "buster-tier1-compile.stderr"), "rb").read()
        def same(a, b):
            return "yes" if a == b else "no"
        (c5, b6) = results
        line = [os.path.basename(chunk.rstrip("/")), os.path.basename(program), recorded["status"], str(recorded["exit_code"]),
                "c5=%s" % c5[0], "head=%s" % b6[0],
                "c5-exe=campaign:%s" % (same(c5[1], campaign) if campaign is not None else "none"),
                "head-exe=campaign:%s" % (same(b6[1], campaign) if campaign is not None else "none"),
                "head-exe=c5:%s" % same(b6[1], c5[1]),
                "head-stderr=c5:%s" % same(b6[2], c5[2]),
                "c5-stderr=campaign:%s" % same(c5[2], recorded_stderr)]
        log.write(" ".join(line) + "\n")
