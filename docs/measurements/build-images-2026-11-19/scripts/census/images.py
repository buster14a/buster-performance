# Header images' census from the experiment patch's lines (BUSTER_PP_IMAGE_CENSUS_FILE).
# Usage: python3 -I images.py CENSUS.tsv
import sys, collections, statistics
segs = []
units = 0
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'U':
        units += 1
        continue
    unit, depth, ident, start, out_count, out_hash, dynamic, eff_count, eff_hash, obs_count = f[1:11]
    obs = f[11] if len(f) > 11 else ''
    segs.append((int(unit), int(depth), ident, int(start), int(out_count), out_hash, int(dynamic), int(eff_count), eff_hash, int(obs_count), obs))
own = [s for s in segs if s[1] <= 1]
hdr = [s for s in segs if s[1] > 1]
print(f"units {units}, segments {len(segs)}: main-file {len(own)} ({sum(s[4] for s in own)} tokens), header {len(hdr)} ({sum(s[4] for s in hdr)} tokens)")
seen = {}
hits = 0; hit_tokens = 0; inconsistent = 0; dyn = 0; dyn_tokens = 0
key_outs = collections.defaultdict(set)
obs_sizes = []; hit_obs = []; eff_sizes = []
text_keys = collections.defaultdict(set)
for s in hdr:
    obs_sorted = ','.join(sorted(s[10].split(','))) if s[10] else ''
    key = (s[2], s[3], obs_sorted)
    key_outs[key].add((s[5], s[8]))
    text_keys[(s[2], s[3], s[5], s[8])].add(obs_sorted)
    obs_sizes.append(s[9]); eff_sizes.append(s[7])
    if s[6]:
        dyn += 1; dyn_tokens += s[4]
    if key in seen:
        hits += 1; hit_tokens += s[4]; hit_obs.append(s[9])
    else:
        seen[key] = s
bad_keys = set()
for k, v in key_outs.items():
    if len(v) > 1:
        inconsistent += 1
        bad_keys.add(k)
# Conservative: every use of a key whose output or effects differ is a miss.
c_hits = 0; c_tokens = 0
seen_c = set()
for s in hdr:
    obs_sorted = ','.join(sorted(s[10].split(','))) if s[10] else ''
    key = (s[2], s[3], obs_sorted)
    if key in bad_keys:
        continue
    if key in seen_c:
        c_hits += 1; c_tokens += s[4]
    else:
        seen_c.add(key)
ht = sum(s[4] for s in hdr)
print(f"distinct keys {len(seen)}; hits {hits} of {len(hdr)} header segments ({hits/max(1,len(hdr)):.4f}); tokens in hits {hit_tokens} of {ht} ({hit_tokens/max(1,ht):.4f})")
print(f"keys whose output or effects differ between uses: {inconsistent} (must be 0)")
print(f"conservative, those keys' uses all misses: hits {c_hits} ({c_hits/max(1,len(hdr)):.4f}), tokens in hits {c_tokens} ({c_tokens/max(1,ht):.4f})")
print(f"segments expanding a unit-dependent builtin: {dyn} ({dyn_tokens} tokens)")
q = statistics.quantiles(obs_sizes, n=10) if len(obs_sizes) > 10 else obs_sizes
print(f"observed names a header segment: mean {statistics.mean(obs_sizes):.1f}, median {statistics.median(obs_sizes)}, p90 {q[-1]:.0f}, max {max(obs_sizes)}; per hit mean {statistics.mean(hit_obs) if hit_obs else 0:.1f}")
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
print(f"observed names to validate a unit: mean {statistics.mean(vals):.0f}, median {statistics.median(vals)}, max {max(vals)}")
