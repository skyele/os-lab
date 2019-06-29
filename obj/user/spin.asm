
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
  80003a:	68 e0 2a 80 00       	push   $0x802ae0
  80003f:	e8 83 01 00 00       	call   8001c7 <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 19 12 00 00       	call   801262 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 58 2b 80 00       	push   $0x802b58
  800058:	e8 6a 01 00 00       	call   8001c7 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 08 2b 80 00       	push   $0x802b08
  80006c:	e8 56 01 00 00       	call   8001c7 <cprintf>
	sys_yield();
  800071:	e8 83 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  800076:	e8 7e 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  80007b:	e8 79 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  800080:	e8 74 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  800085:	e8 6f 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  80008a:	e8 6a 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  80008f:	e8 65 0c 00 00       	call   800cf9 <sys_yield>
	sys_yield();
  800094:	e8 60 0c 00 00       	call   800cf9 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 30 2b 80 00 	movl   $0x802b30,(%esp)
  8000a0:	e8 22 01 00 00       	call   8001c7 <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 ec 0b 00 00       	call   800c99 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000c0:	e8 15 0c 00 00       	call   800cda <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d5:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000da:	85 db                	test   %ebx,%ebx
  8000dc:	7e 07                	jle    8000e5 <libmain+0x30>
		binaryname = argv[0];
  8000de:	8b 06                	mov    (%esi),%eax
  8000e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000e5:	83 ec 08             	sub    $0x8,%esp
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	e8 44 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ef:	e8 0a 00 00 00       	call   8000fe <exit>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800104:	a1 08 50 80 00       	mov    0x805008,%eax
  800109:	8b 40 48             	mov    0x48(%eax),%eax
  80010c:	68 8c 2b 80 00       	push   $0x802b8c
  800111:	50                   	push   %eax
  800112:	68 80 2b 80 00       	push   $0x802b80
  800117:	e8 ab 00 00 00       	call   8001c7 <cprintf>
	close_all();
  80011c:	e8 b1 15 00 00       	call   8016d2 <close_all>
	sys_env_destroy(0);
  800121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800128:	e8 6c 0b 00 00       	call   800c99 <sys_env_destroy>
}
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	c9                   	leave  
  800131:	c3                   	ret    

00800132 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	53                   	push   %ebx
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013c:	8b 13                	mov    (%ebx),%edx
  80013e:	8d 42 01             	lea    0x1(%edx),%eax
  800141:	89 03                	mov    %eax,(%ebx)
  800143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800146:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80014a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014f:	74 09                	je     80015a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800151:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800158:	c9                   	leave  
  800159:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	68 ff 00 00 00       	push   $0xff
  800162:	8d 43 08             	lea    0x8(%ebx),%eax
  800165:	50                   	push   %eax
  800166:	e8 f1 0a 00 00       	call   800c5c <sys_cputs>
		b->idx = 0;
  80016b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	eb db                	jmp    800151 <putch+0x1f>

00800176 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80017f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800186:	00 00 00 
	b.cnt = 0;
  800189:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800190:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	ff 75 08             	pushl  0x8(%ebp)
  800199:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	68 32 01 80 00       	push   $0x800132
  8001a5:	e8 4a 01 00 00       	call   8002f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001aa:	83 c4 08             	add    $0x8,%esp
  8001ad:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 9d 0a 00 00       	call   800c5c <sys_cputs>

	return b.cnt;
}
  8001bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d0:	50                   	push   %eax
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 9d ff ff ff       	call   800176 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

008001db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 1c             	sub    $0x1c,%esp
  8001e4:	89 c6                	mov    %eax,%esi
  8001e6:	89 d7                	mov    %edx,%edi
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001fa:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001fe:	74 2c                	je     80022c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800200:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80020a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80020d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800210:	39 c2                	cmp    %eax,%edx
  800212:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800215:	73 43                	jae    80025a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7e 6c                	jle    80028a <printnum+0xaf>
				putch(padc, putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	57                   	push   %edi
  800222:	ff 75 18             	pushl  0x18(%ebp)
  800225:	ff d6                	call   *%esi
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb eb                	jmp    800217 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	6a 20                	push   $0x20
  800231:	6a 00                	push   $0x0
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	ff 75 e0             	pushl  -0x20(%ebp)
  80023a:	89 fa                	mov    %edi,%edx
  80023c:	89 f0                	mov    %esi,%eax
  80023e:	e8 98 ff ff ff       	call   8001db <printnum>
		while (--width > 0)
  800243:	83 c4 20             	add    $0x20,%esp
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	85 db                	test   %ebx,%ebx
  80024b:	7e 65                	jle    8002b2 <printnum+0xd7>
			putch(padc, putdat);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	57                   	push   %edi
  800251:	6a 20                	push   $0x20
  800253:	ff d6                	call   *%esi
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	eb ec                	jmp    800246 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	ff 75 18             	pushl  0x18(%ebp)
  800260:	83 eb 01             	sub    $0x1,%ebx
  800263:	53                   	push   %ebx
  800264:	50                   	push   %eax
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 dc             	pushl  -0x24(%ebp)
  80026b:	ff 75 d8             	pushl  -0x28(%ebp)
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	e8 17 26 00 00       	call   802890 <__udivdi3>
  800279:	83 c4 18             	add    $0x18,%esp
  80027c:	52                   	push   %edx
  80027d:	50                   	push   %eax
  80027e:	89 fa                	mov    %edi,%edx
  800280:	89 f0                	mov    %esi,%eax
  800282:	e8 54 ff ff ff       	call   8001db <printnum>
  800287:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	57                   	push   %edi
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 dc             	pushl  -0x24(%ebp)
  800294:	ff 75 d8             	pushl  -0x28(%ebp)
  800297:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029a:	ff 75 e0             	pushl  -0x20(%ebp)
  80029d:	e8 fe 26 00 00       	call   8029a0 <__umoddi3>
  8002a2:	83 c4 14             	add    $0x14,%esp
  8002a5:	0f be 80 91 2b 80 00 	movsbl 0x802b91(%eax),%eax
  8002ac:	50                   	push   %eax
  8002ad:	ff d6                	call   *%esi
  8002af:	83 c4 10             	add    $0x10,%esp
	}
}
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c4:	8b 10                	mov    (%eax),%edx
  8002c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c9:	73 0a                	jae    8002d5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	88 02                	mov    %al,(%edx)
}
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <printfmt>:
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e0:	50                   	push   %eax
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	ff 75 0c             	pushl  0xc(%ebp)
  8002e7:	ff 75 08             	pushl  0x8(%ebp)
  8002ea:	e8 05 00 00 00       	call   8002f4 <vprintfmt>
}
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <vprintfmt>:
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 3c             	sub    $0x3c,%esp
  8002fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800303:	8b 7d 10             	mov    0x10(%ebp),%edi
  800306:	e9 32 04 00 00       	jmp    80073d <vprintfmt+0x449>
		padc = ' ';
  80030b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80030f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800316:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80031d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8d 47 01             	lea    0x1(%edi),%eax
  80033a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033d:	0f b6 17             	movzbl (%edi),%edx
  800340:	8d 42 dd             	lea    -0x23(%edx),%eax
  800343:	3c 55                	cmp    $0x55,%al
  800345:	0f 87 12 05 00 00    	ja     80085d <vprintfmt+0x569>
  80034b:	0f b6 c0             	movzbl %al,%eax
  80034e:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800358:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80035c:	eb d9                	jmp    800337 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800361:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800365:	eb d0                	jmp    800337 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800367:	0f b6 d2             	movzbl %dl,%edx
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	89 75 08             	mov    %esi,0x8(%ebp)
  800375:	eb 03                	jmp    80037a <vprintfmt+0x86>
  800377:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80037d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800381:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800384:	8d 72 d0             	lea    -0x30(%edx),%esi
  800387:	83 fe 09             	cmp    $0x9,%esi
  80038a:	76 eb                	jbe    800377 <vprintfmt+0x83>
  80038c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038f:	8b 75 08             	mov    0x8(%ebp),%esi
  800392:	eb 14                	jmp    8003a8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8d 40 04             	lea    0x4(%eax),%eax
  8003a2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ac:	79 89                	jns    800337 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003bb:	e9 77 ff ff ff       	jmp    800337 <vprintfmt+0x43>
  8003c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c3:	85 c0                	test   %eax,%eax
  8003c5:	0f 48 c1             	cmovs  %ecx,%eax
  8003c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ce:	e9 64 ff ff ff       	jmp    800337 <vprintfmt+0x43>
  8003d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003dd:	e9 55 ff ff ff       	jmp    800337 <vprintfmt+0x43>
			lflag++;
  8003e2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e9:	e9 49 ff ff ff       	jmp    800337 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f1:	8d 78 04             	lea    0x4(%eax),%edi
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	53                   	push   %ebx
  8003f8:	ff 30                	pushl  (%eax)
  8003fa:	ff d6                	call   *%esi
			break;
  8003fc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ff:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800402:	e9 33 03 00 00       	jmp    80073a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8d 78 04             	lea    0x4(%eax),%edi
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	99                   	cltd   
  800410:	31 d0                	xor    %edx,%eax
  800412:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800414:	83 f8 11             	cmp    $0x11,%eax
  800417:	7f 23                	jg     80043c <vprintfmt+0x148>
  800419:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800420:	85 d2                	test   %edx,%edx
  800422:	74 18                	je     80043c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800424:	52                   	push   %edx
  800425:	68 cd 30 80 00       	push   $0x8030cd
  80042a:	53                   	push   %ebx
  80042b:	56                   	push   %esi
  80042c:	e8 a6 fe ff ff       	call   8002d7 <printfmt>
  800431:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800434:	89 7d 14             	mov    %edi,0x14(%ebp)
  800437:	e9 fe 02 00 00       	jmp    80073a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80043c:	50                   	push   %eax
  80043d:	68 a9 2b 80 00       	push   $0x802ba9
  800442:	53                   	push   %ebx
  800443:	56                   	push   %esi
  800444:	e8 8e fe ff ff       	call   8002d7 <printfmt>
  800449:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044f:	e9 e6 02 00 00       	jmp    80073a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	83 c0 04             	add    $0x4,%eax
  80045a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80045d:	8b 45 14             	mov    0x14(%ebp),%eax
  800460:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800462:	85 c9                	test   %ecx,%ecx
  800464:	b8 a2 2b 80 00       	mov    $0x802ba2,%eax
  800469:	0f 45 c1             	cmovne %ecx,%eax
  80046c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80046f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800473:	7e 06                	jle    80047b <vprintfmt+0x187>
  800475:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800479:	75 0d                	jne    800488 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80047e:	89 c7                	mov    %eax,%edi
  800480:	03 45 e0             	add    -0x20(%ebp),%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800486:	eb 53                	jmp    8004db <vprintfmt+0x1e7>
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	ff 75 d8             	pushl  -0x28(%ebp)
  80048e:	50                   	push   %eax
  80048f:	e8 71 04 00 00       	call   800905 <strnlen>
  800494:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800497:	29 c1                	sub    %eax,%ecx
  800499:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004a1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a8:	eb 0f                	jmp    8004b9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	53                   	push   %ebx
  8004ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	83 ef 01             	sub    $0x1,%edi
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	85 ff                	test   %edi,%edi
  8004bb:	7f ed                	jg     8004aa <vprintfmt+0x1b6>
  8004bd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004c0:	85 c9                	test   %ecx,%ecx
  8004c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c7:	0f 49 c1             	cmovns %ecx,%eax
  8004ca:	29 c1                	sub    %eax,%ecx
  8004cc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004cf:	eb aa                	jmp    80047b <vprintfmt+0x187>
					putch(ch, putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	52                   	push   %edx
  8004d6:	ff d6                	call   *%esi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004de:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 c7 01             	add    $0x1,%edi
  8004e3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e7:	0f be d0             	movsbl %al,%edx
  8004ea:	85 d2                	test   %edx,%edx
  8004ec:	74 4b                	je     800539 <vprintfmt+0x245>
  8004ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f2:	78 06                	js     8004fa <vprintfmt+0x206>
  8004f4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f8:	78 1e                	js     800518 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004fa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004fe:	74 d1                	je     8004d1 <vprintfmt+0x1dd>
  800500:	0f be c0             	movsbl %al,%eax
  800503:	83 e8 20             	sub    $0x20,%eax
  800506:	83 f8 5e             	cmp    $0x5e,%eax
  800509:	76 c6                	jbe    8004d1 <vprintfmt+0x1dd>
					putch('?', putdat);
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	53                   	push   %ebx
  80050f:	6a 3f                	push   $0x3f
  800511:	ff d6                	call   *%esi
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	eb c3                	jmp    8004db <vprintfmt+0x1e7>
  800518:	89 cf                	mov    %ecx,%edi
  80051a:	eb 0e                	jmp    80052a <vprintfmt+0x236>
				putch(' ', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 20                	push   $0x20
  800522:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800524:	83 ef 01             	sub    $0x1,%edi
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 ff                	test   %edi,%edi
  80052c:	7f ee                	jg     80051c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80052e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800531:	89 45 14             	mov    %eax,0x14(%ebp)
  800534:	e9 01 02 00 00       	jmp    80073a <vprintfmt+0x446>
  800539:	89 cf                	mov    %ecx,%edi
  80053b:	eb ed                	jmp    80052a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800540:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800547:	e9 eb fd ff ff       	jmp    800337 <vprintfmt+0x43>
	if (lflag >= 2)
  80054c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800550:	7f 21                	jg     800573 <vprintfmt+0x27f>
	else if (lflag)
  800552:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800556:	74 68                	je     8005c0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800560:	89 c1                	mov    %eax,%ecx
  800562:	c1 f9 1f             	sar    $0x1f,%ecx
  800565:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 04             	lea    0x4(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	eb 17                	jmp    80058a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 50 04             	mov    0x4(%eax),%edx
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80057e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 08             	lea    0x8(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80058a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80058d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800590:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800593:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800596:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80059a:	78 3f                	js     8005db <vprintfmt+0x2e7>
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005a1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005a5:	0f 84 71 01 00 00    	je     80071c <vprintfmt+0x428>
				putch('+', putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	53                   	push   %ebx
  8005af:	6a 2b                	push   $0x2b
  8005b1:	ff d6                	call   *%esi
  8005b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bb:	e9 5c 01 00 00       	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c8:	89 c1                	mov    %eax,%ecx
  8005ca:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8d 40 04             	lea    0x4(%eax),%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d9:	eb af                	jmp    80058a <vprintfmt+0x296>
				putch('-', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 2d                	push   $0x2d
  8005e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e9:	f7 d8                	neg    %eax
  8005eb:	83 d2 00             	adc    $0x0,%edx
  8005ee:	f7 da                	neg    %edx
  8005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fe:	e9 19 01 00 00       	jmp    80071c <vprintfmt+0x428>
	if (lflag >= 2)
  800603:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800607:	7f 29                	jg     800632 <vprintfmt+0x33e>
	else if (lflag)
  800609:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060d:	74 44                	je     800653 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	ba 00 00 00 00       	mov    $0x0,%edx
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062d:	e9 ea 00 00 00       	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 50 04             	mov    0x4(%eax),%edx
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 40 08             	lea    0x8(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800649:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064e:	e9 c9 00 00 00       	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	ba 00 00 00 00       	mov    $0x0,%edx
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800671:	e9 a6 00 00 00       	jmp    80071c <vprintfmt+0x428>
			putch('0', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 30                	push   $0x30
  80067c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800685:	7f 26                	jg     8006ad <vprintfmt+0x3b9>
	else if (lflag)
  800687:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80068b:	74 3e                	je     8006cb <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ab:	eb 6f                	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 50 04             	mov    0x4(%eax),%edx
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 08             	lea    0x8(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c9:	eb 51                	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e9:	eb 31                	jmp    80071c <vprintfmt+0x428>
			putch('0', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 30                	push   $0x30
  8006f1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f3:	83 c4 08             	add    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 78                	push   $0x78
  8006f9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80070b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800723:	52                   	push   %edx
  800724:	ff 75 e0             	pushl  -0x20(%ebp)
  800727:	50                   	push   %eax
  800728:	ff 75 dc             	pushl  -0x24(%ebp)
  80072b:	ff 75 d8             	pushl  -0x28(%ebp)
  80072e:	89 da                	mov    %ebx,%edx
  800730:	89 f0                	mov    %esi,%eax
  800732:	e8 a4 fa ff ff       	call   8001db <printnum>
			break;
  800737:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80073a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073d:	83 c7 01             	add    $0x1,%edi
  800740:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800744:	83 f8 25             	cmp    $0x25,%eax
  800747:	0f 84 be fb ff ff    	je     80030b <vprintfmt+0x17>
			if (ch == '\0')
  80074d:	85 c0                	test   %eax,%eax
  80074f:	0f 84 28 01 00 00    	je     80087d <vprintfmt+0x589>
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	50                   	push   %eax
  80075a:	ff d6                	call   *%esi
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	eb dc                	jmp    80073d <vprintfmt+0x449>
	if (lflag >= 2)
  800761:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800765:	7f 26                	jg     80078d <vprintfmt+0x499>
	else if (lflag)
  800767:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80076b:	74 41                	je     8007ae <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800786:	b8 10 00 00 00       	mov    $0x10,%eax
  80078b:	eb 8f                	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 50 04             	mov    0x4(%eax),%edx
  800793:	8b 00                	mov    (%eax),%eax
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a9:	e9 6e ff ff ff       	jmp    80071c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 40 04             	lea    0x4(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cc:	e9 4b ff ff ff       	jmp    80071c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 c0 04             	add    $0x4,%eax
  8007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	74 14                	je     8007f7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007e3:	8b 13                	mov    (%ebx),%edx
  8007e5:	83 fa 7f             	cmp    $0x7f,%edx
  8007e8:	7f 37                	jg     800821 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007ea:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f2:	e9 43 ff ff ff       	jmp    80073a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fc:	bf c5 2c 80 00       	mov    $0x802cc5,%edi
							putch(ch, putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	50                   	push   %eax
  800806:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800808:	83 c7 01             	add    $0x1,%edi
  80080b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	85 c0                	test   %eax,%eax
  800814:	75 eb                	jne    800801 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	e9 19 ff ff ff       	jmp    80073a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800821:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
  800828:	bf fd 2c 80 00       	mov    $0x802cfd,%edi
							putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	53                   	push   %ebx
  800831:	50                   	push   %eax
  800832:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800834:	83 c7 01             	add    $0x1,%edi
  800837:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	85 c0                	test   %eax,%eax
  800840:	75 eb                	jne    80082d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800842:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	e9 ed fe ff ff       	jmp    80073a <vprintfmt+0x446>
			putch(ch, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 25                	push   $0x25
  800853:	ff d6                	call   *%esi
			break;
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	e9 dd fe ff ff       	jmp    80073a <vprintfmt+0x446>
			putch('%', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 25                	push   $0x25
  800863:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	89 f8                	mov    %edi,%eax
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x57b>
  80086c:	83 e8 01             	sub    $0x1,%eax
  80086f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800873:	75 f7                	jne    80086c <vprintfmt+0x578>
  800875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800878:	e9 bd fe ff ff       	jmp    80073a <vprintfmt+0x446>
}
  80087d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800880:	5b                   	pop    %ebx
  800881:	5e                   	pop    %esi
  800882:	5f                   	pop    %edi
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800894:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800898:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 26                	je     8008cc <vsnprintf+0x47>
  8008a6:	85 d2                	test   %edx,%edx
  8008a8:	7e 22                	jle    8008cc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008aa:	ff 75 14             	pushl  0x14(%ebp)
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	50                   	push   %eax
  8008b4:	68 ba 02 80 00       	push   $0x8002ba
  8008b9:	e8 36 fa ff ff       	call   8002f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    
		return -E_INVAL;
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb f7                	jmp    8008ca <vsnprintf+0x45>

008008d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 10             	pushl  0x10(%ebp)
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 9a ff ff ff       	call   800885 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    

008008ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fc:	74 05                	je     800903 <strlen+0x16>
		n++;
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	eb f5                	jmp    8008f8 <strlen+0xb>
	return n;
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	39 c2                	cmp    %eax,%edx
  800915:	74 0d                	je     800924 <strnlen+0x1f>
  800917:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80091b:	74 05                	je     800922 <strnlen+0x1d>
		n++;
  80091d:	83 c2 01             	add    $0x1,%edx
  800920:	eb f1                	jmp    800913 <strnlen+0xe>
  800922:	89 d0                	mov    %edx,%eax
	return n;
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800939:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 f2                	jne    800935 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
  80094a:	83 ec 10             	sub    $0x10,%esp
  80094d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800950:	53                   	push   %ebx
  800951:	e8 97 ff ff ff       	call   8008ed <strlen>
  800956:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	01 d8                	add    %ebx,%eax
  80095e:	50                   	push   %eax
  80095f:	e8 c2 ff ff ff       	call   800926 <strcpy>
	return dst;
}
  800964:	89 d8                	mov    %ebx,%eax
  800966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800976:	89 c6                	mov    %eax,%esi
  800978:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097b:	89 c2                	mov    %eax,%edx
  80097d:	39 f2                	cmp    %esi,%edx
  80097f:	74 11                	je     800992 <strncpy+0x27>
		*dst++ = *src;
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	0f b6 19             	movzbl (%ecx),%ebx
  800987:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098a:	80 fb 01             	cmp    $0x1,%bl
  80098d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800990:	eb eb                	jmp    80097d <strncpy+0x12>
	}
	return ret;
}
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 75 08             	mov    0x8(%ebp),%esi
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009a4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a6:	85 d2                	test   %edx,%edx
  8009a8:	74 21                	je     8009cb <strlcpy+0x35>
  8009aa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ae:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	74 14                	je     8009c8 <strlcpy+0x32>
  8009b4:	0f b6 19             	movzbl (%ecx),%ebx
  8009b7:	84 db                	test   %bl,%bl
  8009b9:	74 0b                	je     8009c6 <strlcpy+0x30>
			*dst++ = *src++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c4:	eb ea                	jmp    8009b0 <strlcpy+0x1a>
  8009c6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009cb:	29 f0                	sub    %esi,%eax
}
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009da:	0f b6 01             	movzbl (%ecx),%eax
  8009dd:	84 c0                	test   %al,%al
  8009df:	74 0c                	je     8009ed <strcmp+0x1c>
  8009e1:	3a 02                	cmp    (%edx),%al
  8009e3:	75 08                	jne    8009ed <strcmp+0x1c>
		p++, q++;
  8009e5:	83 c1 01             	add    $0x1,%ecx
  8009e8:	83 c2 01             	add    $0x1,%edx
  8009eb:	eb ed                	jmp    8009da <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ed:	0f b6 c0             	movzbl %al,%eax
  8009f0:	0f b6 12             	movzbl (%edx),%edx
  8009f3:	29 d0                	sub    %edx,%eax
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	89 c3                	mov    %eax,%ebx
  800a03:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a06:	eb 06                	jmp    800a0e <strncmp+0x17>
		n--, p++, q++;
  800a08:	83 c0 01             	add    $0x1,%eax
  800a0b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a0e:	39 d8                	cmp    %ebx,%eax
  800a10:	74 16                	je     800a28 <strncmp+0x31>
  800a12:	0f b6 08             	movzbl (%eax),%ecx
  800a15:	84 c9                	test   %cl,%cl
  800a17:	74 04                	je     800a1d <strncmp+0x26>
  800a19:	3a 0a                	cmp    (%edx),%cl
  800a1b:	74 eb                	je     800a08 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 00             	movzbl (%eax),%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    
		return 0;
  800a28:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2d:	eb f6                	jmp    800a25 <strncmp+0x2e>

00800a2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a39:	0f b6 10             	movzbl (%eax),%edx
  800a3c:	84 d2                	test   %dl,%dl
  800a3e:	74 09                	je     800a49 <strchr+0x1a>
		if (*s == c)
  800a40:	38 ca                	cmp    %cl,%dl
  800a42:	74 0a                	je     800a4e <strchr+0x1f>
	for (; *s; s++)
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	eb f0                	jmp    800a39 <strchr+0xa>
			return (char *) s;
	return 0;
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5d:	38 ca                	cmp    %cl,%dl
  800a5f:	74 09                	je     800a6a <strfind+0x1a>
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 05                	je     800a6a <strfind+0x1a>
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f0                	jmp    800a5a <strfind+0xa>
			break;
	return (char *) s;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a78:	85 c9                	test   %ecx,%ecx
  800a7a:	74 31                	je     800aad <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7c:	89 f8                	mov    %edi,%eax
  800a7e:	09 c8                	or     %ecx,%eax
  800a80:	a8 03                	test   $0x3,%al
  800a82:	75 23                	jne    800aa7 <memset+0x3b>
		c &= 0xFF;
  800a84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a88:	89 d3                	mov    %edx,%ebx
  800a8a:	c1 e3 08             	shl    $0x8,%ebx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	c1 e0 18             	shl    $0x18,%eax
  800a92:	89 d6                	mov    %edx,%esi
  800a94:	c1 e6 10             	shl    $0x10,%esi
  800a97:	09 f0                	or     %esi,%eax
  800a99:	09 c2                	or     %eax,%edx
  800a9b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a9d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa0:	89 d0                	mov    %edx,%eax
  800aa2:	fc                   	cld    
  800aa3:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa5:	eb 06                	jmp    800aad <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	fc                   	cld    
  800aab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5f                   	pop    %edi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac2:	39 c6                	cmp    %eax,%esi
  800ac4:	73 32                	jae    800af8 <memmove+0x44>
  800ac6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	76 2b                	jbe    800af8 <memmove+0x44>
		s += n;
		d += n;
  800acd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	89 fe                	mov    %edi,%esi
  800ad2:	09 ce                	or     %ecx,%esi
  800ad4:	09 d6                	or     %edx,%esi
  800ad6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800adc:	75 0e                	jne    800aec <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ade:	83 ef 04             	sub    $0x4,%edi
  800ae1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae7:	fd                   	std    
  800ae8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aea:	eb 09                	jmp    800af5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aec:	83 ef 01             	sub    $0x1,%edi
  800aef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af2:	fd                   	std    
  800af3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af5:	fc                   	cld    
  800af6:	eb 1a                	jmp    800b12 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	09 ca                	or     %ecx,%edx
  800afc:	09 f2                	or     %esi,%edx
  800afe:	f6 c2 03             	test   $0x3,%dl
  800b01:	75 0a                	jne    800b0d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b06:	89 c7                	mov    %eax,%edi
  800b08:	fc                   	cld    
  800b09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0b:	eb 05                	jmp    800b12 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b0d:	89 c7                	mov    %eax,%edi
  800b0f:	fc                   	cld    
  800b10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 8a ff ff ff       	call   800ab4 <memmove>
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 c6                	mov    %eax,%esi
  800b39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3c:	39 f0                	cmp    %esi,%eax
  800b3e:	74 1c                	je     800b5c <memcmp+0x30>
		if (*s1 != *s2)
  800b40:	0f b6 08             	movzbl (%eax),%ecx
  800b43:	0f b6 1a             	movzbl (%edx),%ebx
  800b46:	38 d9                	cmp    %bl,%cl
  800b48:	75 08                	jne    800b52 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	83 c2 01             	add    $0x1,%edx
  800b50:	eb ea                	jmp    800b3c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b52:	0f b6 c1             	movzbl %cl,%eax
  800b55:	0f b6 db             	movzbl %bl,%ebx
  800b58:	29 d8                	sub    %ebx,%eax
  800b5a:	eb 05                	jmp    800b61 <memcmp+0x35>
	}

	return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b73:	39 d0                	cmp    %edx,%eax
  800b75:	73 09                	jae    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b77:	38 08                	cmp    %cl,(%eax)
  800b79:	74 05                	je     800b80 <memfind+0x1b>
	for (; s < ends; s++)
  800b7b:	83 c0 01             	add    $0x1,%eax
  800b7e:	eb f3                	jmp    800b73 <memfind+0xe>
			break;
	return (void *) s;
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8e:	eb 03                	jmp    800b93 <strtol+0x11>
		s++;
  800b90:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b93:	0f b6 01             	movzbl (%ecx),%eax
  800b96:	3c 20                	cmp    $0x20,%al
  800b98:	74 f6                	je     800b90 <strtol+0xe>
  800b9a:	3c 09                	cmp    $0x9,%al
  800b9c:	74 f2                	je     800b90 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9e:	3c 2b                	cmp    $0x2b,%al
  800ba0:	74 2a                	je     800bcc <strtol+0x4a>
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba7:	3c 2d                	cmp    $0x2d,%al
  800ba9:	74 2b                	je     800bd6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb1:	75 0f                	jne    800bc2 <strtol+0x40>
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 28                	je     800be0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bbf:	0f 44 d8             	cmove  %eax,%ebx
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bca:	eb 50                	jmp    800c1c <strtol+0x9a>
		s++;
  800bcc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd4:	eb d5                	jmp    800bab <strtol+0x29>
		s++, neg = 1;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bde:	eb cb                	jmp    800bab <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be4:	74 0e                	je     800bf4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	75 d8                	jne    800bc2 <strtol+0x40>
		s++, base = 8;
  800bea:	83 c1 01             	add    $0x1,%ecx
  800bed:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf2:	eb ce                	jmp    800bc2 <strtol+0x40>
		s += 2, base = 16;
  800bf4:	83 c1 02             	add    $0x2,%ecx
  800bf7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bfc:	eb c4                	jmp    800bc2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bfe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 29                	ja     800c31 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c11:	7d 30                	jge    800c43 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1c:	0f b6 11             	movzbl (%ecx),%edx
  800c1f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c22:	89 f3                	mov    %esi,%ebx
  800c24:	80 fb 09             	cmp    $0x9,%bl
  800c27:	77 d5                	ja     800bfe <strtol+0x7c>
			dig = *s - '0';
  800c29:	0f be d2             	movsbl %dl,%edx
  800c2c:	83 ea 30             	sub    $0x30,%edx
  800c2f:	eb dd                	jmp    800c0e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c31:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 19             	cmp    $0x19,%bl
  800c39:	77 08                	ja     800c43 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 37             	sub    $0x37,%edx
  800c41:	eb cb                	jmp    800c0e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c47:	74 05                	je     800c4e <strtol+0xcc>
		*endptr = (char *) s;
  800c49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	f7 da                	neg    %edx
  800c52:	85 ff                	test   %edi,%edi
  800c54:	0f 45 c2             	cmovne %edx,%eax
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	89 c3                	mov    %eax,%ebx
  800c6f:	89 c7                	mov    %eax,%edi
  800c71:	89 c6                	mov    %eax,%esi
  800c73:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	b8 03 00 00 00       	mov    $0x3,%eax
  800caf:	89 cb                	mov    %ecx,%ebx
  800cb1:	89 cf                	mov    %ecx,%edi
  800cb3:	89 ce                	mov    %ecx,%esi
  800cb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	7f 08                	jg     800cc3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc3:	83 ec 0c             	sub    $0xc,%esp
  800cc6:	50                   	push   %eax
  800cc7:	6a 03                	push   $0x3
  800cc9:	68 08 2f 80 00       	push   $0x802f08
  800cce:	6a 43                	push   $0x43
  800cd0:	68 25 2f 80 00       	push   $0x802f25
  800cd5:	e8 76 19 00 00       	call   802650 <_panic>

00800cda <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_yield>:

void
sys_yield(void)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
  800d04:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d09:	89 d1                	mov    %edx,%ecx
  800d0b:	89 d3                	mov    %edx,%ebx
  800d0d:	89 d7                	mov    %edx,%edi
  800d0f:	89 d6                	mov    %edx,%esi
  800d11:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d21:	be 00 00 00 00       	mov    $0x0,%esi
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d34:	89 f7                	mov    %esi,%edi
  800d36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	50                   	push   %eax
  800d48:	6a 04                	push   $0x4
  800d4a:	68 08 2f 80 00       	push   $0x802f08
  800d4f:	6a 43                	push   $0x43
  800d51:	68 25 2f 80 00       	push   $0x802f25
  800d56:	e8 f5 18 00 00       	call   802650 <_panic>

00800d5b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d72:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d75:	8b 75 18             	mov    0x18(%ebp),%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 05                	push   $0x5
  800d8c:	68 08 2f 80 00       	push   $0x802f08
  800d91:	6a 43                	push   $0x43
  800d93:	68 25 2f 80 00       	push   $0x802f25
  800d98:	e8 b3 18 00 00       	call   802650 <_panic>

00800d9d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	b8 06 00 00 00       	mov    $0x6,%eax
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7f 08                	jg     800dc8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 06                	push   $0x6
  800dce:	68 08 2f 80 00       	push   $0x802f08
  800dd3:	6a 43                	push   $0x43
  800dd5:	68 25 2f 80 00       	push   $0x802f25
  800dda:	e8 71 18 00 00       	call   802650 <_panic>

00800ddf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	b8 08 00 00 00       	mov    $0x8,%eax
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	89 de                	mov    %ebx,%esi
  800dfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7f 08                	jg     800e0a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 08                	push   $0x8
  800e10:	68 08 2f 80 00       	push   $0x802f08
  800e15:	6a 43                	push   $0x43
  800e17:	68 25 2f 80 00       	push   $0x802f25
  800e1c:	e8 2f 18 00 00       	call   802650 <_panic>

00800e21 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 09 00 00 00       	mov    $0x9,%eax
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	89 de                	mov    %ebx,%esi
  800e3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 09                	push   $0x9
  800e52:	68 08 2f 80 00       	push   $0x802f08
  800e57:	6a 43                	push   $0x43
  800e59:	68 25 2f 80 00       	push   $0x802f25
  800e5e:	e8 ed 17 00 00       	call   802650 <_panic>

00800e63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7c:	89 df                	mov    %ebx,%edi
  800e7e:	89 de                	mov    %ebx,%esi
  800e80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7f 08                	jg     800e8e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 0a                	push   $0xa
  800e94:	68 08 2f 80 00       	push   $0x802f08
  800e99:	6a 43                	push   $0x43
  800e9b:	68 25 2f 80 00       	push   $0x802f25
  800ea0:	e8 ab 17 00 00       	call   802650 <_panic>

00800ea5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	be 00 00 00 00       	mov    $0x0,%esi
  800ebb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
  800ece:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ede:	89 cb                	mov    %ecx,%ebx
  800ee0:	89 cf                	mov    %ecx,%edi
  800ee2:	89 ce                	mov    %ecx,%esi
  800ee4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 0d                	push   $0xd
  800ef8:	68 08 2f 80 00       	push   $0x802f08
  800efd:	6a 43                	push   $0x43
  800eff:	68 25 2f 80 00       	push   $0x802f25
  800f04:	e8 47 17 00 00       	call   802650 <_panic>

00800f09 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3d:	89 cb                	mov    %ecx,%ebx
  800f3f:	89 cf                	mov    %ecx,%edi
  800f41:	89 ce                	mov    %ecx,%esi
  800f43:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f50:	ba 00 00 00 00       	mov    $0x0,%edx
  800f55:	b8 10 00 00 00       	mov    $0x10,%eax
  800f5a:	89 d1                	mov    %edx,%ecx
  800f5c:	89 d3                	mov    %edx,%ebx
  800f5e:	89 d7                	mov    %edx,%edi
  800f60:	89 d6                	mov    %edx,%esi
  800f62:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 11 00 00 00       	mov    $0x11,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	b8 12 00 00 00       	mov    $0x12,%eax
  800fa0:	89 df                	mov    %ebx,%edi
  800fa2:	89 de                	mov    %ebx,%esi
  800fa4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
  800fb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	b8 13 00 00 00       	mov    $0x13,%eax
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	7f 08                	jg     800fd6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	50                   	push   %eax
  800fda:	6a 13                	push   $0x13
  800fdc:	68 08 2f 80 00       	push   $0x802f08
  800fe1:	6a 43                	push   $0x43
  800fe3:	68 25 2f 80 00       	push   $0x802f25
  800fe8:	e8 63 16 00 00       	call   802650 <_panic>

00800fed <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	b8 14 00 00 00       	mov    $0x14,%eax
  801000:	89 cb                	mov    %ecx,%ebx
  801002:	89 cf                	mov    %ecx,%edi
  801004:	89 ce                	mov    %ecx,%esi
  801006:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	53                   	push   %ebx
  801011:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801014:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80101b:	f6 c5 04             	test   $0x4,%ch
  80101e:	75 45                	jne    801065 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801020:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801027:	83 e1 07             	and    $0x7,%ecx
  80102a:	83 f9 07             	cmp    $0x7,%ecx
  80102d:	74 6f                	je     80109e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80102f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801036:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80103c:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801042:	0f 84 b6 00 00 00    	je     8010fe <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801048:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80104f:	83 e1 05             	and    $0x5,%ecx
  801052:	83 f9 05             	cmp    $0x5,%ecx
  801055:	0f 84 d7 00 00 00    	je     801132 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
  801060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801063:	c9                   	leave  
  801064:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801065:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80106c:	c1 e2 0c             	shl    $0xc,%edx
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801078:	51                   	push   %ecx
  801079:	52                   	push   %edx
  80107a:	50                   	push   %eax
  80107b:	52                   	push   %edx
  80107c:	6a 00                	push   $0x0
  80107e:	e8 d8 fc ff ff       	call   800d5b <sys_page_map>
		if(r < 0)
  801083:	83 c4 20             	add    $0x20,%esp
  801086:	85 c0                	test   %eax,%eax
  801088:	79 d1                	jns    80105b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80108a:	83 ec 04             	sub    $0x4,%esp
  80108d:	68 33 2f 80 00       	push   $0x802f33
  801092:	6a 54                	push   $0x54
  801094:	68 49 2f 80 00       	push   $0x802f49
  801099:	e8 b2 15 00 00       	call   802650 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80109e:	89 d3                	mov    %edx,%ebx
  8010a0:	c1 e3 0c             	shl    $0xc,%ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	68 05 08 00 00       	push   $0x805
  8010ab:	53                   	push   %ebx
  8010ac:	50                   	push   %eax
  8010ad:	53                   	push   %ebx
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 a6 fc ff ff       	call   800d5b <sys_page_map>
		if(r < 0)
  8010b5:	83 c4 20             	add    $0x20,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 2e                	js     8010ea <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	68 05 08 00 00       	push   $0x805
  8010c4:	53                   	push   %ebx
  8010c5:	6a 00                	push   $0x0
  8010c7:	53                   	push   %ebx
  8010c8:	6a 00                	push   $0x0
  8010ca:	e8 8c fc ff ff       	call   800d5b <sys_page_map>
		if(r < 0)
  8010cf:	83 c4 20             	add    $0x20,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	79 85                	jns    80105b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 33 2f 80 00       	push   $0x802f33
  8010de:	6a 5f                	push   $0x5f
  8010e0:	68 49 2f 80 00       	push   $0x802f49
  8010e5:	e8 66 15 00 00       	call   802650 <_panic>
			panic("sys_page_map() panic\n");
  8010ea:	83 ec 04             	sub    $0x4,%esp
  8010ed:	68 33 2f 80 00       	push   $0x802f33
  8010f2:	6a 5b                	push   $0x5b
  8010f4:	68 49 2f 80 00       	push   $0x802f49
  8010f9:	e8 52 15 00 00       	call   802650 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010fe:	c1 e2 0c             	shl    $0xc,%edx
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	68 05 08 00 00       	push   $0x805
  801109:	52                   	push   %edx
  80110a:	50                   	push   %eax
  80110b:	52                   	push   %edx
  80110c:	6a 00                	push   $0x0
  80110e:	e8 48 fc ff ff       	call   800d5b <sys_page_map>
		if(r < 0)
  801113:	83 c4 20             	add    $0x20,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	0f 89 3d ff ff ff    	jns    80105b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	68 33 2f 80 00       	push   $0x802f33
  801126:	6a 66                	push   $0x66
  801128:	68 49 2f 80 00       	push   $0x802f49
  80112d:	e8 1e 15 00 00       	call   802650 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801132:	c1 e2 0c             	shl    $0xc,%edx
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	6a 05                	push   $0x5
  80113a:	52                   	push   %edx
  80113b:	50                   	push   %eax
  80113c:	52                   	push   %edx
  80113d:	6a 00                	push   $0x0
  80113f:	e8 17 fc ff ff       	call   800d5b <sys_page_map>
		if(r < 0)
  801144:	83 c4 20             	add    $0x20,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	0f 89 0c ff ff ff    	jns    80105b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114f:	83 ec 04             	sub    $0x4,%esp
  801152:	68 33 2f 80 00       	push   $0x802f33
  801157:	6a 6d                	push   $0x6d
  801159:	68 49 2f 80 00       	push   $0x802f49
  80115e:	e8 ed 14 00 00       	call   802650 <_panic>

00801163 <pgfault>:
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	53                   	push   %ebx
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80116d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80116f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801173:	0f 84 99 00 00 00    	je     801212 <pgfault+0xaf>
  801179:	89 c2                	mov    %eax,%edx
  80117b:	c1 ea 16             	shr    $0x16,%edx
  80117e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801185:	f6 c2 01             	test   $0x1,%dl
  801188:	0f 84 84 00 00 00    	je     801212 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80118e:	89 c2                	mov    %eax,%edx
  801190:	c1 ea 0c             	shr    $0xc,%edx
  801193:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80119a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011a0:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011a6:	75 6a                	jne    801212 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ad:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	6a 07                	push   $0x7
  8011b4:	68 00 f0 7f 00       	push   $0x7ff000
  8011b9:	6a 00                	push   $0x0
  8011bb:	e8 58 fb ff ff       	call   800d18 <sys_page_alloc>
	if(ret < 0)
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	78 5f                	js     801226 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011c7:	83 ec 04             	sub    $0x4,%esp
  8011ca:	68 00 10 00 00       	push   $0x1000
  8011cf:	53                   	push   %ebx
  8011d0:	68 00 f0 7f 00       	push   $0x7ff000
  8011d5:	e8 3c f9 ff ff       	call   800b16 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011da:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011e1:	53                   	push   %ebx
  8011e2:	6a 00                	push   $0x0
  8011e4:	68 00 f0 7f 00       	push   $0x7ff000
  8011e9:	6a 00                	push   $0x0
  8011eb:	e8 6b fb ff ff       	call   800d5b <sys_page_map>
	if(ret < 0)
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	78 43                	js     80123a <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	68 00 f0 7f 00       	push   $0x7ff000
  8011ff:	6a 00                	push   $0x0
  801201:	e8 97 fb ff ff       	call   800d9d <sys_page_unmap>
	if(ret < 0)
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	78 41                	js     80124e <pgfault+0xeb>
}
  80120d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801210:	c9                   	leave  
  801211:	c3                   	ret    
		panic("panic at pgfault()\n");
  801212:	83 ec 04             	sub    $0x4,%esp
  801215:	68 54 2f 80 00       	push   $0x802f54
  80121a:	6a 26                	push   $0x26
  80121c:	68 49 2f 80 00       	push   $0x802f49
  801221:	e8 2a 14 00 00       	call   802650 <_panic>
		panic("panic in sys_page_alloc()\n");
  801226:	83 ec 04             	sub    $0x4,%esp
  801229:	68 68 2f 80 00       	push   $0x802f68
  80122e:	6a 31                	push   $0x31
  801230:	68 49 2f 80 00       	push   $0x802f49
  801235:	e8 16 14 00 00       	call   802650 <_panic>
		panic("panic in sys_page_map()\n");
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	68 83 2f 80 00       	push   $0x802f83
  801242:	6a 36                	push   $0x36
  801244:	68 49 2f 80 00       	push   $0x802f49
  801249:	e8 02 14 00 00       	call   802650 <_panic>
		panic("panic in sys_page_unmap()\n");
  80124e:	83 ec 04             	sub    $0x4,%esp
  801251:	68 9c 2f 80 00       	push   $0x802f9c
  801256:	6a 39                	push   $0x39
  801258:	68 49 2f 80 00       	push   $0x802f49
  80125d:	e8 ee 13 00 00       	call   802650 <_panic>

00801262 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80126b:	68 63 11 80 00       	push   $0x801163
  801270:	e8 3c 14 00 00       	call   8026b1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801275:	b8 07 00 00 00       	mov    $0x7,%eax
  80127a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	78 2a                	js     8012ad <fork+0x4b>
  801283:	89 c6                	mov    %eax,%esi
  801285:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801287:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80128c:	75 4b                	jne    8012d9 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80128e:	e8 47 fa ff ff       	call   800cda <sys_getenvid>
  801293:	25 ff 03 00 00       	and    $0x3ff,%eax
  801298:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80129e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012a3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012a8:	e9 90 00 00 00       	jmp    80133d <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	68 b8 2f 80 00       	push   $0x802fb8
  8012b5:	68 8c 00 00 00       	push   $0x8c
  8012ba:	68 49 2f 80 00       	push   $0x802f49
  8012bf:	e8 8c 13 00 00       	call   802650 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012c4:	89 f8                	mov    %edi,%eax
  8012c6:	e8 42 fd ff ff       	call   80100d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012d1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012d7:	74 26                	je     8012ff <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012d9:	89 d8                	mov    %ebx,%eax
  8012db:	c1 e8 16             	shr    $0x16,%eax
  8012de:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012e5:	a8 01                	test   $0x1,%al
  8012e7:	74 e2                	je     8012cb <fork+0x69>
  8012e9:	89 da                	mov    %ebx,%edx
  8012eb:	c1 ea 0c             	shr    $0xc,%edx
  8012ee:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012f5:	83 e0 05             	and    $0x5,%eax
  8012f8:	83 f8 05             	cmp    $0x5,%eax
  8012fb:	75 ce                	jne    8012cb <fork+0x69>
  8012fd:	eb c5                	jmp    8012c4 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012ff:	83 ec 04             	sub    $0x4,%esp
  801302:	6a 07                	push   $0x7
  801304:	68 00 f0 bf ee       	push   $0xeebff000
  801309:	56                   	push   %esi
  80130a:	e8 09 fa ff ff       	call   800d18 <sys_page_alloc>
	if(ret < 0)
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	78 31                	js     801347 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	68 20 27 80 00       	push   $0x802720
  80131e:	56                   	push   %esi
  80131f:	e8 3f fb ff ff       	call   800e63 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 33                	js     80135e <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	6a 02                	push   $0x2
  801330:	56                   	push   %esi
  801331:	e8 a9 fa ff ff       	call   800ddf <sys_env_set_status>
	if(ret < 0)
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 38                	js     801375 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80133d:	89 f0                	mov    %esi,%eax
  80133f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5f                   	pop    %edi
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	68 68 2f 80 00       	push   $0x802f68
  80134f:	68 98 00 00 00       	push   $0x98
  801354:	68 49 2f 80 00       	push   $0x802f49
  801359:	e8 f2 12 00 00       	call   802650 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	68 dc 2f 80 00       	push   $0x802fdc
  801366:	68 9b 00 00 00       	push   $0x9b
  80136b:	68 49 2f 80 00       	push   $0x802f49
  801370:	e8 db 12 00 00       	call   802650 <_panic>
		panic("panic in sys_env_set_status()\n");
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 04 30 80 00       	push   $0x803004
  80137d:	68 9e 00 00 00       	push   $0x9e
  801382:	68 49 2f 80 00       	push   $0x802f49
  801387:	e8 c4 12 00 00       	call   802650 <_panic>

0080138c <sfork>:

// Challenge!
int
sfork(void)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	57                   	push   %edi
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801395:	68 63 11 80 00       	push   $0x801163
  80139a:	e8 12 13 00 00       	call   8026b1 <set_pgfault_handler>
  80139f:	b8 07 00 00 00       	mov    $0x7,%eax
  8013a4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 2a                	js     8013d7 <sfork+0x4b>
  8013ad:	89 c7                	mov    %eax,%edi
  8013af:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013b1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013b6:	75 58                	jne    801410 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013b8:	e8 1d f9 ff ff       	call   800cda <sys_getenvid>
  8013bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013c2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013cd:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013d2:	e9 d4 00 00 00       	jmp    8014ab <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	68 b8 2f 80 00       	push   $0x802fb8
  8013df:	68 af 00 00 00       	push   $0xaf
  8013e4:	68 49 2f 80 00       	push   $0x802f49
  8013e9:	e8 62 12 00 00       	call   802650 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013ee:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013f3:	89 f0                	mov    %esi,%eax
  8013f5:	e8 13 fc ff ff       	call   80100d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801400:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801406:	77 65                	ja     80146d <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801408:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80140e:	74 de                	je     8013ee <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801410:	89 d8                	mov    %ebx,%eax
  801412:	c1 e8 16             	shr    $0x16,%eax
  801415:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80141c:	a8 01                	test   $0x1,%al
  80141e:	74 da                	je     8013fa <sfork+0x6e>
  801420:	89 da                	mov    %ebx,%edx
  801422:	c1 ea 0c             	shr    $0xc,%edx
  801425:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80142c:	83 e0 05             	and    $0x5,%eax
  80142f:	83 f8 05             	cmp    $0x5,%eax
  801432:	75 c6                	jne    8013fa <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801434:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80143b:	c1 e2 0c             	shl    $0xc,%edx
  80143e:	83 ec 0c             	sub    $0xc,%esp
  801441:	83 e0 07             	and    $0x7,%eax
  801444:	50                   	push   %eax
  801445:	52                   	push   %edx
  801446:	56                   	push   %esi
  801447:	52                   	push   %edx
  801448:	6a 00                	push   $0x0
  80144a:	e8 0c f9 ff ff       	call   800d5b <sys_page_map>
  80144f:	83 c4 20             	add    $0x20,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	74 a4                	je     8013fa <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 33 2f 80 00       	push   $0x802f33
  80145e:	68 ba 00 00 00       	push   $0xba
  801463:	68 49 2f 80 00       	push   $0x802f49
  801468:	e8 e3 11 00 00       	call   802650 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	6a 07                	push   $0x7
  801472:	68 00 f0 bf ee       	push   $0xeebff000
  801477:	57                   	push   %edi
  801478:	e8 9b f8 ff ff       	call   800d18 <sys_page_alloc>
	if(ret < 0)
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 31                	js     8014b5 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	68 20 27 80 00       	push   $0x802720
  80148c:	57                   	push   %edi
  80148d:	e8 d1 f9 ff ff       	call   800e63 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 33                	js     8014cc <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	6a 02                	push   $0x2
  80149e:	57                   	push   %edi
  80149f:	e8 3b f9 ff ff       	call   800ddf <sys_env_set_status>
	if(ret < 0)
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 38                	js     8014e3 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014ab:	89 f8                	mov    %edi,%eax
  8014ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b0:	5b                   	pop    %ebx
  8014b1:	5e                   	pop    %esi
  8014b2:	5f                   	pop    %edi
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	68 68 2f 80 00       	push   $0x802f68
  8014bd:	68 c0 00 00 00       	push   $0xc0
  8014c2:	68 49 2f 80 00       	push   $0x802f49
  8014c7:	e8 84 11 00 00       	call   802650 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	68 dc 2f 80 00       	push   $0x802fdc
  8014d4:	68 c3 00 00 00       	push   $0xc3
  8014d9:	68 49 2f 80 00       	push   $0x802f49
  8014de:	e8 6d 11 00 00       	call   802650 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 04 30 80 00       	push   $0x803004
  8014eb:	68 c6 00 00 00       	push   $0xc6
  8014f0:	68 49 2f 80 00       	push   $0x802f49
  8014f5:	e8 56 11 00 00       	call   802650 <_panic>

008014fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	05 00 00 00 30       	add    $0x30000000,%eax
  801505:	c1 e8 0c             	shr    $0xc,%eax
}
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801515:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80151a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801529:	89 c2                	mov    %eax,%edx
  80152b:	c1 ea 16             	shr    $0x16,%edx
  80152e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 2d                	je     801567 <fd_alloc+0x46>
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 ea 0c             	shr    $0xc,%edx
  80153f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801546:	f6 c2 01             	test   $0x1,%dl
  801549:	74 1c                	je     801567 <fd_alloc+0x46>
  80154b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801550:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801555:	75 d2                	jne    801529 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801560:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801565:	eb 0a                	jmp    801571 <fd_alloc+0x50>
			*fd_store = fd;
  801567:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80156a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801579:	83 f8 1f             	cmp    $0x1f,%eax
  80157c:	77 30                	ja     8015ae <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80157e:	c1 e0 0c             	shl    $0xc,%eax
  801581:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801586:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80158c:	f6 c2 01             	test   $0x1,%dl
  80158f:	74 24                	je     8015b5 <fd_lookup+0x42>
  801591:	89 c2                	mov    %eax,%edx
  801593:	c1 ea 0c             	shr    $0xc,%edx
  801596:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159d:	f6 c2 01             	test   $0x1,%dl
  8015a0:	74 1a                	je     8015bc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    
		return -E_INVAL;
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb f7                	jmp    8015ac <fd_lookup+0x39>
		return -E_INVAL;
  8015b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ba:	eb f0                	jmp    8015ac <fd_lookup+0x39>
  8015bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c1:	eb e9                	jmp    8015ac <fd_lookup+0x39>

008015c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d1:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015d6:	39 08                	cmp    %ecx,(%eax)
  8015d8:	74 38                	je     801612 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8015da:	83 c2 01             	add    $0x1,%edx
  8015dd:	8b 04 95 a0 30 80 00 	mov    0x8030a0(,%edx,4),%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	75 ee                	jne    8015d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015e8:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ed:	8b 40 48             	mov    0x48(%eax),%eax
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	51                   	push   %ecx
  8015f4:	50                   	push   %eax
  8015f5:	68 24 30 80 00       	push   $0x803024
  8015fa:	e8 c8 eb ff ff       	call   8001c7 <cprintf>
	*dev = 0;
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    
			*dev = devtab[i];
  801612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801615:	89 01                	mov    %eax,(%ecx)
			return 0;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	eb f2                	jmp    801610 <dev_lookup+0x4d>

0080161e <fd_close>:
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	57                   	push   %edi
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
  801624:	83 ec 24             	sub    $0x24,%esp
  801627:	8b 75 08             	mov    0x8(%ebp),%esi
  80162a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80162d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801630:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801631:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801637:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80163a:	50                   	push   %eax
  80163b:	e8 33 ff ff ff       	call   801573 <fd_lookup>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 05                	js     80164e <fd_close+0x30>
	    || fd != fd2)
  801649:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80164c:	74 16                	je     801664 <fd_close+0x46>
		return (must_exist ? r : 0);
  80164e:	89 f8                	mov    %edi,%eax
  801650:	84 c0                	test   %al,%al
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	0f 44 d8             	cmove  %eax,%ebx
}
  80165a:	89 d8                	mov    %ebx,%eax
  80165c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165f:	5b                   	pop    %ebx
  801660:	5e                   	pop    %esi
  801661:	5f                   	pop    %edi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	ff 36                	pushl  (%esi)
  80166d:	e8 51 ff ff ff       	call   8015c3 <dev_lookup>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 1a                	js     801695 <fd_close+0x77>
		if (dev->dev_close)
  80167b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801681:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801686:	85 c0                	test   %eax,%eax
  801688:	74 0b                	je     801695 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80168a:	83 ec 0c             	sub    $0xc,%esp
  80168d:	56                   	push   %esi
  80168e:	ff d0                	call   *%eax
  801690:	89 c3                	mov    %eax,%ebx
  801692:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	56                   	push   %esi
  801699:	6a 00                	push   $0x0
  80169b:	e8 fd f6 ff ff       	call   800d9d <sys_page_unmap>
	return r;
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	eb b5                	jmp    80165a <fd_close+0x3c>

008016a5 <close>:

int
close(int fdnum)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ae:	50                   	push   %eax
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	e8 bc fe ff ff       	call   801573 <fd_lookup>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	79 02                	jns    8016c0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    
		return fd_close(fd, 1);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	6a 01                	push   $0x1
  8016c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c8:	e8 51 ff ff ff       	call   80161e <fd_close>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	eb ec                	jmp    8016be <close+0x19>

008016d2 <close_all>:

void
close_all(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	53                   	push   %ebx
  8016d6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	53                   	push   %ebx
  8016e2:	e8 be ff ff ff       	call   8016a5 <close>
	for (i = 0; i < MAXFD; i++)
  8016e7:	83 c3 01             	add    $0x1,%ebx
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	83 fb 20             	cmp    $0x20,%ebx
  8016f0:	75 ec                	jne    8016de <close_all+0xc>
}
  8016f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	57                   	push   %edi
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	e8 67 fe ff ff       	call   801573 <fd_lookup>
  80170c:	89 c3                	mov    %eax,%ebx
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	0f 88 81 00 00 00    	js     80179a <dup+0xa3>
		return r;
	close(newfdnum);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	e8 81 ff ff ff       	call   8016a5 <close>

	newfd = INDEX2FD(newfdnum);
  801724:	8b 75 0c             	mov    0xc(%ebp),%esi
  801727:	c1 e6 0c             	shl    $0xc,%esi
  80172a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801730:	83 c4 04             	add    $0x4,%esp
  801733:	ff 75 e4             	pushl  -0x1c(%ebp)
  801736:	e8 cf fd ff ff       	call   80150a <fd2data>
  80173b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80173d:	89 34 24             	mov    %esi,(%esp)
  801740:	e8 c5 fd ff ff       	call   80150a <fd2data>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	c1 e8 16             	shr    $0x16,%eax
  80174f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801756:	a8 01                	test   $0x1,%al
  801758:	74 11                	je     80176b <dup+0x74>
  80175a:	89 d8                	mov    %ebx,%eax
  80175c:	c1 e8 0c             	shr    $0xc,%eax
  80175f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801766:	f6 c2 01             	test   $0x1,%dl
  801769:	75 39                	jne    8017a4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80176b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80176e:	89 d0                	mov    %edx,%eax
  801770:	c1 e8 0c             	shr    $0xc,%eax
  801773:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	25 07 0e 00 00       	and    $0xe07,%eax
  801782:	50                   	push   %eax
  801783:	56                   	push   %esi
  801784:	6a 00                	push   $0x0
  801786:	52                   	push   %edx
  801787:	6a 00                	push   $0x0
  801789:	e8 cd f5 ff ff       	call   800d5b <sys_page_map>
  80178e:	89 c3                	mov    %eax,%ebx
  801790:	83 c4 20             	add    $0x20,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	78 31                	js     8017c8 <dup+0xd1>
		goto err;

	return newfdnum;
  801797:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80179a:	89 d8                	mov    %ebx,%eax
  80179c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8017b3:	50                   	push   %eax
  8017b4:	57                   	push   %edi
  8017b5:	6a 00                	push   $0x0
  8017b7:	53                   	push   %ebx
  8017b8:	6a 00                	push   $0x0
  8017ba:	e8 9c f5 ff ff       	call   800d5b <sys_page_map>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 20             	add    $0x20,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	79 a3                	jns    80176b <dup+0x74>
	sys_page_unmap(0, newfd);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	56                   	push   %esi
  8017cc:	6a 00                	push   $0x0
  8017ce:	e8 ca f5 ff ff       	call   800d9d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017d3:	83 c4 08             	add    $0x8,%esp
  8017d6:	57                   	push   %edi
  8017d7:	6a 00                	push   $0x0
  8017d9:	e8 bf f5 ff ff       	call   800d9d <sys_page_unmap>
	return r;
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	eb b7                	jmp    80179a <dup+0xa3>

008017e3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 1c             	sub    $0x1c,%esp
  8017ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f0:	50                   	push   %eax
  8017f1:	53                   	push   %ebx
  8017f2:	e8 7c fd ff ff       	call   801573 <fd_lookup>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	78 3f                	js     80183d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801804:	50                   	push   %eax
  801805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801808:	ff 30                	pushl  (%eax)
  80180a:	e8 b4 fd ff ff       	call   8015c3 <dev_lookup>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	85 c0                	test   %eax,%eax
  801814:	78 27                	js     80183d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801816:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801819:	8b 42 08             	mov    0x8(%edx),%eax
  80181c:	83 e0 03             	and    $0x3,%eax
  80181f:	83 f8 01             	cmp    $0x1,%eax
  801822:	74 1e                	je     801842 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	8b 40 08             	mov    0x8(%eax),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 35                	je     801863 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	ff 75 10             	pushl  0x10(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	52                   	push   %edx
  801838:	ff d0                	call   *%eax
  80183a:	83 c4 10             	add    $0x10,%esp
}
  80183d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801840:	c9                   	leave  
  801841:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801842:	a1 08 50 80 00       	mov    0x805008,%eax
  801847:	8b 40 48             	mov    0x48(%eax),%eax
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	53                   	push   %ebx
  80184e:	50                   	push   %eax
  80184f:	68 65 30 80 00       	push   $0x803065
  801854:	e8 6e e9 ff ff       	call   8001c7 <cprintf>
		return -E_INVAL;
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801861:	eb da                	jmp    80183d <read+0x5a>
		return -E_NOT_SUPP;
  801863:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801868:	eb d3                	jmp    80183d <read+0x5a>

0080186a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	57                   	push   %edi
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	8b 7d 08             	mov    0x8(%ebp),%edi
  801876:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801879:	bb 00 00 00 00       	mov    $0x0,%ebx
  80187e:	39 f3                	cmp    %esi,%ebx
  801880:	73 23                	jae    8018a5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	89 f0                	mov    %esi,%eax
  801887:	29 d8                	sub    %ebx,%eax
  801889:	50                   	push   %eax
  80188a:	89 d8                	mov    %ebx,%eax
  80188c:	03 45 0c             	add    0xc(%ebp),%eax
  80188f:	50                   	push   %eax
  801890:	57                   	push   %edi
  801891:	e8 4d ff ff ff       	call   8017e3 <read>
		if (m < 0)
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 06                	js     8018a3 <readn+0x39>
			return m;
		if (m == 0)
  80189d:	74 06                	je     8018a5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80189f:	01 c3                	add    %eax,%ebx
  8018a1:	eb db                	jmp    80187e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018a3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018a5:	89 d8                	mov    %ebx,%eax
  8018a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5f                   	pop    %edi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 1c             	sub    $0x1c,%esp
  8018b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018bc:	50                   	push   %eax
  8018bd:	53                   	push   %ebx
  8018be:	e8 b0 fc ff ff       	call   801573 <fd_lookup>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 3a                	js     801904 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d0:	50                   	push   %eax
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d4:	ff 30                	pushl  (%eax)
  8018d6:	e8 e8 fc ff ff       	call   8015c3 <dev_lookup>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 22                	js     801904 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018e9:	74 1e                	je     801909 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ee:	8b 52 0c             	mov    0xc(%edx),%edx
  8018f1:	85 d2                	test   %edx,%edx
  8018f3:	74 35                	je     80192a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	50                   	push   %eax
  8018ff:	ff d2                	call   *%edx
  801901:	83 c4 10             	add    $0x10,%esp
}
  801904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801907:	c9                   	leave  
  801908:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801909:	a1 08 50 80 00       	mov    0x805008,%eax
  80190e:	8b 40 48             	mov    0x48(%eax),%eax
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	53                   	push   %ebx
  801915:	50                   	push   %eax
  801916:	68 81 30 80 00       	push   $0x803081
  80191b:	e8 a7 e8 ff ff       	call   8001c7 <cprintf>
		return -E_INVAL;
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801928:	eb da                	jmp    801904 <write+0x55>
		return -E_NOT_SUPP;
  80192a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192f:	eb d3                	jmp    801904 <write+0x55>

00801931 <seek>:

int
seek(int fdnum, off_t offset)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	e8 30 fc ff ff       	call   801573 <fd_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 0e                	js     801958 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 1c             	sub    $0x1c,%esp
  801961:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801964:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801967:	50                   	push   %eax
  801968:	53                   	push   %ebx
  801969:	e8 05 fc ff ff       	call   801573 <fd_lookup>
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 37                	js     8019ac <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197b:	50                   	push   %eax
  80197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197f:	ff 30                	pushl  (%eax)
  801981:	e8 3d fc ff ff       	call   8015c3 <dev_lookup>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 1f                	js     8019ac <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801990:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801994:	74 1b                	je     8019b1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801999:	8b 52 18             	mov    0x18(%edx),%edx
  80199c:	85 d2                	test   %edx,%edx
  80199e:	74 32                	je     8019d2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019a0:	83 ec 08             	sub    $0x8,%esp
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	ff d2                	call   *%edx
  8019a9:	83 c4 10             	add    $0x10,%esp
}
  8019ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019b1:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b6:	8b 40 48             	mov    0x48(%eax),%eax
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	53                   	push   %ebx
  8019bd:	50                   	push   %eax
  8019be:	68 44 30 80 00       	push   $0x803044
  8019c3:	e8 ff e7 ff ff       	call   8001c7 <cprintf>
		return -E_INVAL;
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d0:	eb da                	jmp    8019ac <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d7:	eb d3                	jmp    8019ac <ftruncate+0x52>

008019d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 1c             	sub    $0x1c,%esp
  8019e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e6:	50                   	push   %eax
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	e8 84 fb ff ff       	call   801573 <fd_lookup>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 4b                	js     801a41 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fc:	50                   	push   %eax
  8019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a00:	ff 30                	pushl  (%eax)
  801a02:	e8 bc fb ff ff       	call   8015c3 <dev_lookup>
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 33                	js     801a41 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a15:	74 2f                	je     801a46 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a17:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a1a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a21:	00 00 00 
	stat->st_isdir = 0;
  801a24:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a2b:	00 00 00 
	stat->st_dev = dev;
  801a2e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a34:	83 ec 08             	sub    $0x8,%esp
  801a37:	53                   	push   %ebx
  801a38:	ff 75 f0             	pushl  -0x10(%ebp)
  801a3b:	ff 50 14             	call   *0x14(%eax)
  801a3e:	83 c4 10             	add    $0x10,%esp
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
		return -E_NOT_SUPP;
  801a46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4b:	eb f4                	jmp    801a41 <fstat+0x68>

00801a4d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	56                   	push   %esi
  801a51:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	e8 22 02 00 00       	call   801c81 <open>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 1b                	js     801a83 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	e8 65 ff ff ff       	call   8019d9 <fstat>
  801a74:	89 c6                	mov    %eax,%esi
	close(fd);
  801a76:	89 1c 24             	mov    %ebx,(%esp)
  801a79:	e8 27 fc ff ff       	call   8016a5 <close>
	return r;
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	89 f3                	mov    %esi,%ebx
}
  801a83:	89 d8                	mov    %ebx,%eax
  801a85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5e                   	pop    %esi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    

00801a8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	89 c6                	mov    %eax,%esi
  801a93:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a95:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a9c:	74 27                	je     801ac5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a9e:	6a 07                	push   $0x7
  801aa0:	68 00 60 80 00       	push   $0x806000
  801aa5:	56                   	push   %esi
  801aa6:	ff 35 00 50 80 00    	pushl  0x805000
  801aac:	e8 fe 0c 00 00       	call   8027af <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ab1:	83 c4 0c             	add    $0xc,%esp
  801ab4:	6a 00                	push   $0x0
  801ab6:	53                   	push   %ebx
  801ab7:	6a 00                	push   $0x0
  801ab9:	e8 88 0c 00 00       	call   802746 <ipc_recv>
}
  801abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	6a 01                	push   $0x1
  801aca:	e8 38 0d 00 00       	call   802807 <ipc_find_env>
  801acf:	a3 00 50 80 00       	mov    %eax,0x805000
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	eb c5                	jmp    801a9e <fsipc+0x12>

00801ad9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801af2:	ba 00 00 00 00       	mov    $0x0,%edx
  801af7:	b8 02 00 00 00       	mov    $0x2,%eax
  801afc:	e8 8b ff ff ff       	call   801a8c <fsipc>
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <devfile_flush>:
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b14:	ba 00 00 00 00       	mov    $0x0,%edx
  801b19:	b8 06 00 00 00       	mov    $0x6,%eax
  801b1e:	e8 69 ff ff ff       	call   801a8c <fsipc>
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <devfile_stat>:
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	53                   	push   %ebx
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	8b 40 0c             	mov    0xc(%eax),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b44:	e8 43 ff ff ff       	call   801a8c <fsipc>
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	78 2c                	js     801b79 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b4d:	83 ec 08             	sub    $0x8,%esp
  801b50:	68 00 60 80 00       	push   $0x806000
  801b55:	53                   	push   %ebx
  801b56:	e8 cb ed ff ff       	call   800926 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b5b:	a1 80 60 80 00       	mov    0x806080,%eax
  801b60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b66:	a1 84 60 80 00       	mov    0x806084,%eax
  801b6b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <devfile_write>:
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	53                   	push   %ebx
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b93:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b99:	53                   	push   %ebx
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	68 08 60 80 00       	push   $0x806008
  801ba2:	e8 6f ef ff ff       	call   800b16 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bac:	b8 04 00 00 00       	mov    $0x4,%eax
  801bb1:	e8 d6 fe ff ff       	call   801a8c <fsipc>
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 0b                	js     801bc8 <devfile_write+0x4a>
	assert(r <= n);
  801bbd:	39 d8                	cmp    %ebx,%eax
  801bbf:	77 0c                	ja     801bcd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801bc1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bc6:	7f 1e                	jg     801be6 <devfile_write+0x68>
}
  801bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    
	assert(r <= n);
  801bcd:	68 b4 30 80 00       	push   $0x8030b4
  801bd2:	68 bb 30 80 00       	push   $0x8030bb
  801bd7:	68 98 00 00 00       	push   $0x98
  801bdc:	68 d0 30 80 00       	push   $0x8030d0
  801be1:	e8 6a 0a 00 00       	call   802650 <_panic>
	assert(r <= PGSIZE);
  801be6:	68 db 30 80 00       	push   $0x8030db
  801beb:	68 bb 30 80 00       	push   $0x8030bb
  801bf0:	68 99 00 00 00       	push   $0x99
  801bf5:	68 d0 30 80 00       	push   $0x8030d0
  801bfa:	e8 51 0a 00 00       	call   802650 <_panic>

00801bff <devfile_read>:
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c12:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c18:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1d:	b8 03 00 00 00       	mov    $0x3,%eax
  801c22:	e8 65 fe ff ff       	call   801a8c <fsipc>
  801c27:	89 c3                	mov    %eax,%ebx
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 1f                	js     801c4c <devfile_read+0x4d>
	assert(r <= n);
  801c2d:	39 f0                	cmp    %esi,%eax
  801c2f:	77 24                	ja     801c55 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c36:	7f 33                	jg     801c6b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	50                   	push   %eax
  801c3c:	68 00 60 80 00       	push   $0x806000
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	e8 6b ee ff ff       	call   800ab4 <memmove>
	return r;
  801c49:	83 c4 10             	add    $0x10,%esp
}
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
	assert(r <= n);
  801c55:	68 b4 30 80 00       	push   $0x8030b4
  801c5a:	68 bb 30 80 00       	push   $0x8030bb
  801c5f:	6a 7c                	push   $0x7c
  801c61:	68 d0 30 80 00       	push   $0x8030d0
  801c66:	e8 e5 09 00 00       	call   802650 <_panic>
	assert(r <= PGSIZE);
  801c6b:	68 db 30 80 00       	push   $0x8030db
  801c70:	68 bb 30 80 00       	push   $0x8030bb
  801c75:	6a 7d                	push   $0x7d
  801c77:	68 d0 30 80 00       	push   $0x8030d0
  801c7c:	e8 cf 09 00 00       	call   802650 <_panic>

00801c81 <open>:
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	56                   	push   %esi
  801c85:	53                   	push   %ebx
  801c86:	83 ec 1c             	sub    $0x1c,%esp
  801c89:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c8c:	56                   	push   %esi
  801c8d:	e8 5b ec ff ff       	call   8008ed <strlen>
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c9a:	7f 6c                	jg     801d08 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca2:	50                   	push   %eax
  801ca3:	e8 79 f8 ff ff       	call   801521 <fd_alloc>
  801ca8:	89 c3                	mov    %eax,%ebx
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	85 c0                	test   %eax,%eax
  801caf:	78 3c                	js     801ced <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	56                   	push   %esi
  801cb5:	68 00 60 80 00       	push   $0x806000
  801cba:	e8 67 ec ff ff       	call   800926 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccf:	e8 b8 fd ff ff       	call   801a8c <fsipc>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 19                	js     801cf6 <open+0x75>
	return fd2num(fd);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce3:	e8 12 f8 ff ff       	call   8014fa <fd2num>
  801ce8:	89 c3                	mov    %eax,%ebx
  801cea:	83 c4 10             	add    $0x10,%esp
}
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5d                   	pop    %ebp
  801cf5:	c3                   	ret    
		fd_close(fd, 0);
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfe:	e8 1b f9 ff ff       	call   80161e <fd_close>
		return r;
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	eb e5                	jmp    801ced <open+0x6c>
		return -E_BAD_PATH;
  801d08:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d0d:	eb de                	jmp    801ced <open+0x6c>

00801d0f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d15:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1a:	b8 08 00 00 00       	mov    $0x8,%eax
  801d1f:	e8 68 fd ff ff       	call   801a8c <fsipc>
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d2c:	68 e7 30 80 00       	push   $0x8030e7
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	e8 ed eb ff ff       	call   800926 <strcpy>
	return 0;
}
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_close>:
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 10             	sub    $0x10,%esp
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4a:	53                   	push   %ebx
  801d4b:	e8 f6 0a 00 00       	call   802846 <pageref>
  801d50:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d53:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d58:	83 f8 01             	cmp    $0x1,%eax
  801d5b:	74 07                	je     801d64 <devsock_close+0x24>
}
  801d5d:	89 d0                	mov    %edx,%eax
  801d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	ff 73 0c             	pushl  0xc(%ebx)
  801d6a:	e8 b9 02 00 00       	call   802028 <nsipc_close>
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	eb e7                	jmp    801d5d <devsock_close+0x1d>

00801d76 <devsock_write>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	ff 75 10             	pushl  0x10(%ebp)
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	ff 70 0c             	pushl  0xc(%eax)
  801d8a:	e8 76 03 00 00       	call   802105 <nsipc_send>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <devsock_read>:
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	ff 75 10             	pushl  0x10(%ebp)
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	ff 70 0c             	pushl  0xc(%eax)
  801da5:	e8 ef 02 00 00       	call   802099 <nsipc_recv>
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <fd2sockid>:
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	e8 b7 f7 ff ff       	call   801573 <fd_lookup>
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 10                	js     801dd3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801dcc:	39 08                	cmp    %ecx,(%eax)
  801dce:	75 05                	jne    801dd5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    
		return -E_NOT_SUPP;
  801dd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dda:	eb f7                	jmp    801dd3 <fd2sockid+0x27>

00801ddc <alloc_sockfd>:
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	83 ec 1c             	sub    $0x1c,%esp
  801de4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de9:	50                   	push   %eax
  801dea:	e8 32 f7 ff ff       	call   801521 <fd_alloc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 43                	js     801e3b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801df8:	83 ec 04             	sub    $0x4,%esp
  801dfb:	68 07 04 00 00       	push   $0x407
  801e00:	ff 75 f4             	pushl  -0xc(%ebp)
  801e03:	6a 00                	push   $0x0
  801e05:	e8 0e ef ff ff       	call   800d18 <sys_page_alloc>
  801e0a:	89 c3                	mov    %eax,%ebx
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 28                	js     801e3b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e28:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	50                   	push   %eax
  801e2f:	e8 c6 f6 ff ff       	call   8014fa <fd2num>
  801e34:	89 c3                	mov    %eax,%ebx
  801e36:	83 c4 10             	add    $0x10,%esp
  801e39:	eb 0c                	jmp    801e47 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	56                   	push   %esi
  801e3f:	e8 e4 01 00 00       	call   802028 <nsipc_close>
		return r;
  801e44:	83 c4 10             	add    $0x10,%esp
}
  801e47:	89 d8                	mov    %ebx,%eax
  801e49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <accept>:
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	e8 4e ff ff ff       	call   801dac <fd2sockid>
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 1b                	js     801e7d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	ff 75 10             	pushl  0x10(%ebp)
  801e68:	ff 75 0c             	pushl  0xc(%ebp)
  801e6b:	50                   	push   %eax
  801e6c:	e8 0e 01 00 00       	call   801f7f <nsipc_accept>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 05                	js     801e7d <accept+0x2d>
	return alloc_sockfd(r);
  801e78:	e8 5f ff ff ff       	call   801ddc <alloc_sockfd>
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <bind>:
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	e8 1f ff ff ff       	call   801dac <fd2sockid>
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 12                	js     801ea3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e91:	83 ec 04             	sub    $0x4,%esp
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	50                   	push   %eax
  801e9b:	e8 31 01 00 00       	call   801fd1 <nsipc_bind>
  801ea0:	83 c4 10             	add    $0x10,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <shutdown>:
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	e8 f9 fe ff ff       	call   801dac <fd2sockid>
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 0f                	js     801ec6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801eb7:	83 ec 08             	sub    $0x8,%esp
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	50                   	push   %eax
  801ebe:	e8 43 01 00 00       	call   802006 <nsipc_shutdown>
  801ec3:	83 c4 10             	add    $0x10,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <connect>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	e8 d6 fe ff ff       	call   801dac <fd2sockid>
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 12                	js     801eec <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	ff 75 10             	pushl  0x10(%ebp)
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	50                   	push   %eax
  801ee4:	e8 59 01 00 00       	call   802042 <nsipc_connect>
  801ee9:	83 c4 10             	add    $0x10,%esp
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <listen>:
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	e8 b0 fe ff ff       	call   801dac <fd2sockid>
  801efc:	85 c0                	test   %eax,%eax
  801efe:	78 0f                	js     801f0f <listen+0x21>
	return nsipc_listen(r, backlog);
  801f00:	83 ec 08             	sub    $0x8,%esp
  801f03:	ff 75 0c             	pushl  0xc(%ebp)
  801f06:	50                   	push   %eax
  801f07:	e8 6b 01 00 00       	call   802077 <nsipc_listen>
  801f0c:	83 c4 10             	add    $0x10,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f17:	ff 75 10             	pushl  0x10(%ebp)
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	e8 3e 02 00 00       	call   802163 <nsipc_socket>
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 05                	js     801f31 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f2c:	e8 ab fe ff ff       	call   801ddc <alloc_sockfd>
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	53                   	push   %ebx
  801f37:	83 ec 04             	sub    $0x4,%esp
  801f3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f3c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f43:	74 26                	je     801f6b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f45:	6a 07                	push   $0x7
  801f47:	68 00 70 80 00       	push   $0x807000
  801f4c:	53                   	push   %ebx
  801f4d:	ff 35 04 50 80 00    	pushl  0x805004
  801f53:	e8 57 08 00 00       	call   8027af <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f58:	83 c4 0c             	add    $0xc,%esp
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	e8 e0 07 00 00       	call   802746 <ipc_recv>
}
  801f66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	6a 02                	push   $0x2
  801f70:	e8 92 08 00 00       	call   802807 <ipc_find_env>
  801f75:	a3 04 50 80 00       	mov    %eax,0x805004
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	eb c6                	jmp    801f45 <nsipc+0x12>

00801f7f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f8f:	8b 06                	mov    (%esi),%eax
  801f91:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	e8 93 ff ff ff       	call   801f33 <nsipc>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	79 09                	jns    801faf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fa6:	89 d8                	mov    %ebx,%eax
  801fa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	ff 35 10 70 80 00    	pushl  0x807010
  801fb8:	68 00 70 80 00       	push   $0x807000
  801fbd:	ff 75 0c             	pushl  0xc(%ebp)
  801fc0:	e8 ef ea ff ff       	call   800ab4 <memmove>
		*addrlen = ret->ret_addrlen;
  801fc5:	a1 10 70 80 00       	mov    0x807010,%eax
  801fca:	89 06                	mov    %eax,(%esi)
  801fcc:	83 c4 10             	add    $0x10,%esp
	return r;
  801fcf:	eb d5                	jmp    801fa6 <nsipc_accept+0x27>

00801fd1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	53                   	push   %ebx
  801fd5:	83 ec 08             	sub    $0x8,%esp
  801fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe3:	53                   	push   %ebx
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	68 04 70 80 00       	push   $0x807004
  801fec:	e8 c3 ea ff ff       	call   800ab4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801ff7:	b8 02 00 00 00       	mov    $0x2,%eax
  801ffc:	e8 32 ff ff ff       	call   801f33 <nsipc>
}
  802001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80201c:	b8 03 00 00 00       	mov    $0x3,%eax
  802021:	e8 0d ff ff ff       	call   801f33 <nsipc>
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <nsipc_close>:

int
nsipc_close(int s)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802036:	b8 04 00 00 00       	mov    $0x4,%eax
  80203b:	e8 f3 fe ff ff       	call   801f33 <nsipc>
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	53                   	push   %ebx
  802046:	83 ec 08             	sub    $0x8,%esp
  802049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802054:	53                   	push   %ebx
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	68 04 70 80 00       	push   $0x807004
  80205d:	e8 52 ea ff ff       	call   800ab4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802062:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802068:	b8 05 00 00 00       	mov    $0x5,%eax
  80206d:	e8 c1 fe ff ff       	call   801f33 <nsipc>
}
  802072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80208d:	b8 06 00 00 00       	mov    $0x6,%eax
  802092:	e8 9c fe ff ff       	call   801f33 <nsipc>
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	56                   	push   %esi
  80209d:	53                   	push   %ebx
  80209e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020a9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020af:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020b7:	b8 07 00 00 00       	mov    $0x7,%eax
  8020bc:	e8 72 fe ff ff       	call   801f33 <nsipc>
  8020c1:	89 c3                	mov    %eax,%ebx
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 1f                	js     8020e6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020c7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020cc:	7f 21                	jg     8020ef <nsipc_recv+0x56>
  8020ce:	39 c6                	cmp    %eax,%esi
  8020d0:	7c 1d                	jl     8020ef <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	50                   	push   %eax
  8020d6:	68 00 70 80 00       	push   $0x807000
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	e8 d1 e9 ff ff       	call   800ab4 <memmove>
  8020e3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020e6:	89 d8                	mov    %ebx,%eax
  8020e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020ef:	68 f3 30 80 00       	push   $0x8030f3
  8020f4:	68 bb 30 80 00       	push   $0x8030bb
  8020f9:	6a 62                	push   $0x62
  8020fb:	68 08 31 80 00       	push   $0x803108
  802100:	e8 4b 05 00 00       	call   802650 <_panic>

00802105 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802117:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80211d:	7f 2e                	jg     80214d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	53                   	push   %ebx
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	68 0c 70 80 00       	push   $0x80700c
  80212b:	e8 84 e9 ff ff       	call   800ab4 <memmove>
	nsipcbuf.send.req_size = size;
  802130:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802136:	8b 45 14             	mov    0x14(%ebp),%eax
  802139:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80213e:	b8 08 00 00 00       	mov    $0x8,%eax
  802143:	e8 eb fd ff ff       	call   801f33 <nsipc>
}
  802148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    
	assert(size < 1600);
  80214d:	68 14 31 80 00       	push   $0x803114
  802152:	68 bb 30 80 00       	push   $0x8030bb
  802157:	6a 6d                	push   $0x6d
  802159:	68 08 31 80 00       	push   $0x803108
  80215e:	e8 ed 04 00 00       	call   802650 <_panic>

00802163 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802171:	8b 45 0c             	mov    0xc(%ebp),%eax
  802174:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802179:	8b 45 10             	mov    0x10(%ebp),%eax
  80217c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802181:	b8 09 00 00 00       	mov    $0x9,%eax
  802186:	e8 a8 fd ff ff       	call   801f33 <nsipc>
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	ff 75 08             	pushl  0x8(%ebp)
  80219b:	e8 6a f3 ff ff       	call   80150a <fd2data>
  8021a0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021a2:	83 c4 08             	add    $0x8,%esp
  8021a5:	68 20 31 80 00       	push   $0x803120
  8021aa:	53                   	push   %ebx
  8021ab:	e8 76 e7 ff ff       	call   800926 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021b0:	8b 46 04             	mov    0x4(%esi),%eax
  8021b3:	2b 06                	sub    (%esi),%eax
  8021b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021c2:	00 00 00 
	stat->st_dev = &devpipe;
  8021c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021cc:	40 80 00 
	return 0;
}
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	53                   	push   %ebx
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021e5:	53                   	push   %ebx
  8021e6:	6a 00                	push   $0x0
  8021e8:	e8 b0 eb ff ff       	call   800d9d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021ed:	89 1c 24             	mov    %ebx,(%esp)
  8021f0:	e8 15 f3 ff ff       	call   80150a <fd2data>
  8021f5:	83 c4 08             	add    $0x8,%esp
  8021f8:	50                   	push   %eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	e8 9d eb ff ff       	call   800d9d <sys_page_unmap>
}
  802200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <_pipeisclosed>:
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	57                   	push   %edi
  802209:	56                   	push   %esi
  80220a:	53                   	push   %ebx
  80220b:	83 ec 1c             	sub    $0x1c,%esp
  80220e:	89 c7                	mov    %eax,%edi
  802210:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802212:	a1 08 50 80 00       	mov    0x805008,%eax
  802217:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	57                   	push   %edi
  80221e:	e8 23 06 00 00       	call   802846 <pageref>
  802223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802226:	89 34 24             	mov    %esi,(%esp)
  802229:	e8 18 06 00 00       	call   802846 <pageref>
		nn = thisenv->env_runs;
  80222e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802234:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	39 cb                	cmp    %ecx,%ebx
  80223c:	74 1b                	je     802259 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80223e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802241:	75 cf                	jne    802212 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802243:	8b 42 58             	mov    0x58(%edx),%eax
  802246:	6a 01                	push   $0x1
  802248:	50                   	push   %eax
  802249:	53                   	push   %ebx
  80224a:	68 27 31 80 00       	push   $0x803127
  80224f:	e8 73 df ff ff       	call   8001c7 <cprintf>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	eb b9                	jmp    802212 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802259:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80225c:	0f 94 c0             	sete   %al
  80225f:	0f b6 c0             	movzbl %al,%eax
}
  802262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    

0080226a <devpipe_write>:
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	57                   	push   %edi
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	83 ec 28             	sub    $0x28,%esp
  802273:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802276:	56                   	push   %esi
  802277:	e8 8e f2 ff ff       	call   80150a <fd2data>
  80227c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	bf 00 00 00 00       	mov    $0x0,%edi
  802286:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802289:	74 4f                	je     8022da <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80228b:	8b 43 04             	mov    0x4(%ebx),%eax
  80228e:	8b 0b                	mov    (%ebx),%ecx
  802290:	8d 51 20             	lea    0x20(%ecx),%edx
  802293:	39 d0                	cmp    %edx,%eax
  802295:	72 14                	jb     8022ab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802297:	89 da                	mov    %ebx,%edx
  802299:	89 f0                	mov    %esi,%eax
  80229b:	e8 65 ff ff ff       	call   802205 <_pipeisclosed>
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	75 3b                	jne    8022df <devpipe_write+0x75>
			sys_yield();
  8022a4:	e8 50 ea ff ff       	call   800cf9 <sys_yield>
  8022a9:	eb e0                	jmp    80228b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022b2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022b5:	89 c2                	mov    %eax,%edx
  8022b7:	c1 fa 1f             	sar    $0x1f,%edx
  8022ba:	89 d1                	mov    %edx,%ecx
  8022bc:	c1 e9 1b             	shr    $0x1b,%ecx
  8022bf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022c2:	83 e2 1f             	and    $0x1f,%edx
  8022c5:	29 ca                	sub    %ecx,%edx
  8022c7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022cb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022cf:	83 c0 01             	add    $0x1,%eax
  8022d2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022d5:	83 c7 01             	add    $0x1,%edi
  8022d8:	eb ac                	jmp    802286 <devpipe_write+0x1c>
	return i;
  8022da:	8b 45 10             	mov    0x10(%ebp),%eax
  8022dd:	eb 05                	jmp    8022e4 <devpipe_write+0x7a>
				return 0;
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5f                   	pop    %edi
  8022ea:	5d                   	pop    %ebp
  8022eb:	c3                   	ret    

008022ec <devpipe_read>:
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	57                   	push   %edi
  8022f0:	56                   	push   %esi
  8022f1:	53                   	push   %ebx
  8022f2:	83 ec 18             	sub    $0x18,%esp
  8022f5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022f8:	57                   	push   %edi
  8022f9:	e8 0c f2 ff ff       	call   80150a <fd2data>
  8022fe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802300:	83 c4 10             	add    $0x10,%esp
  802303:	be 00 00 00 00       	mov    $0x0,%esi
  802308:	3b 75 10             	cmp    0x10(%ebp),%esi
  80230b:	75 14                	jne    802321 <devpipe_read+0x35>
	return i;
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	eb 02                	jmp    802314 <devpipe_read+0x28>
				return i;
  802312:	89 f0                	mov    %esi,%eax
}
  802314:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    
			sys_yield();
  80231c:	e8 d8 e9 ff ff       	call   800cf9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802321:	8b 03                	mov    (%ebx),%eax
  802323:	3b 43 04             	cmp    0x4(%ebx),%eax
  802326:	75 18                	jne    802340 <devpipe_read+0x54>
			if (i > 0)
  802328:	85 f6                	test   %esi,%esi
  80232a:	75 e6                	jne    802312 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80232c:	89 da                	mov    %ebx,%edx
  80232e:	89 f8                	mov    %edi,%eax
  802330:	e8 d0 fe ff ff       	call   802205 <_pipeisclosed>
  802335:	85 c0                	test   %eax,%eax
  802337:	74 e3                	je     80231c <devpipe_read+0x30>
				return 0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	eb d4                	jmp    802314 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802340:	99                   	cltd   
  802341:	c1 ea 1b             	shr    $0x1b,%edx
  802344:	01 d0                	add    %edx,%eax
  802346:	83 e0 1f             	and    $0x1f,%eax
  802349:	29 d0                	sub    %edx,%eax
  80234b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802353:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802356:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802359:	83 c6 01             	add    $0x1,%esi
  80235c:	eb aa                	jmp    802308 <devpipe_read+0x1c>

0080235e <pipe>:
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	56                   	push   %esi
  802362:	53                   	push   %ebx
  802363:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802366:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802369:	50                   	push   %eax
  80236a:	e8 b2 f1 ff ff       	call   801521 <fd_alloc>
  80236f:	89 c3                	mov    %eax,%ebx
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	0f 88 23 01 00 00    	js     80249f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 07 04 00 00       	push   $0x407
  802384:	ff 75 f4             	pushl  -0xc(%ebp)
  802387:	6a 00                	push   $0x0
  802389:	e8 8a e9 ff ff       	call   800d18 <sys_page_alloc>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	83 c4 10             	add    $0x10,%esp
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 88 04 01 00 00    	js     80249f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80239b:	83 ec 0c             	sub    $0xc,%esp
  80239e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023a1:	50                   	push   %eax
  8023a2:	e8 7a f1 ff ff       	call   801521 <fd_alloc>
  8023a7:	89 c3                	mov    %eax,%ebx
  8023a9:	83 c4 10             	add    $0x10,%esp
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	0f 88 db 00 00 00    	js     80248f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 07 04 00 00       	push   $0x407
  8023bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8023bf:	6a 00                	push   $0x0
  8023c1:	e8 52 e9 ff ff       	call   800d18 <sys_page_alloc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	0f 88 bc 00 00 00    	js     80248f <pipe+0x131>
	va = fd2data(fd0);
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8023d9:	e8 2c f1 ff ff       	call   80150a <fd2data>
  8023de:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e0:	83 c4 0c             	add    $0xc,%esp
  8023e3:	68 07 04 00 00       	push   $0x407
  8023e8:	50                   	push   %eax
  8023e9:	6a 00                	push   $0x0
  8023eb:	e8 28 e9 ff ff       	call   800d18 <sys_page_alloc>
  8023f0:	89 c3                	mov    %eax,%ebx
  8023f2:	83 c4 10             	add    $0x10,%esp
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	0f 88 82 00 00 00    	js     80247f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	ff 75 f0             	pushl  -0x10(%ebp)
  802403:	e8 02 f1 ff ff       	call   80150a <fd2data>
  802408:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80240f:	50                   	push   %eax
  802410:	6a 00                	push   $0x0
  802412:	56                   	push   %esi
  802413:	6a 00                	push   $0x0
  802415:	e8 41 e9 ff ff       	call   800d5b <sys_page_map>
  80241a:	89 c3                	mov    %eax,%ebx
  80241c:	83 c4 20             	add    $0x20,%esp
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 4e                	js     802471 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802423:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802430:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802446:	83 ec 0c             	sub    $0xc,%esp
  802449:	ff 75 f4             	pushl  -0xc(%ebp)
  80244c:	e8 a9 f0 ff ff       	call   8014fa <fd2num>
  802451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802454:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802456:	83 c4 04             	add    $0x4,%esp
  802459:	ff 75 f0             	pushl  -0x10(%ebp)
  80245c:	e8 99 f0 ff ff       	call   8014fa <fd2num>
  802461:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802464:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80246f:	eb 2e                	jmp    80249f <pipe+0x141>
	sys_page_unmap(0, va);
  802471:	83 ec 08             	sub    $0x8,%esp
  802474:	56                   	push   %esi
  802475:	6a 00                	push   $0x0
  802477:	e8 21 e9 ff ff       	call   800d9d <sys_page_unmap>
  80247c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80247f:	83 ec 08             	sub    $0x8,%esp
  802482:	ff 75 f0             	pushl  -0x10(%ebp)
  802485:	6a 00                	push   $0x0
  802487:	e8 11 e9 ff ff       	call   800d9d <sys_page_unmap>
  80248c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80248f:	83 ec 08             	sub    $0x8,%esp
  802492:	ff 75 f4             	pushl  -0xc(%ebp)
  802495:	6a 00                	push   $0x0
  802497:	e8 01 e9 ff ff       	call   800d9d <sys_page_unmap>
  80249c:	83 c4 10             	add    $0x10,%esp
}
  80249f:	89 d8                	mov    %ebx,%eax
  8024a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a4:	5b                   	pop    %ebx
  8024a5:	5e                   	pop    %esi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    

008024a8 <pipeisclosed>:
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b1:	50                   	push   %eax
  8024b2:	ff 75 08             	pushl  0x8(%ebp)
  8024b5:	e8 b9 f0 ff ff       	call   801573 <fd_lookup>
  8024ba:	83 c4 10             	add    $0x10,%esp
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	78 18                	js     8024d9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c7:	e8 3e f0 ff ff       	call   80150a <fd2data>
	return _pipeisclosed(fd, p);
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	e8 2f fd ff ff       	call   802205 <_pipeisclosed>
  8024d6:	83 c4 10             	add    $0x10,%esp
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e0:	c3                   	ret    

008024e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024e7:	68 3f 31 80 00       	push   $0x80313f
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	e8 32 e4 ff ff       	call   800926 <strcpy>
	return 0;
}
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <devcons_write>:
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	57                   	push   %edi
  8024ff:	56                   	push   %esi
  802500:	53                   	push   %ebx
  802501:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802507:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80250c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802512:	3b 75 10             	cmp    0x10(%ebp),%esi
  802515:	73 31                	jae    802548 <devcons_write+0x4d>
		m = n - tot;
  802517:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80251a:	29 f3                	sub    %esi,%ebx
  80251c:	83 fb 7f             	cmp    $0x7f,%ebx
  80251f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802524:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	53                   	push   %ebx
  80252b:	89 f0                	mov    %esi,%eax
  80252d:	03 45 0c             	add    0xc(%ebp),%eax
  802530:	50                   	push   %eax
  802531:	57                   	push   %edi
  802532:	e8 7d e5 ff ff       	call   800ab4 <memmove>
		sys_cputs(buf, m);
  802537:	83 c4 08             	add    $0x8,%esp
  80253a:	53                   	push   %ebx
  80253b:	57                   	push   %edi
  80253c:	e8 1b e7 ff ff       	call   800c5c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802541:	01 de                	add    %ebx,%esi
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	eb ca                	jmp    802512 <devcons_write+0x17>
}
  802548:	89 f0                	mov    %esi,%eax
  80254a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <devcons_read>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	83 ec 08             	sub    $0x8,%esp
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80255d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802561:	74 21                	je     802584 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802563:	e8 12 e7 ff ff       	call   800c7a <sys_cgetc>
  802568:	85 c0                	test   %eax,%eax
  80256a:	75 07                	jne    802573 <devcons_read+0x21>
		sys_yield();
  80256c:	e8 88 e7 ff ff       	call   800cf9 <sys_yield>
  802571:	eb f0                	jmp    802563 <devcons_read+0x11>
	if (c < 0)
  802573:	78 0f                	js     802584 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802575:	83 f8 04             	cmp    $0x4,%eax
  802578:	74 0c                	je     802586 <devcons_read+0x34>
	*(char*)vbuf = c;
  80257a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257d:	88 02                	mov    %al,(%edx)
	return 1;
  80257f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    
		return 0;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	eb f7                	jmp    802584 <devcons_read+0x32>

0080258d <cputchar>:
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802599:	6a 01                	push   $0x1
  80259b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80259e:	50                   	push   %eax
  80259f:	e8 b8 e6 ff ff       	call   800c5c <sys_cputs>
}
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <getchar>:
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025af:	6a 01                	push   $0x1
  8025b1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b4:	50                   	push   %eax
  8025b5:	6a 00                	push   $0x0
  8025b7:	e8 27 f2 ff ff       	call   8017e3 <read>
	if (r < 0)
  8025bc:	83 c4 10             	add    $0x10,%esp
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	78 06                	js     8025c9 <getchar+0x20>
	if (r < 1)
  8025c3:	74 06                	je     8025cb <getchar+0x22>
	return c;
  8025c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    
		return -E_EOF;
  8025cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025d0:	eb f7                	jmp    8025c9 <getchar+0x20>

008025d2 <iscons>:
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025db:	50                   	push   %eax
  8025dc:	ff 75 08             	pushl  0x8(%ebp)
  8025df:	e8 8f ef ff ff       	call   801573 <fd_lookup>
  8025e4:	83 c4 10             	add    $0x10,%esp
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	78 11                	js     8025fc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025f4:	39 10                	cmp    %edx,(%eax)
  8025f6:	0f 94 c0             	sete   %al
  8025f9:	0f b6 c0             	movzbl %al,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <opencons>:
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802607:	50                   	push   %eax
  802608:	e8 14 ef ff ff       	call   801521 <fd_alloc>
  80260d:	83 c4 10             	add    $0x10,%esp
  802610:	85 c0                	test   %eax,%eax
  802612:	78 3a                	js     80264e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 07 04 00 00       	push   $0x407
  80261c:	ff 75 f4             	pushl  -0xc(%ebp)
  80261f:	6a 00                	push   $0x0
  802621:	e8 f2 e6 ff ff       	call   800d18 <sys_page_alloc>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 21                	js     80264e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802636:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	50                   	push   %eax
  802646:	e8 af ee ff ff       	call   8014fa <fd2num>
  80264b:	83 c4 10             	add    $0x10,%esp
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	56                   	push   %esi
  802654:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802655:	a1 08 50 80 00       	mov    0x805008,%eax
  80265a:	8b 40 48             	mov    0x48(%eax),%eax
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 70 31 80 00       	push   $0x803170
  802665:	50                   	push   %eax
  802666:	68 80 2b 80 00       	push   $0x802b80
  80266b:	e8 57 db ff ff       	call   8001c7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802670:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802673:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802679:	e8 5c e6 ff ff       	call   800cda <sys_getenvid>
  80267e:	83 c4 04             	add    $0x4,%esp
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	ff 75 08             	pushl  0x8(%ebp)
  802687:	56                   	push   %esi
  802688:	50                   	push   %eax
  802689:	68 4c 31 80 00       	push   $0x80314c
  80268e:	e8 34 db ff ff       	call   8001c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802693:	83 c4 18             	add    $0x18,%esp
  802696:	53                   	push   %ebx
  802697:	ff 75 10             	pushl  0x10(%ebp)
  80269a:	e8 d7 da ff ff       	call   800176 <vcprintf>
	cprintf("\n");
  80269f:	c7 04 24 81 2f 80 00 	movl   $0x802f81,(%esp)
  8026a6:	e8 1c db ff ff       	call   8001c7 <cprintf>
  8026ab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026ae:	cc                   	int3   
  8026af:	eb fd                	jmp    8026ae <_panic+0x5e>

008026b1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026b7:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026be:	74 0a                	je     8026ca <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	6a 07                	push   $0x7
  8026cf:	68 00 f0 bf ee       	push   $0xeebff000
  8026d4:	6a 00                	push   $0x0
  8026d6:	e8 3d e6 ff ff       	call   800d18 <sys_page_alloc>
		if(r < 0)
  8026db:	83 c4 10             	add    $0x10,%esp
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	78 2a                	js     80270c <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8026e2:	83 ec 08             	sub    $0x8,%esp
  8026e5:	68 20 27 80 00       	push   $0x802720
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 72 e7 ff ff       	call   800e63 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	79 c8                	jns    8026c0 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 a8 31 80 00       	push   $0x8031a8
  802700:	6a 25                	push   $0x25
  802702:	68 e4 31 80 00       	push   $0x8031e4
  802707:	e8 44 ff ff ff       	call   802650 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	68 78 31 80 00       	push   $0x803178
  802714:	6a 22                	push   $0x22
  802716:	68 e4 31 80 00       	push   $0x8031e4
  80271b:	e8 30 ff ff ff       	call   802650 <_panic>

00802720 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802720:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802721:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802726:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802728:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80272b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80272f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802733:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802736:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802738:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80273c:	83 c4 08             	add    $0x8,%esp
	popal
  80273f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802740:	83 c4 04             	add    $0x4,%esp
	popfl
  802743:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802744:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802745:	c3                   	ret    

00802746 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	56                   	push   %esi
  80274a:	53                   	push   %ebx
  80274b:	8b 75 08             	mov    0x8(%ebp),%esi
  80274e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802751:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802754:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802756:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80275b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	50                   	push   %eax
  802762:	e8 61 e7 ff ff       	call   800ec8 <sys_ipc_recv>
	if(ret < 0){
  802767:	83 c4 10             	add    $0x10,%esp
  80276a:	85 c0                	test   %eax,%eax
  80276c:	78 2b                	js     802799 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80276e:	85 f6                	test   %esi,%esi
  802770:	74 0a                	je     80277c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802772:	a1 08 50 80 00       	mov    0x805008,%eax
  802777:	8b 40 78             	mov    0x78(%eax),%eax
  80277a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80277c:	85 db                	test   %ebx,%ebx
  80277e:	74 0a                	je     80278a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802780:	a1 08 50 80 00       	mov    0x805008,%eax
  802785:	8b 40 7c             	mov    0x7c(%eax),%eax
  802788:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80278a:	a1 08 50 80 00       	mov    0x805008,%eax
  80278f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802792:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    
		if(from_env_store)
  802799:	85 f6                	test   %esi,%esi
  80279b:	74 06                	je     8027a3 <ipc_recv+0x5d>
			*from_env_store = 0;
  80279d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027a3:	85 db                	test   %ebx,%ebx
  8027a5:	74 eb                	je     802792 <ipc_recv+0x4c>
			*perm_store = 0;
  8027a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027ad:	eb e3                	jmp    802792 <ipc_recv+0x4c>

008027af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	57                   	push   %edi
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8027c1:	85 db                	test   %ebx,%ebx
  8027c3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027c8:	0f 44 d8             	cmove  %eax,%ebx
  8027cb:	eb 05                	jmp    8027d2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8027cd:	e8 27 e5 ff ff       	call   800cf9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8027d2:	ff 75 14             	pushl  0x14(%ebp)
  8027d5:	53                   	push   %ebx
  8027d6:	56                   	push   %esi
  8027d7:	57                   	push   %edi
  8027d8:	e8 c8 e6 ff ff       	call   800ea5 <sys_ipc_try_send>
  8027dd:	83 c4 10             	add    $0x10,%esp
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 1b                	je     8027ff <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8027e4:	79 e7                	jns    8027cd <ipc_send+0x1e>
  8027e6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027e9:	74 e2                	je     8027cd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	68 f2 31 80 00       	push   $0x8031f2
  8027f3:	6a 46                	push   $0x46
  8027f5:	68 07 32 80 00       	push   $0x803207
  8027fa:	e8 51 fe ff ff       	call   802650 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8027ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802802:	5b                   	pop    %ebx
  802803:	5e                   	pop    %esi
  802804:	5f                   	pop    %edi
  802805:	5d                   	pop    %ebp
  802806:	c3                   	ret    

00802807 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802812:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802818:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80281e:	8b 52 50             	mov    0x50(%edx),%edx
  802821:	39 ca                	cmp    %ecx,%edx
  802823:	74 11                	je     802836 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802825:	83 c0 01             	add    $0x1,%eax
  802828:	3d 00 04 00 00       	cmp    $0x400,%eax
  80282d:	75 e3                	jne    802812 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
  802834:	eb 0e                	jmp    802844 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802836:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80283c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802841:	8b 40 48             	mov    0x48(%eax),%eax
}
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    

00802846 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	c1 e8 16             	shr    $0x16,%eax
  802851:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80285d:	f6 c1 01             	test   $0x1,%cl
  802860:	74 1d                	je     80287f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802862:	c1 ea 0c             	shr    $0xc,%edx
  802865:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80286c:	f6 c2 01             	test   $0x1,%dl
  80286f:	74 0e                	je     80287f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802871:	c1 ea 0c             	shr    $0xc,%edx
  802874:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80287b:	ef 
  80287c:	0f b7 c0             	movzwl %ax,%eax
}
  80287f:	5d                   	pop    %ebp
  802880:	c3                   	ret    
  802881:	66 90                	xchg   %ax,%ax
  802883:	66 90                	xchg   %ax,%ax
  802885:	66 90                	xchg   %ax,%ax
  802887:	66 90                	xchg   %ax,%ax
  802889:	66 90                	xchg   %ax,%ax
  80288b:	66 90                	xchg   %ax,%ax
  80288d:	66 90                	xchg   %ax,%ax
  80288f:	90                   	nop

00802890 <__udivdi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80289b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80289f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028a7:	85 d2                	test   %edx,%edx
  8028a9:	75 4d                	jne    8028f8 <__udivdi3+0x68>
  8028ab:	39 f3                	cmp    %esi,%ebx
  8028ad:	76 19                	jbe    8028c8 <__udivdi3+0x38>
  8028af:	31 ff                	xor    %edi,%edi
  8028b1:	89 e8                	mov    %ebp,%eax
  8028b3:	89 f2                	mov    %esi,%edx
  8028b5:	f7 f3                	div    %ebx
  8028b7:	89 fa                	mov    %edi,%edx
  8028b9:	83 c4 1c             	add    $0x1c,%esp
  8028bc:	5b                   	pop    %ebx
  8028bd:	5e                   	pop    %esi
  8028be:	5f                   	pop    %edi
  8028bf:	5d                   	pop    %ebp
  8028c0:	c3                   	ret    
  8028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	89 d9                	mov    %ebx,%ecx
  8028ca:	85 db                	test   %ebx,%ebx
  8028cc:	75 0b                	jne    8028d9 <__udivdi3+0x49>
  8028ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d3:	31 d2                	xor    %edx,%edx
  8028d5:	f7 f3                	div    %ebx
  8028d7:	89 c1                	mov    %eax,%ecx
  8028d9:	31 d2                	xor    %edx,%edx
  8028db:	89 f0                	mov    %esi,%eax
  8028dd:	f7 f1                	div    %ecx
  8028df:	89 c6                	mov    %eax,%esi
  8028e1:	89 e8                	mov    %ebp,%eax
  8028e3:	89 f7                	mov    %esi,%edi
  8028e5:	f7 f1                	div    %ecx
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	39 f2                	cmp    %esi,%edx
  8028fa:	77 1c                	ja     802918 <__udivdi3+0x88>
  8028fc:	0f bd fa             	bsr    %edx,%edi
  8028ff:	83 f7 1f             	xor    $0x1f,%edi
  802902:	75 2c                	jne    802930 <__udivdi3+0xa0>
  802904:	39 f2                	cmp    %esi,%edx
  802906:	72 06                	jb     80290e <__udivdi3+0x7e>
  802908:	31 c0                	xor    %eax,%eax
  80290a:	39 eb                	cmp    %ebp,%ebx
  80290c:	77 a9                	ja     8028b7 <__udivdi3+0x27>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	eb a2                	jmp    8028b7 <__udivdi3+0x27>
  802915:	8d 76 00             	lea    0x0(%esi),%esi
  802918:	31 ff                	xor    %edi,%edi
  80291a:	31 c0                	xor    %eax,%eax
  80291c:	89 fa                	mov    %edi,%edx
  80291e:	83 c4 1c             	add    $0x1c,%esp
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
  802926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	89 f9                	mov    %edi,%ecx
  802932:	b8 20 00 00 00       	mov    $0x20,%eax
  802937:	29 f8                	sub    %edi,%eax
  802939:	d3 e2                	shl    %cl,%edx
  80293b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80293f:	89 c1                	mov    %eax,%ecx
  802941:	89 da                	mov    %ebx,%edx
  802943:	d3 ea                	shr    %cl,%edx
  802945:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802949:	09 d1                	or     %edx,%ecx
  80294b:	89 f2                	mov    %esi,%edx
  80294d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802951:	89 f9                	mov    %edi,%ecx
  802953:	d3 e3                	shl    %cl,%ebx
  802955:	89 c1                	mov    %eax,%ecx
  802957:	d3 ea                	shr    %cl,%edx
  802959:	89 f9                	mov    %edi,%ecx
  80295b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80295f:	89 eb                	mov    %ebp,%ebx
  802961:	d3 e6                	shl    %cl,%esi
  802963:	89 c1                	mov    %eax,%ecx
  802965:	d3 eb                	shr    %cl,%ebx
  802967:	09 de                	or     %ebx,%esi
  802969:	89 f0                	mov    %esi,%eax
  80296b:	f7 74 24 08          	divl   0x8(%esp)
  80296f:	89 d6                	mov    %edx,%esi
  802971:	89 c3                	mov    %eax,%ebx
  802973:	f7 64 24 0c          	mull   0xc(%esp)
  802977:	39 d6                	cmp    %edx,%esi
  802979:	72 15                	jb     802990 <__udivdi3+0x100>
  80297b:	89 f9                	mov    %edi,%ecx
  80297d:	d3 e5                	shl    %cl,%ebp
  80297f:	39 c5                	cmp    %eax,%ebp
  802981:	73 04                	jae    802987 <__udivdi3+0xf7>
  802983:	39 d6                	cmp    %edx,%esi
  802985:	74 09                	je     802990 <__udivdi3+0x100>
  802987:	89 d8                	mov    %ebx,%eax
  802989:	31 ff                	xor    %edi,%edi
  80298b:	e9 27 ff ff ff       	jmp    8028b7 <__udivdi3+0x27>
  802990:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802993:	31 ff                	xor    %edi,%edi
  802995:	e9 1d ff ff ff       	jmp    8028b7 <__udivdi3+0x27>
  80299a:	66 90                	xchg   %ax,%ax
  80299c:	66 90                	xchg   %ax,%ax
  80299e:	66 90                	xchg   %ax,%ax

008029a0 <__umoddi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	57                   	push   %edi
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 1c             	sub    $0x1c,%esp
  8029a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029b7:	89 da                	mov    %ebx,%edx
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	75 43                	jne    802a00 <__umoddi3+0x60>
  8029bd:	39 df                	cmp    %ebx,%edi
  8029bf:	76 17                	jbe    8029d8 <__umoddi3+0x38>
  8029c1:	89 f0                	mov    %esi,%eax
  8029c3:	f7 f7                	div    %edi
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	31 d2                	xor    %edx,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 fd                	mov    %edi,%ebp
  8029da:	85 ff                	test   %edi,%edi
  8029dc:	75 0b                	jne    8029e9 <__umoddi3+0x49>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f7                	div    %edi
  8029e7:	89 c5                	mov    %eax,%ebp
  8029e9:	89 d8                	mov    %ebx,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f5                	div    %ebp
  8029ef:	89 f0                	mov    %esi,%eax
  8029f1:	f7 f5                	div    %ebp
  8029f3:	89 d0                	mov    %edx,%eax
  8029f5:	eb d0                	jmp    8029c7 <__umoddi3+0x27>
  8029f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029fe:	66 90                	xchg   %ax,%ax
  802a00:	89 f1                	mov    %esi,%ecx
  802a02:	39 d8                	cmp    %ebx,%eax
  802a04:	76 0a                	jbe    802a10 <__umoddi3+0x70>
  802a06:	89 f0                	mov    %esi,%eax
  802a08:	83 c4 1c             	add    $0x1c,%esp
  802a0b:	5b                   	pop    %ebx
  802a0c:	5e                   	pop    %esi
  802a0d:	5f                   	pop    %edi
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    
  802a10:	0f bd e8             	bsr    %eax,%ebp
  802a13:	83 f5 1f             	xor    $0x1f,%ebp
  802a16:	75 20                	jne    802a38 <__umoddi3+0x98>
  802a18:	39 d8                	cmp    %ebx,%eax
  802a1a:	0f 82 b0 00 00 00    	jb     802ad0 <__umoddi3+0x130>
  802a20:	39 f7                	cmp    %esi,%edi
  802a22:	0f 86 a8 00 00 00    	jbe    802ad0 <__umoddi3+0x130>
  802a28:	89 c8                	mov    %ecx,%eax
  802a2a:	83 c4 1c             	add    $0x1c,%esp
  802a2d:	5b                   	pop    %ebx
  802a2e:	5e                   	pop    %esi
  802a2f:	5f                   	pop    %edi
  802a30:	5d                   	pop    %ebp
  802a31:	c3                   	ret    
  802a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a3f:	29 ea                	sub    %ebp,%edx
  802a41:	d3 e0                	shl    %cl,%eax
  802a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a47:	89 d1                	mov    %edx,%ecx
  802a49:	89 f8                	mov    %edi,%eax
  802a4b:	d3 e8                	shr    %cl,%eax
  802a4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a59:	09 c1                	or     %eax,%ecx
  802a5b:	89 d8                	mov    %ebx,%eax
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 e9                	mov    %ebp,%ecx
  802a63:	d3 e7                	shl    %cl,%edi
  802a65:	89 d1                	mov    %edx,%ecx
  802a67:	d3 e8                	shr    %cl,%eax
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a6f:	d3 e3                	shl    %cl,%ebx
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	89 d1                	mov    %edx,%ecx
  802a75:	89 f0                	mov    %esi,%eax
  802a77:	d3 e8                	shr    %cl,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	89 fa                	mov    %edi,%edx
  802a7d:	d3 e6                	shl    %cl,%esi
  802a7f:	09 d8                	or     %ebx,%eax
  802a81:	f7 74 24 08          	divl   0x8(%esp)
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	89 f3                	mov    %esi,%ebx
  802a89:	f7 64 24 0c          	mull   0xc(%esp)
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	89 d7                	mov    %edx,%edi
  802a91:	39 d1                	cmp    %edx,%ecx
  802a93:	72 06                	jb     802a9b <__umoddi3+0xfb>
  802a95:	75 10                	jne    802aa7 <__umoddi3+0x107>
  802a97:	39 c3                	cmp    %eax,%ebx
  802a99:	73 0c                	jae    802aa7 <__umoddi3+0x107>
  802a9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802aa3:	89 d7                	mov    %edx,%edi
  802aa5:	89 c6                	mov    %eax,%esi
  802aa7:	89 ca                	mov    %ecx,%edx
  802aa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aae:	29 f3                	sub    %esi,%ebx
  802ab0:	19 fa                	sbb    %edi,%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	d3 e0                	shl    %cl,%eax
  802ab6:	89 e9                	mov    %ebp,%ecx
  802ab8:	d3 eb                	shr    %cl,%ebx
  802aba:	d3 ea                	shr    %cl,%edx
  802abc:	09 d8                	or     %ebx,%eax
  802abe:	83 c4 1c             	add    $0x1c,%esp
  802ac1:	5b                   	pop    %ebx
  802ac2:	5e                   	pop    %esi
  802ac3:	5f                   	pop    %edi
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    
  802ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802acd:	8d 76 00             	lea    0x0(%esi),%esi
  802ad0:	89 da                	mov    %ebx,%edx
  802ad2:	29 fe                	sub    %edi,%esi
  802ad4:	19 c2                	sbb    %eax,%edx
  802ad6:	89 f1                	mov    %esi,%ecx
  802ad8:	89 c8                	mov    %ecx,%eax
  802ada:	e9 4b ff ff ff       	jmp    802a2a <__umoddi3+0x8a>
