import sys, collections
# dbg2546 slice PIECE INDEX OFFSET SIZE lines: what a link hashes (reads) of the snapshot, by piece.
slices = []
for line in open(sys.argv[1]):
    f = line.split()
    if len(f) == 6 and f[0] == 'dbg2546':
        slices.append((int(f[2]), int(f[3]), int(f[4]), int(f[5])))
pieces = set(s[0] for s in slices)
total = sum(s[3] for s in slices)
pages = set()
for (_, _, off, size) in slices:
    if size:
        for p in range(off >> 12, ((off + size - 1) >> 12) + 1):
            pages.add(p)
windows = set(p >> 4 for p in pages)
# coalesced page ranges
ps = sorted(pages)
ranges = []
for p in ps:
    if ranges and ranges[-1][1] + 1 >= p:
        ranges[-1][1] = p
    else:
        ranges.append([p, p])
bycol = collections.Counter(); bycolpages = collections.defaultdict(set)
for (_, idx, off, size) in slices:
    bycol[idx] += size
    if size:
        for p in range(off >> 12, ((off + size - 1) >> 12) + 1): bycolpages[idx].add(p)
print('pieces %d slices %d bytes read %d (%.1f KB)' % (len(pieces), len(slices), total, total / 1024))
print('distinct 4K pages %d (%.1f KB), distinct 64K windows %d (%.1f KB), coalesced page ranges %d' % (len(pages), len(pages) * 4, len(windows), len(windows) * 64, len(ranges)))
for idx in sorted(bycol): print('  slice %2d: %8d bytes, %4d pages' % (idx, bycol[idx], len(bycolpages[idx])))
