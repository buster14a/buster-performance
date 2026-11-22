"""Regression fixtures for the serial header-image census. Run with python3 -I test-images.py WALK CLANG."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

walk, clang = [str(Path(tool).resolve()) for tool in sys.argv[1:]]
reporter = Path(__file__).with_name("images.py")


def run(root, *args, env=None):
    return subprocess.run(args, cwd=root, env=env, capture_output=True, check=True, text=True).stdout


def check(root):
    (root / "left").mkdir()
    (root / "right").mkdir()
    (root / "left/identity.h").write_text('const char id[] = __FILE__;\n')
    os.link(root / "left/identity.h", root / "right/identity.h")
    (root / "inner.h").write_text('#pragma pop_macro("MODE")\nint inner = MODE;\n')
    (root / "outer.h").write_text('#pragma pop_macro("MODE")\nint outer = MODE;\n')
    (root / "line.h").write_text('#line NUMBER "presumed.c"\nint line = __LINE__;\n')
    (root / "presumed.h").write_text('#line 80 FILE_NAME\nconst char path[] = __FILE__;\n')
    (root / "save.h").write_text('#pragma push_macro("MODE")\n')
    (root / "plain.h").write_text('int plain = CONFIG;\n')
    (root / "order1.h").write_text('#define A 1\n#define B 2\n')
    (root / "order2.h").write_text('#define B 2\n#define A 1\n')
    for n, side in enumerate(("left", "right"), start=1):
        (root / f"{side}.c").write_text(
            f'#include "{side}/identity.h"\n#define MODE {n + 6}\n#include "save.h"\n'
            f'#undef MODE\n#define MODE {n + 8}\n#pragma push_macro("MODE")\n#undef MODE\n'
            '#include "inner.h"\n#include "outer.h"\n'
            f'#define NUMBER {n + 100}\n#include "line.h"\n'
            f'#define FILE_NAME "unit{n}.c"\n#include "presumed.h"\n'
            f'#define CONFIG shared_name\n// different trailing bytes {n}\n#include "plain.h"\n'
            f'#include "order{n}.h"\n'
        )
    args = ["-std=c99", "-nostdinc", "left.c", "right.c"]
    trace = root / "rows.tsv"
    source = run(root, walk, *args, env={**os.environ, "BUSTER_PP_IMAGE_CENSUS_FILE": str(trace)})
    oracle = run(root, clang, "-E", "-P", *args)
    assert source and source.splitlines() == [line for line in oracle.splitlines() if line]
    lines = trace.read_text().splitlines()
    assert lines[0] == "V\t2"
    rows = [line.split("\t") for line in lines if line.startswith("S\t")]

    def header(path):
        stat = (root / path).stat()
        return [row for row in rows if row[3] == f"{stat.st_dev}:{stat.st_ino}" and int(row[2]) > 1]

    for name in ("left/identity.h", "inner.h", "outer.h", "line.h", "presumed.h"):
        first, second = header(name)
        assert first[5] == second[5] and first[6] != second[6], name
        assert int(first[7]) and int(second[7]), name
        if name in ("left/identity.h", "inner.h", "outer.h"):
            assert sorted(first[11].split(",")) == sorted(second[11].split(",")), name
        if name in ("inner.h", "outer.h"):
            assert first[8] == second[8] == "1" and first[9] != second[9], name

    first, second = header("save.h")
    assert first[5:7] == second[5:7] and int(first[7]) and int(second[7])
    first, second = header("plain.h")
    assert first[4:] == second[4:] and first[7] == "0"
    forward, = header("order1.h")
    reverse, = header("order2.h")
    assert forward[5:7] == reverse[5:7] and forward[8] == reverse[8] == "2"
    assert forward[9] != reverse[9]
    summary = run(root, sys.executable, "-I", str(reporter), str(trace))
    # Each of the other repeated headers reads context or changes it.
    assert f"eligible repeat visits 1 of 16, {first[5]} of " in summary, summary

    # Two apparently safe visits precede a flagged third one. A late differing output similarly poisons a whole key.
    # All three have the same number of tokens. Only the plain key's second visit is eligible.
    trace.write_text("V\t2\n" + "".join(
        f"{'R' if i == 3 else 'U'}\t{i}\tu{1 if i == 3 else i}.c\n" + "".join(
            f"S\t{i}\t2\t1:{key}\t0\t5\t{output}\t{flags}\t0\t8\t0\t\n"
            for key, output, flags in [(1, 7, int(i == 3)), (2, 6 if i == 3 else 7, 0), (3, 7, 0)]
            if key != 3 or i != 3) + f"E\t{i}\t1\n"
        for i in (1, 2, 3)))
    summary = run(root, sys.executable, "-I", str(reporter), str(trace))
    assert "eligible repeat visits 1 of 8, 5 of 40 tokens" in summary, summary
    assert "units 2," in summary and "preprocessing walks 3, including 1 replays" in summary, summary


with tempfile.TemporaryDirectory() as tmp:
    check(Path(tmp))
print("Header-image census fixtures passed")
