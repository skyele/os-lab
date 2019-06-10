
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
  800043:	e8 e5 01 00 00       	call   80022d <cprintf>
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("in %s\n", __FUNCTION__);
  800048:	83 c4 08             	add    $0x8,%esp
  80004b:	68 70 26 80 00       	push   $0x802670
  800050:	68 d4 26 80 00       	push   $0x8026d4
  800055:	e8 d3 01 00 00       	call   80022d <cprintf>
	sys_env_destroy(sys_getenvid());
  80005a:	e8 e1 0c 00 00       	call   800d40 <sys_getenvid>
  80005f:	89 04 24             	mov    %eax,(%esp)
  800062:	e8 98 0c 00 00       	call   800cff <sys_env_destroy>
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
  800077:	e8 f7 0f 00 00       	call   801073 <set_pgfault_handler>
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
  80009e:	e8 9d 0c 00 00       	call   800d40 <sys_getenvid>
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
  8000c3:	74 21                	je     8000e6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000c5:	89 d1                	mov    %edx,%ecx
  8000c7:	c1 e1 07             	shl    $0x7,%ecx
  8000ca:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000d0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000d3:	39 c1                	cmp    %eax,%ecx
  8000d5:	75 e3                	jne    8000ba <libmain+0x2f>
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	c1 e3 07             	shl    $0x7,%ebx
  8000dc:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000e2:	89 fe                	mov    %edi,%esi
  8000e4:	eb d4                	jmp    8000ba <libmain+0x2f>
  8000e6:	89 f0                	mov    %esi,%eax
  8000e8:	84 c0                	test   %al,%al
  8000ea:	74 06                	je     8000f2 <libmain+0x67>
  8000ec:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f6:	7e 0a                	jle    800102 <libmain+0x77>
		binaryname = argv[0];
  8000f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800102:	a1 08 40 80 00       	mov    0x804008,%eax
  800107:	8b 40 48             	mov    0x48(%eax),%eax
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	50                   	push   %eax
  80010e:	68 78 26 80 00       	push   $0x802678
  800113:	e8 15 01 00 00       	call   80022d <cprintf>
	cprintf("before umain\n");
  800118:	c7 04 24 96 26 80 00 	movl   $0x802696,(%esp)
  80011f:	e8 09 01 00 00       	call   80022d <cprintf>
	// call user main routine
	umain(argc, argv);
  800124:	83 c4 08             	add    $0x8,%esp
  800127:	ff 75 0c             	pushl  0xc(%ebp)
  80012a:	ff 75 08             	pushl  0x8(%ebp)
  80012d:	e8 3a ff ff ff       	call   80006c <umain>
	cprintf("after umain\n");
  800132:	c7 04 24 a4 26 80 00 	movl   $0x8026a4,(%esp)
  800139:	e8 ef 00 00 00       	call   80022d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80013e:	a1 08 40 80 00       	mov    0x804008,%eax
  800143:	8b 40 48             	mov    0x48(%eax),%eax
  800146:	83 c4 08             	add    $0x8,%esp
  800149:	50                   	push   %eax
  80014a:	68 b1 26 80 00       	push   $0x8026b1
  80014f:	e8 d9 00 00 00       	call   80022d <cprintf>
	// exit gracefully
	exit();
  800154:	e8 0b 00 00 00       	call   800164 <exit>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015f:	5b                   	pop    %ebx
  800160:	5e                   	pop    %esi
  800161:	5f                   	pop    %edi
  800162:	5d                   	pop    %ebp
  800163:	c3                   	ret    

00800164 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80016a:	a1 08 40 80 00       	mov    0x804008,%eax
  80016f:	8b 40 48             	mov    0x48(%eax),%eax
  800172:	68 dc 26 80 00       	push   $0x8026dc
  800177:	50                   	push   %eax
  800178:	68 d0 26 80 00       	push   $0x8026d0
  80017d:	e8 ab 00 00 00       	call   80022d <cprintf>
	close_all();
  800182:	e8 59 11 00 00       	call   8012e0 <close_all>
	sys_env_destroy(0);
  800187:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80018e:	e8 6c 0b 00 00       	call   800cff <sys_env_destroy>
}
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	53                   	push   %ebx
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a2:	8b 13                	mov    (%ebx),%edx
  8001a4:	8d 42 01             	lea    0x1(%edx),%eax
  8001a7:	89 03                	mov    %eax,(%ebx)
  8001a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b5:	74 09                	je     8001c0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	68 ff 00 00 00       	push   $0xff
  8001c8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 f1 0a 00 00       	call   800cc2 <sys_cputs>
		b->idx = 0;
  8001d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	eb db                	jmp    8001b7 <putch+0x1f>

008001dc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ec:	00 00 00 
	b.cnt = 0;
  8001ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	68 98 01 80 00       	push   $0x800198
  80020b:	e8 4a 01 00 00       	call   80035a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800210:	83 c4 08             	add    $0x8,%esp
  800213:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800219:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021f:	50                   	push   %eax
  800220:	e8 9d 0a 00 00       	call   800cc2 <sys_cputs>

	return b.cnt;
}
  800225:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800233:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800236:	50                   	push   %eax
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	e8 9d ff ff ff       	call   8001dc <vcprintf>
	va_end(ap);

	return cnt;
}
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 1c             	sub    $0x1c,%esp
  80024a:	89 c6                	mov    %eax,%esi
  80024c:	89 d7                	mov    %edx,%edi
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	8b 55 0c             	mov    0xc(%ebp),%edx
  800254:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800257:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80025a:	8b 45 10             	mov    0x10(%ebp),%eax
  80025d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800260:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800264:	74 2c                	je     800292 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800266:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800269:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800270:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800273:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800276:	39 c2                	cmp    %eax,%edx
  800278:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80027b:	73 43                	jae    8002c0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80027d:	83 eb 01             	sub    $0x1,%ebx
  800280:	85 db                	test   %ebx,%ebx
  800282:	7e 6c                	jle    8002f0 <printnum+0xaf>
				putch(padc, putdat);
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	57                   	push   %edi
  800288:	ff 75 18             	pushl  0x18(%ebp)
  80028b:	ff d6                	call   *%esi
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	eb eb                	jmp    80027d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 20                	push   $0x20
  800297:	6a 00                	push   $0x0
  800299:	50                   	push   %eax
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	89 fa                	mov    %edi,%edx
  8002a2:	89 f0                	mov    %esi,%eax
  8002a4:	e8 98 ff ff ff       	call   800241 <printnum>
		while (--width > 0)
  8002a9:	83 c4 20             	add    $0x20,%esp
  8002ac:	83 eb 01             	sub    $0x1,%ebx
  8002af:	85 db                	test   %ebx,%ebx
  8002b1:	7e 65                	jle    800318 <printnum+0xd7>
			putch(padc, putdat);
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	57                   	push   %edi
  8002b7:	6a 20                	push   $0x20
  8002b9:	ff d6                	call   *%esi
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	eb ec                	jmp    8002ac <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 18             	pushl  0x18(%ebp)
  8002c6:	83 eb 01             	sub    $0x1,%ebx
  8002c9:	53                   	push   %ebx
  8002ca:	50                   	push   %eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002da:	e8 21 21 00 00       	call   802400 <__udivdi3>
  8002df:	83 c4 18             	add    $0x18,%esp
  8002e2:	52                   	push   %edx
  8002e3:	50                   	push   %eax
  8002e4:	89 fa                	mov    %edi,%edx
  8002e6:	89 f0                	mov    %esi,%eax
  8002e8:	e8 54 ff ff ff       	call   800241 <printnum>
  8002ed:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	57                   	push   %edi
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800300:	ff 75 e0             	pushl  -0x20(%ebp)
  800303:	e8 08 22 00 00       	call   802510 <__umoddi3>
  800308:	83 c4 14             	add    $0x14,%esp
  80030b:	0f be 80 e1 26 80 00 	movsbl 0x8026e1(%eax),%eax
  800312:	50                   	push   %eax
  800313:	ff d6                	call   *%esi
  800315:	83 c4 10             	add    $0x10,%esp
	}
}
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800326:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032a:	8b 10                	mov    (%eax),%edx
  80032c:	3b 50 04             	cmp    0x4(%eax),%edx
  80032f:	73 0a                	jae    80033b <sprintputch+0x1b>
		*b->buf++ = ch;
  800331:	8d 4a 01             	lea    0x1(%edx),%ecx
  800334:	89 08                	mov    %ecx,(%eax)
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	88 02                	mov    %al,(%edx)
}
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <printfmt>:
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800343:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800346:	50                   	push   %eax
  800347:	ff 75 10             	pushl  0x10(%ebp)
  80034a:	ff 75 0c             	pushl  0xc(%ebp)
  80034d:	ff 75 08             	pushl  0x8(%ebp)
  800350:	e8 05 00 00 00       	call   80035a <vprintfmt>
}
  800355:	83 c4 10             	add    $0x10,%esp
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <vprintfmt>:
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 3c             	sub    $0x3c,%esp
  800363:	8b 75 08             	mov    0x8(%ebp),%esi
  800366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800369:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036c:	e9 32 04 00 00       	jmp    8007a3 <vprintfmt+0x449>
		padc = ' ';
  800371:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800375:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80037c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800383:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80038a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800391:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800398:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8d 47 01             	lea    0x1(%edi),%eax
  8003a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a3:	0f b6 17             	movzbl (%edi),%edx
  8003a6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a9:	3c 55                	cmp    $0x55,%al
  8003ab:	0f 87 12 05 00 00    	ja     8008c3 <vprintfmt+0x569>
  8003b1:	0f b6 c0             	movzbl %al,%eax
  8003b4:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003be:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003c2:	eb d9                	jmp    80039d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003cb:	eb d0                	jmp    80039d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	0f b6 d2             	movzbl %dl,%edx
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	89 75 08             	mov    %esi,0x8(%ebp)
  8003db:	eb 03                	jmp    8003e0 <vprintfmt+0x86>
  8003dd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ea:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ed:	83 fe 09             	cmp    $0x9,%esi
  8003f0:	76 eb                	jbe    8003dd <vprintfmt+0x83>
  8003f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f8:	eb 14                	jmp    80040e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 40 04             	lea    0x4(%eax),%eax
  800408:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80040e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800412:	79 89                	jns    80039d <vprintfmt+0x43>
				width = precision, precision = -1;
  800414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800421:	e9 77 ff ff ff       	jmp    80039d <vprintfmt+0x43>
  800426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	0f 48 c1             	cmovs  %ecx,%eax
  80042e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800434:	e9 64 ff ff ff       	jmp    80039d <vprintfmt+0x43>
  800439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800443:	e9 55 ff ff ff       	jmp    80039d <vprintfmt+0x43>
			lflag++;
  800448:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044f:	e9 49 ff ff ff       	jmp    80039d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 78 04             	lea    0x4(%eax),%edi
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 30                	pushl  (%eax)
  800460:	ff d6                	call   *%esi
			break;
  800462:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800468:	e9 33 03 00 00       	jmp    8007a0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8d 78 04             	lea    0x4(%eax),%edi
  800473:	8b 00                	mov    (%eax),%eax
  800475:	99                   	cltd   
  800476:	31 d0                	xor    %edx,%eax
  800478:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	83 f8 11             	cmp    $0x11,%eax
  80047d:	7f 23                	jg     8004a2 <vprintfmt+0x148>
  80047f:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 b5 2b 80 00       	push   $0x802bb5
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 a6 fe ff ff       	call   80033d <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 fe 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 f9 26 80 00       	push   $0x8026f9
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 8e fe ff ff       	call   80033d <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b5:	e9 e6 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 c0 04             	add    $0x4,%eax
  8004c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004c8:	85 c9                	test   %ecx,%ecx
  8004ca:	b8 f2 26 80 00       	mov    $0x8026f2,%eax
  8004cf:	0f 45 c1             	cmovne %ecx,%eax
  8004d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d9:	7e 06                	jle    8004e1 <vprintfmt+0x187>
  8004db:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004df:	75 0d                	jne    8004ee <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ec:	eb 53                	jmp    800541 <vprintfmt+0x1e7>
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	e8 71 04 00 00       	call   80096b <strnlen>
  8004fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fd:	29 c1                	sub    %eax,%ecx
  8004ff:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800507:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80050e:	eb 0f                	jmp    80051f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	ff 75 e0             	pushl  -0x20(%ebp)
  800517:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800519:	83 ef 01             	sub    $0x1,%edi
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	85 ff                	test   %edi,%edi
  800521:	7f ed                	jg     800510 <vprintfmt+0x1b6>
  800523:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800526:	85 c9                	test   %ecx,%ecx
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	0f 49 c1             	cmovns %ecx,%eax
  800530:	29 c1                	sub    %eax,%ecx
  800532:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800535:	eb aa                	jmp    8004e1 <vprintfmt+0x187>
					putch(ch, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	52                   	push   %edx
  80053c:	ff d6                	call   *%esi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800544:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800546:	83 c7 01             	add    $0x1,%edi
  800549:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054d:	0f be d0             	movsbl %al,%edx
  800550:	85 d2                	test   %edx,%edx
  800552:	74 4b                	je     80059f <vprintfmt+0x245>
  800554:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800558:	78 06                	js     800560 <vprintfmt+0x206>
  80055a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80055e:	78 1e                	js     80057e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800560:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800564:	74 d1                	je     800537 <vprintfmt+0x1dd>
  800566:	0f be c0             	movsbl %al,%eax
  800569:	83 e8 20             	sub    $0x20,%eax
  80056c:	83 f8 5e             	cmp    $0x5e,%eax
  80056f:	76 c6                	jbe    800537 <vprintfmt+0x1dd>
					putch('?', putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	53                   	push   %ebx
  800575:	6a 3f                	push   $0x3f
  800577:	ff d6                	call   *%esi
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	eb c3                	jmp    800541 <vprintfmt+0x1e7>
  80057e:	89 cf                	mov    %ecx,%edi
  800580:	eb 0e                	jmp    800590 <vprintfmt+0x236>
				putch(' ', putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	53                   	push   %ebx
  800586:	6a 20                	push   $0x20
  800588:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80058a:	83 ef 01             	sub    $0x1,%edi
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	85 ff                	test   %edi,%edi
  800592:	7f ee                	jg     800582 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800594:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	e9 01 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
  80059f:	89 cf                	mov    %ecx,%edi
  8005a1:	eb ed                	jmp    800590 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005a6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005ad:	e9 eb fd ff ff       	jmp    80039d <vprintfmt+0x43>
	if (lflag >= 2)
  8005b2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b6:	7f 21                	jg     8005d9 <vprintfmt+0x27f>
	else if (lflag)
  8005b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005bc:	74 68                	je     800626 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c6:	89 c1                	mov    %eax,%ecx
  8005c8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d7:	eb 17                	jmp    8005f0 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 50 04             	mov    0x4(%eax),%edx
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 08             	lea    0x8(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800600:	78 3f                	js     800641 <vprintfmt+0x2e7>
			base = 10;
  800602:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800607:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80060b:	0f 84 71 01 00 00    	je     800782 <vprintfmt+0x428>
				putch('+', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 2b                	push   $0x2b
  800617:	ff d6                	call   *%esi
  800619:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	e9 5c 01 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80062e:	89 c1                	mov    %eax,%ecx
  800630:	c1 f9 1f             	sar    $0x1f,%ecx
  800633:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	eb af                	jmp    8005f0 <vprintfmt+0x296>
				putch('-', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 2d                	push   $0x2d
  800647:	ff d6                	call   *%esi
				num = -(long long) num;
  800649:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064f:	f7 d8                	neg    %eax
  800651:	83 d2 00             	adc    $0x0,%edx
  800654:	f7 da                	neg    %edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80065f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800664:	e9 19 01 00 00       	jmp    800782 <vprintfmt+0x428>
	if (lflag >= 2)
  800669:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066d:	7f 29                	jg     800698 <vprintfmt+0x33e>
	else if (lflag)
  80066f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800673:	74 44                	je     8006b9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800693:	e9 ea 00 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b4:	e9 c9 00 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d7:	e9 a6 00 00 00       	jmp    800782 <vprintfmt+0x428>
			putch('0', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 30                	push   $0x30
  8006e2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006eb:	7f 26                	jg     800713 <vprintfmt+0x3b9>
	else if (lflag)
  8006ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f1:	74 3e                	je     800731 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070c:	b8 08 00 00 00       	mov    $0x8,%eax
  800711:	eb 6f                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072a:	b8 08 00 00 00       	mov    $0x8,%eax
  80072f:	eb 51                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074a:	b8 08 00 00 00       	mov    $0x8,%eax
  80074f:	eb 31                	jmp    800782 <vprintfmt+0x428>
			putch('0', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	6a 30                	push   $0x30
  800757:	ff d6                	call   *%esi
			putch('x', putdat);
  800759:	83 c4 08             	add    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 78                	push   $0x78
  80075f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800771:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800782:	83 ec 0c             	sub    $0xc,%esp
  800785:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800789:	52                   	push   %edx
  80078a:	ff 75 e0             	pushl  -0x20(%ebp)
  80078d:	50                   	push   %eax
  80078e:	ff 75 dc             	pushl  -0x24(%ebp)
  800791:	ff 75 d8             	pushl  -0x28(%ebp)
  800794:	89 da                	mov    %ebx,%edx
  800796:	89 f0                	mov    %esi,%eax
  800798:	e8 a4 fa ff ff       	call   800241 <printnum>
			break;
  80079d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a3:	83 c7 01             	add    $0x1,%edi
  8007a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007aa:	83 f8 25             	cmp    $0x25,%eax
  8007ad:	0f 84 be fb ff ff    	je     800371 <vprintfmt+0x17>
			if (ch == '\0')
  8007b3:	85 c0                	test   %eax,%eax
  8007b5:	0f 84 28 01 00 00    	je     8008e3 <vprintfmt+0x589>
			putch(ch, putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	50                   	push   %eax
  8007c0:	ff d6                	call   *%esi
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	eb dc                	jmp    8007a3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007c7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007cb:	7f 26                	jg     8007f3 <vprintfmt+0x499>
	else if (lflag)
  8007cd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d1:	74 41                	je     800814 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f1:	eb 8f                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 50 04             	mov    0x4(%eax),%edx
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8d 40 08             	lea    0x8(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080a:	b8 10 00 00 00       	mov    $0x10,%eax
  80080f:	e9 6e ff ff ff       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082d:	b8 10 00 00 00       	mov    $0x10,%eax
  800832:	e9 4b ff ff ff       	jmp    800782 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 c0 04             	add    $0x4,%eax
  80083d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	85 c0                	test   %eax,%eax
  800847:	74 14                	je     80085d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800849:	8b 13                	mov    (%ebx),%edx
  80084b:	83 fa 7f             	cmp    $0x7f,%edx
  80084e:	7f 37                	jg     800887 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800850:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800852:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	e9 43 ff ff ff       	jmp    8007a0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80085d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800862:	bf 15 28 80 00       	mov    $0x802815,%edi
							putch(ch, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	53                   	push   %ebx
  80086b:	50                   	push   %eax
  80086c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80086e:	83 c7 01             	add    $0x1,%edi
  800871:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	85 c0                	test   %eax,%eax
  80087a:	75 eb                	jne    800867 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80087c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
  800882:	e9 19 ff ff ff       	jmp    8007a0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800887:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800889:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088e:	bf 4d 28 80 00       	mov    $0x80284d,%edi
							putch(ch, putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	50                   	push   %eax
  800898:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80089a:	83 c7 01             	add    $0x1,%edi
  80089d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	75 eb                	jne    800893 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	e9 ed fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	6a 25                	push   $0x25
  8008b9:	ff d6                	call   *%esi
			break;
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	e9 dd fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
			putch('%', putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	6a 25                	push   $0x25
  8008c9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	89 f8                	mov    %edi,%eax
  8008d0:	eb 03                	jmp    8008d5 <vprintfmt+0x57b>
  8008d2:	83 e8 01             	sub    $0x1,%eax
  8008d5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d9:	75 f7                	jne    8008d2 <vprintfmt+0x578>
  8008db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008de:	e9 bd fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
}
  8008e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fe:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800908:	85 c0                	test   %eax,%eax
  80090a:	74 26                	je     800932 <vsnprintf+0x47>
  80090c:	85 d2                	test   %edx,%edx
  80090e:	7e 22                	jle    800932 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800910:	ff 75 14             	pushl  0x14(%ebp)
  800913:	ff 75 10             	pushl  0x10(%ebp)
  800916:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800919:	50                   	push   %eax
  80091a:	68 20 03 80 00       	push   $0x800320
  80091f:	e8 36 fa ff ff       	call   80035a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800927:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092d:	83 c4 10             	add    $0x10,%esp
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    
		return -E_INVAL;
  800932:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800937:	eb f7                	jmp    800930 <vsnprintf+0x45>

00800939 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800942:	50                   	push   %eax
  800943:	ff 75 10             	pushl  0x10(%ebp)
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	ff 75 08             	pushl  0x8(%ebp)
  80094c:	e8 9a ff ff ff       	call   8008eb <vsnprintf>
	va_end(ap);

	return rc;
}
  800951:	c9                   	leave  
  800952:	c3                   	ret    

00800953 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800962:	74 05                	je     800969 <strlen+0x16>
		n++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f5                	jmp    80095e <strlen+0xb>
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800974:	ba 00 00 00 00       	mov    $0x0,%edx
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	74 0d                	je     80098a <strnlen+0x1f>
  80097d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800981:	74 05                	je     800988 <strnlen+0x1d>
		n++;
  800983:	83 c2 01             	add    $0x1,%edx
  800986:	eb f1                	jmp    800979 <strnlen+0xe>
  800988:	89 d0                	mov    %edx,%eax
	return n;
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a2:	83 c2 01             	add    $0x1,%edx
  8009a5:	84 c9                	test   %cl,%cl
  8009a7:	75 f2                	jne    80099b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	53                   	push   %ebx
  8009b0:	83 ec 10             	sub    $0x10,%esp
  8009b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b6:	53                   	push   %ebx
  8009b7:	e8 97 ff ff ff       	call   800953 <strlen>
  8009bc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	01 d8                	add    %ebx,%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 c2 ff ff ff       	call   80098c <strcpy>
	return dst;
}
  8009ca:	89 d8                	mov    %ebx,%eax
  8009cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	39 f2                	cmp    %esi,%edx
  8009e5:	74 11                	je     8009f8 <strncpy+0x27>
		*dst++ = *src;
  8009e7:	83 c2 01             	add    $0x1,%edx
  8009ea:	0f b6 19             	movzbl (%ecx),%ebx
  8009ed:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f0:	80 fb 01             	cmp    $0x1,%bl
  8009f3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009f6:	eb eb                	jmp    8009e3 <strncpy+0x12>
	}
	return ret;
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	56                   	push   %esi
  800a00:	53                   	push   %ebx
  800a01:	8b 75 08             	mov    0x8(%ebp),%esi
  800a04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a07:	8b 55 10             	mov    0x10(%ebp),%edx
  800a0a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a0c:	85 d2                	test   %edx,%edx
  800a0e:	74 21                	je     800a31 <strlcpy+0x35>
  800a10:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a14:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a16:	39 c2                	cmp    %eax,%edx
  800a18:	74 14                	je     800a2e <strlcpy+0x32>
  800a1a:	0f b6 19             	movzbl (%ecx),%ebx
  800a1d:	84 db                	test   %bl,%bl
  800a1f:	74 0b                	je     800a2c <strlcpy+0x30>
			*dst++ = *src++;
  800a21:	83 c1 01             	add    $0x1,%ecx
  800a24:	83 c2 01             	add    $0x1,%edx
  800a27:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a2a:	eb ea                	jmp    800a16 <strlcpy+0x1a>
  800a2c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a31:	29 f0                	sub    %esi,%eax
}
  800a33:	5b                   	pop    %ebx
  800a34:	5e                   	pop    %esi
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a40:	0f b6 01             	movzbl (%ecx),%eax
  800a43:	84 c0                	test   %al,%al
  800a45:	74 0c                	je     800a53 <strcmp+0x1c>
  800a47:	3a 02                	cmp    (%edx),%al
  800a49:	75 08                	jne    800a53 <strcmp+0x1c>
		p++, q++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	83 c2 01             	add    $0x1,%edx
  800a51:	eb ed                	jmp    800a40 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a53:	0f b6 c0             	movzbl %al,%eax
  800a56:	0f b6 12             	movzbl (%edx),%edx
  800a59:	29 d0                	sub    %edx,%eax
}
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	89 c3                	mov    %eax,%ebx
  800a69:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a6c:	eb 06                	jmp    800a74 <strncmp+0x17>
		n--, p++, q++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a74:	39 d8                	cmp    %ebx,%eax
  800a76:	74 16                	je     800a8e <strncmp+0x31>
  800a78:	0f b6 08             	movzbl (%eax),%ecx
  800a7b:	84 c9                	test   %cl,%cl
  800a7d:	74 04                	je     800a83 <strncmp+0x26>
  800a7f:	3a 0a                	cmp    (%edx),%cl
  800a81:	74 eb                	je     800a6e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a83:	0f b6 00             	movzbl (%eax),%eax
  800a86:	0f b6 12             	movzbl (%edx),%edx
  800a89:	29 d0                	sub    %edx,%eax
}
  800a8b:	5b                   	pop    %ebx
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    
		return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a93:	eb f6                	jmp    800a8b <strncmp+0x2e>

00800a95 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9f:	0f b6 10             	movzbl (%eax),%edx
  800aa2:	84 d2                	test   %dl,%dl
  800aa4:	74 09                	je     800aaf <strchr+0x1a>
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 0a                	je     800ab4 <strchr+0x1f>
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	eb f0                	jmp    800a9f <strchr+0xa>
			return (char *) s;
	return 0;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac3:	38 ca                	cmp    %cl,%dl
  800ac5:	74 09                	je     800ad0 <strfind+0x1a>
  800ac7:	84 d2                	test   %dl,%dl
  800ac9:	74 05                	je     800ad0 <strfind+0x1a>
	for (; *s; s++)
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	eb f0                	jmp    800ac0 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	57                   	push   %edi
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ade:	85 c9                	test   %ecx,%ecx
  800ae0:	74 31                	je     800b13 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae2:	89 f8                	mov    %edi,%eax
  800ae4:	09 c8                	or     %ecx,%eax
  800ae6:	a8 03                	test   $0x3,%al
  800ae8:	75 23                	jne    800b0d <memset+0x3b>
		c &= 0xFF;
  800aea:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aee:	89 d3                	mov    %edx,%ebx
  800af0:	c1 e3 08             	shl    $0x8,%ebx
  800af3:	89 d0                	mov    %edx,%eax
  800af5:	c1 e0 18             	shl    $0x18,%eax
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	c1 e6 10             	shl    $0x10,%esi
  800afd:	09 f0                	or     %esi,%eax
  800aff:	09 c2                	or     %eax,%edx
  800b01:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b03:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b06:	89 d0                	mov    %edx,%eax
  800b08:	fc                   	cld    
  800b09:	f3 ab                	rep stos %eax,%es:(%edi)
  800b0b:	eb 06                	jmp    800b13 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	fc                   	cld    
  800b11:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b13:	89 f8                	mov    %edi,%eax
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5f                   	pop    %edi
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b28:	39 c6                	cmp    %eax,%esi
  800b2a:	73 32                	jae    800b5e <memmove+0x44>
  800b2c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	76 2b                	jbe    800b5e <memmove+0x44>
		s += n;
		d += n;
  800b33:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b36:	89 fe                	mov    %edi,%esi
  800b38:	09 ce                	or     %ecx,%esi
  800b3a:	09 d6                	or     %edx,%esi
  800b3c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b42:	75 0e                	jne    800b52 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b44:	83 ef 04             	sub    $0x4,%edi
  800b47:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b4a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b4d:	fd                   	std    
  800b4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b50:	eb 09                	jmp    800b5b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b52:	83 ef 01             	sub    $0x1,%edi
  800b55:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b58:	fd                   	std    
  800b59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5b:	fc                   	cld    
  800b5c:	eb 1a                	jmp    800b78 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5e:	89 c2                	mov    %eax,%edx
  800b60:	09 ca                	or     %ecx,%edx
  800b62:	09 f2                	or     %esi,%edx
  800b64:	f6 c2 03             	test   $0x3,%dl
  800b67:	75 0a                	jne    800b73 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b6c:	89 c7                	mov    %eax,%edi
  800b6e:	fc                   	cld    
  800b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b71:	eb 05                	jmp    800b78 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	fc                   	cld    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b82:	ff 75 10             	pushl  0x10(%ebp)
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 08             	pushl  0x8(%ebp)
  800b8b:	e8 8a ff ff ff       	call   800b1a <memmove>
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	89 c6                	mov    %eax,%esi
  800b9f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba2:	39 f0                	cmp    %esi,%eax
  800ba4:	74 1c                	je     800bc2 <memcmp+0x30>
		if (*s1 != *s2)
  800ba6:	0f b6 08             	movzbl (%eax),%ecx
  800ba9:	0f b6 1a             	movzbl (%edx),%ebx
  800bac:	38 d9                	cmp    %bl,%cl
  800bae:	75 08                	jne    800bb8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	83 c2 01             	add    $0x1,%edx
  800bb6:	eb ea                	jmp    800ba2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb8:	0f b6 c1             	movzbl %cl,%eax
  800bbb:	0f b6 db             	movzbl %bl,%ebx
  800bbe:	29 d8                	sub    %ebx,%eax
  800bc0:	eb 05                	jmp    800bc7 <memcmp+0x35>
	}

	return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd4:	89 c2                	mov    %eax,%edx
  800bd6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd9:	39 d0                	cmp    %edx,%eax
  800bdb:	73 09                	jae    800be6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdd:	38 08                	cmp    %cl,(%eax)
  800bdf:	74 05                	je     800be6 <memfind+0x1b>
	for (; s < ends; s++)
  800be1:	83 c0 01             	add    $0x1,%eax
  800be4:	eb f3                	jmp    800bd9 <memfind+0xe>
			break;
	return (void *) s;
}
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf4:	eb 03                	jmp    800bf9 <strtol+0x11>
		s++;
  800bf6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf9:	0f b6 01             	movzbl (%ecx),%eax
  800bfc:	3c 20                	cmp    $0x20,%al
  800bfe:	74 f6                	je     800bf6 <strtol+0xe>
  800c00:	3c 09                	cmp    $0x9,%al
  800c02:	74 f2                	je     800bf6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c04:	3c 2b                	cmp    $0x2b,%al
  800c06:	74 2a                	je     800c32 <strtol+0x4a>
	int neg = 0;
  800c08:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0d:	3c 2d                	cmp    $0x2d,%al
  800c0f:	74 2b                	je     800c3c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c11:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c17:	75 0f                	jne    800c28 <strtol+0x40>
  800c19:	80 39 30             	cmpb   $0x30,(%ecx)
  800c1c:	74 28                	je     800c46 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c1e:	85 db                	test   %ebx,%ebx
  800c20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c25:	0f 44 d8             	cmove  %eax,%ebx
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c30:	eb 50                	jmp    800c82 <strtol+0x9a>
		s++;
  800c32:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c35:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3a:	eb d5                	jmp    800c11 <strtol+0x29>
		s++, neg = 1;
  800c3c:	83 c1 01             	add    $0x1,%ecx
  800c3f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c44:	eb cb                	jmp    800c11 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c46:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4a:	74 0e                	je     800c5a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c4c:	85 db                	test   %ebx,%ebx
  800c4e:	75 d8                	jne    800c28 <strtol+0x40>
		s++, base = 8;
  800c50:	83 c1 01             	add    $0x1,%ecx
  800c53:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c58:	eb ce                	jmp    800c28 <strtol+0x40>
		s += 2, base = 16;
  800c5a:	83 c1 02             	add    $0x2,%ecx
  800c5d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c62:	eb c4                	jmp    800c28 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c64:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c67:	89 f3                	mov    %esi,%ebx
  800c69:	80 fb 19             	cmp    $0x19,%bl
  800c6c:	77 29                	ja     800c97 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c6e:	0f be d2             	movsbl %dl,%edx
  800c71:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c74:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c77:	7d 30                	jge    800ca9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c79:	83 c1 01             	add    $0x1,%ecx
  800c7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c82:	0f b6 11             	movzbl (%ecx),%edx
  800c85:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c88:	89 f3                	mov    %esi,%ebx
  800c8a:	80 fb 09             	cmp    $0x9,%bl
  800c8d:	77 d5                	ja     800c64 <strtol+0x7c>
			dig = *s - '0';
  800c8f:	0f be d2             	movsbl %dl,%edx
  800c92:	83 ea 30             	sub    $0x30,%edx
  800c95:	eb dd                	jmp    800c74 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c97:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9a:	89 f3                	mov    %esi,%ebx
  800c9c:	80 fb 19             	cmp    $0x19,%bl
  800c9f:	77 08                	ja     800ca9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca1:	0f be d2             	movsbl %dl,%edx
  800ca4:	83 ea 37             	sub    $0x37,%edx
  800ca7:	eb cb                	jmp    800c74 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cad:	74 05                	je     800cb4 <strtol+0xcc>
		*endptr = (char *) s;
  800caf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	f7 da                	neg    %edx
  800cb8:	85 ff                	test   %edi,%edi
  800cba:	0f 45 c2             	cmovne %edx,%eax
}
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd3:	89 c3                	mov    %eax,%ebx
  800cd5:	89 c7                	mov    %eax,%edi
  800cd7:	89 c6                	mov    %eax,%esi
  800cd9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf0:	89 d1                	mov    %edx,%ecx
  800cf2:	89 d3                	mov    %edx,%ebx
  800cf4:	89 d7                	mov    %edx,%edi
  800cf6:	89 d6                	mov    %edx,%esi
  800cf8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
  800d05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	b8 03 00 00 00       	mov    $0x3,%eax
  800d15:	89 cb                	mov    %ecx,%ebx
  800d17:	89 cf                	mov    %ecx,%edi
  800d19:	89 ce                	mov    %ecx,%esi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 03                	push   $0x3
  800d2f:	68 68 2a 80 00       	push   $0x802a68
  800d34:	6a 43                	push   $0x43
  800d36:	68 85 2a 80 00       	push   $0x802a85
  800d3b:	e8 1e 15 00 00       	call   80225e <_panic>

00800d40 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d46:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d50:	89 d1                	mov    %edx,%ecx
  800d52:	89 d3                	mov    %edx,%ebx
  800d54:	89 d7                	mov    %edx,%edi
  800d56:	89 d6                	mov    %edx,%esi
  800d58:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_yield>:

void
sys_yield(void)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d65:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6f:	89 d1                	mov    %edx,%ecx
  800d71:	89 d3                	mov    %edx,%ebx
  800d73:	89 d7                	mov    %edx,%edi
  800d75:	89 d6                	mov    %edx,%esi
  800d77:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d87:	be 00 00 00 00       	mov    $0x0,%esi
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d92:	b8 04 00 00 00       	mov    $0x4,%eax
  800d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9a:	89 f7                	mov    %esi,%edi
  800d9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	7f 08                	jg     800daa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daa:	83 ec 0c             	sub    $0xc,%esp
  800dad:	50                   	push   %eax
  800dae:	6a 04                	push   $0x4
  800db0:	68 68 2a 80 00       	push   $0x802a68
  800db5:	6a 43                	push   $0x43
  800db7:	68 85 2a 80 00       	push   $0x802a85
  800dbc:	e8 9d 14 00 00       	call   80225e <_panic>

00800dc1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 05                	push   $0x5
  800df2:	68 68 2a 80 00       	push   $0x802a68
  800df7:	6a 43                	push   $0x43
  800df9:	68 85 2a 80 00       	push   $0x802a85
  800dfe:	e8 5b 14 00 00       	call   80225e <_panic>

00800e03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e17:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1c:	89 df                	mov    %ebx,%edi
  800e1e:	89 de                	mov    %ebx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 06                	push   $0x6
  800e34:	68 68 2a 80 00       	push   $0x802a68
  800e39:	6a 43                	push   $0x43
  800e3b:	68 85 2a 80 00       	push   $0x802a85
  800e40:	e8 19 14 00 00       	call   80225e <_panic>

00800e45 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5e:	89 df                	mov    %ebx,%edi
  800e60:	89 de                	mov    %ebx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7f 08                	jg     800e70 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 08                	push   $0x8
  800e76:	68 68 2a 80 00       	push   $0x802a68
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 85 2a 80 00       	push   $0x802a85
  800e82:	e8 d7 13 00 00       	call   80225e <_panic>

00800e87 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 09                	push   $0x9
  800eb8:	68 68 2a 80 00       	push   $0x802a68
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 85 2a 80 00       	push   $0x802a85
  800ec4:	e8 95 13 00 00       	call   80225e <_panic>

00800ec9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7f 08                	jg     800ef4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	50                   	push   %eax
  800ef8:	6a 0a                	push   $0xa
  800efa:	68 68 2a 80 00       	push   $0x802a68
  800eff:	6a 43                	push   $0x43
  800f01:	68 85 2a 80 00       	push   $0x802a85
  800f06:	e8 53 13 00 00       	call   80225e <_panic>

00800f0b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1c:	be 00 00 00 00       	mov    $0x0,%esi
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f27:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f44:	89 cb                	mov    %ecx,%ebx
  800f46:	89 cf                	mov    %ecx,%edi
  800f48:	89 ce                	mov    %ecx,%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0d                	push   $0xd
  800f5e:	68 68 2a 80 00       	push   $0x802a68
  800f63:	6a 43                	push   $0x43
  800f65:	68 85 2a 80 00       	push   $0x802a85
  800f6a:	e8 ef 12 00 00       	call   80225e <_panic>

00800f6f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa3:	89 cb                	mov    %ecx,%ebx
  800fa5:	89 cf                	mov    %ecx,%edi
  800fa7:	89 ce                	mov    %ecx,%esi
  800fa9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc0:	89 d1                	mov    %edx,%ecx
  800fc2:	89 d3                	mov    %edx,%ebx
  800fc4:	89 d7                	mov    %edx,%edi
  800fc6:	89 d6                	mov    %edx,%esi
  800fc8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	b8 11 00 00 00       	mov    $0x11,%eax
  800fe5:	89 df                	mov    %ebx,%edi
  800fe7:	89 de                	mov    %ebx,%esi
  800fe9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	57                   	push   %edi
  800ff4:	56                   	push   %esi
  800ff5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	b8 12 00 00 00       	mov    $0x12,%eax
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	b8 13 00 00 00       	mov    $0x13,%eax
  80102a:	89 df                	mov    %ebx,%edi
  80102c:	89 de                	mov    %ebx,%esi
  80102e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801030:	85 c0                	test   %eax,%eax
  801032:	7f 08                	jg     80103c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	50                   	push   %eax
  801040:	6a 13                	push   $0x13
  801042:	68 68 2a 80 00       	push   $0x802a68
  801047:	6a 43                	push   $0x43
  801049:	68 85 2a 80 00       	push   $0x802a85
  80104e:	e8 0b 12 00 00       	call   80225e <_panic>

00801053 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
	asm volatile("int %1\n"
  801059:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105e:	8b 55 08             	mov    0x8(%ebp),%edx
  801061:	b8 14 00 00 00       	mov    $0x14,%eax
  801066:	89 cb                	mov    %ecx,%ebx
  801068:	89 cf                	mov    %ecx,%edi
  80106a:	89 ce                	mov    %ecx,%esi
  80106c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801079:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801080:	74 0a                	je     80108c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	6a 07                	push   $0x7
  801091:	68 00 f0 bf ee       	push   $0xeebff000
  801096:	6a 00                	push   $0x0
  801098:	e8 e1 fc ff ff       	call   800d7e <sys_page_alloc>
		if(r < 0)
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	78 2a                	js     8010ce <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	68 e2 10 80 00       	push   $0x8010e2
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 16 fe ff ff       	call   800ec9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	79 c8                	jns    801082 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8010ba:	83 ec 04             	sub    $0x4,%esp
  8010bd:	68 c4 2a 80 00       	push   $0x802ac4
  8010c2:	6a 25                	push   $0x25
  8010c4:	68 fd 2a 80 00       	push   $0x802afd
  8010c9:	e8 90 11 00 00       	call   80225e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 94 2a 80 00       	push   $0x802a94
  8010d6:	6a 22                	push   $0x22
  8010d8:	68 fd 2a 80 00       	push   $0x802afd
  8010dd:	e8 7c 11 00 00       	call   80225e <_panic>

008010e2 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010e2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010e3:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010e8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010ea:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8010ed:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8010f1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8010f5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8010f8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8010fa:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8010fe:	83 c4 08             	add    $0x8,%esp
	popal
  801101:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801102:	83 c4 04             	add    $0x4,%esp
	popfl
  801105:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801106:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801107:	c3                   	ret    

00801108 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	05 00 00 00 30       	add    $0x30000000,%eax
  801113:	c1 e8 0c             	shr    $0xc,%eax
}
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801123:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801128:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801137:	89 c2                	mov    %eax,%edx
  801139:	c1 ea 16             	shr    $0x16,%edx
  80113c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801143:	f6 c2 01             	test   $0x1,%dl
  801146:	74 2d                	je     801175 <fd_alloc+0x46>
  801148:	89 c2                	mov    %eax,%edx
  80114a:	c1 ea 0c             	shr    $0xc,%edx
  80114d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801154:	f6 c2 01             	test   $0x1,%dl
  801157:	74 1c                	je     801175 <fd_alloc+0x46>
  801159:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80115e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801163:	75 d2                	jne    801137 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80116e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801173:	eb 0a                	jmp    80117f <fd_alloc+0x50>
			*fd_store = fd;
  801175:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801178:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801187:	83 f8 1f             	cmp    $0x1f,%eax
  80118a:	77 30                	ja     8011bc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80118c:	c1 e0 0c             	shl    $0xc,%eax
  80118f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801194:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80119a:	f6 c2 01             	test   $0x1,%dl
  80119d:	74 24                	je     8011c3 <fd_lookup+0x42>
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	c1 ea 0c             	shr    $0xc,%edx
  8011a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ab:	f6 c2 01             	test   $0x1,%dl
  8011ae:	74 1a                	je     8011ca <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b3:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    
		return -E_INVAL;
  8011bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c1:	eb f7                	jmp    8011ba <fd_lookup+0x39>
		return -E_INVAL;
  8011c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c8:	eb f0                	jmp    8011ba <fd_lookup+0x39>
  8011ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cf:	eb e9                	jmp    8011ba <fd_lookup+0x39>

008011d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011da:	ba 00 00 00 00       	mov    $0x0,%edx
  8011df:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e4:	39 08                	cmp    %ecx,(%eax)
  8011e6:	74 38                	je     801220 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011e8:	83 c2 01             	add    $0x1,%edx
  8011eb:	8b 04 95 88 2b 80 00 	mov    0x802b88(,%edx,4),%eax
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	75 ee                	jne    8011e4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011f6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011fb:	8b 40 48             	mov    0x48(%eax),%eax
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	51                   	push   %ecx
  801202:	50                   	push   %eax
  801203:	68 0c 2b 80 00       	push   $0x802b0c
  801208:	e8 20 f0 ff ff       	call   80022d <cprintf>
	*dev = 0;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    
			*dev = devtab[i];
  801220:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801223:	89 01                	mov    %eax,(%ecx)
			return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb f2                	jmp    80121e <dev_lookup+0x4d>

0080122c <fd_close>:
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 24             	sub    $0x24,%esp
  801235:	8b 75 08             	mov    0x8(%ebp),%esi
  801238:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80123b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801245:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801248:	50                   	push   %eax
  801249:	e8 33 ff ff ff       	call   801181 <fd_lookup>
  80124e:	89 c3                	mov    %eax,%ebx
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	78 05                	js     80125c <fd_close+0x30>
	    || fd != fd2)
  801257:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80125a:	74 16                	je     801272 <fd_close+0x46>
		return (must_exist ? r : 0);
  80125c:	89 f8                	mov    %edi,%eax
  80125e:	84 c0                	test   %al,%al
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
  801265:	0f 44 d8             	cmove  %eax,%ebx
}
  801268:	89 d8                	mov    %ebx,%eax
  80126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	ff 36                	pushl  (%esi)
  80127b:	e8 51 ff ff ff       	call   8011d1 <dev_lookup>
  801280:	89 c3                	mov    %eax,%ebx
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	78 1a                	js     8012a3 <fd_close+0x77>
		if (dev->dev_close)
  801289:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80128f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801294:	85 c0                	test   %eax,%eax
  801296:	74 0b                	je     8012a3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801298:	83 ec 0c             	sub    $0xc,%esp
  80129b:	56                   	push   %esi
  80129c:	ff d0                	call   *%eax
  80129e:	89 c3                	mov    %eax,%ebx
  8012a0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	56                   	push   %esi
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 55 fb ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	eb b5                	jmp    801268 <fd_close+0x3c>

008012b3 <close>:

int
close(int fdnum)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	e8 bc fe ff ff       	call   801181 <fd_lookup>
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	79 02                	jns    8012ce <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    
		return fd_close(fd, 1);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	6a 01                	push   $0x1
  8012d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d6:	e8 51 ff ff ff       	call   80122c <fd_close>
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	eb ec                	jmp    8012cc <close+0x19>

008012e0 <close_all>:

void
close_all(void)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	53                   	push   %ebx
  8012f0:	e8 be ff ff ff       	call   8012b3 <close>
	for (i = 0; i < MAXFD; i++)
  8012f5:	83 c3 01             	add    $0x1,%ebx
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	83 fb 20             	cmp    $0x20,%ebx
  8012fe:	75 ec                	jne    8012ec <close_all+0xc>
}
  801300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	57                   	push   %edi
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
  80130b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80130e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	ff 75 08             	pushl  0x8(%ebp)
  801315:	e8 67 fe ff ff       	call   801181 <fd_lookup>
  80131a:	89 c3                	mov    %eax,%ebx
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	0f 88 81 00 00 00    	js     8013a8 <dup+0xa3>
		return r;
	close(newfdnum);
  801327:	83 ec 0c             	sub    $0xc,%esp
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	e8 81 ff ff ff       	call   8012b3 <close>

	newfd = INDEX2FD(newfdnum);
  801332:	8b 75 0c             	mov    0xc(%ebp),%esi
  801335:	c1 e6 0c             	shl    $0xc,%esi
  801338:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80133e:	83 c4 04             	add    $0x4,%esp
  801341:	ff 75 e4             	pushl  -0x1c(%ebp)
  801344:	e8 cf fd ff ff       	call   801118 <fd2data>
  801349:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80134b:	89 34 24             	mov    %esi,(%esp)
  80134e:	e8 c5 fd ff ff       	call   801118 <fd2data>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801358:	89 d8                	mov    %ebx,%eax
  80135a:	c1 e8 16             	shr    $0x16,%eax
  80135d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801364:	a8 01                	test   $0x1,%al
  801366:	74 11                	je     801379 <dup+0x74>
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	c1 e8 0c             	shr    $0xc,%eax
  80136d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801374:	f6 c2 01             	test   $0x1,%dl
  801377:	75 39                	jne    8013b2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801379:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80137c:	89 d0                	mov    %edx,%eax
  80137e:	c1 e8 0c             	shr    $0xc,%eax
  801381:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	25 07 0e 00 00       	and    $0xe07,%eax
  801390:	50                   	push   %eax
  801391:	56                   	push   %esi
  801392:	6a 00                	push   $0x0
  801394:	52                   	push   %edx
  801395:	6a 00                	push   $0x0
  801397:	e8 25 fa ff ff       	call   800dc1 <sys_page_map>
  80139c:	89 c3                	mov    %eax,%ebx
  80139e:	83 c4 20             	add    $0x20,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 31                	js     8013d6 <dup+0xd1>
		goto err;

	return newfdnum;
  8013a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013a8:	89 d8                	mov    %ebx,%eax
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b9:	83 ec 0c             	sub    $0xc,%esp
  8013bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c1:	50                   	push   %eax
  8013c2:	57                   	push   %edi
  8013c3:	6a 00                	push   $0x0
  8013c5:	53                   	push   %ebx
  8013c6:	6a 00                	push   $0x0
  8013c8:	e8 f4 f9 ff ff       	call   800dc1 <sys_page_map>
  8013cd:	89 c3                	mov    %eax,%ebx
  8013cf:	83 c4 20             	add    $0x20,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	79 a3                	jns    801379 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	56                   	push   %esi
  8013da:	6a 00                	push   $0x0
  8013dc:	e8 22 fa ff ff       	call   800e03 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013e1:	83 c4 08             	add    $0x8,%esp
  8013e4:	57                   	push   %edi
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 17 fa ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	eb b7                	jmp    8013a8 <dup+0xa3>

008013f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 1c             	sub    $0x1c,%esp
  8013f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	53                   	push   %ebx
  801400:	e8 7c fd ff ff       	call   801181 <fd_lookup>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 3f                	js     80144b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	ff 30                	pushl  (%eax)
  801418:	e8 b4 fd ff ff       	call   8011d1 <dev_lookup>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	78 27                	js     80144b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801427:	8b 42 08             	mov    0x8(%edx),%eax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	83 f8 01             	cmp    $0x1,%eax
  801430:	74 1e                	je     801450 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801435:	8b 40 08             	mov    0x8(%eax),%eax
  801438:	85 c0                	test   %eax,%eax
  80143a:	74 35                	je     801471 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	ff 75 10             	pushl  0x10(%ebp)
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	52                   	push   %edx
  801446:	ff d0                	call   *%eax
  801448:	83 c4 10             	add    $0x10,%esp
}
  80144b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801450:	a1 08 40 80 00       	mov    0x804008,%eax
  801455:	8b 40 48             	mov    0x48(%eax),%eax
  801458:	83 ec 04             	sub    $0x4,%esp
  80145b:	53                   	push   %ebx
  80145c:	50                   	push   %eax
  80145d:	68 4d 2b 80 00       	push   $0x802b4d
  801462:	e8 c6 ed ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146f:	eb da                	jmp    80144b <read+0x5a>
		return -E_NOT_SUPP;
  801471:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801476:	eb d3                	jmp    80144b <read+0x5a>

00801478 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	57                   	push   %edi
  80147c:	56                   	push   %esi
  80147d:	53                   	push   %ebx
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	8b 7d 08             	mov    0x8(%ebp),%edi
  801484:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801487:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148c:	39 f3                	cmp    %esi,%ebx
  80148e:	73 23                	jae    8014b3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	89 f0                	mov    %esi,%eax
  801495:	29 d8                	sub    %ebx,%eax
  801497:	50                   	push   %eax
  801498:	89 d8                	mov    %ebx,%eax
  80149a:	03 45 0c             	add    0xc(%ebp),%eax
  80149d:	50                   	push   %eax
  80149e:	57                   	push   %edi
  80149f:	e8 4d ff ff ff       	call   8013f1 <read>
		if (m < 0)
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 06                	js     8014b1 <readn+0x39>
			return m;
		if (m == 0)
  8014ab:	74 06                	je     8014b3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014ad:	01 c3                	add    %eax,%ebx
  8014af:	eb db                	jmp    80148c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014b3:	89 d8                	mov    %ebx,%eax
  8014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 1c             	sub    $0x1c,%esp
  8014c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ca:	50                   	push   %eax
  8014cb:	53                   	push   %ebx
  8014cc:	e8 b0 fc ff ff       	call   801181 <fd_lookup>
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 3a                	js     801512 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	ff 30                	pushl  (%eax)
  8014e4:	e8 e8 fc ff ff       	call   8011d1 <dev_lookup>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 22                	js     801512 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f7:	74 1e                	je     801517 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ff:	85 d2                	test   %edx,%edx
  801501:	74 35                	je     801538 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	ff 75 10             	pushl  0x10(%ebp)
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	50                   	push   %eax
  80150d:	ff d2                	call   *%edx
  80150f:	83 c4 10             	add    $0x10,%esp
}
  801512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801515:	c9                   	leave  
  801516:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801517:	a1 08 40 80 00       	mov    0x804008,%eax
  80151c:	8b 40 48             	mov    0x48(%eax),%eax
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	53                   	push   %ebx
  801523:	50                   	push   %eax
  801524:	68 69 2b 80 00       	push   $0x802b69
  801529:	e8 ff ec ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801536:	eb da                	jmp    801512 <write+0x55>
		return -E_NOT_SUPP;
  801538:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153d:	eb d3                	jmp    801512 <write+0x55>

0080153f <seek>:

int
seek(int fdnum, off_t offset)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801545:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801548:	50                   	push   %eax
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	e8 30 fc ff ff       	call   801181 <fd_lookup>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 0e                	js     801566 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	53                   	push   %ebx
  80156c:	83 ec 1c             	sub    $0x1c,%esp
  80156f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801572:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	53                   	push   %ebx
  801577:	e8 05 fc ff ff       	call   801181 <fd_lookup>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 37                	js     8015ba <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801589:	50                   	push   %eax
  80158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158d:	ff 30                	pushl  (%eax)
  80158f:	e8 3d fc ff ff       	call   8011d1 <dev_lookup>
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	78 1f                	js     8015ba <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a2:	74 1b                	je     8015bf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a7:	8b 52 18             	mov    0x18(%edx),%edx
  8015aa:	85 d2                	test   %edx,%edx
  8015ac:	74 32                	je     8015e0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	50                   	push   %eax
  8015b5:	ff d2                	call   *%edx
  8015b7:	83 c4 10             	add    $0x10,%esp
}
  8015ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015bf:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c4:	8b 40 48             	mov    0x48(%eax),%eax
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	53                   	push   %ebx
  8015cb:	50                   	push   %eax
  8015cc:	68 2c 2b 80 00       	push   $0x802b2c
  8015d1:	e8 57 ec ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015de:	eb da                	jmp    8015ba <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e5:	eb d3                	jmp    8015ba <ftruncate+0x52>

008015e7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	53                   	push   %ebx
  8015eb:	83 ec 1c             	sub    $0x1c,%esp
  8015ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	e8 84 fb ff ff       	call   801181 <fd_lookup>
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	78 4b                	js     80164f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	ff 30                	pushl  (%eax)
  801610:	e8 bc fb ff ff       	call   8011d1 <dev_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 33                	js     80164f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801623:	74 2f                	je     801654 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801625:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801628:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162f:	00 00 00 
	stat->st_isdir = 0;
  801632:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801639:	00 00 00 
	stat->st_dev = dev;
  80163c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	53                   	push   %ebx
  801646:	ff 75 f0             	pushl  -0x10(%ebp)
  801649:	ff 50 14             	call   *0x14(%eax)
  80164c:	83 c4 10             	add    $0x10,%esp
}
  80164f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801652:	c9                   	leave  
  801653:	c3                   	ret    
		return -E_NOT_SUPP;
  801654:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801659:	eb f4                	jmp    80164f <fstat+0x68>

0080165b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	6a 00                	push   $0x0
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 22 02 00 00       	call   80188f <open>
  80166d:	89 c3                	mov    %eax,%ebx
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 1b                	js     801691 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	50                   	push   %eax
  80167d:	e8 65 ff ff ff       	call   8015e7 <fstat>
  801682:	89 c6                	mov    %eax,%esi
	close(fd);
  801684:	89 1c 24             	mov    %ebx,(%esp)
  801687:	e8 27 fc ff ff       	call   8012b3 <close>
	return r;
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 f3                	mov    %esi,%ebx
}
  801691:	89 d8                	mov    %ebx,%eax
  801693:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801696:	5b                   	pop    %ebx
  801697:	5e                   	pop    %esi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
  80169f:	89 c6                	mov    %eax,%esi
  8016a1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016a3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016aa:	74 27                	je     8016d3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ac:	6a 07                	push   $0x7
  8016ae:	68 00 50 80 00       	push   $0x805000
  8016b3:	56                   	push   %esi
  8016b4:	ff 35 00 40 80 00    	pushl  0x804000
  8016ba:	e8 69 0c 00 00       	call   802328 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016bf:	83 c4 0c             	add    $0xc,%esp
  8016c2:	6a 00                	push   $0x0
  8016c4:	53                   	push   %ebx
  8016c5:	6a 00                	push   $0x0
  8016c7:	e8 f3 0b 00 00       	call   8022bf <ipc_recv>
}
  8016cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	6a 01                	push   $0x1
  8016d8:	e8 a3 0c 00 00       	call   802380 <ipc_find_env>
  8016dd:	a3 00 40 80 00       	mov    %eax,0x804000
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	eb c5                	jmp    8016ac <fsipc+0x12>

008016e7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 02 00 00 00       	mov    $0x2,%eax
  80170a:	e8 8b ff ff ff       	call   80169a <fsipc>
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <devfile_flush>:
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8b 40 0c             	mov    0xc(%eax),%eax
  80171d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 06 00 00 00       	mov    $0x6,%eax
  80172c:	e8 69 ff ff ff       	call   80169a <fsipc>
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_stat>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	b8 05 00 00 00       	mov    $0x5,%eax
  801752:	e8 43 ff ff ff       	call   80169a <fsipc>
  801757:	85 c0                	test   %eax,%eax
  801759:	78 2c                	js     801787 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	68 00 50 80 00       	push   $0x805000
  801763:	53                   	push   %ebx
  801764:	e8 23 f2 ff ff       	call   80098c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801769:	a1 80 50 80 00       	mov    0x805080,%eax
  80176e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801774:	a1 84 50 80 00       	mov    0x805084,%eax
  801779:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <devfile_write>:
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8b 40 0c             	mov    0xc(%eax),%eax
  80179c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017a1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017a7:	53                   	push   %ebx
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	68 08 50 80 00       	push   $0x805008
  8017b0:	e8 c7 f3 ff ff       	call   800b7c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ba:	b8 04 00 00 00       	mov    $0x4,%eax
  8017bf:	e8 d6 fe ff ff       	call   80169a <fsipc>
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 0b                	js     8017d6 <devfile_write+0x4a>
	assert(r <= n);
  8017cb:	39 d8                	cmp    %ebx,%eax
  8017cd:	77 0c                	ja     8017db <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d4:	7f 1e                	jg     8017f4 <devfile_write+0x68>
}
  8017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    
	assert(r <= n);
  8017db:	68 9c 2b 80 00       	push   $0x802b9c
  8017e0:	68 a3 2b 80 00       	push   $0x802ba3
  8017e5:	68 98 00 00 00       	push   $0x98
  8017ea:	68 b8 2b 80 00       	push   $0x802bb8
  8017ef:	e8 6a 0a 00 00       	call   80225e <_panic>
	assert(r <= PGSIZE);
  8017f4:	68 c3 2b 80 00       	push   $0x802bc3
  8017f9:	68 a3 2b 80 00       	push   $0x802ba3
  8017fe:	68 99 00 00 00       	push   $0x99
  801803:	68 b8 2b 80 00       	push   $0x802bb8
  801808:	e8 51 0a 00 00       	call   80225e <_panic>

0080180d <devfile_read>:
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8b 40 0c             	mov    0xc(%eax),%eax
  80181b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801820:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801826:	ba 00 00 00 00       	mov    $0x0,%edx
  80182b:	b8 03 00 00 00       	mov    $0x3,%eax
  801830:	e8 65 fe ff ff       	call   80169a <fsipc>
  801835:	89 c3                	mov    %eax,%ebx
  801837:	85 c0                	test   %eax,%eax
  801839:	78 1f                	js     80185a <devfile_read+0x4d>
	assert(r <= n);
  80183b:	39 f0                	cmp    %esi,%eax
  80183d:	77 24                	ja     801863 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80183f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801844:	7f 33                	jg     801879 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	50                   	push   %eax
  80184a:	68 00 50 80 00       	push   $0x805000
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	e8 c3 f2 ff ff       	call   800b1a <memmove>
	return r;
  801857:	83 c4 10             	add    $0x10,%esp
}
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    
	assert(r <= n);
  801863:	68 9c 2b 80 00       	push   $0x802b9c
  801868:	68 a3 2b 80 00       	push   $0x802ba3
  80186d:	6a 7c                	push   $0x7c
  80186f:	68 b8 2b 80 00       	push   $0x802bb8
  801874:	e8 e5 09 00 00       	call   80225e <_panic>
	assert(r <= PGSIZE);
  801879:	68 c3 2b 80 00       	push   $0x802bc3
  80187e:	68 a3 2b 80 00       	push   $0x802ba3
  801883:	6a 7d                	push   $0x7d
  801885:	68 b8 2b 80 00       	push   $0x802bb8
  80188a:	e8 cf 09 00 00       	call   80225e <_panic>

0080188f <open>:
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	83 ec 1c             	sub    $0x1c,%esp
  801897:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80189a:	56                   	push   %esi
  80189b:	e8 b3 f0 ff ff       	call   800953 <strlen>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018a8:	7f 6c                	jg     801916 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018aa:	83 ec 0c             	sub    $0xc,%esp
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	e8 79 f8 ff ff       	call   80112f <fd_alloc>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 3c                	js     8018fb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	56                   	push   %esi
  8018c3:	68 00 50 80 00       	push   $0x805000
  8018c8:	e8 bf f0 ff ff       	call   80098c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018dd:	e8 b8 fd ff ff       	call   80169a <fsipc>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 19                	js     801904 <open+0x75>
	return fd2num(fd);
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f1:	e8 12 f8 ff ff       	call   801108 <fd2num>
  8018f6:	89 c3                	mov    %eax,%ebx
  8018f8:	83 c4 10             	add    $0x10,%esp
}
  8018fb:	89 d8                	mov    %ebx,%eax
  8018fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
		fd_close(fd, 0);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	6a 00                	push   $0x0
  801909:	ff 75 f4             	pushl  -0xc(%ebp)
  80190c:	e8 1b f9 ff ff       	call   80122c <fd_close>
		return r;
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	eb e5                	jmp    8018fb <open+0x6c>
		return -E_BAD_PATH;
  801916:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80191b:	eb de                	jmp    8018fb <open+0x6c>

0080191d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801923:	ba 00 00 00 00       	mov    $0x0,%edx
  801928:	b8 08 00 00 00       	mov    $0x8,%eax
  80192d:	e8 68 fd ff ff       	call   80169a <fsipc>
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80193a:	68 cf 2b 80 00       	push   $0x802bcf
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	e8 45 f0 ff ff       	call   80098c <strcpy>
	return 0;
}
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <devsock_close>:
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	53                   	push   %ebx
  801952:	83 ec 10             	sub    $0x10,%esp
  801955:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801958:	53                   	push   %ebx
  801959:	e8 5d 0a 00 00       	call   8023bb <pageref>
  80195e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801961:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801966:	83 f8 01             	cmp    $0x1,%eax
  801969:	74 07                	je     801972 <devsock_close+0x24>
}
  80196b:	89 d0                	mov    %edx,%eax
  80196d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801970:	c9                   	leave  
  801971:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	ff 73 0c             	pushl  0xc(%ebx)
  801978:	e8 b9 02 00 00       	call   801c36 <nsipc_close>
  80197d:	89 c2                	mov    %eax,%edx
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	eb e7                	jmp    80196b <devsock_close+0x1d>

00801984 <devsock_write>:
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 10             	pushl  0x10(%ebp)
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	ff 70 0c             	pushl  0xc(%eax)
  801998:	e8 76 03 00 00       	call   801d13 <nsipc_send>
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <devsock_read>:
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	ff 70 0c             	pushl  0xc(%eax)
  8019b3:	e8 ef 02 00 00       	call   801ca7 <nsipc_recv>
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <fd2sockid>:
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019c0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	e8 b7 f7 ff ff       	call   801181 <fd_lookup>
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 10                	js     8019e1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019da:	39 08                	cmp    %ecx,(%eax)
  8019dc:	75 05                	jne    8019e3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019de:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e8:	eb f7                	jmp    8019e1 <fd2sockid+0x27>

008019ea <alloc_sockfd>:
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	56                   	push   %esi
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 1c             	sub    $0x1c,%esp
  8019f2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	50                   	push   %eax
  8019f8:	e8 32 f7 ff ff       	call   80112f <fd_alloc>
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 43                	js     801a49 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 07 04 00 00       	push   $0x407
  801a0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a11:	6a 00                	push   $0x0
  801a13:	e8 66 f3 ff ff       	call   800d7e <sys_page_alloc>
  801a18:	89 c3                	mov    %eax,%ebx
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 28                	js     801a49 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a2a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a36:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	50                   	push   %eax
  801a3d:	e8 c6 f6 ff ff       	call   801108 <fd2num>
  801a42:	89 c3                	mov    %eax,%ebx
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	eb 0c                	jmp    801a55 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	56                   	push   %esi
  801a4d:	e8 e4 01 00 00       	call   801c36 <nsipc_close>
		return r;
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    

00801a5e <accept>:
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	e8 4e ff ff ff       	call   8019ba <fd2sockid>
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 1b                	js     801a8b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	ff 75 10             	pushl  0x10(%ebp)
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	50                   	push   %eax
  801a7a:	e8 0e 01 00 00       	call   801b8d <nsipc_accept>
  801a7f:	83 c4 10             	add    $0x10,%esp
  801a82:	85 c0                	test   %eax,%eax
  801a84:	78 05                	js     801a8b <accept+0x2d>
	return alloc_sockfd(r);
  801a86:	e8 5f ff ff ff       	call   8019ea <alloc_sockfd>
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <bind>:
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	e8 1f ff ff ff       	call   8019ba <fd2sockid>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 12                	js     801ab1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	e8 31 01 00 00       	call   801bdf <nsipc_bind>
  801aae:	83 c4 10             	add    $0x10,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <shutdown>:
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	e8 f9 fe ff ff       	call   8019ba <fd2sockid>
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	78 0f                	js     801ad4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ac5:	83 ec 08             	sub    $0x8,%esp
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	50                   	push   %eax
  801acc:	e8 43 01 00 00       	call   801c14 <nsipc_shutdown>
  801ad1:	83 c4 10             	add    $0x10,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <connect>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	e8 d6 fe ff ff       	call   8019ba <fd2sockid>
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 12                	js     801afa <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	50                   	push   %eax
  801af2:	e8 59 01 00 00       	call   801c50 <nsipc_connect>
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <listen>:
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	e8 b0 fe ff ff       	call   8019ba <fd2sockid>
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 0f                	js     801b1d <listen+0x21>
	return nsipc_listen(r, backlog);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	50                   	push   %eax
  801b15:	e8 6b 01 00 00       	call   801c85 <nsipc_listen>
  801b1a:	83 c4 10             	add    $0x10,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <socket>:

int
socket(int domain, int type, int protocol)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	e8 3e 02 00 00       	call   801d71 <nsipc_socket>
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 05                	js     801b3f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b3a:	e8 ab fe ff ff       	call   8019ea <alloc_sockfd>
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	53                   	push   %ebx
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b4a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b51:	74 26                	je     801b79 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b53:	6a 07                	push   $0x7
  801b55:	68 00 60 80 00       	push   $0x806000
  801b5a:	53                   	push   %ebx
  801b5b:	ff 35 04 40 80 00    	pushl  0x804004
  801b61:	e8 c2 07 00 00       	call   802328 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b66:	83 c4 0c             	add    $0xc,%esp
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 4b 07 00 00       	call   8022bf <ipc_recv>
}
  801b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	6a 02                	push   $0x2
  801b7e:	e8 fd 07 00 00       	call   802380 <ipc_find_env>
  801b83:	a3 04 40 80 00       	mov    %eax,0x804004
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	eb c6                	jmp    801b53 <nsipc+0x12>

00801b8d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	56                   	push   %esi
  801b91:	53                   	push   %ebx
  801b92:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b9d:	8b 06                	mov    (%esi),%eax
  801b9f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba9:	e8 93 ff ff ff       	call   801b41 <nsipc>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	79 09                	jns    801bbd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb9:	5b                   	pop    %ebx
  801bba:	5e                   	pop    %esi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	ff 35 10 60 80 00    	pushl  0x806010
  801bc6:	68 00 60 80 00       	push   $0x806000
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	e8 47 ef ff ff       	call   800b1a <memmove>
		*addrlen = ret->ret_addrlen;
  801bd3:	a1 10 60 80 00       	mov    0x806010,%eax
  801bd8:	89 06                	mov    %eax,(%esi)
  801bda:	83 c4 10             	add    $0x10,%esp
	return r;
  801bdd:	eb d5                	jmp    801bb4 <nsipc_accept+0x27>

00801bdf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	53                   	push   %ebx
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bf1:	53                   	push   %ebx
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	68 04 60 80 00       	push   $0x806004
  801bfa:	e8 1b ef ff ff       	call   800b1a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bff:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c05:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0a:	e8 32 ff ff ff       	call   801b41 <nsipc>
}
  801c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c2a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2f:	e8 0d ff ff ff       	call   801b41 <nsipc>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <nsipc_close>:

int
nsipc_close(int s)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c44:	b8 04 00 00 00       	mov    $0x4,%eax
  801c49:	e8 f3 fe ff ff       	call   801b41 <nsipc>
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 08             	sub    $0x8,%esp
  801c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c62:	53                   	push   %ebx
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	68 04 60 80 00       	push   $0x806004
  801c6b:	e8 aa ee ff ff       	call   800b1a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c70:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c76:	b8 05 00 00 00       	mov    $0x5,%eax
  801c7b:	e8 c1 fe ff ff       	call   801b41 <nsipc>
}
  801c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c96:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c9b:	b8 06 00 00 00       	mov    $0x6,%eax
  801ca0:	e8 9c fe ff ff       	call   801b41 <nsipc>
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cb7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cc5:	b8 07 00 00 00       	mov    $0x7,%eax
  801cca:	e8 72 fe ff ff       	call   801b41 <nsipc>
  801ccf:	89 c3                	mov    %eax,%ebx
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 1f                	js     801cf4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cd5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cda:	7f 21                	jg     801cfd <nsipc_recv+0x56>
  801cdc:	39 c6                	cmp    %eax,%esi
  801cde:	7c 1d                	jl     801cfd <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	50                   	push   %eax
  801ce4:	68 00 60 80 00       	push   $0x806000
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	e8 29 ee ff ff       	call   800b1a <memmove>
  801cf1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf9:	5b                   	pop    %ebx
  801cfa:	5e                   	pop    %esi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cfd:	68 db 2b 80 00       	push   $0x802bdb
  801d02:	68 a3 2b 80 00       	push   $0x802ba3
  801d07:	6a 62                	push   $0x62
  801d09:	68 f0 2b 80 00       	push   $0x802bf0
  801d0e:	e8 4b 05 00 00       	call   80225e <_panic>

00801d13 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d25:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d2b:	7f 2e                	jg     801d5b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	53                   	push   %ebx
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	68 0c 60 80 00       	push   $0x80600c
  801d39:	e8 dc ed ff ff       	call   800b1a <memmove>
	nsipcbuf.send.req_size = size;
  801d3e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d44:	8b 45 14             	mov    0x14(%ebp),%eax
  801d47:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d4c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d51:	e8 eb fd ff ff       	call   801b41 <nsipc>
}
  801d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    
	assert(size < 1600);
  801d5b:	68 fc 2b 80 00       	push   $0x802bfc
  801d60:	68 a3 2b 80 00       	push   $0x802ba3
  801d65:	6a 6d                	push   $0x6d
  801d67:	68 f0 2b 80 00       	push   $0x802bf0
  801d6c:	e8 ed 04 00 00       	call   80225e <_panic>

00801d71 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d82:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d87:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d8f:	b8 09 00 00 00       	mov    $0x9,%eax
  801d94:	e8 a8 fd ff ff       	call   801b41 <nsipc>
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	e8 6a f3 ff ff       	call   801118 <fd2data>
  801dae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801db0:	83 c4 08             	add    $0x8,%esp
  801db3:	68 08 2c 80 00       	push   $0x802c08
  801db8:	53                   	push   %ebx
  801db9:	e8 ce eb ff ff       	call   80098c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dbe:	8b 46 04             	mov    0x4(%esi),%eax
  801dc1:	2b 06                	sub    (%esi),%eax
  801dc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dc9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dd0:	00 00 00 
	stat->st_dev = &devpipe;
  801dd3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dda:	30 80 00 
	return 0;
}
  801ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  801de2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de5:	5b                   	pop    %ebx
  801de6:	5e                   	pop    %esi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	53                   	push   %ebx
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801df3:	53                   	push   %ebx
  801df4:	6a 00                	push   $0x0
  801df6:	e8 08 f0 ff ff       	call   800e03 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dfb:	89 1c 24             	mov    %ebx,(%esp)
  801dfe:	e8 15 f3 ff ff       	call   801118 <fd2data>
  801e03:	83 c4 08             	add    $0x8,%esp
  801e06:	50                   	push   %eax
  801e07:	6a 00                	push   $0x0
  801e09:	e8 f5 ef ff ff       	call   800e03 <sys_page_unmap>
}
  801e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <_pipeisclosed>:
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	57                   	push   %edi
  801e17:	56                   	push   %esi
  801e18:	53                   	push   %ebx
  801e19:	83 ec 1c             	sub    $0x1c,%esp
  801e1c:	89 c7                	mov    %eax,%edi
  801e1e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e20:	a1 08 40 80 00       	mov    0x804008,%eax
  801e25:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	57                   	push   %edi
  801e2c:	e8 8a 05 00 00       	call   8023bb <pageref>
  801e31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e34:	89 34 24             	mov    %esi,(%esp)
  801e37:	e8 7f 05 00 00       	call   8023bb <pageref>
		nn = thisenv->env_runs;
  801e3c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e42:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	39 cb                	cmp    %ecx,%ebx
  801e4a:	74 1b                	je     801e67 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e4f:	75 cf                	jne    801e20 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e51:	8b 42 58             	mov    0x58(%edx),%eax
  801e54:	6a 01                	push   $0x1
  801e56:	50                   	push   %eax
  801e57:	53                   	push   %ebx
  801e58:	68 0f 2c 80 00       	push   $0x802c0f
  801e5d:	e8 cb e3 ff ff       	call   80022d <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	eb b9                	jmp    801e20 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e67:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6a:	0f 94 c0             	sete   %al
  801e6d:	0f b6 c0             	movzbl %al,%eax
}
  801e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5f                   	pop    %edi
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <devpipe_write>:
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	57                   	push   %edi
  801e7c:	56                   	push   %esi
  801e7d:	53                   	push   %ebx
  801e7e:	83 ec 28             	sub    $0x28,%esp
  801e81:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e84:	56                   	push   %esi
  801e85:	e8 8e f2 ff ff       	call   801118 <fd2data>
  801e8a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e94:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e97:	74 4f                	je     801ee8 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e99:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9c:	8b 0b                	mov    (%ebx),%ecx
  801e9e:	8d 51 20             	lea    0x20(%ecx),%edx
  801ea1:	39 d0                	cmp    %edx,%eax
  801ea3:	72 14                	jb     801eb9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ea5:	89 da                	mov    %ebx,%edx
  801ea7:	89 f0                	mov    %esi,%eax
  801ea9:	e8 65 ff ff ff       	call   801e13 <_pipeisclosed>
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	75 3b                	jne    801eed <devpipe_write+0x75>
			sys_yield();
  801eb2:	e8 a8 ee ff ff       	call   800d5f <sys_yield>
  801eb7:	eb e0                	jmp    801e99 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ebc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ec0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ec3:	89 c2                	mov    %eax,%edx
  801ec5:	c1 fa 1f             	sar    $0x1f,%edx
  801ec8:	89 d1                	mov    %edx,%ecx
  801eca:	c1 e9 1b             	shr    $0x1b,%ecx
  801ecd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ed0:	83 e2 1f             	and    $0x1f,%edx
  801ed3:	29 ca                	sub    %ecx,%edx
  801ed5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ed9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801edd:	83 c0 01             	add    $0x1,%eax
  801ee0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ee3:	83 c7 01             	add    $0x1,%edi
  801ee6:	eb ac                	jmp    801e94 <devpipe_write+0x1c>
	return i;
  801ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eeb:	eb 05                	jmp    801ef2 <devpipe_write+0x7a>
				return 0;
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <devpipe_read>:
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	57                   	push   %edi
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	83 ec 18             	sub    $0x18,%esp
  801f03:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f06:	57                   	push   %edi
  801f07:	e8 0c f2 ff ff       	call   801118 <fd2data>
  801f0c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	be 00 00 00 00       	mov    $0x0,%esi
  801f16:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f19:	75 14                	jne    801f2f <devpipe_read+0x35>
	return i;
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	eb 02                	jmp    801f22 <devpipe_read+0x28>
				return i;
  801f20:	89 f0                	mov    %esi,%eax
}
  801f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f25:	5b                   	pop    %ebx
  801f26:	5e                   	pop    %esi
  801f27:	5f                   	pop    %edi
  801f28:	5d                   	pop    %ebp
  801f29:	c3                   	ret    
			sys_yield();
  801f2a:	e8 30 ee ff ff       	call   800d5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f2f:	8b 03                	mov    (%ebx),%eax
  801f31:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f34:	75 18                	jne    801f4e <devpipe_read+0x54>
			if (i > 0)
  801f36:	85 f6                	test   %esi,%esi
  801f38:	75 e6                	jne    801f20 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f3a:	89 da                	mov    %ebx,%edx
  801f3c:	89 f8                	mov    %edi,%eax
  801f3e:	e8 d0 fe ff ff       	call   801e13 <_pipeisclosed>
  801f43:	85 c0                	test   %eax,%eax
  801f45:	74 e3                	je     801f2a <devpipe_read+0x30>
				return 0;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	eb d4                	jmp    801f22 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f4e:	99                   	cltd   
  801f4f:	c1 ea 1b             	shr    $0x1b,%edx
  801f52:	01 d0                	add    %edx,%eax
  801f54:	83 e0 1f             	and    $0x1f,%eax
  801f57:	29 d0                	sub    %edx,%eax
  801f59:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f61:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f64:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f67:	83 c6 01             	add    $0x1,%esi
  801f6a:	eb aa                	jmp    801f16 <devpipe_read+0x1c>

00801f6c <pipe>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	56                   	push   %esi
  801f70:	53                   	push   %ebx
  801f71:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f77:	50                   	push   %eax
  801f78:	e8 b2 f1 ff ff       	call   80112f <fd_alloc>
  801f7d:	89 c3                	mov    %eax,%ebx
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	85 c0                	test   %eax,%eax
  801f84:	0f 88 23 01 00 00    	js     8020ad <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8a:	83 ec 04             	sub    $0x4,%esp
  801f8d:	68 07 04 00 00       	push   $0x407
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	6a 00                	push   $0x0
  801f97:	e8 e2 ed ff ff       	call   800d7e <sys_page_alloc>
  801f9c:	89 c3                	mov    %eax,%ebx
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	0f 88 04 01 00 00    	js     8020ad <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fa9:	83 ec 0c             	sub    $0xc,%esp
  801fac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801faf:	50                   	push   %eax
  801fb0:	e8 7a f1 ff ff       	call   80112f <fd_alloc>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	0f 88 db 00 00 00    	js     80209d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc2:	83 ec 04             	sub    $0x4,%esp
  801fc5:	68 07 04 00 00       	push   $0x407
  801fca:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 aa ed ff ff       	call   800d7e <sys_page_alloc>
  801fd4:	89 c3                	mov    %eax,%ebx
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	0f 88 bc 00 00 00    	js     80209d <pipe+0x131>
	va = fd2data(fd0);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe7:	e8 2c f1 ff ff       	call   801118 <fd2data>
  801fec:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fee:	83 c4 0c             	add    $0xc,%esp
  801ff1:	68 07 04 00 00       	push   $0x407
  801ff6:	50                   	push   %eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 80 ed ff ff       	call   800d7e <sys_page_alloc>
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	0f 88 82 00 00 00    	js     80208d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	ff 75 f0             	pushl  -0x10(%ebp)
  802011:	e8 02 f1 ff ff       	call   801118 <fd2data>
  802016:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80201d:	50                   	push   %eax
  80201e:	6a 00                	push   $0x0
  802020:	56                   	push   %esi
  802021:	6a 00                	push   $0x0
  802023:	e8 99 ed ff ff       	call   800dc1 <sys_page_map>
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	83 c4 20             	add    $0x20,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 4e                	js     80207f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802031:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802039:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80203b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802048:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	ff 75 f4             	pushl  -0xc(%ebp)
  80205a:	e8 a9 f0 ff ff       	call   801108 <fd2num>
  80205f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802062:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802064:	83 c4 04             	add    $0x4,%esp
  802067:	ff 75 f0             	pushl  -0x10(%ebp)
  80206a:	e8 99 f0 ff ff       	call   801108 <fd2num>
  80206f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802072:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	bb 00 00 00 00       	mov    $0x0,%ebx
  80207d:	eb 2e                	jmp    8020ad <pipe+0x141>
	sys_page_unmap(0, va);
  80207f:	83 ec 08             	sub    $0x8,%esp
  802082:	56                   	push   %esi
  802083:	6a 00                	push   $0x0
  802085:	e8 79 ed ff ff       	call   800e03 <sys_page_unmap>
  80208a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	ff 75 f0             	pushl  -0x10(%ebp)
  802093:	6a 00                	push   $0x0
  802095:	e8 69 ed ff ff       	call   800e03 <sys_page_unmap>
  80209a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 59 ed ff ff       	call   800e03 <sys_page_unmap>
  8020aa:	83 c4 10             	add    $0x10,%esp
}
  8020ad:	89 d8                	mov    %ebx,%eax
  8020af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b2:	5b                   	pop    %ebx
  8020b3:	5e                   	pop    %esi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    

008020b6 <pipeisclosed>:
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bf:	50                   	push   %eax
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	e8 b9 f0 ff ff       	call   801181 <fd_lookup>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 18                	js     8020e7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d5:	e8 3e f0 ff ff       	call   801118 <fd2data>
	return _pipeisclosed(fd, p);
  8020da:	89 c2                	mov    %eax,%edx
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	e8 2f fd ff ff       	call   801e13 <_pipeisclosed>
  8020e4:	83 c4 10             	add    $0x10,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	c3                   	ret    

008020ef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020f5:	68 27 2c 80 00       	push   $0x802c27
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	e8 8a e8 ff ff       	call   80098c <strcpy>
	return 0;
}
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <devcons_write>:
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	57                   	push   %edi
  80210d:	56                   	push   %esi
  80210e:	53                   	push   %ebx
  80210f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802115:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80211a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802120:	3b 75 10             	cmp    0x10(%ebp),%esi
  802123:	73 31                	jae    802156 <devcons_write+0x4d>
		m = n - tot;
  802125:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802128:	29 f3                	sub    %esi,%ebx
  80212a:	83 fb 7f             	cmp    $0x7f,%ebx
  80212d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802132:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	53                   	push   %ebx
  802139:	89 f0                	mov    %esi,%eax
  80213b:	03 45 0c             	add    0xc(%ebp),%eax
  80213e:	50                   	push   %eax
  80213f:	57                   	push   %edi
  802140:	e8 d5 e9 ff ff       	call   800b1a <memmove>
		sys_cputs(buf, m);
  802145:	83 c4 08             	add    $0x8,%esp
  802148:	53                   	push   %ebx
  802149:	57                   	push   %edi
  80214a:	e8 73 eb ff ff       	call   800cc2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80214f:	01 de                	add    %ebx,%esi
  802151:	83 c4 10             	add    $0x10,%esp
  802154:	eb ca                	jmp    802120 <devcons_write+0x17>
}
  802156:	89 f0                	mov    %esi,%eax
  802158:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5e                   	pop    %esi
  80215d:	5f                   	pop    %edi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <devcons_read>:
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80216b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80216f:	74 21                	je     802192 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802171:	e8 6a eb ff ff       	call   800ce0 <sys_cgetc>
  802176:	85 c0                	test   %eax,%eax
  802178:	75 07                	jne    802181 <devcons_read+0x21>
		sys_yield();
  80217a:	e8 e0 eb ff ff       	call   800d5f <sys_yield>
  80217f:	eb f0                	jmp    802171 <devcons_read+0x11>
	if (c < 0)
  802181:	78 0f                	js     802192 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802183:	83 f8 04             	cmp    $0x4,%eax
  802186:	74 0c                	je     802194 <devcons_read+0x34>
	*(char*)vbuf = c;
  802188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218b:	88 02                	mov    %al,(%edx)
	return 1;
  80218d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    
		return 0;
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	eb f7                	jmp    802192 <devcons_read+0x32>

0080219b <cputchar>:
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021a7:	6a 01                	push   $0x1
  8021a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ac:	50                   	push   %eax
  8021ad:	e8 10 eb ff ff       	call   800cc2 <sys_cputs>
}
  8021b2:	83 c4 10             	add    $0x10,%esp
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <getchar>:
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021bd:	6a 01                	push   $0x1
  8021bf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c2:	50                   	push   %eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	e8 27 f2 ff ff       	call   8013f1 <read>
	if (r < 0)
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 06                	js     8021d7 <getchar+0x20>
	if (r < 1)
  8021d1:	74 06                	je     8021d9 <getchar+0x22>
	return c;
  8021d3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    
		return -E_EOF;
  8021d9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021de:	eb f7                	jmp    8021d7 <getchar+0x20>

008021e0 <iscons>:
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e9:	50                   	push   %eax
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	e8 8f ef ff ff       	call   801181 <fd_lookup>
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 11                	js     80220a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802202:	39 10                	cmp    %edx,(%eax)
  802204:	0f 94 c0             	sete   %al
  802207:	0f b6 c0             	movzbl %al,%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <opencons>:
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802215:	50                   	push   %eax
  802216:	e8 14 ef ff ff       	call   80112f <fd_alloc>
  80221b:	83 c4 10             	add    $0x10,%esp
  80221e:	85 c0                	test   %eax,%eax
  802220:	78 3a                	js     80225c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 07 04 00 00       	push   $0x407
  80222a:	ff 75 f4             	pushl  -0xc(%ebp)
  80222d:	6a 00                	push   $0x0
  80222f:	e8 4a eb ff ff       	call   800d7e <sys_page_alloc>
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	85 c0                	test   %eax,%eax
  802239:	78 21                	js     80225c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802244:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	50                   	push   %eax
  802254:	e8 af ee ff ff       	call   801108 <fd2num>
  802259:	83 c4 10             	add    $0x10,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	56                   	push   %esi
  802262:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802263:	a1 08 40 80 00       	mov    0x804008,%eax
  802268:	8b 40 48             	mov    0x48(%eax),%eax
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	68 58 2c 80 00       	push   $0x802c58
  802273:	50                   	push   %eax
  802274:	68 d0 26 80 00       	push   $0x8026d0
  802279:	e8 af df ff ff       	call   80022d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80227e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802281:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802287:	e8 b4 ea ff ff       	call   800d40 <sys_getenvid>
  80228c:	83 c4 04             	add    $0x4,%esp
  80228f:	ff 75 0c             	pushl  0xc(%ebp)
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	56                   	push   %esi
  802296:	50                   	push   %eax
  802297:	68 34 2c 80 00       	push   $0x802c34
  80229c:	e8 8c df ff ff       	call   80022d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022a1:	83 c4 18             	add    $0x18,%esp
  8022a4:	53                   	push   %ebx
  8022a5:	ff 75 10             	pushl  0x10(%ebp)
  8022a8:	e8 2f df ff ff       	call   8001dc <vcprintf>
	cprintf("\n");
  8022ad:	c7 04 24 94 26 80 00 	movl   $0x802694,(%esp)
  8022b4:	e8 74 df ff ff       	call   80022d <cprintf>
  8022b9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022bc:	cc                   	int3   
  8022bd:	eb fd                	jmp    8022bc <_panic+0x5e>

008022bf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022cd:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022cf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022d4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	50                   	push   %eax
  8022db:	e8 4e ec ff ff       	call   800f2e <sys_ipc_recv>
	if(ret < 0){
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 2b                	js     802312 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022e7:	85 f6                	test   %esi,%esi
  8022e9:	74 0a                	je     8022f5 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f0:	8b 40 74             	mov    0x74(%eax),%eax
  8022f3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022f5:	85 db                	test   %ebx,%ebx
  8022f7:	74 0a                	je     802303 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022fe:	8b 40 78             	mov    0x78(%eax),%eax
  802301:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802303:	a1 08 40 80 00       	mov    0x804008,%eax
  802308:	8b 40 70             	mov    0x70(%eax),%eax
}
  80230b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230e:	5b                   	pop    %ebx
  80230f:	5e                   	pop    %esi
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
		if(from_env_store)
  802312:	85 f6                	test   %esi,%esi
  802314:	74 06                	je     80231c <ipc_recv+0x5d>
			*from_env_store = 0;
  802316:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80231c:	85 db                	test   %ebx,%ebx
  80231e:	74 eb                	je     80230b <ipc_recv+0x4c>
			*perm_store = 0;
  802320:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802326:	eb e3                	jmp    80230b <ipc_recv+0x4c>

00802328 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	57                   	push   %edi
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 0c             	sub    $0xc,%esp
  802331:	8b 7d 08             	mov    0x8(%ebp),%edi
  802334:	8b 75 0c             	mov    0xc(%ebp),%esi
  802337:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80233a:	85 db                	test   %ebx,%ebx
  80233c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802341:	0f 44 d8             	cmove  %eax,%ebx
  802344:	eb 05                	jmp    80234b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802346:	e8 14 ea ff ff       	call   800d5f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80234b:	ff 75 14             	pushl  0x14(%ebp)
  80234e:	53                   	push   %ebx
  80234f:	56                   	push   %esi
  802350:	57                   	push   %edi
  802351:	e8 b5 eb ff ff       	call   800f0b <sys_ipc_try_send>
  802356:	83 c4 10             	add    $0x10,%esp
  802359:	85 c0                	test   %eax,%eax
  80235b:	74 1b                	je     802378 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80235d:	79 e7                	jns    802346 <ipc_send+0x1e>
  80235f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802362:	74 e2                	je     802346 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802364:	83 ec 04             	sub    $0x4,%esp
  802367:	68 5f 2c 80 00       	push   $0x802c5f
  80236c:	6a 46                	push   $0x46
  80236e:	68 74 2c 80 00       	push   $0x802c74
  802373:	e8 e6 fe ff ff       	call   80225e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5f                   	pop    %edi
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80238b:	89 c2                	mov    %eax,%edx
  80238d:	c1 e2 07             	shl    $0x7,%edx
  802390:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802396:	8b 52 50             	mov    0x50(%edx),%edx
  802399:	39 ca                	cmp    %ecx,%edx
  80239b:	74 11                	je     8023ae <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80239d:	83 c0 01             	add    $0x1,%eax
  8023a0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023a5:	75 e4                	jne    80238b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	eb 0b                	jmp    8023b9 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023ae:	c1 e0 07             	shl    $0x7,%eax
  8023b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023b6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023b9:	5d                   	pop    %ebp
  8023ba:	c3                   	ret    

008023bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c1:	89 d0                	mov    %edx,%eax
  8023c3:	c1 e8 16             	shr    $0x16,%eax
  8023c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023d2:	f6 c1 01             	test   $0x1,%cl
  8023d5:	74 1d                	je     8023f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023d7:	c1 ea 0c             	shr    $0xc,%edx
  8023da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e1:	f6 c2 01             	test   $0x1,%dl
  8023e4:	74 0e                	je     8023f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e6:	c1 ea 0c             	shr    $0xc,%edx
  8023e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f0:	ef 
  8023f1:	0f b7 c0             	movzwl %ax,%eax
}
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	66 90                	xchg   %ax,%ax
  8023f8:	66 90                	xchg   %ax,%ax
  8023fa:	66 90                	xchg   %ax,%ax
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
