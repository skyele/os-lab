
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 e0 11 80 00       	push   $0x8011e0
  800056:	e8 41 01 00 00       	call   80019c <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	57                   	push   %edi
  800064:	56                   	push   %esi
  800065:	53                   	push   %ebx
  800066:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800069:	c7 05 08 20 80 00 00 	movl   $0x0,0x802008
  800070:	00 00 00 
	envid_t find = sys_getenvid();
  800073:	e8 37 0c 00 00       	call   800caf <sys_getenvid>
  800078:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80007e:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800083:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800088:	bf 01 00 00 00       	mov    $0x1,%edi
  80008d:	eb 0b                	jmp    80009a <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80008f:	83 c2 01             	add    $0x1,%edx
  800092:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800098:	74 21                	je     8000bb <libmain+0x5b>
		if(envs[i].env_id == find)
  80009a:	89 d1                	mov    %edx,%ecx
  80009c:	c1 e1 07             	shl    $0x7,%ecx
  80009f:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000a5:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000a8:	39 c1                	cmp    %eax,%ecx
  8000aa:	75 e3                	jne    80008f <libmain+0x2f>
  8000ac:	89 d3                	mov    %edx,%ebx
  8000ae:	c1 e3 07             	shl    $0x7,%ebx
  8000b1:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000b7:	89 fe                	mov    %edi,%esi
  8000b9:	eb d4                	jmp    80008f <libmain+0x2f>
  8000bb:	89 f0                	mov    %esi,%eax
  8000bd:	84 c0                	test   %al,%al
  8000bf:	74 06                	je     8000c7 <libmain+0x67>
  8000c1:	89 1d 08 20 80 00    	mov    %ebx,0x802008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cb:	7e 0a                	jle    8000d7 <libmain+0x77>
		binaryname = argv[0];
  8000cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d0:	8b 00                	mov    (%eax),%eax
  8000d2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	ff 75 0c             	pushl  0xc(%ebp)
  8000dd:	ff 75 08             	pushl  0x8(%ebp)
  8000e0:	e8 4e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e5:	e8 0b 00 00 00       	call   8000f5 <exit>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5e                   	pop    %esi
  8000f2:	5f                   	pop    %edi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    

008000f5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000fb:	6a 00                	push   $0x0
  8000fd:	e8 6c 0b 00 00       	call   800c6e <sys_env_destroy>
}
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	c9                   	leave  
  800106:	c3                   	ret    

00800107 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	53                   	push   %ebx
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800111:	8b 13                	mov    (%ebx),%edx
  800113:	8d 42 01             	lea    0x1(%edx),%eax
  800116:	89 03                	mov    %eax,(%ebx)
  800118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800124:	74 09                	je     80012f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800126:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	68 ff 00 00 00       	push   $0xff
  800137:	8d 43 08             	lea    0x8(%ebx),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 f1 0a 00 00       	call   800c31 <sys_cputs>
		b->idx = 0;
  800140:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	eb db                	jmp    800126 <putch+0x1f>

0080014b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800154:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015b:	00 00 00 
	b.cnt = 0;
  80015e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800165:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800168:	ff 75 0c             	pushl  0xc(%ebp)
  80016b:	ff 75 08             	pushl  0x8(%ebp)
  80016e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800174:	50                   	push   %eax
  800175:	68 07 01 80 00       	push   $0x800107
  80017a:	e8 4a 01 00 00       	call   8002c9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017f:	83 c4 08             	add    $0x8,%esp
  800182:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800188:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 9d 0a 00 00       	call   800c31 <sys_cputs>

	return b.cnt;
}
  800194:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a5:	50                   	push   %eax
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 9d ff ff ff       	call   80014b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	57                   	push   %edi
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
  8001b9:	89 c6                	mov    %eax,%esi
  8001bb:	89 d7                	mov    %edx,%edi
  8001bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001cf:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001d3:	74 2c                	je     800201 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e5:	39 c2                	cmp    %eax,%edx
  8001e7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ea:	73 43                	jae    80022f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ec:	83 eb 01             	sub    $0x1,%ebx
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 6c                	jle    80025f <printnum+0xaf>
				putch(padc, putdat);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	57                   	push   %edi
  8001f7:	ff 75 18             	pushl  0x18(%ebp)
  8001fa:	ff d6                	call   *%esi
  8001fc:	83 c4 10             	add    $0x10,%esp
  8001ff:	eb eb                	jmp    8001ec <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	6a 20                	push   $0x20
  800206:	6a 00                	push   $0x0
  800208:	50                   	push   %eax
  800209:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020c:	ff 75 e0             	pushl  -0x20(%ebp)
  80020f:	89 fa                	mov    %edi,%edx
  800211:	89 f0                	mov    %esi,%eax
  800213:	e8 98 ff ff ff       	call   8001b0 <printnum>
		while (--width > 0)
  800218:	83 c4 20             	add    $0x20,%esp
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	85 db                	test   %ebx,%ebx
  800220:	7e 65                	jle    800287 <printnum+0xd7>
			putch(padc, putdat);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	57                   	push   %edi
  800226:	6a 20                	push   $0x20
  800228:	ff d6                	call   *%esi
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb ec                	jmp    80021b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	ff 75 18             	pushl  0x18(%ebp)
  800235:	83 eb 01             	sub    $0x1,%ebx
  800238:	53                   	push   %ebx
  800239:	50                   	push   %eax
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	ff 75 dc             	pushl  -0x24(%ebp)
  800240:	ff 75 d8             	pushl  -0x28(%ebp)
  800243:	ff 75 e4             	pushl  -0x1c(%ebp)
  800246:	ff 75 e0             	pushl  -0x20(%ebp)
  800249:	e8 32 0d 00 00       	call   800f80 <__udivdi3>
  80024e:	83 c4 18             	add    $0x18,%esp
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	89 fa                	mov    %edi,%edx
  800255:	89 f0                	mov    %esi,%eax
  800257:	e8 54 ff ff ff       	call   8001b0 <printnum>
  80025c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	57                   	push   %edi
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	ff 75 dc             	pushl  -0x24(%ebp)
  800269:	ff 75 d8             	pushl  -0x28(%ebp)
  80026c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026f:	ff 75 e0             	pushl  -0x20(%ebp)
  800272:	e8 19 0e 00 00       	call   801090 <__umoddi3>
  800277:	83 c4 14             	add    $0x14,%esp
  80027a:	0f be 80 f8 11 80 00 	movsbl 0x8011f8(%eax),%eax
  800281:	50                   	push   %eax
  800282:	ff d6                	call   *%esi
  800284:	83 c4 10             	add    $0x10,%esp
	}
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800295:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	3b 50 04             	cmp    0x4(%eax),%edx
  80029e:	73 0a                	jae    8002aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a3:	89 08                	mov    %ecx,(%eax)
  8002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a8:	88 02                	mov    %al,(%edx)
}
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <printfmt>:
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 10             	pushl  0x10(%ebp)
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	ff 75 08             	pushl  0x8(%ebp)
  8002bf:	e8 05 00 00 00       	call   8002c9 <vprintfmt>
}
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <vprintfmt>:
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	57                   	push   %edi
  8002cd:	56                   	push   %esi
  8002ce:	53                   	push   %ebx
  8002cf:	83 ec 3c             	sub    $0x3c,%esp
  8002d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002db:	e9 32 04 00 00       	jmp    800712 <vprintfmt+0x449>
		padc = ' ';
  8002e0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002eb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800300:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800307:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	8d 47 01             	lea    0x1(%edi),%eax
  80030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800312:	0f b6 17             	movzbl (%edi),%edx
  800315:	8d 42 dd             	lea    -0x23(%edx),%eax
  800318:	3c 55                	cmp    $0x55,%al
  80031a:	0f 87 12 05 00 00    	ja     800832 <vprintfmt+0x569>
  800320:	0f b6 c0             	movzbl %al,%eax
  800323:	ff 24 85 e0 13 80 00 	jmp    *0x8013e0(,%eax,4)
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800331:	eb d9                	jmp    80030c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800336:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80033a:	eb d0                	jmp    80030c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	0f b6 d2             	movzbl %dl,%edx
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800342:	b8 00 00 00 00       	mov    $0x0,%eax
  800347:	89 75 08             	mov    %esi,0x8(%ebp)
  80034a:	eb 03                	jmp    80034f <vprintfmt+0x86>
  80034c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800352:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800356:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800359:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035c:	83 fe 09             	cmp    $0x9,%esi
  80035f:	76 eb                	jbe    80034c <vprintfmt+0x83>
  800361:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800364:	8b 75 08             	mov    0x8(%ebp),%esi
  800367:	eb 14                	jmp    80037d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	8b 00                	mov    (%eax),%eax
  80036e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800371:	8b 45 14             	mov    0x14(%ebp),%eax
  800374:	8d 40 04             	lea    0x4(%eax),%eax
  800377:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800381:	79 89                	jns    80030c <vprintfmt+0x43>
				width = precision, precision = -1;
  800383:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800386:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800389:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800390:	e9 77 ff ff ff       	jmp    80030c <vprintfmt+0x43>
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	0f 48 c1             	cmovs  %ecx,%eax
  80039d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a3:	e9 64 ff ff ff       	jmp    80030c <vprintfmt+0x43>
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ab:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b2:	e9 55 ff ff ff       	jmp    80030c <vprintfmt+0x43>
			lflag++;
  8003b7:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003be:	e9 49 ff ff ff       	jmp    80030c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 78 04             	lea    0x4(%eax),%edi
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	53                   	push   %ebx
  8003cd:	ff 30                	pushl  (%eax)
  8003cf:	ff d6                	call   *%esi
			break;
  8003d1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d7:	e9 33 03 00 00       	jmp    80070f <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 78 04             	lea    0x4(%eax),%edi
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	99                   	cltd   
  8003e5:	31 d0                	xor    %edx,%eax
  8003e7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e9:	83 f8 0f             	cmp    $0xf,%eax
  8003ec:	7f 23                	jg     800411 <vprintfmt+0x148>
  8003ee:	8b 14 85 40 15 80 00 	mov    0x801540(,%eax,4),%edx
  8003f5:	85 d2                	test   %edx,%edx
  8003f7:	74 18                	je     800411 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003f9:	52                   	push   %edx
  8003fa:	68 19 12 80 00       	push   $0x801219
  8003ff:	53                   	push   %ebx
  800400:	56                   	push   %esi
  800401:	e8 a6 fe ff ff       	call   8002ac <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040c:	e9 fe 02 00 00       	jmp    80070f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800411:	50                   	push   %eax
  800412:	68 10 12 80 00       	push   $0x801210
  800417:	53                   	push   %ebx
  800418:	56                   	push   %esi
  800419:	e8 8e fe ff ff       	call   8002ac <printfmt>
  80041e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800421:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800424:	e9 e6 02 00 00       	jmp    80070f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	83 c0 04             	add    $0x4,%eax
  80042f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800437:	85 c9                	test   %ecx,%ecx
  800439:	b8 09 12 80 00       	mov    $0x801209,%eax
  80043e:	0f 45 c1             	cmovne %ecx,%eax
  800441:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800448:	7e 06                	jle    800450 <vprintfmt+0x187>
  80044a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80044e:	75 0d                	jne    80045d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800450:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800453:	89 c7                	mov    %eax,%edi
  800455:	03 45 e0             	add    -0x20(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045b:	eb 53                	jmp    8004b0 <vprintfmt+0x1e7>
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	ff 75 d8             	pushl  -0x28(%ebp)
  800463:	50                   	push   %eax
  800464:	e8 71 04 00 00       	call   8008da <strnlen>
  800469:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046c:	29 c1                	sub    %eax,%ecx
  80046e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800476:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80047a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047d:	eb 0f                	jmp    80048e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	53                   	push   %ebx
  800483:	ff 75 e0             	pushl  -0x20(%ebp)
  800486:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ed                	jg     80047f <vprintfmt+0x1b6>
  800492:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800495:	85 c9                	test   %ecx,%ecx
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
  80049c:	0f 49 c1             	cmovns %ecx,%eax
  80049f:	29 c1                	sub    %eax,%ecx
  8004a1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a4:	eb aa                	jmp    800450 <vprintfmt+0x187>
					putch(ch, putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	53                   	push   %ebx
  8004aa:	52                   	push   %edx
  8004ab:	ff d6                	call   *%esi
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b5:	83 c7 01             	add    $0x1,%edi
  8004b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004bc:	0f be d0             	movsbl %al,%edx
  8004bf:	85 d2                	test   %edx,%edx
  8004c1:	74 4b                	je     80050e <vprintfmt+0x245>
  8004c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c7:	78 06                	js     8004cf <vprintfmt+0x206>
  8004c9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cd:	78 1e                	js     8004ed <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d3:	74 d1                	je     8004a6 <vprintfmt+0x1dd>
  8004d5:	0f be c0             	movsbl %al,%eax
  8004d8:	83 e8 20             	sub    $0x20,%eax
  8004db:	83 f8 5e             	cmp    $0x5e,%eax
  8004de:	76 c6                	jbe    8004a6 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	53                   	push   %ebx
  8004e4:	6a 3f                	push   $0x3f
  8004e6:	ff d6                	call   *%esi
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	eb c3                	jmp    8004b0 <vprintfmt+0x1e7>
  8004ed:	89 cf                	mov    %ecx,%edi
  8004ef:	eb 0e                	jmp    8004ff <vprintfmt+0x236>
				putch(' ', putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	53                   	push   %ebx
  8004f5:	6a 20                	push   $0x20
  8004f7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f9:	83 ef 01             	sub    $0x1,%edi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	85 ff                	test   %edi,%edi
  800501:	7f ee                	jg     8004f1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800503:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800506:	89 45 14             	mov    %eax,0x14(%ebp)
  800509:	e9 01 02 00 00       	jmp    80070f <vprintfmt+0x446>
  80050e:	89 cf                	mov    %ecx,%edi
  800510:	eb ed                	jmp    8004ff <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800515:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80051c:	e9 eb fd ff ff       	jmp    80030c <vprintfmt+0x43>
	if (lflag >= 2)
  800521:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800525:	7f 21                	jg     800548 <vprintfmt+0x27f>
	else if (lflag)
  800527:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80052b:	74 68                	je     800595 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800535:	89 c1                	mov    %eax,%ecx
  800537:	c1 f9 1f             	sar    $0x1f,%ecx
  80053a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 40 04             	lea    0x4(%eax),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
  800546:	eb 17                	jmp    80055f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8b 50 04             	mov    0x4(%eax),%edx
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800553:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8d 40 08             	lea    0x8(%eax),%eax
  80055c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80055f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800562:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800565:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800568:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80056b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056f:	78 3f                	js     8005b0 <vprintfmt+0x2e7>
			base = 10;
  800571:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800576:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80057a:	0f 84 71 01 00 00    	je     8006f1 <vprintfmt+0x428>
				putch('+', putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	6a 2b                	push   $0x2b
  800586:	ff d6                	call   *%esi
  800588:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800590:	e9 5c 01 00 00       	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059d:	89 c1                	mov    %eax,%ecx
  80059f:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 40 04             	lea    0x4(%eax),%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ae:	eb af                	jmp    80055f <vprintfmt+0x296>
				putch('-', putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	53                   	push   %ebx
  8005b4:	6a 2d                	push   $0x2d
  8005b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005be:	f7 d8                	neg    %eax
  8005c0:	83 d2 00             	adc    $0x0,%edx
  8005c3:	f7 da                	neg    %edx
  8005c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d3:	e9 19 01 00 00       	jmp    8006f1 <vprintfmt+0x428>
	if (lflag >= 2)
  8005d8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005dc:	7f 29                	jg     800607 <vprintfmt+0x33e>
	else if (lflag)
  8005de:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e2:	74 44                	je     800628 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800602:	e9 ea 00 00 00       	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8b 50 04             	mov    0x4(%eax),%edx
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800612:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 40 08             	lea    0x8(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800623:	e9 c9 00 00 00       	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800641:	b8 0a 00 00 00       	mov    $0xa,%eax
  800646:	e9 a6 00 00 00       	jmp    8006f1 <vprintfmt+0x428>
			putch('0', putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	53                   	push   %ebx
  80064f:	6a 30                	push   $0x30
  800651:	ff d6                	call   *%esi
	if (lflag >= 2)
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80065a:	7f 26                	jg     800682 <vprintfmt+0x3b9>
	else if (lflag)
  80065c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800660:	74 3e                	je     8006a0 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067b:	b8 08 00 00 00       	mov    $0x8,%eax
  800680:	eb 6f                	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 50 04             	mov    0x4(%eax),%edx
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 40 08             	lea    0x8(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800699:	b8 08 00 00 00       	mov    $0x8,%eax
  80069e:	eb 51                	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006be:	eb 31                	jmp    8006f1 <vprintfmt+0x428>
			putch('0', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	6a 30                	push   $0x30
  8006c6:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c8:	83 c4 08             	add    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 78                	push   $0x78
  8006ce:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006e0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ec:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f8:	52                   	push   %edx
  8006f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800700:	ff 75 d8             	pushl  -0x28(%ebp)
  800703:	89 da                	mov    %ebx,%edx
  800705:	89 f0                	mov    %esi,%eax
  800707:	e8 a4 fa ff ff       	call   8001b0 <printnum>
			break;
  80070c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80070f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800712:	83 c7 01             	add    $0x1,%edi
  800715:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800719:	83 f8 25             	cmp    $0x25,%eax
  80071c:	0f 84 be fb ff ff    	je     8002e0 <vprintfmt+0x17>
			if (ch == '\0')
  800722:	85 c0                	test   %eax,%eax
  800724:	0f 84 28 01 00 00    	je     800852 <vprintfmt+0x589>
			putch(ch, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	50                   	push   %eax
  80072f:	ff d6                	call   *%esi
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	eb dc                	jmp    800712 <vprintfmt+0x449>
	if (lflag >= 2)
  800736:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073a:	7f 26                	jg     800762 <vprintfmt+0x499>
	else if (lflag)
  80073c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800740:	74 41                	je     800783 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075b:	b8 10 00 00 00       	mov    $0x10,%eax
  800760:	eb 8f                	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 50 04             	mov    0x4(%eax),%edx
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 08             	lea    0x8(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800779:	b8 10 00 00 00       	mov    $0x10,%eax
  80077e:	e9 6e ff ff ff       	jmp    8006f1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a1:	e9 4b ff ff ff       	jmp    8006f1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	83 c0 04             	add    $0x4,%eax
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	74 14                	je     8007cc <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b8:	8b 13                	mov    (%ebx),%edx
  8007ba:	83 fa 7f             	cmp    $0x7f,%edx
  8007bd:	7f 37                	jg     8007f6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007bf:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c7:	e9 43 ff ff ff       	jmp    80070f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	bf 31 13 80 00       	mov    $0x801331,%edi
							putch(ch, putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	50                   	push   %eax
  8007db:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007dd:	83 c7 01             	add    $0x1,%edi
  8007e0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	75 eb                	jne    8007d6 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	e9 19 ff ff ff       	jmp    80070f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fd:	bf 69 13 80 00       	mov    $0x801369,%edi
							putch(ch, putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	50                   	push   %eax
  800807:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800809:	83 c7 01             	add    $0x1,%edi
  80080c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	85 c0                	test   %eax,%eax
  800815:	75 eb                	jne    800802 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800817:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	e9 ed fe ff ff       	jmp    80070f <vprintfmt+0x446>
			putch(ch, putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	53                   	push   %ebx
  800826:	6a 25                	push   $0x25
  800828:	ff d6                	call   *%esi
			break;
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	e9 dd fe ff ff       	jmp    80070f <vprintfmt+0x446>
			putch('%', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 25                	push   $0x25
  800838:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	89 f8                	mov    %edi,%eax
  80083f:	eb 03                	jmp    800844 <vprintfmt+0x57b>
  800841:	83 e8 01             	sub    $0x1,%eax
  800844:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800848:	75 f7                	jne    800841 <vprintfmt+0x578>
  80084a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084d:	e9 bd fe ff ff       	jmp    80070f <vprintfmt+0x446>
}
  800852:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800855:	5b                   	pop    %ebx
  800856:	5e                   	pop    %esi
  800857:	5f                   	pop    %edi
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 18             	sub    $0x18,%esp
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800869:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800877:	85 c0                	test   %eax,%eax
  800879:	74 26                	je     8008a1 <vsnprintf+0x47>
  80087b:	85 d2                	test   %edx,%edx
  80087d:	7e 22                	jle    8008a1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087f:	ff 75 14             	pushl  0x14(%ebp)
  800882:	ff 75 10             	pushl  0x10(%ebp)
  800885:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800888:	50                   	push   %eax
  800889:	68 8f 02 80 00       	push   $0x80028f
  80088e:	e8 36 fa ff ff       	call   8002c9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800896:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089c:	83 c4 10             	add    $0x10,%esp
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    
		return -E_INVAL;
  8008a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a6:	eb f7                	jmp    80089f <vsnprintf+0x45>

008008a8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ae:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b1:	50                   	push   %eax
  8008b2:	ff 75 10             	pushl  0x10(%ebp)
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	ff 75 08             	pushl  0x8(%ebp)
  8008bb:	e8 9a ff ff ff       	call   80085a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d1:	74 05                	je     8008d8 <strlen+0x16>
		n++;
  8008d3:	83 c0 01             	add    $0x1,%eax
  8008d6:	eb f5                	jmp    8008cd <strlen+0xb>
	return n;
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e8:	39 c2                	cmp    %eax,%edx
  8008ea:	74 0d                	je     8008f9 <strnlen+0x1f>
  8008ec:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008f0:	74 05                	je     8008f7 <strnlen+0x1d>
		n++;
  8008f2:	83 c2 01             	add    $0x1,%edx
  8008f5:	eb f1                	jmp    8008e8 <strnlen+0xe>
  8008f7:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800911:	83 c2 01             	add    $0x1,%edx
  800914:	84 c9                	test   %cl,%cl
  800916:	75 f2                	jne    80090a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	53                   	push   %ebx
  80091f:	83 ec 10             	sub    $0x10,%esp
  800922:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800925:	53                   	push   %ebx
  800926:	e8 97 ff ff ff       	call   8008c2 <strlen>
  80092b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	01 d8                	add    %ebx,%eax
  800933:	50                   	push   %eax
  800934:	e8 c2 ff ff ff       	call   8008fb <strcpy>
	return dst;
}
  800939:	89 d8                	mov    %ebx,%eax
  80093b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	56                   	push   %esi
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094b:	89 c6                	mov    %eax,%esi
  80094d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800950:	89 c2                	mov    %eax,%edx
  800952:	39 f2                	cmp    %esi,%edx
  800954:	74 11                	je     800967 <strncpy+0x27>
		*dst++ = *src;
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	0f b6 19             	movzbl (%ecx),%ebx
  80095c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095f:	80 fb 01             	cmp    $0x1,%bl
  800962:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800965:	eb eb                	jmp    800952 <strncpy+0x12>
	}
	return ret;
}
  800967:	5b                   	pop    %ebx
  800968:	5e                   	pop    %esi
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	8b 75 08             	mov    0x8(%ebp),%esi
  800973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800976:	8b 55 10             	mov    0x10(%ebp),%edx
  800979:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097b:	85 d2                	test   %edx,%edx
  80097d:	74 21                	je     8009a0 <strlcpy+0x35>
  80097f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800983:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800985:	39 c2                	cmp    %eax,%edx
  800987:	74 14                	je     80099d <strlcpy+0x32>
  800989:	0f b6 19             	movzbl (%ecx),%ebx
  80098c:	84 db                	test   %bl,%bl
  80098e:	74 0b                	je     80099b <strlcpy+0x30>
			*dst++ = *src++;
  800990:	83 c1 01             	add    $0x1,%ecx
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	88 5a ff             	mov    %bl,-0x1(%edx)
  800999:	eb ea                	jmp    800985 <strlcpy+0x1a>
  80099b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a0:	29 f0                	sub    %esi,%eax
}
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009af:	0f b6 01             	movzbl (%ecx),%eax
  8009b2:	84 c0                	test   %al,%al
  8009b4:	74 0c                	je     8009c2 <strcmp+0x1c>
  8009b6:	3a 02                	cmp    (%edx),%al
  8009b8:	75 08                	jne    8009c2 <strcmp+0x1c>
		p++, q++;
  8009ba:	83 c1 01             	add    $0x1,%ecx
  8009bd:	83 c2 01             	add    $0x1,%edx
  8009c0:	eb ed                	jmp    8009af <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 c0             	movzbl %al,%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	89 c3                	mov    %eax,%ebx
  8009d8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009db:	eb 06                	jmp    8009e3 <strncmp+0x17>
		n--, p++, q++;
  8009dd:	83 c0 01             	add    $0x1,%eax
  8009e0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e3:	39 d8                	cmp    %ebx,%eax
  8009e5:	74 16                	je     8009fd <strncmp+0x31>
  8009e7:	0f b6 08             	movzbl (%eax),%ecx
  8009ea:	84 c9                	test   %cl,%cl
  8009ec:	74 04                	je     8009f2 <strncmp+0x26>
  8009ee:	3a 0a                	cmp    (%edx),%cl
  8009f0:	74 eb                	je     8009dd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f2:	0f b6 00             	movzbl (%eax),%eax
  8009f5:	0f b6 12             	movzbl (%edx),%edx
  8009f8:	29 d0                	sub    %edx,%eax
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    
		return 0;
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800a02:	eb f6                	jmp    8009fa <strncmp+0x2e>

00800a04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	74 09                	je     800a1e <strchr+0x1a>
		if (*s == c)
  800a15:	38 ca                	cmp    %cl,%dl
  800a17:	74 0a                	je     800a23 <strchr+0x1f>
	for (; *s; s++)
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	eb f0                	jmp    800a0e <strchr+0xa>
			return (char *) s;
	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a32:	38 ca                	cmp    %cl,%dl
  800a34:	74 09                	je     800a3f <strfind+0x1a>
  800a36:	84 d2                	test   %dl,%dl
  800a38:	74 05                	je     800a3f <strfind+0x1a>
	for (; *s; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	eb f0                	jmp    800a2f <strfind+0xa>
			break;
	return (char *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4d:	85 c9                	test   %ecx,%ecx
  800a4f:	74 31                	je     800a82 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a51:	89 f8                	mov    %edi,%eax
  800a53:	09 c8                	or     %ecx,%eax
  800a55:	a8 03                	test   $0x3,%al
  800a57:	75 23                	jne    800a7c <memset+0x3b>
		c &= 0xFF;
  800a59:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5d:	89 d3                	mov    %edx,%ebx
  800a5f:	c1 e3 08             	shl    $0x8,%ebx
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 18             	shl    $0x18,%eax
  800a67:	89 d6                	mov    %edx,%esi
  800a69:	c1 e6 10             	shl    $0x10,%esi
  800a6c:	09 f0                	or     %esi,%eax
  800a6e:	09 c2                	or     %eax,%edx
  800a70:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a72:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	fc                   	cld    
  800a78:	f3 ab                	rep stos %eax,%es:(%edi)
  800a7a:	eb 06                	jmp    800a82 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	fc                   	cld    
  800a80:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a82:	89 f8                	mov    %edi,%eax
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5f                   	pop    %edi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a97:	39 c6                	cmp    %eax,%esi
  800a99:	73 32                	jae    800acd <memmove+0x44>
  800a9b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9e:	39 c2                	cmp    %eax,%edx
  800aa0:	76 2b                	jbe    800acd <memmove+0x44>
		s += n;
		d += n;
  800aa2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa5:	89 fe                	mov    %edi,%esi
  800aa7:	09 ce                	or     %ecx,%esi
  800aa9:	09 d6                	or     %edx,%esi
  800aab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab1:	75 0e                	jne    800ac1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab3:	83 ef 04             	sub    $0x4,%edi
  800ab6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800abc:	fd                   	std    
  800abd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abf:	eb 09                	jmp    800aca <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac1:	83 ef 01             	sub    $0x1,%edi
  800ac4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac7:	fd                   	std    
  800ac8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aca:	fc                   	cld    
  800acb:	eb 1a                	jmp    800ae7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	09 ca                	or     %ecx,%edx
  800ad1:	09 f2                	or     %esi,%edx
  800ad3:	f6 c2 03             	test   $0x3,%dl
  800ad6:	75 0a                	jne    800ae2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800adb:	89 c7                	mov    %eax,%edi
  800add:	fc                   	cld    
  800ade:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae0:	eb 05                	jmp    800ae7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae2:	89 c7                	mov    %eax,%edi
  800ae4:	fc                   	cld    
  800ae5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae7:	5e                   	pop    %esi
  800ae8:	5f                   	pop    %edi
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af1:	ff 75 10             	pushl  0x10(%ebp)
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	ff 75 08             	pushl  0x8(%ebp)
  800afa:	e8 8a ff ff ff       	call   800a89 <memmove>
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0c:	89 c6                	mov    %eax,%esi
  800b0e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b11:	39 f0                	cmp    %esi,%eax
  800b13:	74 1c                	je     800b31 <memcmp+0x30>
		if (*s1 != *s2)
  800b15:	0f b6 08             	movzbl (%eax),%ecx
  800b18:	0f b6 1a             	movzbl (%edx),%ebx
  800b1b:	38 d9                	cmp    %bl,%cl
  800b1d:	75 08                	jne    800b27 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1f:	83 c0 01             	add    $0x1,%eax
  800b22:	83 c2 01             	add    $0x1,%edx
  800b25:	eb ea                	jmp    800b11 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b27:	0f b6 c1             	movzbl %cl,%eax
  800b2a:	0f b6 db             	movzbl %bl,%ebx
  800b2d:	29 d8                	sub    %ebx,%eax
  800b2f:	eb 05                	jmp    800b36 <memcmp+0x35>
	}

	return 0;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b36:	5b                   	pop    %ebx
  800b37:	5e                   	pop    %esi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b43:	89 c2                	mov    %eax,%edx
  800b45:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b48:	39 d0                	cmp    %edx,%eax
  800b4a:	73 09                	jae    800b55 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4c:	38 08                	cmp    %cl,(%eax)
  800b4e:	74 05                	je     800b55 <memfind+0x1b>
	for (; s < ends; s++)
  800b50:	83 c0 01             	add    $0x1,%eax
  800b53:	eb f3                	jmp    800b48 <memfind+0xe>
			break;
	return (void *) s;
}
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	57                   	push   %edi
  800b5b:	56                   	push   %esi
  800b5c:	53                   	push   %ebx
  800b5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b63:	eb 03                	jmp    800b68 <strtol+0x11>
		s++;
  800b65:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b68:	0f b6 01             	movzbl (%ecx),%eax
  800b6b:	3c 20                	cmp    $0x20,%al
  800b6d:	74 f6                	je     800b65 <strtol+0xe>
  800b6f:	3c 09                	cmp    $0x9,%al
  800b71:	74 f2                	je     800b65 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b73:	3c 2b                	cmp    $0x2b,%al
  800b75:	74 2a                	je     800ba1 <strtol+0x4a>
	int neg = 0;
  800b77:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7c:	3c 2d                	cmp    $0x2d,%al
  800b7e:	74 2b                	je     800bab <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b80:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b86:	75 0f                	jne    800b97 <strtol+0x40>
  800b88:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8b:	74 28                	je     800bb5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b94:	0f 44 d8             	cmove  %eax,%ebx
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9f:	eb 50                	jmp    800bf1 <strtol+0x9a>
		s++;
  800ba1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba9:	eb d5                	jmp    800b80 <strtol+0x29>
		s++, neg = 1;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb3:	eb cb                	jmp    800b80 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb9:	74 0e                	je     800bc9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bbb:	85 db                	test   %ebx,%ebx
  800bbd:	75 d8                	jne    800b97 <strtol+0x40>
		s++, base = 8;
  800bbf:	83 c1 01             	add    $0x1,%ecx
  800bc2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc7:	eb ce                	jmp    800b97 <strtol+0x40>
		s += 2, base = 16;
  800bc9:	83 c1 02             	add    $0x2,%ecx
  800bcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd1:	eb c4                	jmp    800b97 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd6:	89 f3                	mov    %esi,%ebx
  800bd8:	80 fb 19             	cmp    $0x19,%bl
  800bdb:	77 29                	ja     800c06 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdd:	0f be d2             	movsbl %dl,%edx
  800be0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be6:	7d 30                	jge    800c18 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be8:	83 c1 01             	add    $0x1,%ecx
  800beb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf1:	0f b6 11             	movzbl (%ecx),%edx
  800bf4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf7:	89 f3                	mov    %esi,%ebx
  800bf9:	80 fb 09             	cmp    $0x9,%bl
  800bfc:	77 d5                	ja     800bd3 <strtol+0x7c>
			dig = *s - '0';
  800bfe:	0f be d2             	movsbl %dl,%edx
  800c01:	83 ea 30             	sub    $0x30,%edx
  800c04:	eb dd                	jmp    800be3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c06:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c09:	89 f3                	mov    %esi,%ebx
  800c0b:	80 fb 19             	cmp    $0x19,%bl
  800c0e:	77 08                	ja     800c18 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c10:	0f be d2             	movsbl %dl,%edx
  800c13:	83 ea 37             	sub    $0x37,%edx
  800c16:	eb cb                	jmp    800be3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1c:	74 05                	je     800c23 <strtol+0xcc>
		*endptr = (char *) s;
  800c1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c21:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c23:	89 c2                	mov    %eax,%edx
  800c25:	f7 da                	neg    %edx
  800c27:	85 ff                	test   %edi,%edi
  800c29:	0f 45 c2             	cmovne %edx,%eax
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5f                   	pop    %edi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	89 c3                	mov    %eax,%ebx
  800c44:	89 c7                	mov    %eax,%edi
  800c46:	89 c6                	mov    %eax,%esi
  800c48:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c84:	89 cb                	mov    %ecx,%ebx
  800c86:	89 cf                	mov    %ecx,%edi
  800c88:	89 ce                	mov    %ecx,%esi
  800c8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7f 08                	jg     800c98 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 03                	push   $0x3
  800c9e:	68 80 15 80 00       	push   $0x801580
  800ca3:	6a 43                	push   $0x43
  800ca5:	68 9d 15 80 00       	push   $0x80159d
  800caa:	e8 70 02 00 00       	call   800f1f <_panic>

00800caf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbf:	89 d1                	mov    %edx,%ecx
  800cc1:	89 d3                	mov    %edx,%ebx
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	89 d6                	mov    %edx,%esi
  800cc7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_yield>:

void
sys_yield(void)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cde:	89 d1                	mov    %edx,%ecx
  800ce0:	89 d3                	mov    %edx,%ebx
  800ce2:	89 d7                	mov    %edx,%edi
  800ce4:	89 d6                	mov    %edx,%esi
  800ce6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf6:	be 00 00 00 00       	mov    $0x0,%esi
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	b8 04 00 00 00       	mov    $0x4,%eax
  800d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d09:	89 f7                	mov    %esi,%edi
  800d0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 04                	push   $0x4
  800d1f:	68 80 15 80 00       	push   $0x801580
  800d24:	6a 43                	push   $0x43
  800d26:	68 9d 15 80 00       	push   $0x80159d
  800d2b:	e8 ef 01 00 00       	call   800f1f <_panic>

00800d30 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d47:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 05                	push   $0x5
  800d61:	68 80 15 80 00       	push   $0x801580
  800d66:	6a 43                	push   $0x43
  800d68:	68 9d 15 80 00       	push   $0x80159d
  800d6d:	e8 ad 01 00 00       	call   800f1f <_panic>

00800d72 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d86:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8b:	89 df                	mov    %ebx,%edi
  800d8d:	89 de                	mov    %ebx,%esi
  800d8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7f 08                	jg     800d9d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	50                   	push   %eax
  800da1:	6a 06                	push   $0x6
  800da3:	68 80 15 80 00       	push   $0x801580
  800da8:	6a 43                	push   $0x43
  800daa:	68 9d 15 80 00       	push   $0x80159d
  800daf:	e8 6b 01 00 00       	call   800f1f <_panic>

00800db4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcd:	89 df                	mov    %ebx,%edi
  800dcf:	89 de                	mov    %ebx,%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 08                	push   $0x8
  800de5:	68 80 15 80 00       	push   $0x801580
  800dea:	6a 43                	push   $0x43
  800dec:	68 9d 15 80 00       	push   $0x80159d
  800df1:	e8 29 01 00 00       	call   800f1f <_panic>

00800df6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
  800dfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	89 de                	mov    %ebx,%esi
  800e13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7f 08                	jg     800e21 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	50                   	push   %eax
  800e25:	6a 09                	push   $0x9
  800e27:	68 80 15 80 00       	push   $0x801580
  800e2c:	6a 43                	push   $0x43
  800e2e:	68 9d 15 80 00       	push   $0x80159d
  800e33:	e8 e7 00 00 00       	call   800f1f <_panic>

00800e38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e51:	89 df                	mov    %ebx,%edi
  800e53:	89 de                	mov    %ebx,%esi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 0a                	push   $0xa
  800e69:	68 80 15 80 00       	push   $0x801580
  800e6e:	6a 43                	push   $0x43
  800e70:	68 9d 15 80 00       	push   $0x80159d
  800e75:	e8 a5 00 00 00       	call   800f1f <_panic>

00800e7a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8b:	be 00 00 00 00       	mov    $0x0,%esi
  800e90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e93:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e96:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb3:	89 cb                	mov    %ecx,%ebx
  800eb5:	89 cf                	mov    %ecx,%edi
  800eb7:	89 ce                	mov    %ecx,%esi
  800eb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	7f 08                	jg     800ec7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	50                   	push   %eax
  800ecb:	6a 0d                	push   $0xd
  800ecd:	68 80 15 80 00       	push   $0x801580
  800ed2:	6a 43                	push   $0x43
  800ed4:	68 9d 15 80 00       	push   $0x80159d
  800ed9:	e8 41 00 00 00       	call   800f1f <_panic>

00800ede <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef4:	89 df                	mov    %ebx,%edi
  800ef6:	89 de                	mov    %ebx,%esi
  800ef8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f12:	89 cb                	mov    %ecx,%ebx
  800f14:	89 cf                	mov    %ecx,%edi
  800f16:	89 ce                	mov    %ecx,%esi
  800f18:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f24:	a1 08 20 80 00       	mov    0x802008,%eax
  800f29:	8b 40 48             	mov    0x48(%eax),%eax
  800f2c:	83 ec 04             	sub    $0x4,%esp
  800f2f:	68 dc 15 80 00       	push   $0x8015dc
  800f34:	50                   	push   %eax
  800f35:	68 ab 15 80 00       	push   $0x8015ab
  800f3a:	e8 5d f2 ff ff       	call   80019c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f3f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f42:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f48:	e8 62 fd ff ff       	call   800caf <sys_getenvid>
  800f4d:	83 c4 04             	add    $0x4,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	ff 75 08             	pushl  0x8(%ebp)
  800f56:	56                   	push   %esi
  800f57:	50                   	push   %eax
  800f58:	68 b8 15 80 00       	push   $0x8015b8
  800f5d:	e8 3a f2 ff ff       	call   80019c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f62:	83 c4 18             	add    $0x18,%esp
  800f65:	53                   	push   %ebx
  800f66:	ff 75 10             	pushl  0x10(%ebp)
  800f69:	e8 dd f1 ff ff       	call   80014b <vcprintf>
	cprintf("\n");
  800f6e:	c7 04 24 ec 11 80 00 	movl   $0x8011ec,(%esp)
  800f75:	e8 22 f2 ff ff       	call   80019c <cprintf>
  800f7a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f7d:	cc                   	int3   
  800f7e:	eb fd                	jmp    800f7d <_panic+0x5e>

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
