"""Measure fresh processes at the matched or ordinary checker boundary, or capture their live RSS maps."""
import argparse
import csv
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time
from statistics import mean,median
from reproduce import frozen_args, sha, SQLITE_SHA

envs = {"source":{"BUSTER_CHECK_BODY_SOURCE_ONLY":"1","BUSTER_CHECK_BODY_ADMIT_ALL":"1"},
        "dense":{"BUSTER_BODY_DENSE_BOUNDARY":"1"},"ordinary":{"BUSTER_BODY_WHOLE_CHECK_ONLY":"1"}}
def measure(binary, flags, mode, dst, obj, maps=False):
    env = {k:v for k,v in os.environ.items() if not k.startswith(("BUSTER_BODY_","BUSTER_CHECK_BODY_","BUSTER_CHECK_SOURCE_DECLARATIONS"))}
    env.update(BUSTER_BODY_DISCARD_RESULT="1",BUSTER_CHECK_SOURCE_DECLARATIONS="1",**envs[mode])
    if maps:
        env["BUSTER_BODY_MEMORY_AUDIT"] = "1"
    with dst.with_suffix(".stderr").open("wb") as e:
        start=time.monotonic_ns()
        proc=subprocess.Popen([binary,"--lanes","1","-c",*flags,"-o",obj],env=env,stdout=subprocess.DEVNULL,stderr=e)
        pid,st,r=os.wait4(proc.pid,0)
        ms=(time.monotonic_ns()-start)/1e6
        proc.returncode=os.waitstatus_to_exitcode(st)
    data={"wall_ms":ms,"user_ms":r.ru_utime*1000,"system_ms":r.ru_stime*1000,"peak_kib":r.ru_maxrss,
          "minor_faults":r.ru_minflt,"major_faults":r.ru_majflt,"status":proc.returncode}
    dst.with_suffix(".json").write_text(json.dumps(data)+"\n")
    if proc.returncode:
        raise ValueError(f"{mode} failed, see {dst.with_suffix('.stderr')}")
    return data

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for arg in ("compiler","sqlite","self-source","output"):
        p.add_argument("--"+arg,required=True,type=Path)
    p.add_argument("--rounds",type=int,default=5)
    p.add_argument("--maps",action="store_true")
    a=p.parse_args(); assert sha(a.sqlite)==SQLITE_SHA
    folders=frozen_args(a.sqlite.resolve(),a.self_source.resolve());out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
    summaries=[];rss=[]
    for g,flags in folders.items():
        dest=out/g;dest.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory() as tmp:
            obj=Path(tmp)/"unit.o"
            if a.maps:
                for m in ("dense","source"):
                    stem=dest/("mapping-"+m+".sample")
                    measure(a.compiler.resolve(),flags,m,stem,obj,True)
                    buckets={}
                    for l in stem.with_suffix(".stderr").read_text().splitlines():
                        if l.startswith("body-mapping\t"):
                            _,phase,kind,r,h=l.split("\t");pair=(int(r.split("=")[1]),int(h.split("=")[1]))
                            for key in (kind,"TOTAL"):
                                v=buckets.setdefault((phase,key),[0,0]);v[0]+=pair[0];v[1]+=pair[1]
                    rss.extend((g,m,phase,key,*v) for (phase,key),v in sorted(buckets.items()))
            for baseline in ("ordinary","dense"):
                d={}
                for rnd in range(1,a.rounds+1):
                    order=[baseline,"source","source",baseline]
                    if rnd%2==0:
                        order=["source",baseline,baseline,"source"]
                    for i,m in enumerate(order):
                        result=measure(a.compiler.resolve(),flags,m,dest/f"{baseline}-{rnd}-{i}-{m}.sample",obj)
                        for k,val in result.items():
                            d.setdefault((m,rnd,k),[]).append(val)
                for k in ("wall_ms","user_ms","system_ms","peak_kib","minor_faults","major_faults"):
                    x=[mean(d[baseline,r,k]) for r in range(1,a.rounds+1)]
                    y=[mean(d["source",r,k]) for r in range(1,a.rounds+1)]
                    if x:
                        ds=[b-a for a,b in zip(x,y)]
                        summaries.append((g,baseline,k,median(x),median(y),median(ds),min(ds),max(ds),sum(v<0 for v in ds),len(ds)))
    for name,head,rows in (("mapping",("input","mode","phase","area","rss-kib","anon-huge-kib"),rss),
                           ("paired",("input","control","metric","median-control","median-source","paired-median","minimum","maximum","lower","rounds"),summaries)):
        if rows:
            with (out/(name+".tsv")).open("w") as f:
                w=csv.writer(f,delimiter="\t",lineterminator="\n");w.writerow(head);w.writerows(rows)

if __name__=="__main__":
    main()
