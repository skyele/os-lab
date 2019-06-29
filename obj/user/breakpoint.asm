
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800040:	e8 15 0c 00 00       	call   800c5a <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800045:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800050:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800055:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005a:	85 db                	test   %ebx,%ebx
  80005c:	7e 07                	jle    800065 <libmain+0x30>
		binaryname = argv[0];
  80005e:	8b 06                	mov    (%esi),%eax
  800060:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800065:	83 ec 08             	sub    $0x8,%esp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	e8 c4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006f:	e8 0a 00 00 00       	call   80007e <exit>
}
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007a:	5b                   	pop    %ebx
  80007b:	5e                   	pop    %esi
  80007c:	5d                   	pop    %ebp
  80007d:	c3                   	ret    

0080007e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800084:	a1 08 40 80 00       	mov    0x804008,%eax
  800089:	8b 40 48             	mov    0x48(%eax),%eax
  80008c:	68 f8 24 80 00       	push   $0x8024f8
  800091:	50                   	push   %eax
  800092:	68 ea 24 80 00       	push   $0x8024ea
  800097:	e8 ab 00 00 00       	call   800147 <cprintf>
	close_all();
  80009c:	e8 c4 10 00 00       	call   801165 <close_all>
	sys_env_destroy(0);
  8000a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a8:	e8 6c 0b 00 00       	call   800c19 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	53                   	push   %ebx
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bc:	8b 13                	mov    (%ebx),%edx
  8000be:	8d 42 01             	lea    0x1(%edx),%eax
  8000c1:	89 03                	mov    %eax,(%ebx)
  8000c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cf:	74 09                	je     8000da <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d8:	c9                   	leave  
  8000d9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	68 ff 00 00 00       	push   $0xff
  8000e2:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 f1 0a 00 00       	call   800bdc <sys_cputs>
		b->idx = 0;
  8000eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	eb db                	jmp    8000d1 <putch+0x1f>

008000f6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800106:	00 00 00 
	b.cnt = 0;
  800109:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800110:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800113:	ff 75 0c             	pushl  0xc(%ebp)
  800116:	ff 75 08             	pushl  0x8(%ebp)
  800119:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011f:	50                   	push   %eax
  800120:	68 b2 00 80 00       	push   $0x8000b2
  800125:	e8 4a 01 00 00       	call   800274 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012a:	83 c4 08             	add    $0x8,%esp
  80012d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800133:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800139:	50                   	push   %eax
  80013a:	e8 9d 0a 00 00       	call   800bdc <sys_cputs>

	return b.cnt;
}
  80013f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80014d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800150:	50                   	push   %eax
  800151:	ff 75 08             	pushl  0x8(%ebp)
  800154:	e8 9d ff ff ff       	call   8000f6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	83 ec 1c             	sub    $0x1c,%esp
  800164:	89 c6                	mov    %eax,%esi
  800166:	89 d7                	mov    %edx,%edi
  800168:	8b 45 08             	mov    0x8(%ebp),%eax
  80016b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800171:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800174:	8b 45 10             	mov    0x10(%ebp),%eax
  800177:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80017a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80017e:	74 2c                	je     8001ac <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800180:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800183:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80018a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80018d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800190:	39 c2                	cmp    %eax,%edx
  800192:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800195:	73 43                	jae    8001da <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800197:	83 eb 01             	sub    $0x1,%ebx
  80019a:	85 db                	test   %ebx,%ebx
  80019c:	7e 6c                	jle    80020a <printnum+0xaf>
				putch(padc, putdat);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	57                   	push   %edi
  8001a2:	ff 75 18             	pushl  0x18(%ebp)
  8001a5:	ff d6                	call   *%esi
  8001a7:	83 c4 10             	add    $0x10,%esp
  8001aa:	eb eb                	jmp    800197 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	6a 20                	push   $0x20
  8001b1:	6a 00                	push   $0x0
  8001b3:	50                   	push   %eax
  8001b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ba:	89 fa                	mov    %edi,%edx
  8001bc:	89 f0                	mov    %esi,%eax
  8001be:	e8 98 ff ff ff       	call   80015b <printnum>
		while (--width > 0)
  8001c3:	83 c4 20             	add    $0x20,%esp
  8001c6:	83 eb 01             	sub    $0x1,%ebx
  8001c9:	85 db                	test   %ebx,%ebx
  8001cb:	7e 65                	jle    800232 <printnum+0xd7>
			putch(padc, putdat);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	57                   	push   %edi
  8001d1:	6a 20                	push   $0x20
  8001d3:	ff d6                	call   *%esi
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb ec                	jmp    8001c6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	83 eb 01             	sub    $0x1,%ebx
  8001e3:	53                   	push   %ebx
  8001e4:	50                   	push   %eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f4:	e8 87 20 00 00       	call   802280 <__udivdi3>
  8001f9:	83 c4 18             	add    $0x18,%esp
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	89 fa                	mov    %edi,%edx
  800200:	89 f0                	mov    %esi,%eax
  800202:	e8 54 ff ff ff       	call   80015b <printnum>
  800207:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	57                   	push   %edi
  80020e:	83 ec 04             	sub    $0x4,%esp
  800211:	ff 75 dc             	pushl  -0x24(%ebp)
  800214:	ff 75 d8             	pushl  -0x28(%ebp)
  800217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 6e 21 00 00       	call   802390 <__umoddi3>
  800222:	83 c4 14             	add    $0x14,%esp
  800225:	0f be 80 fd 24 80 00 	movsbl 0x8024fd(%eax),%eax
  80022c:	50                   	push   %eax
  80022d:	ff d6                	call   *%esi
  80022f:	83 c4 10             	add    $0x10,%esp
	}
}
  800232:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800235:	5b                   	pop    %ebx
  800236:	5e                   	pop    %esi
  800237:	5f                   	pop    %edi
  800238:	5d                   	pop    %ebp
  800239:	c3                   	ret    

0080023a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800240:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800244:	8b 10                	mov    (%eax),%edx
  800246:	3b 50 04             	cmp    0x4(%eax),%edx
  800249:	73 0a                	jae    800255 <sprintputch+0x1b>
		*b->buf++ = ch;
  80024b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024e:	89 08                	mov    %ecx,(%eax)
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	88 02                	mov    %al,(%edx)
}
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    

00800257 <printfmt>:
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800260:	50                   	push   %eax
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 05 00 00 00       	call   800274 <vprintfmt>
}
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <vprintfmt>:
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 3c             	sub    $0x3c,%esp
  80027d:	8b 75 08             	mov    0x8(%ebp),%esi
  800280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800283:	8b 7d 10             	mov    0x10(%ebp),%edi
  800286:	e9 32 04 00 00       	jmp    8006bd <vprintfmt+0x449>
		padc = ' ';
  80028b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80028f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800296:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80029d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ab:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002bd:	0f b6 17             	movzbl (%edi),%edx
  8002c0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c3:	3c 55                	cmp    $0x55,%al
  8002c5:	0f 87 12 05 00 00    	ja     8007dd <vprintfmt+0x569>
  8002cb:	0f b6 c0             	movzbl %al,%eax
  8002ce:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  8002d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002dc:	eb d9                	jmp    8002b7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002e1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002e5:	eb d0                	jmp    8002b7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	0f b6 d2             	movzbl %dl,%edx
  8002ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f2:	89 75 08             	mov    %esi,0x8(%ebp)
  8002f5:	eb 03                	jmp    8002fa <vprintfmt+0x86>
  8002f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800301:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800304:	8d 72 d0             	lea    -0x30(%edx),%esi
  800307:	83 fe 09             	cmp    $0x9,%esi
  80030a:	76 eb                	jbe    8002f7 <vprintfmt+0x83>
  80030c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030f:	8b 75 08             	mov    0x8(%ebp),%esi
  800312:	eb 14                	jmp    800328 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800314:	8b 45 14             	mov    0x14(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031c:	8b 45 14             	mov    0x14(%ebp),%eax
  80031f:	8d 40 04             	lea    0x4(%eax),%eax
  800322:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800328:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032c:	79 89                	jns    8002b7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80032e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800331:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800334:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80033b:	e9 77 ff ff ff       	jmp    8002b7 <vprintfmt+0x43>
  800340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	0f 48 c1             	cmovs  %ecx,%eax
  800348:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80034e:	e9 64 ff ff ff       	jmp    8002b7 <vprintfmt+0x43>
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800356:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80035d:	e9 55 ff ff ff       	jmp    8002b7 <vprintfmt+0x43>
			lflag++;
  800362:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800369:	e9 49 ff ff ff       	jmp    8002b7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80036e:	8b 45 14             	mov    0x14(%ebp),%eax
  800371:	8d 78 04             	lea    0x4(%eax),%edi
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	53                   	push   %ebx
  800378:	ff 30                	pushl  (%eax)
  80037a:	ff d6                	call   *%esi
			break;
  80037c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80037f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800382:	e9 33 03 00 00       	jmp    8006ba <vprintfmt+0x446>
			err = va_arg(ap, int);
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 78 04             	lea    0x4(%eax),%edi
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	99                   	cltd   
  800390:	31 d0                	xor    %edx,%eax
  800392:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800394:	83 f8 11             	cmp    $0x11,%eax
  800397:	7f 23                	jg     8003bc <vprintfmt+0x148>
  800399:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  8003a0:	85 d2                	test   %edx,%edx
  8003a2:	74 18                	je     8003bc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003a4:	52                   	push   %edx
  8003a5:	68 5d 29 80 00       	push   $0x80295d
  8003aa:	53                   	push   %ebx
  8003ab:	56                   	push   %esi
  8003ac:	e8 a6 fe ff ff       	call   800257 <printfmt>
  8003b1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b7:	e9 fe 02 00 00       	jmp    8006ba <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003bc:	50                   	push   %eax
  8003bd:	68 15 25 80 00       	push   $0x802515
  8003c2:	53                   	push   %ebx
  8003c3:	56                   	push   %esi
  8003c4:	e8 8e fe ff ff       	call   800257 <printfmt>
  8003c9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003cf:	e9 e6 02 00 00       	jmp    8006ba <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	83 c0 04             	add    $0x4,%eax
  8003da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003e2:	85 c9                	test   %ecx,%ecx
  8003e4:	b8 0e 25 80 00       	mov    $0x80250e,%eax
  8003e9:	0f 45 c1             	cmovne %ecx,%eax
  8003ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8003ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f3:	7e 06                	jle    8003fb <vprintfmt+0x187>
  8003f5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8003f9:	75 0d                	jne    800408 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	03 45 e0             	add    -0x20(%ebp),%eax
  800403:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800406:	eb 53                	jmp    80045b <vprintfmt+0x1e7>
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	ff 75 d8             	pushl  -0x28(%ebp)
  80040e:	50                   	push   %eax
  80040f:	e8 71 04 00 00       	call   800885 <strnlen>
  800414:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800417:	29 c1                	sub    %eax,%ecx
  800419:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800421:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800425:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800428:	eb 0f                	jmp    800439 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	53                   	push   %ebx
  80042e:	ff 75 e0             	pushl  -0x20(%ebp)
  800431:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800433:	83 ef 01             	sub    $0x1,%edi
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	85 ff                	test   %edi,%edi
  80043b:	7f ed                	jg     80042a <vprintfmt+0x1b6>
  80043d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800440:	85 c9                	test   %ecx,%ecx
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	0f 49 c1             	cmovns %ecx,%eax
  80044a:	29 c1                	sub    %eax,%ecx
  80044c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80044f:	eb aa                	jmp    8003fb <vprintfmt+0x187>
					putch(ch, putdat);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	53                   	push   %ebx
  800455:	52                   	push   %edx
  800456:	ff d6                	call   *%esi
  800458:	83 c4 10             	add    $0x10,%esp
  80045b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800460:	83 c7 01             	add    $0x1,%edi
  800463:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800467:	0f be d0             	movsbl %al,%edx
  80046a:	85 d2                	test   %edx,%edx
  80046c:	74 4b                	je     8004b9 <vprintfmt+0x245>
  80046e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800472:	78 06                	js     80047a <vprintfmt+0x206>
  800474:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800478:	78 1e                	js     800498 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80047a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80047e:	74 d1                	je     800451 <vprintfmt+0x1dd>
  800480:	0f be c0             	movsbl %al,%eax
  800483:	83 e8 20             	sub    $0x20,%eax
  800486:	83 f8 5e             	cmp    $0x5e,%eax
  800489:	76 c6                	jbe    800451 <vprintfmt+0x1dd>
					putch('?', putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	53                   	push   %ebx
  80048f:	6a 3f                	push   $0x3f
  800491:	ff d6                	call   *%esi
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	eb c3                	jmp    80045b <vprintfmt+0x1e7>
  800498:	89 cf                	mov    %ecx,%edi
  80049a:	eb 0e                	jmp    8004aa <vprintfmt+0x236>
				putch(' ', putdat);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	53                   	push   %ebx
  8004a0:	6a 20                	push   $0x20
  8004a2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ee                	jg     80049c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b4:	e9 01 02 00 00       	jmp    8006ba <vprintfmt+0x446>
  8004b9:	89 cf                	mov    %ecx,%edi
  8004bb:	eb ed                	jmp    8004aa <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004c0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004c7:	e9 eb fd ff ff       	jmp    8002b7 <vprintfmt+0x43>
	if (lflag >= 2)
  8004cc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004d0:	7f 21                	jg     8004f3 <vprintfmt+0x27f>
	else if (lflag)
  8004d2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004d6:	74 68                	je     800540 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e0:	89 c1                	mov    %eax,%ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 40 04             	lea    0x4(%eax),%eax
  8004ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f1:	eb 17                	jmp    80050a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8b 50 04             	mov    0x4(%eax),%edx
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004fe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 08             	lea    0x8(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80050a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80050d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800510:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800513:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800516:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80051a:	78 3f                	js     80055b <vprintfmt+0x2e7>
			base = 10;
  80051c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800521:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800525:	0f 84 71 01 00 00    	je     80069c <vprintfmt+0x428>
				putch('+', putdat);
  80052b:	83 ec 08             	sub    $0x8,%esp
  80052e:	53                   	push   %ebx
  80052f:	6a 2b                	push   $0x2b
  800531:	ff d6                	call   *%esi
  800533:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800536:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053b:	e9 5c 01 00 00       	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800548:	89 c1                	mov    %eax,%ecx
  80054a:	c1 f9 1f             	sar    $0x1f,%ecx
  80054d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 40 04             	lea    0x4(%eax),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	eb af                	jmp    80050a <vprintfmt+0x296>
				putch('-', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 2d                	push   $0x2d
  800561:	ff d6                	call   *%esi
				num = -(long long) num;
  800563:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800566:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800569:	f7 d8                	neg    %eax
  80056b:	83 d2 00             	adc    $0x0,%edx
  80056e:	f7 da                	neg    %edx
  800570:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800573:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800576:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800579:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057e:	e9 19 01 00 00       	jmp    80069c <vprintfmt+0x428>
	if (lflag >= 2)
  800583:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800587:	7f 29                	jg     8005b2 <vprintfmt+0x33e>
	else if (lflag)
  800589:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80058d:	74 44                	je     8005d3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	ba 00 00 00 00       	mov    $0x0,%edx
  800599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 40 04             	lea    0x4(%eax),%eax
  8005a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ad:	e9 ea 00 00 00       	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 50 04             	mov    0x4(%eax),%edx
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 40 08             	lea    0x8(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 c9 00 00 00       	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f1:	e9 a6 00 00 00       	jmp    80069c <vprintfmt+0x428>
			putch('0', putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	6a 30                	push   $0x30
  8005fc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800605:	7f 26                	jg     80062d <vprintfmt+0x3b9>
	else if (lflag)
  800607:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060b:	74 3e                	je     80064b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 40 04             	lea    0x4(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800626:	b8 08 00 00 00       	mov    $0x8,%eax
  80062b:	eb 6f                	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 50 04             	mov    0x4(%eax),%edx
  800633:	8b 00                	mov    (%eax),%eax
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 40 08             	lea    0x8(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800644:	b8 08 00 00 00       	mov    $0x8,%eax
  800649:	eb 51                	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800664:	b8 08 00 00 00       	mov    $0x8,%eax
  800669:	eb 31                	jmp    80069c <vprintfmt+0x428>
			putch('0', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 30                	push   $0x30
  800671:	ff d6                	call   *%esi
			putch('x', putdat);
  800673:	83 c4 08             	add    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 78                	push   $0x78
  800679:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800688:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80068b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800697:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006a3:	52                   	push   %edx
  8006a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a7:	50                   	push   %eax
  8006a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ae:	89 da                	mov    %ebx,%edx
  8006b0:	89 f0                	mov    %esi,%eax
  8006b2:	e8 a4 fa ff ff       	call   80015b <printnum>
			break;
  8006b7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bd:	83 c7 01             	add    $0x1,%edi
  8006c0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c4:	83 f8 25             	cmp    $0x25,%eax
  8006c7:	0f 84 be fb ff ff    	je     80028b <vprintfmt+0x17>
			if (ch == '\0')
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	0f 84 28 01 00 00    	je     8007fd <vprintfmt+0x589>
			putch(ch, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	50                   	push   %eax
  8006da:	ff d6                	call   *%esi
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	eb dc                	jmp    8006bd <vprintfmt+0x449>
	if (lflag >= 2)
  8006e1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e5:	7f 26                	jg     80070d <vprintfmt+0x499>
	else if (lflag)
  8006e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006eb:	74 41                	je     80072e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800706:	b8 10 00 00 00       	mov    $0x10,%eax
  80070b:	eb 8f                	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 50 04             	mov    0x4(%eax),%edx
  800713:	8b 00                	mov    (%eax),%eax
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 08             	lea    0x8(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800724:	b8 10 00 00 00       	mov    $0x10,%eax
  800729:	e9 6e ff ff ff       	jmp    80069c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	ba 00 00 00 00       	mov    $0x0,%edx
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800747:	b8 10 00 00 00       	mov    $0x10,%eax
  80074c:	e9 4b ff ff ff       	jmp    80069c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	74 14                	je     800777 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800763:	8b 13                	mov    (%ebx),%edx
  800765:	83 fa 7f             	cmp    $0x7f,%edx
  800768:	7f 37                	jg     8007a1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80076a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80076c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
  800772:	e9 43 ff ff ff       	jmp    8006ba <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800777:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077c:	bf 31 26 80 00       	mov    $0x802631,%edi
							putch(ch, putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800788:	83 c7 01             	add    $0x1,%edi
  80078b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	85 c0                	test   %eax,%eax
  800794:	75 eb                	jne    800781 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800796:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
  80079c:	e9 19 ff ff ff       	jmp    8006ba <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007a1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a8:	bf 69 26 80 00       	mov    $0x802669,%edi
							putch(ch, putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	50                   	push   %eax
  8007b2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b4:	83 c7 01             	add    $0x1,%edi
  8007b7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	75 eb                	jne    8007ad <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	e9 ed fe ff ff       	jmp    8006ba <vprintfmt+0x446>
			putch(ch, putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 25                	push   $0x25
  8007d3:	ff d6                	call   *%esi
			break;
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	e9 dd fe ff ff       	jmp    8006ba <vprintfmt+0x446>
			putch('%', putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	6a 25                	push   $0x25
  8007e3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	89 f8                	mov    %edi,%eax
  8007ea:	eb 03                	jmp    8007ef <vprintfmt+0x57b>
  8007ec:	83 e8 01             	sub    $0x1,%eax
  8007ef:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f3:	75 f7                	jne    8007ec <vprintfmt+0x578>
  8007f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f8:	e9 bd fe ff ff       	jmp    8006ba <vprintfmt+0x446>
}
  8007fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800800:	5b                   	pop    %ebx
  800801:	5e                   	pop    %esi
  800802:	5f                   	pop    %edi
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	83 ec 18             	sub    $0x18,%esp
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800811:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800814:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800818:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800822:	85 c0                	test   %eax,%eax
  800824:	74 26                	je     80084c <vsnprintf+0x47>
  800826:	85 d2                	test   %edx,%edx
  800828:	7e 22                	jle    80084c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082a:	ff 75 14             	pushl  0x14(%ebp)
  80082d:	ff 75 10             	pushl  0x10(%ebp)
  800830:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800833:	50                   	push   %eax
  800834:	68 3a 02 80 00       	push   $0x80023a
  800839:	e8 36 fa ff ff       	call   800274 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800841:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	83 c4 10             	add    $0x10,%esp
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    
		return -E_INVAL;
  80084c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800851:	eb f7                	jmp    80084a <vsnprintf+0x45>

00800853 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800859:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085c:	50                   	push   %eax
  80085d:	ff 75 10             	pushl  0x10(%ebp)
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 9a ff ff ff       	call   800805 <vsnprintf>
	va_end(ap);

	return rc;
}
  80086b:	c9                   	leave  
  80086c:	c3                   	ret    

0080086d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087c:	74 05                	je     800883 <strlen+0x16>
		n++;
  80087e:	83 c0 01             	add    $0x1,%eax
  800881:	eb f5                	jmp    800878 <strlen+0xb>
	return n;
}
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	39 c2                	cmp    %eax,%edx
  800895:	74 0d                	je     8008a4 <strnlen+0x1f>
  800897:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80089b:	74 05                	je     8008a2 <strnlen+0x1d>
		n++;
  80089d:	83 c2 01             	add    $0x1,%edx
  8008a0:	eb f1                	jmp    800893 <strnlen+0xe>
  8008a2:	89 d0                	mov    %edx,%eax
	return n;
}
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    

008008a6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	53                   	push   %ebx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008b9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	75 f2                	jne    8008b5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c3:	5b                   	pop    %ebx
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	53                   	push   %ebx
  8008ca:	83 ec 10             	sub    $0x10,%esp
  8008cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d0:	53                   	push   %ebx
  8008d1:	e8 97 ff ff ff       	call   80086d <strlen>
  8008d6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	01 d8                	add    %ebx,%eax
  8008de:	50                   	push   %eax
  8008df:	e8 c2 ff ff ff       	call   8008a6 <strcpy>
	return dst;
}
  8008e4:	89 d8                	mov    %ebx,%eax
  8008e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    

008008eb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	56                   	push   %esi
  8008ef:	53                   	push   %ebx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f6:	89 c6                	mov    %eax,%esi
  8008f8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fb:	89 c2                	mov    %eax,%edx
  8008fd:	39 f2                	cmp    %esi,%edx
  8008ff:	74 11                	je     800912 <strncpy+0x27>
		*dst++ = *src;
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	0f b6 19             	movzbl (%ecx),%ebx
  800907:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090a:	80 fb 01             	cmp    $0x1,%bl
  80090d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800910:	eb eb                	jmp    8008fd <strncpy+0x12>
	}
	return ret;
}
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 75 08             	mov    0x8(%ebp),%esi
  80091e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800921:	8b 55 10             	mov    0x10(%ebp),%edx
  800924:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800926:	85 d2                	test   %edx,%edx
  800928:	74 21                	je     80094b <strlcpy+0x35>
  80092a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800930:	39 c2                	cmp    %eax,%edx
  800932:	74 14                	je     800948 <strlcpy+0x32>
  800934:	0f b6 19             	movzbl (%ecx),%ebx
  800937:	84 db                	test   %bl,%bl
  800939:	74 0b                	je     800946 <strlcpy+0x30>
			*dst++ = *src++;
  80093b:	83 c1 01             	add    $0x1,%ecx
  80093e:	83 c2 01             	add    $0x1,%edx
  800941:	88 5a ff             	mov    %bl,-0x1(%edx)
  800944:	eb ea                	jmp    800930 <strlcpy+0x1a>
  800946:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800948:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094b:	29 f0                	sub    %esi,%eax
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095a:	0f b6 01             	movzbl (%ecx),%eax
  80095d:	84 c0                	test   %al,%al
  80095f:	74 0c                	je     80096d <strcmp+0x1c>
  800961:	3a 02                	cmp    (%edx),%al
  800963:	75 08                	jne    80096d <strcmp+0x1c>
		p++, q++;
  800965:	83 c1 01             	add    $0x1,%ecx
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	eb ed                	jmp    80095a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096d:	0f b6 c0             	movzbl %al,%eax
  800970:	0f b6 12             	movzbl (%edx),%edx
  800973:	29 d0                	sub    %edx,%eax
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800981:	89 c3                	mov    %eax,%ebx
  800983:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800986:	eb 06                	jmp    80098e <strncmp+0x17>
		n--, p++, q++;
  800988:	83 c0 01             	add    $0x1,%eax
  80098b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80098e:	39 d8                	cmp    %ebx,%eax
  800990:	74 16                	je     8009a8 <strncmp+0x31>
  800992:	0f b6 08             	movzbl (%eax),%ecx
  800995:	84 c9                	test   %cl,%cl
  800997:	74 04                	je     80099d <strncmp+0x26>
  800999:	3a 0a                	cmp    (%edx),%cl
  80099b:	74 eb                	je     800988 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80099d:	0f b6 00             	movzbl (%eax),%eax
  8009a0:	0f b6 12             	movzbl (%edx),%edx
  8009a3:	29 d0                	sub    %edx,%eax
}
  8009a5:	5b                   	pop    %ebx
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    
		return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	eb f6                	jmp    8009a5 <strncmp+0x2e>

008009af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b9:	0f b6 10             	movzbl (%eax),%edx
  8009bc:	84 d2                	test   %dl,%dl
  8009be:	74 09                	je     8009c9 <strchr+0x1a>
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 0a                	je     8009ce <strchr+0x1f>
	for (; *s; s++)
  8009c4:	83 c0 01             	add    $0x1,%eax
  8009c7:	eb f0                	jmp    8009b9 <strchr+0xa>
			return (char *) s;
	return 0;
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009da:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009dd:	38 ca                	cmp    %cl,%dl
  8009df:	74 09                	je     8009ea <strfind+0x1a>
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	74 05                	je     8009ea <strfind+0x1a>
	for (; *s; s++)
  8009e5:	83 c0 01             	add    $0x1,%eax
  8009e8:	eb f0                	jmp    8009da <strfind+0xa>
			break;
	return (char *) s;
}
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	57                   	push   %edi
  8009f0:	56                   	push   %esi
  8009f1:	53                   	push   %ebx
  8009f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f8:	85 c9                	test   %ecx,%ecx
  8009fa:	74 31                	je     800a2d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009fc:	89 f8                	mov    %edi,%eax
  8009fe:	09 c8                	or     %ecx,%eax
  800a00:	a8 03                	test   $0x3,%al
  800a02:	75 23                	jne    800a27 <memset+0x3b>
		c &= 0xFF;
  800a04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a08:	89 d3                	mov    %edx,%ebx
  800a0a:	c1 e3 08             	shl    $0x8,%ebx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 18             	shl    $0x18,%eax
  800a12:	89 d6                	mov    %edx,%esi
  800a14:	c1 e6 10             	shl    $0x10,%esi
  800a17:	09 f0                	or     %esi,%eax
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	fc                   	cld    
  800a23:	f3 ab                	rep stos %eax,%es:(%edi)
  800a25:	eb 06                	jmp    800a2d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	fc                   	cld    
  800a2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 32                	jae    800a78 <memmove+0x44>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 c2                	cmp    %eax,%edx
  800a4b:	76 2b                	jbe    800a78 <memmove+0x44>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a50:	89 fe                	mov    %edi,%esi
  800a52:	09 ce                	or     %ecx,%esi
  800a54:	09 d6                	or     %edx,%esi
  800a56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5c:	75 0e                	jne    800a6c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a5e:	83 ef 04             	sub    $0x4,%edi
  800a61:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a64:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a67:	fd                   	std    
  800a68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6a:	eb 09                	jmp    800a75 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6c:	83 ef 01             	sub    $0x1,%edi
  800a6f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a72:	fd                   	std    
  800a73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a75:	fc                   	cld    
  800a76:	eb 1a                	jmp    800a92 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a78:	89 c2                	mov    %eax,%edx
  800a7a:	09 ca                	or     %ecx,%edx
  800a7c:	09 f2                	or     %esi,%edx
  800a7e:	f6 c2 03             	test   $0x3,%dl
  800a81:	75 0a                	jne    800a8d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a86:	89 c7                	mov    %eax,%edi
  800a88:	fc                   	cld    
  800a89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8b:	eb 05                	jmp    800a92 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a8d:	89 c7                	mov    %eax,%edi
  800a8f:	fc                   	cld    
  800a90:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a92:	5e                   	pop    %esi
  800a93:	5f                   	pop    %edi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a9c:	ff 75 10             	pushl  0x10(%ebp)
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	ff 75 08             	pushl  0x8(%ebp)
  800aa5:	e8 8a ff ff ff       	call   800a34 <memmove>
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	89 c6                	mov    %eax,%esi
  800ab9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abc:	39 f0                	cmp    %esi,%eax
  800abe:	74 1c                	je     800adc <memcmp+0x30>
		if (*s1 != *s2)
  800ac0:	0f b6 08             	movzbl (%eax),%ecx
  800ac3:	0f b6 1a             	movzbl (%edx),%ebx
  800ac6:	38 d9                	cmp    %bl,%cl
  800ac8:	75 08                	jne    800ad2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	83 c2 01             	add    $0x1,%edx
  800ad0:	eb ea                	jmp    800abc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad2:	0f b6 c1             	movzbl %cl,%eax
  800ad5:	0f b6 db             	movzbl %bl,%ebx
  800ad8:	29 d8                	sub    %ebx,%eax
  800ada:	eb 05                	jmp    800ae1 <memcmp+0x35>
	}

	return 0;
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af3:	39 d0                	cmp    %edx,%eax
  800af5:	73 09                	jae    800b00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af7:	38 08                	cmp    %cl,(%eax)
  800af9:	74 05                	je     800b00 <memfind+0x1b>
	for (; s < ends; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f3                	jmp    800af3 <memfind+0xe>
			break;
	return (void *) s;
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0e:	eb 03                	jmp    800b13 <strtol+0x11>
		s++;
  800b10:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b13:	0f b6 01             	movzbl (%ecx),%eax
  800b16:	3c 20                	cmp    $0x20,%al
  800b18:	74 f6                	je     800b10 <strtol+0xe>
  800b1a:	3c 09                	cmp    $0x9,%al
  800b1c:	74 f2                	je     800b10 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b1e:	3c 2b                	cmp    $0x2b,%al
  800b20:	74 2a                	je     800b4c <strtol+0x4a>
	int neg = 0;
  800b22:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b27:	3c 2d                	cmp    $0x2d,%al
  800b29:	74 2b                	je     800b56 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b31:	75 0f                	jne    800b42 <strtol+0x40>
  800b33:	80 39 30             	cmpb   $0x30,(%ecx)
  800b36:	74 28                	je     800b60 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3f:	0f 44 d8             	cmove  %eax,%ebx
  800b42:	b8 00 00 00 00       	mov    $0x0,%eax
  800b47:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b4a:	eb 50                	jmp    800b9c <strtol+0x9a>
		s++;
  800b4c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b54:	eb d5                	jmp    800b2b <strtol+0x29>
		s++, neg = 1;
  800b56:	83 c1 01             	add    $0x1,%ecx
  800b59:	bf 01 00 00 00       	mov    $0x1,%edi
  800b5e:	eb cb                	jmp    800b2b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b60:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b64:	74 0e                	je     800b74 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b66:	85 db                	test   %ebx,%ebx
  800b68:	75 d8                	jne    800b42 <strtol+0x40>
		s++, base = 8;
  800b6a:	83 c1 01             	add    $0x1,%ecx
  800b6d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b72:	eb ce                	jmp    800b42 <strtol+0x40>
		s += 2, base = 16;
  800b74:	83 c1 02             	add    $0x2,%ecx
  800b77:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b7c:	eb c4                	jmp    800b42 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b7e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b81:	89 f3                	mov    %esi,%ebx
  800b83:	80 fb 19             	cmp    $0x19,%bl
  800b86:	77 29                	ja     800bb1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b88:	0f be d2             	movsbl %dl,%edx
  800b8b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b8e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b91:	7d 30                	jge    800bc3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800b93:	83 c1 01             	add    $0x1,%ecx
  800b96:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b9c:	0f b6 11             	movzbl (%ecx),%edx
  800b9f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ba2:	89 f3                	mov    %esi,%ebx
  800ba4:	80 fb 09             	cmp    $0x9,%bl
  800ba7:	77 d5                	ja     800b7e <strtol+0x7c>
			dig = *s - '0';
  800ba9:	0f be d2             	movsbl %dl,%edx
  800bac:	83 ea 30             	sub    $0x30,%edx
  800baf:	eb dd                	jmp    800b8e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bb1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bb4:	89 f3                	mov    %esi,%ebx
  800bb6:	80 fb 19             	cmp    $0x19,%bl
  800bb9:	77 08                	ja     800bc3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bbb:	0f be d2             	movsbl %dl,%edx
  800bbe:	83 ea 37             	sub    $0x37,%edx
  800bc1:	eb cb                	jmp    800b8e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc7:	74 05                	je     800bce <strtol+0xcc>
		*endptr = (char *) s;
  800bc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bce:	89 c2                	mov    %eax,%edx
  800bd0:	f7 da                	neg    %edx
  800bd2:	85 ff                	test   %edi,%edi
  800bd4:	0f 45 c2             	cmovne %edx,%eax
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5f                   	pop    %edi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
  800be7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bed:	89 c3                	mov    %eax,%ebx
  800bef:	89 c7                	mov    %eax,%edi
  800bf1:	89 c6                	mov    %eax,%esi
  800bf3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <sys_cgetc>:

int
sys_cgetc(void)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c00:	ba 00 00 00 00       	mov    $0x0,%edx
  800c05:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0a:	89 d1                	mov    %edx,%ecx
  800c0c:	89 d3                	mov    %edx,%ebx
  800c0e:	89 d7                	mov    %edx,%edi
  800c10:	89 d6                	mov    %edx,%esi
  800c12:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2f:	89 cb                	mov    %ecx,%ebx
  800c31:	89 cf                	mov    %ecx,%edi
  800c33:	89 ce                	mov    %ecx,%esi
  800c35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	7f 08                	jg     800c43 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c43:	83 ec 0c             	sub    $0xc,%esp
  800c46:	50                   	push   %eax
  800c47:	6a 03                	push   $0x3
  800c49:	68 88 28 80 00       	push   $0x802888
  800c4e:	6a 43                	push   $0x43
  800c50:	68 a5 28 80 00       	push   $0x8028a5
  800c55:	e8 89 14 00 00       	call   8020e3 <_panic>

00800c5a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c60:	ba 00 00 00 00       	mov    $0x0,%edx
  800c65:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6a:	89 d1                	mov    %edx,%ecx
  800c6c:	89 d3                	mov    %edx,%ebx
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	89 d6                	mov    %edx,%esi
  800c72:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <sys_yield>:

void
sys_yield(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c84:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c89:	89 d1                	mov    %edx,%ecx
  800c8b:	89 d3                	mov    %edx,%ebx
  800c8d:	89 d7                	mov    %edx,%edi
  800c8f:	89 d6                	mov    %edx,%esi
  800c91:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
  800c9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca1:	be 00 00 00 00       	mov    $0x0,%esi
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cac:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb4:	89 f7                	mov    %esi,%edi
  800cb6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	7f 08                	jg     800cc4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc4:	83 ec 0c             	sub    $0xc,%esp
  800cc7:	50                   	push   %eax
  800cc8:	6a 04                	push   $0x4
  800cca:	68 88 28 80 00       	push   $0x802888
  800ccf:	6a 43                	push   $0x43
  800cd1:	68 a5 28 80 00       	push   $0x8028a5
  800cd6:	e8 08 14 00 00       	call   8020e3 <_panic>

00800cdb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	b8 05 00 00 00       	mov    $0x5,%eax
  800cef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf5:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	7f 08                	jg     800d06 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d06:	83 ec 0c             	sub    $0xc,%esp
  800d09:	50                   	push   %eax
  800d0a:	6a 05                	push   $0x5
  800d0c:	68 88 28 80 00       	push   $0x802888
  800d11:	6a 43                	push   $0x43
  800d13:	68 a5 28 80 00       	push   $0x8028a5
  800d18:	e8 c6 13 00 00       	call   8020e3 <_panic>

00800d1d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 06 00 00 00       	mov    $0x6,%eax
  800d36:	89 df                	mov    %ebx,%edi
  800d38:	89 de                	mov    %ebx,%esi
  800d3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	7f 08                	jg     800d48 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d48:	83 ec 0c             	sub    $0xc,%esp
  800d4b:	50                   	push   %eax
  800d4c:	6a 06                	push   $0x6
  800d4e:	68 88 28 80 00       	push   $0x802888
  800d53:	6a 43                	push   $0x43
  800d55:	68 a5 28 80 00       	push   $0x8028a5
  800d5a:	e8 84 13 00 00       	call   8020e3 <_panic>

00800d5f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	b8 08 00 00 00       	mov    $0x8,%eax
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7f 08                	jg     800d8a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	6a 08                	push   $0x8
  800d90:	68 88 28 80 00       	push   $0x802888
  800d95:	6a 43                	push   $0x43
  800d97:	68 a5 28 80 00       	push   $0x8028a5
  800d9c:	e8 42 13 00 00       	call   8020e3 <_panic>

00800da1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db5:	b8 09 00 00 00       	mov    $0x9,%eax
  800dba:	89 df                	mov    %ebx,%edi
  800dbc:	89 de                	mov    %ebx,%esi
  800dbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	7f 08                	jg     800dcc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 09                	push   $0x9
  800dd2:	68 88 28 80 00       	push   $0x802888
  800dd7:	6a 43                	push   $0x43
  800dd9:	68 a5 28 80 00       	push   $0x8028a5
  800dde:	e8 00 13 00 00       	call   8020e3 <_panic>

00800de3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 0a                	push   $0xa
  800e14:	68 88 28 80 00       	push   $0x802888
  800e19:	6a 43                	push   $0x43
  800e1b:	68 a5 28 80 00       	push   $0x8028a5
  800e20:	e8 be 12 00 00       	call   8020e3 <_panic>

00800e25 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e36:	be 00 00 00 00       	mov    $0x0,%esi
  800e3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e41:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e51:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5e:	89 cb                	mov    %ecx,%ebx
  800e60:	89 cf                	mov    %ecx,%edi
  800e62:	89 ce                	mov    %ecx,%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 0d                	push   $0xd
  800e78:	68 88 28 80 00       	push   $0x802888
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 a5 28 80 00       	push   $0x8028a5
  800e84:	e8 5a 12 00 00       	call   8020e3 <_panic>

00800e89 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    

00800eaa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ebd:	89 cb                	mov    %ecx,%ebx
  800ebf:	89 cf                	mov    %ecx,%edi
  800ec1:	89 ce                	mov    %ecx,%esi
  800ec3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed5:	b8 10 00 00 00       	mov    $0x10,%eax
  800eda:	89 d1                	mov    %edx,%ecx
  800edc:	89 d3                	mov    %edx,%ebx
  800ede:	89 d7                	mov    %edx,%edi
  800ee0:	89 d6                	mov    %edx,%esi
  800ee2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efa:	b8 11 00 00 00       	mov    $0x11,%eax
  800eff:	89 df                	mov    %ebx,%edi
  800f01:	89 de                	mov    %ebx,%esi
  800f03:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	b8 12 00 00 00       	mov    $0x12,%eax
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 13 00 00 00       	mov    $0x13,%eax
  800f44:	89 df                	mov    %ebx,%edi
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	7f 08                	jg     800f56 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	50                   	push   %eax
  800f5a:	6a 13                	push   $0x13
  800f5c:	68 88 28 80 00       	push   $0x802888
  800f61:	6a 43                	push   $0x43
  800f63:	68 a5 28 80 00       	push   $0x8028a5
  800f68:	e8 76 11 00 00       	call   8020e3 <_panic>

00800f6d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	b8 14 00 00 00       	mov    $0x14,%eax
  800f80:	89 cb                	mov    %ecx,%ebx
  800f82:	89 cf                	mov    %ecx,%edi
  800f84:	89 ce                	mov    %ecx,%esi
  800f86:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	05 00 00 00 30       	add    $0x30000000,%eax
  800f98:	c1 e8 0c             	shr    $0xc,%eax
}
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fa8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fad:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	c1 ea 16             	shr    $0x16,%edx
  800fc1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc8:	f6 c2 01             	test   $0x1,%dl
  800fcb:	74 2d                	je     800ffa <fd_alloc+0x46>
  800fcd:	89 c2                	mov    %eax,%edx
  800fcf:	c1 ea 0c             	shr    $0xc,%edx
  800fd2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd9:	f6 c2 01             	test   $0x1,%dl
  800fdc:	74 1c                	je     800ffa <fd_alloc+0x46>
  800fde:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fe3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fe8:	75 d2                	jne    800fbc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ff3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ff8:	eb 0a                	jmp    801004 <fd_alloc+0x50>
			*fd_store = fd;
  800ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80100c:	83 f8 1f             	cmp    $0x1f,%eax
  80100f:	77 30                	ja     801041 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801011:	c1 e0 0c             	shl    $0xc,%eax
  801014:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801019:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80101f:	f6 c2 01             	test   $0x1,%dl
  801022:	74 24                	je     801048 <fd_lookup+0x42>
  801024:	89 c2                	mov    %eax,%edx
  801026:	c1 ea 0c             	shr    $0xc,%edx
  801029:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801030:	f6 c2 01             	test   $0x1,%dl
  801033:	74 1a                	je     80104f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	89 02                	mov    %eax,(%edx)
	return 0;
  80103a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
		return -E_INVAL;
  801041:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801046:	eb f7                	jmp    80103f <fd_lookup+0x39>
		return -E_INVAL;
  801048:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104d:	eb f0                	jmp    80103f <fd_lookup+0x39>
  80104f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801054:	eb e9                	jmp    80103f <fd_lookup+0x39>

00801056 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 08             	sub    $0x8,%esp
  80105c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80105f:	ba 00 00 00 00       	mov    $0x0,%edx
  801064:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801069:	39 08                	cmp    %ecx,(%eax)
  80106b:	74 38                	je     8010a5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80106d:	83 c2 01             	add    $0x1,%edx
  801070:	8b 04 95 30 29 80 00 	mov    0x802930(,%edx,4),%eax
  801077:	85 c0                	test   %eax,%eax
  801079:	75 ee                	jne    801069 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80107b:	a1 08 40 80 00       	mov    0x804008,%eax
  801080:	8b 40 48             	mov    0x48(%eax),%eax
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	51                   	push   %ecx
  801087:	50                   	push   %eax
  801088:	68 b4 28 80 00       	push   $0x8028b4
  80108d:	e8 b5 f0 ff ff       	call   800147 <cprintf>
	*dev = 0;
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    
			*dev = devtab[i];
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8010af:	eb f2                	jmp    8010a3 <dev_lookup+0x4d>

008010b1 <fd_close>:
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	57                   	push   %edi
  8010b5:	56                   	push   %esi
  8010b6:	53                   	push   %ebx
  8010b7:	83 ec 24             	sub    $0x24,%esp
  8010ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8010bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ca:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010cd:	50                   	push   %eax
  8010ce:	e8 33 ff ff ff       	call   801006 <fd_lookup>
  8010d3:	89 c3                	mov    %eax,%ebx
  8010d5:	83 c4 10             	add    $0x10,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 05                	js     8010e1 <fd_close+0x30>
	    || fd != fd2)
  8010dc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010df:	74 16                	je     8010f7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010e1:	89 f8                	mov    %edi,%eax
  8010e3:	84 c0                	test   %al,%al
  8010e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ea:	0f 44 d8             	cmove  %eax,%ebx
}
  8010ed:	89 d8                	mov    %ebx,%eax
  8010ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010f7:	83 ec 08             	sub    $0x8,%esp
  8010fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010fd:	50                   	push   %eax
  8010fe:	ff 36                	pushl  (%esi)
  801100:	e8 51 ff ff ff       	call   801056 <dev_lookup>
  801105:	89 c3                	mov    %eax,%ebx
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	78 1a                	js     801128 <fd_close+0x77>
		if (dev->dev_close)
  80110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801111:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801119:	85 c0                	test   %eax,%eax
  80111b:	74 0b                	je     801128 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80111d:	83 ec 0c             	sub    $0xc,%esp
  801120:	56                   	push   %esi
  801121:	ff d0                	call   *%eax
  801123:	89 c3                	mov    %eax,%ebx
  801125:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	56                   	push   %esi
  80112c:	6a 00                	push   $0x0
  80112e:	e8 ea fb ff ff       	call   800d1d <sys_page_unmap>
	return r;
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	eb b5                	jmp    8010ed <fd_close+0x3c>

00801138 <close>:

int
close(int fdnum)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80113e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 bc fe ff ff       	call   801006 <fd_lookup>
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	79 02                	jns    801153 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    
		return fd_close(fd, 1);
  801153:	83 ec 08             	sub    $0x8,%esp
  801156:	6a 01                	push   $0x1
  801158:	ff 75 f4             	pushl  -0xc(%ebp)
  80115b:	e8 51 ff ff ff       	call   8010b1 <fd_close>
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	eb ec                	jmp    801151 <close+0x19>

00801165 <close_all>:

void
close_all(void)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	53                   	push   %ebx
  801169:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	53                   	push   %ebx
  801175:	e8 be ff ff ff       	call   801138 <close>
	for (i = 0; i < MAXFD; i++)
  80117a:	83 c3 01             	add    $0x1,%ebx
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	83 fb 20             	cmp    $0x20,%ebx
  801183:	75 ec                	jne    801171 <close_all+0xc>
}
  801185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801193:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 67 fe ff ff       	call   801006 <fd_lookup>
  80119f:	89 c3                	mov    %eax,%ebx
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	0f 88 81 00 00 00    	js     80122d <dup+0xa3>
		return r;
	close(newfdnum);
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	e8 81 ff ff ff       	call   801138 <close>

	newfd = INDEX2FD(newfdnum);
  8011b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ba:	c1 e6 0c             	shl    $0xc,%esi
  8011bd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011c3:	83 c4 04             	add    $0x4,%esp
  8011c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c9:	e8 cf fd ff ff       	call   800f9d <fd2data>
  8011ce:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011d0:	89 34 24             	mov    %esi,(%esp)
  8011d3:	e8 c5 fd ff ff       	call   800f9d <fd2data>
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	c1 e8 16             	shr    $0x16,%eax
  8011e2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011e9:	a8 01                	test   $0x1,%al
  8011eb:	74 11                	je     8011fe <dup+0x74>
  8011ed:	89 d8                	mov    %ebx,%eax
  8011ef:	c1 e8 0c             	shr    $0xc,%eax
  8011f2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011f9:	f6 c2 01             	test   $0x1,%dl
  8011fc:	75 39                	jne    801237 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801201:	89 d0                	mov    %edx,%eax
  801203:	c1 e8 0c             	shr    $0xc,%eax
  801206:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	25 07 0e 00 00       	and    $0xe07,%eax
  801215:	50                   	push   %eax
  801216:	56                   	push   %esi
  801217:	6a 00                	push   $0x0
  801219:	52                   	push   %edx
  80121a:	6a 00                	push   $0x0
  80121c:	e8 ba fa ff ff       	call   800cdb <sys_page_map>
  801221:	89 c3                	mov    %eax,%ebx
  801223:	83 c4 20             	add    $0x20,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	78 31                	js     80125b <dup+0xd1>
		goto err;

	return newfdnum;
  80122a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80122d:	89 d8                	mov    %ebx,%eax
  80122f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801232:	5b                   	pop    %ebx
  801233:	5e                   	pop    %esi
  801234:	5f                   	pop    %edi
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801237:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	25 07 0e 00 00       	and    $0xe07,%eax
  801246:	50                   	push   %eax
  801247:	57                   	push   %edi
  801248:	6a 00                	push   $0x0
  80124a:	53                   	push   %ebx
  80124b:	6a 00                	push   $0x0
  80124d:	e8 89 fa ff ff       	call   800cdb <sys_page_map>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 20             	add    $0x20,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	79 a3                	jns    8011fe <dup+0x74>
	sys_page_unmap(0, newfd);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	56                   	push   %esi
  80125f:	6a 00                	push   $0x0
  801261:	e8 b7 fa ff ff       	call   800d1d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801266:	83 c4 08             	add    $0x8,%esp
  801269:	57                   	push   %edi
  80126a:	6a 00                	push   $0x0
  80126c:	e8 ac fa ff ff       	call   800d1d <sys_page_unmap>
	return r;
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	eb b7                	jmp    80122d <dup+0xa3>

00801276 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	53                   	push   %ebx
  80127a:	83 ec 1c             	sub    $0x1c,%esp
  80127d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801280:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801283:	50                   	push   %eax
  801284:	53                   	push   %ebx
  801285:	e8 7c fd ff ff       	call   801006 <fd_lookup>
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	78 3f                	js     8012d0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129b:	ff 30                	pushl  (%eax)
  80129d:	e8 b4 fd ff ff       	call   801056 <dev_lookup>
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	78 27                	js     8012d0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ac:	8b 42 08             	mov    0x8(%edx),%eax
  8012af:	83 e0 03             	and    $0x3,%eax
  8012b2:	83 f8 01             	cmp    $0x1,%eax
  8012b5:	74 1e                	je     8012d5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	8b 40 08             	mov    0x8(%eax),%eax
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	74 35                	je     8012f6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 10             	pushl  0x10(%ebp)
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	52                   	push   %edx
  8012cb:	ff d0                	call   *%eax
  8012cd:	83 c4 10             	add    $0x10,%esp
}
  8012d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012d5:	a1 08 40 80 00       	mov    0x804008,%eax
  8012da:	8b 40 48             	mov    0x48(%eax),%eax
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	53                   	push   %ebx
  8012e1:	50                   	push   %eax
  8012e2:	68 f5 28 80 00       	push   $0x8028f5
  8012e7:	e8 5b ee ff ff       	call   800147 <cprintf>
		return -E_INVAL;
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f4:	eb da                	jmp    8012d0 <read+0x5a>
		return -E_NOT_SUPP;
  8012f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012fb:	eb d3                	jmp    8012d0 <read+0x5a>

008012fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	57                   	push   %edi
  801301:	56                   	push   %esi
  801302:	53                   	push   %ebx
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	8b 7d 08             	mov    0x8(%ebp),%edi
  801309:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80130c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801311:	39 f3                	cmp    %esi,%ebx
  801313:	73 23                	jae    801338 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	89 f0                	mov    %esi,%eax
  80131a:	29 d8                	sub    %ebx,%eax
  80131c:	50                   	push   %eax
  80131d:	89 d8                	mov    %ebx,%eax
  80131f:	03 45 0c             	add    0xc(%ebp),%eax
  801322:	50                   	push   %eax
  801323:	57                   	push   %edi
  801324:	e8 4d ff ff ff       	call   801276 <read>
		if (m < 0)
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	78 06                	js     801336 <readn+0x39>
			return m;
		if (m == 0)
  801330:	74 06                	je     801338 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801332:	01 c3                	add    %eax,%ebx
  801334:	eb db                	jmp    801311 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801336:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801338:	89 d8                	mov    %ebx,%eax
  80133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	83 ec 1c             	sub    $0x1c,%esp
  801349:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134f:	50                   	push   %eax
  801350:	53                   	push   %ebx
  801351:	e8 b0 fc ff ff       	call   801006 <fd_lookup>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 3a                	js     801397 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	ff 30                	pushl  (%eax)
  801369:	e8 e8 fc ff ff       	call   801056 <dev_lookup>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 22                	js     801397 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80137c:	74 1e                	je     80139c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80137e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801381:	8b 52 0c             	mov    0xc(%edx),%edx
  801384:	85 d2                	test   %edx,%edx
  801386:	74 35                	je     8013bd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	ff 75 10             	pushl  0x10(%ebp)
  80138e:	ff 75 0c             	pushl  0xc(%ebp)
  801391:	50                   	push   %eax
  801392:	ff d2                	call   *%edx
  801394:	83 c4 10             	add    $0x10,%esp
}
  801397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80139c:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a1:	8b 40 48             	mov    0x48(%eax),%eax
  8013a4:	83 ec 04             	sub    $0x4,%esp
  8013a7:	53                   	push   %ebx
  8013a8:	50                   	push   %eax
  8013a9:	68 11 29 80 00       	push   $0x802911
  8013ae:	e8 94 ed ff ff       	call   800147 <cprintf>
		return -E_INVAL;
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bb:	eb da                	jmp    801397 <write+0x55>
		return -E_NOT_SUPP;
  8013bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c2:	eb d3                	jmp    801397 <write+0x55>

008013c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	e8 30 fc ff ff       	call   801006 <fd_lookup>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 0e                	js     8013eb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 1c             	sub    $0x1c,%esp
  8013f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	53                   	push   %ebx
  8013fc:	e8 05 fc ff ff       	call   801006 <fd_lookup>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 37                	js     80143f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801412:	ff 30                	pushl  (%eax)
  801414:	e8 3d fc ff ff       	call   801056 <dev_lookup>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 1f                	js     80143f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801427:	74 1b                	je     801444 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142c:	8b 52 18             	mov    0x18(%edx),%edx
  80142f:	85 d2                	test   %edx,%edx
  801431:	74 32                	je     801465 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	50                   	push   %eax
  80143a:	ff d2                	call   *%edx
  80143c:	83 c4 10             	add    $0x10,%esp
}
  80143f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801442:	c9                   	leave  
  801443:	c3                   	ret    
			thisenv->env_id, fdnum);
  801444:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801449:	8b 40 48             	mov    0x48(%eax),%eax
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	53                   	push   %ebx
  801450:	50                   	push   %eax
  801451:	68 d4 28 80 00       	push   $0x8028d4
  801456:	e8 ec ec ff ff       	call   800147 <cprintf>
		return -E_INVAL;
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801463:	eb da                	jmp    80143f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801465:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146a:	eb d3                	jmp    80143f <ftruncate+0x52>

0080146c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	53                   	push   %ebx
  801470:	83 ec 1c             	sub    $0x1c,%esp
  801473:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801476:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 84 fb ff ff       	call   801006 <fd_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 4b                	js     8014d4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148f:	50                   	push   %eax
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	ff 30                	pushl  (%eax)
  801495:	e8 bc fb ff ff       	call   801056 <dev_lookup>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 33                	js     8014d4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014a8:	74 2f                	je     8014d9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014aa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ad:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014b4:	00 00 00 
	stat->st_isdir = 0;
  8014b7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014be:	00 00 00 
	stat->st_dev = dev;
  8014c1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	53                   	push   %ebx
  8014cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ce:	ff 50 14             	call   *0x14(%eax)
  8014d1:	83 c4 10             	add    $0x10,%esp
}
  8014d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    
		return -E_NOT_SUPP;
  8014d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014de:	eb f4                	jmp    8014d4 <fstat+0x68>

008014e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	6a 00                	push   $0x0
  8014ea:	ff 75 08             	pushl  0x8(%ebp)
  8014ed:	e8 22 02 00 00       	call   801714 <open>
  8014f2:	89 c3                	mov    %eax,%ebx
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 1b                	js     801516 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	50                   	push   %eax
  801502:	e8 65 ff ff ff       	call   80146c <fstat>
  801507:	89 c6                	mov    %eax,%esi
	close(fd);
  801509:	89 1c 24             	mov    %ebx,(%esp)
  80150c:	e8 27 fc ff ff       	call   801138 <close>
	return r;
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	89 f3                	mov    %esi,%ebx
}
  801516:	89 d8                	mov    %ebx,%eax
  801518:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151b:	5b                   	pop    %ebx
  80151c:	5e                   	pop    %esi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    

0080151f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	89 c6                	mov    %eax,%esi
  801526:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801528:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80152f:	74 27                	je     801558 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801531:	6a 07                	push   $0x7
  801533:	68 00 50 80 00       	push   $0x805000
  801538:	56                   	push   %esi
  801539:	ff 35 00 40 80 00    	pushl  0x804000
  80153f:	e8 69 0c 00 00       	call   8021ad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801544:	83 c4 0c             	add    $0xc,%esp
  801547:	6a 00                	push   $0x0
  801549:	53                   	push   %ebx
  80154a:	6a 00                	push   $0x0
  80154c:	e8 f3 0b 00 00       	call   802144 <ipc_recv>
}
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801558:	83 ec 0c             	sub    $0xc,%esp
  80155b:	6a 01                	push   $0x1
  80155d:	e8 a3 0c 00 00       	call   802205 <ipc_find_env>
  801562:	a3 00 40 80 00       	mov    %eax,0x804000
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	eb c5                	jmp    801531 <fsipc+0x12>

0080156c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8b 40 0c             	mov    0xc(%eax),%eax
  801578:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801585:	ba 00 00 00 00       	mov    $0x0,%edx
  80158a:	b8 02 00 00 00       	mov    $0x2,%eax
  80158f:	e8 8b ff ff ff       	call   80151f <fsipc>
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <devfile_flush>:
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b1:	e8 69 ff ff ff       	call   80151f <fsipc>
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <devfile_stat>:
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	53                   	push   %ebx
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d2:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d7:	e8 43 ff ff ff       	call   80151f <fsipc>
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 2c                	js     80160c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	68 00 50 80 00       	push   $0x805000
  8015e8:	53                   	push   %ebx
  8015e9:	e8 b8 f2 ff ff       	call   8008a6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ee:	a1 80 50 80 00       	mov    0x805080,%eax
  8015f3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015f9:	a1 84 50 80 00       	mov    0x805084,%eax
  8015fe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <devfile_write>:
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	53                   	push   %ebx
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 40 0c             	mov    0xc(%eax),%eax
  801621:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801626:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80162c:	53                   	push   %ebx
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	68 08 50 80 00       	push   $0x805008
  801635:	e8 5c f4 ff ff       	call   800a96 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 04 00 00 00       	mov    $0x4,%eax
  801644:	e8 d6 fe ff ff       	call   80151f <fsipc>
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 0b                	js     80165b <devfile_write+0x4a>
	assert(r <= n);
  801650:	39 d8                	cmp    %ebx,%eax
  801652:	77 0c                	ja     801660 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801654:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801659:	7f 1e                	jg     801679 <devfile_write+0x68>
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    
	assert(r <= n);
  801660:	68 44 29 80 00       	push   $0x802944
  801665:	68 4b 29 80 00       	push   $0x80294b
  80166a:	68 98 00 00 00       	push   $0x98
  80166f:	68 60 29 80 00       	push   $0x802960
  801674:	e8 6a 0a 00 00       	call   8020e3 <_panic>
	assert(r <= PGSIZE);
  801679:	68 6b 29 80 00       	push   $0x80296b
  80167e:	68 4b 29 80 00       	push   $0x80294b
  801683:	68 99 00 00 00       	push   $0x99
  801688:	68 60 29 80 00       	push   $0x802960
  80168d:	e8 51 0a 00 00       	call   8020e3 <_panic>

00801692 <devfile_read>:
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	56                   	push   %esi
  801696:	53                   	push   %ebx
  801697:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016a5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	b8 03 00 00 00       	mov    $0x3,%eax
  8016b5:	e8 65 fe ff ff       	call   80151f <fsipc>
  8016ba:	89 c3                	mov    %eax,%ebx
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 1f                	js     8016df <devfile_read+0x4d>
	assert(r <= n);
  8016c0:	39 f0                	cmp    %esi,%eax
  8016c2:	77 24                	ja     8016e8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c9:	7f 33                	jg     8016fe <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	50                   	push   %eax
  8016cf:	68 00 50 80 00       	push   $0x805000
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	e8 58 f3 ff ff       	call   800a34 <memmove>
	return r;
  8016dc:	83 c4 10             	add    $0x10,%esp
}
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    
	assert(r <= n);
  8016e8:	68 44 29 80 00       	push   $0x802944
  8016ed:	68 4b 29 80 00       	push   $0x80294b
  8016f2:	6a 7c                	push   $0x7c
  8016f4:	68 60 29 80 00       	push   $0x802960
  8016f9:	e8 e5 09 00 00       	call   8020e3 <_panic>
	assert(r <= PGSIZE);
  8016fe:	68 6b 29 80 00       	push   $0x80296b
  801703:	68 4b 29 80 00       	push   $0x80294b
  801708:	6a 7d                	push   $0x7d
  80170a:	68 60 29 80 00       	push   $0x802960
  80170f:	e8 cf 09 00 00       	call   8020e3 <_panic>

00801714 <open>:
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
  801719:	83 ec 1c             	sub    $0x1c,%esp
  80171c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80171f:	56                   	push   %esi
  801720:	e8 48 f1 ff ff       	call   80086d <strlen>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80172d:	7f 6c                	jg     80179b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	e8 79 f8 ff ff       	call   800fb4 <fd_alloc>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 3c                	js     801780 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	56                   	push   %esi
  801748:	68 00 50 80 00       	push   $0x805000
  80174d:	e8 54 f1 ff ff       	call   8008a6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80175a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175d:	b8 01 00 00 00       	mov    $0x1,%eax
  801762:	e8 b8 fd ff ff       	call   80151f <fsipc>
  801767:	89 c3                	mov    %eax,%ebx
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 19                	js     801789 <open+0x75>
	return fd2num(fd);
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	ff 75 f4             	pushl  -0xc(%ebp)
  801776:	e8 12 f8 ff ff       	call   800f8d <fd2num>
  80177b:	89 c3                	mov    %eax,%ebx
  80177d:	83 c4 10             	add    $0x10,%esp
}
  801780:	89 d8                	mov    %ebx,%eax
  801782:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    
		fd_close(fd, 0);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	6a 00                	push   $0x0
  80178e:	ff 75 f4             	pushl  -0xc(%ebp)
  801791:	e8 1b f9 ff ff       	call   8010b1 <fd_close>
		return r;
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	eb e5                	jmp    801780 <open+0x6c>
		return -E_BAD_PATH;
  80179b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017a0:	eb de                	jmp    801780 <open+0x6c>

008017a2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b2:	e8 68 fd ff ff       	call   80151f <fsipc>
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017bf:	68 77 29 80 00       	push   $0x802977
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	e8 da f0 ff ff       	call   8008a6 <strcpy>
	return 0;
}
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <devsock_close>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 10             	sub    $0x10,%esp
  8017da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017dd:	53                   	push   %ebx
  8017de:	e8 61 0a 00 00       	call   802244 <pageref>
  8017e3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017eb:	83 f8 01             	cmp    $0x1,%eax
  8017ee:	74 07                	je     8017f7 <devsock_close+0x24>
}
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	ff 73 0c             	pushl  0xc(%ebx)
  8017fd:	e8 b9 02 00 00       	call   801abb <nsipc_close>
  801802:	89 c2                	mov    %eax,%edx
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	eb e7                	jmp    8017f0 <devsock_close+0x1d>

00801809 <devsock_write>:
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80180f:	6a 00                	push   $0x0
  801811:	ff 75 10             	pushl  0x10(%ebp)
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	ff 70 0c             	pushl  0xc(%eax)
  80181d:	e8 76 03 00 00       	call   801b98 <nsipc_send>
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <devsock_read>:
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	ff 75 10             	pushl  0x10(%ebp)
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	ff 70 0c             	pushl  0xc(%eax)
  801838:	e8 ef 02 00 00       	call   801b2c <nsipc_recv>
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <fd2sockid>:
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801845:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	e8 b7 f7 ff ff       	call   801006 <fd_lookup>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 10                	js     801866 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801859:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80185f:	39 08                	cmp    %ecx,(%eax)
  801861:	75 05                	jne    801868 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801863:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    
		return -E_NOT_SUPP;
  801868:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186d:	eb f7                	jmp    801866 <fd2sockid+0x27>

0080186f <alloc_sockfd>:
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 1c             	sub    $0x1c,%esp
  801877:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	e8 32 f7 ff ff       	call   800fb4 <fd_alloc>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 43                	js     8018ce <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	68 07 04 00 00       	push   $0x407
  801893:	ff 75 f4             	pushl  -0xc(%ebp)
  801896:	6a 00                	push   $0x0
  801898:	e8 fb f3 ff ff       	call   800c98 <sys_page_alloc>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 28                	js     8018ce <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018af:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018bb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	50                   	push   %eax
  8018c2:	e8 c6 f6 ff ff       	call   800f8d <fd2num>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	eb 0c                	jmp    8018da <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	56                   	push   %esi
  8018d2:	e8 e4 01 00 00       	call   801abb <nsipc_close>
		return r;
  8018d7:	83 c4 10             	add    $0x10,%esp
}
  8018da:	89 d8                	mov    %ebx,%eax
  8018dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <accept>:
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	e8 4e ff ff ff       	call   80183f <fd2sockid>
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 1b                	js     801910 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	50                   	push   %eax
  8018ff:	e8 0e 01 00 00       	call   801a12 <nsipc_accept>
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 05                	js     801910 <accept+0x2d>
	return alloc_sockfd(r);
  80190b:	e8 5f ff ff ff       	call   80186f <alloc_sockfd>
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <bind>:
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	e8 1f ff ff ff       	call   80183f <fd2sockid>
  801920:	85 c0                	test   %eax,%eax
  801922:	78 12                	js     801936 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	ff 75 10             	pushl  0x10(%ebp)
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	50                   	push   %eax
  80192e:	e8 31 01 00 00       	call   801a64 <nsipc_bind>
  801933:	83 c4 10             	add    $0x10,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <shutdown>:
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	e8 f9 fe ff ff       	call   80183f <fd2sockid>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 0f                	js     801959 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80194a:	83 ec 08             	sub    $0x8,%esp
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	50                   	push   %eax
  801951:	e8 43 01 00 00       	call   801a99 <nsipc_shutdown>
  801956:	83 c4 10             	add    $0x10,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <connect>:
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	e8 d6 fe ff ff       	call   80183f <fd2sockid>
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 12                	js     80197f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	ff 75 10             	pushl  0x10(%ebp)
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	50                   	push   %eax
  801977:	e8 59 01 00 00       	call   801ad5 <nsipc_connect>
  80197c:	83 c4 10             	add    $0x10,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <listen>:
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	e8 b0 fe ff ff       	call   80183f <fd2sockid>
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 0f                	js     8019a2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	e8 6b 01 00 00       	call   801b0a <nsipc_listen>
  80199f:	83 c4 10             	add    $0x10,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019aa:	ff 75 10             	pushl  0x10(%ebp)
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	e8 3e 02 00 00       	call   801bf6 <nsipc_socket>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 05                	js     8019c4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019bf:	e8 ab fe ff ff       	call   80186f <alloc_sockfd>
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019cf:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019d6:	74 26                	je     8019fe <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019d8:	6a 07                	push   $0x7
  8019da:	68 00 60 80 00       	push   $0x806000
  8019df:	53                   	push   %ebx
  8019e0:	ff 35 04 40 80 00    	pushl  0x804004
  8019e6:	e8 c2 07 00 00       	call   8021ad <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019eb:	83 c4 0c             	add    $0xc,%esp
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	e8 4b 07 00 00       	call   802144 <ipc_recv>
}
  8019f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	6a 02                	push   $0x2
  801a03:	e8 fd 07 00 00       	call   802205 <ipc_find_env>
  801a08:	a3 04 40 80 00       	mov    %eax,0x804004
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	eb c6                	jmp    8019d8 <nsipc+0x12>

00801a12 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	56                   	push   %esi
  801a16:	53                   	push   %ebx
  801a17:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a22:	8b 06                	mov    (%esi),%eax
  801a24:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a29:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2e:	e8 93 ff ff ff       	call   8019c6 <nsipc>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	85 c0                	test   %eax,%eax
  801a37:	79 09                	jns    801a42 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	ff 35 10 60 80 00    	pushl  0x806010
  801a4b:	68 00 60 80 00       	push   $0x806000
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 dc ef ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  801a58:	a1 10 60 80 00       	mov    0x806010,%eax
  801a5d:	89 06                	mov    %eax,(%esi)
  801a5f:	83 c4 10             	add    $0x10,%esp
	return r;
  801a62:	eb d5                	jmp    801a39 <nsipc_accept+0x27>

00801a64 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	53                   	push   %ebx
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a76:	53                   	push   %ebx
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	68 04 60 80 00       	push   $0x806004
  801a7f:	e8 b0 ef ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a84:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a8a:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8f:	e8 32 ff ff ff       	call   8019c6 <nsipc>
}
  801a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801aaf:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab4:	e8 0d ff ff ff       	call   8019c6 <nsipc>
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <nsipc_close>:

int
nsipc_close(int s)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ac9:	b8 04 00 00 00       	mov    $0x4,%eax
  801ace:	e8 f3 fe ff ff       	call   8019c6 <nsipc>
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ae7:	53                   	push   %ebx
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	68 04 60 80 00       	push   $0x806004
  801af0:	e8 3f ef ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801afb:	b8 05 00 00 00       	mov    $0x5,%eax
  801b00:	e8 c1 fe ff ff       	call   8019c6 <nsipc>
}
  801b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b20:	b8 06 00 00 00       	mov    $0x6,%eax
  801b25:	e8 9c fe ff ff       	call   8019c6 <nsipc>
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b3c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b42:	8b 45 14             	mov    0x14(%ebp),%eax
  801b45:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b4a:	b8 07 00 00 00       	mov    $0x7,%eax
  801b4f:	e8 72 fe ff ff       	call   8019c6 <nsipc>
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 1f                	js     801b79 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b5a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b5f:	7f 21                	jg     801b82 <nsipc_recv+0x56>
  801b61:	39 c6                	cmp    %eax,%esi
  801b63:	7c 1d                	jl     801b82 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	50                   	push   %eax
  801b69:	68 00 60 80 00       	push   $0x806000
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	e8 be ee ff ff       	call   800a34 <memmove>
  801b76:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b79:	89 d8                	mov    %ebx,%eax
  801b7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b82:	68 83 29 80 00       	push   $0x802983
  801b87:	68 4b 29 80 00       	push   $0x80294b
  801b8c:	6a 62                	push   $0x62
  801b8e:	68 98 29 80 00       	push   $0x802998
  801b93:	e8 4b 05 00 00       	call   8020e3 <_panic>

00801b98 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 04             	sub    $0x4,%esp
  801b9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801baa:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bb0:	7f 2e                	jg     801be0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	53                   	push   %ebx
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	68 0c 60 80 00       	push   $0x80600c
  801bbe:	e8 71 ee ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  801bc3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bd1:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd6:	e8 eb fd ff ff       	call   8019c6 <nsipc>
}
  801bdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    
	assert(size < 1600);
  801be0:	68 a4 29 80 00       	push   $0x8029a4
  801be5:	68 4b 29 80 00       	push   $0x80294b
  801bea:	6a 6d                	push   $0x6d
  801bec:	68 98 29 80 00       	push   $0x802998
  801bf1:	e8 ed 04 00 00       	call   8020e3 <_panic>

00801bf6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c07:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c14:	b8 09 00 00 00       	mov    $0x9,%eax
  801c19:	e8 a8 fd ff ff       	call   8019c6 <nsipc>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	56                   	push   %esi
  801c24:	53                   	push   %ebx
  801c25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 6a f3 ff ff       	call   800f9d <fd2data>
  801c33:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c35:	83 c4 08             	add    $0x8,%esp
  801c38:	68 b0 29 80 00       	push   $0x8029b0
  801c3d:	53                   	push   %ebx
  801c3e:	e8 63 ec ff ff       	call   8008a6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c43:	8b 46 04             	mov    0x4(%esi),%eax
  801c46:	2b 06                	sub    (%esi),%eax
  801c48:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c4e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c55:	00 00 00 
	stat->st_dev = &devpipe;
  801c58:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c5f:	30 80 00 
	return 0;
}
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
  801c67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    

00801c6e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	53                   	push   %ebx
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c78:	53                   	push   %ebx
  801c79:	6a 00                	push   $0x0
  801c7b:	e8 9d f0 ff ff       	call   800d1d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c80:	89 1c 24             	mov    %ebx,(%esp)
  801c83:	e8 15 f3 ff ff       	call   800f9d <fd2data>
  801c88:	83 c4 08             	add    $0x8,%esp
  801c8b:	50                   	push   %eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	e8 8a f0 ff ff       	call   800d1d <sys_page_unmap>
}
  801c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <_pipeisclosed>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	57                   	push   %edi
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	83 ec 1c             	sub    $0x1c,%esp
  801ca1:	89 c7                	mov    %eax,%edi
  801ca3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ca5:	a1 08 40 80 00       	mov    0x804008,%eax
  801caa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	57                   	push   %edi
  801cb1:	e8 8e 05 00 00       	call   802244 <pageref>
  801cb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cb9:	89 34 24             	mov    %esi,(%esp)
  801cbc:	e8 83 05 00 00       	call   802244 <pageref>
		nn = thisenv->env_runs;
  801cc1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cc7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	39 cb                	cmp    %ecx,%ebx
  801ccf:	74 1b                	je     801cec <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cd4:	75 cf                	jne    801ca5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cd6:	8b 42 58             	mov    0x58(%edx),%eax
  801cd9:	6a 01                	push   $0x1
  801cdb:	50                   	push   %eax
  801cdc:	53                   	push   %ebx
  801cdd:	68 b7 29 80 00       	push   $0x8029b7
  801ce2:	e8 60 e4 ff ff       	call   800147 <cprintf>
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	eb b9                	jmp    801ca5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cef:	0f 94 c0             	sete   %al
  801cf2:	0f b6 c0             	movzbl %al,%eax
}
  801cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    

00801cfd <devpipe_write>:
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	57                   	push   %edi
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 28             	sub    $0x28,%esp
  801d06:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d09:	56                   	push   %esi
  801d0a:	e8 8e f2 ff ff       	call   800f9d <fd2data>
  801d0f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	bf 00 00 00 00       	mov    $0x0,%edi
  801d19:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d1c:	74 4f                	je     801d6d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d1e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d21:	8b 0b                	mov    (%ebx),%ecx
  801d23:	8d 51 20             	lea    0x20(%ecx),%edx
  801d26:	39 d0                	cmp    %edx,%eax
  801d28:	72 14                	jb     801d3e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d2a:	89 da                	mov    %ebx,%edx
  801d2c:	89 f0                	mov    %esi,%eax
  801d2e:	e8 65 ff ff ff       	call   801c98 <_pipeisclosed>
  801d33:	85 c0                	test   %eax,%eax
  801d35:	75 3b                	jne    801d72 <devpipe_write+0x75>
			sys_yield();
  801d37:	e8 3d ef ff ff       	call   800c79 <sys_yield>
  801d3c:	eb e0                	jmp    801d1e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d41:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d45:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d48:	89 c2                	mov    %eax,%edx
  801d4a:	c1 fa 1f             	sar    $0x1f,%edx
  801d4d:	89 d1                	mov    %edx,%ecx
  801d4f:	c1 e9 1b             	shr    $0x1b,%ecx
  801d52:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d55:	83 e2 1f             	and    $0x1f,%edx
  801d58:	29 ca                	sub    %ecx,%edx
  801d5a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d5e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d62:	83 c0 01             	add    $0x1,%eax
  801d65:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d68:	83 c7 01             	add    $0x1,%edi
  801d6b:	eb ac                	jmp    801d19 <devpipe_write+0x1c>
	return i;
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	eb 05                	jmp    801d77 <devpipe_write+0x7a>
				return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5f                   	pop    %edi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    

00801d7f <devpipe_read>:
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	57                   	push   %edi
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	83 ec 18             	sub    $0x18,%esp
  801d88:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d8b:	57                   	push   %edi
  801d8c:	e8 0c f2 ff ff       	call   800f9d <fd2data>
  801d91:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	be 00 00 00 00       	mov    $0x0,%esi
  801d9b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d9e:	75 14                	jne    801db4 <devpipe_read+0x35>
	return i;
  801da0:	8b 45 10             	mov    0x10(%ebp),%eax
  801da3:	eb 02                	jmp    801da7 <devpipe_read+0x28>
				return i;
  801da5:	89 f0                	mov    %esi,%eax
}
  801da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5f                   	pop    %edi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    
			sys_yield();
  801daf:	e8 c5 ee ff ff       	call   800c79 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801db4:	8b 03                	mov    (%ebx),%eax
  801db6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801db9:	75 18                	jne    801dd3 <devpipe_read+0x54>
			if (i > 0)
  801dbb:	85 f6                	test   %esi,%esi
  801dbd:	75 e6                	jne    801da5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dbf:	89 da                	mov    %ebx,%edx
  801dc1:	89 f8                	mov    %edi,%eax
  801dc3:	e8 d0 fe ff ff       	call   801c98 <_pipeisclosed>
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	74 e3                	je     801daf <devpipe_read+0x30>
				return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	eb d4                	jmp    801da7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd3:	99                   	cltd   
  801dd4:	c1 ea 1b             	shr    $0x1b,%edx
  801dd7:	01 d0                	add    %edx,%eax
  801dd9:	83 e0 1f             	and    $0x1f,%eax
  801ddc:	29 d0                	sub    %edx,%eax
  801dde:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801de9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dec:	83 c6 01             	add    $0x1,%esi
  801def:	eb aa                	jmp    801d9b <devpipe_read+0x1c>

00801df1 <pipe>:
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	56                   	push   %esi
  801df5:	53                   	push   %ebx
  801df6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801df9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfc:	50                   	push   %eax
  801dfd:	e8 b2 f1 ff ff       	call   800fb4 <fd_alloc>
  801e02:	89 c3                	mov    %eax,%ebx
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 88 23 01 00 00    	js     801f32 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 07 04 00 00       	push   $0x407
  801e17:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1a:	6a 00                	push   $0x0
  801e1c:	e8 77 ee ff ff       	call   800c98 <sys_page_alloc>
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	85 c0                	test   %eax,%eax
  801e28:	0f 88 04 01 00 00    	js     801f32 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e34:	50                   	push   %eax
  801e35:	e8 7a f1 ff ff       	call   800fb4 <fd_alloc>
  801e3a:	89 c3                	mov    %eax,%ebx
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 88 db 00 00 00    	js     801f22 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 07 04 00 00       	push   $0x407
  801e4f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e52:	6a 00                	push   $0x0
  801e54:	e8 3f ee ff ff       	call   800c98 <sys_page_alloc>
  801e59:	89 c3                	mov    %eax,%ebx
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	0f 88 bc 00 00 00    	js     801f22 <pipe+0x131>
	va = fd2data(fd0);
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6c:	e8 2c f1 ff ff       	call   800f9d <fd2data>
  801e71:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e73:	83 c4 0c             	add    $0xc,%esp
  801e76:	68 07 04 00 00       	push   $0x407
  801e7b:	50                   	push   %eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	e8 15 ee ff ff       	call   800c98 <sys_page_alloc>
  801e83:	89 c3                	mov    %eax,%ebx
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	0f 88 82 00 00 00    	js     801f12 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e90:	83 ec 0c             	sub    $0xc,%esp
  801e93:	ff 75 f0             	pushl  -0x10(%ebp)
  801e96:	e8 02 f1 ff ff       	call   800f9d <fd2data>
  801e9b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ea2:	50                   	push   %eax
  801ea3:	6a 00                	push   $0x0
  801ea5:	56                   	push   %esi
  801ea6:	6a 00                	push   $0x0
  801ea8:	e8 2e ee ff ff       	call   800cdb <sys_page_map>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	83 c4 20             	add    $0x20,%esp
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	78 4e                	js     801f04 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eb6:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebe:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ecd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	ff 75 f4             	pushl  -0xc(%ebp)
  801edf:	e8 a9 f0 ff ff       	call   800f8d <fd2num>
  801ee4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee9:	83 c4 04             	add    $0x4,%esp
  801eec:	ff 75 f0             	pushl  -0x10(%ebp)
  801eef:	e8 99 f0 ff ff       	call   800f8d <fd2num>
  801ef4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f02:	eb 2e                	jmp    801f32 <pipe+0x141>
	sys_page_unmap(0, va);
  801f04:	83 ec 08             	sub    $0x8,%esp
  801f07:	56                   	push   %esi
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 0e ee ff ff       	call   800d1d <sys_page_unmap>
  801f0f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f12:	83 ec 08             	sub    $0x8,%esp
  801f15:	ff 75 f0             	pushl  -0x10(%ebp)
  801f18:	6a 00                	push   $0x0
  801f1a:	e8 fe ed ff ff       	call   800d1d <sys_page_unmap>
  801f1f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	ff 75 f4             	pushl  -0xc(%ebp)
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 ee ed ff ff       	call   800d1d <sys_page_unmap>
  801f2f:	83 c4 10             	add    $0x10,%esp
}
  801f32:	89 d8                	mov    %ebx,%eax
  801f34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <pipeisclosed>:
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f44:	50                   	push   %eax
  801f45:	ff 75 08             	pushl  0x8(%ebp)
  801f48:	e8 b9 f0 ff ff       	call   801006 <fd_lookup>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 18                	js     801f6c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5a:	e8 3e f0 ff ff       	call   800f9d <fd2data>
	return _pipeisclosed(fd, p);
  801f5f:	89 c2                	mov    %eax,%edx
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	e8 2f fd ff ff       	call   801c98 <_pipeisclosed>
  801f69:	83 c4 10             	add    $0x10,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f73:	c3                   	ret    

00801f74 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f7a:	68 cf 29 80 00       	push   $0x8029cf
  801f7f:	ff 75 0c             	pushl  0xc(%ebp)
  801f82:	e8 1f e9 ff ff       	call   8008a6 <strcpy>
	return 0;
}
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <devcons_write>:
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	53                   	push   %ebx
  801f94:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f9a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f9f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fa5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa8:	73 31                	jae    801fdb <devcons_write+0x4d>
		m = n - tot;
  801faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fad:	29 f3                	sub    %esi,%ebx
  801faf:	83 fb 7f             	cmp    $0x7f,%ebx
  801fb2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fb7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	53                   	push   %ebx
  801fbe:	89 f0                	mov    %esi,%eax
  801fc0:	03 45 0c             	add    0xc(%ebp),%eax
  801fc3:	50                   	push   %eax
  801fc4:	57                   	push   %edi
  801fc5:	e8 6a ea ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  801fca:	83 c4 08             	add    $0x8,%esp
  801fcd:	53                   	push   %ebx
  801fce:	57                   	push   %edi
  801fcf:	e8 08 ec ff ff       	call   800bdc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fd4:	01 de                	add    %ebx,%esi
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	eb ca                	jmp    801fa5 <devcons_write+0x17>
}
  801fdb:	89 f0                	mov    %esi,%eax
  801fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5f                   	pop    %edi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <devcons_read>:
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ff0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff4:	74 21                	je     802017 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ff6:	e8 ff eb ff ff       	call   800bfa <sys_cgetc>
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	75 07                	jne    802006 <devcons_read+0x21>
		sys_yield();
  801fff:	e8 75 ec ff ff       	call   800c79 <sys_yield>
  802004:	eb f0                	jmp    801ff6 <devcons_read+0x11>
	if (c < 0)
  802006:	78 0f                	js     802017 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802008:	83 f8 04             	cmp    $0x4,%eax
  80200b:	74 0c                	je     802019 <devcons_read+0x34>
	*(char*)vbuf = c;
  80200d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802010:	88 02                	mov    %al,(%edx)
	return 1;
  802012:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    
		return 0;
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	eb f7                	jmp    802017 <devcons_read+0x32>

00802020 <cputchar>:
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80202c:	6a 01                	push   $0x1
  80202e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802031:	50                   	push   %eax
  802032:	e8 a5 eb ff ff       	call   800bdc <sys_cputs>
}
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <getchar>:
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802042:	6a 01                	push   $0x1
  802044:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802047:	50                   	push   %eax
  802048:	6a 00                	push   $0x0
  80204a:	e8 27 f2 ff ff       	call   801276 <read>
	if (r < 0)
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	85 c0                	test   %eax,%eax
  802054:	78 06                	js     80205c <getchar+0x20>
	if (r < 1)
  802056:	74 06                	je     80205e <getchar+0x22>
	return c;
  802058:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    
		return -E_EOF;
  80205e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802063:	eb f7                	jmp    80205c <getchar+0x20>

00802065 <iscons>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80206b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206e:	50                   	push   %eax
  80206f:	ff 75 08             	pushl  0x8(%ebp)
  802072:	e8 8f ef ff ff       	call   801006 <fd_lookup>
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 11                	js     80208f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802087:	39 10                	cmp    %edx,(%eax)
  802089:	0f 94 c0             	sete   %al
  80208c:	0f b6 c0             	movzbl %al,%eax
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <opencons>:
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802097:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209a:	50                   	push   %eax
  80209b:	e8 14 ef ff ff       	call   800fb4 <fd_alloc>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 3a                	js     8020e1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 07 04 00 00       	push   $0x407
  8020af:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 df eb ff ff       	call   800c98 <sys_page_alloc>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 21                	js     8020e1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020c9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	50                   	push   %eax
  8020d9:	e8 af ee ff ff       	call   800f8d <fd2num>
  8020de:	83 c4 10             	add    $0x10,%esp
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020e8:	a1 08 40 80 00       	mov    0x804008,%eax
  8020ed:	8b 40 48             	mov    0x48(%eax),%eax
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 00 2a 80 00       	push   $0x802a00
  8020f8:	50                   	push   %eax
  8020f9:	68 ea 24 80 00       	push   $0x8024ea
  8020fe:	e8 44 e0 ff ff       	call   800147 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802103:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802106:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80210c:	e8 49 eb ff ff       	call   800c5a <sys_getenvid>
  802111:	83 c4 04             	add    $0x4,%esp
  802114:	ff 75 0c             	pushl  0xc(%ebp)
  802117:	ff 75 08             	pushl  0x8(%ebp)
  80211a:	56                   	push   %esi
  80211b:	50                   	push   %eax
  80211c:	68 dc 29 80 00       	push   $0x8029dc
  802121:	e8 21 e0 ff ff       	call   800147 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802126:	83 c4 18             	add    $0x18,%esp
  802129:	53                   	push   %ebx
  80212a:	ff 75 10             	pushl  0x10(%ebp)
  80212d:	e8 c4 df ff ff       	call   8000f6 <vcprintf>
	cprintf("\n");
  802132:	c7 04 24 1a 2a 80 00 	movl   $0x802a1a,(%esp)
  802139:	e8 09 e0 ff ff       	call   800147 <cprintf>
  80213e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802141:	cc                   	int3   
  802142:	eb fd                	jmp    802141 <_panic+0x5e>

00802144 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	8b 75 08             	mov    0x8(%ebp),%esi
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802152:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802154:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802159:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	50                   	push   %eax
  802160:	e8 e3 ec ff ff       	call   800e48 <sys_ipc_recv>
	if(ret < 0){
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 2b                	js     802197 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80216c:	85 f6                	test   %esi,%esi
  80216e:	74 0a                	je     80217a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802170:	a1 08 40 80 00       	mov    0x804008,%eax
  802175:	8b 40 78             	mov    0x78(%eax),%eax
  802178:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80217a:	85 db                	test   %ebx,%ebx
  80217c:	74 0a                	je     802188 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80217e:	a1 08 40 80 00       	mov    0x804008,%eax
  802183:	8b 40 7c             	mov    0x7c(%eax),%eax
  802186:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802188:	a1 08 40 80 00       	mov    0x804008,%eax
  80218d:	8b 40 74             	mov    0x74(%eax),%eax
}
  802190:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5d                   	pop    %ebp
  802196:	c3                   	ret    
		if(from_env_store)
  802197:	85 f6                	test   %esi,%esi
  802199:	74 06                	je     8021a1 <ipc_recv+0x5d>
			*from_env_store = 0;
  80219b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021a1:	85 db                	test   %ebx,%ebx
  8021a3:	74 eb                	je     802190 <ipc_recv+0x4c>
			*perm_store = 0;
  8021a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ab:	eb e3                	jmp    802190 <ipc_recv+0x4c>

008021ad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	57                   	push   %edi
  8021b1:	56                   	push   %esi
  8021b2:	53                   	push   %ebx
  8021b3:	83 ec 0c             	sub    $0xc,%esp
  8021b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021bf:	85 db                	test   %ebx,%ebx
  8021c1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021c6:	0f 44 d8             	cmove  %eax,%ebx
  8021c9:	eb 05                	jmp    8021d0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021cb:	e8 a9 ea ff ff       	call   800c79 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021d0:	ff 75 14             	pushl  0x14(%ebp)
  8021d3:	53                   	push   %ebx
  8021d4:	56                   	push   %esi
  8021d5:	57                   	push   %edi
  8021d6:	e8 4a ec ff ff       	call   800e25 <sys_ipc_try_send>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	74 1b                	je     8021fd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021e2:	79 e7                	jns    8021cb <ipc_send+0x1e>
  8021e4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021e7:	74 e2                	je     8021cb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 07 2a 80 00       	push   $0x802a07
  8021f1:	6a 46                	push   $0x46
  8021f3:	68 1c 2a 80 00       	push   $0x802a1c
  8021f8:	e8 e6 fe ff ff       	call   8020e3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8021fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    

00802205 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802210:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802216:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80221c:	8b 52 50             	mov    0x50(%edx),%edx
  80221f:	39 ca                	cmp    %ecx,%edx
  802221:	74 11                	je     802234 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802223:	83 c0 01             	add    $0x1,%eax
  802226:	3d 00 04 00 00       	cmp    $0x400,%eax
  80222b:	75 e3                	jne    802210 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	eb 0e                	jmp    802242 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802234:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80223a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80223f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    

00802244 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	c1 e8 16             	shr    $0x16,%eax
  80224f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80225b:	f6 c1 01             	test   $0x1,%cl
  80225e:	74 1d                	je     80227d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802260:	c1 ea 0c             	shr    $0xc,%edx
  802263:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80226a:	f6 c2 01             	test   $0x1,%dl
  80226d:	74 0e                	je     80227d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80226f:	c1 ea 0c             	shr    $0xc,%edx
  802272:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802279:	ef 
  80227a:	0f b7 c0             	movzwl %ax,%eax
}
  80227d:	5d                   	pop    %ebp
  80227e:	c3                   	ret    
  80227f:	90                   	nop

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
