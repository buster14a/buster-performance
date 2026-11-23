import glob, collections, statistics, sys, os
os.chdir(sys.argv[1])
rows = {}
for f in sorted(glob.glob('stages-*.txt')):
    for line in open(f):
        p = line.rstrip('\n').split('\t')
        if len(p) > 2 and (p[0] in ('time-stage', 'time-check') or (p[0] == 'time-process' and p[1] in ('peak-rss-kb', 'minor-faults', 'history-replays', 'user-ms', 'system-ms'))):
            try:
                v = float(p[2])
            except ValueError:
                continue
            rows.setdefault(p[0] + ' ' + p[1], []).append(v)
for k, v in rows.items():
    print(f'{k:40s} median {statistics.median(v):10.3f}  min {min(v):10.3f}  max {max(v):10.3f}  n {len(v)}')
