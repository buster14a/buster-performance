"""Verify and archive the per-effect record stream produced by effect-observer.patch."""
import argparse
from collections import Counter
import csv
from pathlib import Path
import tempfile
from reproduce import compressed, frozen_args, run, sha, SQLITE_SHA

KINDS = ["graph-x86-call","report","store","varargs","misc","floating","query","atomic","vector","x86","bit-cast",
         "overload","overload-address","const-warning-request","warning-event"]

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ("compiler","sqlite","self-source","output"):
        p.add_argument("--"+name,type=Path,required=True)
    a=p.parse_args();dst=a.output.resolve();dst.mkdir(parents=True,exist_ok=True)
    if sha(a.sqlite)!=SQLITE_SHA:
        raise ValueError("SQLite source differs")
    inputs=frozen_args(a.sqlite.resolve(),a.self_source.resolve());counts=[]
    for name,flags in inputs.items():
        sub=dst/name;sub.mkdir(exist_ok=True); rows=[]
        with tempfile.TemporaryDirectory() as tmp:
            for mode in ('source','whole'):
                key={"source":{"BUSTER_CHECK_BODY_ADMIT_ALL":"1","BUSTER_CHECK_BODY_SOURCE_ONLY":"1"},
                     "whole":{"BUSTER_CHECK_BODY_WHOLE_FINGERPRINT":"1"}}[mode]
                r,obj=run(a.compiler.resolve(),flags,Path(tmp)/"unit.o",{**key,"BUSTER_BODY_EFFECT_RECEIPTS":"1","BUSTER_CHECK_SOURCE_DECLARATIONS":"1"})
                assert bool(obj)==(mode=="whole")
                data=[line for line in r.stderr.splitlines() if line.startswith(b"body-effect\t")]
                rows.append(data);compressed(sub/(mode+".tsv.xz"),b"\n".join(data)+b"\n")
        if rows[0]!=rows[1]:
            raise ValueError(f"{name} per-effect records differ")
        hist=Counter(l.split(b'\t')[2].decode() for l in rows[0])
        if any(k not in KINDS for k in hist):
            raise ValueError("unknown effect kind")
        counts.extend((name,k,hist[k],hist[k]) for k in KINDS)
        print(name,len(rows[0]),flush=True)
    with (dst/"counts.tsv").open("w") as f:
        w=csv.writer(f,delimiter="\t",lineterminator="\n")
        w.writerow(("input","kind","source-records","whole-records"));w.writerows(counts)
    (dst/"compiler.sha256").write_text(sha(a.compiler.resolve())+"\n")

if __name__=="__main__":
    main()
