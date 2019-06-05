
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
  800039:	68 20 25 80 00       	push   $0x802520
  80003e:	e8 6c 01 00 00       	call   8001af <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 08 40 80 00       	mov    0x804008,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 2e 25 80 00       	push   $0x80252e
  800054:	e8 56 01 00 00       	call   8001af <cprintf>
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
  800067:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80006e:	00 00 00 
	envid_t find = sys_getenvid();
  800071:	e8 4c 0c 00 00       	call   800cc2 <sys_getenvid>
  800076:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
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
  8000bf:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c9:	7e 0a                	jle    8000d5 <libmain+0x77>
		binaryname = argv[0];
  8000cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ce:	8b 00                	mov    (%eax),%eax
  8000d0:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 45 25 80 00       	push   $0x802545
  8000dd:	e8 cd 00 00 00       	call   8001af <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e2:	83 c4 08             	add    $0x8,%esp
  8000e5:	ff 75 0c             	pushl  0xc(%ebp)
  8000e8:	ff 75 08             	pushl  0x8(%ebp)
  8000eb:	e8 43 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f0:	e8 0b 00 00 00       	call   800100 <exit>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    

00800100 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800106:	e8 a2 10 00 00       	call   8011ad <close_all>
	sys_env_destroy(0);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	6a 00                	push   $0x0
  800110:	e8 6c 0b 00 00       	call   800c81 <sys_env_destroy>
}
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	c9                   	leave  
  800119:	c3                   	ret    

0080011a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	53                   	push   %ebx
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800124:	8b 13                	mov    (%ebx),%edx
  800126:	8d 42 01             	lea    0x1(%edx),%eax
  800129:	89 03                	mov    %eax,(%ebx)
  80012b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800132:	3d ff 00 00 00       	cmp    $0xff,%eax
  800137:	74 09                	je     800142 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800139:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800140:	c9                   	leave  
  800141:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	68 ff 00 00 00       	push   $0xff
  80014a:	8d 43 08             	lea    0x8(%ebx),%eax
  80014d:	50                   	push   %eax
  80014e:	e8 f1 0a 00 00       	call   800c44 <sys_cputs>
		b->idx = 0;
  800153:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	eb db                	jmp    800139 <putch+0x1f>

0080015e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800167:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016e:	00 00 00 
	b.cnt = 0;
  800171:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800178:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017b:	ff 75 0c             	pushl  0xc(%ebp)
  80017e:	ff 75 08             	pushl  0x8(%ebp)
  800181:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800187:	50                   	push   %eax
  800188:	68 1a 01 80 00       	push   $0x80011a
  80018d:	e8 4a 01 00 00       	call   8002dc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800192:	83 c4 08             	add    $0x8,%esp
  800195:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a1:	50                   	push   %eax
  8001a2:	e8 9d 0a 00 00       	call   800c44 <sys_cputs>

	return b.cnt;
}
  8001a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b8:	50                   	push   %eax
  8001b9:	ff 75 08             	pushl  0x8(%ebp)
  8001bc:	e8 9d ff ff ff       	call   80015e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	57                   	push   %edi
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	83 ec 1c             	sub    $0x1c,%esp
  8001cc:	89 c6                	mov    %eax,%esi
  8001ce:	89 d7                	mov    %edx,%edi
  8001d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e6:	74 2c                	je     800214 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001fd:	73 43                	jae    800242 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001ff:	83 eb 01             	sub    $0x1,%ebx
  800202:	85 db                	test   %ebx,%ebx
  800204:	7e 6c                	jle    800272 <printnum+0xaf>
				putch(padc, putdat);
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	57                   	push   %edi
  80020a:	ff 75 18             	pushl  0x18(%ebp)
  80020d:	ff d6                	call   *%esi
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	eb eb                	jmp    8001ff <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	6a 20                	push   $0x20
  800219:	6a 00                	push   $0x0
  80021b:	50                   	push   %eax
  80021c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021f:	ff 75 e0             	pushl  -0x20(%ebp)
  800222:	89 fa                	mov    %edi,%edx
  800224:	89 f0                	mov    %esi,%eax
  800226:	e8 98 ff ff ff       	call   8001c3 <printnum>
		while (--width > 0)
  80022b:	83 c4 20             	add    $0x20,%esp
  80022e:	83 eb 01             	sub    $0x1,%ebx
  800231:	85 db                	test   %ebx,%ebx
  800233:	7e 65                	jle    80029a <printnum+0xd7>
			putch(padc, putdat);
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	57                   	push   %edi
  800239:	6a 20                	push   $0x20
  80023b:	ff d6                	call   *%esi
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	eb ec                	jmp    80022e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 18             	pushl  0x18(%ebp)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	53                   	push   %ebx
  80024c:	50                   	push   %eax
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	e8 6f 20 00 00       	call   8022d0 <__udivdi3>
  800261:	83 c4 18             	add    $0x18,%esp
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	89 fa                	mov    %edi,%edx
  800268:	89 f0                	mov    %esi,%eax
  80026a:	e8 54 ff ff ff       	call   8001c3 <printnum>
  80026f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	57                   	push   %edi
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 dc             	pushl  -0x24(%ebp)
  80027c:	ff 75 d8             	pushl  -0x28(%ebp)
  80027f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800282:	ff 75 e0             	pushl  -0x20(%ebp)
  800285:	e8 56 21 00 00       	call   8023e0 <__umoddi3>
  80028a:	83 c4 14             	add    $0x14,%esp
  80028d:	0f be 80 69 25 80 00 	movsbl 0x802569(%eax),%eax
  800294:	50                   	push   %eax
  800295:	ff d6                	call   *%esi
  800297:	83 c4 10             	add    $0x10,%esp
	}
}
  80029a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029d:	5b                   	pop    %ebx
  80029e:	5e                   	pop    %esi
  80029f:	5f                   	pop    %edi
  8002a0:	5d                   	pop    %ebp
  8002a1:	c3                   	ret    

008002a2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ac:	8b 10                	mov    (%eax),%edx
  8002ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b1:	73 0a                	jae    8002bd <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b6:	89 08                	mov    %ecx,(%eax)
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	88 02                	mov    %al,(%edx)
}
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <printfmt>:
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 10             	pushl  0x10(%ebp)
  8002cc:	ff 75 0c             	pushl  0xc(%ebp)
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 05 00 00 00       	call   8002dc <vprintfmt>
}
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <vprintfmt>:
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	57                   	push   %edi
  8002e0:	56                   	push   %esi
  8002e1:	53                   	push   %ebx
  8002e2:	83 ec 3c             	sub    $0x3c,%esp
  8002e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002eb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ee:	e9 32 04 00 00       	jmp    800725 <vprintfmt+0x449>
		padc = ' ';
  8002f3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002f7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002fe:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800305:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800313:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80031a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031f:	8d 47 01             	lea    0x1(%edi),%eax
  800322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800325:	0f b6 17             	movzbl (%edi),%edx
  800328:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032b:	3c 55                	cmp    $0x55,%al
  80032d:	0f 87 12 05 00 00    	ja     800845 <vprintfmt+0x569>
  800333:	0f b6 c0             	movzbl %al,%eax
  800336:	ff 24 85 40 27 80 00 	jmp    *0x802740(,%eax,4)
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800340:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800344:	eb d9                	jmp    80031f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800349:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80034d:	eb d0                	jmp    80031f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	0f b6 d2             	movzbl %dl,%edx
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	89 75 08             	mov    %esi,0x8(%ebp)
  80035d:	eb 03                	jmp    800362 <vprintfmt+0x86>
  80035f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800362:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800365:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800369:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80036f:	83 fe 09             	cmp    $0x9,%esi
  800372:	76 eb                	jbe    80035f <vprintfmt+0x83>
  800374:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800377:	8b 75 08             	mov    0x8(%ebp),%esi
  80037a:	eb 14                	jmp    800390 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80037c:	8b 45 14             	mov    0x14(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8d 40 04             	lea    0x4(%eax),%eax
  80038a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800390:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800394:	79 89                	jns    80031f <vprintfmt+0x43>
				width = precision, precision = -1;
  800396:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800399:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a3:	e9 77 ff ff ff       	jmp    80031f <vprintfmt+0x43>
  8003a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	0f 48 c1             	cmovs  %ecx,%eax
  8003b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b6:	e9 64 ff ff ff       	jmp    80031f <vprintfmt+0x43>
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003be:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c5:	e9 55 ff ff ff       	jmp    80031f <vprintfmt+0x43>
			lflag++;
  8003ca:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d1:	e9 49 ff ff ff       	jmp    80031f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d9:	8d 78 04             	lea    0x4(%eax),%edi
  8003dc:	83 ec 08             	sub    $0x8,%esp
  8003df:	53                   	push   %ebx
  8003e0:	ff 30                	pushl  (%eax)
  8003e2:	ff d6                	call   *%esi
			break;
  8003e4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ea:	e9 33 03 00 00       	jmp    800722 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 78 04             	lea    0x4(%eax),%edi
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	99                   	cltd   
  8003f8:	31 d0                	xor    %edx,%eax
  8003fa:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fc:	83 f8 10             	cmp    $0x10,%eax
  8003ff:	7f 23                	jg     800424 <vprintfmt+0x148>
  800401:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  800408:	85 d2                	test   %edx,%edx
  80040a:	74 18                	je     800424 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80040c:	52                   	push   %edx
  80040d:	68 b9 29 80 00       	push   $0x8029b9
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 a6 fe ff ff       	call   8002bf <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041f:	e9 fe 02 00 00       	jmp    800722 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800424:	50                   	push   %eax
  800425:	68 81 25 80 00       	push   $0x802581
  80042a:	53                   	push   %ebx
  80042b:	56                   	push   %esi
  80042c:	e8 8e fe ff ff       	call   8002bf <printfmt>
  800431:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800434:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800437:	e9 e6 02 00 00       	jmp    800722 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	83 c0 04             	add    $0x4,%eax
  800442:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80044a:	85 c9                	test   %ecx,%ecx
  80044c:	b8 7a 25 80 00       	mov    $0x80257a,%eax
  800451:	0f 45 c1             	cmovne %ecx,%eax
  800454:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800457:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045b:	7e 06                	jle    800463 <vprintfmt+0x187>
  80045d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800461:	75 0d                	jne    800470 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800463:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800466:	89 c7                	mov    %eax,%edi
  800468:	03 45 e0             	add    -0x20(%ebp),%eax
  80046b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046e:	eb 53                	jmp    8004c3 <vprintfmt+0x1e7>
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 d8             	pushl  -0x28(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 71 04 00 00       	call   8008ed <strnlen>
  80047c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047f:	29 c1                	sub    %eax,%ecx
  800481:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800489:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80048d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800490:	eb 0f                	jmp    8004a1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	ff 75 e0             	pushl  -0x20(%ebp)
  800499:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049b:	83 ef 01             	sub    $0x1,%edi
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	85 ff                	test   %edi,%edi
  8004a3:	7f ed                	jg     800492 <vprintfmt+0x1b6>
  8004a5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004a8:	85 c9                	test   %ecx,%ecx
  8004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004af:	0f 49 c1             	cmovns %ecx,%eax
  8004b2:	29 c1                	sub    %eax,%ecx
  8004b4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b7:	eb aa                	jmp    800463 <vprintfmt+0x187>
					putch(ch, putdat);
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	53                   	push   %ebx
  8004bd:	52                   	push   %edx
  8004be:	ff d6                	call   *%esi
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c8:	83 c7 01             	add    $0x1,%edi
  8004cb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004cf:	0f be d0             	movsbl %al,%edx
  8004d2:	85 d2                	test   %edx,%edx
  8004d4:	74 4b                	je     800521 <vprintfmt+0x245>
  8004d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004da:	78 06                	js     8004e2 <vprintfmt+0x206>
  8004dc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e0:	78 1e                	js     800500 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e6:	74 d1                	je     8004b9 <vprintfmt+0x1dd>
  8004e8:	0f be c0             	movsbl %al,%eax
  8004eb:	83 e8 20             	sub    $0x20,%eax
  8004ee:	83 f8 5e             	cmp    $0x5e,%eax
  8004f1:	76 c6                	jbe    8004b9 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 3f                	push   $0x3f
  8004f9:	ff d6                	call   *%esi
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	eb c3                	jmp    8004c3 <vprintfmt+0x1e7>
  800500:	89 cf                	mov    %ecx,%edi
  800502:	eb 0e                	jmp    800512 <vprintfmt+0x236>
				putch(' ', putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	53                   	push   %ebx
  800508:	6a 20                	push   $0x20
  80050a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80050c:	83 ef 01             	sub    $0x1,%edi
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	85 ff                	test   %edi,%edi
  800514:	7f ee                	jg     800504 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800516:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800519:	89 45 14             	mov    %eax,0x14(%ebp)
  80051c:	e9 01 02 00 00       	jmp    800722 <vprintfmt+0x446>
  800521:	89 cf                	mov    %ecx,%edi
  800523:	eb ed                	jmp    800512 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800528:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80052f:	e9 eb fd ff ff       	jmp    80031f <vprintfmt+0x43>
	if (lflag >= 2)
  800534:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800538:	7f 21                	jg     80055b <vprintfmt+0x27f>
	else if (lflag)
  80053a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80053e:	74 68                	je     8005a8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800548:	89 c1                	mov    %eax,%ecx
  80054a:	c1 f9 1f             	sar    $0x1f,%ecx
  80054d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 40 04             	lea    0x4(%eax),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	eb 17                	jmp    800572 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 50 04             	mov    0x4(%eax),%edx
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800566:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800572:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800575:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800578:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80057e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800582:	78 3f                	js     8005c3 <vprintfmt+0x2e7>
			base = 10;
  800584:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800589:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80058d:	0f 84 71 01 00 00    	je     800704 <vprintfmt+0x428>
				putch('+', putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	6a 2b                	push   $0x2b
  800599:	ff d6                	call   *%esi
  80059b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a3:	e9 5c 01 00 00       	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b0:	89 c1                	mov    %eax,%ecx
  8005b2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	eb af                	jmp    800572 <vprintfmt+0x296>
				putch('-', putdat);
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	53                   	push   %ebx
  8005c7:	6a 2d                	push   $0x2d
  8005c9:	ff d6                	call   *%esi
				num = -(long long) num;
  8005cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d1:	f7 d8                	neg    %eax
  8005d3:	83 d2 00             	adc    $0x0,%edx
  8005d6:	f7 da                	neg    %edx
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	e9 19 01 00 00       	jmp    800704 <vprintfmt+0x428>
	if (lflag >= 2)
  8005eb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ef:	7f 29                	jg     80061a <vprintfmt+0x33e>
	else if (lflag)
  8005f1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f5:	74 44                	je     80063b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 40 04             	lea    0x4(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
  800615:	e9 ea 00 00 00       	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 50 04             	mov    0x4(%eax),%edx
  800620:	8b 00                	mov    (%eax),%eax
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800625:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 08             	lea    0x8(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800631:	b8 0a 00 00 00       	mov    $0xa,%eax
  800636:	e9 c9 00 00 00       	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	ba 00 00 00 00       	mov    $0x0,%edx
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
  800659:	e9 a6 00 00 00       	jmp    800704 <vprintfmt+0x428>
			putch('0', putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	53                   	push   %ebx
  800662:	6a 30                	push   $0x30
  800664:	ff d6                	call   *%esi
	if (lflag >= 2)
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066d:	7f 26                	jg     800695 <vprintfmt+0x3b9>
	else if (lflag)
  80066f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800673:	74 3e                	je     8006b3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068e:	b8 08 00 00 00       	mov    $0x8,%eax
  800693:	eb 6f                	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 08             	lea    0x8(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b1:	eb 51                	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d1:	eb 31                	jmp    800704 <vprintfmt+0x428>
			putch('0', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 30                	push   $0x30
  8006d9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006db:	83 c4 08             	add    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 78                	push   $0x78
  8006e1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ff:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800704:	83 ec 0c             	sub    $0xc,%esp
  800707:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80070b:	52                   	push   %edx
  80070c:	ff 75 e0             	pushl  -0x20(%ebp)
  80070f:	50                   	push   %eax
  800710:	ff 75 dc             	pushl  -0x24(%ebp)
  800713:	ff 75 d8             	pushl  -0x28(%ebp)
  800716:	89 da                	mov    %ebx,%edx
  800718:	89 f0                	mov    %esi,%eax
  80071a:	e8 a4 fa ff ff       	call   8001c3 <printnum>
			break;
  80071f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800722:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	83 c7 01             	add    $0x1,%edi
  800728:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072c:	83 f8 25             	cmp    $0x25,%eax
  80072f:	0f 84 be fb ff ff    	je     8002f3 <vprintfmt+0x17>
			if (ch == '\0')
  800735:	85 c0                	test   %eax,%eax
  800737:	0f 84 28 01 00 00    	je     800865 <vprintfmt+0x589>
			putch(ch, putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	50                   	push   %eax
  800742:	ff d6                	call   *%esi
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	eb dc                	jmp    800725 <vprintfmt+0x449>
	if (lflag >= 2)
  800749:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074d:	7f 26                	jg     800775 <vprintfmt+0x499>
	else if (lflag)
  80074f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800753:	74 41                	je     800796 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	ba 00 00 00 00       	mov    $0x0,%edx
  80075f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800762:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 40 04             	lea    0x4(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076e:	b8 10 00 00 00       	mov    $0x10,%eax
  800773:	eb 8f                	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8b 50 04             	mov    0x4(%eax),%edx
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 08             	lea    0x8(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
  800791:	e9 6e ff ff ff       	jmp    800704 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b4:	e9 4b ff ff ff       	jmp    800704 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	74 14                	je     8007df <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007cb:	8b 13                	mov    (%ebx),%edx
  8007cd:	83 fa 7f             	cmp    $0x7f,%edx
  8007d0:	7f 37                	jg     800809 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007d2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007da:	e9 43 ff ff ff       	jmp    800722 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e4:	bf 9d 26 80 00       	mov    $0x80269d,%edi
							putch(ch, putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	50                   	push   %eax
  8007ee:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f0:	83 c7 01             	add    $0x1,%edi
  8007f3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	75 eb                	jne    8007e9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
  800804:	e9 19 ff ff ff       	jmp    800722 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800809:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800810:	bf d5 26 80 00       	mov    $0x8026d5,%edi
							putch(ch, putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	50                   	push   %eax
  80081a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081c:	83 c7 01             	add    $0x1,%edi
  80081f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	85 c0                	test   %eax,%eax
  800828:	75 eb                	jne    800815 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80082a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	e9 ed fe ff ff       	jmp    800722 <vprintfmt+0x446>
			putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 25                	push   $0x25
  80083b:	ff d6                	call   *%esi
			break;
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	e9 dd fe ff ff       	jmp    800722 <vprintfmt+0x446>
			putch('%', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 25                	push   $0x25
  80084b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	89 f8                	mov    %edi,%eax
  800852:	eb 03                	jmp    800857 <vprintfmt+0x57b>
  800854:	83 e8 01             	sub    $0x1,%eax
  800857:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085b:	75 f7                	jne    800854 <vprintfmt+0x578>
  80085d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800860:	e9 bd fe ff ff       	jmp    800722 <vprintfmt+0x446>
}
  800865:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5f                   	pop    %edi
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 18             	sub    $0x18,%esp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800880:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 26                	je     8008b4 <vsnprintf+0x47>
  80088e:	85 d2                	test   %edx,%edx
  800890:	7e 22                	jle    8008b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800892:	ff 75 14             	pushl  0x14(%ebp)
  800895:	ff 75 10             	pushl  0x10(%ebp)
  800898:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	68 a2 02 80 00       	push   $0x8002a2
  8008a1:	e8 36 fa ff ff       	call   8002dc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008af:	83 c4 10             	add    $0x10,%esp
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    
		return -E_INVAL;
  8008b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b9:	eb f7                	jmp    8008b2 <vsnprintf+0x45>

008008bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c4:	50                   	push   %eax
  8008c5:	ff 75 10             	pushl  0x10(%ebp)
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 9a ff ff ff       	call   80086d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e4:	74 05                	je     8008eb <strlen+0x16>
		n++;
  8008e6:	83 c0 01             	add    $0x1,%eax
  8008e9:	eb f5                	jmp    8008e0 <strlen+0xb>
	return n;
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 0d                	je     80090c <strnlen+0x1f>
  8008ff:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800903:	74 05                	je     80090a <strnlen+0x1d>
		n++;
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	eb f1                	jmp    8008fb <strnlen+0xe>
  80090a:	89 d0                	mov    %edx,%eax
	return n;
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800921:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800924:	83 c2 01             	add    $0x1,%edx
  800927:	84 c9                	test   %cl,%cl
  800929:	75 f2                	jne    80091d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092b:	5b                   	pop    %ebx
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	53                   	push   %ebx
  800932:	83 ec 10             	sub    $0x10,%esp
  800935:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800938:	53                   	push   %ebx
  800939:	e8 97 ff ff ff       	call   8008d5 <strlen>
  80093e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	01 d8                	add    %ebx,%eax
  800946:	50                   	push   %eax
  800947:	e8 c2 ff ff ff       	call   80090e <strcpy>
	return dst;
}
  80094c:	89 d8                	mov    %ebx,%eax
  80094e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800951:	c9                   	leave  
  800952:	c3                   	ret    

00800953 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	56                   	push   %esi
  800957:	53                   	push   %ebx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095e:	89 c6                	mov    %eax,%esi
  800960:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800963:	89 c2                	mov    %eax,%edx
  800965:	39 f2                	cmp    %esi,%edx
  800967:	74 11                	je     80097a <strncpy+0x27>
		*dst++ = *src;
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	0f b6 19             	movzbl (%ecx),%ebx
  80096f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800972:	80 fb 01             	cmp    $0x1,%bl
  800975:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800978:	eb eb                	jmp    800965 <strncpy+0x12>
	}
	return ret;
}
  80097a:	5b                   	pop    %ebx
  80097b:	5e                   	pop    %esi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	8b 75 08             	mov    0x8(%ebp),%esi
  800986:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800989:	8b 55 10             	mov    0x10(%ebp),%edx
  80098c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098e:	85 d2                	test   %edx,%edx
  800990:	74 21                	je     8009b3 <strlcpy+0x35>
  800992:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800996:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800998:	39 c2                	cmp    %eax,%edx
  80099a:	74 14                	je     8009b0 <strlcpy+0x32>
  80099c:	0f b6 19             	movzbl (%ecx),%ebx
  80099f:	84 db                	test   %bl,%bl
  8009a1:	74 0b                	je     8009ae <strlcpy+0x30>
			*dst++ = *src++;
  8009a3:	83 c1 01             	add    $0x1,%ecx
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ac:	eb ea                	jmp    800998 <strlcpy+0x1a>
  8009ae:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b3:	29 f0                	sub    %esi,%eax
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c2:	0f b6 01             	movzbl (%ecx),%eax
  8009c5:	84 c0                	test   %al,%al
  8009c7:	74 0c                	je     8009d5 <strcmp+0x1c>
  8009c9:	3a 02                	cmp    (%edx),%al
  8009cb:	75 08                	jne    8009d5 <strcmp+0x1c>
		p++, q++;
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	eb ed                	jmp    8009c2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d5:	0f b6 c0             	movzbl %al,%eax
  8009d8:	0f b6 12             	movzbl (%edx),%edx
  8009db:	29 d0                	sub    %edx,%eax
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e9:	89 c3                	mov    %eax,%ebx
  8009eb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ee:	eb 06                	jmp    8009f6 <strncmp+0x17>
		n--, p++, q++;
  8009f0:	83 c0 01             	add    $0x1,%eax
  8009f3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f6:	39 d8                	cmp    %ebx,%eax
  8009f8:	74 16                	je     800a10 <strncmp+0x31>
  8009fa:	0f b6 08             	movzbl (%eax),%ecx
  8009fd:	84 c9                	test   %cl,%cl
  8009ff:	74 04                	je     800a05 <strncmp+0x26>
  800a01:	3a 0a                	cmp    (%edx),%cl
  800a03:	74 eb                	je     8009f0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a05:	0f b6 00             	movzbl (%eax),%eax
  800a08:	0f b6 12             	movzbl (%edx),%edx
  800a0b:	29 d0                	sub    %edx,%eax
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    
		return 0;
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	eb f6                	jmp    800a0d <strncmp+0x2e>

00800a17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a21:	0f b6 10             	movzbl (%eax),%edx
  800a24:	84 d2                	test   %dl,%dl
  800a26:	74 09                	je     800a31 <strchr+0x1a>
		if (*s == c)
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 0a                	je     800a36 <strchr+0x1f>
	for (; *s; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f0                	jmp    800a21 <strchr+0xa>
			return (char *) s;
	return 0;
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a42:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a45:	38 ca                	cmp    %cl,%dl
  800a47:	74 09                	je     800a52 <strfind+0x1a>
  800a49:	84 d2                	test   %dl,%dl
  800a4b:	74 05                	je     800a52 <strfind+0x1a>
	for (; *s; s++)
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	eb f0                	jmp    800a42 <strfind+0xa>
			break;
	return (char *) s;
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	57                   	push   %edi
  800a58:	56                   	push   %esi
  800a59:	53                   	push   %ebx
  800a5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a60:	85 c9                	test   %ecx,%ecx
  800a62:	74 31                	je     800a95 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a64:	89 f8                	mov    %edi,%eax
  800a66:	09 c8                	or     %ecx,%eax
  800a68:	a8 03                	test   $0x3,%al
  800a6a:	75 23                	jne    800a8f <memset+0x3b>
		c &= 0xFF;
  800a6c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a70:	89 d3                	mov    %edx,%ebx
  800a72:	c1 e3 08             	shl    $0x8,%ebx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	c1 e0 18             	shl    $0x18,%eax
  800a7a:	89 d6                	mov    %edx,%esi
  800a7c:	c1 e6 10             	shl    $0x10,%esi
  800a7f:	09 f0                	or     %esi,%eax
  800a81:	09 c2                	or     %eax,%edx
  800a83:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a85:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a88:	89 d0                	mov    %edx,%eax
  800a8a:	fc                   	cld    
  800a8b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8d:	eb 06                	jmp    800a95 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	fc                   	cld    
  800a93:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a95:	89 f8                	mov    %edi,%eax
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aaa:	39 c6                	cmp    %eax,%esi
  800aac:	73 32                	jae    800ae0 <memmove+0x44>
  800aae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	76 2b                	jbe    800ae0 <memmove+0x44>
		s += n;
		d += n;
  800ab5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab8:	89 fe                	mov    %edi,%esi
  800aba:	09 ce                	or     %ecx,%esi
  800abc:	09 d6                	or     %edx,%esi
  800abe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac4:	75 0e                	jne    800ad4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad2:	eb 09                	jmp    800add <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
  800ade:	eb 1a                	jmp    800afa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	09 ca                	or     %ecx,%edx
  800ae4:	09 f2                	or     %esi,%edx
  800ae6:	f6 c2 03             	test   $0x3,%dl
  800ae9:	75 0a                	jne    800af5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aee:	89 c7                	mov    %eax,%edi
  800af0:	fc                   	cld    
  800af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af3:	eb 05                	jmp    800afa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af5:	89 c7                	mov    %eax,%edi
  800af7:	fc                   	cld    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afa:	5e                   	pop    %esi
  800afb:	5f                   	pop    %edi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b04:	ff 75 10             	pushl  0x10(%ebp)
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 8a ff ff ff       	call   800a9c <memmove>
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	89 c6                	mov    %eax,%esi
  800b21:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b24:	39 f0                	cmp    %esi,%eax
  800b26:	74 1c                	je     800b44 <memcmp+0x30>
		if (*s1 != *s2)
  800b28:	0f b6 08             	movzbl (%eax),%ecx
  800b2b:	0f b6 1a             	movzbl (%edx),%ebx
  800b2e:	38 d9                	cmp    %bl,%cl
  800b30:	75 08                	jne    800b3a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	83 c2 01             	add    $0x1,%edx
  800b38:	eb ea                	jmp    800b24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3a:	0f b6 c1             	movzbl %cl,%eax
  800b3d:	0f b6 db             	movzbl %bl,%ebx
  800b40:	29 d8                	sub    %ebx,%eax
  800b42:	eb 05                	jmp    800b49 <memcmp+0x35>
	}

	return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5b:	39 d0                	cmp    %edx,%eax
  800b5d:	73 09                	jae    800b68 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5f:	38 08                	cmp    %cl,(%eax)
  800b61:	74 05                	je     800b68 <memfind+0x1b>
	for (; s < ends; s++)
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	eb f3                	jmp    800b5b <memfind+0xe>
			break;
	return (void *) s;
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b76:	eb 03                	jmp    800b7b <strtol+0x11>
		s++;
  800b78:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7b:	0f b6 01             	movzbl (%ecx),%eax
  800b7e:	3c 20                	cmp    $0x20,%al
  800b80:	74 f6                	je     800b78 <strtol+0xe>
  800b82:	3c 09                	cmp    $0x9,%al
  800b84:	74 f2                	je     800b78 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b86:	3c 2b                	cmp    $0x2b,%al
  800b88:	74 2a                	je     800bb4 <strtol+0x4a>
	int neg = 0;
  800b8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8f:	3c 2d                	cmp    $0x2d,%al
  800b91:	74 2b                	je     800bbe <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b93:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b99:	75 0f                	jne    800baa <strtol+0x40>
  800b9b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9e:	74 28                	je     800bc8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba0:	85 db                	test   %ebx,%ebx
  800ba2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba7:	0f 44 d8             	cmove  %eax,%ebx
  800baa:	b8 00 00 00 00       	mov    $0x0,%eax
  800baf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb2:	eb 50                	jmp    800c04 <strtol+0x9a>
		s++;
  800bb4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbc:	eb d5                	jmp    800b93 <strtol+0x29>
		s++, neg = 1;
  800bbe:	83 c1 01             	add    $0x1,%ecx
  800bc1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc6:	eb cb                	jmp    800b93 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcc:	74 0e                	je     800bdc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	75 d8                	jne    800baa <strtol+0x40>
		s++, base = 8;
  800bd2:	83 c1 01             	add    $0x1,%ecx
  800bd5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bda:	eb ce                	jmp    800baa <strtol+0x40>
		s += 2, base = 16;
  800bdc:	83 c1 02             	add    $0x2,%ecx
  800bdf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be4:	eb c4                	jmp    800baa <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be9:	89 f3                	mov    %esi,%ebx
  800beb:	80 fb 19             	cmp    $0x19,%bl
  800bee:	77 29                	ja     800c19 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf0:	0f be d2             	movsbl %dl,%edx
  800bf3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf9:	7d 30                	jge    800c2b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c02:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c04:	0f b6 11             	movzbl (%ecx),%edx
  800c07:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0a:	89 f3                	mov    %esi,%ebx
  800c0c:	80 fb 09             	cmp    $0x9,%bl
  800c0f:	77 d5                	ja     800be6 <strtol+0x7c>
			dig = *s - '0';
  800c11:	0f be d2             	movsbl %dl,%edx
  800c14:	83 ea 30             	sub    $0x30,%edx
  800c17:	eb dd                	jmp    800bf6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c19:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1c:	89 f3                	mov    %esi,%ebx
  800c1e:	80 fb 19             	cmp    $0x19,%bl
  800c21:	77 08                	ja     800c2b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c23:	0f be d2             	movsbl %dl,%edx
  800c26:	83 ea 37             	sub    $0x37,%edx
  800c29:	eb cb                	jmp    800bf6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2f:	74 05                	je     800c36 <strtol+0xcc>
		*endptr = (char *) s;
  800c31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c34:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c36:	89 c2                	mov    %eax,%edx
  800c38:	f7 da                	neg    %edx
  800c3a:	85 ff                	test   %edi,%edi
  800c3c:	0f 45 c2             	cmovne %edx,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c55:	89 c3                	mov    %eax,%ebx
  800c57:	89 c7                	mov    %eax,%edi
  800c59:	89 c6                	mov    %eax,%esi
  800c5b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c68:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c72:	89 d1                	mov    %edx,%ecx
  800c74:	89 d3                	mov    %edx,%ebx
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	b8 03 00 00 00       	mov    $0x3,%eax
  800c97:	89 cb                	mov    %ecx,%ebx
  800c99:	89 cf                	mov    %ecx,%edi
  800c9b:	89 ce                	mov    %ecx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 03                	push   $0x3
  800cb1:	68 e4 28 80 00       	push   $0x8028e4
  800cb6:	6a 43                	push   $0x43
  800cb8:	68 01 29 80 00       	push   $0x802901
  800cbd:	e8 69 14 00 00       	call   80212b <_panic>

00800cc2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccd:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd2:	89 d1                	mov    %edx,%ecx
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	89 d7                	mov    %edx,%edi
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <sys_yield>:

void
sys_yield(void)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 d3                	mov    %edx,%ebx
  800cf5:	89 d7                	mov    %edx,%edi
  800cf7:	89 d6                	mov    %edx,%esi
  800cf9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d09:	be 00 00 00 00       	mov    $0x0,%esi
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	b8 04 00 00 00       	mov    $0x4,%eax
  800d19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1c:	89 f7                	mov    %esi,%edi
  800d1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	7f 08                	jg     800d2c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	50                   	push   %eax
  800d30:	6a 04                	push   $0x4
  800d32:	68 e4 28 80 00       	push   $0x8028e4
  800d37:	6a 43                	push   $0x43
  800d39:	68 01 29 80 00       	push   $0x802901
  800d3e:	e8 e8 13 00 00       	call   80212b <_panic>

00800d43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 05 00 00 00       	mov    $0x5,%eax
  800d57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 05                	push   $0x5
  800d74:	68 e4 28 80 00       	push   $0x8028e4
  800d79:	6a 43                	push   $0x43
  800d7b:	68 01 29 80 00       	push   $0x802901
  800d80:	e8 a6 13 00 00       	call   80212b <_panic>

00800d85 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9e:	89 df                	mov    %ebx,%edi
  800da0:	89 de                	mov    %ebx,%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 06                	push   $0x6
  800db6:	68 e4 28 80 00       	push   $0x8028e4
  800dbb:	6a 43                	push   $0x43
  800dbd:	68 01 29 80 00       	push   $0x802901
  800dc2:	e8 64 13 00 00       	call   80212b <_panic>

00800dc7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	b8 08 00 00 00       	mov    $0x8,%eax
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 08                	push   $0x8
  800df8:	68 e4 28 80 00       	push   $0x8028e4
  800dfd:	6a 43                	push   $0x43
  800dff:	68 01 29 80 00       	push   $0x802901
  800e04:	e8 22 13 00 00       	call   80212b <_panic>

00800e09 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e22:	89 df                	mov    %ebx,%edi
  800e24:	89 de                	mov    %ebx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 09                	push   $0x9
  800e3a:	68 e4 28 80 00       	push   $0x8028e4
  800e3f:	6a 43                	push   $0x43
  800e41:	68 01 29 80 00       	push   $0x802901
  800e46:	e8 e0 12 00 00       	call   80212b <_panic>

00800e4b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 0a                	push   $0xa
  800e7c:	68 e4 28 80 00       	push   $0x8028e4
  800e81:	6a 43                	push   $0x43
  800e83:	68 01 29 80 00       	push   $0x802901
  800e88:	e8 9e 12 00 00       	call   80212b <_panic>

00800e8d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec6:	89 cb                	mov    %ecx,%ebx
  800ec8:	89 cf                	mov    %ecx,%edi
  800eca:	89 ce                	mov    %ecx,%esi
  800ecc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7f 08                	jg     800eda <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	50                   	push   %eax
  800ede:	6a 0d                	push   $0xd
  800ee0:	68 e4 28 80 00       	push   $0x8028e4
  800ee5:	6a 43                	push   $0x43
  800ee7:	68 01 29 80 00       	push   $0x802901
  800eec:	e8 3a 12 00 00       	call   80212b <_panic>

00800ef1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f07:	89 df                	mov    %ebx,%edi
  800f09:	89 de                	mov    %ebx,%esi
  800f0b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f25:	89 cb                	mov    %ecx,%ebx
  800f27:	89 cf                	mov    %ecx,%edi
  800f29:	89 ce                	mov    %ecx,%esi
  800f2b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f38:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f42:	89 d1                	mov    %edx,%ecx
  800f44:	89 d3                	mov    %edx,%ebx
  800f46:	89 d7                	mov    %edx,%edi
  800f48:	89 d6                	mov    %edx,%esi
  800f4a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f62:	b8 11 00 00 00       	mov    $0x11,%eax
  800f67:	89 df                	mov    %ebx,%edi
  800f69:	89 de                	mov    %ebx,%esi
  800f6b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6d:	5b                   	pop    %ebx
  800f6e:	5e                   	pop    %esi
  800f6f:	5f                   	pop    %edi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	57                   	push   %edi
  800f76:	56                   	push   %esi
  800f77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	b8 12 00 00 00       	mov    $0x12,%eax
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa7:	b8 13 00 00 00       	mov    $0x13,%eax
  800fac:	89 df                	mov    %ebx,%edi
  800fae:	89 de                	mov    %ebx,%esi
  800fb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	7f 08                	jg     800fbe <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbe:	83 ec 0c             	sub    $0xc,%esp
  800fc1:	50                   	push   %eax
  800fc2:	6a 13                	push   $0x13
  800fc4:	68 e4 28 80 00       	push   $0x8028e4
  800fc9:	6a 43                	push   $0x43
  800fcb:	68 01 29 80 00       	push   $0x802901
  800fd0:	e8 56 11 00 00       	call   80212b <_panic>

00800fd5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801004:	89 c2                	mov    %eax,%edx
  801006:	c1 ea 16             	shr    $0x16,%edx
  801009:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801010:	f6 c2 01             	test   $0x1,%dl
  801013:	74 2d                	je     801042 <fd_alloc+0x46>
  801015:	89 c2                	mov    %eax,%edx
  801017:	c1 ea 0c             	shr    $0xc,%edx
  80101a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801021:	f6 c2 01             	test   $0x1,%dl
  801024:	74 1c                	je     801042 <fd_alloc+0x46>
  801026:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80102b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801030:	75 d2                	jne    801004 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80103b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801040:	eb 0a                	jmp    80104c <fd_alloc+0x50>
			*fd_store = fd;
  801042:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801045:	89 01                	mov    %eax,(%ecx)
			return 0;
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801054:	83 f8 1f             	cmp    $0x1f,%eax
  801057:	77 30                	ja     801089 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801059:	c1 e0 0c             	shl    $0xc,%eax
  80105c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801061:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801067:	f6 c2 01             	test   $0x1,%dl
  80106a:	74 24                	je     801090 <fd_lookup+0x42>
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	c1 ea 0c             	shr    $0xc,%edx
  801071:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801078:	f6 c2 01             	test   $0x1,%dl
  80107b:	74 1a                	je     801097 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80107d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801080:	89 02                	mov    %eax,(%edx)
	return 0;
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    
		return -E_INVAL;
  801089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108e:	eb f7                	jmp    801087 <fd_lookup+0x39>
		return -E_INVAL;
  801090:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801095:	eb f0                	jmp    801087 <fd_lookup+0x39>
  801097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109c:	eb e9                	jmp    801087 <fd_lookup+0x39>

0080109e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 08             	sub    $0x8,%esp
  8010a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ac:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b1:	39 08                	cmp    %ecx,(%eax)
  8010b3:	74 38                	je     8010ed <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010b5:	83 c2 01             	add    $0x1,%edx
  8010b8:	8b 04 95 8c 29 80 00 	mov    0x80298c(,%edx,4),%eax
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	75 ee                	jne    8010b1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010c8:	8b 40 48             	mov    0x48(%eax),%eax
  8010cb:	83 ec 04             	sub    $0x4,%esp
  8010ce:	51                   	push   %ecx
  8010cf:	50                   	push   %eax
  8010d0:	68 10 29 80 00       	push   $0x802910
  8010d5:	e8 d5 f0 ff ff       	call   8001af <cprintf>
	*dev = 0;
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e3:	83 c4 10             	add    $0x10,%esp
  8010e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    
			*dev = devtab[i];
  8010ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	eb f2                	jmp    8010eb <dev_lookup+0x4d>

008010f9 <fd_close>:
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 24             	sub    $0x24,%esp
  801102:	8b 75 08             	mov    0x8(%ebp),%esi
  801105:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801108:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801112:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801115:	50                   	push   %eax
  801116:	e8 33 ff ff ff       	call   80104e <fd_lookup>
  80111b:	89 c3                	mov    %eax,%ebx
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 05                	js     801129 <fd_close+0x30>
	    || fd != fd2)
  801124:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801127:	74 16                	je     80113f <fd_close+0x46>
		return (must_exist ? r : 0);
  801129:	89 f8                	mov    %edi,%eax
  80112b:	84 c0                	test   %al,%al
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
  801132:	0f 44 d8             	cmove  %eax,%ebx
}
  801135:	89 d8                	mov    %ebx,%eax
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801145:	50                   	push   %eax
  801146:	ff 36                	pushl  (%esi)
  801148:	e8 51 ff ff ff       	call   80109e <dev_lookup>
  80114d:	89 c3                	mov    %eax,%ebx
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	78 1a                	js     801170 <fd_close+0x77>
		if (dev->dev_close)
  801156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801159:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80115c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801161:	85 c0                	test   %eax,%eax
  801163:	74 0b                	je     801170 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	56                   	push   %esi
  801169:	ff d0                	call   *%eax
  80116b:	89 c3                	mov    %eax,%ebx
  80116d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	56                   	push   %esi
  801174:	6a 00                	push   $0x0
  801176:	e8 0a fc ff ff       	call   800d85 <sys_page_unmap>
	return r;
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	eb b5                	jmp    801135 <fd_close+0x3c>

00801180 <close>:

int
close(int fdnum)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801186:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801189:	50                   	push   %eax
  80118a:	ff 75 08             	pushl  0x8(%ebp)
  80118d:	e8 bc fe ff ff       	call   80104e <fd_lookup>
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	85 c0                	test   %eax,%eax
  801197:	79 02                	jns    80119b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    
		return fd_close(fd, 1);
  80119b:	83 ec 08             	sub    $0x8,%esp
  80119e:	6a 01                	push   $0x1
  8011a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a3:	e8 51 ff ff ff       	call   8010f9 <fd_close>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	eb ec                	jmp    801199 <close+0x19>

008011ad <close_all>:

void
close_all(void)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	53                   	push   %ebx
  8011b1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011b4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	53                   	push   %ebx
  8011bd:	e8 be ff ff ff       	call   801180 <close>
	for (i = 0; i < MAXFD; i++)
  8011c2:	83 c3 01             	add    $0x1,%ebx
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	83 fb 20             	cmp    $0x20,%ebx
  8011cb:	75 ec                	jne    8011b9 <close_all+0xc>
}
  8011cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011de:	50                   	push   %eax
  8011df:	ff 75 08             	pushl  0x8(%ebp)
  8011e2:	e8 67 fe ff ff       	call   80104e <fd_lookup>
  8011e7:	89 c3                	mov    %eax,%ebx
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	0f 88 81 00 00 00    	js     801275 <dup+0xa3>
		return r;
	close(newfdnum);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	e8 81 ff ff ff       	call   801180 <close>

	newfd = INDEX2FD(newfdnum);
  8011ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801202:	c1 e6 0c             	shl    $0xc,%esi
  801205:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80120b:	83 c4 04             	add    $0x4,%esp
  80120e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801211:	e8 cf fd ff ff       	call   800fe5 <fd2data>
  801216:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801218:	89 34 24             	mov    %esi,(%esp)
  80121b:	e8 c5 fd ff ff       	call   800fe5 <fd2data>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801225:	89 d8                	mov    %ebx,%eax
  801227:	c1 e8 16             	shr    $0x16,%eax
  80122a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801231:	a8 01                	test   $0x1,%al
  801233:	74 11                	je     801246 <dup+0x74>
  801235:	89 d8                	mov    %ebx,%eax
  801237:	c1 e8 0c             	shr    $0xc,%eax
  80123a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801241:	f6 c2 01             	test   $0x1,%dl
  801244:	75 39                	jne    80127f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801246:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801249:	89 d0                	mov    %edx,%eax
  80124b:	c1 e8 0c             	shr    $0xc,%eax
  80124e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	25 07 0e 00 00       	and    $0xe07,%eax
  80125d:	50                   	push   %eax
  80125e:	56                   	push   %esi
  80125f:	6a 00                	push   $0x0
  801261:	52                   	push   %edx
  801262:	6a 00                	push   $0x0
  801264:	e8 da fa ff ff       	call   800d43 <sys_page_map>
  801269:	89 c3                	mov    %eax,%ebx
  80126b:	83 c4 20             	add    $0x20,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 31                	js     8012a3 <dup+0xd1>
		goto err;

	return newfdnum;
  801272:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801275:	89 d8                	mov    %ebx,%eax
  801277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80127f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	25 07 0e 00 00       	and    $0xe07,%eax
  80128e:	50                   	push   %eax
  80128f:	57                   	push   %edi
  801290:	6a 00                	push   $0x0
  801292:	53                   	push   %ebx
  801293:	6a 00                	push   $0x0
  801295:	e8 a9 fa ff ff       	call   800d43 <sys_page_map>
  80129a:	89 c3                	mov    %eax,%ebx
  80129c:	83 c4 20             	add    $0x20,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	79 a3                	jns    801246 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	56                   	push   %esi
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 d7 fa ff ff       	call   800d85 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ae:	83 c4 08             	add    $0x8,%esp
  8012b1:	57                   	push   %edi
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 cc fa ff ff       	call   800d85 <sys_page_unmap>
	return r;
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	eb b7                	jmp    801275 <dup+0xa3>

008012be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 1c             	sub    $0x1c,%esp
  8012c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cb:	50                   	push   %eax
  8012cc:	53                   	push   %ebx
  8012cd:	e8 7c fd ff ff       	call   80104e <fd_lookup>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 3f                	js     801318 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e3:	ff 30                	pushl  (%eax)
  8012e5:	e8 b4 fd ff ff       	call   80109e <dev_lookup>
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 27                	js     801318 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f4:	8b 42 08             	mov    0x8(%edx),%eax
  8012f7:	83 e0 03             	and    $0x3,%eax
  8012fa:	83 f8 01             	cmp    $0x1,%eax
  8012fd:	74 1e                	je     80131d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801302:	8b 40 08             	mov    0x8(%eax),%eax
  801305:	85 c0                	test   %eax,%eax
  801307:	74 35                	je     80133e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	ff 75 10             	pushl  0x10(%ebp)
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	52                   	push   %edx
  801313:	ff d0                	call   *%eax
  801315:	83 c4 10             	add    $0x10,%esp
}
  801318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80131d:	a1 08 40 80 00       	mov    0x804008,%eax
  801322:	8b 40 48             	mov    0x48(%eax),%eax
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	53                   	push   %ebx
  801329:	50                   	push   %eax
  80132a:	68 51 29 80 00       	push   $0x802951
  80132f:	e8 7b ee ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133c:	eb da                	jmp    801318 <read+0x5a>
		return -E_NOT_SUPP;
  80133e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801343:	eb d3                	jmp    801318 <read+0x5a>

00801345 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	57                   	push   %edi
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801351:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801354:	bb 00 00 00 00       	mov    $0x0,%ebx
  801359:	39 f3                	cmp    %esi,%ebx
  80135b:	73 23                	jae    801380 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	89 f0                	mov    %esi,%eax
  801362:	29 d8                	sub    %ebx,%eax
  801364:	50                   	push   %eax
  801365:	89 d8                	mov    %ebx,%eax
  801367:	03 45 0c             	add    0xc(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	57                   	push   %edi
  80136c:	e8 4d ff ff ff       	call   8012be <read>
		if (m < 0)
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	78 06                	js     80137e <readn+0x39>
			return m;
		if (m == 0)
  801378:	74 06                	je     801380 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80137a:	01 c3                	add    %eax,%ebx
  80137c:	eb db                	jmp    801359 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80137e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801380:	89 d8                	mov    %ebx,%eax
  801382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 1c             	sub    $0x1c,%esp
  801391:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801394:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	53                   	push   %ebx
  801399:	e8 b0 fc ff ff       	call   80104e <fd_lookup>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 3a                	js     8013df <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	ff 30                	pushl  (%eax)
  8013b1:	e8 e8 fc ff ff       	call   80109e <dev_lookup>
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 22                	js     8013df <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c4:	74 1e                	je     8013e4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013cc:	85 d2                	test   %edx,%edx
  8013ce:	74 35                	je     801405 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	ff 75 10             	pushl  0x10(%ebp)
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	50                   	push   %eax
  8013da:	ff d2                	call   *%edx
  8013dc:	83 c4 10             	add    $0x10,%esp
}
  8013df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013e9:	8b 40 48             	mov    0x48(%eax),%eax
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	50                   	push   %eax
  8013f1:	68 6d 29 80 00       	push   $0x80296d
  8013f6:	e8 b4 ed ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb da                	jmp    8013df <write+0x55>
		return -E_NOT_SUPP;
  801405:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140a:	eb d3                	jmp    8013df <write+0x55>

0080140c <seek>:

int
seek(int fdnum, off_t offset)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801412:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	e8 30 fc ff ff       	call   80104e <fd_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 0e                	js     801433 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801425:	8b 55 0c             	mov    0xc(%ebp),%edx
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	53                   	push   %ebx
  801439:	83 ec 1c             	sub    $0x1c,%esp
  80143c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	53                   	push   %ebx
  801444:	e8 05 fc ff ff       	call   80104e <fd_lookup>
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 37                	js     801487 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801456:	50                   	push   %eax
  801457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145a:	ff 30                	pushl  (%eax)
  80145c:	e8 3d fc ff ff       	call   80109e <dev_lookup>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	78 1f                	js     801487 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80146f:	74 1b                	je     80148c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801474:	8b 52 18             	mov    0x18(%edx),%edx
  801477:	85 d2                	test   %edx,%edx
  801479:	74 32                	je     8014ad <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	50                   	push   %eax
  801482:	ff d2                	call   *%edx
  801484:	83 c4 10             	add    $0x10,%esp
}
  801487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80148c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801491:	8b 40 48             	mov    0x48(%eax),%eax
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	53                   	push   %ebx
  801498:	50                   	push   %eax
  801499:	68 30 29 80 00       	push   $0x802930
  80149e:	e8 0c ed ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ab:	eb da                	jmp    801487 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b2:	eb d3                	jmp    801487 <ftruncate+0x52>

008014b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 1c             	sub    $0x1c,%esp
  8014bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	ff 75 08             	pushl  0x8(%ebp)
  8014c5:	e8 84 fb ff ff       	call   80104e <fd_lookup>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 4b                	js     80151c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d7:	50                   	push   %eax
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	ff 30                	pushl  (%eax)
  8014dd:	e8 bc fb ff ff       	call   80109e <dev_lookup>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 33                	js     80151c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ec:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f0:	74 2f                	je     801521 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014f5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014fc:	00 00 00 
	stat->st_isdir = 0;
  8014ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801506:	00 00 00 
	stat->st_dev = dev;
  801509:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	53                   	push   %ebx
  801513:	ff 75 f0             	pushl  -0x10(%ebp)
  801516:	ff 50 14             	call   *0x14(%eax)
  801519:	83 c4 10             	add    $0x10,%esp
}
  80151c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151f:	c9                   	leave  
  801520:	c3                   	ret    
		return -E_NOT_SUPP;
  801521:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801526:	eb f4                	jmp    80151c <fstat+0x68>

00801528 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	6a 00                	push   $0x0
  801532:	ff 75 08             	pushl  0x8(%ebp)
  801535:	e8 22 02 00 00       	call   80175c <open>
  80153a:	89 c3                	mov    %eax,%ebx
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 1b                	js     80155e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	50                   	push   %eax
  80154a:	e8 65 ff ff ff       	call   8014b4 <fstat>
  80154f:	89 c6                	mov    %eax,%esi
	close(fd);
  801551:	89 1c 24             	mov    %ebx,(%esp)
  801554:	e8 27 fc ff ff       	call   801180 <close>
	return r;
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 f3                	mov    %esi,%ebx
}
  80155e:	89 d8                	mov    %ebx,%eax
  801560:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801563:	5b                   	pop    %ebx
  801564:	5e                   	pop    %esi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	89 c6                	mov    %eax,%esi
  80156e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801570:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801577:	74 27                	je     8015a0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801579:	6a 07                	push   $0x7
  80157b:	68 00 50 80 00       	push   $0x805000
  801580:	56                   	push   %esi
  801581:	ff 35 00 40 80 00    	pushl  0x804000
  801587:	e8 69 0c 00 00       	call   8021f5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80158c:	83 c4 0c             	add    $0xc,%esp
  80158f:	6a 00                	push   $0x0
  801591:	53                   	push   %ebx
  801592:	6a 00                	push   $0x0
  801594:	e8 f3 0b 00 00       	call   80218c <ipc_recv>
}
  801599:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	6a 01                	push   $0x1
  8015a5:	e8 a3 0c 00 00       	call   80224d <ipc_find_env>
  8015aa:	a3 00 40 80 00       	mov    %eax,0x804000
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	eb c5                	jmp    801579 <fsipc+0x12>

008015b4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d7:	e8 8b ff ff ff       	call   801567 <fsipc>
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <devfile_flush>:
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ea:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8015f9:	e8 69 ff ff ff       	call   801567 <fsipc>
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <devfile_stat>:
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	53                   	push   %ebx
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8b 40 0c             	mov    0xc(%eax),%eax
  801610:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b8 05 00 00 00       	mov    $0x5,%eax
  80161f:	e8 43 ff ff ff       	call   801567 <fsipc>
  801624:	85 c0                	test   %eax,%eax
  801626:	78 2c                	js     801654 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	68 00 50 80 00       	push   $0x805000
  801630:	53                   	push   %ebx
  801631:	e8 d8 f2 ff ff       	call   80090e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801636:	a1 80 50 80 00       	mov    0x805080,%eax
  80163b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801641:	a1 84 50 80 00       	mov    0x805084,%eax
  801646:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <devfile_write>:
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8b 40 0c             	mov    0xc(%eax),%eax
  801669:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80166e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801674:	53                   	push   %ebx
  801675:	ff 75 0c             	pushl  0xc(%ebp)
  801678:	68 08 50 80 00       	push   $0x805008
  80167d:	e8 7c f4 ff ff       	call   800afe <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801682:	ba 00 00 00 00       	mov    $0x0,%edx
  801687:	b8 04 00 00 00       	mov    $0x4,%eax
  80168c:	e8 d6 fe ff ff       	call   801567 <fsipc>
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	85 c0                	test   %eax,%eax
  801696:	78 0b                	js     8016a3 <devfile_write+0x4a>
	assert(r <= n);
  801698:	39 d8                	cmp    %ebx,%eax
  80169a:	77 0c                	ja     8016a8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80169c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a1:	7f 1e                	jg     8016c1 <devfile_write+0x68>
}
  8016a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    
	assert(r <= n);
  8016a8:	68 a0 29 80 00       	push   $0x8029a0
  8016ad:	68 a7 29 80 00       	push   $0x8029a7
  8016b2:	68 98 00 00 00       	push   $0x98
  8016b7:	68 bc 29 80 00       	push   $0x8029bc
  8016bc:	e8 6a 0a 00 00       	call   80212b <_panic>
	assert(r <= PGSIZE);
  8016c1:	68 c7 29 80 00       	push   $0x8029c7
  8016c6:	68 a7 29 80 00       	push   $0x8029a7
  8016cb:	68 99 00 00 00       	push   $0x99
  8016d0:	68 bc 29 80 00       	push   $0x8029bc
  8016d5:	e8 51 0a 00 00       	call   80212b <_panic>

008016da <devfile_read>:
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
  8016df:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ed:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8016fd:	e8 65 fe ff ff       	call   801567 <fsipc>
  801702:	89 c3                	mov    %eax,%ebx
  801704:	85 c0                	test   %eax,%eax
  801706:	78 1f                	js     801727 <devfile_read+0x4d>
	assert(r <= n);
  801708:	39 f0                	cmp    %esi,%eax
  80170a:	77 24                	ja     801730 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80170c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801711:	7f 33                	jg     801746 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	50                   	push   %eax
  801717:	68 00 50 80 00       	push   $0x805000
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	e8 78 f3 ff ff       	call   800a9c <memmove>
	return r;
  801724:	83 c4 10             	add    $0x10,%esp
}
  801727:	89 d8                	mov    %ebx,%eax
  801729:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172c:	5b                   	pop    %ebx
  80172d:	5e                   	pop    %esi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    
	assert(r <= n);
  801730:	68 a0 29 80 00       	push   $0x8029a0
  801735:	68 a7 29 80 00       	push   $0x8029a7
  80173a:	6a 7c                	push   $0x7c
  80173c:	68 bc 29 80 00       	push   $0x8029bc
  801741:	e8 e5 09 00 00       	call   80212b <_panic>
	assert(r <= PGSIZE);
  801746:	68 c7 29 80 00       	push   $0x8029c7
  80174b:	68 a7 29 80 00       	push   $0x8029a7
  801750:	6a 7d                	push   $0x7d
  801752:	68 bc 29 80 00       	push   $0x8029bc
  801757:	e8 cf 09 00 00       	call   80212b <_panic>

0080175c <open>:
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	83 ec 1c             	sub    $0x1c,%esp
  801764:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801767:	56                   	push   %esi
  801768:	e8 68 f1 ff ff       	call   8008d5 <strlen>
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801775:	7f 6c                	jg     8017e3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801777:	83 ec 0c             	sub    $0xc,%esp
  80177a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	e8 79 f8 ff ff       	call   800ffc <fd_alloc>
  801783:	89 c3                	mov    %eax,%ebx
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 3c                	js     8017c8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	56                   	push   %esi
  801790:	68 00 50 80 00       	push   $0x805000
  801795:	e8 74 f1 ff ff       	call   80090e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017aa:	e8 b8 fd ff ff       	call   801567 <fsipc>
  8017af:	89 c3                	mov    %eax,%ebx
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 19                	js     8017d1 <open+0x75>
	return fd2num(fd);
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017be:	e8 12 f8 ff ff       	call   800fd5 <fd2num>
  8017c3:	89 c3                	mov    %eax,%ebx
  8017c5:	83 c4 10             	add    $0x10,%esp
}
  8017c8:	89 d8                	mov    %ebx,%eax
  8017ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    
		fd_close(fd, 0);
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d9:	e8 1b f9 ff ff       	call   8010f9 <fd_close>
		return r;
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	eb e5                	jmp    8017c8 <open+0x6c>
		return -E_BAD_PATH;
  8017e3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017e8:	eb de                	jmp    8017c8 <open+0x6c>

008017ea <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8017fa:	e8 68 fd ff ff       	call   801567 <fsipc>
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801807:	68 d3 29 80 00       	push   $0x8029d3
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	e8 fa f0 ff ff       	call   80090e <strcpy>
	return 0;
}
  801814:	b8 00 00 00 00       	mov    $0x0,%eax
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <devsock_close>:
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	53                   	push   %ebx
  80181f:	83 ec 10             	sub    $0x10,%esp
  801822:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801825:	53                   	push   %ebx
  801826:	e8 5d 0a 00 00       	call   802288 <pageref>
  80182b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801833:	83 f8 01             	cmp    $0x1,%eax
  801836:	74 07                	je     80183f <devsock_close+0x24>
}
  801838:	89 d0                	mov    %edx,%eax
  80183a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	ff 73 0c             	pushl  0xc(%ebx)
  801845:	e8 b9 02 00 00       	call   801b03 <nsipc_close>
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	eb e7                	jmp    801838 <devsock_close+0x1d>

00801851 <devsock_write>:
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801857:	6a 00                	push   $0x0
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	ff 70 0c             	pushl  0xc(%eax)
  801865:	e8 76 03 00 00       	call   801be0 <nsipc_send>
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <devsock_read>:
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801872:	6a 00                	push   $0x0
  801874:	ff 75 10             	pushl  0x10(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	ff 70 0c             	pushl  0xc(%eax)
  801880:	e8 ef 02 00 00       	call   801b74 <nsipc_recv>
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <fd2sockid>:
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80188d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801890:	52                   	push   %edx
  801891:	50                   	push   %eax
  801892:	e8 b7 f7 ff ff       	call   80104e <fd_lookup>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 10                	js     8018ae <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018a7:	39 08                	cmp    %ecx,(%eax)
  8018a9:	75 05                	jne    8018b0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018ab:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b5:	eb f7                	jmp    8018ae <fd2sockid+0x27>

008018b7 <alloc_sockfd>:
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 1c             	sub    $0x1c,%esp
  8018bf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c4:	50                   	push   %eax
  8018c5:	e8 32 f7 ff ff       	call   800ffc <fd_alloc>
  8018ca:	89 c3                	mov    %eax,%ebx
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 43                	js     801916 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 07 04 00 00       	push   $0x407
  8018db:	ff 75 f4             	pushl  -0xc(%ebp)
  8018de:	6a 00                	push   $0x0
  8018e0:	e8 1b f4 ff ff       	call   800d00 <sys_page_alloc>
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 28                	js     801916 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801903:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	50                   	push   %eax
  80190a:	e8 c6 f6 ff ff       	call   800fd5 <fd2num>
  80190f:	89 c3                	mov    %eax,%ebx
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	eb 0c                	jmp    801922 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801916:	83 ec 0c             	sub    $0xc,%esp
  801919:	56                   	push   %esi
  80191a:	e8 e4 01 00 00       	call   801b03 <nsipc_close>
		return r;
  80191f:	83 c4 10             	add    $0x10,%esp
}
  801922:	89 d8                	mov    %ebx,%eax
  801924:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801927:	5b                   	pop    %ebx
  801928:	5e                   	pop    %esi
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <accept>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	e8 4e ff ff ff       	call   801887 <fd2sockid>
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 1b                	js     801958 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	ff 75 10             	pushl  0x10(%ebp)
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	50                   	push   %eax
  801947:	e8 0e 01 00 00       	call   801a5a <nsipc_accept>
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 05                	js     801958 <accept+0x2d>
	return alloc_sockfd(r);
  801953:	e8 5f ff ff ff       	call   8018b7 <alloc_sockfd>
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <bind>:
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	e8 1f ff ff ff       	call   801887 <fd2sockid>
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 12                	js     80197e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	ff 75 10             	pushl  0x10(%ebp)
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	e8 31 01 00 00       	call   801aac <nsipc_bind>
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <shutdown>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	e8 f9 fe ff ff       	call   801887 <fd2sockid>
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 0f                	js     8019a1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	50                   	push   %eax
  801999:	e8 43 01 00 00       	call   801ae1 <nsipc_shutdown>
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <connect>:
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	e8 d6 fe ff ff       	call   801887 <fd2sockid>
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 12                	js     8019c7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	e8 59 01 00 00       	call   801b1d <nsipc_connect>
  8019c4:	83 c4 10             	add    $0x10,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <listen>:
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	e8 b0 fe ff ff       	call   801887 <fd2sockid>
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 0f                	js     8019ea <listen+0x21>
	return nsipc_listen(r, backlog);
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	50                   	push   %eax
  8019e2:	e8 6b 01 00 00       	call   801b52 <nsipc_listen>
  8019e7:	83 c4 10             	add    $0x10,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <socket>:

int
socket(int domain, int type, int protocol)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019f2:	ff 75 10             	pushl  0x10(%ebp)
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	e8 3e 02 00 00       	call   801c3e <nsipc_socket>
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 05                	js     801a0c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a07:	e8 ab fe ff ff       	call   8018b7 <alloc_sockfd>
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	53                   	push   %ebx
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a17:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a1e:	74 26                	je     801a46 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a20:	6a 07                	push   $0x7
  801a22:	68 00 60 80 00       	push   $0x806000
  801a27:	53                   	push   %ebx
  801a28:	ff 35 04 40 80 00    	pushl  0x804004
  801a2e:	e8 c2 07 00 00       	call   8021f5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a33:	83 c4 0c             	add    $0xc,%esp
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	e8 4b 07 00 00       	call   80218c <ipc_recv>
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	6a 02                	push   $0x2
  801a4b:	e8 fd 07 00 00       	call   80224d <ipc_find_env>
  801a50:	a3 04 40 80 00       	mov    %eax,0x804004
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	eb c6                	jmp    801a20 <nsipc+0x12>

00801a5a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a6a:	8b 06                	mov    (%esi),%eax
  801a6c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
  801a76:	e8 93 ff ff ff       	call   801a0e <nsipc>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	79 09                	jns    801a8a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a81:	89 d8                	mov    %ebx,%eax
  801a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	ff 35 10 60 80 00    	pushl  0x806010
  801a93:	68 00 60 80 00       	push   $0x806000
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	e8 fc ef ff ff       	call   800a9c <memmove>
		*addrlen = ret->ret_addrlen;
  801aa0:	a1 10 60 80 00       	mov    0x806010,%eax
  801aa5:	89 06                	mov    %eax,(%esi)
  801aa7:	83 c4 10             	add    $0x10,%esp
	return r;
  801aaa:	eb d5                	jmp    801a81 <nsipc_accept+0x27>

00801aac <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801abe:	53                   	push   %ebx
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	68 04 60 80 00       	push   $0x806004
  801ac7:	e8 d0 ef ff ff       	call   800a9c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801acc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ad2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ad7:	e8 32 ff ff ff       	call   801a0e <nsipc>
}
  801adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801af7:	b8 03 00 00 00       	mov    $0x3,%eax
  801afc:	e8 0d ff ff ff       	call   801a0e <nsipc>
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <nsipc_close>:

int
nsipc_close(int s)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b11:	b8 04 00 00 00       	mov    $0x4,%eax
  801b16:	e8 f3 fe ff ff       	call   801a0e <nsipc>
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	53                   	push   %ebx
  801b21:	83 ec 08             	sub    $0x8,%esp
  801b24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b2f:	53                   	push   %ebx
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	68 04 60 80 00       	push   $0x806004
  801b38:	e8 5f ef ff ff       	call   800a9c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b3d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b43:	b8 05 00 00 00       	mov    $0x5,%eax
  801b48:	e8 c1 fe ff ff       	call   801a0e <nsipc>
}
  801b4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b68:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6d:	e8 9c fe ff ff       	call   801a0e <nsipc>
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	56                   	push   %esi
  801b78:	53                   	push   %ebx
  801b79:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b84:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b92:	b8 07 00 00 00       	mov    $0x7,%eax
  801b97:	e8 72 fe ff ff       	call   801a0e <nsipc>
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 1f                	js     801bc1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ba2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ba7:	7f 21                	jg     801bca <nsipc_recv+0x56>
  801ba9:	39 c6                	cmp    %eax,%esi
  801bab:	7c 1d                	jl     801bca <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	50                   	push   %eax
  801bb1:	68 00 60 80 00       	push   $0x806000
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	e8 de ee ff ff       	call   800a9c <memmove>
  801bbe:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bc1:	89 d8                	mov    %ebx,%eax
  801bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bca:	68 df 29 80 00       	push   $0x8029df
  801bcf:	68 a7 29 80 00       	push   $0x8029a7
  801bd4:	6a 62                	push   $0x62
  801bd6:	68 f4 29 80 00       	push   $0x8029f4
  801bdb:	e8 4b 05 00 00       	call   80212b <_panic>

00801be0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	53                   	push   %ebx
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bf2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bf8:	7f 2e                	jg     801c28 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	53                   	push   %ebx
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	68 0c 60 80 00       	push   $0x80600c
  801c06:	e8 91 ee ff ff       	call   800a9c <memmove>
	nsipcbuf.send.req_size = size;
  801c0b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c11:	8b 45 14             	mov    0x14(%ebp),%eax
  801c14:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c19:	b8 08 00 00 00       	mov    $0x8,%eax
  801c1e:	e8 eb fd ff ff       	call   801a0e <nsipc>
}
  801c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    
	assert(size < 1600);
  801c28:	68 00 2a 80 00       	push   $0x802a00
  801c2d:	68 a7 29 80 00       	push   $0x8029a7
  801c32:	6a 6d                	push   $0x6d
  801c34:	68 f4 29 80 00       	push   $0x8029f4
  801c39:	e8 ed 04 00 00       	call   80212b <_panic>

00801c3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c54:	8b 45 10             	mov    0x10(%ebp),%eax
  801c57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801c61:	e8 a8 fd ff ff       	call   801a0e <nsipc>
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	56                   	push   %esi
  801c6c:	53                   	push   %ebx
  801c6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 6a f3 ff ff       	call   800fe5 <fd2data>
  801c7b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c7d:	83 c4 08             	add    $0x8,%esp
  801c80:	68 0c 2a 80 00       	push   $0x802a0c
  801c85:	53                   	push   %ebx
  801c86:	e8 83 ec ff ff       	call   80090e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c8b:	8b 46 04             	mov    0x4(%esi),%eax
  801c8e:	2b 06                	sub    (%esi),%eax
  801c90:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c96:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9d:	00 00 00 
	stat->st_dev = &devpipe;
  801ca0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ca7:	30 80 00 
	return 0;
}
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
  801caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 0c             	sub    $0xc,%esp
  801cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cc0:	53                   	push   %ebx
  801cc1:	6a 00                	push   $0x0
  801cc3:	e8 bd f0 ff ff       	call   800d85 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cc8:	89 1c 24             	mov    %ebx,(%esp)
  801ccb:	e8 15 f3 ff ff       	call   800fe5 <fd2data>
  801cd0:	83 c4 08             	add    $0x8,%esp
  801cd3:	50                   	push   %eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	e8 aa f0 ff ff       	call   800d85 <sys_page_unmap>
}
  801cdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <_pipeisclosed>:
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	57                   	push   %edi
  801ce4:	56                   	push   %esi
  801ce5:	53                   	push   %ebx
  801ce6:	83 ec 1c             	sub    $0x1c,%esp
  801ce9:	89 c7                	mov    %eax,%edi
  801ceb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ced:	a1 08 40 80 00       	mov    0x804008,%eax
  801cf2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	57                   	push   %edi
  801cf9:	e8 8a 05 00 00       	call   802288 <pageref>
  801cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d01:	89 34 24             	mov    %esi,(%esp)
  801d04:	e8 7f 05 00 00       	call   802288 <pageref>
		nn = thisenv->env_runs;
  801d09:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d0f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	39 cb                	cmp    %ecx,%ebx
  801d17:	74 1b                	je     801d34 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d19:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1c:	75 cf                	jne    801ced <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d1e:	8b 42 58             	mov    0x58(%edx),%eax
  801d21:	6a 01                	push   $0x1
  801d23:	50                   	push   %eax
  801d24:	53                   	push   %ebx
  801d25:	68 13 2a 80 00       	push   $0x802a13
  801d2a:	e8 80 e4 ff ff       	call   8001af <cprintf>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	eb b9                	jmp    801ced <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d34:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d37:	0f 94 c0             	sete   %al
  801d3a:	0f b6 c0             	movzbl %al,%eax
}
  801d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <devpipe_write>:
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	57                   	push   %edi
  801d49:	56                   	push   %esi
  801d4a:	53                   	push   %ebx
  801d4b:	83 ec 28             	sub    $0x28,%esp
  801d4e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d51:	56                   	push   %esi
  801d52:	e8 8e f2 ff ff       	call   800fe5 <fd2data>
  801d57:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d61:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d64:	74 4f                	je     801db5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d66:	8b 43 04             	mov    0x4(%ebx),%eax
  801d69:	8b 0b                	mov    (%ebx),%ecx
  801d6b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d6e:	39 d0                	cmp    %edx,%eax
  801d70:	72 14                	jb     801d86 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d72:	89 da                	mov    %ebx,%edx
  801d74:	89 f0                	mov    %esi,%eax
  801d76:	e8 65 ff ff ff       	call   801ce0 <_pipeisclosed>
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	75 3b                	jne    801dba <devpipe_write+0x75>
			sys_yield();
  801d7f:	e8 5d ef ff ff       	call   800ce1 <sys_yield>
  801d84:	eb e0                	jmp    801d66 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d89:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d8d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d90:	89 c2                	mov    %eax,%edx
  801d92:	c1 fa 1f             	sar    $0x1f,%edx
  801d95:	89 d1                	mov    %edx,%ecx
  801d97:	c1 e9 1b             	shr    $0x1b,%ecx
  801d9a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d9d:	83 e2 1f             	and    $0x1f,%edx
  801da0:	29 ca                	sub    %ecx,%edx
  801da2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801da6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801daa:	83 c0 01             	add    $0x1,%eax
  801dad:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801db0:	83 c7 01             	add    $0x1,%edi
  801db3:	eb ac                	jmp    801d61 <devpipe_write+0x1c>
	return i;
  801db5:	8b 45 10             	mov    0x10(%ebp),%eax
  801db8:	eb 05                	jmp    801dbf <devpipe_write+0x7a>
				return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc2:	5b                   	pop    %ebx
  801dc3:	5e                   	pop    %esi
  801dc4:	5f                   	pop    %edi
  801dc5:	5d                   	pop    %ebp
  801dc6:	c3                   	ret    

00801dc7 <devpipe_read>:
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	57                   	push   %edi
  801dcb:	56                   	push   %esi
  801dcc:	53                   	push   %ebx
  801dcd:	83 ec 18             	sub    $0x18,%esp
  801dd0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dd3:	57                   	push   %edi
  801dd4:	e8 0c f2 ff ff       	call   800fe5 <fd2data>
  801dd9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	be 00 00 00 00       	mov    $0x0,%esi
  801de3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801de6:	75 14                	jne    801dfc <devpipe_read+0x35>
	return i;
  801de8:	8b 45 10             	mov    0x10(%ebp),%eax
  801deb:	eb 02                	jmp    801def <devpipe_read+0x28>
				return i;
  801ded:	89 f0                	mov    %esi,%eax
}
  801def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5f                   	pop    %edi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    
			sys_yield();
  801df7:	e8 e5 ee ff ff       	call   800ce1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dfc:	8b 03                	mov    (%ebx),%eax
  801dfe:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e01:	75 18                	jne    801e1b <devpipe_read+0x54>
			if (i > 0)
  801e03:	85 f6                	test   %esi,%esi
  801e05:	75 e6                	jne    801ded <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e07:	89 da                	mov    %ebx,%edx
  801e09:	89 f8                	mov    %edi,%eax
  801e0b:	e8 d0 fe ff ff       	call   801ce0 <_pipeisclosed>
  801e10:	85 c0                	test   %eax,%eax
  801e12:	74 e3                	je     801df7 <devpipe_read+0x30>
				return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	eb d4                	jmp    801def <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e1b:	99                   	cltd   
  801e1c:	c1 ea 1b             	shr    $0x1b,%edx
  801e1f:	01 d0                	add    %edx,%eax
  801e21:	83 e0 1f             	and    $0x1f,%eax
  801e24:	29 d0                	sub    %edx,%eax
  801e26:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e2e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e31:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e34:	83 c6 01             	add    $0x1,%esi
  801e37:	eb aa                	jmp    801de3 <devpipe_read+0x1c>

00801e39 <pipe>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	56                   	push   %esi
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e44:	50                   	push   %eax
  801e45:	e8 b2 f1 ff ff       	call   800ffc <fd_alloc>
  801e4a:	89 c3                	mov    %eax,%ebx
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	0f 88 23 01 00 00    	js     801f7a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 07 04 00 00       	push   $0x407
  801e5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e62:	6a 00                	push   $0x0
  801e64:	e8 97 ee ff ff       	call   800d00 <sys_page_alloc>
  801e69:	89 c3                	mov    %eax,%ebx
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	0f 88 04 01 00 00    	js     801f7a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e7c:	50                   	push   %eax
  801e7d:	e8 7a f1 ff ff       	call   800ffc <fd_alloc>
  801e82:	89 c3                	mov    %eax,%ebx
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	85 c0                	test   %eax,%eax
  801e89:	0f 88 db 00 00 00    	js     801f6a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	68 07 04 00 00       	push   $0x407
  801e97:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9a:	6a 00                	push   $0x0
  801e9c:	e8 5f ee ff ff       	call   800d00 <sys_page_alloc>
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	0f 88 bc 00 00 00    	js     801f6a <pipe+0x131>
	va = fd2data(fd0);
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb4:	e8 2c f1 ff ff       	call   800fe5 <fd2data>
  801eb9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebb:	83 c4 0c             	add    $0xc,%esp
  801ebe:	68 07 04 00 00       	push   $0x407
  801ec3:	50                   	push   %eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	e8 35 ee ff ff       	call   800d00 <sys_page_alloc>
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	0f 88 82 00 00 00    	js     801f5a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed8:	83 ec 0c             	sub    $0xc,%esp
  801edb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ede:	e8 02 f1 ff ff       	call   800fe5 <fd2data>
  801ee3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eea:	50                   	push   %eax
  801eeb:	6a 00                	push   $0x0
  801eed:	56                   	push   %esi
  801eee:	6a 00                	push   $0x0
  801ef0:	e8 4e ee ff ff       	call   800d43 <sys_page_map>
  801ef5:	89 c3                	mov    %eax,%ebx
  801ef7:	83 c4 20             	add    $0x20,%esp
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 4e                	js     801f4c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801efe:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f15:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	e8 a9 f0 ff ff       	call   800fd5 <fd2num>
  801f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f2f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f31:	83 c4 04             	add    $0x4,%esp
  801f34:	ff 75 f0             	pushl  -0x10(%ebp)
  801f37:	e8 99 f0 ff ff       	call   800fd5 <fd2num>
  801f3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f4a:	eb 2e                	jmp    801f7a <pipe+0x141>
	sys_page_unmap(0, va);
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	56                   	push   %esi
  801f50:	6a 00                	push   $0x0
  801f52:	e8 2e ee ff ff       	call   800d85 <sys_page_unmap>
  801f57:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f60:	6a 00                	push   $0x0
  801f62:	e8 1e ee ff ff       	call   800d85 <sys_page_unmap>
  801f67:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f6a:	83 ec 08             	sub    $0x8,%esp
  801f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f70:	6a 00                	push   $0x0
  801f72:	e8 0e ee ff ff       	call   800d85 <sys_page_unmap>
  801f77:	83 c4 10             	add    $0x10,%esp
}
  801f7a:	89 d8                	mov    %ebx,%eax
  801f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5d                   	pop    %ebp
  801f82:	c3                   	ret    

00801f83 <pipeisclosed>:
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	ff 75 08             	pushl  0x8(%ebp)
  801f90:	e8 b9 f0 ff ff       	call   80104e <fd_lookup>
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	78 18                	js     801fb4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	e8 3e f0 ff ff       	call   800fe5 <fd2data>
	return _pipeisclosed(fd, p);
  801fa7:	89 c2                	mov    %eax,%edx
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	e8 2f fd ff ff       	call   801ce0 <_pipeisclosed>
  801fb1:	83 c4 10             	add    $0x10,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	c3                   	ret    

00801fbc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc2:	68 2b 2a 80 00       	push   $0x802a2b
  801fc7:	ff 75 0c             	pushl  0xc(%ebp)
  801fca:	e8 3f e9 ff ff       	call   80090e <strcpy>
	return 0;
}
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <devcons_write>:
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	57                   	push   %edi
  801fda:	56                   	push   %esi
  801fdb:	53                   	push   %ebx
  801fdc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fed:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff0:	73 31                	jae    802023 <devcons_write+0x4d>
		m = n - tot;
  801ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff5:	29 f3                	sub    %esi,%ebx
  801ff7:	83 fb 7f             	cmp    $0x7f,%ebx
  801ffa:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fff:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	53                   	push   %ebx
  802006:	89 f0                	mov    %esi,%eax
  802008:	03 45 0c             	add    0xc(%ebp),%eax
  80200b:	50                   	push   %eax
  80200c:	57                   	push   %edi
  80200d:	e8 8a ea ff ff       	call   800a9c <memmove>
		sys_cputs(buf, m);
  802012:	83 c4 08             	add    $0x8,%esp
  802015:	53                   	push   %ebx
  802016:	57                   	push   %edi
  802017:	e8 28 ec ff ff       	call   800c44 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80201c:	01 de                	add    %ebx,%esi
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	eb ca                	jmp    801fed <devcons_write+0x17>
}
  802023:	89 f0                	mov    %esi,%eax
  802025:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802028:	5b                   	pop    %ebx
  802029:	5e                   	pop    %esi
  80202a:	5f                   	pop    %edi
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    

0080202d <devcons_read>:
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802038:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203c:	74 21                	je     80205f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80203e:	e8 1f ec ff ff       	call   800c62 <sys_cgetc>
  802043:	85 c0                	test   %eax,%eax
  802045:	75 07                	jne    80204e <devcons_read+0x21>
		sys_yield();
  802047:	e8 95 ec ff ff       	call   800ce1 <sys_yield>
  80204c:	eb f0                	jmp    80203e <devcons_read+0x11>
	if (c < 0)
  80204e:	78 0f                	js     80205f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802050:	83 f8 04             	cmp    $0x4,%eax
  802053:	74 0c                	je     802061 <devcons_read+0x34>
	*(char*)vbuf = c;
  802055:	8b 55 0c             	mov    0xc(%ebp),%edx
  802058:	88 02                	mov    %al,(%edx)
	return 1;
  80205a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    
		return 0;
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	eb f7                	jmp    80205f <devcons_read+0x32>

00802068 <cputchar>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802074:	6a 01                	push   $0x1
  802076:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802079:	50                   	push   %eax
  80207a:	e8 c5 eb ff ff       	call   800c44 <sys_cputs>
}
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <getchar>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208a:	6a 01                	push   $0x1
  80208c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80208f:	50                   	push   %eax
  802090:	6a 00                	push   $0x0
  802092:	e8 27 f2 ff ff       	call   8012be <read>
	if (r < 0)
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	78 06                	js     8020a4 <getchar+0x20>
	if (r < 1)
  80209e:	74 06                	je     8020a6 <getchar+0x22>
	return c;
  8020a0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    
		return -E_EOF;
  8020a6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ab:	eb f7                	jmp    8020a4 <getchar+0x20>

008020ad <iscons>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b6:	50                   	push   %eax
  8020b7:	ff 75 08             	pushl  0x8(%ebp)
  8020ba:	e8 8f ef ff ff       	call   80104e <fd_lookup>
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 11                	js     8020d7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020cf:	39 10                	cmp    %edx,(%eax)
  8020d1:	0f 94 c0             	sete   %al
  8020d4:	0f b6 c0             	movzbl %al,%eax
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <opencons>:
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	e8 14 ef ff ff       	call   800ffc <fd_alloc>
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 3a                	js     802129 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 07 04 00 00       	push   $0x407
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	6a 00                	push   $0x0
  8020fc:	e8 ff eb ff ff       	call   800d00 <sys_page_alloc>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	85 c0                	test   %eax,%eax
  802106:	78 21                	js     802129 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802111:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	50                   	push   %eax
  802121:	e8 af ee ff ff       	call   800fd5 <fd2num>
  802126:	83 c4 10             	add    $0x10,%esp
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802130:	a1 08 40 80 00       	mov    0x804008,%eax
  802135:	8b 40 48             	mov    0x48(%eax),%eax
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 68 2a 80 00       	push   $0x802a68
  802140:	50                   	push   %eax
  802141:	68 37 2a 80 00       	push   $0x802a37
  802146:	e8 64 e0 ff ff       	call   8001af <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80214b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80214e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802154:	e8 69 eb ff ff       	call   800cc2 <sys_getenvid>
  802159:	83 c4 04             	add    $0x4,%esp
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	ff 75 08             	pushl  0x8(%ebp)
  802162:	56                   	push   %esi
  802163:	50                   	push   %eax
  802164:	68 44 2a 80 00       	push   $0x802a44
  802169:	e8 41 e0 ff ff       	call   8001af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80216e:	83 c4 18             	add    $0x18,%esp
  802171:	53                   	push   %ebx
  802172:	ff 75 10             	pushl  0x10(%ebp)
  802175:	e8 e4 df ff ff       	call   80015e <vcprintf>
	cprintf("\n");
  80217a:	c7 04 24 5d 25 80 00 	movl   $0x80255d,(%esp)
  802181:	e8 29 e0 ff ff       	call   8001af <cprintf>
  802186:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802189:	cc                   	int3   
  80218a:	eb fd                	jmp    802189 <_panic+0x5e>

0080218c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	56                   	push   %esi
  802190:	53                   	push   %ebx
  802191:	8b 75 08             	mov    0x8(%ebp),%esi
  802194:	8b 45 0c             	mov    0xc(%ebp),%eax
  802197:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80219a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80219c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021a1:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021a4:	83 ec 0c             	sub    $0xc,%esp
  8021a7:	50                   	push   %eax
  8021a8:	e8 03 ed ff ff       	call   800eb0 <sys_ipc_recv>
	if(ret < 0){
  8021ad:	83 c4 10             	add    $0x10,%esp
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	78 2b                	js     8021df <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021b4:	85 f6                	test   %esi,%esi
  8021b6:	74 0a                	je     8021c2 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021b8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021bd:	8b 40 74             	mov    0x74(%eax),%eax
  8021c0:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021c2:	85 db                	test   %ebx,%ebx
  8021c4:	74 0a                	je     8021d0 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021cb:	8b 40 78             	mov    0x78(%eax),%eax
  8021ce:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8021d5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5e                   	pop    %esi
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    
		if(from_env_store)
  8021df:	85 f6                	test   %esi,%esi
  8021e1:	74 06                	je     8021e9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021e3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021e9:	85 db                	test   %ebx,%ebx
  8021eb:	74 eb                	je     8021d8 <ipc_recv+0x4c>
			*perm_store = 0;
  8021ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021f3:	eb e3                	jmp    8021d8 <ipc_recv+0x4c>

008021f5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	57                   	push   %edi
  8021f9:	56                   	push   %esi
  8021fa:	53                   	push   %ebx
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  802201:	8b 75 0c             	mov    0xc(%ebp),%esi
  802204:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802207:	85 db                	test   %ebx,%ebx
  802209:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80220e:	0f 44 d8             	cmove  %eax,%ebx
  802211:	eb 05                	jmp    802218 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802213:	e8 c9 ea ff ff       	call   800ce1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802218:	ff 75 14             	pushl  0x14(%ebp)
  80221b:	53                   	push   %ebx
  80221c:	56                   	push   %esi
  80221d:	57                   	push   %edi
  80221e:	e8 6a ec ff ff       	call   800e8d <sys_ipc_try_send>
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	74 1b                	je     802245 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80222a:	79 e7                	jns    802213 <ipc_send+0x1e>
  80222c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80222f:	74 e2                	je     802213 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 6f 2a 80 00       	push   $0x802a6f
  802239:	6a 48                	push   $0x48
  80223b:	68 84 2a 80 00       	push   $0x802a84
  802240:	e8 e6 fe ff ff       	call   80212b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802248:	5b                   	pop    %ebx
  802249:	5e                   	pop    %esi
  80224a:	5f                   	pop    %edi
  80224b:	5d                   	pop    %ebp
  80224c:	c3                   	ret    

0080224d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802258:	89 c2                	mov    %eax,%edx
  80225a:	c1 e2 07             	shl    $0x7,%edx
  80225d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802263:	8b 52 50             	mov    0x50(%edx),%edx
  802266:	39 ca                	cmp    %ecx,%edx
  802268:	74 11                	je     80227b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80226a:	83 c0 01             	add    $0x1,%eax
  80226d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802272:	75 e4                	jne    802258 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802274:	b8 00 00 00 00       	mov    $0x0,%eax
  802279:	eb 0b                	jmp    802286 <ipc_find_env+0x39>
			return envs[i].env_id;
  80227b:	c1 e0 07             	shl    $0x7,%eax
  80227e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802283:	8b 40 48             	mov    0x48(%eax),%eax
}
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    

00802288 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80228e:	89 d0                	mov    %edx,%eax
  802290:	c1 e8 16             	shr    $0x16,%eax
  802293:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80229f:	f6 c1 01             	test   $0x1,%cl
  8022a2:	74 1d                	je     8022c1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022a4:	c1 ea 0c             	shr    $0xc,%edx
  8022a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022ae:	f6 c2 01             	test   $0x1,%dl
  8022b1:	74 0e                	je     8022c1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022b3:	c1 ea 0c             	shr    $0xc,%edx
  8022b6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022bd:	ef 
  8022be:	0f b7 c0             	movzwl %ax,%eax
}
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	66 90                	xchg   %ax,%ax
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
