
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
  800043:	68 40 25 80 00       	push   $0x802540
  800048:	e8 5f 01 00 00       	call   8001ac <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 84 0c 00 00       	call   800cde <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 60 25 80 00       	push   $0x802560
  80006c:	e8 3b 01 00 00       	call   8001ac <cprintf>
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
  800088:	68 8c 25 80 00       	push   $0x80258c
  80008d:	e8 1a 01 00 00       	call   8001ac <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000a5:	e8 15 0c 00 00       	call   800cbf <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ba:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	85 db                	test   %ebx,%ebx
  8000c1:	7e 07                	jle    8000ca <libmain+0x30>
		binaryname = argv[0];
  8000c3:	8b 06                	mov    (%esi),%eax
  8000c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	e8 5f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0a 00 00 00       	call   8000e3 <exit>
}
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ee:	8b 40 48             	mov    0x48(%eax),%eax
  8000f1:	68 c0 25 80 00       	push   $0x8025c0
  8000f6:	50                   	push   %eax
  8000f7:	68 b5 25 80 00       	push   $0x8025b5
  8000fc:	e8 ab 00 00 00       	call   8001ac <cprintf>
	close_all();
  800101:	e8 c4 10 00 00       	call   8011ca <close_all>
	sys_env_destroy(0);
  800106:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010d:	e8 6c 0b 00 00       	call   800c7e <sys_env_destroy>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	c9                   	leave  
  800116:	c3                   	ret    

00800117 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	53                   	push   %ebx
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800121:	8b 13                	mov    (%ebx),%edx
  800123:	8d 42 01             	lea    0x1(%edx),%eax
  800126:	89 03                	mov    %eax,(%ebx)
  800128:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800134:	74 09                	je     80013f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800136:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	68 ff 00 00 00       	push   $0xff
  800147:	8d 43 08             	lea    0x8(%ebx),%eax
  80014a:	50                   	push   %eax
  80014b:	e8 f1 0a 00 00       	call   800c41 <sys_cputs>
		b->idx = 0;
  800150:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb db                	jmp    800136 <putch+0x1f>

0080015b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800164:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016b:	00 00 00 
	b.cnt = 0;
  80016e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800175:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	68 17 01 80 00       	push   $0x800117
  80018a:	e8 4a 01 00 00       	call   8002d9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800198:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 9d 0a 00 00       	call   800c41 <sys_cputs>

	return b.cnt;
}
  8001a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b5:	50                   	push   %eax
  8001b6:	ff 75 08             	pushl  0x8(%ebp)
  8001b9:	e8 9d ff ff ff       	call   80015b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 1c             	sub    $0x1c,%esp
  8001c9:	89 c6                	mov    %eax,%esi
  8001cb:	89 d7                	mov    %edx,%edi
  8001cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001df:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e3:	74 2c                	je     800211 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001fa:	73 43                	jae    80023f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	85 db                	test   %ebx,%ebx
  800201:	7e 6c                	jle    80026f <printnum+0xaf>
				putch(padc, putdat);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	57                   	push   %edi
  800207:	ff 75 18             	pushl  0x18(%ebp)
  80020a:	ff d6                	call   *%esi
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	eb eb                	jmp    8001fc <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	6a 20                	push   $0x20
  800216:	6a 00                	push   $0x0
  800218:	50                   	push   %eax
  800219:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021c:	ff 75 e0             	pushl  -0x20(%ebp)
  80021f:	89 fa                	mov    %edi,%edx
  800221:	89 f0                	mov    %esi,%eax
  800223:	e8 98 ff ff ff       	call   8001c0 <printnum>
		while (--width > 0)
  800228:	83 c4 20             	add    $0x20,%esp
  80022b:	83 eb 01             	sub    $0x1,%ebx
  80022e:	85 db                	test   %ebx,%ebx
  800230:	7e 65                	jle    800297 <printnum+0xd7>
			putch(padc, putdat);
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	57                   	push   %edi
  800236:	6a 20                	push   $0x20
  800238:	ff d6                	call   *%esi
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb ec                	jmp    80022b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	ff 75 18             	pushl  0x18(%ebp)
  800245:	83 eb 01             	sub    $0x1,%ebx
  800248:	53                   	push   %ebx
  800249:	50                   	push   %eax
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	ff 75 e4             	pushl  -0x1c(%ebp)
  800256:	ff 75 e0             	pushl  -0x20(%ebp)
  800259:	e8 92 20 00 00       	call   8022f0 <__udivdi3>
  80025e:	83 c4 18             	add    $0x18,%esp
  800261:	52                   	push   %edx
  800262:	50                   	push   %eax
  800263:	89 fa                	mov    %edi,%edx
  800265:	89 f0                	mov    %esi,%eax
  800267:	e8 54 ff ff ff       	call   8001c0 <printnum>
  80026c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	57                   	push   %edi
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	ff 75 d8             	pushl  -0x28(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 e0             	pushl  -0x20(%ebp)
  800282:	e8 79 21 00 00       	call   802400 <__umoddi3>
  800287:	83 c4 14             	add    $0x14,%esp
  80028a:	0f be 80 c5 25 80 00 	movsbl 0x8025c5(%eax),%eax
  800291:	50                   	push   %eax
  800292:	ff d6                	call   *%esi
  800294:	83 c4 10             	add    $0x10,%esp
	}
}
  800297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a9:	8b 10                	mov    (%eax),%edx
  8002ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ae:	73 0a                	jae    8002ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b3:	89 08                	mov    %ecx,(%eax)
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	88 02                	mov    %al,(%edx)
}
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <printfmt>:
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c5:	50                   	push   %eax
  8002c6:	ff 75 10             	pushl  0x10(%ebp)
  8002c9:	ff 75 0c             	pushl  0xc(%ebp)
  8002cc:	ff 75 08             	pushl  0x8(%ebp)
  8002cf:	e8 05 00 00 00       	call   8002d9 <vprintfmt>
}
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <vprintfmt>:
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	57                   	push   %edi
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	83 ec 3c             	sub    $0x3c,%esp
  8002e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002eb:	e9 32 04 00 00       	jmp    800722 <vprintfmt+0x449>
		padc = ' ';
  8002f0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002f4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002fb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800302:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800309:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800310:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031c:	8d 47 01             	lea    0x1(%edi),%eax
  80031f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800322:	0f b6 17             	movzbl (%edi),%edx
  800325:	8d 42 dd             	lea    -0x23(%edx),%eax
  800328:	3c 55                	cmp    $0x55,%al
  80032a:	0f 87 12 05 00 00    	ja     800842 <vprintfmt+0x569>
  800330:	0f b6 c0             	movzbl %al,%eax
  800333:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800341:	eb d9                	jmp    80031c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800346:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80034a:	eb d0                	jmp    80031c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	0f b6 d2             	movzbl %dl,%edx
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	89 75 08             	mov    %esi,0x8(%ebp)
  80035a:	eb 03                	jmp    80035f <vprintfmt+0x86>
  80035c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800362:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800366:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800369:	8d 72 d0             	lea    -0x30(%edx),%esi
  80036c:	83 fe 09             	cmp    $0x9,%esi
  80036f:	76 eb                	jbe    80035c <vprintfmt+0x83>
  800371:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800374:	8b 75 08             	mov    0x8(%ebp),%esi
  800377:	eb 14                	jmp    80038d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800379:	8b 45 14             	mov    0x14(%ebp),%eax
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800381:	8b 45 14             	mov    0x14(%ebp),%eax
  800384:	8d 40 04             	lea    0x4(%eax),%eax
  800387:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800391:	79 89                	jns    80031c <vprintfmt+0x43>
				width = precision, precision = -1;
  800393:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800396:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800399:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a0:	e9 77 ff ff ff       	jmp    80031c <vprintfmt+0x43>
  8003a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	0f 48 c1             	cmovs  %ecx,%eax
  8003ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 64 ff ff ff       	jmp    80031c <vprintfmt+0x43>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c2:	e9 55 ff ff ff       	jmp    80031c <vprintfmt+0x43>
			lflag++;
  8003c7:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ce:	e9 49 ff ff ff       	jmp    80031c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	8d 78 04             	lea    0x4(%eax),%edi
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	53                   	push   %ebx
  8003dd:	ff 30                	pushl  (%eax)
  8003df:	ff d6                	call   *%esi
			break;
  8003e1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e7:	e9 33 03 00 00       	jmp    80071f <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	8d 78 04             	lea    0x4(%eax),%edi
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	99                   	cltd   
  8003f5:	31 d0                	xor    %edx,%eax
  8003f7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f9:	83 f8 11             	cmp    $0x11,%eax
  8003fc:	7f 23                	jg     800421 <vprintfmt+0x148>
  8003fe:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800405:	85 d2                	test   %edx,%edx
  800407:	74 18                	je     800421 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800409:	52                   	push   %edx
  80040a:	68 1d 2a 80 00       	push   $0x802a1d
  80040f:	53                   	push   %ebx
  800410:	56                   	push   %esi
  800411:	e8 a6 fe ff ff       	call   8002bc <printfmt>
  800416:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800419:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041c:	e9 fe 02 00 00       	jmp    80071f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800421:	50                   	push   %eax
  800422:	68 dd 25 80 00       	push   $0x8025dd
  800427:	53                   	push   %ebx
  800428:	56                   	push   %esi
  800429:	e8 8e fe ff ff       	call   8002bc <printfmt>
  80042e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800431:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800434:	e9 e6 02 00 00       	jmp    80071f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	83 c0 04             	add    $0x4,%eax
  80043f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800447:	85 c9                	test   %ecx,%ecx
  800449:	b8 d6 25 80 00       	mov    $0x8025d6,%eax
  80044e:	0f 45 c1             	cmovne %ecx,%eax
  800451:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800458:	7e 06                	jle    800460 <vprintfmt+0x187>
  80045a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80045e:	75 0d                	jne    80046d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800460:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800463:	89 c7                	mov    %eax,%edi
  800465:	03 45 e0             	add    -0x20(%ebp),%eax
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046b:	eb 53                	jmp    8004c0 <vprintfmt+0x1e7>
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d8             	pushl  -0x28(%ebp)
  800473:	50                   	push   %eax
  800474:	e8 71 04 00 00       	call   8008ea <strnlen>
  800479:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047c:	29 c1                	sub    %eax,%ecx
  80047e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800486:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	eb 0f                	jmp    80049e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	53                   	push   %ebx
  800493:	ff 75 e0             	pushl  -0x20(%ebp)
  800496:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800498:	83 ef 01             	sub    $0x1,%edi
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	85 ff                	test   %edi,%edi
  8004a0:	7f ed                	jg     80048f <vprintfmt+0x1b6>
  8004a2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004a5:	85 c9                	test   %ecx,%ecx
  8004a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ac:	0f 49 c1             	cmovns %ecx,%eax
  8004af:	29 c1                	sub    %eax,%ecx
  8004b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b4:	eb aa                	jmp    800460 <vprintfmt+0x187>
					putch(ch, putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	52                   	push   %edx
  8004bb:	ff d6                	call   *%esi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c5:	83 c7 01             	add    $0x1,%edi
  8004c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004cc:	0f be d0             	movsbl %al,%edx
  8004cf:	85 d2                	test   %edx,%edx
  8004d1:	74 4b                	je     80051e <vprintfmt+0x245>
  8004d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d7:	78 06                	js     8004df <vprintfmt+0x206>
  8004d9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004dd:	78 1e                	js     8004fd <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004df:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e3:	74 d1                	je     8004b6 <vprintfmt+0x1dd>
  8004e5:	0f be c0             	movsbl %al,%eax
  8004e8:	83 e8 20             	sub    $0x20,%eax
  8004eb:	83 f8 5e             	cmp    $0x5e,%eax
  8004ee:	76 c6                	jbe    8004b6 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	53                   	push   %ebx
  8004f4:	6a 3f                	push   $0x3f
  8004f6:	ff d6                	call   *%esi
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	eb c3                	jmp    8004c0 <vprintfmt+0x1e7>
  8004fd:	89 cf                	mov    %ecx,%edi
  8004ff:	eb 0e                	jmp    80050f <vprintfmt+0x236>
				putch(' ', putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	6a 20                	push   $0x20
  800507:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800509:	83 ef 01             	sub    $0x1,%edi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	85 ff                	test   %edi,%edi
  800511:	7f ee                	jg     800501 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800513:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800516:	89 45 14             	mov    %eax,0x14(%ebp)
  800519:	e9 01 02 00 00       	jmp    80071f <vprintfmt+0x446>
  80051e:	89 cf                	mov    %ecx,%edi
  800520:	eb ed                	jmp    80050f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800525:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80052c:	e9 eb fd ff ff       	jmp    80031c <vprintfmt+0x43>
	if (lflag >= 2)
  800531:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800535:	7f 21                	jg     800558 <vprintfmt+0x27f>
	else if (lflag)
  800537:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80053b:	74 68                	je     8005a5 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800545:	89 c1                	mov    %eax,%ecx
  800547:	c1 f9 1f             	sar    $0x1f,%ecx
  80054a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 40 04             	lea    0x4(%eax),%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	eb 17                	jmp    80056f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 50 04             	mov    0x4(%eax),%edx
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800563:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 08             	lea    0x8(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80056f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800572:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80057b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80057f:	78 3f                	js     8005c0 <vprintfmt+0x2e7>
			base = 10;
  800581:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800586:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80058a:	0f 84 71 01 00 00    	je     800701 <vprintfmt+0x428>
				putch('+', putdat);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	53                   	push   %ebx
  800594:	6a 2b                	push   $0x2b
  800596:	ff d6                	call   *%esi
  800598:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a0:	e9 5c 01 00 00       	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ad:	89 c1                	mov    %eax,%ecx
  8005af:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005be:	eb af                	jmp    80056f <vprintfmt+0x296>
				putch('-', putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	6a 2d                	push   $0x2d
  8005c6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ce:	f7 d8                	neg    %eax
  8005d0:	83 d2 00             	adc    $0x0,%edx
  8005d3:	f7 da                	neg    %edx
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	e9 19 01 00 00       	jmp    800701 <vprintfmt+0x428>
	if (lflag >= 2)
  8005e8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ec:	7f 29                	jg     800617 <vprintfmt+0x33e>
	else if (lflag)
  8005ee:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f2:	74 44                	je     800638 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 ea 00 00 00       	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 50 04             	mov    0x4(%eax),%edx
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 40 08             	lea    0x8(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	e9 c9 00 00 00       	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
  800656:	e9 a6 00 00 00       	jmp    800701 <vprintfmt+0x428>
			putch('0', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 30                	push   $0x30
  800661:	ff d6                	call   *%esi
	if (lflag >= 2)
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066a:	7f 26                	jg     800692 <vprintfmt+0x3b9>
	else if (lflag)
  80066c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800670:	74 3e                	je     8006b0 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068b:	b8 08 00 00 00       	mov    $0x8,%eax
  800690:	eb 6f                	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 50 04             	mov    0x4(%eax),%edx
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 08             	lea    0x8(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ae:	eb 51                	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 04             	lea    0x4(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ce:	eb 31                	jmp    800701 <vprintfmt+0x428>
			putch('0', putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	6a 30                	push   $0x30
  8006d6:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d8:	83 c4 08             	add    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	6a 78                	push   $0x78
  8006de:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800701:	83 ec 0c             	sub    $0xc,%esp
  800704:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800708:	52                   	push   %edx
  800709:	ff 75 e0             	pushl  -0x20(%ebp)
  80070c:	50                   	push   %eax
  80070d:	ff 75 dc             	pushl  -0x24(%ebp)
  800710:	ff 75 d8             	pushl  -0x28(%ebp)
  800713:	89 da                	mov    %ebx,%edx
  800715:	89 f0                	mov    %esi,%eax
  800717:	e8 a4 fa ff ff       	call   8001c0 <printnum>
			break;
  80071c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80071f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800722:	83 c7 01             	add    $0x1,%edi
  800725:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800729:	83 f8 25             	cmp    $0x25,%eax
  80072c:	0f 84 be fb ff ff    	je     8002f0 <vprintfmt+0x17>
			if (ch == '\0')
  800732:	85 c0                	test   %eax,%eax
  800734:	0f 84 28 01 00 00    	je     800862 <vprintfmt+0x589>
			putch(ch, putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	50                   	push   %eax
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb dc                	jmp    800722 <vprintfmt+0x449>
	if (lflag >= 2)
  800746:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074a:	7f 26                	jg     800772 <vprintfmt+0x499>
	else if (lflag)
  80074c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800750:	74 41                	je     800793 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
  80075c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8d 40 04             	lea    0x4(%eax),%eax
  800768:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076b:	b8 10 00 00 00       	mov    $0x10,%eax
  800770:	eb 8f                	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 50 04             	mov    0x4(%eax),%edx
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 08             	lea    0x8(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800789:	b8 10 00 00 00       	mov    $0x10,%eax
  80078e:	e9 6e ff ff ff       	jmp    800701 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ac:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b1:	e9 4b ff ff ff       	jmp    800701 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	83 c0 04             	add    $0x4,%eax
  8007bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	74 14                	je     8007dc <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007c8:	8b 13                	mov    (%ebx),%edx
  8007ca:	83 fa 7f             	cmp    $0x7f,%edx
  8007cd:	7f 37                	jg     800806 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007cf:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	e9 43 ff ff ff       	jmp    80071f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e1:	bf f9 26 80 00       	mov    $0x8026f9,%edi
							putch(ch, putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	50                   	push   %eax
  8007eb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007ed:	83 c7 01             	add    $0x1,%edi
  8007f0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	75 eb                	jne    8007e6 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	e9 19 ff ff ff       	jmp    80071f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800806:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	bf 31 27 80 00       	mov    $0x802731,%edi
							putch(ch, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	53                   	push   %ebx
  800816:	50                   	push   %eax
  800817:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800819:	83 c7 01             	add    $0x1,%edi
  80081c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	85 c0                	test   %eax,%eax
  800825:	75 eb                	jne    800812 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800827:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	e9 ed fe ff ff       	jmp    80071f <vprintfmt+0x446>
			putch(ch, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 25                	push   $0x25
  800838:	ff d6                	call   *%esi
			break;
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	e9 dd fe ff ff       	jmp    80071f <vprintfmt+0x446>
			putch('%', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 25                	push   $0x25
  800848:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	89 f8                	mov    %edi,%eax
  80084f:	eb 03                	jmp    800854 <vprintfmt+0x57b>
  800851:	83 e8 01             	sub    $0x1,%eax
  800854:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800858:	75 f7                	jne    800851 <vprintfmt+0x578>
  80085a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085d:	e9 bd fe ff ff       	jmp    80071f <vprintfmt+0x446>
}
  800862:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800865:	5b                   	pop    %ebx
  800866:	5e                   	pop    %esi
  800867:	5f                   	pop    %edi
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800876:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800879:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800887:	85 c0                	test   %eax,%eax
  800889:	74 26                	je     8008b1 <vsnprintf+0x47>
  80088b:	85 d2                	test   %edx,%edx
  80088d:	7e 22                	jle    8008b1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088f:	ff 75 14             	pushl  0x14(%ebp)
  800892:	ff 75 10             	pushl  0x10(%ebp)
  800895:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800898:	50                   	push   %eax
  800899:	68 9f 02 80 00       	push   $0x80029f
  80089e:	e8 36 fa ff ff       	call   8002d9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    
		return -E_INVAL;
  8008b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b6:	eb f7                	jmp    8008af <vsnprintf+0x45>

008008b8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008be:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c1:	50                   	push   %eax
  8008c2:	ff 75 10             	pushl  0x10(%ebp)
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	ff 75 08             	pushl  0x8(%ebp)
  8008cb:	e8 9a ff ff ff       	call   80086a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e1:	74 05                	je     8008e8 <strlen+0x16>
		n++;
  8008e3:	83 c0 01             	add    $0x1,%eax
  8008e6:	eb f5                	jmp    8008dd <strlen+0xb>
	return n;
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	39 c2                	cmp    %eax,%edx
  8008fa:	74 0d                	je     800909 <strnlen+0x1f>
  8008fc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800900:	74 05                	je     800907 <strnlen+0x1d>
		n++;
  800902:	83 c2 01             	add    $0x1,%edx
  800905:	eb f1                	jmp    8008f8 <strnlen+0xe>
  800907:	89 d0                	mov    %edx,%eax
	return n;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800915:	ba 00 00 00 00       	mov    $0x0,%edx
  80091a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800921:	83 c2 01             	add    $0x1,%edx
  800924:	84 c9                	test   %cl,%cl
  800926:	75 f2                	jne    80091a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800928:	5b                   	pop    %ebx
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	83 ec 10             	sub    $0x10,%esp
  800932:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800935:	53                   	push   %ebx
  800936:	e8 97 ff ff ff       	call   8008d2 <strlen>
  80093b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	01 d8                	add    %ebx,%eax
  800943:	50                   	push   %eax
  800944:	e8 c2 ff ff ff       	call   80090b <strcpy>
	return dst;
}
  800949:	89 d8                	mov    %ebx,%eax
  80094b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	56                   	push   %esi
  800954:	53                   	push   %ebx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095b:	89 c6                	mov    %eax,%esi
  80095d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800960:	89 c2                	mov    %eax,%edx
  800962:	39 f2                	cmp    %esi,%edx
  800964:	74 11                	je     800977 <strncpy+0x27>
		*dst++ = *src;
  800966:	83 c2 01             	add    $0x1,%edx
  800969:	0f b6 19             	movzbl (%ecx),%ebx
  80096c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80096f:	80 fb 01             	cmp    $0x1,%bl
  800972:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800975:	eb eb                	jmp    800962 <strncpy+0x12>
	}
	return ret;
}
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	56                   	push   %esi
  80097f:	53                   	push   %ebx
  800980:	8b 75 08             	mov    0x8(%ebp),%esi
  800983:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800986:	8b 55 10             	mov    0x10(%ebp),%edx
  800989:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098b:	85 d2                	test   %edx,%edx
  80098d:	74 21                	je     8009b0 <strlcpy+0x35>
  80098f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800993:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800995:	39 c2                	cmp    %eax,%edx
  800997:	74 14                	je     8009ad <strlcpy+0x32>
  800999:	0f b6 19             	movzbl (%ecx),%ebx
  80099c:	84 db                	test   %bl,%bl
  80099e:	74 0b                	je     8009ab <strlcpy+0x30>
			*dst++ = *src++;
  8009a0:	83 c1 01             	add    $0x1,%ecx
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a9:	eb ea                	jmp    800995 <strlcpy+0x1a>
  8009ab:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ad:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b0:	29 f0                	sub    %esi,%eax
}
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009bf:	0f b6 01             	movzbl (%ecx),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 0c                	je     8009d2 <strcmp+0x1c>
  8009c6:	3a 02                	cmp    (%edx),%al
  8009c8:	75 08                	jne    8009d2 <strcmp+0x1c>
		p++, q++;
  8009ca:	83 c1 01             	add    $0x1,%ecx
  8009cd:	83 c2 01             	add    $0x1,%edx
  8009d0:	eb ed                	jmp    8009bf <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d2:	0f b6 c0             	movzbl %al,%eax
  8009d5:	0f b6 12             	movzbl (%edx),%edx
  8009d8:	29 d0                	sub    %edx,%eax
}
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	53                   	push   %ebx
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	89 c3                	mov    %eax,%ebx
  8009e8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009eb:	eb 06                	jmp    8009f3 <strncmp+0x17>
		n--, p++, q++;
  8009ed:	83 c0 01             	add    $0x1,%eax
  8009f0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f3:	39 d8                	cmp    %ebx,%eax
  8009f5:	74 16                	je     800a0d <strncmp+0x31>
  8009f7:	0f b6 08             	movzbl (%eax),%ecx
  8009fa:	84 c9                	test   %cl,%cl
  8009fc:	74 04                	je     800a02 <strncmp+0x26>
  8009fe:	3a 0a                	cmp    (%edx),%cl
  800a00:	74 eb                	je     8009ed <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a02:	0f b6 00             	movzbl (%eax),%eax
  800a05:	0f b6 12             	movzbl (%edx),%edx
  800a08:	29 d0                	sub    %edx,%eax
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    
		return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	eb f6                	jmp    800a0a <strncmp+0x2e>

00800a14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1e:	0f b6 10             	movzbl (%eax),%edx
  800a21:	84 d2                	test   %dl,%dl
  800a23:	74 09                	je     800a2e <strchr+0x1a>
		if (*s == c)
  800a25:	38 ca                	cmp    %cl,%dl
  800a27:	74 0a                	je     800a33 <strchr+0x1f>
	for (; *s; s++)
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	eb f0                	jmp    800a1e <strchr+0xa>
			return (char *) s;
	return 0;
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a42:	38 ca                	cmp    %cl,%dl
  800a44:	74 09                	je     800a4f <strfind+0x1a>
  800a46:	84 d2                	test   %dl,%dl
  800a48:	74 05                	je     800a4f <strfind+0x1a>
	for (; *s; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	eb f0                	jmp    800a3f <strfind+0xa>
			break;
	return (char *) s;
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	57                   	push   %edi
  800a55:	56                   	push   %esi
  800a56:	53                   	push   %ebx
  800a57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5d:	85 c9                	test   %ecx,%ecx
  800a5f:	74 31                	je     800a92 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a61:	89 f8                	mov    %edi,%eax
  800a63:	09 c8                	or     %ecx,%eax
  800a65:	a8 03                	test   $0x3,%al
  800a67:	75 23                	jne    800a8c <memset+0x3b>
		c &= 0xFF;
  800a69:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6d:	89 d3                	mov    %edx,%ebx
  800a6f:	c1 e3 08             	shl    $0x8,%ebx
  800a72:	89 d0                	mov    %edx,%eax
  800a74:	c1 e0 18             	shl    $0x18,%eax
  800a77:	89 d6                	mov    %edx,%esi
  800a79:	c1 e6 10             	shl    $0x10,%esi
  800a7c:	09 f0                	or     %esi,%eax
  800a7e:	09 c2                	or     %eax,%edx
  800a80:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a82:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a85:	89 d0                	mov    %edx,%eax
  800a87:	fc                   	cld    
  800a88:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8a:	eb 06                	jmp    800a92 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	fc                   	cld    
  800a90:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a92:	89 f8                	mov    %edi,%eax
  800a94:	5b                   	pop    %ebx
  800a95:	5e                   	pop    %esi
  800a96:	5f                   	pop    %edi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	57                   	push   %edi
  800a9d:	56                   	push   %esi
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa7:	39 c6                	cmp    %eax,%esi
  800aa9:	73 32                	jae    800add <memmove+0x44>
  800aab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aae:	39 c2                	cmp    %eax,%edx
  800ab0:	76 2b                	jbe    800add <memmove+0x44>
		s += n;
		d += n;
  800ab2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 fe                	mov    %edi,%esi
  800ab7:	09 ce                	or     %ecx,%esi
  800ab9:	09 d6                	or     %edx,%esi
  800abb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac1:	75 0e                	jne    800ad1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac3:	83 ef 04             	sub    $0x4,%edi
  800ac6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acc:	fd                   	std    
  800acd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acf:	eb 09                	jmp    800ada <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad1:	83 ef 01             	sub    $0x1,%edi
  800ad4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad7:	fd                   	std    
  800ad8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ada:	fc                   	cld    
  800adb:	eb 1a                	jmp    800af7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800add:	89 c2                	mov    %eax,%edx
  800adf:	09 ca                	or     %ecx,%edx
  800ae1:	09 f2                	or     %esi,%edx
  800ae3:	f6 c2 03             	test   $0x3,%dl
  800ae6:	75 0a                	jne    800af2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aeb:	89 c7                	mov    %eax,%edi
  800aed:	fc                   	cld    
  800aee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af0:	eb 05                	jmp    800af7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af2:	89 c7                	mov    %eax,%edi
  800af4:	fc                   	cld    
  800af5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af7:	5e                   	pop    %esi
  800af8:	5f                   	pop    %edi
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b01:	ff 75 10             	pushl  0x10(%ebp)
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 8a ff ff ff       	call   800a99 <memmove>
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c6                	mov    %eax,%esi
  800b1e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b21:	39 f0                	cmp    %esi,%eax
  800b23:	74 1c                	je     800b41 <memcmp+0x30>
		if (*s1 != *s2)
  800b25:	0f b6 08             	movzbl (%eax),%ecx
  800b28:	0f b6 1a             	movzbl (%edx),%ebx
  800b2b:	38 d9                	cmp    %bl,%cl
  800b2d:	75 08                	jne    800b37 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2f:	83 c0 01             	add    $0x1,%eax
  800b32:	83 c2 01             	add    $0x1,%edx
  800b35:	eb ea                	jmp    800b21 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b37:	0f b6 c1             	movzbl %cl,%eax
  800b3a:	0f b6 db             	movzbl %bl,%ebx
  800b3d:	29 d8                	sub    %ebx,%eax
  800b3f:	eb 05                	jmp    800b46 <memcmp+0x35>
	}

	return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b58:	39 d0                	cmp    %edx,%eax
  800b5a:	73 09                	jae    800b65 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5c:	38 08                	cmp    %cl,(%eax)
  800b5e:	74 05                	je     800b65 <memfind+0x1b>
	for (; s < ends; s++)
  800b60:	83 c0 01             	add    $0x1,%eax
  800b63:	eb f3                	jmp    800b58 <memfind+0xe>
			break;
	return (void *) s;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b73:	eb 03                	jmp    800b78 <strtol+0x11>
		s++;
  800b75:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b78:	0f b6 01             	movzbl (%ecx),%eax
  800b7b:	3c 20                	cmp    $0x20,%al
  800b7d:	74 f6                	je     800b75 <strtol+0xe>
  800b7f:	3c 09                	cmp    $0x9,%al
  800b81:	74 f2                	je     800b75 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b83:	3c 2b                	cmp    $0x2b,%al
  800b85:	74 2a                	je     800bb1 <strtol+0x4a>
	int neg = 0;
  800b87:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8c:	3c 2d                	cmp    $0x2d,%al
  800b8e:	74 2b                	je     800bbb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b90:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b96:	75 0f                	jne    800ba7 <strtol+0x40>
  800b98:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9b:	74 28                	je     800bc5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9d:	85 db                	test   %ebx,%ebx
  800b9f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba4:	0f 44 d8             	cmove  %eax,%ebx
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800baf:	eb 50                	jmp    800c01 <strtol+0x9a>
		s++;
  800bb1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb9:	eb d5                	jmp    800b90 <strtol+0x29>
		s++, neg = 1;
  800bbb:	83 c1 01             	add    $0x1,%ecx
  800bbe:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc3:	eb cb                	jmp    800b90 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc9:	74 0e                	je     800bd9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	75 d8                	jne    800ba7 <strtol+0x40>
		s++, base = 8;
  800bcf:	83 c1 01             	add    $0x1,%ecx
  800bd2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd7:	eb ce                	jmp    800ba7 <strtol+0x40>
		s += 2, base = 16;
  800bd9:	83 c1 02             	add    $0x2,%ecx
  800bdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be1:	eb c4                	jmp    800ba7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be6:	89 f3                	mov    %esi,%ebx
  800be8:	80 fb 19             	cmp    $0x19,%bl
  800beb:	77 29                	ja     800c16 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bed:	0f be d2             	movsbl %dl,%edx
  800bf0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf6:	7d 30                	jge    800c28 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bff:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c01:	0f b6 11             	movzbl (%ecx),%edx
  800c04:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 09             	cmp    $0x9,%bl
  800c0c:	77 d5                	ja     800be3 <strtol+0x7c>
			dig = *s - '0';
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 30             	sub    $0x30,%edx
  800c14:	eb dd                	jmp    800bf3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c16:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c19:	89 f3                	mov    %esi,%ebx
  800c1b:	80 fb 19             	cmp    $0x19,%bl
  800c1e:	77 08                	ja     800c28 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c20:	0f be d2             	movsbl %dl,%edx
  800c23:	83 ea 37             	sub    $0x37,%edx
  800c26:	eb cb                	jmp    800bf3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 05                	je     800c33 <strtol+0xcc>
		*endptr = (char *) s;
  800c2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c31:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c33:	89 c2                	mov    %eax,%edx
  800c35:	f7 da                	neg    %edx
  800c37:	85 ff                	test   %edi,%edi
  800c39:	0f 45 c2             	cmovne %edx,%eax
}
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c47:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c52:	89 c3                	mov    %eax,%ebx
  800c54:	89 c7                	mov    %eax,%edi
  800c56:	89 c6                	mov    %eax,%esi
  800c58:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c65:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6f:	89 d1                	mov    %edx,%ecx
  800c71:	89 d3                	mov    %edx,%ebx
  800c73:	89 d7                	mov    %edx,%edi
  800c75:	89 d6                	mov    %edx,%esi
  800c77:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c94:	89 cb                	mov    %ecx,%ebx
  800c96:	89 cf                	mov    %ecx,%edi
  800c98:	89 ce                	mov    %ecx,%esi
  800c9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	7f 08                	jg     800ca8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca8:	83 ec 0c             	sub    $0xc,%esp
  800cab:	50                   	push   %eax
  800cac:	6a 03                	push   $0x3
  800cae:	68 48 29 80 00       	push   $0x802948
  800cb3:	6a 43                	push   $0x43
  800cb5:	68 65 29 80 00       	push   $0x802965
  800cba:	e8 89 14 00 00       	call   802148 <_panic>

00800cbf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 02 00 00 00       	mov    $0x2,%eax
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d3                	mov    %edx,%ebx
  800cd3:	89 d7                	mov    %edx,%edi
  800cd5:	89 d6                	mov    %edx,%esi
  800cd7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_yield>:

void
sys_yield(void)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cee:	89 d1                	mov    %edx,%ecx
  800cf0:	89 d3                	mov    %edx,%ebx
  800cf2:	89 d7                	mov    %edx,%edi
  800cf4:	89 d6                	mov    %edx,%esi
  800cf6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    

00800cfd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	be 00 00 00 00       	mov    $0x0,%esi
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	89 f7                	mov    %esi,%edi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 04                	push   $0x4
  800d2f:	68 48 29 80 00       	push   $0x802948
  800d34:	6a 43                	push   $0x43
  800d36:	68 65 29 80 00       	push   $0x802965
  800d3b:	e8 08 14 00 00       	call   802148 <_panic>

00800d40 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7f 08                	jg     800d6b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	50                   	push   %eax
  800d6f:	6a 05                	push   $0x5
  800d71:	68 48 29 80 00       	push   $0x802948
  800d76:	6a 43                	push   $0x43
  800d78:	68 65 29 80 00       	push   $0x802965
  800d7d:	e8 c6 13 00 00       	call   802148 <_panic>

00800d82 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	89 de                	mov    %ebx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 06                	push   $0x6
  800db3:	68 48 29 80 00       	push   $0x802948
  800db8:	6a 43                	push   $0x43
  800dba:	68 65 29 80 00       	push   $0x802965
  800dbf:	e8 84 13 00 00       	call   802148 <_panic>

00800dc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddd:	89 df                	mov    %ebx,%edi
  800ddf:	89 de                	mov    %ebx,%esi
  800de1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 08                	push   $0x8
  800df5:	68 48 29 80 00       	push   $0x802948
  800dfa:	6a 43                	push   $0x43
  800dfc:	68 65 29 80 00       	push   $0x802965
  800e01:	e8 42 13 00 00       	call   802148 <_panic>

00800e06 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e1f:	89 df                	mov    %ebx,%edi
  800e21:	89 de                	mov    %ebx,%esi
  800e23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	7f 08                	jg     800e31 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5f                   	pop    %edi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	50                   	push   %eax
  800e35:	6a 09                	push   $0x9
  800e37:	68 48 29 80 00       	push   $0x802948
  800e3c:	6a 43                	push   $0x43
  800e3e:	68 65 29 80 00       	push   $0x802965
  800e43:	e8 00 13 00 00       	call   802148 <_panic>

00800e48 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7f 08                	jg     800e73 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e77:	6a 0a                	push   $0xa
  800e79:	68 48 29 80 00       	push   $0x802948
  800e7e:	6a 43                	push   $0x43
  800e80:	68 65 29 80 00       	push   $0x802965
  800e85:	e8 be 12 00 00       	call   802148 <_panic>

00800e8a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9b:	be 00 00 00 00       	mov    $0x0,%esi
  800ea0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec3:	89 cb                	mov    %ecx,%ebx
  800ec5:	89 cf                	mov    %ecx,%edi
  800ec7:	89 ce                	mov    %ecx,%esi
  800ec9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	7f 08                	jg     800ed7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	50                   	push   %eax
  800edb:	6a 0d                	push   $0xd
  800edd:	68 48 29 80 00       	push   $0x802948
  800ee2:	6a 43                	push   $0x43
  800ee4:	68 65 29 80 00       	push   $0x802965
  800ee9:	e8 5a 12 00 00       	call   802148 <_panic>

00800eee <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f22:	89 cb                	mov    %ecx,%ebx
  800f24:	89 cf                	mov    %ecx,%edi
  800f26:	89 ce                	mov    %ecx,%esi
  800f28:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    

00800f2f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	57                   	push   %edi
  800f33:	56                   	push   %esi
  800f34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f35:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f3f:	89 d1                	mov    %edx,%ecx
  800f41:	89 d3                	mov    %edx,%ebx
  800f43:	89 d7                	mov    %edx,%edi
  800f45:	89 d6                	mov    %edx,%esi
  800f47:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 11 00 00 00       	mov    $0x11,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 12 00 00 00       	mov    $0x12,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
  800f96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	b8 13 00 00 00       	mov    $0x13,%eax
  800fa9:	89 df                	mov    %ebx,%edi
  800fab:	89 de                	mov    %ebx,%esi
  800fad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	7f 08                	jg     800fbb <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	50                   	push   %eax
  800fbf:	6a 13                	push   $0x13
  800fc1:	68 48 29 80 00       	push   $0x802948
  800fc6:	6a 43                	push   $0x43
  800fc8:	68 65 29 80 00       	push   $0x802965
  800fcd:	e8 76 11 00 00       	call   802148 <_panic>

00800fd2 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	b8 14 00 00 00       	mov    $0x14,%eax
  800fe5:	89 cb                	mov    %ecx,%ebx
  800fe7:	89 cf                	mov    %ecx,%edi
  800fe9:	89 ce                	mov    %ecx,%esi
  800feb:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	05 00 00 00 30       	add    $0x30000000,%eax
  800ffd:	c1 e8 0c             	shr    $0xc,%eax
}
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80100d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801012:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801021:	89 c2                	mov    %eax,%edx
  801023:	c1 ea 16             	shr    $0x16,%edx
  801026:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80102d:	f6 c2 01             	test   $0x1,%dl
  801030:	74 2d                	je     80105f <fd_alloc+0x46>
  801032:	89 c2                	mov    %eax,%edx
  801034:	c1 ea 0c             	shr    $0xc,%edx
  801037:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80103e:	f6 c2 01             	test   $0x1,%dl
  801041:	74 1c                	je     80105f <fd_alloc+0x46>
  801043:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801048:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80104d:	75 d2                	jne    801021 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801058:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80105d:	eb 0a                	jmp    801069 <fd_alloc+0x50>
			*fd_store = fd;
  80105f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801062:	89 01                	mov    %eax,(%ecx)
			return 0;
  801064:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801071:	83 f8 1f             	cmp    $0x1f,%eax
  801074:	77 30                	ja     8010a6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801076:	c1 e0 0c             	shl    $0xc,%eax
  801079:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80107e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801084:	f6 c2 01             	test   $0x1,%dl
  801087:	74 24                	je     8010ad <fd_lookup+0x42>
  801089:	89 c2                	mov    %eax,%edx
  80108b:	c1 ea 0c             	shr    $0xc,%edx
  80108e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801095:	f6 c2 01             	test   $0x1,%dl
  801098:	74 1a                	je     8010b4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	89 02                	mov    %eax,(%edx)
	return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
		return -E_INVAL;
  8010a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ab:	eb f7                	jmp    8010a4 <fd_lookup+0x39>
		return -E_INVAL;
  8010ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b2:	eb f0                	jmp    8010a4 <fd_lookup+0x39>
  8010b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b9:	eb e9                	jmp    8010a4 <fd_lookup+0x39>

008010bb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ce:	39 08                	cmp    %ecx,(%eax)
  8010d0:	74 38                	je     80110a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010d2:	83 c2 01             	add    $0x1,%edx
  8010d5:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 ee                	jne    8010ce <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e0:	a1 08 40 80 00       	mov    0x804008,%eax
  8010e5:	8b 40 48             	mov    0x48(%eax),%eax
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	51                   	push   %ecx
  8010ec:	50                   	push   %eax
  8010ed:	68 74 29 80 00       	push   $0x802974
  8010f2:	e8 b5 f0 ff ff       	call   8001ac <cprintf>
	*dev = 0;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    
			*dev = devtab[i];
  80110a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
  801114:	eb f2                	jmp    801108 <dev_lookup+0x4d>

00801116 <fd_close>:
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
  80111c:	83 ec 24             	sub    $0x24,%esp
  80111f:	8b 75 08             	mov    0x8(%ebp),%esi
  801122:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801125:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801128:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801129:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80112f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801132:	50                   	push   %eax
  801133:	e8 33 ff ff ff       	call   80106b <fd_lookup>
  801138:	89 c3                	mov    %eax,%ebx
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	78 05                	js     801146 <fd_close+0x30>
	    || fd != fd2)
  801141:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801144:	74 16                	je     80115c <fd_close+0x46>
		return (must_exist ? r : 0);
  801146:	89 f8                	mov    %edi,%eax
  801148:	84 c0                	test   %al,%al
  80114a:	b8 00 00 00 00       	mov    $0x0,%eax
  80114f:	0f 44 d8             	cmove  %eax,%ebx
}
  801152:	89 d8                	mov    %ebx,%eax
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801162:	50                   	push   %eax
  801163:	ff 36                	pushl  (%esi)
  801165:	e8 51 ff ff ff       	call   8010bb <dev_lookup>
  80116a:	89 c3                	mov    %eax,%ebx
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 1a                	js     80118d <fd_close+0x77>
		if (dev->dev_close)
  801173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801176:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801179:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80117e:	85 c0                	test   %eax,%eax
  801180:	74 0b                	je     80118d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801182:	83 ec 0c             	sub    $0xc,%esp
  801185:	56                   	push   %esi
  801186:	ff d0                	call   *%eax
  801188:	89 c3                	mov    %eax,%ebx
  80118a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	56                   	push   %esi
  801191:	6a 00                	push   $0x0
  801193:	e8 ea fb ff ff       	call   800d82 <sys_page_unmap>
	return r;
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	eb b5                	jmp    801152 <fd_close+0x3c>

0080119d <close>:

int
close(int fdnum)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	ff 75 08             	pushl  0x8(%ebp)
  8011aa:	e8 bc fe ff ff       	call   80106b <fd_lookup>
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	79 02                	jns    8011b8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    
		return fd_close(fd, 1);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	6a 01                	push   $0x1
  8011bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c0:	e8 51 ff ff ff       	call   801116 <fd_close>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	eb ec                	jmp    8011b6 <close+0x19>

008011ca <close_all>:

void
close_all(void)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	53                   	push   %ebx
  8011da:	e8 be ff ff ff       	call   80119d <close>
	for (i = 0; i < MAXFD; i++)
  8011df:	83 c3 01             	add    $0x1,%ebx
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	83 fb 20             	cmp    $0x20,%ebx
  8011e8:	75 ec                	jne    8011d6 <close_all+0xc>
}
  8011ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fb:	50                   	push   %eax
  8011fc:	ff 75 08             	pushl  0x8(%ebp)
  8011ff:	e8 67 fe ff ff       	call   80106b <fd_lookup>
  801204:	89 c3                	mov    %eax,%ebx
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	0f 88 81 00 00 00    	js     801292 <dup+0xa3>
		return r;
	close(newfdnum);
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	e8 81 ff ff ff       	call   80119d <close>

	newfd = INDEX2FD(newfdnum);
  80121c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121f:	c1 e6 0c             	shl    $0xc,%esi
  801222:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801228:	83 c4 04             	add    $0x4,%esp
  80122b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80122e:	e8 cf fd ff ff       	call   801002 <fd2data>
  801233:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801235:	89 34 24             	mov    %esi,(%esp)
  801238:	e8 c5 fd ff ff       	call   801002 <fd2data>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801242:	89 d8                	mov    %ebx,%eax
  801244:	c1 e8 16             	shr    $0x16,%eax
  801247:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124e:	a8 01                	test   $0x1,%al
  801250:	74 11                	je     801263 <dup+0x74>
  801252:	89 d8                	mov    %ebx,%eax
  801254:	c1 e8 0c             	shr    $0xc,%eax
  801257:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125e:	f6 c2 01             	test   $0x1,%dl
  801261:	75 39                	jne    80129c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801263:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801266:	89 d0                	mov    %edx,%eax
  801268:	c1 e8 0c             	shr    $0xc,%eax
  80126b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	25 07 0e 00 00       	and    $0xe07,%eax
  80127a:	50                   	push   %eax
  80127b:	56                   	push   %esi
  80127c:	6a 00                	push   $0x0
  80127e:	52                   	push   %edx
  80127f:	6a 00                	push   $0x0
  801281:	e8 ba fa ff ff       	call   800d40 <sys_page_map>
  801286:	89 c3                	mov    %eax,%ebx
  801288:	83 c4 20             	add    $0x20,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 31                	js     8012c0 <dup+0xd1>
		goto err;

	return newfdnum;
  80128f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801292:	89 d8                	mov    %ebx,%eax
  801294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5f                   	pop    %edi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80129c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ab:	50                   	push   %eax
  8012ac:	57                   	push   %edi
  8012ad:	6a 00                	push   $0x0
  8012af:	53                   	push   %ebx
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 89 fa ff ff       	call   800d40 <sys_page_map>
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	83 c4 20             	add    $0x20,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	79 a3                	jns    801263 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	56                   	push   %esi
  8012c4:	6a 00                	push   $0x0
  8012c6:	e8 b7 fa ff ff       	call   800d82 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012cb:	83 c4 08             	add    $0x8,%esp
  8012ce:	57                   	push   %edi
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 ac fa ff ff       	call   800d82 <sys_page_unmap>
	return r;
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	eb b7                	jmp    801292 <dup+0xa3>

008012db <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	53                   	push   %ebx
  8012df:	83 ec 1c             	sub    $0x1c,%esp
  8012e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e8:	50                   	push   %eax
  8012e9:	53                   	push   %ebx
  8012ea:	e8 7c fd ff ff       	call   80106b <fd_lookup>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 3f                	js     801335 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fc:	50                   	push   %eax
  8012fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801300:	ff 30                	pushl  (%eax)
  801302:	e8 b4 fd ff ff       	call   8010bb <dev_lookup>
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 27                	js     801335 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801311:	8b 42 08             	mov    0x8(%edx),%eax
  801314:	83 e0 03             	and    $0x3,%eax
  801317:	83 f8 01             	cmp    $0x1,%eax
  80131a:	74 1e                	je     80133a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131f:	8b 40 08             	mov    0x8(%eax),%eax
  801322:	85 c0                	test   %eax,%eax
  801324:	74 35                	je     80135b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	ff 75 10             	pushl  0x10(%ebp)
  80132c:	ff 75 0c             	pushl  0xc(%ebp)
  80132f:	52                   	push   %edx
  801330:	ff d0                	call   *%eax
  801332:	83 c4 10             	add    $0x10,%esp
}
  801335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801338:	c9                   	leave  
  801339:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80133a:	a1 08 40 80 00       	mov    0x804008,%eax
  80133f:	8b 40 48             	mov    0x48(%eax),%eax
  801342:	83 ec 04             	sub    $0x4,%esp
  801345:	53                   	push   %ebx
  801346:	50                   	push   %eax
  801347:	68 b5 29 80 00       	push   $0x8029b5
  80134c:	e8 5b ee ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801359:	eb da                	jmp    801335 <read+0x5a>
		return -E_NOT_SUPP;
  80135b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801360:	eb d3                	jmp    801335 <read+0x5a>

00801362 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	57                   	push   %edi
  801366:	56                   	push   %esi
  801367:	53                   	push   %ebx
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801371:	bb 00 00 00 00       	mov    $0x0,%ebx
  801376:	39 f3                	cmp    %esi,%ebx
  801378:	73 23                	jae    80139d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	89 f0                	mov    %esi,%eax
  80137f:	29 d8                	sub    %ebx,%eax
  801381:	50                   	push   %eax
  801382:	89 d8                	mov    %ebx,%eax
  801384:	03 45 0c             	add    0xc(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	57                   	push   %edi
  801389:	e8 4d ff ff ff       	call   8012db <read>
		if (m < 0)
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 06                	js     80139b <readn+0x39>
			return m;
		if (m == 0)
  801395:	74 06                	je     80139d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801397:	01 c3                	add    %eax,%ebx
  801399:	eb db                	jmp    801376 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80139d:	89 d8                	mov    %ebx,%eax
  80139f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 1c             	sub    $0x1c,%esp
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	53                   	push   %ebx
  8013b6:	e8 b0 fc ff ff       	call   80106b <fd_lookup>
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 3a                	js     8013fc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cc:	ff 30                	pushl  (%eax)
  8013ce:	e8 e8 fc ff ff       	call   8010bb <dev_lookup>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 22                	js     8013fc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e1:	74 1e                	je     801401 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013e9:	85 d2                	test   %edx,%edx
  8013eb:	74 35                	je     801422 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	ff 75 10             	pushl  0x10(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	50                   	push   %eax
  8013f7:	ff d2                	call   *%edx
  8013f9:	83 c4 10             	add    $0x10,%esp
}
  8013fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801401:	a1 08 40 80 00       	mov    0x804008,%eax
  801406:	8b 40 48             	mov    0x48(%eax),%eax
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	53                   	push   %ebx
  80140d:	50                   	push   %eax
  80140e:	68 d1 29 80 00       	push   $0x8029d1
  801413:	e8 94 ed ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb da                	jmp    8013fc <write+0x55>
		return -E_NOT_SUPP;
  801422:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801427:	eb d3                	jmp    8013fc <write+0x55>

00801429 <seek>:

int
seek(int fdnum, off_t offset)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80142f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	ff 75 08             	pushl  0x8(%ebp)
  801436:	e8 30 fc ff ff       	call   80106b <fd_lookup>
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 0e                	js     801450 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801442:	8b 55 0c             	mov    0xc(%ebp),%edx
  801445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801448:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	53                   	push   %ebx
  801456:	83 ec 1c             	sub    $0x1c,%esp
  801459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	53                   	push   %ebx
  801461:	e8 05 fc ff ff       	call   80106b <fd_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 37                	js     8014a4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	ff 30                	pushl  (%eax)
  801479:	e8 3d fc ff ff       	call   8010bb <dev_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 1f                	js     8014a4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801488:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148c:	74 1b                	je     8014a9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80148e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801491:	8b 52 18             	mov    0x18(%edx),%edx
  801494:	85 d2                	test   %edx,%edx
  801496:	74 32                	je     8014ca <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	50                   	push   %eax
  80149f:	ff d2                	call   *%edx
  8014a1:	83 c4 10             	add    $0x10,%esp
}
  8014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014a9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ae:	8b 40 48             	mov    0x48(%eax),%eax
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	53                   	push   %ebx
  8014b5:	50                   	push   %eax
  8014b6:	68 94 29 80 00       	push   $0x802994
  8014bb:	e8 ec ec ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb da                	jmp    8014a4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014cf:	eb d3                	jmp    8014a4 <ftruncate+0x52>

008014d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 1c             	sub    $0x1c,%esp
  8014d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 84 fb ff ff       	call   80106b <fd_lookup>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 4b                	js     801539 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	ff 30                	pushl  (%eax)
  8014fa:	e8 bc fb ff ff       	call   8010bb <dev_lookup>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 33                	js     801539 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801509:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80150d:	74 2f                	je     80153e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80150f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801512:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801519:	00 00 00 
	stat->st_isdir = 0;
  80151c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801523:	00 00 00 
	stat->st_dev = dev;
  801526:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	53                   	push   %ebx
  801530:	ff 75 f0             	pushl  -0x10(%ebp)
  801533:	ff 50 14             	call   *0x14(%eax)
  801536:	83 c4 10             	add    $0x10,%esp
}
  801539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    
		return -E_NOT_SUPP;
  80153e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801543:	eb f4                	jmp    801539 <fstat+0x68>

00801545 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	56                   	push   %esi
  801549:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	6a 00                	push   $0x0
  80154f:	ff 75 08             	pushl  0x8(%ebp)
  801552:	e8 22 02 00 00       	call   801779 <open>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 1b                	js     80157b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	50                   	push   %eax
  801567:	e8 65 ff ff ff       	call   8014d1 <fstat>
  80156c:	89 c6                	mov    %eax,%esi
	close(fd);
  80156e:	89 1c 24             	mov    %ebx,(%esp)
  801571:	e8 27 fc ff ff       	call   80119d <close>
	return r;
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	89 f3                	mov    %esi,%ebx
}
  80157b:	89 d8                	mov    %ebx,%eax
  80157d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	89 c6                	mov    %eax,%esi
  80158b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801594:	74 27                	je     8015bd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801596:	6a 07                	push   $0x7
  801598:	68 00 50 80 00       	push   $0x805000
  80159d:	56                   	push   %esi
  80159e:	ff 35 00 40 80 00    	pushl  0x804000
  8015a4:	e8 69 0c 00 00       	call   802212 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015a9:	83 c4 0c             	add    $0xc,%esp
  8015ac:	6a 00                	push   $0x0
  8015ae:	53                   	push   %ebx
  8015af:	6a 00                	push   $0x0
  8015b1:	e8 f3 0b 00 00       	call   8021a9 <ipc_recv>
}
  8015b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5e                   	pop    %esi
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	6a 01                	push   $0x1
  8015c2:	e8 a3 0c 00 00       	call   80226a <ipc_find_env>
  8015c7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	eb c5                	jmp    801596 <fsipc+0x12>

008015d1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f4:	e8 8b ff ff ff       	call   801584 <fsipc>
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <devfile_flush>:
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8b 40 0c             	mov    0xc(%eax),%eax
  801607:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80160c:	ba 00 00 00 00       	mov    $0x0,%edx
  801611:	b8 06 00 00 00       	mov    $0x6,%eax
  801616:	e8 69 ff ff ff       	call   801584 <fsipc>
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <devfile_stat>:
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	b8 05 00 00 00       	mov    $0x5,%eax
  80163c:	e8 43 ff ff ff       	call   801584 <fsipc>
  801641:	85 c0                	test   %eax,%eax
  801643:	78 2c                	js     801671 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	68 00 50 80 00       	push   $0x805000
  80164d:	53                   	push   %ebx
  80164e:	e8 b8 f2 ff ff       	call   80090b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801653:	a1 80 50 80 00       	mov    0x805080,%eax
  801658:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80165e:	a1 84 50 80 00       	mov    0x805084,%eax
  801663:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <devfile_write>:
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 40 0c             	mov    0xc(%eax),%eax
  801686:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80168b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801691:	53                   	push   %ebx
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	68 08 50 80 00       	push   $0x805008
  80169a:	e8 5c f4 ff ff       	call   800afb <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80169f:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a9:	e8 d6 fe ff ff       	call   801584 <fsipc>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 0b                	js     8016c0 <devfile_write+0x4a>
	assert(r <= n);
  8016b5:	39 d8                	cmp    %ebx,%eax
  8016b7:	77 0c                	ja     8016c5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016be:	7f 1e                	jg     8016de <devfile_write+0x68>
}
  8016c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    
	assert(r <= n);
  8016c5:	68 04 2a 80 00       	push   $0x802a04
  8016ca:	68 0b 2a 80 00       	push   $0x802a0b
  8016cf:	68 98 00 00 00       	push   $0x98
  8016d4:	68 20 2a 80 00       	push   $0x802a20
  8016d9:	e8 6a 0a 00 00       	call   802148 <_panic>
	assert(r <= PGSIZE);
  8016de:	68 2b 2a 80 00       	push   $0x802a2b
  8016e3:	68 0b 2a 80 00       	push   $0x802a0b
  8016e8:	68 99 00 00 00       	push   $0x99
  8016ed:	68 20 2a 80 00       	push   $0x802a20
  8016f2:	e8 51 0a 00 00       	call   802148 <_panic>

008016f7 <devfile_read>:
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	56                   	push   %esi
  8016fb:	53                   	push   %ebx
  8016fc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80170a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b8 03 00 00 00       	mov    $0x3,%eax
  80171a:	e8 65 fe ff ff       	call   801584 <fsipc>
  80171f:	89 c3                	mov    %eax,%ebx
  801721:	85 c0                	test   %eax,%eax
  801723:	78 1f                	js     801744 <devfile_read+0x4d>
	assert(r <= n);
  801725:	39 f0                	cmp    %esi,%eax
  801727:	77 24                	ja     80174d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801729:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172e:	7f 33                	jg     801763 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	50                   	push   %eax
  801734:	68 00 50 80 00       	push   $0x805000
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	e8 58 f3 ff ff       	call   800a99 <memmove>
	return r;
  801741:	83 c4 10             	add    $0x10,%esp
}
  801744:	89 d8                	mov    %ebx,%eax
  801746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    
	assert(r <= n);
  80174d:	68 04 2a 80 00       	push   $0x802a04
  801752:	68 0b 2a 80 00       	push   $0x802a0b
  801757:	6a 7c                	push   $0x7c
  801759:	68 20 2a 80 00       	push   $0x802a20
  80175e:	e8 e5 09 00 00       	call   802148 <_panic>
	assert(r <= PGSIZE);
  801763:	68 2b 2a 80 00       	push   $0x802a2b
  801768:	68 0b 2a 80 00       	push   $0x802a0b
  80176d:	6a 7d                	push   $0x7d
  80176f:	68 20 2a 80 00       	push   $0x802a20
  801774:	e8 cf 09 00 00       	call   802148 <_panic>

00801779 <open>:
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	56                   	push   %esi
  80177d:	53                   	push   %ebx
  80177e:	83 ec 1c             	sub    $0x1c,%esp
  801781:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801784:	56                   	push   %esi
  801785:	e8 48 f1 ff ff       	call   8008d2 <strlen>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801792:	7f 6c                	jg     801800 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179a:	50                   	push   %eax
  80179b:	e8 79 f8 ff ff       	call   801019 <fd_alloc>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 3c                	js     8017e5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	56                   	push   %esi
  8017ad:	68 00 50 80 00       	push   $0x805000
  8017b2:	e8 54 f1 ff ff       	call   80090b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ba:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c7:	e8 b8 fd ff ff       	call   801584 <fsipc>
  8017cc:	89 c3                	mov    %eax,%ebx
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 19                	js     8017ee <open+0x75>
	return fd2num(fd);
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017db:	e8 12 f8 ff ff       	call   800ff2 <fd2num>
  8017e0:	89 c3                	mov    %eax,%ebx
  8017e2:	83 c4 10             	add    $0x10,%esp
}
  8017e5:	89 d8                	mov    %ebx,%eax
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
		fd_close(fd, 0);
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	6a 00                	push   $0x0
  8017f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f6:	e8 1b f9 ff ff       	call   801116 <fd_close>
		return r;
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	eb e5                	jmp    8017e5 <open+0x6c>
		return -E_BAD_PATH;
  801800:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801805:	eb de                	jmp    8017e5 <open+0x6c>

00801807 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	b8 08 00 00 00       	mov    $0x8,%eax
  801817:	e8 68 fd ff ff       	call   801584 <fsipc>
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801824:	68 37 2a 80 00       	push   $0x802a37
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	e8 da f0 ff ff       	call   80090b <strcpy>
	return 0;
}
  801831:	b8 00 00 00 00       	mov    $0x0,%eax
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <devsock_close>:
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	53                   	push   %ebx
  80183c:	83 ec 10             	sub    $0x10,%esp
  80183f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801842:	53                   	push   %ebx
  801843:	e8 61 0a 00 00       	call   8022a9 <pageref>
  801848:	83 c4 10             	add    $0x10,%esp
		return 0;
  80184b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801850:	83 f8 01             	cmp    $0x1,%eax
  801853:	74 07                	je     80185c <devsock_close+0x24>
}
  801855:	89 d0                	mov    %edx,%eax
  801857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	ff 73 0c             	pushl  0xc(%ebx)
  801862:	e8 b9 02 00 00       	call   801b20 <nsipc_close>
  801867:	89 c2                	mov    %eax,%edx
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	eb e7                	jmp    801855 <devsock_close+0x1d>

0080186e <devsock_write>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801874:	6a 00                	push   $0x0
  801876:	ff 75 10             	pushl  0x10(%ebp)
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	ff 70 0c             	pushl  0xc(%eax)
  801882:	e8 76 03 00 00       	call   801bfd <nsipc_send>
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <devsock_read>:
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80188f:	6a 00                	push   $0x0
  801891:	ff 75 10             	pushl  0x10(%ebp)
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	ff 70 0c             	pushl  0xc(%eax)
  80189d:	e8 ef 02 00 00       	call   801b91 <nsipc_recv>
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <fd2sockid>:
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	e8 b7 f7 ff ff       	call   80106b <fd_lookup>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 10                	js     8018cb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018be:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018c4:	39 08                	cmp    %ecx,(%eax)
  8018c6:	75 05                	jne    8018cd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018c8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    
		return -E_NOT_SUPP;
  8018cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d2:	eb f7                	jmp    8018cb <fd2sockid+0x27>

008018d4 <alloc_sockfd>:
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	83 ec 1c             	sub    $0x1c,%esp
  8018dc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	e8 32 f7 ff ff       	call   801019 <fd_alloc>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 43                	js     801933 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 07 04 00 00       	push   $0x407
  8018f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fb:	6a 00                	push   $0x0
  8018fd:	e8 fb f3 ff ff       	call   800cfd <sys_page_alloc>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 28                	js     801933 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801914:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801920:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	50                   	push   %eax
  801927:	e8 c6 f6 ff ff       	call   800ff2 <fd2num>
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	eb 0c                	jmp    80193f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	56                   	push   %esi
  801937:	e8 e4 01 00 00       	call   801b20 <nsipc_close>
		return r;
  80193c:	83 c4 10             	add    $0x10,%esp
}
  80193f:	89 d8                	mov    %ebx,%eax
  801941:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    

00801948 <accept>:
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	e8 4e ff ff ff       	call   8018a4 <fd2sockid>
  801956:	85 c0                	test   %eax,%eax
  801958:	78 1b                	js     801975 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	ff 75 10             	pushl  0x10(%ebp)
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	50                   	push   %eax
  801964:	e8 0e 01 00 00       	call   801a77 <nsipc_accept>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 05                	js     801975 <accept+0x2d>
	return alloc_sockfd(r);
  801970:	e8 5f ff ff ff       	call   8018d4 <alloc_sockfd>
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <bind>:
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	e8 1f ff ff ff       	call   8018a4 <fd2sockid>
  801985:	85 c0                	test   %eax,%eax
  801987:	78 12                	js     80199b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	ff 75 10             	pushl  0x10(%ebp)
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	50                   	push   %eax
  801993:	e8 31 01 00 00       	call   801ac9 <nsipc_bind>
  801998:	83 c4 10             	add    $0x10,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <shutdown>:
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	e8 f9 fe ff ff       	call   8018a4 <fd2sockid>
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 0f                	js     8019be <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	50                   	push   %eax
  8019b6:	e8 43 01 00 00       	call   801afe <nsipc_shutdown>
  8019bb:	83 c4 10             	add    $0x10,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <connect>:
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	e8 d6 fe ff ff       	call   8018a4 <fd2sockid>
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 12                	js     8019e4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	ff 75 10             	pushl  0x10(%ebp)
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	50                   	push   %eax
  8019dc:	e8 59 01 00 00       	call   801b3a <nsipc_connect>
  8019e1:	83 c4 10             	add    $0x10,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <listen>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	e8 b0 fe ff ff       	call   8018a4 <fd2sockid>
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 0f                	js     801a07 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	50                   	push   %eax
  8019ff:	e8 6b 01 00 00       	call   801b6f <nsipc_listen>
  801a04:	83 c4 10             	add    $0x10,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	e8 3e 02 00 00       	call   801c5b <nsipc_socket>
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 05                	js     801a29 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a24:	e8 ab fe ff ff       	call   8018d4 <alloc_sockfd>
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	53                   	push   %ebx
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a34:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a3b:	74 26                	je     801a63 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a3d:	6a 07                	push   $0x7
  801a3f:	68 00 60 80 00       	push   $0x806000
  801a44:	53                   	push   %ebx
  801a45:	ff 35 04 40 80 00    	pushl  0x804004
  801a4b:	e8 c2 07 00 00       	call   802212 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a50:	83 c4 0c             	add    $0xc,%esp
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	e8 4b 07 00 00       	call   8021a9 <ipc_recv>
}
  801a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	6a 02                	push   $0x2
  801a68:	e8 fd 07 00 00       	call   80226a <ipc_find_env>
  801a6d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	eb c6                	jmp    801a3d <nsipc+0x12>

00801a77 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a87:	8b 06                	mov    (%esi),%eax
  801a89:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	e8 93 ff ff ff       	call   801a2b <nsipc>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	79 09                	jns    801aa7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a9e:	89 d8                	mov    %ebx,%eax
  801aa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5d                   	pop    %ebp
  801aa6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	ff 35 10 60 80 00    	pushl  0x806010
  801ab0:	68 00 60 80 00       	push   $0x806000
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	e8 dc ef ff ff       	call   800a99 <memmove>
		*addrlen = ret->ret_addrlen;
  801abd:	a1 10 60 80 00       	mov    0x806010,%eax
  801ac2:	89 06                	mov    %eax,(%esi)
  801ac4:	83 c4 10             	add    $0x10,%esp
	return r;
  801ac7:	eb d5                	jmp    801a9e <nsipc_accept+0x27>

00801ac9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	53                   	push   %ebx
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801adb:	53                   	push   %ebx
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	68 04 60 80 00       	push   $0x806004
  801ae4:	e8 b0 ef ff ff       	call   800a99 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ae9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aef:	b8 02 00 00 00       	mov    $0x2,%eax
  801af4:	e8 32 ff ff ff       	call   801a2b <nsipc>
}
  801af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b14:	b8 03 00 00 00       	mov    $0x3,%eax
  801b19:	e8 0d ff ff ff       	call   801a2b <nsipc>
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <nsipc_close>:

int
nsipc_close(int s)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b2e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b33:	e8 f3 fe ff ff       	call   801a2b <nsipc>
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b4c:	53                   	push   %ebx
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	68 04 60 80 00       	push   $0x806004
  801b55:	e8 3f ef ff ff       	call   800a99 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b5a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b60:	b8 05 00 00 00       	mov    $0x5,%eax
  801b65:	e8 c1 fe ff ff       	call   801a2b <nsipc>
}
  801b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b85:	b8 06 00 00 00       	mov    $0x6,%eax
  801b8a:	e8 9c fe ff ff       	call   801a2b <nsipc>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	56                   	push   %esi
  801b95:	53                   	push   %ebx
  801b96:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ba1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  801baa:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801baf:	b8 07 00 00 00       	mov    $0x7,%eax
  801bb4:	e8 72 fe ff ff       	call   801a2b <nsipc>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 1f                	js     801bde <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bbf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bc4:	7f 21                	jg     801be7 <nsipc_recv+0x56>
  801bc6:	39 c6                	cmp    %eax,%esi
  801bc8:	7c 1d                	jl     801be7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	50                   	push   %eax
  801bce:	68 00 60 80 00       	push   $0x806000
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	e8 be ee ff ff       	call   800a99 <memmove>
  801bdb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bde:	89 d8                	mov    %ebx,%eax
  801be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801be7:	68 43 2a 80 00       	push   $0x802a43
  801bec:	68 0b 2a 80 00       	push   $0x802a0b
  801bf1:	6a 62                	push   $0x62
  801bf3:	68 58 2a 80 00       	push   $0x802a58
  801bf8:	e8 4b 05 00 00       	call   802148 <_panic>

00801bfd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	53                   	push   %ebx
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c0f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c15:	7f 2e                	jg     801c45 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	53                   	push   %ebx
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	68 0c 60 80 00       	push   $0x80600c
  801c23:	e8 71 ee ff ff       	call   800a99 <memmove>
	nsipcbuf.send.req_size = size;
  801c28:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c31:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c36:	b8 08 00 00 00       	mov    $0x8,%eax
  801c3b:	e8 eb fd ff ff       	call   801a2b <nsipc>
}
  801c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    
	assert(size < 1600);
  801c45:	68 64 2a 80 00       	push   $0x802a64
  801c4a:	68 0b 2a 80 00       	push   $0x802a0b
  801c4f:	6a 6d                	push   $0x6d
  801c51:	68 58 2a 80 00       	push   $0x802a58
  801c56:	e8 ed 04 00 00       	call   802148 <_panic>

00801c5b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c79:	b8 09 00 00 00       	mov    $0x9,%eax
  801c7e:	e8 a8 fd ff ff       	call   801a2b <nsipc>
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	56                   	push   %esi
  801c89:	53                   	push   %ebx
  801c8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 6a f3 ff ff       	call   801002 <fd2data>
  801c98:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	68 70 2a 80 00       	push   $0x802a70
  801ca2:	53                   	push   %ebx
  801ca3:	e8 63 ec ff ff       	call   80090b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca8:	8b 46 04             	mov    0x4(%esi),%eax
  801cab:	2b 06                	sub    (%esi),%eax
  801cad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cba:	00 00 00 
	stat->st_dev = &devpipe;
  801cbd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cc4:	30 80 00 
	return 0;
}
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cdd:	53                   	push   %ebx
  801cde:	6a 00                	push   $0x0
  801ce0:	e8 9d f0 ff ff       	call   800d82 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce5:	89 1c 24             	mov    %ebx,(%esp)
  801ce8:	e8 15 f3 ff ff       	call   801002 <fd2data>
  801ced:	83 c4 08             	add    $0x8,%esp
  801cf0:	50                   	push   %eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	e8 8a f0 ff ff       	call   800d82 <sys_page_unmap>
}
  801cf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <_pipeisclosed>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	57                   	push   %edi
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 1c             	sub    $0x1c,%esp
  801d06:	89 c7                	mov    %eax,%edi
  801d08:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d0a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d0f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	57                   	push   %edi
  801d16:	e8 8e 05 00 00       	call   8022a9 <pageref>
  801d1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d1e:	89 34 24             	mov    %esi,(%esp)
  801d21:	e8 83 05 00 00       	call   8022a9 <pageref>
		nn = thisenv->env_runs;
  801d26:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d2c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	39 cb                	cmp    %ecx,%ebx
  801d34:	74 1b                	je     801d51 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d36:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d39:	75 cf                	jne    801d0a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d3b:	8b 42 58             	mov    0x58(%edx),%eax
  801d3e:	6a 01                	push   $0x1
  801d40:	50                   	push   %eax
  801d41:	53                   	push   %ebx
  801d42:	68 77 2a 80 00       	push   $0x802a77
  801d47:	e8 60 e4 ff ff       	call   8001ac <cprintf>
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	eb b9                	jmp    801d0a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d51:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d54:	0f 94 c0             	sete   %al
  801d57:	0f b6 c0             	movzbl %al,%eax
}
  801d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5e                   	pop    %esi
  801d5f:	5f                   	pop    %edi
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    

00801d62 <devpipe_write>:
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 28             	sub    $0x28,%esp
  801d6b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d6e:	56                   	push   %esi
  801d6f:	e8 8e f2 ff ff       	call   801002 <fd2data>
  801d74:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d81:	74 4f                	je     801dd2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d83:	8b 43 04             	mov    0x4(%ebx),%eax
  801d86:	8b 0b                	mov    (%ebx),%ecx
  801d88:	8d 51 20             	lea    0x20(%ecx),%edx
  801d8b:	39 d0                	cmp    %edx,%eax
  801d8d:	72 14                	jb     801da3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d8f:	89 da                	mov    %ebx,%edx
  801d91:	89 f0                	mov    %esi,%eax
  801d93:	e8 65 ff ff ff       	call   801cfd <_pipeisclosed>
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	75 3b                	jne    801dd7 <devpipe_write+0x75>
			sys_yield();
  801d9c:	e8 3d ef ff ff       	call   800cde <sys_yield>
  801da1:	eb e0                	jmp    801d83 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801daa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dad:	89 c2                	mov    %eax,%edx
  801daf:	c1 fa 1f             	sar    $0x1f,%edx
  801db2:	89 d1                	mov    %edx,%ecx
  801db4:	c1 e9 1b             	shr    $0x1b,%ecx
  801db7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dba:	83 e2 1f             	and    $0x1f,%edx
  801dbd:	29 ca                	sub    %ecx,%edx
  801dbf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dc3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dc7:	83 c0 01             	add    $0x1,%eax
  801dca:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dcd:	83 c7 01             	add    $0x1,%edi
  801dd0:	eb ac                	jmp    801d7e <devpipe_write+0x1c>
	return i;
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	eb 05                	jmp    801ddc <devpipe_write+0x7a>
				return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5f                   	pop    %edi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <devpipe_read>:
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	57                   	push   %edi
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	83 ec 18             	sub    $0x18,%esp
  801ded:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df0:	57                   	push   %edi
  801df1:	e8 0c f2 ff ff       	call   801002 <fd2data>
  801df6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	be 00 00 00 00       	mov    $0x0,%esi
  801e00:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e03:	75 14                	jne    801e19 <devpipe_read+0x35>
	return i;
  801e05:	8b 45 10             	mov    0x10(%ebp),%eax
  801e08:	eb 02                	jmp    801e0c <devpipe_read+0x28>
				return i;
  801e0a:	89 f0                	mov    %esi,%eax
}
  801e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    
			sys_yield();
  801e14:	e8 c5 ee ff ff       	call   800cde <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e19:	8b 03                	mov    (%ebx),%eax
  801e1b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e1e:	75 18                	jne    801e38 <devpipe_read+0x54>
			if (i > 0)
  801e20:	85 f6                	test   %esi,%esi
  801e22:	75 e6                	jne    801e0a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e24:	89 da                	mov    %ebx,%edx
  801e26:	89 f8                	mov    %edi,%eax
  801e28:	e8 d0 fe ff ff       	call   801cfd <_pipeisclosed>
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 e3                	je     801e14 <devpipe_read+0x30>
				return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	eb d4                	jmp    801e0c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e38:	99                   	cltd   
  801e39:	c1 ea 1b             	shr    $0x1b,%edx
  801e3c:	01 d0                	add    %edx,%eax
  801e3e:	83 e0 1f             	and    $0x1f,%eax
  801e41:	29 d0                	sub    %edx,%eax
  801e43:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e4e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e51:	83 c6 01             	add    $0x1,%esi
  801e54:	eb aa                	jmp    801e00 <devpipe_read+0x1c>

00801e56 <pipe>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e61:	50                   	push   %eax
  801e62:	e8 b2 f1 ff ff       	call   801019 <fd_alloc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 88 23 01 00 00    	js     801f97 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 07 04 00 00       	push   $0x407
  801e7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7f:	6a 00                	push   $0x0
  801e81:	e8 77 ee ff ff       	call   800cfd <sys_page_alloc>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 88 04 01 00 00    	js     801f97 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e99:	50                   	push   %eax
  801e9a:	e8 7a f1 ff ff       	call   801019 <fd_alloc>
  801e9f:	89 c3                	mov    %eax,%ebx
  801ea1:	83 c4 10             	add    $0x10,%esp
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	0f 88 db 00 00 00    	js     801f87 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 07 04 00 00       	push   $0x407
  801eb4:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb7:	6a 00                	push   $0x0
  801eb9:	e8 3f ee ff ff       	call   800cfd <sys_page_alloc>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 88 bc 00 00 00    	js     801f87 <pipe+0x131>
	va = fd2data(fd0);
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed1:	e8 2c f1 ff ff       	call   801002 <fd2data>
  801ed6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed8:	83 c4 0c             	add    $0xc,%esp
  801edb:	68 07 04 00 00       	push   $0x407
  801ee0:	50                   	push   %eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	e8 15 ee ff ff       	call   800cfd <sys_page_alloc>
  801ee8:	89 c3                	mov    %eax,%ebx
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	85 c0                	test   %eax,%eax
  801eef:	0f 88 82 00 00 00    	js     801f77 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 f0             	pushl  -0x10(%ebp)
  801efb:	e8 02 f1 ff ff       	call   801002 <fd2data>
  801f00:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f07:	50                   	push   %eax
  801f08:	6a 00                	push   $0x0
  801f0a:	56                   	push   %esi
  801f0b:	6a 00                	push   $0x0
  801f0d:	e8 2e ee ff ff       	call   800d40 <sys_page_map>
  801f12:	89 c3                	mov    %eax,%ebx
  801f14:	83 c4 20             	add    $0x20,%esp
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 4e                	js     801f69 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f1b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f23:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f28:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f32:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	ff 75 f4             	pushl  -0xc(%ebp)
  801f44:	e8 a9 f0 ff ff       	call   800ff2 <fd2num>
  801f49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f4e:	83 c4 04             	add    $0x4,%esp
  801f51:	ff 75 f0             	pushl  -0x10(%ebp)
  801f54:	e8 99 f0 ff ff       	call   800ff2 <fd2num>
  801f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f67:	eb 2e                	jmp    801f97 <pipe+0x141>
	sys_page_unmap(0, va);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	56                   	push   %esi
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 0e ee ff ff       	call   800d82 <sys_page_unmap>
  801f74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f7d:	6a 00                	push   $0x0
  801f7f:	e8 fe ed ff ff       	call   800d82 <sys_page_unmap>
  801f84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 ee ed ff ff       	call   800d82 <sys_page_unmap>
  801f94:	83 c4 10             	add    $0x10,%esp
}
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <pipeisclosed>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa9:	50                   	push   %eax
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	e8 b9 f0 ff ff       	call   80106b <fd_lookup>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 18                	js     801fd1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	e8 3e f0 ff ff       	call   801002 <fd2data>
	return _pipeisclosed(fd, p);
  801fc4:	89 c2                	mov    %eax,%edx
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	e8 2f fd ff ff       	call   801cfd <_pipeisclosed>
  801fce:	83 c4 10             	add    $0x10,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	c3                   	ret    

00801fd9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fdf:	68 8f 2a 80 00       	push   $0x802a8f
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	e8 1f e9 ff ff       	call   80090b <strcpy>
	return 0;
}
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <devcons_write>:
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	57                   	push   %edi
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802004:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80200a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200d:	73 31                	jae    802040 <devcons_write+0x4d>
		m = n - tot;
  80200f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802012:	29 f3                	sub    %esi,%ebx
  802014:	83 fb 7f             	cmp    $0x7f,%ebx
  802017:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80201c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	53                   	push   %ebx
  802023:	89 f0                	mov    %esi,%eax
  802025:	03 45 0c             	add    0xc(%ebp),%eax
  802028:	50                   	push   %eax
  802029:	57                   	push   %edi
  80202a:	e8 6a ea ff ff       	call   800a99 <memmove>
		sys_cputs(buf, m);
  80202f:	83 c4 08             	add    $0x8,%esp
  802032:	53                   	push   %ebx
  802033:	57                   	push   %edi
  802034:	e8 08 ec ff ff       	call   800c41 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802039:	01 de                	add    %ebx,%esi
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	eb ca                	jmp    80200a <devcons_write+0x17>
}
  802040:	89 f0                	mov    %esi,%eax
  802042:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802045:	5b                   	pop    %ebx
  802046:	5e                   	pop    %esi
  802047:	5f                   	pop    %edi
  802048:	5d                   	pop    %ebp
  802049:	c3                   	ret    

0080204a <devcons_read>:
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 08             	sub    $0x8,%esp
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802055:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802059:	74 21                	je     80207c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80205b:	e8 ff eb ff ff       	call   800c5f <sys_cgetc>
  802060:	85 c0                	test   %eax,%eax
  802062:	75 07                	jne    80206b <devcons_read+0x21>
		sys_yield();
  802064:	e8 75 ec ff ff       	call   800cde <sys_yield>
  802069:	eb f0                	jmp    80205b <devcons_read+0x11>
	if (c < 0)
  80206b:	78 0f                	js     80207c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80206d:	83 f8 04             	cmp    $0x4,%eax
  802070:	74 0c                	je     80207e <devcons_read+0x34>
	*(char*)vbuf = c;
  802072:	8b 55 0c             	mov    0xc(%ebp),%edx
  802075:	88 02                	mov    %al,(%edx)
	return 1;
  802077:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    
		return 0;
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	eb f7                	jmp    80207c <devcons_read+0x32>

00802085 <cputchar>:
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802091:	6a 01                	push   $0x1
  802093:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	e8 a5 eb ff ff       	call   800c41 <sys_cputs>
}
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <getchar>:
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020a7:	6a 01                	push   $0x1
  8020a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ac:	50                   	push   %eax
  8020ad:	6a 00                	push   $0x0
  8020af:	e8 27 f2 ff ff       	call   8012db <read>
	if (r < 0)
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 06                	js     8020c1 <getchar+0x20>
	if (r < 1)
  8020bb:	74 06                	je     8020c3 <getchar+0x22>
	return c;
  8020bd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    
		return -E_EOF;
  8020c3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020c8:	eb f7                	jmp    8020c1 <getchar+0x20>

008020ca <iscons>:
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d3:	50                   	push   %eax
  8020d4:	ff 75 08             	pushl  0x8(%ebp)
  8020d7:	e8 8f ef ff ff       	call   80106b <fd_lookup>
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 11                	js     8020f4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ec:	39 10                	cmp    %edx,(%eax)
  8020ee:	0f 94 c0             	sete   %al
  8020f1:	0f b6 c0             	movzbl %al,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <opencons>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	e8 14 ef ff ff       	call   801019 <fd_alloc>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 3a                	js     802146 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 07 04 00 00       	push   $0x407
  802114:	ff 75 f4             	pushl  -0xc(%ebp)
  802117:	6a 00                	push   $0x0
  802119:	e8 df eb ff ff       	call   800cfd <sys_page_alloc>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	85 c0                	test   %eax,%eax
  802123:	78 21                	js     802146 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	50                   	push   %eax
  80213e:	e8 af ee ff ff       	call   800ff2 <fd2num>
  802143:	83 c4 10             	add    $0x10,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	56                   	push   %esi
  80214c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80214d:	a1 08 40 80 00       	mov    0x804008,%eax
  802152:	8b 40 48             	mov    0x48(%eax),%eax
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 c0 2a 80 00       	push   $0x802ac0
  80215d:	50                   	push   %eax
  80215e:	68 b5 25 80 00       	push   $0x8025b5
  802163:	e8 44 e0 ff ff       	call   8001ac <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802168:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80216b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802171:	e8 49 eb ff ff       	call   800cbf <sys_getenvid>
  802176:	83 c4 04             	add    $0x4,%esp
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	ff 75 08             	pushl  0x8(%ebp)
  80217f:	56                   	push   %esi
  802180:	50                   	push   %eax
  802181:	68 9c 2a 80 00       	push   $0x802a9c
  802186:	e8 21 e0 ff ff       	call   8001ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80218b:	83 c4 18             	add    $0x18,%esp
  80218e:	53                   	push   %ebx
  80218f:	ff 75 10             	pushl  0x10(%ebp)
  802192:	e8 c4 df ff ff       	call   80015b <vcprintf>
	cprintf("\n");
  802197:	c7 04 24 da 2a 80 00 	movl   $0x802ada,(%esp)
  80219e:	e8 09 e0 ff ff       	call   8001ac <cprintf>
  8021a3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021a6:	cc                   	int3   
  8021a7:	eb fd                	jmp    8021a6 <_panic+0x5e>

008021a9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8021b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021b7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021b9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021be:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	50                   	push   %eax
  8021c5:	e8 e3 ec ff ff       	call   800ead <sys_ipc_recv>
	if(ret < 0){
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 2b                	js     8021fc <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021d1:	85 f6                	test   %esi,%esi
  8021d3:	74 0a                	je     8021df <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021d5:	a1 08 40 80 00       	mov    0x804008,%eax
  8021da:	8b 40 78             	mov    0x78(%eax),%eax
  8021dd:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021df:	85 db                	test   %ebx,%ebx
  8021e1:	74 0a                	je     8021ed <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021eb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f2:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f8:	5b                   	pop    %ebx
  8021f9:	5e                   	pop    %esi
  8021fa:	5d                   	pop    %ebp
  8021fb:	c3                   	ret    
		if(from_env_store)
  8021fc:	85 f6                	test   %esi,%esi
  8021fe:	74 06                	je     802206 <ipc_recv+0x5d>
			*from_env_store = 0;
  802200:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802206:	85 db                	test   %ebx,%ebx
  802208:	74 eb                	je     8021f5 <ipc_recv+0x4c>
			*perm_store = 0;
  80220a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802210:	eb e3                	jmp    8021f5 <ipc_recv+0x4c>

00802212 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80221e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802221:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802224:	85 db                	test   %ebx,%ebx
  802226:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80222b:	0f 44 d8             	cmove  %eax,%ebx
  80222e:	eb 05                	jmp    802235 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802230:	e8 a9 ea ff ff       	call   800cde <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802235:	ff 75 14             	pushl  0x14(%ebp)
  802238:	53                   	push   %ebx
  802239:	56                   	push   %esi
  80223a:	57                   	push   %edi
  80223b:	e8 4a ec ff ff       	call   800e8a <sys_ipc_try_send>
  802240:	83 c4 10             	add    $0x10,%esp
  802243:	85 c0                	test   %eax,%eax
  802245:	74 1b                	je     802262 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802247:	79 e7                	jns    802230 <ipc_send+0x1e>
  802249:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80224c:	74 e2                	je     802230 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 c7 2a 80 00       	push   $0x802ac7
  802256:	6a 46                	push   $0x46
  802258:	68 dc 2a 80 00       	push   $0x802adc
  80225d:	e8 e6 fe ff ff       	call   802148 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    

0080226a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802275:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80227b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802281:	8b 52 50             	mov    0x50(%edx),%edx
  802284:	39 ca                	cmp    %ecx,%edx
  802286:	74 11                	je     802299 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802288:	83 c0 01             	add    $0x1,%eax
  80228b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802290:	75 e3                	jne    802275 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
  802297:	eb 0e                	jmp    8022a7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802299:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80229f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022a4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	c1 e8 16             	shr    $0x16,%eax
  8022b4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c0:	f6 c1 01             	test   $0x1,%cl
  8022c3:	74 1d                	je     8022e2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022c5:	c1 ea 0c             	shr    $0xc,%edx
  8022c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022cf:	f6 c2 01             	test   $0x1,%dl
  8022d2:	74 0e                	je     8022e2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022d4:	c1 ea 0c             	shr    $0xc,%edx
  8022d7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022de:	ef 
  8022df:	0f b7 c0             	movzwl %ax,%eax
}
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
  8022e4:	66 90                	xchg   %ax,%ax
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
