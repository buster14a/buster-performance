from pathlib import Path
import argparse, ast, csv, hashlib, itertools, json, os, re, subprocess
parser=argparse.ArgumentParser()
parser.add_argument("ordinary", type=Path)
parser.add_argument("source", type=Path)
parser.add_argument("output", type=Path)
parser.add_argument("fixtures", type=Path)
args=parser.parse_args()
options={"wall":["-Wall"],"extra":["-Wall","-Wextra"],"fatal-local":["-Wall","-Werror=unused-variable"],"quiet-local":["-Wall","-Wno-unused-variable"],"fatal-parameter":["-Wall","-Werror=unused-parameter"]}
modes={"syntax":["-fsyntax-only"],"scalar":["-fsyntax-only","--scalar"],"one":["--deferred-bodies","--lanes","1","-c"],"two":["--deferred-bodies","--lanes","2","-c"],"three":["--deferred-bodies","--lanes","3","-c"]}
out=args.output.resolve();out.mkdir(exist_ok=True)
fixtures=json.loads(args.fixtures.read_text());clean={k:v for k,v in os.environ.items() if not k.startswith("BUSTER_CONTROL_")};digest=lambda b:hashlib.sha256(b).hexdigest()
with (out/"comparisons.tsv").open("w",buffering=1) as target:
 table=csv.writer(target,delimiter="\t")
 table.writerow(("fixture","language","policy","mode","same-exit","same-object","same-stdout","same-stderr","ordinary-exit","ordinary-stderr-sha","source-stderr-sha"))
 for index, text in enumerate(fixtures):
  path=out/f"repair-{index}.c";path.write_text(text)
  for std,policy,mode in itertools.product(("gnu17","gnu23"),options,modes):
   results=[]
   for exe,env in ((args.ordinary,clean),(args.source,clean|{"BUSTER_CONTROL_SOURCE_NATIVE":"1"})):
    obj=out/"active.o";obj.unlink(missing_ok=True)
    run=subprocess.run([exe.resolve(),"-std="+std,"-fno-caret-diagnostics",*options[policy],*modes[mode],path,"-o",obj],env=env,stdin=subprocess.DEVNULL,capture_output=True,timeout=10)
    results.append((run.returncode,obj.read_bytes() if obj.exists() else None,run.stdout,run.stderr))
   equal=[x==y for x,y in zip(*results)]
   table.writerow((index,std,policy,mode,*(int(x) for x in equal),results[0][0],digest(results[0][3]),digest(results[1][3])))
   if not all(equal):
    for name,r in zip(("ordinary","source"),results):
     (out/f"{index}-{std}-{policy}-{mode}-{name}.stderr").write_bytes(r[3])
