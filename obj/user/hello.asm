
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 00 25 80 00       	push   $0x802500
  80003e:	e8 2d 01 00 00       	call   800170 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 08 40 80 00       	mov    0x804008,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 0e 25 80 00       	push   $0x80250e
  800054:	e8 17 01 00 00       	call   800170 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800069:	e8 15 0c 00 00       	call   800c83 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800083:	85 db                	test   %ebx,%ebx
  800085:	7e 07                	jle    80008e <libmain+0x30>
		binaryname = argv[0];
  800087:	8b 06                	mov    (%esi),%eax
  800089:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	56                   	push   %esi
  800092:	53                   	push   %ebx
  800093:	e8 9b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800098:	e8 0a 00 00 00       	call   8000a7 <exit>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a3:	5b                   	pop    %ebx
  8000a4:	5e                   	pop    %esi
  8000a5:	5d                   	pop    %ebp
  8000a6:	c3                   	ret    

008000a7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b2:	8b 40 48             	mov    0x48(%eax),%eax
  8000b5:	68 3c 25 80 00       	push   $0x80253c
  8000ba:	50                   	push   %eax
  8000bb:	68 2f 25 80 00       	push   $0x80252f
  8000c0:	e8 ab 00 00 00       	call   800170 <cprintf>
	close_all();
  8000c5:	e8 c4 10 00 00       	call   80118e <close_all>
	sys_env_destroy(0);
  8000ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d1:	e8 6c 0b 00 00       	call   800c42 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	53                   	push   %ebx
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e5:	8b 13                	mov    (%ebx),%edx
  8000e7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ea:	89 03                	mov    %eax,(%ebx)
  8000ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f8:	74 09                	je     800103 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800101:	c9                   	leave  
  800102:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 ff 00 00 00       	push   $0xff
  80010b:	8d 43 08             	lea    0x8(%ebx),%eax
  80010e:	50                   	push   %eax
  80010f:	e8 f1 0a 00 00       	call   800c05 <sys_cputs>
		b->idx = 0;
  800114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	eb db                	jmp    8000fa <putch+0x1f>

0080011f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800128:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012f:	00 00 00 
	b.cnt = 0;
  800132:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800139:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	68 db 00 80 00       	push   $0x8000db
  80014e:	e8 4a 01 00 00       	call   80029d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800153:	83 c4 08             	add    $0x8,%esp
  800156:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80015c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	e8 9d 0a 00 00       	call   800c05 <sys_cputs>

	return b.cnt;
}
  800168:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800176:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800179:	50                   	push   %eax
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	e8 9d ff ff ff       	call   80011f <vcprintf>
	va_end(ap);

	return cnt;
}
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 1c             	sub    $0x1c,%esp
  80018d:	89 c6                	mov    %eax,%esi
  80018f:	89 d7                	mov    %edx,%edi
  800191:	8b 45 08             	mov    0x8(%ebp),%eax
  800194:	8b 55 0c             	mov    0xc(%ebp),%edx
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80019d:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001a3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001a7:	74 2c                	je     8001d5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001b9:	39 c2                	cmp    %eax,%edx
  8001bb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001be:	73 43                	jae    800203 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001c0:	83 eb 01             	sub    $0x1,%ebx
  8001c3:	85 db                	test   %ebx,%ebx
  8001c5:	7e 6c                	jle    800233 <printnum+0xaf>
				putch(padc, putdat);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	57                   	push   %edi
  8001cb:	ff 75 18             	pushl  0x18(%ebp)
  8001ce:	ff d6                	call   *%esi
  8001d0:	83 c4 10             	add    $0x10,%esp
  8001d3:	eb eb                	jmp    8001c0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	6a 20                	push   $0x20
  8001da:	6a 00                	push   $0x0
  8001dc:	50                   	push   %eax
  8001dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e3:	89 fa                	mov    %edi,%edx
  8001e5:	89 f0                	mov    %esi,%eax
  8001e7:	e8 98 ff ff ff       	call   800184 <printnum>
		while (--width > 0)
  8001ec:	83 c4 20             	add    $0x20,%esp
  8001ef:	83 eb 01             	sub    $0x1,%ebx
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 65                	jle    80025b <printnum+0xd7>
			putch(padc, putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	57                   	push   %edi
  8001fa:	6a 20                	push   $0x20
  8001fc:	ff d6                	call   *%esi
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	eb ec                	jmp    8001ef <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	53                   	push   %ebx
  80020d:	50                   	push   %eax
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	ff 75 dc             	pushl  -0x24(%ebp)
  800214:	ff 75 d8             	pushl  -0x28(%ebp)
  800217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 8e 20 00 00       	call   8022b0 <__udivdi3>
  800222:	83 c4 18             	add    $0x18,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	89 fa                	mov    %edi,%edx
  800229:	89 f0                	mov    %esi,%eax
  80022b:	e8 54 ff ff ff       	call   800184 <printnum>
  800230:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	57                   	push   %edi
  800237:	83 ec 04             	sub    $0x4,%esp
  80023a:	ff 75 dc             	pushl  -0x24(%ebp)
  80023d:	ff 75 d8             	pushl  -0x28(%ebp)
  800240:	ff 75 e4             	pushl  -0x1c(%ebp)
  800243:	ff 75 e0             	pushl  -0x20(%ebp)
  800246:	e8 75 21 00 00       	call   8023c0 <__umoddi3>
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	0f be 80 41 25 80 00 	movsbl 0x802541(%eax),%eax
  800255:	50                   	push   %eax
  800256:	ff d6                	call   *%esi
  800258:	83 c4 10             	add    $0x10,%esp
	}
}
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800269:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026d:	8b 10                	mov    (%eax),%edx
  80026f:	3b 50 04             	cmp    0x4(%eax),%edx
  800272:	73 0a                	jae    80027e <sprintputch+0x1b>
		*b->buf++ = ch;
  800274:	8d 4a 01             	lea    0x1(%edx),%ecx
  800277:	89 08                	mov    %ecx,(%eax)
  800279:	8b 45 08             	mov    0x8(%ebp),%eax
  80027c:	88 02                	mov    %al,(%edx)
}
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <printfmt>:
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800286:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	e8 05 00 00 00       	call   80029d <vprintfmt>
}
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <vprintfmt>:
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 3c             	sub    $0x3c,%esp
  8002a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002af:	e9 32 04 00 00       	jmp    8006e6 <vprintfmt+0x449>
		padc = ' ';
  8002b4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002bf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002db:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	8d 47 01             	lea    0x1(%edi),%eax
  8002e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e6:	0f b6 17             	movzbl (%edi),%edx
  8002e9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ec:	3c 55                	cmp    $0x55,%al
  8002ee:	0f 87 12 05 00 00    	ja     800806 <vprintfmt+0x569>
  8002f4:	0f b6 c0             	movzbl %al,%eax
  8002f7:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800301:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800305:	eb d9                	jmp    8002e0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80030a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80030e:	eb d0                	jmp    8002e0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800310:	0f b6 d2             	movzbl %dl,%edx
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	89 75 08             	mov    %esi,0x8(%ebp)
  80031e:	eb 03                	jmp    800323 <vprintfmt+0x86>
  800320:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800323:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800326:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800330:	83 fe 09             	cmp    $0x9,%esi
  800333:	76 eb                	jbe    800320 <vprintfmt+0x83>
  800335:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800338:	8b 75 08             	mov    0x8(%ebp),%esi
  80033b:	eb 14                	jmp    800351 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	8d 40 04             	lea    0x4(%eax),%eax
  80034b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800351:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800355:	79 89                	jns    8002e0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800364:	e9 77 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	0f 48 c1             	cmovs  %ecx,%eax
  800371:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800377:	e9 64 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80037f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800386:	e9 55 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
			lflag++;
  80038b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800392:	e9 49 ff ff ff       	jmp    8002e0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	53                   	push   %ebx
  8003a1:	ff 30                	pushl  (%eax)
  8003a3:	ff d6                	call   *%esi
			break;
  8003a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ab:	e9 33 03 00 00       	jmp    8006e3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	99                   	cltd   
  8003b9:	31 d0                	xor    %edx,%eax
  8003bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bd:	83 f8 11             	cmp    $0x11,%eax
  8003c0:	7f 23                	jg     8003e5 <vprintfmt+0x148>
  8003c2:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003cd:	52                   	push   %edx
  8003ce:	68 9d 29 80 00       	push   $0x80299d
  8003d3:	53                   	push   %ebx
  8003d4:	56                   	push   %esi
  8003d5:	e8 a6 fe ff ff       	call   800280 <printfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e0:	e9 fe 02 00 00       	jmp    8006e3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	50                   	push   %eax
  8003e6:	68 59 25 80 00       	push   $0x802559
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 8e fe ff ff       	call   800280 <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 e6 02 00 00       	jmp    8006e3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80040b:	85 c9                	test   %ecx,%ecx
  80040d:	b8 52 25 80 00       	mov    $0x802552,%eax
  800412:	0f 45 c1             	cmovne %ecx,%eax
  800415:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800418:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041c:	7e 06                	jle    800424 <vprintfmt+0x187>
  80041e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800422:	75 0d                	jne    800431 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800424:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800427:	89 c7                	mov    %eax,%edi
  800429:	03 45 e0             	add    -0x20(%ebp),%eax
  80042c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042f:	eb 53                	jmp    800484 <vprintfmt+0x1e7>
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 d8             	pushl  -0x28(%ebp)
  800437:	50                   	push   %eax
  800438:	e8 71 04 00 00       	call   8008ae <strnlen>
  80043d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800440:	29 c1                	sub    %eax,%ecx
  800442:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80044a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800451:	eb 0f                	jmp    800462 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	53                   	push   %ebx
  800457:	ff 75 e0             	pushl  -0x20(%ebp)
  80045a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045c:	83 ef 01             	sub    $0x1,%edi
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	85 ff                	test   %edi,%edi
  800464:	7f ed                	jg     800453 <vprintfmt+0x1b6>
  800466:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800469:	85 c9                	test   %ecx,%ecx
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	0f 49 c1             	cmovns %ecx,%eax
  800473:	29 c1                	sub    %eax,%ecx
  800475:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800478:	eb aa                	jmp    800424 <vprintfmt+0x187>
					putch(ch, putdat);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	53                   	push   %ebx
  80047e:	52                   	push   %edx
  80047f:	ff d6                	call   *%esi
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800487:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800489:	83 c7 01             	add    $0x1,%edi
  80048c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800490:	0f be d0             	movsbl %al,%edx
  800493:	85 d2                	test   %edx,%edx
  800495:	74 4b                	je     8004e2 <vprintfmt+0x245>
  800497:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049b:	78 06                	js     8004a3 <vprintfmt+0x206>
  80049d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a1:	78 1e                	js     8004c1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004a7:	74 d1                	je     80047a <vprintfmt+0x1dd>
  8004a9:	0f be c0             	movsbl %al,%eax
  8004ac:	83 e8 20             	sub    $0x20,%eax
  8004af:	83 f8 5e             	cmp    $0x5e,%eax
  8004b2:	76 c6                	jbe    80047a <vprintfmt+0x1dd>
					putch('?', putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	53                   	push   %ebx
  8004b8:	6a 3f                	push   $0x3f
  8004ba:	ff d6                	call   *%esi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	eb c3                	jmp    800484 <vprintfmt+0x1e7>
  8004c1:	89 cf                	mov    %ecx,%edi
  8004c3:	eb 0e                	jmp    8004d3 <vprintfmt+0x236>
				putch(' ', putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	53                   	push   %ebx
  8004c9:	6a 20                	push   $0x20
  8004cb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cd:	83 ef 01             	sub    $0x1,%edi
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	85 ff                	test   %edi,%edi
  8004d5:	7f ee                	jg     8004c5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004da:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dd:	e9 01 02 00 00       	jmp    8006e3 <vprintfmt+0x446>
  8004e2:	89 cf                	mov    %ecx,%edi
  8004e4:	eb ed                	jmp    8004d3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004e9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004f0:	e9 eb fd ff ff       	jmp    8002e0 <vprintfmt+0x43>
	if (lflag >= 2)
  8004f5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004f9:	7f 21                	jg     80051c <vprintfmt+0x27f>
	else if (lflag)
  8004fb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004ff:	74 68                	je     800569 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800509:	89 c1                	mov    %eax,%ecx
  80050b:	c1 f9 1f             	sar    $0x1f,%ecx
  80050e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 40 04             	lea    0x4(%eax),%eax
  800517:	89 45 14             	mov    %eax,0x14(%ebp)
  80051a:	eb 17                	jmp    800533 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 50 04             	mov    0x4(%eax),%edx
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800527:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 40 08             	lea    0x8(%eax),%eax
  800530:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800533:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80053f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800543:	78 3f                	js     800584 <vprintfmt+0x2e7>
			base = 10;
  800545:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80054a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80054e:	0f 84 71 01 00 00    	je     8006c5 <vprintfmt+0x428>
				putch('+', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 2b                	push   $0x2b
  80055a:	ff d6                	call   *%esi
  80055c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800564:	e9 5c 01 00 00       	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800571:	89 c1                	mov    %eax,%ecx
  800573:	c1 f9 1f             	sar    $0x1f,%ecx
  800576:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb af                	jmp    800533 <vprintfmt+0x296>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80058f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800592:	f7 d8                	neg    %eax
  800594:	83 d2 00             	adc    $0x0,%edx
  800597:	f7 da                	neg    %edx
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a7:	e9 19 01 00 00       	jmp    8006c5 <vprintfmt+0x428>
	if (lflag >= 2)
  8005ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b0:	7f 29                	jg     8005db <vprintfmt+0x33e>
	else if (lflag)
  8005b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005b6:	74 44                	je     8005fc <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 ea 00 00 00       	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 50 04             	mov    0x4(%eax),%edx
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 08             	lea    0x8(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f7:	e9 c9 00 00 00       	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800615:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061a:	e9 a6 00 00 00       	jmp    8006c5 <vprintfmt+0x428>
			putch('0', putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	6a 30                	push   $0x30
  800625:	ff d6                	call   *%esi
	if (lflag >= 2)
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062e:	7f 26                	jg     800656 <vprintfmt+0x3b9>
	else if (lflag)
  800630:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800634:	74 3e                	je     800674 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	ba 00 00 00 00       	mov    $0x0,%edx
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064f:	b8 08 00 00 00       	mov    $0x8,%eax
  800654:	eb 6f                	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 50 04             	mov    0x4(%eax),%edx
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 08             	lea    0x8(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066d:	b8 08 00 00 00       	mov    $0x8,%eax
  800672:	eb 51                	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068d:	b8 08 00 00 00       	mov    $0x8,%eax
  800692:	eb 31                	jmp    8006c5 <vprintfmt+0x428>
			putch('0', putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	53                   	push   %ebx
  800698:	6a 30                	push   $0x30
  80069a:	ff d6                	call   *%esi
			putch('x', putdat);
  80069c:	83 c4 08             	add    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 78                	push   $0x78
  8006a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006cc:	52                   	push   %edx
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d7:	89 da                	mov    %ebx,%edx
  8006d9:	89 f0                	mov    %esi,%eax
  8006db:	e8 a4 fa ff ff       	call   800184 <printnum>
			break;
  8006e0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e6:	83 c7 01             	add    $0x1,%edi
  8006e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ed:	83 f8 25             	cmp    $0x25,%eax
  8006f0:	0f 84 be fb ff ff    	je     8002b4 <vprintfmt+0x17>
			if (ch == '\0')
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	0f 84 28 01 00 00    	je     800826 <vprintfmt+0x589>
			putch(ch, putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	50                   	push   %eax
  800703:	ff d6                	call   *%esi
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	eb dc                	jmp    8006e6 <vprintfmt+0x449>
	if (lflag >= 2)
  80070a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070e:	7f 26                	jg     800736 <vprintfmt+0x499>
	else if (lflag)
  800710:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800714:	74 41                	je     800757 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8d 40 04             	lea    0x4(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072f:	b8 10 00 00 00       	mov    $0x10,%eax
  800734:	eb 8f                	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 50 04             	mov    0x4(%eax),%edx
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800741:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8d 40 08             	lea    0x8(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074d:	b8 10 00 00 00       	mov    $0x10,%eax
  800752:	e9 6e ff ff ff       	jmp    8006c5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	ba 00 00 00 00       	mov    $0x0,%edx
  800761:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800764:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
  800775:	e9 4b ff ff ff       	jmp    8006c5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	83 c0 04             	add    $0x4,%eax
  800780:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	85 c0                	test   %eax,%eax
  80078a:	74 14                	je     8007a0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80078c:	8b 13                	mov    (%ebx),%edx
  80078e:	83 fa 7f             	cmp    $0x7f,%edx
  800791:	7f 37                	jg     8007ca <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800793:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800795:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
  80079b:	e9 43 ff ff ff       	jmp    8006e3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a5:	bf 75 26 80 00       	mov    $0x802675,%edi
							putch(ch, putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	50                   	push   %eax
  8007af:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b1:	83 c7 01             	add    $0x1,%edi
  8007b4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	75 eb                	jne    8007aa <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	e9 19 ff ff ff       	jmp    8006e3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007ca:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	bf ad 26 80 00       	mov    $0x8026ad,%edi
							putch(ch, putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	50                   	push   %eax
  8007db:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007dd:	83 c7 01             	add    $0x1,%edi
  8007e0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	75 eb                	jne    8007d6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	e9 ed fe ff ff       	jmp    8006e3 <vprintfmt+0x446>
			putch(ch, putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 25                	push   $0x25
  8007fc:	ff d6                	call   *%esi
			break;
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	e9 dd fe ff ff       	jmp    8006e3 <vprintfmt+0x446>
			putch('%', putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	53                   	push   %ebx
  80080a:	6a 25                	push   $0x25
  80080c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	89 f8                	mov    %edi,%eax
  800813:	eb 03                	jmp    800818 <vprintfmt+0x57b>
  800815:	83 e8 01             	sub    $0x1,%eax
  800818:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081c:	75 f7                	jne    800815 <vprintfmt+0x578>
  80081e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800821:	e9 bd fe ff ff       	jmp    8006e3 <vprintfmt+0x446>
}
  800826:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800829:	5b                   	pop    %ebx
  80082a:	5e                   	pop    %esi
  80082b:	5f                   	pop    %edi
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 18             	sub    $0x18,%esp
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800841:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800844:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084b:	85 c0                	test   %eax,%eax
  80084d:	74 26                	je     800875 <vsnprintf+0x47>
  80084f:	85 d2                	test   %edx,%edx
  800851:	7e 22                	jle    800875 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800853:	ff 75 14             	pushl  0x14(%ebp)
  800856:	ff 75 10             	pushl  0x10(%ebp)
  800859:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085c:	50                   	push   %eax
  80085d:	68 63 02 80 00       	push   $0x800263
  800862:	e8 36 fa ff ff       	call   80029d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800870:	83 c4 10             	add    $0x10,%esp
}
  800873:	c9                   	leave  
  800874:	c3                   	ret    
		return -E_INVAL;
  800875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087a:	eb f7                	jmp    800873 <vsnprintf+0x45>

0080087c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800885:	50                   	push   %eax
  800886:	ff 75 10             	pushl  0x10(%ebp)
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 9a ff ff ff       	call   80082e <vsnprintf>
	va_end(ap);

	return rc;
}
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a5:	74 05                	je     8008ac <strlen+0x16>
		n++;
  8008a7:	83 c0 01             	add    $0x1,%eax
  8008aa:	eb f5                	jmp    8008a1 <strlen+0xb>
	return n;
}
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 0d                	je     8008cd <strnlen+0x1f>
  8008c0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008c4:	74 05                	je     8008cb <strnlen+0x1d>
		n++;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	eb f1                	jmp    8008bc <strnlen+0xe>
  8008cb:	89 d0                	mov    %edx,%eax
	return n;
}
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	53                   	push   %ebx
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008de:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008e2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008e5:	83 c2 01             	add    $0x1,%edx
  8008e8:	84 c9                	test   %cl,%cl
  8008ea:	75 f2                	jne    8008de <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008ec:	5b                   	pop    %ebx
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	53                   	push   %ebx
  8008f3:	83 ec 10             	sub    $0x10,%esp
  8008f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f9:	53                   	push   %ebx
  8008fa:	e8 97 ff ff ff       	call   800896 <strlen>
  8008ff:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	01 d8                	add    %ebx,%eax
  800907:	50                   	push   %eax
  800908:	e8 c2 ff ff ff       	call   8008cf <strcpy>
	return dst;
}
  80090d:	89 d8                	mov    %ebx,%eax
  80090f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	56                   	push   %esi
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091f:	89 c6                	mov    %eax,%esi
  800921:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800924:	89 c2                	mov    %eax,%edx
  800926:	39 f2                	cmp    %esi,%edx
  800928:	74 11                	je     80093b <strncpy+0x27>
		*dst++ = *src;
  80092a:	83 c2 01             	add    $0x1,%edx
  80092d:	0f b6 19             	movzbl (%ecx),%ebx
  800930:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800933:	80 fb 01             	cmp    $0x1,%bl
  800936:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800939:	eb eb                	jmp    800926 <strncpy+0x12>
	}
	return ret;
}
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094a:	8b 55 10             	mov    0x10(%ebp),%edx
  80094d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094f:	85 d2                	test   %edx,%edx
  800951:	74 21                	je     800974 <strlcpy+0x35>
  800953:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800957:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800959:	39 c2                	cmp    %eax,%edx
  80095b:	74 14                	je     800971 <strlcpy+0x32>
  80095d:	0f b6 19             	movzbl (%ecx),%ebx
  800960:	84 db                	test   %bl,%bl
  800962:	74 0b                	je     80096f <strlcpy+0x30>
			*dst++ = *src++;
  800964:	83 c1 01             	add    $0x1,%ecx
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80096d:	eb ea                	jmp    800959 <strlcpy+0x1a>
  80096f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800971:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800974:	29 f0                	sub    %esi,%eax
}
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 0c                	je     800996 <strcmp+0x1c>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	75 08                	jne    800996 <strcmp+0x1c>
		p++, q++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	eb ed                	jmp    800983 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800996:	0f b6 c0             	movzbl %al,%eax
  800999:	0f b6 12             	movzbl (%edx),%edx
  80099c:	29 d0                	sub    %edx,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	53                   	push   %ebx
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	89 c3                	mov    %eax,%ebx
  8009ac:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009af:	eb 06                	jmp    8009b7 <strncmp+0x17>
		n--, p++, q++;
  8009b1:	83 c0 01             	add    $0x1,%eax
  8009b4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b7:	39 d8                	cmp    %ebx,%eax
  8009b9:	74 16                	je     8009d1 <strncmp+0x31>
  8009bb:	0f b6 08             	movzbl (%eax),%ecx
  8009be:	84 c9                	test   %cl,%cl
  8009c0:	74 04                	je     8009c6 <strncmp+0x26>
  8009c2:	3a 0a                	cmp    (%edx),%cl
  8009c4:	74 eb                	je     8009b1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c6:	0f b6 00             	movzbl (%eax),%eax
  8009c9:	0f b6 12             	movzbl (%edx),%edx
  8009cc:	29 d0                	sub    %edx,%eax
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    
		return 0;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	eb f6                	jmp    8009ce <strncmp+0x2e>

008009d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e2:	0f b6 10             	movzbl (%eax),%edx
  8009e5:	84 d2                	test   %dl,%dl
  8009e7:	74 09                	je     8009f2 <strchr+0x1a>
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	74 0a                	je     8009f7 <strchr+0x1f>
	for (; *s; s++)
  8009ed:	83 c0 01             	add    $0x1,%eax
  8009f0:	eb f0                	jmp    8009e2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a03:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 09                	je     800a13 <strfind+0x1a>
  800a0a:	84 d2                	test   %dl,%dl
  800a0c:	74 05                	je     800a13 <strfind+0x1a>
	for (; *s; s++)
  800a0e:	83 c0 01             	add    $0x1,%eax
  800a11:	eb f0                	jmp    800a03 <strfind+0xa>
			break;
	return (char *) s;
}
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	57                   	push   %edi
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a21:	85 c9                	test   %ecx,%ecx
  800a23:	74 31                	je     800a56 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a25:	89 f8                	mov    %edi,%eax
  800a27:	09 c8                	or     %ecx,%eax
  800a29:	a8 03                	test   $0x3,%al
  800a2b:	75 23                	jne    800a50 <memset+0x3b>
		c &= 0xFF;
  800a2d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a31:	89 d3                	mov    %edx,%ebx
  800a33:	c1 e3 08             	shl    $0x8,%ebx
  800a36:	89 d0                	mov    %edx,%eax
  800a38:	c1 e0 18             	shl    $0x18,%eax
  800a3b:	89 d6                	mov    %edx,%esi
  800a3d:	c1 e6 10             	shl    $0x10,%esi
  800a40:	09 f0                	or     %esi,%eax
  800a42:	09 c2                	or     %eax,%edx
  800a44:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a46:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a49:	89 d0                	mov    %edx,%eax
  800a4b:	fc                   	cld    
  800a4c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a4e:	eb 06                	jmp    800a56 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	fc                   	cld    
  800a54:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a56:	89 f8                	mov    %edi,%eax
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5f                   	pop    %edi
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	57                   	push   %edi
  800a61:	56                   	push   %esi
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a6b:	39 c6                	cmp    %eax,%esi
  800a6d:	73 32                	jae    800aa1 <memmove+0x44>
  800a6f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a72:	39 c2                	cmp    %eax,%edx
  800a74:	76 2b                	jbe    800aa1 <memmove+0x44>
		s += n;
		d += n;
  800a76:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a79:	89 fe                	mov    %edi,%esi
  800a7b:	09 ce                	or     %ecx,%esi
  800a7d:	09 d6                	or     %edx,%esi
  800a7f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a85:	75 0e                	jne    800a95 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a87:	83 ef 04             	sub    $0x4,%edi
  800a8a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a8d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a90:	fd                   	std    
  800a91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a93:	eb 09                	jmp    800a9e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a95:	83 ef 01             	sub    $0x1,%edi
  800a98:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a9b:	fd                   	std    
  800a9c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a9e:	fc                   	cld    
  800a9f:	eb 1a                	jmp    800abb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	09 ca                	or     %ecx,%edx
  800aa5:	09 f2                	or     %esi,%edx
  800aa7:	f6 c2 03             	test   $0x3,%dl
  800aaa:	75 0a                	jne    800ab6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aaf:	89 c7                	mov    %eax,%edi
  800ab1:	fc                   	cld    
  800ab2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab4:	eb 05                	jmp    800abb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab6:	89 c7                	mov    %eax,%edi
  800ab8:	fc                   	cld    
  800ab9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800abb:	5e                   	pop    %esi
  800abc:	5f                   	pop    %edi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac5:	ff 75 10             	pushl  0x10(%ebp)
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 8a ff ff ff       	call   800a5d <memmove>
}
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	89 c6                	mov    %eax,%esi
  800ae2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae5:	39 f0                	cmp    %esi,%eax
  800ae7:	74 1c                	je     800b05 <memcmp+0x30>
		if (*s1 != *s2)
  800ae9:	0f b6 08             	movzbl (%eax),%ecx
  800aec:	0f b6 1a             	movzbl (%edx),%ebx
  800aef:	38 d9                	cmp    %bl,%cl
  800af1:	75 08                	jne    800afb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af3:	83 c0 01             	add    $0x1,%eax
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	eb ea                	jmp    800ae5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800afb:	0f b6 c1             	movzbl %cl,%eax
  800afe:	0f b6 db             	movzbl %bl,%ebx
  800b01:	29 d8                	sub    %ebx,%eax
  800b03:	eb 05                	jmp    800b0a <memcmp+0x35>
	}

	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b1c:	39 d0                	cmp    %edx,%eax
  800b1e:	73 09                	jae    800b29 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b20:	38 08                	cmp    %cl,(%eax)
  800b22:	74 05                	je     800b29 <memfind+0x1b>
	for (; s < ends; s++)
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	eb f3                	jmp    800b1c <memfind+0xe>
			break;
	return (void *) s;
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b37:	eb 03                	jmp    800b3c <strtol+0x11>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3c:	0f b6 01             	movzbl (%ecx),%eax
  800b3f:	3c 20                	cmp    $0x20,%al
  800b41:	74 f6                	je     800b39 <strtol+0xe>
  800b43:	3c 09                	cmp    $0x9,%al
  800b45:	74 f2                	je     800b39 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b47:	3c 2b                	cmp    $0x2b,%al
  800b49:	74 2a                	je     800b75 <strtol+0x4a>
	int neg = 0;
  800b4b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b50:	3c 2d                	cmp    $0x2d,%al
  800b52:	74 2b                	je     800b7f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b54:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5a:	75 0f                	jne    800b6b <strtol+0x40>
  800b5c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5f:	74 28                	je     800b89 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b68:	0f 44 d8             	cmove  %eax,%ebx
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b73:	eb 50                	jmp    800bc5 <strtol+0x9a>
		s++;
  800b75:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b78:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7d:	eb d5                	jmp    800b54 <strtol+0x29>
		s++, neg = 1;
  800b7f:	83 c1 01             	add    $0x1,%ecx
  800b82:	bf 01 00 00 00       	mov    $0x1,%edi
  800b87:	eb cb                	jmp    800b54 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b89:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8d:	74 0e                	je     800b9d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b8f:	85 db                	test   %ebx,%ebx
  800b91:	75 d8                	jne    800b6b <strtol+0x40>
		s++, base = 8;
  800b93:	83 c1 01             	add    $0x1,%ecx
  800b96:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b9b:	eb ce                	jmp    800b6b <strtol+0x40>
		s += 2, base = 16;
  800b9d:	83 c1 02             	add    $0x2,%ecx
  800ba0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba5:	eb c4                	jmp    800b6b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ba7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800baa:	89 f3                	mov    %esi,%ebx
  800bac:	80 fb 19             	cmp    $0x19,%bl
  800baf:	77 29                	ja     800bda <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb1:	0f be d2             	movsbl %dl,%edx
  800bb4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bb7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bba:	7d 30                	jge    800bec <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bbc:	83 c1 01             	add    $0x1,%ecx
  800bbf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bc3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 11             	movzbl (%ecx),%edx
  800bc8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bcb:	89 f3                	mov    %esi,%ebx
  800bcd:	80 fb 09             	cmp    $0x9,%bl
  800bd0:	77 d5                	ja     800ba7 <strtol+0x7c>
			dig = *s - '0';
  800bd2:	0f be d2             	movsbl %dl,%edx
  800bd5:	83 ea 30             	sub    $0x30,%edx
  800bd8:	eb dd                	jmp    800bb7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 19             	cmp    $0x19,%bl
  800be2:	77 08                	ja     800bec <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be4:	0f be d2             	movsbl %dl,%edx
  800be7:	83 ea 37             	sub    $0x37,%edx
  800bea:	eb cb                	jmp    800bb7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf0:	74 05                	je     800bf7 <strtol+0xcc>
		*endptr = (char *) s;
  800bf2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf7:	89 c2                	mov    %eax,%edx
  800bf9:	f7 da                	neg    %edx
  800bfb:	85 ff                	test   %edi,%edi
  800bfd:	0f 45 c2             	cmovne %edx,%eax
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
  800c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c16:	89 c3                	mov    %eax,%ebx
  800c18:	89 c7                	mov    %eax,%edi
  800c1a:	89 c6                	mov    %eax,%esi
  800c1c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c29:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c33:	89 d1                	mov    %edx,%ecx
  800c35:	89 d3                	mov    %edx,%ebx
  800c37:	89 d7                	mov    %edx,%edi
  800c39:	89 d6                	mov    %edx,%esi
  800c3b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	b8 03 00 00 00       	mov    $0x3,%eax
  800c58:	89 cb                	mov    %ecx,%ebx
  800c5a:	89 cf                	mov    %ecx,%edi
  800c5c:	89 ce                	mov    %ecx,%esi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 03                	push   $0x3
  800c72:	68 c8 28 80 00       	push   $0x8028c8
  800c77:	6a 43                	push   $0x43
  800c79:	68 e5 28 80 00       	push   $0x8028e5
  800c7e:	e8 89 14 00 00       	call   80210c <_panic>

00800c83 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c93:	89 d1                	mov    %edx,%ecx
  800c95:	89 d3                	mov    %edx,%ebx
  800c97:	89 d7                	mov    %edx,%edi
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9d:	5b                   	pop    %ebx
  800c9e:	5e                   	pop    %esi
  800c9f:	5f                   	pop    %edi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <sys_yield>:

void
sys_yield(void)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cad:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb2:	89 d1                	mov    %edx,%ecx
  800cb4:	89 d3                	mov    %edx,%ebx
  800cb6:	89 d7                	mov    %edx,%edi
  800cb8:	89 d6                	mov    %edx,%esi
  800cba:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cca:	be 00 00 00 00       	mov    $0x0,%esi
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdd:	89 f7                	mov    %esi,%edi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cf1:	6a 04                	push   $0x4
  800cf3:	68 c8 28 80 00       	push   $0x8028c8
  800cf8:	6a 43                	push   $0x43
  800cfa:	68 e5 28 80 00       	push   $0x8028e5
  800cff:	e8 08 14 00 00       	call   80210c <_panic>

00800d04 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	b8 05 00 00 00       	mov    $0x5,%eax
  800d18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 05                	push   $0x5
  800d35:	68 c8 28 80 00       	push   $0x8028c8
  800d3a:	6a 43                	push   $0x43
  800d3c:	68 e5 28 80 00       	push   $0x8028e5
  800d41:	e8 c6 13 00 00       	call   80210c <_panic>

00800d46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5f:	89 df                	mov    %ebx,%edi
  800d61:	89 de                	mov    %ebx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 06                	push   $0x6
  800d77:	68 c8 28 80 00       	push   $0x8028c8
  800d7c:	6a 43                	push   $0x43
  800d7e:	68 e5 28 80 00       	push   $0x8028e5
  800d83:	e8 84 13 00 00       	call   80210c <_panic>

00800d88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 08 00 00 00       	mov    $0x8,%eax
  800da1:	89 df                	mov    %ebx,%edi
  800da3:	89 de                	mov    %ebx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 08                	push   $0x8
  800db9:	68 c8 28 80 00       	push   $0x8028c8
  800dbe:	6a 43                	push   $0x43
  800dc0:	68 e5 28 80 00       	push   $0x8028e5
  800dc5:	e8 42 13 00 00       	call   80210c <_panic>

00800dca <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 09                	push   $0x9
  800dfb:	68 c8 28 80 00       	push   $0x8028c8
  800e00:	6a 43                	push   $0x43
  800e02:	68 e5 28 80 00       	push   $0x8028e5
  800e07:	e8 00 13 00 00       	call   80210c <_panic>

00800e0c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
  800e12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e25:	89 df                	mov    %ebx,%edi
  800e27:	89 de                	mov    %ebx,%esi
  800e29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	7f 08                	jg     800e37 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e37:	83 ec 0c             	sub    $0xc,%esp
  800e3a:	50                   	push   %eax
  800e3b:	6a 0a                	push   $0xa
  800e3d:	68 c8 28 80 00       	push   $0x8028c8
  800e42:	6a 43                	push   $0x43
  800e44:	68 e5 28 80 00       	push   $0x8028e5
  800e49:	e8 be 12 00 00       	call   80210c <_panic>

00800e4e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e5f:	be 00 00 00 00       	mov    $0x0,%esi
  800e64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e67:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e6a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	57                   	push   %edi
  800e75:	56                   	push   %esi
  800e76:	53                   	push   %ebx
  800e77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e87:	89 cb                	mov    %ecx,%ebx
  800e89:	89 cf                	mov    %ecx,%edi
  800e8b:	89 ce                	mov    %ecx,%esi
  800e8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7f 08                	jg     800e9b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	50                   	push   %eax
  800e9f:	6a 0d                	push   $0xd
  800ea1:	68 c8 28 80 00       	push   $0x8028c8
  800ea6:	6a 43                	push   $0x43
  800ea8:	68 e5 28 80 00       	push   $0x8028e5
  800ead:	e8 5a 12 00 00       	call   80210c <_panic>

00800eb2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee6:	89 cb                	mov    %ecx,%ebx
  800ee8:	89 cf                	mov    %ecx,%edi
  800eea:	89 ce                	mov    %ecx,%esi
  800eec:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  800efe:	b8 10 00 00 00       	mov    $0x10,%eax
  800f03:	89 d1                	mov    %edx,%ecx
  800f05:	89 d3                	mov    %edx,%ebx
  800f07:	89 d7                	mov    %edx,%edi
  800f09:	89 d6                	mov    %edx,%esi
  800f0b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 11 00 00 00       	mov    $0x11,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
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
  800f44:	b8 12 00 00 00       	mov    $0x12,%eax
  800f49:	89 df                	mov    %ebx,%edi
  800f4b:	89 de                	mov    %ebx,%esi
  800f4d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
  800f5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	b8 13 00 00 00       	mov    $0x13,%eax
  800f6d:	89 df                	mov    %ebx,%edi
  800f6f:	89 de                	mov    %ebx,%esi
  800f71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	7f 08                	jg     800f7f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	50                   	push   %eax
  800f83:	6a 13                	push   $0x13
  800f85:	68 c8 28 80 00       	push   $0x8028c8
  800f8a:	6a 43                	push   $0x43
  800f8c:	68 e5 28 80 00       	push   $0x8028e5
  800f91:	e8 76 11 00 00       	call   80210c <_panic>

00800f96 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	b8 14 00 00 00       	mov    $0x14,%eax
  800fa9:	89 cb                	mov    %ecx,%ebx
  800fab:	89 cf                	mov    %ecx,%edi
  800fad:	89 ce                	mov    %ecx,%esi
  800faf:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc1:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe5:	89 c2                	mov    %eax,%edx
  800fe7:	c1 ea 16             	shr    $0x16,%edx
  800fea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff1:	f6 c2 01             	test   $0x1,%dl
  800ff4:	74 2d                	je     801023 <fd_alloc+0x46>
  800ff6:	89 c2                	mov    %eax,%edx
  800ff8:	c1 ea 0c             	shr    $0xc,%edx
  800ffb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801002:	f6 c2 01             	test   $0x1,%dl
  801005:	74 1c                	je     801023 <fd_alloc+0x46>
  801007:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801011:	75 d2                	jne    800fe5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80101c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801021:	eb 0a                	jmp    80102d <fd_alloc+0x50>
			*fd_store = fd;
  801023:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801026:	89 01                	mov    %eax,(%ecx)
			return 0;
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801035:	83 f8 1f             	cmp    $0x1f,%eax
  801038:	77 30                	ja     80106a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80103a:	c1 e0 0c             	shl    $0xc,%eax
  80103d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801042:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801048:	f6 c2 01             	test   $0x1,%dl
  80104b:	74 24                	je     801071 <fd_lookup+0x42>
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	c1 ea 0c             	shr    $0xc,%edx
  801052:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801059:	f6 c2 01             	test   $0x1,%dl
  80105c:	74 1a                	je     801078 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80105e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801061:	89 02                	mov    %eax,(%edx)
	return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    
		return -E_INVAL;
  80106a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106f:	eb f7                	jmp    801068 <fd_lookup+0x39>
		return -E_INVAL;
  801071:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801076:	eb f0                	jmp    801068 <fd_lookup+0x39>
  801078:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107d:	eb e9                	jmp    801068 <fd_lookup+0x39>

0080107f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801088:	ba 00 00 00 00       	mov    $0x0,%edx
  80108d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801092:	39 08                	cmp    %ecx,(%eax)
  801094:	74 38                	je     8010ce <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801096:	83 c2 01             	add    $0x1,%edx
  801099:	8b 04 95 70 29 80 00 	mov    0x802970(,%edx,4),%eax
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	75 ee                	jne    801092 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a9:	8b 40 48             	mov    0x48(%eax),%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	51                   	push   %ecx
  8010b0:	50                   	push   %eax
  8010b1:	68 f4 28 80 00       	push   $0x8028f4
  8010b6:	e8 b5 f0 ff ff       	call   800170 <cprintf>
	*dev = 0;
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    
			*dev = devtab[i];
  8010ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d8:	eb f2                	jmp    8010cc <dev_lookup+0x4d>

008010da <fd_close>:
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 24             	sub    $0x24,%esp
  8010e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f6:	50                   	push   %eax
  8010f7:	e8 33 ff ff ff       	call   80102f <fd_lookup>
  8010fc:	89 c3                	mov    %eax,%ebx
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	78 05                	js     80110a <fd_close+0x30>
	    || fd != fd2)
  801105:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801108:	74 16                	je     801120 <fd_close+0x46>
		return (must_exist ? r : 0);
  80110a:	89 f8                	mov    %edi,%eax
  80110c:	84 c0                	test   %al,%al
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
  801113:	0f 44 d8             	cmove  %eax,%ebx
}
  801116:	89 d8                	mov    %ebx,%eax
  801118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5f                   	pop    %edi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801126:	50                   	push   %eax
  801127:	ff 36                	pushl  (%esi)
  801129:	e8 51 ff ff ff       	call   80107f <dev_lookup>
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 1a                	js     801151 <fd_close+0x77>
		if (dev->dev_close)
  801137:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80113a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80113d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801142:	85 c0                	test   %eax,%eax
  801144:	74 0b                	je     801151 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	56                   	push   %esi
  80114a:	ff d0                	call   *%eax
  80114c:	89 c3                	mov    %eax,%ebx
  80114e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	56                   	push   %esi
  801155:	6a 00                	push   $0x0
  801157:	e8 ea fb ff ff       	call   800d46 <sys_page_unmap>
	return r;
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	eb b5                	jmp    801116 <fd_close+0x3c>

00801161 <close>:

int
close(int fdnum)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801167:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116a:	50                   	push   %eax
  80116b:	ff 75 08             	pushl  0x8(%ebp)
  80116e:	e8 bc fe ff ff       	call   80102f <fd_lookup>
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	85 c0                	test   %eax,%eax
  801178:	79 02                	jns    80117c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    
		return fd_close(fd, 1);
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	6a 01                	push   $0x1
  801181:	ff 75 f4             	pushl  -0xc(%ebp)
  801184:	e8 51 ff ff ff       	call   8010da <fd_close>
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	eb ec                	jmp    80117a <close+0x19>

0080118e <close_all>:

void
close_all(void)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	53                   	push   %ebx
  801192:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801195:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	53                   	push   %ebx
  80119e:	e8 be ff ff ff       	call   801161 <close>
	for (i = 0; i < MAXFD; i++)
  8011a3:	83 c3 01             	add    $0x1,%ebx
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	83 fb 20             	cmp    $0x20,%ebx
  8011ac:	75 ec                	jne    80119a <close_all+0xc>
}
  8011ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	57                   	push   %edi
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011bf:	50                   	push   %eax
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 67 fe ff ff       	call   80102f <fd_lookup>
  8011c8:	89 c3                	mov    %eax,%ebx
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	0f 88 81 00 00 00    	js     801256 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	ff 75 0c             	pushl  0xc(%ebp)
  8011db:	e8 81 ff ff ff       	call   801161 <close>

	newfd = INDEX2FD(newfdnum);
  8011e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e3:	c1 e6 0c             	shl    $0xc,%esi
  8011e6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011ec:	83 c4 04             	add    $0x4,%esp
  8011ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f2:	e8 cf fd ff ff       	call   800fc6 <fd2data>
  8011f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f9:	89 34 24             	mov    %esi,(%esp)
  8011fc:	e8 c5 fd ff ff       	call   800fc6 <fd2data>
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801206:	89 d8                	mov    %ebx,%eax
  801208:	c1 e8 16             	shr    $0x16,%eax
  80120b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801212:	a8 01                	test   $0x1,%al
  801214:	74 11                	je     801227 <dup+0x74>
  801216:	89 d8                	mov    %ebx,%eax
  801218:	c1 e8 0c             	shr    $0xc,%eax
  80121b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	75 39                	jne    801260 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801227:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122a:	89 d0                	mov    %edx,%eax
  80122c:	c1 e8 0c             	shr    $0xc,%eax
  80122f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	25 07 0e 00 00       	and    $0xe07,%eax
  80123e:	50                   	push   %eax
  80123f:	56                   	push   %esi
  801240:	6a 00                	push   $0x0
  801242:	52                   	push   %edx
  801243:	6a 00                	push   $0x0
  801245:	e8 ba fa ff ff       	call   800d04 <sys_page_map>
  80124a:	89 c3                	mov    %eax,%ebx
  80124c:	83 c4 20             	add    $0x20,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 31                	js     801284 <dup+0xd1>
		goto err;

	return newfdnum;
  801253:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801256:	89 d8                	mov    %ebx,%eax
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801260:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	25 07 0e 00 00       	and    $0xe07,%eax
  80126f:	50                   	push   %eax
  801270:	57                   	push   %edi
  801271:	6a 00                	push   $0x0
  801273:	53                   	push   %ebx
  801274:	6a 00                	push   $0x0
  801276:	e8 89 fa ff ff       	call   800d04 <sys_page_map>
  80127b:	89 c3                	mov    %eax,%ebx
  80127d:	83 c4 20             	add    $0x20,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	79 a3                	jns    801227 <dup+0x74>
	sys_page_unmap(0, newfd);
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	56                   	push   %esi
  801288:	6a 00                	push   $0x0
  80128a:	e8 b7 fa ff ff       	call   800d46 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	57                   	push   %edi
  801293:	6a 00                	push   $0x0
  801295:	e8 ac fa ff ff       	call   800d46 <sys_page_unmap>
	return r;
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	eb b7                	jmp    801256 <dup+0xa3>

0080129f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	53                   	push   %ebx
  8012a3:	83 ec 1c             	sub    $0x1c,%esp
  8012a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	53                   	push   %ebx
  8012ae:	e8 7c fd ff ff       	call   80102f <fd_lookup>
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	78 3f                	js     8012f9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	50                   	push   %eax
  8012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c4:	ff 30                	pushl  (%eax)
  8012c6:	e8 b4 fd ff ff       	call   80107f <dev_lookup>
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	78 27                	js     8012f9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d5:	8b 42 08             	mov    0x8(%edx),%eax
  8012d8:	83 e0 03             	and    $0x3,%eax
  8012db:	83 f8 01             	cmp    $0x1,%eax
  8012de:	74 1e                	je     8012fe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e3:	8b 40 08             	mov    0x8(%eax),%eax
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	74 35                	je     80131f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	ff 75 10             	pushl  0x10(%ebp)
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	52                   	push   %edx
  8012f4:	ff d0                	call   *%eax
  8012f6:	83 c4 10             	add    $0x10,%esp
}
  8012f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012fe:	a1 08 40 80 00       	mov    0x804008,%eax
  801303:	8b 40 48             	mov    0x48(%eax),%eax
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	53                   	push   %ebx
  80130a:	50                   	push   %eax
  80130b:	68 35 29 80 00       	push   $0x802935
  801310:	e8 5b ee ff ff       	call   800170 <cprintf>
		return -E_INVAL;
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131d:	eb da                	jmp    8012f9 <read+0x5a>
		return -E_NOT_SUPP;
  80131f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801324:	eb d3                	jmp    8012f9 <read+0x5a>

00801326 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 0c             	sub    $0xc,%esp
  80132f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801332:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133a:	39 f3                	cmp    %esi,%ebx
  80133c:	73 23                	jae    801361 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	89 f0                	mov    %esi,%eax
  801343:	29 d8                	sub    %ebx,%eax
  801345:	50                   	push   %eax
  801346:	89 d8                	mov    %ebx,%eax
  801348:	03 45 0c             	add    0xc(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	57                   	push   %edi
  80134d:	e8 4d ff ff ff       	call   80129f <read>
		if (m < 0)
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 06                	js     80135f <readn+0x39>
			return m;
		if (m == 0)
  801359:	74 06                	je     801361 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80135b:	01 c3                	add    %eax,%ebx
  80135d:	eb db                	jmp    80133a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801361:	89 d8                	mov    %ebx,%eax
  801363:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5f                   	pop    %edi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  80137a:	e8 b0 fc ff ff       	call   80102f <fd_lookup>
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 3a                	js     8013c0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138c:	50                   	push   %eax
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	ff 30                	pushl  (%eax)
  801392:	e8 e8 fc ff ff       	call   80107f <dev_lookup>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 22                	js     8013c0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a5:	74 1e                	je     8013c5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ad:	85 d2                	test   %edx,%edx
  8013af:	74 35                	je     8013e6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	ff 75 10             	pushl  0x10(%ebp)
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	50                   	push   %eax
  8013bb:	ff d2                	call   *%edx
  8013bd:	83 c4 10             	add    $0x10,%esp
}
  8013c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ca:	8b 40 48             	mov    0x48(%eax),%eax
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	53                   	push   %ebx
  8013d1:	50                   	push   %eax
  8013d2:	68 51 29 80 00       	push   $0x802951
  8013d7:	e8 94 ed ff ff       	call   800170 <cprintf>
		return -E_INVAL;
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e4:	eb da                	jmp    8013c0 <write+0x55>
		return -E_NOT_SUPP;
  8013e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013eb:	eb d3                	jmp    8013c0 <write+0x55>

008013ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 08             	pushl  0x8(%ebp)
  8013fa:	e8 30 fc ff ff       	call   80102f <fd_lookup>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 0e                	js     801414 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801406:	8b 55 0c             	mov    0xc(%ebp),%edx
  801409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80140f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 1c             	sub    $0x1c,%esp
  80141d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	53                   	push   %ebx
  801425:	e8 05 fc ff ff       	call   80102f <fd_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 37                	js     801468 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	ff 30                	pushl  (%eax)
  80143d:	e8 3d fc ff ff       	call   80107f <dev_lookup>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 1f                	js     801468 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801450:	74 1b                	je     80146d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801455:	8b 52 18             	mov    0x18(%edx),%edx
  801458:	85 d2                	test   %edx,%edx
  80145a:	74 32                	je     80148e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	50                   	push   %eax
  801463:	ff d2                	call   *%edx
  801465:	83 c4 10             	add    $0x10,%esp
}
  801468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80146d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801472:	8b 40 48             	mov    0x48(%eax),%eax
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	53                   	push   %ebx
  801479:	50                   	push   %eax
  80147a:	68 14 29 80 00       	push   $0x802914
  80147f:	e8 ec ec ff ff       	call   800170 <cprintf>
		return -E_INVAL;
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148c:	eb da                	jmp    801468 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80148e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801493:	eb d3                	jmp    801468 <ftruncate+0x52>

00801495 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	53                   	push   %ebx
  801499:	83 ec 1c             	sub    $0x1c,%esp
  80149c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 84 fb ff ff       	call   80102f <fd_lookup>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 4b                	js     8014fd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	ff 30                	pushl  (%eax)
  8014be:	e8 bc fb ff ff       	call   80107f <dev_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 33                	js     8014fd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d1:	74 2f                	je     801502 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014dd:	00 00 00 
	stat->st_isdir = 0;
  8014e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e7:	00 00 00 
	stat->st_dev = dev;
  8014ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	53                   	push   %ebx
  8014f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f7:	ff 50 14             	call   *0x14(%eax)
  8014fa:	83 c4 10             	add    $0x10,%esp
}
  8014fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801500:	c9                   	leave  
  801501:	c3                   	ret    
		return -E_NOT_SUPP;
  801502:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801507:	eb f4                	jmp    8014fd <fstat+0x68>

00801509 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	6a 00                	push   $0x0
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	e8 22 02 00 00       	call   80173d <open>
  80151b:	89 c3                	mov    %eax,%ebx
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 1b                	js     80153f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	50                   	push   %eax
  80152b:	e8 65 ff ff ff       	call   801495 <fstat>
  801530:	89 c6                	mov    %eax,%esi
	close(fd);
  801532:	89 1c 24             	mov    %ebx,(%esp)
  801535:	e8 27 fc ff ff       	call   801161 <close>
	return r;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	89 f3                	mov    %esi,%ebx
}
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    

00801548 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	56                   	push   %esi
  80154c:	53                   	push   %ebx
  80154d:	89 c6                	mov    %eax,%esi
  80154f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801551:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801558:	74 27                	je     801581 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80155a:	6a 07                	push   $0x7
  80155c:	68 00 50 80 00       	push   $0x805000
  801561:	56                   	push   %esi
  801562:	ff 35 00 40 80 00    	pushl  0x804000
  801568:	e8 69 0c 00 00       	call   8021d6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156d:	83 c4 0c             	add    $0xc,%esp
  801570:	6a 00                	push   $0x0
  801572:	53                   	push   %ebx
  801573:	6a 00                	push   $0x0
  801575:	e8 f3 0b 00 00       	call   80216d <ipc_recv>
}
  80157a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801581:	83 ec 0c             	sub    $0xc,%esp
  801584:	6a 01                	push   $0x1
  801586:	e8 a3 0c 00 00       	call   80222e <ipc_find_env>
  80158b:	a3 00 40 80 00       	mov    %eax,0x804000
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	eb c5                	jmp    80155a <fsipc+0x12>

00801595 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b3:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b8:	e8 8b ff ff ff       	call   801548 <fsipc>
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <devfile_flush>:
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d5:	b8 06 00 00 00       	mov    $0x6,%eax
  8015da:	e8 69 ff ff ff       	call   801548 <fsipc>
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <devfile_stat>:
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fb:	b8 05 00 00 00       	mov    $0x5,%eax
  801600:	e8 43 ff ff ff       	call   801548 <fsipc>
  801605:	85 c0                	test   %eax,%eax
  801607:	78 2c                	js     801635 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	68 00 50 80 00       	push   $0x805000
  801611:	53                   	push   %ebx
  801612:	e8 b8 f2 ff ff       	call   8008cf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801617:	a1 80 50 80 00       	mov    0x805080,%eax
  80161c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801622:	a1 84 50 80 00       	mov    0x805084,%eax
  801627:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <devfile_write>:
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	53                   	push   %ebx
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8b 40 0c             	mov    0xc(%eax),%eax
  80164a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80164f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801655:	53                   	push   %ebx
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	68 08 50 80 00       	push   $0x805008
  80165e:	e8 5c f4 ff ff       	call   800abf <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	b8 04 00 00 00       	mov    $0x4,%eax
  80166d:	e8 d6 fe ff ff       	call   801548 <fsipc>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 0b                	js     801684 <devfile_write+0x4a>
	assert(r <= n);
  801679:	39 d8                	cmp    %ebx,%eax
  80167b:	77 0c                	ja     801689 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80167d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801682:	7f 1e                	jg     8016a2 <devfile_write+0x68>
}
  801684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801687:	c9                   	leave  
  801688:	c3                   	ret    
	assert(r <= n);
  801689:	68 84 29 80 00       	push   $0x802984
  80168e:	68 8b 29 80 00       	push   $0x80298b
  801693:	68 98 00 00 00       	push   $0x98
  801698:	68 a0 29 80 00       	push   $0x8029a0
  80169d:	e8 6a 0a 00 00       	call   80210c <_panic>
	assert(r <= PGSIZE);
  8016a2:	68 ab 29 80 00       	push   $0x8029ab
  8016a7:	68 8b 29 80 00       	push   $0x80298b
  8016ac:	68 99 00 00 00       	push   $0x99
  8016b1:	68 a0 29 80 00       	push   $0x8029a0
  8016b6:	e8 51 0a 00 00       	call   80210c <_panic>

008016bb <devfile_read>:
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
  8016c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016de:	e8 65 fe ff ff       	call   801548 <fsipc>
  8016e3:	89 c3                	mov    %eax,%ebx
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 1f                	js     801708 <devfile_read+0x4d>
	assert(r <= n);
  8016e9:	39 f0                	cmp    %esi,%eax
  8016eb:	77 24                	ja     801711 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f2:	7f 33                	jg     801727 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	50                   	push   %eax
  8016f8:	68 00 50 80 00       	push   $0x805000
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	e8 58 f3 ff ff       	call   800a5d <memmove>
	return r;
  801705:	83 c4 10             	add    $0x10,%esp
}
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    
	assert(r <= n);
  801711:	68 84 29 80 00       	push   $0x802984
  801716:	68 8b 29 80 00       	push   $0x80298b
  80171b:	6a 7c                	push   $0x7c
  80171d:	68 a0 29 80 00       	push   $0x8029a0
  801722:	e8 e5 09 00 00       	call   80210c <_panic>
	assert(r <= PGSIZE);
  801727:	68 ab 29 80 00       	push   $0x8029ab
  80172c:	68 8b 29 80 00       	push   $0x80298b
  801731:	6a 7d                	push   $0x7d
  801733:	68 a0 29 80 00       	push   $0x8029a0
  801738:	e8 cf 09 00 00       	call   80210c <_panic>

0080173d <open>:
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	83 ec 1c             	sub    $0x1c,%esp
  801745:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801748:	56                   	push   %esi
  801749:	e8 48 f1 ff ff       	call   800896 <strlen>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801756:	7f 6c                	jg     8017c4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	e8 79 f8 ff ff       	call   800fdd <fd_alloc>
  801764:	89 c3                	mov    %eax,%ebx
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 3c                	js     8017a9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	56                   	push   %esi
  801771:	68 00 50 80 00       	push   $0x805000
  801776:	e8 54 f1 ff ff       	call   8008cf <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801786:	b8 01 00 00 00       	mov    $0x1,%eax
  80178b:	e8 b8 fd ff ff       	call   801548 <fsipc>
  801790:	89 c3                	mov    %eax,%ebx
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 19                	js     8017b2 <open+0x75>
	return fd2num(fd);
  801799:	83 ec 0c             	sub    $0xc,%esp
  80179c:	ff 75 f4             	pushl  -0xc(%ebp)
  80179f:	e8 12 f8 ff ff       	call   800fb6 <fd2num>
  8017a4:	89 c3                	mov    %eax,%ebx
  8017a6:	83 c4 10             	add    $0x10,%esp
}
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    
		fd_close(fd, 0);
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	6a 00                	push   $0x0
  8017b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ba:	e8 1b f9 ff ff       	call   8010da <fd_close>
		return r;
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	eb e5                	jmp    8017a9 <open+0x6c>
		return -E_BAD_PATH;
  8017c4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c9:	eb de                	jmp    8017a9 <open+0x6c>

008017cb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017db:	e8 68 fd ff ff       	call   801548 <fsipc>
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017e8:	68 b7 29 80 00       	push   $0x8029b7
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	e8 da f0 ff ff       	call   8008cf <strcpy>
	return 0;
}
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <devsock_close>:
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 10             	sub    $0x10,%esp
  801803:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801806:	53                   	push   %ebx
  801807:	e8 61 0a 00 00       	call   80226d <pageref>
  80180c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80180f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801814:	83 f8 01             	cmp    $0x1,%eax
  801817:	74 07                	je     801820 <devsock_close+0x24>
}
  801819:	89 d0                	mov    %edx,%eax
  80181b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	ff 73 0c             	pushl  0xc(%ebx)
  801826:	e8 b9 02 00 00       	call   801ae4 <nsipc_close>
  80182b:	89 c2                	mov    %eax,%edx
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	eb e7                	jmp    801819 <devsock_close+0x1d>

00801832 <devsock_write>:
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801838:	6a 00                	push   $0x0
  80183a:	ff 75 10             	pushl  0x10(%ebp)
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	ff 70 0c             	pushl  0xc(%eax)
  801846:	e8 76 03 00 00       	call   801bc1 <nsipc_send>
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <devsock_read>:
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801853:	6a 00                	push   $0x0
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	ff 70 0c             	pushl  0xc(%eax)
  801861:	e8 ef 02 00 00       	call   801b55 <nsipc_recv>
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <fd2sockid>:
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80186e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801871:	52                   	push   %edx
  801872:	50                   	push   %eax
  801873:	e8 b7 f7 ff ff       	call   80102f <fd_lookup>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 10                	js     80188f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801888:	39 08                	cmp    %ecx,(%eax)
  80188a:	75 05                	jne    801891 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80188c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    
		return -E_NOT_SUPP;
  801891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801896:	eb f7                	jmp    80188f <fd2sockid+0x27>

00801898 <alloc_sockfd>:
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	83 ec 1c             	sub    $0x1c,%esp
  8018a0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a5:	50                   	push   %eax
  8018a6:	e8 32 f7 ff ff       	call   800fdd <fd_alloc>
  8018ab:	89 c3                	mov    %eax,%ebx
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 43                	js     8018f7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 07 04 00 00       	push   $0x407
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	6a 00                	push   $0x0
  8018c1:	e8 fb f3 ff ff       	call   800cc1 <sys_page_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 28                	js     8018f7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018e4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	50                   	push   %eax
  8018eb:	e8 c6 f6 ff ff       	call   800fb6 <fd2num>
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	eb 0c                	jmp    801903 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	56                   	push   %esi
  8018fb:	e8 e4 01 00 00       	call   801ae4 <nsipc_close>
		return r;
  801900:	83 c4 10             	add    $0x10,%esp
}
  801903:	89 d8                	mov    %ebx,%eax
  801905:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801908:	5b                   	pop    %ebx
  801909:	5e                   	pop    %esi
  80190a:	5d                   	pop    %ebp
  80190b:	c3                   	ret    

0080190c <accept>:
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	e8 4e ff ff ff       	call   801868 <fd2sockid>
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 1b                	js     801939 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	ff 75 10             	pushl  0x10(%ebp)
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	50                   	push   %eax
  801928:	e8 0e 01 00 00       	call   801a3b <nsipc_accept>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 05                	js     801939 <accept+0x2d>
	return alloc_sockfd(r);
  801934:	e8 5f ff ff ff       	call   801898 <alloc_sockfd>
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <bind>:
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	e8 1f ff ff ff       	call   801868 <fd2sockid>
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 12                	js     80195f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	50                   	push   %eax
  801957:	e8 31 01 00 00       	call   801a8d <nsipc_bind>
  80195c:	83 c4 10             	add    $0x10,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <shutdown>:
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	e8 f9 fe ff ff       	call   801868 <fd2sockid>
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 0f                	js     801982 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	50                   	push   %eax
  80197a:	e8 43 01 00 00       	call   801ac2 <nsipc_shutdown>
  80197f:	83 c4 10             	add    $0x10,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <connect>:
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	e8 d6 fe ff ff       	call   801868 <fd2sockid>
  801992:	85 c0                	test   %eax,%eax
  801994:	78 12                	js     8019a8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	50                   	push   %eax
  8019a0:	e8 59 01 00 00       	call   801afe <nsipc_connect>
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <listen>:
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	e8 b0 fe ff ff       	call   801868 <fd2sockid>
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 0f                	js     8019cb <listen+0x21>
	return nsipc_listen(r, backlog);
  8019bc:	83 ec 08             	sub    $0x8,%esp
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	50                   	push   %eax
  8019c3:	e8 6b 01 00 00       	call   801b33 <nsipc_listen>
  8019c8:	83 c4 10             	add    $0x10,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <socket>:

int
socket(int domain, int type, int protocol)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	e8 3e 02 00 00       	call   801c1f <nsipc_socket>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 05                	js     8019ed <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019e8:	e8 ab fe ff ff       	call   801898 <alloc_sockfd>
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019f8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019ff:	74 26                	je     801a27 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a01:	6a 07                	push   $0x7
  801a03:	68 00 60 80 00       	push   $0x806000
  801a08:	53                   	push   %ebx
  801a09:	ff 35 04 40 80 00    	pushl  0x804004
  801a0f:	e8 c2 07 00 00       	call   8021d6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a14:	83 c4 0c             	add    $0xc,%esp
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	e8 4b 07 00 00       	call   80216d <ipc_recv>
}
  801a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	6a 02                	push   $0x2
  801a2c:	e8 fd 07 00 00       	call   80222e <ipc_find_env>
  801a31:	a3 04 40 80 00       	mov    %eax,0x804004
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	eb c6                	jmp    801a01 <nsipc+0x12>

00801a3b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a4b:	8b 06                	mov    (%esi),%eax
  801a4d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	e8 93 ff ff ff       	call   8019ef <nsipc>
  801a5c:	89 c3                	mov    %eax,%ebx
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	79 09                	jns    801a6b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a62:	89 d8                	mov    %ebx,%eax
  801a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	ff 35 10 60 80 00    	pushl  0x806010
  801a74:	68 00 60 80 00       	push   $0x806000
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	e8 dc ef ff ff       	call   800a5d <memmove>
		*addrlen = ret->ret_addrlen;
  801a81:	a1 10 60 80 00       	mov    0x806010,%eax
  801a86:	89 06                	mov    %eax,(%esi)
  801a88:	83 c4 10             	add    $0x10,%esp
	return r;
  801a8b:	eb d5                	jmp    801a62 <nsipc_accept+0x27>

00801a8d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	53                   	push   %ebx
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a9f:	53                   	push   %ebx
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	68 04 60 80 00       	push   $0x806004
  801aa8:	e8 b0 ef ff ff       	call   800a5d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aad:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ab3:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab8:	e8 32 ff ff ff       	call   8019ef <nsipc>
}
  801abd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ad8:	b8 03 00 00 00       	mov    $0x3,%eax
  801add:	e8 0d ff ff ff       	call   8019ef <nsipc>
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <nsipc_close>:

int
nsipc_close(int s)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801af2:	b8 04 00 00 00       	mov    $0x4,%eax
  801af7:	e8 f3 fe ff ff       	call   8019ef <nsipc>
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	53                   	push   %ebx
  801b02:	83 ec 08             	sub    $0x8,%esp
  801b05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b10:	53                   	push   %ebx
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	68 04 60 80 00       	push   $0x806004
  801b19:	e8 3f ef ff ff       	call   800a5d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b1e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b24:	b8 05 00 00 00       	mov    $0x5,%eax
  801b29:	e8 c1 fe ff ff       	call   8019ef <nsipc>
}
  801b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b49:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4e:	e8 9c fe ff ff       	call   8019ef <nsipc>
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b65:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b73:	b8 07 00 00 00       	mov    $0x7,%eax
  801b78:	e8 72 fe ff ff       	call   8019ef <nsipc>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 1f                	js     801ba2 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b83:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b88:	7f 21                	jg     801bab <nsipc_recv+0x56>
  801b8a:	39 c6                	cmp    %eax,%esi
  801b8c:	7c 1d                	jl     801bab <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	50                   	push   %eax
  801b92:	68 00 60 80 00       	push   $0x806000
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	e8 be ee ff ff       	call   800a5d <memmove>
  801b9f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ba2:	89 d8                	mov    %ebx,%eax
  801ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bab:	68 c3 29 80 00       	push   $0x8029c3
  801bb0:	68 8b 29 80 00       	push   $0x80298b
  801bb5:	6a 62                	push   $0x62
  801bb7:	68 d8 29 80 00       	push   $0x8029d8
  801bbc:	e8 4b 05 00 00       	call   80210c <_panic>

00801bc1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bd3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bd9:	7f 2e                	jg     801c09 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	53                   	push   %ebx
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	68 0c 60 80 00       	push   $0x80600c
  801be7:	e8 71 ee ff ff       	call   800a5d <memmove>
	nsipcbuf.send.req_size = size;
  801bec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bfa:	b8 08 00 00 00       	mov    $0x8,%eax
  801bff:	e8 eb fd ff ff       	call   8019ef <nsipc>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
	assert(size < 1600);
  801c09:	68 e4 29 80 00       	push   $0x8029e4
  801c0e:	68 8b 29 80 00       	push   $0x80298b
  801c13:	6a 6d                	push   $0x6d
  801c15:	68 d8 29 80 00       	push   $0x8029d8
  801c1a:	e8 ed 04 00 00       	call   80210c <_panic>

00801c1f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c30:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c35:	8b 45 10             	mov    0x10(%ebp),%eax
  801c38:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c3d:	b8 09 00 00 00       	mov    $0x9,%eax
  801c42:	e8 a8 fd ff ff       	call   8019ef <nsipc>
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	56                   	push   %esi
  801c4d:	53                   	push   %ebx
  801c4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c51:	83 ec 0c             	sub    $0xc,%esp
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	e8 6a f3 ff ff       	call   800fc6 <fd2data>
  801c5c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c5e:	83 c4 08             	add    $0x8,%esp
  801c61:	68 f0 29 80 00       	push   $0x8029f0
  801c66:	53                   	push   %ebx
  801c67:	e8 63 ec ff ff       	call   8008cf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c6c:	8b 46 04             	mov    0x4(%esi),%eax
  801c6f:	2b 06                	sub    (%esi),%eax
  801c71:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c77:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c7e:	00 00 00 
	stat->st_dev = &devpipe;
  801c81:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c88:	30 80 00 
	return 0;
}
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    

00801c97 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 0c             	sub    $0xc,%esp
  801c9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca1:	53                   	push   %ebx
  801ca2:	6a 00                	push   $0x0
  801ca4:	e8 9d f0 ff ff       	call   800d46 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca9:	89 1c 24             	mov    %ebx,(%esp)
  801cac:	e8 15 f3 ff ff       	call   800fc6 <fd2data>
  801cb1:	83 c4 08             	add    $0x8,%esp
  801cb4:	50                   	push   %eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	e8 8a f0 ff ff       	call   800d46 <sys_page_unmap>
}
  801cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <_pipeisclosed>:
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	57                   	push   %edi
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 1c             	sub    $0x1c,%esp
  801cca:	89 c7                	mov    %eax,%edi
  801ccc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cce:	a1 08 40 80 00       	mov    0x804008,%eax
  801cd3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	57                   	push   %edi
  801cda:	e8 8e 05 00 00       	call   80226d <pageref>
  801cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce2:	89 34 24             	mov    %esi,(%esp)
  801ce5:	e8 83 05 00 00       	call   80226d <pageref>
		nn = thisenv->env_runs;
  801cea:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cf0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	39 cb                	cmp    %ecx,%ebx
  801cf8:	74 1b                	je     801d15 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cfa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cfd:	75 cf                	jne    801cce <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cff:	8b 42 58             	mov    0x58(%edx),%eax
  801d02:	6a 01                	push   $0x1
  801d04:	50                   	push   %eax
  801d05:	53                   	push   %ebx
  801d06:	68 f7 29 80 00       	push   $0x8029f7
  801d0b:	e8 60 e4 ff ff       	call   800170 <cprintf>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	eb b9                	jmp    801cce <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d15:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d18:	0f 94 c0             	sete   %al
  801d1b:	0f b6 c0             	movzbl %al,%eax
}
  801d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    

00801d26 <devpipe_write>:
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 28             	sub    $0x28,%esp
  801d2f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d32:	56                   	push   %esi
  801d33:	e8 8e f2 ff ff       	call   800fc6 <fd2data>
  801d38:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d42:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d45:	74 4f                	je     801d96 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d47:	8b 43 04             	mov    0x4(%ebx),%eax
  801d4a:	8b 0b                	mov    (%ebx),%ecx
  801d4c:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4f:	39 d0                	cmp    %edx,%eax
  801d51:	72 14                	jb     801d67 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d53:	89 da                	mov    %ebx,%edx
  801d55:	89 f0                	mov    %esi,%eax
  801d57:	e8 65 ff ff ff       	call   801cc1 <_pipeisclosed>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	75 3b                	jne    801d9b <devpipe_write+0x75>
			sys_yield();
  801d60:	e8 3d ef ff ff       	call   800ca2 <sys_yield>
  801d65:	eb e0                	jmp    801d47 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	c1 fa 1f             	sar    $0x1f,%edx
  801d76:	89 d1                	mov    %edx,%ecx
  801d78:	c1 e9 1b             	shr    $0x1b,%ecx
  801d7b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7e:	83 e2 1f             	and    $0x1f,%edx
  801d81:	29 ca                	sub    %ecx,%edx
  801d83:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d87:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d8b:	83 c0 01             	add    $0x1,%eax
  801d8e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d91:	83 c7 01             	add    $0x1,%edi
  801d94:	eb ac                	jmp    801d42 <devpipe_write+0x1c>
	return i;
  801d96:	8b 45 10             	mov    0x10(%ebp),%eax
  801d99:	eb 05                	jmp    801da0 <devpipe_write+0x7a>
				return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    

00801da8 <devpipe_read>:
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 18             	sub    $0x18,%esp
  801db1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db4:	57                   	push   %edi
  801db5:	e8 0c f2 ff ff       	call   800fc6 <fd2data>
  801dba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc7:	75 14                	jne    801ddd <devpipe_read+0x35>
	return i;
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	eb 02                	jmp    801dd0 <devpipe_read+0x28>
				return i;
  801dce:	89 f0                	mov    %esi,%eax
}
  801dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5f                   	pop    %edi
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    
			sys_yield();
  801dd8:	e8 c5 ee ff ff       	call   800ca2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddd:	8b 03                	mov    (%ebx),%eax
  801ddf:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de2:	75 18                	jne    801dfc <devpipe_read+0x54>
			if (i > 0)
  801de4:	85 f6                	test   %esi,%esi
  801de6:	75 e6                	jne    801dce <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	89 f8                	mov    %edi,%eax
  801dec:	e8 d0 fe ff ff       	call   801cc1 <_pipeisclosed>
  801df1:	85 c0                	test   %eax,%eax
  801df3:	74 e3                	je     801dd8 <devpipe_read+0x30>
				return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	eb d4                	jmp    801dd0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfc:	99                   	cltd   
  801dfd:	c1 ea 1b             	shr    $0x1b,%edx
  801e00:	01 d0                	add    %edx,%eax
  801e02:	83 e0 1f             	and    $0x1f,%eax
  801e05:	29 d0                	sub    %edx,%eax
  801e07:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e12:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e15:	83 c6 01             	add    $0x1,%esi
  801e18:	eb aa                	jmp    801dc4 <devpipe_read+0x1c>

00801e1a <pipe>:
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	56                   	push   %esi
  801e1e:	53                   	push   %ebx
  801e1f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e25:	50                   	push   %eax
  801e26:	e8 b2 f1 ff ff       	call   800fdd <fd_alloc>
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	0f 88 23 01 00 00    	js     801f5b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	68 07 04 00 00       	push   $0x407
  801e40:	ff 75 f4             	pushl  -0xc(%ebp)
  801e43:	6a 00                	push   $0x0
  801e45:	e8 77 ee ff ff       	call   800cc1 <sys_page_alloc>
  801e4a:	89 c3                	mov    %eax,%ebx
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	0f 88 04 01 00 00    	js     801f5b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e5d:	50                   	push   %eax
  801e5e:	e8 7a f1 ff ff       	call   800fdd <fd_alloc>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	0f 88 db 00 00 00    	js     801f4b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 07 04 00 00       	push   $0x407
  801e78:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7b:	6a 00                	push   $0x0
  801e7d:	e8 3f ee ff ff       	call   800cc1 <sys_page_alloc>
  801e82:	89 c3                	mov    %eax,%ebx
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	85 c0                	test   %eax,%eax
  801e89:	0f 88 bc 00 00 00    	js     801f4b <pipe+0x131>
	va = fd2data(fd0);
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	ff 75 f4             	pushl  -0xc(%ebp)
  801e95:	e8 2c f1 ff ff       	call   800fc6 <fd2data>
  801e9a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9c:	83 c4 0c             	add    $0xc,%esp
  801e9f:	68 07 04 00 00       	push   $0x407
  801ea4:	50                   	push   %eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	e8 15 ee ff ff       	call   800cc1 <sys_page_alloc>
  801eac:	89 c3                	mov    %eax,%ebx
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	0f 88 82 00 00 00    	js     801f3b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebf:	e8 02 f1 ff ff       	call   800fc6 <fd2data>
  801ec4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ecb:	50                   	push   %eax
  801ecc:	6a 00                	push   $0x0
  801ece:	56                   	push   %esi
  801ecf:	6a 00                	push   $0x0
  801ed1:	e8 2e ee ff ff       	call   800d04 <sys_page_map>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	83 c4 20             	add    $0x20,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 4e                	js     801f2d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801edf:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eec:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	ff 75 f4             	pushl  -0xc(%ebp)
  801f08:	e8 a9 f0 ff ff       	call   800fb6 <fd2num>
  801f0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f10:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f12:	83 c4 04             	add    $0x4,%esp
  801f15:	ff 75 f0             	pushl  -0x10(%ebp)
  801f18:	e8 99 f0 ff ff       	call   800fb6 <fd2num>
  801f1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f20:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2b:	eb 2e                	jmp    801f5b <pipe+0x141>
	sys_page_unmap(0, va);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	56                   	push   %esi
  801f31:	6a 00                	push   $0x0
  801f33:	e8 0e ee ff ff       	call   800d46 <sys_page_unmap>
  801f38:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f3b:	83 ec 08             	sub    $0x8,%esp
  801f3e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f41:	6a 00                	push   $0x0
  801f43:	e8 fe ed ff ff       	call   800d46 <sys_page_unmap>
  801f48:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f4b:	83 ec 08             	sub    $0x8,%esp
  801f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f51:	6a 00                	push   $0x0
  801f53:	e8 ee ed ff ff       	call   800d46 <sys_page_unmap>
  801f58:	83 c4 10             	add    $0x10,%esp
}
  801f5b:	89 d8                	mov    %ebx,%eax
  801f5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    

00801f64 <pipeisclosed>:
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	e8 b9 f0 ff ff       	call   80102f <fd_lookup>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 18                	js     801f95 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 3e f0 ff ff       	call   800fc6 <fd2data>
	return _pipeisclosed(fd, p);
  801f88:	89 c2                	mov    %eax,%edx
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	e8 2f fd ff ff       	call   801cc1 <_pipeisclosed>
  801f92:	83 c4 10             	add    $0x10,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	c3                   	ret    

00801f9d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa3:	68 0f 2a 80 00       	push   $0x802a0f
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	e8 1f e9 ff ff       	call   8008cf <strcpy>
	return 0;
}
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <devcons_write>:
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	57                   	push   %edi
  801fbb:	56                   	push   %esi
  801fbc:	53                   	push   %ebx
  801fbd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fc8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fce:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd1:	73 31                	jae    802004 <devcons_write+0x4d>
		m = n - tot;
  801fd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd6:	29 f3                	sub    %esi,%ebx
  801fd8:	83 fb 7f             	cmp    $0x7f,%ebx
  801fdb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe3:	83 ec 04             	sub    $0x4,%esp
  801fe6:	53                   	push   %ebx
  801fe7:	89 f0                	mov    %esi,%eax
  801fe9:	03 45 0c             	add    0xc(%ebp),%eax
  801fec:	50                   	push   %eax
  801fed:	57                   	push   %edi
  801fee:	e8 6a ea ff ff       	call   800a5d <memmove>
		sys_cputs(buf, m);
  801ff3:	83 c4 08             	add    $0x8,%esp
  801ff6:	53                   	push   %ebx
  801ff7:	57                   	push   %edi
  801ff8:	e8 08 ec ff ff       	call   800c05 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ffd:	01 de                	add    %ebx,%esi
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	eb ca                	jmp    801fce <devcons_write+0x17>
}
  802004:	89 f0                	mov    %esi,%eax
  802006:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802009:	5b                   	pop    %ebx
  80200a:	5e                   	pop    %esi
  80200b:	5f                   	pop    %edi
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <devcons_read>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201d:	74 21                	je     802040 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80201f:	e8 ff eb ff ff       	call   800c23 <sys_cgetc>
  802024:	85 c0                	test   %eax,%eax
  802026:	75 07                	jne    80202f <devcons_read+0x21>
		sys_yield();
  802028:	e8 75 ec ff ff       	call   800ca2 <sys_yield>
  80202d:	eb f0                	jmp    80201f <devcons_read+0x11>
	if (c < 0)
  80202f:	78 0f                	js     802040 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802031:	83 f8 04             	cmp    $0x4,%eax
  802034:	74 0c                	je     802042 <devcons_read+0x34>
	*(char*)vbuf = c;
  802036:	8b 55 0c             	mov    0xc(%ebp),%edx
  802039:	88 02                	mov    %al,(%edx)
	return 1;
  80203b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    
		return 0;
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
  802047:	eb f7                	jmp    802040 <devcons_read+0x32>

00802049 <cputchar>:
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802055:	6a 01                	push   $0x1
  802057:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205a:	50                   	push   %eax
  80205b:	e8 a5 eb ff ff       	call   800c05 <sys_cputs>
}
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <getchar>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80206b:	6a 01                	push   $0x1
  80206d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802070:	50                   	push   %eax
  802071:	6a 00                	push   $0x0
  802073:	e8 27 f2 ff ff       	call   80129f <read>
	if (r < 0)
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 06                	js     802085 <getchar+0x20>
	if (r < 1)
  80207f:	74 06                	je     802087 <getchar+0x22>
	return c;
  802081:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    
		return -E_EOF;
  802087:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80208c:	eb f7                	jmp    802085 <getchar+0x20>

0080208e <iscons>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802094:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802097:	50                   	push   %eax
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	e8 8f ef ff ff       	call   80102f <fd_lookup>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 11                	js     8020b8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b0:	39 10                	cmp    %edx,(%eax)
  8020b2:	0f 94 c0             	sete   %al
  8020b5:	0f b6 c0             	movzbl %al,%eax
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <opencons>:
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c3:	50                   	push   %eax
  8020c4:	e8 14 ef ff ff       	call   800fdd <fd_alloc>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	78 3a                	js     80210a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	68 07 04 00 00       	push   $0x407
  8020d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 df eb ff ff       	call   800cc1 <sys_page_alloc>
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 21                	js     80210a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	50                   	push   %eax
  802102:	e8 af ee ff ff       	call   800fb6 <fd2num>
  802107:	83 c4 10             	add    $0x10,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	56                   	push   %esi
  802110:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802111:	a1 08 40 80 00       	mov    0x804008,%eax
  802116:	8b 40 48             	mov    0x48(%eax),%eax
  802119:	83 ec 04             	sub    $0x4,%esp
  80211c:	68 40 2a 80 00       	push   $0x802a40
  802121:	50                   	push   %eax
  802122:	68 2f 25 80 00       	push   $0x80252f
  802127:	e8 44 e0 ff ff       	call   800170 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80212c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80212f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802135:	e8 49 eb ff ff       	call   800c83 <sys_getenvid>
  80213a:	83 c4 04             	add    $0x4,%esp
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	56                   	push   %esi
  802144:	50                   	push   %eax
  802145:	68 1c 2a 80 00       	push   $0x802a1c
  80214a:	e8 21 e0 ff ff       	call   800170 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80214f:	83 c4 18             	add    $0x18,%esp
  802152:	53                   	push   %ebx
  802153:	ff 75 10             	pushl  0x10(%ebp)
  802156:	e8 c4 df ff ff       	call   80011f <vcprintf>
	cprintf("\n");
  80215b:	c7 04 24 5a 2a 80 00 	movl   $0x802a5a,(%esp)
  802162:	e8 09 e0 ff ff       	call   800170 <cprintf>
  802167:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80216a:	cc                   	int3   
  80216b:	eb fd                	jmp    80216a <_panic+0x5e>

0080216d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	56                   	push   %esi
  802171:	53                   	push   %ebx
  802172:	8b 75 08             	mov    0x8(%ebp),%esi
  802175:	8b 45 0c             	mov    0xc(%ebp),%eax
  802178:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80217b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80217d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802182:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802185:	83 ec 0c             	sub    $0xc,%esp
  802188:	50                   	push   %eax
  802189:	e8 e3 ec ff ff       	call   800e71 <sys_ipc_recv>
	if(ret < 0){
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 2b                	js     8021c0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802195:	85 f6                	test   %esi,%esi
  802197:	74 0a                	je     8021a3 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802199:	a1 08 40 80 00       	mov    0x804008,%eax
  80219e:	8b 40 78             	mov    0x78(%eax),%eax
  8021a1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021a3:	85 db                	test   %ebx,%ebx
  8021a5:	74 0a                	je     8021b1 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ac:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021af:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
		if(from_env_store)
  8021c0:	85 f6                	test   %esi,%esi
  8021c2:	74 06                	je     8021ca <ipc_recv+0x5d>
			*from_env_store = 0;
  8021c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021ca:	85 db                	test   %ebx,%ebx
  8021cc:	74 eb                	je     8021b9 <ipc_recv+0x4c>
			*perm_store = 0;
  8021ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021d4:	eb e3                	jmp    8021b9 <ipc_recv+0x4c>

008021d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	57                   	push   %edi
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	83 ec 0c             	sub    $0xc,%esp
  8021df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021e8:	85 db                	test   %ebx,%ebx
  8021ea:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021ef:	0f 44 d8             	cmove  %eax,%ebx
  8021f2:	eb 05                	jmp    8021f9 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021f4:	e8 a9 ea ff ff       	call   800ca2 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021f9:	ff 75 14             	pushl  0x14(%ebp)
  8021fc:	53                   	push   %ebx
  8021fd:	56                   	push   %esi
  8021fe:	57                   	push   %edi
  8021ff:	e8 4a ec ff ff       	call   800e4e <sys_ipc_try_send>
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	85 c0                	test   %eax,%eax
  802209:	74 1b                	je     802226 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80220b:	79 e7                	jns    8021f4 <ipc_send+0x1e>
  80220d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802210:	74 e2                	je     8021f4 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 47 2a 80 00       	push   $0x802a47
  80221a:	6a 46                	push   $0x46
  80221c:	68 5c 2a 80 00       	push   $0x802a5c
  802221:	e8 e6 fe ff ff       	call   80210c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802229:	5b                   	pop    %ebx
  80222a:	5e                   	pop    %esi
  80222b:	5f                   	pop    %edi
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802239:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80223f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802245:	8b 52 50             	mov    0x50(%edx),%edx
  802248:	39 ca                	cmp    %ecx,%edx
  80224a:	74 11                	je     80225d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80224c:	83 c0 01             	add    $0x1,%eax
  80224f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802254:	75 e3                	jne    802239 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
  80225b:	eb 0e                	jmp    80226b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80225d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802263:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802268:	8b 40 48             	mov    0x48(%eax),%eax
}
  80226b:	5d                   	pop    %ebp
  80226c:	c3                   	ret    

0080226d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802273:	89 d0                	mov    %edx,%eax
  802275:	c1 e8 16             	shr    $0x16,%eax
  802278:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802284:	f6 c1 01             	test   $0x1,%cl
  802287:	74 1d                	je     8022a6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802289:	c1 ea 0c             	shr    $0xc,%edx
  80228c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802293:	f6 c2 01             	test   $0x1,%dl
  802296:	74 0e                	je     8022a6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802298:	c1 ea 0c             	shr    $0xc,%edx
  80229b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a2:	ef 
  8022a3:	0f b7 c0             	movzwl %ax,%eax
}
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__udivdi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022c7:	85 d2                	test   %edx,%edx
  8022c9:	75 4d                	jne    802318 <__udivdi3+0x68>
  8022cb:	39 f3                	cmp    %esi,%ebx
  8022cd:	76 19                	jbe    8022e8 <__udivdi3+0x38>
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	89 e8                	mov    %ebp,%eax
  8022d3:	89 f2                	mov    %esi,%edx
  8022d5:	f7 f3                	div    %ebx
  8022d7:	89 fa                	mov    %edi,%edx
  8022d9:	83 c4 1c             	add    $0x1c,%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5f                   	pop    %edi
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	89 d9                	mov    %ebx,%ecx
  8022ea:	85 db                	test   %ebx,%ebx
  8022ec:	75 0b                	jne    8022f9 <__udivdi3+0x49>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	31 d2                	xor    %edx,%edx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	f7 f1                	div    %ecx
  8022ff:	89 c6                	mov    %eax,%esi
  802301:	89 e8                	mov    %ebp,%eax
  802303:	89 f7                	mov    %esi,%edi
  802305:	f7 f1                	div    %ecx
  802307:	89 fa                	mov    %edi,%edx
  802309:	83 c4 1c             	add    $0x1c,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5f                   	pop    %edi
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	77 1c                	ja     802338 <__udivdi3+0x88>
  80231c:	0f bd fa             	bsr    %edx,%edi
  80231f:	83 f7 1f             	xor    $0x1f,%edi
  802322:	75 2c                	jne    802350 <__udivdi3+0xa0>
  802324:	39 f2                	cmp    %esi,%edx
  802326:	72 06                	jb     80232e <__udivdi3+0x7e>
  802328:	31 c0                	xor    %eax,%eax
  80232a:	39 eb                	cmp    %ebp,%ebx
  80232c:	77 a9                	ja     8022d7 <__udivdi3+0x27>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	eb a2                	jmp    8022d7 <__udivdi3+0x27>
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	31 ff                	xor    %edi,%edi
  80233a:	31 c0                	xor    %eax,%eax
  80233c:	89 fa                	mov    %edi,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 f9                	mov    %edi,%ecx
  802352:	b8 20 00 00 00       	mov    $0x20,%eax
  802357:	29 f8                	sub    %edi,%eax
  802359:	d3 e2                	shl    %cl,%edx
  80235b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	89 da                	mov    %ebx,%edx
  802363:	d3 ea                	shr    %cl,%edx
  802365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802369:	09 d1                	or     %edx,%ecx
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e3                	shl    %cl,%ebx
  802375:	89 c1                	mov    %eax,%ecx
  802377:	d3 ea                	shr    %cl,%edx
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80237f:	89 eb                	mov    %ebp,%ebx
  802381:	d3 e6                	shl    %cl,%esi
  802383:	89 c1                	mov    %eax,%ecx
  802385:	d3 eb                	shr    %cl,%ebx
  802387:	09 de                	or     %ebx,%esi
  802389:	89 f0                	mov    %esi,%eax
  80238b:	f7 74 24 08          	divl   0x8(%esp)
  80238f:	89 d6                	mov    %edx,%esi
  802391:	89 c3                	mov    %eax,%ebx
  802393:	f7 64 24 0c          	mull   0xc(%esp)
  802397:	39 d6                	cmp    %edx,%esi
  802399:	72 15                	jb     8023b0 <__udivdi3+0x100>
  80239b:	89 f9                	mov    %edi,%ecx
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	39 c5                	cmp    %eax,%ebp
  8023a1:	73 04                	jae    8023a7 <__udivdi3+0xf7>
  8023a3:	39 d6                	cmp    %edx,%esi
  8023a5:	74 09                	je     8023b0 <__udivdi3+0x100>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	31 ff                	xor    %edi,%edi
  8023ab:	e9 27 ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 1d ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__umoddi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023d7:	89 da                	mov    %ebx,%edx
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 43                	jne    802420 <__umoddi3+0x60>
  8023dd:	39 df                	cmp    %ebx,%edi
  8023df:	76 17                	jbe    8023f8 <__umoddi3+0x38>
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	f7 f7                	div    %edi
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	31 d2                	xor    %edx,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 fd                	mov    %edi,%ebp
  8023fa:	85 ff                	test   %edi,%edi
  8023fc:	75 0b                	jne    802409 <__umoddi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f7                	div    %edi
  802407:	89 c5                	mov    %eax,%ebp
  802409:	89 d8                	mov    %ebx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f5                	div    %ebp
  80240f:	89 f0                	mov    %esi,%eax
  802411:	f7 f5                	div    %ebp
  802413:	89 d0                	mov    %edx,%eax
  802415:	eb d0                	jmp    8023e7 <__umoddi3+0x27>
  802417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241e:	66 90                	xchg   %ax,%ax
  802420:	89 f1                	mov    %esi,%ecx
  802422:	39 d8                	cmp    %ebx,%eax
  802424:	76 0a                	jbe    802430 <__umoddi3+0x70>
  802426:	89 f0                	mov    %esi,%eax
  802428:	83 c4 1c             	add    $0x1c,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5f                   	pop    %edi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    
  802430:	0f bd e8             	bsr    %eax,%ebp
  802433:	83 f5 1f             	xor    $0x1f,%ebp
  802436:	75 20                	jne    802458 <__umoddi3+0x98>
  802438:	39 d8                	cmp    %ebx,%eax
  80243a:	0f 82 b0 00 00 00    	jb     8024f0 <__umoddi3+0x130>
  802440:	39 f7                	cmp    %esi,%edi
  802442:	0f 86 a8 00 00 00    	jbe    8024f0 <__umoddi3+0x130>
  802448:	89 c8                	mov    %ecx,%eax
  80244a:	83 c4 1c             	add    $0x1c,%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    
  802452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0xfb>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x107>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x107>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	89 da                	mov    %ebx,%edx
  8024f2:	29 fe                	sub    %edi,%esi
  8024f4:	19 c2                	sbb    %eax,%edx
  8024f6:	89 f1                	mov    %esi,%ecx
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	e9 4b ff ff ff       	jmp    80244a <__umoddi3+0x8a>
