
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
  800044:	e8 4c 12 00 00       	call   801295 <fork>
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

	cprintf("call umain!\n");
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
  80015d:	e8 9d 15 00 00       	call   8016ff <close_all>
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
  8002b3:	e8 f8 25 00 00       	call   8028b0 <__udivdi3>
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
  8002dc:	e8 df 26 00 00       	call   8029c0 <__umoddi3>
  8002e1:	83 c4 14             	add    $0x14,%esp
  8002e4:	0f be 80 ad 2b 80 00 	movsbl 0x802bad(%eax),%eax
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
  80038d:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
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
  800458:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  80045f:	85 d2                	test   %edx,%edx
  800461:	74 18                	je     80047b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800463:	52                   	push   %edx
  800464:	68 f1 30 80 00       	push   $0x8030f1
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 a6 fe ff ff       	call   800316 <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
  800476:	e9 fe 02 00 00       	jmp    800779 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80047b:	50                   	push   %eax
  80047c:	68 c5 2b 80 00       	push   $0x802bc5
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
  8004a3:	b8 be 2b 80 00       	mov    $0x802bbe,%eax
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
  80083b:	bf e1 2c 80 00       	mov    $0x802ce1,%edi
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
  800867:	bf 19 2d 80 00       	mov    $0x802d19,%edi
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
  800d08:	68 24 2f 80 00       	push   $0x802f24
  800d0d:	6a 43                	push   $0x43
  800d0f:	68 41 2f 80 00       	push   $0x802f41
  800d14:	e8 64 19 00 00       	call   80267d <_panic>

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
  800d89:	68 24 2f 80 00       	push   $0x802f24
  800d8e:	6a 43                	push   $0x43
  800d90:	68 41 2f 80 00       	push   $0x802f41
  800d95:	e8 e3 18 00 00       	call   80267d <_panic>

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
  800dcb:	68 24 2f 80 00       	push   $0x802f24
  800dd0:	6a 43                	push   $0x43
  800dd2:	68 41 2f 80 00       	push   $0x802f41
  800dd7:	e8 a1 18 00 00       	call   80267d <_panic>

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
  800e0d:	68 24 2f 80 00       	push   $0x802f24
  800e12:	6a 43                	push   $0x43
  800e14:	68 41 2f 80 00       	push   $0x802f41
  800e19:	e8 5f 18 00 00       	call   80267d <_panic>

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
  800e4f:	68 24 2f 80 00       	push   $0x802f24
  800e54:	6a 43                	push   $0x43
  800e56:	68 41 2f 80 00       	push   $0x802f41
  800e5b:	e8 1d 18 00 00       	call   80267d <_panic>

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
  800e91:	68 24 2f 80 00       	push   $0x802f24
  800e96:	6a 43                	push   $0x43
  800e98:	68 41 2f 80 00       	push   $0x802f41
  800e9d:	e8 db 17 00 00       	call   80267d <_panic>

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
  800ed3:	68 24 2f 80 00       	push   $0x802f24
  800ed8:	6a 43                	push   $0x43
  800eda:	68 41 2f 80 00       	push   $0x802f41
  800edf:	e8 99 17 00 00       	call   80267d <_panic>

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
  800f37:	68 24 2f 80 00       	push   $0x802f24
  800f3c:	6a 43                	push   $0x43
  800f3e:	68 41 2f 80 00       	push   $0x802f41
  800f43:	e8 35 17 00 00       	call   80267d <_panic>

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
  80101b:	68 24 2f 80 00       	push   $0x802f24
  801020:	6a 43                	push   $0x43
  801022:	68 41 2f 80 00       	push   $0x802f41
  801027:	e8 51 16 00 00       	call   80267d <_panic>

0080102c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	53                   	push   %ebx
  801030:	83 ec 04             	sub    $0x4,%esp
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801036:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801038:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80103c:	0f 84 99 00 00 00    	je     8010db <pgfault+0xaf>
  801042:	89 c2                	mov    %eax,%edx
  801044:	c1 ea 16             	shr    $0x16,%edx
  801047:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	0f 84 84 00 00 00    	je     8010db <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801057:	89 c2                	mov    %eax,%edx
  801059:	c1 ea 0c             	shr    $0xc,%edx
  80105c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801063:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801069:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80106f:	75 6a                	jne    8010db <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801071:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801076:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	6a 07                	push   $0x7
  80107d:	68 00 f0 7f 00       	push   $0x7ff000
  801082:	6a 00                	push   $0x0
  801084:	e8 ce fc ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	85 c0                	test   %eax,%eax
  80108e:	78 5f                	js     8010ef <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	68 00 10 00 00       	push   $0x1000
  801098:	53                   	push   %ebx
  801099:	68 00 f0 7f 00       	push   $0x7ff000
  80109e:	e8 b2 fa ff ff       	call   800b55 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8010a3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010aa:	53                   	push   %ebx
  8010ab:	6a 00                	push   $0x0
  8010ad:	68 00 f0 7f 00       	push   $0x7ff000
  8010b2:	6a 00                	push   $0x0
  8010b4:	e8 e1 fc ff ff       	call   800d9a <sys_page_map>
	if(ret < 0)
  8010b9:	83 c4 20             	add    $0x20,%esp
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 43                	js     801103 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8010c0:	83 ec 08             	sub    $0x8,%esp
  8010c3:	68 00 f0 7f 00       	push   $0x7ff000
  8010c8:	6a 00                	push   $0x0
  8010ca:	e8 0d fd ff ff       	call   800ddc <sys_page_unmap>
	if(ret < 0)
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	78 41                	js     801117 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  8010d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    
		panic("panic at pgfault()\n");
  8010db:	83 ec 04             	sub    $0x4,%esp
  8010de:	68 4f 2f 80 00       	push   $0x802f4f
  8010e3:	6a 26                	push   $0x26
  8010e5:	68 63 2f 80 00       	push   $0x802f63
  8010ea:	e8 8e 15 00 00       	call   80267d <_panic>
		panic("panic in sys_page_alloc()\n");
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	68 6e 2f 80 00       	push   $0x802f6e
  8010f7:	6a 31                	push   $0x31
  8010f9:	68 63 2f 80 00       	push   $0x802f63
  8010fe:	e8 7a 15 00 00       	call   80267d <_panic>
		panic("panic in sys_page_map()\n");
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	68 89 2f 80 00       	push   $0x802f89
  80110b:	6a 36                	push   $0x36
  80110d:	68 63 2f 80 00       	push   $0x802f63
  801112:	e8 66 15 00 00       	call   80267d <_panic>
		panic("panic in sys_page_unmap()\n");
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	68 a2 2f 80 00       	push   $0x802fa2
  80111f:	6a 39                	push   $0x39
  801121:	68 63 2f 80 00       	push   $0x802f63
  801126:	e8 52 15 00 00       	call   80267d <_panic>

0080112b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	89 c6                	mov    %eax,%esi
  801132:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	68 40 30 80 00       	push   $0x803040
  80113c:	68 73 31 80 00       	push   $0x803173
  801141:	e8 c0 f0 ff ff       	call   800206 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801146:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	f6 c4 04             	test   $0x4,%ah
  801153:	75 45                	jne    80119a <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801155:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80115c:	83 e0 07             	and    $0x7,%eax
  80115f:	83 f8 07             	cmp    $0x7,%eax
  801162:	74 6e                	je     8011d2 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801164:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80116b:	25 05 08 00 00       	and    $0x805,%eax
  801170:	3d 05 08 00 00       	cmp    $0x805,%eax
  801175:	0f 84 b5 00 00 00    	je     801230 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80117b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801182:	83 e0 05             	and    $0x5,%eax
  801185:	83 f8 05             	cmp    $0x5,%eax
  801188:	0f 84 d6 00 00 00    	je     801264 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80119a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011a1:	c1 e3 0c             	shl    $0xc,%ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ac:	50                   	push   %eax
  8011ad:	53                   	push   %ebx
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 e3 fb ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  8011b7:	83 c4 20             	add    $0x20,%esp
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	79 d0                	jns    80118e <duppage+0x63>
			panic("sys_page_map() panic\n");
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	68 bd 2f 80 00       	push   $0x802fbd
  8011c6:	6a 55                	push   $0x55
  8011c8:	68 63 2f 80 00       	push   $0x802f63
  8011cd:	e8 ab 14 00 00       	call   80267d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011d2:	c1 e3 0c             	shl    $0xc,%ebx
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	68 05 08 00 00       	push   $0x805
  8011dd:	53                   	push   %ebx
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	6a 00                	push   $0x0
  8011e2:	e8 b3 fb ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 2e                	js     80121c <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	68 05 08 00 00       	push   $0x805
  8011f6:	53                   	push   %ebx
  8011f7:	6a 00                	push   $0x0
  8011f9:	53                   	push   %ebx
  8011fa:	6a 00                	push   $0x0
  8011fc:	e8 99 fb ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  801201:	83 c4 20             	add    $0x20,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	79 86                	jns    80118e <duppage+0x63>
			panic("sys_page_map() panic\n");
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	68 bd 2f 80 00       	push   $0x802fbd
  801210:	6a 60                	push   $0x60
  801212:	68 63 2f 80 00       	push   $0x802f63
  801217:	e8 61 14 00 00       	call   80267d <_panic>
			panic("sys_page_map() panic\n");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 bd 2f 80 00       	push   $0x802fbd
  801224:	6a 5c                	push   $0x5c
  801226:	68 63 2f 80 00       	push   $0x802f63
  80122b:	e8 4d 14 00 00       	call   80267d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801230:	c1 e3 0c             	shl    $0xc,%ebx
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	68 05 08 00 00       	push   $0x805
  80123b:	53                   	push   %ebx
  80123c:	56                   	push   %esi
  80123d:	53                   	push   %ebx
  80123e:	6a 00                	push   $0x0
  801240:	e8 55 fb ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 89 3e ff ff ff    	jns    80118e <duppage+0x63>
			panic("sys_page_map() panic\n");
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	68 bd 2f 80 00       	push   $0x802fbd
  801258:	6a 67                	push   $0x67
  80125a:	68 63 2f 80 00       	push   $0x802f63
  80125f:	e8 19 14 00 00       	call   80267d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801264:	c1 e3 0c             	shl    $0xc,%ebx
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	6a 05                	push   $0x5
  80126c:	53                   	push   %ebx
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
  80126f:	6a 00                	push   $0x0
  801271:	e8 24 fb ff ff       	call   800d9a <sys_page_map>
		if(r < 0)
  801276:	83 c4 20             	add    $0x20,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	0f 89 0d ff ff ff    	jns    80118e <duppage+0x63>
			panic("sys_page_map() panic\n");
  801281:	83 ec 04             	sub    $0x4,%esp
  801284:	68 bd 2f 80 00       	push   $0x802fbd
  801289:	6a 6e                	push   $0x6e
  80128b:	68 63 2f 80 00       	push   $0x802f63
  801290:	e8 e8 13 00 00       	call   80267d <_panic>

00801295 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	57                   	push   %edi
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
  80129b:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80129e:	68 2c 10 80 00       	push   $0x80102c
  8012a3:	e8 36 14 00 00       	call   8026de <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012a8:	b8 07 00 00 00       	mov    $0x7,%eax
  8012ad:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 27                	js     8012dd <fork+0x48>
  8012b6:	89 c6                	mov    %eax,%esi
  8012b8:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012ba:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012bf:	75 48                	jne    801309 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012c1:	e8 53 fa ff ff       	call   800d19 <sys_getenvid>
  8012c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012cb:	c1 e0 07             	shl    $0x7,%eax
  8012ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012d3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012d8:	e9 90 00 00 00       	jmp    80136d <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	68 d4 2f 80 00       	push   $0x802fd4
  8012e5:	68 8d 00 00 00       	push   $0x8d
  8012ea:	68 63 2f 80 00       	push   $0x802f63
  8012ef:	e8 89 13 00 00       	call   80267d <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012f4:	89 f8                	mov    %edi,%eax
  8012f6:	e8 30 fe ff ff       	call   80112b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801301:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801307:	74 26                	je     80132f <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801309:	89 d8                	mov    %ebx,%eax
  80130b:	c1 e8 16             	shr    $0x16,%eax
  80130e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801315:	a8 01                	test   $0x1,%al
  801317:	74 e2                	je     8012fb <fork+0x66>
  801319:	89 da                	mov    %ebx,%edx
  80131b:	c1 ea 0c             	shr    $0xc,%edx
  80131e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801325:	83 e0 05             	and    $0x5,%eax
  801328:	83 f8 05             	cmp    $0x5,%eax
  80132b:	75 ce                	jne    8012fb <fork+0x66>
  80132d:	eb c5                	jmp    8012f4 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	6a 07                	push   $0x7
  801334:	68 00 f0 bf ee       	push   $0xeebff000
  801339:	56                   	push   %esi
  80133a:	e8 18 fa ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  80133f:	83 c4 10             	add    $0x10,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	78 31                	js     801377 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	68 4d 27 80 00       	push   $0x80274d
  80134e:	56                   	push   %esi
  80134f:	e8 4e fb ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 33                	js     80138e <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	6a 02                	push   $0x2
  801360:	56                   	push   %esi
  801361:	e8 b8 fa ff ff       	call   800e1e <sys_env_set_status>
	if(ret < 0)
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 38                	js     8013a5 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80136d:	89 f0                	mov    %esi,%eax
  80136f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	68 6e 2f 80 00       	push   $0x802f6e
  80137f:	68 99 00 00 00       	push   $0x99
  801384:	68 63 2f 80 00       	push   $0x802f63
  801389:	e8 ef 12 00 00       	call   80267d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80138e:	83 ec 04             	sub    $0x4,%esp
  801391:	68 f8 2f 80 00       	push   $0x802ff8
  801396:	68 9c 00 00 00       	push   $0x9c
  80139b:	68 63 2f 80 00       	push   $0x802f63
  8013a0:	e8 d8 12 00 00       	call   80267d <_panic>
		panic("panic in sys_env_set_status()\n");
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	68 20 30 80 00       	push   $0x803020
  8013ad:	68 9f 00 00 00       	push   $0x9f
  8013b2:	68 63 2f 80 00       	push   $0x802f63
  8013b7:	e8 c1 12 00 00       	call   80267d <_panic>

008013bc <sfork>:

// Challenge!
int
sfork(void)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
  8013c2:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013c5:	68 2c 10 80 00       	push   $0x80102c
  8013ca:	e8 0f 13 00 00       	call   8026de <set_pgfault_handler>
  8013cf:	b8 07 00 00 00       	mov    $0x7,%eax
  8013d4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 27                	js     801404 <sfork+0x48>
  8013dd:	89 c7                	mov    %eax,%edi
  8013df:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013e1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013e6:	75 55                	jne    80143d <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013e8:	e8 2c f9 ff ff       	call   800d19 <sys_getenvid>
  8013ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013f2:	c1 e0 07             	shl    $0x7,%eax
  8013f5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013fa:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013ff:	e9 d4 00 00 00       	jmp    8014d8 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	68 d4 2f 80 00       	push   $0x802fd4
  80140c:	68 b0 00 00 00       	push   $0xb0
  801411:	68 63 2f 80 00       	push   $0x802f63
  801416:	e8 62 12 00 00       	call   80267d <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80141b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801420:	89 f0                	mov    %esi,%eax
  801422:	e8 04 fd ff ff       	call   80112b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80142d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801433:	77 65                	ja     80149a <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801435:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80143b:	74 de                	je     80141b <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80143d:	89 d8                	mov    %ebx,%eax
  80143f:	c1 e8 16             	shr    $0x16,%eax
  801442:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801449:	a8 01                	test   $0x1,%al
  80144b:	74 da                	je     801427 <sfork+0x6b>
  80144d:	89 da                	mov    %ebx,%edx
  80144f:	c1 ea 0c             	shr    $0xc,%edx
  801452:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801459:	83 e0 05             	and    $0x5,%eax
  80145c:	83 f8 05             	cmp    $0x5,%eax
  80145f:	75 c6                	jne    801427 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801461:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801468:	c1 e2 0c             	shl    $0xc,%edx
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	83 e0 07             	and    $0x7,%eax
  801471:	50                   	push   %eax
  801472:	52                   	push   %edx
  801473:	56                   	push   %esi
  801474:	52                   	push   %edx
  801475:	6a 00                	push   $0x0
  801477:	e8 1e f9 ff ff       	call   800d9a <sys_page_map>
  80147c:	83 c4 20             	add    $0x20,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 a4                	je     801427 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	68 bd 2f 80 00       	push   $0x802fbd
  80148b:	68 bb 00 00 00       	push   $0xbb
  801490:	68 63 2f 80 00       	push   $0x802f63
  801495:	e8 e3 11 00 00       	call   80267d <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	6a 07                	push   $0x7
  80149f:	68 00 f0 bf ee       	push   $0xeebff000
  8014a4:	57                   	push   %edi
  8014a5:	e8 ad f8 ff ff       	call   800d57 <sys_page_alloc>
	if(ret < 0)
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 31                	js     8014e2 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	68 4d 27 80 00       	push   $0x80274d
  8014b9:	57                   	push   %edi
  8014ba:	e8 e3 f9 ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 33                	js     8014f9 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	6a 02                	push   $0x2
  8014cb:	57                   	push   %edi
  8014cc:	e8 4d f9 ff ff       	call   800e1e <sys_env_set_status>
	if(ret < 0)
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 38                	js     801510 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014d8:	89 f8                	mov    %edi,%eax
  8014da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014dd:	5b                   	pop    %ebx
  8014de:	5e                   	pop    %esi
  8014df:	5f                   	pop    %edi
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014e2:	83 ec 04             	sub    $0x4,%esp
  8014e5:	68 6e 2f 80 00       	push   $0x802f6e
  8014ea:	68 c1 00 00 00       	push   $0xc1
  8014ef:	68 63 2f 80 00       	push   $0x802f63
  8014f4:	e8 84 11 00 00       	call   80267d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f9:	83 ec 04             	sub    $0x4,%esp
  8014fc:	68 f8 2f 80 00       	push   $0x802ff8
  801501:	68 c4 00 00 00       	push   $0xc4
  801506:	68 63 2f 80 00       	push   $0x802f63
  80150b:	e8 6d 11 00 00       	call   80267d <_panic>
		panic("panic in sys_env_set_status()\n");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 20 30 80 00       	push   $0x803020
  801518:	68 c7 00 00 00       	push   $0xc7
  80151d:	68 63 2f 80 00       	push   $0x802f63
  801522:	e8 56 11 00 00       	call   80267d <_panic>

00801527 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	05 00 00 00 30       	add    $0x30000000,%eax
  801532:	c1 e8 0c             	shr    $0xc,%eax
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801542:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801547:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    

0080154e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801556:	89 c2                	mov    %eax,%edx
  801558:	c1 ea 16             	shr    $0x16,%edx
  80155b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801562:	f6 c2 01             	test   $0x1,%dl
  801565:	74 2d                	je     801594 <fd_alloc+0x46>
  801567:	89 c2                	mov    %eax,%edx
  801569:	c1 ea 0c             	shr    $0xc,%edx
  80156c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801573:	f6 c2 01             	test   $0x1,%dl
  801576:	74 1c                	je     801594 <fd_alloc+0x46>
  801578:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80157d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801582:	75 d2                	jne    801556 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80158d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801592:	eb 0a                	jmp    80159e <fd_alloc+0x50>
			*fd_store = fd;
  801594:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801597:	89 01                	mov    %eax,(%ecx)
			return 0;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015a6:	83 f8 1f             	cmp    $0x1f,%eax
  8015a9:	77 30                	ja     8015db <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015ab:	c1 e0 0c             	shl    $0xc,%eax
  8015ae:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015b3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015b9:	f6 c2 01             	test   $0x1,%dl
  8015bc:	74 24                	je     8015e2 <fd_lookup+0x42>
  8015be:	89 c2                	mov    %eax,%edx
  8015c0:	c1 ea 0c             	shr    $0xc,%edx
  8015c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ca:	f6 c2 01             	test   $0x1,%dl
  8015cd:	74 1a                	je     8015e9 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 02                	mov    %eax,(%edx)
	return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    
		return -E_INVAL;
  8015db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e0:	eb f7                	jmp    8015d9 <fd_lookup+0x39>
		return -E_INVAL;
  8015e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e7:	eb f0                	jmp    8015d9 <fd_lookup+0x39>
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ee:	eb e9                	jmp    8015d9 <fd_lookup+0x39>

008015f0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fe:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801603:	39 08                	cmp    %ecx,(%eax)
  801605:	74 38                	je     80163f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801607:	83 c2 01             	add    $0x1,%edx
  80160a:	8b 04 95 c4 30 80 00 	mov    0x8030c4(,%edx,4),%eax
  801611:	85 c0                	test   %eax,%eax
  801613:	75 ee                	jne    801603 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801615:	a1 08 50 80 00       	mov    0x805008,%eax
  80161a:	8b 40 48             	mov    0x48(%eax),%eax
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	51                   	push   %ecx
  801621:	50                   	push   %eax
  801622:	68 48 30 80 00       	push   $0x803048
  801627:	e8 da eb ff ff       	call   800206 <cprintf>
	*dev = 0;
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    
			*dev = devtab[i];
  80163f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801642:	89 01                	mov    %eax,(%ecx)
			return 0;
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
  801649:	eb f2                	jmp    80163d <dev_lookup+0x4d>

0080164b <fd_close>:
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	57                   	push   %edi
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
  801651:	83 ec 24             	sub    $0x24,%esp
  801654:	8b 75 08             	mov    0x8(%ebp),%esi
  801657:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80165a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80165d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80165e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801664:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801667:	50                   	push   %eax
  801668:	e8 33 ff ff ff       	call   8015a0 <fd_lookup>
  80166d:	89 c3                	mov    %eax,%ebx
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 05                	js     80167b <fd_close+0x30>
	    || fd != fd2)
  801676:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801679:	74 16                	je     801691 <fd_close+0x46>
		return (must_exist ? r : 0);
  80167b:	89 f8                	mov    %edi,%eax
  80167d:	84 c0                	test   %al,%al
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	0f 44 d8             	cmove  %eax,%ebx
}
  801687:	89 d8                	mov    %ebx,%eax
  801689:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801697:	50                   	push   %eax
  801698:	ff 36                	pushl  (%esi)
  80169a:	e8 51 ff ff ff       	call   8015f0 <dev_lookup>
  80169f:	89 c3                	mov    %eax,%ebx
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 1a                	js     8016c2 <fd_close+0x77>
		if (dev->dev_close)
  8016a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	74 0b                	je     8016c2 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	56                   	push   %esi
  8016bb:	ff d0                	call   *%eax
  8016bd:	89 c3                	mov    %eax,%ebx
  8016bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	56                   	push   %esi
  8016c6:	6a 00                	push   $0x0
  8016c8:	e8 0f f7 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	eb b5                	jmp    801687 <fd_close+0x3c>

008016d2 <close>:

int
close(int fdnum)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	e8 bc fe ff ff       	call   8015a0 <fd_lookup>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	79 02                	jns    8016ed <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    
		return fd_close(fd, 1);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	6a 01                	push   $0x1
  8016f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f5:	e8 51 ff ff ff       	call   80164b <fd_close>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	eb ec                	jmp    8016eb <close+0x19>

008016ff <close_all>:

void
close_all(void)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	53                   	push   %ebx
  801703:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801706:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	53                   	push   %ebx
  80170f:	e8 be ff ff ff       	call   8016d2 <close>
	for (i = 0; i < MAXFD; i++)
  801714:	83 c3 01             	add    $0x1,%ebx
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	83 fb 20             	cmp    $0x20,%ebx
  80171d:	75 ec                	jne    80170b <close_all+0xc>
}
  80171f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	57                   	push   %edi
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80172d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	e8 67 fe ff ff       	call   8015a0 <fd_lookup>
  801739:	89 c3                	mov    %eax,%ebx
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	0f 88 81 00 00 00    	js     8017c7 <dup+0xa3>
		return r;
	close(newfdnum);
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	e8 81 ff ff ff       	call   8016d2 <close>

	newfd = INDEX2FD(newfdnum);
  801751:	8b 75 0c             	mov    0xc(%ebp),%esi
  801754:	c1 e6 0c             	shl    $0xc,%esi
  801757:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80175d:	83 c4 04             	add    $0x4,%esp
  801760:	ff 75 e4             	pushl  -0x1c(%ebp)
  801763:	e8 cf fd ff ff       	call   801537 <fd2data>
  801768:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80176a:	89 34 24             	mov    %esi,(%esp)
  80176d:	e8 c5 fd ff ff       	call   801537 <fd2data>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801777:	89 d8                	mov    %ebx,%eax
  801779:	c1 e8 16             	shr    $0x16,%eax
  80177c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801783:	a8 01                	test   $0x1,%al
  801785:	74 11                	je     801798 <dup+0x74>
  801787:	89 d8                	mov    %ebx,%eax
  801789:	c1 e8 0c             	shr    $0xc,%eax
  80178c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801793:	f6 c2 01             	test   $0x1,%dl
  801796:	75 39                	jne    8017d1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801798:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80179b:	89 d0                	mov    %edx,%eax
  80179d:	c1 e8 0c             	shr    $0xc,%eax
  8017a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017a7:	83 ec 0c             	sub    $0xc,%esp
  8017aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8017af:	50                   	push   %eax
  8017b0:	56                   	push   %esi
  8017b1:	6a 00                	push   $0x0
  8017b3:	52                   	push   %edx
  8017b4:	6a 00                	push   $0x0
  8017b6:	e8 df f5 ff ff       	call   800d9a <sys_page_map>
  8017bb:	89 c3                	mov    %eax,%ebx
  8017bd:	83 c4 20             	add    $0x20,%esp
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	78 31                	js     8017f5 <dup+0xd1>
		goto err;

	return newfdnum;
  8017c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017c7:	89 d8                	mov    %ebx,%eax
  8017c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5f                   	pop    %edi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e0:	50                   	push   %eax
  8017e1:	57                   	push   %edi
  8017e2:	6a 00                	push   $0x0
  8017e4:	53                   	push   %ebx
  8017e5:	6a 00                	push   $0x0
  8017e7:	e8 ae f5 ff ff       	call   800d9a <sys_page_map>
  8017ec:	89 c3                	mov    %eax,%ebx
  8017ee:	83 c4 20             	add    $0x20,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	79 a3                	jns    801798 <dup+0x74>
	sys_page_unmap(0, newfd);
  8017f5:	83 ec 08             	sub    $0x8,%esp
  8017f8:	56                   	push   %esi
  8017f9:	6a 00                	push   $0x0
  8017fb:	e8 dc f5 ff ff       	call   800ddc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801800:	83 c4 08             	add    $0x8,%esp
  801803:	57                   	push   %edi
  801804:	6a 00                	push   $0x0
  801806:	e8 d1 f5 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	eb b7                	jmp    8017c7 <dup+0xa3>

00801810 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	53                   	push   %ebx
  80181f:	e8 7c fd ff ff       	call   8015a0 <fd_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 3f                	js     80186a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801831:	50                   	push   %eax
  801832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801835:	ff 30                	pushl  (%eax)
  801837:	e8 b4 fd ff ff       	call   8015f0 <dev_lookup>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 27                	js     80186a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801843:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801846:	8b 42 08             	mov    0x8(%edx),%eax
  801849:	83 e0 03             	and    $0x3,%eax
  80184c:	83 f8 01             	cmp    $0x1,%eax
  80184f:	74 1e                	je     80186f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	8b 40 08             	mov    0x8(%eax),%eax
  801857:	85 c0                	test   %eax,%eax
  801859:	74 35                	je     801890 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	ff 75 10             	pushl  0x10(%ebp)
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	52                   	push   %edx
  801865:	ff d0                	call   *%eax
  801867:	83 c4 10             	add    $0x10,%esp
}
  80186a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80186f:	a1 08 50 80 00       	mov    0x805008,%eax
  801874:	8b 40 48             	mov    0x48(%eax),%eax
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	53                   	push   %ebx
  80187b:	50                   	push   %eax
  80187c:	68 89 30 80 00       	push   $0x803089
  801881:	e8 80 e9 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188e:	eb da                	jmp    80186a <read+0x5a>
		return -E_NOT_SUPP;
  801890:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801895:	eb d3                	jmp    80186a <read+0x5a>

00801897 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	57                   	push   %edi
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ab:	39 f3                	cmp    %esi,%ebx
  8018ad:	73 23                	jae    8018d2 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	89 f0                	mov    %esi,%eax
  8018b4:	29 d8                	sub    %ebx,%eax
  8018b6:	50                   	push   %eax
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	03 45 0c             	add    0xc(%ebp),%eax
  8018bc:	50                   	push   %eax
  8018bd:	57                   	push   %edi
  8018be:	e8 4d ff ff ff       	call   801810 <read>
		if (m < 0)
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 06                	js     8018d0 <readn+0x39>
			return m;
		if (m == 0)
  8018ca:	74 06                	je     8018d2 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018cc:	01 c3                	add    %eax,%ebx
  8018ce:	eb db                	jmp    8018ab <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018d0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018d2:	89 d8                	mov    %ebx,%eax
  8018d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 1c             	sub    $0x1c,%esp
  8018e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e9:	50                   	push   %eax
  8018ea:	53                   	push   %ebx
  8018eb:	e8 b0 fc ff ff       	call   8015a0 <fd_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 3a                	js     801931 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801901:	ff 30                	pushl  (%eax)
  801903:	e8 e8 fc ff ff       	call   8015f0 <dev_lookup>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 22                	js     801931 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801916:	74 1e                	je     801936 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801918:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191b:	8b 52 0c             	mov    0xc(%edx),%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	74 35                	je     801957 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	ff 75 10             	pushl  0x10(%ebp)
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	50                   	push   %eax
  80192c:	ff d2                	call   *%edx
  80192e:	83 c4 10             	add    $0x10,%esp
}
  801931:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801934:	c9                   	leave  
  801935:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801936:	a1 08 50 80 00       	mov    0x805008,%eax
  80193b:	8b 40 48             	mov    0x48(%eax),%eax
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	53                   	push   %ebx
  801942:	50                   	push   %eax
  801943:	68 a5 30 80 00       	push   $0x8030a5
  801948:	e8 b9 e8 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801955:	eb da                	jmp    801931 <write+0x55>
		return -E_NOT_SUPP;
  801957:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80195c:	eb d3                	jmp    801931 <write+0x55>

0080195e <seek>:

int
seek(int fdnum, off_t offset)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801967:	50                   	push   %eax
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	e8 30 fc ff ff       	call   8015a0 <fd_lookup>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 0e                	js     801985 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 1c             	sub    $0x1c,%esp
  80198e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	50                   	push   %eax
  801995:	53                   	push   %ebx
  801996:	e8 05 fc ff ff       	call   8015a0 <fd_lookup>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 37                	js     8019d9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a8:	50                   	push   %eax
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	ff 30                	pushl  (%eax)
  8019ae:	e8 3d fc ff ff       	call   8015f0 <dev_lookup>
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 1f                	js     8019d9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c1:	74 1b                	je     8019de <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	8b 52 18             	mov    0x18(%edx),%edx
  8019c9:	85 d2                	test   %edx,%edx
  8019cb:	74 32                	je     8019ff <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019cd:	83 ec 08             	sub    $0x8,%esp
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	ff d2                	call   *%edx
  8019d6:	83 c4 10             	add    $0x10,%esp
}
  8019d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019de:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e3:	8b 40 48             	mov    0x48(%eax),%eax
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	53                   	push   %ebx
  8019ea:	50                   	push   %eax
  8019eb:	68 68 30 80 00       	push   $0x803068
  8019f0:	e8 11 e8 ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019fd:	eb da                	jmp    8019d9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a04:	eb d3                	jmp    8019d9 <ftruncate+0x52>

00801a06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 1c             	sub    $0x1c,%esp
  801a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a13:	50                   	push   %eax
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 84 fb ff ff       	call   8015a0 <fd_lookup>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 4b                	js     801a6e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a29:	50                   	push   %eax
  801a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2d:	ff 30                	pushl  (%eax)
  801a2f:	e8 bc fb ff ff       	call   8015f0 <dev_lookup>
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 33                	js     801a6e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a42:	74 2f                	je     801a73 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a44:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a47:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a4e:	00 00 00 
	stat->st_isdir = 0;
  801a51:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a58:	00 00 00 
	stat->st_dev = dev;
  801a5b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	53                   	push   %ebx
  801a65:	ff 75 f0             	pushl  -0x10(%ebp)
  801a68:	ff 50 14             	call   *0x14(%eax)
  801a6b:	83 c4 10             	add    $0x10,%esp
}
  801a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    
		return -E_NOT_SUPP;
  801a73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a78:	eb f4                	jmp    801a6e <fstat+0x68>

00801a7a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	e8 22 02 00 00       	call   801cae <open>
  801a8c:	89 c3                	mov    %eax,%ebx
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 1b                	js     801ab0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	50                   	push   %eax
  801a9c:	e8 65 ff ff ff       	call   801a06 <fstat>
  801aa1:	89 c6                	mov    %eax,%esi
	close(fd);
  801aa3:	89 1c 24             	mov    %ebx,(%esp)
  801aa6:	e8 27 fc ff ff       	call   8016d2 <close>
	return r;
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	89 f3                	mov    %esi,%ebx
}
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	56                   	push   %esi
  801abd:	53                   	push   %ebx
  801abe:	89 c6                	mov    %eax,%esi
  801ac0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ac2:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ac9:	74 27                	je     801af2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801acb:	6a 07                	push   $0x7
  801acd:	68 00 60 80 00       	push   $0x806000
  801ad2:	56                   	push   %esi
  801ad3:	ff 35 00 50 80 00    	pushl  0x805000
  801ad9:	e8 fe 0c 00 00       	call   8027dc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ade:	83 c4 0c             	add    $0xc,%esp
  801ae1:	6a 00                	push   $0x0
  801ae3:	53                   	push   %ebx
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 88 0c 00 00       	call   802773 <ipc_recv>
}
  801aeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aee:	5b                   	pop    %ebx
  801aef:	5e                   	pop    %esi
  801af0:	5d                   	pop    %ebp
  801af1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	6a 01                	push   $0x1
  801af7:	e8 38 0d 00 00       	call   802834 <ipc_find_env>
  801afc:	a3 00 50 80 00       	mov    %eax,0x805000
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	eb c5                	jmp    801acb <fsipc+0x12>

00801b06 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b24:	b8 02 00 00 00       	mov    $0x2,%eax
  801b29:	e8 8b ff ff ff       	call   801ab9 <fsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <devfile_flush>:
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4b:	e8 69 ff ff ff       	call   801ab9 <fsipc>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <devfile_stat>:
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b62:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b67:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b71:	e8 43 ff ff ff       	call   801ab9 <fsipc>
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 2c                	js     801ba6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	68 00 60 80 00       	push   $0x806000
  801b82:	53                   	push   %ebx
  801b83:	e8 dd ed ff ff       	call   800965 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b88:	a1 80 60 80 00       	mov    0x806080,%eax
  801b8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b93:	a1 84 60 80 00       	mov    0x806084,%eax
  801b98:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <devfile_write>:
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	53                   	push   %ebx
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bbb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bc0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801bc6:	53                   	push   %ebx
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	68 08 60 80 00       	push   $0x806008
  801bcf:	e8 81 ef ff ff       	call   800b55 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	b8 04 00 00 00       	mov    $0x4,%eax
  801bde:	e8 d6 fe ff ff       	call   801ab9 <fsipc>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 0b                	js     801bf5 <devfile_write+0x4a>
	assert(r <= n);
  801bea:	39 d8                	cmp    %ebx,%eax
  801bec:	77 0c                	ja     801bfa <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bee:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf3:	7f 1e                	jg     801c13 <devfile_write+0x68>
}
  801bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    
	assert(r <= n);
  801bfa:	68 d8 30 80 00       	push   $0x8030d8
  801bff:	68 df 30 80 00       	push   $0x8030df
  801c04:	68 98 00 00 00       	push   $0x98
  801c09:	68 f4 30 80 00       	push   $0x8030f4
  801c0e:	e8 6a 0a 00 00       	call   80267d <_panic>
	assert(r <= PGSIZE);
  801c13:	68 ff 30 80 00       	push   $0x8030ff
  801c18:	68 df 30 80 00       	push   $0x8030df
  801c1d:	68 99 00 00 00       	push   $0x99
  801c22:	68 f4 30 80 00       	push   $0x8030f4
  801c27:	e8 51 0a 00 00       	call   80267d <_panic>

00801c2c <devfile_read>:
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	56                   	push   %esi
  801c30:	53                   	push   %ebx
  801c31:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c3f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c45:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c4f:	e8 65 fe ff ff       	call   801ab9 <fsipc>
  801c54:	89 c3                	mov    %eax,%ebx
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 1f                	js     801c79 <devfile_read+0x4d>
	assert(r <= n);
  801c5a:	39 f0                	cmp    %esi,%eax
  801c5c:	77 24                	ja     801c82 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c5e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c63:	7f 33                	jg     801c98 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	50                   	push   %eax
  801c69:	68 00 60 80 00       	push   $0x806000
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	e8 7d ee ff ff       	call   800af3 <memmove>
	return r;
  801c76:	83 c4 10             	add    $0x10,%esp
}
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
	assert(r <= n);
  801c82:	68 d8 30 80 00       	push   $0x8030d8
  801c87:	68 df 30 80 00       	push   $0x8030df
  801c8c:	6a 7c                	push   $0x7c
  801c8e:	68 f4 30 80 00       	push   $0x8030f4
  801c93:	e8 e5 09 00 00       	call   80267d <_panic>
	assert(r <= PGSIZE);
  801c98:	68 ff 30 80 00       	push   $0x8030ff
  801c9d:	68 df 30 80 00       	push   $0x8030df
  801ca2:	6a 7d                	push   $0x7d
  801ca4:	68 f4 30 80 00       	push   $0x8030f4
  801ca9:	e8 cf 09 00 00       	call   80267d <_panic>

00801cae <open>:
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	56                   	push   %esi
  801cb2:	53                   	push   %ebx
  801cb3:	83 ec 1c             	sub    $0x1c,%esp
  801cb6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cb9:	56                   	push   %esi
  801cba:	e8 6d ec ff ff       	call   80092c <strlen>
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc7:	7f 6c                	jg     801d35 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cc9:	83 ec 0c             	sub    $0xc,%esp
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	50                   	push   %eax
  801cd0:	e8 79 f8 ff ff       	call   80154e <fd_alloc>
  801cd5:	89 c3                	mov    %eax,%ebx
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 3c                	js     801d1a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cde:	83 ec 08             	sub    $0x8,%esp
  801ce1:	56                   	push   %esi
  801ce2:	68 00 60 80 00       	push   $0x806000
  801ce7:	e8 79 ec ff ff       	call   800965 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cef:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfc:	e8 b8 fd ff ff       	call   801ab9 <fsipc>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	85 c0                	test   %eax,%eax
  801d08:	78 19                	js     801d23 <open+0x75>
	return fd2num(fd);
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d10:	e8 12 f8 ff ff       	call   801527 <fd2num>
  801d15:	89 c3                	mov    %eax,%ebx
  801d17:	83 c4 10             	add    $0x10,%esp
}
  801d1a:	89 d8                	mov    %ebx,%eax
  801d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    
		fd_close(fd, 0);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2b:	e8 1b f9 ff ff       	call   80164b <fd_close>
		return r;
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	eb e5                	jmp    801d1a <open+0x6c>
		return -E_BAD_PATH;
  801d35:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d3a:	eb de                	jmp    801d1a <open+0x6c>

00801d3c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	b8 08 00 00 00       	mov    $0x8,%eax
  801d4c:	e8 68 fd ff ff       	call   801ab9 <fsipc>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d59:	68 0b 31 80 00       	push   $0x80310b
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	e8 ff eb ff ff       	call   800965 <strcpy>
	return 0;
}
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <devsock_close>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	53                   	push   %ebx
  801d71:	83 ec 10             	sub    $0x10,%esp
  801d74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d77:	53                   	push   %ebx
  801d78:	e8 f2 0a 00 00       	call   80286f <pageref>
  801d7d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d85:	83 f8 01             	cmp    $0x1,%eax
  801d88:	74 07                	je     801d91 <devsock_close+0x24>
}
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	ff 73 0c             	pushl  0xc(%ebx)
  801d97:	e8 b9 02 00 00       	call   802055 <nsipc_close>
  801d9c:	89 c2                	mov    %eax,%edx
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	eb e7                	jmp    801d8a <devsock_close+0x1d>

00801da3 <devsock_write>:
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 10             	pushl  0x10(%ebp)
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	ff 70 0c             	pushl  0xc(%eax)
  801db7:	e8 76 03 00 00       	call   802132 <nsipc_send>
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <devsock_read>:
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	ff 75 10             	pushl  0x10(%ebp)
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	ff 70 0c             	pushl  0xc(%eax)
  801dd2:	e8 ef 02 00 00       	call   8020c6 <nsipc_recv>
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <fd2sockid>:
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ddf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	e8 b7 f7 ff ff       	call   8015a0 <fd_lookup>
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	78 10                	js     801e00 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801df9:	39 08                	cmp    %ecx,(%eax)
  801dfb:	75 05                	jne    801e02 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dfd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    
		return -E_NOT_SUPP;
  801e02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e07:	eb f7                	jmp    801e00 <fd2sockid+0x27>

00801e09 <alloc_sockfd>:
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 1c             	sub    $0x1c,%esp
  801e11:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e16:	50                   	push   %eax
  801e17:	e8 32 f7 ff ff       	call   80154e <fd_alloc>
  801e1c:	89 c3                	mov    %eax,%ebx
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 43                	js     801e68 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 07 04 00 00       	push   $0x407
  801e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e30:	6a 00                	push   $0x0
  801e32:	e8 20 ef ff ff       	call   800d57 <sys_page_alloc>
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 28                	js     801e68 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e49:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e55:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	50                   	push   %eax
  801e5c:	e8 c6 f6 ff ff       	call   801527 <fd2num>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	eb 0c                	jmp    801e74 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	56                   	push   %esi
  801e6c:	e8 e4 01 00 00       	call   802055 <nsipc_close>
		return r;
  801e71:	83 c4 10             	add    $0x10,%esp
}
  801e74:	89 d8                	mov    %ebx,%eax
  801e76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    

00801e7d <accept>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	e8 4e ff ff ff       	call   801dd9 <fd2sockid>
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	78 1b                	js     801eaa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	ff 75 10             	pushl  0x10(%ebp)
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	50                   	push   %eax
  801e99:	e8 0e 01 00 00       	call   801fac <nsipc_accept>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 05                	js     801eaa <accept+0x2d>
	return alloc_sockfd(r);
  801ea5:	e8 5f ff ff ff       	call   801e09 <alloc_sockfd>
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <bind>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	e8 1f ff ff ff       	call   801dd9 <fd2sockid>
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 12                	js     801ed0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	ff 75 10             	pushl  0x10(%ebp)
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	50                   	push   %eax
  801ec8:	e8 31 01 00 00       	call   801ffe <nsipc_bind>
  801ecd:	83 c4 10             	add    $0x10,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <shutdown>:
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	e8 f9 fe ff ff       	call   801dd9 <fd2sockid>
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	78 0f                	js     801ef3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	50                   	push   %eax
  801eeb:	e8 43 01 00 00       	call   802033 <nsipc_shutdown>
  801ef0:	83 c4 10             	add    $0x10,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <connect>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	e8 d6 fe ff ff       	call   801dd9 <fd2sockid>
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 12                	js     801f19 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	ff 75 10             	pushl  0x10(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	50                   	push   %eax
  801f11:	e8 59 01 00 00       	call   80206f <nsipc_connect>
  801f16:	83 c4 10             	add    $0x10,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <listen>:
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	e8 b0 fe ff ff       	call   801dd9 <fd2sockid>
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	78 0f                	js     801f3c <listen+0x21>
	return nsipc_listen(r, backlog);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	ff 75 0c             	pushl  0xc(%ebp)
  801f33:	50                   	push   %eax
  801f34:	e8 6b 01 00 00       	call   8020a4 <nsipc_listen>
  801f39:	83 c4 10             	add    $0x10,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <socket>:

int
socket(int domain, int type, int protocol)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f44:	ff 75 10             	pushl  0x10(%ebp)
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	ff 75 08             	pushl  0x8(%ebp)
  801f4d:	e8 3e 02 00 00       	call   802190 <nsipc_socket>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	78 05                	js     801f5e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f59:	e8 ab fe ff ff       	call   801e09 <alloc_sockfd>
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	53                   	push   %ebx
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f69:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f70:	74 26                	je     801f98 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f72:	6a 07                	push   $0x7
  801f74:	68 00 70 80 00       	push   $0x807000
  801f79:	53                   	push   %ebx
  801f7a:	ff 35 04 50 80 00    	pushl  0x805004
  801f80:	e8 57 08 00 00       	call   8027dc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f85:	83 c4 0c             	add    $0xc,%esp
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 e0 07 00 00       	call   802773 <ipc_recv>
}
  801f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	6a 02                	push   $0x2
  801f9d:	e8 92 08 00 00       	call   802834 <ipc_find_env>
  801fa2:	a3 04 50 80 00       	mov    %eax,0x805004
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	eb c6                	jmp    801f72 <nsipc+0x12>

00801fac <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	56                   	push   %esi
  801fb0:	53                   	push   %ebx
  801fb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fbc:	8b 06                	mov    (%esi),%eax
  801fbe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc8:	e8 93 ff ff ff       	call   801f60 <nsipc>
  801fcd:	89 c3                	mov    %eax,%ebx
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	79 09                	jns    801fdc <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fd3:	89 d8                	mov    %ebx,%eax
  801fd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd8:	5b                   	pop    %ebx
  801fd9:	5e                   	pop    %esi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	ff 35 10 70 80 00    	pushl  0x807010
  801fe5:	68 00 70 80 00       	push   $0x807000
  801fea:	ff 75 0c             	pushl  0xc(%ebp)
  801fed:	e8 01 eb ff ff       	call   800af3 <memmove>
		*addrlen = ret->ret_addrlen;
  801ff2:	a1 10 70 80 00       	mov    0x807010,%eax
  801ff7:	89 06                	mov    %eax,(%esi)
  801ff9:	83 c4 10             	add    $0x10,%esp
	return r;
  801ffc:	eb d5                	jmp    801fd3 <nsipc_accept+0x27>

00801ffe <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	53                   	push   %ebx
  802002:	83 ec 08             	sub    $0x8,%esp
  802005:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802010:	53                   	push   %ebx
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	68 04 70 80 00       	push   $0x807004
  802019:	e8 d5 ea ff ff       	call   800af3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80201e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802024:	b8 02 00 00 00       	mov    $0x2,%eax
  802029:	e8 32 ff ff ff       	call   801f60 <nsipc>
}
  80202e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802049:	b8 03 00 00 00       	mov    $0x3,%eax
  80204e:	e8 0d ff ff ff       	call   801f60 <nsipc>
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <nsipc_close>:

int
nsipc_close(int s)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802063:	b8 04 00 00 00       	mov    $0x4,%eax
  802068:	e8 f3 fe ff ff       	call   801f60 <nsipc>
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 08             	sub    $0x8,%esp
  802076:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802081:	53                   	push   %ebx
  802082:	ff 75 0c             	pushl  0xc(%ebp)
  802085:	68 04 70 80 00       	push   $0x807004
  80208a:	e8 64 ea ff ff       	call   800af3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80208f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802095:	b8 05 00 00 00       	mov    $0x5,%eax
  80209a:	e8 c1 fe ff ff       	call   801f60 <nsipc>
}
  80209f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020ba:	b8 06 00 00 00       	mov    $0x6,%eax
  8020bf:	e8 9c fe ff ff       	call   801f60 <nsipc>
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	56                   	push   %esi
  8020ca:	53                   	push   %ebx
  8020cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020d6:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8020df:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020e4:	b8 07 00 00 00       	mov    $0x7,%eax
  8020e9:	e8 72 fe ff ff       	call   801f60 <nsipc>
  8020ee:	89 c3                	mov    %eax,%ebx
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	78 1f                	js     802113 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020f4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020f9:	7f 21                	jg     80211c <nsipc_recv+0x56>
  8020fb:	39 c6                	cmp    %eax,%esi
  8020fd:	7c 1d                	jl     80211c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	50                   	push   %eax
  802103:	68 00 70 80 00       	push   $0x807000
  802108:	ff 75 0c             	pushl  0xc(%ebp)
  80210b:	e8 e3 e9 ff ff       	call   800af3 <memmove>
  802110:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802113:	89 d8                	mov    %ebx,%eax
  802115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802118:	5b                   	pop    %ebx
  802119:	5e                   	pop    %esi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80211c:	68 17 31 80 00       	push   $0x803117
  802121:	68 df 30 80 00       	push   $0x8030df
  802126:	6a 62                	push   $0x62
  802128:	68 2c 31 80 00       	push   $0x80312c
  80212d:	e8 4b 05 00 00       	call   80267d <_panic>

00802132 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	53                   	push   %ebx
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802144:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80214a:	7f 2e                	jg     80217a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	53                   	push   %ebx
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	68 0c 70 80 00       	push   $0x80700c
  802158:	e8 96 e9 ff ff       	call   800af3 <memmove>
	nsipcbuf.send.req_size = size;
  80215d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802163:	8b 45 14             	mov    0x14(%ebp),%eax
  802166:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80216b:	b8 08 00 00 00       	mov    $0x8,%eax
  802170:	e8 eb fd ff ff       	call   801f60 <nsipc>
}
  802175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802178:	c9                   	leave  
  802179:	c3                   	ret    
	assert(size < 1600);
  80217a:	68 38 31 80 00       	push   $0x803138
  80217f:	68 df 30 80 00       	push   $0x8030df
  802184:	6a 6d                	push   $0x6d
  802186:	68 2c 31 80 00       	push   $0x80312c
  80218b:	e8 ed 04 00 00       	call   80267d <_panic>

00802190 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80219e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8021b3:	e8 a8 fd ff ff       	call   801f60 <nsipc>
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	56                   	push   %esi
  8021be:	53                   	push   %ebx
  8021bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	e8 6a f3 ff ff       	call   801537 <fd2data>
  8021cd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021cf:	83 c4 08             	add    $0x8,%esp
  8021d2:	68 44 31 80 00       	push   $0x803144
  8021d7:	53                   	push   %ebx
  8021d8:	e8 88 e7 ff ff       	call   800965 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021dd:	8b 46 04             	mov    0x4(%esi),%eax
  8021e0:	2b 06                	sub    (%esi),%eax
  8021e2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021ef:	00 00 00 
	stat->st_dev = &devpipe;
  8021f2:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021f9:	40 80 00 
	return 0;
}
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    

00802208 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	53                   	push   %ebx
  80220c:	83 ec 0c             	sub    $0xc,%esp
  80220f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802212:	53                   	push   %ebx
  802213:	6a 00                	push   $0x0
  802215:	e8 c2 eb ff ff       	call   800ddc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80221a:	89 1c 24             	mov    %ebx,(%esp)
  80221d:	e8 15 f3 ff ff       	call   801537 <fd2data>
  802222:	83 c4 08             	add    $0x8,%esp
  802225:	50                   	push   %eax
  802226:	6a 00                	push   $0x0
  802228:	e8 af eb ff ff       	call   800ddc <sys_page_unmap>
}
  80222d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <_pipeisclosed>:
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 1c             	sub    $0x1c,%esp
  80223b:	89 c7                	mov    %eax,%edi
  80223d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80223f:	a1 08 50 80 00       	mov    0x805008,%eax
  802244:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	57                   	push   %edi
  80224b:	e8 1f 06 00 00       	call   80286f <pageref>
  802250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802253:	89 34 24             	mov    %esi,(%esp)
  802256:	e8 14 06 00 00       	call   80286f <pageref>
		nn = thisenv->env_runs;
  80225b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802261:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	39 cb                	cmp    %ecx,%ebx
  802269:	74 1b                	je     802286 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80226b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80226e:	75 cf                	jne    80223f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802270:	8b 42 58             	mov    0x58(%edx),%eax
  802273:	6a 01                	push   $0x1
  802275:	50                   	push   %eax
  802276:	53                   	push   %ebx
  802277:	68 4b 31 80 00       	push   $0x80314b
  80227c:	e8 85 df ff ff       	call   800206 <cprintf>
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	eb b9                	jmp    80223f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802286:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802289:	0f 94 c0             	sete   %al
  80228c:	0f b6 c0             	movzbl %al,%eax
}
  80228f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5f                   	pop    %edi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <devpipe_write>:
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	57                   	push   %edi
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
  80229d:	83 ec 28             	sub    $0x28,%esp
  8022a0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022a3:	56                   	push   %esi
  8022a4:	e8 8e f2 ff ff       	call   801537 <fd2data>
  8022a9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022b6:	74 4f                	je     802307 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022b8:	8b 43 04             	mov    0x4(%ebx),%eax
  8022bb:	8b 0b                	mov    (%ebx),%ecx
  8022bd:	8d 51 20             	lea    0x20(%ecx),%edx
  8022c0:	39 d0                	cmp    %edx,%eax
  8022c2:	72 14                	jb     8022d8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022c4:	89 da                	mov    %ebx,%edx
  8022c6:	89 f0                	mov    %esi,%eax
  8022c8:	e8 65 ff ff ff       	call   802232 <_pipeisclosed>
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	75 3b                	jne    80230c <devpipe_write+0x75>
			sys_yield();
  8022d1:	e8 62 ea ff ff       	call   800d38 <sys_yield>
  8022d6:	eb e0                	jmp    8022b8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022db:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022df:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022e2:	89 c2                	mov    %eax,%edx
  8022e4:	c1 fa 1f             	sar    $0x1f,%edx
  8022e7:	89 d1                	mov    %edx,%ecx
  8022e9:	c1 e9 1b             	shr    $0x1b,%ecx
  8022ec:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022ef:	83 e2 1f             	and    $0x1f,%edx
  8022f2:	29 ca                	sub    %ecx,%edx
  8022f4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022fc:	83 c0 01             	add    $0x1,%eax
  8022ff:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802302:	83 c7 01             	add    $0x1,%edi
  802305:	eb ac                	jmp    8022b3 <devpipe_write+0x1c>
	return i;
  802307:	8b 45 10             	mov    0x10(%ebp),%eax
  80230a:	eb 05                	jmp    802311 <devpipe_write+0x7a>
				return 0;
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    

00802319 <devpipe_read>:
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	57                   	push   %edi
  80231d:	56                   	push   %esi
  80231e:	53                   	push   %ebx
  80231f:	83 ec 18             	sub    $0x18,%esp
  802322:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802325:	57                   	push   %edi
  802326:	e8 0c f2 ff ff       	call   801537 <fd2data>
  80232b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	be 00 00 00 00       	mov    $0x0,%esi
  802335:	3b 75 10             	cmp    0x10(%ebp),%esi
  802338:	75 14                	jne    80234e <devpipe_read+0x35>
	return i;
  80233a:	8b 45 10             	mov    0x10(%ebp),%eax
  80233d:	eb 02                	jmp    802341 <devpipe_read+0x28>
				return i;
  80233f:	89 f0                	mov    %esi,%eax
}
  802341:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
			sys_yield();
  802349:	e8 ea e9 ff ff       	call   800d38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80234e:	8b 03                	mov    (%ebx),%eax
  802350:	3b 43 04             	cmp    0x4(%ebx),%eax
  802353:	75 18                	jne    80236d <devpipe_read+0x54>
			if (i > 0)
  802355:	85 f6                	test   %esi,%esi
  802357:	75 e6                	jne    80233f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802359:	89 da                	mov    %ebx,%edx
  80235b:	89 f8                	mov    %edi,%eax
  80235d:	e8 d0 fe ff ff       	call   802232 <_pipeisclosed>
  802362:	85 c0                	test   %eax,%eax
  802364:	74 e3                	je     802349 <devpipe_read+0x30>
				return 0;
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
  80236b:	eb d4                	jmp    802341 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80236d:	99                   	cltd   
  80236e:	c1 ea 1b             	shr    $0x1b,%edx
  802371:	01 d0                	add    %edx,%eax
  802373:	83 e0 1f             	and    $0x1f,%eax
  802376:	29 d0                	sub    %edx,%eax
  802378:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80237d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802380:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802383:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802386:	83 c6 01             	add    $0x1,%esi
  802389:	eb aa                	jmp    802335 <devpipe_read+0x1c>

0080238b <pipe>:
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802393:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802396:	50                   	push   %eax
  802397:	e8 b2 f1 ff ff       	call   80154e <fd_alloc>
  80239c:	89 c3                	mov    %eax,%ebx
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	0f 88 23 01 00 00    	js     8024cc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 07 04 00 00       	push   $0x407
  8023b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b4:	6a 00                	push   $0x0
  8023b6:	e8 9c e9 ff ff       	call   800d57 <sys_page_alloc>
  8023bb:	89 c3                	mov    %eax,%ebx
  8023bd:	83 c4 10             	add    $0x10,%esp
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	0f 88 04 01 00 00    	js     8024cc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8023c8:	83 ec 0c             	sub    $0xc,%esp
  8023cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ce:	50                   	push   %eax
  8023cf:	e8 7a f1 ff ff       	call   80154e <fd_alloc>
  8023d4:	89 c3                	mov    %eax,%ebx
  8023d6:	83 c4 10             	add    $0x10,%esp
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	0f 88 db 00 00 00    	js     8024bc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	68 07 04 00 00       	push   $0x407
  8023e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ec:	6a 00                	push   $0x0
  8023ee:	e8 64 e9 ff ff       	call   800d57 <sys_page_alloc>
  8023f3:	89 c3                	mov    %eax,%ebx
  8023f5:	83 c4 10             	add    $0x10,%esp
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 88 bc 00 00 00    	js     8024bc <pipe+0x131>
	va = fd2data(fd0);
  802400:	83 ec 0c             	sub    $0xc,%esp
  802403:	ff 75 f4             	pushl  -0xc(%ebp)
  802406:	e8 2c f1 ff ff       	call   801537 <fd2data>
  80240b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240d:	83 c4 0c             	add    $0xc,%esp
  802410:	68 07 04 00 00       	push   $0x407
  802415:	50                   	push   %eax
  802416:	6a 00                	push   $0x0
  802418:	e8 3a e9 ff ff       	call   800d57 <sys_page_alloc>
  80241d:	89 c3                	mov    %eax,%ebx
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	85 c0                	test   %eax,%eax
  802424:	0f 88 82 00 00 00    	js     8024ac <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242a:	83 ec 0c             	sub    $0xc,%esp
  80242d:	ff 75 f0             	pushl  -0x10(%ebp)
  802430:	e8 02 f1 ff ff       	call   801537 <fd2data>
  802435:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80243c:	50                   	push   %eax
  80243d:	6a 00                	push   $0x0
  80243f:	56                   	push   %esi
  802440:	6a 00                	push   $0x0
  802442:	e8 53 e9 ff ff       	call   800d9a <sys_page_map>
  802447:	89 c3                	mov    %eax,%ebx
  802449:	83 c4 20             	add    $0x20,%esp
  80244c:	85 c0                	test   %eax,%eax
  80244e:	78 4e                	js     80249e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802450:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802458:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802467:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	ff 75 f4             	pushl  -0xc(%ebp)
  802479:	e8 a9 f0 ff ff       	call   801527 <fd2num>
  80247e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802481:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802483:	83 c4 04             	add    $0x4,%esp
  802486:	ff 75 f0             	pushl  -0x10(%ebp)
  802489:	e8 99 f0 ff ff       	call   801527 <fd2num>
  80248e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802491:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	bb 00 00 00 00       	mov    $0x0,%ebx
  80249c:	eb 2e                	jmp    8024cc <pipe+0x141>
	sys_page_unmap(0, va);
  80249e:	83 ec 08             	sub    $0x8,%esp
  8024a1:	56                   	push   %esi
  8024a2:	6a 00                	push   $0x0
  8024a4:	e8 33 e9 ff ff       	call   800ddc <sys_page_unmap>
  8024a9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024ac:	83 ec 08             	sub    $0x8,%esp
  8024af:	ff 75 f0             	pushl  -0x10(%ebp)
  8024b2:	6a 00                	push   $0x0
  8024b4:	e8 23 e9 ff ff       	call   800ddc <sys_page_unmap>
  8024b9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024bc:	83 ec 08             	sub    $0x8,%esp
  8024bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c2:	6a 00                	push   $0x0
  8024c4:	e8 13 e9 ff ff       	call   800ddc <sys_page_unmap>
  8024c9:	83 c4 10             	add    $0x10,%esp
}
  8024cc:	89 d8                	mov    %ebx,%eax
  8024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <pipeisclosed>:
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024de:	50                   	push   %eax
  8024df:	ff 75 08             	pushl  0x8(%ebp)
  8024e2:	e8 b9 f0 ff ff       	call   8015a0 <fd_lookup>
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	78 18                	js     802506 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f4:	e8 3e f0 ff ff       	call   801537 <fd2data>
	return _pipeisclosed(fd, p);
  8024f9:	89 c2                	mov    %eax,%edx
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	e8 2f fd ff ff       	call   802232 <_pipeisclosed>
  802503:	83 c4 10             	add    $0x10,%esp
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802508:	b8 00 00 00 00       	mov    $0x0,%eax
  80250d:	c3                   	ret    

0080250e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802514:	68 63 31 80 00       	push   $0x803163
  802519:	ff 75 0c             	pushl  0xc(%ebp)
  80251c:	e8 44 e4 ff ff       	call   800965 <strcpy>
	return 0;
}
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <devcons_write>:
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	57                   	push   %edi
  80252c:	56                   	push   %esi
  80252d:	53                   	push   %ebx
  80252e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802534:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802539:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80253f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802542:	73 31                	jae    802575 <devcons_write+0x4d>
		m = n - tot;
  802544:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802547:	29 f3                	sub    %esi,%ebx
  802549:	83 fb 7f             	cmp    $0x7f,%ebx
  80254c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802551:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	53                   	push   %ebx
  802558:	89 f0                	mov    %esi,%eax
  80255a:	03 45 0c             	add    0xc(%ebp),%eax
  80255d:	50                   	push   %eax
  80255e:	57                   	push   %edi
  80255f:	e8 8f e5 ff ff       	call   800af3 <memmove>
		sys_cputs(buf, m);
  802564:	83 c4 08             	add    $0x8,%esp
  802567:	53                   	push   %ebx
  802568:	57                   	push   %edi
  802569:	e8 2d e7 ff ff       	call   800c9b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80256e:	01 de                	add    %ebx,%esi
  802570:	83 c4 10             	add    $0x10,%esp
  802573:	eb ca                	jmp    80253f <devcons_write+0x17>
}
  802575:	89 f0                	mov    %esi,%eax
  802577:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80257a:	5b                   	pop    %ebx
  80257b:	5e                   	pop    %esi
  80257c:	5f                   	pop    %edi
  80257d:	5d                   	pop    %ebp
  80257e:	c3                   	ret    

0080257f <devcons_read>:
{
  80257f:	55                   	push   %ebp
  802580:	89 e5                	mov    %esp,%ebp
  802582:	83 ec 08             	sub    $0x8,%esp
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80258a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80258e:	74 21                	je     8025b1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802590:	e8 24 e7 ff ff       	call   800cb9 <sys_cgetc>
  802595:	85 c0                	test   %eax,%eax
  802597:	75 07                	jne    8025a0 <devcons_read+0x21>
		sys_yield();
  802599:	e8 9a e7 ff ff       	call   800d38 <sys_yield>
  80259e:	eb f0                	jmp    802590 <devcons_read+0x11>
	if (c < 0)
  8025a0:	78 0f                	js     8025b1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025a2:	83 f8 04             	cmp    $0x4,%eax
  8025a5:	74 0c                	je     8025b3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8025a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025aa:	88 02                	mov    %al,(%edx)
	return 1;
  8025ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    
		return 0;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	eb f7                	jmp    8025b1 <devcons_read+0x32>

008025ba <cputchar>:
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025c6:	6a 01                	push   $0x1
  8025c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025cb:	50                   	push   %eax
  8025cc:	e8 ca e6 ff ff       	call   800c9b <sys_cputs>
}
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <getchar>:
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025dc:	6a 01                	push   $0x1
  8025de:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e1:	50                   	push   %eax
  8025e2:	6a 00                	push   $0x0
  8025e4:	e8 27 f2 ff ff       	call   801810 <read>
	if (r < 0)
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	78 06                	js     8025f6 <getchar+0x20>
	if (r < 1)
  8025f0:	74 06                	je     8025f8 <getchar+0x22>
	return c;
  8025f2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    
		return -E_EOF;
  8025f8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025fd:	eb f7                	jmp    8025f6 <getchar+0x20>

008025ff <iscons>:
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802605:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802608:	50                   	push   %eax
  802609:	ff 75 08             	pushl  0x8(%ebp)
  80260c:	e8 8f ef ff ff       	call   8015a0 <fd_lookup>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	85 c0                	test   %eax,%eax
  802616:	78 11                	js     802629 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802621:	39 10                	cmp    %edx,(%eax)
  802623:	0f 94 c0             	sete   %al
  802626:	0f b6 c0             	movzbl %al,%eax
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <opencons>:
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802631:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802634:	50                   	push   %eax
  802635:	e8 14 ef ff ff       	call   80154e <fd_alloc>
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	85 c0                	test   %eax,%eax
  80263f:	78 3a                	js     80267b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 07 04 00 00       	push   $0x407
  802649:	ff 75 f4             	pushl  -0xc(%ebp)
  80264c:	6a 00                	push   $0x0
  80264e:	e8 04 e7 ff ff       	call   800d57 <sys_page_alloc>
  802653:	83 c4 10             	add    $0x10,%esp
  802656:	85 c0                	test   %eax,%eax
  802658:	78 21                	js     80267b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802663:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	50                   	push   %eax
  802673:	e8 af ee ff ff       	call   801527 <fd2num>
  802678:	83 c4 10             	add    $0x10,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	56                   	push   %esi
  802681:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802682:	a1 08 50 80 00       	mov    0x805008,%eax
  802687:	8b 40 48             	mov    0x48(%eax),%eax
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 a0 31 80 00       	push   $0x8031a0
  802692:	50                   	push   %eax
  802693:	68 6f 31 80 00       	push   $0x80316f
  802698:	e8 69 db ff ff       	call   800206 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80269d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026a0:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026a6:	e8 6e e6 ff ff       	call   800d19 <sys_getenvid>
  8026ab:	83 c4 04             	add    $0x4,%esp
  8026ae:	ff 75 0c             	pushl  0xc(%ebp)
  8026b1:	ff 75 08             	pushl  0x8(%ebp)
  8026b4:	56                   	push   %esi
  8026b5:	50                   	push   %eax
  8026b6:	68 7c 31 80 00       	push   $0x80317c
  8026bb:	e8 46 db ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026c0:	83 c4 18             	add    $0x18,%esp
  8026c3:	53                   	push   %ebx
  8026c4:	ff 75 10             	pushl  0x10(%ebp)
  8026c7:	e8 e9 da ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  8026cc:	c7 04 24 a1 2b 80 00 	movl   $0x802ba1,(%esp)
  8026d3:	e8 2e db ff ff       	call   800206 <cprintf>
  8026d8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026db:	cc                   	int3   
  8026dc:	eb fd                	jmp    8026db <_panic+0x5e>

008026de <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026e4:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026eb:	74 0a                	je     8026f7 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	6a 07                	push   $0x7
  8026fc:	68 00 f0 bf ee       	push   $0xeebff000
  802701:	6a 00                	push   $0x0
  802703:	e8 4f e6 ff ff       	call   800d57 <sys_page_alloc>
		if(r < 0)
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	85 c0                	test   %eax,%eax
  80270d:	78 2a                	js     802739 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80270f:	83 ec 08             	sub    $0x8,%esp
  802712:	68 4d 27 80 00       	push   $0x80274d
  802717:	6a 00                	push   $0x0
  802719:	e8 84 e7 ff ff       	call   800ea2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80271e:	83 c4 10             	add    $0x10,%esp
  802721:	85 c0                	test   %eax,%eax
  802723:	79 c8                	jns    8026ed <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	68 d8 31 80 00       	push   $0x8031d8
  80272d:	6a 25                	push   $0x25
  80272f:	68 14 32 80 00       	push   $0x803214
  802734:	e8 44 ff ff ff       	call   80267d <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802739:	83 ec 04             	sub    $0x4,%esp
  80273c:	68 a8 31 80 00       	push   $0x8031a8
  802741:	6a 22                	push   $0x22
  802743:	68 14 32 80 00       	push   $0x803214
  802748:	e8 30 ff ff ff       	call   80267d <_panic>

0080274d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80274d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80274e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802753:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802755:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802758:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80275c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802760:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802763:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802765:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802769:	83 c4 08             	add    $0x8,%esp
	popal
  80276c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80276d:	83 c4 04             	add    $0x4,%esp
	popfl
  802770:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802771:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802772:	c3                   	ret    

00802773 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	56                   	push   %esi
  802777:	53                   	push   %ebx
  802778:	8b 75 08             	mov    0x8(%ebp),%esi
  80277b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802781:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802783:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802788:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80278b:	83 ec 0c             	sub    $0xc,%esp
  80278e:	50                   	push   %eax
  80278f:	e8 73 e7 ff ff       	call   800f07 <sys_ipc_recv>
	if(ret < 0){
  802794:	83 c4 10             	add    $0x10,%esp
  802797:	85 c0                	test   %eax,%eax
  802799:	78 2b                	js     8027c6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80279b:	85 f6                	test   %esi,%esi
  80279d:	74 0a                	je     8027a9 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80279f:	a1 08 50 80 00       	mov    0x805008,%eax
  8027a4:	8b 40 74             	mov    0x74(%eax),%eax
  8027a7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027a9:	85 db                	test   %ebx,%ebx
  8027ab:	74 0a                	je     8027b7 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8027b2:	8b 40 78             	mov    0x78(%eax),%eax
  8027b5:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027b7:	a1 08 50 80 00       	mov    0x805008,%eax
  8027bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027c2:	5b                   	pop    %ebx
  8027c3:	5e                   	pop    %esi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
		if(from_env_store)
  8027c6:	85 f6                	test   %esi,%esi
  8027c8:	74 06                	je     8027d0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027ca:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027d0:	85 db                	test   %ebx,%ebx
  8027d2:	74 eb                	je     8027bf <ipc_recv+0x4c>
			*perm_store = 0;
  8027d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027da:	eb e3                	jmp    8027bf <ipc_recv+0x4c>

008027dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	57                   	push   %edi
  8027e0:	56                   	push   %esi
  8027e1:	53                   	push   %ebx
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8027ee:	85 db                	test   %ebx,%ebx
  8027f0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027f5:	0f 44 d8             	cmove  %eax,%ebx
  8027f8:	eb 05                	jmp    8027ff <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8027fa:	e8 39 e5 ff ff       	call   800d38 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8027ff:	ff 75 14             	pushl  0x14(%ebp)
  802802:	53                   	push   %ebx
  802803:	56                   	push   %esi
  802804:	57                   	push   %edi
  802805:	e8 da e6 ff ff       	call   800ee4 <sys_ipc_try_send>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	85 c0                	test   %eax,%eax
  80280f:	74 1b                	je     80282c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802811:	79 e7                	jns    8027fa <ipc_send+0x1e>
  802813:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802816:	74 e2                	je     8027fa <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 22 32 80 00       	push   $0x803222
  802820:	6a 48                	push   $0x48
  802822:	68 37 32 80 00       	push   $0x803237
  802827:	e8 51 fe ff ff       	call   80267d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80282c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5f                   	pop    %edi
  802832:	5d                   	pop    %ebp
  802833:	c3                   	ret    

00802834 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80283f:	89 c2                	mov    %eax,%edx
  802841:	c1 e2 07             	shl    $0x7,%edx
  802844:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80284a:	8b 52 50             	mov    0x50(%edx),%edx
  80284d:	39 ca                	cmp    %ecx,%edx
  80284f:	74 11                	je     802862 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802851:	83 c0 01             	add    $0x1,%eax
  802854:	3d 00 04 00 00       	cmp    $0x400,%eax
  802859:	75 e4                	jne    80283f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	eb 0b                	jmp    80286d <ipc_find_env+0x39>
			return envs[i].env_id;
  802862:	c1 e0 07             	shl    $0x7,%eax
  802865:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80286a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80286d:	5d                   	pop    %ebp
  80286e:	c3                   	ret    

0080286f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802875:	89 d0                	mov    %edx,%eax
  802877:	c1 e8 16             	shr    $0x16,%eax
  80287a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802886:	f6 c1 01             	test   $0x1,%cl
  802889:	74 1d                	je     8028a8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80288b:	c1 ea 0c             	shr    $0xc,%edx
  80288e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802895:	f6 c2 01             	test   $0x1,%dl
  802898:	74 0e                	je     8028a8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80289a:	c1 ea 0c             	shr    $0xc,%edx
  80289d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028a4:	ef 
  8028a5:	0f b7 c0             	movzwl %ax,%eax
}
  8028a8:	5d                   	pop    %ebp
  8028a9:	c3                   	ret    
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	66 90                	xchg   %ax,%ax
  8028ae:	66 90                	xchg   %ax,%ax

008028b0 <__udivdi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 1c             	sub    $0x1c,%esp
  8028b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028c7:	85 d2                	test   %edx,%edx
  8028c9:	75 4d                	jne    802918 <__udivdi3+0x68>
  8028cb:	39 f3                	cmp    %esi,%ebx
  8028cd:	76 19                	jbe    8028e8 <__udivdi3+0x38>
  8028cf:	31 ff                	xor    %edi,%edi
  8028d1:	89 e8                	mov    %ebp,%eax
  8028d3:	89 f2                	mov    %esi,%edx
  8028d5:	f7 f3                	div    %ebx
  8028d7:	89 fa                	mov    %edi,%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	89 d9                	mov    %ebx,%ecx
  8028ea:	85 db                	test   %ebx,%ebx
  8028ec:	75 0b                	jne    8028f9 <__udivdi3+0x49>
  8028ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f3:	31 d2                	xor    %edx,%edx
  8028f5:	f7 f3                	div    %ebx
  8028f7:	89 c1                	mov    %eax,%ecx
  8028f9:	31 d2                	xor    %edx,%edx
  8028fb:	89 f0                	mov    %esi,%eax
  8028fd:	f7 f1                	div    %ecx
  8028ff:	89 c6                	mov    %eax,%esi
  802901:	89 e8                	mov    %ebp,%eax
  802903:	89 f7                	mov    %esi,%edi
  802905:	f7 f1                	div    %ecx
  802907:	89 fa                	mov    %edi,%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	39 f2                	cmp    %esi,%edx
  80291a:	77 1c                	ja     802938 <__udivdi3+0x88>
  80291c:	0f bd fa             	bsr    %edx,%edi
  80291f:	83 f7 1f             	xor    $0x1f,%edi
  802922:	75 2c                	jne    802950 <__udivdi3+0xa0>
  802924:	39 f2                	cmp    %esi,%edx
  802926:	72 06                	jb     80292e <__udivdi3+0x7e>
  802928:	31 c0                	xor    %eax,%eax
  80292a:	39 eb                	cmp    %ebp,%ebx
  80292c:	77 a9                	ja     8028d7 <__udivdi3+0x27>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	eb a2                	jmp    8028d7 <__udivdi3+0x27>
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	31 ff                	xor    %edi,%edi
  80293a:	31 c0                	xor    %eax,%eax
  80293c:	89 fa                	mov    %edi,%edx
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80294d:	8d 76 00             	lea    0x0(%esi),%esi
  802950:	89 f9                	mov    %edi,%ecx
  802952:	b8 20 00 00 00       	mov    $0x20,%eax
  802957:	29 f8                	sub    %edi,%eax
  802959:	d3 e2                	shl    %cl,%edx
  80295b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80295f:	89 c1                	mov    %eax,%ecx
  802961:	89 da                	mov    %ebx,%edx
  802963:	d3 ea                	shr    %cl,%edx
  802965:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802969:	09 d1                	or     %edx,%ecx
  80296b:	89 f2                	mov    %esi,%edx
  80296d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802971:	89 f9                	mov    %edi,%ecx
  802973:	d3 e3                	shl    %cl,%ebx
  802975:	89 c1                	mov    %eax,%ecx
  802977:	d3 ea                	shr    %cl,%edx
  802979:	89 f9                	mov    %edi,%ecx
  80297b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80297f:	89 eb                	mov    %ebp,%ebx
  802981:	d3 e6                	shl    %cl,%esi
  802983:	89 c1                	mov    %eax,%ecx
  802985:	d3 eb                	shr    %cl,%ebx
  802987:	09 de                	or     %ebx,%esi
  802989:	89 f0                	mov    %esi,%eax
  80298b:	f7 74 24 08          	divl   0x8(%esp)
  80298f:	89 d6                	mov    %edx,%esi
  802991:	89 c3                	mov    %eax,%ebx
  802993:	f7 64 24 0c          	mull   0xc(%esp)
  802997:	39 d6                	cmp    %edx,%esi
  802999:	72 15                	jb     8029b0 <__udivdi3+0x100>
  80299b:	89 f9                	mov    %edi,%ecx
  80299d:	d3 e5                	shl    %cl,%ebp
  80299f:	39 c5                	cmp    %eax,%ebp
  8029a1:	73 04                	jae    8029a7 <__udivdi3+0xf7>
  8029a3:	39 d6                	cmp    %edx,%esi
  8029a5:	74 09                	je     8029b0 <__udivdi3+0x100>
  8029a7:	89 d8                	mov    %ebx,%eax
  8029a9:	31 ff                	xor    %edi,%edi
  8029ab:	e9 27 ff ff ff       	jmp    8028d7 <__udivdi3+0x27>
  8029b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029b3:	31 ff                	xor    %edi,%edi
  8029b5:	e9 1d ff ff ff       	jmp    8028d7 <__udivdi3+0x27>
  8029ba:	66 90                	xchg   %ax,%ax
  8029bc:	66 90                	xchg   %ax,%ax
  8029be:	66 90                	xchg   %ax,%ax

008029c0 <__umoddi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029d7:	89 da                	mov    %ebx,%edx
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	75 43                	jne    802a20 <__umoddi3+0x60>
  8029dd:	39 df                	cmp    %ebx,%edi
  8029df:	76 17                	jbe    8029f8 <__umoddi3+0x38>
  8029e1:	89 f0                	mov    %esi,%eax
  8029e3:	f7 f7                	div    %edi
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	31 d2                	xor    %edx,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 fd                	mov    %edi,%ebp
  8029fa:	85 ff                	test   %edi,%edi
  8029fc:	75 0b                	jne    802a09 <__umoddi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f7                	div    %edi
  802a07:	89 c5                	mov    %eax,%ebp
  802a09:	89 d8                	mov    %ebx,%eax
  802a0b:	31 d2                	xor    %edx,%edx
  802a0d:	f7 f5                	div    %ebp
  802a0f:	89 f0                	mov    %esi,%eax
  802a11:	f7 f5                	div    %ebp
  802a13:	89 d0                	mov    %edx,%eax
  802a15:	eb d0                	jmp    8029e7 <__umoddi3+0x27>
  802a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a1e:	66 90                	xchg   %ax,%ax
  802a20:	89 f1                	mov    %esi,%ecx
  802a22:	39 d8                	cmp    %ebx,%eax
  802a24:	76 0a                	jbe    802a30 <__umoddi3+0x70>
  802a26:	89 f0                	mov    %esi,%eax
  802a28:	83 c4 1c             	add    $0x1c,%esp
  802a2b:	5b                   	pop    %ebx
  802a2c:	5e                   	pop    %esi
  802a2d:	5f                   	pop    %edi
  802a2e:	5d                   	pop    %ebp
  802a2f:	c3                   	ret    
  802a30:	0f bd e8             	bsr    %eax,%ebp
  802a33:	83 f5 1f             	xor    $0x1f,%ebp
  802a36:	75 20                	jne    802a58 <__umoddi3+0x98>
  802a38:	39 d8                	cmp    %ebx,%eax
  802a3a:	0f 82 b0 00 00 00    	jb     802af0 <__umoddi3+0x130>
  802a40:	39 f7                	cmp    %esi,%edi
  802a42:	0f 86 a8 00 00 00    	jbe    802af0 <__umoddi3+0x130>
  802a48:	89 c8                	mov    %ecx,%eax
  802a4a:	83 c4 1c             	add    $0x1c,%esp
  802a4d:	5b                   	pop    %ebx
  802a4e:	5e                   	pop    %esi
  802a4f:	5f                   	pop    %edi
  802a50:	5d                   	pop    %ebp
  802a51:	c3                   	ret    
  802a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a58:	89 e9                	mov    %ebp,%ecx
  802a5a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a5f:	29 ea                	sub    %ebp,%edx
  802a61:	d3 e0                	shl    %cl,%eax
  802a63:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a67:	89 d1                	mov    %edx,%ecx
  802a69:	89 f8                	mov    %edi,%eax
  802a6b:	d3 e8                	shr    %cl,%eax
  802a6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a71:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a75:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a79:	09 c1                	or     %eax,%ecx
  802a7b:	89 d8                	mov    %ebx,%eax
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 e9                	mov    %ebp,%ecx
  802a83:	d3 e7                	shl    %cl,%edi
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	d3 e8                	shr    %cl,%eax
  802a89:	89 e9                	mov    %ebp,%ecx
  802a8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a8f:	d3 e3                	shl    %cl,%ebx
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	89 d1                	mov    %edx,%ecx
  802a95:	89 f0                	mov    %esi,%eax
  802a97:	d3 e8                	shr    %cl,%eax
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	89 fa                	mov    %edi,%edx
  802a9d:	d3 e6                	shl    %cl,%esi
  802a9f:	09 d8                	or     %ebx,%eax
  802aa1:	f7 74 24 08          	divl   0x8(%esp)
  802aa5:	89 d1                	mov    %edx,%ecx
  802aa7:	89 f3                	mov    %esi,%ebx
  802aa9:	f7 64 24 0c          	mull   0xc(%esp)
  802aad:	89 c6                	mov    %eax,%esi
  802aaf:	89 d7                	mov    %edx,%edi
  802ab1:	39 d1                	cmp    %edx,%ecx
  802ab3:	72 06                	jb     802abb <__umoddi3+0xfb>
  802ab5:	75 10                	jne    802ac7 <__umoddi3+0x107>
  802ab7:	39 c3                	cmp    %eax,%ebx
  802ab9:	73 0c                	jae    802ac7 <__umoddi3+0x107>
  802abb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802abf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ac3:	89 d7                	mov    %edx,%edi
  802ac5:	89 c6                	mov    %eax,%esi
  802ac7:	89 ca                	mov    %ecx,%edx
  802ac9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ace:	29 f3                	sub    %esi,%ebx
  802ad0:	19 fa                	sbb    %edi,%edx
  802ad2:	89 d0                	mov    %edx,%eax
  802ad4:	d3 e0                	shl    %cl,%eax
  802ad6:	89 e9                	mov    %ebp,%ecx
  802ad8:	d3 eb                	shr    %cl,%ebx
  802ada:	d3 ea                	shr    %cl,%edx
  802adc:	09 d8                	or     %ebx,%eax
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	89 da                	mov    %ebx,%edx
  802af2:	29 fe                	sub    %edi,%esi
  802af4:	19 c2                	sbb    %eax,%edx
  802af6:	89 f1                	mov    %esi,%ecx
  802af8:	89 c8                	mov    %ecx,%eax
  802afa:	e9 4b ff ff ff       	jmp    802a4a <__umoddi3+0x8a>
