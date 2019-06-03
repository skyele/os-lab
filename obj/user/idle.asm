
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 30 80 00 00 	movl   $0x802500,0x803000
  800040:	25 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 85 0c 00 00       	call   800ccd <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	57                   	push   %edi
  80004e:	56                   	push   %esi
  80004f:	53                   	push   %ebx
  800050:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800053:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80005a:	00 00 00 
	envid_t find = sys_getenvid();
  80005d:	e8 4c 0c 00 00       	call   800cae <sys_getenvid>
  800062:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800068:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800072:	bf 01 00 00 00       	mov    $0x1,%edi
  800077:	eb 0b                	jmp    800084 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800079:	83 c2 01             	add    $0x1,%edx
  80007c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800082:	74 21                	je     8000a5 <libmain+0x5b>
		if(envs[i].env_id == find)
  800084:	89 d1                	mov    %edx,%ecx
  800086:	c1 e1 07             	shl    $0x7,%ecx
  800089:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800092:	39 c1                	cmp    %eax,%ecx
  800094:	75 e3                	jne    800079 <libmain+0x2f>
  800096:	89 d3                	mov    %edx,%ebx
  800098:	c1 e3 07             	shl    $0x7,%ebx
  80009b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a1:	89 fe                	mov    %edi,%esi
  8000a3:	eb d4                	jmp    800079 <libmain+0x2f>
  8000a5:	89 f0                	mov    %esi,%eax
  8000a7:	84 c0                	test   %al,%al
  8000a9:	74 06                	je     8000b1 <libmain+0x67>
  8000ab:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b5:	7e 0a                	jle    8000c1 <libmain+0x77>
		binaryname = argv[0];
  8000b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ba:	8b 00                	mov    (%eax),%eax
  8000bc:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 05 25 80 00       	push   $0x802505
  8000c9:	e8 cd 00 00 00       	call   80019b <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ce:	83 c4 08             	add    $0x8,%esp
  8000d1:	ff 75 0c             	pushl  0xc(%ebp)
  8000d4:	ff 75 08             	pushl  0x8(%ebp)
  8000d7:	e8 57 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000dc:	e8 0b 00 00 00       	call   8000ec <exit>
}
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5f                   	pop    %edi
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f2:	e8 a2 10 00 00       	call   801199 <close_all>
	sys_env_destroy(0);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	6a 00                	push   $0x0
  8000fc:	e8 6c 0b 00 00       	call   800c6d <sys_env_destroy>
}
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	53                   	push   %ebx
  80010a:	83 ec 04             	sub    $0x4,%esp
  80010d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800110:	8b 13                	mov    (%ebx),%edx
  800112:	8d 42 01             	lea    0x1(%edx),%eax
  800115:	89 03                	mov    %eax,(%ebx)
  800117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800123:	74 09                	je     80012e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800125:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012c:	c9                   	leave  
  80012d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012e:	83 ec 08             	sub    $0x8,%esp
  800131:	68 ff 00 00 00       	push   $0xff
  800136:	8d 43 08             	lea    0x8(%ebx),%eax
  800139:	50                   	push   %eax
  80013a:	e8 f1 0a 00 00       	call   800c30 <sys_cputs>
		b->idx = 0;
  80013f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb db                	jmp    800125 <putch+0x1f>

0080014a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800153:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015a:	00 00 00 
	b.cnt = 0;
  80015d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800164:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	68 06 01 80 00       	push   $0x800106
  800179:	e8 4a 01 00 00       	call   8002c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800187:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 9d 0a 00 00       	call   800c30 <sys_cputs>

	return b.cnt;
}
  800193:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a4:	50                   	push   %eax
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	e8 9d ff ff ff       	call   80014a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	57                   	push   %edi
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	83 ec 1c             	sub    $0x1c,%esp
  8001b8:	89 c6                	mov    %eax,%esi
  8001ba:	89 d7                	mov    %edx,%edi
  8001bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001ce:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001d2:	74 2c                	je     800200 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e4:	39 c2                	cmp    %eax,%edx
  8001e6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001e9:	73 43                	jae    80022e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001eb:	83 eb 01             	sub    $0x1,%ebx
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7e 6c                	jle    80025e <printnum+0xaf>
				putch(padc, putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	57                   	push   %edi
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	ff d6                	call   *%esi
  8001fb:	83 c4 10             	add    $0x10,%esp
  8001fe:	eb eb                	jmp    8001eb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	6a 20                	push   $0x20
  800205:	6a 00                	push   $0x0
  800207:	50                   	push   %eax
  800208:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020b:	ff 75 e0             	pushl  -0x20(%ebp)
  80020e:	89 fa                	mov    %edi,%edx
  800210:	89 f0                	mov    %esi,%eax
  800212:	e8 98 ff ff ff       	call   8001af <printnum>
		while (--width > 0)
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	83 eb 01             	sub    $0x1,%ebx
  80021d:	85 db                	test   %ebx,%ebx
  80021f:	7e 65                	jle    800286 <printnum+0xd7>
			putch(padc, putdat);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	57                   	push   %edi
  800225:	6a 20                	push   $0x20
  800227:	ff d6                	call   *%esi
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	eb ec                	jmp    80021a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	ff 75 18             	pushl  0x18(%ebp)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	53                   	push   %ebx
  800238:	50                   	push   %eax
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 dc             	pushl  -0x24(%ebp)
  80023f:	ff 75 d8             	pushl  -0x28(%ebp)
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	e8 63 20 00 00       	call   8022b0 <__udivdi3>
  80024d:	83 c4 18             	add    $0x18,%esp
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	89 fa                	mov    %edi,%edx
  800254:	89 f0                	mov    %esi,%eax
  800256:	e8 54 ff ff ff       	call   8001af <printnum>
  80025b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	57                   	push   %edi
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 dc             	pushl  -0x24(%ebp)
  800268:	ff 75 d8             	pushl  -0x28(%ebp)
  80026b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026e:	ff 75 e0             	pushl  -0x20(%ebp)
  800271:	e8 4a 21 00 00       	call   8023c0 <__umoddi3>
  800276:	83 c4 14             	add    $0x14,%esp
  800279:	0f be 80 1c 25 80 00 	movsbl 0x80251c(%eax),%eax
  800280:	50                   	push   %eax
  800281:	ff d6                	call   *%esi
  800283:	83 c4 10             	add    $0x10,%esp
	}
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800294:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800298:	8b 10                	mov    (%eax),%edx
  80029a:	3b 50 04             	cmp    0x4(%eax),%edx
  80029d:	73 0a                	jae    8002a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80029f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a7:	88 02                	mov    %al,(%edx)
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <printfmt>:
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b4:	50                   	push   %eax
  8002b5:	ff 75 10             	pushl  0x10(%ebp)
  8002b8:	ff 75 0c             	pushl  0xc(%ebp)
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 05 00 00 00       	call   8002c8 <vprintfmt>
}
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <vprintfmt>:
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	57                   	push   %edi
  8002cc:	56                   	push   %esi
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 3c             	sub    $0x3c,%esp
  8002d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002da:	e9 32 04 00 00       	jmp    800711 <vprintfmt+0x449>
		padc = ' ';
  8002df:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002ea:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ff:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030b:	8d 47 01             	lea    0x1(%edi),%eax
  80030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800311:	0f b6 17             	movzbl (%edi),%edx
  800314:	8d 42 dd             	lea    -0x23(%edx),%eax
  800317:	3c 55                	cmp    $0x55,%al
  800319:	0f 87 12 05 00 00    	ja     800831 <vprintfmt+0x569>
  80031f:	0f b6 c0             	movzbl %al,%eax
  800322:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800330:	eb d9                	jmp    80030b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800335:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800339:	eb d0                	jmp    80030b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033b:	0f b6 d2             	movzbl %dl,%edx
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	89 75 08             	mov    %esi,0x8(%ebp)
  800349:	eb 03                	jmp    80034e <vprintfmt+0x86>
  80034b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800351:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800355:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800358:	8d 72 d0             	lea    -0x30(%edx),%esi
  80035b:	83 fe 09             	cmp    $0x9,%esi
  80035e:	76 eb                	jbe    80034b <vprintfmt+0x83>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800363:	8b 75 08             	mov    0x8(%ebp),%esi
  800366:	eb 14                	jmp    80037c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8b 00                	mov    (%eax),%eax
  80036d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	8d 40 04             	lea    0x4(%eax),%eax
  800376:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80037c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800380:	79 89                	jns    80030b <vprintfmt+0x43>
				width = precision, precision = -1;
  800382:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800385:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800388:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80038f:	e9 77 ff ff ff       	jmp    80030b <vprintfmt+0x43>
  800394:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	0f 48 c1             	cmovs  %ecx,%eax
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a2:	e9 64 ff ff ff       	jmp    80030b <vprintfmt+0x43>
  8003a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003aa:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003b1:	e9 55 ff ff ff       	jmp    80030b <vprintfmt+0x43>
			lflag++;
  8003b6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bd:	e9 49 ff ff ff       	jmp    80030b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 78 04             	lea    0x4(%eax),%edi
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	53                   	push   %ebx
  8003cc:	ff 30                	pushl  (%eax)
  8003ce:	ff d6                	call   *%esi
			break;
  8003d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d6:	e9 33 03 00 00       	jmp    80070e <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 78 04             	lea    0x4(%eax),%edi
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	99                   	cltd   
  8003e4:	31 d0                	xor    %edx,%eax
  8003e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 10             	cmp    $0x10,%eax
  8003eb:	7f 23                	jg     800410 <vprintfmt+0x148>
  8003ed:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 18                	je     800410 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003f8:	52                   	push   %edx
  8003f9:	68 79 29 80 00       	push   $0x802979
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 a6 fe ff ff       	call   8002ab <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040b:	e9 fe 02 00 00       	jmp    80070e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800410:	50                   	push   %eax
  800411:	68 34 25 80 00       	push   $0x802534
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 8e fe ff ff       	call   8002ab <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800423:	e9 e6 02 00 00       	jmp    80070e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	83 c0 04             	add    $0x4,%eax
  80042e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800436:	85 c9                	test   %ecx,%ecx
  800438:	b8 2d 25 80 00       	mov    $0x80252d,%eax
  80043d:	0f 45 c1             	cmovne %ecx,%eax
  800440:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800443:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800447:	7e 06                	jle    80044f <vprintfmt+0x187>
  800449:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80044d:	75 0d                	jne    80045c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800452:	89 c7                	mov    %eax,%edi
  800454:	03 45 e0             	add    -0x20(%ebp),%eax
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	eb 53                	jmp    8004af <vprintfmt+0x1e7>
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	ff 75 d8             	pushl  -0x28(%ebp)
  800462:	50                   	push   %eax
  800463:	e8 71 04 00 00       	call   8008d9 <strnlen>
  800468:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046b:	29 c1                	sub    %eax,%ecx
  80046d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800475:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800479:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047c:	eb 0f                	jmp    80048d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	83 ef 01             	sub    $0x1,%edi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	85 ff                	test   %edi,%edi
  80048f:	7f ed                	jg     80047e <vprintfmt+0x1b6>
  800491:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800494:	85 c9                	test   %ecx,%ecx
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	0f 49 c1             	cmovns %ecx,%eax
  80049e:	29 c1                	sub    %eax,%ecx
  8004a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a3:	eb aa                	jmp    80044f <vprintfmt+0x187>
					putch(ch, putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	53                   	push   %ebx
  8004a9:	52                   	push   %edx
  8004aa:	ff d6                	call   *%esi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b4:	83 c7 01             	add    $0x1,%edi
  8004b7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004bb:	0f be d0             	movsbl %al,%edx
  8004be:	85 d2                	test   %edx,%edx
  8004c0:	74 4b                	je     80050d <vprintfmt+0x245>
  8004c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c6:	78 06                	js     8004ce <vprintfmt+0x206>
  8004c8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cc:	78 1e                	js     8004ec <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d2:	74 d1                	je     8004a5 <vprintfmt+0x1dd>
  8004d4:	0f be c0             	movsbl %al,%eax
  8004d7:	83 e8 20             	sub    $0x20,%eax
  8004da:	83 f8 5e             	cmp    $0x5e,%eax
  8004dd:	76 c6                	jbe    8004a5 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	53                   	push   %ebx
  8004e3:	6a 3f                	push   $0x3f
  8004e5:	ff d6                	call   *%esi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	eb c3                	jmp    8004af <vprintfmt+0x1e7>
  8004ec:	89 cf                	mov    %ecx,%edi
  8004ee:	eb 0e                	jmp    8004fe <vprintfmt+0x236>
				putch(' ', putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	53                   	push   %ebx
  8004f4:	6a 20                	push   $0x20
  8004f6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f8:	83 ef 01             	sub    $0x1,%edi
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7f ee                	jg     8004f0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800502:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
  800508:	e9 01 02 00 00       	jmp    80070e <vprintfmt+0x446>
  80050d:	89 cf                	mov    %ecx,%edi
  80050f:	eb ed                	jmp    8004fe <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800511:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800514:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80051b:	e9 eb fd ff ff       	jmp    80030b <vprintfmt+0x43>
	if (lflag >= 2)
  800520:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800524:	7f 21                	jg     800547 <vprintfmt+0x27f>
	else if (lflag)
  800526:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80052a:	74 68                	je     800594 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800534:	89 c1                	mov    %eax,%ecx
  800536:	c1 f9 1f             	sar    $0x1f,%ecx
  800539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 40 04             	lea    0x4(%eax),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	eb 17                	jmp    80055e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8b 50 04             	mov    0x4(%eax),%edx
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800552:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 40 08             	lea    0x8(%eax),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80055e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800561:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800564:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800567:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80056a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056e:	78 3f                	js     8005af <vprintfmt+0x2e7>
			base = 10;
  800570:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800575:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800579:	0f 84 71 01 00 00    	je     8006f0 <vprintfmt+0x428>
				putch('+', putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	53                   	push   %ebx
  800583:	6a 2b                	push   $0x2b
  800585:	ff d6                	call   *%esi
  800587:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058f:	e9 5c 01 00 00       	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059c:	89 c1                	mov    %eax,%ecx
  80059e:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	eb af                	jmp    80055e <vprintfmt+0x296>
				putch('-', putdat);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	53                   	push   %ebx
  8005b3:	6a 2d                	push   $0x2d
  8005b5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bd:	f7 d8                	neg    %eax
  8005bf:	83 d2 00             	adc    $0x0,%edx
  8005c2:	f7 da                	neg    %edx
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	e9 19 01 00 00       	jmp    8006f0 <vprintfmt+0x428>
	if (lflag >= 2)
  8005d7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005db:	7f 29                	jg     800606 <vprintfmt+0x33e>
	else if (lflag)
  8005dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e1:	74 44                	je     800627 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8d 40 04             	lea    0x4(%eax),%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800601:	e9 ea 00 00 00       	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 50 04             	mov    0x4(%eax),%edx
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800611:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 40 08             	lea    0x8(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800622:	e9 c9 00 00 00       	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	ba 00 00 00 00       	mov    $0x0,%edx
  800631:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800634:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800640:	b8 0a 00 00 00       	mov    $0xa,%eax
  800645:	e9 a6 00 00 00       	jmp    8006f0 <vprintfmt+0x428>
			putch('0', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 30                	push   $0x30
  800650:	ff d6                	call   *%esi
	if (lflag >= 2)
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800659:	7f 26                	jg     800681 <vprintfmt+0x3b9>
	else if (lflag)
  80065b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065f:	74 3e                	je     80069f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	ba 00 00 00 00       	mov    $0x0,%edx
  80066b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067a:	b8 08 00 00 00       	mov    $0x8,%eax
  80067f:	eb 6f                	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 50 04             	mov    0x4(%eax),%edx
  800687:	8b 00                	mov    (%eax),%eax
  800689:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 40 08             	lea    0x8(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800698:	b8 08 00 00 00       	mov    $0x8,%eax
  80069d:	eb 51                	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bd:	eb 31                	jmp    8006f0 <vprintfmt+0x428>
			putch('0', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 30                	push   $0x30
  8006c5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c7:	83 c4 08             	add    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 78                	push   $0x78
  8006cd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006df:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006eb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f7:	52                   	push   %edx
  8006f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	89 da                	mov    %ebx,%edx
  800704:	89 f0                	mov    %esi,%eax
  800706:	e8 a4 fa ff ff       	call   8001af <printnum>
			break;
  80070b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80070e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800711:	83 c7 01             	add    $0x1,%edi
  800714:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800718:	83 f8 25             	cmp    $0x25,%eax
  80071b:	0f 84 be fb ff ff    	je     8002df <vprintfmt+0x17>
			if (ch == '\0')
  800721:	85 c0                	test   %eax,%eax
  800723:	0f 84 28 01 00 00    	je     800851 <vprintfmt+0x589>
			putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	50                   	push   %eax
  80072e:	ff d6                	call   *%esi
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	eb dc                	jmp    800711 <vprintfmt+0x449>
	if (lflag >= 2)
  800735:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800739:	7f 26                	jg     800761 <vprintfmt+0x499>
	else if (lflag)
  80073b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073f:	74 41                	je     800782 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075a:	b8 10 00 00 00       	mov    $0x10,%eax
  80075f:	eb 8f                	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 40 08             	lea    0x8(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800778:	b8 10 00 00 00       	mov    $0x10,%eax
  80077d:	e9 6e ff ff ff       	jmp    8006f0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
  80078c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 40 04             	lea    0x4(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079b:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a0:	e9 4b ff ff ff       	jmp    8006f0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	83 c0 04             	add    $0x4,%eax
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	85 c0                	test   %eax,%eax
  8007b5:	74 14                	je     8007cb <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b7:	8b 13                	mov    (%ebx),%edx
  8007b9:	83 fa 7f             	cmp    $0x7f,%edx
  8007bc:	7f 37                	jg     8007f5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007be:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c6:	e9 43 ff ff ff       	jmp    80070e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d0:	bf 51 26 80 00       	mov    $0x802651,%edi
							putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	50                   	push   %eax
  8007da:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007dc:	83 c7 01             	add    $0x1,%edi
  8007df:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	75 eb                	jne    8007d5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f0:	e9 19 ff ff ff       	jmp    80070e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fc:	bf 89 26 80 00       	mov    $0x802689,%edi
							putch(ch, putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	50                   	push   %eax
  800806:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800808:	83 c7 01             	add    $0x1,%edi
  80080b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	85 c0                	test   %eax,%eax
  800814:	75 eb                	jne    800801 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	e9 ed fe ff ff       	jmp    80070e <vprintfmt+0x446>
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	6a 25                	push   $0x25
  800827:	ff d6                	call   *%esi
			break;
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	e9 dd fe ff ff       	jmp    80070e <vprintfmt+0x446>
			putch('%', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 25                	push   $0x25
  800837:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	89 f8                	mov    %edi,%eax
  80083e:	eb 03                	jmp    800843 <vprintfmt+0x57b>
  800840:	83 e8 01             	sub    $0x1,%eax
  800843:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800847:	75 f7                	jne    800840 <vprintfmt+0x578>
  800849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084c:	e9 bd fe ff ff       	jmp    80070e <vprintfmt+0x446>
}
  800851:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5f                   	pop    %edi
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	83 ec 18             	sub    $0x18,%esp
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800865:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800868:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800876:	85 c0                	test   %eax,%eax
  800878:	74 26                	je     8008a0 <vsnprintf+0x47>
  80087a:	85 d2                	test   %edx,%edx
  80087c:	7e 22                	jle    8008a0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087e:	ff 75 14             	pushl  0x14(%ebp)
  800881:	ff 75 10             	pushl  0x10(%ebp)
  800884:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	68 8e 02 80 00       	push   $0x80028e
  80088d:	e8 36 fa ff ff       	call   8002c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089b:	83 c4 10             	add    $0x10,%esp
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    
		return -E_INVAL;
  8008a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a5:	eb f7                	jmp    80089e <vsnprintf+0x45>

008008a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ad:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 10             	pushl  0x10(%ebp)
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	ff 75 08             	pushl  0x8(%ebp)
  8008ba:	e8 9a ff ff ff       	call   800859 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d0:	74 05                	je     8008d7 <strlen+0x16>
		n++;
  8008d2:	83 c0 01             	add    $0x1,%eax
  8008d5:	eb f5                	jmp    8008cc <strlen+0xb>
	return n;
}
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	74 0d                	je     8008f8 <strnlen+0x1f>
  8008eb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ef:	74 05                	je     8008f6 <strnlen+0x1d>
		n++;
  8008f1:	83 c2 01             	add    $0x1,%edx
  8008f4:	eb f1                	jmp    8008e7 <strnlen+0xe>
  8008f6:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800904:	ba 00 00 00 00       	mov    $0x0,%edx
  800909:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800910:	83 c2 01             	add    $0x1,%edx
  800913:	84 c9                	test   %cl,%cl
  800915:	75 f2                	jne    800909 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800917:	5b                   	pop    %ebx
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	83 ec 10             	sub    $0x10,%esp
  800921:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800924:	53                   	push   %ebx
  800925:	e8 97 ff ff ff       	call   8008c1 <strlen>
  80092a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	01 d8                	add    %ebx,%eax
  800932:	50                   	push   %eax
  800933:	e8 c2 ff ff ff       	call   8008fa <strcpy>
	return dst;
}
  800938:	89 d8                	mov    %ebx,%eax
  80093a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    

0080093f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094a:	89 c6                	mov    %eax,%esi
  80094c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094f:	89 c2                	mov    %eax,%edx
  800951:	39 f2                	cmp    %esi,%edx
  800953:	74 11                	je     800966 <strncpy+0x27>
		*dst++ = *src;
  800955:	83 c2 01             	add    $0x1,%edx
  800958:	0f b6 19             	movzbl (%ecx),%ebx
  80095b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095e:	80 fb 01             	cmp    $0x1,%bl
  800961:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800964:	eb eb                	jmp    800951 <strncpy+0x12>
	}
	return ret;
}
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
  80096f:	8b 75 08             	mov    0x8(%ebp),%esi
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800975:	8b 55 10             	mov    0x10(%ebp),%edx
  800978:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097a:	85 d2                	test   %edx,%edx
  80097c:	74 21                	je     80099f <strlcpy+0x35>
  80097e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800982:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <strlcpy+0x32>
  800988:	0f b6 19             	movzbl (%ecx),%ebx
  80098b:	84 db                	test   %bl,%bl
  80098d:	74 0b                	je     80099a <strlcpy+0x30>
			*dst++ = *src++;
  80098f:	83 c1 01             	add    $0x1,%ecx
  800992:	83 c2 01             	add    $0x1,%edx
  800995:	88 5a ff             	mov    %bl,-0x1(%edx)
  800998:	eb ea                	jmp    800984 <strlcpy+0x1a>
  80099a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80099c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099f:	29 f0                	sub    %esi,%eax
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 0c                	je     8009c1 <strcmp+0x1c>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	75 08                	jne    8009c1 <strcmp+0x1c>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb ed                	jmp    8009ae <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	0f b6 12             	movzbl (%edx),%edx
  8009c7:	29 d0                	sub    %edx,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	89 c3                	mov    %eax,%ebx
  8009d7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009da:	eb 06                	jmp    8009e2 <strncmp+0x17>
		n--, p++, q++;
  8009dc:	83 c0 01             	add    $0x1,%eax
  8009df:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e2:	39 d8                	cmp    %ebx,%eax
  8009e4:	74 16                	je     8009fc <strncmp+0x31>
  8009e6:	0f b6 08             	movzbl (%eax),%ecx
  8009e9:	84 c9                	test   %cl,%cl
  8009eb:	74 04                	je     8009f1 <strncmp+0x26>
  8009ed:	3a 0a                	cmp    (%edx),%cl
  8009ef:	74 eb                	je     8009dc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f1:	0f b6 00             	movzbl (%eax),%eax
  8009f4:	0f b6 12             	movzbl (%edx),%edx
  8009f7:	29 d0                	sub    %edx,%eax
}
  8009f9:	5b                   	pop    %ebx
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    
		return 0;
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	eb f6                	jmp    8009f9 <strncmp+0x2e>

00800a03 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	74 09                	je     800a1d <strchr+0x1a>
		if (*s == c)
  800a14:	38 ca                	cmp    %cl,%dl
  800a16:	74 0a                	je     800a22 <strchr+0x1f>
	for (; *s; s++)
  800a18:	83 c0 01             	add    $0x1,%eax
  800a1b:	eb f0                	jmp    800a0d <strchr+0xa>
			return (char *) s;
	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a31:	38 ca                	cmp    %cl,%dl
  800a33:	74 09                	je     800a3e <strfind+0x1a>
  800a35:	84 d2                	test   %dl,%dl
  800a37:	74 05                	je     800a3e <strfind+0x1a>
	for (; *s; s++)
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	eb f0                	jmp    800a2e <strfind+0xa>
			break;
	return (char *) s;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a4c:	85 c9                	test   %ecx,%ecx
  800a4e:	74 31                	je     800a81 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a50:	89 f8                	mov    %edi,%eax
  800a52:	09 c8                	or     %ecx,%eax
  800a54:	a8 03                	test   $0x3,%al
  800a56:	75 23                	jne    800a7b <memset+0x3b>
		c &= 0xFF;
  800a58:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5c:	89 d3                	mov    %edx,%ebx
  800a5e:	c1 e3 08             	shl    $0x8,%ebx
  800a61:	89 d0                	mov    %edx,%eax
  800a63:	c1 e0 18             	shl    $0x18,%eax
  800a66:	89 d6                	mov    %edx,%esi
  800a68:	c1 e6 10             	shl    $0x10,%esi
  800a6b:	09 f0                	or     %esi,%eax
  800a6d:	09 c2                	or     %eax,%edx
  800a6f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a71:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a74:	89 d0                	mov    %edx,%eax
  800a76:	fc                   	cld    
  800a77:	f3 ab                	rep stos %eax,%es:(%edi)
  800a79:	eb 06                	jmp    800a81 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	fc                   	cld    
  800a7f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a81:	89 f8                	mov    %edi,%eax
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	57                   	push   %edi
  800a8c:	56                   	push   %esi
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a96:	39 c6                	cmp    %eax,%esi
  800a98:	73 32                	jae    800acc <memmove+0x44>
  800a9a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9d:	39 c2                	cmp    %eax,%edx
  800a9f:	76 2b                	jbe    800acc <memmove+0x44>
		s += n;
		d += n;
  800aa1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	89 fe                	mov    %edi,%esi
  800aa6:	09 ce                	or     %ecx,%esi
  800aa8:	09 d6                	or     %edx,%esi
  800aaa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ab0:	75 0e                	jne    800ac0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab2:	83 ef 04             	sub    $0x4,%edi
  800ab5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800abb:	fd                   	std    
  800abc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abe:	eb 09                	jmp    800ac9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac0:	83 ef 01             	sub    $0x1,%edi
  800ac3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac6:	fd                   	std    
  800ac7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac9:	fc                   	cld    
  800aca:	eb 1a                	jmp    800ae6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acc:	89 c2                	mov    %eax,%edx
  800ace:	09 ca                	or     %ecx,%edx
  800ad0:	09 f2                	or     %esi,%edx
  800ad2:	f6 c2 03             	test   $0x3,%dl
  800ad5:	75 0a                	jne    800ae1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ada:	89 c7                	mov    %eax,%edi
  800adc:	fc                   	cld    
  800add:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800adf:	eb 05                	jmp    800ae6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ae1:	89 c7                	mov    %eax,%edi
  800ae3:	fc                   	cld    
  800ae4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae6:	5e                   	pop    %esi
  800ae7:	5f                   	pop    %edi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af0:	ff 75 10             	pushl  0x10(%ebp)
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 8a ff ff ff       	call   800a88 <memmove>
}
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0b:	89 c6                	mov    %eax,%esi
  800b0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b10:	39 f0                	cmp    %esi,%eax
  800b12:	74 1c                	je     800b30 <memcmp+0x30>
		if (*s1 != *s2)
  800b14:	0f b6 08             	movzbl (%eax),%ecx
  800b17:	0f b6 1a             	movzbl (%edx),%ebx
  800b1a:	38 d9                	cmp    %bl,%cl
  800b1c:	75 08                	jne    800b26 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	83 c2 01             	add    $0x1,%edx
  800b24:	eb ea                	jmp    800b10 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b26:	0f b6 c1             	movzbl %cl,%eax
  800b29:	0f b6 db             	movzbl %bl,%ebx
  800b2c:	29 d8                	sub    %ebx,%eax
  800b2e:	eb 05                	jmp    800b35 <memcmp+0x35>
	}

	return 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b47:	39 d0                	cmp    %edx,%eax
  800b49:	73 09                	jae    800b54 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4b:	38 08                	cmp    %cl,(%eax)
  800b4d:	74 05                	je     800b54 <memfind+0x1b>
	for (; s < ends; s++)
  800b4f:	83 c0 01             	add    $0x1,%eax
  800b52:	eb f3                	jmp    800b47 <memfind+0xe>
			break;
	return (void *) s;
}
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b62:	eb 03                	jmp    800b67 <strtol+0x11>
		s++;
  800b64:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b67:	0f b6 01             	movzbl (%ecx),%eax
  800b6a:	3c 20                	cmp    $0x20,%al
  800b6c:	74 f6                	je     800b64 <strtol+0xe>
  800b6e:	3c 09                	cmp    $0x9,%al
  800b70:	74 f2                	je     800b64 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b72:	3c 2b                	cmp    $0x2b,%al
  800b74:	74 2a                	je     800ba0 <strtol+0x4a>
	int neg = 0;
  800b76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7b:	3c 2d                	cmp    $0x2d,%al
  800b7d:	74 2b                	je     800baa <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b85:	75 0f                	jne    800b96 <strtol+0x40>
  800b87:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8a:	74 28                	je     800bb4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8c:	85 db                	test   %ebx,%ebx
  800b8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b93:	0f 44 d8             	cmove  %eax,%ebx
  800b96:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9e:	eb 50                	jmp    800bf0 <strtol+0x9a>
		s++;
  800ba0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba8:	eb d5                	jmp    800b7f <strtol+0x29>
		s++, neg = 1;
  800baa:	83 c1 01             	add    $0x1,%ecx
  800bad:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb2:	eb cb                	jmp    800b7f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb8:	74 0e                	je     800bc8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bba:	85 db                	test   %ebx,%ebx
  800bbc:	75 d8                	jne    800b96 <strtol+0x40>
		s++, base = 8;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc6:	eb ce                	jmp    800b96 <strtol+0x40>
		s += 2, base = 16;
  800bc8:	83 c1 02             	add    $0x2,%ecx
  800bcb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd0:	eb c4                	jmp    800b96 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd5:	89 f3                	mov    %esi,%ebx
  800bd7:	80 fb 19             	cmp    $0x19,%bl
  800bda:	77 29                	ja     800c05 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bdc:	0f be d2             	movsbl %dl,%edx
  800bdf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be5:	7d 30                	jge    800c17 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be7:	83 c1 01             	add    $0x1,%ecx
  800bea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf0:	0f b6 11             	movzbl (%ecx),%edx
  800bf3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf6:	89 f3                	mov    %esi,%ebx
  800bf8:	80 fb 09             	cmp    $0x9,%bl
  800bfb:	77 d5                	ja     800bd2 <strtol+0x7c>
			dig = *s - '0';
  800bfd:	0f be d2             	movsbl %dl,%edx
  800c00:	83 ea 30             	sub    $0x30,%edx
  800c03:	eb dd                	jmp    800be2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c05:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c08:	89 f3                	mov    %esi,%ebx
  800c0a:	80 fb 19             	cmp    $0x19,%bl
  800c0d:	77 08                	ja     800c17 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0f:	0f be d2             	movsbl %dl,%edx
  800c12:	83 ea 37             	sub    $0x37,%edx
  800c15:	eb cb                	jmp    800be2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1b:	74 05                	je     800c22 <strtol+0xcc>
		*endptr = (char *) s;
  800c1d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c20:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c22:	89 c2                	mov    %eax,%edx
  800c24:	f7 da                	neg    %edx
  800c26:	85 ff                	test   %edi,%edi
  800c28:	0f 45 c2             	cmovne %edx,%eax
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	57                   	push   %edi
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c41:	89 c3                	mov    %eax,%ebx
  800c43:	89 c7                	mov    %eax,%edi
  800c45:	89 c6                	mov    %eax,%esi
  800c47:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5f                   	pop    %edi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5e:	89 d1                	mov    %edx,%ecx
  800c60:	89 d3                	mov    %edx,%ebx
  800c62:	89 d7                	mov    %edx,%edi
  800c64:	89 d6                	mov    %edx,%esi
  800c66:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	89 cb                	mov    %ecx,%ebx
  800c85:	89 cf                	mov    %ecx,%edi
  800c87:	89 ce                	mov    %ecx,%esi
  800c89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8b:	85 c0                	test   %eax,%eax
  800c8d:	7f 08                	jg     800c97 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c97:	83 ec 0c             	sub    $0xc,%esp
  800c9a:	50                   	push   %eax
  800c9b:	6a 03                	push   $0x3
  800c9d:	68 a4 28 80 00       	push   $0x8028a4
  800ca2:	6a 43                	push   $0x43
  800ca4:	68 c1 28 80 00       	push   $0x8028c1
  800ca9:	e8 69 14 00 00       	call   802117 <_panic>

00800cae <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	57                   	push   %edi
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbe:	89 d1                	mov    %edx,%ecx
  800cc0:	89 d3                	mov    %edx,%ebx
  800cc2:	89 d7                	mov    %edx,%edi
  800cc4:	89 d6                	mov    %edx,%esi
  800cc6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <sys_yield>:

void
sys_yield(void)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdd:	89 d1                	mov    %edx,%ecx
  800cdf:	89 d3                	mov    %edx,%ebx
  800ce1:	89 d7                	mov    %edx,%edi
  800ce3:	89 d6                	mov    %edx,%esi
  800ce5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	be 00 00 00 00       	mov    $0x0,%esi
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 04 00 00 00       	mov    $0x4,%eax
  800d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d08:	89 f7                	mov    %esi,%edi
  800d0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7f 08                	jg     800d18 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	50                   	push   %eax
  800d1c:	6a 04                	push   $0x4
  800d1e:	68 a4 28 80 00       	push   $0x8028a4
  800d23:	6a 43                	push   $0x43
  800d25:	68 c1 28 80 00       	push   $0x8028c1
  800d2a:	e8 e8 13 00 00       	call   802117 <_panic>

00800d2f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d46:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d49:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 05                	push   $0x5
  800d60:	68 a4 28 80 00       	push   $0x8028a4
  800d65:	6a 43                	push   $0x43
  800d67:	68 c1 28 80 00       	push   $0x8028c1
  800d6c:	e8 a6 13 00 00       	call   802117 <_panic>

00800d71 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8a:	89 df                	mov    %ebx,%edi
  800d8c:	89 de                	mov    %ebx,%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 06                	push   $0x6
  800da2:	68 a4 28 80 00       	push   $0x8028a4
  800da7:	6a 43                	push   $0x43
  800da9:	68 c1 28 80 00       	push   $0x8028c1
  800dae:	e8 64 13 00 00       	call   802117 <_panic>

00800db3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 08 00 00 00       	mov    $0x8,%eax
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 08                	push   $0x8
  800de4:	68 a4 28 80 00       	push   $0x8028a4
  800de9:	6a 43                	push   $0x43
  800deb:	68 c1 28 80 00       	push   $0x8028c1
  800df0:	e8 22 13 00 00       	call   802117 <_panic>

00800df5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 09                	push   $0x9
  800e26:	68 a4 28 80 00       	push   $0x8028a4
  800e2b:	6a 43                	push   $0x43
  800e2d:	68 c1 28 80 00       	push   $0x8028c1
  800e32:	e8 e0 12 00 00       	call   802117 <_panic>

00800e37 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	89 de                	mov    %ebx,%esi
  800e54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 0a                	push   $0xa
  800e68:	68 a4 28 80 00       	push   $0x8028a4
  800e6d:	6a 43                	push   $0x43
  800e6f:	68 c1 28 80 00       	push   $0x8028c1
  800e74:	e8 9e 12 00 00       	call   802117 <_panic>

00800e79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
  800e8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e95:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb2:	89 cb                	mov    %ecx,%ebx
  800eb4:	89 cf                	mov    %ecx,%edi
  800eb6:	89 ce                	mov    %ecx,%esi
  800eb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	7f 08                	jg     800ec6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	83 ec 0c             	sub    $0xc,%esp
  800ec9:	50                   	push   %eax
  800eca:	6a 0d                	push   $0xd
  800ecc:	68 a4 28 80 00       	push   $0x8028a4
  800ed1:	6a 43                	push   $0x43
  800ed3:	68 c1 28 80 00       	push   $0x8028c1
  800ed8:	e8 3a 12 00 00       	call   802117 <_panic>

00800edd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f11:	89 cb                	mov    %ecx,%ebx
  800f13:	89 cf                	mov    %ecx,%edi
  800f15:	89 ce                	mov    %ecx,%esi
  800f17:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
  800f29:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2e:	89 d1                	mov    %edx,%ecx
  800f30:	89 d3                	mov    %edx,%ebx
  800f32:	89 d7                	mov    %edx,%edi
  800f34:	89 d6                	mov    %edx,%esi
  800f36:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 11 00 00 00       	mov    $0x11,%eax
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	b8 12 00 00 00       	mov    $0x12,%eax
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	b8 13 00 00 00       	mov    $0x13,%eax
  800f98:	89 df                	mov    %ebx,%edi
  800f9a:	89 de                	mov    %ebx,%esi
  800f9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	7f 08                	jg     800faa <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	50                   	push   %eax
  800fae:	6a 13                	push   $0x13
  800fb0:	68 a4 28 80 00       	push   $0x8028a4
  800fb5:	6a 43                	push   $0x43
  800fb7:	68 c1 28 80 00       	push   $0x8028c1
  800fbc:	e8 56 11 00 00       	call   802117 <_panic>

00800fc1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	05 00 00 00 30       	add    $0x30000000,%eax
  800fcc:	c1 e8 0c             	shr    $0xc,%eax
}
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	c1 ea 16             	shr    $0x16,%edx
  800ff5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ffc:	f6 c2 01             	test   $0x1,%dl
  800fff:	74 2d                	je     80102e <fd_alloc+0x46>
  801001:	89 c2                	mov    %eax,%edx
  801003:	c1 ea 0c             	shr    $0xc,%edx
  801006:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100d:	f6 c2 01             	test   $0x1,%dl
  801010:	74 1c                	je     80102e <fd_alloc+0x46>
  801012:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801017:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80101c:	75 d2                	jne    800ff0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801027:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80102c:	eb 0a                	jmp    801038 <fd_alloc+0x50>
			*fd_store = fd;
  80102e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801031:	89 01                	mov    %eax,(%ecx)
			return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801040:	83 f8 1f             	cmp    $0x1f,%eax
  801043:	77 30                	ja     801075 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801045:	c1 e0 0c             	shl    $0xc,%eax
  801048:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801053:	f6 c2 01             	test   $0x1,%dl
  801056:	74 24                	je     80107c <fd_lookup+0x42>
  801058:	89 c2                	mov    %eax,%edx
  80105a:	c1 ea 0c             	shr    $0xc,%edx
  80105d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801064:	f6 c2 01             	test   $0x1,%dl
  801067:	74 1a                	je     801083 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106c:	89 02                	mov    %eax,(%edx)
	return 0;
  80106e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    
		return -E_INVAL;
  801075:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107a:	eb f7                	jmp    801073 <fd_lookup+0x39>
		return -E_INVAL;
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801081:	eb f0                	jmp    801073 <fd_lookup+0x39>
  801083:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801088:	eb e9                	jmp    801073 <fd_lookup+0x39>

0080108a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801093:	ba 00 00 00 00       	mov    $0x0,%edx
  801098:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80109d:	39 08                	cmp    %ecx,(%eax)
  80109f:	74 38                	je     8010d9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010a1:	83 c2 01             	add    $0x1,%edx
  8010a4:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	75 ee                	jne    80109d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010af:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b4:	8b 40 48             	mov    0x48(%eax),%eax
  8010b7:	83 ec 04             	sub    $0x4,%esp
  8010ba:	51                   	push   %ecx
  8010bb:	50                   	push   %eax
  8010bc:	68 d0 28 80 00       	push   $0x8028d0
  8010c1:	e8 d5 f0 ff ff       	call   80019b <cprintf>
	*dev = 0;
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    
			*dev = devtab[i];
  8010d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e3:	eb f2                	jmp    8010d7 <dev_lookup+0x4d>

008010e5 <fd_close>:
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	57                   	push   %edi
  8010e9:	56                   	push   %esi
  8010ea:	53                   	push   %ebx
  8010eb:	83 ec 24             	sub    $0x24,%esp
  8010ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010fe:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801101:	50                   	push   %eax
  801102:	e8 33 ff ff ff       	call   80103a <fd_lookup>
  801107:	89 c3                	mov    %eax,%ebx
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	78 05                	js     801115 <fd_close+0x30>
	    || fd != fd2)
  801110:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801113:	74 16                	je     80112b <fd_close+0x46>
		return (must_exist ? r : 0);
  801115:	89 f8                	mov    %edi,%eax
  801117:	84 c0                	test   %al,%al
  801119:	b8 00 00 00 00       	mov    $0x0,%eax
  80111e:	0f 44 d8             	cmove  %eax,%ebx
}
  801121:	89 d8                	mov    %ebx,%eax
  801123:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801126:	5b                   	pop    %ebx
  801127:	5e                   	pop    %esi
  801128:	5f                   	pop    %edi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801131:	50                   	push   %eax
  801132:	ff 36                	pushl  (%esi)
  801134:	e8 51 ff ff ff       	call   80108a <dev_lookup>
  801139:	89 c3                	mov    %eax,%ebx
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 1a                	js     80115c <fd_close+0x77>
		if (dev->dev_close)
  801142:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801145:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801148:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	74 0b                	je     80115c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	56                   	push   %esi
  801155:	ff d0                	call   *%eax
  801157:	89 c3                	mov    %eax,%ebx
  801159:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	56                   	push   %esi
  801160:	6a 00                	push   $0x0
  801162:	e8 0a fc ff ff       	call   800d71 <sys_page_unmap>
	return r;
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	eb b5                	jmp    801121 <fd_close+0x3c>

0080116c <close>:

int
close(int fdnum)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801172:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801175:	50                   	push   %eax
  801176:	ff 75 08             	pushl  0x8(%ebp)
  801179:	e8 bc fe ff ff       	call   80103a <fd_lookup>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	79 02                	jns    801187 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    
		return fd_close(fd, 1);
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	6a 01                	push   $0x1
  80118c:	ff 75 f4             	pushl  -0xc(%ebp)
  80118f:	e8 51 ff ff ff       	call   8010e5 <fd_close>
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	eb ec                	jmp    801185 <close+0x19>

00801199 <close_all>:

void
close_all(void)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	53                   	push   %ebx
  80119d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	53                   	push   %ebx
  8011a9:	e8 be ff ff ff       	call   80116c <close>
	for (i = 0; i < MAXFD; i++)
  8011ae:	83 c3 01             	add    $0x1,%ebx
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	83 fb 20             	cmp    $0x20,%ebx
  8011b7:	75 ec                	jne    8011a5 <close_all+0xc>
}
  8011b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	57                   	push   %edi
  8011c2:	56                   	push   %esi
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ca:	50                   	push   %eax
  8011cb:	ff 75 08             	pushl  0x8(%ebp)
  8011ce:	e8 67 fe ff ff       	call   80103a <fd_lookup>
  8011d3:	89 c3                	mov    %eax,%ebx
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	0f 88 81 00 00 00    	js     801261 <dup+0xa3>
		return r;
	close(newfdnum);
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	ff 75 0c             	pushl  0xc(%ebp)
  8011e6:	e8 81 ff ff ff       	call   80116c <close>

	newfd = INDEX2FD(newfdnum);
  8011eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ee:	c1 e6 0c             	shl    $0xc,%esi
  8011f1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011fd:	e8 cf fd ff ff       	call   800fd1 <fd2data>
  801202:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801204:	89 34 24             	mov    %esi,(%esp)
  801207:	e8 c5 fd ff ff       	call   800fd1 <fd2data>
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801211:	89 d8                	mov    %ebx,%eax
  801213:	c1 e8 16             	shr    $0x16,%eax
  801216:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121d:	a8 01                	test   $0x1,%al
  80121f:	74 11                	je     801232 <dup+0x74>
  801221:	89 d8                	mov    %ebx,%eax
  801223:	c1 e8 0c             	shr    $0xc,%eax
  801226:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80122d:	f6 c2 01             	test   $0x1,%dl
  801230:	75 39                	jne    80126b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801235:	89 d0                	mov    %edx,%eax
  801237:	c1 e8 0c             	shr    $0xc,%eax
  80123a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	25 07 0e 00 00       	and    $0xe07,%eax
  801249:	50                   	push   %eax
  80124a:	56                   	push   %esi
  80124b:	6a 00                	push   $0x0
  80124d:	52                   	push   %edx
  80124e:	6a 00                	push   $0x0
  801250:	e8 da fa ff ff       	call   800d2f <sys_page_map>
  801255:	89 c3                	mov    %eax,%ebx
  801257:	83 c4 20             	add    $0x20,%esp
  80125a:	85 c0                	test   %eax,%eax
  80125c:	78 31                	js     80128f <dup+0xd1>
		goto err;

	return newfdnum;
  80125e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801261:	89 d8                	mov    %ebx,%eax
  801263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80126b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	25 07 0e 00 00       	and    $0xe07,%eax
  80127a:	50                   	push   %eax
  80127b:	57                   	push   %edi
  80127c:	6a 00                	push   $0x0
  80127e:	53                   	push   %ebx
  80127f:	6a 00                	push   $0x0
  801281:	e8 a9 fa ff ff       	call   800d2f <sys_page_map>
  801286:	89 c3                	mov    %eax,%ebx
  801288:	83 c4 20             	add    $0x20,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	79 a3                	jns    801232 <dup+0x74>
	sys_page_unmap(0, newfd);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	56                   	push   %esi
  801293:	6a 00                	push   $0x0
  801295:	e8 d7 fa ff ff       	call   800d71 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80129a:	83 c4 08             	add    $0x8,%esp
  80129d:	57                   	push   %edi
  80129e:	6a 00                	push   $0x0
  8012a0:	e8 cc fa ff ff       	call   800d71 <sys_page_unmap>
	return r;
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	eb b7                	jmp    801261 <dup+0xa3>

008012aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 1c             	sub    $0x1c,%esp
  8012b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	53                   	push   %ebx
  8012b9:	e8 7c fd ff ff       	call   80103a <fd_lookup>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 3f                	js     801304 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cb:	50                   	push   %eax
  8012cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cf:	ff 30                	pushl  (%eax)
  8012d1:	e8 b4 fd ff ff       	call   80108a <dev_lookup>
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 27                	js     801304 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012e0:	8b 42 08             	mov    0x8(%edx),%eax
  8012e3:	83 e0 03             	and    $0x3,%eax
  8012e6:	83 f8 01             	cmp    $0x1,%eax
  8012e9:	74 1e                	je     801309 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ee:	8b 40 08             	mov    0x8(%eax),%eax
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	74 35                	je     80132a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	ff 75 10             	pushl  0x10(%ebp)
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	52                   	push   %edx
  8012ff:	ff d0                	call   *%eax
  801301:	83 c4 10             	add    $0x10,%esp
}
  801304:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801307:	c9                   	leave  
  801308:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801309:	a1 08 40 80 00       	mov    0x804008,%eax
  80130e:	8b 40 48             	mov    0x48(%eax),%eax
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	53                   	push   %ebx
  801315:	50                   	push   %eax
  801316:	68 11 29 80 00       	push   $0x802911
  80131b:	e8 7b ee ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801328:	eb da                	jmp    801304 <read+0x5a>
		return -E_NOT_SUPP;
  80132a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132f:	eb d3                	jmp    801304 <read+0x5a>

00801331 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	57                   	push   %edi
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801340:	bb 00 00 00 00       	mov    $0x0,%ebx
  801345:	39 f3                	cmp    %esi,%ebx
  801347:	73 23                	jae    80136c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	89 f0                	mov    %esi,%eax
  80134e:	29 d8                	sub    %ebx,%eax
  801350:	50                   	push   %eax
  801351:	89 d8                	mov    %ebx,%eax
  801353:	03 45 0c             	add    0xc(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	57                   	push   %edi
  801358:	e8 4d ff ff ff       	call   8012aa <read>
		if (m < 0)
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 06                	js     80136a <readn+0x39>
			return m;
		if (m == 0)
  801364:	74 06                	je     80136c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801366:	01 c3                	add    %eax,%ebx
  801368:	eb db                	jmp    801345 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	53                   	push   %ebx
  80137a:	83 ec 1c             	sub    $0x1c,%esp
  80137d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	53                   	push   %ebx
  801385:	e8 b0 fc ff ff       	call   80103a <fd_lookup>
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 3a                	js     8013cb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	ff 30                	pushl  (%eax)
  80139d:	e8 e8 fc ff ff       	call   80108a <dev_lookup>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 22                	js     8013cb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b0:	74 1e                	je     8013d0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 35                	je     8013f1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	ff 75 10             	pushl  0x10(%ebp)
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	50                   	push   %eax
  8013c6:	ff d2                	call   *%edx
  8013c8:	83 c4 10             	add    $0x10,%esp
}
  8013cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d5:	8b 40 48             	mov    0x48(%eax),%eax
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	53                   	push   %ebx
  8013dc:	50                   	push   %eax
  8013dd:	68 2d 29 80 00       	push   $0x80292d
  8013e2:	e8 b4 ed ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ef:	eb da                	jmp    8013cb <write+0x55>
		return -E_NOT_SUPP;
  8013f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f6:	eb d3                	jmp    8013cb <write+0x55>

008013f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801401:	50                   	push   %eax
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 30 fc ff ff       	call   80103a <fd_lookup>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 0e                	js     80141f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801411:	8b 55 0c             	mov    0xc(%ebp),%edx
  801414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801417:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80141a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 1c             	sub    $0x1c,%esp
  801428:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	53                   	push   %ebx
  801430:	e8 05 fc ff ff       	call   80103a <fd_lookup>
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 37                	js     801473 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	ff 30                	pushl  (%eax)
  801448:	e8 3d fc ff ff       	call   80108a <dev_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 1f                	js     801473 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145b:	74 1b                	je     801478 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80145d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801460:	8b 52 18             	mov    0x18(%edx),%edx
  801463:	85 d2                	test   %edx,%edx
  801465:	74 32                	je     801499 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	50                   	push   %eax
  80146e:	ff d2                	call   *%edx
  801470:	83 c4 10             	add    $0x10,%esp
}
  801473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801476:	c9                   	leave  
  801477:	c3                   	ret    
			thisenv->env_id, fdnum);
  801478:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80147d:	8b 40 48             	mov    0x48(%eax),%eax
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	53                   	push   %ebx
  801484:	50                   	push   %eax
  801485:	68 f0 28 80 00       	push   $0x8028f0
  80148a:	e8 0c ed ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801497:	eb da                	jmp    801473 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801499:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149e:	eb d3                	jmp    801473 <ftruncate+0x52>

008014a0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 1c             	sub    $0x1c,%esp
  8014a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	ff 75 08             	pushl  0x8(%ebp)
  8014b1:	e8 84 fb ff ff       	call   80103a <fd_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 4b                	js     801508 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	ff 30                	pushl  (%eax)
  8014c9:	e8 bc fb ff ff       	call   80108a <dev_lookup>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 33                	js     801508 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014dc:	74 2f                	je     80150d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014de:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014e1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e8:	00 00 00 
	stat->st_isdir = 0;
  8014eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014f2:	00 00 00 
	stat->st_dev = dev;
  8014f5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	53                   	push   %ebx
  8014ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801502:	ff 50 14             	call   *0x14(%eax)
  801505:	83 c4 10             	add    $0x10,%esp
}
  801508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    
		return -E_NOT_SUPP;
  80150d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801512:	eb f4                	jmp    801508 <fstat+0x68>

00801514 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	6a 00                	push   $0x0
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	e8 22 02 00 00       	call   801748 <open>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 1b                	js     80154a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	50                   	push   %eax
  801536:	e8 65 ff ff ff       	call   8014a0 <fstat>
  80153b:	89 c6                	mov    %eax,%esi
	close(fd);
  80153d:	89 1c 24             	mov    %ebx,(%esp)
  801540:	e8 27 fc ff ff       	call   80116c <close>
	return r;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 f3                	mov    %esi,%ebx
}
  80154a:	89 d8                	mov    %ebx,%eax
  80154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
  801558:	89 c6                	mov    %eax,%esi
  80155a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80155c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801563:	74 27                	je     80158c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801565:	6a 07                	push   $0x7
  801567:	68 00 50 80 00       	push   $0x805000
  80156c:	56                   	push   %esi
  80156d:	ff 35 00 40 80 00    	pushl  0x804000
  801573:	e8 69 0c 00 00       	call   8021e1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801578:	83 c4 0c             	add    $0xc,%esp
  80157b:	6a 00                	push   $0x0
  80157d:	53                   	push   %ebx
  80157e:	6a 00                	push   $0x0
  801580:	e8 f3 0b 00 00       	call   802178 <ipc_recv>
}
  801585:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801588:	5b                   	pop    %ebx
  801589:	5e                   	pop    %esi
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	6a 01                	push   $0x1
  801591:	e8 a3 0c 00 00       	call   802239 <ipc_find_env>
  801596:	a3 00 40 80 00       	mov    %eax,0x804000
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	eb c5                	jmp    801565 <fsipc+0x12>

008015a0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b8 02 00 00 00       	mov    $0x2,%eax
  8015c3:	e8 8b ff ff ff       	call   801553 <fsipc>
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <devfile_flush>:
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e5:	e8 69 ff ff ff       	call   801553 <fsipc>
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <devfile_stat>:
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801601:	ba 00 00 00 00       	mov    $0x0,%edx
  801606:	b8 05 00 00 00       	mov    $0x5,%eax
  80160b:	e8 43 ff ff ff       	call   801553 <fsipc>
  801610:	85 c0                	test   %eax,%eax
  801612:	78 2c                	js     801640 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	68 00 50 80 00       	push   $0x805000
  80161c:	53                   	push   %ebx
  80161d:	e8 d8 f2 ff ff       	call   8008fa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801622:	a1 80 50 80 00       	mov    0x805080,%eax
  801627:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80162d:	a1 84 50 80 00       	mov    0x805084,%eax
  801632:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <devfile_write>:
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
  801655:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80165a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801660:	53                   	push   %ebx
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	68 08 50 80 00       	push   $0x805008
  801669:	e8 7c f4 ff ff       	call   800aea <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80166e:	ba 00 00 00 00       	mov    $0x0,%edx
  801673:	b8 04 00 00 00       	mov    $0x4,%eax
  801678:	e8 d6 fe ff ff       	call   801553 <fsipc>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 0b                	js     80168f <devfile_write+0x4a>
	assert(r <= n);
  801684:	39 d8                	cmp    %ebx,%eax
  801686:	77 0c                	ja     801694 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801688:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80168d:	7f 1e                	jg     8016ad <devfile_write+0x68>
}
  80168f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801692:	c9                   	leave  
  801693:	c3                   	ret    
	assert(r <= n);
  801694:	68 60 29 80 00       	push   $0x802960
  801699:	68 67 29 80 00       	push   $0x802967
  80169e:	68 98 00 00 00       	push   $0x98
  8016a3:	68 7c 29 80 00       	push   $0x80297c
  8016a8:	e8 6a 0a 00 00       	call   802117 <_panic>
	assert(r <= PGSIZE);
  8016ad:	68 87 29 80 00       	push   $0x802987
  8016b2:	68 67 29 80 00       	push   $0x802967
  8016b7:	68 99 00 00 00       	push   $0x99
  8016bc:	68 7c 29 80 00       	push   $0x80297c
  8016c1:	e8 51 0a 00 00       	call   802117 <_panic>

008016c6 <devfile_read>:
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016df:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e9:	e8 65 fe ff ff       	call   801553 <fsipc>
  8016ee:	89 c3                	mov    %eax,%ebx
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 1f                	js     801713 <devfile_read+0x4d>
	assert(r <= n);
  8016f4:	39 f0                	cmp    %esi,%eax
  8016f6:	77 24                	ja     80171c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016fd:	7f 33                	jg     801732 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	50                   	push   %eax
  801703:	68 00 50 80 00       	push   $0x805000
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	e8 78 f3 ff ff       	call   800a88 <memmove>
	return r;
  801710:	83 c4 10             	add    $0x10,%esp
}
  801713:	89 d8                	mov    %ebx,%eax
  801715:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    
	assert(r <= n);
  80171c:	68 60 29 80 00       	push   $0x802960
  801721:	68 67 29 80 00       	push   $0x802967
  801726:	6a 7c                	push   $0x7c
  801728:	68 7c 29 80 00       	push   $0x80297c
  80172d:	e8 e5 09 00 00       	call   802117 <_panic>
	assert(r <= PGSIZE);
  801732:	68 87 29 80 00       	push   $0x802987
  801737:	68 67 29 80 00       	push   $0x802967
  80173c:	6a 7d                	push   $0x7d
  80173e:	68 7c 29 80 00       	push   $0x80297c
  801743:	e8 cf 09 00 00       	call   802117 <_panic>

00801748 <open>:
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	83 ec 1c             	sub    $0x1c,%esp
  801750:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801753:	56                   	push   %esi
  801754:	e8 68 f1 ff ff       	call   8008c1 <strlen>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801761:	7f 6c                	jg     8017cf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801769:	50                   	push   %eax
  80176a:	e8 79 f8 ff ff       	call   800fe8 <fd_alloc>
  80176f:	89 c3                	mov    %eax,%ebx
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 3c                	js     8017b4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	56                   	push   %esi
  80177c:	68 00 50 80 00       	push   $0x805000
  801781:	e8 74 f1 ff ff       	call   8008fa <strcpy>
	fsipcbuf.open.req_omode = mode;
  801786:	8b 45 0c             	mov    0xc(%ebp),%eax
  801789:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80178e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801791:	b8 01 00 00 00       	mov    $0x1,%eax
  801796:	e8 b8 fd ff ff       	call   801553 <fsipc>
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 19                	js     8017bd <open+0x75>
	return fd2num(fd);
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	e8 12 f8 ff ff       	call   800fc1 <fd2num>
  8017af:	89 c3                	mov    %eax,%ebx
  8017b1:	83 c4 10             	add    $0x10,%esp
}
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
		fd_close(fd, 0);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	6a 00                	push   $0x0
  8017c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c5:	e8 1b f9 ff ff       	call   8010e5 <fd_close>
		return r;
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	eb e5                	jmp    8017b4 <open+0x6c>
		return -E_BAD_PATH;
  8017cf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017d4:	eb de                	jmp    8017b4 <open+0x6c>

008017d6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8017e6:	e8 68 fd ff ff       	call   801553 <fsipc>
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017f3:	68 93 29 80 00       	push   $0x802993
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	e8 fa f0 ff ff       	call   8008fa <strcpy>
	return 0;
}
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <devsock_close>:
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 10             	sub    $0x10,%esp
  80180e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801811:	53                   	push   %ebx
  801812:	e8 5d 0a 00 00       	call   802274 <pageref>
  801817:	83 c4 10             	add    $0x10,%esp
		return 0;
  80181a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80181f:	83 f8 01             	cmp    $0x1,%eax
  801822:	74 07                	je     80182b <devsock_close+0x24>
}
  801824:	89 d0                	mov    %edx,%eax
  801826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801829:	c9                   	leave  
  80182a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80182b:	83 ec 0c             	sub    $0xc,%esp
  80182e:	ff 73 0c             	pushl  0xc(%ebx)
  801831:	e8 b9 02 00 00       	call   801aef <nsipc_close>
  801836:	89 c2                	mov    %eax,%edx
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	eb e7                	jmp    801824 <devsock_close+0x1d>

0080183d <devsock_write>:
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801843:	6a 00                	push   $0x0
  801845:	ff 75 10             	pushl  0x10(%ebp)
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	ff 70 0c             	pushl  0xc(%eax)
  801851:	e8 76 03 00 00       	call   801bcc <nsipc_send>
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <devsock_read>:
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80185e:	6a 00                	push   $0x0
  801860:	ff 75 10             	pushl  0x10(%ebp)
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	ff 70 0c             	pushl  0xc(%eax)
  80186c:	e8 ef 02 00 00       	call   801b60 <nsipc_recv>
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <fd2sockid>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801879:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80187c:	52                   	push   %edx
  80187d:	50                   	push   %eax
  80187e:	e8 b7 f7 ff ff       	call   80103a <fd_lookup>
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	85 c0                	test   %eax,%eax
  801888:	78 10                	js     80189a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801893:	39 08                	cmp    %ecx,(%eax)
  801895:	75 05                	jne    80189c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801897:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    
		return -E_NOT_SUPP;
  80189c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a1:	eb f7                	jmp    80189a <fd2sockid+0x27>

008018a3 <alloc_sockfd>:
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 1c             	sub    $0x1c,%esp
  8018ab:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	e8 32 f7 ff ff       	call   800fe8 <fd_alloc>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 43                	js     801902 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 07 04 00 00       	push   $0x407
  8018c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ca:	6a 00                	push   $0x0
  8018cc:	e8 1b f4 ff ff       	call   800cec <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 28                	js     801902 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018ef:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018f2:	83 ec 0c             	sub    $0xc,%esp
  8018f5:	50                   	push   %eax
  8018f6:	e8 c6 f6 ff ff       	call   800fc1 <fd2num>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	eb 0c                	jmp    80190e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	56                   	push   %esi
  801906:	e8 e4 01 00 00       	call   801aef <nsipc_close>
		return r;
  80190b:	83 c4 10             	add    $0x10,%esp
}
  80190e:	89 d8                	mov    %ebx,%eax
  801910:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5d                   	pop    %ebp
  801916:	c3                   	ret    

00801917 <accept>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	e8 4e ff ff ff       	call   801873 <fd2sockid>
  801925:	85 c0                	test   %eax,%eax
  801927:	78 1b                	js     801944 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	50                   	push   %eax
  801933:	e8 0e 01 00 00       	call   801a46 <nsipc_accept>
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 05                	js     801944 <accept+0x2d>
	return alloc_sockfd(r);
  80193f:	e8 5f ff ff ff       	call   8018a3 <alloc_sockfd>
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <bind>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	e8 1f ff ff ff       	call   801873 <fd2sockid>
  801954:	85 c0                	test   %eax,%eax
  801956:	78 12                	js     80196a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	ff 75 10             	pushl  0x10(%ebp)
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	50                   	push   %eax
  801962:	e8 31 01 00 00       	call   801a98 <nsipc_bind>
  801967:	83 c4 10             	add    $0x10,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <shutdown>:
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	e8 f9 fe ff ff       	call   801873 <fd2sockid>
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 0f                	js     80198d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80197e:	83 ec 08             	sub    $0x8,%esp
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	e8 43 01 00 00       	call   801acd <nsipc_shutdown>
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <connect>:
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	e8 d6 fe ff ff       	call   801873 <fd2sockid>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 12                	js     8019b3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	ff 75 10             	pushl  0x10(%ebp)
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	50                   	push   %eax
  8019ab:	e8 59 01 00 00       	call   801b09 <nsipc_connect>
  8019b0:	83 c4 10             	add    $0x10,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <listen>:
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	e8 b0 fe ff ff       	call   801873 <fd2sockid>
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	78 0f                	js     8019d6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	50                   	push   %eax
  8019ce:	e8 6b 01 00 00       	call   801b3e <nsipc_listen>
  8019d3:	83 c4 10             	add    $0x10,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	e8 3e 02 00 00       	call   801c2a <nsipc_socket>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 05                	js     8019f8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019f3:	e8 ab fe ff ff       	call   8018a3 <alloc_sockfd>
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a03:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a0a:	74 26                	je     801a32 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a0c:	6a 07                	push   $0x7
  801a0e:	68 00 60 80 00       	push   $0x806000
  801a13:	53                   	push   %ebx
  801a14:	ff 35 04 40 80 00    	pushl  0x804004
  801a1a:	e8 c2 07 00 00       	call   8021e1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a1f:	83 c4 0c             	add    $0xc,%esp
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	e8 4b 07 00 00       	call   802178 <ipc_recv>
}
  801a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	6a 02                	push   $0x2
  801a37:	e8 fd 07 00 00       	call   802239 <ipc_find_env>
  801a3c:	a3 04 40 80 00       	mov    %eax,0x804004
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	eb c6                	jmp    801a0c <nsipc+0x12>

00801a46 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a56:	8b 06                	mov    (%esi),%eax
  801a58:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a62:	e8 93 ff ff ff       	call   8019fa <nsipc>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	79 09                	jns    801a76 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a6d:	89 d8                	mov    %ebx,%eax
  801a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a72:	5b                   	pop    %ebx
  801a73:	5e                   	pop    %esi
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	ff 35 10 60 80 00    	pushl  0x806010
  801a7f:	68 00 60 80 00       	push   $0x806000
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	e8 fc ef ff ff       	call   800a88 <memmove>
		*addrlen = ret->ret_addrlen;
  801a8c:	a1 10 60 80 00       	mov    0x806010,%eax
  801a91:	89 06                	mov    %eax,(%esi)
  801a93:	83 c4 10             	add    $0x10,%esp
	return r;
  801a96:	eb d5                	jmp    801a6d <nsipc_accept+0x27>

00801a98 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	53                   	push   %ebx
  801a9c:	83 ec 08             	sub    $0x8,%esp
  801a9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aaa:	53                   	push   %ebx
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	68 04 60 80 00       	push   $0x806004
  801ab3:	e8 d0 ef ff ff       	call   800a88 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ab8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801abe:	b8 02 00 00 00       	mov    $0x2,%eax
  801ac3:	e8 32 ff ff ff       	call   8019fa <nsipc>
}
  801ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ade:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ae3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae8:	e8 0d ff ff ff       	call   8019fa <nsipc>
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <nsipc_close>:

int
nsipc_close(int s)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801afd:	b8 04 00 00 00       	mov    $0x4,%eax
  801b02:	e8 f3 fe ff ff       	call   8019fa <nsipc>
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	53                   	push   %ebx
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b1b:	53                   	push   %ebx
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	68 04 60 80 00       	push   $0x806004
  801b24:	e8 5f ef ff ff       	call   800a88 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b29:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b34:	e8 c1 fe ff ff       	call   8019fa <nsipc>
}
  801b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b54:	b8 06 00 00 00       	mov    $0x6,%eax
  801b59:	e8 9c fe ff ff       	call   8019fa <nsipc>
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b70:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b76:	8b 45 14             	mov    0x14(%ebp),%eax
  801b79:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b7e:	b8 07 00 00 00       	mov    $0x7,%eax
  801b83:	e8 72 fe ff ff       	call   8019fa <nsipc>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 1f                	js     801bad <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b8e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b93:	7f 21                	jg     801bb6 <nsipc_recv+0x56>
  801b95:	39 c6                	cmp    %eax,%esi
  801b97:	7c 1d                	jl     801bb6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	50                   	push   %eax
  801b9d:	68 00 60 80 00       	push   $0x806000
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	e8 de ee ff ff       	call   800a88 <memmove>
  801baa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bad:	89 d8                	mov    %ebx,%eax
  801baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb2:	5b                   	pop    %ebx
  801bb3:	5e                   	pop    %esi
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bb6:	68 9f 29 80 00       	push   $0x80299f
  801bbb:	68 67 29 80 00       	push   $0x802967
  801bc0:	6a 62                	push   $0x62
  801bc2:	68 b4 29 80 00       	push   $0x8029b4
  801bc7:	e8 4b 05 00 00       	call   802117 <_panic>

00801bcc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bde:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801be4:	7f 2e                	jg     801c14 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	53                   	push   %ebx
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	68 0c 60 80 00       	push   $0x80600c
  801bf2:	e8 91 ee ff ff       	call   800a88 <memmove>
	nsipcbuf.send.req_size = size;
  801bf7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c05:	b8 08 00 00 00       	mov    $0x8,%eax
  801c0a:	e8 eb fd ff ff       	call   8019fa <nsipc>
}
  801c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    
	assert(size < 1600);
  801c14:	68 c0 29 80 00       	push   $0x8029c0
  801c19:	68 67 29 80 00       	push   $0x802967
  801c1e:	6a 6d                	push   $0x6d
  801c20:	68 b4 29 80 00       	push   $0x8029b4
  801c25:	e8 ed 04 00 00       	call   802117 <_panic>

00801c2a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c48:	b8 09 00 00 00       	mov    $0x9,%eax
  801c4d:	e8 a8 fd ff ff       	call   8019fa <nsipc>
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	e8 6a f3 ff ff       	call   800fd1 <fd2data>
  801c67:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c69:	83 c4 08             	add    $0x8,%esp
  801c6c:	68 cc 29 80 00       	push   $0x8029cc
  801c71:	53                   	push   %ebx
  801c72:	e8 83 ec ff ff       	call   8008fa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c77:	8b 46 04             	mov    0x4(%esi),%eax
  801c7a:	2b 06                	sub    (%esi),%eax
  801c7c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c82:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c89:	00 00 00 
	stat->st_dev = &devpipe;
  801c8c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c93:	30 80 00 
	return 0;
}
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    

00801ca2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cac:	53                   	push   %ebx
  801cad:	6a 00                	push   $0x0
  801caf:	e8 bd f0 ff ff       	call   800d71 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb4:	89 1c 24             	mov    %ebx,(%esp)
  801cb7:	e8 15 f3 ff ff       	call   800fd1 <fd2data>
  801cbc:	83 c4 08             	add    $0x8,%esp
  801cbf:	50                   	push   %eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 aa f0 ff ff       	call   800d71 <sys_page_unmap>
}
  801cc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <_pipeisclosed>:
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	57                   	push   %edi
  801cd0:	56                   	push   %esi
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 1c             	sub    $0x1c,%esp
  801cd5:	89 c7                	mov    %eax,%edi
  801cd7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd9:	a1 08 40 80 00       	mov    0x804008,%eax
  801cde:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	57                   	push   %edi
  801ce5:	e8 8a 05 00 00       	call   802274 <pageref>
  801cea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ced:	89 34 24             	mov    %esi,(%esp)
  801cf0:	e8 7f 05 00 00       	call   802274 <pageref>
		nn = thisenv->env_runs;
  801cf5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cfb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	39 cb                	cmp    %ecx,%ebx
  801d03:	74 1b                	je     801d20 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d08:	75 cf                	jne    801cd9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d0a:	8b 42 58             	mov    0x58(%edx),%eax
  801d0d:	6a 01                	push   $0x1
  801d0f:	50                   	push   %eax
  801d10:	53                   	push   %ebx
  801d11:	68 d3 29 80 00       	push   $0x8029d3
  801d16:	e8 80 e4 ff ff       	call   80019b <cprintf>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	eb b9                	jmp    801cd9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d23:	0f 94 c0             	sete   %al
  801d26:	0f b6 c0             	movzbl %al,%eax
}
  801d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <devpipe_write>:
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	57                   	push   %edi
  801d35:	56                   	push   %esi
  801d36:	53                   	push   %ebx
  801d37:	83 ec 28             	sub    $0x28,%esp
  801d3a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d3d:	56                   	push   %esi
  801d3e:	e8 8e f2 ff ff       	call   800fd1 <fd2data>
  801d43:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d50:	74 4f                	je     801da1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d52:	8b 43 04             	mov    0x4(%ebx),%eax
  801d55:	8b 0b                	mov    (%ebx),%ecx
  801d57:	8d 51 20             	lea    0x20(%ecx),%edx
  801d5a:	39 d0                	cmp    %edx,%eax
  801d5c:	72 14                	jb     801d72 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d5e:	89 da                	mov    %ebx,%edx
  801d60:	89 f0                	mov    %esi,%eax
  801d62:	e8 65 ff ff ff       	call   801ccc <_pipeisclosed>
  801d67:	85 c0                	test   %eax,%eax
  801d69:	75 3b                	jne    801da6 <devpipe_write+0x75>
			sys_yield();
  801d6b:	e8 5d ef ff ff       	call   800ccd <sys_yield>
  801d70:	eb e0                	jmp    801d52 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d75:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d79:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d7c:	89 c2                	mov    %eax,%edx
  801d7e:	c1 fa 1f             	sar    $0x1f,%edx
  801d81:	89 d1                	mov    %edx,%ecx
  801d83:	c1 e9 1b             	shr    $0x1b,%ecx
  801d86:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d89:	83 e2 1f             	and    $0x1f,%edx
  801d8c:	29 ca                	sub    %ecx,%edx
  801d8e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d92:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d96:	83 c0 01             	add    $0x1,%eax
  801d99:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d9c:	83 c7 01             	add    $0x1,%edi
  801d9f:	eb ac                	jmp    801d4d <devpipe_write+0x1c>
	return i;
  801da1:	8b 45 10             	mov    0x10(%ebp),%eax
  801da4:	eb 05                	jmp    801dab <devpipe_write+0x7a>
				return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	5d                   	pop    %ebp
  801db2:	c3                   	ret    

00801db3 <devpipe_read>:
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	57                   	push   %edi
  801db7:	56                   	push   %esi
  801db8:	53                   	push   %ebx
  801db9:	83 ec 18             	sub    $0x18,%esp
  801dbc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dbf:	57                   	push   %edi
  801dc0:	e8 0c f2 ff ff       	call   800fd1 <fd2data>
  801dc5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	be 00 00 00 00       	mov    $0x0,%esi
  801dcf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dd2:	75 14                	jne    801de8 <devpipe_read+0x35>
	return i;
  801dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd7:	eb 02                	jmp    801ddb <devpipe_read+0x28>
				return i;
  801dd9:	89 f0                	mov    %esi,%eax
}
  801ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	5f                   	pop    %edi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    
			sys_yield();
  801de3:	e8 e5 ee ff ff       	call   800ccd <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801de8:	8b 03                	mov    (%ebx),%eax
  801dea:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ded:	75 18                	jne    801e07 <devpipe_read+0x54>
			if (i > 0)
  801def:	85 f6                	test   %esi,%esi
  801df1:	75 e6                	jne    801dd9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801df3:	89 da                	mov    %ebx,%edx
  801df5:	89 f8                	mov    %edi,%eax
  801df7:	e8 d0 fe ff ff       	call   801ccc <_pipeisclosed>
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	74 e3                	je     801de3 <devpipe_read+0x30>
				return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
  801e05:	eb d4                	jmp    801ddb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e07:	99                   	cltd   
  801e08:	c1 ea 1b             	shr    $0x1b,%edx
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	83 e0 1f             	and    $0x1f,%eax
  801e10:	29 d0                	sub    %edx,%eax
  801e12:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e1d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e20:	83 c6 01             	add    $0x1,%esi
  801e23:	eb aa                	jmp    801dcf <devpipe_read+0x1c>

00801e25 <pipe>:
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e30:	50                   	push   %eax
  801e31:	e8 b2 f1 ff ff       	call   800fe8 <fd_alloc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	0f 88 23 01 00 00    	js     801f66 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	68 07 04 00 00       	push   $0x407
  801e4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4e:	6a 00                	push   $0x0
  801e50:	e8 97 ee ff ff       	call   800cec <sys_page_alloc>
  801e55:	89 c3                	mov    %eax,%ebx
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 88 04 01 00 00    	js     801f66 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e68:	50                   	push   %eax
  801e69:	e8 7a f1 ff ff       	call   800fe8 <fd_alloc>
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	85 c0                	test   %eax,%eax
  801e75:	0f 88 db 00 00 00    	js     801f56 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 07 04 00 00       	push   $0x407
  801e83:	ff 75 f0             	pushl  -0x10(%ebp)
  801e86:	6a 00                	push   $0x0
  801e88:	e8 5f ee ff ff       	call   800cec <sys_page_alloc>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	85 c0                	test   %eax,%eax
  801e94:	0f 88 bc 00 00 00    	js     801f56 <pipe+0x131>
	va = fd2data(fd0);
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea0:	e8 2c f1 ff ff       	call   800fd1 <fd2data>
  801ea5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea7:	83 c4 0c             	add    $0xc,%esp
  801eaa:	68 07 04 00 00       	push   $0x407
  801eaf:	50                   	push   %eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	e8 35 ee ff ff       	call   800cec <sys_page_alloc>
  801eb7:	89 c3                	mov    %eax,%ebx
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 88 82 00 00 00    	js     801f46 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eca:	e8 02 f1 ff ff       	call   800fd1 <fd2data>
  801ecf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed6:	50                   	push   %eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	56                   	push   %esi
  801eda:	6a 00                	push   $0x0
  801edc:	e8 4e ee ff ff       	call   800d2f <sys_page_map>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	83 c4 20             	add    $0x20,%esp
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	78 4e                	js     801f38 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eea:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ef4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801efe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f01:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	ff 75 f4             	pushl  -0xc(%ebp)
  801f13:	e8 a9 f0 ff ff       	call   800fc1 <fd2num>
  801f18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f1d:	83 c4 04             	add    $0x4,%esp
  801f20:	ff 75 f0             	pushl  -0x10(%ebp)
  801f23:	e8 99 f0 ff ff       	call   800fc1 <fd2num>
  801f28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f36:	eb 2e                	jmp    801f66 <pipe+0x141>
	sys_page_unmap(0, va);
  801f38:	83 ec 08             	sub    $0x8,%esp
  801f3b:	56                   	push   %esi
  801f3c:	6a 00                	push   $0x0
  801f3e:	e8 2e ee ff ff       	call   800d71 <sys_page_unmap>
  801f43:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f46:	83 ec 08             	sub    $0x8,%esp
  801f49:	ff 75 f0             	pushl  -0x10(%ebp)
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 1e ee ff ff       	call   800d71 <sys_page_unmap>
  801f53:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 0e ee ff ff       	call   800d71 <sys_page_unmap>
  801f63:	83 c4 10             	add    $0x10,%esp
}
  801f66:	89 d8                	mov    %ebx,%eax
  801f68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6b:	5b                   	pop    %ebx
  801f6c:	5e                   	pop    %esi
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <pipeisclosed>:
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	50                   	push   %eax
  801f79:	ff 75 08             	pushl  0x8(%ebp)
  801f7c:	e8 b9 f0 ff ff       	call   80103a <fd_lookup>
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 18                	js     801fa0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8e:	e8 3e f0 ff ff       	call   800fd1 <fd2data>
	return _pipeisclosed(fd, p);
  801f93:	89 c2                	mov    %eax,%edx
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	e8 2f fd ff ff       	call   801ccc <_pipeisclosed>
  801f9d:	83 c4 10             	add    $0x10,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	c3                   	ret    

00801fa8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fae:	68 eb 29 80 00       	push   $0x8029eb
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	e8 3f e9 ff ff       	call   8008fa <strcpy>
	return 0;
}
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <devcons_write>:
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fd3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fdc:	73 31                	jae    80200f <devcons_write+0x4d>
		m = n - tot;
  801fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fe1:	29 f3                	sub    %esi,%ebx
  801fe3:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801feb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	53                   	push   %ebx
  801ff2:	89 f0                	mov    %esi,%eax
  801ff4:	03 45 0c             	add    0xc(%ebp),%eax
  801ff7:	50                   	push   %eax
  801ff8:	57                   	push   %edi
  801ff9:	e8 8a ea ff ff       	call   800a88 <memmove>
		sys_cputs(buf, m);
  801ffe:	83 c4 08             	add    $0x8,%esp
  802001:	53                   	push   %ebx
  802002:	57                   	push   %edi
  802003:	e8 28 ec ff ff       	call   800c30 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802008:	01 de                	add    %ebx,%esi
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	eb ca                	jmp    801fd9 <devcons_write+0x17>
}
  80200f:	89 f0                	mov    %esi,%eax
  802011:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5f                   	pop    %edi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <devcons_read>:
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802028:	74 21                	je     80204b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80202a:	e8 1f ec ff ff       	call   800c4e <sys_cgetc>
  80202f:	85 c0                	test   %eax,%eax
  802031:	75 07                	jne    80203a <devcons_read+0x21>
		sys_yield();
  802033:	e8 95 ec ff ff       	call   800ccd <sys_yield>
  802038:	eb f0                	jmp    80202a <devcons_read+0x11>
	if (c < 0)
  80203a:	78 0f                	js     80204b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80203c:	83 f8 04             	cmp    $0x4,%eax
  80203f:	74 0c                	je     80204d <devcons_read+0x34>
	*(char*)vbuf = c;
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	88 02                	mov    %al,(%edx)
	return 1;
  802046:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    
		return 0;
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
  802052:	eb f7                	jmp    80204b <devcons_read+0x32>

00802054 <cputchar>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802060:	6a 01                	push   $0x1
  802062:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802065:	50                   	push   %eax
  802066:	e8 c5 eb ff ff       	call   800c30 <sys_cputs>
}
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <getchar>:
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802076:	6a 01                	push   $0x1
  802078:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	6a 00                	push   $0x0
  80207e:	e8 27 f2 ff ff       	call   8012aa <read>
	if (r < 0)
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	85 c0                	test   %eax,%eax
  802088:	78 06                	js     802090 <getchar+0x20>
	if (r < 1)
  80208a:	74 06                	je     802092 <getchar+0x22>
	return c;
  80208c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    
		return -E_EOF;
  802092:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802097:	eb f7                	jmp    802090 <getchar+0x20>

00802099 <iscons>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a2:	50                   	push   %eax
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	e8 8f ef ff ff       	call   80103a <fd_lookup>
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 11                	js     8020c3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020bb:	39 10                	cmp    %edx,(%eax)
  8020bd:	0f 94 c0             	sete   %al
  8020c0:	0f b6 c0             	movzbl %al,%eax
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <opencons>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ce:	50                   	push   %eax
  8020cf:	e8 14 ef ff ff       	call   800fe8 <fd_alloc>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	78 3a                	js     802115 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 07 04 00 00       	push   $0x407
  8020e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e6:	6a 00                	push   $0x0
  8020e8:	e8 ff eb ff ff       	call   800cec <sys_page_alloc>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	78 21                	js     802115 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020fd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	50                   	push   %eax
  80210d:	e8 af ee ff ff       	call   800fc1 <fd2num>
  802112:	83 c4 10             	add    $0x10,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80211c:	a1 08 40 80 00       	mov    0x804008,%eax
  802121:	8b 40 48             	mov    0x48(%eax),%eax
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 28 2a 80 00       	push   $0x802a28
  80212c:	50                   	push   %eax
  80212d:	68 f7 29 80 00       	push   $0x8029f7
  802132:	e8 64 e0 ff ff       	call   80019b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802137:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80213a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802140:	e8 69 eb ff ff       	call   800cae <sys_getenvid>
  802145:	83 c4 04             	add    $0x4,%esp
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	56                   	push   %esi
  80214f:	50                   	push   %eax
  802150:	68 04 2a 80 00       	push   $0x802a04
  802155:	e8 41 e0 ff ff       	call   80019b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80215a:	83 c4 18             	add    $0x18,%esp
  80215d:	53                   	push   %ebx
  80215e:	ff 75 10             	pushl  0x10(%ebp)
  802161:	e8 e4 df ff ff       	call   80014a <vcprintf>
	cprintf("\n");
  802166:	c7 04 24 10 25 80 00 	movl   $0x802510,(%esp)
  80216d:	e8 29 e0 ff ff       	call   80019b <cprintf>
  802172:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802175:	cc                   	int3   
  802176:	eb fd                	jmp    802175 <_panic+0x5e>

00802178 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	56                   	push   %esi
  80217c:	53                   	push   %ebx
  80217d:	8b 75 08             	mov    0x8(%ebp),%esi
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802186:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802188:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80218d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802190:	83 ec 0c             	sub    $0xc,%esp
  802193:	50                   	push   %eax
  802194:	e8 03 ed ff ff       	call   800e9c <sys_ipc_recv>
	if(ret < 0){
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 2b                	js     8021cb <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021a0:	85 f6                	test   %esi,%esi
  8021a2:	74 0a                	je     8021ae <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a9:	8b 40 74             	mov    0x74(%eax),%eax
  8021ac:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021ae:	85 db                	test   %ebx,%ebx
  8021b0:	74 0a                	je     8021bc <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b7:	8b 40 78             	mov    0x78(%eax),%eax
  8021ba:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5d                   	pop    %ebp
  8021ca:	c3                   	ret    
		if(from_env_store)
  8021cb:	85 f6                	test   %esi,%esi
  8021cd:	74 06                	je     8021d5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021d5:	85 db                	test   %ebx,%ebx
  8021d7:	74 eb                	je     8021c4 <ipc_recv+0x4c>
			*perm_store = 0;
  8021d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021df:	eb e3                	jmp    8021c4 <ipc_recv+0x4c>

008021e1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	57                   	push   %edi
  8021e5:	56                   	push   %esi
  8021e6:	53                   	push   %ebx
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021f3:	85 db                	test   %ebx,%ebx
  8021f5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021fa:	0f 44 d8             	cmove  %eax,%ebx
  8021fd:	eb 05                	jmp    802204 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021ff:	e8 c9 ea ff ff       	call   800ccd <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802204:	ff 75 14             	pushl  0x14(%ebp)
  802207:	53                   	push   %ebx
  802208:	56                   	push   %esi
  802209:	57                   	push   %edi
  80220a:	e8 6a ec ff ff       	call   800e79 <sys_ipc_try_send>
  80220f:	83 c4 10             	add    $0x10,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	74 1b                	je     802231 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802216:	79 e7                	jns    8021ff <ipc_send+0x1e>
  802218:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80221b:	74 e2                	je     8021ff <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 2f 2a 80 00       	push   $0x802a2f
  802225:	6a 48                	push   $0x48
  802227:	68 44 2a 80 00       	push   $0x802a44
  80222c:	e8 e6 fe ff ff       	call   802117 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802244:	89 c2                	mov    %eax,%edx
  802246:	c1 e2 07             	shl    $0x7,%edx
  802249:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80224f:	8b 52 50             	mov    0x50(%edx),%edx
  802252:	39 ca                	cmp    %ecx,%edx
  802254:	74 11                	je     802267 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802256:	83 c0 01             	add    $0x1,%eax
  802259:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225e:	75 e4                	jne    802244 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
  802265:	eb 0b                	jmp    802272 <ipc_find_env+0x39>
			return envs[i].env_id;
  802267:	c1 e0 07             	shl    $0x7,%eax
  80226a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80226f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227a:	89 d0                	mov    %edx,%eax
  80227c:	c1 e8 16             	shr    $0x16,%eax
  80227f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80228b:	f6 c1 01             	test   $0x1,%cl
  80228e:	74 1d                	je     8022ad <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802290:	c1 ea 0c             	shr    $0xc,%edx
  802293:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80229a:	f6 c2 01             	test   $0x1,%dl
  80229d:	74 0e                	je     8022ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80229f:	c1 ea 0c             	shr    $0xc,%edx
  8022a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a9:	ef 
  8022aa:	0f b7 c0             	movzwl %ax,%eax
}
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    
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
