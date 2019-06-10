
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
  800044:	68 d0 2c 80 00       	push   $0x802cd0
  800049:	68 a0 2b 80 00       	push   $0x802ba0
  80004e:	e8 91 07 00 00       	call   8007e4 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 b0 2b 80 00       	push   $0x802bb0
  80005c:	68 b4 2b 80 00       	push   $0x802bb4
  800061:	e8 7e 07 00 00       	call   8007e4 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c8 2b 80 00       	push   $0x802bc8
  80007b:	e8 64 07 00 00       	call   8007e4 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 d2 2b 80 00       	push   $0x802bd2
  800093:	68 b4 2b 80 00       	push   $0x802bb4
  800098:	e8 47 07 00 00       	call   8007e4 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 c8 2b 80 00       	push   $0x802bc8
  8000b4:	e8 2b 07 00 00       	call   8007e4 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 d6 2b 80 00       	push   $0x802bd6
  8000cc:	68 b4 2b 80 00       	push   $0x802bb4
  8000d1:	e8 0e 07 00 00       	call   8007e4 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 c8 2b 80 00       	push   $0x802bc8
  8000ed:	e8 f2 06 00 00       	call   8007e4 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 da 2b 80 00       	push   $0x802bda
  800105:	68 b4 2b 80 00       	push   $0x802bb4
  80010a:	e8 d5 06 00 00       	call   8007e4 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 c8 2b 80 00       	push   $0x802bc8
  800126:	e8 b9 06 00 00       	call   8007e4 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 de 2b 80 00       	push   $0x802bde
  80013e:	68 b4 2b 80 00       	push   $0x802bb4
  800143:	e8 9c 06 00 00       	call   8007e4 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 c8 2b 80 00       	push   $0x802bc8
  80015f:	e8 80 06 00 00       	call   8007e4 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 e2 2b 80 00       	push   $0x802be2
  800177:	68 b4 2b 80 00       	push   $0x802bb4
  80017c:	e8 63 06 00 00       	call   8007e4 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 c8 2b 80 00       	push   $0x802bc8
  800198:	e8 47 06 00 00       	call   8007e4 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 e6 2b 80 00       	push   $0x802be6
  8001b0:	68 b4 2b 80 00       	push   $0x802bb4
  8001b5:	e8 2a 06 00 00       	call   8007e4 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 c8 2b 80 00       	push   $0x802bc8
  8001d1:	e8 0e 06 00 00       	call   8007e4 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ea 2b 80 00       	push   $0x802bea
  8001e9:	68 b4 2b 80 00       	push   $0x802bb4
  8001ee:	e8 f1 05 00 00       	call   8007e4 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 c8 2b 80 00       	push   $0x802bc8
  80020a:	e8 d5 05 00 00       	call   8007e4 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ee 2b 80 00       	push   $0x802bee
  800222:	68 b4 2b 80 00       	push   $0x802bb4
  800227:	e8 b8 05 00 00       	call   8007e4 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 c8 2b 80 00       	push   $0x802bc8
  800243:	e8 9c 05 00 00       	call   8007e4 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 f5 2b 80 00       	push   $0x802bf5
  800253:	68 b4 2b 80 00       	push   $0x802bb4
  800258:	e8 87 05 00 00       	call   8007e4 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 c8 2b 80 00       	push   $0x802bc8
  800274:	e8 6b 05 00 00       	call   8007e4 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 f9 2b 80 00       	push   $0x802bf9
  800284:	e8 5b 05 00 00       	call   8007e4 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 c8 2b 80 00       	push   $0x802bc8
  800294:	e8 4b 05 00 00       	call   8007e4 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 c4 2b 80 00       	push   $0x802bc4
  8002a9:	e8 36 05 00 00       	call   8007e4 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 c4 2b 80 00       	push   $0x802bc4
  8002c3:	e8 1c 05 00 00       	call   8007e4 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 c4 2b 80 00       	push   $0x802bc4
  8002d8:	e8 07 05 00 00       	call   8007e4 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 c4 2b 80 00       	push   $0x802bc4
  8002ed:	e8 f2 04 00 00       	call   8007e4 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 c4 2b 80 00       	push   $0x802bc4
  800302:	e8 dd 04 00 00       	call   8007e4 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 c4 2b 80 00       	push   $0x802bc4
  800317:	e8 c8 04 00 00       	call   8007e4 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 c4 2b 80 00       	push   $0x802bc4
  80032c:	e8 b3 04 00 00       	call   8007e4 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 c4 2b 80 00       	push   $0x802bc4
  800341:	e8 9e 04 00 00       	call   8007e4 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 c4 2b 80 00       	push   $0x802bc4
  800356:	e8 89 04 00 00       	call   8007e4 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 f5 2b 80 00       	push   $0x802bf5
  800366:	68 b4 2b 80 00       	push   $0x802bb4
  80036b:	e8 74 04 00 00       	call   8007e4 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 c4 2b 80 00       	push   $0x802bc4
  800387:	e8 58 04 00 00       	call   8007e4 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 f9 2b 80 00       	push   $0x802bf9
  800397:	e8 48 04 00 00       	call   8007e4 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 c4 2b 80 00       	push   $0x802bc4
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
  8003c2:	68 c4 2b 80 00       	push   $0x802bc4
  8003c7:	e8 18 04 00 00       	call   8007e4 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 f9 2b 80 00       	push   $0x802bf9
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
  800466:	68 1f 2c 80 00       	push   $0x802c1f
  80046b:	68 2d 2c 80 00       	push   $0x802c2d
  800470:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800475:	ba 18 2c 80 00       	mov    $0x802c18,%edx
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
  8004a5:	68 60 2c 80 00       	push   $0x802c60
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 07 2c 80 00       	push   $0x802c07
  8004b1:	e8 38 02 00 00       	call   8006ee <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 34 2c 80 00       	push   $0x802c34
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 07 2c 80 00       	push   $0x802c07
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
  8004d3:	e8 52 11 00 00       	call   80162a <set_pgfault_handler>

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
  8005ac:	68 47 2c 80 00       	push   $0x802c47
  8005b1:	68 58 2c 80 00       	push   $0x802c58
  8005b6:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005bb:	ba 18 2c 80 00       	mov    $0x802c18,%edx
  8005c0:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 94 2c 80 00       	push   $0x802c94
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
  800664:	68 b3 2c 80 00       	push   $0x802cb3
  800669:	e8 76 01 00 00       	call   8007e4 <cprintf>
	cprintf("before umain\n");
  80066e:	c7 04 24 d1 2c 80 00 	movl   $0x802cd1,(%esp)
  800675:	e8 6a 01 00 00       	call   8007e4 <cprintf>
	// call user main routine
	umain(argc, argv);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 08             	pushl  0x8(%ebp)
  800683:	e8 40 fe ff ff       	call   8004c8 <umain>
	cprintf("after umain\n");
  800688:	c7 04 24 df 2c 80 00 	movl   $0x802cdf,(%esp)
  80068f:	e8 50 01 00 00       	call   8007e4 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800694:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  800699:	8b 40 48             	mov    0x48(%eax),%eax
  80069c:	83 c4 08             	add    $0x8,%esp
  80069f:	50                   	push   %eax
  8006a0:	68 ec 2c 80 00       	push   $0x802cec
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
  8006c8:	68 18 2d 80 00       	push   $0x802d18
  8006cd:	50                   	push   %eax
  8006ce:	68 0b 2d 80 00       	push   $0x802d0b
  8006d3:	e8 0c 01 00 00       	call   8007e4 <cprintf>
	close_all();
  8006d8:	e8 ba 11 00 00       	call   801897 <close_all>
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
  8006fe:	68 44 2d 80 00       	push   $0x802d44
  800703:	50                   	push   %eax
  800704:	68 0b 2d 80 00       	push   $0x802d0b
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
  800727:	68 20 2d 80 00       	push   $0x802d20
  80072c:	e8 b3 00 00 00       	call   8007e4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800731:	83 c4 18             	add    $0x18,%esp
  800734:	53                   	push   %ebx
  800735:	ff 75 10             	pushl  0x10(%ebp)
  800738:	e8 56 00 00 00       	call   800793 <vcprintf>
	cprintf("\n");
  80073d:	c7 04 24 cf 2c 80 00 	movl   $0x802ccf,(%esp)
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
  800891:	e8 ba 20 00 00       	call   802950 <__udivdi3>
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
  8008ba:	e8 a1 21 00 00       	call   802a60 <__umoddi3>
  8008bf:	83 c4 14             	add    $0x14,%esp
  8008c2:	0f be 80 4b 2d 80 00 	movsbl 0x802d4b(%eax),%eax
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
  80096b:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
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
  800a36:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  800a3d:	85 d2                	test   %edx,%edx
  800a3f:	74 18                	je     800a59 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800a41:	52                   	push   %edx
  800a42:	68 19 32 80 00       	push   $0x803219
  800a47:	53                   	push   %ebx
  800a48:	56                   	push   %esi
  800a49:	e8 a6 fe ff ff       	call   8008f4 <printfmt>
  800a4e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a51:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a54:	e9 fe 02 00 00       	jmp    800d57 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a59:	50                   	push   %eax
  800a5a:	68 63 2d 80 00       	push   $0x802d63
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
  800a81:	b8 5c 2d 80 00       	mov    $0x802d5c,%eax
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
  800e19:	bf 81 2e 80 00       	mov    $0x802e81,%edi
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
  800e45:	bf b9 2e 80 00       	mov    $0x802eb9,%edi
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
  8012e6:	68 c8 30 80 00       	push   $0x8030c8
  8012eb:	6a 43                	push   $0x43
  8012ed:	68 e5 30 80 00       	push   $0x8030e5
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
  801367:	68 c8 30 80 00       	push   $0x8030c8
  80136c:	6a 43                	push   $0x43
  80136e:	68 e5 30 80 00       	push   $0x8030e5
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
  8013a9:	68 c8 30 80 00       	push   $0x8030c8
  8013ae:	6a 43                	push   $0x43
  8013b0:	68 e5 30 80 00       	push   $0x8030e5
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
  8013eb:	68 c8 30 80 00       	push   $0x8030c8
  8013f0:	6a 43                	push   $0x43
  8013f2:	68 e5 30 80 00       	push   $0x8030e5
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
  80142d:	68 c8 30 80 00       	push   $0x8030c8
  801432:	6a 43                	push   $0x43
  801434:	68 e5 30 80 00       	push   $0x8030e5
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
  80146f:	68 c8 30 80 00       	push   $0x8030c8
  801474:	6a 43                	push   $0x43
  801476:	68 e5 30 80 00       	push   $0x8030e5
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
  8014b1:	68 c8 30 80 00       	push   $0x8030c8
  8014b6:	6a 43                	push   $0x43
  8014b8:	68 e5 30 80 00       	push   $0x8030e5
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
  801515:	68 c8 30 80 00       	push   $0x8030c8
  80151a:	6a 43                	push   $0x43
  80151c:	68 e5 30 80 00       	push   $0x8030e5
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
  8015f9:	68 c8 30 80 00       	push   $0x8030c8
  8015fe:	6a 43                	push   $0x43
  801600:	68 e5 30 80 00       	push   $0x8030e5
  801605:	e8 e4 f0 ff ff       	call   8006ee <_panic>

0080160a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801610:	b9 00 00 00 00       	mov    $0x0,%ecx
  801615:	8b 55 08             	mov    0x8(%ebp),%edx
  801618:	b8 14 00 00 00       	mov    $0x14,%eax
  80161d:	89 cb                	mov    %ecx,%ebx
  80161f:	89 cf                	mov    %ecx,%edi
  801621:	89 ce                	mov    %ecx,%esi
  801623:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5f                   	pop    %edi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801630:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  801637:	74 0a                	je     801643 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	6a 07                	push   $0x7
  801648:	68 00 f0 bf ee       	push   $0xeebff000
  80164d:	6a 00                	push   $0x0
  80164f:	e8 e1 fc ff ff       	call   801335 <sys_page_alloc>
		if(r < 0)
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 2a                	js     801685 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	68 99 16 80 00       	push   $0x801699
  801663:	6a 00                	push   $0x0
  801665:	e8 16 fe ff ff       	call   801480 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	79 c8                	jns    801639 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 24 31 80 00       	push   $0x803124
  801679:	6a 25                	push   $0x25
  80167b:	68 5d 31 80 00       	push   $0x80315d
  801680:	e8 69 f0 ff ff       	call   8006ee <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	68 f4 30 80 00       	push   $0x8030f4
  80168d:	6a 22                	push   $0x22
  80168f:	68 5d 31 80 00       	push   $0x80315d
  801694:	e8 55 f0 ff ff       	call   8006ee <_panic>

00801699 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801699:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80169a:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  80169f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8016a1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8016a4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8016a8:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8016ac:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8016af:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8016b1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8016b5:	83 c4 08             	add    $0x8,%esp
	popal
  8016b8:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8016b9:	83 c4 04             	add    $0x4,%esp
	popfl
  8016bc:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8016bd:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8016be:	c3                   	ret    

008016bf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	05 00 00 00 30       	add    $0x30000000,%eax
  8016ca:	c1 e8 0c             	shr    $0xc,%eax
}
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016df:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    

008016e6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016ee:	89 c2                	mov    %eax,%edx
  8016f0:	c1 ea 16             	shr    $0x16,%edx
  8016f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016fa:	f6 c2 01             	test   $0x1,%dl
  8016fd:	74 2d                	je     80172c <fd_alloc+0x46>
  8016ff:	89 c2                	mov    %eax,%edx
  801701:	c1 ea 0c             	shr    $0xc,%edx
  801704:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80170b:	f6 c2 01             	test   $0x1,%dl
  80170e:	74 1c                	je     80172c <fd_alloc+0x46>
  801710:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801715:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80171a:	75 d2                	jne    8016ee <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801725:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80172a:	eb 0a                	jmp    801736 <fd_alloc+0x50>
			*fd_store = fd;
  80172c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80173e:	83 f8 1f             	cmp    $0x1f,%eax
  801741:	77 30                	ja     801773 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801743:	c1 e0 0c             	shl    $0xc,%eax
  801746:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80174b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801751:	f6 c2 01             	test   $0x1,%dl
  801754:	74 24                	je     80177a <fd_lookup+0x42>
  801756:	89 c2                	mov    %eax,%edx
  801758:	c1 ea 0c             	shr    $0xc,%edx
  80175b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801762:	f6 c2 01             	test   $0x1,%dl
  801765:	74 1a                	je     801781 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	89 02                	mov    %eax,(%edx)
	return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
		return -E_INVAL;
  801773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801778:	eb f7                	jmp    801771 <fd_lookup+0x39>
		return -E_INVAL;
  80177a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177f:	eb f0                	jmp    801771 <fd_lookup+0x39>
  801781:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801786:	eb e9                	jmp    801771 <fd_lookup+0x39>

00801788 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80179b:	39 08                	cmp    %ecx,(%eax)
  80179d:	74 38                	je     8017d7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80179f:	83 c2 01             	add    $0x1,%edx
  8017a2:	8b 04 95 ec 31 80 00 	mov    0x8031ec(,%edx,4),%eax
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	75 ee                	jne    80179b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017ad:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8017b2:	8b 40 48             	mov    0x48(%eax),%eax
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	51                   	push   %ecx
  8017b9:	50                   	push   %eax
  8017ba:	68 6c 31 80 00       	push   $0x80316c
  8017bf:	e8 20 f0 ff ff       	call   8007e4 <cprintf>
	*dev = 0;
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    
			*dev = devtab[i];
  8017d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017da:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e1:	eb f2                	jmp    8017d5 <dev_lookup+0x4d>

008017e3 <fd_close>:
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	57                   	push   %edi
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 24             	sub    $0x24,%esp
  8017ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8017ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017f5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017fc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017ff:	50                   	push   %eax
  801800:	e8 33 ff ff ff       	call   801738 <fd_lookup>
  801805:	89 c3                	mov    %eax,%ebx
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 05                	js     801813 <fd_close+0x30>
	    || fd != fd2)
  80180e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801811:	74 16                	je     801829 <fd_close+0x46>
		return (must_exist ? r : 0);
  801813:	89 f8                	mov    %edi,%eax
  801815:	84 c0                	test   %al,%al
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	0f 44 d8             	cmove  %eax,%ebx
}
  80181f:	89 d8                	mov    %ebx,%eax
  801821:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5f                   	pop    %edi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	ff 36                	pushl  (%esi)
  801832:	e8 51 ff ff ff       	call   801788 <dev_lookup>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 1a                	js     80185a <fd_close+0x77>
		if (dev->dev_close)
  801840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801843:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801846:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80184b:	85 c0                	test   %eax,%eax
  80184d:	74 0b                	je     80185a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80184f:	83 ec 0c             	sub    $0xc,%esp
  801852:	56                   	push   %esi
  801853:	ff d0                	call   *%eax
  801855:	89 c3                	mov    %eax,%ebx
  801857:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	56                   	push   %esi
  80185e:	6a 00                	push   $0x0
  801860:	e8 55 fb ff ff       	call   8013ba <sys_page_unmap>
	return r;
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	eb b5                	jmp    80181f <fd_close+0x3c>

0080186a <close>:

int
close(int fdnum)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801870:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801873:	50                   	push   %eax
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	e8 bc fe ff ff       	call   801738 <fd_lookup>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	79 02                	jns    801885 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    
		return fd_close(fd, 1);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	6a 01                	push   $0x1
  80188a:	ff 75 f4             	pushl  -0xc(%ebp)
  80188d:	e8 51 ff ff ff       	call   8017e3 <fd_close>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	eb ec                	jmp    801883 <close+0x19>

00801897 <close_all>:

void
close_all(void)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
  80189b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80189e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	53                   	push   %ebx
  8018a7:	e8 be ff ff ff       	call   80186a <close>
	for (i = 0; i < MAXFD; i++)
  8018ac:	83 c3 01             	add    $0x1,%ebx
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	83 fb 20             	cmp    $0x20,%ebx
  8018b5:	75 ec                	jne    8018a3 <close_all+0xc>
}
  8018b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	e8 67 fe ff ff       	call   801738 <fd_lookup>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	0f 88 81 00 00 00    	js     80195f <dup+0xa3>
		return r;
	close(newfdnum);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	e8 81 ff ff ff       	call   80186a <close>

	newfd = INDEX2FD(newfdnum);
  8018e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018ec:	c1 e6 0c             	shl    $0xc,%esi
  8018ef:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018f5:	83 c4 04             	add    $0x4,%esp
  8018f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018fb:	e8 cf fd ff ff       	call   8016cf <fd2data>
  801900:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801902:	89 34 24             	mov    %esi,(%esp)
  801905:	e8 c5 fd ff ff       	call   8016cf <fd2data>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80190f:	89 d8                	mov    %ebx,%eax
  801911:	c1 e8 16             	shr    $0x16,%eax
  801914:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80191b:	a8 01                	test   $0x1,%al
  80191d:	74 11                	je     801930 <dup+0x74>
  80191f:	89 d8                	mov    %ebx,%eax
  801921:	c1 e8 0c             	shr    $0xc,%eax
  801924:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80192b:	f6 c2 01             	test   $0x1,%dl
  80192e:	75 39                	jne    801969 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801933:	89 d0                	mov    %edx,%eax
  801935:	c1 e8 0c             	shr    $0xc,%eax
  801938:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80193f:	83 ec 0c             	sub    $0xc,%esp
  801942:	25 07 0e 00 00       	and    $0xe07,%eax
  801947:	50                   	push   %eax
  801948:	56                   	push   %esi
  801949:	6a 00                	push   $0x0
  80194b:	52                   	push   %edx
  80194c:	6a 00                	push   $0x0
  80194e:	e8 25 fa ff ff       	call   801378 <sys_page_map>
  801953:	89 c3                	mov    %eax,%ebx
  801955:	83 c4 20             	add    $0x20,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 31                	js     80198d <dup+0xd1>
		goto err;

	return newfdnum;
  80195c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80195f:	89 d8                	mov    %ebx,%eax
  801961:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801964:	5b                   	pop    %ebx
  801965:	5e                   	pop    %esi
  801966:	5f                   	pop    %edi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801969:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	25 07 0e 00 00       	and    $0xe07,%eax
  801978:	50                   	push   %eax
  801979:	57                   	push   %edi
  80197a:	6a 00                	push   $0x0
  80197c:	53                   	push   %ebx
  80197d:	6a 00                	push   $0x0
  80197f:	e8 f4 f9 ff ff       	call   801378 <sys_page_map>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 20             	add    $0x20,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	79 a3                	jns    801930 <dup+0x74>
	sys_page_unmap(0, newfd);
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	56                   	push   %esi
  801991:	6a 00                	push   $0x0
  801993:	e8 22 fa ff ff       	call   8013ba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801998:	83 c4 08             	add    $0x8,%esp
  80199b:	57                   	push   %edi
  80199c:	6a 00                	push   $0x0
  80199e:	e8 17 fa ff ff       	call   8013ba <sys_page_unmap>
	return r;
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	eb b7                	jmp    80195f <dup+0xa3>

008019a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	53                   	push   %ebx
  8019ac:	83 ec 1c             	sub    $0x1c,%esp
  8019af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b5:	50                   	push   %eax
  8019b6:	53                   	push   %ebx
  8019b7:	e8 7c fd ff ff       	call   801738 <fd_lookup>
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 3f                	js     801a02 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c9:	50                   	push   %eax
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	ff 30                	pushl  (%eax)
  8019cf:	e8 b4 fd ff ff       	call   801788 <dev_lookup>
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 27                	js     801a02 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019de:	8b 42 08             	mov    0x8(%edx),%eax
  8019e1:	83 e0 03             	and    $0x3,%eax
  8019e4:	83 f8 01             	cmp    $0x1,%eax
  8019e7:	74 1e                	je     801a07 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	8b 40 08             	mov    0x8(%eax),%eax
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	74 35                	je     801a28 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	ff 75 10             	pushl  0x10(%ebp)
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	52                   	push   %edx
  8019fd:	ff d0                	call   *%eax
  8019ff:	83 c4 10             	add    $0x10,%esp
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a07:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801a0c:	8b 40 48             	mov    0x48(%eax),%eax
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	53                   	push   %ebx
  801a13:	50                   	push   %eax
  801a14:	68 b0 31 80 00       	push   $0x8031b0
  801a19:	e8 c6 ed ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a26:	eb da                	jmp    801a02 <read+0x5a>
		return -E_NOT_SUPP;
  801a28:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2d:	eb d3                	jmp    801a02 <read+0x5a>

00801a2f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	57                   	push   %edi
  801a33:	56                   	push   %esi
  801a34:	53                   	push   %ebx
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a3b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a43:	39 f3                	cmp    %esi,%ebx
  801a45:	73 23                	jae    801a6a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	89 f0                	mov    %esi,%eax
  801a4c:	29 d8                	sub    %ebx,%eax
  801a4e:	50                   	push   %eax
  801a4f:	89 d8                	mov    %ebx,%eax
  801a51:	03 45 0c             	add    0xc(%ebp),%eax
  801a54:	50                   	push   %eax
  801a55:	57                   	push   %edi
  801a56:	e8 4d ff ff ff       	call   8019a8 <read>
		if (m < 0)
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 06                	js     801a68 <readn+0x39>
			return m;
		if (m == 0)
  801a62:	74 06                	je     801a6a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a64:	01 c3                	add    %eax,%ebx
  801a66:	eb db                	jmp    801a43 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a68:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5f                   	pop    %edi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    

00801a74 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	53                   	push   %ebx
  801a78:	83 ec 1c             	sub    $0x1c,%esp
  801a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a81:	50                   	push   %eax
  801a82:	53                   	push   %ebx
  801a83:	e8 b0 fc ff ff       	call   801738 <fd_lookup>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 3a                	js     801ac9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a95:	50                   	push   %eax
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	ff 30                	pushl  (%eax)
  801a9b:	e8 e8 fc ff ff       	call   801788 <dev_lookup>
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 22                	js     801ac9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aae:	74 1e                	je     801ace <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab3:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab6:	85 d2                	test   %edx,%edx
  801ab8:	74 35                	je     801aef <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	50                   	push   %eax
  801ac4:	ff d2                	call   *%edx
  801ac6:	83 c4 10             	add    $0x10,%esp
}
  801ac9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ace:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801ad3:	8b 40 48             	mov    0x48(%eax),%eax
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	53                   	push   %ebx
  801ada:	50                   	push   %eax
  801adb:	68 cc 31 80 00       	push   $0x8031cc
  801ae0:	e8 ff ec ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aed:	eb da                	jmp    801ac9 <write+0x55>
		return -E_NOT_SUPP;
  801aef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af4:	eb d3                	jmp    801ac9 <write+0x55>

00801af6 <seek>:

int
seek(int fdnum, off_t offset)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801afc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aff:	50                   	push   %eax
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	e8 30 fc ff ff       	call   801738 <fd_lookup>
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	78 0e                	js     801b1d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b15:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 1c             	sub    $0x1c,%esp
  801b26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b29:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2c:	50                   	push   %eax
  801b2d:	53                   	push   %ebx
  801b2e:	e8 05 fc ff ff       	call   801738 <fd_lookup>
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 37                	js     801b71 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3a:	83 ec 08             	sub    $0x8,%esp
  801b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b40:	50                   	push   %eax
  801b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b44:	ff 30                	pushl  (%eax)
  801b46:	e8 3d fc ff ff       	call   801788 <dev_lookup>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 1f                	js     801b71 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b55:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b59:	74 1b                	je     801b76 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5e:	8b 52 18             	mov    0x18(%edx),%edx
  801b61:	85 d2                	test   %edx,%edx
  801b63:	74 32                	je     801b97 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	ff d2                	call   *%edx
  801b6e:	83 c4 10             	add    $0x10,%esp
}
  801b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b76:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b7b:	8b 40 48             	mov    0x48(%eax),%eax
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	53                   	push   %ebx
  801b82:	50                   	push   %eax
  801b83:	68 8c 31 80 00       	push   $0x80318c
  801b88:	e8 57 ec ff ff       	call   8007e4 <cprintf>
		return -E_INVAL;
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b95:	eb da                	jmp    801b71 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b97:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b9c:	eb d3                	jmp    801b71 <ftruncate+0x52>

00801b9e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	53                   	push   %ebx
  801ba2:	83 ec 1c             	sub    $0x1c,%esp
  801ba5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ba8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bab:	50                   	push   %eax
  801bac:	ff 75 08             	pushl  0x8(%ebp)
  801baf:	e8 84 fb ff ff       	call   801738 <fd_lookup>
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 4b                	js     801c06 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc1:	50                   	push   %eax
  801bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc5:	ff 30                	pushl  (%eax)
  801bc7:	e8 bc fb ff ff       	call   801788 <dev_lookup>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 33                	js     801c06 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bda:	74 2f                	je     801c0b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bdc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bdf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801be6:	00 00 00 
	stat->st_isdir = 0;
  801be9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf0:	00 00 00 
	stat->st_dev = dev;
  801bf3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bf9:	83 ec 08             	sub    $0x8,%esp
  801bfc:	53                   	push   %ebx
  801bfd:	ff 75 f0             	pushl  -0x10(%ebp)
  801c00:	ff 50 14             	call   *0x14(%eax)
  801c03:	83 c4 10             	add    $0x10,%esp
}
  801c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    
		return -E_NOT_SUPP;
  801c0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c10:	eb f4                	jmp    801c06 <fstat+0x68>

00801c12 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	56                   	push   %esi
  801c16:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c17:	83 ec 08             	sub    $0x8,%esp
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	e8 22 02 00 00       	call   801e46 <open>
  801c24:	89 c3                	mov    %eax,%ebx
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 1b                	js     801c48 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	50                   	push   %eax
  801c34:	e8 65 ff ff ff       	call   801b9e <fstat>
  801c39:	89 c6                	mov    %eax,%esi
	close(fd);
  801c3b:	89 1c 24             	mov    %ebx,(%esp)
  801c3e:	e8 27 fc ff ff       	call   80186a <close>
	return r;
  801c43:	83 c4 10             	add    $0x10,%esp
  801c46:	89 f3                	mov    %esi,%ebx
}
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    

00801c51 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	89 c6                	mov    %eax,%esi
  801c58:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c5a:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801c61:	74 27                	je     801c8a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c63:	6a 07                	push   $0x7
  801c65:	68 00 60 80 00       	push   $0x806000
  801c6a:	56                   	push   %esi
  801c6b:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801c71:	e8 08 0c 00 00       	call   80287e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c76:	83 c4 0c             	add    $0xc,%esp
  801c79:	6a 00                	push   $0x0
  801c7b:	53                   	push   %ebx
  801c7c:	6a 00                	push   $0x0
  801c7e:	e8 92 0b 00 00       	call   802815 <ipc_recv>
}
  801c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	6a 01                	push   $0x1
  801c8f:	e8 42 0c 00 00       	call   8028d6 <ipc_find_env>
  801c94:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801c99:	83 c4 10             	add    $0x10,%esp
  801c9c:	eb c5                	jmp    801c63 <fsipc+0x12>

00801c9e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  801caa:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb2:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc1:	e8 8b ff ff ff       	call   801c51 <fsipc>
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <devfile_flush>:
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd4:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cde:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce3:	e8 69 ff ff ff       	call   801c51 <fsipc>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <devfile_stat>:
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfa:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cff:	ba 00 00 00 00       	mov    $0x0,%edx
  801d04:	b8 05 00 00 00       	mov    $0x5,%eax
  801d09:	e8 43 ff ff ff       	call   801c51 <fsipc>
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 2c                	js     801d3e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d12:	83 ec 08             	sub    $0x8,%esp
  801d15:	68 00 60 80 00       	push   $0x806000
  801d1a:	53                   	push   %ebx
  801d1b:	e8 23 f2 ff ff       	call   800f43 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d20:	a1 80 60 80 00       	mov    0x806080,%eax
  801d25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d2b:	a1 84 60 80 00       	mov    0x806084,%eax
  801d30:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <devfile_write>:
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	53                   	push   %ebx
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8b 40 0c             	mov    0xc(%eax),%eax
  801d53:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d58:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d5e:	53                   	push   %ebx
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	68 08 60 80 00       	push   $0x806008
  801d67:	e8 c7 f3 ff ff       	call   801133 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 04 00 00 00       	mov    $0x4,%eax
  801d76:	e8 d6 fe ff ff       	call   801c51 <fsipc>
  801d7b:	83 c4 10             	add    $0x10,%esp
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 0b                	js     801d8d <devfile_write+0x4a>
	assert(r <= n);
  801d82:	39 d8                	cmp    %ebx,%eax
  801d84:	77 0c                	ja     801d92 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d86:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d8b:	7f 1e                	jg     801dab <devfile_write+0x68>
}
  801d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    
	assert(r <= n);
  801d92:	68 00 32 80 00       	push   $0x803200
  801d97:	68 07 32 80 00       	push   $0x803207
  801d9c:	68 98 00 00 00       	push   $0x98
  801da1:	68 1c 32 80 00       	push   $0x80321c
  801da6:	e8 43 e9 ff ff       	call   8006ee <_panic>
	assert(r <= PGSIZE);
  801dab:	68 27 32 80 00       	push   $0x803227
  801db0:	68 07 32 80 00       	push   $0x803207
  801db5:	68 99 00 00 00       	push   $0x99
  801dba:	68 1c 32 80 00       	push   $0x80321c
  801dbf:	e8 2a e9 ff ff       	call   8006ee <_panic>

00801dc4 <devfile_read>:
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dd7:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  801de2:	b8 03 00 00 00       	mov    $0x3,%eax
  801de7:	e8 65 fe ff ff       	call   801c51 <fsipc>
  801dec:	89 c3                	mov    %eax,%ebx
  801dee:	85 c0                	test   %eax,%eax
  801df0:	78 1f                	js     801e11 <devfile_read+0x4d>
	assert(r <= n);
  801df2:	39 f0                	cmp    %esi,%eax
  801df4:	77 24                	ja     801e1a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801df6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dfb:	7f 33                	jg     801e30 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	50                   	push   %eax
  801e01:	68 00 60 80 00       	push   $0x806000
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	e8 c3 f2 ff ff       	call   8010d1 <memmove>
	return r;
  801e0e:	83 c4 10             	add    $0x10,%esp
}
  801e11:	89 d8                	mov    %ebx,%eax
  801e13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5e                   	pop    %esi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
	assert(r <= n);
  801e1a:	68 00 32 80 00       	push   $0x803200
  801e1f:	68 07 32 80 00       	push   $0x803207
  801e24:	6a 7c                	push   $0x7c
  801e26:	68 1c 32 80 00       	push   $0x80321c
  801e2b:	e8 be e8 ff ff       	call   8006ee <_panic>
	assert(r <= PGSIZE);
  801e30:	68 27 32 80 00       	push   $0x803227
  801e35:	68 07 32 80 00       	push   $0x803207
  801e3a:	6a 7d                	push   $0x7d
  801e3c:	68 1c 32 80 00       	push   $0x80321c
  801e41:	e8 a8 e8 ff ff       	call   8006ee <_panic>

00801e46 <open>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	83 ec 1c             	sub    $0x1c,%esp
  801e4e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e51:	56                   	push   %esi
  801e52:	e8 b3 f0 ff ff       	call   800f0a <strlen>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e5f:	7f 6c                	jg     801ecd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e67:	50                   	push   %eax
  801e68:	e8 79 f8 ff ff       	call   8016e6 <fd_alloc>
  801e6d:	89 c3                	mov    %eax,%ebx
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	85 c0                	test   %eax,%eax
  801e74:	78 3c                	js     801eb2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e76:	83 ec 08             	sub    $0x8,%esp
  801e79:	56                   	push   %esi
  801e7a:	68 00 60 80 00       	push   $0x806000
  801e7f:	e8 bf f0 ff ff       	call   800f43 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e94:	e8 b8 fd ff ff       	call   801c51 <fsipc>
  801e99:	89 c3                	mov    %eax,%ebx
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 19                	js     801ebb <open+0x75>
	return fd2num(fd);
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea8:	e8 12 f8 ff ff       	call   8016bf <fd2num>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	83 c4 10             	add    $0x10,%esp
}
  801eb2:	89 d8                	mov    %ebx,%eax
  801eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    
		fd_close(fd, 0);
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	6a 00                	push   $0x0
  801ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec3:	e8 1b f9 ff ff       	call   8017e3 <fd_close>
		return r;
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	eb e5                	jmp    801eb2 <open+0x6c>
		return -E_BAD_PATH;
  801ecd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ed2:	eb de                	jmp    801eb2 <open+0x6c>

00801ed4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eda:	ba 00 00 00 00       	mov    $0x0,%edx
  801edf:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee4:	e8 68 fd ff ff       	call   801c51 <fsipc>
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef1:	68 33 32 80 00       	push   $0x803233
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	e8 45 f0 ff ff       	call   800f43 <strcpy>
	return 0;
}
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <devsock_close>:
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	53                   	push   %ebx
  801f09:	83 ec 10             	sub    $0x10,%esp
  801f0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f0f:	53                   	push   %ebx
  801f10:	e8 fc 09 00 00       	call   802911 <pageref>
  801f15:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f18:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f1d:	83 f8 01             	cmp    $0x1,%eax
  801f20:	74 07                	je     801f29 <devsock_close+0x24>
}
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	ff 73 0c             	pushl  0xc(%ebx)
  801f2f:	e8 b9 02 00 00       	call   8021ed <nsipc_close>
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	eb e7                	jmp    801f22 <devsock_close+0x1d>

00801f3b <devsock_write>:
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f41:	6a 00                	push   $0x0
  801f43:	ff 75 10             	pushl  0x10(%ebp)
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	ff 70 0c             	pushl  0xc(%eax)
  801f4f:	e8 76 03 00 00       	call   8022ca <nsipc_send>
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <devsock_read>:
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	ff 75 10             	pushl  0x10(%ebp)
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	ff 70 0c             	pushl  0xc(%eax)
  801f6a:	e8 ef 02 00 00       	call   80225e <nsipc_recv>
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <fd2sockid>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	e8 b7 f7 ff ff       	call   801738 <fd_lookup>
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 10                	js     801f98 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f91:	39 08                	cmp    %ecx,(%eax)
  801f93:	75 05                	jne    801f9a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    
		return -E_NOT_SUPP;
  801f9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f9f:	eb f7                	jmp    801f98 <fd2sockid+0x27>

00801fa1 <alloc_sockfd>:
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	56                   	push   %esi
  801fa5:	53                   	push   %ebx
  801fa6:	83 ec 1c             	sub    $0x1c,%esp
  801fa9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fae:	50                   	push   %eax
  801faf:	e8 32 f7 ff ff       	call   8016e6 <fd_alloc>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	78 43                	js     802000 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	68 07 04 00 00       	push   $0x407
  801fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 66 f3 ff ff       	call   801335 <sys_page_alloc>
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 28                	js     802000 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fed:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	50                   	push   %eax
  801ff4:	e8 c6 f6 ff ff       	call   8016bf <fd2num>
  801ff9:	89 c3                	mov    %eax,%ebx
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	eb 0c                	jmp    80200c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	56                   	push   %esi
  802004:	e8 e4 01 00 00       	call   8021ed <nsipc_close>
		return r;
  802009:	83 c4 10             	add    $0x10,%esp
}
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802011:	5b                   	pop    %ebx
  802012:	5e                   	pop    %esi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    

00802015 <accept>:
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	e8 4e ff ff ff       	call   801f71 <fd2sockid>
  802023:	85 c0                	test   %eax,%eax
  802025:	78 1b                	js     802042 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	ff 75 10             	pushl  0x10(%ebp)
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	50                   	push   %eax
  802031:	e8 0e 01 00 00       	call   802144 <nsipc_accept>
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	78 05                	js     802042 <accept+0x2d>
	return alloc_sockfd(r);
  80203d:	e8 5f ff ff ff       	call   801fa1 <alloc_sockfd>
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <bind>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	e8 1f ff ff ff       	call   801f71 <fd2sockid>
  802052:	85 c0                	test   %eax,%eax
  802054:	78 12                	js     802068 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	ff 75 10             	pushl  0x10(%ebp)
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	e8 31 01 00 00       	call   802196 <nsipc_bind>
  802065:	83 c4 10             	add    $0x10,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <shutdown>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	e8 f9 fe ff ff       	call   801f71 <fd2sockid>
  802078:	85 c0                	test   %eax,%eax
  80207a:	78 0f                	js     80208b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80207c:	83 ec 08             	sub    $0x8,%esp
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	50                   	push   %eax
  802083:	e8 43 01 00 00       	call   8021cb <nsipc_shutdown>
  802088:	83 c4 10             	add    $0x10,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <connect>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	e8 d6 fe ff ff       	call   801f71 <fd2sockid>
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 12                	js     8020b1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	ff 75 10             	pushl  0x10(%ebp)
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	50                   	push   %eax
  8020a9:	e8 59 01 00 00       	call   802207 <nsipc_connect>
  8020ae:	83 c4 10             	add    $0x10,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <listen>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	e8 b0 fe ff ff       	call   801f71 <fd2sockid>
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 0f                	js     8020d4 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020c5:	83 ec 08             	sub    $0x8,%esp
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	50                   	push   %eax
  8020cc:	e8 6b 01 00 00       	call   80223c <nsipc_listen>
  8020d1:	83 c4 10             	add    $0x10,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020dc:	ff 75 10             	pushl  0x10(%ebp)
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 3e 02 00 00       	call   802328 <nsipc_socket>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 05                	js     8020f6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f1:	e8 ab fe ff ff       	call   801fa1 <alloc_sockfd>
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802101:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  802108:	74 26                	je     802130 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80210a:	6a 07                	push   $0x7
  80210c:	68 00 70 80 00       	push   $0x807000
  802111:	53                   	push   %ebx
  802112:	ff 35 b0 50 80 00    	pushl  0x8050b0
  802118:	e8 61 07 00 00       	call   80287e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80211d:	83 c4 0c             	add    $0xc,%esp
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	e8 ea 06 00 00       	call   802815 <ipc_recv>
}
  80212b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	6a 02                	push   $0x2
  802135:	e8 9c 07 00 00       	call   8028d6 <ipc_find_env>
  80213a:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	eb c6                	jmp    80210a <nsipc+0x12>

00802144 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802154:	8b 06                	mov    (%esi),%eax
  802156:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215b:	b8 01 00 00 00       	mov    $0x1,%eax
  802160:	e8 93 ff ff ff       	call   8020f8 <nsipc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	85 c0                	test   %eax,%eax
  802169:	79 09                	jns    802174 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80216b:	89 d8                	mov    %ebx,%eax
  80216d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	ff 35 10 70 80 00    	pushl  0x807010
  80217d:	68 00 70 80 00       	push   $0x807000
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	e8 47 ef ff ff       	call   8010d1 <memmove>
		*addrlen = ret->ret_addrlen;
  80218a:	a1 10 70 80 00       	mov    0x807010,%eax
  80218f:	89 06                	mov    %eax,(%esi)
  802191:	83 c4 10             	add    $0x10,%esp
	return r;
  802194:	eb d5                	jmp    80216b <nsipc_accept+0x27>

00802196 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	53                   	push   %ebx
  80219a:	83 ec 08             	sub    $0x8,%esp
  80219d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a8:	53                   	push   %ebx
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	68 04 70 80 00       	push   $0x807004
  8021b1:	e8 1b ef ff ff       	call   8010d1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021bc:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c1:	e8 32 ff ff ff       	call   8020f8 <nsipc>
}
  8021c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dc:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e6:	e8 0d ff ff ff       	call   8020f8 <nsipc>
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <nsipc_close>:

int
nsipc_close(int s)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fb:	b8 04 00 00 00       	mov    $0x4,%eax
  802200:	e8 f3 fe ff ff       	call   8020f8 <nsipc>
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	53                   	push   %ebx
  80220b:	83 ec 08             	sub    $0x8,%esp
  80220e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802219:	53                   	push   %ebx
  80221a:	ff 75 0c             	pushl  0xc(%ebp)
  80221d:	68 04 70 80 00       	push   $0x807004
  802222:	e8 aa ee ff ff       	call   8010d1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802227:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80222d:	b8 05 00 00 00       	mov    $0x5,%eax
  802232:	e8 c1 fe ff ff       	call   8020f8 <nsipc>
}
  802237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80224a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802252:	b8 06 00 00 00       	mov    $0x6,%eax
  802257:	e8 9c fe ff ff       	call   8020f8 <nsipc>
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	56                   	push   %esi
  802262:	53                   	push   %ebx
  802263:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80226e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227c:	b8 07 00 00 00       	mov    $0x7,%eax
  802281:	e8 72 fe ff ff       	call   8020f8 <nsipc>
  802286:	89 c3                	mov    %eax,%ebx
  802288:	85 c0                	test   %eax,%eax
  80228a:	78 1f                	js     8022ab <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80228c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802291:	7f 21                	jg     8022b4 <nsipc_recv+0x56>
  802293:	39 c6                	cmp    %eax,%esi
  802295:	7c 1d                	jl     8022b4 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	50                   	push   %eax
  80229b:	68 00 70 80 00       	push   $0x807000
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	e8 29 ee ff ff       	call   8010d1 <memmove>
  8022a8:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ab:	89 d8                	mov    %ebx,%eax
  8022ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022b4:	68 3f 32 80 00       	push   $0x80323f
  8022b9:	68 07 32 80 00       	push   $0x803207
  8022be:	6a 62                	push   $0x62
  8022c0:	68 54 32 80 00       	push   $0x803254
  8022c5:	e8 24 e4 ff ff       	call   8006ee <_panic>

008022ca <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022dc:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e2:	7f 2e                	jg     802312 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	53                   	push   %ebx
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	68 0c 70 80 00       	push   $0x80700c
  8022f0:	e8 dc ed ff ff       	call   8010d1 <memmove>
	nsipcbuf.send.req_size = size;
  8022f5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fe:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802303:	b8 08 00 00 00       	mov    $0x8,%eax
  802308:	e8 eb fd ff ff       	call   8020f8 <nsipc>
}
  80230d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802310:	c9                   	leave  
  802311:	c3                   	ret    
	assert(size < 1600);
  802312:	68 60 32 80 00       	push   $0x803260
  802317:	68 07 32 80 00       	push   $0x803207
  80231c:	6a 6d                	push   $0x6d
  80231e:	68 54 32 80 00       	push   $0x803254
  802323:	e8 c6 e3 ff ff       	call   8006ee <_panic>

00802328 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802336:	8b 45 0c             	mov    0xc(%ebp),%eax
  802339:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80233e:	8b 45 10             	mov    0x10(%ebp),%eax
  802341:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802346:	b8 09 00 00 00       	mov    $0x9,%eax
  80234b:	e8 a8 fd ff ff       	call   8020f8 <nsipc>
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	56                   	push   %esi
  802356:	53                   	push   %ebx
  802357:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 6a f3 ff ff       	call   8016cf <fd2data>
  802365:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802367:	83 c4 08             	add    $0x8,%esp
  80236a:	68 6c 32 80 00       	push   $0x80326c
  80236f:	53                   	push   %ebx
  802370:	e8 ce eb ff ff       	call   800f43 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802375:	8b 46 04             	mov    0x4(%esi),%eax
  802378:	2b 06                	sub    (%esi),%eax
  80237a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802380:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802387:	00 00 00 
	stat->st_dev = &devpipe;
  80238a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802391:	40 80 00 
	return 0;
}
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    

008023a0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023aa:	53                   	push   %ebx
  8023ab:	6a 00                	push   $0x0
  8023ad:	e8 08 f0 ff ff       	call   8013ba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b2:	89 1c 24             	mov    %ebx,(%esp)
  8023b5:	e8 15 f3 ff ff       	call   8016cf <fd2data>
  8023ba:	83 c4 08             	add    $0x8,%esp
  8023bd:	50                   	push   %eax
  8023be:	6a 00                	push   $0x0
  8023c0:	e8 f5 ef ff ff       	call   8013ba <sys_page_unmap>
}
  8023c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <_pipeisclosed>:
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	57                   	push   %edi
  8023ce:	56                   	push   %esi
  8023cf:	53                   	push   %ebx
  8023d0:	83 ec 1c             	sub    $0x1c,%esp
  8023d3:	89 c7                	mov    %eax,%edi
  8023d5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023d7:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8023dc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023df:	83 ec 0c             	sub    $0xc,%esp
  8023e2:	57                   	push   %edi
  8023e3:	e8 29 05 00 00       	call   802911 <pageref>
  8023e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023eb:	89 34 24             	mov    %esi,(%esp)
  8023ee:	e8 1e 05 00 00       	call   802911 <pageref>
		nn = thisenv->env_runs;
  8023f3:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  8023f9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	39 cb                	cmp    %ecx,%ebx
  802401:	74 1b                	je     80241e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802403:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802406:	75 cf                	jne    8023d7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802408:	8b 42 58             	mov    0x58(%edx),%eax
  80240b:	6a 01                	push   $0x1
  80240d:	50                   	push   %eax
  80240e:	53                   	push   %ebx
  80240f:	68 73 32 80 00       	push   $0x803273
  802414:	e8 cb e3 ff ff       	call   8007e4 <cprintf>
  802419:	83 c4 10             	add    $0x10,%esp
  80241c:	eb b9                	jmp    8023d7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80241e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802421:	0f 94 c0             	sete   %al
  802424:	0f b6 c0             	movzbl %al,%eax
}
  802427:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5f                   	pop    %edi
  80242d:	5d                   	pop    %ebp
  80242e:	c3                   	ret    

0080242f <devpipe_write>:
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	57                   	push   %edi
  802433:	56                   	push   %esi
  802434:	53                   	push   %ebx
  802435:	83 ec 28             	sub    $0x28,%esp
  802438:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80243b:	56                   	push   %esi
  80243c:	e8 8e f2 ff ff       	call   8016cf <fd2data>
  802441:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802443:	83 c4 10             	add    $0x10,%esp
  802446:	bf 00 00 00 00       	mov    $0x0,%edi
  80244b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80244e:	74 4f                	je     80249f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802450:	8b 43 04             	mov    0x4(%ebx),%eax
  802453:	8b 0b                	mov    (%ebx),%ecx
  802455:	8d 51 20             	lea    0x20(%ecx),%edx
  802458:	39 d0                	cmp    %edx,%eax
  80245a:	72 14                	jb     802470 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80245c:	89 da                	mov    %ebx,%edx
  80245e:	89 f0                	mov    %esi,%eax
  802460:	e8 65 ff ff ff       	call   8023ca <_pipeisclosed>
  802465:	85 c0                	test   %eax,%eax
  802467:	75 3b                	jne    8024a4 <devpipe_write+0x75>
			sys_yield();
  802469:	e8 a8 ee ff ff       	call   801316 <sys_yield>
  80246e:	eb e0                	jmp    802450 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802473:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802477:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80247a:	89 c2                	mov    %eax,%edx
  80247c:	c1 fa 1f             	sar    $0x1f,%edx
  80247f:	89 d1                	mov    %edx,%ecx
  802481:	c1 e9 1b             	shr    $0x1b,%ecx
  802484:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802487:	83 e2 1f             	and    $0x1f,%edx
  80248a:	29 ca                	sub    %ecx,%edx
  80248c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802490:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802494:	83 c0 01             	add    $0x1,%eax
  802497:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80249a:	83 c7 01             	add    $0x1,%edi
  80249d:	eb ac                	jmp    80244b <devpipe_write+0x1c>
	return i;
  80249f:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a2:	eb 05                	jmp    8024a9 <devpipe_write+0x7a>
				return 0;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    

008024b1 <devpipe_read>:
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	57                   	push   %edi
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 18             	sub    $0x18,%esp
  8024ba:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024bd:	57                   	push   %edi
  8024be:	e8 0c f2 ff ff       	call   8016cf <fd2data>
  8024c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	be 00 00 00 00       	mov    $0x0,%esi
  8024cd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d0:	75 14                	jne    8024e6 <devpipe_read+0x35>
	return i;
  8024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d5:	eb 02                	jmp    8024d9 <devpipe_read+0x28>
				return i;
  8024d7:	89 f0                	mov    %esi,%eax
}
  8024d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
			sys_yield();
  8024e1:	e8 30 ee ff ff       	call   801316 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024e6:	8b 03                	mov    (%ebx),%eax
  8024e8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024eb:	75 18                	jne    802505 <devpipe_read+0x54>
			if (i > 0)
  8024ed:	85 f6                	test   %esi,%esi
  8024ef:	75 e6                	jne    8024d7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024f1:	89 da                	mov    %ebx,%edx
  8024f3:	89 f8                	mov    %edi,%eax
  8024f5:	e8 d0 fe ff ff       	call   8023ca <_pipeisclosed>
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	74 e3                	je     8024e1 <devpipe_read+0x30>
				return 0;
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802503:	eb d4                	jmp    8024d9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802505:	99                   	cltd   
  802506:	c1 ea 1b             	shr    $0x1b,%edx
  802509:	01 d0                	add    %edx,%eax
  80250b:	83 e0 1f             	and    $0x1f,%eax
  80250e:	29 d0                	sub    %edx,%eax
  802510:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802515:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802518:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80251b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80251e:	83 c6 01             	add    $0x1,%esi
  802521:	eb aa                	jmp    8024cd <devpipe_read+0x1c>

00802523 <pipe>:
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80252b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252e:	50                   	push   %eax
  80252f:	e8 b2 f1 ff ff       	call   8016e6 <fd_alloc>
  802534:	89 c3                	mov    %eax,%ebx
  802536:	83 c4 10             	add    $0x10,%esp
  802539:	85 c0                	test   %eax,%eax
  80253b:	0f 88 23 01 00 00    	js     802664 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	68 07 04 00 00       	push   $0x407
  802549:	ff 75 f4             	pushl  -0xc(%ebp)
  80254c:	6a 00                	push   $0x0
  80254e:	e8 e2 ed ff ff       	call   801335 <sys_page_alloc>
  802553:	89 c3                	mov    %eax,%ebx
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	85 c0                	test   %eax,%eax
  80255a:	0f 88 04 01 00 00    	js     802664 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802566:	50                   	push   %eax
  802567:	e8 7a f1 ff ff       	call   8016e6 <fd_alloc>
  80256c:	89 c3                	mov    %eax,%ebx
  80256e:	83 c4 10             	add    $0x10,%esp
  802571:	85 c0                	test   %eax,%eax
  802573:	0f 88 db 00 00 00    	js     802654 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 07 04 00 00       	push   $0x407
  802581:	ff 75 f0             	pushl  -0x10(%ebp)
  802584:	6a 00                	push   $0x0
  802586:	e8 aa ed ff ff       	call   801335 <sys_page_alloc>
  80258b:	89 c3                	mov    %eax,%ebx
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	85 c0                	test   %eax,%eax
  802592:	0f 88 bc 00 00 00    	js     802654 <pipe+0x131>
	va = fd2data(fd0);
  802598:	83 ec 0c             	sub    $0xc,%esp
  80259b:	ff 75 f4             	pushl  -0xc(%ebp)
  80259e:	e8 2c f1 ff ff       	call   8016cf <fd2data>
  8025a3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a5:	83 c4 0c             	add    $0xc,%esp
  8025a8:	68 07 04 00 00       	push   $0x407
  8025ad:	50                   	push   %eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	e8 80 ed ff ff       	call   801335 <sys_page_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 88 82 00 00 00    	js     802644 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c8:	e8 02 f1 ff ff       	call   8016cf <fd2data>
  8025cd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025d4:	50                   	push   %eax
  8025d5:	6a 00                	push   $0x0
  8025d7:	56                   	push   %esi
  8025d8:	6a 00                	push   $0x0
  8025da:	e8 99 ed ff ff       	call   801378 <sys_page_map>
  8025df:	89 c3                	mov    %eax,%ebx
  8025e1:	83 c4 20             	add    $0x20,%esp
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	78 4e                	js     802636 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025e8:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ff:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	ff 75 f4             	pushl  -0xc(%ebp)
  802611:	e8 a9 f0 ff ff       	call   8016bf <fd2num>
  802616:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802619:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80261b:	83 c4 04             	add    $0x4,%esp
  80261e:	ff 75 f0             	pushl  -0x10(%ebp)
  802621:	e8 99 f0 ff ff       	call   8016bf <fd2num>
  802626:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802629:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80262c:	83 c4 10             	add    $0x10,%esp
  80262f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802634:	eb 2e                	jmp    802664 <pipe+0x141>
	sys_page_unmap(0, va);
  802636:	83 ec 08             	sub    $0x8,%esp
  802639:	56                   	push   %esi
  80263a:	6a 00                	push   $0x0
  80263c:	e8 79 ed ff ff       	call   8013ba <sys_page_unmap>
  802641:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802644:	83 ec 08             	sub    $0x8,%esp
  802647:	ff 75 f0             	pushl  -0x10(%ebp)
  80264a:	6a 00                	push   $0x0
  80264c:	e8 69 ed ff ff       	call   8013ba <sys_page_unmap>
  802651:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802654:	83 ec 08             	sub    $0x8,%esp
  802657:	ff 75 f4             	pushl  -0xc(%ebp)
  80265a:	6a 00                	push   $0x0
  80265c:	e8 59 ed ff ff       	call   8013ba <sys_page_unmap>
  802661:	83 c4 10             	add    $0x10,%esp
}
  802664:	89 d8                	mov    %ebx,%eax
  802666:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802669:	5b                   	pop    %ebx
  80266a:	5e                   	pop    %esi
  80266b:	5d                   	pop    %ebp
  80266c:	c3                   	ret    

0080266d <pipeisclosed>:
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802676:	50                   	push   %eax
  802677:	ff 75 08             	pushl  0x8(%ebp)
  80267a:	e8 b9 f0 ff ff       	call   801738 <fd_lookup>
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	85 c0                	test   %eax,%eax
  802684:	78 18                	js     80269e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802686:	83 ec 0c             	sub    $0xc,%esp
  802689:	ff 75 f4             	pushl  -0xc(%ebp)
  80268c:	e8 3e f0 ff ff       	call   8016cf <fd2data>
	return _pipeisclosed(fd, p);
  802691:	89 c2                	mov    %eax,%edx
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	e8 2f fd ff ff       	call   8023ca <_pipeisclosed>
  80269b:	83 c4 10             	add    $0x10,%esp
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a5:	c3                   	ret    

008026a6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ac:	68 8b 32 80 00       	push   $0x80328b
  8026b1:	ff 75 0c             	pushl  0xc(%ebp)
  8026b4:	e8 8a e8 ff ff       	call   800f43 <strcpy>
	return 0;
}
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <devcons_write>:
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	57                   	push   %edi
  8026c4:	56                   	push   %esi
  8026c5:	53                   	push   %ebx
  8026c6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026cc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026d1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026da:	73 31                	jae    80270d <devcons_write+0x4d>
		m = n - tot;
  8026dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026df:	29 f3                	sub    %esi,%ebx
  8026e1:	83 fb 7f             	cmp    $0x7f,%ebx
  8026e4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026e9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	53                   	push   %ebx
  8026f0:	89 f0                	mov    %esi,%eax
  8026f2:	03 45 0c             	add    0xc(%ebp),%eax
  8026f5:	50                   	push   %eax
  8026f6:	57                   	push   %edi
  8026f7:	e8 d5 e9 ff ff       	call   8010d1 <memmove>
		sys_cputs(buf, m);
  8026fc:	83 c4 08             	add    $0x8,%esp
  8026ff:	53                   	push   %ebx
  802700:	57                   	push   %edi
  802701:	e8 73 eb ff ff       	call   801279 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802706:	01 de                	add    %ebx,%esi
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	eb ca                	jmp    8026d7 <devcons_write+0x17>
}
  80270d:	89 f0                	mov    %esi,%eax
  80270f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802712:	5b                   	pop    %ebx
  802713:	5e                   	pop    %esi
  802714:	5f                   	pop    %edi
  802715:	5d                   	pop    %ebp
  802716:	c3                   	ret    

00802717 <devcons_read>:
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	83 ec 08             	sub    $0x8,%esp
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802722:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802726:	74 21                	je     802749 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802728:	e8 6a eb ff ff       	call   801297 <sys_cgetc>
  80272d:	85 c0                	test   %eax,%eax
  80272f:	75 07                	jne    802738 <devcons_read+0x21>
		sys_yield();
  802731:	e8 e0 eb ff ff       	call   801316 <sys_yield>
  802736:	eb f0                	jmp    802728 <devcons_read+0x11>
	if (c < 0)
  802738:	78 0f                	js     802749 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80273a:	83 f8 04             	cmp    $0x4,%eax
  80273d:	74 0c                	je     80274b <devcons_read+0x34>
	*(char*)vbuf = c;
  80273f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802742:	88 02                	mov    %al,(%edx)
	return 1;
  802744:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    
		return 0;
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
  802750:	eb f7                	jmp    802749 <devcons_read+0x32>

00802752 <cputchar>:
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80275e:	6a 01                	push   $0x1
  802760:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802763:	50                   	push   %eax
  802764:	e8 10 eb ff ff       	call   801279 <sys_cputs>
}
  802769:	83 c4 10             	add    $0x10,%esp
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <getchar>:
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802774:	6a 01                	push   $0x1
  802776:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802779:	50                   	push   %eax
  80277a:	6a 00                	push   $0x0
  80277c:	e8 27 f2 ff ff       	call   8019a8 <read>
	if (r < 0)
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	85 c0                	test   %eax,%eax
  802786:	78 06                	js     80278e <getchar+0x20>
	if (r < 1)
  802788:	74 06                	je     802790 <getchar+0x22>
	return c;
  80278a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    
		return -E_EOF;
  802790:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802795:	eb f7                	jmp    80278e <getchar+0x20>

00802797 <iscons>:
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a0:	50                   	push   %eax
  8027a1:	ff 75 08             	pushl  0x8(%ebp)
  8027a4:	e8 8f ef ff ff       	call   801738 <fd_lookup>
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	78 11                	js     8027c1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027b9:	39 10                	cmp    %edx,(%eax)
  8027bb:	0f 94 c0             	sete   %al
  8027be:	0f b6 c0             	movzbl %al,%eax
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <opencons>:
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027cc:	50                   	push   %eax
  8027cd:	e8 14 ef ff ff       	call   8016e6 <fd_alloc>
  8027d2:	83 c4 10             	add    $0x10,%esp
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	78 3a                	js     802813 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	68 07 04 00 00       	push   $0x407
  8027e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e4:	6a 00                	push   $0x0
  8027e6:	e8 4a eb ff ff       	call   801335 <sys_page_alloc>
  8027eb:	83 c4 10             	add    $0x10,%esp
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 21                	js     802813 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027fb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	50                   	push   %eax
  80280b:	e8 af ee ff ff       	call   8016bf <fd2num>
  802810:	83 c4 10             	add    $0x10,%esp
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	56                   	push   %esi
  802819:	53                   	push   %ebx
  80281a:	8b 75 08             	mov    0x8(%ebp),%esi
  80281d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802820:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802823:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802825:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80282a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80282d:	83 ec 0c             	sub    $0xc,%esp
  802830:	50                   	push   %eax
  802831:	e8 af ec ff ff       	call   8014e5 <sys_ipc_recv>
	if(ret < 0){
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	85 c0                	test   %eax,%eax
  80283b:	78 2b                	js     802868 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80283d:	85 f6                	test   %esi,%esi
  80283f:	74 0a                	je     80284b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802841:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802846:	8b 40 74             	mov    0x74(%eax),%eax
  802849:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80284b:	85 db                	test   %ebx,%ebx
  80284d:	74 0a                	je     802859 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80284f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802854:	8b 40 78             	mov    0x78(%eax),%eax
  802857:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802859:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80285e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802864:	5b                   	pop    %ebx
  802865:	5e                   	pop    %esi
  802866:	5d                   	pop    %ebp
  802867:	c3                   	ret    
		if(from_env_store)
  802868:	85 f6                	test   %esi,%esi
  80286a:	74 06                	je     802872 <ipc_recv+0x5d>
			*from_env_store = 0;
  80286c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802872:	85 db                	test   %ebx,%ebx
  802874:	74 eb                	je     802861 <ipc_recv+0x4c>
			*perm_store = 0;
  802876:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80287c:	eb e3                	jmp    802861 <ipc_recv+0x4c>

0080287e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
  802881:	57                   	push   %edi
  802882:	56                   	push   %esi
  802883:	53                   	push   %ebx
  802884:	83 ec 0c             	sub    $0xc,%esp
  802887:	8b 7d 08             	mov    0x8(%ebp),%edi
  80288a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80288d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802890:	85 db                	test   %ebx,%ebx
  802892:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802897:	0f 44 d8             	cmove  %eax,%ebx
  80289a:	eb 05                	jmp    8028a1 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80289c:	e8 75 ea ff ff       	call   801316 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028a1:	ff 75 14             	pushl  0x14(%ebp)
  8028a4:	53                   	push   %ebx
  8028a5:	56                   	push   %esi
  8028a6:	57                   	push   %edi
  8028a7:	e8 16 ec ff ff       	call   8014c2 <sys_ipc_try_send>
  8028ac:	83 c4 10             	add    $0x10,%esp
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 1b                	je     8028ce <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028b3:	79 e7                	jns    80289c <ipc_send+0x1e>
  8028b5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028b8:	74 e2                	je     80289c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 97 32 80 00       	push   $0x803297
  8028c2:	6a 46                	push   $0x46
  8028c4:	68 ac 32 80 00       	push   $0x8032ac
  8028c9:	e8 20 de ff ff       	call   8006ee <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5f                   	pop    %edi
  8028d4:	5d                   	pop    %ebp
  8028d5:	c3                   	ret    

008028d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028e1:	89 c2                	mov    %eax,%edx
  8028e3:	c1 e2 07             	shl    $0x7,%edx
  8028e6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028ec:	8b 52 50             	mov    0x50(%edx),%edx
  8028ef:	39 ca                	cmp    %ecx,%edx
  8028f1:	74 11                	je     802904 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028f3:	83 c0 01             	add    $0x1,%eax
  8028f6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028fb:	75 e4                	jne    8028e1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802902:	eb 0b                	jmp    80290f <ipc_find_env+0x39>
			return envs[i].env_id;
  802904:	c1 e0 07             	shl    $0x7,%eax
  802907:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80290c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    

00802911 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802917:	89 d0                	mov    %edx,%eax
  802919:	c1 e8 16             	shr    $0x16,%eax
  80291c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802928:	f6 c1 01             	test   $0x1,%cl
  80292b:	74 1d                	je     80294a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80292d:	c1 ea 0c             	shr    $0xc,%edx
  802930:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802937:	f6 c2 01             	test   $0x1,%dl
  80293a:	74 0e                	je     80294a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80293c:	c1 ea 0c             	shr    $0xc,%edx
  80293f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802946:	ef 
  802947:	0f b7 c0             	movzwl %ax,%eax
}
  80294a:	5d                   	pop    %ebp
  80294b:	c3                   	ret    
  80294c:	66 90                	xchg   %ax,%ax
  80294e:	66 90                	xchg   %ax,%ax

00802950 <__udivdi3>:
  802950:	55                   	push   %ebp
  802951:	57                   	push   %edi
  802952:	56                   	push   %esi
  802953:	53                   	push   %ebx
  802954:	83 ec 1c             	sub    $0x1c,%esp
  802957:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80295b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80295f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802963:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802967:	85 d2                	test   %edx,%edx
  802969:	75 4d                	jne    8029b8 <__udivdi3+0x68>
  80296b:	39 f3                	cmp    %esi,%ebx
  80296d:	76 19                	jbe    802988 <__udivdi3+0x38>
  80296f:	31 ff                	xor    %edi,%edi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f2                	mov    %esi,%edx
  802975:	f7 f3                	div    %ebx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	89 d9                	mov    %ebx,%ecx
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	75 0b                	jne    802999 <__udivdi3+0x49>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	31 d2                	xor    %edx,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 c1                	mov    %eax,%ecx
  802999:	31 d2                	xor    %edx,%edx
  80299b:	89 f0                	mov    %esi,%eax
  80299d:	f7 f1                	div    %ecx
  80299f:	89 c6                	mov    %eax,%esi
  8029a1:	89 e8                	mov    %ebp,%eax
  8029a3:	89 f7                	mov    %esi,%edi
  8029a5:	f7 f1                	div    %ecx
  8029a7:	89 fa                	mov    %edi,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	77 1c                	ja     8029d8 <__udivdi3+0x88>
  8029bc:	0f bd fa             	bsr    %edx,%edi
  8029bf:	83 f7 1f             	xor    $0x1f,%edi
  8029c2:	75 2c                	jne    8029f0 <__udivdi3+0xa0>
  8029c4:	39 f2                	cmp    %esi,%edx
  8029c6:	72 06                	jb     8029ce <__udivdi3+0x7e>
  8029c8:	31 c0                	xor    %eax,%eax
  8029ca:	39 eb                	cmp    %ebp,%ebx
  8029cc:	77 a9                	ja     802977 <__udivdi3+0x27>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	eb a2                	jmp    802977 <__udivdi3+0x27>
  8029d5:	8d 76 00             	lea    0x0(%esi),%esi
  8029d8:	31 ff                	xor    %edi,%edi
  8029da:	31 c0                	xor    %eax,%eax
  8029dc:	89 fa                	mov    %edi,%edx
  8029de:	83 c4 1c             	add    $0x1c,%esp
  8029e1:	5b                   	pop    %ebx
  8029e2:	5e                   	pop    %esi
  8029e3:	5f                   	pop    %edi
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
  8029e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	89 f9                	mov    %edi,%ecx
  8029f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029f7:	29 f8                	sub    %edi,%eax
  8029f9:	d3 e2                	shl    %cl,%edx
  8029fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ff:	89 c1                	mov    %eax,%ecx
  802a01:	89 da                	mov    %ebx,%edx
  802a03:	d3 ea                	shr    %cl,%edx
  802a05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a09:	09 d1                	or     %edx,%ecx
  802a0b:	89 f2                	mov    %esi,%edx
  802a0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a11:	89 f9                	mov    %edi,%ecx
  802a13:	d3 e3                	shl    %cl,%ebx
  802a15:	89 c1                	mov    %eax,%ecx
  802a17:	d3 ea                	shr    %cl,%edx
  802a19:	89 f9                	mov    %edi,%ecx
  802a1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a1f:	89 eb                	mov    %ebp,%ebx
  802a21:	d3 e6                	shl    %cl,%esi
  802a23:	89 c1                	mov    %eax,%ecx
  802a25:	d3 eb                	shr    %cl,%ebx
  802a27:	09 de                	or     %ebx,%esi
  802a29:	89 f0                	mov    %esi,%eax
  802a2b:	f7 74 24 08          	divl   0x8(%esp)
  802a2f:	89 d6                	mov    %edx,%esi
  802a31:	89 c3                	mov    %eax,%ebx
  802a33:	f7 64 24 0c          	mull   0xc(%esp)
  802a37:	39 d6                	cmp    %edx,%esi
  802a39:	72 15                	jb     802a50 <__udivdi3+0x100>
  802a3b:	89 f9                	mov    %edi,%ecx
  802a3d:	d3 e5                	shl    %cl,%ebp
  802a3f:	39 c5                	cmp    %eax,%ebp
  802a41:	73 04                	jae    802a47 <__udivdi3+0xf7>
  802a43:	39 d6                	cmp    %edx,%esi
  802a45:	74 09                	je     802a50 <__udivdi3+0x100>
  802a47:	89 d8                	mov    %ebx,%eax
  802a49:	31 ff                	xor    %edi,%edi
  802a4b:	e9 27 ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a53:	31 ff                	xor    %edi,%edi
  802a55:	e9 1d ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	66 90                	xchg   %ax,%ax
  802a5e:	66 90                	xchg   %ax,%ax

00802a60 <__umoddi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	53                   	push   %ebx
  802a64:	83 ec 1c             	sub    $0x1c,%esp
  802a67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a77:	89 da                	mov    %ebx,%edx
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	75 43                	jne    802ac0 <__umoddi3+0x60>
  802a7d:	39 df                	cmp    %ebx,%edi
  802a7f:	76 17                	jbe    802a98 <__umoddi3+0x38>
  802a81:	89 f0                	mov    %esi,%eax
  802a83:	f7 f7                	div    %edi
  802a85:	89 d0                	mov    %edx,%eax
  802a87:	31 d2                	xor    %edx,%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	89 fd                	mov    %edi,%ebp
  802a9a:	85 ff                	test   %edi,%edi
  802a9c:	75 0b                	jne    802aa9 <__umoddi3+0x49>
  802a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f7                	div    %edi
  802aa7:	89 c5                	mov    %eax,%ebp
  802aa9:	89 d8                	mov    %ebx,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	f7 f5                	div    %ebp
  802aaf:	89 f0                	mov    %esi,%eax
  802ab1:	f7 f5                	div    %ebp
  802ab3:	89 d0                	mov    %edx,%eax
  802ab5:	eb d0                	jmp    802a87 <__umoddi3+0x27>
  802ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802abe:	66 90                	xchg   %ax,%ax
  802ac0:	89 f1                	mov    %esi,%ecx
  802ac2:	39 d8                	cmp    %ebx,%eax
  802ac4:	76 0a                	jbe    802ad0 <__umoddi3+0x70>
  802ac6:	89 f0                	mov    %esi,%eax
  802ac8:	83 c4 1c             	add    $0x1c,%esp
  802acb:	5b                   	pop    %ebx
  802acc:	5e                   	pop    %esi
  802acd:	5f                   	pop    %edi
  802ace:	5d                   	pop    %ebp
  802acf:	c3                   	ret    
  802ad0:	0f bd e8             	bsr    %eax,%ebp
  802ad3:	83 f5 1f             	xor    $0x1f,%ebp
  802ad6:	75 20                	jne    802af8 <__umoddi3+0x98>
  802ad8:	39 d8                	cmp    %ebx,%eax
  802ada:	0f 82 b0 00 00 00    	jb     802b90 <__umoddi3+0x130>
  802ae0:	39 f7                	cmp    %esi,%edi
  802ae2:	0f 86 a8 00 00 00    	jbe    802b90 <__umoddi3+0x130>
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	83 c4 1c             	add    $0x1c,%esp
  802aed:	5b                   	pop    %ebx
  802aee:	5e                   	pop    %esi
  802aef:	5f                   	pop    %edi
  802af0:	5d                   	pop    %ebp
  802af1:	c3                   	ret    
  802af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aff:	29 ea                	sub    %ebp,%edx
  802b01:	d3 e0                	shl    %cl,%eax
  802b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b07:	89 d1                	mov    %edx,%ecx
  802b09:	89 f8                	mov    %edi,%eax
  802b0b:	d3 e8                	shr    %cl,%eax
  802b0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b19:	09 c1                	or     %eax,%ecx
  802b1b:	89 d8                	mov    %ebx,%eax
  802b1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b21:	89 e9                	mov    %ebp,%ecx
  802b23:	d3 e7                	shl    %cl,%edi
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	d3 e8                	shr    %cl,%eax
  802b29:	89 e9                	mov    %ebp,%ecx
  802b2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b2f:	d3 e3                	shl    %cl,%ebx
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	89 d1                	mov    %edx,%ecx
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	d3 e8                	shr    %cl,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	89 fa                	mov    %edi,%edx
  802b3d:	d3 e6                	shl    %cl,%esi
  802b3f:	09 d8                	or     %ebx,%eax
  802b41:	f7 74 24 08          	divl   0x8(%esp)
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	89 f3                	mov    %esi,%ebx
  802b49:	f7 64 24 0c          	mull   0xc(%esp)
  802b4d:	89 c6                	mov    %eax,%esi
  802b4f:	89 d7                	mov    %edx,%edi
  802b51:	39 d1                	cmp    %edx,%ecx
  802b53:	72 06                	jb     802b5b <__umoddi3+0xfb>
  802b55:	75 10                	jne    802b67 <__umoddi3+0x107>
  802b57:	39 c3                	cmp    %eax,%ebx
  802b59:	73 0c                	jae    802b67 <__umoddi3+0x107>
  802b5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b63:	89 d7                	mov    %edx,%edi
  802b65:	89 c6                	mov    %eax,%esi
  802b67:	89 ca                	mov    %ecx,%edx
  802b69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b6e:	29 f3                	sub    %esi,%ebx
  802b70:	19 fa                	sbb    %edi,%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	d3 e0                	shl    %cl,%eax
  802b76:	89 e9                	mov    %ebp,%ecx
  802b78:	d3 eb                	shr    %cl,%ebx
  802b7a:	d3 ea                	shr    %cl,%edx
  802b7c:	09 d8                	or     %ebx,%eax
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 da                	mov    %ebx,%edx
  802b92:	29 fe                	sub    %edi,%esi
  802b94:	19 c2                	sbb    %eax,%edx
  802b96:	89 f1                	mov    %esi,%ecx
  802b98:	89 c8                	mov    %ecx,%eax
  802b9a:	e9 4b ff ff ff       	jmp    802aea <__umoddi3+0x8a>
