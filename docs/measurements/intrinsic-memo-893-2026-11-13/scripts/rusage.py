# rusage.py LIST OUTPUT ROUNDS NAME PATH [NAME PATH]...: each build compiles each file of LIST (-c, to OUTPUT) as its
# own process, ROUNDS times, the builds' order rotated each round; prints each build's mean user and system time and
# minor faults per process, from wait4's rusage.
import os, sys
files = [line.strip() for line in open(sys.argv[1]) if line.strip()]
output = sys.argv[2]
rounds = int(sys.argv[3])
names = sys.argv[4::2]
paths = dict(zip(sys.argv[4::2], sys.argv[5::2]))
totals = {name: [0.0, 0.0, 0, 0, 0] for name in names}
for r in range(rounds):
    order = names[r % len(names):] + names[:r % len(names)]
    for name in order:
        for path in files:
            pid = os.fork()
            if pid == 0:
                null = os.open("/dev/null", os.O_WRONLY)
                os.dup2(null, 1)
                os.dup2(null, 2)
                os.execv(paths[name], [paths[name], "-c", path, "-o", output])
            _, status, usage = os.wait4(pid, 0)
            total = totals[name]
            total[0] += usage.ru_utime
            total[1] += usage.ru_stime
            total[2] += usage.ru_minflt
            total[3] += 1
            total[4] += status != 0
for name in names:
    total = totals[name]
    print(f"{name}: {total[3]} processes ({total[4]} failed), user {total[0] / total[3] * 1e3:.4f} ms, system {total[1] / total[3] * 1e3:.4f} ms, "
          f"minor faults {total[2] / total[3]:.2f} per process")
