import sys,re
# sysfilter.py IN OUT: the system headers' lines of a preprocessed unit, with every line marker, in order.
out=open(sys.argv[2],'w'); sysflag=False
for line in open(sys.argv[1], errors='replace'):
    if line.startswith('# '):
        m=re.match(r'# (\d+) "([^"]*)"(.*)', line)
        if m:
            sysflag='3' in m.group(3).split()
            out.write(line); continue
    if sysflag: out.write(line)
