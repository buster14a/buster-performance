"""Compile paired native objects, pass both to the system linker and execute each fixture."""
import argparse
import csv
import hashlib
import os
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("ordinary", type=Path)
parser.add_argument("candidate", type=Path)
parser.add_argument("fixtures", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()
dst = args.output.resolve()
dst.mkdir(exist_ok=True, parents=True)
environment = {k:v for k,v in os.environ.items() if not k.startswith(("BUSTER_SOURCE_", "BUSTER_OBJECT_", "BUSTER_CONTROL_"))}
configs = {
    "ordinary": (args.ordinary.resolve(), environment),
    "direct": (args.candidate.resolve(), environment | {k:"1" for k in (
       "BUSTER_SOURCE_ROOT_CURSOR", "BUSTER_SOURCE_CONTROL_MASKS", "BUSTER_SOURCE_DIRTY_DIAGNOSTICS",
       "BUSTER_SOURCE_WARNING_INDEX", "BUSTER_SOURCE_CLOSE_CONTEXTS", "BUSTER_SOURCE_CLASS_CONSUMER",
       "BUSTER_SOURCE_BORROW_CHILDREN", "BUSTER_SOURCE_FIRST_NODE", "BUSTER_CONTROL_EARLY_RELEASE",
       "BUSTER_CONTROL_EARLY_NATIVE", "BUSTER_SOURCE_WRITE_COLUMNS", "BUSTER_SOURCE_FILE_DATA",
       "BUSTER_SOURCE_GROW_GRAPH", "BUSTER_SOURCE_RETIRE_LISTS", "BUSTER_CONTROL_SOURCE_NATIVE",
       "BUSTER_CONTROL_OBJECT_FIELDS", "BUSTER_OBJECT_TEXT_STREAM", "BUSTER_OBJECT_TEXT_RUNS",
       "BUSTER_OBJECT_EARLY_RELOCATIONS", "BUSTER_OBJECT_DATA_SPANS")}),
}
entries = {
 "comdat": "int external(void){return 37;}extern int use(void);int main(void){return use()!=37;}",
 "tlsforms": "__thread int external=17;extern __thread int visible;extern int f(void);extern int *g(void);int main(void){visible=29;*g()=11;return f()!=57;}",
 "signed-addends": "char a[64],b[64];extern char *p[];int main(void){return (unsigned long)p[0]!=(unsigned long)a+17 || (unsigned long)p[1]!=(unsigned long)a-41 || (unsigned long)p[2]!=(unsigned long)b+0x100000010UL || (unsigned long)p[3]!=(unsigned long)b-0x100000020UL;}",
 "large-mixed": "extern int f(void);int main(void){return f()!='b';}",
}
with (dst/"checks.tsv").open("w",newline="") as stream:
 writer=csv.writer(stream,delimiter="\t");writer.writerow(("fixture","arm","source-object-sha256","linked-executable-sha256","exit"))
 for label,driver in entries.items():
  unit=(args.fixtures/(label+".c")).resolve();main=dst/(label+"-driver.c");main.write_text(driver+"\n")
  first=None
  for arm,(cc,env) in configs.items():
   obj=dst/(label+"-"+arm+".o");exe=dst/(label+"-"+arm)
   subprocess.run([cc,"--lanes","1","-nostdinc","-c",unit,"-o",obj],env=env,check=True)
   subprocess.run(["cc","-no-pie","-o",exe,obj,main],check=True)
   run=subprocess.run([exe],check=True,capture_output=True)
   observed=(hashlib.sha256(obj.read_bytes()).hexdigest(),hashlib.sha256(exe.read_bytes()).hexdigest(),run.returncode,run.stdout,run.stderr)
   if arm=="ordinary":first=observed
   else: assert first==observed,(label,first,observed)
   writer.writerow((label,arm,*observed[:3]))
