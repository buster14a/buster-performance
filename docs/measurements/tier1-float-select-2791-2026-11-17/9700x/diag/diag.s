0000000000001340 <v_equal_main_00>:
    1340:	xor    %eax,%eax
    1342:	xor    %ecx,%ecx
    1344:	jmp    136f <v_equal_main_00+0x2f>
    1346:	mov    %rcx,%rdx
    1349:	movsd  (%rdi,%rdx,8),%xmm1
    134e:	xor    %edx,%edx
    1350:	ucomisd %xmm0,%xmm1
    1354:	sete   %dl
    1357:	setnp  %r11b
    135b:	and    %r11b,%dl
    135e:	lea    0x5(%rax),%r8
    1362:	add    $0x1,%rax
    1366:	test   %edx,%edx
    1368:	cmovne %r8,%rax
    136c:	add    $0x1,%ecx
    136f:	cmp    %esi,%ecx
    1371:	jl     1346 <v_equal_main_00+0x6>
    1373:	ret
0000000000001390 <v_equal_main_10>:
    1390:	xor    %eax,%eax
    1392:	xor    %ecx,%ecx
    1394:	jmp    13bf <v_equal_main_10+0x2f>
    1396:	mov    %rcx,%rdx
    1399:	movsd  (%rdi,%rdx,8),%xmm1
    139e:	xor    %edx,%edx
    13a0:	ucomisd %xmm0,%xmm1
    13a4:	sete   %dl
    13a7:	setnp  %r11b
    13ab:	and    %r11b,%dl
    13ae:	lea    0x5(%rax),%r8
    13b2:	add    $0x1,%rax
    13b6:	test   %edx,%edx
    13b8:	cmovne %r8,%rax
    13bc:	add    $0x1,%ecx
    13bf:	cmp    %esi,%ecx
    13c1:	jl     1396 <v_equal_main_10+0x6>
    13c3:	ret
0000000000001420 <v_equal_main_20>:
    1420:	xor    %eax,%eax
    1422:	xor    %ecx,%ecx
    1424:	jmp    144f <v_equal_main_20+0x2f>
    1426:	mov    %rcx,%rdx
    1429:	movsd  (%rdi,%rdx,8),%xmm1
    142e:	xor    %edx,%edx
    1430:	ucomisd %xmm0,%xmm1
    1434:	sete   %dl
    1437:	setnp  %r11b
    143b:	and    %r11b,%dl
    143e:	lea    0x5(%rax),%r8
    1442:	add    $0x1,%rax
    1446:	test   %edx,%edx
    1448:	cmovne %r8,%rax
    144c:	add    $0x1,%ecx
    144f:	cmp    %esi,%ecx
    1451:	jl     1426 <v_equal_main_20+0x6>
    1453:	ret
00000000000014b0 <v_equal_main_30>:
    14b0:	xor    %eax,%eax
    14b2:	xor    %ecx,%ecx
    14b4:	jmp    14df <v_equal_main_30+0x2f>
    14b6:	mov    %rcx,%rdx
    14b9:	movsd  (%rdi,%rdx,8),%xmm1
    14be:	xor    %edx,%edx
    14c0:	ucomisd %xmm0,%xmm1
    14c4:	sete   %dl
    14c7:	setnp  %r11b
    14cb:	and    %r11b,%dl
    14ce:	lea    0x5(%rax),%r8
    14d2:	add    $0x1,%rax
    14d6:	test   %edx,%edx
    14d8:	cmovne %r8,%rax
    14dc:	add    $0x1,%ecx
    14df:	cmp    %esi,%ecx
    14e1:	jl     14b6 <v_equal_main_30+0x6>
    14e3:	ret
0000000000001500 <v_equal_fused_00>:
    1500:	xor    %eax,%eax
    1502:	xor    %ecx,%ecx
    1504:	jmp    1528 <v_equal_fused_00+0x28>
    1506:	mov    %rcx,%rdx
    1509:	movsd  (%rdi,%rdx,8),%xmm1
    150e:	lea    0x5(%rax),%rdx
    1512:	add    $0x1,%rax
    1516:	ucomisd %xmm0,%xmm1
    151a:	mov    %rax,%r11
    151d:	cmove  %rdx,%rax
    1521:	cmovp  %r11,%rax
    1525:	add    $0x1,%ecx
    1528:	cmp    %esi,%ecx
    152a:	jl     1506 <v_equal_fused_00+0x6>
    152c:	ret
0000000000001550 <v_equal_fused_10>:
    1550:	xor    %eax,%eax
    1552:	xor    %ecx,%ecx
    1554:	jmp    1578 <v_equal_fused_10+0x28>
    1556:	mov    %rcx,%rdx
    1559:	movsd  (%rdi,%rdx,8),%xmm1
    155e:	lea    0x5(%rax),%rdx
    1562:	add    $0x1,%rax
    1566:	ucomisd %xmm0,%xmm1
    156a:	mov    %rax,%r11
    156d:	cmove  %rdx,%rax
    1571:	cmovp  %r11,%rax
    1575:	add    $0x1,%ecx
    1578:	cmp    %esi,%ecx
    157a:	jl     1556 <v_equal_fused_10+0x6>
    157c:	ret
00000000000015a0 <v_equal_fused_20>:
    15a0:	xor    %eax,%eax
    15a2:	xor    %ecx,%ecx
    15a4:	jmp    15c8 <v_equal_fused_20+0x28>
    15a6:	mov    %rcx,%rdx
    15a9:	movsd  (%rdi,%rdx,8),%xmm1
    15ae:	lea    0x5(%rax),%rdx
    15b2:	add    $0x1,%rax
    15b6:	ucomisd %xmm0,%xmm1
    15ba:	mov    %rax,%r11
    15bd:	cmove  %rdx,%rax
    15c1:	cmovp  %r11,%rax
    15c5:	add    $0x1,%ecx
    15c8:	cmp    %esi,%ecx
    15ca:	jl     15a6 <v_equal_fused_20+0x6>
    15cc:	ret
0000000000001630 <v_equal_fused_30>:
    1630:	xor    %eax,%eax
    1632:	xor    %ecx,%ecx
    1634:	jmp    1658 <v_equal_fused_30+0x28>
    1636:	mov    %rcx,%rdx
    1639:	movsd  (%rdi,%rdx,8),%xmm1
    163e:	lea    0x5(%rax),%rdx
    1642:	add    $0x1,%rax
    1646:	ucomisd %xmm0,%xmm1
    164a:	mov    %rax,%r11
    164d:	cmove  %rdx,%rax
    1651:	cmovp  %r11,%rax
    1655:	add    $0x1,%ecx
    1658:	cmp    %esi,%ecx
    165a:	jl     1636 <v_equal_fused_30+0x6>
    165c:	ret
0000000000001680 <v_equal_own_00>:
    1680:	xor    %eax,%eax
    1682:	xor    %ecx,%ecx
    1684:	jmp    16a8 <v_equal_own_00+0x28>
    1686:	mov    %rcx,%rdx
    1689:	movsd  (%rdi,%rdx,8),%xmm1
    168e:	lea    0x5(%rax),%rdx
    1692:	add    $0x1,%rax
    1696:	ucomisd %xmm0,%xmm1
    169a:	cmovne %rax,%rdx
    169e:	cmovp  %rax,%rdx
    16a2:	mov    %rdx,%rax
    16a5:	add    $0x1,%ecx
    16a8:	cmp    %esi,%ecx
    16aa:	jl     1686 <v_equal_own_00+0x6>
    16ac:	ret
00000000000016d0 <v_equal_own_10>:
    16d0:	xor    %eax,%eax
    16d2:	xor    %ecx,%ecx
    16d4:	jmp    16f8 <v_equal_own_10+0x28>
    16d6:	mov    %rcx,%rdx
    16d9:	movsd  (%rdi,%rdx,8),%xmm1
    16de:	lea    0x5(%rax),%rdx
    16e2:	add    $0x1,%rax
    16e6:	ucomisd %xmm0,%xmm1
    16ea:	cmovne %rax,%rdx
    16ee:	cmovp  %rax,%rdx
    16f2:	mov    %rdx,%rax
    16f5:	add    $0x1,%ecx
    16f8:	cmp    %esi,%ecx
    16fa:	jl     16d6 <v_equal_own_10+0x6>
    16fc:	ret
0000000000001720 <v_equal_own_20>:
    1720:	xor    %eax,%eax
    1722:	xor    %ecx,%ecx
    1724:	jmp    1748 <v_equal_own_20+0x28>
    1726:	mov    %rcx,%rdx
    1729:	movsd  (%rdi,%rdx,8),%xmm1
    172e:	lea    0x5(%rax),%rdx
    1732:	add    $0x1,%rax
    1736:	ucomisd %xmm0,%xmm1
    173a:	cmovne %rax,%rdx
    173e:	cmovp  %rax,%rdx
    1742:	mov    %rdx,%rax
    1745:	add    $0x1,%ecx
    1748:	cmp    %esi,%ecx
    174a:	jl     1726 <v_equal_own_20+0x6>
    174c:	ret
00000000000017b0 <v_equal_own_30>:
    17b0:	xor    %eax,%eax
    17b2:	xor    %ecx,%ecx
    17b4:	jmp    17d8 <v_equal_own_30+0x28>
    17b6:	mov    %rcx,%rdx
    17b9:	movsd  (%rdi,%rdx,8),%xmm1
    17be:	lea    0x5(%rax),%rdx
    17c2:	add    $0x1,%rax
    17c6:	ucomisd %xmm0,%xmm1
    17ca:	cmovne %rax,%rdx
    17ce:	cmovp  %rax,%rdx
    17d2:	mov    %rdx,%rax
    17d5:	add    $0x1,%ecx
    17d8:	cmp    %esi,%ecx
    17da:	jl     17b6 <v_equal_own_30+0x6>
    17dc:	ret
0000000000001800 <v_count_main_00>:
    1800:	xor    %eax,%eax
    1802:	xor    %ecx,%ecx
    1804:	jmp    1828 <v_count_main_00+0x28>
    1806:	mov    %rcx,%rdx
    1809:	movsd  (%rdi,%rdx,8),%xmm1
    180e:	xor    %edx,%edx
    1810:	ucomisd %xmm0,%xmm1
    1814:	seta   %dl
    1817:	lea    0x3(%rax),%r8
    181b:	sub    $0x1,%rax
    181f:	test   %edx,%edx
    1821:	cmovne %r8,%rax
    1825:	add    $0x1,%ecx
    1828:	cmp    %esi,%ecx
    182a:	jl     1806 <v_count_main_00+0x6>
    182c:	ret
0000000000001850 <v_count_main_10>:
    1850:	xor    %eax,%eax
    1852:	xor    %ecx,%ecx
    1854:	jmp    1878 <v_count_main_10+0x28>
    1856:	mov    %rcx,%rdx
    1859:	movsd  (%rdi,%rdx,8),%xmm1
    185e:	xor    %edx,%edx
    1860:	ucomisd %xmm0,%xmm1
    1864:	seta   %dl
    1867:	lea    0x3(%rax),%r8
    186b:	sub    $0x1,%rax
    186f:	test   %edx,%edx
    1871:	cmovne %r8,%rax
    1875:	add    $0x1,%ecx
    1878:	cmp    %esi,%ecx
    187a:	jl     1856 <v_count_main_10+0x6>
    187c:	ret
00000000000018a0 <v_count_main_20>:
    18a0:	xor    %eax,%eax
    18a2:	xor    %ecx,%ecx
    18a4:	jmp    18c8 <v_count_main_20+0x28>
    18a6:	mov    %rcx,%rdx
    18a9:	movsd  (%rdi,%rdx,8),%xmm1
    18ae:	xor    %edx,%edx
    18b0:	ucomisd %xmm0,%xmm1
    18b4:	seta   %dl
    18b7:	lea    0x3(%rax),%r8
    18bb:	sub    $0x1,%rax
    18bf:	test   %edx,%edx
    18c1:	cmovne %r8,%rax
    18c5:	add    $0x1,%ecx
    18c8:	cmp    %esi,%ecx
    18ca:	jl     18a6 <v_count_main_20+0x6>
    18cc:	ret
0000000000001930 <v_count_main_30>:
    1930:	xor    %eax,%eax
    1932:	xor    %ecx,%ecx
    1934:	jmp    1958 <v_count_main_30+0x28>
    1936:	mov    %rcx,%rdx
    1939:	movsd  (%rdi,%rdx,8),%xmm1
    193e:	xor    %edx,%edx
    1940:	ucomisd %xmm0,%xmm1
    1944:	seta   %dl
    1947:	lea    0x3(%rax),%r8
    194b:	sub    $0x1,%rax
    194f:	test   %edx,%edx
    1951:	cmovne %r8,%rax
    1955:	add    $0x1,%ecx
    1958:	cmp    %esi,%ecx
    195a:	jl     1936 <v_count_main_30+0x6>
    195c:	ret
0000000000001980 <v_count_head_00>:
    1980:	xor    %eax,%eax
    1982:	xor    %ecx,%ecx
    1984:	jmp    19a1 <v_count_head_00+0x21>
    1986:	mov    %rcx,%rdx
    1989:	movsd  (%rdi,%rdx,8),%xmm1
    198e:	lea    0x3(%rax),%rdx
    1992:	sub    $0x1,%rax
    1996:	ucomisd %xmm0,%xmm1
    199a:	cmova  %rdx,%rax
    199e:	add    $0x1,%ecx
    19a1:	cmp    %esi,%ecx
    19a3:	jl     1986 <v_count_head_00+0x6>
    19a5:	ret
00000000000019d0 <v_count_head_10>:
    19d0:	xor    %eax,%eax
    19d2:	xor    %ecx,%ecx
    19d4:	jmp    19f1 <v_count_head_10+0x21>
    19d6:	mov    %rcx,%rdx
    19d9:	movsd  (%rdi,%rdx,8),%xmm1
    19de:	lea    0x3(%rax),%rdx
    19e2:	sub    $0x1,%rax
    19e6:	ucomisd %xmm0,%xmm1
    19ea:	cmova  %rdx,%rax
    19ee:	add    $0x1,%ecx
    19f1:	cmp    %esi,%ecx
    19f3:	jl     19d6 <v_count_head_10+0x6>
    19f5:	ret
0000000000001a20 <v_count_head_20>:
    1a20:	xor    %eax,%eax
    1a22:	xor    %ecx,%ecx
    1a24:	jmp    1a41 <v_count_head_20+0x21>
    1a26:	mov    %rcx,%rdx
    1a29:	movsd  (%rdi,%rdx,8),%xmm1
    1a2e:	lea    0x3(%rax),%rdx
    1a32:	sub    $0x1,%rax
    1a36:	ucomisd %xmm0,%xmm1
    1a3a:	cmova  %rdx,%rax
    1a3e:	add    $0x1,%ecx
    1a41:	cmp    %esi,%ecx
    1a43:	jl     1a26 <v_count_head_20+0x6>
    1a45:	ret
0000000000001ab0 <v_count_head_30>:
    1ab0:	xor    %eax,%eax
    1ab2:	xor    %ecx,%ecx
    1ab4:	jmp    1ad1 <v_count_head_30+0x21>
    1ab6:	mov    %rcx,%rdx
    1ab9:	movsd  (%rdi,%rdx,8),%xmm1
    1abe:	lea    0x3(%rax),%rdx
    1ac2:	sub    $0x1,%rax
    1ac6:	ucomisd %xmm0,%xmm1
    1aca:	cmova  %rdx,%rax
    1ace:	add    $0x1,%ecx
    1ad1:	cmp    %esi,%ecx
    1ad3:	jl     1ab6 <v_count_head_30+0x6>
    1ad5:	ret
