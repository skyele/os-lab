
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800041:	e8 15 0c 00 00       	call   800c5b <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x30>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800085:	a1 08 40 80 00       	mov    0x804008,%eax
  80008a:	8b 40 48             	mov    0x48(%eax),%eax
  80008d:	68 f8 24 80 00       	push   $0x8024f8
  800092:	50                   	push   %eax
  800093:	68 ea 24 80 00       	push   $0x8024ea
  800098:	e8 ab 00 00 00       	call   800148 <cprintf>
	close_all();
  80009d:	e8 c4 10 00 00       	call   801166 <close_all>
	sys_env_destroy(0);
  8000a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a9:	e8 6c 0b 00 00       	call   800c1a <sys_env_destroy>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	c9                   	leave  
  8000b2:	c3                   	ret    

008000b3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b3:	55                   	push   %ebp
  8000b4:	89 e5                	mov    %esp,%ebp
  8000b6:	53                   	push   %ebx
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bd:	8b 13                	mov    (%ebx),%edx
  8000bf:	8d 42 01             	lea    0x1(%edx),%eax
  8000c2:	89 03                	mov    %eax,(%ebx)
  8000c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d0:	74 09                	je     8000db <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000db:	83 ec 08             	sub    $0x8,%esp
  8000de:	68 ff 00 00 00       	push   $0xff
  8000e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e6:	50                   	push   %eax
  8000e7:	e8 f1 0a 00 00       	call   800bdd <sys_cputs>
		b->idx = 0;
  8000ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	eb db                	jmp    8000d2 <putch+0x1f>

008000f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800100:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800107:	00 00 00 
	b.cnt = 0;
  80010a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800111:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800114:	ff 75 0c             	pushl  0xc(%ebp)
  800117:	ff 75 08             	pushl  0x8(%ebp)
  80011a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800120:	50                   	push   %eax
  800121:	68 b3 00 80 00       	push   $0x8000b3
  800126:	e8 4a 01 00 00       	call   800275 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012b:	83 c4 08             	add    $0x8,%esp
  80012e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800134:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 9d 0a 00 00       	call   800bdd <sys_cputs>

	return b.cnt;
}
  800140:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80014e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800151:	50                   	push   %eax
  800152:	ff 75 08             	pushl  0x8(%ebp)
  800155:	e8 9d ff ff ff       	call   8000f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	83 ec 1c             	sub    $0x1c,%esp
  800165:	89 c6                	mov    %eax,%esi
  800167:	89 d7                	mov    %edx,%edi
  800169:	8b 45 08             	mov    0x8(%ebp),%eax
  80016c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800172:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800175:	8b 45 10             	mov    0x10(%ebp),%eax
  800178:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80017b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80017f:	74 2c                	je     8001ad <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800181:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800184:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80018b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80018e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800191:	39 c2                	cmp    %eax,%edx
  800193:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800196:	73 43                	jae    8001db <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800198:	83 eb 01             	sub    $0x1,%ebx
  80019b:	85 db                	test   %ebx,%ebx
  80019d:	7e 6c                	jle    80020b <printnum+0xaf>
				putch(padc, putdat);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	57                   	push   %edi
  8001a3:	ff 75 18             	pushl  0x18(%ebp)
  8001a6:	ff d6                	call   *%esi
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	eb eb                	jmp    800198 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	6a 20                	push   $0x20
  8001b2:	6a 00                	push   $0x0
  8001b4:	50                   	push   %eax
  8001b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001bb:	89 fa                	mov    %edi,%edx
  8001bd:	89 f0                	mov    %esi,%eax
  8001bf:	e8 98 ff ff ff       	call   80015c <printnum>
		while (--width > 0)
  8001c4:	83 c4 20             	add    $0x20,%esp
  8001c7:	83 eb 01             	sub    $0x1,%ebx
  8001ca:	85 db                	test   %ebx,%ebx
  8001cc:	7e 65                	jle    800233 <printnum+0xd7>
			putch(padc, putdat);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	57                   	push   %edi
  8001d2:	6a 20                	push   $0x20
  8001d4:	ff d6                	call   *%esi
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	eb ec                	jmp    8001c7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	ff 75 18             	pushl  0x18(%ebp)
  8001e1:	83 eb 01             	sub    $0x1,%ebx
  8001e4:	53                   	push   %ebx
  8001e5:	50                   	push   %eax
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f5:	e8 86 20 00 00       	call   802280 <__udivdi3>
  8001fa:	83 c4 18             	add    $0x18,%esp
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	89 fa                	mov    %edi,%edx
  800201:	89 f0                	mov    %esi,%eax
  800203:	e8 54 ff ff ff       	call   80015c <printnum>
  800208:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	57                   	push   %edi
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	e8 6d 21 00 00       	call   802390 <__umoddi3>
  800223:	83 c4 14             	add    $0x14,%esp
  800226:	0f be 80 fd 24 80 00 	movsbl 0x8024fd(%eax),%eax
  80022d:	50                   	push   %eax
  80022e:	ff d6                	call   *%esi
  800230:	83 c4 10             	add    $0x10,%esp
	}
}
  800233:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800236:	5b                   	pop    %ebx
  800237:	5e                   	pop    %esi
  800238:	5f                   	pop    %edi
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    

0080023b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800241:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800245:	8b 10                	mov    (%eax),%edx
  800247:	3b 50 04             	cmp    0x4(%eax),%edx
  80024a:	73 0a                	jae    800256 <sprintputch+0x1b>
		*b->buf++ = ch;
  80024c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024f:	89 08                	mov    %ecx,(%eax)
  800251:	8b 45 08             	mov    0x8(%ebp),%eax
  800254:	88 02                	mov    %al,(%edx)
}
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    

00800258 <printfmt>:
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800261:	50                   	push   %eax
  800262:	ff 75 10             	pushl  0x10(%ebp)
  800265:	ff 75 0c             	pushl  0xc(%ebp)
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	e8 05 00 00 00       	call   800275 <vprintfmt>
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <vprintfmt>:
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	57                   	push   %edi
  800279:	56                   	push   %esi
  80027a:	53                   	push   %ebx
  80027b:	83 ec 3c             	sub    $0x3c,%esp
  80027e:	8b 75 08             	mov    0x8(%ebp),%esi
  800281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800284:	8b 7d 10             	mov    0x10(%ebp),%edi
  800287:	e9 32 04 00 00       	jmp    8006be <vprintfmt+0x449>
		padc = ' ';
  80028c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800290:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800297:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80029e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ac:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b8:	8d 47 01             	lea    0x1(%edi),%eax
  8002bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002be:	0f b6 17             	movzbl (%edi),%edx
  8002c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c4:	3c 55                	cmp    $0x55,%al
  8002c6:	0f 87 12 05 00 00    	ja     8007de <vprintfmt+0x569>
  8002cc:	0f b6 c0             	movzbl %al,%eax
  8002cf:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  8002d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002dd:	eb d9                	jmp    8002b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002e2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002e6:	eb d0                	jmp    8002b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	0f b6 d2             	movzbl %dl,%edx
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8002f6:	eb 03                	jmp    8002fb <vprintfmt+0x86>
  8002f8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800302:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800305:	8d 72 d0             	lea    -0x30(%edx),%esi
  800308:	83 fe 09             	cmp    $0x9,%esi
  80030b:	76 eb                	jbe    8002f8 <vprintfmt+0x83>
  80030d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800310:	8b 75 08             	mov    0x8(%ebp),%esi
  800313:	eb 14                	jmp    800329 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800315:	8b 45 14             	mov    0x14(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8d 40 04             	lea    0x4(%eax),%eax
  800323:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800329:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032d:	79 89                	jns    8002b8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80032f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80033c:	e9 77 ff ff ff       	jmp    8002b8 <vprintfmt+0x43>
  800341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800344:	85 c0                	test   %eax,%eax
  800346:	0f 48 c1             	cmovs  %ecx,%eax
  800349:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80034f:	e9 64 ff ff ff       	jmp    8002b8 <vprintfmt+0x43>
  800354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800357:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80035e:	e9 55 ff ff ff       	jmp    8002b8 <vprintfmt+0x43>
			lflag++;
  800363:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80036a:	e9 49 ff ff ff       	jmp    8002b8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80036f:	8b 45 14             	mov    0x14(%ebp),%eax
  800372:	8d 78 04             	lea    0x4(%eax),%edi
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	53                   	push   %ebx
  800379:	ff 30                	pushl  (%eax)
  80037b:	ff d6                	call   *%esi
			break;
  80037d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800380:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800383:	e9 33 03 00 00       	jmp    8006bb <vprintfmt+0x446>
			err = va_arg(ap, int);
  800388:	8b 45 14             	mov    0x14(%ebp),%eax
  80038b:	8d 78 04             	lea    0x4(%eax),%edi
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	99                   	cltd   
  800391:	31 d0                	xor    %edx,%eax
  800393:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800395:	83 f8 11             	cmp    $0x11,%eax
  800398:	7f 23                	jg     8003bd <vprintfmt+0x148>
  80039a:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  8003a1:	85 d2                	test   %edx,%edx
  8003a3:	74 18                	je     8003bd <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003a5:	52                   	push   %edx
  8003a6:	68 5d 29 80 00       	push   $0x80295d
  8003ab:	53                   	push   %ebx
  8003ac:	56                   	push   %esi
  8003ad:	e8 a6 fe ff ff       	call   800258 <printfmt>
  8003b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b8:	e9 fe 02 00 00       	jmp    8006bb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003bd:	50                   	push   %eax
  8003be:	68 15 25 80 00       	push   $0x802515
  8003c3:	53                   	push   %ebx
  8003c4:	56                   	push   %esi
  8003c5:	e8 8e fe ff ff       	call   800258 <printfmt>
  8003ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d0:	e9 e6 02 00 00       	jmp    8006bb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d8:	83 c0 04             	add    $0x4,%eax
  8003db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003e3:	85 c9                	test   %ecx,%ecx
  8003e5:	b8 0e 25 80 00       	mov    $0x80250e,%eax
  8003ea:	0f 45 c1             	cmovne %ecx,%eax
  8003ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8003f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f4:	7e 06                	jle    8003fc <vprintfmt+0x187>
  8003f6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8003fa:	75 0d                	jne    800409 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003ff:	89 c7                	mov    %eax,%edi
  800401:	03 45 e0             	add    -0x20(%ebp),%eax
  800404:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800407:	eb 53                	jmp    80045c <vprintfmt+0x1e7>
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 d8             	pushl  -0x28(%ebp)
  80040f:	50                   	push   %eax
  800410:	e8 71 04 00 00       	call   800886 <strnlen>
  800415:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800418:	29 c1                	sub    %eax,%ecx
  80041a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800422:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	eb 0f                	jmp    80043a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80042b:	83 ec 08             	sub    $0x8,%esp
  80042e:	53                   	push   %ebx
  80042f:	ff 75 e0             	pushl  -0x20(%ebp)
  800432:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800434:	83 ef 01             	sub    $0x1,%edi
  800437:	83 c4 10             	add    $0x10,%esp
  80043a:	85 ff                	test   %edi,%edi
  80043c:	7f ed                	jg     80042b <vprintfmt+0x1b6>
  80043e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800441:	85 c9                	test   %ecx,%ecx
  800443:	b8 00 00 00 00       	mov    $0x0,%eax
  800448:	0f 49 c1             	cmovns %ecx,%eax
  80044b:	29 c1                	sub    %eax,%ecx
  80044d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800450:	eb aa                	jmp    8003fc <vprintfmt+0x187>
					putch(ch, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	52                   	push   %edx
  800457:	ff d6                	call   *%esi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800461:	83 c7 01             	add    $0x1,%edi
  800464:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800468:	0f be d0             	movsbl %al,%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 4b                	je     8004ba <vprintfmt+0x245>
  80046f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800473:	78 06                	js     80047b <vprintfmt+0x206>
  800475:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800479:	78 1e                	js     800499 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80047b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80047f:	74 d1                	je     800452 <vprintfmt+0x1dd>
  800481:	0f be c0             	movsbl %al,%eax
  800484:	83 e8 20             	sub    $0x20,%eax
  800487:	83 f8 5e             	cmp    $0x5e,%eax
  80048a:	76 c6                	jbe    800452 <vprintfmt+0x1dd>
					putch('?', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	6a 3f                	push   $0x3f
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb c3                	jmp    80045c <vprintfmt+0x1e7>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb 0e                	jmp    8004ab <vprintfmt+0x236>
				putch(' ', putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	6a 20                	push   $0x20
  8004a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a5:	83 ef 01             	sub    $0x1,%edi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	7f ee                	jg     80049d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b5:	e9 01 02 00 00       	jmp    8006bb <vprintfmt+0x446>
  8004ba:	89 cf                	mov    %ecx,%edi
  8004bc:	eb ed                	jmp    8004ab <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004c1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004c8:	e9 eb fd ff ff       	jmp    8002b8 <vprintfmt+0x43>
	if (lflag >= 2)
  8004cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004d1:	7f 21                	jg     8004f4 <vprintfmt+0x27f>
	else if (lflag)
  8004d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004d7:	74 68                	je     800541 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e1:	89 c1                	mov    %eax,%ecx
  8004e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	8d 40 04             	lea    0x4(%eax),%eax
  8004ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f2:	eb 17                	jmp    80050b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8b 50 04             	mov    0x4(%eax),%edx
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8d 40 08             	lea    0x8(%eax),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80050b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80050e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800511:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800514:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800517:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051b:	78 3f                	js     80055c <vprintfmt+0x2e7>
			base = 10;
  80051d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800522:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800526:	0f 84 71 01 00 00    	je     80069d <vprintfmt+0x428>
				putch('+', putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	53                   	push   %ebx
  800530:	6a 2b                	push   $0x2b
  800532:	ff d6                	call   *%esi
  800534:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800537:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053c:	e9 5c 01 00 00       	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800549:	89 c1                	mov    %eax,%ecx
  80054b:	c1 f9 1f             	sar    $0x1f,%ecx
  80054e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	eb af                	jmp    80050b <vprintfmt+0x296>
				putch('-', putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	6a 2d                	push   $0x2d
  800562:	ff d6                	call   *%esi
				num = -(long long) num;
  800564:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800567:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056a:	f7 d8                	neg    %eax
  80056c:	83 d2 00             	adc    $0x0,%edx
  80056f:	f7 da                	neg    %edx
  800571:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800574:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800577:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	e9 19 01 00 00       	jmp    80069d <vprintfmt+0x428>
	if (lflag >= 2)
  800584:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800588:	7f 29                	jg     8005b3 <vprintfmt+0x33e>
	else if (lflag)
  80058a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80058e:	74 44                	je     8005d4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ae:	e9 ea 00 00 00       	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 50 04             	mov    0x4(%eax),%edx
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 08             	lea    0x8(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cf:	e9 c9 00 00 00       	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 a6 00 00 00       	jmp    80069d <vprintfmt+0x428>
			putch('0', putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	6a 30                	push   $0x30
  8005fd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800606:	7f 26                	jg     80062e <vprintfmt+0x3b9>
	else if (lflag)
  800608:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060c:	74 3e                	je     80064c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800627:	b8 08 00 00 00       	mov    $0x8,%eax
  80062c:	eb 6f                	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 50 04             	mov    0x4(%eax),%edx
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8d 40 08             	lea    0x8(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800645:	b8 08 00 00 00       	mov    $0x8,%eax
  80064a:	eb 51                	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	ba 00 00 00 00       	mov    $0x0,%edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800665:	b8 08 00 00 00       	mov    $0x8,%eax
  80066a:	eb 31                	jmp    80069d <vprintfmt+0x428>
			putch('0', putdat);
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	53                   	push   %ebx
  800670:	6a 30                	push   $0x30
  800672:	ff d6                	call   *%esi
			putch('x', putdat);
  800674:	83 c4 08             	add    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 78                	push   $0x78
  80067a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80068c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800698:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006a4:	52                   	push   %edx
  8006a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8006af:	89 da                	mov    %ebx,%edx
  8006b1:	89 f0                	mov    %esi,%eax
  8006b3:	e8 a4 fa ff ff       	call   80015c <printnum>
			break;
  8006b8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006be:	83 c7 01             	add    $0x1,%edi
  8006c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c5:	83 f8 25             	cmp    $0x25,%eax
  8006c8:	0f 84 be fb ff ff    	je     80028c <vprintfmt+0x17>
			if (ch == '\0')
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	0f 84 28 01 00 00    	je     8007fe <vprintfmt+0x589>
			putch(ch, putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	53                   	push   %ebx
  8006da:	50                   	push   %eax
  8006db:	ff d6                	call   *%esi
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	eb dc                	jmp    8006be <vprintfmt+0x449>
	if (lflag >= 2)
  8006e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e6:	7f 26                	jg     80070e <vprintfmt+0x499>
	else if (lflag)
  8006e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ec:	74 41                	je     80072f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800707:	b8 10 00 00 00       	mov    $0x10,%eax
  80070c:	eb 8f                	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 50 04             	mov    0x4(%eax),%edx
  800714:	8b 00                	mov    (%eax),%eax
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 40 08             	lea    0x8(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
  80072a:	e9 6e ff ff ff       	jmp    80069d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	ba 00 00 00 00       	mov    $0x0,%edx
  800739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 04             	lea    0x4(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800748:	b8 10 00 00 00       	mov    $0x10,%eax
  80074d:	e9 4b ff ff ff       	jmp    80069d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	83 c0 04             	add    $0x4,%eax
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	85 c0                	test   %eax,%eax
  800762:	74 14                	je     800778 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800764:	8b 13                	mov    (%ebx),%edx
  800766:	83 fa 7f             	cmp    $0x7f,%edx
  800769:	7f 37                	jg     8007a2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80076b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80076d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
  800773:	e9 43 ff ff ff       	jmp    8006bb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800778:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077d:	bf 31 26 80 00       	mov    $0x802631,%edi
							putch(ch, putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	53                   	push   %ebx
  800786:	50                   	push   %eax
  800787:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800789:	83 c7 01             	add    $0x1,%edi
  80078c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	85 c0                	test   %eax,%eax
  800795:	75 eb                	jne    800782 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800797:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
  80079d:	e9 19 ff ff ff       	jmp    8006bb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007a2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a9:	bf 69 26 80 00       	mov    $0x802669,%edi
							putch(ch, putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	50                   	push   %eax
  8007b3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b5:	83 c7 01             	add    $0x1,%edi
  8007b8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	75 eb                	jne    8007ae <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	e9 ed fe ff ff       	jmp    8006bb <vprintfmt+0x446>
			putch(ch, putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	6a 25                	push   $0x25
  8007d4:	ff d6                	call   *%esi
			break;
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	e9 dd fe ff ff       	jmp    8006bb <vprintfmt+0x446>
			putch('%', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	53                   	push   %ebx
  8007e2:	6a 25                	push   $0x25
  8007e4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	89 f8                	mov    %edi,%eax
  8007eb:	eb 03                	jmp    8007f0 <vprintfmt+0x57b>
  8007ed:	83 e8 01             	sub    $0x1,%eax
  8007f0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f4:	75 f7                	jne    8007ed <vprintfmt+0x578>
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	e9 bd fe ff ff       	jmp    8006bb <vprintfmt+0x446>
}
  8007fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800801:	5b                   	pop    %ebx
  800802:	5e                   	pop    %esi
  800803:	5f                   	pop    %edi
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	83 ec 18             	sub    $0x18,%esp
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800812:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800815:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800819:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800823:	85 c0                	test   %eax,%eax
  800825:	74 26                	je     80084d <vsnprintf+0x47>
  800827:	85 d2                	test   %edx,%edx
  800829:	7e 22                	jle    80084d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082b:	ff 75 14             	pushl  0x14(%ebp)
  80082e:	ff 75 10             	pushl  0x10(%ebp)
  800831:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	68 3b 02 80 00       	push   $0x80023b
  80083a:	e8 36 fa ff ff       	call   800275 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800842:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    
		return -E_INVAL;
  80084d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800852:	eb f7                	jmp    80084b <vsnprintf+0x45>

00800854 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085d:	50                   	push   %eax
  80085e:	ff 75 10             	pushl  0x10(%ebp)
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 08             	pushl  0x8(%ebp)
  800867:	e8 9a ff ff ff       	call   800806 <vsnprintf>
	va_end(ap);

	return rc;
}
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    

0080086e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
  800879:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087d:	74 05                	je     800884 <strlen+0x16>
		n++;
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	eb f5                	jmp    800879 <strlen+0xb>
	return n;
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088f:	ba 00 00 00 00       	mov    $0x0,%edx
  800894:	39 c2                	cmp    %eax,%edx
  800896:	74 0d                	je     8008a5 <strnlen+0x1f>
  800898:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80089c:	74 05                	je     8008a3 <strnlen+0x1d>
		n++;
  80089e:	83 c2 01             	add    $0x1,%edx
  8008a1:	eb f1                	jmp    800894 <strnlen+0xe>
  8008a3:	89 d0                	mov    %edx,%eax
	return n;
}
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ba:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008bd:	83 c2 01             	add    $0x1,%edx
  8008c0:	84 c9                	test   %cl,%cl
  8008c2:	75 f2                	jne    8008b6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c4:	5b                   	pop    %ebx
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	83 ec 10             	sub    $0x10,%esp
  8008ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d1:	53                   	push   %ebx
  8008d2:	e8 97 ff ff ff       	call   80086e <strlen>
  8008d7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	01 d8                	add    %ebx,%eax
  8008df:	50                   	push   %eax
  8008e0:	e8 c2 ff ff ff       	call   8008a7 <strcpy>
	return dst;
}
  8008e5:	89 d8                	mov    %ebx,%eax
  8008e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	56                   	push   %esi
  8008f0:	53                   	push   %ebx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f7:	89 c6                	mov    %eax,%esi
  8008f9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fc:	89 c2                	mov    %eax,%edx
  8008fe:	39 f2                	cmp    %esi,%edx
  800900:	74 11                	je     800913 <strncpy+0x27>
		*dst++ = *src;
  800902:	83 c2 01             	add    $0x1,%edx
  800905:	0f b6 19             	movzbl (%ecx),%ebx
  800908:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090b:	80 fb 01             	cmp    $0x1,%bl
  80090e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800911:	eb eb                	jmp    8008fe <strncpy+0x12>
	}
	return ret;
}
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	8b 75 08             	mov    0x8(%ebp),%esi
  80091f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800922:	8b 55 10             	mov    0x10(%ebp),%edx
  800925:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800927:	85 d2                	test   %edx,%edx
  800929:	74 21                	je     80094c <strlcpy+0x35>
  80092b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800931:	39 c2                	cmp    %eax,%edx
  800933:	74 14                	je     800949 <strlcpy+0x32>
  800935:	0f b6 19             	movzbl (%ecx),%ebx
  800938:	84 db                	test   %bl,%bl
  80093a:	74 0b                	je     800947 <strlcpy+0x30>
			*dst++ = *src++;
  80093c:	83 c1 01             	add    $0x1,%ecx
  80093f:	83 c2 01             	add    $0x1,%edx
  800942:	88 5a ff             	mov    %bl,-0x1(%edx)
  800945:	eb ea                	jmp    800931 <strlcpy+0x1a>
  800947:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800949:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094c:	29 f0                	sub    %esi,%eax
}
  80094e:	5b                   	pop    %ebx
  80094f:	5e                   	pop    %esi
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095b:	0f b6 01             	movzbl (%ecx),%eax
  80095e:	84 c0                	test   %al,%al
  800960:	74 0c                	je     80096e <strcmp+0x1c>
  800962:	3a 02                	cmp    (%edx),%al
  800964:	75 08                	jne    80096e <strcmp+0x1c>
		p++, q++;
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	eb ed                	jmp    80095b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096e:	0f b6 c0             	movzbl %al,%eax
  800971:	0f b6 12             	movzbl (%edx),%edx
  800974:	29 d0                	sub    %edx,%eax
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	53                   	push   %ebx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 c3                	mov    %eax,%ebx
  800984:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800987:	eb 06                	jmp    80098f <strncmp+0x17>
		n--, p++, q++;
  800989:	83 c0 01             	add    $0x1,%eax
  80098c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80098f:	39 d8                	cmp    %ebx,%eax
  800991:	74 16                	je     8009a9 <strncmp+0x31>
  800993:	0f b6 08             	movzbl (%eax),%ecx
  800996:	84 c9                	test   %cl,%cl
  800998:	74 04                	je     80099e <strncmp+0x26>
  80099a:	3a 0a                	cmp    (%edx),%cl
  80099c:	74 eb                	je     800989 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80099e:	0f b6 00             	movzbl (%eax),%eax
  8009a1:	0f b6 12             	movzbl (%edx),%edx
  8009a4:	29 d0                	sub    %edx,%eax
}
  8009a6:	5b                   	pop    %ebx
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    
		return 0;
  8009a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ae:	eb f6                	jmp    8009a6 <strncmp+0x2e>

008009b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ba:	0f b6 10             	movzbl (%eax),%edx
  8009bd:	84 d2                	test   %dl,%dl
  8009bf:	74 09                	je     8009ca <strchr+0x1a>
		if (*s == c)
  8009c1:	38 ca                	cmp    %cl,%dl
  8009c3:	74 0a                	je     8009cf <strchr+0x1f>
	for (; *s; s++)
  8009c5:	83 c0 01             	add    $0x1,%eax
  8009c8:	eb f0                	jmp    8009ba <strchr+0xa>
			return (char *) s;
	return 0;
  8009ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009db:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009de:	38 ca                	cmp    %cl,%dl
  8009e0:	74 09                	je     8009eb <strfind+0x1a>
  8009e2:	84 d2                	test   %dl,%dl
  8009e4:	74 05                	je     8009eb <strfind+0x1a>
	for (; *s; s++)
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	eb f0                	jmp    8009db <strfind+0xa>
			break;
	return (char *) s;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	57                   	push   %edi
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f9:	85 c9                	test   %ecx,%ecx
  8009fb:	74 31                	je     800a2e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	09 c8                	or     %ecx,%eax
  800a01:	a8 03                	test   $0x3,%al
  800a03:	75 23                	jne    800a28 <memset+0x3b>
		c &= 0xFF;
  800a05:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a09:	89 d3                	mov    %edx,%ebx
  800a0b:	c1 e3 08             	shl    $0x8,%ebx
  800a0e:	89 d0                	mov    %edx,%eax
  800a10:	c1 e0 18             	shl    $0x18,%eax
  800a13:	89 d6                	mov    %edx,%esi
  800a15:	c1 e6 10             	shl    $0x10,%esi
  800a18:	09 f0                	or     %esi,%eax
  800a1a:	09 c2                	or     %eax,%edx
  800a1c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	fc                   	cld    
  800a24:	f3 ab                	rep stos %eax,%es:(%edi)
  800a26:	eb 06                	jmp    800a2e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	fc                   	cld    
  800a2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2e:	89 f8                	mov    %edi,%eax
  800a30:	5b                   	pop    %ebx
  800a31:	5e                   	pop    %esi
  800a32:	5f                   	pop    %edi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	57                   	push   %edi
  800a39:	56                   	push   %esi
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a43:	39 c6                	cmp    %eax,%esi
  800a45:	73 32                	jae    800a79 <memmove+0x44>
  800a47:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a4a:	39 c2                	cmp    %eax,%edx
  800a4c:	76 2b                	jbe    800a79 <memmove+0x44>
		s += n;
		d += n;
  800a4e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a51:	89 fe                	mov    %edi,%esi
  800a53:	09 ce                	or     %ecx,%esi
  800a55:	09 d6                	or     %edx,%esi
  800a57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5d:	75 0e                	jne    800a6d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a5f:	83 ef 04             	sub    $0x4,%edi
  800a62:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a68:	fd                   	std    
  800a69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6b:	eb 09                	jmp    800a76 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6d:	83 ef 01             	sub    $0x1,%edi
  800a70:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a73:	fd                   	std    
  800a74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a76:	fc                   	cld    
  800a77:	eb 1a                	jmp    800a93 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	09 ca                	or     %ecx,%edx
  800a7d:	09 f2                	or     %esi,%edx
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 0a                	jne    800a8e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a87:	89 c7                	mov    %eax,%edi
  800a89:	fc                   	cld    
  800a8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8c:	eb 05                	jmp    800a93 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a8e:	89 c7                	mov    %eax,%edi
  800a90:	fc                   	cld    
  800a91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a93:	5e                   	pop    %esi
  800a94:	5f                   	pop    %edi
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a9d:	ff 75 10             	pushl  0x10(%ebp)
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 8a ff ff ff       	call   800a35 <memmove>
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	89 c6                	mov    %eax,%esi
  800aba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abd:	39 f0                	cmp    %esi,%eax
  800abf:	74 1c                	je     800add <memcmp+0x30>
		if (*s1 != *s2)
  800ac1:	0f b6 08             	movzbl (%eax),%ecx
  800ac4:	0f b6 1a             	movzbl (%edx),%ebx
  800ac7:	38 d9                	cmp    %bl,%cl
  800ac9:	75 08                	jne    800ad3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	83 c2 01             	add    $0x1,%edx
  800ad1:	eb ea                	jmp    800abd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad3:	0f b6 c1             	movzbl %cl,%eax
  800ad6:	0f b6 db             	movzbl %bl,%ebx
  800ad9:	29 d8                	sub    %ebx,%eax
  800adb:	eb 05                	jmp    800ae2 <memcmp+0x35>
	}

	return 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af4:	39 d0                	cmp    %edx,%eax
  800af6:	73 09                	jae    800b01 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af8:	38 08                	cmp    %cl,(%eax)
  800afa:	74 05                	je     800b01 <memfind+0x1b>
	for (; s < ends; s++)
  800afc:	83 c0 01             	add    $0x1,%eax
  800aff:	eb f3                	jmp    800af4 <memfind+0xe>
			break;
	return (void *) s;
}
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0f:	eb 03                	jmp    800b14 <strtol+0x11>
		s++;
  800b11:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b14:	0f b6 01             	movzbl (%ecx),%eax
  800b17:	3c 20                	cmp    $0x20,%al
  800b19:	74 f6                	je     800b11 <strtol+0xe>
  800b1b:	3c 09                	cmp    $0x9,%al
  800b1d:	74 f2                	je     800b11 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b1f:	3c 2b                	cmp    $0x2b,%al
  800b21:	74 2a                	je     800b4d <strtol+0x4a>
	int neg = 0;
  800b23:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b28:	3c 2d                	cmp    $0x2d,%al
  800b2a:	74 2b                	je     800b57 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b32:	75 0f                	jne    800b43 <strtol+0x40>
  800b34:	80 39 30             	cmpb   $0x30,(%ecx)
  800b37:	74 28                	je     800b61 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b39:	85 db                	test   %ebx,%ebx
  800b3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b40:	0f 44 d8             	cmove  %eax,%ebx
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4b:	eb 50                	jmp    800b9d <strtol+0x9a>
		s++;
  800b4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b50:	bf 00 00 00 00       	mov    $0x0,%edi
  800b55:	eb d5                	jmp    800b2c <strtol+0x29>
		s++, neg = 1;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b5f:	eb cb                	jmp    800b2c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b65:	74 0e                	je     800b75 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	75 d8                	jne    800b43 <strtol+0x40>
		s++, base = 8;
  800b6b:	83 c1 01             	add    $0x1,%ecx
  800b6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b73:	eb ce                	jmp    800b43 <strtol+0x40>
		s += 2, base = 16;
  800b75:	83 c1 02             	add    $0x2,%ecx
  800b78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b7d:	eb c4                	jmp    800b43 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 19             	cmp    $0x19,%bl
  800b87:	77 29                	ja     800bb2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b89:	0f be d2             	movsbl %dl,%edx
  800b8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b92:	7d 30                	jge    800bc4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b94:	83 c1 01             	add    $0x1,%ecx
  800b97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b9d:	0f b6 11             	movzbl (%ecx),%edx
  800ba0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba3:	89 f3                	mov    %esi,%ebx
  800ba5:	80 fb 09             	cmp    $0x9,%bl
  800ba8:	77 d5                	ja     800b7f <strtol+0x7c>
			dig = *s - '0';
  800baa:	0f be d2             	movsbl %dl,%edx
  800bad:	83 ea 30             	sub    $0x30,%edx
  800bb0:	eb dd                	jmp    800b8f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bb2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb5:	89 f3                	mov    %esi,%ebx
  800bb7:	80 fb 19             	cmp    $0x19,%bl
  800bba:	77 08                	ja     800bc4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bbc:	0f be d2             	movsbl %dl,%edx
  800bbf:	83 ea 37             	sub    $0x37,%edx
  800bc2:	eb cb                	jmp    800b8f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	74 05                	je     800bcf <strtol+0xcc>
		*endptr = (char *) s;
  800bca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bcf:	89 c2                	mov    %eax,%edx
  800bd1:	f7 da                	neg    %edx
  800bd3:	85 ff                	test   %edi,%edi
  800bd5:	0f 45 c2             	cmovne %edx,%eax
}
  800bd8:	5b                   	pop    %ebx
  800bd9:	5e                   	pop    %esi
  800bda:	5f                   	pop    %edi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
  800be8:	8b 55 08             	mov    0x8(%ebp),%edx
  800beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bee:	89 c3                	mov    %eax,%ebx
  800bf0:	89 c7                	mov    %eax,%edi
  800bf2:	89 c6                	mov    %eax,%esi
  800bf4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <sys_cgetc>:

int
sys_cgetc(void)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c01:	ba 00 00 00 00       	mov    $0x0,%edx
  800c06:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0b:	89 d1                	mov    %edx,%ecx
  800c0d:	89 d3                	mov    %edx,%ebx
  800c0f:	89 d7                	mov    %edx,%edi
  800c11:	89 d6                	mov    %edx,%esi
  800c13:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	57                   	push   %edi
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c30:	89 cb                	mov    %ecx,%ebx
  800c32:	89 cf                	mov    %ecx,%edi
  800c34:	89 ce                	mov    %ecx,%esi
  800c36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c38:	85 c0                	test   %eax,%eax
  800c3a:	7f 08                	jg     800c44 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c44:	83 ec 0c             	sub    $0xc,%esp
  800c47:	50                   	push   %eax
  800c48:	6a 03                	push   $0x3
  800c4a:	68 88 28 80 00       	push   $0x802888
  800c4f:	6a 43                	push   $0x43
  800c51:	68 a5 28 80 00       	push   $0x8028a5
  800c56:	e8 89 14 00 00       	call   8020e4 <_panic>

00800c5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6b:	89 d1                	mov    %edx,%ecx
  800c6d:	89 d3                	mov    %edx,%ebx
  800c6f:	89 d7                	mov    %edx,%edi
  800c71:	89 d6                	mov    %edx,%esi
  800c73:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_yield>:

void
sys_yield(void)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca2:	be 00 00 00 00       	mov    $0x0,%esi
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb5:	89 f7                	mov    %esi,%edi
  800cb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	7f 08                	jg     800cc5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	50                   	push   %eax
  800cc9:	6a 04                	push   $0x4
  800ccb:	68 88 28 80 00       	push   $0x802888
  800cd0:	6a 43                	push   $0x43
  800cd2:	68 a5 28 80 00       	push   $0x8028a5
  800cd7:	e8 08 14 00 00       	call   8020e4 <_panic>

00800cdc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf6:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	6a 05                	push   $0x5
  800d0d:	68 88 28 80 00       	push   $0x802888
  800d12:	6a 43                	push   $0x43
  800d14:	68 a5 28 80 00       	push   $0x8028a5
  800d19:	e8 c6 13 00 00       	call   8020e4 <_panic>

00800d1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 06 00 00 00       	mov    $0x6,%eax
  800d37:	89 df                	mov    %ebx,%edi
  800d39:	89 de                	mov    %ebx,%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 06                	push   $0x6
  800d4f:	68 88 28 80 00       	push   $0x802888
  800d54:	6a 43                	push   $0x43
  800d56:	68 a5 28 80 00       	push   $0x8028a5
  800d5b:	e8 84 13 00 00       	call   8020e4 <_panic>

00800d60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	b8 08 00 00 00       	mov    $0x8,%eax
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	89 de                	mov    %ebx,%esi
  800d7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7f 08                	jg     800d8b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	50                   	push   %eax
  800d8f:	6a 08                	push   $0x8
  800d91:	68 88 28 80 00       	push   $0x802888
  800d96:	6a 43                	push   $0x43
  800d98:	68 a5 28 80 00       	push   $0x8028a5
  800d9d:	e8 42 13 00 00       	call   8020e4 <_panic>

00800da2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	50                   	push   %eax
  800dd1:	6a 09                	push   $0x9
  800dd3:	68 88 28 80 00       	push   $0x802888
  800dd8:	6a 43                	push   $0x43
  800dda:	68 a5 28 80 00       	push   $0x8028a5
  800ddf:	e8 00 13 00 00       	call   8020e4 <_panic>

00800de4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ded:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfd:	89 df                	mov    %ebx,%edi
  800dff:	89 de                	mov    %ebx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 0a                	push   $0xa
  800e15:	68 88 28 80 00       	push   $0x802888
  800e1a:	6a 43                	push   $0x43
  800e1c:	68 a5 28 80 00       	push   $0x8028a5
  800e21:	e8 be 12 00 00       	call   8020e4 <_panic>

00800e26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e37:	be 00 00 00 00       	mov    $0x0,%esi
  800e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e42:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5f:	89 cb                	mov    %ecx,%ebx
  800e61:	89 cf                	mov    %ecx,%edi
  800e63:	89 ce                	mov    %ecx,%esi
  800e65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7f 08                	jg     800e73 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	50                   	push   %eax
  800e77:	6a 0d                	push   $0xd
  800e79:	68 88 28 80 00       	push   $0x802888
  800e7e:	6a 43                	push   $0x43
  800e80:	68 a5 28 80 00       	push   $0x8028a5
  800e85:	e8 5a 12 00 00       	call   8020e4 <_panic>

00800e8a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ebe:	89 cb                	mov    %ecx,%ebx
  800ec0:	89 cf                	mov    %ecx,%edi
  800ec2:	89 ce                	mov    %ecx,%esi
  800ec4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed6:	b8 10 00 00 00       	mov    $0x10,%eax
  800edb:	89 d1                	mov    %edx,%ecx
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	89 d6                	mov    %edx,%esi
  800ee3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	b8 11 00 00 00       	mov    $0x11,%eax
  800f00:	89 df                	mov    %ebx,%edi
  800f02:	89 de                	mov    %ebx,%esi
  800f04:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 12 00 00 00       	mov    $0x12,%eax
  800f21:	89 df                	mov    %ebx,%edi
  800f23:	89 de                	mov    %ebx,%esi
  800f25:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f40:	b8 13 00 00 00       	mov    $0x13,%eax
  800f45:	89 df                	mov    %ebx,%edi
  800f47:	89 de                	mov    %ebx,%esi
  800f49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	7f 08                	jg     800f57 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	50                   	push   %eax
  800f5b:	6a 13                	push   $0x13
  800f5d:	68 88 28 80 00       	push   $0x802888
  800f62:	6a 43                	push   $0x43
  800f64:	68 a5 28 80 00       	push   $0x8028a5
  800f69:	e8 76 11 00 00       	call   8020e4 <_panic>

00800f6e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	b8 14 00 00 00       	mov    $0x14,%eax
  800f81:	89 cb                	mov    %ecx,%ebx
  800f83:	89 cf                	mov    %ecx,%edi
  800f85:	89 ce                	mov    %ecx,%esi
  800f87:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	05 00 00 00 30       	add    $0x30000000,%eax
  800f99:	c1 e8 0c             	shr    $0xc,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fae:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	c1 ea 16             	shr    $0x16,%edx
  800fc2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc9:	f6 c2 01             	test   $0x1,%dl
  800fcc:	74 2d                	je     800ffb <fd_alloc+0x46>
  800fce:	89 c2                	mov    %eax,%edx
  800fd0:	c1 ea 0c             	shr    $0xc,%edx
  800fd3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fda:	f6 c2 01             	test   $0x1,%dl
  800fdd:	74 1c                	je     800ffb <fd_alloc+0x46>
  800fdf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fe4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fe9:	75 d2                	jne    800fbd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ff4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ff9:	eb 0a                	jmp    801005 <fd_alloc+0x50>
			*fd_store = fd;
  800ffb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80100d:	83 f8 1f             	cmp    $0x1f,%eax
  801010:	77 30                	ja     801042 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801012:	c1 e0 0c             	shl    $0xc,%eax
  801015:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80101a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801020:	f6 c2 01             	test   $0x1,%dl
  801023:	74 24                	je     801049 <fd_lookup+0x42>
  801025:	89 c2                	mov    %eax,%edx
  801027:	c1 ea 0c             	shr    $0xc,%edx
  80102a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801031:	f6 c2 01             	test   $0x1,%dl
  801034:	74 1a                	je     801050 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801036:	8b 55 0c             	mov    0xc(%ebp),%edx
  801039:	89 02                	mov    %eax,(%edx)
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    
		return -E_INVAL;
  801042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801047:	eb f7                	jmp    801040 <fd_lookup+0x39>
		return -E_INVAL;
  801049:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104e:	eb f0                	jmp    801040 <fd_lookup+0x39>
  801050:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801055:	eb e9                	jmp    801040 <fd_lookup+0x39>

00801057 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801060:	ba 00 00 00 00       	mov    $0x0,%edx
  801065:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80106a:	39 08                	cmp    %ecx,(%eax)
  80106c:	74 38                	je     8010a6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80106e:	83 c2 01             	add    $0x1,%edx
  801071:	8b 04 95 30 29 80 00 	mov    0x802930(,%edx,4),%eax
  801078:	85 c0                	test   %eax,%eax
  80107a:	75 ee                	jne    80106a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80107c:	a1 08 40 80 00       	mov    0x804008,%eax
  801081:	8b 40 48             	mov    0x48(%eax),%eax
  801084:	83 ec 04             	sub    $0x4,%esp
  801087:	51                   	push   %ecx
  801088:	50                   	push   %eax
  801089:	68 b4 28 80 00       	push   $0x8028b4
  80108e:	e8 b5 f0 ff ff       	call   800148 <cprintf>
	*dev = 0;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    
			*dev = devtab[i];
  8010a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b0:	eb f2                	jmp    8010a4 <dev_lookup+0x4d>

008010b2 <fd_close>:
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	57                   	push   %edi
  8010b6:	56                   	push   %esi
  8010b7:	53                   	push   %ebx
  8010b8:	83 ec 24             	sub    $0x24,%esp
  8010bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8010be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010ce:	50                   	push   %eax
  8010cf:	e8 33 ff ff ff       	call   801007 <fd_lookup>
  8010d4:	89 c3                	mov    %eax,%ebx
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 05                	js     8010e2 <fd_close+0x30>
	    || fd != fd2)
  8010dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010e0:	74 16                	je     8010f8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010e2:	89 f8                	mov    %edi,%eax
  8010e4:	84 c0                	test   %al,%al
  8010e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8010ee:	89 d8                	mov    %ebx,%eax
  8010f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5f                   	pop    %edi
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010fe:	50                   	push   %eax
  8010ff:	ff 36                	pushl  (%esi)
  801101:	e8 51 ff ff ff       	call   801057 <dev_lookup>
  801106:	89 c3                	mov    %eax,%ebx
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 1a                	js     801129 <fd_close+0x77>
		if (dev->dev_close)
  80110f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801112:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80111a:	85 c0                	test   %eax,%eax
  80111c:	74 0b                	je     801129 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80111e:	83 ec 0c             	sub    $0xc,%esp
  801121:	56                   	push   %esi
  801122:	ff d0                	call   *%eax
  801124:	89 c3                	mov    %eax,%ebx
  801126:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	56                   	push   %esi
  80112d:	6a 00                	push   $0x0
  80112f:	e8 ea fb ff ff       	call   800d1e <sys_page_unmap>
	return r;
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	eb b5                	jmp    8010ee <fd_close+0x3c>

00801139 <close>:

int
close(int fdnum)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80113f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801142:	50                   	push   %eax
  801143:	ff 75 08             	pushl  0x8(%ebp)
  801146:	e8 bc fe ff ff       	call   801007 <fd_lookup>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	79 02                	jns    801154 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    
		return fd_close(fd, 1);
  801154:	83 ec 08             	sub    $0x8,%esp
  801157:	6a 01                	push   $0x1
  801159:	ff 75 f4             	pushl  -0xc(%ebp)
  80115c:	e8 51 ff ff ff       	call   8010b2 <fd_close>
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	eb ec                	jmp    801152 <close+0x19>

00801166 <close_all>:

void
close_all(void)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	53                   	push   %ebx
  80116a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80116d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	53                   	push   %ebx
  801176:	e8 be ff ff ff       	call   801139 <close>
	for (i = 0; i < MAXFD; i++)
  80117b:	83 c3 01             	add    $0x1,%ebx
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	83 fb 20             	cmp    $0x20,%ebx
  801184:	75 ec                	jne    801172 <close_all+0xc>
}
  801186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	57                   	push   %edi
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801194:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801197:	50                   	push   %eax
  801198:	ff 75 08             	pushl  0x8(%ebp)
  80119b:	e8 67 fe ff ff       	call   801007 <fd_lookup>
  8011a0:	89 c3                	mov    %eax,%ebx
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	0f 88 81 00 00 00    	js     80122e <dup+0xa3>
		return r;
	close(newfdnum);
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	e8 81 ff ff ff       	call   801139 <close>

	newfd = INDEX2FD(newfdnum);
  8011b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011bb:	c1 e6 0c             	shl    $0xc,%esi
  8011be:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011c4:	83 c4 04             	add    $0x4,%esp
  8011c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ca:	e8 cf fd ff ff       	call   800f9e <fd2data>
  8011cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011d1:	89 34 24             	mov    %esi,(%esp)
  8011d4:	e8 c5 fd ff ff       	call   800f9e <fd2data>
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011de:	89 d8                	mov    %ebx,%eax
  8011e0:	c1 e8 16             	shr    $0x16,%eax
  8011e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ea:	a8 01                	test   $0x1,%al
  8011ec:	74 11                	je     8011ff <dup+0x74>
  8011ee:	89 d8                	mov    %ebx,%eax
  8011f0:	c1 e8 0c             	shr    $0xc,%eax
  8011f3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011fa:	f6 c2 01             	test   $0x1,%dl
  8011fd:	75 39                	jne    801238 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	c1 e8 0c             	shr    $0xc,%eax
  801207:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	25 07 0e 00 00       	and    $0xe07,%eax
  801216:	50                   	push   %eax
  801217:	56                   	push   %esi
  801218:	6a 00                	push   $0x0
  80121a:	52                   	push   %edx
  80121b:	6a 00                	push   $0x0
  80121d:	e8 ba fa ff ff       	call   800cdc <sys_page_map>
  801222:	89 c3                	mov    %eax,%ebx
  801224:	83 c4 20             	add    $0x20,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	78 31                	js     80125c <dup+0xd1>
		goto err;

	return newfdnum;
  80122b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80122e:	89 d8                	mov    %ebx,%eax
  801230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801238:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	25 07 0e 00 00       	and    $0xe07,%eax
  801247:	50                   	push   %eax
  801248:	57                   	push   %edi
  801249:	6a 00                	push   $0x0
  80124b:	53                   	push   %ebx
  80124c:	6a 00                	push   $0x0
  80124e:	e8 89 fa ff ff       	call   800cdc <sys_page_map>
  801253:	89 c3                	mov    %eax,%ebx
  801255:	83 c4 20             	add    $0x20,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	79 a3                	jns    8011ff <dup+0x74>
	sys_page_unmap(0, newfd);
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	56                   	push   %esi
  801260:	6a 00                	push   $0x0
  801262:	e8 b7 fa ff ff       	call   800d1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	57                   	push   %edi
  80126b:	6a 00                	push   $0x0
  80126d:	e8 ac fa ff ff       	call   800d1e <sys_page_unmap>
	return r;
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	eb b7                	jmp    80122e <dup+0xa3>

00801277 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	53                   	push   %ebx
  80127b:	83 ec 1c             	sub    $0x1c,%esp
  80127e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801281:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801284:	50                   	push   %eax
  801285:	53                   	push   %ebx
  801286:	e8 7c fd ff ff       	call   801007 <fd_lookup>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 3f                	js     8012d1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801292:	83 ec 08             	sub    $0x8,%esp
  801295:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801298:	50                   	push   %eax
  801299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129c:	ff 30                	pushl  (%eax)
  80129e:	e8 b4 fd ff ff       	call   801057 <dev_lookup>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 27                	js     8012d1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ad:	8b 42 08             	mov    0x8(%edx),%eax
  8012b0:	83 e0 03             	and    $0x3,%eax
  8012b3:	83 f8 01             	cmp    $0x1,%eax
  8012b6:	74 1e                	je     8012d6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bb:	8b 40 08             	mov    0x8(%eax),%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 35                	je     8012f7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	ff 75 10             	pushl  0x10(%ebp)
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	ff d0                	call   *%eax
  8012ce:	83 c4 10             	add    $0x10,%esp
}
  8012d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8012db:	8b 40 48             	mov    0x48(%eax),%eax
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	53                   	push   %ebx
  8012e2:	50                   	push   %eax
  8012e3:	68 f5 28 80 00       	push   $0x8028f5
  8012e8:	e8 5b ee ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f5:	eb da                	jmp    8012d1 <read+0x5a>
		return -E_NOT_SUPP;
  8012f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012fc:	eb d3                	jmp    8012d1 <read+0x5a>

008012fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	8b 7d 08             	mov    0x8(%ebp),%edi
  80130a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80130d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801312:	39 f3                	cmp    %esi,%ebx
  801314:	73 23                	jae    801339 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	89 f0                	mov    %esi,%eax
  80131b:	29 d8                	sub    %ebx,%eax
  80131d:	50                   	push   %eax
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	03 45 0c             	add    0xc(%ebp),%eax
  801323:	50                   	push   %eax
  801324:	57                   	push   %edi
  801325:	e8 4d ff ff ff       	call   801277 <read>
		if (m < 0)
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 06                	js     801337 <readn+0x39>
			return m;
		if (m == 0)
  801331:	74 06                	je     801339 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801333:	01 c3                	add    %eax,%ebx
  801335:	eb db                	jmp    801312 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801337:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801339:	89 d8                	mov    %ebx,%eax
  80133b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5f                   	pop    %edi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	53                   	push   %ebx
  801347:	83 ec 1c             	sub    $0x1c,%esp
  80134a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801350:	50                   	push   %eax
  801351:	53                   	push   %ebx
  801352:	e8 b0 fc ff ff       	call   801007 <fd_lookup>
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 3a                	js     801398 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801368:	ff 30                	pushl  (%eax)
  80136a:	e8 e8 fc ff ff       	call   801057 <dev_lookup>
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 22                	js     801398 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801379:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80137d:	74 1e                	je     80139d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80137f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801382:	8b 52 0c             	mov    0xc(%edx),%edx
  801385:	85 d2                	test   %edx,%edx
  801387:	74 35                	je     8013be <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	ff 75 10             	pushl  0x10(%ebp)
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	50                   	push   %eax
  801393:	ff d2                	call   *%edx
  801395:	83 c4 10             	add    $0x10,%esp
}
  801398:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80139d:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a2:	8b 40 48             	mov    0x48(%eax),%eax
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	50                   	push   %eax
  8013aa:	68 11 29 80 00       	push   $0x802911
  8013af:	e8 94 ed ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bc:	eb da                	jmp    801398 <write+0x55>
		return -E_NOT_SUPP;
  8013be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c3:	eb d3                	jmp    801398 <write+0x55>

008013c5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	ff 75 08             	pushl  0x8(%ebp)
  8013d2:	e8 30 fc ff ff       	call   801007 <fd_lookup>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 0e                	js     8013ec <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fb:	50                   	push   %eax
  8013fc:	53                   	push   %ebx
  8013fd:	e8 05 fc ff ff       	call   801007 <fd_lookup>
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 37                	js     801440 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140f:	50                   	push   %eax
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	ff 30                	pushl  (%eax)
  801415:	e8 3d fc ff ff       	call   801057 <dev_lookup>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 1f                	js     801440 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801424:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801428:	74 1b                	je     801445 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 52 18             	mov    0x18(%edx),%edx
  801430:	85 d2                	test   %edx,%edx
  801432:	74 32                	je     801466 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	ff 75 0c             	pushl  0xc(%ebp)
  80143a:	50                   	push   %eax
  80143b:	ff d2                	call   *%edx
  80143d:	83 c4 10             	add    $0x10,%esp
}
  801440:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801443:	c9                   	leave  
  801444:	c3                   	ret    
			thisenv->env_id, fdnum);
  801445:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80144a:	8b 40 48             	mov    0x48(%eax),%eax
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	53                   	push   %ebx
  801451:	50                   	push   %eax
  801452:	68 d4 28 80 00       	push   $0x8028d4
  801457:	e8 ec ec ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801464:	eb da                	jmp    801440 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801466:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146b:	eb d3                	jmp    801440 <ftruncate+0x52>

0080146d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	83 ec 1c             	sub    $0x1c,%esp
  801474:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801477:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147a:	50                   	push   %eax
  80147b:	ff 75 08             	pushl  0x8(%ebp)
  80147e:	e8 84 fb ff ff       	call   801007 <fd_lookup>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 4b                	js     8014d5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801494:	ff 30                	pushl  (%eax)
  801496:	e8 bc fb ff ff       	call   801057 <dev_lookup>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 33                	js     8014d5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014a9:	74 2f                	je     8014da <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ab:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ae:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014b5:	00 00 00 
	stat->st_isdir = 0;
  8014b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014bf:	00 00 00 
	stat->st_dev = dev;
  8014c2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014c8:	83 ec 08             	sub    $0x8,%esp
  8014cb:	53                   	push   %ebx
  8014cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8014cf:	ff 50 14             	call   *0x14(%eax)
  8014d2:	83 c4 10             	add    $0x10,%esp
}
  8014d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    
		return -E_NOT_SUPP;
  8014da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014df:	eb f4                	jmp    8014d5 <fstat+0x68>

008014e1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	6a 00                	push   $0x0
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	e8 22 02 00 00       	call   801715 <open>
  8014f3:	89 c3                	mov    %eax,%ebx
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 1b                	js     801517 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	ff 75 0c             	pushl  0xc(%ebp)
  801502:	50                   	push   %eax
  801503:	e8 65 ff ff ff       	call   80146d <fstat>
  801508:	89 c6                	mov    %eax,%esi
	close(fd);
  80150a:	89 1c 24             	mov    %ebx,(%esp)
  80150d:	e8 27 fc ff ff       	call   801139 <close>
	return r;
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	89 f3                	mov    %esi,%ebx
}
  801517:	89 d8                	mov    %ebx,%eax
  801519:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	89 c6                	mov    %eax,%esi
  801527:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801529:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801530:	74 27                	je     801559 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801532:	6a 07                	push   $0x7
  801534:	68 00 50 80 00       	push   $0x805000
  801539:	56                   	push   %esi
  80153a:	ff 35 00 40 80 00    	pushl  0x804000
  801540:	e8 69 0c 00 00       	call   8021ae <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801545:	83 c4 0c             	add    $0xc,%esp
  801548:	6a 00                	push   $0x0
  80154a:	53                   	push   %ebx
  80154b:	6a 00                	push   $0x0
  80154d:	e8 f3 0b 00 00       	call   802145 <ipc_recv>
}
  801552:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5d                   	pop    %ebp
  801558:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	6a 01                	push   $0x1
  80155e:	e8 a3 0c 00 00       	call   802206 <ipc_find_env>
  801563:	a3 00 40 80 00       	mov    %eax,0x804000
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	eb c5                	jmp    801532 <fsipc+0x12>

0080156d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8b 40 0c             	mov    0xc(%eax),%eax
  801579:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801586:	ba 00 00 00 00       	mov    $0x0,%edx
  80158b:	b8 02 00 00 00       	mov    $0x2,%eax
  801590:	e8 8b ff ff ff       	call   801520 <fsipc>
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <devfile_flush>:
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b2:	e8 69 ff ff ff       	call   801520 <fsipc>
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <devfile_stat>:
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d8:	e8 43 ff ff ff       	call   801520 <fsipc>
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 2c                	js     80160d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	68 00 50 80 00       	push   $0x805000
  8015e9:	53                   	push   %ebx
  8015ea:	e8 b8 f2 ff ff       	call   8008a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ef:	a1 80 50 80 00       	mov    0x805080,%eax
  8015f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015fa:	a1 84 50 80 00       	mov    0x805084,%eax
  8015ff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <devfile_write>:
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	8b 40 0c             	mov    0xc(%eax),%eax
  801622:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801627:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80162d:	53                   	push   %ebx
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	68 08 50 80 00       	push   $0x805008
  801636:	e8 5c f4 ff ff       	call   800a97 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	b8 04 00 00 00       	mov    $0x4,%eax
  801645:	e8 d6 fe ff ff       	call   801520 <fsipc>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	78 0b                	js     80165c <devfile_write+0x4a>
	assert(r <= n);
  801651:	39 d8                	cmp    %ebx,%eax
  801653:	77 0c                	ja     801661 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801655:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165a:	7f 1e                	jg     80167a <devfile_write+0x68>
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
	assert(r <= n);
  801661:	68 44 29 80 00       	push   $0x802944
  801666:	68 4b 29 80 00       	push   $0x80294b
  80166b:	68 98 00 00 00       	push   $0x98
  801670:	68 60 29 80 00       	push   $0x802960
  801675:	e8 6a 0a 00 00       	call   8020e4 <_panic>
	assert(r <= PGSIZE);
  80167a:	68 6b 29 80 00       	push   $0x80296b
  80167f:	68 4b 29 80 00       	push   $0x80294b
  801684:	68 99 00 00 00       	push   $0x99
  801689:	68 60 29 80 00       	push   $0x802960
  80168e:	e8 51 0a 00 00       	call   8020e4 <_panic>

00801693 <devfile_read>:
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016a6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8016b6:	e8 65 fe ff ff       	call   801520 <fsipc>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 1f                	js     8016e0 <devfile_read+0x4d>
	assert(r <= n);
  8016c1:	39 f0                	cmp    %esi,%eax
  8016c3:	77 24                	ja     8016e9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ca:	7f 33                	jg     8016ff <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	50                   	push   %eax
  8016d0:	68 00 50 80 00       	push   $0x805000
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	e8 58 f3 ff ff       	call   800a35 <memmove>
	return r;
  8016dd:	83 c4 10             	add    $0x10,%esp
}
  8016e0:	89 d8                	mov    %ebx,%eax
  8016e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    
	assert(r <= n);
  8016e9:	68 44 29 80 00       	push   $0x802944
  8016ee:	68 4b 29 80 00       	push   $0x80294b
  8016f3:	6a 7c                	push   $0x7c
  8016f5:	68 60 29 80 00       	push   $0x802960
  8016fa:	e8 e5 09 00 00       	call   8020e4 <_panic>
	assert(r <= PGSIZE);
  8016ff:	68 6b 29 80 00       	push   $0x80296b
  801704:	68 4b 29 80 00       	push   $0x80294b
  801709:	6a 7d                	push   $0x7d
  80170b:	68 60 29 80 00       	push   $0x802960
  801710:	e8 cf 09 00 00       	call   8020e4 <_panic>

00801715 <open>:
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	56                   	push   %esi
  801719:	53                   	push   %ebx
  80171a:	83 ec 1c             	sub    $0x1c,%esp
  80171d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801720:	56                   	push   %esi
  801721:	e8 48 f1 ff ff       	call   80086e <strlen>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80172e:	7f 6c                	jg     80179c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801730:	83 ec 0c             	sub    $0xc,%esp
  801733:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801736:	50                   	push   %eax
  801737:	e8 79 f8 ff ff       	call   800fb5 <fd_alloc>
  80173c:	89 c3                	mov    %eax,%ebx
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 3c                	js     801781 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	56                   	push   %esi
  801749:	68 00 50 80 00       	push   $0x805000
  80174e:	e8 54 f1 ff ff       	call   8008a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80175b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175e:	b8 01 00 00 00       	mov    $0x1,%eax
  801763:	e8 b8 fd ff ff       	call   801520 <fsipc>
  801768:	89 c3                	mov    %eax,%ebx
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 19                	js     80178a <open+0x75>
	return fd2num(fd);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	e8 12 f8 ff ff       	call   800f8e <fd2num>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 10             	add    $0x10,%esp
}
  801781:	89 d8                	mov    %ebx,%eax
  801783:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801786:	5b                   	pop    %ebx
  801787:	5e                   	pop    %esi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
		fd_close(fd, 0);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 f4             	pushl  -0xc(%ebp)
  801792:	e8 1b f9 ff ff       	call   8010b2 <fd_close>
		return r;
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	eb e5                	jmp    801781 <open+0x6c>
		return -E_BAD_PATH;
  80179c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a1:	eb de                	jmp    801781 <open+0x6c>

008017a3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b3:	e8 68 fd ff ff       	call   801520 <fsipc>
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017c0:	68 77 29 80 00       	push   $0x802977
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	e8 da f0 ff ff       	call   8008a7 <strcpy>
	return 0;
}
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <devsock_close>:
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	53                   	push   %ebx
  8017d8:	83 ec 10             	sub    $0x10,%esp
  8017db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017de:	53                   	push   %ebx
  8017df:	e8 61 0a 00 00       	call   802245 <pageref>
  8017e4:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017ec:	83 f8 01             	cmp    $0x1,%eax
  8017ef:	74 07                	je     8017f8 <devsock_close+0x24>
}
  8017f1:	89 d0                	mov    %edx,%eax
  8017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	ff 73 0c             	pushl  0xc(%ebx)
  8017fe:	e8 b9 02 00 00       	call   801abc <nsipc_close>
  801803:	89 c2                	mov    %eax,%edx
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	eb e7                	jmp    8017f1 <devsock_close+0x1d>

0080180a <devsock_write>:
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801810:	6a 00                	push   $0x0
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	ff 70 0c             	pushl  0xc(%eax)
  80181e:	e8 76 03 00 00       	call   801b99 <nsipc_send>
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <devsock_read>:
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	ff 70 0c             	pushl  0xc(%eax)
  801839:	e8 ef 02 00 00       	call   801b2d <nsipc_recv>
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <fd2sockid>:
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801846:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	e8 b7 f7 ff ff       	call   801007 <fd_lookup>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	78 10                	js     801867 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801860:	39 08                	cmp    %ecx,(%eax)
  801862:	75 05                	jne    801869 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801864:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    
		return -E_NOT_SUPP;
  801869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186e:	eb f7                	jmp    801867 <fd2sockid+0x27>

00801870 <alloc_sockfd>:
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 1c             	sub    $0x1c,%esp
  801878:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80187a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187d:	50                   	push   %eax
  80187e:	e8 32 f7 ff ff       	call   800fb5 <fd_alloc>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 43                	js     8018cf <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 07 04 00 00       	push   $0x407
  801894:	ff 75 f4             	pushl  -0xc(%ebp)
  801897:	6a 00                	push   $0x0
  801899:	e8 fb f3 ff ff       	call   800c99 <sys_page_alloc>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 28                	js     8018cf <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018aa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018b0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018bc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018bf:	83 ec 0c             	sub    $0xc,%esp
  8018c2:	50                   	push   %eax
  8018c3:	e8 c6 f6 ff ff       	call   800f8e <fd2num>
  8018c8:	89 c3                	mov    %eax,%ebx
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	eb 0c                	jmp    8018db <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018cf:	83 ec 0c             	sub    $0xc,%esp
  8018d2:	56                   	push   %esi
  8018d3:	e8 e4 01 00 00       	call   801abc <nsipc_close>
		return r;
  8018d8:	83 c4 10             	add    $0x10,%esp
}
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    

008018e4 <accept>:
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	e8 4e ff ff ff       	call   801840 <fd2sockid>
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 1b                	js     801911 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018f6:	83 ec 04             	sub    $0x4,%esp
  8018f9:	ff 75 10             	pushl  0x10(%ebp)
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	50                   	push   %eax
  801900:	e8 0e 01 00 00       	call   801a13 <nsipc_accept>
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 05                	js     801911 <accept+0x2d>
	return alloc_sockfd(r);
  80190c:	e8 5f ff ff ff       	call   801870 <alloc_sockfd>
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <bind>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	e8 1f ff ff ff       	call   801840 <fd2sockid>
  801921:	85 c0                	test   %eax,%eax
  801923:	78 12                	js     801937 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	ff 75 10             	pushl  0x10(%ebp)
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	50                   	push   %eax
  80192f:	e8 31 01 00 00       	call   801a65 <nsipc_bind>
  801934:	83 c4 10             	add    $0x10,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <shutdown>:
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	e8 f9 fe ff ff       	call   801840 <fd2sockid>
  801947:	85 c0                	test   %eax,%eax
  801949:	78 0f                	js     80195a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	50                   	push   %eax
  801952:	e8 43 01 00 00       	call   801a9a <nsipc_shutdown>
  801957:	83 c4 10             	add    $0x10,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <connect>:
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	e8 d6 fe ff ff       	call   801840 <fd2sockid>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 12                	js     801980 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	50                   	push   %eax
  801978:	e8 59 01 00 00       	call   801ad6 <nsipc_connect>
  80197d:	83 c4 10             	add    $0x10,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <listen>:
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	e8 b0 fe ff ff       	call   801840 <fd2sockid>
  801990:	85 c0                	test   %eax,%eax
  801992:	78 0f                	js     8019a3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	50                   	push   %eax
  80199b:	e8 6b 01 00 00       	call   801b0b <nsipc_listen>
  8019a0:	83 c4 10             	add    $0x10,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	e8 3e 02 00 00       	call   801bf7 <nsipc_socket>
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 05                	js     8019c5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019c0:	e8 ab fe ff ff       	call   801870 <alloc_sockfd>
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019d0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019d7:	74 26                	je     8019ff <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019d9:	6a 07                	push   $0x7
  8019db:	68 00 60 80 00       	push   $0x806000
  8019e0:	53                   	push   %ebx
  8019e1:	ff 35 04 40 80 00    	pushl  0x804004
  8019e7:	e8 c2 07 00 00       	call   8021ae <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019ec:	83 c4 0c             	add    $0xc,%esp
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	e8 4b 07 00 00       	call   802145 <ipc_recv>
}
  8019fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	6a 02                	push   $0x2
  801a04:	e8 fd 07 00 00       	call   802206 <ipc_find_env>
  801a09:	a3 04 40 80 00       	mov    %eax,0x804004
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	eb c6                	jmp    8019d9 <nsipc+0x12>

00801a13 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a23:	8b 06                	mov    (%esi),%eax
  801a25:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	e8 93 ff ff ff       	call   8019c7 <nsipc>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	85 c0                	test   %eax,%eax
  801a38:	79 09                	jns    801a43 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a3a:	89 d8                	mov    %ebx,%eax
  801a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	ff 35 10 60 80 00    	pushl  0x806010
  801a4c:	68 00 60 80 00       	push   $0x806000
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	e8 dc ef ff ff       	call   800a35 <memmove>
		*addrlen = ret->ret_addrlen;
  801a59:	a1 10 60 80 00       	mov    0x806010,%eax
  801a5e:	89 06                	mov    %eax,(%esi)
  801a60:	83 c4 10             	add    $0x10,%esp
	return r;
  801a63:	eb d5                	jmp    801a3a <nsipc_accept+0x27>

00801a65 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a77:	53                   	push   %ebx
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	68 04 60 80 00       	push   $0x806004
  801a80:	e8 b0 ef ff ff       	call   800a35 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a85:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a8b:	b8 02 00 00 00       	mov    $0x2,%eax
  801a90:	e8 32 ff ff ff       	call   8019c7 <nsipc>
}
  801a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ab0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab5:	e8 0d ff ff ff       	call   8019c7 <nsipc>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <nsipc_close>:

int
nsipc_close(int s)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801aca:	b8 04 00 00 00       	mov    $0x4,%eax
  801acf:	e8 f3 fe ff ff       	call   8019c7 <nsipc>
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ae8:	53                   	push   %ebx
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	68 04 60 80 00       	push   $0x806004
  801af1:	e8 3f ef ff ff       	call   800a35 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801afc:	b8 05 00 00 00       	mov    $0x5,%eax
  801b01:	e8 c1 fe ff ff       	call   8019c7 <nsipc>
}
  801b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b21:	b8 06 00 00 00       	mov    $0x6,%eax
  801b26:	e8 9c fe ff ff       	call   8019c7 <nsipc>
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b3d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b43:	8b 45 14             	mov    0x14(%ebp),%eax
  801b46:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b4b:	b8 07 00 00 00       	mov    $0x7,%eax
  801b50:	e8 72 fe ff ff       	call   8019c7 <nsipc>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	85 c0                	test   %eax,%eax
  801b59:	78 1f                	js     801b7a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b5b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b60:	7f 21                	jg     801b83 <nsipc_recv+0x56>
  801b62:	39 c6                	cmp    %eax,%esi
  801b64:	7c 1d                	jl     801b83 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	50                   	push   %eax
  801b6a:	68 00 60 80 00       	push   $0x806000
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 be ee ff ff       	call   800a35 <memmove>
  801b77:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b83:	68 83 29 80 00       	push   $0x802983
  801b88:	68 4b 29 80 00       	push   $0x80294b
  801b8d:	6a 62                	push   $0x62
  801b8f:	68 98 29 80 00       	push   $0x802998
  801b94:	e8 4b 05 00 00       	call   8020e4 <_panic>

00801b99 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	53                   	push   %ebx
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bab:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bb1:	7f 2e                	jg     801be1 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	53                   	push   %ebx
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	68 0c 60 80 00       	push   $0x80600c
  801bbf:	e8 71 ee ff ff       	call   800a35 <memmove>
	nsipcbuf.send.req_size = size;
  801bc4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bca:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd7:	e8 eb fd ff ff       	call   8019c7 <nsipc>
}
  801bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    
	assert(size < 1600);
  801be1:	68 a4 29 80 00       	push   $0x8029a4
  801be6:	68 4b 29 80 00       	push   $0x80294b
  801beb:	6a 6d                	push   $0x6d
  801bed:	68 98 29 80 00       	push   $0x802998
  801bf2:	e8 ed 04 00 00       	call   8020e4 <_panic>

00801bf7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c08:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c15:	b8 09 00 00 00       	mov    $0x9,%eax
  801c1a:	e8 a8 fd ff ff       	call   8019c7 <nsipc>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c29:	83 ec 0c             	sub    $0xc,%esp
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	e8 6a f3 ff ff       	call   800f9e <fd2data>
  801c34:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c36:	83 c4 08             	add    $0x8,%esp
  801c39:	68 b0 29 80 00       	push   $0x8029b0
  801c3e:	53                   	push   %ebx
  801c3f:	e8 63 ec ff ff       	call   8008a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c44:	8b 46 04             	mov    0x4(%esi),%eax
  801c47:	2b 06                	sub    (%esi),%eax
  801c49:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c4f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c56:	00 00 00 
	stat->st_dev = &devpipe;
  801c59:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c60:	30 80 00 
	return 0;
}
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c79:	53                   	push   %ebx
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 9d f0 ff ff       	call   800d1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c81:	89 1c 24             	mov    %ebx,(%esp)
  801c84:	e8 15 f3 ff ff       	call   800f9e <fd2data>
  801c89:	83 c4 08             	add    $0x8,%esp
  801c8c:	50                   	push   %eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	e8 8a f0 ff ff       	call   800d1e <sys_page_unmap>
}
  801c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <_pipeisclosed>:
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	57                   	push   %edi
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 1c             	sub    $0x1c,%esp
  801ca2:	89 c7                	mov    %eax,%edi
  801ca4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ca6:	a1 08 40 80 00       	mov    0x804008,%eax
  801cab:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	57                   	push   %edi
  801cb2:	e8 8e 05 00 00       	call   802245 <pageref>
  801cb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cba:	89 34 24             	mov    %esi,(%esp)
  801cbd:	e8 83 05 00 00       	call   802245 <pageref>
		nn = thisenv->env_runs;
  801cc2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cc8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	39 cb                	cmp    %ecx,%ebx
  801cd0:	74 1b                	je     801ced <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cd5:	75 cf                	jne    801ca6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cd7:	8b 42 58             	mov    0x58(%edx),%eax
  801cda:	6a 01                	push   $0x1
  801cdc:	50                   	push   %eax
  801cdd:	53                   	push   %ebx
  801cde:	68 b7 29 80 00       	push   $0x8029b7
  801ce3:	e8 60 e4 ff ff       	call   800148 <cprintf>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	eb b9                	jmp    801ca6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ced:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf0:	0f 94 c0             	sete   %al
  801cf3:	0f b6 c0             	movzbl %al,%eax
}
  801cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf9:	5b                   	pop    %ebx
  801cfa:	5e                   	pop    %esi
  801cfb:	5f                   	pop    %edi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <devpipe_write>:
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 28             	sub    $0x28,%esp
  801d07:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d0a:	56                   	push   %esi
  801d0b:	e8 8e f2 ff ff       	call   800f9e <fd2data>
  801d10:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d1d:	74 4f                	je     801d6e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d1f:	8b 43 04             	mov    0x4(%ebx),%eax
  801d22:	8b 0b                	mov    (%ebx),%ecx
  801d24:	8d 51 20             	lea    0x20(%ecx),%edx
  801d27:	39 d0                	cmp    %edx,%eax
  801d29:	72 14                	jb     801d3f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d2b:	89 da                	mov    %ebx,%edx
  801d2d:	89 f0                	mov    %esi,%eax
  801d2f:	e8 65 ff ff ff       	call   801c99 <_pipeisclosed>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	75 3b                	jne    801d73 <devpipe_write+0x75>
			sys_yield();
  801d38:	e8 3d ef ff ff       	call   800c7a <sys_yield>
  801d3d:	eb e0                	jmp    801d1f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d42:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d46:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d49:	89 c2                	mov    %eax,%edx
  801d4b:	c1 fa 1f             	sar    $0x1f,%edx
  801d4e:	89 d1                	mov    %edx,%ecx
  801d50:	c1 e9 1b             	shr    $0x1b,%ecx
  801d53:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d56:	83 e2 1f             	and    $0x1f,%edx
  801d59:	29 ca                	sub    %ecx,%edx
  801d5b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d5f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d63:	83 c0 01             	add    $0x1,%eax
  801d66:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d69:	83 c7 01             	add    $0x1,%edi
  801d6c:	eb ac                	jmp    801d1a <devpipe_write+0x1c>
	return i;
  801d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d71:	eb 05                	jmp    801d78 <devpipe_write+0x7a>
				return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    

00801d80 <devpipe_read>:
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	57                   	push   %edi
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	83 ec 18             	sub    $0x18,%esp
  801d89:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d8c:	57                   	push   %edi
  801d8d:	e8 0c f2 ff ff       	call   800f9e <fd2data>
  801d92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	be 00 00 00 00       	mov    $0x0,%esi
  801d9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d9f:	75 14                	jne    801db5 <devpipe_read+0x35>
	return i;
  801da1:	8b 45 10             	mov    0x10(%ebp),%eax
  801da4:	eb 02                	jmp    801da8 <devpipe_read+0x28>
				return i;
  801da6:	89 f0                	mov    %esi,%eax
}
  801da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
			sys_yield();
  801db0:	e8 c5 ee ff ff       	call   800c7a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801db5:	8b 03                	mov    (%ebx),%eax
  801db7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dba:	75 18                	jne    801dd4 <devpipe_read+0x54>
			if (i > 0)
  801dbc:	85 f6                	test   %esi,%esi
  801dbe:	75 e6                	jne    801da6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dc0:	89 da                	mov    %ebx,%edx
  801dc2:	89 f8                	mov    %edi,%eax
  801dc4:	e8 d0 fe ff ff       	call   801c99 <_pipeisclosed>
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	74 e3                	je     801db0 <devpipe_read+0x30>
				return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	eb d4                	jmp    801da8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd4:	99                   	cltd   
  801dd5:	c1 ea 1b             	shr    $0x1b,%edx
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	83 e0 1f             	and    $0x1f,%eax
  801ddd:	29 d0                	sub    %edx,%eax
  801ddf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dea:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ded:	83 c6 01             	add    $0x1,%esi
  801df0:	eb aa                	jmp    801d9c <devpipe_read+0x1c>

00801df2 <pipe>:
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	56                   	push   %esi
  801df6:	53                   	push   %ebx
  801df7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfd:	50                   	push   %eax
  801dfe:	e8 b2 f1 ff ff       	call   800fb5 <fd_alloc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	0f 88 23 01 00 00    	js     801f33 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e10:	83 ec 04             	sub    $0x4,%esp
  801e13:	68 07 04 00 00       	push   $0x407
  801e18:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1b:	6a 00                	push   $0x0
  801e1d:	e8 77 ee ff ff       	call   800c99 <sys_page_alloc>
  801e22:	89 c3                	mov    %eax,%ebx
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	85 c0                	test   %eax,%eax
  801e29:	0f 88 04 01 00 00    	js     801f33 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e2f:	83 ec 0c             	sub    $0xc,%esp
  801e32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e35:	50                   	push   %eax
  801e36:	e8 7a f1 ff ff       	call   800fb5 <fd_alloc>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	85 c0                	test   %eax,%eax
  801e42:	0f 88 db 00 00 00    	js     801f23 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 07 04 00 00       	push   $0x407
  801e50:	ff 75 f0             	pushl  -0x10(%ebp)
  801e53:	6a 00                	push   $0x0
  801e55:	e8 3f ee ff ff       	call   800c99 <sys_page_alloc>
  801e5a:	89 c3                	mov    %eax,%ebx
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	0f 88 bc 00 00 00    	js     801f23 <pipe+0x131>
	va = fd2data(fd0);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	e8 2c f1 ff ff       	call   800f9e <fd2data>
  801e72:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	83 c4 0c             	add    $0xc,%esp
  801e77:	68 07 04 00 00       	push   $0x407
  801e7c:	50                   	push   %eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	e8 15 ee ff ff       	call   800c99 <sys_page_alloc>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 88 82 00 00 00    	js     801f13 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 f0             	pushl  -0x10(%ebp)
  801e97:	e8 02 f1 ff ff       	call   800f9e <fd2data>
  801e9c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ea3:	50                   	push   %eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	56                   	push   %esi
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 2e ee ff ff       	call   800cdc <sys_page_map>
  801eae:	89 c3                	mov    %eax,%ebx
  801eb0:	83 c4 20             	add    $0x20,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 4e                	js     801f05 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eb7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebf:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ecb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ece:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee0:	e8 a9 f0 ff ff       	call   800f8e <fd2num>
  801ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801eea:	83 c4 04             	add    $0x4,%esp
  801eed:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef0:	e8 99 f0 ff ff       	call   800f8e <fd2num>
  801ef5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f03:	eb 2e                	jmp    801f33 <pipe+0x141>
	sys_page_unmap(0, va);
  801f05:	83 ec 08             	sub    $0x8,%esp
  801f08:	56                   	push   %esi
  801f09:	6a 00                	push   $0x0
  801f0b:	e8 0e ee ff ff       	call   800d1e <sys_page_unmap>
  801f10:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f13:	83 ec 08             	sub    $0x8,%esp
  801f16:	ff 75 f0             	pushl  -0x10(%ebp)
  801f19:	6a 00                	push   $0x0
  801f1b:	e8 fe ed ff ff       	call   800d1e <sys_page_unmap>
  801f20:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f23:	83 ec 08             	sub    $0x8,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 ee ed ff ff       	call   800d1e <sys_page_unmap>
  801f30:	83 c4 10             	add    $0x10,%esp
}
  801f33:	89 d8                	mov    %ebx,%eax
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <pipeisclosed>:
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f45:	50                   	push   %eax
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	e8 b9 f0 ff ff       	call   801007 <fd_lookup>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	85 c0                	test   %eax,%eax
  801f53:	78 18                	js     801f6d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5b:	e8 3e f0 ff ff       	call   800f9e <fd2data>
	return _pipeisclosed(fd, p);
  801f60:	89 c2                	mov    %eax,%edx
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	e8 2f fd ff ff       	call   801c99 <_pipeisclosed>
  801f6a:	83 c4 10             	add    $0x10,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	c3                   	ret    

00801f75 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f7b:	68 cf 29 80 00       	push   $0x8029cf
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	e8 1f e9 ff ff       	call   8008a7 <strcpy>
	return 0;
}
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <devcons_write>:
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	57                   	push   %edi
  801f93:	56                   	push   %esi
  801f94:	53                   	push   %ebx
  801f95:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f9b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fa0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fa6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa9:	73 31                	jae    801fdc <devcons_write+0x4d>
		m = n - tot;
  801fab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fae:	29 f3                	sub    %esi,%ebx
  801fb0:	83 fb 7f             	cmp    $0x7f,%ebx
  801fb3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fb8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	53                   	push   %ebx
  801fbf:	89 f0                	mov    %esi,%eax
  801fc1:	03 45 0c             	add    0xc(%ebp),%eax
  801fc4:	50                   	push   %eax
  801fc5:	57                   	push   %edi
  801fc6:	e8 6a ea ff ff       	call   800a35 <memmove>
		sys_cputs(buf, m);
  801fcb:	83 c4 08             	add    $0x8,%esp
  801fce:	53                   	push   %ebx
  801fcf:	57                   	push   %edi
  801fd0:	e8 08 ec ff ff       	call   800bdd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fd5:	01 de                	add    %ebx,%esi
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	eb ca                	jmp    801fa6 <devcons_write+0x17>
}
  801fdc:	89 f0                	mov    %esi,%eax
  801fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5f                   	pop    %edi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    

00801fe6 <devcons_read>:
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff5:	74 21                	je     802018 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ff7:	e8 ff eb ff ff       	call   800bfb <sys_cgetc>
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	75 07                	jne    802007 <devcons_read+0x21>
		sys_yield();
  802000:	e8 75 ec ff ff       	call   800c7a <sys_yield>
  802005:	eb f0                	jmp    801ff7 <devcons_read+0x11>
	if (c < 0)
  802007:	78 0f                	js     802018 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802009:	83 f8 04             	cmp    $0x4,%eax
  80200c:	74 0c                	je     80201a <devcons_read+0x34>
	*(char*)vbuf = c;
  80200e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802011:	88 02                	mov    %al,(%edx)
	return 1;
  802013:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    
		return 0;
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	eb f7                	jmp    802018 <devcons_read+0x32>

00802021 <cputchar>:
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80202d:	6a 01                	push   $0x1
  80202f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802032:	50                   	push   %eax
  802033:	e8 a5 eb ff ff       	call   800bdd <sys_cputs>
}
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <getchar>:
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802043:	6a 01                	push   $0x1
  802045:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802048:	50                   	push   %eax
  802049:	6a 00                	push   $0x0
  80204b:	e8 27 f2 ff ff       	call   801277 <read>
	if (r < 0)
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	85 c0                	test   %eax,%eax
  802055:	78 06                	js     80205d <getchar+0x20>
	if (r < 1)
  802057:	74 06                	je     80205f <getchar+0x22>
	return c;
  802059:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    
		return -E_EOF;
  80205f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802064:	eb f7                	jmp    80205d <getchar+0x20>

00802066 <iscons>:
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80206c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206f:	50                   	push   %eax
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	e8 8f ef ff ff       	call   801007 <fd_lookup>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 11                	js     802090 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802088:	39 10                	cmp    %edx,(%eax)
  80208a:	0f 94 c0             	sete   %al
  80208d:	0f b6 c0             	movzbl %al,%eax
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <opencons>:
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802098:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209b:	50                   	push   %eax
  80209c:	e8 14 ef ff ff       	call   800fb5 <fd_alloc>
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	78 3a                	js     8020e2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	68 07 04 00 00       	push   $0x407
  8020b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b3:	6a 00                	push   $0x0
  8020b5:	e8 df eb ff ff       	call   800c99 <sys_page_alloc>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 21                	js     8020e2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	50                   	push   %eax
  8020da:	e8 af ee ff ff       	call   800f8e <fd2num>
  8020df:	83 c4 10             	add    $0x10,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8020ee:	8b 40 48             	mov    0x48(%eax),%eax
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 00 2a 80 00       	push   $0x802a00
  8020f9:	50                   	push   %eax
  8020fa:	68 ea 24 80 00       	push   $0x8024ea
  8020ff:	e8 44 e0 ff ff       	call   800148 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802104:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802107:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80210d:	e8 49 eb ff ff       	call   800c5b <sys_getenvid>
  802112:	83 c4 04             	add    $0x4,%esp
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	56                   	push   %esi
  80211c:	50                   	push   %eax
  80211d:	68 dc 29 80 00       	push   $0x8029dc
  802122:	e8 21 e0 ff ff       	call   800148 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802127:	83 c4 18             	add    $0x18,%esp
  80212a:	53                   	push   %ebx
  80212b:	ff 75 10             	pushl  0x10(%ebp)
  80212e:	e8 c4 df ff ff       	call   8000f7 <vcprintf>
	cprintf("\n");
  802133:	c7 04 24 1a 2a 80 00 	movl   $0x802a1a,(%esp)
  80213a:	e8 09 e0 ff ff       	call   800148 <cprintf>
  80213f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802142:	cc                   	int3   
  802143:	eb fd                	jmp    802142 <_panic+0x5e>

00802145 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	8b 75 08             	mov    0x8(%ebp),%esi
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802153:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802155:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80215a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80215d:	83 ec 0c             	sub    $0xc,%esp
  802160:	50                   	push   %eax
  802161:	e8 e3 ec ff ff       	call   800e49 <sys_ipc_recv>
	if(ret < 0){
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 2b                	js     802198 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80216d:	85 f6                	test   %esi,%esi
  80216f:	74 0a                	je     80217b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802171:	a1 08 40 80 00       	mov    0x804008,%eax
  802176:	8b 40 78             	mov    0x78(%eax),%eax
  802179:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80217b:	85 db                	test   %ebx,%ebx
  80217d:	74 0a                	je     802189 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80217f:	a1 08 40 80 00       	mov    0x804008,%eax
  802184:	8b 40 7c             	mov    0x7c(%eax),%eax
  802187:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802189:	a1 08 40 80 00       	mov    0x804008,%eax
  80218e:	8b 40 74             	mov    0x74(%eax),%eax
}
  802191:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
		if(from_env_store)
  802198:	85 f6                	test   %esi,%esi
  80219a:	74 06                	je     8021a2 <ipc_recv+0x5d>
			*from_env_store = 0;
  80219c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021a2:	85 db                	test   %ebx,%ebx
  8021a4:	74 eb                	je     802191 <ipc_recv+0x4c>
			*perm_store = 0;
  8021a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ac:	eb e3                	jmp    802191 <ipc_recv+0x4c>

008021ae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 0c             	sub    $0xc,%esp
  8021b7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021c0:	85 db                	test   %ebx,%ebx
  8021c2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021c7:	0f 44 d8             	cmove  %eax,%ebx
  8021ca:	eb 05                	jmp    8021d1 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021cc:	e8 a9 ea ff ff       	call   800c7a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021d1:	ff 75 14             	pushl  0x14(%ebp)
  8021d4:	53                   	push   %ebx
  8021d5:	56                   	push   %esi
  8021d6:	57                   	push   %edi
  8021d7:	e8 4a ec ff ff       	call   800e26 <sys_ipc_try_send>
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	74 1b                	je     8021fe <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021e3:	79 e7                	jns    8021cc <ipc_send+0x1e>
  8021e5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021e8:	74 e2                	je     8021cc <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	68 07 2a 80 00       	push   $0x802a07
  8021f2:	6a 46                	push   $0x46
  8021f4:	68 1c 2a 80 00       	push   $0x802a1c
  8021f9:	e8 e6 fe ff ff       	call   8020e4 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8021fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    

00802206 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802211:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802217:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80221d:	8b 52 50             	mov    0x50(%edx),%edx
  802220:	39 ca                	cmp    %ecx,%edx
  802222:	74 11                	je     802235 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802224:	83 c0 01             	add    $0x1,%eax
  802227:	3d 00 04 00 00       	cmp    $0x400,%eax
  80222c:	75 e3                	jne    802211 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80222e:	b8 00 00 00 00       	mov    $0x0,%eax
  802233:	eb 0e                	jmp    802243 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802235:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80223b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802240:	8b 40 48             	mov    0x48(%eax),%eax
}
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	c1 e8 16             	shr    $0x16,%eax
  802250:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80225c:	f6 c1 01             	test   $0x1,%cl
  80225f:	74 1d                	je     80227e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802261:	c1 ea 0c             	shr    $0xc,%edx
  802264:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80226b:	f6 c2 01             	test   $0x1,%dl
  80226e:	74 0e                	je     80227e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802270:	c1 ea 0c             	shr    $0xc,%edx
  802273:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80227a:	ef 
  80227b:	0f b7 c0             	movzwl %ax,%eax
}
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    

00802280 <__udivdi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80228b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80228f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802293:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802297:	85 d2                	test   %edx,%edx
  802299:	75 4d                	jne    8022e8 <__udivdi3+0x68>
  80229b:	39 f3                	cmp    %esi,%ebx
  80229d:	76 19                	jbe    8022b8 <__udivdi3+0x38>
  80229f:	31 ff                	xor    %edi,%edi
  8022a1:	89 e8                	mov    %ebp,%eax
  8022a3:	89 f2                	mov    %esi,%edx
  8022a5:	f7 f3                	div    %ebx
  8022a7:	89 fa                	mov    %edi,%edx
  8022a9:	83 c4 1c             	add    $0x1c,%esp
  8022ac:	5b                   	pop    %ebx
  8022ad:	5e                   	pop    %esi
  8022ae:	5f                   	pop    %edi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    
  8022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	89 d9                	mov    %ebx,%ecx
  8022ba:	85 db                	test   %ebx,%ebx
  8022bc:	75 0b                	jne    8022c9 <__udivdi3+0x49>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	31 d2                	xor    %edx,%edx
  8022c5:	f7 f3                	div    %ebx
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	31 d2                	xor    %edx,%edx
  8022cb:	89 f0                	mov    %esi,%eax
  8022cd:	f7 f1                	div    %ecx
  8022cf:	89 c6                	mov    %eax,%esi
  8022d1:	89 e8                	mov    %ebp,%eax
  8022d3:	89 f7                	mov    %esi,%edi
  8022d5:	f7 f1                	div    %ecx
  8022d7:	89 fa                	mov    %edi,%edx
  8022d9:	83 c4 1c             	add    $0x1c,%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5f                   	pop    %edi
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	39 f2                	cmp    %esi,%edx
  8022ea:	77 1c                	ja     802308 <__udivdi3+0x88>
  8022ec:	0f bd fa             	bsr    %edx,%edi
  8022ef:	83 f7 1f             	xor    $0x1f,%edi
  8022f2:	75 2c                	jne    802320 <__udivdi3+0xa0>
  8022f4:	39 f2                	cmp    %esi,%edx
  8022f6:	72 06                	jb     8022fe <__udivdi3+0x7e>
  8022f8:	31 c0                	xor    %eax,%eax
  8022fa:	39 eb                	cmp    %ebp,%ebx
  8022fc:	77 a9                	ja     8022a7 <__udivdi3+0x27>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	eb a2                	jmp    8022a7 <__udivdi3+0x27>
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	31 ff                	xor    %edi,%edi
  80230a:	31 c0                	xor    %eax,%eax
  80230c:	89 fa                	mov    %edi,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 f9                	mov    %edi,%ecx
  802322:	b8 20 00 00 00       	mov    $0x20,%eax
  802327:	29 f8                	sub    %edi,%eax
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	89 da                	mov    %ebx,%edx
  802333:	d3 ea                	shr    %cl,%edx
  802335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802339:	09 d1                	or     %edx,%ecx
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 f9                	mov    %edi,%ecx
  802343:	d3 e3                	shl    %cl,%ebx
  802345:	89 c1                	mov    %eax,%ecx
  802347:	d3 ea                	shr    %cl,%edx
  802349:	89 f9                	mov    %edi,%ecx
  80234b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80234f:	89 eb                	mov    %ebp,%ebx
  802351:	d3 e6                	shl    %cl,%esi
  802353:	89 c1                	mov    %eax,%ecx
  802355:	d3 eb                	shr    %cl,%ebx
  802357:	09 de                	or     %ebx,%esi
  802359:	89 f0                	mov    %esi,%eax
  80235b:	f7 74 24 08          	divl   0x8(%esp)
  80235f:	89 d6                	mov    %edx,%esi
  802361:	89 c3                	mov    %eax,%ebx
  802363:	f7 64 24 0c          	mull   0xc(%esp)
  802367:	39 d6                	cmp    %edx,%esi
  802369:	72 15                	jb     802380 <__udivdi3+0x100>
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e5                	shl    %cl,%ebp
  80236f:	39 c5                	cmp    %eax,%ebp
  802371:	73 04                	jae    802377 <__udivdi3+0xf7>
  802373:	39 d6                	cmp    %edx,%esi
  802375:	74 09                	je     802380 <__udivdi3+0x100>
  802377:	89 d8                	mov    %ebx,%eax
  802379:	31 ff                	xor    %edi,%edi
  80237b:	e9 27 ff ff ff       	jmp    8022a7 <__udivdi3+0x27>
  802380:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802383:	31 ff                	xor    %edi,%edi
  802385:	e9 1d ff ff ff       	jmp    8022a7 <__udivdi3+0x27>
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <__umoddi3>:
  802390:	55                   	push   %ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 1c             	sub    $0x1c,%esp
  802397:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80239b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80239f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023a7:	89 da                	mov    %ebx,%edx
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	75 43                	jne    8023f0 <__umoddi3+0x60>
  8023ad:	39 df                	cmp    %ebx,%edi
  8023af:	76 17                	jbe    8023c8 <__umoddi3+0x38>
  8023b1:	89 f0                	mov    %esi,%eax
  8023b3:	f7 f7                	div    %edi
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	31 d2                	xor    %edx,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 fd                	mov    %edi,%ebp
  8023ca:	85 ff                	test   %edi,%edi
  8023cc:	75 0b                	jne    8023d9 <__umoddi3+0x49>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f7                	div    %edi
  8023d7:	89 c5                	mov    %eax,%ebp
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f5                	div    %ebp
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	f7 f5                	div    %ebp
  8023e3:	89 d0                	mov    %edx,%eax
  8023e5:	eb d0                	jmp    8023b7 <__umoddi3+0x27>
  8023e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	89 f1                	mov    %esi,%ecx
  8023f2:	39 d8                	cmp    %ebx,%eax
  8023f4:	76 0a                	jbe    802400 <__umoddi3+0x70>
  8023f6:	89 f0                	mov    %esi,%eax
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	75 20                	jne    802428 <__umoddi3+0x98>
  802408:	39 d8                	cmp    %ebx,%eax
  80240a:	0f 82 b0 00 00 00    	jb     8024c0 <__umoddi3+0x130>
  802410:	39 f7                	cmp    %esi,%edi
  802412:	0f 86 a8 00 00 00    	jbe    8024c0 <__umoddi3+0x130>
  802418:	89 c8                	mov    %ecx,%eax
  80241a:	83 c4 1c             	add    $0x1c,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5f                   	pop    %edi
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    
  802422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802428:	89 e9                	mov    %ebp,%ecx
  80242a:	ba 20 00 00 00       	mov    $0x20,%edx
  80242f:	29 ea                	sub    %ebp,%edx
  802431:	d3 e0                	shl    %cl,%eax
  802433:	89 44 24 08          	mov    %eax,0x8(%esp)
  802437:	89 d1                	mov    %edx,%ecx
  802439:	89 f8                	mov    %edi,%eax
  80243b:	d3 e8                	shr    %cl,%eax
  80243d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802441:	89 54 24 04          	mov    %edx,0x4(%esp)
  802445:	8b 54 24 04          	mov    0x4(%esp),%edx
  802449:	09 c1                	or     %eax,%ecx
  80244b:	89 d8                	mov    %ebx,%eax
  80244d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802451:	89 e9                	mov    %ebp,%ecx
  802453:	d3 e7                	shl    %cl,%edi
  802455:	89 d1                	mov    %edx,%ecx
  802457:	d3 e8                	shr    %cl,%eax
  802459:	89 e9                	mov    %ebp,%ecx
  80245b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80245f:	d3 e3                	shl    %cl,%ebx
  802461:	89 c7                	mov    %eax,%edi
  802463:	89 d1                	mov    %edx,%ecx
  802465:	89 f0                	mov    %esi,%eax
  802467:	d3 e8                	shr    %cl,%eax
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	89 fa                	mov    %edi,%edx
  80246d:	d3 e6                	shl    %cl,%esi
  80246f:	09 d8                	or     %ebx,%eax
  802471:	f7 74 24 08          	divl   0x8(%esp)
  802475:	89 d1                	mov    %edx,%ecx
  802477:	89 f3                	mov    %esi,%ebx
  802479:	f7 64 24 0c          	mull   0xc(%esp)
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	89 d7                	mov    %edx,%edi
  802481:	39 d1                	cmp    %edx,%ecx
  802483:	72 06                	jb     80248b <__umoddi3+0xfb>
  802485:	75 10                	jne    802497 <__umoddi3+0x107>
  802487:	39 c3                	cmp    %eax,%ebx
  802489:	73 0c                	jae    802497 <__umoddi3+0x107>
  80248b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80248f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802493:	89 d7                	mov    %edx,%edi
  802495:	89 c6                	mov    %eax,%esi
  802497:	89 ca                	mov    %ecx,%edx
  802499:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80249e:	29 f3                	sub    %esi,%ebx
  8024a0:	19 fa                	sbb    %edi,%edx
  8024a2:	89 d0                	mov    %edx,%eax
  8024a4:	d3 e0                	shl    %cl,%eax
  8024a6:	89 e9                	mov    %ebp,%ecx
  8024a8:	d3 eb                	shr    %cl,%ebx
  8024aa:	d3 ea                	shr    %cl,%edx
  8024ac:	09 d8                	or     %ebx,%eax
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	89 da                	mov    %ebx,%edx
  8024c2:	29 fe                	sub    %edi,%esi
  8024c4:	19 c2                	sbb    %eax,%edx
  8024c6:	89 f1                	mov    %esi,%ecx
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	e9 4b ff ff ff       	jmp    80241a <__umoddi3+0x8a>
