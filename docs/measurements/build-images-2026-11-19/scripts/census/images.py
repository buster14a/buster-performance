# Header images' census from the experiment patch's lines (BUSTER_PP_IMAGE_CENSUS_FILE).
# Usage: python3 -I images.py CENSUS.tsv
import sys, collections, statistics
segs = []
units = 0
# Version 2 IDs are valid within exactly one process. Keep old traces readable as historical estimates.
verified = False
active_walk = None
walks = 0
for number, line in enumerate(open(sys.argv[1])):
    if line == 'V\t2\n':
        if number != 0:
            raise ValueError("cannot combine dictionaries from separate census runs")
        verified = True
        continue
    f = line.rstrip('\n').split('\t')
    if f[0] == 'U' or (verified and f[0] == 'R'):
        units += f[0] == 'U'
        walks += 1
        if verified:
            if active_walk is not None or f[1] != str(walks):
                raise ValueError(f"overlapping or out-of-order walk at line {number + 1}")
            active_walk = f[1]
        continue
    if verified and f[0] == 'E':
        if f[1:] != [active_walk, '1']:
            raise ValueError(f"unsuccessful or unmatched end of walk at line {number + 1}")
        active_walk = None
        continue
    if f[0] != 'S':
        raise ValueError(f'unrecognized census record at line {number + 1}')
    unit, depth, ident, start, out_count, out_hash, dynamic, eff_count, eff_hash, obs_count = f[1:11]
    if verified and unit != active_walk:
        raise ValueError(f"segment outside its walk at line {number + 1}")
    obs = f[11] if len(f) > 11 else ''
    segs.append((int(unit), int(depth), ident, int(start), int(out_count), out_hash, int(dynamic), int(eff_count), eff_hash, int(obs_count), obs))
if verified and (active_walk is not None or not units):
    raise ValueError("incomplete census")
own = [s for s in segs if s[1] <= 1]
hdr = [s for s in segs if s[1] > 1]
print(f"units {units}, segments {len(segs)}: main-file {len(own)} ({sum(s[4] for s in own)} tokens), header {len(hdr)} ({sum(s[4] for s in hdr)} tokens)")
if verified:
    print(f"preprocessing walks {walks}, including {walks - units} replays")
seen = {}
hits = 0; hit_tokens = 0; inconsistent = 0; dyn = 0; dyn_tokens = 0
key_outs = collections.defaultdict(set)
context_keys = set()
obs_sizes = []; eligible_obs = []; eff_sizes = []
text_keys = collections.defaultdict(set)
for s in hdr:
    obs_sorted = ','.join(sorted(s[10].split(','))) if s[10] else ''
    key = (s[2], s[3], obs_sorted)
    key_outs[key].add((s[4], s[5], s[7], s[8]))
    text_keys[(s[2], s[3], s[5], s[8])].add(obs_sorted)
    obs_sizes.append(s[9]); eff_sizes.append(s[7])
    if s[6]:
        context_keys.add(key)
        dyn += 1; dyn_tokens += s[4]
    if key in seen:
        hits += 1; hit_tokens += s[4]
    else:
        seen[key] = s
bad_keys = set()
for k, v in key_outs.items():
    if len(v) > 1:
        inconsistent += 1
        bad_keys.add(k)
# Exclude the whole key, even if a later visit first exposed its context dependency or disagreement.
excluded = bad_keys | context_keys
c_hits = 0; c_tokens = 0
seen_c = set()
for s in hdr:
    obs_sorted = ','.join(sorted(s[10].split(','))) if s[10] else ''
    key = (s[2], s[3], obs_sorted)
    if key in excluded:
        continue
    if key in seen_c:
        c_hits += 1; c_tokens += s[4]
        eligible_obs.append(s[9])
    else:
        seen_c.add(key)
ht = sum(s[4] for s in hdr)
print(f"distinct keys {len(seen)}; repeat visits before validation {hits} of {len(hdr)} header segments ({hits/max(1,len(hdr)):.4f}); tokens in those visits {hit_tokens} of {ht} ({hit_tokens/max(1,ht):.4f})")
print(f"keys whose output or effects differ between uses: {inconsistent}")
basis = "exact comparison" if verified else "legacy hash estimate"
print(f"{basis}, context-dependent and inconsistent keys excluded: eligible repeat visits {c_hits} of {len(hdr)}, {c_tokens} of {ht} tokens ({c_tokens/max(1,ht):.4f})")
print(f"context-dependent segments: {dyn} ({dyn_tokens} tokens), distinct flagged keys {len(context_keys)}")
if not hdr:
    sys.exit(0)
q = statistics.quantiles(obs_sizes, n=10) if len(obs_sizes) > 10 else obs_sizes
print(f"observed names a header segment: mean {statistics.mean(obs_sizes):.1f}, median {statistics.median(obs_sizes)}, p90 {q[-1]:.0f}, max {max(obs_sizes)}; per eligible repeat mean {statistics.mean(eligible_obs) if eligible_obs else 0:.1f}")
print(f"macros set a header segment: mean {statistics.mean(eff_sizes):.2f}, max {max(eff_sizes)}; total {sum(eff_sizes)}")
tok_per_obs = ht / max(1, sum(obs_sizes))
print(f"header tokens per observed name: {tok_per_obs:.2f}")
# Texts reached by more than one key: a relaxed key would merge them.
multi = sum(1 for v in text_keys.values() if len(v) > 1)
print(f"(file, start, output, effects) with more than one key: {multi} of {len(text_keys)}")
# What a unit costs in validations: sum of observed names of its header segments.
per_unit = collections.Counter()
for s in hdr:
    per_unit[s[0]] += s[9]
vals = list(per_unit.values())
denominator = "walk" if verified else "unit"
print(f"observed names to validate a {denominator}: mean {statistics.mean(vals):.0f}, median {statistics.median(vals)}, max {max(vals)}")
