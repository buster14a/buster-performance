#!/usr/bin/env python3
"""Fail-closed qualification of the existing Python perf campaign's metrics.

Original project code, Apache-2.0 WITH LLVM-exception. No perf implementation
is imported. Decimal strings are the interchange format: display text is never
an input to arithmetic, and a rejected metric never has an exported value.
"""
import ast
import csv
from decimal import Decimal, InvalidOperation, localcontext
import hashlib
import json
import re

ARCHIVE_COMMIT = '278231126048bbf6dbac0cedfc5004aa16b415ae'
ARCHIVE_MEASUREMENTS_BLOB = 'd7dd4d4db8248910288b21e298f59c5332b06b4a'
ARCHIVE_INVENTORY_BLOB = 'dd4a83af42ae9a03b31d0f50d3849e8a88367cbe'
NUMBER = r'(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?'
TOKEN = re.compile(r'\s+|' + NUMBER + r'|[A-Za-z_][A-Za-z_0-9]*@(?:\\.|[^@])*@(?::?[ukHGhp]+)?|(?:[A-Za-z_]|\\.)(?:[A-Za-z_0-9.:]|\\.)*|[()+*/,\-]')
FLAGS = ('exclude_user', 'exclude_kernel', 'exclude_hv', 'exclude_host', 'exclude_guest')
GENERIC = {'cpu-cycles', 'instructions', 'branches', 'branch-misses',
           'stalled-cycles-frontend', 'stalled-cycles-backend', 'cache-references', 'cache-misses'}


class Rejected(ValueError):
    def __init__(self, state, reason):
        super().__init__(reason)
        self.state = state
        self.reason = reason


def reject(state, reason):
    raise Rejected(state, reason)


def decimal(text):
    try:
        value = Decimal(text)
    except (InvalidOperation, TypeError, ValueError):
        reject('unavailable', 'non-numeric operand: ' + str(text))
    if not value.is_finite():
        reject('unavailable', 'non-finite operand: ' + str(text))
    return value


def blob_sha(data):
    return hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()


def archived_capture(measurements, inventory):
    # A directory name, a caller-supplied scope, or a finite display is not proof.
    return (blob_sha(measurements) == ARCHIVE_MEASUREMENTS_BLOB and
            blob_sha(inventory) == ARCHIVE_INVENTORY_BLOB)


def canonical(name):
    name = re.sub(r'\\(.)', r'\1', name.strip()).replace('@', '/')
    name = re.sub(r'^cpu/([^/,]+)/([ukHGhp]*)$', r'\1:\2', name).rstrip(':')
    name = re.sub(r'/:(?=[ukHGhp]+$)', '/', name)
    if name == 'cycles' or name.startswith('cycles:'):
        name = 'cpu-cycles' + name[len('cycles'):]
    return name


def modifiers(name):
    name = canonical(name)
    match = re.search(r'(?::|/)([ukHGhp]+)$', name)
    return match.group(1) if match else ''


def parse_stat(text):
    rows = []
    for line in text.splitlines():
        if not line.strip() or line.lstrip().startswith('#') or ';' not in line:
            continue
        fields = next(csv.reader([line], delimiter=';'))
        if len(fields) < 5 or not fields[2].strip():
            reject('unavailable', 'malformed perf stat row')
        rows.append({'event': fields[2].strip(), 'count': fields[0].strip(),
                     'unit': fields[1].strip(), 'runtime_ns': fields[3].strip(),
                     'duty_percent': fields[4].strip(),
                     'display_value': fields[5].strip() if len(fields) > 5 else '',
                     'display_label': fields[6].strip() if len(fields) > 6 else ''})
    if not rows:
        reject('unavailable', 'no operand rows')
    return rows


def parse_evlist(text):
    """Read perf evlist -v's complete per-event attribute lines, not labels.

    perf_event_attr__fprintf omits zero fields. A size field is required before
    zero defaults are applied. Unknown layouts and repeated names fail closed.
    The complete text remains in the measurement record for independent review.
    """
    result = {}
    for line in text.splitlines():
        match = re.match(r'^(.*?):\s+((?:type|size):.*)$', line)
        if not match:
            continue
        fields = dict(re.findall(r'(?:^|,)\s*(\w+):\s*([^,]+)', match.group(2)))
        if not re.fullmatch(r'\d+', fields.get('size', '')) or int(fields['size']) < 64:
            reject('unavailable', 'incomplete effective event attributes')
        name = canonical(match.group(1))
        if name in result:
            reject('semantically-invalid', 'ambiguous effective event attributes: ' + name)
        attributes = {key: 0 for key in (*FLAGS, 'inherit', 'type', 'config')}
        for key in attributes:
            if key in fields:
                # New perf versions append a symbolic description in parentheses.
                numeric = re.fullmatch(r'(0x[0-9a-fA-F]+|[0-9]+)(?:\s+\([^\n]*\))?', fields[key].strip())
                if not numeric:
                    reject('unsupported', 'unrecognized effective attribute: ' + key)
                attributes[key] = int(numeric.group(1), 0)
        attributes['size'] = int(fields['size'])
        attributes['printed_attributes'] = match.group(2)
        result[name] = attributes
    return result


def expression(text):
    """Translate perf identifiers only; never eval() perf expressions."""
    names, parts, end = {}, [], 0
    for match in TOKEN.finditer(text):
        if match.start() != end:
            reject('unsupported', 'unsupported formula syntax: ' + text)
        token = match.group()
        end = match.end()
        if token.isspace() or token in '()+*/,-' or re.fullmatch(NUMBER, token):
            parts.append(token)
        elif token in ('d_ratio', 'min', 'max'):
            parts.append(token)
        else:
            key = 'operand_' + str(len(names))
            names[key] = token
            parts.append(key)
    if end != len(text) or len(text) > 65536:
        reject('unsupported', 'unsupported formula syntax: ' + text)
    translated = ''.join(parts).strip()
    try:
        tree = ast.parse(translated, mode='eval').body
    except (SyntaxError, RecursionError):
        reject('unsupported', 'unsupported formula syntax: ' + text)
    allowed = (ast.Expression, ast.BinOp, ast.UnaryOp, ast.Call, ast.Name,
               ast.Load, ast.Constant, ast.Add, ast.Sub, ast.Mult, ast.Div,
               ast.USub, ast.UAdd)
    for node in ast.walk(tree):
        if not isinstance(node, allowed):
            reject('unsupported', 'unsupported formula operation')
        if isinstance(node, ast.Call) and (not isinstance(node.func, ast.Name) or
                node.func.id not in ('d_ratio', 'min', 'max') or node.keywords or
                (node.func.id == 'd_ratio' and len(node.args) != 2) or not node.args):
            reject('unsupported', 'unsupported formula function')
    return tree, names, translated


class Inventory:
    def __init__(self, entries):
        self.metrics, self.events = {}, {}
        self.conflicts = set()
        for entry in entries:
            if entry.get('MetricName'):
                name = entry['MetricName']
                signature = tuple(entry.get(k, '') for k in ('MetricExpr', 'ScaleUnit', 'Unit'))
                if name in self.metrics and signature != tuple(self.metrics[name].get(k, '') for k in ('MetricExpr', 'ScaleUnit', 'Unit')):
                    self.conflicts.add(name)
                self.metrics[name] = entry
            if entry.get('EventName'):
                self.events[canonical(entry['EventName'])] = entry

    def definition(self, name):
        if name in self.conflicts:
            reject('unsupported', 'conflicting pinned formula definitions: ' + name)
        if name not in self.metrics or not self.metrics[name].get('MetricExpr'):
            reject('unsupported', 'missing pinned formula: ' + name)
        return self.metrics[name]

    def leaves(self, name, stack=()):
        if name in stack or len(stack) >= 64:
            reject('unsupported', 'cyclic or excessive metric dependencies')
        _, names, _ = expression(self.definition(name)['MetricExpr'])
        leaves = set()
        for operand in names.values():
            if operand in self.metrics:
                leaves.update(self.leaves(operand, (*stack, name)))
            else:
                leaves.add(canonical(operand))
        return leaves

    def event(self, name):
        base = re.sub(r':[ukHGhp]+$', '', canonical(name))
        if base.startswith('cpu/'):
            base = base[4:].split(',')[0].rstrip('/')
        return self.events.get(base, {})

    def domain(self, name):
        leaves = self.leaves(name)
        for operand in leaves:
            entry = self.event(operand)
            unit = entry.get('Unit')
            base = re.sub(r':[ukHGhp]+$', '', operand)
            if base == 'duration_time':
                continue
            if unit not in (None, 'cpu') or (unit is None and base not in GENERIC):
                reject('unsupported', 'not a supported process-core operand: ' + operand)
        return 'explicit-domains' if any(modifiers(x) for x in leaves) else 'process-core'

    def plan(self, name, requested='auto'):
        domain = self.domain(name)
        scope = ('formula' if domain == 'explicit-domains' else 'user') if requested == 'auto' else requested
        if scope not in ('user', 'formula'):
            reject('unsupported', 'unsupported collection scope')
        if scope == 'user' and any(set(modifiers(x)) & set('khHG') for x in self.leaves(name)):
            reject('unsupported', 'explicit privilege domains cannot be overridden by --all-user')
        return {'scope': scope, 'domain': domain,
                'arguments': (['--all-user'] if scope == 'user' else []) + ['-M', name]}

    def formula_identity(self, name, stack=()):
        if name in stack or len(stack) >= 64:
            reject('unsupported', 'cyclic or excessive metric dependencies')
        definition = self.definition(name)
        result = {name: {key: definition.get(key) for key in ('MetricExpr', 'ScaleUnit', 'Unit')}}
        _, names, _ = expression(definition['MetricExpr'])
        for operand in names.values():
            if operand in self.metrics:
                result.update(self.formula_identity(operand, (*stack, name)))
        return result

    def evaluate(self, name, values, stack=()):
        if name in stack or len(stack) >= 64:
            reject('unsupported', 'cyclic or excessive metric dependencies')
        tree, names, text = expression(self.definition(name)['MetricExpr'])

        def divide(a, b):
            if b <= 0:
                reject('semantically-invalid', 'nonpositive denominator')
            return a / b

        def visit(node):
            if isinstance(node, ast.Constant) and type(node.value) in (int, float):
                return decimal(ast.get_source_segment(text, node))
            if isinstance(node, ast.Name) and node.id in names:
                operand = names[node.id]
                if operand in self.metrics:
                    # Referenced metrics are UNscaled, as in perf's formula language.
                    return self.evaluate(operand, values, (*stack, name))
                return values[canonical(operand)]
            if isinstance(node, ast.UnaryOp):
                value = visit(node.operand)
                return -value if isinstance(node.op, ast.USub) else value
            if isinstance(node, ast.BinOp):
                a, b = visit(node.left), visit(node.right)
                if isinstance(node.op, ast.Add):
                    return a + b
                if isinstance(node.op, ast.Sub):
                    return a - b
                if isinstance(node.op, ast.Mult):
                    return a * b
                if isinstance(node.op, ast.Div):
                    return divide(a, b)
            if isinstance(node, ast.Call):
                args = [visit(arg) for arg in node.args]
                if node.func.id == 'd_ratio':
                    return divide(*args)
                return min(args) if node.func.id == 'min' else max(args)
            reject('unsupported', 'unsupported expression node')
        return visit(tree)


def check_attributes(operand, attributes, scope):
    if attributes.get('inherit') != 1:
        reject('semantically-invalid', 'process descendants are not consistently counted')
    mods = modifiers(operand)
    expected = {}
    if scope == 'user':
        expected.update(exclude_user=0, exclude_kernel=1)
    elif any(x in mods for x in 'ukh'):
        expected.update(exclude_user=int('u' not in mods),
                        exclude_kernel=int('k' not in mods),
                        exclude_hv=int('h' not in mods))
    else:
        expected.update(exclude_user=0, exclude_kernel=0)
    if 'H' in mods or 'G' in mods:
        expected.update(exclude_host=int('H' not in mods), exclude_guest=int('G' not in mods))
    for field, value in expected.items():
        if attributes.get(field) != value:
            reject('semantically-invalid', 'effective privilege mismatch: ' + operand + '/' + field)


def qualify(record, inventory, historical=False):
    name = record.get('variant', record.get('metric', ''))
    result = {'metric': name, 'eligible': False, 'qualification': 'unavailable',
              'reason': '', 'value': None, 'unit': None, 'raw_formula_value': None,
              'reported_value': None, 'reported_unit_and_name': None,
              'scope': None, 'minimum_counter_duty_percent': None, 'operands': []}
    try:
        if record.get('status') is None and record.get('collector_schema') == 'buster-perf-metric-v1':
            # Re-evaluate a planned refusal; do not trust a stored qualification
            # or mislabel an unsupported, never-launched formula as a workload failure.
            inventory.plan(name)
        if record.get('status') != 0:
            reject('failed', 'collector/workload did not succeed')
        definition = inventory.definition(name)
        result['formula'] = definition['MetricExpr']
        result['scale_unit'] = definition.get('ScaleUnit', '1')
        result['formula_sha256'] = hashlib.sha256(json.dumps(
            [result['formula'], result['scale_unit'], definition.get('Unit')],
            separators=(',', ':')).encode()).hexdigest()
        result['formula_closure_sha256'] = hashlib.sha256(json.dumps(inventory.formula_identity(name), sort_keys=True, separators=(',', ':')).encode()).hexdigest()
        rows = parse_stat(record.get('perf_stat', ''))
        result['operands'] = rows
        displayed = [row for row in rows if row['display_label'].split() and row['display_label'].split()[-1] == name]
        if len(displayed) > 1:
            reject('semantically-invalid', 'ambiguous metric display')
        if displayed:
            result['reported_value'] = displayed[0]['display_value']
            result['reported_unit_and_name'] = displayed[0]['display_label']
        leaves = inventory.leaves(name)
        if not leaves:
            reject('unsupported', 'formula has no retained operands')
        scope = 'user' if historical else record.get('collection_scope')
        result['scope'] = scope
        result['scope_evidence'] = ('pinned-collector:' + ARCHIVE_COMMIT) if historical else 'perf-evlist'
        if scope not in ('user', 'formula'):
            reject('unavailable', 'collection scope not established')
        if scope == 'user' and any(set(modifiers(x)) & set('khHG') for x in leaves):
            reject('semantically-invalid', 'blanket --all-user overrides explicit privilege domains')
        attributes = {} if historical else parse_evlist(record.get('perf_evlist', ''))
        if not historical:
            argv = record.get('perf_argv', [])
            options = argv[:argv.index('--')] if '--' in argv else argv
            if any(x in options for x in ('-a', '--all-cpus', '-C', '--cpu', '-p', '--pid', '-t', '--tid', '--all-kernel')) or any(x.startswith(('--cpu=', '--pid=', '--tid=')) for x in options) or ('--all-user' in options) != (scope == 'user'):
                reject('semantically-invalid', 'command and declared scope disagree')
            if record.get('evlist_status') != 0 or not record.get('stat_data_sha256'):
                reject('unavailable', 'effective attributes are not bound to the stat capture')
        values, duties, signatures = {}, [], set()
        for operand in sorted(leaves):
            matches = [row for row in rows if canonical(row['event']) == operand or
                       (scope == 'user' and not modifiers(operand) and canonical(row['event']) == operand + ':u')]
            if len(matches) != 1:
                reject('unavailable' if not matches else 'semantically-invalid',
                       ('missing' if not matches else 'ambiguous') + ' raw operand: ' + operand)
            row = matches[0]
            value, duty, runtime = decimal(row['count']), decimal(row['duty_percent']), decimal(row['runtime_ns'])
            if value < 0 or duty < 0 or duty > 100 or runtime <= 0:
                reject('semantically-invalid', 'invalid count/runtime/duty: ' + operand)
            duties.append(duty)
            result['minimum_counter_duty_percent'] = str(min(duties))
            if duty < 99:
                reject('underscheduled', 'operand below 99% duty: ' + operand)
            if operand == 'duration_time':
                if value <= 0:
                    reject('semantically-invalid', 'zero/nonpositive duration_time')
                if row['unit'] not in ('', 'ns', 'nsec'):
                    reject('unsupported', 'unverified duration_time unit')
                # perf's raw tool counter is nanoseconds; MetricExpr consumes seconds.
                value /= Decimal(1000000000)
                sanity = record.get('time_sanity_seconds')
                if not historical and (sanity is None or decimal(sanity) <= 0 or
                        not Decimal('0.5') <= value / decimal(sanity) <= Decimal('2')):
                    reject('semantically-invalid', 'duration fails independent workload-time sanity check')
            else:
                if row['unit']:
                    reject('unsupported', 'unverified raw operand unit: ' + operand + '/' + row['unit'])
                entry = inventory.event(operand)
                row['encoding'] = entry.get('Encoding')
                if not historical:
                    attr = attributes.get(canonical(row['event']))
                    if attr is None:
                        reject('unavailable', 'missing effective attributes: ' + operand)
                    row['effective_attributes'] = attr
                    check_attributes(operand, attr, scope)
                    if not modifiers(operand):
                        signatures.add(tuple(attr[x] for x in FLAGS))
            values[operand] = value
        inventory.domain(name)  # No process/core mixing with system or uncore operands.
        if len(signatures) > 1:
            reject('semantically-invalid', 'inconsistent operand privilege scopes')
        scale = re.fullmatch('(' + NUMBER + r')(.*)', result['scale_unit'])
        if not scale:
            reject('unsupported', 'unverified metric scale/unit')
        factor, unit = decimal(scale.group(1)), scale.group(2)
        if factor <= 0:
            reject('unsupported', 'nonpositive metric scale')
        if displayed and displayed[0]['display_label'] != (unit + '  ' + name).strip():
            reject('semantically-invalid', 'display unit disagrees with pinned metric unit')
        with localcontext() as context:
            context.prec = 34
            raw = inventory.evaluate(name, values)
            value = raw * factor
        if not value.is_finite() or value < 0 or (unit.startswith('%') and value > 100):
            reject('semantically-invalid', 'derived value outside the metric domain')
        state = 'genuine-zero' if value == 0 else 'valid'
        printed = result['reported_value']
        if value != 0 and printed:
            try:
                if Decimal(printed).is_finite() and Decimal(printed) == 0:
                    state = 'rounded-to-zero'
            except InvalidOperation:
                pass
        result.update(eligible=True, qualification=state, value=str(value),
                      raw_formula_value=str(raw), unit=unit)
    except Rejected as error:
        result.update(qualification=error.state, reason=error.reason)
    except (InvalidOperation, OverflowError, RecursionError, KeyError) as error:
        result.update(qualification='unsupported', reason='unresolved formula prerequisite: ' + str(error))
    return result
