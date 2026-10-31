#!/usr/bin/env python3
import gzip
import json
import math
import re
import sys
from collections import defaultdict

PAT = re.compile(
    r"^ir-dataflow-benchmark: file=(?P<file>.*?) function=(?P<function>.*?) form=(?P<form>.*?) "
    r"operation=(?P<operation>.*?) path=(?P<path>.*?) vector_host=(?P<vector_host>\d+) "
    r"blocks=(?P<blocks>\d+) instructions=(?P<instructions>\d+) dense=(?P<dense>\d+) "
    r"phi_uses=(?P<phi_uses>\d+) row_words=(?P<row_words>\d+) matrix_bytes=(?P<matrix_bytes>\d+) "
    r"retained_bytes=(?P<retained_bytes>\d+) iterations=(?P<iterations>\d+) "
    r"cycles_per_function=(?P<cycles>[\d.]+) cycles_per_block_iteration=(?P<block_cycles>[\d.]+) "
    r"ns_per_function=(?P<ns>[\d.]+)$"
)

def quantile(values, q):
    if not values:
        return None
    ordered = sorted(values)
    if len(ordered) == 1:
        return ordered[0]
    pos = (len(ordered) - 1) * q
    lo = math.floor(pos)
    hi = math.ceil(pos)
    if lo == hi:
        return ordered[lo]
    return ordered[lo] * (hi - pos) + ordered[hi] * (pos - lo)

def summarize(rows, label):
    # rows: key (file, function, form, operation, path) -> dict
    forms = defaultdict(dict)
    for (file, function, form, operation, path), row in rows.items():
        forms[(file, function, form, operation)][path] = row
    out = {"label": label, "forms": len(forms), "pairs": 0, "by_operation": {}, "by_form": {}}
    for operation in sorted({key[3] for key in forms}):
        pairs = []
        for key, pair in forms.items():
            if key[3] != operation or "vector" not in pair or "scalar" not in pair:
                continue
            v = pair["vector"]
            s = pair["scalar"]
            if s["cycles"] <= 0 or s["block_cycles"] <= 0:
                continue
            pairs.append((v, s))
        if not pairs:
            continue
        ratios = [v["cycles"] / s["cycles"] for v, s in pairs]
        block_ratios = [v["block_cycles"] / s["block_cycles"] for v, s in pairs]
        total_v = sum(v["cycles"] for v, s in pairs)
        total_s = sum(s["cycles"] for v, s in pairs)
        out["by_operation"][operation] = {
            "pairs": len(pairs),
            "sum_vector_cycles": total_v,
            "sum_scalar_cycles": total_s,
            "aggregate_vector_over_scalar": total_v / total_s,
            "aggregate_speedup": total_s / total_v,
            "median_per_form_vector_over_scalar": quantile(ratios, 0.5),
            "p10_per_form_vector_over_scalar": quantile(ratios, 0.1),
            "p90_per_form_vector_over_scalar": quantile(ratios, 0.9),
            "vector_faster_forms": sum(1 for r in ratios if r < 1.0),
            "vector_slower_forms": sum(1 for r in ratios if r > 1.0),
            "equal_forms": sum(1 for r in ratios if r == 1.0),
            "median_per_form_block_vector_over_scalar": quantile(block_ratios, 0.5),
            "p10_per_form_block_vector_over_scalar": quantile(block_ratios, 0.1),
            "p90_per_form_block_vector_over_scalar": quantile(block_ratios, 0.9),
        }
        out["pairs"] += len(pairs)
    for form in sorted({key[2] for key in forms}):
        sub = {key: value for key, value in forms.items() if key[2] == form}
        sub_out = {}
        for operation in sorted({key[3] for key in sub}):
            pairs = []
            for key, pair in sub.items():
                if key[3] != operation or "vector" not in pair or "scalar" not in pair:
                    continue
                v = pair["vector"]
                s = pair["scalar"]
                if s["cycles"] <= 0 or s["block_cycles"] <= 0:
                    continue
                pairs.append((v, s))
            if not pairs:
                continue
            ratios = [v["cycles"] / s["cycles"] for v, s in pairs]
            block_ratios = [v["block_cycles"] / s["block_cycles"] for v, s in pairs]
            total_v = sum(v["cycles"] for v, s in pairs)
            total_s = sum(s["cycles"] for v, s in pairs)
            sub_out[operation] = {
                "pairs": len(pairs),
                "sum_vector_cycles": total_v,
                "sum_scalar_cycles": total_s,
                "aggregate_vector_over_scalar": total_v / total_s,
                "aggregate_speedup": total_s / total_v,
                "median_per_form_vector_over_scalar": quantile(ratios, 0.5),
                "p10_per_form_vector_over_scalar": quantile(ratios, 0.1),
                "p90_per_form_vector_over_scalar": quantile(ratios, 0.9),
                "vector_faster_forms": sum(1 for r in ratios if r < 1.0),
                "vector_slower_forms": sum(1 for r in ratios if r > 1.0),
                "equal_forms": sum(1 for r in ratios if r == 1.0),
                "median_per_form_block_vector_over_scalar": quantile(block_ratios, 0.5),
            }
        out["by_form"][form] = sub_out
    return out

def main():
    corpora = [
        ("sqlite", "/tmp/opencode/takeover-942-measure/bench-sqlite.out.gz"),
        ("sqlite-2", "/tmp/opencode/takeover-942-measure/bench-sqlite-2.out.gz"),
        ("musl", "/tmp/opencode/takeover-942-measure/bench-musl.out.gz"),
        ("musl-2", "/tmp/opencode/takeover-942-measure/bench-musl-2.out.gz"),
        ("c-testsuite", "/tmp/opencode/takeover-942-measure/bench-testsuite.out.gz"),
    ]
    all_out = {"corpora": {}}
    for label, path in corpora:
        rows = {}
        vector_hosts = set()
        functions = set()
        summary_lines = 0
        with gzip.open(path, "rt") as handle:
            for line in handle:
                match = PAT.match(line.rstrip("\n"))
                if not match:
                    continue
                summary_lines += 1
                d = match.groupdict()
                key = (d["file"], d["function"], d["form"], d["operation"], d["path"])
                rows[key] = {
                    "cycles": float(d["cycles"]),
                    "block_cycles": float(d["block_cycles"]),
                    "ns": float(d["ns"]),
                    "blocks": int(d["blocks"]),
                    "instructions": int(d["instructions"]),
                    "dense": int(d["dense"]),
                    "phi_uses": int(d["phi_uses"]),
                    "matrix_bytes": int(d["matrix_bytes"]),
                    "retained_bytes": int(d["retained_bytes"]),
                    "iterations": int(d["iterations"]),
                }
                vector_hosts.add(int(d["vector_host"]))
                functions.add((d["file"], d["function"]))
        summary = summarize(rows, label)
        summary["summary_lines"] = summary_lines
        summary["unique_functions"] = len(functions)
        summary["vector_hosts"] = sorted(vector_hosts)
        summary["total_matrix_bytes"] = sum(r["matrix_bytes"] for r in rows.values())
        summary["total_retained_bytes"] = sum(r["retained_bytes"] for r in rows.values())
        all_out["corpora"][label] = summary
    print(json.dumps(all_out, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()
