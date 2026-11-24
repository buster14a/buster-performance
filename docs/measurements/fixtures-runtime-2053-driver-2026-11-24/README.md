# Complete driver program extraction for Buster #2053

The driver packet compares `fa263aba2` and `f0979f0f1`. The pinned Clang 23.1.4 dumper reproduced all 107 inputs and expectations (57,266 bytes, 44 catalog groups). The host owner lost a net 86,069 source bytes. The checker object changed from 30,478,232 to 30,426,984 bytes and the executable from 74,102,008 to 74,101,440 bytes.

All sixteen vector Release parts passed (243,225 checks). Part 6 ran 15,790 checks. Corrupting the alignment golden failed four checks, restoring it passed, and adding a catalog row ran 15,796 checks using the same binary. The no-op, input, golden and catalog probes scheduled no Ninja commands. Touching the checker driver scheduled its owning object, the host link and the bake.

The part-6 log records the intentional negative control. The good and added logs record the two successful reruns. The incremental build ran on the four-vCPU-quota cloud host.
