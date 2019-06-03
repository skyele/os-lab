
obj/user/faultwritekernel.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0xf0100000 = 0;
  800033:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	57                   	push   %edi
  800042:	56                   	push   %esi
  800043:	53                   	push   %ebx
  800044:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800047:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80004e:	00 00 00 
	envid_t find = sys_getenvid();
  800051:	e8 4c 0c 00 00       	call   800ca2 <sys_getenvid>
  800056:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800061:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800066:	bf 01 00 00 00       	mov    $0x1,%edi
  80006b:	eb 0b                	jmp    800078 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80006d:	83 c2 01             	add    $0x1,%edx
  800070:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800076:	74 21                	je     800099 <libmain+0x5b>
		if(envs[i].env_id == find)
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	c1 e1 07             	shl    $0x7,%ecx
  80007d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800083:	8b 49 48             	mov    0x48(%ecx),%ecx
  800086:	39 c1                	cmp    %eax,%ecx
  800088:	75 e3                	jne    80006d <libmain+0x2f>
  80008a:	89 d3                	mov    %edx,%ebx
  80008c:	c1 e3 07             	shl    $0x7,%ebx
  80008f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800095:	89 fe                	mov    %edi,%esi
  800097:	eb d4                	jmp    80006d <libmain+0x2f>
  800099:	89 f0                	mov    %esi,%eax
  80009b:	84 c0                	test   %al,%al
  80009d:	74 06                	je     8000a5 <libmain+0x67>
  80009f:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a9:	7e 0a                	jle    8000b5 <libmain+0x77>
		binaryname = argv[0];
  8000ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ae:	8b 00                	mov    (%eax),%eax
  8000b0:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	68 00 25 80 00       	push   $0x802500
  8000bd:	e8 cd 00 00 00       	call   80018f <cprintf>
	// call user main routine
	umain(argc, argv);
  8000c2:	83 c4 08             	add    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 63 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d0:	e8 0b 00 00 00       	call   8000e0 <exit>
}
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5f                   	pop    %edi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e6:	e8 a2 10 00 00       	call   80118d <close_all>
	sys_env_destroy(0);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 6c 0b 00 00       	call   800c61 <sys_env_destroy>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	c9                   	leave  
  8000f9:	c3                   	ret    

008000fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800104:	8b 13                	mov    (%ebx),%edx
  800106:	8d 42 01             	lea    0x1(%edx),%eax
  800109:	89 03                	mov    %eax,(%ebx)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800112:	3d ff 00 00 00       	cmp    $0xff,%eax
  800117:	74 09                	je     800122 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 f1 0a 00 00       	call   800c24 <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb db                	jmp    800119 <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fa 00 80 00       	push   $0x8000fa
  80016d:	e8 4a 01 00 00       	call   8002bc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 9d 0a 00 00       	call   800c24 <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c6                	mov    %eax,%esi
  8001ae:	89 d7                	mov    %edx,%edi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001c2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c6:	74 2c                	je     8001f4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d8:	39 c2                	cmp    %eax,%edx
  8001da:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001dd:	73 43                	jae    800222 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	85 db                	test   %ebx,%ebx
  8001e4:	7e 6c                	jle    800252 <printnum+0xaf>
				putch(padc, putdat);
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	57                   	push   %edi
  8001ea:	ff 75 18             	pushl  0x18(%ebp)
  8001ed:	ff d6                	call   *%esi
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	eb eb                	jmp    8001df <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	6a 20                	push   $0x20
  8001f9:	6a 00                	push   $0x0
  8001fb:	50                   	push   %eax
  8001fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800202:	89 fa                	mov    %edi,%edx
  800204:	89 f0                	mov    %esi,%eax
  800206:	e8 98 ff ff ff       	call   8001a3 <printnum>
		while (--width > 0)
  80020b:	83 c4 20             	add    $0x20,%esp
  80020e:	83 eb 01             	sub    $0x1,%ebx
  800211:	85 db                	test   %ebx,%ebx
  800213:	7e 65                	jle    80027a <printnum+0xd7>
			putch(padc, putdat);
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	57                   	push   %edi
  800219:	6a 20                	push   $0x20
  80021b:	ff d6                	call   *%esi
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	eb ec                	jmp    80020e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	ff 75 18             	pushl  0x18(%ebp)
  800228:	83 eb 01             	sub    $0x1,%ebx
  80022b:	53                   	push   %ebx
  80022c:	50                   	push   %eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	ff 75 dc             	pushl  -0x24(%ebp)
  800233:	ff 75 d8             	pushl  -0x28(%ebp)
  800236:	ff 75 e4             	pushl  -0x1c(%ebp)
  800239:	ff 75 e0             	pushl  -0x20(%ebp)
  80023c:	e8 6f 20 00 00       	call   8022b0 <__udivdi3>
  800241:	83 c4 18             	add    $0x18,%esp
  800244:	52                   	push   %edx
  800245:	50                   	push   %eax
  800246:	89 fa                	mov    %edi,%edx
  800248:	89 f0                	mov    %esi,%eax
  80024a:	e8 54 ff ff ff       	call   8001a3 <printnum>
  80024f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800252:	83 ec 08             	sub    $0x8,%esp
  800255:	57                   	push   %edi
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	ff 75 dc             	pushl  -0x24(%ebp)
  80025c:	ff 75 d8             	pushl  -0x28(%ebp)
  80025f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800262:	ff 75 e0             	pushl  -0x20(%ebp)
  800265:	e8 56 21 00 00       	call   8023c0 <__umoddi3>
  80026a:	83 c4 14             	add    $0x14,%esp
  80026d:	0f be 80 17 25 80 00 	movsbl 0x802517(%eax),%eax
  800274:	50                   	push   %eax
  800275:	ff d6                	call   *%esi
  800277:	83 c4 10             	add    $0x10,%esp
	}
}
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800288:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028c:	8b 10                	mov    (%eax),%edx
  80028e:	3b 50 04             	cmp    0x4(%eax),%edx
  800291:	73 0a                	jae    80029d <sprintputch+0x1b>
		*b->buf++ = ch;
  800293:	8d 4a 01             	lea    0x1(%edx),%ecx
  800296:	89 08                	mov    %ecx,(%eax)
  800298:	8b 45 08             	mov    0x8(%ebp),%eax
  80029b:	88 02                	mov    %al,(%edx)
}
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <printfmt>:
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a8:	50                   	push   %eax
  8002a9:	ff 75 10             	pushl  0x10(%ebp)
  8002ac:	ff 75 0c             	pushl  0xc(%ebp)
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	e8 05 00 00 00       	call   8002bc <vprintfmt>
}
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <vprintfmt>:
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 3c             	sub    $0x3c,%esp
  8002c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ce:	e9 32 04 00 00       	jmp    800705 <vprintfmt+0x449>
		padc = ' ';
  8002d3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002d7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002de:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002fa:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002ff:	8d 47 01             	lea    0x1(%edi),%eax
  800302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800305:	0f b6 17             	movzbl (%edi),%edx
  800308:	8d 42 dd             	lea    -0x23(%edx),%eax
  80030b:	3c 55                	cmp    $0x55,%al
  80030d:	0f 87 12 05 00 00    	ja     800825 <vprintfmt+0x569>
  800313:	0f b6 c0             	movzbl %al,%eax
  800316:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800320:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800324:	eb d9                	jmp    8002ff <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800329:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80032d:	eb d0                	jmp    8002ff <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032f:	0f b6 d2             	movzbl %dl,%edx
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	89 75 08             	mov    %esi,0x8(%ebp)
  80033d:	eb 03                	jmp    800342 <vprintfmt+0x86>
  80033f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800342:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800345:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800349:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80034f:	83 fe 09             	cmp    $0x9,%esi
  800352:	76 eb                	jbe    80033f <vprintfmt+0x83>
  800354:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800357:	8b 75 08             	mov    0x8(%ebp),%esi
  80035a:	eb 14                	jmp    800370 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800364:	8b 45 14             	mov    0x14(%ebp),%eax
  800367:	8d 40 04             	lea    0x4(%eax),%eax
  80036a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800370:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800374:	79 89                	jns    8002ff <vprintfmt+0x43>
				width = precision, precision = -1;
  800376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800379:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800383:	e9 77 ff ff ff       	jmp    8002ff <vprintfmt+0x43>
  800388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038b:	85 c0                	test   %eax,%eax
  80038d:	0f 48 c1             	cmovs  %ecx,%eax
  800390:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800396:	e9 64 ff ff ff       	jmp    8002ff <vprintfmt+0x43>
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003a5:	e9 55 ff ff ff       	jmp    8002ff <vprintfmt+0x43>
			lflag++;
  8003aa:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b1:	e9 49 ff ff ff       	jmp    8002ff <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8d 78 04             	lea    0x4(%eax),%edi
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	53                   	push   %ebx
  8003c0:	ff 30                	pushl  (%eax)
  8003c2:	ff d6                	call   *%esi
			break;
  8003c4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ca:	e9 33 03 00 00       	jmp    800702 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8d 78 04             	lea    0x4(%eax),%edi
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	99                   	cltd   
  8003d8:	31 d0                	xor    %edx,%eax
  8003da:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003dc:	83 f8 10             	cmp    $0x10,%eax
  8003df:	7f 23                	jg     800404 <vprintfmt+0x148>
  8003e1:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003e8:	85 d2                	test   %edx,%edx
  8003ea:	74 18                	je     800404 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003ec:	52                   	push   %edx
  8003ed:	68 79 29 80 00       	push   $0x802979
  8003f2:	53                   	push   %ebx
  8003f3:	56                   	push   %esi
  8003f4:	e8 a6 fe ff ff       	call   80029f <printfmt>
  8003f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003ff:	e9 fe 02 00 00       	jmp    800702 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800404:	50                   	push   %eax
  800405:	68 2f 25 80 00       	push   $0x80252f
  80040a:	53                   	push   %ebx
  80040b:	56                   	push   %esi
  80040c:	e8 8e fe ff ff       	call   80029f <printfmt>
  800411:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800414:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800417:	e9 e6 02 00 00       	jmp    800702 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	83 c0 04             	add    $0x4,%eax
  800422:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800425:	8b 45 14             	mov    0x14(%ebp),%eax
  800428:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80042a:	85 c9                	test   %ecx,%ecx
  80042c:	b8 28 25 80 00       	mov    $0x802528,%eax
  800431:	0f 45 c1             	cmovne %ecx,%eax
  800434:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043b:	7e 06                	jle    800443 <vprintfmt+0x187>
  80043d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800441:	75 0d                	jne    800450 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800446:	89 c7                	mov    %eax,%edi
  800448:	03 45 e0             	add    -0x20(%ebp),%eax
  80044b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044e:	eb 53                	jmp    8004a3 <vprintfmt+0x1e7>
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 d8             	pushl  -0x28(%ebp)
  800456:	50                   	push   %eax
  800457:	e8 71 04 00 00       	call   8008cd <strnlen>
  80045c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045f:	29 c1                	sub    %eax,%ecx
  800461:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800469:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800470:	eb 0f                	jmp    800481 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	53                   	push   %ebx
  800476:	ff 75 e0             	pushl  -0x20(%ebp)
  800479:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	83 ef 01             	sub    $0x1,%edi
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	85 ff                	test   %edi,%edi
  800483:	7f ed                	jg     800472 <vprintfmt+0x1b6>
  800485:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800488:	85 c9                	test   %ecx,%ecx
  80048a:	b8 00 00 00 00       	mov    $0x0,%eax
  80048f:	0f 49 c1             	cmovns %ecx,%eax
  800492:	29 c1                	sub    %eax,%ecx
  800494:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800497:	eb aa                	jmp    800443 <vprintfmt+0x187>
					putch(ch, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	53                   	push   %ebx
  80049d:	52                   	push   %edx
  80049e:	ff d6                	call   *%esi
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a8:	83 c7 01             	add    $0x1,%edi
  8004ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004af:	0f be d0             	movsbl %al,%edx
  8004b2:	85 d2                	test   %edx,%edx
  8004b4:	74 4b                	je     800501 <vprintfmt+0x245>
  8004b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ba:	78 06                	js     8004c2 <vprintfmt+0x206>
  8004bc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c0:	78 1e                	js     8004e0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c6:	74 d1                	je     800499 <vprintfmt+0x1dd>
  8004c8:	0f be c0             	movsbl %al,%eax
  8004cb:	83 e8 20             	sub    $0x20,%eax
  8004ce:	83 f8 5e             	cmp    $0x5e,%eax
  8004d1:	76 c6                	jbe    800499 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	6a 3f                	push   $0x3f
  8004d9:	ff d6                	call   *%esi
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	eb c3                	jmp    8004a3 <vprintfmt+0x1e7>
  8004e0:	89 cf                	mov    %ecx,%edi
  8004e2:	eb 0e                	jmp    8004f2 <vprintfmt+0x236>
				putch(' ', putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	53                   	push   %ebx
  8004e8:	6a 20                	push   $0x20
  8004ea:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ec:	83 ef 01             	sub    $0x1,%edi
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	85 ff                	test   %edi,%edi
  8004f4:	7f ee                	jg     8004e4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fc:	e9 01 02 00 00       	jmp    800702 <vprintfmt+0x446>
  800501:	89 cf                	mov    %ecx,%edi
  800503:	eb ed                	jmp    8004f2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800508:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80050f:	e9 eb fd ff ff       	jmp    8002ff <vprintfmt+0x43>
	if (lflag >= 2)
  800514:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800518:	7f 21                	jg     80053b <vprintfmt+0x27f>
	else if (lflag)
  80051a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80051e:	74 68                	je     800588 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800528:	89 c1                	mov    %eax,%ecx
  80052a:	c1 f9 1f             	sar    $0x1f,%ecx
  80052d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	8d 40 04             	lea    0x4(%eax),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
  800539:	eb 17                	jmp    800552 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 50 04             	mov    0x4(%eax),%edx
  800541:	8b 00                	mov    (%eax),%eax
  800543:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800546:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8d 40 08             	lea    0x8(%eax),%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800552:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800555:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800558:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80055e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800562:	78 3f                	js     8005a3 <vprintfmt+0x2e7>
			base = 10;
  800564:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800569:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80056d:	0f 84 71 01 00 00    	je     8006e4 <vprintfmt+0x428>
				putch('+', putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	6a 2b                	push   $0x2b
  800579:	ff d6                	call   *%esi
  80057b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800583:	e9 5c 01 00 00       	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800590:	89 c1                	mov    %eax,%ecx
  800592:	c1 f9 1f             	sar    $0x1f,%ecx
  800595:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a1:	eb af                	jmp    800552 <vprintfmt+0x296>
				putch('-', putdat);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	53                   	push   %ebx
  8005a7:	6a 2d                	push   $0x2d
  8005a9:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b1:	f7 d8                	neg    %eax
  8005b3:	83 d2 00             	adc    $0x0,%edx
  8005b6:	f7 da                	neg    %edx
  8005b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 19 01 00 00       	jmp    8006e4 <vprintfmt+0x428>
	if (lflag >= 2)
  8005cb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005cf:	7f 29                	jg     8005fa <vprintfmt+0x33e>
	else if (lflag)
  8005d1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005d5:	74 44                	je     80061b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f5:	e9 ea 00 00 00       	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 50 04             	mov    0x4(%eax),%edx
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 08             	lea    0x8(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
  800616:	e9 c9 00 00 00       	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	ba 00 00 00 00       	mov    $0x0,%edx
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
  800639:	e9 a6 00 00 00       	jmp    8006e4 <vprintfmt+0x428>
			putch('0', putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 30                	push   $0x30
  800644:	ff d6                	call   *%esi
	if (lflag >= 2)
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80064d:	7f 26                	jg     800675 <vprintfmt+0x3b9>
	else if (lflag)
  80064f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800653:	74 3e                	je     800693 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066e:	b8 08 00 00 00       	mov    $0x8,%eax
  800673:	eb 6f                	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 50 04             	mov    0x4(%eax),%edx
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800680:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8d 40 08             	lea    0x8(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068c:	b8 08 00 00 00       	mov    $0x8,%eax
  800691:	eb 51                	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b1:	eb 31                	jmp    8006e4 <vprintfmt+0x428>
			putch('0', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 30                	push   $0x30
  8006b9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bb:	83 c4 08             	add    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 78                	push   $0x78
  8006c1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006d3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006df:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e4:	83 ec 0c             	sub    $0xc,%esp
  8006e7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006eb:	52                   	push   %edx
  8006ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f6:	89 da                	mov    %ebx,%edx
  8006f8:	89 f0                	mov    %esi,%eax
  8006fa:	e8 a4 fa ff ff       	call   8001a3 <printnum>
			break;
  8006ff:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800702:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800705:	83 c7 01             	add    $0x1,%edi
  800708:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070c:	83 f8 25             	cmp    $0x25,%eax
  80070f:	0f 84 be fb ff ff    	je     8002d3 <vprintfmt+0x17>
			if (ch == '\0')
  800715:	85 c0                	test   %eax,%eax
  800717:	0f 84 28 01 00 00    	je     800845 <vprintfmt+0x589>
			putch(ch, putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	50                   	push   %eax
  800722:	ff d6                	call   *%esi
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb dc                	jmp    800705 <vprintfmt+0x449>
	if (lflag >= 2)
  800729:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80072d:	7f 26                	jg     800755 <vprintfmt+0x499>
	else if (lflag)
  80072f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800733:	74 41                	je     800776 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074e:	b8 10 00 00 00       	mov    $0x10,%eax
  800753:	eb 8f                	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 50 04             	mov    0x4(%eax),%edx
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8d 40 08             	lea    0x8(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076c:	b8 10 00 00 00       	mov    $0x10,%eax
  800771:	e9 6e ff ff ff       	jmp    8006e4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800783:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 40 04             	lea    0x4(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078f:	b8 10 00 00 00       	mov    $0x10,%eax
  800794:	e9 4b ff ff ff       	jmp    8006e4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	83 c0 04             	add    $0x4,%eax
  80079f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	74 14                	je     8007bf <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007ab:	8b 13                	mov    (%ebx),%edx
  8007ad:	83 fa 7f             	cmp    $0x7f,%edx
  8007b0:	7f 37                	jg     8007e9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007b2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ba:	e9 43 ff ff ff       	jmp    800702 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c4:	bf 4d 26 80 00       	mov    $0x80264d,%edi
							putch(ch, putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	53                   	push   %ebx
  8007cd:	50                   	push   %eax
  8007ce:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007d0:	83 c7 01             	add    $0x1,%edi
  8007d3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	75 eb                	jne    8007c9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e4:	e9 19 ff ff ff       	jmp    800702 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007e9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	bf 85 26 80 00       	mov    $0x802685,%edi
							putch(ch, putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	50                   	push   %eax
  8007fa:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007fc:	83 c7 01             	add    $0x1,%edi
  8007ff:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	85 c0                	test   %eax,%eax
  800808:	75 eb                	jne    8007f5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80080a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
  800810:	e9 ed fe ff ff       	jmp    800702 <vprintfmt+0x446>
			putch(ch, putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	6a 25                	push   $0x25
  80081b:	ff d6                	call   *%esi
			break;
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	e9 dd fe ff ff       	jmp    800702 <vprintfmt+0x446>
			putch('%', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	6a 25                	push   $0x25
  80082b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 f8                	mov    %edi,%eax
  800832:	eb 03                	jmp    800837 <vprintfmt+0x57b>
  800834:	83 e8 01             	sub    $0x1,%eax
  800837:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083b:	75 f7                	jne    800834 <vprintfmt+0x578>
  80083d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800840:	e9 bd fe ff ff       	jmp    800702 <vprintfmt+0x446>
}
  800845:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800848:	5b                   	pop    %ebx
  800849:	5e                   	pop    %esi
  80084a:	5f                   	pop    %edi
  80084b:	5d                   	pop    %ebp
  80084c:	c3                   	ret    

0080084d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	83 ec 18             	sub    $0x18,%esp
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800859:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80085c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800860:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80086a:	85 c0                	test   %eax,%eax
  80086c:	74 26                	je     800894 <vsnprintf+0x47>
  80086e:	85 d2                	test   %edx,%edx
  800870:	7e 22                	jle    800894 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800872:	ff 75 14             	pushl  0x14(%ebp)
  800875:	ff 75 10             	pushl  0x10(%ebp)
  800878:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80087b:	50                   	push   %eax
  80087c:	68 82 02 80 00       	push   $0x800282
  800881:	e8 36 fa ff ff       	call   8002bc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800886:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800889:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80088c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088f:	83 c4 10             	add    $0x10,%esp
}
  800892:	c9                   	leave  
  800893:	c3                   	ret    
		return -E_INVAL;
  800894:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800899:	eb f7                	jmp    800892 <vsnprintf+0x45>

0080089b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a4:	50                   	push   %eax
  8008a5:	ff 75 10             	pushl  0x10(%ebp)
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 9a ff ff ff       	call   80084d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	74 05                	je     8008cb <strlen+0x16>
		n++;
  8008c6:	83 c0 01             	add    $0x1,%eax
  8008c9:	eb f5                	jmp    8008c0 <strlen+0xb>
	return n;
}
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	74 0d                	je     8008ec <strnlen+0x1f>
  8008df:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008e3:	74 05                	je     8008ea <strnlen+0x1d>
		n++;
  8008e5:	83 c2 01             	add    $0x1,%edx
  8008e8:	eb f1                	jmp    8008db <strnlen+0xe>
  8008ea:	89 d0                	mov    %edx,%eax
	return n;
}
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	53                   	push   %ebx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800901:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800904:	83 c2 01             	add    $0x1,%edx
  800907:	84 c9                	test   %cl,%cl
  800909:	75 f2                	jne    8008fd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80090b:	5b                   	pop    %ebx
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	83 ec 10             	sub    $0x10,%esp
  800915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800918:	53                   	push   %ebx
  800919:	e8 97 ff ff ff       	call   8008b5 <strlen>
  80091e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	01 d8                	add    %ebx,%eax
  800926:	50                   	push   %eax
  800927:	e8 c2 ff ff ff       	call   8008ee <strcpy>
	return dst;
}
  80092c:	89 d8                	mov    %ebx,%eax
  80092e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	56                   	push   %esi
  800937:	53                   	push   %ebx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093e:	89 c6                	mov    %eax,%esi
  800940:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800943:	89 c2                	mov    %eax,%edx
  800945:	39 f2                	cmp    %esi,%edx
  800947:	74 11                	je     80095a <strncpy+0x27>
		*dst++ = *src;
  800949:	83 c2 01             	add    $0x1,%edx
  80094c:	0f b6 19             	movzbl (%ecx),%ebx
  80094f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800952:	80 fb 01             	cmp    $0x1,%bl
  800955:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800958:	eb eb                	jmp    800945 <strncpy+0x12>
	}
	return ret;
}
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	56                   	push   %esi
  800962:	53                   	push   %ebx
  800963:	8b 75 08             	mov    0x8(%ebp),%esi
  800966:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800969:	8b 55 10             	mov    0x10(%ebp),%edx
  80096c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096e:	85 d2                	test   %edx,%edx
  800970:	74 21                	je     800993 <strlcpy+0x35>
  800972:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800976:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800978:	39 c2                	cmp    %eax,%edx
  80097a:	74 14                	je     800990 <strlcpy+0x32>
  80097c:	0f b6 19             	movzbl (%ecx),%ebx
  80097f:	84 db                	test   %bl,%bl
  800981:	74 0b                	je     80098e <strlcpy+0x30>
			*dst++ = *src++;
  800983:	83 c1 01             	add    $0x1,%ecx
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	88 5a ff             	mov    %bl,-0x1(%edx)
  80098c:	eb ea                	jmp    800978 <strlcpy+0x1a>
  80098e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800990:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800993:	29 f0                	sub    %esi,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a2:	0f b6 01             	movzbl (%ecx),%eax
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 0c                	je     8009b5 <strcmp+0x1c>
  8009a9:	3a 02                	cmp    (%edx),%al
  8009ab:	75 08                	jne    8009b5 <strcmp+0x1c>
		p++, q++;
  8009ad:	83 c1 01             	add    $0x1,%ecx
  8009b0:	83 c2 01             	add    $0x1,%edx
  8009b3:	eb ed                	jmp    8009a2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b5:	0f b6 c0             	movzbl %al,%eax
  8009b8:	0f b6 12             	movzbl (%edx),%edx
  8009bb:	29 d0                	sub    %edx,%eax
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c9:	89 c3                	mov    %eax,%ebx
  8009cb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ce:	eb 06                	jmp    8009d6 <strncmp+0x17>
		n--, p++, q++;
  8009d0:	83 c0 01             	add    $0x1,%eax
  8009d3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d6:	39 d8                	cmp    %ebx,%eax
  8009d8:	74 16                	je     8009f0 <strncmp+0x31>
  8009da:	0f b6 08             	movzbl (%eax),%ecx
  8009dd:	84 c9                	test   %cl,%cl
  8009df:	74 04                	je     8009e5 <strncmp+0x26>
  8009e1:	3a 0a                	cmp    (%edx),%cl
  8009e3:	74 eb                	je     8009d0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e5:	0f b6 00             	movzbl (%eax),%eax
  8009e8:	0f b6 12             	movzbl (%edx),%edx
  8009eb:	29 d0                	sub    %edx,%eax
}
  8009ed:	5b                   	pop    %ebx
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    
		return 0;
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f5:	eb f6                	jmp    8009ed <strncmp+0x2e>

008009f7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a01:	0f b6 10             	movzbl (%eax),%edx
  800a04:	84 d2                	test   %dl,%dl
  800a06:	74 09                	je     800a11 <strchr+0x1a>
		if (*s == c)
  800a08:	38 ca                	cmp    %cl,%dl
  800a0a:	74 0a                	je     800a16 <strchr+0x1f>
	for (; *s; s++)
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	eb f0                	jmp    800a01 <strchr+0xa>
			return (char *) s;
	return 0;
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a22:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a25:	38 ca                	cmp    %cl,%dl
  800a27:	74 09                	je     800a32 <strfind+0x1a>
  800a29:	84 d2                	test   %dl,%dl
  800a2b:	74 05                	je     800a32 <strfind+0x1a>
	for (; *s; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	eb f0                	jmp    800a22 <strfind+0xa>
			break;
	return (char *) s;
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a40:	85 c9                	test   %ecx,%ecx
  800a42:	74 31                	je     800a75 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a44:	89 f8                	mov    %edi,%eax
  800a46:	09 c8                	or     %ecx,%eax
  800a48:	a8 03                	test   $0x3,%al
  800a4a:	75 23                	jne    800a6f <memset+0x3b>
		c &= 0xFF;
  800a4c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a50:	89 d3                	mov    %edx,%ebx
  800a52:	c1 e3 08             	shl    $0x8,%ebx
  800a55:	89 d0                	mov    %edx,%eax
  800a57:	c1 e0 18             	shl    $0x18,%eax
  800a5a:	89 d6                	mov    %edx,%esi
  800a5c:	c1 e6 10             	shl    $0x10,%esi
  800a5f:	09 f0                	or     %esi,%eax
  800a61:	09 c2                	or     %eax,%edx
  800a63:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a65:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a6d:	eb 06                	jmp    800a75 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	fc                   	cld    
  800a73:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a75:	89 f8                	mov    %edi,%eax
  800a77:	5b                   	pop    %ebx
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a8a:	39 c6                	cmp    %eax,%esi
  800a8c:	73 32                	jae    800ac0 <memmove+0x44>
  800a8e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a91:	39 c2                	cmp    %eax,%edx
  800a93:	76 2b                	jbe    800ac0 <memmove+0x44>
		s += n;
		d += n;
  800a95:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a98:	89 fe                	mov    %edi,%esi
  800a9a:	09 ce                	or     %ecx,%esi
  800a9c:	09 d6                	or     %edx,%esi
  800a9e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa4:	75 0e                	jne    800ab4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa6:	83 ef 04             	sub    $0x4,%edi
  800aa9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aaf:	fd                   	std    
  800ab0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab2:	eb 09                	jmp    800abd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab4:	83 ef 01             	sub    $0x1,%edi
  800ab7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aba:	fd                   	std    
  800abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abd:	fc                   	cld    
  800abe:	eb 1a                	jmp    800ada <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	09 ca                	or     %ecx,%edx
  800ac4:	09 f2                	or     %esi,%edx
  800ac6:	f6 c2 03             	test   $0x3,%dl
  800ac9:	75 0a                	jne    800ad5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800acb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	fc                   	cld    
  800ad1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad3:	eb 05                	jmp    800ada <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad5:	89 c7                	mov    %eax,%edi
  800ad7:	fc                   	cld    
  800ad8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae4:	ff 75 10             	pushl  0x10(%ebp)
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	ff 75 08             	pushl  0x8(%ebp)
  800aed:	e8 8a ff ff ff       	call   800a7c <memmove>
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aff:	89 c6                	mov    %eax,%esi
  800b01:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b04:	39 f0                	cmp    %esi,%eax
  800b06:	74 1c                	je     800b24 <memcmp+0x30>
		if (*s1 != *s2)
  800b08:	0f b6 08             	movzbl (%eax),%ecx
  800b0b:	0f b6 1a             	movzbl (%edx),%ebx
  800b0e:	38 d9                	cmp    %bl,%cl
  800b10:	75 08                	jne    800b1a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b12:	83 c0 01             	add    $0x1,%eax
  800b15:	83 c2 01             	add    $0x1,%edx
  800b18:	eb ea                	jmp    800b04 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b1a:	0f b6 c1             	movzbl %cl,%eax
  800b1d:	0f b6 db             	movzbl %bl,%ebx
  800b20:	29 d8                	sub    %ebx,%eax
  800b22:	eb 05                	jmp    800b29 <memcmp+0x35>
	}

	return 0;
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b29:	5b                   	pop    %ebx
  800b2a:	5e                   	pop    %esi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b36:	89 c2                	mov    %eax,%edx
  800b38:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3b:	39 d0                	cmp    %edx,%eax
  800b3d:	73 09                	jae    800b48 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3f:	38 08                	cmp    %cl,(%eax)
  800b41:	74 05                	je     800b48 <memfind+0x1b>
	for (; s < ends; s++)
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	eb f3                	jmp    800b3b <memfind+0xe>
			break;
	return (void *) s;
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	57                   	push   %edi
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
  800b50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b56:	eb 03                	jmp    800b5b <strtol+0x11>
		s++;
  800b58:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b5b:	0f b6 01             	movzbl (%ecx),%eax
  800b5e:	3c 20                	cmp    $0x20,%al
  800b60:	74 f6                	je     800b58 <strtol+0xe>
  800b62:	3c 09                	cmp    $0x9,%al
  800b64:	74 f2                	je     800b58 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b66:	3c 2b                	cmp    $0x2b,%al
  800b68:	74 2a                	je     800b94 <strtol+0x4a>
	int neg = 0;
  800b6a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6f:	3c 2d                	cmp    $0x2d,%al
  800b71:	74 2b                	je     800b9e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b73:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b79:	75 0f                	jne    800b8a <strtol+0x40>
  800b7b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7e:	74 28                	je     800ba8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b80:	85 db                	test   %ebx,%ebx
  800b82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b87:	0f 44 d8             	cmove  %eax,%ebx
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b92:	eb 50                	jmp    800be4 <strtol+0x9a>
		s++;
  800b94:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b97:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9c:	eb d5                	jmp    800b73 <strtol+0x29>
		s++, neg = 1;
  800b9e:	83 c1 01             	add    $0x1,%ecx
  800ba1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba6:	eb cb                	jmp    800b73 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bac:	74 0e                	je     800bbc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bae:	85 db                	test   %ebx,%ebx
  800bb0:	75 d8                	jne    800b8a <strtol+0x40>
		s++, base = 8;
  800bb2:	83 c1 01             	add    $0x1,%ecx
  800bb5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bba:	eb ce                	jmp    800b8a <strtol+0x40>
		s += 2, base = 16;
  800bbc:	83 c1 02             	add    $0x2,%ecx
  800bbf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc4:	eb c4                	jmp    800b8a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 29                	ja     800bf9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd9:	7d 30                	jge    800c0b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bdb:	83 c1 01             	add    $0x1,%ecx
  800bde:	0f af 45 10          	imul   0x10(%ebp),%eax
  800be2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800be4:	0f b6 11             	movzbl (%ecx),%edx
  800be7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bea:	89 f3                	mov    %esi,%ebx
  800bec:	80 fb 09             	cmp    $0x9,%bl
  800bef:	77 d5                	ja     800bc6 <strtol+0x7c>
			dig = *s - '0';
  800bf1:	0f be d2             	movsbl %dl,%edx
  800bf4:	83 ea 30             	sub    $0x30,%edx
  800bf7:	eb dd                	jmp    800bd6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bfc:	89 f3                	mov    %esi,%ebx
  800bfe:	80 fb 19             	cmp    $0x19,%bl
  800c01:	77 08                	ja     800c0b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c03:	0f be d2             	movsbl %dl,%edx
  800c06:	83 ea 37             	sub    $0x37,%edx
  800c09:	eb cb                	jmp    800bd6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0f:	74 05                	je     800c16 <strtol+0xcc>
		*endptr = (char *) s;
  800c11:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c14:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c16:	89 c2                	mov    %eax,%edx
  800c18:	f7 da                	neg    %edx
  800c1a:	85 ff                	test   %edi,%edi
  800c1c:	0f 45 c2             	cmovne %edx,%eax
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c35:	89 c3                	mov    %eax,%ebx
  800c37:	89 c7                	mov    %eax,%edi
  800c39:	89 c6                	mov    %eax,%esi
  800c3b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c48:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c52:	89 d1                	mov    %edx,%ecx
  800c54:	89 d3                	mov    %edx,%ebx
  800c56:	89 d7                	mov    %edx,%edi
  800c58:	89 d6                	mov    %edx,%esi
  800c5a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c72:	b8 03 00 00 00       	mov    $0x3,%eax
  800c77:	89 cb                	mov    %ecx,%ebx
  800c79:	89 cf                	mov    %ecx,%edi
  800c7b:	89 ce                	mov    %ecx,%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 03                	push   $0x3
  800c91:	68 a4 28 80 00       	push   $0x8028a4
  800c96:	6a 43                	push   $0x43
  800c98:	68 c1 28 80 00       	push   $0x8028c1
  800c9d:	e8 69 14 00 00       	call   80210b <_panic>

00800ca2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cad:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb2:	89 d1                	mov    %edx,%ecx
  800cb4:	89 d3                	mov    %edx,%ebx
  800cb6:	89 d7                	mov    %edx,%edi
  800cb8:	89 d6                	mov    %edx,%esi
  800cba:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_yield>:

void
sys_yield(void)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd1:	89 d1                	mov    %edx,%ecx
  800cd3:	89 d3                	mov    %edx,%ebx
  800cd5:	89 d7                	mov    %edx,%edi
  800cd7:	89 d6                	mov    %edx,%esi
  800cd9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce9:	be 00 00 00 00       	mov    $0x0,%esi
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfc:	89 f7                	mov    %esi,%edi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 04                	push   $0x4
  800d12:	68 a4 28 80 00       	push   $0x8028a4
  800d17:	6a 43                	push   $0x43
  800d19:	68 c1 28 80 00       	push   $0x8028c1
  800d1e:	e8 e8 13 00 00       	call   80210b <_panic>

00800d23 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 05 00 00 00       	mov    $0x5,%eax
  800d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	7f 08                	jg     800d4e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4e:	83 ec 0c             	sub    $0xc,%esp
  800d51:	50                   	push   %eax
  800d52:	6a 05                	push   $0x5
  800d54:	68 a4 28 80 00       	push   $0x8028a4
  800d59:	6a 43                	push   $0x43
  800d5b:	68 c1 28 80 00       	push   $0x8028c1
  800d60:	e8 a6 13 00 00       	call   80210b <_panic>

00800d65 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7e:	89 df                	mov    %ebx,%edi
  800d80:	89 de                	mov    %ebx,%esi
  800d82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	7f 08                	jg     800d90 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d90:	83 ec 0c             	sub    $0xc,%esp
  800d93:	50                   	push   %eax
  800d94:	6a 06                	push   $0x6
  800d96:	68 a4 28 80 00       	push   $0x8028a4
  800d9b:	6a 43                	push   $0x43
  800d9d:	68 c1 28 80 00       	push   $0x8028c1
  800da2:	e8 64 13 00 00       	call   80210b <_panic>

00800da7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	89 df                	mov    %ebx,%edi
  800dc2:	89 de                	mov    %ebx,%esi
  800dc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7f 08                	jg     800dd2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	50                   	push   %eax
  800dd6:	6a 08                	push   $0x8
  800dd8:	68 a4 28 80 00       	push   $0x8028a4
  800ddd:	6a 43                	push   $0x43
  800ddf:	68 c1 28 80 00       	push   $0x8028c1
  800de4:	e8 22 13 00 00       	call   80210b <_panic>

00800de9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfd:	b8 09 00 00 00       	mov    $0x9,%eax
  800e02:	89 df                	mov    %ebx,%edi
  800e04:	89 de                	mov    %ebx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 09                	push   $0x9
  800e1a:	68 a4 28 80 00       	push   $0x8028a4
  800e1f:	6a 43                	push   $0x43
  800e21:	68 c1 28 80 00       	push   $0x8028c1
  800e26:	e8 e0 12 00 00       	call   80210b <_panic>

00800e2b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e44:	89 df                	mov    %ebx,%edi
  800e46:	89 de                	mov    %ebx,%esi
  800e48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	7f 08                	jg     800e56 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	6a 0a                	push   $0xa
  800e5c:	68 a4 28 80 00       	push   $0x8028a4
  800e61:	6a 43                	push   $0x43
  800e63:	68 c1 28 80 00       	push   $0x8028c1
  800e68:	e8 9e 12 00 00       	call   80210b <_panic>

00800e6d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e89:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e99:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea6:	89 cb                	mov    %ecx,%ebx
  800ea8:	89 cf                	mov    %ecx,%edi
  800eaa:	89 ce                	mov    %ecx,%esi
  800eac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7f 08                	jg     800eba <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	50                   	push   %eax
  800ebe:	6a 0d                	push   $0xd
  800ec0:	68 a4 28 80 00       	push   $0x8028a4
  800ec5:	6a 43                	push   $0x43
  800ec7:	68 c1 28 80 00       	push   $0x8028c1
  800ecc:	e8 3a 12 00 00       	call   80210b <_panic>

00800ed1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ee7:	89 df                	mov    %ebx,%edi
  800ee9:	89 de                	mov    %ebx,%esi
  800eeb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f05:	89 cb                	mov    %ecx,%ebx
  800f07:	89 cf                	mov    %ecx,%edi
  800f09:	89 ce                	mov    %ecx,%esi
  800f0b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f22:	89 d1                	mov    %edx,%ecx
  800f24:	89 d3                	mov    %edx,%ebx
  800f26:	89 d7                	mov    %edx,%edi
  800f28:	89 d6                	mov    %edx,%esi
  800f2a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	b8 11 00 00 00       	mov    $0x11,%eax
  800f47:	89 df                	mov    %ebx,%edi
  800f49:	89 de                	mov    %ebx,%esi
  800f4b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	b8 12 00 00 00       	mov    $0x12,%eax
  800f68:	89 df                	mov    %ebx,%edi
  800f6a:	89 de                	mov    %ebx,%esi
  800f6c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 13 00 00 00       	mov    $0x13,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7f 08                	jg     800f9e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	50                   	push   %eax
  800fa2:	6a 13                	push   $0x13
  800fa4:	68 a4 28 80 00       	push   $0x8028a4
  800fa9:	6a 43                	push   $0x43
  800fab:	68 c1 28 80 00       	push   $0x8028c1
  800fb0:	e8 56 11 00 00       	call   80210b <_panic>

00800fb5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	c1 ea 16             	shr    $0x16,%edx
  800fe9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff0:	f6 c2 01             	test   $0x1,%dl
  800ff3:	74 2d                	je     801022 <fd_alloc+0x46>
  800ff5:	89 c2                	mov    %eax,%edx
  800ff7:	c1 ea 0c             	shr    $0xc,%edx
  800ffa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801001:	f6 c2 01             	test   $0x1,%dl
  801004:	74 1c                	je     801022 <fd_alloc+0x46>
  801006:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801010:	75 d2                	jne    800fe4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80101b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801020:	eb 0a                	jmp    80102c <fd_alloc+0x50>
			*fd_store = fd;
  801022:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801025:	89 01                	mov    %eax,(%ecx)
			return 0;
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801034:	83 f8 1f             	cmp    $0x1f,%eax
  801037:	77 30                	ja     801069 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801039:	c1 e0 0c             	shl    $0xc,%eax
  80103c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801041:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801047:	f6 c2 01             	test   $0x1,%dl
  80104a:	74 24                	je     801070 <fd_lookup+0x42>
  80104c:	89 c2                	mov    %eax,%edx
  80104e:	c1 ea 0c             	shr    $0xc,%edx
  801051:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801058:	f6 c2 01             	test   $0x1,%dl
  80105b:	74 1a                	je     801077 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80105d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801060:	89 02                	mov    %eax,(%edx)
	return 0;
  801062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    
		return -E_INVAL;
  801069:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106e:	eb f7                	jmp    801067 <fd_lookup+0x39>
		return -E_INVAL;
  801070:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801075:	eb f0                	jmp    801067 <fd_lookup+0x39>
  801077:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107c:	eb e9                	jmp    801067 <fd_lookup+0x39>

0080107e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801087:	ba 00 00 00 00       	mov    $0x0,%edx
  80108c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801091:	39 08                	cmp    %ecx,(%eax)
  801093:	74 38                	je     8010cd <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801095:	83 c2 01             	add    $0x1,%edx
  801098:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 ee                	jne    801091 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a8:	8b 40 48             	mov    0x48(%eax),%eax
  8010ab:	83 ec 04             	sub    $0x4,%esp
  8010ae:	51                   	push   %ecx
  8010af:	50                   	push   %eax
  8010b0:	68 d0 28 80 00       	push   $0x8028d0
  8010b5:	e8 d5 f0 ff ff       	call   80018f <cprintf>
	*dev = 0;
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    
			*dev = devtab[i];
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d7:	eb f2                	jmp    8010cb <dev_lookup+0x4d>

008010d9 <fd_close>:
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 24             	sub    $0x24,%esp
  8010e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010eb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ec:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f5:	50                   	push   %eax
  8010f6:	e8 33 ff ff ff       	call   80102e <fd_lookup>
  8010fb:	89 c3                	mov    %eax,%ebx
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 05                	js     801109 <fd_close+0x30>
	    || fd != fd2)
  801104:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801107:	74 16                	je     80111f <fd_close+0x46>
		return (must_exist ? r : 0);
  801109:	89 f8                	mov    %edi,%eax
  80110b:	84 c0                	test   %al,%al
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
  801112:	0f 44 d8             	cmove  %eax,%ebx
}
  801115:	89 d8                	mov    %ebx,%eax
  801117:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801125:	50                   	push   %eax
  801126:	ff 36                	pushl  (%esi)
  801128:	e8 51 ff ff ff       	call   80107e <dev_lookup>
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 1a                	js     801150 <fd_close+0x77>
		if (dev->dev_close)
  801136:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801139:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80113c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801141:	85 c0                	test   %eax,%eax
  801143:	74 0b                	je     801150 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	56                   	push   %esi
  801149:	ff d0                	call   *%eax
  80114b:	89 c3                	mov    %eax,%ebx
  80114d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	56                   	push   %esi
  801154:	6a 00                	push   $0x0
  801156:	e8 0a fc ff ff       	call   800d65 <sys_page_unmap>
	return r;
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	eb b5                	jmp    801115 <fd_close+0x3c>

00801160 <close>:

int
close(int fdnum)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801166:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 bc fe ff ff       	call   80102e <fd_lookup>
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	79 02                	jns    80117b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    
		return fd_close(fd, 1);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	6a 01                	push   $0x1
  801180:	ff 75 f4             	pushl  -0xc(%ebp)
  801183:	e8 51 ff ff ff       	call   8010d9 <fd_close>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	eb ec                	jmp    801179 <close+0x19>

0080118d <close_all>:

void
close_all(void)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	53                   	push   %ebx
  801191:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801194:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	53                   	push   %ebx
  80119d:	e8 be ff ff ff       	call   801160 <close>
	for (i = 0; i < MAXFD; i++)
  8011a2:	83 c3 01             	add    $0x1,%ebx
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	83 fb 20             	cmp    $0x20,%ebx
  8011ab:	75 ec                	jne    801199 <close_all+0xc>
}
  8011ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011be:	50                   	push   %eax
  8011bf:	ff 75 08             	pushl  0x8(%ebp)
  8011c2:	e8 67 fe ff ff       	call   80102e <fd_lookup>
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	0f 88 81 00 00 00    	js     801255 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	e8 81 ff ff ff       	call   801160 <close>

	newfd = INDEX2FD(newfdnum);
  8011df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e2:	c1 e6 0c             	shl    $0xc,%esi
  8011e5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011eb:	83 c4 04             	add    $0x4,%esp
  8011ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f1:	e8 cf fd ff ff       	call   800fc5 <fd2data>
  8011f6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f8:	89 34 24             	mov    %esi,(%esp)
  8011fb:	e8 c5 fd ff ff       	call   800fc5 <fd2data>
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801205:	89 d8                	mov    %ebx,%eax
  801207:	c1 e8 16             	shr    $0x16,%eax
  80120a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801211:	a8 01                	test   $0x1,%al
  801213:	74 11                	je     801226 <dup+0x74>
  801215:	89 d8                	mov    %ebx,%eax
  801217:	c1 e8 0c             	shr    $0xc,%eax
  80121a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801221:	f6 c2 01             	test   $0x1,%dl
  801224:	75 39                	jne    80125f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801226:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801229:	89 d0                	mov    %edx,%eax
  80122b:	c1 e8 0c             	shr    $0xc,%eax
  80122e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	25 07 0e 00 00       	and    $0xe07,%eax
  80123d:	50                   	push   %eax
  80123e:	56                   	push   %esi
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	6a 00                	push   $0x0
  801244:	e8 da fa ff ff       	call   800d23 <sys_page_map>
  801249:	89 c3                	mov    %eax,%ebx
  80124b:	83 c4 20             	add    $0x20,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 31                	js     801283 <dup+0xd1>
		goto err;

	return newfdnum;
  801252:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801255:	89 d8                	mov    %ebx,%eax
  801257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	25 07 0e 00 00       	and    $0xe07,%eax
  80126e:	50                   	push   %eax
  80126f:	57                   	push   %edi
  801270:	6a 00                	push   $0x0
  801272:	53                   	push   %ebx
  801273:	6a 00                	push   $0x0
  801275:	e8 a9 fa ff ff       	call   800d23 <sys_page_map>
  80127a:	89 c3                	mov    %eax,%ebx
  80127c:	83 c4 20             	add    $0x20,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 a3                	jns    801226 <dup+0x74>
	sys_page_unmap(0, newfd);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	56                   	push   %esi
  801287:	6a 00                	push   $0x0
  801289:	e8 d7 fa ff ff       	call   800d65 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128e:	83 c4 08             	add    $0x8,%esp
  801291:	57                   	push   %edi
  801292:	6a 00                	push   $0x0
  801294:	e8 cc fa ff ff       	call   800d65 <sys_page_unmap>
	return r;
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	eb b7                	jmp    801255 <dup+0xa3>

0080129e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 1c             	sub    $0x1c,%esp
  8012a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	53                   	push   %ebx
  8012ad:	e8 7c fd ff ff       	call   80102e <fd_lookup>
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 3f                	js     8012f8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bf:	50                   	push   %eax
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c3:	ff 30                	pushl  (%eax)
  8012c5:	e8 b4 fd ff ff       	call   80107e <dev_lookup>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 27                	js     8012f8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d4:	8b 42 08             	mov    0x8(%edx),%eax
  8012d7:	83 e0 03             	and    $0x3,%eax
  8012da:	83 f8 01             	cmp    $0x1,%eax
  8012dd:	74 1e                	je     8012fd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e2:	8b 40 08             	mov    0x8(%eax),%eax
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	74 35                	je     80131e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	ff 75 10             	pushl  0x10(%ebp)
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	52                   	push   %edx
  8012f3:	ff d0                	call   *%eax
  8012f5:	83 c4 10             	add    $0x10,%esp
}
  8012f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012fd:	a1 08 40 80 00       	mov    0x804008,%eax
  801302:	8b 40 48             	mov    0x48(%eax),%eax
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	53                   	push   %ebx
  801309:	50                   	push   %eax
  80130a:	68 11 29 80 00       	push   $0x802911
  80130f:	e8 7b ee ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131c:	eb da                	jmp    8012f8 <read+0x5a>
		return -E_NOT_SUPP;
  80131e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801323:	eb d3                	jmp    8012f8 <read+0x5a>

00801325 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	57                   	push   %edi
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801331:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801334:	bb 00 00 00 00       	mov    $0x0,%ebx
  801339:	39 f3                	cmp    %esi,%ebx
  80133b:	73 23                	jae    801360 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	89 f0                	mov    %esi,%eax
  801342:	29 d8                	sub    %ebx,%eax
  801344:	50                   	push   %eax
  801345:	89 d8                	mov    %ebx,%eax
  801347:	03 45 0c             	add    0xc(%ebp),%eax
  80134a:	50                   	push   %eax
  80134b:	57                   	push   %edi
  80134c:	e8 4d ff ff ff       	call   80129e <read>
		if (m < 0)
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 06                	js     80135e <readn+0x39>
			return m;
		if (m == 0)
  801358:	74 06                	je     801360 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80135a:	01 c3                	add    %eax,%ebx
  80135c:	eb db                	jmp    801339 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801360:	89 d8                	mov    %ebx,%eax
  801362:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 1c             	sub    $0x1c,%esp
  801371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	53                   	push   %ebx
  801379:	e8 b0 fc ff ff       	call   80102e <fd_lookup>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	78 3a                	js     8013bf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801385:	83 ec 08             	sub    $0x8,%esp
  801388:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138f:	ff 30                	pushl  (%eax)
  801391:	e8 e8 fc ff ff       	call   80107e <dev_lookup>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 22                	js     8013bf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a4:	74 1e                	je     8013c4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	74 35                	je     8013e5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	ff 75 10             	pushl  0x10(%ebp)
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	50                   	push   %eax
  8013ba:	ff d2                	call   *%edx
  8013bc:	83 c4 10             	add    $0x10,%esp
}
  8013bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c9:	8b 40 48             	mov    0x48(%eax),%eax
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	53                   	push   %ebx
  8013d0:	50                   	push   %eax
  8013d1:	68 2d 29 80 00       	push   $0x80292d
  8013d6:	e8 b4 ed ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e3:	eb da                	jmp    8013bf <write+0x55>
		return -E_NOT_SUPP;
  8013e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ea:	eb d3                	jmp    8013bf <write+0x55>

008013ec <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	e8 30 fc ff ff       	call   80102e <fd_lookup>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 0e                	js     801413 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801405:	8b 55 0c             	mov    0xc(%ebp),%edx
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	53                   	push   %ebx
  801419:	83 ec 1c             	sub    $0x1c,%esp
  80141c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	53                   	push   %ebx
  801424:	e8 05 fc ff ff       	call   80102e <fd_lookup>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 37                	js     801467 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801436:	50                   	push   %eax
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	ff 30                	pushl  (%eax)
  80143c:	e8 3d fc ff ff       	call   80107e <dev_lookup>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 1f                	js     801467 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80144f:	74 1b                	je     80146c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801454:	8b 52 18             	mov    0x18(%edx),%edx
  801457:	85 d2                	test   %edx,%edx
  801459:	74 32                	je     80148d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	ff d2                	call   *%edx
  801464:	83 c4 10             	add    $0x10,%esp
}
  801467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80146c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801471:	8b 40 48             	mov    0x48(%eax),%eax
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	53                   	push   %ebx
  801478:	50                   	push   %eax
  801479:	68 f0 28 80 00       	push   $0x8028f0
  80147e:	e8 0c ed ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148b:	eb da                	jmp    801467 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80148d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801492:	eb d3                	jmp    801467 <ftruncate+0x52>

00801494 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	53                   	push   %ebx
  801498:	83 ec 1c             	sub    $0x1c,%esp
  80149b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	e8 84 fb ff ff       	call   80102e <fd_lookup>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 4b                	js     8014fc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	ff 30                	pushl  (%eax)
  8014bd:	e8 bc fb ff ff       	call   80107e <dev_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 33                	js     8014fc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d0:	74 2f                	je     801501 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014dc:	00 00 00 
	stat->st_isdir = 0;
  8014df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e6:	00 00 00 
	stat->st_dev = dev;
  8014e9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	53                   	push   %ebx
  8014f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f6:	ff 50 14             	call   *0x14(%eax)
  8014f9:	83 c4 10             	add    $0x10,%esp
}
  8014fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    
		return -E_NOT_SUPP;
  801501:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801506:	eb f4                	jmp    8014fc <fstat+0x68>

00801508 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	56                   	push   %esi
  80150c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	6a 00                	push   $0x0
  801512:	ff 75 08             	pushl  0x8(%ebp)
  801515:	e8 22 02 00 00       	call   80173c <open>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 1b                	js     80153e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	50                   	push   %eax
  80152a:	e8 65 ff ff ff       	call   801494 <fstat>
  80152f:	89 c6                	mov    %eax,%esi
	close(fd);
  801531:	89 1c 24             	mov    %ebx,(%esp)
  801534:	e8 27 fc ff ff       	call   801160 <close>
	return r;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	89 f3                	mov    %esi,%ebx
}
  80153e:	89 d8                	mov    %ebx,%eax
  801540:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	56                   	push   %esi
  80154b:	53                   	push   %ebx
  80154c:	89 c6                	mov    %eax,%esi
  80154e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801550:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801557:	74 27                	je     801580 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801559:	6a 07                	push   $0x7
  80155b:	68 00 50 80 00       	push   $0x805000
  801560:	56                   	push   %esi
  801561:	ff 35 00 40 80 00    	pushl  0x804000
  801567:	e8 69 0c 00 00       	call   8021d5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156c:	83 c4 0c             	add    $0xc,%esp
  80156f:	6a 00                	push   $0x0
  801571:	53                   	push   %ebx
  801572:	6a 00                	push   $0x0
  801574:	e8 f3 0b 00 00       	call   80216c <ipc_recv>
}
  801579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	6a 01                	push   $0x1
  801585:	e8 a3 0c 00 00       	call   80222d <ipc_find_env>
  80158a:	a3 00 40 80 00       	mov    %eax,0x804000
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	eb c5                	jmp    801559 <fsipc+0x12>

00801594 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b7:	e8 8b ff ff ff       	call   801547 <fsipc>
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <devfile_flush>:
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ca:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d9:	e8 69 ff ff ff       	call   801547 <fsipc>
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <devfile_stat>:
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ff:	e8 43 ff ff ff       	call   801547 <fsipc>
  801604:	85 c0                	test   %eax,%eax
  801606:	78 2c                	js     801634 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	68 00 50 80 00       	push   $0x805000
  801610:	53                   	push   %ebx
  801611:	e8 d8 f2 ff ff       	call   8008ee <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801616:	a1 80 50 80 00       	mov    0x805080,%eax
  80161b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801621:	a1 84 50 80 00       	mov    0x805084,%eax
  801626:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <devfile_write>:
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	53                   	push   %ebx
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8b 40 0c             	mov    0xc(%eax),%eax
  801649:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80164e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801654:	53                   	push   %ebx
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	68 08 50 80 00       	push   $0x805008
  80165d:	e8 7c f4 ff ff       	call   800ade <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 04 00 00 00       	mov    $0x4,%eax
  80166c:	e8 d6 fe ff ff       	call   801547 <fsipc>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 0b                	js     801683 <devfile_write+0x4a>
	assert(r <= n);
  801678:	39 d8                	cmp    %ebx,%eax
  80167a:	77 0c                	ja     801688 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80167c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801681:	7f 1e                	jg     8016a1 <devfile_write+0x68>
}
  801683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801686:	c9                   	leave  
  801687:	c3                   	ret    
	assert(r <= n);
  801688:	68 60 29 80 00       	push   $0x802960
  80168d:	68 67 29 80 00       	push   $0x802967
  801692:	68 98 00 00 00       	push   $0x98
  801697:	68 7c 29 80 00       	push   $0x80297c
  80169c:	e8 6a 0a 00 00       	call   80210b <_panic>
	assert(r <= PGSIZE);
  8016a1:	68 87 29 80 00       	push   $0x802987
  8016a6:	68 67 29 80 00       	push   $0x802967
  8016ab:	68 99 00 00 00       	push   $0x99
  8016b0:	68 7c 29 80 00       	push   $0x80297c
  8016b5:	e8 51 0a 00 00       	call   80210b <_panic>

008016ba <devfile_read>:
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
  8016bf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016cd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	b8 03 00 00 00       	mov    $0x3,%eax
  8016dd:	e8 65 fe ff ff       	call   801547 <fsipc>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 1f                	js     801707 <devfile_read+0x4d>
	assert(r <= n);
  8016e8:	39 f0                	cmp    %esi,%eax
  8016ea:	77 24                	ja     801710 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016ec:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f1:	7f 33                	jg     801726 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	50                   	push   %eax
  8016f7:	68 00 50 80 00       	push   $0x805000
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	e8 78 f3 ff ff       	call   800a7c <memmove>
	return r;
  801704:	83 c4 10             	add    $0x10,%esp
}
  801707:	89 d8                	mov    %ebx,%eax
  801709:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170c:	5b                   	pop    %ebx
  80170d:	5e                   	pop    %esi
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    
	assert(r <= n);
  801710:	68 60 29 80 00       	push   $0x802960
  801715:	68 67 29 80 00       	push   $0x802967
  80171a:	6a 7c                	push   $0x7c
  80171c:	68 7c 29 80 00       	push   $0x80297c
  801721:	e8 e5 09 00 00       	call   80210b <_panic>
	assert(r <= PGSIZE);
  801726:	68 87 29 80 00       	push   $0x802987
  80172b:	68 67 29 80 00       	push   $0x802967
  801730:	6a 7d                	push   $0x7d
  801732:	68 7c 29 80 00       	push   $0x80297c
  801737:	e8 cf 09 00 00       	call   80210b <_panic>

0080173c <open>:
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	83 ec 1c             	sub    $0x1c,%esp
  801744:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801747:	56                   	push   %esi
  801748:	e8 68 f1 ff ff       	call   8008b5 <strlen>
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801755:	7f 6c                	jg     8017c3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175d:	50                   	push   %eax
  80175e:	e8 79 f8 ff ff       	call   800fdc <fd_alloc>
  801763:	89 c3                	mov    %eax,%ebx
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 3c                	js     8017a8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	56                   	push   %esi
  801770:	68 00 50 80 00       	push   $0x805000
  801775:	e8 74 f1 ff ff       	call   8008ee <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801785:	b8 01 00 00 00       	mov    $0x1,%eax
  80178a:	e8 b8 fd ff ff       	call   801547 <fsipc>
  80178f:	89 c3                	mov    %eax,%ebx
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	85 c0                	test   %eax,%eax
  801796:	78 19                	js     8017b1 <open+0x75>
	return fd2num(fd);
  801798:	83 ec 0c             	sub    $0xc,%esp
  80179b:	ff 75 f4             	pushl  -0xc(%ebp)
  80179e:	e8 12 f8 ff ff       	call   800fb5 <fd2num>
  8017a3:	89 c3                	mov    %eax,%ebx
  8017a5:	83 c4 10             	add    $0x10,%esp
}
  8017a8:	89 d8                	mov    %ebx,%eax
  8017aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5e                   	pop    %esi
  8017af:	5d                   	pop    %ebp
  8017b0:	c3                   	ret    
		fd_close(fd, 0);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	6a 00                	push   $0x0
  8017b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b9:	e8 1b f9 ff ff       	call   8010d9 <fd_close>
		return r;
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	eb e5                	jmp    8017a8 <open+0x6c>
		return -E_BAD_PATH;
  8017c3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c8:	eb de                	jmp    8017a8 <open+0x6c>

008017ca <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8017da:	e8 68 fd ff ff       	call   801547 <fsipc>
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017e7:	68 93 29 80 00       	push   $0x802993
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	e8 fa f0 ff ff       	call   8008ee <strcpy>
	return 0;
}
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <devsock_close>:
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 10             	sub    $0x10,%esp
  801802:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801805:	53                   	push   %ebx
  801806:	e8 5d 0a 00 00       	call   802268 <pageref>
  80180b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801813:	83 f8 01             	cmp    $0x1,%eax
  801816:	74 07                	je     80181f <devsock_close+0x24>
}
  801818:	89 d0                	mov    %edx,%eax
  80181a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	ff 73 0c             	pushl  0xc(%ebx)
  801825:	e8 b9 02 00 00       	call   801ae3 <nsipc_close>
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	eb e7                	jmp    801818 <devsock_close+0x1d>

00801831 <devsock_write>:
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801837:	6a 00                	push   $0x0
  801839:	ff 75 10             	pushl  0x10(%ebp)
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	ff 70 0c             	pushl  0xc(%eax)
  801845:	e8 76 03 00 00       	call   801bc0 <nsipc_send>
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <devsock_read>:
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801852:	6a 00                	push   $0x0
  801854:	ff 75 10             	pushl  0x10(%ebp)
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	ff 70 0c             	pushl  0xc(%eax)
  801860:	e8 ef 02 00 00       	call   801b54 <nsipc_recv>
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <fd2sockid>:
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80186d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	e8 b7 f7 ff ff       	call   80102e <fd_lookup>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 10                	js     80188e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801887:	39 08                	cmp    %ecx,(%eax)
  801889:	75 05                	jne    801890 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80188b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    
		return -E_NOT_SUPP;
  801890:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801895:	eb f7                	jmp    80188e <fd2sockid+0x27>

00801897 <alloc_sockfd>:
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	83 ec 1c             	sub    $0x1c,%esp
  80189f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a4:	50                   	push   %eax
  8018a5:	e8 32 f7 ff ff       	call   800fdc <fd_alloc>
  8018aa:	89 c3                	mov    %eax,%ebx
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 43                	js     8018f6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018b3:	83 ec 04             	sub    $0x4,%esp
  8018b6:	68 07 04 00 00       	push   $0x407
  8018bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018be:	6a 00                	push   $0x0
  8018c0:	e8 1b f4 ff ff       	call   800ce0 <sys_page_alloc>
  8018c5:	89 c3                	mov    %eax,%ebx
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 28                	js     8018f6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018e3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	50                   	push   %eax
  8018ea:	e8 c6 f6 ff ff       	call   800fb5 <fd2num>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	eb 0c                	jmp    801902 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	56                   	push   %esi
  8018fa:	e8 e4 01 00 00       	call   801ae3 <nsipc_close>
		return r;
  8018ff:	83 c4 10             	add    $0x10,%esp
}
  801902:	89 d8                	mov    %ebx,%eax
  801904:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801907:	5b                   	pop    %ebx
  801908:	5e                   	pop    %esi
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <accept>:
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	e8 4e ff ff ff       	call   801867 <fd2sockid>
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 1b                	js     801938 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	ff 75 10             	pushl  0x10(%ebp)
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	50                   	push   %eax
  801927:	e8 0e 01 00 00       	call   801a3a <nsipc_accept>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 05                	js     801938 <accept+0x2d>
	return alloc_sockfd(r);
  801933:	e8 5f ff ff ff       	call   801897 <alloc_sockfd>
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <bind>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	e8 1f ff ff ff       	call   801867 <fd2sockid>
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 12                	js     80195e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	ff 75 10             	pushl  0x10(%ebp)
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	50                   	push   %eax
  801956:	e8 31 01 00 00       	call   801a8c <nsipc_bind>
  80195b:	83 c4 10             	add    $0x10,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <shutdown>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	e8 f9 fe ff ff       	call   801867 <fd2sockid>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 0f                	js     801981 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	50                   	push   %eax
  801979:	e8 43 01 00 00       	call   801ac1 <nsipc_shutdown>
  80197e:	83 c4 10             	add    $0x10,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <connect>:
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	e8 d6 fe ff ff       	call   801867 <fd2sockid>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 12                	js     8019a7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	e8 59 01 00 00       	call   801afd <nsipc_connect>
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <listen>:
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	e8 b0 fe ff ff       	call   801867 <fd2sockid>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 0f                	js     8019ca <listen+0x21>
	return nsipc_listen(r, backlog);
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	e8 6b 01 00 00       	call   801b32 <nsipc_listen>
  8019c7:	83 c4 10             	add    $0x10,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <socket>:

int
socket(int domain, int type, int protocol)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019d2:	ff 75 10             	pushl  0x10(%ebp)
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 3e 02 00 00       	call   801c1e <nsipc_socket>
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 05                	js     8019ec <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019e7:	e8 ab fe ff ff       	call   801897 <alloc_sockfd>
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019f7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019fe:	74 26                	je     801a26 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a00:	6a 07                	push   $0x7
  801a02:	68 00 60 80 00       	push   $0x806000
  801a07:	53                   	push   %ebx
  801a08:	ff 35 04 40 80 00    	pushl  0x804004
  801a0e:	e8 c2 07 00 00       	call   8021d5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a13:	83 c4 0c             	add    $0xc,%esp
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	e8 4b 07 00 00       	call   80216c <ipc_recv>
}
  801a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a26:	83 ec 0c             	sub    $0xc,%esp
  801a29:	6a 02                	push   $0x2
  801a2b:	e8 fd 07 00 00       	call   80222d <ipc_find_env>
  801a30:	a3 04 40 80 00       	mov    %eax,0x804004
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	eb c6                	jmp    801a00 <nsipc+0x12>

00801a3a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a4a:	8b 06                	mov    (%esi),%eax
  801a4c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a51:	b8 01 00 00 00       	mov    $0x1,%eax
  801a56:	e8 93 ff ff ff       	call   8019ee <nsipc>
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	79 09                	jns    801a6a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	ff 35 10 60 80 00    	pushl  0x806010
  801a73:	68 00 60 80 00       	push   $0x806000
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	e8 fc ef ff ff       	call   800a7c <memmove>
		*addrlen = ret->ret_addrlen;
  801a80:	a1 10 60 80 00       	mov    0x806010,%eax
  801a85:	89 06                	mov    %eax,(%esi)
  801a87:	83 c4 10             	add    $0x10,%esp
	return r;
  801a8a:	eb d5                	jmp    801a61 <nsipc_accept+0x27>

00801a8c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a9e:	53                   	push   %ebx
  801a9f:	ff 75 0c             	pushl  0xc(%ebp)
  801aa2:	68 04 60 80 00       	push   $0x806004
  801aa7:	e8 d0 ef ff ff       	call   800a7c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aac:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ab2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab7:	e8 32 ff ff ff       	call   8019ee <nsipc>
}
  801abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ad7:	b8 03 00 00 00       	mov    $0x3,%eax
  801adc:	e8 0d ff ff ff       	call   8019ee <nsipc>
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <nsipc_close>:

int
nsipc_close(int s)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801af1:	b8 04 00 00 00       	mov    $0x4,%eax
  801af6:	e8 f3 fe ff ff       	call   8019ee <nsipc>
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	53                   	push   %ebx
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b0f:	53                   	push   %ebx
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	68 04 60 80 00       	push   $0x806004
  801b18:	e8 5f ef ff ff       	call   800a7c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b1d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b23:	b8 05 00 00 00       	mov    $0x5,%eax
  801b28:	e8 c1 fe ff ff       	call   8019ee <nsipc>
}
  801b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b43:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b48:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4d:	e8 9c fe ff ff       	call   8019ee <nsipc>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b64:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b72:	b8 07 00 00 00       	mov    $0x7,%eax
  801b77:	e8 72 fe ff ff       	call   8019ee <nsipc>
  801b7c:	89 c3                	mov    %eax,%ebx
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 1f                	js     801ba1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b82:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b87:	7f 21                	jg     801baa <nsipc_recv+0x56>
  801b89:	39 c6                	cmp    %eax,%esi
  801b8b:	7c 1d                	jl     801baa <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	50                   	push   %eax
  801b91:	68 00 60 80 00       	push   $0x806000
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	e8 de ee ff ff       	call   800a7c <memmove>
  801b9e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801baa:	68 9f 29 80 00       	push   $0x80299f
  801baf:	68 67 29 80 00       	push   $0x802967
  801bb4:	6a 62                	push   $0x62
  801bb6:	68 b4 29 80 00       	push   $0x8029b4
  801bbb:	e8 4b 05 00 00       	call   80210b <_panic>

00801bc0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bd2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bd8:	7f 2e                	jg     801c08 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	53                   	push   %ebx
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	68 0c 60 80 00       	push   $0x80600c
  801be6:	e8 91 ee ff ff       	call   800a7c <memmove>
	nsipcbuf.send.req_size = size;
  801beb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bf9:	b8 08 00 00 00       	mov    $0x8,%eax
  801bfe:	e8 eb fd ff ff       	call   8019ee <nsipc>
}
  801c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    
	assert(size < 1600);
  801c08:	68 c0 29 80 00       	push   $0x8029c0
  801c0d:	68 67 29 80 00       	push   $0x802967
  801c12:	6a 6d                	push   $0x6d
  801c14:	68 b4 29 80 00       	push   $0x8029b4
  801c19:	e8 ed 04 00 00       	call   80210b <_panic>

00801c1e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c3c:	b8 09 00 00 00       	mov    $0x9,%eax
  801c41:	e8 a8 fd ff ff       	call   8019ee <nsipc>
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	56                   	push   %esi
  801c4c:	53                   	push   %ebx
  801c4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c50:	83 ec 0c             	sub    $0xc,%esp
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	e8 6a f3 ff ff       	call   800fc5 <fd2data>
  801c5b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c5d:	83 c4 08             	add    $0x8,%esp
  801c60:	68 cc 29 80 00       	push   $0x8029cc
  801c65:	53                   	push   %ebx
  801c66:	e8 83 ec ff ff       	call   8008ee <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c6b:	8b 46 04             	mov    0x4(%esi),%eax
  801c6e:	2b 06                	sub    (%esi),%eax
  801c70:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c7d:	00 00 00 
	stat->st_dev = &devpipe;
  801c80:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c87:	30 80 00 
	return 0;
}
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5e                   	pop    %esi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    

00801c96 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	53                   	push   %ebx
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca0:	53                   	push   %ebx
  801ca1:	6a 00                	push   $0x0
  801ca3:	e8 bd f0 ff ff       	call   800d65 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca8:	89 1c 24             	mov    %ebx,(%esp)
  801cab:	e8 15 f3 ff ff       	call   800fc5 <fd2data>
  801cb0:	83 c4 08             	add    $0x8,%esp
  801cb3:	50                   	push   %eax
  801cb4:	6a 00                	push   $0x0
  801cb6:	e8 aa f0 ff ff       	call   800d65 <sys_page_unmap>
}
  801cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <_pipeisclosed>:
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	57                   	push   %edi
  801cc4:	56                   	push   %esi
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 1c             	sub    $0x1c,%esp
  801cc9:	89 c7                	mov    %eax,%edi
  801ccb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ccd:	a1 08 40 80 00       	mov    0x804008,%eax
  801cd2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	57                   	push   %edi
  801cd9:	e8 8a 05 00 00       	call   802268 <pageref>
  801cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce1:	89 34 24             	mov    %esi,(%esp)
  801ce4:	e8 7f 05 00 00       	call   802268 <pageref>
		nn = thisenv->env_runs;
  801ce9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cef:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	39 cb                	cmp    %ecx,%ebx
  801cf7:	74 1b                	je     801d14 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cfc:	75 cf                	jne    801ccd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cfe:	8b 42 58             	mov    0x58(%edx),%eax
  801d01:	6a 01                	push   $0x1
  801d03:	50                   	push   %eax
  801d04:	53                   	push   %ebx
  801d05:	68 d3 29 80 00       	push   $0x8029d3
  801d0a:	e8 80 e4 ff ff       	call   80018f <cprintf>
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	eb b9                	jmp    801ccd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d14:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d17:	0f 94 c0             	sete   %al
  801d1a:	0f b6 c0             	movzbl %al,%eax
}
  801d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    

00801d25 <devpipe_write>:
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	57                   	push   %edi
  801d29:	56                   	push   %esi
  801d2a:	53                   	push   %ebx
  801d2b:	83 ec 28             	sub    $0x28,%esp
  801d2e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d31:	56                   	push   %esi
  801d32:	e8 8e f2 ff ff       	call   800fc5 <fd2data>
  801d37:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d41:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d44:	74 4f                	je     801d95 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d46:	8b 43 04             	mov    0x4(%ebx),%eax
  801d49:	8b 0b                	mov    (%ebx),%ecx
  801d4b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4e:	39 d0                	cmp    %edx,%eax
  801d50:	72 14                	jb     801d66 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d52:	89 da                	mov    %ebx,%edx
  801d54:	89 f0                	mov    %esi,%eax
  801d56:	e8 65 ff ff ff       	call   801cc0 <_pipeisclosed>
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	75 3b                	jne    801d9a <devpipe_write+0x75>
			sys_yield();
  801d5f:	e8 5d ef ff ff       	call   800cc1 <sys_yield>
  801d64:	eb e0                	jmp    801d46 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d69:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d70:	89 c2                	mov    %eax,%edx
  801d72:	c1 fa 1f             	sar    $0x1f,%edx
  801d75:	89 d1                	mov    %edx,%ecx
  801d77:	c1 e9 1b             	shr    $0x1b,%ecx
  801d7a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7d:	83 e2 1f             	and    $0x1f,%edx
  801d80:	29 ca                	sub    %ecx,%edx
  801d82:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d86:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d8a:	83 c0 01             	add    $0x1,%eax
  801d8d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d90:	83 c7 01             	add    $0x1,%edi
  801d93:	eb ac                	jmp    801d41 <devpipe_write+0x1c>
	return i;
  801d95:	8b 45 10             	mov    0x10(%ebp),%eax
  801d98:	eb 05                	jmp    801d9f <devpipe_write+0x7a>
				return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5f                   	pop    %edi
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    

00801da7 <devpipe_read>:
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	57                   	push   %edi
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 18             	sub    $0x18,%esp
  801db0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db3:	57                   	push   %edi
  801db4:	e8 0c f2 ff ff       	call   800fc5 <fd2data>
  801db9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc6:	75 14                	jne    801ddc <devpipe_read+0x35>
	return i;
  801dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcb:	eb 02                	jmp    801dcf <devpipe_read+0x28>
				return i;
  801dcd:	89 f0                	mov    %esi,%eax
}
  801dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5f                   	pop    %edi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    
			sys_yield();
  801dd7:	e8 e5 ee ff ff       	call   800cc1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddc:	8b 03                	mov    (%ebx),%eax
  801dde:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de1:	75 18                	jne    801dfb <devpipe_read+0x54>
			if (i > 0)
  801de3:	85 f6                	test   %esi,%esi
  801de5:	75 e6                	jne    801dcd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801de7:	89 da                	mov    %ebx,%edx
  801de9:	89 f8                	mov    %edi,%eax
  801deb:	e8 d0 fe ff ff       	call   801cc0 <_pipeisclosed>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	74 e3                	je     801dd7 <devpipe_read+0x30>
				return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	eb d4                	jmp    801dcf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfb:	99                   	cltd   
  801dfc:	c1 ea 1b             	shr    $0x1b,%edx
  801dff:	01 d0                	add    %edx,%eax
  801e01:	83 e0 1f             	and    $0x1f,%eax
  801e04:	29 d0                	sub    %edx,%eax
  801e06:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e11:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e14:	83 c6 01             	add    $0x1,%esi
  801e17:	eb aa                	jmp    801dc3 <devpipe_read+0x1c>

00801e19 <pipe>:
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e24:	50                   	push   %eax
  801e25:	e8 b2 f1 ff ff       	call   800fdc <fd_alloc>
  801e2a:	89 c3                	mov    %eax,%ebx
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	0f 88 23 01 00 00    	js     801f5a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 07 04 00 00       	push   $0x407
  801e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e42:	6a 00                	push   $0x0
  801e44:	e8 97 ee ff ff       	call   800ce0 <sys_page_alloc>
  801e49:	89 c3                	mov    %eax,%ebx
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	0f 88 04 01 00 00    	js     801f5a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e5c:	50                   	push   %eax
  801e5d:	e8 7a f1 ff ff       	call   800fdc <fd_alloc>
  801e62:	89 c3                	mov    %eax,%ebx
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	85 c0                	test   %eax,%eax
  801e69:	0f 88 db 00 00 00    	js     801f4a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	68 07 04 00 00       	push   $0x407
  801e77:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7a:	6a 00                	push   $0x0
  801e7c:	e8 5f ee ff ff       	call   800ce0 <sys_page_alloc>
  801e81:	89 c3                	mov    %eax,%ebx
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	85 c0                	test   %eax,%eax
  801e88:	0f 88 bc 00 00 00    	js     801f4a <pipe+0x131>
	va = fd2data(fd0);
  801e8e:	83 ec 0c             	sub    $0xc,%esp
  801e91:	ff 75 f4             	pushl  -0xc(%ebp)
  801e94:	e8 2c f1 ff ff       	call   800fc5 <fd2data>
  801e99:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9b:	83 c4 0c             	add    $0xc,%esp
  801e9e:	68 07 04 00 00       	push   $0x407
  801ea3:	50                   	push   %eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	e8 35 ee ff ff       	call   800ce0 <sys_page_alloc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	0f 88 82 00 00 00    	js     801f3a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebe:	e8 02 f1 ff ff       	call   800fc5 <fd2data>
  801ec3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eca:	50                   	push   %eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	56                   	push   %esi
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 4e ee ff ff       	call   800d23 <sys_page_map>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 20             	add    $0x20,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	78 4e                	js     801f2c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ede:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eeb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 f4             	pushl  -0xc(%ebp)
  801f07:	e8 a9 f0 ff ff       	call   800fb5 <fd2num>
  801f0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f0f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f11:	83 c4 04             	add    $0x4,%esp
  801f14:	ff 75 f0             	pushl  -0x10(%ebp)
  801f17:	e8 99 f0 ff ff       	call   800fb5 <fd2num>
  801f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f22:	83 c4 10             	add    $0x10,%esp
  801f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2a:	eb 2e                	jmp    801f5a <pipe+0x141>
	sys_page_unmap(0, va);
  801f2c:	83 ec 08             	sub    $0x8,%esp
  801f2f:	56                   	push   %esi
  801f30:	6a 00                	push   $0x0
  801f32:	e8 2e ee ff ff       	call   800d65 <sys_page_unmap>
  801f37:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f3a:	83 ec 08             	sub    $0x8,%esp
  801f3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f40:	6a 00                	push   $0x0
  801f42:	e8 1e ee ff ff       	call   800d65 <sys_page_unmap>
  801f47:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f4a:	83 ec 08             	sub    $0x8,%esp
  801f4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f50:	6a 00                	push   $0x0
  801f52:	e8 0e ee ff ff       	call   800d65 <sys_page_unmap>
  801f57:	83 c4 10             	add    $0x10,%esp
}
  801f5a:	89 d8                	mov    %ebx,%eax
  801f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    

00801f63 <pipeisclosed>:
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6c:	50                   	push   %eax
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 b9 f0 ff ff       	call   80102e <fd_lookup>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 18                	js     801f94 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f82:	e8 3e f0 ff ff       	call   800fc5 <fd2data>
	return _pipeisclosed(fd, p);
  801f87:	89 c2                	mov    %eax,%edx
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	e8 2f fd ff ff       	call   801cc0 <_pipeisclosed>
  801f91:	83 c4 10             	add    $0x10,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	c3                   	ret    

00801f9c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa2:	68 eb 29 80 00       	push   $0x8029eb
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	e8 3f e9 ff ff       	call   8008ee <strcpy>
	return 0;
}
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <devcons_write>:
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	57                   	push   %edi
  801fba:	56                   	push   %esi
  801fbb:	53                   	push   %ebx
  801fbc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fc7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fcd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd0:	73 31                	jae    802003 <devcons_write+0x4d>
		m = n - tot;
  801fd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd5:	29 f3                	sub    %esi,%ebx
  801fd7:	83 fb 7f             	cmp    $0x7f,%ebx
  801fda:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fdf:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	53                   	push   %ebx
  801fe6:	89 f0                	mov    %esi,%eax
  801fe8:	03 45 0c             	add    0xc(%ebp),%eax
  801feb:	50                   	push   %eax
  801fec:	57                   	push   %edi
  801fed:	e8 8a ea ff ff       	call   800a7c <memmove>
		sys_cputs(buf, m);
  801ff2:	83 c4 08             	add    $0x8,%esp
  801ff5:	53                   	push   %ebx
  801ff6:	57                   	push   %edi
  801ff7:	e8 28 ec ff ff       	call   800c24 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ffc:	01 de                	add    %ebx,%esi
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	eb ca                	jmp    801fcd <devcons_write+0x17>
}
  802003:	89 f0                	mov    %esi,%eax
  802005:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    

0080200d <devcons_read>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201c:	74 21                	je     80203f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80201e:	e8 1f ec ff ff       	call   800c42 <sys_cgetc>
  802023:	85 c0                	test   %eax,%eax
  802025:	75 07                	jne    80202e <devcons_read+0x21>
		sys_yield();
  802027:	e8 95 ec ff ff       	call   800cc1 <sys_yield>
  80202c:	eb f0                	jmp    80201e <devcons_read+0x11>
	if (c < 0)
  80202e:	78 0f                	js     80203f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802030:	83 f8 04             	cmp    $0x4,%eax
  802033:	74 0c                	je     802041 <devcons_read+0x34>
	*(char*)vbuf = c;
  802035:	8b 55 0c             	mov    0xc(%ebp),%edx
  802038:	88 02                	mov    %al,(%edx)
	return 1;
  80203a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    
		return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	eb f7                	jmp    80203f <devcons_read+0x32>

00802048 <cputchar>:
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802054:	6a 01                	push   $0x1
  802056:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802059:	50                   	push   %eax
  80205a:	e8 c5 eb ff ff       	call   800c24 <sys_cputs>
}
  80205f:	83 c4 10             	add    $0x10,%esp
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <getchar>:
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80206a:	6a 01                	push   $0x1
  80206c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80206f:	50                   	push   %eax
  802070:	6a 00                	push   $0x0
  802072:	e8 27 f2 ff ff       	call   80129e <read>
	if (r < 0)
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	78 06                	js     802084 <getchar+0x20>
	if (r < 1)
  80207e:	74 06                	je     802086 <getchar+0x22>
	return c;
  802080:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    
		return -E_EOF;
  802086:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80208b:	eb f7                	jmp    802084 <getchar+0x20>

0080208d <iscons>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802093:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	e8 8f ef ff ff       	call   80102e <fd_lookup>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	78 11                	js     8020b7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020af:	39 10                	cmp    %edx,(%eax)
  8020b1:	0f 94 c0             	sete   %al
  8020b4:	0f b6 c0             	movzbl %al,%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <opencons>:
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c2:	50                   	push   %eax
  8020c3:	e8 14 ef ff ff       	call   800fdc <fd_alloc>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 3a                	js     802109 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 07 04 00 00       	push   $0x407
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	6a 00                	push   $0x0
  8020dc:	e8 ff eb ff ff       	call   800ce0 <sys_page_alloc>
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	78 21                	js     802109 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	50                   	push   %eax
  802101:	e8 af ee ff ff       	call   800fb5 <fd2num>
  802106:	83 c4 10             	add    $0x10,%esp
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802110:	a1 08 40 80 00       	mov    0x804008,%eax
  802115:	8b 40 48             	mov    0x48(%eax),%eax
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	68 28 2a 80 00       	push   $0x802a28
  802120:	50                   	push   %eax
  802121:	68 f7 29 80 00       	push   $0x8029f7
  802126:	e8 64 e0 ff ff       	call   80018f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80212b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80212e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802134:	e8 69 eb ff ff       	call   800ca2 <sys_getenvid>
  802139:	83 c4 04             	add    $0x4,%esp
  80213c:	ff 75 0c             	pushl  0xc(%ebp)
  80213f:	ff 75 08             	pushl  0x8(%ebp)
  802142:	56                   	push   %esi
  802143:	50                   	push   %eax
  802144:	68 04 2a 80 00       	push   $0x802a04
  802149:	e8 41 e0 ff ff       	call   80018f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80214e:	83 c4 18             	add    $0x18,%esp
  802151:	53                   	push   %ebx
  802152:	ff 75 10             	pushl  0x10(%ebp)
  802155:	e8 e4 df ff ff       	call   80013e <vcprintf>
	cprintf("\n");
  80215a:	c7 04 24 0b 25 80 00 	movl   $0x80250b,(%esp)
  802161:	e8 29 e0 ff ff       	call   80018f <cprintf>
  802166:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802169:	cc                   	int3   
  80216a:	eb fd                	jmp    802169 <_panic+0x5e>

0080216c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	56                   	push   %esi
  802170:	53                   	push   %ebx
  802171:	8b 75 08             	mov    0x8(%ebp),%esi
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80217a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80217c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802181:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	50                   	push   %eax
  802188:	e8 03 ed ff ff       	call   800e90 <sys_ipc_recv>
	if(ret < 0){
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	85 c0                	test   %eax,%eax
  802192:	78 2b                	js     8021bf <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802194:	85 f6                	test   %esi,%esi
  802196:	74 0a                	je     8021a2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802198:	a1 08 40 80 00       	mov    0x804008,%eax
  80219d:	8b 40 74             	mov    0x74(%eax),%eax
  8021a0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021a2:	85 db                	test   %ebx,%ebx
  8021a4:	74 0a                	je     8021b0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ab:	8b 40 78             	mov    0x78(%eax),%eax
  8021ae:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    
		if(from_env_store)
  8021bf:	85 f6                	test   %esi,%esi
  8021c1:	74 06                	je     8021c9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021c3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021c9:	85 db                	test   %ebx,%ebx
  8021cb:	74 eb                	je     8021b8 <ipc_recv+0x4c>
			*perm_store = 0;
  8021cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021d3:	eb e3                	jmp    8021b8 <ipc_recv+0x4c>

008021d5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	57                   	push   %edi
  8021d9:	56                   	push   %esi
  8021da:	53                   	push   %ebx
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021e7:	85 db                	test   %ebx,%ebx
  8021e9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021ee:	0f 44 d8             	cmove  %eax,%ebx
  8021f1:	eb 05                	jmp    8021f8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021f3:	e8 c9 ea ff ff       	call   800cc1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021f8:	ff 75 14             	pushl  0x14(%ebp)
  8021fb:	53                   	push   %ebx
  8021fc:	56                   	push   %esi
  8021fd:	57                   	push   %edi
  8021fe:	e8 6a ec ff ff       	call   800e6d <sys_ipc_try_send>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	85 c0                	test   %eax,%eax
  802208:	74 1b                	je     802225 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80220a:	79 e7                	jns    8021f3 <ipc_send+0x1e>
  80220c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80220f:	74 e2                	je     8021f3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	68 2f 2a 80 00       	push   $0x802a2f
  802219:	6a 48                	push   $0x48
  80221b:	68 44 2a 80 00       	push   $0x802a44
  802220:	e8 e6 fe ff ff       	call   80210b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802225:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802228:	5b                   	pop    %ebx
  802229:	5e                   	pop    %esi
  80222a:	5f                   	pop    %edi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    

0080222d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802238:	89 c2                	mov    %eax,%edx
  80223a:	c1 e2 07             	shl    $0x7,%edx
  80223d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802243:	8b 52 50             	mov    0x50(%edx),%edx
  802246:	39 ca                	cmp    %ecx,%edx
  802248:	74 11                	je     80225b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80224a:	83 c0 01             	add    $0x1,%eax
  80224d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802252:	75 e4                	jne    802238 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	eb 0b                	jmp    802266 <ipc_find_env+0x39>
			return envs[i].env_id;
  80225b:	c1 e0 07             	shl    $0x7,%eax
  80225e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802263:	8b 40 48             	mov    0x48(%eax),%eax
}
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    

00802268 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80226e:	89 d0                	mov    %edx,%eax
  802270:	c1 e8 16             	shr    $0x16,%eax
  802273:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80227f:	f6 c1 01             	test   $0x1,%cl
  802282:	74 1d                	je     8022a1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802284:	c1 ea 0c             	shr    $0xc,%edx
  802287:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80228e:	f6 c2 01             	test   $0x1,%dl
  802291:	74 0e                	je     8022a1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802293:	c1 ea 0c             	shr    $0xc,%edx
  802296:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80229d:	ef 
  80229e:	0f b7 c0             	movzwl %ax,%eax
}
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    
  8022a3:	66 90                	xchg   %ax,%ax
  8022a5:	66 90                	xchg   %ax,%ax
  8022a7:	66 90                	xchg   %ax,%ax
  8022a9:	66 90                	xchg   %ax,%ax
  8022ab:	66 90                	xchg   %ax,%ax
  8022ad:	66 90                	xchg   %ax,%ax
  8022af:	90                   	nop

008022b0 <__udivdi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022c7:	85 d2                	test   %edx,%edx
  8022c9:	75 4d                	jne    802318 <__udivdi3+0x68>
  8022cb:	39 f3                	cmp    %esi,%ebx
  8022cd:	76 19                	jbe    8022e8 <__udivdi3+0x38>
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	89 e8                	mov    %ebp,%eax
  8022d3:	89 f2                	mov    %esi,%edx
  8022d5:	f7 f3                	div    %ebx
  8022d7:	89 fa                	mov    %edi,%edx
  8022d9:	83 c4 1c             	add    $0x1c,%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5f                   	pop    %edi
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	89 d9                	mov    %ebx,%ecx
  8022ea:	85 db                	test   %ebx,%ebx
  8022ec:	75 0b                	jne    8022f9 <__udivdi3+0x49>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	31 d2                	xor    %edx,%edx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	f7 f1                	div    %ecx
  8022ff:	89 c6                	mov    %eax,%esi
  802301:	89 e8                	mov    %ebp,%eax
  802303:	89 f7                	mov    %esi,%edi
  802305:	f7 f1                	div    %ecx
  802307:	89 fa                	mov    %edi,%edx
  802309:	83 c4 1c             	add    $0x1c,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5f                   	pop    %edi
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	77 1c                	ja     802338 <__udivdi3+0x88>
  80231c:	0f bd fa             	bsr    %edx,%edi
  80231f:	83 f7 1f             	xor    $0x1f,%edi
  802322:	75 2c                	jne    802350 <__udivdi3+0xa0>
  802324:	39 f2                	cmp    %esi,%edx
  802326:	72 06                	jb     80232e <__udivdi3+0x7e>
  802328:	31 c0                	xor    %eax,%eax
  80232a:	39 eb                	cmp    %ebp,%ebx
  80232c:	77 a9                	ja     8022d7 <__udivdi3+0x27>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	eb a2                	jmp    8022d7 <__udivdi3+0x27>
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	31 ff                	xor    %edi,%edi
  80233a:	31 c0                	xor    %eax,%eax
  80233c:	89 fa                	mov    %edi,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 f9                	mov    %edi,%ecx
  802352:	b8 20 00 00 00       	mov    $0x20,%eax
  802357:	29 f8                	sub    %edi,%eax
  802359:	d3 e2                	shl    %cl,%edx
  80235b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	89 da                	mov    %ebx,%edx
  802363:	d3 ea                	shr    %cl,%edx
  802365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802369:	09 d1                	or     %edx,%ecx
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e3                	shl    %cl,%ebx
  802375:	89 c1                	mov    %eax,%ecx
  802377:	d3 ea                	shr    %cl,%edx
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80237f:	89 eb                	mov    %ebp,%ebx
  802381:	d3 e6                	shl    %cl,%esi
  802383:	89 c1                	mov    %eax,%ecx
  802385:	d3 eb                	shr    %cl,%ebx
  802387:	09 de                	or     %ebx,%esi
  802389:	89 f0                	mov    %esi,%eax
  80238b:	f7 74 24 08          	divl   0x8(%esp)
  80238f:	89 d6                	mov    %edx,%esi
  802391:	89 c3                	mov    %eax,%ebx
  802393:	f7 64 24 0c          	mull   0xc(%esp)
  802397:	39 d6                	cmp    %edx,%esi
  802399:	72 15                	jb     8023b0 <__udivdi3+0x100>
  80239b:	89 f9                	mov    %edi,%ecx
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	39 c5                	cmp    %eax,%ebp
  8023a1:	73 04                	jae    8023a7 <__udivdi3+0xf7>
  8023a3:	39 d6                	cmp    %edx,%esi
  8023a5:	74 09                	je     8023b0 <__udivdi3+0x100>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	31 ff                	xor    %edi,%edi
  8023ab:	e9 27 ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 1d ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__umoddi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023d7:	89 da                	mov    %ebx,%edx
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 43                	jne    802420 <__umoddi3+0x60>
  8023dd:	39 df                	cmp    %ebx,%edi
  8023df:	76 17                	jbe    8023f8 <__umoddi3+0x38>
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	f7 f7                	div    %edi
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	31 d2                	xor    %edx,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 fd                	mov    %edi,%ebp
  8023fa:	85 ff                	test   %edi,%edi
  8023fc:	75 0b                	jne    802409 <__umoddi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f7                	div    %edi
  802407:	89 c5                	mov    %eax,%ebp
  802409:	89 d8                	mov    %ebx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f5                	div    %ebp
  80240f:	89 f0                	mov    %esi,%eax
  802411:	f7 f5                	div    %ebp
  802413:	89 d0                	mov    %edx,%eax
  802415:	eb d0                	jmp    8023e7 <__umoddi3+0x27>
  802417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241e:	66 90                	xchg   %ax,%ax
  802420:	89 f1                	mov    %esi,%ecx
  802422:	39 d8                	cmp    %ebx,%eax
  802424:	76 0a                	jbe    802430 <__umoddi3+0x70>
  802426:	89 f0                	mov    %esi,%eax
  802428:	83 c4 1c             	add    $0x1c,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5f                   	pop    %edi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    
  802430:	0f bd e8             	bsr    %eax,%ebp
  802433:	83 f5 1f             	xor    $0x1f,%ebp
  802436:	75 20                	jne    802458 <__umoddi3+0x98>
  802438:	39 d8                	cmp    %ebx,%eax
  80243a:	0f 82 b0 00 00 00    	jb     8024f0 <__umoddi3+0x130>
  802440:	39 f7                	cmp    %esi,%edi
  802442:	0f 86 a8 00 00 00    	jbe    8024f0 <__umoddi3+0x130>
  802448:	89 c8                	mov    %ecx,%eax
  80244a:	83 c4 1c             	add    $0x1c,%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    
  802452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0xfb>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x107>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x107>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	89 da                	mov    %ebx,%edx
  8024f2:	29 fe                	sub    %edi,%esi
  8024f4:	19 c2                	sbb    %eax,%edx
  8024f6:	89 f1                	mov    %esi,%ecx
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	e9 4b ff ff ff       	jmp    80244a <__umoddi3+0x8a>
