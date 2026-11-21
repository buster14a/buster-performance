"""Check one batch of source files against the ordinary compiler in each warning policy."""
import csv
import hashlib
from pathlib import Path
import re
import subprocess
import sys

exe, response, offset, count, workdir = sys.argv[1:]
args = [x.decode() for x in Path(response).read_bytes().split(b"\0") if x]
sources = [x for x in args if x.endswith(".c")]
common = [x for x in args if not x.endswith(".c")]
output = Path(workdir) / "unit.o"
modes = {"default": [], "regular": ["--node-window"], "assignments": ["--node-window-assignments"]}
writer = csv.writer(sys.stdout, delimiter="\t", lineterminator="\n")
digest = lambda x: hashlib.sha256(x).hexdigest()
for source in sources[int(offset):int(offset)+int(count)]:
    tokens = None
    for label, policy in [("default", []), ("Wall-Wextra", ["-Wall","-Wextra"])]:
        reference = None
        for mode, flags in modes.items():
            output.unlink(missing_ok=True)
            cmd = [exe,"--lanes","1",*flags,*policy,"-c",*common,source,"-o",str(output)]
            process = subprocess.run(cmd,capture_output=True)
            obj = output.read_bytes() if output.exists() else b""
            cell = (process.returncode,len(obj),digest(obj),len(process.stdout),digest(process.stdout),len(process.stderr),digest(process.stderr))
            if reference is None:
                reference = cell
            assert cell == reference and process.returncode == 0 and obj, (source,label,mode,cell,reference)
            if label == "default":
                output.unlink()
                audited = subprocess.run([exe,"--time-stages",*cmd[1:]],capture_output=True)
                assert audited.returncode == process.returncode and audited.stdout == process.stdout and digest(output.read_bytes()) == cell[2]
                actual = int(re.search(rb"^time-process\ttokens\t(\d+)$",audited.stderr,re.M)[1])
                if tokens is None: tokens = actual
                assert actual == tokens
                captured = re.search(rb"^node-window: taken=(\d+) ordinary-nodes-replaced=(\d+) summary-nodes=(\d+) graph-nodes=(\d+)",audited.stderr,re.M)
                adm = [int(x) for x in captured.groups()] if captured else [0,0,0,""]
            else:
                adm = ["","","",""]
            writer.writerow([Path(source).stem+".o",label,mode,tokens,*cell,*adm])
