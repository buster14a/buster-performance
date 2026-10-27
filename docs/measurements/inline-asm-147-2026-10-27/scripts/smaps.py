# gdb: the inferior's peak and current RSS, then each mapping's Rss, AnonHugePages and Size (KB) with its header.
import gdb
pid = gdb.selected_inferior().pid
for line in open('/proc/%d/status' % pid):
    if line.startswith('VmHWM') or line.startswith('VmRSS'):
        print(line.strip())
header = None
values = {}
for line in open('/proc/%d/smaps' % pid):
    parts = line.split()
    if len(parts) >= 5 and '-' in parts[0] and ':' not in parts[0]:
        header = ' '.join(parts[:2] + parts[5:])
        values = {}
    elif parts and parts[0].endswith(':') and len(parts) >= 2 and parts[1].isdigit():
        values[parts[0]] = int(parts[1])
        if parts[0] == 'AnonHugePages:' and values.get('Rss:', 0) > 0:
            print('%10d %10d %10d %s' % (values.get('Rss:', 0), values['AnonHugePages:'], values.get('Size:', 0), header))
