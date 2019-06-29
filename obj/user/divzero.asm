
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
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 00 25 80 00       	push   $0x802500
  800056:	e8 17 01 00 00       	call   800172 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80006b:	e8 15 0c 00 00       	call   800c85 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80007b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800080:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 db                	test   %ebx,%ebx
  800087:	7e 07                	jle    800090 <libmain+0x30>
		binaryname = argv[0];
  800089:	8b 06                	mov    (%esi),%eax
  80008b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	53                   	push   %ebx
  800095:	e8 99 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009a:	e8 0a 00 00 00       	call   8000a9 <exit>
}
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a5:	5b                   	pop    %ebx
  8000a6:	5e                   	pop    %esi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    

008000a9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000af:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	68 24 25 80 00       	push   $0x802524
  8000bc:	50                   	push   %eax
  8000bd:	68 18 25 80 00       	push   $0x802518
  8000c2:	e8 ab 00 00 00       	call   800172 <cprintf>
	close_all();
  8000c7:	e8 c4 10 00 00       	call   801190 <close_all>
	sys_env_destroy(0);
  8000cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d3:	e8 6c 0b 00 00       	call   800c44 <sys_env_destroy>
}
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 04             	sub    $0x4,%esp
  8000e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e7:	8b 13                	mov    (%ebx),%edx
  8000e9:	8d 42 01             	lea    0x1(%edx),%eax
  8000ec:	89 03                	mov    %eax,(%ebx)
  8000ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fa:	74 09                	je     800105 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800103:	c9                   	leave  
  800104:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800105:	83 ec 08             	sub    $0x8,%esp
  800108:	68 ff 00 00 00       	push   $0xff
  80010d:	8d 43 08             	lea    0x8(%ebx),%eax
  800110:	50                   	push   %eax
  800111:	e8 f1 0a 00 00       	call   800c07 <sys_cputs>
		b->idx = 0;
  800116:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	eb db                	jmp    8000fc <putch+0x1f>

00800121 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800131:	00 00 00 
	b.cnt = 0;
  800134:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80013e:	ff 75 0c             	pushl  0xc(%ebp)
  800141:	ff 75 08             	pushl  0x8(%ebp)
  800144:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014a:	50                   	push   %eax
  80014b:	68 dd 00 80 00       	push   $0x8000dd
  800150:	e8 4a 01 00 00       	call   80029f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800155:	83 c4 08             	add    $0x8,%esp
  800158:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80015e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	e8 9d 0a 00 00       	call   800c07 <sys_cputs>

	return b.cnt;
}
  80016a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800178:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017b:	50                   	push   %eax
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	e8 9d ff ff ff       	call   800121 <vcprintf>
	va_end(ap);

	return cnt;
}
  800184:	c9                   	leave  
  800185:	c3                   	ret    

00800186 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	57                   	push   %edi
  80018a:	56                   	push   %esi
  80018b:	53                   	push   %ebx
  80018c:	83 ec 1c             	sub    $0x1c,%esp
  80018f:	89 c6                	mov    %eax,%esi
  800191:	89 d7                	mov    %edx,%edi
  800193:	8b 45 08             	mov    0x8(%ebp),%eax
  800196:	8b 55 0c             	mov    0xc(%ebp),%edx
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80019c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80019f:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001a5:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001a9:	74 2c                	je     8001d7 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001bb:	39 c2                	cmp    %eax,%edx
  8001bd:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001c0:	73 43                	jae    800205 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001c2:	83 eb 01             	sub    $0x1,%ebx
  8001c5:	85 db                	test   %ebx,%ebx
  8001c7:	7e 6c                	jle    800235 <printnum+0xaf>
				putch(padc, putdat);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	57                   	push   %edi
  8001cd:	ff 75 18             	pushl  0x18(%ebp)
  8001d0:	ff d6                	call   *%esi
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	eb eb                	jmp    8001c2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	6a 20                	push   $0x20
  8001dc:	6a 00                	push   $0x0
  8001de:	50                   	push   %eax
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e5:	89 fa                	mov    %edi,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	e8 98 ff ff ff       	call   800186 <printnum>
		while (--width > 0)
  8001ee:	83 c4 20             	add    $0x20,%esp
  8001f1:	83 eb 01             	sub    $0x1,%ebx
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 65                	jle    80025d <printnum+0xd7>
			putch(padc, putdat);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	57                   	push   %edi
  8001fc:	6a 20                	push   $0x20
  8001fe:	ff d6                	call   *%esi
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	eb ec                	jmp    8001f1 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	ff 75 18             	pushl  0x18(%ebp)
  80020b:	83 eb 01             	sub    $0x1,%ebx
  80020e:	53                   	push   %ebx
  80020f:	50                   	push   %eax
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	ff 75 dc             	pushl  -0x24(%ebp)
  800216:	ff 75 d8             	pushl  -0x28(%ebp)
  800219:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021c:	ff 75 e0             	pushl  -0x20(%ebp)
  80021f:	e8 8c 20 00 00       	call   8022b0 <__udivdi3>
  800224:	83 c4 18             	add    $0x18,%esp
  800227:	52                   	push   %edx
  800228:	50                   	push   %eax
  800229:	89 fa                	mov    %edi,%edx
  80022b:	89 f0                	mov    %esi,%eax
  80022d:	e8 54 ff ff ff       	call   800186 <printnum>
  800232:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	57                   	push   %edi
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	ff 75 dc             	pushl  -0x24(%ebp)
  80023f:	ff 75 d8             	pushl  -0x28(%ebp)
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	e8 73 21 00 00       	call   8023c0 <__umoddi3>
  80024d:	83 c4 14             	add    $0x14,%esp
  800250:	0f be 80 29 25 80 00 	movsbl 0x802529(%eax),%eax
  800257:	50                   	push   %eax
  800258:	ff d6                	call   *%esi
  80025a:	83 c4 10             	add    $0x10,%esp
	}
}
  80025d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800260:	5b                   	pop    %ebx
  800261:	5e                   	pop    %esi
  800262:	5f                   	pop    %edi
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    

00800265 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80026b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80026f:	8b 10                	mov    (%eax),%edx
  800271:	3b 50 04             	cmp    0x4(%eax),%edx
  800274:	73 0a                	jae    800280 <sprintputch+0x1b>
		*b->buf++ = ch;
  800276:	8d 4a 01             	lea    0x1(%edx),%ecx
  800279:	89 08                	mov    %ecx,(%eax)
  80027b:	8b 45 08             	mov    0x8(%ebp),%eax
  80027e:	88 02                	mov    %al,(%edx)
}
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <printfmt>:
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800288:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80028b:	50                   	push   %eax
  80028c:	ff 75 10             	pushl  0x10(%ebp)
  80028f:	ff 75 0c             	pushl  0xc(%ebp)
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 05 00 00 00       	call   80029f <vprintfmt>
}
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <vprintfmt>:
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 3c             	sub    $0x3c,%esp
  8002a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b1:	e9 32 04 00 00       	jmp    8006e8 <vprintfmt+0x449>
		padc = ' ';
  8002b6:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002ba:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002c1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002dd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e2:	8d 47 01             	lea    0x1(%edi),%eax
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e8:	0f b6 17             	movzbl (%edi),%edx
  8002eb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ee:	3c 55                	cmp    $0x55,%al
  8002f0:	0f 87 12 05 00 00    	ja     800808 <vprintfmt+0x569>
  8002f6:	0f b6 c0             	movzbl %al,%eax
  8002f9:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800303:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800307:	eb d9                	jmp    8002e2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80030c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800310:	eb d0                	jmp    8002e2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800312:	0f b6 d2             	movzbl %dl,%edx
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	89 75 08             	mov    %esi,0x8(%ebp)
  800320:	eb 03                	jmp    800325 <vprintfmt+0x86>
  800322:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800332:	83 fe 09             	cmp    $0x9,%esi
  800335:	76 eb                	jbe    800322 <vprintfmt+0x83>
  800337:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033a:	8b 75 08             	mov    0x8(%ebp),%esi
  80033d:	eb 14                	jmp    800353 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80033f:	8b 45 14             	mov    0x14(%ebp),%eax
  800342:	8b 00                	mov    (%eax),%eax
  800344:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	8d 40 04             	lea    0x4(%eax),%eax
  80034d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800353:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800357:	79 89                	jns    8002e2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800359:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800366:	e9 77 ff ff ff       	jmp    8002e2 <vprintfmt+0x43>
  80036b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036e:	85 c0                	test   %eax,%eax
  800370:	0f 48 c1             	cmovs  %ecx,%eax
  800373:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800379:	e9 64 ff ff ff       	jmp    8002e2 <vprintfmt+0x43>
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800381:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800388:	e9 55 ff ff ff       	jmp    8002e2 <vprintfmt+0x43>
			lflag++;
  80038d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800394:	e9 49 ff ff ff       	jmp    8002e2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	8d 78 04             	lea    0x4(%eax),%edi
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	53                   	push   %ebx
  8003a3:	ff 30                	pushl  (%eax)
  8003a5:	ff d6                	call   *%esi
			break;
  8003a7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003aa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ad:	e9 33 03 00 00       	jmp    8006e5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 78 04             	lea    0x4(%eax),%edi
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	99                   	cltd   
  8003bb:	31 d0                	xor    %edx,%eax
  8003bd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bf:	83 f8 11             	cmp    $0x11,%eax
  8003c2:	7f 23                	jg     8003e7 <vprintfmt+0x148>
  8003c4:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003cb:	85 d2                	test   %edx,%edx
  8003cd:	74 18                	je     8003e7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003cf:	52                   	push   %edx
  8003d0:	68 7d 29 80 00       	push   $0x80297d
  8003d5:	53                   	push   %ebx
  8003d6:	56                   	push   %esi
  8003d7:	e8 a6 fe ff ff       	call   800282 <printfmt>
  8003dc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003df:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e2:	e9 fe 02 00 00       	jmp    8006e5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003e7:	50                   	push   %eax
  8003e8:	68 41 25 80 00       	push   $0x802541
  8003ed:	53                   	push   %ebx
  8003ee:	56                   	push   %esi
  8003ef:	e8 8e fe ff ff       	call   800282 <printfmt>
  8003f4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003fa:	e9 e6 02 00 00       	jmp    8006e5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800402:	83 c0 04             	add    $0x4,%eax
  800405:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80040d:	85 c9                	test   %ecx,%ecx
  80040f:	b8 3a 25 80 00       	mov    $0x80253a,%eax
  800414:	0f 45 c1             	cmovne %ecx,%eax
  800417:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80041a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041e:	7e 06                	jle    800426 <vprintfmt+0x187>
  800420:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800424:	75 0d                	jne    800433 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800426:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	03 45 e0             	add    -0x20(%ebp),%eax
  80042e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800431:	eb 53                	jmp    800486 <vprintfmt+0x1e7>
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 d8             	pushl  -0x28(%ebp)
  800439:	50                   	push   %eax
  80043a:	e8 71 04 00 00       	call   8008b0 <strnlen>
  80043f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800442:	29 c1                	sub    %eax,%ecx
  800444:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80044c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800450:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	eb 0f                	jmp    800464 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ef 01             	sub    $0x1,%edi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	85 ff                	test   %edi,%edi
  800466:	7f ed                	jg     800455 <vprintfmt+0x1b6>
  800468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80046b:	85 c9                	test   %ecx,%ecx
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	0f 49 c1             	cmovns %ecx,%eax
  800475:	29 c1                	sub    %eax,%ecx
  800477:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80047a:	eb aa                	jmp    800426 <vprintfmt+0x187>
					putch(ch, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	52                   	push   %edx
  800481:	ff d6                	call   *%esi
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800489:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048b:	83 c7 01             	add    $0x1,%edi
  80048e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800492:	0f be d0             	movsbl %al,%edx
  800495:	85 d2                	test   %edx,%edx
  800497:	74 4b                	je     8004e4 <vprintfmt+0x245>
  800499:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049d:	78 06                	js     8004a5 <vprintfmt+0x206>
  80049f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a3:	78 1e                	js     8004c3 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004a9:	74 d1                	je     80047c <vprintfmt+0x1dd>
  8004ab:	0f be c0             	movsbl %al,%eax
  8004ae:	83 e8 20             	sub    $0x20,%eax
  8004b1:	83 f8 5e             	cmp    $0x5e,%eax
  8004b4:	76 c6                	jbe    80047c <vprintfmt+0x1dd>
					putch('?', putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	6a 3f                	push   $0x3f
  8004bc:	ff d6                	call   *%esi
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	eb c3                	jmp    800486 <vprintfmt+0x1e7>
  8004c3:	89 cf                	mov    %ecx,%edi
  8004c5:	eb 0e                	jmp    8004d5 <vprintfmt+0x236>
				putch(' ', putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	53                   	push   %ebx
  8004cb:	6a 20                	push   $0x20
  8004cd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004cf:	83 ef 01             	sub    $0x1,%edi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	85 ff                	test   %edi,%edi
  8004d7:	7f ee                	jg     8004c7 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004df:	e9 01 02 00 00       	jmp    8006e5 <vprintfmt+0x446>
  8004e4:	89 cf                	mov    %ecx,%edi
  8004e6:	eb ed                	jmp    8004d5 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004eb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004f2:	e9 eb fd ff ff       	jmp    8002e2 <vprintfmt+0x43>
	if (lflag >= 2)
  8004f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004fb:	7f 21                	jg     80051e <vprintfmt+0x27f>
	else if (lflag)
  8004fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800501:	74 68                	je     80056b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80050b:	89 c1                	mov    %eax,%ecx
  80050d:	c1 f9 1f             	sar    $0x1f,%ecx
  800510:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8d 40 04             	lea    0x4(%eax),%eax
  800519:	89 45 14             	mov    %eax,0x14(%ebp)
  80051c:	eb 17                	jmp    800535 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800529:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 08             	lea    0x8(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800535:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80053b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800541:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800545:	78 3f                	js     800586 <vprintfmt+0x2e7>
			base = 10;
  800547:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80054c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800550:	0f 84 71 01 00 00    	je     8006c7 <vprintfmt+0x428>
				putch('+', putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	6a 2b                	push   $0x2b
  80055c:	ff d6                	call   *%esi
  80055e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
  800566:	e9 5c 01 00 00       	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800573:	89 c1                	mov    %eax,%ecx
  800575:	c1 f9 1f             	sar    $0x1f,%ecx
  800578:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 40 04             	lea    0x4(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	eb af                	jmp    800535 <vprintfmt+0x296>
				putch('-', putdat);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	53                   	push   %ebx
  80058a:	6a 2d                	push   $0x2d
  80058c:	ff d6                	call   *%esi
				num = -(long long) num;
  80058e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800591:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800594:	f7 d8                	neg    %eax
  800596:	83 d2 00             	adc    $0x0,%edx
  800599:	f7 da                	neg    %edx
  80059b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 19 01 00 00       	jmp    8006c7 <vprintfmt+0x428>
	if (lflag >= 2)
  8005ae:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b2:	7f 29                	jg     8005dd <vprintfmt+0x33e>
	else if (lflag)
  8005b4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005b8:	74 44                	je     8005fe <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d8:	e9 ea 00 00 00       	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 50 04             	mov    0x4(%eax),%edx
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 40 08             	lea    0x8(%eax),%eax
  8005f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f9:	e9 c9 00 00 00       	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	ba 00 00 00 00       	mov    $0x0,%edx
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800617:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061c:	e9 a6 00 00 00       	jmp    8006c7 <vprintfmt+0x428>
			putch('0', putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	53                   	push   %ebx
  800625:	6a 30                	push   $0x30
  800627:	ff d6                	call   *%esi
	if (lflag >= 2)
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800630:	7f 26                	jg     800658 <vprintfmt+0x3b9>
	else if (lflag)
  800632:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800636:	74 3e                	je     800676 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800651:	b8 08 00 00 00       	mov    $0x8,%eax
  800656:	eb 6f                	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 50 04             	mov    0x4(%eax),%edx
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 08             	lea    0x8(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066f:	b8 08 00 00 00       	mov    $0x8,%eax
  800674:	eb 51                	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068f:	b8 08 00 00 00       	mov    $0x8,%eax
  800694:	eb 31                	jmp    8006c7 <vprintfmt+0x428>
			putch('0', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 30                	push   $0x30
  80069c:	ff d6                	call   *%esi
			putch('x', putdat);
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	6a 78                	push   $0x78
  8006a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006ce:	52                   	push   %edx
  8006cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d9:	89 da                	mov    %ebx,%edx
  8006db:	89 f0                	mov    %esi,%eax
  8006dd:	e8 a4 fa ff ff       	call   800186 <printnum>
			break;
  8006e2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e8:	83 c7 01             	add    $0x1,%edi
  8006eb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ef:	83 f8 25             	cmp    $0x25,%eax
  8006f2:	0f 84 be fb ff ff    	je     8002b6 <vprintfmt+0x17>
			if (ch == '\0')
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	0f 84 28 01 00 00    	je     800828 <vprintfmt+0x589>
			putch(ch, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	50                   	push   %eax
  800705:	ff d6                	call   *%esi
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	eb dc                	jmp    8006e8 <vprintfmt+0x449>
	if (lflag >= 2)
  80070c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800710:	7f 26                	jg     800738 <vprintfmt+0x499>
	else if (lflag)
  800712:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800716:	74 41                	je     800759 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800731:	b8 10 00 00 00       	mov    $0x10,%eax
  800736:	eb 8f                	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 50 04             	mov    0x4(%eax),%edx
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 08             	lea    0x8(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074f:	b8 10 00 00 00       	mov    $0x10,%eax
  800754:	e9 6e ff ff ff       	jmp    8006c7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	b8 10 00 00 00       	mov    $0x10,%eax
  800777:	e9 4b ff ff ff       	jmp    8006c7 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 c0 04             	add    $0x4,%eax
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	85 c0                	test   %eax,%eax
  80078c:	74 14                	je     8007a2 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80078e:	8b 13                	mov    (%ebx),%edx
  800790:	83 fa 7f             	cmp    $0x7f,%edx
  800793:	7f 37                	jg     8007cc <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800795:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800797:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
  80079d:	e9 43 ff ff ff       	jmp    8006e5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a7:	bf 5d 26 80 00       	mov    $0x80265d,%edi
							putch(ch, putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	50                   	push   %eax
  8007b1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b3:	83 c7 01             	add    $0x1,%edi
  8007b6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	75 eb                	jne    8007ac <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c7:	e9 19 ff ff ff       	jmp    8006e5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007cc:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d3:	bf 95 26 80 00       	mov    $0x802695,%edi
							putch(ch, putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	53                   	push   %ebx
  8007dc:	50                   	push   %eax
  8007dd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007df:	83 c7 01             	add    $0x1,%edi
  8007e2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	75 eb                	jne    8007d8 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f3:	e9 ed fe ff ff       	jmp    8006e5 <vprintfmt+0x446>
			putch(ch, putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	6a 25                	push   $0x25
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	e9 dd fe ff ff       	jmp    8006e5 <vprintfmt+0x446>
			putch('%', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 25                	push   $0x25
  80080e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 f8                	mov    %edi,%eax
  800815:	eb 03                	jmp    80081a <vprintfmt+0x57b>
  800817:	83 e8 01             	sub    $0x1,%eax
  80081a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081e:	75 f7                	jne    800817 <vprintfmt+0x578>
  800820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800823:	e9 bd fe ff ff       	jmp    8006e5 <vprintfmt+0x446>
}
  800828:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80082b:	5b                   	pop    %ebx
  80082c:	5e                   	pop    %esi
  80082d:	5f                   	pop    %edi
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800843:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 26                	je     800877 <vsnprintf+0x47>
  800851:	85 d2                	test   %edx,%edx
  800853:	7e 22                	jle    800877 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800855:	ff 75 14             	pushl  0x14(%ebp)
  800858:	ff 75 10             	pushl  0x10(%ebp)
  80085b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	68 65 02 80 00       	push   $0x800265
  800864:	e8 36 fa ff ff       	call   80029f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800872:	83 c4 10             	add    $0x10,%esp
}
  800875:	c9                   	leave  
  800876:	c3                   	ret    
		return -E_INVAL;
  800877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087c:	eb f7                	jmp    800875 <vsnprintf+0x45>

0080087e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800884:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800887:	50                   	push   %eax
  800888:	ff 75 10             	pushl  0x10(%ebp)
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	ff 75 08             	pushl  0x8(%ebp)
  800891:	e8 9a ff ff ff       	call   800830 <vsnprintf>
	va_end(ap);

	return rc;
}
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a7:	74 05                	je     8008ae <strlen+0x16>
		n++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	eb f5                	jmp    8008a3 <strlen+0xb>
	return n;
}
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	39 c2                	cmp    %eax,%edx
  8008c0:	74 0d                	je     8008cf <strnlen+0x1f>
  8008c2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008c6:	74 05                	je     8008cd <strnlen+0x1d>
		n++;
  8008c8:	83 c2 01             	add    $0x1,%edx
  8008cb:	eb f1                	jmp    8008be <strnlen+0xe>
  8008cd:	89 d0                	mov    %edx,%eax
	return n;
}
  8008cf:	5d                   	pop    %ebp
  8008d0:	c3                   	ret    

008008d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	53                   	push   %ebx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008e7:	83 c2 01             	add    $0x1,%edx
  8008ea:	84 c9                	test   %cl,%cl
  8008ec:	75 f2                	jne    8008e0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	83 ec 10             	sub    $0x10,%esp
  8008f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008fb:	53                   	push   %ebx
  8008fc:	e8 97 ff ff ff       	call   800898 <strlen>
  800901:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	01 d8                	add    %ebx,%eax
  800909:	50                   	push   %eax
  80090a:	e8 c2 ff ff ff       	call   8008d1 <strcpy>
	return dst;
}
  80090f:	89 d8                	mov    %ebx,%eax
  800911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800921:	89 c6                	mov    %eax,%esi
  800923:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800926:	89 c2                	mov    %eax,%edx
  800928:	39 f2                	cmp    %esi,%edx
  80092a:	74 11                	je     80093d <strncpy+0x27>
		*dst++ = *src;
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	0f b6 19             	movzbl (%ecx),%ebx
  800932:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800935:	80 fb 01             	cmp    $0x1,%bl
  800938:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80093b:	eb eb                	jmp    800928 <strncpy+0x12>
	}
	return ret;
}
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	8b 75 08             	mov    0x8(%ebp),%esi
  800949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094c:	8b 55 10             	mov    0x10(%ebp),%edx
  80094f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800951:	85 d2                	test   %edx,%edx
  800953:	74 21                	je     800976 <strlcpy+0x35>
  800955:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800959:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80095b:	39 c2                	cmp    %eax,%edx
  80095d:	74 14                	je     800973 <strlcpy+0x32>
  80095f:	0f b6 19             	movzbl (%ecx),%ebx
  800962:	84 db                	test   %bl,%bl
  800964:	74 0b                	je     800971 <strlcpy+0x30>
			*dst++ = *src++;
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80096f:	eb ea                	jmp    80095b <strlcpy+0x1a>
  800971:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800973:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	0f b6 01             	movzbl (%ecx),%eax
  800988:	84 c0                	test   %al,%al
  80098a:	74 0c                	je     800998 <strcmp+0x1c>
  80098c:	3a 02                	cmp    (%edx),%al
  80098e:	75 08                	jne    800998 <strcmp+0x1c>
		p++, q++;
  800990:	83 c1 01             	add    $0x1,%ecx
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	eb ed                	jmp    800985 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 16                	je     8009d3 <strncmp+0x31>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    
		return 0;
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	eb f6                	jmp    8009d0 <strncmp+0x2e>

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
  8009e7:	84 d2                	test   %dl,%dl
  8009e9:	74 09                	je     8009f4 <strchr+0x1a>
		if (*s == c)
  8009eb:	38 ca                	cmp    %cl,%dl
  8009ed:	74 0a                	je     8009f9 <strchr+0x1f>
	for (; *s; s++)
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	eb f0                	jmp    8009e4 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a08:	38 ca                	cmp    %cl,%dl
  800a0a:	74 09                	je     800a15 <strfind+0x1a>
  800a0c:	84 d2                	test   %dl,%dl
  800a0e:	74 05                	je     800a15 <strfind+0x1a>
	for (; *s; s++)
  800a10:	83 c0 01             	add    $0x1,%eax
  800a13:	eb f0                	jmp    800a05 <strfind+0xa>
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 31                	je     800a58 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	89 f8                	mov    %edi,%eax
  800a29:	09 c8                	or     %ecx,%eax
  800a2b:	a8 03                	test   $0x3,%al
  800a2d:	75 23                	jne    800a52 <memset+0x3b>
		c &= 0xFF;
  800a2f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a33:	89 d3                	mov    %edx,%ebx
  800a35:	c1 e3 08             	shl    $0x8,%ebx
  800a38:	89 d0                	mov    %edx,%eax
  800a3a:	c1 e0 18             	shl    $0x18,%eax
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 10             	shl    $0x10,%esi
  800a42:	09 f0                	or     %esi,%eax
  800a44:	09 c2                	or     %eax,%edx
  800a46:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a48:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	fc                   	cld    
  800a4e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a50:	eb 06                	jmp    800a58 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	fc                   	cld    
  800a56:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a58:	89 f8                	mov    %edi,%eax
  800a5a:	5b                   	pop    %ebx
  800a5b:	5e                   	pop    %esi
  800a5c:	5f                   	pop    %edi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a6d:	39 c6                	cmp    %eax,%esi
  800a6f:	73 32                	jae    800aa3 <memmove+0x44>
  800a71:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a74:	39 c2                	cmp    %eax,%edx
  800a76:	76 2b                	jbe    800aa3 <memmove+0x44>
		s += n;
		d += n;
  800a78:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7b:	89 fe                	mov    %edi,%esi
  800a7d:	09 ce                	or     %ecx,%esi
  800a7f:	09 d6                	or     %edx,%esi
  800a81:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a87:	75 0e                	jne    800a97 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a89:	83 ef 04             	sub    $0x4,%edi
  800a8c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a8f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a92:	fd                   	std    
  800a93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a95:	eb 09                	jmp    800aa0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a97:	83 ef 01             	sub    $0x1,%edi
  800a9a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a9d:	fd                   	std    
  800a9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa0:	fc                   	cld    
  800aa1:	eb 1a                	jmp    800abd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	09 ca                	or     %ecx,%edx
  800aa7:	09 f2                	or     %esi,%edx
  800aa9:	f6 c2 03             	test   $0x3,%dl
  800aac:	75 0a                	jne    800ab8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ab1:	89 c7                	mov    %eax,%edi
  800ab3:	fc                   	cld    
  800ab4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab6:	eb 05                	jmp    800abd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ab8:	89 c7                	mov    %eax,%edi
  800aba:	fc                   	cld    
  800abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac7:	ff 75 10             	pushl  0x10(%ebp)
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 8a ff ff ff       	call   800a5f <memmove>
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae2:	89 c6                	mov    %eax,%esi
  800ae4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae7:	39 f0                	cmp    %esi,%eax
  800ae9:	74 1c                	je     800b07 <memcmp+0x30>
		if (*s1 != *s2)
  800aeb:	0f b6 08             	movzbl (%eax),%ecx
  800aee:	0f b6 1a             	movzbl (%edx),%ebx
  800af1:	38 d9                	cmp    %bl,%cl
  800af3:	75 08                	jne    800afd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	83 c2 01             	add    $0x1,%edx
  800afb:	eb ea                	jmp    800ae7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800afd:	0f b6 c1             	movzbl %cl,%eax
  800b00:	0f b6 db             	movzbl %bl,%ebx
  800b03:	29 d8                	sub    %ebx,%eax
  800b05:	eb 05                	jmp    800b0c <memcmp+0x35>
	}

	return 0;
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b19:	89 c2                	mov    %eax,%edx
  800b1b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b1e:	39 d0                	cmp    %edx,%eax
  800b20:	73 09                	jae    800b2b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b22:	38 08                	cmp    %cl,(%eax)
  800b24:	74 05                	je     800b2b <memfind+0x1b>
	for (; s < ends; s++)
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	eb f3                	jmp    800b1e <memfind+0xe>
			break;
	return (void *) s;
}
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
  800b33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b39:	eb 03                	jmp    800b3e <strtol+0x11>
		s++;
  800b3b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3e:	0f b6 01             	movzbl (%ecx),%eax
  800b41:	3c 20                	cmp    $0x20,%al
  800b43:	74 f6                	je     800b3b <strtol+0xe>
  800b45:	3c 09                	cmp    $0x9,%al
  800b47:	74 f2                	je     800b3b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b49:	3c 2b                	cmp    $0x2b,%al
  800b4b:	74 2a                	je     800b77 <strtol+0x4a>
	int neg = 0;
  800b4d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b52:	3c 2d                	cmp    $0x2d,%al
  800b54:	74 2b                	je     800b81 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b56:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5c:	75 0f                	jne    800b6d <strtol+0x40>
  800b5e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b61:	74 28                	je     800b8b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b6a:	0f 44 d8             	cmove  %eax,%ebx
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b72:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b75:	eb 50                	jmp    800bc7 <strtol+0x9a>
		s++;
  800b77:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7f:	eb d5                	jmp    800b56 <strtol+0x29>
		s++, neg = 1;
  800b81:	83 c1 01             	add    $0x1,%ecx
  800b84:	bf 01 00 00 00       	mov    $0x1,%edi
  800b89:	eb cb                	jmp    800b56 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8f:	74 0e                	je     800b9f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	75 d8                	jne    800b6d <strtol+0x40>
		s++, base = 8;
  800b95:	83 c1 01             	add    $0x1,%ecx
  800b98:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b9d:	eb ce                	jmp    800b6d <strtol+0x40>
		s += 2, base = 16;
  800b9f:	83 c1 02             	add    $0x2,%ecx
  800ba2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba7:	eb c4                	jmp    800b6d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ba9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bac:	89 f3                	mov    %esi,%ebx
  800bae:	80 fb 19             	cmp    $0x19,%bl
  800bb1:	77 29                	ja     800bdc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb3:	0f be d2             	movsbl %dl,%edx
  800bb6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bb9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bbc:	7d 30                	jge    800bee <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bc5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bc7:	0f b6 11             	movzbl (%ecx),%edx
  800bca:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bcd:	89 f3                	mov    %esi,%ebx
  800bcf:	80 fb 09             	cmp    $0x9,%bl
  800bd2:	77 d5                	ja     800ba9 <strtol+0x7c>
			dig = *s - '0';
  800bd4:	0f be d2             	movsbl %dl,%edx
  800bd7:	83 ea 30             	sub    $0x30,%edx
  800bda:	eb dd                	jmp    800bb9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bdc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 19             	cmp    $0x19,%bl
  800be4:	77 08                	ja     800bee <strtol+0xc1>
			dig = *s - 'A' + 10;
  800be6:	0f be d2             	movsbl %dl,%edx
  800be9:	83 ea 37             	sub    $0x37,%edx
  800bec:	eb cb                	jmp    800bb9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf2:	74 05                	je     800bf9 <strtol+0xcc>
		*endptr = (char *) s;
  800bf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	f7 da                	neg    %edx
  800bfd:	85 ff                	test   %edi,%edi
  800bff:	0f 45 c2             	cmovne %edx,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	89 c6                	mov    %eax,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 01 00 00 00       	mov    $0x1,%eax
  800c35:	89 d1                	mov    %edx,%ecx
  800c37:	89 d3                	mov    %edx,%ebx
  800c39:	89 d7                	mov    %edx,%edi
  800c3b:	89 d6                	mov    %edx,%esi
  800c3d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5a:	89 cb                	mov    %ecx,%ebx
  800c5c:	89 cf                	mov    %ecx,%edi
  800c5e:	89 ce                	mov    %ecx,%esi
  800c60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c62:	85 c0                	test   %eax,%eax
  800c64:	7f 08                	jg     800c6e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 03                	push   $0x3
  800c74:	68 a8 28 80 00       	push   $0x8028a8
  800c79:	6a 43                	push   $0x43
  800c7b:	68 c5 28 80 00       	push   $0x8028c5
  800c80:	e8 89 14 00 00       	call   80210e <_panic>

00800c85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	b8 02 00 00 00       	mov    $0x2,%eax
  800c95:	89 d1                	mov    %edx,%ecx
  800c97:	89 d3                	mov    %edx,%ebx
  800c99:	89 d7                	mov    %edx,%edi
  800c9b:	89 d6                	mov    %edx,%esi
  800c9d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_yield>:

void
sys_yield(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	be 00 00 00 00       	mov    $0x0,%esi
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdf:	89 f7                	mov    %esi,%edi
  800ce1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 04                	push   $0x4
  800cf5:	68 a8 28 80 00       	push   $0x8028a8
  800cfa:	6a 43                	push   $0x43
  800cfc:	68 c5 28 80 00       	push   $0x8028c5
  800d01:	e8 08 14 00 00       	call   80210e <_panic>

00800d06 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d15:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d20:	8b 75 18             	mov    0x18(%ebp),%esi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 05                	push   $0x5
  800d37:	68 a8 28 80 00       	push   $0x8028a8
  800d3c:	6a 43                	push   $0x43
  800d3e:	68 c5 28 80 00       	push   $0x8028c5
  800d43:	e8 c6 13 00 00       	call   80210e <_panic>

00800d48 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d61:	89 df                	mov    %ebx,%edi
  800d63:	89 de                	mov    %ebx,%esi
  800d65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 06                	push   $0x6
  800d79:	68 a8 28 80 00       	push   $0x8028a8
  800d7e:	6a 43                	push   $0x43
  800d80:	68 c5 28 80 00       	push   $0x8028c5
  800d85:	e8 84 13 00 00       	call   80210e <_panic>

00800d8a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 08                	push   $0x8
  800dbb:	68 a8 28 80 00       	push   $0x8028a8
  800dc0:	6a 43                	push   $0x43
  800dc2:	68 c5 28 80 00       	push   $0x8028c5
  800dc7:	e8 42 13 00 00       	call   80210e <_panic>

00800dcc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 09 00 00 00       	mov    $0x9,%eax
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 09                	push   $0x9
  800dfd:	68 a8 28 80 00       	push   $0x8028a8
  800e02:	6a 43                	push   $0x43
  800e04:	68 c5 28 80 00       	push   $0x8028c5
  800e09:	e8 00 13 00 00       	call   80210e <_panic>

00800e0e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 0a                	push   $0xa
  800e3f:	68 a8 28 80 00       	push   $0x8028a8
  800e44:	6a 43                	push   $0x43
  800e46:	68 c5 28 80 00       	push   $0x8028c5
  800e4b:	e8 be 12 00 00       	call   80210e <_panic>

00800e50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e61:	be 00 00 00 00       	mov    $0x0,%esi
  800e66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e69:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e6c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e89:	89 cb                	mov    %ecx,%ebx
  800e8b:	89 cf                	mov    %ecx,%edi
  800e8d:	89 ce                	mov    %ecx,%esi
  800e8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 0d                	push   $0xd
  800ea3:	68 a8 28 80 00       	push   $0x8028a8
  800ea8:	6a 43                	push   $0x43
  800eaa:	68 c5 28 80 00       	push   $0x8028c5
  800eaf:	e8 5a 12 00 00       	call   80210e <_panic>

00800eb4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eca:	89 df                	mov    %ebx,%edi
  800ecc:	89 de                	mov    %ebx,%esi
  800ece:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee8:	89 cb                	mov    %ecx,%ebx
  800eea:	89 cf                	mov    %ecx,%edi
  800eec:	89 ce                	mov    %ecx,%esi
  800eee:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efb:	ba 00 00 00 00       	mov    $0x0,%edx
  800f00:	b8 10 00 00 00       	mov    $0x10,%eax
  800f05:	89 d1                	mov    %edx,%ecx
  800f07:	89 d3                	mov    %edx,%ebx
  800f09:	89 d7                	mov    %edx,%edi
  800f0b:	89 d6                	mov    %edx,%esi
  800f0d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 11 00 00 00       	mov    $0x11,%eax
  800f2a:	89 df                	mov    %ebx,%edi
  800f2c:	89 de                	mov    %ebx,%esi
  800f2e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	b8 12 00 00 00       	mov    $0x12,%eax
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	89 de                	mov    %ebx,%esi
  800f4f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	b8 13 00 00 00       	mov    $0x13,%eax
  800f6f:	89 df                	mov    %ebx,%edi
  800f71:	89 de                	mov    %ebx,%esi
  800f73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7f 08                	jg     800f81 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f81:	83 ec 0c             	sub    $0xc,%esp
  800f84:	50                   	push   %eax
  800f85:	6a 13                	push   $0x13
  800f87:	68 a8 28 80 00       	push   $0x8028a8
  800f8c:	6a 43                	push   $0x43
  800f8e:	68 c5 28 80 00       	push   $0x8028c5
  800f93:	e8 76 11 00 00       	call   80210e <_panic>

00800f98 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	b8 14 00 00 00       	mov    $0x14,%eax
  800fab:	89 cb                	mov    %ecx,%ebx
  800fad:	89 cf                	mov    %ecx,%edi
  800faf:	89 ce                	mov    %ecx,%esi
  800fb1:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc3:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    

00800fc8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe7:	89 c2                	mov    %eax,%edx
  800fe9:	c1 ea 16             	shr    $0x16,%edx
  800fec:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff3:	f6 c2 01             	test   $0x1,%dl
  800ff6:	74 2d                	je     801025 <fd_alloc+0x46>
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	c1 ea 0c             	shr    $0xc,%edx
  800ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801004:	f6 c2 01             	test   $0x1,%dl
  801007:	74 1c                	je     801025 <fd_alloc+0x46>
  801009:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801013:	75 d2                	jne    800fe7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80101e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801023:	eb 0a                	jmp    80102f <fd_alloc+0x50>
			*fd_store = fd;
  801025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801028:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801037:	83 f8 1f             	cmp    $0x1f,%eax
  80103a:	77 30                	ja     80106c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80103c:	c1 e0 0c             	shl    $0xc,%eax
  80103f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801044:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80104a:	f6 c2 01             	test   $0x1,%dl
  80104d:	74 24                	je     801073 <fd_lookup+0x42>
  80104f:	89 c2                	mov    %eax,%edx
  801051:	c1 ea 0c             	shr    $0xc,%edx
  801054:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105b:	f6 c2 01             	test   $0x1,%dl
  80105e:	74 1a                	je     80107a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	89 02                	mov    %eax,(%edx)
	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    
		return -E_INVAL;
  80106c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801071:	eb f7                	jmp    80106a <fd_lookup+0x39>
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb f0                	jmp    80106a <fd_lookup+0x39>
  80107a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107f:	eb e9                	jmp    80106a <fd_lookup+0x39>

00801081 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801094:	39 08                	cmp    %ecx,(%eax)
  801096:	74 38                	je     8010d0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801098:	83 c2 01             	add    $0x1,%edx
  80109b:	8b 04 95 50 29 80 00 	mov    0x802950(,%edx,4),%eax
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 ee                	jne    801094 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010a6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8010ab:	8b 40 48             	mov    0x48(%eax),%eax
  8010ae:	83 ec 04             	sub    $0x4,%esp
  8010b1:	51                   	push   %ecx
  8010b2:	50                   	push   %eax
  8010b3:	68 d4 28 80 00       	push   $0x8028d4
  8010b8:	e8 b5 f0 ff ff       	call   800172 <cprintf>
	*dev = 0;
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    
			*dev = devtab[i];
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb f2                	jmp    8010ce <dev_lookup+0x4d>

008010dc <fd_close>:
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 24             	sub    $0x24,%esp
  8010e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ee:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ef:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f8:	50                   	push   %eax
  8010f9:	e8 33 ff ff ff       	call   801031 <fd_lookup>
  8010fe:	89 c3                	mov    %eax,%ebx
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	85 c0                	test   %eax,%eax
  801105:	78 05                	js     80110c <fd_close+0x30>
	    || fd != fd2)
  801107:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80110a:	74 16                	je     801122 <fd_close+0x46>
		return (must_exist ? r : 0);
  80110c:	89 f8                	mov    %edi,%eax
  80110e:	84 c0                	test   %al,%al
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	0f 44 d8             	cmove  %eax,%ebx
}
  801118:	89 d8                	mov    %ebx,%eax
  80111a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5f                   	pop    %edi
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801128:	50                   	push   %eax
  801129:	ff 36                	pushl  (%esi)
  80112b:	e8 51 ff ff ff       	call   801081 <dev_lookup>
  801130:	89 c3                	mov    %eax,%ebx
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	78 1a                	js     801153 <fd_close+0x77>
		if (dev->dev_close)
  801139:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80113c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80113f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801144:	85 c0                	test   %eax,%eax
  801146:	74 0b                	je     801153 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	56                   	push   %esi
  80114c:	ff d0                	call   *%eax
  80114e:	89 c3                	mov    %eax,%ebx
  801150:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801153:	83 ec 08             	sub    $0x8,%esp
  801156:	56                   	push   %esi
  801157:	6a 00                	push   $0x0
  801159:	e8 ea fb ff ff       	call   800d48 <sys_page_unmap>
	return r;
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	eb b5                	jmp    801118 <fd_close+0x3c>

00801163 <close>:

int
close(int fdnum)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801169:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	ff 75 08             	pushl  0x8(%ebp)
  801170:	e8 bc fe ff ff       	call   801031 <fd_lookup>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	79 02                	jns    80117e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    
		return fd_close(fd, 1);
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	6a 01                	push   $0x1
  801183:	ff 75 f4             	pushl  -0xc(%ebp)
  801186:	e8 51 ff ff ff       	call   8010dc <fd_close>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	eb ec                	jmp    80117c <close+0x19>

00801190 <close_all>:

void
close_all(void)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	53                   	push   %ebx
  801194:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801197:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	53                   	push   %ebx
  8011a0:	e8 be ff ff ff       	call   801163 <close>
	for (i = 0; i < MAXFD; i++)
  8011a5:	83 c3 01             	add    $0x1,%ebx
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	83 fb 20             	cmp    $0x20,%ebx
  8011ae:	75 ec                	jne    80119c <close_all+0xc>
}
  8011b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	57                   	push   %edi
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c1:	50                   	push   %eax
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	e8 67 fe ff ff       	call   801031 <fd_lookup>
  8011ca:	89 c3                	mov    %eax,%ebx
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	0f 88 81 00 00 00    	js     801258 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	e8 81 ff ff ff       	call   801163 <close>

	newfd = INDEX2FD(newfdnum);
  8011e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e5:	c1 e6 0c             	shl    $0xc,%esi
  8011e8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011ee:	83 c4 04             	add    $0x4,%esp
  8011f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f4:	e8 cf fd ff ff       	call   800fc8 <fd2data>
  8011f9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011fb:	89 34 24             	mov    %esi,(%esp)
  8011fe:	e8 c5 fd ff ff       	call   800fc8 <fd2data>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801208:	89 d8                	mov    %ebx,%eax
  80120a:	c1 e8 16             	shr    $0x16,%eax
  80120d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801214:	a8 01                	test   $0x1,%al
  801216:	74 11                	je     801229 <dup+0x74>
  801218:	89 d8                	mov    %ebx,%eax
  80121a:	c1 e8 0c             	shr    $0xc,%eax
  80121d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801224:	f6 c2 01             	test   $0x1,%dl
  801227:	75 39                	jne    801262 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801229:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122c:	89 d0                	mov    %edx,%eax
  80122e:	c1 e8 0c             	shr    $0xc,%eax
  801231:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	25 07 0e 00 00       	and    $0xe07,%eax
  801240:	50                   	push   %eax
  801241:	56                   	push   %esi
  801242:	6a 00                	push   $0x0
  801244:	52                   	push   %edx
  801245:	6a 00                	push   $0x0
  801247:	e8 ba fa ff ff       	call   800d06 <sys_page_map>
  80124c:	89 c3                	mov    %eax,%ebx
  80124e:	83 c4 20             	add    $0x20,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	78 31                	js     801286 <dup+0xd1>
		goto err;

	return newfdnum;
  801255:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801258:	89 d8                	mov    %ebx,%eax
  80125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801262:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	25 07 0e 00 00       	and    $0xe07,%eax
  801271:	50                   	push   %eax
  801272:	57                   	push   %edi
  801273:	6a 00                	push   $0x0
  801275:	53                   	push   %ebx
  801276:	6a 00                	push   $0x0
  801278:	e8 89 fa ff ff       	call   800d06 <sys_page_map>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 20             	add    $0x20,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	79 a3                	jns    801229 <dup+0x74>
	sys_page_unmap(0, newfd);
  801286:	83 ec 08             	sub    $0x8,%esp
  801289:	56                   	push   %esi
  80128a:	6a 00                	push   $0x0
  80128c:	e8 b7 fa ff ff       	call   800d48 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801291:	83 c4 08             	add    $0x8,%esp
  801294:	57                   	push   %edi
  801295:	6a 00                	push   $0x0
  801297:	e8 ac fa ff ff       	call   800d48 <sys_page_unmap>
	return r;
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	eb b7                	jmp    801258 <dup+0xa3>

008012a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 1c             	sub    $0x1c,%esp
  8012a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	53                   	push   %ebx
  8012b0:	e8 7c fd ff ff       	call   801031 <fd_lookup>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 3f                	js     8012fb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c2:	50                   	push   %eax
  8012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c6:	ff 30                	pushl  (%eax)
  8012c8:	e8 b4 fd ff ff       	call   801081 <dev_lookup>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 27                	js     8012fb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d7:	8b 42 08             	mov    0x8(%edx),%eax
  8012da:	83 e0 03             	and    $0x3,%eax
  8012dd:	83 f8 01             	cmp    $0x1,%eax
  8012e0:	74 1e                	je     801300 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	8b 40 08             	mov    0x8(%eax),%eax
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	74 35                	je     801321 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	ff 75 10             	pushl  0x10(%ebp)
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	52                   	push   %edx
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
}
  8012fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801300:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801305:	8b 40 48             	mov    0x48(%eax),%eax
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	53                   	push   %ebx
  80130c:	50                   	push   %eax
  80130d:	68 15 29 80 00       	push   $0x802915
  801312:	e8 5b ee ff ff       	call   800172 <cprintf>
		return -E_INVAL;
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131f:	eb da                	jmp    8012fb <read+0x5a>
		return -E_NOT_SUPP;
  801321:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801326:	eb d3                	jmp    8012fb <read+0x5a>

00801328 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	57                   	push   %edi
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	8b 7d 08             	mov    0x8(%ebp),%edi
  801334:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801337:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133c:	39 f3                	cmp    %esi,%ebx
  80133e:	73 23                	jae    801363 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	89 f0                	mov    %esi,%eax
  801345:	29 d8                	sub    %ebx,%eax
  801347:	50                   	push   %eax
  801348:	89 d8                	mov    %ebx,%eax
  80134a:	03 45 0c             	add    0xc(%ebp),%eax
  80134d:	50                   	push   %eax
  80134e:	57                   	push   %edi
  80134f:	e8 4d ff ff ff       	call   8012a1 <read>
		if (m < 0)
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 06                	js     801361 <readn+0x39>
			return m;
		if (m == 0)
  80135b:	74 06                	je     801363 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80135d:	01 c3                	add    %eax,%ebx
  80135f:	eb db                	jmp    80133c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801361:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801363:	89 d8                	mov    %ebx,%eax
  801365:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5f                   	pop    %edi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	53                   	push   %ebx
  801371:	83 ec 1c             	sub    $0x1c,%esp
  801374:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801377:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137a:	50                   	push   %eax
  80137b:	53                   	push   %ebx
  80137c:	e8 b0 fc ff ff       	call   801031 <fd_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 3a                	js     8013c2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801392:	ff 30                	pushl  (%eax)
  801394:	e8 e8 fc ff ff       	call   801081 <dev_lookup>
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 22                	js     8013c2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a7:	74 1e                	je     8013c7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8013af:	85 d2                	test   %edx,%edx
  8013b1:	74 35                	je     8013e8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	ff 75 10             	pushl  0x10(%ebp)
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	50                   	push   %eax
  8013bd:	ff d2                	call   *%edx
  8013bf:	83 c4 10             	add    $0x10,%esp
}
  8013c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013cc:	8b 40 48             	mov    0x48(%eax),%eax
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	53                   	push   %ebx
  8013d3:	50                   	push   %eax
  8013d4:	68 31 29 80 00       	push   $0x802931
  8013d9:	e8 94 ed ff ff       	call   800172 <cprintf>
		return -E_INVAL;
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e6:	eb da                	jmp    8013c2 <write+0x55>
		return -E_NOT_SUPP;
  8013e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ed:	eb d3                	jmp    8013c2 <write+0x55>

008013ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f8:	50                   	push   %eax
  8013f9:	ff 75 08             	pushl  0x8(%ebp)
  8013fc:	e8 30 fc ff ff       	call   801031 <fd_lookup>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 0e                	js     801416 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 1c             	sub    $0x1c,%esp
  80141f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801422:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	53                   	push   %ebx
  801427:	e8 05 fc ff ff       	call   801031 <fd_lookup>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 37                	js     80146a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143d:	ff 30                	pushl  (%eax)
  80143f:	e8 3d fc ff ff       	call   801081 <dev_lookup>
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 1f                	js     80146a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801452:	74 1b                	je     80146f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801457:	8b 52 18             	mov    0x18(%edx),%edx
  80145a:	85 d2                	test   %edx,%edx
  80145c:	74 32                	je     801490 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145e:	83 ec 08             	sub    $0x8,%esp
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	50                   	push   %eax
  801465:	ff d2                	call   *%edx
  801467:	83 c4 10             	add    $0x10,%esp
}
  80146a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80146f:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801474:	8b 40 48             	mov    0x48(%eax),%eax
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	53                   	push   %ebx
  80147b:	50                   	push   %eax
  80147c:	68 f4 28 80 00       	push   $0x8028f4
  801481:	e8 ec ec ff ff       	call   800172 <cprintf>
		return -E_INVAL;
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148e:	eb da                	jmp    80146a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801490:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801495:	eb d3                	jmp    80146a <ftruncate+0x52>

00801497 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 1c             	sub    $0x1c,%esp
  80149e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 84 fb ff ff       	call   801031 <fd_lookup>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 4b                	js     8014ff <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	ff 30                	pushl  (%eax)
  8014c0:	e8 bc fb ff ff       	call   801081 <dev_lookup>
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 33                	js     8014ff <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d3:	74 2f                	je     801504 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014df:	00 00 00 
	stat->st_isdir = 0;
  8014e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e9:	00 00 00 
	stat->st_dev = dev;
  8014ec:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	53                   	push   %ebx
  8014f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f9:	ff 50 14             	call   *0x14(%eax)
  8014fc:	83 c4 10             	add    $0x10,%esp
}
  8014ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801502:	c9                   	leave  
  801503:	c3                   	ret    
		return -E_NOT_SUPP;
  801504:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801509:	eb f4                	jmp    8014ff <fstat+0x68>

0080150b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	56                   	push   %esi
  80150f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	6a 00                	push   $0x0
  801515:	ff 75 08             	pushl  0x8(%ebp)
  801518:	e8 22 02 00 00       	call   80173f <open>
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 1b                	js     801541 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	ff 75 0c             	pushl  0xc(%ebp)
  80152c:	50                   	push   %eax
  80152d:	e8 65 ff ff ff       	call   801497 <fstat>
  801532:	89 c6                	mov    %eax,%esi
	close(fd);
  801534:	89 1c 24             	mov    %ebx,(%esp)
  801537:	e8 27 fc ff ff       	call   801163 <close>
	return r;
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	89 f3                	mov    %esi,%ebx
}
  801541:	89 d8                	mov    %ebx,%eax
  801543:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    

0080154a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	89 c6                	mov    %eax,%esi
  801551:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801553:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80155a:	74 27                	je     801583 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80155c:	6a 07                	push   $0x7
  80155e:	68 00 50 80 00       	push   $0x805000
  801563:	56                   	push   %esi
  801564:	ff 35 00 40 80 00    	pushl  0x804000
  80156a:	e8 69 0c 00 00       	call   8021d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156f:	83 c4 0c             	add    $0xc,%esp
  801572:	6a 00                	push   $0x0
  801574:	53                   	push   %ebx
  801575:	6a 00                	push   $0x0
  801577:	e8 f3 0b 00 00       	call   80216f <ipc_recv>
}
  80157c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	6a 01                	push   $0x1
  801588:	e8 a3 0c 00 00       	call   802230 <ipc_find_env>
  80158d:	a3 00 40 80 00       	mov    %eax,0x804000
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	eb c5                	jmp    80155c <fsipc+0x12>

00801597 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ab:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8015ba:	e8 8b ff ff ff       	call   80154a <fsipc>
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <devfile_flush>:
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8015dc:	e8 69 ff ff ff       	call   80154a <fsipc>
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <devfile_stat>:
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	53                   	push   %ebx
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fd:	b8 05 00 00 00       	mov    $0x5,%eax
  801602:	e8 43 ff ff ff       	call   80154a <fsipc>
  801607:	85 c0                	test   %eax,%eax
  801609:	78 2c                	js     801637 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	68 00 50 80 00       	push   $0x805000
  801613:	53                   	push   %ebx
  801614:	e8 b8 f2 ff ff       	call   8008d1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801619:	a1 80 50 80 00       	mov    0x805080,%eax
  80161e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801624:	a1 84 50 80 00       	mov    0x805084,%eax
  801629:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <devfile_write>:
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8b 40 0c             	mov    0xc(%eax),%eax
  80164c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801651:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801657:	53                   	push   %ebx
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	68 08 50 80 00       	push   $0x805008
  801660:	e8 5c f4 ff ff       	call   800ac1 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	b8 04 00 00 00       	mov    $0x4,%eax
  80166f:	e8 d6 fe ff ff       	call   80154a <fsipc>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 0b                	js     801686 <devfile_write+0x4a>
	assert(r <= n);
  80167b:	39 d8                	cmp    %ebx,%eax
  80167d:	77 0c                	ja     80168b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80167f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801684:	7f 1e                	jg     8016a4 <devfile_write+0x68>
}
  801686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801689:	c9                   	leave  
  80168a:	c3                   	ret    
	assert(r <= n);
  80168b:	68 64 29 80 00       	push   $0x802964
  801690:	68 6b 29 80 00       	push   $0x80296b
  801695:	68 98 00 00 00       	push   $0x98
  80169a:	68 80 29 80 00       	push   $0x802980
  80169f:	e8 6a 0a 00 00       	call   80210e <_panic>
	assert(r <= PGSIZE);
  8016a4:	68 8b 29 80 00       	push   $0x80298b
  8016a9:	68 6b 29 80 00       	push   $0x80296b
  8016ae:	68 99 00 00 00       	push   $0x99
  8016b3:	68 80 29 80 00       	push   $0x802980
  8016b8:	e8 51 0a 00 00       	call   80210e <_panic>

008016bd <devfile_read>:
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	56                   	push   %esi
  8016c1:	53                   	push   %ebx
  8016c2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016db:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e0:	e8 65 fe ff ff       	call   80154a <fsipc>
  8016e5:	89 c3                	mov    %eax,%ebx
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 1f                	js     80170a <devfile_read+0x4d>
	assert(r <= n);
  8016eb:	39 f0                	cmp    %esi,%eax
  8016ed:	77 24                	ja     801713 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016ef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f4:	7f 33                	jg     801729 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	50                   	push   %eax
  8016fa:	68 00 50 80 00       	push   $0x805000
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	e8 58 f3 ff ff       	call   800a5f <memmove>
	return r;
  801707:	83 c4 10             	add    $0x10,%esp
}
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    
	assert(r <= n);
  801713:	68 64 29 80 00       	push   $0x802964
  801718:	68 6b 29 80 00       	push   $0x80296b
  80171d:	6a 7c                	push   $0x7c
  80171f:	68 80 29 80 00       	push   $0x802980
  801724:	e8 e5 09 00 00       	call   80210e <_panic>
	assert(r <= PGSIZE);
  801729:	68 8b 29 80 00       	push   $0x80298b
  80172e:	68 6b 29 80 00       	push   $0x80296b
  801733:	6a 7d                	push   $0x7d
  801735:	68 80 29 80 00       	push   $0x802980
  80173a:	e8 cf 09 00 00       	call   80210e <_panic>

0080173f <open>:
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 1c             	sub    $0x1c,%esp
  801747:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80174a:	56                   	push   %esi
  80174b:	e8 48 f1 ff ff       	call   800898 <strlen>
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801758:	7f 6c                	jg     8017c6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80175a:	83 ec 0c             	sub    $0xc,%esp
  80175d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	e8 79 f8 ff ff       	call   800fdf <fd_alloc>
  801766:	89 c3                	mov    %eax,%ebx
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 3c                	js     8017ab <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	56                   	push   %esi
  801773:	68 00 50 80 00       	push   $0x805000
  801778:	e8 54 f1 ff ff       	call   8008d1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801780:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801788:	b8 01 00 00 00       	mov    $0x1,%eax
  80178d:	e8 b8 fd ff ff       	call   80154a <fsipc>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	78 19                	js     8017b4 <open+0x75>
	return fd2num(fd);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a1:	e8 12 f8 ff ff       	call   800fb8 <fd2num>
  8017a6:	89 c3                	mov    %eax,%ebx
  8017a8:	83 c4 10             	add    $0x10,%esp
}
  8017ab:	89 d8                	mov    %ebx,%eax
  8017ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
		fd_close(fd, 0);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bc:	e8 1b f9 ff ff       	call   8010dc <fd_close>
		return r;
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	eb e5                	jmp    8017ab <open+0x6c>
		return -E_BAD_PATH;
  8017c6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017cb:	eb de                	jmp    8017ab <open+0x6c>

008017cd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017dd:	e8 68 fd ff ff       	call   80154a <fsipc>
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017ea:	68 97 29 80 00       	push   $0x802997
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	e8 da f0 ff ff       	call   8008d1 <strcpy>
	return 0;
}
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devsock_close>:
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	53                   	push   %ebx
  801802:	83 ec 10             	sub    $0x10,%esp
  801805:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801808:	53                   	push   %ebx
  801809:	e8 61 0a 00 00       	call   80226f <pageref>
  80180e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801816:	83 f8 01             	cmp    $0x1,%eax
  801819:	74 07                	je     801822 <devsock_close+0x24>
}
  80181b:	89 d0                	mov    %edx,%eax
  80181d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801820:	c9                   	leave  
  801821:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	ff 73 0c             	pushl  0xc(%ebx)
  801828:	e8 b9 02 00 00       	call   801ae6 <nsipc_close>
  80182d:	89 c2                	mov    %eax,%edx
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	eb e7                	jmp    80181b <devsock_close+0x1d>

00801834 <devsock_write>:
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 10             	pushl  0x10(%ebp)
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	ff 70 0c             	pushl  0xc(%eax)
  801848:	e8 76 03 00 00       	call   801bc3 <nsipc_send>
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <devsock_read>:
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801855:	6a 00                	push   $0x0
  801857:	ff 75 10             	pushl  0x10(%ebp)
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	ff 70 0c             	pushl  0xc(%eax)
  801863:	e8 ef 02 00 00       	call   801b57 <nsipc_recv>
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <fd2sockid>:
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801870:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801873:	52                   	push   %edx
  801874:	50                   	push   %eax
  801875:	e8 b7 f7 ff ff       	call   801031 <fd_lookup>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 10                	js     801891 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80188a:	39 08                	cmp    %ecx,(%eax)
  80188c:	75 05                	jne    801893 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80188e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    
		return -E_NOT_SUPP;
  801893:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801898:	eb f7                	jmp    801891 <fd2sockid+0x27>

0080189a <alloc_sockfd>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 1c             	sub    $0x1c,%esp
  8018a2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a7:	50                   	push   %eax
  8018a8:	e8 32 f7 ff ff       	call   800fdf <fd_alloc>
  8018ad:	89 c3                	mov    %eax,%ebx
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 43                	js     8018f9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 07 04 00 00       	push   $0x407
  8018be:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c1:	6a 00                	push   $0x0
  8018c3:	e8 fb f3 ff ff       	call   800cc3 <sys_page_alloc>
  8018c8:	89 c3                	mov    %eax,%ebx
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	78 28                	js     8018f9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018da:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018e6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	50                   	push   %eax
  8018ed:	e8 c6 f6 ff ff       	call   800fb8 <fd2num>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	eb 0c                	jmp    801905 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	56                   	push   %esi
  8018fd:	e8 e4 01 00 00       	call   801ae6 <nsipc_close>
		return r;
  801902:	83 c4 10             	add    $0x10,%esp
}
  801905:	89 d8                	mov    %ebx,%eax
  801907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <accept>:
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	e8 4e ff ff ff       	call   80186a <fd2sockid>
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 1b                	js     80193b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	ff 75 10             	pushl  0x10(%ebp)
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	50                   	push   %eax
  80192a:	e8 0e 01 00 00       	call   801a3d <nsipc_accept>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 05                	js     80193b <accept+0x2d>
	return alloc_sockfd(r);
  801936:	e8 5f ff ff ff       	call   80189a <alloc_sockfd>
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <bind>:
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	e8 1f ff ff ff       	call   80186a <fd2sockid>
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 12                	js     801961 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	ff 75 10             	pushl  0x10(%ebp)
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	50                   	push   %eax
  801959:	e8 31 01 00 00       	call   801a8f <nsipc_bind>
  80195e:	83 c4 10             	add    $0x10,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <shutdown>:
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	e8 f9 fe ff ff       	call   80186a <fd2sockid>
  801971:	85 c0                	test   %eax,%eax
  801973:	78 0f                	js     801984 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	e8 43 01 00 00       	call   801ac4 <nsipc_shutdown>
  801981:	83 c4 10             	add    $0x10,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <connect>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	e8 d6 fe ff ff       	call   80186a <fd2sockid>
  801994:	85 c0                	test   %eax,%eax
  801996:	78 12                	js     8019aa <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	50                   	push   %eax
  8019a2:	e8 59 01 00 00       	call   801b00 <nsipc_connect>
  8019a7:	83 c4 10             	add    $0x10,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <listen>:
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	e8 b0 fe ff ff       	call   80186a <fd2sockid>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 0f                	js     8019cd <listen+0x21>
	return nsipc_listen(r, backlog);
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	50                   	push   %eax
  8019c5:	e8 6b 01 00 00       	call   801b35 <nsipc_listen>
  8019ca:	83 c4 10             	add    $0x10,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <socket>:

int
socket(int domain, int type, int protocol)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019d5:	ff 75 10             	pushl  0x10(%ebp)
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	e8 3e 02 00 00       	call   801c21 <nsipc_socket>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 05                	js     8019ef <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019ea:	e8 ab fe ff ff       	call   80189a <alloc_sockfd>
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	53                   	push   %ebx
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019fa:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a01:	74 26                	je     801a29 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a03:	6a 07                	push   $0x7
  801a05:	68 00 60 80 00       	push   $0x806000
  801a0a:	53                   	push   %ebx
  801a0b:	ff 35 04 40 80 00    	pushl  0x804004
  801a11:	e8 c2 07 00 00       	call   8021d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a16:	83 c4 0c             	add    $0xc,%esp
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	e8 4b 07 00 00       	call   80216f <ipc_recv>
}
  801a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	6a 02                	push   $0x2
  801a2e:	e8 fd 07 00 00       	call   802230 <ipc_find_env>
  801a33:	a3 04 40 80 00       	mov    %eax,0x804004
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	eb c6                	jmp    801a03 <nsipc+0x12>

00801a3d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a4d:	8b 06                	mov    (%esi),%eax
  801a4f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a54:	b8 01 00 00 00       	mov    $0x1,%eax
  801a59:	e8 93 ff ff ff       	call   8019f1 <nsipc>
  801a5e:	89 c3                	mov    %eax,%ebx
  801a60:	85 c0                	test   %eax,%eax
  801a62:	79 09                	jns    801a6d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a64:	89 d8                	mov    %ebx,%eax
  801a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	ff 35 10 60 80 00    	pushl  0x806010
  801a76:	68 00 60 80 00       	push   $0x806000
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	e8 dc ef ff ff       	call   800a5f <memmove>
		*addrlen = ret->ret_addrlen;
  801a83:	a1 10 60 80 00       	mov    0x806010,%eax
  801a88:	89 06                	mov    %eax,(%esi)
  801a8a:	83 c4 10             	add    $0x10,%esp
	return r;
  801a8d:	eb d5                	jmp    801a64 <nsipc_accept+0x27>

00801a8f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	53                   	push   %ebx
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aa1:	53                   	push   %ebx
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	68 04 60 80 00       	push   $0x806004
  801aaa:	e8 b0 ef ff ff       	call   800a5f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aaf:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ab5:	b8 02 00 00 00       	mov    $0x2,%eax
  801aba:	e8 32 ff ff ff       	call   8019f1 <nsipc>
}
  801abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ada:	b8 03 00 00 00       	mov    $0x3,%eax
  801adf:	e8 0d ff ff ff       	call   8019f1 <nsipc>
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <nsipc_close>:

int
nsipc_close(int s)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801af4:	b8 04 00 00 00       	mov    $0x4,%eax
  801af9:	e8 f3 fe ff ff       	call   8019f1 <nsipc>
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	53                   	push   %ebx
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b12:	53                   	push   %ebx
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	68 04 60 80 00       	push   $0x806004
  801b1b:	e8 3f ef ff ff       	call   800a5f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b20:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b26:	b8 05 00 00 00       	mov    $0x5,%eax
  801b2b:	e8 c1 fe ff ff       	call   8019f1 <nsipc>
}
  801b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b46:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b4b:	b8 06 00 00 00       	mov    $0x6,%eax
  801b50:	e8 9c fe ff ff       	call   8019f1 <nsipc>
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b67:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b75:	b8 07 00 00 00       	mov    $0x7,%eax
  801b7a:	e8 72 fe ff ff       	call   8019f1 <nsipc>
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 1f                	js     801ba4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b85:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b8a:	7f 21                	jg     801bad <nsipc_recv+0x56>
  801b8c:	39 c6                	cmp    %eax,%esi
  801b8e:	7c 1d                	jl     801bad <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	50                   	push   %eax
  801b94:	68 00 60 80 00       	push   $0x806000
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	e8 be ee ff ff       	call   800a5f <memmove>
  801ba1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bad:	68 a3 29 80 00       	push   $0x8029a3
  801bb2:	68 6b 29 80 00       	push   $0x80296b
  801bb7:	6a 62                	push   $0x62
  801bb9:	68 b8 29 80 00       	push   $0x8029b8
  801bbe:	e8 4b 05 00 00       	call   80210e <_panic>

00801bc3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bd5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bdb:	7f 2e                	jg     801c0b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	53                   	push   %ebx
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	68 0c 60 80 00       	push   $0x80600c
  801be9:	e8 71 ee ff ff       	call   800a5f <memmove>
	nsipcbuf.send.req_size = size;
  801bee:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bfc:	b8 08 00 00 00       	mov    $0x8,%eax
  801c01:	e8 eb fd ff ff       	call   8019f1 <nsipc>
}
  801c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    
	assert(size < 1600);
  801c0b:	68 c4 29 80 00       	push   $0x8029c4
  801c10:	68 6b 29 80 00       	push   $0x80296b
  801c15:	6a 6d                	push   $0x6d
  801c17:	68 b8 29 80 00       	push   $0x8029b8
  801c1c:	e8 ed 04 00 00       	call   80210e <_panic>

00801c21 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c32:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c37:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c3f:	b8 09 00 00 00       	mov    $0x9,%eax
  801c44:	e8 a8 fd ff ff       	call   8019f1 <nsipc>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 6a f3 ff ff       	call   800fc8 <fd2data>
  801c5e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c60:	83 c4 08             	add    $0x8,%esp
  801c63:	68 d0 29 80 00       	push   $0x8029d0
  801c68:	53                   	push   %ebx
  801c69:	e8 63 ec ff ff       	call   8008d1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c6e:	8b 46 04             	mov    0x4(%esi),%eax
  801c71:	2b 06                	sub    (%esi),%eax
  801c73:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c79:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c80:	00 00 00 
	stat->st_dev = &devpipe;
  801c83:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c8a:	30 80 00 
	return 0;
}
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca3:	53                   	push   %ebx
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 9d f0 ff ff       	call   800d48 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cab:	89 1c 24             	mov    %ebx,(%esp)
  801cae:	e8 15 f3 ff ff       	call   800fc8 <fd2data>
  801cb3:	83 c4 08             	add    $0x8,%esp
  801cb6:	50                   	push   %eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	e8 8a f0 ff ff       	call   800d48 <sys_page_unmap>
}
  801cbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <_pipeisclosed>:
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	57                   	push   %edi
  801cc7:	56                   	push   %esi
  801cc8:	53                   	push   %ebx
  801cc9:	83 ec 1c             	sub    $0x1c,%esp
  801ccc:	89 c7                	mov    %eax,%edi
  801cce:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801cd5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	57                   	push   %edi
  801cdc:	e8 8e 05 00 00       	call   80226f <pageref>
  801ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce4:	89 34 24             	mov    %esi,(%esp)
  801ce7:	e8 83 05 00 00       	call   80226f <pageref>
		nn = thisenv->env_runs;
  801cec:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801cf2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	39 cb                	cmp    %ecx,%ebx
  801cfa:	74 1b                	je     801d17 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cfc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cff:	75 cf                	jne    801cd0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d01:	8b 42 58             	mov    0x58(%edx),%eax
  801d04:	6a 01                	push   $0x1
  801d06:	50                   	push   %eax
  801d07:	53                   	push   %ebx
  801d08:	68 d7 29 80 00       	push   $0x8029d7
  801d0d:	e8 60 e4 ff ff       	call   800172 <cprintf>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	eb b9                	jmp    801cd0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d17:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1a:	0f 94 c0             	sete   %al
  801d1d:	0f b6 c0             	movzbl %al,%eax
}
  801d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <devpipe_write>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 28             	sub    $0x28,%esp
  801d31:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d34:	56                   	push   %esi
  801d35:	e8 8e f2 ff ff       	call   800fc8 <fd2data>
  801d3a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d44:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d47:	74 4f                	je     801d98 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d49:	8b 43 04             	mov    0x4(%ebx),%eax
  801d4c:	8b 0b                	mov    (%ebx),%ecx
  801d4e:	8d 51 20             	lea    0x20(%ecx),%edx
  801d51:	39 d0                	cmp    %edx,%eax
  801d53:	72 14                	jb     801d69 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d55:	89 da                	mov    %ebx,%edx
  801d57:	89 f0                	mov    %esi,%eax
  801d59:	e8 65 ff ff ff       	call   801cc3 <_pipeisclosed>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	75 3b                	jne    801d9d <devpipe_write+0x75>
			sys_yield();
  801d62:	e8 3d ef ff ff       	call   800ca4 <sys_yield>
  801d67:	eb e0                	jmp    801d49 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d70:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d73:	89 c2                	mov    %eax,%edx
  801d75:	c1 fa 1f             	sar    $0x1f,%edx
  801d78:	89 d1                	mov    %edx,%ecx
  801d7a:	c1 e9 1b             	shr    $0x1b,%ecx
  801d7d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d80:	83 e2 1f             	and    $0x1f,%edx
  801d83:	29 ca                	sub    %ecx,%edx
  801d85:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d89:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d8d:	83 c0 01             	add    $0x1,%eax
  801d90:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d93:	83 c7 01             	add    $0x1,%edi
  801d96:	eb ac                	jmp    801d44 <devpipe_write+0x1c>
	return i;
  801d98:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9b:	eb 05                	jmp    801da2 <devpipe_write+0x7a>
				return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <devpipe_read>:
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 18             	sub    $0x18,%esp
  801db3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db6:	57                   	push   %edi
  801db7:	e8 0c f2 ff ff       	call   800fc8 <fd2data>
  801dbc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	be 00 00 00 00       	mov    $0x0,%esi
  801dc6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc9:	75 14                	jne    801ddf <devpipe_read+0x35>
	return i;
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	eb 02                	jmp    801dd2 <devpipe_read+0x28>
				return i;
  801dd0:	89 f0                	mov    %esi,%eax
}
  801dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    
			sys_yield();
  801dda:	e8 c5 ee ff ff       	call   800ca4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddf:	8b 03                	mov    (%ebx),%eax
  801de1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de4:	75 18                	jne    801dfe <devpipe_read+0x54>
			if (i > 0)
  801de6:	85 f6                	test   %esi,%esi
  801de8:	75 e6                	jne    801dd0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dea:	89 da                	mov    %ebx,%edx
  801dec:	89 f8                	mov    %edi,%eax
  801dee:	e8 d0 fe ff ff       	call   801cc3 <_pipeisclosed>
  801df3:	85 c0                	test   %eax,%eax
  801df5:	74 e3                	je     801dda <devpipe_read+0x30>
				return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	eb d4                	jmp    801dd2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfe:	99                   	cltd   
  801dff:	c1 ea 1b             	shr    $0x1b,%edx
  801e02:	01 d0                	add    %edx,%eax
  801e04:	83 e0 1f             	and    $0x1f,%eax
  801e07:	29 d0                	sub    %edx,%eax
  801e09:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e11:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e14:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e17:	83 c6 01             	add    $0x1,%esi
  801e1a:	eb aa                	jmp    801dc6 <devpipe_read+0x1c>

00801e1c <pipe>:
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	56                   	push   %esi
  801e20:	53                   	push   %ebx
  801e21:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e27:	50                   	push   %eax
  801e28:	e8 b2 f1 ff ff       	call   800fdf <fd_alloc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	0f 88 23 01 00 00    	js     801f5d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 07 04 00 00       	push   $0x407
  801e42:	ff 75 f4             	pushl  -0xc(%ebp)
  801e45:	6a 00                	push   $0x0
  801e47:	e8 77 ee ff ff       	call   800cc3 <sys_page_alloc>
  801e4c:	89 c3                	mov    %eax,%ebx
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	0f 88 04 01 00 00    	js     801f5d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e5f:	50                   	push   %eax
  801e60:	e8 7a f1 ff ff       	call   800fdf <fd_alloc>
  801e65:	89 c3                	mov    %eax,%ebx
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	0f 88 db 00 00 00    	js     801f4d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e72:	83 ec 04             	sub    $0x4,%esp
  801e75:	68 07 04 00 00       	push   $0x407
  801e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7d:	6a 00                	push   $0x0
  801e7f:	e8 3f ee ff ff       	call   800cc3 <sys_page_alloc>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 88 bc 00 00 00    	js     801f4d <pipe+0x131>
	va = fd2data(fd0);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 f4             	pushl  -0xc(%ebp)
  801e97:	e8 2c f1 ff ff       	call   800fc8 <fd2data>
  801e9c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9e:	83 c4 0c             	add    $0xc,%esp
  801ea1:	68 07 04 00 00       	push   $0x407
  801ea6:	50                   	push   %eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 15 ee ff ff       	call   800cc3 <sys_page_alloc>
  801eae:	89 c3                	mov    %eax,%ebx
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	0f 88 82 00 00 00    	js     801f3d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec1:	e8 02 f1 ff ff       	call   800fc8 <fd2data>
  801ec6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ecd:	50                   	push   %eax
  801ece:	6a 00                	push   $0x0
  801ed0:	56                   	push   %esi
  801ed1:	6a 00                	push   $0x0
  801ed3:	e8 2e ee ff ff       	call   800d06 <sys_page_map>
  801ed8:	89 c3                	mov    %eax,%ebx
  801eda:	83 c4 20             	add    $0x20,%esp
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 4e                	js     801f2f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee1:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0a:	e8 a9 f0 ff ff       	call   800fb8 <fd2num>
  801f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f12:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f14:	83 c4 04             	add    $0x4,%esp
  801f17:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1a:	e8 99 f0 ff ff       	call   800fb8 <fd2num>
  801f1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f22:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2d:	eb 2e                	jmp    801f5d <pipe+0x141>
	sys_page_unmap(0, va);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	56                   	push   %esi
  801f33:	6a 00                	push   $0x0
  801f35:	e8 0e ee ff ff       	call   800d48 <sys_page_unmap>
  801f3a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	ff 75 f0             	pushl  -0x10(%ebp)
  801f43:	6a 00                	push   $0x0
  801f45:	e8 fe ed ff ff       	call   800d48 <sys_page_unmap>
  801f4a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f4d:	83 ec 08             	sub    $0x8,%esp
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	6a 00                	push   $0x0
  801f55:	e8 ee ed ff ff       	call   800d48 <sys_page_unmap>
  801f5a:	83 c4 10             	add    $0x10,%esp
}
  801f5d:	89 d8                	mov    %ebx,%eax
  801f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f62:	5b                   	pop    %ebx
  801f63:	5e                   	pop    %esi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <pipeisclosed>:
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6f:	50                   	push   %eax
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	e8 b9 f0 ff ff       	call   801031 <fd_lookup>
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 18                	js     801f97 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	ff 75 f4             	pushl  -0xc(%ebp)
  801f85:	e8 3e f0 ff ff       	call   800fc8 <fd2data>
	return _pipeisclosed(fd, p);
  801f8a:	89 c2                	mov    %eax,%edx
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	e8 2f fd ff ff       	call   801cc3 <_pipeisclosed>
  801f94:	83 c4 10             	add    $0x10,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	c3                   	ret    

00801f9f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa5:	68 ef 29 80 00       	push   $0x8029ef
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	e8 1f e9 ff ff       	call   8008d1 <strcpy>
	return 0;
}
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <devcons_write>:
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	57                   	push   %edi
  801fbd:	56                   	push   %esi
  801fbe:	53                   	push   %ebx
  801fbf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fca:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd3:	73 31                	jae    802006 <devcons_write+0x4d>
		m = n - tot;
  801fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd8:	29 f3                	sub    %esi,%ebx
  801fda:	83 fb 7f             	cmp    $0x7f,%ebx
  801fdd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	53                   	push   %ebx
  801fe9:	89 f0                	mov    %esi,%eax
  801feb:	03 45 0c             	add    0xc(%ebp),%eax
  801fee:	50                   	push   %eax
  801fef:	57                   	push   %edi
  801ff0:	e8 6a ea ff ff       	call   800a5f <memmove>
		sys_cputs(buf, m);
  801ff5:	83 c4 08             	add    $0x8,%esp
  801ff8:	53                   	push   %ebx
  801ff9:	57                   	push   %edi
  801ffa:	e8 08 ec ff ff       	call   800c07 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fff:	01 de                	add    %ebx,%esi
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	eb ca                	jmp    801fd0 <devcons_write+0x17>
}
  802006:	89 f0                	mov    %esi,%eax
  802008:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    

00802010 <devcons_read>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80201b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201f:	74 21                	je     802042 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802021:	e8 ff eb ff ff       	call   800c25 <sys_cgetc>
  802026:	85 c0                	test   %eax,%eax
  802028:	75 07                	jne    802031 <devcons_read+0x21>
		sys_yield();
  80202a:	e8 75 ec ff ff       	call   800ca4 <sys_yield>
  80202f:	eb f0                	jmp    802021 <devcons_read+0x11>
	if (c < 0)
  802031:	78 0f                	js     802042 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802033:	83 f8 04             	cmp    $0x4,%eax
  802036:	74 0c                	je     802044 <devcons_read+0x34>
	*(char*)vbuf = c;
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	88 02                	mov    %al,(%edx)
	return 1;
  80203d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    
		return 0;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	eb f7                	jmp    802042 <devcons_read+0x32>

0080204b <cputchar>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802057:	6a 01                	push   $0x1
  802059:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	e8 a5 eb ff ff       	call   800c07 <sys_cputs>
}
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <getchar>:
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80206d:	6a 01                	push   $0x1
  80206f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802072:	50                   	push   %eax
  802073:	6a 00                	push   $0x0
  802075:	e8 27 f2 ff ff       	call   8012a1 <read>
	if (r < 0)
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	85 c0                	test   %eax,%eax
  80207f:	78 06                	js     802087 <getchar+0x20>
	if (r < 1)
  802081:	74 06                	je     802089 <getchar+0x22>
	return c;
  802083:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    
		return -E_EOF;
  802089:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80208e:	eb f7                	jmp    802087 <getchar+0x20>

00802090 <iscons>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802099:	50                   	push   %eax
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	e8 8f ef ff ff       	call   801031 <fd_lookup>
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 11                	js     8020ba <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b2:	39 10                	cmp    %edx,(%eax)
  8020b4:	0f 94 c0             	sete   %al
  8020b7:	0f b6 c0             	movzbl %al,%eax
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <opencons>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c5:	50                   	push   %eax
  8020c6:	e8 14 ef ff ff       	call   800fdf <fd_alloc>
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 3a                	js     80210c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 07 04 00 00       	push   $0x407
  8020da:	ff 75 f4             	pushl  -0xc(%ebp)
  8020dd:	6a 00                	push   $0x0
  8020df:	e8 df eb ff ff       	call   800cc3 <sys_page_alloc>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 21                	js     80210c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	50                   	push   %eax
  802104:	e8 af ee ff ff       	call   800fb8 <fd2num>
  802109:	83 c4 10             	add    $0x10,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	56                   	push   %esi
  802112:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802113:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802118:	8b 40 48             	mov    0x48(%eax),%eax
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 20 2a 80 00       	push   $0x802a20
  802123:	50                   	push   %eax
  802124:	68 18 25 80 00       	push   $0x802518
  802129:	e8 44 e0 ff ff       	call   800172 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80212e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802131:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802137:	e8 49 eb ff ff       	call   800c85 <sys_getenvid>
  80213c:	83 c4 04             	add    $0x4,%esp
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	56                   	push   %esi
  802146:	50                   	push   %eax
  802147:	68 fc 29 80 00       	push   $0x8029fc
  80214c:	e8 21 e0 ff ff       	call   800172 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802151:	83 c4 18             	add    $0x18,%esp
  802154:	53                   	push   %ebx
  802155:	ff 75 10             	pushl  0x10(%ebp)
  802158:	e8 c4 df ff ff       	call   800121 <vcprintf>
	cprintf("\n");
  80215d:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  802164:	e8 09 e0 ff ff       	call   800172 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80216c:	cc                   	int3   
  80216d:	eb fd                	jmp    80216c <_panic+0x5e>

0080216f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	8b 75 08             	mov    0x8(%ebp),%esi
  802177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80217d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80217f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802184:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	50                   	push   %eax
  80218b:	e8 e3 ec ff ff       	call   800e73 <sys_ipc_recv>
	if(ret < 0){
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	85 c0                	test   %eax,%eax
  802195:	78 2b                	js     8021c2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802197:	85 f6                	test   %esi,%esi
  802199:	74 0a                	je     8021a5 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80219b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021a0:	8b 40 78             	mov    0x78(%eax),%eax
  8021a3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021a5:	85 db                	test   %ebx,%ebx
  8021a7:	74 0a                	je     8021b3 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021a9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021ae:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021b1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021b3:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021b8:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021be:	5b                   	pop    %ebx
  8021bf:	5e                   	pop    %esi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
		if(from_env_store)
  8021c2:	85 f6                	test   %esi,%esi
  8021c4:	74 06                	je     8021cc <ipc_recv+0x5d>
			*from_env_store = 0;
  8021c6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021cc:	85 db                	test   %ebx,%ebx
  8021ce:	74 eb                	je     8021bb <ipc_recv+0x4c>
			*perm_store = 0;
  8021d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021d6:	eb e3                	jmp    8021bb <ipc_recv+0x4c>

008021d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	57                   	push   %edi
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021ea:	85 db                	test   %ebx,%ebx
  8021ec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f1:	0f 44 d8             	cmove  %eax,%ebx
  8021f4:	eb 05                	jmp    8021fb <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021f6:	e8 a9 ea ff ff       	call   800ca4 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021fb:	ff 75 14             	pushl  0x14(%ebp)
  8021fe:	53                   	push   %ebx
  8021ff:	56                   	push   %esi
  802200:	57                   	push   %edi
  802201:	e8 4a ec ff ff       	call   800e50 <sys_ipc_try_send>
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	85 c0                	test   %eax,%eax
  80220b:	74 1b                	je     802228 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80220d:	79 e7                	jns    8021f6 <ipc_send+0x1e>
  80220f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802212:	74 e2                	je     8021f6 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 27 2a 80 00       	push   $0x802a27
  80221c:	6a 46                	push   $0x46
  80221e:	68 3c 2a 80 00       	push   $0x802a3c
  802223:	e8 e6 fe ff ff       	call   80210e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    

00802230 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80223b:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802241:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802247:	8b 52 50             	mov    0x50(%edx),%edx
  80224a:	39 ca                	cmp    %ecx,%edx
  80224c:	74 11                	je     80225f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80224e:	83 c0 01             	add    $0x1,%eax
  802251:	3d 00 04 00 00       	cmp    $0x400,%eax
  802256:	75 e3                	jne    80223b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	eb 0e                	jmp    80226d <ipc_find_env+0x3d>
			return envs[i].env_id;
  80225f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802265:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80226a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80226d:	5d                   	pop    %ebp
  80226e:	c3                   	ret    

0080226f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802275:	89 d0                	mov    %edx,%eax
  802277:	c1 e8 16             	shr    $0x16,%eax
  80227a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802286:	f6 c1 01             	test   $0x1,%cl
  802289:	74 1d                	je     8022a8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80228b:	c1 ea 0c             	shr    $0xc,%edx
  80228e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802295:	f6 c2 01             	test   $0x1,%dl
  802298:	74 0e                	je     8022a8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80229a:	c1 ea 0c             	shr    $0xc,%edx
  80229d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a4:	ef 
  8022a5:	0f b7 c0             	movzwl %ax,%eax
}
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

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
