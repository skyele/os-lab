
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80003f:	68 20 25 80 00       	push   $0x802520
  800044:	e8 56 01 00 00       	call   80019f <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800057:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80005e:	00 00 00 
	envid_t find = sys_getenvid();
  800061:	e8 4c 0c 00 00       	call   800cb2 <sys_getenvid>
  800066:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80006c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800071:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800076:	bf 01 00 00 00       	mov    $0x1,%edi
  80007b:	eb 0b                	jmp    800088 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80007d:	83 c2 01             	add    $0x1,%edx
  800080:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800086:	74 21                	je     8000a9 <libmain+0x5b>
		if(envs[i].env_id == find)
  800088:	89 d1                	mov    %edx,%ecx
  80008a:	c1 e1 07             	shl    $0x7,%ecx
  80008d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800093:	8b 49 48             	mov    0x48(%ecx),%ecx
  800096:	39 c1                	cmp    %eax,%ecx
  800098:	75 e3                	jne    80007d <libmain+0x2f>
  80009a:	89 d3                	mov    %edx,%ebx
  80009c:	c1 e3 07             	shl    $0x7,%ebx
  80009f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a5:	89 fe                	mov    %edi,%esi
  8000a7:	eb d4                	jmp    80007d <libmain+0x2f>
  8000a9:	89 f0                	mov    %esi,%eax
  8000ab:	84 c0                	test   %al,%al
  8000ad:	74 06                	je     8000b5 <libmain+0x67>
  8000af:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x77>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 47 25 80 00       	push   $0x802547
  8000cd:	e8 cd 00 00 00       	call   80019f <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d2:	83 c4 08             	add    $0x8,%esp
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	ff 75 08             	pushl  0x8(%ebp)
  8000db:	e8 53 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0b 00 00 00       	call   8000f0 <exit>
}
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5f                   	pop    %edi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    

008000f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f6:	e8 a2 10 00 00       	call   80119d <close_all>
	sys_env_destroy(0);
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	6a 00                	push   $0x0
  800100:	e8 6c 0b 00 00       	call   800c71 <sys_env_destroy>
}
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	c9                   	leave  
  800109:	c3                   	ret    

0080010a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	53                   	push   %ebx
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800114:	8b 13                	mov    (%ebx),%edx
  800116:	8d 42 01             	lea    0x1(%edx),%eax
  800119:	89 03                	mov    %eax,(%ebx)
  80011b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800122:	3d ff 00 00 00       	cmp    $0xff,%eax
  800127:	74 09                	je     800132 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800129:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800130:	c9                   	leave  
  800131:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	68 ff 00 00 00       	push   $0xff
  80013a:	8d 43 08             	lea    0x8(%ebx),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 f1 0a 00 00       	call   800c34 <sys_cputs>
		b->idx = 0;
  800143:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	eb db                	jmp    800129 <putch+0x1f>

0080014e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800157:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015e:	00 00 00 
	b.cnt = 0;
  800161:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800168:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016b:	ff 75 0c             	pushl  0xc(%ebp)
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800177:	50                   	push   %eax
  800178:	68 0a 01 80 00       	push   $0x80010a
  80017d:	e8 4a 01 00 00       	call   8002cc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800182:	83 c4 08             	add    $0x8,%esp
  800185:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80018b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	e8 9d 0a 00 00       	call   800c34 <sys_cputs>

	return b.cnt;
}
  800197:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a8:	50                   	push   %eax
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 9d ff ff ff       	call   80014e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 1c             	sub    $0x1c,%esp
  8001bc:	89 c6                	mov    %eax,%esi
  8001be:	89 d7                	mov    %edx,%edi
  8001c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001d2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001d6:	74 2c                	je     800204 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e8:	39 c2                	cmp    %eax,%edx
  8001ea:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ed:	73 43                	jae    800232 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ef:	83 eb 01             	sub    $0x1,%ebx
  8001f2:	85 db                	test   %ebx,%ebx
  8001f4:	7e 6c                	jle    800262 <printnum+0xaf>
				putch(padc, putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	57                   	push   %edi
  8001fa:	ff 75 18             	pushl  0x18(%ebp)
  8001fd:	ff d6                	call   *%esi
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	eb eb                	jmp    8001ef <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	6a 20                	push   $0x20
  800209:	6a 00                	push   $0x0
  80020b:	50                   	push   %eax
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	89 fa                	mov    %edi,%edx
  800214:	89 f0                	mov    %esi,%eax
  800216:	e8 98 ff ff ff       	call   8001b3 <printnum>
		while (--width > 0)
  80021b:	83 c4 20             	add    $0x20,%esp
  80021e:	83 eb 01             	sub    $0x1,%ebx
  800221:	85 db                	test   %ebx,%ebx
  800223:	7e 65                	jle    80028a <printnum+0xd7>
			putch(padc, putdat);
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	57                   	push   %edi
  800229:	6a 20                	push   $0x20
  80022b:	ff d6                	call   *%esi
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb ec                	jmp    80021e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	ff 75 18             	pushl  0x18(%ebp)
  800238:	83 eb 01             	sub    $0x1,%ebx
  80023b:	53                   	push   %ebx
  80023c:	50                   	push   %eax
  80023d:	83 ec 08             	sub    $0x8,%esp
  800240:	ff 75 dc             	pushl  -0x24(%ebp)
  800243:	ff 75 d8             	pushl  -0x28(%ebp)
  800246:	ff 75 e4             	pushl  -0x1c(%ebp)
  800249:	ff 75 e0             	pushl  -0x20(%ebp)
  80024c:	e8 6f 20 00 00       	call   8022c0 <__udivdi3>
  800251:	83 c4 18             	add    $0x18,%esp
  800254:	52                   	push   %edx
  800255:	50                   	push   %eax
  800256:	89 fa                	mov    %edi,%edx
  800258:	89 f0                	mov    %esi,%eax
  80025a:	e8 54 ff ff ff       	call   8001b3 <printnum>
  80025f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	57                   	push   %edi
  800266:	83 ec 04             	sub    $0x4,%esp
  800269:	ff 75 dc             	pushl  -0x24(%ebp)
  80026c:	ff 75 d8             	pushl  -0x28(%ebp)
  80026f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800272:	ff 75 e0             	pushl  -0x20(%ebp)
  800275:	e8 56 21 00 00       	call   8023d0 <__umoddi3>
  80027a:	83 c4 14             	add    $0x14,%esp
  80027d:	0f be 80 6b 25 80 00 	movsbl 0x80256b(%eax),%eax
  800284:	50                   	push   %eax
  800285:	ff d6                	call   *%esi
  800287:	83 c4 10             	add    $0x10,%esp
	}
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    

00800292 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800298:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029c:	8b 10                	mov    (%eax),%edx
  80029e:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a1:	73 0a                	jae    8002ad <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a6:	89 08                	mov    %ecx,(%eax)
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	88 02                	mov    %al,(%edx)
}
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <printfmt>:
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 05 00 00 00       	call   8002cc <vprintfmt>
}
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    

008002cc <vprintfmt>:
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 3c             	sub    $0x3c,%esp
  8002d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002db:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002de:	e9 32 04 00 00       	jmp    800715 <vprintfmt+0x449>
		padc = ' ';
  8002e3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002ee:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800303:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80030a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	8d 47 01             	lea    0x1(%edi),%eax
  800312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800315:	0f b6 17             	movzbl (%edi),%edx
  800318:	8d 42 dd             	lea    -0x23(%edx),%eax
  80031b:	3c 55                	cmp    $0x55,%al
  80031d:	0f 87 12 05 00 00    	ja     800835 <vprintfmt+0x569>
  800323:	0f b6 c0             	movzbl %al,%eax
  800326:	ff 24 85 40 27 80 00 	jmp    *0x802740(,%eax,4)
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800330:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800334:	eb d9                	jmp    80030f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800339:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80033d:	eb d0                	jmp    80030f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033f:	0f b6 d2             	movzbl %dl,%edx
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800345:	b8 00 00 00 00       	mov    $0x0,%eax
  80034a:	89 75 08             	mov    %esi,0x8(%ebp)
  80034d:	eb 03                	jmp    800352 <vprintfmt+0x86>
  80034f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800352:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800355:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800359:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80035c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035f:	83 fe 09             	cmp    $0x9,%esi
  800362:	76 eb                	jbe    80034f <vprintfmt+0x83>
  800364:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800367:	8b 75 08             	mov    0x8(%ebp),%esi
  80036a:	eb 14                	jmp    800380 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80036c:	8b 45 14             	mov    0x14(%ebp),%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800374:	8b 45 14             	mov    0x14(%ebp),%eax
  800377:	8d 40 04             	lea    0x4(%eax),%eax
  80037a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800380:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800384:	79 89                	jns    80030f <vprintfmt+0x43>
				width = precision, precision = -1;
  800386:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800389:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80038c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800393:	e9 77 ff ff ff       	jmp    80030f <vprintfmt+0x43>
  800398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	0f 48 c1             	cmovs  %ecx,%eax
  8003a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a6:	e9 64 ff ff ff       	jmp    80030f <vprintfmt+0x43>
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ae:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b5:	e9 55 ff ff ff       	jmp    80030f <vprintfmt+0x43>
			lflag++;
  8003ba:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c1:	e9 49 ff ff ff       	jmp    80030f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8d 78 04             	lea    0x4(%eax),%edi
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	53                   	push   %ebx
  8003d0:	ff 30                	pushl  (%eax)
  8003d2:	ff d6                	call   *%esi
			break;
  8003d4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003da:	e9 33 03 00 00       	jmp    800712 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8d 78 04             	lea    0x4(%eax),%edi
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	99                   	cltd   
  8003e8:	31 d0                	xor    %edx,%eax
  8003ea:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ec:	83 f8 10             	cmp    $0x10,%eax
  8003ef:	7f 23                	jg     800414 <vprintfmt+0x148>
  8003f1:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  8003f8:	85 d2                	test   %edx,%edx
  8003fa:	74 18                	je     800414 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003fc:	52                   	push   %edx
  8003fd:	68 b9 29 80 00       	push   $0x8029b9
  800402:	53                   	push   %ebx
  800403:	56                   	push   %esi
  800404:	e8 a6 fe ff ff       	call   8002af <printfmt>
  800409:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040f:	e9 fe 02 00 00       	jmp    800712 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800414:	50                   	push   %eax
  800415:	68 83 25 80 00       	push   $0x802583
  80041a:	53                   	push   %ebx
  80041b:	56                   	push   %esi
  80041c:	e8 8e fe ff ff       	call   8002af <printfmt>
  800421:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800427:	e9 e6 02 00 00       	jmp    800712 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	83 c0 04             	add    $0x4,%eax
  800432:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80043a:	85 c9                	test   %ecx,%ecx
  80043c:	b8 7c 25 80 00       	mov    $0x80257c,%eax
  800441:	0f 45 c1             	cmovne %ecx,%eax
  800444:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800447:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044b:	7e 06                	jle    800453 <vprintfmt+0x187>
  80044d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800451:	75 0d                	jne    800460 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800456:	89 c7                	mov    %eax,%edi
  800458:	03 45 e0             	add    -0x20(%ebp),%eax
  80045b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045e:	eb 53                	jmp    8004b3 <vprintfmt+0x1e7>
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	ff 75 d8             	pushl  -0x28(%ebp)
  800466:	50                   	push   %eax
  800467:	e8 71 04 00 00       	call   8008dd <strnlen>
  80046c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046f:	29 c1                	sub    %eax,%ecx
  800471:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800479:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80047d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800480:	eb 0f                	jmp    800491 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	ff 75 e0             	pushl  -0x20(%ebp)
  800489:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	83 ef 01             	sub    $0x1,%edi
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	85 ff                	test   %edi,%edi
  800493:	7f ed                	jg     800482 <vprintfmt+0x1b6>
  800495:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800498:	85 c9                	test   %ecx,%ecx
  80049a:	b8 00 00 00 00       	mov    $0x0,%eax
  80049f:	0f 49 c1             	cmovns %ecx,%eax
  8004a2:	29 c1                	sub    %eax,%ecx
  8004a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a7:	eb aa                	jmp    800453 <vprintfmt+0x187>
					putch(ch, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	52                   	push   %edx
  8004ae:	ff d6                	call   *%esi
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b8:	83 c7 01             	add    $0x1,%edi
  8004bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004bf:	0f be d0             	movsbl %al,%edx
  8004c2:	85 d2                	test   %edx,%edx
  8004c4:	74 4b                	je     800511 <vprintfmt+0x245>
  8004c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ca:	78 06                	js     8004d2 <vprintfmt+0x206>
  8004cc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004d0:	78 1e                	js     8004f0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d6:	74 d1                	je     8004a9 <vprintfmt+0x1dd>
  8004d8:	0f be c0             	movsbl %al,%eax
  8004db:	83 e8 20             	sub    $0x20,%eax
  8004de:	83 f8 5e             	cmp    $0x5e,%eax
  8004e1:	76 c6                	jbe    8004a9 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 3f                	push   $0x3f
  8004e9:	ff d6                	call   *%esi
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	eb c3                	jmp    8004b3 <vprintfmt+0x1e7>
  8004f0:	89 cf                	mov    %ecx,%edi
  8004f2:	eb 0e                	jmp    800502 <vprintfmt+0x236>
				putch(' ', putdat);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	53                   	push   %ebx
  8004f8:	6a 20                	push   $0x20
  8004fa:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fc:	83 ef 01             	sub    $0x1,%edi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	85 ff                	test   %edi,%edi
  800504:	7f ee                	jg     8004f4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800509:	89 45 14             	mov    %eax,0x14(%ebp)
  80050c:	e9 01 02 00 00       	jmp    800712 <vprintfmt+0x446>
  800511:	89 cf                	mov    %ecx,%edi
  800513:	eb ed                	jmp    800502 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800515:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800518:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80051f:	e9 eb fd ff ff       	jmp    80030f <vprintfmt+0x43>
	if (lflag >= 2)
  800524:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800528:	7f 21                	jg     80054b <vprintfmt+0x27f>
	else if (lflag)
  80052a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80052e:	74 68                	je     800598 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800538:	89 c1                	mov    %eax,%ecx
  80053a:	c1 f9 1f             	sar    $0x1f,%ecx
  80053d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 40 04             	lea    0x4(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	eb 17                	jmp    800562 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 50 04             	mov    0x4(%eax),%edx
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800556:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 40 08             	lea    0x8(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800562:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800565:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800568:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80056e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800572:	78 3f                	js     8005b3 <vprintfmt+0x2e7>
			base = 10;
  800574:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800579:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80057d:	0f 84 71 01 00 00    	je     8006f4 <vprintfmt+0x428>
				putch('+', putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	6a 2b                	push   $0x2b
  800589:	ff d6                	call   *%esi
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 5c 01 00 00       	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	89 c1                	mov    %eax,%ecx
  8005a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b1:	eb af                	jmp    800562 <vprintfmt+0x296>
				putch('-', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	53                   	push   %ebx
  8005b7:	6a 2d                	push   $0x2d
  8005b9:	ff d6                	call   *%esi
				num = -(long long) num;
  8005bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c1:	f7 d8                	neg    %eax
  8005c3:	83 d2 00             	adc    $0x0,%edx
  8005c6:	f7 da                	neg    %edx
  8005c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 19 01 00 00       	jmp    8006f4 <vprintfmt+0x428>
	if (lflag >= 2)
  8005db:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005df:	7f 29                	jg     80060a <vprintfmt+0x33e>
	else if (lflag)
  8005e1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e5:	74 44                	je     80062b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	e9 ea 00 00 00       	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 50 04             	mov    0x4(%eax),%edx
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 40 08             	lea    0x8(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800621:	b8 0a 00 00 00       	mov    $0xa,%eax
  800626:	e9 c9 00 00 00       	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	ba 00 00 00 00       	mov    $0x0,%edx
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8d 40 04             	lea    0x4(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800644:	b8 0a 00 00 00       	mov    $0xa,%eax
  800649:	e9 a6 00 00 00       	jmp    8006f4 <vprintfmt+0x428>
			putch('0', putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	6a 30                	push   $0x30
  800654:	ff d6                	call   *%esi
	if (lflag >= 2)
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80065d:	7f 26                	jg     800685 <vprintfmt+0x3b9>
	else if (lflag)
  80065f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800663:	74 3e                	je     8006a3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067e:	b8 08 00 00 00       	mov    $0x8,%eax
  800683:	eb 6f                	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 50 04             	mov    0x4(%eax),%edx
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 08             	lea    0x8(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069c:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a1:	eb 51                	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c1:	eb 31                	jmp    8006f4 <vprintfmt+0x428>
			putch('0', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 30                	push   $0x30
  8006c9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006cb:	83 c4 08             	add    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	6a 78                	push   $0x78
  8006d1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006e3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ef:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f4:	83 ec 0c             	sub    $0xc,%esp
  8006f7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006fb:	52                   	push   %edx
  8006fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ff:	50                   	push   %eax
  800700:	ff 75 dc             	pushl  -0x24(%ebp)
  800703:	ff 75 d8             	pushl  -0x28(%ebp)
  800706:	89 da                	mov    %ebx,%edx
  800708:	89 f0                	mov    %esi,%eax
  80070a:	e8 a4 fa ff ff       	call   8001b3 <printnum>
			break;
  80070f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800712:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	83 c7 01             	add    $0x1,%edi
  800718:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071c:	83 f8 25             	cmp    $0x25,%eax
  80071f:	0f 84 be fb ff ff    	je     8002e3 <vprintfmt+0x17>
			if (ch == '\0')
  800725:	85 c0                	test   %eax,%eax
  800727:	0f 84 28 01 00 00    	je     800855 <vprintfmt+0x589>
			putch(ch, putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	50                   	push   %eax
  800732:	ff d6                	call   *%esi
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	eb dc                	jmp    800715 <vprintfmt+0x449>
	if (lflag >= 2)
  800739:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073d:	7f 26                	jg     800765 <vprintfmt+0x499>
	else if (lflag)
  80073f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800743:	74 41                	je     800786 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800752:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 40 04             	lea    0x4(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075e:	b8 10 00 00 00       	mov    $0x10,%eax
  800763:	eb 8f                	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 50 04             	mov    0x4(%eax),%edx
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 40 08             	lea    0x8(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	b8 10 00 00 00       	mov    $0x10,%eax
  800781:	e9 6e ff ff ff       	jmp    8006f4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a4:	e9 4b ff ff ff       	jmp    8006f4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	83 c0 04             	add    $0x4,%eax
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	85 c0                	test   %eax,%eax
  8007b9:	74 14                	je     8007cf <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007bb:	8b 13                	mov    (%ebx),%edx
  8007bd:	83 fa 7f             	cmp    $0x7f,%edx
  8007c0:	7f 37                	jg     8007f9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007c2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	e9 43 ff ff ff       	jmp    800712 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d4:	bf a1 26 80 00       	mov    $0x8026a1,%edi
							putch(ch, putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	53                   	push   %ebx
  8007dd:	50                   	push   %eax
  8007de:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007e0:	83 c7 01             	add    $0x1,%edi
  8007e3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	75 eb                	jne    8007d9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f4:	e9 19 ff ff ff       	jmp    800712 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800800:	bf d9 26 80 00       	mov    $0x8026d9,%edi
							putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80080c:	83 c7 01             	add    $0x1,%edi
  80080f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	85 c0                	test   %eax,%eax
  800818:	75 eb                	jne    800805 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80081a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
  800820:	e9 ed fe ff ff       	jmp    800712 <vprintfmt+0x446>
			putch(ch, putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	6a 25                	push   $0x25
  80082b:	ff d6                	call   *%esi
			break;
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	e9 dd fe ff ff       	jmp    800712 <vprintfmt+0x446>
			putch('%', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 25                	push   $0x25
  80083b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 f8                	mov    %edi,%eax
  800842:	eb 03                	jmp    800847 <vprintfmt+0x57b>
  800844:	83 e8 01             	sub    $0x1,%eax
  800847:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80084b:	75 f7                	jne    800844 <vprintfmt+0x578>
  80084d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800850:	e9 bd fe ff ff       	jmp    800712 <vprintfmt+0x446>
}
  800855:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800858:	5b                   	pop    %ebx
  800859:	5e                   	pop    %esi
  80085a:	5f                   	pop    %edi
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	83 ec 18             	sub    $0x18,%esp
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800870:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087a:	85 c0                	test   %eax,%eax
  80087c:	74 26                	je     8008a4 <vsnprintf+0x47>
  80087e:	85 d2                	test   %edx,%edx
  800880:	7e 22                	jle    8008a4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800882:	ff 75 14             	pushl  0x14(%ebp)
  800885:	ff 75 10             	pushl  0x10(%ebp)
  800888:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088b:	50                   	push   %eax
  80088c:	68 92 02 80 00       	push   $0x800292
  800891:	e8 36 fa ff ff       	call   8002cc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800899:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80089c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089f:	83 c4 10             	add    $0x10,%esp
}
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    
		return -E_INVAL;
  8008a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a9:	eb f7                	jmp    8008a2 <vsnprintf+0x45>

008008ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b4:	50                   	push   %eax
  8008b5:	ff 75 10             	pushl  0x10(%ebp)
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	ff 75 08             	pushl  0x8(%ebp)
  8008be:	e8 9a ff ff ff       	call   80085d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d4:	74 05                	je     8008db <strlen+0x16>
		n++;
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	eb f5                	jmp    8008d0 <strlen+0xb>
	return n;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008eb:	39 c2                	cmp    %eax,%edx
  8008ed:	74 0d                	je     8008fc <strnlen+0x1f>
  8008ef:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008f3:	74 05                	je     8008fa <strnlen+0x1d>
		n++;
  8008f5:	83 c2 01             	add    $0x1,%edx
  8008f8:	eb f1                	jmp    8008eb <strnlen+0xe>
  8008fa:	89 d0                	mov    %edx,%eax
	return n;
}
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	53                   	push   %ebx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800911:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800914:	83 c2 01             	add    $0x1,%edx
  800917:	84 c9                	test   %cl,%cl
  800919:	75 f2                	jne    80090d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80091b:	5b                   	pop    %ebx
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	83 ec 10             	sub    $0x10,%esp
  800925:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800928:	53                   	push   %ebx
  800929:	e8 97 ff ff ff       	call   8008c5 <strlen>
  80092e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	01 d8                	add    %ebx,%eax
  800936:	50                   	push   %eax
  800937:	e8 c2 ff ff ff       	call   8008fe <strcpy>
	return dst;
}
  80093c:	89 d8                	mov    %ebx,%eax
  80093e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	56                   	push   %esi
  800947:	53                   	push   %ebx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094e:	89 c6                	mov    %eax,%esi
  800950:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800953:	89 c2                	mov    %eax,%edx
  800955:	39 f2                	cmp    %esi,%edx
  800957:	74 11                	je     80096a <strncpy+0x27>
		*dst++ = *src;
  800959:	83 c2 01             	add    $0x1,%edx
  80095c:	0f b6 19             	movzbl (%ecx),%ebx
  80095f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800962:	80 fb 01             	cmp    $0x1,%bl
  800965:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800968:	eb eb                	jmp    800955 <strncpy+0x12>
	}
	return ret;
}
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 75 08             	mov    0x8(%ebp),%esi
  800976:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800979:	8b 55 10             	mov    0x10(%ebp),%edx
  80097c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097e:	85 d2                	test   %edx,%edx
  800980:	74 21                	je     8009a3 <strlcpy+0x35>
  800982:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800986:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800988:	39 c2                	cmp    %eax,%edx
  80098a:	74 14                	je     8009a0 <strlcpy+0x32>
  80098c:	0f b6 19             	movzbl (%ecx),%ebx
  80098f:	84 db                	test   %bl,%bl
  800991:	74 0b                	je     80099e <strlcpy+0x30>
			*dst++ = *src++;
  800993:	83 c1 01             	add    $0x1,%ecx
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	88 5a ff             	mov    %bl,-0x1(%edx)
  80099c:	eb ea                	jmp    800988 <strlcpy+0x1a>
  80099e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009a0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a3:	29 f0                	sub    %esi,%eax
}
  8009a5:	5b                   	pop    %ebx
  8009a6:	5e                   	pop    %esi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b2:	0f b6 01             	movzbl (%ecx),%eax
  8009b5:	84 c0                	test   %al,%al
  8009b7:	74 0c                	je     8009c5 <strcmp+0x1c>
  8009b9:	3a 02                	cmp    (%edx),%al
  8009bb:	75 08                	jne    8009c5 <strcmp+0x1c>
		p++, q++;
  8009bd:	83 c1 01             	add    $0x1,%ecx
  8009c0:	83 c2 01             	add    $0x1,%edx
  8009c3:	eb ed                	jmp    8009b2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c5:	0f b6 c0             	movzbl %al,%eax
  8009c8:	0f b6 12             	movzbl (%edx),%edx
  8009cb:	29 d0                	sub    %edx,%eax
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	89 c3                	mov    %eax,%ebx
  8009db:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009de:	eb 06                	jmp    8009e6 <strncmp+0x17>
		n--, p++, q++;
  8009e0:	83 c0 01             	add    $0x1,%eax
  8009e3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e6:	39 d8                	cmp    %ebx,%eax
  8009e8:	74 16                	je     800a00 <strncmp+0x31>
  8009ea:	0f b6 08             	movzbl (%eax),%ecx
  8009ed:	84 c9                	test   %cl,%cl
  8009ef:	74 04                	je     8009f5 <strncmp+0x26>
  8009f1:	3a 0a                	cmp    (%edx),%cl
  8009f3:	74 eb                	je     8009e0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f5:	0f b6 00             	movzbl (%eax),%eax
  8009f8:	0f b6 12             	movzbl (%edx),%edx
  8009fb:	29 d0                	sub    %edx,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    
		return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb f6                	jmp    8009fd <strncmp+0x2e>

00800a07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a11:	0f b6 10             	movzbl (%eax),%edx
  800a14:	84 d2                	test   %dl,%dl
  800a16:	74 09                	je     800a21 <strchr+0x1a>
		if (*s == c)
  800a18:	38 ca                	cmp    %cl,%dl
  800a1a:	74 0a                	je     800a26 <strchr+0x1f>
	for (; *s; s++)
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	eb f0                	jmp    800a11 <strchr+0xa>
			return (char *) s;
	return 0;
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a32:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a35:	38 ca                	cmp    %cl,%dl
  800a37:	74 09                	je     800a42 <strfind+0x1a>
  800a39:	84 d2                	test   %dl,%dl
  800a3b:	74 05                	je     800a42 <strfind+0x1a>
	for (; *s; s++)
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	eb f0                	jmp    800a32 <strfind+0xa>
			break;
	return (char *) s;
}
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	57                   	push   %edi
  800a48:	56                   	push   %esi
  800a49:	53                   	push   %ebx
  800a4a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a50:	85 c9                	test   %ecx,%ecx
  800a52:	74 31                	je     800a85 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a54:	89 f8                	mov    %edi,%eax
  800a56:	09 c8                	or     %ecx,%eax
  800a58:	a8 03                	test   $0x3,%al
  800a5a:	75 23                	jne    800a7f <memset+0x3b>
		c &= 0xFF;
  800a5c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a60:	89 d3                	mov    %edx,%ebx
  800a62:	c1 e3 08             	shl    $0x8,%ebx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 18             	shl    $0x18,%eax
  800a6a:	89 d6                	mov    %edx,%esi
  800a6c:	c1 e6 10             	shl    $0x10,%esi
  800a6f:	09 f0                	or     %esi,%eax
  800a71:	09 c2                	or     %eax,%edx
  800a73:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a75:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a7d:	eb 06                	jmp    800a85 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	fc                   	cld    
  800a83:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a85:	89 f8                	mov    %edi,%eax
  800a87:	5b                   	pop    %ebx
  800a88:	5e                   	pop    %esi
  800a89:	5f                   	pop    %edi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	57                   	push   %edi
  800a90:	56                   	push   %esi
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a9a:	39 c6                	cmp    %eax,%esi
  800a9c:	73 32                	jae    800ad0 <memmove+0x44>
  800a9e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa1:	39 c2                	cmp    %eax,%edx
  800aa3:	76 2b                	jbe    800ad0 <memmove+0x44>
		s += n;
		d += n;
  800aa5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa8:	89 fe                	mov    %edi,%esi
  800aaa:	09 ce                	or     %ecx,%esi
  800aac:	09 d6                	or     %edx,%esi
  800aae:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab4:	75 0e                	jne    800ac4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab6:	83 ef 04             	sub    $0x4,%edi
  800ab9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800abf:	fd                   	std    
  800ac0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac2:	eb 09                	jmp    800acd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac4:	83 ef 01             	sub    $0x1,%edi
  800ac7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aca:	fd                   	std    
  800acb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800acd:	fc                   	cld    
  800ace:	eb 1a                	jmp    800aea <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	09 ca                	or     %ecx,%edx
  800ad4:	09 f2                	or     %esi,%edx
  800ad6:	f6 c2 03             	test   $0x3,%dl
  800ad9:	75 0a                	jne    800ae5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800adb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae3:	eb 05                	jmp    800aea <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae5:	89 c7                	mov    %eax,%edi
  800ae7:	fc                   	cld    
  800ae8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af4:	ff 75 10             	pushl  0x10(%ebp)
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 8a ff ff ff       	call   800a8c <memmove>
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0f:	89 c6                	mov    %eax,%esi
  800b11:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b14:	39 f0                	cmp    %esi,%eax
  800b16:	74 1c                	je     800b34 <memcmp+0x30>
		if (*s1 != *s2)
  800b18:	0f b6 08             	movzbl (%eax),%ecx
  800b1b:	0f b6 1a             	movzbl (%edx),%ebx
  800b1e:	38 d9                	cmp    %bl,%cl
  800b20:	75 08                	jne    800b2a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b22:	83 c0 01             	add    $0x1,%eax
  800b25:	83 c2 01             	add    $0x1,%edx
  800b28:	eb ea                	jmp    800b14 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b2a:	0f b6 c1             	movzbl %cl,%eax
  800b2d:	0f b6 db             	movzbl %bl,%ebx
  800b30:	29 d8                	sub    %ebx,%eax
  800b32:	eb 05                	jmp    800b39 <memcmp+0x35>
	}

	return 0;
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b46:	89 c2                	mov    %eax,%edx
  800b48:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b4b:	39 d0                	cmp    %edx,%eax
  800b4d:	73 09                	jae    800b58 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4f:	38 08                	cmp    %cl,(%eax)
  800b51:	74 05                	je     800b58 <memfind+0x1b>
	for (; s < ends; s++)
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	eb f3                	jmp    800b4b <memfind+0xe>
			break;
	return (void *) s;
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b66:	eb 03                	jmp    800b6b <strtol+0x11>
		s++;
  800b68:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b6b:	0f b6 01             	movzbl (%ecx),%eax
  800b6e:	3c 20                	cmp    $0x20,%al
  800b70:	74 f6                	je     800b68 <strtol+0xe>
  800b72:	3c 09                	cmp    $0x9,%al
  800b74:	74 f2                	je     800b68 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b76:	3c 2b                	cmp    $0x2b,%al
  800b78:	74 2a                	je     800ba4 <strtol+0x4a>
	int neg = 0;
  800b7a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7f:	3c 2d                	cmp    $0x2d,%al
  800b81:	74 2b                	je     800bae <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b83:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b89:	75 0f                	jne    800b9a <strtol+0x40>
  800b8b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8e:	74 28                	je     800bb8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b90:	85 db                	test   %ebx,%ebx
  800b92:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b97:	0f 44 d8             	cmove  %eax,%ebx
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba2:	eb 50                	jmp    800bf4 <strtol+0x9a>
		s++;
  800ba4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bac:	eb d5                	jmp    800b83 <strtol+0x29>
		s++, neg = 1;
  800bae:	83 c1 01             	add    $0x1,%ecx
  800bb1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb6:	eb cb                	jmp    800b83 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bbc:	74 0e                	je     800bcc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	75 d8                	jne    800b9a <strtol+0x40>
		s++, base = 8;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bca:	eb ce                	jmp    800b9a <strtol+0x40>
		s += 2, base = 16;
  800bcc:	83 c1 02             	add    $0x2,%ecx
  800bcf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd4:	eb c4                	jmp    800b9a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd9:	89 f3                	mov    %esi,%ebx
  800bdb:	80 fb 19             	cmp    $0x19,%bl
  800bde:	77 29                	ja     800c09 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800be0:	0f be d2             	movsbl %dl,%edx
  800be3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be9:	7d 30                	jge    800c1b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800beb:	83 c1 01             	add    $0x1,%ecx
  800bee:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf4:	0f b6 11             	movzbl (%ecx),%edx
  800bf7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bfa:	89 f3                	mov    %esi,%ebx
  800bfc:	80 fb 09             	cmp    $0x9,%bl
  800bff:	77 d5                	ja     800bd6 <strtol+0x7c>
			dig = *s - '0';
  800c01:	0f be d2             	movsbl %dl,%edx
  800c04:	83 ea 30             	sub    $0x30,%edx
  800c07:	eb dd                	jmp    800be6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c09:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0c:	89 f3                	mov    %esi,%ebx
  800c0e:	80 fb 19             	cmp    $0x19,%bl
  800c11:	77 08                	ja     800c1b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c13:	0f be d2             	movsbl %dl,%edx
  800c16:	83 ea 37             	sub    $0x37,%edx
  800c19:	eb cb                	jmp    800be6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1f:	74 05                	je     800c26 <strtol+0xcc>
		*endptr = (char *) s;
  800c21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c24:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c26:	89 c2                	mov    %eax,%edx
  800c28:	f7 da                	neg    %edx
  800c2a:	85 ff                	test   %edi,%edi
  800c2c:	0f 45 c2             	cmovne %edx,%eax
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c45:	89 c3                	mov    %eax,%ebx
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	89 c6                	mov    %eax,%esi
  800c4b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c62:	89 d1                	mov    %edx,%ecx
  800c64:	89 d3                	mov    %edx,%ebx
  800c66:	89 d7                	mov    %edx,%edi
  800c68:	89 d6                	mov    %edx,%esi
  800c6a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	b8 03 00 00 00       	mov    $0x3,%eax
  800c87:	89 cb                	mov    %ecx,%ebx
  800c89:	89 cf                	mov    %ecx,%edi
  800c8b:	89 ce                	mov    %ecx,%esi
  800c8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	6a 03                	push   $0x3
  800ca1:	68 e4 28 80 00       	push   $0x8028e4
  800ca6:	6a 43                	push   $0x43
  800ca8:	68 01 29 80 00       	push   $0x802901
  800cad:	e8 69 14 00 00       	call   80211b <_panic>

00800cb2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc2:	89 d1                	mov    %edx,%ecx
  800cc4:	89 d3                	mov    %edx,%ebx
  800cc6:	89 d7                	mov    %edx,%edi
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_yield>:

void
sys_yield(void)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce1:	89 d1                	mov    %edx,%ecx
  800ce3:	89 d3                	mov    %edx,%ebx
  800ce5:	89 d7                	mov    %edx,%edi
  800ce7:	89 d6                	mov    %edx,%esi
  800ce9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf9:	be 00 00 00 00       	mov    $0x0,%esi
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	b8 04 00 00 00       	mov    $0x4,%eax
  800d09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0c:	89 f7                	mov    %esi,%edi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 04                	push   $0x4
  800d22:	68 e4 28 80 00       	push   $0x8028e4
  800d27:	6a 43                	push   $0x43
  800d29:	68 01 29 80 00       	push   $0x802901
  800d2e:	e8 e8 13 00 00       	call   80211b <_panic>

00800d33 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 05 00 00 00       	mov    $0x5,%eax
  800d47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 05                	push   $0x5
  800d64:	68 e4 28 80 00       	push   $0x8028e4
  800d69:	6a 43                	push   $0x43
  800d6b:	68 01 29 80 00       	push   $0x802901
  800d70:	e8 a6 13 00 00       	call   80211b <_panic>

00800d75 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 06                	push   $0x6
  800da6:	68 e4 28 80 00       	push   $0x8028e4
  800dab:	6a 43                	push   $0x43
  800dad:	68 01 29 80 00       	push   $0x802901
  800db2:	e8 64 13 00 00       	call   80211b <_panic>

00800db7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd0:	89 df                	mov    %ebx,%edi
  800dd2:	89 de                	mov    %ebx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 08                	push   $0x8
  800de8:	68 e4 28 80 00       	push   $0x8028e4
  800ded:	6a 43                	push   $0x43
  800def:	68 01 29 80 00       	push   $0x802901
  800df4:	e8 22 13 00 00       	call   80211b <_panic>

00800df9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e12:	89 df                	mov    %ebx,%edi
  800e14:	89 de                	mov    %ebx,%esi
  800e16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7f 08                	jg     800e24 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e24:	83 ec 0c             	sub    $0xc,%esp
  800e27:	50                   	push   %eax
  800e28:	6a 09                	push   $0x9
  800e2a:	68 e4 28 80 00       	push   $0x8028e4
  800e2f:	6a 43                	push   $0x43
  800e31:	68 01 29 80 00       	push   $0x802901
  800e36:	e8 e0 12 00 00       	call   80211b <_panic>

00800e3b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7f 08                	jg     800e66 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	50                   	push   %eax
  800e6a:	6a 0a                	push   $0xa
  800e6c:	68 e4 28 80 00       	push   $0x8028e4
  800e71:	6a 43                	push   $0x43
  800e73:	68 01 29 80 00       	push   $0x802901
  800e78:	e8 9e 12 00 00       	call   80211b <_panic>

00800e7d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8e:	be 00 00 00 00       	mov    $0x0,%esi
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0d                	push   $0xd
  800ed0:	68 e4 28 80 00       	push   $0x8028e4
  800ed5:	6a 43                	push   $0x43
  800ed7:	68 01 29 80 00       	push   $0x802901
  800edc:	e8 3a 12 00 00       	call   80211b <_panic>

00800ee1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef7:	89 df                	mov    %ebx,%edi
  800ef9:	89 de                	mov    %ebx,%esi
  800efb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f15:	89 cb                	mov    %ecx,%ebx
  800f17:	89 cf                	mov    %ecx,%edi
  800f19:	89 ce                	mov    %ecx,%esi
  800f1b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	89 d3                	mov    %edx,%ebx
  800f36:	89 d7                	mov    %edx,%edi
  800f38:	89 d6                	mov    %edx,%esi
  800f3a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f52:	b8 11 00 00 00       	mov    $0x11,%eax
  800f57:	89 df                	mov    %ebx,%edi
  800f59:	89 de                	mov    %ebx,%esi
  800f5b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	b8 12 00 00 00       	mov    $0x12,%eax
  800f78:	89 df                	mov    %ebx,%edi
  800f7a:	89 de                	mov    %ebx,%esi
  800f7c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	57                   	push   %edi
  800f87:	56                   	push   %esi
  800f88:	53                   	push   %ebx
  800f89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	b8 13 00 00 00       	mov    $0x13,%eax
  800f9c:	89 df                	mov    %ebx,%edi
  800f9e:	89 de                	mov    %ebx,%esi
  800fa0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	7f 08                	jg     800fae <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	50                   	push   %eax
  800fb2:	6a 13                	push   $0x13
  800fb4:	68 e4 28 80 00       	push   $0x8028e4
  800fb9:	6a 43                	push   $0x43
  800fbb:	68 01 29 80 00       	push   $0x802901
  800fc0:	e8 56 11 00 00       	call   80211b <_panic>

00800fc5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fd0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fe0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	c1 ea 16             	shr    $0x16,%edx
  800ff9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801000:	f6 c2 01             	test   $0x1,%dl
  801003:	74 2d                	je     801032 <fd_alloc+0x46>
  801005:	89 c2                	mov    %eax,%edx
  801007:	c1 ea 0c             	shr    $0xc,%edx
  80100a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801011:	f6 c2 01             	test   $0x1,%dl
  801014:	74 1c                	je     801032 <fd_alloc+0x46>
  801016:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80101b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801020:	75 d2                	jne    800ff4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80102b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801030:	eb 0a                	jmp    80103c <fd_alloc+0x50>
			*fd_store = fd;
  801032:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801035:	89 01                	mov    %eax,(%ecx)
			return 0;
  801037:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801044:	83 f8 1f             	cmp    $0x1f,%eax
  801047:	77 30                	ja     801079 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801049:	c1 e0 0c             	shl    $0xc,%eax
  80104c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801051:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801057:	f6 c2 01             	test   $0x1,%dl
  80105a:	74 24                	je     801080 <fd_lookup+0x42>
  80105c:	89 c2                	mov    %eax,%edx
  80105e:	c1 ea 0c             	shr    $0xc,%edx
  801061:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801068:	f6 c2 01             	test   $0x1,%dl
  80106b:	74 1a                	je     801087 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	89 02                	mov    %eax,(%edx)
	return 0;
  801072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		return -E_INVAL;
  801079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107e:	eb f7                	jmp    801077 <fd_lookup+0x39>
		return -E_INVAL;
  801080:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801085:	eb f0                	jmp    801077 <fd_lookup+0x39>
  801087:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108c:	eb e9                	jmp    801077 <fd_lookup+0x39>

0080108e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801097:	ba 00 00 00 00       	mov    $0x0,%edx
  80109c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010a1:	39 08                	cmp    %ecx,(%eax)
  8010a3:	74 38                	je     8010dd <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010a5:	83 c2 01             	add    $0x1,%edx
  8010a8:	8b 04 95 8c 29 80 00 	mov    0x80298c(,%edx,4),%eax
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	75 ee                	jne    8010a1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b8:	8b 40 48             	mov    0x48(%eax),%eax
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	51                   	push   %ecx
  8010bf:	50                   	push   %eax
  8010c0:	68 10 29 80 00       	push   $0x802910
  8010c5:	e8 d5 f0 ff ff       	call   80019f <cprintf>
	*dev = 0;
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    
			*dev = devtab[i];
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e7:	eb f2                	jmp    8010db <dev_lookup+0x4d>

008010e9 <fd_close>:
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 24             	sub    $0x24,%esp
  8010f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010fb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801102:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801105:	50                   	push   %eax
  801106:	e8 33 ff ff ff       	call   80103e <fd_lookup>
  80110b:	89 c3                	mov    %eax,%ebx
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 05                	js     801119 <fd_close+0x30>
	    || fd != fd2)
  801114:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801117:	74 16                	je     80112f <fd_close+0x46>
		return (must_exist ? r : 0);
  801119:	89 f8                	mov    %edi,%eax
  80111b:	84 c0                	test   %al,%al
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
  801122:	0f 44 d8             	cmove  %eax,%ebx
}
  801125:	89 d8                	mov    %ebx,%eax
  801127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5f                   	pop    %edi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	ff 36                	pushl  (%esi)
  801138:	e8 51 ff ff ff       	call   80108e <dev_lookup>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 1a                	js     801160 <fd_close+0x77>
		if (dev->dev_close)
  801146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801149:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801151:	85 c0                	test   %eax,%eax
  801153:	74 0b                	je     801160 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	56                   	push   %esi
  801159:	ff d0                	call   *%eax
  80115b:	89 c3                	mov    %eax,%ebx
  80115d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	56                   	push   %esi
  801164:	6a 00                	push   $0x0
  801166:	e8 0a fc ff ff       	call   800d75 <sys_page_unmap>
	return r;
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	eb b5                	jmp    801125 <fd_close+0x3c>

00801170 <close>:

int
close(int fdnum)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801176:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801179:	50                   	push   %eax
  80117a:	ff 75 08             	pushl  0x8(%ebp)
  80117d:	e8 bc fe ff ff       	call   80103e <fd_lookup>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	79 02                	jns    80118b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    
		return fd_close(fd, 1);
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	6a 01                	push   $0x1
  801190:	ff 75 f4             	pushl  -0xc(%ebp)
  801193:	e8 51 ff ff ff       	call   8010e9 <fd_close>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	eb ec                	jmp    801189 <close+0x19>

0080119d <close_all>:

void
close_all(void)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	53                   	push   %ebx
  8011a1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	53                   	push   %ebx
  8011ad:	e8 be ff ff ff       	call   801170 <close>
	for (i = 0; i < MAXFD; i++)
  8011b2:	83 c3 01             	add    $0x1,%ebx
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	83 fb 20             	cmp    $0x20,%ebx
  8011bb:	75 ec                	jne    8011a9 <close_all+0xc>
}
  8011bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    

008011c2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ce:	50                   	push   %eax
  8011cf:	ff 75 08             	pushl  0x8(%ebp)
  8011d2:	e8 67 fe ff ff       	call   80103e <fd_lookup>
  8011d7:	89 c3                	mov    %eax,%ebx
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	0f 88 81 00 00 00    	js     801265 <dup+0xa3>
		return r;
	close(newfdnum);
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	e8 81 ff ff ff       	call   801170 <close>

	newfd = INDEX2FD(newfdnum);
  8011ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011f2:	c1 e6 0c             	shl    $0xc,%esi
  8011f5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011fb:	83 c4 04             	add    $0x4,%esp
  8011fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801201:	e8 cf fd ff ff       	call   800fd5 <fd2data>
  801206:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801208:	89 34 24             	mov    %esi,(%esp)
  80120b:	e8 c5 fd ff ff       	call   800fd5 <fd2data>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801215:	89 d8                	mov    %ebx,%eax
  801217:	c1 e8 16             	shr    $0x16,%eax
  80121a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801221:	a8 01                	test   $0x1,%al
  801223:	74 11                	je     801236 <dup+0x74>
  801225:	89 d8                	mov    %ebx,%eax
  801227:	c1 e8 0c             	shr    $0xc,%eax
  80122a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801231:	f6 c2 01             	test   $0x1,%dl
  801234:	75 39                	jne    80126f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801236:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801239:	89 d0                	mov    %edx,%eax
  80123b:	c1 e8 0c             	shr    $0xc,%eax
  80123e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	25 07 0e 00 00       	and    $0xe07,%eax
  80124d:	50                   	push   %eax
  80124e:	56                   	push   %esi
  80124f:	6a 00                	push   $0x0
  801251:	52                   	push   %edx
  801252:	6a 00                	push   $0x0
  801254:	e8 da fa ff ff       	call   800d33 <sys_page_map>
  801259:	89 c3                	mov    %eax,%ebx
  80125b:	83 c4 20             	add    $0x20,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 31                	js     801293 <dup+0xd1>
		goto err;

	return newfdnum;
  801262:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801265:	89 d8                	mov    %ebx,%eax
  801267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80126f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801276:	83 ec 0c             	sub    $0xc,%esp
  801279:	25 07 0e 00 00       	and    $0xe07,%eax
  80127e:	50                   	push   %eax
  80127f:	57                   	push   %edi
  801280:	6a 00                	push   $0x0
  801282:	53                   	push   %ebx
  801283:	6a 00                	push   $0x0
  801285:	e8 a9 fa ff ff       	call   800d33 <sys_page_map>
  80128a:	89 c3                	mov    %eax,%ebx
  80128c:	83 c4 20             	add    $0x20,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	79 a3                	jns    801236 <dup+0x74>
	sys_page_unmap(0, newfd);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	56                   	push   %esi
  801297:	6a 00                	push   $0x0
  801299:	e8 d7 fa ff ff       	call   800d75 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	57                   	push   %edi
  8012a2:	6a 00                	push   $0x0
  8012a4:	e8 cc fa ff ff       	call   800d75 <sys_page_unmap>
	return r;
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	eb b7                	jmp    801265 <dup+0xa3>

008012ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 1c             	sub    $0x1c,%esp
  8012b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012bb:	50                   	push   %eax
  8012bc:	53                   	push   %ebx
  8012bd:	e8 7c fd ff ff       	call   80103e <fd_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 3f                	js     801308 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cf:	50                   	push   %eax
  8012d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d3:	ff 30                	pushl  (%eax)
  8012d5:	e8 b4 fd ff ff       	call   80108e <dev_lookup>
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	78 27                	js     801308 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012e4:	8b 42 08             	mov    0x8(%edx),%eax
  8012e7:	83 e0 03             	and    $0x3,%eax
  8012ea:	83 f8 01             	cmp    $0x1,%eax
  8012ed:	74 1e                	je     80130d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f2:	8b 40 08             	mov    0x8(%eax),%eax
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 35                	je     80132e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	ff 75 10             	pushl  0x10(%ebp)
  8012ff:	ff 75 0c             	pushl  0xc(%ebp)
  801302:	52                   	push   %edx
  801303:	ff d0                	call   *%eax
  801305:	83 c4 10             	add    $0x10,%esp
}
  801308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80130d:	a1 08 40 80 00       	mov    0x804008,%eax
  801312:	8b 40 48             	mov    0x48(%eax),%eax
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	53                   	push   %ebx
  801319:	50                   	push   %eax
  80131a:	68 51 29 80 00       	push   $0x802951
  80131f:	e8 7b ee ff ff       	call   80019f <cprintf>
		return -E_INVAL;
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132c:	eb da                	jmp    801308 <read+0x5a>
		return -E_NOT_SUPP;
  80132e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801333:	eb d3                	jmp    801308 <read+0x5a>

00801335 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801341:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
  801349:	39 f3                	cmp    %esi,%ebx
  80134b:	73 23                	jae    801370 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	89 f0                	mov    %esi,%eax
  801352:	29 d8                	sub    %ebx,%eax
  801354:	50                   	push   %eax
  801355:	89 d8                	mov    %ebx,%eax
  801357:	03 45 0c             	add    0xc(%ebp),%eax
  80135a:	50                   	push   %eax
  80135b:	57                   	push   %edi
  80135c:	e8 4d ff ff ff       	call   8012ae <read>
		if (m < 0)
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 06                	js     80136e <readn+0x39>
			return m;
		if (m == 0)
  801368:	74 06                	je     801370 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80136a:	01 c3                	add    %eax,%ebx
  80136c:	eb db                	jmp    801349 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801370:	89 d8                	mov    %ebx,%eax
  801372:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 1c             	sub    $0x1c,%esp
  801381:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801384:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	53                   	push   %ebx
  801389:	e8 b0 fc ff ff       	call   80103e <fd_lookup>
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 3a                	js     8013cf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139f:	ff 30                	pushl  (%eax)
  8013a1:	e8 e8 fc ff ff       	call   80108e <dev_lookup>
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 22                	js     8013cf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b4:	74 1e                	je     8013d4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013bc:	85 d2                	test   %edx,%edx
  8013be:	74 35                	je     8013f5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	ff 75 10             	pushl  0x10(%ebp)
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	50                   	push   %eax
  8013ca:	ff d2                	call   *%edx
  8013cc:	83 c4 10             	add    $0x10,%esp
}
  8013cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d9:	8b 40 48             	mov    0x48(%eax),%eax
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	53                   	push   %ebx
  8013e0:	50                   	push   %eax
  8013e1:	68 6d 29 80 00       	push   $0x80296d
  8013e6:	e8 b4 ed ff ff       	call   80019f <cprintf>
		return -E_INVAL;
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f3:	eb da                	jmp    8013cf <write+0x55>
		return -E_NOT_SUPP;
  8013f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013fa:	eb d3                	jmp    8013cf <write+0x55>

008013fc <seek>:

int
seek(int fdnum, off_t offset)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801405:	50                   	push   %eax
  801406:	ff 75 08             	pushl  0x8(%ebp)
  801409:	e8 30 fc ff ff       	call   80103e <fd_lookup>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 0e                	js     801423 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801415:	8b 55 0c             	mov    0xc(%ebp),%edx
  801418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	53                   	push   %ebx
  801429:	83 ec 1c             	sub    $0x1c,%esp
  80142c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	53                   	push   %ebx
  801434:	e8 05 fc ff ff       	call   80103e <fd_lookup>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 37                	js     801477 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801440:	83 ec 08             	sub    $0x8,%esp
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	ff 30                	pushl  (%eax)
  80144c:	e8 3d fc ff ff       	call   80108e <dev_lookup>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 1f                	js     801477 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145f:	74 1b                	je     80147c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	8b 52 18             	mov    0x18(%edx),%edx
  801467:	85 d2                	test   %edx,%edx
  801469:	74 32                	je     80149d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	50                   	push   %eax
  801472:	ff d2                	call   *%edx
  801474:	83 c4 10             	add    $0x10,%esp
}
  801477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80147c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801481:	8b 40 48             	mov    0x48(%eax),%eax
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	53                   	push   %ebx
  801488:	50                   	push   %eax
  801489:	68 30 29 80 00       	push   $0x802930
  80148e:	e8 0c ed ff ff       	call   80019f <cprintf>
		return -E_INVAL;
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149b:	eb da                	jmp    801477 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80149d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a2:	eb d3                	jmp    801477 <ftruncate+0x52>

008014a4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 1c             	sub    $0x1c,%esp
  8014ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 08             	pushl  0x8(%ebp)
  8014b5:	e8 84 fb ff ff       	call   80103e <fd_lookup>
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 4b                	js     80150c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c1:	83 ec 08             	sub    $0x8,%esp
  8014c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cb:	ff 30                	pushl  (%eax)
  8014cd:	e8 bc fb ff ff       	call   80108e <dev_lookup>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	78 33                	js     80150c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014e0:	74 2f                	je     801511 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014e2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014e5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014ec:	00 00 00 
	stat->st_isdir = 0;
  8014ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014f6:	00 00 00 
	stat->st_dev = dev;
  8014f9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	53                   	push   %ebx
  801503:	ff 75 f0             	pushl  -0x10(%ebp)
  801506:	ff 50 14             	call   *0x14(%eax)
  801509:	83 c4 10             	add    $0x10,%esp
}
  80150c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150f:	c9                   	leave  
  801510:	c3                   	ret    
		return -E_NOT_SUPP;
  801511:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801516:	eb f4                	jmp    80150c <fstat+0x68>

00801518 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	6a 00                	push   $0x0
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	e8 22 02 00 00       	call   80174c <open>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 1b                	js     80154e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	50                   	push   %eax
  80153a:	e8 65 ff ff ff       	call   8014a4 <fstat>
  80153f:	89 c6                	mov    %eax,%esi
	close(fd);
  801541:	89 1c 24             	mov    %ebx,(%esp)
  801544:	e8 27 fc ff ff       	call   801170 <close>
	return r;
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 f3                	mov    %esi,%ebx
}
  80154e:	89 d8                	mov    %ebx,%eax
  801550:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	56                   	push   %esi
  80155b:	53                   	push   %ebx
  80155c:	89 c6                	mov    %eax,%esi
  80155e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801560:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801567:	74 27                	je     801590 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801569:	6a 07                	push   $0x7
  80156b:	68 00 50 80 00       	push   $0x805000
  801570:	56                   	push   %esi
  801571:	ff 35 00 40 80 00    	pushl  0x804000
  801577:	e8 69 0c 00 00       	call   8021e5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80157c:	83 c4 0c             	add    $0xc,%esp
  80157f:	6a 00                	push   $0x0
  801581:	53                   	push   %ebx
  801582:	6a 00                	push   $0x0
  801584:	e8 f3 0b 00 00       	call   80217c <ipc_recv>
}
  801589:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801590:	83 ec 0c             	sub    $0xc,%esp
  801593:	6a 01                	push   $0x1
  801595:	e8 a3 0c 00 00       	call   80223d <ipc_find_env>
  80159a:	a3 00 40 80 00       	mov    %eax,0x804000
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	eb c5                	jmp    801569 <fsipc+0x12>

008015a4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8015c7:	e8 8b ff ff ff       	call   801557 <fsipc>
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <devfile_flush>:
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015da:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015df:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e9:	e8 69 ff ff ff       	call   801557 <fsipc>
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <devfile_stat>:
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801600:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801605:	ba 00 00 00 00       	mov    $0x0,%edx
  80160a:	b8 05 00 00 00       	mov    $0x5,%eax
  80160f:	e8 43 ff ff ff       	call   801557 <fsipc>
  801614:	85 c0                	test   %eax,%eax
  801616:	78 2c                	js     801644 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	68 00 50 80 00       	push   $0x805000
  801620:	53                   	push   %ebx
  801621:	e8 d8 f2 ff ff       	call   8008fe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801626:	a1 80 50 80 00       	mov    0x805080,%eax
  80162b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801631:	a1 84 50 80 00       	mov    0x805084,%eax
  801636:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <devfile_write>:
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	53                   	push   %ebx
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8b 40 0c             	mov    0xc(%eax),%eax
  801659:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80165e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801664:	53                   	push   %ebx
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	68 08 50 80 00       	push   $0x805008
  80166d:	e8 7c f4 ff ff       	call   800aee <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 04 00 00 00       	mov    $0x4,%eax
  80167c:	e8 d6 fe ff ff       	call   801557 <fsipc>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 0b                	js     801693 <devfile_write+0x4a>
	assert(r <= n);
  801688:	39 d8                	cmp    %ebx,%eax
  80168a:	77 0c                	ja     801698 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80168c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801691:	7f 1e                	jg     8016b1 <devfile_write+0x68>
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    
	assert(r <= n);
  801698:	68 a0 29 80 00       	push   $0x8029a0
  80169d:	68 a7 29 80 00       	push   $0x8029a7
  8016a2:	68 98 00 00 00       	push   $0x98
  8016a7:	68 bc 29 80 00       	push   $0x8029bc
  8016ac:	e8 6a 0a 00 00       	call   80211b <_panic>
	assert(r <= PGSIZE);
  8016b1:	68 c7 29 80 00       	push   $0x8029c7
  8016b6:	68 a7 29 80 00       	push   $0x8029a7
  8016bb:	68 99 00 00 00       	push   $0x99
  8016c0:	68 bc 29 80 00       	push   $0x8029bc
  8016c5:	e8 51 0a 00 00       	call   80211b <_panic>

008016ca <devfile_read>:
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	56                   	push   %esi
  8016ce:	53                   	push   %ebx
  8016cf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016dd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ed:	e8 65 fe ff ff       	call   801557 <fsipc>
  8016f2:	89 c3                	mov    %eax,%ebx
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 1f                	js     801717 <devfile_read+0x4d>
	assert(r <= n);
  8016f8:	39 f0                	cmp    %esi,%eax
  8016fa:	77 24                	ja     801720 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801701:	7f 33                	jg     801736 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801703:	83 ec 04             	sub    $0x4,%esp
  801706:	50                   	push   %eax
  801707:	68 00 50 80 00       	push   $0x805000
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	e8 78 f3 ff ff       	call   800a8c <memmove>
	return r;
  801714:	83 c4 10             	add    $0x10,%esp
}
  801717:	89 d8                	mov    %ebx,%eax
  801719:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171c:	5b                   	pop    %ebx
  80171d:	5e                   	pop    %esi
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    
	assert(r <= n);
  801720:	68 a0 29 80 00       	push   $0x8029a0
  801725:	68 a7 29 80 00       	push   $0x8029a7
  80172a:	6a 7c                	push   $0x7c
  80172c:	68 bc 29 80 00       	push   $0x8029bc
  801731:	e8 e5 09 00 00       	call   80211b <_panic>
	assert(r <= PGSIZE);
  801736:	68 c7 29 80 00       	push   $0x8029c7
  80173b:	68 a7 29 80 00       	push   $0x8029a7
  801740:	6a 7d                	push   $0x7d
  801742:	68 bc 29 80 00       	push   $0x8029bc
  801747:	e8 cf 09 00 00       	call   80211b <_panic>

0080174c <open>:
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 1c             	sub    $0x1c,%esp
  801754:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801757:	56                   	push   %esi
  801758:	e8 68 f1 ff ff       	call   8008c5 <strlen>
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801765:	7f 6c                	jg     8017d3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176d:	50                   	push   %eax
  80176e:	e8 79 f8 ff ff       	call   800fec <fd_alloc>
  801773:	89 c3                	mov    %eax,%ebx
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	85 c0                	test   %eax,%eax
  80177a:	78 3c                	js     8017b8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	56                   	push   %esi
  801780:	68 00 50 80 00       	push   $0x805000
  801785:	e8 74 f1 ff ff       	call   8008fe <strcpy>
	fsipcbuf.open.req_omode = mode;
  80178a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	b8 01 00 00 00       	mov    $0x1,%eax
  80179a:	e8 b8 fd ff ff       	call   801557 <fsipc>
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 19                	js     8017c1 <open+0x75>
	return fd2num(fd);
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ae:	e8 12 f8 ff ff       	call   800fc5 <fd2num>
  8017b3:	89 c3                	mov    %eax,%ebx
  8017b5:	83 c4 10             	add    $0x10,%esp
}
  8017b8:	89 d8                	mov    %ebx,%eax
  8017ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5e                   	pop    %esi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    
		fd_close(fd, 0);
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	6a 00                	push   $0x0
  8017c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c9:	e8 1b f9 ff ff       	call   8010e9 <fd_close>
		return r;
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	eb e5                	jmp    8017b8 <open+0x6c>
		return -E_BAD_PATH;
  8017d3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017d8:	eb de                	jmp    8017b8 <open+0x6c>

008017da <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8017ea:	e8 68 fd ff ff       	call   801557 <fsipc>
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017f7:	68 d3 29 80 00       	push   $0x8029d3
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	e8 fa f0 ff ff       	call   8008fe <strcpy>
	return 0;
}
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <devsock_close>:
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	53                   	push   %ebx
  80180f:	83 ec 10             	sub    $0x10,%esp
  801812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801815:	53                   	push   %ebx
  801816:	e8 5d 0a 00 00       	call   802278 <pageref>
  80181b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801823:	83 f8 01             	cmp    $0x1,%eax
  801826:	74 07                	je     80182f <devsock_close+0x24>
}
  801828:	89 d0                	mov    %edx,%eax
  80182a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80182f:	83 ec 0c             	sub    $0xc,%esp
  801832:	ff 73 0c             	pushl  0xc(%ebx)
  801835:	e8 b9 02 00 00       	call   801af3 <nsipc_close>
  80183a:	89 c2                	mov    %eax,%edx
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	eb e7                	jmp    801828 <devsock_close+0x1d>

00801841 <devsock_write>:
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801847:	6a 00                	push   $0x0
  801849:	ff 75 10             	pushl  0x10(%ebp)
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	ff 70 0c             	pushl  0xc(%eax)
  801855:	e8 76 03 00 00       	call   801bd0 <nsipc_send>
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <devsock_read>:
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801862:	6a 00                	push   $0x0
  801864:	ff 75 10             	pushl  0x10(%ebp)
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	ff 70 0c             	pushl  0xc(%eax)
  801870:	e8 ef 02 00 00       	call   801b64 <nsipc_recv>
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <fd2sockid>:
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80187d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	e8 b7 f7 ff ff       	call   80103e <fd_lookup>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 10                	js     80189e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801897:	39 08                	cmp    %ecx,(%eax)
  801899:	75 05                	jne    8018a0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80189b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
		return -E_NOT_SUPP;
  8018a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a5:	eb f7                	jmp    80189e <fd2sockid+0x27>

008018a7 <alloc_sockfd>:
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 1c             	sub    $0x1c,%esp
  8018af:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b4:	50                   	push   %eax
  8018b5:	e8 32 f7 ff ff       	call   800fec <fd_alloc>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 43                	js     801906 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	68 07 04 00 00       	push   $0x407
  8018cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ce:	6a 00                	push   $0x0
  8018d0:	e8 1b f4 ff ff       	call   800cf0 <sys_page_alloc>
  8018d5:	89 c3                	mov    %eax,%ebx
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 28                	js     801906 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018f3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	50                   	push   %eax
  8018fa:	e8 c6 f6 ff ff       	call   800fc5 <fd2num>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	eb 0c                	jmp    801912 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	56                   	push   %esi
  80190a:	e8 e4 01 00 00       	call   801af3 <nsipc_close>
		return r;
  80190f:	83 c4 10             	add    $0x10,%esp
}
  801912:	89 d8                	mov    %ebx,%eax
  801914:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    

0080191b <accept>:
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	e8 4e ff ff ff       	call   801877 <fd2sockid>
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 1b                	js     801948 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	e8 0e 01 00 00       	call   801a4a <nsipc_accept>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 05                	js     801948 <accept+0x2d>
	return alloc_sockfd(r);
  801943:	e8 5f ff ff ff       	call   8018a7 <alloc_sockfd>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <bind>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	e8 1f ff ff ff       	call   801877 <fd2sockid>
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 12                	js     80196e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	ff 75 10             	pushl  0x10(%ebp)
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	e8 31 01 00 00       	call   801a9c <nsipc_bind>
  80196b:	83 c4 10             	add    $0x10,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <shutdown>:
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	e8 f9 fe ff ff       	call   801877 <fd2sockid>
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 0f                	js     801991 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	e8 43 01 00 00       	call   801ad1 <nsipc_shutdown>
  80198e:	83 c4 10             	add    $0x10,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <connect>:
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	e8 d6 fe ff ff       	call   801877 <fd2sockid>
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 12                	js     8019b7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	ff 75 10             	pushl  0x10(%ebp)
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	50                   	push   %eax
  8019af:	e8 59 01 00 00       	call   801b0d <nsipc_connect>
  8019b4:	83 c4 10             	add    $0x10,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <listen>:
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	e8 b0 fe ff ff       	call   801877 <fd2sockid>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 0f                	js     8019da <listen+0x21>
	return nsipc_listen(r, backlog);
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	e8 6b 01 00 00       	call   801b42 <nsipc_listen>
  8019d7:	83 c4 10             	add    $0x10,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <socket>:

int
socket(int domain, int type, int protocol)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019e2:	ff 75 10             	pushl  0x10(%ebp)
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	e8 3e 02 00 00       	call   801c2e <nsipc_socket>
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 05                	js     8019fc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019f7:	e8 ab fe ff ff       	call   8018a7 <alloc_sockfd>
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	53                   	push   %ebx
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a07:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a0e:	74 26                	je     801a36 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a10:	6a 07                	push   $0x7
  801a12:	68 00 60 80 00       	push   $0x806000
  801a17:	53                   	push   %ebx
  801a18:	ff 35 04 40 80 00    	pushl  0x804004
  801a1e:	e8 c2 07 00 00       	call   8021e5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a23:	83 c4 0c             	add    $0xc,%esp
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	e8 4b 07 00 00       	call   80217c <ipc_recv>
}
  801a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	6a 02                	push   $0x2
  801a3b:	e8 fd 07 00 00       	call   80223d <ipc_find_env>
  801a40:	a3 04 40 80 00       	mov    %eax,0x804004
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	eb c6                	jmp    801a10 <nsipc+0x12>

00801a4a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	56                   	push   %esi
  801a4e:	53                   	push   %ebx
  801a4f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a5a:	8b 06                	mov    (%esi),%eax
  801a5c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a61:	b8 01 00 00 00       	mov    $0x1,%eax
  801a66:	e8 93 ff ff ff       	call   8019fe <nsipc>
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	79 09                	jns    801a7a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a71:	89 d8                	mov    %ebx,%eax
  801a73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a76:	5b                   	pop    %ebx
  801a77:	5e                   	pop    %esi
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	ff 35 10 60 80 00    	pushl  0x806010
  801a83:	68 00 60 80 00       	push   $0x806000
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	e8 fc ef ff ff       	call   800a8c <memmove>
		*addrlen = ret->ret_addrlen;
  801a90:	a1 10 60 80 00       	mov    0x806010,%eax
  801a95:	89 06                	mov    %eax,(%esi)
  801a97:	83 c4 10             	add    $0x10,%esp
	return r;
  801a9a:	eb d5                	jmp    801a71 <nsipc_accept+0x27>

00801a9c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 08             	sub    $0x8,%esp
  801aa3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aae:	53                   	push   %ebx
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	68 04 60 80 00       	push   $0x806004
  801ab7:	e8 d0 ef ff ff       	call   800a8c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801abc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ac2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ac7:	e8 32 ff ff ff       	call   8019fe <nsipc>
}
  801acc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ae7:	b8 03 00 00 00       	mov    $0x3,%eax
  801aec:	e8 0d ff ff ff       	call   8019fe <nsipc>
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <nsipc_close>:

int
nsipc_close(int s)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b01:	b8 04 00 00 00       	mov    $0x4,%eax
  801b06:	e8 f3 fe ff ff       	call   8019fe <nsipc>
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b1f:	53                   	push   %ebx
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	68 04 60 80 00       	push   $0x806004
  801b28:	e8 5f ef ff ff       	call   800a8c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b2d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b33:	b8 05 00 00 00       	mov    $0x5,%eax
  801b38:	e8 c1 fe ff ff       	call   8019fe <nsipc>
}
  801b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b58:	b8 06 00 00 00       	mov    $0x6,%eax
  801b5d:	e8 9c fe ff ff       	call   8019fe <nsipc>
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	56                   	push   %esi
  801b68:	53                   	push   %ebx
  801b69:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b74:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b82:	b8 07 00 00 00       	mov    $0x7,%eax
  801b87:	e8 72 fe ff ff       	call   8019fe <nsipc>
  801b8c:	89 c3                	mov    %eax,%ebx
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 1f                	js     801bb1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b92:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b97:	7f 21                	jg     801bba <nsipc_recv+0x56>
  801b99:	39 c6                	cmp    %eax,%esi
  801b9b:	7c 1d                	jl     801bba <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	50                   	push   %eax
  801ba1:	68 00 60 80 00       	push   $0x806000
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	e8 de ee ff ff       	call   800a8c <memmove>
  801bae:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bb1:	89 d8                	mov    %ebx,%eax
  801bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb6:	5b                   	pop    %ebx
  801bb7:	5e                   	pop    %esi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bba:	68 df 29 80 00       	push   $0x8029df
  801bbf:	68 a7 29 80 00       	push   $0x8029a7
  801bc4:	6a 62                	push   $0x62
  801bc6:	68 f4 29 80 00       	push   $0x8029f4
  801bcb:	e8 4b 05 00 00       	call   80211b <_panic>

00801bd0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801be2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801be8:	7f 2e                	jg     801c18 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	53                   	push   %ebx
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	68 0c 60 80 00       	push   $0x80600c
  801bf6:	e8 91 ee ff ff       	call   800a8c <memmove>
	nsipcbuf.send.req_size = size;
  801bfb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c01:	8b 45 14             	mov    0x14(%ebp),%eax
  801c04:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c09:	b8 08 00 00 00       	mov    $0x8,%eax
  801c0e:	e8 eb fd ff ff       	call   8019fe <nsipc>
}
  801c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    
	assert(size < 1600);
  801c18:	68 00 2a 80 00       	push   $0x802a00
  801c1d:	68 a7 29 80 00       	push   $0x8029a7
  801c22:	6a 6d                	push   $0x6d
  801c24:	68 f4 29 80 00       	push   $0x8029f4
  801c29:	e8 ed 04 00 00       	call   80211b <_panic>

00801c2e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c44:	8b 45 10             	mov    0x10(%ebp),%eax
  801c47:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c4c:	b8 09 00 00 00       	mov    $0x9,%eax
  801c51:	e8 a8 fd ff ff       	call   8019fe <nsipc>
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 6a f3 ff ff       	call   800fd5 <fd2data>
  801c6b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c6d:	83 c4 08             	add    $0x8,%esp
  801c70:	68 0c 2a 80 00       	push   $0x802a0c
  801c75:	53                   	push   %ebx
  801c76:	e8 83 ec ff ff       	call   8008fe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c7b:	8b 46 04             	mov    0x4(%esi),%eax
  801c7e:	2b 06                	sub    (%esi),%eax
  801c80:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c8d:	00 00 00 
	stat->st_dev = &devpipe;
  801c90:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c97:	30 80 00 
	return 0;
}
  801c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca2:	5b                   	pop    %ebx
  801ca3:	5e                   	pop    %esi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cb0:	53                   	push   %ebx
  801cb1:	6a 00                	push   $0x0
  801cb3:	e8 bd f0 ff ff       	call   800d75 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb8:	89 1c 24             	mov    %ebx,(%esp)
  801cbb:	e8 15 f3 ff ff       	call   800fd5 <fd2data>
  801cc0:	83 c4 08             	add    $0x8,%esp
  801cc3:	50                   	push   %eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	e8 aa f0 ff ff       	call   800d75 <sys_page_unmap>
}
  801ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <_pipeisclosed>:
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 1c             	sub    $0x1c,%esp
  801cd9:	89 c7                	mov    %eax,%edi
  801cdb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cdd:	a1 08 40 80 00       	mov    0x804008,%eax
  801ce2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	57                   	push   %edi
  801ce9:	e8 8a 05 00 00       	call   802278 <pageref>
  801cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cf1:	89 34 24             	mov    %esi,(%esp)
  801cf4:	e8 7f 05 00 00       	call   802278 <pageref>
		nn = thisenv->env_runs;
  801cf9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cff:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	39 cb                	cmp    %ecx,%ebx
  801d07:	74 1b                	je     801d24 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d09:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d0c:	75 cf                	jne    801cdd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d0e:	8b 42 58             	mov    0x58(%edx),%eax
  801d11:	6a 01                	push   $0x1
  801d13:	50                   	push   %eax
  801d14:	53                   	push   %ebx
  801d15:	68 13 2a 80 00       	push   $0x802a13
  801d1a:	e8 80 e4 ff ff       	call   80019f <cprintf>
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	eb b9                	jmp    801cdd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d24:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d27:	0f 94 c0             	sete   %al
  801d2a:	0f b6 c0             	movzbl %al,%eax
}
  801d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5f                   	pop    %edi
  801d33:	5d                   	pop    %ebp
  801d34:	c3                   	ret    

00801d35 <devpipe_write>:
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	57                   	push   %edi
  801d39:	56                   	push   %esi
  801d3a:	53                   	push   %ebx
  801d3b:	83 ec 28             	sub    $0x28,%esp
  801d3e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d41:	56                   	push   %esi
  801d42:	e8 8e f2 ff ff       	call   800fd5 <fd2data>
  801d47:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d51:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d54:	74 4f                	je     801da5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d56:	8b 43 04             	mov    0x4(%ebx),%eax
  801d59:	8b 0b                	mov    (%ebx),%ecx
  801d5b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d5e:	39 d0                	cmp    %edx,%eax
  801d60:	72 14                	jb     801d76 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d62:	89 da                	mov    %ebx,%edx
  801d64:	89 f0                	mov    %esi,%eax
  801d66:	e8 65 ff ff ff       	call   801cd0 <_pipeisclosed>
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	75 3b                	jne    801daa <devpipe_write+0x75>
			sys_yield();
  801d6f:	e8 5d ef ff ff       	call   800cd1 <sys_yield>
  801d74:	eb e0                	jmp    801d56 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d79:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d7d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	c1 fa 1f             	sar    $0x1f,%edx
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	c1 e9 1b             	shr    $0x1b,%ecx
  801d8a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d8d:	83 e2 1f             	and    $0x1f,%edx
  801d90:	29 ca                	sub    %ecx,%edx
  801d92:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d96:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d9a:	83 c0 01             	add    $0x1,%eax
  801d9d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801da0:	83 c7 01             	add    $0x1,%edi
  801da3:	eb ac                	jmp    801d51 <devpipe_write+0x1c>
	return i;
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	eb 05                	jmp    801daf <devpipe_write+0x7a>
				return 0;
  801daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5f                   	pop    %edi
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    

00801db7 <devpipe_read>:
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	57                   	push   %edi
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 18             	sub    $0x18,%esp
  801dc0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dc3:	57                   	push   %edi
  801dc4:	e8 0c f2 ff ff       	call   800fd5 <fd2data>
  801dc9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	be 00 00 00 00       	mov    $0x0,%esi
  801dd3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dd6:	75 14                	jne    801dec <devpipe_read+0x35>
	return i;
  801dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddb:	eb 02                	jmp    801ddf <devpipe_read+0x28>
				return i;
  801ddd:	89 f0                	mov    %esi,%eax
}
  801ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    
			sys_yield();
  801de7:	e8 e5 ee ff ff       	call   800cd1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dec:	8b 03                	mov    (%ebx),%eax
  801dee:	3b 43 04             	cmp    0x4(%ebx),%eax
  801df1:	75 18                	jne    801e0b <devpipe_read+0x54>
			if (i > 0)
  801df3:	85 f6                	test   %esi,%esi
  801df5:	75 e6                	jne    801ddd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801df7:	89 da                	mov    %ebx,%edx
  801df9:	89 f8                	mov    %edi,%eax
  801dfb:	e8 d0 fe ff ff       	call   801cd0 <_pipeisclosed>
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 e3                	je     801de7 <devpipe_read+0x30>
				return 0;
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
  801e09:	eb d4                	jmp    801ddf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e0b:	99                   	cltd   
  801e0c:	c1 ea 1b             	shr    $0x1b,%edx
  801e0f:	01 d0                	add    %edx,%eax
  801e11:	83 e0 1f             	and    $0x1f,%eax
  801e14:	29 d0                	sub    %edx,%eax
  801e16:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e21:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e24:	83 c6 01             	add    $0x1,%esi
  801e27:	eb aa                	jmp    801dd3 <devpipe_read+0x1c>

00801e29 <pipe>:
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e34:	50                   	push   %eax
  801e35:	e8 b2 f1 ff ff       	call   800fec <fd_alloc>
  801e3a:	89 c3                	mov    %eax,%ebx
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 88 23 01 00 00    	js     801f6a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 07 04 00 00       	push   $0x407
  801e4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e52:	6a 00                	push   $0x0
  801e54:	e8 97 ee ff ff       	call   800cf0 <sys_page_alloc>
  801e59:	89 c3                	mov    %eax,%ebx
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	0f 88 04 01 00 00    	js     801f6a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	e8 7a f1 ff ff       	call   800fec <fd_alloc>
  801e72:	89 c3                	mov    %eax,%ebx
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	85 c0                	test   %eax,%eax
  801e79:	0f 88 db 00 00 00    	js     801f5a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 07 04 00 00       	push   $0x407
  801e87:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8a:	6a 00                	push   $0x0
  801e8c:	e8 5f ee ff ff       	call   800cf0 <sys_page_alloc>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	85 c0                	test   %eax,%eax
  801e98:	0f 88 bc 00 00 00    	js     801f5a <pipe+0x131>
	va = fd2data(fd0);
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea4:	e8 2c f1 ff ff       	call   800fd5 <fd2data>
  801ea9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eab:	83 c4 0c             	add    $0xc,%esp
  801eae:	68 07 04 00 00       	push   $0x407
  801eb3:	50                   	push   %eax
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 35 ee ff ff       	call   800cf0 <sys_page_alloc>
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	0f 88 82 00 00 00    	js     801f4a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ece:	e8 02 f1 ff ff       	call   800fd5 <fd2data>
  801ed3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eda:	50                   	push   %eax
  801edb:	6a 00                	push   $0x0
  801edd:	56                   	push   %esi
  801ede:	6a 00                	push   $0x0
  801ee0:	e8 4e ee ff ff       	call   800d33 <sys_page_map>
  801ee5:	89 c3                	mov    %eax,%ebx
  801ee7:	83 c4 20             	add    $0x20,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 4e                	js     801f3c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eee:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f05:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	e8 a9 f0 ff ff       	call   800fc5 <fd2num>
  801f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f21:	83 c4 04             	add    $0x4,%esp
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	e8 99 f0 ff ff       	call   800fc5 <fd2num>
  801f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f3a:	eb 2e                	jmp    801f6a <pipe+0x141>
	sys_page_unmap(0, va);
  801f3c:	83 ec 08             	sub    $0x8,%esp
  801f3f:	56                   	push   %esi
  801f40:	6a 00                	push   $0x0
  801f42:	e8 2e ee ff ff       	call   800d75 <sys_page_unmap>
  801f47:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f4a:	83 ec 08             	sub    $0x8,%esp
  801f4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f50:	6a 00                	push   $0x0
  801f52:	e8 1e ee ff ff       	call   800d75 <sys_page_unmap>
  801f57:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f60:	6a 00                	push   $0x0
  801f62:	e8 0e ee ff ff       	call   800d75 <sys_page_unmap>
  801f67:	83 c4 10             	add    $0x10,%esp
}
  801f6a:	89 d8                	mov    %ebx,%eax
  801f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <pipeisclosed>:
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7c:	50                   	push   %eax
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	e8 b9 f0 ff ff       	call   80103e <fd_lookup>
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	78 18                	js     801fa4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	e8 3e f0 ff ff       	call   800fd5 <fd2data>
	return _pipeisclosed(fd, p);
  801f97:	89 c2                	mov    %eax,%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	e8 2f fd ff ff       	call   801cd0 <_pipeisclosed>
  801fa1:	83 c4 10             	add    $0x10,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	c3                   	ret    

00801fac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb2:	68 2b 2a 80 00       	push   $0x802a2b
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	e8 3f e9 ff ff       	call   8008fe <strcpy>
	return 0;
}
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <devcons_write>:
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fd2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fd7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fdd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe0:	73 31                	jae    802013 <devcons_write+0x4d>
		m = n - tot;
  801fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fe5:	29 f3                	sub    %esi,%ebx
  801fe7:	83 fb 7f             	cmp    $0x7f,%ebx
  801fea:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fef:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	53                   	push   %ebx
  801ff6:	89 f0                	mov    %esi,%eax
  801ff8:	03 45 0c             	add    0xc(%ebp),%eax
  801ffb:	50                   	push   %eax
  801ffc:	57                   	push   %edi
  801ffd:	e8 8a ea ff ff       	call   800a8c <memmove>
		sys_cputs(buf, m);
  802002:	83 c4 08             	add    $0x8,%esp
  802005:	53                   	push   %ebx
  802006:	57                   	push   %edi
  802007:	e8 28 ec ff ff       	call   800c34 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80200c:	01 de                	add    %ebx,%esi
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	eb ca                	jmp    801fdd <devcons_write+0x17>
}
  802013:	89 f0                	mov    %esi,%eax
  802015:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    

0080201d <devcons_read>:
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80202c:	74 21                	je     80204f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80202e:	e8 1f ec ff ff       	call   800c52 <sys_cgetc>
  802033:	85 c0                	test   %eax,%eax
  802035:	75 07                	jne    80203e <devcons_read+0x21>
		sys_yield();
  802037:	e8 95 ec ff ff       	call   800cd1 <sys_yield>
  80203c:	eb f0                	jmp    80202e <devcons_read+0x11>
	if (c < 0)
  80203e:	78 0f                	js     80204f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802040:	83 f8 04             	cmp    $0x4,%eax
  802043:	74 0c                	je     802051 <devcons_read+0x34>
	*(char*)vbuf = c;
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	88 02                	mov    %al,(%edx)
	return 1;
  80204a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    
		return 0;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
  802056:	eb f7                	jmp    80204f <devcons_read+0x32>

00802058 <cputchar>:
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802064:	6a 01                	push   $0x1
  802066:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802069:	50                   	push   %eax
  80206a:	e8 c5 eb ff ff       	call   800c34 <sys_cputs>
}
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <getchar>:
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80207a:	6a 01                	push   $0x1
  80207c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207f:	50                   	push   %eax
  802080:	6a 00                	push   $0x0
  802082:	e8 27 f2 ff ff       	call   8012ae <read>
	if (r < 0)
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 06                	js     802094 <getchar+0x20>
	if (r < 1)
  80208e:	74 06                	je     802096 <getchar+0x22>
	return c;
  802090:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    
		return -E_EOF;
  802096:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80209b:	eb f7                	jmp    802094 <getchar+0x20>

0080209d <iscons>:
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a6:	50                   	push   %eax
  8020a7:	ff 75 08             	pushl  0x8(%ebp)
  8020aa:	e8 8f ef ff ff       	call   80103e <fd_lookup>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 11                	js     8020c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020bf:	39 10                	cmp    %edx,(%eax)
  8020c1:	0f 94 c0             	sete   %al
  8020c4:	0f b6 c0             	movzbl %al,%eax
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <opencons>:
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d2:	50                   	push   %eax
  8020d3:	e8 14 ef ff ff       	call   800fec <fd_alloc>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 3a                	js     802119 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 07 04 00 00       	push   $0x407
  8020e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ea:	6a 00                	push   $0x0
  8020ec:	e8 ff eb ff ff       	call   800cf0 <sys_page_alloc>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 21                	js     802119 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802101:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	50                   	push   %eax
  802111:	e8 af ee ff ff       	call   800fc5 <fd2num>
  802116:	83 c4 10             	add    $0x10,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	56                   	push   %esi
  80211f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802120:	a1 08 40 80 00       	mov    0x804008,%eax
  802125:	8b 40 48             	mov    0x48(%eax),%eax
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	68 68 2a 80 00       	push   $0x802a68
  802130:	50                   	push   %eax
  802131:	68 37 2a 80 00       	push   $0x802a37
  802136:	e8 64 e0 ff ff       	call   80019f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80213b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80213e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802144:	e8 69 eb ff ff       	call   800cb2 <sys_getenvid>
  802149:	83 c4 04             	add    $0x4,%esp
  80214c:	ff 75 0c             	pushl  0xc(%ebp)
  80214f:	ff 75 08             	pushl  0x8(%ebp)
  802152:	56                   	push   %esi
  802153:	50                   	push   %eax
  802154:	68 44 2a 80 00       	push   $0x802a44
  802159:	e8 41 e0 ff ff       	call   80019f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80215e:	83 c4 18             	add    $0x18,%esp
  802161:	53                   	push   %ebx
  802162:	ff 75 10             	pushl  0x10(%ebp)
  802165:	e8 e4 df ff ff       	call   80014e <vcprintf>
	cprintf("\n");
  80216a:	c7 04 24 5f 25 80 00 	movl   $0x80255f,(%esp)
  802171:	e8 29 e0 ff ff       	call   80019f <cprintf>
  802176:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802179:	cc                   	int3   
  80217a:	eb fd                	jmp    802179 <_panic+0x5e>

0080217c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	56                   	push   %esi
  802180:	53                   	push   %ebx
  802181:	8b 75 08             	mov    0x8(%ebp),%esi
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80218a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80218c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802191:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802194:	83 ec 0c             	sub    $0xc,%esp
  802197:	50                   	push   %eax
  802198:	e8 03 ed ff ff       	call   800ea0 <sys_ipc_recv>
	if(ret < 0){
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	78 2b                	js     8021cf <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021a4:	85 f6                	test   %esi,%esi
  8021a6:	74 0a                	je     8021b2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ad:	8b 40 74             	mov    0x74(%eax),%eax
  8021b0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021b2:	85 db                	test   %ebx,%ebx
  8021b4:	74 0a                	je     8021c0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021bb:	8b 40 78             	mov    0x78(%eax),%eax
  8021be:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    
		if(from_env_store)
  8021cf:	85 f6                	test   %esi,%esi
  8021d1:	74 06                	je     8021d9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021d3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021d9:	85 db                	test   %ebx,%ebx
  8021db:	74 eb                	je     8021c8 <ipc_recv+0x4c>
			*perm_store = 0;
  8021dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021e3:	eb e3                	jmp    8021c8 <ipc_recv+0x4c>

008021e5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	57                   	push   %edi
  8021e9:	56                   	push   %esi
  8021ea:	53                   	push   %ebx
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021f7:	85 db                	test   %ebx,%ebx
  8021f9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021fe:	0f 44 d8             	cmove  %eax,%ebx
  802201:	eb 05                	jmp    802208 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802203:	e8 c9 ea ff ff       	call   800cd1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802208:	ff 75 14             	pushl  0x14(%ebp)
  80220b:	53                   	push   %ebx
  80220c:	56                   	push   %esi
  80220d:	57                   	push   %edi
  80220e:	e8 6a ec ff ff       	call   800e7d <sys_ipc_try_send>
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	85 c0                	test   %eax,%eax
  802218:	74 1b                	je     802235 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80221a:	79 e7                	jns    802203 <ipc_send+0x1e>
  80221c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80221f:	74 e2                	je     802203 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802221:	83 ec 04             	sub    $0x4,%esp
  802224:	68 6f 2a 80 00       	push   $0x802a6f
  802229:	6a 48                	push   $0x48
  80222b:	68 84 2a 80 00       	push   $0x802a84
  802230:	e8 e6 fe ff ff       	call   80211b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802238:	5b                   	pop    %ebx
  802239:	5e                   	pop    %esi
  80223a:	5f                   	pop    %edi
  80223b:	5d                   	pop    %ebp
  80223c:	c3                   	ret    

0080223d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802248:	89 c2                	mov    %eax,%edx
  80224a:	c1 e2 07             	shl    $0x7,%edx
  80224d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802253:	8b 52 50             	mov    0x50(%edx),%edx
  802256:	39 ca                	cmp    %ecx,%edx
  802258:	74 11                	je     80226b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80225a:	83 c0 01             	add    $0x1,%eax
  80225d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802262:	75 e4                	jne    802248 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	eb 0b                	jmp    802276 <ipc_find_env+0x39>
			return envs[i].env_id;
  80226b:	c1 e0 07             	shl    $0x7,%eax
  80226e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802273:	8b 40 48             	mov    0x48(%eax),%eax
}
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    

00802278 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227e:	89 d0                	mov    %edx,%eax
  802280:	c1 e8 16             	shr    $0x16,%eax
  802283:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80228f:	f6 c1 01             	test   $0x1,%cl
  802292:	74 1d                	je     8022b1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802294:	c1 ea 0c             	shr    $0xc,%edx
  802297:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80229e:	f6 c2 01             	test   $0x1,%dl
  8022a1:	74 0e                	je     8022b1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a3:	c1 ea 0c             	shr    $0xc,%edx
  8022a6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ad:	ef 
  8022ae:	0f b7 c0             	movzwl %ax,%eax
}
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	66 90                	xchg   %ax,%ax
  8022b5:	66 90                	xchg   %ax,%ax
  8022b7:	66 90                	xchg   %ax,%ax
  8022b9:	66 90                	xchg   %ax,%ax
  8022bb:	66 90                	xchg   %ax,%ax
  8022bd:	66 90                	xchg   %ax,%ax
  8022bf:	90                   	nop

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	75 4d                	jne    802328 <__udivdi3+0x68>
  8022db:	39 f3                	cmp    %esi,%ebx
  8022dd:	76 19                	jbe    8022f8 <__udivdi3+0x38>
  8022df:	31 ff                	xor    %edi,%edi
  8022e1:	89 e8                	mov    %ebp,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	89 d9                	mov    %ebx,%ecx
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	75 0b                	jne    802309 <__udivdi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f3                	div    %ebx
  802307:	89 c1                	mov    %eax,%ecx
  802309:	31 d2                	xor    %edx,%edx
  80230b:	89 f0                	mov    %esi,%eax
  80230d:	f7 f1                	div    %ecx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f7                	mov    %esi,%edi
  802315:	f7 f1                	div    %ecx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	77 1c                	ja     802348 <__udivdi3+0x88>
  80232c:	0f bd fa             	bsr    %edx,%edi
  80232f:	83 f7 1f             	xor    $0x1f,%edi
  802332:	75 2c                	jne    802360 <__udivdi3+0xa0>
  802334:	39 f2                	cmp    %esi,%edx
  802336:	72 06                	jb     80233e <__udivdi3+0x7e>
  802338:	31 c0                	xor    %eax,%eax
  80233a:	39 eb                	cmp    %ebp,%ebx
  80233c:	77 a9                	ja     8022e7 <__udivdi3+0x27>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	eb a2                	jmp    8022e7 <__udivdi3+0x27>
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 27 ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 1d ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	89 da                	mov    %ebx,%edx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 43                	jne    802430 <__umoddi3+0x60>
  8023ed:	39 df                	cmp    %ebx,%edi
  8023ef:	76 17                	jbe    802408 <__umoddi3+0x38>
  8023f1:	89 f0                	mov    %esi,%eax
  8023f3:	f7 f7                	div    %edi
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	31 d2                	xor    %edx,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d8                	mov    %ebx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 f0                	mov    %esi,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	eb d0                	jmp    8023f7 <__umoddi3+0x27>
  802427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242e:	66 90                	xchg   %ax,%ax
  802430:	89 f1                	mov    %esi,%ecx
  802432:	39 d8                	cmp    %ebx,%eax
  802434:	76 0a                	jbe    802440 <__umoddi3+0x70>
  802436:	89 f0                	mov    %esi,%eax
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 20                	jne    802468 <__umoddi3+0x98>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 b0 00 00 00    	jb     802500 <__umoddi3+0x130>
  802450:	39 f7                	cmp    %esi,%edi
  802452:	0f 86 a8 00 00 00    	jbe    802500 <__umoddi3+0x130>
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0xfb>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x107>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x107>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 da                	mov    %ebx,%edx
  802502:	29 fe                	sub    %edi,%esi
  802504:	19 c2                	sbb    %eax,%edx
  802506:	89 f1                	mov    %esi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	e9 4b ff ff ff       	jmp    80245a <__umoddi3+0x8a>
