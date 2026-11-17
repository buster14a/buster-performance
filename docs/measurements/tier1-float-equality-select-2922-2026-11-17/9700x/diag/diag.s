0000000000001380 <v_best_truth_00>:
    1380:	mov    $0xffffffff,%eax
    1385:	xor    %ecx,%ecx
    1387:	jmp    13a9 <v_best_truth_00+0x29>
    1389:	mov    %rcx,%rdx
    138c:	movsd  (%rdi,%rdx,8),%xmm1
    1391:	xor    %edx,%edx
    1393:	ucomisd %xmm0,%xmm1
    1397:	sete   %dl
    139a:	setnp  %r11b
    139e:	and    %r11b,%dl
    13a1:	test   %edx,%edx
    13a3:	cmovne %ecx,%eax
    13a6:	add    $0x1,%ecx
    13a9:	cmp    %esi,%ecx
    13ab:	jl     1389 <v_best_truth_00+0x9>
    13ad:	ret
00000000000013d0 <v_best_truth_10>:
    13d0:	mov    $0xffffffff,%eax
    13d5:	xor    %ecx,%ecx
    13d7:	jmp    13f9 <v_best_truth_10+0x29>
    13d9:	mov    %rcx,%rdx
    13dc:	movsd  (%rdi,%rdx,8),%xmm1
    13e1:	xor    %edx,%edx
    13e3:	ucomisd %xmm0,%xmm1
    13e7:	sete   %dl
    13ea:	setnp  %r11b
    13ee:	and    %r11b,%dl
    13f1:	test   %edx,%edx
    13f3:	cmovne %ecx,%eax
    13f6:	add    $0x1,%ecx
    13f9:	cmp    %esi,%ecx
    13fb:	jl     13d9 <v_best_truth_10+0x9>
    13fd:	ret
0000000000001420 <v_best_truth_20>:
    1420:	mov    $0xffffffff,%eax
    1425:	xor    %ecx,%ecx
    1427:	jmp    1449 <v_best_truth_20+0x29>
    1429:	mov    %rcx,%rdx
    142c:	movsd  (%rdi,%rdx,8),%xmm1
    1431:	xor    %edx,%edx
    1433:	ucomisd %xmm0,%xmm1
    1437:	sete   %dl
    143a:	setnp  %r11b
    143e:	and    %r11b,%dl
    1441:	test   %edx,%edx
    1443:	cmovne %ecx,%eax
    1446:	add    $0x1,%ecx
    1449:	cmp    %esi,%ecx
    144b:	jl     1429 <v_best_truth_20+0x9>
    144d:	ret
00000000000014b0 <v_best_truth_30>:
    14b0:	mov    $0xffffffff,%eax
    14b5:	xor    %ecx,%ecx
    14b7:	jmp    14d9 <v_best_truth_30+0x29>
    14b9:	mov    %rcx,%rdx
    14bc:	movsd  (%rdi,%rdx,8),%xmm1
    14c1:	xor    %edx,%edx
    14c3:	ucomisd %xmm0,%xmm1
    14c7:	sete   %dl
    14ca:	setnp  %r11b
    14ce:	and    %r11b,%dl
    14d1:	test   %edx,%edx
    14d3:	cmovne %ecx,%eax
    14d6:	add    $0x1,%ecx
    14d9:	cmp    %esi,%ecx
    14db:	jl     14b9 <v_best_truth_30+0x9>
    14dd:	ret
0000000000001500 <v_best_fused_00>:
    1500:	mov    $0xffffffff,%eax
    1505:	xor    %ecx,%ecx
    1507:	jmp    1522 <v_best_fused_00+0x22>
    1509:	mov    %rcx,%rdx
    150c:	movsd  (%rdi,%rdx,8),%xmm1
    1511:	ucomisd %xmm0,%xmm1
    1515:	mov    %eax,%r11d
    1518:	cmove  %ecx,%eax
    151b:	cmovp  %r11d,%eax
    151f:	add    $0x1,%ecx
    1522:	cmp    %esi,%ecx
    1524:	jl     1509 <v_best_fused_00+0x9>
    1526:	ret
0000000000001550 <v_best_fused_10>:
    1550:	mov    $0xffffffff,%eax
    1555:	xor    %ecx,%ecx
    1557:	jmp    1572 <v_best_fused_10+0x22>
    1559:	mov    %rcx,%rdx
    155c:	movsd  (%rdi,%rdx,8),%xmm1
    1561:	ucomisd %xmm0,%xmm1
    1565:	mov    %eax,%r11d
    1568:	cmove  %ecx,%eax
    156b:	cmovp  %r11d,%eax
    156f:	add    $0x1,%ecx
    1572:	cmp    %esi,%ecx
    1574:	jl     1559 <v_best_fused_10+0x9>
    1576:	ret
00000000000015a0 <v_best_fused_20>:
    15a0:	mov    $0xffffffff,%eax
    15a5:	xor    %ecx,%ecx
    15a7:	jmp    15c2 <v_best_fused_20+0x22>
    15a9:	mov    %rcx,%rdx
    15ac:	movsd  (%rdi,%rdx,8),%xmm1
    15b1:	ucomisd %xmm0,%xmm1
    15b5:	mov    %eax,%r11d
    15b8:	cmove  %ecx,%eax
    15bb:	cmovp  %r11d,%eax
    15bf:	add    $0x1,%ecx
    15c2:	cmp    %esi,%ecx
    15c4:	jl     15a9 <v_best_fused_20+0x9>
    15c6:	ret
0000000000001630 <v_best_fused_30>:
    1630:	mov    $0xffffffff,%eax
    1635:	xor    %ecx,%ecx
    1637:	jmp    1652 <v_best_fused_30+0x22>
    1639:	mov    %rcx,%rdx
    163c:	movsd  (%rdi,%rdx,8),%xmm1
    1641:	ucomisd %xmm0,%xmm1
    1645:	mov    %eax,%r11d
    1648:	cmove  %ecx,%eax
    164b:	cmovp  %r11d,%eax
    164f:	add    $0x1,%ecx
    1652:	cmp    %esi,%ecx
    1654:	jl     1639 <v_best_fused_30+0x9>
    1656:	ret
0000000000001680 <v_equal_truth_00>:
    1680:	xor    %eax,%eax
    1682:	xor    %ecx,%ecx
    1684:	jmp    16af <v_equal_truth_00+0x2f>
    1686:	mov    %rcx,%rdx
    1689:	movsd  (%rdi,%rdx,8),%xmm1
    168e:	xor    %edx,%edx
    1690:	ucomisd %xmm0,%xmm1
    1694:	sete   %dl
    1697:	setnp  %r11b
    169b:	and    %r11b,%dl
    169e:	lea    0x5(%rax),%r8
    16a2:	add    $0x1,%rax
    16a6:	test   %edx,%edx
    16a8:	cmovne %r8,%rax
    16ac:	add    $0x1,%ecx
    16af:	cmp    %esi,%ecx
    16b1:	jl     1686 <v_equal_truth_00+0x6>
    16b3:	ret
00000000000016d0 <v_equal_truth_10>:
    16d0:	xor    %eax,%eax
    16d2:	xor    %ecx,%ecx
    16d4:	jmp    16ff <v_equal_truth_10+0x2f>
    16d6:	mov    %rcx,%rdx
    16d9:	movsd  (%rdi,%rdx,8),%xmm1
    16de:	xor    %edx,%edx
    16e0:	ucomisd %xmm0,%xmm1
    16e4:	sete   %dl
    16e7:	setnp  %r11b
    16eb:	and    %r11b,%dl
    16ee:	lea    0x5(%rax),%r8
    16f2:	add    $0x1,%rax
    16f6:	test   %edx,%edx
    16f8:	cmovne %r8,%rax
    16fc:	add    $0x1,%ecx
    16ff:	cmp    %esi,%ecx
    1701:	jl     16d6 <v_equal_truth_10+0x6>
    1703:	ret
0000000000001760 <v_equal_truth_20>:
    1760:	xor    %eax,%eax
    1762:	xor    %ecx,%ecx
    1764:	jmp    178f <v_equal_truth_20+0x2f>
    1766:	mov    %rcx,%rdx
    1769:	movsd  (%rdi,%rdx,8),%xmm1
    176e:	xor    %edx,%edx
    1770:	ucomisd %xmm0,%xmm1
    1774:	sete   %dl
    1777:	setnp  %r11b
    177b:	and    %r11b,%dl
    177e:	lea    0x5(%rax),%r8
    1782:	add    $0x1,%rax
    1786:	test   %edx,%edx
    1788:	cmovne %r8,%rax
    178c:	add    $0x1,%ecx
    178f:	cmp    %esi,%ecx
    1791:	jl     1766 <v_equal_truth_20+0x6>
    1793:	ret
00000000000017f0 <v_equal_truth_30>:
    17f0:	xor    %eax,%eax
    17f2:	xor    %ecx,%ecx
    17f4:	jmp    181f <v_equal_truth_30+0x2f>
    17f6:	mov    %rcx,%rdx
    17f9:	movsd  (%rdi,%rdx,8),%xmm1
    17fe:	xor    %edx,%edx
    1800:	ucomisd %xmm0,%xmm1
    1804:	sete   %dl
    1807:	setnp  %r11b
    180b:	and    %r11b,%dl
    180e:	lea    0x5(%rax),%r8
    1812:	add    $0x1,%rax
    1816:	test   %edx,%edx
    1818:	cmovne %r8,%rax
    181c:	add    $0x1,%ecx
    181f:	cmp    %esi,%ecx
    1821:	jl     17f6 <v_equal_truth_30+0x6>
    1823:	ret
0000000000001840 <v_equal_fused_00>:
    1840:	xor    %eax,%eax
    1842:	xor    %ecx,%ecx
    1844:	jmp    1868 <v_equal_fused_00+0x28>
    1846:	mov    %rcx,%rdx
    1849:	movsd  (%rdi,%rdx,8),%xmm1
    184e:	lea    0x5(%rax),%rdx
    1852:	add    $0x1,%rax
    1856:	ucomisd %xmm0,%xmm1
    185a:	mov    %rax,%r11
    185d:	cmove  %rdx,%rax
    1861:	cmovp  %r11,%rax
    1865:	add    $0x1,%ecx
    1868:	cmp    %esi,%ecx
    186a:	jl     1846 <v_equal_fused_00+0x6>
    186c:	ret
0000000000001890 <v_equal_fused_10>:
    1890:	xor    %eax,%eax
    1892:	xor    %ecx,%ecx
    1894:	jmp    18b8 <v_equal_fused_10+0x28>
    1896:	mov    %rcx,%rdx
    1899:	movsd  (%rdi,%rdx,8),%xmm1
    189e:	lea    0x5(%rax),%rdx
    18a2:	add    $0x1,%rax
    18a6:	ucomisd %xmm0,%xmm1
    18aa:	mov    %rax,%r11
    18ad:	cmove  %rdx,%rax
    18b1:	cmovp  %r11,%rax
    18b5:	add    $0x1,%ecx
    18b8:	cmp    %esi,%ecx
    18ba:	jl     1896 <v_equal_fused_10+0x6>
    18bc:	ret
00000000000018e0 <v_equal_fused_20>:
    18e0:	xor    %eax,%eax
    18e2:	xor    %ecx,%ecx
    18e4:	jmp    1908 <v_equal_fused_20+0x28>
    18e6:	mov    %rcx,%rdx
    18e9:	movsd  (%rdi,%rdx,8),%xmm1
    18ee:	lea    0x5(%rax),%rdx
    18f2:	add    $0x1,%rax
    18f6:	ucomisd %xmm0,%xmm1
    18fa:	mov    %rax,%r11
    18fd:	cmove  %rdx,%rax
    1901:	cmovp  %r11,%rax
    1905:	add    $0x1,%ecx
    1908:	cmp    %esi,%ecx
    190a:	jl     18e6 <v_equal_fused_20+0x6>
    190c:	ret
0000000000001970 <v_equal_fused_30>:
    1970:	xor    %eax,%eax
    1972:	xor    %ecx,%ecx
    1974:	jmp    1998 <v_equal_fused_30+0x28>
    1976:	mov    %rcx,%rdx
    1979:	movsd  (%rdi,%rdx,8),%xmm1
    197e:	lea    0x5(%rax),%rdx
    1982:	add    $0x1,%rax
    1986:	ucomisd %xmm0,%xmm1
    198a:	mov    %rax,%r11
    198d:	cmove  %rdx,%rax
    1991:	cmovp  %r11,%rax
    1995:	add    $0x1,%ecx
    1998:	cmp    %esi,%ecx
    199a:	jl     1976 <v_equal_fused_30+0x6>
    199c:	ret
00000000000019c0 <v_sum_truth_00>:
    19c0:	xor    %eax,%eax
    19c2:	xor    %r8d,%r8d
    19c5:	jmp    19f3 <v_sum_truth_00+0x33>
    19c7:	mov    %r8,%r9
    19ca:	movsd  (%rdi,%r9,8),%xmm1
    19d0:	xor    %r9d,%r9d
    19d3:	ucomisd %xmm0,%xmm1
    19d7:	sete   %r9b
    19db:	setnp  %r11b
    19df:	and    %r11b,%r9b
    19e2:	test   %r9d,%r9d
    19e5:	mov    %rcx,%r9
    19e8:	cmovne %rdx,%r9
    19ec:	add    %r9,%rax
    19ef:	add    $0x1,%r8d
    19f3:	cmp    %esi,%r8d
    19f6:	jl     19c7 <v_sum_truth_00+0x7>
    19f8:	ret
0000000000001a10 <v_sum_truth_10>:
    1a10:	xor    %eax,%eax
    1a12:	xor    %r8d,%r8d
    1a15:	jmp    1a43 <v_sum_truth_10+0x33>
    1a17:	mov    %r8,%r9
    1a1a:	movsd  (%rdi,%r9,8),%xmm1
    1a20:	xor    %r9d,%r9d
    1a23:	ucomisd %xmm0,%xmm1
    1a27:	sete   %r9b
    1a2b:	setnp  %r11b
    1a2f:	and    %r11b,%r9b
    1a32:	test   %r9d,%r9d
    1a35:	mov    %rcx,%r9
    1a38:	cmovne %rdx,%r9
    1a3c:	add    %r9,%rax
    1a3f:	add    $0x1,%r8d
    1a43:	cmp    %esi,%r8d
    1a46:	jl     1a17 <v_sum_truth_10+0x7>
    1a48:	ret
0000000000001aa0 <v_sum_truth_20>:
    1aa0:	xor    %eax,%eax
    1aa2:	xor    %r8d,%r8d
    1aa5:	jmp    1ad3 <v_sum_truth_20+0x33>
    1aa7:	mov    %r8,%r9
    1aaa:	movsd  (%rdi,%r9,8),%xmm1
    1ab0:	xor    %r9d,%r9d
    1ab3:	ucomisd %xmm0,%xmm1
    1ab7:	sete   %r9b
    1abb:	setnp  %r11b
    1abf:	and    %r11b,%r9b
    1ac2:	test   %r9d,%r9d
    1ac5:	mov    %rcx,%r9
    1ac8:	cmovne %rdx,%r9
    1acc:	add    %r9,%rax
    1acf:	add    $0x1,%r8d
    1ad3:	cmp    %esi,%r8d
    1ad6:	jl     1aa7 <v_sum_truth_20+0x7>
    1ad8:	ret
0000000000001b30 <v_sum_truth_30>:
    1b30:	xor    %eax,%eax
    1b32:	xor    %r8d,%r8d
    1b35:	jmp    1b63 <v_sum_truth_30+0x33>
    1b37:	mov    %r8,%r9
    1b3a:	movsd  (%rdi,%r9,8),%xmm1
    1b40:	xor    %r9d,%r9d
    1b43:	ucomisd %xmm0,%xmm1
    1b47:	sete   %r9b
    1b4b:	setnp  %r11b
    1b4f:	and    %r11b,%r9b
    1b52:	test   %r9d,%r9d
    1b55:	mov    %rcx,%r9
    1b58:	cmovne %rdx,%r9
    1b5c:	add    %r9,%rax
    1b5f:	add    $0x1,%r8d
    1b63:	cmp    %esi,%r8d
    1b66:	jl     1b37 <v_sum_truth_30+0x7>
    1b68:	ret
0000000000001b80 <v_sum_fused_00>:
    1b80:	xor    %eax,%eax
    1b82:	xor    %r8d,%r8d
    1b85:	jmp    1ba6 <v_sum_fused_00+0x26>
    1b87:	mov    %r8,%r9
    1b8a:	movsd  (%rdi,%r9,8),%xmm1
    1b90:	ucomisd %xmm0,%xmm1
    1b94:	mov    %rdx,%r9
    1b97:	cmovne %rcx,%r9
    1b9b:	cmovp  %rcx,%r9
    1b9f:	add    %r9,%rax
    1ba2:	add    $0x1,%r8d
    1ba6:	cmp    %esi,%r8d
    1ba9:	jl     1b87 <v_sum_fused_00+0x7>
    1bab:	ret
0000000000001bd0 <v_sum_fused_10>:
    1bd0:	xor    %eax,%eax
    1bd2:	xor    %r8d,%r8d
    1bd5:	jmp    1bf6 <v_sum_fused_10+0x26>
    1bd7:	mov    %r8,%r9
    1bda:	movsd  (%rdi,%r9,8),%xmm1
    1be0:	ucomisd %xmm0,%xmm1
    1be4:	mov    %rdx,%r9
    1be7:	cmovne %rcx,%r9
    1beb:	cmovp  %rcx,%r9
    1bef:	add    %r9,%rax
    1bf2:	add    $0x1,%r8d
    1bf6:	cmp    %esi,%r8d
    1bf9:	jl     1bd7 <v_sum_fused_10+0x7>
    1bfb:	ret
0000000000001c20 <v_sum_fused_20>:
    1c20:	xor    %eax,%eax
    1c22:	xor    %r8d,%r8d
    1c25:	jmp    1c46 <v_sum_fused_20+0x26>
    1c27:	mov    %r8,%r9
    1c2a:	movsd  (%rdi,%r9,8),%xmm1
    1c30:	ucomisd %xmm0,%xmm1
    1c34:	mov    %rdx,%r9
    1c37:	cmovne %rcx,%r9
    1c3b:	cmovp  %rcx,%r9
    1c3f:	add    %r9,%rax
    1c42:	add    $0x1,%r8d
    1c46:	cmp    %esi,%r8d
    1c49:	jl     1c27 <v_sum_fused_20+0x7>
    1c4b:	ret
0000000000001cb0 <v_sum_fused_30>:
    1cb0:	xor    %eax,%eax
    1cb2:	xor    %r8d,%r8d
    1cb5:	jmp    1cd6 <v_sum_fused_30+0x26>
    1cb7:	mov    %r8,%r9
    1cba:	movsd  (%rdi,%r9,8),%xmm1
    1cc0:	ucomisd %xmm0,%xmm1
    1cc4:	mov    %rdx,%r9
    1cc7:	cmovne %rcx,%r9
    1ccb:	cmovp  %rcx,%r9
    1ccf:	add    %r9,%rax
    1cd2:	add    $0x1,%r8d
    1cd6:	cmp    %esi,%r8d
    1cd9:	jl     1cb7 <v_sum_fused_30+0x7>
    1cdb:	ret
