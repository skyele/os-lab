
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
  800044:	68 eb 31 80 00       	push   $0x8031eb
  800049:	68 20 2b 80 00       	push   $0x802b20
  80004e:	e8 01 07 00 00       	call   800754 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 30 2b 80 00       	push   $0x802b30
  80005c:	68 34 2b 80 00       	push   $0x802b34
  800061:	e8 ee 06 00 00       	call   800754 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 48 2b 80 00       	push   $0x802b48
  80007b:	e8 d4 06 00 00       	call   800754 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 52 2b 80 00       	push   $0x802b52
  800093:	68 34 2b 80 00       	push   $0x802b34
  800098:	e8 b7 06 00 00       	call   800754 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 48 2b 80 00       	push   $0x802b48
  8000b4:	e8 9b 06 00 00       	call   800754 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 56 2b 80 00       	push   $0x802b56
  8000cc:	68 34 2b 80 00       	push   $0x802b34
  8000d1:	e8 7e 06 00 00       	call   800754 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 48 2b 80 00       	push   $0x802b48
  8000ed:	e8 62 06 00 00       	call   800754 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 5a 2b 80 00       	push   $0x802b5a
  800105:	68 34 2b 80 00       	push   $0x802b34
  80010a:	e8 45 06 00 00       	call   800754 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 48 2b 80 00       	push   $0x802b48
  800126:	e8 29 06 00 00       	call   800754 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 5e 2b 80 00       	push   $0x802b5e
  80013e:	68 34 2b 80 00       	push   $0x802b34
  800143:	e8 0c 06 00 00       	call   800754 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 48 2b 80 00       	push   $0x802b48
  80015f:	e8 f0 05 00 00       	call   800754 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 62 2b 80 00       	push   $0x802b62
  800177:	68 34 2b 80 00       	push   $0x802b34
  80017c:	e8 d3 05 00 00       	call   800754 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 48 2b 80 00       	push   $0x802b48
  800198:	e8 b7 05 00 00       	call   800754 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 66 2b 80 00       	push   $0x802b66
  8001b0:	68 34 2b 80 00       	push   $0x802b34
  8001b5:	e8 9a 05 00 00       	call   800754 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 48 2b 80 00       	push   $0x802b48
  8001d1:	e8 7e 05 00 00       	call   800754 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 6a 2b 80 00       	push   $0x802b6a
  8001e9:	68 34 2b 80 00       	push   $0x802b34
  8001ee:	e8 61 05 00 00       	call   800754 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 48 2b 80 00       	push   $0x802b48
  80020a:	e8 45 05 00 00       	call   800754 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 6e 2b 80 00       	push   $0x802b6e
  800222:	68 34 2b 80 00       	push   $0x802b34
  800227:	e8 28 05 00 00       	call   800754 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 48 2b 80 00       	push   $0x802b48
  800243:	e8 0c 05 00 00       	call   800754 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 75 2b 80 00       	push   $0x802b75
  800253:	68 34 2b 80 00       	push   $0x802b34
  800258:	e8 f7 04 00 00       	call   800754 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 48 2b 80 00       	push   $0x802b48
  800274:	e8 db 04 00 00       	call   800754 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 79 2b 80 00       	push   $0x802b79
  800284:	e8 cb 04 00 00       	call   800754 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 48 2b 80 00       	push   $0x802b48
  800294:	e8 bb 04 00 00       	call   800754 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 44 2b 80 00       	push   $0x802b44
  8002a9:	e8 a6 04 00 00       	call   800754 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 44 2b 80 00       	push   $0x802b44
  8002c3:	e8 8c 04 00 00       	call   800754 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 44 2b 80 00       	push   $0x802b44
  8002d8:	e8 77 04 00 00       	call   800754 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 44 2b 80 00       	push   $0x802b44
  8002ed:	e8 62 04 00 00       	call   800754 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 44 2b 80 00       	push   $0x802b44
  800302:	e8 4d 04 00 00       	call   800754 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 44 2b 80 00       	push   $0x802b44
  800317:	e8 38 04 00 00       	call   800754 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 44 2b 80 00       	push   $0x802b44
  80032c:	e8 23 04 00 00       	call   800754 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 44 2b 80 00       	push   $0x802b44
  800341:	e8 0e 04 00 00       	call   800754 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 44 2b 80 00       	push   $0x802b44
  800356:	e8 f9 03 00 00       	call   800754 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 75 2b 80 00       	push   $0x802b75
  800366:	68 34 2b 80 00       	push   $0x802b34
  80036b:	e8 e4 03 00 00       	call   800754 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 44 2b 80 00       	push   $0x802b44
  800387:	e8 c8 03 00 00       	call   800754 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 79 2b 80 00       	push   $0x802b79
  800397:	e8 b8 03 00 00       	call   800754 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 44 2b 80 00       	push   $0x802b44
  8003af:	e8 a0 03 00 00       	call   800754 <cprintf>
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
  8003c2:	68 44 2b 80 00       	push   $0x802b44
  8003c7:	e8 88 03 00 00       	call   800754 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 79 2b 80 00       	push   $0x802b79
  8003d7:	e8 78 03 00 00       	call   800754 <cprintf>
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
  8003fe:	89 15 40 50 80 00    	mov    %edx,0x805040
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 44 50 80 00    	mov    %edx,0x805044
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 48 50 80 00    	mov    %edx,0x805048
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 50 50 80 00    	mov    %edx,0x805050
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 54 50 80 00    	mov    %edx,0x805054
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 58 50 80 00    	mov    %edx,0x805058
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 9f 2b 80 00       	push   $0x802b9f
  80046b:	68 ad 2b 80 00       	push   $0x802bad
  800470:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800475:	ba 98 2b 80 00       	mov    $0x802b98,%edx
  80047a:	b8 80 50 80 00       	mov    $0x805080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 10 0e 00 00       	call   8012a5 <sys_page_alloc>
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
  8004a5:	68 e0 2b 80 00       	push   $0x802be0
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 87 2b 80 00       	push   $0x802b87
  8004b1:	e8 a8 01 00 00       	call   80065e <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 b4 2b 80 00       	push   $0x802bb4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 87 2b 80 00       	push   $0x802b87
  8004c3:	e8 96 01 00 00       	call   80065e <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 c2 10 00 00       	call   80159a <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d 80 50 80 00    	mov    %edi,0x805080
  8004f9:	89 35 84 50 80 00    	mov    %esi,0x805084
  8004ff:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  800505:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  80050b:	89 15 94 50 80 00    	mov    %edx,0x805094
  800511:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  800517:	a3 9c 50 80 00       	mov    %eax,0x80509c
  80051c:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 00 50 80 00    	mov    %edi,0x805000
  800532:	89 35 04 50 80 00    	mov    %esi,0x805004
  800538:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  80053e:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  800544:	89 15 14 50 80 00    	mov    %edx,0x805014
  80054a:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  800550:	a3 1c 50 80 00       	mov    %eax,0x80501c
  800555:	89 25 28 50 80 00    	mov    %esp,0x805028
  80055b:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  800561:	8b 35 84 50 80 00    	mov    0x805084,%esi
  800567:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  80056d:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  800573:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800579:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  80057f:	a1 9c 50 80 00       	mov    0x80509c,%eax
  800584:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 24 50 80 00       	mov    %eax,0x805024
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
  80059f:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 c7 2b 80 00       	push   $0x802bc7
  8005b1:	68 d8 2b 80 00       	push   $0x802bd8
  8005b6:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005bb:	ba 98 2b 80 00       	mov    $0x802b98,%edx
  8005c0:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 14 2c 80 00       	push   $0x802c14
  8005d7:	e8 78 01 00 00       	call   800754 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8005ec:	e8 76 0c 00 00       	call   801267 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8005f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8005fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800601:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800606:	85 db                	test   %ebx,%ebx
  800608:	7e 07                	jle    800611 <libmain+0x30>
		binaryname = argv[0];
  80060a:	8b 06                	mov    (%esi),%eax
  80060c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	56                   	push   %esi
  800615:	53                   	push   %ebx
  800616:	e8 ad fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  80061b:	e8 0a 00 00 00       	call   80062a <exit>
}
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800626:	5b                   	pop    %ebx
  800627:	5e                   	pop    %esi
  800628:	5d                   	pop    %ebp
  800629:	c3                   	ret    

0080062a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800630:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  800635:	8b 40 48             	mov    0x48(%eax),%eax
  800638:	68 48 2c 80 00       	push   $0x802c48
  80063d:	50                   	push   %eax
  80063e:	68 3d 2c 80 00       	push   $0x802c3d
  800643:	e8 0c 01 00 00       	call   800754 <cprintf>
	close_all();
  800648:	e8 ba 11 00 00       	call   801807 <close_all>
	sys_env_destroy(0);
  80064d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800654:	e8 cd 0b 00 00       	call   801226 <sys_env_destroy>
}
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	56                   	push   %esi
  800662:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800663:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  800668:	8b 40 48             	mov    0x48(%eax),%eax
  80066b:	83 ec 04             	sub    $0x4,%esp
  80066e:	68 74 2c 80 00       	push   $0x802c74
  800673:	50                   	push   %eax
  800674:	68 3d 2c 80 00       	push   $0x802c3d
  800679:	e8 d6 00 00 00       	call   800754 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80067e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800681:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800687:	e8 db 0b 00 00       	call   801267 <sys_getenvid>
  80068c:	83 c4 04             	add    $0x4,%esp
  80068f:	ff 75 0c             	pushl  0xc(%ebp)
  800692:	ff 75 08             	pushl  0x8(%ebp)
  800695:	56                   	push   %esi
  800696:	50                   	push   %eax
  800697:	68 50 2c 80 00       	push   $0x802c50
  80069c:	e8 b3 00 00 00       	call   800754 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006a1:	83 c4 18             	add    $0x18,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	ff 75 10             	pushl  0x10(%ebp)
  8006a8:	e8 56 00 00 00       	call   800703 <vcprintf>
	cprintf("\n");
  8006ad:	c7 04 24 ea 31 80 00 	movl   $0x8031ea,(%esp)
  8006b4:	e8 9b 00 00 00       	call   800754 <cprintf>
  8006b9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006bc:	cc                   	int3   
  8006bd:	eb fd                	jmp    8006bc <_panic+0x5e>

008006bf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006c9:	8b 13                	mov    (%ebx),%edx
  8006cb:	8d 42 01             	lea    0x1(%edx),%eax
  8006ce:	89 03                	mov    %eax,(%ebx)
  8006d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006dc:	74 09                	je     8006e7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006de:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	68 ff 00 00 00       	push   $0xff
  8006ef:	8d 43 08             	lea    0x8(%ebx),%eax
  8006f2:	50                   	push   %eax
  8006f3:	e8 f1 0a 00 00       	call   8011e9 <sys_cputs>
		b->idx = 0;
  8006f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	eb db                	jmp    8006de <putch+0x1f>

00800703 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800713:	00 00 00 
	b.cnt = 0;
  800716:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	ff 75 08             	pushl  0x8(%ebp)
  800726:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	68 bf 06 80 00       	push   $0x8006bf
  800732:	e8 4a 01 00 00       	call   800881 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800737:	83 c4 08             	add    $0x8,%esp
  80073a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800740:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800746:	50                   	push   %eax
  800747:	e8 9d 0a 00 00       	call   8011e9 <sys_cputs>

	return b.cnt;
}
  80074c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80075d:	50                   	push   %eax
  80075e:	ff 75 08             	pushl  0x8(%ebp)
  800761:	e8 9d ff ff ff       	call   800703 <vcprintf>
	va_end(ap);

	return cnt;
}
  800766:	c9                   	leave  
  800767:	c3                   	ret    

00800768 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	57                   	push   %edi
  80076c:	56                   	push   %esi
  80076d:	53                   	push   %ebx
  80076e:	83 ec 1c             	sub    $0x1c,%esp
  800771:	89 c6                	mov    %eax,%esi
  800773:	89 d7                	mov    %edx,%edi
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800781:	8b 45 10             	mov    0x10(%ebp),%eax
  800784:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800787:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80078b:	74 2c                	je     8007b9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80079d:	39 c2                	cmp    %eax,%edx
  80079f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8007a2:	73 43                	jae    8007e7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8007a4:	83 eb 01             	sub    $0x1,%ebx
  8007a7:	85 db                	test   %ebx,%ebx
  8007a9:	7e 6c                	jle    800817 <printnum+0xaf>
				putch(padc, putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	57                   	push   %edi
  8007af:	ff 75 18             	pushl  0x18(%ebp)
  8007b2:	ff d6                	call   *%esi
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	eb eb                	jmp    8007a4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8007b9:	83 ec 0c             	sub    $0xc,%esp
  8007bc:	6a 20                	push   $0x20
  8007be:	6a 00                	push   $0x0
  8007c0:	50                   	push   %eax
  8007c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c7:	89 fa                	mov    %edi,%edx
  8007c9:	89 f0                	mov    %esi,%eax
  8007cb:	e8 98 ff ff ff       	call   800768 <printnum>
		while (--width > 0)
  8007d0:	83 c4 20             	add    $0x20,%esp
  8007d3:	83 eb 01             	sub    $0x1,%ebx
  8007d6:	85 db                	test   %ebx,%ebx
  8007d8:	7e 65                	jle    80083f <printnum+0xd7>
			putch(padc, putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	57                   	push   %edi
  8007de:	6a 20                	push   $0x20
  8007e0:	ff d6                	call   *%esi
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	eb ec                	jmp    8007d3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e7:	83 ec 0c             	sub    $0xc,%esp
  8007ea:	ff 75 18             	pushl  0x18(%ebp)
  8007ed:	83 eb 01             	sub    $0x1,%ebx
  8007f0:	53                   	push   %ebx
  8007f1:	50                   	push   %eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8007f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800801:	e8 ba 20 00 00       	call   8028c0 <__udivdi3>
  800806:	83 c4 18             	add    $0x18,%esp
  800809:	52                   	push   %edx
  80080a:	50                   	push   %eax
  80080b:	89 fa                	mov    %edi,%edx
  80080d:	89 f0                	mov    %esi,%eax
  80080f:	e8 54 ff ff ff       	call   800768 <printnum>
  800814:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	57                   	push   %edi
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	ff 75 dc             	pushl  -0x24(%ebp)
  800821:	ff 75 d8             	pushl  -0x28(%ebp)
  800824:	ff 75 e4             	pushl  -0x1c(%ebp)
  800827:	ff 75 e0             	pushl  -0x20(%ebp)
  80082a:	e8 a1 21 00 00       	call   8029d0 <__umoddi3>
  80082f:	83 c4 14             	add    $0x14,%esp
  800832:	0f be 80 7b 2c 80 00 	movsbl 0x802c7b(%eax),%eax
  800839:	50                   	push   %eax
  80083a:	ff d6                	call   *%esi
  80083c:	83 c4 10             	add    $0x10,%esp
	}
}
  80083f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800842:	5b                   	pop    %ebx
  800843:	5e                   	pop    %esi
  800844:	5f                   	pop    %edi
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80084d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800851:	8b 10                	mov    (%eax),%edx
  800853:	3b 50 04             	cmp    0x4(%eax),%edx
  800856:	73 0a                	jae    800862 <sprintputch+0x1b>
		*b->buf++ = ch;
  800858:	8d 4a 01             	lea    0x1(%edx),%ecx
  80085b:	89 08                	mov    %ecx,(%eax)
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	88 02                	mov    %al,(%edx)
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <printfmt>:
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80086a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80086d:	50                   	push   %eax
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	ff 75 08             	pushl  0x8(%ebp)
  800877:	e8 05 00 00 00       	call   800881 <vprintfmt>
}
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <vprintfmt>:
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	57                   	push   %edi
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 3c             	sub    $0x3c,%esp
  80088a:	8b 75 08             	mov    0x8(%ebp),%esi
  80088d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800890:	8b 7d 10             	mov    0x10(%ebp),%edi
  800893:	e9 32 04 00 00       	jmp    800cca <vprintfmt+0x449>
		padc = ' ';
  800898:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80089c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8008a3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8008aa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008b8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8008bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008c4:	8d 47 01             	lea    0x1(%edi),%eax
  8008c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ca:	0f b6 17             	movzbl (%edi),%edx
  8008cd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008d0:	3c 55                	cmp    $0x55,%al
  8008d2:	0f 87 12 05 00 00    	ja     800dea <vprintfmt+0x569>
  8008d8:	0f b6 c0             	movzbl %al,%eax
  8008db:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8008e5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8008e9:	eb d9                	jmp    8008c4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8008ee:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8008f2:	eb d0                	jmp    8008c4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008f4:	0f b6 d2             	movzbl %dl,%edx
  8008f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x86>
  800904:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800907:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80090a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80090e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800911:	8d 72 d0             	lea    -0x30(%edx),%esi
  800914:	83 fe 09             	cmp    $0x9,%esi
  800917:	76 eb                	jbe    800904 <vprintfmt+0x83>
  800919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091c:	8b 75 08             	mov    0x8(%ebp),%esi
  80091f:	eb 14                	jmp    800935 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8d 40 04             	lea    0x4(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800932:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 89                	jns    8008c4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80093b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80093e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800941:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800948:	e9 77 ff ff ff       	jmp    8008c4 <vprintfmt+0x43>
  80094d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800950:	85 c0                	test   %eax,%eax
  800952:	0f 48 c1             	cmovs  %ecx,%eax
  800955:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800958:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80095b:	e9 64 ff ff ff       	jmp    8008c4 <vprintfmt+0x43>
  800960:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800963:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80096a:	e9 55 ff ff ff       	jmp    8008c4 <vprintfmt+0x43>
			lflag++;
  80096f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800973:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800976:	e9 49 ff ff ff       	jmp    8008c4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 78 04             	lea    0x4(%eax),%edi
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	ff 30                	pushl  (%eax)
  800987:	ff d6                	call   *%esi
			break;
  800989:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80098c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80098f:	e9 33 03 00 00       	jmp    800cc7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8d 78 04             	lea    0x4(%eax),%edi
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	99                   	cltd   
  80099d:	31 d0                	xor    %edx,%eax
  80099f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009a1:	83 f8 11             	cmp    $0x11,%eax
  8009a4:	7f 23                	jg     8009c9 <vprintfmt+0x148>
  8009a6:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  8009ad:	85 d2                	test   %edx,%edx
  8009af:	74 18                	je     8009c9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8009b1:	52                   	push   %edx
  8009b2:	68 59 31 80 00       	push   $0x803159
  8009b7:	53                   	push   %ebx
  8009b8:	56                   	push   %esi
  8009b9:	e8 a6 fe ff ff       	call   800864 <printfmt>
  8009be:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009c1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009c4:	e9 fe 02 00 00       	jmp    800cc7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8009c9:	50                   	push   %eax
  8009ca:	68 93 2c 80 00       	push   $0x802c93
  8009cf:	53                   	push   %ebx
  8009d0:	56                   	push   %esi
  8009d1:	e8 8e fe ff ff       	call   800864 <printfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009d9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8009dc:	e9 e6 02 00 00       	jmp    800cc7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	83 c0 04             	add    $0x4,%eax
  8009e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8009ef:	85 c9                	test   %ecx,%ecx
  8009f1:	b8 8c 2c 80 00       	mov    $0x802c8c,%eax
  8009f6:	0f 45 c1             	cmovne %ecx,%eax
  8009f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	7e 06                	jle    800a08 <vprintfmt+0x187>
  800a02:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a06:	75 0d                	jne    800a15 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a0b:	89 c7                	mov    %eax,%edi
  800a0d:	03 45 e0             	add    -0x20(%ebp),%eax
  800a10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a13:	eb 53                	jmp    800a68 <vprintfmt+0x1e7>
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 d8             	pushl  -0x28(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	e8 71 04 00 00       	call   800e92 <strnlen>
  800a21:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a24:	29 c1                	sub    %eax,%ecx
  800a26:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800a29:	83 c4 10             	add    $0x10,%esp
  800a2c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a2e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a35:	eb 0f                	jmp    800a46 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	53                   	push   %ebx
  800a3b:	ff 75 e0             	pushl  -0x20(%ebp)
  800a3e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	83 ef 01             	sub    $0x1,%edi
  800a43:	83 c4 10             	add    $0x10,%esp
  800a46:	85 ff                	test   %edi,%edi
  800a48:	7f ed                	jg     800a37 <vprintfmt+0x1b6>
  800a4a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800a4d:	85 c9                	test   %ecx,%ecx
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	0f 49 c1             	cmovns %ecx,%eax
  800a57:	29 c1                	sub    %eax,%ecx
  800a59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a5c:	eb aa                	jmp    800a08 <vprintfmt+0x187>
					putch(ch, putdat);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	53                   	push   %ebx
  800a62:	52                   	push   %edx
  800a63:	ff d6                	call   *%esi
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a6b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	83 c7 01             	add    $0x1,%edi
  800a70:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a74:	0f be d0             	movsbl %al,%edx
  800a77:	85 d2                	test   %edx,%edx
  800a79:	74 4b                	je     800ac6 <vprintfmt+0x245>
  800a7b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a7f:	78 06                	js     800a87 <vprintfmt+0x206>
  800a81:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a85:	78 1e                	js     800aa5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800a87:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a8b:	74 d1                	je     800a5e <vprintfmt+0x1dd>
  800a8d:	0f be c0             	movsbl %al,%eax
  800a90:	83 e8 20             	sub    $0x20,%eax
  800a93:	83 f8 5e             	cmp    $0x5e,%eax
  800a96:	76 c6                	jbe    800a5e <vprintfmt+0x1dd>
					putch('?', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	53                   	push   %ebx
  800a9c:	6a 3f                	push   $0x3f
  800a9e:	ff d6                	call   *%esi
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	eb c3                	jmp    800a68 <vprintfmt+0x1e7>
  800aa5:	89 cf                	mov    %ecx,%edi
  800aa7:	eb 0e                	jmp    800ab7 <vprintfmt+0x236>
				putch(' ', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	53                   	push   %ebx
  800aad:	6a 20                	push   $0x20
  800aaf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800ab1:	83 ef 01             	sub    $0x1,%edi
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	85 ff                	test   %edi,%edi
  800ab9:	7f ee                	jg     800aa9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800abb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800abe:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac1:	e9 01 02 00 00       	jmp    800cc7 <vprintfmt+0x446>
  800ac6:	89 cf                	mov    %ecx,%edi
  800ac8:	eb ed                	jmp    800ab7 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800aca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800acd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800ad4:	e9 eb fd ff ff       	jmp    8008c4 <vprintfmt+0x43>
	if (lflag >= 2)
  800ad9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800add:	7f 21                	jg     800b00 <vprintfmt+0x27f>
	else if (lflag)
  800adf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ae3:	74 68                	je     800b4d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800aed:	89 c1                	mov    %eax,%ecx
  800aef:	c1 f9 1f             	sar    $0x1f,%ecx
  800af2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	8d 40 04             	lea    0x4(%eax),%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
  800afe:	eb 17                	jmp    800b17 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	8b 50 04             	mov    0x4(%eax),%edx
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b0b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8d 40 08             	lea    0x8(%eax),%eax
  800b14:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b20:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800b23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b27:	78 3f                	js     800b68 <vprintfmt+0x2e7>
			base = 10;
  800b29:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800b2e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800b32:	0f 84 71 01 00 00    	je     800ca9 <vprintfmt+0x428>
				putch('+', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	53                   	push   %ebx
  800b3c:	6a 2b                	push   $0x2b
  800b3e:	ff d6                	call   *%esi
  800b40:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b48:	e9 5c 01 00 00       	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	c1 f9 1f             	sar    $0x1f,%ecx
  800b5a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	8d 40 04             	lea    0x4(%eax),%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
  800b66:	eb af                	jmp    800b17 <vprintfmt+0x296>
				putch('-', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	6a 2d                	push   $0x2d
  800b6e:	ff d6                	call   *%esi
				num = -(long long) num;
  800b70:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b76:	f7 d8                	neg    %eax
  800b78:	83 d2 00             	adc    $0x0,%edx
  800b7b:	f7 da                	neg    %edx
  800b7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b83:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8b:	e9 19 01 00 00       	jmp    800ca9 <vprintfmt+0x428>
	if (lflag >= 2)
  800b90:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b94:	7f 29                	jg     800bbf <vprintfmt+0x33e>
	else if (lflag)
  800b96:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b9a:	74 44                	je     800be0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ba9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bac:	8b 45 14             	mov    0x14(%ebp),%eax
  800baf:	8d 40 04             	lea    0x4(%eax),%eax
  800bb2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bb5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bba:	e9 ea 00 00 00       	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	8b 50 04             	mov    0x4(%eax),%edx
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd0:	8d 40 08             	lea    0x8(%eax),%eax
  800bd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bdb:	e9 c9 00 00 00       	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	8d 40 04             	lea    0x4(%eax),%eax
  800bf6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfe:	e9 a6 00 00 00       	jmp    800ca9 <vprintfmt+0x428>
			putch('0', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	53                   	push   %ebx
  800c07:	6a 30                	push   $0x30
  800c09:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c12:	7f 26                	jg     800c3a <vprintfmt+0x3b9>
	else if (lflag)
  800c14:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c18:	74 3e                	je     800c58 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	8b 00                	mov    (%eax),%eax
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c27:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	8d 40 04             	lea    0x4(%eax),%eax
  800c30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c33:	b8 08 00 00 00       	mov    $0x8,%eax
  800c38:	eb 6f                	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3d:	8b 50 04             	mov    0x4(%eax),%edx
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c45:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	8d 40 08             	lea    0x8(%eax),%eax
  800c4e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c51:	b8 08 00 00 00       	mov    $0x8,%eax
  800c56:	eb 51                	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c68:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6b:	8d 40 04             	lea    0x4(%eax),%eax
  800c6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c71:	b8 08 00 00 00       	mov    $0x8,%eax
  800c76:	eb 31                	jmp    800ca9 <vprintfmt+0x428>
			putch('0', putdat);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	53                   	push   %ebx
  800c7c:	6a 30                	push   $0x30
  800c7e:	ff d6                	call   *%esi
			putch('x', putdat);
  800c80:	83 c4 08             	add    $0x8,%esp
  800c83:	53                   	push   %ebx
  800c84:	6a 78                	push   $0x78
  800c86:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c88:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c95:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800c98:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	8d 40 04             	lea    0x4(%eax),%eax
  800ca1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ca4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800cb0:	52                   	push   %edx
  800cb1:	ff 75 e0             	pushl  -0x20(%ebp)
  800cb4:	50                   	push   %eax
  800cb5:	ff 75 dc             	pushl  -0x24(%ebp)
  800cb8:	ff 75 d8             	pushl  -0x28(%ebp)
  800cbb:	89 da                	mov    %ebx,%edx
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	e8 a4 fa ff ff       	call   800768 <printnum>
			break;
  800cc4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800cc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cca:	83 c7 01             	add    $0x1,%edi
  800ccd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800cd1:	83 f8 25             	cmp    $0x25,%eax
  800cd4:	0f 84 be fb ff ff    	je     800898 <vprintfmt+0x17>
			if (ch == '\0')
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	0f 84 28 01 00 00    	je     800e0a <vprintfmt+0x589>
			putch(ch, putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	53                   	push   %ebx
  800ce6:	50                   	push   %eax
  800ce7:	ff d6                	call   *%esi
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	eb dc                	jmp    800cca <vprintfmt+0x449>
	if (lflag >= 2)
  800cee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800cf2:	7f 26                	jg     800d1a <vprintfmt+0x499>
	else if (lflag)
  800cf4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800cf8:	74 41                	je     800d3b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
  800d04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d07:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0d:	8d 40 04             	lea    0x4(%eax),%eax
  800d10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d13:	b8 10 00 00 00       	mov    $0x10,%eax
  800d18:	eb 8f                	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8b 50 04             	mov    0x4(%eax),%edx
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d25:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d28:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2b:	8d 40 08             	lea    0x8(%eax),%eax
  800d2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d31:	b8 10 00 00 00       	mov    $0x10,%eax
  800d36:	e9 6e ff ff ff       	jmp    800ca9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
  800d45:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d48:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	8d 40 04             	lea    0x4(%eax),%eax
  800d51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d54:	b8 10 00 00 00       	mov    $0x10,%eax
  800d59:	e9 4b ff ff ff       	jmp    800ca9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	74 14                	je     800d84 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800d70:	8b 13                	mov    (%ebx),%edx
  800d72:	83 fa 7f             	cmp    $0x7f,%edx
  800d75:	7f 37                	jg     800dae <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800d77:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800d79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7f:	e9 43 ff ff ff       	jmp    800cc7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800d84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d89:	bf b1 2d 80 00       	mov    $0x802db1,%edi
							putch(ch, putdat);
  800d8e:	83 ec 08             	sub    $0x8,%esp
  800d91:	53                   	push   %ebx
  800d92:	50                   	push   %eax
  800d93:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800d95:	83 c7 01             	add    $0x1,%edi
  800d98:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800d9c:	83 c4 10             	add    $0x10,%esp
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	75 eb                	jne    800d8e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800da3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800da6:	89 45 14             	mov    %eax,0x14(%ebp)
  800da9:	e9 19 ff ff ff       	jmp    800cc7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800dae:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800db0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db5:	bf e9 2d 80 00       	mov    $0x802de9,%edi
							putch(ch, putdat);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	53                   	push   %ebx
  800dbe:	50                   	push   %eax
  800dbf:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800dc1:	83 c7 01             	add    $0x1,%edi
  800dc4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	75 eb                	jne    800dba <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800dcf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dd2:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd5:	e9 ed fe ff ff       	jmp    800cc7 <vprintfmt+0x446>
			putch(ch, putdat);
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	53                   	push   %ebx
  800dde:	6a 25                	push   $0x25
  800de0:	ff d6                	call   *%esi
			break;
  800de2:	83 c4 10             	add    $0x10,%esp
  800de5:	e9 dd fe ff ff       	jmp    800cc7 <vprintfmt+0x446>
			putch('%', putdat);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	53                   	push   %ebx
  800dee:	6a 25                	push   $0x25
  800df0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	89 f8                	mov    %edi,%eax
  800df7:	eb 03                	jmp    800dfc <vprintfmt+0x57b>
  800df9:	83 e8 01             	sub    $0x1,%eax
  800dfc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e00:	75 f7                	jne    800df9 <vprintfmt+0x578>
  800e02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e05:	e9 bd fe ff ff       	jmp    800cc7 <vprintfmt+0x446>
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 18             	sub    $0x18,%esp
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e21:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e25:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	74 26                	je     800e59 <vsnprintf+0x47>
  800e33:	85 d2                	test   %edx,%edx
  800e35:	7e 22                	jle    800e59 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e37:	ff 75 14             	pushl  0x14(%ebp)
  800e3a:	ff 75 10             	pushl  0x10(%ebp)
  800e3d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e40:	50                   	push   %eax
  800e41:	68 47 08 80 00       	push   $0x800847
  800e46:	e8 36 fa ff ff       	call   800881 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e54:	83 c4 10             	add    $0x10,%esp
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    
		return -E_INVAL;
  800e59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e5e:	eb f7                	jmp    800e57 <vsnprintf+0x45>

00800e60 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e66:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e69:	50                   	push   %eax
  800e6a:	ff 75 10             	pushl  0x10(%ebp)
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	ff 75 08             	pushl  0x8(%ebp)
  800e73:	e8 9a ff ff ff       	call   800e12 <vsnprintf>
	va_end(ap);

	return rc;
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e80:	b8 00 00 00 00       	mov    $0x0,%eax
  800e85:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e89:	74 05                	je     800e90 <strlen+0x16>
		n++;
  800e8b:	83 c0 01             	add    $0x1,%eax
  800e8e:	eb f5                	jmp    800e85 <strlen+0xb>
	return n;
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea0:	39 c2                	cmp    %eax,%edx
  800ea2:	74 0d                	je     800eb1 <strnlen+0x1f>
  800ea4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ea8:	74 05                	je     800eaf <strnlen+0x1d>
		n++;
  800eaa:	83 c2 01             	add    $0x1,%edx
  800ead:	eb f1                	jmp    800ea0 <strnlen+0xe>
  800eaf:	89 d0                	mov    %edx,%eax
	return n;
}
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	53                   	push   %ebx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ec6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ec9:	83 c2 01             	add    $0x1,%edx
  800ecc:	84 c9                	test   %cl,%cl
  800ece:	75 f2                	jne    800ec2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 10             	sub    $0x10,%esp
  800eda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800edd:	53                   	push   %ebx
  800ede:	e8 97 ff ff ff       	call   800e7a <strlen>
  800ee3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ee6:	ff 75 0c             	pushl  0xc(%ebp)
  800ee9:	01 d8                	add    %ebx,%eax
  800eeb:	50                   	push   %eax
  800eec:	e8 c2 ff ff ff       	call   800eb3 <strcpy>
	return dst;
}
  800ef1:	89 d8                	mov    %ebx,%eax
  800ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	89 c6                	mov    %eax,%esi
  800f05:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f08:	89 c2                	mov    %eax,%edx
  800f0a:	39 f2                	cmp    %esi,%edx
  800f0c:	74 11                	je     800f1f <strncpy+0x27>
		*dst++ = *src;
  800f0e:	83 c2 01             	add    $0x1,%edx
  800f11:	0f b6 19             	movzbl (%ecx),%ebx
  800f14:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f17:	80 fb 01             	cmp    $0x1,%bl
  800f1a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f1d:	eb eb                	jmp    800f0a <strncpy+0x12>
	}
	return ret;
}
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
  800f28:	8b 75 08             	mov    0x8(%ebp),%esi
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f31:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f33:	85 d2                	test   %edx,%edx
  800f35:	74 21                	je     800f58 <strlcpy+0x35>
  800f37:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f3b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f3d:	39 c2                	cmp    %eax,%edx
  800f3f:	74 14                	je     800f55 <strlcpy+0x32>
  800f41:	0f b6 19             	movzbl (%ecx),%ebx
  800f44:	84 db                	test   %bl,%bl
  800f46:	74 0b                	je     800f53 <strlcpy+0x30>
			*dst++ = *src++;
  800f48:	83 c1 01             	add    $0x1,%ecx
  800f4b:	83 c2 01             	add    $0x1,%edx
  800f4e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f51:	eb ea                	jmp    800f3d <strlcpy+0x1a>
  800f53:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f55:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f58:	29 f0                	sub    %esi,%eax
}
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f64:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f67:	0f b6 01             	movzbl (%ecx),%eax
  800f6a:	84 c0                	test   %al,%al
  800f6c:	74 0c                	je     800f7a <strcmp+0x1c>
  800f6e:	3a 02                	cmp    (%edx),%al
  800f70:	75 08                	jne    800f7a <strcmp+0x1c>
		p++, q++;
  800f72:	83 c1 01             	add    $0x1,%ecx
  800f75:	83 c2 01             	add    $0x1,%edx
  800f78:	eb ed                	jmp    800f67 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	0f b6 12             	movzbl (%edx),%edx
  800f80:	29 d0                	sub    %edx,%eax
}
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	53                   	push   %ebx
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f93:	eb 06                	jmp    800f9b <strncmp+0x17>
		n--, p++, q++;
  800f95:	83 c0 01             	add    $0x1,%eax
  800f98:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f9b:	39 d8                	cmp    %ebx,%eax
  800f9d:	74 16                	je     800fb5 <strncmp+0x31>
  800f9f:	0f b6 08             	movzbl (%eax),%ecx
  800fa2:	84 c9                	test   %cl,%cl
  800fa4:	74 04                	je     800faa <strncmp+0x26>
  800fa6:	3a 0a                	cmp    (%edx),%cl
  800fa8:	74 eb                	je     800f95 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800faa:	0f b6 00             	movzbl (%eax),%eax
  800fad:	0f b6 12             	movzbl (%edx),%edx
  800fb0:	29 d0                	sub    %edx,%eax
}
  800fb2:	5b                   	pop    %ebx
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    
		return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fba:	eb f6                	jmp    800fb2 <strncmp+0x2e>

00800fbc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fc6:	0f b6 10             	movzbl (%eax),%edx
  800fc9:	84 d2                	test   %dl,%dl
  800fcb:	74 09                	je     800fd6 <strchr+0x1a>
		if (*s == c)
  800fcd:	38 ca                	cmp    %cl,%dl
  800fcf:	74 0a                	je     800fdb <strchr+0x1f>
	for (; *s; s++)
  800fd1:	83 c0 01             	add    $0x1,%eax
  800fd4:	eb f0                	jmp    800fc6 <strchr+0xa>
			return (char *) s;
	return 0;
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fe7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800fea:	38 ca                	cmp    %cl,%dl
  800fec:	74 09                	je     800ff7 <strfind+0x1a>
  800fee:	84 d2                	test   %dl,%dl
  800ff0:	74 05                	je     800ff7 <strfind+0x1a>
	for (; *s; s++)
  800ff2:	83 c0 01             	add    $0x1,%eax
  800ff5:	eb f0                	jmp    800fe7 <strfind+0xa>
			break;
	return (char *) s;
}
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
  800fff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801002:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801005:	85 c9                	test   %ecx,%ecx
  801007:	74 31                	je     80103a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801009:	89 f8                	mov    %edi,%eax
  80100b:	09 c8                	or     %ecx,%eax
  80100d:	a8 03                	test   $0x3,%al
  80100f:	75 23                	jne    801034 <memset+0x3b>
		c &= 0xFF;
  801011:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801015:	89 d3                	mov    %edx,%ebx
  801017:	c1 e3 08             	shl    $0x8,%ebx
  80101a:	89 d0                	mov    %edx,%eax
  80101c:	c1 e0 18             	shl    $0x18,%eax
  80101f:	89 d6                	mov    %edx,%esi
  801021:	c1 e6 10             	shl    $0x10,%esi
  801024:	09 f0                	or     %esi,%eax
  801026:	09 c2                	or     %eax,%edx
  801028:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80102a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80102d:	89 d0                	mov    %edx,%eax
  80102f:	fc                   	cld    
  801030:	f3 ab                	rep stos %eax,%es:(%edi)
  801032:	eb 06                	jmp    80103a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	fc                   	cld    
  801038:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80103a:	89 f8                	mov    %edi,%eax
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8b 75 0c             	mov    0xc(%ebp),%esi
  80104c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80104f:	39 c6                	cmp    %eax,%esi
  801051:	73 32                	jae    801085 <memmove+0x44>
  801053:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801056:	39 c2                	cmp    %eax,%edx
  801058:	76 2b                	jbe    801085 <memmove+0x44>
		s += n;
		d += n;
  80105a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80105d:	89 fe                	mov    %edi,%esi
  80105f:	09 ce                	or     %ecx,%esi
  801061:	09 d6                	or     %edx,%esi
  801063:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801069:	75 0e                	jne    801079 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80106b:	83 ef 04             	sub    $0x4,%edi
  80106e:	8d 72 fc             	lea    -0x4(%edx),%esi
  801071:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801074:	fd                   	std    
  801075:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801077:	eb 09                	jmp    801082 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801079:	83 ef 01             	sub    $0x1,%edi
  80107c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80107f:	fd                   	std    
  801080:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801082:	fc                   	cld    
  801083:	eb 1a                	jmp    80109f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801085:	89 c2                	mov    %eax,%edx
  801087:	09 ca                	or     %ecx,%edx
  801089:	09 f2                	or     %esi,%edx
  80108b:	f6 c2 03             	test   $0x3,%dl
  80108e:	75 0a                	jne    80109a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801090:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801093:	89 c7                	mov    %eax,%edi
  801095:	fc                   	cld    
  801096:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801098:	eb 05                	jmp    80109f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80109a:	89 c7                	mov    %eax,%edi
  80109c:	fc                   	cld    
  80109d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010a9:	ff 75 10             	pushl  0x10(%ebp)
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	ff 75 08             	pushl  0x8(%ebp)
  8010b2:	e8 8a ff ff ff       	call   801041 <memmove>
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c4:	89 c6                	mov    %eax,%esi
  8010c6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010c9:	39 f0                	cmp    %esi,%eax
  8010cb:	74 1c                	je     8010e9 <memcmp+0x30>
		if (*s1 != *s2)
  8010cd:	0f b6 08             	movzbl (%eax),%ecx
  8010d0:	0f b6 1a             	movzbl (%edx),%ebx
  8010d3:	38 d9                	cmp    %bl,%cl
  8010d5:	75 08                	jne    8010df <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8010d7:	83 c0 01             	add    $0x1,%eax
  8010da:	83 c2 01             	add    $0x1,%edx
  8010dd:	eb ea                	jmp    8010c9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8010df:	0f b6 c1             	movzbl %cl,%eax
  8010e2:	0f b6 db             	movzbl %bl,%ebx
  8010e5:	29 d8                	sub    %ebx,%eax
  8010e7:	eb 05                	jmp    8010ee <memcmp+0x35>
	}

	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    

008010f2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801100:	39 d0                	cmp    %edx,%eax
  801102:	73 09                	jae    80110d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801104:	38 08                	cmp    %cl,(%eax)
  801106:	74 05                	je     80110d <memfind+0x1b>
	for (; s < ends; s++)
  801108:	83 c0 01             	add    $0x1,%eax
  80110b:	eb f3                	jmp    801100 <memfind+0xe>
			break;
	return (void *) s;
}
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
  801115:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801118:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80111b:	eb 03                	jmp    801120 <strtol+0x11>
		s++;
  80111d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801120:	0f b6 01             	movzbl (%ecx),%eax
  801123:	3c 20                	cmp    $0x20,%al
  801125:	74 f6                	je     80111d <strtol+0xe>
  801127:	3c 09                	cmp    $0x9,%al
  801129:	74 f2                	je     80111d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80112b:	3c 2b                	cmp    $0x2b,%al
  80112d:	74 2a                	je     801159 <strtol+0x4a>
	int neg = 0;
  80112f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801134:	3c 2d                	cmp    $0x2d,%al
  801136:	74 2b                	je     801163 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801138:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80113e:	75 0f                	jne    80114f <strtol+0x40>
  801140:	80 39 30             	cmpb   $0x30,(%ecx)
  801143:	74 28                	je     80116d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801145:	85 db                	test   %ebx,%ebx
  801147:	b8 0a 00 00 00       	mov    $0xa,%eax
  80114c:	0f 44 d8             	cmove  %eax,%ebx
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801157:	eb 50                	jmp    8011a9 <strtol+0x9a>
		s++;
  801159:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80115c:	bf 00 00 00 00       	mov    $0x0,%edi
  801161:	eb d5                	jmp    801138 <strtol+0x29>
		s++, neg = 1;
  801163:	83 c1 01             	add    $0x1,%ecx
  801166:	bf 01 00 00 00       	mov    $0x1,%edi
  80116b:	eb cb                	jmp    801138 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801171:	74 0e                	je     801181 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801173:	85 db                	test   %ebx,%ebx
  801175:	75 d8                	jne    80114f <strtol+0x40>
		s++, base = 8;
  801177:	83 c1 01             	add    $0x1,%ecx
  80117a:	bb 08 00 00 00       	mov    $0x8,%ebx
  80117f:	eb ce                	jmp    80114f <strtol+0x40>
		s += 2, base = 16;
  801181:	83 c1 02             	add    $0x2,%ecx
  801184:	bb 10 00 00 00       	mov    $0x10,%ebx
  801189:	eb c4                	jmp    80114f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80118b:	8d 72 9f             	lea    -0x61(%edx),%esi
  80118e:	89 f3                	mov    %esi,%ebx
  801190:	80 fb 19             	cmp    $0x19,%bl
  801193:	77 29                	ja     8011be <strtol+0xaf>
			dig = *s - 'a' + 10;
  801195:	0f be d2             	movsbl %dl,%edx
  801198:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80119b:	3b 55 10             	cmp    0x10(%ebp),%edx
  80119e:	7d 30                	jge    8011d0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011a0:	83 c1 01             	add    $0x1,%ecx
  8011a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011a9:	0f b6 11             	movzbl (%ecx),%edx
  8011ac:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011af:	89 f3                	mov    %esi,%ebx
  8011b1:	80 fb 09             	cmp    $0x9,%bl
  8011b4:	77 d5                	ja     80118b <strtol+0x7c>
			dig = *s - '0';
  8011b6:	0f be d2             	movsbl %dl,%edx
  8011b9:	83 ea 30             	sub    $0x30,%edx
  8011bc:	eb dd                	jmp    80119b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011be:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011c1:	89 f3                	mov    %esi,%ebx
  8011c3:	80 fb 19             	cmp    $0x19,%bl
  8011c6:	77 08                	ja     8011d0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8011c8:	0f be d2             	movsbl %dl,%edx
  8011cb:	83 ea 37             	sub    $0x37,%edx
  8011ce:	eb cb                	jmp    80119b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d4:	74 05                	je     8011db <strtol+0xcc>
		*endptr = (char *) s;
  8011d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	f7 da                	neg    %edx
  8011df:	85 ff                	test   %edi,%edi
  8011e1:	0f 45 c2             	cmovne %edx,%eax
}
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	57                   	push   %edi
  8011ed:	56                   	push   %esi
  8011ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	89 c7                	mov    %eax,%edi
  8011fe:	89 c6                	mov    %eax,%esi
  801200:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801202:	5b                   	pop    %ebx
  801203:	5e                   	pop    %esi
  801204:	5f                   	pop    %edi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <sys_cgetc>:

int
sys_cgetc(void)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	57                   	push   %edi
  80120b:	56                   	push   %esi
  80120c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120d:	ba 00 00 00 00       	mov    $0x0,%edx
  801212:	b8 01 00 00 00       	mov    $0x1,%eax
  801217:	89 d1                	mov    %edx,%ecx
  801219:	89 d3                	mov    %edx,%ebx
  80121b:	89 d7                	mov    %edx,%edi
  80121d:	89 d6                	mov    %edx,%esi
  80121f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    

00801226 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
  80122c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	b8 03 00 00 00       	mov    $0x3,%eax
  80123c:	89 cb                	mov    %ecx,%ebx
  80123e:	89 cf                	mov    %ecx,%edi
  801240:	89 ce                	mov    %ecx,%esi
  801242:	cd 30                	int    $0x30
	if(check && ret > 0)
  801244:	85 c0                	test   %eax,%eax
  801246:	7f 08                	jg     801250 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	50                   	push   %eax
  801254:	6a 03                	push   $0x3
  801256:	68 08 30 80 00       	push   $0x803008
  80125b:	6a 43                	push   $0x43
  80125d:	68 25 30 80 00       	push   $0x803025
  801262:	e8 f7 f3 ff ff       	call   80065e <_panic>

00801267 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126d:	ba 00 00 00 00       	mov    $0x0,%edx
  801272:	b8 02 00 00 00       	mov    $0x2,%eax
  801277:	89 d1                	mov    %edx,%ecx
  801279:	89 d3                	mov    %edx,%ebx
  80127b:	89 d7                	mov    %edx,%edi
  80127d:	89 d6                	mov    %edx,%esi
  80127f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <sys_yield>:

void
sys_yield(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	57                   	push   %edi
  80128a:	56                   	push   %esi
  80128b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80128c:	ba 00 00 00 00       	mov    $0x0,%edx
  801291:	b8 0b 00 00 00       	mov    $0xb,%eax
  801296:	89 d1                	mov    %edx,%ecx
  801298:	89 d3                	mov    %edx,%ebx
  80129a:	89 d7                	mov    %edx,%edi
  80129c:	89 d6                	mov    %edx,%esi
  80129e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012a0:	5b                   	pop    %ebx
  8012a1:	5e                   	pop    %esi
  8012a2:	5f                   	pop    %edi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	57                   	push   %edi
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ae:	be 00 00 00 00       	mov    $0x0,%esi
  8012b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b9:	b8 04 00 00 00       	mov    $0x4,%eax
  8012be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012c1:	89 f7                	mov    %esi,%edi
  8012c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	7f 08                	jg     8012d1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cc:	5b                   	pop    %ebx
  8012cd:	5e                   	pop    %esi
  8012ce:	5f                   	pop    %edi
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	50                   	push   %eax
  8012d5:	6a 04                	push   $0x4
  8012d7:	68 08 30 80 00       	push   $0x803008
  8012dc:	6a 43                	push   $0x43
  8012de:	68 25 30 80 00       	push   $0x803025
  8012e3:	e8 76 f3 ff ff       	call   80065e <_panic>

008012e8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8012fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801302:	8b 75 18             	mov    0x18(%ebp),%esi
  801305:	cd 30                	int    $0x30
	if(check && ret > 0)
  801307:	85 c0                	test   %eax,%eax
  801309:	7f 08                	jg     801313 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80130b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130e:	5b                   	pop    %ebx
  80130f:	5e                   	pop    %esi
  801310:	5f                   	pop    %edi
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801313:	83 ec 0c             	sub    $0xc,%esp
  801316:	50                   	push   %eax
  801317:	6a 05                	push   $0x5
  801319:	68 08 30 80 00       	push   $0x803008
  80131e:	6a 43                	push   $0x43
  801320:	68 25 30 80 00       	push   $0x803025
  801325:	e8 34 f3 ff ff       	call   80065e <_panic>

0080132a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	57                   	push   %edi
  80132e:	56                   	push   %esi
  80132f:	53                   	push   %ebx
  801330:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801333:	bb 00 00 00 00       	mov    $0x0,%ebx
  801338:	8b 55 08             	mov    0x8(%ebp),%edx
  80133b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133e:	b8 06 00 00 00       	mov    $0x6,%eax
  801343:	89 df                	mov    %ebx,%edi
  801345:	89 de                	mov    %ebx,%esi
  801347:	cd 30                	int    $0x30
	if(check && ret > 0)
  801349:	85 c0                	test   %eax,%eax
  80134b:	7f 08                	jg     801355 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80134d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801350:	5b                   	pop    %ebx
  801351:	5e                   	pop    %esi
  801352:	5f                   	pop    %edi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	50                   	push   %eax
  801359:	6a 06                	push   $0x6
  80135b:	68 08 30 80 00       	push   $0x803008
  801360:	6a 43                	push   $0x43
  801362:	68 25 30 80 00       	push   $0x803025
  801367:	e8 f2 f2 ff ff       	call   80065e <_panic>

0080136c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801375:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137a:	8b 55 08             	mov    0x8(%ebp),%edx
  80137d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801380:	b8 08 00 00 00       	mov    $0x8,%eax
  801385:	89 df                	mov    %ebx,%edi
  801387:	89 de                	mov    %ebx,%esi
  801389:	cd 30                	int    $0x30
	if(check && ret > 0)
  80138b:	85 c0                	test   %eax,%eax
  80138d:	7f 08                	jg     801397 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80138f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	50                   	push   %eax
  80139b:	6a 08                	push   $0x8
  80139d:	68 08 30 80 00       	push   $0x803008
  8013a2:	6a 43                	push   $0x43
  8013a4:	68 25 30 80 00       	push   $0x803025
  8013a9:	e8 b0 f2 ff ff       	call   80065e <_panic>

008013ae <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	57                   	push   %edi
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c2:	b8 09 00 00 00       	mov    $0x9,%eax
  8013c7:	89 df                	mov    %ebx,%edi
  8013c9:	89 de                	mov    %ebx,%esi
  8013cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	7f 08                	jg     8013d9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5f                   	pop    %edi
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	50                   	push   %eax
  8013dd:	6a 09                	push   $0x9
  8013df:	68 08 30 80 00       	push   $0x803008
  8013e4:	6a 43                	push   $0x43
  8013e6:	68 25 30 80 00       	push   $0x803025
  8013eb:	e8 6e f2 ff ff       	call   80065e <_panic>

008013f0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801401:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801404:	b8 0a 00 00 00       	mov    $0xa,%eax
  801409:	89 df                	mov    %ebx,%edi
  80140b:	89 de                	mov    %ebx,%esi
  80140d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	7f 08                	jg     80141b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801416:	5b                   	pop    %ebx
  801417:	5e                   	pop    %esi
  801418:	5f                   	pop    %edi
  801419:	5d                   	pop    %ebp
  80141a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	6a 0a                	push   $0xa
  801421:	68 08 30 80 00       	push   $0x803008
  801426:	6a 43                	push   $0x43
  801428:	68 25 30 80 00       	push   $0x803025
  80142d:	e8 2c f2 ff ff       	call   80065e <_panic>

00801432 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	57                   	push   %edi
  801436:	56                   	push   %esi
  801437:	53                   	push   %ebx
	asm volatile("int %1\n"
  801438:	8b 55 08             	mov    0x8(%ebp),%edx
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801443:	be 00 00 00 00       	mov    $0x0,%esi
  801448:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80144b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80144e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    

00801455 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80145e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	b8 0d 00 00 00       	mov    $0xd,%eax
  80146b:	89 cb                	mov    %ecx,%ebx
  80146d:	89 cf                	mov    %ecx,%edi
  80146f:	89 ce                	mov    %ecx,%esi
  801471:	cd 30                	int    $0x30
	if(check && ret > 0)
  801473:	85 c0                	test   %eax,%eax
  801475:	7f 08                	jg     80147f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801477:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5f                   	pop    %edi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	50                   	push   %eax
  801483:	6a 0d                	push   $0xd
  801485:	68 08 30 80 00       	push   $0x803008
  80148a:	6a 43                	push   $0x43
  80148c:	68 25 30 80 00       	push   $0x803025
  801491:	e8 c8 f1 ff ff       	call   80065e <_panic>

00801496 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	57                   	push   %edi
  80149a:	56                   	push   %esi
  80149b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80149c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014ac:	89 df                	mov    %ebx,%edi
  8014ae:	89 de                	mov    %ebx,%esi
  8014b0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	57                   	push   %edi
  8014bb:	56                   	push   %esi
  8014bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8014ca:	89 cb                	mov    %ecx,%ebx
  8014cc:	89 cf                	mov    %ecx,%edi
  8014ce:	89 ce                	mov    %ecx,%esi
  8014d0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5f                   	pop    %edi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	57                   	push   %edi
  8014db:	56                   	push   %esi
  8014dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8014e7:	89 d1                	mov    %edx,%ecx
  8014e9:	89 d3                	mov    %edx,%ebx
  8014eb:	89 d7                	mov    %edx,%edi
  8014ed:	89 d6                	mov    %edx,%esi
  8014ef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	57                   	push   %edi
  8014fa:	56                   	push   %esi
  8014fb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801501:	8b 55 08             	mov    0x8(%ebp),%edx
  801504:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801507:	b8 11 00 00 00       	mov    $0x11,%eax
  80150c:	89 df                	mov    %ebx,%edi
  80150e:	89 de                	mov    %ebx,%esi
  801510:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5f                   	pop    %edi
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	57                   	push   %edi
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80151d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801522:	8b 55 08             	mov    0x8(%ebp),%edx
  801525:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801528:	b8 12 00 00 00       	mov    $0x12,%eax
  80152d:	89 df                	mov    %ebx,%edi
  80152f:	89 de                	mov    %ebx,%esi
  801531:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5f                   	pop    %edi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	57                   	push   %edi
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
  80153e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801541:	bb 00 00 00 00       	mov    $0x0,%ebx
  801546:	8b 55 08             	mov    0x8(%ebp),%edx
  801549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154c:	b8 13 00 00 00       	mov    $0x13,%eax
  801551:	89 df                	mov    %ebx,%edi
  801553:	89 de                	mov    %ebx,%esi
  801555:	cd 30                	int    $0x30
	if(check && ret > 0)
  801557:	85 c0                	test   %eax,%eax
  801559:	7f 08                	jg     801563 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801563:	83 ec 0c             	sub    $0xc,%esp
  801566:	50                   	push   %eax
  801567:	6a 13                	push   $0x13
  801569:	68 08 30 80 00       	push   $0x803008
  80156e:	6a 43                	push   $0x43
  801570:	68 25 30 80 00       	push   $0x803025
  801575:	e8 e4 f0 ff ff       	call   80065e <_panic>

0080157a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	57                   	push   %edi
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801580:	b9 00 00 00 00       	mov    $0x0,%ecx
  801585:	8b 55 08             	mov    0x8(%ebp),%edx
  801588:	b8 14 00 00 00       	mov    $0x14,%eax
  80158d:	89 cb                	mov    %ecx,%ebx
  80158f:	89 cf                	mov    %ecx,%edi
  801591:	89 ce                	mov    %ecx,%esi
  801593:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5f                   	pop    %edi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    

0080159a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8015a0:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  8015a7:	74 0a                	je     8015b3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	6a 07                	push   $0x7
  8015b8:	68 00 f0 bf ee       	push   $0xeebff000
  8015bd:	6a 00                	push   $0x0
  8015bf:	e8 e1 fc ff ff       	call   8012a5 <sys_page_alloc>
		if(r < 0)
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 2a                	js     8015f5 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	68 09 16 80 00       	push   $0x801609
  8015d3:	6a 00                	push   $0x0
  8015d5:	e8 16 fe ff ff       	call   8013f0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	79 c8                	jns    8015a9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 64 30 80 00       	push   $0x803064
  8015e9:	6a 25                	push   $0x25
  8015eb:	68 9d 30 80 00       	push   $0x80309d
  8015f0:	e8 69 f0 ff ff       	call   80065e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 34 30 80 00       	push   $0x803034
  8015fd:	6a 22                	push   $0x22
  8015ff:	68 9d 30 80 00       	push   $0x80309d
  801604:	e8 55 f0 ff ff       	call   80065e <_panic>

00801609 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801609:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80160a:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  80160f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801611:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801614:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801618:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80161c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80161f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801621:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801625:	83 c4 08             	add    $0x8,%esp
	popal
  801628:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801629:	83 c4 04             	add    $0x4,%esp
	popfl
  80162c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80162d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80162e:	c3                   	ret    

0080162f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	05 00 00 00 30       	add    $0x30000000,%eax
  80163a:	c1 e8 0c             	shr    $0xc,%eax
}
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    

0080163f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80164a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80164f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80165e:	89 c2                	mov    %eax,%edx
  801660:	c1 ea 16             	shr    $0x16,%edx
  801663:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80166a:	f6 c2 01             	test   $0x1,%dl
  80166d:	74 2d                	je     80169c <fd_alloc+0x46>
  80166f:	89 c2                	mov    %eax,%edx
  801671:	c1 ea 0c             	shr    $0xc,%edx
  801674:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80167b:	f6 c2 01             	test   $0x1,%dl
  80167e:	74 1c                	je     80169c <fd_alloc+0x46>
  801680:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801685:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80168a:	75 d2                	jne    80165e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801695:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80169a:	eb 0a                	jmp    8016a6 <fd_alloc+0x50>
			*fd_store = fd;
  80169c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169f:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ae:	83 f8 1f             	cmp    $0x1f,%eax
  8016b1:	77 30                	ja     8016e3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016b3:	c1 e0 0c             	shl    $0xc,%eax
  8016b6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016bb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016c1:	f6 c2 01             	test   $0x1,%dl
  8016c4:	74 24                	je     8016ea <fd_lookup+0x42>
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	c1 ea 0c             	shr    $0xc,%edx
  8016cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d2:	f6 c2 01             	test   $0x1,%dl
  8016d5:	74 1a                	je     8016f1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	89 02                	mov    %eax,(%edx)
	return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
		return -E_INVAL;
  8016e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e8:	eb f7                	jmp    8016e1 <fd_lookup+0x39>
		return -E_INVAL;
  8016ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ef:	eb f0                	jmp    8016e1 <fd_lookup+0x39>
  8016f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f6:	eb e9                	jmp    8016e1 <fd_lookup+0x39>

008016f8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801701:	ba 00 00 00 00       	mov    $0x0,%edx
  801706:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80170b:	39 08                	cmp    %ecx,(%eax)
  80170d:	74 38                	je     801747 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80170f:	83 c2 01             	add    $0x1,%edx
  801712:	8b 04 95 2c 31 80 00 	mov    0x80312c(,%edx,4),%eax
  801719:	85 c0                	test   %eax,%eax
  80171b:	75 ee                	jne    80170b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80171d:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801722:	8b 40 48             	mov    0x48(%eax),%eax
  801725:	83 ec 04             	sub    $0x4,%esp
  801728:	51                   	push   %ecx
  801729:	50                   	push   %eax
  80172a:	68 ac 30 80 00       	push   $0x8030ac
  80172f:	e8 20 f0 ff ff       	call   800754 <cprintf>
	*dev = 0;
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    
			*dev = devtab[i];
  801747:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb f2                	jmp    801745 <dev_lookup+0x4d>

00801753 <fd_close>:
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	57                   	push   %edi
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
  801759:	83 ec 24             	sub    $0x24,%esp
  80175c:	8b 75 08             	mov    0x8(%ebp),%esi
  80175f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801762:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801765:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801766:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80176c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80176f:	50                   	push   %eax
  801770:	e8 33 ff ff ff       	call   8016a8 <fd_lookup>
  801775:	89 c3                	mov    %eax,%ebx
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 05                	js     801783 <fd_close+0x30>
	    || fd != fd2)
  80177e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801781:	74 16                	je     801799 <fd_close+0x46>
		return (must_exist ? r : 0);
  801783:	89 f8                	mov    %edi,%eax
  801785:	84 c0                	test   %al,%al
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
  80178c:	0f 44 d8             	cmove  %eax,%ebx
}
  80178f:	89 d8                	mov    %ebx,%eax
  801791:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801794:	5b                   	pop    %ebx
  801795:	5e                   	pop    %esi
  801796:	5f                   	pop    %edi
  801797:	5d                   	pop    %ebp
  801798:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	ff 36                	pushl  (%esi)
  8017a2:	e8 51 ff ff ff       	call   8016f8 <dev_lookup>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 1a                	js     8017ca <fd_close+0x77>
		if (dev->dev_close)
  8017b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	74 0b                	je     8017ca <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	56                   	push   %esi
  8017c3:	ff d0                	call   *%eax
  8017c5:	89 c3                	mov    %eax,%ebx
  8017c7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	56                   	push   %esi
  8017ce:	6a 00                	push   $0x0
  8017d0:	e8 55 fb ff ff       	call   80132a <sys_page_unmap>
	return r;
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	eb b5                	jmp    80178f <fd_close+0x3c>

008017da <close>:

int
close(int fdnum)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e3:	50                   	push   %eax
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	e8 bc fe ff ff       	call   8016a8 <fd_lookup>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	79 02                	jns    8017f5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    
		return fd_close(fd, 1);
  8017f5:	83 ec 08             	sub    $0x8,%esp
  8017f8:	6a 01                	push   $0x1
  8017fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fd:	e8 51 ff ff ff       	call   801753 <fd_close>
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	eb ec                	jmp    8017f3 <close+0x19>

00801807 <close_all>:

void
close_all(void)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80180e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	53                   	push   %ebx
  801817:	e8 be ff ff ff       	call   8017da <close>
	for (i = 0; i < MAXFD; i++)
  80181c:	83 c3 01             	add    $0x1,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	83 fb 20             	cmp    $0x20,%ebx
  801825:	75 ec                	jne    801813 <close_all+0xc>
}
  801827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	57                   	push   %edi
  801830:	56                   	push   %esi
  801831:	53                   	push   %ebx
  801832:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801835:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	e8 67 fe ff ff       	call   8016a8 <fd_lookup>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	85 c0                	test   %eax,%eax
  801848:	0f 88 81 00 00 00    	js     8018cf <dup+0xa3>
		return r;
	close(newfdnum);
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	e8 81 ff ff ff       	call   8017da <close>

	newfd = INDEX2FD(newfdnum);
  801859:	8b 75 0c             	mov    0xc(%ebp),%esi
  80185c:	c1 e6 0c             	shl    $0xc,%esi
  80185f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801865:	83 c4 04             	add    $0x4,%esp
  801868:	ff 75 e4             	pushl  -0x1c(%ebp)
  80186b:	e8 cf fd ff ff       	call   80163f <fd2data>
  801870:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801872:	89 34 24             	mov    %esi,(%esp)
  801875:	e8 c5 fd ff ff       	call   80163f <fd2data>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80187f:	89 d8                	mov    %ebx,%eax
  801881:	c1 e8 16             	shr    $0x16,%eax
  801884:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80188b:	a8 01                	test   $0x1,%al
  80188d:	74 11                	je     8018a0 <dup+0x74>
  80188f:	89 d8                	mov    %ebx,%eax
  801891:	c1 e8 0c             	shr    $0xc,%eax
  801894:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80189b:	f6 c2 01             	test   $0x1,%dl
  80189e:	75 39                	jne    8018d9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018a3:	89 d0                	mov    %edx,%eax
  8018a5:	c1 e8 0c             	shr    $0xc,%eax
  8018a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8018b7:	50                   	push   %eax
  8018b8:	56                   	push   %esi
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	6a 00                	push   $0x0
  8018be:	e8 25 fa ff ff       	call   8012e8 <sys_page_map>
  8018c3:	89 c3                	mov    %eax,%ebx
  8018c5:	83 c4 20             	add    $0x20,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 31                	js     8018fd <dup+0xd1>
		goto err;

	return newfdnum;
  8018cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018cf:	89 d8                	mov    %ebx,%eax
  8018d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5f                   	pop    %edi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8018e8:	50                   	push   %eax
  8018e9:	57                   	push   %edi
  8018ea:	6a 00                	push   $0x0
  8018ec:	53                   	push   %ebx
  8018ed:	6a 00                	push   $0x0
  8018ef:	e8 f4 f9 ff ff       	call   8012e8 <sys_page_map>
  8018f4:	89 c3                	mov    %eax,%ebx
  8018f6:	83 c4 20             	add    $0x20,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	79 a3                	jns    8018a0 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018fd:	83 ec 08             	sub    $0x8,%esp
  801900:	56                   	push   %esi
  801901:	6a 00                	push   $0x0
  801903:	e8 22 fa ff ff       	call   80132a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801908:	83 c4 08             	add    $0x8,%esp
  80190b:	57                   	push   %edi
  80190c:	6a 00                	push   $0x0
  80190e:	e8 17 fa ff ff       	call   80132a <sys_page_unmap>
	return r;
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	eb b7                	jmp    8018cf <dup+0xa3>

00801918 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	53                   	push   %ebx
  80191c:	83 ec 1c             	sub    $0x1c,%esp
  80191f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801922:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801925:	50                   	push   %eax
  801926:	53                   	push   %ebx
  801927:	e8 7c fd ff ff       	call   8016a8 <fd_lookup>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 3f                	js     801972 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801939:	50                   	push   %eax
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	ff 30                	pushl  (%eax)
  80193f:	e8 b4 fd ff ff       	call   8016f8 <dev_lookup>
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 27                	js     801972 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80194b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194e:	8b 42 08             	mov    0x8(%edx),%eax
  801951:	83 e0 03             	and    $0x3,%eax
  801954:	83 f8 01             	cmp    $0x1,%eax
  801957:	74 1e                	je     801977 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195c:	8b 40 08             	mov    0x8(%eax),%eax
  80195f:	85 c0                	test   %eax,%eax
  801961:	74 35                	je     801998 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	ff 75 10             	pushl  0x10(%ebp)
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	52                   	push   %edx
  80196d:	ff d0                	call   *%eax
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801975:	c9                   	leave  
  801976:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801977:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80197c:	8b 40 48             	mov    0x48(%eax),%eax
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	53                   	push   %ebx
  801983:	50                   	push   %eax
  801984:	68 f0 30 80 00       	push   $0x8030f0
  801989:	e8 c6 ed ff ff       	call   800754 <cprintf>
		return -E_INVAL;
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801996:	eb da                	jmp    801972 <read+0x5a>
		return -E_NOT_SUPP;
  801998:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199d:	eb d3                	jmp    801972 <read+0x5a>

0080199f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	57                   	push   %edi
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ab:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b3:	39 f3                	cmp    %esi,%ebx
  8019b5:	73 23                	jae    8019da <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	89 f0                	mov    %esi,%eax
  8019bc:	29 d8                	sub    %ebx,%eax
  8019be:	50                   	push   %eax
  8019bf:	89 d8                	mov    %ebx,%eax
  8019c1:	03 45 0c             	add    0xc(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	57                   	push   %edi
  8019c6:	e8 4d ff ff ff       	call   801918 <read>
		if (m < 0)
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 06                	js     8019d8 <readn+0x39>
			return m;
		if (m == 0)
  8019d2:	74 06                	je     8019da <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019d4:	01 c3                	add    %eax,%ebx
  8019d6:	eb db                	jmp    8019b3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019d8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019da:	89 d8                	mov    %ebx,%eax
  8019dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 1c             	sub    $0x1c,%esp
  8019eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	53                   	push   %ebx
  8019f3:	e8 b0 fc ff ff       	call   8016a8 <fd_lookup>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 3a                	js     801a39 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a05:	50                   	push   %eax
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	ff 30                	pushl  (%eax)
  801a0b:	e8 e8 fc ff ff       	call   8016f8 <dev_lookup>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 22                	js     801a39 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a1e:	74 1e                	je     801a3e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a23:	8b 52 0c             	mov    0xc(%edx),%edx
  801a26:	85 d2                	test   %edx,%edx
  801a28:	74 35                	je     801a5f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	ff d2                	call   *%edx
  801a36:	83 c4 10             	add    $0x10,%esp
}
  801a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3e:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801a43:	8b 40 48             	mov    0x48(%eax),%eax
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	53                   	push   %ebx
  801a4a:	50                   	push   %eax
  801a4b:	68 0c 31 80 00       	push   $0x80310c
  801a50:	e8 ff ec ff ff       	call   800754 <cprintf>
		return -E_INVAL;
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5d:	eb da                	jmp    801a39 <write+0x55>
		return -E_NOT_SUPP;
  801a5f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a64:	eb d3                	jmp    801a39 <write+0x55>

00801a66 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6f:	50                   	push   %eax
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 30 fc ff ff       	call   8016a8 <fd_lookup>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 0e                	js     801a8d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	53                   	push   %ebx
  801a93:	83 ec 1c             	sub    $0x1c,%esp
  801a96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a99:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9c:	50                   	push   %eax
  801a9d:	53                   	push   %ebx
  801a9e:	e8 05 fc ff ff       	call   8016a8 <fd_lookup>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 37                	js     801ae1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab0:	50                   	push   %eax
  801ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab4:	ff 30                	pushl  (%eax)
  801ab6:	e8 3d fc ff ff       	call   8016f8 <dev_lookup>
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 1f                	js     801ae1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ac9:	74 1b                	je     801ae6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ace:	8b 52 18             	mov    0x18(%edx),%edx
  801ad1:	85 d2                	test   %edx,%edx
  801ad3:	74 32                	je     801b07 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ad5:	83 ec 08             	sub    $0x8,%esp
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	ff d2                	call   *%edx
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ae6:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aeb:	8b 40 48             	mov    0x48(%eax),%eax
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	53                   	push   %ebx
  801af2:	50                   	push   %eax
  801af3:	68 cc 30 80 00       	push   $0x8030cc
  801af8:	e8 57 ec ff ff       	call   800754 <cprintf>
		return -E_INVAL;
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b05:	eb da                	jmp    801ae1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0c:	eb d3                	jmp    801ae1 <ftruncate+0x52>

00801b0e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	53                   	push   %ebx
  801b12:	83 ec 1c             	sub    $0x1c,%esp
  801b15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 84 fb ff ff       	call   8016a8 <fd_lookup>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 4b                	js     801b76 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b31:	50                   	push   %eax
  801b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b35:	ff 30                	pushl  (%eax)
  801b37:	e8 bc fb ff ff       	call   8016f8 <dev_lookup>
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 33                	js     801b76 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b4a:	74 2f                	je     801b7b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b4c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b4f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b56:	00 00 00 
	stat->st_isdir = 0;
  801b59:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b60:	00 00 00 
	stat->st_dev = dev;
  801b63:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	53                   	push   %ebx
  801b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801b70:	ff 50 14             	call   *0x14(%eax)
  801b73:	83 c4 10             	add    $0x10,%esp
}
  801b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    
		return -E_NOT_SUPP;
  801b7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b80:	eb f4                	jmp    801b76 <fstat+0x68>

00801b82 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	56                   	push   %esi
  801b86:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	e8 22 02 00 00       	call   801db6 <open>
  801b94:	89 c3                	mov    %eax,%ebx
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 1b                	js     801bb8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b9d:	83 ec 08             	sub    $0x8,%esp
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	50                   	push   %eax
  801ba4:	e8 65 ff ff ff       	call   801b0e <fstat>
  801ba9:	89 c6                	mov    %eax,%esi
	close(fd);
  801bab:	89 1c 24             	mov    %ebx,(%esp)
  801bae:	e8 27 fc ff ff       	call   8017da <close>
	return r;
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	89 f3                	mov    %esi,%ebx
}
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5e                   	pop    %esi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    

00801bc1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	89 c6                	mov    %eax,%esi
  801bc8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bca:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801bd1:	74 27                	je     801bfa <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bd3:	6a 07                	push   $0x7
  801bd5:	68 00 60 80 00       	push   $0x806000
  801bda:	56                   	push   %esi
  801bdb:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801be1:	e8 08 0c 00 00       	call   8027ee <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801be6:	83 c4 0c             	add    $0xc,%esp
  801be9:	6a 00                	push   $0x0
  801beb:	53                   	push   %ebx
  801bec:	6a 00                	push   $0x0
  801bee:	e8 92 0b 00 00       	call   802785 <ipc_recv>
}
  801bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5e                   	pop    %esi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	6a 01                	push   $0x1
  801bff:	e8 42 0c 00 00       	call   802846 <ipc_find_env>
  801c04:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	eb c5                	jmp    801bd3 <fsipc+0x12>

00801c0e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c22:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c27:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2c:	b8 02 00 00 00       	mov    $0x2,%eax
  801c31:	e8 8b ff ff ff       	call   801bc1 <fsipc>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <devfile_flush>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8b 40 0c             	mov    0xc(%eax),%eax
  801c44:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c49:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4e:	b8 06 00 00 00       	mov    $0x6,%eax
  801c53:	e8 69 ff ff ff       	call   801bc1 <fsipc>
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <devfile_stat>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c74:	b8 05 00 00 00       	mov    $0x5,%eax
  801c79:	e8 43 ff ff ff       	call   801bc1 <fsipc>
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 2c                	js     801cae <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	68 00 60 80 00       	push   $0x806000
  801c8a:	53                   	push   %ebx
  801c8b:	e8 23 f2 ff ff       	call   800eb3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c90:	a1 80 60 80 00       	mov    0x806080,%eax
  801c95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c9b:	a1 84 60 80 00       	mov    0x806084,%eax
  801ca0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <devfile_write>:
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 08             	sub    $0x8,%esp
  801cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cc8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cce:	53                   	push   %ebx
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	68 08 60 80 00       	push   $0x806008
  801cd7:	e8 c7 f3 ff ff       	call   8010a3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce1:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce6:	e8 d6 fe ff ff       	call   801bc1 <fsipc>
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 0b                	js     801cfd <devfile_write+0x4a>
	assert(r <= n);
  801cf2:	39 d8                	cmp    %ebx,%eax
  801cf4:	77 0c                	ja     801d02 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cf6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cfb:	7f 1e                	jg     801d1b <devfile_write+0x68>
}
  801cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    
	assert(r <= n);
  801d02:	68 40 31 80 00       	push   $0x803140
  801d07:	68 47 31 80 00       	push   $0x803147
  801d0c:	68 98 00 00 00       	push   $0x98
  801d11:	68 5c 31 80 00       	push   $0x80315c
  801d16:	e8 43 e9 ff ff       	call   80065e <_panic>
	assert(r <= PGSIZE);
  801d1b:	68 67 31 80 00       	push   $0x803167
  801d20:	68 47 31 80 00       	push   $0x803147
  801d25:	68 99 00 00 00       	push   $0x99
  801d2a:	68 5c 31 80 00       	push   $0x80315c
  801d2f:	e8 2a e9 ff ff       	call   80065e <_panic>

00801d34 <devfile_read>:
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d42:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d47:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d52:	b8 03 00 00 00       	mov    $0x3,%eax
  801d57:	e8 65 fe ff ff       	call   801bc1 <fsipc>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 1f                	js     801d81 <devfile_read+0x4d>
	assert(r <= n);
  801d62:	39 f0                	cmp    %esi,%eax
  801d64:	77 24                	ja     801d8a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6b:	7f 33                	jg     801da0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	50                   	push   %eax
  801d71:	68 00 60 80 00       	push   $0x806000
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	e8 c3 f2 ff ff       	call   801041 <memmove>
	return r;
  801d7e:	83 c4 10             	add    $0x10,%esp
}
  801d81:	89 d8                	mov    %ebx,%eax
  801d83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5e                   	pop    %esi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
	assert(r <= n);
  801d8a:	68 40 31 80 00       	push   $0x803140
  801d8f:	68 47 31 80 00       	push   $0x803147
  801d94:	6a 7c                	push   $0x7c
  801d96:	68 5c 31 80 00       	push   $0x80315c
  801d9b:	e8 be e8 ff ff       	call   80065e <_panic>
	assert(r <= PGSIZE);
  801da0:	68 67 31 80 00       	push   $0x803167
  801da5:	68 47 31 80 00       	push   $0x803147
  801daa:	6a 7d                	push   $0x7d
  801dac:	68 5c 31 80 00       	push   $0x80315c
  801db1:	e8 a8 e8 ff ff       	call   80065e <_panic>

00801db6 <open>:
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	83 ec 1c             	sub    $0x1c,%esp
  801dbe:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dc1:	56                   	push   %esi
  801dc2:	e8 b3 f0 ff ff       	call   800e7a <strlen>
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dcf:	7f 6c                	jg     801e3d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd7:	50                   	push   %eax
  801dd8:	e8 79 f8 ff ff       	call   801656 <fd_alloc>
  801ddd:	89 c3                	mov    %eax,%ebx
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 3c                	js     801e22 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801de6:	83 ec 08             	sub    $0x8,%esp
  801de9:	56                   	push   %esi
  801dea:	68 00 60 80 00       	push   $0x806000
  801def:	e8 bf f0 ff ff       	call   800eb3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
  801e04:	e8 b8 fd ff ff       	call   801bc1 <fsipc>
  801e09:	89 c3                	mov    %eax,%ebx
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 19                	js     801e2b <open+0x75>
	return fd2num(fd);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 f4             	pushl  -0xc(%ebp)
  801e18:	e8 12 f8 ff ff       	call   80162f <fd2num>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	83 c4 10             	add    $0x10,%esp
}
  801e22:	89 d8                	mov    %ebx,%eax
  801e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    
		fd_close(fd, 0);
  801e2b:	83 ec 08             	sub    $0x8,%esp
  801e2e:	6a 00                	push   $0x0
  801e30:	ff 75 f4             	pushl  -0xc(%ebp)
  801e33:	e8 1b f9 ff ff       	call   801753 <fd_close>
		return r;
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	eb e5                	jmp    801e22 <open+0x6c>
		return -E_BAD_PATH;
  801e3d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e42:	eb de                	jmp    801e22 <open+0x6c>

00801e44 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	b8 08 00 00 00       	mov    $0x8,%eax
  801e54:	e8 68 fd ff ff       	call   801bc1 <fsipc>
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e61:	68 73 31 80 00       	push   $0x803173
  801e66:	ff 75 0c             	pushl  0xc(%ebp)
  801e69:	e8 45 f0 ff ff       	call   800eb3 <strcpy>
	return 0;
}
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <devsock_close>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	53                   	push   %ebx
  801e79:	83 ec 10             	sub    $0x10,%esp
  801e7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e7f:	53                   	push   %ebx
  801e80:	e8 00 0a 00 00       	call   802885 <pageref>
  801e85:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e88:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e8d:	83 f8 01             	cmp    $0x1,%eax
  801e90:	74 07                	je     801e99 <devsock_close+0x24>
}
  801e92:	89 d0                	mov    %edx,%eax
  801e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	ff 73 0c             	pushl  0xc(%ebx)
  801e9f:	e8 b9 02 00 00       	call   80215d <nsipc_close>
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	eb e7                	jmp    801e92 <devsock_close+0x1d>

00801eab <devsock_write>:
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 10             	pushl  0x10(%ebp)
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	ff 70 0c             	pushl  0xc(%eax)
  801ebf:	e8 76 03 00 00       	call   80223a <nsipc_send>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <devsock_read>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 10             	pushl  0x10(%ebp)
  801ed1:	ff 75 0c             	pushl  0xc(%ebp)
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	ff 70 0c             	pushl  0xc(%eax)
  801eda:	e8 ef 02 00 00       	call   8021ce <nsipc_recv>
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <fd2sockid>:
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	e8 b7 f7 ff ff       	call   8016a8 <fd_lookup>
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	78 10                	js     801f08 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f01:	39 08                	cmp    %ecx,(%eax)
  801f03:	75 05                	jne    801f0a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    
		return -E_NOT_SUPP;
  801f0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f0f:	eb f7                	jmp    801f08 <fd2sockid+0x27>

00801f11 <alloc_sockfd>:
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
  801f16:	83 ec 1c             	sub    $0x1c,%esp
  801f19:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	e8 32 f7 ff ff       	call   801656 <fd_alloc>
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 43                	js     801f70 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	68 07 04 00 00       	push   $0x407
  801f35:	ff 75 f4             	pushl  -0xc(%ebp)
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 66 f3 ff ff       	call   8012a5 <sys_page_alloc>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 28                	js     801f70 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f51:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f5d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	50                   	push   %eax
  801f64:	e8 c6 f6 ff ff       	call   80162f <fd2num>
  801f69:	89 c3                	mov    %eax,%ebx
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	eb 0c                	jmp    801f7c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	56                   	push   %esi
  801f74:	e8 e4 01 00 00       	call   80215d <nsipc_close>
		return r;
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <accept>:
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	e8 4e ff ff ff       	call   801ee1 <fd2sockid>
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 1b                	js     801fb2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	ff 75 10             	pushl  0x10(%ebp)
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	50                   	push   %eax
  801fa1:	e8 0e 01 00 00       	call   8020b4 <nsipc_accept>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 05                	js     801fb2 <accept+0x2d>
	return alloc_sockfd(r);
  801fad:	e8 5f ff ff ff       	call   801f11 <alloc_sockfd>
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <bind>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	e8 1f ff ff ff       	call   801ee1 <fd2sockid>
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 12                	js     801fd8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	ff 75 10             	pushl  0x10(%ebp)
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	50                   	push   %eax
  801fd0:	e8 31 01 00 00       	call   802106 <nsipc_bind>
  801fd5:	83 c4 10             	add    $0x10,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <shutdown>:
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	e8 f9 fe ff ff       	call   801ee1 <fd2sockid>
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 0f                	js     801ffb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fec:	83 ec 08             	sub    $0x8,%esp
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	50                   	push   %eax
  801ff3:	e8 43 01 00 00       	call   80213b <nsipc_shutdown>
  801ff8:	83 c4 10             	add    $0x10,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <connect>:
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	e8 d6 fe ff ff       	call   801ee1 <fd2sockid>
  80200b:	85 c0                	test   %eax,%eax
  80200d:	78 12                	js     802021 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	ff 75 10             	pushl  0x10(%ebp)
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	50                   	push   %eax
  802019:	e8 59 01 00 00       	call   802177 <nsipc_connect>
  80201e:	83 c4 10             	add    $0x10,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <listen>:
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	e8 b0 fe ff ff       	call   801ee1 <fd2sockid>
  802031:	85 c0                	test   %eax,%eax
  802033:	78 0f                	js     802044 <listen+0x21>
	return nsipc_listen(r, backlog);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	ff 75 0c             	pushl  0xc(%ebp)
  80203b:	50                   	push   %eax
  80203c:	e8 6b 01 00 00       	call   8021ac <nsipc_listen>
  802041:	83 c4 10             	add    $0x10,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <socket>:

int
socket(int domain, int type, int protocol)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204c:	ff 75 10             	pushl  0x10(%ebp)
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	ff 75 08             	pushl  0x8(%ebp)
  802055:	e8 3e 02 00 00       	call   802298 <nsipc_socket>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	85 c0                	test   %eax,%eax
  80205f:	78 05                	js     802066 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802061:	e8 ab fe ff ff       	call   801f11 <alloc_sockfd>
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	53                   	push   %ebx
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802071:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  802078:	74 26                	je     8020a0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80207a:	6a 07                	push   $0x7
  80207c:	68 00 70 80 00       	push   $0x807000
  802081:	53                   	push   %ebx
  802082:	ff 35 b0 50 80 00    	pushl  0x8050b0
  802088:	e8 61 07 00 00       	call   8027ee <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80208d:	83 c4 0c             	add    $0xc,%esp
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	e8 ea 06 00 00       	call   802785 <ipc_recv>
}
  80209b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	6a 02                	push   $0x2
  8020a5:	e8 9c 07 00 00       	call   802846 <ipc_find_env>
  8020aa:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	eb c6                	jmp    80207a <nsipc+0x12>

008020b4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	56                   	push   %esi
  8020b8:	53                   	push   %ebx
  8020b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020c4:	8b 06                	mov    (%esi),%eax
  8020c6:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d0:	e8 93 ff ff ff       	call   802068 <nsipc>
  8020d5:	89 c3                	mov    %eax,%ebx
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	79 09                	jns    8020e4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	ff 35 10 70 80 00    	pushl  0x807010
  8020ed:	68 00 70 80 00       	push   $0x807000
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	e8 47 ef ff ff       	call   801041 <memmove>
		*addrlen = ret->ret_addrlen;
  8020fa:	a1 10 70 80 00       	mov    0x807010,%eax
  8020ff:	89 06                	mov    %eax,(%esi)
  802101:	83 c4 10             	add    $0x10,%esp
	return r;
  802104:	eb d5                	jmp    8020db <nsipc_accept+0x27>

00802106 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	53                   	push   %ebx
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802118:	53                   	push   %ebx
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	68 04 70 80 00       	push   $0x807004
  802121:	e8 1b ef ff ff       	call   801041 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802126:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80212c:	b8 02 00 00 00       	mov    $0x2,%eax
  802131:	e8 32 ff ff ff       	call   802068 <nsipc>
}
  802136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802151:	b8 03 00 00 00       	mov    $0x3,%eax
  802156:	e8 0d ff ff ff       	call   802068 <nsipc>
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <nsipc_close>:

int
nsipc_close(int s)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80216b:	b8 04 00 00 00       	mov    $0x4,%eax
  802170:	e8 f3 fe ff ff       	call   802068 <nsipc>
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	53                   	push   %ebx
  80217b:	83 ec 08             	sub    $0x8,%esp
  80217e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802189:	53                   	push   %ebx
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	68 04 70 80 00       	push   $0x807004
  802192:	e8 aa ee ff ff       	call   801041 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802197:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80219d:	b8 05 00 00 00       	mov    $0x5,%eax
  8021a2:	e8 c1 fe ff ff       	call   802068 <nsipc>
}
  8021a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8021c7:	e8 9c fe ff ff       	call   802068 <nsipc>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
  8021d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f1:	e8 72 fe ff ff       	call   802068 <nsipc>
  8021f6:	89 c3                	mov    %eax,%ebx
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	78 1f                	js     80221b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021fc:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802201:	7f 21                	jg     802224 <nsipc_recv+0x56>
  802203:	39 c6                	cmp    %eax,%esi
  802205:	7c 1d                	jl     802224 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	50                   	push   %eax
  80220b:	68 00 70 80 00       	push   $0x807000
  802210:	ff 75 0c             	pushl  0xc(%ebp)
  802213:	e8 29 ee ff ff       	call   801041 <memmove>
  802218:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80221b:	89 d8                	mov    %ebx,%eax
  80221d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802224:	68 7f 31 80 00       	push   $0x80317f
  802229:	68 47 31 80 00       	push   $0x803147
  80222e:	6a 62                	push   $0x62
  802230:	68 94 31 80 00       	push   $0x803194
  802235:	e8 24 e4 ff ff       	call   80065e <_panic>

0080223a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	53                   	push   %ebx
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80224c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802252:	7f 2e                	jg     802282 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	53                   	push   %ebx
  802258:	ff 75 0c             	pushl  0xc(%ebp)
  80225b:	68 0c 70 80 00       	push   $0x80700c
  802260:	e8 dc ed ff ff       	call   801041 <memmove>
	nsipcbuf.send.req_size = size;
  802265:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80226b:	8b 45 14             	mov    0x14(%ebp),%eax
  80226e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802273:	b8 08 00 00 00       	mov    $0x8,%eax
  802278:	e8 eb fd ff ff       	call   802068 <nsipc>
}
  80227d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802280:	c9                   	leave  
  802281:	c3                   	ret    
	assert(size < 1600);
  802282:	68 a0 31 80 00       	push   $0x8031a0
  802287:	68 47 31 80 00       	push   $0x803147
  80228c:	6a 6d                	push   $0x6d
  80228e:	68 94 31 80 00       	push   $0x803194
  802293:	e8 c6 e3 ff ff       	call   80065e <_panic>

00802298 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022b6:	b8 09 00 00 00       	mov    $0x9,%eax
  8022bb:	e8 a8 fd ff ff       	call   802068 <nsipc>
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	56                   	push   %esi
  8022c6:	53                   	push   %ebx
  8022c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	ff 75 08             	pushl  0x8(%ebp)
  8022d0:	e8 6a f3 ff ff       	call   80163f <fd2data>
  8022d5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022d7:	83 c4 08             	add    $0x8,%esp
  8022da:	68 ac 31 80 00       	push   $0x8031ac
  8022df:	53                   	push   %ebx
  8022e0:	e8 ce eb ff ff       	call   800eb3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022e5:	8b 46 04             	mov    0x4(%esi),%eax
  8022e8:	2b 06                	sub    (%esi),%eax
  8022ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022f7:	00 00 00 
	stat->st_dev = &devpipe;
  8022fa:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802301:	40 80 00 
	return 0;
}
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
  802309:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    

00802310 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	53                   	push   %ebx
  802314:	83 ec 0c             	sub    $0xc,%esp
  802317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80231a:	53                   	push   %ebx
  80231b:	6a 00                	push   $0x0
  80231d:	e8 08 f0 ff ff       	call   80132a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802322:	89 1c 24             	mov    %ebx,(%esp)
  802325:	e8 15 f3 ff ff       	call   80163f <fd2data>
  80232a:	83 c4 08             	add    $0x8,%esp
  80232d:	50                   	push   %eax
  80232e:	6a 00                	push   $0x0
  802330:	e8 f5 ef ff ff       	call   80132a <sys_page_unmap>
}
  802335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <_pipeisclosed>:
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	57                   	push   %edi
  80233e:	56                   	push   %esi
  80233f:	53                   	push   %ebx
  802340:	83 ec 1c             	sub    $0x1c,%esp
  802343:	89 c7                	mov    %eax,%edi
  802345:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802347:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80234c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	57                   	push   %edi
  802353:	e8 2d 05 00 00       	call   802885 <pageref>
  802358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80235b:	89 34 24             	mov    %esi,(%esp)
  80235e:	e8 22 05 00 00       	call   802885 <pageref>
		nn = thisenv->env_runs;
  802363:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  802369:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80236c:	83 c4 10             	add    $0x10,%esp
  80236f:	39 cb                	cmp    %ecx,%ebx
  802371:	74 1b                	je     80238e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802373:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802376:	75 cf                	jne    802347 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802378:	8b 42 58             	mov    0x58(%edx),%eax
  80237b:	6a 01                	push   $0x1
  80237d:	50                   	push   %eax
  80237e:	53                   	push   %ebx
  80237f:	68 b3 31 80 00       	push   $0x8031b3
  802384:	e8 cb e3 ff ff       	call   800754 <cprintf>
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	eb b9                	jmp    802347 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80238e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802391:	0f 94 c0             	sete   %al
  802394:	0f b6 c0             	movzbl %al,%eax
}
  802397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5f                   	pop    %edi
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <devpipe_write>:
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	57                   	push   %edi
  8023a3:	56                   	push   %esi
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 28             	sub    $0x28,%esp
  8023a8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023ab:	56                   	push   %esi
  8023ac:	e8 8e f2 ff ff       	call   80163f <fd2data>
  8023b1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023be:	74 4f                	je     80240f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023c0:	8b 43 04             	mov    0x4(%ebx),%eax
  8023c3:	8b 0b                	mov    (%ebx),%ecx
  8023c5:	8d 51 20             	lea    0x20(%ecx),%edx
  8023c8:	39 d0                	cmp    %edx,%eax
  8023ca:	72 14                	jb     8023e0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023cc:	89 da                	mov    %ebx,%edx
  8023ce:	89 f0                	mov    %esi,%eax
  8023d0:	e8 65 ff ff ff       	call   80233a <_pipeisclosed>
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	75 3b                	jne    802414 <devpipe_write+0x75>
			sys_yield();
  8023d9:	e8 a8 ee ff ff       	call   801286 <sys_yield>
  8023de:	eb e0                	jmp    8023c0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023e7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023ea:	89 c2                	mov    %eax,%edx
  8023ec:	c1 fa 1f             	sar    $0x1f,%edx
  8023ef:	89 d1                	mov    %edx,%ecx
  8023f1:	c1 e9 1b             	shr    $0x1b,%ecx
  8023f4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023f7:	83 e2 1f             	and    $0x1f,%edx
  8023fa:	29 ca                	sub    %ecx,%edx
  8023fc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802400:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802404:	83 c0 01             	add    $0x1,%eax
  802407:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80240a:	83 c7 01             	add    $0x1,%edi
  80240d:	eb ac                	jmp    8023bb <devpipe_write+0x1c>
	return i;
  80240f:	8b 45 10             	mov    0x10(%ebp),%eax
  802412:	eb 05                	jmp    802419 <devpipe_write+0x7a>
				return 0;
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802419:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <devpipe_read>:
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	57                   	push   %edi
  802425:	56                   	push   %esi
  802426:	53                   	push   %ebx
  802427:	83 ec 18             	sub    $0x18,%esp
  80242a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80242d:	57                   	push   %edi
  80242e:	e8 0c f2 ff ff       	call   80163f <fd2data>
  802433:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	be 00 00 00 00       	mov    $0x0,%esi
  80243d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802440:	75 14                	jne    802456 <devpipe_read+0x35>
	return i;
  802442:	8b 45 10             	mov    0x10(%ebp),%eax
  802445:	eb 02                	jmp    802449 <devpipe_read+0x28>
				return i;
  802447:	89 f0                	mov    %esi,%eax
}
  802449:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
			sys_yield();
  802451:	e8 30 ee ff ff       	call   801286 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802456:	8b 03                	mov    (%ebx),%eax
  802458:	3b 43 04             	cmp    0x4(%ebx),%eax
  80245b:	75 18                	jne    802475 <devpipe_read+0x54>
			if (i > 0)
  80245d:	85 f6                	test   %esi,%esi
  80245f:	75 e6                	jne    802447 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802461:	89 da                	mov    %ebx,%edx
  802463:	89 f8                	mov    %edi,%eax
  802465:	e8 d0 fe ff ff       	call   80233a <_pipeisclosed>
  80246a:	85 c0                	test   %eax,%eax
  80246c:	74 e3                	je     802451 <devpipe_read+0x30>
				return 0;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	eb d4                	jmp    802449 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802475:	99                   	cltd   
  802476:	c1 ea 1b             	shr    $0x1b,%edx
  802479:	01 d0                	add    %edx,%eax
  80247b:	83 e0 1f             	and    $0x1f,%eax
  80247e:	29 d0                	sub    %edx,%eax
  802480:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802488:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80248b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80248e:	83 c6 01             	add    $0x1,%esi
  802491:	eb aa                	jmp    80243d <devpipe_read+0x1c>

00802493 <pipe>:
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80249b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249e:	50                   	push   %eax
  80249f:	e8 b2 f1 ff ff       	call   801656 <fd_alloc>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	0f 88 23 01 00 00    	js     8025d4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024b1:	83 ec 04             	sub    $0x4,%esp
  8024b4:	68 07 04 00 00       	push   $0x407
  8024b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024bc:	6a 00                	push   $0x0
  8024be:	e8 e2 ed ff ff       	call   8012a5 <sys_page_alloc>
  8024c3:	89 c3                	mov    %eax,%ebx
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	0f 88 04 01 00 00    	js     8025d4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024d6:	50                   	push   %eax
  8024d7:	e8 7a f1 ff ff       	call   801656 <fd_alloc>
  8024dc:	89 c3                	mov    %eax,%ebx
  8024de:	83 c4 10             	add    $0x10,%esp
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	0f 88 db 00 00 00    	js     8025c4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	68 07 04 00 00       	push   $0x407
  8024f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f4:	6a 00                	push   $0x0
  8024f6:	e8 aa ed ff ff       	call   8012a5 <sys_page_alloc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	85 c0                	test   %eax,%eax
  802502:	0f 88 bc 00 00 00    	js     8025c4 <pipe+0x131>
	va = fd2data(fd0);
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	ff 75 f4             	pushl  -0xc(%ebp)
  80250e:	e8 2c f1 ff ff       	call   80163f <fd2data>
  802513:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802515:	83 c4 0c             	add    $0xc,%esp
  802518:	68 07 04 00 00       	push   $0x407
  80251d:	50                   	push   %eax
  80251e:	6a 00                	push   $0x0
  802520:	e8 80 ed ff ff       	call   8012a5 <sys_page_alloc>
  802525:	89 c3                	mov    %eax,%ebx
  802527:	83 c4 10             	add    $0x10,%esp
  80252a:	85 c0                	test   %eax,%eax
  80252c:	0f 88 82 00 00 00    	js     8025b4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	ff 75 f0             	pushl  -0x10(%ebp)
  802538:	e8 02 f1 ff ff       	call   80163f <fd2data>
  80253d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802544:	50                   	push   %eax
  802545:	6a 00                	push   $0x0
  802547:	56                   	push   %esi
  802548:	6a 00                	push   $0x0
  80254a:	e8 99 ed ff ff       	call   8012e8 <sys_page_map>
  80254f:	89 c3                	mov    %eax,%ebx
  802551:	83 c4 20             	add    $0x20,%esp
  802554:	85 c0                	test   %eax,%eax
  802556:	78 4e                	js     8025a6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802558:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802560:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802565:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80256c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80257b:	83 ec 0c             	sub    $0xc,%esp
  80257e:	ff 75 f4             	pushl  -0xc(%ebp)
  802581:	e8 a9 f0 ff ff       	call   80162f <fd2num>
  802586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802589:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80258b:	83 c4 04             	add    $0x4,%esp
  80258e:	ff 75 f0             	pushl  -0x10(%ebp)
  802591:	e8 99 f0 ff ff       	call   80162f <fd2num>
  802596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802599:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025a4:	eb 2e                	jmp    8025d4 <pipe+0x141>
	sys_page_unmap(0, va);
  8025a6:	83 ec 08             	sub    $0x8,%esp
  8025a9:	56                   	push   %esi
  8025aa:	6a 00                	push   $0x0
  8025ac:	e8 79 ed ff ff       	call   80132a <sys_page_unmap>
  8025b1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025b4:	83 ec 08             	sub    $0x8,%esp
  8025b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ba:	6a 00                	push   $0x0
  8025bc:	e8 69 ed ff ff       	call   80132a <sys_page_unmap>
  8025c1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025c4:	83 ec 08             	sub    $0x8,%esp
  8025c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ca:	6a 00                	push   $0x0
  8025cc:	e8 59 ed ff ff       	call   80132a <sys_page_unmap>
  8025d1:	83 c4 10             	add    $0x10,%esp
}
  8025d4:	89 d8                	mov    %ebx,%eax
  8025d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    

008025dd <pipeisclosed>:
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
  8025e0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e6:	50                   	push   %eax
  8025e7:	ff 75 08             	pushl  0x8(%ebp)
  8025ea:	e8 b9 f0 ff ff       	call   8016a8 <fd_lookup>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	78 18                	js     80260e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fc:	e8 3e f0 ff ff       	call   80163f <fd2data>
	return _pipeisclosed(fd, p);
  802601:	89 c2                	mov    %eax,%edx
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	e8 2f fd ff ff       	call   80233a <_pipeisclosed>
  80260b:	83 c4 10             	add    $0x10,%esp
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	c3                   	ret    

00802616 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80261c:	68 cb 31 80 00       	push   $0x8031cb
  802621:	ff 75 0c             	pushl  0xc(%ebp)
  802624:	e8 8a e8 ff ff       	call   800eb3 <strcpy>
	return 0;
}
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <devcons_write>:
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	57                   	push   %edi
  802634:	56                   	push   %esi
  802635:	53                   	push   %ebx
  802636:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80263c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802641:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802647:	3b 75 10             	cmp    0x10(%ebp),%esi
  80264a:	73 31                	jae    80267d <devcons_write+0x4d>
		m = n - tot;
  80264c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80264f:	29 f3                	sub    %esi,%ebx
  802651:	83 fb 7f             	cmp    $0x7f,%ebx
  802654:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802659:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	53                   	push   %ebx
  802660:	89 f0                	mov    %esi,%eax
  802662:	03 45 0c             	add    0xc(%ebp),%eax
  802665:	50                   	push   %eax
  802666:	57                   	push   %edi
  802667:	e8 d5 e9 ff ff       	call   801041 <memmove>
		sys_cputs(buf, m);
  80266c:	83 c4 08             	add    $0x8,%esp
  80266f:	53                   	push   %ebx
  802670:	57                   	push   %edi
  802671:	e8 73 eb ff ff       	call   8011e9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802676:	01 de                	add    %ebx,%esi
  802678:	83 c4 10             	add    $0x10,%esp
  80267b:	eb ca                	jmp    802647 <devcons_write+0x17>
}
  80267d:	89 f0                	mov    %esi,%eax
  80267f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802682:	5b                   	pop    %ebx
  802683:	5e                   	pop    %esi
  802684:	5f                   	pop    %edi
  802685:	5d                   	pop    %ebp
  802686:	c3                   	ret    

00802687 <devcons_read>:
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 08             	sub    $0x8,%esp
  80268d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802692:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802696:	74 21                	je     8026b9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802698:	e8 6a eb ff ff       	call   801207 <sys_cgetc>
  80269d:	85 c0                	test   %eax,%eax
  80269f:	75 07                	jne    8026a8 <devcons_read+0x21>
		sys_yield();
  8026a1:	e8 e0 eb ff ff       	call   801286 <sys_yield>
  8026a6:	eb f0                	jmp    802698 <devcons_read+0x11>
	if (c < 0)
  8026a8:	78 0f                	js     8026b9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026aa:	83 f8 04             	cmp    $0x4,%eax
  8026ad:	74 0c                	je     8026bb <devcons_read+0x34>
	*(char*)vbuf = c;
  8026af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b2:	88 02                	mov    %al,(%edx)
	return 1;
  8026b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    
		return 0;
  8026bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c0:	eb f7                	jmp    8026b9 <devcons_read+0x32>

008026c2 <cputchar>:
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026ce:	6a 01                	push   $0x1
  8026d0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d3:	50                   	push   %eax
  8026d4:	e8 10 eb ff ff       	call   8011e9 <sys_cputs>
}
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <getchar>:
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026e4:	6a 01                	push   $0x1
  8026e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026e9:	50                   	push   %eax
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 27 f2 ff ff       	call   801918 <read>
	if (r < 0)
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	78 06                	js     8026fe <getchar+0x20>
	if (r < 1)
  8026f8:	74 06                	je     802700 <getchar+0x22>
	return c;
  8026fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    
		return -E_EOF;
  802700:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802705:	eb f7                	jmp    8026fe <getchar+0x20>

00802707 <iscons>:
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80270d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802710:	50                   	push   %eax
  802711:	ff 75 08             	pushl  0x8(%ebp)
  802714:	e8 8f ef ff ff       	call   8016a8 <fd_lookup>
  802719:	83 c4 10             	add    $0x10,%esp
  80271c:	85 c0                	test   %eax,%eax
  80271e:	78 11                	js     802731 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802729:	39 10                	cmp    %edx,(%eax)
  80272b:	0f 94 c0             	sete   %al
  80272e:	0f b6 c0             	movzbl %al,%eax
}
  802731:	c9                   	leave  
  802732:	c3                   	ret    

00802733 <opencons>:
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273c:	50                   	push   %eax
  80273d:	e8 14 ef ff ff       	call   801656 <fd_alloc>
  802742:	83 c4 10             	add    $0x10,%esp
  802745:	85 c0                	test   %eax,%eax
  802747:	78 3a                	js     802783 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 07 04 00 00       	push   $0x407
  802751:	ff 75 f4             	pushl  -0xc(%ebp)
  802754:	6a 00                	push   $0x0
  802756:	e8 4a eb ff ff       	call   8012a5 <sys_page_alloc>
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	85 c0                	test   %eax,%eax
  802760:	78 21                	js     802783 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80276b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	50                   	push   %eax
  80277b:	e8 af ee ff ff       	call   80162f <fd2num>
  802780:	83 c4 10             	add    $0x10,%esp
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	56                   	push   %esi
  802789:	53                   	push   %ebx
  80278a:	8b 75 08             	mov    0x8(%ebp),%esi
  80278d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802790:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802793:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802795:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80279a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	50                   	push   %eax
  8027a1:	e8 af ec ff ff       	call   801455 <sys_ipc_recv>
	if(ret < 0){
  8027a6:	83 c4 10             	add    $0x10,%esp
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	78 2b                	js     8027d8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027ad:	85 f6                	test   %esi,%esi
  8027af:	74 0a                	je     8027bb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8027b1:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027b6:	8b 40 78             	mov    0x78(%eax),%eax
  8027b9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027bb:	85 db                	test   %ebx,%ebx
  8027bd:	74 0a                	je     8027c9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8027bf:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027c4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8027c7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8027c9:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027ce:	8b 40 74             	mov    0x74(%eax),%eax
}
  8027d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    
		if(from_env_store)
  8027d8:	85 f6                	test   %esi,%esi
  8027da:	74 06                	je     8027e2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027dc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027e2:	85 db                	test   %ebx,%ebx
  8027e4:	74 eb                	je     8027d1 <ipc_recv+0x4c>
			*perm_store = 0;
  8027e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027ec:	eb e3                	jmp    8027d1 <ipc_recv+0x4c>

008027ee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	57                   	push   %edi
  8027f2:	56                   	push   %esi
  8027f3:	53                   	push   %ebx
  8027f4:	83 ec 0c             	sub    $0xc,%esp
  8027f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802800:	85 db                	test   %ebx,%ebx
  802802:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802807:	0f 44 d8             	cmove  %eax,%ebx
  80280a:	eb 05                	jmp    802811 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80280c:	e8 75 ea ff ff       	call   801286 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802811:	ff 75 14             	pushl  0x14(%ebp)
  802814:	53                   	push   %ebx
  802815:	56                   	push   %esi
  802816:	57                   	push   %edi
  802817:	e8 16 ec ff ff       	call   801432 <sys_ipc_try_send>
  80281c:	83 c4 10             	add    $0x10,%esp
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 1b                	je     80283e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802823:	79 e7                	jns    80280c <ipc_send+0x1e>
  802825:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802828:	74 e2                	je     80280c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 d7 31 80 00       	push   $0x8031d7
  802832:	6a 46                	push   $0x46
  802834:	68 ec 31 80 00       	push   $0x8031ec
  802839:	e8 20 de ff ff       	call   80065e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80283e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    

00802846 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802851:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802857:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80285d:	8b 52 50             	mov    0x50(%edx),%edx
  802860:	39 ca                	cmp    %ecx,%edx
  802862:	74 11                	je     802875 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802864:	83 c0 01             	add    $0x1,%eax
  802867:	3d 00 04 00 00       	cmp    $0x400,%eax
  80286c:	75 e3                	jne    802851 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
  802873:	eb 0e                	jmp    802883 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802875:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80287b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802880:	8b 40 48             	mov    0x48(%eax),%eax
}
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    

00802885 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80288b:	89 d0                	mov    %edx,%eax
  80288d:	c1 e8 16             	shr    $0x16,%eax
  802890:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80289c:	f6 c1 01             	test   $0x1,%cl
  80289f:	74 1d                	je     8028be <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028a1:	c1 ea 0c             	shr    $0xc,%edx
  8028a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028ab:	f6 c2 01             	test   $0x1,%dl
  8028ae:	74 0e                	je     8028be <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028b0:	c1 ea 0c             	shr    $0xc,%edx
  8028b3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028ba:	ef 
  8028bb:	0f b7 c0             	movzwl %ax,%eax
}
  8028be:	5d                   	pop    %ebp
  8028bf:	c3                   	ret    

008028c0 <__udivdi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028d7:	85 d2                	test   %edx,%edx
  8028d9:	75 4d                	jne    802928 <__udivdi3+0x68>
  8028db:	39 f3                	cmp    %esi,%ebx
  8028dd:	76 19                	jbe    8028f8 <__udivdi3+0x38>
  8028df:	31 ff                	xor    %edi,%edi
  8028e1:	89 e8                	mov    %ebp,%eax
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	f7 f3                	div    %ebx
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 d9                	mov    %ebx,%ecx
  8028fa:	85 db                	test   %ebx,%ebx
  8028fc:	75 0b                	jne    802909 <__udivdi3+0x49>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 c1                	mov    %eax,%ecx
  802909:	31 d2                	xor    %edx,%edx
  80290b:	89 f0                	mov    %esi,%eax
  80290d:	f7 f1                	div    %ecx
  80290f:	89 c6                	mov    %eax,%esi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f7                	mov    %esi,%edi
  802915:	f7 f1                	div    %ecx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	39 f2                	cmp    %esi,%edx
  80292a:	77 1c                	ja     802948 <__udivdi3+0x88>
  80292c:	0f bd fa             	bsr    %edx,%edi
  80292f:	83 f7 1f             	xor    $0x1f,%edi
  802932:	75 2c                	jne    802960 <__udivdi3+0xa0>
  802934:	39 f2                	cmp    %esi,%edx
  802936:	72 06                	jb     80293e <__udivdi3+0x7e>
  802938:	31 c0                	xor    %eax,%eax
  80293a:	39 eb                	cmp    %ebp,%ebx
  80293c:	77 a9                	ja     8028e7 <__udivdi3+0x27>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	eb a2                	jmp    8028e7 <__udivdi3+0x27>
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	31 ff                	xor    %edi,%edi
  80294a:	31 c0                	xor    %eax,%eax
  80294c:	89 fa                	mov    %edi,%edx
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	89 f9                	mov    %edi,%ecx
  802962:	b8 20 00 00 00       	mov    $0x20,%eax
  802967:	29 f8                	sub    %edi,%eax
  802969:	d3 e2                	shl    %cl,%edx
  80296b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80296f:	89 c1                	mov    %eax,%ecx
  802971:	89 da                	mov    %ebx,%edx
  802973:	d3 ea                	shr    %cl,%edx
  802975:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802979:	09 d1                	or     %edx,%ecx
  80297b:	89 f2                	mov    %esi,%edx
  80297d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802981:	89 f9                	mov    %edi,%ecx
  802983:	d3 e3                	shl    %cl,%ebx
  802985:	89 c1                	mov    %eax,%ecx
  802987:	d3 ea                	shr    %cl,%edx
  802989:	89 f9                	mov    %edi,%ecx
  80298b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80298f:	89 eb                	mov    %ebp,%ebx
  802991:	d3 e6                	shl    %cl,%esi
  802993:	89 c1                	mov    %eax,%ecx
  802995:	d3 eb                	shr    %cl,%ebx
  802997:	09 de                	or     %ebx,%esi
  802999:	89 f0                	mov    %esi,%eax
  80299b:	f7 74 24 08          	divl   0x8(%esp)
  80299f:	89 d6                	mov    %edx,%esi
  8029a1:	89 c3                	mov    %eax,%ebx
  8029a3:	f7 64 24 0c          	mull   0xc(%esp)
  8029a7:	39 d6                	cmp    %edx,%esi
  8029a9:	72 15                	jb     8029c0 <__udivdi3+0x100>
  8029ab:	89 f9                	mov    %edi,%ecx
  8029ad:	d3 e5                	shl    %cl,%ebp
  8029af:	39 c5                	cmp    %eax,%ebp
  8029b1:	73 04                	jae    8029b7 <__udivdi3+0xf7>
  8029b3:	39 d6                	cmp    %edx,%esi
  8029b5:	74 09                	je     8029c0 <__udivdi3+0x100>
  8029b7:	89 d8                	mov    %ebx,%eax
  8029b9:	31 ff                	xor    %edi,%edi
  8029bb:	e9 27 ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029c3:	31 ff                	xor    %edi,%edi
  8029c5:	e9 1d ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__umoddi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029e7:	89 da                	mov    %ebx,%edx
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 43                	jne    802a30 <__umoddi3+0x60>
  8029ed:	39 df                	cmp    %ebx,%edi
  8029ef:	76 17                	jbe    802a08 <__umoddi3+0x38>
  8029f1:	89 f0                	mov    %esi,%eax
  8029f3:	f7 f7                	div    %edi
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	31 d2                	xor    %edx,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 fd                	mov    %edi,%ebp
  802a0a:	85 ff                	test   %edi,%edi
  802a0c:	75 0b                	jne    802a19 <__umoddi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f7                	div    %edi
  802a17:	89 c5                	mov    %eax,%ebp
  802a19:	89 d8                	mov    %ebx,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f5                	div    %ebp
  802a1f:	89 f0                	mov    %esi,%eax
  802a21:	f7 f5                	div    %ebp
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	eb d0                	jmp    8029f7 <__umoddi3+0x27>
  802a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2e:	66 90                	xchg   %ax,%ax
  802a30:	89 f1                	mov    %esi,%ecx
  802a32:	39 d8                	cmp    %ebx,%eax
  802a34:	76 0a                	jbe    802a40 <__umoddi3+0x70>
  802a36:	89 f0                	mov    %esi,%eax
  802a38:	83 c4 1c             	add    $0x1c,%esp
  802a3b:	5b                   	pop    %ebx
  802a3c:	5e                   	pop    %esi
  802a3d:	5f                   	pop    %edi
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
  802a40:	0f bd e8             	bsr    %eax,%ebp
  802a43:	83 f5 1f             	xor    $0x1f,%ebp
  802a46:	75 20                	jne    802a68 <__umoddi3+0x98>
  802a48:	39 d8                	cmp    %ebx,%eax
  802a4a:	0f 82 b0 00 00 00    	jb     802b00 <__umoddi3+0x130>
  802a50:	39 f7                	cmp    %esi,%edi
  802a52:	0f 86 a8 00 00 00    	jbe    802b00 <__umoddi3+0x130>
  802a58:	89 c8                	mov    %ecx,%eax
  802a5a:	83 c4 1c             	add    $0x1c,%esp
  802a5d:	5b                   	pop    %ebx
  802a5e:	5e                   	pop    %esi
  802a5f:	5f                   	pop    %edi
  802a60:	5d                   	pop    %ebp
  802a61:	c3                   	ret    
  802a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a68:	89 e9                	mov    %ebp,%ecx
  802a6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a6f:	29 ea                	sub    %ebp,%edx
  802a71:	d3 e0                	shl    %cl,%eax
  802a73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a77:	89 d1                	mov    %edx,%ecx
  802a79:	89 f8                	mov    %edi,%eax
  802a7b:	d3 e8                	shr    %cl,%eax
  802a7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a89:	09 c1                	or     %eax,%ecx
  802a8b:	89 d8                	mov    %ebx,%eax
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 e9                	mov    %ebp,%ecx
  802a93:	d3 e7                	shl    %cl,%edi
  802a95:	89 d1                	mov    %edx,%ecx
  802a97:	d3 e8                	shr    %cl,%eax
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a9f:	d3 e3                	shl    %cl,%ebx
  802aa1:	89 c7                	mov    %eax,%edi
  802aa3:	89 d1                	mov    %edx,%ecx
  802aa5:	89 f0                	mov    %esi,%eax
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 fa                	mov    %edi,%edx
  802aad:	d3 e6                	shl    %cl,%esi
  802aaf:	09 d8                	or     %ebx,%eax
  802ab1:	f7 74 24 08          	divl   0x8(%esp)
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	89 f3                	mov    %esi,%ebx
  802ab9:	f7 64 24 0c          	mull   0xc(%esp)
  802abd:	89 c6                	mov    %eax,%esi
  802abf:	89 d7                	mov    %edx,%edi
  802ac1:	39 d1                	cmp    %edx,%ecx
  802ac3:	72 06                	jb     802acb <__umoddi3+0xfb>
  802ac5:	75 10                	jne    802ad7 <__umoddi3+0x107>
  802ac7:	39 c3                	cmp    %eax,%ebx
  802ac9:	73 0c                	jae    802ad7 <__umoddi3+0x107>
  802acb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802acf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ad3:	89 d7                	mov    %edx,%edi
  802ad5:	89 c6                	mov    %eax,%esi
  802ad7:	89 ca                	mov    %ecx,%edx
  802ad9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ade:	29 f3                	sub    %esi,%ebx
  802ae0:	19 fa                	sbb    %edi,%edx
  802ae2:	89 d0                	mov    %edx,%eax
  802ae4:	d3 e0                	shl    %cl,%eax
  802ae6:	89 e9                	mov    %ebp,%ecx
  802ae8:	d3 eb                	shr    %cl,%ebx
  802aea:	d3 ea                	shr    %cl,%edx
  802aec:	09 d8                	or     %ebx,%eax
  802aee:	83 c4 1c             	add    $0x1c,%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
  802af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afd:	8d 76 00             	lea    0x0(%esi),%esi
  802b00:	89 da                	mov    %ebx,%edx
  802b02:	29 fe                	sub    %edi,%esi
  802b04:	19 c2                	sbb    %eax,%edx
  802b06:	89 f1                	mov    %esi,%ecx
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	e9 4b ff ff ff       	jmp    802a5a <__umoddi3+0x8a>
