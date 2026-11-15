00000000000014c0 <v_head_00>:
    14c0:	xor    %eax,%eax
    14c2:	xor    %ecx,%ecx
    14c4:	jmp    14e3 <v_head_00+0x23>
    14c6:	mov    %rcx,%rdx
    14c9:	movslq (%rdi,%rdx,4),%rdx
    14cd:	xor    %r8d,%r8d
    14d0:	mov    %rdx,%r9
    14d3:	cmp    $0x80,%edx
    14d9:	cmovg  %r9,%r8
    14dd:	add    %r8,%rax
    14e0:	add    $0x1,%ecx
    14e3:	cmp    %esi,%ecx
    14e5:	jl     14c6 <v_head_00+0x6>
    14e7:	ret
0000000000001510 <v_head_10>:
    1510:	xor    %eax,%eax
    1512:	xor    %ecx,%ecx
    1514:	jmp    1533 <v_head_10+0x23>
    1516:	mov    %rcx,%rdx
    1519:	movslq (%rdi,%rdx,4),%rdx
    151d:	xor    %r8d,%r8d
    1520:	mov    %rdx,%r9
    1523:	cmp    $0x80,%edx
    1529:	cmovg  %r9,%r8
    152d:	add    %r8,%rax
    1530:	add    $0x1,%ecx
    1533:	cmp    %esi,%ecx
    1535:	jl     1516 <v_head_10+0x6>
    1537:	ret
0000000000001560 <v_head_20>:
    1560:	xor    %eax,%eax
    1562:	xor    %ecx,%ecx
    1564:	jmp    1583 <v_head_20+0x23>
    1566:	mov    %rcx,%rdx
    1569:	movslq (%rdi,%rdx,4),%rdx
    156d:	xor    %r8d,%r8d
    1570:	mov    %rdx,%r9
    1573:	cmp    $0x80,%edx
    1579:	cmovg  %r9,%r8
    157d:	add    %r8,%rax
    1580:	add    $0x1,%ecx
    1583:	cmp    %esi,%ecx
    1585:	jl     1566 <v_head_20+0x6>
    1587:	ret
00000000000015f0 <v_head_30>:
    15f0:	xor    %eax,%eax
    15f2:	xor    %ecx,%ecx
    15f4:	jmp    1613 <v_head_30+0x23>
    15f6:	mov    %rcx,%rdx
    15f9:	movslq (%rdi,%rdx,4),%rdx
    15fd:	xor    %r8d,%r8d
    1600:	mov    %rdx,%r9
    1603:	cmp    $0x80,%edx
    1609:	cmovg  %r9,%r8
    160d:	add    %r8,%rax
    1610:	add    $0x1,%ecx
    1613:	cmp    %esi,%ecx
    1615:	jl     15f6 <v_head_30+0x6>
    1617:	ret
0000000000001640 <v_nomov_00>:
    1640:	xor    %eax,%eax
    1642:	xor    %ecx,%ecx
    1644:	jmp    1660 <v_nomov_00+0x20>
    1646:	mov    %rcx,%rdx
    1649:	movslq (%rdi,%rdx,4),%rdx
    164d:	xor    %r8d,%r8d
    1650:	cmp    $0x80,%edx
    1656:	cmovg  %rdx,%r8
    165a:	add    %r8,%rax
    165d:	add    $0x1,%ecx
    1660:	cmp    %esi,%ecx
    1662:	jl     1646 <v_nomov_00+0x6>
    1664:	ret
0000000000001690 <v_nomov_10>:
    1690:	xor    %eax,%eax
    1692:	xor    %ecx,%ecx
    1694:	jmp    16b0 <v_nomov_10+0x20>
    1696:	mov    %rcx,%rdx
    1699:	movslq (%rdi,%rdx,4),%rdx
    169d:	xor    %r8d,%r8d
    16a0:	cmp    $0x80,%edx
    16a6:	cmovg  %rdx,%r8
    16aa:	add    %r8,%rax
    16ad:	add    $0x1,%ecx
    16b0:	cmp    %esi,%ecx
    16b2:	jl     1696 <v_nomov_10+0x6>
    16b4:	ret
00000000000016e0 <v_nomov_20>:
    16e0:	xor    %eax,%eax
    16e2:	xor    %ecx,%ecx
    16e4:	jmp    1700 <v_nomov_20+0x20>
    16e6:	mov    %rcx,%rdx
    16e9:	movslq (%rdi,%rdx,4),%rdx
    16ed:	xor    %r8d,%r8d
    16f0:	cmp    $0x80,%edx
    16f6:	cmovg  %rdx,%r8
    16fa:	add    %r8,%rax
    16fd:	add    $0x1,%ecx
    1700:	cmp    %esi,%ecx
    1702:	jl     16e6 <v_nomov_20+0x6>
    1704:	ret
0000000000001770 <v_nomov_30>:
    1770:	xor    %eax,%eax
    1772:	xor    %ecx,%ecx
    1774:	jmp    1790 <v_nomov_30+0x20>
    1776:	mov    %rcx,%rdx
    1779:	movslq (%rdi,%rdx,4),%rdx
    177d:	xor    %r8d,%r8d
    1780:	cmp    $0x80,%edx
    1786:	cmovg  %rdx,%r8
    178a:	add    %r8,%rax
    178d:	add    $0x1,%ecx
    1790:	cmp    %esi,%ecx
    1792:	jl     1776 <v_nomov_30+0x6>
    1794:	ret
00000000000017c0 <v_main_00>:
    17c0:	xor    %eax,%eax
    17c2:	xor    %ecx,%ecx
    17c4:	jmp    17ea <v_main_00+0x2a>
    17c6:	mov    %rcx,%rdx
    17c9:	movslq (%rdi,%rdx,4),%rdx
    17cd:	xor    %r8d,%r8d
    17d0:	cmp    $0x80,%edx
    17d6:	setg   %r8b
    17da:	xor    %r9d,%r9d
    17dd:	test   %r8d,%r8d
    17e0:	cmovne %rdx,%r9
    17e4:	add    %r9,%rax
    17e7:	add    $0x1,%ecx
    17ea:	cmp    %esi,%ecx
    17ec:	jl     17c6 <v_main_00+0x6>
    17ee:	ret
0000000000001810 <v_main_10>:
    1810:	xor    %eax,%eax
    1812:	xor    %ecx,%ecx
    1814:	jmp    183a <v_main_10+0x2a>
    1816:	mov    %rcx,%rdx
    1819:	movslq (%rdi,%rdx,4),%rdx
    181d:	xor    %r8d,%r8d
    1820:	cmp    $0x80,%edx
    1826:	setg   %r8b
    182a:	xor    %r9d,%r9d
    182d:	test   %r8d,%r8d
    1830:	cmovne %rdx,%r9
    1834:	add    %r9,%rax
    1837:	add    $0x1,%ecx
    183a:	cmp    %esi,%ecx
    183c:	jl     1816 <v_main_10+0x6>
    183e:	ret
0000000000001860 <v_main_20>:
    1860:	xor    %eax,%eax
    1862:	xor    %ecx,%ecx
    1864:	jmp    188a <v_main_20+0x2a>
    1866:	mov    %rcx,%rdx
    1869:	movslq (%rdi,%rdx,4),%rdx
    186d:	xor    %r8d,%r8d
    1870:	cmp    $0x80,%edx
    1876:	setg   %r8b
    187a:	xor    %r9d,%r9d
    187d:	test   %r8d,%r8d
    1880:	cmovne %rdx,%r9
    1884:	add    %r9,%rax
    1887:	add    $0x1,%ecx
    188a:	cmp    %esi,%ecx
    188c:	jl     1866 <v_main_20+0x6>
    188e:	ret
00000000000018f0 <v_main_30>:
    18f0:	xor    %eax,%eax
    18f2:	xor    %ecx,%ecx
    18f4:	jmp    191a <v_main_30+0x2a>
    18f6:	mov    %rcx,%rdx
    18f9:	movslq (%rdi,%rdx,4),%rdx
    18fd:	xor    %r8d,%r8d
    1900:	cmp    $0x80,%edx
    1906:	setg   %r8b
    190a:	xor    %r9d,%r9d
    190d:	test   %r8d,%r8d
    1910:	cmovne %rdx,%r9
    1914:	add    %r9,%rax
    1917:	add    $0x1,%ecx
    191a:	cmp    %esi,%ecx
    191c:	jl     18f6 <v_main_30+0x6>
    191e:	ret
