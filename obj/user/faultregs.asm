
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
  800044:	68 b0 2c 80 00       	push   $0x802cb0
  800049:	68 80 2b 80 00       	push   $0x802b80
  80004e:	e8 91 07 00 00       	call   8007e4 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 90 2b 80 00       	push   $0x802b90
  80005c:	68 94 2b 80 00       	push   $0x802b94
  800061:	e8 7e 07 00 00       	call   8007e4 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a8 2b 80 00       	push   $0x802ba8
  80007b:	e8 64 07 00 00       	call   8007e4 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 b2 2b 80 00       	push   $0x802bb2
  800093:	68 94 2b 80 00       	push   $0x802b94
  800098:	e8 47 07 00 00       	call   8007e4 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 a8 2b 80 00       	push   $0x802ba8
  8000b4:	e8 2b 07 00 00       	call   8007e4 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 b6 2b 80 00       	push   $0x802bb6
  8000cc:	68 94 2b 80 00       	push   $0x802b94
  8000d1:	e8 0e 07 00 00       	call   8007e4 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 a8 2b 80 00       	push   $0x802ba8
  8000ed:	e8 f2 06 00 00       	call   8007e4 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 ba 2b 80 00       	push   $0x802bba
  800105:	68 94 2b 80 00       	push   $0x802b94
  80010a:	e8 d5 06 00 00       	call   8007e4 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 a8 2b 80 00       	push   $0x802ba8
  800126:	e8 b9 06 00 00       	call   8007e4 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 be 2b 80 00       	push   $0x802bbe
  80013e:	68 94 2b 80 00       	push   $0x802b94
  800143:	e8 9c 06 00 00       	call   8007e4 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 a8 2b 80 00       	push   $0x802ba8
  80015f:	e8 80 06 00 00       	call   8007e4 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 c2 2b 80 00       	push   $0x802bc2
  800177:	68 94 2b 80 00       	push   $0x802b94
  80017c:	e8 63 06 00 00       	call   8007e4 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 a8 2b 80 00       	push   $0x802ba8
  800198:	e8 47 06 00 00       	call   8007e4 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 c6 2b 80 00       	push   $0x802bc6
  8001b0:	68 94 2b 80 00       	push   $0x802b94
  8001b5:	e8 2a 06 00 00       	call   8007e4 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 a8 2b 80 00       	push   $0x802ba8
  8001d1:	e8 0e 06 00 00       	call   8007e4 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ca 2b 80 00       	push   $0x802bca
  8001e9:	68 94 2b 80 00       	push   $0x802b94
  8001ee:	e8 f1 05 00 00       	call   8007e4 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 a8 2b 80 00       	push   $0x802ba8
  80020a:	e8 d5 05 00 00       	call   8007e4 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ce 2b 80 00       	push   $0x802bce
  800222:	68 94 2b 80 00       	push   $0x802b94
  800227:	e8 b8 05 00 00       	call   8007e4 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 a8 2b 80 00       	push   $0x802ba8
  800243:	e8 9c 05 00 00       	call   8007e4 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 d5 2b 80 00       	push   $0x802bd5
  800253:	68 94 2b 80 00       	push   $0x802b94
  800258:	e8 87 05 00 00       	call   8007e4 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 a8 2b 80 00       	push   $0x802ba8
  800274:	e8 6b 05 00 00       	call   8007e4 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 d9 2b 80 00       	push   $0x802bd9
  800284:	e8 5b 05 00 00       	call   8007e4 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 a8 2b 80 00       	push   $0x802ba8
  800294:	e8 4b 05 00 00       	call   8007e4 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 a4 2b 80 00       	push   $0x802ba4
  8002a9:	e8 36 05 00 00       	call   8007e4 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 a4 2b 80 00       	push   $0x802ba4
  8002c3:	e8 1c 05 00 00       	call   8007e4 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 a4 2b 80 00       	push   $0x802ba4
  8002d8:	e8 07 05 00 00       	call   8007e4 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 a4 2b 80 00       	push   $0x802ba4
  8002ed:	e8 f2 04 00 00       	call   8007e4 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 a4 2b 80 00       	push   $0x802ba4
  800302:	e8 dd 04 00 00       	call   8007e4 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 a4 2b 80 00       	push   $0x802ba4
  800317:	e8 c8 04 00 00       	call   8007e4 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 a4 2b 80 00       	push   $0x802ba4
  80032c:	e8 b3 04 00 00       	call   8007e4 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 a4 2b 80 00       	push   $0x802ba4
  800341:	e8 9e 04 00 00       	call   8007e4 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 a4 2b 80 00       	push   $0x802ba4
  800356:	e8 89 04 00 00       	call   8007e4 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 d5 2b 80 00       	push   $0x802bd5
  800366:	68 94 2b 80 00       	push   $0x802b94
  80036b:	e8 74 04 00 00       	call   8007e4 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 a4 2b 80 00       	push   $0x802ba4
  800387:	e8 58 04 00 00       	call   8007e4 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 d9 2b 80 00       	push   $0x802bd9
  800397:	e8 48 04 00 00       	call   8007e4 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 a4 2b 80 00       	push   $0x802ba4
  8003af:	e8 30 04 00 00       	call   8007e4 <cprintf>
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
  8003c2:	68 a4 2b 80 00       	push   $0x802ba4
  8003c7:	e8 18 04 00 00       	call   8007e4 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 d9 2b 80 00       	push   $0x802bd9
  8003d7:	e8 08 04 00 00       	call   8007e4 <cprintf>
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
  800466:	68 ff 2b 80 00       	push   $0x802bff
  80046b:	68 0d 2c 80 00       	push   $0x802c0d
  800470:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800475:	ba f8 2b 80 00       	mov    $0x802bf8,%edx
  80047a:	b8 80 50 80 00       	mov    $0x805080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 a0 0e 00 00       	call   801335 <sys_page_alloc>
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
  8004a5:	68 40 2c 80 00       	push   $0x802c40
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 e7 2b 80 00       	push   $0x802be7
  8004b1:	e8 38 02 00 00       	call   8006ee <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 14 2c 80 00       	push   $0x802c14
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 e7 2b 80 00       	push   $0x802be7
  8004c3:	e8 26 02 00 00       	call   8006ee <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 32 11 00 00       	call   80160a <set_pgfault_handler>

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
  8005ac:	68 27 2c 80 00       	push   $0x802c27
  8005b1:	68 38 2c 80 00       	push   $0x802c38
  8005b6:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005bb:	ba f8 2b 80 00       	mov    $0x802bf8,%edx
  8005c0:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 74 2c 80 00       	push   $0x802c74
  8005d7:	e8 08 02 00 00       	call   8007e4 <cprintf>
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
  8005ea:	c7 05 b4 50 80 00 00 	movl   $0x0,0x8050b4
  8005f1:	00 00 00 
	envid_t find = sys_getenvid();
  8005f4:	e8 fe 0c 00 00       	call   8012f7 <sys_getenvid>
  8005f9:	8b 1d b4 50 80 00    	mov    0x8050b4,%ebx
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
  800642:	89 1d b4 50 80 00    	mov    %ebx,0x8050b4
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800648:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80064c:	7e 0a                	jle    800658 <libmain+0x77>
		binaryname = argv[0];
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800658:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80065d:	8b 40 48             	mov    0x48(%eax),%eax
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	50                   	push   %eax
  800664:	68 93 2c 80 00       	push   $0x802c93
  800669:	e8 76 01 00 00       	call   8007e4 <cprintf>
	cprintf("before umain\n");
  80066e:	c7 04 24 b1 2c 80 00 	movl   $0x802cb1,(%esp)
  800675:	e8 6a 01 00 00       	call   8007e4 <cprintf>
	// call user main routine
	umain(argc, argv);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 08             	pushl  0x8(%ebp)
  800683:	e8 40 fe ff ff       	call   8004c8 <umain>
	cprintf("after umain\n");
  800688:	c7 04 24 bf 2c 80 00 	movl   $0x802cbf,(%esp)
  80068f:	e8 50 01 00 00       	call   8007e4 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800694:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  800699:	8b 40 48             	mov    0x48(%eax),%eax
  80069c:	83 c4 08             	add    $0x8,%esp
  80069f:	50                   	push   %eax
  8006a0:	68 cc 2c 80 00       	push   $0x802ccc
  8006a5:	e8 3a 01 00 00       	call   8007e4 <cprintf>
	// exit gracefully
	exit();
  8006aa:	e8 0b 00 00 00       	call   8006ba <exit>
}
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b5:	5b                   	pop    %ebx
  8006b6:	5e                   	pop    %esi
  8006b7:	5f                   	pop    %edi
  8006b8:	5d                   	pop    %ebp
  8006b9:	c3                   	ret    

008006ba <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
  8006bd:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006c0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8006c5:	8b 40 48             	mov    0x48(%eax),%eax
  8006c8:	68 f8 2c 80 00       	push   $0x802cf8
  8006cd:	50                   	push   %eax
  8006ce:	68 eb 2c 80 00       	push   $0x802ceb
  8006d3:	e8 0c 01 00 00       	call   8007e4 <cprintf>
	close_all();
  8006d8:	e8 9a 11 00 00       	call   801877 <close_all>
	sys_env_destroy(0);
  8006dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006e4:	e8 cd 0b 00 00       	call   8012b6 <sys_env_destroy>
}
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	56                   	push   %esi
  8006f2:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006f3:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8006f8:	8b 40 48             	mov    0x48(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	68 24 2d 80 00       	push   $0x802d24
  800703:	50                   	push   %eax
  800704:	68 eb 2c 80 00       	push   $0x802ceb
  800709:	e8 d6 00 00 00       	call   8007e4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80070e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800711:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800717:	e8 db 0b 00 00       	call   8012f7 <sys_getenvid>
  80071c:	83 c4 04             	add    $0x4,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	ff 75 08             	pushl  0x8(%ebp)
  800725:	56                   	push   %esi
  800726:	50                   	push   %eax
  800727:	68 00 2d 80 00       	push   $0x802d00
  80072c:	e8 b3 00 00 00       	call   8007e4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800731:	83 c4 18             	add    $0x18,%esp
  800734:	53                   	push   %ebx
  800735:	ff 75 10             	pushl  0x10(%ebp)
  800738:	e8 56 00 00 00       	call   800793 <vcprintf>
	cprintf("\n");
  80073d:	c7 04 24 af 2c 80 00 	movl   $0x802caf,(%esp)
  800744:	e8 9b 00 00 00       	call   8007e4 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80074c:	cc                   	int3   
  80074d:	eb fd                	jmp    80074c <_panic+0x5e>

0080074f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	53                   	push   %ebx
  800753:	83 ec 04             	sub    $0x4,%esp
  800756:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800759:	8b 13                	mov    (%ebx),%edx
  80075b:	8d 42 01             	lea    0x1(%edx),%eax
  80075e:	89 03                	mov    %eax,(%ebx)
  800760:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800763:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800767:	3d ff 00 00 00       	cmp    $0xff,%eax
  80076c:	74 09                	je     800777 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80076e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800775:	c9                   	leave  
  800776:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	68 ff 00 00 00       	push   $0xff
  80077f:	8d 43 08             	lea    0x8(%ebx),%eax
  800782:	50                   	push   %eax
  800783:	e8 f1 0a 00 00       	call   801279 <sys_cputs>
		b->idx = 0;
  800788:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	eb db                	jmp    80076e <putch+0x1f>

00800793 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 4f 07 80 00       	push   $0x80074f
  8007c2:	e8 4a 01 00 00       	call   800911 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007c7:	83 c4 08             	add    $0x8,%esp
  8007ca:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007d0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	e8 9d 0a 00 00       	call   801279 <sys_cputs>

	return b.cnt;
}
  8007dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ea:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 08             	pushl  0x8(%ebp)
  8007f1:	e8 9d ff ff ff       	call   800793 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	57                   	push   %edi
  8007fc:	56                   	push   %esi
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 1c             	sub    $0x1c,%esp
  800801:	89 c6                	mov    %eax,%esi
  800803:	89 d7                	mov    %edx,%edi
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80080e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800817:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80081b:	74 2c                	je     800849 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80081d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800820:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800827:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80082a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80082d:	39 c2                	cmp    %eax,%edx
  80082f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800832:	73 43                	jae    800877 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800834:	83 eb 01             	sub    $0x1,%ebx
  800837:	85 db                	test   %ebx,%ebx
  800839:	7e 6c                	jle    8008a7 <printnum+0xaf>
				putch(padc, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	57                   	push   %edi
  80083f:	ff 75 18             	pushl  0x18(%ebp)
  800842:	ff d6                	call   *%esi
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	eb eb                	jmp    800834 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	6a 20                	push   $0x20
  80084e:	6a 00                	push   $0x0
  800850:	50                   	push   %eax
  800851:	ff 75 e4             	pushl  -0x1c(%ebp)
  800854:	ff 75 e0             	pushl  -0x20(%ebp)
  800857:	89 fa                	mov    %edi,%edx
  800859:	89 f0                	mov    %esi,%eax
  80085b:	e8 98 ff ff ff       	call   8007f8 <printnum>
		while (--width > 0)
  800860:	83 c4 20             	add    $0x20,%esp
  800863:	83 eb 01             	sub    $0x1,%ebx
  800866:	85 db                	test   %ebx,%ebx
  800868:	7e 65                	jle    8008cf <printnum+0xd7>
			putch(padc, putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	57                   	push   %edi
  80086e:	6a 20                	push   $0x20
  800870:	ff d6                	call   *%esi
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	eb ec                	jmp    800863 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800877:	83 ec 0c             	sub    $0xc,%esp
  80087a:	ff 75 18             	pushl  0x18(%ebp)
  80087d:	83 eb 01             	sub    $0x1,%ebx
  800880:	53                   	push   %ebx
  800881:	50                   	push   %eax
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 dc             	pushl  -0x24(%ebp)
  800888:	ff 75 d8             	pushl  -0x28(%ebp)
  80088b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088e:	ff 75 e0             	pushl  -0x20(%ebp)
  800891:	e8 9a 20 00 00       	call   802930 <__udivdi3>
  800896:	83 c4 18             	add    $0x18,%esp
  800899:	52                   	push   %edx
  80089a:	50                   	push   %eax
  80089b:	89 fa                	mov    %edi,%edx
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	e8 54 ff ff ff       	call   8007f8 <printnum>
  8008a4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	57                   	push   %edi
  8008ab:	83 ec 04             	sub    $0x4,%esp
  8008ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8008b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8008b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ba:	e8 81 21 00 00       	call   802a40 <__umoddi3>
  8008bf:	83 c4 14             	add    $0x14,%esp
  8008c2:	0f be 80 2b 2d 80 00 	movsbl 0x802d2b(%eax),%eax
  8008c9:	50                   	push   %eax
  8008ca:	ff d6                	call   *%esi
  8008cc:	83 c4 10             	add    $0x10,%esp
	}
}
  8008cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5e                   	pop    %esi
  8008d4:	5f                   	pop    %edi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008dd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e1:	8b 10                	mov    (%eax),%edx
  8008e3:	3b 50 04             	cmp    0x4(%eax),%edx
  8008e6:	73 0a                	jae    8008f2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8008e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008eb:	89 08                	mov    %ecx,(%eax)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	88 02                	mov    %al,(%edx)
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <printfmt>:
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008fa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008fd:	50                   	push   %eax
  8008fe:	ff 75 10             	pushl  0x10(%ebp)
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 05 00 00 00       	call   800911 <vprintfmt>
}
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <vprintfmt>:
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	57                   	push   %edi
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	83 ec 3c             	sub    $0x3c,%esp
  80091a:	8b 75 08             	mov    0x8(%ebp),%esi
  80091d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800920:	8b 7d 10             	mov    0x10(%ebp),%edi
  800923:	e9 32 04 00 00       	jmp    800d5a <vprintfmt+0x449>
		padc = ' ';
  800928:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80092c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800933:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80093a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800941:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800948:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80094f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800954:	8d 47 01             	lea    0x1(%edi),%eax
  800957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80095a:	0f b6 17             	movzbl (%edi),%edx
  80095d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800960:	3c 55                	cmp    $0x55,%al
  800962:	0f 87 12 05 00 00    	ja     800e7a <vprintfmt+0x569>
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	ff 24 85 00 2f 80 00 	jmp    *0x802f00(,%eax,4)
  800972:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800975:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800979:	eb d9                	jmp    800954 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80097e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800982:	eb d0                	jmp    800954 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800984:	0f b6 d2             	movzbl %dl,%edx
  800987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80098a:	b8 00 00 00 00       	mov    $0x0,%eax
  80098f:	89 75 08             	mov    %esi,0x8(%ebp)
  800992:	eb 03                	jmp    800997 <vprintfmt+0x86>
  800994:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800997:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80099a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80099e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009a1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009a4:	83 fe 09             	cmp    $0x9,%esi
  8009a7:	76 eb                	jbe    800994 <vprintfmt+0x83>
  8009a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8009af:	eb 14                	jmp    8009c5 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8009b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	8d 40 04             	lea    0x4(%eax),%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8009c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c9:	79 89                	jns    800954 <vprintfmt+0x43>
				width = precision, precision = -1;
  8009cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009d1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8009d8:	e9 77 ff ff ff       	jmp    800954 <vprintfmt+0x43>
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	0f 48 c1             	cmovs  %ecx,%eax
  8009e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009eb:	e9 64 ff ff ff       	jmp    800954 <vprintfmt+0x43>
  8009f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009f3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8009fa:	e9 55 ff ff ff       	jmp    800954 <vprintfmt+0x43>
			lflag++;
  8009ff:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a03:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a06:	e9 49 ff ff ff       	jmp    800954 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8d 78 04             	lea    0x4(%eax),%edi
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	53                   	push   %ebx
  800a15:	ff 30                	pushl  (%eax)
  800a17:	ff d6                	call   *%esi
			break;
  800a19:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a1c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a1f:	e9 33 03 00 00       	jmp    800d57 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	8d 78 04             	lea    0x4(%eax),%edi
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	99                   	cltd   
  800a2d:	31 d0                	xor    %edx,%eax
  800a2f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a31:	83 f8 11             	cmp    $0x11,%eax
  800a34:	7f 23                	jg     800a59 <vprintfmt+0x148>
  800a36:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  800a3d:	85 d2                	test   %edx,%edx
  800a3f:	74 18                	je     800a59 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800a41:	52                   	push   %edx
  800a42:	68 f9 31 80 00       	push   $0x8031f9
  800a47:	53                   	push   %ebx
  800a48:	56                   	push   %esi
  800a49:	e8 a6 fe ff ff       	call   8008f4 <printfmt>
  800a4e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a51:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a54:	e9 fe 02 00 00       	jmp    800d57 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a59:	50                   	push   %eax
  800a5a:	68 43 2d 80 00       	push   $0x802d43
  800a5f:	53                   	push   %ebx
  800a60:	56                   	push   %esi
  800a61:	e8 8e fe ff ff       	call   8008f4 <printfmt>
  800a66:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a69:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a6c:	e9 e6 02 00 00       	jmp    800d57 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a7f:	85 c9                	test   %ecx,%ecx
  800a81:	b8 3c 2d 80 00       	mov    $0x802d3c,%eax
  800a86:	0f 45 c1             	cmovne %ecx,%eax
  800a89:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a90:	7e 06                	jle    800a98 <vprintfmt+0x187>
  800a92:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a96:	75 0d                	jne    800aa5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a9b:	89 c7                	mov    %eax,%edi
  800a9d:	03 45 e0             	add    -0x20(%ebp),%eax
  800aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aa3:	eb 53                	jmp    800af8 <vprintfmt+0x1e7>
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 d8             	pushl  -0x28(%ebp)
  800aab:	50                   	push   %eax
  800aac:	e8 71 04 00 00       	call   800f22 <strnlen>
  800ab1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ab4:	29 c1                	sub    %eax,%ecx
  800ab6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800abe:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac5:	eb 0f                	jmp    800ad6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	53                   	push   %ebx
  800acb:	ff 75 e0             	pushl  -0x20(%ebp)
  800ace:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad0:	83 ef 01             	sub    $0x1,%edi
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	85 ff                	test   %edi,%edi
  800ad8:	7f ed                	jg     800ac7 <vprintfmt+0x1b6>
  800ada:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800add:	85 c9                	test   %ecx,%ecx
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	0f 49 c1             	cmovns %ecx,%eax
  800ae7:	29 c1                	sub    %eax,%ecx
  800ae9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800aec:	eb aa                	jmp    800a98 <vprintfmt+0x187>
					putch(ch, putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	53                   	push   %ebx
  800af2:	52                   	push   %edx
  800af3:	ff d6                	call   *%esi
  800af5:	83 c4 10             	add    $0x10,%esp
  800af8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800afb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afd:	83 c7 01             	add    $0x1,%edi
  800b00:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b04:	0f be d0             	movsbl %al,%edx
  800b07:	85 d2                	test   %edx,%edx
  800b09:	74 4b                	je     800b56 <vprintfmt+0x245>
  800b0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b0f:	78 06                	js     800b17 <vprintfmt+0x206>
  800b11:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b15:	78 1e                	js     800b35 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800b17:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800b1b:	74 d1                	je     800aee <vprintfmt+0x1dd>
  800b1d:	0f be c0             	movsbl %al,%eax
  800b20:	83 e8 20             	sub    $0x20,%eax
  800b23:	83 f8 5e             	cmp    $0x5e,%eax
  800b26:	76 c6                	jbe    800aee <vprintfmt+0x1dd>
					putch('?', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	53                   	push   %ebx
  800b2c:	6a 3f                	push   $0x3f
  800b2e:	ff d6                	call   *%esi
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	eb c3                	jmp    800af8 <vprintfmt+0x1e7>
  800b35:	89 cf                	mov    %ecx,%edi
  800b37:	eb 0e                	jmp    800b47 <vprintfmt+0x236>
				putch(' ', putdat);
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	53                   	push   %ebx
  800b3d:	6a 20                	push   $0x20
  800b3f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b41:	83 ef 01             	sub    $0x1,%edi
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	85 ff                	test   %edi,%edi
  800b49:	7f ee                	jg     800b39 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800b4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b51:	e9 01 02 00 00       	jmp    800d57 <vprintfmt+0x446>
  800b56:	89 cf                	mov    %ecx,%edi
  800b58:	eb ed                	jmp    800b47 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b5a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800b5d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800b64:	e9 eb fd ff ff       	jmp    800954 <vprintfmt+0x43>
	if (lflag >= 2)
  800b69:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b6d:	7f 21                	jg     800b90 <vprintfmt+0x27f>
	else if (lflag)
  800b6f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b73:	74 68                	je     800bdd <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800b75:	8b 45 14             	mov    0x14(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b7d:	89 c1                	mov    %eax,%ecx
  800b7f:	c1 f9 1f             	sar    $0x1f,%ecx
  800b82:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	8d 40 04             	lea    0x4(%eax),%eax
  800b8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8e:	eb 17                	jmp    800ba7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	8b 50 04             	mov    0x4(%eax),%edx
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b9b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	8d 40 08             	lea    0x8(%eax),%eax
  800ba4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800ba7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800baa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800bb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bb7:	78 3f                	js     800bf8 <vprintfmt+0x2e7>
			base = 10;
  800bb9:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800bbe:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800bc2:	0f 84 71 01 00 00    	je     800d39 <vprintfmt+0x428>
				putch('+', putdat);
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	53                   	push   %ebx
  800bcc:	6a 2b                	push   $0x2b
  800bce:	ff d6                	call   *%esi
  800bd0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd8:	e9 5c 01 00 00       	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	8b 00                	mov    (%eax),%eax
  800be2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800be5:	89 c1                	mov    %eax,%ecx
  800be7:	c1 f9 1f             	sar    $0x1f,%ecx
  800bea:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800bed:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf0:	8d 40 04             	lea    0x4(%eax),%eax
  800bf3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf6:	eb af                	jmp    800ba7 <vprintfmt+0x296>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	53                   	push   %ebx
  800bfc:	6a 2d                	push   $0x2d
  800bfe:	ff d6                	call   *%esi
				num = -(long long) num;
  800c00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c06:	f7 d8                	neg    %eax
  800c08:	83 d2 00             	adc    $0x0,%edx
  800c0b:	f7 da                	neg    %edx
  800c0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c10:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c13:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1b:	e9 19 01 00 00       	jmp    800d39 <vprintfmt+0x428>
	if (lflag >= 2)
  800c20:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c24:	7f 29                	jg     800c4f <vprintfmt+0x33e>
	else if (lflag)
  800c26:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c2a:	74 44                	je     800c70 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3f:	8d 40 04             	lea    0x4(%eax),%eax
  800c42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c4a:	e9 ea 00 00 00       	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8b 50 04             	mov    0x4(%eax),%edx
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c5a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	8d 40 08             	lea    0x8(%eax),%eax
  800c63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6b:	e9 c9 00 00 00       	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c80:	8b 45 14             	mov    0x14(%ebp),%eax
  800c83:	8d 40 04             	lea    0x4(%eax),%eax
  800c86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8e:	e9 a6 00 00 00       	jmp    800d39 <vprintfmt+0x428>
			putch('0', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	53                   	push   %ebx
  800c97:	6a 30                	push   $0x30
  800c99:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c9b:	83 c4 10             	add    $0x10,%esp
  800c9e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ca2:	7f 26                	jg     800cca <vprintfmt+0x3b9>
	else if (lflag)
  800ca4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800ca8:	74 3e                	je     800ce8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cb7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	8d 40 04             	lea    0x4(%eax),%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cc3:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc8:	eb 6f                	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800cca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccd:	8b 50 04             	mov    0x4(%eax),%edx
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdb:	8d 40 08             	lea    0x8(%eax),%eax
  800cde:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce6:	eb 51                	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cf5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	8d 40 04             	lea    0x4(%eax),%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d01:	b8 08 00 00 00       	mov    $0x8,%eax
  800d06:	eb 31                	jmp    800d39 <vprintfmt+0x428>
			putch('0', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	53                   	push   %ebx
  800d0c:	6a 30                	push   $0x30
  800d0e:	ff d6                	call   *%esi
			putch('x', putdat);
  800d10:	83 c4 08             	add    $0x8,%esp
  800d13:	53                   	push   %ebx
  800d14:	6a 78                	push   $0x78
  800d16:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d18:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d25:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d28:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	8d 40 04             	lea    0x4(%eax),%eax
  800d31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d34:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800d40:	52                   	push   %edx
  800d41:	ff 75 e0             	pushl  -0x20(%ebp)
  800d44:	50                   	push   %eax
  800d45:	ff 75 dc             	pushl  -0x24(%ebp)
  800d48:	ff 75 d8             	pushl  -0x28(%ebp)
  800d4b:	89 da                	mov    %ebx,%edx
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	e8 a4 fa ff ff       	call   8007f8 <printnum>
			break;
  800d54:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5a:	83 c7 01             	add    $0x1,%edi
  800d5d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d61:	83 f8 25             	cmp    $0x25,%eax
  800d64:	0f 84 be fb ff ff    	je     800928 <vprintfmt+0x17>
			if (ch == '\0')
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	0f 84 28 01 00 00    	je     800e9a <vprintfmt+0x589>
			putch(ch, putdat);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	53                   	push   %ebx
  800d76:	50                   	push   %eax
  800d77:	ff d6                	call   *%esi
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	eb dc                	jmp    800d5a <vprintfmt+0x449>
	if (lflag >= 2)
  800d7e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d82:	7f 26                	jg     800daa <vprintfmt+0x499>
	else if (lflag)
  800d84:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d88:	74 41                	je     800dcb <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d97:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	8d 40 04             	lea    0x4(%eax),%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800da3:	b8 10 00 00 00       	mov    $0x10,%eax
  800da8:	eb 8f                	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800daa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dad:	8b 50 04             	mov    0x4(%eax),%edx
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800db5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800db8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbb:	8d 40 08             	lea    0x8(%eax),%eax
  800dbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dc1:	b8 10 00 00 00       	mov    $0x10,%eax
  800dc6:	e9 6e ff ff ff       	jmp    800d39 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	8b 00                	mov    (%eax),%eax
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dd8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	8d 40 04             	lea    0x4(%eax),%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800de4:	b8 10 00 00 00       	mov    $0x10,%eax
  800de9:	e9 4b ff ff ff       	jmp    800d39 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800dee:	8b 45 14             	mov    0x14(%ebp),%eax
  800df1:	83 c0 04             	add    $0x4,%eax
  800df4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfa:	8b 00                	mov    (%eax),%eax
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	74 14                	je     800e14 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800e00:	8b 13                	mov    (%ebx),%edx
  800e02:	83 fa 7f             	cmp    $0x7f,%edx
  800e05:	7f 37                	jg     800e3e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800e07:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e0c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0f:	e9 43 ff ff ff       	jmp    800d57 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800e14:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e19:	bf 61 2e 80 00       	mov    $0x802e61,%edi
							putch(ch, putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	53                   	push   %ebx
  800e22:	50                   	push   %eax
  800e23:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e25:	83 c7 01             	add    $0x1,%edi
  800e28:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	75 eb                	jne    800e1e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800e33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e36:	89 45 14             	mov    %eax,0x14(%ebp)
  800e39:	e9 19 ff ff ff       	jmp    800d57 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800e3e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800e40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e45:	bf 99 2e 80 00       	mov    $0x802e99,%edi
							putch(ch, putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	53                   	push   %ebx
  800e4e:	50                   	push   %eax
  800e4f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e51:	83 c7 01             	add    $0x1,%edi
  800e54:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	75 eb                	jne    800e4a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800e5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e62:	89 45 14             	mov    %eax,0x14(%ebp)
  800e65:	e9 ed fe ff ff       	jmp    800d57 <vprintfmt+0x446>
			putch(ch, putdat);
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	53                   	push   %ebx
  800e6e:	6a 25                	push   $0x25
  800e70:	ff d6                	call   *%esi
			break;
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	e9 dd fe ff ff       	jmp    800d57 <vprintfmt+0x446>
			putch('%', putdat);
  800e7a:	83 ec 08             	sub    $0x8,%esp
  800e7d:	53                   	push   %ebx
  800e7e:	6a 25                	push   $0x25
  800e80:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	89 f8                	mov    %edi,%eax
  800e87:	eb 03                	jmp    800e8c <vprintfmt+0x57b>
  800e89:	83 e8 01             	sub    $0x1,%eax
  800e8c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e90:	75 f7                	jne    800e89 <vprintfmt+0x578>
  800e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e95:	e9 bd fe ff ff       	jmp    800d57 <vprintfmt+0x446>
}
  800e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 18             	sub    $0x18,%esp
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eb1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800eb5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	74 26                	je     800ee9 <vsnprintf+0x47>
  800ec3:	85 d2                	test   %edx,%edx
  800ec5:	7e 22                	jle    800ee9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec7:	ff 75 14             	pushl  0x14(%ebp)
  800eca:	ff 75 10             	pushl  0x10(%ebp)
  800ecd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	68 d7 08 80 00       	push   $0x8008d7
  800ed6:	e8 36 fa ff ff       	call   800911 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ede:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    
		return -E_INVAL;
  800ee9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eee:	eb f7                	jmp    800ee7 <vsnprintf+0x45>

00800ef0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ef9:	50                   	push   %eax
  800efa:	ff 75 10             	pushl  0x10(%ebp)
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	ff 75 08             	pushl  0x8(%ebp)
  800f03:	e8 9a ff ff ff       	call   800ea2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f10:	b8 00 00 00 00       	mov    $0x0,%eax
  800f15:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f19:	74 05                	je     800f20 <strlen+0x16>
		n++;
  800f1b:	83 c0 01             	add    $0x1,%eax
  800f1e:	eb f5                	jmp    800f15 <strlen+0xb>
	return n;
}
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f30:	39 c2                	cmp    %eax,%edx
  800f32:	74 0d                	je     800f41 <strnlen+0x1f>
  800f34:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800f38:	74 05                	je     800f3f <strnlen+0x1d>
		n++;
  800f3a:	83 c2 01             	add    $0x1,%edx
  800f3d:	eb f1                	jmp    800f30 <strnlen+0xe>
  800f3f:	89 d0                	mov    %edx,%eax
	return n;
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	53                   	push   %ebx
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f52:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f56:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f59:	83 c2 01             	add    $0x1,%edx
  800f5c:	84 c9                	test   %cl,%cl
  800f5e:	75 f2                	jne    800f52 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f60:	5b                   	pop    %ebx
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	53                   	push   %ebx
  800f67:	83 ec 10             	sub    $0x10,%esp
  800f6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f6d:	53                   	push   %ebx
  800f6e:	e8 97 ff ff ff       	call   800f0a <strlen>
  800f73:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	01 d8                	add    %ebx,%eax
  800f7b:	50                   	push   %eax
  800f7c:	e8 c2 ff ff ff       	call   800f43 <strcpy>
	return dst;
}
  800f81:	89 d8                	mov    %ebx,%eax
  800f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	89 c6                	mov    %eax,%esi
  800f95:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	39 f2                	cmp    %esi,%edx
  800f9c:	74 11                	je     800faf <strncpy+0x27>
		*dst++ = *src;
  800f9e:	83 c2 01             	add    $0x1,%edx
  800fa1:	0f b6 19             	movzbl (%ecx),%ebx
  800fa4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fa7:	80 fb 01             	cmp    $0x1,%bl
  800faa:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800fad:	eb eb                	jmp    800f9a <strncpy+0x12>
	}
	return ret;
}
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbe:	8b 55 10             	mov    0x10(%ebp),%edx
  800fc1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800fc3:	85 d2                	test   %edx,%edx
  800fc5:	74 21                	je     800fe8 <strlcpy+0x35>
  800fc7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800fcb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800fcd:	39 c2                	cmp    %eax,%edx
  800fcf:	74 14                	je     800fe5 <strlcpy+0x32>
  800fd1:	0f b6 19             	movzbl (%ecx),%ebx
  800fd4:	84 db                	test   %bl,%bl
  800fd6:	74 0b                	je     800fe3 <strlcpy+0x30>
			*dst++ = *src++;
  800fd8:	83 c1 01             	add    $0x1,%ecx
  800fdb:	83 c2 01             	add    $0x1,%edx
  800fde:	88 5a ff             	mov    %bl,-0x1(%edx)
  800fe1:	eb ea                	jmp    800fcd <strlcpy+0x1a>
  800fe3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800fe5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe8:	29 f0                	sub    %esi,%eax
}
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ff7:	0f b6 01             	movzbl (%ecx),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	74 0c                	je     80100a <strcmp+0x1c>
  800ffe:	3a 02                	cmp    (%edx),%al
  801000:	75 08                	jne    80100a <strcmp+0x1c>
		p++, q++;
  801002:	83 c1 01             	add    $0x1,%ecx
  801005:	83 c2 01             	add    $0x1,%edx
  801008:	eb ed                	jmp    800ff7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	0f b6 12             	movzbl (%edx),%edx
  801010:	29 d0                	sub    %edx,%eax
}
  801012:	5d                   	pop    %ebp
  801013:	c3                   	ret    

00801014 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	53                   	push   %ebx
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101e:	89 c3                	mov    %eax,%ebx
  801020:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801023:	eb 06                	jmp    80102b <strncmp+0x17>
		n--, p++, q++;
  801025:	83 c0 01             	add    $0x1,%eax
  801028:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80102b:	39 d8                	cmp    %ebx,%eax
  80102d:	74 16                	je     801045 <strncmp+0x31>
  80102f:	0f b6 08             	movzbl (%eax),%ecx
  801032:	84 c9                	test   %cl,%cl
  801034:	74 04                	je     80103a <strncmp+0x26>
  801036:	3a 0a                	cmp    (%edx),%cl
  801038:	74 eb                	je     801025 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80103a:	0f b6 00             	movzbl (%eax),%eax
  80103d:	0f b6 12             	movzbl (%edx),%edx
  801040:	29 d0                	sub    %edx,%eax
}
  801042:	5b                   	pop    %ebx
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    
		return 0;
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	eb f6                	jmp    801042 <strncmp+0x2e>

0080104c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801056:	0f b6 10             	movzbl (%eax),%edx
  801059:	84 d2                	test   %dl,%dl
  80105b:	74 09                	je     801066 <strchr+0x1a>
		if (*s == c)
  80105d:	38 ca                	cmp    %cl,%dl
  80105f:	74 0a                	je     80106b <strchr+0x1f>
	for (; *s; s++)
  801061:	83 c0 01             	add    $0x1,%eax
  801064:	eb f0                	jmp    801056 <strchr+0xa>
			return (char *) s;
	return 0;
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801077:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80107a:	38 ca                	cmp    %cl,%dl
  80107c:	74 09                	je     801087 <strfind+0x1a>
  80107e:	84 d2                	test   %dl,%dl
  801080:	74 05                	je     801087 <strfind+0x1a>
	for (; *s; s++)
  801082:	83 c0 01             	add    $0x1,%eax
  801085:	eb f0                	jmp    801077 <strfind+0xa>
			break;
	return (char *) s;
}
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	57                   	push   %edi
  80108d:	56                   	push   %esi
  80108e:	53                   	push   %ebx
  80108f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801092:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801095:	85 c9                	test   %ecx,%ecx
  801097:	74 31                	je     8010ca <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801099:	89 f8                	mov    %edi,%eax
  80109b:	09 c8                	or     %ecx,%eax
  80109d:	a8 03                	test   $0x3,%al
  80109f:	75 23                	jne    8010c4 <memset+0x3b>
		c &= 0xFF;
  8010a1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010a5:	89 d3                	mov    %edx,%ebx
  8010a7:	c1 e3 08             	shl    $0x8,%ebx
  8010aa:	89 d0                	mov    %edx,%eax
  8010ac:	c1 e0 18             	shl    $0x18,%eax
  8010af:	89 d6                	mov    %edx,%esi
  8010b1:	c1 e6 10             	shl    $0x10,%esi
  8010b4:	09 f0                	or     %esi,%eax
  8010b6:	09 c2                	or     %eax,%edx
  8010b8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010ba:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8010bd:	89 d0                	mov    %edx,%eax
  8010bf:	fc                   	cld    
  8010c0:	f3 ab                	rep stos %eax,%es:(%edi)
  8010c2:	eb 06                	jmp    8010ca <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	fc                   	cld    
  8010c8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8010ca:	89 f8                	mov    %edi,%eax
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	57                   	push   %edi
  8010d5:	56                   	push   %esi
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010df:	39 c6                	cmp    %eax,%esi
  8010e1:	73 32                	jae    801115 <memmove+0x44>
  8010e3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010e6:	39 c2                	cmp    %eax,%edx
  8010e8:	76 2b                	jbe    801115 <memmove+0x44>
		s += n;
		d += n;
  8010ea:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010ed:	89 fe                	mov    %edi,%esi
  8010ef:	09 ce                	or     %ecx,%esi
  8010f1:	09 d6                	or     %edx,%esi
  8010f3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010f9:	75 0e                	jne    801109 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010fb:	83 ef 04             	sub    $0x4,%edi
  8010fe:	8d 72 fc             	lea    -0x4(%edx),%esi
  801101:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801104:	fd                   	std    
  801105:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801107:	eb 09                	jmp    801112 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801109:	83 ef 01             	sub    $0x1,%edi
  80110c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80110f:	fd                   	std    
  801110:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801112:	fc                   	cld    
  801113:	eb 1a                	jmp    80112f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801115:	89 c2                	mov    %eax,%edx
  801117:	09 ca                	or     %ecx,%edx
  801119:	09 f2                	or     %esi,%edx
  80111b:	f6 c2 03             	test   $0x3,%dl
  80111e:	75 0a                	jne    80112a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801120:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801123:	89 c7                	mov    %eax,%edi
  801125:	fc                   	cld    
  801126:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801128:	eb 05                	jmp    80112f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80112a:	89 c7                	mov    %eax,%edi
  80112c:	fc                   	cld    
  80112d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801139:	ff 75 10             	pushl  0x10(%ebp)
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	ff 75 08             	pushl  0x8(%ebp)
  801142:	e8 8a ff ff ff       	call   8010d1 <memmove>
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8b 55 0c             	mov    0xc(%ebp),%edx
  801154:	89 c6                	mov    %eax,%esi
  801156:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801159:	39 f0                	cmp    %esi,%eax
  80115b:	74 1c                	je     801179 <memcmp+0x30>
		if (*s1 != *s2)
  80115d:	0f b6 08             	movzbl (%eax),%ecx
  801160:	0f b6 1a             	movzbl (%edx),%ebx
  801163:	38 d9                	cmp    %bl,%cl
  801165:	75 08                	jne    80116f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801167:	83 c0 01             	add    $0x1,%eax
  80116a:	83 c2 01             	add    $0x1,%edx
  80116d:	eb ea                	jmp    801159 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80116f:	0f b6 c1             	movzbl %cl,%eax
  801172:	0f b6 db             	movzbl %bl,%ebx
  801175:	29 d8                	sub    %ebx,%eax
  801177:	eb 05                	jmp    80117e <memcmp+0x35>
	}

	return 0;
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    

00801182 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80118b:	89 c2                	mov    %eax,%edx
  80118d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801190:	39 d0                	cmp    %edx,%eax
  801192:	73 09                	jae    80119d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801194:	38 08                	cmp    %cl,(%eax)
  801196:	74 05                	je     80119d <memfind+0x1b>
	for (; s < ends; s++)
  801198:	83 c0 01             	add    $0x1,%eax
  80119b:	eb f3                	jmp    801190 <memfind+0xe>
			break;
	return (void *) s;
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	57                   	push   %edi
  8011a3:	56                   	push   %esi
  8011a4:	53                   	push   %ebx
  8011a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ab:	eb 03                	jmp    8011b0 <strtol+0x11>
		s++;
  8011ad:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8011b0:	0f b6 01             	movzbl (%ecx),%eax
  8011b3:	3c 20                	cmp    $0x20,%al
  8011b5:	74 f6                	je     8011ad <strtol+0xe>
  8011b7:	3c 09                	cmp    $0x9,%al
  8011b9:	74 f2                	je     8011ad <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8011bb:	3c 2b                	cmp    $0x2b,%al
  8011bd:	74 2a                	je     8011e9 <strtol+0x4a>
	int neg = 0;
  8011bf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8011c4:	3c 2d                	cmp    $0x2d,%al
  8011c6:	74 2b                	je     8011f3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8011ce:	75 0f                	jne    8011df <strtol+0x40>
  8011d0:	80 39 30             	cmpb   $0x30,(%ecx)
  8011d3:	74 28                	je     8011fd <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8011d5:	85 db                	test   %ebx,%ebx
  8011d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011dc:	0f 44 d8             	cmove  %eax,%ebx
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011e7:	eb 50                	jmp    801239 <strtol+0x9a>
		s++;
  8011e9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8011ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8011f1:	eb d5                	jmp    8011c8 <strtol+0x29>
		s++, neg = 1;
  8011f3:	83 c1 01             	add    $0x1,%ecx
  8011f6:	bf 01 00 00 00       	mov    $0x1,%edi
  8011fb:	eb cb                	jmp    8011c8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801201:	74 0e                	je     801211 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801203:	85 db                	test   %ebx,%ebx
  801205:	75 d8                	jne    8011df <strtol+0x40>
		s++, base = 8;
  801207:	83 c1 01             	add    $0x1,%ecx
  80120a:	bb 08 00 00 00       	mov    $0x8,%ebx
  80120f:	eb ce                	jmp    8011df <strtol+0x40>
		s += 2, base = 16;
  801211:	83 c1 02             	add    $0x2,%ecx
  801214:	bb 10 00 00 00       	mov    $0x10,%ebx
  801219:	eb c4                	jmp    8011df <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80121b:	8d 72 9f             	lea    -0x61(%edx),%esi
  80121e:	89 f3                	mov    %esi,%ebx
  801220:	80 fb 19             	cmp    $0x19,%bl
  801223:	77 29                	ja     80124e <strtol+0xaf>
			dig = *s - 'a' + 10;
  801225:	0f be d2             	movsbl %dl,%edx
  801228:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80122b:	3b 55 10             	cmp    0x10(%ebp),%edx
  80122e:	7d 30                	jge    801260 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801230:	83 c1 01             	add    $0x1,%ecx
  801233:	0f af 45 10          	imul   0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801239:	0f b6 11             	movzbl (%ecx),%edx
  80123c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80123f:	89 f3                	mov    %esi,%ebx
  801241:	80 fb 09             	cmp    $0x9,%bl
  801244:	77 d5                	ja     80121b <strtol+0x7c>
			dig = *s - '0';
  801246:	0f be d2             	movsbl %dl,%edx
  801249:	83 ea 30             	sub    $0x30,%edx
  80124c:	eb dd                	jmp    80122b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80124e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801251:	89 f3                	mov    %esi,%ebx
  801253:	80 fb 19             	cmp    $0x19,%bl
  801256:	77 08                	ja     801260 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801258:	0f be d2             	movsbl %dl,%edx
  80125b:	83 ea 37             	sub    $0x37,%edx
  80125e:	eb cb                	jmp    80122b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801260:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801264:	74 05                	je     80126b <strtol+0xcc>
		*endptr = (char *) s;
  801266:	8b 75 0c             	mov    0xc(%ebp),%esi
  801269:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	f7 da                	neg    %edx
  80126f:	85 ff                	test   %edi,%edi
  801271:	0f 45 c2             	cmovne %edx,%eax
}
  801274:	5b                   	pop    %ebx
  801275:	5e                   	pop    %esi
  801276:	5f                   	pop    %edi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128a:	89 c3                	mov    %eax,%ebx
  80128c:	89 c7                	mov    %eax,%edi
  80128e:	89 c6                	mov    %eax,%esi
  801290:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5f                   	pop    %edi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <sys_cgetc>:

int
sys_cgetc(void)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	57                   	push   %edi
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80129d:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8012a7:	89 d1                	mov    %edx,%ecx
  8012a9:	89 d3                	mov    %edx,%ebx
  8012ab:	89 d7                	mov    %edx,%edi
  8012ad:	89 d6                	mov    %edx,%esi
  8012af:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    

008012b6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	57                   	push   %edi
  8012ba:	56                   	push   %esi
  8012bb:	53                   	push   %ebx
  8012bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8012cc:	89 cb                	mov    %ecx,%ebx
  8012ce:	89 cf                	mov    %ecx,%edi
  8012d0:	89 ce                	mov    %ecx,%esi
  8012d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	7f 08                	jg     8012e0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	50                   	push   %eax
  8012e4:	6a 03                	push   $0x3
  8012e6:	68 a8 30 80 00       	push   $0x8030a8
  8012eb:	6a 43                	push   $0x43
  8012ed:	68 c5 30 80 00       	push   $0x8030c5
  8012f2:	e8 f7 f3 ff ff       	call   8006ee <_panic>

008012f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	57                   	push   %edi
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801302:	b8 02 00 00 00       	mov    $0x2,%eax
  801307:	89 d1                	mov    %edx,%ecx
  801309:	89 d3                	mov    %edx,%ebx
  80130b:	89 d7                	mov    %edx,%edi
  80130d:	89 d6                	mov    %edx,%esi
  80130f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5f                   	pop    %edi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <sys_yield>:

void
sys_yield(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80131c:	ba 00 00 00 00       	mov    $0x0,%edx
  801321:	b8 0b 00 00 00       	mov    $0xb,%eax
  801326:	89 d1                	mov    %edx,%ecx
  801328:	89 d3                	mov    %edx,%ebx
  80132a:	89 d7                	mov    %edx,%edi
  80132c:	89 d6                	mov    %edx,%esi
  80132e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5f                   	pop    %edi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80133e:	be 00 00 00 00       	mov    $0x0,%esi
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801349:	b8 04 00 00 00       	mov    $0x4,%eax
  80134e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801351:	89 f7                	mov    %esi,%edi
  801353:	cd 30                	int    $0x30
	if(check && ret > 0)
  801355:	85 c0                	test   %eax,%eax
  801357:	7f 08                	jg     801361 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801359:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135c:	5b                   	pop    %ebx
  80135d:	5e                   	pop    %esi
  80135e:	5f                   	pop    %edi
  80135f:	5d                   	pop    %ebp
  801360:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	50                   	push   %eax
  801365:	6a 04                	push   $0x4
  801367:	68 a8 30 80 00       	push   $0x8030a8
  80136c:	6a 43                	push   $0x43
  80136e:	68 c5 30 80 00       	push   $0x8030c5
  801373:	e8 76 f3 ff ff       	call   8006ee <_panic>

00801378 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801381:	8b 55 08             	mov    0x8(%ebp),%edx
  801384:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801387:	b8 05 00 00 00       	mov    $0x5,%eax
  80138c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801392:	8b 75 18             	mov    0x18(%ebp),%esi
  801395:	cd 30                	int    $0x30
	if(check && ret > 0)
  801397:	85 c0                	test   %eax,%eax
  801399:	7f 08                	jg     8013a3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80139b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139e:	5b                   	pop    %ebx
  80139f:	5e                   	pop    %esi
  8013a0:	5f                   	pop    %edi
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	6a 05                	push   $0x5
  8013a9:	68 a8 30 80 00       	push   $0x8030a8
  8013ae:	6a 43                	push   $0x43
  8013b0:	68 c5 30 80 00       	push   $0x8030c5
  8013b5:	e8 34 f3 ff ff       	call   8006ee <_panic>

008013ba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8013d3:	89 df                	mov    %ebx,%edi
  8013d5:	89 de                	mov    %ebx,%esi
  8013d7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	7f 08                	jg     8013e5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	50                   	push   %eax
  8013e9:	6a 06                	push   $0x6
  8013eb:	68 a8 30 80 00       	push   $0x8030a8
  8013f0:	6a 43                	push   $0x43
  8013f2:	68 c5 30 80 00       	push   $0x8030c5
  8013f7:	e8 f2 f2 ff ff       	call   8006ee <_panic>

008013fc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	57                   	push   %edi
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801405:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140a:	8b 55 08             	mov    0x8(%ebp),%edx
  80140d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801410:	b8 08 00 00 00       	mov    $0x8,%eax
  801415:	89 df                	mov    %ebx,%edi
  801417:	89 de                	mov    %ebx,%esi
  801419:	cd 30                	int    $0x30
	if(check && ret > 0)
  80141b:	85 c0                	test   %eax,%eax
  80141d:	7f 08                	jg     801427 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80141f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801427:	83 ec 0c             	sub    $0xc,%esp
  80142a:	50                   	push   %eax
  80142b:	6a 08                	push   $0x8
  80142d:	68 a8 30 80 00       	push   $0x8030a8
  801432:	6a 43                	push   $0x43
  801434:	68 c5 30 80 00       	push   $0x8030c5
  801439:	e8 b0 f2 ff ff       	call   8006ee <_panic>

0080143e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801447:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144c:	8b 55 08             	mov    0x8(%ebp),%edx
  80144f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801452:	b8 09 00 00 00       	mov    $0x9,%eax
  801457:	89 df                	mov    %ebx,%edi
  801459:	89 de                	mov    %ebx,%esi
  80145b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80145d:	85 c0                	test   %eax,%eax
  80145f:	7f 08                	jg     801469 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801461:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801464:	5b                   	pop    %ebx
  801465:	5e                   	pop    %esi
  801466:	5f                   	pop    %edi
  801467:	5d                   	pop    %ebp
  801468:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801469:	83 ec 0c             	sub    $0xc,%esp
  80146c:	50                   	push   %eax
  80146d:	6a 09                	push   $0x9
  80146f:	68 a8 30 80 00       	push   $0x8030a8
  801474:	6a 43                	push   $0x43
  801476:	68 c5 30 80 00       	push   $0x8030c5
  80147b:	e8 6e f2 ff ff       	call   8006ee <_panic>

00801480 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	57                   	push   %edi
  801484:	56                   	push   %esi
  801485:	53                   	push   %ebx
  801486:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801489:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148e:	8b 55 08             	mov    0x8(%ebp),%edx
  801491:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801494:	b8 0a 00 00 00       	mov    $0xa,%eax
  801499:	89 df                	mov    %ebx,%edi
  80149b:	89 de                	mov    %ebx,%esi
  80149d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	7f 08                	jg     8014ab <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5e                   	pop    %esi
  8014a8:	5f                   	pop    %edi
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ab:	83 ec 0c             	sub    $0xc,%esp
  8014ae:	50                   	push   %eax
  8014af:	6a 0a                	push   $0xa
  8014b1:	68 a8 30 80 00       	push   $0x8030a8
  8014b6:	6a 43                	push   $0x43
  8014b8:	68 c5 30 80 00       	push   $0x8030c5
  8014bd:	e8 2c f2 ff ff       	call   8006ee <_panic>

008014c2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	57                   	push   %edi
  8014c6:	56                   	push   %esi
  8014c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ce:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014d3:	be 00 00 00 00       	mov    $0x0,%esi
  8014d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014db:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014de:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014e0:	5b                   	pop    %ebx
  8014e1:	5e                   	pop    %esi
  8014e2:	5f                   	pop    %edi
  8014e3:	5d                   	pop    %ebp
  8014e4:	c3                   	ret    

008014e5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	57                   	push   %edi
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014fb:	89 cb                	mov    %ecx,%ebx
  8014fd:	89 cf                	mov    %ecx,%edi
  8014ff:	89 ce                	mov    %ecx,%esi
  801501:	cd 30                	int    $0x30
	if(check && ret > 0)
  801503:	85 c0                	test   %eax,%eax
  801505:	7f 08                	jg     80150f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80150f:	83 ec 0c             	sub    $0xc,%esp
  801512:	50                   	push   %eax
  801513:	6a 0d                	push   $0xd
  801515:	68 a8 30 80 00       	push   $0x8030a8
  80151a:	6a 43                	push   $0x43
  80151c:	68 c5 30 80 00       	push   $0x8030c5
  801521:	e8 c8 f1 ff ff       	call   8006ee <_panic>

00801526 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80152c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801537:	b8 0e 00 00 00       	mov    $0xe,%eax
  80153c:	89 df                	mov    %ebx,%edi
  80153e:	89 de                	mov    %ebx,%esi
  801540:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5f                   	pop    %edi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	57                   	push   %edi
  80154b:	56                   	push   %esi
  80154c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801552:	8b 55 08             	mov    0x8(%ebp),%edx
  801555:	b8 0f 00 00 00       	mov    $0xf,%eax
  80155a:	89 cb                	mov    %ecx,%ebx
  80155c:	89 cf                	mov    %ecx,%edi
  80155e:	89 ce                	mov    %ecx,%esi
  801560:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801562:	5b                   	pop    %ebx
  801563:	5e                   	pop    %esi
  801564:	5f                   	pop    %edi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	57                   	push   %edi
  80156b:	56                   	push   %esi
  80156c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156d:	ba 00 00 00 00       	mov    $0x0,%edx
  801572:	b8 10 00 00 00       	mov    $0x10,%eax
  801577:	89 d1                	mov    %edx,%ecx
  801579:	89 d3                	mov    %edx,%ebx
  80157b:	89 d7                	mov    %edx,%edi
  80157d:	89 d6                	mov    %edx,%esi
  80157f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	57                   	push   %edi
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80158c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801591:	8b 55 08             	mov    0x8(%ebp),%edx
  801594:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801597:	b8 11 00 00 00       	mov    $0x11,%eax
  80159c:	89 df                	mov    %ebx,%edi
  80159e:	89 de                	mov    %ebx,%esi
  8015a0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8015a2:	5b                   	pop    %ebx
  8015a3:	5e                   	pop    %esi
  8015a4:	5f                   	pop    %edi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	57                   	push   %edi
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b8:	b8 12 00 00 00       	mov    $0x12,%eax
  8015bd:	89 df                	mov    %ebx,%edi
  8015bf:	89 de                	mov    %ebx,%esi
  8015c1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8015c3:	5b                   	pop    %ebx
  8015c4:	5e                   	pop    %esi
  8015c5:	5f                   	pop    %edi
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    

008015c8 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015dc:	b8 13 00 00 00       	mov    $0x13,%eax
  8015e1:	89 df                	mov    %ebx,%edi
  8015e3:	89 de                	mov    %ebx,%esi
  8015e5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	7f 08                	jg     8015f3 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5f                   	pop    %edi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	50                   	push   %eax
  8015f7:	6a 13                	push   $0x13
  8015f9:	68 a8 30 80 00       	push   $0x8030a8
  8015fe:	6a 43                	push   $0x43
  801600:	68 c5 30 80 00       	push   $0x8030c5
  801605:	e8 e4 f0 ff ff       	call   8006ee <_panic>

0080160a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801610:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  801617:	74 0a                	je     801623 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	6a 07                	push   $0x7
  801628:	68 00 f0 bf ee       	push   $0xeebff000
  80162d:	6a 00                	push   $0x0
  80162f:	e8 01 fd ff ff       	call   801335 <sys_page_alloc>
		if(r < 0)
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 2a                	js     801665 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	68 79 16 80 00       	push   $0x801679
  801643:	6a 00                	push   $0x0
  801645:	e8 36 fe ff ff       	call   801480 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	79 c8                	jns    801619 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 04 31 80 00       	push   $0x803104
  801659:	6a 25                	push   $0x25
  80165b:	68 3d 31 80 00       	push   $0x80313d
  801660:	e8 89 f0 ff ff       	call   8006ee <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 d4 30 80 00       	push   $0x8030d4
  80166d:	6a 22                	push   $0x22
  80166f:	68 3d 31 80 00       	push   $0x80313d
  801674:	e8 75 f0 ff ff       	call   8006ee <_panic>

00801679 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801679:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80167a:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  80167f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801681:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801684:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801688:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80168c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80168f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801691:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801695:	83 c4 08             	add    $0x8,%esp
	popal
  801698:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801699:	83 c4 04             	add    $0x4,%esp
	popfl
  80169c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80169d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80169e:	c3                   	ret    

0080169f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	05 00 00 00 30       	add    $0x30000000,%eax
  8016aa:	c1 e8 0c             	shr    $0xc,%eax
}
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016ce:	89 c2                	mov    %eax,%edx
  8016d0:	c1 ea 16             	shr    $0x16,%edx
  8016d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016da:	f6 c2 01             	test   $0x1,%dl
  8016dd:	74 2d                	je     80170c <fd_alloc+0x46>
  8016df:	89 c2                	mov    %eax,%edx
  8016e1:	c1 ea 0c             	shr    $0xc,%edx
  8016e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016eb:	f6 c2 01             	test   $0x1,%dl
  8016ee:	74 1c                	je     80170c <fd_alloc+0x46>
  8016f0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016f5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016fa:	75 d2                	jne    8016ce <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801705:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80170a:	eb 0a                	jmp    801716 <fd_alloc+0x50>
			*fd_store = fd;
  80170c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    

00801718 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80171e:	83 f8 1f             	cmp    $0x1f,%eax
  801721:	77 30                	ja     801753 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801723:	c1 e0 0c             	shl    $0xc,%eax
  801726:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80172b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801731:	f6 c2 01             	test   $0x1,%dl
  801734:	74 24                	je     80175a <fd_lookup+0x42>
  801736:	89 c2                	mov    %eax,%edx
  801738:	c1 ea 0c             	shr    $0xc,%edx
  80173b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801742:	f6 c2 01             	test   $0x1,%dl
  801745:	74 1a                	je     801761 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	89 02                	mov    %eax,(%edx)
	return 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    
		return -E_INVAL;
  801753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801758:	eb f7                	jmp    801751 <fd_lookup+0x39>
		return -E_INVAL;
  80175a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175f:	eb f0                	jmp    801751 <fd_lookup+0x39>
  801761:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801766:	eb e9                	jmp    801751 <fd_lookup+0x39>

00801768 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80177b:	39 08                	cmp    %ecx,(%eax)
  80177d:	74 38                	je     8017b7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80177f:	83 c2 01             	add    $0x1,%edx
  801782:	8b 04 95 cc 31 80 00 	mov    0x8031cc(,%edx,4),%eax
  801789:	85 c0                	test   %eax,%eax
  80178b:	75 ee                	jne    80177b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80178d:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801792:	8b 40 48             	mov    0x48(%eax),%eax
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	51                   	push   %ecx
  801799:	50                   	push   %eax
  80179a:	68 4c 31 80 00       	push   $0x80314c
  80179f:	e8 40 f0 ff ff       	call   8007e4 <cprintf>
	*dev = 0;
  8017a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    
			*dev = devtab[i];
  8017b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ba:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	eb f2                	jmp    8017b5 <dev_lookup+0x4d>

008017c3 <fd_close>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	57                   	push   %edi
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 24             	sub    $0x24,%esp
  8017cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8017cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017d6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017dc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017df:	50                   	push   %eax
  8017e0:	e8 33 ff ff ff       	call   801718 <fd_lookup>
  8017e5:	89 c3                	mov    %eax,%ebx
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 05                	js     8017f3 <fd_close+0x30>
	    || fd != fd2)
  8017ee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017f1:	74 16                	je     801809 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f3:	89 f8                	mov    %edi,%eax
  8017f5:	84 c0                	test   %al,%al
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	0f 44 d8             	cmove  %eax,%ebx
}
  8017ff:	89 d8                	mov    %ebx,%eax
  801801:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80180f:	50                   	push   %eax
  801810:	ff 36                	pushl  (%esi)
  801812:	e8 51 ff ff ff       	call   801768 <dev_lookup>
  801817:	89 c3                	mov    %eax,%ebx
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 1a                	js     80183a <fd_close+0x77>
		if (dev->dev_close)
  801820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801823:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801826:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80182b:	85 c0                	test   %eax,%eax
  80182d:	74 0b                	je     80183a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80182f:	83 ec 0c             	sub    $0xc,%esp
  801832:	56                   	push   %esi
  801833:	ff d0                	call   *%eax
  801835:	89 c3                	mov    %eax,%ebx
  801837:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	56                   	push   %esi
  80183e:	6a 00                	push   $0x0
  801840:	e8 75 fb ff ff       	call   8013ba <sys_page_unmap>
	return r;
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	eb b5                	jmp    8017ff <fd_close+0x3c>

0080184a <close>:

int
close(int fdnum)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801850:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801853:	50                   	push   %eax
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 bc fe ff ff       	call   801718 <fd_lookup>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	79 02                	jns    801865 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    
		return fd_close(fd, 1);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	6a 01                	push   $0x1
  80186a:	ff 75 f4             	pushl  -0xc(%ebp)
  80186d:	e8 51 ff ff ff       	call   8017c3 <fd_close>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	eb ec                	jmp    801863 <close+0x19>

00801877 <close_all>:

void
close_all(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	53                   	push   %ebx
  80187b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80187e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	53                   	push   %ebx
  801887:	e8 be ff ff ff       	call   80184a <close>
	for (i = 0; i < MAXFD; i++)
  80188c:	83 c3 01             	add    $0x1,%ebx
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	83 fb 20             	cmp    $0x20,%ebx
  801895:	75 ec                	jne    801883 <close_all+0xc>
}
  801897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	57                   	push   %edi
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a8:	50                   	push   %eax
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	e8 67 fe ff ff       	call   801718 <fd_lookup>
  8018b1:	89 c3                	mov    %eax,%ebx
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	0f 88 81 00 00 00    	js     80193f <dup+0xa3>
		return r;
	close(newfdnum);
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	e8 81 ff ff ff       	call   80184a <close>

	newfd = INDEX2FD(newfdnum);
  8018c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018cc:	c1 e6 0c             	shl    $0xc,%esi
  8018cf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018d5:	83 c4 04             	add    $0x4,%esp
  8018d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018db:	e8 cf fd ff ff       	call   8016af <fd2data>
  8018e0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018e2:	89 34 24             	mov    %esi,(%esp)
  8018e5:	e8 c5 fd ff ff       	call   8016af <fd2data>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	c1 e8 16             	shr    $0x16,%eax
  8018f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018fb:	a8 01                	test   $0x1,%al
  8018fd:	74 11                	je     801910 <dup+0x74>
  8018ff:	89 d8                	mov    %ebx,%eax
  801901:	c1 e8 0c             	shr    $0xc,%eax
  801904:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80190b:	f6 c2 01             	test   $0x1,%dl
  80190e:	75 39                	jne    801949 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801913:	89 d0                	mov    %edx,%eax
  801915:	c1 e8 0c             	shr    $0xc,%eax
  801918:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	25 07 0e 00 00       	and    $0xe07,%eax
  801927:	50                   	push   %eax
  801928:	56                   	push   %esi
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	6a 00                	push   $0x0
  80192e:	e8 45 fa ff ff       	call   801378 <sys_page_map>
  801933:	89 c3                	mov    %eax,%ebx
  801935:	83 c4 20             	add    $0x20,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 31                	js     80196d <dup+0xd1>
		goto err;

	return newfdnum;
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80193f:	89 d8                	mov    %ebx,%eax
  801941:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801949:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	25 07 0e 00 00       	and    $0xe07,%eax
  801958:	50                   	push   %eax
  801959:	57                   	push   %edi
  80195a:	6a 00                	push   $0x0
  80195c:	53                   	push   %ebx
  80195d:	6a 00                	push   $0x0
  80195f:	e8 14 fa ff ff       	call   801378 <sys_page_map>
  801964:	89 c3                	mov    %eax,%ebx
  801966:	83 c4 20             	add    $0x20,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	79 a3                	jns    801910 <dup+0x74>
	sys_page_unmap(0, newfd);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	56                   	push   %esi
  801971:	6a 00                	push   $0x0
  801973:	e8 42 fa ff ff       	call   8013ba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801978:	83 c4 08             	add    $0x8,%esp
  80197b:	57                   	push   %edi
  80197c:	6a 00                	push   $0x0
  80197e:	e8 37 fa ff ff       	call   8013ba <sys_page_unmap>
	return r;
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	eb b7                	jmp    80193f <dup+0xa3>

00801988 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	53                   	push   %ebx
  80198c:	83 ec 1c             	sub    $0x1c,%esp
  80198f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801992:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801995:	50                   	push   %eax
  801996:	53                   	push   %ebx
  801997:	e8 7c fd ff ff       	call   801718 <fd_lookup>
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 3f                	js     8019e2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ad:	ff 30                	pushl  (%eax)
  8019af:	e8 b4 fd ff ff       	call   801768 <dev_lookup>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 27                	js     8019e2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019be:	8b 42 08             	mov    0x8(%edx),%eax
  8019c1:	83 e0 03             	and    $0x3,%eax
  8019c4:	83 f8 01             	cmp    $0x1,%eax
  8019c7:	74 1e                	je     8019e7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	8b 40 08             	mov    0x8(%eax),%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 35                	je     801a08 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	52                   	push   %edx
  8019dd:	ff d0                	call   *%eax
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e7:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8019ec:	8b 40 48             	mov    0x48(%eax),%eax
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	53                   	push   %ebx
  8019f3:	50                   	push   %eax
  8019f4:	68 90 31 80 00       	push   $0x803190
  8019f9:	e8 e6 ed ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a06:	eb da                	jmp    8019e2 <read+0x5a>
		return -E_NOT_SUPP;
  801a08:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0d:	eb d3                	jmp    8019e2 <read+0x5a>

00801a0f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	57                   	push   %edi
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a1b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a23:	39 f3                	cmp    %esi,%ebx
  801a25:	73 23                	jae    801a4a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	89 f0                	mov    %esi,%eax
  801a2c:	29 d8                	sub    %ebx,%eax
  801a2e:	50                   	push   %eax
  801a2f:	89 d8                	mov    %ebx,%eax
  801a31:	03 45 0c             	add    0xc(%ebp),%eax
  801a34:	50                   	push   %eax
  801a35:	57                   	push   %edi
  801a36:	e8 4d ff ff ff       	call   801988 <read>
		if (m < 0)
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 06                	js     801a48 <readn+0x39>
			return m;
		if (m == 0)
  801a42:	74 06                	je     801a4a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a44:	01 c3                	add    %eax,%ebx
  801a46:	eb db                	jmp    801a23 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a48:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a4a:	89 d8                	mov    %ebx,%eax
  801a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    

00801a54 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
  801a58:	83 ec 1c             	sub    $0x1c,%esp
  801a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	53                   	push   %ebx
  801a63:	e8 b0 fc ff ff       	call   801718 <fd_lookup>
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	78 3a                	js     801aa9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a75:	50                   	push   %eax
  801a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a79:	ff 30                	pushl  (%eax)
  801a7b:	e8 e8 fc ff ff       	call   801768 <dev_lookup>
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 22                	js     801aa9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8e:	74 1e                	je     801aae <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a93:	8b 52 0c             	mov    0xc(%edx),%edx
  801a96:	85 d2                	test   %edx,%edx
  801a98:	74 35                	je     801acf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	ff 75 10             	pushl  0x10(%ebp)
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	50                   	push   %eax
  801aa4:	ff d2                	call   *%edx
  801aa6:	83 c4 10             	add    $0x10,%esp
}
  801aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aae:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801ab3:	8b 40 48             	mov    0x48(%eax),%eax
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	53                   	push   %ebx
  801aba:	50                   	push   %eax
  801abb:	68 ac 31 80 00       	push   $0x8031ac
  801ac0:	e8 1f ed ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acd:	eb da                	jmp    801aa9 <write+0x55>
		return -E_NOT_SUPP;
  801acf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad4:	eb d3                	jmp    801aa9 <write+0x55>

00801ad6 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	e8 30 fc ff ff       	call   801718 <fd_lookup>
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 0e                	js     801afd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	53                   	push   %ebx
  801b03:	83 ec 1c             	sub    $0x1c,%esp
  801b06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b09:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	53                   	push   %ebx
  801b0e:	e8 05 fc ff ff       	call   801718 <fd_lookup>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 37                	js     801b51 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b20:	50                   	push   %eax
  801b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b24:	ff 30                	pushl  (%eax)
  801b26:	e8 3d fc ff ff       	call   801768 <dev_lookup>
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	78 1f                	js     801b51 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b35:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b39:	74 1b                	je     801b56 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3e:	8b 52 18             	mov    0x18(%edx),%edx
  801b41:	85 d2                	test   %edx,%edx
  801b43:	74 32                	je     801b77 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	ff d2                	call   *%edx
  801b4e:	83 c4 10             	add    $0x10,%esp
}
  801b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b56:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b5b:	8b 40 48             	mov    0x48(%eax),%eax
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	53                   	push   %ebx
  801b62:	50                   	push   %eax
  801b63:	68 6c 31 80 00       	push   $0x80316c
  801b68:	e8 77 ec ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b75:	eb da                	jmp    801b51 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7c:	eb d3                	jmp    801b51 <ftruncate+0x52>

00801b7e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	53                   	push   %ebx
  801b82:	83 ec 1c             	sub    $0x1c,%esp
  801b85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b88:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8b:	50                   	push   %eax
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	e8 84 fb ff ff       	call   801718 <fd_lookup>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 4b                	js     801be6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba1:	50                   	push   %eax
  801ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba5:	ff 30                	pushl  (%eax)
  801ba7:	e8 bc fb ff ff       	call   801768 <dev_lookup>
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 33                	js     801be6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bba:	74 2f                	je     801beb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bbc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bbf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bc6:	00 00 00 
	stat->st_isdir = 0;
  801bc9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd0:	00 00 00 
	stat->st_dev = dev;
  801bd3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bd9:	83 ec 08             	sub    $0x8,%esp
  801bdc:	53                   	push   %ebx
  801bdd:	ff 75 f0             	pushl  -0x10(%ebp)
  801be0:	ff 50 14             	call   *0x14(%eax)
  801be3:	83 c4 10             	add    $0x10,%esp
}
  801be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    
		return -E_NOT_SUPP;
  801beb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf0:	eb f4                	jmp    801be6 <fstat+0x68>

00801bf2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	56                   	push   %esi
  801bf6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	e8 22 02 00 00       	call   801e26 <open>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 1b                	js     801c28 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	50                   	push   %eax
  801c14:	e8 65 ff ff ff       	call   801b7e <fstat>
  801c19:	89 c6                	mov    %eax,%esi
	close(fd);
  801c1b:	89 1c 24             	mov    %ebx,(%esp)
  801c1e:	e8 27 fc ff ff       	call   80184a <close>
	return r;
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	89 f3                	mov    %esi,%ebx
}
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	56                   	push   %esi
  801c35:	53                   	push   %ebx
  801c36:	89 c6                	mov    %eax,%esi
  801c38:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c3a:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801c41:	74 27                	je     801c6a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c43:	6a 07                	push   $0x7
  801c45:	68 00 60 80 00       	push   $0x806000
  801c4a:	56                   	push   %esi
  801c4b:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801c51:	e8 08 0c 00 00       	call   80285e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c56:	83 c4 0c             	add    $0xc,%esp
  801c59:	6a 00                	push   $0x0
  801c5b:	53                   	push   %ebx
  801c5c:	6a 00                	push   $0x0
  801c5e:	e8 92 0b 00 00       	call   8027f5 <ipc_recv>
}
  801c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	6a 01                	push   $0x1
  801c6f:	e8 42 0c 00 00       	call   8028b6 <ipc_find_env>
  801c74:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	eb c5                	jmp    801c43 <fsipc+0x12>

00801c7e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c92:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9c:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca1:	e8 8b ff ff ff       	call   801c31 <fsipc>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <devfile_flush>:
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb4:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbe:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc3:	e8 69 ff ff ff       	call   801c31 <fsipc>
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <devfile_stat>:
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cda:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce9:	e8 43 ff ff ff       	call   801c31 <fsipc>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 2c                	js     801d1e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	68 00 60 80 00       	push   $0x806000
  801cfa:	53                   	push   %ebx
  801cfb:	e8 43 f2 ff ff       	call   800f43 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d00:	a1 80 60 80 00       	mov    0x806080,%eax
  801d05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d0b:	a1 84 60 80 00       	mov    0x806084,%eax
  801d10:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d16:	83 c4 10             	add    $0x10,%esp
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <devfile_write>:
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 08             	sub    $0x8,%esp
  801d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d38:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d3e:	53                   	push   %ebx
  801d3f:	ff 75 0c             	pushl  0xc(%ebp)
  801d42:	68 08 60 80 00       	push   $0x806008
  801d47:	e8 e7 f3 ff ff       	call   801133 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d51:	b8 04 00 00 00       	mov    $0x4,%eax
  801d56:	e8 d6 fe ff ff       	call   801c31 <fsipc>
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 0b                	js     801d6d <devfile_write+0x4a>
	assert(r <= n);
  801d62:	39 d8                	cmp    %ebx,%eax
  801d64:	77 0c                	ja     801d72 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6b:	7f 1e                	jg     801d8b <devfile_write+0x68>
}
  801d6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    
	assert(r <= n);
  801d72:	68 e0 31 80 00       	push   $0x8031e0
  801d77:	68 e7 31 80 00       	push   $0x8031e7
  801d7c:	68 98 00 00 00       	push   $0x98
  801d81:	68 fc 31 80 00       	push   $0x8031fc
  801d86:	e8 63 e9 ff ff       	call   8006ee <_panic>
	assert(r <= PGSIZE);
  801d8b:	68 07 32 80 00       	push   $0x803207
  801d90:	68 e7 31 80 00       	push   $0x8031e7
  801d95:	68 99 00 00 00       	push   $0x99
  801d9a:	68 fc 31 80 00       	push   $0x8031fc
  801d9f:	e8 4a e9 ff ff       	call   8006ee <_panic>

00801da4 <devfile_read>:
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	8b 40 0c             	mov    0xc(%eax),%eax
  801db2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801db7:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc7:	e8 65 fe ff ff       	call   801c31 <fsipc>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 1f                	js     801df1 <devfile_read+0x4d>
	assert(r <= n);
  801dd2:	39 f0                	cmp    %esi,%eax
  801dd4:	77 24                	ja     801dfa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dd6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ddb:	7f 33                	jg     801e10 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	50                   	push   %eax
  801de1:	68 00 60 80 00       	push   $0x806000
  801de6:	ff 75 0c             	pushl  0xc(%ebp)
  801de9:	e8 e3 f2 ff ff       	call   8010d1 <memmove>
	return r;
  801dee:	83 c4 10             	add    $0x10,%esp
}
  801df1:	89 d8                	mov    %ebx,%eax
  801df3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df6:	5b                   	pop    %ebx
  801df7:	5e                   	pop    %esi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
	assert(r <= n);
  801dfa:	68 e0 31 80 00       	push   $0x8031e0
  801dff:	68 e7 31 80 00       	push   $0x8031e7
  801e04:	6a 7c                	push   $0x7c
  801e06:	68 fc 31 80 00       	push   $0x8031fc
  801e0b:	e8 de e8 ff ff       	call   8006ee <_panic>
	assert(r <= PGSIZE);
  801e10:	68 07 32 80 00       	push   $0x803207
  801e15:	68 e7 31 80 00       	push   $0x8031e7
  801e1a:	6a 7d                	push   $0x7d
  801e1c:	68 fc 31 80 00       	push   $0x8031fc
  801e21:	e8 c8 e8 ff ff       	call   8006ee <_panic>

00801e26 <open>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 1c             	sub    $0x1c,%esp
  801e2e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e31:	56                   	push   %esi
  801e32:	e8 d3 f0 ff ff       	call   800f0a <strlen>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e3f:	7f 6c                	jg     801ead <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e47:	50                   	push   %eax
  801e48:	e8 79 f8 ff ff       	call   8016c6 <fd_alloc>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	85 c0                	test   %eax,%eax
  801e54:	78 3c                	js     801e92 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	56                   	push   %esi
  801e5a:	68 00 60 80 00       	push   $0x806000
  801e5f:	e8 df f0 ff ff       	call   800f43 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e67:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e74:	e8 b8 fd ff ff       	call   801c31 <fsipc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 19                	js     801e9b <open+0x75>
	return fd2num(fd);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	ff 75 f4             	pushl  -0xc(%ebp)
  801e88:	e8 12 f8 ff ff       	call   80169f <fd2num>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	83 c4 10             	add    $0x10,%esp
}
  801e92:	89 d8                	mov    %ebx,%eax
  801e94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    
		fd_close(fd, 0);
  801e9b:	83 ec 08             	sub    $0x8,%esp
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea3:	e8 1b f9 ff ff       	call   8017c3 <fd_close>
		return r;
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	eb e5                	jmp    801e92 <open+0x6c>
		return -E_BAD_PATH;
  801ead:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eb2:	eb de                	jmp    801e92 <open+0x6c>

00801eb4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eba:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebf:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec4:	e8 68 fd ff ff       	call   801c31 <fsipc>
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ed1:	68 13 32 80 00       	push   $0x803213
  801ed6:	ff 75 0c             	pushl  0xc(%ebp)
  801ed9:	e8 65 f0 ff ff       	call   800f43 <strcpy>
	return 0;
}
  801ede:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <devsock_close>:
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	53                   	push   %ebx
  801ee9:	83 ec 10             	sub    $0x10,%esp
  801eec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eef:	53                   	push   %ebx
  801ef0:	e8 fc 09 00 00       	call   8028f1 <pageref>
  801ef5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ef8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801efd:	83 f8 01             	cmp    $0x1,%eax
  801f00:	74 07                	je     801f09 <devsock_close+0x24>
}
  801f02:	89 d0                	mov    %edx,%eax
  801f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 73 0c             	pushl  0xc(%ebx)
  801f0f:	e8 b9 02 00 00       	call   8021cd <nsipc_close>
  801f14:	89 c2                	mov    %eax,%edx
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	eb e7                	jmp    801f02 <devsock_close+0x1d>

00801f1b <devsock_write>:
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	ff 75 10             	pushl  0x10(%ebp)
  801f26:	ff 75 0c             	pushl  0xc(%ebp)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	ff 70 0c             	pushl  0xc(%eax)
  801f2f:	e8 76 03 00 00       	call   8022aa <nsipc_send>
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <devsock_read>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	ff 70 0c             	pushl  0xc(%eax)
  801f4a:	e8 ef 02 00 00       	call   80223e <nsipc_recv>
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <fd2sockid>:
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f57:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	e8 b7 f7 ff ff       	call   801718 <fd_lookup>
  801f61:	83 c4 10             	add    $0x10,%esp
  801f64:	85 c0                	test   %eax,%eax
  801f66:	78 10                	js     801f78 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f71:	39 08                	cmp    %ecx,(%eax)
  801f73:	75 05                	jne    801f7a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f75:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    
		return -E_NOT_SUPP;
  801f7a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f7f:	eb f7                	jmp    801f78 <fd2sockid+0x27>

00801f81 <alloc_sockfd>:
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	56                   	push   %esi
  801f85:	53                   	push   %ebx
  801f86:	83 ec 1c             	sub    $0x1c,%esp
  801f89:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8e:	50                   	push   %eax
  801f8f:	e8 32 f7 ff ff       	call   8016c6 <fd_alloc>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 43                	js     801fe0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 07 04 00 00       	push   $0x407
  801fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa8:	6a 00                	push   $0x0
  801faa:	e8 86 f3 ff ff       	call   801335 <sys_page_alloc>
  801faf:	89 c3                	mov    %eax,%ebx
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 28                	js     801fe0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fc1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fcd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	50                   	push   %eax
  801fd4:	e8 c6 f6 ff ff       	call   80169f <fd2num>
  801fd9:	89 c3                	mov    %eax,%ebx
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	eb 0c                	jmp    801fec <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	56                   	push   %esi
  801fe4:	e8 e4 01 00 00       	call   8021cd <nsipc_close>
		return r;
  801fe9:	83 c4 10             	add    $0x10,%esp
}
  801fec:	89 d8                	mov    %ebx,%eax
  801fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <accept>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	e8 4e ff ff ff       	call   801f51 <fd2sockid>
  802003:	85 c0                	test   %eax,%eax
  802005:	78 1b                	js     802022 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	50                   	push   %eax
  802011:	e8 0e 01 00 00       	call   802124 <nsipc_accept>
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	85 c0                	test   %eax,%eax
  80201b:	78 05                	js     802022 <accept+0x2d>
	return alloc_sockfd(r);
  80201d:	e8 5f ff ff ff       	call   801f81 <alloc_sockfd>
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <bind>:
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	e8 1f ff ff ff       	call   801f51 <fd2sockid>
  802032:	85 c0                	test   %eax,%eax
  802034:	78 12                	js     802048 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	ff 75 10             	pushl  0x10(%ebp)
  80203c:	ff 75 0c             	pushl  0xc(%ebp)
  80203f:	50                   	push   %eax
  802040:	e8 31 01 00 00       	call   802176 <nsipc_bind>
  802045:	83 c4 10             	add    $0x10,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <shutdown>:
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	e8 f9 fe ff ff       	call   801f51 <fd2sockid>
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 0f                	js     80206b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80205c:	83 ec 08             	sub    $0x8,%esp
  80205f:	ff 75 0c             	pushl  0xc(%ebp)
  802062:	50                   	push   %eax
  802063:	e8 43 01 00 00       	call   8021ab <nsipc_shutdown>
  802068:	83 c4 10             	add    $0x10,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <connect>:
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	e8 d6 fe ff ff       	call   801f51 <fd2sockid>
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 12                	js     802091 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	ff 75 10             	pushl  0x10(%ebp)
  802085:	ff 75 0c             	pushl  0xc(%ebp)
  802088:	50                   	push   %eax
  802089:	e8 59 01 00 00       	call   8021e7 <nsipc_connect>
  80208e:	83 c4 10             	add    $0x10,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <listen>:
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	e8 b0 fe ff ff       	call   801f51 <fd2sockid>
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 0f                	js     8020b4 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020a5:	83 ec 08             	sub    $0x8,%esp
  8020a8:	ff 75 0c             	pushl  0xc(%ebp)
  8020ab:	50                   	push   %eax
  8020ac:	e8 6b 01 00 00       	call   80221c <nsipc_listen>
  8020b1:	83 c4 10             	add    $0x10,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020bc:	ff 75 10             	pushl  0x10(%ebp)
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	ff 75 08             	pushl  0x8(%ebp)
  8020c5:	e8 3e 02 00 00       	call   802308 <nsipc_socket>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 05                	js     8020d6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020d1:	e8 ab fe ff ff       	call   801f81 <alloc_sockfd>
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020e1:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  8020e8:	74 26                	je     802110 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020ea:	6a 07                	push   $0x7
  8020ec:	68 00 70 80 00       	push   $0x807000
  8020f1:	53                   	push   %ebx
  8020f2:	ff 35 b0 50 80 00    	pushl  0x8050b0
  8020f8:	e8 61 07 00 00       	call   80285e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020fd:	83 c4 0c             	add    $0xc,%esp
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	e8 ea 06 00 00       	call   8027f5 <ipc_recv>
}
  80210b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802110:	83 ec 0c             	sub    $0xc,%esp
  802113:	6a 02                	push   $0x2
  802115:	e8 9c 07 00 00       	call   8028b6 <ipc_find_env>
  80211a:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	eb c6                	jmp    8020ea <nsipc+0x12>

00802124 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	56                   	push   %esi
  802128:	53                   	push   %ebx
  802129:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802134:	8b 06                	mov    (%esi),%eax
  802136:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80213b:	b8 01 00 00 00       	mov    $0x1,%eax
  802140:	e8 93 ff ff ff       	call   8020d8 <nsipc>
  802145:	89 c3                	mov    %eax,%ebx
  802147:	85 c0                	test   %eax,%eax
  802149:	79 09                	jns    802154 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80214b:	89 d8                	mov    %ebx,%eax
  80214d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	ff 35 10 70 80 00    	pushl  0x807010
  80215d:	68 00 70 80 00       	push   $0x807000
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	e8 67 ef ff ff       	call   8010d1 <memmove>
		*addrlen = ret->ret_addrlen;
  80216a:	a1 10 70 80 00       	mov    0x807010,%eax
  80216f:	89 06                	mov    %eax,(%esi)
  802171:	83 c4 10             	add    $0x10,%esp
	return r;
  802174:	eb d5                	jmp    80214b <nsipc_accept+0x27>

00802176 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	53                   	push   %ebx
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802188:	53                   	push   %ebx
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	68 04 70 80 00       	push   $0x807004
  802191:	e8 3b ef ff ff       	call   8010d1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802196:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80219c:	b8 02 00 00 00       	mov    $0x2,%eax
  8021a1:	e8 32 ff ff ff       	call   8020d8 <nsipc>
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8021c6:	e8 0d ff ff ff       	call   8020d8 <nsipc>
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <nsipc_close>:

int
nsipc_close(int s)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021db:	b8 04 00 00 00       	mov    $0x4,%eax
  8021e0:	e8 f3 fe ff ff       	call   8020d8 <nsipc>
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	53                   	push   %ebx
  8021eb:	83 ec 08             	sub    $0x8,%esp
  8021ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021f9:	53                   	push   %ebx
  8021fa:	ff 75 0c             	pushl  0xc(%ebp)
  8021fd:	68 04 70 80 00       	push   $0x807004
  802202:	e8 ca ee ff ff       	call   8010d1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802207:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80220d:	b8 05 00 00 00       	mov    $0x5,%eax
  802212:	e8 c1 fe ff ff       	call   8020d8 <nsipc>
}
  802217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80222a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802232:	b8 06 00 00 00       	mov    $0x6,%eax
  802237:	e8 9c fe ff ff       	call   8020d8 <nsipc>
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	56                   	push   %esi
  802242:	53                   	push   %ebx
  802243:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80224e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802254:	8b 45 14             	mov    0x14(%ebp),%eax
  802257:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80225c:	b8 07 00 00 00       	mov    $0x7,%eax
  802261:	e8 72 fe ff ff       	call   8020d8 <nsipc>
  802266:	89 c3                	mov    %eax,%ebx
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 1f                	js     80228b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80226c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802271:	7f 21                	jg     802294 <nsipc_recv+0x56>
  802273:	39 c6                	cmp    %eax,%esi
  802275:	7c 1d                	jl     802294 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	50                   	push   %eax
  80227b:	68 00 70 80 00       	push   $0x807000
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	e8 49 ee ff ff       	call   8010d1 <memmove>
  802288:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5d                   	pop    %ebp
  802293:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802294:	68 1f 32 80 00       	push   $0x80321f
  802299:	68 e7 31 80 00       	push   $0x8031e7
  80229e:	6a 62                	push   $0x62
  8022a0:	68 34 32 80 00       	push   $0x803234
  8022a5:	e8 44 e4 ff ff       	call   8006ee <_panic>

008022aa <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 04             	sub    $0x4,%esp
  8022b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022bc:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022c2:	7f 2e                	jg     8022f2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	53                   	push   %ebx
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	68 0c 70 80 00       	push   $0x80700c
  8022d0:	e8 fc ed ff ff       	call   8010d1 <memmove>
	nsipcbuf.send.req_size = size;
  8022d5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022db:	8b 45 14             	mov    0x14(%ebp),%eax
  8022de:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e8:	e8 eb fd ff ff       	call   8020d8 <nsipc>
}
  8022ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    
	assert(size < 1600);
  8022f2:	68 40 32 80 00       	push   $0x803240
  8022f7:	68 e7 31 80 00       	push   $0x8031e7
  8022fc:	6a 6d                	push   $0x6d
  8022fe:	68 34 32 80 00       	push   $0x803234
  802303:	e8 e6 e3 ff ff       	call   8006ee <_panic>

00802308 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80231e:	8b 45 10             	mov    0x10(%ebp),%eax
  802321:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802326:	b8 09 00 00 00       	mov    $0x9,%eax
  80232b:	e8 a8 fd ff ff       	call   8020d8 <nsipc>
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	56                   	push   %esi
  802336:	53                   	push   %ebx
  802337:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	e8 6a f3 ff ff       	call   8016af <fd2data>
  802345:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802347:	83 c4 08             	add    $0x8,%esp
  80234a:	68 4c 32 80 00       	push   $0x80324c
  80234f:	53                   	push   %ebx
  802350:	e8 ee eb ff ff       	call   800f43 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802355:	8b 46 04             	mov    0x4(%esi),%eax
  802358:	2b 06                	sub    (%esi),%eax
  80235a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802360:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802367:	00 00 00 
	stat->st_dev = &devpipe;
  80236a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802371:	40 80 00 
	return 0;
}
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	53                   	push   %ebx
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80238a:	53                   	push   %ebx
  80238b:	6a 00                	push   $0x0
  80238d:	e8 28 f0 ff ff       	call   8013ba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802392:	89 1c 24             	mov    %ebx,(%esp)
  802395:	e8 15 f3 ff ff       	call   8016af <fd2data>
  80239a:	83 c4 08             	add    $0x8,%esp
  80239d:	50                   	push   %eax
  80239e:	6a 00                	push   $0x0
  8023a0:	e8 15 f0 ff ff       	call   8013ba <sys_page_unmap>
}
  8023a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <_pipeisclosed>:
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	57                   	push   %edi
  8023ae:	56                   	push   %esi
  8023af:	53                   	push   %ebx
  8023b0:	83 ec 1c             	sub    $0x1c,%esp
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023b7:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8023bc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	57                   	push   %edi
  8023c3:	e8 29 05 00 00       	call   8028f1 <pageref>
  8023c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023cb:	89 34 24             	mov    %esi,(%esp)
  8023ce:	e8 1e 05 00 00       	call   8028f1 <pageref>
		nn = thisenv->env_runs;
  8023d3:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  8023d9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023dc:	83 c4 10             	add    $0x10,%esp
  8023df:	39 cb                	cmp    %ecx,%ebx
  8023e1:	74 1b                	je     8023fe <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023e3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023e6:	75 cf                	jne    8023b7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e8:	8b 42 58             	mov    0x58(%edx),%eax
  8023eb:	6a 01                	push   $0x1
  8023ed:	50                   	push   %eax
  8023ee:	53                   	push   %ebx
  8023ef:	68 53 32 80 00       	push   $0x803253
  8023f4:	e8 eb e3 ff ff       	call   8007e4 <cprintf>
  8023f9:	83 c4 10             	add    $0x10,%esp
  8023fc:	eb b9                	jmp    8023b7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023fe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802401:	0f 94 c0             	sete   %al
  802404:	0f b6 c0             	movzbl %al,%eax
}
  802407:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240a:	5b                   	pop    %ebx
  80240b:	5e                   	pop    %esi
  80240c:	5f                   	pop    %edi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <devpipe_write>:
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	57                   	push   %edi
  802413:	56                   	push   %esi
  802414:	53                   	push   %ebx
  802415:	83 ec 28             	sub    $0x28,%esp
  802418:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80241b:	56                   	push   %esi
  80241c:	e8 8e f2 ff ff       	call   8016af <fd2data>
  802421:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802423:	83 c4 10             	add    $0x10,%esp
  802426:	bf 00 00 00 00       	mov    $0x0,%edi
  80242b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80242e:	74 4f                	je     80247f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802430:	8b 43 04             	mov    0x4(%ebx),%eax
  802433:	8b 0b                	mov    (%ebx),%ecx
  802435:	8d 51 20             	lea    0x20(%ecx),%edx
  802438:	39 d0                	cmp    %edx,%eax
  80243a:	72 14                	jb     802450 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80243c:	89 da                	mov    %ebx,%edx
  80243e:	89 f0                	mov    %esi,%eax
  802440:	e8 65 ff ff ff       	call   8023aa <_pipeisclosed>
  802445:	85 c0                	test   %eax,%eax
  802447:	75 3b                	jne    802484 <devpipe_write+0x75>
			sys_yield();
  802449:	e8 c8 ee ff ff       	call   801316 <sys_yield>
  80244e:	eb e0                	jmp    802430 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802453:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802457:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80245a:	89 c2                	mov    %eax,%edx
  80245c:	c1 fa 1f             	sar    $0x1f,%edx
  80245f:	89 d1                	mov    %edx,%ecx
  802461:	c1 e9 1b             	shr    $0x1b,%ecx
  802464:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802467:	83 e2 1f             	and    $0x1f,%edx
  80246a:	29 ca                	sub    %ecx,%edx
  80246c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802470:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802474:	83 c0 01             	add    $0x1,%eax
  802477:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80247a:	83 c7 01             	add    $0x1,%edi
  80247d:	eb ac                	jmp    80242b <devpipe_write+0x1c>
	return i;
  80247f:	8b 45 10             	mov    0x10(%ebp),%eax
  802482:	eb 05                	jmp    802489 <devpipe_write+0x7a>
				return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    

00802491 <devpipe_read>:
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	57                   	push   %edi
  802495:	56                   	push   %esi
  802496:	53                   	push   %ebx
  802497:	83 ec 18             	sub    $0x18,%esp
  80249a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80249d:	57                   	push   %edi
  80249e:	e8 0c f2 ff ff       	call   8016af <fd2data>
  8024a3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	be 00 00 00 00       	mov    $0x0,%esi
  8024ad:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b0:	75 14                	jne    8024c6 <devpipe_read+0x35>
	return i;
  8024b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b5:	eb 02                	jmp    8024b9 <devpipe_read+0x28>
				return i;
  8024b7:	89 f0                	mov    %esi,%eax
}
  8024b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
			sys_yield();
  8024c1:	e8 50 ee ff ff       	call   801316 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024c6:	8b 03                	mov    (%ebx),%eax
  8024c8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024cb:	75 18                	jne    8024e5 <devpipe_read+0x54>
			if (i > 0)
  8024cd:	85 f6                	test   %esi,%esi
  8024cf:	75 e6                	jne    8024b7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	89 f8                	mov    %edi,%eax
  8024d5:	e8 d0 fe ff ff       	call   8023aa <_pipeisclosed>
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 e3                	je     8024c1 <devpipe_read+0x30>
				return 0;
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e3:	eb d4                	jmp    8024b9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024e5:	99                   	cltd   
  8024e6:	c1 ea 1b             	shr    $0x1b,%edx
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	83 e0 1f             	and    $0x1f,%eax
  8024ee:	29 d0                	sub    %edx,%eax
  8024f0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024f8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024fb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024fe:	83 c6 01             	add    $0x1,%esi
  802501:	eb aa                	jmp    8024ad <devpipe_read+0x1c>

00802503 <pipe>:
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80250b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80250e:	50                   	push   %eax
  80250f:	e8 b2 f1 ff ff       	call   8016c6 <fd_alloc>
  802514:	89 c3                	mov    %eax,%ebx
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	85 c0                	test   %eax,%eax
  80251b:	0f 88 23 01 00 00    	js     802644 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802521:	83 ec 04             	sub    $0x4,%esp
  802524:	68 07 04 00 00       	push   $0x407
  802529:	ff 75 f4             	pushl  -0xc(%ebp)
  80252c:	6a 00                	push   $0x0
  80252e:	e8 02 ee ff ff       	call   801335 <sys_page_alloc>
  802533:	89 c3                	mov    %eax,%ebx
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	85 c0                	test   %eax,%eax
  80253a:	0f 88 04 01 00 00    	js     802644 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802546:	50                   	push   %eax
  802547:	e8 7a f1 ff ff       	call   8016c6 <fd_alloc>
  80254c:	89 c3                	mov    %eax,%ebx
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	85 c0                	test   %eax,%eax
  802553:	0f 88 db 00 00 00    	js     802634 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 07 04 00 00       	push   $0x407
  802561:	ff 75 f0             	pushl  -0x10(%ebp)
  802564:	6a 00                	push   $0x0
  802566:	e8 ca ed ff ff       	call   801335 <sys_page_alloc>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	0f 88 bc 00 00 00    	js     802634 <pipe+0x131>
	va = fd2data(fd0);
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	ff 75 f4             	pushl  -0xc(%ebp)
  80257e:	e8 2c f1 ff ff       	call   8016af <fd2data>
  802583:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802585:	83 c4 0c             	add    $0xc,%esp
  802588:	68 07 04 00 00       	push   $0x407
  80258d:	50                   	push   %eax
  80258e:	6a 00                	push   $0x0
  802590:	e8 a0 ed ff ff       	call   801335 <sys_page_alloc>
  802595:	89 c3                	mov    %eax,%ebx
  802597:	83 c4 10             	add    $0x10,%esp
  80259a:	85 c0                	test   %eax,%eax
  80259c:	0f 88 82 00 00 00    	js     802624 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a8:	e8 02 f1 ff ff       	call   8016af <fd2data>
  8025ad:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025b4:	50                   	push   %eax
  8025b5:	6a 00                	push   $0x0
  8025b7:	56                   	push   %esi
  8025b8:	6a 00                	push   $0x0
  8025ba:	e8 b9 ed ff ff       	call   801378 <sys_page_map>
  8025bf:	89 c3                	mov    %eax,%ebx
  8025c1:	83 c4 20             	add    $0x20,%esp
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	78 4e                	js     802616 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025c8:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025df:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f1:	e8 a9 f0 ff ff       	call   80169f <fd2num>
  8025f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025fb:	83 c4 04             	add    $0x4,%esp
  8025fe:	ff 75 f0             	pushl  -0x10(%ebp)
  802601:	e8 99 f0 ff ff       	call   80169f <fd2num>
  802606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802609:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802614:	eb 2e                	jmp    802644 <pipe+0x141>
	sys_page_unmap(0, va);
  802616:	83 ec 08             	sub    $0x8,%esp
  802619:	56                   	push   %esi
  80261a:	6a 00                	push   $0x0
  80261c:	e8 99 ed ff ff       	call   8013ba <sys_page_unmap>
  802621:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802624:	83 ec 08             	sub    $0x8,%esp
  802627:	ff 75 f0             	pushl  -0x10(%ebp)
  80262a:	6a 00                	push   $0x0
  80262c:	e8 89 ed ff ff       	call   8013ba <sys_page_unmap>
  802631:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802634:	83 ec 08             	sub    $0x8,%esp
  802637:	ff 75 f4             	pushl  -0xc(%ebp)
  80263a:	6a 00                	push   $0x0
  80263c:	e8 79 ed ff ff       	call   8013ba <sys_page_unmap>
  802641:	83 c4 10             	add    $0x10,%esp
}
  802644:	89 d8                	mov    %ebx,%eax
  802646:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802649:	5b                   	pop    %ebx
  80264a:	5e                   	pop    %esi
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    

0080264d <pipeisclosed>:
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802653:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802656:	50                   	push   %eax
  802657:	ff 75 08             	pushl  0x8(%ebp)
  80265a:	e8 b9 f0 ff ff       	call   801718 <fd_lookup>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	85 c0                	test   %eax,%eax
  802664:	78 18                	js     80267e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802666:	83 ec 0c             	sub    $0xc,%esp
  802669:	ff 75 f4             	pushl  -0xc(%ebp)
  80266c:	e8 3e f0 ff ff       	call   8016af <fd2data>
	return _pipeisclosed(fd, p);
  802671:	89 c2                	mov    %eax,%edx
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	e8 2f fd ff ff       	call   8023aa <_pipeisclosed>
  80267b:	83 c4 10             	add    $0x10,%esp
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	c3                   	ret    

00802686 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
  802689:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80268c:	68 6b 32 80 00       	push   $0x80326b
  802691:	ff 75 0c             	pushl  0xc(%ebp)
  802694:	e8 aa e8 ff ff       	call   800f43 <strcpy>
	return 0;
}
  802699:	b8 00 00 00 00       	mov    $0x0,%eax
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <devcons_write>:
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	57                   	push   %edi
  8026a4:	56                   	push   %esi
  8026a5:	53                   	push   %ebx
  8026a6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026ac:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026b1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026ba:	73 31                	jae    8026ed <devcons_write+0x4d>
		m = n - tot;
  8026bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026bf:	29 f3                	sub    %esi,%ebx
  8026c1:	83 fb 7f             	cmp    $0x7f,%ebx
  8026c4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026c9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	53                   	push   %ebx
  8026d0:	89 f0                	mov    %esi,%eax
  8026d2:	03 45 0c             	add    0xc(%ebp),%eax
  8026d5:	50                   	push   %eax
  8026d6:	57                   	push   %edi
  8026d7:	e8 f5 e9 ff ff       	call   8010d1 <memmove>
		sys_cputs(buf, m);
  8026dc:	83 c4 08             	add    $0x8,%esp
  8026df:	53                   	push   %ebx
  8026e0:	57                   	push   %edi
  8026e1:	e8 93 eb ff ff       	call   801279 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026e6:	01 de                	add    %ebx,%esi
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	eb ca                	jmp    8026b7 <devcons_write+0x17>
}
  8026ed:	89 f0                	mov    %esi,%eax
  8026ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f2:	5b                   	pop    %ebx
  8026f3:	5e                   	pop    %esi
  8026f4:	5f                   	pop    %edi
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    

008026f7 <devcons_read>:
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 08             	sub    $0x8,%esp
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802702:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802706:	74 21                	je     802729 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802708:	e8 8a eb ff ff       	call   801297 <sys_cgetc>
  80270d:	85 c0                	test   %eax,%eax
  80270f:	75 07                	jne    802718 <devcons_read+0x21>
		sys_yield();
  802711:	e8 00 ec ff ff       	call   801316 <sys_yield>
  802716:	eb f0                	jmp    802708 <devcons_read+0x11>
	if (c < 0)
  802718:	78 0f                	js     802729 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80271a:	83 f8 04             	cmp    $0x4,%eax
  80271d:	74 0c                	je     80272b <devcons_read+0x34>
	*(char*)vbuf = c;
  80271f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802722:	88 02                	mov    %al,(%edx)
	return 1;
  802724:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    
		return 0;
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
  802730:	eb f7                	jmp    802729 <devcons_read+0x32>

00802732 <cputchar>:
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80273e:	6a 01                	push   $0x1
  802740:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802743:	50                   	push   %eax
  802744:	e8 30 eb ff ff       	call   801279 <sys_cputs>
}
  802749:	83 c4 10             	add    $0x10,%esp
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <getchar>:
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802754:	6a 01                	push   $0x1
  802756:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802759:	50                   	push   %eax
  80275a:	6a 00                	push   $0x0
  80275c:	e8 27 f2 ff ff       	call   801988 <read>
	if (r < 0)
  802761:	83 c4 10             	add    $0x10,%esp
  802764:	85 c0                	test   %eax,%eax
  802766:	78 06                	js     80276e <getchar+0x20>
	if (r < 1)
  802768:	74 06                	je     802770 <getchar+0x22>
	return c;
  80276a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    
		return -E_EOF;
  802770:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802775:	eb f7                	jmp    80276e <getchar+0x20>

00802777 <iscons>:
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80277d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802780:	50                   	push   %eax
  802781:	ff 75 08             	pushl  0x8(%ebp)
  802784:	e8 8f ef ff ff       	call   801718 <fd_lookup>
  802789:	83 c4 10             	add    $0x10,%esp
  80278c:	85 c0                	test   %eax,%eax
  80278e:	78 11                	js     8027a1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802799:	39 10                	cmp    %edx,(%eax)
  80279b:	0f 94 c0             	sete   %al
  80279e:	0f b6 c0             	movzbl %al,%eax
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <opencons>:
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ac:	50                   	push   %eax
  8027ad:	e8 14 ef ff ff       	call   8016c6 <fd_alloc>
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	78 3a                	js     8027f3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	68 07 04 00 00       	push   $0x407
  8027c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c4:	6a 00                	push   $0x0
  8027c6:	e8 6a eb ff ff       	call   801335 <sys_page_alloc>
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	78 21                	js     8027f3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027db:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	50                   	push   %eax
  8027eb:	e8 af ee ff ff       	call   80169f <fd2num>
  8027f0:	83 c4 10             	add    $0x10,%esp
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	56                   	push   %esi
  8027f9:	53                   	push   %ebx
  8027fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8027fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802800:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802803:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802805:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80280a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	50                   	push   %eax
  802811:	e8 cf ec ff ff       	call   8014e5 <sys_ipc_recv>
	if(ret < 0){
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 2b                	js     802848 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80281d:	85 f6                	test   %esi,%esi
  80281f:	74 0a                	je     80282b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802821:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802826:	8b 40 74             	mov    0x74(%eax),%eax
  802829:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80282b:	85 db                	test   %ebx,%ebx
  80282d:	74 0a                	je     802839 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80282f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802834:	8b 40 78             	mov    0x78(%eax),%eax
  802837:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802839:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80283e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802844:	5b                   	pop    %ebx
  802845:	5e                   	pop    %esi
  802846:	5d                   	pop    %ebp
  802847:	c3                   	ret    
		if(from_env_store)
  802848:	85 f6                	test   %esi,%esi
  80284a:	74 06                	je     802852 <ipc_recv+0x5d>
			*from_env_store = 0;
  80284c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802852:	85 db                	test   %ebx,%ebx
  802854:	74 eb                	je     802841 <ipc_recv+0x4c>
			*perm_store = 0;
  802856:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80285c:	eb e3                	jmp    802841 <ipc_recv+0x4c>

0080285e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	57                   	push   %edi
  802862:	56                   	push   %esi
  802863:	53                   	push   %ebx
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	8b 7d 08             	mov    0x8(%ebp),%edi
  80286a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80286d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802870:	85 db                	test   %ebx,%ebx
  802872:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802877:	0f 44 d8             	cmove  %eax,%ebx
  80287a:	eb 05                	jmp    802881 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80287c:	e8 95 ea ff ff       	call   801316 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802881:	ff 75 14             	pushl  0x14(%ebp)
  802884:	53                   	push   %ebx
  802885:	56                   	push   %esi
  802886:	57                   	push   %edi
  802887:	e8 36 ec ff ff       	call   8014c2 <sys_ipc_try_send>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 1b                	je     8028ae <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802893:	79 e7                	jns    80287c <ipc_send+0x1e>
  802895:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802898:	74 e2                	je     80287c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80289a:	83 ec 04             	sub    $0x4,%esp
  80289d:	68 77 32 80 00       	push   $0x803277
  8028a2:	6a 46                	push   $0x46
  8028a4:	68 8c 32 80 00       	push   $0x80328c
  8028a9:	e8 40 de ff ff       	call   8006ee <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5f                   	pop    %edi
  8028b4:	5d                   	pop    %ebp
  8028b5:	c3                   	ret    

008028b6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028c1:	89 c2                	mov    %eax,%edx
  8028c3:	c1 e2 07             	shl    $0x7,%edx
  8028c6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028cc:	8b 52 50             	mov    0x50(%edx),%edx
  8028cf:	39 ca                	cmp    %ecx,%edx
  8028d1:	74 11                	je     8028e4 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028d3:	83 c0 01             	add    $0x1,%eax
  8028d6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028db:	75 e4                	jne    8028c1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	eb 0b                	jmp    8028ef <ipc_find_env+0x39>
			return envs[i].env_id;
  8028e4:	c1 e0 07             	shl    $0x7,%eax
  8028e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028ec:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    

008028f1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028f7:	89 d0                	mov    %edx,%eax
  8028f9:	c1 e8 16             	shr    $0x16,%eax
  8028fc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802908:	f6 c1 01             	test   $0x1,%cl
  80290b:	74 1d                	je     80292a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80290d:	c1 ea 0c             	shr    $0xc,%edx
  802910:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802917:	f6 c2 01             	test   $0x1,%dl
  80291a:	74 0e                	je     80292a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80291c:	c1 ea 0c             	shr    $0xc,%edx
  80291f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802926:	ef 
  802927:	0f b7 c0             	movzwl %ax,%eax
}
  80292a:	5d                   	pop    %ebp
  80292b:	c3                   	ret    
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__udivdi3>:
  802930:	55                   	push   %ebp
  802931:	57                   	push   %edi
  802932:	56                   	push   %esi
  802933:	53                   	push   %ebx
  802934:	83 ec 1c             	sub    $0x1c,%esp
  802937:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80293b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80293f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802943:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802947:	85 d2                	test   %edx,%edx
  802949:	75 4d                	jne    802998 <__udivdi3+0x68>
  80294b:	39 f3                	cmp    %esi,%ebx
  80294d:	76 19                	jbe    802968 <__udivdi3+0x38>
  80294f:	31 ff                	xor    %edi,%edi
  802951:	89 e8                	mov    %ebp,%eax
  802953:	89 f2                	mov    %esi,%edx
  802955:	f7 f3                	div    %ebx
  802957:	89 fa                	mov    %edi,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 d9                	mov    %ebx,%ecx
  80296a:	85 db                	test   %ebx,%ebx
  80296c:	75 0b                	jne    802979 <__udivdi3+0x49>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f3                	div    %ebx
  802977:	89 c1                	mov    %eax,%ecx
  802979:	31 d2                	xor    %edx,%edx
  80297b:	89 f0                	mov    %esi,%eax
  80297d:	f7 f1                	div    %ecx
  80297f:	89 c6                	mov    %eax,%esi
  802981:	89 e8                	mov    %ebp,%eax
  802983:	89 f7                	mov    %esi,%edi
  802985:	f7 f1                	div    %ecx
  802987:	89 fa                	mov    %edi,%edx
  802989:	83 c4 1c             	add    $0x1c,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5f                   	pop    %edi
  80298f:	5d                   	pop    %ebp
  802990:	c3                   	ret    
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	39 f2                	cmp    %esi,%edx
  80299a:	77 1c                	ja     8029b8 <__udivdi3+0x88>
  80299c:	0f bd fa             	bsr    %edx,%edi
  80299f:	83 f7 1f             	xor    $0x1f,%edi
  8029a2:	75 2c                	jne    8029d0 <__udivdi3+0xa0>
  8029a4:	39 f2                	cmp    %esi,%edx
  8029a6:	72 06                	jb     8029ae <__udivdi3+0x7e>
  8029a8:	31 c0                	xor    %eax,%eax
  8029aa:	39 eb                	cmp    %ebp,%ebx
  8029ac:	77 a9                	ja     802957 <__udivdi3+0x27>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	eb a2                	jmp    802957 <__udivdi3+0x27>
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	31 ff                	xor    %edi,%edi
  8029ba:	31 c0                	xor    %eax,%eax
  8029bc:	89 fa                	mov    %edi,%edx
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	89 f9                	mov    %edi,%ecx
  8029d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029d7:	29 f8                	sub    %edi,%eax
  8029d9:	d3 e2                	shl    %cl,%edx
  8029db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029df:	89 c1                	mov    %eax,%ecx
  8029e1:	89 da                	mov    %ebx,%edx
  8029e3:	d3 ea                	shr    %cl,%edx
  8029e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029e9:	09 d1                	or     %edx,%ecx
  8029eb:	89 f2                	mov    %esi,%edx
  8029ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029f1:	89 f9                	mov    %edi,%ecx
  8029f3:	d3 e3                	shl    %cl,%ebx
  8029f5:	89 c1                	mov    %eax,%ecx
  8029f7:	d3 ea                	shr    %cl,%edx
  8029f9:	89 f9                	mov    %edi,%ecx
  8029fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ff:	89 eb                	mov    %ebp,%ebx
  802a01:	d3 e6                	shl    %cl,%esi
  802a03:	89 c1                	mov    %eax,%ecx
  802a05:	d3 eb                	shr    %cl,%ebx
  802a07:	09 de                	or     %ebx,%esi
  802a09:	89 f0                	mov    %esi,%eax
  802a0b:	f7 74 24 08          	divl   0x8(%esp)
  802a0f:	89 d6                	mov    %edx,%esi
  802a11:	89 c3                	mov    %eax,%ebx
  802a13:	f7 64 24 0c          	mull   0xc(%esp)
  802a17:	39 d6                	cmp    %edx,%esi
  802a19:	72 15                	jb     802a30 <__udivdi3+0x100>
  802a1b:	89 f9                	mov    %edi,%ecx
  802a1d:	d3 e5                	shl    %cl,%ebp
  802a1f:	39 c5                	cmp    %eax,%ebp
  802a21:	73 04                	jae    802a27 <__udivdi3+0xf7>
  802a23:	39 d6                	cmp    %edx,%esi
  802a25:	74 09                	je     802a30 <__udivdi3+0x100>
  802a27:	89 d8                	mov    %ebx,%eax
  802a29:	31 ff                	xor    %edi,%edi
  802a2b:	e9 27 ff ff ff       	jmp    802957 <__udivdi3+0x27>
  802a30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a33:	31 ff                	xor    %edi,%edi
  802a35:	e9 1d ff ff ff       	jmp    802957 <__udivdi3+0x27>
  802a3a:	66 90                	xchg   %ax,%ax
  802a3c:	66 90                	xchg   %ax,%ax
  802a3e:	66 90                	xchg   %ax,%ax

00802a40 <__umoddi3>:
  802a40:	55                   	push   %ebp
  802a41:	57                   	push   %edi
  802a42:	56                   	push   %esi
  802a43:	53                   	push   %ebx
  802a44:	83 ec 1c             	sub    $0x1c,%esp
  802a47:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a57:	89 da                	mov    %ebx,%edx
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	75 43                	jne    802aa0 <__umoddi3+0x60>
  802a5d:	39 df                	cmp    %ebx,%edi
  802a5f:	76 17                	jbe    802a78 <__umoddi3+0x38>
  802a61:	89 f0                	mov    %esi,%eax
  802a63:	f7 f7                	div    %edi
  802a65:	89 d0                	mov    %edx,%eax
  802a67:	31 d2                	xor    %edx,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	89 fd                	mov    %edi,%ebp
  802a7a:	85 ff                	test   %edi,%edi
  802a7c:	75 0b                	jne    802a89 <__umoddi3+0x49>
  802a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a83:	31 d2                	xor    %edx,%edx
  802a85:	f7 f7                	div    %edi
  802a87:	89 c5                	mov    %eax,%ebp
  802a89:	89 d8                	mov    %ebx,%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	f7 f5                	div    %ebp
  802a8f:	89 f0                	mov    %esi,%eax
  802a91:	f7 f5                	div    %ebp
  802a93:	89 d0                	mov    %edx,%eax
  802a95:	eb d0                	jmp    802a67 <__umoddi3+0x27>
  802a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a9e:	66 90                	xchg   %ax,%ax
  802aa0:	89 f1                	mov    %esi,%ecx
  802aa2:	39 d8                	cmp    %ebx,%eax
  802aa4:	76 0a                	jbe    802ab0 <__umoddi3+0x70>
  802aa6:	89 f0                	mov    %esi,%eax
  802aa8:	83 c4 1c             	add    $0x1c,%esp
  802aab:	5b                   	pop    %ebx
  802aac:	5e                   	pop    %esi
  802aad:	5f                   	pop    %edi
  802aae:	5d                   	pop    %ebp
  802aaf:	c3                   	ret    
  802ab0:	0f bd e8             	bsr    %eax,%ebp
  802ab3:	83 f5 1f             	xor    $0x1f,%ebp
  802ab6:	75 20                	jne    802ad8 <__umoddi3+0x98>
  802ab8:	39 d8                	cmp    %ebx,%eax
  802aba:	0f 82 b0 00 00 00    	jb     802b70 <__umoddi3+0x130>
  802ac0:	39 f7                	cmp    %esi,%edi
  802ac2:	0f 86 a8 00 00 00    	jbe    802b70 <__umoddi3+0x130>
  802ac8:	89 c8                	mov    %ecx,%eax
  802aca:	83 c4 1c             	add    $0x1c,%esp
  802acd:	5b                   	pop    %ebx
  802ace:	5e                   	pop    %esi
  802acf:	5f                   	pop    %edi
  802ad0:	5d                   	pop    %ebp
  802ad1:	c3                   	ret    
  802ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ad8:	89 e9                	mov    %ebp,%ecx
  802ada:	ba 20 00 00 00       	mov    $0x20,%edx
  802adf:	29 ea                	sub    %ebp,%edx
  802ae1:	d3 e0                	shl    %cl,%eax
  802ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ae7:	89 d1                	mov    %edx,%ecx
  802ae9:	89 f8                	mov    %edi,%eax
  802aeb:	d3 e8                	shr    %cl,%eax
  802aed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802af1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802af5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802af9:	09 c1                	or     %eax,%ecx
  802afb:	89 d8                	mov    %ebx,%eax
  802afd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b01:	89 e9                	mov    %ebp,%ecx
  802b03:	d3 e7                	shl    %cl,%edi
  802b05:	89 d1                	mov    %edx,%ecx
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b0f:	d3 e3                	shl    %cl,%ebx
  802b11:	89 c7                	mov    %eax,%edi
  802b13:	89 d1                	mov    %edx,%ecx
  802b15:	89 f0                	mov    %esi,%eax
  802b17:	d3 e8                	shr    %cl,%eax
  802b19:	89 e9                	mov    %ebp,%ecx
  802b1b:	89 fa                	mov    %edi,%edx
  802b1d:	d3 e6                	shl    %cl,%esi
  802b1f:	09 d8                	or     %ebx,%eax
  802b21:	f7 74 24 08          	divl   0x8(%esp)
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	89 f3                	mov    %esi,%ebx
  802b29:	f7 64 24 0c          	mull   0xc(%esp)
  802b2d:	89 c6                	mov    %eax,%esi
  802b2f:	89 d7                	mov    %edx,%edi
  802b31:	39 d1                	cmp    %edx,%ecx
  802b33:	72 06                	jb     802b3b <__umoddi3+0xfb>
  802b35:	75 10                	jne    802b47 <__umoddi3+0x107>
  802b37:	39 c3                	cmp    %eax,%ebx
  802b39:	73 0c                	jae    802b47 <__umoddi3+0x107>
  802b3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b43:	89 d7                	mov    %edx,%edi
  802b45:	89 c6                	mov    %eax,%esi
  802b47:	89 ca                	mov    %ecx,%edx
  802b49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b4e:	29 f3                	sub    %esi,%ebx
  802b50:	19 fa                	sbb    %edi,%edx
  802b52:	89 d0                	mov    %edx,%eax
  802b54:	d3 e0                	shl    %cl,%eax
  802b56:	89 e9                	mov    %ebp,%ecx
  802b58:	d3 eb                	shr    %cl,%ebx
  802b5a:	d3 ea                	shr    %cl,%edx
  802b5c:	09 d8                	or     %ebx,%eax
  802b5e:	83 c4 1c             	add    $0x1c,%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5f                   	pop    %edi
  802b64:	5d                   	pop    %ebp
  802b65:	c3                   	ret    
  802b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b6d:	8d 76 00             	lea    0x0(%esi),%esi
  802b70:	89 da                	mov    %ebx,%edx
  802b72:	29 fe                	sub    %edi,%esi
  802b74:	19 c2                	sbb    %eax,%edx
  802b76:	89 f1                	mov    %esi,%ecx
  802b78:	89 c8                	mov    %ecx,%eax
  802b7a:	e9 4b ff ff ff       	jmp    802aca <__umoddi3+0x8a>
