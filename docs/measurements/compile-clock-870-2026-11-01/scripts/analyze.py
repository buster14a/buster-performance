#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Summarize the #870 control and repeated SQLite stage reports. This reads only the run's raw logs and writes new files;
# it never rewrites a log.
import csv
import glob
import os
import statistics
import sys


def rows(path):
    with open(path, encoding="utf-8", errors="replace") as handle:
        for line in handle:
            yield line.rstrip("\n").split("\t")


def median(values):
    return statistics.median(values) if values else None


def fmt(value, digits=3):
    return "unavailable" if value is None else f"{value:.{digits}f}"


def control_config(path):
    config = {}
    for fields in rows(path):
        if fields[0] == "clock-config" and len(fields) >= 3:
            config[fields[1]] = fields[2]
    return config


def control_samples(path):
    samples = []
    for fields in rows(path):
        if fields[0] == "phase" and len(fields) >= 19:
            samples.append(
                {
                    "round": int(fields[1]),
                    "kind": fields[2],
                    "length_us": int(fields[3]),
                    "offset_us": int(fields[4]),
                    "sequence": int(fields[5]),
                    "work": int(fields[6]),
                    "elapsed_ms": float(fields[7]),
                    "process_cpu_ms": float(fields[8]),
                    "system_ms": float(fields[9]),
                    "pmu_user_ms": float(fields[10]),
                    "pmu_kernel_ms": float(fields[11]),
                    "minor_faults": int(fields[12]),
                    "voluntary": int(fields[13]),
                    "involuntary": int(fields[14]),
                    "task_user_ms": float(fields[15]),
                    "task_kernel_ms": float(fields[16]),
                    "pmu_share": float(fields[17]),
                    "usage": fields[18],
                }
            )
    return samples


def aggregate(samples, kind, length_us):
    selected = [s for s in samples if s["kind"] == kind and s["length_us"] == length_us and s["elapsed_ms"] > 0]
    system = [s["system_ms"] for s in selected]
    elapsed = [s["elapsed_ms"] for s in selected]
    pmu = [s["pmu_kernel_ms"] for s in selected if s["pmu_kernel_ms"] >= 0]
    task = [s["task_kernel_ms"] for s in selected if s["pmu_kernel_ms"] >= 0]
    errors = [abs(s["system_ms"] - s["pmu_kernel_ms"]) for s in selected if s["pmu_kernel_ms"] >= 0]
    shares = [s["system_ms"] / s["elapsed_ms"] for s in selected]
    pmu_shares = [s["pmu_kernel_ms"] / s["elapsed_ms"] for s in selected if s["pmu_kernel_ms"] >= 0]
    task_errors = [s["task_kernel_ms"] - s["pmu_kernel_ms"] for s in selected if s["pmu_kernel_ms"] >= 0]
    return {
        "count": len(selected),
        "elapsed_ms": median(elapsed),
        "system_ms": median(system),
        "pmu_kernel_ms": median(pmu),
        "task_kernel_ms": median(task),
        "absolute_error_ms": median(errors),
        "system_share": median(shares),
        "pmu_share": median(pmu_shares),
        "task_error_ms": median(task_errors),
        "involuntary": median([s["involuntary"] for s in selected]),
        "work": median([s["work"] for s in selected]),
    }


def main(out):
    logs = os.path.join(out, "logs")
    control_paths = sorted(glob.glob(os.path.join(logs, "control-*.tsv")))
    control_runs = [(path, control_samples(path)) for path in control_paths]
    all_samples = [sample for _, samples in control_runs for sample in samples]
    config = control_config(control_paths[0]) if control_paths else {}
    lengths = sorted({sample["length_us"] for sample in all_samples})
    kinds = ["cpu", "fault", "syscall", "empty"]

    lines = ["# Compile-clock control (#870)", ""]
    lines += ["## Host and accounting configuration", "", "| key | value |", "| --- | --- |"]
    for key in sorted(config):
        lines.append(f"| `{key}` | `{config[key]}` |")
    lines += ["", f"Control processes: {len(control_runs)}; samples: {len(all_samples)}.", ""]

    lines += ["## CPU-only attribution versus hardware kernel cycles", ""]
    lines += ["| target µs | samples | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms | getrusage system share | PMU kernel share | involuntary switches |",
              "| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for length in lengths:
        value = aggregate(all_samples, "cpu", length)
        lines.append(
            f"| {length} | {value['count']} | {fmt(value['elapsed_ms'])} | {fmt(value['system_ms'])} | {fmt(value['pmu_kernel_ms'])} | "
            f"{fmt(value['absolute_error_ms'])} | {fmt(value['system_share'], 4)} | {fmt(value['pmu_share'], 4)} | {fmt(value['involuntary'], 1)} |"
        )
    lines += ["", "The CPU-only phase has no intentional kernel work. Any attributed system time, and any gap between the",
              "getrusage share and the hardware kernel-cycle share, is accounting leakage or quantization.", ""]

    lines += ["## Page-fault and syscall phases", ""]
    lines += ["| target µs | kind | samples | work units | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms |",
              "| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for kind in ["fault", "syscall"]:
        for length in lengths:
            value = aggregate(all_samples, kind, length)
            lines.append(
                f"| {length} | {kind} | {value['count']} | {fmt(value['work'], 0)} | {fmt(value['elapsed_ms'])} | {fmt(value['system_ms'])} | "
                f"{fmt(value['pmu_kernel_ms'])} | {fmt(value['absolute_error_ms'])} |"
            )
    lines += ["", "These phases do have kernel work. Their error is the same comparison, not evidence that a phase is cheap.", ""]

    lines += ["## task-clock:k is not an independent kernel timer", ""]
    lines += ["| target µs | task-clock:k ms | PMU kernel ms | difference ms |", "| ---: | ---: | ---: | ---: |"]
    for length in lengths:
        value = aggregate(all_samples, "cpu", length)
        lines.append(f"| {length} | {fmt(value['task_kernel_ms'])} | {fmt(value['pmu_kernel_ms'])} | {fmt(value['task_error_ms'])} |")
    lines += ["", "On the control's CPU-only phases, `task-clock:k` tracks the whole phase rather than its kernel cycles.",
              "It is retained as a comparison and not used as the attribution oracle.", ""]

    verdicts = []
    for path in control_paths:
        for fields in rows(path):
            if fields[0] == "summary" and len(fields) >= 3 and fields[1] == "verdict":
                verdicts.append(fields[2])
    lines += ["## Verdict", ""]
    lines.append(f"Per-process verdicts: {', '.join(verdicts) if verdicts else 'none'}.")
    lines.append("")
    lines.append("A `low-confidence` verdict means the getrusage deltas disagree with hardware user/kernel cycles beyond the")
    lines.append("campaign's tolerance, not that no kernel work happened. `--time-stages` therefore reports the split as raw,")
    lines.append("low-confidence values and reports it unavailable when getrusage itself fails.")
    lines += [""]

    # The repeated SQLite report: parse elapsed and system attribution, and the report's own qualification rows.
    sqlite_rows = []
    for path in sorted(glob.glob(os.path.join(logs, "sqlite-*.stderr"))):
        run = os.path.basename(path).replace("sqlite-", "").replace(".stderr", "")
        parse = None
        total = None
        status = "missing"
        accuracy = "missing"
        for fields in rows(path):
            if fields[0] == "time-stage" and len(fields) >= 7 and fields[1] == "parse":
                parse = (float(fields[2]), float(fields[4]), int(fields[5]))
            elif fields[0] == "time-stage" and len(fields) >= 3 and fields[1] == "total":
                total = float(fields[2])
            elif fields[0] == "time-process" and len(fields) >= 3 and fields[1] == "stage-system-status":
                status = fields[2]
            elif fields[0] == "time-process" and len(fields) >= 3 and fields[1] == "stage-system-accuracy":
                accuracy = fields[2]
        if parse is not None:
            sqlite_rows.append((run, parse[0], parse[1], parse[2], total, status, accuracy))

    lines += ["## Repeated frozen SQLite compile", ""]
    lines += ["| run | parse elapsed ms | parse system ms | parse minor faults | total span ms | system status | accuracy |",
              "| ---: | ---: | ---: | ---: | ---: | --- | --- |"]
    for row in sqlite_rows:
        lines.append(f"| {row[0]} | {fmt(row[1])} | {fmt(row[2])} | {row[3]} | {fmt(row[4])} | `{row[5]}` | `{row[6]}` |")
    if sqlite_rows:
        elapsed = [row[1] for row in sqlite_rows]
        system = [row[2] for row in sqlite_rows]
        lines += ["", f"Parse elapsed median {median(elapsed):.3f} ms (range {min(elapsed):.3f} to {max(elapsed):.3f}), "
                      f"parse system median {median(system):.3f} ms (range {min(system):.3f} to {max(system):.3f}).", ""]
        lines.append("The elapsed range is the stable timing; the system range is the qualification the report labels low confidence.")
    else:
        lines += ["", "No complete repeated report was found.", ""]

    # The harness's own stage table and warning.
    measure_path = os.path.join(logs, "measure-compile.txt")
    lines += ["## measure-compile", ""]
    if os.path.exists(measure_path):
        with open(measure_path, encoding="utf-8", errors="replace") as handle:
            text = handle.read()
        lines += ["```text"]
        for line in text.splitlines():
            if any(token in line for token in ("stage system time", "stages, medians", "span", "parse ", "time-stages costs", "default against reference", "failures")):
                lines.append(line)
        lines += ["```", ""]
    else:
        lines += ["No `measure-compile` log.", ""]

    os.makedirs(os.path.join(out, "analysis"), exist_ok=True)
    with open(os.path.join(out, "analysis", "summary.md"), "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines) + "\n")
    with open(os.path.join(out, "analysis", "sqlite-stages.csv"), "w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["run", "parse_elapsed_ms", "parse_system_ms", "parse_minor_faults", "total_span_ms", "system_status", "accuracy"])
        writer.writerows(sqlite_rows)
    print("\n".join(lines))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: analyze.py OUTPUT_DIRECTORY", file=sys.stderr)
        raise SystemExit(2)
    main(sys.argv[1])
