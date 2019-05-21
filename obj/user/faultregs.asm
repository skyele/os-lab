
obj/user/faultregs.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 b0 05 00 00       	call   8005e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 31 18 80 00       	push   $0x801831
  800049:	68 00 18 80 00       	push   $0x801800
  80004e:	e8 2b 07 00 00       	call   80077e <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 10 18 80 00       	push   $0x801810
  80005c:	68 14 18 80 00       	push   $0x801814
  800061:	e8 18 07 00 00       	call   80077e <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 28 18 80 00       	push   $0x801828
  80007b:	e8 fe 06 00 00       	call   80077e <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 32 18 80 00       	push   $0x801832
  800093:	68 14 18 80 00       	push   $0x801814
  800098:	e8 e1 06 00 00       	call   80077e <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 28 18 80 00       	push   $0x801828
  8000b4:	e8 c5 06 00 00       	call   80077e <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 36 18 80 00       	push   $0x801836
  8000cc:	68 14 18 80 00       	push   $0x801814
  8000d1:	e8 a8 06 00 00       	call   80077e <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 28 18 80 00       	push   $0x801828
  8000ed:	e8 8c 06 00 00       	call   80077e <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 3a 18 80 00       	push   $0x80183a
  800105:	68 14 18 80 00       	push   $0x801814
  80010a:	e8 6f 06 00 00       	call   80077e <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 28 18 80 00       	push   $0x801828
  800126:	e8 53 06 00 00       	call   80077e <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 3e 18 80 00       	push   $0x80183e
  80013e:	68 14 18 80 00       	push   $0x801814
  800143:	e8 36 06 00 00       	call   80077e <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 28 18 80 00       	push   $0x801828
  80015f:	e8 1a 06 00 00       	call   80077e <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 42 18 80 00       	push   $0x801842
  800177:	68 14 18 80 00       	push   $0x801814
  80017c:	e8 fd 05 00 00       	call   80077e <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 28 18 80 00       	push   $0x801828
  800198:	e8 e1 05 00 00       	call   80077e <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 46 18 80 00       	push   $0x801846
  8001b0:	68 14 18 80 00       	push   $0x801814
  8001b5:	e8 c4 05 00 00       	call   80077e <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 28 18 80 00       	push   $0x801828
  8001d1:	e8 a8 05 00 00       	call   80077e <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 4a 18 80 00       	push   $0x80184a
  8001e9:	68 14 18 80 00       	push   $0x801814
  8001ee:	e8 8b 05 00 00       	call   80077e <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 28 18 80 00       	push   $0x801828
  80020a:	e8 6f 05 00 00       	call   80077e <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 4e 18 80 00       	push   $0x80184e
  800222:	68 14 18 80 00       	push   $0x801814
  800227:	e8 52 05 00 00       	call   80077e <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 28 18 80 00       	push   $0x801828
  800243:	e8 36 05 00 00       	call   80077e <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 55 18 80 00       	push   $0x801855
  800253:	68 14 18 80 00       	push   $0x801814
  800258:	e8 21 05 00 00       	call   80077e <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 28 18 80 00       	push   $0x801828
  800274:	e8 05 05 00 00       	call   80077e <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 59 18 80 00       	push   $0x801859
  800284:	e8 f5 04 00 00       	call   80077e <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 28 18 80 00       	push   $0x801828
  800294:	e8 e5 04 00 00       	call   80077e <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 24 18 80 00       	push   $0x801824
  8002a9:	e8 d0 04 00 00       	call   80077e <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 24 18 80 00       	push   $0x801824
  8002c3:	e8 b6 04 00 00       	call   80077e <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 24 18 80 00       	push   $0x801824
  8002d8:	e8 a1 04 00 00       	call   80077e <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 24 18 80 00       	push   $0x801824
  8002ed:	e8 8c 04 00 00       	call   80077e <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 24 18 80 00       	push   $0x801824
  800302:	e8 77 04 00 00       	call   80077e <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 24 18 80 00       	push   $0x801824
  800317:	e8 62 04 00 00       	call   80077e <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 24 18 80 00       	push   $0x801824
  80032c:	e8 4d 04 00 00       	call   80077e <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 24 18 80 00       	push   $0x801824
  800341:	e8 38 04 00 00       	call   80077e <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 24 18 80 00       	push   $0x801824
  800356:	e8 23 04 00 00       	call   80077e <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 55 18 80 00       	push   $0x801855
  800366:	68 14 18 80 00       	push   $0x801814
  80036b:	e8 0e 04 00 00       	call   80077e <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 24 18 80 00       	push   $0x801824
  800387:	e8 f2 03 00 00       	call   80077e <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 59 18 80 00       	push   $0x801859
  800397:	e8 e2 03 00 00       	call   80077e <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 24 18 80 00       	push   $0x801824
  8003af:	e8 ca 03 00 00       	call   80077e <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 24 18 80 00       	push   $0x801824
  8003c7:	e8 b2 03 00 00       	call   80077e <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 59 18 80 00       	push   $0x801859
  8003d7:	e8 a2 03 00 00       	call   80077e <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 60 20 80 00    	mov    %edx,0x802060
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 64 20 80 00    	mov    %edx,0x802064
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 68 20 80 00    	mov    %edx,0x802068
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 70 20 80 00    	mov    %edx,0x802070
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 74 20 80 00    	mov    %edx,0x802074
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 78 20 80 00    	mov    %edx,0x802078
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 7f 18 80 00       	push   $0x80187f
  80046b:	68 8d 18 80 00       	push   $0x80188d
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba 78 18 80 00       	mov    $0x801878,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 3a 0e 00 00       	call   8012cf <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 c0 18 80 00       	push   $0x8018c0
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 67 18 80 00       	push   $0x801867
  8004b1:	e8 d2 01 00 00       	call   800688 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 94 18 80 00       	push   $0x801894
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 67 18 80 00       	push   $0x801867
  8004c3:	e8 c0 01 00 00       	call   800688 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 29 10 00 00       	call   801501 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004f9:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004ff:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  800505:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  80050b:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800511:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  800517:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  80051c:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 20 20 80 00    	mov    %edi,0x802020
  800532:	89 35 24 20 80 00    	mov    %esi,0x802024
  800538:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  80053e:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800544:	89 15 34 20 80 00    	mov    %edx,0x802034
  80054a:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800550:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800555:	89 25 48 20 80 00    	mov    %esp,0x802048
  80055b:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800561:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  800567:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  80056d:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800573:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  800579:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  80057f:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800584:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 44 20 80 00       	mov    %eax,0x802044
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	75 30                	jne    8005cf <umain+0x107>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  80059f:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005a4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 a7 18 80 00       	push   $0x8018a7
  8005b1:	68 b8 18 80 00       	push   $0x8018b8
  8005b6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005bb:	ba 78 18 80 00       	mov    $0x801878,%edx
  8005c0:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 f4 18 80 00       	push   $0x8018f4
  8005d7:	e8 a2 01 00 00       	call   80077e <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	57                   	push   %edi
  8005e5:	56                   	push   %esi
  8005e6:	53                   	push   %ebx
  8005e7:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8005ea:	c7 05 cc 20 80 00 00 	movl   $0x0,0x8020cc
  8005f1:	00 00 00 
	envid_t find = sys_getenvid();
  8005f4:	e8 98 0c 00 00       	call   801291 <sys_getenvid>
  8005f9:	8b 1d cc 20 80 00    	mov    0x8020cc,%ebx
  8005ff:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800604:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800609:	bf 01 00 00 00       	mov    $0x1,%edi
  80060e:	eb 0b                	jmp    80061b <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800610:	83 c2 01             	add    $0x1,%edx
  800613:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800619:	74 21                	je     80063c <libmain+0x5b>
		if(envs[i].env_id == find)
  80061b:	89 d1                	mov    %edx,%ecx
  80061d:	c1 e1 07             	shl    $0x7,%ecx
  800620:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800626:	8b 49 48             	mov    0x48(%ecx),%ecx
  800629:	39 c1                	cmp    %eax,%ecx
  80062b:	75 e3                	jne    800610 <libmain+0x2f>
  80062d:	89 d3                	mov    %edx,%ebx
  80062f:	c1 e3 07             	shl    $0x7,%ebx
  800632:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800638:	89 fe                	mov    %edi,%esi
  80063a:	eb d4                	jmp    800610 <libmain+0x2f>
  80063c:	89 f0                	mov    %esi,%eax
  80063e:	84 c0                	test   %al,%al
  800640:	74 06                	je     800648 <libmain+0x67>
  800642:	89 1d cc 20 80 00    	mov    %ebx,0x8020cc
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800648:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80064c:	7e 0a                	jle    800658 <libmain+0x77>
		binaryname = argv[0];
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	ff 75 0c             	pushl  0xc(%ebp)
  80065e:	ff 75 08             	pushl  0x8(%ebp)
  800661:	e8 62 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800666:	e8 0b 00 00 00       	call   800676 <exit>
}
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800671:	5b                   	pop    %ebx
  800672:	5e                   	pop    %esi
  800673:	5f                   	pop    %edi
  800674:	5d                   	pop    %ebp
  800675:	c3                   	ret    

00800676 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80067c:	6a 00                	push   $0x0
  80067e:	e8 cd 0b 00 00       	call   801250 <sys_env_destroy>
}
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	c9                   	leave  
  800687:	c3                   	ret    

00800688 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	56                   	push   %esi
  80068c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80068d:	a1 cc 20 80 00       	mov    0x8020cc,%eax
  800692:	8b 40 48             	mov    0x48(%eax),%eax
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 4c 19 80 00       	push   $0x80194c
  80069d:	50                   	push   %eax
  80069e:	68 1d 19 80 00       	push   $0x80191d
  8006a3:	e8 d6 00 00 00       	call   80077e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8006a8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006ab:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8006b1:	e8 db 0b 00 00       	call   801291 <sys_getenvid>
  8006b6:	83 c4 04             	add    $0x4,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	56                   	push   %esi
  8006c0:	50                   	push   %eax
  8006c1:	68 28 19 80 00       	push   $0x801928
  8006c6:	e8 b3 00 00 00       	call   80077e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006cb:	83 c4 18             	add    $0x18,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	ff 75 10             	pushl  0x10(%ebp)
  8006d2:	e8 56 00 00 00       	call   80072d <vcprintf>
	cprintf("\n");
  8006d7:	c7 04 24 30 18 80 00 	movl   $0x801830,(%esp)
  8006de:	e8 9b 00 00 00       	call   80077e <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006e6:	cc                   	int3   
  8006e7:	eb fd                	jmp    8006e6 <_panic+0x5e>

008006e9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	53                   	push   %ebx
  8006ed:	83 ec 04             	sub    $0x4,%esp
  8006f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006f3:	8b 13                	mov    (%ebx),%edx
  8006f5:	8d 42 01             	lea    0x1(%edx),%eax
  8006f8:	89 03                	mov    %eax,(%ebx)
  8006fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006fd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800701:	3d ff 00 00 00       	cmp    $0xff,%eax
  800706:	74 09                	je     800711 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800708:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80070c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070f:	c9                   	leave  
  800710:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	68 ff 00 00 00       	push   $0xff
  800719:	8d 43 08             	lea    0x8(%ebx),%eax
  80071c:	50                   	push   %eax
  80071d:	e8 f1 0a 00 00       	call   801213 <sys_cputs>
		b->idx = 0;
  800722:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	eb db                	jmp    800708 <putch+0x1f>

0080072d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800736:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80073d:	00 00 00 
	b.cnt = 0;
  800740:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800747:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	ff 75 08             	pushl  0x8(%ebp)
  800750:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800756:	50                   	push   %eax
  800757:	68 e9 06 80 00       	push   $0x8006e9
  80075c:	e8 4a 01 00 00       	call   8008ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800761:	83 c4 08             	add    $0x8,%esp
  800764:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80076a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	e8 9d 0a 00 00       	call   801213 <sys_cputs>

	return b.cnt;
}
  800776:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80077c:	c9                   	leave  
  80077d:	c3                   	ret    

0080077e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800784:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800787:	50                   	push   %eax
  800788:	ff 75 08             	pushl  0x8(%ebp)
  80078b:	e8 9d ff ff ff       	call   80072d <vcprintf>
	va_end(ap);

	return cnt;
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	57                   	push   %edi
  800796:	56                   	push   %esi
  800797:	53                   	push   %ebx
  800798:	83 ec 1c             	sub    $0x1c,%esp
  80079b:	89 c6                	mov    %eax,%esi
  80079d:	89 d7                	mov    %edx,%edi
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8007b1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8007b5:	74 2c                	je     8007e3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8007c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007c7:	39 c2                	cmp    %eax,%edx
  8007c9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8007cc:	73 43                	jae    800811 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8007ce:	83 eb 01             	sub    $0x1,%ebx
  8007d1:	85 db                	test   %ebx,%ebx
  8007d3:	7e 6c                	jle    800841 <printnum+0xaf>
				putch(padc, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	57                   	push   %edi
  8007d9:	ff 75 18             	pushl  0x18(%ebp)
  8007dc:	ff d6                	call   *%esi
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	eb eb                	jmp    8007ce <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	6a 20                	push   $0x20
  8007e8:	6a 00                	push   $0x0
  8007ea:	50                   	push   %eax
  8007eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f1:	89 fa                	mov    %edi,%edx
  8007f3:	89 f0                	mov    %esi,%eax
  8007f5:	e8 98 ff ff ff       	call   800792 <printnum>
		while (--width > 0)
  8007fa:	83 c4 20             	add    $0x20,%esp
  8007fd:	83 eb 01             	sub    $0x1,%ebx
  800800:	85 db                	test   %ebx,%ebx
  800802:	7e 65                	jle    800869 <printnum+0xd7>
			putch(padc, putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	57                   	push   %edi
  800808:	6a 20                	push   $0x20
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb ec                	jmp    8007fd <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	ff 75 18             	pushl  0x18(%ebp)
  800817:	83 eb 01             	sub    $0x1,%ebx
  80081a:	53                   	push   %ebx
  80081b:	50                   	push   %eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 dc             	pushl  -0x24(%ebp)
  800822:	ff 75 d8             	pushl  -0x28(%ebp)
  800825:	ff 75 e4             	pushl  -0x1c(%ebp)
  800828:	ff 75 e0             	pushl  -0x20(%ebp)
  80082b:	e8 70 0d 00 00       	call   8015a0 <__udivdi3>
  800830:	83 c4 18             	add    $0x18,%esp
  800833:	52                   	push   %edx
  800834:	50                   	push   %eax
  800835:	89 fa                	mov    %edi,%edx
  800837:	89 f0                	mov    %esi,%eax
  800839:	e8 54 ff ff ff       	call   800792 <printnum>
  80083e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	57                   	push   %edi
  800845:	83 ec 04             	sub    $0x4,%esp
  800848:	ff 75 dc             	pushl  -0x24(%ebp)
  80084b:	ff 75 d8             	pushl  -0x28(%ebp)
  80084e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800851:	ff 75 e0             	pushl  -0x20(%ebp)
  800854:	e8 57 0e 00 00       	call   8016b0 <__umoddi3>
  800859:	83 c4 14             	add    $0x14,%esp
  80085c:	0f be 80 53 19 80 00 	movsbl 0x801953(%eax),%eax
  800863:	50                   	push   %eax
  800864:	ff d6                	call   *%esi
  800866:	83 c4 10             	add    $0x10,%esp
	}
}
  800869:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5f                   	pop    %edi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800877:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80087b:	8b 10                	mov    (%eax),%edx
  80087d:	3b 50 04             	cmp    0x4(%eax),%edx
  800880:	73 0a                	jae    80088c <sprintputch+0x1b>
		*b->buf++ = ch;
  800882:	8d 4a 01             	lea    0x1(%edx),%ecx
  800885:	89 08                	mov    %ecx,(%eax)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	88 02                	mov    %al,(%edx)
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <printfmt>:
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800897:	50                   	push   %eax
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 05 00 00 00       	call   8008ab <vprintfmt>
}
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	c9                   	leave  
  8008aa:	c3                   	ret    

008008ab <vprintfmt>:
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	57                   	push   %edi
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
  8008b1:	83 ec 3c             	sub    $0x3c,%esp
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ba:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008bd:	e9 32 04 00 00       	jmp    800cf4 <vprintfmt+0x449>
		padc = ' ';
  8008c2:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8008c6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8008cd:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8008d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008e2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8008e9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008ee:	8d 47 01             	lea    0x1(%edi),%eax
  8008f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f4:	0f b6 17             	movzbl (%edi),%edx
  8008f7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008fa:	3c 55                	cmp    $0x55,%al
  8008fc:	0f 87 12 05 00 00    	ja     800e14 <vprintfmt+0x569>
  800902:	0f b6 c0             	movzbl %al,%eax
  800905:	ff 24 85 40 1b 80 00 	jmp    *0x801b40(,%eax,4)
  80090c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80090f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800913:	eb d9                	jmp    8008ee <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800918:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80091c:	eb d0                	jmp    8008ee <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80091e:	0f b6 d2             	movzbl %dl,%edx
  800921:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
  800929:	89 75 08             	mov    %esi,0x8(%ebp)
  80092c:	eb 03                	jmp    800931 <vprintfmt+0x86>
  80092e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800931:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800934:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800938:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80093b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80093e:	83 fe 09             	cmp    $0x9,%esi
  800941:	76 eb                	jbe    80092e <vprintfmt+0x83>
  800943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800946:	8b 75 08             	mov    0x8(%ebp),%esi
  800949:	eb 14                	jmp    80095f <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 04             	lea    0x4(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80095c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 89                	jns    8008ee <vprintfmt+0x43>
				width = precision, precision = -1;
  800965:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800968:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80096b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800972:	e9 77 ff ff ff       	jmp    8008ee <vprintfmt+0x43>
  800977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097a:	85 c0                	test   %eax,%eax
  80097c:	0f 48 c1             	cmovs  %ecx,%eax
  80097f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800985:	e9 64 ff ff ff       	jmp    8008ee <vprintfmt+0x43>
  80098a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80098d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800994:	e9 55 ff ff ff       	jmp    8008ee <vprintfmt+0x43>
			lflag++;
  800999:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009a0:	e9 49 ff ff ff       	jmp    8008ee <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	8d 78 04             	lea    0x4(%eax),%edi
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	53                   	push   %ebx
  8009af:	ff 30                	pushl  (%eax)
  8009b1:	ff d6                	call   *%esi
			break;
  8009b3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009b6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009b9:	e9 33 03 00 00       	jmp    800cf1 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	8d 78 04             	lea    0x4(%eax),%edi
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	99                   	cltd   
  8009c7:	31 d0                	xor    %edx,%eax
  8009c9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009cb:	83 f8 0f             	cmp    $0xf,%eax
  8009ce:	7f 23                	jg     8009f3 <vprintfmt+0x148>
  8009d0:	8b 14 85 a0 1c 80 00 	mov    0x801ca0(,%eax,4),%edx
  8009d7:	85 d2                	test   %edx,%edx
  8009d9:	74 18                	je     8009f3 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8009db:	52                   	push   %edx
  8009dc:	68 74 19 80 00       	push   $0x801974
  8009e1:	53                   	push   %ebx
  8009e2:	56                   	push   %esi
  8009e3:	e8 a6 fe ff ff       	call   80088e <printfmt>
  8009e8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009eb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009ee:	e9 fe 02 00 00       	jmp    800cf1 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8009f3:	50                   	push   %eax
  8009f4:	68 6b 19 80 00       	push   $0x80196b
  8009f9:	53                   	push   %ebx
  8009fa:	56                   	push   %esi
  8009fb:	e8 8e fe ff ff       	call   80088e <printfmt>
  800a00:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a03:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a06:	e9 e6 02 00 00       	jmp    800cf1 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	83 c0 04             	add    $0x4,%eax
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a19:	85 c9                	test   %ecx,%ecx
  800a1b:	b8 64 19 80 00       	mov    $0x801964,%eax
  800a20:	0f 45 c1             	cmovne %ecx,%eax
  800a23:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800a26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2a:	7e 06                	jle    800a32 <vprintfmt+0x187>
  800a2c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a30:	75 0d                	jne    800a3f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a35:	89 c7                	mov    %eax,%edi
  800a37:	03 45 e0             	add    -0x20(%ebp),%eax
  800a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a3d:	eb 53                	jmp    800a92 <vprintfmt+0x1e7>
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 d8             	pushl  -0x28(%ebp)
  800a45:	50                   	push   %eax
  800a46:	e8 71 04 00 00       	call   800ebc <strnlen>
  800a4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a4e:	29 c1                	sub    %eax,%ecx
  800a50:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a58:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5f:	eb 0f                	jmp    800a70 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	53                   	push   %ebx
  800a65:	ff 75 e0             	pushl  -0x20(%ebp)
  800a68:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6a:	83 ef 01             	sub    $0x1,%edi
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	85 ff                	test   %edi,%edi
  800a72:	7f ed                	jg     800a61 <vprintfmt+0x1b6>
  800a74:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800a77:	85 c9                	test   %ecx,%ecx
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7e:	0f 49 c1             	cmovns %ecx,%eax
  800a81:	29 c1                	sub    %eax,%ecx
  800a83:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a86:	eb aa                	jmp    800a32 <vprintfmt+0x187>
					putch(ch, putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	53                   	push   %ebx
  800a8c:	52                   	push   %edx
  800a8d:	ff d6                	call   *%esi
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a95:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a97:	83 c7 01             	add    $0x1,%edi
  800a9a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a9e:	0f be d0             	movsbl %al,%edx
  800aa1:	85 d2                	test   %edx,%edx
  800aa3:	74 4b                	je     800af0 <vprintfmt+0x245>
  800aa5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800aa9:	78 06                	js     800ab1 <vprintfmt+0x206>
  800aab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800aaf:	78 1e                	js     800acf <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800ab1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800ab5:	74 d1                	je     800a88 <vprintfmt+0x1dd>
  800ab7:	0f be c0             	movsbl %al,%eax
  800aba:	83 e8 20             	sub    $0x20,%eax
  800abd:	83 f8 5e             	cmp    $0x5e,%eax
  800ac0:	76 c6                	jbe    800a88 <vprintfmt+0x1dd>
					putch('?', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	53                   	push   %ebx
  800ac6:	6a 3f                	push   $0x3f
  800ac8:	ff d6                	call   *%esi
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	eb c3                	jmp    800a92 <vprintfmt+0x1e7>
  800acf:	89 cf                	mov    %ecx,%edi
  800ad1:	eb 0e                	jmp    800ae1 <vprintfmt+0x236>
				putch(' ', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	53                   	push   %ebx
  800ad7:	6a 20                	push   $0x20
  800ad9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800adb:	83 ef 01             	sub    $0x1,%edi
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	85 ff                	test   %edi,%edi
  800ae3:	7f ee                	jg     800ad3 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800ae5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ae8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aeb:	e9 01 02 00 00       	jmp    800cf1 <vprintfmt+0x446>
  800af0:	89 cf                	mov    %ecx,%edi
  800af2:	eb ed                	jmp    800ae1 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800af4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800af7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800afe:	e9 eb fd ff ff       	jmp    8008ee <vprintfmt+0x43>
	if (lflag >= 2)
  800b03:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b07:	7f 21                	jg     800b2a <vprintfmt+0x27f>
	else if (lflag)
  800b09:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b0d:	74 68                	je     800b77 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b12:	8b 00                	mov    (%eax),%eax
  800b14:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b17:	89 c1                	mov    %eax,%ecx
  800b19:	c1 f9 1f             	sar    $0x1f,%ecx
  800b1c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	8d 40 04             	lea    0x4(%eax),%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	eb 17                	jmp    800b41 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2d:	8b 50 04             	mov    0x4(%eax),%edx
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b35:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8d 40 08             	lea    0x8(%eax),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b44:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800b4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b51:	78 3f                	js     800b92 <vprintfmt+0x2e7>
			base = 10;
  800b53:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800b58:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800b5c:	0f 84 71 01 00 00    	je     800cd3 <vprintfmt+0x428>
				putch('+', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	53                   	push   %ebx
  800b66:	6a 2b                	push   $0x2b
  800b68:	ff d6                	call   *%esi
  800b6a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b72:	e9 5c 01 00 00       	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800b77:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b7f:	89 c1                	mov    %eax,%ecx
  800b81:	c1 f9 1f             	sar    $0x1f,%ecx
  800b84:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b87:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8a:	8d 40 04             	lea    0x4(%eax),%eax
  800b8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b90:	eb af                	jmp    800b41 <vprintfmt+0x296>
				putch('-', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	53                   	push   %ebx
  800b96:	6a 2d                	push   $0x2d
  800b98:	ff d6                	call   *%esi
				num = -(long long) num;
  800b9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ba0:	f7 d8                	neg    %eax
  800ba2:	83 d2 00             	adc    $0x0,%edx
  800ba5:	f7 da                	neg    %edx
  800ba7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800baa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bad:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb5:	e9 19 01 00 00       	jmp    800cd3 <vprintfmt+0x428>
	if (lflag >= 2)
  800bba:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bbe:	7f 29                	jg     800be9 <vprintfmt+0x33e>
	else if (lflag)
  800bc0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bc4:	74 44                	je     800c0a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd9:	8d 40 04             	lea    0x4(%eax),%eax
  800bdc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bdf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be4:	e9 ea 00 00 00       	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	8b 50 04             	mov    0x4(%eax),%edx
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bf4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	8d 40 08             	lea    0x8(%eax),%eax
  800bfd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c05:	e9 c9 00 00 00       	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c17:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	8d 40 04             	lea    0x4(%eax),%eax
  800c20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c23:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c28:	e9 a6 00 00 00       	jmp    800cd3 <vprintfmt+0x428>
			putch('0', putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	53                   	push   %ebx
  800c31:	6a 30                	push   $0x30
  800c33:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c3c:	7f 26                	jg     800c64 <vprintfmt+0x3b9>
	else if (lflag)
  800c3e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c42:	74 3e                	je     800c82 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800c44:	8b 45 14             	mov    0x14(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c51:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	8d 40 04             	lea    0x4(%eax),%eax
  800c5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c62:	eb 6f                	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c64:	8b 45 14             	mov    0x14(%ebp),%eax
  800c67:	8b 50 04             	mov    0x4(%eax),%edx
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	8d 40 08             	lea    0x8(%eax),%eax
  800c78:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800c80:	eb 51                	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	8b 00                	mov    (%eax),%eax
  800c87:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	8d 40 04             	lea    0x4(%eax),%eax
  800c98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca0:	eb 31                	jmp    800cd3 <vprintfmt+0x428>
			putch('0', putdat);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	53                   	push   %ebx
  800ca6:	6a 30                	push   $0x30
  800ca8:	ff d6                	call   *%esi
			putch('x', putdat);
  800caa:	83 c4 08             	add    $0x8,%esp
  800cad:	53                   	push   %ebx
  800cae:	6a 78                	push   $0x78
  800cb0:	ff d6                	call   *%esi
			num = (unsigned long long)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800cc2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	8d 40 04             	lea    0x4(%eax),%eax
  800ccb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cce:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800cda:	52                   	push   %edx
  800cdb:	ff 75 e0             	pushl  -0x20(%ebp)
  800cde:	50                   	push   %eax
  800cdf:	ff 75 dc             	pushl  -0x24(%ebp)
  800ce2:	ff 75 d8             	pushl  -0x28(%ebp)
  800ce5:	89 da                	mov    %ebx,%edx
  800ce7:	89 f0                	mov    %esi,%eax
  800ce9:	e8 a4 fa ff ff       	call   800792 <printnum>
			break;
  800cee:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf4:	83 c7 01             	add    $0x1,%edi
  800cf7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cfb:	83 f8 25             	cmp    $0x25,%eax
  800cfe:	0f 84 be fb ff ff    	je     8008c2 <vprintfmt+0x17>
			if (ch == '\0')
  800d04:	85 c0                	test   %eax,%eax
  800d06:	0f 84 28 01 00 00    	je     800e34 <vprintfmt+0x589>
			putch(ch, putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	53                   	push   %ebx
  800d10:	50                   	push   %eax
  800d11:	ff d6                	call   *%esi
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	eb dc                	jmp    800cf4 <vprintfmt+0x449>
	if (lflag >= 2)
  800d18:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d1c:	7f 26                	jg     800d44 <vprintfmt+0x499>
	else if (lflag)
  800d1e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d22:	74 41                	je     800d65 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d31:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d34:	8b 45 14             	mov    0x14(%ebp),%eax
  800d37:	8d 40 04             	lea    0x4(%eax),%eax
  800d3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d3d:	b8 10 00 00 00       	mov    $0x10,%eax
  800d42:	eb 8f                	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d44:	8b 45 14             	mov    0x14(%ebp),%eax
  800d47:	8b 50 04             	mov    0x4(%eax),%edx
  800d4a:	8b 00                	mov    (%eax),%eax
  800d4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	8d 40 08             	lea    0x8(%eax),%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d5b:	b8 10 00 00 00       	mov    $0x10,%eax
  800d60:	e9 6e ff ff ff       	jmp    800cd3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d72:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d75:	8b 45 14             	mov    0x14(%ebp),%eax
  800d78:	8d 40 04             	lea    0x4(%eax),%eax
  800d7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d7e:	b8 10 00 00 00       	mov    $0x10,%eax
  800d83:	e9 4b ff ff ff       	jmp    800cd3 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800d88:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8b:	83 c0 04             	add    $0x4,%eax
  800d8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	85 c0                	test   %eax,%eax
  800d98:	74 14                	je     800dae <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800d9a:	8b 13                	mov    (%ebx),%edx
  800d9c:	83 fa 7f             	cmp    $0x7f,%edx
  800d9f:	7f 37                	jg     800dd8 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800da1:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800da3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800da6:	89 45 14             	mov    %eax,0x14(%ebp)
  800da9:	e9 43 ff ff ff       	jmp    800cf1 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800dae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db3:	bf 8d 1a 80 00       	mov    $0x801a8d,%edi
							putch(ch, putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	53                   	push   %ebx
  800dbc:	50                   	push   %eax
  800dbd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800dbf:	83 c7 01             	add    $0x1,%edi
  800dc2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 eb                	jne    800db8 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800dcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd3:	e9 19 ff ff ff       	jmp    800cf1 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800dd8:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800dda:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ddf:	bf c5 1a 80 00       	mov    $0x801ac5,%edi
							putch(ch, putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	53                   	push   %ebx
  800de8:	50                   	push   %eax
  800de9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800deb:	83 c7 01             	add    $0x1,%edi
  800dee:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 eb                	jne    800de4 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800df9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800dff:	e9 ed fe ff ff       	jmp    800cf1 <vprintfmt+0x446>
			putch(ch, putdat);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	53                   	push   %ebx
  800e08:	6a 25                	push   $0x25
  800e0a:	ff d6                	call   *%esi
			break;
  800e0c:	83 c4 10             	add    $0x10,%esp
  800e0f:	e9 dd fe ff ff       	jmp    800cf1 <vprintfmt+0x446>
			putch('%', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	53                   	push   %ebx
  800e18:	6a 25                	push   $0x25
  800e1a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e1c:	83 c4 10             	add    $0x10,%esp
  800e1f:	89 f8                	mov    %edi,%eax
  800e21:	eb 03                	jmp    800e26 <vprintfmt+0x57b>
  800e23:	83 e8 01             	sub    $0x1,%eax
  800e26:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e2a:	75 f7                	jne    800e23 <vprintfmt+0x578>
  800e2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e2f:	e9 bd fe ff ff       	jmp    800cf1 <vprintfmt+0x446>
}
  800e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 18             	sub    $0x18,%esp
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e4b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e4f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	74 26                	je     800e83 <vsnprintf+0x47>
  800e5d:	85 d2                	test   %edx,%edx
  800e5f:	7e 22                	jle    800e83 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e61:	ff 75 14             	pushl  0x14(%ebp)
  800e64:	ff 75 10             	pushl  0x10(%ebp)
  800e67:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e6a:	50                   	push   %eax
  800e6b:	68 71 08 80 00       	push   $0x800871
  800e70:	e8 36 fa ff ff       	call   8008ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e78:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7e:	83 c4 10             	add    $0x10,%esp
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    
		return -E_INVAL;
  800e83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e88:	eb f7                	jmp    800e81 <vsnprintf+0x45>

00800e8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e90:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e93:	50                   	push   %eax
  800e94:	ff 75 10             	pushl  0x10(%ebp)
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 9a ff ff ff       	call   800e3c <vsnprintf>
	va_end(ap);

	return rc;
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800eb3:	74 05                	je     800eba <strlen+0x16>
		n++;
  800eb5:	83 c0 01             	add    $0x1,%eax
  800eb8:	eb f5                	jmp    800eaf <strlen+0xb>
	return n;
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eca:	39 c2                	cmp    %eax,%edx
  800ecc:	74 0d                	je     800edb <strnlen+0x1f>
  800ece:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ed2:	74 05                	je     800ed9 <strnlen+0x1d>
		n++;
  800ed4:	83 c2 01             	add    $0x1,%edx
  800ed7:	eb f1                	jmp    800eca <strnlen+0xe>
  800ed9:	89 d0                	mov    %edx,%eax
	return n;
}
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	53                   	push   %ebx
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  800eec:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ef0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ef3:	83 c2 01             	add    $0x1,%edx
  800ef6:	84 c9                	test   %cl,%cl
  800ef8:	75 f2                	jne    800eec <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800efa:	5b                   	pop    %ebx
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	53                   	push   %ebx
  800f01:	83 ec 10             	sub    $0x10,%esp
  800f04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f07:	53                   	push   %ebx
  800f08:	e8 97 ff ff ff       	call   800ea4 <strlen>
  800f0d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	01 d8                	add    %ebx,%eax
  800f15:	50                   	push   %eax
  800f16:	e8 c2 ff ff ff       	call   800edd <strcpy>
	return dst;
}
  800f1b:	89 d8                	mov    %ebx,%eax
  800f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    

00800f22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	56                   	push   %esi
  800f26:	53                   	push   %ebx
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	89 c6                	mov    %eax,%esi
  800f2f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f32:	89 c2                	mov    %eax,%edx
  800f34:	39 f2                	cmp    %esi,%edx
  800f36:	74 11                	je     800f49 <strncpy+0x27>
		*dst++ = *src;
  800f38:	83 c2 01             	add    $0x1,%edx
  800f3b:	0f b6 19             	movzbl (%ecx),%ebx
  800f3e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f41:	80 fb 01             	cmp    $0x1,%bl
  800f44:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f47:	eb eb                	jmp    800f34 <strncpy+0x12>
	}
	return ret;
}
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
  800f52:	8b 75 08             	mov    0x8(%ebp),%esi
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	8b 55 10             	mov    0x10(%ebp),%edx
  800f5b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f5d:	85 d2                	test   %edx,%edx
  800f5f:	74 21                	je     800f82 <strlcpy+0x35>
  800f61:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f65:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f67:	39 c2                	cmp    %eax,%edx
  800f69:	74 14                	je     800f7f <strlcpy+0x32>
  800f6b:	0f b6 19             	movzbl (%ecx),%ebx
  800f6e:	84 db                	test   %bl,%bl
  800f70:	74 0b                	je     800f7d <strlcpy+0x30>
			*dst++ = *src++;
  800f72:	83 c1 01             	add    $0x1,%ecx
  800f75:	83 c2 01             	add    $0x1,%edx
  800f78:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f7b:	eb ea                	jmp    800f67 <strlcpy+0x1a>
  800f7d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f82:	29 f0                	sub    %esi,%eax
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f91:	0f b6 01             	movzbl (%ecx),%eax
  800f94:	84 c0                	test   %al,%al
  800f96:	74 0c                	je     800fa4 <strcmp+0x1c>
  800f98:	3a 02                	cmp    (%edx),%al
  800f9a:	75 08                	jne    800fa4 <strcmp+0x1c>
		p++, q++;
  800f9c:	83 c1 01             	add    $0x1,%ecx
  800f9f:	83 c2 01             	add    $0x1,%edx
  800fa2:	eb ed                	jmp    800f91 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	0f b6 c0             	movzbl %al,%eax
  800fa7:	0f b6 12             	movzbl (%edx),%edx
  800faa:	29 d0                	sub    %edx,%eax
}
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	53                   	push   %ebx
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb8:	89 c3                	mov    %eax,%ebx
  800fba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fbd:	eb 06                	jmp    800fc5 <strncmp+0x17>
		n--, p++, q++;
  800fbf:	83 c0 01             	add    $0x1,%eax
  800fc2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fc5:	39 d8                	cmp    %ebx,%eax
  800fc7:	74 16                	je     800fdf <strncmp+0x31>
  800fc9:	0f b6 08             	movzbl (%eax),%ecx
  800fcc:	84 c9                	test   %cl,%cl
  800fce:	74 04                	je     800fd4 <strncmp+0x26>
  800fd0:	3a 0a                	cmp    (%edx),%cl
  800fd2:	74 eb                	je     800fbf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd4:	0f b6 00             	movzbl (%eax),%eax
  800fd7:	0f b6 12             	movzbl (%edx),%edx
  800fda:	29 d0                	sub    %edx,%eax
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    
		return 0;
  800fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe4:	eb f6                	jmp    800fdc <strncmp+0x2e>

00800fe6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ff0:	0f b6 10             	movzbl (%eax),%edx
  800ff3:	84 d2                	test   %dl,%dl
  800ff5:	74 09                	je     801000 <strchr+0x1a>
		if (*s == c)
  800ff7:	38 ca                	cmp    %cl,%dl
  800ff9:	74 0a                	je     801005 <strchr+0x1f>
	for (; *s; s++)
  800ffb:	83 c0 01             	add    $0x1,%eax
  800ffe:	eb f0                	jmp    800ff0 <strchr+0xa>
			return (char *) s;
	return 0;
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801011:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801014:	38 ca                	cmp    %cl,%dl
  801016:	74 09                	je     801021 <strfind+0x1a>
  801018:	84 d2                	test   %dl,%dl
  80101a:	74 05                	je     801021 <strfind+0x1a>
	for (; *s; s++)
  80101c:	83 c0 01             	add    $0x1,%eax
  80101f:	eb f0                	jmp    801011 <strfind+0xa>
			break;
	return (char *) s;
}
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	8b 7d 08             	mov    0x8(%ebp),%edi
  80102c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80102f:	85 c9                	test   %ecx,%ecx
  801031:	74 31                	je     801064 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801033:	89 f8                	mov    %edi,%eax
  801035:	09 c8                	or     %ecx,%eax
  801037:	a8 03                	test   $0x3,%al
  801039:	75 23                	jne    80105e <memset+0x3b>
		c &= 0xFF;
  80103b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80103f:	89 d3                	mov    %edx,%ebx
  801041:	c1 e3 08             	shl    $0x8,%ebx
  801044:	89 d0                	mov    %edx,%eax
  801046:	c1 e0 18             	shl    $0x18,%eax
  801049:	89 d6                	mov    %edx,%esi
  80104b:	c1 e6 10             	shl    $0x10,%esi
  80104e:	09 f0                	or     %esi,%eax
  801050:	09 c2                	or     %eax,%edx
  801052:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801054:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801057:	89 d0                	mov    %edx,%eax
  801059:	fc                   	cld    
  80105a:	f3 ab                	rep stos %eax,%es:(%edi)
  80105c:	eb 06                	jmp    801064 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	fc                   	cld    
  801062:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801064:	89 f8                	mov    %edi,%eax
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8b 75 0c             	mov    0xc(%ebp),%esi
  801076:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801079:	39 c6                	cmp    %eax,%esi
  80107b:	73 32                	jae    8010af <memmove+0x44>
  80107d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801080:	39 c2                	cmp    %eax,%edx
  801082:	76 2b                	jbe    8010af <memmove+0x44>
		s += n;
		d += n;
  801084:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801087:	89 fe                	mov    %edi,%esi
  801089:	09 ce                	or     %ecx,%esi
  80108b:	09 d6                	or     %edx,%esi
  80108d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801093:	75 0e                	jne    8010a3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801095:	83 ef 04             	sub    $0x4,%edi
  801098:	8d 72 fc             	lea    -0x4(%edx),%esi
  80109b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80109e:	fd                   	std    
  80109f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010a1:	eb 09                	jmp    8010ac <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010a3:	83 ef 01             	sub    $0x1,%edi
  8010a6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010a9:	fd                   	std    
  8010aa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010ac:	fc                   	cld    
  8010ad:	eb 1a                	jmp    8010c9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	09 ca                	or     %ecx,%edx
  8010b3:	09 f2                	or     %esi,%edx
  8010b5:	f6 c2 03             	test   $0x3,%dl
  8010b8:	75 0a                	jne    8010c4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010ba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010bd:	89 c7                	mov    %eax,%edi
  8010bf:	fc                   	cld    
  8010c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010c2:	eb 05                	jmp    8010c9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8010c4:	89 c7                	mov    %eax,%edi
  8010c6:	fc                   	cld    
  8010c7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010d3:	ff 75 10             	pushl  0x10(%ebp)
  8010d6:	ff 75 0c             	pushl  0xc(%ebp)
  8010d9:	ff 75 08             	pushl  0x8(%ebp)
  8010dc:	e8 8a ff ff ff       	call   80106b <memmove>
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 c6                	mov    %eax,%esi
  8010f0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010f3:	39 f0                	cmp    %esi,%eax
  8010f5:	74 1c                	je     801113 <memcmp+0x30>
		if (*s1 != *s2)
  8010f7:	0f b6 08             	movzbl (%eax),%ecx
  8010fa:	0f b6 1a             	movzbl (%edx),%ebx
  8010fd:	38 d9                	cmp    %bl,%cl
  8010ff:	75 08                	jne    801109 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801101:	83 c0 01             	add    $0x1,%eax
  801104:	83 c2 01             	add    $0x1,%edx
  801107:	eb ea                	jmp    8010f3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801109:	0f b6 c1             	movzbl %cl,%eax
  80110c:	0f b6 db             	movzbl %bl,%ebx
  80110f:	29 d8                	sub    %ebx,%eax
  801111:	eb 05                	jmp    801118 <memcmp+0x35>
	}

	return 0;
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801125:	89 c2                	mov    %eax,%edx
  801127:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80112a:	39 d0                	cmp    %edx,%eax
  80112c:	73 09                	jae    801137 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112e:	38 08                	cmp    %cl,(%eax)
  801130:	74 05                	je     801137 <memfind+0x1b>
	for (; s < ends; s++)
  801132:	83 c0 01             	add    $0x1,%eax
  801135:	eb f3                	jmp    80112a <memfind+0xe>
			break;
	return (void *) s;
}
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    

00801139 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	57                   	push   %edi
  80113d:	56                   	push   %esi
  80113e:	53                   	push   %ebx
  80113f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801142:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801145:	eb 03                	jmp    80114a <strtol+0x11>
		s++;
  801147:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80114a:	0f b6 01             	movzbl (%ecx),%eax
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f6                	je     801147 <strtol+0xe>
  801151:	3c 09                	cmp    $0x9,%al
  801153:	74 f2                	je     801147 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801155:	3c 2b                	cmp    $0x2b,%al
  801157:	74 2a                	je     801183 <strtol+0x4a>
	int neg = 0;
  801159:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80115e:	3c 2d                	cmp    $0x2d,%al
  801160:	74 2b                	je     80118d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801162:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801168:	75 0f                	jne    801179 <strtol+0x40>
  80116a:	80 39 30             	cmpb   $0x30,(%ecx)
  80116d:	74 28                	je     801197 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80116f:	85 db                	test   %ebx,%ebx
  801171:	b8 0a 00 00 00       	mov    $0xa,%eax
  801176:	0f 44 d8             	cmove  %eax,%ebx
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
  80117e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801181:	eb 50                	jmp    8011d3 <strtol+0x9a>
		s++;
  801183:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801186:	bf 00 00 00 00       	mov    $0x0,%edi
  80118b:	eb d5                	jmp    801162 <strtol+0x29>
		s++, neg = 1;
  80118d:	83 c1 01             	add    $0x1,%ecx
  801190:	bf 01 00 00 00       	mov    $0x1,%edi
  801195:	eb cb                	jmp    801162 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801197:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80119b:	74 0e                	je     8011ab <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80119d:	85 db                	test   %ebx,%ebx
  80119f:	75 d8                	jne    801179 <strtol+0x40>
		s++, base = 8;
  8011a1:	83 c1 01             	add    $0x1,%ecx
  8011a4:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011a9:	eb ce                	jmp    801179 <strtol+0x40>
		s += 2, base = 16;
  8011ab:	83 c1 02             	add    $0x2,%ecx
  8011ae:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011b3:	eb c4                	jmp    801179 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011b5:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011b8:	89 f3                	mov    %esi,%ebx
  8011ba:	80 fb 19             	cmp    $0x19,%bl
  8011bd:	77 29                	ja     8011e8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8011bf:	0f be d2             	movsbl %dl,%edx
  8011c2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011c5:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011c8:	7d 30                	jge    8011fa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011ca:	83 c1 01             	add    $0x1,%ecx
  8011cd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011d3:	0f b6 11             	movzbl (%ecx),%edx
  8011d6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011d9:	89 f3                	mov    %esi,%ebx
  8011db:	80 fb 09             	cmp    $0x9,%bl
  8011de:	77 d5                	ja     8011b5 <strtol+0x7c>
			dig = *s - '0';
  8011e0:	0f be d2             	movsbl %dl,%edx
  8011e3:	83 ea 30             	sub    $0x30,%edx
  8011e6:	eb dd                	jmp    8011c5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011e8:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011eb:	89 f3                	mov    %esi,%ebx
  8011ed:	80 fb 19             	cmp    $0x19,%bl
  8011f0:	77 08                	ja     8011fa <strtol+0xc1>
			dig = *s - 'A' + 10;
  8011f2:	0f be d2             	movsbl %dl,%edx
  8011f5:	83 ea 37             	sub    $0x37,%edx
  8011f8:	eb cb                	jmp    8011c5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fe:	74 05                	je     801205 <strtol+0xcc>
		*endptr = (char *) s;
  801200:	8b 75 0c             	mov    0xc(%ebp),%esi
  801203:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801205:	89 c2                	mov    %eax,%edx
  801207:	f7 da                	neg    %edx
  801209:	85 ff                	test   %edi,%edi
  80120b:	0f 45 c2             	cmovne %edx,%eax
}
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
	asm volatile("int %1\n"
  801219:	b8 00 00 00 00       	mov    $0x0,%eax
  80121e:	8b 55 08             	mov    0x8(%ebp),%edx
  801221:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801224:	89 c3                	mov    %eax,%ebx
  801226:	89 c7                	mov    %eax,%edi
  801228:	89 c6                	mov    %eax,%esi
  80122a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <sys_cgetc>:

int
sys_cgetc(void)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	57                   	push   %edi
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
	asm volatile("int %1\n"
  801237:	ba 00 00 00 00       	mov    $0x0,%edx
  80123c:	b8 01 00 00 00       	mov    $0x1,%eax
  801241:	89 d1                	mov    %edx,%ecx
  801243:	89 d3                	mov    %edx,%ebx
  801245:	89 d7                	mov    %edx,%edi
  801247:	89 d6                	mov    %edx,%esi
  801249:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801259:	b9 00 00 00 00       	mov    $0x0,%ecx
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	b8 03 00 00 00       	mov    $0x3,%eax
  801266:	89 cb                	mov    %ecx,%ebx
  801268:	89 cf                	mov    %ecx,%edi
  80126a:	89 ce                	mov    %ecx,%esi
  80126c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126e:	85 c0                	test   %eax,%eax
  801270:	7f 08                	jg     80127a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	50                   	push   %eax
  80127e:	6a 03                	push   $0x3
  801280:	68 e0 1c 80 00       	push   $0x801ce0
  801285:	6a 43                	push   $0x43
  801287:	68 fd 1c 80 00       	push   $0x801cfd
  80128c:	e8 f7 f3 ff ff       	call   800688 <_panic>

00801291 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
	asm volatile("int %1\n"
  801297:	ba 00 00 00 00       	mov    $0x0,%edx
  80129c:	b8 02 00 00 00       	mov    $0x2,%eax
  8012a1:	89 d1                	mov    %edx,%ecx
  8012a3:	89 d3                	mov    %edx,%ebx
  8012a5:	89 d7                	mov    %edx,%edi
  8012a7:	89 d6                	mov    %edx,%esi
  8012a9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012ab:	5b                   	pop    %ebx
  8012ac:	5e                   	pop    %esi
  8012ad:	5f                   	pop    %edi
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <sys_yield>:

void
sys_yield(void)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012bb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012c0:	89 d1                	mov    %edx,%ecx
  8012c2:	89 d3                	mov    %edx,%ebx
  8012c4:	89 d7                	mov    %edx,%edi
  8012c6:	89 d6                	mov    %edx,%esi
  8012c8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5f                   	pop    %edi
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d8:	be 00 00 00 00       	mov    $0x0,%esi
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8012e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012eb:	89 f7                	mov    %esi,%edi
  8012ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	7f 08                	jg     8012fb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f6:	5b                   	pop    %ebx
  8012f7:	5e                   	pop    %esi
  8012f8:	5f                   	pop    %edi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	50                   	push   %eax
  8012ff:	6a 04                	push   $0x4
  801301:	68 e0 1c 80 00       	push   $0x801ce0
  801306:	6a 43                	push   $0x43
  801308:	68 fd 1c 80 00       	push   $0x801cfd
  80130d:	e8 76 f3 ff ff       	call   800688 <_panic>

00801312 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801321:	b8 05 00 00 00       	mov    $0x5,%eax
  801326:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801329:	8b 7d 14             	mov    0x14(%ebp),%edi
  80132c:	8b 75 18             	mov    0x18(%ebp),%esi
  80132f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801331:	85 c0                	test   %eax,%eax
  801333:	7f 08                	jg     80133d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801335:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5f                   	pop    %edi
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	50                   	push   %eax
  801341:	6a 05                	push   $0x5
  801343:	68 e0 1c 80 00       	push   $0x801ce0
  801348:	6a 43                	push   $0x43
  80134a:	68 fd 1c 80 00       	push   $0x801cfd
  80134f:	e8 34 f3 ff ff       	call   800688 <_panic>

00801354 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80135d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801368:	b8 06 00 00 00       	mov    $0x6,%eax
  80136d:	89 df                	mov    %ebx,%edi
  80136f:	89 de                	mov    %ebx,%esi
  801371:	cd 30                	int    $0x30
	if(check && ret > 0)
  801373:	85 c0                	test   %eax,%eax
  801375:	7f 08                	jg     80137f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137a:	5b                   	pop    %ebx
  80137b:	5e                   	pop    %esi
  80137c:	5f                   	pop    %edi
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	50                   	push   %eax
  801383:	6a 06                	push   $0x6
  801385:	68 e0 1c 80 00       	push   $0x801ce0
  80138a:	6a 43                	push   $0x43
  80138c:	68 fd 1c 80 00       	push   $0x801cfd
  801391:	e8 f2 f2 ff ff       	call   800688 <_panic>

00801396 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	57                   	push   %edi
  80139a:	56                   	push   %esi
  80139b:	53                   	push   %ebx
  80139c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80139f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8013af:	89 df                	mov    %ebx,%edi
  8013b1:	89 de                	mov    %ebx,%esi
  8013b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	7f 08                	jg     8013c1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8013b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bc:	5b                   	pop    %ebx
  8013bd:	5e                   	pop    %esi
  8013be:	5f                   	pop    %edi
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	50                   	push   %eax
  8013c5:	6a 08                	push   $0x8
  8013c7:	68 e0 1c 80 00       	push   $0x801ce0
  8013cc:	6a 43                	push   $0x43
  8013ce:	68 fd 1c 80 00       	push   $0x801cfd
  8013d3:	e8 b0 f2 ff ff       	call   800688 <_panic>

008013d8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	57                   	push   %edi
  8013dc:	56                   	push   %esi
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8013f1:	89 df                	mov    %ebx,%edi
  8013f3:	89 de                	mov    %ebx,%esi
  8013f5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	7f 08                	jg     801403 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5f                   	pop    %edi
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	6a 09                	push   $0x9
  801409:	68 e0 1c 80 00       	push   $0x801ce0
  80140e:	6a 43                	push   $0x43
  801410:	68 fd 1c 80 00       	push   $0x801cfd
  801415:	e8 6e f2 ff ff       	call   800688 <_panic>

0080141a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	57                   	push   %edi
  80141e:	56                   	push   %esi
  80141f:	53                   	push   %ebx
  801420:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801423:	bb 00 00 00 00       	mov    $0x0,%ebx
  801428:	8b 55 08             	mov    0x8(%ebp),%edx
  80142b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801433:	89 df                	mov    %ebx,%edi
  801435:	89 de                	mov    %ebx,%esi
  801437:	cd 30                	int    $0x30
	if(check && ret > 0)
  801439:	85 c0                	test   %eax,%eax
  80143b:	7f 08                	jg     801445 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80143d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	50                   	push   %eax
  801449:	6a 0a                	push   $0xa
  80144b:	68 e0 1c 80 00       	push   $0x801ce0
  801450:	6a 43                	push   $0x43
  801452:	68 fd 1c 80 00       	push   $0x801cfd
  801457:	e8 2c f2 ff ff       	call   800688 <_panic>

0080145c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
	asm volatile("int %1\n"
  801462:	8b 55 08             	mov    0x8(%ebp),%edx
  801465:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801468:	b8 0c 00 00 00       	mov    $0xc,%eax
  80146d:	be 00 00 00 00       	mov    $0x0,%esi
  801472:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801475:	8b 7d 14             	mov    0x14(%ebp),%edi
  801478:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5f                   	pop    %edi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    

0080147f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	57                   	push   %edi
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801488:	b9 00 00 00 00       	mov    $0x0,%ecx
  80148d:	8b 55 08             	mov    0x8(%ebp),%edx
  801490:	b8 0d 00 00 00       	mov    $0xd,%eax
  801495:	89 cb                	mov    %ecx,%ebx
  801497:	89 cf                	mov    %ecx,%edi
  801499:	89 ce                	mov    %ecx,%esi
  80149b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80149d:	85 c0                	test   %eax,%eax
  80149f:	7f 08                	jg     8014a9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a4:	5b                   	pop    %ebx
  8014a5:	5e                   	pop    %esi
  8014a6:	5f                   	pop    %edi
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	50                   	push   %eax
  8014ad:	6a 0d                	push   $0xd
  8014af:	68 e0 1c 80 00       	push   $0x801ce0
  8014b4:	6a 43                	push   $0x43
  8014b6:	68 fd 1c 80 00       	push   $0x801cfd
  8014bb:	e8 c8 f1 ff ff       	call   800688 <_panic>

008014c0 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014d6:	89 df                	mov    %ebx,%edi
  8014d8:	89 de                	mov    %ebx,%esi
  8014da:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5f                   	pop    %edi
  8014df:	5d                   	pop    %ebp
  8014e0:	c3                   	ret    

008014e1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	57                   	push   %edi
  8014e5:	56                   	push   %esi
  8014e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ef:	b8 0f 00 00 00       	mov    $0xf,%eax
  8014f4:	89 cb                	mov    %ecx,%ebx
  8014f6:	89 cf                	mov    %ecx,%edi
  8014f8:	89 ce                	mov    %ecx,%esi
  8014fa:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8014fc:	5b                   	pop    %ebx
  8014fd:	5e                   	pop    %esi
  8014fe:	5f                   	pop    %edi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801507:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  80150e:	74 0a                	je     80151a <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	6a 07                	push   $0x7
  80151f:	68 00 f0 bf ee       	push   $0xeebff000
  801524:	6a 00                	push   $0x0
  801526:	e8 a4 fd ff ff       	call   8012cf <sys_page_alloc>
		if(r < 0)
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 2a                	js     80155c <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	68 70 15 80 00       	push   $0x801570
  80153a:	6a 00                	push   $0x0
  80153c:	e8 d9 fe ff ff       	call   80141a <sys_env_set_pgfault_upcall>
		if(r < 0)
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	79 c8                	jns    801510 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	68 3c 1d 80 00       	push   $0x801d3c
  801550:	6a 25                	push   $0x25
  801552:	68 78 1d 80 00       	push   $0x801d78
  801557:	e8 2c f1 ff ff       	call   800688 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 0c 1d 80 00       	push   $0x801d0c
  801564:	6a 22                	push   $0x22
  801566:	68 78 1d 80 00       	push   $0x801d78
  80156b:	e8 18 f1 ff ff       	call   800688 <_panic>

00801570 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801570:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801571:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  801576:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801578:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80157b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80157f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801583:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801586:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801588:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80158c:	83 c4 08             	add    $0x8,%esp
	popal
  80158f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801590:	83 c4 04             	add    $0x4,%esp
	popfl
  801593:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801594:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801595:	c3                   	ret    
  801596:	66 90                	xchg   %ax,%ax
  801598:	66 90                	xchg   %ax,%ax
  80159a:	66 90                	xchg   %ax,%ax
  80159c:	66 90                	xchg   %ax,%ax
  80159e:	66 90                	xchg   %ax,%ax

008015a0 <__udivdi3>:
  8015a0:	55                   	push   %ebp
  8015a1:	57                   	push   %edi
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 1c             	sub    $0x1c,%esp
  8015a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8015ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8015af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8015b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8015b7:	85 d2                	test   %edx,%edx
  8015b9:	75 4d                	jne    801608 <__udivdi3+0x68>
  8015bb:	39 f3                	cmp    %esi,%ebx
  8015bd:	76 19                	jbe    8015d8 <__udivdi3+0x38>
  8015bf:	31 ff                	xor    %edi,%edi
  8015c1:	89 e8                	mov    %ebp,%eax
  8015c3:	89 f2                	mov    %esi,%edx
  8015c5:	f7 f3                	div    %ebx
  8015c7:	89 fa                	mov    %edi,%edx
  8015c9:	83 c4 1c             	add    $0x1c,%esp
  8015cc:	5b                   	pop    %ebx
  8015cd:	5e                   	pop    %esi
  8015ce:	5f                   	pop    %edi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    
  8015d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015d8:	89 d9                	mov    %ebx,%ecx
  8015da:	85 db                	test   %ebx,%ebx
  8015dc:	75 0b                	jne    8015e9 <__udivdi3+0x49>
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e3:	31 d2                	xor    %edx,%edx
  8015e5:	f7 f3                	div    %ebx
  8015e7:	89 c1                	mov    %eax,%ecx
  8015e9:	31 d2                	xor    %edx,%edx
  8015eb:	89 f0                	mov    %esi,%eax
  8015ed:	f7 f1                	div    %ecx
  8015ef:	89 c6                	mov    %eax,%esi
  8015f1:	89 e8                	mov    %ebp,%eax
  8015f3:	89 f7                	mov    %esi,%edi
  8015f5:	f7 f1                	div    %ecx
  8015f7:	89 fa                	mov    %edi,%edx
  8015f9:	83 c4 1c             	add    $0x1c,%esp
  8015fc:	5b                   	pop    %ebx
  8015fd:	5e                   	pop    %esi
  8015fe:	5f                   	pop    %edi
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    
  801601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801608:	39 f2                	cmp    %esi,%edx
  80160a:	77 1c                	ja     801628 <__udivdi3+0x88>
  80160c:	0f bd fa             	bsr    %edx,%edi
  80160f:	83 f7 1f             	xor    $0x1f,%edi
  801612:	75 2c                	jne    801640 <__udivdi3+0xa0>
  801614:	39 f2                	cmp    %esi,%edx
  801616:	72 06                	jb     80161e <__udivdi3+0x7e>
  801618:	31 c0                	xor    %eax,%eax
  80161a:	39 eb                	cmp    %ebp,%ebx
  80161c:	77 a9                	ja     8015c7 <__udivdi3+0x27>
  80161e:	b8 01 00 00 00       	mov    $0x1,%eax
  801623:	eb a2                	jmp    8015c7 <__udivdi3+0x27>
  801625:	8d 76 00             	lea    0x0(%esi),%esi
  801628:	31 ff                	xor    %edi,%edi
  80162a:	31 c0                	xor    %eax,%eax
  80162c:	89 fa                	mov    %edi,%edx
  80162e:	83 c4 1c             	add    $0x1c,%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5f                   	pop    %edi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    
  801636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80163d:	8d 76 00             	lea    0x0(%esi),%esi
  801640:	89 f9                	mov    %edi,%ecx
  801642:	b8 20 00 00 00       	mov    $0x20,%eax
  801647:	29 f8                	sub    %edi,%eax
  801649:	d3 e2                	shl    %cl,%edx
  80164b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80164f:	89 c1                	mov    %eax,%ecx
  801651:	89 da                	mov    %ebx,%edx
  801653:	d3 ea                	shr    %cl,%edx
  801655:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801659:	09 d1                	or     %edx,%ecx
  80165b:	89 f2                	mov    %esi,%edx
  80165d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801661:	89 f9                	mov    %edi,%ecx
  801663:	d3 e3                	shl    %cl,%ebx
  801665:	89 c1                	mov    %eax,%ecx
  801667:	d3 ea                	shr    %cl,%edx
  801669:	89 f9                	mov    %edi,%ecx
  80166b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80166f:	89 eb                	mov    %ebp,%ebx
  801671:	d3 e6                	shl    %cl,%esi
  801673:	89 c1                	mov    %eax,%ecx
  801675:	d3 eb                	shr    %cl,%ebx
  801677:	09 de                	or     %ebx,%esi
  801679:	89 f0                	mov    %esi,%eax
  80167b:	f7 74 24 08          	divl   0x8(%esp)
  80167f:	89 d6                	mov    %edx,%esi
  801681:	89 c3                	mov    %eax,%ebx
  801683:	f7 64 24 0c          	mull   0xc(%esp)
  801687:	39 d6                	cmp    %edx,%esi
  801689:	72 15                	jb     8016a0 <__udivdi3+0x100>
  80168b:	89 f9                	mov    %edi,%ecx
  80168d:	d3 e5                	shl    %cl,%ebp
  80168f:	39 c5                	cmp    %eax,%ebp
  801691:	73 04                	jae    801697 <__udivdi3+0xf7>
  801693:	39 d6                	cmp    %edx,%esi
  801695:	74 09                	je     8016a0 <__udivdi3+0x100>
  801697:	89 d8                	mov    %ebx,%eax
  801699:	31 ff                	xor    %edi,%edi
  80169b:	e9 27 ff ff ff       	jmp    8015c7 <__udivdi3+0x27>
  8016a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8016a3:	31 ff                	xor    %edi,%edi
  8016a5:	e9 1d ff ff ff       	jmp    8015c7 <__udivdi3+0x27>
  8016aa:	66 90                	xchg   %ax,%ax
  8016ac:	66 90                	xchg   %ax,%ax
  8016ae:	66 90                	xchg   %ax,%ax

008016b0 <__umoddi3>:
  8016b0:	55                   	push   %ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 1c             	sub    $0x1c,%esp
  8016b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8016bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8016bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8016c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016c7:	89 da                	mov    %ebx,%edx
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 43                	jne    801710 <__umoddi3+0x60>
  8016cd:	39 df                	cmp    %ebx,%edi
  8016cf:	76 17                	jbe    8016e8 <__umoddi3+0x38>
  8016d1:	89 f0                	mov    %esi,%eax
  8016d3:	f7 f7                	div    %edi
  8016d5:	89 d0                	mov    %edx,%eax
  8016d7:	31 d2                	xor    %edx,%edx
  8016d9:	83 c4 1c             	add    $0x1c,%esp
  8016dc:	5b                   	pop    %ebx
  8016dd:	5e                   	pop    %esi
  8016de:	5f                   	pop    %edi
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    
  8016e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016e8:	89 fd                	mov    %edi,%ebp
  8016ea:	85 ff                	test   %edi,%edi
  8016ec:	75 0b                	jne    8016f9 <__umoddi3+0x49>
  8016ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f3:	31 d2                	xor    %edx,%edx
  8016f5:	f7 f7                	div    %edi
  8016f7:	89 c5                	mov    %eax,%ebp
  8016f9:	89 d8                	mov    %ebx,%eax
  8016fb:	31 d2                	xor    %edx,%edx
  8016fd:	f7 f5                	div    %ebp
  8016ff:	89 f0                	mov    %esi,%eax
  801701:	f7 f5                	div    %ebp
  801703:	89 d0                	mov    %edx,%eax
  801705:	eb d0                	jmp    8016d7 <__umoddi3+0x27>
  801707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80170e:	66 90                	xchg   %ax,%ax
  801710:	89 f1                	mov    %esi,%ecx
  801712:	39 d8                	cmp    %ebx,%eax
  801714:	76 0a                	jbe    801720 <__umoddi3+0x70>
  801716:	89 f0                	mov    %esi,%eax
  801718:	83 c4 1c             	add    $0x1c,%esp
  80171b:	5b                   	pop    %ebx
  80171c:	5e                   	pop    %esi
  80171d:	5f                   	pop    %edi
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    
  801720:	0f bd e8             	bsr    %eax,%ebp
  801723:	83 f5 1f             	xor    $0x1f,%ebp
  801726:	75 20                	jne    801748 <__umoddi3+0x98>
  801728:	39 d8                	cmp    %ebx,%eax
  80172a:	0f 82 b0 00 00 00    	jb     8017e0 <__umoddi3+0x130>
  801730:	39 f7                	cmp    %esi,%edi
  801732:	0f 86 a8 00 00 00    	jbe    8017e0 <__umoddi3+0x130>
  801738:	89 c8                	mov    %ecx,%eax
  80173a:	83 c4 1c             	add    $0x1c,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    
  801742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801748:	89 e9                	mov    %ebp,%ecx
  80174a:	ba 20 00 00 00       	mov    $0x20,%edx
  80174f:	29 ea                	sub    %ebp,%edx
  801751:	d3 e0                	shl    %cl,%eax
  801753:	89 44 24 08          	mov    %eax,0x8(%esp)
  801757:	89 d1                	mov    %edx,%ecx
  801759:	89 f8                	mov    %edi,%eax
  80175b:	d3 e8                	shr    %cl,%eax
  80175d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801761:	89 54 24 04          	mov    %edx,0x4(%esp)
  801765:	8b 54 24 04          	mov    0x4(%esp),%edx
  801769:	09 c1                	or     %eax,%ecx
  80176b:	89 d8                	mov    %ebx,%eax
  80176d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801771:	89 e9                	mov    %ebp,%ecx
  801773:	d3 e7                	shl    %cl,%edi
  801775:	89 d1                	mov    %edx,%ecx
  801777:	d3 e8                	shr    %cl,%eax
  801779:	89 e9                	mov    %ebp,%ecx
  80177b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80177f:	d3 e3                	shl    %cl,%ebx
  801781:	89 c7                	mov    %eax,%edi
  801783:	89 d1                	mov    %edx,%ecx
  801785:	89 f0                	mov    %esi,%eax
  801787:	d3 e8                	shr    %cl,%eax
  801789:	89 e9                	mov    %ebp,%ecx
  80178b:	89 fa                	mov    %edi,%edx
  80178d:	d3 e6                	shl    %cl,%esi
  80178f:	09 d8                	or     %ebx,%eax
  801791:	f7 74 24 08          	divl   0x8(%esp)
  801795:	89 d1                	mov    %edx,%ecx
  801797:	89 f3                	mov    %esi,%ebx
  801799:	f7 64 24 0c          	mull   0xc(%esp)
  80179d:	89 c6                	mov    %eax,%esi
  80179f:	89 d7                	mov    %edx,%edi
  8017a1:	39 d1                	cmp    %edx,%ecx
  8017a3:	72 06                	jb     8017ab <__umoddi3+0xfb>
  8017a5:	75 10                	jne    8017b7 <__umoddi3+0x107>
  8017a7:	39 c3                	cmp    %eax,%ebx
  8017a9:	73 0c                	jae    8017b7 <__umoddi3+0x107>
  8017ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8017af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8017b3:	89 d7                	mov    %edx,%edi
  8017b5:	89 c6                	mov    %eax,%esi
  8017b7:	89 ca                	mov    %ecx,%edx
  8017b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8017be:	29 f3                	sub    %esi,%ebx
  8017c0:	19 fa                	sbb    %edi,%edx
  8017c2:	89 d0                	mov    %edx,%eax
  8017c4:	d3 e0                	shl    %cl,%eax
  8017c6:	89 e9                	mov    %ebp,%ecx
  8017c8:	d3 eb                	shr    %cl,%ebx
  8017ca:	d3 ea                	shr    %cl,%edx
  8017cc:	09 d8                	or     %ebx,%eax
  8017ce:	83 c4 1c             	add    $0x1c,%esp
  8017d1:	5b                   	pop    %ebx
  8017d2:	5e                   	pop    %esi
  8017d3:	5f                   	pop    %edi
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    
  8017d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8017dd:	8d 76 00             	lea    0x0(%esi),%esi
  8017e0:	89 da                	mov    %ebx,%edx
  8017e2:	29 fe                	sub    %edi,%esi
  8017e4:	19 c2                	sbb    %eax,%edx
  8017e6:	89 f1                	mov    %esi,%ecx
  8017e8:	89 c8                	mov    %ecx,%eax
  8017ea:	e9 4b ff ff ff       	jmp    80173a <__umoddi3+0x8a>
