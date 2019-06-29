
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 ac 0f 80 00       	push   $0x800fac
  80003e:	6a 00                	push   $0x0
  800040:	e8 bd 0d 00 00       	call   800e02 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80005f:	e8 15 0c 00 00       	call   800c79 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80006f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800074:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 db                	test   %ebx,%ebx
  80007b:	7e 07                	jle    800084 <libmain+0x30>
		binaryname = argv[0];
  80007d:	8b 06                	mov    (%esi),%eax
  80007f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	56                   	push   %esi
  800088:	53                   	push   %ebx
  800089:	e8 a5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008e:	e8 0a 00 00 00       	call   80009d <exit>
}
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800099:	5b                   	pop    %ebx
  80009a:	5e                   	pop    %esi
  80009b:	5d                   	pop    %ebp
  80009c:	c3                   	ret    

0080009d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a8:	8b 40 48             	mov    0x48(%eax),%eax
  8000ab:	68 b8 25 80 00       	push   $0x8025b8
  8000b0:	50                   	push   %eax
  8000b1:	68 aa 25 80 00       	push   $0x8025aa
  8000b6:	e8 ab 00 00 00       	call   800166 <cprintf>
	close_all();
  8000bb:	e8 ea 10 00 00       	call   8011aa <close_all>
	sys_env_destroy(0);
  8000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c7:	e8 6c 0b 00 00       	call   800c38 <sys_env_destroy>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 04             	sub    $0x4,%esp
  8000d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000db:	8b 13                	mov    (%ebx),%edx
  8000dd:	8d 42 01             	lea    0x1(%edx),%eax
  8000e0:	89 03                	mov    %eax,(%ebx)
  8000e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ee:	74 09                	je     8000f9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000f0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f7:	c9                   	leave  
  8000f8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	68 ff 00 00 00       	push   $0xff
  800101:	8d 43 08             	lea    0x8(%ebx),%eax
  800104:	50                   	push   %eax
  800105:	e8 f1 0a 00 00       	call   800bfb <sys_cputs>
		b->idx = 0;
  80010a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	eb db                	jmp    8000f0 <putch+0x1f>

00800115 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800125:	00 00 00 
	b.cnt = 0;
  800128:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80012f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800132:	ff 75 0c             	pushl  0xc(%ebp)
  800135:	ff 75 08             	pushl  0x8(%ebp)
  800138:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013e:	50                   	push   %eax
  80013f:	68 d1 00 80 00       	push   $0x8000d1
  800144:	e8 4a 01 00 00       	call   800293 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800149:	83 c4 08             	add    $0x8,%esp
  80014c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800152:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800158:	50                   	push   %eax
  800159:	e8 9d 0a 00 00       	call   800bfb <sys_cputs>

	return b.cnt;
}
  80015e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016f:	50                   	push   %eax
  800170:	ff 75 08             	pushl  0x8(%ebp)
  800173:	e8 9d ff ff ff       	call   800115 <vcprintf>
	va_end(ap);

	return cnt;
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	57                   	push   %edi
  80017e:	56                   	push   %esi
  80017f:	53                   	push   %ebx
  800180:	83 ec 1c             	sub    $0x1c,%esp
  800183:	89 c6                	mov    %eax,%esi
  800185:	89 d7                	mov    %edx,%edi
  800187:	8b 45 08             	mov    0x8(%ebp),%eax
  80018a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800190:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800193:	8b 45 10             	mov    0x10(%ebp),%eax
  800196:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800199:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80019d:	74 2c                	je     8001cb <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80019f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001af:	39 c2                	cmp    %eax,%edx
  8001b1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001b4:	73 43                	jae    8001f9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001b6:	83 eb 01             	sub    $0x1,%ebx
  8001b9:	85 db                	test   %ebx,%ebx
  8001bb:	7e 6c                	jle    800229 <printnum+0xaf>
				putch(padc, putdat);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	57                   	push   %edi
  8001c1:	ff 75 18             	pushl  0x18(%ebp)
  8001c4:	ff d6                	call   *%esi
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	eb eb                	jmp    8001b6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	6a 20                	push   $0x20
  8001d0:	6a 00                	push   $0x0
  8001d2:	50                   	push   %eax
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d9:	89 fa                	mov    %edi,%edx
  8001db:	89 f0                	mov    %esi,%eax
  8001dd:	e8 98 ff ff ff       	call   80017a <printnum>
		while (--width > 0)
  8001e2:	83 c4 20             	add    $0x20,%esp
  8001e5:	83 eb 01             	sub    $0x1,%ebx
  8001e8:	85 db                	test   %ebx,%ebx
  8001ea:	7e 65                	jle    800251 <printnum+0xd7>
			putch(padc, putdat);
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	57                   	push   %edi
  8001f0:	6a 20                	push   $0x20
  8001f2:	ff d6                	call   *%esi
  8001f4:	83 c4 10             	add    $0x10,%esp
  8001f7:	eb ec                	jmp    8001e5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	pushl  0x18(%ebp)
  8001ff:	83 eb 01             	sub    $0x1,%ebx
  800202:	53                   	push   %ebx
  800203:	50                   	push   %eax
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800210:	ff 75 e0             	pushl  -0x20(%ebp)
  800213:	e8 28 21 00 00       	call   802340 <__udivdi3>
  800218:	83 c4 18             	add    $0x18,%esp
  80021b:	52                   	push   %edx
  80021c:	50                   	push   %eax
  80021d:	89 fa                	mov    %edi,%edx
  80021f:	89 f0                	mov    %esi,%eax
  800221:	e8 54 ff ff ff       	call   80017a <printnum>
  800226:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	57                   	push   %edi
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	ff 75 dc             	pushl  -0x24(%ebp)
  800233:	ff 75 d8             	pushl  -0x28(%ebp)
  800236:	ff 75 e4             	pushl  -0x1c(%ebp)
  800239:	ff 75 e0             	pushl  -0x20(%ebp)
  80023c:	e8 0f 22 00 00       	call   802450 <__umoddi3>
  800241:	83 c4 14             	add    $0x14,%esp
  800244:	0f be 80 bd 25 80 00 	movsbl 0x8025bd(%eax),%eax
  80024b:	50                   	push   %eax
  80024c:	ff d6                	call   *%esi
  80024e:	83 c4 10             	add    $0x10,%esp
	}
}
  800251:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800254:	5b                   	pop    %ebx
  800255:	5e                   	pop    %esi
  800256:	5f                   	pop    %edi
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800263:	8b 10                	mov    (%eax),%edx
  800265:	3b 50 04             	cmp    0x4(%eax),%edx
  800268:	73 0a                	jae    800274 <sprintputch+0x1b>
		*b->buf++ = ch;
  80026a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	88 02                	mov    %al,(%edx)
}
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    

00800276 <printfmt>:
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027f:	50                   	push   %eax
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 05 00 00 00       	call   800293 <vprintfmt>
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <vprintfmt>:
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 3c             	sub    $0x3c,%esp
  80029c:	8b 75 08             	mov    0x8(%ebp),%esi
  80029f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a5:	e9 32 04 00 00       	jmp    8006dc <vprintfmt+0x449>
		padc = ' ';
  8002aa:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002ae:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002b5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ca:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002d1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d6:	8d 47 01             	lea    0x1(%edi),%eax
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	0f b6 17             	movzbl (%edi),%edx
  8002df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e2:	3c 55                	cmp    $0x55,%al
  8002e4:	0f 87 12 05 00 00    	ja     8007fc <vprintfmt+0x569>
  8002ea:	0f b6 c0             	movzbl %al,%eax
  8002ed:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002fb:	eb d9                	jmp    8002d6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800300:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800304:	eb d0                	jmp    8002d6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800306:	0f b6 d2             	movzbl %dl,%edx
  800309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	89 75 08             	mov    %esi,0x8(%ebp)
  800314:	eb 03                	jmp    800319 <vprintfmt+0x86>
  800316:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800319:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800320:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800323:	8d 72 d0             	lea    -0x30(%edx),%esi
  800326:	83 fe 09             	cmp    $0x9,%esi
  800329:	76 eb                	jbe    800316 <vprintfmt+0x83>
  80032b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032e:	8b 75 08             	mov    0x8(%ebp),%esi
  800331:	eb 14                	jmp    800347 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800333:	8b 45 14             	mov    0x14(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033b:	8b 45 14             	mov    0x14(%ebp),%eax
  80033e:	8d 40 04             	lea    0x4(%eax),%eax
  800341:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800347:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034b:	79 89                	jns    8002d6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80034d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800350:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800353:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035a:	e9 77 ff ff ff       	jmp    8002d6 <vprintfmt+0x43>
  80035f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800362:	85 c0                	test   %eax,%eax
  800364:	0f 48 c1             	cmovs  %ecx,%eax
  800367:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	e9 64 ff ff ff       	jmp    8002d6 <vprintfmt+0x43>
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800375:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80037c:	e9 55 ff ff ff       	jmp    8002d6 <vprintfmt+0x43>
			lflag++;
  800381:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800388:	e9 49 ff ff ff       	jmp    8002d6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8d 78 04             	lea    0x4(%eax),%edi
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	53                   	push   %ebx
  800397:	ff 30                	pushl  (%eax)
  800399:	ff d6                	call   *%esi
			break;
  80039b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80039e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a1:	e9 33 03 00 00       	jmp    8006d9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 78 04             	lea    0x4(%eax),%edi
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	99                   	cltd   
  8003af:	31 d0                	xor    %edx,%eax
  8003b1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b3:	83 f8 11             	cmp    $0x11,%eax
  8003b6:	7f 23                	jg     8003db <vprintfmt+0x148>
  8003b8:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  8003bf:	85 d2                	test   %edx,%edx
  8003c1:	74 18                	je     8003db <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003c3:	52                   	push   %edx
  8003c4:	68 1d 2a 80 00       	push   $0x802a1d
  8003c9:	53                   	push   %ebx
  8003ca:	56                   	push   %esi
  8003cb:	e8 a6 fe ff ff       	call   800276 <printfmt>
  8003d0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d6:	e9 fe 02 00 00       	jmp    8006d9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003db:	50                   	push   %eax
  8003dc:	68 d5 25 80 00       	push   $0x8025d5
  8003e1:	53                   	push   %ebx
  8003e2:	56                   	push   %esi
  8003e3:	e8 8e fe ff ff       	call   800276 <printfmt>
  8003e8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ee:	e9 e6 02 00 00       	jmp    8006d9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	83 c0 04             	add    $0x4,%eax
  8003f9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800401:	85 c9                	test   %ecx,%ecx
  800403:	b8 ce 25 80 00       	mov    $0x8025ce,%eax
  800408:	0f 45 c1             	cmovne %ecx,%eax
  80040b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80040e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800412:	7e 06                	jle    80041a <vprintfmt+0x187>
  800414:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800418:	75 0d                	jne    800427 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80041a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80041d:	89 c7                	mov    %eax,%edi
  80041f:	03 45 e0             	add    -0x20(%ebp),%eax
  800422:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800425:	eb 53                	jmp    80047a <vprintfmt+0x1e7>
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	ff 75 d8             	pushl  -0x28(%ebp)
  80042d:	50                   	push   %eax
  80042e:	e8 71 04 00 00       	call   8008a4 <strnlen>
  800433:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800436:	29 c1                	sub    %eax,%ecx
  800438:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800440:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800444:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800447:	eb 0f                	jmp    800458 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	53                   	push   %ebx
  80044d:	ff 75 e0             	pushl  -0x20(%ebp)
  800450:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800452:	83 ef 01             	sub    $0x1,%edi
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	85 ff                	test   %edi,%edi
  80045a:	7f ed                	jg     800449 <vprintfmt+0x1b6>
  80045c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80045f:	85 c9                	test   %ecx,%ecx
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
  800466:	0f 49 c1             	cmovns %ecx,%eax
  800469:	29 c1                	sub    %eax,%ecx
  80046b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80046e:	eb aa                	jmp    80041a <vprintfmt+0x187>
					putch(ch, putdat);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	52                   	push   %edx
  800475:	ff d6                	call   *%esi
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047f:	83 c7 01             	add    $0x1,%edi
  800482:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800486:	0f be d0             	movsbl %al,%edx
  800489:	85 d2                	test   %edx,%edx
  80048b:	74 4b                	je     8004d8 <vprintfmt+0x245>
  80048d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800491:	78 06                	js     800499 <vprintfmt+0x206>
  800493:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800497:	78 1e                	js     8004b7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800499:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80049d:	74 d1                	je     800470 <vprintfmt+0x1dd>
  80049f:	0f be c0             	movsbl %al,%eax
  8004a2:	83 e8 20             	sub    $0x20,%eax
  8004a5:	83 f8 5e             	cmp    $0x5e,%eax
  8004a8:	76 c6                	jbe    800470 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	53                   	push   %ebx
  8004ae:	6a 3f                	push   $0x3f
  8004b0:	ff d6                	call   *%esi
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	eb c3                	jmp    80047a <vprintfmt+0x1e7>
  8004b7:	89 cf                	mov    %ecx,%edi
  8004b9:	eb 0e                	jmp    8004c9 <vprintfmt+0x236>
				putch(' ', putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	6a 20                	push   $0x20
  8004c1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c3:	83 ef 01             	sub    $0x1,%edi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	7f ee                	jg     8004bb <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d3:	e9 01 02 00 00       	jmp    8006d9 <vprintfmt+0x446>
  8004d8:	89 cf                	mov    %ecx,%edi
  8004da:	eb ed                	jmp    8004c9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004df:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004e6:	e9 eb fd ff ff       	jmp    8002d6 <vprintfmt+0x43>
	if (lflag >= 2)
  8004eb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004ef:	7f 21                	jg     800512 <vprintfmt+0x27f>
	else if (lflag)
  8004f1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004f5:	74 68                	je     80055f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ff:	89 c1                	mov    %eax,%ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 40 04             	lea    0x4(%eax),%eax
  80050d:	89 45 14             	mov    %eax,0x14(%ebp)
  800510:	eb 17                	jmp    800529 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80051d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 40 08             	lea    0x8(%eax),%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800529:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800535:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800539:	78 3f                	js     80057a <vprintfmt+0x2e7>
			base = 10;
  80053b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800540:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800544:	0f 84 71 01 00 00    	je     8006bb <vprintfmt+0x428>
				putch('+', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 2b                	push   $0x2b
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055a:	e9 5c 01 00 00       	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800567:	89 c1                	mov    %eax,%ecx
  800569:	c1 f9 1f             	sar    $0x1f,%ecx
  80056c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	eb af                	jmp    800529 <vprintfmt+0x296>
				putch('-', putdat);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	6a 2d                	push   $0x2d
  800580:	ff d6                	call   *%esi
				num = -(long long) num;
  800582:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800585:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800588:	f7 d8                	neg    %eax
  80058a:	83 d2 00             	adc    $0x0,%edx
  80058d:	f7 da                	neg    %edx
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800598:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059d:	e9 19 01 00 00       	jmp    8006bb <vprintfmt+0x428>
	if (lflag >= 2)
  8005a2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005a6:	7f 29                	jg     8005d1 <vprintfmt+0x33e>
	else if (lflag)
  8005a8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005ac:	74 44                	je     8005f2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cc:	e9 ea 00 00 00       	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 50 04             	mov    0x4(%eax),%edx
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 08             	lea    0x8(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ed:	e9 c9 00 00 00       	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 a6 00 00 00       	jmp    8006bb <vprintfmt+0x428>
			putch('0', putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	6a 30                	push   $0x30
  80061b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800624:	7f 26                	jg     80064c <vprintfmt+0x3b9>
	else if (lflag)
  800626:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80062a:	74 3e                	je     80066a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	ba 00 00 00 00       	mov    $0x0,%edx
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8d 40 04             	lea    0x4(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800645:	b8 08 00 00 00       	mov    $0x8,%eax
  80064a:	eb 6f                	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 50 04             	mov    0x4(%eax),%edx
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800657:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 40 08             	lea    0x8(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800663:	b8 08 00 00 00       	mov    $0x8,%eax
  800668:	eb 51                	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800683:	b8 08 00 00 00       	mov    $0x8,%eax
  800688:	eb 31                	jmp    8006bb <vprintfmt+0x428>
			putch('0', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 30                	push   $0x30
  800690:	ff d6                	call   *%esi
			putch('x', putdat);
  800692:	83 c4 08             	add    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 78                	push   $0x78
  800698:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006aa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006c2:	52                   	push   %edx
  8006c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c6:	50                   	push   %eax
  8006c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8006cd:	89 da                	mov    %ebx,%edx
  8006cf:	89 f0                	mov    %esi,%eax
  8006d1:	e8 a4 fa ff ff       	call   80017a <printnum>
			break;
  8006d6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006dc:	83 c7 01             	add    $0x1,%edi
  8006df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e3:	83 f8 25             	cmp    $0x25,%eax
  8006e6:	0f 84 be fb ff ff    	je     8002aa <vprintfmt+0x17>
			if (ch == '\0')
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	0f 84 28 01 00 00    	je     80081c <vprintfmt+0x589>
			putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	50                   	push   %eax
  8006f9:	ff d6                	call   *%esi
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	eb dc                	jmp    8006dc <vprintfmt+0x449>
	if (lflag >= 2)
  800700:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800704:	7f 26                	jg     80072c <vprintfmt+0x499>
	else if (lflag)
  800706:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80070a:	74 41                	je     80074d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
  80072a:	eb 8f                	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 50 04             	mov    0x4(%eax),%edx
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 08             	lea    0x8(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	b8 10 00 00 00       	mov    $0x10,%eax
  800748:	e9 6e ff ff ff       	jmp    8006bb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 04             	lea    0x4(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800766:	b8 10 00 00 00       	mov    $0x10,%eax
  80076b:	e9 4b ff ff ff       	jmp    8006bb <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	85 c0                	test   %eax,%eax
  800780:	74 14                	je     800796 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800782:	8b 13                	mov    (%ebx),%edx
  800784:	83 fa 7f             	cmp    $0x7f,%edx
  800787:	7f 37                	jg     8007c0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800789:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80078b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
  800791:	e9 43 ff ff ff       	jmp    8006d9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800796:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079b:	bf f1 26 80 00       	mov    $0x8026f1,%edi
							putch(ch, putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	50                   	push   %eax
  8007a5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007a7:	83 c7 01             	add    $0x1,%edi
  8007aa:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	75 eb                	jne    8007a0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	e9 19 ff ff ff       	jmp    8006d9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007c0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c7:	bf 29 27 80 00       	mov    $0x802729,%edi
							putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	50                   	push   %eax
  8007d1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007d3:	83 c7 01             	add    $0x1,%edi
  8007d6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 eb                	jne    8007cc <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	e9 ed fe ff ff       	jmp    8006d9 <vprintfmt+0x446>
			putch(ch, putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	6a 25                	push   $0x25
  8007f2:	ff d6                	call   *%esi
			break;
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	e9 dd fe ff ff       	jmp    8006d9 <vprintfmt+0x446>
			putch('%', putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	53                   	push   %ebx
  800800:	6a 25                	push   $0x25
  800802:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	89 f8                	mov    %edi,%eax
  800809:	eb 03                	jmp    80080e <vprintfmt+0x57b>
  80080b:	83 e8 01             	sub    $0x1,%eax
  80080e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800812:	75 f7                	jne    80080b <vprintfmt+0x578>
  800814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800817:	e9 bd fe ff ff       	jmp    8006d9 <vprintfmt+0x446>
}
  80081c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80081f:	5b                   	pop    %ebx
  800820:	5e                   	pop    %esi
  800821:	5f                   	pop    %edi
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	83 ec 18             	sub    $0x18,%esp
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800830:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800833:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800837:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80083a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800841:	85 c0                	test   %eax,%eax
  800843:	74 26                	je     80086b <vsnprintf+0x47>
  800845:	85 d2                	test   %edx,%edx
  800847:	7e 22                	jle    80086b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800849:	ff 75 14             	pushl  0x14(%ebp)
  80084c:	ff 75 10             	pushl  0x10(%ebp)
  80084f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	68 59 02 80 00       	push   $0x800259
  800858:	e8 36 fa ff ff       	call   800293 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80085d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800860:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	c9                   	leave  
  80086a:	c3                   	ret    
		return -E_INVAL;
  80086b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800870:	eb f7                	jmp    800869 <vsnprintf+0x45>

00800872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800878:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80087b:	50                   	push   %eax
  80087c:	ff 75 10             	pushl  0x10(%ebp)
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	e8 9a ff ff ff       	call   800824 <vsnprintf>
	va_end(ap);

	return rc;
}
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
  800897:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80089b:	74 05                	je     8008a2 <strlen+0x16>
		n++;
  80089d:	83 c0 01             	add    $0x1,%eax
  8008a0:	eb f5                	jmp    800897 <strlen+0xb>
	return n;
}
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	39 c2                	cmp    %eax,%edx
  8008b4:	74 0d                	je     8008c3 <strnlen+0x1f>
  8008b6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ba:	74 05                	je     8008c1 <strnlen+0x1d>
		n++;
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	eb f1                	jmp    8008b2 <strnlen+0xe>
  8008c1:	89 d0                	mov    %edx,%eax
	return n;
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	53                   	push   %ebx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008d8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	84 c9                	test   %cl,%cl
  8008e0:	75 f2                	jne    8008d4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008e2:	5b                   	pop    %ebx
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	53                   	push   %ebx
  8008e9:	83 ec 10             	sub    $0x10,%esp
  8008ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008ef:	53                   	push   %ebx
  8008f0:	e8 97 ff ff ff       	call   80088c <strlen>
  8008f5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	01 d8                	add    %ebx,%eax
  8008fd:	50                   	push   %eax
  8008fe:	e8 c2 ff ff ff       	call   8008c5 <strcpy>
	return dst;
}
  800903:	89 d8                	mov    %ebx,%eax
  800905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	56                   	push   %esi
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800915:	89 c6                	mov    %eax,%esi
  800917:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	39 f2                	cmp    %esi,%edx
  80091e:	74 11                	je     800931 <strncpy+0x27>
		*dst++ = *src;
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	0f b6 19             	movzbl (%ecx),%ebx
  800926:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800929:	80 fb 01             	cmp    $0x1,%bl
  80092c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80092f:	eb eb                	jmp    80091c <strncpy+0x12>
	}
	return ret;
}
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 75 08             	mov    0x8(%ebp),%esi
  80093d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800940:	8b 55 10             	mov    0x10(%ebp),%edx
  800943:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800945:	85 d2                	test   %edx,%edx
  800947:	74 21                	je     80096a <strlcpy+0x35>
  800949:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80094d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80094f:	39 c2                	cmp    %eax,%edx
  800951:	74 14                	je     800967 <strlcpy+0x32>
  800953:	0f b6 19             	movzbl (%ecx),%ebx
  800956:	84 db                	test   %bl,%bl
  800958:	74 0b                	je     800965 <strlcpy+0x30>
			*dst++ = *src++;
  80095a:	83 c1 01             	add    $0x1,%ecx
  80095d:	83 c2 01             	add    $0x1,%edx
  800960:	88 5a ff             	mov    %bl,-0x1(%edx)
  800963:	eb ea                	jmp    80094f <strlcpy+0x1a>
  800965:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800967:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80096a:	29 f0                	sub    %esi,%eax
}
  80096c:	5b                   	pop    %ebx
  80096d:	5e                   	pop    %esi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800979:	0f b6 01             	movzbl (%ecx),%eax
  80097c:	84 c0                	test   %al,%al
  80097e:	74 0c                	je     80098c <strcmp+0x1c>
  800980:	3a 02                	cmp    (%edx),%al
  800982:	75 08                	jne    80098c <strcmp+0x1c>
		p++, q++;
  800984:	83 c1 01             	add    $0x1,%ecx
  800987:	83 c2 01             	add    $0x1,%edx
  80098a:	eb ed                	jmp    800979 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098c:	0f b6 c0             	movzbl %al,%eax
  80098f:	0f b6 12             	movzbl (%edx),%edx
  800992:	29 d0                	sub    %edx,%eax
}
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	53                   	push   %ebx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a0:	89 c3                	mov    %eax,%ebx
  8009a2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strncmp+0x17>
		n--, p++, q++;
  8009a7:	83 c0 01             	add    $0x1,%eax
  8009aa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ad:	39 d8                	cmp    %ebx,%eax
  8009af:	74 16                	je     8009c7 <strncmp+0x31>
  8009b1:	0f b6 08             	movzbl (%eax),%ecx
  8009b4:	84 c9                	test   %cl,%cl
  8009b6:	74 04                	je     8009bc <strncmp+0x26>
  8009b8:	3a 0a                	cmp    (%edx),%cl
  8009ba:	74 eb                	je     8009a7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bc:	0f b6 00             	movzbl (%eax),%eax
  8009bf:	0f b6 12             	movzbl (%edx),%edx
  8009c2:	29 d0                	sub    %edx,%eax
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    
		return 0;
  8009c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cc:	eb f6                	jmp    8009c4 <strncmp+0x2e>

008009ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d8:	0f b6 10             	movzbl (%eax),%edx
  8009db:	84 d2                	test   %dl,%dl
  8009dd:	74 09                	je     8009e8 <strchr+0x1a>
		if (*s == c)
  8009df:	38 ca                	cmp    %cl,%dl
  8009e1:	74 0a                	je     8009ed <strchr+0x1f>
	for (; *s; s++)
  8009e3:	83 c0 01             	add    $0x1,%eax
  8009e6:	eb f0                	jmp    8009d8 <strchr+0xa>
			return (char *) s;
	return 0;
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009fc:	38 ca                	cmp    %cl,%dl
  8009fe:	74 09                	je     800a09 <strfind+0x1a>
  800a00:	84 d2                	test   %dl,%dl
  800a02:	74 05                	je     800a09 <strfind+0x1a>
	for (; *s; s++)
  800a04:	83 c0 01             	add    $0x1,%eax
  800a07:	eb f0                	jmp    8009f9 <strfind+0xa>
			break;
	return (char *) s;
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	57                   	push   %edi
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a17:	85 c9                	test   %ecx,%ecx
  800a19:	74 31                	je     800a4c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a1b:	89 f8                	mov    %edi,%eax
  800a1d:	09 c8                	or     %ecx,%eax
  800a1f:	a8 03                	test   $0x3,%al
  800a21:	75 23                	jne    800a46 <memset+0x3b>
		c &= 0xFF;
  800a23:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a27:	89 d3                	mov    %edx,%ebx
  800a29:	c1 e3 08             	shl    $0x8,%ebx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	c1 e0 18             	shl    $0x18,%eax
  800a31:	89 d6                	mov    %edx,%esi
  800a33:	c1 e6 10             	shl    $0x10,%esi
  800a36:	09 f0                	or     %esi,%eax
  800a38:	09 c2                	or     %eax,%edx
  800a3a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a3c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a3f:	89 d0                	mov    %edx,%eax
  800a41:	fc                   	cld    
  800a42:	f3 ab                	rep stos %eax,%es:(%edi)
  800a44:	eb 06                	jmp    800a4c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	fc                   	cld    
  800a4a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4c:	89 f8                	mov    %edi,%eax
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5f                   	pop    %edi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	57                   	push   %edi
  800a57:	56                   	push   %esi
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a61:	39 c6                	cmp    %eax,%esi
  800a63:	73 32                	jae    800a97 <memmove+0x44>
  800a65:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	76 2b                	jbe    800a97 <memmove+0x44>
		s += n;
		d += n;
  800a6c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6f:	89 fe                	mov    %edi,%esi
  800a71:	09 ce                	or     %ecx,%esi
  800a73:	09 d6                	or     %edx,%esi
  800a75:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a7b:	75 0e                	jne    800a8b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a7d:	83 ef 04             	sub    $0x4,%edi
  800a80:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a86:	fd                   	std    
  800a87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a89:	eb 09                	jmp    800a94 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a8b:	83 ef 01             	sub    $0x1,%edi
  800a8e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a91:	fd                   	std    
  800a92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a94:	fc                   	cld    
  800a95:	eb 1a                	jmp    800ab1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a97:	89 c2                	mov    %eax,%edx
  800a99:	09 ca                	or     %ecx,%edx
  800a9b:	09 f2                	or     %esi,%edx
  800a9d:	f6 c2 03             	test   $0x3,%dl
  800aa0:	75 0a                	jne    800aac <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	fc                   	cld    
  800aa8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aaa:	eb 05                	jmp    800ab1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aac:	89 c7                	mov    %eax,%edi
  800aae:	fc                   	cld    
  800aaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800abb:	ff 75 10             	pushl  0x10(%ebp)
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 8a ff ff ff       	call   800a53 <memmove>
}
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    

00800acb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	56                   	push   %esi
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad6:	89 c6                	mov    %eax,%esi
  800ad8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800adb:	39 f0                	cmp    %esi,%eax
  800add:	74 1c                	je     800afb <memcmp+0x30>
		if (*s1 != *s2)
  800adf:	0f b6 08             	movzbl (%eax),%ecx
  800ae2:	0f b6 1a             	movzbl (%edx),%ebx
  800ae5:	38 d9                	cmp    %bl,%cl
  800ae7:	75 08                	jne    800af1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae9:	83 c0 01             	add    $0x1,%eax
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	eb ea                	jmp    800adb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800af1:	0f b6 c1             	movzbl %cl,%eax
  800af4:	0f b6 db             	movzbl %bl,%ebx
  800af7:	29 d8                	sub    %ebx,%eax
  800af9:	eb 05                	jmp    800b00 <memcmp+0x35>
	}

	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b12:	39 d0                	cmp    %edx,%eax
  800b14:	73 09                	jae    800b1f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b16:	38 08                	cmp    %cl,(%eax)
  800b18:	74 05                	je     800b1f <memfind+0x1b>
	for (; s < ends; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	eb f3                	jmp    800b12 <memfind+0xe>
			break;
	return (void *) s;
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	57                   	push   %edi
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
  800b27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b2d:	eb 03                	jmp    800b32 <strtol+0x11>
		s++;
  800b2f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b32:	0f b6 01             	movzbl (%ecx),%eax
  800b35:	3c 20                	cmp    $0x20,%al
  800b37:	74 f6                	je     800b2f <strtol+0xe>
  800b39:	3c 09                	cmp    $0x9,%al
  800b3b:	74 f2                	je     800b2f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b3d:	3c 2b                	cmp    $0x2b,%al
  800b3f:	74 2a                	je     800b6b <strtol+0x4a>
	int neg = 0;
  800b41:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b46:	3c 2d                	cmp    $0x2d,%al
  800b48:	74 2b                	je     800b75 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b50:	75 0f                	jne    800b61 <strtol+0x40>
  800b52:	80 39 30             	cmpb   $0x30,(%ecx)
  800b55:	74 28                	je     800b7f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b57:	85 db                	test   %ebx,%ebx
  800b59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b5e:	0f 44 d8             	cmove  %eax,%ebx
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b69:	eb 50                	jmp    800bbb <strtol+0x9a>
		s++;
  800b6b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b6e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b73:	eb d5                	jmp    800b4a <strtol+0x29>
		s++, neg = 1;
  800b75:	83 c1 01             	add    $0x1,%ecx
  800b78:	bf 01 00 00 00       	mov    $0x1,%edi
  800b7d:	eb cb                	jmp    800b4a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b83:	74 0e                	je     800b93 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	75 d8                	jne    800b61 <strtol+0x40>
		s++, base = 8;
  800b89:	83 c1 01             	add    $0x1,%ecx
  800b8c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b91:	eb ce                	jmp    800b61 <strtol+0x40>
		s += 2, base = 16;
  800b93:	83 c1 02             	add    $0x2,%ecx
  800b96:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b9b:	eb c4                	jmp    800b61 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b9d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ba0:	89 f3                	mov    %esi,%ebx
  800ba2:	80 fb 19             	cmp    $0x19,%bl
  800ba5:	77 29                	ja     800bd0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ba7:	0f be d2             	movsbl %dl,%edx
  800baa:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bad:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bb0:	7d 30                	jge    800be2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bb2:	83 c1 01             	add    $0x1,%ecx
  800bb5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bbb:	0f b6 11             	movzbl (%ecx),%edx
  800bbe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bc1:	89 f3                	mov    %esi,%ebx
  800bc3:	80 fb 09             	cmp    $0x9,%bl
  800bc6:	77 d5                	ja     800b9d <strtol+0x7c>
			dig = *s - '0';
  800bc8:	0f be d2             	movsbl %dl,%edx
  800bcb:	83 ea 30             	sub    $0x30,%edx
  800bce:	eb dd                	jmp    800bad <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bd0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd3:	89 f3                	mov    %esi,%ebx
  800bd5:	80 fb 19             	cmp    $0x19,%bl
  800bd8:	77 08                	ja     800be2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bda:	0f be d2             	movsbl %dl,%edx
  800bdd:	83 ea 37             	sub    $0x37,%edx
  800be0:	eb cb                	jmp    800bad <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 05                	je     800bed <strtol+0xcc>
		*endptr = (char *) s;
  800be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800beb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bed:	89 c2                	mov    %eax,%edx
  800bef:	f7 da                	neg    %edx
  800bf1:	85 ff                	test   %edi,%edi
  800bf3:	0f 45 c2             	cmovne %edx,%eax
}
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0c:	89 c3                	mov    %eax,%ebx
  800c0e:	89 c7                	mov    %eax,%edi
  800c10:	89 c6                	mov    %eax,%esi
  800c12:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	b8 01 00 00 00       	mov    $0x1,%eax
  800c29:	89 d1                	mov    %edx,%ecx
  800c2b:	89 d3                	mov    %edx,%ebx
  800c2d:	89 d7                	mov    %edx,%edi
  800c2f:	89 d6                	mov    %edx,%esi
  800c31:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	57                   	push   %edi
  800c3c:	56                   	push   %esi
  800c3d:	53                   	push   %ebx
  800c3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4e:	89 cb                	mov    %ecx,%ebx
  800c50:	89 cf                	mov    %ecx,%edi
  800c52:	89 ce                	mov    %ecx,%esi
  800c54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7f 08                	jg     800c62 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	50                   	push   %eax
  800c66:	6a 03                	push   $0x3
  800c68:	68 48 29 80 00       	push   $0x802948
  800c6d:	6a 43                	push   $0x43
  800c6f:	68 65 29 80 00       	push   $0x802965
  800c74:	e8 af 14 00 00       	call   802128 <_panic>

00800c79 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c84:	b8 02 00 00 00       	mov    $0x2,%eax
  800c89:	89 d1                	mov    %edx,%ecx
  800c8b:	89 d3                	mov    %edx,%ebx
  800c8d:	89 d7                	mov    %edx,%edi
  800c8f:	89 d6                	mov    %edx,%esi
  800c91:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <sys_yield>:

void
sys_yield(void)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca8:	89 d1                	mov    %edx,%ecx
  800caa:	89 d3                	mov    %edx,%ebx
  800cac:	89 d7                	mov    %edx,%edi
  800cae:	89 d6                	mov    %edx,%esi
  800cb0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
  800cbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc0:	be 00 00 00 00       	mov    $0x0,%esi
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd3:	89 f7                	mov    %esi,%edi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 04                	push   $0x4
  800ce9:	68 48 29 80 00       	push   $0x802948
  800cee:	6a 43                	push   $0x43
  800cf0:	68 65 29 80 00       	push   $0x802965
  800cf5:	e8 2e 14 00 00       	call   802128 <_panic>

00800cfa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	b8 05 00 00 00       	mov    $0x5,%eax
  800d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d11:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d14:	8b 75 18             	mov    0x18(%ebp),%esi
  800d17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7f 08                	jg     800d25 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d25:	83 ec 0c             	sub    $0xc,%esp
  800d28:	50                   	push   %eax
  800d29:	6a 05                	push   $0x5
  800d2b:	68 48 29 80 00       	push   $0x802948
  800d30:	6a 43                	push   $0x43
  800d32:	68 65 29 80 00       	push   $0x802965
  800d37:	e8 ec 13 00 00       	call   802128 <_panic>

00800d3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 06 00 00 00       	mov    $0x6,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 06                	push   $0x6
  800d6d:	68 48 29 80 00       	push   $0x802948
  800d72:	6a 43                	push   $0x43
  800d74:	68 65 29 80 00       	push   $0x802965
  800d79:	e8 aa 13 00 00       	call   802128 <_panic>

00800d7e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d92:	b8 08 00 00 00       	mov    $0x8,%eax
  800d97:	89 df                	mov    %ebx,%edi
  800d99:	89 de                	mov    %ebx,%esi
  800d9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	7f 08                	jg     800da9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	50                   	push   %eax
  800dad:	6a 08                	push   $0x8
  800daf:	68 48 29 80 00       	push   $0x802948
  800db4:	6a 43                	push   $0x43
  800db6:	68 65 29 80 00       	push   $0x802965
  800dbb:	e8 68 13 00 00       	call   802128 <_panic>

00800dc0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd9:	89 df                	mov    %ebx,%edi
  800ddb:	89 de                	mov    %ebx,%esi
  800ddd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7f 08                	jg     800deb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	83 ec 0c             	sub    $0xc,%esp
  800dee:	50                   	push   %eax
  800def:	6a 09                	push   $0x9
  800df1:	68 48 29 80 00       	push   $0x802948
  800df6:	6a 43                	push   $0x43
  800df8:	68 65 29 80 00       	push   $0x802965
  800dfd:	e8 26 13 00 00       	call   802128 <_panic>

00800e02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1b:	89 df                	mov    %ebx,%edi
  800e1d:	89 de                	mov    %ebx,%esi
  800e1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	7f 08                	jg     800e2d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	50                   	push   %eax
  800e31:	6a 0a                	push   $0xa
  800e33:	68 48 29 80 00       	push   $0x802948
  800e38:	6a 43                	push   $0x43
  800e3a:	68 65 29 80 00       	push   $0x802965
  800e3f:	e8 e4 12 00 00       	call   802128 <_panic>

00800e44 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e55:	be 00 00 00 00       	mov    $0x0,%esi
  800e5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e60:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7d:	89 cb                	mov    %ecx,%ebx
  800e7f:	89 cf                	mov    %ecx,%edi
  800e81:	89 ce                	mov    %ecx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 0d                	push   $0xd
  800e97:	68 48 29 80 00       	push   $0x802948
  800e9c:	6a 43                	push   $0x43
  800e9e:	68 65 29 80 00       	push   $0x802965
  800ea3:	e8 80 12 00 00       	call   802128 <_panic>

00800ea8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800edc:	89 cb                	mov    %ecx,%ebx
  800ede:	89 cf                	mov    %ecx,%edi
  800ee0:	89 ce                	mov    %ecx,%esi
  800ee2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ef9:	89 d1                	mov    %edx,%ecx
  800efb:	89 d3                	mov    %edx,%ebx
  800efd:	89 d7                	mov    %edx,%edi
  800eff:	89 d6                	mov    %edx,%esi
  800f01:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	b8 11 00 00 00       	mov    $0x11,%eax
  800f1e:	89 df                	mov    %ebx,%edi
  800f20:	89 de                	mov    %ebx,%esi
  800f22:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	89 de                	mov    %ebx,%esi
  800f43:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5e:	b8 13 00 00 00       	mov    $0x13,%eax
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7f 08                	jg     800f75 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	50                   	push   %eax
  800f79:	6a 13                	push   $0x13
  800f7b:	68 48 29 80 00       	push   $0x802948
  800f80:	6a 43                	push   $0x43
  800f82:	68 65 29 80 00       	push   $0x802965
  800f87:	e8 9c 11 00 00       	call   802128 <_panic>

00800f8c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	b8 14 00 00 00       	mov    $0x14,%eax
  800f9f:	89 cb                	mov    %ecx,%ebx
  800fa1:	89 cf                	mov    %ecx,%edi
  800fa3:	89 ce                	mov    %ecx,%esi
  800fa5:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fac:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fad:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800fb2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fb4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  800fb7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  800fbb:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  800fbf:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800fc2:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800fc4:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  800fc8:	83 c4 08             	add    $0x8,%esp
	popal
  800fcb:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800fcc:	83 c4 04             	add    $0x4,%esp
	popfl
  800fcf:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fd0:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800fd1:	c3                   	ret    

00800fd2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	05 00 00 00 30       	add    $0x30000000,%eax
  800fdd:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801001:	89 c2                	mov    %eax,%edx
  801003:	c1 ea 16             	shr    $0x16,%edx
  801006:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100d:	f6 c2 01             	test   $0x1,%dl
  801010:	74 2d                	je     80103f <fd_alloc+0x46>
  801012:	89 c2                	mov    %eax,%edx
  801014:	c1 ea 0c             	shr    $0xc,%edx
  801017:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80101e:	f6 c2 01             	test   $0x1,%dl
  801021:	74 1c                	je     80103f <fd_alloc+0x46>
  801023:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801028:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80102d:	75 d2                	jne    801001 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801038:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80103d:	eb 0a                	jmp    801049 <fd_alloc+0x50>
			*fd_store = fd;
  80103f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801042:	89 01                	mov    %eax,(%ecx)
			return 0;
  801044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801051:	83 f8 1f             	cmp    $0x1f,%eax
  801054:	77 30                	ja     801086 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801056:	c1 e0 0c             	shl    $0xc,%eax
  801059:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80105e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801064:	f6 c2 01             	test   $0x1,%dl
  801067:	74 24                	je     80108d <fd_lookup+0x42>
  801069:	89 c2                	mov    %eax,%edx
  80106b:	c1 ea 0c             	shr    $0xc,%edx
  80106e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801075:	f6 c2 01             	test   $0x1,%dl
  801078:	74 1a                	je     801094 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	89 02                	mov    %eax,(%edx)
	return 0;
  80107f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
		return -E_INVAL;
  801086:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108b:	eb f7                	jmp    801084 <fd_lookup+0x39>
		return -E_INVAL;
  80108d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801092:	eb f0                	jmp    801084 <fd_lookup+0x39>
  801094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801099:	eb e9                	jmp    801084 <fd_lookup+0x39>

0080109b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ae:	39 08                	cmp    %ecx,(%eax)
  8010b0:	74 38                	je     8010ea <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010b2:	83 c2 01             	add    $0x1,%edx
  8010b5:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	75 ee                	jne    8010ae <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8010c5:	8b 40 48             	mov    0x48(%eax),%eax
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	51                   	push   %ecx
  8010cc:	50                   	push   %eax
  8010cd:	68 74 29 80 00       	push   $0x802974
  8010d2:	e8 8f f0 ff ff       	call   800166 <cprintf>
	*dev = 0;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    
			*dev = devtab[i];
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ed:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f4:	eb f2                	jmp    8010e8 <dev_lookup+0x4d>

008010f6 <fd_close>:
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 24             	sub    $0x24,%esp
  8010ff:	8b 75 08             	mov    0x8(%ebp),%esi
  801102:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801105:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801108:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801109:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80110f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801112:	50                   	push   %eax
  801113:	e8 33 ff ff ff       	call   80104b <fd_lookup>
  801118:	89 c3                	mov    %eax,%ebx
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	78 05                	js     801126 <fd_close+0x30>
	    || fd != fd2)
  801121:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801124:	74 16                	je     80113c <fd_close+0x46>
		return (must_exist ? r : 0);
  801126:	89 f8                	mov    %edi,%eax
  801128:	84 c0                	test   %al,%al
  80112a:	b8 00 00 00 00       	mov    $0x0,%eax
  80112f:	0f 44 d8             	cmove  %eax,%ebx
}
  801132:	89 d8                	mov    %ebx,%eax
  801134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801137:	5b                   	pop    %ebx
  801138:	5e                   	pop    %esi
  801139:	5f                   	pop    %edi
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80113c:	83 ec 08             	sub    $0x8,%esp
  80113f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801142:	50                   	push   %eax
  801143:	ff 36                	pushl  (%esi)
  801145:	e8 51 ff ff ff       	call   80109b <dev_lookup>
  80114a:	89 c3                	mov    %eax,%ebx
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 1a                	js     80116d <fd_close+0x77>
		if (dev->dev_close)
  801153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801156:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801159:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80115e:	85 c0                	test   %eax,%eax
  801160:	74 0b                	je     80116d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	56                   	push   %esi
  801166:	ff d0                	call   *%eax
  801168:	89 c3                	mov    %eax,%ebx
  80116a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	56                   	push   %esi
  801171:	6a 00                	push   $0x0
  801173:	e8 c4 fb ff ff       	call   800d3c <sys_page_unmap>
	return r;
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	eb b5                	jmp    801132 <fd_close+0x3c>

0080117d <close>:

int
close(int fdnum)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801183:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	ff 75 08             	pushl  0x8(%ebp)
  80118a:	e8 bc fe ff ff       	call   80104b <fd_lookup>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	79 02                	jns    801198 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    
		return fd_close(fd, 1);
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	6a 01                	push   $0x1
  80119d:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a0:	e8 51 ff ff ff       	call   8010f6 <fd_close>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	eb ec                	jmp    801196 <close+0x19>

008011aa <close_all>:

void
close_all(void)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	53                   	push   %ebx
  8011ba:	e8 be ff ff ff       	call   80117d <close>
	for (i = 0; i < MAXFD; i++)
  8011bf:	83 c3 01             	add    $0x1,%ebx
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	83 fb 20             	cmp    $0x20,%ebx
  8011c8:	75 ec                	jne    8011b6 <close_all+0xc>
}
  8011ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	ff 75 08             	pushl  0x8(%ebp)
  8011df:	e8 67 fe ff ff       	call   80104b <fd_lookup>
  8011e4:	89 c3                	mov    %eax,%ebx
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	0f 88 81 00 00 00    	js     801272 <dup+0xa3>
		return r;
	close(newfdnum);
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	e8 81 ff ff ff       	call   80117d <close>

	newfd = INDEX2FD(newfdnum);
  8011fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ff:	c1 e6 0c             	shl    $0xc,%esi
  801202:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120e:	e8 cf fd ff ff       	call   800fe2 <fd2data>
  801213:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801215:	89 34 24             	mov    %esi,(%esp)
  801218:	e8 c5 fd ff ff       	call   800fe2 <fd2data>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801222:	89 d8                	mov    %ebx,%eax
  801224:	c1 e8 16             	shr    $0x16,%eax
  801227:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122e:	a8 01                	test   $0x1,%al
  801230:	74 11                	je     801243 <dup+0x74>
  801232:	89 d8                	mov    %ebx,%eax
  801234:	c1 e8 0c             	shr    $0xc,%eax
  801237:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80123e:	f6 c2 01             	test   $0x1,%dl
  801241:	75 39                	jne    80127c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801243:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801246:	89 d0                	mov    %edx,%eax
  801248:	c1 e8 0c             	shr    $0xc,%eax
  80124b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801252:	83 ec 0c             	sub    $0xc,%esp
  801255:	25 07 0e 00 00       	and    $0xe07,%eax
  80125a:	50                   	push   %eax
  80125b:	56                   	push   %esi
  80125c:	6a 00                	push   $0x0
  80125e:	52                   	push   %edx
  80125f:	6a 00                	push   $0x0
  801261:	e8 94 fa ff ff       	call   800cfa <sys_page_map>
  801266:	89 c3                	mov    %eax,%ebx
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	78 31                	js     8012a0 <dup+0xd1>
		goto err;

	return newfdnum;
  80126f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801272:	89 d8                	mov    %ebx,%eax
  801274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80127c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801283:	83 ec 0c             	sub    $0xc,%esp
  801286:	25 07 0e 00 00       	and    $0xe07,%eax
  80128b:	50                   	push   %eax
  80128c:	57                   	push   %edi
  80128d:	6a 00                	push   $0x0
  80128f:	53                   	push   %ebx
  801290:	6a 00                	push   $0x0
  801292:	e8 63 fa ff ff       	call   800cfa <sys_page_map>
  801297:	89 c3                	mov    %eax,%ebx
  801299:	83 c4 20             	add    $0x20,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	79 a3                	jns    801243 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012a0:	83 ec 08             	sub    $0x8,%esp
  8012a3:	56                   	push   %esi
  8012a4:	6a 00                	push   $0x0
  8012a6:	e8 91 fa ff ff       	call   800d3c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ab:	83 c4 08             	add    $0x8,%esp
  8012ae:	57                   	push   %edi
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 86 fa ff ff       	call   800d3c <sys_page_unmap>
	return r;
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	eb b7                	jmp    801272 <dup+0xa3>

008012bb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 1c             	sub    $0x1c,%esp
  8012c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	53                   	push   %ebx
  8012ca:	e8 7c fd ff ff       	call   80104b <fd_lookup>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 3f                	js     801315 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012dc:	50                   	push   %eax
  8012dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e0:	ff 30                	pushl  (%eax)
  8012e2:	e8 b4 fd ff ff       	call   80109b <dev_lookup>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 27                	js     801315 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f1:	8b 42 08             	mov    0x8(%edx),%eax
  8012f4:	83 e0 03             	and    $0x3,%eax
  8012f7:	83 f8 01             	cmp    $0x1,%eax
  8012fa:	74 1e                	je     80131a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	8b 40 08             	mov    0x8(%eax),%eax
  801302:	85 c0                	test   %eax,%eax
  801304:	74 35                	je     80133b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	ff 75 10             	pushl  0x10(%ebp)
  80130c:	ff 75 0c             	pushl  0xc(%ebp)
  80130f:	52                   	push   %edx
  801310:	ff d0                	call   *%eax
  801312:	83 c4 10             	add    $0x10,%esp
}
  801315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801318:	c9                   	leave  
  801319:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80131a:	a1 08 40 80 00       	mov    0x804008,%eax
  80131f:	8b 40 48             	mov    0x48(%eax),%eax
  801322:	83 ec 04             	sub    $0x4,%esp
  801325:	53                   	push   %ebx
  801326:	50                   	push   %eax
  801327:	68 b5 29 80 00       	push   $0x8029b5
  80132c:	e8 35 ee ff ff       	call   800166 <cprintf>
		return -E_INVAL;
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801339:	eb da                	jmp    801315 <read+0x5a>
		return -E_NOT_SUPP;
  80133b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801340:	eb d3                	jmp    801315 <read+0x5a>

00801342 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	57                   	push   %edi
  801346:	56                   	push   %esi
  801347:	53                   	push   %ebx
  801348:	83 ec 0c             	sub    $0xc,%esp
  80134b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80134e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801351:	bb 00 00 00 00       	mov    $0x0,%ebx
  801356:	39 f3                	cmp    %esi,%ebx
  801358:	73 23                	jae    80137d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	89 f0                	mov    %esi,%eax
  80135f:	29 d8                	sub    %ebx,%eax
  801361:	50                   	push   %eax
  801362:	89 d8                	mov    %ebx,%eax
  801364:	03 45 0c             	add    0xc(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	57                   	push   %edi
  801369:	e8 4d ff ff ff       	call   8012bb <read>
		if (m < 0)
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 06                	js     80137b <readn+0x39>
			return m;
		if (m == 0)
  801375:	74 06                	je     80137d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801377:	01 c3                	add    %eax,%ebx
  801379:	eb db                	jmp    801356 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80137d:	89 d8                	mov    %ebx,%eax
  80137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801382:	5b                   	pop    %ebx
  801383:	5e                   	pop    %esi
  801384:	5f                   	pop    %edi
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	53                   	push   %ebx
  80138b:	83 ec 1c             	sub    $0x1c,%esp
  80138e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801391:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	53                   	push   %ebx
  801396:	e8 b0 fc ff ff       	call   80104b <fd_lookup>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 3a                	js     8013dc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	ff 30                	pushl  (%eax)
  8013ae:	e8 e8 fc ff ff       	call   80109b <dev_lookup>
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 22                	js     8013dc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c1:	74 1e                	je     8013e1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013c9:	85 d2                	test   %edx,%edx
  8013cb:	74 35                	je     801402 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	ff 75 10             	pushl  0x10(%ebp)
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	50                   	push   %eax
  8013d7:	ff d2                	call   *%edx
  8013d9:	83 c4 10             	add    $0x10,%esp
}
  8013dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013e6:	8b 40 48             	mov    0x48(%eax),%eax
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	53                   	push   %ebx
  8013ed:	50                   	push   %eax
  8013ee:	68 d1 29 80 00       	push   $0x8029d1
  8013f3:	e8 6e ed ff ff       	call   800166 <cprintf>
		return -E_INVAL;
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801400:	eb da                	jmp    8013dc <write+0x55>
		return -E_NOT_SUPP;
  801402:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801407:	eb d3                	jmp    8013dc <write+0x55>

00801409 <seek>:

int
seek(int fdnum, off_t offset)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	ff 75 08             	pushl  0x8(%ebp)
  801416:	e8 30 fc ff ff       	call   80104b <fd_lookup>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 0e                	js     801430 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	53                   	push   %ebx
  801436:	83 ec 1c             	sub    $0x1c,%esp
  801439:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143f:	50                   	push   %eax
  801440:	53                   	push   %ebx
  801441:	e8 05 fc ff ff       	call   80104b <fd_lookup>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 37                	js     801484 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801453:	50                   	push   %eax
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	ff 30                	pushl  (%eax)
  801459:	e8 3d fc ff ff       	call   80109b <dev_lookup>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	85 c0                	test   %eax,%eax
  801463:	78 1f                	js     801484 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801468:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80146c:	74 1b                	je     801489 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80146e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801471:	8b 52 18             	mov    0x18(%edx),%edx
  801474:	85 d2                	test   %edx,%edx
  801476:	74 32                	je     8014aa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	50                   	push   %eax
  80147f:	ff d2                	call   *%edx
  801481:	83 c4 10             	add    $0x10,%esp
}
  801484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801487:	c9                   	leave  
  801488:	c3                   	ret    
			thisenv->env_id, fdnum);
  801489:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80148e:	8b 40 48             	mov    0x48(%eax),%eax
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	53                   	push   %ebx
  801495:	50                   	push   %eax
  801496:	68 94 29 80 00       	push   $0x802994
  80149b:	e8 c6 ec ff ff       	call   800166 <cprintf>
		return -E_INVAL;
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb da                	jmp    801484 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014af:	eb d3                	jmp    801484 <ftruncate+0x52>

008014b1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	53                   	push   %ebx
  8014b5:	83 ec 1c             	sub    $0x1c,%esp
  8014b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014be:	50                   	push   %eax
  8014bf:	ff 75 08             	pushl  0x8(%ebp)
  8014c2:	e8 84 fb ff ff       	call   80104b <fd_lookup>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 4b                	js     801519 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ce:	83 ec 08             	sub    $0x8,%esp
  8014d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d4:	50                   	push   %eax
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	ff 30                	pushl  (%eax)
  8014da:	e8 bc fb ff ff       	call   80109b <dev_lookup>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 33                	js     801519 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014ed:	74 2f                	je     80151e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f9:	00 00 00 
	stat->st_isdir = 0;
  8014fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801503:	00 00 00 
	stat->st_dev = dev;
  801506:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80150c:	83 ec 08             	sub    $0x8,%esp
  80150f:	53                   	push   %ebx
  801510:	ff 75 f0             	pushl  -0x10(%ebp)
  801513:	ff 50 14             	call   *0x14(%eax)
  801516:	83 c4 10             	add    $0x10,%esp
}
  801519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    
		return -E_NOT_SUPP;
  80151e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801523:	eb f4                	jmp    801519 <fstat+0x68>

00801525 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	56                   	push   %esi
  801529:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	6a 00                	push   $0x0
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 22 02 00 00       	call   801759 <open>
  801537:	89 c3                	mov    %eax,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 1b                	js     80155b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	50                   	push   %eax
  801547:	e8 65 ff ff ff       	call   8014b1 <fstat>
  80154c:	89 c6                	mov    %eax,%esi
	close(fd);
  80154e:	89 1c 24             	mov    %ebx,(%esp)
  801551:	e8 27 fc ff ff       	call   80117d <close>
	return r;
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	89 f3                	mov    %esi,%ebx
}
  80155b:	89 d8                	mov    %ebx,%eax
  80155d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	56                   	push   %esi
  801568:	53                   	push   %ebx
  801569:	89 c6                	mov    %eax,%esi
  80156b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80156d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801574:	74 27                	je     80159d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801576:	6a 07                	push   $0x7
  801578:	68 00 50 80 00       	push   $0x805000
  80157d:	56                   	push   %esi
  80157e:	ff 35 00 40 80 00    	pushl  0x804000
  801584:	e8 d8 0c 00 00       	call   802261 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801589:	83 c4 0c             	add    $0xc,%esp
  80158c:	6a 00                	push   $0x0
  80158e:	53                   	push   %ebx
  80158f:	6a 00                	push   $0x0
  801591:	e8 62 0c 00 00       	call   8021f8 <ipc_recv>
}
  801596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80159d:	83 ec 0c             	sub    $0xc,%esp
  8015a0:	6a 01                	push   $0x1
  8015a2:	e8 12 0d 00 00       	call   8022b9 <ipc_find_env>
  8015a7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb c5                	jmp    801576 <fsipc+0x12>

008015b1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d4:	e8 8b ff ff ff       	call   801564 <fsipc>
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <devfile_flush>:
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8015f6:	e8 69 ff ff ff       	call   801564 <fsipc>
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <devfile_stat>:
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	53                   	push   %ebx
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8b 40 0c             	mov    0xc(%eax),%eax
  80160d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801612:	ba 00 00 00 00       	mov    $0x0,%edx
  801617:	b8 05 00 00 00       	mov    $0x5,%eax
  80161c:	e8 43 ff ff ff       	call   801564 <fsipc>
  801621:	85 c0                	test   %eax,%eax
  801623:	78 2c                	js     801651 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	68 00 50 80 00       	push   $0x805000
  80162d:	53                   	push   %ebx
  80162e:	e8 92 f2 ff ff       	call   8008c5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801633:	a1 80 50 80 00       	mov    0x805080,%eax
  801638:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80163e:	a1 84 50 80 00       	mov    0x805084,%eax
  801643:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <devfile_write>:
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	53                   	push   %ebx
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8b 40 0c             	mov    0xc(%eax),%eax
  801666:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80166b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801671:	53                   	push   %ebx
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	68 08 50 80 00       	push   $0x805008
  80167a:	e8 36 f4 ff ff       	call   800ab5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80167f:	ba 00 00 00 00       	mov    $0x0,%edx
  801684:	b8 04 00 00 00       	mov    $0x4,%eax
  801689:	e8 d6 fe ff ff       	call   801564 <fsipc>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 0b                	js     8016a0 <devfile_write+0x4a>
	assert(r <= n);
  801695:	39 d8                	cmp    %ebx,%eax
  801697:	77 0c                	ja     8016a5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801699:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169e:	7f 1e                	jg     8016be <devfile_write+0x68>
}
  8016a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
	assert(r <= n);
  8016a5:	68 04 2a 80 00       	push   $0x802a04
  8016aa:	68 0b 2a 80 00       	push   $0x802a0b
  8016af:	68 98 00 00 00       	push   $0x98
  8016b4:	68 20 2a 80 00       	push   $0x802a20
  8016b9:	e8 6a 0a 00 00       	call   802128 <_panic>
	assert(r <= PGSIZE);
  8016be:	68 2b 2a 80 00       	push   $0x802a2b
  8016c3:	68 0b 2a 80 00       	push   $0x802a0b
  8016c8:	68 99 00 00 00       	push   $0x99
  8016cd:	68 20 2a 80 00       	push   $0x802a20
  8016d2:	e8 51 0a 00 00       	call   802128 <_panic>

008016d7 <devfile_read>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ea:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8016fa:	e8 65 fe ff ff       	call   801564 <fsipc>
  8016ff:	89 c3                	mov    %eax,%ebx
  801701:	85 c0                	test   %eax,%eax
  801703:	78 1f                	js     801724 <devfile_read+0x4d>
	assert(r <= n);
  801705:	39 f0                	cmp    %esi,%eax
  801707:	77 24                	ja     80172d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801709:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80170e:	7f 33                	jg     801743 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	50                   	push   %eax
  801714:	68 00 50 80 00       	push   $0x805000
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	e8 32 f3 ff ff       	call   800a53 <memmove>
	return r;
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	89 d8                	mov    %ebx,%eax
  801726:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    
	assert(r <= n);
  80172d:	68 04 2a 80 00       	push   $0x802a04
  801732:	68 0b 2a 80 00       	push   $0x802a0b
  801737:	6a 7c                	push   $0x7c
  801739:	68 20 2a 80 00       	push   $0x802a20
  80173e:	e8 e5 09 00 00       	call   802128 <_panic>
	assert(r <= PGSIZE);
  801743:	68 2b 2a 80 00       	push   $0x802a2b
  801748:	68 0b 2a 80 00       	push   $0x802a0b
  80174d:	6a 7d                	push   $0x7d
  80174f:	68 20 2a 80 00       	push   $0x802a20
  801754:	e8 cf 09 00 00       	call   802128 <_panic>

00801759 <open>:
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 1c             	sub    $0x1c,%esp
  801761:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801764:	56                   	push   %esi
  801765:	e8 22 f1 ff ff       	call   80088c <strlen>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801772:	7f 6c                	jg     8017e0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177a:	50                   	push   %eax
  80177b:	e8 79 f8 ff ff       	call   800ff9 <fd_alloc>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 3c                	js     8017c5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	56                   	push   %esi
  80178d:	68 00 50 80 00       	push   $0x805000
  801792:	e8 2e f1 ff ff       	call   8008c5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a7:	e8 b8 fd ff ff       	call   801564 <fsipc>
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 19                	js     8017ce <open+0x75>
	return fd2num(fd);
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bb:	e8 12 f8 ff ff       	call   800fd2 <fd2num>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
}
  8017c5:	89 d8                	mov    %ebx,%eax
  8017c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5e                   	pop    %esi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    
		fd_close(fd, 0);
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d6:	e8 1b f9 ff ff       	call   8010f6 <fd_close>
		return r;
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	eb e5                	jmp    8017c5 <open+0x6c>
		return -E_BAD_PATH;
  8017e0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017e5:	eb de                	jmp    8017c5 <open+0x6c>

008017e7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f7:	e8 68 fd ff ff       	call   801564 <fsipc>
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801804:	68 37 2a 80 00       	push   $0x802a37
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	e8 b4 f0 ff ff       	call   8008c5 <strcpy>
	return 0;
}
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <devsock_close>:
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	53                   	push   %ebx
  80181c:	83 ec 10             	sub    $0x10,%esp
  80181f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801822:	53                   	push   %ebx
  801823:	e8 d0 0a 00 00       	call   8022f8 <pageref>
  801828:	83 c4 10             	add    $0x10,%esp
		return 0;
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801830:	83 f8 01             	cmp    $0x1,%eax
  801833:	74 07                	je     80183c <devsock_close+0x24>
}
  801835:	89 d0                	mov    %edx,%eax
  801837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	ff 73 0c             	pushl  0xc(%ebx)
  801842:	e8 b9 02 00 00       	call   801b00 <nsipc_close>
  801847:	89 c2                	mov    %eax,%edx
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	eb e7                	jmp    801835 <devsock_close+0x1d>

0080184e <devsock_write>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801854:	6a 00                	push   $0x0
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	ff 70 0c             	pushl  0xc(%eax)
  801862:	e8 76 03 00 00       	call   801bdd <nsipc_send>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <devsock_read>:
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 10             	pushl  0x10(%ebp)
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	ff 70 0c             	pushl  0xc(%eax)
  80187d:	e8 ef 02 00 00       	call   801b71 <nsipc_recv>
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <fd2sockid>:
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80188a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	e8 b7 f7 ff ff       	call   80104b <fd_lookup>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	78 10                	js     8018ab <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018a4:	39 08                	cmp    %ecx,(%eax)
  8018a6:	75 05                	jne    8018ad <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018a8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b2:	eb f7                	jmp    8018ab <fd2sockid+0x27>

008018b4 <alloc_sockfd>:
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 1c             	sub    $0x1c,%esp
  8018bc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c1:	50                   	push   %eax
  8018c2:	e8 32 f7 ff ff       	call   800ff9 <fd_alloc>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 43                	js     801913 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	68 07 04 00 00       	push   $0x407
  8018d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018db:	6a 00                	push   $0x0
  8018dd:	e8 d5 f3 ff ff       	call   800cb7 <sys_page_alloc>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 28                	js     801913 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801900:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	50                   	push   %eax
  801907:	e8 c6 f6 ff ff       	call   800fd2 <fd2num>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	eb 0c                	jmp    80191f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	56                   	push   %esi
  801917:	e8 e4 01 00 00       	call   801b00 <nsipc_close>
		return r;
  80191c:	83 c4 10             	add    $0x10,%esp
}
  80191f:	89 d8                	mov    %ebx,%eax
  801921:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    

00801928 <accept>:
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	e8 4e ff ff ff       	call   801884 <fd2sockid>
  801936:	85 c0                	test   %eax,%eax
  801938:	78 1b                	js     801955 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	ff 75 10             	pushl  0x10(%ebp)
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	e8 0e 01 00 00       	call   801a57 <nsipc_accept>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 05                	js     801955 <accept+0x2d>
	return alloc_sockfd(r);
  801950:	e8 5f ff ff ff       	call   8018b4 <alloc_sockfd>
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <bind>:
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	e8 1f ff ff ff       	call   801884 <fd2sockid>
  801965:	85 c0                	test   %eax,%eax
  801967:	78 12                	js     80197b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	ff 75 10             	pushl  0x10(%ebp)
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	50                   	push   %eax
  801973:	e8 31 01 00 00       	call   801aa9 <nsipc_bind>
  801978:	83 c4 10             	add    $0x10,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <shutdown>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	e8 f9 fe ff ff       	call   801884 <fd2sockid>
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 0f                	js     80199e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	e8 43 01 00 00       	call   801ade <nsipc_shutdown>
  80199b:	83 c4 10             	add    $0x10,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <connect>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	e8 d6 fe ff ff       	call   801884 <fd2sockid>
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 12                	js     8019c4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	ff 75 10             	pushl  0x10(%ebp)
  8019b8:	ff 75 0c             	pushl  0xc(%ebp)
  8019bb:	50                   	push   %eax
  8019bc:	e8 59 01 00 00       	call   801b1a <nsipc_connect>
  8019c1:	83 c4 10             	add    $0x10,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <listen>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	e8 b0 fe ff ff       	call   801884 <fd2sockid>
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 0f                	js     8019e7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019d8:	83 ec 08             	sub    $0x8,%esp
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	50                   	push   %eax
  8019df:	e8 6b 01 00 00       	call   801b4f <nsipc_listen>
  8019e4:	83 c4 10             	add    $0x10,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ef:	ff 75 10             	pushl  0x10(%ebp)
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	e8 3e 02 00 00       	call   801c3b <nsipc_socket>
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 05                	js     801a09 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a04:	e8 ab fe ff ff       	call   8018b4 <alloc_sockfd>
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	53                   	push   %ebx
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a14:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a1b:	74 26                	je     801a43 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a1d:	6a 07                	push   $0x7
  801a1f:	68 00 60 80 00       	push   $0x806000
  801a24:	53                   	push   %ebx
  801a25:	ff 35 04 40 80 00    	pushl  0x804004
  801a2b:	e8 31 08 00 00       	call   802261 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a30:	83 c4 0c             	add    $0xc,%esp
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	e8 ba 07 00 00       	call   8021f8 <ipc_recv>
}
  801a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	6a 02                	push   $0x2
  801a48:	e8 6c 08 00 00       	call   8022b9 <ipc_find_env>
  801a4d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	eb c6                	jmp    801a1d <nsipc+0x12>

00801a57 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a67:	8b 06                	mov    (%esi),%eax
  801a69:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	e8 93 ff ff ff       	call   801a0b <nsipc>
  801a78:	89 c3                	mov    %eax,%ebx
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	79 09                	jns    801a87 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a7e:	89 d8                	mov    %ebx,%eax
  801a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	ff 35 10 60 80 00    	pushl  0x806010
  801a90:	68 00 60 80 00       	push   $0x806000
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	e8 b6 ef ff ff       	call   800a53 <memmove>
		*addrlen = ret->ret_addrlen;
  801a9d:	a1 10 60 80 00       	mov    0x806010,%eax
  801aa2:	89 06                	mov    %eax,(%esi)
  801aa4:	83 c4 10             	add    $0x10,%esp
	return r;
  801aa7:	eb d5                	jmp    801a7e <nsipc_accept+0x27>

00801aa9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	53                   	push   %ebx
  801aad:	83 ec 08             	sub    $0x8,%esp
  801ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801abb:	53                   	push   %ebx
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	68 04 60 80 00       	push   $0x806004
  801ac4:	e8 8a ef ff ff       	call   800a53 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ac9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801acf:	b8 02 00 00 00       	mov    $0x2,%eax
  801ad4:	e8 32 ff ff ff       	call   801a0b <nsipc>
}
  801ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801af4:	b8 03 00 00 00       	mov    $0x3,%eax
  801af9:	e8 0d ff ff ff       	call   801a0b <nsipc>
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <nsipc_close>:

int
nsipc_close(int s)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b0e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b13:	e8 f3 fe ff ff       	call   801a0b <nsipc>
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b2c:	53                   	push   %ebx
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	68 04 60 80 00       	push   $0x806004
  801b35:	e8 19 ef ff ff       	call   800a53 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b3a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b40:	b8 05 00 00 00       	mov    $0x5,%eax
  801b45:	e8 c1 fe ff ff       	call   801a0b <nsipc>
}
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b65:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6a:	e8 9c fe ff ff       	call   801a0b <nsipc>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b81:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b87:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b8f:	b8 07 00 00 00       	mov    $0x7,%eax
  801b94:	e8 72 fe ff ff       	call   801a0b <nsipc>
  801b99:	89 c3                	mov    %eax,%ebx
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 1f                	js     801bbe <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b9f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ba4:	7f 21                	jg     801bc7 <nsipc_recv+0x56>
  801ba6:	39 c6                	cmp    %eax,%esi
  801ba8:	7c 1d                	jl     801bc7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	50                   	push   %eax
  801bae:	68 00 60 80 00       	push   $0x806000
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 98 ee ff ff       	call   800a53 <memmove>
  801bbb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bc7:	68 43 2a 80 00       	push   $0x802a43
  801bcc:	68 0b 2a 80 00       	push   $0x802a0b
  801bd1:	6a 62                	push   $0x62
  801bd3:	68 58 2a 80 00       	push   $0x802a58
  801bd8:	e8 4b 05 00 00       	call   802128 <_panic>

00801bdd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bef:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bf5:	7f 2e                	jg     801c25 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	53                   	push   %ebx
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	68 0c 60 80 00       	push   $0x80600c
  801c03:	e8 4b ee ff ff       	call   800a53 <memmove>
	nsipcbuf.send.req_size = size;
  801c08:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c11:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c16:	b8 08 00 00 00       	mov    $0x8,%eax
  801c1b:	e8 eb fd ff ff       	call   801a0b <nsipc>
}
  801c20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    
	assert(size < 1600);
  801c25:	68 64 2a 80 00       	push   $0x802a64
  801c2a:	68 0b 2a 80 00       	push   $0x802a0b
  801c2f:	6a 6d                	push   $0x6d
  801c31:	68 58 2a 80 00       	push   $0x802a58
  801c36:	e8 ed 04 00 00       	call   802128 <_panic>

00801c3b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c59:	b8 09 00 00 00       	mov    $0x9,%eax
  801c5e:	e8 a8 fd ff ff       	call   801a0b <nsipc>
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	56                   	push   %esi
  801c69:	53                   	push   %ebx
  801c6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c6d:	83 ec 0c             	sub    $0xc,%esp
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	e8 6a f3 ff ff       	call   800fe2 <fd2data>
  801c78:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c7a:	83 c4 08             	add    $0x8,%esp
  801c7d:	68 70 2a 80 00       	push   $0x802a70
  801c82:	53                   	push   %ebx
  801c83:	e8 3d ec ff ff       	call   8008c5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c88:	8b 46 04             	mov    0x4(%esi),%eax
  801c8b:	2b 06                	sub    (%esi),%eax
  801c8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9a:	00 00 00 
	stat->st_dev = &devpipe;
  801c9d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ca4:	30 80 00 
	return 0;
}
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    

00801cb3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cbd:	53                   	push   %ebx
  801cbe:	6a 00                	push   $0x0
  801cc0:	e8 77 f0 ff ff       	call   800d3c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cc5:	89 1c 24             	mov    %ebx,(%esp)
  801cc8:	e8 15 f3 ff ff       	call   800fe2 <fd2data>
  801ccd:	83 c4 08             	add    $0x8,%esp
  801cd0:	50                   	push   %eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	e8 64 f0 ff ff       	call   800d3c <sys_page_unmap>
}
  801cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <_pipeisclosed>:
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	57                   	push   %edi
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
  801ce3:	83 ec 1c             	sub    $0x1c,%esp
  801ce6:	89 c7                	mov    %eax,%edi
  801ce8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cea:	a1 08 40 80 00       	mov    0x804008,%eax
  801cef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	57                   	push   %edi
  801cf6:	e8 fd 05 00 00       	call   8022f8 <pageref>
  801cfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cfe:	89 34 24             	mov    %esi,(%esp)
  801d01:	e8 f2 05 00 00       	call   8022f8 <pageref>
		nn = thisenv->env_runs;
  801d06:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d0c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	39 cb                	cmp    %ecx,%ebx
  801d14:	74 1b                	je     801d31 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d16:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d19:	75 cf                	jne    801cea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d1b:	8b 42 58             	mov    0x58(%edx),%eax
  801d1e:	6a 01                	push   $0x1
  801d20:	50                   	push   %eax
  801d21:	53                   	push   %ebx
  801d22:	68 77 2a 80 00       	push   $0x802a77
  801d27:	e8 3a e4 ff ff       	call   800166 <cprintf>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	eb b9                	jmp    801cea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d34:	0f 94 c0             	sete   %al
  801d37:	0f b6 c0             	movzbl %al,%eax
}
  801d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5e                   	pop    %esi
  801d3f:	5f                   	pop    %edi
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <devpipe_write>:
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 28             	sub    $0x28,%esp
  801d4b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d4e:	56                   	push   %esi
  801d4f:	e8 8e f2 ff ff       	call   800fe2 <fd2data>
  801d54:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d61:	74 4f                	je     801db2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d63:	8b 43 04             	mov    0x4(%ebx),%eax
  801d66:	8b 0b                	mov    (%ebx),%ecx
  801d68:	8d 51 20             	lea    0x20(%ecx),%edx
  801d6b:	39 d0                	cmp    %edx,%eax
  801d6d:	72 14                	jb     801d83 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d6f:	89 da                	mov    %ebx,%edx
  801d71:	89 f0                	mov    %esi,%eax
  801d73:	e8 65 ff ff ff       	call   801cdd <_pipeisclosed>
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	75 3b                	jne    801db7 <devpipe_write+0x75>
			sys_yield();
  801d7c:	e8 17 ef ff ff       	call   800c98 <sys_yield>
  801d81:	eb e0                	jmp    801d63 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d86:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d8a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d8d:	89 c2                	mov    %eax,%edx
  801d8f:	c1 fa 1f             	sar    $0x1f,%edx
  801d92:	89 d1                	mov    %edx,%ecx
  801d94:	c1 e9 1b             	shr    $0x1b,%ecx
  801d97:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d9a:	83 e2 1f             	and    $0x1f,%edx
  801d9d:	29 ca                	sub    %ecx,%edx
  801d9f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801da3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801da7:	83 c0 01             	add    $0x1,%eax
  801daa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dad:	83 c7 01             	add    $0x1,%edi
  801db0:	eb ac                	jmp    801d5e <devpipe_write+0x1c>
	return i;
  801db2:	8b 45 10             	mov    0x10(%ebp),%eax
  801db5:	eb 05                	jmp    801dbc <devpipe_write+0x7a>
				return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5f                   	pop    %edi
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    

00801dc4 <devpipe_read>:
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	57                   	push   %edi
  801dc8:	56                   	push   %esi
  801dc9:	53                   	push   %ebx
  801dca:	83 ec 18             	sub    $0x18,%esp
  801dcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dd0:	57                   	push   %edi
  801dd1:	e8 0c f2 ff ff       	call   800fe2 <fd2data>
  801dd6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	be 00 00 00 00       	mov    $0x0,%esi
  801de0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801de3:	75 14                	jne    801df9 <devpipe_read+0x35>
	return i;
  801de5:	8b 45 10             	mov    0x10(%ebp),%eax
  801de8:	eb 02                	jmp    801dec <devpipe_read+0x28>
				return i;
  801dea:	89 f0                	mov    %esi,%eax
}
  801dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
			sys_yield();
  801df4:	e8 9f ee ff ff       	call   800c98 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801df9:	8b 03                	mov    (%ebx),%eax
  801dfb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dfe:	75 18                	jne    801e18 <devpipe_read+0x54>
			if (i > 0)
  801e00:	85 f6                	test   %esi,%esi
  801e02:	75 e6                	jne    801dea <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e04:	89 da                	mov    %ebx,%edx
  801e06:	89 f8                	mov    %edi,%eax
  801e08:	e8 d0 fe ff ff       	call   801cdd <_pipeisclosed>
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	74 e3                	je     801df4 <devpipe_read+0x30>
				return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
  801e16:	eb d4                	jmp    801dec <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e18:	99                   	cltd   
  801e19:	c1 ea 1b             	shr    $0x1b,%edx
  801e1c:	01 d0                	add    %edx,%eax
  801e1e:	83 e0 1f             	and    $0x1f,%eax
  801e21:	29 d0                	sub    %edx,%eax
  801e23:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e2b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e2e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e31:	83 c6 01             	add    $0x1,%esi
  801e34:	eb aa                	jmp    801de0 <devpipe_read+0x1c>

00801e36 <pipe>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	56                   	push   %esi
  801e3a:	53                   	push   %ebx
  801e3b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e41:	50                   	push   %eax
  801e42:	e8 b2 f1 ff ff       	call   800ff9 <fd_alloc>
  801e47:	89 c3                	mov    %eax,%ebx
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	0f 88 23 01 00 00    	js     801f77 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	68 07 04 00 00       	push   $0x407
  801e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5f:	6a 00                	push   $0x0
  801e61:	e8 51 ee ff ff       	call   800cb7 <sys_page_alloc>
  801e66:	89 c3                	mov    %eax,%ebx
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	0f 88 04 01 00 00    	js     801f77 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e79:	50                   	push   %eax
  801e7a:	e8 7a f1 ff ff       	call   800ff9 <fd_alloc>
  801e7f:	89 c3                	mov    %eax,%ebx
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	0f 88 db 00 00 00    	js     801f67 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	68 07 04 00 00       	push   $0x407
  801e94:	ff 75 f0             	pushl  -0x10(%ebp)
  801e97:	6a 00                	push   $0x0
  801e99:	e8 19 ee ff ff       	call   800cb7 <sys_page_alloc>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	0f 88 bc 00 00 00    	js     801f67 <pipe+0x131>
	va = fd2data(fd0);
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb1:	e8 2c f1 ff ff       	call   800fe2 <fd2data>
  801eb6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb8:	83 c4 0c             	add    $0xc,%esp
  801ebb:	68 07 04 00 00       	push   $0x407
  801ec0:	50                   	push   %eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	e8 ef ed ff ff       	call   800cb7 <sys_page_alloc>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	0f 88 82 00 00 00    	js     801f57 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	ff 75 f0             	pushl  -0x10(%ebp)
  801edb:	e8 02 f1 ff ff       	call   800fe2 <fd2data>
  801ee0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ee7:	50                   	push   %eax
  801ee8:	6a 00                	push   $0x0
  801eea:	56                   	push   %esi
  801eeb:	6a 00                	push   $0x0
  801eed:	e8 08 ee ff ff       	call   800cfa <sys_page_map>
  801ef2:	89 c3                	mov    %eax,%ebx
  801ef4:	83 c4 20             	add    $0x20,%esp
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 4e                	js     801f49 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801efb:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f03:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f08:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f12:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	ff 75 f4             	pushl  -0xc(%ebp)
  801f24:	e8 a9 f0 ff ff       	call   800fd2 <fd2num>
  801f29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f2e:	83 c4 04             	add    $0x4,%esp
  801f31:	ff 75 f0             	pushl  -0x10(%ebp)
  801f34:	e8 99 f0 ff ff       	call   800fd2 <fd2num>
  801f39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f47:	eb 2e                	jmp    801f77 <pipe+0x141>
	sys_page_unmap(0, va);
  801f49:	83 ec 08             	sub    $0x8,%esp
  801f4c:	56                   	push   %esi
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 e8 ed ff ff       	call   800d3c <sys_page_unmap>
  801f54:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5d:	6a 00                	push   $0x0
  801f5f:	e8 d8 ed ff ff       	call   800d3c <sys_page_unmap>
  801f64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f67:	83 ec 08             	sub    $0x8,%esp
  801f6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 c8 ed ff ff       	call   800d3c <sys_page_unmap>
  801f74:	83 c4 10             	add    $0x10,%esp
}
  801f77:	89 d8                	mov    %ebx,%eax
  801f79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5d                   	pop    %ebp
  801f7f:	c3                   	ret    

00801f80 <pipeisclosed>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	e8 b9 f0 ff ff       	call   80104b <fd_lookup>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 18                	js     801fb1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9f:	e8 3e f0 ff ff       	call   800fe2 <fd2data>
	return _pipeisclosed(fd, p);
  801fa4:	89 c2                	mov    %eax,%edx
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	e8 2f fd ff ff       	call   801cdd <_pipeisclosed>
  801fae:	83 c4 10             	add    $0x10,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	c3                   	ret    

00801fb9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fbf:	68 8f 2a 80 00       	push   $0x802a8f
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	e8 f9 e8 ff ff       	call   8008c5 <strcpy>
	return 0;
}
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <devcons_write>:
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	57                   	push   %edi
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fdf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fea:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fed:	73 31                	jae    802020 <devcons_write+0x4d>
		m = n - tot;
  801fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff2:	29 f3                	sub    %esi,%ebx
  801ff4:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ffc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	53                   	push   %ebx
  802003:	89 f0                	mov    %esi,%eax
  802005:	03 45 0c             	add    0xc(%ebp),%eax
  802008:	50                   	push   %eax
  802009:	57                   	push   %edi
  80200a:	e8 44 ea ff ff       	call   800a53 <memmove>
		sys_cputs(buf, m);
  80200f:	83 c4 08             	add    $0x8,%esp
  802012:	53                   	push   %ebx
  802013:	57                   	push   %edi
  802014:	e8 e2 eb ff ff       	call   800bfb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802019:	01 de                	add    %ebx,%esi
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	eb ca                	jmp    801fea <devcons_write+0x17>
}
  802020:	89 f0                	mov    %esi,%eax
  802022:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802025:	5b                   	pop    %ebx
  802026:	5e                   	pop    %esi
  802027:	5f                   	pop    %edi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <devcons_read>:
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802039:	74 21                	je     80205c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80203b:	e8 d9 eb ff ff       	call   800c19 <sys_cgetc>
  802040:	85 c0                	test   %eax,%eax
  802042:	75 07                	jne    80204b <devcons_read+0x21>
		sys_yield();
  802044:	e8 4f ec ff ff       	call   800c98 <sys_yield>
  802049:	eb f0                	jmp    80203b <devcons_read+0x11>
	if (c < 0)
  80204b:	78 0f                	js     80205c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80204d:	83 f8 04             	cmp    $0x4,%eax
  802050:	74 0c                	je     80205e <devcons_read+0x34>
	*(char*)vbuf = c;
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	88 02                	mov    %al,(%edx)
	return 1;
  802057:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	eb f7                	jmp    80205c <devcons_read+0x32>

00802065 <cputchar>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802071:	6a 01                	push   $0x1
  802073:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802076:	50                   	push   %eax
  802077:	e8 7f eb ff ff       	call   800bfb <sys_cputs>
}
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <getchar>:
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802087:	6a 01                	push   $0x1
  802089:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80208c:	50                   	push   %eax
  80208d:	6a 00                	push   $0x0
  80208f:	e8 27 f2 ff ff       	call   8012bb <read>
	if (r < 0)
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	85 c0                	test   %eax,%eax
  802099:	78 06                	js     8020a1 <getchar+0x20>
	if (r < 1)
  80209b:	74 06                	je     8020a3 <getchar+0x22>
	return c;
  80209d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    
		return -E_EOF;
  8020a3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020a8:	eb f7                	jmp    8020a1 <getchar+0x20>

008020aa <iscons>:
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b3:	50                   	push   %eax
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	e8 8f ef ff ff       	call   80104b <fd_lookup>
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	78 11                	js     8020d4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020cc:	39 10                	cmp    %edx,(%eax)
  8020ce:	0f 94 c0             	sete   %al
  8020d1:	0f b6 c0             	movzbl %al,%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <opencons>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020df:	50                   	push   %eax
  8020e0:	e8 14 ef ff ff       	call   800ff9 <fd_alloc>
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 3a                	js     802126 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 07 04 00 00       	push   $0x407
  8020f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f7:	6a 00                	push   $0x0
  8020f9:	e8 b9 eb ff ff       	call   800cb7 <sys_page_alloc>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	85 c0                	test   %eax,%eax
  802103:	78 21                	js     802126 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80210e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	50                   	push   %eax
  80211e:	e8 af ee ff ff       	call   800fd2 <fd2num>
  802123:	83 c4 10             	add    $0x10,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	56                   	push   %esi
  80212c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80212d:	a1 08 40 80 00       	mov    0x804008,%eax
  802132:	8b 40 48             	mov    0x48(%eax),%eax
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 c0 2a 80 00       	push   $0x802ac0
  80213d:	50                   	push   %eax
  80213e:	68 aa 25 80 00       	push   $0x8025aa
  802143:	e8 1e e0 ff ff       	call   800166 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802148:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80214b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802151:	e8 23 eb ff ff       	call   800c79 <sys_getenvid>
  802156:	83 c4 04             	add    $0x4,%esp
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	ff 75 08             	pushl  0x8(%ebp)
  80215f:	56                   	push   %esi
  802160:	50                   	push   %eax
  802161:	68 9c 2a 80 00       	push   $0x802a9c
  802166:	e8 fb df ff ff       	call   800166 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80216b:	83 c4 18             	add    $0x18,%esp
  80216e:	53                   	push   %ebx
  80216f:	ff 75 10             	pushl  0x10(%ebp)
  802172:	e8 9e df ff ff       	call   800115 <vcprintf>
	cprintf("\n");
  802177:	c7 04 24 55 2b 80 00 	movl   $0x802b55,(%esp)
  80217e:	e8 e3 df ff ff       	call   800166 <cprintf>
  802183:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802186:	cc                   	int3   
  802187:	eb fd                	jmp    802186 <_panic+0x5e>

00802189 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80218f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802196:	74 0a                	je     8021a2 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	6a 07                	push   $0x7
  8021a7:	68 00 f0 bf ee       	push   $0xeebff000
  8021ac:	6a 00                	push   $0x0
  8021ae:	e8 04 eb ff ff       	call   800cb7 <sys_page_alloc>
		if(r < 0)
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 2a                	js     8021e4 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8021ba:	83 ec 08             	sub    $0x8,%esp
  8021bd:	68 ac 0f 80 00       	push   $0x800fac
  8021c2:	6a 00                	push   $0x0
  8021c4:	e8 39 ec ff ff       	call   800e02 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	79 c8                	jns    802198 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 f8 2a 80 00       	push   $0x802af8
  8021d8:	6a 25                	push   $0x25
  8021da:	68 34 2b 80 00       	push   $0x802b34
  8021df:	e8 44 ff ff ff       	call   802128 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	68 c8 2a 80 00       	push   $0x802ac8
  8021ec:	6a 22                	push   $0x22
  8021ee:	68 34 2b 80 00       	push   $0x802b34
  8021f3:	e8 30 ff ff ff       	call   802128 <_panic>

008021f8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	56                   	push   %esi
  8021fc:	53                   	push   %ebx
  8021fd:	8b 75 08             	mov    0x8(%ebp),%esi
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802206:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802208:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80220d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	50                   	push   %eax
  802214:	e8 4e ec ff ff       	call   800e67 <sys_ipc_recv>
	if(ret < 0){
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	85 c0                	test   %eax,%eax
  80221e:	78 2b                	js     80224b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802220:	85 f6                	test   %esi,%esi
  802222:	74 0a                	je     80222e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802224:	a1 08 40 80 00       	mov    0x804008,%eax
  802229:	8b 40 78             	mov    0x78(%eax),%eax
  80222c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80222e:	85 db                	test   %ebx,%ebx
  802230:	74 0a                	je     80223c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802232:	a1 08 40 80 00       	mov    0x804008,%eax
  802237:	8b 40 7c             	mov    0x7c(%eax),%eax
  80223a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80223c:	a1 08 40 80 00       	mov    0x804008,%eax
  802241:	8b 40 74             	mov    0x74(%eax),%eax
}
  802244:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5d                   	pop    %ebp
  80224a:	c3                   	ret    
		if(from_env_store)
  80224b:	85 f6                	test   %esi,%esi
  80224d:	74 06                	je     802255 <ipc_recv+0x5d>
			*from_env_store = 0;
  80224f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802255:	85 db                	test   %ebx,%ebx
  802257:	74 eb                	je     802244 <ipc_recv+0x4c>
			*perm_store = 0;
  802259:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80225f:	eb e3                	jmp    802244 <ipc_recv+0x4c>

00802261 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	57                   	push   %edi
  802265:	56                   	push   %esi
  802266:	53                   	push   %ebx
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80226d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802270:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802273:	85 db                	test   %ebx,%ebx
  802275:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80227a:	0f 44 d8             	cmove  %eax,%ebx
  80227d:	eb 05                	jmp    802284 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80227f:	e8 14 ea ff ff       	call   800c98 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802284:	ff 75 14             	pushl  0x14(%ebp)
  802287:	53                   	push   %ebx
  802288:	56                   	push   %esi
  802289:	57                   	push   %edi
  80228a:	e8 b5 eb ff ff       	call   800e44 <sys_ipc_try_send>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	85 c0                	test   %eax,%eax
  802294:	74 1b                	je     8022b1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802296:	79 e7                	jns    80227f <ipc_send+0x1e>
  802298:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80229b:	74 e2                	je     80227f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	68 42 2b 80 00       	push   $0x802b42
  8022a5:	6a 46                	push   $0x46
  8022a7:	68 57 2b 80 00       	push   $0x802b57
  8022ac:	e8 77 fe ff ff       	call   802128 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022c4:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022ca:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022d0:	8b 52 50             	mov    0x50(%edx),%edx
  8022d3:	39 ca                	cmp    %ecx,%edx
  8022d5:	74 11                	je     8022e8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022d7:	83 c0 01             	add    $0x1,%eax
  8022da:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022df:	75 e3                	jne    8022c4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e6:	eb 0e                	jmp    8022f6 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022e8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022f3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    

008022f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022fe:	89 d0                	mov    %edx,%eax
  802300:	c1 e8 16             	shr    $0x16,%eax
  802303:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80230f:	f6 c1 01             	test   $0x1,%cl
  802312:	74 1d                	je     802331 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802314:	c1 ea 0c             	shr    $0xc,%edx
  802317:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80231e:	f6 c2 01             	test   $0x1,%dl
  802321:	74 0e                	je     802331 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802323:	c1 ea 0c             	shr    $0xc,%edx
  802326:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80232d:	ef 
  80232e:	0f b7 c0             	movzwl %ax,%eax
}
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    
  802333:	66 90                	xchg   %ax,%ax
  802335:	66 90                	xchg   %ax,%ax
  802337:	66 90                	xchg   %ax,%ax
  802339:	66 90                	xchg   %ax,%ax
  80233b:	66 90                	xchg   %ax,%ax
  80233d:	66 90                	xchg   %ax,%ax
  80233f:	90                   	nop

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80234b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802357:	85 d2                	test   %edx,%edx
  802359:	75 4d                	jne    8023a8 <__udivdi3+0x68>
  80235b:	39 f3                	cmp    %esi,%ebx
  80235d:	76 19                	jbe    802378 <__udivdi3+0x38>
  80235f:	31 ff                	xor    %edi,%edi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f2                	mov    %esi,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 d9                	mov    %ebx,%ecx
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	75 0b                	jne    802389 <__udivdi3+0x49>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 c1                	mov    %eax,%ecx
  802389:	31 d2                	xor    %edx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	f7 f1                	div    %ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f7                	mov    %esi,%edi
  802395:	f7 f1                	div    %ecx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 f2                	cmp    %esi,%edx
  8023aa:	77 1c                	ja     8023c8 <__udivdi3+0x88>
  8023ac:	0f bd fa             	bsr    %edx,%edi
  8023af:	83 f7 1f             	xor    $0x1f,%edi
  8023b2:	75 2c                	jne    8023e0 <__udivdi3+0xa0>
  8023b4:	39 f2                	cmp    %esi,%edx
  8023b6:	72 06                	jb     8023be <__udivdi3+0x7e>
  8023b8:	31 c0                	xor    %eax,%eax
  8023ba:	39 eb                	cmp    %ebp,%ebx
  8023bc:	77 a9                	ja     802367 <__udivdi3+0x27>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	eb a2                	jmp    802367 <__udivdi3+0x27>
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	31 c0                	xor    %eax,%eax
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 f9                	mov    %edi,%ecx
  8023e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e7:	29 f8                	sub    %edi,%eax
  8023e9:	d3 e2                	shl    %cl,%edx
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	d3 ea                	shr    %cl,%edx
  8023f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f9:	09 d1                	or     %edx,%ecx
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e3                	shl    %cl,%ebx
  802405:	89 c1                	mov    %eax,%ecx
  802407:	d3 ea                	shr    %cl,%edx
  802409:	89 f9                	mov    %edi,%ecx
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	89 eb                	mov    %ebp,%ebx
  802411:	d3 e6                	shl    %cl,%esi
  802413:	89 c1                	mov    %eax,%ecx
  802415:	d3 eb                	shr    %cl,%ebx
  802417:	09 de                	or     %ebx,%esi
  802419:	89 f0                	mov    %esi,%eax
  80241b:	f7 74 24 08          	divl   0x8(%esp)
  80241f:	89 d6                	mov    %edx,%esi
  802421:	89 c3                	mov    %eax,%ebx
  802423:	f7 64 24 0c          	mull   0xc(%esp)
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 15                	jb     802440 <__udivdi3+0x100>
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e5                	shl    %cl,%ebp
  80242f:	39 c5                	cmp    %eax,%ebp
  802431:	73 04                	jae    802437 <__udivdi3+0xf7>
  802433:	39 d6                	cmp    %edx,%esi
  802435:	74 09                	je     802440 <__udivdi3+0x100>
  802437:	89 d8                	mov    %ebx,%eax
  802439:	31 ff                	xor    %edi,%edi
  80243b:	e9 27 ff ff ff       	jmp    802367 <__udivdi3+0x27>
  802440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 1d ff ff ff       	jmp    802367 <__udivdi3+0x27>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	89 da                	mov    %ebx,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 43                	jne    8024b0 <__umoddi3+0x60>
  80246d:	39 df                	cmp    %ebx,%edi
  80246f:	76 17                	jbe    802488 <__umoddi3+0x38>
  802471:	89 f0                	mov    %esi,%eax
  802473:	f7 f7                	div    %edi
  802475:	89 d0                	mov    %edx,%eax
  802477:	31 d2                	xor    %edx,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 f0                	mov    %esi,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	eb d0                	jmp    802477 <__umoddi3+0x27>
  8024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	89 f1                	mov    %esi,%ecx
  8024b2:	39 d8                	cmp    %ebx,%eax
  8024b4:	76 0a                	jbe    8024c0 <__umoddi3+0x70>
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	0f bd e8             	bsr    %eax,%ebp
  8024c3:	83 f5 1f             	xor    $0x1f,%ebp
  8024c6:	75 20                	jne    8024e8 <__umoddi3+0x98>
  8024c8:	39 d8                	cmp    %ebx,%eax
  8024ca:	0f 82 b0 00 00 00    	jb     802580 <__umoddi3+0x130>
  8024d0:	39 f7                	cmp    %esi,%edi
  8024d2:	0f 86 a8 00 00 00    	jbe    802580 <__umoddi3+0x130>
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0xfb>
  802545:	75 10                	jne    802557 <__umoddi3+0x107>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x107>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 da                	mov    %ebx,%edx
  802582:	29 fe                	sub    %edi,%esi
  802584:	19 c2                	sbb    %eax,%edx
  802586:	89 f1                	mov    %esi,%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	e9 4b ff ff ff       	jmp    8024da <__umoddi3+0x8a>
