#!/usr/bin/env bash
# run.sh TITLE VARIANT...: runs exp.sh on the 9700X under its lock and summarizes each variant against base.
set -euo pipefail
title=$1; shift
timeout 1200 tailscale ssh david@benchpress "cd ~/buster-fast-bench/claude-880 && EXCLUSIVE_OWNER=claude-880 EXCLUSIVE_TITLE=\"solve 880: $title\" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/880 ~/buster-fast-bench/exclusive.sh ./exp.sh $*" 2>&1 | grep -v "^exclusive\|^  title\|^  link" | tee -a ~/.cache/claude-880/exp.log | python3 -c '
import sys,collections
d=collections.defaultdict(list); other=[]
for l in sys.stdin:
    p=l.split()
    if len(p)==5 and p[3].endswith(":u"): d[(p[0],p[1],p[3])].append(int(p[4]))
    else: other.append(l.rstrip())
base={}
for l in open("/home/david/.cache/claude-880/base.counts"):
    p=l.split(); base[(p[0],p[1])]=float(p[2])
for (v,m,e),vals in sorted(d.items()):
    x=min(vals) if e=="cycles:u" else vals[0]
    b=base.get((m,e))
    print(f"{v:10s} {m:14s} {e:32s} {x:14,d}  {(x/b-1)*100:+6.2f}%" if b else f"{v} {m} {e} {x}")
print("\n".join(other))
'
