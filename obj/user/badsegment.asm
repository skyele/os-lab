
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800045:	e8 15 0c 00 00       	call   800c5f <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x30>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800089:	a1 08 40 80 00       	mov    0x804008,%eax
  80008e:	8b 40 48             	mov    0x48(%eax),%eax
  800091:	68 f8 24 80 00       	push   $0x8024f8
  800096:	50                   	push   %eax
  800097:	68 ea 24 80 00       	push   $0x8024ea
  80009c:	e8 ab 00 00 00       	call   80014c <cprintf>
	close_all();
  8000a1:	e8 c4 10 00 00       	call   80116a <close_all>
	sys_env_destroy(0);
  8000a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ad:	e8 6c 0b 00 00       	call   800c1e <sys_env_destroy>
}
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c1:	8b 13                	mov    (%ebx),%edx
  8000c3:	8d 42 01             	lea    0x1(%edx),%eax
  8000c6:	89 03                	mov    %eax,(%ebx)
  8000c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d4:	74 09                	je     8000df <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000dd:	c9                   	leave  
  8000de:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	68 ff 00 00 00       	push   $0xff
  8000e7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ea:	50                   	push   %eax
  8000eb:	e8 f1 0a 00 00       	call   800be1 <sys_cputs>
		b->idx = 0;
  8000f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	eb db                	jmp    8000d6 <putch+0x1f>

008000fb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800104:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80010b:	00 00 00 
	b.cnt = 0;
  80010e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800115:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800118:	ff 75 0c             	pushl  0xc(%ebp)
  80011b:	ff 75 08             	pushl  0x8(%ebp)
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	50                   	push   %eax
  800125:	68 b7 00 80 00       	push   $0x8000b7
  80012a:	e8 4a 01 00 00       	call   800279 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012f:	83 c4 08             	add    $0x8,%esp
  800132:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800138:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013e:	50                   	push   %eax
  80013f:	e8 9d 0a 00 00       	call   800be1 <sys_cputs>

	return b.cnt;
}
  800144:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800152:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800155:	50                   	push   %eax
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	e8 9d ff ff ff       	call   8000fb <vcprintf>
	va_end(ap);

	return cnt;
}
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

00800160 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 1c             	sub    $0x1c,%esp
  800169:	89 c6                	mov    %eax,%esi
  80016b:	89 d7                	mov    %edx,%edi
  80016d:	8b 45 08             	mov    0x8(%ebp),%eax
  800170:	8b 55 0c             	mov    0xc(%ebp),%edx
  800173:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800176:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80017f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800183:	74 2c                	je     8001b1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800185:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800188:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800195:	39 c2                	cmp    %eax,%edx
  800197:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80019a:	73 43                	jae    8001df <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80019c:	83 eb 01             	sub    $0x1,%ebx
  80019f:	85 db                	test   %ebx,%ebx
  8001a1:	7e 6c                	jle    80020f <printnum+0xaf>
				putch(padc, putdat);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	57                   	push   %edi
  8001a7:	ff 75 18             	pushl  0x18(%ebp)
  8001aa:	ff d6                	call   *%esi
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	eb eb                	jmp    80019c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 20                	push   $0x20
  8001b6:	6a 00                	push   $0x0
  8001b8:	50                   	push   %eax
  8001b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001bf:	89 fa                	mov    %edi,%edx
  8001c1:	89 f0                	mov    %esi,%eax
  8001c3:	e8 98 ff ff ff       	call   800160 <printnum>
		while (--width > 0)
  8001c8:	83 c4 20             	add    $0x20,%esp
  8001cb:	83 eb 01             	sub    $0x1,%ebx
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7e 65                	jle    800237 <printnum+0xd7>
			putch(padc, putdat);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	57                   	push   %edi
  8001d6:	6a 20                	push   $0x20
  8001d8:	ff d6                	call   *%esi
  8001da:	83 c4 10             	add    $0x10,%esp
  8001dd:	eb ec                	jmp    8001cb <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	ff 75 18             	pushl  0x18(%ebp)
  8001e5:	83 eb 01             	sub    $0x1,%ebx
  8001e8:	53                   	push   %ebx
  8001e9:	50                   	push   %eax
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f9:	e8 92 20 00 00       	call   802290 <__udivdi3>
  8001fe:	83 c4 18             	add    $0x18,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	89 fa                	mov    %edi,%edx
  800205:	89 f0                	mov    %esi,%eax
  800207:	e8 54 ff ff ff       	call   800160 <printnum>
  80020c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	57                   	push   %edi
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	ff 75 dc             	pushl  -0x24(%ebp)
  800219:	ff 75 d8             	pushl  -0x28(%ebp)
  80021c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021f:	ff 75 e0             	pushl  -0x20(%ebp)
  800222:	e8 79 21 00 00       	call   8023a0 <__umoddi3>
  800227:	83 c4 14             	add    $0x14,%esp
  80022a:	0f be 80 fd 24 80 00 	movsbl 0x8024fd(%eax),%eax
  800231:	50                   	push   %eax
  800232:	ff d6                	call   *%esi
  800234:	83 c4 10             	add    $0x10,%esp
	}
}
  800237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    

0080023f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800245:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800249:	8b 10                	mov    (%eax),%edx
  80024b:	3b 50 04             	cmp    0x4(%eax),%edx
  80024e:	73 0a                	jae    80025a <sprintputch+0x1b>
		*b->buf++ = ch;
  800250:	8d 4a 01             	lea    0x1(%edx),%ecx
  800253:	89 08                	mov    %ecx,(%eax)
  800255:	8b 45 08             	mov    0x8(%ebp),%eax
  800258:	88 02                	mov    %al,(%edx)
}
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    

0080025c <printfmt>:
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800262:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800265:	50                   	push   %eax
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	ff 75 0c             	pushl  0xc(%ebp)
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	e8 05 00 00 00       	call   800279 <vprintfmt>
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <vprintfmt>:
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 3c             	sub    $0x3c,%esp
  800282:	8b 75 08             	mov    0x8(%ebp),%esi
  800285:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800288:	8b 7d 10             	mov    0x10(%ebp),%edi
  80028b:	e9 32 04 00 00       	jmp    8006c2 <vprintfmt+0x449>
		padc = ' ';
  800290:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800294:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80029b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002b0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002b7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002bc:	8d 47 01             	lea    0x1(%edi),%eax
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c2:	0f b6 17             	movzbl (%edi),%edx
  8002c5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c8:	3c 55                	cmp    $0x55,%al
  8002ca:	0f 87 12 05 00 00    	ja     8007e2 <vprintfmt+0x569>
  8002d0:	0f b6 c0             	movzbl %al,%eax
  8002d3:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  8002da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002dd:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002e1:	eb d9                	jmp    8002bc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002e6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002ea:	eb d0                	jmp    8002bc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002ec:	0f b6 d2             	movzbl %dl,%edx
  8002ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f7:	89 75 08             	mov    %esi,0x8(%ebp)
  8002fa:	eb 03                	jmp    8002ff <vprintfmt+0x86>
  8002fc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800302:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800306:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800309:	8d 72 d0             	lea    -0x30(%edx),%esi
  80030c:	83 fe 09             	cmp    $0x9,%esi
  80030f:	76 eb                	jbe    8002fc <vprintfmt+0x83>
  800311:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800314:	8b 75 08             	mov    0x8(%ebp),%esi
  800317:	eb 14                	jmp    80032d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800319:	8b 45 14             	mov    0x14(%ebp),%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800321:	8b 45 14             	mov    0x14(%ebp),%eax
  800324:	8d 40 04             	lea    0x4(%eax),%eax
  800327:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800331:	79 89                	jns    8002bc <vprintfmt+0x43>
				width = precision, precision = -1;
  800333:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800336:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800339:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800340:	e9 77 ff ff ff       	jmp    8002bc <vprintfmt+0x43>
  800345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800348:	85 c0                	test   %eax,%eax
  80034a:	0f 48 c1             	cmovs  %ecx,%eax
  80034d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800353:	e9 64 ff ff ff       	jmp    8002bc <vprintfmt+0x43>
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800362:	e9 55 ff ff ff       	jmp    8002bc <vprintfmt+0x43>
			lflag++;
  800367:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80036e:	e9 49 ff ff ff       	jmp    8002bc <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800373:	8b 45 14             	mov    0x14(%ebp),%eax
  800376:	8d 78 04             	lea    0x4(%eax),%edi
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	53                   	push   %ebx
  80037d:	ff 30                	pushl  (%eax)
  80037f:	ff d6                	call   *%esi
			break;
  800381:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800384:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800387:	e9 33 03 00 00       	jmp    8006bf <vprintfmt+0x446>
			err = va_arg(ap, int);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8d 78 04             	lea    0x4(%eax),%edi
  800392:	8b 00                	mov    (%eax),%eax
  800394:	99                   	cltd   
  800395:	31 d0                	xor    %edx,%eax
  800397:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800399:	83 f8 11             	cmp    $0x11,%eax
  80039c:	7f 23                	jg     8003c1 <vprintfmt+0x148>
  80039e:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  8003a5:	85 d2                	test   %edx,%edx
  8003a7:	74 18                	je     8003c1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003a9:	52                   	push   %edx
  8003aa:	68 5d 29 80 00       	push   $0x80295d
  8003af:	53                   	push   %ebx
  8003b0:	56                   	push   %esi
  8003b1:	e8 a6 fe ff ff       	call   80025c <printfmt>
  8003b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003bc:	e9 fe 02 00 00       	jmp    8006bf <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003c1:	50                   	push   %eax
  8003c2:	68 15 25 80 00       	push   $0x802515
  8003c7:	53                   	push   %ebx
  8003c8:	56                   	push   %esi
  8003c9:	e8 8e fe ff ff       	call   80025c <printfmt>
  8003ce:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d4:	e9 e6 02 00 00       	jmp    8006bf <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	83 c0 04             	add    $0x4,%eax
  8003df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003e7:	85 c9                	test   %ecx,%ecx
  8003e9:	b8 0e 25 80 00       	mov    $0x80250e,%eax
  8003ee:	0f 45 c1             	cmovne %ecx,%eax
  8003f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8003f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f8:	7e 06                	jle    800400 <vprintfmt+0x187>
  8003fa:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8003fe:	75 0d                	jne    80040d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800400:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800403:	89 c7                	mov    %eax,%edi
  800405:	03 45 e0             	add    -0x20(%ebp),%eax
  800408:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040b:	eb 53                	jmp    800460 <vprintfmt+0x1e7>
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 d8             	pushl  -0x28(%ebp)
  800413:	50                   	push   %eax
  800414:	e8 71 04 00 00       	call   80088a <strnlen>
  800419:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041c:	29 c1                	sub    %eax,%ecx
  80041e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800426:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80042a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80042d:	eb 0f                	jmp    80043e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	53                   	push   %ebx
  800433:	ff 75 e0             	pushl  -0x20(%ebp)
  800436:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	83 ef 01             	sub    $0x1,%edi
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	85 ff                	test   %edi,%edi
  800440:	7f ed                	jg     80042f <vprintfmt+0x1b6>
  800442:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800445:	85 c9                	test   %ecx,%ecx
  800447:	b8 00 00 00 00       	mov    $0x0,%eax
  80044c:	0f 49 c1             	cmovns %ecx,%eax
  80044f:	29 c1                	sub    %eax,%ecx
  800451:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800454:	eb aa                	jmp    800400 <vprintfmt+0x187>
					putch(ch, putdat);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	53                   	push   %ebx
  80045a:	52                   	push   %edx
  80045b:	ff d6                	call   *%esi
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800463:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800465:	83 c7 01             	add    $0x1,%edi
  800468:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80046c:	0f be d0             	movsbl %al,%edx
  80046f:	85 d2                	test   %edx,%edx
  800471:	74 4b                	je     8004be <vprintfmt+0x245>
  800473:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800477:	78 06                	js     80047f <vprintfmt+0x206>
  800479:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80047d:	78 1e                	js     80049d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80047f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800483:	74 d1                	je     800456 <vprintfmt+0x1dd>
  800485:	0f be c0             	movsbl %al,%eax
  800488:	83 e8 20             	sub    $0x20,%eax
  80048b:	83 f8 5e             	cmp    $0x5e,%eax
  80048e:	76 c6                	jbe    800456 <vprintfmt+0x1dd>
					putch('?', putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	6a 3f                	push   $0x3f
  800496:	ff d6                	call   *%esi
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	eb c3                	jmp    800460 <vprintfmt+0x1e7>
  80049d:	89 cf                	mov    %ecx,%edi
  80049f:	eb 0e                	jmp    8004af <vprintfmt+0x236>
				putch(' ', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 20                	push   $0x20
  8004a7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ee                	jg     8004a1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b9:	e9 01 02 00 00       	jmp    8006bf <vprintfmt+0x446>
  8004be:	89 cf                	mov    %ecx,%edi
  8004c0:	eb ed                	jmp    8004af <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004c5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004cc:	e9 eb fd ff ff       	jmp    8002bc <vprintfmt+0x43>
	if (lflag >= 2)
  8004d1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004d5:	7f 21                	jg     8004f8 <vprintfmt+0x27f>
	else if (lflag)
  8004d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004db:	74 68                	je     800545 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e5:	89 c1                	mov    %eax,%ecx
  8004e7:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ea:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8d 40 04             	lea    0x4(%eax),%eax
  8004f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f6:	eb 17                	jmp    80050f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800503:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 40 08             	lea    0x8(%eax),%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80050f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800512:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80051b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051f:	78 3f                	js     800560 <vprintfmt+0x2e7>
			base = 10;
  800521:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800526:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80052a:	0f 84 71 01 00 00    	je     8006a1 <vprintfmt+0x428>
				putch('+', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 2b                	push   $0x2b
  800536:	ff d6                	call   *%esi
  800538:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800540:	e9 5c 01 00 00       	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054d:	89 c1                	mov    %eax,%ecx
  80054f:	c1 f9 1f             	sar    $0x1f,%ecx
  800552:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 40 04             	lea    0x4(%eax),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	eb af                	jmp    80050f <vprintfmt+0x296>
				putch('-', putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	6a 2d                	push   $0x2d
  800566:	ff d6                	call   *%esi
				num = -(long long) num;
  800568:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056e:	f7 d8                	neg    %eax
  800570:	83 d2 00             	adc    $0x0,%edx
  800573:	f7 da                	neg    %edx
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800583:	e9 19 01 00 00       	jmp    8006a1 <vprintfmt+0x428>
	if (lflag >= 2)
  800588:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80058c:	7f 29                	jg     8005b7 <vprintfmt+0x33e>
	else if (lflag)
  80058e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800592:	74 44                	je     8005d8 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	ba 00 00 00 00       	mov    $0x0,%edx
  80059e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b2:	e9 ea 00 00 00       	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 50 04             	mov    0x4(%eax),%edx
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 40 08             	lea    0x8(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d3:	e9 c9 00 00 00       	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f6:	e9 a6 00 00 00       	jmp    8006a1 <vprintfmt+0x428>
			putch('0', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 30                	push   $0x30
  800601:	ff d6                	call   *%esi
	if (lflag >= 2)
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060a:	7f 26                	jg     800632 <vprintfmt+0x3b9>
	else if (lflag)
  80060c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800610:	74 3e                	je     800650 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 40 04             	lea    0x4(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062b:	b8 08 00 00 00       	mov    $0x8,%eax
  800630:	eb 6f                	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 50 04             	mov    0x4(%eax),%edx
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 40 08             	lea    0x8(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800649:	b8 08 00 00 00       	mov    $0x8,%eax
  80064e:	eb 51                	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	ba 00 00 00 00       	mov    $0x0,%edx
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800669:	b8 08 00 00 00       	mov    $0x8,%eax
  80066e:	eb 31                	jmp    8006a1 <vprintfmt+0x428>
			putch('0', putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	53                   	push   %ebx
  800674:	6a 30                	push   $0x30
  800676:	ff d6                	call   *%esi
			putch('x', putdat);
  800678:	83 c4 08             	add    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 78                	push   $0x78
  80067e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800690:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006a8:	52                   	push   %edx
  8006a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b3:	89 da                	mov    %ebx,%edx
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	e8 a4 fa ff ff       	call   800160 <printnum>
			break;
  8006bc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c2:	83 c7 01             	add    $0x1,%edi
  8006c5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c9:	83 f8 25             	cmp    $0x25,%eax
  8006cc:	0f 84 be fb ff ff    	je     800290 <vprintfmt+0x17>
			if (ch == '\0')
  8006d2:	85 c0                	test   %eax,%eax
  8006d4:	0f 84 28 01 00 00    	je     800802 <vprintfmt+0x589>
			putch(ch, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	50                   	push   %eax
  8006df:	ff d6                	call   *%esi
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	eb dc                	jmp    8006c2 <vprintfmt+0x449>
	if (lflag >= 2)
  8006e6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ea:	7f 26                	jg     800712 <vprintfmt+0x499>
	else if (lflag)
  8006ec:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f0:	74 41                	je     800733 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070b:	b8 10 00 00 00       	mov    $0x10,%eax
  800710:	eb 8f                	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 50 04             	mov    0x4(%eax),%edx
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 08             	lea    0x8(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800729:	b8 10 00 00 00       	mov    $0x10,%eax
  80072e:	e9 6e ff ff ff       	jmp    8006a1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074c:	b8 10 00 00 00       	mov    $0x10,%eax
  800751:	e9 4b ff ff ff       	jmp    8006a1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	85 c0                	test   %eax,%eax
  800766:	74 14                	je     80077c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800768:	8b 13                	mov    (%ebx),%edx
  80076a:	83 fa 7f             	cmp    $0x7f,%edx
  80076d:	7f 37                	jg     8007a6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80076f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800771:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	e9 43 ff ff ff       	jmp    8006bf <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80077c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800781:	bf 31 26 80 00       	mov    $0x802631,%edi
							putch(ch, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	50                   	push   %eax
  80078b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80078d:	83 c7 01             	add    $0x1,%edi
  800790:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	85 c0                	test   %eax,%eax
  800799:	75 eb                	jne    800786 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80079b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	e9 19 ff ff ff       	jmp    8006bf <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007a6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ad:	bf 69 26 80 00       	mov    $0x802669,%edi
							putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	50                   	push   %eax
  8007b7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b9:	83 c7 01             	add    $0x1,%edi
  8007bc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	75 eb                	jne    8007b2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cd:	e9 ed fe ff ff       	jmp    8006bf <vprintfmt+0x446>
			putch(ch, putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	6a 25                	push   $0x25
  8007d8:	ff d6                	call   *%esi
			break;
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	e9 dd fe ff ff       	jmp    8006bf <vprintfmt+0x446>
			putch('%', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 25                	push   $0x25
  8007e8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	89 f8                	mov    %edi,%eax
  8007ef:	eb 03                	jmp    8007f4 <vprintfmt+0x57b>
  8007f1:	83 e8 01             	sub    $0x1,%eax
  8007f4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f8:	75 f7                	jne    8007f1 <vprintfmt+0x578>
  8007fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007fd:	e9 bd fe ff ff       	jmp    8006bf <vprintfmt+0x446>
}
  800802:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800805:	5b                   	pop    %ebx
  800806:	5e                   	pop    %esi
  800807:	5f                   	pop    %edi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800816:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800819:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800820:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800827:	85 c0                	test   %eax,%eax
  800829:	74 26                	je     800851 <vsnprintf+0x47>
  80082b:	85 d2                	test   %edx,%edx
  80082d:	7e 22                	jle    800851 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082f:	ff 75 14             	pushl  0x14(%ebp)
  800832:	ff 75 10             	pushl  0x10(%ebp)
  800835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	68 3f 02 80 00       	push   $0x80023f
  80083e:	e8 36 fa ff ff       	call   800279 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800846:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084c:	83 c4 10             	add    $0x10,%esp
}
  80084f:	c9                   	leave  
  800850:	c3                   	ret    
		return -E_INVAL;
  800851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800856:	eb f7                	jmp    80084f <vsnprintf+0x45>

00800858 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800861:	50                   	push   %eax
  800862:	ff 75 10             	pushl  0x10(%ebp)
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 9a ff ff ff       	call   80080a <vsnprintf>
	va_end(ap);

	return rc;
}
  800870:	c9                   	leave  
  800871:	c3                   	ret    

00800872 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800881:	74 05                	je     800888 <strlen+0x16>
		n++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	eb f5                	jmp    80087d <strlen+0xb>
	return n;
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	74 0d                	je     8008a9 <strnlen+0x1f>
  80089c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008a0:	74 05                	je     8008a7 <strnlen+0x1d>
		n++;
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	eb f1                	jmp    800898 <strnlen+0xe>
  8008a7:	89 d0                	mov    %edx,%eax
	return n;
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008be:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c1:	83 c2 01             	add    $0x1,%edx
  8008c4:	84 c9                	test   %cl,%cl
  8008c6:	75 f2                	jne    8008ba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	83 ec 10             	sub    $0x10,%esp
  8008d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d5:	53                   	push   %ebx
  8008d6:	e8 97 ff ff ff       	call   800872 <strlen>
  8008db:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	01 d8                	add    %ebx,%eax
  8008e3:	50                   	push   %eax
  8008e4:	e8 c2 ff ff ff       	call   8008ab <strcpy>
	return dst;
}
  8008e9:	89 d8                	mov    %ebx,%eax
  8008eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	56                   	push   %esi
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fb:	89 c6                	mov    %eax,%esi
  8008fd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800900:	89 c2                	mov    %eax,%edx
  800902:	39 f2                	cmp    %esi,%edx
  800904:	74 11                	je     800917 <strncpy+0x27>
		*dst++ = *src;
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	0f b6 19             	movzbl (%ecx),%ebx
  80090c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090f:	80 fb 01             	cmp    $0x1,%bl
  800912:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800915:	eb eb                	jmp    800902 <strncpy+0x12>
	}
	return ret;
}
  800917:	5b                   	pop    %ebx
  800918:	5e                   	pop    %esi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 75 08             	mov    0x8(%ebp),%esi
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	8b 55 10             	mov    0x10(%ebp),%edx
  800929:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092b:	85 d2                	test   %edx,%edx
  80092d:	74 21                	je     800950 <strlcpy+0x35>
  80092f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800933:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800935:	39 c2                	cmp    %eax,%edx
  800937:	74 14                	je     80094d <strlcpy+0x32>
  800939:	0f b6 19             	movzbl (%ecx),%ebx
  80093c:	84 db                	test   %bl,%bl
  80093e:	74 0b                	je     80094b <strlcpy+0x30>
			*dst++ = *src++;
  800940:	83 c1 01             	add    $0x1,%ecx
  800943:	83 c2 01             	add    $0x1,%edx
  800946:	88 5a ff             	mov    %bl,-0x1(%edx)
  800949:	eb ea                	jmp    800935 <strlcpy+0x1a>
  80094b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80094d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800950:	29 f0                	sub    %esi,%eax
}
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095f:	0f b6 01             	movzbl (%ecx),%eax
  800962:	84 c0                	test   %al,%al
  800964:	74 0c                	je     800972 <strcmp+0x1c>
  800966:	3a 02                	cmp    (%edx),%al
  800968:	75 08                	jne    800972 <strcmp+0x1c>
		p++, q++;
  80096a:	83 c1 01             	add    $0x1,%ecx
  80096d:	83 c2 01             	add    $0x1,%edx
  800970:	eb ed                	jmp    80095f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800972:	0f b6 c0             	movzbl %al,%eax
  800975:	0f b6 12             	movzbl (%edx),%edx
  800978:	29 d0                	sub    %edx,%eax
}
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 c3                	mov    %eax,%ebx
  800988:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098b:	eb 06                	jmp    800993 <strncmp+0x17>
		n--, p++, q++;
  80098d:	83 c0 01             	add    $0x1,%eax
  800990:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800993:	39 d8                	cmp    %ebx,%eax
  800995:	74 16                	je     8009ad <strncmp+0x31>
  800997:	0f b6 08             	movzbl (%eax),%ecx
  80099a:	84 c9                	test   %cl,%cl
  80099c:	74 04                	je     8009a2 <strncmp+0x26>
  80099e:	3a 0a                	cmp    (%edx),%cl
  8009a0:	74 eb                	je     80098d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a2:	0f b6 00             	movzbl (%eax),%eax
  8009a5:	0f b6 12             	movzbl (%edx),%edx
  8009a8:	29 d0                	sub    %edx,%eax
}
  8009aa:	5b                   	pop    %ebx
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    
		return 0;
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	eb f6                	jmp    8009aa <strncmp+0x2e>

008009b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	74 09                	je     8009ce <strchr+0x1a>
		if (*s == c)
  8009c5:	38 ca                	cmp    %cl,%dl
  8009c7:	74 0a                	je     8009d3 <strchr+0x1f>
	for (; *s; s++)
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	eb f0                	jmp    8009be <strchr+0xa>
			return (char *) s;
	return 0;
  8009ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009df:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e2:	38 ca                	cmp    %cl,%dl
  8009e4:	74 09                	je     8009ef <strfind+0x1a>
  8009e6:	84 d2                	test   %dl,%dl
  8009e8:	74 05                	je     8009ef <strfind+0x1a>
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	eb f0                	jmp    8009df <strfind+0xa>
			break;
	return (char *) s;
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	57                   	push   %edi
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009fd:	85 c9                	test   %ecx,%ecx
  8009ff:	74 31                	je     800a32 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a01:	89 f8                	mov    %edi,%eax
  800a03:	09 c8                	or     %ecx,%eax
  800a05:	a8 03                	test   $0x3,%al
  800a07:	75 23                	jne    800a2c <memset+0x3b>
		c &= 0xFF;
  800a09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a0d:	89 d3                	mov    %edx,%ebx
  800a0f:	c1 e3 08             	shl    $0x8,%ebx
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 18             	shl    $0x18,%eax
  800a17:	89 d6                	mov    %edx,%esi
  800a19:	c1 e6 10             	shl    $0x10,%esi
  800a1c:	09 f0                	or     %esi,%eax
  800a1e:	09 c2                	or     %eax,%edx
  800a20:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a25:	89 d0                	mov    %edx,%eax
  800a27:	fc                   	cld    
  800a28:	f3 ab                	rep stos %eax,%es:(%edi)
  800a2a:	eb 06                	jmp    800a32 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	fc                   	cld    
  800a30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a32:	89 f8                	mov    %edi,%eax
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5f                   	pop    %edi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a47:	39 c6                	cmp    %eax,%esi
  800a49:	73 32                	jae    800a7d <memmove+0x44>
  800a4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a4e:	39 c2                	cmp    %eax,%edx
  800a50:	76 2b                	jbe    800a7d <memmove+0x44>
		s += n;
		d += n;
  800a52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 fe                	mov    %edi,%esi
  800a57:	09 ce                	or     %ecx,%esi
  800a59:	09 d6                	or     %edx,%esi
  800a5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a61:	75 0e                	jne    800a71 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a63:	83 ef 04             	sub    $0x4,%edi
  800a66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a6c:	fd                   	std    
  800a6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6f:	eb 09                	jmp    800a7a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a71:	83 ef 01             	sub    $0x1,%edi
  800a74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a77:	fd                   	std    
  800a78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7a:	fc                   	cld    
  800a7b:	eb 1a                	jmp    800a97 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	09 ca                	or     %ecx,%edx
  800a81:	09 f2                	or     %esi,%edx
  800a83:	f6 c2 03             	test   $0x3,%dl
  800a86:	75 0a                	jne    800a92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a8b:	89 c7                	mov    %eax,%edi
  800a8d:	fc                   	cld    
  800a8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a90:	eb 05                	jmp    800a97 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a92:	89 c7                	mov    %eax,%edi
  800a94:	fc                   	cld    
  800a95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a97:	5e                   	pop    %esi
  800a98:	5f                   	pop    %edi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa1:	ff 75 10             	pushl  0x10(%ebp)
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	e8 8a ff ff ff       	call   800a39 <memmove>
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 c6                	mov    %eax,%esi
  800abe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac1:	39 f0                	cmp    %esi,%eax
  800ac3:	74 1c                	je     800ae1 <memcmp+0x30>
		if (*s1 != *s2)
  800ac5:	0f b6 08             	movzbl (%eax),%ecx
  800ac8:	0f b6 1a             	movzbl (%edx),%ebx
  800acb:	38 d9                	cmp    %bl,%cl
  800acd:	75 08                	jne    800ad7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	eb ea                	jmp    800ac1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad7:	0f b6 c1             	movzbl %cl,%eax
  800ada:	0f b6 db             	movzbl %bl,%ebx
  800add:	29 d8                	sub    %ebx,%eax
  800adf:	eb 05                	jmp    800ae6 <memcmp+0x35>
	}

	return 0;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af8:	39 d0                	cmp    %edx,%eax
  800afa:	73 09                	jae    800b05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800afc:	38 08                	cmp    %cl,(%eax)
  800afe:	74 05                	je     800b05 <memfind+0x1b>
	for (; s < ends; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	eb f3                	jmp    800af8 <memfind+0xe>
			break;
	return (void *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b13:	eb 03                	jmp    800b18 <strtol+0x11>
		s++;
  800b15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b18:	0f b6 01             	movzbl (%ecx),%eax
  800b1b:	3c 20                	cmp    $0x20,%al
  800b1d:	74 f6                	je     800b15 <strtol+0xe>
  800b1f:	3c 09                	cmp    $0x9,%al
  800b21:	74 f2                	je     800b15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b23:	3c 2b                	cmp    $0x2b,%al
  800b25:	74 2a                	je     800b51 <strtol+0x4a>
	int neg = 0;
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b2c:	3c 2d                	cmp    $0x2d,%al
  800b2e:	74 2b                	je     800b5b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b36:	75 0f                	jne    800b47 <strtol+0x40>
  800b38:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3b:	74 28                	je     800b65 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b3d:	85 db                	test   %ebx,%ebx
  800b3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b44:	0f 44 d8             	cmove  %eax,%ebx
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4f:	eb 50                	jmp    800ba1 <strtol+0x9a>
		s++;
  800b51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b54:	bf 00 00 00 00       	mov    $0x0,%edi
  800b59:	eb d5                	jmp    800b30 <strtol+0x29>
		s++, neg = 1;
  800b5b:	83 c1 01             	add    $0x1,%ecx
  800b5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b63:	eb cb                	jmp    800b30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b69:	74 0e                	je     800b79 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b6b:	85 db                	test   %ebx,%ebx
  800b6d:	75 d8                	jne    800b47 <strtol+0x40>
		s++, base = 8;
  800b6f:	83 c1 01             	add    $0x1,%ecx
  800b72:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b77:	eb ce                	jmp    800b47 <strtol+0x40>
		s += 2, base = 16;
  800b79:	83 c1 02             	add    $0x2,%ecx
  800b7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b81:	eb c4                	jmp    800b47 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b83:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b86:	89 f3                	mov    %esi,%ebx
  800b88:	80 fb 19             	cmp    $0x19,%bl
  800b8b:	77 29                	ja     800bb6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b8d:	0f be d2             	movsbl %dl,%edx
  800b90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b93:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b96:	7d 30                	jge    800bc8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b98:	83 c1 01             	add    $0x1,%ecx
  800b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba1:	0f b6 11             	movzbl (%ecx),%edx
  800ba4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba7:	89 f3                	mov    %esi,%ebx
  800ba9:	80 fb 09             	cmp    $0x9,%bl
  800bac:	77 d5                	ja     800b83 <strtol+0x7c>
			dig = *s - '0';
  800bae:	0f be d2             	movsbl %dl,%edx
  800bb1:	83 ea 30             	sub    $0x30,%edx
  800bb4:	eb dd                	jmp    800b93 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bb6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb9:	89 f3                	mov    %esi,%ebx
  800bbb:	80 fb 19             	cmp    $0x19,%bl
  800bbe:	77 08                	ja     800bc8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bc0:	0f be d2             	movsbl %dl,%edx
  800bc3:	83 ea 37             	sub    $0x37,%edx
  800bc6:	eb cb                	jmp    800b93 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcc:	74 05                	je     800bd3 <strtol+0xcc>
		*endptr = (char *) s;
  800bce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd3:	89 c2                	mov    %eax,%edx
  800bd5:	f7 da                	neg    %edx
  800bd7:	85 ff                	test   %edi,%edi
  800bd9:	0f 45 c2             	cmovne %edx,%eax
}
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf2:	89 c3                	mov    %eax,%ebx
  800bf4:	89 c7                	mov    %eax,%edi
  800bf6:	89 c6                	mov    %eax,%esi
  800bf8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_cgetc>:

int
sys_cgetc(void)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c05:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0f:	89 d1                	mov    %edx,%ecx
  800c11:	89 d3                	mov    %edx,%ebx
  800c13:	89 d7                	mov    %edx,%edi
  800c15:	89 d6                	mov    %edx,%esi
  800c17:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c34:	89 cb                	mov    %ecx,%ebx
  800c36:	89 cf                	mov    %ecx,%edi
  800c38:	89 ce                	mov    %ecx,%esi
  800c3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7f 08                	jg     800c48 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 03                	push   $0x3
  800c4e:	68 88 28 80 00       	push   $0x802888
  800c53:	6a 43                	push   $0x43
  800c55:	68 a5 28 80 00       	push   $0x8028a5
  800c5a:	e8 89 14 00 00       	call   8020e8 <_panic>

00800c5f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c65:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6f:	89 d1                	mov    %edx,%ecx
  800c71:	89 d3                	mov    %edx,%ebx
  800c73:	89 d7                	mov    %edx,%edi
  800c75:	89 d6                	mov    %edx,%esi
  800c77:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_yield>:

void
sys_yield(void)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8e:	89 d1                	mov    %edx,%ecx
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	89 d7                	mov    %edx,%edi
  800c94:	89 d6                	mov    %edx,%esi
  800c96:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	be 00 00 00 00       	mov    $0x0,%esi
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	89 f7                	mov    %esi,%edi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 04                	push   $0x4
  800ccf:	68 88 28 80 00       	push   $0x802888
  800cd4:	6a 43                	push   $0x43
  800cd6:	68 a5 28 80 00       	push   $0x8028a5
  800cdb:	e8 08 14 00 00       	call   8020e8 <_panic>

00800ce0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfa:	8b 75 18             	mov    0x18(%ebp),%esi
  800cfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	7f 08                	jg     800d0b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0b:	83 ec 0c             	sub    $0xc,%esp
  800d0e:	50                   	push   %eax
  800d0f:	6a 05                	push   $0x5
  800d11:	68 88 28 80 00       	push   $0x802888
  800d16:	6a 43                	push   $0x43
  800d18:	68 a5 28 80 00       	push   $0x8028a5
  800d1d:	e8 c6 13 00 00       	call   8020e8 <_panic>

00800d22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3b:	89 df                	mov    %ebx,%edi
  800d3d:	89 de                	mov    %ebx,%esi
  800d3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7f 08                	jg     800d4d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	83 ec 0c             	sub    $0xc,%esp
  800d50:	50                   	push   %eax
  800d51:	6a 06                	push   $0x6
  800d53:	68 88 28 80 00       	push   $0x802888
  800d58:	6a 43                	push   $0x43
  800d5a:	68 a5 28 80 00       	push   $0x8028a5
  800d5f:	e8 84 13 00 00       	call   8020e8 <_panic>

00800d64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	b8 08 00 00 00       	mov    $0x8,%eax
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	89 de                	mov    %ebx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 08                	push   $0x8
  800d95:	68 88 28 80 00       	push   $0x802888
  800d9a:	6a 43                	push   $0x43
  800d9c:	68 a5 28 80 00       	push   $0x8028a5
  800da1:	e8 42 13 00 00       	call   8020e8 <_panic>

00800da6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
  800dac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbf:	89 df                	mov    %ebx,%edi
  800dc1:	89 de                	mov    %ebx,%esi
  800dc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7f 08                	jg     800dd1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	50                   	push   %eax
  800dd5:	6a 09                	push   $0x9
  800dd7:	68 88 28 80 00       	push   $0x802888
  800ddc:	6a 43                	push   $0x43
  800dde:	68 a5 28 80 00       	push   $0x8028a5
  800de3:	e8 00 13 00 00       	call   8020e8 <_panic>

00800de8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e01:	89 df                	mov    %ebx,%edi
  800e03:	89 de                	mov    %ebx,%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 0a                	push   $0xa
  800e19:	68 88 28 80 00       	push   $0x802888
  800e1e:	6a 43                	push   $0x43
  800e20:	68 a5 28 80 00       	push   $0x8028a5
  800e25:	e8 be 12 00 00       	call   8020e8 <_panic>

00800e2a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3b:	be 00 00 00 00       	mov    $0x0,%esi
  800e40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e46:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e63:	89 cb                	mov    %ecx,%ebx
  800e65:	89 cf                	mov    %ecx,%edi
  800e67:	89 ce                	mov    %ecx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 0d                	push   $0xd
  800e7d:	68 88 28 80 00       	push   $0x802888
  800e82:	6a 43                	push   $0x43
  800e84:	68 a5 28 80 00       	push   $0x8028a5
  800e89:	e8 5a 12 00 00       	call   8020e8 <_panic>

00800e8e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ec2:	89 cb                	mov    %ecx,%ebx
  800ec4:	89 cf                	mov    %ecx,%edi
  800ec6:	89 ce                	mov    %ecx,%esi
  800ec8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eda:	b8 10 00 00 00       	mov    $0x10,%eax
  800edf:	89 d1                	mov    %edx,%ecx
  800ee1:	89 d3                	mov    %edx,%ebx
  800ee3:	89 d7                	mov    %edx,%edi
  800ee5:	89 d6                	mov    %edx,%esi
  800ee7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    

00800eee <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
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
  800eff:	b8 11 00 00 00       	mov    $0x11,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	b8 12 00 00 00       	mov    $0x12,%eax
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f44:	b8 13 00 00 00       	mov    $0x13,%eax
  800f49:	89 df                	mov    %ebx,%edi
  800f4b:	89 de                	mov    %ebx,%esi
  800f4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	7f 08                	jg     800f5b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	50                   	push   %eax
  800f5f:	6a 13                	push   $0x13
  800f61:	68 88 28 80 00       	push   $0x802888
  800f66:	6a 43                	push   $0x43
  800f68:	68 a5 28 80 00       	push   $0x8028a5
  800f6d:	e8 76 11 00 00       	call   8020e8 <_panic>

00800f72 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	57                   	push   %edi
  800f76:	56                   	push   %esi
  800f77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	b8 14 00 00 00       	mov    $0x14,%eax
  800f85:	89 cb                	mov    %ecx,%ebx
  800f87:	89 cf                	mov    %ecx,%edi
  800f89:	89 ce                	mov    %ecx,%esi
  800f8b:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	05 00 00 00 30       	add    $0x30000000,%eax
  800f9d:	c1 e8 0c             	shr    $0xc,%eax
}
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fc1:	89 c2                	mov    %eax,%edx
  800fc3:	c1 ea 16             	shr    $0x16,%edx
  800fc6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fcd:	f6 c2 01             	test   $0x1,%dl
  800fd0:	74 2d                	je     800fff <fd_alloc+0x46>
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	c1 ea 0c             	shr    $0xc,%edx
  800fd7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fde:	f6 c2 01             	test   $0x1,%dl
  800fe1:	74 1c                	je     800fff <fd_alloc+0x46>
  800fe3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fe8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fed:	75 d2                	jne    800fc1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ff8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ffd:	eb 0a                	jmp    801009 <fd_alloc+0x50>
			*fd_store = fd;
  800fff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801002:	89 01                	mov    %eax,(%ecx)
			return 0;
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801011:	83 f8 1f             	cmp    $0x1f,%eax
  801014:	77 30                	ja     801046 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801016:	c1 e0 0c             	shl    $0xc,%eax
  801019:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80101e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801024:	f6 c2 01             	test   $0x1,%dl
  801027:	74 24                	je     80104d <fd_lookup+0x42>
  801029:	89 c2                	mov    %eax,%edx
  80102b:	c1 ea 0c             	shr    $0xc,%edx
  80102e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801035:	f6 c2 01             	test   $0x1,%dl
  801038:	74 1a                	je     801054 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80103a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103d:	89 02                	mov    %eax,(%edx)
	return 0;
  80103f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
		return -E_INVAL;
  801046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104b:	eb f7                	jmp    801044 <fd_lookup+0x39>
		return -E_INVAL;
  80104d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801052:	eb f0                	jmp    801044 <fd_lookup+0x39>
  801054:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801059:	eb e9                	jmp    801044 <fd_lookup+0x39>

0080105b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 08             	sub    $0x8,%esp
  801061:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801064:	ba 00 00 00 00       	mov    $0x0,%edx
  801069:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80106e:	39 08                	cmp    %ecx,(%eax)
  801070:	74 38                	je     8010aa <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801072:	83 c2 01             	add    $0x1,%edx
  801075:	8b 04 95 30 29 80 00 	mov    0x802930(,%edx,4),%eax
  80107c:	85 c0                	test   %eax,%eax
  80107e:	75 ee                	jne    80106e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801080:	a1 08 40 80 00       	mov    0x804008,%eax
  801085:	8b 40 48             	mov    0x48(%eax),%eax
  801088:	83 ec 04             	sub    $0x4,%esp
  80108b:	51                   	push   %ecx
  80108c:	50                   	push   %eax
  80108d:	68 b4 28 80 00       	push   $0x8028b4
  801092:	e8 b5 f0 ff ff       	call   80014c <cprintf>
	*dev = 0;
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    
			*dev = devtab[i];
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010af:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b4:	eb f2                	jmp    8010a8 <dev_lookup+0x4d>

008010b6 <fd_close>:
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 24             	sub    $0x24,%esp
  8010bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8010c2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010cf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d2:	50                   	push   %eax
  8010d3:	e8 33 ff ff ff       	call   80100b <fd_lookup>
  8010d8:	89 c3                	mov    %eax,%ebx
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	78 05                	js     8010e6 <fd_close+0x30>
	    || fd != fd2)
  8010e1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010e4:	74 16                	je     8010fc <fd_close+0x46>
		return (must_exist ? r : 0);
  8010e6:	89 f8                	mov    %edi,%eax
  8010e8:	84 c0                	test   %al,%al
  8010ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ef:	0f 44 d8             	cmove  %eax,%ebx
}
  8010f2:	89 d8                	mov    %ebx,%eax
  8010f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	ff 36                	pushl  (%esi)
  801105:	e8 51 ff ff ff       	call   80105b <dev_lookup>
  80110a:	89 c3                	mov    %eax,%ebx
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 1a                	js     80112d <fd_close+0x77>
		if (dev->dev_close)
  801113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801116:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801119:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80111e:	85 c0                	test   %eax,%eax
  801120:	74 0b                	je     80112d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801122:	83 ec 0c             	sub    $0xc,%esp
  801125:	56                   	push   %esi
  801126:	ff d0                	call   *%eax
  801128:	89 c3                	mov    %eax,%ebx
  80112a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	56                   	push   %esi
  801131:	6a 00                	push   $0x0
  801133:	e8 ea fb ff ff       	call   800d22 <sys_page_unmap>
	return r;
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	eb b5                	jmp    8010f2 <fd_close+0x3c>

0080113d <close>:

int
close(int fdnum)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 bc fe ff ff       	call   80100b <fd_lookup>
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	79 02                	jns    801158 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    
		return fd_close(fd, 1);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	6a 01                	push   $0x1
  80115d:	ff 75 f4             	pushl  -0xc(%ebp)
  801160:	e8 51 ff ff ff       	call   8010b6 <fd_close>
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	eb ec                	jmp    801156 <close+0x19>

0080116a <close_all>:

void
close_all(void)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	53                   	push   %ebx
  80116e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801171:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801176:	83 ec 0c             	sub    $0xc,%esp
  801179:	53                   	push   %ebx
  80117a:	e8 be ff ff ff       	call   80113d <close>
	for (i = 0; i < MAXFD; i++)
  80117f:	83 c3 01             	add    $0x1,%ebx
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	83 fb 20             	cmp    $0x20,%ebx
  801188:	75 ec                	jne    801176 <close_all+0xc>
}
  80118a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	57                   	push   %edi
  801193:	56                   	push   %esi
  801194:	53                   	push   %ebx
  801195:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801198:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80119b:	50                   	push   %eax
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	e8 67 fe ff ff       	call   80100b <fd_lookup>
  8011a4:	89 c3                	mov    %eax,%ebx
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	0f 88 81 00 00 00    	js     801232 <dup+0xa3>
		return r;
	close(newfdnum);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	e8 81 ff ff ff       	call   80113d <close>

	newfd = INDEX2FD(newfdnum);
  8011bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011bf:	c1 e6 0c             	shl    $0xc,%esi
  8011c2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011c8:	83 c4 04             	add    $0x4,%esp
  8011cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ce:	e8 cf fd ff ff       	call   800fa2 <fd2data>
  8011d3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011d5:	89 34 24             	mov    %esi,(%esp)
  8011d8:	e8 c5 fd ff ff       	call   800fa2 <fd2data>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011e2:	89 d8                	mov    %ebx,%eax
  8011e4:	c1 e8 16             	shr    $0x16,%eax
  8011e7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ee:	a8 01                	test   $0x1,%al
  8011f0:	74 11                	je     801203 <dup+0x74>
  8011f2:	89 d8                	mov    %ebx,%eax
  8011f4:	c1 e8 0c             	shr    $0xc,%eax
  8011f7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011fe:	f6 c2 01             	test   $0x1,%dl
  801201:	75 39                	jne    80123c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801203:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801206:	89 d0                	mov    %edx,%eax
  801208:	c1 e8 0c             	shr    $0xc,%eax
  80120b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	25 07 0e 00 00       	and    $0xe07,%eax
  80121a:	50                   	push   %eax
  80121b:	56                   	push   %esi
  80121c:	6a 00                	push   $0x0
  80121e:	52                   	push   %edx
  80121f:	6a 00                	push   $0x0
  801221:	e8 ba fa ff ff       	call   800ce0 <sys_page_map>
  801226:	89 c3                	mov    %eax,%ebx
  801228:	83 c4 20             	add    $0x20,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 31                	js     801260 <dup+0xd1>
		goto err;

	return newfdnum;
  80122f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801232:	89 d8                	mov    %ebx,%eax
  801234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80123c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	25 07 0e 00 00       	and    $0xe07,%eax
  80124b:	50                   	push   %eax
  80124c:	57                   	push   %edi
  80124d:	6a 00                	push   $0x0
  80124f:	53                   	push   %ebx
  801250:	6a 00                	push   $0x0
  801252:	e8 89 fa ff ff       	call   800ce0 <sys_page_map>
  801257:	89 c3                	mov    %eax,%ebx
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	79 a3                	jns    801203 <dup+0x74>
	sys_page_unmap(0, newfd);
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	56                   	push   %esi
  801264:	6a 00                	push   $0x0
  801266:	e8 b7 fa ff ff       	call   800d22 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	57                   	push   %edi
  80126f:	6a 00                	push   $0x0
  801271:	e8 ac fa ff ff       	call   800d22 <sys_page_unmap>
	return r;
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	eb b7                	jmp    801232 <dup+0xa3>

0080127b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	53                   	push   %ebx
  80127f:	83 ec 1c             	sub    $0x1c,%esp
  801282:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801285:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	53                   	push   %ebx
  80128a:	e8 7c fd ff ff       	call   80100b <fd_lookup>
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 3f                	js     8012d5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a0:	ff 30                	pushl  (%eax)
  8012a2:	e8 b4 fd ff ff       	call   80105b <dev_lookup>
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 27                	js     8012d5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b1:	8b 42 08             	mov    0x8(%edx),%eax
  8012b4:	83 e0 03             	and    $0x3,%eax
  8012b7:	83 f8 01             	cmp    $0x1,%eax
  8012ba:	74 1e                	je     8012da <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bf:	8b 40 08             	mov    0x8(%eax),%eax
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	74 35                	je     8012fb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	ff 75 10             	pushl  0x10(%ebp)
  8012cc:	ff 75 0c             	pushl  0xc(%ebp)
  8012cf:	52                   	push   %edx
  8012d0:	ff d0                	call   *%eax
  8012d2:	83 c4 10             	add    $0x10,%esp
}
  8012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012da:	a1 08 40 80 00       	mov    0x804008,%eax
  8012df:	8b 40 48             	mov    0x48(%eax),%eax
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	53                   	push   %ebx
  8012e6:	50                   	push   %eax
  8012e7:	68 f5 28 80 00       	push   $0x8028f5
  8012ec:	e8 5b ee ff ff       	call   80014c <cprintf>
		return -E_INVAL;
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb da                	jmp    8012d5 <read+0x5a>
		return -E_NOT_SUPP;
  8012fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801300:	eb d3                	jmp    8012d5 <read+0x5a>

00801302 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	57                   	push   %edi
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80130e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801311:	bb 00 00 00 00       	mov    $0x0,%ebx
  801316:	39 f3                	cmp    %esi,%ebx
  801318:	73 23                	jae    80133d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	89 f0                	mov    %esi,%eax
  80131f:	29 d8                	sub    %ebx,%eax
  801321:	50                   	push   %eax
  801322:	89 d8                	mov    %ebx,%eax
  801324:	03 45 0c             	add    0xc(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	57                   	push   %edi
  801329:	e8 4d ff ff ff       	call   80127b <read>
		if (m < 0)
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 06                	js     80133b <readn+0x39>
			return m;
		if (m == 0)
  801335:	74 06                	je     80133d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801337:	01 c3                	add    %eax,%ebx
  801339:	eb db                	jmp    801316 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80133d:	89 d8                	mov    %ebx,%eax
  80133f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5f                   	pop    %edi
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    

00801347 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	53                   	push   %ebx
  80134b:	83 ec 1c             	sub    $0x1c,%esp
  80134e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801351:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801354:	50                   	push   %eax
  801355:	53                   	push   %ebx
  801356:	e8 b0 fc ff ff       	call   80100b <fd_lookup>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 3a                	js     80139c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801368:	50                   	push   %eax
  801369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136c:	ff 30                	pushl  (%eax)
  80136e:	e8 e8 fc ff ff       	call   80105b <dev_lookup>
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	78 22                	js     80139c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801381:	74 1e                	je     8013a1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801386:	8b 52 0c             	mov    0xc(%edx),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	74 35                	je     8013c2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80138d:	83 ec 04             	sub    $0x4,%esp
  801390:	ff 75 10             	pushl  0x10(%ebp)
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	50                   	push   %eax
  801397:	ff d2                	call   *%edx
  801399:	83 c4 10             	add    $0x10,%esp
}
  80139c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a6:	8b 40 48             	mov    0x48(%eax),%eax
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	53                   	push   %ebx
  8013ad:	50                   	push   %eax
  8013ae:	68 11 29 80 00       	push   $0x802911
  8013b3:	e8 94 ed ff ff       	call   80014c <cprintf>
		return -E_INVAL;
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb da                	jmp    80139c <write+0x55>
		return -E_NOT_SUPP;
  8013c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c7:	eb d3                	jmp    80139c <write+0x55>

008013c9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	e8 30 fc ff ff       	call   80100b <fd_lookup>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 0e                	js     8013f0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 1c             	sub    $0x1c,%esp
  8013f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	53                   	push   %ebx
  801401:	e8 05 fc ff ff       	call   80100b <fd_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 37                	js     801444 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801417:	ff 30                	pushl  (%eax)
  801419:	e8 3d fc ff ff       	call   80105b <dev_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 1f                	js     801444 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801428:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142c:	74 1b                	je     801449 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80142e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801431:	8b 52 18             	mov    0x18(%edx),%edx
  801434:	85 d2                	test   %edx,%edx
  801436:	74 32                	je     80146a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	50                   	push   %eax
  80143f:	ff d2                	call   *%edx
  801441:	83 c4 10             	add    $0x10,%esp
}
  801444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801447:	c9                   	leave  
  801448:	c3                   	ret    
			thisenv->env_id, fdnum);
  801449:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80144e:	8b 40 48             	mov    0x48(%eax),%eax
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	53                   	push   %ebx
  801455:	50                   	push   %eax
  801456:	68 d4 28 80 00       	push   $0x8028d4
  80145b:	e8 ec ec ff ff       	call   80014c <cprintf>
		return -E_INVAL;
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb da                	jmp    801444 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80146a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146f:	eb d3                	jmp    801444 <ftruncate+0x52>

00801471 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 1c             	sub    $0x1c,%esp
  801478:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	ff 75 08             	pushl  0x8(%ebp)
  801482:	e8 84 fb ff ff       	call   80100b <fd_lookup>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 4b                	js     8014d9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148e:	83 ec 08             	sub    $0x8,%esp
  801491:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	ff 30                	pushl  (%eax)
  80149a:	e8 bc fb ff ff       	call   80105b <dev_lookup>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 33                	js     8014d9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ad:	74 2f                	je     8014de <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014af:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014b2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014b9:	00 00 00 
	stat->st_isdir = 0;
  8014bc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014c3:	00 00 00 
	stat->st_dev = dev;
  8014c6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	53                   	push   %ebx
  8014d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d3:	ff 50 14             	call   *0x14(%eax)
  8014d6:	83 c4 10             	add    $0x10,%esp
}
  8014d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    
		return -E_NOT_SUPP;
  8014de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e3:	eb f4                	jmp    8014d9 <fstat+0x68>

008014e5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	56                   	push   %esi
  8014e9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	6a 00                	push   $0x0
  8014ef:	ff 75 08             	pushl  0x8(%ebp)
  8014f2:	e8 22 02 00 00       	call   801719 <open>
  8014f7:	89 c3                	mov    %eax,%ebx
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 1b                	js     80151b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801500:	83 ec 08             	sub    $0x8,%esp
  801503:	ff 75 0c             	pushl  0xc(%ebp)
  801506:	50                   	push   %eax
  801507:	e8 65 ff ff ff       	call   801471 <fstat>
  80150c:	89 c6                	mov    %eax,%esi
	close(fd);
  80150e:	89 1c 24             	mov    %ebx,(%esp)
  801511:	e8 27 fc ff ff       	call   80113d <close>
	return r;
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	89 f3                	mov    %esi,%ebx
}
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
  801529:	89 c6                	mov    %eax,%esi
  80152b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80152d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801534:	74 27                	je     80155d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801536:	6a 07                	push   $0x7
  801538:	68 00 50 80 00       	push   $0x805000
  80153d:	56                   	push   %esi
  80153e:	ff 35 00 40 80 00    	pushl  0x804000
  801544:	e8 69 0c 00 00       	call   8021b2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801549:	83 c4 0c             	add    $0xc,%esp
  80154c:	6a 00                	push   $0x0
  80154e:	53                   	push   %ebx
  80154f:	6a 00                	push   $0x0
  801551:	e8 f3 0b 00 00       	call   802149 <ipc_recv>
}
  801556:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	6a 01                	push   $0x1
  801562:	e8 a3 0c 00 00       	call   80220a <ipc_find_env>
  801567:	a3 00 40 80 00       	mov    %eax,0x804000
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	eb c5                	jmp    801536 <fsipc+0x12>

00801571 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8b 40 0c             	mov    0xc(%eax),%eax
  80157d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	b8 02 00 00 00       	mov    $0x2,%eax
  801594:	e8 8b ff ff ff       	call   801524 <fsipc>
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <devfile_flush>:
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b6:	e8 69 ff ff ff       	call   801524 <fsipc>
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <devfile_stat>:
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	53                   	push   %ebx
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8015dc:	e8 43 ff ff ff       	call   801524 <fsipc>
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 2c                	js     801611 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	68 00 50 80 00       	push   $0x805000
  8015ed:	53                   	push   %ebx
  8015ee:	e8 b8 f2 ff ff       	call   8008ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015f3:	a1 80 50 80 00       	mov    0x805080,%eax
  8015f8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015fe:	a1 84 50 80 00       	mov    0x805084,%eax
  801603:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <devfile_write>:
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8b 40 0c             	mov    0xc(%eax),%eax
  801626:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80162b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801631:	53                   	push   %ebx
  801632:	ff 75 0c             	pushl  0xc(%ebp)
  801635:	68 08 50 80 00       	push   $0x805008
  80163a:	e8 5c f4 ff ff       	call   800a9b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	b8 04 00 00 00       	mov    $0x4,%eax
  801649:	e8 d6 fe ff ff       	call   801524 <fsipc>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 0b                	js     801660 <devfile_write+0x4a>
	assert(r <= n);
  801655:	39 d8                	cmp    %ebx,%eax
  801657:	77 0c                	ja     801665 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801659:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165e:	7f 1e                	jg     80167e <devfile_write+0x68>
}
  801660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801663:	c9                   	leave  
  801664:	c3                   	ret    
	assert(r <= n);
  801665:	68 44 29 80 00       	push   $0x802944
  80166a:	68 4b 29 80 00       	push   $0x80294b
  80166f:	68 98 00 00 00       	push   $0x98
  801674:	68 60 29 80 00       	push   $0x802960
  801679:	e8 6a 0a 00 00       	call   8020e8 <_panic>
	assert(r <= PGSIZE);
  80167e:	68 6b 29 80 00       	push   $0x80296b
  801683:	68 4b 29 80 00       	push   $0x80294b
  801688:	68 99 00 00 00       	push   $0x99
  80168d:	68 60 29 80 00       	push   $0x802960
  801692:	e8 51 0a 00 00       	call   8020e8 <_panic>

00801697 <devfile_read>:
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016aa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ba:	e8 65 fe ff ff       	call   801524 <fsipc>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 1f                	js     8016e4 <devfile_read+0x4d>
	assert(r <= n);
  8016c5:	39 f0                	cmp    %esi,%eax
  8016c7:	77 24                	ja     8016ed <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016c9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ce:	7f 33                	jg     801703 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	50                   	push   %eax
  8016d4:	68 00 50 80 00       	push   $0x805000
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	e8 58 f3 ff ff       	call   800a39 <memmove>
	return r;
  8016e1:	83 c4 10             	add    $0x10,%esp
}
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5e                   	pop    %esi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    
	assert(r <= n);
  8016ed:	68 44 29 80 00       	push   $0x802944
  8016f2:	68 4b 29 80 00       	push   $0x80294b
  8016f7:	6a 7c                	push   $0x7c
  8016f9:	68 60 29 80 00       	push   $0x802960
  8016fe:	e8 e5 09 00 00       	call   8020e8 <_panic>
	assert(r <= PGSIZE);
  801703:	68 6b 29 80 00       	push   $0x80296b
  801708:	68 4b 29 80 00       	push   $0x80294b
  80170d:	6a 7d                	push   $0x7d
  80170f:	68 60 29 80 00       	push   $0x802960
  801714:	e8 cf 09 00 00       	call   8020e8 <_panic>

00801719 <open>:
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	56                   	push   %esi
  80171d:	53                   	push   %ebx
  80171e:	83 ec 1c             	sub    $0x1c,%esp
  801721:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801724:	56                   	push   %esi
  801725:	e8 48 f1 ff ff       	call   800872 <strlen>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801732:	7f 6c                	jg     8017a0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	e8 79 f8 ff ff       	call   800fb9 <fd_alloc>
  801740:	89 c3                	mov    %eax,%ebx
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	78 3c                	js     801785 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	56                   	push   %esi
  80174d:	68 00 50 80 00       	push   $0x805000
  801752:	e8 54 f1 ff ff       	call   8008ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80175f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801762:	b8 01 00 00 00       	mov    $0x1,%eax
  801767:	e8 b8 fd ff ff       	call   801524 <fsipc>
  80176c:	89 c3                	mov    %eax,%ebx
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 19                	js     80178e <open+0x75>
	return fd2num(fd);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 f4             	pushl  -0xc(%ebp)
  80177b:	e8 12 f8 ff ff       	call   800f92 <fd2num>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
}
  801785:	89 d8                	mov    %ebx,%eax
  801787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    
		fd_close(fd, 0);
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	6a 00                	push   $0x0
  801793:	ff 75 f4             	pushl  -0xc(%ebp)
  801796:	e8 1b f9 ff ff       	call   8010b6 <fd_close>
		return r;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb e5                	jmp    801785 <open+0x6c>
		return -E_BAD_PATH;
  8017a0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a5:	eb de                	jmp    801785 <open+0x6c>

008017a7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b7:	e8 68 fd ff ff       	call   801524 <fsipc>
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017c4:	68 77 29 80 00       	push   $0x802977
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	e8 da f0 ff ff       	call   8008ab <strcpy>
	return 0;
}
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <devsock_close>:
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	53                   	push   %ebx
  8017dc:	83 ec 10             	sub    $0x10,%esp
  8017df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017e2:	53                   	push   %ebx
  8017e3:	e8 61 0a 00 00       	call   802249 <pageref>
  8017e8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017f0:	83 f8 01             	cmp    $0x1,%eax
  8017f3:	74 07                	je     8017fc <devsock_close+0x24>
}
  8017f5:	89 d0                	mov    %edx,%eax
  8017f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	ff 73 0c             	pushl  0xc(%ebx)
  801802:	e8 b9 02 00 00       	call   801ac0 <nsipc_close>
  801807:	89 c2                	mov    %eax,%edx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	eb e7                	jmp    8017f5 <devsock_close+0x1d>

0080180e <devsock_write>:
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801814:	6a 00                	push   $0x0
  801816:	ff 75 10             	pushl  0x10(%ebp)
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	ff 70 0c             	pushl  0xc(%eax)
  801822:	e8 76 03 00 00       	call   801b9d <nsipc_send>
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <devsock_read>:
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80182f:	6a 00                	push   $0x0
  801831:	ff 75 10             	pushl  0x10(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	ff 70 0c             	pushl  0xc(%eax)
  80183d:	e8 ef 02 00 00       	call   801b31 <nsipc_recv>
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <fd2sockid>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80184a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	e8 b7 f7 ff ff       	call   80100b <fd_lookup>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	78 10                	js     80186b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801864:	39 08                	cmp    %ecx,(%eax)
  801866:	75 05                	jne    80186d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801868:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    
		return -E_NOT_SUPP;
  80186d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801872:	eb f7                	jmp    80186b <fd2sockid+0x27>

00801874 <alloc_sockfd>:
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
  801879:	83 ec 1c             	sub    $0x1c,%esp
  80187c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80187e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801881:	50                   	push   %eax
  801882:	e8 32 f7 ff ff       	call   800fb9 <fd_alloc>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 43                	js     8018d3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 07 04 00 00       	push   $0x407
  801898:	ff 75 f4             	pushl  -0xc(%ebp)
  80189b:	6a 00                	push   $0x0
  80189d:	e8 fb f3 ff ff       	call   800c9d <sys_page_alloc>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 28                	js     8018d3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018b4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018c0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018c3:	83 ec 0c             	sub    $0xc,%esp
  8018c6:	50                   	push   %eax
  8018c7:	e8 c6 f6 ff ff       	call   800f92 <fd2num>
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	eb 0c                	jmp    8018df <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	56                   	push   %esi
  8018d7:	e8 e4 01 00 00       	call   801ac0 <nsipc_close>
		return r;
  8018dc:	83 c4 10             	add    $0x10,%esp
}
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <accept>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	e8 4e ff ff ff       	call   801844 <fd2sockid>
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 1b                	js     801915 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	ff 75 10             	pushl  0x10(%ebp)
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	50                   	push   %eax
  801904:	e8 0e 01 00 00       	call   801a17 <nsipc_accept>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 05                	js     801915 <accept+0x2d>
	return alloc_sockfd(r);
  801910:	e8 5f ff ff ff       	call   801874 <alloc_sockfd>
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <bind>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	e8 1f ff ff ff       	call   801844 <fd2sockid>
  801925:	85 c0                	test   %eax,%eax
  801927:	78 12                	js     80193b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	50                   	push   %eax
  801933:	e8 31 01 00 00       	call   801a69 <nsipc_bind>
  801938:	83 c4 10             	add    $0x10,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <shutdown>:
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	e8 f9 fe ff ff       	call   801844 <fd2sockid>
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 0f                	js     80195e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	50                   	push   %eax
  801956:	e8 43 01 00 00       	call   801a9e <nsipc_shutdown>
  80195b:	83 c4 10             	add    $0x10,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <connect>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	e8 d6 fe ff ff       	call   801844 <fd2sockid>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 12                	js     801984 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	e8 59 01 00 00       	call   801ada <nsipc_connect>
  801981:	83 c4 10             	add    $0x10,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <listen>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	e8 b0 fe ff ff       	call   801844 <fd2sockid>
  801994:	85 c0                	test   %eax,%eax
  801996:	78 0f                	js     8019a7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	e8 6b 01 00 00       	call   801b0f <nsipc_listen>
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	e8 3e 02 00 00       	call   801bfb <nsipc_socket>
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 05                	js     8019c9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019c4:	e8 ab fe ff ff       	call   801874 <alloc_sockfd>
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019d4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019db:	74 26                	je     801a03 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019dd:	6a 07                	push   $0x7
  8019df:	68 00 60 80 00       	push   $0x806000
  8019e4:	53                   	push   %ebx
  8019e5:	ff 35 04 40 80 00    	pushl  0x804004
  8019eb:	e8 c2 07 00 00       	call   8021b2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019f0:	83 c4 0c             	add    $0xc,%esp
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	e8 4b 07 00 00       	call   802149 <ipc_recv>
}
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	6a 02                	push   $0x2
  801a08:	e8 fd 07 00 00       	call   80220a <ipc_find_env>
  801a0d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	eb c6                	jmp    8019dd <nsipc+0x12>

00801a17 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a27:	8b 06                	mov    (%esi),%eax
  801a29:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a33:	e8 93 ff ff ff       	call   8019cb <nsipc>
  801a38:	89 c3                	mov    %eax,%ebx
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	79 09                	jns    801a47 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a3e:	89 d8                	mov    %ebx,%eax
  801a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	ff 35 10 60 80 00    	pushl  0x806010
  801a50:	68 00 60 80 00       	push   $0x806000
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	e8 dc ef ff ff       	call   800a39 <memmove>
		*addrlen = ret->ret_addrlen;
  801a5d:	a1 10 60 80 00       	mov    0x806010,%eax
  801a62:	89 06                	mov    %eax,(%esi)
  801a64:	83 c4 10             	add    $0x10,%esp
	return r;
  801a67:	eb d5                	jmp    801a3e <nsipc_accept+0x27>

00801a69 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	53                   	push   %ebx
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a7b:	53                   	push   %ebx
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	68 04 60 80 00       	push   $0x806004
  801a84:	e8 b0 ef ff ff       	call   800a39 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a89:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a8f:	b8 02 00 00 00       	mov    $0x2,%eax
  801a94:	e8 32 ff ff ff       	call   8019cb <nsipc>
}
  801a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ab4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab9:	e8 0d ff ff ff       	call   8019cb <nsipc>
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ace:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad3:	e8 f3 fe ff ff       	call   8019cb <nsipc>
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	53                   	push   %ebx
  801ade:	83 ec 08             	sub    $0x8,%esp
  801ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801aec:	53                   	push   %ebx
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	68 04 60 80 00       	push   $0x806004
  801af5:	e8 3f ef ff ff       	call   800a39 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801afa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b00:	b8 05 00 00 00       	mov    $0x5,%eax
  801b05:	e8 c1 fe ff ff       	call   8019cb <nsipc>
}
  801b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b20:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b25:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2a:	e8 9c fe ff ff       	call   8019cb <nsipc>
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b41:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b4f:	b8 07 00 00 00       	mov    $0x7,%eax
  801b54:	e8 72 fe ff ff       	call   8019cb <nsipc>
  801b59:	89 c3                	mov    %eax,%ebx
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 1f                	js     801b7e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b5f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b64:	7f 21                	jg     801b87 <nsipc_recv+0x56>
  801b66:	39 c6                	cmp    %eax,%esi
  801b68:	7c 1d                	jl     801b87 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	50                   	push   %eax
  801b6e:	68 00 60 80 00       	push   $0x806000
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	e8 be ee ff ff       	call   800a39 <memmove>
  801b7b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b87:	68 83 29 80 00       	push   $0x802983
  801b8c:	68 4b 29 80 00       	push   $0x80294b
  801b91:	6a 62                	push   $0x62
  801b93:	68 98 29 80 00       	push   $0x802998
  801b98:	e8 4b 05 00 00       	call   8020e8 <_panic>

00801b9d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	53                   	push   %ebx
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801baf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bb5:	7f 2e                	jg     801be5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	53                   	push   %ebx
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	68 0c 60 80 00       	push   $0x80600c
  801bc3:	e8 71 ee ff ff       	call   800a39 <memmove>
	nsipcbuf.send.req_size = size;
  801bc8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bce:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bd6:	b8 08 00 00 00       	mov    $0x8,%eax
  801bdb:	e8 eb fd ff ff       	call   8019cb <nsipc>
}
  801be0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    
	assert(size < 1600);
  801be5:	68 a4 29 80 00       	push   $0x8029a4
  801bea:	68 4b 29 80 00       	push   $0x80294b
  801bef:	6a 6d                	push   $0x6d
  801bf1:	68 98 29 80 00       	push   $0x802998
  801bf6:	e8 ed 04 00 00       	call   8020e8 <_panic>

00801bfb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c11:	8b 45 10             	mov    0x10(%ebp),%eax
  801c14:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c19:	b8 09 00 00 00       	mov    $0x9,%eax
  801c1e:	e8 a8 fd ff ff       	call   8019cb <nsipc>
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	56                   	push   %esi
  801c29:	53                   	push   %ebx
  801c2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c2d:	83 ec 0c             	sub    $0xc,%esp
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	e8 6a f3 ff ff       	call   800fa2 <fd2data>
  801c38:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c3a:	83 c4 08             	add    $0x8,%esp
  801c3d:	68 b0 29 80 00       	push   $0x8029b0
  801c42:	53                   	push   %ebx
  801c43:	e8 63 ec ff ff       	call   8008ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c48:	8b 46 04             	mov    0x4(%esi),%eax
  801c4b:	2b 06                	sub    (%esi),%eax
  801c4d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c53:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c5a:	00 00 00 
	stat->st_dev = &devpipe;
  801c5d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c64:	30 80 00 
	return 0;
}
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    

00801c73 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	53                   	push   %ebx
  801c77:	83 ec 0c             	sub    $0xc,%esp
  801c7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c7d:	53                   	push   %ebx
  801c7e:	6a 00                	push   $0x0
  801c80:	e8 9d f0 ff ff       	call   800d22 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c85:	89 1c 24             	mov    %ebx,(%esp)
  801c88:	e8 15 f3 ff ff       	call   800fa2 <fd2data>
  801c8d:	83 c4 08             	add    $0x8,%esp
  801c90:	50                   	push   %eax
  801c91:	6a 00                	push   $0x0
  801c93:	e8 8a f0 ff ff       	call   800d22 <sys_page_unmap>
}
  801c98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <_pipeisclosed>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	57                   	push   %edi
  801ca1:	56                   	push   %esi
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 1c             	sub    $0x1c,%esp
  801ca6:	89 c7                	mov    %eax,%edi
  801ca8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801caa:	a1 08 40 80 00       	mov    0x804008,%eax
  801caf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cb2:	83 ec 0c             	sub    $0xc,%esp
  801cb5:	57                   	push   %edi
  801cb6:	e8 8e 05 00 00       	call   802249 <pageref>
  801cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cbe:	89 34 24             	mov    %esi,(%esp)
  801cc1:	e8 83 05 00 00       	call   802249 <pageref>
		nn = thisenv->env_runs;
  801cc6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ccc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ccf:	83 c4 10             	add    $0x10,%esp
  801cd2:	39 cb                	cmp    %ecx,%ebx
  801cd4:	74 1b                	je     801cf1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cd9:	75 cf                	jne    801caa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cdb:	8b 42 58             	mov    0x58(%edx),%eax
  801cde:	6a 01                	push   $0x1
  801ce0:	50                   	push   %eax
  801ce1:	53                   	push   %ebx
  801ce2:	68 b7 29 80 00       	push   $0x8029b7
  801ce7:	e8 60 e4 ff ff       	call   80014c <cprintf>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	eb b9                	jmp    801caa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cf1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf4:	0f 94 c0             	sete   %al
  801cf7:	0f b6 c0             	movzbl %al,%eax
}
  801cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5f                   	pop    %edi
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    

00801d02 <devpipe_write>:
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	57                   	push   %edi
  801d06:	56                   	push   %esi
  801d07:	53                   	push   %ebx
  801d08:	83 ec 28             	sub    $0x28,%esp
  801d0b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d0e:	56                   	push   %esi
  801d0f:	e8 8e f2 ff ff       	call   800fa2 <fd2data>
  801d14:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d16:	83 c4 10             	add    $0x10,%esp
  801d19:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d21:	74 4f                	je     801d72 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d23:	8b 43 04             	mov    0x4(%ebx),%eax
  801d26:	8b 0b                	mov    (%ebx),%ecx
  801d28:	8d 51 20             	lea    0x20(%ecx),%edx
  801d2b:	39 d0                	cmp    %edx,%eax
  801d2d:	72 14                	jb     801d43 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d2f:	89 da                	mov    %ebx,%edx
  801d31:	89 f0                	mov    %esi,%eax
  801d33:	e8 65 ff ff ff       	call   801c9d <_pipeisclosed>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	75 3b                	jne    801d77 <devpipe_write+0x75>
			sys_yield();
  801d3c:	e8 3d ef ff ff       	call   800c7e <sys_yield>
  801d41:	eb e0                	jmp    801d23 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d46:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d4a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	c1 fa 1f             	sar    $0x1f,%edx
  801d52:	89 d1                	mov    %edx,%ecx
  801d54:	c1 e9 1b             	shr    $0x1b,%ecx
  801d57:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d5a:	83 e2 1f             	and    $0x1f,%edx
  801d5d:	29 ca                	sub    %ecx,%edx
  801d5f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d63:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d67:	83 c0 01             	add    $0x1,%eax
  801d6a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d6d:	83 c7 01             	add    $0x1,%edi
  801d70:	eb ac                	jmp    801d1e <devpipe_write+0x1c>
	return i;
  801d72:	8b 45 10             	mov    0x10(%ebp),%eax
  801d75:	eb 05                	jmp    801d7c <devpipe_write+0x7a>
				return 0;
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <devpipe_read>:
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	57                   	push   %edi
  801d88:	56                   	push   %esi
  801d89:	53                   	push   %ebx
  801d8a:	83 ec 18             	sub    $0x18,%esp
  801d8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d90:	57                   	push   %edi
  801d91:	e8 0c f2 ff ff       	call   800fa2 <fd2data>
  801d96:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	be 00 00 00 00       	mov    $0x0,%esi
  801da0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da3:	75 14                	jne    801db9 <devpipe_read+0x35>
	return i;
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	eb 02                	jmp    801dac <devpipe_read+0x28>
				return i;
  801daa:	89 f0                	mov    %esi,%eax
}
  801dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
			sys_yield();
  801db4:	e8 c5 ee ff ff       	call   800c7e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801db9:	8b 03                	mov    (%ebx),%eax
  801dbb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dbe:	75 18                	jne    801dd8 <devpipe_read+0x54>
			if (i > 0)
  801dc0:	85 f6                	test   %esi,%esi
  801dc2:	75 e6                	jne    801daa <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dc4:	89 da                	mov    %ebx,%edx
  801dc6:	89 f8                	mov    %edi,%eax
  801dc8:	e8 d0 fe ff ff       	call   801c9d <_pipeisclosed>
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	74 e3                	je     801db4 <devpipe_read+0x30>
				return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	eb d4                	jmp    801dac <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd8:	99                   	cltd   
  801dd9:	c1 ea 1b             	shr    $0x1b,%edx
  801ddc:	01 d0                	add    %edx,%eax
  801dde:	83 e0 1f             	and    $0x1f,%eax
  801de1:	29 d0                	sub    %edx,%eax
  801de3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801deb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dee:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801df1:	83 c6 01             	add    $0x1,%esi
  801df4:	eb aa                	jmp    801da0 <devpipe_read+0x1c>

00801df6 <pipe>:
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	56                   	push   %esi
  801dfa:	53                   	push   %ebx
  801dfb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	e8 b2 f1 ff ff       	call   800fb9 <fd_alloc>
  801e07:	89 c3                	mov    %eax,%ebx
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	0f 88 23 01 00 00    	js     801f37 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	68 07 04 00 00       	push   $0x407
  801e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1f:	6a 00                	push   $0x0
  801e21:	e8 77 ee ff ff       	call   800c9d <sys_page_alloc>
  801e26:	89 c3                	mov    %eax,%ebx
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	0f 88 04 01 00 00    	js     801f37 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e33:	83 ec 0c             	sub    $0xc,%esp
  801e36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e39:	50                   	push   %eax
  801e3a:	e8 7a f1 ff ff       	call   800fb9 <fd_alloc>
  801e3f:	89 c3                	mov    %eax,%ebx
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	85 c0                	test   %eax,%eax
  801e46:	0f 88 db 00 00 00    	js     801f27 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	68 07 04 00 00       	push   $0x407
  801e54:	ff 75 f0             	pushl  -0x10(%ebp)
  801e57:	6a 00                	push   $0x0
  801e59:	e8 3f ee ff ff       	call   800c9d <sys_page_alloc>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	85 c0                	test   %eax,%eax
  801e65:	0f 88 bc 00 00 00    	js     801f27 <pipe+0x131>
	va = fd2data(fd0);
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e71:	e8 2c f1 ff ff       	call   800fa2 <fd2data>
  801e76:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e78:	83 c4 0c             	add    $0xc,%esp
  801e7b:	68 07 04 00 00       	push   $0x407
  801e80:	50                   	push   %eax
  801e81:	6a 00                	push   $0x0
  801e83:	e8 15 ee ff ff       	call   800c9d <sys_page_alloc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 88 82 00 00 00    	js     801f17 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9b:	e8 02 f1 ff ff       	call   800fa2 <fd2data>
  801ea0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ea7:	50                   	push   %eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	56                   	push   %esi
  801eab:	6a 00                	push   $0x0
  801ead:	e8 2e ee ff ff       	call   800ce0 <sys_page_map>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 20             	add    $0x20,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 4e                	js     801f09 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ebb:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee4:	e8 a9 f0 ff ff       	call   800f92 <fd2num>
  801ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801eee:	83 c4 04             	add    $0x4,%esp
  801ef1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef4:	e8 99 f0 ff ff       	call   800f92 <fd2num>
  801ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f07:	eb 2e                	jmp    801f37 <pipe+0x141>
	sys_page_unmap(0, va);
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	56                   	push   %esi
  801f0d:	6a 00                	push   $0x0
  801f0f:	e8 0e ee ff ff       	call   800d22 <sys_page_unmap>
  801f14:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f17:	83 ec 08             	sub    $0x8,%esp
  801f1a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1d:	6a 00                	push   $0x0
  801f1f:	e8 fe ed ff ff       	call   800d22 <sys_page_unmap>
  801f24:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2d:	6a 00                	push   $0x0
  801f2f:	e8 ee ed ff ff       	call   800d22 <sys_page_unmap>
  801f34:	83 c4 10             	add    $0x10,%esp
}
  801f37:	89 d8                	mov    %ebx,%eax
  801f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <pipeisclosed>:
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f49:	50                   	push   %eax
  801f4a:	ff 75 08             	pushl  0x8(%ebp)
  801f4d:	e8 b9 f0 ff ff       	call   80100b <fd_lookup>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	78 18                	js     801f71 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5f:	e8 3e f0 ff ff       	call   800fa2 <fd2data>
	return _pipeisclosed(fd, p);
  801f64:	89 c2                	mov    %eax,%edx
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	e8 2f fd ff ff       	call   801c9d <_pipeisclosed>
  801f6e:	83 c4 10             	add    $0x10,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	c3                   	ret    

00801f79 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f7f:	68 cf 29 80 00       	push   $0x8029cf
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	e8 1f e9 ff ff       	call   8008ab <strcpy>
	return 0;
}
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <devcons_write>:
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	57                   	push   %edi
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f9f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fa4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801faa:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fad:	73 31                	jae    801fe0 <devcons_write+0x4d>
		m = n - tot;
  801faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fb2:	29 f3                	sub    %esi,%ebx
  801fb4:	83 fb 7f             	cmp    $0x7f,%ebx
  801fb7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fbc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	53                   	push   %ebx
  801fc3:	89 f0                	mov    %esi,%eax
  801fc5:	03 45 0c             	add    0xc(%ebp),%eax
  801fc8:	50                   	push   %eax
  801fc9:	57                   	push   %edi
  801fca:	e8 6a ea ff ff       	call   800a39 <memmove>
		sys_cputs(buf, m);
  801fcf:	83 c4 08             	add    $0x8,%esp
  801fd2:	53                   	push   %ebx
  801fd3:	57                   	push   %edi
  801fd4:	e8 08 ec ff ff       	call   800be1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fd9:	01 de                	add    %ebx,%esi
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	eb ca                	jmp    801faa <devcons_write+0x17>
}
  801fe0:	89 f0                	mov    %esi,%eax
  801fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe5:	5b                   	pop    %ebx
  801fe6:	5e                   	pop    %esi
  801fe7:	5f                   	pop    %edi
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    

00801fea <devcons_read>:
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ff5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff9:	74 21                	je     80201c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ffb:	e8 ff eb ff ff       	call   800bff <sys_cgetc>
  802000:	85 c0                	test   %eax,%eax
  802002:	75 07                	jne    80200b <devcons_read+0x21>
		sys_yield();
  802004:	e8 75 ec ff ff       	call   800c7e <sys_yield>
  802009:	eb f0                	jmp    801ffb <devcons_read+0x11>
	if (c < 0)
  80200b:	78 0f                	js     80201c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80200d:	83 f8 04             	cmp    $0x4,%eax
  802010:	74 0c                	je     80201e <devcons_read+0x34>
	*(char*)vbuf = c;
  802012:	8b 55 0c             	mov    0xc(%ebp),%edx
  802015:	88 02                	mov    %al,(%edx)
	return 1;
  802017:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    
		return 0;
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	eb f7                	jmp    80201c <devcons_read+0x32>

00802025 <cputchar>:
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802031:	6a 01                	push   $0x1
  802033:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802036:	50                   	push   %eax
  802037:	e8 a5 eb ff ff       	call   800be1 <sys_cputs>
}
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <getchar>:
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802047:	6a 01                	push   $0x1
  802049:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80204c:	50                   	push   %eax
  80204d:	6a 00                	push   $0x0
  80204f:	e8 27 f2 ff ff       	call   80127b <read>
	if (r < 0)
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	85 c0                	test   %eax,%eax
  802059:	78 06                	js     802061 <getchar+0x20>
	if (r < 1)
  80205b:	74 06                	je     802063 <getchar+0x22>
	return c;
  80205d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    
		return -E_EOF;
  802063:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802068:	eb f7                	jmp    802061 <getchar+0x20>

0080206a <iscons>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 8f ef ff ff       	call   80100b <fd_lookup>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 11                	js     802094 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80208c:	39 10                	cmp    %edx,(%eax)
  80208e:	0f 94 c0             	sete   %al
  802091:	0f b6 c0             	movzbl %al,%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <opencons>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	e8 14 ef ff ff       	call   800fb9 <fd_alloc>
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	78 3a                	js     8020e6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	68 07 04 00 00       	push   $0x407
  8020b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b7:	6a 00                	push   $0x0
  8020b9:	e8 df eb ff ff       	call   800c9d <sys_page_alloc>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 21                	js     8020e6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ce:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	50                   	push   %eax
  8020de:	e8 af ee ff ff       	call   800f92 <fd2num>
  8020e3:	83 c4 10             	add    $0x10,%esp
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	56                   	push   %esi
  8020ec:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f2:	8b 40 48             	mov    0x48(%eax),%eax
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 00 2a 80 00       	push   $0x802a00
  8020fd:	50                   	push   %eax
  8020fe:	68 ea 24 80 00       	push   $0x8024ea
  802103:	e8 44 e0 ff ff       	call   80014c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802108:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80210b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802111:	e8 49 eb ff ff       	call   800c5f <sys_getenvid>
  802116:	83 c4 04             	add    $0x4,%esp
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	ff 75 08             	pushl  0x8(%ebp)
  80211f:	56                   	push   %esi
  802120:	50                   	push   %eax
  802121:	68 dc 29 80 00       	push   $0x8029dc
  802126:	e8 21 e0 ff ff       	call   80014c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80212b:	83 c4 18             	add    $0x18,%esp
  80212e:	53                   	push   %ebx
  80212f:	ff 75 10             	pushl  0x10(%ebp)
  802132:	e8 c4 df ff ff       	call   8000fb <vcprintf>
	cprintf("\n");
  802137:	c7 04 24 1a 2a 80 00 	movl   $0x802a1a,(%esp)
  80213e:	e8 09 e0 ff ff       	call   80014c <cprintf>
  802143:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802146:	cc                   	int3   
  802147:	eb fd                	jmp    802146 <_panic+0x5e>

00802149 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	8b 75 08             	mov    0x8(%ebp),%esi
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802157:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802159:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80215e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	50                   	push   %eax
  802165:	e8 e3 ec ff ff       	call   800e4d <sys_ipc_recv>
	if(ret < 0){
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 2b                	js     80219c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802171:	85 f6                	test   %esi,%esi
  802173:	74 0a                	je     80217f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802175:	a1 08 40 80 00       	mov    0x804008,%eax
  80217a:	8b 40 78             	mov    0x78(%eax),%eax
  80217d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80217f:	85 db                	test   %ebx,%ebx
  802181:	74 0a                	je     80218d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802183:	a1 08 40 80 00       	mov    0x804008,%eax
  802188:	8b 40 7c             	mov    0x7c(%eax),%eax
  80218b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80218d:	a1 08 40 80 00       	mov    0x804008,%eax
  802192:	8b 40 74             	mov    0x74(%eax),%eax
}
  802195:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    
		if(from_env_store)
  80219c:	85 f6                	test   %esi,%esi
  80219e:	74 06                	je     8021a6 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021a0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021a6:	85 db                	test   %ebx,%ebx
  8021a8:	74 eb                	je     802195 <ipc_recv+0x4c>
			*perm_store = 0;
  8021aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021b0:	eb e3                	jmp    802195 <ipc_recv+0x4c>

008021b2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 0c             	sub    $0xc,%esp
  8021bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021c4:	85 db                	test   %ebx,%ebx
  8021c6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021cb:	0f 44 d8             	cmove  %eax,%ebx
  8021ce:	eb 05                	jmp    8021d5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021d0:	e8 a9 ea ff ff       	call   800c7e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021d5:	ff 75 14             	pushl  0x14(%ebp)
  8021d8:	53                   	push   %ebx
  8021d9:	56                   	push   %esi
  8021da:	57                   	push   %edi
  8021db:	e8 4a ec ff ff       	call   800e2a <sys_ipc_try_send>
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 1b                	je     802202 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021e7:	79 e7                	jns    8021d0 <ipc_send+0x1e>
  8021e9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021ec:	74 e2                	je     8021d0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	68 07 2a 80 00       	push   $0x802a07
  8021f6:	6a 46                	push   $0x46
  8021f8:	68 1c 2a 80 00       	push   $0x802a1c
  8021fd:	e8 e6 fe ff ff       	call   8020e8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    

0080220a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802215:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80221b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802221:	8b 52 50             	mov    0x50(%edx),%edx
  802224:	39 ca                	cmp    %ecx,%edx
  802226:	74 11                	je     802239 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802228:	83 c0 01             	add    $0x1,%eax
  80222b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802230:	75 e3                	jne    802215 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
  802237:	eb 0e                	jmp    802247 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802239:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80223f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802244:	8b 40 48             	mov    0x48(%eax),%eax
}
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80224f:	89 d0                	mov    %edx,%eax
  802251:	c1 e8 16             	shr    $0x16,%eax
  802254:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802260:	f6 c1 01             	test   $0x1,%cl
  802263:	74 1d                	je     802282 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802265:	c1 ea 0c             	shr    $0xc,%edx
  802268:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80226f:	f6 c2 01             	test   $0x1,%dl
  802272:	74 0e                	je     802282 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802274:	c1 ea 0c             	shr    $0xc,%edx
  802277:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80227e:	ef 
  80227f:	0f b7 c0             	movzwl %ax,%eax
}
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	66 90                	xchg   %ax,%ax
  802286:	66 90                	xchg   %ax,%ax
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
