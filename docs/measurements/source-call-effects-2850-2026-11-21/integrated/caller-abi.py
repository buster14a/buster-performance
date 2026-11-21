import argparse
import csv
import hashlib
import os
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument("cc", type=Path)
p.add_argument("out", type=Path)
a = p.parse_args()
cc, d = a.cc.resolve(), a.out.resolve()
d.mkdir(parents=True, exist_ok=True)
cases = dict(
    interrupt=("extern void external(void); struct frame; __attribute__((interrupt)) void handler(struct frame *f) { external(); }"),
    saving=("extern int external(int); __attribute__((no_caller_saved_registers)) int call(void) { return external(1); }"),
    naked=("extern int external(int); __attribute__((naked)) int call(void) { return external(1); }"),
    preserve_all=("extern int external(int); __attribute__((preserve_all)) int call(void) { return external(1); }"),
    preserve_most=("extern int external(int); __attribute__((preserve_most)) int call(void) { return external(1); }"),
    ms_abi=("extern int external(int); __attribute__((ms_abi)) int call(void) { return external(1); }"),
    sysv_abi=("extern int external(int); __attribute__((sysv_abi)) int call(void) { return external(1); }"),
    musttail_valid=("extern int external(int); int call(int x) { [[clang::musttail]] return external(x); }"),
    musttail_invalid=("extern int external(int); long call(int x) { [[clang::musttail]] return external(x); }"),
    noinline=("extern int external(int); __attribute__((noinline)) int call(void) { return external(1); }"),
    inline=("extern int external(int); __attribute__((always_inline)) static inline int call(void) { return external(1); } int use(void){return call();}"),
    no_stack=("extern int external(int); __attribute__((no_stack_protector)) int call(void) { return external(1); }"),
    target=("extern int external(int); __attribute__((target(\"avx2\"))) int call(void) { return external(1); }"),
    hot=("extern int external(int); __attribute__((hot)) int call(void) { return external(1); }"),
    cold=("extern int external(int); __attribute__((cold)) int call(void) { return external(1); }"),
    saving_decl=("extern int external(int); __attribute__((no_caller_saved_registers)) int call(void); int call(void) { return external(1); }"),
    gate_bodies=("extern int external(int); __attribute__((target(\"no-avx2\"),flatten)) int no(void){return external(1);} int yes(void){return external(1);}"),
    asm_decl=("extern int external(int) __asm__(\"real_symbol\"); int call(void){return external(1);}"),
    weak_pragma=("extern int external(int);\n#pragma weak external\nint call(void){return external(1);}"),
    alias=("extern int external(int); int real(int x) { return external(x); } extern __typeof(real) local __attribute__((alias(\"real\"))); int call(void){return local(1);}"),
)
policies = dict(default=[], debug=["-g"], error=["-Werror=excessive-regsave"], general=["-mgeneral-regs-only", "-Werror=excessive-regsave"], debug_tier=["-g", "--tier1"], avx=["-mavx2"])
def sha(data):
    return hashlib.sha256(data).hexdigest()
with (d/"matrix.tsv").open("w") as report:
    w = csv.writer(report, delimiter="\t", lineterminator="\n")
    w.writerow("source policy base_exit compact_exit takes same_stderr same_stdout same_elf same_raw_marks original_sha candidate_sha".split())
    for name, body in cases.items():
        s = d/(name+".c")
        s.write_text(body+"\n")
        for pol, args in policies.items():
            vals = []
            for compact in [False, True]:
                obj = d/"tmp.o"
                decl = d/"marks"
                decl.unlink(missing_ok=True)
                obj.unlink(missing_ok=True)
                env = dict(os.environ, BUSTER_CALL_MARKS=str(decl), BUSTER_WINDOW_CALL_LOG="1")
                opt=[]
                if compact:
                    env["BUSTER_CALL_FORCE_DEBUG"]="1"
                    opt=["--node-window-calls"]
                r = subprocess.run([cc, "--lanes", "1", *opt, *args, "-c", s, "-o", obj], env=env, capture_output=True)
                lines=r.stderr.splitlines(keepends=True)
                diag=b"".join(i for i in lines if not i.startswith(b"plain-call:"))
                takes=sum(i.startswith(b"plain-call:") for i in lines)
                vals.append((r.returncode,diag,r.stdout,sha(obj.read_bytes()) if obj.exists() else "",sha(decl.read_bytes()) if decl.exists() else "",takes))
            old,new=vals
            if old[:5]!=new[:5]:
                (d/(name+"-"+pol+"-normal.err")).write_bytes(old[1])
                (d/(name+"-"+pol+"-compacted.err")).write_bytes(new[1])
            w.writerow([name,pol,old[0],new[0],new[-1],*[int(x==y) for x,y in zip(old[1:5],new[1:5])],old[3],new[3]])
