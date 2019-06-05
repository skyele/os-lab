
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
  800039:	68 50 26 80 00       	push   $0x802650
  80003e:	68 40 26 80 00       	push   $0x802640
  800043:	e8 e5 01 00 00       	call   80022d <cprintf>
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("in %s\n", __FUNCTION__);
  800048:	83 c4 08             	add    $0x8,%esp
  80004b:	68 50 26 80 00       	push   $0x802650
  800050:	68 b4 26 80 00       	push   $0x8026b4
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
  800077:	e8 d7 0f 00 00       	call   801053 <set_pgfault_handler>
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
  80010e:	68 58 26 80 00       	push   $0x802658
  800113:	e8 15 01 00 00       	call   80022d <cprintf>
	cprintf("before umain\n");
  800118:	c7 04 24 76 26 80 00 	movl   $0x802676,(%esp)
  80011f:	e8 09 01 00 00       	call   80022d <cprintf>
	// call user main routine
	umain(argc, argv);
  800124:	83 c4 08             	add    $0x8,%esp
  800127:	ff 75 0c             	pushl  0xc(%ebp)
  80012a:	ff 75 08             	pushl  0x8(%ebp)
  80012d:	e8 3a ff ff ff       	call   80006c <umain>
	cprintf("after umain\n");
  800132:	c7 04 24 84 26 80 00 	movl   $0x802684,(%esp)
  800139:	e8 ef 00 00 00       	call   80022d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80013e:	a1 08 40 80 00       	mov    0x804008,%eax
  800143:	8b 40 48             	mov    0x48(%eax),%eax
  800146:	83 c4 08             	add    $0x8,%esp
  800149:	50                   	push   %eax
  80014a:	68 91 26 80 00       	push   $0x802691
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
  800172:	68 bc 26 80 00       	push   $0x8026bc
  800177:	50                   	push   %eax
  800178:	68 b0 26 80 00       	push   $0x8026b0
  80017d:	e8 ab 00 00 00       	call   80022d <cprintf>
	close_all();
  800182:	e8 39 11 00 00       	call   8012c0 <close_all>
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
  8002da:	e8 01 21 00 00       	call   8023e0 <__udivdi3>
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
  800303:	e8 e8 21 00 00       	call   8024f0 <__umoddi3>
  800308:	83 c4 14             	add    $0x14,%esp
  80030b:	0f be 80 c1 26 80 00 	movsbl 0x8026c1(%eax),%eax
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
  8003b4:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
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
  80047f:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 95 2b 80 00       	push   $0x802b95
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 a6 fe ff ff       	call   80033d <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 fe 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 d9 26 80 00       	push   $0x8026d9
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
  8004ca:	b8 d2 26 80 00       	mov    $0x8026d2,%eax
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
  800862:	bf f5 27 80 00       	mov    $0x8027f5,%edi
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
  80088e:	bf 2d 28 80 00       	mov    $0x80282d,%edi
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
  800d2f:	68 48 2a 80 00       	push   $0x802a48
  800d34:	6a 43                	push   $0x43
  800d36:	68 65 2a 80 00       	push   $0x802a65
  800d3b:	e8 fe 14 00 00       	call   80223e <_panic>

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
  800db0:	68 48 2a 80 00       	push   $0x802a48
  800db5:	6a 43                	push   $0x43
  800db7:	68 65 2a 80 00       	push   $0x802a65
  800dbc:	e8 7d 14 00 00       	call   80223e <_panic>

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
  800df2:	68 48 2a 80 00       	push   $0x802a48
  800df7:	6a 43                	push   $0x43
  800df9:	68 65 2a 80 00       	push   $0x802a65
  800dfe:	e8 3b 14 00 00       	call   80223e <_panic>

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
  800e34:	68 48 2a 80 00       	push   $0x802a48
  800e39:	6a 43                	push   $0x43
  800e3b:	68 65 2a 80 00       	push   $0x802a65
  800e40:	e8 f9 13 00 00       	call   80223e <_panic>

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
  800e76:	68 48 2a 80 00       	push   $0x802a48
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 65 2a 80 00       	push   $0x802a65
  800e82:	e8 b7 13 00 00       	call   80223e <_panic>

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
  800eb8:	68 48 2a 80 00       	push   $0x802a48
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 65 2a 80 00       	push   $0x802a65
  800ec4:	e8 75 13 00 00       	call   80223e <_panic>

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
  800efa:	68 48 2a 80 00       	push   $0x802a48
  800eff:	6a 43                	push   $0x43
  800f01:	68 65 2a 80 00       	push   $0x802a65
  800f06:	e8 33 13 00 00       	call   80223e <_panic>

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
  800f5e:	68 48 2a 80 00       	push   $0x802a48
  800f63:	6a 43                	push   $0x43
  800f65:	68 65 2a 80 00       	push   $0x802a65
  800f6a:	e8 cf 12 00 00       	call   80223e <_panic>

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
  801042:	68 48 2a 80 00       	push   $0x802a48
  801047:	6a 43                	push   $0x43
  801049:	68 65 2a 80 00       	push   $0x802a65
  80104e:	e8 eb 11 00 00       	call   80223e <_panic>

00801053 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801059:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801060:	74 0a                	je     80106c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80106c:	83 ec 04             	sub    $0x4,%esp
  80106f:	6a 07                	push   $0x7
  801071:	68 00 f0 bf ee       	push   $0xeebff000
  801076:	6a 00                	push   $0x0
  801078:	e8 01 fd ff ff       	call   800d7e <sys_page_alloc>
		if(r < 0)
  80107d:	83 c4 10             	add    $0x10,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 2a                	js     8010ae <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	68 c2 10 80 00       	push   $0x8010c2
  80108c:	6a 00                	push   $0x0
  80108e:	e8 36 fe ff ff       	call   800ec9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	79 c8                	jns    801062 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80109a:	83 ec 04             	sub    $0x4,%esp
  80109d:	68 a4 2a 80 00       	push   $0x802aa4
  8010a2:	6a 25                	push   $0x25
  8010a4:	68 dd 2a 80 00       	push   $0x802add
  8010a9:	e8 90 11 00 00       	call   80223e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8010ae:	83 ec 04             	sub    $0x4,%esp
  8010b1:	68 74 2a 80 00       	push   $0x802a74
  8010b6:	6a 22                	push   $0x22
  8010b8:	68 dd 2a 80 00       	push   $0x802add
  8010bd:	e8 7c 11 00 00       	call   80223e <_panic>

008010c2 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010c2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010c3:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010c8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010ca:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8010cd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8010d1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8010d5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8010d8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8010da:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8010de:	83 c4 08             	add    $0x8,%esp
	popal
  8010e1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010e2:	83 c4 04             	add    $0x4,%esp
	popfl
  8010e5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010e6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8010e7:	c3                   	ret    

008010e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	05 00 00 00 30       	add    $0x30000000,%eax
  8010f3:	c1 e8 0c             	shr    $0xc,%eax
}
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801103:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801108:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801117:	89 c2                	mov    %eax,%edx
  801119:	c1 ea 16             	shr    $0x16,%edx
  80111c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801123:	f6 c2 01             	test   $0x1,%dl
  801126:	74 2d                	je     801155 <fd_alloc+0x46>
  801128:	89 c2                	mov    %eax,%edx
  80112a:	c1 ea 0c             	shr    $0xc,%edx
  80112d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801134:	f6 c2 01             	test   $0x1,%dl
  801137:	74 1c                	je     801155 <fd_alloc+0x46>
  801139:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80113e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801143:	75 d2                	jne    801117 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80114e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801153:	eb 0a                	jmp    80115f <fd_alloc+0x50>
			*fd_store = fd;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	89 01                	mov    %eax,(%ecx)
			return 0;
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801167:	83 f8 1f             	cmp    $0x1f,%eax
  80116a:	77 30                	ja     80119c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80116c:	c1 e0 0c             	shl    $0xc,%eax
  80116f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801174:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 24                	je     8011a3 <fd_lookup+0x42>
  80117f:	89 c2                	mov    %eax,%edx
  801181:	c1 ea 0c             	shr    $0xc,%edx
  801184:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118b:	f6 c2 01             	test   $0x1,%dl
  80118e:	74 1a                	je     8011aa <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801190:	8b 55 0c             	mov    0xc(%ebp),%edx
  801193:	89 02                	mov    %eax,(%edx)
	return 0;
  801195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    
		return -E_INVAL;
  80119c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a1:	eb f7                	jmp    80119a <fd_lookup+0x39>
		return -E_INVAL;
  8011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a8:	eb f0                	jmp    80119a <fd_lookup+0x39>
  8011aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011af:	eb e9                	jmp    80119a <fd_lookup+0x39>

008011b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011c4:	39 08                	cmp    %ecx,(%eax)
  8011c6:	74 38                	je     801200 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011c8:	83 c2 01             	add    $0x1,%edx
  8011cb:	8b 04 95 68 2b 80 00 	mov    0x802b68(,%edx,4),%eax
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	75 ee                	jne    8011c4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011db:	8b 40 48             	mov    0x48(%eax),%eax
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	51                   	push   %ecx
  8011e2:	50                   	push   %eax
  8011e3:	68 ec 2a 80 00       	push   $0x802aec
  8011e8:	e8 40 f0 ff ff       	call   80022d <cprintf>
	*dev = 0;
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    
			*dev = devtab[i];
  801200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801203:	89 01                	mov    %eax,(%ecx)
			return 0;
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	eb f2                	jmp    8011fe <dev_lookup+0x4d>

0080120c <fd_close>:
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
  801212:	83 ec 24             	sub    $0x24,%esp
  801215:	8b 75 08             	mov    0x8(%ebp),%esi
  801218:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80121b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801225:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801228:	50                   	push   %eax
  801229:	e8 33 ff ff ff       	call   801161 <fd_lookup>
  80122e:	89 c3                	mov    %eax,%ebx
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 05                	js     80123c <fd_close+0x30>
	    || fd != fd2)
  801237:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80123a:	74 16                	je     801252 <fd_close+0x46>
		return (must_exist ? r : 0);
  80123c:	89 f8                	mov    %edi,%eax
  80123e:	84 c0                	test   %al,%al
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	0f 44 d8             	cmove  %eax,%ebx
}
  801248:	89 d8                	mov    %ebx,%eax
  80124a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124d:	5b                   	pop    %ebx
  80124e:	5e                   	pop    %esi
  80124f:	5f                   	pop    %edi
  801250:	5d                   	pop    %ebp
  801251:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801252:	83 ec 08             	sub    $0x8,%esp
  801255:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	ff 36                	pushl  (%esi)
  80125b:	e8 51 ff ff ff       	call   8011b1 <dev_lookup>
  801260:	89 c3                	mov    %eax,%ebx
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	78 1a                	js     801283 <fd_close+0x77>
		if (dev->dev_close)
  801269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80126f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801274:	85 c0                	test   %eax,%eax
  801276:	74 0b                	je     801283 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801278:	83 ec 0c             	sub    $0xc,%esp
  80127b:	56                   	push   %esi
  80127c:	ff d0                	call   *%eax
  80127e:	89 c3                	mov    %eax,%ebx
  801280:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	56                   	push   %esi
  801287:	6a 00                	push   $0x0
  801289:	e8 75 fb ff ff       	call   800e03 <sys_page_unmap>
	return r;
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	eb b5                	jmp    801248 <fd_close+0x3c>

00801293 <close>:

int
close(int fdnum)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 bc fe ff ff       	call   801161 <fd_lookup>
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	79 02                	jns    8012ae <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    
		return fd_close(fd, 1);
  8012ae:	83 ec 08             	sub    $0x8,%esp
  8012b1:	6a 01                	push   $0x1
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	e8 51 ff ff ff       	call   80120c <fd_close>
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	eb ec                	jmp    8012ac <close+0x19>

008012c0 <close_all>:

void
close_all(void)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	53                   	push   %ebx
  8012c4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012c7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	53                   	push   %ebx
  8012d0:	e8 be ff ff ff       	call   801293 <close>
	for (i = 0; i < MAXFD; i++)
  8012d5:	83 c3 01             	add    $0x1,%ebx
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	83 fb 20             	cmp    $0x20,%ebx
  8012de:	75 ec                	jne    8012cc <close_all+0xc>
}
  8012e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	ff 75 08             	pushl  0x8(%ebp)
  8012f5:	e8 67 fe ff ff       	call   801161 <fd_lookup>
  8012fa:	89 c3                	mov    %eax,%ebx
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	0f 88 81 00 00 00    	js     801388 <dup+0xa3>
		return r;
	close(newfdnum);
  801307:	83 ec 0c             	sub    $0xc,%esp
  80130a:	ff 75 0c             	pushl  0xc(%ebp)
  80130d:	e8 81 ff ff ff       	call   801293 <close>

	newfd = INDEX2FD(newfdnum);
  801312:	8b 75 0c             	mov    0xc(%ebp),%esi
  801315:	c1 e6 0c             	shl    $0xc,%esi
  801318:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80131e:	83 c4 04             	add    $0x4,%esp
  801321:	ff 75 e4             	pushl  -0x1c(%ebp)
  801324:	e8 cf fd ff ff       	call   8010f8 <fd2data>
  801329:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80132b:	89 34 24             	mov    %esi,(%esp)
  80132e:	e8 c5 fd ff ff       	call   8010f8 <fd2data>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801338:	89 d8                	mov    %ebx,%eax
  80133a:	c1 e8 16             	shr    $0x16,%eax
  80133d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801344:	a8 01                	test   $0x1,%al
  801346:	74 11                	je     801359 <dup+0x74>
  801348:	89 d8                	mov    %ebx,%eax
  80134a:	c1 e8 0c             	shr    $0xc,%eax
  80134d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801354:	f6 c2 01             	test   $0x1,%dl
  801357:	75 39                	jne    801392 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801359:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80135c:	89 d0                	mov    %edx,%eax
  80135e:	c1 e8 0c             	shr    $0xc,%eax
  801361:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	25 07 0e 00 00       	and    $0xe07,%eax
  801370:	50                   	push   %eax
  801371:	56                   	push   %esi
  801372:	6a 00                	push   $0x0
  801374:	52                   	push   %edx
  801375:	6a 00                	push   $0x0
  801377:	e8 45 fa ff ff       	call   800dc1 <sys_page_map>
  80137c:	89 c3                	mov    %eax,%ebx
  80137e:	83 c4 20             	add    $0x20,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	78 31                	js     8013b6 <dup+0xd1>
		goto err;

	return newfdnum;
  801385:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801388:	89 d8                	mov    %ebx,%eax
  80138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5f                   	pop    %edi
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801392:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a1:	50                   	push   %eax
  8013a2:	57                   	push   %edi
  8013a3:	6a 00                	push   $0x0
  8013a5:	53                   	push   %ebx
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 14 fa ff ff       	call   800dc1 <sys_page_map>
  8013ad:	89 c3                	mov    %eax,%ebx
  8013af:	83 c4 20             	add    $0x20,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	79 a3                	jns    801359 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	56                   	push   %esi
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 42 fa ff ff       	call   800e03 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013c1:	83 c4 08             	add    $0x8,%esp
  8013c4:	57                   	push   %edi
  8013c5:	6a 00                	push   $0x0
  8013c7:	e8 37 fa ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	eb b7                	jmp    801388 <dup+0xa3>

008013d1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	53                   	push   %ebx
  8013d5:	83 ec 1c             	sub    $0x1c,%esp
  8013d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013de:	50                   	push   %eax
  8013df:	53                   	push   %ebx
  8013e0:	e8 7c fd ff ff       	call   801161 <fd_lookup>
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	78 3f                	js     80142b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f2:	50                   	push   %eax
  8013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f6:	ff 30                	pushl  (%eax)
  8013f8:	e8 b4 fd ff ff       	call   8011b1 <dev_lookup>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 27                	js     80142b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801404:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801407:	8b 42 08             	mov    0x8(%edx),%eax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	83 f8 01             	cmp    $0x1,%eax
  801410:	74 1e                	je     801430 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801415:	8b 40 08             	mov    0x8(%eax),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 35                	je     801451 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	ff 75 10             	pushl  0x10(%ebp)
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	52                   	push   %edx
  801426:	ff d0                	call   *%eax
  801428:	83 c4 10             	add    $0x10,%esp
}
  80142b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801430:	a1 08 40 80 00       	mov    0x804008,%eax
  801435:	8b 40 48             	mov    0x48(%eax),%eax
  801438:	83 ec 04             	sub    $0x4,%esp
  80143b:	53                   	push   %ebx
  80143c:	50                   	push   %eax
  80143d:	68 2d 2b 80 00       	push   $0x802b2d
  801442:	e8 e6 ed ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144f:	eb da                	jmp    80142b <read+0x5a>
		return -E_NOT_SUPP;
  801451:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801456:	eb d3                	jmp    80142b <read+0x5a>

00801458 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 0c             	sub    $0xc,%esp
  801461:	8b 7d 08             	mov    0x8(%ebp),%edi
  801464:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801467:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146c:	39 f3                	cmp    %esi,%ebx
  80146e:	73 23                	jae    801493 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801470:	83 ec 04             	sub    $0x4,%esp
  801473:	89 f0                	mov    %esi,%eax
  801475:	29 d8                	sub    %ebx,%eax
  801477:	50                   	push   %eax
  801478:	89 d8                	mov    %ebx,%eax
  80147a:	03 45 0c             	add    0xc(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	57                   	push   %edi
  80147f:	e8 4d ff ff ff       	call   8013d1 <read>
		if (m < 0)
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 06                	js     801491 <readn+0x39>
			return m;
		if (m == 0)
  80148b:	74 06                	je     801493 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80148d:	01 c3                	add    %eax,%ebx
  80148f:	eb db                	jmp    80146c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801491:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801493:	89 d8                	mov    %ebx,%eax
  801495:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801498:	5b                   	pop    %ebx
  801499:	5e                   	pop    %esi
  80149a:	5f                   	pop    %edi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	53                   	push   %ebx
  8014a1:	83 ec 1c             	sub    $0x1c,%esp
  8014a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	53                   	push   %ebx
  8014ac:	e8 b0 fc ff ff       	call   801161 <fd_lookup>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 3a                	js     8014f2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014be:	50                   	push   %eax
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c2:	ff 30                	pushl  (%eax)
  8014c4:	e8 e8 fc ff ff       	call   8011b1 <dev_lookup>
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 22                	js     8014f2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d7:	74 1e                	je     8014f7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014df:	85 d2                	test   %edx,%edx
  8014e1:	74 35                	je     801518 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	ff 75 10             	pushl  0x10(%ebp)
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	50                   	push   %eax
  8014ed:	ff d2                	call   *%edx
  8014ef:	83 c4 10             	add    $0x10,%esp
}
  8014f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014fc:	8b 40 48             	mov    0x48(%eax),%eax
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	53                   	push   %ebx
  801503:	50                   	push   %eax
  801504:	68 49 2b 80 00       	push   $0x802b49
  801509:	e8 1f ed ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801516:	eb da                	jmp    8014f2 <write+0x55>
		return -E_NOT_SUPP;
  801518:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151d:	eb d3                	jmp    8014f2 <write+0x55>

0080151f <seek>:

int
seek(int fdnum, off_t offset)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801525:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 30 fc ff ff       	call   801161 <fd_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 0e                	js     801546 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
  80154c:	83 ec 1c             	sub    $0x1c,%esp
  80154f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801552:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	53                   	push   %ebx
  801557:	e8 05 fc ff ff       	call   801161 <fd_lookup>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 37                	js     80159a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156d:	ff 30                	pushl  (%eax)
  80156f:	e8 3d fc ff ff       	call   8011b1 <dev_lookup>
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	85 c0                	test   %eax,%eax
  801579:	78 1f                	js     80159a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801582:	74 1b                	je     80159f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801587:	8b 52 18             	mov    0x18(%edx),%edx
  80158a:	85 d2                	test   %edx,%edx
  80158c:	74 32                	je     8015c0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	ff 75 0c             	pushl  0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff d2                	call   *%edx
  801597:	83 c4 10             	add    $0x10,%esp
}
  80159a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80159f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a4:	8b 40 48             	mov    0x48(%eax),%eax
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	53                   	push   %ebx
  8015ab:	50                   	push   %eax
  8015ac:	68 0c 2b 80 00       	push   $0x802b0c
  8015b1:	e8 77 ec ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015be:	eb da                	jmp    80159a <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c5:	eb d3                	jmp    80159a <ftruncate+0x52>

008015c7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 1c             	sub    $0x1c,%esp
  8015ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 84 fb ff ff       	call   801161 <fd_lookup>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 4b                	js     80162f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ee:	ff 30                	pushl  (%eax)
  8015f0:	e8 bc fb ff ff       	call   8011b1 <dev_lookup>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 33                	js     80162f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801603:	74 2f                	je     801634 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801605:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801608:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80160f:	00 00 00 
	stat->st_isdir = 0;
  801612:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801619:	00 00 00 
	stat->st_dev = dev;
  80161c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	53                   	push   %ebx
  801626:	ff 75 f0             	pushl  -0x10(%ebp)
  801629:	ff 50 14             	call   *0x14(%eax)
  80162c:	83 c4 10             	add    $0x10,%esp
}
  80162f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801632:	c9                   	leave  
  801633:	c3                   	ret    
		return -E_NOT_SUPP;
  801634:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801639:	eb f4                	jmp    80162f <fstat+0x68>

0080163b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	6a 00                	push   $0x0
  801645:	ff 75 08             	pushl  0x8(%ebp)
  801648:	e8 22 02 00 00       	call   80186f <open>
  80164d:	89 c3                	mov    %eax,%ebx
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	78 1b                	js     801671 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	ff 75 0c             	pushl  0xc(%ebp)
  80165c:	50                   	push   %eax
  80165d:	e8 65 ff ff ff       	call   8015c7 <fstat>
  801662:	89 c6                	mov    %eax,%esi
	close(fd);
  801664:	89 1c 24             	mov    %ebx,(%esp)
  801667:	e8 27 fc ff ff       	call   801293 <close>
	return r;
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	89 f3                	mov    %esi,%ebx
}
  801671:	89 d8                	mov    %ebx,%eax
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
  80167f:	89 c6                	mov    %eax,%esi
  801681:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801683:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80168a:	74 27                	je     8016b3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80168c:	6a 07                	push   $0x7
  80168e:	68 00 50 80 00       	push   $0x805000
  801693:	56                   	push   %esi
  801694:	ff 35 00 40 80 00    	pushl  0x804000
  80169a:	e8 69 0c 00 00       	call   802308 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80169f:	83 c4 0c             	add    $0xc,%esp
  8016a2:	6a 00                	push   $0x0
  8016a4:	53                   	push   %ebx
  8016a5:	6a 00                	push   $0x0
  8016a7:	e8 f3 0b 00 00       	call   80229f <ipc_recv>
}
  8016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5e                   	pop    %esi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b3:	83 ec 0c             	sub    $0xc,%esp
  8016b6:	6a 01                	push   $0x1
  8016b8:	e8 a3 0c 00 00       	call   802360 <ipc_find_env>
  8016bd:	a3 00 40 80 00       	mov    %eax,0x804000
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	eb c5                	jmp    80168c <fsipc+0x12>

008016c7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ea:	e8 8b ff ff ff       	call   80167a <fsipc>
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <devfile_flush>:
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801702:	ba 00 00 00 00       	mov    $0x0,%edx
  801707:	b8 06 00 00 00       	mov    $0x6,%eax
  80170c:	e8 69 ff ff ff       	call   80167a <fsipc>
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <devfile_stat>:
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	53                   	push   %ebx
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8b 40 0c             	mov    0xc(%eax),%eax
  801723:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801728:	ba 00 00 00 00       	mov    $0x0,%edx
  80172d:	b8 05 00 00 00       	mov    $0x5,%eax
  801732:	e8 43 ff ff ff       	call   80167a <fsipc>
  801737:	85 c0                	test   %eax,%eax
  801739:	78 2c                	js     801767 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	68 00 50 80 00       	push   $0x805000
  801743:	53                   	push   %ebx
  801744:	e8 43 f2 ff ff       	call   80098c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801749:	a1 80 50 80 00       	mov    0x805080,%eax
  80174e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801754:	a1 84 50 80 00       	mov    0x805084,%eax
  801759:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <devfile_write>:
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	53                   	push   %ebx
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8b 40 0c             	mov    0xc(%eax),%eax
  80177c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801781:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801787:	53                   	push   %ebx
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	68 08 50 80 00       	push   $0x805008
  801790:	e8 e7 f3 ff ff       	call   800b7c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801795:	ba 00 00 00 00       	mov    $0x0,%edx
  80179a:	b8 04 00 00 00       	mov    $0x4,%eax
  80179f:	e8 d6 fe ff ff       	call   80167a <fsipc>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 0b                	js     8017b6 <devfile_write+0x4a>
	assert(r <= n);
  8017ab:	39 d8                	cmp    %ebx,%eax
  8017ad:	77 0c                	ja     8017bb <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b4:	7f 1e                	jg     8017d4 <devfile_write+0x68>
}
  8017b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
	assert(r <= n);
  8017bb:	68 7c 2b 80 00       	push   $0x802b7c
  8017c0:	68 83 2b 80 00       	push   $0x802b83
  8017c5:	68 98 00 00 00       	push   $0x98
  8017ca:	68 98 2b 80 00       	push   $0x802b98
  8017cf:	e8 6a 0a 00 00       	call   80223e <_panic>
	assert(r <= PGSIZE);
  8017d4:	68 a3 2b 80 00       	push   $0x802ba3
  8017d9:	68 83 2b 80 00       	push   $0x802b83
  8017de:	68 99 00 00 00       	push   $0x99
  8017e3:	68 98 2b 80 00       	push   $0x802b98
  8017e8:	e8 51 0a 00 00       	call   80223e <_panic>

008017ed <devfile_read>:
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801800:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801806:	ba 00 00 00 00       	mov    $0x0,%edx
  80180b:	b8 03 00 00 00       	mov    $0x3,%eax
  801810:	e8 65 fe ff ff       	call   80167a <fsipc>
  801815:	89 c3                	mov    %eax,%ebx
  801817:	85 c0                	test   %eax,%eax
  801819:	78 1f                	js     80183a <devfile_read+0x4d>
	assert(r <= n);
  80181b:	39 f0                	cmp    %esi,%eax
  80181d:	77 24                	ja     801843 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80181f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801824:	7f 33                	jg     801859 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	50                   	push   %eax
  80182a:	68 00 50 80 00       	push   $0x805000
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	e8 e3 f2 ff ff       	call   800b1a <memmove>
	return r;
  801837:	83 c4 10             	add    $0x10,%esp
}
  80183a:	89 d8                	mov    %ebx,%eax
  80183c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    
	assert(r <= n);
  801843:	68 7c 2b 80 00       	push   $0x802b7c
  801848:	68 83 2b 80 00       	push   $0x802b83
  80184d:	6a 7c                	push   $0x7c
  80184f:	68 98 2b 80 00       	push   $0x802b98
  801854:	e8 e5 09 00 00       	call   80223e <_panic>
	assert(r <= PGSIZE);
  801859:	68 a3 2b 80 00       	push   $0x802ba3
  80185e:	68 83 2b 80 00       	push   $0x802b83
  801863:	6a 7d                	push   $0x7d
  801865:	68 98 2b 80 00       	push   $0x802b98
  80186a:	e8 cf 09 00 00       	call   80223e <_panic>

0080186f <open>:
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 1c             	sub    $0x1c,%esp
  801877:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80187a:	56                   	push   %esi
  80187b:	e8 d3 f0 ff ff       	call   800953 <strlen>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801888:	7f 6c                	jg     8018f6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801890:	50                   	push   %eax
  801891:	e8 79 f8 ff ff       	call   80110f <fd_alloc>
  801896:	89 c3                	mov    %eax,%ebx
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 3c                	js     8018db <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	56                   	push   %esi
  8018a3:	68 00 50 80 00       	push   $0x805000
  8018a8:	e8 df f0 ff ff       	call   80098c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bd:	e8 b8 fd ff ff       	call   80167a <fsipc>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 19                	js     8018e4 <open+0x75>
	return fd2num(fd);
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d1:	e8 12 f8 ff ff       	call   8010e8 <fd2num>
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	83 c4 10             	add    $0x10,%esp
}
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    
		fd_close(fd, 0);
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ec:	e8 1b f9 ff ff       	call   80120c <fd_close>
		return r;
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	eb e5                	jmp    8018db <open+0x6c>
		return -E_BAD_PATH;
  8018f6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018fb:	eb de                	jmp    8018db <open+0x6c>

008018fd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	b8 08 00 00 00       	mov    $0x8,%eax
  80190d:	e8 68 fd ff ff       	call   80167a <fsipc>
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80191a:	68 af 2b 80 00       	push   $0x802baf
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	e8 65 f0 ff ff       	call   80098c <strcpy>
	return 0;
}
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <devsock_close>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	53                   	push   %ebx
  801932:	83 ec 10             	sub    $0x10,%esp
  801935:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801938:	53                   	push   %ebx
  801939:	e8 5d 0a 00 00       	call   80239b <pageref>
  80193e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801946:	83 f8 01             	cmp    $0x1,%eax
  801949:	74 07                	je     801952 <devsock_close+0x24>
}
  80194b:	89 d0                	mov    %edx,%eax
  80194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff 73 0c             	pushl  0xc(%ebx)
  801958:	e8 b9 02 00 00       	call   801c16 <nsipc_close>
  80195d:	89 c2                	mov    %eax,%edx
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	eb e7                	jmp    80194b <devsock_close+0x1d>

00801964 <devsock_write>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 10             	pushl  0x10(%ebp)
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	ff 70 0c             	pushl  0xc(%eax)
  801978:	e8 76 03 00 00       	call   801cf3 <nsipc_send>
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <devsock_read>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801985:	6a 00                	push   $0x0
  801987:	ff 75 10             	pushl  0x10(%ebp)
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	ff 70 0c             	pushl  0xc(%eax)
  801993:	e8 ef 02 00 00       	call   801c87 <nsipc_recv>
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <fd2sockid>:
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019a0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	e8 b7 f7 ff ff       	call   801161 <fd_lookup>
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 10                	js     8019c1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019ba:	39 08                	cmp    %ecx,(%eax)
  8019bc:	75 05                	jne    8019c3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019be:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c8:	eb f7                	jmp    8019c1 <fd2sockid+0x27>

008019ca <alloc_sockfd>:
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	56                   	push   %esi
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 1c             	sub    $0x1c,%esp
  8019d2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	e8 32 f7 ff ff       	call   80110f <fd_alloc>
  8019dd:	89 c3                	mov    %eax,%ebx
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 43                	js     801a29 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	68 07 04 00 00       	push   $0x407
  8019ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f1:	6a 00                	push   $0x0
  8019f3:	e8 86 f3 ff ff       	call   800d7e <sys_page_alloc>
  8019f8:	89 c3                	mov    %eax,%ebx
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 28                	js     801a29 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a0a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a16:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	50                   	push   %eax
  801a1d:	e8 c6 f6 ff ff       	call   8010e8 <fd2num>
  801a22:	89 c3                	mov    %eax,%ebx
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb 0c                	jmp    801a35 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	56                   	push   %esi
  801a2d:	e8 e4 01 00 00       	call   801c16 <nsipc_close>
		return r;
  801a32:	83 c4 10             	add    $0x10,%esp
}
  801a35:	89 d8                	mov    %ebx,%eax
  801a37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <accept>:
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	e8 4e ff ff ff       	call   80199a <fd2sockid>
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 1b                	js     801a6b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	ff 75 10             	pushl  0x10(%ebp)
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	50                   	push   %eax
  801a5a:	e8 0e 01 00 00       	call   801b6d <nsipc_accept>
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 05                	js     801a6b <accept+0x2d>
	return alloc_sockfd(r);
  801a66:	e8 5f ff ff ff       	call   8019ca <alloc_sockfd>
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <bind>:
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	e8 1f ff ff ff       	call   80199a <fd2sockid>
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 12                	js     801a91 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	e8 31 01 00 00       	call   801bbf <nsipc_bind>
  801a8e:	83 c4 10             	add    $0x10,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <shutdown>:
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	e8 f9 fe ff ff       	call   80199a <fd2sockid>
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 0f                	js     801ab4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801aa5:	83 ec 08             	sub    $0x8,%esp
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	50                   	push   %eax
  801aac:	e8 43 01 00 00       	call   801bf4 <nsipc_shutdown>
  801ab1:	83 c4 10             	add    $0x10,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <connect>:
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	e8 d6 fe ff ff       	call   80199a <fd2sockid>
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	78 12                	js     801ada <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	ff 75 10             	pushl  0x10(%ebp)
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	50                   	push   %eax
  801ad2:	e8 59 01 00 00       	call   801c30 <nsipc_connect>
  801ad7:	83 c4 10             	add    $0x10,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <listen>:
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	e8 b0 fe ff ff       	call   80199a <fd2sockid>
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 0f                	js     801afd <listen+0x21>
	return nsipc_listen(r, backlog);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	50                   	push   %eax
  801af5:	e8 6b 01 00 00       	call   801c65 <nsipc_listen>
  801afa:	83 c4 10             	add    $0x10,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <socket>:

int
socket(int domain, int type, int protocol)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b05:	ff 75 10             	pushl  0x10(%ebp)
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	e8 3e 02 00 00       	call   801d51 <nsipc_socket>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 05                	js     801b1f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b1a:	e8 ab fe ff ff       	call   8019ca <alloc_sockfd>
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b2a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b31:	74 26                	je     801b59 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b33:	6a 07                	push   $0x7
  801b35:	68 00 60 80 00       	push   $0x806000
  801b3a:	53                   	push   %ebx
  801b3b:	ff 35 04 40 80 00    	pushl  0x804004
  801b41:	e8 c2 07 00 00       	call   802308 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b46:	83 c4 0c             	add    $0xc,%esp
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	e8 4b 07 00 00       	call   80229f <ipc_recv>
}
  801b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	6a 02                	push   $0x2
  801b5e:	e8 fd 07 00 00       	call   802360 <ipc_find_env>
  801b63:	a3 04 40 80 00       	mov    %eax,0x804004
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	eb c6                	jmp    801b33 <nsipc+0x12>

00801b6d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b7d:	8b 06                	mov    (%esi),%eax
  801b7f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b84:	b8 01 00 00 00       	mov    $0x1,%eax
  801b89:	e8 93 ff ff ff       	call   801b21 <nsipc>
  801b8e:	89 c3                	mov    %eax,%ebx
  801b90:	85 c0                	test   %eax,%eax
  801b92:	79 09                	jns    801b9d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	ff 35 10 60 80 00    	pushl  0x806010
  801ba6:	68 00 60 80 00       	push   $0x806000
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	e8 67 ef ff ff       	call   800b1a <memmove>
		*addrlen = ret->ret_addrlen;
  801bb3:	a1 10 60 80 00       	mov    0x806010,%eax
  801bb8:	89 06                	mov    %eax,(%esi)
  801bba:	83 c4 10             	add    $0x10,%esp
	return r;
  801bbd:	eb d5                	jmp    801b94 <nsipc_accept+0x27>

00801bbf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 08             	sub    $0x8,%esp
  801bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bd1:	53                   	push   %ebx
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	68 04 60 80 00       	push   $0x806004
  801bda:	e8 3b ef ff ff       	call   800b1a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bdf:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801be5:	b8 02 00 00 00       	mov    $0x2,%eax
  801bea:	e8 32 ff ff ff       	call   801b21 <nsipc>
}
  801bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c0f:	e8 0d ff ff ff       	call   801b21 <nsipc>
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <nsipc_close>:

int
nsipc_close(int s)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c24:	b8 04 00 00 00       	mov    $0x4,%eax
  801c29:	e8 f3 fe ff ff       	call   801b21 <nsipc>
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c42:	53                   	push   %ebx
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	68 04 60 80 00       	push   $0x806004
  801c4b:	e8 ca ee ff ff       	call   800b1a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c50:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c56:	b8 05 00 00 00       	mov    $0x5,%eax
  801c5b:	e8 c1 fe ff ff       	call   801b21 <nsipc>
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c76:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c7b:	b8 06 00 00 00       	mov    $0x6,%eax
  801c80:	e8 9c fe ff ff       	call   801b21 <nsipc>
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c97:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ca5:	b8 07 00 00 00       	mov    $0x7,%eax
  801caa:	e8 72 fe ff ff       	call   801b21 <nsipc>
  801caf:	89 c3                	mov    %eax,%ebx
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 1f                	js     801cd4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cb5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cba:	7f 21                	jg     801cdd <nsipc_recv+0x56>
  801cbc:	39 c6                	cmp    %eax,%esi
  801cbe:	7c 1d                	jl     801cdd <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	50                   	push   %eax
  801cc4:	68 00 60 80 00       	push   $0x806000
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	e8 49 ee ff ff       	call   800b1a <memmove>
  801cd1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cdd:	68 bb 2b 80 00       	push   $0x802bbb
  801ce2:	68 83 2b 80 00       	push   $0x802b83
  801ce7:	6a 62                	push   $0x62
  801ce9:	68 d0 2b 80 00       	push   $0x802bd0
  801cee:	e8 4b 05 00 00       	call   80223e <_panic>

00801cf3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d05:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d0b:	7f 2e                	jg     801d3b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	53                   	push   %ebx
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	68 0c 60 80 00       	push   $0x80600c
  801d19:	e8 fc ed ff ff       	call   800b1a <memmove>
	nsipcbuf.send.req_size = size;
  801d1e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d24:	8b 45 14             	mov    0x14(%ebp),%eax
  801d27:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d2c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d31:	e8 eb fd ff ff       	call   801b21 <nsipc>
}
  801d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    
	assert(size < 1600);
  801d3b:	68 dc 2b 80 00       	push   $0x802bdc
  801d40:	68 83 2b 80 00       	push   $0x802b83
  801d45:	6a 6d                	push   $0x6d
  801d47:	68 d0 2b 80 00       	push   $0x802bd0
  801d4c:	e8 ed 04 00 00       	call   80223e <_panic>

00801d51 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d62:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d67:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d6f:	b8 09 00 00 00       	mov    $0x9,%eax
  801d74:	e8 a8 fd ff ff       	call   801b21 <nsipc>
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	e8 6a f3 ff ff       	call   8010f8 <fd2data>
  801d8e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d90:	83 c4 08             	add    $0x8,%esp
  801d93:	68 e8 2b 80 00       	push   $0x802be8
  801d98:	53                   	push   %ebx
  801d99:	e8 ee eb ff ff       	call   80098c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d9e:	8b 46 04             	mov    0x4(%esi),%eax
  801da1:	2b 06                	sub    (%esi),%eax
  801da3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801da9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801db0:	00 00 00 
	stat->st_dev = &devpipe;
  801db3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dba:	30 80 00 
	return 0;
}
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	53                   	push   %ebx
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd3:	53                   	push   %ebx
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 28 f0 ff ff       	call   800e03 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ddb:	89 1c 24             	mov    %ebx,(%esp)
  801dde:	e8 15 f3 ff ff       	call   8010f8 <fd2data>
  801de3:	83 c4 08             	add    $0x8,%esp
  801de6:	50                   	push   %eax
  801de7:	6a 00                	push   $0x0
  801de9:	e8 15 f0 ff ff       	call   800e03 <sys_page_unmap>
}
  801dee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <_pipeisclosed>:
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	57                   	push   %edi
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	83 ec 1c             	sub    $0x1c,%esp
  801dfc:	89 c7                	mov    %eax,%edi
  801dfe:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e00:	a1 08 40 80 00       	mov    0x804008,%eax
  801e05:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	57                   	push   %edi
  801e0c:	e8 8a 05 00 00       	call   80239b <pageref>
  801e11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e14:	89 34 24             	mov    %esi,(%esp)
  801e17:	e8 7f 05 00 00       	call   80239b <pageref>
		nn = thisenv->env_runs;
  801e1c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e22:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	39 cb                	cmp    %ecx,%ebx
  801e2a:	74 1b                	je     801e47 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e2c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e2f:	75 cf                	jne    801e00 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e31:	8b 42 58             	mov    0x58(%edx),%eax
  801e34:	6a 01                	push   $0x1
  801e36:	50                   	push   %eax
  801e37:	53                   	push   %ebx
  801e38:	68 ef 2b 80 00       	push   $0x802bef
  801e3d:	e8 eb e3 ff ff       	call   80022d <cprintf>
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	eb b9                	jmp    801e00 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e47:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e4a:	0f 94 c0             	sete   %al
  801e4d:	0f b6 c0             	movzbl %al,%eax
}
  801e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    

00801e58 <devpipe_write>:
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	57                   	push   %edi
  801e5c:	56                   	push   %esi
  801e5d:	53                   	push   %ebx
  801e5e:	83 ec 28             	sub    $0x28,%esp
  801e61:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e64:	56                   	push   %esi
  801e65:	e8 8e f2 ff ff       	call   8010f8 <fd2data>
  801e6a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e74:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e77:	74 4f                	je     801ec8 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e79:	8b 43 04             	mov    0x4(%ebx),%eax
  801e7c:	8b 0b                	mov    (%ebx),%ecx
  801e7e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e81:	39 d0                	cmp    %edx,%eax
  801e83:	72 14                	jb     801e99 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e85:	89 da                	mov    %ebx,%edx
  801e87:	89 f0                	mov    %esi,%eax
  801e89:	e8 65 ff ff ff       	call   801df3 <_pipeisclosed>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	75 3b                	jne    801ecd <devpipe_write+0x75>
			sys_yield();
  801e92:	e8 c8 ee ff ff       	call   800d5f <sys_yield>
  801e97:	eb e0                	jmp    801e79 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ea0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ea3:	89 c2                	mov    %eax,%edx
  801ea5:	c1 fa 1f             	sar    $0x1f,%edx
  801ea8:	89 d1                	mov    %edx,%ecx
  801eaa:	c1 e9 1b             	shr    $0x1b,%ecx
  801ead:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eb0:	83 e2 1f             	and    $0x1f,%edx
  801eb3:	29 ca                	sub    %ecx,%edx
  801eb5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801eb9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ebd:	83 c0 01             	add    $0x1,%eax
  801ec0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ec3:	83 c7 01             	add    $0x1,%edi
  801ec6:	eb ac                	jmp    801e74 <devpipe_write+0x1c>
	return i;
  801ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecb:	eb 05                	jmp    801ed2 <devpipe_write+0x7a>
				return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <devpipe_read>:
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 18             	sub    $0x18,%esp
  801ee3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ee6:	57                   	push   %edi
  801ee7:	e8 0c f2 ff ff       	call   8010f8 <fd2data>
  801eec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	be 00 00 00 00       	mov    $0x0,%esi
  801ef6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ef9:	75 14                	jne    801f0f <devpipe_read+0x35>
	return i;
  801efb:	8b 45 10             	mov    0x10(%ebp),%eax
  801efe:	eb 02                	jmp    801f02 <devpipe_read+0x28>
				return i;
  801f00:	89 f0                	mov    %esi,%eax
}
  801f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
			sys_yield();
  801f0a:	e8 50 ee ff ff       	call   800d5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f0f:	8b 03                	mov    (%ebx),%eax
  801f11:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f14:	75 18                	jne    801f2e <devpipe_read+0x54>
			if (i > 0)
  801f16:	85 f6                	test   %esi,%esi
  801f18:	75 e6                	jne    801f00 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f1a:	89 da                	mov    %ebx,%edx
  801f1c:	89 f8                	mov    %edi,%eax
  801f1e:	e8 d0 fe ff ff       	call   801df3 <_pipeisclosed>
  801f23:	85 c0                	test   %eax,%eax
  801f25:	74 e3                	je     801f0a <devpipe_read+0x30>
				return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	eb d4                	jmp    801f02 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f2e:	99                   	cltd   
  801f2f:	c1 ea 1b             	shr    $0x1b,%edx
  801f32:	01 d0                	add    %edx,%eax
  801f34:	83 e0 1f             	and    $0x1f,%eax
  801f37:	29 d0                	sub    %edx,%eax
  801f39:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f41:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f44:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f47:	83 c6 01             	add    $0x1,%esi
  801f4a:	eb aa                	jmp    801ef6 <devpipe_read+0x1c>

00801f4c <pipe>:
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	56                   	push   %esi
  801f50:	53                   	push   %ebx
  801f51:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f57:	50                   	push   %eax
  801f58:	e8 b2 f1 ff ff       	call   80110f <fd_alloc>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	0f 88 23 01 00 00    	js     80208d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 07 04 00 00       	push   $0x407
  801f72:	ff 75 f4             	pushl  -0xc(%ebp)
  801f75:	6a 00                	push   $0x0
  801f77:	e8 02 ee ff ff       	call   800d7e <sys_page_alloc>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	0f 88 04 01 00 00    	js     80208d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f8f:	50                   	push   %eax
  801f90:	e8 7a f1 ff ff       	call   80110f <fd_alloc>
  801f95:	89 c3                	mov    %eax,%ebx
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	0f 88 db 00 00 00    	js     80207d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	68 07 04 00 00       	push   $0x407
  801faa:	ff 75 f0             	pushl  -0x10(%ebp)
  801fad:	6a 00                	push   $0x0
  801faf:	e8 ca ed ff ff       	call   800d7e <sys_page_alloc>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	0f 88 bc 00 00 00    	js     80207d <pipe+0x131>
	va = fd2data(fd0);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc7:	e8 2c f1 ff ff       	call   8010f8 <fd2data>
  801fcc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fce:	83 c4 0c             	add    $0xc,%esp
  801fd1:	68 07 04 00 00       	push   $0x407
  801fd6:	50                   	push   %eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 a0 ed ff ff       	call   800d7e <sys_page_alloc>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 88 82 00 00 00    	js     80206d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff1:	e8 02 f1 ff ff       	call   8010f8 <fd2data>
  801ff6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ffd:	50                   	push   %eax
  801ffe:	6a 00                	push   $0x0
  802000:	56                   	push   %esi
  802001:	6a 00                	push   $0x0
  802003:	e8 b9 ed ff ff       	call   800dc1 <sys_page_map>
  802008:	89 c3                	mov    %eax,%ebx
  80200a:	83 c4 20             	add    $0x20,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 4e                	js     80205f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802011:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802019:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802025:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802028:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80202a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	ff 75 f4             	pushl  -0xc(%ebp)
  80203a:	e8 a9 f0 ff ff       	call   8010e8 <fd2num>
  80203f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802042:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802044:	83 c4 04             	add    $0x4,%esp
  802047:	ff 75 f0             	pushl  -0x10(%ebp)
  80204a:	e8 99 f0 ff ff       	call   8010e8 <fd2num>
  80204f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802052:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	bb 00 00 00 00       	mov    $0x0,%ebx
  80205d:	eb 2e                	jmp    80208d <pipe+0x141>
	sys_page_unmap(0, va);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	56                   	push   %esi
  802063:	6a 00                	push   $0x0
  802065:	e8 99 ed ff ff       	call   800e03 <sys_page_unmap>
  80206a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80206d:	83 ec 08             	sub    $0x8,%esp
  802070:	ff 75 f0             	pushl  -0x10(%ebp)
  802073:	6a 00                	push   $0x0
  802075:	e8 89 ed ff ff       	call   800e03 <sys_page_unmap>
  80207a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80207d:	83 ec 08             	sub    $0x8,%esp
  802080:	ff 75 f4             	pushl  -0xc(%ebp)
  802083:	6a 00                	push   $0x0
  802085:	e8 79 ed ff ff       	call   800e03 <sys_page_unmap>
  80208a:	83 c4 10             	add    $0x10,%esp
}
  80208d:	89 d8                	mov    %ebx,%eax
  80208f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802092:	5b                   	pop    %ebx
  802093:	5e                   	pop    %esi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <pipeisclosed>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	e8 b9 f0 ff ff       	call   801161 <fd_lookup>
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 18                	js     8020c7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b5:	e8 3e f0 ff ff       	call   8010f8 <fd2data>
	return _pipeisclosed(fd, p);
  8020ba:	89 c2                	mov    %eax,%edx
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	e8 2f fd ff ff       	call   801df3 <_pipeisclosed>
  8020c4:	83 c4 10             	add    $0x10,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ce:	c3                   	ret    

008020cf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020d5:	68 07 2c 80 00       	push   $0x802c07
  8020da:	ff 75 0c             	pushl  0xc(%ebp)
  8020dd:	e8 aa e8 ff ff       	call   80098c <strcpy>
	return 0;
}
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <devcons_write>:
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	57                   	push   %edi
  8020ed:	56                   	push   %esi
  8020ee:	53                   	push   %ebx
  8020ef:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020f5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020fa:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802100:	3b 75 10             	cmp    0x10(%ebp),%esi
  802103:	73 31                	jae    802136 <devcons_write+0x4d>
		m = n - tot;
  802105:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802108:	29 f3                	sub    %esi,%ebx
  80210a:	83 fb 7f             	cmp    $0x7f,%ebx
  80210d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802112:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802115:	83 ec 04             	sub    $0x4,%esp
  802118:	53                   	push   %ebx
  802119:	89 f0                	mov    %esi,%eax
  80211b:	03 45 0c             	add    0xc(%ebp),%eax
  80211e:	50                   	push   %eax
  80211f:	57                   	push   %edi
  802120:	e8 f5 e9 ff ff       	call   800b1a <memmove>
		sys_cputs(buf, m);
  802125:	83 c4 08             	add    $0x8,%esp
  802128:	53                   	push   %ebx
  802129:	57                   	push   %edi
  80212a:	e8 93 eb ff ff       	call   800cc2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80212f:	01 de                	add    %ebx,%esi
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	eb ca                	jmp    802100 <devcons_write+0x17>
}
  802136:	89 f0                	mov    %esi,%eax
  802138:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5e                   	pop    %esi
  80213d:	5f                   	pop    %edi
  80213e:	5d                   	pop    %ebp
  80213f:	c3                   	ret    

00802140 <devcons_read>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 08             	sub    $0x8,%esp
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80214b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80214f:	74 21                	je     802172 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802151:	e8 8a eb ff ff       	call   800ce0 <sys_cgetc>
  802156:	85 c0                	test   %eax,%eax
  802158:	75 07                	jne    802161 <devcons_read+0x21>
		sys_yield();
  80215a:	e8 00 ec ff ff       	call   800d5f <sys_yield>
  80215f:	eb f0                	jmp    802151 <devcons_read+0x11>
	if (c < 0)
  802161:	78 0f                	js     802172 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802163:	83 f8 04             	cmp    $0x4,%eax
  802166:	74 0c                	je     802174 <devcons_read+0x34>
	*(char*)vbuf = c;
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	88 02                	mov    %al,(%edx)
	return 1;
  80216d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    
		return 0;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	eb f7                	jmp    802172 <devcons_read+0x32>

0080217b <cputchar>:
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802187:	6a 01                	push   $0x1
  802189:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80218c:	50                   	push   %eax
  80218d:	e8 30 eb ff ff       	call   800cc2 <sys_cputs>
}
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <getchar>:
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80219d:	6a 01                	push   $0x1
  80219f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021a2:	50                   	push   %eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	e8 27 f2 ff ff       	call   8013d1 <read>
	if (r < 0)
  8021aa:	83 c4 10             	add    $0x10,%esp
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	78 06                	js     8021b7 <getchar+0x20>
	if (r < 1)
  8021b1:	74 06                	je     8021b9 <getchar+0x22>
	return c;
  8021b3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    
		return -E_EOF;
  8021b9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021be:	eb f7                	jmp    8021b7 <getchar+0x20>

008021c0 <iscons>:
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	e8 8f ef ff ff       	call   801161 <fd_lookup>
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 11                	js     8021ea <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021e2:	39 10                	cmp    %edx,(%eax)
  8021e4:	0f 94 c0             	sete   %al
  8021e7:	0f b6 c0             	movzbl %al,%eax
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <opencons>:
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f5:	50                   	push   %eax
  8021f6:	e8 14 ef ff ff       	call   80110f <fd_alloc>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	85 c0                	test   %eax,%eax
  802200:	78 3a                	js     80223c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	68 07 04 00 00       	push   $0x407
  80220a:	ff 75 f4             	pushl  -0xc(%ebp)
  80220d:	6a 00                	push   $0x0
  80220f:	e8 6a eb ff ff       	call   800d7e <sys_page_alloc>
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	78 21                	js     80223c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802224:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802230:	83 ec 0c             	sub    $0xc,%esp
  802233:	50                   	push   %eax
  802234:	e8 af ee ff ff       	call   8010e8 <fd2num>
  802239:	83 c4 10             	add    $0x10,%esp
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	56                   	push   %esi
  802242:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802243:	a1 08 40 80 00       	mov    0x804008,%eax
  802248:	8b 40 48             	mov    0x48(%eax),%eax
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 38 2c 80 00       	push   $0x802c38
  802253:	50                   	push   %eax
  802254:	68 b0 26 80 00       	push   $0x8026b0
  802259:	e8 cf df ff ff       	call   80022d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80225e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802261:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802267:	e8 d4 ea ff ff       	call   800d40 <sys_getenvid>
  80226c:	83 c4 04             	add    $0x4,%esp
  80226f:	ff 75 0c             	pushl  0xc(%ebp)
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	56                   	push   %esi
  802276:	50                   	push   %eax
  802277:	68 14 2c 80 00       	push   $0x802c14
  80227c:	e8 ac df ff ff       	call   80022d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802281:	83 c4 18             	add    $0x18,%esp
  802284:	53                   	push   %ebx
  802285:	ff 75 10             	pushl  0x10(%ebp)
  802288:	e8 4f df ff ff       	call   8001dc <vcprintf>
	cprintf("\n");
  80228d:	c7 04 24 74 26 80 00 	movl   $0x802674,(%esp)
  802294:	e8 94 df ff ff       	call   80022d <cprintf>
  802299:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80229c:	cc                   	int3   
  80229d:	eb fd                	jmp    80229c <_panic+0x5e>

0080229f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8022ad:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022af:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022b4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	50                   	push   %eax
  8022bb:	e8 6e ec ff ff       	call   800f2e <sys_ipc_recv>
	if(ret < 0){
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	78 2b                	js     8022f2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022c7:	85 f6                	test   %esi,%esi
  8022c9:	74 0a                	je     8022d5 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d0:	8b 40 74             	mov    0x74(%eax),%eax
  8022d3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022d5:	85 db                	test   %ebx,%ebx
  8022d7:	74 0a                	je     8022e3 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8022d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022de:	8b 40 78             	mov    0x78(%eax),%eax
  8022e1:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8022e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    
		if(from_env_store)
  8022f2:	85 f6                	test   %esi,%esi
  8022f4:	74 06                	je     8022fc <ipc_recv+0x5d>
			*from_env_store = 0;
  8022f6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022fc:	85 db                	test   %ebx,%ebx
  8022fe:	74 eb                	je     8022eb <ipc_recv+0x4c>
			*perm_store = 0;
  802300:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802306:	eb e3                	jmp    8022eb <ipc_recv+0x4c>

00802308 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	57                   	push   %edi
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	8b 7d 08             	mov    0x8(%ebp),%edi
  802314:	8b 75 0c             	mov    0xc(%ebp),%esi
  802317:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80231a:	85 db                	test   %ebx,%ebx
  80231c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802321:	0f 44 d8             	cmove  %eax,%ebx
  802324:	eb 05                	jmp    80232b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802326:	e8 34 ea ff ff       	call   800d5f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80232b:	ff 75 14             	pushl  0x14(%ebp)
  80232e:	53                   	push   %ebx
  80232f:	56                   	push   %esi
  802330:	57                   	push   %edi
  802331:	e8 d5 eb ff ff       	call   800f0b <sys_ipc_try_send>
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 1b                	je     802358 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80233d:	79 e7                	jns    802326 <ipc_send+0x1e>
  80233f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802342:	74 e2                	je     802326 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 3f 2c 80 00       	push   $0x802c3f
  80234c:	6a 4a                	push   $0x4a
  80234e:	68 54 2c 80 00       	push   $0x802c54
  802353:	e8 e6 fe ff ff       	call   80223e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5e                   	pop    %esi
  80235d:	5f                   	pop    %edi
  80235e:	5d                   	pop    %ebp
  80235f:	c3                   	ret    

00802360 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80236b:	89 c2                	mov    %eax,%edx
  80236d:	c1 e2 07             	shl    $0x7,%edx
  802370:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802376:	8b 52 50             	mov    0x50(%edx),%edx
  802379:	39 ca                	cmp    %ecx,%edx
  80237b:	74 11                	je     80238e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80237d:	83 c0 01             	add    $0x1,%eax
  802380:	3d 00 04 00 00       	cmp    $0x400,%eax
  802385:	75 e4                	jne    80236b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	eb 0b                	jmp    802399 <ipc_find_env+0x39>
			return envs[i].env_id;
  80238e:	c1 e0 07             	shl    $0x7,%eax
  802391:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802396:	8b 40 48             	mov    0x48(%eax),%eax
}
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a1:	89 d0                	mov    %edx,%eax
  8023a3:	c1 e8 16             	shr    $0x16,%eax
  8023a6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023ad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023b2:	f6 c1 01             	test   $0x1,%cl
  8023b5:	74 1d                	je     8023d4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023b7:	c1 ea 0c             	shr    $0xc,%edx
  8023ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023c1:	f6 c2 01             	test   $0x1,%dl
  8023c4:	74 0e                	je     8023d4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023c6:	c1 ea 0c             	shr    $0xc,%edx
  8023c9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023d0:	ef 
  8023d1:	0f b7 c0             	movzwl %ax,%eax
}
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	66 90                	xchg   %ax,%ax
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__udivdi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023f7:	85 d2                	test   %edx,%edx
  8023f9:	75 4d                	jne    802448 <__udivdi3+0x68>
  8023fb:	39 f3                	cmp    %esi,%ebx
  8023fd:	76 19                	jbe    802418 <__udivdi3+0x38>
  8023ff:	31 ff                	xor    %edi,%edi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f2                	mov    %esi,%edx
  802405:	f7 f3                	div    %ebx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 d9                	mov    %ebx,%ecx
  80241a:	85 db                	test   %ebx,%ebx
  80241c:	75 0b                	jne    802429 <__udivdi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f3                	div    %ebx
  802427:	89 c1                	mov    %eax,%ecx
  802429:	31 d2                	xor    %edx,%edx
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	f7 f1                	div    %ecx
  80242f:	89 c6                	mov    %eax,%esi
  802431:	89 e8                	mov    %ebp,%eax
  802433:	89 f7                	mov    %esi,%edi
  802435:	f7 f1                	div    %ecx
  802437:	89 fa                	mov    %edi,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	39 f2                	cmp    %esi,%edx
  80244a:	77 1c                	ja     802468 <__udivdi3+0x88>
  80244c:	0f bd fa             	bsr    %edx,%edi
  80244f:	83 f7 1f             	xor    $0x1f,%edi
  802452:	75 2c                	jne    802480 <__udivdi3+0xa0>
  802454:	39 f2                	cmp    %esi,%edx
  802456:	72 06                	jb     80245e <__udivdi3+0x7e>
  802458:	31 c0                	xor    %eax,%eax
  80245a:	39 eb                	cmp    %ebp,%ebx
  80245c:	77 a9                	ja     802407 <__udivdi3+0x27>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	eb a2                	jmp    802407 <__udivdi3+0x27>
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	31 ff                	xor    %edi,%edi
  80246a:	31 c0                	xor    %eax,%eax
  80246c:	89 fa                	mov    %edi,%edx
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	89 f9                	mov    %edi,%ecx
  802482:	b8 20 00 00 00       	mov    $0x20,%eax
  802487:	29 f8                	sub    %edi,%eax
  802489:	d3 e2                	shl    %cl,%edx
  80248b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80248f:	89 c1                	mov    %eax,%ecx
  802491:	89 da                	mov    %ebx,%edx
  802493:	d3 ea                	shr    %cl,%edx
  802495:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802499:	09 d1                	or     %edx,%ecx
  80249b:	89 f2                	mov    %esi,%edx
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 f9                	mov    %edi,%ecx
  8024a3:	d3 e3                	shl    %cl,%ebx
  8024a5:	89 c1                	mov    %eax,%ecx
  8024a7:	d3 ea                	shr    %cl,%edx
  8024a9:	89 f9                	mov    %edi,%ecx
  8024ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024af:	89 eb                	mov    %ebp,%ebx
  8024b1:	d3 e6                	shl    %cl,%esi
  8024b3:	89 c1                	mov    %eax,%ecx
  8024b5:	d3 eb                	shr    %cl,%ebx
  8024b7:	09 de                	or     %ebx,%esi
  8024b9:	89 f0                	mov    %esi,%eax
  8024bb:	f7 74 24 08          	divl   0x8(%esp)
  8024bf:	89 d6                	mov    %edx,%esi
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	f7 64 24 0c          	mull   0xc(%esp)
  8024c7:	39 d6                	cmp    %edx,%esi
  8024c9:	72 15                	jb     8024e0 <__udivdi3+0x100>
  8024cb:	89 f9                	mov    %edi,%ecx
  8024cd:	d3 e5                	shl    %cl,%ebp
  8024cf:	39 c5                	cmp    %eax,%ebp
  8024d1:	73 04                	jae    8024d7 <__udivdi3+0xf7>
  8024d3:	39 d6                	cmp    %edx,%esi
  8024d5:	74 09                	je     8024e0 <__udivdi3+0x100>
  8024d7:	89 d8                	mov    %ebx,%eax
  8024d9:	31 ff                	xor    %edi,%edi
  8024db:	e9 27 ff ff ff       	jmp    802407 <__udivdi3+0x27>
  8024e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024e3:	31 ff                	xor    %edi,%edi
  8024e5:	e9 1d ff ff ff       	jmp    802407 <__udivdi3+0x27>
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__umoddi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802507:	89 da                	mov    %ebx,%edx
  802509:	85 c0                	test   %eax,%eax
  80250b:	75 43                	jne    802550 <__umoddi3+0x60>
  80250d:	39 df                	cmp    %ebx,%edi
  80250f:	76 17                	jbe    802528 <__umoddi3+0x38>
  802511:	89 f0                	mov    %esi,%eax
  802513:	f7 f7                	div    %edi
  802515:	89 d0                	mov    %edx,%eax
  802517:	31 d2                	xor    %edx,%edx
  802519:	83 c4 1c             	add    $0x1c,%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5f                   	pop    %edi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	89 fd                	mov    %edi,%ebp
  80252a:	85 ff                	test   %edi,%edi
  80252c:	75 0b                	jne    802539 <__umoddi3+0x49>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f7                	div    %edi
  802537:	89 c5                	mov    %eax,%ebp
  802539:	89 d8                	mov    %ebx,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f5                	div    %ebp
  80253f:	89 f0                	mov    %esi,%eax
  802541:	f7 f5                	div    %ebp
  802543:	89 d0                	mov    %edx,%eax
  802545:	eb d0                	jmp    802517 <__umoddi3+0x27>
  802547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254e:	66 90                	xchg   %ax,%ax
  802550:	89 f1                	mov    %esi,%ecx
  802552:	39 d8                	cmp    %ebx,%eax
  802554:	76 0a                	jbe    802560 <__umoddi3+0x70>
  802556:	89 f0                	mov    %esi,%eax
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	0f bd e8             	bsr    %eax,%ebp
  802563:	83 f5 1f             	xor    $0x1f,%ebp
  802566:	75 20                	jne    802588 <__umoddi3+0x98>
  802568:	39 d8                	cmp    %ebx,%eax
  80256a:	0f 82 b0 00 00 00    	jb     802620 <__umoddi3+0x130>
  802570:	39 f7                	cmp    %esi,%edi
  802572:	0f 86 a8 00 00 00    	jbe    802620 <__umoddi3+0x130>
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	83 c4 1c             	add    $0x1c,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5f                   	pop    %edi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    
  802582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802588:	89 e9                	mov    %ebp,%ecx
  80258a:	ba 20 00 00 00       	mov    $0x20,%edx
  80258f:	29 ea                	sub    %ebp,%edx
  802591:	d3 e0                	shl    %cl,%eax
  802593:	89 44 24 08          	mov    %eax,0x8(%esp)
  802597:	89 d1                	mov    %edx,%ecx
  802599:	89 f8                	mov    %edi,%eax
  80259b:	d3 e8                	shr    %cl,%eax
  80259d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025a9:	09 c1                	or     %eax,%ecx
  8025ab:	89 d8                	mov    %ebx,%eax
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 e9                	mov    %ebp,%ecx
  8025b3:	d3 e7                	shl    %cl,%edi
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025bf:	d3 e3                	shl    %cl,%ebx
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	89 d1                	mov    %edx,%ecx
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	d3 e8                	shr    %cl,%eax
  8025c9:	89 e9                	mov    %ebp,%ecx
  8025cb:	89 fa                	mov    %edi,%edx
  8025cd:	d3 e6                	shl    %cl,%esi
  8025cf:	09 d8                	or     %ebx,%eax
  8025d1:	f7 74 24 08          	divl   0x8(%esp)
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	89 f3                	mov    %esi,%ebx
  8025d9:	f7 64 24 0c          	mull   0xc(%esp)
  8025dd:	89 c6                	mov    %eax,%esi
  8025df:	89 d7                	mov    %edx,%edi
  8025e1:	39 d1                	cmp    %edx,%ecx
  8025e3:	72 06                	jb     8025eb <__umoddi3+0xfb>
  8025e5:	75 10                	jne    8025f7 <__umoddi3+0x107>
  8025e7:	39 c3                	cmp    %eax,%ebx
  8025e9:	73 0c                	jae    8025f7 <__umoddi3+0x107>
  8025eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025f3:	89 d7                	mov    %edx,%edi
  8025f5:	89 c6                	mov    %eax,%esi
  8025f7:	89 ca                	mov    %ecx,%edx
  8025f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025fe:	29 f3                	sub    %esi,%ebx
  802600:	19 fa                	sbb    %edi,%edx
  802602:	89 d0                	mov    %edx,%eax
  802604:	d3 e0                	shl    %cl,%eax
  802606:	89 e9                	mov    %ebp,%ecx
  802608:	d3 eb                	shr    %cl,%ebx
  80260a:	d3 ea                	shr    %cl,%edx
  80260c:	09 d8                	or     %ebx,%eax
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	89 da                	mov    %ebx,%edx
  802622:	29 fe                	sub    %edi,%esi
  802624:	19 c2                	sbb    %eax,%edx
  802626:	89 f1                	mov    %esi,%ecx
  802628:	89 c8                	mov    %ecx,%eax
  80262a:	e9 4b ff ff ff       	jmp    80257a <__umoddi3+0x8a>
