#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
"""Prove object-qualified hot-function geometry and linked nonrelocation bytes.

This does not execute the image. Structural object/relocation translation must
pass separately. Ambiguous final symbol identities fail rather than guessing
which object a duplicated local name came from. Normal/zero SHA gates belong
to the caller and cannot be replaced by this narrower comparison.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from elf_proof import ProofError, WIDTHS, load_elf, require


def linked_gate(original_object, normal_image, shifted_image, shift, required):
    require(shift in (0, 16, 64, 256, 1024, 2048), "unapproved shift")
    obj, normal, variant = map(load_elf, (original_object, normal_image, shifted_image))
    require(obj.elf_type == 1 and normal.elf_type == variant.elf_type == 2, "requires REL and non-PIE EXEC images")
    address_limit = 1 << 64
    for elf in (normal, variant):
        require(all(section.addr < address_limit and section.size <= address_limit - section.addr
                    for section in elf.sections if section.flags & 2), "allocated section exceeds ELF64 address range")
    hot = obj.section_named(".text.buster_checker")
    require(hot.type == 1 and hot.align == 4096 and (hot.flags & 6) == 6, "hot object section must remain file-backed/allocated/executable/page-aligned")
    members = [s for s in obj.symbols if s.section == hot.index and s.type == 2]
    require(members, "no owned hot functions")
    require(all(s.name for s in members), "unnamed hot function cannot be bound to final ownership")
    require(hot.size > 0 and all(s.value <= hot.size and s.size <= hot.size - s.value for s in members), "owned function outside hot section")
    require(len({s.name for s in members}) == len(members), "ambiguous owned hot function names")
    required = set(required) | {"check_program_emit", "check_lower_drain", "check_lower_batch_classify"}
    require(required <= {s.name for s in members}, "required function is not owned by selected object's hot section")

    def index_symbols(elf):
        result = {}
        for symbol in elf.symbols:
            if elf.sections[symbol.table].type == 2 and 0 < symbol.section < len(elf.sections):
                key = (symbol.name, symbol.type, symbol.bind, symbol.other, symbol.size)
                result.setdefault(key, []).append(symbol)
        return result

    normal_index, variant_index = index_symbols(normal), index_symbols(variant)

    # Establish the selected input contribution independently from every owned
    # function whose full identity is globally unique. Only then may a duplicated
    # local name be selected at its proved base+object-offset address.
    anchors = []
    for index in (normal_index, variant_index):
        candidates = set()
        for member in members:
            found = index.get((member.name, member.type, member.bind, member.other, member.size), [])
            if len(found) == 1:
                candidates.add(found[0].value - member.value)
        require(len(candidates) == 1, "missing/inconsistent unambiguous hot ownership anchors")
        anchors.append(next(iter(candidates)))
    require(anchors[1] - anchors[0] == shift and anchors[0] % 4096 == 0,
            "independent hot ownership anchors do not prove requested translation")

    def final_symbol(index, member, anchor):
        found = [symbol for symbol in index.get((member.name, member.type, member.bind, member.other, member.size), [])
                 if symbol.value == anchor + member.value]
        require(len(found) == 1, f"missing/ambiguous final function {member.name}")
        return found[0]

    bases, shifted_bases = set(), set()
    records = []
    final_members = []
    for member in members:
        a, b = final_symbol(normal_index, member, anchors[0]), final_symbol(variant_index, member, anchors[1])
        require((normal.sections[a.section].flags & 6) == 6 and (variant.sections[b.section].flags & 6) == 6,
                "final function is outside allocated executable code")
        for elf, symbol in ((normal, a), (variant, b)):
            section = elf.sections[symbol.section]
            require(section.addr <= symbol.value <= section.addr + section.size and
                    symbol.size <= section.addr + section.size - symbol.value and
                    symbol.size <= address_limit - symbol.value, "function extent is outside its declared final section")
        require(b.value - a.value == shift, f"wrong final hot delta: {member.name}")
        bases.add(a.value - member.value)
        shifted_bases.add(b.value - member.value - shift)
        final_members.append((a, b))
        records.append({"name": member.name, "object_offset": member.value, "size": member.size,
                        "normal_address": a.value, "shifted_address": b.value,
                        "delta": b.value - a.value, "residue_4096": b.value % 4096})
    require(len(bases) == len(shifted_bases) == 1 and bases == shifted_bases, "input hot section is not one translated contribution")
    base = next(iter(bases))
    require(0 <= base < address_limit and hot.size + shift <= address_limit - base and base % 4096 == 0,
            "linked hot input contribution lost page alignment/address bounds")

    def image_range(elf, address, length):
        found = [s for s in elf.sections if s.type == 1 and (s.flags & 6) == 6 and s.addr <= address and
                 address + length <= s.addr + s.size]
        require(len(found) == 1, "hot contribution is not one file-backed executable range")
        section = found[0]
        return section, section.data[address - section.addr:address - section.addr + length]

    normal_section, normal_bytes = image_range(normal, base, hot.size)
    variant_section, variant_bytes = image_range(variant, base, hot.size + shift)
    require(all(a.section == normal_section.index and b.section == variant_section.index for a, b in final_members),
            "owned function does not belong to the proved final hot contribution")
    a = bytearray(normal_bytes)
    prefix = variant_bytes[:shift]
    require(prefix == bytes(shift), "inside padding was dropped/changed in final image")
    b = bytearray(variant_bytes[shift:])
    masked = []
    for rel in obj.relocations:
        if rel.target_section != hot.index:
            continue
        require(rel.type in WIDTHS, "unknown hot relocation width")
        width = WIDTHS[rel.type]
        require(0 <= rel.offset <= hot.size - width, "hot relocation outside code")
        a[rel.offset:rel.offset + width] = bytes(width)
        b[rel.offset:rel.offset + width] = bytes(width)
        masked.append({"offset": rel.offset, "width": width, "type": rel.type})
    require(a == b, "linked hot instructions/alignment bytes changed outside proved relocation operands")
    # Prove actual wild output for each local-section PLT32 reference to hot
    # code, independently of the object addend/site normalization. Require the
    # final signed32 displacement to be S+A-P, without a PLT redirection.
    local_plt = []
    contributions = {hot.index: (base, base)}
    for rel in obj.relocations:
        if rel.type != 4 or rel.symbol.type != 3 or rel.symbol.section != hot.index:
            continue
        require(rel.symbol.bind == 0 and rel.symbol.value == rel.symbol.size == 0,
                "PLT32 hot section target is not local and nonpreemptible")
        section = obj.sections[rel.target_section]
        require(section.type == 1 and (section.flags & 6) == 6,
                "local hot PLT32 source is not executable PROGBITS")
        if section.index not in contributions:
            owned = [s for s in obj.symbols if s.section == section.index and s.type == 2 and s.name]
            normal_bases, variant_bases = set(), set()
            for member in owned:
                key = (member.name, member.type, member.bind, member.other, member.size)
                na, va = normal_index.get(key, []), variant_index.get(key, [])
                if len(na) == len(va) == 1:
                    normal_bases.add(na[0].value - member.value)
                    variant_bases.add(va[0].value - member.value)
            require(len(normal_bases) == len(variant_bases) == 1,
                    "ambiguous/missing ownership for local PLT32 source contribution")
            contributions[section.index] = (next(iter(normal_bases)), next(iter(variant_bases)))
        source_bases = contributions[section.index]
        require(-4 <= rel.addend <= hot.size - 4,
                "local hot PLT32 code target outside original hot contribution")
        observations = []
        for elf, source_base, delta in ((normal, source_bases[0], 0), (variant, source_bases[1], shift)):
            site = source_base + rel.offset + (delta if section.index == hot.index else 0)
            expected = base + rel.addend + delta - site
            require(-(1 << 31) <= expected < (1 << 31), "local hot PLT32 exceeds signed32 span")
            _, data = image_range(elf, site, 4)
            actual = struct.unpack("<i", data)[0]
            require(actual == expected, "wild local hot PLT32 linked target differs from S+A-P")
            observations.append({"site": site, "displacement": actual, "target_next_ip": site + 4 + actual})
        local_plt.append({"source_section": section.name, "object_offset": rel.offset,
                          "object_addend": rel.addend, "normal": observations[0], "variant": observations[1]})
    return {"passed": True, "kind": "object-qualified linked hot geometry and code", "shift": shift,
            "hot_section": hot.name, "hot_input_base": base, "hot_bytes": hot.size,
            "functions": records, "masked_relocation_operands": masked,
            "proved_local_hot_plt32_targets": local_plt,
            "object_sha256": hashlib.sha256(obj.data).hexdigest(),
            "normal_final_section": normal_section.name, "variant_final_section": variant_section.name,
            "normal_sha256": hashlib.sha256(normal.data).hexdigest(),
            "variant_sha256": hashlib.sha256(variant.data).hexdigest(),
            "scope": "requires separate full object relocation translation proof; no execution/semantic oracle"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("object")
    parser.add_argument("normal")
    parser.add_argument("variant")
    parser.add_argument("--shift", type=int, required=True)
    parser.add_argument("--required", action="append", default=[])
    args = parser.parse_args()
    try:
        result = linked_gate(args.object, args.normal, args.variant, args.shift, args.required)
    except (ProofError, OSError, ValueError, struct.error) as error:
        print(json.dumps({"passed": False, "error": str(error)}))
        return 1
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
