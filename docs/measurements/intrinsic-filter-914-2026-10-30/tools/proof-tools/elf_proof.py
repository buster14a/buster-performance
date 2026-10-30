#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
"""Fail-closed ELF object translation proof; no assembler or compiler is run.

The proof accepts ELF64 little-endian x86-64 ET_REL objects with one .symtab,
RELA relocations and unique section names. It proves a structural translation,
not execution or linker equivalence: the hot section gains exactly S zero bytes,
its old bytes and ordinary defined symbols translate by S, and relocation sites
and direct section-relative targets translate consistently. All other section
bytes and symbol properties stay exact. Physical section/symbol/string-table
ordering can differ. Only nonalloc .comment contents and unreferenced STT_FILE
producer records may differ, and these are disclosed in the result.

REL, COMDAT/groups, compressed sections, extended ELF indices, dynamic object
relocations, TLS descriptor relocations, unknown relocation types and ambiguous
named symbols are refused.
GOT/TLS/SIZE relocations to the hot *section symbol* are refused: their addends
do not necessarily denote code addresses. Named targets retain exact addends.
Direct section-symbol references require A'=A+S (including PC-relative -4 bias).
The proof does not turn a named-symbol relocation into a section-symbol one.
.llvm_addrsig is compared after ULEB128 symbol-identity normalization; its
presence, including empty presence, is significant. .note.GNU-stack and all
other notes/debug/unrecognized nonalloc data are compared, never discarded.

Public reader: load_elf(path_or_bytes), also reads ET_EXEC/ET_DYN for a separate
linked-address gate. Its Section/Symbol/Relocation records expose ELF metadata.
Object proof: compare_objects(base, variant, hot_section, shift) -> JSON dict;
malformed/unsupported/different inputs raise ProofError. CLI prints JSON and
returns nonzero on refusal. No target instructions are executed.
"""
from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import struct
from typing import Union


class ProofError(ValueError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ProofError(message)


@dataclass(frozen=True)
class Section:
    index: int
    name: str
    type: int
    flags: int
    addr: int
    offset: int
    size: int
    link: int
    info: int
    align: int
    entsize: int
    data: bytes


@dataclass(frozen=True)
class Symbol:
    table: int
    index: int
    name: str
    bind: int
    type: int
    other: int
    section: int
    value: int
    size: int


@dataclass(frozen=True)
class Relocation:
    section: int
    target_section: int
    offset: int
    type: int
    symbol: Symbol
    addend: int


@dataclass(frozen=True)
class ELF:
    data: bytes
    ident: bytes
    elf_type: int
    machine: int
    version: int
    entry: int
    flags: int
    sections: list[Section]
    symbols: list[Symbol]
    relocations: list[Relocation]
    shstr_index: int

    def section_named(self, name: str) -> Section:
        found = [s for s in self.sections if s.name == name]
        require(len(found) == 1, f"section {name!r} is missing or ambiguous")
        return found[0]


def _span(data: bytes, offset: int, size: int, what: str) -> bytes:
    require(0 <= offset <= len(data) and 0 <= size <= len(data) - offset,
            f"out-of-file {what}")
    return data[offset:offset + size]


def _name(strings: bytes, offset: int, what: str) -> str:
    require(0 <= offset < len(strings), f"bad string offset for {what}")
    end = strings.find(b"\0", offset)
    require(end >= 0, f"unterminated string for {what}")
    # Byte-preserving identities; no locale-dependent or lossy decoding.
    return strings[offset:end].decode("latin1")


def load_elf(source: Union[str, Path, bytes, bytearray]) -> ELF:
    data = bytes(source) if isinstance(source, (bytes, bytearray)) else Path(source).read_bytes()
    require(len(data) >= 64, "short ELF header")
    h = struct.unpack_from("<16sHHIQQQIHHHHHH", data)
    ident, kind, machine, version, entry, phoff, shoff, flags, ehsize, phsize, phnum, shsize, shnum, shstr = h
    require(ident[:7] == b"\x7fELF\x02\x01\x01", "requires ELF64 little-endian version 1")
    require(kind in (1, 2, 3) and machine == 62 and version == 1, "requires x86-64 ELF REL/EXEC/DYN")
    require(ehsize == 64 and shsize == 64 and 0 < shnum < 0xff00 and shstr < shnum and phnum != 0xffff,
            "unsupported ELF header/extended section indices")
    require(phnum == 0 or phsize == 56, "invalid program-header size")
    _span(data, phoff, phnum * phsize, "program headers")
    _span(data, shoff, shnum * shsize, "section headers")
    rows = [struct.unpack_from("<IIQQQQIIQQ", data, shoff + i * shsize) for i in range(shnum)]
    require(rows[0] == (0,) * 10, "nonempty/extended null section")
    names_row = rows[shstr]
    require(names_row[1] == 3, "section-name table is not STRTAB")
    strings = _span(data, names_row[4], names_row[5], "section names")
    sections = []
    occupied = [(0, 64), (shoff, shoff + shnum * shsize)]
    if phnum:
        occupied.append((phoff, phoff + phnum * phsize))
    for i, r in enumerate(rows):
        name, typ, sflags, addr, offset, size, link, info, align, entsize = r
        require(align == 0 or align & (align - 1) == 0, "non-power-of-two alignment")
        require(offset % max(align, 1) == 0 or typ in (0, 8), "misaligned section")
        require(link < shnum, "bad section link")
        payload = b"" if typ == 8 else _span(data, offset, size, f"section {i}")
        if typ != 8 and size:
            occupied.append((offset, offset + size))
        sections.append(Section(i, _name(strings, name, f"section {i}"), typ, sflags,
                                addr, offset, size, link, info, align, entsize, payload))
    require(len({s.name for s in sections}) == len(sections), "duplicate section names")
    occupied.sort()
    require(all(occupied[i - 1][1] <= occupied[i][0] for i in range(1, len(occupied))), "overlapping ELF file regions")
    symbols = []
    tables = {}
    for s in sections:
        if s.type not in (2, 11):
            continue
        require(s.entsize == 24 and s.size % 24 == 0 and sections[s.link].type == 3,
                "bad symbol table")
        strings = sections[s.link].data
        table = []
        for index in range(s.size // 24):
            name, info, other, section, value, size = struct.unpack_from("<IBBHQQ", s.data, index * 24)
            require(section < shnum or section in (0xfff1, 0xfff2), "unsupported symbol section index")
            symbol = Symbol(s.index, index, _name(strings, name, "symbol"), info >> 4,
                            info & 15, other, section, value, size)
            table.append(symbol)
        require(table and table[0] == Symbol(s.index, 0, "", 0, 0, 0, 0, 0, 0), "bad null symbol")
        require(s.info <= len(table), "bad local-symbol boundary")
        require(all((x.bind == 0) == (x.index < s.info) for x in table[1:]), "bad local-symbol ordering")
        tables[s.index] = table
        symbols.extend(table)
    relocations = []
    for s in sections:
        require(s.type != 9, "SHT_REL implicit addends are unsupported")
        if s.type != 4:
            continue
        require(s.link in tables and 0 <= s.info < shnum and (kind != 1 or s.info != 0) and s.entsize == 24 and s.size % 24 == 0,
                "bad RELA table")
        table = tables[s.link]
        for i in range(s.size // 24):
            offset, info, addend = struct.unpack_from("<QQq", s.data, i * 24)
            index, typ = info >> 32, info & 0xffffffff
            require(index < len(table), "bad relocation symbol index")
            relocations.append(Relocation(s.index, s.info, offset, typ, table[index], addend))
    return ELF(data, ident, kind, machine, version, entry, flags, sections, symbols, relocations, shstr)


# AMD64 psABI field widths. Dynamic-only relocations are deliberately absent.
WIDTHS = {1: 8, 2: 4, 3: 4, 4: 4, 9: 4, 10: 4, 11: 4, 12: 2, 13: 2,
          14: 1, 15: 1, 16: 8, 17: 8, 18: 8, 19: 4, 20: 4, 21: 4, 22: 4,
          23: 4, 24: 8, 25: 8, 26: 4, 27: 8, 28: 8, 29: 8, 30: 8, 31: 8,
          32: 4, 33: 8, 39: 4, 40: 4, 41: 4, 42: 4}
# Local STT_SECTION PLT32 references cannot be preempted. Their target is
# section+addend, with the same four-byte PC-relative field as PC32. Section
# symbol locality/value/size is checked by _symbol_identity; final signed32
# displacement and actual linked targets are checked separately by check_linked.
DIRECT_SECTION_TYPES = {1, 2, 4, 10, 11, 12, 13, 14, 15, 24}
PC_TYPES = {2, 4, 13, 15, 24}
ADDRSIG = 0x6fff4c03


def _section_identity(elf: ELF, index: int):
    if index == 0:
        return ("special", "undefined")
    if index == 0xfff1:
        return ("special", "absolute")
    if index == 0xfff2:
        return ("special", "common")
    return elf.sections[index].name


def _symbol_identity(elf: ELF, symbol: Symbol, hot: str, shift: int) -> tuple:
    section = _section_identity(elf, symbol.section)
    value = symbol.value
    if symbol.type == 3:
        require(symbol.bind == 0 and symbol.value == 0 and symbol.size == 0 and 0 < symbol.section < len(elf.sections),
                "unsupported section symbol")
    elif section == hot:
        require(value >= shift, "hot symbol is in the inserted prefix")
        value -= shift
    require(symbol.type in (0, 1, 2, 3, 4, 5, 6, 10), "unknown symbol type")
    require(symbol.bind in (0, 1, 2, 10), "unknown symbol binding")
    require(symbol.other & ~3 == 0, "unsupported symbol visibility bits")
    if 0 < symbol.section < len(elf.sections) and symbol.type != 3:
        require(symbol.value <= elf.sections[symbol.section].size and symbol.size <= elf.sections[symbol.section].size - symbol.value,
                "defined symbol extends past its section")
    return (symbol.name, symbol.bind, symbol.type, symbol.other, section, value, symbol.size)


def _uleb_values(data: bytes) -> list[int]:
    result = []
    i = 0
    while i < len(data):
        value = 0
        bits = 0
        start = i
        while True:
            require(i < len(data) and bits < 64, "malformed .llvm_addrsig ULEB128")
            byte = data[i]
            i += 1
            value |= (byte & 127) << bits
            if byte < 128:
                require(value < 1 << 64, "overflowing .llvm_addrsig ULEB128")
                require(i - start == 1 or byte != 0, "noncanonical .llvm_addrsig ULEB128")
                result.append(value)
                break
            bits += 7
    return result


def _validate_object(elf: ELF) -> Section:
    require(elf.elf_type == 1 and elf.entry == 0, "object comparison requires ET_REL")
    require(struct.unpack_from("<H", elf.data, 56)[0] == 0, "ET_REL has program headers")
    symtabs = [s for s in elf.sections if s.type == 2]
    require(len(symtabs) == 1 and all(s.type != 11 for s in elf.sections), "requires exactly one SYMTAB")
    for s in elf.sections:
        require(s.addr == 0, "ET_REL section has a nonzero address")
        require(s.type not in (17, 18) and not s.flags & (0x200 | 0x800), "groups/extended/compressed sections unsupported")
        if s.type in (2, 4) or s.index in (elf.shstr_index, symtabs[0].link):
            require(not s.flags & 2, "allocatable symbol/string/relocation metadata unsupported")
        if s.type not in (2, 4, ADDRSIG):
            require(s.link == 0, "unmodeled linked section metadata")
    return symtabs[0]


def compare_objects(base, variant, hot_section=".text.buster_checker", shift=0) -> dict:
    require(isinstance(shift, int) and 0 <= shift <= 1 << 30, "invalid shift")
    a, b = load_elf(base), load_elf(variant)
    at, bt = _validate_object(a), _validate_object(b)
    require((a.ident, a.machine, a.version, a.flags) == (b.ident, b.machine, b.version, b.flags), "ELF identity changed")
    ah, bh = a.section_named(hot_section), b.section_named(hot_section)
    require(ah.type == bh.type == 1 and ah.flags & 6 == 6 and ah.align == bh.align == 4096,
            "hot section must be executable/allocatable PROGBITS aligned to 4096")
    require(bh.size == ah.size + shift and bh.data[:shift] == b"\0" * shift and bh.data[shift:] == ah.data,
            "hot section is not an exact zero-prefix translation")
    disclosures = []
    sa, sb = {s.name: s for s in a.sections}, {s.name: s for s in b.sections}
    comments = [s for e in (a, b) for s in e.sections if s.name == ".comment"]
    require(all(s.flags & ~0x30 == 0 and s.type == 1 and s.link == s.info == 0 and
                s.align in (0, 1) and s.entsize in (0, 1) for s in comments), "semantic .comment section")
    if (sa.get(".comment"), sb.get(".comment")) and (".comment" in sa or ".comment" in sb):
        if ".comment" not in sa or ".comment" not in sb or sa[".comment"].data != sb[".comment"].data:
            disclosures.append("nonalloc .comment producer bytes/presence differ")
    require(set(sa) - {".comment"} == set(sb) - {".comment"}, "section inventory changed")
    ids = []
    for elf, hot_shift, table in ((a, 0, at), (b, shift, bt)):
        by_index = {}
        records = []
        for sym in (s for s in elf.symbols if s.table == table.index):
            identity = _symbol_identity(elf, sym, hot_section, hot_shift)
            by_index[sym.index] = identity
            if sym.type == 4:
                require(sym.bind == 0 and sym.section == 0xfff1 and sym.value == sym.size == 0,
                        "unexpected STT_FILE semantics")
            else:
                records.append(identity)
        require(len(records) == len(set(records)), "duplicate/ambiguous symbol identity")
        ids.append((by_index, Counter(records)))
    require(ids[0][1] == ids[1][1], "symbol identity/value/size/binding changed")
    files_a = Counter(s.name for s in a.symbols if s.type == 4)
    files_b = Counter(s.name for s in b.symbols if s.type == 4)
    if files_a != files_b:
        disclosures.append("unreferenced STT_FILE producer records differ")
    # Reject same-name ambiguity even where differing offsets would disambiguate
    # the full tuple; linked function ownership must never guess among aliases.
    for identities, _ in ids:
        names = [x[0] for x in identities.values() if x[0] and x[2] != 4]
        require(len(names) == len(set(names)), "ambiguous named symbols")
    normalized_relocations = []
    for elf, delta, index_ids in ((a, 0, ids[0][0]), (b, shift, ids[1][0])):
        tuples = []
        fields = {}
        for rel in elf.relocations:
            require(rel.type in WIDTHS, f"unsupported relocation type {rel.type}")
            require(rel.symbol.table == (at.index if elf is a else bt.index), "relocation uses another symbol table")
            require(rel.symbol.type != 4, "relocation to STT_FILE producer metadata")
            target = elf.sections[rel.target_section]
            require(target.name != ".comment" and _section_identity(elf, rel.symbol.section) != ".comment",
                    "relocation involving ignored producer bytes")
            width = WIDTHS[rel.type]
            file_backed = target.type in (1, 14, 15, 16) or (target.name == ".eh_frame" and target.type == 0x70000001)
            require(file_backed and rel.offset + max(width, 1) <= target.size,
                    "relocation field outside supported file-backed content")
            used = fields.setdefault(target.index, [])
            used.append((rel.offset, rel.offset + max(width, 1)))
            offset = rel.offset
            if target.name == hot_section:
                require(offset >= delta, "relocation is in inserted hot prefix")
                offset -= delta
            addend = rel.addend
            if rel.symbol.type == 3 and _section_identity(elf, rel.symbol.section) == hot_section:
                require(rel.type in DIRECT_SECTION_TYPES, "non-direct relocation to hot section symbol")
                addend -= delta
                bias = width if rel.type in PC_TYPES else 0
                require(-bias <= addend <= ah.size, "hot section-symbol addend outside bounded direct target")
            tuples.append((elf.sections[rel.section].name, target.name, offset, rel.type, index_ids[rel.symbol.index], addend))
        for intervals in fields.values():
            intervals.sort()
            require(all(intervals[i - 1][1] <= intervals[i][0] for i in range(1, len(intervals))), "overlapping relocation fields")
        normalized_relocations.append(Counter(tuples))
    require(normalized_relocations[0] == normalized_relocations[1], "normalized relocations changed")
    strtabs = {a.sections[a.shstr_index].name, a.sections[at.link].name}
    require(strtabs == {b.sections[b.shstr_index].name, b.sections[bt.link].name}, "string-table ownership changed")
    for name in sorted(set(sa) & set(sb)):
        if name == ".comment":
            continue
        x, y = sa[name], sb[name]
        link_a = a.sections[x.link].name if x.link else ""
        link_b = b.sections[y.link].name if y.link else ""
        info_a, info_b = x.info, y.info
        if x.type == y.type == 4:
            info_a, info_b = a.sections[x.info].name, b.sections[y.info].name
        if x.type == y.type == 2:
            info_a = info_b = "<normalized-local-symbol-boundary>"
        require((x.type, x.flags, x.align, x.entsize, link_a, info_a) ==
                (y.type, y.flags, y.align, y.entsize, link_b, info_b), f"section attributes changed: {name}")
        if x.type == 2 or name in strtabs or x.type == 4:
            if x.data != y.data:
                disclosures.append(f"{name}: normalized symbol/string/RELA encoding differs")
        elif x.type == ADDRSIG:
            require(x.link == at.index and y.link == bt.index and not (x.flags | y.flags) & 2,
                    "unsupported .llvm_addrsig ownership")
            left = _uleb_values(x.data)
            right = _uleb_values(y.data)
            require(all(i in ids[0][0] and ids[0][0][i][2] != 4 for i in left) and
                    all(i in ids[1][0] and ids[1][0][i][2] != 4 for i in right), "bad .llvm_addrsig symbol")
            require(Counter(ids[0][0][i] for i in left) == Counter(ids[1][0][i] for i in right), ".llvm_addrsig target identities changed")
        elif name == hot_section:
            pass  # Exact prefix/suffix and size proved above.
        else:
            require(x.size == y.size and x.data == y.data, f"section bytes/size changed: {name}")
    return {"passed": True, "kind": "ET_REL hot-section structural translation",
            "hot_section": hot_section, "shift": shift, "hot_bytes_before": ah.size,
            "hot_alignment": ah.align, "symbols_compared": sum(ids[0][1].values()),
            "relocations_compared": sum(normalized_relocations[0].values()),
            "base_sha256": hashlib.sha256(a.data).hexdigest(),
            "variant_sha256": hashlib.sha256(b.data).hexdigest(),
            "disclosed_nonsemantic_differences": disclosures}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["object"])
    parser.add_argument("base")
    parser.add_argument("variant")
    parser.add_argument("--hot-section", default=".text.buster_checker")
    parser.add_argument("--shift", type=int, required=True)
    args = parser.parse_args()
    try:
        result = compare_objects(args.base, args.variant, args.hot_section, args.shift)
    except (ProofError, OSError, struct.error) as error:
        print(json.dumps({"passed": False, "error": str(error)}, sort_keys=True))
        return 1
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
