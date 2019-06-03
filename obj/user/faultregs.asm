
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
  800044:	68 5f 2c 80 00       	push   $0x802c5f
  800049:	68 40 2b 80 00       	push   $0x802b40
  80004e:	e8 40 07 00 00       	call   800793 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 50 2b 80 00       	push   $0x802b50
  80005c:	68 54 2b 80 00       	push   $0x802b54
  800061:	e8 2d 07 00 00       	call   800793 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 68 2b 80 00       	push   $0x802b68
  80007b:	e8 13 07 00 00       	call   800793 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 72 2b 80 00       	push   $0x802b72
  800093:	68 54 2b 80 00       	push   $0x802b54
  800098:	e8 f6 06 00 00       	call   800793 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 68 2b 80 00       	push   $0x802b68
  8000b4:	e8 da 06 00 00       	call   800793 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 76 2b 80 00       	push   $0x802b76
  8000cc:	68 54 2b 80 00       	push   $0x802b54
  8000d1:	e8 bd 06 00 00       	call   800793 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 68 2b 80 00       	push   $0x802b68
  8000ed:	e8 a1 06 00 00       	call   800793 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 7a 2b 80 00       	push   $0x802b7a
  800105:	68 54 2b 80 00       	push   $0x802b54
  80010a:	e8 84 06 00 00       	call   800793 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 68 2b 80 00       	push   $0x802b68
  800126:	e8 68 06 00 00       	call   800793 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 7e 2b 80 00       	push   $0x802b7e
  80013e:	68 54 2b 80 00       	push   $0x802b54
  800143:	e8 4b 06 00 00       	call   800793 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 68 2b 80 00       	push   $0x802b68
  80015f:	e8 2f 06 00 00       	call   800793 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 82 2b 80 00       	push   $0x802b82
  800177:	68 54 2b 80 00       	push   $0x802b54
  80017c:	e8 12 06 00 00       	call   800793 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 68 2b 80 00       	push   $0x802b68
  800198:	e8 f6 05 00 00       	call   800793 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 86 2b 80 00       	push   $0x802b86
  8001b0:	68 54 2b 80 00       	push   $0x802b54
  8001b5:	e8 d9 05 00 00       	call   800793 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 68 2b 80 00       	push   $0x802b68
  8001d1:	e8 bd 05 00 00       	call   800793 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 8a 2b 80 00       	push   $0x802b8a
  8001e9:	68 54 2b 80 00       	push   $0x802b54
  8001ee:	e8 a0 05 00 00       	call   800793 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 68 2b 80 00       	push   $0x802b68
  80020a:	e8 84 05 00 00       	call   800793 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 8e 2b 80 00       	push   $0x802b8e
  800222:	68 54 2b 80 00       	push   $0x802b54
  800227:	e8 67 05 00 00       	call   800793 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 68 2b 80 00       	push   $0x802b68
  800243:	e8 4b 05 00 00       	call   800793 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 95 2b 80 00       	push   $0x802b95
  800253:	68 54 2b 80 00       	push   $0x802b54
  800258:	e8 36 05 00 00       	call   800793 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 68 2b 80 00       	push   $0x802b68
  800274:	e8 1a 05 00 00       	call   800793 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 99 2b 80 00       	push   $0x802b99
  800284:	e8 0a 05 00 00       	call   800793 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 68 2b 80 00       	push   $0x802b68
  800294:	e8 fa 04 00 00       	call   800793 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 64 2b 80 00       	push   $0x802b64
  8002a9:	e8 e5 04 00 00       	call   800793 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 64 2b 80 00       	push   $0x802b64
  8002c3:	e8 cb 04 00 00       	call   800793 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 64 2b 80 00       	push   $0x802b64
  8002d8:	e8 b6 04 00 00       	call   800793 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 64 2b 80 00       	push   $0x802b64
  8002ed:	e8 a1 04 00 00       	call   800793 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 64 2b 80 00       	push   $0x802b64
  800302:	e8 8c 04 00 00       	call   800793 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 64 2b 80 00       	push   $0x802b64
  800317:	e8 77 04 00 00       	call   800793 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 64 2b 80 00       	push   $0x802b64
  80032c:	e8 62 04 00 00       	call   800793 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 64 2b 80 00       	push   $0x802b64
  800341:	e8 4d 04 00 00       	call   800793 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 64 2b 80 00       	push   $0x802b64
  800356:	e8 38 04 00 00       	call   800793 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 95 2b 80 00       	push   $0x802b95
  800366:	68 54 2b 80 00       	push   $0x802b54
  80036b:	e8 23 04 00 00       	call   800793 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 64 2b 80 00       	push   $0x802b64
  800387:	e8 07 04 00 00       	call   800793 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 99 2b 80 00       	push   $0x802b99
  800397:	e8 f7 03 00 00       	call   800793 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 64 2b 80 00       	push   $0x802b64
  8003af:	e8 df 03 00 00       	call   800793 <cprintf>
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
  8003c2:	68 64 2b 80 00       	push   $0x802b64
  8003c7:	e8 c7 03 00 00       	call   800793 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 99 2b 80 00       	push   $0x802b99
  8003d7:	e8 b7 03 00 00       	call   800793 <cprintf>
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
  800466:	68 bf 2b 80 00       	push   $0x802bbf
  80046b:	68 cd 2b 80 00       	push   $0x802bcd
  800470:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800475:	ba b8 2b 80 00       	mov    $0x802bb8,%edx
  80047a:	b8 80 50 80 00       	mov    $0x805080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 4f 0e 00 00       	call   8012e4 <sys_page_alloc>
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
  8004a5:	68 00 2c 80 00       	push   $0x802c00
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 a7 2b 80 00       	push   $0x802ba7
  8004b1:	e8 e7 01 00 00       	call   80069d <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 d4 2b 80 00       	push   $0x802bd4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 a7 2b 80 00       	push   $0x802ba7
  8004c3:	e8 d5 01 00 00       	call   80069d <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 e1 10 00 00       	call   8015b9 <set_pgfault_handler>

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
  8005ac:	68 e7 2b 80 00       	push   $0x802be7
  8005b1:	68 f8 2b 80 00       	push   $0x802bf8
  8005b6:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005bb:	ba b8 2b 80 00       	mov    $0x802bb8,%edx
  8005c0:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 34 2c 80 00       	push   $0x802c34
  8005d7:	e8 b7 01 00 00       	call   800793 <cprintf>
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
  8005f4:	e8 ad 0c 00 00       	call   8012a6 <sys_getenvid>
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

	cprintf("call umain!\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 53 2c 80 00       	push   $0x802c53
  800660:	e8 2e 01 00 00       	call   800793 <cprintf>
	// call user main routine
	umain(argc, argv);
  800665:	83 c4 08             	add    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	ff 75 08             	pushl  0x8(%ebp)
  80066e:	e8 55 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800673:	e8 0b 00 00 00       	call   800683 <exit>
}
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067e:	5b                   	pop    %ebx
  80067f:	5e                   	pop    %esi
  800680:	5f                   	pop    %edi
  800681:	5d                   	pop    %ebp
  800682:	c3                   	ret    

00800683 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800689:	e8 98 11 00 00       	call   801826 <close_all>
	sys_env_destroy(0);
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	6a 00                	push   $0x0
  800693:	e8 cd 0b 00 00       	call   801265 <sys_env_destroy>
}
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	56                   	push   %esi
  8006a1:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006a2:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8006a7:	8b 40 48             	mov    0x48(%eax),%eax
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 9c 2c 80 00       	push   $0x802c9c
  8006b2:	50                   	push   %eax
  8006b3:	68 6a 2c 80 00       	push   $0x802c6a
  8006b8:	e8 d6 00 00 00       	call   800793 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8006bd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006c0:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8006c6:	e8 db 0b 00 00       	call   8012a6 <sys_getenvid>
  8006cb:	83 c4 04             	add    $0x4,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	56                   	push   %esi
  8006d5:	50                   	push   %eax
  8006d6:	68 78 2c 80 00       	push   $0x802c78
  8006db:	e8 b3 00 00 00       	call   800793 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006e0:	83 c4 18             	add    $0x18,%esp
  8006e3:	53                   	push   %ebx
  8006e4:	ff 75 10             	pushl  0x10(%ebp)
  8006e7:	e8 56 00 00 00       	call   800742 <vcprintf>
	cprintf("\n");
  8006ec:	c7 04 24 5e 2c 80 00 	movl   $0x802c5e,(%esp)
  8006f3:	e8 9b 00 00 00       	call   800793 <cprintf>
  8006f8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006fb:	cc                   	int3   
  8006fc:	eb fd                	jmp    8006fb <_panic+0x5e>

008006fe <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	53                   	push   %ebx
  800702:	83 ec 04             	sub    $0x4,%esp
  800705:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800708:	8b 13                	mov    (%ebx),%edx
  80070a:	8d 42 01             	lea    0x1(%edx),%eax
  80070d:	89 03                	mov    %eax,(%ebx)
  80070f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800712:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800716:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071b:	74 09                	je     800726 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80071d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800724:	c9                   	leave  
  800725:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	68 ff 00 00 00       	push   $0xff
  80072e:	8d 43 08             	lea    0x8(%ebx),%eax
  800731:	50                   	push   %eax
  800732:	e8 f1 0a 00 00       	call   801228 <sys_cputs>
		b->idx = 0;
  800737:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	eb db                	jmp    80071d <putch+0x1f>

00800742 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80074b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800752:	00 00 00 
	b.cnt = 0;
  800755:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	ff 75 08             	pushl  0x8(%ebp)
  800765:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	68 fe 06 80 00       	push   $0x8006fe
  800771:	e8 4a 01 00 00       	call   8008c0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800776:	83 c4 08             	add    $0x8,%esp
  800779:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80077f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	e8 9d 0a 00 00       	call   801228 <sys_cputs>

	return b.cnt;
}
  80078b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800799:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80079c:	50                   	push   %eax
  80079d:	ff 75 08             	pushl  0x8(%ebp)
  8007a0:	e8 9d ff ff ff       	call   800742 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007a5:	c9                   	leave  
  8007a6:	c3                   	ret    

008007a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	57                   	push   %edi
  8007ab:	56                   	push   %esi
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 1c             	sub    $0x1c,%esp
  8007b0:	89 c6                	mov    %eax,%esi
  8007b2:	89 d7                	mov    %edx,%edi
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8007c6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8007ca:	74 2c                	je     8007f8 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8007cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8007d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8007e1:	73 43                	jae    800826 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8007e3:	83 eb 01             	sub    $0x1,%ebx
  8007e6:	85 db                	test   %ebx,%ebx
  8007e8:	7e 6c                	jle    800856 <printnum+0xaf>
				putch(padc, putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	57                   	push   %edi
  8007ee:	ff 75 18             	pushl  0x18(%ebp)
  8007f1:	ff d6                	call   *%esi
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	eb eb                	jmp    8007e3 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	6a 20                	push   $0x20
  8007fd:	6a 00                	push   $0x0
  8007ff:	50                   	push   %eax
  800800:	ff 75 e4             	pushl  -0x1c(%ebp)
  800803:	ff 75 e0             	pushl  -0x20(%ebp)
  800806:	89 fa                	mov    %edi,%edx
  800808:	89 f0                	mov    %esi,%eax
  80080a:	e8 98 ff ff ff       	call   8007a7 <printnum>
		while (--width > 0)
  80080f:	83 c4 20             	add    $0x20,%esp
  800812:	83 eb 01             	sub    $0x1,%ebx
  800815:	85 db                	test   %ebx,%ebx
  800817:	7e 65                	jle    80087e <printnum+0xd7>
			putch(padc, putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	57                   	push   %edi
  80081d:	6a 20                	push   $0x20
  80081f:	ff d6                	call   *%esi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	eb ec                	jmp    800812 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800826:	83 ec 0c             	sub    $0xc,%esp
  800829:	ff 75 18             	pushl  0x18(%ebp)
  80082c:	83 eb 01             	sub    $0x1,%ebx
  80082f:	53                   	push   %ebx
  800830:	50                   	push   %eax
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 dc             	pushl  -0x24(%ebp)
  800837:	ff 75 d8             	pushl  -0x28(%ebp)
  80083a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083d:	ff 75 e0             	pushl  -0x20(%ebp)
  800840:	e8 9b 20 00 00       	call   8028e0 <__udivdi3>
  800845:	83 c4 18             	add    $0x18,%esp
  800848:	52                   	push   %edx
  800849:	50                   	push   %eax
  80084a:	89 fa                	mov    %edi,%edx
  80084c:	89 f0                	mov    %esi,%eax
  80084e:	e8 54 ff ff ff       	call   8007a7 <printnum>
  800853:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	57                   	push   %edi
  80085a:	83 ec 04             	sub    $0x4,%esp
  80085d:	ff 75 dc             	pushl  -0x24(%ebp)
  800860:	ff 75 d8             	pushl  -0x28(%ebp)
  800863:	ff 75 e4             	pushl  -0x1c(%ebp)
  800866:	ff 75 e0             	pushl  -0x20(%ebp)
  800869:	e8 82 21 00 00       	call   8029f0 <__umoddi3>
  80086e:	83 c4 14             	add    $0x14,%esp
  800871:	0f be 80 a3 2c 80 00 	movsbl 0x802ca3(%eax),%eax
  800878:	50                   	push   %eax
  800879:	ff d6                	call   *%esi
  80087b:	83 c4 10             	add    $0x10,%esp
	}
}
  80087e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800881:	5b                   	pop    %ebx
  800882:	5e                   	pop    %esi
  800883:	5f                   	pop    %edi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80088c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800890:	8b 10                	mov    (%eax),%edx
  800892:	3b 50 04             	cmp    0x4(%eax),%edx
  800895:	73 0a                	jae    8008a1 <sprintputch+0x1b>
		*b->buf++ = ch;
  800897:	8d 4a 01             	lea    0x1(%edx),%ecx
  80089a:	89 08                	mov    %ecx,(%eax)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	88 02                	mov    %al,(%edx)
}
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <printfmt>:
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008a9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008ac:	50                   	push   %eax
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	ff 75 08             	pushl  0x8(%ebp)
  8008b6:	e8 05 00 00 00       	call   8008c0 <vprintfmt>
}
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <vprintfmt>:
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	57                   	push   %edi
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
  8008c6:	83 ec 3c             	sub    $0x3c,%esp
  8008c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008d2:	e9 32 04 00 00       	jmp    800d09 <vprintfmt+0x449>
		padc = ' ';
  8008d7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8008db:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8008e2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8008e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008f7:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8008fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800903:	8d 47 01             	lea    0x1(%edi),%eax
  800906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800909:	0f b6 17             	movzbl (%edi),%edx
  80090c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80090f:	3c 55                	cmp    $0x55,%al
  800911:	0f 87 12 05 00 00    	ja     800e29 <vprintfmt+0x569>
  800917:	0f b6 c0             	movzbl %al,%eax
  80091a:	ff 24 85 80 2e 80 00 	jmp    *0x802e80(,%eax,4)
  800921:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800924:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800928:	eb d9                	jmp    800903 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80092d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800931:	eb d0                	jmp    800903 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800933:	0f b6 d2             	movzbl %dl,%edx
  800936:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800939:	b8 00 00 00 00       	mov    $0x0,%eax
  80093e:	89 75 08             	mov    %esi,0x8(%ebp)
  800941:	eb 03                	jmp    800946 <vprintfmt+0x86>
  800943:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800946:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800949:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80094d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800950:	8d 72 d0             	lea    -0x30(%edx),%esi
  800953:	83 fe 09             	cmp    $0x9,%esi
  800956:	76 eb                	jbe    800943 <vprintfmt+0x83>
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	eb 14                	jmp    800974 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8d 40 04             	lea    0x4(%eax),%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800971:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 89                	jns    800903 <vprintfmt+0x43>
				width = precision, precision = -1;
  80097a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80097d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800980:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800987:	e9 77 ff ff ff       	jmp    800903 <vprintfmt+0x43>
  80098c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098f:	85 c0                	test   %eax,%eax
  800991:	0f 48 c1             	cmovs  %ecx,%eax
  800994:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80099a:	e9 64 ff ff ff       	jmp    800903 <vprintfmt+0x43>
  80099f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009a2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8009a9:	e9 55 ff ff ff       	jmp    800903 <vprintfmt+0x43>
			lflag++;
  8009ae:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009b5:	e9 49 ff ff ff       	jmp    800903 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8d 78 04             	lea    0x4(%eax),%edi
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	53                   	push   %ebx
  8009c4:	ff 30                	pushl  (%eax)
  8009c6:	ff d6                	call   *%esi
			break;
  8009c8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009cb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009ce:	e9 33 03 00 00       	jmp    800d06 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8009d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d6:	8d 78 04             	lea    0x4(%eax),%edi
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	99                   	cltd   
  8009dc:	31 d0                	xor    %edx,%eax
  8009de:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009e0:	83 f8 10             	cmp    $0x10,%eax
  8009e3:	7f 23                	jg     800a08 <vprintfmt+0x148>
  8009e5:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8009ec:	85 d2                	test   %edx,%edx
  8009ee:	74 18                	je     800a08 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8009f0:	52                   	push   %edx
  8009f1:	68 75 31 80 00       	push   $0x803175
  8009f6:	53                   	push   %ebx
  8009f7:	56                   	push   %esi
  8009f8:	e8 a6 fe ff ff       	call   8008a3 <printfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a00:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a03:	e9 fe 02 00 00       	jmp    800d06 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a08:	50                   	push   %eax
  800a09:	68 bb 2c 80 00       	push   $0x802cbb
  800a0e:	53                   	push   %ebx
  800a0f:	56                   	push   %esi
  800a10:	e8 8e fe ff ff       	call   8008a3 <printfmt>
  800a15:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a18:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a1b:	e9 e6 02 00 00       	jmp    800d06 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a2e:	85 c9                	test   %ecx,%ecx
  800a30:	b8 b4 2c 80 00       	mov    $0x802cb4,%eax
  800a35:	0f 45 c1             	cmovne %ecx,%eax
  800a38:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800a3b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3f:	7e 06                	jle    800a47 <vprintfmt+0x187>
  800a41:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a45:	75 0d                	jne    800a54 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a47:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a4a:	89 c7                	mov    %eax,%edi
  800a4c:	03 45 e0             	add    -0x20(%ebp),%eax
  800a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a52:	eb 53                	jmp    800aa7 <vprintfmt+0x1e7>
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 d8             	pushl  -0x28(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	e8 71 04 00 00       	call   800ed1 <strnlen>
  800a60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a63:	29 c1                	sub    %eax,%ecx
  800a65:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a6d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800a71:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a74:	eb 0f                	jmp    800a85 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	53                   	push   %ebx
  800a7a:	ff 75 e0             	pushl  -0x20(%ebp)
  800a7d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7f:	83 ef 01             	sub    $0x1,%edi
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	85 ff                	test   %edi,%edi
  800a87:	7f ed                	jg     800a76 <vprintfmt+0x1b6>
  800a89:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800a8c:	85 c9                	test   %ecx,%ecx
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a93:	0f 49 c1             	cmovns %ecx,%eax
  800a96:	29 c1                	sub    %eax,%ecx
  800a98:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a9b:	eb aa                	jmp    800a47 <vprintfmt+0x187>
					putch(ch, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	53                   	push   %ebx
  800aa1:	52                   	push   %edx
  800aa2:	ff d6                	call   *%esi
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800aaa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aac:	83 c7 01             	add    $0x1,%edi
  800aaf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab3:	0f be d0             	movsbl %al,%edx
  800ab6:	85 d2                	test   %edx,%edx
  800ab8:	74 4b                	je     800b05 <vprintfmt+0x245>
  800aba:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800abe:	78 06                	js     800ac6 <vprintfmt+0x206>
  800ac0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800ac4:	78 1e                	js     800ae4 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800ac6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800aca:	74 d1                	je     800a9d <vprintfmt+0x1dd>
  800acc:	0f be c0             	movsbl %al,%eax
  800acf:	83 e8 20             	sub    $0x20,%eax
  800ad2:	83 f8 5e             	cmp    $0x5e,%eax
  800ad5:	76 c6                	jbe    800a9d <vprintfmt+0x1dd>
					putch('?', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	53                   	push   %ebx
  800adb:	6a 3f                	push   $0x3f
  800add:	ff d6                	call   *%esi
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	eb c3                	jmp    800aa7 <vprintfmt+0x1e7>
  800ae4:	89 cf                	mov    %ecx,%edi
  800ae6:	eb 0e                	jmp    800af6 <vprintfmt+0x236>
				putch(' ', putdat);
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	53                   	push   %ebx
  800aec:	6a 20                	push   $0x20
  800aee:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800af0:	83 ef 01             	sub    $0x1,%edi
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	85 ff                	test   %edi,%edi
  800af8:	7f ee                	jg     800ae8 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800afa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	e9 01 02 00 00       	jmp    800d06 <vprintfmt+0x446>
  800b05:	89 cf                	mov    %ecx,%edi
  800b07:	eb ed                	jmp    800af6 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800b0c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800b13:	e9 eb fd ff ff       	jmp    800903 <vprintfmt+0x43>
	if (lflag >= 2)
  800b18:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b1c:	7f 21                	jg     800b3f <vprintfmt+0x27f>
	else if (lflag)
  800b1e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b22:	74 68                	je     800b8c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b2c:	89 c1                	mov    %eax,%ecx
  800b2e:	c1 f9 1f             	sar    $0x1f,%ecx
  800b31:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	8d 40 04             	lea    0x4(%eax),%eax
  800b3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3d:	eb 17                	jmp    800b56 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	8b 50 04             	mov    0x4(%eax),%edx
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8d 40 08             	lea    0x8(%eax),%eax
  800b53:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b56:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b59:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800b62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b66:	78 3f                	js     800ba7 <vprintfmt+0x2e7>
			base = 10;
  800b68:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800b6d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800b71:	0f 84 71 01 00 00    	je     800ce8 <vprintfmt+0x428>
				putch('+', putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	53                   	push   %ebx
  800b7b:	6a 2b                	push   $0x2b
  800b7d:	ff d6                	call   *%esi
  800b7f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b87:	e9 5c 01 00 00       	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b94:	89 c1                	mov    %eax,%ecx
  800b96:	c1 f9 1f             	sar    $0x1f,%ecx
  800b99:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9f:	8d 40 04             	lea    0x4(%eax),%eax
  800ba2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba5:	eb af                	jmp    800b56 <vprintfmt+0x296>
				putch('-', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	53                   	push   %ebx
  800bab:	6a 2d                	push   $0x2d
  800bad:	ff d6                	call   *%esi
				num = -(long long) num;
  800baf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	e9 19 01 00 00       	jmp    800ce8 <vprintfmt+0x428>
	if (lflag >= 2)
  800bcf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800bd3:	7f 29                	jg     800bfe <vprintfmt+0x33e>
	else if (lflag)
  800bd5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800bd9:	74 44                	je     800c1f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	ba 00 00 00 00       	mov    $0x0,%edx
  800be5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800beb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bee:	8d 40 04             	lea    0x4(%eax),%eax
  800bf1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf9:	e9 ea 00 00 00       	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	8b 50 04             	mov    0x4(%eax),%edx
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c09:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	8d 40 08             	lea    0x8(%eax),%eax
  800c12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c15:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1a:	e9 c9 00 00 00       	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	8b 00                	mov    (%eax),%eax
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	8d 40 04             	lea    0x4(%eax),%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3d:	e9 a6 00 00 00       	jmp    800ce8 <vprintfmt+0x428>
			putch('0', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	53                   	push   %ebx
  800c46:	6a 30                	push   $0x30
  800c48:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c51:	7f 26                	jg     800c79 <vprintfmt+0x3b9>
	else if (lflag)
  800c53:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c57:	74 3e                	je     800c97 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800c59:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5c:	8b 00                	mov    (%eax),%eax
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c66:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	8d 40 04             	lea    0x4(%eax),%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c72:	b8 08 00 00 00       	mov    $0x8,%eax
  800c77:	eb 6f                	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c79:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7c:	8b 50 04             	mov    0x4(%eax),%edx
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c84:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	8d 40 08             	lea    0x8(%eax),%eax
  800c8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c90:	b8 08 00 00 00       	mov    $0x8,%eax
  800c95:	eb 51                	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	8d 40 04             	lea    0x4(%eax),%eax
  800cad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb5:	eb 31                	jmp    800ce8 <vprintfmt+0x428>
			putch('0', putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	53                   	push   %ebx
  800cbb:	6a 30                	push   $0x30
  800cbd:	ff d6                	call   *%esi
			putch('x', putdat);
  800cbf:	83 c4 08             	add    $0x8,%esp
  800cc2:	53                   	push   %ebx
  800cc3:	6a 78                	push   $0x78
  800cc5:	ff d6                	call   *%esi
			num = (unsigned long long)
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	8b 00                	mov    (%eax),%eax
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800cd7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	8d 40 04             	lea    0x4(%eax),%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ce3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800cef:	52                   	push   %edx
  800cf0:	ff 75 e0             	pushl  -0x20(%ebp)
  800cf3:	50                   	push   %eax
  800cf4:	ff 75 dc             	pushl  -0x24(%ebp)
  800cf7:	ff 75 d8             	pushl  -0x28(%ebp)
  800cfa:	89 da                	mov    %ebx,%edx
  800cfc:	89 f0                	mov    %esi,%eax
  800cfe:	e8 a4 fa ff ff       	call   8007a7 <printnum>
			break;
  800d03:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d09:	83 c7 01             	add    $0x1,%edi
  800d0c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d10:	83 f8 25             	cmp    $0x25,%eax
  800d13:	0f 84 be fb ff ff    	je     8008d7 <vprintfmt+0x17>
			if (ch == '\0')
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	0f 84 28 01 00 00    	je     800e49 <vprintfmt+0x589>
			putch(ch, putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	53                   	push   %ebx
  800d25:	50                   	push   %eax
  800d26:	ff d6                	call   *%esi
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	eb dc                	jmp    800d09 <vprintfmt+0x449>
	if (lflag >= 2)
  800d2d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d31:	7f 26                	jg     800d59 <vprintfmt+0x499>
	else if (lflag)
  800d33:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d37:	74 41                	je     800d7a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800d39:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d46:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	8d 40 04             	lea    0x4(%eax),%eax
  800d4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d52:	b8 10 00 00 00       	mov    $0x10,%eax
  800d57:	eb 8f                	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	8b 50 04             	mov    0x4(%eax),%edx
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	8d 40 08             	lea    0x8(%eax),%eax
  800d6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d70:	b8 10 00 00 00       	mov    $0x10,%eax
  800d75:	e9 6e ff ff ff       	jmp    800ce8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800d7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8d:	8d 40 04             	lea    0x4(%eax),%eax
  800d90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d93:	b8 10 00 00 00       	mov    $0x10,%eax
  800d98:	e9 4b ff ff ff       	jmp    800ce8 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800da0:	83 c0 04             	add    $0x4,%eax
  800da3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800da6:	8b 45 14             	mov    0x14(%ebp),%eax
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	85 c0                	test   %eax,%eax
  800dad:	74 14                	je     800dc3 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800daf:	8b 13                	mov    (%ebx),%edx
  800db1:	83 fa 7f             	cmp    $0x7f,%edx
  800db4:	7f 37                	jg     800ded <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800db6:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800db8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	e9 43 ff ff ff       	jmp    800d06 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800dc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc8:	bf d9 2d 80 00       	mov    $0x802dd9,%edi
							putch(ch, putdat);
  800dcd:	83 ec 08             	sub    $0x8,%esp
  800dd0:	53                   	push   %ebx
  800dd1:	50                   	push   %eax
  800dd2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800dd4:	83 c7 01             	add    $0x1,%edi
  800dd7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	85 c0                	test   %eax,%eax
  800de0:	75 eb                	jne    800dcd <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800de2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800de5:	89 45 14             	mov    %eax,0x14(%ebp)
  800de8:	e9 19 ff ff ff       	jmp    800d06 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ded:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800def:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df4:	bf 11 2e 80 00       	mov    $0x802e11,%edi
							putch(ch, putdat);
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	53                   	push   %ebx
  800dfd:	50                   	push   %eax
  800dfe:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e00:	83 c7 01             	add    $0x1,%edi
  800e03:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e07:	83 c4 10             	add    $0x10,%esp
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	75 eb                	jne    800df9 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800e0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e11:	89 45 14             	mov    %eax,0x14(%ebp)
  800e14:	e9 ed fe ff ff       	jmp    800d06 <vprintfmt+0x446>
			putch(ch, putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	53                   	push   %ebx
  800e1d:	6a 25                	push   $0x25
  800e1f:	ff d6                	call   *%esi
			break;
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	e9 dd fe ff ff       	jmp    800d06 <vprintfmt+0x446>
			putch('%', putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	53                   	push   %ebx
  800e2d:	6a 25                	push   $0x25
  800e2f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e31:	83 c4 10             	add    $0x10,%esp
  800e34:	89 f8                	mov    %edi,%eax
  800e36:	eb 03                	jmp    800e3b <vprintfmt+0x57b>
  800e38:	83 e8 01             	sub    $0x1,%eax
  800e3b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e3f:	75 f7                	jne    800e38 <vprintfmt+0x578>
  800e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e44:	e9 bd fe ff ff       	jmp    800d06 <vprintfmt+0x446>
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 18             	sub    $0x18,%esp
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e60:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e64:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	74 26                	je     800e98 <vsnprintf+0x47>
  800e72:	85 d2                	test   %edx,%edx
  800e74:	7e 22                	jle    800e98 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e76:	ff 75 14             	pushl  0x14(%ebp)
  800e79:	ff 75 10             	pushl  0x10(%ebp)
  800e7c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e7f:	50                   	push   %eax
  800e80:	68 86 08 80 00       	push   $0x800886
  800e85:	e8 36 fa ff ff       	call   8008c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e93:	83 c4 10             	add    $0x10,%esp
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    
		return -E_INVAL;
  800e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9d:	eb f7                	jmp    800e96 <vsnprintf+0x45>

00800e9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ea8:	50                   	push   %eax
  800ea9:	ff 75 10             	pushl  0x10(%ebp)
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 9a ff ff ff       	call   800e51 <vsnprintf>
	va_end(ap);

	return rc;
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ec8:	74 05                	je     800ecf <strlen+0x16>
		n++;
  800eca:	83 c0 01             	add    $0x1,%eax
  800ecd:	eb f5                	jmp    800ec4 <strlen+0xb>
	return n;
}
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eda:	ba 00 00 00 00       	mov    $0x0,%edx
  800edf:	39 c2                	cmp    %eax,%edx
  800ee1:	74 0d                	je     800ef0 <strnlen+0x1f>
  800ee3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ee7:	74 05                	je     800eee <strnlen+0x1d>
		n++;
  800ee9:	83 c2 01             	add    $0x1,%edx
  800eec:	eb f1                	jmp    800edf <strnlen+0xe>
  800eee:	89 d0                	mov    %edx,%eax
	return n;
}
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	53                   	push   %ebx
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800efc:	ba 00 00 00 00       	mov    $0x0,%edx
  800f01:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f05:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f08:	83 c2 01             	add    $0x1,%edx
  800f0b:	84 c9                	test   %cl,%cl
  800f0d:	75 f2                	jne    800f01 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f0f:	5b                   	pop    %ebx
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	53                   	push   %ebx
  800f16:	83 ec 10             	sub    $0x10,%esp
  800f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f1c:	53                   	push   %ebx
  800f1d:	e8 97 ff ff ff       	call   800eb9 <strlen>
  800f22:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	01 d8                	add    %ebx,%eax
  800f2a:	50                   	push   %eax
  800f2b:	e8 c2 ff ff ff       	call   800ef2 <strcpy>
	return dst;
}
  800f30:	89 d8                	mov    %ebx,%eax
  800f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	89 c6                	mov    %eax,%esi
  800f44:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f47:	89 c2                	mov    %eax,%edx
  800f49:	39 f2                	cmp    %esi,%edx
  800f4b:	74 11                	je     800f5e <strncpy+0x27>
		*dst++ = *src;
  800f4d:	83 c2 01             	add    $0x1,%edx
  800f50:	0f b6 19             	movzbl (%ecx),%ebx
  800f53:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f56:	80 fb 01             	cmp    $0x1,%bl
  800f59:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800f5c:	eb eb                	jmp    800f49 <strncpy+0x12>
	}
	return ret;
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
  800f67:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6d:	8b 55 10             	mov    0x10(%ebp),%edx
  800f70:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f72:	85 d2                	test   %edx,%edx
  800f74:	74 21                	je     800f97 <strlcpy+0x35>
  800f76:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f7a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	74 14                	je     800f94 <strlcpy+0x32>
  800f80:	0f b6 19             	movzbl (%ecx),%ebx
  800f83:	84 db                	test   %bl,%bl
  800f85:	74 0b                	je     800f92 <strlcpy+0x30>
			*dst++ = *src++;
  800f87:	83 c1 01             	add    $0x1,%ecx
  800f8a:	83 c2 01             	add    $0x1,%edx
  800f8d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f90:	eb ea                	jmp    800f7c <strlcpy+0x1a>
  800f92:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f97:	29 f0                	sub    %esi,%eax
}
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fa6:	0f b6 01             	movzbl (%ecx),%eax
  800fa9:	84 c0                	test   %al,%al
  800fab:	74 0c                	je     800fb9 <strcmp+0x1c>
  800fad:	3a 02                	cmp    (%edx),%al
  800faf:	75 08                	jne    800fb9 <strcmp+0x1c>
		p++, q++;
  800fb1:	83 c1 01             	add    $0x1,%ecx
  800fb4:	83 c2 01             	add    $0x1,%edx
  800fb7:	eb ed                	jmp    800fa6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	0f b6 12             	movzbl (%edx),%edx
  800fbf:	29 d0                	sub    %edx,%eax
}
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	53                   	push   %ebx
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	89 c3                	mov    %eax,%ebx
  800fcf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fd2:	eb 06                	jmp    800fda <strncmp+0x17>
		n--, p++, q++;
  800fd4:	83 c0 01             	add    $0x1,%eax
  800fd7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fda:	39 d8                	cmp    %ebx,%eax
  800fdc:	74 16                	je     800ff4 <strncmp+0x31>
  800fde:	0f b6 08             	movzbl (%eax),%ecx
  800fe1:	84 c9                	test   %cl,%cl
  800fe3:	74 04                	je     800fe9 <strncmp+0x26>
  800fe5:	3a 0a                	cmp    (%edx),%cl
  800fe7:	74 eb                	je     800fd4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe9:	0f b6 00             	movzbl (%eax),%eax
  800fec:	0f b6 12             	movzbl (%edx),%edx
  800fef:	29 d0                	sub    %edx,%eax
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5d                   	pop    %ebp
  800ff3:	c3                   	ret    
		return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff9:	eb f6                	jmp    800ff1 <strncmp+0x2e>

00800ffb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801005:	0f b6 10             	movzbl (%eax),%edx
  801008:	84 d2                	test   %dl,%dl
  80100a:	74 09                	je     801015 <strchr+0x1a>
		if (*s == c)
  80100c:	38 ca                	cmp    %cl,%dl
  80100e:	74 0a                	je     80101a <strchr+0x1f>
	for (; *s; s++)
  801010:	83 c0 01             	add    $0x1,%eax
  801013:	eb f0                	jmp    801005 <strchr+0xa>
			return (char *) s;
	return 0;
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801026:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801029:	38 ca                	cmp    %cl,%dl
  80102b:	74 09                	je     801036 <strfind+0x1a>
  80102d:	84 d2                	test   %dl,%dl
  80102f:	74 05                	je     801036 <strfind+0x1a>
	for (; *s; s++)
  801031:	83 c0 01             	add    $0x1,%eax
  801034:	eb f0                	jmp    801026 <strfind+0xa>
			break;
	return (char *) s;
}
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801041:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801044:	85 c9                	test   %ecx,%ecx
  801046:	74 31                	je     801079 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801048:	89 f8                	mov    %edi,%eax
  80104a:	09 c8                	or     %ecx,%eax
  80104c:	a8 03                	test   $0x3,%al
  80104e:	75 23                	jne    801073 <memset+0x3b>
		c &= 0xFF;
  801050:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801054:	89 d3                	mov    %edx,%ebx
  801056:	c1 e3 08             	shl    $0x8,%ebx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	c1 e0 18             	shl    $0x18,%eax
  80105e:	89 d6                	mov    %edx,%esi
  801060:	c1 e6 10             	shl    $0x10,%esi
  801063:	09 f0                	or     %esi,%eax
  801065:	09 c2                	or     %eax,%edx
  801067:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801069:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80106c:	89 d0                	mov    %edx,%eax
  80106e:	fc                   	cld    
  80106f:	f3 ab                	rep stos %eax,%es:(%edi)
  801071:	eb 06                	jmp    801079 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	fc                   	cld    
  801077:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801079:	89 f8                	mov    %edi,%eax
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	57                   	push   %edi
  801084:	56                   	push   %esi
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80108e:	39 c6                	cmp    %eax,%esi
  801090:	73 32                	jae    8010c4 <memmove+0x44>
  801092:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801095:	39 c2                	cmp    %eax,%edx
  801097:	76 2b                	jbe    8010c4 <memmove+0x44>
		s += n;
		d += n;
  801099:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80109c:	89 fe                	mov    %edi,%esi
  80109e:	09 ce                	or     %ecx,%esi
  8010a0:	09 d6                	or     %edx,%esi
  8010a2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010a8:	75 0e                	jne    8010b8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010aa:	83 ef 04             	sub    $0x4,%edi
  8010ad:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010b0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8010b3:	fd                   	std    
  8010b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010b6:	eb 09                	jmp    8010c1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010b8:	83 ef 01             	sub    $0x1,%edi
  8010bb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010be:	fd                   	std    
  8010bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010c1:	fc                   	cld    
  8010c2:	eb 1a                	jmp    8010de <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	09 ca                	or     %ecx,%edx
  8010c8:	09 f2                	or     %esi,%edx
  8010ca:	f6 c2 03             	test   $0x3,%dl
  8010cd:	75 0a                	jne    8010d9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010cf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010d2:	89 c7                	mov    %eax,%edi
  8010d4:	fc                   	cld    
  8010d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010d7:	eb 05                	jmp    8010de <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8010d9:	89 c7                	mov    %eax,%edi
  8010db:	fc                   	cld    
  8010dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010de:	5e                   	pop    %esi
  8010df:	5f                   	pop    %edi
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010e8:	ff 75 10             	pushl  0x10(%ebp)
  8010eb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ee:	ff 75 08             	pushl  0x8(%ebp)
  8010f1:	e8 8a ff ff ff       	call   801080 <memmove>
}
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    

008010f8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	56                   	push   %esi
  8010fc:	53                   	push   %ebx
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8b 55 0c             	mov    0xc(%ebp),%edx
  801103:	89 c6                	mov    %eax,%esi
  801105:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801108:	39 f0                	cmp    %esi,%eax
  80110a:	74 1c                	je     801128 <memcmp+0x30>
		if (*s1 != *s2)
  80110c:	0f b6 08             	movzbl (%eax),%ecx
  80110f:	0f b6 1a             	movzbl (%edx),%ebx
  801112:	38 d9                	cmp    %bl,%cl
  801114:	75 08                	jne    80111e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801116:	83 c0 01             	add    $0x1,%eax
  801119:	83 c2 01             	add    $0x1,%edx
  80111c:	eb ea                	jmp    801108 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80111e:	0f b6 c1             	movzbl %cl,%eax
  801121:	0f b6 db             	movzbl %bl,%ebx
  801124:	29 d8                	sub    %ebx,%eax
  801126:	eb 05                	jmp    80112d <memcmp+0x35>
	}

	return 0;
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80113f:	39 d0                	cmp    %edx,%eax
  801141:	73 09                	jae    80114c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801143:	38 08                	cmp    %cl,(%eax)
  801145:	74 05                	je     80114c <memfind+0x1b>
	for (; s < ends; s++)
  801147:	83 c0 01             	add    $0x1,%eax
  80114a:	eb f3                	jmp    80113f <memfind+0xe>
			break;
	return (void *) s;
}
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	57                   	push   %edi
  801152:	56                   	push   %esi
  801153:	53                   	push   %ebx
  801154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801157:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115a:	eb 03                	jmp    80115f <strtol+0x11>
		s++;
  80115c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80115f:	0f b6 01             	movzbl (%ecx),%eax
  801162:	3c 20                	cmp    $0x20,%al
  801164:	74 f6                	je     80115c <strtol+0xe>
  801166:	3c 09                	cmp    $0x9,%al
  801168:	74 f2                	je     80115c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80116a:	3c 2b                	cmp    $0x2b,%al
  80116c:	74 2a                	je     801198 <strtol+0x4a>
	int neg = 0;
  80116e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801173:	3c 2d                	cmp    $0x2d,%al
  801175:	74 2b                	je     8011a2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801177:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80117d:	75 0f                	jne    80118e <strtol+0x40>
  80117f:	80 39 30             	cmpb   $0x30,(%ecx)
  801182:	74 28                	je     8011ac <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801184:	85 db                	test   %ebx,%ebx
  801186:	b8 0a 00 00 00       	mov    $0xa,%eax
  80118b:	0f 44 d8             	cmove  %eax,%ebx
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801196:	eb 50                	jmp    8011e8 <strtol+0x9a>
		s++;
  801198:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80119b:	bf 00 00 00 00       	mov    $0x0,%edi
  8011a0:	eb d5                	jmp    801177 <strtol+0x29>
		s++, neg = 1;
  8011a2:	83 c1 01             	add    $0x1,%ecx
  8011a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8011aa:	eb cb                	jmp    801177 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ac:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8011b0:	74 0e                	je     8011c0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8011b2:	85 db                	test   %ebx,%ebx
  8011b4:	75 d8                	jne    80118e <strtol+0x40>
		s++, base = 8;
  8011b6:	83 c1 01             	add    $0x1,%ecx
  8011b9:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011be:	eb ce                	jmp    80118e <strtol+0x40>
		s += 2, base = 16;
  8011c0:	83 c1 02             	add    $0x2,%ecx
  8011c3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011c8:	eb c4                	jmp    80118e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8011ca:	8d 72 9f             	lea    -0x61(%edx),%esi
  8011cd:	89 f3                	mov    %esi,%ebx
  8011cf:	80 fb 19             	cmp    $0x19,%bl
  8011d2:	77 29                	ja     8011fd <strtol+0xaf>
			dig = *s - 'a' + 10;
  8011d4:	0f be d2             	movsbl %dl,%edx
  8011d7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011da:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011dd:	7d 30                	jge    80120f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8011df:	83 c1 01             	add    $0x1,%ecx
  8011e2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011e8:	0f b6 11             	movzbl (%ecx),%edx
  8011eb:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011ee:	89 f3                	mov    %esi,%ebx
  8011f0:	80 fb 09             	cmp    $0x9,%bl
  8011f3:	77 d5                	ja     8011ca <strtol+0x7c>
			dig = *s - '0';
  8011f5:	0f be d2             	movsbl %dl,%edx
  8011f8:	83 ea 30             	sub    $0x30,%edx
  8011fb:	eb dd                	jmp    8011da <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8011fd:	8d 72 bf             	lea    -0x41(%edx),%esi
  801200:	89 f3                	mov    %esi,%ebx
  801202:	80 fb 19             	cmp    $0x19,%bl
  801205:	77 08                	ja     80120f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801207:	0f be d2             	movsbl %dl,%edx
  80120a:	83 ea 37             	sub    $0x37,%edx
  80120d:	eb cb                	jmp    8011da <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80120f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801213:	74 05                	je     80121a <strtol+0xcc>
		*endptr = (char *) s;
  801215:	8b 75 0c             	mov    0xc(%ebp),%esi
  801218:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80121a:	89 c2                	mov    %eax,%edx
  80121c:	f7 da                	neg    %edx
  80121e:	85 ff                	test   %edi,%edi
  801220:	0f 45 c2             	cmovne %edx,%eax
}
  801223:	5b                   	pop    %ebx
  801224:	5e                   	pop    %esi
  801225:	5f                   	pop    %edi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122e:	b8 00 00 00 00       	mov    $0x0,%eax
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	89 c3                	mov    %eax,%ebx
  80123b:	89 c7                	mov    %eax,%edi
  80123d:	89 c6                	mov    %eax,%esi
  80123f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <sys_cgetc>:

int
sys_cgetc(void)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	57                   	push   %edi
  80124a:	56                   	push   %esi
  80124b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124c:	ba 00 00 00 00       	mov    $0x0,%edx
  801251:	b8 01 00 00 00       	mov    $0x1,%eax
  801256:	89 d1                	mov    %edx,%ecx
  801258:	89 d3                	mov    %edx,%ebx
  80125a:	89 d7                	mov    %edx,%edi
  80125c:	89 d6                	mov    %edx,%esi
  80125e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801260:	5b                   	pop    %ebx
  801261:	5e                   	pop    %esi
  801262:	5f                   	pop    %edi
  801263:	5d                   	pop    %ebp
  801264:	c3                   	ret    

00801265 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	57                   	push   %edi
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80126e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801273:	8b 55 08             	mov    0x8(%ebp),%edx
  801276:	b8 03 00 00 00       	mov    $0x3,%eax
  80127b:	89 cb                	mov    %ecx,%ebx
  80127d:	89 cf                	mov    %ecx,%edi
  80127f:	89 ce                	mov    %ecx,%esi
  801281:	cd 30                	int    $0x30
	if(check && ret > 0)
  801283:	85 c0                	test   %eax,%eax
  801285:	7f 08                	jg     80128f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128a:	5b                   	pop    %ebx
  80128b:	5e                   	pop    %esi
  80128c:	5f                   	pop    %edi
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80128f:	83 ec 0c             	sub    $0xc,%esp
  801292:	50                   	push   %eax
  801293:	6a 03                	push   $0x3
  801295:	68 24 30 80 00       	push   $0x803024
  80129a:	6a 43                	push   $0x43
  80129c:	68 41 30 80 00       	push   $0x803041
  8012a1:	e8 f7 f3 ff ff       	call   80069d <_panic>

008012a6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	57                   	push   %edi
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8012b6:	89 d1                	mov    %edx,%ecx
  8012b8:	89 d3                	mov    %edx,%ebx
  8012ba:	89 d7                	mov    %edx,%edi
  8012bc:	89 d6                	mov    %edx,%esi
  8012be:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012c0:	5b                   	pop    %ebx
  8012c1:	5e                   	pop    %esi
  8012c2:	5f                   	pop    %edi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <sys_yield>:

void
sys_yield(void)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	57                   	push   %edi
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012d5:	89 d1                	mov    %edx,%ecx
  8012d7:	89 d3                	mov    %edx,%ebx
  8012d9:	89 d7                	mov    %edx,%edi
  8012db:	89 d6                	mov    %edx,%esi
  8012dd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	57                   	push   %edi
  8012e8:	56                   	push   %esi
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ed:	be 00 00 00 00       	mov    $0x0,%esi
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8012fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801300:	89 f7                	mov    %esi,%edi
  801302:	cd 30                	int    $0x30
	if(check && ret > 0)
  801304:	85 c0                	test   %eax,%eax
  801306:	7f 08                	jg     801310 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	50                   	push   %eax
  801314:	6a 04                	push   $0x4
  801316:	68 24 30 80 00       	push   $0x803024
  80131b:	6a 43                	push   $0x43
  80131d:	68 41 30 80 00       	push   $0x803041
  801322:	e8 76 f3 ff ff       	call   80069d <_panic>

00801327 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	57                   	push   %edi
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801330:	8b 55 08             	mov    0x8(%ebp),%edx
  801333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801336:	b8 05 00 00 00       	mov    $0x5,%eax
  80133b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801341:	8b 75 18             	mov    0x18(%ebp),%esi
  801344:	cd 30                	int    $0x30
	if(check && ret > 0)
  801346:	85 c0                	test   %eax,%eax
  801348:	7f 08                	jg     801352 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134d:	5b                   	pop    %ebx
  80134e:	5e                   	pop    %esi
  80134f:	5f                   	pop    %edi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	50                   	push   %eax
  801356:	6a 05                	push   $0x5
  801358:	68 24 30 80 00       	push   $0x803024
  80135d:	6a 43                	push   $0x43
  80135f:	68 41 30 80 00       	push   $0x803041
  801364:	e8 34 f3 ff ff       	call   80069d <_panic>

00801369 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	57                   	push   %edi
  80136d:	56                   	push   %esi
  80136e:	53                   	push   %ebx
  80136f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801372:	bb 00 00 00 00       	mov    $0x0,%ebx
  801377:	8b 55 08             	mov    0x8(%ebp),%edx
  80137a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137d:	b8 06 00 00 00       	mov    $0x6,%eax
  801382:	89 df                	mov    %ebx,%edi
  801384:	89 de                	mov    %ebx,%esi
  801386:	cd 30                	int    $0x30
	if(check && ret > 0)
  801388:	85 c0                	test   %eax,%eax
  80138a:	7f 08                	jg     801394 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80138c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	50                   	push   %eax
  801398:	6a 06                	push   $0x6
  80139a:	68 24 30 80 00       	push   $0x803024
  80139f:	6a 43                	push   $0x43
  8013a1:	68 41 30 80 00       	push   $0x803041
  8013a6:	e8 f2 f2 ff ff       	call   80069d <_panic>

008013ab <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	57                   	push   %edi
  8013af:	56                   	push   %esi
  8013b0:	53                   	push   %ebx
  8013b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8013c4:	89 df                	mov    %ebx,%edi
  8013c6:	89 de                	mov    %ebx,%esi
  8013c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	7f 08                	jg     8013d6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8013ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d1:	5b                   	pop    %ebx
  8013d2:	5e                   	pop    %esi
  8013d3:	5f                   	pop    %edi
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	50                   	push   %eax
  8013da:	6a 08                	push   $0x8
  8013dc:	68 24 30 80 00       	push   $0x803024
  8013e1:	6a 43                	push   $0x43
  8013e3:	68 41 30 80 00       	push   $0x803041
  8013e8:	e8 b0 f2 ff ff       	call   80069d <_panic>

008013ed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	57                   	push   %edi
  8013f1:	56                   	push   %esi
  8013f2:	53                   	push   %ebx
  8013f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801401:	b8 09 00 00 00       	mov    $0x9,%eax
  801406:	89 df                	mov    %ebx,%edi
  801408:	89 de                	mov    %ebx,%esi
  80140a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80140c:	85 c0                	test   %eax,%eax
  80140e:	7f 08                	jg     801418 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801413:	5b                   	pop    %ebx
  801414:	5e                   	pop    %esi
  801415:	5f                   	pop    %edi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	50                   	push   %eax
  80141c:	6a 09                	push   $0x9
  80141e:	68 24 30 80 00       	push   $0x803024
  801423:	6a 43                	push   $0x43
  801425:	68 41 30 80 00       	push   $0x803041
  80142a:	e8 6e f2 ff ff       	call   80069d <_panic>

0080142f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	57                   	push   %edi
  801433:	56                   	push   %esi
  801434:	53                   	push   %ebx
  801435:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801438:	bb 00 00 00 00       	mov    $0x0,%ebx
  80143d:	8b 55 08             	mov    0x8(%ebp),%edx
  801440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801443:	b8 0a 00 00 00       	mov    $0xa,%eax
  801448:	89 df                	mov    %ebx,%edi
  80144a:	89 de                	mov    %ebx,%esi
  80144c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80144e:	85 c0                	test   %eax,%eax
  801450:	7f 08                	jg     80145a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80145a:	83 ec 0c             	sub    $0xc,%esp
  80145d:	50                   	push   %eax
  80145e:	6a 0a                	push   $0xa
  801460:	68 24 30 80 00       	push   $0x803024
  801465:	6a 43                	push   $0x43
  801467:	68 41 30 80 00       	push   $0x803041
  80146c:	e8 2c f2 ff ff       	call   80069d <_panic>

00801471 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	57                   	push   %edi
  801475:	56                   	push   %esi
  801476:	53                   	push   %ebx
	asm volatile("int %1\n"
  801477:	8b 55 08             	mov    0x8(%ebp),%edx
  80147a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801482:	be 00 00 00 00       	mov    $0x0,%esi
  801487:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80148a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80148d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5f                   	pop    %edi
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    

00801494 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	57                   	push   %edi
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
  80149a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80149d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014aa:	89 cb                	mov    %ecx,%ebx
  8014ac:	89 cf                	mov    %ecx,%edi
  8014ae:	89 ce                	mov    %ecx,%esi
  8014b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	7f 08                	jg     8014be <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b9:	5b                   	pop    %ebx
  8014ba:	5e                   	pop    %esi
  8014bb:	5f                   	pop    %edi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014be:	83 ec 0c             	sub    $0xc,%esp
  8014c1:	50                   	push   %eax
  8014c2:	6a 0d                	push   $0xd
  8014c4:	68 24 30 80 00       	push   $0x803024
  8014c9:	6a 43                	push   $0x43
  8014cb:	68 41 30 80 00       	push   $0x803041
  8014d0:	e8 c8 f1 ff ff       	call   80069d <_panic>

008014d5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	57                   	push   %edi
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8014eb:	89 df                	mov    %ebx,%edi
  8014ed:	89 de                	mov    %ebx,%esi
  8014ef:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	57                   	push   %edi
  8014fa:	56                   	push   %esi
  8014fb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801501:	8b 55 08             	mov    0x8(%ebp),%edx
  801504:	b8 0f 00 00 00       	mov    $0xf,%eax
  801509:	89 cb                	mov    %ecx,%ebx
  80150b:	89 cf                	mov    %ecx,%edi
  80150d:	89 ce                	mov    %ecx,%esi
  80150f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5f                   	pop    %edi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80151c:	ba 00 00 00 00       	mov    $0x0,%edx
  801521:	b8 10 00 00 00       	mov    $0x10,%eax
  801526:	89 d1                	mov    %edx,%ecx
  801528:	89 d3                	mov    %edx,%ebx
  80152a:	89 d7                	mov    %edx,%edi
  80152c:	89 d6                	mov    %edx,%esi
  80152e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5f                   	pop    %edi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	57                   	push   %edi
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80153b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801540:	8b 55 08             	mov    0x8(%ebp),%edx
  801543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801546:	b8 11 00 00 00       	mov    $0x11,%eax
  80154b:	89 df                	mov    %ebx,%edi
  80154d:	89 de                	mov    %ebx,%esi
  80154f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	57                   	push   %edi
  80155a:	56                   	push   %esi
  80155b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80155c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801561:	8b 55 08             	mov    0x8(%ebp),%edx
  801564:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801567:	b8 12 00 00 00       	mov    $0x12,%eax
  80156c:	89 df                	mov    %ebx,%edi
  80156e:	89 de                	mov    %ebx,%esi
  801570:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5f                   	pop    %edi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	57                   	push   %edi
  80157b:	56                   	push   %esi
  80157c:	53                   	push   %ebx
  80157d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801580:	bb 00 00 00 00       	mov    $0x0,%ebx
  801585:	8b 55 08             	mov    0x8(%ebp),%edx
  801588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158b:	b8 13 00 00 00       	mov    $0x13,%eax
  801590:	89 df                	mov    %ebx,%edi
  801592:	89 de                	mov    %ebx,%esi
  801594:	cd 30                	int    $0x30
	if(check && ret > 0)
  801596:	85 c0                	test   %eax,%eax
  801598:	7f 08                	jg     8015a2 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	50                   	push   %eax
  8015a6:	6a 13                	push   $0x13
  8015a8:	68 24 30 80 00       	push   $0x803024
  8015ad:	6a 43                	push   $0x43
  8015af:	68 41 30 80 00       	push   $0x803041
  8015b4:	e8 e4 f0 ff ff       	call   80069d <_panic>

008015b9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8015bf:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  8015c6:	74 0a                	je     8015d2 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	6a 07                	push   $0x7
  8015d7:	68 00 f0 bf ee       	push   $0xeebff000
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 01 fd ff ff       	call   8012e4 <sys_page_alloc>
		if(r < 0)
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 2a                	js     801614 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8015ea:	83 ec 08             	sub    $0x8,%esp
  8015ed:	68 28 16 80 00       	push   $0x801628
  8015f2:	6a 00                	push   $0x0
  8015f4:	e8 36 fe ff ff       	call   80142f <sys_env_set_pgfault_upcall>
		if(r < 0)
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	79 c8                	jns    8015c8 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 80 30 80 00       	push   $0x803080
  801608:	6a 25                	push   $0x25
  80160a:	68 b9 30 80 00       	push   $0x8030b9
  80160f:	e8 89 f0 ff ff       	call   80069d <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 50 30 80 00       	push   $0x803050
  80161c:	6a 22                	push   $0x22
  80161e:	68 b9 30 80 00       	push   $0x8030b9
  801623:	e8 75 f0 ff ff       	call   80069d <_panic>

00801628 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801628:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801629:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  80162e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801630:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801633:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801637:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80163b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80163e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801640:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801644:	83 c4 08             	add    $0x8,%esp
	popal
  801647:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801648:	83 c4 04             	add    $0x4,%esp
	popfl
  80164b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80164c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80164d:	c3                   	ret    

0080164e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	05 00 00 00 30       	add    $0x30000000,%eax
  801659:	c1 e8 0c             	shr    $0xc,%eax
}
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    

0080165e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801669:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    

00801675 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80167d:	89 c2                	mov    %eax,%edx
  80167f:	c1 ea 16             	shr    $0x16,%edx
  801682:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801689:	f6 c2 01             	test   $0x1,%dl
  80168c:	74 2d                	je     8016bb <fd_alloc+0x46>
  80168e:	89 c2                	mov    %eax,%edx
  801690:	c1 ea 0c             	shr    $0xc,%edx
  801693:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80169a:	f6 c2 01             	test   $0x1,%dl
  80169d:	74 1c                	je     8016bb <fd_alloc+0x46>
  80169f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016a9:	75 d2                	jne    80167d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016b9:	eb 0a                	jmp    8016c5 <fd_alloc+0x50>
			*fd_store = fd;
  8016bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016cd:	83 f8 1f             	cmp    $0x1f,%eax
  8016d0:	77 30                	ja     801702 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016d2:	c1 e0 0c             	shl    $0xc,%eax
  8016d5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016da:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016e0:	f6 c2 01             	test   $0x1,%dl
  8016e3:	74 24                	je     801709 <fd_lookup+0x42>
  8016e5:	89 c2                	mov    %eax,%edx
  8016e7:	c1 ea 0c             	shr    $0xc,%edx
  8016ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f1:	f6 c2 01             	test   $0x1,%dl
  8016f4:	74 1a                	je     801710 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	89 02                	mov    %eax,(%edx)
	return 0;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		return -E_INVAL;
  801702:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801707:	eb f7                	jmp    801700 <fd_lookup+0x39>
		return -E_INVAL;
  801709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170e:	eb f0                	jmp    801700 <fd_lookup+0x39>
  801710:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801715:	eb e9                	jmp    801700 <fd_lookup+0x39>

00801717 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801720:	ba 00 00 00 00       	mov    $0x0,%edx
  801725:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80172a:	39 08                	cmp    %ecx,(%eax)
  80172c:	74 38                	je     801766 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80172e:	83 c2 01             	add    $0x1,%edx
  801731:	8b 04 95 48 31 80 00 	mov    0x803148(,%edx,4),%eax
  801738:	85 c0                	test   %eax,%eax
  80173a:	75 ee                	jne    80172a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80173c:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801741:	8b 40 48             	mov    0x48(%eax),%eax
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	51                   	push   %ecx
  801748:	50                   	push   %eax
  801749:	68 c8 30 80 00       	push   $0x8030c8
  80174e:	e8 40 f0 ff ff       	call   800793 <cprintf>
	*dev = 0;
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    
			*dev = devtab[i];
  801766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801769:	89 01                	mov    %eax,(%ecx)
			return 0;
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
  801770:	eb f2                	jmp    801764 <dev_lookup+0x4d>

00801772 <fd_close>:
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	57                   	push   %edi
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
  801778:	83 ec 24             	sub    $0x24,%esp
  80177b:	8b 75 08             	mov    0x8(%ebp),%esi
  80177e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801781:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801784:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801785:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80178b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80178e:	50                   	push   %eax
  80178f:	e8 33 ff ff ff       	call   8016c7 <fd_lookup>
  801794:	89 c3                	mov    %eax,%ebx
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 05                	js     8017a2 <fd_close+0x30>
	    || fd != fd2)
  80179d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017a0:	74 16                	je     8017b8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017a2:	89 f8                	mov    %edi,%eax
  8017a4:	84 c0                	test   %al,%al
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	0f 44 d8             	cmove  %eax,%ebx
}
  8017ae:	89 d8                	mov    %ebx,%eax
  8017b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017b8:	83 ec 08             	sub    $0x8,%esp
  8017bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017be:	50                   	push   %eax
  8017bf:	ff 36                	pushl  (%esi)
  8017c1:	e8 51 ff ff ff       	call   801717 <dev_lookup>
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 1a                	js     8017e9 <fd_close+0x77>
		if (dev->dev_close)
  8017cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	74 0b                	je     8017e9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	56                   	push   %esi
  8017e2:	ff d0                	call   *%eax
  8017e4:	89 c3                	mov    %eax,%ebx
  8017e6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017e9:	83 ec 08             	sub    $0x8,%esp
  8017ec:	56                   	push   %esi
  8017ed:	6a 00                	push   $0x0
  8017ef:	e8 75 fb ff ff       	call   801369 <sys_page_unmap>
	return r;
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	eb b5                	jmp    8017ae <fd_close+0x3c>

008017f9 <close>:

int
close(int fdnum)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801802:	50                   	push   %eax
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	e8 bc fe ff ff       	call   8016c7 <fd_lookup>
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	79 02                	jns    801814 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    
		return fd_close(fd, 1);
  801814:	83 ec 08             	sub    $0x8,%esp
  801817:	6a 01                	push   $0x1
  801819:	ff 75 f4             	pushl  -0xc(%ebp)
  80181c:	e8 51 ff ff ff       	call   801772 <fd_close>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	eb ec                	jmp    801812 <close+0x19>

00801826 <close_all>:

void
close_all(void)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80182d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	53                   	push   %ebx
  801836:	e8 be ff ff ff       	call   8017f9 <close>
	for (i = 0; i < MAXFD; i++)
  80183b:	83 c3 01             	add    $0x1,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	83 fb 20             	cmp    $0x20,%ebx
  801844:	75 ec                	jne    801832 <close_all+0xc>
}
  801846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801854:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801857:	50                   	push   %eax
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	e8 67 fe ff ff       	call   8016c7 <fd_lookup>
  801860:	89 c3                	mov    %eax,%ebx
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	85 c0                	test   %eax,%eax
  801867:	0f 88 81 00 00 00    	js     8018ee <dup+0xa3>
		return r;
	close(newfdnum);
  80186d:	83 ec 0c             	sub    $0xc,%esp
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	e8 81 ff ff ff       	call   8017f9 <close>

	newfd = INDEX2FD(newfdnum);
  801878:	8b 75 0c             	mov    0xc(%ebp),%esi
  80187b:	c1 e6 0c             	shl    $0xc,%esi
  80187e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801884:	83 c4 04             	add    $0x4,%esp
  801887:	ff 75 e4             	pushl  -0x1c(%ebp)
  80188a:	e8 cf fd ff ff       	call   80165e <fd2data>
  80188f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801891:	89 34 24             	mov    %esi,(%esp)
  801894:	e8 c5 fd ff ff       	call   80165e <fd2data>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	c1 e8 16             	shr    $0x16,%eax
  8018a3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018aa:	a8 01                	test   $0x1,%al
  8018ac:	74 11                	je     8018bf <dup+0x74>
  8018ae:	89 d8                	mov    %ebx,%eax
  8018b0:	c1 e8 0c             	shr    $0xc,%eax
  8018b3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018ba:	f6 c2 01             	test   $0x1,%dl
  8018bd:	75 39                	jne    8018f8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018c2:	89 d0                	mov    %edx,%eax
  8018c4:	c1 e8 0c             	shr    $0xc,%eax
  8018c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d6:	50                   	push   %eax
  8018d7:	56                   	push   %esi
  8018d8:	6a 00                	push   $0x0
  8018da:	52                   	push   %edx
  8018db:	6a 00                	push   $0x0
  8018dd:	e8 45 fa ff ff       	call   801327 <sys_page_map>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	83 c4 20             	add    $0x20,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 31                	js     80191c <dup+0xd1>
		goto err;

	return newfdnum;
  8018eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018ee:	89 d8                	mov    %ebx,%eax
  8018f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5f                   	pop    %edi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	25 07 0e 00 00       	and    $0xe07,%eax
  801907:	50                   	push   %eax
  801908:	57                   	push   %edi
  801909:	6a 00                	push   $0x0
  80190b:	53                   	push   %ebx
  80190c:	6a 00                	push   $0x0
  80190e:	e8 14 fa ff ff       	call   801327 <sys_page_map>
  801913:	89 c3                	mov    %eax,%ebx
  801915:	83 c4 20             	add    $0x20,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	79 a3                	jns    8018bf <dup+0x74>
	sys_page_unmap(0, newfd);
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	56                   	push   %esi
  801920:	6a 00                	push   $0x0
  801922:	e8 42 fa ff ff       	call   801369 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801927:	83 c4 08             	add    $0x8,%esp
  80192a:	57                   	push   %edi
  80192b:	6a 00                	push   $0x0
  80192d:	e8 37 fa ff ff       	call   801369 <sys_page_unmap>
	return r;
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	eb b7                	jmp    8018ee <dup+0xa3>

00801937 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	53                   	push   %ebx
  80193b:	83 ec 1c             	sub    $0x1c,%esp
  80193e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801941:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801944:	50                   	push   %eax
  801945:	53                   	push   %ebx
  801946:	e8 7c fd ff ff       	call   8016c7 <fd_lookup>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 3f                	js     801991 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	ff 30                	pushl  (%eax)
  80195e:	e8 b4 fd ff ff       	call   801717 <dev_lookup>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 27                	js     801991 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80196a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196d:	8b 42 08             	mov    0x8(%edx),%eax
  801970:	83 e0 03             	and    $0x3,%eax
  801973:	83 f8 01             	cmp    $0x1,%eax
  801976:	74 1e                	je     801996 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	8b 40 08             	mov    0x8(%eax),%eax
  80197e:	85 c0                	test   %eax,%eax
  801980:	74 35                	je     8019b7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	ff 75 10             	pushl  0x10(%ebp)
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	52                   	push   %edx
  80198c:	ff d0                	call   *%eax
  80198e:	83 c4 10             	add    $0x10,%esp
}
  801991:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801994:	c9                   	leave  
  801995:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801996:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80199b:	8b 40 48             	mov    0x48(%eax),%eax
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	53                   	push   %ebx
  8019a2:	50                   	push   %eax
  8019a3:	68 0c 31 80 00       	push   $0x80310c
  8019a8:	e8 e6 ed ff ff       	call   800793 <cprintf>
		return -E_INVAL;
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b5:	eb da                	jmp    801991 <read+0x5a>
		return -E_NOT_SUPP;
  8019b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019bc:	eb d3                	jmp    801991 <read+0x5a>

008019be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d2:	39 f3                	cmp    %esi,%ebx
  8019d4:	73 23                	jae    8019f9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	89 f0                	mov    %esi,%eax
  8019db:	29 d8                	sub    %ebx,%eax
  8019dd:	50                   	push   %eax
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	03 45 0c             	add    0xc(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	57                   	push   %edi
  8019e5:	e8 4d ff ff ff       	call   801937 <read>
		if (m < 0)
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 06                	js     8019f7 <readn+0x39>
			return m;
		if (m == 0)
  8019f1:	74 06                	je     8019f9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019f3:	01 c3                	add    %eax,%ebx
  8019f5:	eb db                	jmp    8019d2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019f7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5f                   	pop    %edi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	53                   	push   %ebx
  801a07:	83 ec 1c             	sub    $0x1c,%esp
  801a0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	53                   	push   %ebx
  801a12:	e8 b0 fc ff ff       	call   8016c7 <fd_lookup>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 3a                	js     801a58 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	ff 30                	pushl  (%eax)
  801a2a:	e8 e8 fc ff ff       	call   801717 <dev_lookup>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 22                	js     801a58 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3d:	74 1e                	je     801a5d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 52 0c             	mov    0xc(%edx),%edx
  801a45:	85 d2                	test   %edx,%edx
  801a47:	74 35                	je     801a7e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	ff 75 10             	pushl  0x10(%ebp)
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	50                   	push   %eax
  801a53:	ff d2                	call   *%edx
  801a55:	83 c4 10             	add    $0x10,%esp
}
  801a58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a5d:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801a62:	8b 40 48             	mov    0x48(%eax),%eax
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	53                   	push   %ebx
  801a69:	50                   	push   %eax
  801a6a:	68 28 31 80 00       	push   $0x803128
  801a6f:	e8 1f ed ff ff       	call   800793 <cprintf>
		return -E_INVAL;
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a7c:	eb da                	jmp    801a58 <write+0x55>
		return -E_NOT_SUPP;
  801a7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a83:	eb d3                	jmp    801a58 <write+0x55>

00801a85 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8e:	50                   	push   %eax
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	e8 30 fc ff ff       	call   8016c7 <fd_lookup>
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 0e                	js     801aac <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	53                   	push   %ebx
  801ab2:	83 ec 1c             	sub    $0x1c,%esp
  801ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	53                   	push   %ebx
  801abd:	e8 05 fc ff ff       	call   8016c7 <fd_lookup>
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	78 37                	js     801b00 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac9:	83 ec 08             	sub    $0x8,%esp
  801acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acf:	50                   	push   %eax
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad3:	ff 30                	pushl  (%eax)
  801ad5:	e8 3d fc ff ff       	call   801717 <dev_lookup>
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 1f                	js     801b00 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ae8:	74 1b                	je     801b05 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aed:	8b 52 18             	mov    0x18(%edx),%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	74 32                	je     801b26 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	ff d2                	call   *%edx
  801afd:	83 c4 10             	add    $0x10,%esp
}
  801b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b05:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b0a:	8b 40 48             	mov    0x48(%eax),%eax
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	53                   	push   %ebx
  801b11:	50                   	push   %eax
  801b12:	68 e8 30 80 00       	push   $0x8030e8
  801b17:	e8 77 ec ff ff       	call   800793 <cprintf>
		return -E_INVAL;
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b24:	eb da                	jmp    801b00 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b2b:	eb d3                	jmp    801b00 <ftruncate+0x52>

00801b2d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	53                   	push   %ebx
  801b31:	83 ec 1c             	sub    $0x1c,%esp
  801b34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	e8 84 fb ff ff       	call   8016c7 <fd_lookup>
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 4b                	js     801b95 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b50:	50                   	push   %eax
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b54:	ff 30                	pushl  (%eax)
  801b56:	e8 bc fb ff ff       	call   801717 <dev_lookup>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 33                	js     801b95 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b65:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b69:	74 2f                	je     801b9a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b6b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b6e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b75:	00 00 00 
	stat->st_isdir = 0;
  801b78:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b7f:	00 00 00 
	stat->st_dev = dev;
  801b82:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b88:	83 ec 08             	sub    $0x8,%esp
  801b8b:	53                   	push   %ebx
  801b8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b8f:	ff 50 14             	call   *0x14(%eax)
  801b92:	83 c4 10             	add    $0x10,%esp
}
  801b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    
		return -E_NOT_SUPP;
  801b9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b9f:	eb f4                	jmp    801b95 <fstat+0x68>

00801ba1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 22 02 00 00       	call   801dd5 <open>
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 1b                	js     801bd7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	50                   	push   %eax
  801bc3:	e8 65 ff ff ff       	call   801b2d <fstat>
  801bc8:	89 c6                	mov    %eax,%esi
	close(fd);
  801bca:	89 1c 24             	mov    %ebx,(%esp)
  801bcd:	e8 27 fc ff ff       	call   8017f9 <close>
	return r;
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	89 f3                	mov    %esi,%ebx
}
  801bd7:	89 d8                	mov    %ebx,%eax
  801bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	89 c6                	mov    %eax,%esi
  801be7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801be9:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801bf0:	74 27                	je     801c19 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bf2:	6a 07                	push   $0x7
  801bf4:	68 00 60 80 00       	push   $0x806000
  801bf9:	56                   	push   %esi
  801bfa:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801c00:	e8 08 0c 00 00       	call   80280d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c05:	83 c4 0c             	add    $0xc,%esp
  801c08:	6a 00                	push   $0x0
  801c0a:	53                   	push   %ebx
  801c0b:	6a 00                	push   $0x0
  801c0d:	e8 92 0b 00 00       	call   8027a4 <ipc_recv>
}
  801c12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5e                   	pop    %esi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	6a 01                	push   $0x1
  801c1e:	e8 42 0c 00 00       	call   802865 <ipc_find_env>
  801c23:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	eb c5                	jmp    801bf2 <fsipc+0x12>

00801c2d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	8b 40 0c             	mov    0xc(%eax),%eax
  801c39:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	b8 02 00 00 00       	mov    $0x2,%eax
  801c50:	e8 8b ff ff ff       	call   801be0 <fsipc>
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <devfile_flush>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	8b 40 0c             	mov    0xc(%eax),%eax
  801c63:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c68:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6d:	b8 06 00 00 00       	mov    $0x6,%eax
  801c72:	e8 69 ff ff ff       	call   801be0 <fsipc>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_stat>:
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8b 40 0c             	mov    0xc(%eax),%eax
  801c89:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	b8 05 00 00 00       	mov    $0x5,%eax
  801c98:	e8 43 ff ff ff       	call   801be0 <fsipc>
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	78 2c                	js     801ccd <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	68 00 60 80 00       	push   $0x806000
  801ca9:	53                   	push   %ebx
  801caa:	e8 43 f2 ff ff       	call   800ef2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801caf:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cba:	a1 84 60 80 00       	mov    0x806084,%eax
  801cbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <devfile_write>:
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ce7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ced:	53                   	push   %ebx
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	68 08 60 80 00       	push   $0x806008
  801cf6:	e8 e7 f3 ff ff       	call   8010e2 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	b8 04 00 00 00       	mov    $0x4,%eax
  801d05:	e8 d6 fe ff ff       	call   801be0 <fsipc>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	78 0b                	js     801d1c <devfile_write+0x4a>
	assert(r <= n);
  801d11:	39 d8                	cmp    %ebx,%eax
  801d13:	77 0c                	ja     801d21 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d15:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d1a:	7f 1e                	jg     801d3a <devfile_write+0x68>
}
  801d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    
	assert(r <= n);
  801d21:	68 5c 31 80 00       	push   $0x80315c
  801d26:	68 63 31 80 00       	push   $0x803163
  801d2b:	68 98 00 00 00       	push   $0x98
  801d30:	68 78 31 80 00       	push   $0x803178
  801d35:	e8 63 e9 ff ff       	call   80069d <_panic>
	assert(r <= PGSIZE);
  801d3a:	68 83 31 80 00       	push   $0x803183
  801d3f:	68 63 31 80 00       	push   $0x803163
  801d44:	68 99 00 00 00       	push   $0x99
  801d49:	68 78 31 80 00       	push   $0x803178
  801d4e:	e8 4a e9 ff ff       	call   80069d <_panic>

00801d53 <devfile_read>:
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d61:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d66:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 03 00 00 00       	mov    $0x3,%eax
  801d76:	e8 65 fe ff ff       	call   801be0 <fsipc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	78 1f                	js     801da0 <devfile_read+0x4d>
	assert(r <= n);
  801d81:	39 f0                	cmp    %esi,%eax
  801d83:	77 24                	ja     801da9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d85:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d8a:	7f 33                	jg     801dbf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	50                   	push   %eax
  801d90:	68 00 60 80 00       	push   $0x806000
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	e8 e3 f2 ff ff       	call   801080 <memmove>
	return r;
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	89 d8                	mov    %ebx,%eax
  801da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    
	assert(r <= n);
  801da9:	68 5c 31 80 00       	push   $0x80315c
  801dae:	68 63 31 80 00       	push   $0x803163
  801db3:	6a 7c                	push   $0x7c
  801db5:	68 78 31 80 00       	push   $0x803178
  801dba:	e8 de e8 ff ff       	call   80069d <_panic>
	assert(r <= PGSIZE);
  801dbf:	68 83 31 80 00       	push   $0x803183
  801dc4:	68 63 31 80 00       	push   $0x803163
  801dc9:	6a 7d                	push   $0x7d
  801dcb:	68 78 31 80 00       	push   $0x803178
  801dd0:	e8 c8 e8 ff ff       	call   80069d <_panic>

00801dd5 <open>:
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	56                   	push   %esi
  801dd9:	53                   	push   %ebx
  801dda:	83 ec 1c             	sub    $0x1c,%esp
  801ddd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801de0:	56                   	push   %esi
  801de1:	e8 d3 f0 ff ff       	call   800eb9 <strlen>
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dee:	7f 6c                	jg     801e5c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801df0:	83 ec 0c             	sub    $0xc,%esp
  801df3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df6:	50                   	push   %eax
  801df7:	e8 79 f8 ff ff       	call   801675 <fd_alloc>
  801dfc:	89 c3                	mov    %eax,%ebx
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	85 c0                	test   %eax,%eax
  801e03:	78 3c                	js     801e41 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	56                   	push   %esi
  801e09:	68 00 60 80 00       	push   $0x806000
  801e0e:	e8 df f0 ff ff       	call   800ef2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e16:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	e8 b8 fd ff ff       	call   801be0 <fsipc>
  801e28:	89 c3                	mov    %eax,%ebx
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 19                	js     801e4a <open+0x75>
	return fd2num(fd);
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 f4             	pushl  -0xc(%ebp)
  801e37:	e8 12 f8 ff ff       	call   80164e <fd2num>
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	83 c4 10             	add    $0x10,%esp
}
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
		fd_close(fd, 0);
  801e4a:	83 ec 08             	sub    $0x8,%esp
  801e4d:	6a 00                	push   $0x0
  801e4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e52:	e8 1b f9 ff ff       	call   801772 <fd_close>
		return r;
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	eb e5                	jmp    801e41 <open+0x6c>
		return -E_BAD_PATH;
  801e5c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e61:	eb de                	jmp    801e41 <open+0x6c>

00801e63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e69:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e73:	e8 68 fd ff ff       	call   801be0 <fsipc>
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e80:	68 8f 31 80 00       	push   $0x80318f
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	e8 65 f0 ff ff       	call   800ef2 <strcpy>
	return 0;
}
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <devsock_close>:
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	53                   	push   %ebx
  801e98:	83 ec 10             	sub    $0x10,%esp
  801e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e9e:	53                   	push   %ebx
  801e9f:	e8 fc 09 00 00       	call   8028a0 <pageref>
  801ea4:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ea7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801eac:	83 f8 01             	cmp    $0x1,%eax
  801eaf:	74 07                	je     801eb8 <devsock_close+0x24>
}
  801eb1:	89 d0                	mov    %edx,%eax
  801eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 73 0c             	pushl  0xc(%ebx)
  801ebe:	e8 b9 02 00 00       	call   80217c <nsipc_close>
  801ec3:	89 c2                	mov    %eax,%edx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	eb e7                	jmp    801eb1 <devsock_close+0x1d>

00801eca <devsock_write>:
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	ff 75 10             	pushl  0x10(%ebp)
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	ff 70 0c             	pushl  0xc(%eax)
  801ede:	e8 76 03 00 00       	call   802259 <nsipc_send>
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <devsock_read>:
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	ff 75 10             	pushl  0x10(%ebp)
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	ff 70 0c             	pushl  0xc(%eax)
  801ef9:	e8 ef 02 00 00       	call   8021ed <nsipc_recv>
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <fd2sockid>:
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f06:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	e8 b7 f7 ff ff       	call   8016c7 <fd_lookup>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	85 c0                	test   %eax,%eax
  801f15:	78 10                	js     801f27 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f20:	39 08                	cmp    %ecx,(%eax)
  801f22:	75 05                	jne    801f29 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f24:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    
		return -E_NOT_SUPP;
  801f29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f2e:	eb f7                	jmp    801f27 <fd2sockid+0x27>

00801f30 <alloc_sockfd>:
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	56                   	push   %esi
  801f34:	53                   	push   %ebx
  801f35:	83 ec 1c             	sub    $0x1c,%esp
  801f38:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3d:	50                   	push   %eax
  801f3e:	e8 32 f7 ff ff       	call   801675 <fd_alloc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 43                	js     801f8f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 07 04 00 00       	push   $0x407
  801f54:	ff 75 f4             	pushl  -0xc(%ebp)
  801f57:	6a 00                	push   $0x0
  801f59:	e8 86 f3 ff ff       	call   8012e4 <sys_page_alloc>
  801f5e:	89 c3                	mov    %eax,%ebx
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	85 c0                	test   %eax,%eax
  801f65:	78 28                	js     801f8f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f70:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	50                   	push   %eax
  801f83:	e8 c6 f6 ff ff       	call   80164e <fd2num>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	eb 0c                	jmp    801f9b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	56                   	push   %esi
  801f93:	e8 e4 01 00 00       	call   80217c <nsipc_close>
		return r;
  801f98:	83 c4 10             	add    $0x10,%esp
}
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    

00801fa4 <accept>:
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	e8 4e ff ff ff       	call   801f00 <fd2sockid>
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 1b                	js     801fd1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	ff 75 10             	pushl  0x10(%ebp)
  801fbc:	ff 75 0c             	pushl  0xc(%ebp)
  801fbf:	50                   	push   %eax
  801fc0:	e8 0e 01 00 00       	call   8020d3 <nsipc_accept>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 05                	js     801fd1 <accept+0x2d>
	return alloc_sockfd(r);
  801fcc:	e8 5f ff ff ff       	call   801f30 <alloc_sockfd>
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <bind>:
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	e8 1f ff ff ff       	call   801f00 <fd2sockid>
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 12                	js     801ff7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	ff 75 10             	pushl  0x10(%ebp)
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	50                   	push   %eax
  801fef:	e8 31 01 00 00       	call   802125 <nsipc_bind>
  801ff4:	83 c4 10             	add    $0x10,%esp
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <shutdown>:
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	e8 f9 fe ff ff       	call   801f00 <fd2sockid>
  802007:	85 c0                	test   %eax,%eax
  802009:	78 0f                	js     80201a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80200b:	83 ec 08             	sub    $0x8,%esp
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	50                   	push   %eax
  802012:	e8 43 01 00 00       	call   80215a <nsipc_shutdown>
  802017:	83 c4 10             	add    $0x10,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <connect>:
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	e8 d6 fe ff ff       	call   801f00 <fd2sockid>
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 12                	js     802040 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	ff 75 10             	pushl  0x10(%ebp)
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	50                   	push   %eax
  802038:	e8 59 01 00 00       	call   802196 <nsipc_connect>
  80203d:	83 c4 10             	add    $0x10,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <listen>:
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	e8 b0 fe ff ff       	call   801f00 <fd2sockid>
  802050:	85 c0                	test   %eax,%eax
  802052:	78 0f                	js     802063 <listen+0x21>
	return nsipc_listen(r, backlog);
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	50                   	push   %eax
  80205b:	e8 6b 01 00 00       	call   8021cb <nsipc_listen>
  802060:	83 c4 10             	add    $0x10,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <socket>:

int
socket(int domain, int type, int protocol)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80206b:	ff 75 10             	pushl  0x10(%ebp)
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	ff 75 08             	pushl  0x8(%ebp)
  802074:	e8 3e 02 00 00       	call   8022b7 <nsipc_socket>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 05                	js     802085 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802080:	e8 ab fe ff ff       	call   801f30 <alloc_sockfd>
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	53                   	push   %ebx
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802090:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  802097:	74 26                	je     8020bf <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802099:	6a 07                	push   $0x7
  80209b:	68 00 70 80 00       	push   $0x807000
  8020a0:	53                   	push   %ebx
  8020a1:	ff 35 b0 50 80 00    	pushl  0x8050b0
  8020a7:	e8 61 07 00 00       	call   80280d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ac:	83 c4 0c             	add    $0xc,%esp
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	e8 ea 06 00 00       	call   8027a4 <ipc_recv>
}
  8020ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	6a 02                	push   $0x2
  8020c4:	e8 9c 07 00 00       	call   802865 <ipc_find_env>
  8020c9:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	eb c6                	jmp    802099 <nsipc+0x12>

008020d3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020e3:	8b 06                	mov    (%esi),%eax
  8020e5:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ef:	e8 93 ff ff ff       	call   802087 <nsipc>
  8020f4:	89 c3                	mov    %eax,%ebx
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	79 09                	jns    802103 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020fa:	89 d8                	mov    %ebx,%eax
  8020fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5d                   	pop    %ebp
  802102:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	ff 35 10 70 80 00    	pushl  0x807010
  80210c:	68 00 70 80 00       	push   $0x807000
  802111:	ff 75 0c             	pushl  0xc(%ebp)
  802114:	e8 67 ef ff ff       	call   801080 <memmove>
		*addrlen = ret->ret_addrlen;
  802119:	a1 10 70 80 00       	mov    0x807010,%eax
  80211e:	89 06                	mov    %eax,(%esi)
  802120:	83 c4 10             	add    $0x10,%esp
	return r;
  802123:	eb d5                	jmp    8020fa <nsipc_accept+0x27>

00802125 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	53                   	push   %ebx
  802129:	83 ec 08             	sub    $0x8,%esp
  80212c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802137:	53                   	push   %ebx
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	68 04 70 80 00       	push   $0x807004
  802140:	e8 3b ef ff ff       	call   801080 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802145:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80214b:	b8 02 00 00 00       	mov    $0x2,%eax
  802150:	e8 32 ff ff ff       	call   802087 <nsipc>
}
  802155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802170:	b8 03 00 00 00       	mov    $0x3,%eax
  802175:	e8 0d ff ff ff       	call   802087 <nsipc>
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <nsipc_close>:

int
nsipc_close(int s)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80218a:	b8 04 00 00 00       	mov    $0x4,%eax
  80218f:	e8 f3 fe ff ff       	call   802087 <nsipc>
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	53                   	push   %ebx
  80219a:	83 ec 08             	sub    $0x8,%esp
  80219d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021a8:	53                   	push   %ebx
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	68 04 70 80 00       	push   $0x807004
  8021b1:	e8 ca ee ff ff       	call   801080 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021b6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8021c1:	e8 c1 fe ff ff       	call   802087 <nsipc>
}
  8021c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dc:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021e1:	b8 06 00 00 00       	mov    $0x6,%eax
  8021e6:	e8 9c fe ff ff       	call   802087 <nsipc>
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	56                   	push   %esi
  8021f1:	53                   	push   %ebx
  8021f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021fd:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802203:	8b 45 14             	mov    0x14(%ebp),%eax
  802206:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80220b:	b8 07 00 00 00       	mov    $0x7,%eax
  802210:	e8 72 fe ff ff       	call   802087 <nsipc>
  802215:	89 c3                	mov    %eax,%ebx
  802217:	85 c0                	test   %eax,%eax
  802219:	78 1f                	js     80223a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80221b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802220:	7f 21                	jg     802243 <nsipc_recv+0x56>
  802222:	39 c6                	cmp    %eax,%esi
  802224:	7c 1d                	jl     802243 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	50                   	push   %eax
  80222a:	68 00 70 80 00       	push   $0x807000
  80222f:	ff 75 0c             	pushl  0xc(%ebp)
  802232:	e8 49 ee ff ff       	call   801080 <memmove>
  802237:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80223a:	89 d8                	mov    %ebx,%eax
  80223c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802243:	68 9b 31 80 00       	push   $0x80319b
  802248:	68 63 31 80 00       	push   $0x803163
  80224d:	6a 62                	push   $0x62
  80224f:	68 b0 31 80 00       	push   $0x8031b0
  802254:	e8 44 e4 ff ff       	call   80069d <_panic>

00802259 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	53                   	push   %ebx
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80226b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802271:	7f 2e                	jg     8022a1 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	53                   	push   %ebx
  802277:	ff 75 0c             	pushl  0xc(%ebp)
  80227a:	68 0c 70 80 00       	push   $0x80700c
  80227f:	e8 fc ed ff ff       	call   801080 <memmove>
	nsipcbuf.send.req_size = size;
  802284:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80228a:	8b 45 14             	mov    0x14(%ebp),%eax
  80228d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802292:	b8 08 00 00 00       	mov    $0x8,%eax
  802297:	e8 eb fd ff ff       	call   802087 <nsipc>
}
  80229c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    
	assert(size < 1600);
  8022a1:	68 bc 31 80 00       	push   $0x8031bc
  8022a6:	68 63 31 80 00       	push   $0x803163
  8022ab:	6a 6d                	push   $0x6d
  8022ad:	68 b0 31 80 00       	push   $0x8031b0
  8022b2:	e8 e6 e3 ff ff       	call   80069d <_panic>

008022b7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c8:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022d5:	b8 09 00 00 00       	mov    $0x9,%eax
  8022da:	e8 a8 fd ff ff       	call   802087 <nsipc>
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	56                   	push   %esi
  8022e5:	53                   	push   %ebx
  8022e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	ff 75 08             	pushl  0x8(%ebp)
  8022ef:	e8 6a f3 ff ff       	call   80165e <fd2data>
  8022f4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022f6:	83 c4 08             	add    $0x8,%esp
  8022f9:	68 c8 31 80 00       	push   $0x8031c8
  8022fe:	53                   	push   %ebx
  8022ff:	e8 ee eb ff ff       	call   800ef2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802304:	8b 46 04             	mov    0x4(%esi),%eax
  802307:	2b 06                	sub    (%esi),%eax
  802309:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80230f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802316:	00 00 00 
	stat->st_dev = &devpipe;
  802319:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802320:	40 80 00 
	return 0;
}
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    

0080232f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	53                   	push   %ebx
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802339:	53                   	push   %ebx
  80233a:	6a 00                	push   $0x0
  80233c:	e8 28 f0 ff ff       	call   801369 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802341:	89 1c 24             	mov    %ebx,(%esp)
  802344:	e8 15 f3 ff ff       	call   80165e <fd2data>
  802349:	83 c4 08             	add    $0x8,%esp
  80234c:	50                   	push   %eax
  80234d:	6a 00                	push   $0x0
  80234f:	e8 15 f0 ff ff       	call   801369 <sys_page_unmap>
}
  802354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <_pipeisclosed>:
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	57                   	push   %edi
  80235d:	56                   	push   %esi
  80235e:	53                   	push   %ebx
  80235f:	83 ec 1c             	sub    $0x1c,%esp
  802362:	89 c7                	mov    %eax,%edi
  802364:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802366:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80236b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	57                   	push   %edi
  802372:	e8 29 05 00 00       	call   8028a0 <pageref>
  802377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80237a:	89 34 24             	mov    %esi,(%esp)
  80237d:	e8 1e 05 00 00       	call   8028a0 <pageref>
		nn = thisenv->env_runs;
  802382:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  802388:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	39 cb                	cmp    %ecx,%ebx
  802390:	74 1b                	je     8023ad <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802392:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802395:	75 cf                	jne    802366 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802397:	8b 42 58             	mov    0x58(%edx),%eax
  80239a:	6a 01                	push   $0x1
  80239c:	50                   	push   %eax
  80239d:	53                   	push   %ebx
  80239e:	68 cf 31 80 00       	push   $0x8031cf
  8023a3:	e8 eb e3 ff ff       	call   800793 <cprintf>
  8023a8:	83 c4 10             	add    $0x10,%esp
  8023ab:	eb b9                	jmp    802366 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023b0:	0f 94 c0             	sete   %al
  8023b3:	0f b6 c0             	movzbl %al,%eax
}
  8023b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023b9:	5b                   	pop    %ebx
  8023ba:	5e                   	pop    %esi
  8023bb:	5f                   	pop    %edi
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <devpipe_write>:
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 28             	sub    $0x28,%esp
  8023c7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023ca:	56                   	push   %esi
  8023cb:	e8 8e f2 ff ff       	call   80165e <fd2data>
  8023d0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023da:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023dd:	74 4f                	je     80242e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023df:	8b 43 04             	mov    0x4(%ebx),%eax
  8023e2:	8b 0b                	mov    (%ebx),%ecx
  8023e4:	8d 51 20             	lea    0x20(%ecx),%edx
  8023e7:	39 d0                	cmp    %edx,%eax
  8023e9:	72 14                	jb     8023ff <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023eb:	89 da                	mov    %ebx,%edx
  8023ed:	89 f0                	mov    %esi,%eax
  8023ef:	e8 65 ff ff ff       	call   802359 <_pipeisclosed>
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	75 3b                	jne    802433 <devpipe_write+0x75>
			sys_yield();
  8023f8:	e8 c8 ee ff ff       	call   8012c5 <sys_yield>
  8023fd:	eb e0                	jmp    8023df <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802402:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802406:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802409:	89 c2                	mov    %eax,%edx
  80240b:	c1 fa 1f             	sar    $0x1f,%edx
  80240e:	89 d1                	mov    %edx,%ecx
  802410:	c1 e9 1b             	shr    $0x1b,%ecx
  802413:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802416:	83 e2 1f             	and    $0x1f,%edx
  802419:	29 ca                	sub    %ecx,%edx
  80241b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80241f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802423:	83 c0 01             	add    $0x1,%eax
  802426:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802429:	83 c7 01             	add    $0x1,%edi
  80242c:	eb ac                	jmp    8023da <devpipe_write+0x1c>
	return i;
  80242e:	8b 45 10             	mov    0x10(%ebp),%eax
  802431:	eb 05                	jmp    802438 <devpipe_write+0x7a>
				return 0;
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802438:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    

00802440 <devpipe_read>:
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	57                   	push   %edi
  802444:	56                   	push   %esi
  802445:	53                   	push   %ebx
  802446:	83 ec 18             	sub    $0x18,%esp
  802449:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80244c:	57                   	push   %edi
  80244d:	e8 0c f2 ff ff       	call   80165e <fd2data>
  802452:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	be 00 00 00 00       	mov    $0x0,%esi
  80245c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80245f:	75 14                	jne    802475 <devpipe_read+0x35>
	return i;
  802461:	8b 45 10             	mov    0x10(%ebp),%eax
  802464:	eb 02                	jmp    802468 <devpipe_read+0x28>
				return i;
  802466:	89 f0                	mov    %esi,%eax
}
  802468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
			sys_yield();
  802470:	e8 50 ee ff ff       	call   8012c5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802475:	8b 03                	mov    (%ebx),%eax
  802477:	3b 43 04             	cmp    0x4(%ebx),%eax
  80247a:	75 18                	jne    802494 <devpipe_read+0x54>
			if (i > 0)
  80247c:	85 f6                	test   %esi,%esi
  80247e:	75 e6                	jne    802466 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802480:	89 da                	mov    %ebx,%edx
  802482:	89 f8                	mov    %edi,%eax
  802484:	e8 d0 fe ff ff       	call   802359 <_pipeisclosed>
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 e3                	je     802470 <devpipe_read+0x30>
				return 0;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	eb d4                	jmp    802468 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802494:	99                   	cltd   
  802495:	c1 ea 1b             	shr    $0x1b,%edx
  802498:	01 d0                	add    %edx,%eax
  80249a:	83 e0 1f             	and    $0x1f,%eax
  80249d:	29 d0                	sub    %edx,%eax
  80249f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024a7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024aa:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024ad:	83 c6 01             	add    $0x1,%esi
  8024b0:	eb aa                	jmp    80245c <devpipe_read+0x1c>

008024b2 <pipe>:
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024bd:	50                   	push   %eax
  8024be:	e8 b2 f1 ff ff       	call   801675 <fd_alloc>
  8024c3:	89 c3                	mov    %eax,%ebx
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	0f 88 23 01 00 00    	js     8025f3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	68 07 04 00 00       	push   $0x407
  8024d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8024db:	6a 00                	push   $0x0
  8024dd:	e8 02 ee ff ff       	call   8012e4 <sys_page_alloc>
  8024e2:	89 c3                	mov    %eax,%ebx
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	0f 88 04 01 00 00    	js     8025f3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024f5:	50                   	push   %eax
  8024f6:	e8 7a f1 ff ff       	call   801675 <fd_alloc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	85 c0                	test   %eax,%eax
  802502:	0f 88 db 00 00 00    	js     8025e3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	68 07 04 00 00       	push   $0x407
  802510:	ff 75 f0             	pushl  -0x10(%ebp)
  802513:	6a 00                	push   $0x0
  802515:	e8 ca ed ff ff       	call   8012e4 <sys_page_alloc>
  80251a:	89 c3                	mov    %eax,%ebx
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	85 c0                	test   %eax,%eax
  802521:	0f 88 bc 00 00 00    	js     8025e3 <pipe+0x131>
	va = fd2data(fd0);
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	ff 75 f4             	pushl  -0xc(%ebp)
  80252d:	e8 2c f1 ff ff       	call   80165e <fd2data>
  802532:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802534:	83 c4 0c             	add    $0xc,%esp
  802537:	68 07 04 00 00       	push   $0x407
  80253c:	50                   	push   %eax
  80253d:	6a 00                	push   $0x0
  80253f:	e8 a0 ed ff ff       	call   8012e4 <sys_page_alloc>
  802544:	89 c3                	mov    %eax,%ebx
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	85 c0                	test   %eax,%eax
  80254b:	0f 88 82 00 00 00    	js     8025d3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	ff 75 f0             	pushl  -0x10(%ebp)
  802557:	e8 02 f1 ff ff       	call   80165e <fd2data>
  80255c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802563:	50                   	push   %eax
  802564:	6a 00                	push   $0x0
  802566:	56                   	push   %esi
  802567:	6a 00                	push   $0x0
  802569:	e8 b9 ed ff ff       	call   801327 <sys_page_map>
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	83 c4 20             	add    $0x20,%esp
  802573:	85 c0                	test   %eax,%eax
  802575:	78 4e                	js     8025c5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802577:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80258b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a0:	e8 a9 f0 ff ff       	call   80164e <fd2num>
  8025a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025aa:	83 c4 04             	add    $0x4,%esp
  8025ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b0:	e8 99 f0 ff ff       	call   80164e <fd2num>
  8025b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025b8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025c3:	eb 2e                	jmp    8025f3 <pipe+0x141>
	sys_page_unmap(0, va);
  8025c5:	83 ec 08             	sub    $0x8,%esp
  8025c8:	56                   	push   %esi
  8025c9:	6a 00                	push   $0x0
  8025cb:	e8 99 ed ff ff       	call   801369 <sys_page_unmap>
  8025d0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025d3:	83 ec 08             	sub    $0x8,%esp
  8025d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d9:	6a 00                	push   $0x0
  8025db:	e8 89 ed ff ff       	call   801369 <sys_page_unmap>
  8025e0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025e3:	83 ec 08             	sub    $0x8,%esp
  8025e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e9:	6a 00                	push   $0x0
  8025eb:	e8 79 ed ff ff       	call   801369 <sys_page_unmap>
  8025f0:	83 c4 10             	add    $0x10,%esp
}
  8025f3:	89 d8                	mov    %ebx,%eax
  8025f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025f8:	5b                   	pop    %ebx
  8025f9:	5e                   	pop    %esi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <pipeisclosed>:
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802605:	50                   	push   %eax
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	e8 b9 f0 ff ff       	call   8016c7 <fd_lookup>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	78 18                	js     80262d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802615:	83 ec 0c             	sub    $0xc,%esp
  802618:	ff 75 f4             	pushl  -0xc(%ebp)
  80261b:	e8 3e f0 ff ff       	call   80165e <fd2data>
	return _pipeisclosed(fd, p);
  802620:	89 c2                	mov    %eax,%edx
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	e8 2f fd ff ff       	call   802359 <_pipeisclosed>
  80262a:	83 c4 10             	add    $0x10,%esp
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	c3                   	ret    

00802635 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80263b:	68 e7 31 80 00       	push   $0x8031e7
  802640:	ff 75 0c             	pushl  0xc(%ebp)
  802643:	e8 aa e8 ff ff       	call   800ef2 <strcpy>
	return 0;
}
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <devcons_write>:
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	57                   	push   %edi
  802653:	56                   	push   %esi
  802654:	53                   	push   %ebx
  802655:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80265b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802660:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802666:	3b 75 10             	cmp    0x10(%ebp),%esi
  802669:	73 31                	jae    80269c <devcons_write+0x4d>
		m = n - tot;
  80266b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80266e:	29 f3                	sub    %esi,%ebx
  802670:	83 fb 7f             	cmp    $0x7f,%ebx
  802673:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802678:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	53                   	push   %ebx
  80267f:	89 f0                	mov    %esi,%eax
  802681:	03 45 0c             	add    0xc(%ebp),%eax
  802684:	50                   	push   %eax
  802685:	57                   	push   %edi
  802686:	e8 f5 e9 ff ff       	call   801080 <memmove>
		sys_cputs(buf, m);
  80268b:	83 c4 08             	add    $0x8,%esp
  80268e:	53                   	push   %ebx
  80268f:	57                   	push   %edi
  802690:	e8 93 eb ff ff       	call   801228 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802695:	01 de                	add    %ebx,%esi
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	eb ca                	jmp    802666 <devcons_write+0x17>
}
  80269c:	89 f0                	mov    %esi,%eax
  80269e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    

008026a6 <devcons_read>:
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 08             	sub    $0x8,%esp
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b5:	74 21                	je     8026d8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026b7:	e8 8a eb ff ff       	call   801246 <sys_cgetc>
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	75 07                	jne    8026c7 <devcons_read+0x21>
		sys_yield();
  8026c0:	e8 00 ec ff ff       	call   8012c5 <sys_yield>
  8026c5:	eb f0                	jmp    8026b7 <devcons_read+0x11>
	if (c < 0)
  8026c7:	78 0f                	js     8026d8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026c9:	83 f8 04             	cmp    $0x4,%eax
  8026cc:	74 0c                	je     8026da <devcons_read+0x34>
	*(char*)vbuf = c;
  8026ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d1:	88 02                	mov    %al,(%edx)
	return 1;
  8026d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    
		return 0;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	eb f7                	jmp    8026d8 <devcons_read+0x32>

008026e1 <cputchar>:
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026ed:	6a 01                	push   $0x1
  8026ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026f2:	50                   	push   %eax
  8026f3:	e8 30 eb ff ff       	call   801228 <sys_cputs>
}
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <getchar>:
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802703:	6a 01                	push   $0x1
  802705:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802708:	50                   	push   %eax
  802709:	6a 00                	push   $0x0
  80270b:	e8 27 f2 ff ff       	call   801937 <read>
	if (r < 0)
  802710:	83 c4 10             	add    $0x10,%esp
  802713:	85 c0                	test   %eax,%eax
  802715:	78 06                	js     80271d <getchar+0x20>
	if (r < 1)
  802717:	74 06                	je     80271f <getchar+0x22>
	return c;
  802719:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    
		return -E_EOF;
  80271f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802724:	eb f7                	jmp    80271d <getchar+0x20>

00802726 <iscons>:
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272f:	50                   	push   %eax
  802730:	ff 75 08             	pushl  0x8(%ebp)
  802733:	e8 8f ef ff ff       	call   8016c7 <fd_lookup>
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	78 11                	js     802750 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802748:	39 10                	cmp    %edx,(%eax)
  80274a:	0f 94 c0             	sete   %al
  80274d:	0f b6 c0             	movzbl %al,%eax
}
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <opencons>:
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275b:	50                   	push   %eax
  80275c:	e8 14 ef ff ff       	call   801675 <fd_alloc>
  802761:	83 c4 10             	add    $0x10,%esp
  802764:	85 c0                	test   %eax,%eax
  802766:	78 3a                	js     8027a2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 07 04 00 00       	push   $0x407
  802770:	ff 75 f4             	pushl  -0xc(%ebp)
  802773:	6a 00                	push   $0x0
  802775:	e8 6a eb ff ff       	call   8012e4 <sys_page_alloc>
  80277a:	83 c4 10             	add    $0x10,%esp
  80277d:	85 c0                	test   %eax,%eax
  80277f:	78 21                	js     8027a2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80278a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	50                   	push   %eax
  80279a:	e8 af ee ff ff       	call   80164e <fd2num>
  80279f:	83 c4 10             	add    $0x10,%esp
}
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	56                   	push   %esi
  8027a8:	53                   	push   %ebx
  8027a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8027ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027b2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027b4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027b9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027bc:	83 ec 0c             	sub    $0xc,%esp
  8027bf:	50                   	push   %eax
  8027c0:	e8 cf ec ff ff       	call   801494 <sys_ipc_recv>
	if(ret < 0){
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	78 2b                	js     8027f7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027cc:	85 f6                	test   %esi,%esi
  8027ce:	74 0a                	je     8027da <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027d0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027d5:	8b 40 74             	mov    0x74(%eax),%eax
  8027d8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027da:	85 db                	test   %ebx,%ebx
  8027dc:	74 0a                	je     8027e8 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027de:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027e3:	8b 40 78             	mov    0x78(%eax),%eax
  8027e6:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027e8:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8027ed:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f3:	5b                   	pop    %ebx
  8027f4:	5e                   	pop    %esi
  8027f5:	5d                   	pop    %ebp
  8027f6:	c3                   	ret    
		if(from_env_store)
  8027f7:	85 f6                	test   %esi,%esi
  8027f9:	74 06                	je     802801 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802801:	85 db                	test   %ebx,%ebx
  802803:	74 eb                	je     8027f0 <ipc_recv+0x4c>
			*perm_store = 0;
  802805:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80280b:	eb e3                	jmp    8027f0 <ipc_recv+0x4c>

0080280d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	57                   	push   %edi
  802811:	56                   	push   %esi
  802812:	53                   	push   %ebx
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	8b 7d 08             	mov    0x8(%ebp),%edi
  802819:	8b 75 0c             	mov    0xc(%ebp),%esi
  80281c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80281f:	85 db                	test   %ebx,%ebx
  802821:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802826:	0f 44 d8             	cmove  %eax,%ebx
  802829:	eb 05                	jmp    802830 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80282b:	e8 95 ea ff ff       	call   8012c5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802830:	ff 75 14             	pushl  0x14(%ebp)
  802833:	53                   	push   %ebx
  802834:	56                   	push   %esi
  802835:	57                   	push   %edi
  802836:	e8 36 ec ff ff       	call   801471 <sys_ipc_try_send>
  80283b:	83 c4 10             	add    $0x10,%esp
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 1b                	je     80285d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802842:	79 e7                	jns    80282b <ipc_send+0x1e>
  802844:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802847:	74 e2                	je     80282b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802849:	83 ec 04             	sub    $0x4,%esp
  80284c:	68 f3 31 80 00       	push   $0x8031f3
  802851:	6a 48                	push   $0x48
  802853:	68 08 32 80 00       	push   $0x803208
  802858:	e8 40 de ff ff       	call   80069d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80285d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    

00802865 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802870:	89 c2                	mov    %eax,%edx
  802872:	c1 e2 07             	shl    $0x7,%edx
  802875:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80287b:	8b 52 50             	mov    0x50(%edx),%edx
  80287e:	39 ca                	cmp    %ecx,%edx
  802880:	74 11                	je     802893 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802882:	83 c0 01             	add    $0x1,%eax
  802885:	3d 00 04 00 00       	cmp    $0x400,%eax
  80288a:	75 e4                	jne    802870 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	eb 0b                	jmp    80289e <ipc_find_env+0x39>
			return envs[i].env_id;
  802893:	c1 e0 07             	shl    $0x7,%eax
  802896:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80289b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    

008028a0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a6:	89 d0                	mov    %edx,%eax
  8028a8:	c1 e8 16             	shr    $0x16,%eax
  8028ab:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b7:	f6 c1 01             	test   $0x1,%cl
  8028ba:	74 1d                	je     8028d9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028bc:	c1 ea 0c             	shr    $0xc,%edx
  8028bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c6:	f6 c2 01             	test   $0x1,%dl
  8028c9:	74 0e                	je     8028d9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028cb:	c1 ea 0c             	shr    $0xc,%edx
  8028ce:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d5:	ef 
  8028d6:	0f b7 c0             	movzwl %ax,%eax
}
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    
  8028db:	66 90                	xchg   %ax,%ax
  8028dd:	66 90                	xchg   %ax,%ax
  8028df:	90                   	nop

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 1c             	sub    $0x1c,%esp
  8028e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028f7:	85 d2                	test   %edx,%edx
  8028f9:	75 4d                	jne    802948 <__udivdi3+0x68>
  8028fb:	39 f3                	cmp    %esi,%ebx
  8028fd:	76 19                	jbe    802918 <__udivdi3+0x38>
  8028ff:	31 ff                	xor    %edi,%edi
  802901:	89 e8                	mov    %ebp,%eax
  802903:	89 f2                	mov    %esi,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 fa                	mov    %edi,%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	89 d9                	mov    %ebx,%ecx
  80291a:	85 db                	test   %ebx,%ebx
  80291c:	75 0b                	jne    802929 <__udivdi3+0x49>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	31 d2                	xor    %edx,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 c1                	mov    %eax,%ecx
  802929:	31 d2                	xor    %edx,%edx
  80292b:	89 f0                	mov    %esi,%eax
  80292d:	f7 f1                	div    %ecx
  80292f:	89 c6                	mov    %eax,%esi
  802931:	89 e8                	mov    %ebp,%eax
  802933:	89 f7                	mov    %esi,%edi
  802935:	f7 f1                	div    %ecx
  802937:	89 fa                	mov    %edi,%edx
  802939:	83 c4 1c             	add    $0x1c,%esp
  80293c:	5b                   	pop    %ebx
  80293d:	5e                   	pop    %esi
  80293e:	5f                   	pop    %edi
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	39 f2                	cmp    %esi,%edx
  80294a:	77 1c                	ja     802968 <__udivdi3+0x88>
  80294c:	0f bd fa             	bsr    %edx,%edi
  80294f:	83 f7 1f             	xor    $0x1f,%edi
  802952:	75 2c                	jne    802980 <__udivdi3+0xa0>
  802954:	39 f2                	cmp    %esi,%edx
  802956:	72 06                	jb     80295e <__udivdi3+0x7e>
  802958:	31 c0                	xor    %eax,%eax
  80295a:	39 eb                	cmp    %ebp,%ebx
  80295c:	77 a9                	ja     802907 <__udivdi3+0x27>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	eb a2                	jmp    802907 <__udivdi3+0x27>
  802965:	8d 76 00             	lea    0x0(%esi),%esi
  802968:	31 ff                	xor    %edi,%edi
  80296a:	31 c0                	xor    %eax,%eax
  80296c:	89 fa                	mov    %edi,%edx
  80296e:	83 c4 1c             	add    $0x1c,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	89 f9                	mov    %edi,%ecx
  802982:	b8 20 00 00 00       	mov    $0x20,%eax
  802987:	29 f8                	sub    %edi,%eax
  802989:	d3 e2                	shl    %cl,%edx
  80298b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80298f:	89 c1                	mov    %eax,%ecx
  802991:	89 da                	mov    %ebx,%edx
  802993:	d3 ea                	shr    %cl,%edx
  802995:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802999:	09 d1                	or     %edx,%ecx
  80299b:	89 f2                	mov    %esi,%edx
  80299d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029a1:	89 f9                	mov    %edi,%ecx
  8029a3:	d3 e3                	shl    %cl,%ebx
  8029a5:	89 c1                	mov    %eax,%ecx
  8029a7:	d3 ea                	shr    %cl,%edx
  8029a9:	89 f9                	mov    %edi,%ecx
  8029ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029af:	89 eb                	mov    %ebp,%ebx
  8029b1:	d3 e6                	shl    %cl,%esi
  8029b3:	89 c1                	mov    %eax,%ecx
  8029b5:	d3 eb                	shr    %cl,%ebx
  8029b7:	09 de                	or     %ebx,%esi
  8029b9:	89 f0                	mov    %esi,%eax
  8029bb:	f7 74 24 08          	divl   0x8(%esp)
  8029bf:	89 d6                	mov    %edx,%esi
  8029c1:	89 c3                	mov    %eax,%ebx
  8029c3:	f7 64 24 0c          	mull   0xc(%esp)
  8029c7:	39 d6                	cmp    %edx,%esi
  8029c9:	72 15                	jb     8029e0 <__udivdi3+0x100>
  8029cb:	89 f9                	mov    %edi,%ecx
  8029cd:	d3 e5                	shl    %cl,%ebp
  8029cf:	39 c5                	cmp    %eax,%ebp
  8029d1:	73 04                	jae    8029d7 <__udivdi3+0xf7>
  8029d3:	39 d6                	cmp    %edx,%esi
  8029d5:	74 09                	je     8029e0 <__udivdi3+0x100>
  8029d7:	89 d8                	mov    %ebx,%eax
  8029d9:	31 ff                	xor    %edi,%edi
  8029db:	e9 27 ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029e3:	31 ff                	xor    %edi,%edi
  8029e5:	e9 1d ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029ea:	66 90                	xchg   %ax,%ax
  8029ec:	66 90                	xchg   %ax,%ax
  8029ee:	66 90                	xchg   %ax,%ax

008029f0 <__umoddi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	57                   	push   %edi
  8029f2:	56                   	push   %esi
  8029f3:	53                   	push   %ebx
  8029f4:	83 ec 1c             	sub    $0x1c,%esp
  8029f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a07:	89 da                	mov    %ebx,%edx
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	75 43                	jne    802a50 <__umoddi3+0x60>
  802a0d:	39 df                	cmp    %ebx,%edi
  802a0f:	76 17                	jbe    802a28 <__umoddi3+0x38>
  802a11:	89 f0                	mov    %esi,%eax
  802a13:	f7 f7                	div    %edi
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	31 d2                	xor    %edx,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	89 fd                	mov    %edi,%ebp
  802a2a:	85 ff                	test   %edi,%edi
  802a2c:	75 0b                	jne    802a39 <__umoddi3+0x49>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	31 d2                	xor    %edx,%edx
  802a35:	f7 f7                	div    %edi
  802a37:	89 c5                	mov    %eax,%ebp
  802a39:	89 d8                	mov    %ebx,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	f7 f5                	div    %ebp
  802a3f:	89 f0                	mov    %esi,%eax
  802a41:	f7 f5                	div    %ebp
  802a43:	89 d0                	mov    %edx,%eax
  802a45:	eb d0                	jmp    802a17 <__umoddi3+0x27>
  802a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4e:	66 90                	xchg   %ax,%ax
  802a50:	89 f1                	mov    %esi,%ecx
  802a52:	39 d8                	cmp    %ebx,%eax
  802a54:	76 0a                	jbe    802a60 <__umoddi3+0x70>
  802a56:	89 f0                	mov    %esi,%eax
  802a58:	83 c4 1c             	add    $0x1c,%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	0f bd e8             	bsr    %eax,%ebp
  802a63:	83 f5 1f             	xor    $0x1f,%ebp
  802a66:	75 20                	jne    802a88 <__umoddi3+0x98>
  802a68:	39 d8                	cmp    %ebx,%eax
  802a6a:	0f 82 b0 00 00 00    	jb     802b20 <__umoddi3+0x130>
  802a70:	39 f7                	cmp    %esi,%edi
  802a72:	0f 86 a8 00 00 00    	jbe    802b20 <__umoddi3+0x130>
  802a78:	89 c8                	mov    %ecx,%eax
  802a7a:	83 c4 1c             	add    $0x1c,%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    
  802a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a8f:	29 ea                	sub    %ebp,%edx
  802a91:	d3 e0                	shl    %cl,%eax
  802a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a97:	89 d1                	mov    %edx,%ecx
  802a99:	89 f8                	mov    %edi,%eax
  802a9b:	d3 e8                	shr    %cl,%eax
  802a9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aa5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aa9:	09 c1                	or     %eax,%ecx
  802aab:	89 d8                	mov    %ebx,%eax
  802aad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab1:	89 e9                	mov    %ebp,%ecx
  802ab3:	d3 e7                	shl    %cl,%edi
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802abf:	d3 e3                	shl    %cl,%ebx
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	89 d1                	mov    %edx,%ecx
  802ac5:	89 f0                	mov    %esi,%eax
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 fa                	mov    %edi,%edx
  802acd:	d3 e6                	shl    %cl,%esi
  802acf:	09 d8                	or     %ebx,%eax
  802ad1:	f7 74 24 08          	divl   0x8(%esp)
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	89 f3                	mov    %esi,%ebx
  802ad9:	f7 64 24 0c          	mull   0xc(%esp)
  802add:	89 c6                	mov    %eax,%esi
  802adf:	89 d7                	mov    %edx,%edi
  802ae1:	39 d1                	cmp    %edx,%ecx
  802ae3:	72 06                	jb     802aeb <__umoddi3+0xfb>
  802ae5:	75 10                	jne    802af7 <__umoddi3+0x107>
  802ae7:	39 c3                	cmp    %eax,%ebx
  802ae9:	73 0c                	jae    802af7 <__umoddi3+0x107>
  802aeb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802af3:	89 d7                	mov    %edx,%edi
  802af5:	89 c6                	mov    %eax,%esi
  802af7:	89 ca                	mov    %ecx,%edx
  802af9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802afe:	29 f3                	sub    %esi,%ebx
  802b00:	19 fa                	sbb    %edi,%edx
  802b02:	89 d0                	mov    %edx,%eax
  802b04:	d3 e0                	shl    %cl,%eax
  802b06:	89 e9                	mov    %ebp,%ecx
  802b08:	d3 eb                	shr    %cl,%ebx
  802b0a:	d3 ea                	shr    %cl,%edx
  802b0c:	09 d8                	or     %ebx,%eax
  802b0e:	83 c4 1c             	add    $0x1c,%esp
  802b11:	5b                   	pop    %ebx
  802b12:	5e                   	pop    %esi
  802b13:	5f                   	pop    %edi
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	89 da                	mov    %ebx,%edx
  802b22:	29 fe                	sub    %edi,%esi
  802b24:	19 c2                	sbb    %eax,%edx
  802b26:	89 f1                	mov    %esi,%ecx
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	e9 4b ff ff ff       	jmp    802a7a <__umoddi3+0x8a>
