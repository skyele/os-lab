
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800049:	e8 15 0c 00 00       	call   800c63 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800059:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800063:	85 db                	test   %ebx,%ebx
  800065:	7e 07                	jle    80006e <libmain+0x30>
		binaryname = argv[0];
  800067:	8b 06                	mov    (%esi),%eax
  800069:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	e8 bb ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800078:	e8 0a 00 00 00       	call   800087 <exit>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800083:	5b                   	pop    %ebx
  800084:	5e                   	pop    %esi
  800085:	5d                   	pop    %ebp
  800086:	c3                   	ret    

00800087 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80008d:	a1 08 40 80 00       	mov    0x804008,%eax
  800092:	8b 40 48             	mov    0x48(%eax),%eax
  800095:	68 f8 24 80 00       	push   $0x8024f8
  80009a:	50                   	push   %eax
  80009b:	68 ea 24 80 00       	push   $0x8024ea
  8000a0:	e8 ab 00 00 00       	call   800150 <cprintf>
	close_all();
  8000a5:	e8 c4 10 00 00       	call   80116e <close_all>
	sys_env_destroy(0);
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 6c 0b 00 00       	call   800c22 <sys_env_destroy>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	53                   	push   %ebx
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c5:	8b 13                	mov    (%ebx),%edx
  8000c7:	8d 42 01             	lea    0x1(%edx),%eax
  8000ca:	89 03                	mov    %eax,(%ebx)
  8000cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d8:	74 09                	je     8000e3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000da:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	68 ff 00 00 00       	push   $0xff
  8000eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 f1 0a 00 00       	call   800be5 <sys_cputs>
		b->idx = 0;
  8000f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	eb db                	jmp    8000da <putch+0x1f>

008000ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800108:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010f:	00 00 00 
	b.cnt = 0;
  800112:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800119:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011c:	ff 75 0c             	pushl  0xc(%ebp)
  80011f:	ff 75 08             	pushl  0x8(%ebp)
  800122:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800128:	50                   	push   %eax
  800129:	68 bb 00 80 00       	push   $0x8000bb
  80012e:	e8 4a 01 00 00       	call   80027d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 9d 0a 00 00       	call   800be5 <sys_cputs>

	return b.cnt;
}
  800148:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800156:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800159:	50                   	push   %eax
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 9d ff ff ff       	call   8000ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	57                   	push   %edi
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 1c             	sub    $0x1c,%esp
  80016d:	89 c6                	mov    %eax,%esi
  80016f:	89 d7                	mov    %edx,%edi
  800171:	8b 45 08             	mov    0x8(%ebp),%eax
  800174:	8b 55 0c             	mov    0xc(%ebp),%edx
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80017a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800183:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800187:	74 2c                	je     8001b5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800196:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800199:	39 c2                	cmp    %eax,%edx
  80019b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019e:	73 43                	jae    8001e3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001a0:	83 eb 01             	sub    $0x1,%ebx
  8001a3:	85 db                	test   %ebx,%ebx
  8001a5:	7e 6c                	jle    800213 <printnum+0xaf>
				putch(padc, putdat);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	57                   	push   %edi
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	ff d6                	call   *%esi
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb eb                	jmp    8001a0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	6a 20                	push   $0x20
  8001ba:	6a 00                	push   $0x0
  8001bc:	50                   	push   %eax
  8001bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c3:	89 fa                	mov    %edi,%edx
  8001c5:	89 f0                	mov    %esi,%eax
  8001c7:	e8 98 ff ff ff       	call   800164 <printnum>
		while (--width > 0)
  8001cc:	83 c4 20             	add    $0x20,%esp
  8001cf:	83 eb 01             	sub    $0x1,%ebx
  8001d2:	85 db                	test   %ebx,%ebx
  8001d4:	7e 65                	jle    80023b <printnum+0xd7>
			putch(padc, putdat);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	57                   	push   %edi
  8001da:	6a 20                	push   $0x20
  8001dc:	ff d6                	call   *%esi
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	eb ec                	jmp    8001cf <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	ff 75 18             	pushl  0x18(%ebp)
  8001e9:	83 eb 01             	sub    $0x1,%ebx
  8001ec:	53                   	push   %ebx
  8001ed:	50                   	push   %eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	e8 8e 20 00 00       	call   802290 <__udivdi3>
  800202:	83 c4 18             	add    $0x18,%esp
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	89 fa                	mov    %edi,%edx
  800209:	89 f0                	mov    %esi,%eax
  80020b:	e8 54 ff ff ff       	call   800164 <printnum>
  800210:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	57                   	push   %edi
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	ff 75 dc             	pushl  -0x24(%ebp)
  80021d:	ff 75 d8             	pushl  -0x28(%ebp)
  800220:	ff 75 e4             	pushl  -0x1c(%ebp)
  800223:	ff 75 e0             	pushl  -0x20(%ebp)
  800226:	e8 75 21 00 00       	call   8023a0 <__umoddi3>
  80022b:	83 c4 14             	add    $0x14,%esp
  80022e:	0f be 80 fd 24 80 00 	movsbl 0x8024fd(%eax),%eax
  800235:	50                   	push   %eax
  800236:	ff d6                	call   *%esi
  800238:	83 c4 10             	add    $0x10,%esp
	}
}
  80023b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800249:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80024d:	8b 10                	mov    (%eax),%edx
  80024f:	3b 50 04             	cmp    0x4(%eax),%edx
  800252:	73 0a                	jae    80025e <sprintputch+0x1b>
		*b->buf++ = ch;
  800254:	8d 4a 01             	lea    0x1(%edx),%ecx
  800257:	89 08                	mov    %ecx,(%eax)
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	88 02                	mov    %al,(%edx)
}
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <printfmt>:
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800266:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800269:	50                   	push   %eax
  80026a:	ff 75 10             	pushl  0x10(%ebp)
  80026d:	ff 75 0c             	pushl  0xc(%ebp)
  800270:	ff 75 08             	pushl  0x8(%ebp)
  800273:	e8 05 00 00 00       	call   80027d <vprintfmt>
}
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <vprintfmt>:
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	57                   	push   %edi
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 3c             	sub    $0x3c,%esp
  800286:	8b 75 08             	mov    0x8(%ebp),%esi
  800289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028f:	e9 32 04 00 00       	jmp    8006c6 <vprintfmt+0x449>
		padc = ' ';
  800294:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800298:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80029f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c0:	8d 47 01             	lea    0x1(%edi),%eax
  8002c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c6:	0f b6 17             	movzbl (%edi),%edx
  8002c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cc:	3c 55                	cmp    $0x55,%al
  8002ce:	0f 87 12 05 00 00    	ja     8007e6 <vprintfmt+0x569>
  8002d4:	0f b6 c0             	movzbl %al,%eax
  8002d7:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  8002de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002e5:	eb d9                	jmp    8002c0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ea:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002ee:	eb d0                	jmp    8002c0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f0:	0f b6 d2             	movzbl %dl,%edx
  8002f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8002fe:	eb 03                	jmp    800303 <vprintfmt+0x86>
  800300:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800303:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800306:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80030d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800310:	83 fe 09             	cmp    $0x9,%esi
  800313:	76 eb                	jbe    800300 <vprintfmt+0x83>
  800315:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800318:	8b 75 08             	mov    0x8(%ebp),%esi
  80031b:	eb 14                	jmp    800331 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8b 00                	mov    (%eax),%eax
  800322:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800325:	8b 45 14             	mov    0x14(%ebp),%eax
  800328:	8d 40 04             	lea    0x4(%eax),%eax
  80032b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800331:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800335:	79 89                	jns    8002c0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800344:	e9 77 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	85 c0                	test   %eax,%eax
  80034e:	0f 48 c1             	cmovs  %ecx,%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800357:	e9 64 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800366:	e9 55 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
			lflag++;
  80036b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800372:	e9 49 ff ff ff       	jmp    8002c0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8d 78 04             	lea    0x4(%eax),%edi
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	53                   	push   %ebx
  800381:	ff 30                	pushl  (%eax)
  800383:	ff d6                	call   *%esi
			break;
  800385:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800388:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038b:	e9 33 03 00 00       	jmp    8006c3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	8d 78 04             	lea    0x4(%eax),%edi
  800396:	8b 00                	mov    (%eax),%eax
  800398:	99                   	cltd   
  800399:	31 d0                	xor    %edx,%eax
  80039b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039d:	83 f8 11             	cmp    $0x11,%eax
  8003a0:	7f 23                	jg     8003c5 <vprintfmt+0x148>
  8003a2:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  8003a9:	85 d2                	test   %edx,%edx
  8003ab:	74 18                	je     8003c5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003ad:	52                   	push   %edx
  8003ae:	68 5d 29 80 00       	push   $0x80295d
  8003b3:	53                   	push   %ebx
  8003b4:	56                   	push   %esi
  8003b5:	e8 a6 fe ff ff       	call   800260 <printfmt>
  8003ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c0:	e9 fe 02 00 00       	jmp    8006c3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003c5:	50                   	push   %eax
  8003c6:	68 15 25 80 00       	push   $0x802515
  8003cb:	53                   	push   %ebx
  8003cc:	56                   	push   %esi
  8003cd:	e8 8e fe ff ff       	call   800260 <printfmt>
  8003d2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d8:	e9 e6 02 00 00       	jmp    8006c3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	83 c0 04             	add    $0x4,%eax
  8003e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003eb:	85 c9                	test   %ecx,%ecx
  8003ed:	b8 0e 25 80 00       	mov    $0x80250e,%eax
  8003f2:	0f 45 c1             	cmovne %ecx,%eax
  8003f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8003f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fc:	7e 06                	jle    800404 <vprintfmt+0x187>
  8003fe:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800402:	75 0d                	jne    800411 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800404:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800407:	89 c7                	mov    %eax,%edi
  800409:	03 45 e0             	add    -0x20(%ebp),%eax
  80040c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040f:	eb 53                	jmp    800464 <vprintfmt+0x1e7>
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 d8             	pushl  -0x28(%ebp)
  800417:	50                   	push   %eax
  800418:	e8 71 04 00 00       	call   80088e <strnlen>
  80041d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800420:	29 c1                	sub    %eax,%ecx
  800422:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80042a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80042e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800431:	eb 0f                	jmp    800442 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	53                   	push   %ebx
  800437:	ff 75 e0             	pushl  -0x20(%ebp)
  80043a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043c:	83 ef 01             	sub    $0x1,%edi
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	85 ff                	test   %edi,%edi
  800444:	7f ed                	jg     800433 <vprintfmt+0x1b6>
  800446:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800449:	85 c9                	test   %ecx,%ecx
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	0f 49 c1             	cmovns %ecx,%eax
  800453:	29 c1                	sub    %eax,%ecx
  800455:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800458:	eb aa                	jmp    800404 <vprintfmt+0x187>
					putch(ch, putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	52                   	push   %edx
  80045f:	ff d6                	call   *%esi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800467:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800469:	83 c7 01             	add    $0x1,%edi
  80046c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800470:	0f be d0             	movsbl %al,%edx
  800473:	85 d2                	test   %edx,%edx
  800475:	74 4b                	je     8004c2 <vprintfmt+0x245>
  800477:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80047b:	78 06                	js     800483 <vprintfmt+0x206>
  80047d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800481:	78 1e                	js     8004a1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800483:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800487:	74 d1                	je     80045a <vprintfmt+0x1dd>
  800489:	0f be c0             	movsbl %al,%eax
  80048c:	83 e8 20             	sub    $0x20,%eax
  80048f:	83 f8 5e             	cmp    $0x5e,%eax
  800492:	76 c6                	jbe    80045a <vprintfmt+0x1dd>
					putch('?', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	6a 3f                	push   $0x3f
  80049a:	ff d6                	call   *%esi
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	eb c3                	jmp    800464 <vprintfmt+0x1e7>
  8004a1:	89 cf                	mov    %ecx,%edi
  8004a3:	eb 0e                	jmp    8004b3 <vprintfmt+0x236>
				putch(' ', putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	53                   	push   %ebx
  8004a9:	6a 20                	push   $0x20
  8004ab:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ad:	83 ef 01             	sub    $0x1,%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	85 ff                	test   %edi,%edi
  8004b5:	7f ee                	jg     8004a5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bd:	e9 01 02 00 00       	jmp    8006c3 <vprintfmt+0x446>
  8004c2:	89 cf                	mov    %ecx,%edi
  8004c4:	eb ed                	jmp    8004b3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004c9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004d0:	e9 eb fd ff ff       	jmp    8002c0 <vprintfmt+0x43>
	if (lflag >= 2)
  8004d5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004d9:	7f 21                	jg     8004fc <vprintfmt+0x27f>
	else if (lflag)
  8004db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004df:	74 68                	je     800549 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e9:	89 c1                	mov    %eax,%ecx
  8004eb:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ee:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 40 04             	lea    0x4(%eax),%eax
  8004f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fa:	eb 17                	jmp    800513 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	8b 50 04             	mov    0x4(%eax),%edx
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800507:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 40 08             	lea    0x8(%eax),%eax
  800510:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800513:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800516:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800519:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80051f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800523:	78 3f                	js     800564 <vprintfmt+0x2e7>
			base = 10;
  800525:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80052a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80052e:	0f 84 71 01 00 00    	je     8006a5 <vprintfmt+0x428>
				putch('+', putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	6a 2b                	push   $0x2b
  80053a:	ff d6                	call   *%esi
  80053c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800544:	e9 5c 01 00 00       	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800551:	89 c1                	mov    %eax,%ecx
  800553:	c1 f9 1f             	sar    $0x1f,%ecx
  800556:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 40 04             	lea    0x4(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
  800562:	eb af                	jmp    800513 <vprintfmt+0x296>
				putch('-', putdat);
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	53                   	push   %ebx
  800568:	6a 2d                	push   $0x2d
  80056a:	ff d6                	call   *%esi
				num = -(long long) num;
  80056c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800572:	f7 d8                	neg    %eax
  800574:	83 d2 00             	adc    $0x0,%edx
  800577:	f7 da                	neg    %edx
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800582:	b8 0a 00 00 00       	mov    $0xa,%eax
  800587:	e9 19 01 00 00       	jmp    8006a5 <vprintfmt+0x428>
	if (lflag >= 2)
  80058c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800590:	7f 29                	jg     8005bb <vprintfmt+0x33e>
	else if (lflag)
  800592:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800596:	74 44                	je     8005dc <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b6:	e9 ea 00 00 00       	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 50 04             	mov    0x4(%eax),%edx
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8d 40 08             	lea    0x8(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d7:	e9 c9 00 00 00       	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8d 40 04             	lea    0x4(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 a6 00 00 00       	jmp    8006a5 <vprintfmt+0x428>
			putch('0', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 30                	push   $0x30
  800605:	ff d6                	call   *%esi
	if (lflag >= 2)
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060e:	7f 26                	jg     800636 <vprintfmt+0x3b9>
	else if (lflag)
  800610:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800614:	74 3e                	je     800654 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062f:	b8 08 00 00 00       	mov    $0x8,%eax
  800634:	eb 6f                	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 50 04             	mov    0x4(%eax),%edx
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 08             	lea    0x8(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064d:	b8 08 00 00 00       	mov    $0x8,%eax
  800652:	eb 51                	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066d:	b8 08 00 00 00       	mov    $0x8,%eax
  800672:	eb 31                	jmp    8006a5 <vprintfmt+0x428>
			putch('0', putdat);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 30                	push   $0x30
  80067a:	ff d6                	call   *%esi
			putch('x', putdat);
  80067c:	83 c4 08             	add    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	6a 78                	push   $0x78
  800682:	ff d6                	call   *%esi
			num = (unsigned long long)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800694:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a5:	83 ec 0c             	sub    $0xc,%esp
  8006a8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006ac:	52                   	push   %edx
  8006ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b0:	50                   	push   %eax
  8006b1:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b7:	89 da                	mov    %ebx,%edx
  8006b9:	89 f0                	mov    %esi,%eax
  8006bb:	e8 a4 fa ff ff       	call   800164 <printnum>
			break;
  8006c0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c6:	83 c7 01             	add    $0x1,%edi
  8006c9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cd:	83 f8 25             	cmp    $0x25,%eax
  8006d0:	0f 84 be fb ff ff    	je     800294 <vprintfmt+0x17>
			if (ch == '\0')
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	0f 84 28 01 00 00    	je     800806 <vprintfmt+0x589>
			putch(ch, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	50                   	push   %eax
  8006e3:	ff d6                	call   *%esi
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	eb dc                	jmp    8006c6 <vprintfmt+0x449>
	if (lflag >= 2)
  8006ea:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ee:	7f 26                	jg     800716 <vprintfmt+0x499>
	else if (lflag)
  8006f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f4:	74 41                	je     800737 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800703:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	b8 10 00 00 00       	mov    $0x10,%eax
  800714:	eb 8f                	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 50 04             	mov    0x4(%eax),%edx
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 08             	lea    0x8(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
  800732:	e9 6e ff ff ff       	jmp    8006a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	ba 00 00 00 00       	mov    $0x0,%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800750:	b8 10 00 00 00       	mov    $0x10,%eax
  800755:	e9 4b ff ff ff       	jmp    8006a5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	83 c0 04             	add    $0x4,%eax
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	85 c0                	test   %eax,%eax
  80076a:	74 14                	je     800780 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80076c:	8b 13                	mov    (%ebx),%edx
  80076e:	83 fa 7f             	cmp    $0x7f,%edx
  800771:	7f 37                	jg     8007aa <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800773:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800775:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	e9 43 ff ff ff       	jmp    8006c3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800780:	b8 0a 00 00 00       	mov    $0xa,%eax
  800785:	bf 31 26 80 00       	mov    $0x802631,%edi
							putch(ch, putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800791:	83 c7 01             	add    $0x1,%edi
  800794:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	85 c0                	test   %eax,%eax
  80079d:	75 eb                	jne    80078a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80079f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	e9 19 ff ff ff       	jmp    8006c3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007aa:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b1:	bf 69 26 80 00       	mov    $0x802669,%edi
							putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	50                   	push   %eax
  8007bb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007bd:	83 c7 01             	add    $0x1,%edi
  8007c0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	75 eb                	jne    8007b6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d1:	e9 ed fe ff ff       	jmp    8006c3 <vprintfmt+0x446>
			putch(ch, putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	6a 25                	push   $0x25
  8007dc:	ff d6                	call   *%esi
			break;
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	e9 dd fe ff ff       	jmp    8006c3 <vprintfmt+0x446>
			putch('%', putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	6a 25                	push   $0x25
  8007ec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	89 f8                	mov    %edi,%eax
  8007f3:	eb 03                	jmp    8007f8 <vprintfmt+0x57b>
  8007f5:	83 e8 01             	sub    $0x1,%eax
  8007f8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007fc:	75 f7                	jne    8007f5 <vprintfmt+0x578>
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	e9 bd fe ff ff       	jmp    8006c3 <vprintfmt+0x446>
}
  800806:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800809:	5b                   	pop    %ebx
  80080a:	5e                   	pop    %esi
  80080b:	5f                   	pop    %edi
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80081d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800821:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800824:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082b:	85 c0                	test   %eax,%eax
  80082d:	74 26                	je     800855 <vsnprintf+0x47>
  80082f:	85 d2                	test   %edx,%edx
  800831:	7e 22                	jle    800855 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800833:	ff 75 14             	pushl  0x14(%ebp)
  800836:	ff 75 10             	pushl  0x10(%ebp)
  800839:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80083c:	50                   	push   %eax
  80083d:	68 43 02 80 00       	push   $0x800243
  800842:	e8 36 fa ff ff       	call   80027d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800850:	83 c4 10             	add    $0x10,%esp
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    
		return -E_INVAL;
  800855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085a:	eb f7                	jmp    800853 <vsnprintf+0x45>

0080085c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800865:	50                   	push   %eax
  800866:	ff 75 10             	pushl  0x10(%ebp)
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	ff 75 08             	pushl  0x8(%ebp)
  80086f:	e8 9a ff ff ff       	call   80080e <vsnprintf>
	va_end(ap);

	return rc;
}
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80087c:	b8 00 00 00 00       	mov    $0x0,%eax
  800881:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800885:	74 05                	je     80088c <strlen+0x16>
		n++;
  800887:	83 c0 01             	add    $0x1,%eax
  80088a:	eb f5                	jmp    800881 <strlen+0xb>
	return n;
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800894:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	74 0d                	je     8008ad <strnlen+0x1f>
  8008a0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008a4:	74 05                	je     8008ab <strnlen+0x1d>
		n++;
  8008a6:	83 c2 01             	add    $0x1,%edx
  8008a9:	eb f1                	jmp    80089c <strnlen+0xe>
  8008ab:	89 d0                	mov    %edx,%eax
	return n;
}
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	53                   	push   %ebx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008c2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c5:	83 c2 01             	add    $0x1,%edx
  8008c8:	84 c9                	test   %cl,%cl
  8008ca:	75 f2                	jne    8008be <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008cc:	5b                   	pop    %ebx
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	53                   	push   %ebx
  8008d3:	83 ec 10             	sub    $0x10,%esp
  8008d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d9:	53                   	push   %ebx
  8008da:	e8 97 ff ff ff       	call   800876 <strlen>
  8008df:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	01 d8                	add    %ebx,%eax
  8008e7:	50                   	push   %eax
  8008e8:	e8 c2 ff ff ff       	call   8008af <strcpy>
	return dst;
}
  8008ed:	89 d8                	mov    %ebx,%eax
  8008ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	56                   	push   %esi
  8008f8:	53                   	push   %ebx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ff:	89 c6                	mov    %eax,%esi
  800901:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800904:	89 c2                	mov    %eax,%edx
  800906:	39 f2                	cmp    %esi,%edx
  800908:	74 11                	je     80091b <strncpy+0x27>
		*dst++ = *src;
  80090a:	83 c2 01             	add    $0x1,%edx
  80090d:	0f b6 19             	movzbl (%ecx),%ebx
  800910:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800913:	80 fb 01             	cmp    $0x1,%bl
  800916:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800919:	eb eb                	jmp    800906 <strncpy+0x12>
	}
	return ret;
}
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	56                   	push   %esi
  800923:	53                   	push   %ebx
  800924:	8b 75 08             	mov    0x8(%ebp),%esi
  800927:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092a:	8b 55 10             	mov    0x10(%ebp),%edx
  80092d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092f:	85 d2                	test   %edx,%edx
  800931:	74 21                	je     800954 <strlcpy+0x35>
  800933:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800937:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800939:	39 c2                	cmp    %eax,%edx
  80093b:	74 14                	je     800951 <strlcpy+0x32>
  80093d:	0f b6 19             	movzbl (%ecx),%ebx
  800940:	84 db                	test   %bl,%bl
  800942:	74 0b                	je     80094f <strlcpy+0x30>
			*dst++ = *src++;
  800944:	83 c1 01             	add    $0x1,%ecx
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80094d:	eb ea                	jmp    800939 <strlcpy+0x1a>
  80094f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800951:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800954:	29 f0                	sub    %esi,%eax
}
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800963:	0f b6 01             	movzbl (%ecx),%eax
  800966:	84 c0                	test   %al,%al
  800968:	74 0c                	je     800976 <strcmp+0x1c>
  80096a:	3a 02                	cmp    (%edx),%al
  80096c:	75 08                	jne    800976 <strcmp+0x1c>
		p++, q++;
  80096e:	83 c1 01             	add    $0x1,%ecx
  800971:	83 c2 01             	add    $0x1,%edx
  800974:	eb ed                	jmp    800963 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800976:	0f b6 c0             	movzbl %al,%eax
  800979:	0f b6 12             	movzbl (%edx),%edx
  80097c:	29 d0                	sub    %edx,%eax
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	53                   	push   %ebx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	89 c3                	mov    %eax,%ebx
  80098c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098f:	eb 06                	jmp    800997 <strncmp+0x17>
		n--, p++, q++;
  800991:	83 c0 01             	add    $0x1,%eax
  800994:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800997:	39 d8                	cmp    %ebx,%eax
  800999:	74 16                	je     8009b1 <strncmp+0x31>
  80099b:	0f b6 08             	movzbl (%eax),%ecx
  80099e:	84 c9                	test   %cl,%cl
  8009a0:	74 04                	je     8009a6 <strncmp+0x26>
  8009a2:	3a 0a                	cmp    (%edx),%cl
  8009a4:	74 eb                	je     800991 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a6:	0f b6 00             	movzbl (%eax),%eax
  8009a9:	0f b6 12             	movzbl (%edx),%edx
  8009ac:	29 d0                	sub    %edx,%eax
}
  8009ae:	5b                   	pop    %ebx
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    
		return 0;
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b6:	eb f6                	jmp    8009ae <strncmp+0x2e>

008009b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c2:	0f b6 10             	movzbl (%eax),%edx
  8009c5:	84 d2                	test   %dl,%dl
  8009c7:	74 09                	je     8009d2 <strchr+0x1a>
		if (*s == c)
  8009c9:	38 ca                	cmp    %cl,%dl
  8009cb:	74 0a                	je     8009d7 <strchr+0x1f>
	for (; *s; s++)
  8009cd:	83 c0 01             	add    $0x1,%eax
  8009d0:	eb f0                	jmp    8009c2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e6:	38 ca                	cmp    %cl,%dl
  8009e8:	74 09                	je     8009f3 <strfind+0x1a>
  8009ea:	84 d2                	test   %dl,%dl
  8009ec:	74 05                	je     8009f3 <strfind+0x1a>
	for (; *s; s++)
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	eb f0                	jmp    8009e3 <strfind+0xa>
			break;
	return (char *) s;
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	57                   	push   %edi
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a01:	85 c9                	test   %ecx,%ecx
  800a03:	74 31                	je     800a36 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a05:	89 f8                	mov    %edi,%eax
  800a07:	09 c8                	or     %ecx,%eax
  800a09:	a8 03                	test   $0x3,%al
  800a0b:	75 23                	jne    800a30 <memset+0x3b>
		c &= 0xFF;
  800a0d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a11:	89 d3                	mov    %edx,%ebx
  800a13:	c1 e3 08             	shl    $0x8,%ebx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	c1 e0 18             	shl    $0x18,%eax
  800a1b:	89 d6                	mov    %edx,%esi
  800a1d:	c1 e6 10             	shl    $0x10,%esi
  800a20:	09 f0                	or     %esi,%eax
  800a22:	09 c2                	or     %eax,%edx
  800a24:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a26:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a29:	89 d0                	mov    %edx,%eax
  800a2b:	fc                   	cld    
  800a2c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2e:	eb 06                	jmp    800a36 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	fc                   	cld    
  800a34:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a36:	89 f8                	mov    %edi,%eax
  800a38:	5b                   	pop    %ebx
  800a39:	5e                   	pop    %esi
  800a3a:	5f                   	pop    %edi
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	57                   	push   %edi
  800a41:	56                   	push   %esi
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a4b:	39 c6                	cmp    %eax,%esi
  800a4d:	73 32                	jae    800a81 <memmove+0x44>
  800a4f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	76 2b                	jbe    800a81 <memmove+0x44>
		s += n;
		d += n;
  800a56:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a59:	89 fe                	mov    %edi,%esi
  800a5b:	09 ce                	or     %ecx,%esi
  800a5d:	09 d6                	or     %edx,%esi
  800a5f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a65:	75 0e                	jne    800a75 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a67:	83 ef 04             	sub    $0x4,%edi
  800a6a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a70:	fd                   	std    
  800a71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a73:	eb 09                	jmp    800a7e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a75:	83 ef 01             	sub    $0x1,%edi
  800a78:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a7b:	fd                   	std    
  800a7c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7e:	fc                   	cld    
  800a7f:	eb 1a                	jmp    800a9b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	09 ca                	or     %ecx,%edx
  800a85:	09 f2                	or     %esi,%edx
  800a87:	f6 c2 03             	test   $0x3,%dl
  800a8a:	75 0a                	jne    800a96 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a8f:	89 c7                	mov    %eax,%edi
  800a91:	fc                   	cld    
  800a92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a94:	eb 05                	jmp    800a9b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a96:	89 c7                	mov    %eax,%edi
  800a98:	fc                   	cld    
  800a99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a9b:	5e                   	pop    %esi
  800a9c:	5f                   	pop    %edi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa5:	ff 75 10             	pushl  0x10(%ebp)
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	ff 75 08             	pushl  0x8(%ebp)
  800aae:	e8 8a ff ff ff       	call   800a3d <memmove>
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	56                   	push   %esi
  800ab9:	53                   	push   %ebx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	89 c6                	mov    %eax,%esi
  800ac2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac5:	39 f0                	cmp    %esi,%eax
  800ac7:	74 1c                	je     800ae5 <memcmp+0x30>
		if (*s1 != *s2)
  800ac9:	0f b6 08             	movzbl (%eax),%ecx
  800acc:	0f b6 1a             	movzbl (%edx),%ebx
  800acf:	38 d9                	cmp    %bl,%cl
  800ad1:	75 08                	jne    800adb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	eb ea                	jmp    800ac5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800adb:	0f b6 c1             	movzbl %cl,%eax
  800ade:	0f b6 db             	movzbl %bl,%ebx
  800ae1:	29 d8                	sub    %ebx,%eax
  800ae3:	eb 05                	jmp    800aea <memcmp+0x35>
	}

	return 0;
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af7:	89 c2                	mov    %eax,%edx
  800af9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800afc:	39 d0                	cmp    %edx,%eax
  800afe:	73 09                	jae    800b09 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b00:	38 08                	cmp    %cl,(%eax)
  800b02:	74 05                	je     800b09 <memfind+0x1b>
	for (; s < ends; s++)
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	eb f3                	jmp    800afc <memfind+0xe>
			break;
	return (void *) s;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b17:	eb 03                	jmp    800b1c <strtol+0x11>
		s++;
  800b19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b1c:	0f b6 01             	movzbl (%ecx),%eax
  800b1f:	3c 20                	cmp    $0x20,%al
  800b21:	74 f6                	je     800b19 <strtol+0xe>
  800b23:	3c 09                	cmp    $0x9,%al
  800b25:	74 f2                	je     800b19 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b27:	3c 2b                	cmp    $0x2b,%al
  800b29:	74 2a                	je     800b55 <strtol+0x4a>
	int neg = 0;
  800b2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b30:	3c 2d                	cmp    $0x2d,%al
  800b32:	74 2b                	je     800b5f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b3a:	75 0f                	jne    800b4b <strtol+0x40>
  800b3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3f:	74 28                	je     800b69 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	85 db                	test   %ebx,%ebx
  800b43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b48:	0f 44 d8             	cmove  %eax,%ebx
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b53:	eb 50                	jmp    800ba5 <strtol+0x9a>
		s++;
  800b55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b58:	bf 00 00 00 00       	mov    $0x0,%edi
  800b5d:	eb d5                	jmp    800b34 <strtol+0x29>
		s++, neg = 1;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	bf 01 00 00 00       	mov    $0x1,%edi
  800b67:	eb cb                	jmp    800b34 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b6d:	74 0e                	je     800b7d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	75 d8                	jne    800b4b <strtol+0x40>
		s++, base = 8;
  800b73:	83 c1 01             	add    $0x1,%ecx
  800b76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b7b:	eb ce                	jmp    800b4b <strtol+0x40>
		s += 2, base = 16;
  800b7d:	83 c1 02             	add    $0x2,%ecx
  800b80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b85:	eb c4                	jmp    800b4b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b87:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 29                	ja     800bba <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b97:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b9a:	7d 30                	jge    800bcc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b9c:	83 c1 01             	add    $0x1,%ecx
  800b9f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ba3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba5:	0f b6 11             	movzbl (%ecx),%edx
  800ba8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bab:	89 f3                	mov    %esi,%ebx
  800bad:	80 fb 09             	cmp    $0x9,%bl
  800bb0:	77 d5                	ja     800b87 <strtol+0x7c>
			dig = *s - '0';
  800bb2:	0f be d2             	movsbl %dl,%edx
  800bb5:	83 ea 30             	sub    $0x30,%edx
  800bb8:	eb dd                	jmp    800b97 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bbd:	89 f3                	mov    %esi,%ebx
  800bbf:	80 fb 19             	cmp    $0x19,%bl
  800bc2:	77 08                	ja     800bcc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc4:	0f be d2             	movsbl %dl,%edx
  800bc7:	83 ea 37             	sub    $0x37,%edx
  800bca:	eb cb                	jmp    800b97 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 05                	je     800bd7 <strtol+0xcc>
		*endptr = (char *) s;
  800bd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd7:	89 c2                	mov    %eax,%edx
  800bd9:	f7 da                	neg    %edx
  800bdb:	85 ff                	test   %edi,%edi
  800bdd:	0f 45 c2             	cmovne %edx,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf6:	89 c3                	mov    %eax,%ebx
  800bf8:	89 c7                	mov    %eax,%edi
  800bfa:	89 c6                	mov    %eax,%esi
  800bfc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c09:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c13:	89 d1                	mov    %edx,%ecx
  800c15:	89 d3                	mov    %edx,%ebx
  800c17:	89 d7                	mov    %edx,%edi
  800c19:	89 d6                	mov    %edx,%esi
  800c1b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	b8 03 00 00 00       	mov    $0x3,%eax
  800c38:	89 cb                	mov    %ecx,%ebx
  800c3a:	89 cf                	mov    %ecx,%edi
  800c3c:	89 ce                	mov    %ecx,%esi
  800c3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c40:	85 c0                	test   %eax,%eax
  800c42:	7f 08                	jg     800c4c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	50                   	push   %eax
  800c50:	6a 03                	push   $0x3
  800c52:	68 88 28 80 00       	push   $0x802888
  800c57:	6a 43                	push   $0x43
  800c59:	68 a5 28 80 00       	push   $0x8028a5
  800c5e:	e8 89 14 00 00       	call   8020ec <_panic>

00800c63 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_yield>:

void
sys_yield(void)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c88:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c92:	89 d1                	mov    %edx,%ecx
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	89 d7                	mov    %edx,%edi
  800c98:	89 d6                	mov    %edx,%esi
  800c9a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caa:	be 00 00 00 00       	mov    $0x0,%esi
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbd:	89 f7                	mov    %esi,%edi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 04                	push   $0x4
  800cd3:	68 88 28 80 00       	push   $0x802888
  800cd8:	6a 43                	push   $0x43
  800cda:	68 a5 28 80 00       	push   $0x8028a5
  800cdf:	e8 08 14 00 00       	call   8020ec <_panic>

00800ce4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfe:	8b 75 18             	mov    0x18(%ebp),%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 05                	push   $0x5
  800d15:	68 88 28 80 00       	push   $0x802888
  800d1a:	6a 43                	push   $0x43
  800d1c:	68 a5 28 80 00       	push   $0x8028a5
  800d21:	e8 c6 13 00 00       	call   8020ec <_panic>

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3f:	89 df                	mov    %ebx,%edi
  800d41:	89 de                	mov    %ebx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 06                	push   $0x6
  800d57:	68 88 28 80 00       	push   $0x802888
  800d5c:	6a 43                	push   $0x43
  800d5e:	68 a5 28 80 00       	push   $0x8028a5
  800d63:	e8 84 13 00 00       	call   8020ec <_panic>

00800d68 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 08                	push   $0x8
  800d99:	68 88 28 80 00       	push   $0x802888
  800d9e:	6a 43                	push   $0x43
  800da0:	68 a5 28 80 00       	push   $0x8028a5
  800da5:	e8 42 13 00 00       	call   8020ec <_panic>

00800daa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 09                	push   $0x9
  800ddb:	68 88 28 80 00       	push   $0x802888
  800de0:	6a 43                	push   $0x43
  800de2:	68 a5 28 80 00       	push   $0x8028a5
  800de7:	e8 00 13 00 00       	call   8020ec <_panic>

00800dec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 0a                	push   $0xa
  800e1d:	68 88 28 80 00       	push   $0x802888
  800e22:	6a 43                	push   $0x43
  800e24:	68 a5 28 80 00       	push   $0x8028a5
  800e29:	e8 be 12 00 00       	call   8020ec <_panic>

00800e2e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3f:	be 00 00 00 00       	mov    $0x0,%esi
  800e44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e47:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e67:	89 cb                	mov    %ecx,%ebx
  800e69:	89 cf                	mov    %ecx,%edi
  800e6b:	89 ce                	mov    %ecx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 0d                	push   $0xd
  800e81:	68 88 28 80 00       	push   $0x802888
  800e86:	6a 43                	push   $0x43
  800e88:	68 a5 28 80 00       	push   $0x8028a5
  800e8d:	e8 5a 12 00 00       	call   8020ec <_panic>

00800e92 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea8:	89 df                	mov    %ebx,%edi
  800eaa:	89 de                	mov    %ebx,%esi
  800eac:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ec6:	89 cb                	mov    %ecx,%ebx
  800ec8:	89 cf                	mov    %ecx,%edi
  800eca:	89 ce                	mov    %ecx,%esi
  800ecc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ede:	b8 10 00 00 00       	mov    $0x10,%eax
  800ee3:	89 d1                	mov    %edx,%ecx
  800ee5:	89 d3                	mov    %edx,%ebx
  800ee7:	89 d7                	mov    %edx,%edi
  800ee9:	89 d6                	mov    %edx,%esi
  800eeb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	b8 11 00 00 00       	mov    $0x11,%eax
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	89 de                	mov    %ebx,%esi
  800f0c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 12 00 00 00       	mov    $0x12,%eax
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	b8 13 00 00 00       	mov    $0x13,%eax
  800f4d:	89 df                	mov    %ebx,%edi
  800f4f:	89 de                	mov    %ebx,%esi
  800f51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	7f 08                	jg     800f5f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	50                   	push   %eax
  800f63:	6a 13                	push   $0x13
  800f65:	68 88 28 80 00       	push   $0x802888
  800f6a:	6a 43                	push   $0x43
  800f6c:	68 a5 28 80 00       	push   $0x8028a5
  800f71:	e8 76 11 00 00       	call   8020ec <_panic>

00800f76 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	b8 14 00 00 00       	mov    $0x14,%eax
  800f89:	89 cb                	mov    %ecx,%ebx
  800f8b:	89 cf                	mov    %ecx,%edi
  800f8d:	89 ce                	mov    %ecx,%esi
  800f8f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	05 00 00 00 30       	add    $0x30000000,%eax
  800fa1:	c1 e8 0c             	shr    $0xc,%eax
}
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fb1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	c1 ea 16             	shr    $0x16,%edx
  800fca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fd1:	f6 c2 01             	test   $0x1,%dl
  800fd4:	74 2d                	je     801003 <fd_alloc+0x46>
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	c1 ea 0c             	shr    $0xc,%edx
  800fdb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe2:	f6 c2 01             	test   $0x1,%dl
  800fe5:	74 1c                	je     801003 <fd_alloc+0x46>
  800fe7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fec:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ff1:	75 d2                	jne    800fc5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ffc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801001:	eb 0a                	jmp    80100d <fd_alloc+0x50>
			*fd_store = fd;
  801003:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801006:	89 01                	mov    %eax,(%ecx)
			return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801015:	83 f8 1f             	cmp    $0x1f,%eax
  801018:	77 30                	ja     80104a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80101a:	c1 e0 0c             	shl    $0xc,%eax
  80101d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801022:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801028:	f6 c2 01             	test   $0x1,%dl
  80102b:	74 24                	je     801051 <fd_lookup+0x42>
  80102d:	89 c2                	mov    %eax,%edx
  80102f:	c1 ea 0c             	shr    $0xc,%edx
  801032:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801039:	f6 c2 01             	test   $0x1,%dl
  80103c:	74 1a                	je     801058 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	89 02                	mov    %eax,(%edx)
	return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    
		return -E_INVAL;
  80104a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104f:	eb f7                	jmp    801048 <fd_lookup+0x39>
		return -E_INVAL;
  801051:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801056:	eb f0                	jmp    801048 <fd_lookup+0x39>
  801058:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105d:	eb e9                	jmp    801048 <fd_lookup+0x39>

0080105f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801072:	39 08                	cmp    %ecx,(%eax)
  801074:	74 38                	je     8010ae <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801076:	83 c2 01             	add    $0x1,%edx
  801079:	8b 04 95 30 29 80 00 	mov    0x802930(,%edx,4),%eax
  801080:	85 c0                	test   %eax,%eax
  801082:	75 ee                	jne    801072 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801084:	a1 08 40 80 00       	mov    0x804008,%eax
  801089:	8b 40 48             	mov    0x48(%eax),%eax
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	51                   	push   %ecx
  801090:	50                   	push   %eax
  801091:	68 b4 28 80 00       	push   $0x8028b4
  801096:	e8 b5 f0 ff ff       	call   800150 <cprintf>
	*dev = 0;
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    
			*dev = devtab[i];
  8010ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b8:	eb f2                	jmp    8010ac <dev_lookup+0x4d>

008010ba <fd_close>:
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 24             	sub    $0x24,%esp
  8010c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8010c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010cc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010cd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010d3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d6:	50                   	push   %eax
  8010d7:	e8 33 ff ff ff       	call   80100f <fd_lookup>
  8010dc:	89 c3                	mov    %eax,%ebx
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	78 05                	js     8010ea <fd_close+0x30>
	    || fd != fd2)
  8010e5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010e8:	74 16                	je     801100 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010ea:	89 f8                	mov    %edi,%eax
  8010ec:	84 c0                	test   %al,%al
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f3:	0f 44 d8             	cmove  %eax,%ebx
}
  8010f6:	89 d8                	mov    %ebx,%eax
  8010f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801106:	50                   	push   %eax
  801107:	ff 36                	pushl  (%esi)
  801109:	e8 51 ff ff ff       	call   80105f <dev_lookup>
  80110e:	89 c3                	mov    %eax,%ebx
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	78 1a                	js     801131 <fd_close+0x77>
		if (dev->dev_close)
  801117:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80111a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801122:	85 c0                	test   %eax,%eax
  801124:	74 0b                	je     801131 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801126:	83 ec 0c             	sub    $0xc,%esp
  801129:	56                   	push   %esi
  80112a:	ff d0                	call   *%eax
  80112c:	89 c3                	mov    %eax,%ebx
  80112e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801131:	83 ec 08             	sub    $0x8,%esp
  801134:	56                   	push   %esi
  801135:	6a 00                	push   $0x0
  801137:	e8 ea fb ff ff       	call   800d26 <sys_page_unmap>
	return r;
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	eb b5                	jmp    8010f6 <fd_close+0x3c>

00801141 <close>:

int
close(int fdnum)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801147:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80114a:	50                   	push   %eax
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 bc fe ff ff       	call   80100f <fd_lookup>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	79 02                	jns    80115c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    
		return fd_close(fd, 1);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	6a 01                	push   $0x1
  801161:	ff 75 f4             	pushl  -0xc(%ebp)
  801164:	e8 51 ff ff ff       	call   8010ba <fd_close>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	eb ec                	jmp    80115a <close+0x19>

0080116e <close_all>:

void
close_all(void)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	53                   	push   %ebx
  801172:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801175:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	53                   	push   %ebx
  80117e:	e8 be ff ff ff       	call   801141 <close>
	for (i = 0; i < MAXFD; i++)
  801183:	83 c3 01             	add    $0x1,%ebx
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	83 fb 20             	cmp    $0x20,%ebx
  80118c:	75 ec                	jne    80117a <close_all+0xc>
}
  80118e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	57                   	push   %edi
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
  801199:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80119c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80119f:	50                   	push   %eax
  8011a0:	ff 75 08             	pushl  0x8(%ebp)
  8011a3:	e8 67 fe ff ff       	call   80100f <fd_lookup>
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	0f 88 81 00 00 00    	js     801236 <dup+0xa3>
		return r;
	close(newfdnum);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	e8 81 ff ff ff       	call   801141 <close>

	newfd = INDEX2FD(newfdnum);
  8011c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011c3:	c1 e6 0c             	shl    $0xc,%esi
  8011c6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011cc:	83 c4 04             	add    $0x4,%esp
  8011cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d2:	e8 cf fd ff ff       	call   800fa6 <fd2data>
  8011d7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011d9:	89 34 24             	mov    %esi,(%esp)
  8011dc:	e8 c5 fd ff ff       	call   800fa6 <fd2data>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011e6:	89 d8                	mov    %ebx,%eax
  8011e8:	c1 e8 16             	shr    $0x16,%eax
  8011eb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f2:	a8 01                	test   $0x1,%al
  8011f4:	74 11                	je     801207 <dup+0x74>
  8011f6:	89 d8                	mov    %ebx,%eax
  8011f8:	c1 e8 0c             	shr    $0xc,%eax
  8011fb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801202:	f6 c2 01             	test   $0x1,%dl
  801205:	75 39                	jne    801240 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80120a:	89 d0                	mov    %edx,%eax
  80120c:	c1 e8 0c             	shr    $0xc,%eax
  80120f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	25 07 0e 00 00       	and    $0xe07,%eax
  80121e:	50                   	push   %eax
  80121f:	56                   	push   %esi
  801220:	6a 00                	push   $0x0
  801222:	52                   	push   %edx
  801223:	6a 00                	push   $0x0
  801225:	e8 ba fa ff ff       	call   800ce4 <sys_page_map>
  80122a:	89 c3                	mov    %eax,%ebx
  80122c:	83 c4 20             	add    $0x20,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	78 31                	js     801264 <dup+0xd1>
		goto err;

	return newfdnum;
  801233:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801236:	89 d8                	mov    %ebx,%eax
  801238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801240:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	25 07 0e 00 00       	and    $0xe07,%eax
  80124f:	50                   	push   %eax
  801250:	57                   	push   %edi
  801251:	6a 00                	push   $0x0
  801253:	53                   	push   %ebx
  801254:	6a 00                	push   $0x0
  801256:	e8 89 fa ff ff       	call   800ce4 <sys_page_map>
  80125b:	89 c3                	mov    %eax,%ebx
  80125d:	83 c4 20             	add    $0x20,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	79 a3                	jns    801207 <dup+0x74>
	sys_page_unmap(0, newfd);
  801264:	83 ec 08             	sub    $0x8,%esp
  801267:	56                   	push   %esi
  801268:	6a 00                	push   $0x0
  80126a:	e8 b7 fa ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80126f:	83 c4 08             	add    $0x8,%esp
  801272:	57                   	push   %edi
  801273:	6a 00                	push   $0x0
  801275:	e8 ac fa ff ff       	call   800d26 <sys_page_unmap>
	return r;
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	eb b7                	jmp    801236 <dup+0xa3>

0080127f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	53                   	push   %ebx
  801283:	83 ec 1c             	sub    $0x1c,%esp
  801286:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801289:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	53                   	push   %ebx
  80128e:	e8 7c fd ff ff       	call   80100f <fd_lookup>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	78 3f                	js     8012d9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a0:	50                   	push   %eax
  8012a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a4:	ff 30                	pushl  (%eax)
  8012a6:	e8 b4 fd ff ff       	call   80105f <dev_lookup>
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 27                	js     8012d9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b5:	8b 42 08             	mov    0x8(%edx),%eax
  8012b8:	83 e0 03             	and    $0x3,%eax
  8012bb:	83 f8 01             	cmp    $0x1,%eax
  8012be:	74 1e                	je     8012de <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8b 40 08             	mov    0x8(%eax),%eax
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	74 35                	je     8012ff <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ca:	83 ec 04             	sub    $0x4,%esp
  8012cd:	ff 75 10             	pushl  0x10(%ebp)
  8012d0:	ff 75 0c             	pushl  0xc(%ebp)
  8012d3:	52                   	push   %edx
  8012d4:	ff d0                	call   *%eax
  8012d6:	83 c4 10             	add    $0x10,%esp
}
  8012d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012de:	a1 08 40 80 00       	mov    0x804008,%eax
  8012e3:	8b 40 48             	mov    0x48(%eax),%eax
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	53                   	push   %ebx
  8012ea:	50                   	push   %eax
  8012eb:	68 f5 28 80 00       	push   $0x8028f5
  8012f0:	e8 5b ee ff ff       	call   800150 <cprintf>
		return -E_INVAL;
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fd:	eb da                	jmp    8012d9 <read+0x5a>
		return -E_NOT_SUPP;
  8012ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801304:	eb d3                	jmp    8012d9 <read+0x5a>

00801306 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	57                   	push   %edi
  80130a:	56                   	push   %esi
  80130b:	53                   	push   %ebx
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801312:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801315:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131a:	39 f3                	cmp    %esi,%ebx
  80131c:	73 23                	jae    801341 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80131e:	83 ec 04             	sub    $0x4,%esp
  801321:	89 f0                	mov    %esi,%eax
  801323:	29 d8                	sub    %ebx,%eax
  801325:	50                   	push   %eax
  801326:	89 d8                	mov    %ebx,%eax
  801328:	03 45 0c             	add    0xc(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	57                   	push   %edi
  80132d:	e8 4d ff ff ff       	call   80127f <read>
		if (m < 0)
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 06                	js     80133f <readn+0x39>
			return m;
		if (m == 0)
  801339:	74 06                	je     801341 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80133b:	01 c3                	add    %eax,%ebx
  80133d:	eb db                	jmp    80131a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801341:	89 d8                	mov    %ebx,%eax
  801343:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  80135a:	e8 b0 fc ff ff       	call   80100f <fd_lookup>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 3a                	js     8013a0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	ff 30                	pushl  (%eax)
  801372:	e8 e8 fc ff ff       	call   80105f <dev_lookup>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 22                	js     8013a0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801381:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801385:	74 1e                	je     8013a5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138a:	8b 52 0c             	mov    0xc(%edx),%edx
  80138d:	85 d2                	test   %edx,%edx
  80138f:	74 35                	je     8013c6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	ff 75 10             	pushl  0x10(%ebp)
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	50                   	push   %eax
  80139b:	ff d2                	call   *%edx
  80139d:	83 c4 10             	add    $0x10,%esp
}
  8013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a5:	a1 08 40 80 00       	mov    0x804008,%eax
  8013aa:	8b 40 48             	mov    0x48(%eax),%eax
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	53                   	push   %ebx
  8013b1:	50                   	push   %eax
  8013b2:	68 11 29 80 00       	push   $0x802911
  8013b7:	e8 94 ed ff ff       	call   800150 <cprintf>
		return -E_INVAL;
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c4:	eb da                	jmp    8013a0 <write+0x55>
		return -E_NOT_SUPP;
  8013c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013cb:	eb d3                	jmp    8013a0 <write+0x55>

008013cd <seek>:

int
seek(int fdnum, off_t offset)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	ff 75 08             	pushl  0x8(%ebp)
  8013da:	e8 30 fc ff ff       	call   80100f <fd_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 0e                	js     8013f4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ec:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 1c             	sub    $0x1c,%esp
  8013fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801400:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	53                   	push   %ebx
  801405:	e8 05 fc ff ff       	call   80100f <fd_lookup>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 37                	js     801448 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	ff 30                	pushl  (%eax)
  80141d:	e8 3d fc ff ff       	call   80105f <dev_lookup>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 1f                	js     801448 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801430:	74 1b                	je     80144d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801435:	8b 52 18             	mov    0x18(%edx),%edx
  801438:	85 d2                	test   %edx,%edx
  80143a:	74 32                	je     80146e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	50                   	push   %eax
  801443:	ff d2                	call   *%edx
  801445:	83 c4 10             	add    $0x10,%esp
}
  801448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80144d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801452:	8b 40 48             	mov    0x48(%eax),%eax
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	53                   	push   %ebx
  801459:	50                   	push   %eax
  80145a:	68 d4 28 80 00       	push   $0x8028d4
  80145f:	e8 ec ec ff ff       	call   800150 <cprintf>
		return -E_INVAL;
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146c:	eb da                	jmp    801448 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80146e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801473:	eb d3                	jmp    801448 <ftruncate+0x52>

00801475 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	53                   	push   %ebx
  801479:	83 ec 1c             	sub    $0x1c,%esp
  80147c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	e8 84 fb ff ff       	call   80100f <fd_lookup>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 4b                	js     8014dd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801498:	50                   	push   %eax
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	ff 30                	pushl  (%eax)
  80149e:	e8 bc fb ff ff       	call   80105f <dev_lookup>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 33                	js     8014dd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ad:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014b1:	74 2f                	je     8014e2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014b3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014b6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014bd:	00 00 00 
	stat->st_isdir = 0;
  8014c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014c7:	00 00 00 
	stat->st_dev = dev;
  8014ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014d0:	83 ec 08             	sub    $0x8,%esp
  8014d3:	53                   	push   %ebx
  8014d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d7:	ff 50 14             	call   *0x14(%eax)
  8014da:	83 c4 10             	add    $0x10,%esp
}
  8014dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
		return -E_NOT_SUPP;
  8014e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e7:	eb f4                	jmp    8014dd <fstat+0x68>

008014e9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	6a 00                	push   $0x0
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	e8 22 02 00 00       	call   80171d <open>
  8014fb:	89 c3                	mov    %eax,%ebx
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	78 1b                	js     80151f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	50                   	push   %eax
  80150b:	e8 65 ff ff ff       	call   801475 <fstat>
  801510:	89 c6                	mov    %eax,%esi
	close(fd);
  801512:	89 1c 24             	mov    %ebx,(%esp)
  801515:	e8 27 fc ff ff       	call   801141 <close>
	return r;
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	89 f3                	mov    %esi,%ebx
}
  80151f:	89 d8                	mov    %ebx,%eax
  801521:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801524:	5b                   	pop    %ebx
  801525:	5e                   	pop    %esi
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
  80152d:	89 c6                	mov    %eax,%esi
  80152f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801531:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801538:	74 27                	je     801561 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80153a:	6a 07                	push   $0x7
  80153c:	68 00 50 80 00       	push   $0x805000
  801541:	56                   	push   %esi
  801542:	ff 35 00 40 80 00    	pushl  0x804000
  801548:	e8 69 0c 00 00       	call   8021b6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80154d:	83 c4 0c             	add    $0xc,%esp
  801550:	6a 00                	push   $0x0
  801552:	53                   	push   %ebx
  801553:	6a 00                	push   $0x0
  801555:	e8 f3 0b 00 00       	call   80214d <ipc_recv>
}
  80155a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5e                   	pop    %esi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	6a 01                	push   $0x1
  801566:	e8 a3 0c 00 00       	call   80220e <ipc_find_env>
  80156b:	a3 00 40 80 00       	mov    %eax,0x804000
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	eb c5                	jmp    80153a <fsipc+0x12>

00801575 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	8b 40 0c             	mov    0xc(%eax),%eax
  801581:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80158e:	ba 00 00 00 00       	mov    $0x0,%edx
  801593:	b8 02 00 00 00       	mov    $0x2,%eax
  801598:	e8 8b ff ff ff       	call   801528 <fsipc>
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <devfile_flush>:
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ab:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ba:	e8 69 ff ff ff       	call   801528 <fsipc>
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <devfile_stat>:
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015db:	b8 05 00 00 00       	mov    $0x5,%eax
  8015e0:	e8 43 ff ff ff       	call   801528 <fsipc>
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 2c                	js     801615 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	68 00 50 80 00       	push   $0x805000
  8015f1:	53                   	push   %ebx
  8015f2:	e8 b8 f2 ff ff       	call   8008af <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015f7:	a1 80 50 80 00       	mov    0x805080,%eax
  8015fc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801602:	a1 84 50 80 00       	mov    0x805084,%eax
  801607:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <devfile_write>:
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	53                   	push   %ebx
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8b 40 0c             	mov    0xc(%eax),%eax
  80162a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80162f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801635:	53                   	push   %ebx
  801636:	ff 75 0c             	pushl  0xc(%ebp)
  801639:	68 08 50 80 00       	push   $0x805008
  80163e:	e8 5c f4 ff ff       	call   800a9f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	b8 04 00 00 00       	mov    $0x4,%eax
  80164d:	e8 d6 fe ff ff       	call   801528 <fsipc>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 0b                	js     801664 <devfile_write+0x4a>
	assert(r <= n);
  801659:	39 d8                	cmp    %ebx,%eax
  80165b:	77 0c                	ja     801669 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80165d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801662:	7f 1e                	jg     801682 <devfile_write+0x68>
}
  801664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801667:	c9                   	leave  
  801668:	c3                   	ret    
	assert(r <= n);
  801669:	68 44 29 80 00       	push   $0x802944
  80166e:	68 4b 29 80 00       	push   $0x80294b
  801673:	68 98 00 00 00       	push   $0x98
  801678:	68 60 29 80 00       	push   $0x802960
  80167d:	e8 6a 0a 00 00       	call   8020ec <_panic>
	assert(r <= PGSIZE);
  801682:	68 6b 29 80 00       	push   $0x80296b
  801687:	68 4b 29 80 00       	push   $0x80294b
  80168c:	68 99 00 00 00       	push   $0x99
  801691:	68 60 29 80 00       	push   $0x802960
  801696:	e8 51 0a 00 00       	call   8020ec <_panic>

0080169b <devfile_read>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ae:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016be:	e8 65 fe ff ff       	call   801528 <fsipc>
  8016c3:	89 c3                	mov    %eax,%ebx
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1f                	js     8016e8 <devfile_read+0x4d>
	assert(r <= n);
  8016c9:	39 f0                	cmp    %esi,%eax
  8016cb:	77 24                	ja     8016f1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016cd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d2:	7f 33                	jg     801707 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	50                   	push   %eax
  8016d8:	68 00 50 80 00       	push   $0x805000
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	e8 58 f3 ff ff       	call   800a3d <memmove>
	return r;
  8016e5:	83 c4 10             	add    $0x10,%esp
}
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    
	assert(r <= n);
  8016f1:	68 44 29 80 00       	push   $0x802944
  8016f6:	68 4b 29 80 00       	push   $0x80294b
  8016fb:	6a 7c                	push   $0x7c
  8016fd:	68 60 29 80 00       	push   $0x802960
  801702:	e8 e5 09 00 00       	call   8020ec <_panic>
	assert(r <= PGSIZE);
  801707:	68 6b 29 80 00       	push   $0x80296b
  80170c:	68 4b 29 80 00       	push   $0x80294b
  801711:	6a 7d                	push   $0x7d
  801713:	68 60 29 80 00       	push   $0x802960
  801718:	e8 cf 09 00 00       	call   8020ec <_panic>

0080171d <open>:
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	83 ec 1c             	sub    $0x1c,%esp
  801725:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801728:	56                   	push   %esi
  801729:	e8 48 f1 ff ff       	call   800876 <strlen>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801736:	7f 6c                	jg     8017a4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801738:	83 ec 0c             	sub    $0xc,%esp
  80173b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173e:	50                   	push   %eax
  80173f:	e8 79 f8 ff ff       	call   800fbd <fd_alloc>
  801744:	89 c3                	mov    %eax,%ebx
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	78 3c                	js     801789 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	56                   	push   %esi
  801751:	68 00 50 80 00       	push   $0x805000
  801756:	e8 54 f1 ff ff       	call   8008af <strcpy>
	fsipcbuf.open.req_omode = mode;
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801766:	b8 01 00 00 00       	mov    $0x1,%eax
  80176b:	e8 b8 fd ff ff       	call   801528 <fsipc>
  801770:	89 c3                	mov    %eax,%ebx
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 19                	js     801792 <open+0x75>
	return fd2num(fd);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	ff 75 f4             	pushl  -0xc(%ebp)
  80177f:	e8 12 f8 ff ff       	call   800f96 <fd2num>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
}
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    
		fd_close(fd, 0);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	6a 00                	push   $0x0
  801797:	ff 75 f4             	pushl  -0xc(%ebp)
  80179a:	e8 1b f9 ff ff       	call   8010ba <fd_close>
		return r;
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	eb e5                	jmp    801789 <open+0x6c>
		return -E_BAD_PATH;
  8017a4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a9:	eb de                	jmp    801789 <open+0x6c>

008017ab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017bb:	e8 68 fd ff ff       	call   801528 <fsipc>
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017c8:	68 77 29 80 00       	push   $0x802977
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	e8 da f0 ff ff       	call   8008af <strcpy>
	return 0;
}
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <devsock_close>:
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 10             	sub    $0x10,%esp
  8017e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017e6:	53                   	push   %ebx
  8017e7:	e8 61 0a 00 00       	call   80224d <pageref>
  8017ec:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017f4:	83 f8 01             	cmp    $0x1,%eax
  8017f7:	74 07                	je     801800 <devsock_close+0x24>
}
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	ff 73 0c             	pushl  0xc(%ebx)
  801806:	e8 b9 02 00 00       	call   801ac4 <nsipc_close>
  80180b:	89 c2                	mov    %eax,%edx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb e7                	jmp    8017f9 <devsock_close+0x1d>

00801812 <devsock_write>:
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	ff 70 0c             	pushl  0xc(%eax)
  801826:	e8 76 03 00 00       	call   801ba1 <nsipc_send>
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <devsock_read>:
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801833:	6a 00                	push   $0x0
  801835:	ff 75 10             	pushl  0x10(%ebp)
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	ff 70 0c             	pushl  0xc(%eax)
  801841:	e8 ef 02 00 00       	call   801b35 <nsipc_recv>
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <fd2sockid>:
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80184e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801851:	52                   	push   %edx
  801852:	50                   	push   %eax
  801853:	e8 b7 f7 ff ff       	call   80100f <fd_lookup>
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 10                	js     80186f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801868:	39 08                	cmp    %ecx,(%eax)
  80186a:	75 05                	jne    801871 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80186c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    
		return -E_NOT_SUPP;
  801871:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801876:	eb f7                	jmp    80186f <fd2sockid+0x27>

00801878 <alloc_sockfd>:
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
  80187d:	83 ec 1c             	sub    $0x1c,%esp
  801880:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801885:	50                   	push   %eax
  801886:	e8 32 f7 ff ff       	call   800fbd <fd_alloc>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	85 c0                	test   %eax,%eax
  801892:	78 43                	js     8018d7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 07 04 00 00       	push   $0x407
  80189c:	ff 75 f4             	pushl  -0xc(%ebp)
  80189f:	6a 00                	push   $0x0
  8018a1:	e8 fb f3 ff ff       	call   800ca1 <sys_page_alloc>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 28                	js     8018d7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018b8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018c4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	50                   	push   %eax
  8018cb:	e8 c6 f6 ff ff       	call   800f96 <fd2num>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	eb 0c                	jmp    8018e3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	56                   	push   %esi
  8018db:	e8 e4 01 00 00       	call   801ac4 <nsipc_close>
		return r;
  8018e0:	83 c4 10             	add    $0x10,%esp
}
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <accept>:
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	e8 4e ff ff ff       	call   801848 <fd2sockid>
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 1b                	js     801919 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	50                   	push   %eax
  801908:	e8 0e 01 00 00       	call   801a1b <nsipc_accept>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 05                	js     801919 <accept+0x2d>
	return alloc_sockfd(r);
  801914:	e8 5f ff ff ff       	call   801878 <alloc_sockfd>
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <bind>:
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	e8 1f ff ff ff       	call   801848 <fd2sockid>
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 12                	js     80193f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	e8 31 01 00 00       	call   801a6d <nsipc_bind>
  80193c:	83 c4 10             	add    $0x10,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <shutdown>:
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	e8 f9 fe ff ff       	call   801848 <fd2sockid>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 0f                	js     801962 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	50                   	push   %eax
  80195a:	e8 43 01 00 00       	call   801aa2 <nsipc_shutdown>
  80195f:	83 c4 10             	add    $0x10,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <connect>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	e8 d6 fe ff ff       	call   801848 <fd2sockid>
  801972:	85 c0                	test   %eax,%eax
  801974:	78 12                	js     801988 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	50                   	push   %eax
  801980:	e8 59 01 00 00       	call   801ade <nsipc_connect>
  801985:	83 c4 10             	add    $0x10,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <listen>:
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	e8 b0 fe ff ff       	call   801848 <fd2sockid>
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 0f                	js     8019ab <listen+0x21>
	return nsipc_listen(r, backlog);
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	e8 6b 01 00 00       	call   801b13 <nsipc_listen>
  8019a8:	83 c4 10             	add    $0x10,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <socket>:

int
socket(int domain, int type, int protocol)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019b3:	ff 75 10             	pushl  0x10(%ebp)
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	e8 3e 02 00 00       	call   801bff <nsipc_socket>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 05                	js     8019cd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019c8:	e8 ab fe ff ff       	call   801878 <alloc_sockfd>
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	53                   	push   %ebx
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019d8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019df:	74 26                	je     801a07 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019e1:	6a 07                	push   $0x7
  8019e3:	68 00 60 80 00       	push   $0x806000
  8019e8:	53                   	push   %ebx
  8019e9:	ff 35 04 40 80 00    	pushl  0x804004
  8019ef:	e8 c2 07 00 00       	call   8021b6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019f4:	83 c4 0c             	add    $0xc,%esp
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	e8 4b 07 00 00       	call   80214d <ipc_recv>
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	6a 02                	push   $0x2
  801a0c:	e8 fd 07 00 00       	call   80220e <ipc_find_env>
  801a11:	a3 04 40 80 00       	mov    %eax,0x804004
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	eb c6                	jmp    8019e1 <nsipc+0x12>

00801a1b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a2b:	8b 06                	mov    (%esi),%eax
  801a2d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a32:	b8 01 00 00 00       	mov    $0x1,%eax
  801a37:	e8 93 ff ff ff       	call   8019cf <nsipc>
  801a3c:	89 c3                	mov    %eax,%ebx
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	79 09                	jns    801a4b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a42:	89 d8                	mov    %ebx,%eax
  801a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	ff 35 10 60 80 00    	pushl  0x806010
  801a54:	68 00 60 80 00       	push   $0x806000
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	e8 dc ef ff ff       	call   800a3d <memmove>
		*addrlen = ret->ret_addrlen;
  801a61:	a1 10 60 80 00       	mov    0x806010,%eax
  801a66:	89 06                	mov    %eax,(%esi)
  801a68:	83 c4 10             	add    $0x10,%esp
	return r;
  801a6b:	eb d5                	jmp    801a42 <nsipc_accept+0x27>

00801a6d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	53                   	push   %ebx
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a7f:	53                   	push   %ebx
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	68 04 60 80 00       	push   $0x806004
  801a88:	e8 b0 ef ff ff       	call   800a3d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a8d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a93:	b8 02 00 00 00       	mov    $0x2,%eax
  801a98:	e8 32 ff ff ff       	call   8019cf <nsipc>
}
  801a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ab8:	b8 03 00 00 00       	mov    $0x3,%eax
  801abd:	e8 0d ff ff ff       	call   8019cf <nsipc>
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <nsipc_close>:

int
nsipc_close(int s)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ad2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad7:	e8 f3 fe ff ff       	call   8019cf <nsipc>
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801af0:	53                   	push   %ebx
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	68 04 60 80 00       	push   $0x806004
  801af9:	e8 3f ef ff ff       	call   800a3d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801afe:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b04:	b8 05 00 00 00       	mov    $0x5,%eax
  801b09:	e8 c1 fe ff ff       	call   8019cf <nsipc>
}
  801b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b29:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2e:	e8 9c fe ff ff       	call   8019cf <nsipc>
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b45:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b53:	b8 07 00 00 00       	mov    $0x7,%eax
  801b58:	e8 72 fe ff ff       	call   8019cf <nsipc>
  801b5d:	89 c3                	mov    %eax,%ebx
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1f                	js     801b82 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b63:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b68:	7f 21                	jg     801b8b <nsipc_recv+0x56>
  801b6a:	39 c6                	cmp    %eax,%esi
  801b6c:	7c 1d                	jl     801b8b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	50                   	push   %eax
  801b72:	68 00 60 80 00       	push   $0x806000
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	e8 be ee ff ff       	call   800a3d <memmove>
  801b7f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b82:	89 d8                	mov    %ebx,%eax
  801b84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b8b:	68 83 29 80 00       	push   $0x802983
  801b90:	68 4b 29 80 00       	push   $0x80294b
  801b95:	6a 62                	push   $0x62
  801b97:	68 98 29 80 00       	push   $0x802998
  801b9c:	e8 4b 05 00 00       	call   8020ec <_panic>

00801ba1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bb3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bb9:	7f 2e                	jg     801be9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	53                   	push   %ebx
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	68 0c 60 80 00       	push   $0x80600c
  801bc7:	e8 71 ee ff ff       	call   800a3d <memmove>
	nsipcbuf.send.req_size = size;
  801bcc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bda:	b8 08 00 00 00       	mov    $0x8,%eax
  801bdf:	e8 eb fd ff ff       	call   8019cf <nsipc>
}
  801be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    
	assert(size < 1600);
  801be9:	68 a4 29 80 00       	push   $0x8029a4
  801bee:	68 4b 29 80 00       	push   $0x80294b
  801bf3:	6a 6d                	push   $0x6d
  801bf5:	68 98 29 80 00       	push   $0x802998
  801bfa:	e8 ed 04 00 00       	call   8020ec <_panic>

00801bff <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c10:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c15:	8b 45 10             	mov    0x10(%ebp),%eax
  801c18:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c1d:	b8 09 00 00 00       	mov    $0x9,%eax
  801c22:	e8 a8 fd ff ff       	call   8019cf <nsipc>
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	56                   	push   %esi
  801c2d:	53                   	push   %ebx
  801c2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	e8 6a f3 ff ff       	call   800fa6 <fd2data>
  801c3c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c3e:	83 c4 08             	add    $0x8,%esp
  801c41:	68 b0 29 80 00       	push   $0x8029b0
  801c46:	53                   	push   %ebx
  801c47:	e8 63 ec ff ff       	call   8008af <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c4c:	8b 46 04             	mov    0x4(%esi),%eax
  801c4f:	2b 06                	sub    (%esi),%eax
  801c51:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c5e:	00 00 00 
	stat->st_dev = &devpipe;
  801c61:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c68:	30 80 00 
	return 0;
}
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    

00801c77 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 0c             	sub    $0xc,%esp
  801c7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c81:	53                   	push   %ebx
  801c82:	6a 00                	push   $0x0
  801c84:	e8 9d f0 ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c89:	89 1c 24             	mov    %ebx,(%esp)
  801c8c:	e8 15 f3 ff ff       	call   800fa6 <fd2data>
  801c91:	83 c4 08             	add    $0x8,%esp
  801c94:	50                   	push   %eax
  801c95:	6a 00                	push   $0x0
  801c97:	e8 8a f0 ff ff       	call   800d26 <sys_page_unmap>
}
  801c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <_pipeisclosed>:
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	57                   	push   %edi
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 1c             	sub    $0x1c,%esp
  801caa:	89 c7                	mov    %eax,%edi
  801cac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cae:	a1 08 40 80 00       	mov    0x804008,%eax
  801cb3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	57                   	push   %edi
  801cba:	e8 8e 05 00 00       	call   80224d <pageref>
  801cbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cc2:	89 34 24             	mov    %esi,(%esp)
  801cc5:	e8 83 05 00 00       	call   80224d <pageref>
		nn = thisenv->env_runs;
  801cca:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cd0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	39 cb                	cmp    %ecx,%ebx
  801cd8:	74 1b                	je     801cf5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cda:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cdd:	75 cf                	jne    801cae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cdf:	8b 42 58             	mov    0x58(%edx),%eax
  801ce2:	6a 01                	push   $0x1
  801ce4:	50                   	push   %eax
  801ce5:	53                   	push   %ebx
  801ce6:	68 b7 29 80 00       	push   $0x8029b7
  801ceb:	e8 60 e4 ff ff       	call   800150 <cprintf>
  801cf0:	83 c4 10             	add    $0x10,%esp
  801cf3:	eb b9                	jmp    801cae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cf5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf8:	0f 94 c0             	sete   %al
  801cfb:	0f b6 c0             	movzbl %al,%eax
}
  801cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5f                   	pop    %edi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <devpipe_write>:
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	57                   	push   %edi
  801d0a:	56                   	push   %esi
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 28             	sub    $0x28,%esp
  801d0f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d12:	56                   	push   %esi
  801d13:	e8 8e f2 ff ff       	call   800fa6 <fd2data>
  801d18:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d22:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d25:	74 4f                	je     801d76 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d27:	8b 43 04             	mov    0x4(%ebx),%eax
  801d2a:	8b 0b                	mov    (%ebx),%ecx
  801d2c:	8d 51 20             	lea    0x20(%ecx),%edx
  801d2f:	39 d0                	cmp    %edx,%eax
  801d31:	72 14                	jb     801d47 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d33:	89 da                	mov    %ebx,%edx
  801d35:	89 f0                	mov    %esi,%eax
  801d37:	e8 65 ff ff ff       	call   801ca1 <_pipeisclosed>
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	75 3b                	jne    801d7b <devpipe_write+0x75>
			sys_yield();
  801d40:	e8 3d ef ff ff       	call   800c82 <sys_yield>
  801d45:	eb e0                	jmp    801d27 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d4a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d4e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d51:	89 c2                	mov    %eax,%edx
  801d53:	c1 fa 1f             	sar    $0x1f,%edx
  801d56:	89 d1                	mov    %edx,%ecx
  801d58:	c1 e9 1b             	shr    $0x1b,%ecx
  801d5b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d5e:	83 e2 1f             	and    $0x1f,%edx
  801d61:	29 ca                	sub    %ecx,%edx
  801d63:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d67:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d6b:	83 c0 01             	add    $0x1,%eax
  801d6e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d71:	83 c7 01             	add    $0x1,%edi
  801d74:	eb ac                	jmp    801d22 <devpipe_write+0x1c>
	return i;
  801d76:	8b 45 10             	mov    0x10(%ebp),%eax
  801d79:	eb 05                	jmp    801d80 <devpipe_write+0x7a>
				return 0;
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    

00801d88 <devpipe_read>:
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	57                   	push   %edi
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 18             	sub    $0x18,%esp
  801d91:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d94:	57                   	push   %edi
  801d95:	e8 0c f2 ff ff       	call   800fa6 <fd2data>
  801d9a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	be 00 00 00 00       	mov    $0x0,%esi
  801da4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da7:	75 14                	jne    801dbd <devpipe_read+0x35>
	return i;
  801da9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dac:	eb 02                	jmp    801db0 <devpipe_read+0x28>
				return i;
  801dae:	89 f0                	mov    %esi,%eax
}
  801db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    
			sys_yield();
  801db8:	e8 c5 ee ff ff       	call   800c82 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dbd:	8b 03                	mov    (%ebx),%eax
  801dbf:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dc2:	75 18                	jne    801ddc <devpipe_read+0x54>
			if (i > 0)
  801dc4:	85 f6                	test   %esi,%esi
  801dc6:	75 e6                	jne    801dae <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dc8:	89 da                	mov    %ebx,%edx
  801dca:	89 f8                	mov    %edi,%eax
  801dcc:	e8 d0 fe ff ff       	call   801ca1 <_pipeisclosed>
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	74 e3                	je     801db8 <devpipe_read+0x30>
				return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb d4                	jmp    801db0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ddc:	99                   	cltd   
  801ddd:	c1 ea 1b             	shr    $0x1b,%edx
  801de0:	01 d0                	add    %edx,%eax
  801de2:	83 e0 1f             	and    $0x1f,%eax
  801de5:	29 d0                	sub    %edx,%eax
  801de7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801def:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801df2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801df5:	83 c6 01             	add    $0x1,%esi
  801df8:	eb aa                	jmp    801da4 <devpipe_read+0x1c>

00801dfa <pipe>:
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	56                   	push   %esi
  801dfe:	53                   	push   %ebx
  801dff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e05:	50                   	push   %eax
  801e06:	e8 b2 f1 ff ff       	call   800fbd <fd_alloc>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	85 c0                	test   %eax,%eax
  801e12:	0f 88 23 01 00 00    	js     801f3b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	68 07 04 00 00       	push   $0x407
  801e20:	ff 75 f4             	pushl  -0xc(%ebp)
  801e23:	6a 00                	push   $0x0
  801e25:	e8 77 ee ff ff       	call   800ca1 <sys_page_alloc>
  801e2a:	89 c3                	mov    %eax,%ebx
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	0f 88 04 01 00 00    	js     801f3b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e37:	83 ec 0c             	sub    $0xc,%esp
  801e3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e3d:	50                   	push   %eax
  801e3e:	e8 7a f1 ff ff       	call   800fbd <fd_alloc>
  801e43:	89 c3                	mov    %eax,%ebx
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	0f 88 db 00 00 00    	js     801f2b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	68 07 04 00 00       	push   $0x407
  801e58:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5b:	6a 00                	push   $0x0
  801e5d:	e8 3f ee ff ff       	call   800ca1 <sys_page_alloc>
  801e62:	89 c3                	mov    %eax,%ebx
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	85 c0                	test   %eax,%eax
  801e69:	0f 88 bc 00 00 00    	js     801f2b <pipe+0x131>
	va = fd2data(fd0);
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	ff 75 f4             	pushl  -0xc(%ebp)
  801e75:	e8 2c f1 ff ff       	call   800fa6 <fd2data>
  801e7a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7c:	83 c4 0c             	add    $0xc,%esp
  801e7f:	68 07 04 00 00       	push   $0x407
  801e84:	50                   	push   %eax
  801e85:	6a 00                	push   $0x0
  801e87:	e8 15 ee ff ff       	call   800ca1 <sys_page_alloc>
  801e8c:	89 c3                	mov    %eax,%ebx
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	85 c0                	test   %eax,%eax
  801e93:	0f 88 82 00 00 00    	js     801f1b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9f:	e8 02 f1 ff ff       	call   800fa6 <fd2data>
  801ea4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eab:	50                   	push   %eax
  801eac:	6a 00                	push   $0x0
  801eae:	56                   	push   %esi
  801eaf:	6a 00                	push   $0x0
  801eb1:	e8 2e ee ff ff       	call   800ce4 <sys_page_map>
  801eb6:	89 c3                	mov    %eax,%ebx
  801eb8:	83 c4 20             	add    $0x20,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	78 4e                	js     801f0d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ebf:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee8:	e8 a9 f0 ff ff       	call   800f96 <fd2num>
  801eed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ef2:	83 c4 04             	add    $0x4,%esp
  801ef5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef8:	e8 99 f0 ff ff       	call   800f96 <fd2num>
  801efd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f00:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0b:	eb 2e                	jmp    801f3b <pipe+0x141>
	sys_page_unmap(0, va);
  801f0d:	83 ec 08             	sub    $0x8,%esp
  801f10:	56                   	push   %esi
  801f11:	6a 00                	push   $0x0
  801f13:	e8 0e ee ff ff       	call   800d26 <sys_page_unmap>
  801f18:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f1b:	83 ec 08             	sub    $0x8,%esp
  801f1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f21:	6a 00                	push   $0x0
  801f23:	e8 fe ed ff ff       	call   800d26 <sys_page_unmap>
  801f28:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f2b:	83 ec 08             	sub    $0x8,%esp
  801f2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f31:	6a 00                	push   $0x0
  801f33:	e8 ee ed ff ff       	call   800d26 <sys_page_unmap>
  801f38:	83 c4 10             	add    $0x10,%esp
}
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <pipeisclosed>:
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4d:	50                   	push   %eax
  801f4e:	ff 75 08             	pushl  0x8(%ebp)
  801f51:	e8 b9 f0 ff ff       	call   80100f <fd_lookup>
  801f56:	83 c4 10             	add    $0x10,%esp
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 18                	js     801f75 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	ff 75 f4             	pushl  -0xc(%ebp)
  801f63:	e8 3e f0 ff ff       	call   800fa6 <fd2data>
	return _pipeisclosed(fd, p);
  801f68:	89 c2                	mov    %eax,%edx
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	e8 2f fd ff ff       	call   801ca1 <_pipeisclosed>
  801f72:	83 c4 10             	add    $0x10,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	c3                   	ret    

00801f7d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f83:	68 cf 29 80 00       	push   $0x8029cf
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	e8 1f e9 ff ff       	call   8008af <strcpy>
	return 0;
}
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devcons_write>:
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	57                   	push   %edi
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fa3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fa8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fae:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb1:	73 31                	jae    801fe4 <devcons_write+0x4d>
		m = n - tot;
  801fb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fb6:	29 f3                	sub    %esi,%ebx
  801fb8:	83 fb 7f             	cmp    $0x7f,%ebx
  801fbb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fc0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	53                   	push   %ebx
  801fc7:	89 f0                	mov    %esi,%eax
  801fc9:	03 45 0c             	add    0xc(%ebp),%eax
  801fcc:	50                   	push   %eax
  801fcd:	57                   	push   %edi
  801fce:	e8 6a ea ff ff       	call   800a3d <memmove>
		sys_cputs(buf, m);
  801fd3:	83 c4 08             	add    $0x8,%esp
  801fd6:	53                   	push   %ebx
  801fd7:	57                   	push   %edi
  801fd8:	e8 08 ec ff ff       	call   800be5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fdd:	01 de                	add    %ebx,%esi
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	eb ca                	jmp    801fae <devcons_write+0x17>
}
  801fe4:	89 f0                	mov    %esi,%eax
  801fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5f                   	pop    %edi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <devcons_read>:
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffd:	74 21                	je     802020 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801fff:	e8 ff eb ff ff       	call   800c03 <sys_cgetc>
  802004:	85 c0                	test   %eax,%eax
  802006:	75 07                	jne    80200f <devcons_read+0x21>
		sys_yield();
  802008:	e8 75 ec ff ff       	call   800c82 <sys_yield>
  80200d:	eb f0                	jmp    801fff <devcons_read+0x11>
	if (c < 0)
  80200f:	78 0f                	js     802020 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802011:	83 f8 04             	cmp    $0x4,%eax
  802014:	74 0c                	je     802022 <devcons_read+0x34>
	*(char*)vbuf = c;
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	88 02                	mov    %al,(%edx)
	return 1;
  80201b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    
		return 0;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	eb f7                	jmp    802020 <devcons_read+0x32>

00802029 <cputchar>:
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802035:	6a 01                	push   $0x1
  802037:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80203a:	50                   	push   %eax
  80203b:	e8 a5 eb ff ff       	call   800be5 <sys_cputs>
}
  802040:	83 c4 10             	add    $0x10,%esp
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <getchar>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80204b:	6a 01                	push   $0x1
  80204d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	6a 00                	push   $0x0
  802053:	e8 27 f2 ff ff       	call   80127f <read>
	if (r < 0)
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 06                	js     802065 <getchar+0x20>
	if (r < 1)
  80205f:	74 06                	je     802067 <getchar+0x22>
	return c;
  802061:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    
		return -E_EOF;
  802067:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80206c:	eb f7                	jmp    802065 <getchar+0x20>

0080206e <iscons>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	e8 8f ef ff ff       	call   80100f <fd_lookup>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	85 c0                	test   %eax,%eax
  802085:	78 11                	js     802098 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802090:	39 10                	cmp    %edx,(%eax)
  802092:	0f 94 c0             	sete   %al
  802095:	0f b6 c0             	movzbl %al,%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <opencons>:
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	e8 14 ef ff ff       	call   800fbd <fd_alloc>
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 3a                	js     8020ea <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	68 07 04 00 00       	push   $0x407
  8020b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020bb:	6a 00                	push   $0x0
  8020bd:	e8 df eb ff ff       	call   800ca1 <sys_page_alloc>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 21                	js     8020ea <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	50                   	push   %eax
  8020e2:	e8 af ee ff ff       	call   800f96 <fd2num>
  8020e7:	83 c4 10             	add    $0x10,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020f1:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f6:	8b 40 48             	mov    0x48(%eax),%eax
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	68 00 2a 80 00       	push   $0x802a00
  802101:	50                   	push   %eax
  802102:	68 ea 24 80 00       	push   $0x8024ea
  802107:	e8 44 e0 ff ff       	call   800150 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80210c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80210f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802115:	e8 49 eb ff ff       	call   800c63 <sys_getenvid>
  80211a:	83 c4 04             	add    $0x4,%esp
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	56                   	push   %esi
  802124:	50                   	push   %eax
  802125:	68 dc 29 80 00       	push   $0x8029dc
  80212a:	e8 21 e0 ff ff       	call   800150 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80212f:	83 c4 18             	add    $0x18,%esp
  802132:	53                   	push   %ebx
  802133:	ff 75 10             	pushl  0x10(%ebp)
  802136:	e8 c4 df ff ff       	call   8000ff <vcprintf>
	cprintf("\n");
  80213b:	c7 04 24 1a 2a 80 00 	movl   $0x802a1a,(%esp)
  802142:	e8 09 e0 ff ff       	call   800150 <cprintf>
  802147:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80214a:	cc                   	int3   
  80214b:	eb fd                	jmp    80214a <_panic+0x5e>

0080214d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	8b 75 08             	mov    0x8(%ebp),%esi
  802155:	8b 45 0c             	mov    0xc(%ebp),%eax
  802158:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80215b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80215d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802162:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	50                   	push   %eax
  802169:	e8 e3 ec ff ff       	call   800e51 <sys_ipc_recv>
	if(ret < 0){
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 2b                	js     8021a0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802175:	85 f6                	test   %esi,%esi
  802177:	74 0a                	je     802183 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802179:	a1 08 40 80 00       	mov    0x804008,%eax
  80217e:	8b 40 78             	mov    0x78(%eax),%eax
  802181:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802183:	85 db                	test   %ebx,%ebx
  802185:	74 0a                	je     802191 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802187:	a1 08 40 80 00       	mov    0x804008,%eax
  80218c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80218f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802191:	a1 08 40 80 00       	mov    0x804008,%eax
  802196:	8b 40 74             	mov    0x74(%eax),%eax
}
  802199:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219c:	5b                   	pop    %ebx
  80219d:	5e                   	pop    %esi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
		if(from_env_store)
  8021a0:	85 f6                	test   %esi,%esi
  8021a2:	74 06                	je     8021aa <ipc_recv+0x5d>
			*from_env_store = 0;
  8021a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021aa:	85 db                	test   %ebx,%ebx
  8021ac:	74 eb                	je     802199 <ipc_recv+0x4c>
			*perm_store = 0;
  8021ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021b4:	eb e3                	jmp    802199 <ipc_recv+0x4c>

008021b6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	57                   	push   %edi
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
  8021bc:	83 ec 0c             	sub    $0xc,%esp
  8021bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021c2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021c8:	85 db                	test   %ebx,%ebx
  8021ca:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021cf:	0f 44 d8             	cmove  %eax,%ebx
  8021d2:	eb 05                	jmp    8021d9 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021d4:	e8 a9 ea ff ff       	call   800c82 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021d9:	ff 75 14             	pushl  0x14(%ebp)
  8021dc:	53                   	push   %ebx
  8021dd:	56                   	push   %esi
  8021de:	57                   	push   %edi
  8021df:	e8 4a ec ff ff       	call   800e2e <sys_ipc_try_send>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	74 1b                	je     802206 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021eb:	79 e7                	jns    8021d4 <ipc_send+0x1e>
  8021ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f0:	74 e2                	je     8021d4 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 07 2a 80 00       	push   $0x802a07
  8021fa:	6a 46                	push   $0x46
  8021fc:	68 1c 2a 80 00       	push   $0x802a1c
  802201:	e8 e6 fe ff ff       	call   8020ec <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802209:	5b                   	pop    %ebx
  80220a:	5e                   	pop    %esi
  80220b:	5f                   	pop    %edi
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    

0080220e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802219:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80221f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802225:	8b 52 50             	mov    0x50(%edx),%edx
  802228:	39 ca                	cmp    %ecx,%edx
  80222a:	74 11                	je     80223d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80222c:	83 c0 01             	add    $0x1,%eax
  80222f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802234:	75 e3                	jne    802219 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	eb 0e                	jmp    80224b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80223d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802243:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802248:	8b 40 48             	mov    0x48(%eax),%eax
}
  80224b:	5d                   	pop    %ebp
  80224c:	c3                   	ret    

0080224d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802253:	89 d0                	mov    %edx,%eax
  802255:	c1 e8 16             	shr    $0x16,%eax
  802258:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802264:	f6 c1 01             	test   $0x1,%cl
  802267:	74 1d                	je     802286 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802269:	c1 ea 0c             	shr    $0xc,%edx
  80226c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802273:	f6 c2 01             	test   $0x1,%dl
  802276:	74 0e                	je     802286 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802278:	c1 ea 0c             	shr    $0xc,%edx
  80227b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802282:	ef 
  802283:	0f b7 c0             	movzwl %ax,%eax
}
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    
  802288:	66 90                	xchg   %ax,%ax
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <__udivdi3>:
  802290:	55                   	push   %ebp
  802291:	57                   	push   %edi
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 1c             	sub    $0x1c,%esp
  802297:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80229b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80229f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022a7:	85 d2                	test   %edx,%edx
  8022a9:	75 4d                	jne    8022f8 <__udivdi3+0x68>
  8022ab:	39 f3                	cmp    %esi,%ebx
  8022ad:	76 19                	jbe    8022c8 <__udivdi3+0x38>
  8022af:	31 ff                	xor    %edi,%edi
  8022b1:	89 e8                	mov    %ebp,%eax
  8022b3:	89 f2                	mov    %esi,%edx
  8022b5:	f7 f3                	div    %ebx
  8022b7:	89 fa                	mov    %edi,%edx
  8022b9:	83 c4 1c             	add    $0x1c,%esp
  8022bc:	5b                   	pop    %ebx
  8022bd:	5e                   	pop    %esi
  8022be:	5f                   	pop    %edi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    
  8022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	89 d9                	mov    %ebx,%ecx
  8022ca:	85 db                	test   %ebx,%ebx
  8022cc:	75 0b                	jne    8022d9 <__udivdi3+0x49>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f3                	div    %ebx
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	31 d2                	xor    %edx,%edx
  8022db:	89 f0                	mov    %esi,%eax
  8022dd:	f7 f1                	div    %ecx
  8022df:	89 c6                	mov    %eax,%esi
  8022e1:	89 e8                	mov    %ebp,%eax
  8022e3:	89 f7                	mov    %esi,%edi
  8022e5:	f7 f1                	div    %ecx
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	77 1c                	ja     802318 <__udivdi3+0x88>
  8022fc:	0f bd fa             	bsr    %edx,%edi
  8022ff:	83 f7 1f             	xor    $0x1f,%edi
  802302:	75 2c                	jne    802330 <__udivdi3+0xa0>
  802304:	39 f2                	cmp    %esi,%edx
  802306:	72 06                	jb     80230e <__udivdi3+0x7e>
  802308:	31 c0                	xor    %eax,%eax
  80230a:	39 eb                	cmp    %ebp,%ebx
  80230c:	77 a9                	ja     8022b7 <__udivdi3+0x27>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	eb a2                	jmp    8022b7 <__udivdi3+0x27>
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	31 ff                	xor    %edi,%edi
  80231a:	31 c0                	xor    %eax,%eax
  80231c:	89 fa                	mov    %edi,%edx
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	89 f9                	mov    %edi,%ecx
  802332:	b8 20 00 00 00       	mov    $0x20,%eax
  802337:	29 f8                	sub    %edi,%eax
  802339:	d3 e2                	shl    %cl,%edx
  80233b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80233f:	89 c1                	mov    %eax,%ecx
  802341:	89 da                	mov    %ebx,%edx
  802343:	d3 ea                	shr    %cl,%edx
  802345:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802349:	09 d1                	or     %edx,%ecx
  80234b:	89 f2                	mov    %esi,%edx
  80234d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802351:	89 f9                	mov    %edi,%ecx
  802353:	d3 e3                	shl    %cl,%ebx
  802355:	89 c1                	mov    %eax,%ecx
  802357:	d3 ea                	shr    %cl,%edx
  802359:	89 f9                	mov    %edi,%ecx
  80235b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80235f:	89 eb                	mov    %ebp,%ebx
  802361:	d3 e6                	shl    %cl,%esi
  802363:	89 c1                	mov    %eax,%ecx
  802365:	d3 eb                	shr    %cl,%ebx
  802367:	09 de                	or     %ebx,%esi
  802369:	89 f0                	mov    %esi,%eax
  80236b:	f7 74 24 08          	divl   0x8(%esp)
  80236f:	89 d6                	mov    %edx,%esi
  802371:	89 c3                	mov    %eax,%ebx
  802373:	f7 64 24 0c          	mull   0xc(%esp)
  802377:	39 d6                	cmp    %edx,%esi
  802379:	72 15                	jb     802390 <__udivdi3+0x100>
  80237b:	89 f9                	mov    %edi,%ecx
  80237d:	d3 e5                	shl    %cl,%ebp
  80237f:	39 c5                	cmp    %eax,%ebp
  802381:	73 04                	jae    802387 <__udivdi3+0xf7>
  802383:	39 d6                	cmp    %edx,%esi
  802385:	74 09                	je     802390 <__udivdi3+0x100>
  802387:	89 d8                	mov    %ebx,%eax
  802389:	31 ff                	xor    %edi,%edi
  80238b:	e9 27 ff ff ff       	jmp    8022b7 <__udivdi3+0x27>
  802390:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802393:	31 ff                	xor    %edi,%edi
  802395:	e9 1d ff ff ff       	jmp    8022b7 <__udivdi3+0x27>
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	66 90                	xchg   %ax,%ax
  80239e:	66 90                	xchg   %ax,%ax

008023a0 <__umoddi3>:
  8023a0:	55                   	push   %ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 1c             	sub    $0x1c,%esp
  8023a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023b7:	89 da                	mov    %ebx,%edx
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	75 43                	jne    802400 <__umoddi3+0x60>
  8023bd:	39 df                	cmp    %ebx,%edi
  8023bf:	76 17                	jbe    8023d8 <__umoddi3+0x38>
  8023c1:	89 f0                	mov    %esi,%eax
  8023c3:	f7 f7                	div    %edi
  8023c5:	89 d0                	mov    %edx,%eax
  8023c7:	31 d2                	xor    %edx,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 fd                	mov    %edi,%ebp
  8023da:	85 ff                	test   %edi,%edi
  8023dc:	75 0b                	jne    8023e9 <__umoddi3+0x49>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f7                	div    %edi
  8023e7:	89 c5                	mov    %eax,%ebp
  8023e9:	89 d8                	mov    %ebx,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	f7 f5                	div    %ebp
  8023ef:	89 f0                	mov    %esi,%eax
  8023f1:	f7 f5                	div    %ebp
  8023f3:	89 d0                	mov    %edx,%eax
  8023f5:	eb d0                	jmp    8023c7 <__umoddi3+0x27>
  8023f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	89 f1                	mov    %esi,%ecx
  802402:	39 d8                	cmp    %ebx,%eax
  802404:	76 0a                	jbe    802410 <__umoddi3+0x70>
  802406:	89 f0                	mov    %esi,%eax
  802408:	83 c4 1c             	add    $0x1c,%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5f                   	pop    %edi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    
  802410:	0f bd e8             	bsr    %eax,%ebp
  802413:	83 f5 1f             	xor    $0x1f,%ebp
  802416:	75 20                	jne    802438 <__umoddi3+0x98>
  802418:	39 d8                	cmp    %ebx,%eax
  80241a:	0f 82 b0 00 00 00    	jb     8024d0 <__umoddi3+0x130>
  802420:	39 f7                	cmp    %esi,%edi
  802422:	0f 86 a8 00 00 00    	jbe    8024d0 <__umoddi3+0x130>
  802428:	89 c8                	mov    %ecx,%eax
  80242a:	83 c4 1c             	add    $0x1c,%esp
  80242d:	5b                   	pop    %ebx
  80242e:	5e                   	pop    %esi
  80242f:	5f                   	pop    %edi
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    
  802432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802438:	89 e9                	mov    %ebp,%ecx
  80243a:	ba 20 00 00 00       	mov    $0x20,%edx
  80243f:	29 ea                	sub    %ebp,%edx
  802441:	d3 e0                	shl    %cl,%eax
  802443:	89 44 24 08          	mov    %eax,0x8(%esp)
  802447:	89 d1                	mov    %edx,%ecx
  802449:	89 f8                	mov    %edi,%eax
  80244b:	d3 e8                	shr    %cl,%eax
  80244d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802451:	89 54 24 04          	mov    %edx,0x4(%esp)
  802455:	8b 54 24 04          	mov    0x4(%esp),%edx
  802459:	09 c1                	or     %eax,%ecx
  80245b:	89 d8                	mov    %ebx,%eax
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 e9                	mov    %ebp,%ecx
  802463:	d3 e7                	shl    %cl,%edi
  802465:	89 d1                	mov    %edx,%ecx
  802467:	d3 e8                	shr    %cl,%eax
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80246f:	d3 e3                	shl    %cl,%ebx
  802471:	89 c7                	mov    %eax,%edi
  802473:	89 d1                	mov    %edx,%ecx
  802475:	89 f0                	mov    %esi,%eax
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 fa                	mov    %edi,%edx
  80247d:	d3 e6                	shl    %cl,%esi
  80247f:	09 d8                	or     %ebx,%eax
  802481:	f7 74 24 08          	divl   0x8(%esp)
  802485:	89 d1                	mov    %edx,%ecx
  802487:	89 f3                	mov    %esi,%ebx
  802489:	f7 64 24 0c          	mull   0xc(%esp)
  80248d:	89 c6                	mov    %eax,%esi
  80248f:	89 d7                	mov    %edx,%edi
  802491:	39 d1                	cmp    %edx,%ecx
  802493:	72 06                	jb     80249b <__umoddi3+0xfb>
  802495:	75 10                	jne    8024a7 <__umoddi3+0x107>
  802497:	39 c3                	cmp    %eax,%ebx
  802499:	73 0c                	jae    8024a7 <__umoddi3+0x107>
  80249b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80249f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024a3:	89 d7                	mov    %edx,%edi
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	89 ca                	mov    %ecx,%edx
  8024a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ae:	29 f3                	sub    %esi,%ebx
  8024b0:	19 fa                	sbb    %edi,%edx
  8024b2:	89 d0                	mov    %edx,%eax
  8024b4:	d3 e0                	shl    %cl,%eax
  8024b6:	89 e9                	mov    %ebp,%ecx
  8024b8:	d3 eb                	shr    %cl,%ebx
  8024ba:	d3 ea                	shr    %cl,%edx
  8024bc:	09 d8                	or     %ebx,%eax
  8024be:	83 c4 1c             	add    $0x1c,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5f                   	pop    %edi
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    
  8024c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024cd:	8d 76 00             	lea    0x0(%esi),%esi
  8024d0:	89 da                	mov    %ebx,%edx
  8024d2:	29 fe                	sub    %edi,%esi
  8024d4:	19 c2                	sbb    %eax,%edx
  8024d6:	89 f1                	mov    %esi,%ecx
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	e9 4b ff ff ff       	jmp    80242a <__umoddi3+0x8a>
