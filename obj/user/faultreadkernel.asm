
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
  80003f:	68 c0 11 80 00       	push   $0x8011c0
  800044:	e8 41 01 00 00       	call   80018a <cprintf>
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
  800057:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80005e:	00 00 00 
	envid_t find = sys_getenvid();
  800061:	e8 37 0c 00 00       	call   800c9d <sys_getenvid>
  800066:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
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
  8000af:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x77>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 60 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d3:	e8 0b 00 00 00       	call   8000e3 <exit>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000e9:	6a 00                	push   $0x0
  8000eb:	e8 6c 0b 00 00       	call   800c5c <sys_env_destroy>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    

008000f5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ff:	8b 13                	mov    (%ebx),%edx
  800101:	8d 42 01             	lea    0x1(%edx),%eax
  800104:	89 03                	mov    %eax,(%ebx)
  800106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800109:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800112:	74 09                	je     80011d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800114:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ff 00 00 00       	push   $0xff
  800125:	8d 43 08             	lea    0x8(%ebx),%eax
  800128:	50                   	push   %eax
  800129:	e8 f1 0a 00 00       	call   800c1f <sys_cputs>
		b->idx = 0;
  80012e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	eb db                	jmp    800114 <putch+0x1f>

00800139 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800142:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800149:	00 00 00 
	b.cnt = 0;
  80014c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800153:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800162:	50                   	push   %eax
  800163:	68 f5 00 80 00       	push   $0x8000f5
  800168:	e8 4a 01 00 00       	call   8002b7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016d:	83 c4 08             	add    $0x8,%esp
  800170:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800176:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 9d 0a 00 00       	call   800c1f <sys_cputs>

	return b.cnt;
}
  800182:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800190:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800193:	50                   	push   %eax
  800194:	ff 75 08             	pushl  0x8(%ebp)
  800197:	e8 9d ff ff ff       	call   800139 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 1c             	sub    $0x1c,%esp
  8001a7:	89 c6                	mov    %eax,%esi
  8001a9:	89 d7                	mov    %edx,%edi
  8001ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001bd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c1:	74 2c                	je     8001ef <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d8:	73 43                	jae    80021d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7e 6c                	jle    80024d <printnum+0xaf>
				putch(padc, putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	57                   	push   %edi
  8001e5:	ff 75 18             	pushl  0x18(%ebp)
  8001e8:	ff d6                	call   *%esi
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	eb eb                	jmp    8001da <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 20                	push   $0x20
  8001f4:	6a 00                	push   $0x0
  8001f6:	50                   	push   %eax
  8001f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fd:	89 fa                	mov    %edi,%edx
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	e8 98 ff ff ff       	call   80019e <printnum>
		while (--width > 0)
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	83 eb 01             	sub    $0x1,%ebx
  80020c:	85 db                	test   %ebx,%ebx
  80020e:	7e 65                	jle    800275 <printnum+0xd7>
			putch(padc, putdat);
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	57                   	push   %edi
  800214:	6a 20                	push   $0x20
  800216:	ff d6                	call   *%esi
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	eb ec                	jmp    800209 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	ff 75 18             	pushl  0x18(%ebp)
  800223:	83 eb 01             	sub    $0x1,%ebx
  800226:	53                   	push   %ebx
  800227:	50                   	push   %eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	ff 75 e4             	pushl  -0x1c(%ebp)
  800234:	ff 75 e0             	pushl  -0x20(%ebp)
  800237:	e8 34 0d 00 00       	call   800f70 <__udivdi3>
  80023c:	83 c4 18             	add    $0x18,%esp
  80023f:	52                   	push   %edx
  800240:	50                   	push   %eax
  800241:	89 fa                	mov    %edi,%edx
  800243:	89 f0                	mov    %esi,%eax
  800245:	e8 54 ff ff ff       	call   80019e <printnum>
  80024a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	57                   	push   %edi
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025d:	ff 75 e0             	pushl  -0x20(%ebp)
  800260:	e8 1b 0e 00 00       	call   801080 <__umoddi3>
  800265:	83 c4 14             	add    $0x14,%esp
  800268:	0f be 80 f1 11 80 00 	movsbl 0x8011f1(%eax),%eax
  80026f:	50                   	push   %eax
  800270:	ff d6                	call   *%esi
  800272:	83 c4 10             	add    $0x10,%esp
	}
}
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800283:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800287:	8b 10                	mov    (%eax),%edx
  800289:	3b 50 04             	cmp    0x4(%eax),%edx
  80028c:	73 0a                	jae    800298 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800291:	89 08                	mov    %ecx,(%eax)
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	88 02                	mov    %al,(%edx)
}
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    

0080029a <printfmt>:
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 10             	pushl  0x10(%ebp)
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 05 00 00 00       	call   8002b7 <vprintfmt>
}
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <vprintfmt>:
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	57                   	push   %edi
  8002bb:	56                   	push   %esi
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 3c             	sub    $0x3c,%esp
  8002c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c9:	e9 32 04 00 00       	jmp    800700 <vprintfmt+0x449>
		padc = ' ';
  8002ce:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002d2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002d9:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ee:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 12 05 00 00    	ja     800820 <vprintfmt+0x569>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	ff 24 85 e0 13 80 00 	jmp    *0x8013e0(,%eax,4)
  800318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80031f:	eb d9                	jmp    8002fa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800324:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800328:	eb d0                	jmp    8002fa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	0f b6 d2             	movzbl %dl,%edx
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	89 75 08             	mov    %esi,0x8(%ebp)
  800338:	eb 03                	jmp    80033d <vprintfmt+0x86>
  80033a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800340:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800344:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800347:	8d 72 d0             	lea    -0x30(%edx),%esi
  80034a:	83 fe 09             	cmp    $0x9,%esi
  80034d:	76 eb                	jbe    80033a <vprintfmt+0x83>
  80034f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800352:	8b 75 08             	mov    0x8(%ebp),%esi
  800355:	eb 14                	jmp    80036b <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8b 00                	mov    (%eax),%eax
  80035c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 40 04             	lea    0x4(%eax),%eax
  800365:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80036f:	79 89                	jns    8002fa <vprintfmt+0x43>
				width = precision, precision = -1;
  800371:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800374:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800377:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80037e:	e9 77 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
  800383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800386:	85 c0                	test   %eax,%eax
  800388:	0f 48 c1             	cmovs  %ecx,%eax
  80038b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800391:	e9 64 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
  800396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800399:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003a0:	e9 55 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
			lflag++;
  8003a5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ac:	e9 49 ff ff ff       	jmp    8002fa <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 78 04             	lea    0x4(%eax),%edi
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	53                   	push   %ebx
  8003bb:	ff 30                	pushl  (%eax)
  8003bd:	ff d6                	call   *%esi
			break;
  8003bf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c5:	e9 33 03 00 00       	jmp    8006fd <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	8d 78 04             	lea    0x4(%eax),%edi
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	99                   	cltd   
  8003d3:	31 d0                	xor    %edx,%eax
  8003d5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d7:	83 f8 0f             	cmp    $0xf,%eax
  8003da:	7f 23                	jg     8003ff <vprintfmt+0x148>
  8003dc:	8b 14 85 40 15 80 00 	mov    0x801540(,%eax,4),%edx
  8003e3:	85 d2                	test   %edx,%edx
  8003e5:	74 18                	je     8003ff <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003e7:	52                   	push   %edx
  8003e8:	68 12 12 80 00       	push   $0x801212
  8003ed:	53                   	push   %ebx
  8003ee:	56                   	push   %esi
  8003ef:	e8 a6 fe ff ff       	call   80029a <printfmt>
  8003f4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fa:	e9 fe 02 00 00       	jmp    8006fd <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003ff:	50                   	push   %eax
  800400:	68 09 12 80 00       	push   $0x801209
  800405:	53                   	push   %ebx
  800406:	56                   	push   %esi
  800407:	e8 8e fe ff ff       	call   80029a <printfmt>
  80040c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800412:	e9 e6 02 00 00       	jmp    8006fd <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	83 c0 04             	add    $0x4,%eax
  80041d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800425:	85 c9                	test   %ecx,%ecx
  800427:	b8 02 12 80 00       	mov    $0x801202,%eax
  80042c:	0f 45 c1             	cmovne %ecx,%eax
  80042f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800432:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800436:	7e 06                	jle    80043e <vprintfmt+0x187>
  800438:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80043c:	75 0d                	jne    80044b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800441:	89 c7                	mov    %eax,%edi
  800443:	03 45 e0             	add    -0x20(%ebp),%eax
  800446:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800449:	eb 53                	jmp    80049e <vprintfmt+0x1e7>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 d8             	pushl  -0x28(%ebp)
  800451:	50                   	push   %eax
  800452:	e8 71 04 00 00       	call   8008c8 <strnlen>
  800457:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045a:	29 c1                	sub    %eax,%ecx
  80045c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800464:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046b:	eb 0f                	jmp    80047c <vprintfmt+0x1c5>
					putch(padc, putdat);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	53                   	push   %ebx
  800471:	ff 75 e0             	pushl  -0x20(%ebp)
  800474:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ef 01             	sub    $0x1,%edi
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	85 ff                	test   %edi,%edi
  80047e:	7f ed                	jg     80046d <vprintfmt+0x1b6>
  800480:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800483:	85 c9                	test   %ecx,%ecx
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	0f 49 c1             	cmovns %ecx,%eax
  80048d:	29 c1                	sub    %eax,%ecx
  80048f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800492:	eb aa                	jmp    80043e <vprintfmt+0x187>
					putch(ch, putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	52                   	push   %edx
  800499:	ff d6                	call   *%esi
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a3:	83 c7 01             	add    $0x1,%edi
  8004a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004aa:	0f be d0             	movsbl %al,%edx
  8004ad:	85 d2                	test   %edx,%edx
  8004af:	74 4b                	je     8004fc <vprintfmt+0x245>
  8004b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b5:	78 06                	js     8004bd <vprintfmt+0x206>
  8004b7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004bb:	78 1e                	js     8004db <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004bd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c1:	74 d1                	je     800494 <vprintfmt+0x1dd>
  8004c3:	0f be c0             	movsbl %al,%eax
  8004c6:	83 e8 20             	sub    $0x20,%eax
  8004c9:	83 f8 5e             	cmp    $0x5e,%eax
  8004cc:	76 c6                	jbe    800494 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	6a 3f                	push   $0x3f
  8004d4:	ff d6                	call   *%esi
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	eb c3                	jmp    80049e <vprintfmt+0x1e7>
  8004db:	89 cf                	mov    %ecx,%edi
  8004dd:	eb 0e                	jmp    8004ed <vprintfmt+0x236>
				putch(' ', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	53                   	push   %ebx
  8004e3:	6a 20                	push   $0x20
  8004e5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ee                	jg     8004df <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f7:	e9 01 02 00 00       	jmp    8006fd <vprintfmt+0x446>
  8004fc:	89 cf                	mov    %ecx,%edi
  8004fe:	eb ed                	jmp    8004ed <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800503:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80050a:	e9 eb fd ff ff       	jmp    8002fa <vprintfmt+0x43>
	if (lflag >= 2)
  80050f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800513:	7f 21                	jg     800536 <vprintfmt+0x27f>
	else if (lflag)
  800515:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800519:	74 68                	je     800583 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800523:	89 c1                	mov    %eax,%ecx
  800525:	c1 f9 1f             	sar    $0x1f,%ecx
  800528:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 40 04             	lea    0x4(%eax),%eax
  800531:	89 45 14             	mov    %eax,0x14(%ebp)
  800534:	eb 17                	jmp    80054d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8b 50 04             	mov    0x4(%eax),%edx
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800541:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 40 08             	lea    0x8(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80054d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800550:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800559:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80055d:	78 3f                	js     80059e <vprintfmt+0x2e7>
			base = 10;
  80055f:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800564:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800568:	0f 84 71 01 00 00    	je     8006df <vprintfmt+0x428>
				putch('+', putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	53                   	push   %ebx
  800572:	6a 2b                	push   $0x2b
  800574:	ff d6                	call   *%esi
  800576:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800579:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057e:	e9 5c 01 00 00       	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, int);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058b:	89 c1                	mov    %eax,%ecx
  80058d:	c1 f9 1f             	sar    $0x1f,%ecx
  800590:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 04             	lea    0x4(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	eb af                	jmp    80054d <vprintfmt+0x296>
				putch('-', putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	6a 2d                	push   $0x2d
  8005a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ac:	f7 d8                	neg    %eax
  8005ae:	83 d2 00             	adc    $0x0,%edx
  8005b1:	f7 da                	neg    %edx
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c1:	e9 19 01 00 00       	jmp    8006df <vprintfmt+0x428>
	if (lflag >= 2)
  8005c6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ca:	7f 29                	jg     8005f5 <vprintfmt+0x33e>
	else if (lflag)
  8005cc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005d0:	74 44                	je     800616 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f0:	e9 ea 00 00 00       	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 50 04             	mov    0x4(%eax),%edx
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 08             	lea    0x8(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800611:	e9 c9 00 00 00       	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 a6 00 00 00       	jmp    8006df <vprintfmt+0x428>
			putch('0', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 30                	push   $0x30
  80063f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800648:	7f 26                	jg     800670 <vprintfmt+0x3b9>
	else if (lflag)
  80064a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064e:	74 3e                	je     80068e <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
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
  80066e:	eb 6f                	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 50 04             	mov    0x4(%eax),%edx
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800687:	b8 08 00 00 00       	mov    $0x8,%eax
  80068c:	eb 51                	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	ba 00 00 00 00       	mov    $0x0,%edx
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ac:	eb 31                	jmp    8006df <vprintfmt+0x428>
			putch('0', putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	6a 30                	push   $0x30
  8006b4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b6:	83 c4 08             	add    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 78                	push   $0x78
  8006bc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ce:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006da:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006e6:	52                   	push   %edx
  8006e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ea:	50                   	push   %eax
  8006eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f1:	89 da                	mov    %ebx,%edx
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	e8 a4 fa ff ff       	call   80019e <printnum>
			break;
  8006fa:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800700:	83 c7 01             	add    $0x1,%edi
  800703:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800707:	83 f8 25             	cmp    $0x25,%eax
  80070a:	0f 84 be fb ff ff    	je     8002ce <vprintfmt+0x17>
			if (ch == '\0')
  800710:	85 c0                	test   %eax,%eax
  800712:	0f 84 28 01 00 00    	je     800840 <vprintfmt+0x589>
			putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	50                   	push   %eax
  80071d:	ff d6                	call   *%esi
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb dc                	jmp    800700 <vprintfmt+0x449>
	if (lflag >= 2)
  800724:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800728:	7f 26                	jg     800750 <vprintfmt+0x499>
	else if (lflag)
  80072a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072e:	74 41                	je     800771 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 40 04             	lea    0x4(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800749:	b8 10 00 00 00       	mov    $0x10,%eax
  80074e:	eb 8f                	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 50 04             	mov    0x4(%eax),%edx
  800756:	8b 00                	mov    (%eax),%eax
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 08             	lea    0x8(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800767:	b8 10 00 00 00       	mov    $0x10,%eax
  80076c:	e9 6e ff ff ff       	jmp    8006df <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	ba 00 00 00 00       	mov    $0x0,%edx
  80077b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8d 40 04             	lea    0x4(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078a:	b8 10 00 00 00       	mov    $0x10,%eax
  80078f:	e9 4b ff ff ff       	jmp    8006df <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	83 c0 04             	add    $0x4,%eax
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	74 14                	je     8007ba <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007a6:	8b 13                	mov    (%ebx),%edx
  8007a8:	83 fa 7f             	cmp    $0x7f,%edx
  8007ab:	7f 37                	jg     8007e4 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007ad:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	e9 43 ff ff ff       	jmp    8006fd <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bf:	bf 29 13 80 00       	mov    $0x801329,%edi
							putch(ch, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	50                   	push   %eax
  8007c9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007cb:	83 c7 01             	add    $0x1,%edi
  8007ce:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	85 c0                	test   %eax,%eax
  8007d7:	75 eb                	jne    8007c4 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	e9 19 ff ff ff       	jmp    8006fd <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007e4:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007eb:	bf 61 13 80 00       	mov    $0x801361,%edi
							putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	50                   	push   %eax
  8007f5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f7:	83 c7 01             	add    $0x1,%edi
  8007fa:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	85 c0                	test   %eax,%eax
  800803:	75 eb                	jne    8007f0 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	e9 ed fe ff ff       	jmp    8006fd <vprintfmt+0x446>
			putch(ch, putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	6a 25                	push   $0x25
  800816:	ff d6                	call   *%esi
			break;
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	e9 dd fe ff ff       	jmp    8006fd <vprintfmt+0x446>
			putch('%', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 25                	push   $0x25
  800826:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	89 f8                	mov    %edi,%eax
  80082d:	eb 03                	jmp    800832 <vprintfmt+0x57b>
  80082f:	83 e8 01             	sub    $0x1,%eax
  800832:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800836:	75 f7                	jne    80082f <vprintfmt+0x578>
  800838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083b:	e9 bd fe ff ff       	jmp    8006fd <vprintfmt+0x446>
}
  800840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800843:	5b                   	pop    %ebx
  800844:	5e                   	pop    %esi
  800845:	5f                   	pop    %edi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 18             	sub    $0x18,%esp
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800857:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800865:	85 c0                	test   %eax,%eax
  800867:	74 26                	je     80088f <vsnprintf+0x47>
  800869:	85 d2                	test   %edx,%edx
  80086b:	7e 22                	jle    80088f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086d:	ff 75 14             	pushl  0x14(%ebp)
  800870:	ff 75 10             	pushl  0x10(%ebp)
  800873:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800876:	50                   	push   %eax
  800877:	68 7d 02 80 00       	push   $0x80027d
  80087c:	e8 36 fa ff ff       	call   8002b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800884:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088a:	83 c4 10             	add    $0x10,%esp
}
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    
		return -E_INVAL;
  80088f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800894:	eb f7                	jmp    80088d <vsnprintf+0x45>

00800896 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089f:	50                   	push   %eax
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 9a ff ff ff       	call   800848 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bf:	74 05                	je     8008c6 <strlen+0x16>
		n++;
  8008c1:	83 c0 01             	add    $0x1,%eax
  8008c4:	eb f5                	jmp    8008bb <strlen+0xb>
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	39 c2                	cmp    %eax,%edx
  8008d8:	74 0d                	je     8008e7 <strnlen+0x1f>
  8008da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008de:	74 05                	je     8008e5 <strnlen+0x1d>
		n++;
  8008e0:	83 c2 01             	add    $0x1,%edx
  8008e3:	eb f1                	jmp    8008d6 <strnlen+0xe>
  8008e5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ff:	83 c2 01             	add    $0x1,%edx
  800902:	84 c9                	test   %cl,%cl
  800904:	75 f2                	jne    8008f8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800906:	5b                   	pop    %ebx
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	83 ec 10             	sub    $0x10,%esp
  800910:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800913:	53                   	push   %ebx
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
  800919:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	01 d8                	add    %ebx,%eax
  800921:	50                   	push   %eax
  800922:	e8 c2 ff ff ff       	call   8008e9 <strcpy>
	return dst;
}
  800927:	89 d8                	mov    %ebx,%eax
  800929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	56                   	push   %esi
  800932:	53                   	push   %ebx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800939:	89 c6                	mov    %eax,%esi
  80093b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093e:	89 c2                	mov    %eax,%edx
  800940:	39 f2                	cmp    %esi,%edx
  800942:	74 11                	je     800955 <strncpy+0x27>
		*dst++ = *src;
  800944:	83 c2 01             	add    $0x1,%edx
  800947:	0f b6 19             	movzbl (%ecx),%ebx
  80094a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094d:	80 fb 01             	cmp    $0x1,%bl
  800950:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800953:	eb eb                	jmp    800940 <strncpy+0x12>
	}
	return ret;
}
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	8b 75 08             	mov    0x8(%ebp),%esi
  800961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800964:	8b 55 10             	mov    0x10(%ebp),%edx
  800967:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800969:	85 d2                	test   %edx,%edx
  80096b:	74 21                	je     80098e <strlcpy+0x35>
  80096d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800971:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800973:	39 c2                	cmp    %eax,%edx
  800975:	74 14                	je     80098b <strlcpy+0x32>
  800977:	0f b6 19             	movzbl (%ecx),%ebx
  80097a:	84 db                	test   %bl,%bl
  80097c:	74 0b                	je     800989 <strlcpy+0x30>
			*dst++ = *src++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	88 5a ff             	mov    %bl,-0x1(%edx)
  800987:	eb ea                	jmp    800973 <strlcpy+0x1a>
  800989:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80098b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098e:	29 f0                	sub    %esi,%eax
}
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 0c                	je     8009b0 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	75 08                	jne    8009b0 <strcmp+0x1c>
		p++, q++;
  8009a8:	83 c1 01             	add    $0x1,%ecx
  8009ab:	83 c2 01             	add    $0x1,%edx
  8009ae:	eb ed                	jmp    80099d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b0:	0f b6 c0             	movzbl %al,%eax
  8009b3:	0f b6 12             	movzbl (%edx),%edx
  8009b6:	29 d0                	sub    %edx,%eax
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	89 c3                	mov    %eax,%ebx
  8009c6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c9:	eb 06                	jmp    8009d1 <strncmp+0x17>
		n--, p++, q++;
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d1:	39 d8                	cmp    %ebx,%eax
  8009d3:	74 16                	je     8009eb <strncmp+0x31>
  8009d5:	0f b6 08             	movzbl (%eax),%ecx
  8009d8:	84 c9                	test   %cl,%cl
  8009da:	74 04                	je     8009e0 <strncmp+0x26>
  8009dc:	3a 0a                	cmp    (%edx),%cl
  8009de:	74 eb                	je     8009cb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e0:	0f b6 00             	movzbl (%eax),%eax
  8009e3:	0f b6 12             	movzbl (%edx),%edx
  8009e6:	29 d0                	sub    %edx,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    
		return 0;
  8009eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f0:	eb f6                	jmp    8009e8 <strncmp+0x2e>

008009f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fc:	0f b6 10             	movzbl (%eax),%edx
  8009ff:	84 d2                	test   %dl,%dl
  800a01:	74 09                	je     800a0c <strchr+0x1a>
		if (*s == c)
  800a03:	38 ca                	cmp    %cl,%dl
  800a05:	74 0a                	je     800a11 <strchr+0x1f>
	for (; *s; s++)
  800a07:	83 c0 01             	add    $0x1,%eax
  800a0a:	eb f0                	jmp    8009fc <strchr+0xa>
			return (char *) s;
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a20:	38 ca                	cmp    %cl,%dl
  800a22:	74 09                	je     800a2d <strfind+0x1a>
  800a24:	84 d2                	test   %dl,%dl
  800a26:	74 05                	je     800a2d <strfind+0x1a>
	for (; *s; s++)
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f0                	jmp    800a1d <strfind+0xa>
			break;
	return (char *) s;
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3b:	85 c9                	test   %ecx,%ecx
  800a3d:	74 31                	je     800a70 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	09 c8                	or     %ecx,%eax
  800a43:	a8 03                	test   $0x3,%al
  800a45:	75 23                	jne    800a6a <memset+0x3b>
		c &= 0xFF;
  800a47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4b:	89 d3                	mov    %edx,%ebx
  800a4d:	c1 e3 08             	shl    $0x8,%ebx
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	c1 e0 18             	shl    $0x18,%eax
  800a55:	89 d6                	mov    %edx,%esi
  800a57:	c1 e6 10             	shl    $0x10,%esi
  800a5a:	09 f0                	or     %esi,%eax
  800a5c:	09 c2                	or     %eax,%edx
  800a5e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a63:	89 d0                	mov    %edx,%eax
  800a65:	fc                   	cld    
  800a66:	f3 ab                	rep stos %eax,%es:(%edi)
  800a68:	eb 06                	jmp    800a70 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	fc                   	cld    
  800a6e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5f                   	pop    %edi
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	57                   	push   %edi
  800a7b:	56                   	push   %esi
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a85:	39 c6                	cmp    %eax,%esi
  800a87:	73 32                	jae    800abb <memmove+0x44>
  800a89:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8c:	39 c2                	cmp    %eax,%edx
  800a8e:	76 2b                	jbe    800abb <memmove+0x44>
		s += n;
		d += n;
  800a90:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a93:	89 fe                	mov    %edi,%esi
  800a95:	09 ce                	or     %ecx,%esi
  800a97:	09 d6                	or     %edx,%esi
  800a99:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9f:	75 0e                	jne    800aaf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1a                	jmp    800ad5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	89 c2                	mov    %eax,%edx
  800abd:	09 ca                	or     %ecx,%edx
  800abf:	09 f2                	or     %esi,%edx
  800ac1:	f6 c2 03             	test   $0x3,%dl
  800ac4:	75 0a                	jne    800ad0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac9:	89 c7                	mov    %eax,%edi
  800acb:	fc                   	cld    
  800acc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ace:	eb 05                	jmp    800ad5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad0:	89 c7                	mov    %eax,%edi
  800ad2:	fc                   	cld    
  800ad3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adf:	ff 75 10             	pushl  0x10(%ebp)
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	ff 75 08             	pushl  0x8(%ebp)
  800ae8:	e8 8a ff ff ff       	call   800a77 <memmove>
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afa:	89 c6                	mov    %eax,%esi
  800afc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aff:	39 f0                	cmp    %esi,%eax
  800b01:	74 1c                	je     800b1f <memcmp+0x30>
		if (*s1 != *s2)
  800b03:	0f b6 08             	movzbl (%eax),%ecx
  800b06:	0f b6 1a             	movzbl (%edx),%ebx
  800b09:	38 d9                	cmp    %bl,%cl
  800b0b:	75 08                	jne    800b15 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0d:	83 c0 01             	add    $0x1,%eax
  800b10:	83 c2 01             	add    $0x1,%edx
  800b13:	eb ea                	jmp    800aff <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b15:	0f b6 c1             	movzbl %cl,%eax
  800b18:	0f b6 db             	movzbl %bl,%ebx
  800b1b:	29 d8                	sub    %ebx,%eax
  800b1d:	eb 05                	jmp    800b24 <memcmp+0x35>
	}

	return 0;
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b36:	39 d0                	cmp    %edx,%eax
  800b38:	73 09                	jae    800b43 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3a:	38 08                	cmp    %cl,(%eax)
  800b3c:	74 05                	je     800b43 <memfind+0x1b>
	for (; s < ends; s++)
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	eb f3                	jmp    800b36 <memfind+0xe>
			break;
	return (void *) s;
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b51:	eb 03                	jmp    800b56 <strtol+0x11>
		s++;
  800b53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b56:	0f b6 01             	movzbl (%ecx),%eax
  800b59:	3c 20                	cmp    $0x20,%al
  800b5b:	74 f6                	je     800b53 <strtol+0xe>
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	74 f2                	je     800b53 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b61:	3c 2b                	cmp    $0x2b,%al
  800b63:	74 2a                	je     800b8f <strtol+0x4a>
	int neg = 0;
  800b65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6a:	3c 2d                	cmp    $0x2d,%al
  800b6c:	74 2b                	je     800b99 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b74:	75 0f                	jne    800b85 <strtol+0x40>
  800b76:	80 39 30             	cmpb   $0x30,(%ecx)
  800b79:	74 28                	je     800ba3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7b:	85 db                	test   %ebx,%ebx
  800b7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b82:	0f 44 d8             	cmove  %eax,%ebx
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8d:	eb 50                	jmp    800bdf <strtol+0x9a>
		s++;
  800b8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b92:	bf 00 00 00 00       	mov    $0x0,%edi
  800b97:	eb d5                	jmp    800b6e <strtol+0x29>
		s++, neg = 1;
  800b99:	83 c1 01             	add    $0x1,%ecx
  800b9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba1:	eb cb                	jmp    800b6e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba7:	74 0e                	je     800bb7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba9:	85 db                	test   %ebx,%ebx
  800bab:	75 d8                	jne    800b85 <strtol+0x40>
		s++, base = 8;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb5:	eb ce                	jmp    800b85 <strtol+0x40>
		s += 2, base = 16;
  800bb7:	83 c1 02             	add    $0x2,%ecx
  800bba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbf:	eb c4                	jmp    800b85 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc4:	89 f3                	mov    %esi,%ebx
  800bc6:	80 fb 19             	cmp    $0x19,%bl
  800bc9:	77 29                	ja     800bf4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bcb:	0f be d2             	movsbl %dl,%edx
  800bce:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd4:	7d 30                	jge    800c06 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdf:	0f b6 11             	movzbl (%ecx),%edx
  800be2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 09             	cmp    $0x9,%bl
  800bea:	77 d5                	ja     800bc1 <strtol+0x7c>
			dig = *s - '0';
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 30             	sub    $0x30,%edx
  800bf2:	eb dd                	jmp    800bd1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf7:	89 f3                	mov    %esi,%ebx
  800bf9:	80 fb 19             	cmp    $0x19,%bl
  800bfc:	77 08                	ja     800c06 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfe:	0f be d2             	movsbl %dl,%edx
  800c01:	83 ea 37             	sub    $0x37,%edx
  800c04:	eb cb                	jmp    800bd1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0a:	74 05                	je     800c11 <strtol+0xcc>
		*endptr = (char *) s;
  800c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c11:	89 c2                	mov    %eax,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	85 ff                	test   %edi,%edi
  800c17:	0f 45 c2             	cmovne %edx,%eax
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c30:	89 c3                	mov    %eax,%ebx
  800c32:	89 c7                	mov    %eax,%edi
  800c34:	89 c6                	mov    %eax,%esi
  800c36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
  800c48:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4d:	89 d1                	mov    %edx,%ecx
  800c4f:	89 d3                	mov    %edx,%ebx
  800c51:	89 d7                	mov    %edx,%edi
  800c53:	89 d6                	mov    %edx,%esi
  800c55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c72:	89 cb                	mov    %ecx,%ebx
  800c74:	89 cf                	mov    %ecx,%edi
  800c76:	89 ce                	mov    %ecx,%esi
  800c78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	7f 08                	jg     800c86 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	50                   	push   %eax
  800c8a:	6a 03                	push   $0x3
  800c8c:	68 80 15 80 00       	push   $0x801580
  800c91:	6a 43                	push   $0x43
  800c93:	68 9d 15 80 00       	push   $0x80159d
  800c98:	e8 70 02 00 00       	call   800f0d <_panic>

00800c9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cad:	89 d1                	mov    %edx,%ecx
  800caf:	89 d3                	mov    %edx,%ebx
  800cb1:	89 d7                	mov    %edx,%edi
  800cb3:	89 d6                	mov    %edx,%esi
  800cb5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_yield>:

void
sys_yield(void)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ccc:	89 d1                	mov    %edx,%ecx
  800cce:	89 d3                	mov    %edx,%ebx
  800cd0:	89 d7                	mov    %edx,%edi
  800cd2:	89 d6                	mov    %edx,%esi
  800cd4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce4:	be 00 00 00 00       	mov    $0x0,%esi
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf7:	89 f7                	mov    %esi,%edi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d0b:	6a 04                	push   $0x4
  800d0d:	68 80 15 80 00       	push   $0x801580
  800d12:	6a 43                	push   $0x43
  800d14:	68 9d 15 80 00       	push   $0x80159d
  800d19:	e8 ef 01 00 00       	call   800f0d <_panic>

00800d1e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d38:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d4d:	6a 05                	push   $0x5
  800d4f:	68 80 15 80 00       	push   $0x801580
  800d54:	6a 43                	push   $0x43
  800d56:	68 9d 15 80 00       	push   $0x80159d
  800d5b:	e8 ad 01 00 00       	call   800f0d <_panic>

00800d60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d74:	b8 06 00 00 00       	mov    $0x6,%eax
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	89 de                	mov    %ebx,%esi
  800d7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7f 08                	jg     800d8b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d8f:	6a 06                	push   $0x6
  800d91:	68 80 15 80 00       	push   $0x801580
  800d96:	6a 43                	push   $0x43
  800d98:	68 9d 15 80 00       	push   $0x80159d
  800d9d:	e8 6b 01 00 00       	call   800f0d <_panic>

00800da2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800db6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800dd1:	6a 08                	push   $0x8
  800dd3:	68 80 15 80 00       	push   $0x801580
  800dd8:	6a 43                	push   $0x43
  800dda:	68 9d 15 80 00       	push   $0x80159d
  800ddf:	e8 29 01 00 00       	call   800f0d <_panic>

00800de4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800df8:	b8 09 00 00 00       	mov    $0x9,%eax
  800dfd:	89 df                	mov    %ebx,%edi
  800dff:	89 de                	mov    %ebx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800e13:	6a 09                	push   $0x9
  800e15:	68 80 15 80 00       	push   $0x801580
  800e1a:	6a 43                	push   $0x43
  800e1c:	68 9d 15 80 00       	push   $0x80159d
  800e21:	e8 e7 00 00 00       	call   800f0d <_panic>

00800e26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	89 de                	mov    %ebx,%esi
  800e43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7f 08                	jg     800e51 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	50                   	push   %eax
  800e55:	6a 0a                	push   $0xa
  800e57:	68 80 15 80 00       	push   $0x801580
  800e5c:	6a 43                	push   $0x43
  800e5e:	68 9d 15 80 00       	push   $0x80159d
  800e63:	e8 a5 00 00 00       	call   800f0d <_panic>

00800e68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e79:	be 00 00 00 00       	mov    $0x0,%esi
  800e7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e84:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea1:	89 cb                	mov    %ecx,%ebx
  800ea3:	89 cf                	mov    %ecx,%edi
  800ea5:	89 ce                	mov    %ecx,%esi
  800ea7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	7f 08                	jg     800eb5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	6a 0d                	push   $0xd
  800ebb:	68 80 15 80 00       	push   $0x801580
  800ec0:	6a 43                	push   $0x43
  800ec2:	68 9d 15 80 00       	push   $0x80159d
  800ec7:	e8 41 00 00 00       	call   800f0d <_panic>

00800ecc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f00:	89 cb                	mov    %ecx,%ebx
  800f02:	89 cf                	mov    %ecx,%edi
  800f04:	89 ce                	mov    %ecx,%esi
  800f06:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f12:	a1 04 20 80 00       	mov    0x802004,%eax
  800f17:	8b 40 48             	mov    0x48(%eax),%eax
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	68 dc 15 80 00       	push   $0x8015dc
  800f22:	50                   	push   %eax
  800f23:	68 ab 15 80 00       	push   $0x8015ab
  800f28:	e8 5d f2 ff ff       	call   80018a <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f2d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f30:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f36:	e8 62 fd ff ff       	call   800c9d <sys_getenvid>
  800f3b:	83 c4 04             	add    $0x4,%esp
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	ff 75 08             	pushl  0x8(%ebp)
  800f44:	56                   	push   %esi
  800f45:	50                   	push   %eax
  800f46:	68 b8 15 80 00       	push   $0x8015b8
  800f4b:	e8 3a f2 ff ff       	call   80018a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f50:	83 c4 18             	add    $0x18,%esp
  800f53:	53                   	push   %ebx
  800f54:	ff 75 10             	pushl  0x10(%ebp)
  800f57:	e8 dd f1 ff ff       	call   800139 <vcprintf>
	cprintf("\n");
  800f5c:	c7 04 24 b4 15 80 00 	movl   $0x8015b4,(%esp)
  800f63:	e8 22 f2 ff ff       	call   80018a <cprintf>
  800f68:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f6b:	cc                   	int3   
  800f6c:	eb fd                	jmp    800f6b <_panic+0x5e>
  800f6e:	66 90                	xchg   %ax,%ax

00800f70 <__udivdi3>:
  800f70:	55                   	push   %ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 1c             	sub    $0x1c,%esp
  800f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f87:	85 d2                	test   %edx,%edx
  800f89:	75 4d                	jne    800fd8 <__udivdi3+0x68>
  800f8b:	39 f3                	cmp    %esi,%ebx
  800f8d:	76 19                	jbe    800fa8 <__udivdi3+0x38>
  800f8f:	31 ff                	xor    %edi,%edi
  800f91:	89 e8                	mov    %ebp,%eax
  800f93:	89 f2                	mov    %esi,%edx
  800f95:	f7 f3                	div    %ebx
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	83 c4 1c             	add    $0x1c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	89 d9                	mov    %ebx,%ecx
  800faa:	85 db                	test   %ebx,%ebx
  800fac:	75 0b                	jne    800fb9 <__udivdi3+0x49>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	31 d2                	xor    %edx,%edx
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 c6                	mov    %eax,%esi
  800fc1:	89 e8                	mov    %ebp,%eax
  800fc3:	89 f7                	mov    %esi,%edi
  800fc5:	f7 f1                	div    %ecx
  800fc7:	89 fa                	mov    %edi,%edx
  800fc9:	83 c4 1c             	add    $0x1c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
  800fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd8:	39 f2                	cmp    %esi,%edx
  800fda:	77 1c                	ja     800ff8 <__udivdi3+0x88>
  800fdc:	0f bd fa             	bsr    %edx,%edi
  800fdf:	83 f7 1f             	xor    $0x1f,%edi
  800fe2:	75 2c                	jne    801010 <__udivdi3+0xa0>
  800fe4:	39 f2                	cmp    %esi,%edx
  800fe6:	72 06                	jb     800fee <__udivdi3+0x7e>
  800fe8:	31 c0                	xor    %eax,%eax
  800fea:	39 eb                	cmp    %ebp,%ebx
  800fec:	77 a9                	ja     800f97 <__udivdi3+0x27>
  800fee:	b8 01 00 00 00       	mov    $0x1,%eax
  800ff3:	eb a2                	jmp    800f97 <__udivdi3+0x27>
  800ff5:	8d 76 00             	lea    0x0(%esi),%esi
  800ff8:	31 ff                	xor    %edi,%edi
  800ffa:	31 c0                	xor    %eax,%eax
  800ffc:	89 fa                	mov    %edi,%edx
  800ffe:	83 c4 1c             	add    $0x1c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
  801006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80100d:	8d 76 00             	lea    0x0(%esi),%esi
  801010:	89 f9                	mov    %edi,%ecx
  801012:	b8 20 00 00 00       	mov    $0x20,%eax
  801017:	29 f8                	sub    %edi,%eax
  801019:	d3 e2                	shl    %cl,%edx
  80101b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80101f:	89 c1                	mov    %eax,%ecx
  801021:	89 da                	mov    %ebx,%edx
  801023:	d3 ea                	shr    %cl,%edx
  801025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801029:	09 d1                	or     %edx,%ecx
  80102b:	89 f2                	mov    %esi,%edx
  80102d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801031:	89 f9                	mov    %edi,%ecx
  801033:	d3 e3                	shl    %cl,%ebx
  801035:	89 c1                	mov    %eax,%ecx
  801037:	d3 ea                	shr    %cl,%edx
  801039:	89 f9                	mov    %edi,%ecx
  80103b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80103f:	89 eb                	mov    %ebp,%ebx
  801041:	d3 e6                	shl    %cl,%esi
  801043:	89 c1                	mov    %eax,%ecx
  801045:	d3 eb                	shr    %cl,%ebx
  801047:	09 de                	or     %ebx,%esi
  801049:	89 f0                	mov    %esi,%eax
  80104b:	f7 74 24 08          	divl   0x8(%esp)
  80104f:	89 d6                	mov    %edx,%esi
  801051:	89 c3                	mov    %eax,%ebx
  801053:	f7 64 24 0c          	mull   0xc(%esp)
  801057:	39 d6                	cmp    %edx,%esi
  801059:	72 15                	jb     801070 <__udivdi3+0x100>
  80105b:	89 f9                	mov    %edi,%ecx
  80105d:	d3 e5                	shl    %cl,%ebp
  80105f:	39 c5                	cmp    %eax,%ebp
  801061:	73 04                	jae    801067 <__udivdi3+0xf7>
  801063:	39 d6                	cmp    %edx,%esi
  801065:	74 09                	je     801070 <__udivdi3+0x100>
  801067:	89 d8                	mov    %ebx,%eax
  801069:	31 ff                	xor    %edi,%edi
  80106b:	e9 27 ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  801070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801073:	31 ff                	xor    %edi,%edi
  801075:	e9 1d ff ff ff       	jmp    800f97 <__udivdi3+0x27>
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__umoddi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80108b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80108f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801097:	89 da                	mov    %ebx,%edx
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 43                	jne    8010e0 <__umoddi3+0x60>
  80109d:	39 df                	cmp    %ebx,%edi
  80109f:	76 17                	jbe    8010b8 <__umoddi3+0x38>
  8010a1:	89 f0                	mov    %esi,%eax
  8010a3:	f7 f7                	div    %edi
  8010a5:	89 d0                	mov    %edx,%eax
  8010a7:	31 d2                	xor    %edx,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 fd                	mov    %edi,%ebp
  8010ba:	85 ff                	test   %edi,%edi
  8010bc:	75 0b                	jne    8010c9 <__umoddi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f7                	div    %edi
  8010c7:	89 c5                	mov    %eax,%ebp
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	31 d2                	xor    %edx,%edx
  8010cd:	f7 f5                	div    %ebp
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	f7 f5                	div    %ebp
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	eb d0                	jmp    8010a7 <__umoddi3+0x27>
  8010d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010de:	66 90                	xchg   %ax,%ax
  8010e0:	89 f1                	mov    %esi,%ecx
  8010e2:	39 d8                	cmp    %ebx,%eax
  8010e4:	76 0a                	jbe    8010f0 <__umoddi3+0x70>
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	83 c4 1c             	add    $0x1c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
  8010f0:	0f bd e8             	bsr    %eax,%ebp
  8010f3:	83 f5 1f             	xor    $0x1f,%ebp
  8010f6:	75 20                	jne    801118 <__umoddi3+0x98>
  8010f8:	39 d8                	cmp    %ebx,%eax
  8010fa:	0f 82 b0 00 00 00    	jb     8011b0 <__umoddi3+0x130>
  801100:	39 f7                	cmp    %esi,%edi
  801102:	0f 86 a8 00 00 00    	jbe    8011b0 <__umoddi3+0x130>
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	83 c4 1c             	add    $0x1c,%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
  801112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801118:	89 e9                	mov    %ebp,%ecx
  80111a:	ba 20 00 00 00       	mov    $0x20,%edx
  80111f:	29 ea                	sub    %ebp,%edx
  801121:	d3 e0                	shl    %cl,%eax
  801123:	89 44 24 08          	mov    %eax,0x8(%esp)
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 f8                	mov    %edi,%eax
  80112b:	d3 e8                	shr    %cl,%eax
  80112d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801131:	89 54 24 04          	mov    %edx,0x4(%esp)
  801135:	8b 54 24 04          	mov    0x4(%esp),%edx
  801139:	09 c1                	or     %eax,%ecx
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 e9                	mov    %ebp,%ecx
  801143:	d3 e7                	shl    %cl,%edi
  801145:	89 d1                	mov    %edx,%ecx
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80114f:	d3 e3                	shl    %cl,%ebx
  801151:	89 c7                	mov    %eax,%edi
  801153:	89 d1                	mov    %edx,%ecx
  801155:	89 f0                	mov    %esi,%eax
  801157:	d3 e8                	shr    %cl,%eax
  801159:	89 e9                	mov    %ebp,%ecx
  80115b:	89 fa                	mov    %edi,%edx
  80115d:	d3 e6                	shl    %cl,%esi
  80115f:	09 d8                	or     %ebx,%eax
  801161:	f7 74 24 08          	divl   0x8(%esp)
  801165:	89 d1                	mov    %edx,%ecx
  801167:	89 f3                	mov    %esi,%ebx
  801169:	f7 64 24 0c          	mull   0xc(%esp)
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	89 d7                	mov    %edx,%edi
  801171:	39 d1                	cmp    %edx,%ecx
  801173:	72 06                	jb     80117b <__umoddi3+0xfb>
  801175:	75 10                	jne    801187 <__umoddi3+0x107>
  801177:	39 c3                	cmp    %eax,%ebx
  801179:	73 0c                	jae    801187 <__umoddi3+0x107>
  80117b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80117f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801183:	89 d7                	mov    %edx,%edi
  801185:	89 c6                	mov    %eax,%esi
  801187:	89 ca                	mov    %ecx,%edx
  801189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80118e:	29 f3                	sub    %esi,%ebx
  801190:	19 fa                	sbb    %edi,%edx
  801192:	89 d0                	mov    %edx,%eax
  801194:	d3 e0                	shl    %cl,%eax
  801196:	89 e9                	mov    %ebp,%ecx
  801198:	d3 eb                	shr    %cl,%ebx
  80119a:	d3 ea                	shr    %cl,%edx
  80119c:	09 d8                	or     %ebx,%eax
  80119e:	83 c4 1c             	add    $0x1c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
  8011a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ad:	8d 76 00             	lea    0x0(%esi),%esi
  8011b0:	89 da                	mov    %ebx,%edx
  8011b2:	29 fe                	sub    %edi,%esi
  8011b4:	19 c2                	sbb    %eax,%edx
  8011b6:	89 f1                	mov    %esi,%ecx
  8011b8:	89 c8                	mov    %ecx,%eax
  8011ba:	e9 4b ff ff ff       	jmp    80110a <__umoddi3+0x8a>
