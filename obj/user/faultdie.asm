
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 5a 00 00 00       	call   80008b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("in faultdie %s\n", __FUNCTION__);
  800039:	68 d0 25 80 00       	push   $0x8025d0
  80003e:	68 c0 25 80 00       	push   $0x8025c0
  800043:	e8 55 01 00 00       	call   80019d <cprintf>
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("in %s\n", __FUNCTION__);
  800048:	83 c4 08             	add    $0x8,%esp
  80004b:	68 d0 25 80 00       	push   $0x8025d0
  800050:	68 e6 25 80 00       	push   $0x8025e6
  800055:	e8 43 01 00 00       	call   80019d <cprintf>
	sys_env_destroy(sys_getenvid());
  80005a:	e8 51 0c 00 00       	call   800cb0 <sys_getenvid>
  80005f:	89 04 24             	mov    %eax,(%esp)
  800062:	e8 08 0c 00 00       	call   800c6f <sys_env_destroy>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	c9                   	leave  
  80006b:	c3                   	ret    

0080006c <umain>:

void
umain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800072:	68 33 00 80 00       	push   $0x800033
  800077:	e8 67 0f 00 00       	call   800fe3 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  80007c:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800083:	00 00 00 
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	c9                   	leave  
  80008a:	c3                   	ret    

0080008b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800093:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800096:	e8 15 0c 00 00       	call   800cb0 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80009b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ab:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b0:	85 db                	test   %ebx,%ebx
  8000b2:	7e 07                	jle    8000bb <libmain+0x30>
		binaryname = argv[0];
  8000b4:	8b 06                	mov    (%esi),%eax
  8000b6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
  8000c0:	e8 a7 ff ff ff       	call   80006c <umain>

	// exit gracefully
	exit();
  8000c5:	e8 0a 00 00 00       	call   8000d4 <exit>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000da:	a1 08 40 80 00       	mov    0x804008,%eax
  8000df:	8b 40 48             	mov    0x48(%eax),%eax
  8000e2:	68 f0 25 80 00       	push   $0x8025f0
  8000e7:	50                   	push   %eax
  8000e8:	68 e2 25 80 00       	push   $0x8025e2
  8000ed:	e8 ab 00 00 00       	call   80019d <cprintf>
	close_all();
  8000f2:	e8 59 11 00 00       	call   801250 <close_all>
	sys_env_destroy(0);
  8000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fe:	e8 6c 0b 00 00       	call   800c6f <sys_env_destroy>
}
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	c9                   	leave  
  800107:	c3                   	ret    

00800108 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	53                   	push   %ebx
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800112:	8b 13                	mov    (%ebx),%edx
  800114:	8d 42 01             	lea    0x1(%edx),%eax
  800117:	89 03                	mov    %eax,(%ebx)
  800119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800120:	3d ff 00 00 00       	cmp    $0xff,%eax
  800125:	74 09                	je     800130 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800127:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	68 ff 00 00 00       	push   $0xff
  800138:	8d 43 08             	lea    0x8(%ebx),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 f1 0a 00 00       	call   800c32 <sys_cputs>
		b->idx = 0;
  800141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	eb db                	jmp    800127 <putch+0x1f>

0080014c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800155:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015c:	00 00 00 
	b.cnt = 0;
  80015f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800166:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800175:	50                   	push   %eax
  800176:	68 08 01 80 00       	push   $0x800108
  80017b:	e8 4a 01 00 00       	call   8002ca <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800180:	83 c4 08             	add    $0x8,%esp
  800183:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800189:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018f:	50                   	push   %eax
  800190:	e8 9d 0a 00 00       	call   800c32 <sys_cputs>

	return b.cnt;
}
  800195:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a6:	50                   	push   %eax
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 9d ff ff ff       	call   80014c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	57                   	push   %edi
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
  8001b7:	83 ec 1c             	sub    $0x1c,%esp
  8001ba:	89 c6                	mov    %eax,%esi
  8001bc:	89 d7                	mov    %edx,%edi
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001d0:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001d4:	74 2c                	je     800202 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e6:	39 c2                	cmp    %eax,%edx
  8001e8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001eb:	73 43                	jae    800230 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ed:	83 eb 01             	sub    $0x1,%ebx
  8001f0:	85 db                	test   %ebx,%ebx
  8001f2:	7e 6c                	jle    800260 <printnum+0xaf>
				putch(padc, putdat);
  8001f4:	83 ec 08             	sub    $0x8,%esp
  8001f7:	57                   	push   %edi
  8001f8:	ff 75 18             	pushl  0x18(%ebp)
  8001fb:	ff d6                	call   *%esi
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	eb eb                	jmp    8001ed <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	6a 20                	push   $0x20
  800207:	6a 00                	push   $0x0
  800209:	50                   	push   %eax
  80020a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020d:	ff 75 e0             	pushl  -0x20(%ebp)
  800210:	89 fa                	mov    %edi,%edx
  800212:	89 f0                	mov    %esi,%eax
  800214:	e8 98 ff ff ff       	call   8001b1 <printnum>
		while (--width > 0)
  800219:	83 c4 20             	add    $0x20,%esp
  80021c:	83 eb 01             	sub    $0x1,%ebx
  80021f:	85 db                	test   %ebx,%ebx
  800221:	7e 65                	jle    800288 <printnum+0xd7>
			putch(padc, putdat);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	57                   	push   %edi
  800227:	6a 20                	push   $0x20
  800229:	ff d6                	call   *%esi
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	eb ec                	jmp    80021c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	ff 75 18             	pushl  0x18(%ebp)
  800236:	83 eb 01             	sub    $0x1,%ebx
  800239:	53                   	push   %ebx
  80023a:	50                   	push   %eax
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	ff 75 dc             	pushl  -0x24(%ebp)
  800241:	ff 75 d8             	pushl  -0x28(%ebp)
  800244:	ff 75 e4             	pushl  -0x1c(%ebp)
  800247:	ff 75 e0             	pushl  -0x20(%ebp)
  80024a:	e8 21 21 00 00       	call   802370 <__udivdi3>
  80024f:	83 c4 18             	add    $0x18,%esp
  800252:	52                   	push   %edx
  800253:	50                   	push   %eax
  800254:	89 fa                	mov    %edi,%edx
  800256:	89 f0                	mov    %esi,%eax
  800258:	e8 54 ff ff ff       	call   8001b1 <printnum>
  80025d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	57                   	push   %edi
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	ff 75 dc             	pushl  -0x24(%ebp)
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	e8 08 22 00 00       	call   802480 <__umoddi3>
  800278:	83 c4 14             	add    $0x14,%esp
  80027b:	0f be 80 f5 25 80 00 	movsbl 0x8025f5(%eax),%eax
  800282:	50                   	push   %eax
  800283:	ff d6                	call   *%esi
  800285:	83 c4 10             	add    $0x10,%esp
	}
}
  800288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028b:	5b                   	pop    %ebx
  80028c:	5e                   	pop    %esi
  80028d:	5f                   	pop    %edi
  80028e:	5d                   	pop    %ebp
  80028f:	c3                   	ret    

00800290 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800296:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029a:	8b 10                	mov    (%eax),%edx
  80029c:	3b 50 04             	cmp    0x4(%eax),%edx
  80029f:	73 0a                	jae    8002ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a4:	89 08                	mov    %ecx,(%eax)
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	88 02                	mov    %al,(%edx)
}
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    

008002ad <printfmt>:
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 10             	pushl  0x10(%ebp)
  8002ba:	ff 75 0c             	pushl  0xc(%ebp)
  8002bd:	ff 75 08             	pushl  0x8(%ebp)
  8002c0:	e8 05 00 00 00       	call   8002ca <vprintfmt>
}
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <vprintfmt>:
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	57                   	push   %edi
  8002ce:	56                   	push   %esi
  8002cf:	53                   	push   %ebx
  8002d0:	83 ec 3c             	sub    $0x3c,%esp
  8002d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002dc:	e9 32 04 00 00       	jmp    800713 <vprintfmt+0x449>
		padc = ' ';
  8002e1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002ec:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800301:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800308:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8d 47 01             	lea    0x1(%edi),%eax
  800310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800313:	0f b6 17             	movzbl (%edi),%edx
  800316:	8d 42 dd             	lea    -0x23(%edx),%eax
  800319:	3c 55                	cmp    $0x55,%al
  80031b:	0f 87 12 05 00 00    	ja     800833 <vprintfmt+0x569>
  800321:	0f b6 c0             	movzbl %al,%eax
  800324:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  80032b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800332:	eb d9                	jmp    80030d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800334:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800337:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80033b:	eb d0                	jmp    80030d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	0f b6 d2             	movzbl %dl,%edx
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800343:	b8 00 00 00 00       	mov    $0x0,%eax
  800348:	89 75 08             	mov    %esi,0x8(%ebp)
  80034b:	eb 03                	jmp    800350 <vprintfmt+0x86>
  80034d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800350:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800353:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800357:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80035a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035d:	83 fe 09             	cmp    $0x9,%esi
  800360:	76 eb                	jbe    80034d <vprintfmt+0x83>
  800362:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800365:	8b 75 08             	mov    0x8(%ebp),%esi
  800368:	eb 14                	jmp    80037e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80036a:	8b 45 14             	mov    0x14(%ebp),%eax
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8d 40 04             	lea    0x4(%eax),%eax
  800378:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800382:	79 89                	jns    80030d <vprintfmt+0x43>
				width = precision, precision = -1;
  800384:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800387:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80038a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800391:	e9 77 ff ff ff       	jmp    80030d <vprintfmt+0x43>
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	85 c0                	test   %eax,%eax
  80039b:	0f 48 c1             	cmovs  %ecx,%eax
  80039e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a4:	e9 64 ff ff ff       	jmp    80030d <vprintfmt+0x43>
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ac:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b3:	e9 55 ff ff ff       	jmp    80030d <vprintfmt+0x43>
			lflag++;
  8003b8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bf:	e9 49 ff ff ff       	jmp    80030d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8d 78 04             	lea    0x4(%eax),%edi
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	53                   	push   %ebx
  8003ce:	ff 30                	pushl  (%eax)
  8003d0:	ff d6                	call   *%esi
			break;
  8003d2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d8:	e9 33 03 00 00       	jmp    800710 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8d 78 04             	lea    0x4(%eax),%edi
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	99                   	cltd   
  8003e6:	31 d0                	xor    %edx,%eax
  8003e8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ea:	83 f8 11             	cmp    $0x11,%eax
  8003ed:	7f 23                	jg     800412 <vprintfmt+0x148>
  8003ef:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	74 18                	je     800412 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003fa:	52                   	push   %edx
  8003fb:	68 d5 2a 80 00       	push   $0x802ad5
  800400:	53                   	push   %ebx
  800401:	56                   	push   %esi
  800402:	e8 a6 fe ff ff       	call   8002ad <printfmt>
  800407:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040d:	e9 fe 02 00 00       	jmp    800710 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800412:	50                   	push   %eax
  800413:	68 0d 26 80 00       	push   $0x80260d
  800418:	53                   	push   %ebx
  800419:	56                   	push   %esi
  80041a:	e8 8e fe ff ff       	call   8002ad <printfmt>
  80041f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800422:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800425:	e9 e6 02 00 00       	jmp    800710 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	83 c0 04             	add    $0x4,%eax
  800430:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800433:	8b 45 14             	mov    0x14(%ebp),%eax
  800436:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800438:	85 c9                	test   %ecx,%ecx
  80043a:	b8 06 26 80 00       	mov    $0x802606,%eax
  80043f:	0f 45 c1             	cmovne %ecx,%eax
  800442:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800445:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800449:	7e 06                	jle    800451 <vprintfmt+0x187>
  80044b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80044f:	75 0d                	jne    80045e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800451:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800454:	89 c7                	mov    %eax,%edi
  800456:	03 45 e0             	add    -0x20(%ebp),%eax
  800459:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045c:	eb 53                	jmp    8004b1 <vprintfmt+0x1e7>
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 d8             	pushl  -0x28(%ebp)
  800464:	50                   	push   %eax
  800465:	e8 71 04 00 00       	call   8008db <strnlen>
  80046a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046d:	29 c1                	sub    %eax,%ecx
  80046f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800472:	83 c4 10             	add    $0x10,%esp
  800475:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800477:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80047b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	eb 0f                	jmp    80048f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	ff 75 e0             	pushl  -0x20(%ebp)
  800487:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800489:	83 ef 01             	sub    $0x1,%edi
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	85 ff                	test   %edi,%edi
  800491:	7f ed                	jg     800480 <vprintfmt+0x1b6>
  800493:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800496:	85 c9                	test   %ecx,%ecx
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	0f 49 c1             	cmovns %ecx,%eax
  8004a0:	29 c1                	sub    %eax,%ecx
  8004a2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a5:	eb aa                	jmp    800451 <vprintfmt+0x187>
					putch(ch, putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	52                   	push   %edx
  8004ac:	ff d6                	call   *%esi
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b6:	83 c7 01             	add    $0x1,%edi
  8004b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004bd:	0f be d0             	movsbl %al,%edx
  8004c0:	85 d2                	test   %edx,%edx
  8004c2:	74 4b                	je     80050f <vprintfmt+0x245>
  8004c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c8:	78 06                	js     8004d0 <vprintfmt+0x206>
  8004ca:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ce:	78 1e                	js     8004ee <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d4:	74 d1                	je     8004a7 <vprintfmt+0x1dd>
  8004d6:	0f be c0             	movsbl %al,%eax
  8004d9:	83 e8 20             	sub    $0x20,%eax
  8004dc:	83 f8 5e             	cmp    $0x5e,%eax
  8004df:	76 c6                	jbe    8004a7 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	53                   	push   %ebx
  8004e5:	6a 3f                	push   $0x3f
  8004e7:	ff d6                	call   *%esi
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	eb c3                	jmp    8004b1 <vprintfmt+0x1e7>
  8004ee:	89 cf                	mov    %ecx,%edi
  8004f0:	eb 0e                	jmp    800500 <vprintfmt+0x236>
				putch(' ', putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	53                   	push   %ebx
  8004f6:	6a 20                	push   $0x20
  8004f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ee                	jg     8004f2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 01 02 00 00       	jmp    800710 <vprintfmt+0x446>
  80050f:	89 cf                	mov    %ecx,%edi
  800511:	eb ed                	jmp    800500 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800516:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80051d:	e9 eb fd ff ff       	jmp    80030d <vprintfmt+0x43>
	if (lflag >= 2)
  800522:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800526:	7f 21                	jg     800549 <vprintfmt+0x27f>
	else if (lflag)
  800528:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80052c:	74 68                	je     800596 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800536:	89 c1                	mov    %eax,%ecx
  800538:	c1 f9 1f             	sar    $0x1f,%ecx
  80053b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8d 40 04             	lea    0x4(%eax),%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	eb 17                	jmp    800560 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8b 50 04             	mov    0x4(%eax),%edx
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800554:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 08             	lea    0x8(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800560:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800563:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800569:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80056c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800570:	78 3f                	js     8005b1 <vprintfmt+0x2e7>
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800577:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80057b:	0f 84 71 01 00 00    	je     8006f2 <vprintfmt+0x428>
				putch('+', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 2b                	push   $0x2b
  800587:	ff d6                	call   *%esi
  800589:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800591:	e9 5c 01 00 00       	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059e:	89 c1                	mov    %eax,%ecx
  8005a0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8005af:	eb af                	jmp    800560 <vprintfmt+0x296>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bf:	f7 d8                	neg    %eax
  8005c1:	83 d2 00             	adc    $0x0,%edx
  8005c4:	f7 da                	neg    %edx
  8005c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d4:	e9 19 01 00 00       	jmp    8006f2 <vprintfmt+0x428>
	if (lflag >= 2)
  8005d9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005dd:	7f 29                	jg     800608 <vprintfmt+0x33e>
	else if (lflag)
  8005df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e3:	74 44                	je     800629 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
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
  800603:	e9 ea 00 00 00       	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 50 04             	mov    0x4(%eax),%edx
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800613:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8d 40 08             	lea    0x8(%eax),%eax
  80061c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800624:	e9 c9 00 00 00       	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	ba 00 00 00 00       	mov    $0x0,%edx
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800642:	b8 0a 00 00 00       	mov    $0xa,%eax
  800647:	e9 a6 00 00 00       	jmp    8006f2 <vprintfmt+0x428>
			putch('0', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 30                	push   $0x30
  800652:	ff d6                	call   *%esi
	if (lflag >= 2)
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80065b:	7f 26                	jg     800683 <vprintfmt+0x3b9>
	else if (lflag)
  80065d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800661:	74 3e                	je     8006a1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067c:	b8 08 00 00 00       	mov    $0x8,%eax
  800681:	eb 6f                	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069a:	b8 08 00 00 00       	mov    $0x8,%eax
  80069f:	eb 51                	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ba:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bf:	eb 31                	jmp    8006f2 <vprintfmt+0x428>
			putch('0', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 30                	push   $0x30
  8006c7:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c9:	83 c4 08             	add    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 78                	push   $0x78
  8006cf:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006e1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f9:	52                   	push   %edx
  8006fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800701:	ff 75 d8             	pushl  -0x28(%ebp)
  800704:	89 da                	mov    %ebx,%edx
  800706:	89 f0                	mov    %esi,%eax
  800708:	e8 a4 fa ff ff       	call   8001b1 <printnum>
			break;
  80070d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800710:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	83 c7 01             	add    $0x1,%edi
  800716:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071a:	83 f8 25             	cmp    $0x25,%eax
  80071d:	0f 84 be fb ff ff    	je     8002e1 <vprintfmt+0x17>
			if (ch == '\0')
  800723:	85 c0                	test   %eax,%eax
  800725:	0f 84 28 01 00 00    	je     800853 <vprintfmt+0x589>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	50                   	push   %eax
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	eb dc                	jmp    800713 <vprintfmt+0x449>
	if (lflag >= 2)
  800737:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073b:	7f 26                	jg     800763 <vprintfmt+0x499>
	else if (lflag)
  80073d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800741:	74 41                	je     800784 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
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
  800761:	eb 8f                	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 50 04             	mov    0x4(%eax),%edx
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8d 40 08             	lea    0x8(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077a:	b8 10 00 00 00       	mov    $0x10,%eax
  80077f:	e9 6e ff ff ff       	jmp    8006f2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079d:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a2:	e9 4b ff ff ff       	jmp    8006f2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 c0 04             	add    $0x4,%eax
  8007ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	74 14                	je     8007cd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b9:	8b 13                	mov    (%ebx),%edx
  8007bb:	83 fa 7f             	cmp    $0x7f,%edx
  8007be:	7f 37                	jg     8007f7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007c0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	e9 43 ff ff ff       	jmp    800710 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	bf 29 27 80 00       	mov    $0x802729,%edi
							putch(ch, putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	53                   	push   %ebx
  8007db:	50                   	push   %eax
  8007dc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007de:	83 c7 01             	add    $0x1,%edi
  8007e1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	75 eb                	jne    8007d7 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f2:	e9 19 ff ff ff       	jmp    800710 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fe:	bf 61 27 80 00       	mov    $0x802761,%edi
							putch(ch, putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	50                   	push   %eax
  800808:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80080a:	83 c7 01             	add    $0x1,%edi
  80080d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	85 c0                	test   %eax,%eax
  800816:	75 eb                	jne    800803 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
  80081e:	e9 ed fe ff ff       	jmp    800710 <vprintfmt+0x446>
			putch(ch, putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 25                	push   $0x25
  800829:	ff d6                	call   *%esi
			break;
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	e9 dd fe ff ff       	jmp    800710 <vprintfmt+0x446>
			putch('%', putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 25                	push   $0x25
  800839:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	89 f8                	mov    %edi,%eax
  800840:	eb 03                	jmp    800845 <vprintfmt+0x57b>
  800842:	83 e8 01             	sub    $0x1,%eax
  800845:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800849:	75 f7                	jne    800842 <vprintfmt+0x578>
  80084b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084e:	e9 bd fe ff ff       	jmp    800710 <vprintfmt+0x446>
}
  800853:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800856:	5b                   	pop    %ebx
  800857:	5e                   	pop    %esi
  800858:	5f                   	pop    %edi
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	83 ec 18             	sub    $0x18,%esp
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800878:	85 c0                	test   %eax,%eax
  80087a:	74 26                	je     8008a2 <vsnprintf+0x47>
  80087c:	85 d2                	test   %edx,%edx
  80087e:	7e 22                	jle    8008a2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800880:	ff 75 14             	pushl  0x14(%ebp)
  800883:	ff 75 10             	pushl  0x10(%ebp)
  800886:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800889:	50                   	push   %eax
  80088a:	68 90 02 80 00       	push   $0x800290
  80088f:	e8 36 fa ff ff       	call   8002ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800897:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80089a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089d:	83 c4 10             	add    $0x10,%esp
}
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    
		return -E_INVAL;
  8008a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a7:	eb f7                	jmp    8008a0 <vsnprintf+0x45>

008008a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008af:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b2:	50                   	push   %eax
  8008b3:	ff 75 10             	pushl  0x10(%ebp)
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	ff 75 08             	pushl  0x8(%ebp)
  8008bc:	e8 9a ff ff ff       	call   80085b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ce:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d2:	74 05                	je     8008d9 <strlen+0x16>
		n++;
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	eb f5                	jmp    8008ce <strlen+0xb>
	return n;
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	39 c2                	cmp    %eax,%edx
  8008eb:	74 0d                	je     8008fa <strnlen+0x1f>
  8008ed:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008f1:	74 05                	je     8008f8 <strnlen+0x1d>
		n++;
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	eb f1                	jmp    8008e9 <strnlen+0xe>
  8008f8:	89 d0                	mov    %edx,%eax
	return n;
}
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	53                   	push   %ebx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800912:	83 c2 01             	add    $0x1,%edx
  800915:	84 c9                	test   %cl,%cl
  800917:	75 f2                	jne    80090b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	53                   	push   %ebx
  800920:	83 ec 10             	sub    $0x10,%esp
  800923:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800926:	53                   	push   %ebx
  800927:	e8 97 ff ff ff       	call   8008c3 <strlen>
  80092c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	01 d8                	add    %ebx,%eax
  800934:	50                   	push   %eax
  800935:	e8 c2 ff ff ff       	call   8008fc <strcpy>
	return dst;
}
  80093a:	89 d8                	mov    %ebx,%eax
  80093c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094c:	89 c6                	mov    %eax,%esi
  80094e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800951:	89 c2                	mov    %eax,%edx
  800953:	39 f2                	cmp    %esi,%edx
  800955:	74 11                	je     800968 <strncpy+0x27>
		*dst++ = *src;
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	0f b6 19             	movzbl (%ecx),%ebx
  80095d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800960:	80 fb 01             	cmp    $0x1,%bl
  800963:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800966:	eb eb                	jmp    800953 <strncpy+0x12>
	}
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5e                   	pop    %esi
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
  800971:	8b 75 08             	mov    0x8(%ebp),%esi
  800974:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800977:	8b 55 10             	mov    0x10(%ebp),%edx
  80097a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097c:	85 d2                	test   %edx,%edx
  80097e:	74 21                	je     8009a1 <strlcpy+0x35>
  800980:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800984:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800986:	39 c2                	cmp    %eax,%edx
  800988:	74 14                	je     80099e <strlcpy+0x32>
  80098a:	0f b6 19             	movzbl (%ecx),%ebx
  80098d:	84 db                	test   %bl,%bl
  80098f:	74 0b                	je     80099c <strlcpy+0x30>
			*dst++ = *src++;
  800991:	83 c1 01             	add    $0x1,%ecx
  800994:	83 c2 01             	add    $0x1,%edx
  800997:	88 5a ff             	mov    %bl,-0x1(%edx)
  80099a:	eb ea                	jmp    800986 <strlcpy+0x1a>
  80099c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a1:	29 f0                	sub    %esi,%eax
}
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b0:	0f b6 01             	movzbl (%ecx),%eax
  8009b3:	84 c0                	test   %al,%al
  8009b5:	74 0c                	je     8009c3 <strcmp+0x1c>
  8009b7:	3a 02                	cmp    (%edx),%al
  8009b9:	75 08                	jne    8009c3 <strcmp+0x1c>
		p++, q++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	eb ed                	jmp    8009b0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c3:	0f b6 c0             	movzbl %al,%eax
  8009c6:	0f b6 12             	movzbl (%edx),%edx
  8009c9:	29 d0                	sub    %edx,%eax
}
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d7:	89 c3                	mov    %eax,%ebx
  8009d9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009dc:	eb 06                	jmp    8009e4 <strncmp+0x17>
		n--, p++, q++;
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e4:	39 d8                	cmp    %ebx,%eax
  8009e6:	74 16                	je     8009fe <strncmp+0x31>
  8009e8:	0f b6 08             	movzbl (%eax),%ecx
  8009eb:	84 c9                	test   %cl,%cl
  8009ed:	74 04                	je     8009f3 <strncmp+0x26>
  8009ef:	3a 0a                	cmp    (%edx),%cl
  8009f1:	74 eb                	je     8009de <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f3:	0f b6 00             	movzbl (%eax),%eax
  8009f6:	0f b6 12             	movzbl (%edx),%edx
  8009f9:	29 d0                	sub    %edx,%eax
}
  8009fb:	5b                   	pop    %ebx
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    
		return 0;
  8009fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800a03:	eb f6                	jmp    8009fb <strncmp+0x2e>

00800a05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0f:	0f b6 10             	movzbl (%eax),%edx
  800a12:	84 d2                	test   %dl,%dl
  800a14:	74 09                	je     800a1f <strchr+0x1a>
		if (*s == c)
  800a16:	38 ca                	cmp    %cl,%dl
  800a18:	74 0a                	je     800a24 <strchr+0x1f>
	for (; *s; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f0                	jmp    800a0f <strchr+0xa>
			return (char *) s;
	return 0;
  800a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a30:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a33:	38 ca                	cmp    %cl,%dl
  800a35:	74 09                	je     800a40 <strfind+0x1a>
  800a37:	84 d2                	test   %dl,%dl
  800a39:	74 05                	je     800a40 <strfind+0x1a>
	for (; *s; s++)
  800a3b:	83 c0 01             	add    $0x1,%eax
  800a3e:	eb f0                	jmp    800a30 <strfind+0xa>
			break;
	return (char *) s;
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	57                   	push   %edi
  800a46:	56                   	push   %esi
  800a47:	53                   	push   %ebx
  800a48:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4e:	85 c9                	test   %ecx,%ecx
  800a50:	74 31                	je     800a83 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a52:	89 f8                	mov    %edi,%eax
  800a54:	09 c8                	or     %ecx,%eax
  800a56:	a8 03                	test   $0x3,%al
  800a58:	75 23                	jne    800a7d <memset+0x3b>
		c &= 0xFF;
  800a5a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5e:	89 d3                	mov    %edx,%ebx
  800a60:	c1 e3 08             	shl    $0x8,%ebx
  800a63:	89 d0                	mov    %edx,%eax
  800a65:	c1 e0 18             	shl    $0x18,%eax
  800a68:	89 d6                	mov    %edx,%esi
  800a6a:	c1 e6 10             	shl    $0x10,%esi
  800a6d:	09 f0                	or     %esi,%eax
  800a6f:	09 c2                	or     %eax,%edx
  800a71:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a73:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a76:	89 d0                	mov    %edx,%eax
  800a78:	fc                   	cld    
  800a79:	f3 ab                	rep stos %eax,%es:(%edi)
  800a7b:	eb 06                	jmp    800a83 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	fc                   	cld    
  800a81:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a83:	89 f8                	mov    %edi,%eax
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5f                   	pop    %edi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	57                   	push   %edi
  800a8e:	56                   	push   %esi
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a98:	39 c6                	cmp    %eax,%esi
  800a9a:	73 32                	jae    800ace <memmove+0x44>
  800a9c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9f:	39 c2                	cmp    %eax,%edx
  800aa1:	76 2b                	jbe    800ace <memmove+0x44>
		s += n;
		d += n;
  800aa3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa6:	89 fe                	mov    %edi,%esi
  800aa8:	09 ce                	or     %ecx,%esi
  800aaa:	09 d6                	or     %edx,%esi
  800aac:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab2:	75 0e                	jne    800ac2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab4:	83 ef 04             	sub    $0x4,%edi
  800ab7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800abd:	fd                   	std    
  800abe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac0:	eb 09                	jmp    800acb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac2:	83 ef 01             	sub    $0x1,%edi
  800ac5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac8:	fd                   	std    
  800ac9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800acb:	fc                   	cld    
  800acc:	eb 1a                	jmp    800ae8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	09 ca                	or     %ecx,%edx
  800ad2:	09 f2                	or     %esi,%edx
  800ad4:	f6 c2 03             	test   $0x3,%dl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	ff 75 10             	pushl  0x10(%ebp)
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 8a ff ff ff       	call   800a8a <memmove>
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0d:	89 c6                	mov    %eax,%esi
  800b0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b12:	39 f0                	cmp    %esi,%eax
  800b14:	74 1c                	je     800b32 <memcmp+0x30>
		if (*s1 != *s2)
  800b16:	0f b6 08             	movzbl (%eax),%ecx
  800b19:	0f b6 1a             	movzbl (%edx),%ebx
  800b1c:	38 d9                	cmp    %bl,%cl
  800b1e:	75 08                	jne    800b28 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	eb ea                	jmp    800b12 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b28:	0f b6 c1             	movzbl %cl,%eax
  800b2b:	0f b6 db             	movzbl %bl,%ebx
  800b2e:	29 d8                	sub    %ebx,%eax
  800b30:	eb 05                	jmp    800b37 <memcmp+0x35>
	}

	return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b49:	39 d0                	cmp    %edx,%eax
  800b4b:	73 09                	jae    800b56 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4d:	38 08                	cmp    %cl,(%eax)
  800b4f:	74 05                	je     800b56 <memfind+0x1b>
	for (; s < ends; s++)
  800b51:	83 c0 01             	add    $0x1,%eax
  800b54:	eb f3                	jmp    800b49 <memfind+0xe>
			break;
	return (void *) s;
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	eb 03                	jmp    800b69 <strtol+0x11>
		s++;
  800b66:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b69:	0f b6 01             	movzbl (%ecx),%eax
  800b6c:	3c 20                	cmp    $0x20,%al
  800b6e:	74 f6                	je     800b66 <strtol+0xe>
  800b70:	3c 09                	cmp    $0x9,%al
  800b72:	74 f2                	je     800b66 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b74:	3c 2b                	cmp    $0x2b,%al
  800b76:	74 2a                	je     800ba2 <strtol+0x4a>
	int neg = 0;
  800b78:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7d:	3c 2d                	cmp    $0x2d,%al
  800b7f:	74 2b                	je     800bac <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b87:	75 0f                	jne    800b98 <strtol+0x40>
  800b89:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8c:	74 28                	je     800bb6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8e:	85 db                	test   %ebx,%ebx
  800b90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b95:	0f 44 d8             	cmove  %eax,%ebx
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba0:	eb 50                	jmp    800bf2 <strtol+0x9a>
		s++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  800baa:	eb d5                	jmp    800b81 <strtol+0x29>
		s++, neg = 1;
  800bac:	83 c1 01             	add    $0x1,%ecx
  800baf:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb4:	eb cb                	jmp    800b81 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bba:	74 0e                	je     800bca <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bbc:	85 db                	test   %ebx,%ebx
  800bbe:	75 d8                	jne    800b98 <strtol+0x40>
		s++, base = 8;
  800bc0:	83 c1 01             	add    $0x1,%ecx
  800bc3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc8:	eb ce                	jmp    800b98 <strtol+0x40>
		s += 2, base = 16;
  800bca:	83 c1 02             	add    $0x2,%ecx
  800bcd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd2:	eb c4                	jmp    800b98 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd7:	89 f3                	mov    %esi,%ebx
  800bd9:	80 fb 19             	cmp    $0x19,%bl
  800bdc:	77 29                	ja     800c07 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bde:	0f be d2             	movsbl %dl,%edx
  800be1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be7:	7d 30                	jge    800c19 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be9:	83 c1 01             	add    $0x1,%ecx
  800bec:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf2:	0f b6 11             	movzbl (%ecx),%edx
  800bf5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf8:	89 f3                	mov    %esi,%ebx
  800bfa:	80 fb 09             	cmp    $0x9,%bl
  800bfd:	77 d5                	ja     800bd4 <strtol+0x7c>
			dig = *s - '0';
  800bff:	0f be d2             	movsbl %dl,%edx
  800c02:	83 ea 30             	sub    $0x30,%edx
  800c05:	eb dd                	jmp    800be4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c07:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0a:	89 f3                	mov    %esi,%ebx
  800c0c:	80 fb 19             	cmp    $0x19,%bl
  800c0f:	77 08                	ja     800c19 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c11:	0f be d2             	movsbl %dl,%edx
  800c14:	83 ea 37             	sub    $0x37,%edx
  800c17:	eb cb                	jmp    800be4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1d:	74 05                	je     800c24 <strtol+0xcc>
		*endptr = (char *) s;
  800c1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c22:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c24:	89 c2                	mov    %eax,%edx
  800c26:	f7 da                	neg    %edx
  800c28:	85 ff                	test   %edi,%edi
  800c2a:	0f 45 c2             	cmovne %edx,%eax
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c43:	89 c3                	mov    %eax,%ebx
  800c45:	89 c7                	mov    %eax,%edi
  800c47:	89 c6                	mov    %eax,%esi
  800c49:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5f                   	pop    %edi
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c56:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c60:	89 d1                	mov    %edx,%ecx
  800c62:	89 d3                	mov    %edx,%ebx
  800c64:	89 d7                	mov    %edx,%edi
  800c66:	89 d6                	mov    %edx,%esi
  800c68:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c80:	b8 03 00 00 00       	mov    $0x3,%eax
  800c85:	89 cb                	mov    %ecx,%ebx
  800c87:	89 cf                	mov    %ecx,%edi
  800c89:	89 ce                	mov    %ecx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 03                	push   $0x3
  800c9f:	68 88 29 80 00       	push   $0x802988
  800ca4:	6a 43                	push   $0x43
  800ca6:	68 a5 29 80 00       	push   $0x8029a5
  800cab:	e8 1e 15 00 00       	call   8021ce <_panic>

00800cb0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbb:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc0:	89 d1                	mov    %edx,%ecx
  800cc2:	89 d3                	mov    %edx,%ebx
  800cc4:	89 d7                	mov    %edx,%edi
  800cc6:	89 d6                	mov    %edx,%esi
  800cc8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <sys_yield>:

void
sys_yield(void)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cda:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 d3                	mov    %edx,%ebx
  800ce3:	89 d7                	mov    %edx,%edi
  800ce5:	89 d6                	mov    %edx,%esi
  800ce7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf7:	be 00 00 00 00       	mov    $0x0,%esi
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 04 00 00 00       	mov    $0x4,%eax
  800d07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0a:	89 f7                	mov    %esi,%edi
  800d0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0e:	85 c0                	test   %eax,%eax
  800d10:	7f 08                	jg     800d1a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	50                   	push   %eax
  800d1e:	6a 04                	push   $0x4
  800d20:	68 88 29 80 00       	push   $0x802988
  800d25:	6a 43                	push   $0x43
  800d27:	68 a5 29 80 00       	push   $0x8029a5
  800d2c:	e8 9d 14 00 00       	call   8021ce <_panic>

00800d31 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
  800d37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	b8 05 00 00 00       	mov    $0x5,%eax
  800d45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d48:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	7f 08                	jg     800d5c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5c:	83 ec 0c             	sub    $0xc,%esp
  800d5f:	50                   	push   %eax
  800d60:	6a 05                	push   $0x5
  800d62:	68 88 29 80 00       	push   $0x802988
  800d67:	6a 43                	push   $0x43
  800d69:	68 a5 29 80 00       	push   $0x8029a5
  800d6e:	e8 5b 14 00 00       	call   8021ce <_panic>

00800d73 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8c:	89 df                	mov    %ebx,%edi
  800d8e:	89 de                	mov    %ebx,%esi
  800d90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	7f 08                	jg     800d9e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d99:	5b                   	pop    %ebx
  800d9a:	5e                   	pop    %esi
  800d9b:	5f                   	pop    %edi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9e:	83 ec 0c             	sub    $0xc,%esp
  800da1:	50                   	push   %eax
  800da2:	6a 06                	push   $0x6
  800da4:	68 88 29 80 00       	push   $0x802988
  800da9:	6a 43                	push   $0x43
  800dab:	68 a5 29 80 00       	push   $0x8029a5
  800db0:	e8 19 14 00 00       	call   8021ce <_panic>

00800db5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 08 00 00 00       	mov    $0x8,%eax
  800dce:	89 df                	mov    %ebx,%edi
  800dd0:	89 de                	mov    %ebx,%esi
  800dd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7f 08                	jg     800de0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 08                	push   $0x8
  800de6:	68 88 29 80 00       	push   $0x802988
  800deb:	6a 43                	push   $0x43
  800ded:	68 a5 29 80 00       	push   $0x8029a5
  800df2:	e8 d7 13 00 00       	call   8021ce <_panic>

00800df7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	57                   	push   %edi
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e10:	89 df                	mov    %ebx,%edi
  800e12:	89 de                	mov    %ebx,%esi
  800e14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	7f 08                	jg     800e22 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	50                   	push   %eax
  800e26:	6a 09                	push   $0x9
  800e28:	68 88 29 80 00       	push   $0x802988
  800e2d:	6a 43                	push   $0x43
  800e2f:	68 a5 29 80 00       	push   $0x8029a5
  800e34:	e8 95 13 00 00       	call   8021ce <_panic>

00800e39 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e52:	89 df                	mov    %ebx,%edi
  800e54:	89 de                	mov    %ebx,%esi
  800e56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	7f 08                	jg     800e64 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	50                   	push   %eax
  800e68:	6a 0a                	push   $0xa
  800e6a:	68 88 29 80 00       	push   $0x802988
  800e6f:	6a 43                	push   $0x43
  800e71:	68 a5 29 80 00       	push   $0x8029a5
  800e76:	e8 53 13 00 00       	call   8021ce <_panic>

00800e7b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8c:	be 00 00 00 00       	mov    $0x0,%esi
  800e91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e97:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb4:	89 cb                	mov    %ecx,%ebx
  800eb6:	89 cf                	mov    %ecx,%edi
  800eb8:	89 ce                	mov    %ecx,%esi
  800eba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7f 08                	jg     800ec8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 0d                	push   $0xd
  800ece:	68 88 29 80 00       	push   $0x802988
  800ed3:	6a 43                	push   $0x43
  800ed5:	68 a5 29 80 00       	push   $0x8029a5
  800eda:	e8 ef 12 00 00       	call   8021ce <_panic>

00800edf <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800efb:	5b                   	pop    %ebx
  800efc:	5e                   	pop    %esi
  800efd:	5f                   	pop    %edi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f13:	89 cb                	mov    %ecx,%ebx
  800f15:	89 cf                	mov    %ecx,%edi
  800f17:	89 ce                	mov    %ecx,%esi
  800f19:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f26:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f30:	89 d1                	mov    %edx,%ecx
  800f32:	89 d3                	mov    %edx,%ebx
  800f34:	89 d7                	mov    %edx,%edi
  800f36:	89 d6                	mov    %edx,%esi
  800f38:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	b8 11 00 00 00       	mov    $0x11,%eax
  800f55:	89 df                	mov    %ebx,%edi
  800f57:	89 de                	mov    %ebx,%esi
  800f59:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	b8 12 00 00 00       	mov    $0x12,%eax
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	b8 13 00 00 00       	mov    $0x13,%eax
  800f9a:	89 df                	mov    %ebx,%edi
  800f9c:	89 de                	mov    %ebx,%esi
  800f9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	7f 08                	jg     800fac <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fac:	83 ec 0c             	sub    $0xc,%esp
  800faf:	50                   	push   %eax
  800fb0:	6a 13                	push   $0x13
  800fb2:	68 88 29 80 00       	push   $0x802988
  800fb7:	6a 43                	push   $0x43
  800fb9:	68 a5 29 80 00       	push   $0x8029a5
  800fbe:	e8 0b 12 00 00       	call   8021ce <_panic>

00800fc3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	b8 14 00 00 00       	mov    $0x14,%eax
  800fd6:	89 cb                	mov    %ecx,%ebx
  800fd8:	89 cf                	mov    %ecx,%edi
  800fda:	89 ce                	mov    %ecx,%esi
  800fdc:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fe9:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800ff0:	74 0a                	je     800ffc <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800ffc:	83 ec 04             	sub    $0x4,%esp
  800fff:	6a 07                	push   $0x7
  801001:	68 00 f0 bf ee       	push   $0xeebff000
  801006:	6a 00                	push   $0x0
  801008:	e8 e1 fc ff ff       	call   800cee <sys_page_alloc>
		if(r < 0)
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	85 c0                	test   %eax,%eax
  801012:	78 2a                	js     80103e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801014:	83 ec 08             	sub    $0x8,%esp
  801017:	68 52 10 80 00       	push   $0x801052
  80101c:	6a 00                	push   $0x0
  80101e:	e8 16 fe ff ff       	call   800e39 <sys_env_set_pgfault_upcall>
		if(r < 0)
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	79 c8                	jns    800ff2 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80102a:	83 ec 04             	sub    $0x4,%esp
  80102d:	68 e4 29 80 00       	push   $0x8029e4
  801032:	6a 25                	push   $0x25
  801034:	68 1d 2a 80 00       	push   $0x802a1d
  801039:	e8 90 11 00 00       	call   8021ce <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	68 b4 29 80 00       	push   $0x8029b4
  801046:	6a 22                	push   $0x22
  801048:	68 1d 2a 80 00       	push   $0x802a1d
  80104d:	e8 7c 11 00 00       	call   8021ce <_panic>

00801052 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801052:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801053:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801058:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80105a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80105d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801061:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801065:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801068:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80106a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80106e:	83 c4 08             	add    $0x8,%esp
	popal
  801071:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801072:	83 c4 04             	add    $0x4,%esp
	popfl
  801075:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801076:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801077:	c3                   	ret    

00801078 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	05 00 00 00 30       	add    $0x30000000,%eax
  801083:	c1 e8 0c             	shr    $0xc,%eax
}
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801093:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801098:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010a7:	89 c2                	mov    %eax,%edx
  8010a9:	c1 ea 16             	shr    $0x16,%edx
  8010ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010b3:	f6 c2 01             	test   $0x1,%dl
  8010b6:	74 2d                	je     8010e5 <fd_alloc+0x46>
  8010b8:	89 c2                	mov    %eax,%edx
  8010ba:	c1 ea 0c             	shr    $0xc,%edx
  8010bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c4:	f6 c2 01             	test   $0x1,%dl
  8010c7:	74 1c                	je     8010e5 <fd_alloc+0x46>
  8010c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010d3:	75 d2                	jne    8010a7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010e3:	eb 0a                	jmp    8010ef <fd_alloc+0x50>
			*fd_store = fd;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    

008010f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010f7:	83 f8 1f             	cmp    $0x1f,%eax
  8010fa:	77 30                	ja     80112c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010fc:	c1 e0 0c             	shl    $0xc,%eax
  8010ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801104:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80110a:	f6 c2 01             	test   $0x1,%dl
  80110d:	74 24                	je     801133 <fd_lookup+0x42>
  80110f:	89 c2                	mov    %eax,%edx
  801111:	c1 ea 0c             	shr    $0xc,%edx
  801114:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80111b:	f6 c2 01             	test   $0x1,%dl
  80111e:	74 1a                	je     80113a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801120:	8b 55 0c             	mov    0xc(%ebp),%edx
  801123:	89 02                	mov    %eax,(%edx)
	return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    
		return -E_INVAL;
  80112c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801131:	eb f7                	jmp    80112a <fd_lookup+0x39>
		return -E_INVAL;
  801133:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801138:	eb f0                	jmp    80112a <fd_lookup+0x39>
  80113a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113f:	eb e9                	jmp    80112a <fd_lookup+0x39>

00801141 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80114a:	ba 00 00 00 00       	mov    $0x0,%edx
  80114f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801154:	39 08                	cmp    %ecx,(%eax)
  801156:	74 38                	je     801190 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801158:	83 c2 01             	add    $0x1,%edx
  80115b:	8b 04 95 a8 2a 80 00 	mov    0x802aa8(,%edx,4),%eax
  801162:	85 c0                	test   %eax,%eax
  801164:	75 ee                	jne    801154 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801166:	a1 08 40 80 00       	mov    0x804008,%eax
  80116b:	8b 40 48             	mov    0x48(%eax),%eax
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	51                   	push   %ecx
  801172:	50                   	push   %eax
  801173:	68 2c 2a 80 00       	push   $0x802a2c
  801178:	e8 20 f0 ff ff       	call   80019d <cprintf>
	*dev = 0;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    
			*dev = devtab[i];
  801190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801193:	89 01                	mov    %eax,(%ecx)
			return 0;
  801195:	b8 00 00 00 00       	mov    $0x0,%eax
  80119a:	eb f2                	jmp    80118e <dev_lookup+0x4d>

0080119c <fd_close>:
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 24             	sub    $0x24,%esp
  8011a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8011a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b8:	50                   	push   %eax
  8011b9:	e8 33 ff ff ff       	call   8010f1 <fd_lookup>
  8011be:	89 c3                	mov    %eax,%ebx
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	78 05                	js     8011cc <fd_close+0x30>
	    || fd != fd2)
  8011c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ca:	74 16                	je     8011e2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011cc:	89 f8                	mov    %edi,%eax
  8011ce:	84 c0                	test   %al,%al
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8011d8:	89 d8                	mov    %ebx,%eax
  8011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011e2:	83 ec 08             	sub    $0x8,%esp
  8011e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	ff 36                	pushl  (%esi)
  8011eb:	e8 51 ff ff ff       	call   801141 <dev_lookup>
  8011f0:	89 c3                	mov    %eax,%ebx
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 1a                	js     801213 <fd_close+0x77>
		if (dev->dev_close)
  8011f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011fc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801204:	85 c0                	test   %eax,%eax
  801206:	74 0b                	je     801213 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	56                   	push   %esi
  80120c:	ff d0                	call   *%eax
  80120e:	89 c3                	mov    %eax,%ebx
  801210:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	56                   	push   %esi
  801217:	6a 00                	push   $0x0
  801219:	e8 55 fb ff ff       	call   800d73 <sys_page_unmap>
	return r;
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	eb b5                	jmp    8011d8 <fd_close+0x3c>

00801223 <close>:

int
close(int fdnum)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801229:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122c:	50                   	push   %eax
  80122d:	ff 75 08             	pushl  0x8(%ebp)
  801230:	e8 bc fe ff ff       	call   8010f1 <fd_lookup>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	79 02                	jns    80123e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    
		return fd_close(fd, 1);
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	6a 01                	push   $0x1
  801243:	ff 75 f4             	pushl  -0xc(%ebp)
  801246:	e8 51 ff ff ff       	call   80119c <fd_close>
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	eb ec                	jmp    80123c <close+0x19>

00801250 <close_all>:

void
close_all(void)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	53                   	push   %ebx
  801254:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801257:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	53                   	push   %ebx
  801260:	e8 be ff ff ff       	call   801223 <close>
	for (i = 0; i < MAXFD; i++)
  801265:	83 c3 01             	add    $0x1,%ebx
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	83 fb 20             	cmp    $0x20,%ebx
  80126e:	75 ec                	jne    80125c <close_all+0xc>
}
  801270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	57                   	push   %edi
  801279:	56                   	push   %esi
  80127a:	53                   	push   %ebx
  80127b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80127e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801281:	50                   	push   %eax
  801282:	ff 75 08             	pushl  0x8(%ebp)
  801285:	e8 67 fe ff ff       	call   8010f1 <fd_lookup>
  80128a:	89 c3                	mov    %eax,%ebx
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	0f 88 81 00 00 00    	js     801318 <dup+0xa3>
		return r;
	close(newfdnum);
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	ff 75 0c             	pushl  0xc(%ebp)
  80129d:	e8 81 ff ff ff       	call   801223 <close>

	newfd = INDEX2FD(newfdnum);
  8012a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012a5:	c1 e6 0c             	shl    $0xc,%esi
  8012a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012ae:	83 c4 04             	add    $0x4,%esp
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	e8 cf fd ff ff       	call   801088 <fd2data>
  8012b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012bb:	89 34 24             	mov    %esi,(%esp)
  8012be:	e8 c5 fd ff ff       	call   801088 <fd2data>
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	c1 e8 16             	shr    $0x16,%eax
  8012cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012d4:	a8 01                	test   $0x1,%al
  8012d6:	74 11                	je     8012e9 <dup+0x74>
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	c1 e8 0c             	shr    $0xc,%eax
  8012dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012e4:	f6 c2 01             	test   $0x1,%dl
  8012e7:	75 39                	jne    801322 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012ec:	89 d0                	mov    %edx,%eax
  8012ee:	c1 e8 0c             	shr    $0xc,%eax
  8012f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801300:	50                   	push   %eax
  801301:	56                   	push   %esi
  801302:	6a 00                	push   $0x0
  801304:	52                   	push   %edx
  801305:	6a 00                	push   $0x0
  801307:	e8 25 fa ff ff       	call   800d31 <sys_page_map>
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	83 c4 20             	add    $0x20,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 31                	js     801346 <dup+0xd1>
		goto err;

	return newfdnum;
  801315:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801318:	89 d8                	mov    %ebx,%eax
  80131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801322:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	25 07 0e 00 00       	and    $0xe07,%eax
  801331:	50                   	push   %eax
  801332:	57                   	push   %edi
  801333:	6a 00                	push   $0x0
  801335:	53                   	push   %ebx
  801336:	6a 00                	push   $0x0
  801338:	e8 f4 f9 ff ff       	call   800d31 <sys_page_map>
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	83 c4 20             	add    $0x20,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	79 a3                	jns    8012e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	56                   	push   %esi
  80134a:	6a 00                	push   $0x0
  80134c:	e8 22 fa ff ff       	call   800d73 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801351:	83 c4 08             	add    $0x8,%esp
  801354:	57                   	push   %edi
  801355:	6a 00                	push   $0x0
  801357:	e8 17 fa ff ff       	call   800d73 <sys_page_unmap>
	return r;
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	eb b7                	jmp    801318 <dup+0xa3>

00801361 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	53                   	push   %ebx
  801365:	83 ec 1c             	sub    $0x1c,%esp
  801368:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	53                   	push   %ebx
  801370:	e8 7c fd ff ff       	call   8010f1 <fd_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 3f                	js     8013bb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	ff 30                	pushl  (%eax)
  801388:	e8 b4 fd ff ff       	call   801141 <dev_lookup>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 27                	js     8013bb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801397:	8b 42 08             	mov    0x8(%edx),%eax
  80139a:	83 e0 03             	and    $0x3,%eax
  80139d:	83 f8 01             	cmp    $0x1,%eax
  8013a0:	74 1e                	je     8013c0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a5:	8b 40 08             	mov    0x8(%eax),%eax
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	74 35                	je     8013e1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	ff 75 10             	pushl  0x10(%ebp)
  8013b2:	ff 75 0c             	pushl  0xc(%ebp)
  8013b5:	52                   	push   %edx
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
}
  8013bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c5:	8b 40 48             	mov    0x48(%eax),%eax
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	53                   	push   %ebx
  8013cc:	50                   	push   %eax
  8013cd:	68 6d 2a 80 00       	push   $0x802a6d
  8013d2:	e8 c6 ed ff ff       	call   80019d <cprintf>
		return -E_INVAL;
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013df:	eb da                	jmp    8013bb <read+0x5a>
		return -E_NOT_SUPP;
  8013e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e6:	eb d3                	jmp    8013bb <read+0x5a>

008013e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	57                   	push   %edi
  8013ec:	56                   	push   %esi
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fc:	39 f3                	cmp    %esi,%ebx
  8013fe:	73 23                	jae    801423 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	89 f0                	mov    %esi,%eax
  801405:	29 d8                	sub    %ebx,%eax
  801407:	50                   	push   %eax
  801408:	89 d8                	mov    %ebx,%eax
  80140a:	03 45 0c             	add    0xc(%ebp),%eax
  80140d:	50                   	push   %eax
  80140e:	57                   	push   %edi
  80140f:	e8 4d ff ff ff       	call   801361 <read>
		if (m < 0)
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	78 06                	js     801421 <readn+0x39>
			return m;
		if (m == 0)
  80141b:	74 06                	je     801423 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80141d:	01 c3                	add    %eax,%ebx
  80141f:	eb db                	jmp    8013fc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801421:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801423:	89 d8                	mov    %ebx,%eax
  801425:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    

0080142d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	53                   	push   %ebx
  801431:	83 ec 1c             	sub    $0x1c,%esp
  801434:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801437:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	53                   	push   %ebx
  80143c:	e8 b0 fc ff ff       	call   8010f1 <fd_lookup>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 3a                	js     801482 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144e:	50                   	push   %eax
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	ff 30                	pushl  (%eax)
  801454:	e8 e8 fc ff ff       	call   801141 <dev_lookup>
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 22                	js     801482 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801463:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801467:	74 1e                	je     801487 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146c:	8b 52 0c             	mov    0xc(%edx),%edx
  80146f:	85 d2                	test   %edx,%edx
  801471:	74 35                	je     8014a8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	ff 75 10             	pushl  0x10(%ebp)
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	50                   	push   %eax
  80147d:	ff d2                	call   *%edx
  80147f:	83 c4 10             	add    $0x10,%esp
}
  801482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801485:	c9                   	leave  
  801486:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801487:	a1 08 40 80 00       	mov    0x804008,%eax
  80148c:	8b 40 48             	mov    0x48(%eax),%eax
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	53                   	push   %ebx
  801493:	50                   	push   %eax
  801494:	68 89 2a 80 00       	push   $0x802a89
  801499:	e8 ff ec ff ff       	call   80019d <cprintf>
		return -E_INVAL;
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a6:	eb da                	jmp    801482 <write+0x55>
		return -E_NOT_SUPP;
  8014a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ad:	eb d3                	jmp    801482 <write+0x55>

008014af <seek>:

int
seek(int fdnum, off_t offset)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 30 fc ff ff       	call   8010f1 <fd_lookup>
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 0e                	js     8014d6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ce:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 1c             	sub    $0x1c,%esp
  8014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	53                   	push   %ebx
  8014e7:	e8 05 fc ff ff       	call   8010f1 <fd_lookup>
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 37                	js     80152a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fd:	ff 30                	pushl  (%eax)
  8014ff:	e8 3d fc ff ff       	call   801141 <dev_lookup>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	78 1f                	js     80152a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801512:	74 1b                	je     80152f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801517:	8b 52 18             	mov    0x18(%edx),%edx
  80151a:	85 d2                	test   %edx,%edx
  80151c:	74 32                	je     801550 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80151e:	83 ec 08             	sub    $0x8,%esp
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	50                   	push   %eax
  801525:	ff d2                	call   *%edx
  801527:	83 c4 10             	add    $0x10,%esp
}
  80152a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80152f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801534:	8b 40 48             	mov    0x48(%eax),%eax
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	53                   	push   %ebx
  80153b:	50                   	push   %eax
  80153c:	68 4c 2a 80 00       	push   $0x802a4c
  801541:	e8 57 ec ff ff       	call   80019d <cprintf>
		return -E_INVAL;
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154e:	eb da                	jmp    80152a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801550:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801555:	eb d3                	jmp    80152a <ftruncate+0x52>

00801557 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	53                   	push   %ebx
  80155b:	83 ec 1c             	sub    $0x1c,%esp
  80155e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801561:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801564:	50                   	push   %eax
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	e8 84 fb ff ff       	call   8010f1 <fd_lookup>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 4b                	js     8015bf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157a:	50                   	push   %eax
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157e:	ff 30                	pushl  (%eax)
  801580:	e8 bc fb ff ff       	call   801141 <dev_lookup>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 33                	js     8015bf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801593:	74 2f                	je     8015c4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801595:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801598:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80159f:	00 00 00 
	stat->st_isdir = 0;
  8015a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a9:	00 00 00 
	stat->st_dev = dev;
  8015ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	53                   	push   %ebx
  8015b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b9:	ff 50 14             	call   *0x14(%eax)
  8015bc:	83 c4 10             	add    $0x10,%esp
}
  8015bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8015c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c9:	eb f4                	jmp    8015bf <fstat+0x68>

008015cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	6a 00                	push   $0x0
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 22 02 00 00       	call   8017ff <open>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	78 1b                	js     801601 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	e8 65 ff ff ff       	call   801557 <fstat>
  8015f2:	89 c6                	mov    %eax,%esi
	close(fd);
  8015f4:	89 1c 24             	mov    %ebx,(%esp)
  8015f7:	e8 27 fc ff ff       	call   801223 <close>
	return r;
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	89 f3                	mov    %esi,%ebx
}
  801601:	89 d8                	mov    %ebx,%eax
  801603:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	56                   	push   %esi
  80160e:	53                   	push   %ebx
  80160f:	89 c6                	mov    %eax,%esi
  801611:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801613:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80161a:	74 27                	je     801643 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80161c:	6a 07                	push   $0x7
  80161e:	68 00 50 80 00       	push   $0x805000
  801623:	56                   	push   %esi
  801624:	ff 35 00 40 80 00    	pushl  0x804000
  80162a:	e8 69 0c 00 00       	call   802298 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80162f:	83 c4 0c             	add    $0xc,%esp
  801632:	6a 00                	push   $0x0
  801634:	53                   	push   %ebx
  801635:	6a 00                	push   $0x0
  801637:	e8 f3 0b 00 00       	call   80222f <ipc_recv>
}
  80163c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801643:	83 ec 0c             	sub    $0xc,%esp
  801646:	6a 01                	push   $0x1
  801648:	e8 a3 0c 00 00       	call   8022f0 <ipc_find_env>
  80164d:	a3 00 40 80 00       	mov    %eax,0x804000
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	eb c5                	jmp    80161c <fsipc+0x12>

00801657 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8b 40 0c             	mov    0xc(%eax),%eax
  801663:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	b8 02 00 00 00       	mov    $0x2,%eax
  80167a:	e8 8b ff ff ff       	call   80160a <fsipc>
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <devfile_flush>:
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8b 40 0c             	mov    0xc(%eax),%eax
  80168d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
  801697:	b8 06 00 00 00       	mov    $0x6,%eax
  80169c:	e8 69 ff ff ff       	call   80160a <fsipc>
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <devfile_stat>:
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8016c2:	e8 43 ff ff ff       	call   80160a <fsipc>
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 2c                	js     8016f7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	68 00 50 80 00       	push   $0x805000
  8016d3:	53                   	push   %ebx
  8016d4:	e8 23 f2 ff ff       	call   8008fc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016d9:	a1 80 50 80 00       	mov    0x805080,%eax
  8016de:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016e4:	a1 84 50 80 00       	mov    0x805084,%eax
  8016e9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <devfile_write>:
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	53                   	push   %ebx
  801700:	83 ec 08             	sub    $0x8,%esp
  801703:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8b 40 0c             	mov    0xc(%eax),%eax
  80170c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801711:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801717:	53                   	push   %ebx
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	68 08 50 80 00       	push   $0x805008
  801720:	e8 c7 f3 ff ff       	call   800aec <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801725:	ba 00 00 00 00       	mov    $0x0,%edx
  80172a:	b8 04 00 00 00       	mov    $0x4,%eax
  80172f:	e8 d6 fe ff ff       	call   80160a <fsipc>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 0b                	js     801746 <devfile_write+0x4a>
	assert(r <= n);
  80173b:	39 d8                	cmp    %ebx,%eax
  80173d:	77 0c                	ja     80174b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80173f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801744:	7f 1e                	jg     801764 <devfile_write+0x68>
}
  801746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801749:	c9                   	leave  
  80174a:	c3                   	ret    
	assert(r <= n);
  80174b:	68 bc 2a 80 00       	push   $0x802abc
  801750:	68 c3 2a 80 00       	push   $0x802ac3
  801755:	68 98 00 00 00       	push   $0x98
  80175a:	68 d8 2a 80 00       	push   $0x802ad8
  80175f:	e8 6a 0a 00 00       	call   8021ce <_panic>
	assert(r <= PGSIZE);
  801764:	68 e3 2a 80 00       	push   $0x802ae3
  801769:	68 c3 2a 80 00       	push   $0x802ac3
  80176e:	68 99 00 00 00       	push   $0x99
  801773:	68 d8 2a 80 00       	push   $0x802ad8
  801778:	e8 51 0a 00 00       	call   8021ce <_panic>

0080177d <devfile_read>:
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
  801782:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8b 40 0c             	mov    0xc(%eax),%eax
  80178b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801790:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a0:	e8 65 fe ff ff       	call   80160a <fsipc>
  8017a5:	89 c3                	mov    %eax,%ebx
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 1f                	js     8017ca <devfile_read+0x4d>
	assert(r <= n);
  8017ab:	39 f0                	cmp    %esi,%eax
  8017ad:	77 24                	ja     8017d3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b4:	7f 33                	jg     8017e9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	50                   	push   %eax
  8017ba:	68 00 50 80 00       	push   $0x805000
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	e8 c3 f2 ff ff       	call   800a8a <memmove>
	return r;
  8017c7:	83 c4 10             	add    $0x10,%esp
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    
	assert(r <= n);
  8017d3:	68 bc 2a 80 00       	push   $0x802abc
  8017d8:	68 c3 2a 80 00       	push   $0x802ac3
  8017dd:	6a 7c                	push   $0x7c
  8017df:	68 d8 2a 80 00       	push   $0x802ad8
  8017e4:	e8 e5 09 00 00       	call   8021ce <_panic>
	assert(r <= PGSIZE);
  8017e9:	68 e3 2a 80 00       	push   $0x802ae3
  8017ee:	68 c3 2a 80 00       	push   $0x802ac3
  8017f3:	6a 7d                	push   $0x7d
  8017f5:	68 d8 2a 80 00       	push   $0x802ad8
  8017fa:	e8 cf 09 00 00       	call   8021ce <_panic>

008017ff <open>:
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	83 ec 1c             	sub    $0x1c,%esp
  801807:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80180a:	56                   	push   %esi
  80180b:	e8 b3 f0 ff ff       	call   8008c3 <strlen>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801818:	7f 6c                	jg     801886 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	e8 79 f8 ff ff       	call   80109f <fd_alloc>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 3c                	js     80186b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	56                   	push   %esi
  801833:	68 00 50 80 00       	push   $0x805000
  801838:	e8 bf f0 ff ff       	call   8008fc <strcpy>
	fsipcbuf.open.req_omode = mode;
  80183d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801840:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801848:	b8 01 00 00 00       	mov    $0x1,%eax
  80184d:	e8 b8 fd ff ff       	call   80160a <fsipc>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	78 19                	js     801874 <open+0x75>
	return fd2num(fd);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 f4             	pushl  -0xc(%ebp)
  801861:	e8 12 f8 ff ff       	call   801078 <fd2num>
  801866:	89 c3                	mov    %eax,%ebx
  801868:	83 c4 10             	add    $0x10,%esp
}
  80186b:	89 d8                	mov    %ebx,%eax
  80186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
		fd_close(fd, 0);
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	6a 00                	push   $0x0
  801879:	ff 75 f4             	pushl  -0xc(%ebp)
  80187c:	e8 1b f9 ff ff       	call   80119c <fd_close>
		return r;
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	eb e5                	jmp    80186b <open+0x6c>
		return -E_BAD_PATH;
  801886:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80188b:	eb de                	jmp    80186b <open+0x6c>

0080188d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801893:	ba 00 00 00 00       	mov    $0x0,%edx
  801898:	b8 08 00 00 00       	mov    $0x8,%eax
  80189d:	e8 68 fd ff ff       	call   80160a <fsipc>
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018aa:	68 ef 2a 80 00       	push   $0x802aef
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	e8 45 f0 ff ff       	call   8008fc <strcpy>
	return 0;
}
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <devsock_close>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 10             	sub    $0x10,%esp
  8018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018c8:	53                   	push   %ebx
  8018c9:	e8 61 0a 00 00       	call   80232f <pageref>
  8018ce:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018d6:	83 f8 01             	cmp    $0x1,%eax
  8018d9:	74 07                	je     8018e2 <devsock_close+0x24>
}
  8018db:	89 d0                	mov    %edx,%eax
  8018dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	ff 73 0c             	pushl  0xc(%ebx)
  8018e8:	e8 b9 02 00 00       	call   801ba6 <nsipc_close>
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	eb e7                	jmp    8018db <devsock_close+0x1d>

008018f4 <devsock_write>:
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 10             	pushl  0x10(%ebp)
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	ff 70 0c             	pushl  0xc(%eax)
  801908:	e8 76 03 00 00       	call   801c83 <nsipc_send>
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <devsock_read>:
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801915:	6a 00                	push   $0x0
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	ff 70 0c             	pushl  0xc(%eax)
  801923:	e8 ef 02 00 00       	call   801c17 <nsipc_recv>
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <fd2sockid>:
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801930:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	e8 b7 f7 ff ff       	call   8010f1 <fd_lookup>
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 10                	js     801951 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80194a:	39 08                	cmp    %ecx,(%eax)
  80194c:	75 05                	jne    801953 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80194e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    
		return -E_NOT_SUPP;
  801953:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801958:	eb f7                	jmp    801951 <fd2sockid+0x27>

0080195a <alloc_sockfd>:
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	56                   	push   %esi
  80195e:	53                   	push   %ebx
  80195f:	83 ec 1c             	sub    $0x1c,%esp
  801962:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801967:	50                   	push   %eax
  801968:	e8 32 f7 ff ff       	call   80109f <fd_alloc>
  80196d:	89 c3                	mov    %eax,%ebx
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	78 43                	js     8019b9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 07 04 00 00       	push   $0x407
  80197e:	ff 75 f4             	pushl  -0xc(%ebp)
  801981:	6a 00                	push   $0x0
  801983:	e8 66 f3 ff ff       	call   800cee <sys_page_alloc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 28                	js     8019b9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80199a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019a6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019a9:	83 ec 0c             	sub    $0xc,%esp
  8019ac:	50                   	push   %eax
  8019ad:	e8 c6 f6 ff ff       	call   801078 <fd2num>
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	eb 0c                	jmp    8019c5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	56                   	push   %esi
  8019bd:	e8 e4 01 00 00       	call   801ba6 <nsipc_close>
		return r;
  8019c2:	83 c4 10             	add    $0x10,%esp
}
  8019c5:	89 d8                	mov    %ebx,%eax
  8019c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    

008019ce <accept>:
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	e8 4e ff ff ff       	call   80192a <fd2sockid>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 1b                	js     8019fb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	ff 75 10             	pushl  0x10(%ebp)
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	50                   	push   %eax
  8019ea:	e8 0e 01 00 00       	call   801afd <nsipc_accept>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 05                	js     8019fb <accept+0x2d>
	return alloc_sockfd(r);
  8019f6:	e8 5f ff ff ff       	call   80195a <alloc_sockfd>
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <bind>:
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	e8 1f ff ff ff       	call   80192a <fd2sockid>
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 12                	js     801a21 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	e8 31 01 00 00       	call   801b4f <nsipc_bind>
  801a1e:	83 c4 10             	add    $0x10,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <shutdown>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	e8 f9 fe ff ff       	call   80192a <fd2sockid>
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 0f                	js     801a44 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	50                   	push   %eax
  801a3c:	e8 43 01 00 00       	call   801b84 <nsipc_shutdown>
  801a41:	83 c4 10             	add    $0x10,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <connect>:
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	e8 d6 fe ff ff       	call   80192a <fd2sockid>
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 12                	js     801a6a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	ff 75 10             	pushl  0x10(%ebp)
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	50                   	push   %eax
  801a62:	e8 59 01 00 00       	call   801bc0 <nsipc_connect>
  801a67:	83 c4 10             	add    $0x10,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <listen>:
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	e8 b0 fe ff ff       	call   80192a <fd2sockid>
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 0f                	js     801a8d <listen+0x21>
	return nsipc_listen(r, backlog);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	50                   	push   %eax
  801a85:	e8 6b 01 00 00       	call   801bf5 <nsipc_listen>
  801a8a:	83 c4 10             	add    $0x10,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <socket>:

int
socket(int domain, int type, int protocol)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a95:	ff 75 10             	pushl  0x10(%ebp)
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	e8 3e 02 00 00       	call   801ce1 <nsipc_socket>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 05                	js     801aaf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801aaa:	e8 ab fe ff ff       	call   80195a <alloc_sockfd>
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aba:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ac1:	74 26                	je     801ae9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ac3:	6a 07                	push   $0x7
  801ac5:	68 00 60 80 00       	push   $0x806000
  801aca:	53                   	push   %ebx
  801acb:	ff 35 04 40 80 00    	pushl  0x804004
  801ad1:	e8 c2 07 00 00       	call   802298 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ad6:	83 c4 0c             	add    $0xc,%esp
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	e8 4b 07 00 00       	call   80222f <ipc_recv>
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	6a 02                	push   $0x2
  801aee:	e8 fd 07 00 00       	call   8022f0 <ipc_find_env>
  801af3:	a3 04 40 80 00       	mov    %eax,0x804004
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	eb c6                	jmp    801ac3 <nsipc+0x12>

00801afd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	56                   	push   %esi
  801b01:	53                   	push   %ebx
  801b02:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b0d:	8b 06                	mov    (%esi),%eax
  801b0f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
  801b19:	e8 93 ff ff ff       	call   801ab1 <nsipc>
  801b1e:	89 c3                	mov    %eax,%ebx
  801b20:	85 c0                	test   %eax,%eax
  801b22:	79 09                	jns    801b2d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5e                   	pop    %esi
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	ff 35 10 60 80 00    	pushl  0x806010
  801b36:	68 00 60 80 00       	push   $0x806000
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	e8 47 ef ff ff       	call   800a8a <memmove>
		*addrlen = ret->ret_addrlen;
  801b43:	a1 10 60 80 00       	mov    0x806010,%eax
  801b48:	89 06                	mov    %eax,(%esi)
  801b4a:	83 c4 10             	add    $0x10,%esp
	return r;
  801b4d:	eb d5                	jmp    801b24 <nsipc_accept+0x27>

00801b4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b61:	53                   	push   %ebx
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	68 04 60 80 00       	push   $0x806004
  801b6a:	e8 1b ef ff ff       	call   800a8a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b6f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b75:	b8 02 00 00 00       	mov    $0x2,%eax
  801b7a:	e8 32 ff ff ff       	call   801ab1 <nsipc>
}
  801b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b9a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b9f:	e8 0d ff ff ff       	call   801ab1 <nsipc>
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <nsipc_close>:

int
nsipc_close(int s)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bb4:	b8 04 00 00 00       	mov    $0x4,%eax
  801bb9:	e8 f3 fe ff ff       	call   801ab1 <nsipc>
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bd2:	53                   	push   %ebx
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	68 04 60 80 00       	push   $0x806004
  801bdb:	e8 aa ee ff ff       	call   800a8a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801be0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801be6:	b8 05 00 00 00       	mov    $0x5,%eax
  801beb:	e8 c1 fe ff ff       	call   801ab1 <nsipc>
}
  801bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c06:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c0b:	b8 06 00 00 00       	mov    $0x6,%eax
  801c10:	e8 9c fe ff ff       	call   801ab1 <nsipc>
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c27:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c30:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c35:	b8 07 00 00 00       	mov    $0x7,%eax
  801c3a:	e8 72 fe ff ff       	call   801ab1 <nsipc>
  801c3f:	89 c3                	mov    %eax,%ebx
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 1f                	js     801c64 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c45:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c4a:	7f 21                	jg     801c6d <nsipc_recv+0x56>
  801c4c:	39 c6                	cmp    %eax,%esi
  801c4e:	7c 1d                	jl     801c6d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	50                   	push   %eax
  801c54:	68 00 60 80 00       	push   $0x806000
  801c59:	ff 75 0c             	pushl  0xc(%ebp)
  801c5c:	e8 29 ee ff ff       	call   800a8a <memmove>
  801c61:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c64:	89 d8                	mov    %ebx,%eax
  801c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c6d:	68 fb 2a 80 00       	push   $0x802afb
  801c72:	68 c3 2a 80 00       	push   $0x802ac3
  801c77:	6a 62                	push   $0x62
  801c79:	68 10 2b 80 00       	push   $0x802b10
  801c7e:	e8 4b 05 00 00       	call   8021ce <_panic>

00801c83 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	53                   	push   %ebx
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c95:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c9b:	7f 2e                	jg     801ccb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	53                   	push   %ebx
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	68 0c 60 80 00       	push   $0x80600c
  801ca9:	e8 dc ed ff ff       	call   800a8a <memmove>
	nsipcbuf.send.req_size = size;
  801cae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cbc:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc1:	e8 eb fd ff ff       	call   801ab1 <nsipc>
}
  801cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    
	assert(size < 1600);
  801ccb:	68 1c 2b 80 00       	push   $0x802b1c
  801cd0:	68 c3 2a 80 00       	push   $0x802ac3
  801cd5:	6a 6d                	push   $0x6d
  801cd7:	68 10 2b 80 00       	push   $0x802b10
  801cdc:	e8 ed 04 00 00       	call   8021ce <_panic>

00801ce1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cff:	b8 09 00 00 00       	mov    $0x9,%eax
  801d04:	e8 a8 fd ff ff       	call   801ab1 <nsipc>
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 6a f3 ff ff       	call   801088 <fd2data>
  801d1e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d20:	83 c4 08             	add    $0x8,%esp
  801d23:	68 28 2b 80 00       	push   $0x802b28
  801d28:	53                   	push   %ebx
  801d29:	e8 ce eb ff ff       	call   8008fc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d2e:	8b 46 04             	mov    0x4(%esi),%eax
  801d31:	2b 06                	sub    (%esi),%eax
  801d33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d39:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d40:	00 00 00 
	stat->st_dev = &devpipe;
  801d43:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d4a:	30 80 00 
	return 0;
}
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d55:	5b                   	pop    %ebx
  801d56:	5e                   	pop    %esi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d63:	53                   	push   %ebx
  801d64:	6a 00                	push   $0x0
  801d66:	e8 08 f0 ff ff       	call   800d73 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d6b:	89 1c 24             	mov    %ebx,(%esp)
  801d6e:	e8 15 f3 ff ff       	call   801088 <fd2data>
  801d73:	83 c4 08             	add    $0x8,%esp
  801d76:	50                   	push   %eax
  801d77:	6a 00                	push   $0x0
  801d79:	e8 f5 ef ff ff       	call   800d73 <sys_page_unmap>
}
  801d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <_pipeisclosed>:
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	57                   	push   %edi
  801d87:	56                   	push   %esi
  801d88:	53                   	push   %ebx
  801d89:	83 ec 1c             	sub    $0x1c,%esp
  801d8c:	89 c7                	mov    %eax,%edi
  801d8e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d90:	a1 08 40 80 00       	mov    0x804008,%eax
  801d95:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	57                   	push   %edi
  801d9c:	e8 8e 05 00 00       	call   80232f <pageref>
  801da1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801da4:	89 34 24             	mov    %esi,(%esp)
  801da7:	e8 83 05 00 00       	call   80232f <pageref>
		nn = thisenv->env_runs;
  801dac:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801db2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	39 cb                	cmp    %ecx,%ebx
  801dba:	74 1b                	je     801dd7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dbc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dbf:	75 cf                	jne    801d90 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dc1:	8b 42 58             	mov    0x58(%edx),%eax
  801dc4:	6a 01                	push   $0x1
  801dc6:	50                   	push   %eax
  801dc7:	53                   	push   %ebx
  801dc8:	68 2f 2b 80 00       	push   $0x802b2f
  801dcd:	e8 cb e3 ff ff       	call   80019d <cprintf>
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	eb b9                	jmp    801d90 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dd7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dda:	0f 94 c0             	sete   %al
  801ddd:	0f b6 c0             	movzbl %al,%eax
}
  801de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    

00801de8 <devpipe_write>:
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	57                   	push   %edi
  801dec:	56                   	push   %esi
  801ded:	53                   	push   %ebx
  801dee:	83 ec 28             	sub    $0x28,%esp
  801df1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801df4:	56                   	push   %esi
  801df5:	e8 8e f2 ff ff       	call   801088 <fd2data>
  801dfa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	bf 00 00 00 00       	mov    $0x0,%edi
  801e04:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e07:	74 4f                	je     801e58 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e09:	8b 43 04             	mov    0x4(%ebx),%eax
  801e0c:	8b 0b                	mov    (%ebx),%ecx
  801e0e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e11:	39 d0                	cmp    %edx,%eax
  801e13:	72 14                	jb     801e29 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e15:	89 da                	mov    %ebx,%edx
  801e17:	89 f0                	mov    %esi,%eax
  801e19:	e8 65 ff ff ff       	call   801d83 <_pipeisclosed>
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	75 3b                	jne    801e5d <devpipe_write+0x75>
			sys_yield();
  801e22:	e8 a8 ee ff ff       	call   800ccf <sys_yield>
  801e27:	eb e0                	jmp    801e09 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e2c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e30:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e33:	89 c2                	mov    %eax,%edx
  801e35:	c1 fa 1f             	sar    $0x1f,%edx
  801e38:	89 d1                	mov    %edx,%ecx
  801e3a:	c1 e9 1b             	shr    $0x1b,%ecx
  801e3d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e40:	83 e2 1f             	and    $0x1f,%edx
  801e43:	29 ca                	sub    %ecx,%edx
  801e45:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e49:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e4d:	83 c0 01             	add    $0x1,%eax
  801e50:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e53:	83 c7 01             	add    $0x1,%edi
  801e56:	eb ac                	jmp    801e04 <devpipe_write+0x1c>
	return i;
  801e58:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5b:	eb 05                	jmp    801e62 <devpipe_write+0x7a>
				return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5f                   	pop    %edi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <devpipe_read>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 18             	sub    $0x18,%esp
  801e73:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e76:	57                   	push   %edi
  801e77:	e8 0c f2 ff ff       	call   801088 <fd2data>
  801e7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	be 00 00 00 00       	mov    $0x0,%esi
  801e86:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e89:	75 14                	jne    801e9f <devpipe_read+0x35>
	return i;
  801e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8e:	eb 02                	jmp    801e92 <devpipe_read+0x28>
				return i;
  801e90:	89 f0                	mov    %esi,%eax
}
  801e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    
			sys_yield();
  801e9a:	e8 30 ee ff ff       	call   800ccf <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e9f:	8b 03                	mov    (%ebx),%eax
  801ea1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ea4:	75 18                	jne    801ebe <devpipe_read+0x54>
			if (i > 0)
  801ea6:	85 f6                	test   %esi,%esi
  801ea8:	75 e6                	jne    801e90 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801eaa:	89 da                	mov    %ebx,%edx
  801eac:	89 f8                	mov    %edi,%eax
  801eae:	e8 d0 fe ff ff       	call   801d83 <_pipeisclosed>
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	74 e3                	je     801e9a <devpipe_read+0x30>
				return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	eb d4                	jmp    801e92 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ebe:	99                   	cltd   
  801ebf:	c1 ea 1b             	shr    $0x1b,%edx
  801ec2:	01 d0                	add    %edx,%eax
  801ec4:	83 e0 1f             	and    $0x1f,%eax
  801ec7:	29 d0                	sub    %edx,%eax
  801ec9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ed4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ed7:	83 c6 01             	add    $0x1,%esi
  801eda:	eb aa                	jmp    801e86 <devpipe_read+0x1c>

00801edc <pipe>:
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	56                   	push   %esi
  801ee0:	53                   	push   %ebx
  801ee1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee7:	50                   	push   %eax
  801ee8:	e8 b2 f1 ff ff       	call   80109f <fd_alloc>
  801eed:	89 c3                	mov    %eax,%ebx
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	0f 88 23 01 00 00    	js     80201d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	68 07 04 00 00       	push   $0x407
  801f02:	ff 75 f4             	pushl  -0xc(%ebp)
  801f05:	6a 00                	push   $0x0
  801f07:	e8 e2 ed ff ff       	call   800cee <sys_page_alloc>
  801f0c:	89 c3                	mov    %eax,%ebx
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	85 c0                	test   %eax,%eax
  801f13:	0f 88 04 01 00 00    	js     80201d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f1f:	50                   	push   %eax
  801f20:	e8 7a f1 ff ff       	call   80109f <fd_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	0f 88 db 00 00 00    	js     80200d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	68 07 04 00 00       	push   $0x407
  801f3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3d:	6a 00                	push   $0x0
  801f3f:	e8 aa ed ff ff       	call   800cee <sys_page_alloc>
  801f44:	89 c3                	mov    %eax,%ebx
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 bc 00 00 00    	js     80200d <pipe+0x131>
	va = fd2data(fd0);
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	ff 75 f4             	pushl  -0xc(%ebp)
  801f57:	e8 2c f1 ff ff       	call   801088 <fd2data>
  801f5c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5e:	83 c4 0c             	add    $0xc,%esp
  801f61:	68 07 04 00 00       	push   $0x407
  801f66:	50                   	push   %eax
  801f67:	6a 00                	push   $0x0
  801f69:	e8 80 ed ff ff       	call   800cee <sys_page_alloc>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	0f 88 82 00 00 00    	js     801ffd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f81:	e8 02 f1 ff ff       	call   801088 <fd2data>
  801f86:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f8d:	50                   	push   %eax
  801f8e:	6a 00                	push   $0x0
  801f90:	56                   	push   %esi
  801f91:	6a 00                	push   $0x0
  801f93:	e8 99 ed ff ff       	call   800d31 <sys_page_map>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 20             	add    $0x20,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 4e                	js     801fef <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fa1:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fae:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fb8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fca:	e8 a9 f0 ff ff       	call   801078 <fd2num>
  801fcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fd4:	83 c4 04             	add    $0x4,%esp
  801fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fda:	e8 99 f0 ff ff       	call   801078 <fd2num>
  801fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fe2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fed:	eb 2e                	jmp    80201d <pipe+0x141>
	sys_page_unmap(0, va);
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	56                   	push   %esi
  801ff3:	6a 00                	push   $0x0
  801ff5:	e8 79 ed ff ff       	call   800d73 <sys_page_unmap>
  801ffa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ffd:	83 ec 08             	sub    $0x8,%esp
  802000:	ff 75 f0             	pushl  -0x10(%ebp)
  802003:	6a 00                	push   $0x0
  802005:	e8 69 ed ff ff       	call   800d73 <sys_page_unmap>
  80200a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80200d:	83 ec 08             	sub    $0x8,%esp
  802010:	ff 75 f4             	pushl  -0xc(%ebp)
  802013:	6a 00                	push   $0x0
  802015:	e8 59 ed ff ff       	call   800d73 <sys_page_unmap>
  80201a:	83 c4 10             	add    $0x10,%esp
}
  80201d:	89 d8                	mov    %ebx,%eax
  80201f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802022:	5b                   	pop    %ebx
  802023:	5e                   	pop    %esi
  802024:	5d                   	pop    %ebp
  802025:	c3                   	ret    

00802026 <pipeisclosed>:
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202f:	50                   	push   %eax
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	e8 b9 f0 ff ff       	call   8010f1 <fd_lookup>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	78 18                	js     802057 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 f4             	pushl  -0xc(%ebp)
  802045:	e8 3e f0 ff ff       	call   801088 <fd2data>
	return _pipeisclosed(fd, p);
  80204a:	89 c2                	mov    %eax,%edx
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	e8 2f fd ff ff       	call   801d83 <_pipeisclosed>
  802054:	83 c4 10             	add    $0x10,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	c3                   	ret    

0080205f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802065:	68 47 2b 80 00       	push   $0x802b47
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	e8 8a e8 ff ff       	call   8008fc <strcpy>
	return 0;
}
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <devcons_write>:
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	57                   	push   %edi
  80207d:	56                   	push   %esi
  80207e:	53                   	push   %ebx
  80207f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802085:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80208a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802090:	3b 75 10             	cmp    0x10(%ebp),%esi
  802093:	73 31                	jae    8020c6 <devcons_write+0x4d>
		m = n - tot;
  802095:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802098:	29 f3                	sub    %esi,%ebx
  80209a:	83 fb 7f             	cmp    $0x7f,%ebx
  80209d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020a2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	53                   	push   %ebx
  8020a9:	89 f0                	mov    %esi,%eax
  8020ab:	03 45 0c             	add    0xc(%ebp),%eax
  8020ae:	50                   	push   %eax
  8020af:	57                   	push   %edi
  8020b0:	e8 d5 e9 ff ff       	call   800a8a <memmove>
		sys_cputs(buf, m);
  8020b5:	83 c4 08             	add    $0x8,%esp
  8020b8:	53                   	push   %ebx
  8020b9:	57                   	push   %edi
  8020ba:	e8 73 eb ff ff       	call   800c32 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020bf:	01 de                	add    %ebx,%esi
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	eb ca                	jmp    802090 <devcons_write+0x17>
}
  8020c6:	89 f0                	mov    %esi,%eax
  8020c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5f                   	pop    %edi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <devcons_read>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
  8020d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020df:	74 21                	je     802102 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020e1:	e8 6a eb ff ff       	call   800c50 <sys_cgetc>
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	75 07                	jne    8020f1 <devcons_read+0x21>
		sys_yield();
  8020ea:	e8 e0 eb ff ff       	call   800ccf <sys_yield>
  8020ef:	eb f0                	jmp    8020e1 <devcons_read+0x11>
	if (c < 0)
  8020f1:	78 0f                	js     802102 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020f3:	83 f8 04             	cmp    $0x4,%eax
  8020f6:	74 0c                	je     802104 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	88 02                	mov    %al,(%edx)
	return 1;
  8020fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    
		return 0;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	eb f7                	jmp    802102 <devcons_read+0x32>

0080210b <cputchar>:
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802117:	6a 01                	push   $0x1
  802119:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211c:	50                   	push   %eax
  80211d:	e8 10 eb ff ff       	call   800c32 <sys_cputs>
}
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <getchar>:
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80212d:	6a 01                	push   $0x1
  80212f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802132:	50                   	push   %eax
  802133:	6a 00                	push   $0x0
  802135:	e8 27 f2 ff ff       	call   801361 <read>
	if (r < 0)
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 06                	js     802147 <getchar+0x20>
	if (r < 1)
  802141:	74 06                	je     802149 <getchar+0x22>
	return c;
  802143:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    
		return -E_EOF;
  802149:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80214e:	eb f7                	jmp    802147 <getchar+0x20>

00802150 <iscons>:
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802156:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802159:	50                   	push   %eax
  80215a:	ff 75 08             	pushl  0x8(%ebp)
  80215d:	e8 8f ef ff ff       	call   8010f1 <fd_lookup>
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	78 11                	js     80217a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802172:	39 10                	cmp    %edx,(%eax)
  802174:	0f 94 c0             	sete   %al
  802177:	0f b6 c0             	movzbl %al,%eax
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <opencons>:
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802185:	50                   	push   %eax
  802186:	e8 14 ef ff ff       	call   80109f <fd_alloc>
  80218b:	83 c4 10             	add    $0x10,%esp
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 3a                	js     8021cc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 07 04 00 00       	push   $0x407
  80219a:	ff 75 f4             	pushl  -0xc(%ebp)
  80219d:	6a 00                	push   $0x0
  80219f:	e8 4a eb ff ff       	call   800cee <sys_page_alloc>
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 21                	js     8021cc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021b4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	50                   	push   %eax
  8021c4:	e8 af ee ff ff       	call   801078 <fd2num>
  8021c9:	83 c4 10             	add    $0x10,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8021d8:	8b 40 48             	mov    0x48(%eax),%eax
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	68 78 2b 80 00       	push   $0x802b78
  8021e3:	50                   	push   %eax
  8021e4:	68 e2 25 80 00       	push   $0x8025e2
  8021e9:	e8 af df ff ff       	call   80019d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021f1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021f7:	e8 b4 ea ff ff       	call   800cb0 <sys_getenvid>
  8021fc:	83 c4 04             	add    $0x4,%esp
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	56                   	push   %esi
  802206:	50                   	push   %eax
  802207:	68 54 2b 80 00       	push   $0x802b54
  80220c:	e8 8c df ff ff       	call   80019d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802211:	83 c4 18             	add    $0x18,%esp
  802214:	53                   	push   %ebx
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	e8 2f df ff ff       	call   80014c <vcprintf>
	cprintf("\n");
  80221d:	c7 04 24 92 2b 80 00 	movl   $0x802b92,(%esp)
  802224:	e8 74 df ff ff       	call   80019d <cprintf>
  802229:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80222c:	cc                   	int3   
  80222d:	eb fd                	jmp    80222c <_panic+0x5e>

0080222f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	56                   	push   %esi
  802233:	53                   	push   %ebx
  802234:	8b 75 08             	mov    0x8(%ebp),%esi
  802237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80223d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80223f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802244:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	50                   	push   %eax
  80224b:	e8 4e ec ff ff       	call   800e9e <sys_ipc_recv>
	if(ret < 0){
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	85 c0                	test   %eax,%eax
  802255:	78 2b                	js     802282 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802257:	85 f6                	test   %esi,%esi
  802259:	74 0a                	je     802265 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80225b:	a1 08 40 80 00       	mov    0x804008,%eax
  802260:	8b 40 78             	mov    0x78(%eax),%eax
  802263:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802265:	85 db                	test   %ebx,%ebx
  802267:	74 0a                	je     802273 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802269:	a1 08 40 80 00       	mov    0x804008,%eax
  80226e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802271:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802273:	a1 08 40 80 00       	mov    0x804008,%eax
  802278:	8b 40 74             	mov    0x74(%eax),%eax
}
  80227b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227e:	5b                   	pop    %ebx
  80227f:	5e                   	pop    %esi
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    
		if(from_env_store)
  802282:	85 f6                	test   %esi,%esi
  802284:	74 06                	je     80228c <ipc_recv+0x5d>
			*from_env_store = 0;
  802286:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80228c:	85 db                	test   %ebx,%ebx
  80228e:	74 eb                	je     80227b <ipc_recv+0x4c>
			*perm_store = 0;
  802290:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802296:	eb e3                	jmp    80227b <ipc_recv+0x4c>

00802298 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	57                   	push   %edi
  80229c:	56                   	push   %esi
  80229d:	53                   	push   %ebx
  80229e:	83 ec 0c             	sub    $0xc,%esp
  8022a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022aa:	85 db                	test   %ebx,%ebx
  8022ac:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022b1:	0f 44 d8             	cmove  %eax,%ebx
  8022b4:	eb 05                	jmp    8022bb <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022b6:	e8 14 ea ff ff       	call   800ccf <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022bb:	ff 75 14             	pushl  0x14(%ebp)
  8022be:	53                   	push   %ebx
  8022bf:	56                   	push   %esi
  8022c0:	57                   	push   %edi
  8022c1:	e8 b5 eb ff ff       	call   800e7b <sys_ipc_try_send>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 1b                	je     8022e8 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022cd:	79 e7                	jns    8022b6 <ipc_send+0x1e>
  8022cf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d2:	74 e2                	je     8022b6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 7f 2b 80 00       	push   $0x802b7f
  8022dc:	6a 46                	push   $0x46
  8022de:	68 94 2b 80 00       	push   $0x802b94
  8022e3:	e8 e6 fe ff ff       	call   8021ce <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022fb:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802301:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802307:	8b 52 50             	mov    0x50(%edx),%edx
  80230a:	39 ca                	cmp    %ecx,%edx
  80230c:	74 11                	je     80231f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80230e:	83 c0 01             	add    $0x1,%eax
  802311:	3d 00 04 00 00       	cmp    $0x400,%eax
  802316:	75 e3                	jne    8022fb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
  80231d:	eb 0e                	jmp    80232d <ipc_find_env+0x3d>
			return envs[i].env_id;
  80231f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802325:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80232a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    

0080232f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802335:	89 d0                	mov    %edx,%eax
  802337:	c1 e8 16             	shr    $0x16,%eax
  80233a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802346:	f6 c1 01             	test   $0x1,%cl
  802349:	74 1d                	je     802368 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80234b:	c1 ea 0c             	shr    $0xc,%edx
  80234e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802355:	f6 c2 01             	test   $0x1,%dl
  802358:	74 0e                	je     802368 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80235a:	c1 ea 0c             	shr    $0xc,%edx
  80235d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802364:	ef 
  802365:	0f b7 c0             	movzwl %ax,%eax
}
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80237b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802387:	85 d2                	test   %edx,%edx
  802389:	75 4d                	jne    8023d8 <__udivdi3+0x68>
  80238b:	39 f3                	cmp    %esi,%ebx
  80238d:	76 19                	jbe    8023a8 <__udivdi3+0x38>
  80238f:	31 ff                	xor    %edi,%edi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f2                	mov    %esi,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 d9                	mov    %ebx,%ecx
  8023aa:	85 db                	test   %ebx,%ebx
  8023ac:	75 0b                	jne    8023b9 <__udivdi3+0x49>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f3                	div    %ebx
  8023b7:	89 c1                	mov    %eax,%ecx
  8023b9:	31 d2                	xor    %edx,%edx
  8023bb:	89 f0                	mov    %esi,%eax
  8023bd:	f7 f1                	div    %ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f7                	mov    %esi,%edi
  8023c5:	f7 f1                	div    %ecx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	77 1c                	ja     8023f8 <__udivdi3+0x88>
  8023dc:	0f bd fa             	bsr    %edx,%edi
  8023df:	83 f7 1f             	xor    $0x1f,%edi
  8023e2:	75 2c                	jne    802410 <__udivdi3+0xa0>
  8023e4:	39 f2                	cmp    %esi,%edx
  8023e6:	72 06                	jb     8023ee <__udivdi3+0x7e>
  8023e8:	31 c0                	xor    %eax,%eax
  8023ea:	39 eb                	cmp    %ebp,%ebx
  8023ec:	77 a9                	ja     802397 <__udivdi3+0x27>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	eb a2                	jmp    802397 <__udivdi3+0x27>
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	31 ff                	xor    %edi,%edi
  8023fa:	31 c0                	xor    %eax,%eax
  8023fc:	89 fa                	mov    %edi,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 f9                	mov    %edi,%ecx
  802412:	b8 20 00 00 00       	mov    $0x20,%eax
  802417:	29 f8                	sub    %edi,%eax
  802419:	d3 e2                	shl    %cl,%edx
  80241b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	89 da                	mov    %ebx,%edx
  802423:	d3 ea                	shr    %cl,%edx
  802425:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802429:	09 d1                	or     %edx,%ecx
  80242b:	89 f2                	mov    %esi,%edx
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 f9                	mov    %edi,%ecx
  802433:	d3 e3                	shl    %cl,%ebx
  802435:	89 c1                	mov    %eax,%ecx
  802437:	d3 ea                	shr    %cl,%edx
  802439:	89 f9                	mov    %edi,%ecx
  80243b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80243f:	89 eb                	mov    %ebp,%ebx
  802441:	d3 e6                	shl    %cl,%esi
  802443:	89 c1                	mov    %eax,%ecx
  802445:	d3 eb                	shr    %cl,%ebx
  802447:	09 de                	or     %ebx,%esi
  802449:	89 f0                	mov    %esi,%eax
  80244b:	f7 74 24 08          	divl   0x8(%esp)
  80244f:	89 d6                	mov    %edx,%esi
  802451:	89 c3                	mov    %eax,%ebx
  802453:	f7 64 24 0c          	mull   0xc(%esp)
  802457:	39 d6                	cmp    %edx,%esi
  802459:	72 15                	jb     802470 <__udivdi3+0x100>
  80245b:	89 f9                	mov    %edi,%ecx
  80245d:	d3 e5                	shl    %cl,%ebp
  80245f:	39 c5                	cmp    %eax,%ebp
  802461:	73 04                	jae    802467 <__udivdi3+0xf7>
  802463:	39 d6                	cmp    %edx,%esi
  802465:	74 09                	je     802470 <__udivdi3+0x100>
  802467:	89 d8                	mov    %ebx,%eax
  802469:	31 ff                	xor    %edi,%edi
  80246b:	e9 27 ff ff ff       	jmp    802397 <__udivdi3+0x27>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 1d ff ff ff       	jmp    802397 <__udivdi3+0x27>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80248b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80248f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	89 da                	mov    %ebx,%edx
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 43                	jne    8024e0 <__umoddi3+0x60>
  80249d:	39 df                	cmp    %ebx,%edi
  80249f:	76 17                	jbe    8024b8 <__umoddi3+0x38>
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	f7 f7                	div    %edi
  8024a5:	89 d0                	mov    %edx,%eax
  8024a7:	31 d2                	xor    %edx,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 fd                	mov    %edi,%ebp
  8024ba:	85 ff                	test   %edi,%edi
  8024bc:	75 0b                	jne    8024c9 <__umoddi3+0x49>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f7                	div    %edi
  8024c7:	89 c5                	mov    %eax,%ebp
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f5                	div    %ebp
  8024cf:	89 f0                	mov    %esi,%eax
  8024d1:	f7 f5                	div    %ebp
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	eb d0                	jmp    8024a7 <__umoddi3+0x27>
  8024d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	89 f1                	mov    %esi,%ecx
  8024e2:	39 d8                	cmp    %ebx,%eax
  8024e4:	76 0a                	jbe    8024f0 <__umoddi3+0x70>
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	83 c4 1c             	add    $0x1c,%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	0f bd e8             	bsr    %eax,%ebp
  8024f3:	83 f5 1f             	xor    $0x1f,%ebp
  8024f6:	75 20                	jne    802518 <__umoddi3+0x98>
  8024f8:	39 d8                	cmp    %ebx,%eax
  8024fa:	0f 82 b0 00 00 00    	jb     8025b0 <__umoddi3+0x130>
  802500:	39 f7                	cmp    %esi,%edi
  802502:	0f 86 a8 00 00 00    	jbe    8025b0 <__umoddi3+0x130>
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	83 c4 1c             	add    $0x1c,%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5f                   	pop    %edi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	ba 20 00 00 00       	mov    $0x20,%edx
  80251f:	29 ea                	sub    %ebp,%edx
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 44 24 08          	mov    %eax,0x8(%esp)
  802527:	89 d1                	mov    %edx,%ecx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	d3 e8                	shr    %cl,%eax
  80252d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802531:	89 54 24 04          	mov    %edx,0x4(%esp)
  802535:	8b 54 24 04          	mov    0x4(%esp),%edx
  802539:	09 c1                	or     %eax,%ecx
  80253b:	89 d8                	mov    %ebx,%eax
  80253d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e7                	shl    %cl,%edi
  802545:	89 d1                	mov    %edx,%ecx
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	d3 e3                	shl    %cl,%ebx
  802551:	89 c7                	mov    %eax,%edi
  802553:	89 d1                	mov    %edx,%ecx
  802555:	89 f0                	mov    %esi,%eax
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 fa                	mov    %edi,%edx
  80255d:	d3 e6                	shl    %cl,%esi
  80255f:	09 d8                	or     %ebx,%eax
  802561:	f7 74 24 08          	divl   0x8(%esp)
  802565:	89 d1                	mov    %edx,%ecx
  802567:	89 f3                	mov    %esi,%ebx
  802569:	f7 64 24 0c          	mull   0xc(%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d7                	mov    %edx,%edi
  802571:	39 d1                	cmp    %edx,%ecx
  802573:	72 06                	jb     80257b <__umoddi3+0xfb>
  802575:	75 10                	jne    802587 <__umoddi3+0x107>
  802577:	39 c3                	cmp    %eax,%ebx
  802579:	73 0c                	jae    802587 <__umoddi3+0x107>
  80257b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80257f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802583:	89 d7                	mov    %edx,%edi
  802585:	89 c6                	mov    %eax,%esi
  802587:	89 ca                	mov    %ecx,%edx
  802589:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258e:	29 f3                	sub    %esi,%ebx
  802590:	19 fa                	sbb    %edi,%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	d3 e0                	shl    %cl,%eax
  802596:	89 e9                	mov    %ebp,%ecx
  802598:	d3 eb                	shr    %cl,%ebx
  80259a:	d3 ea                	shr    %cl,%edx
  80259c:	09 d8                	or     %ebx,%eax
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 da                	mov    %ebx,%edx
  8025b2:	29 fe                	sub    %edi,%esi
  8025b4:	19 c2                	sbb    %eax,%edx
  8025b6:	89 f1                	mov    %esi,%ecx
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	e9 4b ff ff ff       	jmp    80250a <__umoddi3+0x8a>
