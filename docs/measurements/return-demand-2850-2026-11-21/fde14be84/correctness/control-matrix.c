typedef struct { int a, b; } Pair;
extern _Noreturn void stop(void);
extern int external(int);
extern int (*indirect)(int);
int candidate_0(int x) {  if (x) { return x; } end: return x; }
int candidate_1(int x) {  if (x) { return x; } end: return x; }
int candidate_2(int x) {  if (x) { return x; } return x; end: ; }
int candidate_3(int x) {  if (x) { return x; } return x; end: ; }
int candidate_4(int x) {  if (x) { return x; } end: stop(); }
int candidate_5(int x) {  if (x) { return x; } end: stop(); }
int candidate_6(int x) {  if (x) { return x; } end: if (indirect(x)) { return x; } }
int candidate_7(int x) {  if (x) { return x; } end: if (external(x)) { return x; } }
int candidate_8(int x) {  if (x) { return x; } end: for (;;) { if (external(x)) return x; } }
int candidate_9(int x) {  if (x) { return x; } end: for (;;) { if (indirect(x)) return x; } }
int candidate_10(int x) {  if (x) { return x; } end: if (x) stop(); else return x; }
int candidate_11(int x) {  if (x) { return x; } end: if (x) stop(); else return x; }
int candidate_12(int x) {  if (x) { return x; } end: (void)(x ? indirect(x) : external(x)); }
int candidate_13(int x) {  if (x) { return x; } end: (void)(x ? external(x) : indirect(x)); }
int candidate_14(int x) {  if (x) { return x; } end: if (x) { return x; } else stop(); }
int candidate_15(int x) {  if (x) { return x; } end: if (x) { return x; } else stop(); }
int candidate_16(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: return x; }
int candidate_17(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: return x; }
int candidate_18(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } return x; end: ; }
int candidate_19(int x) {  if (external(x)) { if (x<9) goto end; else return x; } return x; end: ; }
int candidate_20(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: stop(); }
int candidate_21(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: stop(); }
int candidate_22(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: if (indirect(x)) { return x; } }
int candidate_23(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: if (external(x)) { return x; } }
int candidate_24(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: for (;;) { if (external(x)) return x; } }
int candidate_25(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: for (;;) { if (indirect(x)) return x; } }
int candidate_26(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: if (x) stop(); else return x; }
int candidate_27(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: if (x) stop(); else return x; }
int candidate_28(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: (void)(x ? indirect(x) : external(x)); }
int candidate_29(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: (void)(x ? external(x) : indirect(x)); }
int candidate_30(int x) {  if (indirect(x)) { if (x<9) goto end; else return x; } end: if (x) { return x; } else stop(); }
int candidate_31(int x) {  if (external(x)) { if (x<9) goto end; else return x; } end: if (x) { return x; } else stop(); }
int candidate_32(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: return x; }
int candidate_33(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: return x; }
int candidate_34(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } return x; end: ; }
int candidate_35(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } return x; end: ; }
int candidate_36(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: stop(); }
int candidate_37(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: stop(); }
int candidate_38(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (indirect(x)) { return x; } }
int candidate_39(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: if (external(x)) { return x; } }
int candidate_40(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: for (;;) { if (external(x)) return x; } }
int candidate_41(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: for (;;) { if (indirect(x)) return x; } }
int candidate_42(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) stop(); else return x; }
int candidate_43(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) stop(); else return x; }
int candidate_44(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: (void)(x ? indirect(x) : external(x)); }
int candidate_45(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: (void)(x ? external(x) : indirect(x)); }
int candidate_46(int x) {  switch (x) { case 1: if (external(x)) return x; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) { return x; } else stop(); }
int candidate_47(int x) {  switch (x) { case 1: if (indirect(x)) return x; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) { return x; } else stop(); }
int candidate_48(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: return x; }
int candidate_49(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: return x; }
int candidate_50(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } return x; end: ; }
int candidate_51(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } return x; end: ; }
int candidate_52(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: stop(); }
int candidate_53(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: stop(); }
int candidate_54(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: if (indirect(x)) { return x; } }
int candidate_55(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: if (external(x)) { return x; } }
int candidate_56(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: for (;;) { if (external(x)) return x; } }
int candidate_57(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: for (;;) { if (indirect(x)) return x; } }
int candidate_58(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: if (x) stop(); else return x; }
int candidate_59(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: if (x) stop(); else return x; }
int candidate_60(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: (void)(x ? indirect(x) : external(x)); }
int candidate_61(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: (void)(x ? external(x) : indirect(x)); }
int candidate_62(int x) {  while (indirect(x)) { if (external(x)) return x; if (x==3) goto end; break; } end: if (x) { return x; } else stop(); }
int candidate_63(int x) {  while (external(x)) { if (indirect(x)) return x; if (x==3) goto end; break; } end: if (x) { return x; } else stop(); }
int candidate_64(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: return x; }
int candidate_65(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: return x; }
int candidate_66(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); return x; end: ; }
int candidate_67(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); return x; end: ; }
int candidate_68(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: stop(); }
int candidate_69(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: stop(); }
int candidate_70(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (indirect(x)) { return x; } }
int candidate_71(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (external(x)) { return x; } }
int candidate_72(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: for (;;) { if (external(x)) return x; } }
int candidate_73(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: for (;;) { if (indirect(x)) return x; } }
int candidate_74(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) stop(); else return x; }
int candidate_75(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) stop(); else return x; }
int candidate_76(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: (void)(x ? indirect(x) : external(x)); }
int candidate_77(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: (void)(x ? external(x) : indirect(x)); }
int candidate_78(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) { return x; } else stop(); }
int candidate_79(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) { return x; } else stop(); }
int candidate_80(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: return x; }
int candidate_81(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: return x; }
int candidate_82(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; return x; end: ; }
int candidate_83(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; return x; end: ; }
int candidate_84(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: stop(); }
int candidate_85(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: stop(); }
int candidate_86(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: if (indirect(x)) { return x; } }
int candidate_87(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: if (external(x)) { return x; } }
int candidate_88(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: for (;;) { if (external(x)) return x; } }
int candidate_89(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: for (;;) { if (indirect(x)) return x; } }
int candidate_90(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: if (x) stop(); else return x; }
int candidate_91(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: if (x) stop(); else return x; }
int candidate_92(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: (void)(x ? indirect(x) : external(x)); }
int candidate_93(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: (void)(x ? external(x) : indirect(x)); }
int candidate_94(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return x; end: if (x) { return x; } else stop(); }
int candidate_95(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return x; end: if (x) { return x; } else stop(); }
int candidate_96(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: return x; }
int candidate_97(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: return x; }
int candidate_98(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } return x; end: ; }
int candidate_99(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } return x; end: ; }
int candidate_100(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: stop(); }
int candidate_101(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: stop(); }
int candidate_102(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: if (indirect(x)) { return x; } }
int candidate_103(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: if (external(x)) { return x; } }
int candidate_104(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: for (;;) { if (external(x)) return x; } }
int candidate_105(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: for (;;) { if (indirect(x)) return x; } }
int candidate_106(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: if (x) stop(); else return x; }
int candidate_107(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: if (x) stop(); else return x; }
int candidate_108(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: (void)(x ? indirect(x) : external(x)); }
int candidate_109(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: (void)(x ? external(x) : indirect(x)); }
int candidate_110(int x) {  if (({ int k=indirect(x); k && external(x); })) { return x; } end: if (x) { return x; } else stop(); }
int candidate_111(int x) {  if (({ int k=external(x); k && indirect(x); })) { return x; } end: if (x) { return x; } else stop(); }
void candidate_112(int x) {  if (x) { return; } end: return; }
void candidate_113(int x) {  if (x) { return; } end: return; }
void candidate_114(int x) {  if (x) { return; } return; end: ; }
void candidate_115(int x) {  if (x) { return; } return; end: ; }
void candidate_116(int x) {  if (x) { return; } end: stop(); }
void candidate_117(int x) {  if (x) { return; } end: stop(); }
void candidate_118(int x) {  if (x) { return; } end: if (indirect(x)) { return; } }
void candidate_119(int x) {  if (x) { return; } end: if (external(x)) { return; } }
void candidate_120(int x) {  if (x) { return; } end: for (;;) { if (external(x)) return; } }
void candidate_121(int x) {  if (x) { return; } end: for (;;) { if (indirect(x)) return; } }
void candidate_122(int x) {  if (x) { return; } end: if (x) stop(); else return; }
void candidate_123(int x) {  if (x) { return; } end: if (x) stop(); else return; }
void candidate_124(int x) {  if (x) { return; } end: (void)(x ? indirect(x) : external(x)); }
void candidate_125(int x) {  if (x) { return; } end: (void)(x ? external(x) : indirect(x)); }
void candidate_126(int x) {  if (x) { return; } end: if (x) { return; } else stop(); }
void candidate_127(int x) {  if (x) { return; } end: if (x) { return; } else stop(); }
void candidate_128(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: return; }
void candidate_129(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: return; }
void candidate_130(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } return; end: ; }
void candidate_131(int x) {  if (external(x)) { if (x<9) goto end; else return; } return; end: ; }
void candidate_132(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: stop(); }
void candidate_133(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: stop(); }
void candidate_134(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (indirect(x)) { return; } }
void candidate_135(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (external(x)) { return; } }
void candidate_136(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: for (;;) { if (external(x)) return; } }
void candidate_137(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: for (;;) { if (indirect(x)) return; } }
void candidate_138(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (x) stop(); else return; }
void candidate_139(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (x) stop(); else return; }
void candidate_140(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: (void)(x ? indirect(x) : external(x)); }
void candidate_141(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: (void)(x ? external(x) : indirect(x)); }
void candidate_142(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (x) { return; } else stop(); }
void candidate_143(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (x) { return; } else stop(); }
void candidate_144(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: return; }
void candidate_145(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: return; }
void candidate_146(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } return; end: ; }
void candidate_147(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } return; end: ; }
void candidate_148(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: stop(); }
void candidate_149(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: stop(); }
void candidate_150(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (indirect(x)) { return; } }
void candidate_151(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (external(x)) { return; } }
void candidate_152(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: for (;;) { if (external(x)) return; } }
void candidate_153(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: for (;;) { if (indirect(x)) return; } }
void candidate_154(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) stop(); else return; }
void candidate_155(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) stop(); else return; }
void candidate_156(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: (void)(x ? indirect(x) : external(x)); }
void candidate_157(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: (void)(x ? external(x) : indirect(x)); }
void candidate_158(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) { return; } else stop(); }
void candidate_159(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) { return; } else stop(); }
void candidate_160(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: return; }
void candidate_161(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: return; }
void candidate_162(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } return; end: ; }
void candidate_163(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } return; end: ; }
void candidate_164(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: stop(); }
void candidate_165(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: stop(); }
void candidate_166(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (indirect(x)) { return; } }
void candidate_167(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (external(x)) { return; } }
void candidate_168(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: for (;;) { if (external(x)) return; } }
void candidate_169(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: for (;;) { if (indirect(x)) return; } }
void candidate_170(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (x) stop(); else return; }
void candidate_171(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (x) stop(); else return; }
void candidate_172(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: (void)(x ? indirect(x) : external(x)); }
void candidate_173(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: (void)(x ? external(x) : indirect(x)); }
void candidate_174(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (x) { return; } else stop(); }
void candidate_175(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (x) { return; } else stop(); }
void candidate_176(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: return; }
void candidate_177(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: return; }
void candidate_178(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); return; end: ; }
void candidate_179(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); return; end: ; }
void candidate_180(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: stop(); }
void candidate_181(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: stop(); }
void candidate_182(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (indirect(x)) { return; } }
void candidate_183(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (external(x)) { return; } }
void candidate_184(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: for (;;) { if (external(x)) return; } }
void candidate_185(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: for (;;) { if (indirect(x)) return; } }
void candidate_186(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) stop(); else return; }
void candidate_187(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) stop(); else return; }
void candidate_188(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: (void)(x ? indirect(x) : external(x)); }
void candidate_189(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: (void)(x ? external(x) : indirect(x)); }
void candidate_190(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) { return; } else stop(); }
void candidate_191(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) { return; } else stop(); }
void candidate_192(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: return; }
void candidate_193(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: return; }
void candidate_194(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; return; end: ; }
void candidate_195(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; return; end: ; }
void candidate_196(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: stop(); }
void candidate_197(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: stop(); }
void candidate_198(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (indirect(x)) { return; } }
void candidate_199(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (external(x)) { return; } }
void candidate_200(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: for (;;) { if (external(x)) return; } }
void candidate_201(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: for (;;) { if (indirect(x)) return; } }
void candidate_202(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (x) stop(); else return; }
void candidate_203(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (x) stop(); else return; }
void candidate_204(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: (void)(x ? indirect(x) : external(x)); }
void candidate_205(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: (void)(x ? external(x) : indirect(x)); }
void candidate_206(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (x) { return; } else stop(); }
void candidate_207(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (x) { return; } else stop(); }
void candidate_208(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: return; }
void candidate_209(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: return; }
void candidate_210(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } return; end: ; }
void candidate_211(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } return; end: ; }
void candidate_212(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: stop(); }
void candidate_213(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: stop(); }
void candidate_214(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (indirect(x)) { return; } }
void candidate_215(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (external(x)) { return; } }
void candidate_216(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: for (;;) { if (external(x)) return; } }
void candidate_217(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: for (;;) { if (indirect(x)) return; } }
void candidate_218(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (x) stop(); else return; }
void candidate_219(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (x) stop(); else return; }
void candidate_220(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: (void)(x ? indirect(x) : external(x)); }
void candidate_221(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: (void)(x ? external(x) : indirect(x)); }
void candidate_222(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (x) { return; } else stop(); }
void candidate_223(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (x) { return; } else stop(); }
Pair candidate_224(int x) {  if (x) { return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_225(int x) {  if (x) { return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_226(int x) {  if (x) { return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_227(int x) {  if (x) { return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_228(int x) {  if (x) { return (Pair){x,1}; } end: stop(); }
Pair candidate_229(int x) {  if (x) { return (Pair){x,1}; } end: stop(); }
Pair candidate_230(int x) {  if (x) { return (Pair){x,1}; } end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_231(int x) {  if (x) { return (Pair){x,1}; } end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_232(int x) {  if (x) { return (Pair){x,1}; } end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_233(int x) {  if (x) { return (Pair){x,1}; } end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_234(int x) {  if (x) { return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_235(int x) {  if (x) { return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_236(int x) {  if (x) { return (Pair){x,1}; } end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_237(int x) {  if (x) { return (Pair){x,1}; } end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_238(int x) {  if (x) { return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_239(int x) {  if (x) { return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_240(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_241(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_242(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_243(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_244(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: stop(); }
Pair candidate_245(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: stop(); }
Pair candidate_246(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_247(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_248(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_249(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_250(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_251(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_252(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_253(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_254(int x) {  if (indirect(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_255(int x) {  if (external(x)) { if (x<9) goto end; else return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_256(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: return (Pair){x,1}; }
Pair candidate_257(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: return (Pair){x,1}; }
Pair candidate_258(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } return (Pair){x,1}; end: ; }
Pair candidate_259(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } return (Pair){x,1}; end: ; }
Pair candidate_260(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: stop(); }
Pair candidate_261(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: stop(); }
Pair candidate_262(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_263(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_264(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_265(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_266(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_267(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_268(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_269(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_270(int x) {  switch (x) { case 1: if (external(x)) return (Pair){x,1}; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_271(int x) {  switch (x) { case 1: if (indirect(x)) return (Pair){x,1}; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_272(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: return (Pair){x,1}; }
Pair candidate_273(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: return (Pair){x,1}; }
Pair candidate_274(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } return (Pair){x,1}; end: ; }
Pair candidate_275(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } return (Pair){x,1}; end: ; }
Pair candidate_276(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: stop(); }
Pair candidate_277(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: stop(); }
Pair candidate_278(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_279(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_280(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_281(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_282(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_283(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_284(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_285(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_286(int x) {  while (indirect(x)) { if (external(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_287(int x) {  while (external(x)) { if (indirect(x)) return (Pair){x,1}; if (x==3) goto end; break; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_288(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: return (Pair){x,1}; }
Pair candidate_289(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: return (Pair){x,1}; }
Pair candidate_290(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); return (Pair){x,1}; end: ; }
Pair candidate_291(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); return (Pair){x,1}; end: ; }
Pair candidate_292(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: stop(); }
Pair candidate_293(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: stop(); }
Pair candidate_294(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_295(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_296(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_297(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_298(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_299(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_300(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_301(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_302(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_303(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_304(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: return (Pair){x,1}; }
Pair candidate_305(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: return (Pair){x,1}; }
Pair candidate_306(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; return (Pair){x,1}; end: ; }
Pair candidate_307(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; return (Pair){x,1}; end: ; }
Pair candidate_308(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: stop(); }
Pair candidate_309(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: stop(); }
Pair candidate_310(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_311(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_312(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_313(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_314(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_315(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_316(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_317(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_318(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return (Pair){x,1}; end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_319(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return (Pair){x,1}; end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_320(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_321(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: return (Pair){x,1}; }
Pair candidate_322(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_323(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } return (Pair){x,1}; end: ; }
Pair candidate_324(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: stop(); }
Pair candidate_325(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: stop(); }
Pair candidate_326(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: if (indirect(x)) { return (Pair){x,1}; } }
Pair candidate_327(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: if (external(x)) { return (Pair){x,1}; } }
Pair candidate_328(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: for (;;) { if (external(x)) return (Pair){x,1}; } }
Pair candidate_329(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: for (;;) { if (indirect(x)) return (Pair){x,1}; } }
Pair candidate_330(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_331(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: if (x) stop(); else return (Pair){x,1}; }
Pair candidate_332(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: (void)(x ? indirect(x) : external(x)); }
Pair candidate_333(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: (void)(x ? external(x) : indirect(x)); }
Pair candidate_334(int x) {  if (({ int k=indirect(x); k && external(x); })) { return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
Pair candidate_335(int x) {  if (({ int k=external(x); k && indirect(x); })) { return (Pair){x,1}; } end: if (x) { return (Pair){x,1}; } else stop(); }
_Noreturn void candidate_336(int x) {  if (x) { return; } end: return; }
_Noreturn void candidate_337(int x) {  if (x) { return; } end: return; }
_Noreturn void candidate_338(int x) {  if (x) { return; } return; end: ; }
_Noreturn void candidate_339(int x) {  if (x) { return; } return; end: ; }
_Noreturn void candidate_340(int x) {  if (x) { return; } end: stop(); }
_Noreturn void candidate_341(int x) {  if (x) { return; } end: stop(); }
_Noreturn void candidate_342(int x) {  if (x) { return; } end: if (indirect(x)) { return; } }
_Noreturn void candidate_343(int x) {  if (x) { return; } end: if (external(x)) { return; } }
_Noreturn void candidate_344(int x) {  if (x) { return; } end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_345(int x) {  if (x) { return; } end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_346(int x) {  if (x) { return; } end: if (x) stop(); else return; }
_Noreturn void candidate_347(int x) {  if (x) { return; } end: if (x) stop(); else return; }
_Noreturn void candidate_348(int x) {  if (x) { return; } end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_349(int x) {  if (x) { return; } end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_350(int x) {  if (x) { return; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_351(int x) {  if (x) { return; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_352(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: return; }
_Noreturn void candidate_353(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: return; }
_Noreturn void candidate_354(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } return; end: ; }
_Noreturn void candidate_355(int x) {  if (external(x)) { if (x<9) goto end; else return; } return; end: ; }
_Noreturn void candidate_356(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: stop(); }
_Noreturn void candidate_357(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: stop(); }
_Noreturn void candidate_358(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (indirect(x)) { return; } }
_Noreturn void candidate_359(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (external(x)) { return; } }
_Noreturn void candidate_360(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_361(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_362(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (x) stop(); else return; }
_Noreturn void candidate_363(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (x) stop(); else return; }
_Noreturn void candidate_364(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_365(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_366(int x) {  if (indirect(x)) { if (x<9) goto end; else return; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_367(int x) {  if (external(x)) { if (x<9) goto end; else return; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_368(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: return; }
_Noreturn void candidate_369(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: return; }
_Noreturn void candidate_370(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } return; end: ; }
_Noreturn void candidate_371(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } return; end: ; }
_Noreturn void candidate_372(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: stop(); }
_Noreturn void candidate_373(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: stop(); }
_Noreturn void candidate_374(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (indirect(x)) { return; } }
_Noreturn void candidate_375(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (external(x)) { return; } }
_Noreturn void candidate_376(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_377(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_378(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) stop(); else return; }
_Noreturn void candidate_379(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) stop(); else return; }
_Noreturn void candidate_380(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_381(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_382(int x) {  switch (x) { case 1: if (external(x)) return; break; case 2: goto end; default: if (indirect(x)) stop(); } end: if (x) { return; } else stop(); }
_Noreturn void candidate_383(int x) {  switch (x) { case 1: if (indirect(x)) return; break; case 2: goto end; default: if (external(x)) stop(); } end: if (x) { return; } else stop(); }
_Noreturn void candidate_384(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: return; }
_Noreturn void candidate_385(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: return; }
_Noreturn void candidate_386(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } return; end: ; }
_Noreturn void candidate_387(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } return; end: ; }
_Noreturn void candidate_388(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: stop(); }
_Noreturn void candidate_389(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: stop(); }
_Noreturn void candidate_390(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (indirect(x)) { return; } }
_Noreturn void candidate_391(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (external(x)) { return; } }
_Noreturn void candidate_392(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_393(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_394(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (x) stop(); else return; }
_Noreturn void candidate_395(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (x) stop(); else return; }
_Noreturn void candidate_396(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_397(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_398(int x) {  while (indirect(x)) { if (external(x)) return; if (x==3) goto end; break; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_399(int x) {  while (external(x)) { if (indirect(x)) return; if (x==3) goto end; break; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_400(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: return; }
_Noreturn void candidate_401(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: return; }
_Noreturn void candidate_402(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); return; end: ; }
_Noreturn void candidate_403(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); return; end: ; }
_Noreturn void candidate_404(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: stop(); }
_Noreturn void candidate_405(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: stop(); }
_Noreturn void candidate_406(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (indirect(x)) { return; } }
_Noreturn void candidate_407(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (external(x)) { return; } }
_Noreturn void candidate_408(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_409(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_410(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) stop(); else return; }
_Noreturn void candidate_411(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) stop(); else return; }
_Noreturn void candidate_412(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_413(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_414(int x) { void *p=x ? &&end : &&skip; if (indirect(x)) goto *p; if (x) goto end; skip: if (external(x)) stop(); end: if (x) { return; } else stop(); }
_Noreturn void candidate_415(int x) { void *p=x ? &&end : &&skip; if (external(x)) goto *p; if (x) goto end; skip: if (indirect(x)) stop(); end: if (x) { return; } else stop(); }
_Noreturn void candidate_416(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: return; }
_Noreturn void candidate_417(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: return; }
_Noreturn void candidate_418(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; return; end: ; }
_Noreturn void candidate_419(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; return; end: ; }
_Noreturn void candidate_420(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: stop(); }
_Noreturn void candidate_421(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: stop(); }
_Noreturn void candidate_422(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (indirect(x)) { return; } }
_Noreturn void candidate_423(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (external(x)) { return; } }
_Noreturn void candidate_424(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_425(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_426(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (x) stop(); else return; }
_Noreturn void candidate_427(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (x) stop(); else return; }
_Noreturn void candidate_428(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_429(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_430(int x) {  __asm__ goto ("" : : : : end); if (indirect(x)) return; end: if (x) { return; } else stop(); }
_Noreturn void candidate_431(int x) {  __asm__ goto ("" : : : : end); if (external(x)) return; end: if (x) { return; } else stop(); }
_Noreturn void candidate_432(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: return; }
_Noreturn void candidate_433(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: return; }
_Noreturn void candidate_434(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } return; end: ; }
_Noreturn void candidate_435(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } return; end: ; }
_Noreturn void candidate_436(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: stop(); }
_Noreturn void candidate_437(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: stop(); }
_Noreturn void candidate_438(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (indirect(x)) { return; } }
_Noreturn void candidate_439(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (external(x)) { return; } }
_Noreturn void candidate_440(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: for (;;) { if (external(x)) return; } }
_Noreturn void candidate_441(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: for (;;) { if (indirect(x)) return; } }
_Noreturn void candidate_442(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (x) stop(); else return; }
_Noreturn void candidate_443(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (x) stop(); else return; }
_Noreturn void candidate_444(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: (void)(x ? indirect(x) : external(x)); }
_Noreturn void candidate_445(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: (void)(x ? external(x) : indirect(x)); }
_Noreturn void candidate_446(int x) {  if (({ int k=indirect(x); k && external(x); })) { return; } end: if (x) { return; } else stop(); }
_Noreturn void candidate_447(int x) {  if (({ int k=external(x); k && indirect(x); })) { return; } end: if (x) { return; } else stop(); }
