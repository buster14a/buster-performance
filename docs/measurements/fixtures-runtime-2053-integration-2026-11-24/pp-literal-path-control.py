"""Exercise a forged diagnostic path through the normal test command, without Clang."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

compiler = Path(sys.argv[1]).resolve()
with tempfile.TemporaryDirectory() as scratch:
    root = Path(scratch)
    for family in ("preprocessor", "preprocessor-kernels"):
        shutil.copytree(Path("tests") / family, root / family)
    header = root / "preprocessor/structure/header-diagnostic-percent.h"
    header.write_bytes(b'#line 1 "%d/structure.h"\n' + header.read_bytes())
    run = subprocess.run(
        [str(compiler), "test-preprocessor", "--part", "3/64", "--jobs", "1",
         "--fuzz", "0", "--fixtures", str(root)],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print(run.stdout.decode(), end="")
    sys.exit(run.returncode)
