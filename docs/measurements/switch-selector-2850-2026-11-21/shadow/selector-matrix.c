// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.

enum E {A,B,C};
enum __attribute__((packed)) P {D,F,G};
enum __attribute__((mode(HI))) W {H,I,J};
struct S {enum E e; enum P p; enum W w;};

enum E gete(void);
enum P getp(void);
enum W getw(void);
int manage_4(enum E v, enum E* a, struct S* s, int x) { switch (v) { case A: return 1; } return 0; }
int manage_5(enum E v, enum E* a, struct S* s, int x) { switch ((v)) { case A: return 1; } return 0; }
int manage_6(enum E v, enum E* a, struct S* s, int x) { switch (((v))) { case A: return 1; } return 0; }
int manage_7(enum E v, enum E* a, struct S* s, int x) { switch (*a) { case A: return 1; } return 0; }
int manage_8(enum E v, enum E* a, struct S* s, int x) { switch (a[x]) { case A: return 1; } return 0; }
int manage_9(enum E v, enum E* a, struct S* s, int x) { switch (s->e) { case A: return 1; } return 0; }
int manage_10(enum E v, enum E* a, struct S* s, int x) { switch (gete()) { case A: return 1; } return 0; }
int manage_11(enum E v, enum E* a, struct S* s, int x) { switch ((enum E)x) { case A: return 1; } return 0; }
int manage_12(enum E v, enum E* a, struct S* s, int x) { switch (((enum E)(v))) { case A: return 1; } return 0; }
int manage_13(enum E v, enum E* a, struct S* s, int x) { switch (+v) { case A: return 1; } return 0; }
int manage_14(enum E v, enum E* a, struct S* s, int x) { switch (-v) { case A: return 1; } return 0; }
int manage_15(enum E v, enum E* a, struct S* s, int x) { switch (~v) { case A: return 1; } return 0; }
int manage_16(enum E v, enum E* a, struct S* s, int x) { switch ((int)v) { case A: return 1; } return 0; }
int manage_17(enum E v, enum E* a, struct S* s, int x) { switch ((unsigned)v) { case A: return 1; } return 0; }
int manage_18(enum E v, enum E* a, struct S* s, int x) { switch ((long)v) { case A: return 1; } return 0; }
int manage_19(enum E v, enum E* a, struct S* s, int x) { switch ((unsigned short)v) { case A: return 1; } return 0; }
int manage_20(enum E v, enum E* a, struct S* s, int x) { switch ((0,v)) { case A: return 1; } return 0; }
int manage_21(enum E v, enum E* a, struct S* s, int x) { switch ((x?v:v)) { case A: return 1; } return 0; }
int manage_22(enum E v, enum E* a, struct S* s, int x) { switch ((v=A)) { case A: return 1; } return 0; }
int manage_23(enum E v, enum E* a, struct S* s, int x) { switch (v++) { case A: return 1; } return 0; }
int manage_24(enum E v, enum E* a, struct S* s, int x) { switch ((*&v)) { case A: return 1; } return 0; }
int manage_25(enum E v, enum E* a, struct S* s, int x) { switch ((1?A:v)) { case A: return 1; } return 0; }
int manage_26(enum E v, enum E* a, struct S* s, int x) { switch ((enum E)(+v)) { case A: return 1; } return 0; }
int manage_27(enum E v, enum E* a, struct S* s, int x) { switch (((int)(enum E)v)) { case A: return 1; } return 0; }
int manage_28(enum E v, enum E* a, struct S* s, int x) { switch (x) { case A: return 1; } return 0; }
int manage_29(enum P v, enum P* a, struct S* s, int x) { switch (v) { case D: return 1; } return 0; }
int manage_30(enum P v, enum P* a, struct S* s, int x) { switch ((v)) { case D: return 1; } return 0; }
int manage_31(enum P v, enum P* a, struct S* s, int x) { switch (((v))) { case D: return 1; } return 0; }
int manage_32(enum P v, enum P* a, struct S* s, int x) { switch (*a) { case D: return 1; } return 0; }
int manage_33(enum P v, enum P* a, struct S* s, int x) { switch (a[x]) { case D: return 1; } return 0; }
int manage_34(enum P v, enum P* a, struct S* s, int x) { switch (s->p) { case D: return 1; } return 0; }
int manage_35(enum P v, enum P* a, struct S* s, int x) { switch (getp()) { case D: return 1; } return 0; }
int manage_36(enum P v, enum P* a, struct S* s, int x) { switch ((enum P)x) { case D: return 1; } return 0; }
int manage_37(enum P v, enum P* a, struct S* s, int x) { switch (((enum P)(v))) { case D: return 1; } return 0; }
int manage_38(enum P v, enum P* a, struct S* s, int x) { switch (+v) { case D: return 1; } return 0; }
int manage_39(enum P v, enum P* a, struct S* s, int x) { switch (-v) { case D: return 1; } return 0; }
int manage_40(enum P v, enum P* a, struct S* s, int x) { switch (~v) { case D: return 1; } return 0; }
int manage_41(enum P v, enum P* a, struct S* s, int x) { switch ((int)v) { case D: return 1; } return 0; }
int manage_42(enum P v, enum P* a, struct S* s, int x) { switch ((unsigned)v) { case D: return 1; } return 0; }
int manage_43(enum P v, enum P* a, struct S* s, int x) { switch ((long)v) { case D: return 1; } return 0; }
int manage_44(enum P v, enum P* a, struct S* s, int x) { switch ((unsigned short)v) { case D: return 1; } return 0; }
int manage_45(enum P v, enum P* a, struct S* s, int x) { switch ((0,v)) { case D: return 1; } return 0; }
int manage_46(enum P v, enum P* a, struct S* s, int x) { switch ((x?v:v)) { case D: return 1; } return 0; }
int manage_47(enum P v, enum P* a, struct S* s, int x) { switch ((v=D)) { case D: return 1; } return 0; }
int manage_48(enum P v, enum P* a, struct S* s, int x) { switch (v++) { case D: return 1; } return 0; }
int manage_49(enum P v, enum P* a, struct S* s, int x) { switch ((*&v)) { case D: return 1; } return 0; }
int manage_50(enum P v, enum P* a, struct S* s, int x) { switch ((1?D:v)) { case D: return 1; } return 0; }
int manage_51(enum P v, enum P* a, struct S* s, int x) { switch ((enum P)(+v)) { case D: return 1; } return 0; }
int manage_52(enum P v, enum P* a, struct S* s, int x) { switch (((int)(enum P)v)) { case D: return 1; } return 0; }
int manage_53(enum P v, enum P* a, struct S* s, int x) { switch (x) { case D: return 1; } return 0; }
int manage_54(enum W v, enum W* a, struct S* s, int x) { switch (v) { case H: return 1; } return 0; }
int manage_55(enum W v, enum W* a, struct S* s, int x) { switch ((v)) { case H: return 1; } return 0; }
int manage_56(enum W v, enum W* a, struct S* s, int x) { switch (((v))) { case H: return 1; } return 0; }
int manage_57(enum W v, enum W* a, struct S* s, int x) { switch (*a) { case H: return 1; } return 0; }
int manage_58(enum W v, enum W* a, struct S* s, int x) { switch (a[x]) { case H: return 1; } return 0; }
int manage_59(enum W v, enum W* a, struct S* s, int x) { switch (s->w) { case H: return 1; } return 0; }
int manage_60(enum W v, enum W* a, struct S* s, int x) { switch (getw()) { case H: return 1; } return 0; }
int manage_61(enum W v, enum W* a, struct S* s, int x) { switch ((enum W)x) { case H: return 1; } return 0; }
int manage_62(enum W v, enum W* a, struct S* s, int x) { switch (((enum W)(v))) { case H: return 1; } return 0; }
int manage_63(enum W v, enum W* a, struct S* s, int x) { switch (+v) { case H: return 1; } return 0; }
int manage_64(enum W v, enum W* a, struct S* s, int x) { switch (-v) { case H: return 1; } return 0; }
int manage_65(enum W v, enum W* a, struct S* s, int x) { switch (~v) { case H: return 1; } return 0; }
int manage_66(enum W v, enum W* a, struct S* s, int x) { switch ((int)v) { case H: return 1; } return 0; }
int manage_67(enum W v, enum W* a, struct S* s, int x) { switch ((unsigned)v) { case H: return 1; } return 0; }
int manage_68(enum W v, enum W* a, struct S* s, int x) { switch ((long)v) { case H: return 1; } return 0; }
int manage_69(enum W v, enum W* a, struct S* s, int x) { switch ((unsigned short)v) { case H: return 1; } return 0; }
int manage_70(enum W v, enum W* a, struct S* s, int x) { switch ((0,v)) { case H: return 1; } return 0; }
int manage_71(enum W v, enum W* a, struct S* s, int x) { switch ((x?v:v)) { case H: return 1; } return 0; }
int manage_72(enum W v, enum W* a, struct S* s, int x) { switch ((v=H)) { case H: return 1; } return 0; }
int manage_73(enum W v, enum W* a, struct S* s, int x) { switch (v++) { case H: return 1; } return 0; }
int manage_74(enum W v, enum W* a, struct S* s, int x) { switch ((*&v)) { case H: return 1; } return 0; }
int manage_75(enum W v, enum W* a, struct S* s, int x) { switch ((1?H:v)) { case H: return 1; } return 0; }
int manage_76(enum W v, enum W* a, struct S* s, int x) { switch ((enum W)(+v)) { case H: return 1; } return 0; }
int manage_77(enum W v, enum W* a, struct S* s, int x) { switch (((int)(enum W)v)) { case H: return 1; } return 0; }
int manage_78(enum W v, enum W* a, struct S* s, int x) { switch (x) { case H: return 1; } return 0; }
