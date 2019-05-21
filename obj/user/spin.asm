
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 80 17 80 00       	push   $0x801780
  80003f:	e8 ad 01 00 00       	call   8001f1 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 37 11 00 00       	call   801180 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 f8 17 80 00       	push   $0x8017f8
  800058:	e8 94 01 00 00       	call   8001f1 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 a8 17 80 00       	push   $0x8017a8
  80006c:	e8 80 01 00 00       	call   8001f1 <cprintf>
	sys_yield();
  800071:	e8 ad 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  800076:	e8 a8 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  80007b:	e8 a3 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  800080:	e8 9e 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  800085:	e8 99 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  80008a:	e8 94 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  80008f:	e8 8f 0c 00 00       	call   800d23 <sys_yield>
	sys_yield();
  800094:	e8 8a 0c 00 00       	call   800d23 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 d0 17 80 00 	movl   $0x8017d0,(%esp)
  8000a0:	e8 4c 01 00 00       	call   8001f1 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 16 0c 00 00       	call   800cc3 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	57                   	push   %edi
  8000b9:	56                   	push   %esi
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000be:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000c5:	00 00 00 
	envid_t find = sys_getenvid();
  8000c8:	e8 37 0c 00 00       	call   800d04 <sys_getenvid>
  8000cd:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8000d3:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8000e2:	eb 0b                	jmp    8000ef <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000e4:	83 c2 01             	add    $0x1,%edx
  8000e7:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000ed:	74 21                	je     800110 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000ef:	89 d1                	mov    %edx,%ecx
  8000f1:	c1 e1 07             	shl    $0x7,%ecx
  8000f4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000fa:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000fd:	39 c1                	cmp    %eax,%ecx
  8000ff:	75 e3                	jne    8000e4 <libmain+0x2f>
  800101:	89 d3                	mov    %edx,%ebx
  800103:	c1 e3 07             	shl    $0x7,%ebx
  800106:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80010c:	89 fe                	mov    %edi,%esi
  80010e:	eb d4                	jmp    8000e4 <libmain+0x2f>
  800110:	89 f0                	mov    %esi,%eax
  800112:	84 c0                	test   %al,%al
  800114:	74 06                	je     80011c <libmain+0x67>
  800116:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800120:	7e 0a                	jle    80012c <libmain+0x77>
		binaryname = argv[0];
  800122:	8b 45 0c             	mov    0xc(%ebp),%eax
  800125:	8b 00                	mov    (%eax),%eax
  800127:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 75 0c             	pushl  0xc(%ebp)
  800132:	ff 75 08             	pushl  0x8(%ebp)
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0b 00 00 00       	call   80014a <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800150:	6a 00                	push   $0x0
  800152:	e8 6c 0b 00 00       	call   800cc3 <sys_env_destroy>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	53                   	push   %ebx
  800160:	83 ec 04             	sub    $0x4,%esp
  800163:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800166:	8b 13                	mov    (%ebx),%edx
  800168:	8d 42 01             	lea    0x1(%edx),%eax
  80016b:	89 03                	mov    %eax,(%ebx)
  80016d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800170:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800174:	3d ff 00 00 00       	cmp    $0xff,%eax
  800179:	74 09                	je     800184 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800182:	c9                   	leave  
  800183:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 ff 00 00 00       	push   $0xff
  80018c:	8d 43 08             	lea    0x8(%ebx),%eax
  80018f:	50                   	push   %eax
  800190:	e8 f1 0a 00 00       	call   800c86 <sys_cputs>
		b->idx = 0;
  800195:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	eb db                	jmp    80017b <putch+0x1f>

008001a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b0:	00 00 00 
	b.cnt = 0;
  8001b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bd:	ff 75 0c             	pushl  0xc(%ebp)
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	68 5c 01 80 00       	push   $0x80015c
  8001cf:	e8 4a 01 00 00       	call   80031e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d4:	83 c4 08             	add    $0x8,%esp
  8001d7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e3:	50                   	push   %eax
  8001e4:	e8 9d 0a 00 00       	call   800c86 <sys_cputs>

	return b.cnt;
}
  8001e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fa:	50                   	push   %eax
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 9d ff ff ff       	call   8001a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	57                   	push   %edi
  800209:	56                   	push   %esi
  80020a:	53                   	push   %ebx
  80020b:	83 ec 1c             	sub    $0x1c,%esp
  80020e:	89 c6                	mov    %eax,%esi
  800210:	89 d7                	mov    %edx,%edi
  800212:	8b 45 08             	mov    0x8(%ebp),%eax
  800215:	8b 55 0c             	mov    0xc(%ebp),%edx
  800218:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021e:	8b 45 10             	mov    0x10(%ebp),%eax
  800221:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800224:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800228:	74 2c                	je     800256 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80022a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800234:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800237:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023a:	39 c2                	cmp    %eax,%edx
  80023c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023f:	73 43                	jae    800284 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800241:	83 eb 01             	sub    $0x1,%ebx
  800244:	85 db                	test   %ebx,%ebx
  800246:	7e 6c                	jle    8002b4 <printnum+0xaf>
				putch(padc, putdat);
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	57                   	push   %edi
  80024c:	ff 75 18             	pushl  0x18(%ebp)
  80024f:	ff d6                	call   *%esi
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	eb eb                	jmp    800241 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 20                	push   $0x20
  80025b:	6a 00                	push   $0x0
  80025d:	50                   	push   %eax
  80025e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800261:	ff 75 e0             	pushl  -0x20(%ebp)
  800264:	89 fa                	mov    %edi,%edx
  800266:	89 f0                	mov    %esi,%eax
  800268:	e8 98 ff ff ff       	call   800205 <printnum>
		while (--width > 0)
  80026d:	83 c4 20             	add    $0x20,%esp
  800270:	83 eb 01             	sub    $0x1,%ebx
  800273:	85 db                	test   %ebx,%ebx
  800275:	7e 65                	jle    8002dc <printnum+0xd7>
			putch(padc, putdat);
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	57                   	push   %edi
  80027b:	6a 20                	push   $0x20
  80027d:	ff d6                	call   *%esi
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	eb ec                	jmp    800270 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	ff 75 18             	pushl  0x18(%ebp)
  80028a:	83 eb 01             	sub    $0x1,%ebx
  80028d:	53                   	push   %ebx
  80028e:	50                   	push   %eax
  80028f:	83 ec 08             	sub    $0x8,%esp
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029b:	ff 75 e0             	pushl  -0x20(%ebp)
  80029e:	e8 8d 12 00 00       	call   801530 <__udivdi3>
  8002a3:	83 c4 18             	add    $0x18,%esp
  8002a6:	52                   	push   %edx
  8002a7:	50                   	push   %eax
  8002a8:	89 fa                	mov    %edi,%edx
  8002aa:	89 f0                	mov    %esi,%eax
  8002ac:	e8 54 ff ff ff       	call   800205 <printnum>
  8002b1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	57                   	push   %edi
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002be:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c7:	e8 74 13 00 00       	call   801640 <__umoddi3>
  8002cc:	83 c4 14             	add    $0x14,%esp
  8002cf:	0f be 80 20 18 80 00 	movsbl 0x801820(%eax),%eax
  8002d6:	50                   	push   %eax
  8002d7:	ff d6                	call   *%esi
  8002d9:	83 c4 10             	add    $0x10,%esp
	}
}
  8002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002df:	5b                   	pop    %ebx
  8002e0:	5e                   	pop    %esi
  8002e1:	5f                   	pop    %edi
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f3:	73 0a                	jae    8002ff <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f8:	89 08                	mov    %ecx,(%eax)
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	88 02                	mov    %al,(%edx)
}
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <printfmt>:
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800307:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030a:	50                   	push   %eax
  80030b:	ff 75 10             	pushl  0x10(%ebp)
  80030e:	ff 75 0c             	pushl  0xc(%ebp)
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 05 00 00 00       	call   80031e <vprintfmt>
}
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vprintfmt>:
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	57                   	push   %edi
  800322:	56                   	push   %esi
  800323:	53                   	push   %ebx
  800324:	83 ec 3c             	sub    $0x3c,%esp
  800327:	8b 75 08             	mov    0x8(%ebp),%esi
  80032a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800330:	e9 32 04 00 00       	jmp    800767 <vprintfmt+0x449>
		padc = ' ';
  800335:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800339:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800340:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800347:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800355:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8d 47 01             	lea    0x1(%edi),%eax
  800364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800367:	0f b6 17             	movzbl (%edi),%edx
  80036a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036d:	3c 55                	cmp    $0x55,%al
  80036f:	0f 87 12 05 00 00    	ja     800887 <vprintfmt+0x569>
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	ff 24 85 00 1a 80 00 	jmp    *0x801a00(,%eax,4)
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800382:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800386:	eb d9                	jmp    800361 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038f:	eb d0                	jmp    800361 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	0f b6 d2             	movzbl %dl,%edx
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800397:	b8 00 00 00 00       	mov    $0x0,%eax
  80039c:	89 75 08             	mov    %esi,0x8(%ebp)
  80039f:	eb 03                	jmp    8003a4 <vprintfmt+0x86>
  8003a1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ab:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ae:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b1:	83 fe 09             	cmp    $0x9,%esi
  8003b4:	76 eb                	jbe    8003a1 <vprintfmt+0x83>
  8003b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bc:	eb 14                	jmp    8003d2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8d 40 04             	lea    0x4(%eax),%eax
  8003cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d6:	79 89                	jns    800361 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e5:	e9 77 ff ff ff       	jmp    800361 <vprintfmt+0x43>
  8003ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	0f 48 c1             	cmovs  %ecx,%eax
  8003f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f8:	e9 64 ff ff ff       	jmp    800361 <vprintfmt+0x43>
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800400:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800407:	e9 55 ff ff ff       	jmp    800361 <vprintfmt+0x43>
			lflag++;
  80040c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800413:	e9 49 ff ff ff       	jmp    800361 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8d 78 04             	lea    0x4(%eax),%edi
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	53                   	push   %ebx
  800422:	ff 30                	pushl  (%eax)
  800424:	ff d6                	call   *%esi
			break;
  800426:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800429:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042c:	e9 33 03 00 00       	jmp    800764 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8d 78 04             	lea    0x4(%eax),%edi
  800437:	8b 00                	mov    (%eax),%eax
  800439:	99                   	cltd   
  80043a:	31 d0                	xor    %edx,%eax
  80043c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043e:	83 f8 0f             	cmp    $0xf,%eax
  800441:	7f 23                	jg     800466 <vprintfmt+0x148>
  800443:	8b 14 85 60 1b 80 00 	mov    0x801b60(,%eax,4),%edx
  80044a:	85 d2                	test   %edx,%edx
  80044c:	74 18                	je     800466 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044e:	52                   	push   %edx
  80044f:	68 41 18 80 00       	push   $0x801841
  800454:	53                   	push   %ebx
  800455:	56                   	push   %esi
  800456:	e8 a6 fe ff ff       	call   800301 <printfmt>
  80045b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800461:	e9 fe 02 00 00       	jmp    800764 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800466:	50                   	push   %eax
  800467:	68 38 18 80 00       	push   $0x801838
  80046c:	53                   	push   %ebx
  80046d:	56                   	push   %esi
  80046e:	e8 8e fe ff ff       	call   800301 <printfmt>
  800473:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800476:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800479:	e9 e6 02 00 00       	jmp    800764 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	83 c0 04             	add    $0x4,%eax
  800484:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800487:	8b 45 14             	mov    0x14(%ebp),%eax
  80048a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80048c:	85 c9                	test   %ecx,%ecx
  80048e:	b8 31 18 80 00       	mov    $0x801831,%eax
  800493:	0f 45 c1             	cmovne %ecx,%eax
  800496:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800499:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049d:	7e 06                	jle    8004a5 <vprintfmt+0x187>
  80049f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a3:	75 0d                	jne    8004b2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a8:	89 c7                	mov    %eax,%edi
  8004aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b0:	eb 53                	jmp    800505 <vprintfmt+0x1e7>
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b8:	50                   	push   %eax
  8004b9:	e8 71 04 00 00       	call   80092f <strnlen>
  8004be:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c1:	29 c1                	sub    %eax,%ecx
  8004c3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004cb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d2:	eb 0f                	jmp    8004e3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	53                   	push   %ebx
  8004d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004db:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dd:	83 ef 01             	sub    $0x1,%edi
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	85 ff                	test   %edi,%edi
  8004e5:	7f ed                	jg     8004d4 <vprintfmt+0x1b6>
  8004e7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004ea:	85 c9                	test   %ecx,%ecx
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	0f 49 c1             	cmovns %ecx,%eax
  8004f4:	29 c1                	sub    %eax,%ecx
  8004f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f9:	eb aa                	jmp    8004a5 <vprintfmt+0x187>
					putch(ch, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	52                   	push   %edx
  800500:	ff d6                	call   *%esi
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800508:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800511:	0f be d0             	movsbl %al,%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	74 4b                	je     800563 <vprintfmt+0x245>
  800518:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051c:	78 06                	js     800524 <vprintfmt+0x206>
  80051e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800522:	78 1e                	js     800542 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800528:	74 d1                	je     8004fb <vprintfmt+0x1dd>
  80052a:	0f be c0             	movsbl %al,%eax
  80052d:	83 e8 20             	sub    $0x20,%eax
  800530:	83 f8 5e             	cmp    $0x5e,%eax
  800533:	76 c6                	jbe    8004fb <vprintfmt+0x1dd>
					putch('?', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 3f                	push   $0x3f
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb c3                	jmp    800505 <vprintfmt+0x1e7>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb 0e                	jmp    800554 <vprintfmt+0x236>
				putch(' ', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 20                	push   $0x20
  80054c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ee                	jg     800546 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800558:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	e9 01 02 00 00       	jmp    800764 <vprintfmt+0x446>
  800563:	89 cf                	mov    %ecx,%edi
  800565:	eb ed                	jmp    800554 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80056a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800571:	e9 eb fd ff ff       	jmp    800361 <vprintfmt+0x43>
	if (lflag >= 2)
  800576:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80057a:	7f 21                	jg     80059d <vprintfmt+0x27f>
	else if (lflag)
  80057c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800580:	74 68                	je     8005ea <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058a:	89 c1                	mov    %eax,%ecx
  80058c:	c1 f9 1f             	sar    $0x1f,%ecx
  80058f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
  80059b:	eb 17                	jmp    8005b4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 50 04             	mov    0x4(%eax),%edx
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8d 40 08             	lea    0x8(%eax),%eax
  8005b1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c4:	78 3f                	js     800605 <vprintfmt+0x2e7>
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005cb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005cf:	0f 84 71 01 00 00    	je     800746 <vprintfmt+0x428>
				putch('+', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 2b                	push   $0x2b
  8005db:	ff d6                	call   *%esi
  8005dd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e5:	e9 5c 01 00 00       	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
  800603:	eb af                	jmp    8005b4 <vprintfmt+0x296>
				putch('-', putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	6a 2d                	push   $0x2d
  80060b:	ff d6                	call   *%esi
				num = -(long long) num;
  80060d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800610:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800613:	f7 d8                	neg    %eax
  800615:	83 d2 00             	adc    $0x0,%edx
  800618:	f7 da                	neg    %edx
  80061a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800620:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800623:	b8 0a 00 00 00       	mov    $0xa,%eax
  800628:	e9 19 01 00 00       	jmp    800746 <vprintfmt+0x428>
	if (lflag >= 2)
  80062d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800631:	7f 29                	jg     80065c <vprintfmt+0x33e>
	else if (lflag)
  800633:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800637:	74 44                	je     80067d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	ba 00 00 00 00       	mov    $0x0,%edx
  800643:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800646:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	e9 ea 00 00 00       	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 50 04             	mov    0x4(%eax),%edx
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 08             	lea    0x8(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800673:	b8 0a 00 00 00       	mov    $0xa,%eax
  800678:	e9 c9 00 00 00       	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800696:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069b:	e9 a6 00 00 00       	jmp    800746 <vprintfmt+0x428>
			putch('0', putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 30                	push   $0x30
  8006a6:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006af:	7f 26                	jg     8006d7 <vprintfmt+0x3b9>
	else if (lflag)
  8006b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b5:	74 3e                	je     8006f5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d5:	eb 6f                	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 50 04             	mov    0x4(%eax),%edx
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 40 08             	lea    0x8(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f3:	eb 51                	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  800713:	eb 31                	jmp    800746 <vprintfmt+0x428>
			putch('0', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 30                	push   $0x30
  80071b:	ff d6                	call   *%esi
			putch('x', putdat);
  80071d:	83 c4 08             	add    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 78                	push   $0x78
  800723:	ff d6                	call   *%esi
			num = (unsigned long long)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	ba 00 00 00 00       	mov    $0x0,%edx
  80072f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800732:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800735:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800741:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800746:	83 ec 0c             	sub    $0xc,%esp
  800749:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074d:	52                   	push   %edx
  80074e:	ff 75 e0             	pushl  -0x20(%ebp)
  800751:	50                   	push   %eax
  800752:	ff 75 dc             	pushl  -0x24(%ebp)
  800755:	ff 75 d8             	pushl  -0x28(%ebp)
  800758:	89 da                	mov    %ebx,%edx
  80075a:	89 f0                	mov    %esi,%eax
  80075c:	e8 a4 fa ff ff       	call   800205 <printnum>
			break;
  800761:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	83 c7 01             	add    $0x1,%edi
  80076a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076e:	83 f8 25             	cmp    $0x25,%eax
  800771:	0f 84 be fb ff ff    	je     800335 <vprintfmt+0x17>
			if (ch == '\0')
  800777:	85 c0                	test   %eax,%eax
  800779:	0f 84 28 01 00 00    	je     8008a7 <vprintfmt+0x589>
			putch(ch, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	50                   	push   %eax
  800784:	ff d6                	call   *%esi
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	eb dc                	jmp    800767 <vprintfmt+0x449>
	if (lflag >= 2)
  80078b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078f:	7f 26                	jg     8007b7 <vprintfmt+0x499>
	else if (lflag)
  800791:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800795:	74 41                	je     8007d8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b5:	eb 8f                	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 50 04             	mov    0x4(%eax),%edx
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 08             	lea    0x8(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d3:	e9 6e ff ff ff       	jmp    800746 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f6:	e9 4b ff ff ff       	jmp    800746 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	83 c0 04             	add    $0x4,%eax
  800801:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	85 c0                	test   %eax,%eax
  80080b:	74 14                	je     800821 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080d:	8b 13                	mov    (%ebx),%edx
  80080f:	83 fa 7f             	cmp    $0x7f,%edx
  800812:	7f 37                	jg     80084b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800814:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	e9 43 ff ff ff       	jmp    800764 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800821:	b8 0a 00 00 00       	mov    $0xa,%eax
  800826:	bf 59 19 80 00       	mov    $0x801959,%edi
							putch(ch, putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	50                   	push   %eax
  800830:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800832:	83 c7 01             	add    $0x1,%edi
  800835:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 c0                	test   %eax,%eax
  80083e:	75 eb                	jne    80082b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800840:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	e9 19 ff ff ff       	jmp    800764 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80084b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800852:	bf 91 19 80 00       	mov    $0x801991,%edi
							putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	50                   	push   %eax
  80085c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085e:	83 c7 01             	add    $0x1,%edi
  800861:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	85 c0                	test   %eax,%eax
  80086a:	75 eb                	jne    800857 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80086c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	e9 ed fe ff ff       	jmp    800764 <vprintfmt+0x446>
			putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	6a 25                	push   $0x25
  80087d:	ff d6                	call   *%esi
			break;
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	e9 dd fe ff ff       	jmp    800764 <vprintfmt+0x446>
			putch('%', putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	6a 25                	push   $0x25
  80088d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	89 f8                	mov    %edi,%eax
  800894:	eb 03                	jmp    800899 <vprintfmt+0x57b>
  800896:	83 e8 01             	sub    $0x1,%eax
  800899:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089d:	75 f7                	jne    800896 <vprintfmt+0x578>
  80089f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a2:	e9 bd fe ff ff       	jmp    800764 <vprintfmt+0x446>
}
  8008a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008aa:	5b                   	pop    %ebx
  8008ab:	5e                   	pop    %esi
  8008ac:	5f                   	pop    %edi
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 18             	sub    $0x18,%esp
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008be:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	74 26                	je     8008f6 <vsnprintf+0x47>
  8008d0:	85 d2                	test   %edx,%edx
  8008d2:	7e 22                	jle    8008f6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d4:	ff 75 14             	pushl  0x14(%ebp)
  8008d7:	ff 75 10             	pushl  0x10(%ebp)
  8008da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	68 e4 02 80 00       	push   $0x8002e4
  8008e3:	e8 36 fa ff ff       	call   80031e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f1:	83 c4 10             	add    $0x10,%esp
}
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    
		return -E_INVAL;
  8008f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fb:	eb f7                	jmp    8008f4 <vsnprintf+0x45>

008008fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800903:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800906:	50                   	push   %eax
  800907:	ff 75 10             	pushl  0x10(%ebp)
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 9a ff ff ff       	call   8008af <vsnprintf>
	va_end(ap);

	return rc;
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
  800922:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800926:	74 05                	je     80092d <strlen+0x16>
		n++;
  800928:	83 c0 01             	add    $0x1,%eax
  80092b:	eb f5                	jmp    800922 <strlen+0xb>
	return n;
}
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800935:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800938:	ba 00 00 00 00       	mov    $0x0,%edx
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	74 0d                	je     80094e <strnlen+0x1f>
  800941:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800945:	74 05                	je     80094c <strnlen+0x1d>
		n++;
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	eb f1                	jmp    80093d <strnlen+0xe>
  80094c:	89 d0                	mov    %edx,%eax
	return n;
}
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	53                   	push   %ebx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800963:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800966:	83 c2 01             	add    $0x1,%edx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 f2                	jne    80095f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096d:	5b                   	pop    %ebx
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	53                   	push   %ebx
  800974:	83 ec 10             	sub    $0x10,%esp
  800977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097a:	53                   	push   %ebx
  80097b:	e8 97 ff ff ff       	call   800917 <strlen>
  800980:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	01 d8                	add    %ebx,%eax
  800988:	50                   	push   %eax
  800989:	e8 c2 ff ff ff       	call   800950 <strcpy>
	return dst;
}
  80098e:	89 d8                	mov    %ebx,%eax
  800990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a0:	89 c6                	mov    %eax,%esi
  8009a2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	39 f2                	cmp    %esi,%edx
  8009a9:	74 11                	je     8009bc <strncpy+0x27>
		*dst++ = *src;
  8009ab:	83 c2 01             	add    $0x1,%edx
  8009ae:	0f b6 19             	movzbl (%ecx),%ebx
  8009b1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b4:	80 fb 01             	cmp    $0x1,%bl
  8009b7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009ba:	eb eb                	jmp    8009a7 <strncpy+0x12>
	}
	return ret;
}
  8009bc:	5b                   	pop    %ebx
  8009bd:	5e                   	pop    %esi
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	56                   	push   %esi
  8009c4:	53                   	push   %ebx
  8009c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cb:	8b 55 10             	mov    0x10(%ebp),%edx
  8009ce:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	74 21                	je     8009f5 <strlcpy+0x35>
  8009d4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009da:	39 c2                	cmp    %eax,%edx
  8009dc:	74 14                	je     8009f2 <strlcpy+0x32>
  8009de:	0f b6 19             	movzbl (%ecx),%ebx
  8009e1:	84 db                	test   %bl,%bl
  8009e3:	74 0b                	je     8009f0 <strlcpy+0x30>
			*dst++ = *src++;
  8009e5:	83 c1 01             	add    $0x1,%ecx
  8009e8:	83 c2 01             	add    $0x1,%edx
  8009eb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ee:	eb ea                	jmp    8009da <strlcpy+0x1a>
  8009f0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f5:	29 f0                	sub    %esi,%eax
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5e                   	pop    %esi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a04:	0f b6 01             	movzbl (%ecx),%eax
  800a07:	84 c0                	test   %al,%al
  800a09:	74 0c                	je     800a17 <strcmp+0x1c>
  800a0b:	3a 02                	cmp    (%edx),%al
  800a0d:	75 08                	jne    800a17 <strcmp+0x1c>
		p++, q++;
  800a0f:	83 c1 01             	add    $0x1,%ecx
  800a12:	83 c2 01             	add    $0x1,%edx
  800a15:	eb ed                	jmp    800a04 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a17:	0f b6 c0             	movzbl %al,%eax
  800a1a:	0f b6 12             	movzbl (%edx),%edx
  800a1d:	29 d0                	sub    %edx,%eax
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c3                	mov    %eax,%ebx
  800a2d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a30:	eb 06                	jmp    800a38 <strncmp+0x17>
		n--, p++, q++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a38:	39 d8                	cmp    %ebx,%eax
  800a3a:	74 16                	je     800a52 <strncmp+0x31>
  800a3c:	0f b6 08             	movzbl (%eax),%ecx
  800a3f:	84 c9                	test   %cl,%cl
  800a41:	74 04                	je     800a47 <strncmp+0x26>
  800a43:	3a 0a                	cmp    (%edx),%cl
  800a45:	74 eb                	je     800a32 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a47:	0f b6 00             	movzbl (%eax),%eax
  800a4a:	0f b6 12             	movzbl (%edx),%edx
  800a4d:	29 d0                	sub    %edx,%eax
}
  800a4f:	5b                   	pop    %ebx
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
  800a57:	eb f6                	jmp    800a4f <strncmp+0x2e>

00800a59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a63:	0f b6 10             	movzbl (%eax),%edx
  800a66:	84 d2                	test   %dl,%dl
  800a68:	74 09                	je     800a73 <strchr+0x1a>
		if (*s == c)
  800a6a:	38 ca                	cmp    %cl,%dl
  800a6c:	74 0a                	je     800a78 <strchr+0x1f>
	for (; *s; s++)
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	eb f0                	jmp    800a63 <strchr+0xa>
			return (char *) s;
	return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a84:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	74 09                	je     800a94 <strfind+0x1a>
  800a8b:	84 d2                	test   %dl,%dl
  800a8d:	74 05                	je     800a94 <strfind+0x1a>
	for (; *s; s++)
  800a8f:	83 c0 01             	add    $0x1,%eax
  800a92:	eb f0                	jmp    800a84 <strfind+0xa>
			break;
	return (char *) s;
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa2:	85 c9                	test   %ecx,%ecx
  800aa4:	74 31                	je     800ad7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa6:	89 f8                	mov    %edi,%eax
  800aa8:	09 c8                	or     %ecx,%eax
  800aaa:	a8 03                	test   $0x3,%al
  800aac:	75 23                	jne    800ad1 <memset+0x3b>
		c &= 0xFF;
  800aae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab2:	89 d3                	mov    %edx,%ebx
  800ab4:	c1 e3 08             	shl    $0x8,%ebx
  800ab7:	89 d0                	mov    %edx,%eax
  800ab9:	c1 e0 18             	shl    $0x18,%eax
  800abc:	89 d6                	mov    %edx,%esi
  800abe:	c1 e6 10             	shl    $0x10,%esi
  800ac1:	09 f0                	or     %esi,%eax
  800ac3:	09 c2                	or     %eax,%edx
  800ac5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	fc                   	cld    
  800acd:	f3 ab                	rep stos %eax,%es:(%edi)
  800acf:	eb 06                	jmp    800ad7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad4:	fc                   	cld    
  800ad5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad7:	89 f8                	mov    %edi,%eax
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	57                   	push   %edi
  800ae2:	56                   	push   %esi
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aec:	39 c6                	cmp    %eax,%esi
  800aee:	73 32                	jae    800b22 <memmove+0x44>
  800af0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af3:	39 c2                	cmp    %eax,%edx
  800af5:	76 2b                	jbe    800b22 <memmove+0x44>
		s += n;
		d += n;
  800af7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afa:	89 fe                	mov    %edi,%esi
  800afc:	09 ce                	or     %ecx,%esi
  800afe:	09 d6                	or     %edx,%esi
  800b00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b06:	75 0e                	jne    800b16 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b08:	83 ef 04             	sub    $0x4,%edi
  800b0b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b11:	fd                   	std    
  800b12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b14:	eb 09                	jmp    800b1f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b16:	83 ef 01             	sub    $0x1,%edi
  800b19:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1c:	fd                   	std    
  800b1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1f:	fc                   	cld    
  800b20:	eb 1a                	jmp    800b3c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b22:	89 c2                	mov    %eax,%edx
  800b24:	09 ca                	or     %ecx,%edx
  800b26:	09 f2                	or     %esi,%edx
  800b28:	f6 c2 03             	test   $0x3,%dl
  800b2b:	75 0a                	jne    800b37 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b30:	89 c7                	mov    %eax,%edi
  800b32:	fc                   	cld    
  800b33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b35:	eb 05                	jmp    800b3c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b37:	89 c7                	mov    %eax,%edi
  800b39:	fc                   	cld    
  800b3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3c:	5e                   	pop    %esi
  800b3d:	5f                   	pop    %edi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	ff 75 08             	pushl  0x8(%ebp)
  800b4f:	e8 8a ff ff ff       	call   800ade <memmove>
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b61:	89 c6                	mov    %eax,%esi
  800b63:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b66:	39 f0                	cmp    %esi,%eax
  800b68:	74 1c                	je     800b86 <memcmp+0x30>
		if (*s1 != *s2)
  800b6a:	0f b6 08             	movzbl (%eax),%ecx
  800b6d:	0f b6 1a             	movzbl (%edx),%ebx
  800b70:	38 d9                	cmp    %bl,%cl
  800b72:	75 08                	jne    800b7c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b74:	83 c0 01             	add    $0x1,%eax
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	eb ea                	jmp    800b66 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b7c:	0f b6 c1             	movzbl %cl,%eax
  800b7f:	0f b6 db             	movzbl %bl,%ebx
  800b82:	29 d8                	sub    %ebx,%eax
  800b84:	eb 05                	jmp    800b8b <memcmp+0x35>
	}

	return 0;
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b98:	89 c2                	mov    %eax,%edx
  800b9a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9d:	39 d0                	cmp    %edx,%eax
  800b9f:	73 09                	jae    800baa <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba1:	38 08                	cmp    %cl,(%eax)
  800ba3:	74 05                	je     800baa <memfind+0x1b>
	for (; s < ends; s++)
  800ba5:	83 c0 01             	add    $0x1,%eax
  800ba8:	eb f3                	jmp    800b9d <memfind+0xe>
			break;
	return (void *) s;
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb8:	eb 03                	jmp    800bbd <strtol+0x11>
		s++;
  800bba:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bbd:	0f b6 01             	movzbl (%ecx),%eax
  800bc0:	3c 20                	cmp    $0x20,%al
  800bc2:	74 f6                	je     800bba <strtol+0xe>
  800bc4:	3c 09                	cmp    $0x9,%al
  800bc6:	74 f2                	je     800bba <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc8:	3c 2b                	cmp    $0x2b,%al
  800bca:	74 2a                	je     800bf6 <strtol+0x4a>
	int neg = 0;
  800bcc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd1:	3c 2d                	cmp    $0x2d,%al
  800bd3:	74 2b                	je     800c00 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bdb:	75 0f                	jne    800bec <strtol+0x40>
  800bdd:	80 39 30             	cmpb   $0x30,(%ecx)
  800be0:	74 28                	je     800c0a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be9:	0f 44 d8             	cmove  %eax,%ebx
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf4:	eb 50                	jmp    800c46 <strtol+0x9a>
		s++;
  800bf6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	eb d5                	jmp    800bd5 <strtol+0x29>
		s++, neg = 1;
  800c00:	83 c1 01             	add    $0x1,%ecx
  800c03:	bf 01 00 00 00       	mov    $0x1,%edi
  800c08:	eb cb                	jmp    800bd5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0e:	74 0e                	je     800c1e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c10:	85 db                	test   %ebx,%ebx
  800c12:	75 d8                	jne    800bec <strtol+0x40>
		s++, base = 8;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1c:	eb ce                	jmp    800bec <strtol+0x40>
		s += 2, base = 16;
  800c1e:	83 c1 02             	add    $0x2,%ecx
  800c21:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c26:	eb c4                	jmp    800bec <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c28:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2b:	89 f3                	mov    %esi,%ebx
  800c2d:	80 fb 19             	cmp    $0x19,%bl
  800c30:	77 29                	ja     800c5b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c32:	0f be d2             	movsbl %dl,%edx
  800c35:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c38:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3b:	7d 30                	jge    800c6d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3d:	83 c1 01             	add    $0x1,%ecx
  800c40:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c46:	0f b6 11             	movzbl (%ecx),%edx
  800c49:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4c:	89 f3                	mov    %esi,%ebx
  800c4e:	80 fb 09             	cmp    $0x9,%bl
  800c51:	77 d5                	ja     800c28 <strtol+0x7c>
			dig = *s - '0';
  800c53:	0f be d2             	movsbl %dl,%edx
  800c56:	83 ea 30             	sub    $0x30,%edx
  800c59:	eb dd                	jmp    800c38 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5e:	89 f3                	mov    %esi,%ebx
  800c60:	80 fb 19             	cmp    $0x19,%bl
  800c63:	77 08                	ja     800c6d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c65:	0f be d2             	movsbl %dl,%edx
  800c68:	83 ea 37             	sub    $0x37,%edx
  800c6b:	eb cb                	jmp    800c38 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c71:	74 05                	je     800c78 <strtol+0xcc>
		*endptr = (char *) s;
  800c73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c76:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	f7 da                	neg    %edx
  800c7c:	85 ff                	test   %edi,%edi
  800c7e:	0f 45 c2             	cmovne %edx,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c97:	89 c3                	mov    %eax,%ebx
  800c99:	89 c7                	mov    %eax,%edi
  800c9b:	89 c6                	mov    %eax,%esi
  800c9d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd9:	89 cb                	mov    %ecx,%ebx
  800cdb:	89 cf                	mov    %ecx,%edi
  800cdd:	89 ce                	mov    %ecx,%esi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ced:	83 ec 0c             	sub    $0xc,%esp
  800cf0:	50                   	push   %eax
  800cf1:	6a 03                	push   $0x3
  800cf3:	68 a0 1b 80 00       	push   $0x801ba0
  800cf8:	6a 43                	push   $0x43
  800cfa:	68 bd 1b 80 00       	push   $0x801bbd
  800cff:	e8 28 07 00 00       	call   80142c <_panic>

00800d04 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	b8 02 00 00 00       	mov    $0x2,%eax
  800d14:	89 d1                	mov    %edx,%ecx
  800d16:	89 d3                	mov    %edx,%ebx
  800d18:	89 d7                	mov    %edx,%edi
  800d1a:	89 d6                	mov    %edx,%esi
  800d1c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_yield>:

void
sys_yield(void)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d33:	89 d1                	mov    %edx,%ecx
  800d35:	89 d3                	mov    %edx,%ebx
  800d37:	89 d7                	mov    %edx,%edi
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
  800d48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4b:	be 00 00 00 00       	mov    $0x0,%esi
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	89 f7                	mov    %esi,%edi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 04                	push   $0x4
  800d74:	68 a0 1b 80 00       	push   $0x801ba0
  800d79:	6a 43                	push   $0x43
  800d7b:	68 bd 1b 80 00       	push   $0x801bbd
  800d80:	e8 a7 06 00 00       	call   80142c <_panic>

00800d85 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 05 00 00 00       	mov    $0x5,%eax
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9f:	8b 75 18             	mov    0x18(%ebp),%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 05                	push   $0x5
  800db6:	68 a0 1b 80 00       	push   $0x801ba0
  800dbb:	6a 43                	push   $0x43
  800dbd:	68 bd 1b 80 00       	push   $0x801bbd
  800dc2:	e8 65 06 00 00       	call   80142c <_panic>

00800dc7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	b8 06 00 00 00       	mov    $0x6,%eax
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 06                	push   $0x6
  800df8:	68 a0 1b 80 00       	push   $0x801ba0
  800dfd:	6a 43                	push   $0x43
  800dff:	68 bd 1b 80 00       	push   $0x801bbd
  800e04:	e8 23 06 00 00       	call   80142c <_panic>

00800e09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e22:	89 df                	mov    %ebx,%edi
  800e24:	89 de                	mov    %ebx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 08                	push   $0x8
  800e3a:	68 a0 1b 80 00       	push   $0x801ba0
  800e3f:	6a 43                	push   $0x43
  800e41:	68 bd 1b 80 00       	push   $0x801bbd
  800e46:	e8 e1 05 00 00       	call   80142c <_panic>

00800e4b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 09                	push   $0x9
  800e7c:	68 a0 1b 80 00       	push   $0x801ba0
  800e81:	6a 43                	push   $0x43
  800e83:	68 bd 1b 80 00       	push   $0x801bbd
  800e88:	e8 9f 05 00 00       	call   80142c <_panic>

00800e8d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7f 08                	jg     800eb8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	50                   	push   %eax
  800ebc:	6a 0a                	push   $0xa
  800ebe:	68 a0 1b 80 00       	push   $0x801ba0
  800ec3:	6a 43                	push   $0x43
  800ec5:	68 bd 1b 80 00       	push   $0x801bbd
  800eca:	e8 5d 05 00 00       	call   80142c <_panic>

00800ecf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f08:	89 cb                	mov    %ecx,%ebx
  800f0a:	89 cf                	mov    %ecx,%edi
  800f0c:	89 ce                	mov    %ecx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 0d                	push   $0xd
  800f22:	68 a0 1b 80 00       	push   $0x801ba0
  800f27:	6a 43                	push   $0x43
  800f29:	68 bd 1b 80 00       	push   $0x801bbd
  800f2e:	e8 f9 04 00 00       	call   80142c <_panic>

00800f33 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f44:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f49:	89 df                	mov    %ebx,%edi
  800f4b:	89 de                	mov    %ebx,%esi
  800f4d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f67:	89 cb                	mov    %ecx,%ebx
  800f69:	89 cf                	mov    %ecx,%edi
  800f6b:	89 ce                	mov    %ecx,%esi
  800f6d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	53                   	push   %ebx
  800f78:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  800f7b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f82:	83 e1 07             	and    $0x7,%ecx
  800f85:	83 f9 07             	cmp    $0x7,%ecx
  800f88:	74 32                	je     800fbc <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  800f8a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f91:	81 e1 05 08 00 00    	and    $0x805,%ecx
  800f97:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  800f9d:	74 7d                	je     80101c <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  800f9f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fa6:	83 e1 05             	and    $0x5,%ecx
  800fa9:	83 f9 05             	cmp    $0x5,%ecx
  800fac:	0f 84 9e 00 00 00    	je     801050 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  800fbc:	89 d3                	mov    %edx,%ebx
  800fbe:	c1 e3 0c             	shl    $0xc,%ebx
  800fc1:	83 ec 0c             	sub    $0xc,%esp
  800fc4:	68 05 08 00 00       	push   $0x805
  800fc9:	53                   	push   %ebx
  800fca:	50                   	push   %eax
  800fcb:	53                   	push   %ebx
  800fcc:	6a 00                	push   $0x0
  800fce:	e8 b2 fd ff ff       	call   800d85 <sys_page_map>
		if(r < 0)
  800fd3:	83 c4 20             	add    $0x20,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 2e                	js     801008 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	68 05 08 00 00       	push   $0x805
  800fe2:	53                   	push   %ebx
  800fe3:	6a 00                	push   $0x0
  800fe5:	53                   	push   %ebx
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 98 fd ff ff       	call   800d85 <sys_page_map>
		if(r < 0)
  800fed:	83 c4 20             	add    $0x20,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	79 be                	jns    800fb2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	68 cb 1b 80 00       	push   $0x801bcb
  800ffc:	6a 57                	push   $0x57
  800ffe:	68 e1 1b 80 00       	push   $0x801be1
  801003:	e8 24 04 00 00       	call   80142c <_panic>
			panic("sys_page_map() panic\n");
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	68 cb 1b 80 00       	push   $0x801bcb
  801010:	6a 53                	push   $0x53
  801012:	68 e1 1b 80 00       	push   $0x801be1
  801017:	e8 10 04 00 00       	call   80142c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80101c:	c1 e2 0c             	shl    $0xc,%edx
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	68 05 08 00 00       	push   $0x805
  801027:	52                   	push   %edx
  801028:	50                   	push   %eax
  801029:	52                   	push   %edx
  80102a:	6a 00                	push   $0x0
  80102c:	e8 54 fd ff ff       	call   800d85 <sys_page_map>
		if(r < 0)
  801031:	83 c4 20             	add    $0x20,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	0f 89 76 ff ff ff    	jns    800fb2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	68 cb 1b 80 00       	push   $0x801bcb
  801044:	6a 5e                	push   $0x5e
  801046:	68 e1 1b 80 00       	push   $0x801be1
  80104b:	e8 dc 03 00 00       	call   80142c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801050:	c1 e2 0c             	shl    $0xc,%edx
  801053:	83 ec 0c             	sub    $0xc,%esp
  801056:	6a 05                	push   $0x5
  801058:	52                   	push   %edx
  801059:	50                   	push   %eax
  80105a:	52                   	push   %edx
  80105b:	6a 00                	push   $0x0
  80105d:	e8 23 fd ff ff       	call   800d85 <sys_page_map>
		if(r < 0)
  801062:	83 c4 20             	add    $0x20,%esp
  801065:	85 c0                	test   %eax,%eax
  801067:	0f 89 45 ff ff ff    	jns    800fb2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	68 cb 1b 80 00       	push   $0x801bcb
  801075:	6a 65                	push   $0x65
  801077:	68 e1 1b 80 00       	push   $0x801be1
  80107c:	e8 ab 03 00 00       	call   80142c <_panic>

00801081 <pgfault>:
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	53                   	push   %ebx
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80108b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80108d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801091:	0f 84 99 00 00 00    	je     801130 <pgfault+0xaf>
  801097:	89 c2                	mov    %eax,%edx
  801099:	c1 ea 16             	shr    $0x16,%edx
  80109c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a3:	f6 c2 01             	test   $0x1,%dl
  8010a6:	0f 84 84 00 00 00    	je     801130 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8010ac:	89 c2                	mov    %eax,%edx
  8010ae:	c1 ea 0c             	shr    $0xc,%edx
  8010b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b8:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010be:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8010c4:	75 6a                	jne    801130 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8010c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cb:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8010cd:	83 ec 04             	sub    $0x4,%esp
  8010d0:	6a 07                	push   $0x7
  8010d2:	68 00 f0 7f 00       	push   $0x7ff000
  8010d7:	6a 00                	push   $0x0
  8010d9:	e8 64 fc ff ff       	call   800d42 <sys_page_alloc>
	if(ret < 0)
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	78 5f                	js     801144 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8010e5:	83 ec 04             	sub    $0x4,%esp
  8010e8:	68 00 10 00 00       	push   $0x1000
  8010ed:	53                   	push   %ebx
  8010ee:	68 00 f0 7f 00       	push   $0x7ff000
  8010f3:	e8 48 fa ff ff       	call   800b40 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8010f8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010ff:	53                   	push   %ebx
  801100:	6a 00                	push   $0x0
  801102:	68 00 f0 7f 00       	push   $0x7ff000
  801107:	6a 00                	push   $0x0
  801109:	e8 77 fc ff ff       	call   800d85 <sys_page_map>
	if(ret < 0)
  80110e:	83 c4 20             	add    $0x20,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	78 43                	js     801158 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	68 00 f0 7f 00       	push   $0x7ff000
  80111d:	6a 00                	push   $0x0
  80111f:	e8 a3 fc ff ff       	call   800dc7 <sys_page_unmap>
	if(ret < 0)
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 41                	js     80116c <pgfault+0xeb>
}
  80112b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801130:	83 ec 04             	sub    $0x4,%esp
  801133:	68 ec 1b 80 00       	push   $0x801bec
  801138:	6a 26                	push   $0x26
  80113a:	68 e1 1b 80 00       	push   $0x801be1
  80113f:	e8 e8 02 00 00       	call   80142c <_panic>
		panic("panic in sys_page_alloc()\n");
  801144:	83 ec 04             	sub    $0x4,%esp
  801147:	68 00 1c 80 00       	push   $0x801c00
  80114c:	6a 31                	push   $0x31
  80114e:	68 e1 1b 80 00       	push   $0x801be1
  801153:	e8 d4 02 00 00       	call   80142c <_panic>
		panic("panic in sys_page_map()\n");
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	68 1b 1c 80 00       	push   $0x801c1b
  801160:	6a 36                	push   $0x36
  801162:	68 e1 1b 80 00       	push   $0x801be1
  801167:	e8 c0 02 00 00       	call   80142c <_panic>
		panic("panic in sys_page_unmap()\n");
  80116c:	83 ec 04             	sub    $0x4,%esp
  80116f:	68 34 1c 80 00       	push   $0x801c34
  801174:	6a 39                	push   $0x39
  801176:	68 e1 1b 80 00       	push   $0x801be1
  80117b:	e8 ac 02 00 00       	call   80142c <_panic>

00801180 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	57                   	push   %edi
  801184:	56                   	push   %esi
  801185:	53                   	push   %ebx
  801186:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801189:	68 81 10 80 00       	push   $0x801081
  80118e:	e8 fa 02 00 00       	call   80148d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801193:	b8 07 00 00 00       	mov    $0x7,%eax
  801198:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 27                	js     8011c8 <fork+0x48>
  8011a1:	89 c6                	mov    %eax,%esi
  8011a3:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8011a5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8011aa:	75 48                	jne    8011f4 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ac:	e8 53 fb ff ff       	call   800d04 <sys_getenvid>
  8011b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011b6:	c1 e0 07             	shl    $0x7,%eax
  8011b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011be:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8011c3:	e9 90 00 00 00       	jmp    801258 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 5c 1c 80 00       	push   $0x801c5c
  8011d0:	68 85 00 00 00       	push   $0x85
  8011d5:	68 e1 1b 80 00       	push   $0x801be1
  8011da:	e8 4d 02 00 00       	call   80142c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8011df:	89 f8                	mov    %edi,%eax
  8011e1:	e8 8e fd ff ff       	call   800f74 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8011e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011ec:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011f2:	74 26                	je     80121a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8011f4:	89 d8                	mov    %ebx,%eax
  8011f6:	c1 e8 16             	shr    $0x16,%eax
  8011f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801200:	a8 01                	test   $0x1,%al
  801202:	74 e2                	je     8011e6 <fork+0x66>
  801204:	89 da                	mov    %ebx,%edx
  801206:	c1 ea 0c             	shr    $0xc,%edx
  801209:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801210:	83 e0 05             	and    $0x5,%eax
  801213:	83 f8 05             	cmp    $0x5,%eax
  801216:	75 ce                	jne    8011e6 <fork+0x66>
  801218:	eb c5                	jmp    8011df <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	6a 07                	push   $0x7
  80121f:	68 00 f0 bf ee       	push   $0xeebff000
  801224:	56                   	push   %esi
  801225:	e8 18 fb ff ff       	call   800d42 <sys_page_alloc>
	if(ret < 0)
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	85 c0                	test   %eax,%eax
  80122f:	78 31                	js     801262 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	68 fc 14 80 00       	push   $0x8014fc
  801239:	56                   	push   %esi
  80123a:	e8 4e fc ff ff       	call   800e8d <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	78 33                	js     801279 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801246:	83 ec 08             	sub    $0x8,%esp
  801249:	6a 02                	push   $0x2
  80124b:	56                   	push   %esi
  80124c:	e8 b8 fb ff ff       	call   800e09 <sys_env_set_status>
	if(ret < 0)
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	78 38                	js     801290 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801258:	89 f0                	mov    %esi,%eax
  80125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	68 00 1c 80 00       	push   $0x801c00
  80126a:	68 91 00 00 00       	push   $0x91
  80126f:	68 e1 1b 80 00       	push   $0x801be1
  801274:	e8 b3 01 00 00       	call   80142c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	68 80 1c 80 00       	push   $0x801c80
  801281:	68 94 00 00 00       	push   $0x94
  801286:	68 e1 1b 80 00       	push   $0x801be1
  80128b:	e8 9c 01 00 00       	call   80142c <_panic>
		panic("panic in sys_env_set_status()\n");
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	68 a8 1c 80 00       	push   $0x801ca8
  801298:	68 97 00 00 00       	push   $0x97
  80129d:	68 e1 1b 80 00       	push   $0x801be1
  8012a2:	e8 85 01 00 00       	call   80142c <_panic>

008012a7 <sfork>:

// Challenge!
int
sfork(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	57                   	push   %edi
  8012ab:	56                   	push   %esi
  8012ac:	53                   	push   %ebx
  8012ad:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8012b0:	a1 04 20 80 00       	mov    0x802004,%eax
  8012b5:	8b 40 48             	mov    0x48(%eax),%eax
  8012b8:	68 c8 1c 80 00       	push   $0x801cc8
  8012bd:	50                   	push   %eax
  8012be:	68 4f 1c 80 00       	push   $0x801c4f
  8012c3:	e8 29 ef ff ff       	call   8001f1 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8012c8:	c7 04 24 81 10 80 00 	movl   $0x801081,(%esp)
  8012cf:	e8 b9 01 00 00       	call   80148d <set_pgfault_handler>
  8012d4:	b8 07 00 00 00       	mov    $0x7,%eax
  8012d9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 27                	js     801309 <sfork+0x62>
  8012e2:	89 c7                	mov    %eax,%edi
  8012e4:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012e6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012eb:	75 55                	jne    801342 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ed:	e8 12 fa ff ff       	call   800d04 <sys_getenvid>
  8012f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f7:	c1 e0 07             	shl    $0x7,%eax
  8012fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ff:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801304:	e9 d4 00 00 00       	jmp    8013dd <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	68 5c 1c 80 00       	push   $0x801c5c
  801311:	68 a9 00 00 00       	push   $0xa9
  801316:	68 e1 1b 80 00       	push   $0x801be1
  80131b:	e8 0c 01 00 00       	call   80142c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801320:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801325:	89 f0                	mov    %esi,%eax
  801327:	e8 48 fc ff ff       	call   800f74 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80132c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801332:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801338:	77 65                	ja     80139f <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  80133a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801340:	74 de                	je     801320 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801342:	89 d8                	mov    %ebx,%eax
  801344:	c1 e8 16             	shr    $0x16,%eax
  801347:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80134e:	a8 01                	test   $0x1,%al
  801350:	74 da                	je     80132c <sfork+0x85>
  801352:	89 da                	mov    %ebx,%edx
  801354:	c1 ea 0c             	shr    $0xc,%edx
  801357:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80135e:	83 e0 05             	and    $0x5,%eax
  801361:	83 f8 05             	cmp    $0x5,%eax
  801364:	75 c6                	jne    80132c <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801366:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80136d:	c1 e2 0c             	shl    $0xc,%edx
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	83 e0 07             	and    $0x7,%eax
  801376:	50                   	push   %eax
  801377:	52                   	push   %edx
  801378:	56                   	push   %esi
  801379:	52                   	push   %edx
  80137a:	6a 00                	push   $0x0
  80137c:	e8 04 fa ff ff       	call   800d85 <sys_page_map>
  801381:	83 c4 20             	add    $0x20,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 a4                	je     80132c <sfork+0x85>
				panic("sys_page_map() panic\n");
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 cb 1b 80 00       	push   $0x801bcb
  801390:	68 b4 00 00 00       	push   $0xb4
  801395:	68 e1 1b 80 00       	push   $0x801be1
  80139a:	e8 8d 00 00 00       	call   80142c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	6a 07                	push   $0x7
  8013a4:	68 00 f0 bf ee       	push   $0xeebff000
  8013a9:	57                   	push   %edi
  8013aa:	e8 93 f9 ff ff       	call   800d42 <sys_page_alloc>
	if(ret < 0)
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 31                	js     8013e7 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	68 fc 14 80 00       	push   $0x8014fc
  8013be:	57                   	push   %edi
  8013bf:	e8 c9 fa ff ff       	call   800e8d <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 33                	js     8013fe <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	6a 02                	push   $0x2
  8013d0:	57                   	push   %edi
  8013d1:	e8 33 fa ff ff       	call   800e09 <sys_env_set_status>
	if(ret < 0)
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 38                	js     801415 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8013dd:	89 f8                	mov    %edi,%eax
  8013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 00 1c 80 00       	push   $0x801c00
  8013ef:	68 ba 00 00 00       	push   $0xba
  8013f4:	68 e1 1b 80 00       	push   $0x801be1
  8013f9:	e8 2e 00 00 00       	call   80142c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	68 80 1c 80 00       	push   $0x801c80
  801406:	68 bd 00 00 00       	push   $0xbd
  80140b:	68 e1 1b 80 00       	push   $0x801be1
  801410:	e8 17 00 00 00       	call   80142c <_panic>
		panic("panic in sys_env_set_status()\n");
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	68 a8 1c 80 00       	push   $0x801ca8
  80141d:	68 c0 00 00 00       	push   $0xc0
  801422:	68 e1 1b 80 00       	push   $0x801be1
  801427:	e8 00 00 00 00       	call   80142c <_panic>

0080142c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	56                   	push   %esi
  801430:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801431:	a1 04 20 80 00       	mov    0x802004,%eax
  801436:	8b 40 48             	mov    0x48(%eax),%eax
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	68 f4 1c 80 00       	push   $0x801cf4
  801441:	50                   	push   %eax
  801442:	68 4f 1c 80 00       	push   $0x801c4f
  801447:	e8 a5 ed ff ff       	call   8001f1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80144c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80144f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801455:	e8 aa f8 ff ff       	call   800d04 <sys_getenvid>
  80145a:	83 c4 04             	add    $0x4,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	ff 75 08             	pushl  0x8(%ebp)
  801463:	56                   	push   %esi
  801464:	50                   	push   %eax
  801465:	68 d0 1c 80 00       	push   $0x801cd0
  80146a:	e8 82 ed ff ff       	call   8001f1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80146f:	83 c4 18             	add    $0x18,%esp
  801472:	53                   	push   %ebx
  801473:	ff 75 10             	pushl  0x10(%ebp)
  801476:	e8 25 ed ff ff       	call   8001a0 <vcprintf>
	cprintf("\n");
  80147b:	c7 04 24 19 1c 80 00 	movl   $0x801c19,(%esp)
  801482:	e8 6a ed ff ff       	call   8001f1 <cprintf>
  801487:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80148a:	cc                   	int3   
  80148b:	eb fd                	jmp    80148a <_panic+0x5e>

0080148d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801493:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80149a:	74 0a                	je     8014a6 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	6a 07                	push   $0x7
  8014ab:	68 00 f0 bf ee       	push   $0xeebff000
  8014b0:	6a 00                	push   $0x0
  8014b2:	e8 8b f8 ff ff       	call   800d42 <sys_page_alloc>
		if(r < 0)
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 2a                	js     8014e8 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	68 fc 14 80 00       	push   $0x8014fc
  8014c6:	6a 00                	push   $0x0
  8014c8:	e8 c0 f9 ff ff       	call   800e8d <sys_env_set_pgfault_upcall>
		if(r < 0)
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	79 c8                	jns    80149c <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	68 2c 1d 80 00       	push   $0x801d2c
  8014dc:	6a 25                	push   $0x25
  8014de:	68 68 1d 80 00       	push   $0x801d68
  8014e3:	e8 44 ff ff ff       	call   80142c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	68 fc 1c 80 00       	push   $0x801cfc
  8014f0:	6a 22                	push   $0x22
  8014f2:	68 68 1d 80 00       	push   $0x801d68
  8014f7:	e8 30 ff ff ff       	call   80142c <_panic>

008014fc <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014fc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014fd:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801502:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801504:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801507:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80150b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80150f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801512:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801514:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801518:	83 c4 08             	add    $0x8,%esp
	popal
  80151b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80151c:	83 c4 04             	add    $0x4,%esp
	popfl
  80151f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801520:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801521:	c3                   	ret    
  801522:	66 90                	xchg   %ax,%ax
  801524:	66 90                	xchg   %ax,%ax
  801526:	66 90                	xchg   %ax,%ax
  801528:	66 90                	xchg   %ax,%ax
  80152a:	66 90                	xchg   %ax,%ax
  80152c:	66 90                	xchg   %ax,%ax
  80152e:	66 90                	xchg   %ax,%ax

00801530 <__udivdi3>:
  801530:	55                   	push   %ebp
  801531:	57                   	push   %edi
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 1c             	sub    $0x1c,%esp
  801537:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80153b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80153f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801543:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801547:	85 d2                	test   %edx,%edx
  801549:	75 4d                	jne    801598 <__udivdi3+0x68>
  80154b:	39 f3                	cmp    %esi,%ebx
  80154d:	76 19                	jbe    801568 <__udivdi3+0x38>
  80154f:	31 ff                	xor    %edi,%edi
  801551:	89 e8                	mov    %ebp,%eax
  801553:	89 f2                	mov    %esi,%edx
  801555:	f7 f3                	div    %ebx
  801557:	89 fa                	mov    %edi,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	89 d9                	mov    %ebx,%ecx
  80156a:	85 db                	test   %ebx,%ebx
  80156c:	75 0b                	jne    801579 <__udivdi3+0x49>
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
  801573:	31 d2                	xor    %edx,%edx
  801575:	f7 f3                	div    %ebx
  801577:	89 c1                	mov    %eax,%ecx
  801579:	31 d2                	xor    %edx,%edx
  80157b:	89 f0                	mov    %esi,%eax
  80157d:	f7 f1                	div    %ecx
  80157f:	89 c6                	mov    %eax,%esi
  801581:	89 e8                	mov    %ebp,%eax
  801583:	89 f7                	mov    %esi,%edi
  801585:	f7 f1                	div    %ecx
  801587:	89 fa                	mov    %edi,%edx
  801589:	83 c4 1c             	add    $0x1c,%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
  801591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801598:	39 f2                	cmp    %esi,%edx
  80159a:	77 1c                	ja     8015b8 <__udivdi3+0x88>
  80159c:	0f bd fa             	bsr    %edx,%edi
  80159f:	83 f7 1f             	xor    $0x1f,%edi
  8015a2:	75 2c                	jne    8015d0 <__udivdi3+0xa0>
  8015a4:	39 f2                	cmp    %esi,%edx
  8015a6:	72 06                	jb     8015ae <__udivdi3+0x7e>
  8015a8:	31 c0                	xor    %eax,%eax
  8015aa:	39 eb                	cmp    %ebp,%ebx
  8015ac:	77 a9                	ja     801557 <__udivdi3+0x27>
  8015ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b3:	eb a2                	jmp    801557 <__udivdi3+0x27>
  8015b5:	8d 76 00             	lea    0x0(%esi),%esi
  8015b8:	31 ff                	xor    %edi,%edi
  8015ba:	31 c0                	xor    %eax,%eax
  8015bc:	89 fa                	mov    %edi,%edx
  8015be:	83 c4 1c             	add    $0x1c,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    
  8015c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015cd:	8d 76 00             	lea    0x0(%esi),%esi
  8015d0:	89 f9                	mov    %edi,%ecx
  8015d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015d7:	29 f8                	sub    %edi,%eax
  8015d9:	d3 e2                	shl    %cl,%edx
  8015db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015df:	89 c1                	mov    %eax,%ecx
  8015e1:	89 da                	mov    %ebx,%edx
  8015e3:	d3 ea                	shr    %cl,%edx
  8015e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015e9:	09 d1                	or     %edx,%ecx
  8015eb:	89 f2                	mov    %esi,%edx
  8015ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f1:	89 f9                	mov    %edi,%ecx
  8015f3:	d3 e3                	shl    %cl,%ebx
  8015f5:	89 c1                	mov    %eax,%ecx
  8015f7:	d3 ea                	shr    %cl,%edx
  8015f9:	89 f9                	mov    %edi,%ecx
  8015fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ff:	89 eb                	mov    %ebp,%ebx
  801601:	d3 e6                	shl    %cl,%esi
  801603:	89 c1                	mov    %eax,%ecx
  801605:	d3 eb                	shr    %cl,%ebx
  801607:	09 de                	or     %ebx,%esi
  801609:	89 f0                	mov    %esi,%eax
  80160b:	f7 74 24 08          	divl   0x8(%esp)
  80160f:	89 d6                	mov    %edx,%esi
  801611:	89 c3                	mov    %eax,%ebx
  801613:	f7 64 24 0c          	mull   0xc(%esp)
  801617:	39 d6                	cmp    %edx,%esi
  801619:	72 15                	jb     801630 <__udivdi3+0x100>
  80161b:	89 f9                	mov    %edi,%ecx
  80161d:	d3 e5                	shl    %cl,%ebp
  80161f:	39 c5                	cmp    %eax,%ebp
  801621:	73 04                	jae    801627 <__udivdi3+0xf7>
  801623:	39 d6                	cmp    %edx,%esi
  801625:	74 09                	je     801630 <__udivdi3+0x100>
  801627:	89 d8                	mov    %ebx,%eax
  801629:	31 ff                	xor    %edi,%edi
  80162b:	e9 27 ff ff ff       	jmp    801557 <__udivdi3+0x27>
  801630:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801633:	31 ff                	xor    %edi,%edi
  801635:	e9 1d ff ff ff       	jmp    801557 <__udivdi3+0x27>
  80163a:	66 90                	xchg   %ax,%ax
  80163c:	66 90                	xchg   %ax,%ax
  80163e:	66 90                	xchg   %ax,%ax

00801640 <__umoddi3>:
  801640:	55                   	push   %ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 1c             	sub    $0x1c,%esp
  801647:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80164b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80164f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801653:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801657:	89 da                	mov    %ebx,%edx
  801659:	85 c0                	test   %eax,%eax
  80165b:	75 43                	jne    8016a0 <__umoddi3+0x60>
  80165d:	39 df                	cmp    %ebx,%edi
  80165f:	76 17                	jbe    801678 <__umoddi3+0x38>
  801661:	89 f0                	mov    %esi,%eax
  801663:	f7 f7                	div    %edi
  801665:	89 d0                	mov    %edx,%eax
  801667:	31 d2                	xor    %edx,%edx
  801669:	83 c4 1c             	add    $0x1c,%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
  801671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801678:	89 fd                	mov    %edi,%ebp
  80167a:	85 ff                	test   %edi,%edi
  80167c:	75 0b                	jne    801689 <__umoddi3+0x49>
  80167e:	b8 01 00 00 00       	mov    $0x1,%eax
  801683:	31 d2                	xor    %edx,%edx
  801685:	f7 f7                	div    %edi
  801687:	89 c5                	mov    %eax,%ebp
  801689:	89 d8                	mov    %ebx,%eax
  80168b:	31 d2                	xor    %edx,%edx
  80168d:	f7 f5                	div    %ebp
  80168f:	89 f0                	mov    %esi,%eax
  801691:	f7 f5                	div    %ebp
  801693:	89 d0                	mov    %edx,%eax
  801695:	eb d0                	jmp    801667 <__umoddi3+0x27>
  801697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80169e:	66 90                	xchg   %ax,%ax
  8016a0:	89 f1                	mov    %esi,%ecx
  8016a2:	39 d8                	cmp    %ebx,%eax
  8016a4:	76 0a                	jbe    8016b0 <__umoddi3+0x70>
  8016a6:	89 f0                	mov    %esi,%eax
  8016a8:	83 c4 1c             	add    $0x1c,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    
  8016b0:	0f bd e8             	bsr    %eax,%ebp
  8016b3:	83 f5 1f             	xor    $0x1f,%ebp
  8016b6:	75 20                	jne    8016d8 <__umoddi3+0x98>
  8016b8:	39 d8                	cmp    %ebx,%eax
  8016ba:	0f 82 b0 00 00 00    	jb     801770 <__umoddi3+0x130>
  8016c0:	39 f7                	cmp    %esi,%edi
  8016c2:	0f 86 a8 00 00 00    	jbe    801770 <__umoddi3+0x130>
  8016c8:	89 c8                	mov    %ecx,%eax
  8016ca:	83 c4 1c             	add    $0x1c,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5e                   	pop    %esi
  8016cf:	5f                   	pop    %edi
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    
  8016d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016d8:	89 e9                	mov    %ebp,%ecx
  8016da:	ba 20 00 00 00       	mov    $0x20,%edx
  8016df:	29 ea                	sub    %ebp,%edx
  8016e1:	d3 e0                	shl    %cl,%eax
  8016e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e7:	89 d1                	mov    %edx,%ecx
  8016e9:	89 f8                	mov    %edi,%eax
  8016eb:	d3 e8                	shr    %cl,%eax
  8016ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016f9:	09 c1                	or     %eax,%ecx
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801701:	89 e9                	mov    %ebp,%ecx
  801703:	d3 e7                	shl    %cl,%edi
  801705:	89 d1                	mov    %edx,%ecx
  801707:	d3 e8                	shr    %cl,%eax
  801709:	89 e9                	mov    %ebp,%ecx
  80170b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80170f:	d3 e3                	shl    %cl,%ebx
  801711:	89 c7                	mov    %eax,%edi
  801713:	89 d1                	mov    %edx,%ecx
  801715:	89 f0                	mov    %esi,%eax
  801717:	d3 e8                	shr    %cl,%eax
  801719:	89 e9                	mov    %ebp,%ecx
  80171b:	89 fa                	mov    %edi,%edx
  80171d:	d3 e6                	shl    %cl,%esi
  80171f:	09 d8                	or     %ebx,%eax
  801721:	f7 74 24 08          	divl   0x8(%esp)
  801725:	89 d1                	mov    %edx,%ecx
  801727:	89 f3                	mov    %esi,%ebx
  801729:	f7 64 24 0c          	mull   0xc(%esp)
  80172d:	89 c6                	mov    %eax,%esi
  80172f:	89 d7                	mov    %edx,%edi
  801731:	39 d1                	cmp    %edx,%ecx
  801733:	72 06                	jb     80173b <__umoddi3+0xfb>
  801735:	75 10                	jne    801747 <__umoddi3+0x107>
  801737:	39 c3                	cmp    %eax,%ebx
  801739:	73 0c                	jae    801747 <__umoddi3+0x107>
  80173b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80173f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801743:	89 d7                	mov    %edx,%edi
  801745:	89 c6                	mov    %eax,%esi
  801747:	89 ca                	mov    %ecx,%edx
  801749:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80174e:	29 f3                	sub    %esi,%ebx
  801750:	19 fa                	sbb    %edi,%edx
  801752:	89 d0                	mov    %edx,%eax
  801754:	d3 e0                	shl    %cl,%eax
  801756:	89 e9                	mov    %ebp,%ecx
  801758:	d3 eb                	shr    %cl,%ebx
  80175a:	d3 ea                	shr    %cl,%edx
  80175c:	09 d8                	or     %ebx,%eax
  80175e:	83 c4 1c             	add    $0x1c,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5f                   	pop    %edi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    
  801766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80176d:	8d 76 00             	lea    0x0(%esi),%esi
  801770:	89 da                	mov    %ebx,%edx
  801772:	29 fe                	sub    %edi,%esi
  801774:	19 c2                	sbb    %eax,%edx
  801776:	89 f1                	mov    %esi,%ecx
  801778:	89 c8                	mov    %ecx,%eax
  80177a:	e9 4b ff ff ff       	jmp    8016ca <__umoddi3+0x8a>
