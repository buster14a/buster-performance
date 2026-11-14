#!/usr/bin/env python3
# #1444, the checker's section: a census's faults in the executable's code, by region, with .text's split into the
# checker's section (.text.buster_checker of the checker's unit, by its functions' names) and the rest.
#   checker-faults.py SECTION CENSUS-DIRECTORY CONTROL...
# SECTION: `readelf -sW` of the checker unit's joined object (native.o, gzipped), whose FUNC symbols in section 2 are the
# section's; CENSUS-DIRECTORY: census.sh's results (faults-CONTROL.txt.gz, attribution-CONTROL.txt, sections.txt).
import gzip, sys
names = set()
for line in gzip.open(sys.argv[1], "rt"):
    p = line.split()
    if len(p) >= 8 and p[3] == "FUNC" and p[6] == "2":
        names.add(p[7].replace(".buster_split", ""))
sections = {}
for line in open(sys.argv[2] + "/sections.txt"):
    p = line.split()
    if len(p) == 3:
        sections[p[0]] = (int(p[1], 16), int(p[2], 16))
text = sections[".text"]
start = sections.get(".text.buster_start", (0, 0))
for control in sys.argv[3:]:
    total = 0
    counts = {"checker": 0, "text": 0, "start": 0}
    for line in open(sys.argv[2] + "/attribution-%s.txt" % control):
        if line.startswith("faults: "):
            total = int(line.split()[1])
    for line in gzip.open(sys.argv[2] + "/faults-%s.txt.gz" % control, "rt"):
        p = line.split()
        if len(p) < 2:
            continue
        try:
            address = int(p[0], 16)
        except ValueError:
            continue
        if text[0] <= address < text[0] + text[1]:
            counts["checker" if p[1].replace(".buster_split", "") in names else "text"] += 1
        elif start[0] <= address < start[0] + start[1]:
            counts["start"] += 1
    print("%-10s faults %4d  code %3d: checker's section %3d, other .text %3d, .text.buster_start %3d" % (control, total, counts["checker"] + counts["text"] + counts["start"], counts["checker"], counts["text"], counts["start"]))
