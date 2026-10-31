#!/usr/bin/env python3
"""Paired placement timing for Buster #883.

The six placement images of each build are the same compiler objects linked
with a bounded inside-.text.buster_checker shift. Each measured block runs every
image once per round in a rotated order, then reports wall and stage medians and
paired candidate-baseline deltas.
"""
import argparse
import json
import os
import random
import re
import shutil
import statistics
import subprocess
import sys
import time

SHIFTS = [0, 16, 64, 256, 1024, 2048]
BUILDS = ["base", "base2", "candidate"]
STAGE = re.compile(r"^time-stage\t([^\t]+)\t([0-9.]+)")
NODES = re.compile(r"^lowering-nodes\tevaluated=(\d+)\tbatched=(\d+)\tshare=([0-9.]+)%\tclassified=(\d+)")


def parse(text):
    stages = {}
    nodes = None
    for line in text.splitlines():
        m = STAGE.match(line)
        if m:
            stages[m.group(1)] = float(m.group(2))
        m = NODES.match(line)
        if m:
            nodes = dict(evaluated=int(m.group(1)), batched=int(m.group(2)),
                         share=float(m.group(3)), classified=int(m.group(4)))
    return stages, nodes


def once(image, args, outdir, tag, timeout, copies=None):
    out = os.path.join(outdir, tag + ".o")
    run_image = image
    if copies:
        run_image = os.path.join(copies, tag)
        shutil.copy2(image, run_image)
    argv = [run_image] + args + ["-o", out]
    start = time.perf_counter_ns()
    try:
        p = subprocess.run(argv, capture_output=True, text=True, timeout=timeout)
        status, err = p.returncode, p.stderr
    except subprocess.TimeoutExpired as e:
        status, err = -999, (e.stderr or "") + "\nTIMEOUT"
    wall = time.perf_counter_ns() - start
    stages, nodes = parse(err)
    if os.path.exists(out):
        os.unlink(out)
    if copies and os.path.exists(run_image):
        os.unlink(run_image)
    return dict(status=status, wall_ms=wall / 1e6, lower=stages.get("lower"),
                lanes=stages.get("lanes"), total=stages.get("total"),
                nodes=nodes, tail=err[-800:])


def stats(values):
    if not values:
        return dict(n=0)
    rng = random.Random(883)
    med = statistics.median(values)
    boots = []
    for _ in range(5000):
        boots.append(statistics.median([values[rng.randrange(len(values))] for _ in values]))
    boots.sort()
    return dict(n=len(values), median=med, mean=statistics.mean(values),
                min=min(values), max=max(values),
                ci95=[boots[125], boots[4874]])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", required=True)
    ap.add_argument("--input", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--mode", choices=["lanes1", "default"], default="lanes1")
    ap.add_argument("--extra", default="")
    ap.add_argument("--runs", type=int, default=18)
    ap.add_argument("--warmups", type=int, default=3)
    ap.add_argument("--timeout", type=float, default=120.0)
    ap.add_argument("--tag", default="")
    ap.add_argument("--copies", default="")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    if a.copies:
        os.makedirs(a.copies, exist_ok=True)
    args = ["--time-stages"] + (["--lanes", "1"] if a.mode == "lanes1" else []) + a.extra.split() + ["-c", a.input]
    images = []
    for build in BUILDS:
        for shift in SHIFTS:
            image = os.path.join(a.root, "place-" + build, "compiler-%d" % shift)
            if not (os.path.isfile(image) and os.access(image, os.X_OK)):
                sys.exit("missing image " + image)
            images.append((build, shift, image))
    records = []
    for build, shift, image in images:
        for _ in range(a.warmups):
            r = once(image, args, a.out, "warm-%s-%d" % (build, shift), a.timeout, a.copies or None)
            r.update(build=build, shift=shift, round=-1)
            records.append(r)
    for rnd in range(a.runs):
        order = images[rnd % len(images):] + images[:rnd % len(images)]
        if rnd % 2:
            order = list(reversed(order))
        for build, shift, image in order:
            r = once(image, args, a.out, "r-%03d-%s-%d" % (rnd, build, shift), a.timeout, a.copies or None)
            r.update(build=build, shift=shift, round=rnd)
            records.append(r)
            if r["status"] != 0:
                print("FAIL round=%d %s/%d status=%d %s" % (rnd, build, shift, r["status"], r["tail"][-300:]), file=sys.stderr)
    with open(os.path.join(a.out, "records.json"), "w") as f:
        json.dump(dict(mode=a.mode, input=a.input, args=args, copies=a.copies, records=records), f)
    good = [r for r in records if r["round"] >= 0 and r["status"] == 0]
    index = {(r["build"], r["shift"], r["round"]): r for r in good}
    result = dict(mode=a.mode, tag=a.tag, input=a.input, runs=a.runs, args=args, copies=a.copies, images={}, paired={})
    for build in BUILDS:
        for shift in SHIFTS:
            rows = [r for r in good if r["build"] == build and r["shift"] == shift]
            result["images"]["%s/%d" % (build, shift)] = dict(
                wall=stats([r["wall_ms"] for r in rows]),
                lower=stats([r["lower"] for r in rows if r["lower"] is not None]),
                lanes=stats([r["lanes"] for r in rows if r["lanes"] is not None]),
                total=stats([r["total"] for r in rows if r["total"] is not None]),
                nodes=rows[0]["nodes"] if rows else None,
                failures=sum(1 for r in records if r["build"] == build and r["shift"] == shift and r["status"] != 0))
    for label, x, y in [("base2-base", "base2", "base"), ("candidate-base", "candidate", "base")]:
        per_shift = {}
        all_wall, all_lower, all_lanes = [], [], []
        for shift in SHIFTS:
            dw, dl, dn = [], [], []
            for rnd in range(a.runs):
                rx, ry = index.get((x, shift, rnd)), index.get((y, shift, rnd))
                if not rx or not ry:
                    continue
                dw.append(rx["wall_ms"] - ry["wall_ms"])
                if rx["lower"] is not None and ry["lower"] is not None:
                    dl.append(rx["lower"] - ry["lower"])
                if rx["lanes"] is not None and ry["lanes"] is not None:
                    dn.append(rx["lanes"] - ry["lanes"])
            per_shift[str(shift)] = dict(wall=stats(dw), lower=stats(dl), lanes=stats(dn))
            all_wall += dw
            all_lower += dl
            all_lanes += dn
        result["paired"][label] = dict(per_shift=per_shift, wall=stats(all_wall),
                                       lower=stats(all_lower), lanes=stats(all_lanes))
    with open(os.path.join(a.out, "summary.json"), "w") as f:
        json.dump(result, f, indent=2)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
