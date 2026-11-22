from pathlib import Path
import json,os,subprocess,sys,time
dest=Path(sys.argv[1]); cmd=sys.argv[2:]
began=time.monotonic_ns()
proc=subprocess.Popen(cmd)
pid,st,r=os.wait4(proc.pid,0)
proc.returncode=os.waitstatus_to_exitcode(st)
elapsed=time.monotonic_ns()-began
dest.write_text(json.dumps({'wall_ms':elapsed/1e6,'user_ms':r.ru_utime*1000,'system_ms':r.ru_stime*1000,'peak_kib':r.ru_maxrss,'minor_faults':r.ru_minflt,'major_faults':r.ru_majflt,'status':proc.returncode})+'\n')
sys.exit(proc.returncode)
