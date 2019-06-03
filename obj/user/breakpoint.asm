
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	57                   	push   %edi
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800045:	00 00 00 
	envid_t find = sys_getenvid();
  800048:	e8 4c 0c 00 00       	call   800c99 <sys_getenvid>
  80004d:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800053:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800058:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005d:	bf 01 00 00 00       	mov    $0x1,%edi
  800062:	eb 0b                	jmp    80006f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800064:	83 c2 01             	add    $0x1,%edx
  800067:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006d:	74 21                	je     800090 <libmain+0x5b>
		if(envs[i].env_id == find)
  80006f:	89 d1                	mov    %edx,%ecx
  800071:	c1 e1 07             	shl    $0x7,%ecx
  800074:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007d:	39 c1                	cmp    %eax,%ecx
  80007f:	75 e3                	jne    800064 <libmain+0x2f>
  800081:	89 d3                	mov    %edx,%ebx
  800083:	c1 e3 07             	shl    $0x7,%ebx
  800086:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008c:	89 fe                	mov    %edi,%esi
  80008e:	eb d4                	jmp    800064 <libmain+0x2f>
  800090:	89 f0                	mov    %esi,%eax
  800092:	84 c0                	test   %al,%al
  800094:	74 06                	je     80009c <libmain+0x67>
  800096:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x77>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 00 25 80 00       	push   $0x802500
  8000b4:	e8 cd 00 00 00       	call   800186 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000b9:	83 c4 08             	add    $0x8,%esp
  8000bc:	ff 75 0c             	pushl  0xc(%ebp)
  8000bf:	ff 75 08             	pushl  0x8(%ebp)
  8000c2:	e8 6c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c7:	e8 0b 00 00 00       	call   8000d7 <exit>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000dd:	e8 a2 10 00 00       	call   801184 <close_all>
	sys_env_destroy(0);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	6a 00                	push   $0x0
  8000e7:	e8 6c 0b 00 00       	call   800c58 <sys_env_destroy>
}
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	53                   	push   %ebx
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fb:	8b 13                	mov    (%ebx),%edx
  8000fd:	8d 42 01             	lea    0x1(%edx),%eax
  800100:	89 03                	mov    %eax,(%ebx)
  800102:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800105:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800109:	3d ff 00 00 00       	cmp    $0xff,%eax
  80010e:	74 09                	je     800119 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800110:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800117:	c9                   	leave  
  800118:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	68 ff 00 00 00       	push   $0xff
  800121:	8d 43 08             	lea    0x8(%ebx),%eax
  800124:	50                   	push   %eax
  800125:	e8 f1 0a 00 00       	call   800c1b <sys_cputs>
		b->idx = 0;
  80012a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	eb db                	jmp    800110 <putch+0x1f>

00800135 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80013e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800145:	00 00 00 
	b.cnt = 0;
  800148:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015e:	50                   	push   %eax
  80015f:	68 f1 00 80 00       	push   $0x8000f1
  800164:	e8 4a 01 00 00       	call   8002b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800169:	83 c4 08             	add    $0x8,%esp
  80016c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800172:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	e8 9d 0a 00 00       	call   800c1b <sys_cputs>

	return b.cnt;
}
  80017e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800184:	c9                   	leave  
  800185:	c3                   	ret    

00800186 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80018f:	50                   	push   %eax
  800190:	ff 75 08             	pushl  0x8(%ebp)
  800193:	e8 9d ff ff ff       	call   800135 <vcprintf>
	va_end(ap);

	return cnt;
}
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	57                   	push   %edi
  80019e:	56                   	push   %esi
  80019f:	53                   	push   %ebx
  8001a0:	83 ec 1c             	sub    $0x1c,%esp
  8001a3:	89 c6                	mov    %eax,%esi
  8001a5:	89 d7                	mov    %edx,%edi
  8001a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001b9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001bd:	74 2c                	je     8001eb <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001cc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001cf:	39 c2                	cmp    %eax,%edx
  8001d1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d4:	73 43                	jae    800219 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001d6:	83 eb 01             	sub    $0x1,%ebx
  8001d9:	85 db                	test   %ebx,%ebx
  8001db:	7e 6c                	jle    800249 <printnum+0xaf>
				putch(padc, putdat);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	57                   	push   %edi
  8001e1:	ff 75 18             	pushl  0x18(%ebp)
  8001e4:	ff d6                	call   *%esi
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	eb eb                	jmp    8001d6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	6a 20                	push   $0x20
  8001f0:	6a 00                	push   $0x0
  8001f2:	50                   	push   %eax
  8001f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f9:	89 fa                	mov    %edi,%edx
  8001fb:	89 f0                	mov    %esi,%eax
  8001fd:	e8 98 ff ff ff       	call   80019a <printnum>
		while (--width > 0)
  800202:	83 c4 20             	add    $0x20,%esp
  800205:	83 eb 01             	sub    $0x1,%ebx
  800208:	85 db                	test   %ebx,%ebx
  80020a:	7e 65                	jle    800271 <printnum+0xd7>
			putch(padc, putdat);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	57                   	push   %edi
  800210:	6a 20                	push   $0x20
  800212:	ff d6                	call   *%esi
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb ec                	jmp    800205 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 18             	pushl  0x18(%ebp)
  80021f:	83 eb 01             	sub    $0x1,%ebx
  800222:	53                   	push   %ebx
  800223:	50                   	push   %eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	ff 75 dc             	pushl  -0x24(%ebp)
  80022a:	ff 75 d8             	pushl  -0x28(%ebp)
  80022d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800230:	ff 75 e0             	pushl  -0x20(%ebp)
  800233:	e8 68 20 00 00       	call   8022a0 <__udivdi3>
  800238:	83 c4 18             	add    $0x18,%esp
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	89 fa                	mov    %edi,%edx
  80023f:	89 f0                	mov    %esi,%eax
  800241:	e8 54 ff ff ff       	call   80019a <printnum>
  800246:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	57                   	push   %edi
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	e8 4f 21 00 00       	call   8023b0 <__umoddi3>
  800261:	83 c4 14             	add    $0x14,%esp
  800264:	0f be 80 17 25 80 00 	movsbl 0x802517(%eax),%eax
  80026b:	50                   	push   %eax
  80026c:	ff d6                	call   *%esi
  80026e:	83 c4 10             	add    $0x10,%esp
	}
}
  800271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800274:	5b                   	pop    %ebx
  800275:	5e                   	pop    %esi
  800276:	5f                   	pop    %edi
  800277:	5d                   	pop    %ebp
  800278:	c3                   	ret    

00800279 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800283:	8b 10                	mov    (%eax),%edx
  800285:	3b 50 04             	cmp    0x4(%eax),%edx
  800288:	73 0a                	jae    800294 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028d:	89 08                	mov    %ecx,(%eax)
  80028f:	8b 45 08             	mov    0x8(%ebp),%eax
  800292:	88 02                	mov    %al,(%edx)
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <printfmt>:
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029f:	50                   	push   %eax
  8002a0:	ff 75 10             	pushl  0x10(%ebp)
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 05 00 00 00       	call   8002b3 <vprintfmt>
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <vprintfmt>:
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 3c             	sub    $0x3c,%esp
  8002bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c5:	e9 32 04 00 00       	jmp    8006fc <vprintfmt+0x449>
		padc = ' ';
  8002ca:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002ce:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002d5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002ea:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002f1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f6:	8d 47 01             	lea    0x1(%edi),%eax
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	0f b6 17             	movzbl (%edi),%edx
  8002ff:	8d 42 dd             	lea    -0x23(%edx),%eax
  800302:	3c 55                	cmp    $0x55,%al
  800304:	0f 87 12 05 00 00    	ja     80081c <vprintfmt+0x569>
  80030a:	0f b6 c0             	movzbl %al,%eax
  80030d:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800314:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800317:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80031b:	eb d9                	jmp    8002f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800320:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800324:	eb d0                	jmp    8002f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800326:	0f b6 d2             	movzbl %dl,%edx
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	89 75 08             	mov    %esi,0x8(%ebp)
  800334:	eb 03                	jmp    800339 <vprintfmt+0x86>
  800336:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800339:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800340:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800343:	8d 72 d0             	lea    -0x30(%edx),%esi
  800346:	83 fe 09             	cmp    $0x9,%esi
  800349:	76 eb                	jbe    800336 <vprintfmt+0x83>
  80034b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034e:	8b 75 08             	mov    0x8(%ebp),%esi
  800351:	eb 14                	jmp    800367 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800353:	8b 45 14             	mov    0x14(%ebp),%eax
  800356:	8b 00                	mov    (%eax),%eax
  800358:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8d 40 04             	lea    0x4(%eax),%eax
  800361:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800367:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80036b:	79 89                	jns    8002f6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80036d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800370:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800373:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80037a:	e9 77 ff ff ff       	jmp    8002f6 <vprintfmt+0x43>
  80037f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800382:	85 c0                	test   %eax,%eax
  800384:	0f 48 c1             	cmovs  %ecx,%eax
  800387:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038d:	e9 64 ff ff ff       	jmp    8002f6 <vprintfmt+0x43>
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800395:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80039c:	e9 55 ff ff ff       	jmp    8002f6 <vprintfmt+0x43>
			lflag++;
  8003a1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003a8:	e9 49 ff ff ff       	jmp    8002f6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 78 04             	lea    0x4(%eax),%edi
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	53                   	push   %ebx
  8003b7:	ff 30                	pushl  (%eax)
  8003b9:	ff d6                	call   *%esi
			break;
  8003bb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003be:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c1:	e9 33 03 00 00       	jmp    8006f9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8d 78 04             	lea    0x4(%eax),%edi
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	99                   	cltd   
  8003cf:	31 d0                	xor    %edx,%eax
  8003d1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d3:	83 f8 10             	cmp    $0x10,%eax
  8003d6:	7f 23                	jg     8003fb <vprintfmt+0x148>
  8003d8:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003df:	85 d2                	test   %edx,%edx
  8003e1:	74 18                	je     8003fb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003e3:	52                   	push   %edx
  8003e4:	68 79 29 80 00       	push   $0x802979
  8003e9:	53                   	push   %ebx
  8003ea:	56                   	push   %esi
  8003eb:	e8 a6 fe ff ff       	call   800296 <printfmt>
  8003f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f6:	e9 fe 02 00 00       	jmp    8006f9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003fb:	50                   	push   %eax
  8003fc:	68 2f 25 80 00       	push   $0x80252f
  800401:	53                   	push   %ebx
  800402:	56                   	push   %esi
  800403:	e8 8e fe ff ff       	call   800296 <printfmt>
  800408:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040e:	e9 e6 02 00 00       	jmp    8006f9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	83 c0 04             	add    $0x4,%eax
  800419:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800421:	85 c9                	test   %ecx,%ecx
  800423:	b8 28 25 80 00       	mov    $0x802528,%eax
  800428:	0f 45 c1             	cmovne %ecx,%eax
  80042b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80042e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800432:	7e 06                	jle    80043a <vprintfmt+0x187>
  800434:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800438:	75 0d                	jne    800447 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80043d:	89 c7                	mov    %eax,%edi
  80043f:	03 45 e0             	add    -0x20(%ebp),%eax
  800442:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800445:	eb 53                	jmp    80049a <vprintfmt+0x1e7>
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 d8             	pushl  -0x28(%ebp)
  80044d:	50                   	push   %eax
  80044e:	e8 71 04 00 00       	call   8008c4 <strnlen>
  800453:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800456:	29 c1                	sub    %eax,%ecx
  800458:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800460:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800467:	eb 0f                	jmp    800478 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	53                   	push   %ebx
  80046d:	ff 75 e0             	pushl  -0x20(%ebp)
  800470:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800472:	83 ef 01             	sub    $0x1,%edi
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	85 ff                	test   %edi,%edi
  80047a:	7f ed                	jg     800469 <vprintfmt+0x1b6>
  80047c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80047f:	85 c9                	test   %ecx,%ecx
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	0f 49 c1             	cmovns %ecx,%eax
  800489:	29 c1                	sub    %eax,%ecx
  80048b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80048e:	eb aa                	jmp    80043a <vprintfmt+0x187>
					putch(ch, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	52                   	push   %edx
  800495:	ff d6                	call   *%esi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049f:	83 c7 01             	add    $0x1,%edi
  8004a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a6:	0f be d0             	movsbl %al,%edx
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	74 4b                	je     8004f8 <vprintfmt+0x245>
  8004ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b1:	78 06                	js     8004b9 <vprintfmt+0x206>
  8004b3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b7:	78 1e                	js     8004d7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004bd:	74 d1                	je     800490 <vprintfmt+0x1dd>
  8004bf:	0f be c0             	movsbl %al,%eax
  8004c2:	83 e8 20             	sub    $0x20,%eax
  8004c5:	83 f8 5e             	cmp    $0x5e,%eax
  8004c8:	76 c6                	jbe    800490 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	53                   	push   %ebx
  8004ce:	6a 3f                	push   $0x3f
  8004d0:	ff d6                	call   *%esi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	eb c3                	jmp    80049a <vprintfmt+0x1e7>
  8004d7:	89 cf                	mov    %ecx,%edi
  8004d9:	eb 0e                	jmp    8004e9 <vprintfmt+0x236>
				putch(' ', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 20                	push   $0x20
  8004e1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e3:	83 ef 01             	sub    $0x1,%edi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	7f ee                	jg     8004db <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f3:	e9 01 02 00 00       	jmp    8006f9 <vprintfmt+0x446>
  8004f8:	89 cf                	mov    %ecx,%edi
  8004fa:	eb ed                	jmp    8004e9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004ff:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800506:	e9 eb fd ff ff       	jmp    8002f6 <vprintfmt+0x43>
	if (lflag >= 2)
  80050b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80050f:	7f 21                	jg     800532 <vprintfmt+0x27f>
	else if (lflag)
  800511:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800515:	74 68                	je     80057f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80051f:	89 c1                	mov    %eax,%ecx
  800521:	c1 f9 1f             	sar    $0x1f,%ecx
  800524:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 40 04             	lea    0x4(%eax),%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
  800530:	eb 17                	jmp    800549 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8b 50 04             	mov    0x4(%eax),%edx
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80053d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 40 08             	lea    0x8(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800549:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80054c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80054f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800552:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800555:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800559:	78 3f                	js     80059a <vprintfmt+0x2e7>
			base = 10;
  80055b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800560:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800564:	0f 84 71 01 00 00    	je     8006db <vprintfmt+0x428>
				putch('+', putdat);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	53                   	push   %ebx
  80056e:	6a 2b                	push   $0x2b
  800570:	ff d6                	call   *%esi
  800572:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800575:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057a:	e9 5c 01 00 00       	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, int);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800587:	89 c1                	mov    %eax,%ecx
  800589:	c1 f9 1f             	sar    $0x1f,%ecx
  80058c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	eb af                	jmp    800549 <vprintfmt+0x296>
				putch('-', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 2d                	push   $0x2d
  8005a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a8:	f7 d8                	neg    %eax
  8005aa:	83 d2 00             	adc    $0x0,%edx
  8005ad:	f7 da                	neg    %edx
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bd:	e9 19 01 00 00       	jmp    8006db <vprintfmt+0x428>
	if (lflag >= 2)
  8005c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c6:	7f 29                	jg     8005f1 <vprintfmt+0x33e>
	else if (lflag)
  8005c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cc:	74 44                	je     800612 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ec:	e9 ea 00 00 00       	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 08             	lea    0x8(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060d:	e9 c9 00 00 00       	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 40 04             	lea    0x4(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800630:	e9 a6 00 00 00       	jmp    8006db <vprintfmt+0x428>
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 30                	push   $0x30
  80063b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800644:	7f 26                	jg     80066c <vprintfmt+0x3b9>
	else if (lflag)
  800646:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064a:	74 3e                	je     80068a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	ba 00 00 00 00       	mov    $0x0,%edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800665:	b8 08 00 00 00       	mov    $0x8,%eax
  80066a:	eb 6f                	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 50 04             	mov    0x4(%eax),%edx
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 08             	lea    0x8(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800683:	b8 08 00 00 00       	mov    $0x8,%eax
  800688:	eb 51                	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800697:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a8:	eb 31                	jmp    8006db <vprintfmt+0x428>
			putch('0', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	6a 30                	push   $0x30
  8006b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b2:	83 c4 08             	add    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 78                	push   $0x78
  8006b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006e2:	52                   	push   %edx
  8006e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8006ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ed:	89 da                	mov    %ebx,%edx
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	e8 a4 fa ff ff       	call   80019a <printnum>
			break;
  8006f6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fc:	83 c7 01             	add    $0x1,%edi
  8006ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800703:	83 f8 25             	cmp    $0x25,%eax
  800706:	0f 84 be fb ff ff    	je     8002ca <vprintfmt+0x17>
			if (ch == '\0')
  80070c:	85 c0                	test   %eax,%eax
  80070e:	0f 84 28 01 00 00    	je     80083c <vprintfmt+0x589>
			putch(ch, putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	50                   	push   %eax
  800719:	ff d6                	call   *%esi
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	eb dc                	jmp    8006fc <vprintfmt+0x449>
	if (lflag >= 2)
  800720:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800724:	7f 26                	jg     80074c <vprintfmt+0x499>
	else if (lflag)
  800726:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072a:	74 41                	je     80076d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800745:	b8 10 00 00 00       	mov    $0x10,%eax
  80074a:	eb 8f                	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 50 04             	mov    0x4(%eax),%edx
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800757:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 08             	lea    0x8(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800763:	b8 10 00 00 00       	mov    $0x10,%eax
  800768:	e9 6e ff ff ff       	jmp    8006db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800786:	b8 10 00 00 00       	mov    $0x10,%eax
  80078b:	e9 4b ff ff ff       	jmp    8006db <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	83 c0 04             	add    $0x4,%eax
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	74 14                	je     8007b6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007a2:	8b 13                	mov    (%ebx),%edx
  8007a4:	83 fa 7f             	cmp    $0x7f,%edx
  8007a7:	7f 37                	jg     8007e0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007a9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b1:	e9 43 ff ff ff       	jmp    8006f9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bb:	bf 4d 26 80 00       	mov    $0x80264d,%edi
							putch(ch, putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	53                   	push   %ebx
  8007c4:	50                   	push   %eax
  8007c5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007c7:	83 c7 01             	add    $0x1,%edi
  8007ca:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	85 c0                	test   %eax,%eax
  8007d3:	75 eb                	jne    8007c0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007db:	e9 19 ff ff ff       	jmp    8006f9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007e0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e7:	bf 85 26 80 00       	mov    $0x802685,%edi
							putch(ch, putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	50                   	push   %eax
  8007f1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f3:	83 c7 01             	add    $0x1,%edi
  8007f6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	75 eb                	jne    8007ec <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800801:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	e9 ed fe ff ff       	jmp    8006f9 <vprintfmt+0x446>
			putch(ch, putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	6a 25                	push   $0x25
  800812:	ff d6                	call   *%esi
			break;
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	e9 dd fe ff ff       	jmp    8006f9 <vprintfmt+0x446>
			putch('%', putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	6a 25                	push   $0x25
  800822:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	89 f8                	mov    %edi,%eax
  800829:	eb 03                	jmp    80082e <vprintfmt+0x57b>
  80082b:	83 e8 01             	sub    $0x1,%eax
  80082e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800832:	75 f7                	jne    80082b <vprintfmt+0x578>
  800834:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800837:	e9 bd fe ff ff       	jmp    8006f9 <vprintfmt+0x446>
}
  80083c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083f:	5b                   	pop    %ebx
  800840:	5e                   	pop    %esi
  800841:	5f                   	pop    %edi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 18             	sub    $0x18,%esp
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800850:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800853:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800857:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800861:	85 c0                	test   %eax,%eax
  800863:	74 26                	je     80088b <vsnprintf+0x47>
  800865:	85 d2                	test   %edx,%edx
  800867:	7e 22                	jle    80088b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800869:	ff 75 14             	pushl  0x14(%ebp)
  80086c:	ff 75 10             	pushl  0x10(%ebp)
  80086f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800872:	50                   	push   %eax
  800873:	68 79 02 80 00       	push   $0x800279
  800878:	e8 36 fa ff ff       	call   8002b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800880:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800886:	83 c4 10             	add    $0x10,%esp
}
  800889:	c9                   	leave  
  80088a:	c3                   	ret    
		return -E_INVAL;
  80088b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800890:	eb f7                	jmp    800889 <vsnprintf+0x45>

00800892 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800898:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089b:	50                   	push   %eax
  80089c:	ff 75 10             	pushl  0x10(%ebp)
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	ff 75 08             	pushl  0x8(%ebp)
  8008a5:	e8 9a ff ff ff       	call   800844 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bb:	74 05                	je     8008c2 <strlen+0x16>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
  8008c0:	eb f5                	jmp    8008b7 <strlen+0xb>
	return n;
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	39 c2                	cmp    %eax,%edx
  8008d4:	74 0d                	je     8008e3 <strnlen+0x1f>
  8008d6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008da:	74 05                	je     8008e1 <strnlen+0x1d>
		n++;
  8008dc:	83 c2 01             	add    $0x1,%edx
  8008df:	eb f1                	jmp    8008d2 <strnlen+0xe>
  8008e1:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	53                   	push   %ebx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008f8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008fb:	83 c2 01             	add    $0x1,%edx
  8008fe:	84 c9                	test   %cl,%cl
  800900:	75 f2                	jne    8008f4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800902:	5b                   	pop    %ebx
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	53                   	push   %ebx
  800909:	83 ec 10             	sub    $0x10,%esp
  80090c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090f:	53                   	push   %ebx
  800910:	e8 97 ff ff ff       	call   8008ac <strlen>
  800915:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	01 d8                	add    %ebx,%eax
  80091d:	50                   	push   %eax
  80091e:	e8 c2 ff ff ff       	call   8008e5 <strcpy>
	return dst;
}
  800923:	89 d8                	mov    %ebx,%eax
  800925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800935:	89 c6                	mov    %eax,%esi
  800937:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093a:	89 c2                	mov    %eax,%edx
  80093c:	39 f2                	cmp    %esi,%edx
  80093e:	74 11                	je     800951 <strncpy+0x27>
		*dst++ = *src;
  800940:	83 c2 01             	add    $0x1,%edx
  800943:	0f b6 19             	movzbl (%ecx),%ebx
  800946:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800949:	80 fb 01             	cmp    $0x1,%bl
  80094c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80094f:	eb eb                	jmp    80093c <strncpy+0x12>
	}
	return ret;
}
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	8b 75 08             	mov    0x8(%ebp),%esi
  80095d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800960:	8b 55 10             	mov    0x10(%ebp),%edx
  800963:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800965:	85 d2                	test   %edx,%edx
  800967:	74 21                	je     80098a <strlcpy+0x35>
  800969:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80096f:	39 c2                	cmp    %eax,%edx
  800971:	74 14                	je     800987 <strlcpy+0x32>
  800973:	0f b6 19             	movzbl (%ecx),%ebx
  800976:	84 db                	test   %bl,%bl
  800978:	74 0b                	je     800985 <strlcpy+0x30>
			*dst++ = *src++;
  80097a:	83 c1 01             	add    $0x1,%ecx
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	88 5a ff             	mov    %bl,-0x1(%edx)
  800983:	eb ea                	jmp    80096f <strlcpy+0x1a>
  800985:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800987:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098a:	29 f0                	sub    %esi,%eax
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800999:	0f b6 01             	movzbl (%ecx),%eax
  80099c:	84 c0                	test   %al,%al
  80099e:	74 0c                	je     8009ac <strcmp+0x1c>
  8009a0:	3a 02                	cmp    (%edx),%al
  8009a2:	75 08                	jne    8009ac <strcmp+0x1c>
		p++, q++;
  8009a4:	83 c1 01             	add    $0x1,%ecx
  8009a7:	83 c2 01             	add    $0x1,%edx
  8009aa:	eb ed                	jmp    800999 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ac:	0f b6 c0             	movzbl %al,%eax
  8009af:	0f b6 12             	movzbl (%edx),%edx
  8009b2:	29 d0                	sub    %edx,%eax
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c0:	89 c3                	mov    %eax,%ebx
  8009c2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c5:	eb 06                	jmp    8009cd <strncmp+0x17>
		n--, p++, q++;
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009cd:	39 d8                	cmp    %ebx,%eax
  8009cf:	74 16                	je     8009e7 <strncmp+0x31>
  8009d1:	0f b6 08             	movzbl (%eax),%ecx
  8009d4:	84 c9                	test   %cl,%cl
  8009d6:	74 04                	je     8009dc <strncmp+0x26>
  8009d8:	3a 0a                	cmp    (%edx),%cl
  8009da:	74 eb                	je     8009c7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dc:	0f b6 00             	movzbl (%eax),%eax
  8009df:	0f b6 12             	movzbl (%edx),%edx
  8009e2:	29 d0                	sub    %edx,%eax
}
  8009e4:	5b                   	pop    %ebx
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    
		return 0;
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ec:	eb f6                	jmp    8009e4 <strncmp+0x2e>

008009ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f8:	0f b6 10             	movzbl (%eax),%edx
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	74 09                	je     800a08 <strchr+0x1a>
		if (*s == c)
  8009ff:	38 ca                	cmp    %cl,%dl
  800a01:	74 0a                	je     800a0d <strchr+0x1f>
	for (; *s; s++)
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	eb f0                	jmp    8009f8 <strchr+0xa>
			return (char *) s;
	return 0;
  800a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	74 09                	je     800a29 <strfind+0x1a>
  800a20:	84 d2                	test   %dl,%dl
  800a22:	74 05                	je     800a29 <strfind+0x1a>
	for (; *s; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f0                	jmp    800a19 <strfind+0xa>
			break;
	return (char *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a37:	85 c9                	test   %ecx,%ecx
  800a39:	74 31                	je     800a6c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3b:	89 f8                	mov    %edi,%eax
  800a3d:	09 c8                	or     %ecx,%eax
  800a3f:	a8 03                	test   $0x3,%al
  800a41:	75 23                	jne    800a66 <memset+0x3b>
		c &= 0xFF;
  800a43:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a47:	89 d3                	mov    %edx,%ebx
  800a49:	c1 e3 08             	shl    $0x8,%ebx
  800a4c:	89 d0                	mov    %edx,%eax
  800a4e:	c1 e0 18             	shl    $0x18,%eax
  800a51:	89 d6                	mov    %edx,%esi
  800a53:	c1 e6 10             	shl    $0x10,%esi
  800a56:	09 f0                	or     %esi,%eax
  800a58:	09 c2                	or     %eax,%edx
  800a5a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5f:	89 d0                	mov    %edx,%eax
  800a61:	fc                   	cld    
  800a62:	f3 ab                	rep stos %eax,%es:(%edi)
  800a64:	eb 06                	jmp    800a6c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	fc                   	cld    
  800a6a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6c:	89 f8                	mov    %edi,%eax
  800a6e:	5b                   	pop    %ebx
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a81:	39 c6                	cmp    %eax,%esi
  800a83:	73 32                	jae    800ab7 <memmove+0x44>
  800a85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	76 2b                	jbe    800ab7 <memmove+0x44>
		s += n;
		d += n;
  800a8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	89 fe                	mov    %edi,%esi
  800a91:	09 ce                	or     %ecx,%esi
  800a93:	09 d6                	or     %edx,%esi
  800a95:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9b:	75 0e                	jne    800aab <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9d:	83 ef 04             	sub    $0x4,%edi
  800aa0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa6:	fd                   	std    
  800aa7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa9:	eb 09                	jmp    800ab4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aab:	83 ef 01             	sub    $0x1,%edi
  800aae:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab1:	fd                   	std    
  800ab2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab4:	fc                   	cld    
  800ab5:	eb 1a                	jmp    800ad1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab7:	89 c2                	mov    %eax,%edx
  800ab9:	09 ca                	or     %ecx,%edx
  800abb:	09 f2                	or     %esi,%edx
  800abd:	f6 c2 03             	test   $0x3,%dl
  800ac0:	75 0a                	jne    800acc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac5:	89 c7                	mov    %eax,%edi
  800ac7:	fc                   	cld    
  800ac8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aca:	eb 05                	jmp    800ad1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad1:	5e                   	pop    %esi
  800ad2:	5f                   	pop    %edi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adb:	ff 75 10             	pushl  0x10(%ebp)
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 8a ff ff ff       	call   800a73 <memmove>
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	56                   	push   %esi
  800aef:	53                   	push   %ebx
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	89 c6                	mov    %eax,%esi
  800af8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afb:	39 f0                	cmp    %esi,%eax
  800afd:	74 1c                	je     800b1b <memcmp+0x30>
		if (*s1 != *s2)
  800aff:	0f b6 08             	movzbl (%eax),%ecx
  800b02:	0f b6 1a             	movzbl (%edx),%ebx
  800b05:	38 d9                	cmp    %bl,%cl
  800b07:	75 08                	jne    800b11 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b09:	83 c0 01             	add    $0x1,%eax
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	eb ea                	jmp    800afb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b11:	0f b6 c1             	movzbl %cl,%eax
  800b14:	0f b6 db             	movzbl %bl,%ebx
  800b17:	29 d8                	sub    %ebx,%eax
  800b19:	eb 05                	jmp    800b20 <memcmp+0x35>
	}

	return 0;
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2d:	89 c2                	mov    %eax,%edx
  800b2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b32:	39 d0                	cmp    %edx,%eax
  800b34:	73 09                	jae    800b3f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b36:	38 08                	cmp    %cl,(%eax)
  800b38:	74 05                	je     800b3f <memfind+0x1b>
	for (; s < ends; s++)
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	eb f3                	jmp    800b32 <memfind+0xe>
			break;
	return (void *) s;
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	57                   	push   %edi
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
  800b47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4d:	eb 03                	jmp    800b52 <strtol+0x11>
		s++;
  800b4f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b52:	0f b6 01             	movzbl (%ecx),%eax
  800b55:	3c 20                	cmp    $0x20,%al
  800b57:	74 f6                	je     800b4f <strtol+0xe>
  800b59:	3c 09                	cmp    $0x9,%al
  800b5b:	74 f2                	je     800b4f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5d:	3c 2b                	cmp    $0x2b,%al
  800b5f:	74 2a                	je     800b8b <strtol+0x4a>
	int neg = 0;
  800b61:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b66:	3c 2d                	cmp    $0x2d,%al
  800b68:	74 2b                	je     800b95 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b70:	75 0f                	jne    800b81 <strtol+0x40>
  800b72:	80 39 30             	cmpb   $0x30,(%ecx)
  800b75:	74 28                	je     800b9f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b77:	85 db                	test   %ebx,%ebx
  800b79:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7e:	0f 44 d8             	cmove  %eax,%ebx
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b89:	eb 50                	jmp    800bdb <strtol+0x9a>
		s++;
  800b8b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b93:	eb d5                	jmp    800b6a <strtol+0x29>
		s++, neg = 1;
  800b95:	83 c1 01             	add    $0x1,%ecx
  800b98:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9d:	eb cb                	jmp    800b6a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba3:	74 0e                	je     800bb3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba5:	85 db                	test   %ebx,%ebx
  800ba7:	75 d8                	jne    800b81 <strtol+0x40>
		s++, base = 8;
  800ba9:	83 c1 01             	add    $0x1,%ecx
  800bac:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb1:	eb ce                	jmp    800b81 <strtol+0x40>
		s += 2, base = 16;
  800bb3:	83 c1 02             	add    $0x2,%ecx
  800bb6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbb:	eb c4                	jmp    800b81 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bbd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc0:	89 f3                	mov    %esi,%ebx
  800bc2:	80 fb 19             	cmp    $0x19,%bl
  800bc5:	77 29                	ja     800bf0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc7:	0f be d2             	movsbl %dl,%edx
  800bca:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bcd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd0:	7d 30                	jge    800c02 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd2:	83 c1 01             	add    $0x1,%ecx
  800bd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdb:	0f b6 11             	movzbl (%ecx),%edx
  800bde:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be1:	89 f3                	mov    %esi,%ebx
  800be3:	80 fb 09             	cmp    $0x9,%bl
  800be6:	77 d5                	ja     800bbd <strtol+0x7c>
			dig = *s - '0';
  800be8:	0f be d2             	movsbl %dl,%edx
  800beb:	83 ea 30             	sub    $0x30,%edx
  800bee:	eb dd                	jmp    800bcd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf3:	89 f3                	mov    %esi,%ebx
  800bf5:	80 fb 19             	cmp    $0x19,%bl
  800bf8:	77 08                	ja     800c02 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfa:	0f be d2             	movsbl %dl,%edx
  800bfd:	83 ea 37             	sub    $0x37,%edx
  800c00:	eb cb                	jmp    800bcd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c06:	74 05                	je     800c0d <strtol+0xcc>
		*endptr = (char *) s;
  800c08:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c0d:	89 c2                	mov    %eax,%edx
  800c0f:	f7 da                	neg    %edx
  800c11:	85 ff                	test   %edi,%edi
  800c13:	0f 45 c2             	cmovne %edx,%eax
}
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2c:	89 c3                	mov    %eax,%ebx
  800c2e:	89 c7                	mov    %eax,%edi
  800c30:	89 c6                	mov    %eax,%esi
  800c32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5f                   	pop    %edi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 01 00 00 00       	mov    $0x1,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6e:	89 cb                	mov    %ecx,%ebx
  800c70:	89 cf                	mov    %ecx,%edi
  800c72:	89 ce                	mov    %ecx,%esi
  800c74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	7f 08                	jg     800c82 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	50                   	push   %eax
  800c86:	6a 03                	push   $0x3
  800c88:	68 a4 28 80 00       	push   $0x8028a4
  800c8d:	6a 43                	push   $0x43
  800c8f:	68 c1 28 80 00       	push   $0x8028c1
  800c94:	e8 69 14 00 00       	call   802102 <_panic>

00800c99 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca9:	89 d1                	mov    %edx,%ecx
  800cab:	89 d3                	mov    %edx,%ebx
  800cad:	89 d7                	mov    %edx,%edi
  800caf:	89 d6                	mov    %edx,%esi
  800cb1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <sys_yield>:

void
sys_yield(void)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc8:	89 d1                	mov    %edx,%ecx
  800cca:	89 d3                	mov    %edx,%ebx
  800ccc:	89 d7                	mov    %edx,%edi
  800cce:	89 d6                	mov    %edx,%esi
  800cd0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	be 00 00 00 00       	mov    $0x0,%esi
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	89 f7                	mov    %esi,%edi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 04                	push   $0x4
  800d09:	68 a4 28 80 00       	push   $0x8028a4
  800d0e:	6a 43                	push   $0x43
  800d10:	68 c1 28 80 00       	push   $0x8028c1
  800d15:	e8 e8 13 00 00       	call   802102 <_panic>

00800d1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d34:	8b 75 18             	mov    0x18(%ebp),%esi
  800d37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7f 08                	jg     800d45 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	50                   	push   %eax
  800d49:	6a 05                	push   $0x5
  800d4b:	68 a4 28 80 00       	push   $0x8028a4
  800d50:	6a 43                	push   $0x43
  800d52:	68 c1 28 80 00       	push   $0x8028c1
  800d57:	e8 a6 13 00 00       	call   802102 <_panic>

00800d5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	b8 06 00 00 00       	mov    $0x6,%eax
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	89 de                	mov    %ebx,%esi
  800d79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7f 08                	jg     800d87 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	83 ec 0c             	sub    $0xc,%esp
  800d8a:	50                   	push   %eax
  800d8b:	6a 06                	push   $0x6
  800d8d:	68 a4 28 80 00       	push   $0x8028a4
  800d92:	6a 43                	push   $0x43
  800d94:	68 c1 28 80 00       	push   $0x8028c1
  800d99:	e8 64 13 00 00       	call   802102 <_panic>

00800d9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
  800da4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db2:	b8 08 00 00 00       	mov    $0x8,%eax
  800db7:	89 df                	mov    %ebx,%edi
  800db9:	89 de                	mov    %ebx,%esi
  800dbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7f 08                	jg     800dc9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	50                   	push   %eax
  800dcd:	6a 08                	push   $0x8
  800dcf:	68 a4 28 80 00       	push   $0x8028a4
  800dd4:	6a 43                	push   $0x43
  800dd6:	68 c1 28 80 00       	push   $0x8028c1
  800ddb:	e8 22 13 00 00       	call   802102 <_panic>

00800de0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	b8 09 00 00 00       	mov    $0x9,%eax
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7f 08                	jg     800e0b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	50                   	push   %eax
  800e0f:	6a 09                	push   $0x9
  800e11:	68 a4 28 80 00       	push   $0x8028a4
  800e16:	6a 43                	push   $0x43
  800e18:	68 c1 28 80 00       	push   $0x8028c1
  800e1d:	e8 e0 12 00 00       	call   802102 <_panic>

00800e22 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3b:	89 df                	mov    %ebx,%edi
  800e3d:	89 de                	mov    %ebx,%esi
  800e3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 0a                	push   $0xa
  800e53:	68 a4 28 80 00       	push   $0x8028a4
  800e58:	6a 43                	push   $0x43
  800e5a:	68 c1 28 80 00       	push   $0x8028c1
  800e5f:	e8 9e 12 00 00       	call   802102 <_panic>

00800e64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e75:	be 00 00 00 00       	mov    $0x0,%esi
  800e7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e80:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9d:	89 cb                	mov    %ecx,%ebx
  800e9f:	89 cf                	mov    %ecx,%edi
  800ea1:	89 ce                	mov    %ecx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 0d                	push   $0xd
  800eb7:	68 a4 28 80 00       	push   $0x8028a4
  800ebc:	6a 43                	push   $0x43
  800ebe:	68 c1 28 80 00       	push   $0x8028c1
  800ec3:	e8 3a 12 00 00       	call   802102 <_panic>

00800ec8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ece:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ede:	89 df                	mov    %ebx,%edi
  800ee0:	89 de                	mov    %ebx,%esi
  800ee2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800efc:	89 cb                	mov    %ecx,%ebx
  800efe:	89 cf                	mov    %ecx,%edi
  800f00:	89 ce                	mov    %ecx,%esi
  800f02:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f14:	b8 10 00 00 00       	mov    $0x10,%eax
  800f19:	89 d1                	mov    %edx,%ecx
  800f1b:	89 d3                	mov    %edx,%ebx
  800f1d:	89 d7                	mov    %edx,%edi
  800f1f:	89 d6                	mov    %edx,%esi
  800f21:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	b8 11 00 00 00       	mov    $0x11,%eax
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	89 de                	mov    %ebx,%esi
  800f42:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	89 de                	mov    %ebx,%esi
  800f63:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7e:	b8 13 00 00 00       	mov    $0x13,%eax
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7f 08                	jg     800f95 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	50                   	push   %eax
  800f99:	6a 13                	push   $0x13
  800f9b:	68 a4 28 80 00       	push   $0x8028a4
  800fa0:	6a 43                	push   $0x43
  800fa2:	68 c1 28 80 00       	push   $0x8028c1
  800fa7:	e8 56 11 00 00       	call   802102 <_panic>

00800fac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	05 00 00 00 30       	add    $0x30000000,%eax
  800fb7:	c1 e8 0c             	shr    $0xc,%eax
}
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fcc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	c1 ea 16             	shr    $0x16,%edx
  800fe0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fe7:	f6 c2 01             	test   $0x1,%dl
  800fea:	74 2d                	je     801019 <fd_alloc+0x46>
  800fec:	89 c2                	mov    %eax,%edx
  800fee:	c1 ea 0c             	shr    $0xc,%edx
  800ff1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff8:	f6 c2 01             	test   $0x1,%dl
  800ffb:	74 1c                	je     801019 <fd_alloc+0x46>
  800ffd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801002:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801007:	75 d2                	jne    800fdb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801012:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801017:	eb 0a                	jmp    801023 <fd_alloc+0x50>
			*fd_store = fd;
  801019:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80102b:	83 f8 1f             	cmp    $0x1f,%eax
  80102e:	77 30                	ja     801060 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801030:	c1 e0 0c             	shl    $0xc,%eax
  801033:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801038:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80103e:	f6 c2 01             	test   $0x1,%dl
  801041:	74 24                	je     801067 <fd_lookup+0x42>
  801043:	89 c2                	mov    %eax,%edx
  801045:	c1 ea 0c             	shr    $0xc,%edx
  801048:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	74 1a                	je     80106e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801054:	8b 55 0c             	mov    0xc(%ebp),%edx
  801057:	89 02                	mov    %eax,(%edx)
	return 0;
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    
		return -E_INVAL;
  801060:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801065:	eb f7                	jmp    80105e <fd_lookup+0x39>
		return -E_INVAL;
  801067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106c:	eb f0                	jmp    80105e <fd_lookup+0x39>
  80106e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801073:	eb e9                	jmp    80105e <fd_lookup+0x39>

00801075 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80107e:	ba 00 00 00 00       	mov    $0x0,%edx
  801083:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801088:	39 08                	cmp    %ecx,(%eax)
  80108a:	74 38                	je     8010c4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80108c:	83 c2 01             	add    $0x1,%edx
  80108f:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  801096:	85 c0                	test   %eax,%eax
  801098:	75 ee                	jne    801088 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80109a:	a1 08 40 80 00       	mov    0x804008,%eax
  80109f:	8b 40 48             	mov    0x48(%eax),%eax
  8010a2:	83 ec 04             	sub    $0x4,%esp
  8010a5:	51                   	push   %ecx
  8010a6:	50                   	push   %eax
  8010a7:	68 d0 28 80 00       	push   $0x8028d0
  8010ac:	e8 d5 f0 ff ff       	call   800186 <cprintf>
	*dev = 0;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    
			*dev = devtab[i];
  8010c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ce:	eb f2                	jmp    8010c2 <dev_lookup+0x4d>

008010d0 <fd_close>:
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 24             	sub    $0x24,%esp
  8010d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8010dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010e9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010ec:	50                   	push   %eax
  8010ed:	e8 33 ff ff ff       	call   801025 <fd_lookup>
  8010f2:	89 c3                	mov    %eax,%ebx
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 05                	js     801100 <fd_close+0x30>
	    || fd != fd2)
  8010fb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010fe:	74 16                	je     801116 <fd_close+0x46>
		return (must_exist ? r : 0);
  801100:	89 f8                	mov    %edi,%eax
  801102:	84 c0                	test   %al,%al
  801104:	b8 00 00 00 00       	mov    $0x0,%eax
  801109:	0f 44 d8             	cmove  %eax,%ebx
}
  80110c:	89 d8                	mov    %ebx,%eax
  80110e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80111c:	50                   	push   %eax
  80111d:	ff 36                	pushl  (%esi)
  80111f:	e8 51 ff ff ff       	call   801075 <dev_lookup>
  801124:	89 c3                	mov    %eax,%ebx
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 1a                	js     801147 <fd_close+0x77>
		if (dev->dev_close)
  80112d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801130:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801138:	85 c0                	test   %eax,%eax
  80113a:	74 0b                	je     801147 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80113c:	83 ec 0c             	sub    $0xc,%esp
  80113f:	56                   	push   %esi
  801140:	ff d0                	call   *%eax
  801142:	89 c3                	mov    %eax,%ebx
  801144:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801147:	83 ec 08             	sub    $0x8,%esp
  80114a:	56                   	push   %esi
  80114b:	6a 00                	push   $0x0
  80114d:	e8 0a fc ff ff       	call   800d5c <sys_page_unmap>
	return r;
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	eb b5                	jmp    80110c <fd_close+0x3c>

00801157 <close>:

int
close(int fdnum)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	ff 75 08             	pushl  0x8(%ebp)
  801164:	e8 bc fe ff ff       	call   801025 <fd_lookup>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 02                	jns    801172 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    
		return fd_close(fd, 1);
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	6a 01                	push   $0x1
  801177:	ff 75 f4             	pushl  -0xc(%ebp)
  80117a:	e8 51 ff ff ff       	call   8010d0 <fd_close>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	eb ec                	jmp    801170 <close+0x19>

00801184 <close_all>:

void
close_all(void)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	53                   	push   %ebx
  801188:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80118b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	53                   	push   %ebx
  801194:	e8 be ff ff ff       	call   801157 <close>
	for (i = 0; i < MAXFD; i++)
  801199:	83 c3 01             	add    $0x1,%ebx
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	83 fb 20             	cmp    $0x20,%ebx
  8011a2:	75 ec                	jne    801190 <close_all+0xc>
}
  8011a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
  8011af:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b5:	50                   	push   %eax
  8011b6:	ff 75 08             	pushl  0x8(%ebp)
  8011b9:	e8 67 fe ff ff       	call   801025 <fd_lookup>
  8011be:	89 c3                	mov    %eax,%ebx
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	0f 88 81 00 00 00    	js     80124c <dup+0xa3>
		return r;
	close(newfdnum);
  8011cb:	83 ec 0c             	sub    $0xc,%esp
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	e8 81 ff ff ff       	call   801157 <close>

	newfd = INDEX2FD(newfdnum);
  8011d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d9:	c1 e6 0c             	shl    $0xc,%esi
  8011dc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011e2:	83 c4 04             	add    $0x4,%esp
  8011e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e8:	e8 cf fd ff ff       	call   800fbc <fd2data>
  8011ed:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011ef:	89 34 24             	mov    %esi,(%esp)
  8011f2:	e8 c5 fd ff ff       	call   800fbc <fd2data>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011fc:	89 d8                	mov    %ebx,%eax
  8011fe:	c1 e8 16             	shr    $0x16,%eax
  801201:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801208:	a8 01                	test   $0x1,%al
  80120a:	74 11                	je     80121d <dup+0x74>
  80120c:	89 d8                	mov    %ebx,%eax
  80120e:	c1 e8 0c             	shr    $0xc,%eax
  801211:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801218:	f6 c2 01             	test   $0x1,%dl
  80121b:	75 39                	jne    801256 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80121d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801220:	89 d0                	mov    %edx,%eax
  801222:	c1 e8 0c             	shr    $0xc,%eax
  801225:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	25 07 0e 00 00       	and    $0xe07,%eax
  801234:	50                   	push   %eax
  801235:	56                   	push   %esi
  801236:	6a 00                	push   $0x0
  801238:	52                   	push   %edx
  801239:	6a 00                	push   $0x0
  80123b:	e8 da fa ff ff       	call   800d1a <sys_page_map>
  801240:	89 c3                	mov    %eax,%ebx
  801242:	83 c4 20             	add    $0x20,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	78 31                	js     80127a <dup+0xd1>
		goto err;

	return newfdnum;
  801249:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80124c:	89 d8                	mov    %ebx,%eax
  80124e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801256:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	25 07 0e 00 00       	and    $0xe07,%eax
  801265:	50                   	push   %eax
  801266:	57                   	push   %edi
  801267:	6a 00                	push   $0x0
  801269:	53                   	push   %ebx
  80126a:	6a 00                	push   $0x0
  80126c:	e8 a9 fa ff ff       	call   800d1a <sys_page_map>
  801271:	89 c3                	mov    %eax,%ebx
  801273:	83 c4 20             	add    $0x20,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	79 a3                	jns    80121d <dup+0x74>
	sys_page_unmap(0, newfd);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	56                   	push   %esi
  80127e:	6a 00                	push   $0x0
  801280:	e8 d7 fa ff ff       	call   800d5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801285:	83 c4 08             	add    $0x8,%esp
  801288:	57                   	push   %edi
  801289:	6a 00                	push   $0x0
  80128b:	e8 cc fa ff ff       	call   800d5c <sys_page_unmap>
	return r;
  801290:	83 c4 10             	add    $0x10,%esp
  801293:	eb b7                	jmp    80124c <dup+0xa3>

00801295 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	53                   	push   %ebx
  801299:	83 ec 1c             	sub    $0x1c,%esp
  80129c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	53                   	push   %ebx
  8012a4:	e8 7c fd ff ff       	call   801025 <fd_lookup>
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 3f                	js     8012ef <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b6:	50                   	push   %eax
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ba:	ff 30                	pushl  (%eax)
  8012bc:	e8 b4 fd ff ff       	call   801075 <dev_lookup>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 27                	js     8012ef <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cb:	8b 42 08             	mov    0x8(%edx),%eax
  8012ce:	83 e0 03             	and    $0x3,%eax
  8012d1:	83 f8 01             	cmp    $0x1,%eax
  8012d4:	74 1e                	je     8012f4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d9:	8b 40 08             	mov    0x8(%eax),%eax
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	74 35                	je     801315 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	ff 75 10             	pushl  0x10(%ebp)
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	52                   	push   %edx
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
}
  8012ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012f9:	8b 40 48             	mov    0x48(%eax),%eax
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	53                   	push   %ebx
  801300:	50                   	push   %eax
  801301:	68 11 29 80 00       	push   $0x802911
  801306:	e8 7b ee ff ff       	call   800186 <cprintf>
		return -E_INVAL;
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801313:	eb da                	jmp    8012ef <read+0x5a>
		return -E_NOT_SUPP;
  801315:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131a:	eb d3                	jmp    8012ef <read+0x5a>

0080131c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 0c             	sub    $0xc,%esp
  801325:	8b 7d 08             	mov    0x8(%ebp),%edi
  801328:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80132b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801330:	39 f3                	cmp    %esi,%ebx
  801332:	73 23                	jae    801357 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	89 f0                	mov    %esi,%eax
  801339:	29 d8                	sub    %ebx,%eax
  80133b:	50                   	push   %eax
  80133c:	89 d8                	mov    %ebx,%eax
  80133e:	03 45 0c             	add    0xc(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	57                   	push   %edi
  801343:	e8 4d ff ff ff       	call   801295 <read>
		if (m < 0)
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	78 06                	js     801355 <readn+0x39>
			return m;
		if (m == 0)
  80134f:	74 06                	je     801357 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801351:	01 c3                	add    %eax,%ebx
  801353:	eb db                	jmp    801330 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801355:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801357:	89 d8                	mov    %ebx,%eax
  801359:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135c:	5b                   	pop    %ebx
  80135d:	5e                   	pop    %esi
  80135e:	5f                   	pop    %edi
  80135f:	5d                   	pop    %ebp
  801360:	c3                   	ret    

00801361 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	53                   	push   %ebx
  801365:	83 ec 1c             	sub    $0x1c,%esp
  801368:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	53                   	push   %ebx
  801370:	e8 b0 fc ff ff       	call   801025 <fd_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 3a                	js     8013b6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	ff 30                	pushl  (%eax)
  801388:	e8 e8 fc ff ff       	call   801075 <dev_lookup>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 22                	js     8013b6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80139b:	74 1e                	je     8013bb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80139d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a3:	85 d2                	test   %edx,%edx
  8013a5:	74 35                	je     8013dc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	ff 75 10             	pushl  0x10(%ebp)
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	50                   	push   %eax
  8013b1:	ff d2                	call   *%edx
  8013b3:	83 c4 10             	add    $0x10,%esp
}
  8013b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013bb:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c0:	8b 40 48             	mov    0x48(%eax),%eax
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	53                   	push   %ebx
  8013c7:	50                   	push   %eax
  8013c8:	68 2d 29 80 00       	push   $0x80292d
  8013cd:	e8 b4 ed ff ff       	call   800186 <cprintf>
		return -E_INVAL;
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013da:	eb da                	jmp    8013b6 <write+0x55>
		return -E_NOT_SUPP;
  8013dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e1:	eb d3                	jmp    8013b6 <write+0x55>

008013e3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	e8 30 fc ff ff       	call   801025 <fd_lookup>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 0e                	js     80140a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801402:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	53                   	push   %ebx
  801410:	83 ec 1c             	sub    $0x1c,%esp
  801413:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801416:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801419:	50                   	push   %eax
  80141a:	53                   	push   %ebx
  80141b:	e8 05 fc ff ff       	call   801025 <fd_lookup>
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	78 37                	js     80145e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801431:	ff 30                	pushl  (%eax)
  801433:	e8 3d fc ff ff       	call   801075 <dev_lookup>
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 1f                	js     80145e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801442:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801446:	74 1b                	je     801463 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144b:	8b 52 18             	mov    0x18(%edx),%edx
  80144e:	85 d2                	test   %edx,%edx
  801450:	74 32                	je     801484 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	50                   	push   %eax
  801459:	ff d2                	call   *%edx
  80145b:	83 c4 10             	add    $0x10,%esp
}
  80145e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801461:	c9                   	leave  
  801462:	c3                   	ret    
			thisenv->env_id, fdnum);
  801463:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801468:	8b 40 48             	mov    0x48(%eax),%eax
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	53                   	push   %ebx
  80146f:	50                   	push   %eax
  801470:	68 f0 28 80 00       	push   $0x8028f0
  801475:	e8 0c ed ff ff       	call   800186 <cprintf>
		return -E_INVAL;
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801482:	eb da                	jmp    80145e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801484:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801489:	eb d3                	jmp    80145e <ftruncate+0x52>

0080148b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	53                   	push   %ebx
  80148f:	83 ec 1c             	sub    $0x1c,%esp
  801492:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801495:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801498:	50                   	push   %eax
  801499:	ff 75 08             	pushl  0x8(%ebp)
  80149c:	e8 84 fb ff ff       	call   801025 <fd_lookup>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 4b                	js     8014f3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	50                   	push   %eax
  8014af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b2:	ff 30                	pushl  (%eax)
  8014b4:	e8 bc fb ff ff       	call   801075 <dev_lookup>
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 33                	js     8014f3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014c7:	74 2f                	je     8014f8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014d3:	00 00 00 
	stat->st_isdir = 0;
  8014d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014dd:	00 00 00 
	stat->st_dev = dev;
  8014e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	53                   	push   %ebx
  8014ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ed:	ff 50 14             	call   *0x14(%eax)
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
		return -E_NOT_SUPP;
  8014f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fd:	eb f4                	jmp    8014f3 <fstat+0x68>

008014ff <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	6a 00                	push   $0x0
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 22 02 00 00       	call   801733 <open>
  801511:	89 c3                	mov    %eax,%ebx
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 1b                	js     801535 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	50                   	push   %eax
  801521:	e8 65 ff ff ff       	call   80148b <fstat>
  801526:	89 c6                	mov    %eax,%esi
	close(fd);
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 27 fc ff ff       	call   801157 <close>
	return r;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	89 f3                	mov    %esi,%ebx
}
  801535:	89 d8                	mov    %ebx,%eax
  801537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	89 c6                	mov    %eax,%esi
  801545:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801547:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80154e:	74 27                	je     801577 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801550:	6a 07                	push   $0x7
  801552:	68 00 50 80 00       	push   $0x805000
  801557:	56                   	push   %esi
  801558:	ff 35 00 40 80 00    	pushl  0x804000
  80155e:	e8 69 0c 00 00       	call   8021cc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801563:	83 c4 0c             	add    $0xc,%esp
  801566:	6a 00                	push   $0x0
  801568:	53                   	push   %ebx
  801569:	6a 00                	push   $0x0
  80156b:	e8 f3 0b 00 00       	call   802163 <ipc_recv>
}
  801570:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	6a 01                	push   $0x1
  80157c:	e8 a3 0c 00 00       	call   802224 <ipc_find_env>
  801581:	a3 00 40 80 00       	mov    %eax,0x804000
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	eb c5                	jmp    801550 <fsipc+0x12>

0080158b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8b 40 0c             	mov    0xc(%eax),%eax
  801597:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	b8 02 00 00 00       	mov    $0x2,%eax
  8015ae:	e8 8b ff ff ff       	call   80153e <fsipc>
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <devfile_flush>:
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d0:	e8 69 ff ff ff       	call   80153e <fsipc>
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <devfile_stat>:
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	53                   	push   %ebx
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f1:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f6:	e8 43 ff ff ff       	call   80153e <fsipc>
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 2c                	js     80162b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	68 00 50 80 00       	push   $0x805000
  801607:	53                   	push   %ebx
  801608:	e8 d8 f2 ff ff       	call   8008e5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80160d:	a1 80 50 80 00       	mov    0x805080,%eax
  801612:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801618:	a1 84 50 80 00       	mov    0x805084,%eax
  80161d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <devfile_write>:
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8b 40 0c             	mov    0xc(%eax),%eax
  801640:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801645:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80164b:	53                   	push   %ebx
  80164c:	ff 75 0c             	pushl  0xc(%ebp)
  80164f:	68 08 50 80 00       	push   $0x805008
  801654:	e8 7c f4 ff ff       	call   800ad5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801659:	ba 00 00 00 00       	mov    $0x0,%edx
  80165e:	b8 04 00 00 00       	mov    $0x4,%eax
  801663:	e8 d6 fe ff ff       	call   80153e <fsipc>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 0b                	js     80167a <devfile_write+0x4a>
	assert(r <= n);
  80166f:	39 d8                	cmp    %ebx,%eax
  801671:	77 0c                	ja     80167f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801673:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801678:	7f 1e                	jg     801698 <devfile_write+0x68>
}
  80167a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    
	assert(r <= n);
  80167f:	68 60 29 80 00       	push   $0x802960
  801684:	68 67 29 80 00       	push   $0x802967
  801689:	68 98 00 00 00       	push   $0x98
  80168e:	68 7c 29 80 00       	push   $0x80297c
  801693:	e8 6a 0a 00 00       	call   802102 <_panic>
	assert(r <= PGSIZE);
  801698:	68 87 29 80 00       	push   $0x802987
  80169d:	68 67 29 80 00       	push   $0x802967
  8016a2:	68 99 00 00 00       	push   $0x99
  8016a7:	68 7c 29 80 00       	push   $0x80297c
  8016ac:	e8 51 0a 00 00       	call   802102 <_panic>

008016b1 <devfile_read>:
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016c4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d4:	e8 65 fe ff ff       	call   80153e <fsipc>
  8016d9:	89 c3                	mov    %eax,%ebx
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 1f                	js     8016fe <devfile_read+0x4d>
	assert(r <= n);
  8016df:	39 f0                	cmp    %esi,%eax
  8016e1:	77 24                	ja     801707 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e8:	7f 33                	jg     80171d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	50                   	push   %eax
  8016ee:	68 00 50 80 00       	push   $0x805000
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	e8 78 f3 ff ff       	call   800a73 <memmove>
	return r;
  8016fb:	83 c4 10             	add    $0x10,%esp
}
  8016fe:	89 d8                	mov    %ebx,%eax
  801700:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
	assert(r <= n);
  801707:	68 60 29 80 00       	push   $0x802960
  80170c:	68 67 29 80 00       	push   $0x802967
  801711:	6a 7c                	push   $0x7c
  801713:	68 7c 29 80 00       	push   $0x80297c
  801718:	e8 e5 09 00 00       	call   802102 <_panic>
	assert(r <= PGSIZE);
  80171d:	68 87 29 80 00       	push   $0x802987
  801722:	68 67 29 80 00       	push   $0x802967
  801727:	6a 7d                	push   $0x7d
  801729:	68 7c 29 80 00       	push   $0x80297c
  80172e:	e8 cf 09 00 00       	call   802102 <_panic>

00801733 <open>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 1c             	sub    $0x1c,%esp
  80173b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80173e:	56                   	push   %esi
  80173f:	e8 68 f1 ff ff       	call   8008ac <strlen>
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80174c:	7f 6c                	jg     8017ba <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801754:	50                   	push   %eax
  801755:	e8 79 f8 ff ff       	call   800fd3 <fd_alloc>
  80175a:	89 c3                	mov    %eax,%ebx
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 3c                	js     80179f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	56                   	push   %esi
  801767:	68 00 50 80 00       	push   $0x805000
  80176c:	e8 74 f1 ff ff       	call   8008e5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177c:	b8 01 00 00 00       	mov    $0x1,%eax
  801781:	e8 b8 fd ff ff       	call   80153e <fsipc>
  801786:	89 c3                	mov    %eax,%ebx
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 19                	js     8017a8 <open+0x75>
	return fd2num(fd);
  80178f:	83 ec 0c             	sub    $0xc,%esp
  801792:	ff 75 f4             	pushl  -0xc(%ebp)
  801795:	e8 12 f8 ff ff       	call   800fac <fd2num>
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	83 c4 10             	add    $0x10,%esp
}
  80179f:	89 d8                	mov    %ebx,%eax
  8017a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    
		fd_close(fd, 0);
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	6a 00                	push   $0x0
  8017ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b0:	e8 1b f9 ff ff       	call   8010d0 <fd_close>
		return r;
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	eb e5                	jmp    80179f <open+0x6c>
		return -E_BAD_PATH;
  8017ba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017bf:	eb de                	jmp    80179f <open+0x6c>

008017c1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d1:	e8 68 fd ff ff       	call   80153e <fsipc>
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017de:	68 93 29 80 00       	push   $0x802993
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	e8 fa f0 ff ff       	call   8008e5 <strcpy>
	return 0;
}
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <devsock_close>:
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 10             	sub    $0x10,%esp
  8017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017fc:	53                   	push   %ebx
  8017fd:	e8 5d 0a 00 00       	call   80225f <pageref>
  801802:	83 c4 10             	add    $0x10,%esp
		return 0;
  801805:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80180a:	83 f8 01             	cmp    $0x1,%eax
  80180d:	74 07                	je     801816 <devsock_close+0x24>
}
  80180f:	89 d0                	mov    %edx,%eax
  801811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801814:	c9                   	leave  
  801815:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	ff 73 0c             	pushl  0xc(%ebx)
  80181c:	e8 b9 02 00 00       	call   801ada <nsipc_close>
  801821:	89 c2                	mov    %eax,%edx
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	eb e7                	jmp    80180f <devsock_close+0x1d>

00801828 <devsock_write>:
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 10             	pushl  0x10(%ebp)
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	ff 70 0c             	pushl  0xc(%eax)
  80183c:	e8 76 03 00 00       	call   801bb7 <nsipc_send>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devsock_read>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 10             	pushl  0x10(%ebp)
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	ff 70 0c             	pushl  0xc(%eax)
  801857:	e8 ef 02 00 00       	call   801b4b <nsipc_recv>
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <fd2sockid>:
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801864:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801867:	52                   	push   %edx
  801868:	50                   	push   %eax
  801869:	e8 b7 f7 ff ff       	call   801025 <fd_lookup>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	78 10                	js     801885 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80187e:	39 08                	cmp    %ecx,(%eax)
  801880:	75 05                	jne    801887 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801882:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    
		return -E_NOT_SUPP;
  801887:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188c:	eb f7                	jmp    801885 <fd2sockid+0x27>

0080188e <alloc_sockfd>:
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	56                   	push   %esi
  801892:	53                   	push   %ebx
  801893:	83 ec 1c             	sub    $0x1c,%esp
  801896:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801898:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189b:	50                   	push   %eax
  80189c:	e8 32 f7 ff ff       	call   800fd3 <fd_alloc>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 43                	js     8018ed <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 07 04 00 00       	push   $0x407
  8018b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 1b f4 ff ff       	call   800cd7 <sys_page_alloc>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 28                	js     8018ed <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018ce:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018da:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	50                   	push   %eax
  8018e1:	e8 c6 f6 ff ff       	call   800fac <fd2num>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb 0c                	jmp    8018f9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	56                   	push   %esi
  8018f1:	e8 e4 01 00 00       	call   801ada <nsipc_close>
		return r;
  8018f6:	83 c4 10             	add    $0x10,%esp
}
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <accept>:
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	e8 4e ff ff ff       	call   80185e <fd2sockid>
  801910:	85 c0                	test   %eax,%eax
  801912:	78 1b                	js     80192f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	50                   	push   %eax
  80191e:	e8 0e 01 00 00       	call   801a31 <nsipc_accept>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 05                	js     80192f <accept+0x2d>
	return alloc_sockfd(r);
  80192a:	e8 5f ff ff ff       	call   80188e <alloc_sockfd>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <bind>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	e8 1f ff ff ff       	call   80185e <fd2sockid>
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 12                	js     801955 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	50                   	push   %eax
  80194d:	e8 31 01 00 00       	call   801a83 <nsipc_bind>
  801952:	83 c4 10             	add    $0x10,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <shutdown>:
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	e8 f9 fe ff ff       	call   80185e <fd2sockid>
  801965:	85 c0                	test   %eax,%eax
  801967:	78 0f                	js     801978 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	e8 43 01 00 00       	call   801ab8 <nsipc_shutdown>
  801975:	83 c4 10             	add    $0x10,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <connect>:
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	e8 d6 fe ff ff       	call   80185e <fd2sockid>
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 12                	js     80199e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	e8 59 01 00 00       	call   801af4 <nsipc_connect>
  80199b:	83 c4 10             	add    $0x10,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <listen>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	e8 b0 fe ff ff       	call   80185e <fd2sockid>
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 0f                	js     8019c1 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	e8 6b 01 00 00       	call   801b29 <nsipc_listen>
  8019be:	83 c4 10             	add    $0x10,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	e8 3e 02 00 00       	call   801c15 <nsipc_socket>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 05                	js     8019e3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019de:	e8 ab fe ff ff       	call   80188e <alloc_sockfd>
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019ee:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019f5:	74 26                	je     801a1d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019f7:	6a 07                	push   $0x7
  8019f9:	68 00 60 80 00       	push   $0x806000
  8019fe:	53                   	push   %ebx
  8019ff:	ff 35 04 40 80 00    	pushl  0x804004
  801a05:	e8 c2 07 00 00       	call   8021cc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a0a:	83 c4 0c             	add    $0xc,%esp
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	e8 4b 07 00 00       	call   802163 <ipc_recv>
}
  801a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	6a 02                	push   $0x2
  801a22:	e8 fd 07 00 00       	call   802224 <ipc_find_env>
  801a27:	a3 04 40 80 00       	mov    %eax,0x804004
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	eb c6                	jmp    8019f7 <nsipc+0x12>

00801a31 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a41:	8b 06                	mov    (%esi),%eax
  801a43:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a48:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4d:	e8 93 ff ff ff       	call   8019e5 <nsipc>
  801a52:	89 c3                	mov    %eax,%ebx
  801a54:	85 c0                	test   %eax,%eax
  801a56:	79 09                	jns    801a61 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	ff 35 10 60 80 00    	pushl  0x806010
  801a6a:	68 00 60 80 00       	push   $0x806000
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	e8 fc ef ff ff       	call   800a73 <memmove>
		*addrlen = ret->ret_addrlen;
  801a77:	a1 10 60 80 00       	mov    0x806010,%eax
  801a7c:	89 06                	mov    %eax,(%esi)
  801a7e:	83 c4 10             	add    $0x10,%esp
	return r;
  801a81:	eb d5                	jmp    801a58 <nsipc_accept+0x27>

00801a83 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 08             	sub    $0x8,%esp
  801a8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a95:	53                   	push   %ebx
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	68 04 60 80 00       	push   $0x806004
  801a9e:	e8 d0 ef ff ff       	call   800a73 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aa3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aa9:	b8 02 00 00 00       	mov    $0x2,%eax
  801aae:	e8 32 ff ff ff       	call   8019e5 <nsipc>
}
  801ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ace:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad3:	e8 0d ff ff ff       	call   8019e5 <nsipc>
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <nsipc_close>:

int
nsipc_close(int s)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ae8:	b8 04 00 00 00       	mov    $0x4,%eax
  801aed:	e8 f3 fe ff ff       	call   8019e5 <nsipc>
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	53                   	push   %ebx
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b06:	53                   	push   %ebx
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	68 04 60 80 00       	push   $0x806004
  801b0f:	e8 5f ef ff ff       	call   800a73 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b14:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b1a:	b8 05 00 00 00       	mov    $0x5,%eax
  801b1f:	e8 c1 fe ff ff       	call   8019e5 <nsipc>
}
  801b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801b44:	e8 9c fe ff ff       	call   8019e5 <nsipc>
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b5b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b61:	8b 45 14             	mov    0x14(%ebp),%eax
  801b64:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b69:	b8 07 00 00 00       	mov    $0x7,%eax
  801b6e:	e8 72 fe ff ff       	call   8019e5 <nsipc>
  801b73:	89 c3                	mov    %eax,%ebx
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 1f                	js     801b98 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b79:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b7e:	7f 21                	jg     801ba1 <nsipc_recv+0x56>
  801b80:	39 c6                	cmp    %eax,%esi
  801b82:	7c 1d                	jl     801ba1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	50                   	push   %eax
  801b88:	68 00 60 80 00       	push   $0x806000
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	e8 de ee ff ff       	call   800a73 <memmove>
  801b95:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ba1:	68 9f 29 80 00       	push   $0x80299f
  801ba6:	68 67 29 80 00       	push   $0x802967
  801bab:	6a 62                	push   $0x62
  801bad:	68 b4 29 80 00       	push   $0x8029b4
  801bb2:	e8 4b 05 00 00       	call   802102 <_panic>

00801bb7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bc9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bcf:	7f 2e                	jg     801bff <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	53                   	push   %ebx
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	68 0c 60 80 00       	push   $0x80600c
  801bdd:	e8 91 ee ff ff       	call   800a73 <memmove>
	nsipcbuf.send.req_size = size;
  801be2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801be8:	8b 45 14             	mov    0x14(%ebp),%eax
  801beb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bf0:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf5:	e8 eb fd ff ff       	call   8019e5 <nsipc>
}
  801bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    
	assert(size < 1600);
  801bff:	68 c0 29 80 00       	push   $0x8029c0
  801c04:	68 67 29 80 00       	push   $0x802967
  801c09:	6a 6d                	push   $0x6d
  801c0b:	68 b4 29 80 00       	push   $0x8029b4
  801c10:	e8 ed 04 00 00       	call   802102 <_panic>

00801c15 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c26:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c33:	b8 09 00 00 00       	mov    $0x9,%eax
  801c38:	e8 a8 fd ff ff       	call   8019e5 <nsipc>
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	e8 6a f3 ff ff       	call   800fbc <fd2data>
  801c52:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c54:	83 c4 08             	add    $0x8,%esp
  801c57:	68 cc 29 80 00       	push   $0x8029cc
  801c5c:	53                   	push   %ebx
  801c5d:	e8 83 ec ff ff       	call   8008e5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c62:	8b 46 04             	mov    0x4(%esi),%eax
  801c65:	2b 06                	sub    (%esi),%eax
  801c67:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c74:	00 00 00 
	stat->st_dev = &devpipe;
  801c77:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c7e:	30 80 00 
	return 0;
}
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	53                   	push   %ebx
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c97:	53                   	push   %ebx
  801c98:	6a 00                	push   $0x0
  801c9a:	e8 bd f0 ff ff       	call   800d5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c9f:	89 1c 24             	mov    %ebx,(%esp)
  801ca2:	e8 15 f3 ff ff       	call   800fbc <fd2data>
  801ca7:	83 c4 08             	add    $0x8,%esp
  801caa:	50                   	push   %eax
  801cab:	6a 00                	push   $0x0
  801cad:	e8 aa f0 ff ff       	call   800d5c <sys_page_unmap>
}
  801cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <_pipeisclosed>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	57                   	push   %edi
  801cbb:	56                   	push   %esi
  801cbc:	53                   	push   %ebx
  801cbd:	83 ec 1c             	sub    $0x1c,%esp
  801cc0:	89 c7                	mov    %eax,%edi
  801cc2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc4:	a1 08 40 80 00       	mov    0x804008,%eax
  801cc9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	57                   	push   %edi
  801cd0:	e8 8a 05 00 00       	call   80225f <pageref>
  801cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd8:	89 34 24             	mov    %esi,(%esp)
  801cdb:	e8 7f 05 00 00       	call   80225f <pageref>
		nn = thisenv->env_runs;
  801ce0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	39 cb                	cmp    %ecx,%ebx
  801cee:	74 1b                	je     801d0b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf3:	75 cf                	jne    801cc4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf5:	8b 42 58             	mov    0x58(%edx),%eax
  801cf8:	6a 01                	push   $0x1
  801cfa:	50                   	push   %eax
  801cfb:	53                   	push   %ebx
  801cfc:	68 d3 29 80 00       	push   $0x8029d3
  801d01:	e8 80 e4 ff ff       	call   800186 <cprintf>
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	eb b9                	jmp    801cc4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d0e:	0f 94 c0             	sete   %al
  801d11:	0f b6 c0             	movzbl %al,%eax
}
  801d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    

00801d1c <devpipe_write>:
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	57                   	push   %edi
  801d20:	56                   	push   %esi
  801d21:	53                   	push   %ebx
  801d22:	83 ec 28             	sub    $0x28,%esp
  801d25:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d28:	56                   	push   %esi
  801d29:	e8 8e f2 ff ff       	call   800fbc <fd2data>
  801d2e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	bf 00 00 00 00       	mov    $0x0,%edi
  801d38:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d3b:	74 4f                	je     801d8c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d3d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d40:	8b 0b                	mov    (%ebx),%ecx
  801d42:	8d 51 20             	lea    0x20(%ecx),%edx
  801d45:	39 d0                	cmp    %edx,%eax
  801d47:	72 14                	jb     801d5d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d49:	89 da                	mov    %ebx,%edx
  801d4b:	89 f0                	mov    %esi,%eax
  801d4d:	e8 65 ff ff ff       	call   801cb7 <_pipeisclosed>
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 3b                	jne    801d91 <devpipe_write+0x75>
			sys_yield();
  801d56:	e8 5d ef ff ff       	call   800cb8 <sys_yield>
  801d5b:	eb e0                	jmp    801d3d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d60:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d64:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d67:	89 c2                	mov    %eax,%edx
  801d69:	c1 fa 1f             	sar    $0x1f,%edx
  801d6c:	89 d1                	mov    %edx,%ecx
  801d6e:	c1 e9 1b             	shr    $0x1b,%ecx
  801d71:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d74:	83 e2 1f             	and    $0x1f,%edx
  801d77:	29 ca                	sub    %ecx,%edx
  801d79:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d7d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d81:	83 c0 01             	add    $0x1,%eax
  801d84:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d87:	83 c7 01             	add    $0x1,%edi
  801d8a:	eb ac                	jmp    801d38 <devpipe_write+0x1c>
	return i;
  801d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8f:	eb 05                	jmp    801d96 <devpipe_write+0x7a>
				return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d99:	5b                   	pop    %ebx
  801d9a:	5e                   	pop    %esi
  801d9b:	5f                   	pop    %edi
  801d9c:	5d                   	pop    %ebp
  801d9d:	c3                   	ret    

00801d9e <devpipe_read>:
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	57                   	push   %edi
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 18             	sub    $0x18,%esp
  801da7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801daa:	57                   	push   %edi
  801dab:	e8 0c f2 ff ff       	call   800fbc <fd2data>
  801db0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	be 00 00 00 00       	mov    $0x0,%esi
  801dba:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dbd:	75 14                	jne    801dd3 <devpipe_read+0x35>
	return i;
  801dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc2:	eb 02                	jmp    801dc6 <devpipe_read+0x28>
				return i;
  801dc4:	89 f0                	mov    %esi,%eax
}
  801dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    
			sys_yield();
  801dce:	e8 e5 ee ff ff       	call   800cb8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dd3:	8b 03                	mov    (%ebx),%eax
  801dd5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd8:	75 18                	jne    801df2 <devpipe_read+0x54>
			if (i > 0)
  801dda:	85 f6                	test   %esi,%esi
  801ddc:	75 e6                	jne    801dc4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dde:	89 da                	mov    %ebx,%edx
  801de0:	89 f8                	mov    %edi,%eax
  801de2:	e8 d0 fe ff ff       	call   801cb7 <_pipeisclosed>
  801de7:	85 c0                	test   %eax,%eax
  801de9:	74 e3                	je     801dce <devpipe_read+0x30>
				return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
  801df0:	eb d4                	jmp    801dc6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df2:	99                   	cltd   
  801df3:	c1 ea 1b             	shr    $0x1b,%edx
  801df6:	01 d0                	add    %edx,%eax
  801df8:	83 e0 1f             	and    $0x1f,%eax
  801dfb:	29 d0                	sub    %edx,%eax
  801dfd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e05:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e08:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e0b:	83 c6 01             	add    $0x1,%esi
  801e0e:	eb aa                	jmp    801dba <devpipe_read+0x1c>

00801e10 <pipe>:
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1b:	50                   	push   %eax
  801e1c:	e8 b2 f1 ff ff       	call   800fd3 <fd_alloc>
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	85 c0                	test   %eax,%eax
  801e28:	0f 88 23 01 00 00    	js     801f51 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 07 04 00 00       	push   $0x407
  801e36:	ff 75 f4             	pushl  -0xc(%ebp)
  801e39:	6a 00                	push   $0x0
  801e3b:	e8 97 ee ff ff       	call   800cd7 <sys_page_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	0f 88 04 01 00 00    	js     801f51 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e4d:	83 ec 0c             	sub    $0xc,%esp
  801e50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e53:	50                   	push   %eax
  801e54:	e8 7a f1 ff ff       	call   800fd3 <fd_alloc>
  801e59:	89 c3                	mov    %eax,%ebx
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	0f 88 db 00 00 00    	js     801f41 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	68 07 04 00 00       	push   $0x407
  801e6e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e71:	6a 00                	push   $0x0
  801e73:	e8 5f ee ff ff       	call   800cd7 <sys_page_alloc>
  801e78:	89 c3                	mov    %eax,%ebx
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	0f 88 bc 00 00 00    	js     801f41 <pipe+0x131>
	va = fd2data(fd0);
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8b:	e8 2c f1 ff ff       	call   800fbc <fd2data>
  801e90:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e92:	83 c4 0c             	add    $0xc,%esp
  801e95:	68 07 04 00 00       	push   $0x407
  801e9a:	50                   	push   %eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	e8 35 ee ff ff       	call   800cd7 <sys_page_alloc>
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	0f 88 82 00 00 00    	js     801f31 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eaf:	83 ec 0c             	sub    $0xc,%esp
  801eb2:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb5:	e8 02 f1 ff ff       	call   800fbc <fd2data>
  801eba:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ec1:	50                   	push   %eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	56                   	push   %esi
  801ec5:	6a 00                	push   $0x0
  801ec7:	e8 4e ee ff ff       	call   800d1a <sys_page_map>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	83 c4 20             	add    $0x20,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 4e                	js     801f23 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ed5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ee9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eec:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	e8 a9 f0 ff ff       	call   800fac <fd2num>
  801f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f06:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f08:	83 c4 04             	add    $0x4,%esp
  801f0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0e:	e8 99 f0 ff ff       	call   800fac <fd2num>
  801f13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f16:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f21:	eb 2e                	jmp    801f51 <pipe+0x141>
	sys_page_unmap(0, va);
  801f23:	83 ec 08             	sub    $0x8,%esp
  801f26:	56                   	push   %esi
  801f27:	6a 00                	push   $0x0
  801f29:	e8 2e ee ff ff       	call   800d5c <sys_page_unmap>
  801f2e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	ff 75 f0             	pushl  -0x10(%ebp)
  801f37:	6a 00                	push   $0x0
  801f39:	e8 1e ee ff ff       	call   800d5c <sys_page_unmap>
  801f3e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f41:	83 ec 08             	sub    $0x8,%esp
  801f44:	ff 75 f4             	pushl  -0xc(%ebp)
  801f47:	6a 00                	push   $0x0
  801f49:	e8 0e ee ff ff       	call   800d5c <sys_page_unmap>
  801f4e:	83 c4 10             	add    $0x10,%esp
}
  801f51:	89 d8                	mov    %ebx,%eax
  801f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <pipeisclosed>:
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f63:	50                   	push   %eax
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 b9 f0 ff ff       	call   801025 <fd_lookup>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 18                	js     801f8b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	ff 75 f4             	pushl  -0xc(%ebp)
  801f79:	e8 3e f0 ff ff       	call   800fbc <fd2data>
	return _pipeisclosed(fd, p);
  801f7e:	89 c2                	mov    %eax,%edx
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	e8 2f fd ff ff       	call   801cb7 <_pipeisclosed>
  801f88:	83 c4 10             	add    $0x10,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	c3                   	ret    

00801f93 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f99:	68 eb 29 80 00       	push   $0x8029eb
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	e8 3f e9 ff ff       	call   8008e5 <strcpy>
	return 0;
}
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <devcons_write>:
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	57                   	push   %edi
  801fb1:	56                   	push   %esi
  801fb2:	53                   	push   %ebx
  801fb3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fb9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fbe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc7:	73 31                	jae    801ffa <devcons_write+0x4d>
		m = n - tot;
  801fc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fcc:	29 f3                	sub    %esi,%ebx
  801fce:	83 fb 7f             	cmp    $0x7f,%ebx
  801fd1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fd6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	53                   	push   %ebx
  801fdd:	89 f0                	mov    %esi,%eax
  801fdf:	03 45 0c             	add    0xc(%ebp),%eax
  801fe2:	50                   	push   %eax
  801fe3:	57                   	push   %edi
  801fe4:	e8 8a ea ff ff       	call   800a73 <memmove>
		sys_cputs(buf, m);
  801fe9:	83 c4 08             	add    $0x8,%esp
  801fec:	53                   	push   %ebx
  801fed:	57                   	push   %edi
  801fee:	e8 28 ec ff ff       	call   800c1b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ff3:	01 de                	add    %ebx,%esi
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	eb ca                	jmp    801fc4 <devcons_write+0x17>
}
  801ffa:	89 f0                	mov    %esi,%eax
  801ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fff:	5b                   	pop    %ebx
  802000:	5e                   	pop    %esi
  802001:	5f                   	pop    %edi
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    

00802004 <devcons_read>:
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80200f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802013:	74 21                	je     802036 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802015:	e8 1f ec ff ff       	call   800c39 <sys_cgetc>
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 07                	jne    802025 <devcons_read+0x21>
		sys_yield();
  80201e:	e8 95 ec ff ff       	call   800cb8 <sys_yield>
  802023:	eb f0                	jmp    802015 <devcons_read+0x11>
	if (c < 0)
  802025:	78 0f                	js     802036 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802027:	83 f8 04             	cmp    $0x4,%eax
  80202a:	74 0c                	je     802038 <devcons_read+0x34>
	*(char*)vbuf = c;
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	88 02                	mov    %al,(%edx)
	return 1;
  802031:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    
		return 0;
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
  80203d:	eb f7                	jmp    802036 <devcons_read+0x32>

0080203f <cputchar>:
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80204b:	6a 01                	push   $0x1
  80204d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	e8 c5 eb ff ff       	call   800c1b <sys_cputs>
}
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <getchar>:
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802061:	6a 01                	push   $0x1
  802063:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802066:	50                   	push   %eax
  802067:	6a 00                	push   $0x0
  802069:	e8 27 f2 ff ff       	call   801295 <read>
	if (r < 0)
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 c0                	test   %eax,%eax
  802073:	78 06                	js     80207b <getchar+0x20>
	if (r < 1)
  802075:	74 06                	je     80207d <getchar+0x22>
	return c;
  802077:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    
		return -E_EOF;
  80207d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802082:	eb f7                	jmp    80207b <getchar+0x20>

00802084 <iscons>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208d:	50                   	push   %eax
  80208e:	ff 75 08             	pushl  0x8(%ebp)
  802091:	e8 8f ef ff ff       	call   801025 <fd_lookup>
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 11                	js     8020ae <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020a6:	39 10                	cmp    %edx,(%eax)
  8020a8:	0f 94 c0             	sete   %al
  8020ab:	0f b6 c0             	movzbl %al,%eax
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <opencons>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b9:	50                   	push   %eax
  8020ba:	e8 14 ef ff ff       	call   800fd3 <fd_alloc>
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 3a                	js     802100 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	68 07 04 00 00       	push   $0x407
  8020ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d1:	6a 00                	push   $0x0
  8020d3:	e8 ff eb ff ff       	call   800cd7 <sys_page_alloc>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 21                	js     802100 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020e8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	50                   	push   %eax
  8020f8:	e8 af ee ff ff       	call   800fac <fd2num>
  8020fd:	83 c4 10             	add    $0x10,%esp
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	56                   	push   %esi
  802106:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802107:	a1 08 40 80 00       	mov    0x804008,%eax
  80210c:	8b 40 48             	mov    0x48(%eax),%eax
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	68 28 2a 80 00       	push   $0x802a28
  802117:	50                   	push   %eax
  802118:	68 f7 29 80 00       	push   $0x8029f7
  80211d:	e8 64 e0 ff ff       	call   800186 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802122:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802125:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80212b:	e8 69 eb ff ff       	call   800c99 <sys_getenvid>
  802130:	83 c4 04             	add    $0x4,%esp
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	56                   	push   %esi
  80213a:	50                   	push   %eax
  80213b:	68 04 2a 80 00       	push   $0x802a04
  802140:	e8 41 e0 ff ff       	call   800186 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802145:	83 c4 18             	add    $0x18,%esp
  802148:	53                   	push   %ebx
  802149:	ff 75 10             	pushl  0x10(%ebp)
  80214c:	e8 e4 df ff ff       	call   800135 <vcprintf>
	cprintf("\n");
  802151:	c7 04 24 0b 25 80 00 	movl   $0x80250b,(%esp)
  802158:	e8 29 e0 ff ff       	call   800186 <cprintf>
  80215d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802160:	cc                   	int3   
  802161:	eb fd                	jmp    802160 <_panic+0x5e>

00802163 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	8b 75 08             	mov    0x8(%ebp),%esi
  80216b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802171:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802173:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802178:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80217b:	83 ec 0c             	sub    $0xc,%esp
  80217e:	50                   	push   %eax
  80217f:	e8 03 ed ff ff       	call   800e87 <sys_ipc_recv>
	if(ret < 0){
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	85 c0                	test   %eax,%eax
  802189:	78 2b                	js     8021b6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80218b:	85 f6                	test   %esi,%esi
  80218d:	74 0a                	je     802199 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80218f:	a1 08 40 80 00       	mov    0x804008,%eax
  802194:	8b 40 74             	mov    0x74(%eax),%eax
  802197:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802199:	85 db                	test   %ebx,%ebx
  80219b:	74 0a                	je     8021a7 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80219d:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a2:	8b 40 78             	mov    0x78(%eax),%eax
  8021a5:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ac:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b2:	5b                   	pop    %ebx
  8021b3:	5e                   	pop    %esi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    
		if(from_env_store)
  8021b6:	85 f6                	test   %esi,%esi
  8021b8:	74 06                	je     8021c0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021c0:	85 db                	test   %ebx,%ebx
  8021c2:	74 eb                	je     8021af <ipc_recv+0x4c>
			*perm_store = 0;
  8021c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ca:	eb e3                	jmp    8021af <ipc_recv+0x4c>

008021cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	57                   	push   %edi
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021de:	85 db                	test   %ebx,%ebx
  8021e0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021e5:	0f 44 d8             	cmove  %eax,%ebx
  8021e8:	eb 05                	jmp    8021ef <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021ea:	e8 c9 ea ff ff       	call   800cb8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021ef:	ff 75 14             	pushl  0x14(%ebp)
  8021f2:	53                   	push   %ebx
  8021f3:	56                   	push   %esi
  8021f4:	57                   	push   %edi
  8021f5:	e8 6a ec ff ff       	call   800e64 <sys_ipc_try_send>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	74 1b                	je     80221c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802201:	79 e7                	jns    8021ea <ipc_send+0x1e>
  802203:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802206:	74 e2                	je     8021ea <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 2f 2a 80 00       	push   $0x802a2f
  802210:	6a 48                	push   $0x48
  802212:	68 44 2a 80 00       	push   $0x802a44
  802217:	e8 e6 fe ff ff       	call   802102 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80221c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5f                   	pop    %edi
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    

00802224 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80222f:	89 c2                	mov    %eax,%edx
  802231:	c1 e2 07             	shl    $0x7,%edx
  802234:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80223a:	8b 52 50             	mov    0x50(%edx),%edx
  80223d:	39 ca                	cmp    %ecx,%edx
  80223f:	74 11                	je     802252 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802241:	83 c0 01             	add    $0x1,%eax
  802244:	3d 00 04 00 00       	cmp    $0x400,%eax
  802249:	75 e4                	jne    80222f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	eb 0b                	jmp    80225d <ipc_find_env+0x39>
			return envs[i].env_id;
  802252:	c1 e0 07             	shl    $0x7,%eax
  802255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80225a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    

0080225f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802265:	89 d0                	mov    %edx,%eax
  802267:	c1 e8 16             	shr    $0x16,%eax
  80226a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802276:	f6 c1 01             	test   $0x1,%cl
  802279:	74 1d                	je     802298 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80227b:	c1 ea 0c             	shr    $0xc,%edx
  80227e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802285:	f6 c2 01             	test   $0x1,%dl
  802288:	74 0e                	je     802298 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80228a:	c1 ea 0c             	shr    $0xc,%edx
  80228d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802294:	ef 
  802295:	0f b7 c0             	movzwl %ax,%eax
}
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

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
