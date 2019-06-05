
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 a0 25 80 00       	push   $0x8025a0
  800048:	e8 ef 01 00 00       	call   80023c <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 14 0d 00 00       	call   800d6e <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 c0 25 80 00       	push   $0x8025c0
  80006c:	e8 cb 01 00 00       	call   80023c <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ec 25 80 00       	push   $0x8025ec
  80008d:	e8 aa 01 00 00       	call   80023c <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
  8000a0:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000aa:	00 00 00 
	envid_t find = sys_getenvid();
  8000ad:	e8 9d 0c 00 00       	call   800d4f <sys_getenvid>
  8000b2:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000b8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c7:	eb 0b                	jmp    8000d4 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000c9:	83 c2 01             	add    $0x1,%edx
  8000cc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d2:	74 21                	je     8000f5 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	c1 e1 07             	shl    $0x7,%ecx
  8000d9:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000df:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e2:	39 c1                	cmp    %eax,%ecx
  8000e4:	75 e3                	jne    8000c9 <libmain+0x2f>
  8000e6:	89 d3                	mov    %edx,%ebx
  8000e8:	c1 e3 07             	shl    $0x7,%ebx
  8000eb:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f1:	89 fe                	mov    %edi,%esi
  8000f3:	eb d4                	jmp    8000c9 <libmain+0x2f>
  8000f5:	89 f0                	mov    %esi,%eax
  8000f7:	84 c0                	test   %al,%al
  8000f9:	74 06                	je     800101 <libmain+0x67>
  8000fb:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800105:	7e 0a                	jle    800111 <libmain+0x77>
		binaryname = argv[0];
  800107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010a:	8b 00                	mov    (%eax),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800111:	a1 08 40 80 00       	mov    0x804008,%eax
  800116:	8b 40 48             	mov    0x48(%eax),%eax
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	50                   	push   %eax
  80011d:	68 0b 26 80 00       	push   $0x80260b
  800122:	e8 15 01 00 00       	call   80023c <cprintf>
	cprintf("before umain\n");
  800127:	c7 04 24 29 26 80 00 	movl   $0x802629,(%esp)
  80012e:	e8 09 01 00 00       	call   80023c <cprintf>
	// call user main routine
	umain(argc, argv);
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	ff 75 0c             	pushl  0xc(%ebp)
  800139:	ff 75 08             	pushl  0x8(%ebp)
  80013c:	e8 f2 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800141:	c7 04 24 37 26 80 00 	movl   $0x802637,(%esp)
  800148:	e8 ef 00 00 00       	call   80023c <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80014d:	a1 08 40 80 00       	mov    0x804008,%eax
  800152:	8b 40 48             	mov    0x48(%eax),%eax
  800155:	83 c4 08             	add    $0x8,%esp
  800158:	50                   	push   %eax
  800159:	68 44 26 80 00       	push   $0x802644
  80015e:	e8 d9 00 00 00       	call   80023c <cprintf>
	// exit gracefully
	exit();
  800163:	e8 0b 00 00 00       	call   800173 <exit>
}
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5f                   	pop    %edi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800179:	a1 08 40 80 00       	mov    0x804008,%eax
  80017e:	8b 40 48             	mov    0x48(%eax),%eax
  800181:	68 70 26 80 00       	push   $0x802670
  800186:	50                   	push   %eax
  800187:	68 63 26 80 00       	push   $0x802663
  80018c:	e8 ab 00 00 00       	call   80023c <cprintf>
	close_all();
  800191:	e8 a4 10 00 00       	call   80123a <close_all>
	sys_env_destroy(0);
  800196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80019d:	e8 6c 0b 00 00       	call   800d0e <sys_env_destroy>
}
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b1:	8b 13                	mov    (%ebx),%edx
  8001b3:	8d 42 01             	lea    0x1(%edx),%eax
  8001b6:	89 03                	mov    %eax,(%ebx)
  8001b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c4:	74 09                	je     8001cf <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001cf:	83 ec 08             	sub    $0x8,%esp
  8001d2:	68 ff 00 00 00       	push   $0xff
  8001d7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001da:	50                   	push   %eax
  8001db:	e8 f1 0a 00 00       	call   800cd1 <sys_cputs>
		b->idx = 0;
  8001e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	eb db                	jmp    8001c6 <putch+0x1f>

008001eb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fb:	00 00 00 
	b.cnt = 0;
  8001fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800205:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800208:	ff 75 0c             	pushl  0xc(%ebp)
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800214:	50                   	push   %eax
  800215:	68 a7 01 80 00       	push   $0x8001a7
  80021a:	e8 4a 01 00 00       	call   800369 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021f:	83 c4 08             	add    $0x8,%esp
  800222:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800228:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022e:	50                   	push   %eax
  80022f:	e8 9d 0a 00 00       	call   800cd1 <sys_cputs>

	return b.cnt;
}
  800234:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800242:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800245:	50                   	push   %eax
  800246:	ff 75 08             	pushl  0x8(%ebp)
  800249:	e8 9d ff ff ff       	call   8001eb <vcprintf>
	va_end(ap);

	return cnt;
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 1c             	sub    $0x1c,%esp
  800259:	89 c6                	mov    %eax,%esi
  80025b:	89 d7                	mov    %edx,%edi
  80025d:	8b 45 08             	mov    0x8(%ebp),%eax
  800260:	8b 55 0c             	mov    0xc(%ebp),%edx
  800263:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800266:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800269:	8b 45 10             	mov    0x10(%ebp),%eax
  80026c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80026f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800273:	74 2c                	je     8002a1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800275:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800278:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80027f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800282:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800285:	39 c2                	cmp    %eax,%edx
  800287:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028a:	73 43                	jae    8002cf <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	85 db                	test   %ebx,%ebx
  800291:	7e 6c                	jle    8002ff <printnum+0xaf>
				putch(padc, putdat);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	57                   	push   %edi
  800297:	ff 75 18             	pushl  0x18(%ebp)
  80029a:	ff d6                	call   *%esi
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	eb eb                	jmp    80028c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	6a 20                	push   $0x20
  8002a6:	6a 00                	push   $0x0
  8002a8:	50                   	push   %eax
  8002a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8002af:	89 fa                	mov    %edi,%edx
  8002b1:	89 f0                	mov    %esi,%eax
  8002b3:	e8 98 ff ff ff       	call   800250 <printnum>
		while (--width > 0)
  8002b8:	83 c4 20             	add    $0x20,%esp
  8002bb:	83 eb 01             	sub    $0x1,%ebx
  8002be:	85 db                	test   %ebx,%ebx
  8002c0:	7e 65                	jle    800327 <printnum+0xd7>
			putch(padc, putdat);
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	57                   	push   %edi
  8002c6:	6a 20                	push   $0x20
  8002c8:	ff d6                	call   *%esi
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	eb ec                	jmp    8002bb <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	ff 75 18             	pushl  0x18(%ebp)
  8002d5:	83 eb 01             	sub    $0x1,%ebx
  8002d8:	53                   	push   %ebx
  8002d9:	50                   	push   %eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e9:	e8 62 20 00 00       	call   802350 <__udivdi3>
  8002ee:	83 c4 18             	add    $0x18,%esp
  8002f1:	52                   	push   %edx
  8002f2:	50                   	push   %eax
  8002f3:	89 fa                	mov    %edi,%edx
  8002f5:	89 f0                	mov    %esi,%eax
  8002f7:	e8 54 ff ff ff       	call   800250 <printnum>
  8002fc:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	57                   	push   %edi
  800303:	83 ec 04             	sub    $0x4,%esp
  800306:	ff 75 dc             	pushl  -0x24(%ebp)
  800309:	ff 75 d8             	pushl  -0x28(%ebp)
  80030c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030f:	ff 75 e0             	pushl  -0x20(%ebp)
  800312:	e8 49 21 00 00       	call   802460 <__umoddi3>
  800317:	83 c4 14             	add    $0x14,%esp
  80031a:	0f be 80 75 26 80 00 	movsbl 0x802675(%eax),%eax
  800321:	50                   	push   %eax
  800322:	ff d6                	call   *%esi
  800324:	83 c4 10             	add    $0x10,%esp
	}
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    

0080032f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800335:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	3b 50 04             	cmp    0x4(%eax),%edx
  80033e:	73 0a                	jae    80034a <sprintputch+0x1b>
		*b->buf++ = ch;
  800340:	8d 4a 01             	lea    0x1(%edx),%ecx
  800343:	89 08                	mov    %ecx,(%eax)
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	88 02                	mov    %al,(%edx)
}
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <printfmt>:
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800352:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800355:	50                   	push   %eax
  800356:	ff 75 10             	pushl  0x10(%ebp)
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 05 00 00 00       	call   800369 <vprintfmt>
}
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <vprintfmt>:
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	57                   	push   %edi
  80036d:	56                   	push   %esi
  80036e:	53                   	push   %ebx
  80036f:	83 ec 3c             	sub    $0x3c,%esp
  800372:	8b 75 08             	mov    0x8(%ebp),%esi
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800378:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037b:	e9 32 04 00 00       	jmp    8007b2 <vprintfmt+0x449>
		padc = ' ';
  800380:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800384:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80038b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800392:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800399:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8d 47 01             	lea    0x1(%edi),%eax
  8003af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b2:	0f b6 17             	movzbl (%edi),%edx
  8003b5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b8:	3c 55                	cmp    $0x55,%al
  8003ba:	0f 87 12 05 00 00    	ja     8008d2 <vprintfmt+0x569>
  8003c0:	0f b6 c0             	movzbl %al,%eax
  8003c3:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003cd:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d1:	eb d9                	jmp    8003ac <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003da:	eb d0                	jmp    8003ac <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	0f b6 d2             	movzbl %dl,%edx
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ea:	eb 03                	jmp    8003ef <vprintfmt+0x86>
  8003ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ef:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003fc:	83 fe 09             	cmp    $0x9,%esi
  8003ff:	76 eb                	jbe    8003ec <vprintfmt+0x83>
  800401:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800404:	8b 75 08             	mov    0x8(%ebp),%esi
  800407:	eb 14                	jmp    80041d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	8d 40 04             	lea    0x4(%eax),%eax
  800417:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80041d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800421:	79 89                	jns    8003ac <vprintfmt+0x43>
				width = precision, precision = -1;
  800423:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800429:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800430:	e9 77 ff ff ff       	jmp    8003ac <vprintfmt+0x43>
  800435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800438:	85 c0                	test   %eax,%eax
  80043a:	0f 48 c1             	cmovs  %ecx,%eax
  80043d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800443:	e9 64 ff ff ff       	jmp    8003ac <vprintfmt+0x43>
  800448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800452:	e9 55 ff ff ff       	jmp    8003ac <vprintfmt+0x43>
			lflag++;
  800457:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045e:	e9 49 ff ff ff       	jmp    8003ac <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 78 04             	lea    0x4(%eax),%edi
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	53                   	push   %ebx
  80046d:	ff 30                	pushl  (%eax)
  80046f:	ff d6                	call   *%esi
			break;
  800471:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800477:	e9 33 03 00 00       	jmp    8007af <vprintfmt+0x446>
			err = va_arg(ap, int);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	8b 00                	mov    (%eax),%eax
  800484:	99                   	cltd   
  800485:	31 d0                	xor    %edx,%eax
  800487:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800489:	83 f8 11             	cmp    $0x11,%eax
  80048c:	7f 23                	jg     8004b1 <vprintfmt+0x148>
  80048e:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800495:	85 d2                	test   %edx,%edx
  800497:	74 18                	je     8004b1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800499:	52                   	push   %edx
  80049a:	68 dd 2a 80 00       	push   $0x802add
  80049f:	53                   	push   %ebx
  8004a0:	56                   	push   %esi
  8004a1:	e8 a6 fe ff ff       	call   80034c <printfmt>
  8004a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ac:	e9 fe 02 00 00       	jmp    8007af <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b1:	50                   	push   %eax
  8004b2:	68 8d 26 80 00       	push   $0x80268d
  8004b7:	53                   	push   %ebx
  8004b8:	56                   	push   %esi
  8004b9:	e8 8e fe ff ff       	call   80034c <printfmt>
  8004be:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c4:	e9 e6 02 00 00       	jmp    8007af <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	83 c0 04             	add    $0x4,%eax
  8004cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d7:	85 c9                	test   %ecx,%ecx
  8004d9:	b8 86 26 80 00       	mov    $0x802686,%eax
  8004de:	0f 45 c1             	cmovne %ecx,%eax
  8004e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	7e 06                	jle    8004f0 <vprintfmt+0x187>
  8004ea:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ee:	75 0d                	jne    8004fd <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f3:	89 c7                	mov    %eax,%edi
  8004f5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fb:	eb 53                	jmp    800550 <vprintfmt+0x1e7>
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 d8             	pushl  -0x28(%ebp)
  800503:	50                   	push   %eax
  800504:	e8 71 04 00 00       	call   80097a <strnlen>
  800509:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050c:	29 c1                	sub    %eax,%ecx
  80050e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800516:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	eb 0f                	jmp    80052e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	53                   	push   %ebx
  800523:	ff 75 e0             	pushl  -0x20(%ebp)
  800526:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800528:	83 ef 01             	sub    $0x1,%edi
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	85 ff                	test   %edi,%edi
  800530:	7f ed                	jg     80051f <vprintfmt+0x1b6>
  800532:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800535:	85 c9                	test   %ecx,%ecx
  800537:	b8 00 00 00 00       	mov    $0x0,%eax
  80053c:	0f 49 c1             	cmovns %ecx,%eax
  80053f:	29 c1                	sub    %eax,%ecx
  800541:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800544:	eb aa                	jmp    8004f0 <vprintfmt+0x187>
					putch(ch, putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	52                   	push   %edx
  80054b:	ff d6                	call   *%esi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 c7 01             	add    $0x1,%edi
  800558:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055c:	0f be d0             	movsbl %al,%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	74 4b                	je     8005ae <vprintfmt+0x245>
  800563:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800567:	78 06                	js     80056f <vprintfmt+0x206>
  800569:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056d:	78 1e                	js     80058d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80056f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800573:	74 d1                	je     800546 <vprintfmt+0x1dd>
  800575:	0f be c0             	movsbl %al,%eax
  800578:	83 e8 20             	sub    $0x20,%eax
  80057b:	83 f8 5e             	cmp    $0x5e,%eax
  80057e:	76 c6                	jbe    800546 <vprintfmt+0x1dd>
					putch('?', putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	6a 3f                	push   $0x3f
  800586:	ff d6                	call   *%esi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	eb c3                	jmp    800550 <vprintfmt+0x1e7>
  80058d:	89 cf                	mov    %ecx,%edi
  80058f:	eb 0e                	jmp    80059f <vprintfmt+0x236>
				putch(' ', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 20                	push   $0x20
  800597:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800599:	83 ef 01             	sub    $0x1,%edi
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	85 ff                	test   %edi,%edi
  8005a1:	7f ee                	jg     800591 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a9:	e9 01 02 00 00       	jmp    8007af <vprintfmt+0x446>
  8005ae:	89 cf                	mov    %ecx,%edi
  8005b0:	eb ed                	jmp    80059f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005b5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005bc:	e9 eb fd ff ff       	jmp    8003ac <vprintfmt+0x43>
	if (lflag >= 2)
  8005c1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c5:	7f 21                	jg     8005e8 <vprintfmt+0x27f>
	else if (lflag)
  8005c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cb:	74 68                	je     800635 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005da:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb 17                	jmp    8005ff <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 50 04             	mov    0x4(%eax),%edx
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8d 40 08             	lea    0x8(%eax),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800602:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80060b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80060f:	78 3f                	js     800650 <vprintfmt+0x2e7>
			base = 10;
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800616:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80061a:	0f 84 71 01 00 00    	je     800791 <vprintfmt+0x428>
				putch('+', putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	6a 2b                	push   $0x2b
  800626:	ff d6                	call   *%esi
  800628:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800630:	e9 5c 01 00 00       	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063d:	89 c1                	mov    %eax,%ecx
  80063f:	c1 f9 1f             	sar    $0x1f,%ecx
  800642:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb af                	jmp    8005ff <vprintfmt+0x296>
				putch('-', putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	6a 2d                	push   $0x2d
  800656:	ff d6                	call   *%esi
				num = -(long long) num;
  800658:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80065e:	f7 d8                	neg    %eax
  800660:	83 d2 00             	adc    $0x0,%edx
  800663:	f7 da                	neg    %edx
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800673:	e9 19 01 00 00       	jmp    800791 <vprintfmt+0x428>
	if (lflag >= 2)
  800678:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067c:	7f 29                	jg     8006a7 <vprintfmt+0x33e>
	else if (lflag)
  80067e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800682:	74 44                	je     8006c8 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a2:	e9 ea 00 00 00       	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c3:	e9 c9 00 00 00       	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e6:	e9 a6 00 00 00       	jmp    800791 <vprintfmt+0x428>
			putch('0', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 30                	push   $0x30
  8006f1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fa:	7f 26                	jg     800722 <vprintfmt+0x3b9>
	else if (lflag)
  8006fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800700:	74 3e                	je     800740 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071b:	b8 08 00 00 00       	mov    $0x8,%eax
  800720:	eb 6f                	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 50 04             	mov    0x4(%eax),%edx
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 40 08             	lea    0x8(%eax),%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800739:	b8 08 00 00 00       	mov    $0x8,%eax
  80073e:	eb 51                	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
  80074a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800759:	b8 08 00 00 00       	mov    $0x8,%eax
  80075e:	eb 31                	jmp    800791 <vprintfmt+0x428>
			putch('0', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	6a 30                	push   $0x30
  800766:	ff d6                	call   *%esi
			putch('x', putdat);
  800768:	83 c4 08             	add    $0x8,%esp
  80076b:	53                   	push   %ebx
  80076c:	6a 78                	push   $0x78
  80076e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800780:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800798:	52                   	push   %edx
  800799:	ff 75 e0             	pushl  -0x20(%ebp)
  80079c:	50                   	push   %eax
  80079d:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a3:	89 da                	mov    %ebx,%edx
  8007a5:	89 f0                	mov    %esi,%eax
  8007a7:	e8 a4 fa ff ff       	call   800250 <printnum>
			break;
  8007ac:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b2:	83 c7 01             	add    $0x1,%edi
  8007b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b9:	83 f8 25             	cmp    $0x25,%eax
  8007bc:	0f 84 be fb ff ff    	je     800380 <vprintfmt+0x17>
			if (ch == '\0')
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	0f 84 28 01 00 00    	je     8008f2 <vprintfmt+0x589>
			putch(ch, putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	50                   	push   %eax
  8007cf:	ff d6                	call   *%esi
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	eb dc                	jmp    8007b2 <vprintfmt+0x449>
	if (lflag >= 2)
  8007d6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007da:	7f 26                	jg     800802 <vprintfmt+0x499>
	else if (lflag)
  8007dc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e0:	74 41                	je     800823 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fb:	b8 10 00 00 00       	mov    $0x10,%eax
  800800:	eb 8f                	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 50 04             	mov    0x4(%eax),%edx
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8d 40 08             	lea    0x8(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800819:	b8 10 00 00 00       	mov    $0x10,%eax
  80081e:	e9 6e ff ff ff       	jmp    800791 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
  80082d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800830:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8d 40 04             	lea    0x4(%eax),%eax
  800839:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083c:	b8 10 00 00 00       	mov    $0x10,%eax
  800841:	e9 4b ff ff ff       	jmp    800791 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 c0 04             	add    $0x4,%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	85 c0                	test   %eax,%eax
  800856:	74 14                	je     80086c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800858:	8b 13                	mov    (%ebx),%edx
  80085a:	83 fa 7f             	cmp    $0x7f,%edx
  80085d:	7f 37                	jg     800896 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80085f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800861:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
  800867:	e9 43 ff ff ff       	jmp    8007af <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80086c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800871:	bf a9 27 80 00       	mov    $0x8027a9,%edi
							putch(ch, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	50                   	push   %eax
  80087b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80087d:	83 c7 01             	add    $0x1,%edi
  800880:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	85 c0                	test   %eax,%eax
  800889:	75 eb                	jne    800876 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80088b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088e:	89 45 14             	mov    %eax,0x14(%ebp)
  800891:	e9 19 ff ff ff       	jmp    8007af <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800896:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800898:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089d:	bf e1 27 80 00       	mov    $0x8027e1,%edi
							putch(ch, putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	53                   	push   %ebx
  8008a6:	50                   	push   %eax
  8008a7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a9:	83 c7 01             	add    $0x1,%edi
  8008ac:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	75 eb                	jne    8008a2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bd:	e9 ed fe ff ff       	jmp    8007af <vprintfmt+0x446>
			putch(ch, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	6a 25                	push   $0x25
  8008c8:	ff d6                	call   *%esi
			break;
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	e9 dd fe ff ff       	jmp    8007af <vprintfmt+0x446>
			putch('%', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	53                   	push   %ebx
  8008d6:	6a 25                	push   $0x25
  8008d8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	89 f8                	mov    %edi,%eax
  8008df:	eb 03                	jmp    8008e4 <vprintfmt+0x57b>
  8008e1:	83 e8 01             	sub    $0x1,%eax
  8008e4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e8:	75 f7                	jne    8008e1 <vprintfmt+0x578>
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ed:	e9 bd fe ff ff       	jmp    8007af <vprintfmt+0x446>
}
  8008f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5f                   	pop    %edi
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800906:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800909:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80090d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800917:	85 c0                	test   %eax,%eax
  800919:	74 26                	je     800941 <vsnprintf+0x47>
  80091b:	85 d2                	test   %edx,%edx
  80091d:	7e 22                	jle    800941 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80091f:	ff 75 14             	pushl  0x14(%ebp)
  800922:	ff 75 10             	pushl  0x10(%ebp)
  800925:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800928:	50                   	push   %eax
  800929:	68 2f 03 80 00       	push   $0x80032f
  80092e:	e8 36 fa ff ff       	call   800369 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800936:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093c:	83 c4 10             	add    $0x10,%esp
}
  80093f:	c9                   	leave  
  800940:	c3                   	ret    
		return -E_INVAL;
  800941:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800946:	eb f7                	jmp    80093f <vsnprintf+0x45>

00800948 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800951:	50                   	push   %eax
  800952:	ff 75 10             	pushl  0x10(%ebp)
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 9a ff ff ff       	call   8008fa <vsnprintf>
	va_end(ap);

	return rc;
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    

00800962 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
  80096d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800971:	74 05                	je     800978 <strlen+0x16>
		n++;
  800973:	83 c0 01             	add    $0x1,%eax
  800976:	eb f5                	jmp    80096d <strlen+0xb>
	return n;
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
  800988:	39 c2                	cmp    %eax,%edx
  80098a:	74 0d                	je     800999 <strnlen+0x1f>
  80098c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800990:	74 05                	je     800997 <strnlen+0x1d>
		n++;
  800992:	83 c2 01             	add    $0x1,%edx
  800995:	eb f1                	jmp    800988 <strnlen+0xe>
  800997:	89 d0                	mov    %edx,%eax
	return n;
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009aa:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b1:	83 c2 01             	add    $0x1,%edx
  8009b4:	84 c9                	test   %cl,%cl
  8009b6:	75 f2                	jne    8009aa <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	83 ec 10             	sub    $0x10,%esp
  8009c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c5:	53                   	push   %ebx
  8009c6:	e8 97 ff ff ff       	call   800962 <strlen>
  8009cb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	01 d8                	add    %ebx,%eax
  8009d3:	50                   	push   %eax
  8009d4:	e8 c2 ff ff ff       	call   80099b <strcpy>
	return dst;
}
  8009d9:	89 d8                	mov    %ebx,%eax
  8009db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	56                   	push   %esi
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009eb:	89 c6                	mov    %eax,%esi
  8009ed:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f0:	89 c2                	mov    %eax,%edx
  8009f2:	39 f2                	cmp    %esi,%edx
  8009f4:	74 11                	je     800a07 <strncpy+0x27>
		*dst++ = *src;
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	0f b6 19             	movzbl (%ecx),%ebx
  8009fc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ff:	80 fb 01             	cmp    $0x1,%bl
  800a02:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a05:	eb eb                	jmp    8009f2 <strncpy+0x12>
	}
	return ret;
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
  800a10:	8b 75 08             	mov    0x8(%ebp),%esi
  800a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a16:	8b 55 10             	mov    0x10(%ebp),%edx
  800a19:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1b:	85 d2                	test   %edx,%edx
  800a1d:	74 21                	je     800a40 <strlcpy+0x35>
  800a1f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a23:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <strlcpy+0x32>
  800a29:	0f b6 19             	movzbl (%ecx),%ebx
  800a2c:	84 db                	test   %bl,%bl
  800a2e:	74 0b                	je     800a3b <strlcpy+0x30>
			*dst++ = *src++;
  800a30:	83 c1 01             	add    $0x1,%ecx
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a39:	eb ea                	jmp    800a25 <strlcpy+0x1a>
  800a3b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a40:	29 f0                	sub    %esi,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a4f:	0f b6 01             	movzbl (%ecx),%eax
  800a52:	84 c0                	test   %al,%al
  800a54:	74 0c                	je     800a62 <strcmp+0x1c>
  800a56:	3a 02                	cmp    (%edx),%al
  800a58:	75 08                	jne    800a62 <strcmp+0x1c>
		p++, q++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	eb ed                	jmp    800a4f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a62:	0f b6 c0             	movzbl %al,%eax
  800a65:	0f b6 12             	movzbl (%edx),%edx
  800a68:	29 d0                	sub    %edx,%eax
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	53                   	push   %ebx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 c3                	mov    %eax,%ebx
  800a78:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7b:	eb 06                	jmp    800a83 <strncmp+0x17>
		n--, p++, q++;
  800a7d:	83 c0 01             	add    $0x1,%eax
  800a80:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a83:	39 d8                	cmp    %ebx,%eax
  800a85:	74 16                	je     800a9d <strncmp+0x31>
  800a87:	0f b6 08             	movzbl (%eax),%ecx
  800a8a:	84 c9                	test   %cl,%cl
  800a8c:	74 04                	je     800a92 <strncmp+0x26>
  800a8e:	3a 0a                	cmp    (%edx),%cl
  800a90:	74 eb                	je     800a7d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a92:	0f b6 00             	movzbl (%eax),%eax
  800a95:	0f b6 12             	movzbl (%edx),%edx
  800a98:	29 d0                	sub    %edx,%eax
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    
		return 0;
  800a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa2:	eb f6                	jmp    800a9a <strncmp+0x2e>

00800aa4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aae:	0f b6 10             	movzbl (%eax),%edx
  800ab1:	84 d2                	test   %dl,%dl
  800ab3:	74 09                	je     800abe <strchr+0x1a>
		if (*s == c)
  800ab5:	38 ca                	cmp    %cl,%dl
  800ab7:	74 0a                	je     800ac3 <strchr+0x1f>
	for (; *s; s++)
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	eb f0                	jmp    800aae <strchr+0xa>
			return (char *) s;
	return 0;
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800acf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad2:	38 ca                	cmp    %cl,%dl
  800ad4:	74 09                	je     800adf <strfind+0x1a>
  800ad6:	84 d2                	test   %dl,%dl
  800ad8:	74 05                	je     800adf <strfind+0x1a>
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	eb f0                	jmp    800acf <strfind+0xa>
			break;
	return (char *) s;
}
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	57                   	push   %edi
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aed:	85 c9                	test   %ecx,%ecx
  800aef:	74 31                	je     800b22 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af1:	89 f8                	mov    %edi,%eax
  800af3:	09 c8                	or     %ecx,%eax
  800af5:	a8 03                	test   $0x3,%al
  800af7:	75 23                	jne    800b1c <memset+0x3b>
		c &= 0xFF;
  800af9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afd:	89 d3                	mov    %edx,%ebx
  800aff:	c1 e3 08             	shl    $0x8,%ebx
  800b02:	89 d0                	mov    %edx,%eax
  800b04:	c1 e0 18             	shl    $0x18,%eax
  800b07:	89 d6                	mov    %edx,%esi
  800b09:	c1 e6 10             	shl    $0x10,%esi
  800b0c:	09 f0                	or     %esi,%eax
  800b0e:	09 c2                	or     %eax,%edx
  800b10:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b12:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	fc                   	cld    
  800b18:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1a:	eb 06                	jmp    800b22 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	fc                   	cld    
  800b20:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b22:	89 f8                	mov    %edi,%eax
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b37:	39 c6                	cmp    %eax,%esi
  800b39:	73 32                	jae    800b6d <memmove+0x44>
  800b3b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b3e:	39 c2                	cmp    %eax,%edx
  800b40:	76 2b                	jbe    800b6d <memmove+0x44>
		s += n;
		d += n;
  800b42:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b45:	89 fe                	mov    %edi,%esi
  800b47:	09 ce                	or     %ecx,%esi
  800b49:	09 d6                	or     %edx,%esi
  800b4b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b51:	75 0e                	jne    800b61 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b53:	83 ef 04             	sub    $0x4,%edi
  800b56:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b59:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5c:	fd                   	std    
  800b5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5f:	eb 09                	jmp    800b6a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b61:	83 ef 01             	sub    $0x1,%edi
  800b64:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b67:	fd                   	std    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6a:	fc                   	cld    
  800b6b:	eb 1a                	jmp    800b87 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6d:	89 c2                	mov    %eax,%edx
  800b6f:	09 ca                	or     %ecx,%edx
  800b71:	09 f2                	or     %esi,%edx
  800b73:	f6 c2 03             	test   $0x3,%dl
  800b76:	75 0a                	jne    800b82 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7b:	89 c7                	mov    %eax,%edi
  800b7d:	fc                   	cld    
  800b7e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b80:	eb 05                	jmp    800b87 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	fc                   	cld    
  800b85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b91:	ff 75 10             	pushl  0x10(%ebp)
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	ff 75 08             	pushl  0x8(%ebp)
  800b9a:	e8 8a ff ff ff       	call   800b29 <memmove>
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bac:	89 c6                	mov    %eax,%esi
  800bae:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb1:	39 f0                	cmp    %esi,%eax
  800bb3:	74 1c                	je     800bd1 <memcmp+0x30>
		if (*s1 != *s2)
  800bb5:	0f b6 08             	movzbl (%eax),%ecx
  800bb8:	0f b6 1a             	movzbl (%edx),%ebx
  800bbb:	38 d9                	cmp    %bl,%cl
  800bbd:	75 08                	jne    800bc7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bbf:	83 c0 01             	add    $0x1,%eax
  800bc2:	83 c2 01             	add    $0x1,%edx
  800bc5:	eb ea                	jmp    800bb1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc7:	0f b6 c1             	movzbl %cl,%eax
  800bca:	0f b6 db             	movzbl %bl,%ebx
  800bcd:	29 d8                	sub    %ebx,%eax
  800bcf:	eb 05                	jmp    800bd6 <memcmp+0x35>
	}

	return 0;
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be3:	89 c2                	mov    %eax,%edx
  800be5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be8:	39 d0                	cmp    %edx,%eax
  800bea:	73 09                	jae    800bf5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bec:	38 08                	cmp    %cl,(%eax)
  800bee:	74 05                	je     800bf5 <memfind+0x1b>
	for (; s < ends; s++)
  800bf0:	83 c0 01             	add    $0x1,%eax
  800bf3:	eb f3                	jmp    800be8 <memfind+0xe>
			break;
	return (void *) s;
}
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c03:	eb 03                	jmp    800c08 <strtol+0x11>
		s++;
  800c05:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c08:	0f b6 01             	movzbl (%ecx),%eax
  800c0b:	3c 20                	cmp    $0x20,%al
  800c0d:	74 f6                	je     800c05 <strtol+0xe>
  800c0f:	3c 09                	cmp    $0x9,%al
  800c11:	74 f2                	je     800c05 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c13:	3c 2b                	cmp    $0x2b,%al
  800c15:	74 2a                	je     800c41 <strtol+0x4a>
	int neg = 0;
  800c17:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1c:	3c 2d                	cmp    $0x2d,%al
  800c1e:	74 2b                	je     800c4b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c20:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c26:	75 0f                	jne    800c37 <strtol+0x40>
  800c28:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2b:	74 28                	je     800c55 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2d:	85 db                	test   %ebx,%ebx
  800c2f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c34:	0f 44 d8             	cmove  %eax,%ebx
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c3f:	eb 50                	jmp    800c91 <strtol+0x9a>
		s++;
  800c41:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c44:	bf 00 00 00 00       	mov    $0x0,%edi
  800c49:	eb d5                	jmp    800c20 <strtol+0x29>
		s++, neg = 1;
  800c4b:	83 c1 01             	add    $0x1,%ecx
  800c4e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c53:	eb cb                	jmp    800c20 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c55:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c59:	74 0e                	je     800c69 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c5b:	85 db                	test   %ebx,%ebx
  800c5d:	75 d8                	jne    800c37 <strtol+0x40>
		s++, base = 8;
  800c5f:	83 c1 01             	add    $0x1,%ecx
  800c62:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c67:	eb ce                	jmp    800c37 <strtol+0x40>
		s += 2, base = 16;
  800c69:	83 c1 02             	add    $0x2,%ecx
  800c6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c71:	eb c4                	jmp    800c37 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c73:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c76:	89 f3                	mov    %esi,%ebx
  800c78:	80 fb 19             	cmp    $0x19,%bl
  800c7b:	77 29                	ja     800ca6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c7d:	0f be d2             	movsbl %dl,%edx
  800c80:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c83:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c86:	7d 30                	jge    800cb8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c88:	83 c1 01             	add    $0x1,%ecx
  800c8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c91:	0f b6 11             	movzbl (%ecx),%edx
  800c94:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c97:	89 f3                	mov    %esi,%ebx
  800c99:	80 fb 09             	cmp    $0x9,%bl
  800c9c:	77 d5                	ja     800c73 <strtol+0x7c>
			dig = *s - '0';
  800c9e:	0f be d2             	movsbl %dl,%edx
  800ca1:	83 ea 30             	sub    $0x30,%edx
  800ca4:	eb dd                	jmp    800c83 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ca6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca9:	89 f3                	mov    %esi,%ebx
  800cab:	80 fb 19             	cmp    $0x19,%bl
  800cae:	77 08                	ja     800cb8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb0:	0f be d2             	movsbl %dl,%edx
  800cb3:	83 ea 37             	sub    $0x37,%edx
  800cb6:	eb cb                	jmp    800c83 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbc:	74 05                	je     800cc3 <strtol+0xcc>
		*endptr = (char *) s;
  800cbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc3:	89 c2                	mov    %eax,%edx
  800cc5:	f7 da                	neg    %edx
  800cc7:	85 ff                	test   %edi,%edi
  800cc9:	0f 45 c2             	cmovne %edx,%eax
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	89 c3                	mov    %eax,%ebx
  800ce4:	89 c7                	mov    %eax,%edi
  800ce6:	89 c6                	mov    %eax,%esi
  800ce8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_cgetc>:

int
sys_cgetc(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d3                	mov    %edx,%ebx
  800d03:	89 d7                	mov    %edx,%edi
  800d05:	89 d6                	mov    %edx,%esi
  800d07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d24:	89 cb                	mov    %ecx,%ebx
  800d26:	89 cf                	mov    %ecx,%edi
  800d28:	89 ce                	mov    %ecx,%esi
  800d2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	6a 03                	push   $0x3
  800d3e:	68 08 2a 80 00       	push   $0x802a08
  800d43:	6a 43                	push   $0x43
  800d45:	68 25 2a 80 00       	push   $0x802a25
  800d4a:	e8 69 14 00 00       	call   8021b8 <_panic>

00800d4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d55:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5f:	89 d1                	mov    %edx,%ecx
  800d61:	89 d3                	mov    %edx,%ebx
  800d63:	89 d7                	mov    %edx,%edi
  800d65:	89 d6                	mov    %edx,%esi
  800d67:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <sys_yield>:

void
sys_yield(void)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d96:	be 00 00 00 00       	mov    $0x0,%esi
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	b8 04 00 00 00       	mov    $0x4,%eax
  800da6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da9:	89 f7                	mov    %esi,%edi
  800dab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	7f 08                	jg     800db9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db9:	83 ec 0c             	sub    $0xc,%esp
  800dbc:	50                   	push   %eax
  800dbd:	6a 04                	push   $0x4
  800dbf:	68 08 2a 80 00       	push   $0x802a08
  800dc4:	6a 43                	push   $0x43
  800dc6:	68 25 2a 80 00       	push   $0x802a25
  800dcb:	e8 e8 13 00 00       	call   8021b8 <_panic>

00800dd0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	b8 05 00 00 00       	mov    $0x5,%eax
  800de4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dea:	8b 75 18             	mov    0x18(%ebp),%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 05                	push   $0x5
  800e01:	68 08 2a 80 00       	push   $0x802a08
  800e06:	6a 43                	push   $0x43
  800e08:	68 25 2a 80 00       	push   $0x802a25
  800e0d:	e8 a6 13 00 00       	call   8021b8 <_panic>

00800e12 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e26:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2b:	89 df                	mov    %ebx,%edi
  800e2d:	89 de                	mov    %ebx,%esi
  800e2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7f 08                	jg     800e3d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	50                   	push   %eax
  800e41:	6a 06                	push   $0x6
  800e43:	68 08 2a 80 00       	push   $0x802a08
  800e48:	6a 43                	push   $0x43
  800e4a:	68 25 2a 80 00       	push   $0x802a25
  800e4f:	e8 64 13 00 00       	call   8021b8 <_panic>

00800e54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 08 00 00 00       	mov    $0x8,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 08                	push   $0x8
  800e85:	68 08 2a 80 00       	push   $0x802a08
  800e8a:	6a 43                	push   $0x43
  800e8c:	68 25 2a 80 00       	push   $0x802a25
  800e91:	e8 22 13 00 00       	call   8021b8 <_panic>

00800e96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 09 00 00 00       	mov    $0x9,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 09                	push   $0x9
  800ec7:	68 08 2a 80 00       	push   $0x802a08
  800ecc:	6a 43                	push   $0x43
  800ece:	68 25 2a 80 00       	push   $0x802a25
  800ed3:	e8 e0 12 00 00       	call   8021b8 <_panic>

00800ed8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 0a                	push   $0xa
  800f09:	68 08 2a 80 00       	push   $0x802a08
  800f0e:	6a 43                	push   $0x43
  800f10:	68 25 2a 80 00       	push   $0x802a25
  800f15:	e8 9e 12 00 00       	call   8021b8 <_panic>

00800f1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2b:	be 00 00 00 00       	mov    $0x0,%esi
  800f30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f36:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f53:	89 cb                	mov    %ecx,%ebx
  800f55:	89 cf                	mov    %ecx,%edi
  800f57:	89 ce                	mov    %ecx,%esi
  800f59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	7f 08                	jg     800f67 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f67:	83 ec 0c             	sub    $0xc,%esp
  800f6a:	50                   	push   %eax
  800f6b:	6a 0d                	push   $0xd
  800f6d:	68 08 2a 80 00       	push   $0x802a08
  800f72:	6a 43                	push   $0x43
  800f74:	68 25 2a 80 00       	push   $0x802a25
  800f79:	e8 3a 12 00 00       	call   8021b8 <_panic>

00800f7e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f94:	89 df                	mov    %ebx,%edi
  800f96:	89 de                	mov    %ebx,%esi
  800f98:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb2:	89 cb                	mov    %ecx,%ebx
  800fb4:	89 cf                	mov    %ecx,%edi
  800fb6:	89 ce                	mov    %ecx,%esi
  800fb8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fca:	b8 10 00 00 00       	mov    $0x10,%eax
  800fcf:	89 d1                	mov    %edx,%ecx
  800fd1:	89 d3                	mov    %edx,%ebx
  800fd3:	89 d7                	mov    %edx,%edi
  800fd5:	89 d6                	mov    %edx,%esi
  800fd7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff4:	89 df                	mov    %ebx,%edi
  800ff6:	89 de                	mov    %ebx,%esi
  800ff8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	b8 12 00 00 00       	mov    $0x12,%eax
  801015:	89 df                	mov    %ebx,%edi
  801017:	89 de                	mov    %ebx,%esi
  801019:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	b8 13 00 00 00       	mov    $0x13,%eax
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7f 08                	jg     80104b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	6a 13                	push   $0x13
  801051:	68 08 2a 80 00       	push   $0x802a08
  801056:	6a 43                	push   $0x43
  801058:	68 25 2a 80 00       	push   $0x802a25
  80105d:	e8 56 11 00 00       	call   8021b8 <_panic>

00801062 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	05 00 00 00 30       	add    $0x30000000,%eax
  80106d:	c1 e8 0c             	shr    $0xc,%eax
}
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80107d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801082:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801091:	89 c2                	mov    %eax,%edx
  801093:	c1 ea 16             	shr    $0x16,%edx
  801096:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109d:	f6 c2 01             	test   $0x1,%dl
  8010a0:	74 2d                	je     8010cf <fd_alloc+0x46>
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 0c             	shr    $0xc,%edx
  8010a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	74 1c                	je     8010cf <fd_alloc+0x46>
  8010b3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010b8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010bd:	75 d2                	jne    801091 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010c8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010cd:	eb 0a                	jmp    8010d9 <fd_alloc+0x50>
			*fd_store = fd;
  8010cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e1:	83 f8 1f             	cmp    $0x1f,%eax
  8010e4:	77 30                	ja     801116 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e6:	c1 e0 0c             	shl    $0xc,%eax
  8010e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ee:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010f4:	f6 c2 01             	test   $0x1,%dl
  8010f7:	74 24                	je     80111d <fd_lookup+0x42>
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 0c             	shr    $0xc,%edx
  8010fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	74 1a                	je     801124 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110d:	89 02                	mov    %eax,(%edx)
	return 0;
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
		return -E_INVAL;
  801116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111b:	eb f7                	jmp    801114 <fd_lookup+0x39>
		return -E_INVAL;
  80111d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801122:	eb f0                	jmp    801114 <fd_lookup+0x39>
  801124:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801129:	eb e9                	jmp    801114 <fd_lookup+0x39>

0080112b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801134:	ba 00 00 00 00       	mov    $0x0,%edx
  801139:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80113e:	39 08                	cmp    %ecx,(%eax)
  801140:	74 38                	je     80117a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801142:	83 c2 01             	add    $0x1,%edx
  801145:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  80114c:	85 c0                	test   %eax,%eax
  80114e:	75 ee                	jne    80113e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801150:	a1 08 40 80 00       	mov    0x804008,%eax
  801155:	8b 40 48             	mov    0x48(%eax),%eax
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	51                   	push   %ecx
  80115c:	50                   	push   %eax
  80115d:	68 34 2a 80 00       	push   $0x802a34
  801162:	e8 d5 f0 ff ff       	call   80023c <cprintf>
	*dev = 0;
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    
			*dev = devtab[i];
  80117a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	eb f2                	jmp    801178 <dev_lookup+0x4d>

00801186 <fd_close>:
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	57                   	push   %edi
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	83 ec 24             	sub    $0x24,%esp
  80118f:	8b 75 08             	mov    0x8(%ebp),%esi
  801192:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801195:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801198:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801199:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80119f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a2:	50                   	push   %eax
  8011a3:	e8 33 ff ff ff       	call   8010db <fd_lookup>
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 05                	js     8011b6 <fd_close+0x30>
	    || fd != fd2)
  8011b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011b4:	74 16                	je     8011cc <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b6:	89 f8                	mov    %edi,%eax
  8011b8:	84 c0                	test   %al,%al
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8011c2:	89 d8                	mov    %ebx,%eax
  8011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011d2:	50                   	push   %eax
  8011d3:	ff 36                	pushl  (%esi)
  8011d5:	e8 51 ff ff ff       	call   80112b <dev_lookup>
  8011da:	89 c3                	mov    %eax,%ebx
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	78 1a                	js     8011fd <fd_close+0x77>
		if (dev->dev_close)
  8011e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	74 0b                	je     8011fd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	56                   	push   %esi
  8011f6:	ff d0                	call   *%eax
  8011f8:	89 c3                	mov    %eax,%ebx
  8011fa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	56                   	push   %esi
  801201:	6a 00                	push   $0x0
  801203:	e8 0a fc ff ff       	call   800e12 <sys_page_unmap>
	return r;
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	eb b5                	jmp    8011c2 <fd_close+0x3c>

0080120d <close>:

int
close(int fdnum)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801213:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801216:	50                   	push   %eax
  801217:	ff 75 08             	pushl  0x8(%ebp)
  80121a:	e8 bc fe ff ff       	call   8010db <fd_lookup>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	79 02                	jns    801228 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    
		return fd_close(fd, 1);
  801228:	83 ec 08             	sub    $0x8,%esp
  80122b:	6a 01                	push   $0x1
  80122d:	ff 75 f4             	pushl  -0xc(%ebp)
  801230:	e8 51 ff ff ff       	call   801186 <fd_close>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	eb ec                	jmp    801226 <close+0x19>

0080123a <close_all>:

void
close_all(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801241:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	53                   	push   %ebx
  80124a:	e8 be ff ff ff       	call   80120d <close>
	for (i = 0; i < MAXFD; i++)
  80124f:	83 c3 01             	add    $0x1,%ebx
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	83 fb 20             	cmp    $0x20,%ebx
  801258:	75 ec                	jne    801246 <close_all+0xc>
}
  80125a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801268:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126b:	50                   	push   %eax
  80126c:	ff 75 08             	pushl  0x8(%ebp)
  80126f:	e8 67 fe ff ff       	call   8010db <fd_lookup>
  801274:	89 c3                	mov    %eax,%ebx
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	0f 88 81 00 00 00    	js     801302 <dup+0xa3>
		return r;
	close(newfdnum);
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 81 ff ff ff       	call   80120d <close>

	newfd = INDEX2FD(newfdnum);
  80128c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128f:	c1 e6 0c             	shl    $0xc,%esi
  801292:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801298:	83 c4 04             	add    $0x4,%esp
  80129b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129e:	e8 cf fd ff ff       	call   801072 <fd2data>
  8012a3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a5:	89 34 24             	mov    %esi,(%esp)
  8012a8:	e8 c5 fd ff ff       	call   801072 <fd2data>
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	c1 e8 16             	shr    $0x16,%eax
  8012b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012be:	a8 01                	test   $0x1,%al
  8012c0:	74 11                	je     8012d3 <dup+0x74>
  8012c2:	89 d8                	mov    %ebx,%eax
  8012c4:	c1 e8 0c             	shr    $0xc,%eax
  8012c7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ce:	f6 c2 01             	test   $0x1,%dl
  8012d1:	75 39                	jne    80130c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d6:	89 d0                	mov    %edx,%eax
  8012d8:	c1 e8 0c             	shr    $0xc,%eax
  8012db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ea:	50                   	push   %eax
  8012eb:	56                   	push   %esi
  8012ec:	6a 00                	push   $0x0
  8012ee:	52                   	push   %edx
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 da fa ff ff       	call   800dd0 <sys_page_map>
  8012f6:	89 c3                	mov    %eax,%ebx
  8012f8:	83 c4 20             	add    $0x20,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 31                	js     801330 <dup+0xd1>
		goto err;

	return newfdnum;
  8012ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801302:	89 d8                	mov    %ebx,%eax
  801304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801313:	83 ec 0c             	sub    $0xc,%esp
  801316:	25 07 0e 00 00       	and    $0xe07,%eax
  80131b:	50                   	push   %eax
  80131c:	57                   	push   %edi
  80131d:	6a 00                	push   $0x0
  80131f:	53                   	push   %ebx
  801320:	6a 00                	push   $0x0
  801322:	e8 a9 fa ff ff       	call   800dd0 <sys_page_map>
  801327:	89 c3                	mov    %eax,%ebx
  801329:	83 c4 20             	add    $0x20,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	79 a3                	jns    8012d3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	56                   	push   %esi
  801334:	6a 00                	push   $0x0
  801336:	e8 d7 fa ff ff       	call   800e12 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80133b:	83 c4 08             	add    $0x8,%esp
  80133e:	57                   	push   %edi
  80133f:	6a 00                	push   $0x0
  801341:	e8 cc fa ff ff       	call   800e12 <sys_page_unmap>
	return r;
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	eb b7                	jmp    801302 <dup+0xa3>

0080134b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	83 ec 1c             	sub    $0x1c,%esp
  801352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801355:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	53                   	push   %ebx
  80135a:	e8 7c fd ff ff       	call   8010db <fd_lookup>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 3f                	js     8013a5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	ff 30                	pushl  (%eax)
  801372:	e8 b4 fd ff ff       	call   80112b <dev_lookup>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 27                	js     8013a5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801381:	8b 42 08             	mov    0x8(%edx),%eax
  801384:	83 e0 03             	and    $0x3,%eax
  801387:	83 f8 01             	cmp    $0x1,%eax
  80138a:	74 1e                	je     8013aa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138f:	8b 40 08             	mov    0x8(%eax),%eax
  801392:	85 c0                	test   %eax,%eax
  801394:	74 35                	je     8013cb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	ff 75 10             	pushl  0x10(%ebp)
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	52                   	push   %edx
  8013a0:	ff d0                	call   *%eax
  8013a2:	83 c4 10             	add    $0x10,%esp
}
  8013a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8013af:	8b 40 48             	mov    0x48(%eax),%eax
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	50                   	push   %eax
  8013b7:	68 75 2a 80 00       	push   $0x802a75
  8013bc:	e8 7b ee ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c9:	eb da                	jmp    8013a5 <read+0x5a>
		return -E_NOT_SUPP;
  8013cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d0:	eb d3                	jmp    8013a5 <read+0x5a>

008013d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	57                   	push   %edi
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e6:	39 f3                	cmp    %esi,%ebx
  8013e8:	73 23                	jae    80140d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	89 f0                	mov    %esi,%eax
  8013ef:	29 d8                	sub    %ebx,%eax
  8013f1:	50                   	push   %eax
  8013f2:	89 d8                	mov    %ebx,%eax
  8013f4:	03 45 0c             	add    0xc(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	57                   	push   %edi
  8013f9:	e8 4d ff ff ff       	call   80134b <read>
		if (m < 0)
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 06                	js     80140b <readn+0x39>
			return m;
		if (m == 0)
  801405:	74 06                	je     80140d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801407:	01 c3                	add    %eax,%ebx
  801409:	eb db                	jmp    8013e6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 1c             	sub    $0x1c,%esp
  80141e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	53                   	push   %ebx
  801426:	e8 b0 fc ff ff       	call   8010db <fd_lookup>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 3a                	js     80146c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143c:	ff 30                	pushl  (%eax)
  80143e:	e8 e8 fc ff ff       	call   80112b <dev_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 22                	js     80146c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801451:	74 1e                	je     801471 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801456:	8b 52 0c             	mov    0xc(%edx),%edx
  801459:	85 d2                	test   %edx,%edx
  80145b:	74 35                	je     801492 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	ff 75 10             	pushl  0x10(%ebp)
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	50                   	push   %eax
  801467:	ff d2                	call   *%edx
  801469:	83 c4 10             	add    $0x10,%esp
}
  80146c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146f:	c9                   	leave  
  801470:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801471:	a1 08 40 80 00       	mov    0x804008,%eax
  801476:	8b 40 48             	mov    0x48(%eax),%eax
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	53                   	push   %ebx
  80147d:	50                   	push   %eax
  80147e:	68 91 2a 80 00       	push   $0x802a91
  801483:	e8 b4 ed ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb da                	jmp    80146c <write+0x55>
		return -E_NOT_SUPP;
  801492:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801497:	eb d3                	jmp    80146c <write+0x55>

00801499 <seek>:

int
seek(int fdnum, off_t offset)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80149f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 30 fc ff ff       	call   8010db <fd_lookup>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 0e                	js     8014c0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 1c             	sub    $0x1c,%esp
  8014c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	53                   	push   %ebx
  8014d1:	e8 05 fc ff ff       	call   8010db <fd_lookup>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 37                	js     801514 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e7:	ff 30                	pushl  (%eax)
  8014e9:	e8 3d fc ff ff       	call   80112b <dev_lookup>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 1f                	js     801514 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fc:	74 1b                	je     801519 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801501:	8b 52 18             	mov    0x18(%edx),%edx
  801504:	85 d2                	test   %edx,%edx
  801506:	74 32                	je     80153a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	50                   	push   %eax
  80150f:	ff d2                	call   *%edx
  801511:	83 c4 10             	add    $0x10,%esp
}
  801514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
			thisenv->env_id, fdnum);
  801519:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80151e:	8b 40 48             	mov    0x48(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	53                   	push   %ebx
  801525:	50                   	push   %eax
  801526:	68 54 2a 80 00       	push   $0x802a54
  80152b:	e8 0c ed ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801538:	eb da                	jmp    801514 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80153a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153f:	eb d3                	jmp    801514 <ftruncate+0x52>

00801541 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	53                   	push   %ebx
  801545:	83 ec 1c             	sub    $0x1c,%esp
  801548:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154e:	50                   	push   %eax
  80154f:	ff 75 08             	pushl  0x8(%ebp)
  801552:	e8 84 fb ff ff       	call   8010db <fd_lookup>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 4b                	js     8015a9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801564:	50                   	push   %eax
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	ff 30                	pushl  (%eax)
  80156a:	e8 bc fb ff ff       	call   80112b <dev_lookup>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 33                	js     8015a9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80157d:	74 2f                	je     8015ae <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80157f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801582:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801589:	00 00 00 
	stat->st_isdir = 0;
  80158c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801593:	00 00 00 
	stat->st_dev = dev;
  801596:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	53                   	push   %ebx
  8015a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a3:	ff 50 14             	call   *0x14(%eax)
  8015a6:	83 c4 10             	add    $0x10,%esp
}
  8015a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b3:	eb f4                	jmp    8015a9 <fstat+0x68>

008015b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	6a 00                	push   $0x0
  8015bf:	ff 75 08             	pushl  0x8(%ebp)
  8015c2:	e8 22 02 00 00       	call   8017e9 <open>
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 1b                	js     8015eb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	50                   	push   %eax
  8015d7:	e8 65 ff ff ff       	call   801541 <fstat>
  8015dc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015de:	89 1c 24             	mov    %ebx,(%esp)
  8015e1:	e8 27 fc ff ff       	call   80120d <close>
	return r;
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	89 f3                	mov    %esi,%ebx
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	89 c6                	mov    %eax,%esi
  8015fb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015fd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801604:	74 27                	je     80162d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801606:	6a 07                	push   $0x7
  801608:	68 00 50 80 00       	push   $0x805000
  80160d:	56                   	push   %esi
  80160e:	ff 35 00 40 80 00    	pushl  0x804000
  801614:	e8 69 0c 00 00       	call   802282 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801619:	83 c4 0c             	add    $0xc,%esp
  80161c:	6a 00                	push   $0x0
  80161e:	53                   	push   %ebx
  80161f:	6a 00                	push   $0x0
  801621:	e8 f3 0b 00 00       	call   802219 <ipc_recv>
}
  801626:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	6a 01                	push   $0x1
  801632:	e8 a3 0c 00 00       	call   8022da <ipc_find_env>
  801637:	a3 00 40 80 00       	mov    %eax,0x804000
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	eb c5                	jmp    801606 <fsipc+0x12>

00801641 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 40 0c             	mov    0xc(%eax),%eax
  80164d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	b8 02 00 00 00       	mov    $0x2,%eax
  801664:	e8 8b ff ff ff       	call   8015f4 <fsipc>
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <devfile_flush>:
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8b 40 0c             	mov    0xc(%eax),%eax
  801677:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b8 06 00 00 00       	mov    $0x6,%eax
  801686:	e8 69 ff ff ff       	call   8015f4 <fsipc>
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <devfile_stat>:
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	53                   	push   %ebx
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8b 40 0c             	mov    0xc(%eax),%eax
  80169d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ac:	e8 43 ff ff ff       	call   8015f4 <fsipc>
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 2c                	js     8016e1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	68 00 50 80 00       	push   $0x805000
  8016bd:	53                   	push   %ebx
  8016be:	e8 d8 f2 ff ff       	call   80099b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016c3:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ce:	a1 84 50 80 00       	mov    0x805084,%eax
  8016d3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <devfile_write>:
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	53                   	push   %ebx
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016fb:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801701:	53                   	push   %ebx
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	68 08 50 80 00       	push   $0x805008
  80170a:	e8 7c f4 ff ff       	call   800b8b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80170f:	ba 00 00 00 00       	mov    $0x0,%edx
  801714:	b8 04 00 00 00       	mov    $0x4,%eax
  801719:	e8 d6 fe ff ff       	call   8015f4 <fsipc>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 0b                	js     801730 <devfile_write+0x4a>
	assert(r <= n);
  801725:	39 d8                	cmp    %ebx,%eax
  801727:	77 0c                	ja     801735 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801729:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172e:	7f 1e                	jg     80174e <devfile_write+0x68>
}
  801730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801733:	c9                   	leave  
  801734:	c3                   	ret    
	assert(r <= n);
  801735:	68 c4 2a 80 00       	push   $0x802ac4
  80173a:	68 cb 2a 80 00       	push   $0x802acb
  80173f:	68 98 00 00 00       	push   $0x98
  801744:	68 e0 2a 80 00       	push   $0x802ae0
  801749:	e8 6a 0a 00 00       	call   8021b8 <_panic>
	assert(r <= PGSIZE);
  80174e:	68 eb 2a 80 00       	push   $0x802aeb
  801753:	68 cb 2a 80 00       	push   $0x802acb
  801758:	68 99 00 00 00       	push   $0x99
  80175d:	68 e0 2a 80 00       	push   $0x802ae0
  801762:	e8 51 0a 00 00       	call   8021b8 <_panic>

00801767 <devfile_read>:
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80177a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	b8 03 00 00 00       	mov    $0x3,%eax
  80178a:	e8 65 fe ff ff       	call   8015f4 <fsipc>
  80178f:	89 c3                	mov    %eax,%ebx
  801791:	85 c0                	test   %eax,%eax
  801793:	78 1f                	js     8017b4 <devfile_read+0x4d>
	assert(r <= n);
  801795:	39 f0                	cmp    %esi,%eax
  801797:	77 24                	ja     8017bd <devfile_read+0x56>
	assert(r <= PGSIZE);
  801799:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179e:	7f 33                	jg     8017d3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	50                   	push   %eax
  8017a4:	68 00 50 80 00       	push   $0x805000
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	e8 78 f3 ff ff       	call   800b29 <memmove>
	return r;
  8017b1:	83 c4 10             	add    $0x10,%esp
}
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
	assert(r <= n);
  8017bd:	68 c4 2a 80 00       	push   $0x802ac4
  8017c2:	68 cb 2a 80 00       	push   $0x802acb
  8017c7:	6a 7c                	push   $0x7c
  8017c9:	68 e0 2a 80 00       	push   $0x802ae0
  8017ce:	e8 e5 09 00 00       	call   8021b8 <_panic>
	assert(r <= PGSIZE);
  8017d3:	68 eb 2a 80 00       	push   $0x802aeb
  8017d8:	68 cb 2a 80 00       	push   $0x802acb
  8017dd:	6a 7d                	push   $0x7d
  8017df:	68 e0 2a 80 00       	push   $0x802ae0
  8017e4:	e8 cf 09 00 00       	call   8021b8 <_panic>

008017e9 <open>:
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017f4:	56                   	push   %esi
  8017f5:	e8 68 f1 ff ff       	call   800962 <strlen>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801802:	7f 6c                	jg     801870 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	e8 79 f8 ff ff       	call   801089 <fd_alloc>
  801810:	89 c3                	mov    %eax,%ebx
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 3c                	js     801855 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	56                   	push   %esi
  80181d:	68 00 50 80 00       	push   $0x805000
  801822:	e8 74 f1 ff ff       	call   80099b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80182f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801832:	b8 01 00 00 00       	mov    $0x1,%eax
  801837:	e8 b8 fd ff ff       	call   8015f4 <fsipc>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 19                	js     80185e <open+0x75>
	return fd2num(fd);
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	ff 75 f4             	pushl  -0xc(%ebp)
  80184b:	e8 12 f8 ff ff       	call   801062 <fd2num>
  801850:	89 c3                	mov    %eax,%ebx
  801852:	83 c4 10             	add    $0x10,%esp
}
  801855:	89 d8                	mov    %ebx,%eax
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
		fd_close(fd, 0);
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	6a 00                	push   $0x0
  801863:	ff 75 f4             	pushl  -0xc(%ebp)
  801866:	e8 1b f9 ff ff       	call   801186 <fd_close>
		return r;
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	eb e5                	jmp    801855 <open+0x6c>
		return -E_BAD_PATH;
  801870:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801875:	eb de                	jmp    801855 <open+0x6c>

00801877 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80187d:	ba 00 00 00 00       	mov    $0x0,%edx
  801882:	b8 08 00 00 00       	mov    $0x8,%eax
  801887:	e8 68 fd ff ff       	call   8015f4 <fsipc>
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801894:	68 f7 2a 80 00       	push   $0x802af7
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	e8 fa f0 ff ff       	call   80099b <strcpy>
	return 0;
}
  8018a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <devsock_close>:
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 10             	sub    $0x10,%esp
  8018af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018b2:	53                   	push   %ebx
  8018b3:	e8 5d 0a 00 00       	call   802315 <pageref>
  8018b8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018bb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018c0:	83 f8 01             	cmp    $0x1,%eax
  8018c3:	74 07                	je     8018cc <devsock_close+0x24>
}
  8018c5:	89 d0                	mov    %edx,%eax
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018cc:	83 ec 0c             	sub    $0xc,%esp
  8018cf:	ff 73 0c             	pushl  0xc(%ebx)
  8018d2:	e8 b9 02 00 00       	call   801b90 <nsipc_close>
  8018d7:	89 c2                	mov    %eax,%edx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb e7                	jmp    8018c5 <devsock_close+0x1d>

008018de <devsock_write>:
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 10             	pushl  0x10(%ebp)
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	ff 70 0c             	pushl  0xc(%eax)
  8018f2:	e8 76 03 00 00       	call   801c6d <nsipc_send>
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <devsock_read>:
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	ff 70 0c             	pushl  0xc(%eax)
  80190d:	e8 ef 02 00 00       	call   801c01 <nsipc_recv>
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <fd2sockid>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	e8 b7 f7 ff ff       	call   8010db <fd_lookup>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 10                	js     80193b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801934:	39 08                	cmp    %ecx,(%eax)
  801936:	75 05                	jne    80193d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
		return -E_NOT_SUPP;
  80193d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801942:	eb f7                	jmp    80193b <fd2sockid+0x27>

00801944 <alloc_sockfd>:
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 1c             	sub    $0x1c,%esp
  80194c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80194e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801951:	50                   	push   %eax
  801952:	e8 32 f7 ff ff       	call   801089 <fd_alloc>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 43                	js     8019a3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 07 04 00 00       	push   $0x407
  801968:	ff 75 f4             	pushl  -0xc(%ebp)
  80196b:	6a 00                	push   $0x0
  80196d:	e8 1b f4 ff ff       	call   800d8d <sys_page_alloc>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 28                	js     8019a3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801984:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801989:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801990:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	50                   	push   %eax
  801997:	e8 c6 f6 ff ff       	call   801062 <fd2num>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	eb 0c                	jmp    8019af <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	56                   	push   %esi
  8019a7:	e8 e4 01 00 00       	call   801b90 <nsipc_close>
		return r;
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    

008019b8 <accept>:
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	e8 4e ff ff ff       	call   801914 <fd2sockid>
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 1b                	js     8019e5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	ff 75 10             	pushl  0x10(%ebp)
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	e8 0e 01 00 00       	call   801ae7 <nsipc_accept>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 05                	js     8019e5 <accept+0x2d>
	return alloc_sockfd(r);
  8019e0:	e8 5f ff ff ff       	call   801944 <alloc_sockfd>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <bind>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	e8 1f ff ff ff       	call   801914 <fd2sockid>
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 12                	js     801a0b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	50                   	push   %eax
  801a03:	e8 31 01 00 00       	call   801b39 <nsipc_bind>
  801a08:	83 c4 10             	add    $0x10,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <shutdown>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	e8 f9 fe ff ff       	call   801914 <fd2sockid>
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 0f                	js     801a2e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	50                   	push   %eax
  801a26:	e8 43 01 00 00       	call   801b6e <nsipc_shutdown>
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <connect>:
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	e8 d6 fe ff ff       	call   801914 <fd2sockid>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 12                	js     801a54 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	e8 59 01 00 00       	call   801baa <nsipc_connect>
  801a51:	83 c4 10             	add    $0x10,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <listen>:
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	e8 b0 fe ff ff       	call   801914 <fd2sockid>
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 0f                	js     801a77 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	e8 6b 01 00 00       	call   801bdf <nsipc_listen>
  801a74:	83 c4 10             	add    $0x10,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	e8 3e 02 00 00       	call   801ccb <nsipc_socket>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 05                	js     801a99 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a94:	e8 ab fe ff ff       	call   801944 <alloc_sockfd>
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	53                   	push   %ebx
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aa4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aab:	74 26                	je     801ad3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aad:	6a 07                	push   $0x7
  801aaf:	68 00 60 80 00       	push   $0x806000
  801ab4:	53                   	push   %ebx
  801ab5:	ff 35 04 40 80 00    	pushl  0x804004
  801abb:	e8 c2 07 00 00       	call   802282 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac0:	83 c4 0c             	add    $0xc,%esp
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	e8 4b 07 00 00       	call   802219 <ipc_recv>
}
  801ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	6a 02                	push   $0x2
  801ad8:	e8 fd 07 00 00       	call   8022da <ipc_find_env>
  801add:	a3 04 40 80 00       	mov    %eax,0x804004
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	eb c6                	jmp    801aad <nsipc+0x12>

00801ae7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af7:	8b 06                	mov    (%esi),%eax
  801af9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801afe:	b8 01 00 00 00       	mov    $0x1,%eax
  801b03:	e8 93 ff ff ff       	call   801a9b <nsipc>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	79 09                	jns    801b17 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b0e:	89 d8                	mov    %ebx,%eax
  801b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5d                   	pop    %ebp
  801b16:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	ff 35 10 60 80 00    	pushl  0x806010
  801b20:	68 00 60 80 00       	push   $0x806000
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	e8 fc ef ff ff       	call   800b29 <memmove>
		*addrlen = ret->ret_addrlen;
  801b2d:	a1 10 60 80 00       	mov    0x806010,%eax
  801b32:	89 06                	mov    %eax,(%esi)
  801b34:	83 c4 10             	add    $0x10,%esp
	return r;
  801b37:	eb d5                	jmp    801b0e <nsipc_accept+0x27>

00801b39 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	53                   	push   %ebx
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b4b:	53                   	push   %ebx
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	68 04 60 80 00       	push   $0x806004
  801b54:	e8 d0 ef ff ff       	call   800b29 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b59:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b5f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b64:	e8 32 ff ff ff       	call   801a9b <nsipc>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b84:	b8 03 00 00 00       	mov    $0x3,%eax
  801b89:	e8 0d ff ff ff       	call   801a9b <nsipc>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <nsipc_close>:

int
nsipc_close(int s)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b9e:	b8 04 00 00 00       	mov    $0x4,%eax
  801ba3:	e8 f3 fe ff ff       	call   801a9b <nsipc>
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	53                   	push   %ebx
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bbc:	53                   	push   %ebx
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	68 04 60 80 00       	push   $0x806004
  801bc5:	e8 5f ef ff ff       	call   800b29 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bca:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bd0:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd5:	e8 c1 fe ff ff       	call   801a9b <nsipc>
}
  801bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bf5:	b8 06 00 00 00       	mov    $0x6,%eax
  801bfa:	e8 9c fe ff ff       	call   801a9b <nsipc>
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	56                   	push   %esi
  801c05:	53                   	push   %ebx
  801c06:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c11:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c1f:	b8 07 00 00 00       	mov    $0x7,%eax
  801c24:	e8 72 fe ff ff       	call   801a9b <nsipc>
  801c29:	89 c3                	mov    %eax,%ebx
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 1f                	js     801c4e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c2f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c34:	7f 21                	jg     801c57 <nsipc_recv+0x56>
  801c36:	39 c6                	cmp    %eax,%esi
  801c38:	7c 1d                	jl     801c57 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	50                   	push   %eax
  801c3e:	68 00 60 80 00       	push   $0x806000
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	e8 de ee ff ff       	call   800b29 <memmove>
  801c4b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c4e:	89 d8                	mov    %ebx,%eax
  801c50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c57:	68 03 2b 80 00       	push   $0x802b03
  801c5c:	68 cb 2a 80 00       	push   $0x802acb
  801c61:	6a 62                	push   $0x62
  801c63:	68 18 2b 80 00       	push   $0x802b18
  801c68:	e8 4b 05 00 00       	call   8021b8 <_panic>

00801c6d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c7f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c85:	7f 2e                	jg     801cb5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	53                   	push   %ebx
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	68 0c 60 80 00       	push   $0x80600c
  801c93:	e8 91 ee ff ff       	call   800b29 <memmove>
	nsipcbuf.send.req_size = size;
  801c98:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ca6:	b8 08 00 00 00       	mov    $0x8,%eax
  801cab:	e8 eb fd ff ff       	call   801a9b <nsipc>
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    
	assert(size < 1600);
  801cb5:	68 24 2b 80 00       	push   $0x802b24
  801cba:	68 cb 2a 80 00       	push   $0x802acb
  801cbf:	6a 6d                	push   $0x6d
  801cc1:	68 18 2b 80 00       	push   $0x802b18
  801cc6:	e8 ed 04 00 00       	call   8021b8 <_panic>

00801ccb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdc:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ce9:	b8 09 00 00 00       	mov    $0x9,%eax
  801cee:	e8 a8 fd ff ff       	call   801a9b <nsipc>
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	56                   	push   %esi
  801cf9:	53                   	push   %ebx
  801cfa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	e8 6a f3 ff ff       	call   801072 <fd2data>
  801d08:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d0a:	83 c4 08             	add    $0x8,%esp
  801d0d:	68 30 2b 80 00       	push   $0x802b30
  801d12:	53                   	push   %ebx
  801d13:	e8 83 ec ff ff       	call   80099b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d18:	8b 46 04             	mov    0x4(%esi),%eax
  801d1b:	2b 06                	sub    (%esi),%eax
  801d1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d2a:	00 00 00 
	stat->st_dev = &devpipe;
  801d2d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d34:	30 80 00 
	return 0;
}
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    

00801d43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	53                   	push   %ebx
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d4d:	53                   	push   %ebx
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 bd f0 ff ff       	call   800e12 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d55:	89 1c 24             	mov    %ebx,(%esp)
  801d58:	e8 15 f3 ff ff       	call   801072 <fd2data>
  801d5d:	83 c4 08             	add    $0x8,%esp
  801d60:	50                   	push   %eax
  801d61:	6a 00                	push   $0x0
  801d63:	e8 aa f0 ff ff       	call   800e12 <sys_page_unmap>
}
  801d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <_pipeisclosed>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	57                   	push   %edi
  801d71:	56                   	push   %esi
  801d72:	53                   	push   %ebx
  801d73:	83 ec 1c             	sub    $0x1c,%esp
  801d76:	89 c7                	mov    %eax,%edi
  801d78:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d7a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d7f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	57                   	push   %edi
  801d86:	e8 8a 05 00 00       	call   802315 <pageref>
  801d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8e:	89 34 24             	mov    %esi,(%esp)
  801d91:	e8 7f 05 00 00       	call   802315 <pageref>
		nn = thisenv->env_runs;
  801d96:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d9c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	39 cb                	cmp    %ecx,%ebx
  801da4:	74 1b                	je     801dc1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da9:	75 cf                	jne    801d7a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dab:	8b 42 58             	mov    0x58(%edx),%eax
  801dae:	6a 01                	push   $0x1
  801db0:	50                   	push   %eax
  801db1:	53                   	push   %ebx
  801db2:	68 37 2b 80 00       	push   $0x802b37
  801db7:	e8 80 e4 ff ff       	call   80023c <cprintf>
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	eb b9                	jmp    801d7a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dc1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc4:	0f 94 c0             	sete   %al
  801dc7:	0f b6 c0             	movzbl %al,%eax
}
  801dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5f                   	pop    %edi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <devpipe_write>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 28             	sub    $0x28,%esp
  801ddb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dde:	56                   	push   %esi
  801ddf:	e8 8e f2 ff ff       	call   801072 <fd2data>
  801de4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801df1:	74 4f                	je     801e42 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801df3:	8b 43 04             	mov    0x4(%ebx),%eax
  801df6:	8b 0b                	mov    (%ebx),%ecx
  801df8:	8d 51 20             	lea    0x20(%ecx),%edx
  801dfb:	39 d0                	cmp    %edx,%eax
  801dfd:	72 14                	jb     801e13 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dff:	89 da                	mov    %ebx,%edx
  801e01:	89 f0                	mov    %esi,%eax
  801e03:	e8 65 ff ff ff       	call   801d6d <_pipeisclosed>
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	75 3b                	jne    801e47 <devpipe_write+0x75>
			sys_yield();
  801e0c:	e8 5d ef ff ff       	call   800d6e <sys_yield>
  801e11:	eb e0                	jmp    801df3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e16:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e1a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e1d:	89 c2                	mov    %eax,%edx
  801e1f:	c1 fa 1f             	sar    $0x1f,%edx
  801e22:	89 d1                	mov    %edx,%ecx
  801e24:	c1 e9 1b             	shr    $0x1b,%ecx
  801e27:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e2a:	83 e2 1f             	and    $0x1f,%edx
  801e2d:	29 ca                	sub    %ecx,%edx
  801e2f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e33:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e37:	83 c0 01             	add    $0x1,%eax
  801e3a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e3d:	83 c7 01             	add    $0x1,%edi
  801e40:	eb ac                	jmp    801dee <devpipe_write+0x1c>
	return i;
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	eb 05                	jmp    801e4c <devpipe_write+0x7a>
				return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <devpipe_read>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	57                   	push   %edi
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 18             	sub    $0x18,%esp
  801e5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e60:	57                   	push   %edi
  801e61:	e8 0c f2 ff ff       	call   801072 <fd2data>
  801e66:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	be 00 00 00 00       	mov    $0x0,%esi
  801e70:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e73:	75 14                	jne    801e89 <devpipe_read+0x35>
	return i;
  801e75:	8b 45 10             	mov    0x10(%ebp),%eax
  801e78:	eb 02                	jmp    801e7c <devpipe_read+0x28>
				return i;
  801e7a:	89 f0                	mov    %esi,%eax
}
  801e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    
			sys_yield();
  801e84:	e8 e5 ee ff ff       	call   800d6e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e89:	8b 03                	mov    (%ebx),%eax
  801e8b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e8e:	75 18                	jne    801ea8 <devpipe_read+0x54>
			if (i > 0)
  801e90:	85 f6                	test   %esi,%esi
  801e92:	75 e6                	jne    801e7a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e94:	89 da                	mov    %ebx,%edx
  801e96:	89 f8                	mov    %edi,%eax
  801e98:	e8 d0 fe ff ff       	call   801d6d <_pipeisclosed>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	74 e3                	je     801e84 <devpipe_read+0x30>
				return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	eb d4                	jmp    801e7c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ea8:	99                   	cltd   
  801ea9:	c1 ea 1b             	shr    $0x1b,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	83 e0 1f             	and    $0x1f,%eax
  801eb1:	29 d0                	sub    %edx,%eax
  801eb3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ebb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ebe:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ec1:	83 c6 01             	add    $0x1,%esi
  801ec4:	eb aa                	jmp    801e70 <devpipe_read+0x1c>

00801ec6 <pipe>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ece:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed1:	50                   	push   %eax
  801ed2:	e8 b2 f1 ff ff       	call   801089 <fd_alloc>
  801ed7:	89 c3                	mov    %eax,%ebx
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	85 c0                	test   %eax,%eax
  801ede:	0f 88 23 01 00 00    	js     802007 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	68 07 04 00 00       	push   $0x407
  801eec:	ff 75 f4             	pushl  -0xc(%ebp)
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 97 ee ff ff       	call   800d8d <sys_page_alloc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	0f 88 04 01 00 00    	js     802007 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f09:	50                   	push   %eax
  801f0a:	e8 7a f1 ff ff       	call   801089 <fd_alloc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	0f 88 db 00 00 00    	js     801ff7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 5f ee ff ff       	call   800d8d <sys_page_alloc>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	0f 88 bc 00 00 00    	js     801ff7 <pipe+0x131>
	va = fd2data(fd0);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	e8 2c f1 ff ff       	call   801072 <fd2data>
  801f46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f48:	83 c4 0c             	add    $0xc,%esp
  801f4b:	68 07 04 00 00       	push   $0x407
  801f50:	50                   	push   %eax
  801f51:	6a 00                	push   $0x0
  801f53:	e8 35 ee ff ff       	call   800d8d <sys_page_alloc>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	0f 88 82 00 00 00    	js     801fe7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6b:	e8 02 f1 ff ff       	call   801072 <fd2data>
  801f70:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f77:	50                   	push   %eax
  801f78:	6a 00                	push   $0x0
  801f7a:	56                   	push   %esi
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 4e ee ff ff       	call   800dd0 <sys_page_map>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	83 c4 20             	add    $0x20,%esp
  801f87:	85 c0                	test   %eax,%eax
  801f89:	78 4e                	js     801fd9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f8b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f93:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f98:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	e8 a9 f0 ff ff       	call   801062 <fd2num>
  801fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fbe:	83 c4 04             	add    $0x4,%esp
  801fc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc4:	e8 99 f0 ff ff       	call   801062 <fd2num>
  801fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd7:	eb 2e                	jmp    802007 <pipe+0x141>
	sys_page_unmap(0, va);
  801fd9:	83 ec 08             	sub    $0x8,%esp
  801fdc:	56                   	push   %esi
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 2e ee ff ff       	call   800e12 <sys_page_unmap>
  801fe4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	ff 75 f0             	pushl  -0x10(%ebp)
  801fed:	6a 00                	push   $0x0
  801fef:	e8 1e ee ff ff       	call   800e12 <sys_page_unmap>
  801ff4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ff7:	83 ec 08             	sub    $0x8,%esp
  801ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffd:	6a 00                	push   $0x0
  801fff:	e8 0e ee ff ff       	call   800e12 <sys_page_unmap>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	89 d8                	mov    %ebx,%eax
  802009:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    

00802010 <pipeisclosed>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802016:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	e8 b9 f0 ff ff       	call   8010db <fd_lookup>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	78 18                	js     802041 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	ff 75 f4             	pushl  -0xc(%ebp)
  80202f:	e8 3e f0 ff ff       	call   801072 <fd2data>
	return _pipeisclosed(fd, p);
  802034:	89 c2                	mov    %eax,%edx
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	e8 2f fd ff ff       	call   801d6d <_pipeisclosed>
  80203e:	83 c4 10             	add    $0x10,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
  802048:	c3                   	ret    

00802049 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80204f:	68 4f 2b 80 00       	push   $0x802b4f
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	e8 3f e9 ff ff       	call   80099b <strcpy>
	return 0;
}
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <devcons_write>:
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	57                   	push   %edi
  802067:	56                   	push   %esi
  802068:	53                   	push   %ebx
  802069:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80206f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802074:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80207a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80207d:	73 31                	jae    8020b0 <devcons_write+0x4d>
		m = n - tot;
  80207f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802082:	29 f3                	sub    %esi,%ebx
  802084:	83 fb 7f             	cmp    $0x7f,%ebx
  802087:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80208c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	53                   	push   %ebx
  802093:	89 f0                	mov    %esi,%eax
  802095:	03 45 0c             	add    0xc(%ebp),%eax
  802098:	50                   	push   %eax
  802099:	57                   	push   %edi
  80209a:	e8 8a ea ff ff       	call   800b29 <memmove>
		sys_cputs(buf, m);
  80209f:	83 c4 08             	add    $0x8,%esp
  8020a2:	53                   	push   %ebx
  8020a3:	57                   	push   %edi
  8020a4:	e8 28 ec ff ff       	call   800cd1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a9:	01 de                	add    %ebx,%esi
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	eb ca                	jmp    80207a <devcons_write+0x17>
}
  8020b0:	89 f0                	mov    %esi,%eax
  8020b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5e                   	pop    %esi
  8020b7:	5f                   	pop    %edi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <devcons_read>:
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c9:	74 21                	je     8020ec <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020cb:	e8 1f ec ff ff       	call   800cef <sys_cgetc>
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	75 07                	jne    8020db <devcons_read+0x21>
		sys_yield();
  8020d4:	e8 95 ec ff ff       	call   800d6e <sys_yield>
  8020d9:	eb f0                	jmp    8020cb <devcons_read+0x11>
	if (c < 0)
  8020db:	78 0f                	js     8020ec <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020dd:	83 f8 04             	cmp    $0x4,%eax
  8020e0:	74 0c                	je     8020ee <devcons_read+0x34>
	*(char*)vbuf = c;
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	88 02                	mov    %al,(%edx)
	return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	eb f7                	jmp    8020ec <devcons_read+0x32>

008020f5 <cputchar>:
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802101:	6a 01                	push   $0x1
  802103:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802106:	50                   	push   %eax
  802107:	e8 c5 eb ff ff       	call   800cd1 <sys_cputs>
}
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <getchar>:
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802117:	6a 01                	push   $0x1
  802119:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211c:	50                   	push   %eax
  80211d:	6a 00                	push   $0x0
  80211f:	e8 27 f2 ff ff       	call   80134b <read>
	if (r < 0)
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 06                	js     802131 <getchar+0x20>
	if (r < 1)
  80212b:	74 06                	je     802133 <getchar+0x22>
	return c;
  80212d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    
		return -E_EOF;
  802133:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802138:	eb f7                	jmp    802131 <getchar+0x20>

0080213a <iscons>:
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802143:	50                   	push   %eax
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	e8 8f ef ff ff       	call   8010db <fd_lookup>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 11                	js     802164 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215c:	39 10                	cmp    %edx,(%eax)
  80215e:	0f 94 c0             	sete   %al
  802161:	0f b6 c0             	movzbl %al,%eax
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <opencons>:
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80216c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216f:	50                   	push   %eax
  802170:	e8 14 ef ff ff       	call   801089 <fd_alloc>
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 3a                	js     8021b6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	68 07 04 00 00       	push   $0x407
  802184:	ff 75 f4             	pushl  -0xc(%ebp)
  802187:	6a 00                	push   $0x0
  802189:	e8 ff eb ff ff       	call   800d8d <sys_page_alloc>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 21                	js     8021b6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80219e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	50                   	push   %eax
  8021ae:	e8 af ee ff ff       	call   801062 <fd2num>
  8021b3:	83 c4 10             	add    $0x10,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	56                   	push   %esi
  8021bc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021bd:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c2:	8b 40 48             	mov    0x48(%eax),%eax
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	68 80 2b 80 00       	push   $0x802b80
  8021cd:	50                   	push   %eax
  8021ce:	68 63 26 80 00       	push   $0x802663
  8021d3:	e8 64 e0 ff ff       	call   80023c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021d8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021db:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021e1:	e8 69 eb ff ff       	call   800d4f <sys_getenvid>
  8021e6:	83 c4 04             	add    $0x4,%esp
  8021e9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ec:	ff 75 08             	pushl  0x8(%ebp)
  8021ef:	56                   	push   %esi
  8021f0:	50                   	push   %eax
  8021f1:	68 5c 2b 80 00       	push   $0x802b5c
  8021f6:	e8 41 e0 ff ff       	call   80023c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021fb:	83 c4 18             	add    $0x18,%esp
  8021fe:	53                   	push   %ebx
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	e8 e4 df ff ff       	call   8001eb <vcprintf>
	cprintf("\n");
  802207:	c7 04 24 27 26 80 00 	movl   $0x802627,(%esp)
  80220e:	e8 29 e0 ff ff       	call   80023c <cprintf>
  802213:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802216:	cc                   	int3   
  802217:	eb fd                	jmp    802216 <_panic+0x5e>

00802219 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	56                   	push   %esi
  80221d:	53                   	push   %ebx
  80221e:	8b 75 08             	mov    0x8(%ebp),%esi
  802221:	8b 45 0c             	mov    0xc(%ebp),%eax
  802224:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802227:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802229:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80222e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	50                   	push   %eax
  802235:	e8 03 ed ff ff       	call   800f3d <sys_ipc_recv>
	if(ret < 0){
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 2b                	js     80226c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802241:	85 f6                	test   %esi,%esi
  802243:	74 0a                	je     80224f <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802245:	a1 08 40 80 00       	mov    0x804008,%eax
  80224a:	8b 40 74             	mov    0x74(%eax),%eax
  80224d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80224f:	85 db                	test   %ebx,%ebx
  802251:	74 0a                	je     80225d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802253:	a1 08 40 80 00       	mov    0x804008,%eax
  802258:	8b 40 78             	mov    0x78(%eax),%eax
  80225b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80225d:	a1 08 40 80 00       	mov    0x804008,%eax
  802262:	8b 40 70             	mov    0x70(%eax),%eax
}
  802265:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802268:	5b                   	pop    %ebx
  802269:	5e                   	pop    %esi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
		if(from_env_store)
  80226c:	85 f6                	test   %esi,%esi
  80226e:	74 06                	je     802276 <ipc_recv+0x5d>
			*from_env_store = 0;
  802270:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802276:	85 db                	test   %ebx,%ebx
  802278:	74 eb                	je     802265 <ipc_recv+0x4c>
			*perm_store = 0;
  80227a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802280:	eb e3                	jmp    802265 <ipc_recv+0x4c>

00802282 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 0c             	sub    $0xc,%esp
  80228b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80228e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802291:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802294:	85 db                	test   %ebx,%ebx
  802296:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80229b:	0f 44 d8             	cmove  %eax,%ebx
  80229e:	eb 05                	jmp    8022a5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022a0:	e8 c9 ea ff ff       	call   800d6e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022a5:	ff 75 14             	pushl  0x14(%ebp)
  8022a8:	53                   	push   %ebx
  8022a9:	56                   	push   %esi
  8022aa:	57                   	push   %edi
  8022ab:	e8 6a ec ff ff       	call   800f1a <sys_ipc_try_send>
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 1b                	je     8022d2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022b7:	79 e7                	jns    8022a0 <ipc_send+0x1e>
  8022b9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022bc:	74 e2                	je     8022a0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	68 87 2b 80 00       	push   $0x802b87
  8022c6:	6a 4a                	push   $0x4a
  8022c8:	68 9c 2b 80 00       	push   $0x802b9c
  8022cd:	e8 e6 fe ff ff       	call   8021b8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5f                   	pop    %edi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    

008022da <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022e5:	89 c2                	mov    %eax,%edx
  8022e7:	c1 e2 07             	shl    $0x7,%edx
  8022ea:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022f0:	8b 52 50             	mov    0x50(%edx),%edx
  8022f3:	39 ca                	cmp    %ecx,%edx
  8022f5:	74 11                	je     802308 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022f7:	83 c0 01             	add    $0x1,%eax
  8022fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ff:	75 e4                	jne    8022e5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
  802306:	eb 0b                	jmp    802313 <ipc_find_env+0x39>
			return envs[i].env_id;
  802308:	c1 e0 07             	shl    $0x7,%eax
  80230b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802310:	8b 40 48             	mov    0x48(%eax),%eax
}
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    

00802315 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	c1 e8 16             	shr    $0x16,%eax
  802320:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80232c:	f6 c1 01             	test   $0x1,%cl
  80232f:	74 1d                	je     80234e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802331:	c1 ea 0c             	shr    $0xc,%edx
  802334:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80233b:	f6 c2 01             	test   $0x1,%dl
  80233e:	74 0e                	je     80234e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802340:	c1 ea 0c             	shr    $0xc,%edx
  802343:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80234a:	ef 
  80234b:	0f b7 c0             	movzwl %ax,%eax
}
  80234e:	5d                   	pop    %ebp
  80234f:	c3                   	ret    

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80235f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802367:	85 d2                	test   %edx,%edx
  802369:	75 4d                	jne    8023b8 <__udivdi3+0x68>
  80236b:	39 f3                	cmp    %esi,%ebx
  80236d:	76 19                	jbe    802388 <__udivdi3+0x38>
  80236f:	31 ff                	xor    %edi,%edi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 a9                	ja     802377 <__udivdi3+0x27>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a2                	jmp    802377 <__udivdi3+0x27>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 27 ff ff ff       	jmp    802377 <__udivdi3+0x27>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 1d ff ff ff       	jmp    802377 <__udivdi3+0x27>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802477:	89 da                	mov    %ebx,%edx
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 43                	jne    8024c0 <__umoddi3+0x60>
  80247d:	39 df                	cmp    %ebx,%edi
  80247f:	76 17                	jbe    802498 <__umoddi3+0x38>
  802481:	89 f0                	mov    %esi,%eax
  802483:	f7 f7                	div    %edi
  802485:	89 d0                	mov    %edx,%eax
  802487:	31 d2                	xor    %edx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d0                	jmp    802487 <__umoddi3+0x27>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
