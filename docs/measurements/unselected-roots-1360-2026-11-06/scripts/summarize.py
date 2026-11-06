#!/usr/bin/env python3
# The medians, with their range, of results.tsv per workload and build: wall time, the compiler's own total and
# check-program stage (--time-stages; for the Lua rows the sums over the 34 files), user instructions and cycles.
import csv, statistics, sys
rows = list(csv.DictReader(open(sys.argv[1]), delimiter='\t'))
order, data = [], {}
for r in rows:
    if r['status'] != '0':
        sys.exit('nonzero status: %r' % r)
    if r['workload'] not in order:
        order.append(r['workload'])
    data.setdefault((r['workload'], r['variant']), []).append(r)
def values(key, field):
    return [float(x[field]) for x in data[key]]
def cell(key, field, scale=1.0, digits=1):
    v = [x / scale for x in values(key, field)]
    return f"{statistics.median(v):,.{digits}f} [{min(v):,.{digits}f}–{max(v):,.{digits}f}]"
print('| workload | runs base/head | wall ms, base | wall ms, head | total ms, base | total ms, head | head/base total | check-program ms, base | check-program ms, head | user instructions, base | user instructions, head | user cycles, base | user cycles, head |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for w in order:
    b, h = (w, 'base'), (w, 'head')
    ratio = statistics.median(values(h, 'total_ms')) / statistics.median(values(b, 'total_ms'))
    print(f"| {w} | {len(data[b])}/{len(data[h])} | {cell(b,'wall_ms')} | {cell(h,'wall_ms')} | {cell(b,'total_ms')} | {cell(h,'total_ms')} | {ratio:.3f} | "
          f"{cell(b,'check_program_ms')} | {cell(h,'check_program_ms')} | {statistics.median(values(b,'instructions_u'))/1e6:,.1f} M | "
          f"{statistics.median(values(h,'instructions_u'))/1e6:,.1f} M | {statistics.median(values(b,'cycles_u'))/1e6:,.1f} M | {statistics.median(values(h,'cycles_u'))/1e6:,.1f} M |")
