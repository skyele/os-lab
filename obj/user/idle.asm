
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 30 80 00 00 	movl   $0x802500,0x803000
  800040:	25 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 46 0c 00 00       	call   800c8e <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800055:	e8 15 0c 00 00       	call   800c6f <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006f:	85 db                	test   %ebx,%ebx
  800071:	7e 07                	jle    80007a <libmain+0x30>
		binaryname = argv[0];
  800073:	8b 06                	mov    (%esi),%eax
  800075:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007a:	83 ec 08             	sub    $0x8,%esp
  80007d:	56                   	push   %esi
  80007e:	53                   	push   %ebx
  80007f:	e8 af ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800084:	e8 0a 00 00 00       	call   800093 <exit>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800099:	a1 08 40 80 00       	mov    0x804008,%eax
  80009e:	8b 40 48             	mov    0x48(%eax),%eax
  8000a1:	68 1c 25 80 00       	push   $0x80251c
  8000a6:	50                   	push   %eax
  8000a7:	68 0f 25 80 00       	push   $0x80250f
  8000ac:	e8 ab 00 00 00       	call   80015c <cprintf>
	close_all();
  8000b1:	e8 c4 10 00 00       	call   80117a <close_all>
	sys_env_destroy(0);
  8000b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bd:	e8 6c 0b 00 00       	call   800c2e <sys_env_destroy>
}
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	c9                   	leave  
  8000c6:	c3                   	ret    

008000c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	53                   	push   %ebx
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d1:	8b 13                	mov    (%ebx),%edx
  8000d3:	8d 42 01             	lea    0x1(%edx),%eax
  8000d6:	89 03                	mov    %eax,(%ebx)
  8000d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e4:	74 09                	je     8000ef <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 ff 00 00 00       	push   $0xff
  8000f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fa:	50                   	push   %eax
  8000fb:	e8 f1 0a 00 00       	call   800bf1 <sys_cputs>
		b->idx = 0;
  800100:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	eb db                	jmp    8000e6 <putch+0x1f>

0080010b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011b:	00 00 00 
	b.cnt = 0;
  80011e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800125:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800128:	ff 75 0c             	pushl  0xc(%ebp)
  80012b:	ff 75 08             	pushl  0x8(%ebp)
  80012e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800134:	50                   	push   %eax
  800135:	68 c7 00 80 00       	push   $0x8000c7
  80013a:	e8 4a 01 00 00       	call   800289 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013f:	83 c4 08             	add    $0x8,%esp
  800142:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800148:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014e:	50                   	push   %eax
  80014f:	e8 9d 0a 00 00       	call   800bf1 <sys_cputs>

	return b.cnt;
}
  800154:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800162:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800165:	50                   	push   %eax
  800166:	ff 75 08             	pushl  0x8(%ebp)
  800169:	e8 9d ff ff ff       	call   80010b <vcprintf>
	va_end(ap);

	return cnt;
}
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 1c             	sub    $0x1c,%esp
  800179:	89 c6                	mov    %eax,%esi
  80017b:	89 d7                	mov    %edx,%edi
  80017d:	8b 45 08             	mov    0x8(%ebp),%eax
  800180:	8b 55 0c             	mov    0xc(%ebp),%edx
  800183:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800186:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800189:	8b 45 10             	mov    0x10(%ebp),%eax
  80018c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80018f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800193:	74 2c                	je     8001c1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800195:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800198:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80019f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001a5:	39 c2                	cmp    %eax,%edx
  8001a7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001aa:	73 43                	jae    8001ef <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ac:	83 eb 01             	sub    $0x1,%ebx
  8001af:	85 db                	test   %ebx,%ebx
  8001b1:	7e 6c                	jle    80021f <printnum+0xaf>
				putch(padc, putdat);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	57                   	push   %edi
  8001b7:	ff 75 18             	pushl  0x18(%ebp)
  8001ba:	ff d6                	call   *%esi
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	eb eb                	jmp    8001ac <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	6a 20                	push   $0x20
  8001c6:	6a 00                	push   $0x0
  8001c8:	50                   	push   %eax
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	89 fa                	mov    %edi,%edx
  8001d1:	89 f0                	mov    %esi,%eax
  8001d3:	e8 98 ff ff ff       	call   800170 <printnum>
		while (--width > 0)
  8001d8:	83 c4 20             	add    $0x20,%esp
  8001db:	83 eb 01             	sub    $0x1,%ebx
  8001de:	85 db                	test   %ebx,%ebx
  8001e0:	7e 65                	jle    800247 <printnum+0xd7>
			putch(padc, putdat);
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	57                   	push   %edi
  8001e6:	6a 20                	push   $0x20
  8001e8:	ff d6                	call   *%esi
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	eb ec                	jmp    8001db <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 18             	pushl  0x18(%ebp)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	50                   	push   %eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800200:	ff 75 d8             	pushl  -0x28(%ebp)
  800203:	ff 75 e4             	pushl  -0x1c(%ebp)
  800206:	ff 75 e0             	pushl  -0x20(%ebp)
  800209:	e8 92 20 00 00       	call   8022a0 <__udivdi3>
  80020e:	83 c4 18             	add    $0x18,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	89 fa                	mov    %edi,%edx
  800215:	89 f0                	mov    %esi,%eax
  800217:	e8 54 ff ff ff       	call   800170 <printnum>
  80021c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	57                   	push   %edi
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	ff 75 dc             	pushl  -0x24(%ebp)
  800229:	ff 75 d8             	pushl  -0x28(%ebp)
  80022c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022f:	ff 75 e0             	pushl  -0x20(%ebp)
  800232:	e8 79 21 00 00       	call   8023b0 <__umoddi3>
  800237:	83 c4 14             	add    $0x14,%esp
  80023a:	0f be 80 21 25 80 00 	movsbl 0x802521(%eax),%eax
  800241:	50                   	push   %eax
  800242:	ff d6                	call   *%esi
  800244:	83 c4 10             	add    $0x10,%esp
	}
}
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    

0080024f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800255:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800259:	8b 10                	mov    (%eax),%edx
  80025b:	3b 50 04             	cmp    0x4(%eax),%edx
  80025e:	73 0a                	jae    80026a <sprintputch+0x1b>
		*b->buf++ = ch;
  800260:	8d 4a 01             	lea    0x1(%edx),%ecx
  800263:	89 08                	mov    %ecx,(%eax)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	88 02                	mov    %al,(%edx)
}
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <printfmt>:
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800272:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800275:	50                   	push   %eax
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	e8 05 00 00 00       	call   800289 <vprintfmt>
}
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <vprintfmt>:
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	57                   	push   %edi
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	83 ec 3c             	sub    $0x3c,%esp
  800292:	8b 75 08             	mov    0x8(%ebp),%esi
  800295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800298:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029b:	e9 32 04 00 00       	jmp    8006d2 <vprintfmt+0x449>
		padc = ' ';
  8002a0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002a4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002ab:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002c7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002cc:	8d 47 01             	lea    0x1(%edi),%eax
  8002cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d2:	0f b6 17             	movzbl (%edi),%edx
  8002d5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d8:	3c 55                	cmp    $0x55,%al
  8002da:	0f 87 12 05 00 00    	ja     8007f2 <vprintfmt+0x569>
  8002e0:	0f b6 c0             	movzbl %al,%eax
  8002e3:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  8002ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ed:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002f1:	eb d9                	jmp    8002cc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002fa:	eb d0                	jmp    8002cc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	0f b6 d2             	movzbl %dl,%edx
  8002ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	89 75 08             	mov    %esi,0x8(%ebp)
  80030a:	eb 03                	jmp    80030f <vprintfmt+0x86>
  80030c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800312:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800316:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800319:	8d 72 d0             	lea    -0x30(%edx),%esi
  80031c:	83 fe 09             	cmp    $0x9,%esi
  80031f:	76 eb                	jbe    80030c <vprintfmt+0x83>
  800321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	eb 14                	jmp    80033d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800329:	8b 45 14             	mov    0x14(%ebp),%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8d 40 04             	lea    0x4(%eax),%eax
  800337:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80033d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800341:	79 89                	jns    8002cc <vprintfmt+0x43>
				width = precision, precision = -1;
  800343:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800346:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800349:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800350:	e9 77 ff ff ff       	jmp    8002cc <vprintfmt+0x43>
  800355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	0f 48 c1             	cmovs  %ecx,%eax
  80035d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800363:	e9 64 ff ff ff       	jmp    8002cc <vprintfmt+0x43>
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800372:	e9 55 ff ff ff       	jmp    8002cc <vprintfmt+0x43>
			lflag++;
  800377:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037e:	e9 49 ff ff ff       	jmp    8002cc <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800383:	8b 45 14             	mov    0x14(%ebp),%eax
  800386:	8d 78 04             	lea    0x4(%eax),%edi
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	53                   	push   %ebx
  80038d:	ff 30                	pushl  (%eax)
  80038f:	ff d6                	call   *%esi
			break;
  800391:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800394:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800397:	e9 33 03 00 00       	jmp    8006cf <vprintfmt+0x446>
			err = va_arg(ap, int);
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8d 78 04             	lea    0x4(%eax),%edi
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	99                   	cltd   
  8003a5:	31 d0                	xor    %edx,%eax
  8003a7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a9:	83 f8 11             	cmp    $0x11,%eax
  8003ac:	7f 23                	jg     8003d1 <vprintfmt+0x148>
  8003ae:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003b5:	85 d2                	test   %edx,%edx
  8003b7:	74 18                	je     8003d1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003b9:	52                   	push   %edx
  8003ba:	68 7d 29 80 00       	push   $0x80297d
  8003bf:	53                   	push   %ebx
  8003c0:	56                   	push   %esi
  8003c1:	e8 a6 fe ff ff       	call   80026c <printfmt>
  8003c6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cc:	e9 fe 02 00 00       	jmp    8006cf <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003d1:	50                   	push   %eax
  8003d2:	68 39 25 80 00       	push   $0x802539
  8003d7:	53                   	push   %ebx
  8003d8:	56                   	push   %esi
  8003d9:	e8 8e fe ff ff       	call   80026c <printfmt>
  8003de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e4:	e9 e6 02 00 00       	jmp    8006cf <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	83 c0 04             	add    $0x4,%eax
  8003ef:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003f7:	85 c9                	test   %ecx,%ecx
  8003f9:	b8 32 25 80 00       	mov    $0x802532,%eax
  8003fe:	0f 45 c1             	cmovne %ecx,%eax
  800401:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800404:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800408:	7e 06                	jle    800410 <vprintfmt+0x187>
  80040a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80040e:	75 0d                	jne    80041d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800410:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800413:	89 c7                	mov    %eax,%edi
  800415:	03 45 e0             	add    -0x20(%ebp),%eax
  800418:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041b:	eb 53                	jmp    800470 <vprintfmt+0x1e7>
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 d8             	pushl  -0x28(%ebp)
  800423:	50                   	push   %eax
  800424:	e8 71 04 00 00       	call   80089a <strnlen>
  800429:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042c:	29 c1                	sub    %eax,%ecx
  80042e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800436:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80043a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043d:	eb 0f                	jmp    80044e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	53                   	push   %ebx
  800443:	ff 75 e0             	pushl  -0x20(%ebp)
  800446:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800448:	83 ef 01             	sub    $0x1,%edi
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	85 ff                	test   %edi,%edi
  800450:	7f ed                	jg     80043f <vprintfmt+0x1b6>
  800452:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800455:	85 c9                	test   %ecx,%ecx
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	0f 49 c1             	cmovns %ecx,%eax
  80045f:	29 c1                	sub    %eax,%ecx
  800461:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800464:	eb aa                	jmp    800410 <vprintfmt+0x187>
					putch(ch, putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	53                   	push   %ebx
  80046a:	52                   	push   %edx
  80046b:	ff d6                	call   *%esi
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800473:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800475:	83 c7 01             	add    $0x1,%edi
  800478:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047c:	0f be d0             	movsbl %al,%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	74 4b                	je     8004ce <vprintfmt+0x245>
  800483:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800487:	78 06                	js     80048f <vprintfmt+0x206>
  800489:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048d:	78 1e                	js     8004ad <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80048f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800493:	74 d1                	je     800466 <vprintfmt+0x1dd>
  800495:	0f be c0             	movsbl %al,%eax
  800498:	83 e8 20             	sub    $0x20,%eax
  80049b:	83 f8 5e             	cmp    $0x5e,%eax
  80049e:	76 c6                	jbe    800466 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	6a 3f                	push   $0x3f
  8004a6:	ff d6                	call   *%esi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	eb c3                	jmp    800470 <vprintfmt+0x1e7>
  8004ad:	89 cf                	mov    %ecx,%edi
  8004af:	eb 0e                	jmp    8004bf <vprintfmt+0x236>
				putch(' ', putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	6a 20                	push   $0x20
  8004b7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004b9:	83 ef 01             	sub    $0x1,%edi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 ff                	test   %edi,%edi
  8004c1:	7f ee                	jg     8004b1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c9:	e9 01 02 00 00       	jmp    8006cf <vprintfmt+0x446>
  8004ce:	89 cf                	mov    %ecx,%edi
  8004d0:	eb ed                	jmp    8004bf <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004d5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004dc:	e9 eb fd ff ff       	jmp    8002cc <vprintfmt+0x43>
	if (lflag >= 2)
  8004e1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004e5:	7f 21                	jg     800508 <vprintfmt+0x27f>
	else if (lflag)
  8004e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004eb:	74 68                	je     800555 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f5:	89 c1                	mov    %eax,%ecx
  8004f7:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8d 40 04             	lea    0x4(%eax),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	eb 17                	jmp    80051f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8b 50 04             	mov    0x4(%eax),%edx
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800513:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8d 40 08             	lea    0x8(%eax),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80051f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800522:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800525:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800528:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80052b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80052f:	78 3f                	js     800570 <vprintfmt+0x2e7>
			base = 10;
  800531:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800536:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80053a:	0f 84 71 01 00 00    	je     8006b1 <vprintfmt+0x428>
				putch('+', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	53                   	push   %ebx
  800544:	6a 2b                	push   $0x2b
  800546:	ff d6                	call   *%esi
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 5c 01 00 00       	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80055d:	89 c1                	mov    %eax,%ecx
  80055f:	c1 f9 1f             	sar    $0x1f,%ecx
  800562:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8d 40 04             	lea    0x4(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
  80056e:	eb af                	jmp    80051f <vprintfmt+0x296>
				putch('-', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 2d                	push   $0x2d
  800576:	ff d6                	call   *%esi
				num = -(long long) num;
  800578:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057e:	f7 d8                	neg    %eax
  800580:	83 d2 00             	adc    $0x0,%edx
  800583:	f7 da                	neg    %edx
  800585:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800588:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 19 01 00 00       	jmp    8006b1 <vprintfmt+0x428>
	if (lflag >= 2)
  800598:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80059c:	7f 29                	jg     8005c7 <vprintfmt+0x33e>
	else if (lflag)
  80059e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005a2:	74 44                	je     8005e8 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c2:	e9 ea 00 00 00       	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 50 04             	mov    0x4(%eax),%edx
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 08             	lea    0x8(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	e9 c9 00 00 00       	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 04             	lea    0x4(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800601:	b8 0a 00 00 00       	mov    $0xa,%eax
  800606:	e9 a6 00 00 00       	jmp    8006b1 <vprintfmt+0x428>
			putch('0', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 30                	push   $0x30
  800611:	ff d6                	call   *%esi
	if (lflag >= 2)
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061a:	7f 26                	jg     800642 <vprintfmt+0x3b9>
	else if (lflag)
  80061c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800620:	74 3e                	je     800660 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063b:	b8 08 00 00 00       	mov    $0x8,%eax
  800640:	eb 6f                	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 50 04             	mov    0x4(%eax),%edx
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 08             	lea    0x8(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800659:	b8 08 00 00 00       	mov    $0x8,%eax
  80065e:	eb 51                	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
  80067e:	eb 31                	jmp    8006b1 <vprintfmt+0x428>
			putch('0', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 30                	push   $0x30
  800686:	ff d6                	call   *%esi
			putch('x', putdat);
  800688:	83 c4 08             	add    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 78                	push   $0x78
  80068e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006a0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ac:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006b8:	52                   	push   %edx
  8006b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bc:	50                   	push   %eax
  8006bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c3:	89 da                	mov    %ebx,%edx
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	e8 a4 fa ff ff       	call   800170 <printnum>
			break;
  8006cc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d2:	83 c7 01             	add    $0x1,%edi
  8006d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d9:	83 f8 25             	cmp    $0x25,%eax
  8006dc:	0f 84 be fb ff ff    	je     8002a0 <vprintfmt+0x17>
			if (ch == '\0')
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	0f 84 28 01 00 00    	je     800812 <vprintfmt+0x589>
			putch(ch, putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	50                   	push   %eax
  8006ef:	ff d6                	call   *%esi
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb dc                	jmp    8006d2 <vprintfmt+0x449>
	if (lflag >= 2)
  8006f6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fa:	7f 26                	jg     800722 <vprintfmt+0x499>
	else if (lflag)
  8006fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800700:	74 41                	je     800743 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071b:	b8 10 00 00 00       	mov    $0x10,%eax
  800720:	eb 8f                	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 50 04             	mov    0x4(%eax),%edx
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 40 08             	lea    0x8(%eax),%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800739:	b8 10 00 00 00       	mov    $0x10,%eax
  80073e:	e9 6e ff ff ff       	jmp    8006b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075c:	b8 10 00 00 00       	mov    $0x10,%eax
  800761:	e9 4b ff ff ff       	jmp    8006b1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	83 c0 04             	add    $0x4,%eax
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	85 c0                	test   %eax,%eax
  800776:	74 14                	je     80078c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800778:	8b 13                	mov    (%ebx),%edx
  80077a:	83 fa 7f             	cmp    $0x7f,%edx
  80077d:	7f 37                	jg     8007b6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80077f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800781:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
  800787:	e9 43 ff ff ff       	jmp    8006cf <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80078c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800791:	bf 55 26 80 00       	mov    $0x802655,%edi
							putch(ch, putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	50                   	push   %eax
  80079b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80079d:	83 c7 01             	add    $0x1,%edi
  8007a0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	75 eb                	jne    800796 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b1:	e9 19 ff ff ff       	jmp    8006cf <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007b6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bd:	bf 8d 26 80 00       	mov    $0x80268d,%edi
							putch(ch, putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	50                   	push   %eax
  8007c7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	75 eb                	jne    8007c2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	e9 ed fe ff ff       	jmp    8006cf <vprintfmt+0x446>
			putch(ch, putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 25                	push   $0x25
  8007e8:	ff d6                	call   *%esi
			break;
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	e9 dd fe ff ff       	jmp    8006cf <vprintfmt+0x446>
			putch('%', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	6a 25                	push   $0x25
  8007f8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 f8                	mov    %edi,%eax
  8007ff:	eb 03                	jmp    800804 <vprintfmt+0x57b>
  800801:	83 e8 01             	sub    $0x1,%eax
  800804:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800808:	75 f7                	jne    800801 <vprintfmt+0x578>
  80080a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080d:	e9 bd fe ff ff       	jmp    8006cf <vprintfmt+0x446>
}
  800812:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800815:	5b                   	pop    %ebx
  800816:	5e                   	pop    %esi
  800817:	5f                   	pop    %edi
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 18             	sub    $0x18,%esp
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800826:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800829:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80082d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800830:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800837:	85 c0                	test   %eax,%eax
  800839:	74 26                	je     800861 <vsnprintf+0x47>
  80083b:	85 d2                	test   %edx,%edx
  80083d:	7e 22                	jle    800861 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083f:	ff 75 14             	pushl  0x14(%ebp)
  800842:	ff 75 10             	pushl  0x10(%ebp)
  800845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	68 4f 02 80 00       	push   $0x80024f
  80084e:	e8 36 fa ff ff       	call   800289 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800856:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085c:	83 c4 10             	add    $0x10,%esp
}
  80085f:	c9                   	leave  
  800860:	c3                   	ret    
		return -E_INVAL;
  800861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800866:	eb f7                	jmp    80085f <vsnprintf+0x45>

00800868 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800871:	50                   	push   %eax
  800872:	ff 75 10             	pushl  0x10(%ebp)
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 08             	pushl  0x8(%ebp)
  80087b:	e8 9a ff ff ff       	call   80081a <vsnprintf>
	va_end(ap);

	return rc;
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800888:	b8 00 00 00 00       	mov    $0x0,%eax
  80088d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800891:	74 05                	je     800898 <strlen+0x16>
		n++;
  800893:	83 c0 01             	add    $0x1,%eax
  800896:	eb f5                	jmp    80088d <strlen+0xb>
	return n;
}
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	74 0d                	je     8008b9 <strnlen+0x1f>
  8008ac:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008b0:	74 05                	je     8008b7 <strnlen+0x1d>
		n++;
  8008b2:	83 c2 01             	add    $0x1,%edx
  8008b5:	eb f1                	jmp    8008a8 <strnlen+0xe>
  8008b7:	89 d0                	mov    %edx,%eax
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ce:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008d1:	83 c2 01             	add    $0x1,%edx
  8008d4:	84 c9                	test   %cl,%cl
  8008d6:	75 f2                	jne    8008ca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	83 ec 10             	sub    $0x10,%esp
  8008e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e5:	53                   	push   %ebx
  8008e6:	e8 97 ff ff ff       	call   800882 <strlen>
  8008eb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	01 d8                	add    %ebx,%eax
  8008f3:	50                   	push   %eax
  8008f4:	e8 c2 ff ff ff       	call   8008bb <strcpy>
	return dst;
}
  8008f9:	89 d8                	mov    %ebx,%eax
  8008fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	56                   	push   %esi
  800904:	53                   	push   %ebx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090b:	89 c6                	mov    %eax,%esi
  80090d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800910:	89 c2                	mov    %eax,%edx
  800912:	39 f2                	cmp    %esi,%edx
  800914:	74 11                	je     800927 <strncpy+0x27>
		*dst++ = *src;
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 19             	movzbl (%ecx),%ebx
  80091c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091f:	80 fb 01             	cmp    $0x1,%bl
  800922:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800925:	eb eb                	jmp    800912 <strncpy+0x12>
	}
	return ret;
}
  800927:	5b                   	pop    %ebx
  800928:	5e                   	pop    %esi
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
  800930:	8b 75 08             	mov    0x8(%ebp),%esi
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800936:	8b 55 10             	mov    0x10(%ebp),%edx
  800939:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093b:	85 d2                	test   %edx,%edx
  80093d:	74 21                	je     800960 <strlcpy+0x35>
  80093f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800943:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800945:	39 c2                	cmp    %eax,%edx
  800947:	74 14                	je     80095d <strlcpy+0x32>
  800949:	0f b6 19             	movzbl (%ecx),%ebx
  80094c:	84 db                	test   %bl,%bl
  80094e:	74 0b                	je     80095b <strlcpy+0x30>
			*dst++ = *src++;
  800950:	83 c1 01             	add    $0x1,%ecx
  800953:	83 c2 01             	add    $0x1,%edx
  800956:	88 5a ff             	mov    %bl,-0x1(%edx)
  800959:	eb ea                	jmp    800945 <strlcpy+0x1a>
  80095b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80095d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800960:	29 f0                	sub    %esi,%eax
}
  800962:	5b                   	pop    %ebx
  800963:	5e                   	pop    %esi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096f:	0f b6 01             	movzbl (%ecx),%eax
  800972:	84 c0                	test   %al,%al
  800974:	74 0c                	je     800982 <strcmp+0x1c>
  800976:	3a 02                	cmp    (%edx),%al
  800978:	75 08                	jne    800982 <strcmp+0x1c>
		p++, q++;
  80097a:	83 c1 01             	add    $0x1,%ecx
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	eb ed                	jmp    80096f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800982:	0f b6 c0             	movzbl %al,%eax
  800985:	0f b6 12             	movzbl (%edx),%edx
  800988:	29 d0                	sub    %edx,%eax
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	89 c3                	mov    %eax,%ebx
  800998:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099b:	eb 06                	jmp    8009a3 <strncmp+0x17>
		n--, p++, q++;
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a3:	39 d8                	cmp    %ebx,%eax
  8009a5:	74 16                	je     8009bd <strncmp+0x31>
  8009a7:	0f b6 08             	movzbl (%eax),%ecx
  8009aa:	84 c9                	test   %cl,%cl
  8009ac:	74 04                	je     8009b2 <strncmp+0x26>
  8009ae:	3a 0a                	cmp    (%edx),%cl
  8009b0:	74 eb                	je     80099d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b2:	0f b6 00             	movzbl (%eax),%eax
  8009b5:	0f b6 12             	movzbl (%edx),%edx
  8009b8:	29 d0                	sub    %edx,%eax
}
  8009ba:	5b                   	pop    %ebx
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    
		return 0;
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c2:	eb f6                	jmp    8009ba <strncmp+0x2e>

008009c4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ce:	0f b6 10             	movzbl (%eax),%edx
  8009d1:	84 d2                	test   %dl,%dl
  8009d3:	74 09                	je     8009de <strchr+0x1a>
		if (*s == c)
  8009d5:	38 ca                	cmp    %cl,%dl
  8009d7:	74 0a                	je     8009e3 <strchr+0x1f>
	for (; *s; s++)
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	eb f0                	jmp    8009ce <strchr+0xa>
			return (char *) s;
	return 0;
  8009de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 09                	je     8009ff <strfind+0x1a>
  8009f6:	84 d2                	test   %dl,%dl
  8009f8:	74 05                	je     8009ff <strfind+0x1a>
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	eb f0                	jmp    8009ef <strfind+0xa>
			break;
	return (char *) s;
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	57                   	push   %edi
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0d:	85 c9                	test   %ecx,%ecx
  800a0f:	74 31                	je     800a42 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a11:	89 f8                	mov    %edi,%eax
  800a13:	09 c8                	or     %ecx,%eax
  800a15:	a8 03                	test   $0x3,%al
  800a17:	75 23                	jne    800a3c <memset+0x3b>
		c &= 0xFF;
  800a19:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1d:	89 d3                	mov    %edx,%ebx
  800a1f:	c1 e3 08             	shl    $0x8,%ebx
  800a22:	89 d0                	mov    %edx,%eax
  800a24:	c1 e0 18             	shl    $0x18,%eax
  800a27:	89 d6                	mov    %edx,%esi
  800a29:	c1 e6 10             	shl    $0x10,%esi
  800a2c:	09 f0                	or     %esi,%eax
  800a2e:	09 c2                	or     %eax,%edx
  800a30:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a32:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a35:	89 d0                	mov    %edx,%eax
  800a37:	fc                   	cld    
  800a38:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3a:	eb 06                	jmp    800a42 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	fc                   	cld    
  800a40:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a42:	89 f8                	mov    %edi,%eax
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5f                   	pop    %edi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	57                   	push   %edi
  800a4d:	56                   	push   %esi
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a54:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a57:	39 c6                	cmp    %eax,%esi
  800a59:	73 32                	jae    800a8d <memmove+0x44>
  800a5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5e:	39 c2                	cmp    %eax,%edx
  800a60:	76 2b                	jbe    800a8d <memmove+0x44>
		s += n;
		d += n;
  800a62:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a65:	89 fe                	mov    %edi,%esi
  800a67:	09 ce                	or     %ecx,%esi
  800a69:	09 d6                	or     %edx,%esi
  800a6b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a71:	75 0e                	jne    800a81 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a73:	83 ef 04             	sub    $0x4,%edi
  800a76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7c:	fd                   	std    
  800a7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7f:	eb 09                	jmp    800a8a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a81:	83 ef 01             	sub    $0x1,%edi
  800a84:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a87:	fd                   	std    
  800a88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8a:	fc                   	cld    
  800a8b:	eb 1a                	jmp    800aa7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8d:	89 c2                	mov    %eax,%edx
  800a8f:	09 ca                	or     %ecx,%edx
  800a91:	09 f2                	or     %esi,%edx
  800a93:	f6 c2 03             	test   $0x3,%dl
  800a96:	75 0a                	jne    800aa2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a98:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9b:	89 c7                	mov    %eax,%edi
  800a9d:	fc                   	cld    
  800a9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa0:	eb 05                	jmp    800aa7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa2:	89 c7                	mov    %eax,%edi
  800aa4:	fc                   	cld    
  800aa5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab1:	ff 75 10             	pushl  0x10(%ebp)
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	ff 75 08             	pushl  0x8(%ebp)
  800aba:	e8 8a ff ff ff       	call   800a49 <memmove>
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 c6                	mov    %eax,%esi
  800ace:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad1:	39 f0                	cmp    %esi,%eax
  800ad3:	74 1c                	je     800af1 <memcmp+0x30>
		if (*s1 != *s2)
  800ad5:	0f b6 08             	movzbl (%eax),%ecx
  800ad8:	0f b6 1a             	movzbl (%edx),%ebx
  800adb:	38 d9                	cmp    %bl,%cl
  800add:	75 08                	jne    800ae7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800adf:	83 c0 01             	add    $0x1,%eax
  800ae2:	83 c2 01             	add    $0x1,%edx
  800ae5:	eb ea                	jmp    800ad1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae7:	0f b6 c1             	movzbl %cl,%eax
  800aea:	0f b6 db             	movzbl %bl,%ebx
  800aed:	29 d8                	sub    %ebx,%eax
  800aef:	eb 05                	jmp    800af6 <memcmp+0x35>
	}

	return 0;
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af6:	5b                   	pop    %ebx
  800af7:	5e                   	pop    %esi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b08:	39 d0                	cmp    %edx,%eax
  800b0a:	73 09                	jae    800b15 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0c:	38 08                	cmp    %cl,(%eax)
  800b0e:	74 05                	je     800b15 <memfind+0x1b>
	for (; s < ends; s++)
  800b10:	83 c0 01             	add    $0x1,%eax
  800b13:	eb f3                	jmp    800b08 <memfind+0xe>
			break;
	return (void *) s;
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b23:	eb 03                	jmp    800b28 <strtol+0x11>
		s++;
  800b25:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b28:	0f b6 01             	movzbl (%ecx),%eax
  800b2b:	3c 20                	cmp    $0x20,%al
  800b2d:	74 f6                	je     800b25 <strtol+0xe>
  800b2f:	3c 09                	cmp    $0x9,%al
  800b31:	74 f2                	je     800b25 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b33:	3c 2b                	cmp    $0x2b,%al
  800b35:	74 2a                	je     800b61 <strtol+0x4a>
	int neg = 0;
  800b37:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b3c:	3c 2d                	cmp    $0x2d,%al
  800b3e:	74 2b                	je     800b6b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b40:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b46:	75 0f                	jne    800b57 <strtol+0x40>
  800b48:	80 39 30             	cmpb   $0x30,(%ecx)
  800b4b:	74 28                	je     800b75 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b54:	0f 44 d8             	cmove  %eax,%ebx
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5f:	eb 50                	jmp    800bb1 <strtol+0x9a>
		s++;
  800b61:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b64:	bf 00 00 00 00       	mov    $0x0,%edi
  800b69:	eb d5                	jmp    800b40 <strtol+0x29>
		s++, neg = 1;
  800b6b:	83 c1 01             	add    $0x1,%ecx
  800b6e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b73:	eb cb                	jmp    800b40 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b75:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b79:	74 0e                	je     800b89 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b7b:	85 db                	test   %ebx,%ebx
  800b7d:	75 d8                	jne    800b57 <strtol+0x40>
		s++, base = 8;
  800b7f:	83 c1 01             	add    $0x1,%ecx
  800b82:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b87:	eb ce                	jmp    800b57 <strtol+0x40>
		s += 2, base = 16;
  800b89:	83 c1 02             	add    $0x2,%ecx
  800b8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b91:	eb c4                	jmp    800b57 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b93:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b96:	89 f3                	mov    %esi,%ebx
  800b98:	80 fb 19             	cmp    $0x19,%bl
  800b9b:	77 29                	ja     800bc6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b9d:	0f be d2             	movsbl %dl,%edx
  800ba0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba6:	7d 30                	jge    800bd8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba8:	83 c1 01             	add    $0x1,%ecx
  800bab:	0f af 45 10          	imul   0x10(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb1:	0f b6 11             	movzbl (%ecx),%edx
  800bb4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb7:	89 f3                	mov    %esi,%ebx
  800bb9:	80 fb 09             	cmp    $0x9,%bl
  800bbc:	77 d5                	ja     800b93 <strtol+0x7c>
			dig = *s - '0';
  800bbe:	0f be d2             	movsbl %dl,%edx
  800bc1:	83 ea 30             	sub    $0x30,%edx
  800bc4:	eb dd                	jmp    800ba3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bc6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 08                	ja     800bd8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 37             	sub    $0x37,%edx
  800bd6:	eb cb                	jmp    800ba3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdc:	74 05                	je     800be3 <strtol+0xcc>
		*endptr = (char *) s;
  800bde:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be3:	89 c2                	mov    %eax,%edx
  800be5:	f7 da                	neg    %edx
  800be7:	85 ff                	test   %edi,%edi
  800be9:	0f 45 c2             	cmovne %edx,%eax
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c02:	89 c3                	mov    %eax,%ebx
  800c04:	89 c7                	mov    %eax,%edi
  800c06:	89 c6                	mov    %eax,%esi
  800c08:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5f                   	pop    %edi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1f:	89 d1                	mov    %edx,%ecx
  800c21:	89 d3                	mov    %edx,%ebx
  800c23:	89 d7                	mov    %edx,%edi
  800c25:	89 d6                	mov    %edx,%esi
  800c27:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c44:	89 cb                	mov    %ecx,%ebx
  800c46:	89 cf                	mov    %ecx,%edi
  800c48:	89 ce                	mov    %ecx,%esi
  800c4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	7f 08                	jg     800c58 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	50                   	push   %eax
  800c5c:	6a 03                	push   $0x3
  800c5e:	68 a8 28 80 00       	push   $0x8028a8
  800c63:	6a 43                	push   $0x43
  800c65:	68 c5 28 80 00       	push   $0x8028c5
  800c6a:	e8 89 14 00 00       	call   8020f8 <_panic>

00800c6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7f:	89 d1                	mov    %edx,%ecx
  800c81:	89 d3                	mov    %edx,%ebx
  800c83:	89 d7                	mov    %edx,%edi
  800c85:	89 d6                	mov    %edx,%esi
  800c87:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5f                   	pop    %edi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <sys_yield>:

void
sys_yield(void)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb6:	be 00 00 00 00       	mov    $0x0,%esi
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc9:	89 f7                	mov    %esi,%edi
  800ccb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	7f 08                	jg     800cd9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd9:	83 ec 0c             	sub    $0xc,%esp
  800cdc:	50                   	push   %eax
  800cdd:	6a 04                	push   $0x4
  800cdf:	68 a8 28 80 00       	push   $0x8028a8
  800ce4:	6a 43                	push   $0x43
  800ce6:	68 c5 28 80 00       	push   $0x8028c5
  800ceb:	e8 08 14 00 00       	call   8020f8 <_panic>

00800cf0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 05 00 00 00       	mov    $0x5,%eax
  800d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d07:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	7f 08                	jg     800d1b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	50                   	push   %eax
  800d1f:	6a 05                	push   $0x5
  800d21:	68 a8 28 80 00       	push   $0x8028a8
  800d26:	6a 43                	push   $0x43
  800d28:	68 c5 28 80 00       	push   $0x8028c5
  800d2d:	e8 c6 13 00 00       	call   8020f8 <_panic>

00800d32 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	89 de                	mov    %ebx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 06                	push   $0x6
  800d63:	68 a8 28 80 00       	push   $0x8028a8
  800d68:	6a 43                	push   $0x43
  800d6a:	68 c5 28 80 00       	push   $0x8028c5
  800d6f:	e8 84 13 00 00       	call   8020f8 <_panic>

00800d74 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d88:	b8 08 00 00 00       	mov    $0x8,%eax
  800d8d:	89 df                	mov    %ebx,%edi
  800d8f:	89 de                	mov    %ebx,%esi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 08                	push   $0x8
  800da5:	68 a8 28 80 00       	push   $0x8028a8
  800daa:	6a 43                	push   $0x43
  800dac:	68 c5 28 80 00       	push   $0x8028c5
  800db1:	e8 42 13 00 00       	call   8020f8 <_panic>

00800db6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 09                	push   $0x9
  800de7:	68 a8 28 80 00       	push   $0x8028a8
  800dec:	6a 43                	push   $0x43
  800dee:	68 c5 28 80 00       	push   $0x8028c5
  800df3:	e8 00 13 00 00       	call   8020f8 <_panic>

00800df8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e11:	89 df                	mov    %ebx,%edi
  800e13:	89 de                	mov    %ebx,%esi
  800e15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7f 08                	jg     800e23 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	6a 0a                	push   $0xa
  800e29:	68 a8 28 80 00       	push   $0x8028a8
  800e2e:	6a 43                	push   $0x43
  800e30:	68 c5 28 80 00       	push   $0x8028c5
  800e35:	e8 be 12 00 00       	call   8020f8 <_panic>

00800e3a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4b:	be 00 00 00 00       	mov    $0x0,%esi
  800e50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e53:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e56:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e73:	89 cb                	mov    %ecx,%ebx
  800e75:	89 cf                	mov    %ecx,%edi
  800e77:	89 ce                	mov    %ecx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 0d                	push   $0xd
  800e8d:	68 a8 28 80 00       	push   $0x8028a8
  800e92:	6a 43                	push   $0x43
  800e94:	68 c5 28 80 00       	push   $0x8028c5
  800e99:	e8 5a 12 00 00       	call   8020f8 <_panic>

00800e9e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb4:	89 df                	mov    %ebx,%edi
  800eb6:	89 de                	mov    %ebx,%esi
  800eb8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed2:	89 cb                	mov    %ecx,%ebx
  800ed4:	89 cf                	mov    %ecx,%edi
  800ed6:	89 ce                	mov    %ecx,%esi
  800ed8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eea:	b8 10 00 00 00       	mov    $0x10,%eax
  800eef:	89 d1                	mov    %edx,%ecx
  800ef1:	89 d3                	mov    %edx,%ebx
  800ef3:	89 d7                	mov    %edx,%edi
  800ef5:	89 d6                	mov    %edx,%esi
  800ef7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0f:	b8 11 00 00 00       	mov    $0x11,%eax
  800f14:	89 df                	mov    %ebx,%edi
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 12 00 00 00       	mov    $0x12,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f54:	b8 13 00 00 00       	mov    $0x13,%eax
  800f59:	89 df                	mov    %ebx,%edi
  800f5b:	89 de                	mov    %ebx,%esi
  800f5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7f 08                	jg     800f6b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	50                   	push   %eax
  800f6f:	6a 13                	push   $0x13
  800f71:	68 a8 28 80 00       	push   $0x8028a8
  800f76:	6a 43                	push   $0x43
  800f78:	68 c5 28 80 00       	push   $0x8028c5
  800f7d:	e8 76 11 00 00       	call   8020f8 <_panic>

00800f82 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	b8 14 00 00 00       	mov    $0x14,%eax
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	05 00 00 00 30       	add    $0x30000000,%eax
  800fad:	c1 e8 0c             	shr    $0xc,%eax
}
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fd1:	89 c2                	mov    %eax,%edx
  800fd3:	c1 ea 16             	shr    $0x16,%edx
  800fd6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fdd:	f6 c2 01             	test   $0x1,%dl
  800fe0:	74 2d                	je     80100f <fd_alloc+0x46>
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	c1 ea 0c             	shr    $0xc,%edx
  800fe7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fee:	f6 c2 01             	test   $0x1,%dl
  800ff1:	74 1c                	je     80100f <fd_alloc+0x46>
  800ff3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ff8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ffd:	75 d2                	jne    800fd1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801008:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80100d:	eb 0a                	jmp    801019 <fd_alloc+0x50>
			*fd_store = fd;
  80100f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801012:	89 01                	mov    %eax,(%ecx)
			return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801021:	83 f8 1f             	cmp    $0x1f,%eax
  801024:	77 30                	ja     801056 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801026:	c1 e0 0c             	shl    $0xc,%eax
  801029:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80102e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801034:	f6 c2 01             	test   $0x1,%dl
  801037:	74 24                	je     80105d <fd_lookup+0x42>
  801039:	89 c2                	mov    %eax,%edx
  80103b:	c1 ea 0c             	shr    $0xc,%edx
  80103e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801045:	f6 c2 01             	test   $0x1,%dl
  801048:	74 1a                	je     801064 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	89 02                	mov    %eax,(%edx)
	return 0;
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
		return -E_INVAL;
  801056:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105b:	eb f7                	jmp    801054 <fd_lookup+0x39>
		return -E_INVAL;
  80105d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801062:	eb f0                	jmp    801054 <fd_lookup+0x39>
  801064:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801069:	eb e9                	jmp    801054 <fd_lookup+0x39>

0080106b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 08             	sub    $0x8,%esp
  801071:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801074:	ba 00 00 00 00       	mov    $0x0,%edx
  801079:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80107e:	39 08                	cmp    %ecx,(%eax)
  801080:	74 38                	je     8010ba <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801082:	83 c2 01             	add    $0x1,%edx
  801085:	8b 04 95 50 29 80 00 	mov    0x802950(,%edx,4),%eax
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 ee                	jne    80107e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801090:	a1 08 40 80 00       	mov    0x804008,%eax
  801095:	8b 40 48             	mov    0x48(%eax),%eax
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	51                   	push   %ecx
  80109c:	50                   	push   %eax
  80109d:	68 d4 28 80 00       	push   $0x8028d4
  8010a2:	e8 b5 f0 ff ff       	call   80015c <cprintf>
	*dev = 0;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010b0:	83 c4 10             	add    $0x10,%esp
  8010b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    
			*dev = devtab[i];
  8010ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c4:	eb f2                	jmp    8010b8 <dev_lookup+0x4d>

008010c6 <fd_close>:
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
  8010cc:	83 ec 24             	sub    $0x24,%esp
  8010cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8010d2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010d8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010df:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e2:	50                   	push   %eax
  8010e3:	e8 33 ff ff ff       	call   80101b <fd_lookup>
  8010e8:	89 c3                	mov    %eax,%ebx
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 05                	js     8010f6 <fd_close+0x30>
	    || fd != fd2)
  8010f1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010f4:	74 16                	je     80110c <fd_close+0x46>
		return (must_exist ? r : 0);
  8010f6:	89 f8                	mov    %edi,%eax
  8010f8:	84 c0                	test   %al,%al
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ff:	0f 44 d8             	cmove  %eax,%ebx
}
  801102:	89 d8                	mov    %ebx,%eax
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801112:	50                   	push   %eax
  801113:	ff 36                	pushl  (%esi)
  801115:	e8 51 ff ff ff       	call   80106b <dev_lookup>
  80111a:	89 c3                	mov    %eax,%ebx
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	78 1a                	js     80113d <fd_close+0x77>
		if (dev->dev_close)
  801123:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801126:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80112e:	85 c0                	test   %eax,%eax
  801130:	74 0b                	je     80113d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	56                   	push   %esi
  801136:	ff d0                	call   *%eax
  801138:	89 c3                	mov    %eax,%ebx
  80113a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	56                   	push   %esi
  801141:	6a 00                	push   $0x0
  801143:	e8 ea fb ff ff       	call   800d32 <sys_page_unmap>
	return r;
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	eb b5                	jmp    801102 <fd_close+0x3c>

0080114d <close>:

int
close(int fdnum)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	ff 75 08             	pushl  0x8(%ebp)
  80115a:	e8 bc fe ff ff       	call   80101b <fd_lookup>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	79 02                	jns    801168 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    
		return fd_close(fd, 1);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	6a 01                	push   $0x1
  80116d:	ff 75 f4             	pushl  -0xc(%ebp)
  801170:	e8 51 ff ff ff       	call   8010c6 <fd_close>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	eb ec                	jmp    801166 <close+0x19>

0080117a <close_all>:

void
close_all(void)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	53                   	push   %ebx
  80117e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801181:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801186:	83 ec 0c             	sub    $0xc,%esp
  801189:	53                   	push   %ebx
  80118a:	e8 be ff ff ff       	call   80114d <close>
	for (i = 0; i < MAXFD; i++)
  80118f:	83 c3 01             	add    $0x1,%ebx
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	83 fb 20             	cmp    $0x20,%ebx
  801198:	75 ec                	jne    801186 <close_all+0xc>
}
  80119a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	57                   	push   %edi
  8011a3:	56                   	push   %esi
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ab:	50                   	push   %eax
  8011ac:	ff 75 08             	pushl  0x8(%ebp)
  8011af:	e8 67 fe ff ff       	call   80101b <fd_lookup>
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	0f 88 81 00 00 00    	js     801242 <dup+0xa3>
		return r;
	close(newfdnum);
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	ff 75 0c             	pushl  0xc(%ebp)
  8011c7:	e8 81 ff ff ff       	call   80114d <close>

	newfd = INDEX2FD(newfdnum);
  8011cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011cf:	c1 e6 0c             	shl    $0xc,%esi
  8011d2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011d8:	83 c4 04             	add    $0x4,%esp
  8011db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011de:	e8 cf fd ff ff       	call   800fb2 <fd2data>
  8011e3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011e5:	89 34 24             	mov    %esi,(%esp)
  8011e8:	e8 c5 fd ff ff       	call   800fb2 <fd2data>
  8011ed:	83 c4 10             	add    $0x10,%esp
  8011f0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f2:	89 d8                	mov    %ebx,%eax
  8011f4:	c1 e8 16             	shr    $0x16,%eax
  8011f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011fe:	a8 01                	test   $0x1,%al
  801200:	74 11                	je     801213 <dup+0x74>
  801202:	89 d8                	mov    %ebx,%eax
  801204:	c1 e8 0c             	shr    $0xc,%eax
  801207:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	75 39                	jne    80124c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801213:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801216:	89 d0                	mov    %edx,%eax
  801218:	c1 e8 0c             	shr    $0xc,%eax
  80121b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801222:	83 ec 0c             	sub    $0xc,%esp
  801225:	25 07 0e 00 00       	and    $0xe07,%eax
  80122a:	50                   	push   %eax
  80122b:	56                   	push   %esi
  80122c:	6a 00                	push   $0x0
  80122e:	52                   	push   %edx
  80122f:	6a 00                	push   $0x0
  801231:	e8 ba fa ff ff       	call   800cf0 <sys_page_map>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	83 c4 20             	add    $0x20,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	78 31                	js     801270 <dup+0xd1>
		goto err;

	return newfdnum;
  80123f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801242:	89 d8                	mov    %ebx,%eax
  801244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80124c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	25 07 0e 00 00       	and    $0xe07,%eax
  80125b:	50                   	push   %eax
  80125c:	57                   	push   %edi
  80125d:	6a 00                	push   $0x0
  80125f:	53                   	push   %ebx
  801260:	6a 00                	push   $0x0
  801262:	e8 89 fa ff ff       	call   800cf0 <sys_page_map>
  801267:	89 c3                	mov    %eax,%ebx
  801269:	83 c4 20             	add    $0x20,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	79 a3                	jns    801213 <dup+0x74>
	sys_page_unmap(0, newfd);
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	56                   	push   %esi
  801274:	6a 00                	push   $0x0
  801276:	e8 b7 fa ff ff       	call   800d32 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	57                   	push   %edi
  80127f:	6a 00                	push   $0x0
  801281:	e8 ac fa ff ff       	call   800d32 <sys_page_unmap>
	return r;
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	eb b7                	jmp    801242 <dup+0xa3>

0080128b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	83 ec 1c             	sub    $0x1c,%esp
  801292:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801295:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801298:	50                   	push   %eax
  801299:	53                   	push   %ebx
  80129a:	e8 7c fd ff ff       	call   80101b <fd_lookup>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 3f                	js     8012e5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b0:	ff 30                	pushl  (%eax)
  8012b2:	e8 b4 fd ff ff       	call   80106b <dev_lookup>
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 27                	js     8012e5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c1:	8b 42 08             	mov    0x8(%edx),%eax
  8012c4:	83 e0 03             	and    $0x3,%eax
  8012c7:	83 f8 01             	cmp    $0x1,%eax
  8012ca:	74 1e                	je     8012ea <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cf:	8b 40 08             	mov    0x8(%eax),%eax
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	74 35                	je     80130b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	ff 75 10             	pushl  0x10(%ebp)
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	52                   	push   %edx
  8012e0:	ff d0                	call   *%eax
  8012e2:	83 c4 10             	add    $0x10,%esp
}
  8012e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ef:	8b 40 48             	mov    0x48(%eax),%eax
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	53                   	push   %ebx
  8012f6:	50                   	push   %eax
  8012f7:	68 15 29 80 00       	push   $0x802915
  8012fc:	e8 5b ee ff ff       	call   80015c <cprintf>
		return -E_INVAL;
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801309:	eb da                	jmp    8012e5 <read+0x5a>
		return -E_NOT_SUPP;
  80130b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801310:	eb d3                	jmp    8012e5 <read+0x5a>

00801312 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 0c             	sub    $0xc,%esp
  80131b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80131e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
  801326:	39 f3                	cmp    %esi,%ebx
  801328:	73 23                	jae    80134d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	89 f0                	mov    %esi,%eax
  80132f:	29 d8                	sub    %ebx,%eax
  801331:	50                   	push   %eax
  801332:	89 d8                	mov    %ebx,%eax
  801334:	03 45 0c             	add    0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	57                   	push   %edi
  801339:	e8 4d ff ff ff       	call   80128b <read>
		if (m < 0)
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	78 06                	js     80134b <readn+0x39>
			return m;
		if (m == 0)
  801345:	74 06                	je     80134d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801347:	01 c3                	add    %eax,%ebx
  801349:	eb db                	jmp    801326 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80134b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 1c             	sub    $0x1c,%esp
  80135e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801361:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	53                   	push   %ebx
  801366:	e8 b0 fc ff ff       	call   80101b <fd_lookup>
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 3a                	js     8013ac <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137c:	ff 30                	pushl  (%eax)
  80137e:	e8 e8 fc ff ff       	call   80106b <dev_lookup>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 22                	js     8013ac <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801391:	74 1e                	je     8013b1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801396:	8b 52 0c             	mov    0xc(%edx),%edx
  801399:	85 d2                	test   %edx,%edx
  80139b:	74 35                	je     8013d2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	ff d2                	call   *%edx
  8013a9:	83 c4 10             	add    $0x10,%esp
}
  8013ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b6:	8b 40 48             	mov    0x48(%eax),%eax
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	53                   	push   %ebx
  8013bd:	50                   	push   %eax
  8013be:	68 31 29 80 00       	push   $0x802931
  8013c3:	e8 94 ed ff ff       	call   80015c <cprintf>
		return -E_INVAL;
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d0:	eb da                	jmp    8013ac <write+0x55>
		return -E_NOT_SUPP;
  8013d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d7:	eb d3                	jmp    8013ac <write+0x55>

008013d9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	e8 30 fc ff ff       	call   80101b <fd_lookup>
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	78 0e                	js     801400 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	53                   	push   %ebx
  801406:	83 ec 1c             	sub    $0x1c,%esp
  801409:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140f:	50                   	push   %eax
  801410:	53                   	push   %ebx
  801411:	e8 05 fc ff ff       	call   80101b <fd_lookup>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 37                	js     801454 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	ff 30                	pushl  (%eax)
  801429:	e8 3d fc ff ff       	call   80106b <dev_lookup>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 1f                	js     801454 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801438:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80143c:	74 1b                	je     801459 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80143e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801441:	8b 52 18             	mov    0x18(%edx),%edx
  801444:	85 d2                	test   %edx,%edx
  801446:	74 32                	je     80147a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	50                   	push   %eax
  80144f:	ff d2                	call   *%edx
  801451:	83 c4 10             	add    $0x10,%esp
}
  801454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801457:	c9                   	leave  
  801458:	c3                   	ret    
			thisenv->env_id, fdnum);
  801459:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80145e:	8b 40 48             	mov    0x48(%eax),%eax
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	53                   	push   %ebx
  801465:	50                   	push   %eax
  801466:	68 f4 28 80 00       	push   $0x8028f4
  80146b:	e8 ec ec ff ff       	call   80015c <cprintf>
		return -E_INVAL;
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801478:	eb da                	jmp    801454 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80147a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147f:	eb d3                	jmp    801454 <ftruncate+0x52>

00801481 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	53                   	push   %ebx
  801485:	83 ec 1c             	sub    $0x1c,%esp
  801488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148e:	50                   	push   %eax
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	e8 84 fb ff ff       	call   80101b <fd_lookup>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 4b                	js     8014e9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a8:	ff 30                	pushl  (%eax)
  8014aa:	e8 bc fb ff ff       	call   80106b <dev_lookup>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 33                	js     8014e9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014bd:	74 2f                	je     8014ee <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014bf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014c2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014c9:	00 00 00 
	stat->st_isdir = 0;
  8014cc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d3:	00 00 00 
	stat->st_dev = dev;
  8014d6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	53                   	push   %ebx
  8014e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014e3:	ff 50 14             	call   *0x14(%eax)
  8014e6:	83 c4 10             	add    $0x10,%esp
}
  8014e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    
		return -E_NOT_SUPP;
  8014ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f3:	eb f4                	jmp    8014e9 <fstat+0x68>

008014f5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	56                   	push   %esi
  8014f9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	6a 00                	push   $0x0
  8014ff:	ff 75 08             	pushl  0x8(%ebp)
  801502:	e8 22 02 00 00       	call   801729 <open>
  801507:	89 c3                	mov    %eax,%ebx
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 1b                	js     80152b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	ff 75 0c             	pushl  0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	e8 65 ff ff ff       	call   801481 <fstat>
  80151c:	89 c6                	mov    %eax,%esi
	close(fd);
  80151e:	89 1c 24             	mov    %ebx,(%esp)
  801521:	e8 27 fc ff ff       	call   80114d <close>
	return r;
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	89 f3                	mov    %esi,%ebx
}
  80152b:	89 d8                	mov    %ebx,%eax
  80152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	89 c6                	mov    %eax,%esi
  80153b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80153d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801544:	74 27                	je     80156d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801546:	6a 07                	push   $0x7
  801548:	68 00 50 80 00       	push   $0x805000
  80154d:	56                   	push   %esi
  80154e:	ff 35 00 40 80 00    	pushl  0x804000
  801554:	e8 69 0c 00 00       	call   8021c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801559:	83 c4 0c             	add    $0xc,%esp
  80155c:	6a 00                	push   $0x0
  80155e:	53                   	push   %ebx
  80155f:	6a 00                	push   $0x0
  801561:	e8 f3 0b 00 00       	call   802159 <ipc_recv>
}
  801566:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80156d:	83 ec 0c             	sub    $0xc,%esp
  801570:	6a 01                	push   $0x1
  801572:	e8 a3 0c 00 00       	call   80221a <ipc_find_env>
  801577:	a3 00 40 80 00       	mov    %eax,0x804000
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	eb c5                	jmp    801546 <fsipc+0x12>

00801581 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8b 40 0c             	mov    0xc(%eax),%eax
  80158d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801592:	8b 45 0c             	mov    0xc(%ebp),%eax
  801595:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80159a:	ba 00 00 00 00       	mov    $0x0,%edx
  80159f:	b8 02 00 00 00       	mov    $0x2,%eax
  8015a4:	e8 8b ff ff ff       	call   801534 <fsipc>
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <devfile_flush>:
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8015c6:	e8 69 ff ff ff       	call   801534 <fsipc>
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <devfile_stat>:
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ec:	e8 43 ff ff ff       	call   801534 <fsipc>
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 2c                	js     801621 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	68 00 50 80 00       	push   $0x805000
  8015fd:	53                   	push   %ebx
  8015fe:	e8 b8 f2 ff ff       	call   8008bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801603:	a1 80 50 80 00       	mov    0x805080,%eax
  801608:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80160e:	a1 84 50 80 00       	mov    0x805084,%eax
  801613:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801621:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <devfile_write>:
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	53                   	push   %ebx
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 40 0c             	mov    0xc(%eax),%eax
  801636:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80163b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801641:	53                   	push   %ebx
  801642:	ff 75 0c             	pushl  0xc(%ebp)
  801645:	68 08 50 80 00       	push   $0x805008
  80164a:	e8 5c f4 ff ff       	call   800aab <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80164f:	ba 00 00 00 00       	mov    $0x0,%edx
  801654:	b8 04 00 00 00       	mov    $0x4,%eax
  801659:	e8 d6 fe ff ff       	call   801534 <fsipc>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 0b                	js     801670 <devfile_write+0x4a>
	assert(r <= n);
  801665:	39 d8                	cmp    %ebx,%eax
  801667:	77 0c                	ja     801675 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801669:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80166e:	7f 1e                	jg     80168e <devfile_write+0x68>
}
  801670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801673:	c9                   	leave  
  801674:	c3                   	ret    
	assert(r <= n);
  801675:	68 64 29 80 00       	push   $0x802964
  80167a:	68 6b 29 80 00       	push   $0x80296b
  80167f:	68 98 00 00 00       	push   $0x98
  801684:	68 80 29 80 00       	push   $0x802980
  801689:	e8 6a 0a 00 00       	call   8020f8 <_panic>
	assert(r <= PGSIZE);
  80168e:	68 8b 29 80 00       	push   $0x80298b
  801693:	68 6b 29 80 00       	push   $0x80296b
  801698:	68 99 00 00 00       	push   $0x99
  80169d:	68 80 29 80 00       	push   $0x802980
  8016a2:	e8 51 0a 00 00       	call   8020f8 <_panic>

008016a7 <devfile_read>:
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ba:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ca:	e8 65 fe ff ff       	call   801534 <fsipc>
  8016cf:	89 c3                	mov    %eax,%ebx
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 1f                	js     8016f4 <devfile_read+0x4d>
	assert(r <= n);
  8016d5:	39 f0                	cmp    %esi,%eax
  8016d7:	77 24                	ja     8016fd <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016de:	7f 33                	jg     801713 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	50                   	push   %eax
  8016e4:	68 00 50 80 00       	push   $0x805000
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	e8 58 f3 ff ff       	call   800a49 <memmove>
	return r;
  8016f1:	83 c4 10             	add    $0x10,%esp
}
  8016f4:	89 d8                	mov    %ebx,%eax
  8016f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5e                   	pop    %esi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    
	assert(r <= n);
  8016fd:	68 64 29 80 00       	push   $0x802964
  801702:	68 6b 29 80 00       	push   $0x80296b
  801707:	6a 7c                	push   $0x7c
  801709:	68 80 29 80 00       	push   $0x802980
  80170e:	e8 e5 09 00 00       	call   8020f8 <_panic>
	assert(r <= PGSIZE);
  801713:	68 8b 29 80 00       	push   $0x80298b
  801718:	68 6b 29 80 00       	push   $0x80296b
  80171d:	6a 7d                	push   $0x7d
  80171f:	68 80 29 80 00       	push   $0x802980
  801724:	e8 cf 09 00 00       	call   8020f8 <_panic>

00801729 <open>:
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	83 ec 1c             	sub    $0x1c,%esp
  801731:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801734:	56                   	push   %esi
  801735:	e8 48 f1 ff ff       	call   800882 <strlen>
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801742:	7f 6c                	jg     8017b0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174a:	50                   	push   %eax
  80174b:	e8 79 f8 ff ff       	call   800fc9 <fd_alloc>
  801750:	89 c3                	mov    %eax,%ebx
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	78 3c                	js     801795 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	56                   	push   %esi
  80175d:	68 00 50 80 00       	push   $0x805000
  801762:	e8 54 f1 ff ff       	call   8008bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80176f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801772:	b8 01 00 00 00       	mov    $0x1,%eax
  801777:	e8 b8 fd ff ff       	call   801534 <fsipc>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	78 19                	js     80179e <open+0x75>
	return fd2num(fd);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	ff 75 f4             	pushl  -0xc(%ebp)
  80178b:	e8 12 f8 ff ff       	call   800fa2 <fd2num>
  801790:	89 c3                	mov    %eax,%ebx
  801792:	83 c4 10             	add    $0x10,%esp
}
  801795:	89 d8                	mov    %ebx,%eax
  801797:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    
		fd_close(fd, 0);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a6:	e8 1b f9 ff ff       	call   8010c6 <fd_close>
		return r;
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	eb e5                	jmp    801795 <open+0x6c>
		return -E_BAD_PATH;
  8017b0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017b5:	eb de                	jmp    801795 <open+0x6c>

008017b7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c7:	e8 68 fd ff ff       	call   801534 <fsipc>
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017d4:	68 97 29 80 00       	push   $0x802997
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	e8 da f0 ff ff       	call   8008bb <strcpy>
	return 0;
}
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <devsock_close>:
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	53                   	push   %ebx
  8017ec:	83 ec 10             	sub    $0x10,%esp
  8017ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017f2:	53                   	push   %ebx
  8017f3:	e8 61 0a 00 00       	call   802259 <pageref>
  8017f8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801800:	83 f8 01             	cmp    $0x1,%eax
  801803:	74 07                	je     80180c <devsock_close+0x24>
}
  801805:	89 d0                	mov    %edx,%eax
  801807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	ff 73 0c             	pushl  0xc(%ebx)
  801812:	e8 b9 02 00 00       	call   801ad0 <nsipc_close>
  801817:	89 c2                	mov    %eax,%edx
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	eb e7                	jmp    801805 <devsock_close+0x1d>

0080181e <devsock_write>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801824:	6a 00                	push   $0x0
  801826:	ff 75 10             	pushl  0x10(%ebp)
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	ff 70 0c             	pushl  0xc(%eax)
  801832:	e8 76 03 00 00       	call   801bad <nsipc_send>
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <devsock_read>:
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 10             	pushl  0x10(%ebp)
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	ff 70 0c             	pushl  0xc(%eax)
  80184d:	e8 ef 02 00 00       	call   801b41 <nsipc_recv>
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <fd2sockid>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80185a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	e8 b7 f7 ff ff       	call   80101b <fd_lookup>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 10                	js     80187b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801874:	39 08                	cmp    %ecx,(%eax)
  801876:	75 05                	jne    80187d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801878:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    
		return -E_NOT_SUPP;
  80187d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801882:	eb f7                	jmp    80187b <fd2sockid+0x27>

00801884 <alloc_sockfd>:
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	56                   	push   %esi
  801888:	53                   	push   %ebx
  801889:	83 ec 1c             	sub    $0x1c,%esp
  80188c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80188e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	e8 32 f7 ff ff       	call   800fc9 <fd_alloc>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 43                	js     8018e3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 07 04 00 00       	push   $0x407
  8018a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ab:	6a 00                	push   $0x0
  8018ad:	e8 fb f3 ff ff       	call   800cad <sys_page_alloc>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 28                	js     8018e3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018be:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018c4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018d0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	50                   	push   %eax
  8018d7:	e8 c6 f6 ff ff       	call   800fa2 <fd2num>
  8018dc:	89 c3                	mov    %eax,%ebx
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	eb 0c                	jmp    8018ef <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	56                   	push   %esi
  8018e7:	e8 e4 01 00 00       	call   801ad0 <nsipc_close>
		return r;
  8018ec:	83 c4 10             	add    $0x10,%esp
}
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    

008018f8 <accept>:
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	e8 4e ff ff ff       	call   801854 <fd2sockid>
  801906:	85 c0                	test   %eax,%eax
  801908:	78 1b                	js     801925 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	ff 75 10             	pushl  0x10(%ebp)
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	50                   	push   %eax
  801914:	e8 0e 01 00 00       	call   801a27 <nsipc_accept>
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 05                	js     801925 <accept+0x2d>
	return alloc_sockfd(r);
  801920:	e8 5f ff ff ff       	call   801884 <alloc_sockfd>
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <bind>:
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	e8 1f ff ff ff       	call   801854 <fd2sockid>
  801935:	85 c0                	test   %eax,%eax
  801937:	78 12                	js     80194b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	ff 75 10             	pushl  0x10(%ebp)
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	50                   	push   %eax
  801943:	e8 31 01 00 00       	call   801a79 <nsipc_bind>
  801948:	83 c4 10             	add    $0x10,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <shutdown>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	e8 f9 fe ff ff       	call   801854 <fd2sockid>
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 0f                	js     80196e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	e8 43 01 00 00       	call   801aae <nsipc_shutdown>
  80196b:	83 c4 10             	add    $0x10,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <connect>:
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	e8 d6 fe ff ff       	call   801854 <fd2sockid>
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 12                	js     801994 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	ff 75 10             	pushl  0x10(%ebp)
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	50                   	push   %eax
  80198c:	e8 59 01 00 00       	call   801aea <nsipc_connect>
  801991:	83 c4 10             	add    $0x10,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <listen>:
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	e8 b0 fe ff ff       	call   801854 <fd2sockid>
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 0f                	js     8019b7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	50                   	push   %eax
  8019af:	e8 6b 01 00 00       	call   801b1f <nsipc_listen>
  8019b4:	83 c4 10             	add    $0x10,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019bf:	ff 75 10             	pushl  0x10(%ebp)
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 3e 02 00 00       	call   801c0b <nsipc_socket>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 05                	js     8019d9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019d4:	e8 ab fe ff ff       	call   801884 <alloc_sockfd>
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019e4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019eb:	74 26                	je     801a13 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019ed:	6a 07                	push   $0x7
  8019ef:	68 00 60 80 00       	push   $0x806000
  8019f4:	53                   	push   %ebx
  8019f5:	ff 35 04 40 80 00    	pushl  0x804004
  8019fb:	e8 c2 07 00 00       	call   8021c2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a00:	83 c4 0c             	add    $0xc,%esp
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	e8 4b 07 00 00       	call   802159 <ipc_recv>
}
  801a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a13:	83 ec 0c             	sub    $0xc,%esp
  801a16:	6a 02                	push   $0x2
  801a18:	e8 fd 07 00 00       	call   80221a <ipc_find_env>
  801a1d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	eb c6                	jmp    8019ed <nsipc+0x12>

00801a27 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a37:	8b 06                	mov    (%esi),%eax
  801a39:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a43:	e8 93 ff ff ff       	call   8019db <nsipc>
  801a48:	89 c3                	mov    %eax,%ebx
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	79 09                	jns    801a57 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	ff 35 10 60 80 00    	pushl  0x806010
  801a60:	68 00 60 80 00       	push   $0x806000
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	e8 dc ef ff ff       	call   800a49 <memmove>
		*addrlen = ret->ret_addrlen;
  801a6d:	a1 10 60 80 00       	mov    0x806010,%eax
  801a72:	89 06                	mov    %eax,(%esi)
  801a74:	83 c4 10             	add    $0x10,%esp
	return r;
  801a77:	eb d5                	jmp    801a4e <nsipc_accept+0x27>

00801a79 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	53                   	push   %ebx
  801a7d:	83 ec 08             	sub    $0x8,%esp
  801a80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a8b:	53                   	push   %ebx
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	68 04 60 80 00       	push   $0x806004
  801a94:	e8 b0 ef ff ff       	call   800a49 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a99:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a9f:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa4:	e8 32 ff ff ff       	call   8019db <nsipc>
}
  801aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ac4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac9:	e8 0d ff ff ff       	call   8019db <nsipc>
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ade:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae3:	e8 f3 fe ff ff       	call   8019db <nsipc>
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801afc:	53                   	push   %ebx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	68 04 60 80 00       	push   $0x806004
  801b05:	e8 3f ef ff ff       	call   800a49 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b0a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b10:	b8 05 00 00 00       	mov    $0x5,%eax
  801b15:	e8 c1 fe ff ff       	call   8019db <nsipc>
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b30:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b35:	b8 06 00 00 00       	mov    $0x6,%eax
  801b3a:	e8 9c fe ff ff       	call   8019db <nsipc>
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b51:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b5f:	b8 07 00 00 00       	mov    $0x7,%eax
  801b64:	e8 72 fe ff ff       	call   8019db <nsipc>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 1f                	js     801b8e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b6f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b74:	7f 21                	jg     801b97 <nsipc_recv+0x56>
  801b76:	39 c6                	cmp    %eax,%esi
  801b78:	7c 1d                	jl     801b97 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	50                   	push   %eax
  801b7e:	68 00 60 80 00       	push   $0x806000
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	e8 be ee ff ff       	call   800a49 <memmove>
  801b8b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b8e:	89 d8                	mov    %ebx,%eax
  801b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b97:	68 a3 29 80 00       	push   $0x8029a3
  801b9c:	68 6b 29 80 00       	push   $0x80296b
  801ba1:	6a 62                	push   $0x62
  801ba3:	68 b8 29 80 00       	push   $0x8029b8
  801ba8:	e8 4b 05 00 00       	call   8020f8 <_panic>

00801bad <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bbf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc5:	7f 2e                	jg     801bf5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	53                   	push   %ebx
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	68 0c 60 80 00       	push   $0x80600c
  801bd3:	e8 71 ee ff ff       	call   800a49 <memmove>
	nsipcbuf.send.req_size = size;
  801bd8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bde:	8b 45 14             	mov    0x14(%ebp),%eax
  801be1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801be6:	b8 08 00 00 00       	mov    $0x8,%eax
  801beb:	e8 eb fd ff ff       	call   8019db <nsipc>
}
  801bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
	assert(size < 1600);
  801bf5:	68 c4 29 80 00       	push   $0x8029c4
  801bfa:	68 6b 29 80 00       	push   $0x80296b
  801bff:	6a 6d                	push   $0x6d
  801c01:	68 b8 29 80 00       	push   $0x8029b8
  801c06:	e8 ed 04 00 00       	call   8020f8 <_panic>

00801c0b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c29:	b8 09 00 00 00       	mov    $0x9,%eax
  801c2e:	e8 a8 fd ff ff       	call   8019db <nsipc>
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	e8 6a f3 ff ff       	call   800fb2 <fd2data>
  801c48:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c4a:	83 c4 08             	add    $0x8,%esp
  801c4d:	68 d0 29 80 00       	push   $0x8029d0
  801c52:	53                   	push   %ebx
  801c53:	e8 63 ec ff ff       	call   8008bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c58:	8b 46 04             	mov    0x4(%esi),%eax
  801c5b:	2b 06                	sub    (%esi),%eax
  801c5d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c63:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c6a:	00 00 00 
	stat->st_dev = &devpipe;
  801c6d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c74:	30 80 00 
	return 0;
}
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	53                   	push   %ebx
  801c87:	83 ec 0c             	sub    $0xc,%esp
  801c8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c8d:	53                   	push   %ebx
  801c8e:	6a 00                	push   $0x0
  801c90:	e8 9d f0 ff ff       	call   800d32 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c95:	89 1c 24             	mov    %ebx,(%esp)
  801c98:	e8 15 f3 ff ff       	call   800fb2 <fd2data>
  801c9d:	83 c4 08             	add    $0x8,%esp
  801ca0:	50                   	push   %eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	e8 8a f0 ff ff       	call   800d32 <sys_page_unmap>
}
  801ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <_pipeisclosed>:
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	57                   	push   %edi
  801cb1:	56                   	push   %esi
  801cb2:	53                   	push   %ebx
  801cb3:	83 ec 1c             	sub    $0x1c,%esp
  801cb6:	89 c7                	mov    %eax,%edi
  801cb8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cba:	a1 08 40 80 00       	mov    0x804008,%eax
  801cbf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cc2:	83 ec 0c             	sub    $0xc,%esp
  801cc5:	57                   	push   %edi
  801cc6:	e8 8e 05 00 00       	call   802259 <pageref>
  801ccb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cce:	89 34 24             	mov    %esi,(%esp)
  801cd1:	e8 83 05 00 00       	call   802259 <pageref>
		nn = thisenv->env_runs;
  801cd6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cdc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	39 cb                	cmp    %ecx,%ebx
  801ce4:	74 1b                	je     801d01 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ce6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ce9:	75 cf                	jne    801cba <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ceb:	8b 42 58             	mov    0x58(%edx),%eax
  801cee:	6a 01                	push   $0x1
  801cf0:	50                   	push   %eax
  801cf1:	53                   	push   %ebx
  801cf2:	68 d7 29 80 00       	push   $0x8029d7
  801cf7:	e8 60 e4 ff ff       	call   80015c <cprintf>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	eb b9                	jmp    801cba <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d01:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d04:	0f 94 c0             	sete   %al
  801d07:	0f b6 c0             	movzbl %al,%eax
}
  801d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <devpipe_write>:
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 28             	sub    $0x28,%esp
  801d1b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d1e:	56                   	push   %esi
  801d1f:	e8 8e f2 ff ff       	call   800fb2 <fd2data>
  801d24:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d31:	74 4f                	je     801d82 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d33:	8b 43 04             	mov    0x4(%ebx),%eax
  801d36:	8b 0b                	mov    (%ebx),%ecx
  801d38:	8d 51 20             	lea    0x20(%ecx),%edx
  801d3b:	39 d0                	cmp    %edx,%eax
  801d3d:	72 14                	jb     801d53 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d3f:	89 da                	mov    %ebx,%edx
  801d41:	89 f0                	mov    %esi,%eax
  801d43:	e8 65 ff ff ff       	call   801cad <_pipeisclosed>
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	75 3b                	jne    801d87 <devpipe_write+0x75>
			sys_yield();
  801d4c:	e8 3d ef ff ff       	call   800c8e <sys_yield>
  801d51:	eb e0                	jmp    801d33 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d56:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d5a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d5d:	89 c2                	mov    %eax,%edx
  801d5f:	c1 fa 1f             	sar    $0x1f,%edx
  801d62:	89 d1                	mov    %edx,%ecx
  801d64:	c1 e9 1b             	shr    $0x1b,%ecx
  801d67:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d6a:	83 e2 1f             	and    $0x1f,%edx
  801d6d:	29 ca                	sub    %ecx,%edx
  801d6f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d73:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d77:	83 c0 01             	add    $0x1,%eax
  801d7a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d7d:	83 c7 01             	add    $0x1,%edi
  801d80:	eb ac                	jmp    801d2e <devpipe_write+0x1c>
	return i;
  801d82:	8b 45 10             	mov    0x10(%ebp),%eax
  801d85:	eb 05                	jmp    801d8c <devpipe_write+0x7a>
				return 0;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <devpipe_read>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 18             	sub    $0x18,%esp
  801d9d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801da0:	57                   	push   %edi
  801da1:	e8 0c f2 ff ff       	call   800fb2 <fd2data>
  801da6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	be 00 00 00 00       	mov    $0x0,%esi
  801db0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801db3:	75 14                	jne    801dc9 <devpipe_read+0x35>
	return i;
  801db5:	8b 45 10             	mov    0x10(%ebp),%eax
  801db8:	eb 02                	jmp    801dbc <devpipe_read+0x28>
				return i;
  801dba:	89 f0                	mov    %esi,%eax
}
  801dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5f                   	pop    %edi
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    
			sys_yield();
  801dc4:	e8 c5 ee ff ff       	call   800c8e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dc9:	8b 03                	mov    (%ebx),%eax
  801dcb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dce:	75 18                	jne    801de8 <devpipe_read+0x54>
			if (i > 0)
  801dd0:	85 f6                	test   %esi,%esi
  801dd2:	75 e6                	jne    801dba <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dd4:	89 da                	mov    %ebx,%edx
  801dd6:	89 f8                	mov    %edi,%eax
  801dd8:	e8 d0 fe ff ff       	call   801cad <_pipeisclosed>
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	74 e3                	je     801dc4 <devpipe_read+0x30>
				return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	eb d4                	jmp    801dbc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801de8:	99                   	cltd   
  801de9:	c1 ea 1b             	shr    $0x1b,%edx
  801dec:	01 d0                	add    %edx,%eax
  801dee:	83 e0 1f             	and    $0x1f,%eax
  801df1:	29 d0                	sub    %edx,%eax
  801df3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dfb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dfe:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e01:	83 c6 01             	add    $0x1,%esi
  801e04:	eb aa                	jmp    801db0 <devpipe_read+0x1c>

00801e06 <pipe>:
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e11:	50                   	push   %eax
  801e12:	e8 b2 f1 ff ff       	call   800fc9 <fd_alloc>
  801e17:	89 c3                	mov    %eax,%ebx
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	0f 88 23 01 00 00    	js     801f47 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	68 07 04 00 00       	push   $0x407
  801e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2f:	6a 00                	push   $0x0
  801e31:	e8 77 ee ff ff       	call   800cad <sys_page_alloc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	0f 88 04 01 00 00    	js     801f47 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e49:	50                   	push   %eax
  801e4a:	e8 7a f1 ff ff       	call   800fc9 <fd_alloc>
  801e4f:	89 c3                	mov    %eax,%ebx
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	85 c0                	test   %eax,%eax
  801e56:	0f 88 db 00 00 00    	js     801f37 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	68 07 04 00 00       	push   $0x407
  801e64:	ff 75 f0             	pushl  -0x10(%ebp)
  801e67:	6a 00                	push   $0x0
  801e69:	e8 3f ee ff ff       	call   800cad <sys_page_alloc>
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	85 c0                	test   %eax,%eax
  801e75:	0f 88 bc 00 00 00    	js     801f37 <pipe+0x131>
	va = fd2data(fd0);
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e81:	e8 2c f1 ff ff       	call   800fb2 <fd2data>
  801e86:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e88:	83 c4 0c             	add    $0xc,%esp
  801e8b:	68 07 04 00 00       	push   $0x407
  801e90:	50                   	push   %eax
  801e91:	6a 00                	push   $0x0
  801e93:	e8 15 ee ff ff       	call   800cad <sys_page_alloc>
  801e98:	89 c3                	mov    %eax,%ebx
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	0f 88 82 00 00 00    	js     801f27 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	ff 75 f0             	pushl  -0x10(%ebp)
  801eab:	e8 02 f1 ff ff       	call   800fb2 <fd2data>
  801eb0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eb7:	50                   	push   %eax
  801eb8:	6a 00                	push   $0x0
  801eba:	56                   	push   %esi
  801ebb:	6a 00                	push   $0x0
  801ebd:	e8 2e ee ff ff       	call   800cf0 <sys_page_map>
  801ec2:	89 c3                	mov    %eax,%ebx
  801ec4:	83 c4 20             	add    $0x20,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	78 4e                	js     801f19 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ecb:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef4:	e8 a9 f0 ff ff       	call   800fa2 <fd2num>
  801ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801efe:	83 c4 04             	add    $0x4,%esp
  801f01:	ff 75 f0             	pushl  -0x10(%ebp)
  801f04:	e8 99 f0 ff ff       	call   800fa2 <fd2num>
  801f09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f0c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f17:	eb 2e                	jmp    801f47 <pipe+0x141>
	sys_page_unmap(0, va);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	56                   	push   %esi
  801f1d:	6a 00                	push   $0x0
  801f1f:	e8 0e ee ff ff       	call   800d32 <sys_page_unmap>
  801f24:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2d:	6a 00                	push   $0x0
  801f2f:	e8 fe ed ff ff       	call   800d32 <sys_page_unmap>
  801f34:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f37:	83 ec 08             	sub    $0x8,%esp
  801f3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3d:	6a 00                	push   $0x0
  801f3f:	e8 ee ed ff ff       	call   800d32 <sys_page_unmap>
  801f44:	83 c4 10             	add    $0x10,%esp
}
  801f47:	89 d8                	mov    %ebx,%eax
  801f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <pipeisclosed>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f59:	50                   	push   %eax
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 b9 f0 ff ff       	call   80101b <fd_lookup>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 18                	js     801f81 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6f:	e8 3e f0 ff ff       	call   800fb2 <fd2data>
	return _pipeisclosed(fd, p);
  801f74:	89 c2                	mov    %eax,%edx
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	e8 2f fd ff ff       	call   801cad <_pipeisclosed>
  801f7e:	83 c4 10             	add    $0x10,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	c3                   	ret    

00801f89 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f8f:	68 ef 29 80 00       	push   $0x8029ef
  801f94:	ff 75 0c             	pushl  0xc(%ebp)
  801f97:	e8 1f e9 ff ff       	call   8008bb <strcpy>
	return 0;
}
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <devcons_write>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	57                   	push   %edi
  801fa7:	56                   	push   %esi
  801fa8:	53                   	push   %ebx
  801fa9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801faf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fb4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fba:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fbd:	73 31                	jae    801ff0 <devcons_write+0x4d>
		m = n - tot;
  801fbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fc2:	29 f3                	sub    %esi,%ebx
  801fc4:	83 fb 7f             	cmp    $0x7f,%ebx
  801fc7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fcc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	53                   	push   %ebx
  801fd3:	89 f0                	mov    %esi,%eax
  801fd5:	03 45 0c             	add    0xc(%ebp),%eax
  801fd8:	50                   	push   %eax
  801fd9:	57                   	push   %edi
  801fda:	e8 6a ea ff ff       	call   800a49 <memmove>
		sys_cputs(buf, m);
  801fdf:	83 c4 08             	add    $0x8,%esp
  801fe2:	53                   	push   %ebx
  801fe3:	57                   	push   %edi
  801fe4:	e8 08 ec ff ff       	call   800bf1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fe9:	01 de                	add    %ebx,%esi
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	eb ca                	jmp    801fba <devcons_write+0x17>
}
  801ff0:	89 f0                	mov    %esi,%eax
  801ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5f                   	pop    %edi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <devcons_read>:
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 08             	sub    $0x8,%esp
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802005:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802009:	74 21                	je     80202c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80200b:	e8 ff eb ff ff       	call   800c0f <sys_cgetc>
  802010:	85 c0                	test   %eax,%eax
  802012:	75 07                	jne    80201b <devcons_read+0x21>
		sys_yield();
  802014:	e8 75 ec ff ff       	call   800c8e <sys_yield>
  802019:	eb f0                	jmp    80200b <devcons_read+0x11>
	if (c < 0)
  80201b:	78 0f                	js     80202c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80201d:	83 f8 04             	cmp    $0x4,%eax
  802020:	74 0c                	je     80202e <devcons_read+0x34>
	*(char*)vbuf = c;
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
  802025:	88 02                	mov    %al,(%edx)
	return 1;
  802027:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    
		return 0;
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	eb f7                	jmp    80202c <devcons_read+0x32>

00802035 <cputchar>:
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802041:	6a 01                	push   $0x1
  802043:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802046:	50                   	push   %eax
  802047:	e8 a5 eb ff ff       	call   800bf1 <sys_cputs>
}
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <getchar>:
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802057:	6a 01                	push   $0x1
  802059:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	6a 00                	push   $0x0
  80205f:	e8 27 f2 ff ff       	call   80128b <read>
	if (r < 0)
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	78 06                	js     802071 <getchar+0x20>
	if (r < 1)
  80206b:	74 06                	je     802073 <getchar+0x22>
	return c;
  80206d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    
		return -E_EOF;
  802073:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802078:	eb f7                	jmp    802071 <getchar+0x20>

0080207a <iscons>:
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802080:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802083:	50                   	push   %eax
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	e8 8f ef ff ff       	call   80101b <fd_lookup>
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 11                	js     8020a4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80209c:	39 10                	cmp    %edx,(%eax)
  80209e:	0f 94 c0             	sete   %al
  8020a1:	0f b6 c0             	movzbl %al,%eax
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <opencons>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020af:	50                   	push   %eax
  8020b0:	e8 14 ef ff ff       	call   800fc9 <fd_alloc>
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 3a                	js     8020f6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 07 04 00 00       	push   $0x407
  8020c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c7:	6a 00                	push   $0x0
  8020c9:	e8 df eb ff ff       	call   800cad <sys_page_alloc>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 21                	js     8020f6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020de:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	50                   	push   %eax
  8020ee:	e8 af ee ff ff       	call   800fa2 <fd2num>
  8020f3:	83 c4 10             	add    $0x10,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	56                   	push   %esi
  8020fc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020fd:	a1 08 40 80 00       	mov    0x804008,%eax
  802102:	8b 40 48             	mov    0x48(%eax),%eax
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 20 2a 80 00       	push   $0x802a20
  80210d:	50                   	push   %eax
  80210e:	68 0f 25 80 00       	push   $0x80250f
  802113:	e8 44 e0 ff ff       	call   80015c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802118:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80211b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802121:	e8 49 eb ff ff       	call   800c6f <sys_getenvid>
  802126:	83 c4 04             	add    $0x4,%esp
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	ff 75 08             	pushl  0x8(%ebp)
  80212f:	56                   	push   %esi
  802130:	50                   	push   %eax
  802131:	68 fc 29 80 00       	push   $0x8029fc
  802136:	e8 21 e0 ff ff       	call   80015c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80213b:	83 c4 18             	add    $0x18,%esp
  80213e:	53                   	push   %ebx
  80213f:	ff 75 10             	pushl  0x10(%ebp)
  802142:	e8 c4 df ff ff       	call   80010b <vcprintf>
	cprintf("\n");
  802147:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  80214e:	e8 09 e0 ff ff       	call   80015c <cprintf>
  802153:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802156:	cc                   	int3   
  802157:	eb fd                	jmp    802156 <_panic+0x5e>

00802159 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	56                   	push   %esi
  80215d:	53                   	push   %ebx
  80215e:	8b 75 08             	mov    0x8(%ebp),%esi
  802161:	8b 45 0c             	mov    0xc(%ebp),%eax
  802164:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802167:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802169:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80216e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	50                   	push   %eax
  802175:	e8 e3 ec ff ff       	call   800e5d <sys_ipc_recv>
	if(ret < 0){
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 2b                	js     8021ac <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802181:	85 f6                	test   %esi,%esi
  802183:	74 0a                	je     80218f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802185:	a1 08 40 80 00       	mov    0x804008,%eax
  80218a:	8b 40 78             	mov    0x78(%eax),%eax
  80218d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80218f:	85 db                	test   %ebx,%ebx
  802191:	74 0a                	je     80219d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802193:	a1 08 40 80 00       	mov    0x804008,%eax
  802198:	8b 40 7c             	mov    0x7c(%eax),%eax
  80219b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80219d:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a2:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a8:	5b                   	pop    %ebx
  8021a9:	5e                   	pop    %esi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
		if(from_env_store)
  8021ac:	85 f6                	test   %esi,%esi
  8021ae:	74 06                	je     8021b6 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021b0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021b6:	85 db                	test   %ebx,%ebx
  8021b8:	74 eb                	je     8021a5 <ipc_recv+0x4c>
			*perm_store = 0;
  8021ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021c0:	eb e3                	jmp    8021a5 <ipc_recv+0x4c>

008021c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 0c             	sub    $0xc,%esp
  8021cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021d4:	85 db                	test   %ebx,%ebx
  8021d6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021db:	0f 44 d8             	cmove  %eax,%ebx
  8021de:	eb 05                	jmp    8021e5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021e0:	e8 a9 ea ff ff       	call   800c8e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021e5:	ff 75 14             	pushl  0x14(%ebp)
  8021e8:	53                   	push   %ebx
  8021e9:	56                   	push   %esi
  8021ea:	57                   	push   %edi
  8021eb:	e8 4a ec ff ff       	call   800e3a <sys_ipc_try_send>
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 1b                	je     802212 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021f7:	79 e7                	jns    8021e0 <ipc_send+0x1e>
  8021f9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021fc:	74 e2                	je     8021e0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	68 27 2a 80 00       	push   $0x802a27
  802206:	6a 46                	push   $0x46
  802208:	68 3c 2a 80 00       	push   $0x802a3c
  80220d:	e8 e6 fe ff ff       	call   8020f8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802225:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80222b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802231:	8b 52 50             	mov    0x50(%edx),%edx
  802234:	39 ca                	cmp    %ecx,%edx
  802236:	74 11                	je     802249 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802238:	83 c0 01             	add    $0x1,%eax
  80223b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802240:	75 e3                	jne    802225 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
  802247:	eb 0e                	jmp    802257 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802249:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80224f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802254:	8b 40 48             	mov    0x48(%eax),%eax
}
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80225f:	89 d0                	mov    %edx,%eax
  802261:	c1 e8 16             	shr    $0x16,%eax
  802264:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802270:	f6 c1 01             	test   $0x1,%cl
  802273:	74 1d                	je     802292 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802275:	c1 ea 0c             	shr    $0xc,%edx
  802278:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80227f:	f6 c2 01             	test   $0x1,%dl
  802282:	74 0e                	je     802292 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802284:	c1 ea 0c             	shr    $0xc,%edx
  802287:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80228e:	ef 
  80228f:	0f b7 c0             	movzwl %ax,%eax
}
  802292:	5d                   	pop    %ebp
  802293:	c3                   	ret    
  802294:	66 90                	xchg   %ax,%ax
  802296:	66 90                	xchg   %ax,%ax
  802298:	66 90                	xchg   %ax,%ax
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__udivdi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022b7:	85 d2                	test   %edx,%edx
  8022b9:	75 4d                	jne    802308 <__udivdi3+0x68>
  8022bb:	39 f3                	cmp    %esi,%ebx
  8022bd:	76 19                	jbe    8022d8 <__udivdi3+0x38>
  8022bf:	31 ff                	xor    %edi,%edi
  8022c1:	89 e8                	mov    %ebp,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	f7 f3                	div    %ebx
  8022c7:	89 fa                	mov    %edi,%edx
  8022c9:	83 c4 1c             	add    $0x1c,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5f                   	pop    %edi
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    
  8022d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	89 d9                	mov    %ebx,%ecx
  8022da:	85 db                	test   %ebx,%ebx
  8022dc:	75 0b                	jne    8022e9 <__udivdi3+0x49>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	31 d2                	xor    %edx,%edx
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 c6                	mov    %eax,%esi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f7                	mov    %esi,%edi
  8022f5:	f7 f1                	div    %ecx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	77 1c                	ja     802328 <__udivdi3+0x88>
  80230c:	0f bd fa             	bsr    %edx,%edi
  80230f:	83 f7 1f             	xor    $0x1f,%edi
  802312:	75 2c                	jne    802340 <__udivdi3+0xa0>
  802314:	39 f2                	cmp    %esi,%edx
  802316:	72 06                	jb     80231e <__udivdi3+0x7e>
  802318:	31 c0                	xor    %eax,%eax
  80231a:	39 eb                	cmp    %ebp,%ebx
  80231c:	77 a9                	ja     8022c7 <__udivdi3+0x27>
  80231e:	b8 01 00 00 00       	mov    $0x1,%eax
  802323:	eb a2                	jmp    8022c7 <__udivdi3+0x27>
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	31 ff                	xor    %edi,%edi
  80232a:	31 c0                	xor    %eax,%eax
  80232c:	89 fa                	mov    %edi,%edx
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 27 ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 1d ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023c7:	89 da                	mov    %ebx,%edx
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	75 43                	jne    802410 <__umoddi3+0x60>
  8023cd:	39 df                	cmp    %ebx,%edi
  8023cf:	76 17                	jbe    8023e8 <__umoddi3+0x38>
  8023d1:	89 f0                	mov    %esi,%eax
  8023d3:	f7 f7                	div    %edi
  8023d5:	89 d0                	mov    %edx,%eax
  8023d7:	31 d2                	xor    %edx,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 fd                	mov    %edi,%ebp
  8023ea:	85 ff                	test   %edi,%edi
  8023ec:	75 0b                	jne    8023f9 <__umoddi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f7                	div    %edi
  8023f7:	89 c5                	mov    %eax,%ebp
  8023f9:	89 d8                	mov    %ebx,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f5                	div    %ebp
  8023ff:	89 f0                	mov    %esi,%eax
  802401:	f7 f5                	div    %ebp
  802403:	89 d0                	mov    %edx,%eax
  802405:	eb d0                	jmp    8023d7 <__umoddi3+0x27>
  802407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240e:	66 90                	xchg   %ax,%ax
  802410:	89 f1                	mov    %esi,%ecx
  802412:	39 d8                	cmp    %ebx,%eax
  802414:	76 0a                	jbe    802420 <__umoddi3+0x70>
  802416:	89 f0                	mov    %esi,%eax
  802418:	83 c4 1c             	add    $0x1c,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    
  802420:	0f bd e8             	bsr    %eax,%ebp
  802423:	83 f5 1f             	xor    $0x1f,%ebp
  802426:	75 20                	jne    802448 <__umoddi3+0x98>
  802428:	39 d8                	cmp    %ebx,%eax
  80242a:	0f 82 b0 00 00 00    	jb     8024e0 <__umoddi3+0x130>
  802430:	39 f7                	cmp    %esi,%edi
  802432:	0f 86 a8 00 00 00    	jbe    8024e0 <__umoddi3+0x130>
  802438:	89 c8                	mov    %ecx,%eax
  80243a:	83 c4 1c             	add    $0x1c,%esp
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5f                   	pop    %edi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    
  802442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802448:	89 e9                	mov    %ebp,%ecx
  80244a:	ba 20 00 00 00       	mov    $0x20,%edx
  80244f:	29 ea                	sub    %ebp,%edx
  802451:	d3 e0                	shl    %cl,%eax
  802453:	89 44 24 08          	mov    %eax,0x8(%esp)
  802457:	89 d1                	mov    %edx,%ecx
  802459:	89 f8                	mov    %edi,%eax
  80245b:	d3 e8                	shr    %cl,%eax
  80245d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802461:	89 54 24 04          	mov    %edx,0x4(%esp)
  802465:	8b 54 24 04          	mov    0x4(%esp),%edx
  802469:	09 c1                	or     %eax,%ecx
  80246b:	89 d8                	mov    %ebx,%eax
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 e9                	mov    %ebp,%ecx
  802473:	d3 e7                	shl    %cl,%edi
  802475:	89 d1                	mov    %edx,%ecx
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80247f:	d3 e3                	shl    %cl,%ebx
  802481:	89 c7                	mov    %eax,%edi
  802483:	89 d1                	mov    %edx,%ecx
  802485:	89 f0                	mov    %esi,%eax
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 fa                	mov    %edi,%edx
  80248d:	d3 e6                	shl    %cl,%esi
  80248f:	09 d8                	or     %ebx,%eax
  802491:	f7 74 24 08          	divl   0x8(%esp)
  802495:	89 d1                	mov    %edx,%ecx
  802497:	89 f3                	mov    %esi,%ebx
  802499:	f7 64 24 0c          	mull   0xc(%esp)
  80249d:	89 c6                	mov    %eax,%esi
  80249f:	89 d7                	mov    %edx,%edi
  8024a1:	39 d1                	cmp    %edx,%ecx
  8024a3:	72 06                	jb     8024ab <__umoddi3+0xfb>
  8024a5:	75 10                	jne    8024b7 <__umoddi3+0x107>
  8024a7:	39 c3                	cmp    %eax,%ebx
  8024a9:	73 0c                	jae    8024b7 <__umoddi3+0x107>
  8024ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024b3:	89 d7                	mov    %edx,%edi
  8024b5:	89 c6                	mov    %eax,%esi
  8024b7:	89 ca                	mov    %ecx,%edx
  8024b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024be:	29 f3                	sub    %esi,%ebx
  8024c0:	19 fa                	sbb    %edi,%edx
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	d3 e0                	shl    %cl,%eax
  8024c6:	89 e9                	mov    %ebp,%ecx
  8024c8:	d3 eb                	shr    %cl,%ebx
  8024ca:	d3 ea                	shr    %cl,%edx
  8024cc:	09 d8                	or     %ebx,%eax
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	29 fe                	sub    %edi,%esi
  8024e4:	19 c2                	sbb    %eax,%edx
  8024e6:	89 f1                	mov    %esi,%ecx
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	e9 4b ff ff ff       	jmp    80243a <__umoddi3+0x8a>
