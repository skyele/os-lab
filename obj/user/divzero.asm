
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
  800051:	68 20 25 80 00       	push   $0x802520
  800056:	e8 56 01 00 00       	call   8001b1 <cprintf>
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
  800069:	c7 05 0c 40 80 00 00 	movl   $0x0,0x80400c
  800070:	00 00 00 
	envid_t find = sys_getenvid();
  800073:	e8 4c 0c 00 00       	call   800cc4 <sys_getenvid>
  800078:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
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
  8000c1:	89 1d 0c 40 80 00    	mov    %ebx,0x80400c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cb:	7e 0a                	jle    8000d7 <libmain+0x77>
		binaryname = argv[0];
  8000cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d0:	8b 00                	mov    (%eax),%eax
  8000d2:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 2e 25 80 00       	push   $0x80252e
  8000df:	e8 cd 00 00 00       	call   8001b1 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e4:	83 c4 08             	add    $0x8,%esp
  8000e7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ea:	ff 75 08             	pushl  0x8(%ebp)
  8000ed:	e8 41 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f2:	e8 0b 00 00 00       	call   800102 <exit>
}
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5f                   	pop    %edi
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800108:	e8 a2 10 00 00       	call   8011af <close_all>
	sys_env_destroy(0);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 00                	push   $0x0
  800112:	e8 6c 0b 00 00       	call   800c83 <sys_env_destroy>
}
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	c9                   	leave  
  80011b:	c3                   	ret    

0080011c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	53                   	push   %ebx
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800126:	8b 13                	mov    (%ebx),%edx
  800128:	8d 42 01             	lea    0x1(%edx),%eax
  80012b:	89 03                	mov    %eax,(%ebx)
  80012d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800130:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800134:	3d ff 00 00 00       	cmp    $0xff,%eax
  800139:	74 09                	je     800144 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800142:	c9                   	leave  
  800143:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	68 ff 00 00 00       	push   $0xff
  80014c:	8d 43 08             	lea    0x8(%ebx),%eax
  80014f:	50                   	push   %eax
  800150:	e8 f1 0a 00 00       	call   800c46 <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	eb db                	jmp    80013b <putch+0x1f>

00800160 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800169:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800170:	00 00 00 
	b.cnt = 0;
  800173:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800189:	50                   	push   %eax
  80018a:	68 1c 01 80 00       	push   $0x80011c
  80018f:	e8 4a 01 00 00       	call   8002de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800194:	83 c4 08             	add    $0x8,%esp
  800197:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 9d 0a 00 00       	call   800c46 <sys_cputs>

	return b.cnt;
}
  8001a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	e8 9d ff ff ff       	call   800160 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    

008001c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	57                   	push   %edi
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 1c             	sub    $0x1c,%esp
  8001ce:	89 c6                	mov    %eax,%esi
  8001d0:	89 d7                	mov    %edx,%edi
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e8:	74 2c                	je     800216 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ff:	73 43                	jae    800244 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800201:	83 eb 01             	sub    $0x1,%ebx
  800204:	85 db                	test   %ebx,%ebx
  800206:	7e 6c                	jle    800274 <printnum+0xaf>
				putch(padc, putdat);
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	57                   	push   %edi
  80020c:	ff 75 18             	pushl  0x18(%ebp)
  80020f:	ff d6                	call   *%esi
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb eb                	jmp    800201 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	6a 20                	push   $0x20
  80021b:	6a 00                	push   $0x0
  80021d:	50                   	push   %eax
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	89 fa                	mov    %edi,%edx
  800226:	89 f0                	mov    %esi,%eax
  800228:	e8 98 ff ff ff       	call   8001c5 <printnum>
		while (--width > 0)
  80022d:	83 c4 20             	add    $0x20,%esp
  800230:	83 eb 01             	sub    $0x1,%ebx
  800233:	85 db                	test   %ebx,%ebx
  800235:	7e 65                	jle    80029c <printnum+0xd7>
			putch(padc, putdat);
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	57                   	push   %edi
  80023b:	6a 20                	push   $0x20
  80023d:	ff d6                	call   *%esi
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	eb ec                	jmp    800230 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	83 eb 01             	sub    $0x1,%ebx
  80024d:	53                   	push   %ebx
  80024e:	50                   	push   %eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 dc             	pushl  -0x24(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	e8 6d 20 00 00       	call   8022d0 <__udivdi3>
  800263:	83 c4 18             	add    $0x18,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	89 fa                	mov    %edi,%edx
  80026a:	89 f0                	mov    %esi,%eax
  80026c:	e8 54 ff ff ff       	call   8001c5 <printnum>
  800271:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	e8 54 21 00 00       	call   8023e0 <__umoddi3>
  80028c:	83 c4 14             	add    $0x14,%esp
  80028f:	0f be 80 45 25 80 00 	movsbl 0x802545(%eax),%eax
  800296:	50                   	push   %eax
  800297:	ff d6                	call   *%esi
  800299:	83 c4 10             	add    $0x10,%esp
	}
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    

008002a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002aa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ae:	8b 10                	mov    (%eax),%edx
  8002b0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b3:	73 0a                	jae    8002bf <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bd:	88 02                	mov    %al,(%edx)
}
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <printfmt>:
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ca:	50                   	push   %eax
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	ff 75 0c             	pushl  0xc(%ebp)
  8002d1:	ff 75 08             	pushl  0x8(%ebp)
  8002d4:	e8 05 00 00 00       	call   8002de <vprintfmt>
}
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <vprintfmt>:
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 3c             	sub    $0x3c,%esp
  8002e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f0:	e9 32 04 00 00       	jmp    800727 <vprintfmt+0x449>
		padc = ' ';
  8002f5:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002f9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800300:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800307:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800315:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80031c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8d 47 01             	lea    0x1(%edi),%eax
  800324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800327:	0f b6 17             	movzbl (%edi),%edx
  80032a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032d:	3c 55                	cmp    $0x55,%al
  80032f:	0f 87 12 05 00 00    	ja     800847 <vprintfmt+0x569>
  800335:	0f b6 c0             	movzbl %al,%eax
  800338:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800342:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800346:	eb d9                	jmp    800321 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80034f:	eb d0                	jmp    800321 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800351:	0f b6 d2             	movzbl %dl,%edx
  800354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	89 75 08             	mov    %esi,0x8(%ebp)
  80035f:	eb 03                	jmp    800364 <vprintfmt+0x86>
  800361:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800364:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800367:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800371:	83 fe 09             	cmp    $0x9,%esi
  800374:	76 eb                	jbe    800361 <vprintfmt+0x83>
  800376:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800379:	8b 75 08             	mov    0x8(%ebp),%esi
  80037c:	eb 14                	jmp    800392 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 40 04             	lea    0x4(%eax),%eax
  80038c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800396:	79 89                	jns    800321 <vprintfmt+0x43>
				width = precision, precision = -1;
  800398:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a5:	e9 77 ff ff ff       	jmp    800321 <vprintfmt+0x43>
  8003aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	0f 48 c1             	cmovs  %ecx,%eax
  8003b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b8:	e9 64 ff ff ff       	jmp    800321 <vprintfmt+0x43>
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c7:	e9 55 ff ff ff       	jmp    800321 <vprintfmt+0x43>
			lflag++;
  8003cc:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d3:	e9 49 ff ff ff       	jmp    800321 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 78 04             	lea    0x4(%eax),%edi
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	53                   	push   %ebx
  8003e2:	ff 30                	pushl  (%eax)
  8003e4:	ff d6                	call   *%esi
			break;
  8003e6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ec:	e9 33 03 00 00       	jmp    800724 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 78 04             	lea    0x4(%eax),%edi
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	99                   	cltd   
  8003fa:	31 d0                	xor    %edx,%eax
  8003fc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fe:	83 f8 10             	cmp    $0x10,%eax
  800401:	7f 23                	jg     800426 <vprintfmt+0x148>
  800403:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  80040a:	85 d2                	test   %edx,%edx
  80040c:	74 18                	je     800426 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80040e:	52                   	push   %edx
  80040f:	68 99 29 80 00       	push   $0x802999
  800414:	53                   	push   %ebx
  800415:	56                   	push   %esi
  800416:	e8 a6 fe ff ff       	call   8002c1 <printfmt>
  80041b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800421:	e9 fe 02 00 00       	jmp    800724 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800426:	50                   	push   %eax
  800427:	68 5d 25 80 00       	push   $0x80255d
  80042c:	53                   	push   %ebx
  80042d:	56                   	push   %esi
  80042e:	e8 8e fe ff ff       	call   8002c1 <printfmt>
  800433:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800436:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800439:	e9 e6 02 00 00       	jmp    800724 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	83 c0 04             	add    $0x4,%eax
  800444:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80044c:	85 c9                	test   %ecx,%ecx
  80044e:	b8 56 25 80 00       	mov    $0x802556,%eax
  800453:	0f 45 c1             	cmovne %ecx,%eax
  800456:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045d:	7e 06                	jle    800465 <vprintfmt+0x187>
  80045f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800463:	75 0d                	jne    800472 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800465:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800468:	89 c7                	mov    %eax,%edi
  80046a:	03 45 e0             	add    -0x20(%ebp),%eax
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800470:	eb 53                	jmp    8004c5 <vprintfmt+0x1e7>
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	50                   	push   %eax
  800479:	e8 71 04 00 00       	call   8008ef <strnlen>
  80047e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800481:	29 c1                	sub    %eax,%ecx
  800483:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80048b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80048f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800492:	eb 0f                	jmp    8004a3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	ff 75 e0             	pushl  -0x20(%ebp)
  80049b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	83 ef 01             	sub    $0x1,%edi
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	85 ff                	test   %edi,%edi
  8004a5:	7f ed                	jg     800494 <vprintfmt+0x1b6>
  8004a7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004aa:	85 c9                	test   %ecx,%ecx
  8004ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b1:	0f 49 c1             	cmovns %ecx,%eax
  8004b4:	29 c1                	sub    %eax,%ecx
  8004b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b9:	eb aa                	jmp    800465 <vprintfmt+0x187>
					putch(ch, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	52                   	push   %edx
  8004c0:	ff d6                	call   *%esi
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ca:	83 c7 01             	add    $0x1,%edi
  8004cd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d1:	0f be d0             	movsbl %al,%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 4b                	je     800523 <vprintfmt+0x245>
  8004d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004dc:	78 06                	js     8004e4 <vprintfmt+0x206>
  8004de:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e2:	78 1e                	js     800502 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e8:	74 d1                	je     8004bb <vprintfmt+0x1dd>
  8004ea:	0f be c0             	movsbl %al,%eax
  8004ed:	83 e8 20             	sub    $0x20,%eax
  8004f0:	83 f8 5e             	cmp    $0x5e,%eax
  8004f3:	76 c6                	jbe    8004bb <vprintfmt+0x1dd>
					putch('?', putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	53                   	push   %ebx
  8004f9:	6a 3f                	push   $0x3f
  8004fb:	ff d6                	call   *%esi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	eb c3                	jmp    8004c5 <vprintfmt+0x1e7>
  800502:	89 cf                	mov    %ecx,%edi
  800504:	eb 0e                	jmp    800514 <vprintfmt+0x236>
				putch(' ', putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	53                   	push   %ebx
  80050a:	6a 20                	push   $0x20
  80050c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80050e:	83 ef 01             	sub    $0x1,%edi
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	85 ff                	test   %edi,%edi
  800516:	7f ee                	jg     800506 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800518:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	e9 01 02 00 00       	jmp    800724 <vprintfmt+0x446>
  800523:	89 cf                	mov    %ecx,%edi
  800525:	eb ed                	jmp    800514 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80052a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800531:	e9 eb fd ff ff       	jmp    800321 <vprintfmt+0x43>
	if (lflag >= 2)
  800536:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80053a:	7f 21                	jg     80055d <vprintfmt+0x27f>
	else if (lflag)
  80053c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800540:	74 68                	je     8005aa <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054a:	89 c1                	mov    %eax,%ecx
  80054c:	c1 f9 1f             	sar    $0x1f,%ecx
  80054f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb 17                	jmp    800574 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 50 04             	mov    0x4(%eax),%edx
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 40 08             	lea    0x8(%eax),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800577:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800580:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800584:	78 3f                	js     8005c5 <vprintfmt+0x2e7>
			base = 10;
  800586:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80058b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80058f:	0f 84 71 01 00 00    	je     800706 <vprintfmt+0x428>
				putch('+', putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	6a 2b                	push   $0x2b
  80059b:	ff d6                	call   *%esi
  80059d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a5:	e9 5c 01 00 00       	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b2:	89 c1                	mov    %eax,%ecx
  8005b4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	eb af                	jmp    800574 <vprintfmt+0x296>
				putch('-', putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	6a 2d                	push   $0x2d
  8005cb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d3:	f7 d8                	neg    %eax
  8005d5:	83 d2 00             	adc    $0x0,%edx
  8005d8:	f7 da                	neg    %edx
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e8:	e9 19 01 00 00       	jmp    800706 <vprintfmt+0x428>
	if (lflag >= 2)
  8005ed:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005f1:	7f 29                	jg     80061c <vprintfmt+0x33e>
	else if (lflag)
  8005f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f7:	74 44                	je     80063d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800603:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800606:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800612:	b8 0a 00 00 00       	mov    $0xa,%eax
  800617:	e9 ea 00 00 00       	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 50 04             	mov    0x4(%eax),%edx
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 08             	lea    0x8(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800633:	b8 0a 00 00 00       	mov    $0xa,%eax
  800638:	e9 c9 00 00 00       	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800656:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065b:	e9 a6 00 00 00       	jmp    800706 <vprintfmt+0x428>
			putch('0', putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 30                	push   $0x30
  800666:	ff d6                	call   *%esi
	if (lflag >= 2)
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066f:	7f 26                	jg     800697 <vprintfmt+0x3b9>
	else if (lflag)
  800671:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800675:	74 3e                	je     8006b5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800690:	b8 08 00 00 00       	mov    $0x8,%eax
  800695:	eb 6f                	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 08             	lea    0x8(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b3:	eb 51                	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d3:	eb 31                	jmp    800706 <vprintfmt+0x428>
			putch('0', putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	6a 30                	push   $0x30
  8006db:	ff d6                	call   *%esi
			putch('x', putdat);
  8006dd:	83 c4 08             	add    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 78                	push   $0x78
  8006e3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800701:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80070d:	52                   	push   %edx
  80070e:	ff 75 e0             	pushl  -0x20(%ebp)
  800711:	50                   	push   %eax
  800712:	ff 75 dc             	pushl  -0x24(%ebp)
  800715:	ff 75 d8             	pushl  -0x28(%ebp)
  800718:	89 da                	mov    %ebx,%edx
  80071a:	89 f0                	mov    %esi,%eax
  80071c:	e8 a4 fa ff ff       	call   8001c5 <printnum>
			break;
  800721:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800727:	83 c7 01             	add    $0x1,%edi
  80072a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072e:	83 f8 25             	cmp    $0x25,%eax
  800731:	0f 84 be fb ff ff    	je     8002f5 <vprintfmt+0x17>
			if (ch == '\0')
  800737:	85 c0                	test   %eax,%eax
  800739:	0f 84 28 01 00 00    	je     800867 <vprintfmt+0x589>
			putch(ch, putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	53                   	push   %ebx
  800743:	50                   	push   %eax
  800744:	ff d6                	call   *%esi
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	eb dc                	jmp    800727 <vprintfmt+0x449>
	if (lflag >= 2)
  80074b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074f:	7f 26                	jg     800777 <vprintfmt+0x499>
	else if (lflag)
  800751:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800755:	74 41                	je     800798 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	ba 00 00 00 00       	mov    $0x0,%edx
  800761:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800764:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
  800775:	eb 8f                	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 50 04             	mov    0x4(%eax),%edx
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800782:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 40 08             	lea    0x8(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078e:	b8 10 00 00 00       	mov    $0x10,%eax
  800793:	e9 6e ff ff ff       	jmp    800706 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 04             	lea    0x4(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b6:	e9 4b ff ff ff       	jmp    800706 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 c0 04             	add    $0x4,%eax
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	74 14                	je     8007e1 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007cd:	8b 13                	mov    (%ebx),%edx
  8007cf:	83 fa 7f             	cmp    $0x7f,%edx
  8007d2:	7f 37                	jg     80080b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007d4:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	e9 43 ff ff ff       	jmp    800724 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e6:	bf 79 26 80 00       	mov    $0x802679,%edi
							putch(ch, putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	53                   	push   %ebx
  8007ef:	50                   	push   %eax
  8007f0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f2:	83 c7 01             	add    $0x1,%edi
  8007f5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	75 eb                	jne    8007eb <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800800:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
  800806:	e9 19 ff ff ff       	jmp    800724 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80080b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80080d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800812:	bf b1 26 80 00       	mov    $0x8026b1,%edi
							putch(ch, putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	50                   	push   %eax
  80081c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081e:	83 c7 01             	add    $0x1,%edi
  800821:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	85 c0                	test   %eax,%eax
  80082a:	75 eb                	jne    800817 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80082c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	e9 ed fe ff ff       	jmp    800724 <vprintfmt+0x446>
			putch(ch, putdat);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	53                   	push   %ebx
  80083b:	6a 25                	push   $0x25
  80083d:	ff d6                	call   *%esi
			break;
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	e9 dd fe ff ff       	jmp    800724 <vprintfmt+0x446>
			putch('%', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	53                   	push   %ebx
  80084b:	6a 25                	push   $0x25
  80084d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	89 f8                	mov    %edi,%eax
  800854:	eb 03                	jmp    800859 <vprintfmt+0x57b>
  800856:	83 e8 01             	sub    $0x1,%eax
  800859:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085d:	75 f7                	jne    800856 <vprintfmt+0x578>
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	e9 bd fe ff ff       	jmp    800724 <vprintfmt+0x446>
}
  800867:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086a:	5b                   	pop    %ebx
  80086b:	5e                   	pop    %esi
  80086c:	5f                   	pop    %edi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	83 ec 18             	sub    $0x18,%esp
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800882:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800885:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088c:	85 c0                	test   %eax,%eax
  80088e:	74 26                	je     8008b6 <vsnprintf+0x47>
  800890:	85 d2                	test   %edx,%edx
  800892:	7e 22                	jle    8008b6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800894:	ff 75 14             	pushl  0x14(%ebp)
  800897:	ff 75 10             	pushl  0x10(%ebp)
  80089a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089d:	50                   	push   %eax
  80089e:	68 a4 02 80 00       	push   $0x8002a4
  8008a3:	e8 36 fa ff ff       	call   8002de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    
		return -E_INVAL;
  8008b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008bb:	eb f7                	jmp    8008b4 <vsnprintf+0x45>

008008bd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 10             	pushl  0x10(%ebp)
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 9a ff ff ff       	call   80086f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e6:	74 05                	je     8008ed <strlen+0x16>
		n++;
  8008e8:	83 c0 01             	add    $0x1,%eax
  8008eb:	eb f5                	jmp    8008e2 <strlen+0xb>
	return n;
}
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fd:	39 c2                	cmp    %eax,%edx
  8008ff:	74 0d                	je     80090e <strnlen+0x1f>
  800901:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800905:	74 05                	je     80090c <strnlen+0x1d>
		n++;
  800907:	83 c2 01             	add    $0x1,%edx
  80090a:	eb f1                	jmp    8008fd <strnlen+0xe>
  80090c:	89 d0                	mov    %edx,%eax
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
  80091f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800923:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	84 c9                	test   %cl,%cl
  80092b:	75 f2                	jne    80091f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092d:	5b                   	pop    %ebx
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	53                   	push   %ebx
  800934:	83 ec 10             	sub    $0x10,%esp
  800937:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093a:	53                   	push   %ebx
  80093b:	e8 97 ff ff ff       	call   8008d7 <strlen>
  800940:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	01 d8                	add    %ebx,%eax
  800948:	50                   	push   %eax
  800949:	e8 c2 ff ff ff       	call   800910 <strcpy>
	return dst;
}
  80094e:	89 d8                	mov    %ebx,%eax
  800950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800960:	89 c6                	mov    %eax,%esi
  800962:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800965:	89 c2                	mov    %eax,%edx
  800967:	39 f2                	cmp    %esi,%edx
  800969:	74 11                	je     80097c <strncpy+0x27>
		*dst++ = *src;
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	0f b6 19             	movzbl (%ecx),%ebx
  800971:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800974:	80 fb 01             	cmp    $0x1,%bl
  800977:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80097a:	eb eb                	jmp    800967 <strncpy+0x12>
	}
	return ret;
}
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 75 08             	mov    0x8(%ebp),%esi
  800988:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098b:	8b 55 10             	mov    0x10(%ebp),%edx
  80098e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800990:	85 d2                	test   %edx,%edx
  800992:	74 21                	je     8009b5 <strlcpy+0x35>
  800994:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800998:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 14                	je     8009b2 <strlcpy+0x32>
  80099e:	0f b6 19             	movzbl (%ecx),%ebx
  8009a1:	84 db                	test   %bl,%bl
  8009a3:	74 0b                	je     8009b0 <strlcpy+0x30>
			*dst++ = *src++;
  8009a5:	83 c1 01             	add    $0x1,%ecx
  8009a8:	83 c2 01             	add    $0x1,%edx
  8009ab:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ae:	eb ea                	jmp    80099a <strlcpy+0x1a>
  8009b0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b5:	29 f0                	sub    %esi,%eax
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c4:	0f b6 01             	movzbl (%ecx),%eax
  8009c7:	84 c0                	test   %al,%al
  8009c9:	74 0c                	je     8009d7 <strcmp+0x1c>
  8009cb:	3a 02                	cmp    (%edx),%al
  8009cd:	75 08                	jne    8009d7 <strcmp+0x1c>
		p++, q++;
  8009cf:	83 c1 01             	add    $0x1,%ecx
  8009d2:	83 c2 01             	add    $0x1,%edx
  8009d5:	eb ed                	jmp    8009c4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d7:	0f b6 c0             	movzbl %al,%eax
  8009da:	0f b6 12             	movzbl (%edx),%edx
  8009dd:	29 d0                	sub    %edx,%eax
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	89 c3                	mov    %eax,%ebx
  8009ed:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f0:	eb 06                	jmp    8009f8 <strncmp+0x17>
		n--, p++, q++;
  8009f2:	83 c0 01             	add    $0x1,%eax
  8009f5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f8:	39 d8                	cmp    %ebx,%eax
  8009fa:	74 16                	je     800a12 <strncmp+0x31>
  8009fc:	0f b6 08             	movzbl (%eax),%ecx
  8009ff:	84 c9                	test   %cl,%cl
  800a01:	74 04                	je     800a07 <strncmp+0x26>
  800a03:	3a 0a                	cmp    (%edx),%cl
  800a05:	74 eb                	je     8009f2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a07:	0f b6 00             	movzbl (%eax),%eax
  800a0a:	0f b6 12             	movzbl (%edx),%edx
  800a0d:	29 d0                	sub    %edx,%eax
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    
		return 0;
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb f6                	jmp    800a0f <strncmp+0x2e>

00800a19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a23:	0f b6 10             	movzbl (%eax),%edx
  800a26:	84 d2                	test   %dl,%dl
  800a28:	74 09                	je     800a33 <strchr+0x1a>
		if (*s == c)
  800a2a:	38 ca                	cmp    %cl,%dl
  800a2c:	74 0a                	je     800a38 <strchr+0x1f>
	for (; *s; s++)
  800a2e:	83 c0 01             	add    $0x1,%eax
  800a31:	eb f0                	jmp    800a23 <strchr+0xa>
			return (char *) s;
	return 0;
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a47:	38 ca                	cmp    %cl,%dl
  800a49:	74 09                	je     800a54 <strfind+0x1a>
  800a4b:	84 d2                	test   %dl,%dl
  800a4d:	74 05                	je     800a54 <strfind+0x1a>
	for (; *s; s++)
  800a4f:	83 c0 01             	add    $0x1,%eax
  800a52:	eb f0                	jmp    800a44 <strfind+0xa>
			break;
	return (char *) s;
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a62:	85 c9                	test   %ecx,%ecx
  800a64:	74 31                	je     800a97 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a66:	89 f8                	mov    %edi,%eax
  800a68:	09 c8                	or     %ecx,%eax
  800a6a:	a8 03                	test   $0x3,%al
  800a6c:	75 23                	jne    800a91 <memset+0x3b>
		c &= 0xFF;
  800a6e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a72:	89 d3                	mov    %edx,%ebx
  800a74:	c1 e3 08             	shl    $0x8,%ebx
  800a77:	89 d0                	mov    %edx,%eax
  800a79:	c1 e0 18             	shl    $0x18,%eax
  800a7c:	89 d6                	mov    %edx,%esi
  800a7e:	c1 e6 10             	shl    $0x10,%esi
  800a81:	09 f0                	or     %esi,%eax
  800a83:	09 c2                	or     %eax,%edx
  800a85:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a87:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8a:	89 d0                	mov    %edx,%eax
  800a8c:	fc                   	cld    
  800a8d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8f:	eb 06                	jmp    800a97 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	fc                   	cld    
  800a95:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a97:	89 f8                	mov    %edi,%eax
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5f                   	pop    %edi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	57                   	push   %edi
  800aa2:	56                   	push   %esi
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aac:	39 c6                	cmp    %eax,%esi
  800aae:	73 32                	jae    800ae2 <memmove+0x44>
  800ab0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab3:	39 c2                	cmp    %eax,%edx
  800ab5:	76 2b                	jbe    800ae2 <memmove+0x44>
		s += n;
		d += n;
  800ab7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aba:	89 fe                	mov    %edi,%esi
  800abc:	09 ce                	or     %ecx,%esi
  800abe:	09 d6                	or     %edx,%esi
  800ac0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac6:	75 0e                	jne    800ad6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac8:	83 ef 04             	sub    $0x4,%edi
  800acb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ace:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad1:	fd                   	std    
  800ad2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad4:	eb 09                	jmp    800adf <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad6:	83 ef 01             	sub    $0x1,%edi
  800ad9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800adc:	fd                   	std    
  800add:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800adf:	fc                   	cld    
  800ae0:	eb 1a                	jmp    800afc <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae2:	89 c2                	mov    %eax,%edx
  800ae4:	09 ca                	or     %ecx,%edx
  800ae6:	09 f2                	or     %esi,%edx
  800ae8:	f6 c2 03             	test   $0x3,%dl
  800aeb:	75 0a                	jne    800af7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aed:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af0:	89 c7                	mov    %eax,%edi
  800af2:	fc                   	cld    
  800af3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af5:	eb 05                	jmp    800afc <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af7:	89 c7                	mov    %eax,%edi
  800af9:	fc                   	cld    
  800afa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afc:	5e                   	pop    %esi
  800afd:	5f                   	pop    %edi
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b06:	ff 75 10             	pushl  0x10(%ebp)
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 08             	pushl  0x8(%ebp)
  800b0f:	e8 8a ff ff ff       	call   800a9e <memmove>
}
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 c6                	mov    %eax,%esi
  800b23:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b26:	39 f0                	cmp    %esi,%eax
  800b28:	74 1c                	je     800b46 <memcmp+0x30>
		if (*s1 != *s2)
  800b2a:	0f b6 08             	movzbl (%eax),%ecx
  800b2d:	0f b6 1a             	movzbl (%edx),%ebx
  800b30:	38 d9                	cmp    %bl,%cl
  800b32:	75 08                	jne    800b3c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b34:	83 c0 01             	add    $0x1,%eax
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	eb ea                	jmp    800b26 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3c:	0f b6 c1             	movzbl %cl,%eax
  800b3f:	0f b6 db             	movzbl %bl,%ebx
  800b42:	29 d8                	sub    %ebx,%eax
  800b44:	eb 05                	jmp    800b4b <memcmp+0x35>
	}

	return 0;
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5e                   	pop    %esi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	73 09                	jae    800b6a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b61:	38 08                	cmp    %cl,(%eax)
  800b63:	74 05                	je     800b6a <memfind+0x1b>
	for (; s < ends; s++)
  800b65:	83 c0 01             	add    $0x1,%eax
  800b68:	eb f3                	jmp    800b5d <memfind+0xe>
			break;
	return (void *) s;
}
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b78:	eb 03                	jmp    800b7d <strtol+0x11>
		s++;
  800b7a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7d:	0f b6 01             	movzbl (%ecx),%eax
  800b80:	3c 20                	cmp    $0x20,%al
  800b82:	74 f6                	je     800b7a <strtol+0xe>
  800b84:	3c 09                	cmp    $0x9,%al
  800b86:	74 f2                	je     800b7a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b88:	3c 2b                	cmp    $0x2b,%al
  800b8a:	74 2a                	je     800bb6 <strtol+0x4a>
	int neg = 0;
  800b8c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b91:	3c 2d                	cmp    $0x2d,%al
  800b93:	74 2b                	je     800bc0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b9b:	75 0f                	jne    800bac <strtol+0x40>
  800b9d:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba0:	74 28                	je     800bca <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba9:	0f 44 d8             	cmove  %eax,%ebx
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb4:	eb 50                	jmp    800c06 <strtol+0x9a>
		s++;
  800bb6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbe:	eb d5                	jmp    800b95 <strtol+0x29>
		s++, neg = 1;
  800bc0:	83 c1 01             	add    $0x1,%ecx
  800bc3:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc8:	eb cb                	jmp    800b95 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bca:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bce:	74 0e                	je     800bde <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bd0:	85 db                	test   %ebx,%ebx
  800bd2:	75 d8                	jne    800bac <strtol+0x40>
		s++, base = 8;
  800bd4:	83 c1 01             	add    $0x1,%ecx
  800bd7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bdc:	eb ce                	jmp    800bac <strtol+0x40>
		s += 2, base = 16;
  800bde:	83 c1 02             	add    $0x2,%ecx
  800be1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be6:	eb c4                	jmp    800bac <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800beb:	89 f3                	mov    %esi,%ebx
  800bed:	80 fb 19             	cmp    $0x19,%bl
  800bf0:	77 29                	ja     800c1b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf2:	0f be d2             	movsbl %dl,%edx
  800bf5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfb:	7d 30                	jge    800c2d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c04:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c06:	0f b6 11             	movzbl (%ecx),%edx
  800c09:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0c:	89 f3                	mov    %esi,%ebx
  800c0e:	80 fb 09             	cmp    $0x9,%bl
  800c11:	77 d5                	ja     800be8 <strtol+0x7c>
			dig = *s - '0';
  800c13:	0f be d2             	movsbl %dl,%edx
  800c16:	83 ea 30             	sub    $0x30,%edx
  800c19:	eb dd                	jmp    800bf8 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c1b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1e:	89 f3                	mov    %esi,%ebx
  800c20:	80 fb 19             	cmp    $0x19,%bl
  800c23:	77 08                	ja     800c2d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c25:	0f be d2             	movsbl %dl,%edx
  800c28:	83 ea 37             	sub    $0x37,%edx
  800c2b:	eb cb                	jmp    800bf8 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c31:	74 05                	je     800c38 <strtol+0xcc>
		*endptr = (char *) s;
  800c33:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c36:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	f7 da                	neg    %edx
  800c3c:	85 ff                	test   %edi,%edi
  800c3e:	0f 45 c2             	cmovne %edx,%eax
}
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c57:	89 c3                	mov    %eax,%ebx
  800c59:	89 c7                	mov    %eax,%edi
  800c5b:	89 c6                	mov    %eax,%esi
  800c5d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	b8 03 00 00 00       	mov    $0x3,%eax
  800c99:	89 cb                	mov    %ecx,%ebx
  800c9b:	89 cf                	mov    %ecx,%edi
  800c9d:	89 ce                	mov    %ecx,%esi
  800c9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7f 08                	jg     800cad <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	83 ec 0c             	sub    $0xc,%esp
  800cb0:	50                   	push   %eax
  800cb1:	6a 03                	push   $0x3
  800cb3:	68 c4 28 80 00       	push   $0x8028c4
  800cb8:	6a 43                	push   $0x43
  800cba:	68 e1 28 80 00       	push   $0x8028e1
  800cbf:	e8 69 14 00 00       	call   80212d <_panic>

00800cc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_yield>:

void
sys_yield(void)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0b:	be 00 00 00 00       	mov    $0x0,%esi
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	b8 04 00 00 00       	mov    $0x4,%eax
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	89 f7                	mov    %esi,%edi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	50                   	push   %eax
  800d32:	6a 04                	push   $0x4
  800d34:	68 c4 28 80 00       	push   $0x8028c4
  800d39:	6a 43                	push   $0x43
  800d3b:	68 e1 28 80 00       	push   $0x8028e1
  800d40:	e8 e8 13 00 00       	call   80212d <_panic>

00800d45 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	b8 05 00 00 00       	mov    $0x5,%eax
  800d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	83 ec 0c             	sub    $0xc,%esp
  800d73:	50                   	push   %eax
  800d74:	6a 05                	push   $0x5
  800d76:	68 c4 28 80 00       	push   $0x8028c4
  800d7b:	6a 43                	push   $0x43
  800d7d:	68 e1 28 80 00       	push   $0x8028e1
  800d82:	e8 a6 13 00 00       	call   80212d <_panic>

00800d87 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	b8 06 00 00 00       	mov    $0x6,%eax
  800da0:	89 df                	mov    %ebx,%edi
  800da2:	89 de                	mov    %ebx,%esi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 06                	push   $0x6
  800db8:	68 c4 28 80 00       	push   $0x8028c4
  800dbd:	6a 43                	push   $0x43
  800dbf:	68 e1 28 80 00       	push   $0x8028e1
  800dc4:	e8 64 13 00 00       	call   80212d <_panic>

00800dc9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddd:	b8 08 00 00 00       	mov    $0x8,%eax
  800de2:	89 df                	mov    %ebx,%edi
  800de4:	89 de                	mov    %ebx,%esi
  800de6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de8:	85 c0                	test   %eax,%eax
  800dea:	7f 08                	jg     800df4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	50                   	push   %eax
  800df8:	6a 08                	push   $0x8
  800dfa:	68 c4 28 80 00       	push   $0x8028c4
  800dff:	6a 43                	push   $0x43
  800e01:	68 e1 28 80 00       	push   $0x8028e1
  800e06:	e8 22 13 00 00       	call   80212d <_panic>

00800e0b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7f 08                	jg     800e36 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e36:	83 ec 0c             	sub    $0xc,%esp
  800e39:	50                   	push   %eax
  800e3a:	6a 09                	push   $0x9
  800e3c:	68 c4 28 80 00       	push   $0x8028c4
  800e41:	6a 43                	push   $0x43
  800e43:	68 e1 28 80 00       	push   $0x8028e1
  800e48:	e8 e0 12 00 00       	call   80212d <_panic>

00800e4d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 0a                	push   $0xa
  800e7e:	68 c4 28 80 00       	push   $0x8028c4
  800e83:	6a 43                	push   $0x43
  800e85:	68 e1 28 80 00       	push   $0x8028e1
  800e8a:	e8 9e 12 00 00       	call   80212d <_panic>

00800e8f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea0:	be 00 00 00 00       	mov    $0x0,%esi
  800ea5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eab:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec8:	89 cb                	mov    %ecx,%ebx
  800eca:	89 cf                	mov    %ecx,%edi
  800ecc:	89 ce                	mov    %ecx,%esi
  800ece:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	7f 08                	jg     800edc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	50                   	push   %eax
  800ee0:	6a 0d                	push   $0xd
  800ee2:	68 c4 28 80 00       	push   $0x8028c4
  800ee7:	6a 43                	push   $0x43
  800ee9:	68 e1 28 80 00       	push   $0x8028e1
  800eee:	e8 3a 12 00 00       	call   80212d <_panic>

00800ef3 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f27:	89 cb                	mov    %ecx,%ebx
  800f29:	89 cf                	mov    %ecx,%edi
  800f2b:	89 ce                	mov    %ecx,%esi
  800f2d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3f:	b8 10 00 00 00       	mov    $0x10,%eax
  800f44:	89 d1                	mov    %edx,%ecx
  800f46:	89 d3                	mov    %edx,%ebx
  800f48:	89 d7                	mov    %edx,%edi
  800f4a:	89 d6                	mov    %edx,%esi
  800f4c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f64:	b8 11 00 00 00       	mov    $0x11,%eax
  800f69:	89 df                	mov    %ebx,%edi
  800f6b:	89 de                	mov    %ebx,%esi
  800f6d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8a:	89 df                	mov    %ebx,%edi
  800f8c:	89 de                	mov    %ebx,%esi
  800f8e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	b8 13 00 00 00       	mov    $0x13,%eax
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7f 08                	jg     800fc0 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	50                   	push   %eax
  800fc4:	6a 13                	push   $0x13
  800fc6:	68 c4 28 80 00       	push   $0x8028c4
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 e1 28 80 00       	push   $0x8028e1
  800fd2:	e8 56 11 00 00       	call   80212d <_panic>

00800fd7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe2:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801006:	89 c2                	mov    %eax,%edx
  801008:	c1 ea 16             	shr    $0x16,%edx
  80100b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801012:	f6 c2 01             	test   $0x1,%dl
  801015:	74 2d                	je     801044 <fd_alloc+0x46>
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 0c             	shr    $0xc,%edx
  80101c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801023:	f6 c2 01             	test   $0x1,%dl
  801026:	74 1c                	je     801044 <fd_alloc+0x46>
  801028:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80102d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801032:	75 d2                	jne    801006 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80103d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801042:	eb 0a                	jmp    80104e <fd_alloc+0x50>
			*fd_store = fd;
  801044:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801047:	89 01                	mov    %eax,(%ecx)
			return 0;
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801056:	83 f8 1f             	cmp    $0x1f,%eax
  801059:	77 30                	ja     80108b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80105b:	c1 e0 0c             	shl    $0xc,%eax
  80105e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801063:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801069:	f6 c2 01             	test   $0x1,%dl
  80106c:	74 24                	je     801092 <fd_lookup+0x42>
  80106e:	89 c2                	mov    %eax,%edx
  801070:	c1 ea 0c             	shr    $0xc,%edx
  801073:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107a:	f6 c2 01             	test   $0x1,%dl
  80107d:	74 1a                	je     801099 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801082:	89 02                	mov    %eax,(%edx)
	return 0;
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    
		return -E_INVAL;
  80108b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801090:	eb f7                	jmp    801089 <fd_lookup+0x39>
		return -E_INVAL;
  801092:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801097:	eb f0                	jmp    801089 <fd_lookup+0x39>
  801099:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109e:	eb e9                	jmp    801089 <fd_lookup+0x39>

008010a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ae:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b3:	39 08                	cmp    %ecx,(%eax)
  8010b5:	74 38                	je     8010ef <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010b7:	83 c2 01             	add    $0x1,%edx
  8010ba:	8b 04 95 6c 29 80 00 	mov    0x80296c(,%edx,4),%eax
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 ee                	jne    8010b3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8010ca:	8b 40 48             	mov    0x48(%eax),%eax
  8010cd:	83 ec 04             	sub    $0x4,%esp
  8010d0:	51                   	push   %ecx
  8010d1:	50                   	push   %eax
  8010d2:	68 f0 28 80 00       	push   $0x8028f0
  8010d7:	e8 d5 f0 ff ff       	call   8001b1 <cprintf>
	*dev = 0;
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    
			*dev = devtab[i];
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f9:	eb f2                	jmp    8010ed <dev_lookup+0x4d>

008010fb <fd_close>:
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	57                   	push   %edi
  8010ff:	56                   	push   %esi
  801100:	53                   	push   %ebx
  801101:	83 ec 24             	sub    $0x24,%esp
  801104:	8b 75 08             	mov    0x8(%ebp),%esi
  801107:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80110a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801114:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801117:	50                   	push   %eax
  801118:	e8 33 ff ff ff       	call   801050 <fd_lookup>
  80111d:	89 c3                	mov    %eax,%ebx
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	85 c0                	test   %eax,%eax
  801124:	78 05                	js     80112b <fd_close+0x30>
	    || fd != fd2)
  801126:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801129:	74 16                	je     801141 <fd_close+0x46>
		return (must_exist ? r : 0);
  80112b:	89 f8                	mov    %edi,%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
  801134:	0f 44 d8             	cmove  %eax,%ebx
}
  801137:	89 d8                	mov    %ebx,%eax
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801147:	50                   	push   %eax
  801148:	ff 36                	pushl  (%esi)
  80114a:	e8 51 ff ff ff       	call   8010a0 <dev_lookup>
  80114f:	89 c3                	mov    %eax,%ebx
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 1a                	js     801172 <fd_close+0x77>
		if (dev->dev_close)
  801158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801163:	85 c0                	test   %eax,%eax
  801165:	74 0b                	je     801172 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801167:	83 ec 0c             	sub    $0xc,%esp
  80116a:	56                   	push   %esi
  80116b:	ff d0                	call   *%eax
  80116d:	89 c3                	mov    %eax,%ebx
  80116f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	56                   	push   %esi
  801176:	6a 00                	push   $0x0
  801178:	e8 0a fc ff ff       	call   800d87 <sys_page_unmap>
	return r;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	eb b5                	jmp    801137 <fd_close+0x3c>

00801182 <close>:

int
close(int fdnum)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801188:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 bc fe ff ff       	call   801050 <fd_lookup>
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	79 02                	jns    80119d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    
		return fd_close(fd, 1);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	6a 01                	push   $0x1
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	e8 51 ff ff ff       	call   8010fb <fd_close>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	eb ec                	jmp    80119b <close+0x19>

008011af <close_all>:

void
close_all(void)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	53                   	push   %ebx
  8011bf:	e8 be ff ff ff       	call   801182 <close>
	for (i = 0; i < MAXFD; i++)
  8011c4:	83 c3 01             	add    $0x1,%ebx
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	83 fb 20             	cmp    $0x20,%ebx
  8011cd:	75 ec                	jne    8011bb <close_all+0xc>
}
  8011cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	57                   	push   %edi
  8011d8:	56                   	push   %esi
  8011d9:	53                   	push   %ebx
  8011da:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e0:	50                   	push   %eax
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 67 fe ff ff       	call   801050 <fd_lookup>
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	0f 88 81 00 00 00    	js     801277 <dup+0xa3>
		return r;
	close(newfdnum);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 81 ff ff ff       	call   801182 <close>

	newfd = INDEX2FD(newfdnum);
  801201:	8b 75 0c             	mov    0xc(%ebp),%esi
  801204:	c1 e6 0c             	shl    $0xc,%esi
  801207:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	ff 75 e4             	pushl  -0x1c(%ebp)
  801213:	e8 cf fd ff ff       	call   800fe7 <fd2data>
  801218:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80121a:	89 34 24             	mov    %esi,(%esp)
  80121d:	e8 c5 fd ff ff       	call   800fe7 <fd2data>
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801227:	89 d8                	mov    %ebx,%eax
  801229:	c1 e8 16             	shr    $0x16,%eax
  80122c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801233:	a8 01                	test   $0x1,%al
  801235:	74 11                	je     801248 <dup+0x74>
  801237:	89 d8                	mov    %ebx,%eax
  801239:	c1 e8 0c             	shr    $0xc,%eax
  80123c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801243:	f6 c2 01             	test   $0x1,%dl
  801246:	75 39                	jne    801281 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	c1 e8 0c             	shr    $0xc,%eax
  801250:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	25 07 0e 00 00       	and    $0xe07,%eax
  80125f:	50                   	push   %eax
  801260:	56                   	push   %esi
  801261:	6a 00                	push   $0x0
  801263:	52                   	push   %edx
  801264:	6a 00                	push   $0x0
  801266:	e8 da fa ff ff       	call   800d45 <sys_page_map>
  80126b:	89 c3                	mov    %eax,%ebx
  80126d:	83 c4 20             	add    $0x20,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 31                	js     8012a5 <dup+0xd1>
		goto err;

	return newfdnum;
  801274:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801277:	89 d8                	mov    %ebx,%eax
  801279:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127c:	5b                   	pop    %ebx
  80127d:	5e                   	pop    %esi
  80127e:	5f                   	pop    %edi
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801281:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	25 07 0e 00 00       	and    $0xe07,%eax
  801290:	50                   	push   %eax
  801291:	57                   	push   %edi
  801292:	6a 00                	push   $0x0
  801294:	53                   	push   %ebx
  801295:	6a 00                	push   $0x0
  801297:	e8 a9 fa ff ff       	call   800d45 <sys_page_map>
  80129c:	89 c3                	mov    %eax,%ebx
  80129e:	83 c4 20             	add    $0x20,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	79 a3                	jns    801248 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	56                   	push   %esi
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 d7 fa ff ff       	call   800d87 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	57                   	push   %edi
  8012b4:	6a 00                	push   $0x0
  8012b6:	e8 cc fa ff ff       	call   800d87 <sys_page_unmap>
	return r;
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	eb b7                	jmp    801277 <dup+0xa3>

008012c0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	53                   	push   %ebx
  8012c4:	83 ec 1c             	sub    $0x1c,%esp
  8012c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	53                   	push   %ebx
  8012cf:	e8 7c fd ff ff       	call   801050 <fd_lookup>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 3f                	js     80131a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e5:	ff 30                	pushl  (%eax)
  8012e7:	e8 b4 fd ff ff       	call   8010a0 <dev_lookup>
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 27                	js     80131a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f6:	8b 42 08             	mov    0x8(%edx),%eax
  8012f9:	83 e0 03             	and    $0x3,%eax
  8012fc:	83 f8 01             	cmp    $0x1,%eax
  8012ff:	74 1e                	je     80131f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801304:	8b 40 08             	mov    0x8(%eax),%eax
  801307:	85 c0                	test   %eax,%eax
  801309:	74 35                	je     801340 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	ff 75 10             	pushl  0x10(%ebp)
  801311:	ff 75 0c             	pushl  0xc(%ebp)
  801314:	52                   	push   %edx
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
}
  80131a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80131f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801324:	8b 40 48             	mov    0x48(%eax),%eax
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	53                   	push   %ebx
  80132b:	50                   	push   %eax
  80132c:	68 31 29 80 00       	push   $0x802931
  801331:	e8 7b ee ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133e:	eb da                	jmp    80131a <read+0x5a>
		return -E_NOT_SUPP;
  801340:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801345:	eb d3                	jmp    80131a <read+0x5a>

00801347 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	57                   	push   %edi
  80134b:	56                   	push   %esi
  80134c:	53                   	push   %ebx
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	8b 7d 08             	mov    0x8(%ebp),%edi
  801353:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801356:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135b:	39 f3                	cmp    %esi,%ebx
  80135d:	73 23                	jae    801382 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	89 f0                	mov    %esi,%eax
  801364:	29 d8                	sub    %ebx,%eax
  801366:	50                   	push   %eax
  801367:	89 d8                	mov    %ebx,%eax
  801369:	03 45 0c             	add    0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	57                   	push   %edi
  80136e:	e8 4d ff ff ff       	call   8012c0 <read>
		if (m < 0)
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	78 06                	js     801380 <readn+0x39>
			return m;
		if (m == 0)
  80137a:	74 06                	je     801382 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80137c:	01 c3                	add    %eax,%ebx
  80137e:	eb db                	jmp    80135b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801380:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801382:	89 d8                	mov    %ebx,%eax
  801384:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	53                   	push   %ebx
  801390:	83 ec 1c             	sub    $0x1c,%esp
  801393:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801396:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801399:	50                   	push   %eax
  80139a:	53                   	push   %ebx
  80139b:	e8 b0 fc ff ff       	call   801050 <fd_lookup>
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 3a                	js     8013e1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	ff 30                	pushl  (%eax)
  8013b3:	e8 e8 fc ff ff       	call   8010a0 <dev_lookup>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 22                	js     8013e1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c6:	74 1e                	je     8013e6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ce:	85 d2                	test   %edx,%edx
  8013d0:	74 35                	je     801407 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	ff 75 10             	pushl  0x10(%ebp)
  8013d8:	ff 75 0c             	pushl  0xc(%ebp)
  8013db:	50                   	push   %eax
  8013dc:	ff d2                	call   *%edx
  8013de:	83 c4 10             	add    $0x10,%esp
}
  8013e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013eb:	8b 40 48             	mov    0x48(%eax),%eax
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	53                   	push   %ebx
  8013f2:	50                   	push   %eax
  8013f3:	68 4d 29 80 00       	push   $0x80294d
  8013f8:	e8 b4 ed ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801405:	eb da                	jmp    8013e1 <write+0x55>
		return -E_NOT_SUPP;
  801407:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140c:	eb d3                	jmp    8013e1 <write+0x55>

0080140e <seek>:

int
seek(int fdnum, off_t offset)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801414:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	ff 75 08             	pushl  0x8(%ebp)
  80141b:	e8 30 fc ff ff       	call   801050 <fd_lookup>
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	78 0e                	js     801435 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 1c             	sub    $0x1c,%esp
  80143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	53                   	push   %ebx
  801446:	e8 05 fc ff ff       	call   801050 <fd_lookup>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 37                	js     801489 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	ff 30                	pushl  (%eax)
  80145e:	e8 3d fc ff ff       	call   8010a0 <dev_lookup>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 1f                	js     801489 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801471:	74 1b                	je     80148e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801476:	8b 52 18             	mov    0x18(%edx),%edx
  801479:	85 d2                	test   %edx,%edx
  80147b:	74 32                	je     8014af <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	50                   	push   %eax
  801484:	ff d2                	call   *%edx
  801486:	83 c4 10             	add    $0x10,%esp
}
  801489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80148e:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801493:	8b 40 48             	mov    0x48(%eax),%eax
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	53                   	push   %ebx
  80149a:	50                   	push   %eax
  80149b:	68 10 29 80 00       	push   $0x802910
  8014a0:	e8 0c ed ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ad:	eb da                	jmp    801489 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b4:	eb d3                	jmp    801489 <ftruncate+0x52>

008014b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 1c             	sub    $0x1c,%esp
  8014bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	ff 75 08             	pushl  0x8(%ebp)
  8014c7:	e8 84 fb ff ff       	call   801050 <fd_lookup>
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 4b                	js     80151e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dd:	ff 30                	pushl  (%eax)
  8014df:	e8 bc fb ff ff       	call   8010a0 <dev_lookup>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 33                	js     80151e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ee:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f2:	74 2f                	je     801523 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014fe:	00 00 00 
	stat->st_isdir = 0;
  801501:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801508:	00 00 00 
	stat->st_dev = dev;
  80150b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	53                   	push   %ebx
  801515:	ff 75 f0             	pushl  -0x10(%ebp)
  801518:	ff 50 14             	call   *0x14(%eax)
  80151b:	83 c4 10             	add    $0x10,%esp
}
  80151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801521:	c9                   	leave  
  801522:	c3                   	ret    
		return -E_NOT_SUPP;
  801523:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801528:	eb f4                	jmp    80151e <fstat+0x68>

0080152a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	56                   	push   %esi
  80152e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	6a 00                	push   $0x0
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 22 02 00 00       	call   80175e <open>
  80153c:	89 c3                	mov    %eax,%ebx
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 1b                	js     801560 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	50                   	push   %eax
  80154c:	e8 65 ff ff ff       	call   8014b6 <fstat>
  801551:	89 c6                	mov    %eax,%esi
	close(fd);
  801553:	89 1c 24             	mov    %ebx,(%esp)
  801556:	e8 27 fc ff ff       	call   801182 <close>
	return r;
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	89 f3                	mov    %esi,%ebx
}
  801560:	89 d8                	mov    %ebx,%eax
  801562:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	89 c6                	mov    %eax,%esi
  801570:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801572:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801579:	74 27                	je     8015a2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80157b:	6a 07                	push   $0x7
  80157d:	68 00 50 80 00       	push   $0x805000
  801582:	56                   	push   %esi
  801583:	ff 35 00 40 80 00    	pushl  0x804000
  801589:	e8 69 0c 00 00       	call   8021f7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80158e:	83 c4 0c             	add    $0xc,%esp
  801591:	6a 00                	push   $0x0
  801593:	53                   	push   %ebx
  801594:	6a 00                	push   $0x0
  801596:	e8 f3 0b 00 00       	call   80218e <ipc_recv>
}
  80159b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	6a 01                	push   $0x1
  8015a7:	e8 a3 0c 00 00       	call   80224f <ipc_find_env>
  8015ac:	a3 00 40 80 00       	mov    %eax,0x804000
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	eb c5                	jmp    80157b <fsipc+0x12>

008015b6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d9:	e8 8b ff ff ff       	call   801569 <fsipc>
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <devfile_flush>:
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ec:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8015fb:	e8 69 ff ff ff       	call   801569 <fsipc>
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <devfile_stat>:
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	53                   	push   %ebx
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8b 40 0c             	mov    0xc(%eax),%eax
  801612:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801617:	ba 00 00 00 00       	mov    $0x0,%edx
  80161c:	b8 05 00 00 00       	mov    $0x5,%eax
  801621:	e8 43 ff ff ff       	call   801569 <fsipc>
  801626:	85 c0                	test   %eax,%eax
  801628:	78 2c                	js     801656 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	68 00 50 80 00       	push   $0x805000
  801632:	53                   	push   %ebx
  801633:	e8 d8 f2 ff ff       	call   800910 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801638:	a1 80 50 80 00       	mov    0x805080,%eax
  80163d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801643:	a1 84 50 80 00       	mov    0x805084,%eax
  801648:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <devfile_write>:
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8b 40 0c             	mov    0xc(%eax),%eax
  80166b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801670:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801676:	53                   	push   %ebx
  801677:	ff 75 0c             	pushl  0xc(%ebp)
  80167a:	68 08 50 80 00       	push   $0x805008
  80167f:	e8 7c f4 ff ff       	call   800b00 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801684:	ba 00 00 00 00       	mov    $0x0,%edx
  801689:	b8 04 00 00 00       	mov    $0x4,%eax
  80168e:	e8 d6 fe ff ff       	call   801569 <fsipc>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	85 c0                	test   %eax,%eax
  801698:	78 0b                	js     8016a5 <devfile_write+0x4a>
	assert(r <= n);
  80169a:	39 d8                	cmp    %ebx,%eax
  80169c:	77 0c                	ja     8016aa <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80169e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a3:	7f 1e                	jg     8016c3 <devfile_write+0x68>
}
  8016a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    
	assert(r <= n);
  8016aa:	68 80 29 80 00       	push   $0x802980
  8016af:	68 87 29 80 00       	push   $0x802987
  8016b4:	68 98 00 00 00       	push   $0x98
  8016b9:	68 9c 29 80 00       	push   $0x80299c
  8016be:	e8 6a 0a 00 00       	call   80212d <_panic>
	assert(r <= PGSIZE);
  8016c3:	68 a7 29 80 00       	push   $0x8029a7
  8016c8:	68 87 29 80 00       	push   $0x802987
  8016cd:	68 99 00 00 00       	push   $0x99
  8016d2:	68 9c 29 80 00       	push   $0x80299c
  8016d7:	e8 51 0a 00 00       	call   80212d <_panic>

008016dc <devfile_read>:
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ea:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ef:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ff:	e8 65 fe ff ff       	call   801569 <fsipc>
  801704:	89 c3                	mov    %eax,%ebx
  801706:	85 c0                	test   %eax,%eax
  801708:	78 1f                	js     801729 <devfile_read+0x4d>
	assert(r <= n);
  80170a:	39 f0                	cmp    %esi,%eax
  80170c:	77 24                	ja     801732 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80170e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801713:	7f 33                	jg     801748 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	50                   	push   %eax
  801719:	68 00 50 80 00       	push   $0x805000
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	e8 78 f3 ff ff       	call   800a9e <memmove>
	return r;
  801726:	83 c4 10             	add    $0x10,%esp
}
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172e:	5b                   	pop    %ebx
  80172f:	5e                   	pop    %esi
  801730:	5d                   	pop    %ebp
  801731:	c3                   	ret    
	assert(r <= n);
  801732:	68 80 29 80 00       	push   $0x802980
  801737:	68 87 29 80 00       	push   $0x802987
  80173c:	6a 7c                	push   $0x7c
  80173e:	68 9c 29 80 00       	push   $0x80299c
  801743:	e8 e5 09 00 00       	call   80212d <_panic>
	assert(r <= PGSIZE);
  801748:	68 a7 29 80 00       	push   $0x8029a7
  80174d:	68 87 29 80 00       	push   $0x802987
  801752:	6a 7d                	push   $0x7d
  801754:	68 9c 29 80 00       	push   $0x80299c
  801759:	e8 cf 09 00 00       	call   80212d <_panic>

0080175e <open>:
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	83 ec 1c             	sub    $0x1c,%esp
  801766:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801769:	56                   	push   %esi
  80176a:	e8 68 f1 ff ff       	call   8008d7 <strlen>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801777:	7f 6c                	jg     8017e5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177f:	50                   	push   %eax
  801780:	e8 79 f8 ff ff       	call   800ffe <fd_alloc>
  801785:	89 c3                	mov    %eax,%ebx
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 3c                	js     8017ca <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	56                   	push   %esi
  801792:	68 00 50 80 00       	push   $0x805000
  801797:	e8 74 f1 ff ff       	call   800910 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80179c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ac:	e8 b8 fd ff ff       	call   801569 <fsipc>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 19                	js     8017d3 <open+0x75>
	return fd2num(fd);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c0:	e8 12 f8 ff ff       	call   800fd7 <fd2num>
  8017c5:	89 c3                	mov    %eax,%ebx
  8017c7:	83 c4 10             	add    $0x10,%esp
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    
		fd_close(fd, 0);
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017db:	e8 1b f9 ff ff       	call   8010fb <fd_close>
		return r;
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	eb e5                	jmp    8017ca <open+0x6c>
		return -E_BAD_PATH;
  8017e5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017ea:	eb de                	jmp    8017ca <open+0x6c>

008017ec <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8017fc:	e8 68 fd ff ff       	call   801569 <fsipc>
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801809:	68 b3 29 80 00       	push   $0x8029b3
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	e8 fa f0 ff ff       	call   800910 <strcpy>
	return 0;
}
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <devsock_close>:
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	53                   	push   %ebx
  801821:	83 ec 10             	sub    $0x10,%esp
  801824:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801827:	53                   	push   %ebx
  801828:	e8 5d 0a 00 00       	call   80228a <pageref>
  80182d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801830:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801835:	83 f8 01             	cmp    $0x1,%eax
  801838:	74 07                	je     801841 <devsock_close+0x24>
}
  80183a:	89 d0                	mov    %edx,%eax
  80183c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183f:	c9                   	leave  
  801840:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	ff 73 0c             	pushl  0xc(%ebx)
  801847:	e8 b9 02 00 00       	call   801b05 <nsipc_close>
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	eb e7                	jmp    80183a <devsock_close+0x1d>

00801853 <devsock_write>:
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801859:	6a 00                	push   $0x0
  80185b:	ff 75 10             	pushl  0x10(%ebp)
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	ff 70 0c             	pushl  0xc(%eax)
  801867:	e8 76 03 00 00       	call   801be2 <nsipc_send>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devsock_read>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801874:	6a 00                	push   $0x0
  801876:	ff 75 10             	pushl  0x10(%ebp)
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	ff 70 0c             	pushl  0xc(%eax)
  801882:	e8 ef 02 00 00       	call   801b76 <nsipc_recv>
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <fd2sockid>:
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80188f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	e8 b7 f7 ff ff       	call   801050 <fd_lookup>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 10                	js     8018b0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018a9:	39 08                	cmp    %ecx,(%eax)
  8018ab:	75 05                	jne    8018b2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018ad:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b7:	eb f7                	jmp    8018b0 <fd2sockid+0x27>

008018b9 <alloc_sockfd>:
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 1c             	sub    $0x1c,%esp
  8018c1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c6:	50                   	push   %eax
  8018c7:	e8 32 f7 ff ff       	call   800ffe <fd_alloc>
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 43                	js     801918 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	68 07 04 00 00       	push   $0x407
  8018dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 1b f4 ff ff       	call   800d02 <sys_page_alloc>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 28                	js     801918 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801905:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	50                   	push   %eax
  80190c:	e8 c6 f6 ff ff       	call   800fd7 <fd2num>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	eb 0c                	jmp    801924 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	56                   	push   %esi
  80191c:	e8 e4 01 00 00       	call   801b05 <nsipc_close>
		return r;
  801921:	83 c4 10             	add    $0x10,%esp
}
  801924:	89 d8                	mov    %ebx,%eax
  801926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <accept>:
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	e8 4e ff ff ff       	call   801889 <fd2sockid>
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 1b                	js     80195a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	e8 0e 01 00 00       	call   801a5c <nsipc_accept>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 05                	js     80195a <accept+0x2d>
	return alloc_sockfd(r);
  801955:	e8 5f ff ff ff       	call   8018b9 <alloc_sockfd>
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <bind>:
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	e8 1f ff ff ff       	call   801889 <fd2sockid>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 12                	js     801980 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	50                   	push   %eax
  801978:	e8 31 01 00 00       	call   801aae <nsipc_bind>
  80197d:	83 c4 10             	add    $0x10,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <shutdown>:
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	e8 f9 fe ff ff       	call   801889 <fd2sockid>
  801990:	85 c0                	test   %eax,%eax
  801992:	78 0f                	js     8019a3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	50                   	push   %eax
  80199b:	e8 43 01 00 00       	call   801ae3 <nsipc_shutdown>
  8019a0:	83 c4 10             	add    $0x10,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <connect>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	e8 d6 fe ff ff       	call   801889 <fd2sockid>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 12                	js     8019c9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	ff 75 10             	pushl  0x10(%ebp)
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	e8 59 01 00 00       	call   801b1f <nsipc_connect>
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <listen>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	e8 b0 fe ff ff       	call   801889 <fd2sockid>
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 0f                	js     8019ec <listen+0x21>
	return nsipc_listen(r, backlog);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	e8 6b 01 00 00       	call   801b54 <nsipc_listen>
  8019e9:	83 c4 10             	add    $0x10,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <socket>:

int
socket(int domain, int type, int protocol)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	e8 3e 02 00 00       	call   801c40 <nsipc_socket>
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 05                	js     801a0e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a09:	e8 ab fe ff ff       	call   8018b9 <alloc_sockfd>
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	53                   	push   %ebx
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a19:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a20:	74 26                	je     801a48 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a22:	6a 07                	push   $0x7
  801a24:	68 00 60 80 00       	push   $0x806000
  801a29:	53                   	push   %ebx
  801a2a:	ff 35 04 40 80 00    	pushl  0x804004
  801a30:	e8 c2 07 00 00       	call   8021f7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a35:	83 c4 0c             	add    $0xc,%esp
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	e8 4b 07 00 00       	call   80218e <ipc_recv>
}
  801a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a48:	83 ec 0c             	sub    $0xc,%esp
  801a4b:	6a 02                	push   $0x2
  801a4d:	e8 fd 07 00 00       	call   80224f <ipc_find_env>
  801a52:	a3 04 40 80 00       	mov    %eax,0x804004
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	eb c6                	jmp    801a22 <nsipc+0x12>

00801a5c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
  801a61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a6c:	8b 06                	mov    (%esi),%eax
  801a6e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a73:	b8 01 00 00 00       	mov    $0x1,%eax
  801a78:	e8 93 ff ff ff       	call   801a10 <nsipc>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	79 09                	jns    801a8c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a83:	89 d8                	mov    %ebx,%eax
  801a85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5e                   	pop    %esi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	ff 35 10 60 80 00    	pushl  0x806010
  801a95:	68 00 60 80 00       	push   $0x806000
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	e8 fc ef ff ff       	call   800a9e <memmove>
		*addrlen = ret->ret_addrlen;
  801aa2:	a1 10 60 80 00       	mov    0x806010,%eax
  801aa7:	89 06                	mov    %eax,(%esi)
  801aa9:	83 c4 10             	add    $0x10,%esp
	return r;
  801aac:	eb d5                	jmp    801a83 <nsipc_accept+0x27>

00801aae <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	53                   	push   %ebx
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ac0:	53                   	push   %ebx
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	68 04 60 80 00       	push   $0x806004
  801ac9:	e8 d0 ef ff ff       	call   800a9e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ace:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ad4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ad9:	e8 32 ff ff ff       	call   801a10 <nsipc>
}
  801ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801af9:	b8 03 00 00 00       	mov    $0x3,%eax
  801afe:	e8 0d ff ff ff       	call   801a10 <nsipc>
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <nsipc_close>:

int
nsipc_close(int s)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b13:	b8 04 00 00 00       	mov    $0x4,%eax
  801b18:	e8 f3 fe ff ff       	call   801a10 <nsipc>
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 08             	sub    $0x8,%esp
  801b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b31:	53                   	push   %ebx
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	68 04 60 80 00       	push   $0x806004
  801b3a:	e8 5f ef ff ff       	call   800a9e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b3f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b45:	b8 05 00 00 00       	mov    $0x5,%eax
  801b4a:	e8 c1 fe ff ff       	call   801a10 <nsipc>
}
  801b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b65:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b6a:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6f:	e8 9c fe ff ff       	call   801a10 <nsipc>
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b86:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b94:	b8 07 00 00 00       	mov    $0x7,%eax
  801b99:	e8 72 fe ff ff       	call   801a10 <nsipc>
  801b9e:	89 c3                	mov    %eax,%ebx
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 1f                	js     801bc3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ba4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ba9:	7f 21                	jg     801bcc <nsipc_recv+0x56>
  801bab:	39 c6                	cmp    %eax,%esi
  801bad:	7c 1d                	jl     801bcc <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	50                   	push   %eax
  801bb3:	68 00 60 80 00       	push   $0x806000
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	e8 de ee ff ff       	call   800a9e <memmove>
  801bc0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bc3:	89 d8                	mov    %ebx,%eax
  801bc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bcc:	68 bf 29 80 00       	push   $0x8029bf
  801bd1:	68 87 29 80 00       	push   $0x802987
  801bd6:	6a 62                	push   $0x62
  801bd8:	68 d4 29 80 00       	push   $0x8029d4
  801bdd:	e8 4b 05 00 00       	call   80212d <_panic>

00801be2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	53                   	push   %ebx
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bf4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bfa:	7f 2e                	jg     801c2a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bfc:	83 ec 04             	sub    $0x4,%esp
  801bff:	53                   	push   %ebx
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	68 0c 60 80 00       	push   $0x80600c
  801c08:	e8 91 ee ff ff       	call   800a9e <memmove>
	nsipcbuf.send.req_size = size;
  801c0d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c13:	8b 45 14             	mov    0x14(%ebp),%eax
  801c16:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c1b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c20:	e8 eb fd ff ff       	call   801a10 <nsipc>
}
  801c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    
	assert(size < 1600);
  801c2a:	68 e0 29 80 00       	push   $0x8029e0
  801c2f:	68 87 29 80 00       	push   $0x802987
  801c34:	6a 6d                	push   $0x6d
  801c36:	68 d4 29 80 00       	push   $0x8029d4
  801c3b:	e8 ed 04 00 00       	call   80212d <_panic>

00801c40 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c56:	8b 45 10             	mov    0x10(%ebp),%eax
  801c59:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c5e:	b8 09 00 00 00       	mov    $0x9,%eax
  801c63:	e8 a8 fd ff ff       	call   801a10 <nsipc>
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	56                   	push   %esi
  801c6e:	53                   	push   %ebx
  801c6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	e8 6a f3 ff ff       	call   800fe7 <fd2data>
  801c7d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c7f:	83 c4 08             	add    $0x8,%esp
  801c82:	68 ec 29 80 00       	push   $0x8029ec
  801c87:	53                   	push   %ebx
  801c88:	e8 83 ec ff ff       	call   800910 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c8d:	8b 46 04             	mov    0x4(%esi),%eax
  801c90:	2b 06                	sub    (%esi),%eax
  801c92:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c98:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9f:	00 00 00 
	stat->st_dev = &devpipe;
  801ca2:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ca9:	30 80 00 
	return 0;
}
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    

00801cb8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cc2:	53                   	push   %ebx
  801cc3:	6a 00                	push   $0x0
  801cc5:	e8 bd f0 ff ff       	call   800d87 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cca:	89 1c 24             	mov    %ebx,(%esp)
  801ccd:	e8 15 f3 ff ff       	call   800fe7 <fd2data>
  801cd2:	83 c4 08             	add    $0x8,%esp
  801cd5:	50                   	push   %eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	e8 aa f0 ff ff       	call   800d87 <sys_page_unmap>
}
  801cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <_pipeisclosed>:
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	57                   	push   %edi
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
  801ce8:	83 ec 1c             	sub    $0x1c,%esp
  801ceb:	89 c7                	mov    %eax,%edi
  801ced:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cef:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801cf4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	57                   	push   %edi
  801cfb:	e8 8a 05 00 00       	call   80228a <pageref>
  801d00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d03:	89 34 24             	mov    %esi,(%esp)
  801d06:	e8 7f 05 00 00       	call   80228a <pageref>
		nn = thisenv->env_runs;
  801d0b:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801d11:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	39 cb                	cmp    %ecx,%ebx
  801d19:	74 1b                	je     801d36 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d1b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1e:	75 cf                	jne    801cef <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d20:	8b 42 58             	mov    0x58(%edx),%eax
  801d23:	6a 01                	push   $0x1
  801d25:	50                   	push   %eax
  801d26:	53                   	push   %ebx
  801d27:	68 f3 29 80 00       	push   $0x8029f3
  801d2c:	e8 80 e4 ff ff       	call   8001b1 <cprintf>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	eb b9                	jmp    801cef <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d36:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d39:	0f 94 c0             	sete   %al
  801d3c:	0f b6 c0             	movzbl %al,%eax
}
  801d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    

00801d47 <devpipe_write>:
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	57                   	push   %edi
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	83 ec 28             	sub    $0x28,%esp
  801d50:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d53:	56                   	push   %esi
  801d54:	e8 8e f2 ff ff       	call   800fe7 <fd2data>
  801d59:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d63:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d66:	74 4f                	je     801db7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d68:	8b 43 04             	mov    0x4(%ebx),%eax
  801d6b:	8b 0b                	mov    (%ebx),%ecx
  801d6d:	8d 51 20             	lea    0x20(%ecx),%edx
  801d70:	39 d0                	cmp    %edx,%eax
  801d72:	72 14                	jb     801d88 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d74:	89 da                	mov    %ebx,%edx
  801d76:	89 f0                	mov    %esi,%eax
  801d78:	e8 65 ff ff ff       	call   801ce2 <_pipeisclosed>
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	75 3b                	jne    801dbc <devpipe_write+0x75>
			sys_yield();
  801d81:	e8 5d ef ff ff       	call   800ce3 <sys_yield>
  801d86:	eb e0                	jmp    801d68 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d8f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d92:	89 c2                	mov    %eax,%edx
  801d94:	c1 fa 1f             	sar    $0x1f,%edx
  801d97:	89 d1                	mov    %edx,%ecx
  801d99:	c1 e9 1b             	shr    $0x1b,%ecx
  801d9c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d9f:	83 e2 1f             	and    $0x1f,%edx
  801da2:	29 ca                	sub    %ecx,%edx
  801da4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801da8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dac:	83 c0 01             	add    $0x1,%eax
  801daf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801db2:	83 c7 01             	add    $0x1,%edi
  801db5:	eb ac                	jmp    801d63 <devpipe_write+0x1c>
	return i;
  801db7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dba:	eb 05                	jmp    801dc1 <devpipe_write+0x7a>
				return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <devpipe_read>:
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	57                   	push   %edi
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 18             	sub    $0x18,%esp
  801dd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dd5:	57                   	push   %edi
  801dd6:	e8 0c f2 ff ff       	call   800fe7 <fd2data>
  801ddb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	be 00 00 00 00       	mov    $0x0,%esi
  801de5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801de8:	75 14                	jne    801dfe <devpipe_read+0x35>
	return i;
  801dea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ded:	eb 02                	jmp    801df1 <devpipe_read+0x28>
				return i;
  801def:	89 f0                	mov    %esi,%eax
}
  801df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
			sys_yield();
  801df9:	e8 e5 ee ff ff       	call   800ce3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dfe:	8b 03                	mov    (%ebx),%eax
  801e00:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e03:	75 18                	jne    801e1d <devpipe_read+0x54>
			if (i > 0)
  801e05:	85 f6                	test   %esi,%esi
  801e07:	75 e6                	jne    801def <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e09:	89 da                	mov    %ebx,%edx
  801e0b:	89 f8                	mov    %edi,%eax
  801e0d:	e8 d0 fe ff ff       	call   801ce2 <_pipeisclosed>
  801e12:	85 c0                	test   %eax,%eax
  801e14:	74 e3                	je     801df9 <devpipe_read+0x30>
				return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	eb d4                	jmp    801df1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e1d:	99                   	cltd   
  801e1e:	c1 ea 1b             	shr    $0x1b,%edx
  801e21:	01 d0                	add    %edx,%eax
  801e23:	83 e0 1f             	and    $0x1f,%eax
  801e26:	29 d0                	sub    %edx,%eax
  801e28:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e30:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e33:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e36:	83 c6 01             	add    $0x1,%esi
  801e39:	eb aa                	jmp    801de5 <devpipe_read+0x1c>

00801e3b <pipe>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e46:	50                   	push   %eax
  801e47:	e8 b2 f1 ff ff       	call   800ffe <fd_alloc>
  801e4c:	89 c3                	mov    %eax,%ebx
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	0f 88 23 01 00 00    	js     801f7c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 07 04 00 00       	push   $0x407
  801e61:	ff 75 f4             	pushl  -0xc(%ebp)
  801e64:	6a 00                	push   $0x0
  801e66:	e8 97 ee ff ff       	call   800d02 <sys_page_alloc>
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	0f 88 04 01 00 00    	js     801f7c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e7e:	50                   	push   %eax
  801e7f:	e8 7a f1 ff ff       	call   800ffe <fd_alloc>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 88 db 00 00 00    	js     801f6c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e91:	83 ec 04             	sub    $0x4,%esp
  801e94:	68 07 04 00 00       	push   $0x407
  801e99:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 5f ee ff ff       	call   800d02 <sys_page_alloc>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	0f 88 bc 00 00 00    	js     801f6c <pipe+0x131>
	va = fd2data(fd0);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb6:	e8 2c f1 ff ff       	call   800fe7 <fd2data>
  801ebb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebd:	83 c4 0c             	add    $0xc,%esp
  801ec0:	68 07 04 00 00       	push   $0x407
  801ec5:	50                   	push   %eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 35 ee ff ff       	call   800d02 <sys_page_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	0f 88 82 00 00 00    	js     801f5c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee0:	e8 02 f1 ff ff       	call   800fe7 <fd2data>
  801ee5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eec:	50                   	push   %eax
  801eed:	6a 00                	push   $0x0
  801eef:	56                   	push   %esi
  801ef0:	6a 00                	push   $0x0
  801ef2:	e8 4e ee ff ff       	call   800d45 <sys_page_map>
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	83 c4 20             	add    $0x20,%esp
  801efc:	85 c0                	test   %eax,%eax
  801efe:	78 4e                	js     801f4e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f00:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f08:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f17:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	e8 a9 f0 ff ff       	call   800fd7 <fd2num>
  801f2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f31:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f33:	83 c4 04             	add    $0x4,%esp
  801f36:	ff 75 f0             	pushl  -0x10(%ebp)
  801f39:	e8 99 f0 ff ff       	call   800fd7 <fd2num>
  801f3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f41:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f4c:	eb 2e                	jmp    801f7c <pipe+0x141>
	sys_page_unmap(0, va);
  801f4e:	83 ec 08             	sub    $0x8,%esp
  801f51:	56                   	push   %esi
  801f52:	6a 00                	push   $0x0
  801f54:	e8 2e ee ff ff       	call   800d87 <sys_page_unmap>
  801f59:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f5c:	83 ec 08             	sub    $0x8,%esp
  801f5f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f62:	6a 00                	push   $0x0
  801f64:	e8 1e ee ff ff       	call   800d87 <sys_page_unmap>
  801f69:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f6c:	83 ec 08             	sub    $0x8,%esp
  801f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f72:	6a 00                	push   $0x0
  801f74:	e8 0e ee ff ff       	call   800d87 <sys_page_unmap>
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <pipeisclosed>:
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8e:	50                   	push   %eax
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	e8 b9 f0 ff ff       	call   801050 <fd_lookup>
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 18                	js     801fb6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa4:	e8 3e f0 ff ff       	call   800fe7 <fd2data>
	return _pipeisclosed(fd, p);
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	e8 2f fd ff ff       	call   801ce2 <_pipeisclosed>
  801fb3:	83 c4 10             	add    $0x10,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	c3                   	ret    

00801fbe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc4:	68 0b 2a 80 00       	push   $0x802a0b
  801fc9:	ff 75 0c             	pushl  0xc(%ebp)
  801fcc:	e8 3f e9 ff ff       	call   800910 <strcpy>
	return 0;
}
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <devcons_write>:
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	57                   	push   %edi
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fef:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff2:	73 31                	jae    802025 <devcons_write+0x4d>
		m = n - tot;
  801ff4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff7:	29 f3                	sub    %esi,%ebx
  801ff9:	83 fb 7f             	cmp    $0x7f,%ebx
  801ffc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802001:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	53                   	push   %ebx
  802008:	89 f0                	mov    %esi,%eax
  80200a:	03 45 0c             	add    0xc(%ebp),%eax
  80200d:	50                   	push   %eax
  80200e:	57                   	push   %edi
  80200f:	e8 8a ea ff ff       	call   800a9e <memmove>
		sys_cputs(buf, m);
  802014:	83 c4 08             	add    $0x8,%esp
  802017:	53                   	push   %ebx
  802018:	57                   	push   %edi
  802019:	e8 28 ec ff ff       	call   800c46 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80201e:	01 de                	add    %ebx,%esi
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	eb ca                	jmp    801fef <devcons_write+0x17>
}
  802025:	89 f0                	mov    %esi,%eax
  802027:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202a:	5b                   	pop    %ebx
  80202b:	5e                   	pop    %esi
  80202c:	5f                   	pop    %edi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    

0080202f <devcons_read>:
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 08             	sub    $0x8,%esp
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80203a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203e:	74 21                	je     802061 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802040:	e8 1f ec ff ff       	call   800c64 <sys_cgetc>
  802045:	85 c0                	test   %eax,%eax
  802047:	75 07                	jne    802050 <devcons_read+0x21>
		sys_yield();
  802049:	e8 95 ec ff ff       	call   800ce3 <sys_yield>
  80204e:	eb f0                	jmp    802040 <devcons_read+0x11>
	if (c < 0)
  802050:	78 0f                	js     802061 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802052:	83 f8 04             	cmp    $0x4,%eax
  802055:	74 0c                	je     802063 <devcons_read+0x34>
	*(char*)vbuf = c;
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	88 02                	mov    %al,(%edx)
	return 1;
  80205c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    
		return 0;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	eb f7                	jmp    802061 <devcons_read+0x32>

0080206a <cputchar>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802076:	6a 01                	push   $0x1
  802078:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	e8 c5 eb ff ff       	call   800c46 <sys_cputs>
}
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <getchar>:
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208c:	6a 01                	push   $0x1
  80208e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802091:	50                   	push   %eax
  802092:	6a 00                	push   $0x0
  802094:	e8 27 f2 ff ff       	call   8012c0 <read>
	if (r < 0)
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 06                	js     8020a6 <getchar+0x20>
	if (r < 1)
  8020a0:	74 06                	je     8020a8 <getchar+0x22>
	return c;
  8020a2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    
		return -E_EOF;
  8020a8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ad:	eb f7                	jmp    8020a6 <getchar+0x20>

008020af <iscons>:
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b8:	50                   	push   %eax
  8020b9:	ff 75 08             	pushl  0x8(%ebp)
  8020bc:	e8 8f ef ff ff       	call   801050 <fd_lookup>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	78 11                	js     8020d9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d1:	39 10                	cmp    %edx,(%eax)
  8020d3:	0f 94 c0             	sete   %al
  8020d6:	0f b6 c0             	movzbl %al,%eax
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <opencons>:
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e4:	50                   	push   %eax
  8020e5:	e8 14 ef ff ff       	call   800ffe <fd_alloc>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 3a                	js     80212b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 07 04 00 00       	push   $0x407
  8020f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fc:	6a 00                	push   $0x0
  8020fe:	e8 ff eb ff ff       	call   800d02 <sys_page_alloc>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 21                	js     80212b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802113:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	50                   	push   %eax
  802123:	e8 af ee ff ff       	call   800fd7 <fd2num>
  802128:	83 c4 10             	add    $0x10,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	56                   	push   %esi
  802131:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802132:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802137:	8b 40 48             	mov    0x48(%eax),%eax
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 48 2a 80 00       	push   $0x802a48
  802142:	50                   	push   %eax
  802143:	68 17 2a 80 00       	push   $0x802a17
  802148:	e8 64 e0 ff ff       	call   8001b1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80214d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802150:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802156:	e8 69 eb ff ff       	call   800cc4 <sys_getenvid>
  80215b:	83 c4 04             	add    $0x4,%esp
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	ff 75 08             	pushl  0x8(%ebp)
  802164:	56                   	push   %esi
  802165:	50                   	push   %eax
  802166:	68 24 2a 80 00       	push   $0x802a24
  80216b:	e8 41 e0 ff ff       	call   8001b1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802170:	83 c4 18             	add    $0x18,%esp
  802173:	53                   	push   %ebx
  802174:	ff 75 10             	pushl  0x10(%ebp)
  802177:	e8 e4 df ff ff       	call   800160 <vcprintf>
	cprintf("\n");
  80217c:	c7 04 24 39 25 80 00 	movl   $0x802539,(%esp)
  802183:	e8 29 e0 ff ff       	call   8001b1 <cprintf>
  802188:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80218b:	cc                   	int3   
  80218c:	eb fd                	jmp    80218b <_panic+0x5e>

0080218e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	56                   	push   %esi
  802192:	53                   	push   %ebx
  802193:	8b 75 08             	mov    0x8(%ebp),%esi
  802196:	8b 45 0c             	mov    0xc(%ebp),%eax
  802199:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80219c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80219e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021a3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	50                   	push   %eax
  8021aa:	e8 03 ed ff ff       	call   800eb2 <sys_ipc_recv>
	if(ret < 0){
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 2b                	js     8021e1 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021b6:	85 f6                	test   %esi,%esi
  8021b8:	74 0a                	je     8021c4 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021ba:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021bf:	8b 40 74             	mov    0x74(%eax),%eax
  8021c2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021c4:	85 db                	test   %ebx,%ebx
  8021c6:	74 0a                	je     8021d2 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021c8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021cd:	8b 40 78             	mov    0x78(%eax),%eax
  8021d0:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021d7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    
		if(from_env_store)
  8021e1:	85 f6                	test   %esi,%esi
  8021e3:	74 06                	je     8021eb <ipc_recv+0x5d>
			*from_env_store = 0;
  8021e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021eb:	85 db                	test   %ebx,%ebx
  8021ed:	74 eb                	je     8021da <ipc_recv+0x4c>
			*perm_store = 0;
  8021ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021f5:	eb e3                	jmp    8021da <ipc_recv+0x4c>

008021f7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	57                   	push   %edi
  8021fb:	56                   	push   %esi
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	8b 7d 08             	mov    0x8(%ebp),%edi
  802203:	8b 75 0c             	mov    0xc(%ebp),%esi
  802206:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802209:	85 db                	test   %ebx,%ebx
  80220b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802210:	0f 44 d8             	cmove  %eax,%ebx
  802213:	eb 05                	jmp    80221a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802215:	e8 c9 ea ff ff       	call   800ce3 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80221a:	ff 75 14             	pushl  0x14(%ebp)
  80221d:	53                   	push   %ebx
  80221e:	56                   	push   %esi
  80221f:	57                   	push   %edi
  802220:	e8 6a ec ff ff       	call   800e8f <sys_ipc_try_send>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	85 c0                	test   %eax,%eax
  80222a:	74 1b                	je     802247 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80222c:	79 e7                	jns    802215 <ipc_send+0x1e>
  80222e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802231:	74 e2                	je     802215 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 4f 2a 80 00       	push   $0x802a4f
  80223b:	6a 48                	push   $0x48
  80223d:	68 64 2a 80 00       	push   $0x802a64
  802242:	e8 e6 fe ff ff       	call   80212d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224a:	5b                   	pop    %ebx
  80224b:	5e                   	pop    %esi
  80224c:	5f                   	pop    %edi
  80224d:	5d                   	pop    %ebp
  80224e:	c3                   	ret    

0080224f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80225a:	89 c2                	mov    %eax,%edx
  80225c:	c1 e2 07             	shl    $0x7,%edx
  80225f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802265:	8b 52 50             	mov    0x50(%edx),%edx
  802268:	39 ca                	cmp    %ecx,%edx
  80226a:	74 11                	je     80227d <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80226c:	83 c0 01             	add    $0x1,%eax
  80226f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802274:	75 e4                	jne    80225a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	eb 0b                	jmp    802288 <ipc_find_env+0x39>
			return envs[i].env_id;
  80227d:	c1 e0 07             	shl    $0x7,%eax
  802280:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802285:	8b 40 48             	mov    0x48(%eax),%eax
}
  802288:	5d                   	pop    %ebp
  802289:	c3                   	ret    

0080228a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802290:	89 d0                	mov    %edx,%eax
  802292:	c1 e8 16             	shr    $0x16,%eax
  802295:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022a1:	f6 c1 01             	test   $0x1,%cl
  8022a4:	74 1d                	je     8022c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022a6:	c1 ea 0c             	shr    $0xc,%edx
  8022a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022b0:	f6 c2 01             	test   $0x1,%dl
  8022b3:	74 0e                	je     8022c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022b5:	c1 ea 0c             	shr    $0xc,%edx
  8022b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022bf:	ef 
  8022c0:	0f b7 c0             	movzwl %ax,%eax
}
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	66 90                	xchg   %ax,%ax
  8022c7:	66 90                	xchg   %ax,%ax
  8022c9:	66 90                	xchg   %ax,%ax
  8022cb:	66 90                	xchg   %ax,%ax
  8022cd:	66 90                	xchg   %ax,%ax
  8022cf:	90                   	nop

008022d0 <__udivdi3>:
  8022d0:	55                   	push   %ebp
  8022d1:	57                   	push   %edi
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 1c             	sub    $0x1c,%esp
  8022d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022e7:	85 d2                	test   %edx,%edx
  8022e9:	75 4d                	jne    802338 <__udivdi3+0x68>
  8022eb:	39 f3                	cmp    %esi,%ebx
  8022ed:	76 19                	jbe    802308 <__udivdi3+0x38>
  8022ef:	31 ff                	xor    %edi,%edi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	89 d9                	mov    %ebx,%ecx
  80230a:	85 db                	test   %ebx,%ebx
  80230c:	75 0b                	jne    802319 <__udivdi3+0x49>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 c1                	mov    %eax,%ecx
  802319:	31 d2                	xor    %edx,%edx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	f7 f1                	div    %ecx
  80231f:	89 c6                	mov    %eax,%esi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f7                	mov    %esi,%edi
  802325:	f7 f1                	div    %ecx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	77 1c                	ja     802358 <__udivdi3+0x88>
  80233c:	0f bd fa             	bsr    %edx,%edi
  80233f:	83 f7 1f             	xor    $0x1f,%edi
  802342:	75 2c                	jne    802370 <__udivdi3+0xa0>
  802344:	39 f2                	cmp    %esi,%edx
  802346:	72 06                	jb     80234e <__udivdi3+0x7e>
  802348:	31 c0                	xor    %eax,%eax
  80234a:	39 eb                	cmp    %ebp,%ebx
  80234c:	77 a9                	ja     8022f7 <__udivdi3+0x27>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	eb a2                	jmp    8022f7 <__udivdi3+0x27>
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	31 ff                	xor    %edi,%edi
  80235a:	31 c0                	xor    %eax,%eax
  80235c:	89 fa                	mov    %edi,%edx
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	89 eb                	mov    %ebp,%ebx
  8023a1:	d3 e6                	shl    %cl,%esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 15                	jb     8023d0 <__udivdi3+0x100>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 04                	jae    8023c7 <__udivdi3+0xf7>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	74 09                	je     8023d0 <__udivdi3+0x100>
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	e9 27 ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023d3:	31 ff                	xor    %edi,%edi
  8023d5:	e9 1d ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	89 da                	mov    %ebx,%edx
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	75 43                	jne    802440 <__umoddi3+0x60>
  8023fd:	39 df                	cmp    %ebx,%edi
  8023ff:	76 17                	jbe    802418 <__umoddi3+0x38>
  802401:	89 f0                	mov    %esi,%eax
  802403:	f7 f7                	div    %edi
  802405:	89 d0                	mov    %edx,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 fd                	mov    %edi,%ebp
  80241a:	85 ff                	test   %edi,%edi
  80241c:	75 0b                	jne    802429 <__umoddi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f7                	div    %edi
  802427:	89 c5                	mov    %eax,%ebp
  802429:	89 d8                	mov    %ebx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	f7 f5                	div    %ebp
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 f5                	div    %ebp
  802433:	89 d0                	mov    %edx,%eax
  802435:	eb d0                	jmp    802407 <__umoddi3+0x27>
  802437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243e:	66 90                	xchg   %ax,%ax
  802440:	89 f1                	mov    %esi,%ecx
  802442:	39 d8                	cmp    %ebx,%eax
  802444:	76 0a                	jbe    802450 <__umoddi3+0x70>
  802446:	89 f0                	mov    %esi,%eax
  802448:	83 c4 1c             	add    $0x1c,%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    
  802450:	0f bd e8             	bsr    %eax,%ebp
  802453:	83 f5 1f             	xor    $0x1f,%ebp
  802456:	75 20                	jne    802478 <__umoddi3+0x98>
  802458:	39 d8                	cmp    %ebx,%eax
  80245a:	0f 82 b0 00 00 00    	jb     802510 <__umoddi3+0x130>
  802460:	39 f7                	cmp    %esi,%edi
  802462:	0f 86 a8 00 00 00    	jbe    802510 <__umoddi3+0x130>
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	83 c4 1c             	add    $0x1c,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    
  802472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	ba 20 00 00 00       	mov    $0x20,%edx
  80247f:	29 ea                	sub    %ebp,%edx
  802481:	d3 e0                	shl    %cl,%eax
  802483:	89 44 24 08          	mov    %eax,0x8(%esp)
  802487:	89 d1                	mov    %edx,%ecx
  802489:	89 f8                	mov    %edi,%eax
  80248b:	d3 e8                	shr    %cl,%eax
  80248d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802491:	89 54 24 04          	mov    %edx,0x4(%esp)
  802495:	8b 54 24 04          	mov    0x4(%esp),%edx
  802499:	09 c1                	or     %eax,%ecx
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 e9                	mov    %ebp,%ecx
  8024a3:	d3 e7                	shl    %cl,%edi
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	89 d1                	mov    %edx,%ecx
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	d3 e6                	shl    %cl,%esi
  8024bf:	09 d8                	or     %ebx,%eax
  8024c1:	f7 74 24 08          	divl   0x8(%esp)
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	89 f3                	mov    %esi,%ebx
  8024c9:	f7 64 24 0c          	mull   0xc(%esp)
  8024cd:	89 c6                	mov    %eax,%esi
  8024cf:	89 d7                	mov    %edx,%edi
  8024d1:	39 d1                	cmp    %edx,%ecx
  8024d3:	72 06                	jb     8024db <__umoddi3+0xfb>
  8024d5:	75 10                	jne    8024e7 <__umoddi3+0x107>
  8024d7:	39 c3                	cmp    %eax,%ebx
  8024d9:	73 0c                	jae    8024e7 <__umoddi3+0x107>
  8024db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	89 ca                	mov    %ecx,%edx
  8024e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	19 fa                	sbb    %edi,%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	d3 e0                	shl    %cl,%eax
  8024f6:	89 e9                	mov    %ebp,%ecx
  8024f8:	d3 eb                	shr    %cl,%ebx
  8024fa:	d3 ea                	shr    %cl,%edx
  8024fc:	09 d8                	or     %ebx,%eax
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 da                	mov    %ebx,%edx
  802512:	29 fe                	sub    %edi,%esi
  802514:	19 c2                	sbb    %eax,%edx
  802516:	89 f1                	mov    %esi,%ecx
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	e9 4b ff ff ff       	jmp    80246a <__umoddi3+0x8a>
