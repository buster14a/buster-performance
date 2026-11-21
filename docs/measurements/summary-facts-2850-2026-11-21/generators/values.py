#!/usr/bin/env python3
# values.py KEY=PATH... > all.json: the numbers the write-ups use, each from a file a run wrote.
#   final=, repeat=, experiment=, experiment2=   xs-table.py's, xse-table.py's and xse2-table.py's JSON files (the 9700X's);
#   build:NAME=                    an earlier build's xs-table.py JSON;
#   checks=                        checks-rows.sh's directory (the cloud container's runs of the frozen commit);
#   census=                        the census's record's `out` (the piece before's code on the same inputs);
#   faults=                        faults-tally.py's JSON;
#   probes=                        the probes' directory (cases*.txt, a line a program);
#   fuzz:NAME=                     a fuzz campaign's directory (run-*.log and */found.txt);
#   tests:NAME=                    a run of the regression programs (tests-run's out file).
import glob, json, os, re, sys
args = dict(a.split('=', 1) for a in sys.argv[1:])
def number(text, pattern):
    m = re.search(pattern, text)
    if m is None:
        raise SystemExit('no ' + pattern)
    return int(m.group(1))
def shadow(path):
    text = open(path).read()
    r = {}
    r['expressions'] = number(text, r'window rows expressions=(\d+)')
    r['taken'] = number(text, r'window rows expressions=\d+ records=\d+ taken=(\d+)')
    r['taken_records'] = number(text, r'window rows expressions=.* their-records=(\d+)')
    r['swept'] = number(text, r'window rows expressions=.* records-swept=(\d+)')
    r['rows_differences'] = number(text, r'window rows expressions=.* differences=(\d+) not-kept')
    if 'casts-listed-for-a-truth-their-value-has-not=' in text:
        r['passed'] = number(text, r'casts-listed-for-a-truth-their-value-has-not=(\d+)')
    if 'window summaries compared=' in text:
        r['kept'] = number(text, r'window summaries compared=(\d+)')
        r['unkept'] = number(text, r'window summaries compared=\d+ \(not kept: (\d+)\)')
        r['kept_references'] = number(text, r'window summaries expressions=\d+ their-references=(\d+)')
        r['program_references'] = number(text, r"the program's references=(\d+)")
        r['listed_references'] = number(text, r'records listed for a reference=(\d+)')
        r['suspects'] = number(text, r'calls asked a record at a time=(\d+)')
        r['reduced'] = number(text, r'expressions reduced=(\d+)')
        r['unknown'] = number(text, r'with-an-unknown=(\d+)')
        r['stop'] = number(text, r'with-a-stop=(\d+)')
        r['decided'] = number(text, r'second operand whose truth is known=(\d+)')
        r['conditions'] = number(text, r"conditions' truths asked=(\d+)")
        r['truths'] = number(text, r'a truth known=(\d+)')
        r['folds'] = number(text, r'a constant folded=(\d+)')
        r['differences'] = [number(text, p) for p in (r'reference-differences=(\d+)', r'fact-differences=(\d+)', r'truth-differences=(\d+)', r'fold-differences=(\d+)')]
        r['again'] = number(text, r'window summaries expressions=.* second-runs-that-differ=(\d+)')
    return r
out = dict(builds={}, fuzz={}, tests={})
for key, path in args.items():
    if key in ('final', 'repeat', 'experiment', 'experiment2', 'faults'):
        out[key] = json.load(open(path))
    elif key.startswith('build:'):
        out['builds'][key[6:]] = json.load(open(path))
    elif key == 'checks':
        checks = path
        cloud = {}
        for unit in ('sqlite', 'lua', 'musl', 'main'):
            cloud[unit] = shadow('%s/shadow/%s--passes0--window-rows--list20.out' % (checks, unit))
            cloud[unit + '-wall'] = shadow('%s/shadow/%s--passes0--window-rows-Wall-Wextra--list20.out' % (checks, unit))
        out['cloud'] = cloud
        status = open(checks + '/shadow/status.txt').read()
        progress = open(checks + '/progress.txt').read()
        check = dict(revision=open(checks + '/revision.txt').read().split()[0][:9], shadow_runs=len(re.findall(r' status \d+', status)),
                     shadow_ok=len(re.findall(r' status 0\b', status)), progress=progress)
        modes = open(checks + '/modes/status.txt').read()
        check['mode_runs'] = len(re.findall(r' status \d+', modes))
        check['mode_ok'] = len(re.findall(r' status 0\b', modes))
        parts = open(checks + '/test-checker/status.txt').read()
        check['parts'] = len(re.findall(r'^part \d status \d+', parts, re.M))
        check['parts_ok'] = len(re.findall(r'^part \d status 0\b', parts, re.M))
        check['checks'] = sum(int(x) for x in re.findall(r'test-checker: (\d+) checks, 0 failures', parts))
        check['part5'] = number(parts, r'part 5 status 0 .*test-checker: (\d+) checks, 0 failures')
        out['checks'] = check
    elif key == 'census':
        out['census_dir'] = path
        out['census_taken'] = {unit: shadow('%s/shadow-%s.txt' % (path, unit))['taken'] for unit in ('sqlite', 'lua', 'musl', 'main')}
    elif key == 'probes':
        agree = re.compile(r' status 0 .*refused \d+ diff 0 .*entries \d+ diff 0 .*values alone 0 .*compared \d+ program-refs \d+ diff refs 0 facts 0 folds 0 truths 0$')
        files = sorted(glob.glob(path + '/cases*.txt'), key=lambda f: int(re.search(r'cases(\d+)', f).group(1)))
        p = dict(cases=0, agree=0, piece=0, files=len(files), by_file={})
        sums = dict(kept=0, refs=0, unknown=0, stop=0, asked=0, decided=0)
        for f in files:
            k = int(re.search(r'cases(\d+)', f).group(1))
            lines = [l.rstrip('\n') for l in open(f)]
            p['cases'] += len(lines)
            p['agree'] += sum(1 for l in lines if agree.search(l))
            p['by_file'][str(k)] = len(lines)
            if k >= 22:
                p['piece'] += len(lines)
                for l in lines:
                    m = re.search(r'facts kept (\d+) refs (\d+) unknown (\d+) stop (\d+) asked (\d+) reduced \d+ decided (\d+)', l)
                    if m:
                        for name, value in zip(('kept', 'refs', 'unknown', 'stop', 'asked', 'decided'), m.groups()):
                            sums[name] += int(value)
        p['sums'] = sums
        p['before'] = p['cases'] - p['piece']
        out['probes'] = p
    elif key.startswith('fuzz:'):
        campaign = dict(programs=0, rejected=0, clean=0, found=0, variants={}, truth=0, value=0, unsound=0, other=0)
        for log in sorted(glob.glob(path + '/run-*.log')):
            m = re.search(r'seed (\d+): (\d+) programs, (\d+) rejected, (\d+) clean, (\d+) found', open(log).read())
            if m is None:
                raise SystemExit(log + ': not finished')
            seed, programs, rejected, clean, found = (int(x) for x in m.groups())
            campaign['programs'] += programs; campaign['rejected'] += rejected; campaign['clean'] += clean; campaign['found'] += found
            campaign['variants'][str(seed)] = dict(programs=programs, rejected=rejected, clean=clean, found=found)
        for found in glob.glob(path + '/*/found.txt') + glob.glob(path + '/found.txt'):
            for line in open(found):
                signature = line.split(' | ')[1]
                if 'truth-differences' in signature: campaign['truth'] += 1
                elif 'window rows' in signature: campaign['value'] += 1
                elif 'taken-there-and-refused-by-the-census' in signature: campaign['unsound'] += 1
                else: campaign['other'] += 1
        assert campaign['truth'] + campaign['value'] + campaign['unsound'] + campaign['other'] == campaign['found'], (key, campaign)
        # The unsound takes by the compiler's own warning's text, where a run of the classifier left its counts.
        if os.path.exists(path + '/classes.txt'):
            m = re.search(r'total (\d+) ordered-alone (\d+) cast-alone (\d+) both (\d+) neither (\d+)', open(path + '/classes.txt').read())
            campaign['classes'] = dict(zip(('total', 'ordered', 'cast', 'both', 'neither'), (int(x) for x in m.groups())))
            assert campaign['classes']['total'] == campaign['found'], (key, campaign['classes'])
        out['fuzz'][key[5:]] = campaign
    elif key.startswith('tests:'):
        text = open(path).read()
        m = re.search(r"\{'rejected': (\d+), 'clean': (\d+), 'found': (\d+)\}", text) or re.search(r"\{'rejected': (\d+), 'clean': (\d+)\}", text)
        rejected, clean = int(m.group(1)), int(m.group(2))
        found = int(m.group(3)) if m.lastindex == 3 else 0
        names = re.findall(r'^FOUND (\S+)', text, re.M)
        assert len(names) == found
        out['tests'][key[6:]] = dict(programs=rejected + clean + found, rejected=rejected, clean=clean, found=found, ran=clean + found,
                                     cleanup=sum(1 for x in names if '/cleanup/' in x), rows=sum(1 for x in names if re.search(r'sources/00(13|14|21|22)\.c', x)),
                                     objects=sum(1 for x in names if re.search(r'sources/0(396|397|402|405|406|416|417)\.c', x)), names=names)
    else:
        raise SystemExit('unknown key ' + key)
if 'cloud' in out and 'census_taken' in out:
    for unit in ('sqlite', 'lua', 'musl', 'main'):
        out['cloud'][unit]['before_taken'] = out['census_taken'][unit]
        out['cloud'][unit]['left_out'] = out['census_taken'][unit] - out['cloud'][unit]['taken']
json.dump(out, sys.stdout, indent=1)
