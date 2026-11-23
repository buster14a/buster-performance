#!/usr/bin/env python3
# fit2.py PROBE_DIR [MIN_BODY_TOKENS]: #1667's fit, second form. Per-body one-lane walks (median of a body's readings);
# models fitted by non-negative least squares on the training units' bodies, each body weighted by 1/sqrt(walk) (between
# absolute and relative error): tokens (one per body + per token) and kind groups (one per body + per group). Scored on
# units whose bodies have MIN tokens or more (2000 by default), each unit's whole walk predicted against measured:
# |log error| median, 90th percentile and max, on training and held-out units (Lua's; a third of musl's and
# c-testsuite's by name).
import os, sys, math, zlib, statistics as st
import numpy as np
from collections import defaultdict
KINDS = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "kinds.txt")).read().split()
GROUPS = os.environ.get("KGROUPS", "ident:IDENTIFIER lit:NUMBER,CHARACTER,STRING paren:L_PAREN,R_PAREN,L_SQUARE,R_SQUARE brace:L_BRACE,R_BRACE,SEMI,COLON,COMMA member:PERIOD,ARROW decl:TYPE,STRUCT,ENUM,QUALIFIER,ATOMIC,CALLING_CONVENTION,STORAGE,TYPEDEF,ATTRIBUTE,ALIGNAS,TYPEOF,TYPE_ARGUMENT,STATIC_ASSERT,EXTENSION,ASM,SIZEOF,GENERIC,REAL_IMAG ctl:LABEL,IF,ELSE,SWITCH,CASE,DEFAULT,WHILE,DO,FOR,GOTO,CONTINUE,BREAK,RETURN").split()
group_of = {}; names = []
for g in GROUPS:
    name, members = g.split(":"); names.append(name)
    for k in members.split(","): group_of[KINDS.index(k)] = len(names) - 1
OTHER = len(names); names.append("op")
MIN = int(sys.argv[2]) if len(sys.argv) > 2 else 2000
units = {}
for f in sorted(os.listdir(sys.argv[1])):
    bodies = defaultdict(list); feats = {}
    for line in open(os.path.join(sys.argv[1], f)):
        p = line.split()
        key = int(p[1]); bodies[key].append(int(p[3]))
        if key not in feats:
            v = np.zeros(len(names) + 2); v[0] = 1; v[1] = int(p[2])
            for kc in p[4:]:
                k, c = map(int, kc.split(":")); v[2 + group_of.get(k, OTHER)] += c
            feats[key] = v
    if bodies: units[f[:-4]] = (np.array([feats[k] for k in bodies]), np.array([st.median(w) for w in bodies.values()]))
def held(u): return u.startswith("lua_") or (not u.startswith("sqlite") and zlib.crc32(u.encode()) % 3 == 0)
def cols(X, model): return X[:, [0, 1]] if model == "tokens" else np.concatenate((X[:, :1], X[:, 2:]), axis=1)
def nnls(A, b):
    active = list(range(A.shape[1]))
    while True:
        c, *_ = np.linalg.lstsq(A[:, active], b, rcond=None)
        if (c >= 0).all(): break
        active.pop(int(np.argmin(c)))
    out = np.zeros(A.shape[1]); out[active] = c; return out
res = {}
for model in ("tokens", "groups"):
    X = np.concatenate([cols(units[u][0], model) for u in units if not held(u)]); y = np.concatenate([units[u][1] for u in units if not held(u)])
    w = 1 / np.sqrt(np.maximum(y, 1))
    coef = nnls(X * w[:, None], y * w); res[model] = coef
    for part in ("train", "held"):
        errs = sorted(abs(math.log(max((cols(units[u][0], model) @ coef).sum(), 1) / units[u][1].sum())) for u in units
                      if held(u) == (part == "held") and units[u][0][:, 1].sum() >= MIN)
        print(f"{model:6s} {part:5s} units={len(errs)} median|log err|={100*st.median(errs):.1f}% p90={100*errs[int(.9*len(errs))]:.1f}% max={100*errs[-1]:.1f}%")
    print("  coef ns:", " ".join(f"{n}={c:.2f}" for n, c in zip(["body"] + (["token"] if model == "tokens" else names), coef)))
for u in os.environ.get("SHOW", "").split():
    X, y = units[u]; t = X[:, 1].sum()
    print(f"{u:34s} bodies={len(y)} tokens={t:.0f} walk={y.sum()/1e3:.1f}us ns/tok={y.sum()/t:.1f} pred: tokens={(cols(X,'tokens')@res['tokens']).sum()/1e3:.1f} groups={(cols(X,'groups')@res['groups']).sum()/1e3:.1f} held={held(u)}")
