#!/usr/bin/env python3
"""#937: summarize the raw logs into the record's table."""
import statistics
from pathlib import Path

LOGS = Path(__file__).resolve().parent.parent / "logs"


def fields(line):
    result = {}
    for part in line.rstrip("\n").split("\t"):
        if "=" in part:
            key, value = part.split("=", 1)
            result[key] = value
        elif part not in result:
            result.setdefault("_", []).append(part)
    return result


medians = {}
pairs = {}
for line in (LOGS / "commands41.txt").read_text().splitlines():
    if line.startswith("median\t"):
        parts = line.split("\t")
        key = parts[1]
        values = {}
        for part in parts[2:]:
            if "=" in part:
                name, value = part.split("=", 1)
                values[name] = value
            elif part.startswith("runs="):
                values["runs"] = part[5:]
        medians[key] = values
    elif line.startswith("pair\t"):
        parts = line.split("\t")
        values = {}
        for part in parts[2:]:
            name, value = part.split("=", 1)
            values[name] = int(value)
        pairs[parts[1]] = values
for line in (LOGS / "serials.txt").read_text().splitlines():
    if line.startswith("median\t"):
        parts = line.split("\t")
        key = parts[1]
        values = {}
        for part in parts[2:]:
            if "=" in part:
                name, value = part.split("=", 1)
                values[name] = value
        medians[key] = values

lease_medians = {}
tokens = None
for line in (LOGS / "lease.txt").read_text().splitlines():
    if line.startswith("== tokens="):
        tokens = line.split("=")[-1]
    elif line.startswith("median\t") and tokens is not None:
        fields = {}
        for part in line.split("\t")[1:]:
            if "=" in part:
                name, value = part.split("=", 1)
                fields[name] = int(value)
        lease_medians[tokens] = fields

makes = []
for line in (LOGS / "make.txt").read_text().splitlines():
    if line.startswith("make\t"):
        parts = line.split("\t")
        values = {}
        for part in parts[2:]:
            if "=" in part:
                name, value = part.split("=", 1)
                values[name] = value
        makes.append((parts[1], values))


def ms(value):
    return f"{int(value) / 1e6:.3f}"


def us(value):
    return f"{int(value) / 1e3:.1f}"


print("One lease alone (median of 51), outside a compiler command:")
print("tokens\tacquire_us\trelease_us\ttotal_us")
for token_count in sorted(lease_medians, key=int):
    row = lease_medians[token_count]
    print(f"{token_count}\t{us(row['acquire_ns'])}\t{us(row['release_ns'])}\t{us(row['total_ns'])}")

print("\nCommands (median of 41, 2 warm-up rounds, rotated cohorts):")
print("cohort\tleases\twall_ms\tp10_ms\tp90_ms\tacquire_us\trelease_us\tlease_us\tshare_pct")
for key in ("sqlite-jobserver", "sqlite-no-jobserver", "link-jobserver", "link-no-jobserver"):
    row = medians[key]
    print(
        f"{key}\t{row['leases_each']}\t{ms(row['wall_ns'])}\t{ms(row['wall_p10'])}\t{ms(row['wall_p90'])}"
        f"\t{us(row['acquire_ns'])}\t{us(row['release_ns'])}\t{us(row['lease_ns'])}\t{row['share_pct']}"
    )

print("\nPaired wall difference, jobserver minus no-jobserver (same run index):")
for key in ("sqlite", "link"):
    row = pairs[key]
    print(f"{key}\tmedian_us={us(row['guardian_wall_ns_median'])}\tmin_us={us(row['min'])}\tmax_us={us(row['max'])}")

print("\nSerial controls (median of 5):")
for key in ("sqlite-lanes1", "link-lanes1"):
    row = medians[key]
    print(f"{key}\twall_ms={ms(row['wall_ns'])}\tp10_ms={ms(row['wall_p10'])}\tp90_ms={ms(row['wall_p90'])}")

print("\nReal make -j8 confirmation (median of 5, including make's own overhead):")
print("target\tleases\twall_ms\tlease_us")
by_target = {}
for target, row in makes:
    by_target.setdefault(target, []).append(row)
for target in sorted(by_target):
    group = by_target[target]
    walls = [int(r["wall_ns"]) for r in group]
    leases = [int(r["lease_ns"]) for r in group]
    print(f"{target}\t{group[0]['leases']}\t{ms(int(statistics.median(walls)))}\t{us(int(statistics.median(leases)))}")

link = medians["link-jobserver"]
pair = pairs["link"]
ceiling_ns = 0.75 * pair["guardian_wall_ns_median"]
print("\nSession-long ceiling on the four-lease link: 3 of 4 guardians saved")
print(f"ceiling_ms={ceiling_ns / 1e6:.3f}\tceiling_pct_of_jobserver_wall={100.0 * ceiling_ns / int(link['wall_ns']):.3f}")
print("Session-long ceiling on the one-lease -c: 0 (one guardian stays)")
