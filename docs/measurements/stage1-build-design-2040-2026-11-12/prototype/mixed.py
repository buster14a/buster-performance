#!/usr/bin/env python3
# Applies the measurement-only "mixed toolchain" change to a clone's cmake/BusterCodegen.cmake (buster#2040's record):
# with BUSTER_2040_MIXED set in the environment at configure time, llvm-config, clang++, llvm-nm, llvm-objcopy and
# llvm-readobj are the host's own (/usr/bin) whatever clang is configured, and a tool passes the version check when its
# major and minor version are the configured clang's. So CI's staged clang 23.1.4, which ships no LLVM library the
# splitter can link and no llvm-nm or llvm-objcopy, can compile the units and the parts while the splitter is built
# against the host's LLVM 23.1.1. Without the variable the build is unchanged.
import sys
path = sys.argv[1]
s = open(path).read()
old1 = '''        find_program(program NAMES "${name}" HINTS "${directory}" NO_CACHE NO_DEFAULT_PATH)
        if(NOT program)
            find_program(program NAMES "${name}" NO_CACHE)
        endif()
'''
new1 = '''        if(DEFINED ENV{BUSTER_2040_MIXED} AND NOT tool STREQUAL "LLD")
            find_program(program NAMES "${name}" PATHS /usr/bin NO_CACHE NO_DEFAULT_PATH)
        else()
            find_program(program NAMES "${name}" HINTS "${directory}" NO_CACHE NO_DEFAULT_PATH)
        endif()
        if(NOT program)
            find_program(program NAMES "${name}" NO_CACHE)
        endif()
'''
old2 = '''        if(NOT program OR NOT status EQUAL 0 OR NOT version VERSION_EQUAL CMAKE_C_COMPILER_VERSION)
'''
new2 = '''        if(DEFINED ENV{BUSTER_2040_MIXED} AND program AND status EQUAL 0)
            string(REGEX MATCH "^[0-9]+\\\\.[0-9]+" mixed_tool "${version}")
            string(REGEX MATCH "^[0-9]+\\\\.[0-9]+" mixed_clang "${CMAKE_C_COMPILER_VERSION}")
            if(mixed_tool STREQUAL mixed_clang)
                set(version "${CMAKE_C_COMPILER_VERSION}")
            endif()
        endif()
        if(NOT program OR NOT status EQUAL 0 OR NOT version VERSION_EQUAL CMAKE_C_COMPILER_VERSION)
'''
assert s.count(old1) == 1 and s.count(old2) == 1, (s.count(old1), s.count(old2))
s = s.replace(old1, new1).replace(old2, new2)
open(path + '.new', 'w').write(s)
import os
os.replace(path + '.new', path)
print('patched', path)
