
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
  800043:	68 c0 25 80 00       	push   $0x8025c0
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
  800067:	68 e0 25 80 00       	push   $0x8025e0
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
  800088:	68 0c 26 80 00       	push   $0x80260c
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
  80011d:	68 2b 26 80 00       	push   $0x80262b
  800122:	e8 15 01 00 00       	call   80023c <cprintf>
	cprintf("before umain\n");
  800127:	c7 04 24 49 26 80 00 	movl   $0x802649,(%esp)
  80012e:	e8 09 01 00 00       	call   80023c <cprintf>
	// call user main routine
	umain(argc, argv);
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	ff 75 0c             	pushl  0xc(%ebp)
  800139:	ff 75 08             	pushl  0x8(%ebp)
  80013c:	e8 f2 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800141:	c7 04 24 57 26 80 00 	movl   $0x802657,(%esp)
  800148:	e8 ef 00 00 00       	call   80023c <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80014d:	a1 08 40 80 00       	mov    0x804008,%eax
  800152:	8b 40 48             	mov    0x48(%eax),%eax
  800155:	83 c4 08             	add    $0x8,%esp
  800158:	50                   	push   %eax
  800159:	68 64 26 80 00       	push   $0x802664
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
  800181:	68 90 26 80 00       	push   $0x802690
  800186:	50                   	push   %eax
  800187:	68 83 26 80 00       	push   $0x802683
  80018c:	e8 ab 00 00 00       	call   80023c <cprintf>
	close_all();
  800191:	e8 c4 10 00 00       	call   80125a <close_all>
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
  8002e9:	e8 82 20 00 00       	call   802370 <__udivdi3>
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
  800312:	e8 69 21 00 00       	call   802480 <__umoddi3>
  800317:	83 c4 14             	add    $0x14,%esp
  80031a:	0f be 80 95 26 80 00 	movsbl 0x802695(%eax),%eax
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
  8003c3:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
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
  80048e:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  800495:	85 d2                	test   %edx,%edx
  800497:	74 18                	je     8004b1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800499:	52                   	push   %edx
  80049a:	68 fd 2a 80 00       	push   $0x802afd
  80049f:	53                   	push   %ebx
  8004a0:	56                   	push   %esi
  8004a1:	e8 a6 fe ff ff       	call   80034c <printfmt>
  8004a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ac:	e9 fe 02 00 00       	jmp    8007af <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b1:	50                   	push   %eax
  8004b2:	68 ad 26 80 00       	push   $0x8026ad
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
  8004d9:	b8 a6 26 80 00       	mov    $0x8026a6,%eax
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
  800871:	bf c9 27 80 00       	mov    $0x8027c9,%edi
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
  80089d:	bf 01 28 80 00       	mov    $0x802801,%edi
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
  800d3e:	68 28 2a 80 00       	push   $0x802a28
  800d43:	6a 43                	push   $0x43
  800d45:	68 45 2a 80 00       	push   $0x802a45
  800d4a:	e8 89 14 00 00       	call   8021d8 <_panic>

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
  800dbf:	68 28 2a 80 00       	push   $0x802a28
  800dc4:	6a 43                	push   $0x43
  800dc6:	68 45 2a 80 00       	push   $0x802a45
  800dcb:	e8 08 14 00 00       	call   8021d8 <_panic>

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
  800e01:	68 28 2a 80 00       	push   $0x802a28
  800e06:	6a 43                	push   $0x43
  800e08:	68 45 2a 80 00       	push   $0x802a45
  800e0d:	e8 c6 13 00 00       	call   8021d8 <_panic>

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
  800e43:	68 28 2a 80 00       	push   $0x802a28
  800e48:	6a 43                	push   $0x43
  800e4a:	68 45 2a 80 00       	push   $0x802a45
  800e4f:	e8 84 13 00 00       	call   8021d8 <_panic>

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
  800e85:	68 28 2a 80 00       	push   $0x802a28
  800e8a:	6a 43                	push   $0x43
  800e8c:	68 45 2a 80 00       	push   $0x802a45
  800e91:	e8 42 13 00 00       	call   8021d8 <_panic>

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
  800ec7:	68 28 2a 80 00       	push   $0x802a28
  800ecc:	6a 43                	push   $0x43
  800ece:	68 45 2a 80 00       	push   $0x802a45
  800ed3:	e8 00 13 00 00       	call   8021d8 <_panic>

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
  800f09:	68 28 2a 80 00       	push   $0x802a28
  800f0e:	6a 43                	push   $0x43
  800f10:	68 45 2a 80 00       	push   $0x802a45
  800f15:	e8 be 12 00 00       	call   8021d8 <_panic>

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
  800f6d:	68 28 2a 80 00       	push   $0x802a28
  800f72:	6a 43                	push   $0x43
  800f74:	68 45 2a 80 00       	push   $0x802a45
  800f79:	e8 5a 12 00 00       	call   8021d8 <_panic>

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
  801051:	68 28 2a 80 00       	push   $0x802a28
  801056:	6a 43                	push   $0x43
  801058:	68 45 2a 80 00       	push   $0x802a45
  80105d:	e8 76 11 00 00       	call   8021d8 <_panic>

00801062 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
	asm volatile("int %1\n"
  801068:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	b8 14 00 00 00       	mov    $0x14,%eax
  801075:	89 cb                	mov    %ecx,%ebx
  801077:	89 cf                	mov    %ecx,%edi
  801079:	89 ce                	mov    %ecx,%esi
  80107b:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	05 00 00 00 30       	add    $0x30000000,%eax
  80108d:	c1 e8 0c             	shr    $0xc,%eax
}
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80109d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	c1 ea 16             	shr    $0x16,%edx
  8010b6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010bd:	f6 c2 01             	test   $0x1,%dl
  8010c0:	74 2d                	je     8010ef <fd_alloc+0x46>
  8010c2:	89 c2                	mov    %eax,%edx
  8010c4:	c1 ea 0c             	shr    $0xc,%edx
  8010c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ce:	f6 c2 01             	test   $0x1,%dl
  8010d1:	74 1c                	je     8010ef <fd_alloc+0x46>
  8010d3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010d8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010dd:	75 d2                	jne    8010b1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010e8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ed:	eb 0a                	jmp    8010f9 <fd_alloc+0x50>
			*fd_store = fd;
  8010ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801101:	83 f8 1f             	cmp    $0x1f,%eax
  801104:	77 30                	ja     801136 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801106:	c1 e0 0c             	shl    $0xc,%eax
  801109:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80110e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801114:	f6 c2 01             	test   $0x1,%dl
  801117:	74 24                	je     80113d <fd_lookup+0x42>
  801119:	89 c2                	mov    %eax,%edx
  80111b:	c1 ea 0c             	shr    $0xc,%edx
  80111e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801125:	f6 c2 01             	test   $0x1,%dl
  801128:	74 1a                	je     801144 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	89 02                	mov    %eax,(%edx)
	return 0;
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		return -E_INVAL;
  801136:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113b:	eb f7                	jmp    801134 <fd_lookup+0x39>
		return -E_INVAL;
  80113d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801142:	eb f0                	jmp    801134 <fd_lookup+0x39>
  801144:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801149:	eb e9                	jmp    801134 <fd_lookup+0x39>

0080114b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801154:	ba 00 00 00 00       	mov    $0x0,%edx
  801159:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80115e:	39 08                	cmp    %ecx,(%eax)
  801160:	74 38                	je     80119a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801162:	83 c2 01             	add    $0x1,%edx
  801165:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  80116c:	85 c0                	test   %eax,%eax
  80116e:	75 ee                	jne    80115e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801170:	a1 08 40 80 00       	mov    0x804008,%eax
  801175:	8b 40 48             	mov    0x48(%eax),%eax
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	51                   	push   %ecx
  80117c:	50                   	push   %eax
  80117d:	68 54 2a 80 00       	push   $0x802a54
  801182:	e8 b5 f0 ff ff       	call   80023c <cprintf>
	*dev = 0;
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    
			*dev = devtab[i];
  80119a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80119f:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a4:	eb f2                	jmp    801198 <dev_lookup+0x4d>

008011a6 <fd_close>:
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 24             	sub    $0x24,%esp
  8011af:	8b 75 08             	mov    0x8(%ebp),%esi
  8011b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011bf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c2:	50                   	push   %eax
  8011c3:	e8 33 ff ff ff       	call   8010fb <fd_lookup>
  8011c8:	89 c3                	mov    %eax,%ebx
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 05                	js     8011d6 <fd_close+0x30>
	    || fd != fd2)
  8011d1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011d4:	74 16                	je     8011ec <fd_close+0x46>
		return (must_exist ? r : 0);
  8011d6:	89 f8                	mov    %edi,%eax
  8011d8:	84 c0                	test   %al,%al
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
  8011df:	0f 44 d8             	cmove  %eax,%ebx
}
  8011e2:	89 d8                	mov    %ebx,%eax
  8011e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e7:	5b                   	pop    %ebx
  8011e8:	5e                   	pop    %esi
  8011e9:	5f                   	pop    %edi
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	ff 36                	pushl  (%esi)
  8011f5:	e8 51 ff ff ff       	call   80114b <dev_lookup>
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 1a                	js     80121d <fd_close+0x77>
		if (dev->dev_close)
  801203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801206:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801209:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80120e:	85 c0                	test   %eax,%eax
  801210:	74 0b                	je     80121d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	56                   	push   %esi
  801216:	ff d0                	call   *%eax
  801218:	89 c3                	mov    %eax,%ebx
  80121a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	56                   	push   %esi
  801221:	6a 00                	push   $0x0
  801223:	e8 ea fb ff ff       	call   800e12 <sys_page_unmap>
	return r;
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	eb b5                	jmp    8011e2 <fd_close+0x3c>

0080122d <close>:

int
close(int fdnum)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801233:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	ff 75 08             	pushl  0x8(%ebp)
  80123a:	e8 bc fe ff ff       	call   8010fb <fd_lookup>
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	79 02                	jns    801248 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801246:	c9                   	leave  
  801247:	c3                   	ret    
		return fd_close(fd, 1);
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	6a 01                	push   $0x1
  80124d:	ff 75 f4             	pushl  -0xc(%ebp)
  801250:	e8 51 ff ff ff       	call   8011a6 <fd_close>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	eb ec                	jmp    801246 <close+0x19>

0080125a <close_all>:

void
close_all(void)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801261:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	53                   	push   %ebx
  80126a:	e8 be ff ff ff       	call   80122d <close>
	for (i = 0; i < MAXFD; i++)
  80126f:	83 c3 01             	add    $0x1,%ebx
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	83 fb 20             	cmp    $0x20,%ebx
  801278:	75 ec                	jne    801266 <close_all+0xc>
}
  80127a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801288:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128b:	50                   	push   %eax
  80128c:	ff 75 08             	pushl  0x8(%ebp)
  80128f:	e8 67 fe ff ff       	call   8010fb <fd_lookup>
  801294:	89 c3                	mov    %eax,%ebx
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	0f 88 81 00 00 00    	js     801322 <dup+0xa3>
		return r;
	close(newfdnum);
  8012a1:	83 ec 0c             	sub    $0xc,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	e8 81 ff ff ff       	call   80122d <close>

	newfd = INDEX2FD(newfdnum);
  8012ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012af:	c1 e6 0c             	shl    $0xc,%esi
  8012b2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012b8:	83 c4 04             	add    $0x4,%esp
  8012bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012be:	e8 cf fd ff ff       	call   801092 <fd2data>
  8012c3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012c5:	89 34 24             	mov    %esi,(%esp)
  8012c8:	e8 c5 fd ff ff       	call   801092 <fd2data>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012d2:	89 d8                	mov    %ebx,%eax
  8012d4:	c1 e8 16             	shr    $0x16,%eax
  8012d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012de:	a8 01                	test   $0x1,%al
  8012e0:	74 11                	je     8012f3 <dup+0x74>
  8012e2:	89 d8                	mov    %ebx,%eax
  8012e4:	c1 e8 0c             	shr    $0xc,%eax
  8012e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ee:	f6 c2 01             	test   $0x1,%dl
  8012f1:	75 39                	jne    80132c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f6:	89 d0                	mov    %edx,%eax
  8012f8:	c1 e8 0c             	shr    $0xc,%eax
  8012fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801302:	83 ec 0c             	sub    $0xc,%esp
  801305:	25 07 0e 00 00       	and    $0xe07,%eax
  80130a:	50                   	push   %eax
  80130b:	56                   	push   %esi
  80130c:	6a 00                	push   $0x0
  80130e:	52                   	push   %edx
  80130f:	6a 00                	push   $0x0
  801311:	e8 ba fa ff ff       	call   800dd0 <sys_page_map>
  801316:	89 c3                	mov    %eax,%ebx
  801318:	83 c4 20             	add    $0x20,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 31                	js     801350 <dup+0xd1>
		goto err;

	return newfdnum;
  80131f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801322:	89 d8                	mov    %ebx,%eax
  801324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5f                   	pop    %edi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80132c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	25 07 0e 00 00       	and    $0xe07,%eax
  80133b:	50                   	push   %eax
  80133c:	57                   	push   %edi
  80133d:	6a 00                	push   $0x0
  80133f:	53                   	push   %ebx
  801340:	6a 00                	push   $0x0
  801342:	e8 89 fa ff ff       	call   800dd0 <sys_page_map>
  801347:	89 c3                	mov    %eax,%ebx
  801349:	83 c4 20             	add    $0x20,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	79 a3                	jns    8012f3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801350:	83 ec 08             	sub    $0x8,%esp
  801353:	56                   	push   %esi
  801354:	6a 00                	push   $0x0
  801356:	e8 b7 fa ff ff       	call   800e12 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80135b:	83 c4 08             	add    $0x8,%esp
  80135e:	57                   	push   %edi
  80135f:	6a 00                	push   $0x0
  801361:	e8 ac fa ff ff       	call   800e12 <sys_page_unmap>
	return r;
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	eb b7                	jmp    801322 <dup+0xa3>

0080136b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	53                   	push   %ebx
  80136f:	83 ec 1c             	sub    $0x1c,%esp
  801372:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801375:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	53                   	push   %ebx
  80137a:	e8 7c fd ff ff       	call   8010fb <fd_lookup>
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 3f                	js     8013c5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138c:	50                   	push   %eax
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	ff 30                	pushl  (%eax)
  801392:	e8 b4 fd ff ff       	call   80114b <dev_lookup>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 27                	js     8013c5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80139e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a1:	8b 42 08             	mov    0x8(%edx),%eax
  8013a4:	83 e0 03             	and    $0x3,%eax
  8013a7:	83 f8 01             	cmp    $0x1,%eax
  8013aa:	74 1e                	je     8013ca <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013af:	8b 40 08             	mov    0x8(%eax),%eax
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	74 35                	je     8013eb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	ff 75 10             	pushl  0x10(%ebp)
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	52                   	push   %edx
  8013c0:	ff d0                	call   *%eax
  8013c2:	83 c4 10             	add    $0x10,%esp
}
  8013c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8013cf:	8b 40 48             	mov    0x48(%eax),%eax
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	53                   	push   %ebx
  8013d6:	50                   	push   %eax
  8013d7:	68 95 2a 80 00       	push   $0x802a95
  8013dc:	e8 5b ee ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e9:	eb da                	jmp    8013c5 <read+0x5a>
		return -E_NOT_SUPP;
  8013eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f0:	eb d3                	jmp    8013c5 <read+0x5a>

008013f2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	57                   	push   %edi
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013fe:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801401:	bb 00 00 00 00       	mov    $0x0,%ebx
  801406:	39 f3                	cmp    %esi,%ebx
  801408:	73 23                	jae    80142d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	89 f0                	mov    %esi,%eax
  80140f:	29 d8                	sub    %ebx,%eax
  801411:	50                   	push   %eax
  801412:	89 d8                	mov    %ebx,%eax
  801414:	03 45 0c             	add    0xc(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	57                   	push   %edi
  801419:	e8 4d ff ff ff       	call   80136b <read>
		if (m < 0)
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 06                	js     80142b <readn+0x39>
			return m;
		if (m == 0)
  801425:	74 06                	je     80142d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801427:	01 c3                	add    %eax,%ebx
  801429:	eb db                	jmp    801406 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80142d:	89 d8                	mov    %ebx,%eax
  80142f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5f                   	pop    %edi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 1c             	sub    $0x1c,%esp
  80143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	53                   	push   %ebx
  801446:	e8 b0 fc ff ff       	call   8010fb <fd_lookup>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 3a                	js     80148c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	ff 30                	pushl  (%eax)
  80145e:	e8 e8 fc ff ff       	call   80114b <dev_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 22                	js     80148c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801471:	74 1e                	je     801491 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801476:	8b 52 0c             	mov    0xc(%edx),%edx
  801479:	85 d2                	test   %edx,%edx
  80147b:	74 35                	je     8014b2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	ff 75 10             	pushl  0x10(%ebp)
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	50                   	push   %eax
  801487:	ff d2                	call   *%edx
  801489:	83 c4 10             	add    $0x10,%esp
}
  80148c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148f:	c9                   	leave  
  801490:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801491:	a1 08 40 80 00       	mov    0x804008,%eax
  801496:	8b 40 48             	mov    0x48(%eax),%eax
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	53                   	push   %ebx
  80149d:	50                   	push   %eax
  80149e:	68 b1 2a 80 00       	push   $0x802ab1
  8014a3:	e8 94 ed ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b0:	eb da                	jmp    80148c <write+0x55>
		return -E_NOT_SUPP;
  8014b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b7:	eb d3                	jmp    80148c <write+0x55>

008014b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	ff 75 08             	pushl  0x8(%ebp)
  8014c6:	e8 30 fc ff ff       	call   8010fb <fd_lookup>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 0e                	js     8014e0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 1c             	sub    $0x1c,%esp
  8014e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	53                   	push   %ebx
  8014f1:	e8 05 fc ff ff       	call   8010fb <fd_lookup>
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 37                	js     801534 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801507:	ff 30                	pushl  (%eax)
  801509:	e8 3d fc ff ff       	call   80114b <dev_lookup>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 1f                	js     801534 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801518:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151c:	74 1b                	je     801539 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80151e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801521:	8b 52 18             	mov    0x18(%edx),%edx
  801524:	85 d2                	test   %edx,%edx
  801526:	74 32                	je     80155a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 0c             	pushl  0xc(%ebp)
  80152e:	50                   	push   %eax
  80152f:	ff d2                	call   *%edx
  801531:	83 c4 10             	add    $0x10,%esp
}
  801534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801537:	c9                   	leave  
  801538:	c3                   	ret    
			thisenv->env_id, fdnum);
  801539:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80153e:	8b 40 48             	mov    0x48(%eax),%eax
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	53                   	push   %ebx
  801545:	50                   	push   %eax
  801546:	68 74 2a 80 00       	push   $0x802a74
  80154b:	e8 ec ec ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801558:	eb da                	jmp    801534 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80155a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155f:	eb d3                	jmp    801534 <ftruncate+0x52>

00801561 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	53                   	push   %ebx
  801565:	83 ec 1c             	sub    $0x1c,%esp
  801568:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156e:	50                   	push   %eax
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 84 fb ff ff       	call   8010fb <fd_lookup>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 4b                	js     8015c9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801584:	50                   	push   %eax
  801585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801588:	ff 30                	pushl  (%eax)
  80158a:	e8 bc fb ff ff       	call   80114b <dev_lookup>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 33                	js     8015c9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80159d:	74 2f                	je     8015ce <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80159f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015a9:	00 00 00 
	stat->st_isdir = 0;
  8015ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015b3:	00 00 00 
	stat->st_dev = dev;
  8015b6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	53                   	push   %ebx
  8015c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c3:	ff 50 14             	call   *0x14(%eax)
  8015c6:	83 c4 10             	add    $0x10,%esp
}
  8015c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d3:	eb f4                	jmp    8015c9 <fstat+0x68>

008015d5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	6a 00                	push   $0x0
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 22 02 00 00       	call   801809 <open>
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 1b                	js     80160b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	50                   	push   %eax
  8015f7:	e8 65 ff ff ff       	call   801561 <fstat>
  8015fc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015fe:	89 1c 24             	mov    %ebx,(%esp)
  801601:	e8 27 fc ff ff       	call   80122d <close>
	return r;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 f3                	mov    %esi,%ebx
}
  80160b:	89 d8                	mov    %ebx,%eax
  80160d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801610:	5b                   	pop    %ebx
  801611:	5e                   	pop    %esi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	89 c6                	mov    %eax,%esi
  80161b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80161d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801624:	74 27                	je     80164d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801626:	6a 07                	push   $0x7
  801628:	68 00 50 80 00       	push   $0x805000
  80162d:	56                   	push   %esi
  80162e:	ff 35 00 40 80 00    	pushl  0x804000
  801634:	e8 69 0c 00 00       	call   8022a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801639:	83 c4 0c             	add    $0xc,%esp
  80163c:	6a 00                	push   $0x0
  80163e:	53                   	push   %ebx
  80163f:	6a 00                	push   $0x0
  801641:	e8 f3 0b 00 00       	call   802239 <ipc_recv>
}
  801646:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801649:	5b                   	pop    %ebx
  80164a:	5e                   	pop    %esi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	6a 01                	push   $0x1
  801652:	e8 a3 0c 00 00       	call   8022fa <ipc_find_env>
  801657:	a3 00 40 80 00       	mov    %eax,0x804000
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	eb c5                	jmp    801626 <fsipc+0x12>

00801661 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8b 40 0c             	mov    0xc(%eax),%eax
  80166d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801672:	8b 45 0c             	mov    0xc(%ebp),%eax
  801675:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	b8 02 00 00 00       	mov    $0x2,%eax
  801684:	e8 8b ff ff ff       	call   801614 <fsipc>
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <devfile_flush>:
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8b 40 0c             	mov    0xc(%eax),%eax
  801697:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80169c:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8016a6:	e8 69 ff ff ff       	call   801614 <fsipc>
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <devfile_stat>:
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016cc:	e8 43 ff ff ff       	call   801614 <fsipc>
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 2c                	js     801701 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	68 00 50 80 00       	push   $0x805000
  8016dd:	53                   	push   %ebx
  8016de:	e8 b8 f2 ff ff       	call   80099b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016e3:	a1 80 50 80 00       	mov    0x805080,%eax
  8016e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ee:	a1 84 50 80 00       	mov    0x805084,%eax
  8016f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <devfile_write>:
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	53                   	push   %ebx
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8b 40 0c             	mov    0xc(%eax),%eax
  801716:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80171b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801721:	53                   	push   %ebx
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	68 08 50 80 00       	push   $0x805008
  80172a:	e8 5c f4 ff ff       	call   800b8b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 04 00 00 00       	mov    $0x4,%eax
  801739:	e8 d6 fe ff ff       	call   801614 <fsipc>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 0b                	js     801750 <devfile_write+0x4a>
	assert(r <= n);
  801745:	39 d8                	cmp    %ebx,%eax
  801747:	77 0c                	ja     801755 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801749:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174e:	7f 1e                	jg     80176e <devfile_write+0x68>
}
  801750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801753:	c9                   	leave  
  801754:	c3                   	ret    
	assert(r <= n);
  801755:	68 e4 2a 80 00       	push   $0x802ae4
  80175a:	68 eb 2a 80 00       	push   $0x802aeb
  80175f:	68 98 00 00 00       	push   $0x98
  801764:	68 00 2b 80 00       	push   $0x802b00
  801769:	e8 6a 0a 00 00       	call   8021d8 <_panic>
	assert(r <= PGSIZE);
  80176e:	68 0b 2b 80 00       	push   $0x802b0b
  801773:	68 eb 2a 80 00       	push   $0x802aeb
  801778:	68 99 00 00 00       	push   $0x99
  80177d:	68 00 2b 80 00       	push   $0x802b00
  801782:	e8 51 0a 00 00       	call   8021d8 <_panic>

00801787 <devfile_read>:
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	56                   	push   %esi
  80178b:	53                   	push   %ebx
  80178c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80179a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8017aa:	e8 65 fe ff ff       	call   801614 <fsipc>
  8017af:	89 c3                	mov    %eax,%ebx
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 1f                	js     8017d4 <devfile_read+0x4d>
	assert(r <= n);
  8017b5:	39 f0                	cmp    %esi,%eax
  8017b7:	77 24                	ja     8017dd <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017be:	7f 33                	jg     8017f3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	50                   	push   %eax
  8017c4:	68 00 50 80 00       	push   $0x805000
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	e8 58 f3 ff ff       	call   800b29 <memmove>
	return r;
  8017d1:	83 c4 10             	add    $0x10,%esp
}
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d9:	5b                   	pop    %ebx
  8017da:	5e                   	pop    %esi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    
	assert(r <= n);
  8017dd:	68 e4 2a 80 00       	push   $0x802ae4
  8017e2:	68 eb 2a 80 00       	push   $0x802aeb
  8017e7:	6a 7c                	push   $0x7c
  8017e9:	68 00 2b 80 00       	push   $0x802b00
  8017ee:	e8 e5 09 00 00       	call   8021d8 <_panic>
	assert(r <= PGSIZE);
  8017f3:	68 0b 2b 80 00       	push   $0x802b0b
  8017f8:	68 eb 2a 80 00       	push   $0x802aeb
  8017fd:	6a 7d                	push   $0x7d
  8017ff:	68 00 2b 80 00       	push   $0x802b00
  801804:	e8 cf 09 00 00       	call   8021d8 <_panic>

00801809 <open>:
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	56                   	push   %esi
  80180d:	53                   	push   %ebx
  80180e:	83 ec 1c             	sub    $0x1c,%esp
  801811:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801814:	56                   	push   %esi
  801815:	e8 48 f1 ff ff       	call   800962 <strlen>
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801822:	7f 6c                	jg     801890 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182a:	50                   	push   %eax
  80182b:	e8 79 f8 ff ff       	call   8010a9 <fd_alloc>
  801830:	89 c3                	mov    %eax,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	78 3c                	js     801875 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	56                   	push   %esi
  80183d:	68 00 50 80 00       	push   $0x805000
  801842:	e8 54 f1 ff ff       	call   80099b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80184f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801852:	b8 01 00 00 00       	mov    $0x1,%eax
  801857:	e8 b8 fd ff ff       	call   801614 <fsipc>
  80185c:	89 c3                	mov    %eax,%ebx
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	78 19                	js     80187e <open+0x75>
	return fd2num(fd);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 75 f4             	pushl  -0xc(%ebp)
  80186b:	e8 12 f8 ff ff       	call   801082 <fd2num>
  801870:	89 c3                	mov    %eax,%ebx
  801872:	83 c4 10             	add    $0x10,%esp
}
  801875:	89 d8                	mov    %ebx,%eax
  801877:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    
		fd_close(fd, 0);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	6a 00                	push   $0x0
  801883:	ff 75 f4             	pushl  -0xc(%ebp)
  801886:	e8 1b f9 ff ff       	call   8011a6 <fd_close>
		return r;
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	eb e5                	jmp    801875 <open+0x6c>
		return -E_BAD_PATH;
  801890:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801895:	eb de                	jmp    801875 <open+0x6c>

00801897 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a7:	e8 68 fd ff ff       	call   801614 <fsipc>
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018b4:	68 17 2b 80 00       	push   $0x802b17
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 da f0 ff ff       	call   80099b <strcpy>
	return 0;
}
  8018c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <devsock_close>:
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 10             	sub    $0x10,%esp
  8018cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018d2:	53                   	push   %ebx
  8018d3:	e8 5d 0a 00 00       	call   802335 <pageref>
  8018d8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018db:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018e0:	83 f8 01             	cmp    $0x1,%eax
  8018e3:	74 07                	je     8018ec <devsock_close+0x24>
}
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	ff 73 0c             	pushl  0xc(%ebx)
  8018f2:	e8 b9 02 00 00       	call   801bb0 <nsipc_close>
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	eb e7                	jmp    8018e5 <devsock_close+0x1d>

008018fe <devsock_write>:
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801904:	6a 00                	push   $0x0
  801906:	ff 75 10             	pushl  0x10(%ebp)
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	ff 70 0c             	pushl  0xc(%eax)
  801912:	e8 76 03 00 00       	call   801c8d <nsipc_send>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <devsock_read>:
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 10             	pushl  0x10(%ebp)
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	ff 70 0c             	pushl  0xc(%eax)
  80192d:	e8 ef 02 00 00       	call   801c21 <nsipc_recv>
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <fd2sockid>:
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80193a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	e8 b7 f7 ff ff       	call   8010fb <fd_lookup>
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 10                	js     80195b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80194b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801954:	39 08                	cmp    %ecx,(%eax)
  801956:	75 05                	jne    80195d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801958:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    
		return -E_NOT_SUPP;
  80195d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801962:	eb f7                	jmp    80195b <fd2sockid+0x27>

00801964 <alloc_sockfd>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
  801969:	83 ec 1c             	sub    $0x1c,%esp
  80196c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80196e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801971:	50                   	push   %eax
  801972:	e8 32 f7 ff ff       	call   8010a9 <fd_alloc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 43                	js     8019c3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	68 07 04 00 00       	push   $0x407
  801988:	ff 75 f4             	pushl  -0xc(%ebp)
  80198b:	6a 00                	push   $0x0
  80198d:	e8 fb f3 ff ff       	call   800d8d <sys_page_alloc>
  801992:	89 c3                	mov    %eax,%ebx
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 28                	js     8019c3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019a4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019b0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	50                   	push   %eax
  8019b7:	e8 c6 f6 ff ff       	call   801082 <fd2num>
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	eb 0c                	jmp    8019cf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	56                   	push   %esi
  8019c7:	e8 e4 01 00 00       	call   801bb0 <nsipc_close>
		return r;
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	89 d8                	mov    %ebx,%eax
  8019d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    

008019d8 <accept>:
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	e8 4e ff ff ff       	call   801934 <fd2sockid>
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 1b                	js     801a05 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	ff 75 10             	pushl  0x10(%ebp)
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	50                   	push   %eax
  8019f4:	e8 0e 01 00 00       	call   801b07 <nsipc_accept>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 05                	js     801a05 <accept+0x2d>
	return alloc_sockfd(r);
  801a00:	e8 5f ff ff ff       	call   801964 <alloc_sockfd>
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <bind>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	e8 1f ff ff ff       	call   801934 <fd2sockid>
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 12                	js     801a2b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	e8 31 01 00 00       	call   801b59 <nsipc_bind>
  801a28:	83 c4 10             	add    $0x10,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <shutdown>:
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	e8 f9 fe ff ff       	call   801934 <fd2sockid>
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 0f                	js     801a4e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	50                   	push   %eax
  801a46:	e8 43 01 00 00       	call   801b8e <nsipc_shutdown>
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <connect>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	e8 d6 fe ff ff       	call   801934 <fd2sockid>
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 12                	js     801a74 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	50                   	push   %eax
  801a6c:	e8 59 01 00 00       	call   801bca <nsipc_connect>
  801a71:	83 c4 10             	add    $0x10,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <listen>:
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	e8 b0 fe ff ff       	call   801934 <fd2sockid>
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 0f                	js     801a97 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	e8 6b 01 00 00       	call   801bff <nsipc_listen>
  801a94:	83 c4 10             	add    $0x10,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	e8 3e 02 00 00       	call   801ceb <nsipc_socket>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 05                	js     801ab9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ab4:	e8 ab fe ff ff       	call   801964 <alloc_sockfd>
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ac4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801acb:	74 26                	je     801af3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801acd:	6a 07                	push   $0x7
  801acf:	68 00 60 80 00       	push   $0x806000
  801ad4:	53                   	push   %ebx
  801ad5:	ff 35 04 40 80 00    	pushl  0x804004
  801adb:	e8 c2 07 00 00       	call   8022a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ae0:	83 c4 0c             	add    $0xc,%esp
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	e8 4b 07 00 00       	call   802239 <ipc_recv>
}
  801aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801af3:	83 ec 0c             	sub    $0xc,%esp
  801af6:	6a 02                	push   $0x2
  801af8:	e8 fd 07 00 00       	call   8022fa <ipc_find_env>
  801afd:	a3 04 40 80 00       	mov    %eax,0x804004
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	eb c6                	jmp    801acd <nsipc+0x12>

00801b07 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b17:	8b 06                	mov    (%esi),%eax
  801b19:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b23:	e8 93 ff ff ff       	call   801abb <nsipc>
  801b28:	89 c3                	mov    %eax,%ebx
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	79 09                	jns    801b37 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b2e:	89 d8                	mov    %ebx,%eax
  801b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b37:	83 ec 04             	sub    $0x4,%esp
  801b3a:	ff 35 10 60 80 00    	pushl  0x806010
  801b40:	68 00 60 80 00       	push   $0x806000
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	e8 dc ef ff ff       	call   800b29 <memmove>
		*addrlen = ret->ret_addrlen;
  801b4d:	a1 10 60 80 00       	mov    0x806010,%eax
  801b52:	89 06                	mov    %eax,(%esi)
  801b54:	83 c4 10             	add    $0x10,%esp
	return r;
  801b57:	eb d5                	jmp    801b2e <nsipc_accept+0x27>

00801b59 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b6b:	53                   	push   %ebx
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	68 04 60 80 00       	push   $0x806004
  801b74:	e8 b0 ef ff ff       	call   800b29 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b7f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b84:	e8 32 ff ff ff       	call   801abb <nsipc>
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ba4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba9:	e8 0d ff ff ff       	call   801abb <nsipc>
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <nsipc_close>:

int
nsipc_close(int s)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bbe:	b8 04 00 00 00       	mov    $0x4,%eax
  801bc3:	e8 f3 fe ff ff       	call   801abb <nsipc>
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	53                   	push   %ebx
  801bce:	83 ec 08             	sub    $0x8,%esp
  801bd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bdc:	53                   	push   %ebx
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	68 04 60 80 00       	push   $0x806004
  801be5:	e8 3f ef ff ff       	call   800b29 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bea:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bf0:	b8 05 00 00 00       	mov    $0x5,%eax
  801bf5:	e8 c1 fe ff ff       	call   801abb <nsipc>
}
  801bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c10:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c15:	b8 06 00 00 00       	mov    $0x6,%eax
  801c1a:	e8 9c fe ff ff       	call   801abb <nsipc>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c31:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c37:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c3f:	b8 07 00 00 00       	mov    $0x7,%eax
  801c44:	e8 72 fe ff ff       	call   801abb <nsipc>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 1f                	js     801c6e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c4f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c54:	7f 21                	jg     801c77 <nsipc_recv+0x56>
  801c56:	39 c6                	cmp    %eax,%esi
  801c58:	7c 1d                	jl     801c77 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	50                   	push   %eax
  801c5e:	68 00 60 80 00       	push   $0x806000
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	e8 be ee ff ff       	call   800b29 <memmove>
  801c6b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c6e:	89 d8                	mov    %ebx,%eax
  801c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c77:	68 23 2b 80 00       	push   $0x802b23
  801c7c:	68 eb 2a 80 00       	push   $0x802aeb
  801c81:	6a 62                	push   $0x62
  801c83:	68 38 2b 80 00       	push   $0x802b38
  801c88:	e8 4b 05 00 00       	call   8021d8 <_panic>

00801c8d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	53                   	push   %ebx
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c9f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ca5:	7f 2e                	jg     801cd5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	53                   	push   %ebx
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	68 0c 60 80 00       	push   $0x80600c
  801cb3:	e8 71 ee ff ff       	call   800b29 <memmove>
	nsipcbuf.send.req_size = size;
  801cb8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cc6:	b8 08 00 00 00       	mov    $0x8,%eax
  801ccb:	e8 eb fd ff ff       	call   801abb <nsipc>
}
  801cd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    
	assert(size < 1600);
  801cd5:	68 44 2b 80 00       	push   $0x802b44
  801cda:	68 eb 2a 80 00       	push   $0x802aeb
  801cdf:	6a 6d                	push   $0x6d
  801ce1:	68 38 2b 80 00       	push   $0x802b38
  801ce6:	e8 ed 04 00 00       	call   8021d8 <_panic>

00801ceb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfc:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d01:	8b 45 10             	mov    0x10(%ebp),%eax
  801d04:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d09:	b8 09 00 00 00       	mov    $0x9,%eax
  801d0e:	e8 a8 fd ff ff       	call   801abb <nsipc>
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	56                   	push   %esi
  801d19:	53                   	push   %ebx
  801d1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	e8 6a f3 ff ff       	call   801092 <fd2data>
  801d28:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d2a:	83 c4 08             	add    $0x8,%esp
  801d2d:	68 50 2b 80 00       	push   $0x802b50
  801d32:	53                   	push   %ebx
  801d33:	e8 63 ec ff ff       	call   80099b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d38:	8b 46 04             	mov    0x4(%esi),%eax
  801d3b:	2b 06                	sub    (%esi),%eax
  801d3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d4a:	00 00 00 
	stat->st_dev = &devpipe;
  801d4d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d54:	30 80 00 
	return 0;
}
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d6d:	53                   	push   %ebx
  801d6e:	6a 00                	push   $0x0
  801d70:	e8 9d f0 ff ff       	call   800e12 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d75:	89 1c 24             	mov    %ebx,(%esp)
  801d78:	e8 15 f3 ff ff       	call   801092 <fd2data>
  801d7d:	83 c4 08             	add    $0x8,%esp
  801d80:	50                   	push   %eax
  801d81:	6a 00                	push   $0x0
  801d83:	e8 8a f0 ff ff       	call   800e12 <sys_page_unmap>
}
  801d88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <_pipeisclosed>:
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	57                   	push   %edi
  801d91:	56                   	push   %esi
  801d92:	53                   	push   %ebx
  801d93:	83 ec 1c             	sub    $0x1c,%esp
  801d96:	89 c7                	mov    %eax,%edi
  801d98:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d9a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d9f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801da2:	83 ec 0c             	sub    $0xc,%esp
  801da5:	57                   	push   %edi
  801da6:	e8 8a 05 00 00       	call   802335 <pageref>
  801dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dae:	89 34 24             	mov    %esi,(%esp)
  801db1:	e8 7f 05 00 00       	call   802335 <pageref>
		nn = thisenv->env_runs;
  801db6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dbc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	39 cb                	cmp    %ecx,%ebx
  801dc4:	74 1b                	je     801de1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dc6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc9:	75 cf                	jne    801d9a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dcb:	8b 42 58             	mov    0x58(%edx),%eax
  801dce:	6a 01                	push   $0x1
  801dd0:	50                   	push   %eax
  801dd1:	53                   	push   %ebx
  801dd2:	68 57 2b 80 00       	push   $0x802b57
  801dd7:	e8 60 e4 ff ff       	call   80023c <cprintf>
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	eb b9                	jmp    801d9a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801de1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de4:	0f 94 c0             	sete   %al
  801de7:	0f b6 c0             	movzbl %al,%eax
}
  801dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5f                   	pop    %edi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    

00801df2 <devpipe_write>:
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 28             	sub    $0x28,%esp
  801dfb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dfe:	56                   	push   %esi
  801dff:	e8 8e f2 ff ff       	call   801092 <fd2data>
  801e04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e11:	74 4f                	je     801e62 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e13:	8b 43 04             	mov    0x4(%ebx),%eax
  801e16:	8b 0b                	mov    (%ebx),%ecx
  801e18:	8d 51 20             	lea    0x20(%ecx),%edx
  801e1b:	39 d0                	cmp    %edx,%eax
  801e1d:	72 14                	jb     801e33 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e1f:	89 da                	mov    %ebx,%edx
  801e21:	89 f0                	mov    %esi,%eax
  801e23:	e8 65 ff ff ff       	call   801d8d <_pipeisclosed>
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	75 3b                	jne    801e67 <devpipe_write+0x75>
			sys_yield();
  801e2c:	e8 3d ef ff ff       	call   800d6e <sys_yield>
  801e31:	eb e0                	jmp    801e13 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e36:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e3a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e3d:	89 c2                	mov    %eax,%edx
  801e3f:	c1 fa 1f             	sar    $0x1f,%edx
  801e42:	89 d1                	mov    %edx,%ecx
  801e44:	c1 e9 1b             	shr    $0x1b,%ecx
  801e47:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e4a:	83 e2 1f             	and    $0x1f,%edx
  801e4d:	29 ca                	sub    %ecx,%edx
  801e4f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e53:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e57:	83 c0 01             	add    $0x1,%eax
  801e5a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e5d:	83 c7 01             	add    $0x1,%edi
  801e60:	eb ac                	jmp    801e0e <devpipe_write+0x1c>
	return i;
  801e62:	8b 45 10             	mov    0x10(%ebp),%eax
  801e65:	eb 05                	jmp    801e6c <devpipe_write+0x7a>
				return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    

00801e74 <devpipe_read>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	57                   	push   %edi
  801e78:	56                   	push   %esi
  801e79:	53                   	push   %ebx
  801e7a:	83 ec 18             	sub    $0x18,%esp
  801e7d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e80:	57                   	push   %edi
  801e81:	e8 0c f2 ff ff       	call   801092 <fd2data>
  801e86:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	be 00 00 00 00       	mov    $0x0,%esi
  801e90:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e93:	75 14                	jne    801ea9 <devpipe_read+0x35>
	return i;
  801e95:	8b 45 10             	mov    0x10(%ebp),%eax
  801e98:	eb 02                	jmp    801e9c <devpipe_read+0x28>
				return i;
  801e9a:	89 f0                	mov    %esi,%eax
}
  801e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
			sys_yield();
  801ea4:	e8 c5 ee ff ff       	call   800d6e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ea9:	8b 03                	mov    (%ebx),%eax
  801eab:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eae:	75 18                	jne    801ec8 <devpipe_read+0x54>
			if (i > 0)
  801eb0:	85 f6                	test   %esi,%esi
  801eb2:	75 e6                	jne    801e9a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801eb4:	89 da                	mov    %ebx,%edx
  801eb6:	89 f8                	mov    %edi,%eax
  801eb8:	e8 d0 fe ff ff       	call   801d8d <_pipeisclosed>
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	74 e3                	je     801ea4 <devpipe_read+0x30>
				return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	eb d4                	jmp    801e9c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ec8:	99                   	cltd   
  801ec9:	c1 ea 1b             	shr    $0x1b,%edx
  801ecc:	01 d0                	add    %edx,%eax
  801ece:	83 e0 1f             	and    $0x1f,%eax
  801ed1:	29 d0                	sub    %edx,%eax
  801ed3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ede:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ee1:	83 c6 01             	add    $0x1,%esi
  801ee4:	eb aa                	jmp    801e90 <devpipe_read+0x1c>

00801ee6 <pipe>:
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef1:	50                   	push   %eax
  801ef2:	e8 b2 f1 ff ff       	call   8010a9 <fd_alloc>
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	85 c0                	test   %eax,%eax
  801efe:	0f 88 23 01 00 00    	js     802027 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	68 07 04 00 00       	push   $0x407
  801f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 77 ee ff ff       	call   800d8d <sys_page_alloc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	0f 88 04 01 00 00    	js     802027 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f29:	50                   	push   %eax
  801f2a:	e8 7a f1 ff ff       	call   8010a9 <fd_alloc>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	0f 88 db 00 00 00    	js     802017 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	68 07 04 00 00       	push   $0x407
  801f44:	ff 75 f0             	pushl  -0x10(%ebp)
  801f47:	6a 00                	push   $0x0
  801f49:	e8 3f ee ff ff       	call   800d8d <sys_page_alloc>
  801f4e:	89 c3                	mov    %eax,%ebx
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	85 c0                	test   %eax,%eax
  801f55:	0f 88 bc 00 00 00    	js     802017 <pipe+0x131>
	va = fd2data(fd0);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f61:	e8 2c f1 ff ff       	call   801092 <fd2data>
  801f66:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f68:	83 c4 0c             	add    $0xc,%esp
  801f6b:	68 07 04 00 00       	push   $0x407
  801f70:	50                   	push   %eax
  801f71:	6a 00                	push   $0x0
  801f73:	e8 15 ee ff ff       	call   800d8d <sys_page_alloc>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	0f 88 82 00 00 00    	js     802007 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8b:	e8 02 f1 ff ff       	call   801092 <fd2data>
  801f90:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f97:	50                   	push   %eax
  801f98:	6a 00                	push   $0x0
  801f9a:	56                   	push   %esi
  801f9b:	6a 00                	push   $0x0
  801f9d:	e8 2e ee ff ff       	call   800dd0 <sys_page_map>
  801fa2:	89 c3                	mov    %eax,%ebx
  801fa4:	83 c4 20             	add    $0x20,%esp
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 4e                	js     801ff9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fab:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd4:	e8 a9 f0 ff ff       	call   801082 <fd2num>
  801fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fdc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fde:	83 c4 04             	add    $0x4,%esp
  801fe1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe4:	e8 99 f0 ff ff       	call   801082 <fd2num>
  801fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff7:	eb 2e                	jmp    802027 <pipe+0x141>
	sys_page_unmap(0, va);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	56                   	push   %esi
  801ffd:	6a 00                	push   $0x0
  801fff:	e8 0e ee ff ff       	call   800e12 <sys_page_unmap>
  802004:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	ff 75 f0             	pushl  -0x10(%ebp)
  80200d:	6a 00                	push   $0x0
  80200f:	e8 fe ed ff ff       	call   800e12 <sys_page_unmap>
  802014:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802017:	83 ec 08             	sub    $0x8,%esp
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	6a 00                	push   $0x0
  80201f:	e8 ee ed ff ff       	call   800e12 <sys_page_unmap>
  802024:	83 c4 10             	add    $0x10,%esp
}
  802027:	89 d8                	mov    %ebx,%eax
  802029:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    

00802030 <pipeisclosed>:
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802036:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802039:	50                   	push   %eax
  80203a:	ff 75 08             	pushl  0x8(%ebp)
  80203d:	e8 b9 f0 ff ff       	call   8010fb <fd_lookup>
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	85 c0                	test   %eax,%eax
  802047:	78 18                	js     802061 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	ff 75 f4             	pushl  -0xc(%ebp)
  80204f:	e8 3e f0 ff ff       	call   801092 <fd2data>
	return _pipeisclosed(fd, p);
  802054:	89 c2                	mov    %eax,%edx
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	e8 2f fd ff ff       	call   801d8d <_pipeisclosed>
  80205e:	83 c4 10             	add    $0x10,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	c3                   	ret    

00802069 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80206f:	68 6f 2b 80 00       	push   $0x802b6f
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	e8 1f e9 ff ff       	call   80099b <strcpy>
	return 0;
}
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <devcons_write>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	57                   	push   %edi
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80208f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802094:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80209a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209d:	73 31                	jae    8020d0 <devcons_write+0x4d>
		m = n - tot;
  80209f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020a2:	29 f3                	sub    %esi,%ebx
  8020a4:	83 fb 7f             	cmp    $0x7f,%ebx
  8020a7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ac:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020af:	83 ec 04             	sub    $0x4,%esp
  8020b2:	53                   	push   %ebx
  8020b3:	89 f0                	mov    %esi,%eax
  8020b5:	03 45 0c             	add    0xc(%ebp),%eax
  8020b8:	50                   	push   %eax
  8020b9:	57                   	push   %edi
  8020ba:	e8 6a ea ff ff       	call   800b29 <memmove>
		sys_cputs(buf, m);
  8020bf:	83 c4 08             	add    $0x8,%esp
  8020c2:	53                   	push   %ebx
  8020c3:	57                   	push   %edi
  8020c4:	e8 08 ec ff ff       	call   800cd1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020c9:	01 de                	add    %ebx,%esi
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	eb ca                	jmp    80209a <devcons_write+0x17>
}
  8020d0:	89 f0                	mov    %esi,%eax
  8020d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5f                   	pop    %edi
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <devcons_read>:
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 08             	sub    $0x8,%esp
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e9:	74 21                	je     80210c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020eb:	e8 ff eb ff ff       	call   800cef <sys_cgetc>
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	75 07                	jne    8020fb <devcons_read+0x21>
		sys_yield();
  8020f4:	e8 75 ec ff ff       	call   800d6e <sys_yield>
  8020f9:	eb f0                	jmp    8020eb <devcons_read+0x11>
	if (c < 0)
  8020fb:	78 0f                	js     80210c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020fd:	83 f8 04             	cmp    $0x4,%eax
  802100:	74 0c                	je     80210e <devcons_read+0x34>
	*(char*)vbuf = c;
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	88 02                	mov    %al,(%edx)
	return 1;
  802107:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    
		return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	eb f7                	jmp    80210c <devcons_read+0x32>

00802115 <cputchar>:
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802121:	6a 01                	push   $0x1
  802123:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802126:	50                   	push   %eax
  802127:	e8 a5 eb ff ff       	call   800cd1 <sys_cputs>
}
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <getchar>:
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802137:	6a 01                	push   $0x1
  802139:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213c:	50                   	push   %eax
  80213d:	6a 00                	push   $0x0
  80213f:	e8 27 f2 ff ff       	call   80136b <read>
	if (r < 0)
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	85 c0                	test   %eax,%eax
  802149:	78 06                	js     802151 <getchar+0x20>
	if (r < 1)
  80214b:	74 06                	je     802153 <getchar+0x22>
	return c;
  80214d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    
		return -E_EOF;
  802153:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802158:	eb f7                	jmp    802151 <getchar+0x20>

0080215a <iscons>:
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 8f ef ff ff       	call   8010fb <fd_lookup>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 11                	js     802184 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80217c:	39 10                	cmp    %edx,(%eax)
  80217e:	0f 94 c0             	sete   %al
  802181:	0f b6 c0             	movzbl %al,%eax
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <opencons>:
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80218c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218f:	50                   	push   %eax
  802190:	e8 14 ef ff ff       	call   8010a9 <fd_alloc>
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	85 c0                	test   %eax,%eax
  80219a:	78 3a                	js     8021d6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	68 07 04 00 00       	push   $0x407
  8021a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a7:	6a 00                	push   $0x0
  8021a9:	e8 df eb ff ff       	call   800d8d <sys_page_alloc>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 21                	js     8021d6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021be:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	50                   	push   %eax
  8021ce:	e8 af ee ff ff       	call   801082 <fd2num>
  8021d3:	83 c4 10             	add    $0x10,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	56                   	push   %esi
  8021dc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e2:	8b 40 48             	mov    0x48(%eax),%eax
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	68 a0 2b 80 00       	push   $0x802ba0
  8021ed:	50                   	push   %eax
  8021ee:	68 83 26 80 00       	push   $0x802683
  8021f3:	e8 44 e0 ff ff       	call   80023c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021f8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021fb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802201:	e8 49 eb ff ff       	call   800d4f <sys_getenvid>
  802206:	83 c4 04             	add    $0x4,%esp
  802209:	ff 75 0c             	pushl  0xc(%ebp)
  80220c:	ff 75 08             	pushl  0x8(%ebp)
  80220f:	56                   	push   %esi
  802210:	50                   	push   %eax
  802211:	68 7c 2b 80 00       	push   $0x802b7c
  802216:	e8 21 e0 ff ff       	call   80023c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80221b:	83 c4 18             	add    $0x18,%esp
  80221e:	53                   	push   %ebx
  80221f:	ff 75 10             	pushl  0x10(%ebp)
  802222:	e8 c4 df ff ff       	call   8001eb <vcprintf>
	cprintf("\n");
  802227:	c7 04 24 47 26 80 00 	movl   $0x802647,(%esp)
  80222e:	e8 09 e0 ff ff       	call   80023c <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802236:	cc                   	int3   
  802237:	eb fd                	jmp    802236 <_panic+0x5e>

00802239 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	56                   	push   %esi
  80223d:	53                   	push   %ebx
  80223e:	8b 75 08             	mov    0x8(%ebp),%esi
  802241:	8b 45 0c             	mov    0xc(%ebp),%eax
  802244:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802247:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802249:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80224e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	50                   	push   %eax
  802255:	e8 e3 ec ff ff       	call   800f3d <sys_ipc_recv>
	if(ret < 0){
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 2b                	js     80228c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802261:	85 f6                	test   %esi,%esi
  802263:	74 0a                	je     80226f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802265:	a1 08 40 80 00       	mov    0x804008,%eax
  80226a:	8b 40 74             	mov    0x74(%eax),%eax
  80226d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80226f:	85 db                	test   %ebx,%ebx
  802271:	74 0a                	je     80227d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802273:	a1 08 40 80 00       	mov    0x804008,%eax
  802278:	8b 40 78             	mov    0x78(%eax),%eax
  80227b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80227d:	a1 08 40 80 00       	mov    0x804008,%eax
  802282:	8b 40 70             	mov    0x70(%eax),%eax
}
  802285:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
		if(from_env_store)
  80228c:	85 f6                	test   %esi,%esi
  80228e:	74 06                	je     802296 <ipc_recv+0x5d>
			*from_env_store = 0;
  802290:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802296:	85 db                	test   %ebx,%ebx
  802298:	74 eb                	je     802285 <ipc_recv+0x4c>
			*perm_store = 0;
  80229a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022a0:	eb e3                	jmp    802285 <ipc_recv+0x4c>

008022a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022b4:	85 db                	test   %ebx,%ebx
  8022b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022bb:	0f 44 d8             	cmove  %eax,%ebx
  8022be:	eb 05                	jmp    8022c5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022c0:	e8 a9 ea ff ff       	call   800d6e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022c5:	ff 75 14             	pushl  0x14(%ebp)
  8022c8:	53                   	push   %ebx
  8022c9:	56                   	push   %esi
  8022ca:	57                   	push   %edi
  8022cb:	e8 4a ec ff ff       	call   800f1a <sys_ipc_try_send>
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 1b                	je     8022f2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022d7:	79 e7                	jns    8022c0 <ipc_send+0x1e>
  8022d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022dc:	74 e2                	je     8022c0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 a7 2b 80 00       	push   $0x802ba7
  8022e6:	6a 46                	push   $0x46
  8022e8:	68 bc 2b 80 00       	push   $0x802bbc
  8022ed:	e8 e6 fe ff ff       	call   8021d8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5f                   	pop    %edi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    

008022fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802305:	89 c2                	mov    %eax,%edx
  802307:	c1 e2 07             	shl    $0x7,%edx
  80230a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802310:	8b 52 50             	mov    0x50(%edx),%edx
  802313:	39 ca                	cmp    %ecx,%edx
  802315:	74 11                	je     802328 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802317:	83 c0 01             	add    $0x1,%eax
  80231a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80231f:	75 e4                	jne    802305 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
  802326:	eb 0b                	jmp    802333 <ipc_find_env+0x39>
			return envs[i].env_id;
  802328:	c1 e0 07             	shl    $0x7,%eax
  80232b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802330:	8b 40 48             	mov    0x48(%eax),%eax
}
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    

00802335 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	c1 e8 16             	shr    $0x16,%eax
  802340:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80234c:	f6 c1 01             	test   $0x1,%cl
  80234f:	74 1d                	je     80236e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802351:	c1 ea 0c             	shr    $0xc,%edx
  802354:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80235b:	f6 c2 01             	test   $0x1,%dl
  80235e:	74 0e                	je     80236e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802360:	c1 ea 0c             	shr    $0xc,%edx
  802363:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80236a:	ef 
  80236b:	0f b7 c0             	movzwl %ax,%eax
}
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80237b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802387:	85 d2                	test   %edx,%edx
  802389:	75 4d                	jne    8023d8 <__udivdi3+0x68>
  80238b:	39 f3                	cmp    %esi,%ebx
  80238d:	76 19                	jbe    8023a8 <__udivdi3+0x38>
  80238f:	31 ff                	xor    %edi,%edi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f2                	mov    %esi,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 d9                	mov    %ebx,%ecx
  8023aa:	85 db                	test   %ebx,%ebx
  8023ac:	75 0b                	jne    8023b9 <__udivdi3+0x49>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f3                	div    %ebx
  8023b7:	89 c1                	mov    %eax,%ecx
  8023b9:	31 d2                	xor    %edx,%edx
  8023bb:	89 f0                	mov    %esi,%eax
  8023bd:	f7 f1                	div    %ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f7                	mov    %esi,%edi
  8023c5:	f7 f1                	div    %ecx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	77 1c                	ja     8023f8 <__udivdi3+0x88>
  8023dc:	0f bd fa             	bsr    %edx,%edi
  8023df:	83 f7 1f             	xor    $0x1f,%edi
  8023e2:	75 2c                	jne    802410 <__udivdi3+0xa0>
  8023e4:	39 f2                	cmp    %esi,%edx
  8023e6:	72 06                	jb     8023ee <__udivdi3+0x7e>
  8023e8:	31 c0                	xor    %eax,%eax
  8023ea:	39 eb                	cmp    %ebp,%ebx
  8023ec:	77 a9                	ja     802397 <__udivdi3+0x27>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	eb a2                	jmp    802397 <__udivdi3+0x27>
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	31 ff                	xor    %edi,%edi
  8023fa:	31 c0                	xor    %eax,%eax
  8023fc:	89 fa                	mov    %edi,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 f9                	mov    %edi,%ecx
  802412:	b8 20 00 00 00       	mov    $0x20,%eax
  802417:	29 f8                	sub    %edi,%eax
  802419:	d3 e2                	shl    %cl,%edx
  80241b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	89 da                	mov    %ebx,%edx
  802423:	d3 ea                	shr    %cl,%edx
  802425:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802429:	09 d1                	or     %edx,%ecx
  80242b:	89 f2                	mov    %esi,%edx
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 f9                	mov    %edi,%ecx
  802433:	d3 e3                	shl    %cl,%ebx
  802435:	89 c1                	mov    %eax,%ecx
  802437:	d3 ea                	shr    %cl,%edx
  802439:	89 f9                	mov    %edi,%ecx
  80243b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80243f:	89 eb                	mov    %ebp,%ebx
  802441:	d3 e6                	shl    %cl,%esi
  802443:	89 c1                	mov    %eax,%ecx
  802445:	d3 eb                	shr    %cl,%ebx
  802447:	09 de                	or     %ebx,%esi
  802449:	89 f0                	mov    %esi,%eax
  80244b:	f7 74 24 08          	divl   0x8(%esp)
  80244f:	89 d6                	mov    %edx,%esi
  802451:	89 c3                	mov    %eax,%ebx
  802453:	f7 64 24 0c          	mull   0xc(%esp)
  802457:	39 d6                	cmp    %edx,%esi
  802459:	72 15                	jb     802470 <__udivdi3+0x100>
  80245b:	89 f9                	mov    %edi,%ecx
  80245d:	d3 e5                	shl    %cl,%ebp
  80245f:	39 c5                	cmp    %eax,%ebp
  802461:	73 04                	jae    802467 <__udivdi3+0xf7>
  802463:	39 d6                	cmp    %edx,%esi
  802465:	74 09                	je     802470 <__udivdi3+0x100>
  802467:	89 d8                	mov    %ebx,%eax
  802469:	31 ff                	xor    %edi,%edi
  80246b:	e9 27 ff ff ff       	jmp    802397 <__udivdi3+0x27>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 1d ff ff ff       	jmp    802397 <__udivdi3+0x27>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80248b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80248f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	89 da                	mov    %ebx,%edx
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 43                	jne    8024e0 <__umoddi3+0x60>
  80249d:	39 df                	cmp    %ebx,%edi
  80249f:	76 17                	jbe    8024b8 <__umoddi3+0x38>
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	f7 f7                	div    %edi
  8024a5:	89 d0                	mov    %edx,%eax
  8024a7:	31 d2                	xor    %edx,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 fd                	mov    %edi,%ebp
  8024ba:	85 ff                	test   %edi,%edi
  8024bc:	75 0b                	jne    8024c9 <__umoddi3+0x49>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f7                	div    %edi
  8024c7:	89 c5                	mov    %eax,%ebp
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f5                	div    %ebp
  8024cf:	89 f0                	mov    %esi,%eax
  8024d1:	f7 f5                	div    %ebp
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	eb d0                	jmp    8024a7 <__umoddi3+0x27>
  8024d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	89 f1                	mov    %esi,%ecx
  8024e2:	39 d8                	cmp    %ebx,%eax
  8024e4:	76 0a                	jbe    8024f0 <__umoddi3+0x70>
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	83 c4 1c             	add    $0x1c,%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	0f bd e8             	bsr    %eax,%ebp
  8024f3:	83 f5 1f             	xor    $0x1f,%ebp
  8024f6:	75 20                	jne    802518 <__umoddi3+0x98>
  8024f8:	39 d8                	cmp    %ebx,%eax
  8024fa:	0f 82 b0 00 00 00    	jb     8025b0 <__umoddi3+0x130>
  802500:	39 f7                	cmp    %esi,%edi
  802502:	0f 86 a8 00 00 00    	jbe    8025b0 <__umoddi3+0x130>
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	83 c4 1c             	add    $0x1c,%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5f                   	pop    %edi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	ba 20 00 00 00       	mov    $0x20,%edx
  80251f:	29 ea                	sub    %ebp,%edx
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 44 24 08          	mov    %eax,0x8(%esp)
  802527:	89 d1                	mov    %edx,%ecx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	d3 e8                	shr    %cl,%eax
  80252d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802531:	89 54 24 04          	mov    %edx,0x4(%esp)
  802535:	8b 54 24 04          	mov    0x4(%esp),%edx
  802539:	09 c1                	or     %eax,%ecx
  80253b:	89 d8                	mov    %ebx,%eax
  80253d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e7                	shl    %cl,%edi
  802545:	89 d1                	mov    %edx,%ecx
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	d3 e3                	shl    %cl,%ebx
  802551:	89 c7                	mov    %eax,%edi
  802553:	89 d1                	mov    %edx,%ecx
  802555:	89 f0                	mov    %esi,%eax
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 fa                	mov    %edi,%edx
  80255d:	d3 e6                	shl    %cl,%esi
  80255f:	09 d8                	or     %ebx,%eax
  802561:	f7 74 24 08          	divl   0x8(%esp)
  802565:	89 d1                	mov    %edx,%ecx
  802567:	89 f3                	mov    %esi,%ebx
  802569:	f7 64 24 0c          	mull   0xc(%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d7                	mov    %edx,%edi
  802571:	39 d1                	cmp    %edx,%ecx
  802573:	72 06                	jb     80257b <__umoddi3+0xfb>
  802575:	75 10                	jne    802587 <__umoddi3+0x107>
  802577:	39 c3                	cmp    %eax,%ebx
  802579:	73 0c                	jae    802587 <__umoddi3+0x107>
  80257b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80257f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802583:	89 d7                	mov    %edx,%edi
  802585:	89 c6                	mov    %eax,%esi
  802587:	89 ca                	mov    %ecx,%edx
  802589:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258e:	29 f3                	sub    %esi,%ebx
  802590:	19 fa                	sbb    %edi,%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	d3 e0                	shl    %cl,%eax
  802596:	89 e9                	mov    %ebp,%ecx
  802598:	d3 eb                	shr    %cl,%ebx
  80259a:	d3 ea                	shr    %cl,%edx
  80259c:	09 d8                	or     %ebx,%eax
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 da                	mov    %ebx,%edx
  8025b2:	29 fe                	sub    %edi,%esi
  8025b4:	19 c2                	sbb    %eax,%edx
  8025b6:	89 f1                	mov    %esi,%ecx
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	e9 4b ff ff ff       	jmp    80250a <__umoddi3+0x8a>
