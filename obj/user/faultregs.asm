
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
  800044:	68 f0 2c 80 00       	push   $0x802cf0
  800049:	68 c0 2b 80 00       	push   $0x802bc0
  80004e:	e8 93 07 00 00       	call   8007e6 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 d0 2b 80 00       	push   $0x802bd0
  80005c:	68 d4 2b 80 00       	push   $0x802bd4
  800061:	e8 80 07 00 00       	call   8007e6 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 e8 2b 80 00       	push   $0x802be8
  80007b:	e8 66 07 00 00       	call   8007e6 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 f2 2b 80 00       	push   $0x802bf2
  800093:	68 d4 2b 80 00       	push   $0x802bd4
  800098:	e8 49 07 00 00       	call   8007e6 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 e8 2b 80 00       	push   $0x802be8
  8000b4:	e8 2d 07 00 00       	call   8007e6 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 f6 2b 80 00       	push   $0x802bf6
  8000cc:	68 d4 2b 80 00       	push   $0x802bd4
  8000d1:	e8 10 07 00 00       	call   8007e6 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 e8 2b 80 00       	push   $0x802be8
  8000ed:	e8 f4 06 00 00       	call   8007e6 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 fa 2b 80 00       	push   $0x802bfa
  800105:	68 d4 2b 80 00       	push   $0x802bd4
  80010a:	e8 d7 06 00 00       	call   8007e6 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 e8 2b 80 00       	push   $0x802be8
  800126:	e8 bb 06 00 00       	call   8007e6 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 fe 2b 80 00       	push   $0x802bfe
  80013e:	68 d4 2b 80 00       	push   $0x802bd4
  800143:	e8 9e 06 00 00       	call   8007e6 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 e8 2b 80 00       	push   $0x802be8
  80015f:	e8 82 06 00 00       	call   8007e6 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 02 2c 80 00       	push   $0x802c02
  800177:	68 d4 2b 80 00       	push   $0x802bd4
  80017c:	e8 65 06 00 00       	call   8007e6 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 e8 2b 80 00       	push   $0x802be8
  800198:	e8 49 06 00 00       	call   8007e6 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 06 2c 80 00       	push   $0x802c06
  8001b0:	68 d4 2b 80 00       	push   $0x802bd4
  8001b5:	e8 2c 06 00 00       	call   8007e6 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 e8 2b 80 00       	push   $0x802be8
  8001d1:	e8 10 06 00 00       	call   8007e6 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 0a 2c 80 00       	push   $0x802c0a
  8001e9:	68 d4 2b 80 00       	push   $0x802bd4
  8001ee:	e8 f3 05 00 00       	call   8007e6 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 e8 2b 80 00       	push   $0x802be8
  80020a:	e8 d7 05 00 00       	call   8007e6 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 0e 2c 80 00       	push   $0x802c0e
  800222:	68 d4 2b 80 00       	push   $0x802bd4
  800227:	e8 ba 05 00 00       	call   8007e6 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 e8 2b 80 00       	push   $0x802be8
  800243:	e8 9e 05 00 00       	call   8007e6 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 15 2c 80 00       	push   $0x802c15
  800253:	68 d4 2b 80 00       	push   $0x802bd4
  800258:	e8 89 05 00 00       	call   8007e6 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 e8 2b 80 00       	push   $0x802be8
  800274:	e8 6d 05 00 00       	call   8007e6 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 19 2c 80 00       	push   $0x802c19
  800284:	e8 5d 05 00 00       	call   8007e6 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 e8 2b 80 00       	push   $0x802be8
  800294:	e8 4d 05 00 00       	call   8007e6 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 e4 2b 80 00       	push   $0x802be4
  8002a9:	e8 38 05 00 00       	call   8007e6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 e4 2b 80 00       	push   $0x802be4
  8002c3:	e8 1e 05 00 00       	call   8007e6 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 e4 2b 80 00       	push   $0x802be4
  8002d8:	e8 09 05 00 00       	call   8007e6 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 e4 2b 80 00       	push   $0x802be4
  8002ed:	e8 f4 04 00 00       	call   8007e6 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 e4 2b 80 00       	push   $0x802be4
  800302:	e8 df 04 00 00       	call   8007e6 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 e4 2b 80 00       	push   $0x802be4
  800317:	e8 ca 04 00 00       	call   8007e6 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 e4 2b 80 00       	push   $0x802be4
  80032c:	e8 b5 04 00 00       	call   8007e6 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 e4 2b 80 00       	push   $0x802be4
  800341:	e8 a0 04 00 00       	call   8007e6 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 e4 2b 80 00       	push   $0x802be4
  800356:	e8 8b 04 00 00       	call   8007e6 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 15 2c 80 00       	push   $0x802c15
  800366:	68 d4 2b 80 00       	push   $0x802bd4
  80036b:	e8 76 04 00 00       	call   8007e6 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 e4 2b 80 00       	push   $0x802be4
  800387:	e8 5a 04 00 00       	call   8007e6 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 19 2c 80 00       	push   $0x802c19
  800397:	e8 4a 04 00 00       	call   8007e6 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 e4 2b 80 00       	push   $0x802be4
  8003af:	e8 32 04 00 00       	call   8007e6 <cprintf>
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
  8003c2:	68 e4 2b 80 00       	push   $0x802be4
  8003c7:	e8 1a 04 00 00       	call   8007e6 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 19 2c 80 00       	push   $0x802c19
  8003d7:	e8 0a 04 00 00       	call   8007e6 <cprintf>
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
  800466:	68 3f 2c 80 00       	push   $0x802c3f
  80046b:	68 4d 2c 80 00       	push   $0x802c4d
  800470:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800475:	ba 38 2c 80 00       	mov    $0x802c38,%edx
  80047a:	b8 80 50 80 00       	mov    $0x805080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 a2 0e 00 00       	call   801337 <sys_page_alloc>
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
  8004a5:	68 80 2c 80 00       	push   $0x802c80
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 27 2c 80 00       	push   $0x802c27
  8004b1:	e8 3a 02 00 00       	call   8006f0 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 54 2c 80 00       	push   $0x802c54
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 27 2c 80 00       	push   $0x802c27
  8004c3:	e8 28 02 00 00       	call   8006f0 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 54 11 00 00       	call   80162c <set_pgfault_handler>

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
  8005ac:	68 67 2c 80 00       	push   $0x802c67
  8005b1:	68 78 2c 80 00       	push   $0x802c78
  8005b6:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005bb:	ba 38 2c 80 00       	mov    $0x802c38,%edx
  8005c0:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 b4 2c 80 00       	push   $0x802cb4
  8005d7:	e8 0a 02 00 00       	call   8007e6 <cprintf>
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
  8005f4:	e8 00 0d 00 00       	call   8012f9 <sys_getenvid>
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
  800619:	74 23                	je     80063e <libmain+0x5d>
		if(envs[i].env_id == find)
  80061b:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800621:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800627:	8b 49 48             	mov    0x48(%ecx),%ecx
  80062a:	39 c1                	cmp    %eax,%ecx
  80062c:	75 e2                	jne    800610 <libmain+0x2f>
  80062e:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800634:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80063a:	89 fe                	mov    %edi,%esi
  80063c:	eb d2                	jmp    800610 <libmain+0x2f>
  80063e:	89 f0                	mov    %esi,%eax
  800640:	84 c0                	test   %al,%al
  800642:	74 06                	je     80064a <libmain+0x69>
  800644:	89 1d b4 50 80 00    	mov    %ebx,0x8050b4
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80064e:	7e 0a                	jle    80065a <libmain+0x79>
		binaryname = argv[0];
  800650:	8b 45 0c             	mov    0xc(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80065a:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80065f:	8b 40 48             	mov    0x48(%eax),%eax
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	50                   	push   %eax
  800666:	68 d3 2c 80 00       	push   $0x802cd3
  80066b:	e8 76 01 00 00       	call   8007e6 <cprintf>
	cprintf("before umain\n");
  800670:	c7 04 24 f1 2c 80 00 	movl   $0x802cf1,(%esp)
  800677:	e8 6a 01 00 00       	call   8007e6 <cprintf>
	// call user main routine
	umain(argc, argv);
  80067c:	83 c4 08             	add    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	ff 75 08             	pushl  0x8(%ebp)
  800685:	e8 3e fe ff ff       	call   8004c8 <umain>
	cprintf("after umain\n");
  80068a:	c7 04 24 ff 2c 80 00 	movl   $0x802cff,(%esp)
  800691:	e8 50 01 00 00       	call   8007e6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800696:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80069b:	8b 40 48             	mov    0x48(%eax),%eax
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	50                   	push   %eax
  8006a2:	68 0c 2d 80 00       	push   $0x802d0c
  8006a7:	e8 3a 01 00 00       	call   8007e6 <cprintf>
	// exit gracefully
	exit();
  8006ac:	e8 0b 00 00 00       	call   8006bc <exit>
}
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b7:	5b                   	pop    %ebx
  8006b8:	5e                   	pop    %esi
  8006b9:	5f                   	pop    %edi
  8006ba:	5d                   	pop    %ebp
  8006bb:	c3                   	ret    

008006bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006c2:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8006c7:	8b 40 48             	mov    0x48(%eax),%eax
  8006ca:	68 38 2d 80 00       	push   $0x802d38
  8006cf:	50                   	push   %eax
  8006d0:	68 2b 2d 80 00       	push   $0x802d2b
  8006d5:	e8 0c 01 00 00       	call   8007e6 <cprintf>
	close_all();
  8006da:	e8 ba 11 00 00       	call   801899 <close_all>
	sys_env_destroy(0);
  8006df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006e6:	e8 cd 0b 00 00       	call   8012b8 <sys_env_destroy>
}
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	56                   	push   %esi
  8006f4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8006f5:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8006fa:	8b 40 48             	mov    0x48(%eax),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	68 64 2d 80 00       	push   $0x802d64
  800705:	50                   	push   %eax
  800706:	68 2b 2d 80 00       	push   $0x802d2b
  80070b:	e8 d6 00 00 00       	call   8007e6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800710:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800713:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800719:	e8 db 0b 00 00       	call   8012f9 <sys_getenvid>
  80071e:	83 c4 04             	add    $0x4,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	56                   	push   %esi
  800728:	50                   	push   %eax
  800729:	68 40 2d 80 00       	push   $0x802d40
  80072e:	e8 b3 00 00 00       	call   8007e6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800733:	83 c4 18             	add    $0x18,%esp
  800736:	53                   	push   %ebx
  800737:	ff 75 10             	pushl  0x10(%ebp)
  80073a:	e8 56 00 00 00       	call   800795 <vcprintf>
	cprintf("\n");
  80073f:	c7 04 24 ef 2c 80 00 	movl   $0x802cef,(%esp)
  800746:	e8 9b 00 00 00       	call   8007e6 <cprintf>
  80074b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80074e:	cc                   	int3   
  80074f:	eb fd                	jmp    80074e <_panic+0x5e>

00800751 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	53                   	push   %ebx
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80075b:	8b 13                	mov    (%ebx),%edx
  80075d:	8d 42 01             	lea    0x1(%edx),%eax
  800760:	89 03                	mov    %eax,(%ebx)
  800762:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800765:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800769:	3d ff 00 00 00       	cmp    $0xff,%eax
  80076e:	74 09                	je     800779 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800770:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800777:	c9                   	leave  
  800778:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	68 ff 00 00 00       	push   $0xff
  800781:	8d 43 08             	lea    0x8(%ebx),%eax
  800784:	50                   	push   %eax
  800785:	e8 f1 0a 00 00       	call   80127b <sys_cputs>
		b->idx = 0;
  80078a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	eb db                	jmp    800770 <putch+0x1f>

00800795 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a5:	00 00 00 
	b.cnt = 0;
  8007a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007af:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	ff 75 08             	pushl  0x8(%ebp)
  8007b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007be:	50                   	push   %eax
  8007bf:	68 51 07 80 00       	push   $0x800751
  8007c4:	e8 4a 01 00 00       	call   800913 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007c9:	83 c4 08             	add    $0x8,%esp
  8007cc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007d2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	e8 9d 0a 00 00       	call   80127b <sys_cputs>

	return b.cnt;
}
  8007de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007ef:	50                   	push   %eax
  8007f0:	ff 75 08             	pushl  0x8(%ebp)
  8007f3:	e8 9d ff ff ff       	call   800795 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	57                   	push   %edi
  8007fe:	56                   	push   %esi
  8007ff:	53                   	push   %ebx
  800800:	83 ec 1c             	sub    $0x1c,%esp
  800803:	89 c6                	mov    %eax,%esi
  800805:	89 d7                	mov    %edx,%edi
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800810:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800819:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80081d:	74 2c                	je     80084b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80081f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800822:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800829:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80082c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80082f:	39 c2                	cmp    %eax,%edx
  800831:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800834:	73 43                	jae    800879 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800836:	83 eb 01             	sub    $0x1,%ebx
  800839:	85 db                	test   %ebx,%ebx
  80083b:	7e 6c                	jle    8008a9 <printnum+0xaf>
				putch(padc, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	57                   	push   %edi
  800841:	ff 75 18             	pushl  0x18(%ebp)
  800844:	ff d6                	call   *%esi
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	eb eb                	jmp    800836 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80084b:	83 ec 0c             	sub    $0xc,%esp
  80084e:	6a 20                	push   $0x20
  800850:	6a 00                	push   $0x0
  800852:	50                   	push   %eax
  800853:	ff 75 e4             	pushl  -0x1c(%ebp)
  800856:	ff 75 e0             	pushl  -0x20(%ebp)
  800859:	89 fa                	mov    %edi,%edx
  80085b:	89 f0                	mov    %esi,%eax
  80085d:	e8 98 ff ff ff       	call   8007fa <printnum>
		while (--width > 0)
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	83 eb 01             	sub    $0x1,%ebx
  800868:	85 db                	test   %ebx,%ebx
  80086a:	7e 65                	jle    8008d1 <printnum+0xd7>
			putch(padc, putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	57                   	push   %edi
  800870:	6a 20                	push   $0x20
  800872:	ff d6                	call   *%esi
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	eb ec                	jmp    800865 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800879:	83 ec 0c             	sub    $0xc,%esp
  80087c:	ff 75 18             	pushl  0x18(%ebp)
  80087f:	83 eb 01             	sub    $0x1,%ebx
  800882:	53                   	push   %ebx
  800883:	50                   	push   %eax
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 dc             	pushl  -0x24(%ebp)
  80088a:	ff 75 d8             	pushl  -0x28(%ebp)
  80088d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800890:	ff 75 e0             	pushl  -0x20(%ebp)
  800893:	e8 c8 20 00 00       	call   802960 <__udivdi3>
  800898:	83 c4 18             	add    $0x18,%esp
  80089b:	52                   	push   %edx
  80089c:	50                   	push   %eax
  80089d:	89 fa                	mov    %edi,%edx
  80089f:	89 f0                	mov    %esi,%eax
  8008a1:	e8 54 ff ff ff       	call   8007fa <printnum>
  8008a6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	57                   	push   %edi
  8008ad:	83 ec 04             	sub    $0x4,%esp
  8008b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8008b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8008b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bc:	e8 af 21 00 00       	call   802a70 <__umoddi3>
  8008c1:	83 c4 14             	add    $0x14,%esp
  8008c4:	0f be 80 6b 2d 80 00 	movsbl 0x802d6b(%eax),%eax
  8008cb:	50                   	push   %eax
  8008cc:	ff d6                	call   *%esi
  8008ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8008d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5f                   	pop    %edi
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e3:	8b 10                	mov    (%eax),%edx
  8008e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8008e8:	73 0a                	jae    8008f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8008ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008ed:	89 08                	mov    %ecx,(%eax)
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	88 02                	mov    %al,(%edx)
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <printfmt>:
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008ff:	50                   	push   %eax
  800900:	ff 75 10             	pushl  0x10(%ebp)
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 05 00 00 00       	call   800913 <vprintfmt>
}
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	c9                   	leave  
  800912:	c3                   	ret    

00800913 <vprintfmt>:
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	57                   	push   %edi
  800917:	56                   	push   %esi
  800918:	53                   	push   %ebx
  800919:	83 ec 3c             	sub    $0x3c,%esp
  80091c:	8b 75 08             	mov    0x8(%ebp),%esi
  80091f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800922:	8b 7d 10             	mov    0x10(%ebp),%edi
  800925:	e9 32 04 00 00       	jmp    800d5c <vprintfmt+0x449>
		padc = ' ';
  80092a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80092e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800935:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80093c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800943:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80094a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800951:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800956:	8d 47 01             	lea    0x1(%edi),%eax
  800959:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80095c:	0f b6 17             	movzbl (%edi),%edx
  80095f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800962:	3c 55                	cmp    $0x55,%al
  800964:	0f 87 12 05 00 00    	ja     800e7c <vprintfmt+0x569>
  80096a:	0f b6 c0             	movzbl %al,%eax
  80096d:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  800974:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800977:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80097b:	eb d9                	jmp    800956 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80097d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800980:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800984:	eb d0                	jmp    800956 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800986:	0f b6 d2             	movzbl %dl,%edx
  800989:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80098c:	b8 00 00 00 00       	mov    $0x0,%eax
  800991:	89 75 08             	mov    %esi,0x8(%ebp)
  800994:	eb 03                	jmp    800999 <vprintfmt+0x86>
  800996:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800999:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80099c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8009a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009a3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009a6:	83 fe 09             	cmp    $0x9,%esi
  8009a9:	76 eb                	jbe    800996 <vprintfmt+0x83>
  8009ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b1:	eb 14                	jmp    8009c7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 40 04             	lea    0x4(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8009c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009cb:	79 89                	jns    800956 <vprintfmt+0x43>
				width = precision, precision = -1;
  8009cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8009da:	e9 77 ff ff ff       	jmp    800956 <vprintfmt+0x43>
  8009df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	0f 48 c1             	cmovs  %ecx,%eax
  8009e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009ed:	e9 64 ff ff ff       	jmp    800956 <vprintfmt+0x43>
  8009f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009f5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8009fc:	e9 55 ff ff ff       	jmp    800956 <vprintfmt+0x43>
			lflag++;
  800a01:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a05:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a08:	e9 49 ff ff ff       	jmp    800956 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8d 78 04             	lea    0x4(%eax),%edi
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	53                   	push   %ebx
  800a17:	ff 30                	pushl  (%eax)
  800a19:	ff d6                	call   *%esi
			break;
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a1e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a21:	e9 33 03 00 00       	jmp    800d59 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	8d 78 04             	lea    0x4(%eax),%edi
  800a2c:	8b 00                	mov    (%eax),%eax
  800a2e:	99                   	cltd   
  800a2f:	31 d0                	xor    %edx,%eax
  800a31:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a33:	83 f8 11             	cmp    $0x11,%eax
  800a36:	7f 23                	jg     800a5b <vprintfmt+0x148>
  800a38:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  800a3f:	85 d2                	test   %edx,%edx
  800a41:	74 18                	je     800a5b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800a43:	52                   	push   %edx
  800a44:	68 39 32 80 00       	push   $0x803239
  800a49:	53                   	push   %ebx
  800a4a:	56                   	push   %esi
  800a4b:	e8 a6 fe ff ff       	call   8008f6 <printfmt>
  800a50:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a53:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a56:	e9 fe 02 00 00       	jmp    800d59 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800a5b:	50                   	push   %eax
  800a5c:	68 83 2d 80 00       	push   $0x802d83
  800a61:	53                   	push   %ebx
  800a62:	56                   	push   %esi
  800a63:	e8 8e fe ff ff       	call   8008f6 <printfmt>
  800a68:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a6b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a6e:	e9 e6 02 00 00       	jmp    800d59 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 c0 04             	add    $0x4,%eax
  800a79:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800a81:	85 c9                	test   %ecx,%ecx
  800a83:	b8 7c 2d 80 00       	mov    $0x802d7c,%eax
  800a88:	0f 45 c1             	cmovne %ecx,%eax
  800a8b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800a8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a92:	7e 06                	jle    800a9a <vprintfmt+0x187>
  800a94:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800a98:	75 0d                	jne    800aa7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	03 45 e0             	add    -0x20(%ebp),%eax
  800aa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aa5:	eb 53                	jmp    800afa <vprintfmt+0x1e7>
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 d8             	pushl  -0x28(%ebp)
  800aad:	50                   	push   %eax
  800aae:	e8 71 04 00 00       	call   800f24 <strnlen>
  800ab3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ab6:	29 c1                	sub    %eax,%ecx
  800ab8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800ac0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800ac4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac7:	eb 0f                	jmp    800ad8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	53                   	push   %ebx
  800acd:	ff 75 e0             	pushl  -0x20(%ebp)
  800ad0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad2:	83 ef 01             	sub    $0x1,%edi
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	85 ff                	test   %edi,%edi
  800ada:	7f ed                	jg     800ac9 <vprintfmt+0x1b6>
  800adc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800adf:	85 c9                	test   %ecx,%ecx
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	0f 49 c1             	cmovns %ecx,%eax
  800ae9:	29 c1                	sub    %eax,%ecx
  800aeb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800aee:	eb aa                	jmp    800a9a <vprintfmt+0x187>
					putch(ch, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	53                   	push   %ebx
  800af4:	52                   	push   %edx
  800af5:	ff d6                	call   *%esi
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800afd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aff:	83 c7 01             	add    $0x1,%edi
  800b02:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b06:	0f be d0             	movsbl %al,%edx
  800b09:	85 d2                	test   %edx,%edx
  800b0b:	74 4b                	je     800b58 <vprintfmt+0x245>
  800b0d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b11:	78 06                	js     800b19 <vprintfmt+0x206>
  800b13:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b17:	78 1e                	js     800b37 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800b19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800b1d:	74 d1                	je     800af0 <vprintfmt+0x1dd>
  800b1f:	0f be c0             	movsbl %al,%eax
  800b22:	83 e8 20             	sub    $0x20,%eax
  800b25:	83 f8 5e             	cmp    $0x5e,%eax
  800b28:	76 c6                	jbe    800af0 <vprintfmt+0x1dd>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	53                   	push   %ebx
  800b2e:	6a 3f                	push   $0x3f
  800b30:	ff d6                	call   *%esi
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	eb c3                	jmp    800afa <vprintfmt+0x1e7>
  800b37:	89 cf                	mov    %ecx,%edi
  800b39:	eb 0e                	jmp    800b49 <vprintfmt+0x236>
				putch(' ', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	53                   	push   %ebx
  800b3f:	6a 20                	push   $0x20
  800b41:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b43:	83 ef 01             	sub    $0x1,%edi
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	85 ff                	test   %edi,%edi
  800b4b:	7f ee                	jg     800b3b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800b4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b50:	89 45 14             	mov    %eax,0x14(%ebp)
  800b53:	e9 01 02 00 00       	jmp    800d59 <vprintfmt+0x446>
  800b58:	89 cf                	mov    %ecx,%edi
  800b5a:	eb ed                	jmp    800b49 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800b5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800b5f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800b66:	e9 eb fd ff ff       	jmp    800956 <vprintfmt+0x43>
	if (lflag >= 2)
  800b6b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800b6f:	7f 21                	jg     800b92 <vprintfmt+0x27f>
	else if (lflag)
  800b71:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800b75:	74 68                	je     800bdf <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800b77:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b7f:	89 c1                	mov    %eax,%ecx
  800b81:	c1 f9 1f             	sar    $0x1f,%ecx
  800b84:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b87:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8a:	8d 40 04             	lea    0x4(%eax),%eax
  800b8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b90:	eb 17                	jmp    800ba9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800b92:	8b 45 14             	mov    0x14(%ebp),%eax
  800b95:	8b 50 04             	mov    0x4(%eax),%edx
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b9d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	8d 40 08             	lea    0x8(%eax),%eax
  800ba6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800ba9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800baf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800bb5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bb9:	78 3f                	js     800bfa <vprintfmt+0x2e7>
			base = 10;
  800bbb:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800bc0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800bc4:	0f 84 71 01 00 00    	je     800d3b <vprintfmt+0x428>
				putch('+', putdat);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	53                   	push   %ebx
  800bce:	6a 2b                	push   $0x2b
  800bd0:	ff d6                	call   *%esi
  800bd2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bd5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bda:	e9 5c 01 00 00       	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, int);
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800be7:	89 c1                	mov    %eax,%ecx
  800be9:	c1 f9 1f             	sar    $0x1f,%ecx
  800bec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	8d 40 04             	lea    0x4(%eax),%eax
  800bf5:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf8:	eb af                	jmp    800ba9 <vprintfmt+0x296>
				putch('-', putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	53                   	push   %ebx
  800bfe:	6a 2d                	push   $0x2d
  800c00:	ff d6                	call   *%esi
				num = -(long long) num;
  800c02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800c08:	f7 d8                	neg    %eax
  800c0a:	83 d2 00             	adc    $0x0,%edx
  800c0d:	f7 da                	neg    %edx
  800c0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c12:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c15:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1d:	e9 19 01 00 00       	jmp    800d3b <vprintfmt+0x428>
	if (lflag >= 2)
  800c22:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800c26:	7f 29                	jg     800c51 <vprintfmt+0x33e>
	else if (lflag)
  800c28:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c2c:	74 44                	je     800c72 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c41:	8d 40 04             	lea    0x4(%eax),%eax
  800c44:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c4c:	e9 ea 00 00 00       	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	8b 50 04             	mov    0x4(%eax),%edx
  800c57:	8b 00                	mov    (%eax),%eax
  800c59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c62:	8d 40 08             	lea    0x8(%eax),%eax
  800c65:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c68:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6d:	e9 c9 00 00 00       	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	8d 40 04             	lea    0x4(%eax),%eax
  800c88:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c90:	e9 a6 00 00 00       	jmp    800d3b <vprintfmt+0x428>
			putch('0', putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	53                   	push   %ebx
  800c99:	6a 30                	push   $0x30
  800c9b:	ff d6                	call   *%esi
	if (lflag >= 2)
  800c9d:	83 c4 10             	add    $0x10,%esp
  800ca0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800ca4:	7f 26                	jg     800ccc <vprintfmt+0x3b9>
	else if (lflag)
  800ca6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800caa:	74 3e                	je     800cea <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800cac:	8b 45 14             	mov    0x14(%ebp),%eax
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cb9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	8d 40 04             	lea    0x4(%eax),%eax
  800cc2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cc5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cca:	eb 6f                	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	8b 50 04             	mov    0x4(%eax),%edx
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	8d 40 08             	lea    0x8(%eax),%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ce3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce8:	eb 51                	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800cea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cf7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	8d 40 04             	lea    0x4(%eax),%eax
  800d00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d03:	b8 08 00 00 00       	mov    $0x8,%eax
  800d08:	eb 31                	jmp    800d3b <vprintfmt+0x428>
			putch('0', putdat);
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	53                   	push   %ebx
  800d0e:	6a 30                	push   $0x30
  800d10:	ff d6                	call   *%esi
			putch('x', putdat);
  800d12:	83 c4 08             	add    $0x8,%esp
  800d15:	53                   	push   %ebx
  800d16:	6a 78                	push   $0x78
  800d18:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8b 00                	mov    (%eax),%eax
  800d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d27:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800d2a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	8d 40 04             	lea    0x4(%eax),%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d36:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	83 ec 0c             	sub    $0xc,%esp
  800d3e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800d42:	52                   	push   %edx
  800d43:	ff 75 e0             	pushl  -0x20(%ebp)
  800d46:	50                   	push   %eax
  800d47:	ff 75 dc             	pushl  -0x24(%ebp)
  800d4a:	ff 75 d8             	pushl  -0x28(%ebp)
  800d4d:	89 da                	mov    %ebx,%edx
  800d4f:	89 f0                	mov    %esi,%eax
  800d51:	e8 a4 fa ff ff       	call   8007fa <printnum>
			break;
  800d56:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5c:	83 c7 01             	add    $0x1,%edi
  800d5f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d63:	83 f8 25             	cmp    $0x25,%eax
  800d66:	0f 84 be fb ff ff    	je     80092a <vprintfmt+0x17>
			if (ch == '\0')
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	0f 84 28 01 00 00    	je     800e9c <vprintfmt+0x589>
			putch(ch, putdat);
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	53                   	push   %ebx
  800d78:	50                   	push   %eax
  800d79:	ff d6                	call   *%esi
  800d7b:	83 c4 10             	add    $0x10,%esp
  800d7e:	eb dc                	jmp    800d5c <vprintfmt+0x449>
	if (lflag >= 2)
  800d80:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800d84:	7f 26                	jg     800dac <vprintfmt+0x499>
	else if (lflag)
  800d86:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800d8a:	74 41                	je     800dcd <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d99:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9f:	8d 40 04             	lea    0x4(%eax),%eax
  800da2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800da5:	b8 10 00 00 00       	mov    $0x10,%eax
  800daa:	eb 8f                	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800dac:	8b 45 14             	mov    0x14(%ebp),%eax
  800daf:	8b 50 04             	mov    0x4(%eax),%edx
  800db2:	8b 00                	mov    (%eax),%eax
  800db4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800db7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800dba:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbd:	8d 40 08             	lea    0x8(%eax),%eax
  800dc0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dc3:	b8 10 00 00 00       	mov    $0x10,%eax
  800dc8:	e9 6e ff ff ff       	jmp    800d3b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800dda:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	8d 40 04             	lea    0x4(%eax),%eax
  800de3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800de6:	b8 10 00 00 00       	mov    $0x10,%eax
  800deb:	e9 4b ff ff ff       	jmp    800d3b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	83 c0 04             	add    $0x4,%eax
  800df6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800df9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	74 14                	je     800e16 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800e02:	8b 13                	mov    (%ebx),%edx
  800e04:	83 fa 7f             	cmp    $0x7f,%edx
  800e07:	7f 37                	jg     800e40 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800e09:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800e0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e11:	e9 43 ff ff ff       	jmp    800d59 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800e16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1b:	bf a1 2e 80 00       	mov    $0x802ea1,%edi
							putch(ch, putdat);
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	53                   	push   %ebx
  800e24:	50                   	push   %eax
  800e25:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e27:	83 c7 01             	add    $0x1,%edi
  800e2a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	75 eb                	jne    800e20 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800e35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e38:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3b:	e9 19 ff ff ff       	jmp    800d59 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800e40:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800e42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e47:	bf d9 2e 80 00       	mov    $0x802ed9,%edi
							putch(ch, putdat);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	53                   	push   %ebx
  800e50:	50                   	push   %eax
  800e51:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800e53:	83 c7 01             	add    $0x1,%edi
  800e56:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 eb                	jne    800e4c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800e61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	e9 ed fe ff ff       	jmp    800d59 <vprintfmt+0x446>
			putch(ch, putdat);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	53                   	push   %ebx
  800e70:	6a 25                	push   $0x25
  800e72:	ff d6                	call   *%esi
			break;
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	e9 dd fe ff ff       	jmp    800d59 <vprintfmt+0x446>
			putch('%', putdat);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	53                   	push   %ebx
  800e80:	6a 25                	push   $0x25
  800e82:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 f8                	mov    %edi,%eax
  800e89:	eb 03                	jmp    800e8e <vprintfmt+0x57b>
  800e8b:	83 e8 01             	sub    $0x1,%eax
  800e8e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e92:	75 f7                	jne    800e8b <vprintfmt+0x578>
  800e94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e97:	e9 bd fe ff ff       	jmp    800d59 <vprintfmt+0x446>
}
  800e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 18             	sub    $0x18,%esp
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eb3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800eb7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800eba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	74 26                	je     800eeb <vsnprintf+0x47>
  800ec5:	85 d2                	test   %edx,%edx
  800ec7:	7e 22                	jle    800eeb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec9:	ff 75 14             	pushl  0x14(%ebp)
  800ecc:	ff 75 10             	pushl  0x10(%ebp)
  800ecf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed2:	50                   	push   %eax
  800ed3:	68 d9 08 80 00       	push   $0x8008d9
  800ed8:	e8 36 fa ff ff       	call   800913 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    
		return -E_INVAL;
  800eeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef0:	eb f7                	jmp    800ee9 <vsnprintf+0x45>

00800ef2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ef8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800efb:	50                   	push   %eax
  800efc:	ff 75 10             	pushl  0x10(%ebp)
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	ff 75 08             	pushl  0x8(%ebp)
  800f05:	e8 9a ff ff ff       	call   800ea4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
  800f17:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f1b:	74 05                	je     800f22 <strlen+0x16>
		n++;
  800f1d:	83 c0 01             	add    $0x1,%eax
  800f20:	eb f5                	jmp    800f17 <strlen+0xb>
	return n;
}
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    

00800f24 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f32:	39 c2                	cmp    %eax,%edx
  800f34:	74 0d                	je     800f43 <strnlen+0x1f>
  800f36:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800f3a:	74 05                	je     800f41 <strnlen+0x1d>
		n++;
  800f3c:	83 c2 01             	add    $0x1,%edx
  800f3f:	eb f1                	jmp    800f32 <strnlen+0xe>
  800f41:	89 d0                	mov    %edx,%eax
	return n;
}
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	53                   	push   %ebx
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f54:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f58:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f5b:	83 c2 01             	add    $0x1,%edx
  800f5e:	84 c9                	test   %cl,%cl
  800f60:	75 f2                	jne    800f54 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f62:	5b                   	pop    %ebx
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	53                   	push   %ebx
  800f69:	83 ec 10             	sub    $0x10,%esp
  800f6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f6f:	53                   	push   %ebx
  800f70:	e8 97 ff ff ff       	call   800f0c <strlen>
  800f75:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f78:	ff 75 0c             	pushl  0xc(%ebp)
  800f7b:	01 d8                	add    %ebx,%eax
  800f7d:	50                   	push   %eax
  800f7e:	e8 c2 ff ff ff       	call   800f45 <strcpy>
	return dst;
}
  800f83:	89 d8                	mov    %ebx,%eax
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	89 c6                	mov    %eax,%esi
  800f97:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f9a:	89 c2                	mov    %eax,%edx
  800f9c:	39 f2                	cmp    %esi,%edx
  800f9e:	74 11                	je     800fb1 <strncpy+0x27>
		*dst++ = *src;
  800fa0:	83 c2 01             	add    $0x1,%edx
  800fa3:	0f b6 19             	movzbl (%ecx),%ebx
  800fa6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fa9:	80 fb 01             	cmp    $0x1,%bl
  800fac:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800faf:	eb eb                	jmp    800f9c <strncpy+0x12>
	}
	return ret;
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	8b 55 10             	mov    0x10(%ebp),%edx
  800fc3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800fc5:	85 d2                	test   %edx,%edx
  800fc7:	74 21                	je     800fea <strlcpy+0x35>
  800fc9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800fcd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800fcf:	39 c2                	cmp    %eax,%edx
  800fd1:	74 14                	je     800fe7 <strlcpy+0x32>
  800fd3:	0f b6 19             	movzbl (%ecx),%ebx
  800fd6:	84 db                	test   %bl,%bl
  800fd8:	74 0b                	je     800fe5 <strlcpy+0x30>
			*dst++ = *src++;
  800fda:	83 c1 01             	add    $0x1,%ecx
  800fdd:	83 c2 01             	add    $0x1,%edx
  800fe0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800fe3:	eb ea                	jmp    800fcf <strlcpy+0x1a>
  800fe5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800fe7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fea:	29 f0                	sub    %esi,%eax
}
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ff9:	0f b6 01             	movzbl (%ecx),%eax
  800ffc:	84 c0                	test   %al,%al
  800ffe:	74 0c                	je     80100c <strcmp+0x1c>
  801000:	3a 02                	cmp    (%edx),%al
  801002:	75 08                	jne    80100c <strcmp+0x1c>
		p++, q++;
  801004:	83 c1 01             	add    $0x1,%ecx
  801007:	83 c2 01             	add    $0x1,%edx
  80100a:	eb ed                	jmp    800ff9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	0f b6 12             	movzbl (%edx),%edx
  801012:	29 d0                	sub    %edx,%eax
}
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	53                   	push   %ebx
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801020:	89 c3                	mov    %eax,%ebx
  801022:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801025:	eb 06                	jmp    80102d <strncmp+0x17>
		n--, p++, q++;
  801027:	83 c0 01             	add    $0x1,%eax
  80102a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80102d:	39 d8                	cmp    %ebx,%eax
  80102f:	74 16                	je     801047 <strncmp+0x31>
  801031:	0f b6 08             	movzbl (%eax),%ecx
  801034:	84 c9                	test   %cl,%cl
  801036:	74 04                	je     80103c <strncmp+0x26>
  801038:	3a 0a                	cmp    (%edx),%cl
  80103a:	74 eb                	je     801027 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80103c:	0f b6 00             	movzbl (%eax),%eax
  80103f:	0f b6 12             	movzbl (%edx),%edx
  801042:	29 d0                	sub    %edx,%eax
}
  801044:	5b                   	pop    %ebx
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    
		return 0;
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
  80104c:	eb f6                	jmp    801044 <strncmp+0x2e>

0080104e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801058:	0f b6 10             	movzbl (%eax),%edx
  80105b:	84 d2                	test   %dl,%dl
  80105d:	74 09                	je     801068 <strchr+0x1a>
		if (*s == c)
  80105f:	38 ca                	cmp    %cl,%dl
  801061:	74 0a                	je     80106d <strchr+0x1f>
	for (; *s; s++)
  801063:	83 c0 01             	add    $0x1,%eax
  801066:	eb f0                	jmp    801058 <strchr+0xa>
			return (char *) s;
	return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801079:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80107c:	38 ca                	cmp    %cl,%dl
  80107e:	74 09                	je     801089 <strfind+0x1a>
  801080:	84 d2                	test   %dl,%dl
  801082:	74 05                	je     801089 <strfind+0x1a>
	for (; *s; s++)
  801084:	83 c0 01             	add    $0x1,%eax
  801087:	eb f0                	jmp    801079 <strfind+0xa>
			break;
	return (char *) s;
}
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	8b 7d 08             	mov    0x8(%ebp),%edi
  801094:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801097:	85 c9                	test   %ecx,%ecx
  801099:	74 31                	je     8010cc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80109b:	89 f8                	mov    %edi,%eax
  80109d:	09 c8                	or     %ecx,%eax
  80109f:	a8 03                	test   $0x3,%al
  8010a1:	75 23                	jne    8010c6 <memset+0x3b>
		c &= 0xFF;
  8010a3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010a7:	89 d3                	mov    %edx,%ebx
  8010a9:	c1 e3 08             	shl    $0x8,%ebx
  8010ac:	89 d0                	mov    %edx,%eax
  8010ae:	c1 e0 18             	shl    $0x18,%eax
  8010b1:	89 d6                	mov    %edx,%esi
  8010b3:	c1 e6 10             	shl    $0x10,%esi
  8010b6:	09 f0                	or     %esi,%eax
  8010b8:	09 c2                	or     %eax,%edx
  8010ba:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010bc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8010bf:	89 d0                	mov    %edx,%eax
  8010c1:	fc                   	cld    
  8010c2:	f3 ab                	rep stos %eax,%es:(%edi)
  8010c4:	eb 06                	jmp    8010cc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	fc                   	cld    
  8010ca:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8010cc:	89 f8                	mov    %edi,%eax
  8010ce:	5b                   	pop    %ebx
  8010cf:	5e                   	pop    %esi
  8010d0:	5f                   	pop    %edi
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010de:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010e1:	39 c6                	cmp    %eax,%esi
  8010e3:	73 32                	jae    801117 <memmove+0x44>
  8010e5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010e8:	39 c2                	cmp    %eax,%edx
  8010ea:	76 2b                	jbe    801117 <memmove+0x44>
		s += n;
		d += n;
  8010ec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010ef:	89 fe                	mov    %edi,%esi
  8010f1:	09 ce                	or     %ecx,%esi
  8010f3:	09 d6                	or     %edx,%esi
  8010f5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010fb:	75 0e                	jne    80110b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010fd:	83 ef 04             	sub    $0x4,%edi
  801100:	8d 72 fc             	lea    -0x4(%edx),%esi
  801103:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801106:	fd                   	std    
  801107:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801109:	eb 09                	jmp    801114 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80110b:	83 ef 01             	sub    $0x1,%edi
  80110e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801111:	fd                   	std    
  801112:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801114:	fc                   	cld    
  801115:	eb 1a                	jmp    801131 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801117:	89 c2                	mov    %eax,%edx
  801119:	09 ca                	or     %ecx,%edx
  80111b:	09 f2                	or     %esi,%edx
  80111d:	f6 c2 03             	test   $0x3,%dl
  801120:	75 0a                	jne    80112c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801122:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801125:	89 c7                	mov    %eax,%edi
  801127:	fc                   	cld    
  801128:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80112a:	eb 05                	jmp    801131 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80112c:	89 c7                	mov    %eax,%edi
  80112e:	fc                   	cld    
  80112f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80113b:	ff 75 10             	pushl  0x10(%ebp)
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	ff 75 08             	pushl  0x8(%ebp)
  801144:	e8 8a ff ff ff       	call   8010d3 <memmove>
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8b 55 0c             	mov    0xc(%ebp),%edx
  801156:	89 c6                	mov    %eax,%esi
  801158:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80115b:	39 f0                	cmp    %esi,%eax
  80115d:	74 1c                	je     80117b <memcmp+0x30>
		if (*s1 != *s2)
  80115f:	0f b6 08             	movzbl (%eax),%ecx
  801162:	0f b6 1a             	movzbl (%edx),%ebx
  801165:	38 d9                	cmp    %bl,%cl
  801167:	75 08                	jne    801171 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801169:	83 c0 01             	add    $0x1,%eax
  80116c:	83 c2 01             	add    $0x1,%edx
  80116f:	eb ea                	jmp    80115b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801171:	0f b6 c1             	movzbl %cl,%eax
  801174:	0f b6 db             	movzbl %bl,%ebx
  801177:	29 d8                	sub    %ebx,%eax
  801179:	eb 05                	jmp    801180 <memcmp+0x35>
	}

	return 0;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801192:	39 d0                	cmp    %edx,%eax
  801194:	73 09                	jae    80119f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801196:	38 08                	cmp    %cl,(%eax)
  801198:	74 05                	je     80119f <memfind+0x1b>
	for (; s < ends; s++)
  80119a:	83 c0 01             	add    $0x1,%eax
  80119d:	eb f3                	jmp    801192 <memfind+0xe>
			break;
	return (void *) s;
}
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	57                   	push   %edi
  8011a5:	56                   	push   %esi
  8011a6:	53                   	push   %ebx
  8011a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ad:	eb 03                	jmp    8011b2 <strtol+0x11>
		s++;
  8011af:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8011b2:	0f b6 01             	movzbl (%ecx),%eax
  8011b5:	3c 20                	cmp    $0x20,%al
  8011b7:	74 f6                	je     8011af <strtol+0xe>
  8011b9:	3c 09                	cmp    $0x9,%al
  8011bb:	74 f2                	je     8011af <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8011bd:	3c 2b                	cmp    $0x2b,%al
  8011bf:	74 2a                	je     8011eb <strtol+0x4a>
	int neg = 0;
  8011c1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	74 2b                	je     8011f5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ca:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8011d0:	75 0f                	jne    8011e1 <strtol+0x40>
  8011d2:	80 39 30             	cmpb   $0x30,(%ecx)
  8011d5:	74 28                	je     8011ff <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8011d7:	85 db                	test   %ebx,%ebx
  8011d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011de:	0f 44 d8             	cmove  %eax,%ebx
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011e9:	eb 50                	jmp    80123b <strtol+0x9a>
		s++;
  8011eb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8011ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8011f3:	eb d5                	jmp    8011ca <strtol+0x29>
		s++, neg = 1;
  8011f5:	83 c1 01             	add    $0x1,%ecx
  8011f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8011fd:	eb cb                	jmp    8011ca <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ff:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801203:	74 0e                	je     801213 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801205:	85 db                	test   %ebx,%ebx
  801207:	75 d8                	jne    8011e1 <strtol+0x40>
		s++, base = 8;
  801209:	83 c1 01             	add    $0x1,%ecx
  80120c:	bb 08 00 00 00       	mov    $0x8,%ebx
  801211:	eb ce                	jmp    8011e1 <strtol+0x40>
		s += 2, base = 16;
  801213:	83 c1 02             	add    $0x2,%ecx
  801216:	bb 10 00 00 00       	mov    $0x10,%ebx
  80121b:	eb c4                	jmp    8011e1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80121d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801220:	89 f3                	mov    %esi,%ebx
  801222:	80 fb 19             	cmp    $0x19,%bl
  801225:	77 29                	ja     801250 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801227:	0f be d2             	movsbl %dl,%edx
  80122a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80122d:	3b 55 10             	cmp    0x10(%ebp),%edx
  801230:	7d 30                	jge    801262 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801232:	83 c1 01             	add    $0x1,%ecx
  801235:	0f af 45 10          	imul   0x10(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80123b:	0f b6 11             	movzbl (%ecx),%edx
  80123e:	8d 72 d0             	lea    -0x30(%edx),%esi
  801241:	89 f3                	mov    %esi,%ebx
  801243:	80 fb 09             	cmp    $0x9,%bl
  801246:	77 d5                	ja     80121d <strtol+0x7c>
			dig = *s - '0';
  801248:	0f be d2             	movsbl %dl,%edx
  80124b:	83 ea 30             	sub    $0x30,%edx
  80124e:	eb dd                	jmp    80122d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8d 72 bf             	lea    -0x41(%edx),%esi
  801253:	89 f3                	mov    %esi,%ebx
  801255:	80 fb 19             	cmp    $0x19,%bl
  801258:	77 08                	ja     801262 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80125a:	0f be d2             	movsbl %dl,%edx
  80125d:	83 ea 37             	sub    $0x37,%edx
  801260:	eb cb                	jmp    80122d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801262:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801266:	74 05                	je     80126d <strtol+0xcc>
		*endptr = (char *) s;
  801268:	8b 75 0c             	mov    0xc(%ebp),%esi
  80126b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	f7 da                	neg    %edx
  801271:	85 ff                	test   %edi,%edi
  801273:	0f 45 c2             	cmovne %edx,%eax
}
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
	asm volatile("int %1\n"
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	8b 55 08             	mov    0x8(%ebp),%edx
  801289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128c:	89 c3                	mov    %eax,%ebx
  80128e:	89 c7                	mov    %eax,%edi
  801290:	89 c6                	mov    %eax,%esi
  801292:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801294:	5b                   	pop    %ebx
  801295:	5e                   	pop    %esi
  801296:	5f                   	pop    %edi
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <sys_cgetc>:

int
sys_cgetc(void)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80129f:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8012a9:	89 d1                	mov    %edx,%ecx
  8012ab:	89 d3                	mov    %edx,%ebx
  8012ad:	89 d7                	mov    %edx,%edi
  8012af:	89 d6                	mov    %edx,%esi
  8012b1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8012ce:	89 cb                	mov    %ecx,%ebx
  8012d0:	89 cf                	mov    %ecx,%edi
  8012d2:	89 ce                	mov    %ecx,%esi
  8012d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	7f 08                	jg     8012e2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	50                   	push   %eax
  8012e6:	6a 03                	push   $0x3
  8012e8:	68 e8 30 80 00       	push   $0x8030e8
  8012ed:	6a 43                	push   $0x43
  8012ef:	68 05 31 80 00       	push   $0x803105
  8012f4:	e8 f7 f3 ff ff       	call   8006f0 <_panic>

008012f9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801304:	b8 02 00 00 00       	mov    $0x2,%eax
  801309:	89 d1                	mov    %edx,%ecx
  80130b:	89 d3                	mov    %edx,%ebx
  80130d:	89 d7                	mov    %edx,%edi
  80130f:	89 d6                	mov    %edx,%esi
  801311:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801313:	5b                   	pop    %ebx
  801314:	5e                   	pop    %esi
  801315:	5f                   	pop    %edi
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    

00801318 <sys_yield>:

void
sys_yield(void)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	57                   	push   %edi
  80131c:	56                   	push   %esi
  80131d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80131e:	ba 00 00 00 00       	mov    $0x0,%edx
  801323:	b8 0b 00 00 00       	mov    $0xb,%eax
  801328:	89 d1                	mov    %edx,%ecx
  80132a:	89 d3                	mov    %edx,%ebx
  80132c:	89 d7                	mov    %edx,%edi
  80132e:	89 d6                	mov    %edx,%esi
  801330:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801340:	be 00 00 00 00       	mov    $0x0,%esi
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134b:	b8 04 00 00 00       	mov    $0x4,%eax
  801350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801353:	89 f7                	mov    %esi,%edi
  801355:	cd 30                	int    $0x30
	if(check && ret > 0)
  801357:	85 c0                	test   %eax,%eax
  801359:	7f 08                	jg     801363 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80135b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135e:	5b                   	pop    %ebx
  80135f:	5e                   	pop    %esi
  801360:	5f                   	pop    %edi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	50                   	push   %eax
  801367:	6a 04                	push   $0x4
  801369:	68 e8 30 80 00       	push   $0x8030e8
  80136e:	6a 43                	push   $0x43
  801370:	68 05 31 80 00       	push   $0x803105
  801375:	e8 76 f3 ff ff       	call   8006f0 <_panic>

0080137a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801383:	8b 55 08             	mov    0x8(%ebp),%edx
  801386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801389:	b8 05 00 00 00       	mov    $0x5,%eax
  80138e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801391:	8b 7d 14             	mov    0x14(%ebp),%edi
  801394:	8b 75 18             	mov    0x18(%ebp),%esi
  801397:	cd 30                	int    $0x30
	if(check && ret > 0)
  801399:	85 c0                	test   %eax,%eax
  80139b:	7f 08                	jg     8013a5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80139d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5e                   	pop    %esi
  8013a2:	5f                   	pop    %edi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	50                   	push   %eax
  8013a9:	6a 05                	push   $0x5
  8013ab:	68 e8 30 80 00       	push   $0x8030e8
  8013b0:	6a 43                	push   $0x43
  8013b2:	68 05 31 80 00       	push   $0x803105
  8013b7:	e8 34 f3 ff ff       	call   8006f0 <_panic>

008013bc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
  8013c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8013d5:	89 df                	mov    %ebx,%edi
  8013d7:	89 de                	mov    %ebx,%esi
  8013d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	7f 08                	jg     8013e7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e7:	83 ec 0c             	sub    $0xc,%esp
  8013ea:	50                   	push   %eax
  8013eb:	6a 06                	push   $0x6
  8013ed:	68 e8 30 80 00       	push   $0x8030e8
  8013f2:	6a 43                	push   $0x43
  8013f4:	68 05 31 80 00       	push   $0x803105
  8013f9:	e8 f2 f2 ff ff       	call   8006f0 <_panic>

008013fe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801407:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140c:	8b 55 08             	mov    0x8(%ebp),%edx
  80140f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801412:	b8 08 00 00 00       	mov    $0x8,%eax
  801417:	89 df                	mov    %ebx,%edi
  801419:	89 de                	mov    %ebx,%esi
  80141b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80141d:	85 c0                	test   %eax,%eax
  80141f:	7f 08                	jg     801429 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801421:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	50                   	push   %eax
  80142d:	6a 08                	push   $0x8
  80142f:	68 e8 30 80 00       	push   $0x8030e8
  801434:	6a 43                	push   $0x43
  801436:	68 05 31 80 00       	push   $0x803105
  80143b:	e8 b0 f2 ff ff       	call   8006f0 <_panic>

00801440 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	57                   	push   %edi
  801444:	56                   	push   %esi
  801445:	53                   	push   %ebx
  801446:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801449:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144e:	8b 55 08             	mov    0x8(%ebp),%edx
  801451:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801454:	b8 09 00 00 00       	mov    $0x9,%eax
  801459:	89 df                	mov    %ebx,%edi
  80145b:	89 de                	mov    %ebx,%esi
  80145d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80145f:	85 c0                	test   %eax,%eax
  801461:	7f 08                	jg     80146b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801463:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801466:	5b                   	pop    %ebx
  801467:	5e                   	pop    %esi
  801468:	5f                   	pop    %edi
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	50                   	push   %eax
  80146f:	6a 09                	push   $0x9
  801471:	68 e8 30 80 00       	push   $0x8030e8
  801476:	6a 43                	push   $0x43
  801478:	68 05 31 80 00       	push   $0x803105
  80147d:	e8 6e f2 ff ff       	call   8006f0 <_panic>

00801482 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	57                   	push   %edi
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80148b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801490:	8b 55 08             	mov    0x8(%ebp),%edx
  801493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801496:	b8 0a 00 00 00       	mov    $0xa,%eax
  80149b:	89 df                	mov    %ebx,%edi
  80149d:	89 de                	mov    %ebx,%esi
  80149f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	7f 08                	jg     8014ad <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a8:	5b                   	pop    %ebx
  8014a9:	5e                   	pop    %esi
  8014aa:	5f                   	pop    %edi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	50                   	push   %eax
  8014b1:	6a 0a                	push   $0xa
  8014b3:	68 e8 30 80 00       	push   $0x8030e8
  8014b8:	6a 43                	push   $0x43
  8014ba:	68 05 31 80 00       	push   $0x803105
  8014bf:	e8 2c f2 ff ff       	call   8006f0 <_panic>

008014c4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	57                   	push   %edi
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d0:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014d5:	be 00 00 00 00       	mov    $0x0,%esi
  8014da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014dd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014e0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014e2:	5b                   	pop    %ebx
  8014e3:	5e                   	pop    %esi
  8014e4:	5f                   	pop    %edi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	57                   	push   %edi
  8014eb:	56                   	push   %esi
  8014ec:	53                   	push   %ebx
  8014ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014fd:	89 cb                	mov    %ecx,%ebx
  8014ff:	89 cf                	mov    %ecx,%edi
  801501:	89 ce                	mov    %ecx,%esi
  801503:	cd 30                	int    $0x30
	if(check && ret > 0)
  801505:	85 c0                	test   %eax,%eax
  801507:	7f 08                	jg     801511 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150c:	5b                   	pop    %ebx
  80150d:	5e                   	pop    %esi
  80150e:	5f                   	pop    %edi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	50                   	push   %eax
  801515:	6a 0d                	push   $0xd
  801517:	68 e8 30 80 00       	push   $0x8030e8
  80151c:	6a 43                	push   $0x43
  80151e:	68 05 31 80 00       	push   $0x803105
  801523:	e8 c8 f1 ff ff       	call   8006f0 <_panic>

00801528 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	57                   	push   %edi
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80152e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801539:	b8 0e 00 00 00       	mov    $0xe,%eax
  80153e:	89 df                	mov    %ebx,%edi
  801540:	89 de                	mov    %ebx,%esi
  801542:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5f                   	pop    %edi
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    

00801549 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	57                   	push   %edi
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801554:	8b 55 08             	mov    0x8(%ebp),%edx
  801557:	b8 0f 00 00 00       	mov    $0xf,%eax
  80155c:	89 cb                	mov    %ecx,%ebx
  80155e:	89 cf                	mov    %ecx,%edi
  801560:	89 ce                	mov    %ecx,%esi
  801562:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5f                   	pop    %edi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	57                   	push   %edi
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156f:	ba 00 00 00 00       	mov    $0x0,%edx
  801574:	b8 10 00 00 00       	mov    $0x10,%eax
  801579:	89 d1                	mov    %edx,%ecx
  80157b:	89 d3                	mov    %edx,%ebx
  80157d:	89 d7                	mov    %edx,%edi
  80157f:	89 d6                	mov    %edx,%esi
  801581:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801583:	5b                   	pop    %ebx
  801584:	5e                   	pop    %esi
  801585:	5f                   	pop    %edi
  801586:	5d                   	pop    %ebp
  801587:	c3                   	ret    

00801588 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	57                   	push   %edi
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80158e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801593:	8b 55 08             	mov    0x8(%ebp),%edx
  801596:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801599:	b8 11 00 00 00       	mov    $0x11,%eax
  80159e:	89 df                	mov    %ebx,%edi
  8015a0:	89 de                	mov    %ebx,%esi
  8015a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5f                   	pop    %edi
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	57                   	push   %edi
  8015ad:	56                   	push   %esi
  8015ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ba:	b8 12 00 00 00       	mov    $0x12,%eax
  8015bf:	89 df                	mov    %ebx,%edi
  8015c1:	89 de                	mov    %ebx,%esi
  8015c3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5f                   	pop    %edi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	57                   	push   %edi
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015de:	b8 13 00 00 00       	mov    $0x13,%eax
  8015e3:	89 df                	mov    %ebx,%edi
  8015e5:	89 de                	mov    %ebx,%esi
  8015e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	7f 08                	jg     8015f5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	50                   	push   %eax
  8015f9:	6a 13                	push   $0x13
  8015fb:	68 e8 30 80 00       	push   $0x8030e8
  801600:	6a 43                	push   $0x43
  801602:	68 05 31 80 00       	push   $0x803105
  801607:	e8 e4 f0 ff ff       	call   8006f0 <_panic>

0080160c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	57                   	push   %edi
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
	asm volatile("int %1\n"
  801612:	b9 00 00 00 00       	mov    $0x0,%ecx
  801617:	8b 55 08             	mov    0x8(%ebp),%edx
  80161a:	b8 14 00 00 00       	mov    $0x14,%eax
  80161f:	89 cb                	mov    %ecx,%ebx
  801621:	89 cf                	mov    %ecx,%edi
  801623:	89 ce                	mov    %ecx,%esi
  801625:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801627:	5b                   	pop    %ebx
  801628:	5e                   	pop    %esi
  801629:	5f                   	pop    %edi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801632:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  801639:	74 0a                	je     801645 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	6a 07                	push   $0x7
  80164a:	68 00 f0 bf ee       	push   $0xeebff000
  80164f:	6a 00                	push   $0x0
  801651:	e8 e1 fc ff ff       	call   801337 <sys_page_alloc>
		if(r < 0)
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 2a                	js     801687 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	68 9b 16 80 00       	push   $0x80169b
  801665:	6a 00                	push   $0x0
  801667:	e8 16 fe ff ff       	call   801482 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	85 c0                	test   %eax,%eax
  801671:	79 c8                	jns    80163b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 44 31 80 00       	push   $0x803144
  80167b:	6a 25                	push   $0x25
  80167d:	68 7d 31 80 00       	push   $0x80317d
  801682:	e8 69 f0 ff ff       	call   8006f0 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 14 31 80 00       	push   $0x803114
  80168f:	6a 22                	push   $0x22
  801691:	68 7d 31 80 00       	push   $0x80317d
  801696:	e8 55 f0 ff ff       	call   8006f0 <_panic>

0080169b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80169b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80169c:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  8016a1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8016a3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8016a6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8016aa:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8016ae:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8016b1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8016b3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8016b7:	83 c4 08             	add    $0x8,%esp
	popal
  8016ba:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8016bb:	83 c4 04             	add    $0x4,%esp
	popfl
  8016be:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8016bf:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8016c0:	c3                   	ret    

008016c1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	05 00 00 00 30       	add    $0x30000000,%eax
  8016cc:	c1 e8 0c             	shr    $0xc,%eax
}
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	c1 ea 16             	shr    $0x16,%edx
  8016f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016fc:	f6 c2 01             	test   $0x1,%dl
  8016ff:	74 2d                	je     80172e <fd_alloc+0x46>
  801701:	89 c2                	mov    %eax,%edx
  801703:	c1 ea 0c             	shr    $0xc,%edx
  801706:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80170d:	f6 c2 01             	test   $0x1,%dl
  801710:	74 1c                	je     80172e <fd_alloc+0x46>
  801712:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801717:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80171c:	75 d2                	jne    8016f0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801727:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80172c:	eb 0a                	jmp    801738 <fd_alloc+0x50>
			*fd_store = fd;
  80172e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801731:	89 01                	mov    %eax,(%ecx)
			return 0;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801740:	83 f8 1f             	cmp    $0x1f,%eax
  801743:	77 30                	ja     801775 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801745:	c1 e0 0c             	shl    $0xc,%eax
  801748:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80174d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801753:	f6 c2 01             	test   $0x1,%dl
  801756:	74 24                	je     80177c <fd_lookup+0x42>
  801758:	89 c2                	mov    %eax,%edx
  80175a:	c1 ea 0c             	shr    $0xc,%edx
  80175d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801764:	f6 c2 01             	test   $0x1,%dl
  801767:	74 1a                	je     801783 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 02                	mov    %eax,(%edx)
	return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    
		return -E_INVAL;
  801775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177a:	eb f7                	jmp    801773 <fd_lookup+0x39>
		return -E_INVAL;
  80177c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801781:	eb f0                	jmp    801773 <fd_lookup+0x39>
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801788:	eb e9                	jmp    801773 <fd_lookup+0x39>

0080178a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801793:	ba 00 00 00 00       	mov    $0x0,%edx
  801798:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80179d:	39 08                	cmp    %ecx,(%eax)
  80179f:	74 38                	je     8017d9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017a1:	83 c2 01             	add    $0x1,%edx
  8017a4:	8b 04 95 0c 32 80 00 	mov    0x80320c(,%edx,4),%eax
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 ee                	jne    80179d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017af:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8017b4:	8b 40 48             	mov    0x48(%eax),%eax
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	51                   	push   %ecx
  8017bb:	50                   	push   %eax
  8017bc:	68 8c 31 80 00       	push   $0x80318c
  8017c1:	e8 20 f0 ff ff       	call   8007e6 <cprintf>
	*dev = 0;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    
			*dev = devtab[i];
  8017d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e3:	eb f2                	jmp    8017d7 <dev_lookup+0x4d>

008017e5 <fd_close>:
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 24             	sub    $0x24,%esp
  8017ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8017f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017f7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017fe:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801801:	50                   	push   %eax
  801802:	e8 33 ff ff ff       	call   80173a <fd_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 05                	js     801815 <fd_close+0x30>
	    || fd != fd2)
  801810:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801813:	74 16                	je     80182b <fd_close+0x46>
		return (must_exist ? r : 0);
  801815:	89 f8                	mov    %edi,%eax
  801817:	84 c0                	test   %al,%al
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
  80181e:	0f 44 d8             	cmove  %eax,%ebx
}
  801821:	89 d8                	mov    %ebx,%eax
  801823:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801826:	5b                   	pop    %ebx
  801827:	5e                   	pop    %esi
  801828:	5f                   	pop    %edi
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801831:	50                   	push   %eax
  801832:	ff 36                	pushl  (%esi)
  801834:	e8 51 ff ff ff       	call   80178a <dev_lookup>
  801839:	89 c3                	mov    %eax,%ebx
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 1a                	js     80185c <fd_close+0x77>
		if (dev->dev_close)
  801842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801845:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801848:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80184d:	85 c0                	test   %eax,%eax
  80184f:	74 0b                	je     80185c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	56                   	push   %esi
  801855:	ff d0                	call   *%eax
  801857:	89 c3                	mov    %eax,%ebx
  801859:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	56                   	push   %esi
  801860:	6a 00                	push   $0x0
  801862:	e8 55 fb ff ff       	call   8013bc <sys_page_unmap>
	return r;
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	eb b5                	jmp    801821 <fd_close+0x3c>

0080186c <close>:

int
close(int fdnum)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	e8 bc fe ff ff       	call   80173a <fd_lookup>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	79 02                	jns    801887 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    
		return fd_close(fd, 1);
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	6a 01                	push   $0x1
  80188c:	ff 75 f4             	pushl  -0xc(%ebp)
  80188f:	e8 51 ff ff ff       	call   8017e5 <fd_close>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	eb ec                	jmp    801885 <close+0x19>

00801899 <close_all>:

void
close_all(void)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
  80189d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	53                   	push   %ebx
  8018a9:	e8 be ff ff ff       	call   80186c <close>
	for (i = 0; i < MAXFD; i++)
  8018ae:	83 c3 01             	add    $0x1,%ebx
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	83 fb 20             	cmp    $0x20,%ebx
  8018b7:	75 ec                	jne    8018a5 <close_all+0xc>
}
  8018b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	57                   	push   %edi
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ca:	50                   	push   %eax
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	e8 67 fe ff ff       	call   80173a <fd_lookup>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	0f 88 81 00 00 00    	js     801961 <dup+0xa3>
		return r;
	close(newfdnum);
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	e8 81 ff ff ff       	call   80186c <close>

	newfd = INDEX2FD(newfdnum);
  8018eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018ee:	c1 e6 0c             	shl    $0xc,%esi
  8018f1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018f7:	83 c4 04             	add    $0x4,%esp
  8018fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018fd:	e8 cf fd ff ff       	call   8016d1 <fd2data>
  801902:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801904:	89 34 24             	mov    %esi,(%esp)
  801907:	e8 c5 fd ff ff       	call   8016d1 <fd2data>
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801911:	89 d8                	mov    %ebx,%eax
  801913:	c1 e8 16             	shr    $0x16,%eax
  801916:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80191d:	a8 01                	test   $0x1,%al
  80191f:	74 11                	je     801932 <dup+0x74>
  801921:	89 d8                	mov    %ebx,%eax
  801923:	c1 e8 0c             	shr    $0xc,%eax
  801926:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80192d:	f6 c2 01             	test   $0x1,%dl
  801930:	75 39                	jne    80196b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801932:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801935:	89 d0                	mov    %edx,%eax
  801937:	c1 e8 0c             	shr    $0xc,%eax
  80193a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	25 07 0e 00 00       	and    $0xe07,%eax
  801949:	50                   	push   %eax
  80194a:	56                   	push   %esi
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	6a 00                	push   $0x0
  801950:	e8 25 fa ff ff       	call   80137a <sys_page_map>
  801955:	89 c3                	mov    %eax,%ebx
  801957:	83 c4 20             	add    $0x20,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 31                	js     80198f <dup+0xd1>
		goto err;

	return newfdnum;
  80195e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801961:	89 d8                	mov    %ebx,%eax
  801963:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5f                   	pop    %edi
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80196b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	25 07 0e 00 00       	and    $0xe07,%eax
  80197a:	50                   	push   %eax
  80197b:	57                   	push   %edi
  80197c:	6a 00                	push   $0x0
  80197e:	53                   	push   %ebx
  80197f:	6a 00                	push   $0x0
  801981:	e8 f4 f9 ff ff       	call   80137a <sys_page_map>
  801986:	89 c3                	mov    %eax,%ebx
  801988:	83 c4 20             	add    $0x20,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	79 a3                	jns    801932 <dup+0x74>
	sys_page_unmap(0, newfd);
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	56                   	push   %esi
  801993:	6a 00                	push   $0x0
  801995:	e8 22 fa ff ff       	call   8013bc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80199a:	83 c4 08             	add    $0x8,%esp
  80199d:	57                   	push   %edi
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 17 fa ff ff       	call   8013bc <sys_page_unmap>
	return r;
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	eb b7                	jmp    801961 <dup+0xa3>

008019aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	53                   	push   %ebx
  8019ae:	83 ec 1c             	sub    $0x1c,%esp
  8019b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	53                   	push   %ebx
  8019b9:	e8 7c fd ff ff       	call   80173a <fd_lookup>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 3f                	js     801a04 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cf:	ff 30                	pushl  (%eax)
  8019d1:	e8 b4 fd ff ff       	call   80178a <dev_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 27                	js     801a04 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e0:	8b 42 08             	mov    0x8(%edx),%eax
  8019e3:	83 e0 03             	and    $0x3,%eax
  8019e6:	83 f8 01             	cmp    $0x1,%eax
  8019e9:	74 1e                	je     801a09 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	8b 40 08             	mov    0x8(%eax),%eax
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	74 35                	je     801a2a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	52                   	push   %edx
  8019ff:	ff d0                	call   *%eax
  801a01:	83 c4 10             	add    $0x10,%esp
}
  801a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a09:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801a0e:	8b 40 48             	mov    0x48(%eax),%eax
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	53                   	push   %ebx
  801a15:	50                   	push   %eax
  801a16:	68 d0 31 80 00       	push   $0x8031d0
  801a1b:	e8 c6 ed ff ff       	call   8007e6 <cprintf>
		return -E_INVAL;
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a28:	eb da                	jmp    801a04 <read+0x5a>
		return -E_NOT_SUPP;
  801a2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2f:	eb d3                	jmp    801a04 <read+0x5a>

00801a31 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	57                   	push   %edi
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a3d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a45:	39 f3                	cmp    %esi,%ebx
  801a47:	73 23                	jae    801a6c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	89 f0                	mov    %esi,%eax
  801a4e:	29 d8                	sub    %ebx,%eax
  801a50:	50                   	push   %eax
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	03 45 0c             	add    0xc(%ebp),%eax
  801a56:	50                   	push   %eax
  801a57:	57                   	push   %edi
  801a58:	e8 4d ff ff ff       	call   8019aa <read>
		if (m < 0)
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 06                	js     801a6a <readn+0x39>
			return m;
		if (m == 0)
  801a64:	74 06                	je     801a6c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a66:	01 c3                	add    %eax,%ebx
  801a68:	eb db                	jmp    801a45 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a6a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a6c:	89 d8                	mov    %ebx,%eax
  801a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a71:	5b                   	pop    %ebx
  801a72:	5e                   	pop    %esi
  801a73:	5f                   	pop    %edi
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 1c             	sub    $0x1c,%esp
  801a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a83:	50                   	push   %eax
  801a84:	53                   	push   %ebx
  801a85:	e8 b0 fc ff ff       	call   80173a <fd_lookup>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	78 3a                	js     801acb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a97:	50                   	push   %eax
  801a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9b:	ff 30                	pushl  (%eax)
  801a9d:	e8 e8 fc ff ff       	call   80178a <dev_lookup>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 22                	js     801acb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab0:	74 1e                	je     801ad0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab5:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab8:	85 d2                	test   %edx,%edx
  801aba:	74 35                	je     801af1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	ff 75 10             	pushl  0x10(%ebp)
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	ff d2                	call   *%edx
  801ac8:	83 c4 10             	add    $0x10,%esp
}
  801acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801ad5:	8b 40 48             	mov    0x48(%eax),%eax
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	53                   	push   %ebx
  801adc:	50                   	push   %eax
  801add:	68 ec 31 80 00       	push   $0x8031ec
  801ae2:	e8 ff ec ff ff       	call   8007e6 <cprintf>
		return -E_INVAL;
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aef:	eb da                	jmp    801acb <write+0x55>
		return -E_NOT_SUPP;
  801af1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af6:	eb d3                	jmp    801acb <write+0x55>

00801af8 <seek>:

int
seek(int fdnum, off_t offset)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801afe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b01:	50                   	push   %eax
  801b02:	ff 75 08             	pushl  0x8(%ebp)
  801b05:	e8 30 fc ff ff       	call   80173a <fd_lookup>
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 0e                	js     801b1f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
  801b25:	83 ec 1c             	sub    $0x1c,%esp
  801b28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2e:	50                   	push   %eax
  801b2f:	53                   	push   %ebx
  801b30:	e8 05 fc ff ff       	call   80173a <fd_lookup>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 37                	js     801b73 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b42:	50                   	push   %eax
  801b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b46:	ff 30                	pushl  (%eax)
  801b48:	e8 3d fc ff ff       	call   80178a <dev_lookup>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 1f                	js     801b73 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b57:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b5b:	74 1b                	je     801b78 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b60:	8b 52 18             	mov    0x18(%edx),%edx
  801b63:	85 d2                	test   %edx,%edx
  801b65:	74 32                	je     801b99 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	50                   	push   %eax
  801b6e:	ff d2                	call   *%edx
  801b70:	83 c4 10             	add    $0x10,%esp
}
  801b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b78:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b7d:	8b 40 48             	mov    0x48(%eax),%eax
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	53                   	push   %ebx
  801b84:	50                   	push   %eax
  801b85:	68 ac 31 80 00       	push   $0x8031ac
  801b8a:	e8 57 ec ff ff       	call   8007e6 <cprintf>
		return -E_INVAL;
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b97:	eb da                	jmp    801b73 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b9e:	eb d3                	jmp    801b73 <ftruncate+0x52>

00801ba0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 1c             	sub    $0x1c,%esp
  801ba7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801baa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	e8 84 fb ff ff       	call   80173a <fd_lookup>
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 4b                	js     801c08 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbd:	83 ec 08             	sub    $0x8,%esp
  801bc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc3:	50                   	push   %eax
  801bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc7:	ff 30                	pushl  (%eax)
  801bc9:	e8 bc fb ff ff       	call   80178a <dev_lookup>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 33                	js     801c08 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bdc:	74 2f                	je     801c0d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bde:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801be1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801be8:	00 00 00 
	stat->st_isdir = 0;
  801beb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf2:	00 00 00 
	stat->st_dev = dev;
  801bf5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	53                   	push   %ebx
  801bff:	ff 75 f0             	pushl  -0x10(%ebp)
  801c02:	ff 50 14             	call   *0x14(%eax)
  801c05:	83 c4 10             	add    $0x10,%esp
}
  801c08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    
		return -E_NOT_SUPP;
  801c0d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c12:	eb f4                	jmp    801c08 <fstat+0x68>

00801c14 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	56                   	push   %esi
  801c18:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c19:	83 ec 08             	sub    $0x8,%esp
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 22 02 00 00       	call   801e48 <open>
  801c26:	89 c3                	mov    %eax,%ebx
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 1b                	js     801c4a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c2f:	83 ec 08             	sub    $0x8,%esp
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	50                   	push   %eax
  801c36:	e8 65 ff ff ff       	call   801ba0 <fstat>
  801c3b:	89 c6                	mov    %eax,%esi
	close(fd);
  801c3d:	89 1c 24             	mov    %ebx,(%esp)
  801c40:	e8 27 fc ff ff       	call   80186c <close>
	return r;
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	89 f3                	mov    %esi,%ebx
}
  801c4a:	89 d8                	mov    %ebx,%eax
  801c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    

00801c53 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	89 c6                	mov    %eax,%esi
  801c5a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c5c:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801c63:	74 27                	je     801c8c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c65:	6a 07                	push   $0x7
  801c67:	68 00 60 80 00       	push   $0x806000
  801c6c:	56                   	push   %esi
  801c6d:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801c73:	e8 08 0c 00 00       	call   802880 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c78:	83 c4 0c             	add    $0xc,%esp
  801c7b:	6a 00                	push   $0x0
  801c7d:	53                   	push   %ebx
  801c7e:	6a 00                	push   $0x0
  801c80:	e8 92 0b 00 00       	call   802817 <ipc_recv>
}
  801c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c8c:	83 ec 0c             	sub    $0xc,%esp
  801c8f:	6a 01                	push   $0x1
  801c91:	e8 42 0c 00 00       	call   8028d8 <ipc_find_env>
  801c96:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	eb c5                	jmp    801c65 <fsipc+0x12>

00801ca0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cac:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbe:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc3:	e8 8b ff ff ff       	call   801c53 <fsipc>
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <devfile_flush>:
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce0:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce5:	e8 69 ff ff ff       	call   801c53 <fsipc>
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <devfile_stat>:
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfc:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d01:	ba 00 00 00 00       	mov    $0x0,%edx
  801d06:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0b:	e8 43 ff ff ff       	call   801c53 <fsipc>
  801d10:	85 c0                	test   %eax,%eax
  801d12:	78 2c                	js     801d40 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	68 00 60 80 00       	push   $0x806000
  801d1c:	53                   	push   %ebx
  801d1d:	e8 23 f2 ff ff       	call   800f45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d22:	a1 80 60 80 00       	mov    0x806080,%eax
  801d27:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d2d:	a1 84 60 80 00       	mov    0x806084,%eax
  801d32:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <devfile_write>:
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 08             	sub    $0x8,%esp
  801d4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d5a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d60:	53                   	push   %ebx
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	68 08 60 80 00       	push   $0x806008
  801d69:	e8 c7 f3 ff ff       	call   801135 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d73:	b8 04 00 00 00       	mov    $0x4,%eax
  801d78:	e8 d6 fe ff ff       	call   801c53 <fsipc>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 0b                	js     801d8f <devfile_write+0x4a>
	assert(r <= n);
  801d84:	39 d8                	cmp    %ebx,%eax
  801d86:	77 0c                	ja     801d94 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d8d:	7f 1e                	jg     801dad <devfile_write+0x68>
}
  801d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    
	assert(r <= n);
  801d94:	68 20 32 80 00       	push   $0x803220
  801d99:	68 27 32 80 00       	push   $0x803227
  801d9e:	68 98 00 00 00       	push   $0x98
  801da3:	68 3c 32 80 00       	push   $0x80323c
  801da8:	e8 43 e9 ff ff       	call   8006f0 <_panic>
	assert(r <= PGSIZE);
  801dad:	68 47 32 80 00       	push   $0x803247
  801db2:	68 27 32 80 00       	push   $0x803227
  801db7:	68 99 00 00 00       	push   $0x99
  801dbc:	68 3c 32 80 00       	push   $0x80323c
  801dc1:	e8 2a e9 ff ff       	call   8006f0 <_panic>

00801dc6 <devfile_read>:
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dd9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  801de4:	b8 03 00 00 00       	mov    $0x3,%eax
  801de9:	e8 65 fe ff ff       	call   801c53 <fsipc>
  801dee:	89 c3                	mov    %eax,%ebx
  801df0:	85 c0                	test   %eax,%eax
  801df2:	78 1f                	js     801e13 <devfile_read+0x4d>
	assert(r <= n);
  801df4:	39 f0                	cmp    %esi,%eax
  801df6:	77 24                	ja     801e1c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801df8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dfd:	7f 33                	jg     801e32 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dff:	83 ec 04             	sub    $0x4,%esp
  801e02:	50                   	push   %eax
  801e03:	68 00 60 80 00       	push   $0x806000
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	e8 c3 f2 ff ff       	call   8010d3 <memmove>
	return r;
  801e10:	83 c4 10             	add    $0x10,%esp
}
  801e13:	89 d8                	mov    %ebx,%eax
  801e15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5e                   	pop    %esi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
	assert(r <= n);
  801e1c:	68 20 32 80 00       	push   $0x803220
  801e21:	68 27 32 80 00       	push   $0x803227
  801e26:	6a 7c                	push   $0x7c
  801e28:	68 3c 32 80 00       	push   $0x80323c
  801e2d:	e8 be e8 ff ff       	call   8006f0 <_panic>
	assert(r <= PGSIZE);
  801e32:	68 47 32 80 00       	push   $0x803247
  801e37:	68 27 32 80 00       	push   $0x803227
  801e3c:	6a 7d                	push   $0x7d
  801e3e:	68 3c 32 80 00       	push   $0x80323c
  801e43:	e8 a8 e8 ff ff       	call   8006f0 <_panic>

00801e48 <open>:
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
  801e4d:	83 ec 1c             	sub    $0x1c,%esp
  801e50:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e53:	56                   	push   %esi
  801e54:	e8 b3 f0 ff ff       	call   800f0c <strlen>
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e61:	7f 6c                	jg     801ecf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e69:	50                   	push   %eax
  801e6a:	e8 79 f8 ff ff       	call   8016e8 <fd_alloc>
  801e6f:	89 c3                	mov    %eax,%ebx
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 3c                	js     801eb4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	56                   	push   %esi
  801e7c:	68 00 60 80 00       	push   $0x806000
  801e81:	e8 bf f0 ff ff       	call   800f45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e89:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e91:	b8 01 00 00 00       	mov    $0x1,%eax
  801e96:	e8 b8 fd ff ff       	call   801c53 <fsipc>
  801e9b:	89 c3                	mov    %eax,%ebx
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 19                	js     801ebd <open+0x75>
	return fd2num(fd);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaa:	e8 12 f8 ff ff       	call   8016c1 <fd2num>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	83 c4 10             	add    $0x10,%esp
}
  801eb4:	89 d8                	mov    %ebx,%eax
  801eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb9:	5b                   	pop    %ebx
  801eba:	5e                   	pop    %esi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    
		fd_close(fd, 0);
  801ebd:	83 ec 08             	sub    $0x8,%esp
  801ec0:	6a 00                	push   $0x0
  801ec2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec5:	e8 1b f9 ff ff       	call   8017e5 <fd_close>
		return r;
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	eb e5                	jmp    801eb4 <open+0x6c>
		return -E_BAD_PATH;
  801ecf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ed4:	eb de                	jmp    801eb4 <open+0x6c>

00801ed6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801edc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee6:	e8 68 fd ff ff       	call   801c53 <fsipc>
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef3:	68 53 32 80 00       	push   $0x803253
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	e8 45 f0 ff ff       	call   800f45 <strcpy>
	return 0;
}
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <devsock_close>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	53                   	push   %ebx
  801f0b:	83 ec 10             	sub    $0x10,%esp
  801f0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f11:	53                   	push   %ebx
  801f12:	e8 00 0a 00 00       	call   802917 <pageref>
  801f17:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f1a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f1f:	83 f8 01             	cmp    $0x1,%eax
  801f22:	74 07                	je     801f2b <devsock_close+0x24>
}
  801f24:	89 d0                	mov    %edx,%eax
  801f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 73 0c             	pushl  0xc(%ebx)
  801f31:	e8 b9 02 00 00       	call   8021ef <nsipc_close>
  801f36:	89 c2                	mov    %eax,%edx
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	eb e7                	jmp    801f24 <devsock_close+0x1d>

00801f3d <devsock_write>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	ff 75 10             	pushl  0x10(%ebp)
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	ff 70 0c             	pushl  0xc(%eax)
  801f51:	e8 76 03 00 00       	call   8022cc <nsipc_send>
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <devsock_read>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	ff 75 10             	pushl  0x10(%ebp)
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	ff 70 0c             	pushl  0xc(%eax)
  801f6c:	e8 ef 02 00 00       	call   802260 <nsipc_recv>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <fd2sockid>:
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f79:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	e8 b7 f7 ff ff       	call   80173a <fd_lookup>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 10                	js     801f9a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f93:	39 08                	cmp    %ecx,(%eax)
  801f95:	75 05                	jne    801f9c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    
		return -E_NOT_SUPP;
  801f9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fa1:	eb f7                	jmp    801f9a <fd2sockid+0x27>

00801fa3 <alloc_sockfd>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 1c             	sub    $0x1c,%esp
  801fab:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb0:	50                   	push   %eax
  801fb1:	e8 32 f7 ff ff       	call   8016e8 <fd_alloc>
  801fb6:	89 c3                	mov    %eax,%ebx
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 43                	js     802002 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	68 07 04 00 00       	push   $0x407
  801fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 66 f3 ff ff       	call   801337 <sys_page_alloc>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 28                	js     802002 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fef:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	50                   	push   %eax
  801ff6:	e8 c6 f6 ff ff       	call   8016c1 <fd2num>
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	eb 0c                	jmp    80200e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	56                   	push   %esi
  802006:	e8 e4 01 00 00       	call   8021ef <nsipc_close>
		return r;
  80200b:	83 c4 10             	add    $0x10,%esp
}
  80200e:	89 d8                	mov    %ebx,%eax
  802010:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5d                   	pop    %ebp
  802016:	c3                   	ret    

00802017 <accept>:
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	e8 4e ff ff ff       	call   801f73 <fd2sockid>
  802025:	85 c0                	test   %eax,%eax
  802027:	78 1b                	js     802044 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	ff 75 10             	pushl  0x10(%ebp)
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	50                   	push   %eax
  802033:	e8 0e 01 00 00       	call   802146 <nsipc_accept>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 05                	js     802044 <accept+0x2d>
	return alloc_sockfd(r);
  80203f:	e8 5f ff ff ff       	call   801fa3 <alloc_sockfd>
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <bind>:
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	e8 1f ff ff ff       	call   801f73 <fd2sockid>
  802054:	85 c0                	test   %eax,%eax
  802056:	78 12                	js     80206a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	ff 75 10             	pushl  0x10(%ebp)
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	50                   	push   %eax
  802062:	e8 31 01 00 00       	call   802198 <nsipc_bind>
  802067:	83 c4 10             	add    $0x10,%esp
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <shutdown>:
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	e8 f9 fe ff ff       	call   801f73 <fd2sockid>
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 0f                	js     80208d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80207e:	83 ec 08             	sub    $0x8,%esp
  802081:	ff 75 0c             	pushl  0xc(%ebp)
  802084:	50                   	push   %eax
  802085:	e8 43 01 00 00       	call   8021cd <nsipc_shutdown>
  80208a:	83 c4 10             	add    $0x10,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <connect>:
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	e8 d6 fe ff ff       	call   801f73 <fd2sockid>
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 12                	js     8020b3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	ff 75 10             	pushl  0x10(%ebp)
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	50                   	push   %eax
  8020ab:	e8 59 01 00 00       	call   802209 <nsipc_connect>
  8020b0:	83 c4 10             	add    $0x10,%esp
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <listen>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	e8 b0 fe ff ff       	call   801f73 <fd2sockid>
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 0f                	js     8020d6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	e8 6b 01 00 00       	call   80223e <nsipc_listen>
  8020d3:	83 c4 10             	add    $0x10,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020de:	ff 75 10             	pushl  0x10(%ebp)
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	e8 3e 02 00 00       	call   80232a <nsipc_socket>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 05                	js     8020f8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f3:	e8 ab fe ff ff       	call   801fa3 <alloc_sockfd>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	53                   	push   %ebx
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802103:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  80210a:	74 26                	je     802132 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80210c:	6a 07                	push   $0x7
  80210e:	68 00 70 80 00       	push   $0x807000
  802113:	53                   	push   %ebx
  802114:	ff 35 b0 50 80 00    	pushl  0x8050b0
  80211a:	e8 61 07 00 00       	call   802880 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80211f:	83 c4 0c             	add    $0xc,%esp
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	e8 ea 06 00 00       	call   802817 <ipc_recv>
}
  80212d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802130:	c9                   	leave  
  802131:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802132:	83 ec 0c             	sub    $0xc,%esp
  802135:	6a 02                	push   $0x2
  802137:	e8 9c 07 00 00       	call   8028d8 <ipc_find_env>
  80213c:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	eb c6                	jmp    80210c <nsipc+0x12>

00802146 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	56                   	push   %esi
  80214a:	53                   	push   %ebx
  80214b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802156:	8b 06                	mov    (%esi),%eax
  802158:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215d:	b8 01 00 00 00       	mov    $0x1,%eax
  802162:	e8 93 ff ff ff       	call   8020fa <nsipc>
  802167:	89 c3                	mov    %eax,%ebx
  802169:	85 c0                	test   %eax,%eax
  80216b:	79 09                	jns    802176 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80216d:	89 d8                	mov    %ebx,%eax
  80216f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802172:	5b                   	pop    %ebx
  802173:	5e                   	pop    %esi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	ff 35 10 70 80 00    	pushl  0x807010
  80217f:	68 00 70 80 00       	push   $0x807000
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	e8 47 ef ff ff       	call   8010d3 <memmove>
		*addrlen = ret->ret_addrlen;
  80218c:	a1 10 70 80 00       	mov    0x807010,%eax
  802191:	89 06                	mov    %eax,(%esi)
  802193:	83 c4 10             	add    $0x10,%esp
	return r;
  802196:	eb d5                	jmp    80216d <nsipc_accept+0x27>

00802198 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	53                   	push   %ebx
  80219c:	83 ec 08             	sub    $0x8,%esp
  80219f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021aa:	53                   	push   %ebx
  8021ab:	ff 75 0c             	pushl  0xc(%ebp)
  8021ae:	68 04 70 80 00       	push   $0x807004
  8021b3:	e8 1b ef ff ff       	call   8010d3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021be:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c3:	e8 32 ff ff ff       	call   8020fa <nsipc>
}
  8021c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021de:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e8:	e8 0d ff ff ff       	call   8020fa <nsipc>
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <nsipc_close>:

int
nsipc_close(int s)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fd:	b8 04 00 00 00       	mov    $0x4,%eax
  802202:	e8 f3 fe ff ff       	call   8020fa <nsipc>
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	53                   	push   %ebx
  80220d:	83 ec 08             	sub    $0x8,%esp
  802210:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80221b:	53                   	push   %ebx
  80221c:	ff 75 0c             	pushl  0xc(%ebp)
  80221f:	68 04 70 80 00       	push   $0x807004
  802224:	e8 aa ee ff ff       	call   8010d3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802229:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80222f:	b8 05 00 00 00       	mov    $0x5,%eax
  802234:	e8 c1 fe ff ff       	call   8020fa <nsipc>
}
  802239:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802254:	b8 06 00 00 00       	mov    $0x6,%eax
  802259:	e8 9c fe ff ff       	call   8020fa <nsipc>
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
  802265:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802270:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802276:	8b 45 14             	mov    0x14(%ebp),%eax
  802279:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227e:	b8 07 00 00 00       	mov    $0x7,%eax
  802283:	e8 72 fe ff ff       	call   8020fa <nsipc>
  802288:	89 c3                	mov    %eax,%ebx
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 1f                	js     8022ad <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80228e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802293:	7f 21                	jg     8022b6 <nsipc_recv+0x56>
  802295:	39 c6                	cmp    %eax,%esi
  802297:	7c 1d                	jl     8022b6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	50                   	push   %eax
  80229d:	68 00 70 80 00       	push   $0x807000
  8022a2:	ff 75 0c             	pushl  0xc(%ebp)
  8022a5:	e8 29 ee ff ff       	call   8010d3 <memmove>
  8022aa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ad:	89 d8                	mov    %ebx,%eax
  8022af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b2:	5b                   	pop    %ebx
  8022b3:	5e                   	pop    %esi
  8022b4:	5d                   	pop    %ebp
  8022b5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022b6:	68 5f 32 80 00       	push   $0x80325f
  8022bb:	68 27 32 80 00       	push   $0x803227
  8022c0:	6a 62                	push   $0x62
  8022c2:	68 74 32 80 00       	push   $0x803274
  8022c7:	e8 24 e4 ff ff       	call   8006f0 <_panic>

008022cc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	53                   	push   %ebx
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022de:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e4:	7f 2e                	jg     802314 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	53                   	push   %ebx
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	68 0c 70 80 00       	push   $0x80700c
  8022f2:	e8 dc ed ff ff       	call   8010d3 <memmove>
	nsipcbuf.send.req_size = size;
  8022f7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802300:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802305:	b8 08 00 00 00       	mov    $0x8,%eax
  80230a:	e8 eb fd ff ff       	call   8020fa <nsipc>
}
  80230f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802312:	c9                   	leave  
  802313:	c3                   	ret    
	assert(size < 1600);
  802314:	68 80 32 80 00       	push   $0x803280
  802319:	68 27 32 80 00       	push   $0x803227
  80231e:	6a 6d                	push   $0x6d
  802320:	68 74 32 80 00       	push   $0x803274
  802325:	e8 c6 e3 ff ff       	call   8006f0 <_panic>

0080232a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802340:	8b 45 10             	mov    0x10(%ebp),%eax
  802343:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802348:	b8 09 00 00 00       	mov    $0x9,%eax
  80234d:	e8 a8 fd ff ff       	call   8020fa <nsipc>
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	56                   	push   %esi
  802358:	53                   	push   %ebx
  802359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	ff 75 08             	pushl  0x8(%ebp)
  802362:	e8 6a f3 ff ff       	call   8016d1 <fd2data>
  802367:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802369:	83 c4 08             	add    $0x8,%esp
  80236c:	68 8c 32 80 00       	push   $0x80328c
  802371:	53                   	push   %ebx
  802372:	e8 ce eb ff ff       	call   800f45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802377:	8b 46 04             	mov    0x4(%esi),%eax
  80237a:	2b 06                	sub    (%esi),%eax
  80237c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802382:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802389:	00 00 00 
	stat->st_dev = &devpipe;
  80238c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802393:	40 80 00 
	return 0;
}
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239e:	5b                   	pop    %ebx
  80239f:	5e                   	pop    %esi
  8023a0:	5d                   	pop    %ebp
  8023a1:	c3                   	ret    

008023a2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	53                   	push   %ebx
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ac:	53                   	push   %ebx
  8023ad:	6a 00                	push   $0x0
  8023af:	e8 08 f0 ff ff       	call   8013bc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b4:	89 1c 24             	mov    %ebx,(%esp)
  8023b7:	e8 15 f3 ff ff       	call   8016d1 <fd2data>
  8023bc:	83 c4 08             	add    $0x8,%esp
  8023bf:	50                   	push   %eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	e8 f5 ef ff ff       	call   8013bc <sys_page_unmap>
}
  8023c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <_pipeisclosed>:
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	57                   	push   %edi
  8023d0:	56                   	push   %esi
  8023d1:	53                   	push   %ebx
  8023d2:	83 ec 1c             	sub    $0x1c,%esp
  8023d5:	89 c7                	mov    %eax,%edi
  8023d7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023d9:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8023de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	57                   	push   %edi
  8023e5:	e8 2d 05 00 00       	call   802917 <pageref>
  8023ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023ed:	89 34 24             	mov    %esi,(%esp)
  8023f0:	e8 22 05 00 00       	call   802917 <pageref>
		nn = thisenv->env_runs;
  8023f5:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  8023fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023fe:	83 c4 10             	add    $0x10,%esp
  802401:	39 cb                	cmp    %ecx,%ebx
  802403:	74 1b                	je     802420 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802405:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802408:	75 cf                	jne    8023d9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80240a:	8b 42 58             	mov    0x58(%edx),%eax
  80240d:	6a 01                	push   $0x1
  80240f:	50                   	push   %eax
  802410:	53                   	push   %ebx
  802411:	68 93 32 80 00       	push   $0x803293
  802416:	e8 cb e3 ff ff       	call   8007e6 <cprintf>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	eb b9                	jmp    8023d9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802420:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802423:	0f 94 c0             	sete   %al
  802426:	0f b6 c0             	movzbl %al,%eax
}
  802429:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    

00802431 <devpipe_write>:
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	57                   	push   %edi
  802435:	56                   	push   %esi
  802436:	53                   	push   %ebx
  802437:	83 ec 28             	sub    $0x28,%esp
  80243a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80243d:	56                   	push   %esi
  80243e:	e8 8e f2 ff ff       	call   8016d1 <fd2data>
  802443:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	bf 00 00 00 00       	mov    $0x0,%edi
  80244d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802450:	74 4f                	je     8024a1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802452:	8b 43 04             	mov    0x4(%ebx),%eax
  802455:	8b 0b                	mov    (%ebx),%ecx
  802457:	8d 51 20             	lea    0x20(%ecx),%edx
  80245a:	39 d0                	cmp    %edx,%eax
  80245c:	72 14                	jb     802472 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80245e:	89 da                	mov    %ebx,%edx
  802460:	89 f0                	mov    %esi,%eax
  802462:	e8 65 ff ff ff       	call   8023cc <_pipeisclosed>
  802467:	85 c0                	test   %eax,%eax
  802469:	75 3b                	jne    8024a6 <devpipe_write+0x75>
			sys_yield();
  80246b:	e8 a8 ee ff ff       	call   801318 <sys_yield>
  802470:	eb e0                	jmp    802452 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802472:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802475:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802479:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80247c:	89 c2                	mov    %eax,%edx
  80247e:	c1 fa 1f             	sar    $0x1f,%edx
  802481:	89 d1                	mov    %edx,%ecx
  802483:	c1 e9 1b             	shr    $0x1b,%ecx
  802486:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802489:	83 e2 1f             	and    $0x1f,%edx
  80248c:	29 ca                	sub    %ecx,%edx
  80248e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802492:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802496:	83 c0 01             	add    $0x1,%eax
  802499:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80249c:	83 c7 01             	add    $0x1,%edi
  80249f:	eb ac                	jmp    80244d <devpipe_write+0x1c>
	return i;
  8024a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a4:	eb 05                	jmp    8024ab <devpipe_write+0x7a>
				return 0;
  8024a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    

008024b3 <devpipe_read>:
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	57                   	push   %edi
  8024b7:	56                   	push   %esi
  8024b8:	53                   	push   %ebx
  8024b9:	83 ec 18             	sub    $0x18,%esp
  8024bc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024bf:	57                   	push   %edi
  8024c0:	e8 0c f2 ff ff       	call   8016d1 <fd2data>
  8024c5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	be 00 00 00 00       	mov    $0x0,%esi
  8024cf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d2:	75 14                	jne    8024e8 <devpipe_read+0x35>
	return i;
  8024d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d7:	eb 02                	jmp    8024db <devpipe_read+0x28>
				return i;
  8024d9:	89 f0                	mov    %esi,%eax
}
  8024db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024de:	5b                   	pop    %ebx
  8024df:	5e                   	pop    %esi
  8024e0:	5f                   	pop    %edi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    
			sys_yield();
  8024e3:	e8 30 ee ff ff       	call   801318 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024e8:	8b 03                	mov    (%ebx),%eax
  8024ea:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024ed:	75 18                	jne    802507 <devpipe_read+0x54>
			if (i > 0)
  8024ef:	85 f6                	test   %esi,%esi
  8024f1:	75 e6                	jne    8024d9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024f3:	89 da                	mov    %ebx,%edx
  8024f5:	89 f8                	mov    %edi,%eax
  8024f7:	e8 d0 fe ff ff       	call   8023cc <_pipeisclosed>
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 e3                	je     8024e3 <devpipe_read+0x30>
				return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
  802505:	eb d4                	jmp    8024db <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802507:	99                   	cltd   
  802508:	c1 ea 1b             	shr    $0x1b,%edx
  80250b:	01 d0                	add    %edx,%eax
  80250d:	83 e0 1f             	and    $0x1f,%eax
  802510:	29 d0                	sub    %edx,%eax
  802512:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80251d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802520:	83 c6 01             	add    $0x1,%esi
  802523:	eb aa                	jmp    8024cf <devpipe_read+0x1c>

00802525 <pipe>:
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	56                   	push   %esi
  802529:	53                   	push   %ebx
  80252a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80252d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	e8 b2 f1 ff ff       	call   8016e8 <fd_alloc>
  802536:	89 c3                	mov    %eax,%ebx
  802538:	83 c4 10             	add    $0x10,%esp
  80253b:	85 c0                	test   %eax,%eax
  80253d:	0f 88 23 01 00 00    	js     802666 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 07 04 00 00       	push   $0x407
  80254b:	ff 75 f4             	pushl  -0xc(%ebp)
  80254e:	6a 00                	push   $0x0
  802550:	e8 e2 ed ff ff       	call   801337 <sys_page_alloc>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 88 04 01 00 00    	js     802666 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802568:	50                   	push   %eax
  802569:	e8 7a f1 ff ff       	call   8016e8 <fd_alloc>
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	83 c4 10             	add    $0x10,%esp
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 88 db 00 00 00    	js     802656 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 07 04 00 00       	push   $0x407
  802583:	ff 75 f0             	pushl  -0x10(%ebp)
  802586:	6a 00                	push   $0x0
  802588:	e8 aa ed ff ff       	call   801337 <sys_page_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 bc 00 00 00    	js     802656 <pipe+0x131>
	va = fd2data(fd0);
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a0:	e8 2c f1 ff ff       	call   8016d1 <fd2data>
  8025a5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a7:	83 c4 0c             	add    $0xc,%esp
  8025aa:	68 07 04 00 00       	push   $0x407
  8025af:	50                   	push   %eax
  8025b0:	6a 00                	push   $0x0
  8025b2:	e8 80 ed ff ff       	call   801337 <sys_page_alloc>
  8025b7:	89 c3                	mov    %eax,%ebx
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	0f 88 82 00 00 00    	js     802646 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ca:	e8 02 f1 ff ff       	call   8016d1 <fd2data>
  8025cf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025d6:	50                   	push   %eax
  8025d7:	6a 00                	push   $0x0
  8025d9:	56                   	push   %esi
  8025da:	6a 00                	push   $0x0
  8025dc:	e8 99 ed ff ff       	call   80137a <sys_page_map>
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	83 c4 20             	add    $0x20,%esp
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	78 4e                	js     802638 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025ea:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802601:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	ff 75 f4             	pushl  -0xc(%ebp)
  802613:	e8 a9 f0 ff ff       	call   8016c1 <fd2num>
  802618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80261d:	83 c4 04             	add    $0x4,%esp
  802620:	ff 75 f0             	pushl  -0x10(%ebp)
  802623:	e8 99 f0 ff ff       	call   8016c1 <fd2num>
  802628:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80262e:	83 c4 10             	add    $0x10,%esp
  802631:	bb 00 00 00 00       	mov    $0x0,%ebx
  802636:	eb 2e                	jmp    802666 <pipe+0x141>
	sys_page_unmap(0, va);
  802638:	83 ec 08             	sub    $0x8,%esp
  80263b:	56                   	push   %esi
  80263c:	6a 00                	push   $0x0
  80263e:	e8 79 ed ff ff       	call   8013bc <sys_page_unmap>
  802643:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802646:	83 ec 08             	sub    $0x8,%esp
  802649:	ff 75 f0             	pushl  -0x10(%ebp)
  80264c:	6a 00                	push   $0x0
  80264e:	e8 69 ed ff ff       	call   8013bc <sys_page_unmap>
  802653:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802656:	83 ec 08             	sub    $0x8,%esp
  802659:	ff 75 f4             	pushl  -0xc(%ebp)
  80265c:	6a 00                	push   $0x0
  80265e:	e8 59 ed ff ff       	call   8013bc <sys_page_unmap>
  802663:	83 c4 10             	add    $0x10,%esp
}
  802666:	89 d8                	mov    %ebx,%eax
  802668:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80266b:	5b                   	pop    %ebx
  80266c:	5e                   	pop    %esi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    

0080266f <pipeisclosed>:
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802675:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802678:	50                   	push   %eax
  802679:	ff 75 08             	pushl  0x8(%ebp)
  80267c:	e8 b9 f0 ff ff       	call   80173a <fd_lookup>
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	85 c0                	test   %eax,%eax
  802686:	78 18                	js     8026a0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	ff 75 f4             	pushl  -0xc(%ebp)
  80268e:	e8 3e f0 ff ff       	call   8016d1 <fd2data>
	return _pipeisclosed(fd, p);
  802693:	89 c2                	mov    %eax,%edx
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	e8 2f fd ff ff       	call   8023cc <_pipeisclosed>
  80269d:	83 c4 10             	add    $0x10,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	c3                   	ret    

008026a8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ae:	68 ab 32 80 00       	push   $0x8032ab
  8026b3:	ff 75 0c             	pushl  0xc(%ebp)
  8026b6:	e8 8a e8 ff ff       	call   800f45 <strcpy>
	return 0;
}
  8026bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <devcons_write>:
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	57                   	push   %edi
  8026c6:	56                   	push   %esi
  8026c7:	53                   	push   %ebx
  8026c8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026ce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026d3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026dc:	73 31                	jae    80270f <devcons_write+0x4d>
		m = n - tot;
  8026de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e1:	29 f3                	sub    %esi,%ebx
  8026e3:	83 fb 7f             	cmp    $0x7f,%ebx
  8026e6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026eb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026ee:	83 ec 04             	sub    $0x4,%esp
  8026f1:	53                   	push   %ebx
  8026f2:	89 f0                	mov    %esi,%eax
  8026f4:	03 45 0c             	add    0xc(%ebp),%eax
  8026f7:	50                   	push   %eax
  8026f8:	57                   	push   %edi
  8026f9:	e8 d5 e9 ff ff       	call   8010d3 <memmove>
		sys_cputs(buf, m);
  8026fe:	83 c4 08             	add    $0x8,%esp
  802701:	53                   	push   %ebx
  802702:	57                   	push   %edi
  802703:	e8 73 eb ff ff       	call   80127b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802708:	01 de                	add    %ebx,%esi
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	eb ca                	jmp    8026d9 <devcons_write+0x17>
}
  80270f:	89 f0                	mov    %esi,%eax
  802711:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802714:	5b                   	pop    %ebx
  802715:	5e                   	pop    %esi
  802716:	5f                   	pop    %edi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    

00802719 <devcons_read>:
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 08             	sub    $0x8,%esp
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802724:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802728:	74 21                	je     80274b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80272a:	e8 6a eb ff ff       	call   801299 <sys_cgetc>
  80272f:	85 c0                	test   %eax,%eax
  802731:	75 07                	jne    80273a <devcons_read+0x21>
		sys_yield();
  802733:	e8 e0 eb ff ff       	call   801318 <sys_yield>
  802738:	eb f0                	jmp    80272a <devcons_read+0x11>
	if (c < 0)
  80273a:	78 0f                	js     80274b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80273c:	83 f8 04             	cmp    $0x4,%eax
  80273f:	74 0c                	je     80274d <devcons_read+0x34>
	*(char*)vbuf = c;
  802741:	8b 55 0c             	mov    0xc(%ebp),%edx
  802744:	88 02                	mov    %al,(%edx)
	return 1;
  802746:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    
		return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	eb f7                	jmp    80274b <devcons_read+0x32>

00802754 <cputchar>:
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802760:	6a 01                	push   $0x1
  802762:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802765:	50                   	push   %eax
  802766:	e8 10 eb ff ff       	call   80127b <sys_cputs>
}
  80276b:	83 c4 10             	add    $0x10,%esp
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <getchar>:
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802776:	6a 01                	push   $0x1
  802778:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277b:	50                   	push   %eax
  80277c:	6a 00                	push   $0x0
  80277e:	e8 27 f2 ff ff       	call   8019aa <read>
	if (r < 0)
  802783:	83 c4 10             	add    $0x10,%esp
  802786:	85 c0                	test   %eax,%eax
  802788:	78 06                	js     802790 <getchar+0x20>
	if (r < 1)
  80278a:	74 06                	je     802792 <getchar+0x22>
	return c;
  80278c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    
		return -E_EOF;
  802792:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802797:	eb f7                	jmp    802790 <getchar+0x20>

00802799 <iscons>:
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a2:	50                   	push   %eax
  8027a3:	ff 75 08             	pushl  0x8(%ebp)
  8027a6:	e8 8f ef ff ff       	call   80173a <fd_lookup>
  8027ab:	83 c4 10             	add    $0x10,%esp
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	78 11                	js     8027c3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027bb:	39 10                	cmp    %edx,(%eax)
  8027bd:	0f 94 c0             	sete   %al
  8027c0:	0f b6 c0             	movzbl %al,%eax
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <opencons>:
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ce:	50                   	push   %eax
  8027cf:	e8 14 ef ff ff       	call   8016e8 <fd_alloc>
  8027d4:	83 c4 10             	add    $0x10,%esp
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	78 3a                	js     802815 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	68 07 04 00 00       	push   $0x407
  8027e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e6:	6a 00                	push   $0x0
  8027e8:	e8 4a eb ff ff       	call   801337 <sys_page_alloc>
  8027ed:	83 c4 10             	add    $0x10,%esp
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	78 21                	js     802815 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027fd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	50                   	push   %eax
  80280d:	e8 af ee ff ff       	call   8016c1 <fd2num>
  802812:	83 c4 10             	add    $0x10,%esp
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	56                   	push   %esi
  80281b:	53                   	push   %ebx
  80281c:	8b 75 08             	mov    0x8(%ebp),%esi
  80281f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802822:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802825:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802827:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80282c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80282f:	83 ec 0c             	sub    $0xc,%esp
  802832:	50                   	push   %eax
  802833:	e8 af ec ff ff       	call   8014e7 <sys_ipc_recv>
	if(ret < 0){
  802838:	83 c4 10             	add    $0x10,%esp
  80283b:	85 c0                	test   %eax,%eax
  80283d:	78 2b                	js     80286a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80283f:	85 f6                	test   %esi,%esi
  802841:	74 0a                	je     80284d <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802843:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802848:	8b 40 78             	mov    0x78(%eax),%eax
  80284b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80284d:	85 db                	test   %ebx,%ebx
  80284f:	74 0a                	je     80285b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802851:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802856:	8b 40 7c             	mov    0x7c(%eax),%eax
  802859:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80285b:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802860:	8b 40 74             	mov    0x74(%eax),%eax
}
  802863:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802866:	5b                   	pop    %ebx
  802867:	5e                   	pop    %esi
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    
		if(from_env_store)
  80286a:	85 f6                	test   %esi,%esi
  80286c:	74 06                	je     802874 <ipc_recv+0x5d>
			*from_env_store = 0;
  80286e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802874:	85 db                	test   %ebx,%ebx
  802876:	74 eb                	je     802863 <ipc_recv+0x4c>
			*perm_store = 0;
  802878:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80287e:	eb e3                	jmp    802863 <ipc_recv+0x4c>

00802880 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	57                   	push   %edi
  802884:	56                   	push   %esi
  802885:	53                   	push   %ebx
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	8b 7d 08             	mov    0x8(%ebp),%edi
  80288c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80288f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802892:	85 db                	test   %ebx,%ebx
  802894:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802899:	0f 44 d8             	cmove  %eax,%ebx
  80289c:	eb 05                	jmp    8028a3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80289e:	e8 75 ea ff ff       	call   801318 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028a3:	ff 75 14             	pushl  0x14(%ebp)
  8028a6:	53                   	push   %ebx
  8028a7:	56                   	push   %esi
  8028a8:	57                   	push   %edi
  8028a9:	e8 16 ec ff ff       	call   8014c4 <sys_ipc_try_send>
  8028ae:	83 c4 10             	add    $0x10,%esp
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 1b                	je     8028d0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028b5:	79 e7                	jns    80289e <ipc_send+0x1e>
  8028b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028ba:	74 e2                	je     80289e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	68 b7 32 80 00       	push   $0x8032b7
  8028c4:	6a 46                	push   $0x46
  8028c6:	68 cc 32 80 00       	push   $0x8032cc
  8028cb:	e8 20 de ff ff       	call   8006f0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d3:	5b                   	pop    %ebx
  8028d4:	5e                   	pop    %esi
  8028d5:	5f                   	pop    %edi
  8028d6:	5d                   	pop    %ebp
  8028d7:	c3                   	ret    

008028d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028d8:	55                   	push   %ebp
  8028d9:	89 e5                	mov    %esp,%ebp
  8028db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028e3:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8028e9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028ef:	8b 52 50             	mov    0x50(%edx),%edx
  8028f2:	39 ca                	cmp    %ecx,%edx
  8028f4:	74 11                	je     802907 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8028f6:	83 c0 01             	add    $0x1,%eax
  8028f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028fe:	75 e3                	jne    8028e3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
  802905:	eb 0e                	jmp    802915 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802907:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80290d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802912:	8b 40 48             	mov    0x48(%eax),%eax
}
  802915:	5d                   	pop    %ebp
  802916:	c3                   	ret    

00802917 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
  80291a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80291d:	89 d0                	mov    %edx,%eax
  80291f:	c1 e8 16             	shr    $0x16,%eax
  802922:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80292e:	f6 c1 01             	test   $0x1,%cl
  802931:	74 1d                	je     802950 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802933:	c1 ea 0c             	shr    $0xc,%edx
  802936:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80293d:	f6 c2 01             	test   $0x1,%dl
  802940:	74 0e                	je     802950 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802942:	c1 ea 0c             	shr    $0xc,%edx
  802945:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80294c:	ef 
  80294d:	0f b7 c0             	movzwl %ax,%eax
}
  802950:	5d                   	pop    %ebp
  802951:	c3                   	ret    
  802952:	66 90                	xchg   %ax,%ax
  802954:	66 90                	xchg   %ax,%ax
  802956:	66 90                	xchg   %ax,%ax
  802958:	66 90                	xchg   %ax,%ax
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__udivdi3>:
  802960:	55                   	push   %ebp
  802961:	57                   	push   %edi
  802962:	56                   	push   %esi
  802963:	53                   	push   %ebx
  802964:	83 ec 1c             	sub    $0x1c,%esp
  802967:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80296b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80296f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802973:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802977:	85 d2                	test   %edx,%edx
  802979:	75 4d                	jne    8029c8 <__udivdi3+0x68>
  80297b:	39 f3                	cmp    %esi,%ebx
  80297d:	76 19                	jbe    802998 <__udivdi3+0x38>
  80297f:	31 ff                	xor    %edi,%edi
  802981:	89 e8                	mov    %ebp,%eax
  802983:	89 f2                	mov    %esi,%edx
  802985:	f7 f3                	div    %ebx
  802987:	89 fa                	mov    %edi,%edx
  802989:	83 c4 1c             	add    $0x1c,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5f                   	pop    %edi
  80298f:	5d                   	pop    %ebp
  802990:	c3                   	ret    
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	89 d9                	mov    %ebx,%ecx
  80299a:	85 db                	test   %ebx,%ebx
  80299c:	75 0b                	jne    8029a9 <__udivdi3+0x49>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	31 d2                	xor    %edx,%edx
  8029a5:	f7 f3                	div    %ebx
  8029a7:	89 c1                	mov    %eax,%ecx
  8029a9:	31 d2                	xor    %edx,%edx
  8029ab:	89 f0                	mov    %esi,%eax
  8029ad:	f7 f1                	div    %ecx
  8029af:	89 c6                	mov    %eax,%esi
  8029b1:	89 e8                	mov    %ebp,%eax
  8029b3:	89 f7                	mov    %esi,%edi
  8029b5:	f7 f1                	div    %ecx
  8029b7:	89 fa                	mov    %edi,%edx
  8029b9:	83 c4 1c             	add    $0x1c,%esp
  8029bc:	5b                   	pop    %ebx
  8029bd:	5e                   	pop    %esi
  8029be:	5f                   	pop    %edi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    
  8029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	39 f2                	cmp    %esi,%edx
  8029ca:	77 1c                	ja     8029e8 <__udivdi3+0x88>
  8029cc:	0f bd fa             	bsr    %edx,%edi
  8029cf:	83 f7 1f             	xor    $0x1f,%edi
  8029d2:	75 2c                	jne    802a00 <__udivdi3+0xa0>
  8029d4:	39 f2                	cmp    %esi,%edx
  8029d6:	72 06                	jb     8029de <__udivdi3+0x7e>
  8029d8:	31 c0                	xor    %eax,%eax
  8029da:	39 eb                	cmp    %ebp,%ebx
  8029dc:	77 a9                	ja     802987 <__udivdi3+0x27>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	eb a2                	jmp    802987 <__udivdi3+0x27>
  8029e5:	8d 76 00             	lea    0x0(%esi),%esi
  8029e8:	31 ff                	xor    %edi,%edi
  8029ea:	31 c0                	xor    %eax,%eax
  8029ec:	89 fa                	mov    %edi,%edx
  8029ee:	83 c4 1c             	add    $0x1c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
  8029f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029fd:	8d 76 00             	lea    0x0(%esi),%esi
  802a00:	89 f9                	mov    %edi,%ecx
  802a02:	b8 20 00 00 00       	mov    $0x20,%eax
  802a07:	29 f8                	sub    %edi,%eax
  802a09:	d3 e2                	shl    %cl,%edx
  802a0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a0f:	89 c1                	mov    %eax,%ecx
  802a11:	89 da                	mov    %ebx,%edx
  802a13:	d3 ea                	shr    %cl,%edx
  802a15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a19:	09 d1                	or     %edx,%ecx
  802a1b:	89 f2                	mov    %esi,%edx
  802a1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a21:	89 f9                	mov    %edi,%ecx
  802a23:	d3 e3                	shl    %cl,%ebx
  802a25:	89 c1                	mov    %eax,%ecx
  802a27:	d3 ea                	shr    %cl,%edx
  802a29:	89 f9                	mov    %edi,%ecx
  802a2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a2f:	89 eb                	mov    %ebp,%ebx
  802a31:	d3 e6                	shl    %cl,%esi
  802a33:	89 c1                	mov    %eax,%ecx
  802a35:	d3 eb                	shr    %cl,%ebx
  802a37:	09 de                	or     %ebx,%esi
  802a39:	89 f0                	mov    %esi,%eax
  802a3b:	f7 74 24 08          	divl   0x8(%esp)
  802a3f:	89 d6                	mov    %edx,%esi
  802a41:	89 c3                	mov    %eax,%ebx
  802a43:	f7 64 24 0c          	mull   0xc(%esp)
  802a47:	39 d6                	cmp    %edx,%esi
  802a49:	72 15                	jb     802a60 <__udivdi3+0x100>
  802a4b:	89 f9                	mov    %edi,%ecx
  802a4d:	d3 e5                	shl    %cl,%ebp
  802a4f:	39 c5                	cmp    %eax,%ebp
  802a51:	73 04                	jae    802a57 <__udivdi3+0xf7>
  802a53:	39 d6                	cmp    %edx,%esi
  802a55:	74 09                	je     802a60 <__udivdi3+0x100>
  802a57:	89 d8                	mov    %ebx,%eax
  802a59:	31 ff                	xor    %edi,%edi
  802a5b:	e9 27 ff ff ff       	jmp    802987 <__udivdi3+0x27>
  802a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a63:	31 ff                	xor    %edi,%edi
  802a65:	e9 1d ff ff ff       	jmp    802987 <__udivdi3+0x27>
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	66 90                	xchg   %ax,%ax
  802a6e:	66 90                	xchg   %ax,%ax

00802a70 <__umoddi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	53                   	push   %ebx
  802a74:	83 ec 1c             	sub    $0x1c,%esp
  802a77:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a87:	89 da                	mov    %ebx,%edx
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	75 43                	jne    802ad0 <__umoddi3+0x60>
  802a8d:	39 df                	cmp    %ebx,%edi
  802a8f:	76 17                	jbe    802aa8 <__umoddi3+0x38>
  802a91:	89 f0                	mov    %esi,%eax
  802a93:	f7 f7                	div    %edi
  802a95:	89 d0                	mov    %edx,%eax
  802a97:	31 d2                	xor    %edx,%edx
  802a99:	83 c4 1c             	add    $0x1c,%esp
  802a9c:	5b                   	pop    %ebx
  802a9d:	5e                   	pop    %esi
  802a9e:	5f                   	pop    %edi
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    
  802aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	89 fd                	mov    %edi,%ebp
  802aaa:	85 ff                	test   %edi,%edi
  802aac:	75 0b                	jne    802ab9 <__umoddi3+0x49>
  802aae:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab3:	31 d2                	xor    %edx,%edx
  802ab5:	f7 f7                	div    %edi
  802ab7:	89 c5                	mov    %eax,%ebp
  802ab9:	89 d8                	mov    %ebx,%eax
  802abb:	31 d2                	xor    %edx,%edx
  802abd:	f7 f5                	div    %ebp
  802abf:	89 f0                	mov    %esi,%eax
  802ac1:	f7 f5                	div    %ebp
  802ac3:	89 d0                	mov    %edx,%eax
  802ac5:	eb d0                	jmp    802a97 <__umoddi3+0x27>
  802ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ace:	66 90                	xchg   %ax,%ax
  802ad0:	89 f1                	mov    %esi,%ecx
  802ad2:	39 d8                	cmp    %ebx,%eax
  802ad4:	76 0a                	jbe    802ae0 <__umoddi3+0x70>
  802ad6:	89 f0                	mov    %esi,%eax
  802ad8:	83 c4 1c             	add    $0x1c,%esp
  802adb:	5b                   	pop    %ebx
  802adc:	5e                   	pop    %esi
  802add:	5f                   	pop    %edi
  802ade:	5d                   	pop    %ebp
  802adf:	c3                   	ret    
  802ae0:	0f bd e8             	bsr    %eax,%ebp
  802ae3:	83 f5 1f             	xor    $0x1f,%ebp
  802ae6:	75 20                	jne    802b08 <__umoddi3+0x98>
  802ae8:	39 d8                	cmp    %ebx,%eax
  802aea:	0f 82 b0 00 00 00    	jb     802ba0 <__umoddi3+0x130>
  802af0:	39 f7                	cmp    %esi,%edi
  802af2:	0f 86 a8 00 00 00    	jbe    802ba0 <__umoddi3+0x130>
  802af8:	89 c8                	mov    %ecx,%eax
  802afa:	83 c4 1c             	add    $0x1c,%esp
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5f                   	pop    %edi
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    
  802b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b0f:	29 ea                	sub    %ebp,%edx
  802b11:	d3 e0                	shl    %cl,%eax
  802b13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b17:	89 d1                	mov    %edx,%ecx
  802b19:	89 f8                	mov    %edi,%eax
  802b1b:	d3 e8                	shr    %cl,%eax
  802b1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b29:	09 c1                	or     %eax,%ecx
  802b2b:	89 d8                	mov    %ebx,%eax
  802b2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b31:	89 e9                	mov    %ebp,%ecx
  802b33:	d3 e7                	shl    %cl,%edi
  802b35:	89 d1                	mov    %edx,%ecx
  802b37:	d3 e8                	shr    %cl,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b3f:	d3 e3                	shl    %cl,%ebx
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	89 d1                	mov    %edx,%ecx
  802b45:	89 f0                	mov    %esi,%eax
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 fa                	mov    %edi,%edx
  802b4d:	d3 e6                	shl    %cl,%esi
  802b4f:	09 d8                	or     %ebx,%eax
  802b51:	f7 74 24 08          	divl   0x8(%esp)
  802b55:	89 d1                	mov    %edx,%ecx
  802b57:	89 f3                	mov    %esi,%ebx
  802b59:	f7 64 24 0c          	mull   0xc(%esp)
  802b5d:	89 c6                	mov    %eax,%esi
  802b5f:	89 d7                	mov    %edx,%edi
  802b61:	39 d1                	cmp    %edx,%ecx
  802b63:	72 06                	jb     802b6b <__umoddi3+0xfb>
  802b65:	75 10                	jne    802b77 <__umoddi3+0x107>
  802b67:	39 c3                	cmp    %eax,%ebx
  802b69:	73 0c                	jae    802b77 <__umoddi3+0x107>
  802b6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b73:	89 d7                	mov    %edx,%edi
  802b75:	89 c6                	mov    %eax,%esi
  802b77:	89 ca                	mov    %ecx,%edx
  802b79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b7e:	29 f3                	sub    %esi,%ebx
  802b80:	19 fa                	sbb    %edi,%edx
  802b82:	89 d0                	mov    %edx,%eax
  802b84:	d3 e0                	shl    %cl,%eax
  802b86:	89 e9                	mov    %ebp,%ecx
  802b88:	d3 eb                	shr    %cl,%ebx
  802b8a:	d3 ea                	shr    %cl,%edx
  802b8c:	09 d8                	or     %ebx,%eax
  802b8e:	83 c4 1c             	add    $0x1c,%esp
  802b91:	5b                   	pop    %ebx
  802b92:	5e                   	pop    %esi
  802b93:	5f                   	pop    %edi
  802b94:	5d                   	pop    %ebp
  802b95:	c3                   	ret    
  802b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	89 da                	mov    %ebx,%edx
  802ba2:	29 fe                	sub    %edi,%esi
  802ba4:	19 c2                	sbb    %eax,%edx
  802ba6:	89 f1                	mov    %esi,%ecx
  802ba8:	89 c8                	mov    %ecx,%eax
  802baa:	e9 4b ff ff ff       	jmp    802afa <__umoddi3+0x8a>
