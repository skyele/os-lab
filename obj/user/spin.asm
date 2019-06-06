
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
  80003a:	68 40 2b 80 00       	push   $0x802b40
  80003f:	e8 13 02 00 00       	call   800257 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 89 12 00 00       	call   8012d2 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 b8 2b 80 00       	push   $0x802bb8
  800058:	e8 fa 01 00 00       	call   800257 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 68 2b 80 00       	push   $0x802b68
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
  800099:	c7 04 24 90 2b 80 00 	movl   $0x802b90,(%esp)
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
  800138:	68 d6 2b 80 00       	push   $0x802bd6
  80013d:	e8 15 01 00 00       	call   800257 <cprintf>
	cprintf("before umain\n");
  800142:	c7 04 24 f4 2b 80 00 	movl   $0x802bf4,(%esp)
  800149:	e8 09 01 00 00       	call   800257 <cprintf>
	// call user main routine
	umain(argc, argv);
  80014e:	83 c4 08             	add    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 d7 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80015c:	c7 04 24 02 2c 80 00 	movl   $0x802c02,(%esp)
  800163:	e8 ef 00 00 00       	call   800257 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800168:	a1 08 50 80 00       	mov    0x805008,%eax
  80016d:	8b 40 48             	mov    0x48(%eax),%eax
  800170:	83 c4 08             	add    $0x8,%esp
  800173:	50                   	push   %eax
  800174:	68 0f 2c 80 00       	push   $0x802c0f
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
  80019c:	68 3c 2c 80 00       	push   $0x802c3c
  8001a1:	50                   	push   %eax
  8001a2:	68 2e 2c 80 00       	push   $0x802c2e
  8001a7:	e8 ab 00 00 00       	call   800257 <cprintf>
	close_all();
  8001ac:	e8 8b 15 00 00       	call   80173c <close_all>
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
  800304:	e8 e7 25 00 00       	call   8028f0 <__udivdi3>
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
  80032d:	e8 ce 26 00 00       	call   802a00 <__umoddi3>
  800332:	83 c4 14             	add    $0x14,%esp
  800335:	0f be 80 41 2c 80 00 	movsbl 0x802c41(%eax),%eax
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
  8003de:	ff 24 85 20 2e 80 00 	jmp    *0x802e20(,%eax,4)
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
  8004a9:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 18                	je     8004cc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004b4:	52                   	push   %edx
  8004b5:	68 8d 31 80 00       	push   $0x80318d
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 a6 fe ff ff       	call   800367 <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c7:	e9 fe 02 00 00       	jmp    8007ca <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 59 2c 80 00       	push   $0x802c59
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
  8004f4:	b8 52 2c 80 00       	mov    $0x802c52,%eax
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
  80088c:	bf 75 2d 80 00       	mov    $0x802d75,%edi
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
  8008b8:	bf ad 2d 80 00       	mov    $0x802dad,%edi
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
  800d59:	68 c8 2f 80 00       	push   $0x802fc8
  800d5e:	6a 43                	push   $0x43
  800d60:	68 e5 2f 80 00       	push   $0x802fe5
  800d65:	e8 50 19 00 00       	call   8026ba <_panic>

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
  800dda:	68 c8 2f 80 00       	push   $0x802fc8
  800ddf:	6a 43                	push   $0x43
  800de1:	68 e5 2f 80 00       	push   $0x802fe5
  800de6:	e8 cf 18 00 00       	call   8026ba <_panic>

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
  800e1c:	68 c8 2f 80 00       	push   $0x802fc8
  800e21:	6a 43                	push   $0x43
  800e23:	68 e5 2f 80 00       	push   $0x802fe5
  800e28:	e8 8d 18 00 00       	call   8026ba <_panic>

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
  800e5e:	68 c8 2f 80 00       	push   $0x802fc8
  800e63:	6a 43                	push   $0x43
  800e65:	68 e5 2f 80 00       	push   $0x802fe5
  800e6a:	e8 4b 18 00 00       	call   8026ba <_panic>

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
  800ea0:	68 c8 2f 80 00       	push   $0x802fc8
  800ea5:	6a 43                	push   $0x43
  800ea7:	68 e5 2f 80 00       	push   $0x802fe5
  800eac:	e8 09 18 00 00       	call   8026ba <_panic>

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
  800ee2:	68 c8 2f 80 00       	push   $0x802fc8
  800ee7:	6a 43                	push   $0x43
  800ee9:	68 e5 2f 80 00       	push   $0x802fe5
  800eee:	e8 c7 17 00 00       	call   8026ba <_panic>

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
  800f24:	68 c8 2f 80 00       	push   $0x802fc8
  800f29:	6a 43                	push   $0x43
  800f2b:	68 e5 2f 80 00       	push   $0x802fe5
  800f30:	e8 85 17 00 00       	call   8026ba <_panic>

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
  800f88:	68 c8 2f 80 00       	push   $0x802fc8
  800f8d:	6a 43                	push   $0x43
  800f8f:	68 e5 2f 80 00       	push   $0x802fe5
  800f94:	e8 21 17 00 00       	call   8026ba <_panic>

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
  80106c:	68 c8 2f 80 00       	push   $0x802fc8
  801071:	6a 43                	push   $0x43
  801073:	68 e5 2f 80 00       	push   $0x802fe5
  801078:	e8 3d 16 00 00       	call   8026ba <_panic>

0080107d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	53                   	push   %ebx
  801081:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801084:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80108b:	f6 c5 04             	test   $0x4,%ch
  80108e:	75 45                	jne    8010d5 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801090:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801097:	83 e1 07             	and    $0x7,%ecx
  80109a:	83 f9 07             	cmp    $0x7,%ecx
  80109d:	74 6f                	je     80110e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80109f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010a6:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010ac:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010b2:	0f 84 b6 00 00 00    	je     80116e <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010b8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010bf:	83 e1 05             	and    $0x5,%ecx
  8010c2:	83 f9 05             	cmp    $0x5,%ecx
  8010c5:	0f 84 d7 00 00 00    	je     8011a2 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010d5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010dc:	c1 e2 0c             	shl    $0xc,%edx
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010e8:	51                   	push   %ecx
  8010e9:	52                   	push   %edx
  8010ea:	50                   	push   %eax
  8010eb:	52                   	push   %edx
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 f8 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  8010f3:	83 c4 20             	add    $0x20,%esp
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	79 d1                	jns    8010cb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	68 f3 2f 80 00       	push   $0x802ff3
  801102:	6a 54                	push   $0x54
  801104:	68 09 30 80 00       	push   $0x803009
  801109:	e8 ac 15 00 00       	call   8026ba <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80110e:	89 d3                	mov    %edx,%ebx
  801110:	c1 e3 0c             	shl    $0xc,%ebx
  801113:	83 ec 0c             	sub    $0xc,%esp
  801116:	68 05 08 00 00       	push   $0x805
  80111b:	53                   	push   %ebx
  80111c:	50                   	push   %eax
  80111d:	53                   	push   %ebx
  80111e:	6a 00                	push   $0x0
  801120:	e8 c6 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  801125:	83 c4 20             	add    $0x20,%esp
  801128:	85 c0                	test   %eax,%eax
  80112a:	78 2e                	js     80115a <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	68 05 08 00 00       	push   $0x805
  801134:	53                   	push   %ebx
  801135:	6a 00                	push   $0x0
  801137:	53                   	push   %ebx
  801138:	6a 00                	push   $0x0
  80113a:	e8 ac fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  80113f:	83 c4 20             	add    $0x20,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	79 85                	jns    8010cb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801146:	83 ec 04             	sub    $0x4,%esp
  801149:	68 f3 2f 80 00       	push   $0x802ff3
  80114e:	6a 5f                	push   $0x5f
  801150:	68 09 30 80 00       	push   $0x803009
  801155:	e8 60 15 00 00       	call   8026ba <_panic>
			panic("sys_page_map() panic\n");
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	68 f3 2f 80 00       	push   $0x802ff3
  801162:	6a 5b                	push   $0x5b
  801164:	68 09 30 80 00       	push   $0x803009
  801169:	e8 4c 15 00 00       	call   8026ba <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80116e:	c1 e2 0c             	shl    $0xc,%edx
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	68 05 08 00 00       	push   $0x805
  801179:	52                   	push   %edx
  80117a:	50                   	push   %eax
  80117b:	52                   	push   %edx
  80117c:	6a 00                	push   $0x0
  80117e:	e8 68 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  801183:	83 c4 20             	add    $0x20,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	0f 89 3d ff ff ff    	jns    8010cb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	68 f3 2f 80 00       	push   $0x802ff3
  801196:	6a 66                	push   $0x66
  801198:	68 09 30 80 00       	push   $0x803009
  80119d:	e8 18 15 00 00       	call   8026ba <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011a2:	c1 e2 0c             	shl    $0xc,%edx
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	6a 05                	push   $0x5
  8011aa:	52                   	push   %edx
  8011ab:	50                   	push   %eax
  8011ac:	52                   	push   %edx
  8011ad:	6a 00                	push   $0x0
  8011af:	e8 37 fc ff ff       	call   800deb <sys_page_map>
		if(r < 0)
  8011b4:	83 c4 20             	add    $0x20,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	0f 89 0c ff ff ff    	jns    8010cb <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011bf:	83 ec 04             	sub    $0x4,%esp
  8011c2:	68 f3 2f 80 00       	push   $0x802ff3
  8011c7:	6a 6d                	push   $0x6d
  8011c9:	68 09 30 80 00       	push   $0x803009
  8011ce:	e8 e7 14 00 00       	call   8026ba <_panic>

008011d3 <pgfault>:
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011dd:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011df:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011e3:	0f 84 99 00 00 00    	je     801282 <pgfault+0xaf>
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	c1 ea 16             	shr    $0x16,%edx
  8011ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f5:	f6 c2 01             	test   $0x1,%dl
  8011f8:	0f 84 84 00 00 00    	je     801282 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	c1 ea 0c             	shr    $0xc,%edx
  801203:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801210:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801216:	75 6a                	jne    801282 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80121d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	6a 07                	push   $0x7
  801224:	68 00 f0 7f 00       	push   $0x7ff000
  801229:	6a 00                	push   $0x0
  80122b:	e8 78 fb ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 5f                	js     801296 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	68 00 10 00 00       	push   $0x1000
  80123f:	53                   	push   %ebx
  801240:	68 00 f0 7f 00       	push   $0x7ff000
  801245:	e8 5c f9 ff ff       	call   800ba6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80124a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801251:	53                   	push   %ebx
  801252:	6a 00                	push   $0x0
  801254:	68 00 f0 7f 00       	push   $0x7ff000
  801259:	6a 00                	push   $0x0
  80125b:	e8 8b fb ff ff       	call   800deb <sys_page_map>
	if(ret < 0)
  801260:	83 c4 20             	add    $0x20,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 43                	js     8012aa <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	68 00 f0 7f 00       	push   $0x7ff000
  80126f:	6a 00                	push   $0x0
  801271:	e8 b7 fb ff ff       	call   800e2d <sys_page_unmap>
	if(ret < 0)
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	78 41                	js     8012be <pgfault+0xeb>
}
  80127d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801280:	c9                   	leave  
  801281:	c3                   	ret    
		panic("panic at pgfault()\n");
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	68 14 30 80 00       	push   $0x803014
  80128a:	6a 26                	push   $0x26
  80128c:	68 09 30 80 00       	push   $0x803009
  801291:	e8 24 14 00 00       	call   8026ba <_panic>
		panic("panic in sys_page_alloc()\n");
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	68 28 30 80 00       	push   $0x803028
  80129e:	6a 31                	push   $0x31
  8012a0:	68 09 30 80 00       	push   $0x803009
  8012a5:	e8 10 14 00 00       	call   8026ba <_panic>
		panic("panic in sys_page_map()\n");
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	68 43 30 80 00       	push   $0x803043
  8012b2:	6a 36                	push   $0x36
  8012b4:	68 09 30 80 00       	push   $0x803009
  8012b9:	e8 fc 13 00 00       	call   8026ba <_panic>
		panic("panic in sys_page_unmap()\n");
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	68 5c 30 80 00       	push   $0x80305c
  8012c6:	6a 39                	push   $0x39
  8012c8:	68 09 30 80 00       	push   $0x803009
  8012cd:	e8 e8 13 00 00       	call   8026ba <_panic>

008012d2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012db:	68 d3 11 80 00       	push   $0x8011d3
  8012e0:	e8 36 14 00 00       	call   80271b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8012ea:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 27                	js     80131a <fork+0x48>
  8012f3:	89 c6                	mov    %eax,%esi
  8012f5:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012f7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012fc:	75 48                	jne    801346 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012fe:	e8 67 fa ff ff       	call   800d6a <sys_getenvid>
  801303:	25 ff 03 00 00       	and    $0x3ff,%eax
  801308:	c1 e0 07             	shl    $0x7,%eax
  80130b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801310:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801315:	e9 90 00 00 00       	jmp    8013aa <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	68 78 30 80 00       	push   $0x803078
  801322:	68 8c 00 00 00       	push   $0x8c
  801327:	68 09 30 80 00       	push   $0x803009
  80132c:	e8 89 13 00 00       	call   8026ba <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801331:	89 f8                	mov    %edi,%eax
  801333:	e8 45 fd ff ff       	call   80107d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801338:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80133e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801344:	74 26                	je     80136c <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801346:	89 d8                	mov    %ebx,%eax
  801348:	c1 e8 16             	shr    $0x16,%eax
  80134b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801352:	a8 01                	test   $0x1,%al
  801354:	74 e2                	je     801338 <fork+0x66>
  801356:	89 da                	mov    %ebx,%edx
  801358:	c1 ea 0c             	shr    $0xc,%edx
  80135b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801362:	83 e0 05             	and    $0x5,%eax
  801365:	83 f8 05             	cmp    $0x5,%eax
  801368:	75 ce                	jne    801338 <fork+0x66>
  80136a:	eb c5                	jmp    801331 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	6a 07                	push   $0x7
  801371:	68 00 f0 bf ee       	push   $0xeebff000
  801376:	56                   	push   %esi
  801377:	e8 2c fa ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 31                	js     8013b4 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	68 8a 27 80 00       	push   $0x80278a
  80138b:	56                   	push   %esi
  80138c:	e8 62 fb ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 33                	js     8013cb <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	6a 02                	push   $0x2
  80139d:	56                   	push   %esi
  80139e:	e8 cc fa ff ff       	call   800e6f <sys_env_set_status>
	if(ret < 0)
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 38                	js     8013e2 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013aa:	89 f0                	mov    %esi,%eax
  8013ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5f                   	pop    %edi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	68 28 30 80 00       	push   $0x803028
  8013bc:	68 98 00 00 00       	push   $0x98
  8013c1:	68 09 30 80 00       	push   $0x803009
  8013c6:	e8 ef 12 00 00       	call   8026ba <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	68 9c 30 80 00       	push   $0x80309c
  8013d3:	68 9b 00 00 00       	push   $0x9b
  8013d8:	68 09 30 80 00       	push   $0x803009
  8013dd:	e8 d8 12 00 00       	call   8026ba <_panic>
		panic("panic in sys_env_set_status()\n");
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 c4 30 80 00       	push   $0x8030c4
  8013ea:	68 9e 00 00 00       	push   $0x9e
  8013ef:	68 09 30 80 00       	push   $0x803009
  8013f4:	e8 c1 12 00 00       	call   8026ba <_panic>

008013f9 <sfork>:

// Challenge!
int
sfork(void)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	57                   	push   %edi
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801402:	68 d3 11 80 00       	push   $0x8011d3
  801407:	e8 0f 13 00 00       	call   80271b <set_pgfault_handler>
  80140c:	b8 07 00 00 00       	mov    $0x7,%eax
  801411:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 27                	js     801441 <sfork+0x48>
  80141a:	89 c7                	mov    %eax,%edi
  80141c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801423:	75 55                	jne    80147a <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801425:	e8 40 f9 ff ff       	call   800d6a <sys_getenvid>
  80142a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142f:	c1 e0 07             	shl    $0x7,%eax
  801432:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801437:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80143c:	e9 d4 00 00 00       	jmp    801515 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	68 78 30 80 00       	push   $0x803078
  801449:	68 af 00 00 00       	push   $0xaf
  80144e:	68 09 30 80 00       	push   $0x803009
  801453:	e8 62 12 00 00       	call   8026ba <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801458:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80145d:	89 f0                	mov    %esi,%eax
  80145f:	e8 19 fc ff ff       	call   80107d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801464:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80146a:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801470:	77 65                	ja     8014d7 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801472:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801478:	74 de                	je     801458 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	c1 e8 16             	shr    $0x16,%eax
  80147f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801486:	a8 01                	test   $0x1,%al
  801488:	74 da                	je     801464 <sfork+0x6b>
  80148a:	89 da                	mov    %ebx,%edx
  80148c:	c1 ea 0c             	shr    $0xc,%edx
  80148f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801496:	83 e0 05             	and    $0x5,%eax
  801499:	83 f8 05             	cmp    $0x5,%eax
  80149c:	75 c6                	jne    801464 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80149e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014a5:	c1 e2 0c             	shl    $0xc,%edx
  8014a8:	83 ec 0c             	sub    $0xc,%esp
  8014ab:	83 e0 07             	and    $0x7,%eax
  8014ae:	50                   	push   %eax
  8014af:	52                   	push   %edx
  8014b0:	56                   	push   %esi
  8014b1:	52                   	push   %edx
  8014b2:	6a 00                	push   $0x0
  8014b4:	e8 32 f9 ff ff       	call   800deb <sys_page_map>
  8014b9:	83 c4 20             	add    $0x20,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	74 a4                	je     801464 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 f3 2f 80 00       	push   $0x802ff3
  8014c8:	68 ba 00 00 00       	push   $0xba
  8014cd:	68 09 30 80 00       	push   $0x803009
  8014d2:	e8 e3 11 00 00       	call   8026ba <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	6a 07                	push   $0x7
  8014dc:	68 00 f0 bf ee       	push   $0xeebff000
  8014e1:	57                   	push   %edi
  8014e2:	e8 c1 f8 ff ff       	call   800da8 <sys_page_alloc>
	if(ret < 0)
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 31                	js     80151f <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	68 8a 27 80 00       	push   $0x80278a
  8014f6:	57                   	push   %edi
  8014f7:	e8 f7 f9 ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 33                	js     801536 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	6a 02                	push   $0x2
  801508:	57                   	push   %edi
  801509:	e8 61 f9 ff ff       	call   800e6f <sys_env_set_status>
	if(ret < 0)
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 38                	js     80154d <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801515:	89 f8                	mov    %edi,%eax
  801517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5f                   	pop    %edi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	68 28 30 80 00       	push   $0x803028
  801527:	68 c0 00 00 00       	push   $0xc0
  80152c:	68 09 30 80 00       	push   $0x803009
  801531:	e8 84 11 00 00       	call   8026ba <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	68 9c 30 80 00       	push   $0x80309c
  80153e:	68 c3 00 00 00       	push   $0xc3
  801543:	68 09 30 80 00       	push   $0x803009
  801548:	e8 6d 11 00 00       	call   8026ba <_panic>
		panic("panic in sys_env_set_status()\n");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 c4 30 80 00       	push   $0x8030c4
  801555:	68 c6 00 00 00       	push   $0xc6
  80155a:	68 09 30 80 00       	push   $0x803009
  80155f:	e8 56 11 00 00       	call   8026ba <_panic>

00801564 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	05 00 00 00 30       	add    $0x30000000,%eax
  80156f:	c1 e8 0c             	shr    $0xc,%eax
}
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80157f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801584:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    

0080158b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801593:	89 c2                	mov    %eax,%edx
  801595:	c1 ea 16             	shr    $0x16,%edx
  801598:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	74 2d                	je     8015d1 <fd_alloc+0x46>
  8015a4:	89 c2                	mov    %eax,%edx
  8015a6:	c1 ea 0c             	shr    $0xc,%edx
  8015a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b0:	f6 c2 01             	test   $0x1,%dl
  8015b3:	74 1c                	je     8015d1 <fd_alloc+0x46>
  8015b5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015ba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015bf:	75 d2                	jne    801593 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015ca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015cf:	eb 0a                	jmp    8015db <fd_alloc+0x50>
			*fd_store = fd;
  8015d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    

008015dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015e3:	83 f8 1f             	cmp    $0x1f,%eax
  8015e6:	77 30                	ja     801618 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e8:	c1 e0 0c             	shl    $0xc,%eax
  8015eb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015f0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015f6:	f6 c2 01             	test   $0x1,%dl
  8015f9:	74 24                	je     80161f <fd_lookup+0x42>
  8015fb:	89 c2                	mov    %eax,%edx
  8015fd:	c1 ea 0c             	shr    $0xc,%edx
  801600:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801607:	f6 c2 01             	test   $0x1,%dl
  80160a:	74 1a                	je     801626 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80160c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160f:	89 02                	mov    %eax,(%edx)
	return 0;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		return -E_INVAL;
  801618:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161d:	eb f7                	jmp    801616 <fd_lookup+0x39>
		return -E_INVAL;
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801624:	eb f0                	jmp    801616 <fd_lookup+0x39>
  801626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162b:	eb e9                	jmp    801616 <fd_lookup+0x39>

0080162d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 08             	sub    $0x8,%esp
  801633:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801636:	ba 00 00 00 00       	mov    $0x0,%edx
  80163b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801640:	39 08                	cmp    %ecx,(%eax)
  801642:	74 38                	je     80167c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801644:	83 c2 01             	add    $0x1,%edx
  801647:	8b 04 95 60 31 80 00 	mov    0x803160(,%edx,4),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 ee                	jne    801640 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801652:	a1 08 50 80 00       	mov    0x805008,%eax
  801657:	8b 40 48             	mov    0x48(%eax),%eax
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	51                   	push   %ecx
  80165e:	50                   	push   %eax
  80165f:	68 e4 30 80 00       	push   $0x8030e4
  801664:	e8 ee eb ff ff       	call   800257 <cprintf>
	*dev = 0;
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
			*dev = devtab[i];
  80167c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801681:	b8 00 00 00 00       	mov    $0x0,%eax
  801686:	eb f2                	jmp    80167a <dev_lookup+0x4d>

00801688 <fd_close>:
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	57                   	push   %edi
  80168c:	56                   	push   %esi
  80168d:	53                   	push   %ebx
  80168e:	83 ec 24             	sub    $0x24,%esp
  801691:	8b 75 08             	mov    0x8(%ebp),%esi
  801694:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80169a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a4:	50                   	push   %eax
  8016a5:	e8 33 ff ff ff       	call   8015dd <fd_lookup>
  8016aa:	89 c3                	mov    %eax,%ebx
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 05                	js     8016b8 <fd_close+0x30>
	    || fd != fd2)
  8016b3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016b6:	74 16                	je     8016ce <fd_close+0x46>
		return (must_exist ? r : 0);
  8016b8:	89 f8                	mov    %edi,%eax
  8016ba:	84 c0                	test   %al,%al
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	0f 44 d8             	cmove  %eax,%ebx
}
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5f                   	pop    %edi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ce:	83 ec 08             	sub    $0x8,%esp
  8016d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016d4:	50                   	push   %eax
  8016d5:	ff 36                	pushl  (%esi)
  8016d7:	e8 51 ff ff ff       	call   80162d <dev_lookup>
  8016dc:	89 c3                	mov    %eax,%ebx
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 1a                	js     8016ff <fd_close+0x77>
		if (dev->dev_close)
  8016e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	74 0b                	je     8016ff <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	56                   	push   %esi
  8016f8:	ff d0                	call   *%eax
  8016fa:	89 c3                	mov    %eax,%ebx
  8016fc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	56                   	push   %esi
  801703:	6a 00                	push   $0x0
  801705:	e8 23 f7 ff ff       	call   800e2d <sys_page_unmap>
	return r;
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	eb b5                	jmp    8016c4 <fd_close+0x3c>

0080170f <close>:

int
close(int fdnum)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801715:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801718:	50                   	push   %eax
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	e8 bc fe ff ff       	call   8015dd <fd_lookup>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	79 02                	jns    80172a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    
		return fd_close(fd, 1);
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	6a 01                	push   $0x1
  80172f:	ff 75 f4             	pushl  -0xc(%ebp)
  801732:	e8 51 ff ff ff       	call   801688 <fd_close>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	eb ec                	jmp    801728 <close+0x19>

0080173c <close_all>:

void
close_all(void)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	53                   	push   %ebx
  801740:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801743:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	53                   	push   %ebx
  80174c:	e8 be ff ff ff       	call   80170f <close>
	for (i = 0; i < MAXFD; i++)
  801751:	83 c3 01             	add    $0x1,%ebx
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	83 fb 20             	cmp    $0x20,%ebx
  80175a:	75 ec                	jne    801748 <close_all+0xc>
}
  80175c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	57                   	push   %edi
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80176a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80176d:	50                   	push   %eax
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	e8 67 fe ff ff       	call   8015dd <fd_lookup>
  801776:	89 c3                	mov    %eax,%ebx
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	0f 88 81 00 00 00    	js     801804 <dup+0xa3>
		return r;
	close(newfdnum);
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	e8 81 ff ff ff       	call   80170f <close>

	newfd = INDEX2FD(newfdnum);
  80178e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801791:	c1 e6 0c             	shl    $0xc,%esi
  801794:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80179a:	83 c4 04             	add    $0x4,%esp
  80179d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a0:	e8 cf fd ff ff       	call   801574 <fd2data>
  8017a5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017a7:	89 34 24             	mov    %esi,(%esp)
  8017aa:	e8 c5 fd ff ff       	call   801574 <fd2data>
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	c1 e8 16             	shr    $0x16,%eax
  8017b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c0:	a8 01                	test   $0x1,%al
  8017c2:	74 11                	je     8017d5 <dup+0x74>
  8017c4:	89 d8                	mov    %ebx,%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
  8017c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017d0:	f6 c2 01             	test   $0x1,%dl
  8017d3:	75 39                	jne    80180e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017d8:	89 d0                	mov    %edx,%eax
  8017da:	c1 e8 0c             	shr    $0xc,%eax
  8017dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ec:	50                   	push   %eax
  8017ed:	56                   	push   %esi
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	6a 00                	push   $0x0
  8017f3:	e8 f3 f5 ff ff       	call   800deb <sys_page_map>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 20             	add    $0x20,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 31                	js     801832 <dup+0xd1>
		goto err;

	return newfdnum;
  801801:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801804:	89 d8                	mov    %ebx,%eax
  801806:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801809:	5b                   	pop    %ebx
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80180e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	25 07 0e 00 00       	and    $0xe07,%eax
  80181d:	50                   	push   %eax
  80181e:	57                   	push   %edi
  80181f:	6a 00                	push   $0x0
  801821:	53                   	push   %ebx
  801822:	6a 00                	push   $0x0
  801824:	e8 c2 f5 ff ff       	call   800deb <sys_page_map>
  801829:	89 c3                	mov    %eax,%ebx
  80182b:	83 c4 20             	add    $0x20,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	79 a3                	jns    8017d5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	56                   	push   %esi
  801836:	6a 00                	push   $0x0
  801838:	e8 f0 f5 ff ff       	call   800e2d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80183d:	83 c4 08             	add    $0x8,%esp
  801840:	57                   	push   %edi
  801841:	6a 00                	push   $0x0
  801843:	e8 e5 f5 ff ff       	call   800e2d <sys_page_unmap>
	return r;
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	eb b7                	jmp    801804 <dup+0xa3>

0080184d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	53                   	push   %ebx
  801851:	83 ec 1c             	sub    $0x1c,%esp
  801854:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801857:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185a:	50                   	push   %eax
  80185b:	53                   	push   %ebx
  80185c:	e8 7c fd ff ff       	call   8015dd <fd_lookup>
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	78 3f                	js     8018a7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186e:	50                   	push   %eax
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801872:	ff 30                	pushl  (%eax)
  801874:	e8 b4 fd ff ff       	call   80162d <dev_lookup>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 27                	js     8018a7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801880:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801883:	8b 42 08             	mov    0x8(%edx),%eax
  801886:	83 e0 03             	and    $0x3,%eax
  801889:	83 f8 01             	cmp    $0x1,%eax
  80188c:	74 1e                	je     8018ac <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	8b 40 08             	mov    0x8(%eax),%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	74 35                	je     8018cd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	ff 75 10             	pushl  0x10(%ebp)
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	52                   	push   %edx
  8018a2:	ff d0                	call   *%eax
  8018a4:	83 c4 10             	add    $0x10,%esp
}
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ac:	a1 08 50 80 00       	mov    0x805008,%eax
  8018b1:	8b 40 48             	mov    0x48(%eax),%eax
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	53                   	push   %ebx
  8018b8:	50                   	push   %eax
  8018b9:	68 25 31 80 00       	push   $0x803125
  8018be:	e8 94 e9 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cb:	eb da                	jmp    8018a7 <read+0x5a>
		return -E_NOT_SUPP;
  8018cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d2:	eb d3                	jmp    8018a7 <read+0x5a>

008018d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	57                   	push   %edi
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e8:	39 f3                	cmp    %esi,%ebx
  8018ea:	73 23                	jae    80190f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	89 f0                	mov    %esi,%eax
  8018f1:	29 d8                	sub    %ebx,%eax
  8018f3:	50                   	push   %eax
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	03 45 0c             	add    0xc(%ebp),%eax
  8018f9:	50                   	push   %eax
  8018fa:	57                   	push   %edi
  8018fb:	e8 4d ff ff ff       	call   80184d <read>
		if (m < 0)
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	85 c0                	test   %eax,%eax
  801905:	78 06                	js     80190d <readn+0x39>
			return m;
		if (m == 0)
  801907:	74 06                	je     80190f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801909:	01 c3                	add    %eax,%ebx
  80190b:	eb db                	jmp    8018e8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80190d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80190f:	89 d8                	mov    %ebx,%eax
  801911:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
  80191d:	83 ec 1c             	sub    $0x1c,%esp
  801920:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801923:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801926:	50                   	push   %eax
  801927:	53                   	push   %ebx
  801928:	e8 b0 fc ff ff       	call   8015dd <fd_lookup>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 3a                	js     80196e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193e:	ff 30                	pushl  (%eax)
  801940:	e8 e8 fc ff ff       	call   80162d <dev_lookup>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 22                	js     80196e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80194c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801953:	74 1e                	je     801973 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801958:	8b 52 0c             	mov    0xc(%edx),%edx
  80195b:	85 d2                	test   %edx,%edx
  80195d:	74 35                	je     801994 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	ff 75 10             	pushl  0x10(%ebp)
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	50                   	push   %eax
  801969:	ff d2                	call   *%edx
  80196b:	83 c4 10             	add    $0x10,%esp
}
  80196e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801971:	c9                   	leave  
  801972:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801973:	a1 08 50 80 00       	mov    0x805008,%eax
  801978:	8b 40 48             	mov    0x48(%eax),%eax
  80197b:	83 ec 04             	sub    $0x4,%esp
  80197e:	53                   	push   %ebx
  80197f:	50                   	push   %eax
  801980:	68 41 31 80 00       	push   $0x803141
  801985:	e8 cd e8 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801992:	eb da                	jmp    80196e <write+0x55>
		return -E_NOT_SUPP;
  801994:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801999:	eb d3                	jmp    80196e <write+0x55>

0080199b <seek>:

int
seek(int fdnum, off_t offset)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a4:	50                   	push   %eax
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	e8 30 fc ff ff       	call   8015dd <fd_lookup>
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 0e                	js     8019c2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ba:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 1c             	sub    $0x1c,%esp
  8019cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d1:	50                   	push   %eax
  8019d2:	53                   	push   %ebx
  8019d3:	e8 05 fc ff ff       	call   8015dd <fd_lookup>
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 37                	js     801a16 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e5:	50                   	push   %eax
  8019e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e9:	ff 30                	pushl  (%eax)
  8019eb:	e8 3d fc ff ff       	call   80162d <dev_lookup>
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 1f                	js     801a16 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019fe:	74 1b                	je     801a1b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a03:	8b 52 18             	mov    0x18(%edx),%edx
  801a06:	85 d2                	test   %edx,%edx
  801a08:	74 32                	je     801a3c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	50                   	push   %eax
  801a11:	ff d2                	call   *%edx
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a1b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a20:	8b 40 48             	mov    0x48(%eax),%eax
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	53                   	push   %ebx
  801a27:	50                   	push   %eax
  801a28:	68 04 31 80 00       	push   $0x803104
  801a2d:	e8 25 e8 ff ff       	call   800257 <cprintf>
		return -E_INVAL;
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a3a:	eb da                	jmp    801a16 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a3c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a41:	eb d3                	jmp    801a16 <ftruncate+0x52>

00801a43 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	53                   	push   %ebx
  801a47:	83 ec 1c             	sub    $0x1c,%esp
  801a4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a50:	50                   	push   %eax
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	e8 84 fb ff ff       	call   8015dd <fd_lookup>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 4b                	js     801aab <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	ff 30                	pushl  (%eax)
  801a6c:	e8 bc fb ff ff       	call   80162d <dev_lookup>
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 33                	js     801aab <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a7f:	74 2f                	je     801ab0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a81:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a84:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a8b:	00 00 00 
	stat->st_isdir = 0;
  801a8e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a95:	00 00 00 
	stat->st_dev = dev;
  801a98:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a9e:	83 ec 08             	sub    $0x8,%esp
  801aa1:	53                   	push   %ebx
  801aa2:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa5:	ff 50 14             	call   *0x14(%eax)
  801aa8:	83 c4 10             	add    $0x10,%esp
}
  801aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    
		return -E_NOT_SUPP;
  801ab0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ab5:	eb f4                	jmp    801aab <fstat+0x68>

00801ab7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801abc:	83 ec 08             	sub    $0x8,%esp
  801abf:	6a 00                	push   $0x0
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	e8 22 02 00 00       	call   801ceb <open>
  801ac9:	89 c3                	mov    %eax,%ebx
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 1b                	js     801aed <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	e8 65 ff ff ff       	call   801a43 <fstat>
  801ade:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae0:	89 1c 24             	mov    %ebx,(%esp)
  801ae3:	e8 27 fc ff ff       	call   80170f <close>
	return r;
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	89 f3                	mov    %esi,%ebx
}
  801aed:	89 d8                	mov    %ebx,%eax
  801aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	56                   	push   %esi
  801afa:	53                   	push   %ebx
  801afb:	89 c6                	mov    %eax,%esi
  801afd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b06:	74 27                	je     801b2f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b08:	6a 07                	push   $0x7
  801b0a:	68 00 60 80 00       	push   $0x806000
  801b0f:	56                   	push   %esi
  801b10:	ff 35 00 50 80 00    	pushl  0x805000
  801b16:	e8 fe 0c 00 00       	call   802819 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b1b:	83 c4 0c             	add    $0xc,%esp
  801b1e:	6a 00                	push   $0x0
  801b20:	53                   	push   %ebx
  801b21:	6a 00                	push   $0x0
  801b23:	e8 88 0c 00 00       	call   8027b0 <ipc_recv>
}
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	6a 01                	push   $0x1
  801b34:	e8 38 0d 00 00       	call   802871 <ipc_find_env>
  801b39:	a3 00 50 80 00       	mov    %eax,0x805000
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	eb c5                	jmp    801b08 <fsipc+0x12>

00801b43 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b61:	b8 02 00 00 00       	mov    $0x2,%eax
  801b66:	e8 8b ff ff ff       	call   801af6 <fsipc>
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <devfile_flush>:
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8b 40 0c             	mov    0xc(%eax),%eax
  801b79:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b83:	b8 06 00 00 00       	mov    $0x6,%eax
  801b88:	e8 69 ff ff ff       	call   801af6 <fsipc>
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <devfile_stat>:
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	53                   	push   %ebx
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9f:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bae:	e8 43 ff ff ff       	call   801af6 <fsipc>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 2c                	js     801be3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	68 00 60 80 00       	push   $0x806000
  801bbf:	53                   	push   %ebx
  801bc0:	e8 f1 ed ff ff       	call   8009b6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bc5:	a1 80 60 80 00       	mov    0x806080,%eax
  801bca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd0:	a1 84 60 80 00       	mov    0x806084,%eax
  801bd5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <devfile_write>:
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	53                   	push   %ebx
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bfd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c03:	53                   	push   %ebx
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	68 08 60 80 00       	push   $0x806008
  801c0c:	e8 95 ef ff ff       	call   800ba6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c11:	ba 00 00 00 00       	mov    $0x0,%edx
  801c16:	b8 04 00 00 00       	mov    $0x4,%eax
  801c1b:	e8 d6 fe ff ff       	call   801af6 <fsipc>
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 0b                	js     801c32 <devfile_write+0x4a>
	assert(r <= n);
  801c27:	39 d8                	cmp    %ebx,%eax
  801c29:	77 0c                	ja     801c37 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c2b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c30:	7f 1e                	jg     801c50 <devfile_write+0x68>
}
  801c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    
	assert(r <= n);
  801c37:	68 74 31 80 00       	push   $0x803174
  801c3c:	68 7b 31 80 00       	push   $0x80317b
  801c41:	68 98 00 00 00       	push   $0x98
  801c46:	68 90 31 80 00       	push   $0x803190
  801c4b:	e8 6a 0a 00 00       	call   8026ba <_panic>
	assert(r <= PGSIZE);
  801c50:	68 9b 31 80 00       	push   $0x80319b
  801c55:	68 7b 31 80 00       	push   $0x80317b
  801c5a:	68 99 00 00 00       	push   $0x99
  801c5f:	68 90 31 80 00       	push   $0x803190
  801c64:	e8 51 0a 00 00       	call   8026ba <_panic>

00801c69 <devfile_read>:
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	56                   	push   %esi
  801c6d:	53                   	push   %ebx
  801c6e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	8b 40 0c             	mov    0xc(%eax),%eax
  801c77:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c7c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c82:	ba 00 00 00 00       	mov    $0x0,%edx
  801c87:	b8 03 00 00 00       	mov    $0x3,%eax
  801c8c:	e8 65 fe ff ff       	call   801af6 <fsipc>
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 1f                	js     801cb6 <devfile_read+0x4d>
	assert(r <= n);
  801c97:	39 f0                	cmp    %esi,%eax
  801c99:	77 24                	ja     801cbf <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c9b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca0:	7f 33                	jg     801cd5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	50                   	push   %eax
  801ca6:	68 00 60 80 00       	push   $0x806000
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	e8 91 ee ff ff       	call   800b44 <memmove>
	return r;
  801cb3:	83 c4 10             	add    $0x10,%esp
}
  801cb6:	89 d8                	mov    %ebx,%eax
  801cb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    
	assert(r <= n);
  801cbf:	68 74 31 80 00       	push   $0x803174
  801cc4:	68 7b 31 80 00       	push   $0x80317b
  801cc9:	6a 7c                	push   $0x7c
  801ccb:	68 90 31 80 00       	push   $0x803190
  801cd0:	e8 e5 09 00 00       	call   8026ba <_panic>
	assert(r <= PGSIZE);
  801cd5:	68 9b 31 80 00       	push   $0x80319b
  801cda:	68 7b 31 80 00       	push   $0x80317b
  801cdf:	6a 7d                	push   $0x7d
  801ce1:	68 90 31 80 00       	push   $0x803190
  801ce6:	e8 cf 09 00 00       	call   8026ba <_panic>

00801ceb <open>:
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 1c             	sub    $0x1c,%esp
  801cf3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cf6:	56                   	push   %esi
  801cf7:	e8 81 ec ff ff       	call   80097d <strlen>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d04:	7f 6c                	jg     801d72 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d06:	83 ec 0c             	sub    $0xc,%esp
  801d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	e8 79 f8 ff ff       	call   80158b <fd_alloc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 3c                	js     801d57 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d1b:	83 ec 08             	sub    $0x8,%esp
  801d1e:	56                   	push   %esi
  801d1f:	68 00 60 80 00       	push   $0x806000
  801d24:	e8 8d ec ff ff       	call   8009b6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	e8 b8 fd ff ff       	call   801af6 <fsipc>
  801d3e:	89 c3                	mov    %eax,%ebx
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	85 c0                	test   %eax,%eax
  801d45:	78 19                	js     801d60 <open+0x75>
	return fd2num(fd);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4d:	e8 12 f8 ff ff       	call   801564 <fd2num>
  801d52:	89 c3                	mov    %eax,%ebx
  801d54:	83 c4 10             	add    $0x10,%esp
}
  801d57:	89 d8                	mov    %ebx,%eax
  801d59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    
		fd_close(fd, 0);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	e8 1b f9 ff ff       	call   801688 <fd_close>
		return r;
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	eb e5                	jmp    801d57 <open+0x6c>
		return -E_BAD_PATH;
  801d72:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d77:	eb de                	jmp    801d57 <open+0x6c>

00801d79 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d84:	b8 08 00 00 00       	mov    $0x8,%eax
  801d89:	e8 68 fd ff ff       	call   801af6 <fsipc>
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d96:	68 a7 31 80 00       	push   $0x8031a7
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	e8 13 ec ff ff       	call   8009b6 <strcpy>
	return 0;
}
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <devsock_close>:
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	53                   	push   %ebx
  801dae:	83 ec 10             	sub    $0x10,%esp
  801db1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801db4:	53                   	push   %ebx
  801db5:	e8 f2 0a 00 00       	call   8028ac <pageref>
  801dba:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dc2:	83 f8 01             	cmp    $0x1,%eax
  801dc5:	74 07                	je     801dce <devsock_close+0x24>
}
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	ff 73 0c             	pushl  0xc(%ebx)
  801dd4:	e8 b9 02 00 00       	call   802092 <nsipc_close>
  801dd9:	89 c2                	mov    %eax,%edx
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	eb e7                	jmp    801dc7 <devsock_close+0x1d>

00801de0 <devsock_write>:
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	ff 75 10             	pushl  0x10(%ebp)
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	ff 70 0c             	pushl  0xc(%eax)
  801df4:	e8 76 03 00 00       	call   80216f <nsipc_send>
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <devsock_read>:
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 10             	pushl  0x10(%ebp)
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	ff 70 0c             	pushl  0xc(%eax)
  801e0f:	e8 ef 02 00 00       	call   802103 <nsipc_recv>
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <fd2sockid>:
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e1c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	e8 b7 f7 ff ff       	call   8015dd <fd_lookup>
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 10                	js     801e3d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e36:	39 08                	cmp    %ecx,(%eax)
  801e38:	75 05                	jne    801e3f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e3a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    
		return -E_NOT_SUPP;
  801e3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e44:	eb f7                	jmp    801e3d <fd2sockid+0x27>

00801e46 <alloc_sockfd>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	83 ec 1c             	sub    $0x1c,%esp
  801e4e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e53:	50                   	push   %eax
  801e54:	e8 32 f7 ff ff       	call   80158b <fd_alloc>
  801e59:	89 c3                	mov    %eax,%ebx
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 43                	js     801ea5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 07 04 00 00       	push   $0x407
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	6a 00                	push   $0x0
  801e6f:	e8 34 ef ff ff       	call   800da8 <sys_page_alloc>
  801e74:	89 c3                	mov    %eax,%ebx
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 28                	js     801ea5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e86:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e92:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	50                   	push   %eax
  801e99:	e8 c6 f6 ff ff       	call   801564 <fd2num>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	eb 0c                	jmp    801eb1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	56                   	push   %esi
  801ea9:	e8 e4 01 00 00       	call   802092 <nsipc_close>
		return r;
  801eae:	83 c4 10             	add    $0x10,%esp
}
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <accept>:
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	e8 4e ff ff ff       	call   801e16 <fd2sockid>
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 1b                	js     801ee7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	ff 75 10             	pushl  0x10(%ebp)
  801ed2:	ff 75 0c             	pushl  0xc(%ebp)
  801ed5:	50                   	push   %eax
  801ed6:	e8 0e 01 00 00       	call   801fe9 <nsipc_accept>
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 05                	js     801ee7 <accept+0x2d>
	return alloc_sockfd(r);
  801ee2:	e8 5f ff ff ff       	call   801e46 <alloc_sockfd>
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <bind>:
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	e8 1f ff ff ff       	call   801e16 <fd2sockid>
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 12                	js     801f0d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	ff 75 10             	pushl  0x10(%ebp)
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	50                   	push   %eax
  801f05:	e8 31 01 00 00       	call   80203b <nsipc_bind>
  801f0a:	83 c4 10             	add    $0x10,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <shutdown>:
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	e8 f9 fe ff ff       	call   801e16 <fd2sockid>
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 0f                	js     801f30 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	50                   	push   %eax
  801f28:	e8 43 01 00 00       	call   802070 <nsipc_shutdown>
  801f2d:	83 c4 10             	add    $0x10,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <connect>:
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	e8 d6 fe ff ff       	call   801e16 <fd2sockid>
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 12                	js     801f56 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	ff 75 10             	pushl  0x10(%ebp)
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	50                   	push   %eax
  801f4e:	e8 59 01 00 00       	call   8020ac <nsipc_connect>
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <listen>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	e8 b0 fe ff ff       	call   801e16 <fd2sockid>
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 0f                	js     801f79 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f6a:	83 ec 08             	sub    $0x8,%esp
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	50                   	push   %eax
  801f71:	e8 6b 01 00 00       	call   8020e1 <nsipc_listen>
  801f76:	83 c4 10             	add    $0x10,%esp
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <socket>:

int
socket(int domain, int type, int protocol)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f81:	ff 75 10             	pushl  0x10(%ebp)
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 3e 02 00 00       	call   8021cd <nsipc_socket>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 05                	js     801f9b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f96:	e8 ab fe ff ff       	call   801e46 <alloc_sockfd>
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	53                   	push   %ebx
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fa6:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fad:	74 26                	je     801fd5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801faf:	6a 07                	push   $0x7
  801fb1:	68 00 70 80 00       	push   $0x807000
  801fb6:	53                   	push   %ebx
  801fb7:	ff 35 04 50 80 00    	pushl  0x805004
  801fbd:	e8 57 08 00 00       	call   802819 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fc2:	83 c4 0c             	add    $0xc,%esp
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 e0 07 00 00       	call   8027b0 <ipc_recv>
}
  801fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	6a 02                	push   $0x2
  801fda:	e8 92 08 00 00       	call   802871 <ipc_find_env>
  801fdf:	a3 04 50 80 00       	mov    %eax,0x805004
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	eb c6                	jmp    801faf <nsipc+0x12>

00801fe9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	56                   	push   %esi
  801fed:	53                   	push   %ebx
  801fee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ff9:	8b 06                	mov    (%esi),%eax
  801ffb:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802000:	b8 01 00 00 00       	mov    $0x1,%eax
  802005:	e8 93 ff ff ff       	call   801f9d <nsipc>
  80200a:	89 c3                	mov    %eax,%ebx
  80200c:	85 c0                	test   %eax,%eax
  80200e:	79 09                	jns    802019 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802010:	89 d8                	mov    %ebx,%eax
  802012:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	ff 35 10 70 80 00    	pushl  0x807010
  802022:	68 00 70 80 00       	push   $0x807000
  802027:	ff 75 0c             	pushl  0xc(%ebp)
  80202a:	e8 15 eb ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  80202f:	a1 10 70 80 00       	mov    0x807010,%eax
  802034:	89 06                	mov    %eax,(%esi)
  802036:	83 c4 10             	add    $0x10,%esp
	return r;
  802039:	eb d5                	jmp    802010 <nsipc_accept+0x27>

0080203b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 08             	sub    $0x8,%esp
  802042:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80204d:	53                   	push   %ebx
  80204e:	ff 75 0c             	pushl  0xc(%ebp)
  802051:	68 04 70 80 00       	push   $0x807004
  802056:	e8 e9 ea ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80205b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802061:	b8 02 00 00 00       	mov    $0x2,%eax
  802066:	e8 32 ff ff ff       	call   801f9d <nsipc>
}
  80206b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802086:	b8 03 00 00 00       	mov    $0x3,%eax
  80208b:	e8 0d ff ff ff       	call   801f9d <nsipc>
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <nsipc_close>:

int
nsipc_close(int s)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8020a5:	e8 f3 fe ff ff       	call   801f9d <nsipc>
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 08             	sub    $0x8,%esp
  8020b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020be:	53                   	push   %ebx
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	68 04 70 80 00       	push   $0x807004
  8020c7:	e8 78 ea ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020cc:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020d2:	b8 05 00 00 00       	mov    $0x5,%eax
  8020d7:	e8 c1 fe ff ff       	call   801f9d <nsipc>
}
  8020dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f2:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8020fc:	e8 9c fe ff ff       	call   801f9d <nsipc>
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802113:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802119:	8b 45 14             	mov    0x14(%ebp),%eax
  80211c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802121:	b8 07 00 00 00       	mov    $0x7,%eax
  802126:	e8 72 fe ff ff       	call   801f9d <nsipc>
  80212b:	89 c3                	mov    %eax,%ebx
  80212d:	85 c0                	test   %eax,%eax
  80212f:	78 1f                	js     802150 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802131:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802136:	7f 21                	jg     802159 <nsipc_recv+0x56>
  802138:	39 c6                	cmp    %eax,%esi
  80213a:	7c 1d                	jl     802159 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	50                   	push   %eax
  802140:	68 00 70 80 00       	push   $0x807000
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	e8 f7 e9 ff ff       	call   800b44 <memmove>
  80214d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802150:	89 d8                	mov    %ebx,%eax
  802152:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802155:	5b                   	pop    %ebx
  802156:	5e                   	pop    %esi
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802159:	68 b3 31 80 00       	push   $0x8031b3
  80215e:	68 7b 31 80 00       	push   $0x80317b
  802163:	6a 62                	push   $0x62
  802165:	68 c8 31 80 00       	push   $0x8031c8
  80216a:	e8 4b 05 00 00       	call   8026ba <_panic>

0080216f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	53                   	push   %ebx
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802181:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802187:	7f 2e                	jg     8021b7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	53                   	push   %ebx
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	68 0c 70 80 00       	push   $0x80700c
  802195:	e8 aa e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  80219a:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8021ad:	e8 eb fd ff ff       	call   801f9d <nsipc>
}
  8021b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    
	assert(size < 1600);
  8021b7:	68 d4 31 80 00       	push   $0x8031d4
  8021bc:	68 7b 31 80 00       	push   $0x80317b
  8021c1:	6a 6d                	push   $0x6d
  8021c3:	68 c8 31 80 00       	push   $0x8031c8
  8021c8:	e8 ed 04 00 00       	call   8026ba <_panic>

008021cd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021de:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021eb:	b8 09 00 00 00       	mov    $0x9,%eax
  8021f0:	e8 a8 fd ff ff       	call   801f9d <nsipc>
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	56                   	push   %esi
  8021fb:	53                   	push   %ebx
  8021fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	e8 6a f3 ff ff       	call   801574 <fd2data>
  80220a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80220c:	83 c4 08             	add    $0x8,%esp
  80220f:	68 e0 31 80 00       	push   $0x8031e0
  802214:	53                   	push   %ebx
  802215:	e8 9c e7 ff ff       	call   8009b6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80221a:	8b 46 04             	mov    0x4(%esi),%eax
  80221d:	2b 06                	sub    (%esi),%eax
  80221f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802225:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80222c:	00 00 00 
	stat->st_dev = &devpipe;
  80222f:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802236:	40 80 00 
	return 0;
}
  802239:	b8 00 00 00 00       	mov    $0x0,%eax
  80223e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	53                   	push   %ebx
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80224f:	53                   	push   %ebx
  802250:	6a 00                	push   $0x0
  802252:	e8 d6 eb ff ff       	call   800e2d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802257:	89 1c 24             	mov    %ebx,(%esp)
  80225a:	e8 15 f3 ff ff       	call   801574 <fd2data>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	50                   	push   %eax
  802263:	6a 00                	push   $0x0
  802265:	e8 c3 eb ff ff       	call   800e2d <sys_page_unmap>
}
  80226a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <_pipeisclosed>:
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	57                   	push   %edi
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	83 ec 1c             	sub    $0x1c,%esp
  802278:	89 c7                	mov    %eax,%edi
  80227a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80227c:	a1 08 50 80 00       	mov    0x805008,%eax
  802281:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	57                   	push   %edi
  802288:	e8 1f 06 00 00       	call   8028ac <pageref>
  80228d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802290:	89 34 24             	mov    %esi,(%esp)
  802293:	e8 14 06 00 00       	call   8028ac <pageref>
		nn = thisenv->env_runs;
  802298:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80229e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	39 cb                	cmp    %ecx,%ebx
  8022a6:	74 1b                	je     8022c3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ab:	75 cf                	jne    80227c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022ad:	8b 42 58             	mov    0x58(%edx),%eax
  8022b0:	6a 01                	push   $0x1
  8022b2:	50                   	push   %eax
  8022b3:	53                   	push   %ebx
  8022b4:	68 e7 31 80 00       	push   $0x8031e7
  8022b9:	e8 99 df ff ff       	call   800257 <cprintf>
  8022be:	83 c4 10             	add    $0x10,%esp
  8022c1:	eb b9                	jmp    80227c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022c6:	0f 94 c0             	sete   %al
  8022c9:	0f b6 c0             	movzbl %al,%eax
}
  8022cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022cf:	5b                   	pop    %ebx
  8022d0:	5e                   	pop    %esi
  8022d1:	5f                   	pop    %edi
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    

008022d4 <devpipe_write>:
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	57                   	push   %edi
  8022d8:	56                   	push   %esi
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 28             	sub    $0x28,%esp
  8022dd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022e0:	56                   	push   %esi
  8022e1:	e8 8e f2 ff ff       	call   801574 <fd2data>
  8022e6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022f3:	74 4f                	je     802344 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022f5:	8b 43 04             	mov    0x4(%ebx),%eax
  8022f8:	8b 0b                	mov    (%ebx),%ecx
  8022fa:	8d 51 20             	lea    0x20(%ecx),%edx
  8022fd:	39 d0                	cmp    %edx,%eax
  8022ff:	72 14                	jb     802315 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802301:	89 da                	mov    %ebx,%edx
  802303:	89 f0                	mov    %esi,%eax
  802305:	e8 65 ff ff ff       	call   80226f <_pipeisclosed>
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 3b                	jne    802349 <devpipe_write+0x75>
			sys_yield();
  80230e:	e8 76 ea ff ff       	call   800d89 <sys_yield>
  802313:	eb e0                	jmp    8022f5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802318:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80231c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80231f:	89 c2                	mov    %eax,%edx
  802321:	c1 fa 1f             	sar    $0x1f,%edx
  802324:	89 d1                	mov    %edx,%ecx
  802326:	c1 e9 1b             	shr    $0x1b,%ecx
  802329:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80232c:	83 e2 1f             	and    $0x1f,%edx
  80232f:	29 ca                	sub    %ecx,%edx
  802331:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802335:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802339:	83 c0 01             	add    $0x1,%eax
  80233c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80233f:	83 c7 01             	add    $0x1,%edi
  802342:	eb ac                	jmp    8022f0 <devpipe_write+0x1c>
	return i;
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	eb 05                	jmp    80234e <devpipe_write+0x7a>
				return 0;
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <devpipe_read>:
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	57                   	push   %edi
  80235a:	56                   	push   %esi
  80235b:	53                   	push   %ebx
  80235c:	83 ec 18             	sub    $0x18,%esp
  80235f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802362:	57                   	push   %edi
  802363:	e8 0c f2 ff ff       	call   801574 <fd2data>
  802368:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	be 00 00 00 00       	mov    $0x0,%esi
  802372:	3b 75 10             	cmp    0x10(%ebp),%esi
  802375:	75 14                	jne    80238b <devpipe_read+0x35>
	return i;
  802377:	8b 45 10             	mov    0x10(%ebp),%eax
  80237a:	eb 02                	jmp    80237e <devpipe_read+0x28>
				return i;
  80237c:	89 f0                	mov    %esi,%eax
}
  80237e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
			sys_yield();
  802386:	e8 fe e9 ff ff       	call   800d89 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80238b:	8b 03                	mov    (%ebx),%eax
  80238d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802390:	75 18                	jne    8023aa <devpipe_read+0x54>
			if (i > 0)
  802392:	85 f6                	test   %esi,%esi
  802394:	75 e6                	jne    80237c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802396:	89 da                	mov    %ebx,%edx
  802398:	89 f8                	mov    %edi,%eax
  80239a:	e8 d0 fe ff ff       	call   80226f <_pipeisclosed>
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 e3                	je     802386 <devpipe_read+0x30>
				return 0;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a8:	eb d4                	jmp    80237e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023aa:	99                   	cltd   
  8023ab:	c1 ea 1b             	shr    $0x1b,%edx
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	83 e0 1f             	and    $0x1f,%eax
  8023b3:	29 d0                	sub    %edx,%eax
  8023b5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023bd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023c0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023c3:	83 c6 01             	add    $0x1,%esi
  8023c6:	eb aa                	jmp    802372 <devpipe_read+0x1c>

008023c8 <pipe>:
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
  8023cd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d3:	50                   	push   %eax
  8023d4:	e8 b2 f1 ff ff       	call   80158b <fd_alloc>
  8023d9:	89 c3                	mov    %eax,%ebx
  8023db:	83 c4 10             	add    $0x10,%esp
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	0f 88 23 01 00 00    	js     802509 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	68 07 04 00 00       	push   $0x407
  8023ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8023f1:	6a 00                	push   $0x0
  8023f3:	e8 b0 e9 ff ff       	call   800da8 <sys_page_alloc>
  8023f8:	89 c3                	mov    %eax,%ebx
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	0f 88 04 01 00 00    	js     802509 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80240b:	50                   	push   %eax
  80240c:	e8 7a f1 ff ff       	call   80158b <fd_alloc>
  802411:	89 c3                	mov    %eax,%ebx
  802413:	83 c4 10             	add    $0x10,%esp
  802416:	85 c0                	test   %eax,%eax
  802418:	0f 88 db 00 00 00    	js     8024f9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 07 04 00 00       	push   $0x407
  802426:	ff 75 f0             	pushl  -0x10(%ebp)
  802429:	6a 00                	push   $0x0
  80242b:	e8 78 e9 ff ff       	call   800da8 <sys_page_alloc>
  802430:	89 c3                	mov    %eax,%ebx
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	85 c0                	test   %eax,%eax
  802437:	0f 88 bc 00 00 00    	js     8024f9 <pipe+0x131>
	va = fd2data(fd0);
  80243d:	83 ec 0c             	sub    $0xc,%esp
  802440:	ff 75 f4             	pushl  -0xc(%ebp)
  802443:	e8 2c f1 ff ff       	call   801574 <fd2data>
  802448:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244a:	83 c4 0c             	add    $0xc,%esp
  80244d:	68 07 04 00 00       	push   $0x407
  802452:	50                   	push   %eax
  802453:	6a 00                	push   $0x0
  802455:	e8 4e e9 ff ff       	call   800da8 <sys_page_alloc>
  80245a:	89 c3                	mov    %eax,%ebx
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	85 c0                	test   %eax,%eax
  802461:	0f 88 82 00 00 00    	js     8024e9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	ff 75 f0             	pushl  -0x10(%ebp)
  80246d:	e8 02 f1 ff ff       	call   801574 <fd2data>
  802472:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802479:	50                   	push   %eax
  80247a:	6a 00                	push   $0x0
  80247c:	56                   	push   %esi
  80247d:	6a 00                	push   $0x0
  80247f:	e8 67 e9 ff ff       	call   800deb <sys_page_map>
  802484:	89 c3                	mov    %eax,%ebx
  802486:	83 c4 20             	add    $0x20,%esp
  802489:	85 c0                	test   %eax,%eax
  80248b:	78 4e                	js     8024db <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80248d:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802495:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024b0:	83 ec 0c             	sub    $0xc,%esp
  8024b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b6:	e8 a9 f0 ff ff       	call   801564 <fd2num>
  8024bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024be:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024c0:	83 c4 04             	add    $0x4,%esp
  8024c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c6:	e8 99 f0 ff ff       	call   801564 <fd2num>
  8024cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ce:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024d1:	83 c4 10             	add    $0x10,%esp
  8024d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024d9:	eb 2e                	jmp    802509 <pipe+0x141>
	sys_page_unmap(0, va);
  8024db:	83 ec 08             	sub    $0x8,%esp
  8024de:	56                   	push   %esi
  8024df:	6a 00                	push   $0x0
  8024e1:	e8 47 e9 ff ff       	call   800e2d <sys_page_unmap>
  8024e6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024e9:	83 ec 08             	sub    $0x8,%esp
  8024ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ef:	6a 00                	push   $0x0
  8024f1:	e8 37 e9 ff ff       	call   800e2d <sys_page_unmap>
  8024f6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8024f9:	83 ec 08             	sub    $0x8,%esp
  8024fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ff:	6a 00                	push   $0x0
  802501:	e8 27 e9 ff ff       	call   800e2d <sys_page_unmap>
  802506:	83 c4 10             	add    $0x10,%esp
}
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    

00802512 <pipeisclosed>:
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802518:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251b:	50                   	push   %eax
  80251c:	ff 75 08             	pushl  0x8(%ebp)
  80251f:	e8 b9 f0 ff ff       	call   8015dd <fd_lookup>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	85 c0                	test   %eax,%eax
  802529:	78 18                	js     802543 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80252b:	83 ec 0c             	sub    $0xc,%esp
  80252e:	ff 75 f4             	pushl  -0xc(%ebp)
  802531:	e8 3e f0 ff ff       	call   801574 <fd2data>
	return _pipeisclosed(fd, p);
  802536:	89 c2                	mov    %eax,%edx
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	e8 2f fd ff ff       	call   80226f <_pipeisclosed>
  802540:	83 c4 10             	add    $0x10,%esp
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	c3                   	ret    

0080254b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802551:	68 ff 31 80 00       	push   $0x8031ff
  802556:	ff 75 0c             	pushl  0xc(%ebp)
  802559:	e8 58 e4 ff ff       	call   8009b6 <strcpy>
	return 0;
}
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <devcons_write>:
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	57                   	push   %edi
  802569:	56                   	push   %esi
  80256a:	53                   	push   %ebx
  80256b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802571:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802576:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80257c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80257f:	73 31                	jae    8025b2 <devcons_write+0x4d>
		m = n - tot;
  802581:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802584:	29 f3                	sub    %esi,%ebx
  802586:	83 fb 7f             	cmp    $0x7f,%ebx
  802589:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80258e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	53                   	push   %ebx
  802595:	89 f0                	mov    %esi,%eax
  802597:	03 45 0c             	add    0xc(%ebp),%eax
  80259a:	50                   	push   %eax
  80259b:	57                   	push   %edi
  80259c:	e8 a3 e5 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  8025a1:	83 c4 08             	add    $0x8,%esp
  8025a4:	53                   	push   %ebx
  8025a5:	57                   	push   %edi
  8025a6:	e8 41 e7 ff ff       	call   800cec <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025ab:	01 de                	add    %ebx,%esi
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	eb ca                	jmp    80257c <devcons_write+0x17>
}
  8025b2:	89 f0                	mov    %esi,%eax
  8025b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b7:	5b                   	pop    %ebx
  8025b8:	5e                   	pop    %esi
  8025b9:	5f                   	pop    %edi
  8025ba:	5d                   	pop    %ebp
  8025bb:	c3                   	ret    

008025bc <devcons_read>:
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	83 ec 08             	sub    $0x8,%esp
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025cb:	74 21                	je     8025ee <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025cd:	e8 38 e7 ff ff       	call   800d0a <sys_cgetc>
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	75 07                	jne    8025dd <devcons_read+0x21>
		sys_yield();
  8025d6:	e8 ae e7 ff ff       	call   800d89 <sys_yield>
  8025db:	eb f0                	jmp    8025cd <devcons_read+0x11>
	if (c < 0)
  8025dd:	78 0f                	js     8025ee <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025df:	83 f8 04             	cmp    $0x4,%eax
  8025e2:	74 0c                	je     8025f0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8025e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e7:	88 02                	mov    %al,(%edx)
	return 1;
  8025e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    
		return 0;
  8025f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f5:	eb f7                	jmp    8025ee <devcons_read+0x32>

008025f7 <cputchar>:
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802603:	6a 01                	push   $0x1
  802605:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802608:	50                   	push   %eax
  802609:	e8 de e6 ff ff       	call   800cec <sys_cputs>
}
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <getchar>:
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802619:	6a 01                	push   $0x1
  80261b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80261e:	50                   	push   %eax
  80261f:	6a 00                	push   $0x0
  802621:	e8 27 f2 ff ff       	call   80184d <read>
	if (r < 0)
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 06                	js     802633 <getchar+0x20>
	if (r < 1)
  80262d:	74 06                	je     802635 <getchar+0x22>
	return c;
  80262f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    
		return -E_EOF;
  802635:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80263a:	eb f7                	jmp    802633 <getchar+0x20>

0080263c <iscons>:
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802642:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802645:	50                   	push   %eax
  802646:	ff 75 08             	pushl  0x8(%ebp)
  802649:	e8 8f ef ff ff       	call   8015dd <fd_lookup>
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	85 c0                	test   %eax,%eax
  802653:	78 11                	js     802666 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80265e:	39 10                	cmp    %edx,(%eax)
  802660:	0f 94 c0             	sete   %al
  802663:	0f b6 c0             	movzbl %al,%eax
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <opencons>:
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80266e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802671:	50                   	push   %eax
  802672:	e8 14 ef ff ff       	call   80158b <fd_alloc>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	85 c0                	test   %eax,%eax
  80267c:	78 3a                	js     8026b8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 07 04 00 00       	push   $0x407
  802686:	ff 75 f4             	pushl  -0xc(%ebp)
  802689:	6a 00                	push   $0x0
  80268b:	e8 18 e7 ff ff       	call   800da8 <sys_page_alloc>
  802690:	83 c4 10             	add    $0x10,%esp
  802693:	85 c0                	test   %eax,%eax
  802695:	78 21                	js     8026b8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026a0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	50                   	push   %eax
  8026b0:	e8 af ee ff ff       	call   801564 <fd2num>
  8026b5:	83 c4 10             	add    $0x10,%esp
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	56                   	push   %esi
  8026be:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8026bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8026c4:	8b 40 48             	mov    0x48(%eax),%eax
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 30 32 80 00       	push   $0x803230
  8026cf:	50                   	push   %eax
  8026d0:	68 2e 2c 80 00       	push   $0x802c2e
  8026d5:	e8 7d db ff ff       	call   800257 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8026da:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026dd:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026e3:	e8 82 e6 ff ff       	call   800d6a <sys_getenvid>
  8026e8:	83 c4 04             	add    $0x4,%esp
  8026eb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ee:	ff 75 08             	pushl  0x8(%ebp)
  8026f1:	56                   	push   %esi
  8026f2:	50                   	push   %eax
  8026f3:	68 0c 32 80 00       	push   $0x80320c
  8026f8:	e8 5a db ff ff       	call   800257 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026fd:	83 c4 18             	add    $0x18,%esp
  802700:	53                   	push   %ebx
  802701:	ff 75 10             	pushl  0x10(%ebp)
  802704:	e8 fd da ff ff       	call   800206 <vcprintf>
	cprintf("\n");
  802709:	c7 04 24 f2 2b 80 00 	movl   $0x802bf2,(%esp)
  802710:	e8 42 db ff ff       	call   800257 <cprintf>
  802715:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802718:	cc                   	int3   
  802719:	eb fd                	jmp    802718 <_panic+0x5e>

0080271b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802721:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802728:	74 0a                	je     802734 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	6a 07                	push   $0x7
  802739:	68 00 f0 bf ee       	push   $0xeebff000
  80273e:	6a 00                	push   $0x0
  802740:	e8 63 e6 ff ff       	call   800da8 <sys_page_alloc>
		if(r < 0)
  802745:	83 c4 10             	add    $0x10,%esp
  802748:	85 c0                	test   %eax,%eax
  80274a:	78 2a                	js     802776 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80274c:	83 ec 08             	sub    $0x8,%esp
  80274f:	68 8a 27 80 00       	push   $0x80278a
  802754:	6a 00                	push   $0x0
  802756:	e8 98 e7 ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	85 c0                	test   %eax,%eax
  802760:	79 c8                	jns    80272a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 68 32 80 00       	push   $0x803268
  80276a:	6a 25                	push   $0x25
  80276c:	68 a4 32 80 00       	push   $0x8032a4
  802771:	e8 44 ff ff ff       	call   8026ba <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 38 32 80 00       	push   $0x803238
  80277e:	6a 22                	push   $0x22
  802780:	68 a4 32 80 00       	push   $0x8032a4
  802785:	e8 30 ff ff ff       	call   8026ba <_panic>

0080278a <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80278a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80278b:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802790:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802792:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802795:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802799:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80279d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027a0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027a2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027a6:	83 c4 08             	add    $0x8,%esp
	popal
  8027a9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027aa:	83 c4 04             	add    $0x4,%esp
	popfl
  8027ad:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027ae:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027af:	c3                   	ret    

008027b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8027b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027be:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027c0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027c5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	50                   	push   %eax
  8027cc:	e8 87 e7 ff ff       	call   800f58 <sys_ipc_recv>
	if(ret < 0){
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	78 2b                	js     802803 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027d8:	85 f6                	test   %esi,%esi
  8027da:	74 0a                	je     8027e6 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8027dc:	a1 08 50 80 00       	mov    0x805008,%eax
  8027e1:	8b 40 74             	mov    0x74(%eax),%eax
  8027e4:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027e6:	85 db                	test   %ebx,%ebx
  8027e8:	74 0a                	je     8027f4 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8027ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ef:	8b 40 78             	mov    0x78(%eax),%eax
  8027f2:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8027f4:	a1 08 50 80 00       	mov    0x805008,%eax
  8027f9:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ff:	5b                   	pop    %ebx
  802800:	5e                   	pop    %esi
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    
		if(from_env_store)
  802803:	85 f6                	test   %esi,%esi
  802805:	74 06                	je     80280d <ipc_recv+0x5d>
			*from_env_store = 0;
  802807:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80280d:	85 db                	test   %ebx,%ebx
  80280f:	74 eb                	je     8027fc <ipc_recv+0x4c>
			*perm_store = 0;
  802811:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802817:	eb e3                	jmp    8027fc <ipc_recv+0x4c>

00802819 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	57                   	push   %edi
  80281d:	56                   	push   %esi
  80281e:	53                   	push   %ebx
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	8b 7d 08             	mov    0x8(%ebp),%edi
  802825:	8b 75 0c             	mov    0xc(%ebp),%esi
  802828:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80282b:	85 db                	test   %ebx,%ebx
  80282d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802832:	0f 44 d8             	cmove  %eax,%ebx
  802835:	eb 05                	jmp    80283c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802837:	e8 4d e5 ff ff       	call   800d89 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80283c:	ff 75 14             	pushl  0x14(%ebp)
  80283f:	53                   	push   %ebx
  802840:	56                   	push   %esi
  802841:	57                   	push   %edi
  802842:	e8 ee e6 ff ff       	call   800f35 <sys_ipc_try_send>
  802847:	83 c4 10             	add    $0x10,%esp
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 1b                	je     802869 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80284e:	79 e7                	jns    802837 <ipc_send+0x1e>
  802850:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802853:	74 e2                	je     802837 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	68 b2 32 80 00       	push   $0x8032b2
  80285d:	6a 46                	push   $0x46
  80285f:	68 c7 32 80 00       	push   $0x8032c7
  802864:	e8 51 fe ff ff       	call   8026ba <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802869:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80286c:	5b                   	pop    %ebx
  80286d:	5e                   	pop    %esi
  80286e:	5f                   	pop    %edi
  80286f:	5d                   	pop    %ebp
  802870:	c3                   	ret    

00802871 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80287c:	89 c2                	mov    %eax,%edx
  80287e:	c1 e2 07             	shl    $0x7,%edx
  802881:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802887:	8b 52 50             	mov    0x50(%edx),%edx
  80288a:	39 ca                	cmp    %ecx,%edx
  80288c:	74 11                	je     80289f <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80288e:	83 c0 01             	add    $0x1,%eax
  802891:	3d 00 04 00 00       	cmp    $0x400,%eax
  802896:	75 e4                	jne    80287c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
  80289d:	eb 0b                	jmp    8028aa <ipc_find_env+0x39>
			return envs[i].env_id;
  80289f:	c1 e0 07             	shl    $0x7,%eax
  8028a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028a7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028aa:	5d                   	pop    %ebp
  8028ab:	c3                   	ret    

008028ac <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	c1 e8 16             	shr    $0x16,%eax
  8028b7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028c3:	f6 c1 01             	test   $0x1,%cl
  8028c6:	74 1d                	je     8028e5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028c8:	c1 ea 0c             	shr    $0xc,%edx
  8028cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028d2:	f6 c2 01             	test   $0x1,%dl
  8028d5:	74 0e                	je     8028e5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028d7:	c1 ea 0c             	shr    $0xc,%edx
  8028da:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028e1:	ef 
  8028e2:	0f b7 c0             	movzwl %ax,%eax
}
  8028e5:	5d                   	pop    %ebp
  8028e6:	c3                   	ret    
  8028e7:	66 90                	xchg   %ax,%ax
  8028e9:	66 90                	xchg   %ax,%ax
  8028eb:	66 90                	xchg   %ax,%ax
  8028ed:	66 90                	xchg   %ax,%ax
  8028ef:	90                   	nop

008028f0 <__udivdi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802903:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802907:	85 d2                	test   %edx,%edx
  802909:	75 4d                	jne    802958 <__udivdi3+0x68>
  80290b:	39 f3                	cmp    %esi,%ebx
  80290d:	76 19                	jbe    802928 <__udivdi3+0x38>
  80290f:	31 ff                	xor    %edi,%edi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f2                	mov    %esi,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 d9                	mov    %ebx,%ecx
  80292a:	85 db                	test   %ebx,%ebx
  80292c:	75 0b                	jne    802939 <__udivdi3+0x49>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f3                	div    %ebx
  802937:	89 c1                	mov    %eax,%ecx
  802939:	31 d2                	xor    %edx,%edx
  80293b:	89 f0                	mov    %esi,%eax
  80293d:	f7 f1                	div    %ecx
  80293f:	89 c6                	mov    %eax,%esi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f7                	mov    %esi,%edi
  802945:	f7 f1                	div    %ecx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	39 f2                	cmp    %esi,%edx
  80295a:	77 1c                	ja     802978 <__udivdi3+0x88>
  80295c:	0f bd fa             	bsr    %edx,%edi
  80295f:	83 f7 1f             	xor    $0x1f,%edi
  802962:	75 2c                	jne    802990 <__udivdi3+0xa0>
  802964:	39 f2                	cmp    %esi,%edx
  802966:	72 06                	jb     80296e <__udivdi3+0x7e>
  802968:	31 c0                	xor    %eax,%eax
  80296a:	39 eb                	cmp    %ebp,%ebx
  80296c:	77 a9                	ja     802917 <__udivdi3+0x27>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	eb a2                	jmp    802917 <__udivdi3+0x27>
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	31 ff                	xor    %edi,%edi
  80297a:	31 c0                	xor    %eax,%eax
  80297c:	89 fa                	mov    %edi,%edx
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	89 f9                	mov    %edi,%ecx
  802992:	b8 20 00 00 00       	mov    $0x20,%eax
  802997:	29 f8                	sub    %edi,%eax
  802999:	d3 e2                	shl    %cl,%edx
  80299b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80299f:	89 c1                	mov    %eax,%ecx
  8029a1:	89 da                	mov    %ebx,%edx
  8029a3:	d3 ea                	shr    %cl,%edx
  8029a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029a9:	09 d1                	or     %edx,%ecx
  8029ab:	89 f2                	mov    %esi,%edx
  8029ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b1:	89 f9                	mov    %edi,%ecx
  8029b3:	d3 e3                	shl    %cl,%ebx
  8029b5:	89 c1                	mov    %eax,%ecx
  8029b7:	d3 ea                	shr    %cl,%edx
  8029b9:	89 f9                	mov    %edi,%ecx
  8029bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029bf:	89 eb                	mov    %ebp,%ebx
  8029c1:	d3 e6                	shl    %cl,%esi
  8029c3:	89 c1                	mov    %eax,%ecx
  8029c5:	d3 eb                	shr    %cl,%ebx
  8029c7:	09 de                	or     %ebx,%esi
  8029c9:	89 f0                	mov    %esi,%eax
  8029cb:	f7 74 24 08          	divl   0x8(%esp)
  8029cf:	89 d6                	mov    %edx,%esi
  8029d1:	89 c3                	mov    %eax,%ebx
  8029d3:	f7 64 24 0c          	mull   0xc(%esp)
  8029d7:	39 d6                	cmp    %edx,%esi
  8029d9:	72 15                	jb     8029f0 <__udivdi3+0x100>
  8029db:	89 f9                	mov    %edi,%ecx
  8029dd:	d3 e5                	shl    %cl,%ebp
  8029df:	39 c5                	cmp    %eax,%ebp
  8029e1:	73 04                	jae    8029e7 <__udivdi3+0xf7>
  8029e3:	39 d6                	cmp    %edx,%esi
  8029e5:	74 09                	je     8029f0 <__udivdi3+0x100>
  8029e7:	89 d8                	mov    %ebx,%eax
  8029e9:	31 ff                	xor    %edi,%edi
  8029eb:	e9 27 ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029f3:	31 ff                	xor    %edi,%edi
  8029f5:	e9 1d ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__umoddi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a17:	89 da                	mov    %ebx,%edx
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 43                	jne    802a60 <__umoddi3+0x60>
  802a1d:	39 df                	cmp    %ebx,%edi
  802a1f:	76 17                	jbe    802a38 <__umoddi3+0x38>
  802a21:	89 f0                	mov    %esi,%eax
  802a23:	f7 f7                	div    %edi
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	31 d2                	xor    %edx,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 fd                	mov    %edi,%ebp
  802a3a:	85 ff                	test   %edi,%edi
  802a3c:	75 0b                	jne    802a49 <__umoddi3+0x49>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	31 d2                	xor    %edx,%edx
  802a45:	f7 f7                	div    %edi
  802a47:	89 c5                	mov    %eax,%ebp
  802a49:	89 d8                	mov    %ebx,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f5                	div    %ebp
  802a4f:	89 f0                	mov    %esi,%eax
  802a51:	f7 f5                	div    %ebp
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	eb d0                	jmp    802a27 <__umoddi3+0x27>
  802a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5e:	66 90                	xchg   %ax,%ax
  802a60:	89 f1                	mov    %esi,%ecx
  802a62:	39 d8                	cmp    %ebx,%eax
  802a64:	76 0a                	jbe    802a70 <__umoddi3+0x70>
  802a66:	89 f0                	mov    %esi,%eax
  802a68:	83 c4 1c             	add    $0x1c,%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    
  802a70:	0f bd e8             	bsr    %eax,%ebp
  802a73:	83 f5 1f             	xor    $0x1f,%ebp
  802a76:	75 20                	jne    802a98 <__umoddi3+0x98>
  802a78:	39 d8                	cmp    %ebx,%eax
  802a7a:	0f 82 b0 00 00 00    	jb     802b30 <__umoddi3+0x130>
  802a80:	39 f7                	cmp    %esi,%edi
  802a82:	0f 86 a8 00 00 00    	jbe    802b30 <__umoddi3+0x130>
  802a88:	89 c8                	mov    %ecx,%eax
  802a8a:	83 c4 1c             	add    $0x1c,%esp
  802a8d:	5b                   	pop    %ebx
  802a8e:	5e                   	pop    %esi
  802a8f:	5f                   	pop    %edi
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a9f:	29 ea                	sub    %ebp,%edx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aa7:	89 d1                	mov    %edx,%ecx
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	d3 e8                	shr    %cl,%eax
  802aad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ab1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ab5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ab9:	09 c1                	or     %eax,%ecx
  802abb:	89 d8                	mov    %ebx,%eax
  802abd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac1:	89 e9                	mov    %ebp,%ecx
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802acf:	d3 e3                	shl    %cl,%ebx
  802ad1:	89 c7                	mov    %eax,%edi
  802ad3:	89 d1                	mov    %edx,%ecx
  802ad5:	89 f0                	mov    %esi,%eax
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 fa                	mov    %edi,%edx
  802add:	d3 e6                	shl    %cl,%esi
  802adf:	09 d8                	or     %ebx,%eax
  802ae1:	f7 74 24 08          	divl   0x8(%esp)
  802ae5:	89 d1                	mov    %edx,%ecx
  802ae7:	89 f3                	mov    %esi,%ebx
  802ae9:	f7 64 24 0c          	mull   0xc(%esp)
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	89 d7                	mov    %edx,%edi
  802af1:	39 d1                	cmp    %edx,%ecx
  802af3:	72 06                	jb     802afb <__umoddi3+0xfb>
  802af5:	75 10                	jne    802b07 <__umoddi3+0x107>
  802af7:	39 c3                	cmp    %eax,%ebx
  802af9:	73 0c                	jae    802b07 <__umoddi3+0x107>
  802afb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b03:	89 d7                	mov    %edx,%edi
  802b05:	89 c6                	mov    %eax,%esi
  802b07:	89 ca                	mov    %ecx,%edx
  802b09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b0e:	29 f3                	sub    %esi,%ebx
  802b10:	19 fa                	sbb    %edi,%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	d3 e0                	shl    %cl,%eax
  802b16:	89 e9                	mov    %ebp,%ecx
  802b18:	d3 eb                	shr    %cl,%ebx
  802b1a:	d3 ea                	shr    %cl,%edx
  802b1c:	09 d8                	or     %ebx,%eax
  802b1e:	83 c4 1c             	add    $0x1c,%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	89 da                	mov    %ebx,%edx
  802b32:	29 fe                	sub    %edi,%esi
  802b34:	19 c2                	sbb    %eax,%edx
  802b36:	89 f1                	mov    %esi,%ecx
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	e9 4b ff ff ff       	jmp    802a8a <__umoddi3+0x8a>
