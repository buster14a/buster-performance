#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
import argparse, hashlib, os, subprocess, time
from pathlib import Path


def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 18), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--compiler", type=Path, required=True)
    p.add_argument("--data", type=Path, required=True)
    p.add_argument("--out", type=Path, required=True)
    p.add_argument("--mode", default="0,0")
    p.add_argument("--case", nargs="+", default=["sqlite", "lua", "musl"])
    p.add_argument("--plain", action="store_true")
    p.add_argument("--census", action="store_true")
    p.add_argument("--option", action="append", default=[])
    p.add_argument("--dump", action="store_true")
    p.add_argument("--lanes", default="1")
    p.add_argument("--use-census", action="store_true")
    p.add_argument(
        "--common-object-dir",
        type=Path,
        help="shared compiler working directory when debug paths are compared",
    )
    a = p.parse_args()
    d = a.data.resolve()
    binary = a.compiler.resolve()
    for case in a.case:
        top = (a.out / case).resolve()
        top.mkdir(parents=True, exist_ok=True)
        obj = top / "objects"
        obj.mkdir(exist_ok=False)
        run_dir = a.common_object_dir.resolve() if a.common_object_dir else obj
        if run_dir != obj:
            run_dir.mkdir(parents=True, exist_ok=True)
            if list(run_dir.iterdir()):
                raise ValueError(f"comparison directory must be empty: {run_dir}")
        flags = (d / f"{case}.flags").read_text().splitlines()
        files = (d / f"{case}.files").read_text().splitlines()
        switches = a.mode.split(",")
        vals, events = switches[:2]
        env = {
            **os.environ,
            "BUSTER_RESEARCH_VALUES": vals,
            "BUSTER_RESEARCH_EVENTS": events,
            "BUSTER_RESEARCH_USES": switches[2] if len(switches) > 2 else "0",
            "SOURCE_DATE_EPOCH": "1700000000",
            "BUSTER_EXIT_HELPER": "0",
        }
        if a.census:
            env["BUSTER_RESEARCH_CENSUS"] = "1"
        if a.use_census:
            env["BUSTER_RESEARCH_USE_CENSUS"] = "1"
        if a.dump:
            env["BUSTER_RESEARCH_IR"] = str(top / "ir.txt")
        start = time.monotonic()
        with (top / "stderr").open("wb") as err, (top / "stdout").open("wb") as out:
            run = subprocess.run(
                [
                    str(binary),
                    "--lanes",
                    a.lanes,
                    *([] if a.plain else ["--tier1"]),
                    "-c",
                    *a.option,
                    *flags,
                    *files,
                ],
                cwd=run_dir,
                env=env,
                stderr=err,
                stdout=out,
            )
        print(
            case, a.mode, run.returncode, round(time.monotonic() - start, 2), flush=True
        )
        if run.returncode:
            raise SystemExit(1)
        if run_dir != obj:
            for result in run_dir.glob("*.o"):
                result.rename(obj / result.name)
        rows = sorted(obj.glob("*.o"))
        assert len(rows) == len(files), (len(rows), len(files))
        (top / "objects.sha256").write_text(
            "".join(f"{digest(o)}  {o.name}\n" for o in rows)
        )
        data = (top / "stderr").read_bytes().splitlines(keepends=True)
        (top / "diagnostics").write_bytes(
            b"".join(
                x for x in data if not x.startswith((b"SSA-CENSUS ", b"SSA-USES "))
            )
        )
        if a.use_census:
            (top / "uses").write_bytes(
                b"".join(x[9:] for x in data if x.startswith(b"SSA-USES "))
            )
        if a.census:
            (top / "census").write_bytes(
                b"".join(x[11:] for x in data if x.startswith(b"SSA-CENSUS "))
            )


if __name__ == "__main__":
    main()
