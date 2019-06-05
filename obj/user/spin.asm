
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
  80003a:	68 00 2b 80 00       	push   $0x802b00
  80003f:	e8 c2 01 00 00       	call   800206 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 38 12 00 00       	call   801281 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 78 2b 80 00       	push   $0x802b78
  800058:	e8 a9 01 00 00       	call   800206 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 28 2b 80 00       	push   $0x802b28
  80006c:	e8 95 01 00 00       	call   800206 <cprintf>
	sys_yield();
  800071:	e8 c2 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  800076:	e8 bd 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  80007b:	e8 b8 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  800080:	e8 b3 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  800085:	e8 ae 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  80008a:	e8 a9 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  80008f:	e8 a4 0c 00 00       	call   800d38 <sys_yield>
	sys_yield();
  800094:	e8 9f 0c 00 00       	call   800d38 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 50 2b 80 00 	movl   $0x802b50,(%esp)
  8000a0:	e8 61 01 00 00       	call   800206 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 2b 0c 00 00       	call   800cd8 <sys_env_destroy>
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
  8000be:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000c5:	00 00 00 
	envid_t find = sys_getenvid();
  8000c8:	e8 4c 0c 00 00       	call   800d19 <sys_getenvid>
  8000cd:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  800116:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800120:	7e 0a                	jle    80012c <libmain+0x77>
		binaryname = argv[0];
  800122:	8b 45 0c             	mov    0xc(%ebp),%eax
  800125:	8b 00                	mov    (%eax),%eax
  800127:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	68 96 2b 80 00       	push   $0x802b96
  800134:	e8 cd 00 00 00       	call   800206 <cprintf>
	// call user main routine
	umain(argc, argv);
  800139:	83 c4 08             	add    $0x8,%esp
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 ec fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800147:	e8 0b 00 00 00       	call   800157 <exit>
}
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800152:	5b                   	pop    %ebx
  800153:	5e                   	pop    %esi
  800154:	5f                   	pop    %edi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 89 15 00 00       	call   8016eb <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 6c 0b 00 00       	call   800cd8 <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	74 09                	je     800199 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800197:	c9                   	leave  
  800198:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	68 ff 00 00 00       	push   $0xff
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 f1 0a 00 00       	call   800c9b <sys_cputs>
		b->idx = 0;
  8001aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb db                	jmp    800190 <putch+0x1f>

008001b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c5:	00 00 00 
	b.cnt = 0;
  8001c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	68 71 01 80 00       	push   $0x800171
  8001e4:	e8 4a 01 00 00       	call   800333 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	83 c4 08             	add    $0x8,%esp
  8001ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 9d 0a 00 00       	call   800c9b <sys_cputs>

	return b.cnt;
}
  8001fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020f:	50                   	push   %eax
  800210:	ff 75 08             	pushl  0x8(%ebp)
  800213:	e8 9d ff ff ff       	call   8001b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 1c             	sub    $0x1c,%esp
  800223:	89 c6                	mov    %eax,%esi
  800225:	89 d7                	mov    %edx,%edi
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800230:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800233:	8b 45 10             	mov    0x10(%ebp),%eax
  800236:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800239:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80023d:	74 2c                	je     80026b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80023f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800242:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800249:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80024c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024f:	39 c2                	cmp    %eax,%edx
  800251:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800254:	73 43                	jae    800299 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	85 db                	test   %ebx,%ebx
  80025b:	7e 6c                	jle    8002c9 <printnum+0xaf>
				putch(padc, putdat);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	57                   	push   %edi
  800261:	ff 75 18             	pushl  0x18(%ebp)
  800264:	ff d6                	call   *%esi
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb eb                	jmp    800256 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	6a 20                	push   $0x20
  800270:	6a 00                	push   $0x0
  800272:	50                   	push   %eax
  800273:	ff 75 e4             	pushl  -0x1c(%ebp)
  800276:	ff 75 e0             	pushl  -0x20(%ebp)
  800279:	89 fa                	mov    %edi,%edx
  80027b:	89 f0                	mov    %esi,%eax
  80027d:	e8 98 ff ff ff       	call   80021a <printnum>
		while (--width > 0)
  800282:	83 c4 20             	add    $0x20,%esp
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	85 db                	test   %ebx,%ebx
  80028a:	7e 65                	jle    8002f1 <printnum+0xd7>
			putch(padc, putdat);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	57                   	push   %edi
  800290:	6a 20                	push   $0x20
  800292:	ff d6                	call   *%esi
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	eb ec                	jmp    800285 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	ff 75 18             	pushl  0x18(%ebp)
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	53                   	push   %ebx
  8002a3:	50                   	push   %eax
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b3:	e8 e8 25 00 00       	call   8028a0 <__udivdi3>
  8002b8:	83 c4 18             	add    $0x18,%esp
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	89 fa                	mov    %edi,%edx
  8002bf:	89 f0                	mov    %esi,%eax
  8002c1:	e8 54 ff ff ff       	call   80021a <printnum>
  8002c6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	57                   	push   %edi
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dc:	e8 cf 26 00 00       	call   8029b0 <__umoddi3>
  8002e1:	83 c4 14             	add    $0x14,%esp
  8002e4:	0f be 80 ba 2b 80 00 	movsbl 0x802bba(%eax),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff d6                	call   *%esi
  8002ee:	83 c4 10             	add    $0x10,%esp
	}
}
  8002f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f4:	5b                   	pop    %ebx
  8002f5:	5e                   	pop    %esi
  8002f6:	5f                   	pop    %edi
  8002f7:	5d                   	pop    %ebp
  8002f8:	c3                   	ret    

008002f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800303:	8b 10                	mov    (%eax),%edx
  800305:	3b 50 04             	cmp    0x4(%eax),%edx
  800308:	73 0a                	jae    800314 <sprintputch+0x1b>
		*b->buf++ = ch;
  80030a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030d:	89 08                	mov    %ecx,(%eax)
  80030f:	8b 45 08             	mov    0x8(%ebp),%eax
  800312:	88 02                	mov    %al,(%edx)
}
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <printfmt>:
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031f:	50                   	push   %eax
  800320:	ff 75 10             	pushl  0x10(%ebp)
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 05 00 00 00       	call   800333 <vprintfmt>
}
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <vprintfmt>:
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	57                   	push   %edi
  800337:	56                   	push   %esi
  800338:	53                   	push   %ebx
  800339:	83 ec 3c             	sub    $0x3c,%esp
  80033c:	8b 75 08             	mov    0x8(%ebp),%esi
  80033f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800342:	8b 7d 10             	mov    0x10(%ebp),%edi
  800345:	e9 32 04 00 00       	jmp    80077c <vprintfmt+0x449>
		padc = ' ';
  80034a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80034e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800355:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80035c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800363:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800371:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8d 47 01             	lea    0x1(%edi),%eax
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037c:	0f b6 17             	movzbl (%edi),%edx
  80037f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800382:	3c 55                	cmp    $0x55,%al
  800384:	0f 87 12 05 00 00    	ja     80089c <vprintfmt+0x569>
  80038a:	0f b6 c0             	movzbl %al,%eax
  80038d:	ff 24 85 a0 2d 80 00 	jmp    *0x802da0(,%eax,4)
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800397:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80039b:	eb d9                	jmp    800376 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a4:	eb d0                	jmp    800376 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	0f b6 d2             	movzbl %dl,%edx
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b1:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b4:	eb 03                	jmp    8003b9 <vprintfmt+0x86>
  8003b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003bc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c6:	83 fe 09             	cmp    $0x9,%esi
  8003c9:	76 eb                	jbe    8003b6 <vprintfmt+0x83>
  8003cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d1:	eb 14                	jmp    8003e7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 40 04             	lea    0x4(%eax),%eax
  8003e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003eb:	79 89                	jns    800376 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fa:	e9 77 ff ff ff       	jmp    800376 <vprintfmt+0x43>
  8003ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800402:	85 c0                	test   %eax,%eax
  800404:	0f 48 c1             	cmovs  %ecx,%eax
  800407:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040d:	e9 64 ff ff ff       	jmp    800376 <vprintfmt+0x43>
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800415:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80041c:	e9 55 ff ff ff       	jmp    800376 <vprintfmt+0x43>
			lflag++;
  800421:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800428:	e9 49 ff ff ff       	jmp    800376 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8d 78 04             	lea    0x4(%eax),%edi
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	53                   	push   %ebx
  800437:	ff 30                	pushl  (%eax)
  800439:	ff d6                	call   *%esi
			break;
  80043b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800441:	e9 33 03 00 00       	jmp    800779 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8d 78 04             	lea    0x4(%eax),%edi
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	99                   	cltd   
  80044f:	31 d0                	xor    %edx,%eax
  800451:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800453:	83 f8 10             	cmp    $0x10,%eax
  800456:	7f 23                	jg     80047b <vprintfmt+0x148>
  800458:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  80045f:	85 d2                	test   %edx,%edx
  800461:	74 18                	je     80047b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800463:	52                   	push   %edx
  800464:	68 09 31 80 00       	push   $0x803109
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 a6 fe ff ff       	call   800316 <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
  800476:	e9 fe 02 00 00       	jmp    800779 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80047b:	50                   	push   %eax
  80047c:	68 d2 2b 80 00       	push   $0x802bd2
  800481:	53                   	push   %ebx
  800482:	56                   	push   %esi
  800483:	e8 8e fe ff ff       	call   800316 <printfmt>
  800488:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048e:	e9 e6 02 00 00       	jmp    800779 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800493:	8b 45 14             	mov    0x14(%ebp),%eax
  800496:	83 c0 04             	add    $0x4,%eax
  800499:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004a1:	85 c9                	test   %ecx,%ecx
  8004a3:	b8 cb 2b 80 00       	mov    $0x802bcb,%eax
  8004a8:	0f 45 c1             	cmovne %ecx,%eax
  8004ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b2:	7e 06                	jle    8004ba <vprintfmt+0x187>
  8004b4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004b8:	75 0d                	jne    8004c7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004bd:	89 c7                	mov    %eax,%edi
  8004bf:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c5:	eb 53                	jmp    80051a <vprintfmt+0x1e7>
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cd:	50                   	push   %eax
  8004ce:	e8 71 04 00 00       	call   800944 <strnlen>
  8004d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d6:	29 c1                	sub    %eax,%ecx
  8004d8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	eb 0f                	jmp    8004f8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	83 ef 01             	sub    $0x1,%edi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	7f ed                	jg     8004e9 <vprintfmt+0x1b6>
  8004fc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004ff:	85 c9                	test   %ecx,%ecx
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	0f 49 c1             	cmovns %ecx,%eax
  800509:	29 c1                	sub    %eax,%ecx
  80050b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050e:	eb aa                	jmp    8004ba <vprintfmt+0x187>
					putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	52                   	push   %edx
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 4b                	je     800578 <vprintfmt+0x245>
  80052d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800531:	78 06                	js     800539 <vprintfmt+0x206>
  800533:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800537:	78 1e                	js     800557 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80053d:	74 d1                	je     800510 <vprintfmt+0x1dd>
  80053f:	0f be c0             	movsbl %al,%eax
  800542:	83 e8 20             	sub    $0x20,%eax
  800545:	83 f8 5e             	cmp    $0x5e,%eax
  800548:	76 c6                	jbe    800510 <vprintfmt+0x1dd>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 3f                	push   $0x3f
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb c3                	jmp    80051a <vprintfmt+0x1e7>
  800557:	89 cf                	mov    %ecx,%edi
  800559:	eb 0e                	jmp    800569 <vprintfmt+0x236>
				putch(' ', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ee                	jg     80055b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 01 02 00 00       	jmp    800779 <vprintfmt+0x446>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb ed                	jmp    800569 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80057c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80057f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800586:	e9 eb fd ff ff       	jmp    800376 <vprintfmt+0x43>
	if (lflag >= 2)
  80058b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80058f:	7f 21                	jg     8005b2 <vprintfmt+0x27f>
	else if (lflag)
  800591:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800595:	74 68                	je     8005ff <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059f:	89 c1                	mov    %eax,%ecx
  8005a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	eb 17                	jmp    8005c9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 50 04             	mov    0x4(%eax),%edx
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 40 08             	lea    0x8(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d9:	78 3f                	js     80061a <vprintfmt+0x2e7>
			base = 10;
  8005db:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005e0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e4:	0f 84 71 01 00 00    	je     80075b <vprintfmt+0x428>
				putch('+', putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	53                   	push   %ebx
  8005ee:	6a 2b                	push   $0x2b
  8005f0:	ff d6                	call   *%esi
  8005f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 5c 01 00 00       	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800607:	89 c1                	mov    %eax,%ecx
  800609:	c1 f9 1f             	sar    $0x1f,%ecx
  80060c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
  800618:	eb af                	jmp    8005c9 <vprintfmt+0x296>
				putch('-', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 2d                	push   $0x2d
  800620:	ff d6                	call   *%esi
				num = -(long long) num;
  800622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800625:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800628:	f7 d8                	neg    %eax
  80062a:	83 d2 00             	adc    $0x0,%edx
  80062d:	f7 da                	neg    %edx
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 19 01 00 00       	jmp    80075b <vprintfmt+0x428>
	if (lflag >= 2)
  800642:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800646:	7f 29                	jg     800671 <vprintfmt+0x33e>
	else if (lflag)
  800648:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064c:	74 44                	je     800692 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	ba 00 00 00 00       	mov    $0x0,%edx
  800658:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 40 04             	lea    0x4(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800667:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066c:	e9 ea 00 00 00       	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 50 04             	mov    0x4(%eax),%edx
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 08             	lea    0x8(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800688:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068d:	e9 c9 00 00 00       	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b0:	e9 a6 00 00 00       	jmp    80075b <vprintfmt+0x428>
			putch('0', putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	6a 30                	push   $0x30
  8006bb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c4:	7f 26                	jg     8006ec <vprintfmt+0x3b9>
	else if (lflag)
  8006c6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ca:	74 3e                	je     80070a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 40 04             	lea    0x4(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ea:	eb 6f                	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 50 04             	mov    0x4(%eax),%edx
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 08             	lea    0x8(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800703:	b8 08 00 00 00       	mov    $0x8,%eax
  800708:	eb 51                	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800723:	b8 08 00 00 00       	mov    $0x8,%eax
  800728:	eb 31                	jmp    80075b <vprintfmt+0x428>
			putch('0', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 30                	push   $0x30
  800730:	ff d6                	call   *%esi
			putch('x', putdat);
  800732:	83 c4 08             	add    $0x8,%esp
  800735:	53                   	push   %ebx
  800736:	6a 78                	push   $0x78
  800738:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800747:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80074a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80075b:	83 ec 0c             	sub    $0xc,%esp
  80075e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800762:	52                   	push   %edx
  800763:	ff 75 e0             	pushl  -0x20(%ebp)
  800766:	50                   	push   %eax
  800767:	ff 75 dc             	pushl  -0x24(%ebp)
  80076a:	ff 75 d8             	pushl  -0x28(%ebp)
  80076d:	89 da                	mov    %ebx,%edx
  80076f:	89 f0                	mov    %esi,%eax
  800771:	e8 a4 fa ff ff       	call   80021a <printnum>
			break;
  800776:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800779:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077c:	83 c7 01             	add    $0x1,%edi
  80077f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800783:	83 f8 25             	cmp    $0x25,%eax
  800786:	0f 84 be fb ff ff    	je     80034a <vprintfmt+0x17>
			if (ch == '\0')
  80078c:	85 c0                	test   %eax,%eax
  80078e:	0f 84 28 01 00 00    	je     8008bc <vprintfmt+0x589>
			putch(ch, putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	50                   	push   %eax
  800799:	ff d6                	call   *%esi
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	eb dc                	jmp    80077c <vprintfmt+0x449>
	if (lflag >= 2)
  8007a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a4:	7f 26                	jg     8007cc <vprintfmt+0x499>
	else if (lflag)
  8007a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007aa:	74 41                	je     8007ed <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 04             	lea    0x4(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ca:	eb 8f                	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 50 04             	mov    0x4(%eax),%edx
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 08             	lea    0x8(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e8:	e9 6e ff ff ff       	jmp    80075b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
  80080b:	e9 4b ff ff ff       	jmp    80075b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	83 c0 04             	add    $0x4,%eax
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	85 c0                	test   %eax,%eax
  800820:	74 14                	je     800836 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800822:	8b 13                	mov    (%ebx),%edx
  800824:	83 fa 7f             	cmp    $0x7f,%edx
  800827:	7f 37                	jg     800860 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800829:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	e9 43 ff ff ff       	jmp    800779 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800836:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083b:	bf f1 2c 80 00       	mov    $0x802cf1,%edi
							putch(ch, putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	53                   	push   %ebx
  800844:	50                   	push   %eax
  800845:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800847:	83 c7 01             	add    $0x1,%edi
  80084a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	85 c0                	test   %eax,%eax
  800853:	75 eb                	jne    800840 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800855:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	e9 19 ff ff ff       	jmp    800779 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800860:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800862:	b8 0a 00 00 00       	mov    $0xa,%eax
  800867:	bf 29 2d 80 00       	mov    $0x802d29,%edi
							putch(ch, putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	50                   	push   %eax
  800871:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800873:	83 c7 01             	add    $0x1,%edi
  800876:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	85 c0                	test   %eax,%eax
  80087f:	75 eb                	jne    80086c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800881:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	e9 ed fe ff ff       	jmp    800779 <vprintfmt+0x446>
			putch(ch, putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 25                	push   $0x25
  800892:	ff d6                	call   *%esi
			break;
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	e9 dd fe ff ff       	jmp    800779 <vprintfmt+0x446>
			putch('%', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	53                   	push   %ebx
  8008a0:	6a 25                	push   $0x25
  8008a2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	89 f8                	mov    %edi,%eax
  8008a9:	eb 03                	jmp    8008ae <vprintfmt+0x57b>
  8008ab:	83 e8 01             	sub    $0x1,%eax
  8008ae:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b2:	75 f7                	jne    8008ab <vprintfmt+0x578>
  8008b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b7:	e9 bd fe ff ff       	jmp    800779 <vprintfmt+0x446>
}
  8008bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 18             	sub    $0x18,%esp
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	74 26                	je     80090b <vsnprintf+0x47>
  8008e5:	85 d2                	test   %edx,%edx
  8008e7:	7e 22                	jle    80090b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e9:	ff 75 14             	pushl  0x14(%ebp)
  8008ec:	ff 75 10             	pushl  0x10(%ebp)
  8008ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	68 f9 02 80 00       	push   $0x8002f9
  8008f8:	e8 36 fa ff ff       	call   800333 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800900:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800906:	83 c4 10             	add    $0x10,%esp
}
  800909:	c9                   	leave  
  80090a:	c3                   	ret    
		return -E_INVAL;
  80090b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800910:	eb f7                	jmp    800909 <vsnprintf+0x45>

00800912 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800918:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80091b:	50                   	push   %eax
  80091c:	ff 75 10             	pushl  0x10(%ebp)
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	e8 9a ff ff ff       	call   8008c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
  800937:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80093b:	74 05                	je     800942 <strlen+0x16>
		n++;
  80093d:	83 c0 01             	add    $0x1,%eax
  800940:	eb f5                	jmp    800937 <strlen+0xb>
	return n;
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094d:	ba 00 00 00 00       	mov    $0x0,%edx
  800952:	39 c2                	cmp    %eax,%edx
  800954:	74 0d                	je     800963 <strnlen+0x1f>
  800956:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80095a:	74 05                	je     800961 <strnlen+0x1d>
		n++;
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	eb f1                	jmp    800952 <strnlen+0xe>
  800961:	89 d0                	mov    %edx,%eax
	return n;
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	53                   	push   %ebx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096f:	ba 00 00 00 00       	mov    $0x0,%edx
  800974:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800978:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80097b:	83 c2 01             	add    $0x1,%edx
  80097e:	84 c9                	test   %cl,%cl
  800980:	75 f2                	jne    800974 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800982:	5b                   	pop    %ebx
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	53                   	push   %ebx
  800989:	83 ec 10             	sub    $0x10,%esp
  80098c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098f:	53                   	push   %ebx
  800990:	e8 97 ff ff ff       	call   80092c <strlen>
  800995:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	01 d8                	add    %ebx,%eax
  80099d:	50                   	push   %eax
  80099e:	e8 c2 ff ff ff       	call   800965 <strcpy>
	return dst;
}
  8009a3:	89 d8                	mov    %ebx,%eax
  8009a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b5:	89 c6                	mov    %eax,%esi
  8009b7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ba:	89 c2                	mov    %eax,%edx
  8009bc:	39 f2                	cmp    %esi,%edx
  8009be:	74 11                	je     8009d1 <strncpy+0x27>
		*dst++ = *src;
  8009c0:	83 c2 01             	add    $0x1,%edx
  8009c3:	0f b6 19             	movzbl (%ecx),%ebx
  8009c6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c9:	80 fb 01             	cmp    $0x1,%bl
  8009cc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009cf:	eb eb                	jmp    8009bc <strncpy+0x12>
	}
	return ret;
}
  8009d1:	5b                   	pop    %ebx
  8009d2:	5e                   	pop    %esi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	56                   	push   %esi
  8009d9:	53                   	push   %ebx
  8009da:	8b 75 08             	mov    0x8(%ebp),%esi
  8009dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e0:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e5:	85 d2                	test   %edx,%edx
  8009e7:	74 21                	je     800a0a <strlcpy+0x35>
  8009e9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ed:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009ef:	39 c2                	cmp    %eax,%edx
  8009f1:	74 14                	je     800a07 <strlcpy+0x32>
  8009f3:	0f b6 19             	movzbl (%ecx),%ebx
  8009f6:	84 db                	test   %bl,%bl
  8009f8:	74 0b                	je     800a05 <strlcpy+0x30>
			*dst++ = *src++;
  8009fa:	83 c1 01             	add    $0x1,%ecx
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a03:	eb ea                	jmp    8009ef <strlcpy+0x1a>
  800a05:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0a:	29 f0                	sub    %esi,%eax
}
  800a0c:	5b                   	pop    %ebx
  800a0d:	5e                   	pop    %esi
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a19:	0f b6 01             	movzbl (%ecx),%eax
  800a1c:	84 c0                	test   %al,%al
  800a1e:	74 0c                	je     800a2c <strcmp+0x1c>
  800a20:	3a 02                	cmp    (%edx),%al
  800a22:	75 08                	jne    800a2c <strcmp+0x1c>
		p++, q++;
  800a24:	83 c1 01             	add    $0x1,%ecx
  800a27:	83 c2 01             	add    $0x1,%edx
  800a2a:	eb ed                	jmp    800a19 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2c:	0f b6 c0             	movzbl %al,%eax
  800a2f:	0f b6 12             	movzbl (%edx),%edx
  800a32:	29 d0                	sub    %edx,%eax
}
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	53                   	push   %ebx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	89 c3                	mov    %eax,%ebx
  800a42:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a45:	eb 06                	jmp    800a4d <strncmp+0x17>
		n--, p++, q++;
  800a47:	83 c0 01             	add    $0x1,%eax
  800a4a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4d:	39 d8                	cmp    %ebx,%eax
  800a4f:	74 16                	je     800a67 <strncmp+0x31>
  800a51:	0f b6 08             	movzbl (%eax),%ecx
  800a54:	84 c9                	test   %cl,%cl
  800a56:	74 04                	je     800a5c <strncmp+0x26>
  800a58:	3a 0a                	cmp    (%edx),%cl
  800a5a:	74 eb                	je     800a47 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5c:	0f b6 00             	movzbl (%eax),%eax
  800a5f:	0f b6 12             	movzbl (%edx),%edx
  800a62:	29 d0                	sub    %edx,%eax
}
  800a64:	5b                   	pop    %ebx
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    
		return 0;
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6c:	eb f6                	jmp    800a64 <strncmp+0x2e>

00800a6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a78:	0f b6 10             	movzbl (%eax),%edx
  800a7b:	84 d2                	test   %dl,%dl
  800a7d:	74 09                	je     800a88 <strchr+0x1a>
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	74 0a                	je     800a8d <strchr+0x1f>
	for (; *s; s++)
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	eb f0                	jmp    800a78 <strchr+0xa>
			return (char *) s;
	return 0;
  800a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a99:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9c:	38 ca                	cmp    %cl,%dl
  800a9e:	74 09                	je     800aa9 <strfind+0x1a>
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	74 05                	je     800aa9 <strfind+0x1a>
	for (; *s; s++)
  800aa4:	83 c0 01             	add    $0x1,%eax
  800aa7:	eb f0                	jmp    800a99 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	57                   	push   %edi
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab7:	85 c9                	test   %ecx,%ecx
  800ab9:	74 31                	je     800aec <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800abb:	89 f8                	mov    %edi,%eax
  800abd:	09 c8                	or     %ecx,%eax
  800abf:	a8 03                	test   $0x3,%al
  800ac1:	75 23                	jne    800ae6 <memset+0x3b>
		c &= 0xFF;
  800ac3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac7:	89 d3                	mov    %edx,%ebx
  800ac9:	c1 e3 08             	shl    $0x8,%ebx
  800acc:	89 d0                	mov    %edx,%eax
  800ace:	c1 e0 18             	shl    $0x18,%eax
  800ad1:	89 d6                	mov    %edx,%esi
  800ad3:	c1 e6 10             	shl    $0x10,%esi
  800ad6:	09 f0                	or     %esi,%eax
  800ad8:	09 c2                	or     %eax,%edx
  800ada:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800adc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800adf:	89 d0                	mov    %edx,%eax
  800ae1:	fc                   	cld    
  800ae2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae4:	eb 06                	jmp    800aec <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	fc                   	cld    
  800aea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aec:	89 f8                	mov    %edi,%eax
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5f                   	pop    %edi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b01:	39 c6                	cmp    %eax,%esi
  800b03:	73 32                	jae    800b37 <memmove+0x44>
  800b05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b08:	39 c2                	cmp    %eax,%edx
  800b0a:	76 2b                	jbe    800b37 <memmove+0x44>
		s += n;
		d += n;
  800b0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0f:	89 fe                	mov    %edi,%esi
  800b11:	09 ce                	or     %ecx,%esi
  800b13:	09 d6                	or     %edx,%esi
  800b15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1b:	75 0e                	jne    800b2b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1d:	83 ef 04             	sub    $0x4,%edi
  800b20:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b26:	fd                   	std    
  800b27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b29:	eb 09                	jmp    800b34 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2b:	83 ef 01             	sub    $0x1,%edi
  800b2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b31:	fd                   	std    
  800b32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b34:	fc                   	cld    
  800b35:	eb 1a                	jmp    800b51 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	09 ca                	or     %ecx,%edx
  800b3b:	09 f2                	or     %esi,%edx
  800b3d:	f6 c2 03             	test   $0x3,%dl
  800b40:	75 0a                	jne    800b4c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b45:	89 c7                	mov    %eax,%edi
  800b47:	fc                   	cld    
  800b48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4a:	eb 05                	jmp    800b51 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b4c:	89 c7                	mov    %eax,%edi
  800b4e:	fc                   	cld    
  800b4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 8a ff ff ff       	call   800af3 <memmove>
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b76:	89 c6                	mov    %eax,%esi
  800b78:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7b:	39 f0                	cmp    %esi,%eax
  800b7d:	74 1c                	je     800b9b <memcmp+0x30>
		if (*s1 != *s2)
  800b7f:	0f b6 08             	movzbl (%eax),%ecx
  800b82:	0f b6 1a             	movzbl (%edx),%ebx
  800b85:	38 d9                	cmp    %bl,%cl
  800b87:	75 08                	jne    800b91 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	eb ea                	jmp    800b7b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b91:	0f b6 c1             	movzbl %cl,%eax
  800b94:	0f b6 db             	movzbl %bl,%ebx
  800b97:	29 d8                	sub    %ebx,%eax
  800b99:	eb 05                	jmp    800ba0 <memcmp+0x35>
	}

	return 0;
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb2:	39 d0                	cmp    %edx,%eax
  800bb4:	73 09                	jae    800bbf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 05                	je     800bbf <memfind+0x1b>
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	eb f3                	jmp    800bb2 <memfind+0xe>
			break;
	return (void *) s;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	57                   	push   %edi
  800bc5:	56                   	push   %esi
  800bc6:	53                   	push   %ebx
  800bc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcd:	eb 03                	jmp    800bd2 <strtol+0x11>
		s++;
  800bcf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd2:	0f b6 01             	movzbl (%ecx),%eax
  800bd5:	3c 20                	cmp    $0x20,%al
  800bd7:	74 f6                	je     800bcf <strtol+0xe>
  800bd9:	3c 09                	cmp    $0x9,%al
  800bdb:	74 f2                	je     800bcf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bdd:	3c 2b                	cmp    $0x2b,%al
  800bdf:	74 2a                	je     800c0b <strtol+0x4a>
	int neg = 0;
  800be1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be6:	3c 2d                	cmp    $0x2d,%al
  800be8:	74 2b                	je     800c15 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf0:	75 0f                	jne    800c01 <strtol+0x40>
  800bf2:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf5:	74 28                	je     800c1f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf7:	85 db                	test   %ebx,%ebx
  800bf9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfe:	0f 44 d8             	cmove  %eax,%ebx
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c09:	eb 50                	jmp    800c5b <strtol+0x9a>
		s++;
  800c0b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c13:	eb d5                	jmp    800bea <strtol+0x29>
		s++, neg = 1;
  800c15:	83 c1 01             	add    $0x1,%ecx
  800c18:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1d:	eb cb                	jmp    800bea <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c23:	74 0e                	je     800c33 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	75 d8                	jne    800c01 <strtol+0x40>
		s++, base = 8;
  800c29:	83 c1 01             	add    $0x1,%ecx
  800c2c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c31:	eb ce                	jmp    800c01 <strtol+0x40>
		s += 2, base = 16;
  800c33:	83 c1 02             	add    $0x2,%ecx
  800c36:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3b:	eb c4                	jmp    800c01 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c40:	89 f3                	mov    %esi,%ebx
  800c42:	80 fb 19             	cmp    $0x19,%bl
  800c45:	77 29                	ja     800c70 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c47:	0f be d2             	movsbl %dl,%edx
  800c4a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c50:	7d 30                	jge    800c82 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5b:	0f b6 11             	movzbl (%ecx),%edx
  800c5e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c61:	89 f3                	mov    %esi,%ebx
  800c63:	80 fb 09             	cmp    $0x9,%bl
  800c66:	77 d5                	ja     800c3d <strtol+0x7c>
			dig = *s - '0';
  800c68:	0f be d2             	movsbl %dl,%edx
  800c6b:	83 ea 30             	sub    $0x30,%edx
  800c6e:	eb dd                	jmp    800c4d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c70:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c73:	89 f3                	mov    %esi,%ebx
  800c75:	80 fb 19             	cmp    $0x19,%bl
  800c78:	77 08                	ja     800c82 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c7a:	0f be d2             	movsbl %dl,%edx
  800c7d:	83 ea 37             	sub    $0x37,%edx
  800c80:	eb cb                	jmp    800c4d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c86:	74 05                	je     800c8d <strtol+0xcc>
		*endptr = (char *) s;
  800c88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8d:	89 c2                	mov    %eax,%edx
  800c8f:	f7 da                	neg    %edx
  800c91:	85 ff                	test   %edi,%edi
  800c93:	0f 45 c2             	cmovne %edx,%eax
}
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cac:	89 c3                	mov    %eax,%ebx
  800cae:	89 c7                	mov    %eax,%edi
  800cb0:	89 c6                	mov    %eax,%esi
  800cb2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc9:	89 d1                	mov    %edx,%ecx
  800ccb:	89 d3                	mov    %edx,%ebx
  800ccd:	89 d7                	mov    %edx,%edi
  800ccf:	89 d6                	mov    %edx,%esi
  800cd1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cee:	89 cb                	mov    %ecx,%ebx
  800cf0:	89 cf                	mov    %ecx,%edi
  800cf2:	89 ce                	mov    %ecx,%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 03                	push   $0x3
  800d08:	68 44 2f 80 00       	push   $0x802f44
  800d0d:	6a 43                	push   $0x43
  800d0f:	68 61 2f 80 00       	push   $0x802f61
  800d14:	e8 50 19 00 00       	call   802669 <_panic>

00800d19 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d24:	b8 02 00 00 00       	mov    $0x2,%eax
  800d29:	89 d1                	mov    %edx,%ecx
  800d2b:	89 d3                	mov    %edx,%ebx
  800d2d:	89 d7                	mov    %edx,%edi
  800d2f:	89 d6                	mov    %edx,%esi
  800d31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_yield>:

void
sys_yield(void)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d43:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d48:	89 d1                	mov    %edx,%ecx
  800d4a:	89 d3                	mov    %edx,%ebx
  800d4c:	89 d7                	mov    %edx,%edi
  800d4e:	89 d6                	mov    %edx,%esi
  800d50:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d60:	be 00 00 00 00       	mov    $0x0,%esi
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d73:	89 f7                	mov    %esi,%edi
  800d75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7f 08                	jg     800d83 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	50                   	push   %eax
  800d87:	6a 04                	push   $0x4
  800d89:	68 44 2f 80 00       	push   $0x802f44
  800d8e:	6a 43                	push   $0x43
  800d90:	68 61 2f 80 00       	push   $0x802f61
  800d95:	e8 cf 18 00 00       	call   802669 <_panic>

00800d9a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db4:	8b 75 18             	mov    0x18(%ebp),%esi
  800db7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7f 08                	jg     800dc5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	83 ec 0c             	sub    $0xc,%esp
  800dc8:	50                   	push   %eax
  800dc9:	6a 05                	push   $0x5
  800dcb:	68 44 2f 80 00       	push   $0x802f44
  800dd0:	6a 43                	push   $0x43
  800dd2:	68 61 2f 80 00       	push   $0x802f61
  800dd7:	e8 8d 18 00 00       	call   802669 <_panic>

00800ddc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 06 00 00 00       	mov    $0x6,%eax
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7f 08                	jg     800e07 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	50                   	push   %eax
  800e0b:	6a 06                	push   $0x6
  800e0d:	68 44 2f 80 00       	push   $0x802f44
  800e12:	6a 43                	push   $0x43
  800e14:	68 61 2f 80 00       	push   $0x802f61
  800e19:	e8 4b 18 00 00       	call   802669 <_panic>

00800e1e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 08 00 00 00       	mov    $0x8,%eax
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 08                	push   $0x8
  800e4f:	68 44 2f 80 00       	push   $0x802f44
  800e54:	6a 43                	push   $0x43
  800e56:	68 61 2f 80 00       	push   $0x802f61
  800e5b:	e8 09 18 00 00       	call   802669 <_panic>

00800e60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	b8 09 00 00 00       	mov    $0x9,%eax
  800e79:	89 df                	mov    %ebx,%edi
  800e7b:	89 de                	mov    %ebx,%esi
  800e7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7f 08                	jg     800e8b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	83 ec 0c             	sub    $0xc,%esp
  800e8e:	50                   	push   %eax
  800e8f:	6a 09                	push   $0x9
  800e91:	68 44 2f 80 00       	push   $0x802f44
  800e96:	6a 43                	push   $0x43
  800e98:	68 61 2f 80 00       	push   $0x802f61
  800e9d:	e8 c7 17 00 00       	call   802669 <_panic>

00800ea2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	89 de                	mov    %ebx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 0a                	push   $0xa
  800ed3:	68 44 2f 80 00       	push   $0x802f44
  800ed8:	6a 43                	push   $0x43
  800eda:	68 61 2f 80 00       	push   $0x802f61
  800edf:	e8 85 17 00 00       	call   802669 <_panic>

00800ee4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef5:	be 00 00 00 00       	mov    $0x0,%esi
  800efa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f00:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1d:	89 cb                	mov    %ecx,%ebx
  800f1f:	89 cf                	mov    %ecx,%edi
  800f21:	89 ce                	mov    %ecx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 0d                	push   $0xd
  800f37:	68 44 2f 80 00       	push   $0x802f44
  800f3c:	6a 43                	push   $0x43
  800f3e:	68 61 2f 80 00       	push   $0x802f61
  800f43:	e8 21 17 00 00       	call   802669 <_panic>

00800f48 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f53:	8b 55 08             	mov    0x8(%ebp),%edx
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5e:	89 df                	mov    %ebx,%edi
  800f60:	89 de                	mov    %ebx,%esi
  800f62:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7c:	89 cb                	mov    %ecx,%ebx
  800f7e:	89 cf                	mov    %ecx,%edi
  800f80:	89 ce                	mov    %ecx,%esi
  800f82:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f94:	b8 10 00 00 00       	mov    $0x10,%eax
  800f99:	89 d1                	mov    %edx,%ecx
  800f9b:	89 d3                	mov    %edx,%ebx
  800f9d:	89 d7                	mov    %edx,%edi
  800f9f:	89 d6                	mov    %edx,%esi
  800fa1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	b8 11 00 00 00       	mov    $0x11,%eax
  800fbe:	89 df                	mov    %ebx,%edi
  800fc0:	89 de                	mov    %ebx,%esi
  800fc2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	b8 12 00 00 00       	mov    $0x12,%eax
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	89 de                	mov    %ebx,%esi
  800fe3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
  800ff0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffe:	b8 13 00 00 00       	mov    $0x13,%eax
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7f 08                	jg     801015 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	83 ec 0c             	sub    $0xc,%esp
  801018:	50                   	push   %eax
  801019:	6a 13                	push   $0x13
  80101b:	68 44 2f 80 00       	push   $0x802f44
  801020:	6a 43                	push   $0x43
  801022:	68 61 2f 80 00       	push   $0x802f61
  801027:	e8 3d 16 00 00       	call   802669 <_panic>

0080102c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	53                   	push   %ebx
  801030:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801033:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80103a:	f6 c5 04             	test   $0x4,%ch
  80103d:	75 45                	jne    801084 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80103f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801046:	83 e1 07             	and    $0x7,%ecx
  801049:	83 f9 07             	cmp    $0x7,%ecx
  80104c:	74 6f                	je     8010bd <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80104e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801055:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80105b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801061:	0f 84 b6 00 00 00    	je     80111d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801067:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80106e:	83 e1 05             	and    $0x5,%ecx
  801071:	83 f9 05             	cmp    $0x5,%ecx
  801074:	0f 84 d7 00 00 00    	je     801151 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80107a:	b8 00 00 00 00       	mov    $0x0,%eax
  80107f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801082:	c9                   	leave  
  801083:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801084:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80108b:	c1 e2 0c             	shl    $0xc,%edx
  80108e:	83 ec 0c             	sub    $0xc,%esp
  801091:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801097:	51                   	push   %ecx
  801098:	52                   	push   %edx
  801099:	50                   	push   %eax
  80109a:	52                   	push   %edx
  80109b:	6a 00                	push   $0x0
  80109d:	e8 f8 fc ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  8010a2:	83 c4 20             	add    $0x20,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	79 d1                	jns    80107a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	68 6f 2f 80 00       	push   $0x802f6f
  8010b1:	6a 54                	push   $0x54
  8010b3:	68 85 2f 80 00       	push   $0x802f85
  8010b8:	e8 ac 15 00 00       	call   802669 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010bd:	89 d3                	mov    %edx,%ebx
  8010bf:	c1 e3 0c             	shl    $0xc,%ebx
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	68 05 08 00 00       	push   $0x805
  8010ca:	53                   	push   %ebx
  8010cb:	50                   	push   %eax
  8010cc:	53                   	push   %ebx
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 c6 fc ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  8010d4:	83 c4 20             	add    $0x20,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	78 2e                	js     801109 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010db:	83 ec 0c             	sub    $0xc,%esp
  8010de:	68 05 08 00 00       	push   $0x805
  8010e3:	53                   	push   %ebx
  8010e4:	6a 00                	push   $0x0
  8010e6:	53                   	push   %ebx
  8010e7:	6a 00                	push   $0x0
  8010e9:	e8 ac fc ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  8010ee:	83 c4 20             	add    $0x20,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	79 85                	jns    80107a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	68 6f 2f 80 00       	push   $0x802f6f
  8010fd:	6a 5f                	push   $0x5f
  8010ff:	68 85 2f 80 00       	push   $0x802f85
  801104:	e8 60 15 00 00       	call   802669 <_panic>
			panic("sys_page_map() panic\n");
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	68 6f 2f 80 00       	push   $0x802f6f
  801111:	6a 5b                	push   $0x5b
  801113:	68 85 2f 80 00       	push   $0x802f85
  801118:	e8 4c 15 00 00       	call   802669 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80111d:	c1 e2 0c             	shl    $0xc,%edx
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	68 05 08 00 00       	push   $0x805
  801128:	52                   	push   %edx
  801129:	50                   	push   %eax
  80112a:	52                   	push   %edx
  80112b:	6a 00                	push   $0x0
  80112d:	e8 68 fc ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  801132:	83 c4 20             	add    $0x20,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	0f 89 3d ff ff ff    	jns    80107a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	68 6f 2f 80 00       	push   $0x802f6f
  801145:	6a 66                	push   $0x66
  801147:	68 85 2f 80 00       	push   $0x802f85
  80114c:	e8 18 15 00 00       	call   802669 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801151:	c1 e2 0c             	shl    $0xc,%edx
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	6a 05                	push   $0x5
  801159:	52                   	push   %edx
  80115a:	50                   	push   %eax
  80115b:	52                   	push   %edx
  80115c:	6a 00                	push   $0x0
  80115e:	e8 37 fc ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	0f 89 0c ff ff ff    	jns    80107a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	68 6f 2f 80 00       	push   $0x802f6f
  801176:	6a 6d                	push   $0x6d
  801178:	68 85 2f 80 00       	push   $0x802f85
  80117d:	e8 e7 14 00 00       	call   802669 <_panic>

00801182 <pgfault>:
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	53                   	push   %ebx
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80118c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80118e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801192:	0f 84 99 00 00 00    	je     801231 <pgfault+0xaf>
  801198:	89 c2                	mov    %eax,%edx
  80119a:	c1 ea 16             	shr    $0x16,%edx
  80119d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a4:	f6 c2 01             	test   $0x1,%dl
  8011a7:	0f 84 84 00 00 00    	je     801231 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	c1 ea 0c             	shr    $0xc,%edx
  8011b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011bf:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011c5:	75 6a                	jne    801231 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011cc:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	6a 07                	push   $0x7
  8011d3:	68 00 f0 7f 00       	push   $0x7ff000
  8011d8:	6a 00                	push   $0x0
  8011da:	e8 78 fb ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	78 5f                	js     801245 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	68 00 10 00 00       	push   $0x1000
  8011ee:	53                   	push   %ebx
  8011ef:	68 00 f0 7f 00       	push   $0x7ff000
  8011f4:	e8 5c f9 ff ff       	call   800b55 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011f9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801200:	53                   	push   %ebx
  801201:	6a 00                	push   $0x0
  801203:	68 00 f0 7f 00       	push   $0x7ff000
  801208:	6a 00                	push   $0x0
  80120a:	e8 8b fb ff ff       	call   800d9a <sys_page_map>
	if(ret < 0)
  80120f:	83 c4 20             	add    $0x20,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 43                	js     801259 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	68 00 f0 7f 00       	push   $0x7ff000
  80121e:	6a 00                	push   $0x0
  801220:	e8 b7 fb ff ff       	call   800ddc <sys_page_unmap>
	if(ret < 0)
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 41                	js     80126d <pgfault+0xeb>
}
  80122c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122f:	c9                   	leave  
  801230:	c3                   	ret    
		panic("panic at pgfault()\n");
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	68 90 2f 80 00       	push   $0x802f90
  801239:	6a 26                	push   $0x26
  80123b:	68 85 2f 80 00       	push   $0x802f85
  801240:	e8 24 14 00 00       	call   802669 <_panic>
		panic("panic in sys_page_alloc()\n");
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	68 a4 2f 80 00       	push   $0x802fa4
  80124d:	6a 31                	push   $0x31
  80124f:	68 85 2f 80 00       	push   $0x802f85
  801254:	e8 10 14 00 00       	call   802669 <_panic>
		panic("panic in sys_page_map()\n");
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	68 bf 2f 80 00       	push   $0x802fbf
  801261:	6a 36                	push   $0x36
  801263:	68 85 2f 80 00       	push   $0x802f85
  801268:	e8 fc 13 00 00       	call   802669 <_panic>
		panic("panic in sys_page_unmap()\n");
  80126d:	83 ec 04             	sub    $0x4,%esp
  801270:	68 d8 2f 80 00       	push   $0x802fd8
  801275:	6a 39                	push   $0x39
  801277:	68 85 2f 80 00       	push   $0x802f85
  80127c:	e8 e8 13 00 00       	call   802669 <_panic>

00801281 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80128a:	68 82 11 80 00       	push   $0x801182
  80128f:	e8 36 14 00 00       	call   8026ca <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801294:	b8 07 00 00 00       	mov    $0x7,%eax
  801299:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 27                	js     8012c9 <fork+0x48>
  8012a2:	89 c6                	mov    %eax,%esi
  8012a4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012a6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012ab:	75 48                	jne    8012f5 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ad:	e8 67 fa ff ff       	call   800d19 <sys_getenvid>
  8012b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012b7:	c1 e0 07             	shl    $0x7,%eax
  8012ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012bf:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012c4:	e9 90 00 00 00       	jmp    801359 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	68 f4 2f 80 00       	push   $0x802ff4
  8012d1:	68 8c 00 00 00       	push   $0x8c
  8012d6:	68 85 2f 80 00       	push   $0x802f85
  8012db:	e8 89 13 00 00       	call   802669 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012e0:	89 f8                	mov    %edi,%eax
  8012e2:	e8 45 fd ff ff       	call   80102c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012ed:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012f3:	74 26                	je     80131b <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	c1 e8 16             	shr    $0x16,%eax
  8012fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801301:	a8 01                	test   $0x1,%al
  801303:	74 e2                	je     8012e7 <fork+0x66>
  801305:	89 da                	mov    %ebx,%edx
  801307:	c1 ea 0c             	shr    $0xc,%edx
  80130a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801311:	83 e0 05             	and    $0x5,%eax
  801314:	83 f8 05             	cmp    $0x5,%eax
  801317:	75 ce                	jne    8012e7 <fork+0x66>
  801319:	eb c5                	jmp    8012e0 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	6a 07                	push   $0x7
  801320:	68 00 f0 bf ee       	push   $0xeebff000
  801325:	56                   	push   %esi
  801326:	e8 2c fa ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 31                	js     801363 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	68 39 27 80 00       	push   $0x802739
  80133a:	56                   	push   %esi
  80133b:	e8 62 fb ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 33                	js     80137a <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801347:	83 ec 08             	sub    $0x8,%esp
  80134a:	6a 02                	push   $0x2
  80134c:	56                   	push   %esi
  80134d:	e8 cc fa ff ff       	call   800e1e <sys_env_set_status>
	if(ret < 0)
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 38                	js     801391 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801359:	89 f0                	mov    %esi,%eax
  80135b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135e:	5b                   	pop    %ebx
  80135f:	5e                   	pop    %esi
  801360:	5f                   	pop    %edi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	68 a4 2f 80 00       	push   $0x802fa4
  80136b:	68 98 00 00 00       	push   $0x98
  801370:	68 85 2f 80 00       	push   $0x802f85
  801375:	e8 ef 12 00 00       	call   802669 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	68 18 30 80 00       	push   $0x803018
  801382:	68 9b 00 00 00       	push   $0x9b
  801387:	68 85 2f 80 00       	push   $0x802f85
  80138c:	e8 d8 12 00 00       	call   802669 <_panic>
		panic("panic in sys_env_set_status()\n");
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	68 40 30 80 00       	push   $0x803040
  801399:	68 9e 00 00 00       	push   $0x9e
  80139e:	68 85 2f 80 00       	push   $0x802f85
  8013a3:	e8 c1 12 00 00       	call   802669 <_panic>

008013a8 <sfork>:

// Challenge!
int
sfork(void)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013b1:	68 82 11 80 00       	push   $0x801182
  8013b6:	e8 0f 13 00 00       	call   8026ca <set_pgfault_handler>
  8013bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8013c0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 27                	js     8013f0 <sfork+0x48>
  8013c9:	89 c7                	mov    %eax,%edi
  8013cb:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013cd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013d2:	75 55                	jne    801429 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013d4:	e8 40 f9 ff ff       	call   800d19 <sys_getenvid>
  8013d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013de:	c1 e0 07             	shl    $0x7,%eax
  8013e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013e6:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013eb:	e9 d4 00 00 00       	jmp    8014c4 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	68 f4 2f 80 00       	push   $0x802ff4
  8013f8:	68 af 00 00 00       	push   $0xaf
  8013fd:	68 85 2f 80 00       	push   $0x802f85
  801402:	e8 62 12 00 00       	call   802669 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801407:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80140c:	89 f0                	mov    %esi,%eax
  80140e:	e8 19 fc ff ff       	call   80102c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801413:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801419:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80141f:	77 65                	ja     801486 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801421:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801427:	74 de                	je     801407 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801429:	89 d8                	mov    %ebx,%eax
  80142b:	c1 e8 16             	shr    $0x16,%eax
  80142e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801435:	a8 01                	test   $0x1,%al
  801437:	74 da                	je     801413 <sfork+0x6b>
  801439:	89 da                	mov    %ebx,%edx
  80143b:	c1 ea 0c             	shr    $0xc,%edx
  80143e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801445:	83 e0 05             	and    $0x5,%eax
  801448:	83 f8 05             	cmp    $0x5,%eax
  80144b:	75 c6                	jne    801413 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80144d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801454:	c1 e2 0c             	shl    $0xc,%edx
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	83 e0 07             	and    $0x7,%eax
  80145d:	50                   	push   %eax
  80145e:	52                   	push   %edx
  80145f:	56                   	push   %esi
  801460:	52                   	push   %edx
  801461:	6a 00                	push   $0x0
  801463:	e8 32 f9 ff ff       	call   800d9a <sys_page_map>
  801468:	83 c4 20             	add    $0x20,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	74 a4                	je     801413 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	68 6f 2f 80 00       	push   $0x802f6f
  801477:	68 ba 00 00 00       	push   $0xba
  80147c:	68 85 2f 80 00       	push   $0x802f85
  801481:	e8 e3 11 00 00       	call   802669 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 07                	push   $0x7
  80148b:	68 00 f0 bf ee       	push   $0xeebff000
  801490:	57                   	push   %edi
  801491:	e8 c1 f8 ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 31                	js     8014ce <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	68 39 27 80 00       	push   $0x802739
  8014a5:	57                   	push   %edi
  8014a6:	e8 f7 f9 ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 33                	js     8014e5 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	6a 02                	push   $0x2
  8014b7:	57                   	push   %edi
  8014b8:	e8 61 f9 ff ff       	call   800e1e <sys_env_set_status>
	if(ret < 0)
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 38                	js     8014fc <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014c4:	89 f8                	mov    %edi,%eax
  8014c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5e                   	pop    %esi
  8014cb:	5f                   	pop    %edi
  8014cc:	5d                   	pop    %ebp
  8014cd:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 a4 2f 80 00       	push   $0x802fa4
  8014d6:	68 c0 00 00 00       	push   $0xc0
  8014db:	68 85 2f 80 00       	push   $0x802f85
  8014e0:	e8 84 11 00 00       	call   802669 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	68 18 30 80 00       	push   $0x803018
  8014ed:	68 c3 00 00 00       	push   $0xc3
  8014f2:	68 85 2f 80 00       	push   $0x802f85
  8014f7:	e8 6d 11 00 00       	call   802669 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014fc:	83 ec 04             	sub    $0x4,%esp
  8014ff:	68 40 30 80 00       	push   $0x803040
  801504:	68 c6 00 00 00       	push   $0xc6
  801509:	68 85 2f 80 00       	push   $0x802f85
  80150e:	e8 56 11 00 00       	call   802669 <_panic>

00801513 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	05 00 00 00 30       	add    $0x30000000,%eax
  80151e:	c1 e8 0c             	shr    $0xc,%eax
}
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80152e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801533:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801538:	5d                   	pop    %ebp
  801539:	c3                   	ret    

0080153a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	89 c2                	mov    %eax,%edx
  801544:	c1 ea 16             	shr    $0x16,%edx
  801547:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154e:	f6 c2 01             	test   $0x1,%dl
  801551:	74 2d                	je     801580 <fd_alloc+0x46>
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 1c                	je     801580 <fd_alloc+0x46>
  801564:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801569:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80156e:	75 d2                	jne    801542 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801579:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80157e:	eb 0a                	jmp    80158a <fd_alloc+0x50>
			*fd_store = fd;
  801580:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801583:	89 01                	mov    %eax,(%ecx)
			return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801592:	83 f8 1f             	cmp    $0x1f,%eax
  801595:	77 30                	ja     8015c7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801597:	c1 e0 0c             	shl    $0xc,%eax
  80159a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80159f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015a5:	f6 c2 01             	test   $0x1,%dl
  8015a8:	74 24                	je     8015ce <fd_lookup+0x42>
  8015aa:	89 c2                	mov    %eax,%edx
  8015ac:	c1 ea 0c             	shr    $0xc,%edx
  8015af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b6:	f6 c2 01             	test   $0x1,%dl
  8015b9:	74 1a                	je     8015d5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	89 02                	mov    %eax,(%edx)
	return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    
		return -E_INVAL;
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cc:	eb f7                	jmp    8015c5 <fd_lookup+0x39>
		return -E_INVAL;
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d3:	eb f0                	jmp    8015c5 <fd_lookup+0x39>
  8015d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015da:	eb e9                	jmp    8015c5 <fd_lookup+0x39>

008015dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015ef:	39 08                	cmp    %ecx,(%eax)
  8015f1:	74 38                	je     80162b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8015f3:	83 c2 01             	add    $0x1,%edx
  8015f6:	8b 04 95 dc 30 80 00 	mov    0x8030dc(,%edx,4),%eax
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	75 ee                	jne    8015ef <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801601:	a1 08 50 80 00       	mov    0x805008,%eax
  801606:	8b 40 48             	mov    0x48(%eax),%eax
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	51                   	push   %ecx
  80160d:	50                   	push   %eax
  80160e:	68 60 30 80 00       	push   $0x803060
  801613:	e8 ee eb ff ff       	call   800206 <cprintf>
	*dev = 0;
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    
			*dev = devtab[i];
  80162b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
  801635:	eb f2                	jmp    801629 <dev_lookup+0x4d>

00801637 <fd_close>:
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	57                   	push   %edi
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
  80163d:	83 ec 24             	sub    $0x24,%esp
  801640:	8b 75 08             	mov    0x8(%ebp),%esi
  801643:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801646:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801649:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80164a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801650:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801653:	50                   	push   %eax
  801654:	e8 33 ff ff ff       	call   80158c <fd_lookup>
  801659:	89 c3                	mov    %eax,%ebx
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 05                	js     801667 <fd_close+0x30>
	    || fd != fd2)
  801662:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801665:	74 16                	je     80167d <fd_close+0x46>
		return (must_exist ? r : 0);
  801667:	89 f8                	mov    %edi,%eax
  801669:	84 c0                	test   %al,%al
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	0f 44 d8             	cmove  %eax,%ebx
}
  801673:	89 d8                	mov    %ebx,%eax
  801675:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5f                   	pop    %edi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	ff 36                	pushl  (%esi)
  801686:	e8 51 ff ff ff       	call   8015dc <dev_lookup>
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	78 1a                	js     8016ae <fd_close+0x77>
		if (dev->dev_close)
  801694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801697:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80169a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	74 0b                	je     8016ae <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	56                   	push   %esi
  8016a7:	ff d0                	call   *%eax
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	56                   	push   %esi
  8016b2:	6a 00                	push   $0x0
  8016b4:	e8 23 f7 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	eb b5                	jmp    801673 <fd_close+0x3c>

008016be <close>:

int
close(int fdnum)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	e8 bc fe ff ff       	call   80158c <fd_lookup>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	79 02                	jns    8016d9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    
		return fd_close(fd, 1);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	6a 01                	push   $0x1
  8016de:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e1:	e8 51 ff ff ff       	call   801637 <fd_close>
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	eb ec                	jmp    8016d7 <close+0x19>

008016eb <close_all>:

void
close_all(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016f2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	53                   	push   %ebx
  8016fb:	e8 be ff ff ff       	call   8016be <close>
	for (i = 0; i < MAXFD; i++)
  801700:	83 c3 01             	add    $0x1,%ebx
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	83 fb 20             	cmp    $0x20,%ebx
  801709:	75 ec                	jne    8016f7 <close_all+0xc>
}
  80170b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	57                   	push   %edi
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801719:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 67 fe ff ff       	call   80158c <fd_lookup>
  801725:	89 c3                	mov    %eax,%ebx
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	0f 88 81 00 00 00    	js     8017b3 <dup+0xa3>
		return r;
	close(newfdnum);
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	e8 81 ff ff ff       	call   8016be <close>

	newfd = INDEX2FD(newfdnum);
  80173d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801740:	c1 e6 0c             	shl    $0xc,%esi
  801743:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801749:	83 c4 04             	add    $0x4,%esp
  80174c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174f:	e8 cf fd ff ff       	call   801523 <fd2data>
  801754:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801756:	89 34 24             	mov    %esi,(%esp)
  801759:	e8 c5 fd ff ff       	call   801523 <fd2data>
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801763:	89 d8                	mov    %ebx,%eax
  801765:	c1 e8 16             	shr    $0x16,%eax
  801768:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80176f:	a8 01                	test   $0x1,%al
  801771:	74 11                	je     801784 <dup+0x74>
  801773:	89 d8                	mov    %ebx,%eax
  801775:	c1 e8 0c             	shr    $0xc,%eax
  801778:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80177f:	f6 c2 01             	test   $0x1,%dl
  801782:	75 39                	jne    8017bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801784:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801787:	89 d0                	mov    %edx,%eax
  801789:	c1 e8 0c             	shr    $0xc,%eax
  80178c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	25 07 0e 00 00       	and    $0xe07,%eax
  80179b:	50                   	push   %eax
  80179c:	56                   	push   %esi
  80179d:	6a 00                	push   $0x0
  80179f:	52                   	push   %edx
  8017a0:	6a 00                	push   $0x0
  8017a2:	e8 f3 f5 ff ff       	call   800d9a <sys_page_map>
  8017a7:	89 c3                	mov    %eax,%ebx
  8017a9:	83 c4 20             	add    $0x20,%esp
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 31                	js     8017e1 <dup+0xd1>
		goto err;

	return newfdnum;
  8017b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017b3:	89 d8                	mov    %ebx,%eax
  8017b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017cc:	50                   	push   %eax
  8017cd:	57                   	push   %edi
  8017ce:	6a 00                	push   $0x0
  8017d0:	53                   	push   %ebx
  8017d1:	6a 00                	push   $0x0
  8017d3:	e8 c2 f5 ff ff       	call   800d9a <sys_page_map>
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	83 c4 20             	add    $0x20,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	79 a3                	jns    801784 <dup+0x74>
	sys_page_unmap(0, newfd);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	56                   	push   %esi
  8017e5:	6a 00                	push   $0x0
  8017e7:	e8 f0 f5 ff ff       	call   800ddc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017ec:	83 c4 08             	add    $0x8,%esp
  8017ef:	57                   	push   %edi
  8017f0:	6a 00                	push   $0x0
  8017f2:	e8 e5 f5 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	eb b7                	jmp    8017b3 <dup+0xa3>

008017fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 1c             	sub    $0x1c,%esp
  801803:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801806:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801809:	50                   	push   %eax
  80180a:	53                   	push   %ebx
  80180b:	e8 7c fd ff ff       	call   80158c <fd_lookup>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	85 c0                	test   %eax,%eax
  801815:	78 3f                	js     801856 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	ff 30                	pushl  (%eax)
  801823:	e8 b4 fd ff ff       	call   8015dc <dev_lookup>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 27                	js     801856 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80182f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801832:	8b 42 08             	mov    0x8(%edx),%eax
  801835:	83 e0 03             	and    $0x3,%eax
  801838:	83 f8 01             	cmp    $0x1,%eax
  80183b:	74 1e                	je     80185b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	8b 40 08             	mov    0x8(%eax),%eax
  801843:	85 c0                	test   %eax,%eax
  801845:	74 35                	je     80187c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	ff 75 10             	pushl  0x10(%ebp)
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	52                   	push   %edx
  801851:	ff d0                	call   *%eax
  801853:	83 c4 10             	add    $0x10,%esp
}
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80185b:	a1 08 50 80 00       	mov    0x805008,%eax
  801860:	8b 40 48             	mov    0x48(%eax),%eax
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	53                   	push   %ebx
  801867:	50                   	push   %eax
  801868:	68 a1 30 80 00       	push   $0x8030a1
  80186d:	e8 94 e9 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187a:	eb da                	jmp    801856 <read+0x5a>
		return -E_NOT_SUPP;
  80187c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801881:	eb d3                	jmp    801856 <read+0x5a>

00801883 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	57                   	push   %edi
  801887:	56                   	push   %esi
  801888:	53                   	push   %ebx
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80188f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801892:	bb 00 00 00 00       	mov    $0x0,%ebx
  801897:	39 f3                	cmp    %esi,%ebx
  801899:	73 23                	jae    8018be <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	89 f0                	mov    %esi,%eax
  8018a0:	29 d8                	sub    %ebx,%eax
  8018a2:	50                   	push   %eax
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	03 45 0c             	add    0xc(%ebp),%eax
  8018a8:	50                   	push   %eax
  8018a9:	57                   	push   %edi
  8018aa:	e8 4d ff ff ff       	call   8017fc <read>
		if (m < 0)
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 06                	js     8018bc <readn+0x39>
			return m;
		if (m == 0)
  8018b6:	74 06                	je     8018be <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018b8:	01 c3                	add    %eax,%ebx
  8018ba:	eb db                	jmp    801897 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018bc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018be:	89 d8                	mov    %ebx,%eax
  8018c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    

008018c8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 1c             	sub    $0x1c,%esp
  8018cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d5:	50                   	push   %eax
  8018d6:	53                   	push   %ebx
  8018d7:	e8 b0 fc ff ff       	call   80158c <fd_lookup>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 3a                	js     80191d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e9:	50                   	push   %eax
  8018ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ed:	ff 30                	pushl  (%eax)
  8018ef:	e8 e8 fc ff ff       	call   8015dc <dev_lookup>
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 22                	js     80191d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fe:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801902:	74 1e                	je     801922 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801907:	8b 52 0c             	mov    0xc(%edx),%edx
  80190a:	85 d2                	test   %edx,%edx
  80190c:	74 35                	je     801943 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	ff 75 10             	pushl  0x10(%ebp)
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	50                   	push   %eax
  801918:	ff d2                	call   *%edx
  80191a:	83 c4 10             	add    $0x10,%esp
}
  80191d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801920:	c9                   	leave  
  801921:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801922:	a1 08 50 80 00       	mov    0x805008,%eax
  801927:	8b 40 48             	mov    0x48(%eax),%eax
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	53                   	push   %ebx
  80192e:	50                   	push   %eax
  80192f:	68 bd 30 80 00       	push   $0x8030bd
  801934:	e8 cd e8 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801941:	eb da                	jmp    80191d <write+0x55>
		return -E_NOT_SUPP;
  801943:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801948:	eb d3                	jmp    80191d <write+0x55>

0080194a <seek>:

int
seek(int fdnum, off_t offset)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801950:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801953:	50                   	push   %eax
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 30 fc ff ff       	call   80158c <fd_lookup>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 0e                	js     801971 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	53                   	push   %ebx
  801977:	83 ec 1c             	sub    $0x1c,%esp
  80197a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	53                   	push   %ebx
  801982:	e8 05 fc ff ff       	call   80158c <fd_lookup>
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 37                	js     8019c5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801994:	50                   	push   %eax
  801995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801998:	ff 30                	pushl  (%eax)
  80199a:	e8 3d fc ff ff       	call   8015dc <dev_lookup>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 1f                	js     8019c5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ad:	74 1b                	je     8019ca <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	8b 52 18             	mov    0x18(%edx),%edx
  8019b5:	85 d2                	test   %edx,%edx
  8019b7:	74 32                	je     8019eb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	50                   	push   %eax
  8019c0:	ff d2                	call   *%edx
  8019c2:	83 c4 10             	add    $0x10,%esp
}
  8019c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019ca:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019cf:	8b 40 48             	mov    0x48(%eax),%eax
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	53                   	push   %ebx
  8019d6:	50                   	push   %eax
  8019d7:	68 80 30 80 00       	push   $0x803080
  8019dc:	e8 25 e8 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e9:	eb da                	jmp    8019c5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f0:	eb d3                	jmp    8019c5 <ftruncate+0x52>

008019f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 1c             	sub    $0x1c,%esp
  8019f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ff:	50                   	push   %eax
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	e8 84 fb ff ff       	call   80158c <fd_lookup>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 4b                	js     801a5a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a15:	50                   	push   %eax
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	ff 30                	pushl  (%eax)
  801a1b:	e8 bc fb ff ff       	call   8015dc <dev_lookup>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 33                	js     801a5a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a2e:	74 2f                	je     801a5f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a30:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a33:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a3a:	00 00 00 
	stat->st_isdir = 0;
  801a3d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a44:	00 00 00 
	stat->st_dev = dev;
  801a47:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	53                   	push   %ebx
  801a51:	ff 75 f0             	pushl  -0x10(%ebp)
  801a54:	ff 50 14             	call   *0x14(%eax)
  801a57:	83 c4 10             	add    $0x10,%esp
}
  801a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    
		return -E_NOT_SUPP;
  801a5f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a64:	eb f4                	jmp    801a5a <fstat+0x68>

00801a66 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	56                   	push   %esi
  801a6a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 22 02 00 00       	call   801c9a <open>
  801a78:	89 c3                	mov    %eax,%ebx
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 1b                	js     801a9c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	50                   	push   %eax
  801a88:	e8 65 ff ff ff       	call   8019f2 <fstat>
  801a8d:	89 c6                	mov    %eax,%esi
	close(fd);
  801a8f:	89 1c 24             	mov    %ebx,(%esp)
  801a92:	e8 27 fc ff ff       	call   8016be <close>
	return r;
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	89 f3                	mov    %esi,%ebx
}
  801a9c:	89 d8                	mov    %ebx,%eax
  801a9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa1:	5b                   	pop    %ebx
  801aa2:	5e                   	pop    %esi
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    

00801aa5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	56                   	push   %esi
  801aa9:	53                   	push   %ebx
  801aaa:	89 c6                	mov    %eax,%esi
  801aac:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aae:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ab5:	74 27                	je     801ade <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ab7:	6a 07                	push   $0x7
  801ab9:	68 00 60 80 00       	push   $0x806000
  801abe:	56                   	push   %esi
  801abf:	ff 35 00 50 80 00    	pushl  0x805000
  801ac5:	e8 fe 0c 00 00       	call   8027c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aca:	83 c4 0c             	add    $0xc,%esp
  801acd:	6a 00                	push   $0x0
  801acf:	53                   	push   %ebx
  801ad0:	6a 00                	push   $0x0
  801ad2:	e8 88 0c 00 00       	call   80275f <ipc_recv>
}
  801ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5e                   	pop    %esi
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	6a 01                	push   $0x1
  801ae3:	e8 38 0d 00 00       	call   802820 <ipc_find_env>
  801ae8:	a3 00 50 80 00       	mov    %eax,0x805000
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	eb c5                	jmp    801ab7 <fsipc+0x12>

00801af2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	8b 40 0c             	mov    0xc(%eax),%eax
  801afe:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b06:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	b8 02 00 00 00       	mov    $0x2,%eax
  801b15:	e8 8b ff ff ff       	call   801aa5 <fsipc>
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <devfile_flush>:
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	8b 40 0c             	mov    0xc(%eax),%eax
  801b28:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b32:	b8 06 00 00 00       	mov    $0x6,%eax
  801b37:	e8 69 ff ff ff       	call   801aa5 <fsipc>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <devfile_stat>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	53                   	push   %ebx
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b53:	ba 00 00 00 00       	mov    $0x0,%edx
  801b58:	b8 05 00 00 00       	mov    $0x5,%eax
  801b5d:	e8 43 ff ff ff       	call   801aa5 <fsipc>
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 2c                	js     801b92 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b66:	83 ec 08             	sub    $0x8,%esp
  801b69:	68 00 60 80 00       	push   $0x806000
  801b6e:	53                   	push   %ebx
  801b6f:	e8 f1 ed ff ff       	call   800965 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b74:	a1 80 60 80 00       	mov    0x806080,%eax
  801b79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b7f:	a1 84 60 80 00       	mov    0x806084,%eax
  801b84:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <devfile_write>:
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	53                   	push   %ebx
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bac:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bb2:	53                   	push   %ebx
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	68 08 60 80 00       	push   $0x806008
  801bbb:	e8 95 ef ff ff       	call   800b55 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc5:	b8 04 00 00 00       	mov    $0x4,%eax
  801bca:	e8 d6 fe ff ff       	call   801aa5 <fsipc>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 0b                	js     801be1 <devfile_write+0x4a>
	assert(r <= n);
  801bd6:	39 d8                	cmp    %ebx,%eax
  801bd8:	77 0c                	ja     801be6 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bda:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bdf:	7f 1e                	jg     801bff <devfile_write+0x68>
}
  801be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    
	assert(r <= n);
  801be6:	68 f0 30 80 00       	push   $0x8030f0
  801beb:	68 f7 30 80 00       	push   $0x8030f7
  801bf0:	68 98 00 00 00       	push   $0x98
  801bf5:	68 0c 31 80 00       	push   $0x80310c
  801bfa:	e8 6a 0a 00 00       	call   802669 <_panic>
	assert(r <= PGSIZE);
  801bff:	68 17 31 80 00       	push   $0x803117
  801c04:	68 f7 30 80 00       	push   $0x8030f7
  801c09:	68 99 00 00 00       	push   $0x99
  801c0e:	68 0c 31 80 00       	push   $0x80310c
  801c13:	e8 51 0a 00 00       	call   802669 <_panic>

00801c18 <devfile_read>:
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8b 40 0c             	mov    0xc(%eax),%eax
  801c26:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c2b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c31:	ba 00 00 00 00       	mov    $0x0,%edx
  801c36:	b8 03 00 00 00       	mov    $0x3,%eax
  801c3b:	e8 65 fe ff ff       	call   801aa5 <fsipc>
  801c40:	89 c3                	mov    %eax,%ebx
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 1f                	js     801c65 <devfile_read+0x4d>
	assert(r <= n);
  801c46:	39 f0                	cmp    %esi,%eax
  801c48:	77 24                	ja     801c6e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c4a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c4f:	7f 33                	jg     801c84 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	50                   	push   %eax
  801c55:	68 00 60 80 00       	push   $0x806000
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	e8 91 ee ff ff       	call   800af3 <memmove>
	return r;
  801c62:	83 c4 10             	add    $0x10,%esp
}
  801c65:	89 d8                	mov    %ebx,%eax
  801c67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    
	assert(r <= n);
  801c6e:	68 f0 30 80 00       	push   $0x8030f0
  801c73:	68 f7 30 80 00       	push   $0x8030f7
  801c78:	6a 7c                	push   $0x7c
  801c7a:	68 0c 31 80 00       	push   $0x80310c
  801c7f:	e8 e5 09 00 00       	call   802669 <_panic>
	assert(r <= PGSIZE);
  801c84:	68 17 31 80 00       	push   $0x803117
  801c89:	68 f7 30 80 00       	push   $0x8030f7
  801c8e:	6a 7d                	push   $0x7d
  801c90:	68 0c 31 80 00       	push   $0x80310c
  801c95:	e8 cf 09 00 00       	call   802669 <_panic>

00801c9a <open>:
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 1c             	sub    $0x1c,%esp
  801ca2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ca5:	56                   	push   %esi
  801ca6:	e8 81 ec ff ff       	call   80092c <strlen>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cb3:	7f 6c                	jg     801d21 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cbb:	50                   	push   %eax
  801cbc:	e8 79 f8 ff ff       	call   80153a <fd_alloc>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	78 3c                	js     801d06 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cca:	83 ec 08             	sub    $0x8,%esp
  801ccd:	56                   	push   %esi
  801cce:	68 00 60 80 00       	push   $0x806000
  801cd3:	e8 8d ec ff ff       	call   800965 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdb:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce8:	e8 b8 fd ff ff       	call   801aa5 <fsipc>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	78 19                	js     801d0f <open+0x75>
	return fd2num(fd);
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfc:	e8 12 f8 ff ff       	call   801513 <fd2num>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	83 c4 10             	add    $0x10,%esp
}
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    
		fd_close(fd, 0);
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	6a 00                	push   $0x0
  801d14:	ff 75 f4             	pushl  -0xc(%ebp)
  801d17:	e8 1b f9 ff ff       	call   801637 <fd_close>
		return r;
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	eb e5                	jmp    801d06 <open+0x6c>
		return -E_BAD_PATH;
  801d21:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d26:	eb de                	jmp    801d06 <open+0x6c>

00801d28 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d33:	b8 08 00 00 00       	mov    $0x8,%eax
  801d38:	e8 68 fd ff ff       	call   801aa5 <fsipc>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d45:	68 23 31 80 00       	push   $0x803123
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	e8 13 ec ff ff       	call   800965 <strcpy>
	return 0;
}
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <devsock_close>:
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 10             	sub    $0x10,%esp
  801d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d63:	53                   	push   %ebx
  801d64:	e8 f2 0a 00 00       	call   80285b <pageref>
  801d69:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d71:	83 f8 01             	cmp    $0x1,%eax
  801d74:	74 07                	je     801d7d <devsock_close+0x24>
}
  801d76:	89 d0                	mov    %edx,%eax
  801d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 73 0c             	pushl  0xc(%ebx)
  801d83:	e8 b9 02 00 00       	call   802041 <nsipc_close>
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	eb e7                	jmp    801d76 <devsock_close+0x1d>

00801d8f <devsock_write>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 10             	pushl  0x10(%ebp)
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	ff 70 0c             	pushl  0xc(%eax)
  801da3:	e8 76 03 00 00       	call   80211e <nsipc_send>
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <devsock_read>:
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 10             	pushl  0x10(%ebp)
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	ff 70 0c             	pushl  0xc(%eax)
  801dbe:	e8 ef 02 00 00       	call   8020b2 <nsipc_recv>
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <fd2sockid>:
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dcb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dce:	52                   	push   %edx
  801dcf:	50                   	push   %eax
  801dd0:	e8 b7 f7 ff ff       	call   80158c <fd_lookup>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	78 10                	js     801dec <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801de5:	39 08                	cmp    %ecx,(%eax)
  801de7:	75 05                	jne    801dee <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801de9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    
		return -E_NOT_SUPP;
  801dee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df3:	eb f7                	jmp    801dec <fd2sockid+0x27>

00801df5 <alloc_sockfd>:
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	56                   	push   %esi
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 1c             	sub    $0x1c,%esp
  801dfd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	50                   	push   %eax
  801e03:	e8 32 f7 ff ff       	call   80153a <fd_alloc>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 43                	js     801e54 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	68 07 04 00 00       	push   $0x407
  801e19:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1c:	6a 00                	push   $0x0
  801e1e:	e8 34 ef ff ff       	call   800d57 <sys_page_alloc>
  801e23:	89 c3                	mov    %eax,%ebx
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 28                	js     801e54 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e35:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e41:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e44:	83 ec 0c             	sub    $0xc,%esp
  801e47:	50                   	push   %eax
  801e48:	e8 c6 f6 ff ff       	call   801513 <fd2num>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	eb 0c                	jmp    801e60 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e54:	83 ec 0c             	sub    $0xc,%esp
  801e57:	56                   	push   %esi
  801e58:	e8 e4 01 00 00       	call   802041 <nsipc_close>
		return r;
  801e5d:	83 c4 10             	add    $0x10,%esp
}
  801e60:	89 d8                	mov    %ebx,%eax
  801e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    

00801e69 <accept>:
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	e8 4e ff ff ff       	call   801dc5 <fd2sockid>
  801e77:	85 c0                	test   %eax,%eax
  801e79:	78 1b                	js     801e96 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	50                   	push   %eax
  801e85:	e8 0e 01 00 00       	call   801f98 <nsipc_accept>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 05                	js     801e96 <accept+0x2d>
	return alloc_sockfd(r);
  801e91:	e8 5f ff ff ff       	call   801df5 <alloc_sockfd>
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <bind>:
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	e8 1f ff ff ff       	call   801dc5 <fd2sockid>
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	78 12                	js     801ebc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	ff 75 10             	pushl  0x10(%ebp)
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	50                   	push   %eax
  801eb4:	e8 31 01 00 00       	call   801fea <nsipc_bind>
  801eb9:	83 c4 10             	add    $0x10,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <shutdown>:
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	e8 f9 fe ff ff       	call   801dc5 <fd2sockid>
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 0f                	js     801edf <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ed0:	83 ec 08             	sub    $0x8,%esp
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	50                   	push   %eax
  801ed7:	e8 43 01 00 00       	call   80201f <nsipc_shutdown>
  801edc:	83 c4 10             	add    $0x10,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <connect>:
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	e8 d6 fe ff ff       	call   801dc5 <fd2sockid>
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 12                	js     801f05 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	ff 75 10             	pushl  0x10(%ebp)
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	50                   	push   %eax
  801efd:	e8 59 01 00 00       	call   80205b <nsipc_connect>
  801f02:	83 c4 10             	add    $0x10,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <listen>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	e8 b0 fe ff ff       	call   801dc5 <fd2sockid>
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 0f                	js     801f28 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	50                   	push   %eax
  801f20:	e8 6b 01 00 00       	call   802090 <nsipc_listen>
  801f25:	83 c4 10             	add    $0x10,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <socket>:

int
socket(int domain, int type, int protocol)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f30:	ff 75 10             	pushl  0x10(%ebp)
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	e8 3e 02 00 00       	call   80217c <nsipc_socket>
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	85 c0                	test   %eax,%eax
  801f43:	78 05                	js     801f4a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f45:	e8 ab fe ff ff       	call   801df5 <alloc_sockfd>
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f55:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f5c:	74 26                	je     801f84 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f5e:	6a 07                	push   $0x7
  801f60:	68 00 70 80 00       	push   $0x807000
  801f65:	53                   	push   %ebx
  801f66:	ff 35 04 50 80 00    	pushl  0x805004
  801f6c:	e8 57 08 00 00       	call   8027c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f71:	83 c4 0c             	add    $0xc,%esp
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 e0 07 00 00       	call   80275f <ipc_recv>
}
  801f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	6a 02                	push   $0x2
  801f89:	e8 92 08 00 00       	call   802820 <ipc_find_env>
  801f8e:	a3 04 50 80 00       	mov    %eax,0x805004
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	eb c6                	jmp    801f5e <nsipc+0x12>

00801f98 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fa8:	8b 06                	mov    (%esi),%eax
  801faa:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801faf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb4:	e8 93 ff ff ff       	call   801f4c <nsipc>
  801fb9:	89 c3                	mov    %eax,%ebx
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	79 09                	jns    801fc8 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fbf:	89 d8                	mov    %ebx,%eax
  801fc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fc8:	83 ec 04             	sub    $0x4,%esp
  801fcb:	ff 35 10 70 80 00    	pushl  0x807010
  801fd1:	68 00 70 80 00       	push   $0x807000
  801fd6:	ff 75 0c             	pushl  0xc(%ebp)
  801fd9:	e8 15 eb ff ff       	call   800af3 <memmove>
		*addrlen = ret->ret_addrlen;
  801fde:	a1 10 70 80 00       	mov    0x807010,%eax
  801fe3:	89 06                	mov    %eax,(%esi)
  801fe5:	83 c4 10             	add    $0x10,%esp
	return r;
  801fe8:	eb d5                	jmp    801fbf <nsipc_accept+0x27>

00801fea <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	53                   	push   %ebx
  801fee:	83 ec 08             	sub    $0x8,%esp
  801ff1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ffc:	53                   	push   %ebx
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	68 04 70 80 00       	push   $0x807004
  802005:	e8 e9 ea ff ff       	call   800af3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80200a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802010:	b8 02 00 00 00       	mov    $0x2,%eax
  802015:	e8 32 ff ff ff       	call   801f4c <nsipc>
}
  80201a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80202d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802030:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802035:	b8 03 00 00 00       	mov    $0x3,%eax
  80203a:	e8 0d ff ff ff       	call   801f4c <nsipc>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <nsipc_close>:

int
nsipc_close(int s)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80204f:	b8 04 00 00 00       	mov    $0x4,%eax
  802054:	e8 f3 fe ff ff       	call   801f4c <nsipc>
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	53                   	push   %ebx
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80206d:	53                   	push   %ebx
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	68 04 70 80 00       	push   $0x807004
  802076:	e8 78 ea ff ff       	call   800af3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80207b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802081:	b8 05 00 00 00       	mov    $0x5,%eax
  802086:	e8 c1 fe ff ff       	call   801f4c <nsipc>
}
  80208b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020a6:	b8 06 00 00 00       	mov    $0x6,%eax
  8020ab:	e8 9c fe ff ff       	call   801f4c <nsipc>
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020c2:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020cb:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020d0:	b8 07 00 00 00       	mov    $0x7,%eax
  8020d5:	e8 72 fe ff ff       	call   801f4c <nsipc>
  8020da:	89 c3                	mov    %eax,%ebx
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 1f                	js     8020ff <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020e0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020e5:	7f 21                	jg     802108 <nsipc_recv+0x56>
  8020e7:	39 c6                	cmp    %eax,%esi
  8020e9:	7c 1d                	jl     802108 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	50                   	push   %eax
  8020ef:	68 00 70 80 00       	push   $0x807000
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	e8 f7 e9 ff ff       	call   800af3 <memmove>
  8020fc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020ff:	89 d8                	mov    %ebx,%eax
  802101:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802104:	5b                   	pop    %ebx
  802105:	5e                   	pop    %esi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802108:	68 2f 31 80 00       	push   $0x80312f
  80210d:	68 f7 30 80 00       	push   $0x8030f7
  802112:	6a 62                	push   $0x62
  802114:	68 44 31 80 00       	push   $0x803144
  802119:	e8 4b 05 00 00       	call   802669 <_panic>

0080211e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	53                   	push   %ebx
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802130:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802136:	7f 2e                	jg     802166 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	53                   	push   %ebx
  80213c:	ff 75 0c             	pushl  0xc(%ebp)
  80213f:	68 0c 70 80 00       	push   $0x80700c
  802144:	e8 aa e9 ff ff       	call   800af3 <memmove>
	nsipcbuf.send.req_size = size;
  802149:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80214f:	8b 45 14             	mov    0x14(%ebp),%eax
  802152:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802157:	b8 08 00 00 00       	mov    $0x8,%eax
  80215c:	e8 eb fd ff ff       	call   801f4c <nsipc>
}
  802161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802164:	c9                   	leave  
  802165:	c3                   	ret    
	assert(size < 1600);
  802166:	68 50 31 80 00       	push   $0x803150
  80216b:	68 f7 30 80 00       	push   $0x8030f7
  802170:	6a 6d                	push   $0x6d
  802172:	68 44 31 80 00       	push   $0x803144
  802177:	e8 ed 04 00 00       	call   802669 <_panic>

0080217c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802192:	8b 45 10             	mov    0x10(%ebp),%eax
  802195:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80219a:	b8 09 00 00 00       	mov    $0x9,%eax
  80219f:	e8 a8 fd ff ff       	call   801f4c <nsipc>
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	56                   	push   %esi
  8021aa:	53                   	push   %ebx
  8021ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021ae:	83 ec 0c             	sub    $0xc,%esp
  8021b1:	ff 75 08             	pushl  0x8(%ebp)
  8021b4:	e8 6a f3 ff ff       	call   801523 <fd2data>
  8021b9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021bb:	83 c4 08             	add    $0x8,%esp
  8021be:	68 5c 31 80 00       	push   $0x80315c
  8021c3:	53                   	push   %ebx
  8021c4:	e8 9c e7 ff ff       	call   800965 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021c9:	8b 46 04             	mov    0x4(%esi),%eax
  8021cc:	2b 06                	sub    (%esi),%eax
  8021ce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021db:	00 00 00 
	stat->st_dev = &devpipe;
  8021de:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021e5:	40 80 00 
	return 0;
}
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5d                   	pop    %ebp
  8021f3:	c3                   	ret    

008021f4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 0c             	sub    $0xc,%esp
  8021fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021fe:	53                   	push   %ebx
  8021ff:	6a 00                	push   $0x0
  802201:	e8 d6 eb ff ff       	call   800ddc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802206:	89 1c 24             	mov    %ebx,(%esp)
  802209:	e8 15 f3 ff ff       	call   801523 <fd2data>
  80220e:	83 c4 08             	add    $0x8,%esp
  802211:	50                   	push   %eax
  802212:	6a 00                	push   $0x0
  802214:	e8 c3 eb ff ff       	call   800ddc <sys_page_unmap>
}
  802219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <_pipeisclosed>:
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	89 c7                	mov    %eax,%edi
  802229:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80222b:	a1 08 50 80 00       	mov    0x805008,%eax
  802230:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802233:	83 ec 0c             	sub    $0xc,%esp
  802236:	57                   	push   %edi
  802237:	e8 1f 06 00 00       	call   80285b <pageref>
  80223c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80223f:	89 34 24             	mov    %esi,(%esp)
  802242:	e8 14 06 00 00       	call   80285b <pageref>
		nn = thisenv->env_runs;
  802247:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80224d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	39 cb                	cmp    %ecx,%ebx
  802255:	74 1b                	je     802272 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802257:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80225a:	75 cf                	jne    80222b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80225c:	8b 42 58             	mov    0x58(%edx),%eax
  80225f:	6a 01                	push   $0x1
  802261:	50                   	push   %eax
  802262:	53                   	push   %ebx
  802263:	68 63 31 80 00       	push   $0x803163
  802268:	e8 99 df ff ff       	call   800206 <cprintf>
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	eb b9                	jmp    80222b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802272:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802275:	0f 94 c0             	sete   %al
  802278:	0f b6 c0             	movzbl %al,%eax
}
  80227b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80227e:	5b                   	pop    %ebx
  80227f:	5e                   	pop    %esi
  802280:	5f                   	pop    %edi
  802281:	5d                   	pop    %ebp
  802282:	c3                   	ret    

00802283 <devpipe_write>:
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	57                   	push   %edi
  802287:	56                   	push   %esi
  802288:	53                   	push   %ebx
  802289:	83 ec 28             	sub    $0x28,%esp
  80228c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80228f:	56                   	push   %esi
  802290:	e8 8e f2 ff ff       	call   801523 <fd2data>
  802295:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802297:	83 c4 10             	add    $0x10,%esp
  80229a:	bf 00 00 00 00       	mov    $0x0,%edi
  80229f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022a2:	74 4f                	je     8022f3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022a4:	8b 43 04             	mov    0x4(%ebx),%eax
  8022a7:	8b 0b                	mov    (%ebx),%ecx
  8022a9:	8d 51 20             	lea    0x20(%ecx),%edx
  8022ac:	39 d0                	cmp    %edx,%eax
  8022ae:	72 14                	jb     8022c4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022b0:	89 da                	mov    %ebx,%edx
  8022b2:	89 f0                	mov    %esi,%eax
  8022b4:	e8 65 ff ff ff       	call   80221e <_pipeisclosed>
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	75 3b                	jne    8022f8 <devpipe_write+0x75>
			sys_yield();
  8022bd:	e8 76 ea ff ff       	call   800d38 <sys_yield>
  8022c2:	eb e0                	jmp    8022a4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022c7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022cb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022ce:	89 c2                	mov    %eax,%edx
  8022d0:	c1 fa 1f             	sar    $0x1f,%edx
  8022d3:	89 d1                	mov    %edx,%ecx
  8022d5:	c1 e9 1b             	shr    $0x1b,%ecx
  8022d8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022db:	83 e2 1f             	and    $0x1f,%edx
  8022de:	29 ca                	sub    %ecx,%edx
  8022e0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022e8:	83 c0 01             	add    $0x1,%eax
  8022eb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022ee:	83 c7 01             	add    $0x1,%edi
  8022f1:	eb ac                	jmp    80229f <devpipe_write+0x1c>
	return i;
  8022f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f6:	eb 05                	jmp    8022fd <devpipe_write+0x7a>
				return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    

00802305 <devpipe_read>:
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	57                   	push   %edi
  802309:	56                   	push   %esi
  80230a:	53                   	push   %ebx
  80230b:	83 ec 18             	sub    $0x18,%esp
  80230e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802311:	57                   	push   %edi
  802312:	e8 0c f2 ff ff       	call   801523 <fd2data>
  802317:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	be 00 00 00 00       	mov    $0x0,%esi
  802321:	3b 75 10             	cmp    0x10(%ebp),%esi
  802324:	75 14                	jne    80233a <devpipe_read+0x35>
	return i;
  802326:	8b 45 10             	mov    0x10(%ebp),%eax
  802329:	eb 02                	jmp    80232d <devpipe_read+0x28>
				return i;
  80232b:	89 f0                	mov    %esi,%eax
}
  80232d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
			sys_yield();
  802335:	e8 fe e9 ff ff       	call   800d38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80233a:	8b 03                	mov    (%ebx),%eax
  80233c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80233f:	75 18                	jne    802359 <devpipe_read+0x54>
			if (i > 0)
  802341:	85 f6                	test   %esi,%esi
  802343:	75 e6                	jne    80232b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802345:	89 da                	mov    %ebx,%edx
  802347:	89 f8                	mov    %edi,%eax
  802349:	e8 d0 fe ff ff       	call   80221e <_pipeisclosed>
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 e3                	je     802335 <devpipe_read+0x30>
				return 0;
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	eb d4                	jmp    80232d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802359:	99                   	cltd   
  80235a:	c1 ea 1b             	shr    $0x1b,%edx
  80235d:	01 d0                	add    %edx,%eax
  80235f:	83 e0 1f             	and    $0x1f,%eax
  802362:	29 d0                	sub    %edx,%eax
  802364:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80236c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80236f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802372:	83 c6 01             	add    $0x1,%esi
  802375:	eb aa                	jmp    802321 <devpipe_read+0x1c>

00802377 <pipe>:
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	56                   	push   %esi
  80237b:	53                   	push   %ebx
  80237c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80237f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802382:	50                   	push   %eax
  802383:	e8 b2 f1 ff ff       	call   80153a <fd_alloc>
  802388:	89 c3                	mov    %eax,%ebx
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	85 c0                	test   %eax,%eax
  80238f:	0f 88 23 01 00 00    	js     8024b8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 07 04 00 00       	push   $0x407
  80239d:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a0:	6a 00                	push   $0x0
  8023a2:	e8 b0 e9 ff ff       	call   800d57 <sys_page_alloc>
  8023a7:	89 c3                	mov    %eax,%ebx
  8023a9:	83 c4 10             	add    $0x10,%esp
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	0f 88 04 01 00 00    	js     8024b8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023b4:	83 ec 0c             	sub    $0xc,%esp
  8023b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ba:	50                   	push   %eax
  8023bb:	e8 7a f1 ff ff       	call   80153a <fd_alloc>
  8023c0:	89 c3                	mov    %eax,%ebx
  8023c2:	83 c4 10             	add    $0x10,%esp
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	0f 88 db 00 00 00    	js     8024a8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	68 07 04 00 00       	push   $0x407
  8023d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d8:	6a 00                	push   $0x0
  8023da:	e8 78 e9 ff ff       	call   800d57 <sys_page_alloc>
  8023df:	89 c3                	mov    %eax,%ebx
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	0f 88 bc 00 00 00    	js     8024a8 <pipe+0x131>
	va = fd2data(fd0);
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f2:	e8 2c f1 ff ff       	call   801523 <fd2data>
  8023f7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f9:	83 c4 0c             	add    $0xc,%esp
  8023fc:	68 07 04 00 00       	push   $0x407
  802401:	50                   	push   %eax
  802402:	6a 00                	push   $0x0
  802404:	e8 4e e9 ff ff       	call   800d57 <sys_page_alloc>
  802409:	89 c3                	mov    %eax,%ebx
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	85 c0                	test   %eax,%eax
  802410:	0f 88 82 00 00 00    	js     802498 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802416:	83 ec 0c             	sub    $0xc,%esp
  802419:	ff 75 f0             	pushl  -0x10(%ebp)
  80241c:	e8 02 f1 ff ff       	call   801523 <fd2data>
  802421:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802428:	50                   	push   %eax
  802429:	6a 00                	push   $0x0
  80242b:	56                   	push   %esi
  80242c:	6a 00                	push   $0x0
  80242e:	e8 67 e9 ff ff       	call   800d9a <sys_page_map>
  802433:	89 c3                	mov    %eax,%ebx
  802435:	83 c4 20             	add    $0x20,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 4e                	js     80248a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80243c:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802449:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802450:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802453:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80245f:	83 ec 0c             	sub    $0xc,%esp
  802462:	ff 75 f4             	pushl  -0xc(%ebp)
  802465:	e8 a9 f0 ff ff       	call   801513 <fd2num>
  80246a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80246f:	83 c4 04             	add    $0x4,%esp
  802472:	ff 75 f0             	pushl  -0x10(%ebp)
  802475:	e8 99 f0 ff ff       	call   801513 <fd2num>
  80247a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	bb 00 00 00 00       	mov    $0x0,%ebx
  802488:	eb 2e                	jmp    8024b8 <pipe+0x141>
	sys_page_unmap(0, va);
  80248a:	83 ec 08             	sub    $0x8,%esp
  80248d:	56                   	push   %esi
  80248e:	6a 00                	push   $0x0
  802490:	e8 47 e9 ff ff       	call   800ddc <sys_page_unmap>
  802495:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802498:	83 ec 08             	sub    $0x8,%esp
  80249b:	ff 75 f0             	pushl  -0x10(%ebp)
  80249e:	6a 00                	push   $0x0
  8024a0:	e8 37 e9 ff ff       	call   800ddc <sys_page_unmap>
  8024a5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024a8:	83 ec 08             	sub    $0x8,%esp
  8024ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ae:	6a 00                	push   $0x0
  8024b0:	e8 27 e9 ff ff       	call   800ddc <sys_page_unmap>
  8024b5:	83 c4 10             	add    $0x10,%esp
}
  8024b8:	89 d8                	mov    %ebx,%eax
  8024ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    

008024c1 <pipeisclosed>:
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ca:	50                   	push   %eax
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	e8 b9 f0 ff ff       	call   80158c <fd_lookup>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 18                	js     8024f2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024da:	83 ec 0c             	sub    $0xc,%esp
  8024dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e0:	e8 3e f0 ff ff       	call   801523 <fd2data>
	return _pipeisclosed(fd, p);
  8024e5:	89 c2                	mov    %eax,%edx
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	e8 2f fd ff ff       	call   80221e <_pipeisclosed>
  8024ef:	83 c4 10             	add    $0x10,%esp
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	c3                   	ret    

008024fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802500:	68 7b 31 80 00       	push   $0x80317b
  802505:	ff 75 0c             	pushl  0xc(%ebp)
  802508:	e8 58 e4 ff ff       	call   800965 <strcpy>
	return 0;
}
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <devcons_write>:
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	57                   	push   %edi
  802518:	56                   	push   %esi
  802519:	53                   	push   %ebx
  80251a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802520:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802525:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80252b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80252e:	73 31                	jae    802561 <devcons_write+0x4d>
		m = n - tot;
  802530:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802533:	29 f3                	sub    %esi,%ebx
  802535:	83 fb 7f             	cmp    $0x7f,%ebx
  802538:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80253d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802540:	83 ec 04             	sub    $0x4,%esp
  802543:	53                   	push   %ebx
  802544:	89 f0                	mov    %esi,%eax
  802546:	03 45 0c             	add    0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	57                   	push   %edi
  80254b:	e8 a3 e5 ff ff       	call   800af3 <memmove>
		sys_cputs(buf, m);
  802550:	83 c4 08             	add    $0x8,%esp
  802553:	53                   	push   %ebx
  802554:	57                   	push   %edi
  802555:	e8 41 e7 ff ff       	call   800c9b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80255a:	01 de                	add    %ebx,%esi
  80255c:	83 c4 10             	add    $0x10,%esp
  80255f:	eb ca                	jmp    80252b <devcons_write+0x17>
}
  802561:	89 f0                	mov    %esi,%eax
  802563:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802566:	5b                   	pop    %ebx
  802567:	5e                   	pop    %esi
  802568:	5f                   	pop    %edi
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    

0080256b <devcons_read>:
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 08             	sub    $0x8,%esp
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802576:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80257a:	74 21                	je     80259d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80257c:	e8 38 e7 ff ff       	call   800cb9 <sys_cgetc>
  802581:	85 c0                	test   %eax,%eax
  802583:	75 07                	jne    80258c <devcons_read+0x21>
		sys_yield();
  802585:	e8 ae e7 ff ff       	call   800d38 <sys_yield>
  80258a:	eb f0                	jmp    80257c <devcons_read+0x11>
	if (c < 0)
  80258c:	78 0f                	js     80259d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80258e:	83 f8 04             	cmp    $0x4,%eax
  802591:	74 0c                	je     80259f <devcons_read+0x34>
	*(char*)vbuf = c;
  802593:	8b 55 0c             	mov    0xc(%ebp),%edx
  802596:	88 02                	mov    %al,(%edx)
	return 1;
  802598:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    
		return 0;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	eb f7                	jmp    80259d <devcons_read+0x32>

008025a6 <cputchar>:
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025b2:	6a 01                	push   $0x1
  8025b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b7:	50                   	push   %eax
  8025b8:	e8 de e6 ff ff       	call   800c9b <sys_cputs>
}
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <getchar>:
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025c8:	6a 01                	push   $0x1
  8025ca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025cd:	50                   	push   %eax
  8025ce:	6a 00                	push   $0x0
  8025d0:	e8 27 f2 ff ff       	call   8017fc <read>
	if (r < 0)
  8025d5:	83 c4 10             	add    $0x10,%esp
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	78 06                	js     8025e2 <getchar+0x20>
	if (r < 1)
  8025dc:	74 06                	je     8025e4 <getchar+0x22>
	return c;
  8025de:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    
		return -E_EOF;
  8025e4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025e9:	eb f7                	jmp    8025e2 <getchar+0x20>

008025eb <iscons>:
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025f4:	50                   	push   %eax
  8025f5:	ff 75 08             	pushl  0x8(%ebp)
  8025f8:	e8 8f ef ff ff       	call   80158c <fd_lookup>
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	85 c0                	test   %eax,%eax
  802602:	78 11                	js     802615 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80260d:	39 10                	cmp    %edx,(%eax)
  80260f:	0f 94 c0             	sete   %al
  802612:	0f b6 c0             	movzbl %al,%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <opencons>:
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80261d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802620:	50                   	push   %eax
  802621:	e8 14 ef ff ff       	call   80153a <fd_alloc>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 3a                	js     802667 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 07 04 00 00       	push   $0x407
  802635:	ff 75 f4             	pushl  -0xc(%ebp)
  802638:	6a 00                	push   $0x0
  80263a:	e8 18 e7 ff ff       	call   800d57 <sys_page_alloc>
  80263f:	83 c4 10             	add    $0x10,%esp
  802642:	85 c0                	test   %eax,%eax
  802644:	78 21                	js     802667 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80264f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	50                   	push   %eax
  80265f:	e8 af ee ff ff       	call   801513 <fd2num>
  802664:	83 c4 10             	add    $0x10,%esp
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	56                   	push   %esi
  80266d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80266e:	a1 08 50 80 00       	mov    0x805008,%eax
  802673:	8b 40 48             	mov    0x48(%eax),%eax
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	68 b8 31 80 00       	push   $0x8031b8
  80267e:	50                   	push   %eax
  80267f:	68 87 31 80 00       	push   $0x803187
  802684:	e8 7d db ff ff       	call   800206 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802689:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80268c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802692:	e8 82 e6 ff ff       	call   800d19 <sys_getenvid>
  802697:	83 c4 04             	add    $0x4,%esp
  80269a:	ff 75 0c             	pushl  0xc(%ebp)
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	56                   	push   %esi
  8026a1:	50                   	push   %eax
  8026a2:	68 94 31 80 00       	push   $0x803194
  8026a7:	e8 5a db ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026ac:	83 c4 18             	add    $0x18,%esp
  8026af:	53                   	push   %ebx
  8026b0:	ff 75 10             	pushl  0x10(%ebp)
  8026b3:	e8 fd da ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  8026b8:	c7 04 24 ae 2b 80 00 	movl   $0x802bae,(%esp)
  8026bf:	e8 42 db ff ff       	call   800206 <cprintf>
  8026c4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026c7:	cc                   	int3   
  8026c8:	eb fd                	jmp    8026c7 <_panic+0x5e>

008026ca <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026d0:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026d7:	74 0a                	je     8026e3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	6a 07                	push   $0x7
  8026e8:	68 00 f0 bf ee       	push   $0xeebff000
  8026ed:	6a 00                	push   $0x0
  8026ef:	e8 63 e6 ff ff       	call   800d57 <sys_page_alloc>
		if(r < 0)
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	78 2a                	js     802725 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8026fb:	83 ec 08             	sub    $0x8,%esp
  8026fe:	68 39 27 80 00       	push   $0x802739
  802703:	6a 00                	push   $0x0
  802705:	e8 98 e7 ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	85 c0                	test   %eax,%eax
  80270f:	79 c8                	jns    8026d9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	68 f0 31 80 00       	push   $0x8031f0
  802719:	6a 25                	push   $0x25
  80271b:	68 2c 32 80 00       	push   $0x80322c
  802720:	e8 44 ff ff ff       	call   802669 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	68 c0 31 80 00       	push   $0x8031c0
  80272d:	6a 22                	push   $0x22
  80272f:	68 2c 32 80 00       	push   $0x80322c
  802734:	e8 30 ff ff ff       	call   802669 <_panic>

00802739 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802739:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80273a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80273f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802741:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802744:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802748:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80274c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80274f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802751:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802755:	83 c4 08             	add    $0x8,%esp
	popal
  802758:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802759:	83 c4 04             	add    $0x4,%esp
	popfl
  80275c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80275d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80275e:	c3                   	ret    

0080275f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	8b 75 08             	mov    0x8(%ebp),%esi
  802767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80276d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80276f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802774:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	50                   	push   %eax
  80277b:	e8 87 e7 ff ff       	call   800f07 <sys_ipc_recv>
	if(ret < 0){
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	85 c0                	test   %eax,%eax
  802785:	78 2b                	js     8027b2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802787:	85 f6                	test   %esi,%esi
  802789:	74 0a                	je     802795 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80278b:	a1 08 50 80 00       	mov    0x805008,%eax
  802790:	8b 40 74             	mov    0x74(%eax),%eax
  802793:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802795:	85 db                	test   %ebx,%ebx
  802797:	74 0a                	je     8027a3 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802799:	a1 08 50 80 00       	mov    0x805008,%eax
  80279e:	8b 40 78             	mov    0x78(%eax),%eax
  8027a1:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027a3:	a1 08 50 80 00       	mov    0x805008,%eax
  8027a8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ae:	5b                   	pop    %ebx
  8027af:	5e                   	pop    %esi
  8027b0:	5d                   	pop    %ebp
  8027b1:	c3                   	ret    
		if(from_env_store)
  8027b2:	85 f6                	test   %esi,%esi
  8027b4:	74 06                	je     8027bc <ipc_recv+0x5d>
			*from_env_store = 0;
  8027b6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027bc:	85 db                	test   %ebx,%ebx
  8027be:	74 eb                	je     8027ab <ipc_recv+0x4c>
			*perm_store = 0;
  8027c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027c6:	eb e3                	jmp    8027ab <ipc_recv+0x4c>

008027c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
  8027cb:	57                   	push   %edi
  8027cc:	56                   	push   %esi
  8027cd:	53                   	push   %ebx
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8027da:	85 db                	test   %ebx,%ebx
  8027dc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027e1:	0f 44 d8             	cmove  %eax,%ebx
  8027e4:	eb 05                	jmp    8027eb <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8027e6:	e8 4d e5 ff ff       	call   800d38 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8027eb:	ff 75 14             	pushl  0x14(%ebp)
  8027ee:	53                   	push   %ebx
  8027ef:	56                   	push   %esi
  8027f0:	57                   	push   %edi
  8027f1:	e8 ee e6 ff ff       	call   800ee4 <sys_ipc_try_send>
  8027f6:	83 c4 10             	add    $0x10,%esp
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	74 1b                	je     802818 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8027fd:	79 e7                	jns    8027e6 <ipc_send+0x1e>
  8027ff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802802:	74 e2                	je     8027e6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 3a 32 80 00       	push   $0x80323a
  80280c:	6a 48                	push   $0x48
  80280e:	68 4f 32 80 00       	push   $0x80324f
  802813:	e8 51 fe ff ff       	call   802669 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802818:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80281b:	5b                   	pop    %ebx
  80281c:	5e                   	pop    %esi
  80281d:	5f                   	pop    %edi
  80281e:	5d                   	pop    %ebp
  80281f:	c3                   	ret    

00802820 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80282b:	89 c2                	mov    %eax,%edx
  80282d:	c1 e2 07             	shl    $0x7,%edx
  802830:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802836:	8b 52 50             	mov    0x50(%edx),%edx
  802839:	39 ca                	cmp    %ecx,%edx
  80283b:	74 11                	je     80284e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80283d:	83 c0 01             	add    $0x1,%eax
  802840:	3d 00 04 00 00       	cmp    $0x400,%eax
  802845:	75 e4                	jne    80282b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802847:	b8 00 00 00 00       	mov    $0x0,%eax
  80284c:	eb 0b                	jmp    802859 <ipc_find_env+0x39>
			return envs[i].env_id;
  80284e:	c1 e0 07             	shl    $0x7,%eax
  802851:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802856:	8b 40 48             	mov    0x48(%eax),%eax
}
  802859:	5d                   	pop    %ebp
  80285a:	c3                   	ret    

0080285b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802861:	89 d0                	mov    %edx,%eax
  802863:	c1 e8 16             	shr    $0x16,%eax
  802866:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802872:	f6 c1 01             	test   $0x1,%cl
  802875:	74 1d                	je     802894 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802877:	c1 ea 0c             	shr    $0xc,%edx
  80287a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802881:	f6 c2 01             	test   $0x1,%dl
  802884:	74 0e                	je     802894 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802886:	c1 ea 0c             	shr    $0xc,%edx
  802889:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802890:	ef 
  802891:	0f b7 c0             	movzwl %ax,%eax
}
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	66 90                	xchg   %ax,%ax
  802898:	66 90                	xchg   %ax,%ax
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__udivdi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 1c             	sub    $0x1c,%esp
  8028a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028b7:	85 d2                	test   %edx,%edx
  8028b9:	75 4d                	jne    802908 <__udivdi3+0x68>
  8028bb:	39 f3                	cmp    %esi,%ebx
  8028bd:	76 19                	jbe    8028d8 <__udivdi3+0x38>
  8028bf:	31 ff                	xor    %edi,%edi
  8028c1:	89 e8                	mov    %ebp,%eax
  8028c3:	89 f2                	mov    %esi,%edx
  8028c5:	f7 f3                	div    %ebx
  8028c7:	89 fa                	mov    %edi,%edx
  8028c9:	83 c4 1c             	add    $0x1c,%esp
  8028cc:	5b                   	pop    %ebx
  8028cd:	5e                   	pop    %esi
  8028ce:	5f                   	pop    %edi
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 d9                	mov    %ebx,%ecx
  8028da:	85 db                	test   %ebx,%ebx
  8028dc:	75 0b                	jne    8028e9 <__udivdi3+0x49>
  8028de:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f3                	div    %ebx
  8028e7:	89 c1                	mov    %eax,%ecx
  8028e9:	31 d2                	xor    %edx,%edx
  8028eb:	89 f0                	mov    %esi,%eax
  8028ed:	f7 f1                	div    %ecx
  8028ef:	89 c6                	mov    %eax,%esi
  8028f1:	89 e8                	mov    %ebp,%eax
  8028f3:	89 f7                	mov    %esi,%edi
  8028f5:	f7 f1                	div    %ecx
  8028f7:	89 fa                	mov    %edi,%edx
  8028f9:	83 c4 1c             	add    $0x1c,%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5f                   	pop    %edi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
  802901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802908:	39 f2                	cmp    %esi,%edx
  80290a:	77 1c                	ja     802928 <__udivdi3+0x88>
  80290c:	0f bd fa             	bsr    %edx,%edi
  80290f:	83 f7 1f             	xor    $0x1f,%edi
  802912:	75 2c                	jne    802940 <__udivdi3+0xa0>
  802914:	39 f2                	cmp    %esi,%edx
  802916:	72 06                	jb     80291e <__udivdi3+0x7e>
  802918:	31 c0                	xor    %eax,%eax
  80291a:	39 eb                	cmp    %ebp,%ebx
  80291c:	77 a9                	ja     8028c7 <__udivdi3+0x27>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	eb a2                	jmp    8028c7 <__udivdi3+0x27>
  802925:	8d 76 00             	lea    0x0(%esi),%esi
  802928:	31 ff                	xor    %edi,%edi
  80292a:	31 c0                	xor    %eax,%eax
  80292c:	89 fa                	mov    %edi,%edx
  80292e:	83 c4 1c             	add    $0x1c,%esp
  802931:	5b                   	pop    %ebx
  802932:	5e                   	pop    %esi
  802933:	5f                   	pop    %edi
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    
  802936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80293d:	8d 76 00             	lea    0x0(%esi),%esi
  802940:	89 f9                	mov    %edi,%ecx
  802942:	b8 20 00 00 00       	mov    $0x20,%eax
  802947:	29 f8                	sub    %edi,%eax
  802949:	d3 e2                	shl    %cl,%edx
  80294b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80294f:	89 c1                	mov    %eax,%ecx
  802951:	89 da                	mov    %ebx,%edx
  802953:	d3 ea                	shr    %cl,%edx
  802955:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802959:	09 d1                	or     %edx,%ecx
  80295b:	89 f2                	mov    %esi,%edx
  80295d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802961:	89 f9                	mov    %edi,%ecx
  802963:	d3 e3                	shl    %cl,%ebx
  802965:	89 c1                	mov    %eax,%ecx
  802967:	d3 ea                	shr    %cl,%edx
  802969:	89 f9                	mov    %edi,%ecx
  80296b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80296f:	89 eb                	mov    %ebp,%ebx
  802971:	d3 e6                	shl    %cl,%esi
  802973:	89 c1                	mov    %eax,%ecx
  802975:	d3 eb                	shr    %cl,%ebx
  802977:	09 de                	or     %ebx,%esi
  802979:	89 f0                	mov    %esi,%eax
  80297b:	f7 74 24 08          	divl   0x8(%esp)
  80297f:	89 d6                	mov    %edx,%esi
  802981:	89 c3                	mov    %eax,%ebx
  802983:	f7 64 24 0c          	mull   0xc(%esp)
  802987:	39 d6                	cmp    %edx,%esi
  802989:	72 15                	jb     8029a0 <__udivdi3+0x100>
  80298b:	89 f9                	mov    %edi,%ecx
  80298d:	d3 e5                	shl    %cl,%ebp
  80298f:	39 c5                	cmp    %eax,%ebp
  802991:	73 04                	jae    802997 <__udivdi3+0xf7>
  802993:	39 d6                	cmp    %edx,%esi
  802995:	74 09                	je     8029a0 <__udivdi3+0x100>
  802997:	89 d8                	mov    %ebx,%eax
  802999:	31 ff                	xor    %edi,%edi
  80299b:	e9 27 ff ff ff       	jmp    8028c7 <__udivdi3+0x27>
  8029a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029a3:	31 ff                	xor    %edi,%edi
  8029a5:	e9 1d ff ff ff       	jmp    8028c7 <__udivdi3+0x27>
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__umoddi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 1c             	sub    $0x1c,%esp
  8029b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029c7:	89 da                	mov    %ebx,%edx
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	75 43                	jne    802a10 <__umoddi3+0x60>
  8029cd:	39 df                	cmp    %ebx,%edi
  8029cf:	76 17                	jbe    8029e8 <__umoddi3+0x38>
  8029d1:	89 f0                	mov    %esi,%eax
  8029d3:	f7 f7                	div    %edi
  8029d5:	89 d0                	mov    %edx,%eax
  8029d7:	31 d2                	xor    %edx,%edx
  8029d9:	83 c4 1c             	add    $0x1c,%esp
  8029dc:	5b                   	pop    %ebx
  8029dd:	5e                   	pop    %esi
  8029de:	5f                   	pop    %edi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 fd                	mov    %edi,%ebp
  8029ea:	85 ff                	test   %edi,%edi
  8029ec:	75 0b                	jne    8029f9 <__umoddi3+0x49>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f7                	div    %edi
  8029f7:	89 c5                	mov    %eax,%ebp
  8029f9:	89 d8                	mov    %ebx,%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	f7 f5                	div    %ebp
  8029ff:	89 f0                	mov    %esi,%eax
  802a01:	f7 f5                	div    %ebp
  802a03:	89 d0                	mov    %edx,%eax
  802a05:	eb d0                	jmp    8029d7 <__umoddi3+0x27>
  802a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0e:	66 90                	xchg   %ax,%ax
  802a10:	89 f1                	mov    %esi,%ecx
  802a12:	39 d8                	cmp    %ebx,%eax
  802a14:	76 0a                	jbe    802a20 <__umoddi3+0x70>
  802a16:	89 f0                	mov    %esi,%eax
  802a18:	83 c4 1c             	add    $0x1c,%esp
  802a1b:	5b                   	pop    %ebx
  802a1c:	5e                   	pop    %esi
  802a1d:	5f                   	pop    %edi
  802a1e:	5d                   	pop    %ebp
  802a1f:	c3                   	ret    
  802a20:	0f bd e8             	bsr    %eax,%ebp
  802a23:	83 f5 1f             	xor    $0x1f,%ebp
  802a26:	75 20                	jne    802a48 <__umoddi3+0x98>
  802a28:	39 d8                	cmp    %ebx,%eax
  802a2a:	0f 82 b0 00 00 00    	jb     802ae0 <__umoddi3+0x130>
  802a30:	39 f7                	cmp    %esi,%edi
  802a32:	0f 86 a8 00 00 00    	jbe    802ae0 <__umoddi3+0x130>
  802a38:	89 c8                	mov    %ecx,%eax
  802a3a:	83 c4 1c             	add    $0x1c,%esp
  802a3d:	5b                   	pop    %ebx
  802a3e:	5e                   	pop    %esi
  802a3f:	5f                   	pop    %edi
  802a40:	5d                   	pop    %ebp
  802a41:	c3                   	ret    
  802a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a4f:	29 ea                	sub    %ebp,%edx
  802a51:	d3 e0                	shl    %cl,%eax
  802a53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a57:	89 d1                	mov    %edx,%ecx
  802a59:	89 f8                	mov    %edi,%eax
  802a5b:	d3 e8                	shr    %cl,%eax
  802a5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a69:	09 c1                	or     %eax,%ecx
  802a6b:	89 d8                	mov    %ebx,%eax
  802a6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a71:	89 e9                	mov    %ebp,%ecx
  802a73:	d3 e7                	shl    %cl,%edi
  802a75:	89 d1                	mov    %edx,%ecx
  802a77:	d3 e8                	shr    %cl,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a7f:	d3 e3                	shl    %cl,%ebx
  802a81:	89 c7                	mov    %eax,%edi
  802a83:	89 d1                	mov    %edx,%ecx
  802a85:	89 f0                	mov    %esi,%eax
  802a87:	d3 e8                	shr    %cl,%eax
  802a89:	89 e9                	mov    %ebp,%ecx
  802a8b:	89 fa                	mov    %edi,%edx
  802a8d:	d3 e6                	shl    %cl,%esi
  802a8f:	09 d8                	or     %ebx,%eax
  802a91:	f7 74 24 08          	divl   0x8(%esp)
  802a95:	89 d1                	mov    %edx,%ecx
  802a97:	89 f3                	mov    %esi,%ebx
  802a99:	f7 64 24 0c          	mull   0xc(%esp)
  802a9d:	89 c6                	mov    %eax,%esi
  802a9f:	89 d7                	mov    %edx,%edi
  802aa1:	39 d1                	cmp    %edx,%ecx
  802aa3:	72 06                	jb     802aab <__umoddi3+0xfb>
  802aa5:	75 10                	jne    802ab7 <__umoddi3+0x107>
  802aa7:	39 c3                	cmp    %eax,%ebx
  802aa9:	73 0c                	jae    802ab7 <__umoddi3+0x107>
  802aab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aaf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ab3:	89 d7                	mov    %edx,%edi
  802ab5:	89 c6                	mov    %eax,%esi
  802ab7:	89 ca                	mov    %ecx,%edx
  802ab9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802abe:	29 f3                	sub    %esi,%ebx
  802ac0:	19 fa                	sbb    %edi,%edx
  802ac2:	89 d0                	mov    %edx,%eax
  802ac4:	d3 e0                	shl    %cl,%eax
  802ac6:	89 e9                	mov    %ebp,%ecx
  802ac8:	d3 eb                	shr    %cl,%ebx
  802aca:	d3 ea                	shr    %cl,%edx
  802acc:	09 d8                	or     %ebx,%eax
  802ace:	83 c4 1c             	add    $0x1c,%esp
  802ad1:	5b                   	pop    %ebx
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802add:	8d 76 00             	lea    0x0(%esi),%esi
  802ae0:	89 da                	mov    %ebx,%edx
  802ae2:	29 fe                	sub    %edi,%esi
  802ae4:	19 c2                	sbb    %eax,%edx
  802ae6:	89 f1                	mov    %esi,%ecx
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	e9 4b ff ff ff       	jmp    802a3a <__umoddi3+0x8a>
