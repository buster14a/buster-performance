0000000000001350 <v_head_10>:
    1350:	xor    %eax,%eax
    1352:	xor    %ecx,%ecx
    1354:	jmp    1373 <v_head_10+0x23>
    1356:	mov    %rcx,%rdx
    1359:	movslq (%rdi,%rdx,4),%rdx
    135d:	xor    %r8d,%r8d
    1360:	mov    %rdx,%r9
    1363:	cmp    $0x80,%edx
    1369:	cmovg  %r9,%r8
    136d:	add    %r8,%rax
    1370:	add    $0x1,%ecx
    1373:	cmp    %esi,%ecx
    1375:	jl     1356 <v_head_10+0x6>
    1377:	ret
00000000000013a0 <v_head_20>:
    13a0:	xor    %eax,%eax
    13a2:	xor    %ecx,%ecx
    13a4:	jmp    13c3 <v_head_20+0x23>
    13a6:	mov    %rcx,%rdx
    13a9:	movslq (%rdi,%rdx,4),%rdx
    13ad:	xor    %r8d,%r8d
    13b0:	mov    %rdx,%r9
    13b3:	cmp    $0x80,%edx
    13b9:	cmovg  %r9,%r8
    13bd:	add    %r8,%rax
    13c0:	add    $0x1,%ecx
    13c3:	cmp    %esi,%ecx
    13c5:	jl     13a6 <v_head_20+0x6>
    13c7:	ret
0000000000001410 <v_nomov_10>:
    1410:	xor    %eax,%eax
    1412:	xor    %ecx,%ecx
    1414:	jmp    1430 <v_nomov_10+0x20>
    1416:	mov    %rcx,%rdx
    1419:	movslq (%rdi,%rdx,4),%rdx
    141d:	xor    %r8d,%r8d
    1420:	cmp    $0x80,%edx
    1426:	cmovg  %rdx,%r8
    142a:	add    %r8,%rax
    142d:	add    $0x1,%ecx
    1430:	cmp    %esi,%ecx
    1432:	jl     1416 <v_nomov_10+0x6>
    1434:	ret
0000000000001460 <v_nomov_20>:
    1460:	xor    %eax,%eax
    1462:	xor    %ecx,%ecx
    1464:	jmp    1480 <v_nomov_20+0x20>
    1466:	mov    %rcx,%rdx
    1469:	movslq (%rdi,%rdx,4),%rdx
    146d:	xor    %r8d,%r8d
    1470:	cmp    $0x80,%edx
    1476:	cmovg  %rdx,%r8
    147a:	add    %r8,%rax
    147d:	add    $0x1,%ecx
    1480:	cmp    %esi,%ecx
    1482:	jl     1466 <v_nomov_20+0x6>
    1484:	ret
00000000000014d0 <v_main_10>:
    14d0:	xor    %eax,%eax
    14d2:	xor    %ecx,%ecx
    14d4:	jmp    14fa <v_main_10+0x2a>
    14d6:	mov    %rcx,%rdx
    14d9:	movslq (%rdi,%rdx,4),%rdx
    14dd:	xor    %r8d,%r8d
    14e0:	cmp    $0x80,%edx
    14e6:	setg   %r8b
    14ea:	xor    %r9d,%r9d
    14ed:	test   %r8d,%r8d
    14f0:	cmovne %rdx,%r9
    14f4:	add    %r9,%rax
    14f7:	add    $0x1,%ecx
    14fa:	cmp    %esi,%ecx
    14fc:	jl     14d6 <v_main_10+0x6>
    14fe:	ret
0000000000001520 <v_main_20>:
    1520:	xor    %eax,%eax
    1522:	xor    %ecx,%ecx
    1524:	jmp    154a <v_main_20+0x2a>
    1526:	mov    %rcx,%rdx
    1529:	movslq (%rdi,%rdx,4),%rdx
    152d:	xor    %r8d,%r8d
    1530:	cmp    $0x80,%edx
    1536:	setg   %r8b
    153a:	xor    %r9d,%r9d
    153d:	test   %r8d,%r8d
    1540:	cmovne %rdx,%r9
    1544:	add    %r9,%rax
    1547:	add    $0x1,%ecx
    154a:	cmp    %esi,%ecx
    154c:	jl     1526 <v_main_20+0x6>
    154e:	ret
