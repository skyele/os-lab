
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 ac 0b 00 00       	call   800bee <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800052:	e8 15 0c 00 00       	call   800c6c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x30>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800096:	a1 08 40 80 00       	mov    0x804008,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	68 18 25 80 00       	push   $0x802518
  8000a3:	50                   	push   %eax
  8000a4:	68 0a 25 80 00       	push   $0x80250a
  8000a9:	e8 ab 00 00 00       	call   800159 <cprintf>
	close_all();
  8000ae:	e8 c4 10 00 00       	call   801177 <close_all>
	sys_env_destroy(0);
  8000b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ba:	e8 6c 0b 00 00       	call   800c2b <sys_env_destroy>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	53                   	push   %ebx
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ce:	8b 13                	mov    (%ebx),%edx
  8000d0:	8d 42 01             	lea    0x1(%edx),%eax
  8000d3:	89 03                	mov    %eax,(%ebx)
  8000d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e1:	74 09                	je     8000ec <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ea:	c9                   	leave  
  8000eb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ec:	83 ec 08             	sub    $0x8,%esp
  8000ef:	68 ff 00 00 00       	push   $0xff
  8000f4:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f7:	50                   	push   %eax
  8000f8:	e8 f1 0a 00 00       	call   800bee <sys_cputs>
		b->idx = 0;
  8000fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	eb db                	jmp    8000e3 <putch+0x1f>

00800108 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800111:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800118:	00 00 00 
	b.cnt = 0;
  80011b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800122:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800125:	ff 75 0c             	pushl  0xc(%ebp)
  800128:	ff 75 08             	pushl  0x8(%ebp)
  80012b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800131:	50                   	push   %eax
  800132:	68 c4 00 80 00       	push   $0x8000c4
  800137:	e8 4a 01 00 00       	call   800286 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013c:	83 c4 08             	add    $0x8,%esp
  80013f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800145:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 9d 0a 00 00       	call   800bee <sys_cputs>

	return b.cnt;
}
  800151:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800162:	50                   	push   %eax
  800163:	ff 75 08             	pushl  0x8(%ebp)
  800166:	e8 9d ff ff ff       	call   800108 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	57                   	push   %edi
  800171:	56                   	push   %esi
  800172:	53                   	push   %ebx
  800173:	83 ec 1c             	sub    $0x1c,%esp
  800176:	89 c6                	mov    %eax,%esi
  800178:	89 d7                	mov    %edx,%edi
  80017a:	8b 45 08             	mov    0x8(%ebp),%eax
  80017d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800180:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800183:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800186:	8b 45 10             	mov    0x10(%ebp),%eax
  800189:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80018c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800190:	74 2c                	je     8001be <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800192:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800195:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80019c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80019f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001a7:	73 43                	jae    8001ec <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001a9:	83 eb 01             	sub    $0x1,%ebx
  8001ac:	85 db                	test   %ebx,%ebx
  8001ae:	7e 6c                	jle    80021c <printnum+0xaf>
				putch(padc, putdat);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	57                   	push   %edi
  8001b4:	ff 75 18             	pushl  0x18(%ebp)
  8001b7:	ff d6                	call   *%esi
  8001b9:	83 c4 10             	add    $0x10,%esp
  8001bc:	eb eb                	jmp    8001a9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	6a 20                	push   $0x20
  8001c3:	6a 00                	push   $0x0
  8001c5:	50                   	push   %eax
  8001c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cc:	89 fa                	mov    %edi,%edx
  8001ce:	89 f0                	mov    %esi,%eax
  8001d0:	e8 98 ff ff ff       	call   80016d <printnum>
		while (--width > 0)
  8001d5:	83 c4 20             	add    $0x20,%esp
  8001d8:	83 eb 01             	sub    $0x1,%ebx
  8001db:	85 db                	test   %ebx,%ebx
  8001dd:	7e 65                	jle    800244 <printnum+0xd7>
			putch(padc, putdat);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	57                   	push   %edi
  8001e3:	6a 20                	push   $0x20
  8001e5:	ff d6                	call   *%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb ec                	jmp    8001d8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 18             	pushl  0x18(%ebp)
  8001f2:	83 eb 01             	sub    $0x1,%ebx
  8001f5:	53                   	push   %ebx
  8001f6:	50                   	push   %eax
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800200:	ff 75 e4             	pushl  -0x1c(%ebp)
  800203:	ff 75 e0             	pushl  -0x20(%ebp)
  800206:	e8 95 20 00 00       	call   8022a0 <__udivdi3>
  80020b:	83 c4 18             	add    $0x18,%esp
  80020e:	52                   	push   %edx
  80020f:	50                   	push   %eax
  800210:	89 fa                	mov    %edi,%edx
  800212:	89 f0                	mov    %esi,%eax
  800214:	e8 54 ff ff ff       	call   80016d <printnum>
  800219:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	57                   	push   %edi
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	ff 75 dc             	pushl  -0x24(%ebp)
  800226:	ff 75 d8             	pushl  -0x28(%ebp)
  800229:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	e8 7c 21 00 00       	call   8023b0 <__umoddi3>
  800234:	83 c4 14             	add    $0x14,%esp
  800237:	0f be 80 1d 25 80 00 	movsbl 0x80251d(%eax),%eax
  80023e:	50                   	push   %eax
  80023f:	ff d6                	call   *%esi
  800241:	83 c4 10             	add    $0x10,%esp
	}
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800252:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800256:	8b 10                	mov    (%eax),%edx
  800258:	3b 50 04             	cmp    0x4(%eax),%edx
  80025b:	73 0a                	jae    800267 <sprintputch+0x1b>
		*b->buf++ = ch;
  80025d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800260:	89 08                	mov    %ecx,(%eax)
  800262:	8b 45 08             	mov    0x8(%ebp),%eax
  800265:	88 02                	mov    %al,(%edx)
}
  800267:	5d                   	pop    %ebp
  800268:	c3                   	ret    

00800269 <printfmt>:
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80026f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800272:	50                   	push   %eax
  800273:	ff 75 10             	pushl  0x10(%ebp)
  800276:	ff 75 0c             	pushl  0xc(%ebp)
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 05 00 00 00       	call   800286 <vprintfmt>
}
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <vprintfmt>:
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	57                   	push   %edi
  80028a:	56                   	push   %esi
  80028b:	53                   	push   %ebx
  80028c:	83 ec 3c             	sub    $0x3c,%esp
  80028f:	8b 75 08             	mov    0x8(%ebp),%esi
  800292:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800295:	8b 7d 10             	mov    0x10(%ebp),%edi
  800298:	e9 32 04 00 00       	jmp    8006cf <vprintfmt+0x449>
		padc = ' ';
  80029d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002a1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002a8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c9:	8d 47 01             	lea    0x1(%edi),%eax
  8002cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cf:	0f b6 17             	movzbl (%edi),%edx
  8002d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d5:	3c 55                	cmp    $0x55,%al
  8002d7:	0f 87 12 05 00 00    	ja     8007ef <vprintfmt+0x569>
  8002dd:	0f b6 c0             	movzbl %al,%eax
  8002e0:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ea:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002ee:	eb d9                	jmp    8002c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002f7:	eb d0                	jmp    8002c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f9:	0f b6 d2             	movzbl %dl,%edx
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800304:	89 75 08             	mov    %esi,0x8(%ebp)
  800307:	eb 03                	jmp    80030c <vprintfmt+0x86>
  800309:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80030c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800313:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800316:	8d 72 d0             	lea    -0x30(%edx),%esi
  800319:	83 fe 09             	cmp    $0x9,%esi
  80031c:	76 eb                	jbe    800309 <vprintfmt+0x83>
  80031e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	eb 14                	jmp    80033a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	8b 00                	mov    (%eax),%eax
  80032b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032e:	8b 45 14             	mov    0x14(%ebp),%eax
  800331:	8d 40 04             	lea    0x4(%eax),%eax
  800334:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80033a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80033e:	79 89                	jns    8002c9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800340:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800343:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800346:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80034d:	e9 77 ff ff ff       	jmp    8002c9 <vprintfmt+0x43>
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	0f 48 c1             	cmovs  %ecx,%eax
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800360:	e9 64 ff ff ff       	jmp    8002c9 <vprintfmt+0x43>
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800368:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80036f:	e9 55 ff ff ff       	jmp    8002c9 <vprintfmt+0x43>
			lflag++;
  800374:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037b:	e9 49 ff ff ff       	jmp    8002c9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 78 04             	lea    0x4(%eax),%edi
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	53                   	push   %ebx
  80038a:	ff 30                	pushl  (%eax)
  80038c:	ff d6                	call   *%esi
			break;
  80038e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800391:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800394:	e9 33 03 00 00       	jmp    8006cc <vprintfmt+0x446>
			err = va_arg(ap, int);
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	8d 78 04             	lea    0x4(%eax),%edi
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	99                   	cltd   
  8003a2:	31 d0                	xor    %edx,%eax
  8003a4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a6:	83 f8 11             	cmp    $0x11,%eax
  8003a9:	7f 23                	jg     8003ce <vprintfmt+0x148>
  8003ab:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003b2:	85 d2                	test   %edx,%edx
  8003b4:	74 18                	je     8003ce <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003b6:	52                   	push   %edx
  8003b7:	68 7d 29 80 00       	push   $0x80297d
  8003bc:	53                   	push   %ebx
  8003bd:	56                   	push   %esi
  8003be:	e8 a6 fe ff ff       	call   800269 <printfmt>
  8003c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c9:	e9 fe 02 00 00       	jmp    8006cc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003ce:	50                   	push   %eax
  8003cf:	68 35 25 80 00       	push   $0x802535
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 8e fe ff ff       	call   800269 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e1:	e9 e6 02 00 00       	jmp    8006cc <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	83 c0 04             	add    $0x4,%eax
  8003ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003f4:	85 c9                	test   %ecx,%ecx
  8003f6:	b8 2e 25 80 00       	mov    $0x80252e,%eax
  8003fb:	0f 45 c1             	cmovne %ecx,%eax
  8003fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800401:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800405:	7e 06                	jle    80040d <vprintfmt+0x187>
  800407:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80040b:	75 0d                	jne    80041a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800410:	89 c7                	mov    %eax,%edi
  800412:	03 45 e0             	add    -0x20(%ebp),%eax
  800415:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800418:	eb 53                	jmp    80046d <vprintfmt+0x1e7>
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	ff 75 d8             	pushl  -0x28(%ebp)
  800420:	50                   	push   %eax
  800421:	e8 71 04 00 00       	call   800897 <strnlen>
  800426:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800429:	29 c1                	sub    %eax,%ecx
  80042b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800433:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043a:	eb 0f                	jmp    80044b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	53                   	push   %ebx
  800440:	ff 75 e0             	pushl  -0x20(%ebp)
  800443:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800445:	83 ef 01             	sub    $0x1,%edi
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	85 ff                	test   %edi,%edi
  80044d:	7f ed                	jg     80043c <vprintfmt+0x1b6>
  80044f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800452:	85 c9                	test   %ecx,%ecx
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	0f 49 c1             	cmovns %ecx,%eax
  80045c:	29 c1                	sub    %eax,%ecx
  80045e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800461:	eb aa                	jmp    80040d <vprintfmt+0x187>
					putch(ch, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	53                   	push   %ebx
  800467:	52                   	push   %edx
  800468:	ff d6                	call   *%esi
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800470:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800472:	83 c7 01             	add    $0x1,%edi
  800475:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800479:	0f be d0             	movsbl %al,%edx
  80047c:	85 d2                	test   %edx,%edx
  80047e:	74 4b                	je     8004cb <vprintfmt+0x245>
  800480:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800484:	78 06                	js     80048c <vprintfmt+0x206>
  800486:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048a:	78 1e                	js     8004aa <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80048c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800490:	74 d1                	je     800463 <vprintfmt+0x1dd>
  800492:	0f be c0             	movsbl %al,%eax
  800495:	83 e8 20             	sub    $0x20,%eax
  800498:	83 f8 5e             	cmp    $0x5e,%eax
  80049b:	76 c6                	jbe    800463 <vprintfmt+0x1dd>
					putch('?', putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	6a 3f                	push   $0x3f
  8004a3:	ff d6                	call   *%esi
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	eb c3                	jmp    80046d <vprintfmt+0x1e7>
  8004aa:	89 cf                	mov    %ecx,%edi
  8004ac:	eb 0e                	jmp    8004bc <vprintfmt+0x236>
				putch(' ', putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	53                   	push   %ebx
  8004b2:	6a 20                	push   $0x20
  8004b4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004b6:	83 ef 01             	sub    $0x1,%edi
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	85 ff                	test   %edi,%edi
  8004be:	7f ee                	jg     8004ae <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c6:	e9 01 02 00 00       	jmp    8006cc <vprintfmt+0x446>
  8004cb:	89 cf                	mov    %ecx,%edi
  8004cd:	eb ed                	jmp    8004bc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004d2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004d9:	e9 eb fd ff ff       	jmp    8002c9 <vprintfmt+0x43>
	if (lflag >= 2)
  8004de:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004e2:	7f 21                	jg     800505 <vprintfmt+0x27f>
	else if (lflag)
  8004e4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004e8:	74 68                	je     800552 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f2:	89 c1                	mov    %eax,%ecx
  8004f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 40 04             	lea    0x4(%eax),%eax
  800500:	89 45 14             	mov    %eax,0x14(%ebp)
  800503:	eb 17                	jmp    80051c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8b 50 04             	mov    0x4(%eax),%edx
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800510:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8d 40 08             	lea    0x8(%eax),%eax
  800519:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80051c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80051f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800522:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800525:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800528:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80052c:	78 3f                	js     80056d <vprintfmt+0x2e7>
			base = 10;
  80052e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800533:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800537:	0f 84 71 01 00 00    	je     8006ae <vprintfmt+0x428>
				putch('+', putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	53                   	push   %ebx
  800541:	6a 2b                	push   $0x2b
  800543:	ff d6                	call   *%esi
  800545:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054d:	e9 5c 01 00 00       	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, int);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80055a:	89 c1                	mov    %eax,%ecx
  80055c:	c1 f9 1f             	sar    $0x1f,%ecx
  80055f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
  80056b:	eb af                	jmp    80051c <vprintfmt+0x296>
				putch('-', putdat);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	53                   	push   %ebx
  800571:	6a 2d                	push   $0x2d
  800573:	ff d6                	call   *%esi
				num = -(long long) num;
  800575:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800578:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057b:	f7 d8                	neg    %eax
  80057d:	83 d2 00             	adc    $0x0,%edx
  800580:	f7 da                	neg    %edx
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800588:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800590:	e9 19 01 00 00       	jmp    8006ae <vprintfmt+0x428>
	if (lflag >= 2)
  800595:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800599:	7f 29                	jg     8005c4 <vprintfmt+0x33e>
	else if (lflag)
  80059b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80059f:	74 44                	je     8005e5 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 40 04             	lea    0x4(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bf:	e9 ea 00 00 00       	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 40 08             	lea    0x8(%eax),%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e0:	e9 c9 00 00 00       	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800603:	e9 a6 00 00 00       	jmp    8006ae <vprintfmt+0x428>
			putch('0', putdat);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	53                   	push   %ebx
  80060c:	6a 30                	push   $0x30
  80060e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800617:	7f 26                	jg     80063f <vprintfmt+0x3b9>
	else if (lflag)
  800619:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061d:	74 3e                	je     80065d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	ba 00 00 00 00       	mov    $0x0,%edx
  800629:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800638:	b8 08 00 00 00       	mov    $0x8,%eax
  80063d:	eb 6f                	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 50 04             	mov    0x4(%eax),%edx
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 08             	lea    0x8(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800656:	b8 08 00 00 00       	mov    $0x8,%eax
  80065b:	eb 51                	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800676:	b8 08 00 00 00       	mov    $0x8,%eax
  80067b:	eb 31                	jmp    8006ae <vprintfmt+0x428>
			putch('0', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 30                	push   $0x30
  800683:	ff d6                	call   *%esi
			putch('x', putdat);
  800685:	83 c4 08             	add    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 78                	push   $0x78
  80068b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80069d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006b5:	52                   	push   %edx
  8006b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8006bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c0:	89 da                	mov    %ebx,%edx
  8006c2:	89 f0                	mov    %esi,%eax
  8006c4:	e8 a4 fa ff ff       	call   80016d <printnum>
			break;
  8006c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cf:	83 c7 01             	add    $0x1,%edi
  8006d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d6:	83 f8 25             	cmp    $0x25,%eax
  8006d9:	0f 84 be fb ff ff    	je     80029d <vprintfmt+0x17>
			if (ch == '\0')
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	0f 84 28 01 00 00    	je     80080f <vprintfmt+0x589>
			putch(ch, putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	50                   	push   %eax
  8006ec:	ff d6                	call   *%esi
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	eb dc                	jmp    8006cf <vprintfmt+0x449>
	if (lflag >= 2)
  8006f3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f7:	7f 26                	jg     80071f <vprintfmt+0x499>
	else if (lflag)
  8006f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fd:	74 41                	je     800740 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	ba 00 00 00 00       	mov    $0x0,%edx
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 40 04             	lea    0x4(%eax),%eax
  800715:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800718:	b8 10 00 00 00       	mov    $0x10,%eax
  80071d:	eb 8f                	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 50 04             	mov    0x4(%eax),%edx
  800725:	8b 00                	mov    (%eax),%eax
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 40 08             	lea    0x8(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
  80073b:	e9 6e ff ff ff       	jmp    8006ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
  80074a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800759:	b8 10 00 00 00       	mov    $0x10,%eax
  80075e:	e9 4b ff ff ff       	jmp    8006ae <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	83 c0 04             	add    $0x4,%eax
  800769:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	85 c0                	test   %eax,%eax
  800773:	74 14                	je     800789 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800775:	8b 13                	mov    (%ebx),%edx
  800777:	83 fa 7f             	cmp    $0x7f,%edx
  80077a:	7f 37                	jg     8007b3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80077c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80077e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	e9 43 ff ff ff       	jmp    8006cc <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800789:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078e:	bf 51 26 80 00       	mov    $0x802651,%edi
							putch(ch, putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	50                   	push   %eax
  800798:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80079a:	83 c7 01             	add    $0x1,%edi
  80079d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	75 eb                	jne    800793 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ae:	e9 19 ff ff ff       	jmp    8006cc <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007b3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ba:	bf 89 26 80 00       	mov    $0x802689,%edi
							putch(ch, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	50                   	push   %eax
  8007c4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007c6:	83 c7 01             	add    $0x1,%edi
  8007c9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	75 eb                	jne    8007bf <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007da:	e9 ed fe ff ff       	jmp    8006cc <vprintfmt+0x446>
			putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	6a 25                	push   $0x25
  8007e5:	ff d6                	call   *%esi
			break;
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	e9 dd fe ff ff       	jmp    8006cc <vprintfmt+0x446>
			putch('%', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	6a 25                	push   $0x25
  8007f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	89 f8                	mov    %edi,%eax
  8007fc:	eb 03                	jmp    800801 <vprintfmt+0x57b>
  8007fe:	83 e8 01             	sub    $0x1,%eax
  800801:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800805:	75 f7                	jne    8007fe <vprintfmt+0x578>
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	e9 bd fe ff ff       	jmp    8006cc <vprintfmt+0x446>
}
  80080f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800812:	5b                   	pop    %ebx
  800813:	5e                   	pop    %esi
  800814:	5f                   	pop    %edi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	83 ec 18             	sub    $0x18,%esp
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800823:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800826:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80082a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800834:	85 c0                	test   %eax,%eax
  800836:	74 26                	je     80085e <vsnprintf+0x47>
  800838:	85 d2                	test   %edx,%edx
  80083a:	7e 22                	jle    80085e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083c:	ff 75 14             	pushl  0x14(%ebp)
  80083f:	ff 75 10             	pushl  0x10(%ebp)
  800842:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	68 4c 02 80 00       	push   $0x80024c
  80084b:	e8 36 fa ff ff       	call   800286 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800853:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800859:	83 c4 10             	add    $0x10,%esp
}
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    
		return -E_INVAL;
  80085e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800863:	eb f7                	jmp    80085c <vsnprintf+0x45>

00800865 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086e:	50                   	push   %eax
  80086f:	ff 75 10             	pushl  0x10(%ebp)
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 9a ff ff ff       	call   800817 <vsnprintf>
	va_end(ap);

	return rc;
}
  80087d:	c9                   	leave  
  80087e:	c3                   	ret    

0080087f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80088e:	74 05                	je     800895 <strlen+0x16>
		n++;
  800890:	83 c0 01             	add    $0x1,%eax
  800893:	eb f5                	jmp    80088a <strlen+0xb>
	return n;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	39 c2                	cmp    %eax,%edx
  8008a7:	74 0d                	je     8008b6 <strnlen+0x1f>
  8008a9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ad:	74 05                	je     8008b4 <strnlen+0x1d>
		n++;
  8008af:	83 c2 01             	add    $0x1,%edx
  8008b2:	eb f1                	jmp    8008a5 <strnlen+0xe>
  8008b4:	89 d0                	mov    %edx,%eax
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008cb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ce:	83 c2 01             	add    $0x1,%edx
  8008d1:	84 c9                	test   %cl,%cl
  8008d3:	75 f2                	jne    8008c7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008d5:	5b                   	pop    %ebx
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	53                   	push   %ebx
  8008dc:	83 ec 10             	sub    $0x10,%esp
  8008df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e2:	53                   	push   %ebx
  8008e3:	e8 97 ff ff ff       	call   80087f <strlen>
  8008e8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	01 d8                	add    %ebx,%eax
  8008f0:	50                   	push   %eax
  8008f1:	e8 c2 ff ff ff       	call   8008b8 <strcpy>
	return dst;
}
  8008f6:	89 d8                	mov    %ebx,%eax
  8008f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	56                   	push   %esi
  800901:	53                   	push   %ebx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800908:	89 c6                	mov    %eax,%esi
  80090a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	39 f2                	cmp    %esi,%edx
  800911:	74 11                	je     800924 <strncpy+0x27>
		*dst++ = *src;
  800913:	83 c2 01             	add    $0x1,%edx
  800916:	0f b6 19             	movzbl (%ecx),%ebx
  800919:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091c:	80 fb 01             	cmp    $0x1,%bl
  80091f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800922:	eb eb                	jmp    80090f <strncpy+0x12>
	}
	return ret;
}
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 75 08             	mov    0x8(%ebp),%esi
  800930:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800933:	8b 55 10             	mov    0x10(%ebp),%edx
  800936:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800938:	85 d2                	test   %edx,%edx
  80093a:	74 21                	je     80095d <strlcpy+0x35>
  80093c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800940:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800942:	39 c2                	cmp    %eax,%edx
  800944:	74 14                	je     80095a <strlcpy+0x32>
  800946:	0f b6 19             	movzbl (%ecx),%ebx
  800949:	84 db                	test   %bl,%bl
  80094b:	74 0b                	je     800958 <strlcpy+0x30>
			*dst++ = *src++;
  80094d:	83 c1 01             	add    $0x1,%ecx
  800950:	83 c2 01             	add    $0x1,%edx
  800953:	88 5a ff             	mov    %bl,-0x1(%edx)
  800956:	eb ea                	jmp    800942 <strlcpy+0x1a>
  800958:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80095a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80095d:	29 f0                	sub    %esi,%eax
}
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096c:	0f b6 01             	movzbl (%ecx),%eax
  80096f:	84 c0                	test   %al,%al
  800971:	74 0c                	je     80097f <strcmp+0x1c>
  800973:	3a 02                	cmp    (%edx),%al
  800975:	75 08                	jne    80097f <strcmp+0x1c>
		p++, q++;
  800977:	83 c1 01             	add    $0x1,%ecx
  80097a:	83 c2 01             	add    $0x1,%edx
  80097d:	eb ed                	jmp    80096c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097f:	0f b6 c0             	movzbl %al,%eax
  800982:	0f b6 12             	movzbl (%edx),%edx
  800985:	29 d0                	sub    %edx,%eax
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	53                   	push   %ebx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx
  800993:	89 c3                	mov    %eax,%ebx
  800995:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800998:	eb 06                	jmp    8009a0 <strncmp+0x17>
		n--, p++, q++;
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a0:	39 d8                	cmp    %ebx,%eax
  8009a2:	74 16                	je     8009ba <strncmp+0x31>
  8009a4:	0f b6 08             	movzbl (%eax),%ecx
  8009a7:	84 c9                	test   %cl,%cl
  8009a9:	74 04                	je     8009af <strncmp+0x26>
  8009ab:	3a 0a                	cmp    (%edx),%cl
  8009ad:	74 eb                	je     80099a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009af:	0f b6 00             	movzbl (%eax),%eax
  8009b2:	0f b6 12             	movzbl (%edx),%edx
  8009b5:	29 d0                	sub    %edx,%eax
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    
		return 0;
  8009ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bf:	eb f6                	jmp    8009b7 <strncmp+0x2e>

008009c1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009cb:	0f b6 10             	movzbl (%eax),%edx
  8009ce:	84 d2                	test   %dl,%dl
  8009d0:	74 09                	je     8009db <strchr+0x1a>
		if (*s == c)
  8009d2:	38 ca                	cmp    %cl,%dl
  8009d4:	74 0a                	je     8009e0 <strchr+0x1f>
	for (; *s; s++)
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	eb f0                	jmp    8009cb <strchr+0xa>
			return (char *) s;
	return 0;
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ec:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ef:	38 ca                	cmp    %cl,%dl
  8009f1:	74 09                	je     8009fc <strfind+0x1a>
  8009f3:	84 d2                	test   %dl,%dl
  8009f5:	74 05                	je     8009fc <strfind+0x1a>
	for (; *s; s++)
  8009f7:	83 c0 01             	add    $0x1,%eax
  8009fa:	eb f0                	jmp    8009ec <strfind+0xa>
			break;
	return (char *) s;
}
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	57                   	push   %edi
  800a02:	56                   	push   %esi
  800a03:	53                   	push   %ebx
  800a04:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0a:	85 c9                	test   %ecx,%ecx
  800a0c:	74 31                	je     800a3f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0e:	89 f8                	mov    %edi,%eax
  800a10:	09 c8                	or     %ecx,%eax
  800a12:	a8 03                	test   $0x3,%al
  800a14:	75 23                	jne    800a39 <memset+0x3b>
		c &= 0xFF;
  800a16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1a:	89 d3                	mov    %edx,%ebx
  800a1c:	c1 e3 08             	shl    $0x8,%ebx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	c1 e0 18             	shl    $0x18,%eax
  800a24:	89 d6                	mov    %edx,%esi
  800a26:	c1 e6 10             	shl    $0x10,%esi
  800a29:	09 f0                	or     %esi,%eax
  800a2b:	09 c2                	or     %eax,%edx
  800a2d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	fc                   	cld    
  800a35:	f3 ab                	rep stos %eax,%es:(%edi)
  800a37:	eb 06                	jmp    800a3f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	fc                   	cld    
  800a3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5f                   	pop    %edi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	57                   	push   %edi
  800a4a:	56                   	push   %esi
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a54:	39 c6                	cmp    %eax,%esi
  800a56:	73 32                	jae    800a8a <memmove+0x44>
  800a58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	76 2b                	jbe    800a8a <memmove+0x44>
		s += n;
		d += n;
  800a5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a62:	89 fe                	mov    %edi,%esi
  800a64:	09 ce                	or     %ecx,%esi
  800a66:	09 d6                	or     %edx,%esi
  800a68:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6e:	75 0e                	jne    800a7e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a70:	83 ef 04             	sub    $0x4,%edi
  800a73:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a76:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a79:	fd                   	std    
  800a7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7c:	eb 09                	jmp    800a87 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7e:	83 ef 01             	sub    $0x1,%edi
  800a81:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a84:	fd                   	std    
  800a85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a87:	fc                   	cld    
  800a88:	eb 1a                	jmp    800aa4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	09 ca                	or     %ecx,%edx
  800a8e:	09 f2                	or     %esi,%edx
  800a90:	f6 c2 03             	test   $0x3,%dl
  800a93:	75 0a                	jne    800a9f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a95:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a98:	89 c7                	mov    %eax,%edi
  800a9a:	fc                   	cld    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 05                	jmp    800aa4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800a9f:	89 c7                	mov    %eax,%edi
  800aa1:	fc                   	cld    
  800aa2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa4:	5e                   	pop    %esi
  800aa5:	5f                   	pop    %edi
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aae:	ff 75 10             	pushl  0x10(%ebp)
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	e8 8a ff ff ff       	call   800a46 <memmove>
}
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac9:	89 c6                	mov    %eax,%esi
  800acb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ace:	39 f0                	cmp    %esi,%eax
  800ad0:	74 1c                	je     800aee <memcmp+0x30>
		if (*s1 != *s2)
  800ad2:	0f b6 08             	movzbl (%eax),%ecx
  800ad5:	0f b6 1a             	movzbl (%edx),%ebx
  800ad8:	38 d9                	cmp    %bl,%cl
  800ada:	75 08                	jne    800ae4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800adc:	83 c0 01             	add    $0x1,%eax
  800adf:	83 c2 01             	add    $0x1,%edx
  800ae2:	eb ea                	jmp    800ace <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae4:	0f b6 c1             	movzbl %cl,%eax
  800ae7:	0f b6 db             	movzbl %bl,%ebx
  800aea:	29 d8                	sub    %ebx,%eax
  800aec:	eb 05                	jmp    800af3 <memcmp+0x35>
	}

	return 0;
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af3:	5b                   	pop    %ebx
  800af4:	5e                   	pop    %esi
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b00:	89 c2                	mov    %eax,%edx
  800b02:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b05:	39 d0                	cmp    %edx,%eax
  800b07:	73 09                	jae    800b12 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b09:	38 08                	cmp    %cl,(%eax)
  800b0b:	74 05                	je     800b12 <memfind+0x1b>
	for (; s < ends; s++)
  800b0d:	83 c0 01             	add    $0x1,%eax
  800b10:	eb f3                	jmp    800b05 <memfind+0xe>
			break;
	return (void *) s;
}
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b20:	eb 03                	jmp    800b25 <strtol+0x11>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b25:	0f b6 01             	movzbl (%ecx),%eax
  800b28:	3c 20                	cmp    $0x20,%al
  800b2a:	74 f6                	je     800b22 <strtol+0xe>
  800b2c:	3c 09                	cmp    $0x9,%al
  800b2e:	74 f2                	je     800b22 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b30:	3c 2b                	cmp    $0x2b,%al
  800b32:	74 2a                	je     800b5e <strtol+0x4a>
	int neg = 0;
  800b34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b39:	3c 2d                	cmp    $0x2d,%al
  800b3b:	74 2b                	je     800b68 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b43:	75 0f                	jne    800b54 <strtol+0x40>
  800b45:	80 39 30             	cmpb   $0x30,(%ecx)
  800b48:	74 28                	je     800b72 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b51:	0f 44 d8             	cmove  %eax,%ebx
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5c:	eb 50                	jmp    800bae <strtol+0x9a>
		s++;
  800b5e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b61:	bf 00 00 00 00       	mov    $0x0,%edi
  800b66:	eb d5                	jmp    800b3d <strtol+0x29>
		s++, neg = 1;
  800b68:	83 c1 01             	add    $0x1,%ecx
  800b6b:	bf 01 00 00 00       	mov    $0x1,%edi
  800b70:	eb cb                	jmp    800b3d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b72:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b76:	74 0e                	je     800b86 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b78:	85 db                	test   %ebx,%ebx
  800b7a:	75 d8                	jne    800b54 <strtol+0x40>
		s++, base = 8;
  800b7c:	83 c1 01             	add    $0x1,%ecx
  800b7f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b84:	eb ce                	jmp    800b54 <strtol+0x40>
		s += 2, base = 16;
  800b86:	83 c1 02             	add    $0x2,%ecx
  800b89:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b8e:	eb c4                	jmp    800b54 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b90:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b93:	89 f3                	mov    %esi,%ebx
  800b95:	80 fb 19             	cmp    $0x19,%bl
  800b98:	77 29                	ja     800bc3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800b9a:	0f be d2             	movsbl %dl,%edx
  800b9d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba3:	7d 30                	jge    800bd5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ba5:	83 c1 01             	add    $0x1,%ecx
  800ba8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bac:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bae:	0f b6 11             	movzbl (%ecx),%edx
  800bb1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb4:	89 f3                	mov    %esi,%ebx
  800bb6:	80 fb 09             	cmp    $0x9,%bl
  800bb9:	77 d5                	ja     800b90 <strtol+0x7c>
			dig = *s - '0';
  800bbb:	0f be d2             	movsbl %dl,%edx
  800bbe:	83 ea 30             	sub    $0x30,%edx
  800bc1:	eb dd                	jmp    800ba0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bc3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc6:	89 f3                	mov    %esi,%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 08                	ja     800bd5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bcd:	0f be d2             	movsbl %dl,%edx
  800bd0:	83 ea 37             	sub    $0x37,%edx
  800bd3:	eb cb                	jmp    800ba0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd9:	74 05                	je     800be0 <strtol+0xcc>
		*endptr = (char *) s;
  800bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bde:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be0:	89 c2                	mov    %eax,%edx
  800be2:	f7 da                	neg    %edx
  800be4:	85 ff                	test   %edi,%edi
  800be6:	0f 45 c2             	cmovne %edx,%eax
}
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5f                   	pop    %edi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bff:	89 c3                	mov    %eax,%ebx
  800c01:	89 c7                	mov    %eax,%edi
  800c03:	89 c6                	mov    %eax,%esi
  800c05:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c12:	ba 00 00 00 00       	mov    $0x0,%edx
  800c17:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1c:	89 d1                	mov    %edx,%ecx
  800c1e:	89 d3                	mov    %edx,%ebx
  800c20:	89 d7                	mov    %edx,%edi
  800c22:	89 d6                	mov    %edx,%esi
  800c24:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c41:	89 cb                	mov    %ecx,%ebx
  800c43:	89 cf                	mov    %ecx,%edi
  800c45:	89 ce                	mov    %ecx,%esi
  800c47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c49:	85 c0                	test   %eax,%eax
  800c4b:	7f 08                	jg     800c55 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c55:	83 ec 0c             	sub    $0xc,%esp
  800c58:	50                   	push   %eax
  800c59:	6a 03                	push   $0x3
  800c5b:	68 a8 28 80 00       	push   $0x8028a8
  800c60:	6a 43                	push   $0x43
  800c62:	68 c5 28 80 00       	push   $0x8028c5
  800c67:	e8 89 14 00 00       	call   8020f5 <_panic>

00800c6c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7c:	89 d1                	mov    %edx,%ecx
  800c7e:	89 d3                	mov    %edx,%ebx
  800c80:	89 d7                	mov    %edx,%edi
  800c82:	89 d6                	mov    %edx,%esi
  800c84:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <sys_yield>:

void
sys_yield(void)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c91:	ba 00 00 00 00       	mov    $0x0,%edx
  800c96:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9b:	89 d1                	mov    %edx,%ecx
  800c9d:	89 d3                	mov    %edx,%ebx
  800c9f:	89 d7                	mov    %edx,%edi
  800ca1:	89 d6                	mov    %edx,%esi
  800ca3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb3:	be 00 00 00 00       	mov    $0x0,%esi
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc6:	89 f7                	mov    %esi,%edi
  800cc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 04                	push   $0x4
  800cdc:	68 a8 28 80 00       	push   $0x8028a8
  800ce1:	6a 43                	push   $0x43
  800ce3:	68 c5 28 80 00       	push   $0x8028c5
  800ce8:	e8 08 14 00 00       	call   8020f5 <_panic>

00800ced <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	b8 05 00 00 00       	mov    $0x5,%eax
  800d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d04:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d07:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7f 08                	jg     800d18 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	50                   	push   %eax
  800d1c:	6a 05                	push   $0x5
  800d1e:	68 a8 28 80 00       	push   $0x8028a8
  800d23:	6a 43                	push   $0x43
  800d25:	68 c5 28 80 00       	push   $0x8028c5
  800d2a:	e8 c6 13 00 00       	call   8020f5 <_panic>

00800d2f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 06 00 00 00       	mov    $0x6,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 06                	push   $0x6
  800d60:	68 a8 28 80 00       	push   $0x8028a8
  800d65:	6a 43                	push   $0x43
  800d67:	68 c5 28 80 00       	push   $0x8028c5
  800d6c:	e8 84 13 00 00       	call   8020f5 <_panic>

00800d71 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	b8 08 00 00 00       	mov    $0x8,%eax
  800d8a:	89 df                	mov    %ebx,%edi
  800d8c:	89 de                	mov    %ebx,%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 08                	push   $0x8
  800da2:	68 a8 28 80 00       	push   $0x8028a8
  800da7:	6a 43                	push   $0x43
  800da9:	68 c5 28 80 00       	push   $0x8028c5
  800dae:	e8 42 13 00 00       	call   8020f5 <_panic>

00800db3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 09                	push   $0x9
  800de4:	68 a8 28 80 00       	push   $0x8028a8
  800de9:	6a 43                	push   $0x43
  800deb:	68 c5 28 80 00       	push   $0x8028c5
  800df0:	e8 00 13 00 00       	call   8020f5 <_panic>

00800df5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 0a                	push   $0xa
  800e26:	68 a8 28 80 00       	push   $0x8028a8
  800e2b:	6a 43                	push   $0x43
  800e2d:	68 c5 28 80 00       	push   $0x8028c5
  800e32:	e8 be 12 00 00       	call   8020f5 <_panic>

00800e37 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e48:	be 00 00 00 00       	mov    $0x0,%esi
  800e4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e53:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e68:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e70:	89 cb                	mov    %ecx,%ebx
  800e72:	89 cf                	mov    %ecx,%edi
  800e74:	89 ce                	mov    %ecx,%esi
  800e76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7f 08                	jg     800e84 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5f                   	pop    %edi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e84:	83 ec 0c             	sub    $0xc,%esp
  800e87:	50                   	push   %eax
  800e88:	6a 0d                	push   $0xd
  800e8a:	68 a8 28 80 00       	push   $0x8028a8
  800e8f:	6a 43                	push   $0x43
  800e91:	68 c5 28 80 00       	push   $0x8028c5
  800e96:	e8 5a 12 00 00       	call   8020f5 <_panic>

00800e9b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ecf:	89 cb                	mov    %ecx,%ebx
  800ed1:	89 cf                	mov    %ecx,%edi
  800ed3:	89 ce                	mov    %ecx,%esi
  800ed5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee7:	b8 10 00 00 00       	mov    $0x10,%eax
  800eec:	89 d1                	mov    %edx,%ecx
  800eee:	89 d3                	mov    %edx,%ebx
  800ef0:	89 d7                	mov    %edx,%edi
  800ef2:	89 d6                	mov    %edx,%esi
  800ef4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0c:	b8 11 00 00 00       	mov    $0x11,%eax
  800f11:	89 df                	mov    %ebx,%edi
  800f13:	89 de                	mov    %ebx,%esi
  800f15:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	b8 12 00 00 00       	mov    $0x12,%eax
  800f32:	89 df                	mov    %ebx,%edi
  800f34:	89 de                	mov    %ebx,%esi
  800f36:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	b8 13 00 00 00       	mov    $0x13,%eax
  800f56:	89 df                	mov    %ebx,%edi
  800f58:	89 de                	mov    %ebx,%esi
  800f5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	7f 08                	jg     800f68 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	50                   	push   %eax
  800f6c:	6a 13                	push   $0x13
  800f6e:	68 a8 28 80 00       	push   $0x8028a8
  800f73:	6a 43                	push   $0x43
  800f75:	68 c5 28 80 00       	push   $0x8028c5
  800f7a:	e8 76 11 00 00       	call   8020f5 <_panic>

00800f7f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	b8 14 00 00 00       	mov    $0x14,%eax
  800f92:	89 cb                	mov    %ecx,%ebx
  800f94:	89 cf                	mov    %ecx,%edi
  800f96:	89 ce                	mov    %ecx,%esi
  800f98:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	05 00 00 00 30       	add    $0x30000000,%eax
  800faa:	c1 e8 0c             	shr    $0xc,%eax
}
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fbf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fce:	89 c2                	mov    %eax,%edx
  800fd0:	c1 ea 16             	shr    $0x16,%edx
  800fd3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fda:	f6 c2 01             	test   $0x1,%dl
  800fdd:	74 2d                	je     80100c <fd_alloc+0x46>
  800fdf:	89 c2                	mov    %eax,%edx
  800fe1:	c1 ea 0c             	shr    $0xc,%edx
  800fe4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800feb:	f6 c2 01             	test   $0x1,%dl
  800fee:	74 1c                	je     80100c <fd_alloc+0x46>
  800ff0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ff5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ffa:	75 d2                	jne    800fce <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801005:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80100a:	eb 0a                	jmp    801016 <fd_alloc+0x50>
			*fd_store = fd;
  80100c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80101e:	83 f8 1f             	cmp    $0x1f,%eax
  801021:	77 30                	ja     801053 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801023:	c1 e0 0c             	shl    $0xc,%eax
  801026:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80102b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801031:	f6 c2 01             	test   $0x1,%dl
  801034:	74 24                	je     80105a <fd_lookup+0x42>
  801036:	89 c2                	mov    %eax,%edx
  801038:	c1 ea 0c             	shr    $0xc,%edx
  80103b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801042:	f6 c2 01             	test   $0x1,%dl
  801045:	74 1a                	je     801061 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104a:	89 02                	mov    %eax,(%edx)
	return 0;
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    
		return -E_INVAL;
  801053:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801058:	eb f7                	jmp    801051 <fd_lookup+0x39>
		return -E_INVAL;
  80105a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105f:	eb f0                	jmp    801051 <fd_lookup+0x39>
  801061:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801066:	eb e9                	jmp    801051 <fd_lookup+0x39>

00801068 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801071:	ba 00 00 00 00       	mov    $0x0,%edx
  801076:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80107b:	39 08                	cmp    %ecx,(%eax)
  80107d:	74 38                	je     8010b7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80107f:	83 c2 01             	add    $0x1,%edx
  801082:	8b 04 95 50 29 80 00 	mov    0x802950(,%edx,4),%eax
  801089:	85 c0                	test   %eax,%eax
  80108b:	75 ee                	jne    80107b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80108d:	a1 08 40 80 00       	mov    0x804008,%eax
  801092:	8b 40 48             	mov    0x48(%eax),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	51                   	push   %ecx
  801099:	50                   	push   %eax
  80109a:	68 d4 28 80 00       	push   $0x8028d4
  80109f:	e8 b5 f0 ff ff       	call   800159 <cprintf>
	*dev = 0;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010b5:	c9                   	leave  
  8010b6:	c3                   	ret    
			*dev = devtab[i];
  8010b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ba:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c1:	eb f2                	jmp    8010b5 <dev_lookup+0x4d>

008010c3 <fd_close>:
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	57                   	push   %edi
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 24             	sub    $0x24,%esp
  8010cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8010cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010d5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010dc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010df:	50                   	push   %eax
  8010e0:	e8 33 ff ff ff       	call   801018 <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 05                	js     8010f3 <fd_close+0x30>
	    || fd != fd2)
  8010ee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010f1:	74 16                	je     801109 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010f3:	89 f8                	mov    %edi,%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	0f 44 d8             	cmove  %eax,%ebx
}
  8010ff:	89 d8                	mov    %ebx,%eax
  801101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80110f:	50                   	push   %eax
  801110:	ff 36                	pushl  (%esi)
  801112:	e8 51 ff ff ff       	call   801068 <dev_lookup>
  801117:	89 c3                	mov    %eax,%ebx
  801119:	83 c4 10             	add    $0x10,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 1a                	js     80113a <fd_close+0x77>
		if (dev->dev_close)
  801120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801123:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801126:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80112b:	85 c0                	test   %eax,%eax
  80112d:	74 0b                	je     80113a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80112f:	83 ec 0c             	sub    $0xc,%esp
  801132:	56                   	push   %esi
  801133:	ff d0                	call   *%eax
  801135:	89 c3                	mov    %eax,%ebx
  801137:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	56                   	push   %esi
  80113e:	6a 00                	push   $0x0
  801140:	e8 ea fb ff ff       	call   800d2f <sys_page_unmap>
	return r;
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb b5                	jmp    8010ff <fd_close+0x3c>

0080114a <close>:

int
close(int fdnum)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801150:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801153:	50                   	push   %eax
  801154:	ff 75 08             	pushl  0x8(%ebp)
  801157:	e8 bc fe ff ff       	call   801018 <fd_lookup>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	79 02                	jns    801165 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    
		return fd_close(fd, 1);
  801165:	83 ec 08             	sub    $0x8,%esp
  801168:	6a 01                	push   $0x1
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	e8 51 ff ff ff       	call   8010c3 <fd_close>
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	eb ec                	jmp    801163 <close+0x19>

00801177 <close_all>:

void
close_all(void)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	53                   	push   %ebx
  80117b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80117e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	53                   	push   %ebx
  801187:	e8 be ff ff ff       	call   80114a <close>
	for (i = 0; i < MAXFD; i++)
  80118c:	83 c3 01             	add    $0x1,%ebx
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	83 fb 20             	cmp    $0x20,%ebx
  801195:	75 ec                	jne    801183 <close_all+0xc>
}
  801197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	e8 67 fe ff ff       	call   801018 <fd_lookup>
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	0f 88 81 00 00 00    	js     80123f <dup+0xa3>
		return r;
	close(newfdnum);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	ff 75 0c             	pushl  0xc(%ebp)
  8011c4:	e8 81 ff ff ff       	call   80114a <close>

	newfd = INDEX2FD(newfdnum);
  8011c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011cc:	c1 e6 0c             	shl    $0xc,%esi
  8011cf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011d5:	83 c4 04             	add    $0x4,%esp
  8011d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011db:	e8 cf fd ff ff       	call   800faf <fd2data>
  8011e0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011e2:	89 34 24             	mov    %esi,(%esp)
  8011e5:	e8 c5 fd ff ff       	call   800faf <fd2data>
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011ef:	89 d8                	mov    %ebx,%eax
  8011f1:	c1 e8 16             	shr    $0x16,%eax
  8011f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011fb:	a8 01                	test   $0x1,%al
  8011fd:	74 11                	je     801210 <dup+0x74>
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	c1 e8 0c             	shr    $0xc,%eax
  801204:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80120b:	f6 c2 01             	test   $0x1,%dl
  80120e:	75 39                	jne    801249 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801210:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801213:	89 d0                	mov    %edx,%eax
  801215:	c1 e8 0c             	shr    $0xc,%eax
  801218:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80121f:	83 ec 0c             	sub    $0xc,%esp
  801222:	25 07 0e 00 00       	and    $0xe07,%eax
  801227:	50                   	push   %eax
  801228:	56                   	push   %esi
  801229:	6a 00                	push   $0x0
  80122b:	52                   	push   %edx
  80122c:	6a 00                	push   $0x0
  80122e:	e8 ba fa ff ff       	call   800ced <sys_page_map>
  801233:	89 c3                	mov    %eax,%ebx
  801235:	83 c4 20             	add    $0x20,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 31                	js     80126d <dup+0xd1>
		goto err;

	return newfdnum;
  80123c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80123f:	89 d8                	mov    %ebx,%eax
  801241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801249:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	25 07 0e 00 00       	and    $0xe07,%eax
  801258:	50                   	push   %eax
  801259:	57                   	push   %edi
  80125a:	6a 00                	push   $0x0
  80125c:	53                   	push   %ebx
  80125d:	6a 00                	push   $0x0
  80125f:	e8 89 fa ff ff       	call   800ced <sys_page_map>
  801264:	89 c3                	mov    %eax,%ebx
  801266:	83 c4 20             	add    $0x20,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	79 a3                	jns    801210 <dup+0x74>
	sys_page_unmap(0, newfd);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	56                   	push   %esi
  801271:	6a 00                	push   $0x0
  801273:	e8 b7 fa ff ff       	call   800d2f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801278:	83 c4 08             	add    $0x8,%esp
  80127b:	57                   	push   %edi
  80127c:	6a 00                	push   $0x0
  80127e:	e8 ac fa ff ff       	call   800d2f <sys_page_unmap>
	return r;
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	eb b7                	jmp    80123f <dup+0xa3>

00801288 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	53                   	push   %ebx
  80128c:	83 ec 1c             	sub    $0x1c,%esp
  80128f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801292:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801295:	50                   	push   %eax
  801296:	53                   	push   %ebx
  801297:	e8 7c fd ff ff       	call   801018 <fd_lookup>
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 3f                	js     8012e2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a9:	50                   	push   %eax
  8012aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ad:	ff 30                	pushl  (%eax)
  8012af:	e8 b4 fd ff ff       	call   801068 <dev_lookup>
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 27                	js     8012e2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012be:	8b 42 08             	mov    0x8(%edx),%eax
  8012c1:	83 e0 03             	and    $0x3,%eax
  8012c4:	83 f8 01             	cmp    $0x1,%eax
  8012c7:	74 1e                	je     8012e7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cc:	8b 40 08             	mov    0x8(%eax),%eax
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	74 35                	je     801308 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012d3:	83 ec 04             	sub    $0x4,%esp
  8012d6:	ff 75 10             	pushl  0x10(%ebp)
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	52                   	push   %edx
  8012dd:	ff d0                	call   *%eax
  8012df:	83 c4 10             	add    $0x10,%esp
}
  8012e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ec:	8b 40 48             	mov    0x48(%eax),%eax
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	53                   	push   %ebx
  8012f3:	50                   	push   %eax
  8012f4:	68 15 29 80 00       	push   $0x802915
  8012f9:	e8 5b ee ff ff       	call   800159 <cprintf>
		return -E_INVAL;
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801306:	eb da                	jmp    8012e2 <read+0x5a>
		return -E_NOT_SUPP;
  801308:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80130d:	eb d3                	jmp    8012e2 <read+0x5a>

0080130f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	8b 7d 08             	mov    0x8(%ebp),%edi
  80131b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80131e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801323:	39 f3                	cmp    %esi,%ebx
  801325:	73 23                	jae    80134a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	89 f0                	mov    %esi,%eax
  80132c:	29 d8                	sub    %ebx,%eax
  80132e:	50                   	push   %eax
  80132f:	89 d8                	mov    %ebx,%eax
  801331:	03 45 0c             	add    0xc(%ebp),%eax
  801334:	50                   	push   %eax
  801335:	57                   	push   %edi
  801336:	e8 4d ff ff ff       	call   801288 <read>
		if (m < 0)
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 06                	js     801348 <readn+0x39>
			return m;
		if (m == 0)
  801342:	74 06                	je     80134a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801344:	01 c3                	add    %eax,%ebx
  801346:	eb db                	jmp    801323 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801348:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80134a:	89 d8                	mov    %ebx,%eax
  80134c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134f:	5b                   	pop    %ebx
  801350:	5e                   	pop    %esi
  801351:	5f                   	pop    %edi
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	53                   	push   %ebx
  801358:	83 ec 1c             	sub    $0x1c,%esp
  80135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80135e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801361:	50                   	push   %eax
  801362:	53                   	push   %ebx
  801363:	e8 b0 fc ff ff       	call   801018 <fd_lookup>
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 3a                	js     8013a9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80136f:	83 ec 08             	sub    $0x8,%esp
  801372:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801379:	ff 30                	pushl  (%eax)
  80137b:	e8 e8 fc ff ff       	call   801068 <dev_lookup>
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 22                	js     8013a9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80138e:	74 1e                	je     8013ae <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801393:	8b 52 0c             	mov    0xc(%edx),%edx
  801396:	85 d2                	test   %edx,%edx
  801398:	74 35                	je     8013cf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	ff 75 10             	pushl  0x10(%ebp)
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	50                   	push   %eax
  8013a4:	ff d2                	call   *%edx
  8013a6:	83 c4 10             	add    $0x10,%esp
}
  8013a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b3:	8b 40 48             	mov    0x48(%eax),%eax
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	53                   	push   %ebx
  8013ba:	50                   	push   %eax
  8013bb:	68 31 29 80 00       	push   $0x802931
  8013c0:	e8 94 ed ff ff       	call   800159 <cprintf>
		return -E_INVAL;
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013cd:	eb da                	jmp    8013a9 <write+0x55>
		return -E_NOT_SUPP;
  8013cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d4:	eb d3                	jmp    8013a9 <write+0x55>

008013d6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	e8 30 fc ff ff       	call   801018 <fd_lookup>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 0e                	js     8013fd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	53                   	push   %ebx
  801403:	83 ec 1c             	sub    $0x1c,%esp
  801406:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801409:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	53                   	push   %ebx
  80140e:	e8 05 fc ff ff       	call   801018 <fd_lookup>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 37                	js     801451 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141a:	83 ec 08             	sub    $0x8,%esp
  80141d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801420:	50                   	push   %eax
  801421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801424:	ff 30                	pushl  (%eax)
  801426:	e8 3d fc ff ff       	call   801068 <dev_lookup>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 1f                	js     801451 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801439:	74 1b                	je     801456 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80143b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143e:	8b 52 18             	mov    0x18(%edx),%edx
  801441:	85 d2                	test   %edx,%edx
  801443:	74 32                	je     801477 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	50                   	push   %eax
  80144c:	ff d2                	call   *%edx
  80144e:	83 c4 10             	add    $0x10,%esp
}
  801451:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801454:	c9                   	leave  
  801455:	c3                   	ret    
			thisenv->env_id, fdnum);
  801456:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80145b:	8b 40 48             	mov    0x48(%eax),%eax
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	53                   	push   %ebx
  801462:	50                   	push   %eax
  801463:	68 f4 28 80 00       	push   $0x8028f4
  801468:	e8 ec ec ff ff       	call   800159 <cprintf>
		return -E_INVAL;
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801475:	eb da                	jmp    801451 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801477:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147c:	eb d3                	jmp    801451 <ftruncate+0x52>

0080147e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801488:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	ff 75 08             	pushl  0x8(%ebp)
  80148f:	e8 84 fb ff ff       	call   801018 <fd_lookup>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 4b                	js     8014e6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a5:	ff 30                	pushl  (%eax)
  8014a7:	e8 bc fb ff ff       	call   801068 <dev_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 33                	js     8014e6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ba:	74 2f                	je     8014eb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014bc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014c6:	00 00 00 
	stat->st_isdir = 0;
  8014c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d0:	00 00 00 
	stat->st_dev = dev;
  8014d3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	53                   	push   %ebx
  8014dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8014e0:	ff 50 14             	call   *0x14(%eax)
  8014e3:	83 c4 10             	add    $0x10,%esp
}
  8014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    
		return -E_NOT_SUPP;
  8014eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f0:	eb f4                	jmp    8014e6 <fstat+0x68>

008014f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	6a 00                	push   $0x0
  8014fc:	ff 75 08             	pushl  0x8(%ebp)
  8014ff:	e8 22 02 00 00       	call   801726 <open>
  801504:	89 c3                	mov    %eax,%ebx
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 1b                	js     801528 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	50                   	push   %eax
  801514:	e8 65 ff ff ff       	call   80147e <fstat>
  801519:	89 c6                	mov    %eax,%esi
	close(fd);
  80151b:	89 1c 24             	mov    %ebx,(%esp)
  80151e:	e8 27 fc ff ff       	call   80114a <close>
	return r;
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	89 f3                	mov    %esi,%ebx
}
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    

00801531 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
  801536:	89 c6                	mov    %eax,%esi
  801538:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80153a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801541:	74 27                	je     80156a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801543:	6a 07                	push   $0x7
  801545:	68 00 50 80 00       	push   $0x805000
  80154a:	56                   	push   %esi
  80154b:	ff 35 00 40 80 00    	pushl  0x804000
  801551:	e8 69 0c 00 00       	call   8021bf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801556:	83 c4 0c             	add    $0xc,%esp
  801559:	6a 00                	push   $0x0
  80155b:	53                   	push   %ebx
  80155c:	6a 00                	push   $0x0
  80155e:	e8 f3 0b 00 00       	call   802156 <ipc_recv>
}
  801563:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801566:	5b                   	pop    %ebx
  801567:	5e                   	pop    %esi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	6a 01                	push   $0x1
  80156f:	e8 a3 0c 00 00       	call   802217 <ipc_find_env>
  801574:	a3 00 40 80 00       	mov    %eax,0x804000
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	eb c5                	jmp    801543 <fsipc+0x12>

0080157e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8b 40 0c             	mov    0xc(%eax),%eax
  80158a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	b8 02 00 00 00       	mov    $0x2,%eax
  8015a1:	e8 8b ff ff ff       	call   801531 <fsipc>
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <devfile_flush>:
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b8 06 00 00 00       	mov    $0x6,%eax
  8015c3:	e8 69 ff ff ff       	call   801531 <fsipc>
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <devfile_stat>:
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015da:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015df:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015e9:	e8 43 ff ff ff       	call   801531 <fsipc>
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 2c                	js     80161e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	68 00 50 80 00       	push   $0x805000
  8015fa:	53                   	push   %ebx
  8015fb:	e8 b8 f2 ff ff       	call   8008b8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801600:	a1 80 50 80 00       	mov    0x805080,%eax
  801605:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80160b:	a1 84 50 80 00       	mov    0x805084,%eax
  801610:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <devfile_write>:
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	53                   	push   %ebx
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 40 0c             	mov    0xc(%eax),%eax
  801633:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801638:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80163e:	53                   	push   %ebx
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	68 08 50 80 00       	push   $0x805008
  801647:	e8 5c f4 ff ff       	call   800aa8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80164c:	ba 00 00 00 00       	mov    $0x0,%edx
  801651:	b8 04 00 00 00       	mov    $0x4,%eax
  801656:	e8 d6 fe ff ff       	call   801531 <fsipc>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 0b                	js     80166d <devfile_write+0x4a>
	assert(r <= n);
  801662:	39 d8                	cmp    %ebx,%eax
  801664:	77 0c                	ja     801672 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801666:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80166b:	7f 1e                	jg     80168b <devfile_write+0x68>
}
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    
	assert(r <= n);
  801672:	68 64 29 80 00       	push   $0x802964
  801677:	68 6b 29 80 00       	push   $0x80296b
  80167c:	68 98 00 00 00       	push   $0x98
  801681:	68 80 29 80 00       	push   $0x802980
  801686:	e8 6a 0a 00 00       	call   8020f5 <_panic>
	assert(r <= PGSIZE);
  80168b:	68 8b 29 80 00       	push   $0x80298b
  801690:	68 6b 29 80 00       	push   $0x80296b
  801695:	68 99 00 00 00       	push   $0x99
  80169a:	68 80 29 80 00       	push   $0x802980
  80169f:	e8 51 0a 00 00       	call   8020f5 <_panic>

008016a4 <devfile_read>:
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016b7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8016c7:	e8 65 fe ff ff       	call   801531 <fsipc>
  8016cc:	89 c3                	mov    %eax,%ebx
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	78 1f                	js     8016f1 <devfile_read+0x4d>
	assert(r <= n);
  8016d2:	39 f0                	cmp    %esi,%eax
  8016d4:	77 24                	ja     8016fa <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016d6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016db:	7f 33                	jg     801710 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	50                   	push   %eax
  8016e1:	68 00 50 80 00       	push   $0x805000
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	e8 58 f3 ff ff       	call   800a46 <memmove>
	return r;
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    
	assert(r <= n);
  8016fa:	68 64 29 80 00       	push   $0x802964
  8016ff:	68 6b 29 80 00       	push   $0x80296b
  801704:	6a 7c                	push   $0x7c
  801706:	68 80 29 80 00       	push   $0x802980
  80170b:	e8 e5 09 00 00       	call   8020f5 <_panic>
	assert(r <= PGSIZE);
  801710:	68 8b 29 80 00       	push   $0x80298b
  801715:	68 6b 29 80 00       	push   $0x80296b
  80171a:	6a 7d                	push   $0x7d
  80171c:	68 80 29 80 00       	push   $0x802980
  801721:	e8 cf 09 00 00       	call   8020f5 <_panic>

00801726 <open>:
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
  80172b:	83 ec 1c             	sub    $0x1c,%esp
  80172e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801731:	56                   	push   %esi
  801732:	e8 48 f1 ff ff       	call   80087f <strlen>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80173f:	7f 6c                	jg     8017ad <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801741:	83 ec 0c             	sub    $0xc,%esp
  801744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801747:	50                   	push   %eax
  801748:	e8 79 f8 ff ff       	call   800fc6 <fd_alloc>
  80174d:	89 c3                	mov    %eax,%ebx
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	85 c0                	test   %eax,%eax
  801754:	78 3c                	js     801792 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	56                   	push   %esi
  80175a:	68 00 50 80 00       	push   $0x805000
  80175f:	e8 54 f1 ff ff       	call   8008b8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80176c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176f:	b8 01 00 00 00       	mov    $0x1,%eax
  801774:	e8 b8 fd ff ff       	call   801531 <fsipc>
  801779:	89 c3                	mov    %eax,%ebx
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 19                	js     80179b <open+0x75>
	return fd2num(fd);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	ff 75 f4             	pushl  -0xc(%ebp)
  801788:	e8 12 f8 ff ff       	call   800f9f <fd2num>
  80178d:	89 c3                	mov    %eax,%ebx
  80178f:	83 c4 10             	add    $0x10,%esp
}
  801792:	89 d8                	mov    %ebx,%eax
  801794:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801797:	5b                   	pop    %ebx
  801798:	5e                   	pop    %esi
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    
		fd_close(fd, 0);
  80179b:	83 ec 08             	sub    $0x8,%esp
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a3:	e8 1b f9 ff ff       	call   8010c3 <fd_close>
		return r;
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	eb e5                	jmp    801792 <open+0x6c>
		return -E_BAD_PATH;
  8017ad:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017b2:	eb de                	jmp    801792 <open+0x6c>

008017b4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c4:	e8 68 fd ff ff       	call   801531 <fsipc>
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017d1:	68 97 29 80 00       	push   $0x802997
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	e8 da f0 ff ff       	call   8008b8 <strcpy>
	return 0;
}
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <devsock_close>:
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 10             	sub    $0x10,%esp
  8017ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ef:	53                   	push   %ebx
  8017f0:	e8 61 0a 00 00       	call   802256 <pageref>
  8017f5:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017f8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017fd:	83 f8 01             	cmp    $0x1,%eax
  801800:	74 07                	je     801809 <devsock_close+0x24>
}
  801802:	89 d0                	mov    %edx,%eax
  801804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801807:	c9                   	leave  
  801808:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	ff 73 0c             	pushl  0xc(%ebx)
  80180f:	e8 b9 02 00 00       	call   801acd <nsipc_close>
  801814:	89 c2                	mov    %eax,%edx
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	eb e7                	jmp    801802 <devsock_close+0x1d>

0080181b <devsock_write>:
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801821:	6a 00                	push   $0x0
  801823:	ff 75 10             	pushl  0x10(%ebp)
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	ff 70 0c             	pushl  0xc(%eax)
  80182f:	e8 76 03 00 00       	call   801baa <nsipc_send>
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <devsock_read>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 10             	pushl  0x10(%ebp)
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	ff 70 0c             	pushl  0xc(%eax)
  80184a:	e8 ef 02 00 00       	call   801b3e <nsipc_recv>
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <fd2sockid>:
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801857:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80185a:	52                   	push   %edx
  80185b:	50                   	push   %eax
  80185c:	e8 b7 f7 ff ff       	call   801018 <fd_lookup>
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	78 10                	js     801878 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186b:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801871:	39 08                	cmp    %ecx,(%eax)
  801873:	75 05                	jne    80187a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801875:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    
		return -E_NOT_SUPP;
  80187a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187f:	eb f7                	jmp    801878 <fd2sockid+0x27>

00801881 <alloc_sockfd>:
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
  801886:	83 ec 1c             	sub    $0x1c,%esp
  801889:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	50                   	push   %eax
  80188f:	e8 32 f7 ff ff       	call   800fc6 <fd_alloc>
  801894:	89 c3                	mov    %eax,%ebx
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 43                	js     8018e0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	68 07 04 00 00       	push   $0x407
  8018a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 fb f3 ff ff       	call   800caa <sys_page_alloc>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 28                	js     8018e0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018c1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018cd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	50                   	push   %eax
  8018d4:	e8 c6 f6 ff ff       	call   800f9f <fd2num>
  8018d9:	89 c3                	mov    %eax,%ebx
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	eb 0c                	jmp    8018ec <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	56                   	push   %esi
  8018e4:	e8 e4 01 00 00       	call   801acd <nsipc_close>
		return r;
  8018e9:	83 c4 10             	add    $0x10,%esp
}
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <accept>:
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	e8 4e ff ff ff       	call   801851 <fd2sockid>
  801903:	85 c0                	test   %eax,%eax
  801905:	78 1b                	js     801922 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	ff 75 10             	pushl  0x10(%ebp)
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	50                   	push   %eax
  801911:	e8 0e 01 00 00       	call   801a24 <nsipc_accept>
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 05                	js     801922 <accept+0x2d>
	return alloc_sockfd(r);
  80191d:	e8 5f ff ff ff       	call   801881 <alloc_sockfd>
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <bind>:
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	e8 1f ff ff ff       	call   801851 <fd2sockid>
  801932:	85 c0                	test   %eax,%eax
  801934:	78 12                	js     801948 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	ff 75 10             	pushl  0x10(%ebp)
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	50                   	push   %eax
  801940:	e8 31 01 00 00       	call   801a76 <nsipc_bind>
  801945:	83 c4 10             	add    $0x10,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <shutdown>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	e8 f9 fe ff ff       	call   801851 <fd2sockid>
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 0f                	js     80196b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	50                   	push   %eax
  801963:	e8 43 01 00 00       	call   801aab <nsipc_shutdown>
  801968:	83 c4 10             	add    $0x10,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <connect>:
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	e8 d6 fe ff ff       	call   801851 <fd2sockid>
  80197b:	85 c0                	test   %eax,%eax
  80197d:	78 12                	js     801991 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	e8 59 01 00 00       	call   801ae7 <nsipc_connect>
  80198e:	83 c4 10             	add    $0x10,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <listen>:
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	e8 b0 fe ff ff       	call   801851 <fd2sockid>
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 0f                	js     8019b4 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	e8 6b 01 00 00       	call   801b1c <nsipc_listen>
  8019b1:	83 c4 10             	add    $0x10,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019bc:	ff 75 10             	pushl  0x10(%ebp)
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	e8 3e 02 00 00       	call   801c08 <nsipc_socket>
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 05                	js     8019d6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019d1:	e8 ab fe ff ff       	call   801881 <alloc_sockfd>
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019e1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019e8:	74 26                	je     801a10 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019ea:	6a 07                	push   $0x7
  8019ec:	68 00 60 80 00       	push   $0x806000
  8019f1:	53                   	push   %ebx
  8019f2:	ff 35 04 40 80 00    	pushl  0x804004
  8019f8:	e8 c2 07 00 00       	call   8021bf <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019fd:	83 c4 0c             	add    $0xc,%esp
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	e8 4b 07 00 00       	call   802156 <ipc_recv>
}
  801a0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a10:	83 ec 0c             	sub    $0xc,%esp
  801a13:	6a 02                	push   $0x2
  801a15:	e8 fd 07 00 00       	call   802217 <ipc_find_env>
  801a1a:	a3 04 40 80 00       	mov    %eax,0x804004
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	eb c6                	jmp    8019ea <nsipc+0x12>

00801a24 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	56                   	push   %esi
  801a28:	53                   	push   %ebx
  801a29:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a34:	8b 06                	mov    (%esi),%eax
  801a36:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a40:	e8 93 ff ff ff       	call   8019d8 <nsipc>
  801a45:	89 c3                	mov    %eax,%ebx
  801a47:	85 c0                	test   %eax,%eax
  801a49:	79 09                	jns    801a54 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a4b:	89 d8                	mov    %ebx,%eax
  801a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	ff 35 10 60 80 00    	pushl  0x806010
  801a5d:	68 00 60 80 00       	push   $0x806000
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 dc ef ff ff       	call   800a46 <memmove>
		*addrlen = ret->ret_addrlen;
  801a6a:	a1 10 60 80 00       	mov    0x806010,%eax
  801a6f:	89 06                	mov    %eax,(%esi)
  801a71:	83 c4 10             	add    $0x10,%esp
	return r;
  801a74:	eb d5                	jmp    801a4b <nsipc_accept+0x27>

00801a76 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 08             	sub    $0x8,%esp
  801a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a88:	53                   	push   %ebx
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	68 04 60 80 00       	push   $0x806004
  801a91:	e8 b0 ef ff ff       	call   800a46 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a96:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a9c:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa1:	e8 32 ff ff ff       	call   8019d8 <nsipc>
}
  801aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ac1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac6:	e8 0d ff ff ff       	call   8019d8 <nsipc>
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <nsipc_close>:

int
nsipc_close(int s)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801adb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae0:	e8 f3 fe ff ff       	call   8019d8 <nsipc>
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 08             	sub    $0x8,%esp
  801aee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801af9:	53                   	push   %ebx
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	68 04 60 80 00       	push   $0x806004
  801b02:	e8 3f ef ff ff       	call   800a46 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b07:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b0d:	b8 05 00 00 00       	mov    $0x5,%eax
  801b12:	e8 c1 fe ff ff       	call   8019d8 <nsipc>
}
  801b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b32:	b8 06 00 00 00       	mov    $0x6,%eax
  801b37:	e8 9c fe ff ff       	call   8019d8 <nsipc>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b4e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b54:	8b 45 14             	mov    0x14(%ebp),%eax
  801b57:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801b61:	e8 72 fe ff ff       	call   8019d8 <nsipc>
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 1f                	js     801b8b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b6c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b71:	7f 21                	jg     801b94 <nsipc_recv+0x56>
  801b73:	39 c6                	cmp    %eax,%esi
  801b75:	7c 1d                	jl     801b94 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	50                   	push   %eax
  801b7b:	68 00 60 80 00       	push   $0x806000
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	e8 be ee ff ff       	call   800a46 <memmove>
  801b88:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b90:	5b                   	pop    %ebx
  801b91:	5e                   	pop    %esi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b94:	68 a3 29 80 00       	push   $0x8029a3
  801b99:	68 6b 29 80 00       	push   $0x80296b
  801b9e:	6a 62                	push   $0x62
  801ba0:	68 b8 29 80 00       	push   $0x8029b8
  801ba5:	e8 4b 05 00 00       	call   8020f5 <_panic>

00801baa <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	53                   	push   %ebx
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bbc:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc2:	7f 2e                	jg     801bf2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	53                   	push   %ebx
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	68 0c 60 80 00       	push   $0x80600c
  801bd0:	e8 71 ee ff ff       	call   800a46 <memmove>
	nsipcbuf.send.req_size = size;
  801bd5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801be3:	b8 08 00 00 00       	mov    $0x8,%eax
  801be8:	e8 eb fd ff ff       	call   8019d8 <nsipc>
}
  801bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    
	assert(size < 1600);
  801bf2:	68 c4 29 80 00       	push   $0x8029c4
  801bf7:	68 6b 29 80 00       	push   $0x80296b
  801bfc:	6a 6d                	push   $0x6d
  801bfe:	68 b8 29 80 00       	push   $0x8029b8
  801c03:	e8 ed 04 00 00       	call   8020f5 <_panic>

00801c08 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c19:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c21:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c26:	b8 09 00 00 00       	mov    $0x9,%eax
  801c2b:	e8 a8 fd ff ff       	call   8019d8 <nsipc>
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	56                   	push   %esi
  801c36:	53                   	push   %ebx
  801c37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	e8 6a f3 ff ff       	call   800faf <fd2data>
  801c45:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c47:	83 c4 08             	add    $0x8,%esp
  801c4a:	68 d0 29 80 00       	push   $0x8029d0
  801c4f:	53                   	push   %ebx
  801c50:	e8 63 ec ff ff       	call   8008b8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c55:	8b 46 04             	mov    0x4(%esi),%eax
  801c58:	2b 06                	sub    (%esi),%eax
  801c5a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c60:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c67:	00 00 00 
	stat->st_dev = &devpipe;
  801c6a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c71:	30 80 00 
	return 0;
}
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c8a:	53                   	push   %ebx
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 9d f0 ff ff       	call   800d2f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c92:	89 1c 24             	mov    %ebx,(%esp)
  801c95:	e8 15 f3 ff ff       	call   800faf <fd2data>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	50                   	push   %eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	e8 8a f0 ff ff       	call   800d2f <sys_page_unmap>
}
  801ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <_pipeisclosed>:
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	57                   	push   %edi
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
  801cb3:	89 c7                	mov    %eax,%edi
  801cb5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cb7:	a1 08 40 80 00       	mov    0x804008,%eax
  801cbc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	57                   	push   %edi
  801cc3:	e8 8e 05 00 00       	call   802256 <pageref>
  801cc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ccb:	89 34 24             	mov    %esi,(%esp)
  801cce:	e8 83 05 00 00       	call   802256 <pageref>
		nn = thisenv->env_runs;
  801cd3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cd9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	39 cb                	cmp    %ecx,%ebx
  801ce1:	74 1b                	je     801cfe <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ce3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ce6:	75 cf                	jne    801cb7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ce8:	8b 42 58             	mov    0x58(%edx),%eax
  801ceb:	6a 01                	push   $0x1
  801ced:	50                   	push   %eax
  801cee:	53                   	push   %ebx
  801cef:	68 d7 29 80 00       	push   $0x8029d7
  801cf4:	e8 60 e4 ff ff       	call   800159 <cprintf>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	eb b9                	jmp    801cb7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cfe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d01:	0f 94 c0             	sete   %al
  801d04:	0f b6 c0             	movzbl %al,%eax
}
  801d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0a:	5b                   	pop    %ebx
  801d0b:	5e                   	pop    %esi
  801d0c:	5f                   	pop    %edi
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <devpipe_write>:
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	57                   	push   %edi
  801d13:	56                   	push   %esi
  801d14:	53                   	push   %ebx
  801d15:	83 ec 28             	sub    $0x28,%esp
  801d18:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d1b:	56                   	push   %esi
  801d1c:	e8 8e f2 ff ff       	call   800faf <fd2data>
  801d21:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d2e:	74 4f                	je     801d7f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d30:	8b 43 04             	mov    0x4(%ebx),%eax
  801d33:	8b 0b                	mov    (%ebx),%ecx
  801d35:	8d 51 20             	lea    0x20(%ecx),%edx
  801d38:	39 d0                	cmp    %edx,%eax
  801d3a:	72 14                	jb     801d50 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d3c:	89 da                	mov    %ebx,%edx
  801d3e:	89 f0                	mov    %esi,%eax
  801d40:	e8 65 ff ff ff       	call   801caa <_pipeisclosed>
  801d45:	85 c0                	test   %eax,%eax
  801d47:	75 3b                	jne    801d84 <devpipe_write+0x75>
			sys_yield();
  801d49:	e8 3d ef ff ff       	call   800c8b <sys_yield>
  801d4e:	eb e0                	jmp    801d30 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d53:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d57:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d5a:	89 c2                	mov    %eax,%edx
  801d5c:	c1 fa 1f             	sar    $0x1f,%edx
  801d5f:	89 d1                	mov    %edx,%ecx
  801d61:	c1 e9 1b             	shr    $0x1b,%ecx
  801d64:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d67:	83 e2 1f             	and    $0x1f,%edx
  801d6a:	29 ca                	sub    %ecx,%edx
  801d6c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d70:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d74:	83 c0 01             	add    $0x1,%eax
  801d77:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d7a:	83 c7 01             	add    $0x1,%edi
  801d7d:	eb ac                	jmp    801d2b <devpipe_write+0x1c>
	return i;
  801d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d82:	eb 05                	jmp    801d89 <devpipe_write+0x7a>
				return 0;
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5f                   	pop    %edi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    

00801d91 <devpipe_read>:
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	57                   	push   %edi
  801d95:	56                   	push   %esi
  801d96:	53                   	push   %ebx
  801d97:	83 ec 18             	sub    $0x18,%esp
  801d9a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d9d:	57                   	push   %edi
  801d9e:	e8 0c f2 ff ff       	call   800faf <fd2data>
  801da3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	be 00 00 00 00       	mov    $0x0,%esi
  801dad:	3b 75 10             	cmp    0x10(%ebp),%esi
  801db0:	75 14                	jne    801dc6 <devpipe_read+0x35>
	return i;
  801db2:	8b 45 10             	mov    0x10(%ebp),%eax
  801db5:	eb 02                	jmp    801db9 <devpipe_read+0x28>
				return i;
  801db7:	89 f0                	mov    %esi,%eax
}
  801db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbc:	5b                   	pop    %ebx
  801dbd:	5e                   	pop    %esi
  801dbe:	5f                   	pop    %edi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    
			sys_yield();
  801dc1:	e8 c5 ee ff ff       	call   800c8b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dc6:	8b 03                	mov    (%ebx),%eax
  801dc8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dcb:	75 18                	jne    801de5 <devpipe_read+0x54>
			if (i > 0)
  801dcd:	85 f6                	test   %esi,%esi
  801dcf:	75 e6                	jne    801db7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dd1:	89 da                	mov    %ebx,%edx
  801dd3:	89 f8                	mov    %edi,%eax
  801dd5:	e8 d0 fe ff ff       	call   801caa <_pipeisclosed>
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	74 e3                	je     801dc1 <devpipe_read+0x30>
				return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	eb d4                	jmp    801db9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801de5:	99                   	cltd   
  801de6:	c1 ea 1b             	shr    $0x1b,%edx
  801de9:	01 d0                	add    %edx,%eax
  801deb:	83 e0 1f             	and    $0x1f,%eax
  801dee:	29 d0                	sub    %edx,%eax
  801df0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dfb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dfe:	83 c6 01             	add    $0x1,%esi
  801e01:	eb aa                	jmp    801dad <devpipe_read+0x1c>

00801e03 <pipe>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0e:	50                   	push   %eax
  801e0f:	e8 b2 f1 ff ff       	call   800fc6 <fd_alloc>
  801e14:	89 c3                	mov    %eax,%ebx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	0f 88 23 01 00 00    	js     801f44 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	68 07 04 00 00       	push   $0x407
  801e29:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2c:	6a 00                	push   $0x0
  801e2e:	e8 77 ee ff ff       	call   800caa <sys_page_alloc>
  801e33:	89 c3                	mov    %eax,%ebx
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 04 01 00 00    	js     801f44 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e46:	50                   	push   %eax
  801e47:	e8 7a f1 ff ff       	call   800fc6 <fd_alloc>
  801e4c:	89 c3                	mov    %eax,%ebx
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	0f 88 db 00 00 00    	js     801f34 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 07 04 00 00       	push   $0x407
  801e61:	ff 75 f0             	pushl  -0x10(%ebp)
  801e64:	6a 00                	push   $0x0
  801e66:	e8 3f ee ff ff       	call   800caa <sys_page_alloc>
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	0f 88 bc 00 00 00    	js     801f34 <pipe+0x131>
	va = fd2data(fd0);
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7e:	e8 2c f1 ff ff       	call   800faf <fd2data>
  801e83:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e85:	83 c4 0c             	add    $0xc,%esp
  801e88:	68 07 04 00 00       	push   $0x407
  801e8d:	50                   	push   %eax
  801e8e:	6a 00                	push   $0x0
  801e90:	e8 15 ee ff ff       	call   800caa <sys_page_alloc>
  801e95:	89 c3                	mov    %eax,%ebx
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	0f 88 82 00 00 00    	js     801f24 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea8:	e8 02 f1 ff ff       	call   800faf <fd2data>
  801ead:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eb4:	50                   	push   %eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	56                   	push   %esi
  801eb8:	6a 00                	push   $0x0
  801eba:	e8 2e ee ff ff       	call   800ced <sys_page_map>
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	83 c4 20             	add    $0x20,%esp
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	78 4e                	js     801f16 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ec8:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801edf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef1:	e8 a9 f0 ff ff       	call   800f9f <fd2num>
  801ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801efb:	83 c4 04             	add    $0x4,%esp
  801efe:	ff 75 f0             	pushl  -0x10(%ebp)
  801f01:	e8 99 f0 ff ff       	call   800f9f <fd2num>
  801f06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f09:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f14:	eb 2e                	jmp    801f44 <pipe+0x141>
	sys_page_unmap(0, va);
  801f16:	83 ec 08             	sub    $0x8,%esp
  801f19:	56                   	push   %esi
  801f1a:	6a 00                	push   $0x0
  801f1c:	e8 0e ee ff ff       	call   800d2f <sys_page_unmap>
  801f21:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f24:	83 ec 08             	sub    $0x8,%esp
  801f27:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2a:	6a 00                	push   $0x0
  801f2c:	e8 fe ed ff ff       	call   800d2f <sys_page_unmap>
  801f31:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3a:	6a 00                	push   $0x0
  801f3c:	e8 ee ed ff ff       	call   800d2f <sys_page_unmap>
  801f41:	83 c4 10             	add    $0x10,%esp
}
  801f44:	89 d8                	mov    %ebx,%eax
  801f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f49:	5b                   	pop    %ebx
  801f4a:	5e                   	pop    %esi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <pipeisclosed>:
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f56:	50                   	push   %eax
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	e8 b9 f0 ff ff       	call   801018 <fd_lookup>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	78 18                	js     801f7e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6c:	e8 3e f0 ff ff       	call   800faf <fd2data>
	return _pipeisclosed(fd, p);
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	e8 2f fd ff ff       	call   801caa <_pipeisclosed>
  801f7b:	83 c4 10             	add    $0x10,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	c3                   	ret    

00801f86 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f8c:	68 ef 29 80 00       	push   $0x8029ef
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	e8 1f e9 ff ff       	call   8008b8 <strcpy>
	return 0;
}
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <devcons_write>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	57                   	push   %edi
  801fa4:	56                   	push   %esi
  801fa5:	53                   	push   %ebx
  801fa6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fac:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fb1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fb7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fba:	73 31                	jae    801fed <devcons_write+0x4d>
		m = n - tot;
  801fbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fbf:	29 f3                	sub    %esi,%ebx
  801fc1:	83 fb 7f             	cmp    $0x7f,%ebx
  801fc4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fc9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	53                   	push   %ebx
  801fd0:	89 f0                	mov    %esi,%eax
  801fd2:	03 45 0c             	add    0xc(%ebp),%eax
  801fd5:	50                   	push   %eax
  801fd6:	57                   	push   %edi
  801fd7:	e8 6a ea ff ff       	call   800a46 <memmove>
		sys_cputs(buf, m);
  801fdc:	83 c4 08             	add    $0x8,%esp
  801fdf:	53                   	push   %ebx
  801fe0:	57                   	push   %edi
  801fe1:	e8 08 ec ff ff       	call   800bee <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fe6:	01 de                	add    %ebx,%esi
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	eb ca                	jmp    801fb7 <devcons_write+0x17>
}
  801fed:	89 f0                	mov    %esi,%eax
  801fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff2:	5b                   	pop    %ebx
  801ff3:	5e                   	pop    %esi
  801ff4:	5f                   	pop    %edi
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    

00801ff7 <devcons_read>:
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802002:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802006:	74 21                	je     802029 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802008:	e8 ff eb ff ff       	call   800c0c <sys_cgetc>
  80200d:	85 c0                	test   %eax,%eax
  80200f:	75 07                	jne    802018 <devcons_read+0x21>
		sys_yield();
  802011:	e8 75 ec ff ff       	call   800c8b <sys_yield>
  802016:	eb f0                	jmp    802008 <devcons_read+0x11>
	if (c < 0)
  802018:	78 0f                	js     802029 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80201a:	83 f8 04             	cmp    $0x4,%eax
  80201d:	74 0c                	je     80202b <devcons_read+0x34>
	*(char*)vbuf = c;
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	88 02                	mov    %al,(%edx)
	return 1;
  802024:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    
		return 0;
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	eb f7                	jmp    802029 <devcons_read+0x32>

00802032 <cputchar>:
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80203e:	6a 01                	push   $0x1
  802040:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802043:	50                   	push   %eax
  802044:	e8 a5 eb ff ff       	call   800bee <sys_cputs>
}
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <getchar>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802054:	6a 01                	push   $0x1
  802056:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802059:	50                   	push   %eax
  80205a:	6a 00                	push   $0x0
  80205c:	e8 27 f2 ff ff       	call   801288 <read>
	if (r < 0)
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	78 06                	js     80206e <getchar+0x20>
	if (r < 1)
  802068:	74 06                	je     802070 <getchar+0x22>
	return c;
  80206a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    
		return -E_EOF;
  802070:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802075:	eb f7                	jmp    80206e <getchar+0x20>

00802077 <iscons>:
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802080:	50                   	push   %eax
  802081:	ff 75 08             	pushl  0x8(%ebp)
  802084:	e8 8f ef ff ff       	call   801018 <fd_lookup>
  802089:	83 c4 10             	add    $0x10,%esp
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 11                	js     8020a1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802099:	39 10                	cmp    %edx,(%eax)
  80209b:	0f 94 c0             	sete   %al
  80209e:	0f b6 c0             	movzbl %al,%eax
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <opencons>:
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ac:	50                   	push   %eax
  8020ad:	e8 14 ef ff ff       	call   800fc6 <fd_alloc>
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	78 3a                	js     8020f3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020b9:	83 ec 04             	sub    $0x4,%esp
  8020bc:	68 07 04 00 00       	push   $0x407
  8020c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c4:	6a 00                	push   $0x0
  8020c6:	e8 df eb ff ff       	call   800caa <sys_page_alloc>
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 21                	js     8020f3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020db:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020e7:	83 ec 0c             	sub    $0xc,%esp
  8020ea:	50                   	push   %eax
  8020eb:	e8 af ee ff ff       	call   800f9f <fd2num>
  8020f0:	83 c4 10             	add    $0x10,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	56                   	push   %esi
  8020f9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8020fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8020ff:	8b 40 48             	mov    0x48(%eax),%eax
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	68 20 2a 80 00       	push   $0x802a20
  80210a:	50                   	push   %eax
  80210b:	68 0a 25 80 00       	push   $0x80250a
  802110:	e8 44 e0 ff ff       	call   800159 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802115:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802118:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80211e:	e8 49 eb ff ff       	call   800c6c <sys_getenvid>
  802123:	83 c4 04             	add    $0x4,%esp
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	56                   	push   %esi
  80212d:	50                   	push   %eax
  80212e:	68 fc 29 80 00       	push   $0x8029fc
  802133:	e8 21 e0 ff ff       	call   800159 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802138:	83 c4 18             	add    $0x18,%esp
  80213b:	53                   	push   %ebx
  80213c:	ff 75 10             	pushl  0x10(%ebp)
  80213f:	e8 c4 df ff ff       	call   800108 <vcprintf>
	cprintf("\n");
  802144:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  80214b:	e8 09 e0 ff ff       	call   800159 <cprintf>
  802150:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802153:	cc                   	int3   
  802154:	eb fd                	jmp    802153 <_panic+0x5e>

00802156 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	56                   	push   %esi
  80215a:	53                   	push   %ebx
  80215b:	8b 75 08             	mov    0x8(%ebp),%esi
  80215e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802161:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802164:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802166:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80216b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	50                   	push   %eax
  802172:	e8 e3 ec ff ff       	call   800e5a <sys_ipc_recv>
	if(ret < 0){
  802177:	83 c4 10             	add    $0x10,%esp
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 2b                	js     8021a9 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80217e:	85 f6                	test   %esi,%esi
  802180:	74 0a                	je     80218c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802182:	a1 08 40 80 00       	mov    0x804008,%eax
  802187:	8b 40 78             	mov    0x78(%eax),%eax
  80218a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80218c:	85 db                	test   %ebx,%ebx
  80218e:	74 0a                	je     80219a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802190:	a1 08 40 80 00       	mov    0x804008,%eax
  802195:	8b 40 7c             	mov    0x7c(%eax),%eax
  802198:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80219a:	a1 08 40 80 00       	mov    0x804008,%eax
  80219f:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    
		if(from_env_store)
  8021a9:	85 f6                	test   %esi,%esi
  8021ab:	74 06                	je     8021b3 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021ad:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021b3:	85 db                	test   %ebx,%ebx
  8021b5:	74 eb                	je     8021a2 <ipc_recv+0x4c>
			*perm_store = 0;
  8021b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021bd:	eb e3                	jmp    8021a2 <ipc_recv+0x4c>

008021bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	57                   	push   %edi
  8021c3:	56                   	push   %esi
  8021c4:	53                   	push   %ebx
  8021c5:	83 ec 0c             	sub    $0xc,%esp
  8021c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021d1:	85 db                	test   %ebx,%ebx
  8021d3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021d8:	0f 44 d8             	cmove  %eax,%ebx
  8021db:	eb 05                	jmp    8021e2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021dd:	e8 a9 ea ff ff       	call   800c8b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021e2:	ff 75 14             	pushl  0x14(%ebp)
  8021e5:	53                   	push   %ebx
  8021e6:	56                   	push   %esi
  8021e7:	57                   	push   %edi
  8021e8:	e8 4a ec ff ff       	call   800e37 <sys_ipc_try_send>
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 1b                	je     80220f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021f4:	79 e7                	jns    8021dd <ipc_send+0x1e>
  8021f6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f9:	74 e2                	je     8021dd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	68 27 2a 80 00       	push   $0x802a27
  802203:	6a 46                	push   $0x46
  802205:	68 3c 2a 80 00       	push   $0x802a3c
  80220a:	e8 e6 fe ff ff       	call   8020f5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80220f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5f                   	pop    %edi
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    

00802217 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802222:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802228:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80222e:	8b 52 50             	mov    0x50(%edx),%edx
  802231:	39 ca                	cmp    %ecx,%edx
  802233:	74 11                	je     802246 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802235:	83 c0 01             	add    $0x1,%eax
  802238:	3d 00 04 00 00       	cmp    $0x400,%eax
  80223d:	75 e3                	jne    802222 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	eb 0e                	jmp    802254 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802246:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80224c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802251:	8b 40 48             	mov    0x48(%eax),%eax
}
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    

00802256 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80225c:	89 d0                	mov    %edx,%eax
  80225e:	c1 e8 16             	shr    $0x16,%eax
  802261:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80226d:	f6 c1 01             	test   $0x1,%cl
  802270:	74 1d                	je     80228f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802272:	c1 ea 0c             	shr    $0xc,%edx
  802275:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80227c:	f6 c2 01             	test   $0x1,%dl
  80227f:	74 0e                	je     80228f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802281:	c1 ea 0c             	shr    $0xc,%edx
  802284:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80228b:	ef 
  80228c:	0f b7 c0             	movzwl %ax,%eax
}
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    
  802291:	66 90                	xchg   %ax,%ax
  802293:	66 90                	xchg   %ax,%ax
  802295:	66 90                	xchg   %ax,%ax
  802297:	66 90                	xchg   %ax,%ax
  802299:	66 90                	xchg   %ax,%ax
  80229b:	66 90                	xchg   %ax,%ax
  80229d:	66 90                	xchg   %ax,%ax
  80229f:	90                   	nop

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
