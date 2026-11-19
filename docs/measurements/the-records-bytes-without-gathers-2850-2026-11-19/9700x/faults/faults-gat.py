#!/usr/bin/env python3
# faults-gat.py FILE [N]: the sweep piece's faults (c_check_node_census.c's four columns by loads and permutes), one
# at a time: with no N, print how many; with N, apply fault N to FILE in place and print its name.
import sys
faults = []
# Each of the permute's sixteen indices names another record's dword: the other record of its register (its `+ 8`
# dropped or added). And one a column names another register's record (its `16 +` dropped).
def column(index, change):
    def apply(t):
        head = "const __m512i columns = _mm512_set_epi32("
        a = t.index(head) + len(head)
        b = t.index(");", a)
        arguments = [x.strip() for x in t[a:b].split(',')]
        assert len(arguments) == 16
        k = 15 - index
        before = arguments[k]
        if change == 'record':
            arguments[k] = before[:-4] if before.endswith(' + 8') else before + ' + 8'
        else:
            assert before.startswith('16 + ')
            arguments[k] = before[5:]
        assert arguments[k] != before
        return t[:a] + ', '.join(arguments) + t[b:]
    return apply
for i in range(16):
    faults.append(('column-%d-other-record' % i, column(i, 'record'), None))
for name, i in (('word', 2), ('flags', 6), ('object', 10), ('standing', 14)):
    faults.append(('column-%s-other-register' % name, column(i, 'register'), None))
# The lane shuffles' selections.
faults.append(('low-words-flags-selection', "_mm512_shuffle_i32x4(fours[0], fours[1], 0x44)", "_mm512_shuffle_i32x4(fours[0], fours[1], 0x40)"))
faults.append(('high-words-flags-selection', "_mm512_shuffle_i32x4(fours[2], fours[3], 0x44)", "_mm512_shuffle_i32x4(fours[2], fours[3], 0x04)"))
faults.append(('low-objects-standings-selection', "_mm512_shuffle_i32x4(fours[0], fours[1], 0xee)", "_mm512_shuffle_i32x4(fours[0], fours[1], 0xe4)"))
faults.append(('high-objects-standings-selection', "_mm512_shuffle_i32x4(fours[2], fours[3], 0xee)", "_mm512_shuffle_i32x4(fours[2], fours[3], 0x4e)"))
faults.append(('words-selection', "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0x88)", "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0x80)"))
faults.append(('flags-selection', "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0xdd)", "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0x8d)"))
faults.append(('objects-selection', "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0x88)", "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0x08)"))
faults.append(('standings-selection', "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0xdd)", "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0xd8)"))
# The placed records' mask, a column.
faults.append(('words-not-masked', "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0x88)", "_mm512_shuffle_i32x4(words_flags_low, words_flags_high, 0x88)"))
faults.append(('flags-not-masked', "_mm512_maskz_shuffle_i32x4(placed, words_flags_low, words_flags_high, 0xdd)", "_mm512_shuffle_i32x4(words_flags_low, words_flags_high, 0xdd)"))
faults.append(('objects-not-masked', "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0x88)", "_mm512_shuffle_i32x4(objects_standings_low, objects_standings_high, 0x88)"))
faults.append(('standings-not-masked', "_mm512_maskz_shuffle_i32x4(placed, objects_standings_low, objects_standings_high, 0xdd)", "_mm512_shuffle_i32x4(objects_standings_low, objects_standings_high, 0xdd)"))
# The loads' places and the permute's two registers.
faults.append(('second-record-load', "_mm256_loadu_si256((const __m256i*)(const void*)(at + sizeof(NodeFactsRecord))), 1);", "_mm256_loadu_si256((const __m256i*)(const void*)(at)), 1);"))
faults.append(('third-record-load', "(const void*)(at + 2 * sizeof(NodeFactsRecord))", "(const void*)(at + sizeof(NodeFactsRecord))"))
faults.append(('fourth-record-load', "(const void*)(at + 3 * sizeof(NodeFactsRecord))", "(const void*)(at + 2 * sizeof(NodeFactsRecord))"))
faults.append(('four-records-step', "base + 4 * sizeof(NodeFactsRecord) * (uint64_t)four", "base + 2 * sizeof(NodeFactsRecord) * (uint64_t)four"))
faults.append(('permute-registers-swapped', "_mm512_permutex2var_epi32(first, columns, second)", "_mm512_permutex2var_epi32(second, columns, first)"))
path = sys.argv[1]
if len(sys.argv) < 3:
    t = open(path).read()
    for name, old, new in faults:
        if callable(old):
            assert old(t) != t, name
        else:
            assert t.count(old) == 1, (name, t.count(old))
    print(len(faults))
else:
    name, old, new = faults[int(sys.argv[2])]
    t = open(path).read()
    if callable(old):
        changed = old(t)
    else:
        assert t.count(old) == 1, (name, t.count(old))
        changed = t.replace(old, new)
    assert changed != t, name
    open(path, 'w').write(changed)
    print(name)
