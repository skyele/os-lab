
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	57                   	push   %edi
  80003e:	56                   	push   %esi
  80003f:	53                   	push   %ebx
  800040:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800043:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80004a:	00 00 00 
	envid_t find = sys_getenvid();
  80004d:	e8 4c 0c 00 00       	call   800c9e <sys_getenvid>
  800052:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80005d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800062:	bf 01 00 00 00       	mov    $0x1,%edi
  800067:	eb 0b                	jmp    800074 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800069:	83 c2 01             	add    $0x1,%edx
  80006c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800072:	74 21                	je     800095 <libmain+0x5b>
		if(envs[i].env_id == find)
  800074:	89 d1                	mov    %edx,%ecx
  800076:	c1 e1 07             	shl    $0x7,%ecx
  800079:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800082:	39 c1                	cmp    %eax,%ecx
  800084:	75 e3                	jne    800069 <libmain+0x2f>
  800086:	89 d3                	mov    %edx,%ebx
  800088:	c1 e3 07             	shl    $0x7,%ebx
  80008b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800091:	89 fe                	mov    %edi,%esi
  800093:	eb d4                	jmp    800069 <libmain+0x2f>
  800095:	89 f0                	mov    %esi,%eax
  800097:	84 c0                	test   %al,%al
  800099:	74 06                	je     8000a1 <libmain+0x67>
  80009b:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a5:	7e 0a                	jle    8000b1 <libmain+0x77>
		binaryname = argv[0];
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 00 25 80 00       	push   $0x802500
  8000b9:	e8 cd 00 00 00       	call   80018b <cprintf>
	// call user main routine
	umain(argc, argv);
  8000be:	83 c4 08             	add    $0x8,%esp
  8000c1:	ff 75 0c             	pushl  0xc(%ebp)
  8000c4:	ff 75 08             	pushl  0x8(%ebp)
  8000c7:	e8 67 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cc:	e8 0b 00 00 00       	call   8000dc <exit>
}
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e2:	e8 a2 10 00 00       	call   801189 <close_all>
	sys_env_destroy(0);
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	6a 00                	push   $0x0
  8000ec:	e8 6c 0b 00 00       	call   800c5d <sys_env_destroy>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800100:	8b 13                	mov    (%ebx),%edx
  800102:	8d 42 01             	lea    0x1(%edx),%eax
  800105:	89 03                	mov    %eax,(%ebx)
  800107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800113:	74 09                	je     80011e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800115:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	68 ff 00 00 00       	push   $0xff
  800126:	8d 43 08             	lea    0x8(%ebx),%eax
  800129:	50                   	push   %eax
  80012a:	e8 f1 0a 00 00       	call   800c20 <sys_cputs>
		b->idx = 0;
  80012f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	eb db                	jmp    800115 <putch+0x1f>

0080013a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800143:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014a:	00 00 00 
	b.cnt = 0;
  80014d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800154:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800163:	50                   	push   %eax
  800164:	68 f6 00 80 00       	push   $0x8000f6
  800169:	e8 4a 01 00 00       	call   8002b8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016e:	83 c4 08             	add    $0x8,%esp
  800171:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800177:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017d:	50                   	push   %eax
  80017e:	e8 9d 0a 00 00       	call   800c20 <sys_cputs>

	return b.cnt;
}
  800183:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800191:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800194:	50                   	push   %eax
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 9d ff ff ff       	call   80013a <vcprintf>
	va_end(ap);

	return cnt;
}
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	57                   	push   %edi
  8001a3:	56                   	push   %esi
  8001a4:	53                   	push   %ebx
  8001a5:	83 ec 1c             	sub    $0x1c,%esp
  8001a8:	89 c6                	mov    %eax,%esi
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8001af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001be:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001c2:	74 2c                	je     8001f0 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d4:	39 c2                	cmp    %eax,%edx
  8001d6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d9:	73 43                	jae    80021e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001db:	83 eb 01             	sub    $0x1,%ebx
  8001de:	85 db                	test   %ebx,%ebx
  8001e0:	7e 6c                	jle    80024e <printnum+0xaf>
				putch(padc, putdat);
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	57                   	push   %edi
  8001e6:	ff 75 18             	pushl  0x18(%ebp)
  8001e9:	ff d6                	call   *%esi
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	eb eb                	jmp    8001db <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	6a 20                	push   $0x20
  8001f5:	6a 00                	push   $0x0
  8001f7:	50                   	push   %eax
  8001f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fe:	89 fa                	mov    %edi,%edx
  800200:	89 f0                	mov    %esi,%eax
  800202:	e8 98 ff ff ff       	call   80019f <printnum>
		while (--width > 0)
  800207:	83 c4 20             	add    $0x20,%esp
  80020a:	83 eb 01             	sub    $0x1,%ebx
  80020d:	85 db                	test   %ebx,%ebx
  80020f:	7e 65                	jle    800276 <printnum+0xd7>
			putch(padc, putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	57                   	push   %edi
  800215:	6a 20                	push   $0x20
  800217:	ff d6                	call   *%esi
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb ec                	jmp    80020a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	ff 75 18             	pushl  0x18(%ebp)
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	53                   	push   %ebx
  800228:	50                   	push   %eax
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	ff 75 dc             	pushl  -0x24(%ebp)
  80022f:	ff 75 d8             	pushl  -0x28(%ebp)
  800232:	ff 75 e4             	pushl  -0x1c(%ebp)
  800235:	ff 75 e0             	pushl  -0x20(%ebp)
  800238:	e8 63 20 00 00       	call   8022a0 <__udivdi3>
  80023d:	83 c4 18             	add    $0x18,%esp
  800240:	52                   	push   %edx
  800241:	50                   	push   %eax
  800242:	89 fa                	mov    %edi,%edx
  800244:	89 f0                	mov    %esi,%eax
  800246:	e8 54 ff ff ff       	call   80019f <printnum>
  80024b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	57                   	push   %edi
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025e:	ff 75 e0             	pushl  -0x20(%ebp)
  800261:	e8 4a 21 00 00       	call   8023b0 <__umoddi3>
  800266:	83 c4 14             	add    $0x14,%esp
  800269:	0f be 80 24 25 80 00 	movsbl 0x802524(%eax),%eax
  800270:	50                   	push   %eax
  800271:	ff d6                	call   *%esi
  800273:	83 c4 10             	add    $0x10,%esp
	}
}
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    

0080027e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800284:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800288:	8b 10                	mov    (%eax),%edx
  80028a:	3b 50 04             	cmp    0x4(%eax),%edx
  80028d:	73 0a                	jae    800299 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800292:	89 08                	mov    %ecx,(%eax)
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	88 02                	mov    %al,(%edx)
}
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <printfmt>:
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002a1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a4:	50                   	push   %eax
  8002a5:	ff 75 10             	pushl  0x10(%ebp)
  8002a8:	ff 75 0c             	pushl  0xc(%ebp)
  8002ab:	ff 75 08             	pushl  0x8(%ebp)
  8002ae:	e8 05 00 00 00       	call   8002b8 <vprintfmt>
}
  8002b3:	83 c4 10             	add    $0x10,%esp
  8002b6:	c9                   	leave  
  8002b7:	c3                   	ret    

008002b8 <vprintfmt>:
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	57                   	push   %edi
  8002bc:	56                   	push   %esi
  8002bd:	53                   	push   %ebx
  8002be:	83 ec 3c             	sub    $0x3c,%esp
  8002c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ca:	e9 32 04 00 00       	jmp    800701 <vprintfmt+0x449>
		padc = ' ';
  8002cf:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002d3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002da:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ef:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002f6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fb:	8d 47 01             	lea    0x1(%edi),%eax
  8002fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800301:	0f b6 17             	movzbl (%edi),%edx
  800304:	8d 42 dd             	lea    -0x23(%edx),%eax
  800307:	3c 55                	cmp    $0x55,%al
  800309:	0f 87 12 05 00 00    	ja     800821 <vprintfmt+0x569>
  80030f:	0f b6 c0             	movzbl %al,%eax
  800312:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800320:	eb d9                	jmp    8002fb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800325:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800329:	eb d0                	jmp    8002fb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032b:	0f b6 d2             	movzbl %dl,%edx
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	89 75 08             	mov    %esi,0x8(%ebp)
  800339:	eb 03                	jmp    80033e <vprintfmt+0x86>
  80033b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800341:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800345:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800348:	8d 72 d0             	lea    -0x30(%edx),%esi
  80034b:	83 fe 09             	cmp    $0x9,%esi
  80034e:	76 eb                	jbe    80033b <vprintfmt+0x83>
  800350:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800353:	8b 75 08             	mov    0x8(%ebp),%esi
  800356:	eb 14                	jmp    80036c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8d 40 04             	lea    0x4(%eax),%eax
  800366:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800370:	79 89                	jns    8002fb <vprintfmt+0x43>
				width = precision, precision = -1;
  800372:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800375:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800378:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80037f:	e9 77 ff ff ff       	jmp    8002fb <vprintfmt+0x43>
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	0f 48 c1             	cmovs  %ecx,%eax
  80038c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800392:	e9 64 ff ff ff       	jmp    8002fb <vprintfmt+0x43>
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003a1:	e9 55 ff ff ff       	jmp    8002fb <vprintfmt+0x43>
			lflag++;
  8003a6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ad:	e9 49 ff ff ff       	jmp    8002fb <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 78 04             	lea    0x4(%eax),%edi
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	53                   	push   %ebx
  8003bc:	ff 30                	pushl  (%eax)
  8003be:	ff d6                	call   *%esi
			break;
  8003c0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c6:	e9 33 03 00 00       	jmp    8006fe <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8d 78 04             	lea    0x4(%eax),%edi
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	99                   	cltd   
  8003d4:	31 d0                	xor    %edx,%eax
  8003d6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d8:	83 f8 10             	cmp    $0x10,%eax
  8003db:	7f 23                	jg     800400 <vprintfmt+0x148>
  8003dd:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003e4:	85 d2                	test   %edx,%edx
  8003e6:	74 18                	je     800400 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003e8:	52                   	push   %edx
  8003e9:	68 79 29 80 00       	push   $0x802979
  8003ee:	53                   	push   %ebx
  8003ef:	56                   	push   %esi
  8003f0:	e8 a6 fe ff ff       	call   80029b <printfmt>
  8003f5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fb:	e9 fe 02 00 00       	jmp    8006fe <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800400:	50                   	push   %eax
  800401:	68 3c 25 80 00       	push   $0x80253c
  800406:	53                   	push   %ebx
  800407:	56                   	push   %esi
  800408:	e8 8e fe ff ff       	call   80029b <printfmt>
  80040d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800410:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800413:	e9 e6 02 00 00       	jmp    8006fe <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	83 c0 04             	add    $0x4,%eax
  80041e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800426:	85 c9                	test   %ecx,%ecx
  800428:	b8 35 25 80 00       	mov    $0x802535,%eax
  80042d:	0f 45 c1             	cmovne %ecx,%eax
  800430:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800433:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800437:	7e 06                	jle    80043f <vprintfmt+0x187>
  800439:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80043d:	75 0d                	jne    80044c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800442:	89 c7                	mov    %eax,%edi
  800444:	03 45 e0             	add    -0x20(%ebp),%eax
  800447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044a:	eb 53                	jmp    80049f <vprintfmt+0x1e7>
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	ff 75 d8             	pushl  -0x28(%ebp)
  800452:	50                   	push   %eax
  800453:	e8 71 04 00 00       	call   8008c9 <strnlen>
  800458:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045b:	29 c1                	sub    %eax,%ecx
  80045d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800465:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800469:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	eb 0f                	jmp    80047d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	53                   	push   %ebx
  800472:	ff 75 e0             	pushl  -0x20(%ebp)
  800475:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800477:	83 ef 01             	sub    $0x1,%edi
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	85 ff                	test   %edi,%edi
  80047f:	7f ed                	jg     80046e <vprintfmt+0x1b6>
  800481:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800484:	85 c9                	test   %ecx,%ecx
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	0f 49 c1             	cmovns %ecx,%eax
  80048e:	29 c1                	sub    %eax,%ecx
  800490:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800493:	eb aa                	jmp    80043f <vprintfmt+0x187>
					putch(ch, putdat);
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	53                   	push   %ebx
  800499:	52                   	push   %edx
  80049a:	ff d6                	call   *%esi
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a4:	83 c7 01             	add    $0x1,%edi
  8004a7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ab:	0f be d0             	movsbl %al,%edx
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	74 4b                	je     8004fd <vprintfmt+0x245>
  8004b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b6:	78 06                	js     8004be <vprintfmt+0x206>
  8004b8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004bc:	78 1e                	js     8004dc <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004be:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c2:	74 d1                	je     800495 <vprintfmt+0x1dd>
  8004c4:	0f be c0             	movsbl %al,%eax
  8004c7:	83 e8 20             	sub    $0x20,%eax
  8004ca:	83 f8 5e             	cmp    $0x5e,%eax
  8004cd:	76 c6                	jbe    800495 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	6a 3f                	push   $0x3f
  8004d5:	ff d6                	call   *%esi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	eb c3                	jmp    80049f <vprintfmt+0x1e7>
  8004dc:	89 cf                	mov    %ecx,%edi
  8004de:	eb 0e                	jmp    8004ee <vprintfmt+0x236>
				putch(' ', putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	53                   	push   %ebx
  8004e4:	6a 20                	push   $0x20
  8004e6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e8:	83 ef 01             	sub    $0x1,%edi
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	85 ff                	test   %edi,%edi
  8004f0:	7f ee                	jg     8004e0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f8:	e9 01 02 00 00       	jmp    8006fe <vprintfmt+0x446>
  8004fd:	89 cf                	mov    %ecx,%edi
  8004ff:	eb ed                	jmp    8004ee <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800501:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800504:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80050b:	e9 eb fd ff ff       	jmp    8002fb <vprintfmt+0x43>
	if (lflag >= 2)
  800510:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800514:	7f 21                	jg     800537 <vprintfmt+0x27f>
	else if (lflag)
  800516:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80051a:	74 68                	je     800584 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800524:	89 c1                	mov    %eax,%ecx
  800526:	c1 f9 1f             	sar    $0x1f,%ecx
  800529:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 04             	lea    0x4(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	eb 17                	jmp    80054e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 50 04             	mov    0x4(%eax),%edx
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800542:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8d 40 08             	lea    0x8(%eax),%eax
  80054b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80054e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800551:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800554:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800557:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80055a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80055e:	78 3f                	js     80059f <vprintfmt+0x2e7>
			base = 10;
  800560:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800565:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800569:	0f 84 71 01 00 00    	je     8006e0 <vprintfmt+0x428>
				putch('+', putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	53                   	push   %ebx
  800573:	6a 2b                	push   $0x2b
  800575:	ff d6                	call   *%esi
  800577:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	e9 5c 01 00 00       	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058c:	89 c1                	mov    %eax,%ecx
  80058e:	c1 f9 1f             	sar    $0x1f,%ecx
  800591:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
  80059d:	eb af                	jmp    80054e <vprintfmt+0x296>
				putch('-', putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	53                   	push   %ebx
  8005a3:	6a 2d                	push   $0x2d
  8005a5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ad:	f7 d8                	neg    %eax
  8005af:	83 d2 00             	adc    $0x0,%edx
  8005b2:	f7 da                	neg    %edx
  8005b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ba:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c2:	e9 19 01 00 00       	jmp    8006e0 <vprintfmt+0x428>
	if (lflag >= 2)
  8005c7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005cb:	7f 29                	jg     8005f6 <vprintfmt+0x33e>
	else if (lflag)
  8005cd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005d1:	74 44                	je     800617 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f1:	e9 ea 00 00 00       	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 50 04             	mov    0x4(%eax),%edx
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 08             	lea    0x8(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 c9 00 00 00       	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
  800635:	e9 a6 00 00 00       	jmp    8006e0 <vprintfmt+0x428>
			putch('0', putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	6a 30                	push   $0x30
  800640:	ff d6                	call   *%esi
	if (lflag >= 2)
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800649:	7f 26                	jg     800671 <vprintfmt+0x3b9>
	else if (lflag)
  80064b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064f:	74 3e                	je     80068f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
  80066f:	eb 6f                	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 50 04             	mov    0x4(%eax),%edx
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 08             	lea    0x8(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800688:	b8 08 00 00 00       	mov    $0x8,%eax
  80068d:	eb 51                	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ad:	eb 31                	jmp    8006e0 <vprintfmt+0x428>
			putch('0', putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 30                	push   $0x30
  8006b5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	6a 78                	push   $0x78
  8006bd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006cf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006db:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e0:	83 ec 0c             	sub    $0xc,%esp
  8006e3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006e7:	52                   	push   %edx
  8006e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006eb:	50                   	push   %eax
  8006ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f2:	89 da                	mov    %ebx,%edx
  8006f4:	89 f0                	mov    %esi,%eax
  8006f6:	e8 a4 fa ff ff       	call   80019f <printnum>
			break;
  8006fb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800701:	83 c7 01             	add    $0x1,%edi
  800704:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800708:	83 f8 25             	cmp    $0x25,%eax
  80070b:	0f 84 be fb ff ff    	je     8002cf <vprintfmt+0x17>
			if (ch == '\0')
  800711:	85 c0                	test   %eax,%eax
  800713:	0f 84 28 01 00 00    	je     800841 <vprintfmt+0x589>
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	50                   	push   %eax
  80071e:	ff d6                	call   *%esi
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	eb dc                	jmp    800701 <vprintfmt+0x449>
	if (lflag >= 2)
  800725:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800729:	7f 26                	jg     800751 <vprintfmt+0x499>
	else if (lflag)
  80072b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072f:	74 41                	je     800772 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074a:	b8 10 00 00 00       	mov    $0x10,%eax
  80074f:	eb 8f                	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 08             	lea    0x8(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800768:	b8 10 00 00 00       	mov    $0x10,%eax
  80076d:	e9 6e ff ff ff       	jmp    8006e0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078b:	b8 10 00 00 00       	mov    $0x10,%eax
  800790:	e9 4b ff ff ff       	jmp    8006e0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	83 c0 04             	add    $0x4,%eax
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	85 c0                	test   %eax,%eax
  8007a5:	74 14                	je     8007bb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007a7:	8b 13                	mov    (%ebx),%edx
  8007a9:	83 fa 7f             	cmp    $0x7f,%edx
  8007ac:	7f 37                	jg     8007e5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007ae:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b6:	e9 43 ff ff ff       	jmp    8006fe <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c0:	bf 59 26 80 00       	mov    $0x802659,%edi
							putch(ch, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	53                   	push   %ebx
  8007c9:	50                   	push   %eax
  8007ca:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007cc:	83 c7 01             	add    $0x1,%edi
  8007cf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	85 c0                	test   %eax,%eax
  8007d8:	75 eb                	jne    8007c5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e0:	e9 19 ff ff ff       	jmp    8006fe <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007e5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ec:	bf 91 26 80 00       	mov    $0x802691,%edi
							putch(ch, putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	50                   	push   %eax
  8007f6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 c0                	test   %eax,%eax
  800804:	75 eb                	jne    8007f1 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800806:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
  80080c:	e9 ed fe ff ff       	jmp    8006fe <vprintfmt+0x446>
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	6a 25                	push   $0x25
  800817:	ff d6                	call   *%esi
			break;
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	e9 dd fe ff ff       	jmp    8006fe <vprintfmt+0x446>
			putch('%', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	6a 25                	push   $0x25
  800827:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	89 f8                	mov    %edi,%eax
  80082e:	eb 03                	jmp    800833 <vprintfmt+0x57b>
  800830:	83 e8 01             	sub    $0x1,%eax
  800833:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800837:	75 f7                	jne    800830 <vprintfmt+0x578>
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	e9 bd fe ff ff       	jmp    8006fe <vprintfmt+0x446>
}
  800841:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5f                   	pop    %edi
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	83 ec 18             	sub    $0x18,%esp
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800855:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800858:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800866:	85 c0                	test   %eax,%eax
  800868:	74 26                	je     800890 <vsnprintf+0x47>
  80086a:	85 d2                	test   %edx,%edx
  80086c:	7e 22                	jle    800890 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086e:	ff 75 14             	pushl  0x14(%ebp)
  800871:	ff 75 10             	pushl  0x10(%ebp)
  800874:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800877:	50                   	push   %eax
  800878:	68 7e 02 80 00       	push   $0x80027e
  80087d:	e8 36 fa ff ff       	call   8002b8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800885:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088b:	83 c4 10             	add    $0x10,%esp
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    
		return -E_INVAL;
  800890:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800895:	eb f7                	jmp    80088e <vsnprintf+0x45>

00800897 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a0:	50                   	push   %eax
  8008a1:	ff 75 10             	pushl  0x10(%ebp)
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 9a ff ff ff       	call   800849 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c0:	74 05                	je     8008c7 <strlen+0x16>
		n++;
  8008c2:	83 c0 01             	add    $0x1,%eax
  8008c5:	eb f5                	jmp    8008bc <strlen+0xb>
	return n;
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	39 c2                	cmp    %eax,%edx
  8008d9:	74 0d                	je     8008e8 <strnlen+0x1f>
  8008db:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008df:	74 05                	je     8008e6 <strnlen+0x1d>
		n++;
  8008e1:	83 c2 01             	add    $0x1,%edx
  8008e4:	eb f1                	jmp    8008d7 <strnlen+0xe>
  8008e6:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800900:	83 c2 01             	add    $0x1,%edx
  800903:	84 c9                	test   %cl,%cl
  800905:	75 f2                	jne    8008f9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	83 ec 10             	sub    $0x10,%esp
  800911:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800914:	53                   	push   %ebx
  800915:	e8 97 ff ff ff       	call   8008b1 <strlen>
  80091a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	50                   	push   %eax
  800923:	e8 c2 ff ff ff       	call   8008ea <strcpy>
	return dst;
}
  800928:	89 d8                	mov    %ebx,%eax
  80092a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093a:	89 c6                	mov    %eax,%esi
  80093c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093f:	89 c2                	mov    %eax,%edx
  800941:	39 f2                	cmp    %esi,%edx
  800943:	74 11                	je     800956 <strncpy+0x27>
		*dst++ = *src;
  800945:	83 c2 01             	add    $0x1,%edx
  800948:	0f b6 19             	movzbl (%ecx),%ebx
  80094b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094e:	80 fb 01             	cmp    $0x1,%bl
  800951:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800954:	eb eb                	jmp    800941 <strncpy+0x12>
	}
	return ret;
}
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 75 08             	mov    0x8(%ebp),%esi
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800965:	8b 55 10             	mov    0x10(%ebp),%edx
  800968:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096a:	85 d2                	test   %edx,%edx
  80096c:	74 21                	je     80098f <strlcpy+0x35>
  80096e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800972:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800974:	39 c2                	cmp    %eax,%edx
  800976:	74 14                	je     80098c <strlcpy+0x32>
  800978:	0f b6 19             	movzbl (%ecx),%ebx
  80097b:	84 db                	test   %bl,%bl
  80097d:	74 0b                	je     80098a <strlcpy+0x30>
			*dst++ = *src++;
  80097f:	83 c1 01             	add    $0x1,%ecx
  800982:	83 c2 01             	add    $0x1,%edx
  800985:	88 5a ff             	mov    %bl,-0x1(%edx)
  800988:	eb ea                	jmp    800974 <strlcpy+0x1a>
  80098a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80098c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098f:	29 f0                	sub    %esi,%eax
}
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099e:	0f b6 01             	movzbl (%ecx),%eax
  8009a1:	84 c0                	test   %al,%al
  8009a3:	74 0c                	je     8009b1 <strcmp+0x1c>
  8009a5:	3a 02                	cmp    (%edx),%al
  8009a7:	75 08                	jne    8009b1 <strcmp+0x1c>
		p++, q++;
  8009a9:	83 c1 01             	add    $0x1,%ecx
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	eb ed                	jmp    80099e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b1:	0f b6 c0             	movzbl %al,%eax
  8009b4:	0f b6 12             	movzbl (%edx),%edx
  8009b7:	29 d0                	sub    %edx,%eax
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	89 c3                	mov    %eax,%ebx
  8009c7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ca:	eb 06                	jmp    8009d2 <strncmp+0x17>
		n--, p++, q++;
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d2:	39 d8                	cmp    %ebx,%eax
  8009d4:	74 16                	je     8009ec <strncmp+0x31>
  8009d6:	0f b6 08             	movzbl (%eax),%ecx
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	74 04                	je     8009e1 <strncmp+0x26>
  8009dd:	3a 0a                	cmp    (%edx),%cl
  8009df:	74 eb                	je     8009cc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e1:	0f b6 00             	movzbl (%eax),%eax
  8009e4:	0f b6 12             	movzbl (%edx),%edx
  8009e7:	29 d0                	sub    %edx,%eax
}
  8009e9:	5b                   	pop    %ebx
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    
		return 0;
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	eb f6                	jmp    8009e9 <strncmp+0x2e>

008009f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	74 09                	je     800a0d <strchr+0x1a>
		if (*s == c)
  800a04:	38 ca                	cmp    %cl,%dl
  800a06:	74 0a                	je     800a12 <strchr+0x1f>
	for (; *s; s++)
  800a08:	83 c0 01             	add    $0x1,%eax
  800a0b:	eb f0                	jmp    8009fd <strchr+0xa>
			return (char *) s;
	return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a21:	38 ca                	cmp    %cl,%dl
  800a23:	74 09                	je     800a2e <strfind+0x1a>
  800a25:	84 d2                	test   %dl,%dl
  800a27:	74 05                	je     800a2e <strfind+0x1a>
	for (; *s; s++)
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	eb f0                	jmp    800a1e <strfind+0xa>
			break;
	return (char *) s;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	57                   	push   %edi
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3c:	85 c9                	test   %ecx,%ecx
  800a3e:	74 31                	je     800a71 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	09 c8                	or     %ecx,%eax
  800a44:	a8 03                	test   $0x3,%al
  800a46:	75 23                	jne    800a6b <memset+0x3b>
		c &= 0xFF;
  800a48:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4c:	89 d3                	mov    %edx,%ebx
  800a4e:	c1 e3 08             	shl    $0x8,%ebx
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	c1 e0 18             	shl    $0x18,%eax
  800a56:	89 d6                	mov    %edx,%esi
  800a58:	c1 e6 10             	shl    $0x10,%esi
  800a5b:	09 f0                	or     %esi,%eax
  800a5d:	09 c2                	or     %eax,%edx
  800a5f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a61:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	fc                   	cld    
  800a67:	f3 ab                	rep stos %eax,%es:(%edi)
  800a69:	eb 06                	jmp    800a71 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	fc                   	cld    
  800a6f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a71:	89 f8                	mov    %edi,%eax
  800a73:	5b                   	pop    %ebx
  800a74:	5e                   	pop    %esi
  800a75:	5f                   	pop    %edi
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	57                   	push   %edi
  800a7c:	56                   	push   %esi
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a86:	39 c6                	cmp    %eax,%esi
  800a88:	73 32                	jae    800abc <memmove+0x44>
  800a8a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	76 2b                	jbe    800abc <memmove+0x44>
		s += n;
		d += n;
  800a91:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	89 fe                	mov    %edi,%esi
  800a96:	09 ce                	or     %ecx,%esi
  800a98:	09 d6                	or     %edx,%esi
  800a9a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa0:	75 0e                	jne    800ab0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa2:	83 ef 04             	sub    $0x4,%edi
  800aa5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aab:	fd                   	std    
  800aac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aae:	eb 09                	jmp    800ab9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab0:	83 ef 01             	sub    $0x1,%edi
  800ab3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab6:	fd                   	std    
  800ab7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab9:	fc                   	cld    
  800aba:	eb 1a                	jmp    800ad6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abc:	89 c2                	mov    %eax,%edx
  800abe:	09 ca                	or     %ecx,%edx
  800ac0:	09 f2                	or     %esi,%edx
  800ac2:	f6 c2 03             	test   $0x3,%dl
  800ac5:	75 0a                	jne    800ad1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aca:	89 c7                	mov    %eax,%edi
  800acc:	fc                   	cld    
  800acd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acf:	eb 05                	jmp    800ad6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad1:	89 c7                	mov    %eax,%edi
  800ad3:	fc                   	cld    
  800ad4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad6:	5e                   	pop    %esi
  800ad7:	5f                   	pop    %edi
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae0:	ff 75 10             	pushl  0x10(%ebp)
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	ff 75 08             	pushl  0x8(%ebp)
  800ae9:	e8 8a ff ff ff       	call   800a78 <memmove>
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b00:	39 f0                	cmp    %esi,%eax
  800b02:	74 1c                	je     800b20 <memcmp+0x30>
		if (*s1 != *s2)
  800b04:	0f b6 08             	movzbl (%eax),%ecx
  800b07:	0f b6 1a             	movzbl (%edx),%ebx
  800b0a:	38 d9                	cmp    %bl,%cl
  800b0c:	75 08                	jne    800b16 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	83 c2 01             	add    $0x1,%edx
  800b14:	eb ea                	jmp    800b00 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b16:	0f b6 c1             	movzbl %cl,%eax
  800b19:	0f b6 db             	movzbl %bl,%ebx
  800b1c:	29 d8                	sub    %ebx,%eax
  800b1e:	eb 05                	jmp    800b25 <memcmp+0x35>
	}

	return 0;
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b32:	89 c2                	mov    %eax,%edx
  800b34:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b37:	39 d0                	cmp    %edx,%eax
  800b39:	73 09                	jae    800b44 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3b:	38 08                	cmp    %cl,(%eax)
  800b3d:	74 05                	je     800b44 <memfind+0x1b>
	for (; s < ends; s++)
  800b3f:	83 c0 01             	add    $0x1,%eax
  800b42:	eb f3                	jmp    800b37 <memfind+0xe>
			break;
	return (void *) s;
}
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
  800b4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b52:	eb 03                	jmp    800b57 <strtol+0x11>
		s++;
  800b54:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b57:	0f b6 01             	movzbl (%ecx),%eax
  800b5a:	3c 20                	cmp    $0x20,%al
  800b5c:	74 f6                	je     800b54 <strtol+0xe>
  800b5e:	3c 09                	cmp    $0x9,%al
  800b60:	74 f2                	je     800b54 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b62:	3c 2b                	cmp    $0x2b,%al
  800b64:	74 2a                	je     800b90 <strtol+0x4a>
	int neg = 0;
  800b66:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6b:	3c 2d                	cmp    $0x2d,%al
  800b6d:	74 2b                	je     800b9a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b75:	75 0f                	jne    800b86 <strtol+0x40>
  800b77:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7a:	74 28                	je     800ba4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7c:	85 db                	test   %ebx,%ebx
  800b7e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b83:	0f 44 d8             	cmove  %eax,%ebx
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8e:	eb 50                	jmp    800be0 <strtol+0x9a>
		s++;
  800b90:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b93:	bf 00 00 00 00       	mov    $0x0,%edi
  800b98:	eb d5                	jmp    800b6f <strtol+0x29>
		s++, neg = 1;
  800b9a:	83 c1 01             	add    $0x1,%ecx
  800b9d:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba2:	eb cb                	jmp    800b6f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba8:	74 0e                	je     800bb8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	75 d8                	jne    800b86 <strtol+0x40>
		s++, base = 8;
  800bae:	83 c1 01             	add    $0x1,%ecx
  800bb1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb6:	eb ce                	jmp    800b86 <strtol+0x40>
		s += 2, base = 16;
  800bb8:	83 c1 02             	add    $0x2,%ecx
  800bbb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc0:	eb c4                	jmp    800b86 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc5:	89 f3                	mov    %esi,%ebx
  800bc7:	80 fb 19             	cmp    $0x19,%bl
  800bca:	77 29                	ja     800bf5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bcc:	0f be d2             	movsbl %dl,%edx
  800bcf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd5:	7d 30                	jge    800c07 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd7:	83 c1 01             	add    $0x1,%ecx
  800bda:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800be0:	0f b6 11             	movzbl (%ecx),%edx
  800be3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be6:	89 f3                	mov    %esi,%ebx
  800be8:	80 fb 09             	cmp    $0x9,%bl
  800beb:	77 d5                	ja     800bc2 <strtol+0x7c>
			dig = *s - '0';
  800bed:	0f be d2             	movsbl %dl,%edx
  800bf0:	83 ea 30             	sub    $0x30,%edx
  800bf3:	eb dd                	jmp    800bd2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf8:	89 f3                	mov    %esi,%ebx
  800bfa:	80 fb 19             	cmp    $0x19,%bl
  800bfd:	77 08                	ja     800c07 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bff:	0f be d2             	movsbl %dl,%edx
  800c02:	83 ea 37             	sub    $0x37,%edx
  800c05:	eb cb                	jmp    800bd2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0b:	74 05                	je     800c12 <strtol+0xcc>
		*endptr = (char *) s;
  800c0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c10:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	f7 da                	neg    %edx
  800c16:	85 ff                	test   %edi,%edi
  800c18:	0f 45 c2             	cmovne %edx,%eax
}
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c31:	89 c3                	mov    %eax,%ebx
  800c33:	89 c7                	mov    %eax,%edi
  800c35:	89 c6                	mov    %eax,%esi
  800c37:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4e:	89 d1                	mov    %edx,%ecx
  800c50:	89 d3                	mov    %edx,%ebx
  800c52:	89 d7                	mov    %edx,%edi
  800c54:	89 d6                	mov    %edx,%esi
  800c56:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    

00800c5d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	57                   	push   %edi
  800c61:	56                   	push   %esi
  800c62:	53                   	push   %ebx
  800c63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c73:	89 cb                	mov    %ecx,%ebx
  800c75:	89 cf                	mov    %ecx,%edi
  800c77:	89 ce                	mov    %ecx,%esi
  800c79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	7f 08                	jg     800c87 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c87:	83 ec 0c             	sub    $0xc,%esp
  800c8a:	50                   	push   %eax
  800c8b:	6a 03                	push   $0x3
  800c8d:	68 a4 28 80 00       	push   $0x8028a4
  800c92:	6a 43                	push   $0x43
  800c94:	68 c1 28 80 00       	push   $0x8028c1
  800c99:	e8 69 14 00 00       	call   802107 <_panic>

00800c9e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cae:	89 d1                	mov    %edx,%ecx
  800cb0:	89 d3                	mov    %edx,%ebx
  800cb2:	89 d7                	mov    %edx,%edi
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_yield>:

void
sys_yield(void)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	89 d3                	mov    %edx,%ebx
  800cd1:	89 d7                	mov    %edx,%edi
  800cd3:	89 d6                	mov    %edx,%esi
  800cd5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce5:	be 00 00 00 00       	mov    $0x0,%esi
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf8:	89 f7                	mov    %esi,%edi
  800cfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7f 08                	jg     800d08 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	6a 04                	push   $0x4
  800d0e:	68 a4 28 80 00       	push   $0x8028a4
  800d13:	6a 43                	push   $0x43
  800d15:	68 c1 28 80 00       	push   $0x8028c1
  800d1a:	e8 e8 13 00 00       	call   802107 <_panic>

00800d1f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d39:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 05                	push   $0x5
  800d50:	68 a4 28 80 00       	push   $0x8028a4
  800d55:	6a 43                	push   $0x43
  800d57:	68 c1 28 80 00       	push   $0x8028c1
  800d5c:	e8 a6 13 00 00       	call   802107 <_panic>

00800d61 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	89 de                	mov    %ebx,%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 06                	push   $0x6
  800d92:	68 a4 28 80 00       	push   $0x8028a4
  800d97:	6a 43                	push   $0x43
  800d99:	68 c1 28 80 00       	push   $0x8028c1
  800d9e:	e8 64 13 00 00       	call   802107 <_panic>

00800da3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7f 08                	jg     800dce <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dce:	83 ec 0c             	sub    $0xc,%esp
  800dd1:	50                   	push   %eax
  800dd2:	6a 08                	push   $0x8
  800dd4:	68 a4 28 80 00       	push   $0x8028a4
  800dd9:	6a 43                	push   $0x43
  800ddb:	68 c1 28 80 00       	push   $0x8028c1
  800de0:	e8 22 13 00 00       	call   802107 <_panic>

00800de5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	b8 09 00 00 00       	mov    $0x9,%eax
  800dfe:	89 df                	mov    %ebx,%edi
  800e00:	89 de                	mov    %ebx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 09                	push   $0x9
  800e16:	68 a4 28 80 00       	push   $0x8028a4
  800e1b:	6a 43                	push   $0x43
  800e1d:	68 c1 28 80 00       	push   $0x8028c1
  800e22:	e8 e0 12 00 00       	call   802107 <_panic>

00800e27 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	89 de                	mov    %ebx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0a                	push   $0xa
  800e58:	68 a4 28 80 00       	push   $0x8028a4
  800e5d:	6a 43                	push   $0x43
  800e5f:	68 c1 28 80 00       	push   $0x8028c1
  800e64:	e8 9e 12 00 00       	call   802107 <_panic>

00800e69 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e7a:	be 00 00 00 00       	mov    $0x0,%esi
  800e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e82:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e85:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea2:	89 cb                	mov    %ecx,%ebx
  800ea4:	89 cf                	mov    %ecx,%edi
  800ea6:	89 ce                	mov    %ecx,%esi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 0d                	push   $0xd
  800ebc:	68 a4 28 80 00       	push   $0x8028a4
  800ec1:	6a 43                	push   $0x43
  800ec3:	68 c1 28 80 00       	push   $0x8028c1
  800ec8:	e8 3a 12 00 00       	call   802107 <_panic>

00800ecd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ede:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    

00800eee <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f01:	89 cb                	mov    %ecx,%ebx
  800f03:	89 cf                	mov    %ecx,%edi
  800f05:	89 ce                	mov    %ecx,%esi
  800f07:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
  800f19:	b8 10 00 00 00       	mov    $0x10,%eax
  800f1e:	89 d1                	mov    %edx,%ecx
  800f20:	89 d3                	mov    %edx,%ebx
  800f22:	89 d7                	mov    %edx,%edi
  800f24:	89 d6                	mov    %edx,%esi
  800f26:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 11 00 00 00       	mov    $0x11,%eax
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 12 00 00 00       	mov    $0x12,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	b8 13 00 00 00       	mov    $0x13,%eax
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7f 08                	jg     800f9a <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	50                   	push   %eax
  800f9e:	6a 13                	push   $0x13
  800fa0:	68 a4 28 80 00       	push   $0x8028a4
  800fa5:	6a 43                	push   $0x43
  800fa7:	68 c1 28 80 00       	push   $0x8028c1
  800fac:	e8 56 11 00 00       	call   802107 <_panic>

00800fb1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbc:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	c1 ea 16             	shr    $0x16,%edx
  800fe5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fec:	f6 c2 01             	test   $0x1,%dl
  800fef:	74 2d                	je     80101e <fd_alloc+0x46>
  800ff1:	89 c2                	mov    %eax,%edx
  800ff3:	c1 ea 0c             	shr    $0xc,%edx
  800ff6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ffd:	f6 c2 01             	test   $0x1,%dl
  801000:	74 1c                	je     80101e <fd_alloc+0x46>
  801002:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801007:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80100c:	75 d2                	jne    800fe0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801017:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80101c:	eb 0a                	jmp    801028 <fd_alloc+0x50>
			*fd_store = fd;
  80101e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801021:	89 01                	mov    %eax,(%ecx)
			return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801030:	83 f8 1f             	cmp    $0x1f,%eax
  801033:	77 30                	ja     801065 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801035:	c1 e0 0c             	shl    $0xc,%eax
  801038:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80103d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801043:	f6 c2 01             	test   $0x1,%dl
  801046:	74 24                	je     80106c <fd_lookup+0x42>
  801048:	89 c2                	mov    %eax,%edx
  80104a:	c1 ea 0c             	shr    $0xc,%edx
  80104d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801054:	f6 c2 01             	test   $0x1,%dl
  801057:	74 1a                	je     801073 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105c:	89 02                	mov    %eax,(%edx)
	return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    
		return -E_INVAL;
  801065:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106a:	eb f7                	jmp    801063 <fd_lookup+0x39>
		return -E_INVAL;
  80106c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801071:	eb f0                	jmp    801063 <fd_lookup+0x39>
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb e9                	jmp    801063 <fd_lookup+0x39>

0080107a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801083:	ba 00 00 00 00       	mov    $0x0,%edx
  801088:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80108d:	39 08                	cmp    %ecx,(%eax)
  80108f:	74 38                	je     8010c9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801091:	83 c2 01             	add    $0x1,%edx
  801094:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  80109b:	85 c0                	test   %eax,%eax
  80109d:	75 ee                	jne    80108d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80109f:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a4:	8b 40 48             	mov    0x48(%eax),%eax
  8010a7:	83 ec 04             	sub    $0x4,%esp
  8010aa:	51                   	push   %ecx
  8010ab:	50                   	push   %eax
  8010ac:	68 d0 28 80 00       	push   $0x8028d0
  8010b1:	e8 d5 f0 ff ff       	call   80018b <cprintf>
	*dev = 0;
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    
			*dev = devtab[i];
  8010c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d3:	eb f2                	jmp    8010c7 <dev_lookup+0x4d>

008010d5 <fd_close>:
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 24             	sub    $0x24,%esp
  8010de:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ee:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f1:	50                   	push   %eax
  8010f2:	e8 33 ff ff ff       	call   80102a <fd_lookup>
  8010f7:	89 c3                	mov    %eax,%ebx
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	78 05                	js     801105 <fd_close+0x30>
	    || fd != fd2)
  801100:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801103:	74 16                	je     80111b <fd_close+0x46>
		return (must_exist ? r : 0);
  801105:	89 f8                	mov    %edi,%eax
  801107:	84 c0                	test   %al,%al
  801109:	b8 00 00 00 00       	mov    $0x0,%eax
  80110e:	0f 44 d8             	cmove  %eax,%ebx
}
  801111:	89 d8                	mov    %ebx,%eax
  801113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801116:	5b                   	pop    %ebx
  801117:	5e                   	pop    %esi
  801118:	5f                   	pop    %edi
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801121:	50                   	push   %eax
  801122:	ff 36                	pushl  (%esi)
  801124:	e8 51 ff ff ff       	call   80107a <dev_lookup>
  801129:	89 c3                	mov    %eax,%ebx
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 1a                	js     80114c <fd_close+0x77>
		if (dev->dev_close)
  801132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801135:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801138:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	74 0b                	je     80114c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	56                   	push   %esi
  801145:	ff d0                	call   *%eax
  801147:	89 c3                	mov    %eax,%ebx
  801149:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80114c:	83 ec 08             	sub    $0x8,%esp
  80114f:	56                   	push   %esi
  801150:	6a 00                	push   $0x0
  801152:	e8 0a fc ff ff       	call   800d61 <sys_page_unmap>
	return r;
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	eb b5                	jmp    801111 <fd_close+0x3c>

0080115c <close>:

int
close(int fdnum)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801162:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	ff 75 08             	pushl  0x8(%ebp)
  801169:	e8 bc fe ff ff       	call   80102a <fd_lookup>
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	79 02                	jns    801177 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    
		return fd_close(fd, 1);
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	6a 01                	push   $0x1
  80117c:	ff 75 f4             	pushl  -0xc(%ebp)
  80117f:	e8 51 ff ff ff       	call   8010d5 <fd_close>
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	eb ec                	jmp    801175 <close+0x19>

00801189 <close_all>:

void
close_all(void)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	53                   	push   %ebx
  80118d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801190:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	53                   	push   %ebx
  801199:	e8 be ff ff ff       	call   80115c <close>
	for (i = 0; i < MAXFD; i++)
  80119e:	83 c3 01             	add    $0x1,%ebx
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	83 fb 20             	cmp    $0x20,%ebx
  8011a7:	75 ec                	jne    801195 <close_all+0xc>
}
  8011a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	57                   	push   %edi
  8011b2:	56                   	push   %esi
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	ff 75 08             	pushl  0x8(%ebp)
  8011be:	e8 67 fe ff ff       	call   80102a <fd_lookup>
  8011c3:	89 c3                	mov    %eax,%ebx
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	0f 88 81 00 00 00    	js     801251 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	ff 75 0c             	pushl  0xc(%ebp)
  8011d6:	e8 81 ff ff ff       	call   80115c <close>

	newfd = INDEX2FD(newfdnum);
  8011db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011de:	c1 e6 0c             	shl    $0xc,%esi
  8011e1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011e7:	83 c4 04             	add    $0x4,%esp
  8011ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ed:	e8 cf fd ff ff       	call   800fc1 <fd2data>
  8011f2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f4:	89 34 24             	mov    %esi,(%esp)
  8011f7:	e8 c5 fd ff ff       	call   800fc1 <fd2data>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801201:	89 d8                	mov    %ebx,%eax
  801203:	c1 e8 16             	shr    $0x16,%eax
  801206:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120d:	a8 01                	test   $0x1,%al
  80120f:	74 11                	je     801222 <dup+0x74>
  801211:	89 d8                	mov    %ebx,%eax
  801213:	c1 e8 0c             	shr    $0xc,%eax
  801216:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121d:	f6 c2 01             	test   $0x1,%dl
  801220:	75 39                	jne    80125b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801225:	89 d0                	mov    %edx,%eax
  801227:	c1 e8 0c             	shr    $0xc,%eax
  80122a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	25 07 0e 00 00       	and    $0xe07,%eax
  801239:	50                   	push   %eax
  80123a:	56                   	push   %esi
  80123b:	6a 00                	push   $0x0
  80123d:	52                   	push   %edx
  80123e:	6a 00                	push   $0x0
  801240:	e8 da fa ff ff       	call   800d1f <sys_page_map>
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 20             	add    $0x20,%esp
  80124a:	85 c0                	test   %eax,%eax
  80124c:	78 31                	js     80127f <dup+0xd1>
		goto err;

	return newfdnum;
  80124e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801251:	89 d8                	mov    %ebx,%eax
  801253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801256:	5b                   	pop    %ebx
  801257:	5e                   	pop    %esi
  801258:	5f                   	pop    %edi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801262:	83 ec 0c             	sub    $0xc,%esp
  801265:	25 07 0e 00 00       	and    $0xe07,%eax
  80126a:	50                   	push   %eax
  80126b:	57                   	push   %edi
  80126c:	6a 00                	push   $0x0
  80126e:	53                   	push   %ebx
  80126f:	6a 00                	push   $0x0
  801271:	e8 a9 fa ff ff       	call   800d1f <sys_page_map>
  801276:	89 c3                	mov    %eax,%ebx
  801278:	83 c4 20             	add    $0x20,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	79 a3                	jns    801222 <dup+0x74>
	sys_page_unmap(0, newfd);
  80127f:	83 ec 08             	sub    $0x8,%esp
  801282:	56                   	push   %esi
  801283:	6a 00                	push   $0x0
  801285:	e8 d7 fa ff ff       	call   800d61 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	57                   	push   %edi
  80128e:	6a 00                	push   $0x0
  801290:	e8 cc fa ff ff       	call   800d61 <sys_page_unmap>
	return r;
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	eb b7                	jmp    801251 <dup+0xa3>

0080129a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	53                   	push   %ebx
  80129e:	83 ec 1c             	sub    $0x1c,%esp
  8012a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a7:	50                   	push   %eax
  8012a8:	53                   	push   %ebx
  8012a9:	e8 7c fd ff ff       	call   80102a <fd_lookup>
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	78 3f                	js     8012f4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bb:	50                   	push   %eax
  8012bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bf:	ff 30                	pushl  (%eax)
  8012c1:	e8 b4 fd ff ff       	call   80107a <dev_lookup>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 27                	js     8012f4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d0:	8b 42 08             	mov    0x8(%edx),%eax
  8012d3:	83 e0 03             	and    $0x3,%eax
  8012d6:	83 f8 01             	cmp    $0x1,%eax
  8012d9:	74 1e                	je     8012f9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012de:	8b 40 08             	mov    0x8(%eax),%eax
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	74 35                	je     80131a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	ff 75 10             	pushl  0x10(%ebp)
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	52                   	push   %edx
  8012ef:	ff d0                	call   *%eax
  8012f1:	83 c4 10             	add    $0x10,%esp
}
  8012f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8012fe:	8b 40 48             	mov    0x48(%eax),%eax
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	53                   	push   %ebx
  801305:	50                   	push   %eax
  801306:	68 11 29 80 00       	push   $0x802911
  80130b:	e8 7b ee ff ff       	call   80018b <cprintf>
		return -E_INVAL;
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801318:	eb da                	jmp    8012f4 <read+0x5a>
		return -E_NOT_SUPP;
  80131a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131f:	eb d3                	jmp    8012f4 <read+0x5a>

00801321 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	57                   	push   %edi
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	83 ec 0c             	sub    $0xc,%esp
  80132a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
  801335:	39 f3                	cmp    %esi,%ebx
  801337:	73 23                	jae    80135c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	89 f0                	mov    %esi,%eax
  80133e:	29 d8                	sub    %ebx,%eax
  801340:	50                   	push   %eax
  801341:	89 d8                	mov    %ebx,%eax
  801343:	03 45 0c             	add    0xc(%ebp),%eax
  801346:	50                   	push   %eax
  801347:	57                   	push   %edi
  801348:	e8 4d ff ff ff       	call   80129a <read>
		if (m < 0)
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	78 06                	js     80135a <readn+0x39>
			return m;
		if (m == 0)
  801354:	74 06                	je     80135c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801356:	01 c3                	add    %eax,%ebx
  801358:	eb db                	jmp    801335 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80135c:	89 d8                	mov    %ebx,%eax
  80135e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801361:	5b                   	pop    %ebx
  801362:	5e                   	pop    %esi
  801363:	5f                   	pop    %edi
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	53                   	push   %ebx
  80136a:	83 ec 1c             	sub    $0x1c,%esp
  80136d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801370:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801373:	50                   	push   %eax
  801374:	53                   	push   %ebx
  801375:	e8 b0 fc ff ff       	call   80102a <fd_lookup>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 3a                	js     8013bb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138b:	ff 30                	pushl  (%eax)
  80138d:	e8 e8 fc ff ff       	call   80107a <dev_lookup>
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 22                	js     8013bb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a0:	74 1e                	je     8013c0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a8:	85 d2                	test   %edx,%edx
  8013aa:	74 35                	je     8013e1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	ff 75 10             	pushl  0x10(%ebp)
  8013b2:	ff 75 0c             	pushl  0xc(%ebp)
  8013b5:	50                   	push   %eax
  8013b6:	ff d2                	call   *%edx
  8013b8:	83 c4 10             	add    $0x10,%esp
}
  8013bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c5:	8b 40 48             	mov    0x48(%eax),%eax
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	53                   	push   %ebx
  8013cc:	50                   	push   %eax
  8013cd:	68 2d 29 80 00       	push   $0x80292d
  8013d2:	e8 b4 ed ff ff       	call   80018b <cprintf>
		return -E_INVAL;
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013df:	eb da                	jmp    8013bb <write+0x55>
		return -E_NOT_SUPP;
  8013e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e6:	eb d3                	jmp    8013bb <write+0x55>

008013e8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	e8 30 fc ff ff       	call   80102a <fd_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 0e                	js     80140f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80140a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	53                   	push   %ebx
  801415:	83 ec 1c             	sub    $0x1c,%esp
  801418:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	53                   	push   %ebx
  801420:	e8 05 fc ff ff       	call   80102a <fd_lookup>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 37                	js     801463 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142c:	83 ec 08             	sub    $0x8,%esp
  80142f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	ff 30                	pushl  (%eax)
  801438:	e8 3d fc ff ff       	call   80107a <dev_lookup>
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	78 1f                	js     801463 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801447:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80144b:	74 1b                	je     801468 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80144d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801450:	8b 52 18             	mov    0x18(%edx),%edx
  801453:	85 d2                	test   %edx,%edx
  801455:	74 32                	je     801489 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	50                   	push   %eax
  80145e:	ff d2                	call   *%edx
  801460:	83 c4 10             	add    $0x10,%esp
}
  801463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801466:	c9                   	leave  
  801467:	c3                   	ret    
			thisenv->env_id, fdnum);
  801468:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80146d:	8b 40 48             	mov    0x48(%eax),%eax
  801470:	83 ec 04             	sub    $0x4,%esp
  801473:	53                   	push   %ebx
  801474:	50                   	push   %eax
  801475:	68 f0 28 80 00       	push   $0x8028f0
  80147a:	e8 0c ed ff ff       	call   80018b <cprintf>
		return -E_INVAL;
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801487:	eb da                	jmp    801463 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801489:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148e:	eb d3                	jmp    801463 <ftruncate+0x52>

00801490 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	53                   	push   %ebx
  801494:	83 ec 1c             	sub    $0x1c,%esp
  801497:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149d:	50                   	push   %eax
  80149e:	ff 75 08             	pushl  0x8(%ebp)
  8014a1:	e8 84 fb ff ff       	call   80102a <fd_lookup>
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 4b                	js     8014f8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b3:	50                   	push   %eax
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	ff 30                	pushl  (%eax)
  8014b9:	e8 bc fb ff ff       	call   80107a <dev_lookup>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 33                	js     8014f8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014cc:	74 2f                	je     8014fd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ce:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014d8:	00 00 00 
	stat->st_isdir = 0;
  8014db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e2:	00 00 00 
	stat->st_dev = dev;
  8014e5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	53                   	push   %ebx
  8014ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f2:	ff 50 14             	call   *0x14(%eax)
  8014f5:	83 c4 10             	add    $0x10,%esp
}
  8014f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    
		return -E_NOT_SUPP;
  8014fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801502:	eb f4                	jmp    8014f8 <fstat+0x68>

00801504 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	6a 00                	push   $0x0
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	e8 22 02 00 00       	call   801738 <open>
  801516:	89 c3                	mov    %eax,%ebx
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 1b                	js     80153a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	ff 75 0c             	pushl  0xc(%ebp)
  801525:	50                   	push   %eax
  801526:	e8 65 ff ff ff       	call   801490 <fstat>
  80152b:	89 c6                	mov    %eax,%esi
	close(fd);
  80152d:	89 1c 24             	mov    %ebx,(%esp)
  801530:	e8 27 fc ff ff       	call   80115c <close>
	return r;
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	89 f3                	mov    %esi,%ebx
}
  80153a:	89 d8                	mov    %ebx,%eax
  80153c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    

00801543 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
  801548:	89 c6                	mov    %eax,%esi
  80154a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80154c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801553:	74 27                	je     80157c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801555:	6a 07                	push   $0x7
  801557:	68 00 50 80 00       	push   $0x805000
  80155c:	56                   	push   %esi
  80155d:	ff 35 00 40 80 00    	pushl  0x804000
  801563:	e8 69 0c 00 00       	call   8021d1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801568:	83 c4 0c             	add    $0xc,%esp
  80156b:	6a 00                	push   $0x0
  80156d:	53                   	push   %ebx
  80156e:	6a 00                	push   $0x0
  801570:	e8 f3 0b 00 00       	call   802168 <ipc_recv>
}
  801575:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801578:	5b                   	pop    %ebx
  801579:	5e                   	pop    %esi
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80157c:	83 ec 0c             	sub    $0xc,%esp
  80157f:	6a 01                	push   $0x1
  801581:	e8 a3 0c 00 00       	call   802229 <ipc_find_env>
  801586:	a3 00 40 80 00       	mov    %eax,0x804000
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	eb c5                	jmp    801555 <fsipc+0x12>

00801590 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8b 40 0c             	mov    0xc(%eax),%eax
  80159c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b3:	e8 8b ff ff ff       	call   801543 <fsipc>
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <devfile_flush>:
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d5:	e8 69 ff ff ff       	call   801543 <fsipc>
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <devfile_stat>:
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ec:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8015fb:	e8 43 ff ff ff       	call   801543 <fsipc>
  801600:	85 c0                	test   %eax,%eax
  801602:	78 2c                	js     801630 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	68 00 50 80 00       	push   $0x805000
  80160c:	53                   	push   %ebx
  80160d:	e8 d8 f2 ff ff       	call   8008ea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801612:	a1 80 50 80 00       	mov    0x805080,%eax
  801617:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80161d:	a1 84 50 80 00       	mov    0x805084,%eax
  801622:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <devfile_write>:
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 40 0c             	mov    0xc(%eax),%eax
  801645:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80164a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801650:	53                   	push   %ebx
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	68 08 50 80 00       	push   $0x805008
  801659:	e8 7c f4 ff ff       	call   800ada <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	b8 04 00 00 00       	mov    $0x4,%eax
  801668:	e8 d6 fe ff ff       	call   801543 <fsipc>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 0b                	js     80167f <devfile_write+0x4a>
	assert(r <= n);
  801674:	39 d8                	cmp    %ebx,%eax
  801676:	77 0c                	ja     801684 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801678:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80167d:	7f 1e                	jg     80169d <devfile_write+0x68>
}
  80167f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801682:	c9                   	leave  
  801683:	c3                   	ret    
	assert(r <= n);
  801684:	68 60 29 80 00       	push   $0x802960
  801689:	68 67 29 80 00       	push   $0x802967
  80168e:	68 98 00 00 00       	push   $0x98
  801693:	68 7c 29 80 00       	push   $0x80297c
  801698:	e8 6a 0a 00 00       	call   802107 <_panic>
	assert(r <= PGSIZE);
  80169d:	68 87 29 80 00       	push   $0x802987
  8016a2:	68 67 29 80 00       	push   $0x802967
  8016a7:	68 99 00 00 00       	push   $0x99
  8016ac:	68 7c 29 80 00       	push   $0x80297c
  8016b1:	e8 51 0a 00 00       	call   802107 <_panic>

008016b6 <devfile_read>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016c9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	e8 65 fe ff ff       	call   801543 <fsipc>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 1f                	js     801703 <devfile_read+0x4d>
	assert(r <= n);
  8016e4:	39 f0                	cmp    %esi,%eax
  8016e6:	77 24                	ja     80170c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016e8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ed:	7f 33                	jg     801722 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	50                   	push   %eax
  8016f3:	68 00 50 80 00       	push   $0x805000
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	e8 78 f3 ff ff       	call   800a78 <memmove>
	return r;
  801700:	83 c4 10             	add    $0x10,%esp
}
  801703:	89 d8                	mov    %ebx,%eax
  801705:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    
	assert(r <= n);
  80170c:	68 60 29 80 00       	push   $0x802960
  801711:	68 67 29 80 00       	push   $0x802967
  801716:	6a 7c                	push   $0x7c
  801718:	68 7c 29 80 00       	push   $0x80297c
  80171d:	e8 e5 09 00 00       	call   802107 <_panic>
	assert(r <= PGSIZE);
  801722:	68 87 29 80 00       	push   $0x802987
  801727:	68 67 29 80 00       	push   $0x802967
  80172c:	6a 7d                	push   $0x7d
  80172e:	68 7c 29 80 00       	push   $0x80297c
  801733:	e8 cf 09 00 00       	call   802107 <_panic>

00801738 <open>:
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 1c             	sub    $0x1c,%esp
  801740:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801743:	56                   	push   %esi
  801744:	e8 68 f1 ff ff       	call   8008b1 <strlen>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801751:	7f 6c                	jg     8017bf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801753:	83 ec 0c             	sub    $0xc,%esp
  801756:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801759:	50                   	push   %eax
  80175a:	e8 79 f8 ff ff       	call   800fd8 <fd_alloc>
  80175f:	89 c3                	mov    %eax,%ebx
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	78 3c                	js     8017a4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	56                   	push   %esi
  80176c:	68 00 50 80 00       	push   $0x805000
  801771:	e8 74 f1 ff ff       	call   8008ea <strcpy>
	fsipcbuf.open.req_omode = mode;
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80177e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801781:	b8 01 00 00 00       	mov    $0x1,%eax
  801786:	e8 b8 fd ff ff       	call   801543 <fsipc>
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	85 c0                	test   %eax,%eax
  801792:	78 19                	js     8017ad <open+0x75>
	return fd2num(fd);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 f4             	pushl  -0xc(%ebp)
  80179a:	e8 12 f8 ff ff       	call   800fb1 <fd2num>
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
}
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    
		fd_close(fd, 0);
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	6a 00                	push   $0x0
  8017b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b5:	e8 1b f9 ff ff       	call   8010d5 <fd_close>
		return r;
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	eb e5                	jmp    8017a4 <open+0x6c>
		return -E_BAD_PATH;
  8017bf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c4:	eb de                	jmp    8017a4 <open+0x6c>

008017c6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d6:	e8 68 fd ff ff       	call   801543 <fsipc>
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017e3:	68 93 29 80 00       	push   $0x802993
  8017e8:	ff 75 0c             	pushl  0xc(%ebp)
  8017eb:	e8 fa f0 ff ff       	call   8008ea <strcpy>
	return 0;
}
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <devsock_close>:
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	53                   	push   %ebx
  8017fb:	83 ec 10             	sub    $0x10,%esp
  8017fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801801:	53                   	push   %ebx
  801802:	e8 5d 0a 00 00       	call   802264 <pageref>
  801807:	83 c4 10             	add    $0x10,%esp
		return 0;
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80180f:	83 f8 01             	cmp    $0x1,%eax
  801812:	74 07                	je     80181b <devsock_close+0x24>
}
  801814:	89 d0                	mov    %edx,%eax
  801816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801819:	c9                   	leave  
  80181a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	ff 73 0c             	pushl  0xc(%ebx)
  801821:	e8 b9 02 00 00       	call   801adf <nsipc_close>
  801826:	89 c2                	mov    %eax,%edx
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	eb e7                	jmp    801814 <devsock_close+0x1d>

0080182d <devsock_write>:
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801833:	6a 00                	push   $0x0
  801835:	ff 75 10             	pushl  0x10(%ebp)
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	ff 70 0c             	pushl  0xc(%eax)
  801841:	e8 76 03 00 00       	call   801bbc <nsipc_send>
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <devsock_read>:
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80184e:	6a 00                	push   $0x0
  801850:	ff 75 10             	pushl  0x10(%ebp)
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	ff 70 0c             	pushl  0xc(%eax)
  80185c:	e8 ef 02 00 00       	call   801b50 <nsipc_recv>
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <fd2sockid>:
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801869:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	e8 b7 f7 ff ff       	call   80102a <fd_lookup>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	78 10                	js     80188a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801883:	39 08                	cmp    %ecx,(%eax)
  801885:	75 05                	jne    80188c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801887:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    
		return -E_NOT_SUPP;
  80188c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801891:	eb f7                	jmp    80188a <fd2sockid+0x27>

00801893 <alloc_sockfd>:
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	83 ec 1c             	sub    $0x1c,%esp
  80189b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80189d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a0:	50                   	push   %eax
  8018a1:	e8 32 f7 ff ff       	call   800fd8 <fd_alloc>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 43                	js     8018f2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 07 04 00 00       	push   $0x407
  8018b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ba:	6a 00                	push   $0x0
  8018bc:	e8 1b f4 ff ff       	call   800cdc <sys_page_alloc>
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 28                	js     8018f2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018df:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	50                   	push   %eax
  8018e6:	e8 c6 f6 ff ff       	call   800fb1 <fd2num>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	eb 0c                	jmp    8018fe <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018f2:	83 ec 0c             	sub    $0xc,%esp
  8018f5:	56                   	push   %esi
  8018f6:	e8 e4 01 00 00       	call   801adf <nsipc_close>
		return r;
  8018fb:	83 c4 10             	add    $0x10,%esp
}
  8018fe:	89 d8                	mov    %ebx,%eax
  801900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801903:	5b                   	pop    %ebx
  801904:	5e                   	pop    %esi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <accept>:
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	e8 4e ff ff ff       	call   801863 <fd2sockid>
  801915:	85 c0                	test   %eax,%eax
  801917:	78 1b                	js     801934 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	ff 75 10             	pushl  0x10(%ebp)
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	50                   	push   %eax
  801923:	e8 0e 01 00 00       	call   801a36 <nsipc_accept>
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 05                	js     801934 <accept+0x2d>
	return alloc_sockfd(r);
  80192f:	e8 5f ff ff ff       	call   801893 <alloc_sockfd>
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <bind>:
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	e8 1f ff ff ff       	call   801863 <fd2sockid>
  801944:	85 c0                	test   %eax,%eax
  801946:	78 12                	js     80195a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	50                   	push   %eax
  801952:	e8 31 01 00 00       	call   801a88 <nsipc_bind>
  801957:	83 c4 10             	add    $0x10,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <shutdown>:
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	e8 f9 fe ff ff       	call   801863 <fd2sockid>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 0f                	js     80197d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	50                   	push   %eax
  801975:	e8 43 01 00 00       	call   801abd <nsipc_shutdown>
  80197a:	83 c4 10             	add    $0x10,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <connect>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	e8 d6 fe ff ff       	call   801863 <fd2sockid>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 12                	js     8019a3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	ff 75 10             	pushl  0x10(%ebp)
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	50                   	push   %eax
  80199b:	e8 59 01 00 00       	call   801af9 <nsipc_connect>
  8019a0:	83 c4 10             	add    $0x10,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <listen>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	e8 b0 fe ff ff       	call   801863 <fd2sockid>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 0f                	js     8019c6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	50                   	push   %eax
  8019be:	e8 6b 01 00 00       	call   801b2e <nsipc_listen>
  8019c3:	83 c4 10             	add    $0x10,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ce:	ff 75 10             	pushl  0x10(%ebp)
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	ff 75 08             	pushl  0x8(%ebp)
  8019d7:	e8 3e 02 00 00       	call   801c1a <nsipc_socket>
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 05                	js     8019e8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019e3:	e8 ab fe ff ff       	call   801893 <alloc_sockfd>
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019f3:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019fa:	74 26                	je     801a22 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019fc:	6a 07                	push   $0x7
  8019fe:	68 00 60 80 00       	push   $0x806000
  801a03:	53                   	push   %ebx
  801a04:	ff 35 04 40 80 00    	pushl  0x804004
  801a0a:	e8 c2 07 00 00       	call   8021d1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a0f:	83 c4 0c             	add    $0xc,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	e8 4b 07 00 00       	call   802168 <ipc_recv>
}
  801a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a22:	83 ec 0c             	sub    $0xc,%esp
  801a25:	6a 02                	push   $0x2
  801a27:	e8 fd 07 00 00       	call   802229 <ipc_find_env>
  801a2c:	a3 04 40 80 00       	mov    %eax,0x804004
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	eb c6                	jmp    8019fc <nsipc+0x12>

00801a36 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a46:	8b 06                	mov    (%esi),%eax
  801a48:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	e8 93 ff ff ff       	call   8019ea <nsipc>
  801a57:	89 c3                	mov    %eax,%ebx
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	79 09                	jns    801a66 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	ff 35 10 60 80 00    	pushl  0x806010
  801a6f:	68 00 60 80 00       	push   $0x806000
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	e8 fc ef ff ff       	call   800a78 <memmove>
		*addrlen = ret->ret_addrlen;
  801a7c:	a1 10 60 80 00       	mov    0x806010,%eax
  801a81:	89 06                	mov    %eax,(%esi)
  801a83:	83 c4 10             	add    $0x10,%esp
	return r;
  801a86:	eb d5                	jmp    801a5d <nsipc_accept+0x27>

00801a88 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 08             	sub    $0x8,%esp
  801a8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a9a:	53                   	push   %ebx
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	68 04 60 80 00       	push   $0x806004
  801aa3:	e8 d0 ef ff ff       	call   800a78 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aa8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aae:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab3:	e8 32 ff ff ff       	call   8019ea <nsipc>
}
  801ab8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ad3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad8:	e8 0d ff ff ff       	call   8019ea <nsipc>
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <nsipc_close>:

int
nsipc_close(int s)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801aed:	b8 04 00 00 00       	mov    $0x4,%eax
  801af2:	e8 f3 fe ff ff       	call   8019ea <nsipc>
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	53                   	push   %ebx
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b0b:	53                   	push   %ebx
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	68 04 60 80 00       	push   $0x806004
  801b14:	e8 5f ef ff ff       	call   800a78 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b19:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b24:	e8 c1 fe ff ff       	call   8019ea <nsipc>
}
  801b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b44:	b8 06 00 00 00       	mov    $0x6,%eax
  801b49:	e8 9c fe ff ff       	call   8019ea <nsipc>
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
  801b55:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b60:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b6e:	b8 07 00 00 00       	mov    $0x7,%eax
  801b73:	e8 72 fe ff ff       	call   8019ea <nsipc>
  801b78:	89 c3                	mov    %eax,%ebx
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 1f                	js     801b9d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b7e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b83:	7f 21                	jg     801ba6 <nsipc_recv+0x56>
  801b85:	39 c6                	cmp    %eax,%esi
  801b87:	7c 1d                	jl     801ba6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	50                   	push   %eax
  801b8d:	68 00 60 80 00       	push   $0x806000
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 de ee ff ff       	call   800a78 <memmove>
  801b9a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b9d:	89 d8                	mov    %ebx,%eax
  801b9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ba6:	68 9f 29 80 00       	push   $0x80299f
  801bab:	68 67 29 80 00       	push   $0x802967
  801bb0:	6a 62                	push   $0x62
  801bb2:	68 b4 29 80 00       	push   $0x8029b4
  801bb7:	e8 4b 05 00 00       	call   802107 <_panic>

00801bbc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bce:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bd4:	7f 2e                	jg     801c04 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	53                   	push   %ebx
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	68 0c 60 80 00       	push   $0x80600c
  801be2:	e8 91 ee ff ff       	call   800a78 <memmove>
	nsipcbuf.send.req_size = size;
  801be7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bf5:	b8 08 00 00 00       	mov    $0x8,%eax
  801bfa:	e8 eb fd ff ff       	call   8019ea <nsipc>
}
  801bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    
	assert(size < 1600);
  801c04:	68 c0 29 80 00       	push   $0x8029c0
  801c09:	68 67 29 80 00       	push   $0x802967
  801c0e:	6a 6d                	push   $0x6d
  801c10:	68 b4 29 80 00       	push   $0x8029b4
  801c15:	e8 ed 04 00 00       	call   802107 <_panic>

00801c1a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c30:	8b 45 10             	mov    0x10(%ebp),%eax
  801c33:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c38:	b8 09 00 00 00       	mov    $0x9,%eax
  801c3d:	e8 a8 fd ff ff       	call   8019ea <nsipc>
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	e8 6a f3 ff ff       	call   800fc1 <fd2data>
  801c57:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c59:	83 c4 08             	add    $0x8,%esp
  801c5c:	68 cc 29 80 00       	push   $0x8029cc
  801c61:	53                   	push   %ebx
  801c62:	e8 83 ec ff ff       	call   8008ea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c67:	8b 46 04             	mov    0x4(%esi),%eax
  801c6a:	2b 06                	sub    (%esi),%eax
  801c6c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c72:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c79:	00 00 00 
	stat->st_dev = &devpipe;
  801c7c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c83:	30 80 00 
	return 0;
}
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    

00801c92 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c9c:	53                   	push   %ebx
  801c9d:	6a 00                	push   $0x0
  801c9f:	e8 bd f0 ff ff       	call   800d61 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca4:	89 1c 24             	mov    %ebx,(%esp)
  801ca7:	e8 15 f3 ff ff       	call   800fc1 <fd2data>
  801cac:	83 c4 08             	add    $0x8,%esp
  801caf:	50                   	push   %eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	e8 aa f0 ff ff       	call   800d61 <sys_page_unmap>
}
  801cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <_pipeisclosed>:
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	57                   	push   %edi
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 1c             	sub    $0x1c,%esp
  801cc5:	89 c7                	mov    %eax,%edi
  801cc7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc9:	a1 08 40 80 00       	mov    0x804008,%eax
  801cce:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	57                   	push   %edi
  801cd5:	e8 8a 05 00 00       	call   802264 <pageref>
  801cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cdd:	89 34 24             	mov    %esi,(%esp)
  801ce0:	e8 7f 05 00 00       	call   802264 <pageref>
		nn = thisenv->env_runs;
  801ce5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ceb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	39 cb                	cmp    %ecx,%ebx
  801cf3:	74 1b                	je     801d10 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf8:	75 cf                	jne    801cc9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cfa:	8b 42 58             	mov    0x58(%edx),%eax
  801cfd:	6a 01                	push   $0x1
  801cff:	50                   	push   %eax
  801d00:	53                   	push   %ebx
  801d01:	68 d3 29 80 00       	push   $0x8029d3
  801d06:	e8 80 e4 ff ff       	call   80018b <cprintf>
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	eb b9                	jmp    801cc9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d10:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d13:	0f 94 c0             	sete   %al
  801d16:	0f b6 c0             	movzbl %al,%eax
}
  801d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <devpipe_write>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	57                   	push   %edi
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	83 ec 28             	sub    $0x28,%esp
  801d2a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d2d:	56                   	push   %esi
  801d2e:	e8 8e f2 ff ff       	call   800fc1 <fd2data>
  801d33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d40:	74 4f                	je     801d91 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d42:	8b 43 04             	mov    0x4(%ebx),%eax
  801d45:	8b 0b                	mov    (%ebx),%ecx
  801d47:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4a:	39 d0                	cmp    %edx,%eax
  801d4c:	72 14                	jb     801d62 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d4e:	89 da                	mov    %ebx,%edx
  801d50:	89 f0                	mov    %esi,%eax
  801d52:	e8 65 ff ff ff       	call   801cbc <_pipeisclosed>
  801d57:	85 c0                	test   %eax,%eax
  801d59:	75 3b                	jne    801d96 <devpipe_write+0x75>
			sys_yield();
  801d5b:	e8 5d ef ff ff       	call   800cbd <sys_yield>
  801d60:	eb e0                	jmp    801d42 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d65:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d69:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	c1 fa 1f             	sar    $0x1f,%edx
  801d71:	89 d1                	mov    %edx,%ecx
  801d73:	c1 e9 1b             	shr    $0x1b,%ecx
  801d76:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d79:	83 e2 1f             	and    $0x1f,%edx
  801d7c:	29 ca                	sub    %ecx,%edx
  801d7e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d82:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d86:	83 c0 01             	add    $0x1,%eax
  801d89:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d8c:	83 c7 01             	add    $0x1,%edi
  801d8f:	eb ac                	jmp    801d3d <devpipe_write+0x1c>
	return i;
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	eb 05                	jmp    801d9b <devpipe_write+0x7a>
				return 0;
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5f                   	pop    %edi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <devpipe_read>:
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	57                   	push   %edi
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	83 ec 18             	sub    $0x18,%esp
  801dac:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801daf:	57                   	push   %edi
  801db0:	e8 0c f2 ff ff       	call   800fc1 <fd2data>
  801db5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	be 00 00 00 00       	mov    $0x0,%esi
  801dbf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc2:	75 14                	jne    801dd8 <devpipe_read+0x35>
	return i;
  801dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc7:	eb 02                	jmp    801dcb <devpipe_read+0x28>
				return i;
  801dc9:	89 f0                	mov    %esi,%eax
}
  801dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5f                   	pop    %edi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    
			sys_yield();
  801dd3:	e8 e5 ee ff ff       	call   800cbd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dd8:	8b 03                	mov    (%ebx),%eax
  801dda:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ddd:	75 18                	jne    801df7 <devpipe_read+0x54>
			if (i > 0)
  801ddf:	85 f6                	test   %esi,%esi
  801de1:	75 e6                	jne    801dc9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801de3:	89 da                	mov    %ebx,%edx
  801de5:	89 f8                	mov    %edi,%eax
  801de7:	e8 d0 fe ff ff       	call   801cbc <_pipeisclosed>
  801dec:	85 c0                	test   %eax,%eax
  801dee:	74 e3                	je     801dd3 <devpipe_read+0x30>
				return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
  801df5:	eb d4                	jmp    801dcb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df7:	99                   	cltd   
  801df8:	c1 ea 1b             	shr    $0x1b,%edx
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	83 e0 1f             	and    $0x1f,%eax
  801e00:	29 d0                	sub    %edx,%eax
  801e02:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e0d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e10:	83 c6 01             	add    $0x1,%esi
  801e13:	eb aa                	jmp    801dbf <devpipe_read+0x1c>

00801e15 <pipe>:
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	56                   	push   %esi
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e20:	50                   	push   %eax
  801e21:	e8 b2 f1 ff ff       	call   800fd8 <fd_alloc>
  801e26:	89 c3                	mov    %eax,%ebx
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	0f 88 23 01 00 00    	js     801f56 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	68 07 04 00 00       	push   $0x407
  801e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3e:	6a 00                	push   $0x0
  801e40:	e8 97 ee ff ff       	call   800cdc <sys_page_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	0f 88 04 01 00 00    	js     801f56 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e58:	50                   	push   %eax
  801e59:	e8 7a f1 ff ff       	call   800fd8 <fd_alloc>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	85 c0                	test   %eax,%eax
  801e65:	0f 88 db 00 00 00    	js     801f46 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	68 07 04 00 00       	push   $0x407
  801e73:	ff 75 f0             	pushl  -0x10(%ebp)
  801e76:	6a 00                	push   $0x0
  801e78:	e8 5f ee ff ff       	call   800cdc <sys_page_alloc>
  801e7d:	89 c3                	mov    %eax,%ebx
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	0f 88 bc 00 00 00    	js     801f46 <pipe+0x131>
	va = fd2data(fd0);
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e90:	e8 2c f1 ff ff       	call   800fc1 <fd2data>
  801e95:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e97:	83 c4 0c             	add    $0xc,%esp
  801e9a:	68 07 04 00 00       	push   $0x407
  801e9f:	50                   	push   %eax
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 35 ee ff ff       	call   800cdc <sys_page_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 82 00 00 00    	js     801f36 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eba:	e8 02 f1 ff ff       	call   800fc1 <fd2data>
  801ebf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ec6:	50                   	push   %eax
  801ec7:	6a 00                	push   $0x0
  801ec9:	56                   	push   %esi
  801eca:	6a 00                	push   $0x0
  801ecc:	e8 4e ee ff ff       	call   800d1f <sys_page_map>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	83 c4 20             	add    $0x20,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 4e                	js     801f28 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eda:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801eee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f4             	pushl  -0xc(%ebp)
  801f03:	e8 a9 f0 ff ff       	call   800fb1 <fd2num>
  801f08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f0b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f0d:	83 c4 04             	add    $0x4,%esp
  801f10:	ff 75 f0             	pushl  -0x10(%ebp)
  801f13:	e8 99 f0 ff ff       	call   800fb1 <fd2num>
  801f18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f26:	eb 2e                	jmp    801f56 <pipe+0x141>
	sys_page_unmap(0, va);
  801f28:	83 ec 08             	sub    $0x8,%esp
  801f2b:	56                   	push   %esi
  801f2c:	6a 00                	push   $0x0
  801f2e:	e8 2e ee ff ff       	call   800d61 <sys_page_unmap>
  801f33:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f36:	83 ec 08             	sub    $0x8,%esp
  801f39:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3c:	6a 00                	push   $0x0
  801f3e:	e8 1e ee ff ff       	call   800d61 <sys_page_unmap>
  801f43:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f46:	83 ec 08             	sub    $0x8,%esp
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 0e ee ff ff       	call   800d61 <sys_page_unmap>
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	89 d8                	mov    %ebx,%eax
  801f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <pipeisclosed>:
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	50                   	push   %eax
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 b9 f0 ff ff       	call   80102a <fd_lookup>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 18                	js     801f90 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7e:	e8 3e f0 ff ff       	call   800fc1 <fd2data>
	return _pipeisclosed(fd, p);
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	e8 2f fd ff ff       	call   801cbc <_pipeisclosed>
  801f8d:	83 c4 10             	add    $0x10,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	c3                   	ret    

00801f98 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f9e:	68 eb 29 80 00       	push   $0x8029eb
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	e8 3f e9 ff ff       	call   8008ea <strcpy>
	return 0;
}
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <devcons_write>:
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	57                   	push   %edi
  801fb6:	56                   	push   %esi
  801fb7:	53                   	push   %ebx
  801fb8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fbe:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fc3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fcc:	73 31                	jae    801fff <devcons_write+0x4d>
		m = n - tot;
  801fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd1:	29 f3                	sub    %esi,%ebx
  801fd3:	83 fb 7f             	cmp    $0x7f,%ebx
  801fd6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fdb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	53                   	push   %ebx
  801fe2:	89 f0                	mov    %esi,%eax
  801fe4:	03 45 0c             	add    0xc(%ebp),%eax
  801fe7:	50                   	push   %eax
  801fe8:	57                   	push   %edi
  801fe9:	e8 8a ea ff ff       	call   800a78 <memmove>
		sys_cputs(buf, m);
  801fee:	83 c4 08             	add    $0x8,%esp
  801ff1:	53                   	push   %ebx
  801ff2:	57                   	push   %edi
  801ff3:	e8 28 ec ff ff       	call   800c20 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ff8:	01 de                	add    %ebx,%esi
  801ffa:	83 c4 10             	add    $0x10,%esp
  801ffd:	eb ca                	jmp    801fc9 <devcons_write+0x17>
}
  801fff:	89 f0                	mov    %esi,%eax
  802001:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802004:	5b                   	pop    %ebx
  802005:	5e                   	pop    %esi
  802006:	5f                   	pop    %edi
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <devcons_read>:
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 08             	sub    $0x8,%esp
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802014:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802018:	74 21                	je     80203b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80201a:	e8 1f ec ff ff       	call   800c3e <sys_cgetc>
  80201f:	85 c0                	test   %eax,%eax
  802021:	75 07                	jne    80202a <devcons_read+0x21>
		sys_yield();
  802023:	e8 95 ec ff ff       	call   800cbd <sys_yield>
  802028:	eb f0                	jmp    80201a <devcons_read+0x11>
	if (c < 0)
  80202a:	78 0f                	js     80203b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80202c:	83 f8 04             	cmp    $0x4,%eax
  80202f:	74 0c                	je     80203d <devcons_read+0x34>
	*(char*)vbuf = c;
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	88 02                	mov    %al,(%edx)
	return 1;
  802036:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    
		return 0;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	eb f7                	jmp    80203b <devcons_read+0x32>

00802044 <cputchar>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802050:	6a 01                	push   $0x1
  802052:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802055:	50                   	push   %eax
  802056:	e8 c5 eb ff ff       	call   800c20 <sys_cputs>
}
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <getchar>:
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802066:	6a 01                	push   $0x1
  802068:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80206b:	50                   	push   %eax
  80206c:	6a 00                	push   $0x0
  80206e:	e8 27 f2 ff ff       	call   80129a <read>
	if (r < 0)
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	78 06                	js     802080 <getchar+0x20>
	if (r < 1)
  80207a:	74 06                	je     802082 <getchar+0x22>
	return c;
  80207c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    
		return -E_EOF;
  802082:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802087:	eb f7                	jmp    802080 <getchar+0x20>

00802089 <iscons>:
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802092:	50                   	push   %eax
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	e8 8f ef ff ff       	call   80102a <fd_lookup>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 11                	js     8020b3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ab:	39 10                	cmp    %edx,(%eax)
  8020ad:	0f 94 c0             	sete   %al
  8020b0:	0f b6 c0             	movzbl %al,%eax
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <opencons>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020be:	50                   	push   %eax
  8020bf:	e8 14 ef ff ff       	call   800fd8 <fd_alloc>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 3a                	js     802105 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 07 04 00 00       	push   $0x407
  8020d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d6:	6a 00                	push   $0x0
  8020d8:	e8 ff eb ff ff       	call   800cdc <sys_page_alloc>
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	78 21                	js     802105 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ed:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	50                   	push   %eax
  8020fd:	e8 af ee ff ff       	call   800fb1 <fd2num>
  802102:	83 c4 10             	add    $0x10,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80210c:	a1 08 40 80 00       	mov    0x804008,%eax
  802111:	8b 40 48             	mov    0x48(%eax),%eax
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	68 28 2a 80 00       	push   $0x802a28
  80211c:	50                   	push   %eax
  80211d:	68 f7 29 80 00       	push   $0x8029f7
  802122:	e8 64 e0 ff ff       	call   80018b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802127:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80212a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802130:	e8 69 eb ff ff       	call   800c9e <sys_getenvid>
  802135:	83 c4 04             	add    $0x4,%esp
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	56                   	push   %esi
  80213f:	50                   	push   %eax
  802140:	68 04 2a 80 00       	push   $0x802a04
  802145:	e8 41 e0 ff ff       	call   80018b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80214a:	83 c4 18             	add    $0x18,%esp
  80214d:	53                   	push   %ebx
  80214e:	ff 75 10             	pushl  0x10(%ebp)
  802151:	e8 e4 df ff ff       	call   80013a <vcprintf>
	cprintf("\n");
  802156:	c7 04 24 18 25 80 00 	movl   $0x802518,(%esp)
  80215d:	e8 29 e0 ff ff       	call   80018b <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802165:	cc                   	int3   
  802166:	eb fd                	jmp    802165 <_panic+0x5e>

00802168 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
  80216d:	8b 75 08             	mov    0x8(%ebp),%esi
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802176:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802178:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80217d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	50                   	push   %eax
  802184:	e8 03 ed ff ff       	call   800e8c <sys_ipc_recv>
	if(ret < 0){
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 2b                	js     8021bb <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802190:	85 f6                	test   %esi,%esi
  802192:	74 0a                	je     80219e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802194:	a1 08 40 80 00       	mov    0x804008,%eax
  802199:	8b 40 74             	mov    0x74(%eax),%eax
  80219c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80219e:	85 db                	test   %ebx,%ebx
  8021a0:	74 0a                	je     8021ac <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a7:	8b 40 78             	mov    0x78(%eax),%eax
  8021aa:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    
		if(from_env_store)
  8021bb:	85 f6                	test   %esi,%esi
  8021bd:	74 06                	je     8021c5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021c5:	85 db                	test   %ebx,%ebx
  8021c7:	74 eb                	je     8021b4 <ipc_recv+0x4c>
			*perm_store = 0;
  8021c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021cf:	eb e3                	jmp    8021b4 <ipc_recv+0x4c>

008021d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	57                   	push   %edi
  8021d5:	56                   	push   %esi
  8021d6:	53                   	push   %ebx
  8021d7:	83 ec 0c             	sub    $0xc,%esp
  8021da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021e3:	85 db                	test   %ebx,%ebx
  8021e5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021ea:	0f 44 d8             	cmove  %eax,%ebx
  8021ed:	eb 05                	jmp    8021f4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021ef:	e8 c9 ea ff ff       	call   800cbd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021f4:	ff 75 14             	pushl  0x14(%ebp)
  8021f7:	53                   	push   %ebx
  8021f8:	56                   	push   %esi
  8021f9:	57                   	push   %edi
  8021fa:	e8 6a ec ff ff       	call   800e69 <sys_ipc_try_send>
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	74 1b                	je     802221 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802206:	79 e7                	jns    8021ef <ipc_send+0x1e>
  802208:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80220b:	74 e2                	je     8021ef <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 2f 2a 80 00       	push   $0x802a2f
  802215:	6a 48                	push   $0x48
  802217:	68 44 2a 80 00       	push   $0x802a44
  80221c:	e8 e6 fe ff ff       	call   802107 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    

00802229 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802234:	89 c2                	mov    %eax,%edx
  802236:	c1 e2 07             	shl    $0x7,%edx
  802239:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80223f:	8b 52 50             	mov    0x50(%edx),%edx
  802242:	39 ca                	cmp    %ecx,%edx
  802244:	74 11                	je     802257 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802246:	83 c0 01             	add    $0x1,%eax
  802249:	3d 00 04 00 00       	cmp    $0x400,%eax
  80224e:	75 e4                	jne    802234 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
  802255:	eb 0b                	jmp    802262 <ipc_find_env+0x39>
			return envs[i].env_id;
  802257:	c1 e0 07             	shl    $0x7,%eax
  80225a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80225f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    

00802264 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80226a:	89 d0                	mov    %edx,%eax
  80226c:	c1 e8 16             	shr    $0x16,%eax
  80226f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80227b:	f6 c1 01             	test   $0x1,%cl
  80227e:	74 1d                	je     80229d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802280:	c1 ea 0c             	shr    $0xc,%edx
  802283:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80228a:	f6 c2 01             	test   $0x1,%dl
  80228d:	74 0e                	je     80229d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80228f:	c1 ea 0c             	shr    $0xc,%edx
  802292:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802299:	ef 
  80229a:	0f b7 c0             	movzwl %ax,%eax
}
  80229d:	5d                   	pop    %ebp
  80229e:	c3                   	ret    
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
