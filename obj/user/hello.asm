
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 e0 11 80 00       	push   $0x8011e0
  80003e:	e8 57 01 00 00       	call   80019a <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 20 80 00       	mov    0x802004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 ee 11 80 00       	push   $0x8011ee
  800054:	e8 41 01 00 00       	call   80019a <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800067:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80006e:	00 00 00 
	envid_t find = sys_getenvid();
  800071:	e8 37 0c 00 00       	call   800cad <sys_getenvid>
  800076:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  80007c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800086:	bf 01 00 00 00       	mov    $0x1,%edi
  80008b:	eb 0b                	jmp    800098 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80008d:	83 c2 01             	add    $0x1,%edx
  800090:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800096:	74 21                	je     8000b9 <libmain+0x5b>
		if(envs[i].env_id == find)
  800098:	89 d1                	mov    %edx,%ecx
  80009a:	c1 e1 07             	shl    $0x7,%ecx
  80009d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000a3:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000a6:	39 c1                	cmp    %eax,%ecx
  8000a8:	75 e3                	jne    80008d <libmain+0x2f>
  8000aa:	89 d3                	mov    %edx,%ebx
  8000ac:	c1 e3 07             	shl    $0x7,%ebx
  8000af:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000b5:	89 fe                	mov    %edi,%esi
  8000b7:	eb d4                	jmp    80008d <libmain+0x2f>
  8000b9:	89 f0                	mov    %esi,%eax
  8000bb:	84 c0                	test   %al,%al
  8000bd:	74 06                	je     8000c5 <libmain+0x67>
  8000bf:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c9:	7e 0a                	jle    8000d5 <libmain+0x77>
		binaryname = argv[0];
  8000cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ce:	8b 00                	mov    (%eax),%eax
  8000d0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	ff 75 0c             	pushl  0xc(%ebp)
  8000db:	ff 75 08             	pushl  0x8(%ebp)
  8000de:	e8 50 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e3:	e8 0b 00 00 00       	call   8000f3 <exit>
}
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000f9:	6a 00                	push   $0x0
  8000fb:	e8 6c 0b 00 00       	call   800c6c <sys_env_destroy>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	53                   	push   %ebx
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010f:	8b 13                	mov    (%ebx),%edx
  800111:	8d 42 01             	lea    0x1(%edx),%eax
  800114:	89 03                	mov    %eax,(%ebx)
  800116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800119:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800122:	74 09                	je     80012d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800124:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	68 ff 00 00 00       	push   $0xff
  800135:	8d 43 08             	lea    0x8(%ebx),%eax
  800138:	50                   	push   %eax
  800139:	e8 f1 0a 00 00       	call   800c2f <sys_cputs>
		b->idx = 0;
  80013e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	eb db                	jmp    800124 <putch+0x1f>

00800149 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800152:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800159:	00 00 00 
	b.cnt = 0;
  80015c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800163:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800172:	50                   	push   %eax
  800173:	68 05 01 80 00       	push   $0x800105
  800178:	e8 4a 01 00 00       	call   8002c7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017d:	83 c4 08             	add    $0x8,%esp
  800180:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800186:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018c:	50                   	push   %eax
  80018d:	e8 9d 0a 00 00       	call   800c2f <sys_cputs>

	return b.cnt;
}
  800192:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a3:	50                   	push   %eax
  8001a4:	ff 75 08             	pushl  0x8(%ebp)
  8001a7:	e8 9d ff ff ff       	call   800149 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	57                   	push   %edi
  8001b2:	56                   	push   %esi
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 1c             	sub    $0x1c,%esp
  8001b7:	89 c6                	mov    %eax,%esi
  8001b9:	89 d7                	mov    %edx,%edi
  8001bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001cd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001d1:	74 2c                	je     8001ff <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e3:	39 c2                	cmp    %eax,%edx
  8001e5:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001e8:	73 43                	jae    80022d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ea:	83 eb 01             	sub    $0x1,%ebx
  8001ed:	85 db                	test   %ebx,%ebx
  8001ef:	7e 6c                	jle    80025d <printnum+0xaf>
				putch(padc, putdat);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	57                   	push   %edi
  8001f5:	ff 75 18             	pushl  0x18(%ebp)
  8001f8:	ff d6                	call   *%esi
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	eb eb                	jmp    8001ea <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	6a 20                	push   $0x20
  800204:	6a 00                	push   $0x0
  800206:	50                   	push   %eax
  800207:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020a:	ff 75 e0             	pushl  -0x20(%ebp)
  80020d:	89 fa                	mov    %edi,%edx
  80020f:	89 f0                	mov    %esi,%eax
  800211:	e8 98 ff ff ff       	call   8001ae <printnum>
		while (--width > 0)
  800216:	83 c4 20             	add    $0x20,%esp
  800219:	83 eb 01             	sub    $0x1,%ebx
  80021c:	85 db                	test   %ebx,%ebx
  80021e:	7e 65                	jle    800285 <printnum+0xd7>
			putch(padc, putdat);
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	57                   	push   %edi
  800224:	6a 20                	push   $0x20
  800226:	ff d6                	call   *%esi
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	eb ec                	jmp    800219 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	ff 75 18             	pushl  0x18(%ebp)
  800233:	83 eb 01             	sub    $0x1,%ebx
  800236:	53                   	push   %ebx
  800237:	50                   	push   %eax
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	ff 75 dc             	pushl  -0x24(%ebp)
  80023e:	ff 75 d8             	pushl  -0x28(%ebp)
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 e0             	pushl  -0x20(%ebp)
  800247:	e8 34 0d 00 00       	call   800f80 <__udivdi3>
  80024c:	83 c4 18             	add    $0x18,%esp
  80024f:	52                   	push   %edx
  800250:	50                   	push   %eax
  800251:	89 fa                	mov    %edi,%edx
  800253:	89 f0                	mov    %esi,%eax
  800255:	e8 54 ff ff ff       	call   8001ae <printnum>
  80025a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	57                   	push   %edi
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	ff 75 dc             	pushl  -0x24(%ebp)
  800267:	ff 75 d8             	pushl  -0x28(%ebp)
  80026a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026d:	ff 75 e0             	pushl  -0x20(%ebp)
  800270:	e8 1b 0e 00 00       	call   801090 <__umoddi3>
  800275:	83 c4 14             	add    $0x14,%esp
  800278:	0f be 80 0f 12 80 00 	movsbl 0x80120f(%eax),%eax
  80027f:	50                   	push   %eax
  800280:	ff d6                	call   *%esi
  800282:	83 c4 10             	add    $0x10,%esp
	}
}
  800285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800293:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800297:	8b 10                	mov    (%eax),%edx
  800299:	3b 50 04             	cmp    0x4(%eax),%edx
  80029c:	73 0a                	jae    8002a8 <sprintputch+0x1b>
		*b->buf++ = ch;
  80029e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a1:	89 08                	mov    %ecx,(%eax)
  8002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a6:	88 02                	mov    %al,(%edx)
}
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <printfmt>:
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b3:	50                   	push   %eax
  8002b4:	ff 75 10             	pushl  0x10(%ebp)
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 05 00 00 00       	call   8002c7 <vprintfmt>
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <vprintfmt>:
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	57                   	push   %edi
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	83 ec 3c             	sub    $0x3c,%esp
  8002d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d9:	e9 32 04 00 00       	jmp    800710 <vprintfmt+0x449>
		padc = ' ';
  8002de:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002e9:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002fe:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 12 05 00 00    	ja     800830 <vprintfmt+0x569>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80032f:	eb d9                	jmp    80030a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800334:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800338:	eb d0                	jmp    80030a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	0f b6 d2             	movzbl %dl,%edx
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	89 75 08             	mov    %esi,0x8(%ebp)
  800348:	eb 03                	jmp    80034d <vprintfmt+0x86>
  80034a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800350:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800354:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800357:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035a:	83 fe 09             	cmp    $0x9,%esi
  80035d:	76 eb                	jbe    80034a <vprintfmt+0x83>
  80035f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800362:	8b 75 08             	mov    0x8(%ebp),%esi
  800365:	eb 14                	jmp    80037b <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036f:	8b 45 14             	mov    0x14(%ebp),%eax
  800372:	8d 40 04             	lea    0x4(%eax),%eax
  800375:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037f:	79 89                	jns    80030a <vprintfmt+0x43>
				width = precision, precision = -1;
  800381:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800384:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800387:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80038e:	e9 77 ff ff ff       	jmp    80030a <vprintfmt+0x43>
  800393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	0f 48 c1             	cmovs  %ecx,%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a1:	e9 64 ff ff ff       	jmp    80030a <vprintfmt+0x43>
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b0:	e9 55 ff ff ff       	jmp    80030a <vprintfmt+0x43>
			lflag++;
  8003b5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bc:	e9 49 ff ff ff       	jmp    80030a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 78 04             	lea    0x4(%eax),%edi
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	53                   	push   %ebx
  8003cb:	ff 30                	pushl  (%eax)
  8003cd:	ff d6                	call   *%esi
			break;
  8003cf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d5:	e9 33 03 00 00       	jmp    80070d <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	99                   	cltd   
  8003e3:	31 d0                	xor    %edx,%eax
  8003e5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e7:	83 f8 0f             	cmp    $0xf,%eax
  8003ea:	7f 23                	jg     80040f <vprintfmt+0x148>
  8003ec:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  8003f3:	85 d2                	test   %edx,%edx
  8003f5:	74 18                	je     80040f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003f7:	52                   	push   %edx
  8003f8:	68 30 12 80 00       	push   $0x801230
  8003fd:	53                   	push   %ebx
  8003fe:	56                   	push   %esi
  8003ff:	e8 a6 fe ff ff       	call   8002aa <printfmt>
  800404:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800407:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040a:	e9 fe 02 00 00       	jmp    80070d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80040f:	50                   	push   %eax
  800410:	68 27 12 80 00       	push   $0x801227
  800415:	53                   	push   %ebx
  800416:	56                   	push   %esi
  800417:	e8 8e fe ff ff       	call   8002aa <printfmt>
  80041c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800422:	e9 e6 02 00 00       	jmp    80070d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	83 c0 04             	add    $0x4,%eax
  80042d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800435:	85 c9                	test   %ecx,%ecx
  800437:	b8 20 12 80 00       	mov    $0x801220,%eax
  80043c:	0f 45 c1             	cmovne %ecx,%eax
  80043f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800442:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800446:	7e 06                	jle    80044e <vprintfmt+0x187>
  800448:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80044c:	75 0d                	jne    80045b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800451:	89 c7                	mov    %eax,%edi
  800453:	03 45 e0             	add    -0x20(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	eb 53                	jmp    8004ae <vprintfmt+0x1e7>
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 d8             	pushl  -0x28(%ebp)
  800461:	50                   	push   %eax
  800462:	e8 71 04 00 00       	call   8008d8 <strnlen>
  800467:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046a:	29 c1                	sub    %eax,%ecx
  80046c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800474:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	eb 0f                	jmp    80048c <vprintfmt+0x1c5>
					putch(padc, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	ff 75 e0             	pushl  -0x20(%ebp)
  800484:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	83 ef 01             	sub    $0x1,%edi
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	85 ff                	test   %edi,%edi
  80048e:	7f ed                	jg     80047d <vprintfmt+0x1b6>
  800490:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800493:	85 c9                	test   %ecx,%ecx
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	0f 49 c1             	cmovns %ecx,%eax
  80049d:	29 c1                	sub    %eax,%ecx
  80049f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a2:	eb aa                	jmp    80044e <vprintfmt+0x187>
					putch(ch, putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	52                   	push   %edx
  8004a9:	ff d6                	call   *%esi
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b3:	83 c7 01             	add    $0x1,%edi
  8004b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ba:	0f be d0             	movsbl %al,%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	74 4b                	je     80050c <vprintfmt+0x245>
  8004c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c5:	78 06                	js     8004cd <vprintfmt+0x206>
  8004c7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cb:	78 1e                	js     8004eb <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d1:	74 d1                	je     8004a4 <vprintfmt+0x1dd>
  8004d3:	0f be c0             	movsbl %al,%eax
  8004d6:	83 e8 20             	sub    $0x20,%eax
  8004d9:	83 f8 5e             	cmp    $0x5e,%eax
  8004dc:	76 c6                	jbe    8004a4 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	6a 3f                	push   $0x3f
  8004e4:	ff d6                	call   *%esi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	eb c3                	jmp    8004ae <vprintfmt+0x1e7>
  8004eb:	89 cf                	mov    %ecx,%edi
  8004ed:	eb 0e                	jmp    8004fd <vprintfmt+0x236>
				putch(' ', putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	6a 20                	push   $0x20
  8004f5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f7:	83 ef 01             	sub    $0x1,%edi
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	85 ff                	test   %edi,%edi
  8004ff:	7f ee                	jg     8004ef <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800501:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
  800507:	e9 01 02 00 00       	jmp    80070d <vprintfmt+0x446>
  80050c:	89 cf                	mov    %ecx,%edi
  80050e:	eb ed                	jmp    8004fd <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800513:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80051a:	e9 eb fd ff ff       	jmp    80030a <vprintfmt+0x43>
	if (lflag >= 2)
  80051f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800523:	7f 21                	jg     800546 <vprintfmt+0x27f>
	else if (lflag)
  800525:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800529:	74 68                	je     800593 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800533:	89 c1                	mov    %eax,%ecx
  800535:	c1 f9 1f             	sar    $0x1f,%ecx
  800538:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 40 04             	lea    0x4(%eax),%eax
  800541:	89 45 14             	mov    %eax,0x14(%ebp)
  800544:	eb 17                	jmp    80055d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8b 50 04             	mov    0x4(%eax),%edx
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800551:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 40 08             	lea    0x8(%eax),%eax
  80055a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80055d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800560:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800566:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800569:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056d:	78 3f                	js     8005ae <vprintfmt+0x2e7>
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800574:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800578:	0f 84 71 01 00 00    	je     8006ef <vprintfmt+0x428>
				putch('+', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 2b                	push   $0x2b
  800584:	ff d6                	call   *%esi
  800586:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800589:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058e:	e9 5c 01 00 00       	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, int);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	eb af                	jmp    80055d <vprintfmt+0x296>
				putch('-', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 2d                	push   $0x2d
  8005b4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bc:	f7 d8                	neg    %eax
  8005be:	83 d2 00             	adc    $0x0,%edx
  8005c1:	f7 da                	neg    %edx
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d1:	e9 19 01 00 00       	jmp    8006ef <vprintfmt+0x428>
	if (lflag >= 2)
  8005d6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005da:	7f 29                	jg     800605 <vprintfmt+0x33e>
	else if (lflag)
  8005dc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e0:	74 44                	je     800626 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800600:	e9 ea 00 00 00       	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 50 04             	mov    0x4(%eax),%edx
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800610:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8d 40 08             	lea    0x8(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	e9 c9 00 00 00       	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	ba 00 00 00 00       	mov    $0x0,%edx
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800633:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800644:	e9 a6 00 00 00       	jmp    8006ef <vprintfmt+0x428>
			putch('0', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	6a 30                	push   $0x30
  80064f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800658:	7f 26                	jg     800680 <vprintfmt+0x3b9>
	else if (lflag)
  80065a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065e:	74 3e                	je     80069e <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
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
  80067e:	eb 6f                	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 50 04             	mov    0x4(%eax),%edx
  800686:	8b 00                	mov    (%eax),%eax
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 08             	lea    0x8(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800697:	b8 08 00 00 00       	mov    $0x8,%eax
  80069c:	eb 51                	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bc:	eb 31                	jmp    8006ef <vprintfmt+0x428>
			putch('0', putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	53                   	push   %ebx
  8006c2:	6a 30                	push   $0x30
  8006c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c6:	83 c4 08             	add    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	6a 78                	push   $0x78
  8006cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006db:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006de:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ea:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ef:	83 ec 0c             	sub    $0xc,%esp
  8006f2:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f6:	52                   	push   %edx
  8006f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8006fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800701:	89 da                	mov    %ebx,%edx
  800703:	89 f0                	mov    %esi,%eax
  800705:	e8 a4 fa ff ff       	call   8001ae <printnum>
			break;
  80070a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800710:	83 c7 01             	add    $0x1,%edi
  800713:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800717:	83 f8 25             	cmp    $0x25,%eax
  80071a:	0f 84 be fb ff ff    	je     8002de <vprintfmt+0x17>
			if (ch == '\0')
  800720:	85 c0                	test   %eax,%eax
  800722:	0f 84 28 01 00 00    	je     800850 <vprintfmt+0x589>
			putch(ch, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	50                   	push   %eax
  80072d:	ff d6                	call   *%esi
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	eb dc                	jmp    800710 <vprintfmt+0x449>
	if (lflag >= 2)
  800734:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800738:	7f 26                	jg     800760 <vprintfmt+0x499>
	else if (lflag)
  80073a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073e:	74 41                	je     800781 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
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
  80075e:	eb 8f                	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 50 04             	mov    0x4(%eax),%edx
  800766:	8b 00                	mov    (%eax),%eax
  800768:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 08             	lea    0x8(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
  80077c:	e9 6e ff ff ff       	jmp    8006ef <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079a:	b8 10 00 00 00       	mov    $0x10,%eax
  80079f:	e9 4b ff ff ff       	jmp    8006ef <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	83 c0 04             	add    $0x4,%eax
  8007aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	74 14                	je     8007ca <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b6:	8b 13                	mov    (%ebx),%edx
  8007b8:	83 fa 7f             	cmp    $0x7f,%edx
  8007bb:	7f 37                	jg     8007f4 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007bd:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	e9 43 ff ff ff       	jmp    80070d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cf:	bf 49 13 80 00       	mov    $0x801349,%edi
							putch(ch, putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	53                   	push   %ebx
  8007d8:	50                   	push   %eax
  8007d9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007db:	83 c7 01             	add    $0x1,%edi
  8007de:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 eb                	jne    8007d4 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ef:	e9 19 ff ff ff       	jmp    80070d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f4:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fb:	bf 81 13 80 00       	mov    $0x801381,%edi
							putch(ch, putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	53                   	push   %ebx
  800804:	50                   	push   %eax
  800805:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800807:	83 c7 01             	add    $0x1,%edi
  80080a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	85 c0                	test   %eax,%eax
  800813:	75 eb                	jne    800800 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800815:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
  80081b:	e9 ed fe ff ff       	jmp    80070d <vprintfmt+0x446>
			putch(ch, putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 25                	push   $0x25
  800826:	ff d6                	call   *%esi
			break;
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	e9 dd fe ff ff       	jmp    80070d <vprintfmt+0x446>
			putch('%', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 25                	push   $0x25
  800836:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	89 f8                	mov    %edi,%eax
  80083d:	eb 03                	jmp    800842 <vprintfmt+0x57b>
  80083f:	83 e8 01             	sub    $0x1,%eax
  800842:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800846:	75 f7                	jne    80083f <vprintfmt+0x578>
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	e9 bd fe ff ff       	jmp    80070d <vprintfmt+0x446>
}
  800850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 18             	sub    $0x18,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 26                	je     80089f <vsnprintf+0x47>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 22                	jle    80089f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	ff 75 14             	pushl  0x14(%ebp)
  800880:	ff 75 10             	pushl  0x10(%ebp)
  800883:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	68 8d 02 80 00       	push   $0x80028d
  80088c:	e8 36 fa ff ff       	call   8002c7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800894:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089a:	83 c4 10             	add    $0x10,%esp
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    
		return -E_INVAL;
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb f7                	jmp    80089d <vsnprintf+0x45>

008008a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008af:	50                   	push   %eax
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	ff 75 08             	pushl  0x8(%ebp)
  8008b9:	e8 9a ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008cf:	74 05                	je     8008d6 <strlen+0x16>
		n++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	eb f5                	jmp    8008cb <strlen+0xb>
	return n;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	39 c2                	cmp    %eax,%edx
  8008e8:	74 0d                	je     8008f7 <strnlen+0x1f>
  8008ea:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ee:	74 05                	je     8008f5 <strnlen+0x1d>
		n++;
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb f1                	jmp    8008e6 <strnlen+0xe>
  8008f5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	ba 00 00 00 00       	mov    $0x0,%edx
  800908:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80090f:	83 c2 01             	add    $0x1,%edx
  800912:	84 c9                	test   %cl,%cl
  800914:	75 f2                	jne    800908 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800916:	5b                   	pop    %ebx
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	53                   	push   %ebx
  80091d:	83 ec 10             	sub    $0x10,%esp
  800920:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800923:	53                   	push   %ebx
  800924:	e8 97 ff ff ff       	call   8008c0 <strlen>
  800929:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	01 d8                	add    %ebx,%eax
  800931:	50                   	push   %eax
  800932:	e8 c2 ff ff ff       	call   8008f9 <strcpy>
	return dst;
}
  800937:	89 d8                	mov    %ebx,%eax
  800939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	56                   	push   %esi
  800942:	53                   	push   %ebx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800949:	89 c6                	mov    %eax,%esi
  80094b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094e:	89 c2                	mov    %eax,%edx
  800950:	39 f2                	cmp    %esi,%edx
  800952:	74 11                	je     800965 <strncpy+0x27>
		*dst++ = *src;
  800954:	83 c2 01             	add    $0x1,%edx
  800957:	0f b6 19             	movzbl (%ecx),%ebx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095d:	80 fb 01             	cmp    $0x1,%bl
  800960:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800963:	eb eb                	jmp    800950 <strncpy+0x12>
	}
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	56                   	push   %esi
  80096d:	53                   	push   %ebx
  80096e:	8b 75 08             	mov    0x8(%ebp),%esi
  800971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800974:	8b 55 10             	mov    0x10(%ebp),%edx
  800977:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800979:	85 d2                	test   %edx,%edx
  80097b:	74 21                	je     80099e <strlcpy+0x35>
  80097d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800981:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800983:	39 c2                	cmp    %eax,%edx
  800985:	74 14                	je     80099b <strlcpy+0x32>
  800987:	0f b6 19             	movzbl (%ecx),%ebx
  80098a:	84 db                	test   %bl,%bl
  80098c:	74 0b                	je     800999 <strlcpy+0x30>
			*dst++ = *src++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	88 5a ff             	mov    %bl,-0x1(%edx)
  800997:	eb ea                	jmp    800983 <strlcpy+0x1a>
  800999:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099e:	29 f0                	sub    %esi,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 0c                	je     8009c0 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	75 08                	jne    8009c0 <strcmp+0x1c>
		p++, q++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
  8009be:	eb ed                	jmp    8009ad <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	0f b6 12             	movzbl (%edx),%edx
  8009c6:	29 d0                	sub    %edx,%eax
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	89 c3                	mov    %eax,%ebx
  8009d6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d9:	eb 06                	jmp    8009e1 <strncmp+0x17>
		n--, p++, q++;
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e1:	39 d8                	cmp    %ebx,%eax
  8009e3:	74 16                	je     8009fb <strncmp+0x31>
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	84 c9                	test   %cl,%cl
  8009ea:	74 04                	je     8009f0 <strncmp+0x26>
  8009ec:	3a 0a                	cmp    (%edx),%cl
  8009ee:	74 eb                	je     8009db <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f0:	0f b6 00             	movzbl (%eax),%eax
  8009f3:	0f b6 12             	movzbl (%edx),%edx
  8009f6:	29 d0                	sub    %edx,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    
		return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800a00:	eb f6                	jmp    8009f8 <strncmp+0x2e>

00800a02 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0c:	0f b6 10             	movzbl (%eax),%edx
  800a0f:	84 d2                	test   %dl,%dl
  800a11:	74 09                	je     800a1c <strchr+0x1a>
		if (*s == c)
  800a13:	38 ca                	cmp    %cl,%dl
  800a15:	74 0a                	je     800a21 <strchr+0x1f>
	for (; *s; s++)
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	eb f0                	jmp    800a0c <strchr+0xa>
			return (char *) s;
	return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 09                	je     800a3d <strfind+0x1a>
  800a34:	84 d2                	test   %dl,%dl
  800a36:	74 05                	je     800a3d <strfind+0x1a>
	for (; *s; s++)
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	eb f0                	jmp    800a2d <strfind+0xa>
			break;
	return (char *) s;
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	57                   	push   %edi
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4b:	85 c9                	test   %ecx,%ecx
  800a4d:	74 31                	je     800a80 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4f:	89 f8                	mov    %edi,%eax
  800a51:	09 c8                	or     %ecx,%eax
  800a53:	a8 03                	test   $0x3,%al
  800a55:	75 23                	jne    800a7a <memset+0x3b>
		c &= 0xFF;
  800a57:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5b:	89 d3                	mov    %edx,%ebx
  800a5d:	c1 e3 08             	shl    $0x8,%ebx
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	c1 e0 18             	shl    $0x18,%eax
  800a65:	89 d6                	mov    %edx,%esi
  800a67:	c1 e6 10             	shl    $0x10,%esi
  800a6a:	09 f0                	or     %esi,%eax
  800a6c:	09 c2                	or     %eax,%edx
  800a6e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a70:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	fc                   	cld    
  800a76:	f3 ab                	rep stos %eax,%es:(%edi)
  800a78:	eb 06                	jmp    800a80 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	fc                   	cld    
  800a7e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a80:	89 f8                	mov    %edi,%eax
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a95:	39 c6                	cmp    %eax,%esi
  800a97:	73 32                	jae    800acb <memmove+0x44>
  800a99:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	76 2b                	jbe    800acb <memmove+0x44>
		s += n;
		d += n;
  800aa0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 fe                	mov    %edi,%esi
  800aa5:	09 ce                	or     %ecx,%esi
  800aa7:	09 d6                	or     %edx,%esi
  800aa9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaf:	75 0e                	jne    800abf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1a                	jmp    800ae5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 c2                	mov    %eax,%edx
  800acd:	09 ca                	or     %ecx,%edx
  800acf:	09 f2                	or     %esi,%edx
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0a                	jne    800ae0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb 05                	jmp    800ae5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae5:	5e                   	pop    %esi
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aef:	ff 75 10             	pushl  0x10(%ebp)
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 8a ff ff ff       	call   800a87 <memmove>
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c6                	mov    %eax,%esi
  800b0c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0f:	39 f0                	cmp    %esi,%eax
  800b11:	74 1c                	je     800b2f <memcmp+0x30>
		if (*s1 != *s2)
  800b13:	0f b6 08             	movzbl (%eax),%ecx
  800b16:	0f b6 1a             	movzbl (%edx),%ebx
  800b19:	38 d9                	cmp    %bl,%cl
  800b1b:	75 08                	jne    800b25 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	eb ea                	jmp    800b0f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b25:	0f b6 c1             	movzbl %cl,%eax
  800b28:	0f b6 db             	movzbl %bl,%ebx
  800b2b:	29 d8                	sub    %ebx,%eax
  800b2d:	eb 05                	jmp    800b34 <memcmp+0x35>
	}

	return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b46:	39 d0                	cmp    %edx,%eax
  800b48:	73 09                	jae    800b53 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4a:	38 08                	cmp    %cl,(%eax)
  800b4c:	74 05                	je     800b53 <memfind+0x1b>
	for (; s < ends; s++)
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	eb f3                	jmp    800b46 <memfind+0xe>
			break;
	return (void *) s;
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
  800b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b61:	eb 03                	jmp    800b66 <strtol+0x11>
		s++;
  800b63:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b66:	0f b6 01             	movzbl (%ecx),%eax
  800b69:	3c 20                	cmp    $0x20,%al
  800b6b:	74 f6                	je     800b63 <strtol+0xe>
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	74 f2                	je     800b63 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b71:	3c 2b                	cmp    $0x2b,%al
  800b73:	74 2a                	je     800b9f <strtol+0x4a>
	int neg = 0;
  800b75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7a:	3c 2d                	cmp    $0x2d,%al
  800b7c:	74 2b                	je     800ba9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b84:	75 0f                	jne    800b95 <strtol+0x40>
  800b86:	80 39 30             	cmpb   $0x30,(%ecx)
  800b89:	74 28                	je     800bb3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b92:	0f 44 d8             	cmove  %eax,%ebx
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9d:	eb 50                	jmp    800bef <strtol+0x9a>
		s++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba7:	eb d5                	jmp    800b7e <strtol+0x29>
		s++, neg = 1;
  800ba9:	83 c1 01             	add    $0x1,%ecx
  800bac:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb1:	eb cb                	jmp    800b7e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb7:	74 0e                	je     800bc7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	75 d8                	jne    800b95 <strtol+0x40>
		s++, base = 8;
  800bbd:	83 c1 01             	add    $0x1,%ecx
  800bc0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc5:	eb ce                	jmp    800b95 <strtol+0x40>
		s += 2, base = 16;
  800bc7:	83 c1 02             	add    $0x2,%ecx
  800bca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcf:	eb c4                	jmp    800b95 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd4:	89 f3                	mov    %esi,%ebx
  800bd6:	80 fb 19             	cmp    $0x19,%bl
  800bd9:	77 29                	ja     800c04 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdb:	0f be d2             	movsbl %dl,%edx
  800bde:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be4:	7d 30                	jge    800c16 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bed:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bef:	0f b6 11             	movzbl (%ecx),%edx
  800bf2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf5:	89 f3                	mov    %esi,%ebx
  800bf7:	80 fb 09             	cmp    $0x9,%bl
  800bfa:	77 d5                	ja     800bd1 <strtol+0x7c>
			dig = *s - '0';
  800bfc:	0f be d2             	movsbl %dl,%edx
  800bff:	83 ea 30             	sub    $0x30,%edx
  800c02:	eb dd                	jmp    800be1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 08                	ja     800c16 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 37             	sub    $0x37,%edx
  800c14:	eb cb                	jmp    800be1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	74 05                	je     800c21 <strtol+0xcc>
		*endptr = (char *) s;
  800c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c21:	89 c2                	mov    %eax,%edx
  800c23:	f7 da                	neg    %edx
  800c25:	85 ff                	test   %edi,%edi
  800c27:	0f 45 c2             	cmovne %edx,%eax
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	89 c3                	mov    %eax,%ebx
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c53:	ba 00 00 00 00       	mov    $0x0,%edx
  800c58:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5d:	89 d1                	mov    %edx,%ecx
  800c5f:	89 d3                	mov    %edx,%ebx
  800c61:	89 d7                	mov    %edx,%edi
  800c63:	89 d6                	mov    %edx,%esi
  800c65:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c82:	89 cb                	mov    %ecx,%ebx
  800c84:	89 cf                	mov    %ecx,%edi
  800c86:	89 ce                	mov    %ecx,%esi
  800c88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7f 08                	jg     800c96 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 03                	push   $0x3
  800c9c:	68 a0 15 80 00       	push   $0x8015a0
  800ca1:	6a 43                	push   $0x43
  800ca3:	68 bd 15 80 00       	push   $0x8015bd
  800ca8:	e8 70 02 00 00       	call   800f1d <_panic>

00800cad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbd:	89 d1                	mov    %edx,%ecx
  800cbf:	89 d3                	mov    %edx,%ebx
  800cc1:	89 d7                	mov    %edx,%edi
  800cc3:	89 d6                	mov    %edx,%esi
  800cc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_yield>:

void
sys_yield(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	89 d3                	mov    %edx,%ebx
  800ce0:	89 d7                	mov    %edx,%edi
  800ce2:	89 d6                	mov    %edx,%esi
  800ce4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf4:	be 00 00 00 00       	mov    $0x0,%esi
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	b8 04 00 00 00       	mov    $0x4,%eax
  800d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d07:	89 f7                	mov    %esi,%edi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 04                	push   $0x4
  800d1d:	68 a0 15 80 00       	push   $0x8015a0
  800d22:	6a 43                	push   $0x43
  800d24:	68 bd 15 80 00       	push   $0x8015bd
  800d29:	e8 ef 01 00 00       	call   800f1d <_panic>

00800d2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d48:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 05                	push   $0x5
  800d5f:	68 a0 15 80 00       	push   $0x8015a0
  800d64:	6a 43                	push   $0x43
  800d66:	68 bd 15 80 00       	push   $0x8015bd
  800d6b:	e8 ad 01 00 00       	call   800f1d <_panic>

00800d70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 06 00 00 00       	mov    $0x6,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 06                	push   $0x6
  800da1:	68 a0 15 80 00       	push   $0x8015a0
  800da6:	6a 43                	push   $0x43
  800da8:	68 bd 15 80 00       	push   $0x8015bd
  800dad:	e8 6b 01 00 00       	call   800f1d <_panic>

00800db2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 08                	push   $0x8
  800de3:	68 a0 15 80 00       	push   $0x8015a0
  800de8:	6a 43                	push   $0x43
  800dea:	68 bd 15 80 00       	push   $0x8015bd
  800def:	e8 29 01 00 00       	call   800f1d <_panic>

00800df4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	89 de                	mov    %ebx,%esi
  800e11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7f 08                	jg     800e1f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	50                   	push   %eax
  800e23:	6a 09                	push   $0x9
  800e25:	68 a0 15 80 00       	push   $0x8015a0
  800e2a:	6a 43                	push   $0x43
  800e2c:	68 bd 15 80 00       	push   $0x8015bd
  800e31:	e8 e7 00 00 00       	call   800f1d <_panic>

00800e36 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0a                	push   $0xa
  800e67:	68 a0 15 80 00       	push   $0x8015a0
  800e6c:	6a 43                	push   $0x43
  800e6e:	68 bd 15 80 00       	push   $0x8015bd
  800e73:	e8 a5 00 00 00       	call   800f1d <_panic>

00800e78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e89:	be 00 00 00 00       	mov    $0x0,%esi
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e94:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
  800ea1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb1:	89 cb                	mov    %ecx,%ebx
  800eb3:	89 cf                	mov    %ecx,%edi
  800eb5:	89 ce                	mov    %ecx,%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 0d                	push   $0xd
  800ecb:	68 a0 15 80 00       	push   $0x8015a0
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 bd 15 80 00       	push   $0x8015bd
  800ed7:	e8 41 00 00 00       	call   800f1d <_panic>

00800edc <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f03:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f10:	89 cb                	mov    %ecx,%ebx
  800f12:	89 cf                	mov    %ecx,%edi
  800f14:	89 ce                	mov    %ecx,%esi
  800f16:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f22:	a1 04 20 80 00       	mov    0x802004,%eax
  800f27:	8b 40 48             	mov    0x48(%eax),%eax
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	68 fc 15 80 00       	push   $0x8015fc
  800f32:	50                   	push   %eax
  800f33:	68 cb 15 80 00       	push   $0x8015cb
  800f38:	e8 5d f2 ff ff       	call   80019a <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f3d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f40:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f46:	e8 62 fd ff ff       	call   800cad <sys_getenvid>
  800f4b:	83 c4 04             	add    $0x4,%esp
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	56                   	push   %esi
  800f55:	50                   	push   %eax
  800f56:	68 d8 15 80 00       	push   $0x8015d8
  800f5b:	e8 3a f2 ff ff       	call   80019a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f60:	83 c4 18             	add    $0x18,%esp
  800f63:	53                   	push   %ebx
  800f64:	ff 75 10             	pushl  0x10(%ebp)
  800f67:	e8 dd f1 ff ff       	call   800149 <vcprintf>
	cprintf("\n");
  800f6c:	c7 04 24 ec 11 80 00 	movl   $0x8011ec,(%esp)
  800f73:	e8 22 f2 ff ff       	call   80019a <cprintf>
  800f78:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f7b:	cc                   	int3   
  800f7c:	eb fd                	jmp    800f7b <_panic+0x5e>
  800f7e:	66 90                	xchg   %ax,%ax

00800f80 <__udivdi3>:
  800f80:	55                   	push   %ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
  800f84:	83 ec 1c             	sub    $0x1c,%esp
  800f87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f97:	85 d2                	test   %edx,%edx
  800f99:	75 4d                	jne    800fe8 <__udivdi3+0x68>
  800f9b:	39 f3                	cmp    %esi,%ebx
  800f9d:	76 19                	jbe    800fb8 <__udivdi3+0x38>
  800f9f:	31 ff                	xor    %edi,%edi
  800fa1:	89 e8                	mov    %ebp,%eax
  800fa3:	89 f2                	mov    %esi,%edx
  800fa5:	f7 f3                	div    %ebx
  800fa7:	89 fa                	mov    %edi,%edx
  800fa9:	83 c4 1c             	add    $0x1c,%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    
  800fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb8:	89 d9                	mov    %ebx,%ecx
  800fba:	85 db                	test   %ebx,%ebx
  800fbc:	75 0b                	jne    800fc9 <__udivdi3+0x49>
  800fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc3:	31 d2                	xor    %edx,%edx
  800fc5:	f7 f3                	div    %ebx
  800fc7:	89 c1                	mov    %eax,%ecx
  800fc9:	31 d2                	xor    %edx,%edx
  800fcb:	89 f0                	mov    %esi,%eax
  800fcd:	f7 f1                	div    %ecx
  800fcf:	89 c6                	mov    %eax,%esi
  800fd1:	89 e8                	mov    %ebp,%eax
  800fd3:	89 f7                	mov    %esi,%edi
  800fd5:	f7 f1                	div    %ecx
  800fd7:	89 fa                	mov    %edi,%edx
  800fd9:	83 c4 1c             	add    $0x1c,%esp
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    
  800fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fe8:	39 f2                	cmp    %esi,%edx
  800fea:	77 1c                	ja     801008 <__udivdi3+0x88>
  800fec:	0f bd fa             	bsr    %edx,%edi
  800fef:	83 f7 1f             	xor    $0x1f,%edi
  800ff2:	75 2c                	jne    801020 <__udivdi3+0xa0>
  800ff4:	39 f2                	cmp    %esi,%edx
  800ff6:	72 06                	jb     800ffe <__udivdi3+0x7e>
  800ff8:	31 c0                	xor    %eax,%eax
  800ffa:	39 eb                	cmp    %ebp,%ebx
  800ffc:	77 a9                	ja     800fa7 <__udivdi3+0x27>
  800ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  801003:	eb a2                	jmp    800fa7 <__udivdi3+0x27>
  801005:	8d 76 00             	lea    0x0(%esi),%esi
  801008:	31 ff                	xor    %edi,%edi
  80100a:	31 c0                	xor    %eax,%eax
  80100c:	89 fa                	mov    %edi,%edx
  80100e:	83 c4 1c             	add    $0x1c,%esp
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    
  801016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80101d:	8d 76 00             	lea    0x0(%esi),%esi
  801020:	89 f9                	mov    %edi,%ecx
  801022:	b8 20 00 00 00       	mov    $0x20,%eax
  801027:	29 f8                	sub    %edi,%eax
  801029:	d3 e2                	shl    %cl,%edx
  80102b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80102f:	89 c1                	mov    %eax,%ecx
  801031:	89 da                	mov    %ebx,%edx
  801033:	d3 ea                	shr    %cl,%edx
  801035:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801039:	09 d1                	or     %edx,%ecx
  80103b:	89 f2                	mov    %esi,%edx
  80103d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801041:	89 f9                	mov    %edi,%ecx
  801043:	d3 e3                	shl    %cl,%ebx
  801045:	89 c1                	mov    %eax,%ecx
  801047:	d3 ea                	shr    %cl,%edx
  801049:	89 f9                	mov    %edi,%ecx
  80104b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80104f:	89 eb                	mov    %ebp,%ebx
  801051:	d3 e6                	shl    %cl,%esi
  801053:	89 c1                	mov    %eax,%ecx
  801055:	d3 eb                	shr    %cl,%ebx
  801057:	09 de                	or     %ebx,%esi
  801059:	89 f0                	mov    %esi,%eax
  80105b:	f7 74 24 08          	divl   0x8(%esp)
  80105f:	89 d6                	mov    %edx,%esi
  801061:	89 c3                	mov    %eax,%ebx
  801063:	f7 64 24 0c          	mull   0xc(%esp)
  801067:	39 d6                	cmp    %edx,%esi
  801069:	72 15                	jb     801080 <__udivdi3+0x100>
  80106b:	89 f9                	mov    %edi,%ecx
  80106d:	d3 e5                	shl    %cl,%ebp
  80106f:	39 c5                	cmp    %eax,%ebp
  801071:	73 04                	jae    801077 <__udivdi3+0xf7>
  801073:	39 d6                	cmp    %edx,%esi
  801075:	74 09                	je     801080 <__udivdi3+0x100>
  801077:	89 d8                	mov    %ebx,%eax
  801079:	31 ff                	xor    %edi,%edi
  80107b:	e9 27 ff ff ff       	jmp    800fa7 <__udivdi3+0x27>
  801080:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801083:	31 ff                	xor    %edi,%edi
  801085:	e9 1d ff ff ff       	jmp    800fa7 <__udivdi3+0x27>
  80108a:	66 90                	xchg   %ax,%ax
  80108c:	66 90                	xchg   %ax,%ax
  80108e:	66 90                	xchg   %ax,%ax

00801090 <__umoddi3>:
  801090:	55                   	push   %ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
  801094:	83 ec 1c             	sub    $0x1c,%esp
  801097:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80109b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80109f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010a7:	89 da                	mov    %ebx,%edx
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	75 43                	jne    8010f0 <__umoddi3+0x60>
  8010ad:	39 df                	cmp    %ebx,%edi
  8010af:	76 17                	jbe    8010c8 <__umoddi3+0x38>
  8010b1:	89 f0                	mov    %esi,%eax
  8010b3:	f7 f7                	div    %edi
  8010b5:	89 d0                	mov    %edx,%eax
  8010b7:	31 d2                	xor    %edx,%edx
  8010b9:	83 c4 1c             	add    $0x1c,%esp
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    
  8010c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010c8:	89 fd                	mov    %edi,%ebp
  8010ca:	85 ff                	test   %edi,%edi
  8010cc:	75 0b                	jne    8010d9 <__umoddi3+0x49>
  8010ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8010d3:	31 d2                	xor    %edx,%edx
  8010d5:	f7 f7                	div    %edi
  8010d7:	89 c5                	mov    %eax,%ebp
  8010d9:	89 d8                	mov    %ebx,%eax
  8010db:	31 d2                	xor    %edx,%edx
  8010dd:	f7 f5                	div    %ebp
  8010df:	89 f0                	mov    %esi,%eax
  8010e1:	f7 f5                	div    %ebp
  8010e3:	89 d0                	mov    %edx,%eax
  8010e5:	eb d0                	jmp    8010b7 <__umoddi3+0x27>
  8010e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ee:	66 90                	xchg   %ax,%ax
  8010f0:	89 f1                	mov    %esi,%ecx
  8010f2:	39 d8                	cmp    %ebx,%eax
  8010f4:	76 0a                	jbe    801100 <__umoddi3+0x70>
  8010f6:	89 f0                	mov    %esi,%eax
  8010f8:	83 c4 1c             	add    $0x1c,%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
  801100:	0f bd e8             	bsr    %eax,%ebp
  801103:	83 f5 1f             	xor    $0x1f,%ebp
  801106:	75 20                	jne    801128 <__umoddi3+0x98>
  801108:	39 d8                	cmp    %ebx,%eax
  80110a:	0f 82 b0 00 00 00    	jb     8011c0 <__umoddi3+0x130>
  801110:	39 f7                	cmp    %esi,%edi
  801112:	0f 86 a8 00 00 00    	jbe    8011c0 <__umoddi3+0x130>
  801118:	89 c8                	mov    %ecx,%eax
  80111a:	83 c4 1c             	add    $0x1c,%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5f                   	pop    %edi
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    
  801122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801128:	89 e9                	mov    %ebp,%ecx
  80112a:	ba 20 00 00 00       	mov    $0x20,%edx
  80112f:	29 ea                	sub    %ebp,%edx
  801131:	d3 e0                	shl    %cl,%eax
  801133:	89 44 24 08          	mov    %eax,0x8(%esp)
  801137:	89 d1                	mov    %edx,%ecx
  801139:	89 f8                	mov    %edi,%eax
  80113b:	d3 e8                	shr    %cl,%eax
  80113d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801141:	89 54 24 04          	mov    %edx,0x4(%esp)
  801145:	8b 54 24 04          	mov    0x4(%esp),%edx
  801149:	09 c1                	or     %eax,%ecx
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801151:	89 e9                	mov    %ebp,%ecx
  801153:	d3 e7                	shl    %cl,%edi
  801155:	89 d1                	mov    %edx,%ecx
  801157:	d3 e8                	shr    %cl,%eax
  801159:	89 e9                	mov    %ebp,%ecx
  80115b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80115f:	d3 e3                	shl    %cl,%ebx
  801161:	89 c7                	mov    %eax,%edi
  801163:	89 d1                	mov    %edx,%ecx
  801165:	89 f0                	mov    %esi,%eax
  801167:	d3 e8                	shr    %cl,%eax
  801169:	89 e9                	mov    %ebp,%ecx
  80116b:	89 fa                	mov    %edi,%edx
  80116d:	d3 e6                	shl    %cl,%esi
  80116f:	09 d8                	or     %ebx,%eax
  801171:	f7 74 24 08          	divl   0x8(%esp)
  801175:	89 d1                	mov    %edx,%ecx
  801177:	89 f3                	mov    %esi,%ebx
  801179:	f7 64 24 0c          	mull   0xc(%esp)
  80117d:	89 c6                	mov    %eax,%esi
  80117f:	89 d7                	mov    %edx,%edi
  801181:	39 d1                	cmp    %edx,%ecx
  801183:	72 06                	jb     80118b <__umoddi3+0xfb>
  801185:	75 10                	jne    801197 <__umoddi3+0x107>
  801187:	39 c3                	cmp    %eax,%ebx
  801189:	73 0c                	jae    801197 <__umoddi3+0x107>
  80118b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80118f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801193:	89 d7                	mov    %edx,%edi
  801195:	89 c6                	mov    %eax,%esi
  801197:	89 ca                	mov    %ecx,%edx
  801199:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80119e:	29 f3                	sub    %esi,%ebx
  8011a0:	19 fa                	sbb    %edi,%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	d3 e0                	shl    %cl,%eax
  8011a6:	89 e9                	mov    %ebp,%ecx
  8011a8:	d3 eb                	shr    %cl,%ebx
  8011aa:	d3 ea                	shr    %cl,%edx
  8011ac:	09 d8                	or     %ebx,%eax
  8011ae:	83 c4 1c             	add    $0x1c,%esp
  8011b1:	5b                   	pop    %ebx
  8011b2:	5e                   	pop    %esi
  8011b3:	5f                   	pop    %edi
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    
  8011b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011bd:	8d 76 00             	lea    0x0(%esi),%esi
  8011c0:	89 da                	mov    %ebx,%edx
  8011c2:	29 fe                	sub    %edi,%esi
  8011c4:	19 c2                	sbb    %eax,%edx
  8011c6:	89 f1                	mov    %esi,%ecx
  8011c8:	89 c8                	mov    %ecx,%eax
  8011ca:	e9 4b ff ff ff       	jmp    80111a <__umoddi3+0x8a>
