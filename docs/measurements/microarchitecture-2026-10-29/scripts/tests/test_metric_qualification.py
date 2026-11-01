"""Original regressions; archived CSV operands are quoted verbatim from #875.

ENTRIES is a minimal synthetic unit-test inventory. The archive integration test
uses the byte-verified complete captured inventory instead.
"""
import copy
from decimal import Decimal
import json
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from metric_qualification import (Inventory, Rejected, archived_capture, parse_elapsed,
                                  parse_evlist, parse_verbose, parse_verbose_attributes, qualify)

ENTRIES = [
    {'EventName': name, 'Unit': 'cpu', 'Encoding': encoding}
    for name, encoding in (
        ('ex_ret_brn', 'cpu/event=0xc2/'),
        ('ex_ret_brn_misp', 'cpu/event=0xc3/'),
        ('ls_dispatch.ld_dispatch', 'cpu/event=0x29,umask=1/'),
        ('ls_not_halted_cyc', 'cpu/event=0x76/'),
        ('ex_ret_ops', 'cpu/event=0xc1/'),
        ('de_src_op_disp.all', 'cpu/event=0xaa,umask=0xff/'))
]


def metric(name, expression, scale='1'):
    return {'MetricName': name, 'MetricExpr': expression, 'ScaleUnit': scale, 'Unit': 'default_core'}


ENTRIES += [
    metric('branch_misprediction_rate', 'd_ratio(ex_ret_brn_misp, ex_ret_brn)', '1per_branch'),
    metric('lpm_cycles_user', r'd_ratio(cpu\-cycles:uH,cpu\-cycles:kHh + cpu\-cycles:G + cpu\-cycles:uH)', '100%'),
    metric('lpm_cycles_total', r'cpu\-cycles:kHh + cpu\-cycles:G + cpu\-cycles:uH', '1cycles'),
    metric('lpm_ldst_total_ld', 'd_ratio(ls_dispatch.ld_dispatch, duration_time)', '1insns per sec'),
    metric('total_dispatch_slots', '8 * ls_not_halted_cyc', '1slots'),
    metric('retiring', 'd_ratio(ex_ret_ops, total_dispatch_slots)', '100%slots'),
    metric('bad_speculation', 'd_ratio(de_src_op_disp.all - ex_ret_ops, total_dispatch_slots)', '100%ops'),
    metric('retiring_half', 'retiring / 2', '100%slots'),
]
INVENTORY = Inventory(ENTRIES)
BRANCH = {'kind': 'metric', 'workload': 'compile', 'variant': 'branch_misprediction_rate', 'repetition': 0, 'status': 0, 'wall_ms': 131.478129, 'affinity': '2', 'perf_stat': '# started on Thu Oct 29 16:09:27 2026\n\n211482428;;ex_ret_brn;125374788;100.00;0.0;per_branch  branch_misprediction_rate\n3590833;;ex_ret_brn_misp;125374788;100.00;;\n', 'workload_stderr': ''}
USER = {'kind': 'metric', 'workload': 'compile', 'variant': 'lpm_cycles_user', 'repetition': 0, 'status': 0, 'wall_ms': 131.596922, 'affinity': '2', 'perf_stat': '# started on Thu Oct 29 16:09:46 2026\n\n597727633;;cpu-cycles:uH;125350651;100.00;50.0;%  lpm_cycles_user\n597727633;;cpu-cycles:kHh;125350651;100.00;;\n0;;cpu-cycles:G;125350651;100.00;;\n', 'workload_stderr': ''}
TOTAL = {'kind': 'metric', 'workload': 'compile', 'variant': 'lpm_cycles_total', 'repetition': 0, 'status': 0, 'wall_ms': 131.419309, 'affinity': '2', 'perf_stat': '# started on Thu Oct 29 16:09:46 2026\n\n594508147;;cpu-cycles:uH;125243942;100.00;1189016294.0;cycles  lpm_cycles_total\n594508147;;cpu-cycles:kHh;125243942;100.00;;\n0;;cpu-cycles:G;125243942;100.00;;\n', 'workload_stderr': ''}
LOAD = {'kind': 'metric', 'workload': 'compile', 'variant': 'lpm_ldst_total_ld', 'status': 0, 'perf_stat': '540701410;;ls_dispatch.ld_dispatch;125723340;100.00;0.0;insns per sec  lpm_ldst_total_ld\n0;;duration_time;1;100.00;;\n'}


def changed(record, old, new):
    result = copy.deepcopy(record)
    result['perf_stat'] = result['perf_stat'].replace(old, new)
    return result


def verbose_text(record):
    lines = []
    for line in record['perf_stat'].splitlines():
        fields = line.split(';')
        if len(fields) < 5 or not fields[2]:
            continue
        name, count, runtime, duty = fields[2], fields[0], int(fields[3] or 0), Decimal(fields[4] or 0)
        enabled = max(runtime, 1)
        running = int(duty * enabled / 100)
        lines.append(f'{name}: {count} {enabled} {running}')
    elapsed = record.get('elapsed_seconds', '0.125')
    lines.append(f'       {elapsed} seconds time elapsed')
    return '\n'.join(lines) + '\n'


def live(record, scope='user'):
    result = copy.deepcopy(record)
    result.update(collection_scope=scope, evlist_status=0, stat_data_sha256='a' * 64,
                  collector_schema='buster-perf-metric-v2',
                  perf_argv=['perf', 'stat', 'record', *(['--all-user'] if scope == 'user' else []), '-M', record['variant'], '--', '/compiler'])
    attrs = []
    for line in record['perf_stat'].splitlines():
        fields = line.split(';')
        if len(fields) < 5 or fields[2] == 'duration_time':
            continue
        name = fields[2]
        flags = 'exclude_kernel: 1'
        if scope == 'formula':
            flags = {'uH': 'exclude_kernel: 1, exclude_hv: 1, exclude_guest: 1',
                     'kHh': 'exclude_user: 1, exclude_guest: 1',
                     'G': 'exclude_host: 1'}.get(name.split(':')[-1], '')
        attrs.append(f'{name}: type: 4 (cpu), size: 128, config: 0xc2 (event), inherit: 1' + (', ' + flags if flags else ''))
    result['perf_evlist'] = '\n'.join(attrs)
    blocks = []
    for line in attrs:
        name, rest = line.split(': ', 1)
        blocks.extend(('Opening: ' + name, 'perf_event_attr:'))
        blocks.extend('  ' + field.replace(': ', ' ', 1) for field in rest.split(', '))
    result['perf_stat'] = '\n'.join(blocks + [verbose_text(record)]) + '\n'
    result['perf_stat_sha256'] = 'b' * 64
    return result


class QualificationTests(unittest.TestCase):
    def result(self, record, state, eligible=False, inventory=INVENTORY, historical=True):
        result = qualify(record, inventory, historical)
        self.assertEqual(result['qualification'], state, result)
        self.assertEqual(result['eligible'], eligible, result)
        if not eligible:
            self.assertIsNone(result['value'])
        json.dumps(result, allow_nan=False)
        return result

    def test_archived_branch_precision(self):
        result = self.result(BRANCH, 'rounded-to-zero', True)
        self.assertLess(abs(Decimal(result['value']) - (Decimal(3590833) / Decimal(211482428))), Decimal('1e-17'))
        self.assertEqual(result['unit'], 'per_branch')
        self.assertEqual(result['reported_value'], '0.0')

    def test_archived_privilege_split(self):
        self.result(USER, 'semantically-invalid')

    def test_archived_doubled_total(self):
        self.result(TOTAL, 'semantically-invalid')

    def test_privilege_override_not_a_count_equality_heuristic(self):
        self.result(changed(USER, '597727633;;cpu-cycles:kHh', '123;;cpu-cycles:kHh'), 'semantically-invalid')

    def test_intended_domains_with_equal_counts_are_legitimate(self):
        result = self.result(live(USER, 'formula'), 'valid', True, historical=False)
        self.assertEqual(Decimal(result['value']), 50)

    def test_effective_kernel_override_rejected(self):
        record = live(USER, 'formula')
        record['perf_stat'] = record['perf_stat'].replace('  exclude_user 1', '  exclude_kernel 1')
        self.result(record, 'semantically-invalid', historical=False)

    def test_zero_duration_is_not_zero_rate(self):
        self.result(LOAD, 'semantically-invalid')

    def test_wrapper_wall_cannot_rescue_zero_duration(self):
        record = dict(LOAD, wall_ms=125.723340, time_sanity_seconds='0.125723340')
        self.result(record, 'semantically-invalid')

    def test_missing_duration(self):
        self.result(changed(LOAD, '0;;duration_time;1;100.00;;\n', ''), 'unavailable')

    def test_positive_duration_conversion(self):
        record = live(changed(LOAD, '0;;duration_time', '125000000;;duration_time'))
        record['time_sanity_seconds'] = '0.125'
        result = self.result(record, 'valid', True, historical=False)
        self.assertEqual(Decimal(result['value']), Decimal(540701410) * 8)

    def test_elapsed_fallback_requires_control_and_positive_time(self):
        record = live(changed(LOAD, '0;;duration_time', '0;;duration_time'))
        record['time_sanity_seconds'] = '0.125'
        result = self.result(record, 'valid', True, historical=False)
        self.assertEqual(Decimal(result['value']), Decimal(540701410) / Decimal('0.125'))
        rows = {row['event']: row for row in result['operands']}
        self.assertEqual(rows['duration_time']['duration_source'], 'perf-elapsed')
        record['perf_stat'] = record['perf_stat'].replace('0.125 seconds time elapsed', '')
        self.result(record, 'unavailable', historical=False)

    def test_duplicate_verbose_operand_is_rejected(self):
        record = live(BRANCH)
        record['perf_stat'] += 'ex_ret_brn: 1 125374788 125374788\n'
        self.result(record, 'semantically-invalid', historical=False)

    def test_duration_requires_independent_sanity(self):
        self.result(live(changed(LOAD, '0;;duration_time', '125000000;;duration_time')), 'semantically-invalid', historical=False)

    def test_inconsistent_duration(self):
        record = live(changed(LOAD, '0;;duration_time', '125000000;;duration_time'))
        record['time_sanity_seconds'] = '5'
        self.result(record, 'semantically-invalid', historical=False)

    def test_real_zero_numerator(self):
        result = self.result(changed(BRANCH, '3590833;', '0;'), 'genuine-zero', True)
        self.assertEqual(Decimal(result['value']), 0)

    def test_zero_denominator_even_with_zero_numerator(self):
        self.result(changed(changed(BRANCH, '3590833;', '0;'), '211482428;', '0;'), 'semantically-invalid')

    def test_missing_numerator(self):
        self.result(changed(BRANCH, '3590833;;ex_ret_brn_misp;125374788;100.00;;\n', ''), 'unavailable')

    def test_duplicate_operand(self):
        record = dict(BRANCH, perf_stat=BRANCH['perf_stat'] + '1;;ex_ret_brn;10;100;;\n')
        self.result(record, 'semantically-invalid')

    def test_unavailable_nonfinite_and_not_counted(self):
        for value in ('<not counted>', '<not supported>', 'nan', 'inf', '-Infinity'):
            with self.subTest(value=value):
                self.result(changed(BRANCH, '3590833;', value + ';'), 'unavailable')

    def test_negative_operand(self):
        self.result(changed(BRANCH, '3590833;', '-1;'), 'semantically-invalid')

    def test_invalid_runtime_or_duty(self):
        for old, new in ((';125374788;', ';0;'), (';100.00;', ';101;'), (';100.00;', ';nan;')):
            self.result(changed(BRANCH, old, new), 'unavailable' if new == ';nan;' else 'semantically-invalid')

    def test_underscheduled(self):
        self.result(changed(BRANCH, ';100.00;', ';98.99;'), 'underscheduled')

    def test_workload_failure(self):
        self.result(dict(BRANCH, status=1), 'failed')

    def test_unknown_scope(self):
        self.result(BRANCH, 'unavailable', historical=False)

    def test_live_attributes_required(self):
        record = live(BRANCH)
        record['perf_stat'] = 'ex_ret_brn: 211482428 125374788 125374788\n'
        self.result(record, 'unavailable', historical=False)

    def test_live_user_scope(self):
        self.result(live(BRANCH), 'valid', True, historical=False)

    def test_live_scope_mismatch(self):
        record = live(BRANCH)
        record['perf_argv'].remove('--all-user')
        self.result(record, 'semantically-invalid', historical=False)

    def test_live_system_scope_rejected(self):
        record = live(BRANCH)
        record['perf_argv'].insert(3, '-a')
        self.result(record, 'semantically-invalid', historical=False)

    def test_live_inheritance_required(self):
        record = live(BRANCH)
        record['perf_stat'] = record['perf_stat'].replace('  inherit 1', '  inherit 0')
        self.result(record, 'semantically-invalid', historical=False)

    def test_wrong_metric_unit(self):
        self.result(changed(BRANCH, 'per_branch  branch_', '%  branch_'), 'semantically-invalid')

    def test_unknown_raw_units(self):
        self.result(changed(BRANCH, '3590833;;', '3590833;msec;'), 'unsupported')

    def test_scale_and_recursive_metric_are_not_double_applied(self):
        record = {'variant': 'retiring_half', 'status': 0, 'perf_stat': '800;;ls_not_halted_cyc;10;100;25;%slots  retiring_half\n3200;;ex_ret_ops;10;100;;\n'}
        result = self.result(record, 'valid', True)
        self.assertEqual(Decimal(result['value']), 25)

    def test_topdown_formulas_independently_qualified(self):
        record = {'variant': 'bad_speculation', 'status': 0, 'perf_stat': '1651028127;;de_src_op_disp.all;125945456;100.00;9.4;%ops  bad_speculation\n598334794;;ls_not_halted_cyc;125945456;100.00;;\n1200760996;;ex_ret_ops;125945456;100.00;;\n'}
        self.result(record, 'valid', True)
        self.result(changed(record, '598334794;', '0;'), 'semantically-invalid')

    def test_bad_formula_never_evaluates_code(self):
        for expr in ('__import__("os").system("false")', '0 if has_event(x) else 1', 'ex_ret_brn ** 1000000000', '#target_cpu', '1'):
            with self.subTest(expr=expr):
                entries = [*ENTRIES, metric('branch_misprediction_rate', expr, '1per_branch')]
                self.result(BRANCH, 'unsupported', inventory=Inventory(entries))

    def test_conflicting_formula(self):
        self.result(BRANCH, 'unsupported', inventory=Inventory([*ENTRIES, metric('branch_misprediction_rate', 'ex_ret_brn', '1per_branch')]))

    def test_dependency_cycle(self):
        entries = [metric('a', 'b'), metric('b', 'a')]
        self.result(dict(BRANCH, variant='a'), 'unsupported', inventory=Inventory(entries))

    def test_formula_closure_identity_changes_with_dependency(self):
        entries = copy.deepcopy(ENTRIES)
        for item in entries:
            if item.get('MetricName') == 'total_dispatch_slots':
                item['MetricExpr'] = '9 * ls_not_halted_cyc'
        self.assertNotEqual(INVENTORY.formula_identity('retiring'), Inventory(entries).formula_identity('retiring'))

    def test_unknown_archive_never_inherits_historical_scope(self):
        self.assertFalse(archived_capture(b'fake', b'[]'))

    def test_collection_plans_preserve_explicit_domains(self):
        self.assertEqual(INVENTORY.plan('lpm_cycles_user')['scope'], 'formula')
        self.assertNotIn('--all-user', INVENTORY.plan('lpm_cycles_user')['arguments'])
        self.assertIn('--all-user', INVENTORY.plan('branch_misprediction_rate')['arguments'])
        with self.assertRaises(Rejected):
            INVENTORY.plan('lpm_cycles_user', 'user')

    def test_uncore_not_process_core(self):
        entries = [*ENTRIES, {'EventName': 'ex_ret_brn', 'Unit': 'amd_df'}]
        self.result(BRANCH, 'unsupported', inventory=Inventory(entries))

    def test_software_and_amd_l3_are_process_core(self):
        entries = [*ENTRIES,
                   {'EventName': 'context-switches', 'Unit': 'software', 'Encoding': 'software/config=3/'},
                   {'EventName': 'l3_lookup_state.l3_miss', 'Unit': 'amd_l3', 'Encoding': 'amd_l3/event=4,umask=1/'},
                   metric('cs_rate', r'd_ratio(context\-switches, duration_time)', '1ctxsw/s'),
                   metric('l3_misses', 'd_ratio(l3_lookup_state.l3_miss, duration_time)', '1accesses per sec')]
        inventory = Inventory(entries)
        self.assertEqual(inventory.domain('cs_rate'), 'process-core')
        self.assertEqual(inventory.domain('l3_misses'), 'process-core')
        plan = inventory.plan('cs_rate')
        self.assertEqual(plan['scope'], 'formula')
        self.assertNotIn('--all-user', plan['arguments'])

    def test_evlist_zero_defaults_and_annotations(self):
        parsed = parse_evlist('cycles:u: type: 0 (PERF_TYPE_HARDWARE), size: 128, config: 0 (PERF_COUNT_HW_CPU_CYCLES), inherit: 1, exclude_kernel: 1')
        self.assertEqual(parsed['cpu-cycles:u']['exclude_user'], 0)
        self.assertEqual(parsed['cpu-cycles:u']['exclude_kernel'], 1)

    def test_verbose_counts_and_attributes(self):
        text = '''Opening: cycles:u
perf_event_attr:
  type                             0
  size                             128
  config                           0
  inherit                          1
  exclude_kernel                   1
------------------------------------------------------------
Opening: duration_time
perf_event_attr:
  type                             4294967294
  size                             128
  config                           1
  inherit                          1
------------------------------------------------------------
cycles:u: -1: 1 2 2
cycles:u: 10 20 20
duration_time: 0 1 1

       0.250000000 seconds time elapsed
'''
        rows = {row['event']: row for row in parse_verbose(text)}
        self.assertEqual(rows['cycles:u']['count'], '10')
        self.assertEqual(rows['cycles:u']['duty_percent'], '100')
        self.assertEqual(parse_elapsed(text), Decimal('0.25'))
        attributes = parse_verbose_attributes(text)
        self.assertEqual(attributes['cpu-cycles:u']['exclude_kernel'], 1)
        self.assertEqual(attributes['cpu-cycles:u']['size'], 128)
        self.assertEqual(attributes['duration_time']['type'], 4294967294)

    def test_verbose_duplicate_and_missing_attributes(self):
        duplicate = 'cycles:u: 1 1 1\ncycles:u: 2 1 1\n'
        with self.assertRaises(Rejected):
            parse_verbose(duplicate)
        self.assertEqual(parse_verbose_attributes('cycles:u: 1 1 1\n'), {})

    def test_evlist_incomplete_and_duplicate(self):
        for text in ('cycles:u: type: 0, config: 0', 'cycles:u: type: 0, size: 16, config: 0', 'cycles:u: size: 128\ncycles:u: size: 128'):
            with self.subTest(text=text), self.assertRaises(Rejected):
                parse_evlist(text)


if __name__ == '__main__':
    unittest.main()
