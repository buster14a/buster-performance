import argparse,csv,hashlib,os,re,subprocess
from pathlib import Path
parser=argparse.ArgumentParser()
parser.add_argument("compiler",type=Path);parser.add_argument("ordinary",type=Path);parser.add_argument("out",type=Path)
args=parser.parse_args();d=args.out.resolve();d.mkdir(exist_ok=True)
root=d/"inputs";root.mkdir(exist_ok=True)
sources=[]
for n in range(8):
    p=root/f"part{n}.c";p.write_text(f"int f{n}(int x){{return x+{n+1};}}\n");sources.append(p)
clean={k:v for k,v in os.environ.items() if not k.startswith("BUSTER_CONTROL_")}
def run(exe, dest, lanes, env):
    dest.mkdir(exist_ok=True)
    for p in dest.glob("*.o"):p.unlink()
    r=subprocess.run([exe.resolve(),"--lanes",str(lanes),"-nostdinc","-c",*sources],cwd=dest,env=env,stdin=subprocess.DEVNULL,capture_output=True)
    return r, {p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in dest.glob("*.o")}
with (d/"sampling.tsv").open("w",buffering=1) as f:
    w=csv.writer(f,delimiter="\t");w.writerow(("lanes","max","stride","expected","selected","audited-units","same-objects","same-status","same-stdout"))
    for lanes in (1,2,4):
        ordinary,objects=run(args.ordinary,d/"ordinary",lanes,clean)
        for maximum,stride in ((0,1),(1,1),(4,1),(7,2),(8,3),(8,0)):
            expected=sum(stride!=0 and ordinal%stride==0 and ordinal<maximum for ordinal in range(8))
            source,results=run(args.compiler,d/"source",lanes,clean|{"BUSTER_CONTROL_SOURCE_NATIVE":"1","BUSTER_CONTROL_SOURCE_AUDIT":"1","BUSTER_CONTROL_NATIVE_MAX":str(maximum),"BUSTER_CONTROL_NATIVE_STRIDE":str(stride)})
            owned=[int(n) for n in re.findall(rb"control-source-summary\tbodies=1\tselected=(\d+)",source.stderr)]
            w.writerow((lanes,maximum,stride,expected,sum(owned),len(owned),int(objects==results),int(ordinary.returncode==source.returncode),int(ordinary.stdout==source.stdout)))
