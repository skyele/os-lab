
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 5a 00 00 00       	call   80008b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("in faultdie %s\n", __FUNCTION__);
  800039:	68 70 26 80 00       	push   $0x802670
  80003e:	68 60 26 80 00       	push   $0x802660
  800043:	e8 e7 01 00 00       	call   80022f <cprintf>
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("in %s\n", __FUNCTION__);
  800048:	83 c4 08             	add    $0x8,%esp
  80004b:	68 70 26 80 00       	push   $0x802670
  800050:	68 d4 26 80 00       	push   $0x8026d4
  800055:	e8 d5 01 00 00       	call   80022f <cprintf>
	sys_env_destroy(sys_getenvid());
  80005a:	e8 e3 0c 00 00       	call   800d42 <sys_getenvid>
  80005f:	89 04 24             	mov    %eax,(%esp)
  800062:	e8 9a 0c 00 00       	call   800d01 <sys_env_destroy>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	c9                   	leave  
  80006b:	c3                   	ret    

0080006c <umain>:

void
umain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800072:	68 33 00 80 00       	push   $0x800033
  800077:	e8 f9 0f 00 00       	call   801075 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  80007c:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800083:	00 00 00 
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	c9                   	leave  
  80008a:	c3                   	ret    

0080008b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	57                   	push   %edi
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800094:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80009b:	00 00 00 
	envid_t find = sys_getenvid();
  80009e:	e8 9f 0c 00 00       	call   800d42 <sys_getenvid>
  8000a3:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000b8:	eb 0b                	jmp    8000c5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ba:	83 c2 01             	add    $0x1,%edx
  8000bd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000c3:	74 23                	je     8000e8 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000c5:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000cb:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000d1:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000d4:	39 c1                	cmp    %eax,%ecx
  8000d6:	75 e2                	jne    8000ba <libmain+0x2f>
  8000d8:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000de:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000e4:	89 fe                	mov    %edi,%esi
  8000e6:	eb d2                	jmp    8000ba <libmain+0x2f>
  8000e8:	89 f0                	mov    %esi,%eax
  8000ea:	84 c0                	test   %al,%al
  8000ec:	74 06                	je     8000f4 <libmain+0x69>
  8000ee:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f8:	7e 0a                	jle    800104 <libmain+0x79>
		binaryname = argv[0];
  8000fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fd:	8b 00                	mov    (%eax),%eax
  8000ff:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800104:	a1 08 40 80 00       	mov    0x804008,%eax
  800109:	8b 40 48             	mov    0x48(%eax),%eax
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	50                   	push   %eax
  800110:	68 78 26 80 00       	push   $0x802678
  800115:	e8 15 01 00 00       	call   80022f <cprintf>
	cprintf("before umain\n");
  80011a:	c7 04 24 96 26 80 00 	movl   $0x802696,(%esp)
  800121:	e8 09 01 00 00       	call   80022f <cprintf>
	// call user main routine
	umain(argc, argv);
  800126:	83 c4 08             	add    $0x8,%esp
  800129:	ff 75 0c             	pushl  0xc(%ebp)
  80012c:	ff 75 08             	pushl  0x8(%ebp)
  80012f:	e8 38 ff ff ff       	call   80006c <umain>
	cprintf("after umain\n");
  800134:	c7 04 24 a4 26 80 00 	movl   $0x8026a4,(%esp)
  80013b:	e8 ef 00 00 00       	call   80022f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800140:	a1 08 40 80 00       	mov    0x804008,%eax
  800145:	8b 40 48             	mov    0x48(%eax),%eax
  800148:	83 c4 08             	add    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	68 b1 26 80 00       	push   $0x8026b1
  800151:	e8 d9 00 00 00       	call   80022f <cprintf>
	// exit gracefully
	exit();
  800156:	e8 0b 00 00 00       	call   800166 <exit>
}
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800161:	5b                   	pop    %ebx
  800162:	5e                   	pop    %esi
  800163:	5f                   	pop    %edi
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    

00800166 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80016c:	a1 08 40 80 00       	mov    0x804008,%eax
  800171:	8b 40 48             	mov    0x48(%eax),%eax
  800174:	68 dc 26 80 00       	push   $0x8026dc
  800179:	50                   	push   %eax
  80017a:	68 d0 26 80 00       	push   $0x8026d0
  80017f:	e8 ab 00 00 00       	call   80022f <cprintf>
	close_all();
  800184:	e8 59 11 00 00       	call   8012e2 <close_all>
	sys_env_destroy(0);
  800189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800190:	e8 6c 0b 00 00       	call   800d01 <sys_env_destroy>
}
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	53                   	push   %ebx
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a4:	8b 13                	mov    (%ebx),%edx
  8001a6:	8d 42 01             	lea    0x1(%edx),%eax
  8001a9:	89 03                	mov    %eax,(%ebx)
  8001ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b7:	74 09                	je     8001c2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 ff 00 00 00       	push   $0xff
  8001ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cd:	50                   	push   %eax
  8001ce:	e8 f1 0a 00 00       	call   800cc4 <sys_cputs>
		b->idx = 0;
  8001d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	eb db                	jmp    8001b9 <putch+0x1f>

008001de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ee:	00 00 00 
	b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	68 9a 01 80 00       	push   $0x80019a
  80020d:	e8 4a 01 00 00       	call   80035c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800212:	83 c4 08             	add    $0x8,%esp
  800215:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	e8 9d 0a 00 00       	call   800cc4 <sys_cputs>

	return b.cnt;
}
  800227:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800235:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800238:	50                   	push   %eax
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	e8 9d ff ff ff       	call   8001de <vcprintf>
	va_end(ap);

	return cnt;
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 1c             	sub    $0x1c,%esp
  80024c:	89 c6                	mov    %eax,%esi
  80024e:	89 d7                	mov    %edx,%edi
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
  800256:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800259:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80025c:	8b 45 10             	mov    0x10(%ebp),%eax
  80025f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800262:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800266:	74 2c                	je     800294 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800268:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80026b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800272:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800275:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800278:	39 c2                	cmp    %eax,%edx
  80027a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80027d:	73 43                	jae    8002c2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7e 6c                	jle    8002f2 <printnum+0xaf>
				putch(padc, putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	57                   	push   %edi
  80028a:	ff 75 18             	pushl  0x18(%ebp)
  80028d:	ff d6                	call   *%esi
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	eb eb                	jmp    80027f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	6a 20                	push   $0x20
  800299:	6a 00                	push   $0x0
  80029b:	50                   	push   %eax
  80029c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029f:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	e8 98 ff ff ff       	call   800243 <printnum>
		while (--width > 0)
  8002ab:	83 c4 20             	add    $0x20,%esp
  8002ae:	83 eb 01             	sub    $0x1,%ebx
  8002b1:	85 db                	test   %ebx,%ebx
  8002b3:	7e 65                	jle    80031a <printnum+0xd7>
			putch(padc, putdat);
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	57                   	push   %edi
  8002b9:	6a 20                	push   $0x20
  8002bb:	ff d6                	call   *%esi
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	eb ec                	jmp    8002ae <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	ff 75 18             	pushl  0x18(%ebp)
  8002c8:	83 eb 01             	sub    $0x1,%ebx
  8002cb:	53                   	push   %ebx
  8002cc:	50                   	push   %eax
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dc:	e8 1f 21 00 00       	call   802400 <__udivdi3>
  8002e1:	83 c4 18             	add    $0x18,%esp
  8002e4:	52                   	push   %edx
  8002e5:	50                   	push   %eax
  8002e6:	89 fa                	mov    %edi,%edx
  8002e8:	89 f0                	mov    %esi,%eax
  8002ea:	e8 54 ff ff ff       	call   800243 <printnum>
  8002ef:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	57                   	push   %edi
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800302:	ff 75 e0             	pushl  -0x20(%ebp)
  800305:	e8 06 22 00 00       	call   802510 <__umoddi3>
  80030a:	83 c4 14             	add    $0x14,%esp
  80030d:	0f be 80 e1 26 80 00 	movsbl 0x8026e1(%eax),%eax
  800314:	50                   	push   %eax
  800315:	ff d6                	call   *%esi
  800317:	83 c4 10             	add    $0x10,%esp
	}
}
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800328:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	3b 50 04             	cmp    0x4(%eax),%edx
  800331:	73 0a                	jae    80033d <sprintputch+0x1b>
		*b->buf++ = ch;
  800333:	8d 4a 01             	lea    0x1(%edx),%ecx
  800336:	89 08                	mov    %ecx,(%eax)
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	88 02                	mov    %al,(%edx)
}
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <printfmt>:
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800345:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800348:	50                   	push   %eax
  800349:	ff 75 10             	pushl  0x10(%ebp)
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 05 00 00 00       	call   80035c <vprintfmt>
}
  800357:	83 c4 10             	add    $0x10,%esp
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <vprintfmt>:
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	53                   	push   %ebx
  800362:	83 ec 3c             	sub    $0x3c,%esp
  800365:	8b 75 08             	mov    0x8(%ebp),%esi
  800368:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80036b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036e:	e9 32 04 00 00       	jmp    8007a5 <vprintfmt+0x449>
		padc = ' ';
  800373:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800377:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80037e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800385:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80038c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800393:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80039a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039f:	8d 47 01             	lea    0x1(%edi),%eax
  8003a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a5:	0f b6 17             	movzbl (%edi),%edx
  8003a8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ab:	3c 55                	cmp    $0x55,%al
  8003ad:	0f 87 12 05 00 00    	ja     8008c5 <vprintfmt+0x569>
  8003b3:	0f b6 c0             	movzbl %al,%eax
  8003b6:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003c4:	eb d9                	jmp    80039f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003cd:	eb d0                	jmp    80039f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	0f b6 d2             	movzbl %dl,%edx
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003da:	89 75 08             	mov    %esi,0x8(%ebp)
  8003dd:	eb 03                	jmp    8003e2 <vprintfmt+0x86>
  8003df:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ec:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ef:	83 fe 09             	cmp    $0x9,%esi
  8003f2:	76 eb                	jbe    8003df <vprintfmt+0x83>
  8003f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fa:	eb 14                	jmp    800410 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	8d 40 04             	lea    0x4(%eax),%eax
  80040a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800410:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800414:	79 89                	jns    80039f <vprintfmt+0x43>
				width = precision, precision = -1;
  800416:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800419:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800423:	e9 77 ff ff ff       	jmp    80039f <vprintfmt+0x43>
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	85 c0                	test   %eax,%eax
  80042d:	0f 48 c1             	cmovs  %ecx,%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800436:	e9 64 ff ff ff       	jmp    80039f <vprintfmt+0x43>
  80043b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800445:	e9 55 ff ff ff       	jmp    80039f <vprintfmt+0x43>
			lflag++;
  80044a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800451:	e9 49 ff ff ff       	jmp    80039f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	8d 78 04             	lea    0x4(%eax),%edi
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	53                   	push   %ebx
  800460:	ff 30                	pushl  (%eax)
  800462:	ff d6                	call   *%esi
			break;
  800464:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800467:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80046a:	e9 33 03 00 00       	jmp    8007a2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80046f:	8b 45 14             	mov    0x14(%ebp),%eax
  800472:	8d 78 04             	lea    0x4(%eax),%edi
  800475:	8b 00                	mov    (%eax),%eax
  800477:	99                   	cltd   
  800478:	31 d0                	xor    %edx,%eax
  80047a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047c:	83 f8 11             	cmp    $0x11,%eax
  80047f:	7f 23                	jg     8004a4 <vprintfmt+0x148>
  800481:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  800488:	85 d2                	test   %edx,%edx
  80048a:	74 18                	je     8004a4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80048c:	52                   	push   %edx
  80048d:	68 b5 2b 80 00       	push   $0x802bb5
  800492:	53                   	push   %ebx
  800493:	56                   	push   %esi
  800494:	e8 a6 fe ff ff       	call   80033f <printfmt>
  800499:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049f:	e9 fe 02 00 00       	jmp    8007a2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a4:	50                   	push   %eax
  8004a5:	68 f9 26 80 00       	push   $0x8026f9
  8004aa:	53                   	push   %ebx
  8004ab:	56                   	push   %esi
  8004ac:	e8 8e fe ff ff       	call   80033f <printfmt>
  8004b1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b7:	e9 e6 02 00 00       	jmp    8007a2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	83 c0 04             	add    $0x4,%eax
  8004c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ca:	85 c9                	test   %ecx,%ecx
  8004cc:	b8 f2 26 80 00       	mov    $0x8026f2,%eax
  8004d1:	0f 45 c1             	cmovne %ecx,%eax
  8004d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	7e 06                	jle    8004e3 <vprintfmt+0x187>
  8004dd:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004e1:	75 0d                	jne    8004f0 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e6:	89 c7                	mov    %eax,%edi
  8004e8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ee:	eb 53                	jmp    800543 <vprintfmt+0x1e7>
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f6:	50                   	push   %eax
  8004f7:	e8 71 04 00 00       	call   80096d <strnlen>
  8004fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ff:	29 c1                	sub    %eax,%ecx
  800501:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800509:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80050d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800510:	eb 0f                	jmp    800521 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	ff 75 e0             	pushl  -0x20(%ebp)
  800519:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80051b:	83 ef 01             	sub    $0x1,%edi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 ff                	test   %edi,%edi
  800523:	7f ed                	jg     800512 <vprintfmt+0x1b6>
  800525:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800528:	85 c9                	test   %ecx,%ecx
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	0f 49 c1             	cmovns %ecx,%eax
  800532:	29 c1                	sub    %eax,%ecx
  800534:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800537:	eb aa                	jmp    8004e3 <vprintfmt+0x187>
					putch(ch, putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	53                   	push   %ebx
  80053d:	52                   	push   %edx
  80053e:	ff d6                	call   *%esi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800546:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800548:	83 c7 01             	add    $0x1,%edi
  80054b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054f:	0f be d0             	movsbl %al,%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	74 4b                	je     8005a1 <vprintfmt+0x245>
  800556:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80055a:	78 06                	js     800562 <vprintfmt+0x206>
  80055c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800560:	78 1e                	js     800580 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800562:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800566:	74 d1                	je     800539 <vprintfmt+0x1dd>
  800568:	0f be c0             	movsbl %al,%eax
  80056b:	83 e8 20             	sub    $0x20,%eax
  80056e:	83 f8 5e             	cmp    $0x5e,%eax
  800571:	76 c6                	jbe    800539 <vprintfmt+0x1dd>
					putch('?', putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	6a 3f                	push   $0x3f
  800579:	ff d6                	call   *%esi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	eb c3                	jmp    800543 <vprintfmt+0x1e7>
  800580:	89 cf                	mov    %ecx,%edi
  800582:	eb 0e                	jmp    800592 <vprintfmt+0x236>
				putch(' ', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 20                	push   $0x20
  80058a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80058c:	83 ef 01             	sub    $0x1,%edi
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	85 ff                	test   %edi,%edi
  800594:	7f ee                	jg     800584 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800596:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	e9 01 02 00 00       	jmp    8007a2 <vprintfmt+0x446>
  8005a1:	89 cf                	mov    %ecx,%edi
  8005a3:	eb ed                	jmp    800592 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005a8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005af:	e9 eb fd ff ff       	jmp    80039f <vprintfmt+0x43>
	if (lflag >= 2)
  8005b4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b8:	7f 21                	jg     8005db <vprintfmt+0x27f>
	else if (lflag)
  8005ba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005be:	74 68                	je     800628 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c8:	89 c1                	mov    %eax,%ecx
  8005ca:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8d 40 04             	lea    0x4(%eax),%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d9:	eb 17                	jmp    8005f2 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 50 04             	mov    0x4(%eax),%edx
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 08             	lea    0x8(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800602:	78 3f                	js     800643 <vprintfmt+0x2e7>
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800609:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80060d:	0f 84 71 01 00 00    	je     800784 <vprintfmt+0x428>
				putch('+', putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	6a 2b                	push   $0x2b
  800619:	ff d6                	call   *%esi
  80061b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800623:	e9 5c 01 00 00       	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800630:	89 c1                	mov    %eax,%ecx
  800632:	c1 f9 1f             	sar    $0x1f,%ecx
  800635:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
  800641:	eb af                	jmp    8005f2 <vprintfmt+0x296>
				putch('-', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	6a 2d                	push   $0x2d
  800649:	ff d6                	call   *%esi
				num = -(long long) num;
  80064b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800651:	f7 d8                	neg    %eax
  800653:	83 d2 00             	adc    $0x0,%edx
  800656:	f7 da                	neg    %edx
  800658:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800661:	b8 0a 00 00 00       	mov    $0xa,%eax
  800666:	e9 19 01 00 00       	jmp    800784 <vprintfmt+0x428>
	if (lflag >= 2)
  80066b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066f:	7f 29                	jg     80069a <vprintfmt+0x33e>
	else if (lflag)
  800671:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800675:	74 44                	je     8006bb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800690:	b8 0a 00 00 00       	mov    $0xa,%eax
  800695:	e9 ea 00 00 00       	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 50 04             	mov    0x4(%eax),%edx
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 08             	lea    0x8(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b6:	e9 c9 00 00 00       	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d9:	e9 a6 00 00 00       	jmp    800784 <vprintfmt+0x428>
			putch('0', putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	6a 30                	push   $0x30
  8006e4:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ed:	7f 26                	jg     800715 <vprintfmt+0x3b9>
	else if (lflag)
  8006ef:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f3:	74 3e                	je     800733 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800702:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070e:	b8 08 00 00 00       	mov    $0x8,%eax
  800713:	eb 6f                	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 50 04             	mov    0x4(%eax),%edx
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 08             	lea    0x8(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072c:	b8 08 00 00 00       	mov    $0x8,%eax
  800731:	eb 51                	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074c:	b8 08 00 00 00       	mov    $0x8,%eax
  800751:	eb 31                	jmp    800784 <vprintfmt+0x428>
			putch('0', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 30                	push   $0x30
  800759:	ff d6                	call   *%esi
			putch('x', putdat);
  80075b:	83 c4 08             	add    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 78                	push   $0x78
  800761:	ff d6                	call   *%esi
			num = (unsigned long long)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	ba 00 00 00 00       	mov    $0x0,%edx
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800773:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80078b:	52                   	push   %edx
  80078c:	ff 75 e0             	pushl  -0x20(%ebp)
  80078f:	50                   	push   %eax
  800790:	ff 75 dc             	pushl  -0x24(%ebp)
  800793:	ff 75 d8             	pushl  -0x28(%ebp)
  800796:	89 da                	mov    %ebx,%edx
  800798:	89 f0                	mov    %esi,%eax
  80079a:	e8 a4 fa ff ff       	call   800243 <printnum>
			break;
  80079f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a5:	83 c7 01             	add    $0x1,%edi
  8007a8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ac:	83 f8 25             	cmp    $0x25,%eax
  8007af:	0f 84 be fb ff ff    	je     800373 <vprintfmt+0x17>
			if (ch == '\0')
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	0f 84 28 01 00 00    	je     8008e5 <vprintfmt+0x589>
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	50                   	push   %eax
  8007c2:	ff d6                	call   *%esi
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	eb dc                	jmp    8007a5 <vprintfmt+0x449>
	if (lflag >= 2)
  8007c9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007cd:	7f 26                	jg     8007f5 <vprintfmt+0x499>
	else if (lflag)
  8007cf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d3:	74 41                	je     800816 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f3:	eb 8f                	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 50 04             	mov    0x4(%eax),%edx
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8d 40 08             	lea    0x8(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
  800811:	e9 6e ff ff ff       	jmp    800784 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	ba 00 00 00 00       	mov    $0x0,%edx
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082f:	b8 10 00 00 00       	mov    $0x10,%eax
  800834:	e9 4b ff ff ff       	jmp    800784 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	83 c0 04             	add    $0x4,%eax
  80083f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	85 c0                	test   %eax,%eax
  800849:	74 14                	je     80085f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80084b:	8b 13                	mov    (%ebx),%edx
  80084d:	83 fa 7f             	cmp    $0x7f,%edx
  800850:	7f 37                	jg     800889 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800852:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800854:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	e9 43 ff ff ff       	jmp    8007a2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80085f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800864:	bf 15 28 80 00       	mov    $0x802815,%edi
							putch(ch, putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	53                   	push   %ebx
  80086d:	50                   	push   %eax
  80086e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800870:	83 c7 01             	add    $0x1,%edi
  800873:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	75 eb                	jne    800869 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80087e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	e9 19 ff ff ff       	jmp    8007a2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800889:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80088b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800890:	bf 4d 28 80 00       	mov    $0x80284d,%edi
							putch(ch, putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	53                   	push   %ebx
  800899:	50                   	push   %eax
  80089a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80089c:	83 c7 01             	add    $0x1,%edi
  80089f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	75 eb                	jne    800895 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b0:	e9 ed fe ff ff       	jmp    8007a2 <vprintfmt+0x446>
			putch(ch, putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	6a 25                	push   $0x25
  8008bb:	ff d6                	call   *%esi
			break;
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	e9 dd fe ff ff       	jmp    8007a2 <vprintfmt+0x446>
			putch('%', putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	6a 25                	push   $0x25
  8008cb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	89 f8                	mov    %edi,%eax
  8008d2:	eb 03                	jmp    8008d7 <vprintfmt+0x57b>
  8008d4:	83 e8 01             	sub    $0x1,%eax
  8008d7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008db:	75 f7                	jne    8008d4 <vprintfmt+0x578>
  8008dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e0:	e9 bd fe ff ff       	jmp    8007a2 <vprintfmt+0x446>
}
  8008e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e8:	5b                   	pop    %ebx
  8008e9:	5e                   	pop    %esi
  8008ea:	5f                   	pop    %edi
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	83 ec 18             	sub    $0x18,%esp
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800900:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800903:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090a:	85 c0                	test   %eax,%eax
  80090c:	74 26                	je     800934 <vsnprintf+0x47>
  80090e:	85 d2                	test   %edx,%edx
  800910:	7e 22                	jle    800934 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800912:	ff 75 14             	pushl  0x14(%ebp)
  800915:	ff 75 10             	pushl  0x10(%ebp)
  800918:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091b:	50                   	push   %eax
  80091c:	68 22 03 80 00       	push   $0x800322
  800921:	e8 36 fa ff ff       	call   80035c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800929:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092f:	83 c4 10             	add    $0x10,%esp
}
  800932:	c9                   	leave  
  800933:	c3                   	ret    
		return -E_INVAL;
  800934:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800939:	eb f7                	jmp    800932 <vsnprintf+0x45>

0080093b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800941:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800944:	50                   	push   %eax
  800945:	ff 75 10             	pushl  0x10(%ebp)
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	ff 75 08             	pushl  0x8(%ebp)
  80094e:	e8 9a ff ff ff       	call   8008ed <vsnprintf>
	va_end(ap);

	return rc;
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
  800960:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800964:	74 05                	je     80096b <strlen+0x16>
		n++;
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	eb f5                	jmp    800960 <strlen+0xb>
	return n;
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	ba 00 00 00 00       	mov    $0x0,%edx
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	74 0d                	je     80098c <strnlen+0x1f>
  80097f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800983:	74 05                	je     80098a <strnlen+0x1d>
		n++;
  800985:	83 c2 01             	add    $0x1,%edx
  800988:	eb f1                	jmp    80097b <strnlen+0xe>
  80098a:	89 d0                	mov    %edx,%eax
	return n;
}
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	53                   	push   %ebx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
  80099d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009a1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a4:	83 c2 01             	add    $0x1,%edx
  8009a7:	84 c9                	test   %cl,%cl
  8009a9:	75 f2                	jne    80099d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009ab:	5b                   	pop    %ebx
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
  8009b2:	83 ec 10             	sub    $0x10,%esp
  8009b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b8:	53                   	push   %ebx
  8009b9:	e8 97 ff ff ff       	call   800955 <strlen>
  8009be:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	01 d8                	add    %ebx,%eax
  8009c6:	50                   	push   %eax
  8009c7:	e8 c2 ff ff ff       	call   80098e <strcpy>
	return dst;
}
  8009cc:	89 d8                	mov    %ebx,%eax
  8009ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	56                   	push   %esi
  8009d7:	53                   	push   %ebx
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009de:	89 c6                	mov    %eax,%esi
  8009e0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e3:	89 c2                	mov    %eax,%edx
  8009e5:	39 f2                	cmp    %esi,%edx
  8009e7:	74 11                	je     8009fa <strncpy+0x27>
		*dst++ = *src;
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	0f b6 19             	movzbl (%ecx),%ebx
  8009ef:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f2:	80 fb 01             	cmp    $0x1,%bl
  8009f5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009f8:	eb eb                	jmp    8009e5 <strncpy+0x12>
	}
	return ret;
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5e                   	pop    %esi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	8b 75 08             	mov    0x8(%ebp),%esi
  800a06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a09:	8b 55 10             	mov    0x10(%ebp),%edx
  800a0c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a0e:	85 d2                	test   %edx,%edx
  800a10:	74 21                	je     800a33 <strlcpy+0x35>
  800a12:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a16:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a18:	39 c2                	cmp    %eax,%edx
  800a1a:	74 14                	je     800a30 <strlcpy+0x32>
  800a1c:	0f b6 19             	movzbl (%ecx),%ebx
  800a1f:	84 db                	test   %bl,%bl
  800a21:	74 0b                	je     800a2e <strlcpy+0x30>
			*dst++ = *src++;
  800a23:	83 c1 01             	add    $0x1,%ecx
  800a26:	83 c2 01             	add    $0x1,%edx
  800a29:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a2c:	eb ea                	jmp    800a18 <strlcpy+0x1a>
  800a2e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a30:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a33:	29 f0                	sub    %esi,%eax
}
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a42:	0f b6 01             	movzbl (%ecx),%eax
  800a45:	84 c0                	test   %al,%al
  800a47:	74 0c                	je     800a55 <strcmp+0x1c>
  800a49:	3a 02                	cmp    (%edx),%al
  800a4b:	75 08                	jne    800a55 <strcmp+0x1c>
		p++, q++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	83 c2 01             	add    $0x1,%edx
  800a53:	eb ed                	jmp    800a42 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a55:	0f b6 c0             	movzbl %al,%eax
  800a58:	0f b6 12             	movzbl (%edx),%edx
  800a5b:	29 d0                	sub    %edx,%eax
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	53                   	push   %ebx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a69:	89 c3                	mov    %eax,%ebx
  800a6b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a6e:	eb 06                	jmp    800a76 <strncmp+0x17>
		n--, p++, q++;
  800a70:	83 c0 01             	add    $0x1,%eax
  800a73:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a76:	39 d8                	cmp    %ebx,%eax
  800a78:	74 16                	je     800a90 <strncmp+0x31>
  800a7a:	0f b6 08             	movzbl (%eax),%ecx
  800a7d:	84 c9                	test   %cl,%cl
  800a7f:	74 04                	je     800a85 <strncmp+0x26>
  800a81:	3a 0a                	cmp    (%edx),%cl
  800a83:	74 eb                	je     800a70 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a85:	0f b6 00             	movzbl (%eax),%eax
  800a88:	0f b6 12             	movzbl (%edx),%edx
  800a8b:	29 d0                	sub    %edx,%eax
}
  800a8d:	5b                   	pop    %ebx
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    
		return 0;
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	eb f6                	jmp    800a8d <strncmp+0x2e>

00800a97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa1:	0f b6 10             	movzbl (%eax),%edx
  800aa4:	84 d2                	test   %dl,%dl
  800aa6:	74 09                	je     800ab1 <strchr+0x1a>
		if (*s == c)
  800aa8:	38 ca                	cmp    %cl,%dl
  800aaa:	74 0a                	je     800ab6 <strchr+0x1f>
	for (; *s; s++)
  800aac:	83 c0 01             	add    $0x1,%eax
  800aaf:	eb f0                	jmp    800aa1 <strchr+0xa>
			return (char *) s;
	return 0;
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac5:	38 ca                	cmp    %cl,%dl
  800ac7:	74 09                	je     800ad2 <strfind+0x1a>
  800ac9:	84 d2                	test   %dl,%dl
  800acb:	74 05                	je     800ad2 <strfind+0x1a>
	for (; *s; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f0                	jmp    800ac2 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 7d 08             	mov    0x8(%ebp),%edi
  800add:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae0:	85 c9                	test   %ecx,%ecx
  800ae2:	74 31                	je     800b15 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae4:	89 f8                	mov    %edi,%eax
  800ae6:	09 c8                	or     %ecx,%eax
  800ae8:	a8 03                	test   $0x3,%al
  800aea:	75 23                	jne    800b0f <memset+0x3b>
		c &= 0xFF;
  800aec:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af0:	89 d3                	mov    %edx,%ebx
  800af2:	c1 e3 08             	shl    $0x8,%ebx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	c1 e0 18             	shl    $0x18,%eax
  800afa:	89 d6                	mov    %edx,%esi
  800afc:	c1 e6 10             	shl    $0x10,%esi
  800aff:	09 f0                	or     %esi,%eax
  800b01:	09 c2                	or     %eax,%edx
  800b03:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b05:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b08:	89 d0                	mov    %edx,%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b0d:	eb 06                	jmp    800b15 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	fc                   	cld    
  800b13:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b15:	89 f8                	mov    %edi,%eax
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b2a:	39 c6                	cmp    %eax,%esi
  800b2c:	73 32                	jae    800b60 <memmove+0x44>
  800b2e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b31:	39 c2                	cmp    %eax,%edx
  800b33:	76 2b                	jbe    800b60 <memmove+0x44>
		s += n;
		d += n;
  800b35:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b38:	89 fe                	mov    %edi,%esi
  800b3a:	09 ce                	or     %ecx,%esi
  800b3c:	09 d6                	or     %edx,%esi
  800b3e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b44:	75 0e                	jne    800b54 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b46:	83 ef 04             	sub    $0x4,%edi
  800b49:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b4f:	fd                   	std    
  800b50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b52:	eb 09                	jmp    800b5d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b54:	83 ef 01             	sub    $0x1,%edi
  800b57:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b5a:	fd                   	std    
  800b5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5d:	fc                   	cld    
  800b5e:	eb 1a                	jmp    800b7a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	09 ca                	or     %ecx,%edx
  800b64:	09 f2                	or     %esi,%edx
  800b66:	f6 c2 03             	test   $0x3,%dl
  800b69:	75 0a                	jne    800b75 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	fc                   	cld    
  800b71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b73:	eb 05                	jmp    800b7a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b75:	89 c7                	mov    %eax,%edi
  800b77:	fc                   	cld    
  800b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b84:	ff 75 10             	pushl  0x10(%ebp)
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 8a ff ff ff       	call   800b1c <memmove>
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9f:	89 c6                	mov    %eax,%esi
  800ba1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba4:	39 f0                	cmp    %esi,%eax
  800ba6:	74 1c                	je     800bc4 <memcmp+0x30>
		if (*s1 != *s2)
  800ba8:	0f b6 08             	movzbl (%eax),%ecx
  800bab:	0f b6 1a             	movzbl (%edx),%ebx
  800bae:	38 d9                	cmp    %bl,%cl
  800bb0:	75 08                	jne    800bba <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	83 c2 01             	add    $0x1,%edx
  800bb8:	eb ea                	jmp    800ba4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bba:	0f b6 c1             	movzbl %cl,%eax
  800bbd:	0f b6 db             	movzbl %bl,%ebx
  800bc0:	29 d8                	sub    %ebx,%eax
  800bc2:	eb 05                	jmp    800bc9 <memcmp+0x35>
	}

	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bdb:	39 d0                	cmp    %edx,%eax
  800bdd:	73 09                	jae    800be8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdf:	38 08                	cmp    %cl,(%eax)
  800be1:	74 05                	je     800be8 <memfind+0x1b>
	for (; s < ends; s++)
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	eb f3                	jmp    800bdb <memfind+0xe>
			break;
	return (void *) s;
}
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	57                   	push   %edi
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
  800bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf6:	eb 03                	jmp    800bfb <strtol+0x11>
		s++;
  800bf8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bfb:	0f b6 01             	movzbl (%ecx),%eax
  800bfe:	3c 20                	cmp    $0x20,%al
  800c00:	74 f6                	je     800bf8 <strtol+0xe>
  800c02:	3c 09                	cmp    $0x9,%al
  800c04:	74 f2                	je     800bf8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c06:	3c 2b                	cmp    $0x2b,%al
  800c08:	74 2a                	je     800c34 <strtol+0x4a>
	int neg = 0;
  800c0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0f:	3c 2d                	cmp    $0x2d,%al
  800c11:	74 2b                	je     800c3e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c13:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c19:	75 0f                	jne    800c2a <strtol+0x40>
  800c1b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c1e:	74 28                	je     800c48 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c20:	85 db                	test   %ebx,%ebx
  800c22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c27:	0f 44 d8             	cmove  %eax,%ebx
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c32:	eb 50                	jmp    800c84 <strtol+0x9a>
		s++;
  800c34:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c37:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3c:	eb d5                	jmp    800c13 <strtol+0x29>
		s++, neg = 1;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	bf 01 00 00 00       	mov    $0x1,%edi
  800c46:	eb cb                	jmp    800c13 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c48:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4c:	74 0e                	je     800c5c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c4e:	85 db                	test   %ebx,%ebx
  800c50:	75 d8                	jne    800c2a <strtol+0x40>
		s++, base = 8;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5a:	eb ce                	jmp    800c2a <strtol+0x40>
		s += 2, base = 16;
  800c5c:	83 c1 02             	add    $0x2,%ecx
  800c5f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c64:	eb c4                	jmp    800c2a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c69:	89 f3                	mov    %esi,%ebx
  800c6b:	80 fb 19             	cmp    $0x19,%bl
  800c6e:	77 29                	ja     800c99 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c70:	0f be d2             	movsbl %dl,%edx
  800c73:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c76:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c79:	7d 30                	jge    800cab <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c7b:	83 c1 01             	add    $0x1,%ecx
  800c7e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c82:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c84:	0f b6 11             	movzbl (%ecx),%edx
  800c87:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8a:	89 f3                	mov    %esi,%ebx
  800c8c:	80 fb 09             	cmp    $0x9,%bl
  800c8f:	77 d5                	ja     800c66 <strtol+0x7c>
			dig = *s - '0';
  800c91:	0f be d2             	movsbl %dl,%edx
  800c94:	83 ea 30             	sub    $0x30,%edx
  800c97:	eb dd                	jmp    800c76 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c99:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9c:	89 f3                	mov    %esi,%ebx
  800c9e:	80 fb 19             	cmp    $0x19,%bl
  800ca1:	77 08                	ja     800cab <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca3:	0f be d2             	movsbl %dl,%edx
  800ca6:	83 ea 37             	sub    $0x37,%edx
  800ca9:	eb cb                	jmp    800c76 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caf:	74 05                	je     800cb6 <strtol+0xcc>
		*endptr = (char *) s;
  800cb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb6:	89 c2                	mov    %eax,%edx
  800cb8:	f7 da                	neg    %edx
  800cba:	85 ff                	test   %edi,%edi
  800cbc:	0f 45 c2             	cmovne %edx,%eax
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	89 c3                	mov    %eax,%ebx
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	89 c6                	mov    %eax,%esi
  800cdb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ced:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf2:	89 d1                	mov    %edx,%ecx
  800cf4:	89 d3                	mov    %edx,%ebx
  800cf6:	89 d7                	mov    %edx,%edi
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	b8 03 00 00 00       	mov    $0x3,%eax
  800d17:	89 cb                	mov    %ecx,%ebx
  800d19:	89 cf                	mov    %ecx,%edi
  800d1b:	89 ce                	mov    %ecx,%esi
  800d1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7f 08                	jg     800d2b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2b:	83 ec 0c             	sub    $0xc,%esp
  800d2e:	50                   	push   %eax
  800d2f:	6a 03                	push   $0x3
  800d31:	68 68 2a 80 00       	push   $0x802a68
  800d36:	6a 43                	push   $0x43
  800d38:	68 85 2a 80 00       	push   $0x802a85
  800d3d:	e8 1e 15 00 00       	call   802260 <_panic>

00800d42 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d48:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d52:	89 d1                	mov    %edx,%ecx
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	89 d7                	mov    %edx,%edi
  800d58:	89 d6                	mov    %edx,%esi
  800d5a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <sys_yield>:

void
sys_yield(void)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d67:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d71:	89 d1                	mov    %edx,%ecx
  800d73:	89 d3                	mov    %edx,%ebx
  800d75:	89 d7                	mov    %edx,%edi
  800d77:	89 d6                	mov    %edx,%esi
  800d79:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	be 00 00 00 00       	mov    $0x0,%esi
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 04 00 00 00       	mov    $0x4,%eax
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9c:	89 f7                	mov    %esi,%edi
  800d9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7f 08                	jg     800dac <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	50                   	push   %eax
  800db0:	6a 04                	push   $0x4
  800db2:	68 68 2a 80 00       	push   $0x802a68
  800db7:	6a 43                	push   $0x43
  800db9:	68 85 2a 80 00       	push   $0x802a85
  800dbe:	e8 9d 14 00 00       	call   802260 <_panic>

00800dc3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddd:	8b 75 18             	mov    0x18(%ebp),%esi
  800de0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	7f 08                	jg     800dee <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	50                   	push   %eax
  800df2:	6a 05                	push   $0x5
  800df4:	68 68 2a 80 00       	push   $0x802a68
  800df9:	6a 43                	push   $0x43
  800dfb:	68 85 2a 80 00       	push   $0x802a85
  800e00:	e8 5b 14 00 00       	call   802260 <_panic>

00800e05 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	89 de                	mov    %ebx,%esi
  800e22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 06                	push   $0x6
  800e36:	68 68 2a 80 00       	push   $0x802a68
  800e3b:	6a 43                	push   $0x43
  800e3d:	68 85 2a 80 00       	push   $0x802a85
  800e42:	e8 19 14 00 00       	call   802260 <_panic>

00800e47 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	89 de                	mov    %ebx,%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 08                	push   $0x8
  800e78:	68 68 2a 80 00       	push   $0x802a68
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 85 2a 80 00       	push   $0x802a85
  800e84:	e8 d7 13 00 00       	call   802260 <_panic>

00800e89 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9d:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea2:	89 df                	mov    %ebx,%edi
  800ea4:	89 de                	mov    %ebx,%esi
  800ea6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7f 08                	jg     800eb4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 09                	push   $0x9
  800eba:	68 68 2a 80 00       	push   $0x802a68
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 85 2a 80 00       	push   $0x802a85
  800ec6:	e8 95 13 00 00       	call   802260 <_panic>

00800ecb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7f 08                	jg     800ef6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 0a                	push   $0xa
  800efc:	68 68 2a 80 00       	push   $0x802a68
  800f01:	6a 43                	push   $0x43
  800f03:	68 85 2a 80 00       	push   $0x802a85
  800f08:	e8 53 13 00 00       	call   802260 <_panic>

00800f0d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1e:	be 00 00 00 00       	mov    $0x0,%esi
  800f23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f26:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f29:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f46:	89 cb                	mov    %ecx,%ebx
  800f48:	89 cf                	mov    %ecx,%edi
  800f4a:	89 ce                	mov    %ecx,%esi
  800f4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	7f 08                	jg     800f5a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	50                   	push   %eax
  800f5e:	6a 0d                	push   $0xd
  800f60:	68 68 2a 80 00       	push   $0x802a68
  800f65:	6a 43                	push   $0x43
  800f67:	68 85 2a 80 00       	push   $0x802a85
  800f6c:	e8 ef 12 00 00       	call   802260 <_panic>

00800f71 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f82:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f87:	89 df                	mov    %ebx,%edi
  800f89:	89 de                	mov    %ebx,%esi
  800f8b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa5:	89 cb                	mov    %ecx,%ebx
  800fa7:	89 cf                	mov    %ecx,%edi
  800fa9:	89 ce                	mov    %ecx,%esi
  800fab:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	89 d3                	mov    %edx,%ebx
  800fc6:	89 d7                	mov    %edx,%edi
  800fc8:	89 d6                	mov    %edx,%esi
  800fca:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	57                   	push   %edi
  800fd5:	56                   	push   %esi
  800fd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe2:	b8 11 00 00 00       	mov    $0x11,%eax
  800fe7:	89 df                	mov    %ebx,%edi
  800fe9:	89 de                	mov    %ebx,%esi
  800feb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	b8 12 00 00 00       	mov    $0x12,%eax
  801008:	89 df                	mov    %ebx,%edi
  80100a:	89 de                	mov    %ebx,%esi
  80100c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	53                   	push   %ebx
  801019:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801027:	b8 13 00 00 00       	mov    $0x13,%eax
  80102c:	89 df                	mov    %ebx,%edi
  80102e:	89 de                	mov    %ebx,%esi
  801030:	cd 30                	int    $0x30
	if(check && ret > 0)
  801032:	85 c0                	test   %eax,%eax
  801034:	7f 08                	jg     80103e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801036:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	50                   	push   %eax
  801042:	6a 13                	push   $0x13
  801044:	68 68 2a 80 00       	push   $0x802a68
  801049:	6a 43                	push   $0x43
  80104b:	68 85 2a 80 00       	push   $0x802a85
  801050:	e8 0b 12 00 00       	call   802260 <_panic>

00801055 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	b8 14 00 00 00       	mov    $0x14,%eax
  801068:	89 cb                	mov    %ecx,%ebx
  80106a:	89 cf                	mov    %ecx,%edi
  80106c:	89 ce                	mov    %ecx,%esi
  80106e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801070:	5b                   	pop    %ebx
  801071:	5e                   	pop    %esi
  801072:	5f                   	pop    %edi
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80107b:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801082:	74 0a                	je     80108e <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80108e:	83 ec 04             	sub    $0x4,%esp
  801091:	6a 07                	push   $0x7
  801093:	68 00 f0 bf ee       	push   $0xeebff000
  801098:	6a 00                	push   $0x0
  80109a:	e8 e1 fc ff ff       	call   800d80 <sys_page_alloc>
		if(r < 0)
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 2a                	js     8010d0 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	68 e4 10 80 00       	push   $0x8010e4
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 16 fe ff ff       	call   800ecb <sys_env_set_pgfault_upcall>
		if(r < 0)
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	79 c8                	jns    801084 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	68 c4 2a 80 00       	push   $0x802ac4
  8010c4:	6a 25                	push   $0x25
  8010c6:	68 fd 2a 80 00       	push   $0x802afd
  8010cb:	e8 90 11 00 00       	call   802260 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	68 94 2a 80 00       	push   $0x802a94
  8010d8:	6a 22                	push   $0x22
  8010da:	68 fd 2a 80 00       	push   $0x802afd
  8010df:	e8 7c 11 00 00       	call   802260 <_panic>

008010e4 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010e4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010e5:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010ea:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010ec:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8010ef:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8010f3:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8010f7:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8010fa:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8010fc:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801100:	83 c4 08             	add    $0x8,%esp
	popal
  801103:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801104:	83 c4 04             	add    $0x4,%esp
	popfl
  801107:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801108:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801109:	c3                   	ret    

0080110a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	05 00 00 00 30       	add    $0x30000000,%eax
  801115:	c1 e8 0c             	shr    $0xc,%eax
}
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801125:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801139:	89 c2                	mov    %eax,%edx
  80113b:	c1 ea 16             	shr    $0x16,%edx
  80113e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801145:	f6 c2 01             	test   $0x1,%dl
  801148:	74 2d                	je     801177 <fd_alloc+0x46>
  80114a:	89 c2                	mov    %eax,%edx
  80114c:	c1 ea 0c             	shr    $0xc,%edx
  80114f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801156:	f6 c2 01             	test   $0x1,%dl
  801159:	74 1c                	je     801177 <fd_alloc+0x46>
  80115b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801160:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801165:	75 d2                	jne    801139 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801170:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801175:	eb 0a                	jmp    801181 <fd_alloc+0x50>
			*fd_store = fd;
  801177:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801189:	83 f8 1f             	cmp    $0x1f,%eax
  80118c:	77 30                	ja     8011be <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80118e:	c1 e0 0c             	shl    $0xc,%eax
  801191:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801196:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80119c:	f6 c2 01             	test   $0x1,%dl
  80119f:	74 24                	je     8011c5 <fd_lookup+0x42>
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	c1 ea 0c             	shr    $0xc,%edx
  8011a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ad:	f6 c2 01             	test   $0x1,%dl
  8011b0:	74 1a                	je     8011cc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b5:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    
		return -E_INVAL;
  8011be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c3:	eb f7                	jmp    8011bc <fd_lookup+0x39>
		return -E_INVAL;
  8011c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ca:	eb f0                	jmp    8011bc <fd_lookup+0x39>
  8011cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d1:	eb e9                	jmp    8011bc <fd_lookup+0x39>

008011d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e6:	39 08                	cmp    %ecx,(%eax)
  8011e8:	74 38                	je     801222 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ea:	83 c2 01             	add    $0x1,%edx
  8011ed:	8b 04 95 88 2b 80 00 	mov    0x802b88(,%edx,4),%eax
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	75 ee                	jne    8011e6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8011fd:	8b 40 48             	mov    0x48(%eax),%eax
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	51                   	push   %ecx
  801204:	50                   	push   %eax
  801205:	68 0c 2b 80 00       	push   $0x802b0c
  80120a:	e8 20 f0 ff ff       	call   80022f <cprintf>
	*dev = 0;
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801220:	c9                   	leave  
  801221:	c3                   	ret    
			*dev = devtab[i];
  801222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801225:	89 01                	mov    %eax,(%ecx)
			return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
  80122c:	eb f2                	jmp    801220 <dev_lookup+0x4d>

0080122e <fd_close>:
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 24             	sub    $0x24,%esp
  801237:	8b 75 08             	mov    0x8(%ebp),%esi
  80123a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80123d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801240:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801241:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80124a:	50                   	push   %eax
  80124b:	e8 33 ff ff ff       	call   801183 <fd_lookup>
  801250:	89 c3                	mov    %eax,%ebx
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	78 05                	js     80125e <fd_close+0x30>
	    || fd != fd2)
  801259:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80125c:	74 16                	je     801274 <fd_close+0x46>
		return (must_exist ? r : 0);
  80125e:	89 f8                	mov    %edi,%eax
  801260:	84 c0                	test   %al,%al
  801262:	b8 00 00 00 00       	mov    $0x0,%eax
  801267:	0f 44 d8             	cmove  %eax,%ebx
}
  80126a:	89 d8                	mov    %ebx,%eax
  80126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80127a:	50                   	push   %eax
  80127b:	ff 36                	pushl  (%esi)
  80127d:	e8 51 ff ff ff       	call   8011d3 <dev_lookup>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 1a                	js     8012a5 <fd_close+0x77>
		if (dev->dev_close)
  80128b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801291:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801296:	85 c0                	test   %eax,%eax
  801298:	74 0b                	je     8012a5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	56                   	push   %esi
  80129e:	ff d0                	call   *%eax
  8012a0:	89 c3                	mov    %eax,%ebx
  8012a2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	56                   	push   %esi
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 55 fb ff ff       	call   800e05 <sys_page_unmap>
	return r;
  8012b0:	83 c4 10             	add    $0x10,%esp
  8012b3:	eb b5                	jmp    80126a <fd_close+0x3c>

008012b5 <close>:

int
close(int fdnum)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012be:	50                   	push   %eax
  8012bf:	ff 75 08             	pushl  0x8(%ebp)
  8012c2:	e8 bc fe ff ff       	call   801183 <fd_lookup>
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	79 02                	jns    8012d0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    
		return fd_close(fd, 1);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	6a 01                	push   $0x1
  8012d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d8:	e8 51 ff ff ff       	call   80122e <fd_close>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	eb ec                	jmp    8012ce <close+0x19>

008012e2 <close_all>:

void
close_all(void)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	53                   	push   %ebx
  8012f2:	e8 be ff ff ff       	call   8012b5 <close>
	for (i = 0; i < MAXFD; i++)
  8012f7:	83 c3 01             	add    $0x1,%ebx
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	83 fb 20             	cmp    $0x20,%ebx
  801300:	75 ec                	jne    8012ee <close_all+0xc>
}
  801302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	57                   	push   %edi
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
  80130d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801310:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801313:	50                   	push   %eax
  801314:	ff 75 08             	pushl  0x8(%ebp)
  801317:	e8 67 fe ff ff       	call   801183 <fd_lookup>
  80131c:	89 c3                	mov    %eax,%ebx
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	0f 88 81 00 00 00    	js     8013aa <dup+0xa3>
		return r;
	close(newfdnum);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	ff 75 0c             	pushl  0xc(%ebp)
  80132f:	e8 81 ff ff ff       	call   8012b5 <close>

	newfd = INDEX2FD(newfdnum);
  801334:	8b 75 0c             	mov    0xc(%ebp),%esi
  801337:	c1 e6 0c             	shl    $0xc,%esi
  80133a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801340:	83 c4 04             	add    $0x4,%esp
  801343:	ff 75 e4             	pushl  -0x1c(%ebp)
  801346:	e8 cf fd ff ff       	call   80111a <fd2data>
  80134b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80134d:	89 34 24             	mov    %esi,(%esp)
  801350:	e8 c5 fd ff ff       	call   80111a <fd2data>
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	c1 e8 16             	shr    $0x16,%eax
  80135f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801366:	a8 01                	test   $0x1,%al
  801368:	74 11                	je     80137b <dup+0x74>
  80136a:	89 d8                	mov    %ebx,%eax
  80136c:	c1 e8 0c             	shr    $0xc,%eax
  80136f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801376:	f6 c2 01             	test   $0x1,%dl
  801379:	75 39                	jne    8013b4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80137b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80137e:	89 d0                	mov    %edx,%eax
  801380:	c1 e8 0c             	shr    $0xc,%eax
  801383:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	25 07 0e 00 00       	and    $0xe07,%eax
  801392:	50                   	push   %eax
  801393:	56                   	push   %esi
  801394:	6a 00                	push   $0x0
  801396:	52                   	push   %edx
  801397:	6a 00                	push   $0x0
  801399:	e8 25 fa ff ff       	call   800dc3 <sys_page_map>
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	83 c4 20             	add    $0x20,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 31                	js     8013d8 <dup+0xd1>
		goto err;

	return newfdnum;
  8013a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013aa:	89 d8                	mov    %ebx,%eax
  8013ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5f                   	pop    %edi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c3:	50                   	push   %eax
  8013c4:	57                   	push   %edi
  8013c5:	6a 00                	push   $0x0
  8013c7:	53                   	push   %ebx
  8013c8:	6a 00                	push   $0x0
  8013ca:	e8 f4 f9 ff ff       	call   800dc3 <sys_page_map>
  8013cf:	89 c3                	mov    %eax,%ebx
  8013d1:	83 c4 20             	add    $0x20,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	79 a3                	jns    80137b <dup+0x74>
	sys_page_unmap(0, newfd);
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	56                   	push   %esi
  8013dc:	6a 00                	push   $0x0
  8013de:	e8 22 fa ff ff       	call   800e05 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013e3:	83 c4 08             	add    $0x8,%esp
  8013e6:	57                   	push   %edi
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 17 fa ff ff       	call   800e05 <sys_page_unmap>
	return r;
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	eb b7                	jmp    8013aa <dup+0xa3>

008013f3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	53                   	push   %ebx
  8013f7:	83 ec 1c             	sub    $0x1c,%esp
  8013fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	53                   	push   %ebx
  801402:	e8 7c fd ff ff       	call   801183 <fd_lookup>
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 3f                	js     80144d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801414:	50                   	push   %eax
  801415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801418:	ff 30                	pushl  (%eax)
  80141a:	e8 b4 fd ff ff       	call   8011d3 <dev_lookup>
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 27                	js     80144d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801429:	8b 42 08             	mov    0x8(%edx),%eax
  80142c:	83 e0 03             	and    $0x3,%eax
  80142f:	83 f8 01             	cmp    $0x1,%eax
  801432:	74 1e                	je     801452 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801437:	8b 40 08             	mov    0x8(%eax),%eax
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 35                	je     801473 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	ff 75 10             	pushl  0x10(%ebp)
  801444:	ff 75 0c             	pushl  0xc(%ebp)
  801447:	52                   	push   %edx
  801448:	ff d0                	call   *%eax
  80144a:	83 c4 10             	add    $0x10,%esp
}
  80144d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801450:	c9                   	leave  
  801451:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801452:	a1 08 40 80 00       	mov    0x804008,%eax
  801457:	8b 40 48             	mov    0x48(%eax),%eax
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	53                   	push   %ebx
  80145e:	50                   	push   %eax
  80145f:	68 4d 2b 80 00       	push   $0x802b4d
  801464:	e8 c6 ed ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801471:	eb da                	jmp    80144d <read+0x5a>
		return -E_NOT_SUPP;
  801473:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801478:	eb d3                	jmp    80144d <read+0x5a>

0080147a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	57                   	push   %edi
  80147e:	56                   	push   %esi
  80147f:	53                   	push   %ebx
  801480:	83 ec 0c             	sub    $0xc,%esp
  801483:	8b 7d 08             	mov    0x8(%ebp),%edi
  801486:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801489:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148e:	39 f3                	cmp    %esi,%ebx
  801490:	73 23                	jae    8014b5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	89 f0                	mov    %esi,%eax
  801497:	29 d8                	sub    %ebx,%eax
  801499:	50                   	push   %eax
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	03 45 0c             	add    0xc(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	57                   	push   %edi
  8014a1:	e8 4d ff ff ff       	call   8013f3 <read>
		if (m < 0)
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 06                	js     8014b3 <readn+0x39>
			return m;
		if (m == 0)
  8014ad:	74 06                	je     8014b5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014af:	01 c3                	add    %eax,%ebx
  8014b1:	eb db                	jmp    80148e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014b5:	89 d8                	mov    %ebx,%eax
  8014b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ba:	5b                   	pop    %ebx
  8014bb:	5e                   	pop    %esi
  8014bc:	5f                   	pop    %edi
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    

008014bf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	53                   	push   %ebx
  8014c3:	83 ec 1c             	sub    $0x1c,%esp
  8014c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	53                   	push   %ebx
  8014ce:	e8 b0 fc ff ff       	call   801183 <fd_lookup>
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 3a                	js     801514 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	ff 30                	pushl  (%eax)
  8014e6:	e8 e8 fc ff ff       	call   8011d3 <dev_lookup>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 22                	js     801514 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f9:	74 1e                	je     801519 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fe:	8b 52 0c             	mov    0xc(%edx),%edx
  801501:	85 d2                	test   %edx,%edx
  801503:	74 35                	je     80153a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	ff 75 10             	pushl  0x10(%ebp)
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	50                   	push   %eax
  80150f:	ff d2                	call   *%edx
  801511:	83 c4 10             	add    $0x10,%esp
}
  801514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801519:	a1 08 40 80 00       	mov    0x804008,%eax
  80151e:	8b 40 48             	mov    0x48(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	53                   	push   %ebx
  801525:	50                   	push   %eax
  801526:	68 69 2b 80 00       	push   $0x802b69
  80152b:	e8 ff ec ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801538:	eb da                	jmp    801514 <write+0x55>
		return -E_NOT_SUPP;
  80153a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153f:	eb d3                	jmp    801514 <write+0x55>

00801541 <seek>:

int
seek(int fdnum, off_t offset)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801547:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154a:	50                   	push   %eax
  80154b:	ff 75 08             	pushl  0x8(%ebp)
  80154e:	e8 30 fc ff ff       	call   801183 <fd_lookup>
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 0e                	js     801568 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801560:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 1c             	sub    $0x1c,%esp
  801571:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801574:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	53                   	push   %ebx
  801579:	e8 05 fc ff ff       	call   801183 <fd_lookup>
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 37                	js     8015bc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158b:	50                   	push   %eax
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	ff 30                	pushl  (%eax)
  801591:	e8 3d fc ff ff       	call   8011d3 <dev_lookup>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 1f                	js     8015bc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a4:	74 1b                	je     8015c1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a9:	8b 52 18             	mov    0x18(%edx),%edx
  8015ac:	85 d2                	test   %edx,%edx
  8015ae:	74 32                	je     8015e2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	50                   	push   %eax
  8015b7:	ff d2                	call   *%edx
  8015b9:	83 c4 10             	add    $0x10,%esp
}
  8015bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015c1:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c6:	8b 40 48             	mov    0x48(%eax),%eax
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	53                   	push   %ebx
  8015cd:	50                   	push   %eax
  8015ce:	68 2c 2b 80 00       	push   $0x802b2c
  8015d3:	e8 57 ec ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e0:	eb da                	jmp    8015bc <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e7:	eb d3                	jmp    8015bc <ftruncate+0x52>

008015e9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	53                   	push   %ebx
  8015ed:	83 ec 1c             	sub    $0x1c,%esp
  8015f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	e8 84 fb ff ff       	call   801183 <fd_lookup>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 4b                	js     801651 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	ff 30                	pushl  (%eax)
  801612:	e8 bc fb ff ff       	call   8011d3 <dev_lookup>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 33                	js     801651 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801625:	74 2f                	je     801656 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801627:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80162a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801631:	00 00 00 
	stat->st_isdir = 0;
  801634:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80163b:	00 00 00 
	stat->st_dev = dev;
  80163e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	53                   	push   %ebx
  801648:	ff 75 f0             	pushl  -0x10(%ebp)
  80164b:	ff 50 14             	call   *0x14(%eax)
  80164e:	83 c4 10             	add    $0x10,%esp
}
  801651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801654:	c9                   	leave  
  801655:	c3                   	ret    
		return -E_NOT_SUPP;
  801656:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165b:	eb f4                	jmp    801651 <fstat+0x68>

0080165d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	6a 00                	push   $0x0
  801667:	ff 75 08             	pushl  0x8(%ebp)
  80166a:	e8 22 02 00 00       	call   801891 <open>
  80166f:	89 c3                	mov    %eax,%ebx
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 1b                	js     801693 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	50                   	push   %eax
  80167f:	e8 65 ff ff ff       	call   8015e9 <fstat>
  801684:	89 c6                	mov    %eax,%esi
	close(fd);
  801686:	89 1c 24             	mov    %ebx,(%esp)
  801689:	e8 27 fc ff ff       	call   8012b5 <close>
	return r;
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	89 f3                	mov    %esi,%ebx
}
  801693:	89 d8                	mov    %ebx,%eax
  801695:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801698:	5b                   	pop    %ebx
  801699:	5e                   	pop    %esi
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	89 c6                	mov    %eax,%esi
  8016a3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016a5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016ac:	74 27                	je     8016d5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ae:	6a 07                	push   $0x7
  8016b0:	68 00 50 80 00       	push   $0x805000
  8016b5:	56                   	push   %esi
  8016b6:	ff 35 00 40 80 00    	pushl  0x804000
  8016bc:	e8 69 0c 00 00       	call   80232a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016c1:	83 c4 0c             	add    $0xc,%esp
  8016c4:	6a 00                	push   $0x0
  8016c6:	53                   	push   %ebx
  8016c7:	6a 00                	push   $0x0
  8016c9:	e8 f3 0b 00 00       	call   8022c1 <ipc_recv>
}
  8016ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	6a 01                	push   $0x1
  8016da:	e8 a3 0c 00 00       	call   802382 <ipc_find_env>
  8016df:	a3 00 40 80 00       	mov    %eax,0x804000
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	eb c5                	jmp    8016ae <fsipc+0x12>

008016e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801702:	ba 00 00 00 00       	mov    $0x0,%edx
  801707:	b8 02 00 00 00       	mov    $0x2,%eax
  80170c:	e8 8b ff ff ff       	call   80169c <fsipc>
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <devfile_flush>:
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8b 40 0c             	mov    0xc(%eax),%eax
  80171f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 06 00 00 00       	mov    $0x6,%eax
  80172e:	e8 69 ff ff ff       	call   80169c <fsipc>
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <devfile_stat>:
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 05 00 00 00       	mov    $0x5,%eax
  801754:	e8 43 ff ff ff       	call   80169c <fsipc>
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 2c                	js     801789 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	68 00 50 80 00       	push   $0x805000
  801765:	53                   	push   %ebx
  801766:	e8 23 f2 ff ff       	call   80098e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80176b:	a1 80 50 80 00       	mov    0x805080,%eax
  801770:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801776:	a1 84 50 80 00       	mov    0x805084,%eax
  80177b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <devfile_write>:
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8b 40 0c             	mov    0xc(%eax),%eax
  80179e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017a3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017a9:	53                   	push   %ebx
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	68 08 50 80 00       	push   $0x805008
  8017b2:	e8 c7 f3 ff ff       	call   800b7e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bc:	b8 04 00 00 00       	mov    $0x4,%eax
  8017c1:	e8 d6 fe ff ff       	call   80169c <fsipc>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 0b                	js     8017d8 <devfile_write+0x4a>
	assert(r <= n);
  8017cd:	39 d8                	cmp    %ebx,%eax
  8017cf:	77 0c                	ja     8017dd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017d1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d6:	7f 1e                	jg     8017f6 <devfile_write+0x68>
}
  8017d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    
	assert(r <= n);
  8017dd:	68 9c 2b 80 00       	push   $0x802b9c
  8017e2:	68 a3 2b 80 00       	push   $0x802ba3
  8017e7:	68 98 00 00 00       	push   $0x98
  8017ec:	68 b8 2b 80 00       	push   $0x802bb8
  8017f1:	e8 6a 0a 00 00       	call   802260 <_panic>
	assert(r <= PGSIZE);
  8017f6:	68 c3 2b 80 00       	push   $0x802bc3
  8017fb:	68 a3 2b 80 00       	push   $0x802ba3
  801800:	68 99 00 00 00       	push   $0x99
  801805:	68 b8 2b 80 00       	push   $0x802bb8
  80180a:	e8 51 0a 00 00       	call   802260 <_panic>

0080180f <devfile_read>:
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8b 40 0c             	mov    0xc(%eax),%eax
  80181d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801822:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801828:	ba 00 00 00 00       	mov    $0x0,%edx
  80182d:	b8 03 00 00 00       	mov    $0x3,%eax
  801832:	e8 65 fe ff ff       	call   80169c <fsipc>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	85 c0                	test   %eax,%eax
  80183b:	78 1f                	js     80185c <devfile_read+0x4d>
	assert(r <= n);
  80183d:	39 f0                	cmp    %esi,%eax
  80183f:	77 24                	ja     801865 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801841:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801846:	7f 33                	jg     80187b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	50                   	push   %eax
  80184c:	68 00 50 80 00       	push   $0x805000
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	e8 c3 f2 ff ff       	call   800b1c <memmove>
	return r;
  801859:	83 c4 10             	add    $0x10,%esp
}
  80185c:	89 d8                	mov    %ebx,%eax
  80185e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801861:	5b                   	pop    %ebx
  801862:	5e                   	pop    %esi
  801863:	5d                   	pop    %ebp
  801864:	c3                   	ret    
	assert(r <= n);
  801865:	68 9c 2b 80 00       	push   $0x802b9c
  80186a:	68 a3 2b 80 00       	push   $0x802ba3
  80186f:	6a 7c                	push   $0x7c
  801871:	68 b8 2b 80 00       	push   $0x802bb8
  801876:	e8 e5 09 00 00       	call   802260 <_panic>
	assert(r <= PGSIZE);
  80187b:	68 c3 2b 80 00       	push   $0x802bc3
  801880:	68 a3 2b 80 00       	push   $0x802ba3
  801885:	6a 7d                	push   $0x7d
  801887:	68 b8 2b 80 00       	push   $0x802bb8
  80188c:	e8 cf 09 00 00       	call   802260 <_panic>

00801891 <open>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	83 ec 1c             	sub    $0x1c,%esp
  801899:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80189c:	56                   	push   %esi
  80189d:	e8 b3 f0 ff ff       	call   800955 <strlen>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018aa:	7f 6c                	jg     801918 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018ac:	83 ec 0c             	sub    $0xc,%esp
  8018af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b2:	50                   	push   %eax
  8018b3:	e8 79 f8 ff ff       	call   801131 <fd_alloc>
  8018b8:	89 c3                	mov    %eax,%ebx
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 3c                	js     8018fd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018c1:	83 ec 08             	sub    $0x8,%esp
  8018c4:	56                   	push   %esi
  8018c5:	68 00 50 80 00       	push   $0x805000
  8018ca:	e8 bf f0 ff ff       	call   80098e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018da:	b8 01 00 00 00       	mov    $0x1,%eax
  8018df:	e8 b8 fd ff ff       	call   80169c <fsipc>
  8018e4:	89 c3                	mov    %eax,%ebx
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 19                	js     801906 <open+0x75>
	return fd2num(fd);
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f3:	e8 12 f8 ff ff       	call   80110a <fd2num>
  8018f8:	89 c3                	mov    %eax,%ebx
  8018fa:	83 c4 10             	add    $0x10,%esp
}
  8018fd:	89 d8                	mov    %ebx,%eax
  8018ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    
		fd_close(fd, 0);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 f4             	pushl  -0xc(%ebp)
  80190e:	e8 1b f9 ff ff       	call   80122e <fd_close>
		return r;
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	eb e5                	jmp    8018fd <open+0x6c>
		return -E_BAD_PATH;
  801918:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80191d:	eb de                	jmp    8018fd <open+0x6c>

0080191f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	b8 08 00 00 00       	mov    $0x8,%eax
  80192f:	e8 68 fd ff ff       	call   80169c <fsipc>
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80193c:	68 cf 2b 80 00       	push   $0x802bcf
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	e8 45 f0 ff ff       	call   80098e <strcpy>
	return 0;
}
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <devsock_close>:
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 10             	sub    $0x10,%esp
  801957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80195a:	53                   	push   %ebx
  80195b:	e8 61 0a 00 00       	call   8023c1 <pageref>
  801960:	83 c4 10             	add    $0x10,%esp
		return 0;
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801968:	83 f8 01             	cmp    $0x1,%eax
  80196b:	74 07                	je     801974 <devsock_close+0x24>
}
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801972:	c9                   	leave  
  801973:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801974:	83 ec 0c             	sub    $0xc,%esp
  801977:	ff 73 0c             	pushl  0xc(%ebx)
  80197a:	e8 b9 02 00 00       	call   801c38 <nsipc_close>
  80197f:	89 c2                	mov    %eax,%edx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	eb e7                	jmp    80196d <devsock_close+0x1d>

00801986 <devsock_write>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 10             	pushl  0x10(%ebp)
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	ff 70 0c             	pushl  0xc(%eax)
  80199a:	e8 76 03 00 00       	call   801d15 <nsipc_send>
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <devsock_read>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 10             	pushl  0x10(%ebp)
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	ff 70 0c             	pushl  0xc(%eax)
  8019b5:	e8 ef 02 00 00       	call   801ca9 <nsipc_recv>
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <fd2sockid>:
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	e8 b7 f7 ff ff       	call   801183 <fd_lookup>
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 10                	js     8019e3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019dc:	39 08                	cmp    %ecx,(%eax)
  8019de:	75 05                	jne    8019e5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    
		return -E_NOT_SUPP;
  8019e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ea:	eb f7                	jmp    8019e3 <fd2sockid+0x27>

008019ec <alloc_sockfd>:
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 1c             	sub    $0x1c,%esp
  8019f4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f9:	50                   	push   %eax
  8019fa:	e8 32 f7 ff ff       	call   801131 <fd_alloc>
  8019ff:	89 c3                	mov    %eax,%ebx
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 43                	js     801a4b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	68 07 04 00 00       	push   $0x407
  801a10:	ff 75 f4             	pushl  -0xc(%ebp)
  801a13:	6a 00                	push   $0x0
  801a15:	e8 66 f3 ff ff       	call   800d80 <sys_page_alloc>
  801a1a:	89 c3                	mov    %eax,%ebx
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 28                	js     801a4b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a26:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a38:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	50                   	push   %eax
  801a3f:	e8 c6 f6 ff ff       	call   80110a <fd2num>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	eb 0c                	jmp    801a57 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	56                   	push   %esi
  801a4f:	e8 e4 01 00 00       	call   801c38 <nsipc_close>
		return r;
  801a54:	83 c4 10             	add    $0x10,%esp
}
  801a57:	89 d8                	mov    %ebx,%eax
  801a59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    

00801a60 <accept>:
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	e8 4e ff ff ff       	call   8019bc <fd2sockid>
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 1b                	js     801a8d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	ff 75 10             	pushl  0x10(%ebp)
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	50                   	push   %eax
  801a7c:	e8 0e 01 00 00       	call   801b8f <nsipc_accept>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 05                	js     801a8d <accept+0x2d>
	return alloc_sockfd(r);
  801a88:	e8 5f ff ff ff       	call   8019ec <alloc_sockfd>
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <bind>:
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	e8 1f ff ff ff       	call   8019bc <fd2sockid>
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 12                	js     801ab3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	50                   	push   %eax
  801aab:	e8 31 01 00 00       	call   801be1 <nsipc_bind>
  801ab0:	83 c4 10             	add    $0x10,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <shutdown>:
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	e8 f9 fe ff ff       	call   8019bc <fd2sockid>
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 0f                	js     801ad6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	50                   	push   %eax
  801ace:	e8 43 01 00 00       	call   801c16 <nsipc_shutdown>
  801ad3:	83 c4 10             	add    $0x10,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <connect>:
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	e8 d6 fe ff ff       	call   8019bc <fd2sockid>
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 12                	js     801afc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	ff 75 10             	pushl  0x10(%ebp)
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	50                   	push   %eax
  801af4:	e8 59 01 00 00       	call   801c52 <nsipc_connect>
  801af9:	83 c4 10             	add    $0x10,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <listen>:
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	e8 b0 fe ff ff       	call   8019bc <fd2sockid>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 0f                	js     801b1f <listen+0x21>
	return nsipc_listen(r, backlog);
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	e8 6b 01 00 00       	call   801c87 <nsipc_listen>
  801b1c:	83 c4 10             	add    $0x10,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b27:	ff 75 10             	pushl  0x10(%ebp)
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	e8 3e 02 00 00       	call   801d73 <nsipc_socket>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 05                	js     801b41 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b3c:	e8 ab fe ff ff       	call   8019ec <alloc_sockfd>
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	53                   	push   %ebx
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b4c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b53:	74 26                	je     801b7b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b55:	6a 07                	push   $0x7
  801b57:	68 00 60 80 00       	push   $0x806000
  801b5c:	53                   	push   %ebx
  801b5d:	ff 35 04 40 80 00    	pushl  0x804004
  801b63:	e8 c2 07 00 00       	call   80232a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b68:	83 c4 0c             	add    $0xc,%esp
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	e8 4b 07 00 00       	call   8022c1 <ipc_recv>
}
  801b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b7b:	83 ec 0c             	sub    $0xc,%esp
  801b7e:	6a 02                	push   $0x2
  801b80:	e8 fd 07 00 00       	call   802382 <ipc_find_env>
  801b85:	a3 04 40 80 00       	mov    %eax,0x804004
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	eb c6                	jmp    801b55 <nsipc+0x12>

00801b8f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b9f:	8b 06                	mov    (%esi),%eax
  801ba1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	e8 93 ff ff ff       	call   801b43 <nsipc>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	79 09                	jns    801bbf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bb6:	89 d8                	mov    %ebx,%eax
  801bb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	ff 35 10 60 80 00    	pushl  0x806010
  801bc8:	68 00 60 80 00       	push   $0x806000
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	e8 47 ef ff ff       	call   800b1c <memmove>
		*addrlen = ret->ret_addrlen;
  801bd5:	a1 10 60 80 00       	mov    0x806010,%eax
  801bda:	89 06                	mov    %eax,(%esi)
  801bdc:	83 c4 10             	add    $0x10,%esp
	return r;
  801bdf:	eb d5                	jmp    801bb6 <nsipc_accept+0x27>

00801be1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bf3:	53                   	push   %ebx
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	68 04 60 80 00       	push   $0x806004
  801bfc:	e8 1b ef ff ff       	call   800b1c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c01:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c07:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0c:	e8 32 ff ff ff       	call   801b43 <nsipc>
}
  801c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c27:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c2c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c31:	e8 0d ff ff ff       	call   801b43 <nsipc>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <nsipc_close>:

int
nsipc_close(int s)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c46:	b8 04 00 00 00       	mov    $0x4,%eax
  801c4b:	e8 f3 fe ff ff       	call   801b43 <nsipc>
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	53                   	push   %ebx
  801c56:	83 ec 08             	sub    $0x8,%esp
  801c59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c64:	53                   	push   %ebx
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	68 04 60 80 00       	push   $0x806004
  801c6d:	e8 aa ee ff ff       	call   800b1c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c72:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c78:	b8 05 00 00 00       	mov    $0x5,%eax
  801c7d:	e8 c1 fe ff ff       	call   801b43 <nsipc>
}
  801c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c9d:	b8 06 00 00 00       	mov    $0x6,%eax
  801ca2:	e8 9c fe ff ff       	call   801b43 <nsipc>
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	56                   	push   %esi
  801cad:	53                   	push   %ebx
  801cae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cb9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cc7:	b8 07 00 00 00       	mov    $0x7,%eax
  801ccc:	e8 72 fe ff ff       	call   801b43 <nsipc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 1f                	js     801cf6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cd7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cdc:	7f 21                	jg     801cff <nsipc_recv+0x56>
  801cde:	39 c6                	cmp    %eax,%esi
  801ce0:	7c 1d                	jl     801cff <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	50                   	push   %eax
  801ce6:	68 00 60 80 00       	push   $0x806000
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	e8 29 ee ff ff       	call   800b1c <memmove>
  801cf3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cff:	68 db 2b 80 00       	push   $0x802bdb
  801d04:	68 a3 2b 80 00       	push   $0x802ba3
  801d09:	6a 62                	push   $0x62
  801d0b:	68 f0 2b 80 00       	push   $0x802bf0
  801d10:	e8 4b 05 00 00       	call   802260 <_panic>

00801d15 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	53                   	push   %ebx
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d27:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d2d:	7f 2e                	jg     801d5d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d2f:	83 ec 04             	sub    $0x4,%esp
  801d32:	53                   	push   %ebx
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	68 0c 60 80 00       	push   $0x80600c
  801d3b:	e8 dc ed ff ff       	call   800b1c <memmove>
	nsipcbuf.send.req_size = size;
  801d40:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d4e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d53:	e8 eb fd ff ff       	call   801b43 <nsipc>
}
  801d58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    
	assert(size < 1600);
  801d5d:	68 fc 2b 80 00       	push   $0x802bfc
  801d62:	68 a3 2b 80 00       	push   $0x802ba3
  801d67:	6a 6d                	push   $0x6d
  801d69:	68 f0 2b 80 00       	push   $0x802bf0
  801d6e:	e8 ed 04 00 00       	call   802260 <_panic>

00801d73 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d84:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d89:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d91:	b8 09 00 00 00       	mov    $0x9,%eax
  801d96:	e8 a8 fd ff ff       	call   801b43 <nsipc>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	e8 6a f3 ff ff       	call   80111a <fd2data>
  801db0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801db2:	83 c4 08             	add    $0x8,%esp
  801db5:	68 08 2c 80 00       	push   $0x802c08
  801dba:	53                   	push   %ebx
  801dbb:	e8 ce eb ff ff       	call   80098e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dc0:	8b 46 04             	mov    0x4(%esi),%eax
  801dc3:	2b 06                	sub    (%esi),%eax
  801dc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dd2:	00 00 00 
	stat->st_dev = &devpipe;
  801dd5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ddc:	30 80 00 
	return 0;
}
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	53                   	push   %ebx
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801df5:	53                   	push   %ebx
  801df6:	6a 00                	push   $0x0
  801df8:	e8 08 f0 ff ff       	call   800e05 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dfd:	89 1c 24             	mov    %ebx,(%esp)
  801e00:	e8 15 f3 ff ff       	call   80111a <fd2data>
  801e05:	83 c4 08             	add    $0x8,%esp
  801e08:	50                   	push   %eax
  801e09:	6a 00                	push   $0x0
  801e0b:	e8 f5 ef ff ff       	call   800e05 <sys_page_unmap>
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <_pipeisclosed>:
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	57                   	push   %edi
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 1c             	sub    $0x1c,%esp
  801e1e:	89 c7                	mov    %eax,%edi
  801e20:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e22:	a1 08 40 80 00       	mov    0x804008,%eax
  801e27:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	57                   	push   %edi
  801e2e:	e8 8e 05 00 00       	call   8023c1 <pageref>
  801e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e36:	89 34 24             	mov    %esi,(%esp)
  801e39:	e8 83 05 00 00       	call   8023c1 <pageref>
		nn = thisenv->env_runs;
  801e3e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e44:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	39 cb                	cmp    %ecx,%ebx
  801e4c:	74 1b                	je     801e69 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e4e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e51:	75 cf                	jne    801e22 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e53:	8b 42 58             	mov    0x58(%edx),%eax
  801e56:	6a 01                	push   $0x1
  801e58:	50                   	push   %eax
  801e59:	53                   	push   %ebx
  801e5a:	68 0f 2c 80 00       	push   $0x802c0f
  801e5f:	e8 cb e3 ff ff       	call   80022f <cprintf>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	eb b9                	jmp    801e22 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e69:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6c:	0f 94 c0             	sete   %al
  801e6f:	0f b6 c0             	movzbl %al,%eax
}
  801e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5f                   	pop    %edi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <devpipe_write>:
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	57                   	push   %edi
  801e7e:	56                   	push   %esi
  801e7f:	53                   	push   %ebx
  801e80:	83 ec 28             	sub    $0x28,%esp
  801e83:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e86:	56                   	push   %esi
  801e87:	e8 8e f2 ff ff       	call   80111a <fd2data>
  801e8c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	bf 00 00 00 00       	mov    $0x0,%edi
  801e96:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e99:	74 4f                	je     801eea <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e9b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9e:	8b 0b                	mov    (%ebx),%ecx
  801ea0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ea3:	39 d0                	cmp    %edx,%eax
  801ea5:	72 14                	jb     801ebb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ea7:	89 da                	mov    %ebx,%edx
  801ea9:	89 f0                	mov    %esi,%eax
  801eab:	e8 65 ff ff ff       	call   801e15 <_pipeisclosed>
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	75 3b                	jne    801eef <devpipe_write+0x75>
			sys_yield();
  801eb4:	e8 a8 ee ff ff       	call   800d61 <sys_yield>
  801eb9:	eb e0                	jmp    801e9b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ebe:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ec2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ec5:	89 c2                	mov    %eax,%edx
  801ec7:	c1 fa 1f             	sar    $0x1f,%edx
  801eca:	89 d1                	mov    %edx,%ecx
  801ecc:	c1 e9 1b             	shr    $0x1b,%ecx
  801ecf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ed2:	83 e2 1f             	and    $0x1f,%edx
  801ed5:	29 ca                	sub    %ecx,%edx
  801ed7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801edb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801edf:	83 c0 01             	add    $0x1,%eax
  801ee2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ee5:	83 c7 01             	add    $0x1,%edi
  801ee8:	eb ac                	jmp    801e96 <devpipe_write+0x1c>
	return i;
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	eb 05                	jmp    801ef4 <devpipe_write+0x7a>
				return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <devpipe_read>:
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	57                   	push   %edi
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
  801f02:	83 ec 18             	sub    $0x18,%esp
  801f05:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f08:	57                   	push   %edi
  801f09:	e8 0c f2 ff ff       	call   80111a <fd2data>
  801f0e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	be 00 00 00 00       	mov    $0x0,%esi
  801f18:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f1b:	75 14                	jne    801f31 <devpipe_read+0x35>
	return i;
  801f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f20:	eb 02                	jmp    801f24 <devpipe_read+0x28>
				return i;
  801f22:	89 f0                	mov    %esi,%eax
}
  801f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
			sys_yield();
  801f2c:	e8 30 ee ff ff       	call   800d61 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f31:	8b 03                	mov    (%ebx),%eax
  801f33:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f36:	75 18                	jne    801f50 <devpipe_read+0x54>
			if (i > 0)
  801f38:	85 f6                	test   %esi,%esi
  801f3a:	75 e6                	jne    801f22 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f3c:	89 da                	mov    %ebx,%edx
  801f3e:	89 f8                	mov    %edi,%eax
  801f40:	e8 d0 fe ff ff       	call   801e15 <_pipeisclosed>
  801f45:	85 c0                	test   %eax,%eax
  801f47:	74 e3                	je     801f2c <devpipe_read+0x30>
				return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	eb d4                	jmp    801f24 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f50:	99                   	cltd   
  801f51:	c1 ea 1b             	shr    $0x1b,%edx
  801f54:	01 d0                	add    %edx,%eax
  801f56:	83 e0 1f             	and    $0x1f,%eax
  801f59:	29 d0                	sub    %edx,%eax
  801f5b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f63:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f66:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f69:	83 c6 01             	add    $0x1,%esi
  801f6c:	eb aa                	jmp    801f18 <devpipe_read+0x1c>

00801f6e <pipe>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	56                   	push   %esi
  801f72:	53                   	push   %ebx
  801f73:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f79:	50                   	push   %eax
  801f7a:	e8 b2 f1 ff ff       	call   801131 <fd_alloc>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	0f 88 23 01 00 00    	js     8020af <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	68 07 04 00 00       	push   $0x407
  801f94:	ff 75 f4             	pushl  -0xc(%ebp)
  801f97:	6a 00                	push   $0x0
  801f99:	e8 e2 ed ff ff       	call   800d80 <sys_page_alloc>
  801f9e:	89 c3                	mov    %eax,%ebx
  801fa0:	83 c4 10             	add    $0x10,%esp
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 88 04 01 00 00    	js     8020af <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	e8 7a f1 ff ff       	call   801131 <fd_alloc>
  801fb7:	89 c3                	mov    %eax,%ebx
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	0f 88 db 00 00 00    	js     80209f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc4:	83 ec 04             	sub    $0x4,%esp
  801fc7:	68 07 04 00 00       	push   $0x407
  801fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcf:	6a 00                	push   $0x0
  801fd1:	e8 aa ed ff ff       	call   800d80 <sys_page_alloc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	0f 88 bc 00 00 00    	js     80209f <pipe+0x131>
	va = fd2data(fd0);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe9:	e8 2c f1 ff ff       	call   80111a <fd2data>
  801fee:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff0:	83 c4 0c             	add    $0xc,%esp
  801ff3:	68 07 04 00 00       	push   $0x407
  801ff8:	50                   	push   %eax
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 80 ed ff ff       	call   800d80 <sys_page_alloc>
  802000:	89 c3                	mov    %eax,%ebx
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	0f 88 82 00 00 00    	js     80208f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	ff 75 f0             	pushl  -0x10(%ebp)
  802013:	e8 02 f1 ff ff       	call   80111a <fd2data>
  802018:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80201f:	50                   	push   %eax
  802020:	6a 00                	push   $0x0
  802022:	56                   	push   %esi
  802023:	6a 00                	push   $0x0
  802025:	e8 99 ed ff ff       	call   800dc3 <sys_page_map>
  80202a:	89 c3                	mov    %eax,%ebx
  80202c:	83 c4 20             	add    $0x20,%esp
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 4e                	js     802081 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802033:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80203d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802040:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802047:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802056:	83 ec 0c             	sub    $0xc,%esp
  802059:	ff 75 f4             	pushl  -0xc(%ebp)
  80205c:	e8 a9 f0 ff ff       	call   80110a <fd2num>
  802061:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802064:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802066:	83 c4 04             	add    $0x4,%esp
  802069:	ff 75 f0             	pushl  -0x10(%ebp)
  80206c:	e8 99 f0 ff ff       	call   80110a <fd2num>
  802071:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802074:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80207f:	eb 2e                	jmp    8020af <pipe+0x141>
	sys_page_unmap(0, va);
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	56                   	push   %esi
  802085:	6a 00                	push   $0x0
  802087:	e8 79 ed ff ff       	call   800e05 <sys_page_unmap>
  80208c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80208f:	83 ec 08             	sub    $0x8,%esp
  802092:	ff 75 f0             	pushl  -0x10(%ebp)
  802095:	6a 00                	push   $0x0
  802097:	e8 69 ed ff ff       	call   800e05 <sys_page_unmap>
  80209c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80209f:	83 ec 08             	sub    $0x8,%esp
  8020a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a5:	6a 00                	push   $0x0
  8020a7:	e8 59 ed ff ff       	call   800e05 <sys_page_unmap>
  8020ac:	83 c4 10             	add    $0x10,%esp
}
  8020af:	89 d8                	mov    %ebx,%eax
  8020b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b4:	5b                   	pop    %ebx
  8020b5:	5e                   	pop    %esi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    

008020b8 <pipeisclosed>:
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c1:	50                   	push   %eax
  8020c2:	ff 75 08             	pushl  0x8(%ebp)
  8020c5:	e8 b9 f0 ff ff       	call   801183 <fd_lookup>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 18                	js     8020e9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d7:	e8 3e f0 ff ff       	call   80111a <fd2data>
	return _pipeisclosed(fd, p);
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	e8 2f fd ff ff       	call   801e15 <_pipeisclosed>
  8020e6:	83 c4 10             	add    $0x10,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	c3                   	ret    

008020f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020f7:	68 27 2c 80 00       	push   $0x802c27
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	e8 8a e8 ff ff       	call   80098e <strcpy>
	return 0;
}
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <devcons_write>:
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	57                   	push   %edi
  80210f:	56                   	push   %esi
  802110:	53                   	push   %ebx
  802111:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802117:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80211c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802122:	3b 75 10             	cmp    0x10(%ebp),%esi
  802125:	73 31                	jae    802158 <devcons_write+0x4d>
		m = n - tot;
  802127:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80212a:	29 f3                	sub    %esi,%ebx
  80212c:	83 fb 7f             	cmp    $0x7f,%ebx
  80212f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802134:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	53                   	push   %ebx
  80213b:	89 f0                	mov    %esi,%eax
  80213d:	03 45 0c             	add    0xc(%ebp),%eax
  802140:	50                   	push   %eax
  802141:	57                   	push   %edi
  802142:	e8 d5 e9 ff ff       	call   800b1c <memmove>
		sys_cputs(buf, m);
  802147:	83 c4 08             	add    $0x8,%esp
  80214a:	53                   	push   %ebx
  80214b:	57                   	push   %edi
  80214c:	e8 73 eb ff ff       	call   800cc4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802151:	01 de                	add    %ebx,%esi
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	eb ca                	jmp    802122 <devcons_write+0x17>
}
  802158:	89 f0                	mov    %esi,%eax
  80215a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    

00802162 <devcons_read>:
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80216d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802171:	74 21                	je     802194 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802173:	e8 6a eb ff ff       	call   800ce2 <sys_cgetc>
  802178:	85 c0                	test   %eax,%eax
  80217a:	75 07                	jne    802183 <devcons_read+0x21>
		sys_yield();
  80217c:	e8 e0 eb ff ff       	call   800d61 <sys_yield>
  802181:	eb f0                	jmp    802173 <devcons_read+0x11>
	if (c < 0)
  802183:	78 0f                	js     802194 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802185:	83 f8 04             	cmp    $0x4,%eax
  802188:	74 0c                	je     802196 <devcons_read+0x34>
	*(char*)vbuf = c;
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	88 02                	mov    %al,(%edx)
	return 1;
  80218f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    
		return 0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	eb f7                	jmp    802194 <devcons_read+0x32>

0080219d <cputchar>:
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021a9:	6a 01                	push   $0x1
  8021ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ae:	50                   	push   %eax
  8021af:	e8 10 eb ff ff       	call   800cc4 <sys_cputs>
}
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <getchar>:
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021bf:	6a 01                	push   $0x1
  8021c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c4:	50                   	push   %eax
  8021c5:	6a 00                	push   $0x0
  8021c7:	e8 27 f2 ff ff       	call   8013f3 <read>
	if (r < 0)
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	78 06                	js     8021d9 <getchar+0x20>
	if (r < 1)
  8021d3:	74 06                	je     8021db <getchar+0x22>
	return c;
  8021d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    
		return -E_EOF;
  8021db:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021e0:	eb f7                	jmp    8021d9 <getchar+0x20>

008021e2 <iscons>:
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021eb:	50                   	push   %eax
  8021ec:	ff 75 08             	pushl  0x8(%ebp)
  8021ef:	e8 8f ef ff ff       	call   801183 <fd_lookup>
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 11                	js     80220c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802204:	39 10                	cmp    %edx,(%eax)
  802206:	0f 94 c0             	sete   %al
  802209:	0f b6 c0             	movzbl %al,%eax
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <opencons>:
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802217:	50                   	push   %eax
  802218:	e8 14 ef ff ff       	call   801131 <fd_alloc>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	85 c0                	test   %eax,%eax
  802222:	78 3a                	js     80225e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	68 07 04 00 00       	push   $0x407
  80222c:	ff 75 f4             	pushl  -0xc(%ebp)
  80222f:	6a 00                	push   $0x0
  802231:	e8 4a eb ff ff       	call   800d80 <sys_page_alloc>
  802236:	83 c4 10             	add    $0x10,%esp
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 21                	js     80225e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802246:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	50                   	push   %eax
  802256:	e8 af ee ff ff       	call   80110a <fd2num>
  80225b:	83 c4 10             	add    $0x10,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802265:	a1 08 40 80 00       	mov    0x804008,%eax
  80226a:	8b 40 48             	mov    0x48(%eax),%eax
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	68 58 2c 80 00       	push   $0x802c58
  802275:	50                   	push   %eax
  802276:	68 d0 26 80 00       	push   $0x8026d0
  80227b:	e8 af df ff ff       	call   80022f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802280:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802283:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802289:	e8 b4 ea ff ff       	call   800d42 <sys_getenvid>
  80228e:	83 c4 04             	add    $0x4,%esp
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	ff 75 08             	pushl  0x8(%ebp)
  802297:	56                   	push   %esi
  802298:	50                   	push   %eax
  802299:	68 34 2c 80 00       	push   $0x802c34
  80229e:	e8 8c df ff ff       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022a3:	83 c4 18             	add    $0x18,%esp
  8022a6:	53                   	push   %ebx
  8022a7:	ff 75 10             	pushl  0x10(%ebp)
  8022aa:	e8 2f df ff ff       	call   8001de <vcprintf>
	cprintf("\n");
  8022af:	c7 04 24 94 26 80 00 	movl   $0x802694,(%esp)
  8022b6:	e8 74 df ff ff       	call   80022f <cprintf>
  8022bb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022be:	cc                   	int3   
  8022bf:	eb fd                	jmp    8022be <_panic+0x5e>

008022c1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022cf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022d1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022d6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022d9:	83 ec 0c             	sub    $0xc,%esp
  8022dc:	50                   	push   %eax
  8022dd:	e8 4e ec ff ff       	call   800f30 <sys_ipc_recv>
	if(ret < 0){
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	78 2b                	js     802314 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022e9:	85 f6                	test   %esi,%esi
  8022eb:	74 0a                	je     8022f7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f2:	8b 40 78             	mov    0x78(%eax),%eax
  8022f5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022f7:	85 db                	test   %ebx,%ebx
  8022f9:	74 0a                	je     802305 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022fb:	a1 08 40 80 00       	mov    0x804008,%eax
  802300:	8b 40 7c             	mov    0x7c(%eax),%eax
  802303:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802305:	a1 08 40 80 00       	mov    0x804008,%eax
  80230a:	8b 40 74             	mov    0x74(%eax),%eax
}
  80230d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    
		if(from_env_store)
  802314:	85 f6                	test   %esi,%esi
  802316:	74 06                	je     80231e <ipc_recv+0x5d>
			*from_env_store = 0;
  802318:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80231e:	85 db                	test   %ebx,%ebx
  802320:	74 eb                	je     80230d <ipc_recv+0x4c>
			*perm_store = 0;
  802322:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802328:	eb e3                	jmp    80230d <ipc_recv+0x4c>

0080232a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	57                   	push   %edi
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	8b 7d 08             	mov    0x8(%ebp),%edi
  802336:	8b 75 0c             	mov    0xc(%ebp),%esi
  802339:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80233c:	85 db                	test   %ebx,%ebx
  80233e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802343:	0f 44 d8             	cmove  %eax,%ebx
  802346:	eb 05                	jmp    80234d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802348:	e8 14 ea ff ff       	call   800d61 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80234d:	ff 75 14             	pushl  0x14(%ebp)
  802350:	53                   	push   %ebx
  802351:	56                   	push   %esi
  802352:	57                   	push   %edi
  802353:	e8 b5 eb ff ff       	call   800f0d <sys_ipc_try_send>
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	74 1b                	je     80237a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80235f:	79 e7                	jns    802348 <ipc_send+0x1e>
  802361:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802364:	74 e2                	je     802348 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	68 5f 2c 80 00       	push   $0x802c5f
  80236e:	6a 46                	push   $0x46
  802370:	68 74 2c 80 00       	push   $0x802c74
  802375:	e8 e6 fe ff ff       	call   802260 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80237a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5e                   	pop    %esi
  80237f:	5f                   	pop    %edi
  802380:	5d                   	pop    %ebp
  802381:	c3                   	ret    

00802382 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802388:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80238d:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802393:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802399:	8b 52 50             	mov    0x50(%edx),%edx
  80239c:	39 ca                	cmp    %ecx,%edx
  80239e:	74 11                	je     8023b1 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023a0:	83 c0 01             	add    $0x1,%eax
  8023a3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023a8:	75 e3                	jne    80238d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023af:	eb 0e                	jmp    8023bf <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023b1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023bc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    

008023c1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c7:	89 d0                	mov    %edx,%eax
  8023c9:	c1 e8 16             	shr    $0x16,%eax
  8023cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023d8:	f6 c1 01             	test   $0x1,%cl
  8023db:	74 1d                	je     8023fa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023dd:	c1 ea 0c             	shr    $0xc,%edx
  8023e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e7:	f6 c2 01             	test   $0x1,%dl
  8023ea:	74 0e                	je     8023fa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ec:	c1 ea 0c             	shr    $0xc,%edx
  8023ef:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f6:	ef 
  8023f7:	0f b7 c0             	movzwl %ax,%eax
}
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80240b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80240f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802413:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802417:	85 d2                	test   %edx,%edx
  802419:	75 4d                	jne    802468 <__udivdi3+0x68>
  80241b:	39 f3                	cmp    %esi,%ebx
  80241d:	76 19                	jbe    802438 <__udivdi3+0x38>
  80241f:	31 ff                	xor    %edi,%edi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f2                	mov    %esi,%edx
  802425:	f7 f3                	div    %ebx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 d9                	mov    %ebx,%ecx
  80243a:	85 db                	test   %ebx,%ebx
  80243c:	75 0b                	jne    802449 <__udivdi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f3                	div    %ebx
  802447:	89 c1                	mov    %eax,%ecx
  802449:	31 d2                	xor    %edx,%edx
  80244b:	89 f0                	mov    %esi,%eax
  80244d:	f7 f1                	div    %ecx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	89 e8                	mov    %ebp,%eax
  802453:	89 f7                	mov    %esi,%edi
  802455:	f7 f1                	div    %ecx
  802457:	89 fa                	mov    %edi,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	39 f2                	cmp    %esi,%edx
  80246a:	77 1c                	ja     802488 <__udivdi3+0x88>
  80246c:	0f bd fa             	bsr    %edx,%edi
  80246f:	83 f7 1f             	xor    $0x1f,%edi
  802472:	75 2c                	jne    8024a0 <__udivdi3+0xa0>
  802474:	39 f2                	cmp    %esi,%edx
  802476:	72 06                	jb     80247e <__udivdi3+0x7e>
  802478:	31 c0                	xor    %eax,%eax
  80247a:	39 eb                	cmp    %ebp,%ebx
  80247c:	77 a9                	ja     802427 <__udivdi3+0x27>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	eb a2                	jmp    802427 <__udivdi3+0x27>
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	31 ff                	xor    %edi,%edi
  80248a:	31 c0                	xor    %eax,%eax
  80248c:	89 fa                	mov    %edi,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 f9                	mov    %edi,%ecx
  8024a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a7:	29 f8                	sub    %edi,%eax
  8024a9:	d3 e2                	shl    %cl,%edx
  8024ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024af:	89 c1                	mov    %eax,%ecx
  8024b1:	89 da                	mov    %ebx,%edx
  8024b3:	d3 ea                	shr    %cl,%edx
  8024b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b9:	09 d1                	or     %edx,%ecx
  8024bb:	89 f2                	mov    %esi,%edx
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 f9                	mov    %edi,%ecx
  8024c3:	d3 e3                	shl    %cl,%ebx
  8024c5:	89 c1                	mov    %eax,%ecx
  8024c7:	d3 ea                	shr    %cl,%edx
  8024c9:	89 f9                	mov    %edi,%ecx
  8024cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024cf:	89 eb                	mov    %ebp,%ebx
  8024d1:	d3 e6                	shl    %cl,%esi
  8024d3:	89 c1                	mov    %eax,%ecx
  8024d5:	d3 eb                	shr    %cl,%ebx
  8024d7:	09 de                	or     %ebx,%esi
  8024d9:	89 f0                	mov    %esi,%eax
  8024db:	f7 74 24 08          	divl   0x8(%esp)
  8024df:	89 d6                	mov    %edx,%esi
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	f7 64 24 0c          	mull   0xc(%esp)
  8024e7:	39 d6                	cmp    %edx,%esi
  8024e9:	72 15                	jb     802500 <__udivdi3+0x100>
  8024eb:	89 f9                	mov    %edi,%ecx
  8024ed:	d3 e5                	shl    %cl,%ebp
  8024ef:	39 c5                	cmp    %eax,%ebp
  8024f1:	73 04                	jae    8024f7 <__udivdi3+0xf7>
  8024f3:	39 d6                	cmp    %edx,%esi
  8024f5:	74 09                	je     802500 <__udivdi3+0x100>
  8024f7:	89 d8                	mov    %ebx,%eax
  8024f9:	31 ff                	xor    %edi,%edi
  8024fb:	e9 27 ff ff ff       	jmp    802427 <__udivdi3+0x27>
  802500:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802503:	31 ff                	xor    %edi,%edi
  802505:	e9 1d ff ff ff       	jmp    802427 <__udivdi3+0x27>
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__umoddi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80251b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80251f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	89 da                	mov    %ebx,%edx
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 43                	jne    802570 <__umoddi3+0x60>
  80252d:	39 df                	cmp    %ebx,%edi
  80252f:	76 17                	jbe    802548 <__umoddi3+0x38>
  802531:	89 f0                	mov    %esi,%eax
  802533:	f7 f7                	div    %edi
  802535:	89 d0                	mov    %edx,%eax
  802537:	31 d2                	xor    %edx,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	89 fd                	mov    %edi,%ebp
  80254a:	85 ff                	test   %edi,%edi
  80254c:	75 0b                	jne    802559 <__umoddi3+0x49>
  80254e:	b8 01 00 00 00       	mov    $0x1,%eax
  802553:	31 d2                	xor    %edx,%edx
  802555:	f7 f7                	div    %edi
  802557:	89 c5                	mov    %eax,%ebp
  802559:	89 d8                	mov    %ebx,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	f7 f5                	div    %ebp
  80255f:	89 f0                	mov    %esi,%eax
  802561:	f7 f5                	div    %ebp
  802563:	89 d0                	mov    %edx,%eax
  802565:	eb d0                	jmp    802537 <__umoddi3+0x27>
  802567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256e:	66 90                	xchg   %ax,%ax
  802570:	89 f1                	mov    %esi,%ecx
  802572:	39 d8                	cmp    %ebx,%eax
  802574:	76 0a                	jbe    802580 <__umoddi3+0x70>
  802576:	89 f0                	mov    %esi,%eax
  802578:	83 c4 1c             	add    $0x1c,%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	0f bd e8             	bsr    %eax,%ebp
  802583:	83 f5 1f             	xor    $0x1f,%ebp
  802586:	75 20                	jne    8025a8 <__umoddi3+0x98>
  802588:	39 d8                	cmp    %ebx,%eax
  80258a:	0f 82 b0 00 00 00    	jb     802640 <__umoddi3+0x130>
  802590:	39 f7                	cmp    %esi,%edi
  802592:	0f 86 a8 00 00 00    	jbe    802640 <__umoddi3+0x130>
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8025af:	29 ea                	sub    %ebp,%edx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b7:	89 d1                	mov    %edx,%ecx
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	d3 e8                	shr    %cl,%eax
  8025bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025c9:	09 c1                	or     %eax,%ecx
  8025cb:	89 d8                	mov    %ebx,%eax
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 e9                	mov    %ebp,%ecx
  8025d3:	d3 e7                	shl    %cl,%edi
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	d3 e8                	shr    %cl,%eax
  8025d9:	89 e9                	mov    %ebp,%ecx
  8025db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025df:	d3 e3                	shl    %cl,%ebx
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	89 d1                	mov    %edx,%ecx
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	d3 e6                	shl    %cl,%esi
  8025ef:	09 d8                	or     %ebx,%eax
  8025f1:	f7 74 24 08          	divl   0x8(%esp)
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	89 f3                	mov    %esi,%ebx
  8025f9:	f7 64 24 0c          	mull   0xc(%esp)
  8025fd:	89 c6                	mov    %eax,%esi
  8025ff:	89 d7                	mov    %edx,%edi
  802601:	39 d1                	cmp    %edx,%ecx
  802603:	72 06                	jb     80260b <__umoddi3+0xfb>
  802605:	75 10                	jne    802617 <__umoddi3+0x107>
  802607:	39 c3                	cmp    %eax,%ebx
  802609:	73 0c                	jae    802617 <__umoddi3+0x107>
  80260b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80260f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802613:	89 d7                	mov    %edx,%edi
  802615:	89 c6                	mov    %eax,%esi
  802617:	89 ca                	mov    %ecx,%edx
  802619:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261e:	29 f3                	sub    %esi,%ebx
  802620:	19 fa                	sbb    %edi,%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	d3 e0                	shl    %cl,%eax
  802626:	89 e9                	mov    %ebp,%ecx
  802628:	d3 eb                	shr    %cl,%ebx
  80262a:	d3 ea                	shr    %cl,%edx
  80262c:	09 d8                	or     %ebx,%eax
  80262e:	83 c4 1c             	add    $0x1c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263d:	8d 76 00             	lea    0x0(%esi),%esi
  802640:	89 da                	mov    %ebx,%edx
  802642:	29 fe                	sub    %edi,%esi
  802644:	19 c2                	sbb    %eax,%edx
  802646:	89 f1                	mov    %esi,%ecx
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	e9 4b ff ff ff       	jmp    80259a <__umoddi3+0x8a>
