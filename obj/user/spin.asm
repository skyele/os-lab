
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
  80003a:	68 60 2b 80 00       	push   $0x802b60
  80003f:	e8 13 02 00 00       	call   800257 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 a9 12 00 00       	call   8012f2 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 d8 2b 80 00       	push   $0x802bd8
  800058:	e8 fa 01 00 00       	call   800257 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 88 2b 80 00       	push   $0x802b88
  80006c:	e8 e6 01 00 00       	call   800257 <cprintf>
	sys_yield();
  800071:	e8 13 0d 00 00       	call   800d89 <sys_yield>
	sys_yield();
  800076:	e8 0e 0d 00 00       	call   800d89 <sys_yield>
	sys_yield();
  80007b:	e8 09 0d 00 00       	call   800d89 <sys_yield>
	sys_yield();
  800080:	e8 04 0d 00 00       	call   800d89 <sys_yield>
	sys_yield();
  800085:	e8 ff 0c 00 00       	call   800d89 <sys_yield>
	sys_yield();
  80008a:	e8 fa 0c 00 00       	call   800d89 <sys_yield>
	sys_yield();
  80008f:	e8 f5 0c 00 00       	call   800d89 <sys_yield>
	sys_yield();
  800094:	e8 f0 0c 00 00       	call   800d89 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 b0 2b 80 00 	movl   $0x802bb0,(%esp)
  8000a0:	e8 b2 01 00 00       	call   800257 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 7c 0c 00 00       	call   800d29 <sys_env_destroy>
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
  8000c8:	e8 9d 0c 00 00       	call   800d6a <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80012c:	a1 08 50 80 00       	mov    0x805008,%eax
  800131:	8b 40 48             	mov    0x48(%eax),%eax
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	50                   	push   %eax
  800138:	68 f6 2b 80 00       	push   $0x802bf6
  80013d:	e8 15 01 00 00       	call   800257 <cprintf>
	cprintf("before umain\n");
  800142:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800149:	e8 09 01 00 00       	call   800257 <cprintf>
	// call user main routine
	umain(argc, argv);
  80014e:	83 c4 08             	add    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 d7 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80015c:	c7 04 24 22 2c 80 00 	movl   $0x802c22,(%esp)
  800163:	e8 ef 00 00 00       	call   800257 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800168:	a1 08 50 80 00       	mov    0x805008,%eax
  80016d:	8b 40 48             	mov    0x48(%eax),%eax
  800170:	83 c4 08             	add    $0x8,%esp
  800173:	50                   	push   %eax
  800174:	68 2f 2c 80 00       	push   $0x802c2f
  800179:	e8 d9 00 00 00       	call   800257 <cprintf>
	// exit gracefully
	exit();
  80017e:	e8 0b 00 00 00       	call   80018e <exit>
}
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    

0080018e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800194:	a1 08 50 80 00       	mov    0x805008,%eax
  800199:	8b 40 48             	mov    0x48(%eax),%eax
  80019c:	68 5c 2c 80 00       	push   $0x802c5c
  8001a1:	50                   	push   %eax
  8001a2:	68 4e 2c 80 00       	push   $0x802c4e
  8001a7:	e8 ab 00 00 00       	call   800257 <cprintf>
	close_all();
  8001ac:	e8 ab 15 00 00       	call   80175c <close_all>
	sys_env_destroy(0);
  8001b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b8:	e8 6c 0b 00 00       	call   800d29 <sys_env_destroy>
}
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001cc:	8b 13                	mov    (%ebx),%edx
  8001ce:	8d 42 01             	lea    0x1(%edx),%eax
  8001d1:	89 03                	mov    %eax,(%ebx)
  8001d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001df:	74 09                	je     8001ea <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	68 ff 00 00 00       	push   $0xff
  8001f2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f5:	50                   	push   %eax
  8001f6:	e8 f1 0a 00 00       	call   800cec <sys_cputs>
		b->idx = 0;
  8001fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	eb db                	jmp    8001e1 <putch+0x1f>

00800206 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80020f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800216:	00 00 00 
	b.cnt = 0;
  800219:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800220:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800223:	ff 75 0c             	pushl  0xc(%ebp)
  800226:	ff 75 08             	pushl  0x8(%ebp)
  800229:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022f:	50                   	push   %eax
  800230:	68 c2 01 80 00       	push   $0x8001c2
  800235:	e8 4a 01 00 00       	call   800384 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80023a:	83 c4 08             	add    $0x8,%esp
  80023d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800243:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 9d 0a 00 00       	call   800cec <sys_cputs>

	return b.cnt;
}
  80024f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800260:	50                   	push   %eax
  800261:	ff 75 08             	pushl  0x8(%ebp)
  800264:	e8 9d ff ff ff       	call   800206 <vcprintf>
	va_end(ap);

	return cnt;
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	57                   	push   %edi
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	83 ec 1c             	sub    $0x1c,%esp
  800274:	89 c6                	mov    %eax,%esi
  800276:	89 d7                	mov    %edx,%edi
  800278:	8b 45 08             	mov    0x8(%ebp),%eax
  80027b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800281:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800284:	8b 45 10             	mov    0x10(%ebp),%eax
  800287:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80028a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80028e:	74 2c                	je     8002bc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800290:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800293:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80029a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80029d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002a5:	73 43                	jae    8002ea <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002a7:	83 eb 01             	sub    $0x1,%ebx
  8002aa:	85 db                	test   %ebx,%ebx
  8002ac:	7e 6c                	jle    80031a <printnum+0xaf>
				putch(padc, putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	57                   	push   %edi
  8002b2:	ff 75 18             	pushl  0x18(%ebp)
  8002b5:	ff d6                	call   *%esi
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb eb                	jmp    8002a7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	6a 20                	push   $0x20
  8002c1:	6a 00                	push   $0x0
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ca:	89 fa                	mov    %edi,%edx
  8002cc:	89 f0                	mov    %esi,%eax
  8002ce:	e8 98 ff ff ff       	call   80026b <printnum>
		while (--width > 0)
  8002d3:	83 c4 20             	add    $0x20,%esp
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	85 db                	test   %ebx,%ebx
  8002db:	7e 65                	jle    800342 <printnum+0xd7>
			putch(padc, putdat);
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	57                   	push   %edi
  8002e1:	6a 20                	push   $0x20
  8002e3:	ff d6                	call   *%esi
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	eb ec                	jmp    8002d6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 18             	pushl  0x18(%ebp)
  8002f0:	83 eb 01             	sub    $0x1,%ebx
  8002f3:	53                   	push   %ebx
  8002f4:	50                   	push   %eax
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	ff 75 e0             	pushl  -0x20(%ebp)
  800304:	e8 07 26 00 00       	call   802910 <__udivdi3>
  800309:	83 c4 18             	add    $0x18,%esp
  80030c:	52                   	push   %edx
  80030d:	50                   	push   %eax
  80030e:	89 fa                	mov    %edi,%edx
  800310:	89 f0                	mov    %esi,%eax
  800312:	e8 54 ff ff ff       	call   80026b <printnum>
  800317:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	57                   	push   %edi
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	ff 75 dc             	pushl  -0x24(%ebp)
  800324:	ff 75 d8             	pushl  -0x28(%ebp)
  800327:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032a:	ff 75 e0             	pushl  -0x20(%ebp)
  80032d:	e8 ee 26 00 00       	call   802a20 <__umoddi3>
  800332:	83 c4 14             	add    $0x14,%esp
  800335:	0f be 80 61 2c 80 00 	movsbl 0x802c61(%eax),%eax
  80033c:	50                   	push   %eax
  80033d:	ff d6                	call   *%esi
  80033f:	83 c4 10             	add    $0x10,%esp
	}
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    

0080034a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800350:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800354:	8b 10                	mov    (%eax),%edx
  800356:	3b 50 04             	cmp    0x4(%eax),%edx
  800359:	73 0a                	jae    800365 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035e:	89 08                	mov    %ecx,(%eax)
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	88 02                	mov    %al,(%edx)
}
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <printfmt>:
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800370:	50                   	push   %eax
  800371:	ff 75 10             	pushl  0x10(%ebp)
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 05 00 00 00       	call   800384 <vprintfmt>
}
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <vprintfmt>:
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 3c             	sub    $0x3c,%esp
  80038d:	8b 75 08             	mov    0x8(%ebp),%esi
  800390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800393:	8b 7d 10             	mov    0x10(%ebp),%edi
  800396:	e9 32 04 00 00       	jmp    8007cd <vprintfmt+0x449>
		padc = ' ';
  80039b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80039f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003a6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8d 47 01             	lea    0x1(%edi),%eax
  8003ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cd:	0f b6 17             	movzbl (%edi),%edx
  8003d0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d3:	3c 55                	cmp    $0x55,%al
  8003d5:	0f 87 12 05 00 00    	ja     8008ed <vprintfmt+0x569>
  8003db:	0f b6 c0             	movzbl %al,%eax
  8003de:	ff 24 85 40 2e 80 00 	jmp    *0x802e40(,%eax,4)
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003ec:	eb d9                	jmp    8003c7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003f5:	eb d0                	jmp    8003c7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	0f b6 d2             	movzbl %dl,%edx
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	89 75 08             	mov    %esi,0x8(%ebp)
  800405:	eb 03                	jmp    80040a <vprintfmt+0x86>
  800407:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80040a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80040d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800411:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800414:	8d 72 d0             	lea    -0x30(%edx),%esi
  800417:	83 fe 09             	cmp    $0x9,%esi
  80041a:	76 eb                	jbe    800407 <vprintfmt+0x83>
  80041c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041f:	8b 75 08             	mov    0x8(%ebp),%esi
  800422:	eb 14                	jmp    800438 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 40 04             	lea    0x4(%eax),%eax
  800432:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800438:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043c:	79 89                	jns    8003c7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80043e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800444:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80044b:	e9 77 ff ff ff       	jmp    8003c7 <vprintfmt+0x43>
  800450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	0f 48 c1             	cmovs  %ecx,%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80045e:	e9 64 ff ff ff       	jmp    8003c7 <vprintfmt+0x43>
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800466:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80046d:	e9 55 ff ff ff       	jmp    8003c7 <vprintfmt+0x43>
			lflag++;
  800472:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800479:	e9 49 ff ff ff       	jmp    8003c7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 78 04             	lea    0x4(%eax),%edi
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	ff 30                	pushl  (%eax)
  80048a:	ff d6                	call   *%esi
			break;
  80048c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800492:	e9 33 03 00 00       	jmp    8007ca <vprintfmt+0x446>
			err = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
  8004a0:	31 d0                	xor    %edx,%eax
  8004a2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a4:	83 f8 11             	cmp    $0x11,%eax
  8004a7:	7f 23                	jg     8004cc <vprintfmt+0x148>
  8004a9:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 18                	je     8004cc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004b4:	52                   	push   %edx
  8004b5:	68 ad 31 80 00       	push   $0x8031ad
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 a6 fe ff ff       	call   800367 <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c7:	e9 fe 02 00 00       	jmp    8007ca <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 79 2c 80 00       	push   $0x802c79
  8004d2:	53                   	push   %ebx
  8004d3:	56                   	push   %esi
  8004d4:	e8 8e fe ff ff       	call   800367 <printfmt>
  8004d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004df:	e9 e6 02 00 00       	jmp    8007ca <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	83 c0 04             	add    $0x4,%eax
  8004ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004f2:	85 c9                	test   %ecx,%ecx
  8004f4:	b8 72 2c 80 00       	mov    $0x802c72,%eax
  8004f9:	0f 45 c1             	cmovne %ecx,%eax
  8004fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800503:	7e 06                	jle    80050b <vprintfmt+0x187>
  800505:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800509:	75 0d                	jne    800518 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80050e:	89 c7                	mov    %eax,%edi
  800510:	03 45 e0             	add    -0x20(%ebp),%eax
  800513:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800516:	eb 53                	jmp    80056b <vprintfmt+0x1e7>
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 d8             	pushl  -0x28(%ebp)
  80051e:	50                   	push   %eax
  80051f:	e8 71 04 00 00       	call   800995 <strnlen>
  800524:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800527:	29 c1                	sub    %eax,%ecx
  800529:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800531:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	eb 0f                	jmp    800549 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	ff 75 e0             	pushl  -0x20(%ebp)
  800541:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	83 ef 01             	sub    $0x1,%edi
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	85 ff                	test   %edi,%edi
  80054b:	7f ed                	jg     80053a <vprintfmt+0x1b6>
  80054d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800550:	85 c9                	test   %ecx,%ecx
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	0f 49 c1             	cmovns %ecx,%eax
  80055a:	29 c1                	sub    %eax,%ecx
  80055c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80055f:	eb aa                	jmp    80050b <vprintfmt+0x187>
					putch(ch, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	52                   	push   %edx
  800566:	ff d6                	call   *%esi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800570:	83 c7 01             	add    $0x1,%edi
  800573:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800577:	0f be d0             	movsbl %al,%edx
  80057a:	85 d2                	test   %edx,%edx
  80057c:	74 4b                	je     8005c9 <vprintfmt+0x245>
  80057e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800582:	78 06                	js     80058a <vprintfmt+0x206>
  800584:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800588:	78 1e                	js     8005a8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80058e:	74 d1                	je     800561 <vprintfmt+0x1dd>
  800590:	0f be c0             	movsbl %al,%eax
  800593:	83 e8 20             	sub    $0x20,%eax
  800596:	83 f8 5e             	cmp    $0x5e,%eax
  800599:	76 c6                	jbe    800561 <vprintfmt+0x1dd>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 3f                	push   $0x3f
  8005a1:	ff d6                	call   *%esi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb c3                	jmp    80056b <vprintfmt+0x1e7>
  8005a8:	89 cf                	mov    %ecx,%edi
  8005aa:	eb 0e                	jmp    8005ba <vprintfmt+0x236>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 01 02 00 00       	jmp    8007ca <vprintfmt+0x446>
  8005c9:	89 cf                	mov    %ecx,%edi
  8005cb:	eb ed                	jmp    8005ba <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005d0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005d7:	e9 eb fd ff ff       	jmp    8003c7 <vprintfmt+0x43>
	if (lflag >= 2)
  8005dc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005e0:	7f 21                	jg     800603 <vprintfmt+0x27f>
	else if (lflag)
  8005e2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e6:	74 68                	je     800650 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f0:	89 c1                	mov    %eax,%ecx
  8005f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 04             	lea    0x4(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800601:	eb 17                	jmp    80061a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 50 04             	mov    0x4(%eax),%edx
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80060e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 40 08             	lea    0x8(%eax),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80061a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800626:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062a:	78 3f                	js     80066b <vprintfmt+0x2e7>
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800631:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800635:	0f 84 71 01 00 00    	je     8007ac <vprintfmt+0x428>
				putch('+', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 2b                	push   $0x2b
  800641:	ff d6                	call   *%esi
  800643:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800646:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064b:	e9 5c 01 00 00       	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, int);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800658:	89 c1                	mov    %eax,%ecx
  80065a:	c1 f9 1f             	sar    $0x1f,%ecx
  80065d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
  800669:	eb af                	jmp    80061a <vprintfmt+0x296>
				putch('-', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 2d                	push   $0x2d
  800671:	ff d6                	call   *%esi
				num = -(long long) num;
  800673:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800676:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800679:	f7 d8                	neg    %eax
  80067b:	83 d2 00             	adc    $0x0,%edx
  80067e:	f7 da                	neg    %edx
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800686:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800689:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068e:	e9 19 01 00 00       	jmp    8007ac <vprintfmt+0x428>
	if (lflag >= 2)
  800693:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800697:	7f 29                	jg     8006c2 <vprintfmt+0x33e>
	else if (lflag)
  800699:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069d:	74 44                	je     8006e3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bd:	e9 ea 00 00 00       	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 08             	lea    0x8(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006de:	e9 c9 00 00 00       	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	e9 a6 00 00 00       	jmp    8007ac <vprintfmt+0x428>
			putch('0', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	6a 30                	push   $0x30
  80070c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800715:	7f 26                	jg     80073d <vprintfmt+0x3b9>
	else if (lflag)
  800717:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80071b:	74 3e                	je     80075b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800736:	b8 08 00 00 00       	mov    $0x8,%eax
  80073b:	eb 6f                	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 50 04             	mov    0x4(%eax),%edx
  800743:	8b 00                	mov    (%eax),%eax
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 08             	lea    0x8(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800754:	b8 08 00 00 00       	mov    $0x8,%eax
  800759:	eb 51                	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
  800765:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800768:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8d 40 04             	lea    0x4(%eax),%eax
  800771:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800774:	b8 08 00 00 00       	mov    $0x8,%eax
  800779:	eb 31                	jmp    8007ac <vprintfmt+0x428>
			putch('0', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 30                	push   $0x30
  800781:	ff d6                	call   *%esi
			putch('x', putdat);
  800783:	83 c4 08             	add    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 78                	push   $0x78
  800789:	ff d6                	call   *%esi
			num = (unsigned long long)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80079b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007b3:	52                   	push   %edx
  8007b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007be:	89 da                	mov    %ebx,%edx
  8007c0:	89 f0                	mov    %esi,%eax
  8007c2:	e8 a4 fa ff ff       	call   80026b <printnum>
			break;
  8007c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cd:	83 c7 01             	add    $0x1,%edi
  8007d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d4:	83 f8 25             	cmp    $0x25,%eax
  8007d7:	0f 84 be fb ff ff    	je     80039b <vprintfmt+0x17>
			if (ch == '\0')
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	0f 84 28 01 00 00    	je     80090d <vprintfmt+0x589>
			putch(ch, putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	50                   	push   %eax
  8007ea:	ff d6                	call   *%esi
  8007ec:	83 c4 10             	add    $0x10,%esp
  8007ef:	eb dc                	jmp    8007cd <vprintfmt+0x449>
	if (lflag >= 2)
  8007f1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f5:	7f 26                	jg     80081d <vprintfmt+0x499>
	else if (lflag)
  8007f7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fb:	74 41                	je     80083e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	ba 00 00 00 00       	mov    $0x0,%edx
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	b8 10 00 00 00       	mov    $0x10,%eax
  80081b:	eb 8f                	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 50 04             	mov    0x4(%eax),%edx
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800828:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 40 08             	lea    0x8(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
  800839:	e9 6e ff ff ff       	jmp    8007ac <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	ba 00 00 00 00       	mov    $0x0,%edx
  800848:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800857:	b8 10 00 00 00       	mov    $0x10,%eax
  80085c:	e9 4b ff ff ff       	jmp    8007ac <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 c0 04             	add    $0x4,%eax
  800867:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	85 c0                	test   %eax,%eax
  800871:	74 14                	je     800887 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800873:	8b 13                	mov    (%ebx),%edx
  800875:	83 fa 7f             	cmp    $0x7f,%edx
  800878:	7f 37                	jg     8008b1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80087a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80087c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
  800882:	e9 43 ff ff ff       	jmp    8007ca <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800887:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088c:	bf 95 2d 80 00       	mov    $0x802d95,%edi
							putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	53                   	push   %ebx
  800895:	50                   	push   %eax
  800896:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800898:	83 c7 01             	add    $0x1,%edi
  80089b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	75 eb                	jne    800891 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ac:	e9 19 ff ff ff       	jmp    8007ca <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008b1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b8:	bf cd 2d 80 00       	mov    $0x802dcd,%edi
							putch(ch, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	50                   	push   %eax
  8008c2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c4:	83 c7 01             	add    $0x1,%edi
  8008c7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	75 eb                	jne    8008bd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	e9 ed fe ff ff       	jmp    8007ca <vprintfmt+0x446>
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 25                	push   $0x25
  8008e3:	ff d6                	call   *%esi
			break;
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	e9 dd fe ff ff       	jmp    8007ca <vprintfmt+0x446>
			putch('%', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	6a 25                	push   $0x25
  8008f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	89 f8                	mov    %edi,%eax
  8008fa:	eb 03                	jmp    8008ff <vprintfmt+0x57b>
  8008fc:	83 e8 01             	sub    $0x1,%eax
  8008ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800903:	75 f7                	jne    8008fc <vprintfmt+0x578>
  800905:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800908:	e9 bd fe ff ff       	jmp    8007ca <vprintfmt+0x446>
}
  80090d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5f                   	pop    %edi
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800921:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800924:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800928:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800932:	85 c0                	test   %eax,%eax
  800934:	74 26                	je     80095c <vsnprintf+0x47>
  800936:	85 d2                	test   %edx,%edx
  800938:	7e 22                	jle    80095c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093a:	ff 75 14             	pushl  0x14(%ebp)
  80093d:	ff 75 10             	pushl  0x10(%ebp)
  800940:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	68 4a 03 80 00       	push   $0x80034a
  800949:	e8 36 fa ff ff       	call   800384 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80094e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800951:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800957:	83 c4 10             	add    $0x10,%esp
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    
		return -E_INVAL;
  80095c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800961:	eb f7                	jmp    80095a <vsnprintf+0x45>

00800963 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80096c:	50                   	push   %eax
  80096d:	ff 75 10             	pushl  0x10(%ebp)
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 9a ff ff ff       	call   800915 <vsnprintf>
	va_end(ap);

	return rc;
}
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
  800988:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80098c:	74 05                	je     800993 <strlen+0x16>
		n++;
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	eb f5                	jmp    800988 <strlen+0xb>
	return n;
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	39 c2                	cmp    %eax,%edx
  8009a5:	74 0d                	je     8009b4 <strnlen+0x1f>
  8009a7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009ab:	74 05                	je     8009b2 <strnlen+0x1d>
		n++;
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	eb f1                	jmp    8009a3 <strnlen+0xe>
  8009b2:	89 d0                	mov    %edx,%eax
	return n;
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009c9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	84 c9                	test   %cl,%cl
  8009d1:	75 f2                	jne    8009c5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009d3:	5b                   	pop    %ebx
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	53                   	push   %ebx
  8009da:	83 ec 10             	sub    $0x10,%esp
  8009dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e0:	53                   	push   %ebx
  8009e1:	e8 97 ff ff ff       	call   80097d <strlen>
  8009e6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	01 d8                	add    %ebx,%eax
  8009ee:	50                   	push   %eax
  8009ef:	e8 c2 ff ff ff       	call   8009b6 <strcpy>
	return dst;
}
  8009f4:	89 d8                	mov    %ebx,%eax
  8009f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	56                   	push   %esi
  8009ff:	53                   	push   %ebx
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a06:	89 c6                	mov    %eax,%esi
  800a08:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0b:	89 c2                	mov    %eax,%edx
  800a0d:	39 f2                	cmp    %esi,%edx
  800a0f:	74 11                	je     800a22 <strncpy+0x27>
		*dst++ = *src;
  800a11:	83 c2 01             	add    $0x1,%edx
  800a14:	0f b6 19             	movzbl (%ecx),%ebx
  800a17:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a1a:	80 fb 01             	cmp    $0x1,%bl
  800a1d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a20:	eb eb                	jmp    800a0d <strncpy+0x12>
	}
	return ret;
}
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a31:	8b 55 10             	mov    0x10(%ebp),%edx
  800a34:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a36:	85 d2                	test   %edx,%edx
  800a38:	74 21                	je     800a5b <strlcpy+0x35>
  800a3a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a3e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	74 14                	je     800a58 <strlcpy+0x32>
  800a44:	0f b6 19             	movzbl (%ecx),%ebx
  800a47:	84 db                	test   %bl,%bl
  800a49:	74 0b                	je     800a56 <strlcpy+0x30>
			*dst++ = *src++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	83 c2 01             	add    $0x1,%edx
  800a51:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a54:	eb ea                	jmp    800a40 <strlcpy+0x1a>
  800a56:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a58:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5b:	29 f0                	sub    %esi,%eax
}
  800a5d:	5b                   	pop    %ebx
  800a5e:	5e                   	pop    %esi
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a6a:	0f b6 01             	movzbl (%ecx),%eax
  800a6d:	84 c0                	test   %al,%al
  800a6f:	74 0c                	je     800a7d <strcmp+0x1c>
  800a71:	3a 02                	cmp    (%edx),%al
  800a73:	75 08                	jne    800a7d <strcmp+0x1c>
		p++, q++;
  800a75:	83 c1 01             	add    $0x1,%ecx
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	eb ed                	jmp    800a6a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7d:	0f b6 c0             	movzbl %al,%eax
  800a80:	0f b6 12             	movzbl (%edx),%edx
  800a83:	29 d0                	sub    %edx,%eax
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	53                   	push   %ebx
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a91:	89 c3                	mov    %eax,%ebx
  800a93:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a96:	eb 06                	jmp    800a9e <strncmp+0x17>
		n--, p++, q++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a9e:	39 d8                	cmp    %ebx,%eax
  800aa0:	74 16                	je     800ab8 <strncmp+0x31>
  800aa2:	0f b6 08             	movzbl (%eax),%ecx
  800aa5:	84 c9                	test   %cl,%cl
  800aa7:	74 04                	je     800aad <strncmp+0x26>
  800aa9:	3a 0a                	cmp    (%edx),%cl
  800aab:	74 eb                	je     800a98 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aad:	0f b6 00             	movzbl (%eax),%eax
  800ab0:	0f b6 12             	movzbl (%edx),%edx
  800ab3:	29 d0                	sub    %edx,%eax
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    
		return 0;
  800ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  800abd:	eb f6                	jmp    800ab5 <strncmp+0x2e>

00800abf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac9:	0f b6 10             	movzbl (%eax),%edx
  800acc:	84 d2                	test   %dl,%dl
  800ace:	74 09                	je     800ad9 <strchr+0x1a>
		if (*s == c)
  800ad0:	38 ca                	cmp    %cl,%dl
  800ad2:	74 0a                	je     800ade <strchr+0x1f>
	for (; *s; s++)
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	eb f0                	jmp    800ac9 <strchr+0xa>
			return (char *) s;
	return 0;
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aea:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aed:	38 ca                	cmp    %cl,%dl
  800aef:	74 09                	je     800afa <strfind+0x1a>
  800af1:	84 d2                	test   %dl,%dl
  800af3:	74 05                	je     800afa <strfind+0x1a>
	for (; *s; s++)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	eb f0                	jmp    800aea <strfind+0xa>
			break;
	return (char *) s;
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	57                   	push   %edi
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b08:	85 c9                	test   %ecx,%ecx
  800b0a:	74 31                	je     800b3d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b0c:	89 f8                	mov    %edi,%eax
  800b0e:	09 c8                	or     %ecx,%eax
  800b10:	a8 03                	test   $0x3,%al
  800b12:	75 23                	jne    800b37 <memset+0x3b>
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d0                	mov    %edx,%eax
  800b1f:	c1 e0 18             	shl    $0x18,%eax
  800b22:	89 d6                	mov    %edx,%esi
  800b24:	c1 e6 10             	shl    $0x10,%esi
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb 06                	jmp    800b3d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	39 c6                	cmp    %eax,%esi
  800b54:	73 32                	jae    800b88 <memmove+0x44>
  800b56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b59:	39 c2                	cmp    %eax,%edx
  800b5b:	76 2b                	jbe    800b88 <memmove+0x44>
		s += n;
		d += n;
  800b5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b60:	89 fe                	mov    %edi,%esi
  800b62:	09 ce                	or     %ecx,%esi
  800b64:	09 d6                	or     %edx,%esi
  800b66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6c:	75 0e                	jne    800b7c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b6e:	83 ef 04             	sub    $0x4,%edi
  800b71:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b74:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b77:	fd                   	std    
  800b78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7a:	eb 09                	jmp    800b85 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7c:	83 ef 01             	sub    $0x1,%edi
  800b7f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b82:	fd                   	std    
  800b83:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b85:	fc                   	cld    
  800b86:	eb 1a                	jmp    800ba2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b88:	89 c2                	mov    %eax,%edx
  800b8a:	09 ca                	or     %ecx,%edx
  800b8c:	09 f2                	or     %esi,%edx
  800b8e:	f6 c2 03             	test   $0x3,%dl
  800b91:	75 0a                	jne    800b9d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b93:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b96:	89 c7                	mov    %eax,%edi
  800b98:	fc                   	cld    
  800b99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9b:	eb 05                	jmp    800ba2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b9d:	89 c7                	mov    %eax,%edi
  800b9f:	fc                   	cld    
  800ba0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bac:	ff 75 10             	pushl  0x10(%ebp)
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 8a ff ff ff       	call   800b44 <memmove>
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc7:	89 c6                	mov    %eax,%esi
  800bc9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bcc:	39 f0                	cmp    %esi,%eax
  800bce:	74 1c                	je     800bec <memcmp+0x30>
		if (*s1 != *s2)
  800bd0:	0f b6 08             	movzbl (%eax),%ecx
  800bd3:	0f b6 1a             	movzbl (%edx),%ebx
  800bd6:	38 d9                	cmp    %bl,%cl
  800bd8:	75 08                	jne    800be2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	83 c2 01             	add    $0x1,%edx
  800be0:	eb ea                	jmp    800bcc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800be2:	0f b6 c1             	movzbl %cl,%eax
  800be5:	0f b6 db             	movzbl %bl,%ebx
  800be8:	29 d8                	sub    %ebx,%eax
  800bea:	eb 05                	jmp    800bf1 <memcmp+0x35>
	}

	return 0;
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c03:	39 d0                	cmp    %edx,%eax
  800c05:	73 09                	jae    800c10 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c07:	38 08                	cmp    %cl,(%eax)
  800c09:	74 05                	je     800c10 <memfind+0x1b>
	for (; s < ends; s++)
  800c0b:	83 c0 01             	add    $0x1,%eax
  800c0e:	eb f3                	jmp    800c03 <memfind+0xe>
			break;
	return (void *) s;
}
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1e:	eb 03                	jmp    800c23 <strtol+0x11>
		s++;
  800c20:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c23:	0f b6 01             	movzbl (%ecx),%eax
  800c26:	3c 20                	cmp    $0x20,%al
  800c28:	74 f6                	je     800c20 <strtol+0xe>
  800c2a:	3c 09                	cmp    $0x9,%al
  800c2c:	74 f2                	je     800c20 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c2e:	3c 2b                	cmp    $0x2b,%al
  800c30:	74 2a                	je     800c5c <strtol+0x4a>
	int neg = 0;
  800c32:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c37:	3c 2d                	cmp    $0x2d,%al
  800c39:	74 2b                	je     800c66 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c41:	75 0f                	jne    800c52 <strtol+0x40>
  800c43:	80 39 30             	cmpb   $0x30,(%ecx)
  800c46:	74 28                	je     800c70 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c48:	85 db                	test   %ebx,%ebx
  800c4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c4f:	0f 44 d8             	cmove  %eax,%ebx
  800c52:	b8 00 00 00 00       	mov    $0x0,%eax
  800c57:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c5a:	eb 50                	jmp    800cac <strtol+0x9a>
		s++;
  800c5c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c64:	eb d5                	jmp    800c3b <strtol+0x29>
		s++, neg = 1;
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	bf 01 00 00 00       	mov    $0x1,%edi
  800c6e:	eb cb                	jmp    800c3b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c70:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c74:	74 0e                	je     800c84 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c76:	85 db                	test   %ebx,%ebx
  800c78:	75 d8                	jne    800c52 <strtol+0x40>
		s++, base = 8;
  800c7a:	83 c1 01             	add    $0x1,%ecx
  800c7d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c82:	eb ce                	jmp    800c52 <strtol+0x40>
		s += 2, base = 16;
  800c84:	83 c1 02             	add    $0x2,%ecx
  800c87:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c8c:	eb c4                	jmp    800c52 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c8e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c91:	89 f3                	mov    %esi,%ebx
  800c93:	80 fb 19             	cmp    $0x19,%bl
  800c96:	77 29                	ja     800cc1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c98:	0f be d2             	movsbl %dl,%edx
  800c9b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c9e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ca1:	7d 30                	jge    800cd3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ca3:	83 c1 01             	add    $0x1,%ecx
  800ca6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800caa:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cac:	0f b6 11             	movzbl (%ecx),%edx
  800caf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cb2:	89 f3                	mov    %esi,%ebx
  800cb4:	80 fb 09             	cmp    $0x9,%bl
  800cb7:	77 d5                	ja     800c8e <strtol+0x7c>
			dig = *s - '0';
  800cb9:	0f be d2             	movsbl %dl,%edx
  800cbc:	83 ea 30             	sub    $0x30,%edx
  800cbf:	eb dd                	jmp    800c9e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cc1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cc4:	89 f3                	mov    %esi,%ebx
  800cc6:	80 fb 19             	cmp    $0x19,%bl
  800cc9:	77 08                	ja     800cd3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ccb:	0f be d2             	movsbl %dl,%edx
  800cce:	83 ea 37             	sub    $0x37,%edx
  800cd1:	eb cb                	jmp    800c9e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd7:	74 05                	je     800cde <strtol+0xcc>
		*endptr = (char *) s;
  800cd9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cdc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cde:	89 c2                	mov    %eax,%edx
  800ce0:	f7 da                	neg    %edx
  800ce2:	85 ff                	test   %edi,%edi
  800ce4:	0f 45 c2             	cmovne %edx,%eax
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	89 c3                	mov    %eax,%ebx
  800cff:	89 c7                	mov    %eax,%edi
  800d01:	89 c6                	mov    %eax,%esi
  800d03:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
  800d15:	b8 01 00 00 00       	mov    $0x1,%eax
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	89 d7                	mov    %edx,%edi
  800d20:	89 d6                	mov    %edx,%esi
  800d22:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3f:	89 cb                	mov    %ecx,%ebx
  800d41:	89 cf                	mov    %ecx,%edi
  800d43:	89 ce                	mov    %ecx,%esi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 03                	push   $0x3
  800d59:	68 e8 2f 80 00       	push   $0x802fe8
  800d5e:	6a 43                	push   $0x43
  800d60:	68 05 30 80 00       	push   $0x803005
  800d65:	e8 70 19 00 00       	call   8026da <_panic>

00800d6a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	b8 02 00 00 00       	mov    $0x2,%eax
  800d7a:	89 d1                	mov    %edx,%ecx
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	89 d7                	mov    %edx,%edi
  800d80:	89 d6                	mov    %edx,%esi
  800d82:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_yield>:

void
sys_yield(void)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d94:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d99:	89 d1                	mov    %edx,%ecx
  800d9b:	89 d3                	mov    %edx,%ebx
  800d9d:	89 d7                	mov    %edx,%edi
  800d9f:	89 d6                	mov    %edx,%esi
  800da1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
  800dae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db1:	be 00 00 00 00       	mov    $0x0,%esi
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc4:	89 f7                	mov    %esi,%edi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 04                	push   $0x4
  800dda:	68 e8 2f 80 00       	push   $0x802fe8
  800ddf:	6a 43                	push   $0x43
  800de1:	68 05 30 80 00       	push   $0x803005
  800de6:	e8 ef 18 00 00       	call   8026da <_panic>

00800deb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	b8 05 00 00 00       	mov    $0x5,%eax
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e05:	8b 75 18             	mov    0x18(%ebp),%esi
  800e08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7f 08                	jg     800e16 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e11:	5b                   	pop    %ebx
  800e12:	5e                   	pop    %esi
  800e13:	5f                   	pop    %edi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	50                   	push   %eax
  800e1a:	6a 05                	push   $0x5
  800e1c:	68 e8 2f 80 00       	push   $0x802fe8
  800e21:	6a 43                	push   $0x43
  800e23:	68 05 30 80 00       	push   $0x803005
  800e28:	e8 ad 18 00 00       	call   8026da <_panic>

00800e2d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e41:	b8 06 00 00 00       	mov    $0x6,%eax
  800e46:	89 df                	mov    %ebx,%edi
  800e48:	89 de                	mov    %ebx,%esi
  800e4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	7f 08                	jg     800e58 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e58:	83 ec 0c             	sub    $0xc,%esp
  800e5b:	50                   	push   %eax
  800e5c:	6a 06                	push   $0x6
  800e5e:	68 e8 2f 80 00       	push   $0x802fe8
  800e63:	6a 43                	push   $0x43
  800e65:	68 05 30 80 00       	push   $0x803005
  800e6a:	e8 6b 18 00 00       	call   8026da <_panic>

00800e6f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	b8 08 00 00 00       	mov    $0x8,%eax
  800e88:	89 df                	mov    %ebx,%edi
  800e8a:	89 de                	mov    %ebx,%esi
  800e8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	7f 08                	jg     800e9a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	50                   	push   %eax
  800e9e:	6a 08                	push   $0x8
  800ea0:	68 e8 2f 80 00       	push   $0x802fe8
  800ea5:	6a 43                	push   $0x43
  800ea7:	68 05 30 80 00       	push   $0x803005
  800eac:	e8 29 18 00 00       	call   8026da <_panic>

00800eb1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	b8 09 00 00 00       	mov    $0x9,%eax
  800eca:	89 df                	mov    %ebx,%edi
  800ecc:	89 de                	mov    %ebx,%esi
  800ece:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	7f 08                	jg     800edc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	50                   	push   %eax
  800ee0:	6a 09                	push   $0x9
  800ee2:	68 e8 2f 80 00       	push   $0x802fe8
  800ee7:	6a 43                	push   $0x43
  800ee9:	68 05 30 80 00       	push   $0x803005
  800eee:	e8 e7 17 00 00       	call   8026da <_panic>

00800ef3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	89 de                	mov    %ebx,%esi
  800f10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7f 08                	jg     800f1e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	50                   	push   %eax
  800f22:	6a 0a                	push   $0xa
  800f24:	68 e8 2f 80 00       	push   $0x802fe8
  800f29:	6a 43                	push   $0x43
  800f2b:	68 05 30 80 00       	push   $0x803005
  800f30:	e8 a5 17 00 00       	call   8026da <_panic>

00800f35 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f46:	be 00 00 00 00       	mov    $0x0,%esi
  800f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f51:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6e:	89 cb                	mov    %ecx,%ebx
  800f70:	89 cf                	mov    %ecx,%edi
  800f72:	89 ce                	mov    %ecx,%esi
  800f74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f76:	85 c0                	test   %eax,%eax
  800f78:	7f 08                	jg     800f82 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	50                   	push   %eax
  800f86:	6a 0d                	push   $0xd
  800f88:	68 e8 2f 80 00       	push   $0x802fe8
  800f8d:	6a 43                	push   $0x43
  800f8f:	68 05 30 80 00       	push   $0x803005
  800f94:	e8 41 17 00 00       	call   8026da <_panic>

00800f99 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faa:	b8 0e 00 00 00       	mov    $0xe,%eax
  800faf:	89 df                	mov    %ebx,%edi
  800fb1:	89 de                	mov    %ebx,%esi
  800fb3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcd:	89 cb                	mov    %ecx,%ebx
  800fcf:	89 cf                	mov    %ecx,%edi
  800fd1:	89 ce                	mov    %ecx,%esi
  800fd3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe5:	b8 10 00 00 00       	mov    $0x10,%eax
  800fea:	89 d1                	mov    %edx,%ecx
  800fec:	89 d3                	mov    %edx,%ebx
  800fee:	89 d7                	mov    %edx,%edi
  800ff0:	89 d6                	mov    %edx,%esi
  800ff2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100a:	b8 11 00 00 00       	mov    $0x11,%eax
  80100f:	89 df                	mov    %ebx,%edi
  801011:	89 de                	mov    %ebx,%esi
  801013:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	bb 00 00 00 00       	mov    $0x0,%ebx
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	b8 12 00 00 00       	mov    $0x12,%eax
  801030:	89 df                	mov    %ebx,%edi
  801032:	89 de                	mov    %ebx,%esi
  801034:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	57                   	push   %edi
  80103f:	56                   	push   %esi
  801040:	53                   	push   %ebx
  801041:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801044:	bb 00 00 00 00       	mov    $0x0,%ebx
  801049:	8b 55 08             	mov    0x8(%ebp),%edx
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	b8 13 00 00 00       	mov    $0x13,%eax
  801054:	89 df                	mov    %ebx,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105a:	85 c0                	test   %eax,%eax
  80105c:	7f 08                	jg     801066 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801066:	83 ec 0c             	sub    $0xc,%esp
  801069:	50                   	push   %eax
  80106a:	6a 13                	push   $0x13
  80106c:	68 e8 2f 80 00       	push   $0x802fe8
  801071:	6a 43                	push   $0x43
  801073:	68 05 30 80 00       	push   $0x803005
  801078:	e8 5d 16 00 00       	call   8026da <_panic>

0080107d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
	asm volatile("int %1\n"
  801083:	b9 00 00 00 00       	mov    $0x0,%ecx
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	b8 14 00 00 00       	mov    $0x14,%eax
  801090:	89 cb                	mov    %ecx,%ebx
  801092:	89 cf                	mov    %ecx,%edi
  801094:	89 ce                	mov    %ecx,%esi
  801096:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010a4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ab:	f6 c5 04             	test   $0x4,%ch
  8010ae:	75 45                	jne    8010f5 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010b0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b7:	83 e1 07             	and    $0x7,%ecx
  8010ba:	83 f9 07             	cmp    $0x7,%ecx
  8010bd:	74 6f                	je     80112e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010bf:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c6:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010cc:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010d2:	0f 84 b6 00 00 00    	je     80118e <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010d8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010df:	83 e1 05             	and    $0x5,%ecx
  8010e2:	83 f9 05             	cmp    $0x5,%ecx
  8010e5:	0f 84 d7 00 00 00    	je     8011c2 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010f5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010fc:	c1 e2 0c             	shl    $0xc,%edx
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801108:	51                   	push   %ecx
  801109:	52                   	push   %edx
  80110a:	50                   	push   %eax
  80110b:	52                   	push   %edx
  80110c:	6a 00                	push   $0x0
  80110e:	e8 d8 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  801113:	83 c4 20             	add    $0x20,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	79 d1                	jns    8010eb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	68 13 30 80 00       	push   $0x803013
  801122:	6a 54                	push   $0x54
  801124:	68 29 30 80 00       	push   $0x803029
  801129:	e8 ac 15 00 00       	call   8026da <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80112e:	89 d3                	mov    %edx,%ebx
  801130:	c1 e3 0c             	shl    $0xc,%ebx
  801133:	83 ec 0c             	sub    $0xc,%esp
  801136:	68 05 08 00 00       	push   $0x805
  80113b:	53                   	push   %ebx
  80113c:	50                   	push   %eax
  80113d:	53                   	push   %ebx
  80113e:	6a 00                	push   $0x0
  801140:	e8 a6 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  801145:	83 c4 20             	add    $0x20,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	78 2e                	js     80117a <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	68 05 08 00 00       	push   $0x805
  801154:	53                   	push   %ebx
  801155:	6a 00                	push   $0x0
  801157:	53                   	push   %ebx
  801158:	6a 00                	push   $0x0
  80115a:	e8 8c fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  80115f:	83 c4 20             	add    $0x20,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	79 85                	jns    8010eb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	68 13 30 80 00       	push   $0x803013
  80116e:	6a 5f                	push   $0x5f
  801170:	68 29 30 80 00       	push   $0x803029
  801175:	e8 60 15 00 00       	call   8026da <_panic>
			panic("sys_page_map() panic\n");
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	68 13 30 80 00       	push   $0x803013
  801182:	6a 5b                	push   $0x5b
  801184:	68 29 30 80 00       	push   $0x803029
  801189:	e8 4c 15 00 00       	call   8026da <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80118e:	c1 e2 0c             	shl    $0xc,%edx
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	68 05 08 00 00       	push   $0x805
  801199:	52                   	push   %edx
  80119a:	50                   	push   %eax
  80119b:	52                   	push   %edx
  80119c:	6a 00                	push   $0x0
  80119e:	e8 48 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  8011a3:	83 c4 20             	add    $0x20,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	0f 89 3d ff ff ff    	jns    8010eb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	68 13 30 80 00       	push   $0x803013
  8011b6:	6a 66                	push   $0x66
  8011b8:	68 29 30 80 00       	push   $0x803029
  8011bd:	e8 18 15 00 00       	call   8026da <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011c2:	c1 e2 0c             	shl    $0xc,%edx
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	6a 05                	push   $0x5
  8011ca:	52                   	push   %edx
  8011cb:	50                   	push   %eax
  8011cc:	52                   	push   %edx
  8011cd:	6a 00                	push   $0x0
  8011cf:	e8 17 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  8011d4:	83 c4 20             	add    $0x20,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	0f 89 0c ff ff ff    	jns    8010eb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 13 30 80 00       	push   $0x803013
  8011e7:	6a 6d                	push   $0x6d
  8011e9:	68 29 30 80 00       	push   $0x803029
  8011ee:	e8 e7 14 00 00       	call   8026da <_panic>

008011f3 <pgfault>:
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011fd:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ff:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801203:	0f 84 99 00 00 00    	je     8012a2 <pgfault+0xaf>
  801209:	89 c2                	mov    %eax,%edx
  80120b:	c1 ea 16             	shr    $0x16,%edx
  80120e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801215:	f6 c2 01             	test   $0x1,%dl
  801218:	0f 84 84 00 00 00    	je     8012a2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80121e:	89 c2                	mov    %eax,%edx
  801220:	c1 ea 0c             	shr    $0xc,%edx
  801223:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801230:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801236:	75 6a                	jne    8012a2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80123d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	6a 07                	push   $0x7
  801244:	68 00 f0 7f 00       	push   $0x7ff000
  801249:	6a 00                	push   $0x0
  80124b:	e8 58 fb ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	78 5f                	js     8012b6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 00 10 00 00       	push   $0x1000
  80125f:	53                   	push   %ebx
  801260:	68 00 f0 7f 00       	push   $0x7ff000
  801265:	e8 3c f9 ff ff       	call   800ba6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80126a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801271:	53                   	push   %ebx
  801272:	6a 00                	push   $0x0
  801274:	68 00 f0 7f 00       	push   $0x7ff000
  801279:	6a 00                	push   $0x0
  80127b:	e8 6b fb ff ff       	call   800deb <sys_page_map>
	if(ret < 0)
  801280:	83 c4 20             	add    $0x20,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 43                	js     8012ca <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	68 00 f0 7f 00       	push   $0x7ff000
  80128f:	6a 00                	push   $0x0
  801291:	e8 97 fb ff ff       	call   800e2d <sys_page_unmap>
	if(ret < 0)
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 41                	js     8012de <pgfault+0xeb>
}
  80129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012a2:	83 ec 04             	sub    $0x4,%esp
  8012a5:	68 34 30 80 00       	push   $0x803034
  8012aa:	6a 26                	push   $0x26
  8012ac:	68 29 30 80 00       	push   $0x803029
  8012b1:	e8 24 14 00 00       	call   8026da <_panic>
		panic("panic in sys_page_alloc()\n");
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	68 48 30 80 00       	push   $0x803048
  8012be:	6a 31                	push   $0x31
  8012c0:	68 29 30 80 00       	push   $0x803029
  8012c5:	e8 10 14 00 00       	call   8026da <_panic>
		panic("panic in sys_page_map()\n");
  8012ca:	83 ec 04             	sub    $0x4,%esp
  8012cd:	68 63 30 80 00       	push   $0x803063
  8012d2:	6a 36                	push   $0x36
  8012d4:	68 29 30 80 00       	push   $0x803029
  8012d9:	e8 fc 13 00 00       	call   8026da <_panic>
		panic("panic in sys_page_unmap()\n");
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	68 7c 30 80 00       	push   $0x80307c
  8012e6:	6a 39                	push   $0x39
  8012e8:	68 29 30 80 00       	push   $0x803029
  8012ed:	e8 e8 13 00 00       	call   8026da <_panic>

008012f2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012fb:	68 f3 11 80 00       	push   $0x8011f3
  801300:	e8 36 14 00 00       	call   80273b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801305:	b8 07 00 00 00       	mov    $0x7,%eax
  80130a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	78 27                	js     80133a <fork+0x48>
  801313:	89 c6                	mov    %eax,%esi
  801315:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801317:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80131c:	75 48                	jne    801366 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80131e:	e8 47 fa ff ff       	call   800d6a <sys_getenvid>
  801323:	25 ff 03 00 00       	and    $0x3ff,%eax
  801328:	c1 e0 07             	shl    $0x7,%eax
  80132b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801330:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801335:	e9 90 00 00 00       	jmp    8013ca <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	68 98 30 80 00       	push   $0x803098
  801342:	68 8c 00 00 00       	push   $0x8c
  801347:	68 29 30 80 00       	push   $0x803029
  80134c:	e8 89 13 00 00       	call   8026da <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801351:	89 f8                	mov    %edi,%eax
  801353:	e8 45 fd ff ff       	call   80109d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801358:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80135e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801364:	74 26                	je     80138c <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801366:	89 d8                	mov    %ebx,%eax
  801368:	c1 e8 16             	shr    $0x16,%eax
  80136b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801372:	a8 01                	test   $0x1,%al
  801374:	74 e2                	je     801358 <fork+0x66>
  801376:	89 da                	mov    %ebx,%edx
  801378:	c1 ea 0c             	shr    $0xc,%edx
  80137b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801382:	83 e0 05             	and    $0x5,%eax
  801385:	83 f8 05             	cmp    $0x5,%eax
  801388:	75 ce                	jne    801358 <fork+0x66>
  80138a:	eb c5                	jmp    801351 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	6a 07                	push   $0x7
  801391:	68 00 f0 bf ee       	push   $0xeebff000
  801396:	56                   	push   %esi
  801397:	e8 0c fa ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 31                	js     8013d4 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013a3:	83 ec 08             	sub    $0x8,%esp
  8013a6:	68 aa 27 80 00       	push   $0x8027aa
  8013ab:	56                   	push   %esi
  8013ac:	e8 42 fb ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 33                	js     8013eb <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013b8:	83 ec 08             	sub    $0x8,%esp
  8013bb:	6a 02                	push   $0x2
  8013bd:	56                   	push   %esi
  8013be:	e8 ac fa ff ff       	call   800e6f <sys_env_set_status>
	if(ret < 0)
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 38                	js     801402 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013ca:	89 f0                	mov    %esi,%eax
  8013cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cf:	5b                   	pop    %ebx
  8013d0:	5e                   	pop    %esi
  8013d1:	5f                   	pop    %edi
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	68 48 30 80 00       	push   $0x803048
  8013dc:	68 98 00 00 00       	push   $0x98
  8013e1:	68 29 30 80 00       	push   $0x803029
  8013e6:	e8 ef 12 00 00       	call   8026da <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	68 bc 30 80 00       	push   $0x8030bc
  8013f3:	68 9b 00 00 00       	push   $0x9b
  8013f8:	68 29 30 80 00       	push   $0x803029
  8013fd:	e8 d8 12 00 00       	call   8026da <_panic>
		panic("panic in sys_env_set_status()\n");
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	68 e4 30 80 00       	push   $0x8030e4
  80140a:	68 9e 00 00 00       	push   $0x9e
  80140f:	68 29 30 80 00       	push   $0x803029
  801414:	e8 c1 12 00 00       	call   8026da <_panic>

00801419 <sfork>:

// Challenge!
int
sfork(void)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801422:	68 f3 11 80 00       	push   $0x8011f3
  801427:	e8 0f 13 00 00       	call   80273b <set_pgfault_handler>
  80142c:	b8 07 00 00 00       	mov    $0x7,%eax
  801431:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 27                	js     801461 <sfork+0x48>
  80143a:	89 c7                	mov    %eax,%edi
  80143c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80143e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801443:	75 55                	jne    80149a <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801445:	e8 20 f9 ff ff       	call   800d6a <sys_getenvid>
  80144a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80144f:	c1 e0 07             	shl    $0x7,%eax
  801452:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801457:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80145c:	e9 d4 00 00 00       	jmp    801535 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 98 30 80 00       	push   $0x803098
  801469:	68 af 00 00 00       	push   $0xaf
  80146e:	68 29 30 80 00       	push   $0x803029
  801473:	e8 62 12 00 00       	call   8026da <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801478:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80147d:	89 f0                	mov    %esi,%eax
  80147f:	e8 19 fc ff ff       	call   80109d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801484:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80148a:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801490:	77 65                	ja     8014f7 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801492:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801498:	74 de                	je     801478 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	c1 e8 16             	shr    $0x16,%eax
  80149f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a6:	a8 01                	test   $0x1,%al
  8014a8:	74 da                	je     801484 <sfork+0x6b>
  8014aa:	89 da                	mov    %ebx,%edx
  8014ac:	c1 ea 0c             	shr    $0xc,%edx
  8014af:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014b6:	83 e0 05             	and    $0x5,%eax
  8014b9:	83 f8 05             	cmp    $0x5,%eax
  8014bc:	75 c6                	jne    801484 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014be:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014c5:	c1 e2 0c             	shl    $0xc,%edx
  8014c8:	83 ec 0c             	sub    $0xc,%esp
  8014cb:	83 e0 07             	and    $0x7,%eax
  8014ce:	50                   	push   %eax
  8014cf:	52                   	push   %edx
  8014d0:	56                   	push   %esi
  8014d1:	52                   	push   %edx
  8014d2:	6a 00                	push   $0x0
  8014d4:	e8 12 f9 ff ff       	call   800deb <sys_page_map>
  8014d9:	83 c4 20             	add    $0x20,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	74 a4                	je     801484 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 13 30 80 00       	push   $0x803013
  8014e8:	68 ba 00 00 00       	push   $0xba
  8014ed:	68 29 30 80 00       	push   $0x803029
  8014f2:	e8 e3 11 00 00       	call   8026da <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	6a 07                	push   $0x7
  8014fc:	68 00 f0 bf ee       	push   $0xeebff000
  801501:	57                   	push   %edi
  801502:	e8 a1 f8 ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 31                	js     80153f <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	68 aa 27 80 00       	push   $0x8027aa
  801516:	57                   	push   %edi
  801517:	e8 d7 f9 ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 33                	js     801556 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	6a 02                	push   $0x2
  801528:	57                   	push   %edi
  801529:	e8 41 f9 ff ff       	call   800e6f <sys_env_set_status>
	if(ret < 0)
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 38                	js     80156d <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801535:	89 f8                	mov    %edi,%eax
  801537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5f                   	pop    %edi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	68 48 30 80 00       	push   $0x803048
  801547:	68 c0 00 00 00       	push   $0xc0
  80154c:	68 29 30 80 00       	push   $0x803029
  801551:	e8 84 11 00 00       	call   8026da <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	68 bc 30 80 00       	push   $0x8030bc
  80155e:	68 c3 00 00 00       	push   $0xc3
  801563:	68 29 30 80 00       	push   $0x803029
  801568:	e8 6d 11 00 00       	call   8026da <_panic>
		panic("panic in sys_env_set_status()\n");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 e4 30 80 00       	push   $0x8030e4
  801575:	68 c6 00 00 00       	push   $0xc6
  80157a:	68 29 30 80 00       	push   $0x803029
  80157f:	e8 56 11 00 00       	call   8026da <_panic>

00801584 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	05 00 00 00 30       	add    $0x30000000,%eax
  80158f:	c1 e8 0c             	shr    $0xc,%eax
}
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80159f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    

008015ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	c1 ea 16             	shr    $0x16,%edx
  8015b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015bf:	f6 c2 01             	test   $0x1,%dl
  8015c2:	74 2d                	je     8015f1 <fd_alloc+0x46>
  8015c4:	89 c2                	mov    %eax,%edx
  8015c6:	c1 ea 0c             	shr    $0xc,%edx
  8015c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015d0:	f6 c2 01             	test   $0x1,%dl
  8015d3:	74 1c                	je     8015f1 <fd_alloc+0x46>
  8015d5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015da:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015df:	75 d2                	jne    8015b3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015ea:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015ef:	eb 0a                	jmp    8015fb <fd_alloc+0x50>
			*fd_store = fd;
  8015f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801603:	83 f8 1f             	cmp    $0x1f,%eax
  801606:	77 30                	ja     801638 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801608:	c1 e0 0c             	shl    $0xc,%eax
  80160b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801610:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801616:	f6 c2 01             	test   $0x1,%dl
  801619:	74 24                	je     80163f <fd_lookup+0x42>
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	c1 ea 0c             	shr    $0xc,%edx
  801620:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801627:	f6 c2 01             	test   $0x1,%dl
  80162a:	74 1a                	je     801646 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80162c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162f:	89 02                	mov    %eax,(%edx)
	return 0;
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    
		return -E_INVAL;
  801638:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163d:	eb f7                	jmp    801636 <fd_lookup+0x39>
		return -E_INVAL;
  80163f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801644:	eb f0                	jmp    801636 <fd_lookup+0x39>
  801646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164b:	eb e9                	jmp    801636 <fd_lookup+0x39>

0080164d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801656:	ba 00 00 00 00       	mov    $0x0,%edx
  80165b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801660:	39 08                	cmp    %ecx,(%eax)
  801662:	74 38                	je     80169c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801664:	83 c2 01             	add    $0x1,%edx
  801667:	8b 04 95 80 31 80 00 	mov    0x803180(,%edx,4),%eax
  80166e:	85 c0                	test   %eax,%eax
  801670:	75 ee                	jne    801660 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801672:	a1 08 50 80 00       	mov    0x805008,%eax
  801677:	8b 40 48             	mov    0x48(%eax),%eax
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	51                   	push   %ecx
  80167e:	50                   	push   %eax
  80167f:	68 04 31 80 00       	push   $0x803104
  801684:	e8 ce eb ff ff       	call   800257 <cprintf>
	*dev = 0;
  801689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    
			*dev = devtab[i];
  80169c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169f:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a6:	eb f2                	jmp    80169a <dev_lookup+0x4d>

008016a8 <fd_close>:
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	57                   	push   %edi
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 24             	sub    $0x24,%esp
  8016b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016ba:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016c1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c4:	50                   	push   %eax
  8016c5:	e8 33 ff ff ff       	call   8015fd <fd_lookup>
  8016ca:	89 c3                	mov    %eax,%ebx
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 05                	js     8016d8 <fd_close+0x30>
	    || fd != fd2)
  8016d3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016d6:	74 16                	je     8016ee <fd_close+0x46>
		return (must_exist ? r : 0);
  8016d8:	89 f8                	mov    %edi,%eax
  8016da:	84 c0                	test   %al,%al
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	0f 44 d8             	cmove  %eax,%ebx
}
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5e                   	pop    %esi
  8016eb:	5f                   	pop    %edi
  8016ec:	5d                   	pop    %ebp
  8016ed:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	ff 36                	pushl  (%esi)
  8016f7:	e8 51 ff ff ff       	call   80164d <dev_lookup>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 1a                	js     80171f <fd_close+0x77>
		if (dev->dev_close)
  801705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801708:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80170b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801710:	85 c0                	test   %eax,%eax
  801712:	74 0b                	je     80171f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	56                   	push   %esi
  801718:	ff d0                	call   *%eax
  80171a:	89 c3                	mov    %eax,%ebx
  80171c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	56                   	push   %esi
  801723:	6a 00                	push   $0x0
  801725:	e8 03 f7 ff ff       	call   800e2d <sys_page_unmap>
	return r;
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	eb b5                	jmp    8016e4 <fd_close+0x3c>

0080172f <close>:

int
close(int fdnum)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801735:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	ff 75 08             	pushl  0x8(%ebp)
  80173c:	e8 bc fe ff ff       	call   8015fd <fd_lookup>
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	85 c0                	test   %eax,%eax
  801746:	79 02                	jns    80174a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    
		return fd_close(fd, 1);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	6a 01                	push   $0x1
  80174f:	ff 75 f4             	pushl  -0xc(%ebp)
  801752:	e8 51 ff ff ff       	call   8016a8 <fd_close>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	eb ec                	jmp    801748 <close+0x19>

0080175c <close_all>:

void
close_all(void)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	53                   	push   %ebx
  801760:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801763:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801768:	83 ec 0c             	sub    $0xc,%esp
  80176b:	53                   	push   %ebx
  80176c:	e8 be ff ff ff       	call   80172f <close>
	for (i = 0; i < MAXFD; i++)
  801771:	83 c3 01             	add    $0x1,%ebx
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	83 fb 20             	cmp    $0x20,%ebx
  80177a:	75 ec                	jne    801768 <close_all+0xc>
}
  80177c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	57                   	push   %edi
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80178a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80178d:	50                   	push   %eax
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 67 fe ff ff       	call   8015fd <fd_lookup>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	0f 88 81 00 00 00    	js     801824 <dup+0xa3>
		return r;
	close(newfdnum);
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 81 ff ff ff       	call   80172f <close>

	newfd = INDEX2FD(newfdnum);
  8017ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b1:	c1 e6 0c             	shl    $0xc,%esi
  8017b4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017ba:	83 c4 04             	add    $0x4,%esp
  8017bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c0:	e8 cf fd ff ff       	call   801594 <fd2data>
  8017c5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017c7:	89 34 24             	mov    %esi,(%esp)
  8017ca:	e8 c5 fd ff ff       	call   801594 <fd2data>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	c1 e8 16             	shr    $0x16,%eax
  8017d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e0:	a8 01                	test   $0x1,%al
  8017e2:	74 11                	je     8017f5 <dup+0x74>
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	c1 e8 0c             	shr    $0xc,%eax
  8017e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017f0:	f6 c2 01             	test   $0x1,%dl
  8017f3:	75 39                	jne    80182e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017f8:	89 d0                	mov    %edx,%eax
  8017fa:	c1 e8 0c             	shr    $0xc,%eax
  8017fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	25 07 0e 00 00       	and    $0xe07,%eax
  80180c:	50                   	push   %eax
  80180d:	56                   	push   %esi
  80180e:	6a 00                	push   $0x0
  801810:	52                   	push   %edx
  801811:	6a 00                	push   $0x0
  801813:	e8 d3 f5 ff ff       	call   800deb <sys_page_map>
  801818:	89 c3                	mov    %eax,%ebx
  80181a:	83 c4 20             	add    $0x20,%esp
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 31                	js     801852 <dup+0xd1>
		goto err;

	return newfdnum;
  801821:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801824:	89 d8                	mov    %ebx,%eax
  801826:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5f                   	pop    %edi
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80182e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	25 07 0e 00 00       	and    $0xe07,%eax
  80183d:	50                   	push   %eax
  80183e:	57                   	push   %edi
  80183f:	6a 00                	push   $0x0
  801841:	53                   	push   %ebx
  801842:	6a 00                	push   $0x0
  801844:	e8 a2 f5 ff ff       	call   800deb <sys_page_map>
  801849:	89 c3                	mov    %eax,%ebx
  80184b:	83 c4 20             	add    $0x20,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	79 a3                	jns    8017f5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	56                   	push   %esi
  801856:	6a 00                	push   $0x0
  801858:	e8 d0 f5 ff ff       	call   800e2d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80185d:	83 c4 08             	add    $0x8,%esp
  801860:	57                   	push   %edi
  801861:	6a 00                	push   $0x0
  801863:	e8 c5 f5 ff ff       	call   800e2d <sys_page_unmap>
	return r;
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	eb b7                	jmp    801824 <dup+0xa3>

0080186d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	53                   	push   %ebx
  801871:	83 ec 1c             	sub    $0x1c,%esp
  801874:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801877:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187a:	50                   	push   %eax
  80187b:	53                   	push   %ebx
  80187c:	e8 7c fd ff ff       	call   8015fd <fd_lookup>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	78 3f                	js     8018c7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801888:	83 ec 08             	sub    $0x8,%esp
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	50                   	push   %eax
  80188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801892:	ff 30                	pushl  (%eax)
  801894:	e8 b4 fd ff ff       	call   80164d <dev_lookup>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 27                	js     8018c7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a3:	8b 42 08             	mov    0x8(%edx),%eax
  8018a6:	83 e0 03             	and    $0x3,%eax
  8018a9:	83 f8 01             	cmp    $0x1,%eax
  8018ac:	74 1e                	je     8018cc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b1:	8b 40 08             	mov    0x8(%eax),%eax
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	74 35                	je     8018ed <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	ff 75 10             	pushl  0x10(%ebp)
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	52                   	push   %edx
  8018c2:	ff d0                	call   *%eax
  8018c4:	83 c4 10             	add    $0x10,%esp
}
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018cc:	a1 08 50 80 00       	mov    0x805008,%eax
  8018d1:	8b 40 48             	mov    0x48(%eax),%eax
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	53                   	push   %ebx
  8018d8:	50                   	push   %eax
  8018d9:	68 45 31 80 00       	push   $0x803145
  8018de:	e8 74 e9 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018eb:	eb da                	jmp    8018c7 <read+0x5a>
		return -E_NOT_SUPP;
  8018ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f2:	eb d3                	jmp    8018c7 <read+0x5a>

008018f4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	57                   	push   %edi
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 0c             	sub    $0xc,%esp
  8018fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801900:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801903:	bb 00 00 00 00       	mov    $0x0,%ebx
  801908:	39 f3                	cmp    %esi,%ebx
  80190a:	73 23                	jae    80192f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	89 f0                	mov    %esi,%eax
  801911:	29 d8                	sub    %ebx,%eax
  801913:	50                   	push   %eax
  801914:	89 d8                	mov    %ebx,%eax
  801916:	03 45 0c             	add    0xc(%ebp),%eax
  801919:	50                   	push   %eax
  80191a:	57                   	push   %edi
  80191b:	e8 4d ff ff ff       	call   80186d <read>
		if (m < 0)
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	78 06                	js     80192d <readn+0x39>
			return m;
		if (m == 0)
  801927:	74 06                	je     80192f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801929:	01 c3                	add    %eax,%ebx
  80192b:	eb db                	jmp    801908 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80192d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5f                   	pop    %edi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    

00801939 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	53                   	push   %ebx
  80193d:	83 ec 1c             	sub    $0x1c,%esp
  801940:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801943:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801946:	50                   	push   %eax
  801947:	53                   	push   %ebx
  801948:	e8 b0 fc ff ff       	call   8015fd <fd_lookup>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	78 3a                	js     80198e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195a:	50                   	push   %eax
  80195b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195e:	ff 30                	pushl  (%eax)
  801960:	e8 e8 fc ff ff       	call   80164d <dev_lookup>
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 22                	js     80198e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801973:	74 1e                	je     801993 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801978:	8b 52 0c             	mov    0xc(%edx),%edx
  80197b:	85 d2                	test   %edx,%edx
  80197d:	74 35                	je     8019b4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	ff d2                	call   *%edx
  80198b:	83 c4 10             	add    $0x10,%esp
}
  80198e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801991:	c9                   	leave  
  801992:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801993:	a1 08 50 80 00       	mov    0x805008,%eax
  801998:	8b 40 48             	mov    0x48(%eax),%eax
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	53                   	push   %ebx
  80199f:	50                   	push   %eax
  8019a0:	68 61 31 80 00       	push   $0x803161
  8019a5:	e8 ad e8 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019b2:	eb da                	jmp    80198e <write+0x55>
		return -E_NOT_SUPP;
  8019b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b9:	eb d3                	jmp    80198e <write+0x55>

008019bb <seek>:

int
seek(int fdnum, off_t offset)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 30 fc ff ff       	call   8015fd <fd_lookup>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 0e                	js     8019e2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 1c             	sub    $0x1c,%esp
  8019eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	53                   	push   %ebx
  8019f3:	e8 05 fc ff ff       	call   8015fd <fd_lookup>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 37                	js     801a36 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a05:	50                   	push   %eax
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	ff 30                	pushl  (%eax)
  801a0b:	e8 3d fc ff ff       	call   80164d <dev_lookup>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 1f                	js     801a36 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a1e:	74 1b                	je     801a3b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a23:	8b 52 18             	mov    0x18(%edx),%edx
  801a26:	85 d2                	test   %edx,%edx
  801a28:	74 32                	je     801a5c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	ff d2                	call   *%edx
  801a33:	83 c4 10             	add    $0x10,%esp
}
  801a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a3b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a40:	8b 40 48             	mov    0x48(%eax),%eax
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	53                   	push   %ebx
  801a47:	50                   	push   %eax
  801a48:	68 24 31 80 00       	push   $0x803124
  801a4d:	e8 05 e8 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5a:	eb da                	jmp    801a36 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a61:	eb d3                	jmp    801a36 <ftruncate+0x52>

00801a63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 1c             	sub    $0x1c,%esp
  801a6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a70:	50                   	push   %eax
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	e8 84 fb ff ff       	call   8015fd <fd_lookup>
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 4b                	js     801acb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a86:	50                   	push   %eax
  801a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8a:	ff 30                	pushl  (%eax)
  801a8c:	e8 bc fb ff ff       	call   80164d <dev_lookup>
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 33                	js     801acb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a9f:	74 2f                	je     801ad0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aa1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aa4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aab:	00 00 00 
	stat->st_isdir = 0;
  801aae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab5:	00 00 00 
	stat->st_dev = dev;
  801ab8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	53                   	push   %ebx
  801ac2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac5:	ff 50 14             	call   *0x14(%eax)
  801ac8:	83 c4 10             	add    $0x10,%esp
}
  801acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad5:	eb f4                	jmp    801acb <fstat+0x68>

00801ad7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 22 02 00 00       	call   801d0b <open>
  801ae9:	89 c3                	mov    %eax,%ebx
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 1b                	js     801b0d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	50                   	push   %eax
  801af9:	e8 65 ff ff ff       	call   801a63 <fstat>
  801afe:	89 c6                	mov    %eax,%esi
	close(fd);
  801b00:	89 1c 24             	mov    %ebx,(%esp)
  801b03:	e8 27 fc ff ff       	call   80172f <close>
	return r;
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	89 f3                	mov    %esi,%ebx
}
  801b0d:	89 d8                	mov    %ebx,%eax
  801b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b12:	5b                   	pop    %ebx
  801b13:	5e                   	pop    %esi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	89 c6                	mov    %eax,%esi
  801b1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b1f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b26:	74 27                	je     801b4f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b28:	6a 07                	push   $0x7
  801b2a:	68 00 60 80 00       	push   $0x806000
  801b2f:	56                   	push   %esi
  801b30:	ff 35 00 50 80 00    	pushl  0x805000
  801b36:	e8 fe 0c 00 00       	call   802839 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b3b:	83 c4 0c             	add    $0xc,%esp
  801b3e:	6a 00                	push   $0x0
  801b40:	53                   	push   %ebx
  801b41:	6a 00                	push   $0x0
  801b43:	e8 88 0c 00 00       	call   8027d0 <ipc_recv>
}
  801b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	6a 01                	push   $0x1
  801b54:	e8 38 0d 00 00       	call   802891 <ipc_find_env>
  801b59:	a3 00 50 80 00       	mov    %eax,0x805000
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	eb c5                	jmp    801b28 <fsipc+0x12>

00801b63 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b77:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	b8 02 00 00 00       	mov    $0x2,%eax
  801b86:	e8 8b ff ff ff       	call   801b16 <fsipc>
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <devfile_flush>:
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	8b 40 0c             	mov    0xc(%eax),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba3:	b8 06 00 00 00       	mov    $0x6,%eax
  801ba8:	e8 69 ff ff ff       	call   801b16 <fsipc>
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <devfile_stat>:
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	53                   	push   %ebx
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bbf:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bce:	e8 43 ff ff ff       	call   801b16 <fsipc>
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 2c                	js     801c03 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bd7:	83 ec 08             	sub    $0x8,%esp
  801bda:	68 00 60 80 00       	push   $0x806000
  801bdf:	53                   	push   %ebx
  801be0:	e8 d1 ed ff ff       	call   8009b6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801be5:	a1 80 60 80 00       	mov    0x806080,%eax
  801bea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bf0:	a1 84 60 80 00       	mov    0x806084,%eax
  801bf5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <devfile_write>:
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8b 40 0c             	mov    0xc(%eax),%eax
  801c18:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c1d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c23:	53                   	push   %ebx
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	68 08 60 80 00       	push   $0x806008
  801c2c:	e8 75 ef ff ff       	call   800ba6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c31:	ba 00 00 00 00       	mov    $0x0,%edx
  801c36:	b8 04 00 00 00       	mov    $0x4,%eax
  801c3b:	e8 d6 fe ff ff       	call   801b16 <fsipc>
  801c40:	83 c4 10             	add    $0x10,%esp
  801c43:	85 c0                	test   %eax,%eax
  801c45:	78 0b                	js     801c52 <devfile_write+0x4a>
	assert(r <= n);
  801c47:	39 d8                	cmp    %ebx,%eax
  801c49:	77 0c                	ja     801c57 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c4b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c50:	7f 1e                	jg     801c70 <devfile_write+0x68>
}
  801c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    
	assert(r <= n);
  801c57:	68 94 31 80 00       	push   $0x803194
  801c5c:	68 9b 31 80 00       	push   $0x80319b
  801c61:	68 98 00 00 00       	push   $0x98
  801c66:	68 b0 31 80 00       	push   $0x8031b0
  801c6b:	e8 6a 0a 00 00       	call   8026da <_panic>
	assert(r <= PGSIZE);
  801c70:	68 bb 31 80 00       	push   $0x8031bb
  801c75:	68 9b 31 80 00       	push   $0x80319b
  801c7a:	68 99 00 00 00       	push   $0x99
  801c7f:	68 b0 31 80 00       	push   $0x8031b0
  801c84:	e8 51 0a 00 00       	call   8026da <_panic>

00801c89 <devfile_read>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	8b 40 0c             	mov    0xc(%eax),%eax
  801c97:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c9c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	b8 03 00 00 00       	mov    $0x3,%eax
  801cac:	e8 65 fe ff ff       	call   801b16 <fsipc>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 1f                	js     801cd6 <devfile_read+0x4d>
	assert(r <= n);
  801cb7:	39 f0                	cmp    %esi,%eax
  801cb9:	77 24                	ja     801cdf <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cbb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc0:	7f 33                	jg     801cf5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	50                   	push   %eax
  801cc6:	68 00 60 80 00       	push   $0x806000
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	e8 71 ee ff ff       	call   800b44 <memmove>
	return r;
  801cd3:	83 c4 10             	add    $0x10,%esp
}
  801cd6:	89 d8                	mov    %ebx,%eax
  801cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    
	assert(r <= n);
  801cdf:	68 94 31 80 00       	push   $0x803194
  801ce4:	68 9b 31 80 00       	push   $0x80319b
  801ce9:	6a 7c                	push   $0x7c
  801ceb:	68 b0 31 80 00       	push   $0x8031b0
  801cf0:	e8 e5 09 00 00       	call   8026da <_panic>
	assert(r <= PGSIZE);
  801cf5:	68 bb 31 80 00       	push   $0x8031bb
  801cfa:	68 9b 31 80 00       	push   $0x80319b
  801cff:	6a 7d                	push   $0x7d
  801d01:	68 b0 31 80 00       	push   $0x8031b0
  801d06:	e8 cf 09 00 00       	call   8026da <_panic>

00801d0b <open>:
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 1c             	sub    $0x1c,%esp
  801d13:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d16:	56                   	push   %esi
  801d17:	e8 61 ec ff ff       	call   80097d <strlen>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d24:	7f 6c                	jg     801d92 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2c:	50                   	push   %eax
  801d2d:	e8 79 f8 ff ff       	call   8015ab <fd_alloc>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 3c                	js     801d77 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	56                   	push   %esi
  801d3f:	68 00 60 80 00       	push   $0x806000
  801d44:	e8 6d ec ff ff       	call   8009b6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d54:	b8 01 00 00 00       	mov    $0x1,%eax
  801d59:	e8 b8 fd ff ff       	call   801b16 <fsipc>
  801d5e:	89 c3                	mov    %eax,%ebx
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 19                	js     801d80 <open+0x75>
	return fd2num(fd);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6d:	e8 12 f8 ff ff       	call   801584 <fd2num>
  801d72:	89 c3                	mov    %eax,%ebx
  801d74:	83 c4 10             	add    $0x10,%esp
}
  801d77:	89 d8                	mov    %ebx,%eax
  801d79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    
		fd_close(fd, 0);
  801d80:	83 ec 08             	sub    $0x8,%esp
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 f4             	pushl  -0xc(%ebp)
  801d88:	e8 1b f9 ff ff       	call   8016a8 <fd_close>
		return r;
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	eb e5                	jmp    801d77 <open+0x6c>
		return -E_BAD_PATH;
  801d92:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d97:	eb de                	jmp    801d77 <open+0x6c>

00801d99 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801da4:	b8 08 00 00 00       	mov    $0x8,%eax
  801da9:	e8 68 fd ff ff       	call   801b16 <fsipc>
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801db6:	68 c7 31 80 00       	push   $0x8031c7
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	e8 f3 eb ff ff       	call   8009b6 <strcpy>
	return 0;
}
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <devsock_close>:
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 10             	sub    $0x10,%esp
  801dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dd4:	53                   	push   %ebx
  801dd5:	e8 f2 0a 00 00       	call   8028cc <pageref>
  801dda:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ddd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801de2:	83 f8 01             	cmp    $0x1,%eax
  801de5:	74 07                	je     801dee <devsock_close+0x24>
}
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	ff 73 0c             	pushl  0xc(%ebx)
  801df4:	e8 b9 02 00 00       	call   8020b2 <nsipc_close>
  801df9:	89 c2                	mov    %eax,%edx
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	eb e7                	jmp    801de7 <devsock_close+0x1d>

00801e00 <devsock_write>:
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	ff 75 10             	pushl  0x10(%ebp)
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	ff 70 0c             	pushl  0xc(%eax)
  801e14:	e8 76 03 00 00       	call   80218f <nsipc_send>
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <devsock_read>:
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	ff 70 0c             	pushl  0xc(%eax)
  801e2f:	e8 ef 02 00 00       	call   802123 <nsipc_recv>
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <fd2sockid>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e3c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	e8 b7 f7 ff ff       	call   8015fd <fd_lookup>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	78 10                	js     801e5d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e56:	39 08                	cmp    %ecx,(%eax)
  801e58:	75 05                	jne    801e5f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e5a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    
		return -E_NOT_SUPP;
  801e5f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e64:	eb f7                	jmp    801e5d <fd2sockid+0x27>

00801e66 <alloc_sockfd>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	56                   	push   %esi
  801e6a:	53                   	push   %ebx
  801e6b:	83 ec 1c             	sub    $0x1c,%esp
  801e6e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e73:	50                   	push   %eax
  801e74:	e8 32 f7 ff ff       	call   8015ab <fd_alloc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 43                	js     801ec5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 07 04 00 00       	push   $0x407
  801e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8d:	6a 00                	push   $0x0
  801e8f:	e8 14 ef ff ff       	call   800da8 <sys_page_alloc>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 28                	js     801ec5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ea6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801eb2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	50                   	push   %eax
  801eb9:	e8 c6 f6 ff ff       	call   801584 <fd2num>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	eb 0c                	jmp    801ed1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	56                   	push   %esi
  801ec9:	e8 e4 01 00 00       	call   8020b2 <nsipc_close>
		return r;
  801ece:	83 c4 10             	add    $0x10,%esp
}
  801ed1:	89 d8                	mov    %ebx,%eax
  801ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <accept>:
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	e8 4e ff ff ff       	call   801e36 <fd2sockid>
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 1b                	js     801f07 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	50                   	push   %eax
  801ef6:	e8 0e 01 00 00       	call   802009 <nsipc_accept>
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 05                	js     801f07 <accept+0x2d>
	return alloc_sockfd(r);
  801f02:	e8 5f ff ff ff       	call   801e66 <alloc_sockfd>
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <bind>:
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	e8 1f ff ff ff       	call   801e36 <fd2sockid>
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 12                	js     801f2d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	ff 75 10             	pushl  0x10(%ebp)
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	50                   	push   %eax
  801f25:	e8 31 01 00 00       	call   80205b <nsipc_bind>
  801f2a:	83 c4 10             	add    $0x10,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <shutdown>:
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	e8 f9 fe ff ff       	call   801e36 <fd2sockid>
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 0f                	js     801f50 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f41:	83 ec 08             	sub    $0x8,%esp
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	50                   	push   %eax
  801f48:	e8 43 01 00 00       	call   802090 <nsipc_shutdown>
  801f4d:	83 c4 10             	add    $0x10,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <connect>:
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	e8 d6 fe ff ff       	call   801e36 <fd2sockid>
  801f60:	85 c0                	test   %eax,%eax
  801f62:	78 12                	js     801f76 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	ff 75 10             	pushl  0x10(%ebp)
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	50                   	push   %eax
  801f6e:	e8 59 01 00 00       	call   8020cc <nsipc_connect>
  801f73:	83 c4 10             	add    $0x10,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <listen>:
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	e8 b0 fe ff ff       	call   801e36 <fd2sockid>
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 0f                	js     801f99 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f8a:	83 ec 08             	sub    $0x8,%esp
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	50                   	push   %eax
  801f91:	e8 6b 01 00 00       	call   802101 <nsipc_listen>
  801f96:	83 c4 10             	add    $0x10,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <socket>:

int
socket(int domain, int type, int protocol)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fa1:	ff 75 10             	pushl  0x10(%ebp)
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	ff 75 08             	pushl  0x8(%ebp)
  801faa:	e8 3e 02 00 00       	call   8021ed <nsipc_socket>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 05                	js     801fbb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fb6:	e8 ab fe ff ff       	call   801e66 <alloc_sockfd>
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	53                   	push   %ebx
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fc6:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fcd:	74 26                	je     801ff5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fcf:	6a 07                	push   $0x7
  801fd1:	68 00 70 80 00       	push   $0x807000
  801fd6:	53                   	push   %ebx
  801fd7:	ff 35 04 50 80 00    	pushl  0x805004
  801fdd:	e8 57 08 00 00       	call   802839 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fe2:	83 c4 0c             	add    $0xc,%esp
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 e0 07 00 00       	call   8027d0 <ipc_recv>
}
  801ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	6a 02                	push   $0x2
  801ffa:	e8 92 08 00 00       	call   802891 <ipc_find_env>
  801fff:	a3 04 50 80 00       	mov    %eax,0x805004
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	eb c6                	jmp    801fcf <nsipc+0x12>

00802009 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802019:	8b 06                	mov    (%esi),%eax
  80201b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802020:	b8 01 00 00 00       	mov    $0x1,%eax
  802025:	e8 93 ff ff ff       	call   801fbd <nsipc>
  80202a:	89 c3                	mov    %eax,%ebx
  80202c:	85 c0                	test   %eax,%eax
  80202e:	79 09                	jns    802039 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802030:	89 d8                	mov    %ebx,%eax
  802032:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5d                   	pop    %ebp
  802038:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	ff 35 10 70 80 00    	pushl  0x807010
  802042:	68 00 70 80 00       	push   $0x807000
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	e8 f5 ea ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  80204f:	a1 10 70 80 00       	mov    0x807010,%eax
  802054:	89 06                	mov    %eax,(%esi)
  802056:	83 c4 10             	add    $0x10,%esp
	return r;
  802059:	eb d5                	jmp    802030 <nsipc_accept+0x27>

0080205b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	53                   	push   %ebx
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80206d:	53                   	push   %ebx
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	68 04 70 80 00       	push   $0x807004
  802076:	e8 c9 ea ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80207b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802081:	b8 02 00 00 00       	mov    $0x2,%eax
  802086:	e8 32 ff ff ff       	call   801fbd <nsipc>
}
  80208b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8020ab:	e8 0d ff ff ff       	call   801fbd <nsipc>
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <nsipc_close>:

int
nsipc_close(int s)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8020c5:	e8 f3 fe ff ff       	call   801fbd <nsipc>
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 08             	sub    $0x8,%esp
  8020d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020de:	53                   	push   %ebx
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	68 04 70 80 00       	push   $0x807004
  8020e7:	e8 58 ea ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ec:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8020f7:	e8 c1 fe ff ff       	call   801fbd <nsipc>
}
  8020fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80210f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802112:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802117:	b8 06 00 00 00       	mov    $0x6,%eax
  80211c:	e8 9c fe ff ff       	call   801fbd <nsipc>
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802133:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802139:	8b 45 14             	mov    0x14(%ebp),%eax
  80213c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802141:	b8 07 00 00 00       	mov    $0x7,%eax
  802146:	e8 72 fe ff ff       	call   801fbd <nsipc>
  80214b:	89 c3                	mov    %eax,%ebx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 1f                	js     802170 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802151:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802156:	7f 21                	jg     802179 <nsipc_recv+0x56>
  802158:	39 c6                	cmp    %eax,%esi
  80215a:	7c 1d                	jl     802179 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	50                   	push   %eax
  802160:	68 00 70 80 00       	push   $0x807000
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	e8 d7 e9 ff ff       	call   800b44 <memmove>
  80216d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802170:	89 d8                	mov    %ebx,%eax
  802172:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802175:	5b                   	pop    %ebx
  802176:	5e                   	pop    %esi
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802179:	68 d3 31 80 00       	push   $0x8031d3
  80217e:	68 9b 31 80 00       	push   $0x80319b
  802183:	6a 62                	push   $0x62
  802185:	68 e8 31 80 00       	push   $0x8031e8
  80218a:	e8 4b 05 00 00       	call   8026da <_panic>

0080218f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	53                   	push   %ebx
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021a1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021a7:	7f 2e                	jg     8021d7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	53                   	push   %ebx
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	68 0c 70 80 00       	push   $0x80700c
  8021b5:	e8 8a e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  8021ba:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8021cd:	e8 eb fd ff ff       	call   801fbd <nsipc>
}
  8021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    
	assert(size < 1600);
  8021d7:	68 f4 31 80 00       	push   $0x8031f4
  8021dc:	68 9b 31 80 00       	push   $0x80319b
  8021e1:	6a 6d                	push   $0x6d
  8021e3:	68 e8 31 80 00       	push   $0x8031e8
  8021e8:	e8 ed 04 00 00       	call   8026da <_panic>

008021ed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fe:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802203:	8b 45 10             	mov    0x10(%ebp),%eax
  802206:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80220b:	b8 09 00 00 00       	mov    $0x9,%eax
  802210:	e8 a8 fd ff ff       	call   801fbd <nsipc>
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	e8 6a f3 ff ff       	call   801594 <fd2data>
  80222a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80222c:	83 c4 08             	add    $0x8,%esp
  80222f:	68 00 32 80 00       	push   $0x803200
  802234:	53                   	push   %ebx
  802235:	e8 7c e7 ff ff       	call   8009b6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80223a:	8b 46 04             	mov    0x4(%esi),%eax
  80223d:	2b 06                	sub    (%esi),%eax
  80223f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802245:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80224c:	00 00 00 
	stat->st_dev = &devpipe;
  80224f:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802256:	40 80 00 
	return 0;
}
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
  80225e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    

00802265 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	53                   	push   %ebx
  802269:	83 ec 0c             	sub    $0xc,%esp
  80226c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80226f:	53                   	push   %ebx
  802270:	6a 00                	push   $0x0
  802272:	e8 b6 eb ff ff       	call   800e2d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802277:	89 1c 24             	mov    %ebx,(%esp)
  80227a:	e8 15 f3 ff ff       	call   801594 <fd2data>
  80227f:	83 c4 08             	add    $0x8,%esp
  802282:	50                   	push   %eax
  802283:	6a 00                	push   $0x0
  802285:	e8 a3 eb ff ff       	call   800e2d <sys_page_unmap>
}
  80228a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <_pipeisclosed>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	57                   	push   %edi
  802293:	56                   	push   %esi
  802294:	53                   	push   %ebx
  802295:	83 ec 1c             	sub    $0x1c,%esp
  802298:	89 c7                	mov    %eax,%edi
  80229a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80229c:	a1 08 50 80 00       	mov    0x805008,%eax
  8022a1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	57                   	push   %edi
  8022a8:	e8 1f 06 00 00       	call   8028cc <pageref>
  8022ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022b0:	89 34 24             	mov    %esi,(%esp)
  8022b3:	e8 14 06 00 00       	call   8028cc <pageref>
		nn = thisenv->env_runs;
  8022b8:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8022be:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	39 cb                	cmp    %ecx,%ebx
  8022c6:	74 1b                	je     8022e3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022cb:	75 cf                	jne    80229c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022cd:	8b 42 58             	mov    0x58(%edx),%eax
  8022d0:	6a 01                	push   $0x1
  8022d2:	50                   	push   %eax
  8022d3:	53                   	push   %ebx
  8022d4:	68 07 32 80 00       	push   $0x803207
  8022d9:	e8 79 df ff ff       	call   800257 <cprintf>
  8022de:	83 c4 10             	add    $0x10,%esp
  8022e1:	eb b9                	jmp    80229c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022e3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022e6:	0f 94 c0             	sete   %al
  8022e9:	0f b6 c0             	movzbl %al,%eax
}
  8022ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    

008022f4 <devpipe_write>:
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	57                   	push   %edi
  8022f8:	56                   	push   %esi
  8022f9:	53                   	push   %ebx
  8022fa:	83 ec 28             	sub    $0x28,%esp
  8022fd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802300:	56                   	push   %esi
  802301:	e8 8e f2 ff ff       	call   801594 <fd2data>
  802306:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802308:	83 c4 10             	add    $0x10,%esp
  80230b:	bf 00 00 00 00       	mov    $0x0,%edi
  802310:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802313:	74 4f                	je     802364 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802315:	8b 43 04             	mov    0x4(%ebx),%eax
  802318:	8b 0b                	mov    (%ebx),%ecx
  80231a:	8d 51 20             	lea    0x20(%ecx),%edx
  80231d:	39 d0                	cmp    %edx,%eax
  80231f:	72 14                	jb     802335 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802321:	89 da                	mov    %ebx,%edx
  802323:	89 f0                	mov    %esi,%eax
  802325:	e8 65 ff ff ff       	call   80228f <_pipeisclosed>
  80232a:	85 c0                	test   %eax,%eax
  80232c:	75 3b                	jne    802369 <devpipe_write+0x75>
			sys_yield();
  80232e:	e8 56 ea ff ff       	call   800d89 <sys_yield>
  802333:	eb e0                	jmp    802315 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802338:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80233c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80233f:	89 c2                	mov    %eax,%edx
  802341:	c1 fa 1f             	sar    $0x1f,%edx
  802344:	89 d1                	mov    %edx,%ecx
  802346:	c1 e9 1b             	shr    $0x1b,%ecx
  802349:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80234c:	83 e2 1f             	and    $0x1f,%edx
  80234f:	29 ca                	sub    %ecx,%edx
  802351:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802355:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802359:	83 c0 01             	add    $0x1,%eax
  80235c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80235f:	83 c7 01             	add    $0x1,%edi
  802362:	eb ac                	jmp    802310 <devpipe_write+0x1c>
	return i;
  802364:	8b 45 10             	mov    0x10(%ebp),%eax
  802367:	eb 05                	jmp    80236e <devpipe_write+0x7a>
				return 0;
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    

00802376 <devpipe_read>:
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	57                   	push   %edi
  80237a:	56                   	push   %esi
  80237b:	53                   	push   %ebx
  80237c:	83 ec 18             	sub    $0x18,%esp
  80237f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802382:	57                   	push   %edi
  802383:	e8 0c f2 ff ff       	call   801594 <fd2data>
  802388:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	be 00 00 00 00       	mov    $0x0,%esi
  802392:	3b 75 10             	cmp    0x10(%ebp),%esi
  802395:	75 14                	jne    8023ab <devpipe_read+0x35>
	return i;
  802397:	8b 45 10             	mov    0x10(%ebp),%eax
  80239a:	eb 02                	jmp    80239e <devpipe_read+0x28>
				return i;
  80239c:	89 f0                	mov    %esi,%eax
}
  80239e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
			sys_yield();
  8023a6:	e8 de e9 ff ff       	call   800d89 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023ab:	8b 03                	mov    (%ebx),%eax
  8023ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023b0:	75 18                	jne    8023ca <devpipe_read+0x54>
			if (i > 0)
  8023b2:	85 f6                	test   %esi,%esi
  8023b4:	75 e6                	jne    80239c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023b6:	89 da                	mov    %ebx,%edx
  8023b8:	89 f8                	mov    %edi,%eax
  8023ba:	e8 d0 fe ff ff       	call   80228f <_pipeisclosed>
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 e3                	je     8023a6 <devpipe_read+0x30>
				return 0;
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	eb d4                	jmp    80239e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023ca:	99                   	cltd   
  8023cb:	c1 ea 1b             	shr    $0x1b,%edx
  8023ce:	01 d0                	add    %edx,%eax
  8023d0:	83 e0 1f             	and    $0x1f,%eax
  8023d3:	29 d0                	sub    %edx,%eax
  8023d5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023dd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023e0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023e3:	83 c6 01             	add    $0x1,%esi
  8023e6:	eb aa                	jmp    802392 <devpipe_read+0x1c>

008023e8 <pipe>:
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f3:	50                   	push   %eax
  8023f4:	e8 b2 f1 ff ff       	call   8015ab <fd_alloc>
  8023f9:	89 c3                	mov    %eax,%ebx
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	85 c0                	test   %eax,%eax
  802400:	0f 88 23 01 00 00    	js     802529 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	68 07 04 00 00       	push   $0x407
  80240e:	ff 75 f4             	pushl  -0xc(%ebp)
  802411:	6a 00                	push   $0x0
  802413:	e8 90 e9 ff ff       	call   800da8 <sys_page_alloc>
  802418:	89 c3                	mov    %eax,%ebx
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	85 c0                	test   %eax,%eax
  80241f:	0f 88 04 01 00 00    	js     802529 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802425:	83 ec 0c             	sub    $0xc,%esp
  802428:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80242b:	50                   	push   %eax
  80242c:	e8 7a f1 ff ff       	call   8015ab <fd_alloc>
  802431:	89 c3                	mov    %eax,%ebx
  802433:	83 c4 10             	add    $0x10,%esp
  802436:	85 c0                	test   %eax,%eax
  802438:	0f 88 db 00 00 00    	js     802519 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	68 07 04 00 00       	push   $0x407
  802446:	ff 75 f0             	pushl  -0x10(%ebp)
  802449:	6a 00                	push   $0x0
  80244b:	e8 58 e9 ff ff       	call   800da8 <sys_page_alloc>
  802450:	89 c3                	mov    %eax,%ebx
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	85 c0                	test   %eax,%eax
  802457:	0f 88 bc 00 00 00    	js     802519 <pipe+0x131>
	va = fd2data(fd0);
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	ff 75 f4             	pushl  -0xc(%ebp)
  802463:	e8 2c f1 ff ff       	call   801594 <fd2data>
  802468:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246a:	83 c4 0c             	add    $0xc,%esp
  80246d:	68 07 04 00 00       	push   $0x407
  802472:	50                   	push   %eax
  802473:	6a 00                	push   $0x0
  802475:	e8 2e e9 ff ff       	call   800da8 <sys_page_alloc>
  80247a:	89 c3                	mov    %eax,%ebx
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	85 c0                	test   %eax,%eax
  802481:	0f 88 82 00 00 00    	js     802509 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	ff 75 f0             	pushl  -0x10(%ebp)
  80248d:	e8 02 f1 ff ff       	call   801594 <fd2data>
  802492:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802499:	50                   	push   %eax
  80249a:	6a 00                	push   $0x0
  80249c:	56                   	push   %esi
  80249d:	6a 00                	push   $0x0
  80249f:	e8 47 e9 ff ff       	call   800deb <sys_page_map>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	83 c4 20             	add    $0x20,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	78 4e                	js     8024fb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024ad:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d6:	e8 a9 f0 ff ff       	call   801584 <fd2num>
  8024db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024de:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024e0:	83 c4 04             	add    $0x4,%esp
  8024e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e6:	e8 99 f0 ff ff       	call   801584 <fd2num>
  8024eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ee:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024f9:	eb 2e                	jmp    802529 <pipe+0x141>
	sys_page_unmap(0, va);
  8024fb:	83 ec 08             	sub    $0x8,%esp
  8024fe:	56                   	push   %esi
  8024ff:	6a 00                	push   $0x0
  802501:	e8 27 e9 ff ff       	call   800e2d <sys_page_unmap>
  802506:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802509:	83 ec 08             	sub    $0x8,%esp
  80250c:	ff 75 f0             	pushl  -0x10(%ebp)
  80250f:	6a 00                	push   $0x0
  802511:	e8 17 e9 ff ff       	call   800e2d <sys_page_unmap>
  802516:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802519:	83 ec 08             	sub    $0x8,%esp
  80251c:	ff 75 f4             	pushl  -0xc(%ebp)
  80251f:	6a 00                	push   $0x0
  802521:	e8 07 e9 ff ff       	call   800e2d <sys_page_unmap>
  802526:	83 c4 10             	add    $0x10,%esp
}
  802529:	89 d8                	mov    %ebx,%eax
  80252b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252e:	5b                   	pop    %ebx
  80252f:	5e                   	pop    %esi
  802530:	5d                   	pop    %ebp
  802531:	c3                   	ret    

00802532 <pipeisclosed>:
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 08             	pushl  0x8(%ebp)
  80253f:	e8 b9 f0 ff ff       	call   8015fd <fd_lookup>
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	78 18                	js     802563 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	ff 75 f4             	pushl  -0xc(%ebp)
  802551:	e8 3e f0 ff ff       	call   801594 <fd2data>
	return _pipeisclosed(fd, p);
  802556:	89 c2                	mov    %eax,%edx
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	e8 2f fd ff ff       	call   80228f <_pipeisclosed>
  802560:	83 c4 10             	add    $0x10,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	c3                   	ret    

0080256b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802571:	68 1f 32 80 00       	push   $0x80321f
  802576:	ff 75 0c             	pushl  0xc(%ebp)
  802579:	e8 38 e4 ff ff       	call   8009b6 <strcpy>
	return 0;
}
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <devcons_write>:
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	57                   	push   %edi
  802589:	56                   	push   %esi
  80258a:	53                   	push   %ebx
  80258b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802591:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802596:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80259c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80259f:	73 31                	jae    8025d2 <devcons_write+0x4d>
		m = n - tot;
  8025a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025a4:	29 f3                	sub    %esi,%ebx
  8025a6:	83 fb 7f             	cmp    $0x7f,%ebx
  8025a9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025ae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025b1:	83 ec 04             	sub    $0x4,%esp
  8025b4:	53                   	push   %ebx
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	03 45 0c             	add    0xc(%ebp),%eax
  8025ba:	50                   	push   %eax
  8025bb:	57                   	push   %edi
  8025bc:	e8 83 e5 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  8025c1:	83 c4 08             	add    $0x8,%esp
  8025c4:	53                   	push   %ebx
  8025c5:	57                   	push   %edi
  8025c6:	e8 21 e7 ff ff       	call   800cec <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025cb:	01 de                	add    %ebx,%esi
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	eb ca                	jmp    80259c <devcons_write+0x17>
}
  8025d2:	89 f0                	mov    %esi,%eax
  8025d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025d7:	5b                   	pop    %ebx
  8025d8:	5e                   	pop    %esi
  8025d9:	5f                   	pop    %edi
  8025da:	5d                   	pop    %ebp
  8025db:	c3                   	ret    

008025dc <devcons_read>:
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 08             	sub    $0x8,%esp
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025eb:	74 21                	je     80260e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025ed:	e8 18 e7 ff ff       	call   800d0a <sys_cgetc>
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	75 07                	jne    8025fd <devcons_read+0x21>
		sys_yield();
  8025f6:	e8 8e e7 ff ff       	call   800d89 <sys_yield>
  8025fb:	eb f0                	jmp    8025ed <devcons_read+0x11>
	if (c < 0)
  8025fd:	78 0f                	js     80260e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025ff:	83 f8 04             	cmp    $0x4,%eax
  802602:	74 0c                	je     802610 <devcons_read+0x34>
	*(char*)vbuf = c;
  802604:	8b 55 0c             	mov    0xc(%ebp),%edx
  802607:	88 02                	mov    %al,(%edx)
	return 1;
  802609:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    
		return 0;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	eb f7                	jmp    80260e <devcons_read+0x32>

00802617 <cputchar>:
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802623:	6a 01                	push   $0x1
  802625:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802628:	50                   	push   %eax
  802629:	e8 be e6 ff ff       	call   800cec <sys_cputs>
}
  80262e:	83 c4 10             	add    $0x10,%esp
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <getchar>:
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802639:	6a 01                	push   $0x1
  80263b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80263e:	50                   	push   %eax
  80263f:	6a 00                	push   $0x0
  802641:	e8 27 f2 ff ff       	call   80186d <read>
	if (r < 0)
  802646:	83 c4 10             	add    $0x10,%esp
  802649:	85 c0                	test   %eax,%eax
  80264b:	78 06                	js     802653 <getchar+0x20>
	if (r < 1)
  80264d:	74 06                	je     802655 <getchar+0x22>
	return c;
  80264f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    
		return -E_EOF;
  802655:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80265a:	eb f7                	jmp    802653 <getchar+0x20>

0080265c <iscons>:
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802662:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802665:	50                   	push   %eax
  802666:	ff 75 08             	pushl  0x8(%ebp)
  802669:	e8 8f ef ff ff       	call   8015fd <fd_lookup>
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	85 c0                	test   %eax,%eax
  802673:	78 11                	js     802686 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80267e:	39 10                	cmp    %edx,(%eax)
  802680:	0f 94 c0             	sete   %al
  802683:	0f b6 c0             	movzbl %al,%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <opencons>:
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80268e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802691:	50                   	push   %eax
  802692:	e8 14 ef ff ff       	call   8015ab <fd_alloc>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	85 c0                	test   %eax,%eax
  80269c:	78 3a                	js     8026d8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 07 04 00 00       	push   $0x407
  8026a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a9:	6a 00                	push   $0x0
  8026ab:	e8 f8 e6 ff ff       	call   800da8 <sys_page_alloc>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	78 21                	js     8026d8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026c0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	50                   	push   %eax
  8026d0:	e8 af ee ff ff       	call   801584 <fd2num>
  8026d5:	83 c4 10             	add    $0x10,%esp
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	56                   	push   %esi
  8026de:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8026df:	a1 08 50 80 00       	mov    0x805008,%eax
  8026e4:	8b 40 48             	mov    0x48(%eax),%eax
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 50 32 80 00       	push   $0x803250
  8026ef:	50                   	push   %eax
  8026f0:	68 4e 2c 80 00       	push   $0x802c4e
  8026f5:	e8 5d db ff ff       	call   800257 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8026fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026fd:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802703:	e8 62 e6 ff ff       	call   800d6a <sys_getenvid>
  802708:	83 c4 04             	add    $0x4,%esp
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	ff 75 08             	pushl  0x8(%ebp)
  802711:	56                   	push   %esi
  802712:	50                   	push   %eax
  802713:	68 2c 32 80 00       	push   $0x80322c
  802718:	e8 3a db ff ff       	call   800257 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80271d:	83 c4 18             	add    $0x18,%esp
  802720:	53                   	push   %ebx
  802721:	ff 75 10             	pushl  0x10(%ebp)
  802724:	e8 dd da ff ff       	call   800206 <vcprintf>
	cprintf("\n");
  802729:	c7 04 24 12 2c 80 00 	movl   $0x802c12,(%esp)
  802730:	e8 22 db ff ff       	call   800257 <cprintf>
  802735:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802738:	cc                   	int3   
  802739:	eb fd                	jmp    802738 <_panic+0x5e>

0080273b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802741:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802748:	74 0a                	je     802754 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	6a 07                	push   $0x7
  802759:	68 00 f0 bf ee       	push   $0xeebff000
  80275e:	6a 00                	push   $0x0
  802760:	e8 43 e6 ff ff       	call   800da8 <sys_page_alloc>
		if(r < 0)
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	85 c0                	test   %eax,%eax
  80276a:	78 2a                	js     802796 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80276c:	83 ec 08             	sub    $0x8,%esp
  80276f:	68 aa 27 80 00       	push   $0x8027aa
  802774:	6a 00                	push   $0x0
  802776:	e8 78 e7 ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80277b:	83 c4 10             	add    $0x10,%esp
  80277e:	85 c0                	test   %eax,%eax
  802780:	79 c8                	jns    80274a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 88 32 80 00       	push   $0x803288
  80278a:	6a 25                	push   $0x25
  80278c:	68 c4 32 80 00       	push   $0x8032c4
  802791:	e8 44 ff ff ff       	call   8026da <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 58 32 80 00       	push   $0x803258
  80279e:	6a 22                	push   $0x22
  8027a0:	68 c4 32 80 00       	push   $0x8032c4
  8027a5:	e8 30 ff ff ff       	call   8026da <_panic>

008027aa <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027aa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027ab:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027b0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027b2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027b5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027b9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027bd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027c0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027c2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027c6:	83 c4 08             	add    $0x8,%esp
	popal
  8027c9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027ca:	83 c4 04             	add    $0x4,%esp
	popfl
  8027cd:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027ce:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027cf:	c3                   	ret    

008027d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	56                   	push   %esi
  8027d4:	53                   	push   %ebx
  8027d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027de:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027e0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027e5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027e8:	83 ec 0c             	sub    $0xc,%esp
  8027eb:	50                   	push   %eax
  8027ec:	e8 67 e7 ff ff       	call   800f58 <sys_ipc_recv>
	if(ret < 0){
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	78 2b                	js     802823 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027f8:	85 f6                	test   %esi,%esi
  8027fa:	74 0a                	je     802806 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8027fc:	a1 08 50 80 00       	mov    0x805008,%eax
  802801:	8b 40 74             	mov    0x74(%eax),%eax
  802804:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802806:	85 db                	test   %ebx,%ebx
  802808:	74 0a                	je     802814 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80280a:	a1 08 50 80 00       	mov    0x805008,%eax
  80280f:	8b 40 78             	mov    0x78(%eax),%eax
  802812:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802814:	a1 08 50 80 00       	mov    0x805008,%eax
  802819:	8b 40 70             	mov    0x70(%eax),%eax
}
  80281c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80281f:	5b                   	pop    %ebx
  802820:	5e                   	pop    %esi
  802821:	5d                   	pop    %ebp
  802822:	c3                   	ret    
		if(from_env_store)
  802823:	85 f6                	test   %esi,%esi
  802825:	74 06                	je     80282d <ipc_recv+0x5d>
			*from_env_store = 0;
  802827:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80282d:	85 db                	test   %ebx,%ebx
  80282f:	74 eb                	je     80281c <ipc_recv+0x4c>
			*perm_store = 0;
  802831:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802837:	eb e3                	jmp    80281c <ipc_recv+0x4c>

00802839 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	57                   	push   %edi
  80283d:	56                   	push   %esi
  80283e:	53                   	push   %ebx
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	8b 7d 08             	mov    0x8(%ebp),%edi
  802845:	8b 75 0c             	mov    0xc(%ebp),%esi
  802848:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80284b:	85 db                	test   %ebx,%ebx
  80284d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802852:	0f 44 d8             	cmove  %eax,%ebx
  802855:	eb 05                	jmp    80285c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802857:	e8 2d e5 ff ff       	call   800d89 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80285c:	ff 75 14             	pushl  0x14(%ebp)
  80285f:	53                   	push   %ebx
  802860:	56                   	push   %esi
  802861:	57                   	push   %edi
  802862:	e8 ce e6 ff ff       	call   800f35 <sys_ipc_try_send>
  802867:	83 c4 10             	add    $0x10,%esp
  80286a:	85 c0                	test   %eax,%eax
  80286c:	74 1b                	je     802889 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80286e:	79 e7                	jns    802857 <ipc_send+0x1e>
  802870:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802873:	74 e2                	je     802857 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 d2 32 80 00       	push   $0x8032d2
  80287d:	6a 46                	push   $0x46
  80287f:	68 e7 32 80 00       	push   $0x8032e7
  802884:	e8 51 fe ff ff       	call   8026da <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802889:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80288c:	5b                   	pop    %ebx
  80288d:	5e                   	pop    %esi
  80288e:	5f                   	pop    %edi
  80288f:	5d                   	pop    %ebp
  802890:	c3                   	ret    

00802891 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80289c:	89 c2                	mov    %eax,%edx
  80289e:	c1 e2 07             	shl    $0x7,%edx
  8028a1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028a7:	8b 52 50             	mov    0x50(%edx),%edx
  8028aa:	39 ca                	cmp    %ecx,%edx
  8028ac:	74 11                	je     8028bf <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028ae:	83 c0 01             	add    $0x1,%eax
  8028b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028b6:	75 e4                	jne    80289c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bd:	eb 0b                	jmp    8028ca <ipc_find_env+0x39>
			return envs[i].env_id;
  8028bf:	c1 e0 07             	shl    $0x7,%eax
  8028c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028c7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028ca:	5d                   	pop    %ebp
  8028cb:	c3                   	ret    

008028cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028d2:	89 d0                	mov    %edx,%eax
  8028d4:	c1 e8 16             	shr    $0x16,%eax
  8028d7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028e3:	f6 c1 01             	test   $0x1,%cl
  8028e6:	74 1d                	je     802905 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028e8:	c1 ea 0c             	shr    $0xc,%edx
  8028eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028f2:	f6 c2 01             	test   $0x1,%dl
  8028f5:	74 0e                	je     802905 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028f7:	c1 ea 0c             	shr    $0xc,%edx
  8028fa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802901:	ef 
  802902:	0f b7 c0             	movzwl %ax,%eax
}
  802905:	5d                   	pop    %ebp
  802906:	c3                   	ret    
  802907:	66 90                	xchg   %ax,%ax
  802909:	66 90                	xchg   %ax,%ax
  80290b:	66 90                	xchg   %ax,%ax
  80290d:	66 90                	xchg   %ax,%ax
  80290f:	90                   	nop

00802910 <__udivdi3>:
  802910:	55                   	push   %ebp
  802911:	57                   	push   %edi
  802912:	56                   	push   %esi
  802913:	53                   	push   %ebx
  802914:	83 ec 1c             	sub    $0x1c,%esp
  802917:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80291b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80291f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802923:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802927:	85 d2                	test   %edx,%edx
  802929:	75 4d                	jne    802978 <__udivdi3+0x68>
  80292b:	39 f3                	cmp    %esi,%ebx
  80292d:	76 19                	jbe    802948 <__udivdi3+0x38>
  80292f:	31 ff                	xor    %edi,%edi
  802931:	89 e8                	mov    %ebp,%eax
  802933:	89 f2                	mov    %esi,%edx
  802935:	f7 f3                	div    %ebx
  802937:	89 fa                	mov    %edi,%edx
  802939:	83 c4 1c             	add    $0x1c,%esp
  80293c:	5b                   	pop    %ebx
  80293d:	5e                   	pop    %esi
  80293e:	5f                   	pop    %edi
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	89 d9                	mov    %ebx,%ecx
  80294a:	85 db                	test   %ebx,%ebx
  80294c:	75 0b                	jne    802959 <__udivdi3+0x49>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	31 d2                	xor    %edx,%edx
  802955:	f7 f3                	div    %ebx
  802957:	89 c1                	mov    %eax,%ecx
  802959:	31 d2                	xor    %edx,%edx
  80295b:	89 f0                	mov    %esi,%eax
  80295d:	f7 f1                	div    %ecx
  80295f:	89 c6                	mov    %eax,%esi
  802961:	89 e8                	mov    %ebp,%eax
  802963:	89 f7                	mov    %esi,%edi
  802965:	f7 f1                	div    %ecx
  802967:	89 fa                	mov    %edi,%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802978:	39 f2                	cmp    %esi,%edx
  80297a:	77 1c                	ja     802998 <__udivdi3+0x88>
  80297c:	0f bd fa             	bsr    %edx,%edi
  80297f:	83 f7 1f             	xor    $0x1f,%edi
  802982:	75 2c                	jne    8029b0 <__udivdi3+0xa0>
  802984:	39 f2                	cmp    %esi,%edx
  802986:	72 06                	jb     80298e <__udivdi3+0x7e>
  802988:	31 c0                	xor    %eax,%eax
  80298a:	39 eb                	cmp    %ebp,%ebx
  80298c:	77 a9                	ja     802937 <__udivdi3+0x27>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	eb a2                	jmp    802937 <__udivdi3+0x27>
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	31 ff                	xor    %edi,%edi
  80299a:	31 c0                	xor    %eax,%eax
  80299c:	89 fa                	mov    %edi,%edx
  80299e:	83 c4 1c             	add    $0x1c,%esp
  8029a1:	5b                   	pop    %ebx
  8029a2:	5e                   	pop    %esi
  8029a3:	5f                   	pop    %edi
  8029a4:	5d                   	pop    %ebp
  8029a5:	c3                   	ret    
  8029a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ad:	8d 76 00             	lea    0x0(%esi),%esi
  8029b0:	89 f9                	mov    %edi,%ecx
  8029b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029b7:	29 f8                	sub    %edi,%eax
  8029b9:	d3 e2                	shl    %cl,%edx
  8029bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029bf:	89 c1                	mov    %eax,%ecx
  8029c1:	89 da                	mov    %ebx,%edx
  8029c3:	d3 ea                	shr    %cl,%edx
  8029c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029c9:	09 d1                	or     %edx,%ecx
  8029cb:	89 f2                	mov    %esi,%edx
  8029cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029d1:	89 f9                	mov    %edi,%ecx
  8029d3:	d3 e3                	shl    %cl,%ebx
  8029d5:	89 c1                	mov    %eax,%ecx
  8029d7:	d3 ea                	shr    %cl,%edx
  8029d9:	89 f9                	mov    %edi,%ecx
  8029db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029df:	89 eb                	mov    %ebp,%ebx
  8029e1:	d3 e6                	shl    %cl,%esi
  8029e3:	89 c1                	mov    %eax,%ecx
  8029e5:	d3 eb                	shr    %cl,%ebx
  8029e7:	09 de                	or     %ebx,%esi
  8029e9:	89 f0                	mov    %esi,%eax
  8029eb:	f7 74 24 08          	divl   0x8(%esp)
  8029ef:	89 d6                	mov    %edx,%esi
  8029f1:	89 c3                	mov    %eax,%ebx
  8029f3:	f7 64 24 0c          	mull   0xc(%esp)
  8029f7:	39 d6                	cmp    %edx,%esi
  8029f9:	72 15                	jb     802a10 <__udivdi3+0x100>
  8029fb:	89 f9                	mov    %edi,%ecx
  8029fd:	d3 e5                	shl    %cl,%ebp
  8029ff:	39 c5                	cmp    %eax,%ebp
  802a01:	73 04                	jae    802a07 <__udivdi3+0xf7>
  802a03:	39 d6                	cmp    %edx,%esi
  802a05:	74 09                	je     802a10 <__udivdi3+0x100>
  802a07:	89 d8                	mov    %ebx,%eax
  802a09:	31 ff                	xor    %edi,%edi
  802a0b:	e9 27 ff ff ff       	jmp    802937 <__udivdi3+0x27>
  802a10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a13:	31 ff                	xor    %edi,%edi
  802a15:	e9 1d ff ff ff       	jmp    802937 <__udivdi3+0x27>
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <__umoddi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
  802a24:	83 ec 1c             	sub    $0x1c,%esp
  802a27:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a2f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a37:	89 da                	mov    %ebx,%edx
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	75 43                	jne    802a80 <__umoddi3+0x60>
  802a3d:	39 df                	cmp    %ebx,%edi
  802a3f:	76 17                	jbe    802a58 <__umoddi3+0x38>
  802a41:	89 f0                	mov    %esi,%eax
  802a43:	f7 f7                	div    %edi
  802a45:	89 d0                	mov    %edx,%eax
  802a47:	31 d2                	xor    %edx,%edx
  802a49:	83 c4 1c             	add    $0x1c,%esp
  802a4c:	5b                   	pop    %ebx
  802a4d:	5e                   	pop    %esi
  802a4e:	5f                   	pop    %edi
  802a4f:	5d                   	pop    %ebp
  802a50:	c3                   	ret    
  802a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a58:	89 fd                	mov    %edi,%ebp
  802a5a:	85 ff                	test   %edi,%edi
  802a5c:	75 0b                	jne    802a69 <__umoddi3+0x49>
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	31 d2                	xor    %edx,%edx
  802a65:	f7 f7                	div    %edi
  802a67:	89 c5                	mov    %eax,%ebp
  802a69:	89 d8                	mov    %ebx,%eax
  802a6b:	31 d2                	xor    %edx,%edx
  802a6d:	f7 f5                	div    %ebp
  802a6f:	89 f0                	mov    %esi,%eax
  802a71:	f7 f5                	div    %ebp
  802a73:	89 d0                	mov    %edx,%eax
  802a75:	eb d0                	jmp    802a47 <__umoddi3+0x27>
  802a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a7e:	66 90                	xchg   %ax,%ax
  802a80:	89 f1                	mov    %esi,%ecx
  802a82:	39 d8                	cmp    %ebx,%eax
  802a84:	76 0a                	jbe    802a90 <__umoddi3+0x70>
  802a86:	89 f0                	mov    %esi,%eax
  802a88:	83 c4 1c             	add    $0x1c,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
  802a90:	0f bd e8             	bsr    %eax,%ebp
  802a93:	83 f5 1f             	xor    $0x1f,%ebp
  802a96:	75 20                	jne    802ab8 <__umoddi3+0x98>
  802a98:	39 d8                	cmp    %ebx,%eax
  802a9a:	0f 82 b0 00 00 00    	jb     802b50 <__umoddi3+0x130>
  802aa0:	39 f7                	cmp    %esi,%edi
  802aa2:	0f 86 a8 00 00 00    	jbe    802b50 <__umoddi3+0x130>
  802aa8:	89 c8                	mov    %ecx,%eax
  802aaa:	83 c4 1c             	add    $0x1c,%esp
  802aad:	5b                   	pop    %ebx
  802aae:	5e                   	pop    %esi
  802aaf:	5f                   	pop    %edi
  802ab0:	5d                   	pop    %ebp
  802ab1:	c3                   	ret    
  802ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ab8:	89 e9                	mov    %ebp,%ecx
  802aba:	ba 20 00 00 00       	mov    $0x20,%edx
  802abf:	29 ea                	sub    %ebp,%edx
  802ac1:	d3 e0                	shl    %cl,%eax
  802ac3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ac7:	89 d1                	mov    %edx,%ecx
  802ac9:	89 f8                	mov    %edi,%eax
  802acb:	d3 e8                	shr    %cl,%eax
  802acd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ad1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ad5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ad9:	09 c1                	or     %eax,%ecx
  802adb:	89 d8                	mov    %ebx,%eax
  802add:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae1:	89 e9                	mov    %ebp,%ecx
  802ae3:	d3 e7                	shl    %cl,%edi
  802ae5:	89 d1                	mov    %edx,%ecx
  802ae7:	d3 e8                	shr    %cl,%eax
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aef:	d3 e3                	shl    %cl,%ebx
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	89 d1                	mov    %edx,%ecx
  802af5:	89 f0                	mov    %esi,%eax
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 fa                	mov    %edi,%edx
  802afd:	d3 e6                	shl    %cl,%esi
  802aff:	09 d8                	or     %ebx,%eax
  802b01:	f7 74 24 08          	divl   0x8(%esp)
  802b05:	89 d1                	mov    %edx,%ecx
  802b07:	89 f3                	mov    %esi,%ebx
  802b09:	f7 64 24 0c          	mull   0xc(%esp)
  802b0d:	89 c6                	mov    %eax,%esi
  802b0f:	89 d7                	mov    %edx,%edi
  802b11:	39 d1                	cmp    %edx,%ecx
  802b13:	72 06                	jb     802b1b <__umoddi3+0xfb>
  802b15:	75 10                	jne    802b27 <__umoddi3+0x107>
  802b17:	39 c3                	cmp    %eax,%ebx
  802b19:	73 0c                	jae    802b27 <__umoddi3+0x107>
  802b1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b23:	89 d7                	mov    %edx,%edi
  802b25:	89 c6                	mov    %eax,%esi
  802b27:	89 ca                	mov    %ecx,%edx
  802b29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b2e:	29 f3                	sub    %esi,%ebx
  802b30:	19 fa                	sbb    %edi,%edx
  802b32:	89 d0                	mov    %edx,%eax
  802b34:	d3 e0                	shl    %cl,%eax
  802b36:	89 e9                	mov    %ebp,%ecx
  802b38:	d3 eb                	shr    %cl,%ebx
  802b3a:	d3 ea                	shr    %cl,%edx
  802b3c:	09 d8                	or     %ebx,%eax
  802b3e:	83 c4 1c             	add    $0x1c,%esp
  802b41:	5b                   	pop    %ebx
  802b42:	5e                   	pop    %esi
  802b43:	5f                   	pop    %edi
  802b44:	5d                   	pop    %ebp
  802b45:	c3                   	ret    
  802b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	89 da                	mov    %ebx,%edx
  802b52:	29 fe                	sub    %edi,%esi
  802b54:	19 c2                	sbb    %eax,%edx
  802b56:	89 f1                	mov    %esi,%ecx
  802b58:	89 c8                	mov    %ecx,%eax
  802b5a:	e9 4b ff ff ff       	jmp    802aaa <__umoddi3+0x8a>
