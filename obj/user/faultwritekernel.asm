
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
  800051:	e8 9f 0c 00 00       	call   800cf5 <sys_getenvid>
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
  800076:	74 23                	je     80009b <libmain+0x5d>
		if(envs[i].env_id == find)
  800078:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80007e:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800084:	8b 49 48             	mov    0x48(%ecx),%ecx
  800087:	39 c1                	cmp    %eax,%ecx
  800089:	75 e2                	jne    80006d <libmain+0x2f>
  80008b:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800091:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800097:	89 fe                	mov    %edi,%esi
  800099:	eb d2                	jmp    80006d <libmain+0x2f>
  80009b:	89 f0                	mov    %esi,%eax
  80009d:	84 c0                	test   %al,%al
  80009f:	74 06                	je     8000a7 <libmain+0x69>
  8000a1:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ab:	7e 0a                	jle    8000b7 <libmain+0x79>
		binaryname = argv[0];
  8000ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b0:	8b 00                	mov    (%eax),%eax
  8000b2:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8000bc:	8b 40 48             	mov    0x48(%eax),%eax
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 80 25 80 00       	push   $0x802580
  8000c8:	e8 15 01 00 00       	call   8001e2 <cprintf>
	cprintf("before umain\n");
  8000cd:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000d4:	e8 09 01 00 00       	call   8001e2 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d9:	83 c4 08             	add    $0x8,%esp
  8000dc:	ff 75 0c             	pushl  0xc(%ebp)
  8000df:	ff 75 08             	pushl  0x8(%ebp)
  8000e2:	e8 4c ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000e7:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000ee:	e8 ef 00 00 00       	call   8001e2 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f8:	8b 40 48             	mov    0x48(%eax),%eax
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	50                   	push   %eax
  8000ff:	68 b9 25 80 00       	push   $0x8025b9
  800104:	e8 d9 00 00 00       	call   8001e2 <cprintf>
	// exit gracefully
	exit();
  800109:	e8 0b 00 00 00       	call   800119 <exit>
}
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80011f:	a1 08 40 80 00       	mov    0x804008,%eax
  800124:	8b 40 48             	mov    0x48(%eax),%eax
  800127:	68 e4 25 80 00       	push   $0x8025e4
  80012c:	50                   	push   %eax
  80012d:	68 d8 25 80 00       	push   $0x8025d8
  800132:	e8 ab 00 00 00       	call   8001e2 <cprintf>
	close_all();
  800137:	e8 c4 10 00 00       	call   801200 <close_all>
	sys_env_destroy(0);
  80013c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800143:	e8 6c 0b 00 00       	call   800cb4 <sys_env_destroy>
}
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	53                   	push   %ebx
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800157:	8b 13                	mov    (%ebx),%edx
  800159:	8d 42 01             	lea    0x1(%edx),%eax
  80015c:	89 03                	mov    %eax,(%ebx)
  80015e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800161:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800165:	3d ff 00 00 00       	cmp    $0xff,%eax
  80016a:	74 09                	je     800175 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80016c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800170:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800173:	c9                   	leave  
  800174:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	68 ff 00 00 00       	push   $0xff
  80017d:	8d 43 08             	lea    0x8(%ebx),%eax
  800180:	50                   	push   %eax
  800181:	e8 f1 0a 00 00       	call   800c77 <sys_cputs>
		b->idx = 0;
  800186:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	eb db                	jmp    80016c <putch+0x1f>

00800191 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80019a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a1:	00 00 00 
	b.cnt = 0;
  8001a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ab:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ba:	50                   	push   %eax
  8001bb:	68 4d 01 80 00       	push   $0x80014d
  8001c0:	e8 4a 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c5:	83 c4 08             	add    $0x8,%esp
  8001c8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ce:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 9d 0a 00 00       	call   800c77 <sys_cputs>

	return b.cnt;
}
  8001da:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001eb:	50                   	push   %eax
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	e8 9d ff ff ff       	call   800191 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	57                   	push   %edi
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	83 ec 1c             	sub    $0x1c,%esp
  8001ff:	89 c6                	mov    %eax,%esi
  800201:	89 d7                	mov    %edx,%edi
  800203:	8b 45 08             	mov    0x8(%ebp),%eax
  800206:	8b 55 0c             	mov    0xc(%ebp),%edx
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80020f:	8b 45 10             	mov    0x10(%ebp),%eax
  800212:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800215:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800219:	74 2c                	je     800247 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80021b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800225:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800228:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80022b:	39 c2                	cmp    %eax,%edx
  80022d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800230:	73 43                	jae    800275 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800232:	83 eb 01             	sub    $0x1,%ebx
  800235:	85 db                	test   %ebx,%ebx
  800237:	7e 6c                	jle    8002a5 <printnum+0xaf>
				putch(padc, putdat);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	57                   	push   %edi
  80023d:	ff 75 18             	pushl  0x18(%ebp)
  800240:	ff d6                	call   *%esi
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	eb eb                	jmp    800232 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	6a 20                	push   $0x20
  80024c:	6a 00                	push   $0x0
  80024e:	50                   	push   %eax
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	89 fa                	mov    %edi,%edx
  800257:	89 f0                	mov    %esi,%eax
  800259:	e8 98 ff ff ff       	call   8001f6 <printnum>
		while (--width > 0)
  80025e:	83 c4 20             	add    $0x20,%esp
  800261:	83 eb 01             	sub    $0x1,%ebx
  800264:	85 db                	test   %ebx,%ebx
  800266:	7e 65                	jle    8002cd <printnum+0xd7>
			putch(padc, putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	57                   	push   %edi
  80026c:	6a 20                	push   $0x20
  80026e:	ff d6                	call   *%esi
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	eb ec                	jmp    800261 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 18             	pushl  0x18(%ebp)
  80027b:	83 eb 01             	sub    $0x1,%ebx
  80027e:	53                   	push   %ebx
  80027f:	50                   	push   %eax
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	ff 75 dc             	pushl  -0x24(%ebp)
  800286:	ff 75 d8             	pushl  -0x28(%ebp)
  800289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028c:	ff 75 e0             	pushl  -0x20(%ebp)
  80028f:	e8 8c 20 00 00       	call   802320 <__udivdi3>
  800294:	83 c4 18             	add    $0x18,%esp
  800297:	52                   	push   %edx
  800298:	50                   	push   %eax
  800299:	89 fa                	mov    %edi,%edx
  80029b:	89 f0                	mov    %esi,%eax
  80029d:	e8 54 ff ff ff       	call   8001f6 <printnum>
  8002a2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	57                   	push   %edi
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8002af:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b8:	e8 73 21 00 00       	call   802430 <__umoddi3>
  8002bd:	83 c4 14             	add    $0x14,%esp
  8002c0:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002c7:	50                   	push   %eax
  8002c8:	ff d6                	call   *%esi
  8002ca:	83 c4 10             	add    $0x10,%esp
	}
}
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002df:	8b 10                	mov    (%eax),%edx
  8002e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e4:	73 0a                	jae    8002f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e9:	89 08                	mov    %ecx,(%eax)
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	88 02                	mov    %al,(%edx)
}
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <printfmt>:
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	57                   	push   %edi
  800313:	56                   	push   %esi
  800314:	53                   	push   %ebx
  800315:	83 ec 3c             	sub    $0x3c,%esp
  800318:	8b 75 08             	mov    0x8(%ebp),%esi
  80031b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800321:	e9 32 04 00 00       	jmp    800758 <vprintfmt+0x449>
		padc = ' ';
  800326:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80032a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800331:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800338:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800346:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80034d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8d 47 01             	lea    0x1(%edi),%eax
  800355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800358:	0f b6 17             	movzbl (%edi),%edx
  80035b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80035e:	3c 55                	cmp    $0x55,%al
  800360:	0f 87 12 05 00 00    	ja     800878 <vprintfmt+0x569>
  800366:	0f b6 c0             	movzbl %al,%eax
  800369:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800373:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800377:	eb d9                	jmp    800352 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800380:	eb d0                	jmp    800352 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800382:	0f b6 d2             	movzbl %dl,%edx
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800388:	b8 00 00 00 00       	mov    $0x0,%eax
  80038d:	89 75 08             	mov    %esi,0x8(%ebp)
  800390:	eb 03                	jmp    800395 <vprintfmt+0x86>
  800392:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800395:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800398:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039f:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003a2:	83 fe 09             	cmp    $0x9,%esi
  8003a5:	76 eb                	jbe    800392 <vprintfmt+0x83>
  8003a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ad:	eb 14                	jmp    8003c3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8d 40 04             	lea    0x4(%eax),%eax
  8003bd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c7:	79 89                	jns    800352 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d6:	e9 77 ff ff ff       	jmp    800352 <vprintfmt+0x43>
  8003db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	0f 48 c1             	cmovs  %ecx,%eax
  8003e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e9:	e9 64 ff ff ff       	jmp    800352 <vprintfmt+0x43>
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f8:	e9 55 ff ff ff       	jmp    800352 <vprintfmt+0x43>
			lflag++;
  8003fd:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800404:	e9 49 ff ff ff       	jmp    800352 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 78 04             	lea    0x4(%eax),%edi
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	53                   	push   %ebx
  800413:	ff 30                	pushl  (%eax)
  800415:	ff d6                	call   *%esi
			break;
  800417:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80041d:	e9 33 03 00 00       	jmp    800755 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8d 78 04             	lea    0x4(%eax),%edi
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	99                   	cltd   
  80042b:	31 d0                	xor    %edx,%eax
  80042d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042f:	83 f8 11             	cmp    $0x11,%eax
  800432:	7f 23                	jg     800457 <vprintfmt+0x148>
  800434:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  80043b:	85 d2                	test   %edx,%edx
  80043d:	74 18                	je     800457 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80043f:	52                   	push   %edx
  800440:	68 3d 2a 80 00       	push   $0x802a3d
  800445:	53                   	push   %ebx
  800446:	56                   	push   %esi
  800447:	e8 a6 fe ff ff       	call   8002f2 <printfmt>
  80044c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800452:	e9 fe 02 00 00       	jmp    800755 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800457:	50                   	push   %eax
  800458:	68 01 26 80 00       	push   $0x802601
  80045d:	53                   	push   %ebx
  80045e:	56                   	push   %esi
  80045f:	e8 8e fe ff ff       	call   8002f2 <printfmt>
  800464:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800467:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046a:	e9 e6 02 00 00       	jmp    800755 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80046f:	8b 45 14             	mov    0x14(%ebp),%eax
  800472:	83 c0 04             	add    $0x4,%eax
  800475:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80047d:	85 c9                	test   %ecx,%ecx
  80047f:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  800484:	0f 45 c1             	cmovne %ecx,%eax
  800487:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80048a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048e:	7e 06                	jle    800496 <vprintfmt+0x187>
  800490:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800494:	75 0d                	jne    8004a3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800496:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800499:	89 c7                	mov    %eax,%edi
  80049b:	03 45 e0             	add    -0x20(%ebp),%eax
  80049e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a1:	eb 53                	jmp    8004f6 <vprintfmt+0x1e7>
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a9:	50                   	push   %eax
  8004aa:	e8 71 04 00 00       	call   800920 <strnlen>
  8004af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b2:	29 c1                	sub    %eax,%ecx
  8004b4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004bc:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	eb 0f                	jmp    8004d4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	53                   	push   %ebx
  8004c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ce:	83 ef 01             	sub    $0x1,%edi
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	85 ff                	test   %edi,%edi
  8004d6:	7f ed                	jg     8004c5 <vprintfmt+0x1b6>
  8004d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004db:	85 c9                	test   %ecx,%ecx
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	0f 49 c1             	cmovns %ecx,%eax
  8004e5:	29 c1                	sub    %eax,%ecx
  8004e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004ea:	eb aa                	jmp    800496 <vprintfmt+0x187>
					putch(ch, putdat);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	53                   	push   %ebx
  8004f0:	52                   	push   %edx
  8004f1:	ff d6                	call   *%esi
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fb:	83 c7 01             	add    $0x1,%edi
  8004fe:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800502:	0f be d0             	movsbl %al,%edx
  800505:	85 d2                	test   %edx,%edx
  800507:	74 4b                	je     800554 <vprintfmt+0x245>
  800509:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050d:	78 06                	js     800515 <vprintfmt+0x206>
  80050f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800513:	78 1e                	js     800533 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800515:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800519:	74 d1                	je     8004ec <vprintfmt+0x1dd>
  80051b:	0f be c0             	movsbl %al,%eax
  80051e:	83 e8 20             	sub    $0x20,%eax
  800521:	83 f8 5e             	cmp    $0x5e,%eax
  800524:	76 c6                	jbe    8004ec <vprintfmt+0x1dd>
					putch('?', putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	53                   	push   %ebx
  80052a:	6a 3f                	push   $0x3f
  80052c:	ff d6                	call   *%esi
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	eb c3                	jmp    8004f6 <vprintfmt+0x1e7>
  800533:	89 cf                	mov    %ecx,%edi
  800535:	eb 0e                	jmp    800545 <vprintfmt+0x236>
				putch(' ', putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	6a 20                	push   $0x20
  80053d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053f:	83 ef 01             	sub    $0x1,%edi
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	85 ff                	test   %edi,%edi
  800547:	7f ee                	jg     800537 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800549:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054c:	89 45 14             	mov    %eax,0x14(%ebp)
  80054f:	e9 01 02 00 00       	jmp    800755 <vprintfmt+0x446>
  800554:	89 cf                	mov    %ecx,%edi
  800556:	eb ed                	jmp    800545 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800558:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80055b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800562:	e9 eb fd ff ff       	jmp    800352 <vprintfmt+0x43>
	if (lflag >= 2)
  800567:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80056b:	7f 21                	jg     80058e <vprintfmt+0x27f>
	else if (lflag)
  80056d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800571:	74 68                	je     8005db <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80057b:	89 c1                	mov    %eax,%ecx
  80057d:	c1 f9 1f             	sar    $0x1f,%ecx
  800580:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
  80058c:	eb 17                	jmp    8005a5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8b 50 04             	mov    0x4(%eax),%edx
  800594:	8b 00                	mov    (%eax),%eax
  800596:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800599:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8d 40 08             	lea    0x8(%eax),%eax
  8005a2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b5:	78 3f                	js     8005f6 <vprintfmt+0x2e7>
			base = 10;
  8005b7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005bc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005c0:	0f 84 71 01 00 00    	je     800737 <vprintfmt+0x428>
				putch('+', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2b                	push   $0x2b
  8005cc:	ff d6                	call   *%esi
  8005ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 5c 01 00 00       	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e3:	89 c1                	mov    %eax,%ecx
  8005e5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 40 04             	lea    0x4(%eax),%eax
  8005f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f4:	eb af                	jmp    8005a5 <vprintfmt+0x296>
				putch('-', putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	6a 2d                	push   $0x2d
  8005fc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800601:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800604:	f7 d8                	neg    %eax
  800606:	83 d2 00             	adc    $0x0,%edx
  800609:	f7 da                	neg    %edx
  80060b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800611:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 19 01 00 00       	jmp    800737 <vprintfmt+0x428>
	if (lflag >= 2)
  80061e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800622:	7f 29                	jg     80064d <vprintfmt+0x33e>
	else if (lflag)
  800624:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800628:	74 44                	je     80066e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	ba 00 00 00 00       	mov    $0x0,%edx
  800634:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
  800648:	e9 ea 00 00 00       	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 50 04             	mov    0x4(%eax),%edx
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 08             	lea    0x8(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800664:	b8 0a 00 00 00       	mov    $0xa,%eax
  800669:	e9 c9 00 00 00       	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	ba 00 00 00 00       	mov    $0x0,%edx
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800687:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068c:	e9 a6 00 00 00       	jmp    800737 <vprintfmt+0x428>
			putch('0', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	53                   	push   %ebx
  800695:	6a 30                	push   $0x30
  800697:	ff d6                	call   *%esi
	if (lflag >= 2)
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a0:	7f 26                	jg     8006c8 <vprintfmt+0x3b9>
	else if (lflag)
  8006a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a6:	74 3e                	je     8006e6 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c6:	eb 6f                	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 08             	lea    0x8(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006df:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e4:	eb 51                	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ff:	b8 08 00 00 00       	mov    $0x8,%eax
  800704:	eb 31                	jmp    800737 <vprintfmt+0x428>
			putch('0', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	6a 30                	push   $0x30
  80070c:	ff d6                	call   *%esi
			putch('x', putdat);
  80070e:	83 c4 08             	add    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 78                	push   $0x78
  800714:	ff d6                	call   *%esi
			num = (unsigned long long)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800726:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80073e:	52                   	push   %edx
  80073f:	ff 75 e0             	pushl  -0x20(%ebp)
  800742:	50                   	push   %eax
  800743:	ff 75 dc             	pushl  -0x24(%ebp)
  800746:	ff 75 d8             	pushl  -0x28(%ebp)
  800749:	89 da                	mov    %ebx,%edx
  80074b:	89 f0                	mov    %esi,%eax
  80074d:	e8 a4 fa ff ff       	call   8001f6 <printnum>
			break;
  800752:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800755:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800758:	83 c7 01             	add    $0x1,%edi
  80075b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075f:	83 f8 25             	cmp    $0x25,%eax
  800762:	0f 84 be fb ff ff    	je     800326 <vprintfmt+0x17>
			if (ch == '\0')
  800768:	85 c0                	test   %eax,%eax
  80076a:	0f 84 28 01 00 00    	je     800898 <vprintfmt+0x589>
			putch(ch, putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	50                   	push   %eax
  800775:	ff d6                	call   *%esi
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	eb dc                	jmp    800758 <vprintfmt+0x449>
	if (lflag >= 2)
  80077c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800780:	7f 26                	jg     8007a8 <vprintfmt+0x499>
	else if (lflag)
  800782:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800786:	74 41                	je     8007c9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	ba 00 00 00 00       	mov    $0x0,%edx
  800792:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800795:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a6:	eb 8f                	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 50 04             	mov    0x4(%eax),%edx
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 08             	lea    0x8(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c4:	e9 6e ff ff ff       	jmp    800737 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e7:	e9 4b ff ff ff       	jmp    800737 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 c0 04             	add    $0x4,%eax
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	74 14                	je     800812 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007fe:	8b 13                	mov    (%ebx),%edx
  800800:	83 fa 7f             	cmp    $0x7f,%edx
  800803:	7f 37                	jg     80083c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800805:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800807:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	e9 43 ff ff ff       	jmp    800755 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
  800817:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	50                   	push   %eax
  800821:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800823:	83 c7 01             	add    $0x1,%edi
  800826:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	85 c0                	test   %eax,%eax
  80082f:	75 eb                	jne    80081c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
  800837:	e9 19 ff ff ff       	jmp    800755 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80083c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80083e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800843:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	53                   	push   %ebx
  80084c:	50                   	push   %eax
  80084d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084f:	83 c7 01             	add    $0x1,%edi
  800852:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	85 c0                	test   %eax,%eax
  80085b:	75 eb                	jne    800848 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80085d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
  800863:	e9 ed fe ff ff       	jmp    800755 <vprintfmt+0x446>
			putch(ch, putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 25                	push   $0x25
  80086e:	ff d6                	call   *%esi
			break;
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	e9 dd fe ff ff       	jmp    800755 <vprintfmt+0x446>
			putch('%', putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	6a 25                	push   $0x25
  80087e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	89 f8                	mov    %edi,%eax
  800885:	eb 03                	jmp    80088a <vprintfmt+0x57b>
  800887:	83 e8 01             	sub    $0x1,%eax
  80088a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80088e:	75 f7                	jne    800887 <vprintfmt+0x578>
  800890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800893:	e9 bd fe ff ff       	jmp    800755 <vprintfmt+0x446>
}
  800898:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5f                   	pop    %edi
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 18             	sub    $0x18,%esp
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008af:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	74 26                	je     8008e7 <vsnprintf+0x47>
  8008c1:	85 d2                	test   %edx,%edx
  8008c3:	7e 22                	jle    8008e7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c5:	ff 75 14             	pushl  0x14(%ebp)
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ce:	50                   	push   %eax
  8008cf:	68 d5 02 80 00       	push   $0x8002d5
  8008d4:	e8 36 fa ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
}
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    
		return -E_INVAL;
  8008e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ec:	eb f7                	jmp    8008e5 <vsnprintf+0x45>

008008ee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	ff 75 08             	pushl  0x8(%ebp)
  800901:	e8 9a ff ff ff       	call   8008a0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800917:	74 05                	je     80091e <strlen+0x16>
		n++;
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	eb f5                	jmp    800913 <strlen+0xb>
	return n;
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 0d                	je     80093f <strnlen+0x1f>
  800932:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800936:	74 05                	je     80093d <strnlen+0x1d>
		n++;
  800938:	83 c2 01             	add    $0x1,%edx
  80093b:	eb f1                	jmp    80092e <strnlen+0xe>
  80093d:	89 d0                	mov    %edx,%eax
	return n;
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800954:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	84 c9                	test   %cl,%cl
  80095c:	75 f2                	jne    800950 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80095e:	5b                   	pop    %ebx
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	83 ec 10             	sub    $0x10,%esp
  800968:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096b:	53                   	push   %ebx
  80096c:	e8 97 ff ff ff       	call   800908 <strlen>
  800971:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	01 d8                	add    %ebx,%eax
  800979:	50                   	push   %eax
  80097a:	e8 c2 ff ff ff       	call   800941 <strcpy>
	return dst;
}
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800991:	89 c6                	mov    %eax,%esi
  800993:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800996:	89 c2                	mov    %eax,%edx
  800998:	39 f2                	cmp    %esi,%edx
  80099a:	74 11                	je     8009ad <strncpy+0x27>
		*dst++ = *src;
  80099c:	83 c2 01             	add    $0x1,%edx
  80099f:	0f b6 19             	movzbl (%ecx),%ebx
  8009a2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a5:	80 fb 01             	cmp    $0x1,%bl
  8009a8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009ab:	eb eb                	jmp    800998 <strncpy+0x12>
	}
	return ret;
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c1:	85 d2                	test   %edx,%edx
  8009c3:	74 21                	je     8009e6 <strlcpy+0x35>
  8009c5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	74 14                	je     8009e3 <strlcpy+0x32>
  8009cf:	0f b6 19             	movzbl (%ecx),%ebx
  8009d2:	84 db                	test   %bl,%bl
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x30>
			*dst++ = *src++;
  8009d6:	83 c1 01             	add    $0x1,%ecx
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009df:	eb ea                	jmp    8009cb <strlcpy+0x1a>
  8009e1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f5:	0f b6 01             	movzbl (%ecx),%eax
  8009f8:	84 c0                	test   %al,%al
  8009fa:	74 0c                	je     800a08 <strcmp+0x1c>
  8009fc:	3a 02                	cmp    (%edx),%al
  8009fe:	75 08                	jne    800a08 <strcmp+0x1c>
		p++, q++;
  800a00:	83 c1 01             	add    $0x1,%ecx
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	eb ed                	jmp    8009f5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 c0             	movzbl %al,%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 c3                	mov    %eax,%ebx
  800a1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a21:	eb 06                	jmp    800a29 <strncmp+0x17>
		n--, p++, q++;
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a29:	39 d8                	cmp    %ebx,%eax
  800a2b:	74 16                	je     800a43 <strncmp+0x31>
  800a2d:	0f b6 08             	movzbl (%eax),%ecx
  800a30:	84 c9                	test   %cl,%cl
  800a32:	74 04                	je     800a38 <strncmp+0x26>
  800a34:	3a 0a                	cmp    (%edx),%cl
  800a36:	74 eb                	je     800a23 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
}
  800a40:	5b                   	pop    %ebx
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    
		return 0;
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
  800a48:	eb f6                	jmp    800a40 <strncmp+0x2e>

00800a4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	0f b6 10             	movzbl (%eax),%edx
  800a57:	84 d2                	test   %dl,%dl
  800a59:	74 09                	je     800a64 <strchr+0x1a>
		if (*s == c)
  800a5b:	38 ca                	cmp    %cl,%dl
  800a5d:	74 0a                	je     800a69 <strchr+0x1f>
	for (; *s; s++)
  800a5f:	83 c0 01             	add    $0x1,%eax
  800a62:	eb f0                	jmp    800a54 <strchr+0xa>
			return (char *) s;
	return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a78:	38 ca                	cmp    %cl,%dl
  800a7a:	74 09                	je     800a85 <strfind+0x1a>
  800a7c:	84 d2                	test   %dl,%dl
  800a7e:	74 05                	je     800a85 <strfind+0x1a>
	for (; *s; s++)
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	eb f0                	jmp    800a75 <strfind+0xa>
			break;
	return (char *) s;
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a93:	85 c9                	test   %ecx,%ecx
  800a95:	74 31                	je     800ac8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a97:	89 f8                	mov    %edi,%eax
  800a99:	09 c8                	or     %ecx,%eax
  800a9b:	a8 03                	test   $0x3,%al
  800a9d:	75 23                	jne    800ac2 <memset+0x3b>
		c &= 0xFF;
  800a9f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa3:	89 d3                	mov    %edx,%ebx
  800aa5:	c1 e3 08             	shl    $0x8,%ebx
  800aa8:	89 d0                	mov    %edx,%eax
  800aaa:	c1 e0 18             	shl    $0x18,%eax
  800aad:	89 d6                	mov    %edx,%esi
  800aaf:	c1 e6 10             	shl    $0x10,%esi
  800ab2:	09 f0                	or     %esi,%eax
  800ab4:	09 c2                	or     %eax,%edx
  800ab6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	fc                   	cld    
  800abe:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac0:	eb 06                	jmp    800ac8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	fc                   	cld    
  800ac6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac8:	89 f8                	mov    %edi,%eax
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5f                   	pop    %edi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ada:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800add:	39 c6                	cmp    %eax,%esi
  800adf:	73 32                	jae    800b13 <memmove+0x44>
  800ae1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae4:	39 c2                	cmp    %eax,%edx
  800ae6:	76 2b                	jbe    800b13 <memmove+0x44>
		s += n;
		d += n;
  800ae8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aeb:	89 fe                	mov    %edi,%esi
  800aed:	09 ce                	or     %ecx,%esi
  800aef:	09 d6                	or     %edx,%esi
  800af1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af7:	75 0e                	jne    800b07 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af9:	83 ef 04             	sub    $0x4,%edi
  800afc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aff:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b02:	fd                   	std    
  800b03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b05:	eb 09                	jmp    800b10 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b07:	83 ef 01             	sub    $0x1,%edi
  800b0a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b0d:	fd                   	std    
  800b0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b10:	fc                   	cld    
  800b11:	eb 1a                	jmp    800b2d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b13:	89 c2                	mov    %eax,%edx
  800b15:	09 ca                	or     %ecx,%edx
  800b17:	09 f2                	or     %esi,%edx
  800b19:	f6 c2 03             	test   $0x3,%dl
  800b1c:	75 0a                	jne    800b28 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b21:	89 c7                	mov    %eax,%edi
  800b23:	fc                   	cld    
  800b24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b26:	eb 05                	jmp    800b2d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	fc                   	cld    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b2d:	5e                   	pop    %esi
  800b2e:	5f                   	pop    %edi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b37:	ff 75 10             	pushl  0x10(%ebp)
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	ff 75 08             	pushl  0x8(%ebp)
  800b40:	e8 8a ff ff ff       	call   800acf <memmove>
}
  800b45:	c9                   	leave  
  800b46:	c3                   	ret    

00800b47 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b52:	89 c6                	mov    %eax,%esi
  800b54:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b57:	39 f0                	cmp    %esi,%eax
  800b59:	74 1c                	je     800b77 <memcmp+0x30>
		if (*s1 != *s2)
  800b5b:	0f b6 08             	movzbl (%eax),%ecx
  800b5e:	0f b6 1a             	movzbl (%edx),%ebx
  800b61:	38 d9                	cmp    %bl,%cl
  800b63:	75 08                	jne    800b6d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b65:	83 c0 01             	add    $0x1,%eax
  800b68:	83 c2 01             	add    $0x1,%edx
  800b6b:	eb ea                	jmp    800b57 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b6d:	0f b6 c1             	movzbl %cl,%eax
  800b70:	0f b6 db             	movzbl %bl,%ebx
  800b73:	29 d8                	sub    %ebx,%eax
  800b75:	eb 05                	jmp    800b7c <memcmp+0x35>
	}

	return 0;
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7c:	5b                   	pop    %ebx
  800b7d:	5e                   	pop    %esi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b8e:	39 d0                	cmp    %edx,%eax
  800b90:	73 09                	jae    800b9b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b92:	38 08                	cmp    %cl,(%eax)
  800b94:	74 05                	je     800b9b <memfind+0x1b>
	for (; s < ends; s++)
  800b96:	83 c0 01             	add    $0x1,%eax
  800b99:	eb f3                	jmp    800b8e <memfind+0xe>
			break;
	return (void *) s;
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba9:	eb 03                	jmp    800bae <strtol+0x11>
		s++;
  800bab:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bae:	0f b6 01             	movzbl (%ecx),%eax
  800bb1:	3c 20                	cmp    $0x20,%al
  800bb3:	74 f6                	je     800bab <strtol+0xe>
  800bb5:	3c 09                	cmp    $0x9,%al
  800bb7:	74 f2                	je     800bab <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb9:	3c 2b                	cmp    $0x2b,%al
  800bbb:	74 2a                	je     800be7 <strtol+0x4a>
	int neg = 0;
  800bbd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc2:	3c 2d                	cmp    $0x2d,%al
  800bc4:	74 2b                	je     800bf1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bcc:	75 0f                	jne    800bdd <strtol+0x40>
  800bce:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd1:	74 28                	je     800bfb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bd3:	85 db                	test   %ebx,%ebx
  800bd5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bda:	0f 44 d8             	cmove  %eax,%ebx
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800be5:	eb 50                	jmp    800c37 <strtol+0x9a>
		s++;
  800be7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bea:	bf 00 00 00 00       	mov    $0x0,%edi
  800bef:	eb d5                	jmp    800bc6 <strtol+0x29>
		s++, neg = 1;
  800bf1:	83 c1 01             	add    $0x1,%ecx
  800bf4:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf9:	eb cb                	jmp    800bc6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bff:	74 0e                	je     800c0f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c01:	85 db                	test   %ebx,%ebx
  800c03:	75 d8                	jne    800bdd <strtol+0x40>
		s++, base = 8;
  800c05:	83 c1 01             	add    $0x1,%ecx
  800c08:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c0d:	eb ce                	jmp    800bdd <strtol+0x40>
		s += 2, base = 16;
  800c0f:	83 c1 02             	add    $0x2,%ecx
  800c12:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c17:	eb c4                	jmp    800bdd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c19:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c1c:	89 f3                	mov    %esi,%ebx
  800c1e:	80 fb 19             	cmp    $0x19,%bl
  800c21:	77 29                	ja     800c4c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c23:	0f be d2             	movsbl %dl,%edx
  800c26:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c29:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c2c:	7d 30                	jge    800c5e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2e:	83 c1 01             	add    $0x1,%ecx
  800c31:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c35:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c37:	0f b6 11             	movzbl (%ecx),%edx
  800c3a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c3d:	89 f3                	mov    %esi,%ebx
  800c3f:	80 fb 09             	cmp    $0x9,%bl
  800c42:	77 d5                	ja     800c19 <strtol+0x7c>
			dig = *s - '0';
  800c44:	0f be d2             	movsbl %dl,%edx
  800c47:	83 ea 30             	sub    $0x30,%edx
  800c4a:	eb dd                	jmp    800c29 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c4c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c4f:	89 f3                	mov    %esi,%ebx
  800c51:	80 fb 19             	cmp    $0x19,%bl
  800c54:	77 08                	ja     800c5e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c56:	0f be d2             	movsbl %dl,%edx
  800c59:	83 ea 37             	sub    $0x37,%edx
  800c5c:	eb cb                	jmp    800c29 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c62:	74 05                	je     800c69 <strtol+0xcc>
		*endptr = (char *) s;
  800c64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c67:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	85 ff                	test   %edi,%edi
  800c6f:	0f 45 c2             	cmovne %edx,%eax
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c88:	89 c3                	mov    %eax,%ebx
  800c8a:	89 c7                	mov    %eax,%edi
  800c8c:	89 c6                	mov    %eax,%esi
  800c8e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cca:	89 cb                	mov    %ecx,%ebx
  800ccc:	89 cf                	mov    %ecx,%edi
  800cce:	89 ce                	mov    %ecx,%esi
  800cd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	7f 08                	jg     800cde <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cde:	83 ec 0c             	sub    $0xc,%esp
  800ce1:	50                   	push   %eax
  800ce2:	6a 03                	push   $0x3
  800ce4:	68 68 29 80 00       	push   $0x802968
  800ce9:	6a 43                	push   $0x43
  800ceb:	68 85 29 80 00       	push   $0x802985
  800cf0:	e8 89 14 00 00       	call   80217e <_panic>

00800cf5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_yield>:

void
sys_yield(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3c:	be 00 00 00 00       	mov    $0x0,%esi
  800d41:	8b 55 08             	mov    0x8(%ebp),%edx
  800d44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d47:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4f:	89 f7                	mov    %esi,%edi
  800d51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7f 08                	jg     800d5f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	50                   	push   %eax
  800d63:	6a 04                	push   $0x4
  800d65:	68 68 29 80 00       	push   $0x802968
  800d6a:	6a 43                	push   $0x43
  800d6c:	68 85 29 80 00       	push   $0x802985
  800d71:	e8 08 14 00 00       	call   80217e <_panic>

00800d76 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	b8 05 00 00 00       	mov    $0x5,%eax
  800d8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d90:	8b 75 18             	mov    0x18(%ebp),%esi
  800d93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d95:	85 c0                	test   %eax,%eax
  800d97:	7f 08                	jg     800da1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da1:	83 ec 0c             	sub    $0xc,%esp
  800da4:	50                   	push   %eax
  800da5:	6a 05                	push   $0x5
  800da7:	68 68 29 80 00       	push   $0x802968
  800dac:	6a 43                	push   $0x43
  800dae:	68 85 29 80 00       	push   $0x802985
  800db3:	e8 c6 13 00 00       	call   80217e <_panic>

00800db8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcc:	b8 06 00 00 00       	mov    $0x6,%eax
  800dd1:	89 df                	mov    %ebx,%edi
  800dd3:	89 de                	mov    %ebx,%esi
  800dd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7f 08                	jg     800de3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de3:	83 ec 0c             	sub    $0xc,%esp
  800de6:	50                   	push   %eax
  800de7:	6a 06                	push   $0x6
  800de9:	68 68 29 80 00       	push   $0x802968
  800dee:	6a 43                	push   $0x43
  800df0:	68 85 29 80 00       	push   $0x802985
  800df5:	e8 84 13 00 00       	call   80217e <_panic>

00800dfa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 08                	push   $0x8
  800e2b:	68 68 29 80 00       	push   $0x802968
  800e30:	6a 43                	push   $0x43
  800e32:	68 85 29 80 00       	push   $0x802985
  800e37:	e8 42 13 00 00       	call   80217e <_panic>

00800e3c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	b8 09 00 00 00       	mov    $0x9,%eax
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 09                	push   $0x9
  800e6d:	68 68 29 80 00       	push   $0x802968
  800e72:	6a 43                	push   $0x43
  800e74:	68 85 29 80 00       	push   $0x802985
  800e79:	e8 00 13 00 00       	call   80217e <_panic>

00800e7e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e97:	89 df                	mov    %ebx,%edi
  800e99:	89 de                	mov    %ebx,%esi
  800e9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	7f 08                	jg     800ea9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	83 ec 0c             	sub    $0xc,%esp
  800eac:	50                   	push   %eax
  800ead:	6a 0a                	push   $0xa
  800eaf:	68 68 29 80 00       	push   $0x802968
  800eb4:	6a 43                	push   $0x43
  800eb6:	68 85 29 80 00       	push   $0x802985
  800ebb:	e8 be 12 00 00       	call   80217e <_panic>

00800ec0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed1:	be 00 00 00 00       	mov    $0x0,%esi
  800ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef9:	89 cb                	mov    %ecx,%ebx
  800efb:	89 cf                	mov    %ecx,%edi
  800efd:	89 ce                	mov    %ecx,%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 0d                	push   $0xd
  800f13:	68 68 29 80 00       	push   $0x802968
  800f18:	6a 43                	push   $0x43
  800f1a:	68 85 29 80 00       	push   $0x802985
  800f1f:	e8 5a 12 00 00       	call   80217e <_panic>

00800f24 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f35:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f3a:	89 df                	mov    %ebx,%edi
  800f3c:	89 de                	mov    %ebx,%esi
  800f3e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f58:	89 cb                	mov    %ecx,%ebx
  800f5a:	89 cf                	mov    %ecx,%edi
  800f5c:	89 ce                	mov    %ecx,%esi
  800f5e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	b8 10 00 00 00       	mov    $0x10,%eax
  800f75:	89 d1                	mov    %edx,%ecx
  800f77:	89 d3                	mov    %edx,%ebx
  800f79:	89 d7                	mov    %edx,%edi
  800f7b:	89 d6                	mov    %edx,%esi
  800f7d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f7f:	5b                   	pop    %ebx
  800f80:	5e                   	pop    %esi
  800f81:	5f                   	pop    %edi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	b8 11 00 00 00       	mov    $0x11,%eax
  800f9a:	89 df                	mov    %ebx,%edi
  800f9c:	89 de                	mov    %ebx,%esi
  800f9e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 12 00 00 00       	mov    $0x12,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
  800fcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	b8 13 00 00 00       	mov    $0x13,%eax
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	89 de                	mov    %ebx,%esi
  800fe3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	7f 08                	jg     800ff1 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff1:	83 ec 0c             	sub    $0xc,%esp
  800ff4:	50                   	push   %eax
  800ff5:	6a 13                	push   $0x13
  800ff7:	68 68 29 80 00       	push   $0x802968
  800ffc:	6a 43                	push   $0x43
  800ffe:	68 85 29 80 00       	push   $0x802985
  801003:	e8 76 11 00 00       	call   80217e <_panic>

00801008 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	b8 14 00 00 00       	mov    $0x14,%eax
  80101b:	89 cb                	mov    %ecx,%ebx
  80101d:	89 cf                	mov    %ecx,%edi
  80101f:	89 ce                	mov    %ecx,%esi
  801021:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5f                   	pop    %edi
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	05 00 00 00 30       	add    $0x30000000,%eax
  801033:	c1 e8 0c             	shr    $0xc,%eax
}
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801043:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801048:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801057:	89 c2                	mov    %eax,%edx
  801059:	c1 ea 16             	shr    $0x16,%edx
  80105c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801063:	f6 c2 01             	test   $0x1,%dl
  801066:	74 2d                	je     801095 <fd_alloc+0x46>
  801068:	89 c2                	mov    %eax,%edx
  80106a:	c1 ea 0c             	shr    $0xc,%edx
  80106d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801074:	f6 c2 01             	test   $0x1,%dl
  801077:	74 1c                	je     801095 <fd_alloc+0x46>
  801079:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80107e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801083:	75 d2                	jne    801057 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80108e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801093:	eb 0a                	jmp    80109f <fd_alloc+0x50>
			*fd_store = fd;
  801095:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801098:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a7:	83 f8 1f             	cmp    $0x1f,%eax
  8010aa:	77 30                	ja     8010dc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ac:	c1 e0 0c             	shl    $0xc,%eax
  8010af:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ba:	f6 c2 01             	test   $0x1,%dl
  8010bd:	74 24                	je     8010e3 <fd_lookup+0x42>
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	c1 ea 0c             	shr    $0xc,%edx
  8010c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cb:	f6 c2 01             	test   $0x1,%dl
  8010ce:	74 1a                	je     8010ea <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    
		return -E_INVAL;
  8010dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e1:	eb f7                	jmp    8010da <fd_lookup+0x39>
		return -E_INVAL;
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e8:	eb f0                	jmp    8010da <fd_lookup+0x39>
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ef:	eb e9                	jmp    8010da <fd_lookup+0x39>

008010f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801104:	39 08                	cmp    %ecx,(%eax)
  801106:	74 38                	je     801140 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801108:	83 c2 01             	add    $0x1,%edx
  80110b:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801112:	85 c0                	test   %eax,%eax
  801114:	75 ee                	jne    801104 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801116:	a1 08 40 80 00       	mov    0x804008,%eax
  80111b:	8b 40 48             	mov    0x48(%eax),%eax
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	51                   	push   %ecx
  801122:	50                   	push   %eax
  801123:	68 94 29 80 00       	push   $0x802994
  801128:	e8 b5 f0 ff ff       	call   8001e2 <cprintf>
	*dev = 0;
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    
			*dev = devtab[i];
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	89 01                	mov    %eax,(%ecx)
			return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb f2                	jmp    80113e <dev_lookup+0x4d>

0080114c <fd_close>:
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 24             	sub    $0x24,%esp
  801155:	8b 75 08             	mov    0x8(%ebp),%esi
  801158:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801168:	50                   	push   %eax
  801169:	e8 33 ff ff ff       	call   8010a1 <fd_lookup>
  80116e:	89 c3                	mov    %eax,%ebx
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	78 05                	js     80117c <fd_close+0x30>
	    || fd != fd2)
  801177:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80117a:	74 16                	je     801192 <fd_close+0x46>
		return (must_exist ? r : 0);
  80117c:	89 f8                	mov    %edi,%eax
  80117e:	84 c0                	test   %al,%al
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	0f 44 d8             	cmove  %eax,%ebx
}
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	ff 36                	pushl  (%esi)
  80119b:	e8 51 ff ff ff       	call   8010f1 <dev_lookup>
  8011a0:	89 c3                	mov    %eax,%ebx
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	78 1a                	js     8011c3 <fd_close+0x77>
		if (dev->dev_close)
  8011a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ac:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	74 0b                	je     8011c3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	56                   	push   %esi
  8011bc:	ff d0                	call   *%eax
  8011be:	89 c3                	mov    %eax,%ebx
  8011c0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	56                   	push   %esi
  8011c7:	6a 00                	push   $0x0
  8011c9:	e8 ea fb ff ff       	call   800db8 <sys_page_unmap>
	return r;
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	eb b5                	jmp    801188 <fd_close+0x3c>

008011d3 <close>:

int
close(int fdnum)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011dc:	50                   	push   %eax
  8011dd:	ff 75 08             	pushl  0x8(%ebp)
  8011e0:	e8 bc fe ff ff       	call   8010a1 <fd_lookup>
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	79 02                	jns    8011ee <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    
		return fd_close(fd, 1);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	6a 01                	push   $0x1
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	e8 51 ff ff ff       	call   80114c <fd_close>
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	eb ec                	jmp    8011ec <close+0x19>

00801200 <close_all>:

void
close_all(void)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801207:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	53                   	push   %ebx
  801210:	e8 be ff ff ff       	call   8011d3 <close>
	for (i = 0; i < MAXFD; i++)
  801215:	83 c3 01             	add    $0x1,%ebx
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 fb 20             	cmp    $0x20,%ebx
  80121e:	75 ec                	jne    80120c <close_all+0xc>
}
  801220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	57                   	push   %edi
  801229:	56                   	push   %esi
  80122a:	53                   	push   %ebx
  80122b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801231:	50                   	push   %eax
  801232:	ff 75 08             	pushl  0x8(%ebp)
  801235:	e8 67 fe ff ff       	call   8010a1 <fd_lookup>
  80123a:	89 c3                	mov    %eax,%ebx
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	0f 88 81 00 00 00    	js     8012c8 <dup+0xa3>
		return r;
	close(newfdnum);
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	e8 81 ff ff ff       	call   8011d3 <close>

	newfd = INDEX2FD(newfdnum);
  801252:	8b 75 0c             	mov    0xc(%ebp),%esi
  801255:	c1 e6 0c             	shl    $0xc,%esi
  801258:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	ff 75 e4             	pushl  -0x1c(%ebp)
  801264:	e8 cf fd ff ff       	call   801038 <fd2data>
  801269:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80126b:	89 34 24             	mov    %esi,(%esp)
  80126e:	e8 c5 fd ff ff       	call   801038 <fd2data>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	c1 e8 16             	shr    $0x16,%eax
  80127d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801284:	a8 01                	test   $0x1,%al
  801286:	74 11                	je     801299 <dup+0x74>
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	c1 e8 0c             	shr    $0xc,%eax
  80128d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801294:	f6 c2 01             	test   $0x1,%dl
  801297:	75 39                	jne    8012d2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80129c:	89 d0                	mov    %edx,%eax
  80129e:	c1 e8 0c             	shr    $0xc,%eax
  8012a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b0:	50                   	push   %eax
  8012b1:	56                   	push   %esi
  8012b2:	6a 00                	push   $0x0
  8012b4:	52                   	push   %edx
  8012b5:	6a 00                	push   $0x0
  8012b7:	e8 ba fa ff ff       	call   800d76 <sys_page_map>
  8012bc:	89 c3                	mov    %eax,%ebx
  8012be:	83 c4 20             	add    $0x20,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 31                	js     8012f6 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cd:	5b                   	pop    %ebx
  8012ce:	5e                   	pop    %esi
  8012cf:	5f                   	pop    %edi
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d9:	83 ec 0c             	sub    $0xc,%esp
  8012dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e1:	50                   	push   %eax
  8012e2:	57                   	push   %edi
  8012e3:	6a 00                	push   $0x0
  8012e5:	53                   	push   %ebx
  8012e6:	6a 00                	push   $0x0
  8012e8:	e8 89 fa ff ff       	call   800d76 <sys_page_map>
  8012ed:	89 c3                	mov    %eax,%ebx
  8012ef:	83 c4 20             	add    $0x20,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 a3                	jns    801299 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	56                   	push   %esi
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 b7 fa ff ff       	call   800db8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801301:	83 c4 08             	add    $0x8,%esp
  801304:	57                   	push   %edi
  801305:	6a 00                	push   $0x0
  801307:	e8 ac fa ff ff       	call   800db8 <sys_page_unmap>
	return r;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	eb b7                	jmp    8012c8 <dup+0xa3>

00801311 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	53                   	push   %ebx
  801315:	83 ec 1c             	sub    $0x1c,%esp
  801318:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131e:	50                   	push   %eax
  80131f:	53                   	push   %ebx
  801320:	e8 7c fd ff ff       	call   8010a1 <fd_lookup>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 3f                	js     80136b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	ff 30                	pushl  (%eax)
  801338:	e8 b4 fd ff ff       	call   8010f1 <dev_lookup>
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	78 27                	js     80136b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 42 08             	mov    0x8(%edx),%eax
  80134a:	83 e0 03             	and    $0x3,%eax
  80134d:	83 f8 01             	cmp    $0x1,%eax
  801350:	74 1e                	je     801370 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	8b 40 08             	mov    0x8(%eax),%eax
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 35                	je     801391 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	ff 75 10             	pushl  0x10(%ebp)
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	52                   	push   %edx
  801366:	ff d0                	call   *%eax
  801368:	83 c4 10             	add    $0x10,%esp
}
  80136b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801370:	a1 08 40 80 00       	mov    0x804008,%eax
  801375:	8b 40 48             	mov    0x48(%eax),%eax
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	53                   	push   %ebx
  80137c:	50                   	push   %eax
  80137d:	68 d5 29 80 00       	push   $0x8029d5
  801382:	e8 5b ee ff ff       	call   8001e2 <cprintf>
		return -E_INVAL;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138f:	eb da                	jmp    80136b <read+0x5a>
		return -E_NOT_SUPP;
  801391:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801396:	eb d3                	jmp    80136b <read+0x5a>

00801398 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ac:	39 f3                	cmp    %esi,%ebx
  8013ae:	73 23                	jae    8013d3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	89 f0                	mov    %esi,%eax
  8013b5:	29 d8                	sub    %ebx,%eax
  8013b7:	50                   	push   %eax
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	03 45 0c             	add    0xc(%ebp),%eax
  8013bd:	50                   	push   %eax
  8013be:	57                   	push   %edi
  8013bf:	e8 4d ff ff ff       	call   801311 <read>
		if (m < 0)
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 06                	js     8013d1 <readn+0x39>
			return m;
		if (m == 0)
  8013cb:	74 06                	je     8013d3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013cd:	01 c3                	add    %eax,%ebx
  8013cf:	eb db                	jmp    8013ac <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	53                   	push   %ebx
  8013e1:	83 ec 1c             	sub    $0x1c,%esp
  8013e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ea:	50                   	push   %eax
  8013eb:	53                   	push   %ebx
  8013ec:	e8 b0 fc ff ff       	call   8010a1 <fd_lookup>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 3a                	js     801432 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801402:	ff 30                	pushl  (%eax)
  801404:	e8 e8 fc ff ff       	call   8010f1 <dev_lookup>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 22                	js     801432 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801417:	74 1e                	je     801437 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141c:	8b 52 0c             	mov    0xc(%edx),%edx
  80141f:	85 d2                	test   %edx,%edx
  801421:	74 35                	je     801458 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	ff 75 10             	pushl  0x10(%ebp)
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	ff d2                	call   *%edx
  80142f:	83 c4 10             	add    $0x10,%esp
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801437:	a1 08 40 80 00       	mov    0x804008,%eax
  80143c:	8b 40 48             	mov    0x48(%eax),%eax
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	53                   	push   %ebx
  801443:	50                   	push   %eax
  801444:	68 f1 29 80 00       	push   $0x8029f1
  801449:	e8 94 ed ff ff       	call   8001e2 <cprintf>
		return -E_INVAL;
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801456:	eb da                	jmp    801432 <write+0x55>
		return -E_NOT_SUPP;
  801458:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145d:	eb d3                	jmp    801432 <write+0x55>

0080145f <seek>:

int
seek(int fdnum, off_t offset)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	ff 75 08             	pushl  0x8(%ebp)
  80146c:	e8 30 fc ff ff       	call   8010a1 <fd_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 0e                	js     801486 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	53                   	push   %ebx
  80148c:	83 ec 1c             	sub    $0x1c,%esp
  80148f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801492:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	53                   	push   %ebx
  801497:	e8 05 fc ff ff       	call   8010a1 <fd_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 37                	js     8014da <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	ff 30                	pushl  (%eax)
  8014af:	e8 3d fc ff ff       	call   8010f1 <dev_lookup>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 1f                	js     8014da <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c2:	74 1b                	je     8014df <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c7:	8b 52 18             	mov    0x18(%edx),%edx
  8014ca:	85 d2                	test   %edx,%edx
  8014cc:	74 32                	je     801500 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ce:	83 ec 08             	sub    $0x8,%esp
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	ff d2                	call   *%edx
  8014d7:	83 c4 10             	add    $0x10,%esp
}
  8014da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014df:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e4:	8b 40 48             	mov    0x48(%eax),%eax
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	53                   	push   %ebx
  8014eb:	50                   	push   %eax
  8014ec:	68 b4 29 80 00       	push   $0x8029b4
  8014f1:	e8 ec ec ff ff       	call   8001e2 <cprintf>
		return -E_INVAL;
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fe:	eb da                	jmp    8014da <ftruncate+0x52>
		return -E_NOT_SUPP;
  801500:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801505:	eb d3                	jmp    8014da <ftruncate+0x52>

00801507 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 1c             	sub    $0x1c,%esp
  80150e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	ff 75 08             	pushl  0x8(%ebp)
  801518:	e8 84 fb ff ff       	call   8010a1 <fd_lookup>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 4b                	js     80156f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152e:	ff 30                	pushl  (%eax)
  801530:	e8 bc fb ff ff       	call   8010f1 <dev_lookup>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 33                	js     80156f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801543:	74 2f                	je     801574 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801545:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801548:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154f:	00 00 00 
	stat->st_isdir = 0;
  801552:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801559:	00 00 00 
	stat->st_dev = dev;
  80155c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	53                   	push   %ebx
  801566:	ff 75 f0             	pushl  -0x10(%ebp)
  801569:	ff 50 14             	call   *0x14(%eax)
  80156c:	83 c4 10             	add    $0x10,%esp
}
  80156f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801572:	c9                   	leave  
  801573:	c3                   	ret    
		return -E_NOT_SUPP;
  801574:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801579:	eb f4                	jmp    80156f <fstat+0x68>

0080157b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	6a 00                	push   $0x0
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	e8 22 02 00 00       	call   8017af <open>
  80158d:	89 c3                	mov    %eax,%ebx
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 1b                	js     8015b1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	50                   	push   %eax
  80159d:	e8 65 ff ff ff       	call   801507 <fstat>
  8015a2:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a4:	89 1c 24             	mov    %ebx,(%esp)
  8015a7:	e8 27 fc ff ff       	call   8011d3 <close>
	return r;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	89 f3                	mov    %esi,%ebx
}
  8015b1:	89 d8                	mov    %ebx,%eax
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	56                   	push   %esi
  8015be:	53                   	push   %ebx
  8015bf:	89 c6                	mov    %eax,%esi
  8015c1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ca:	74 27                	je     8015f3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015cc:	6a 07                	push   $0x7
  8015ce:	68 00 50 80 00       	push   $0x805000
  8015d3:	56                   	push   %esi
  8015d4:	ff 35 00 40 80 00    	pushl  0x804000
  8015da:	e8 69 0c 00 00       	call   802248 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015df:	83 c4 0c             	add    $0xc,%esp
  8015e2:	6a 00                	push   $0x0
  8015e4:	53                   	push   %ebx
  8015e5:	6a 00                	push   $0x0
  8015e7:	e8 f3 0b 00 00       	call   8021df <ipc_recv>
}
  8015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	6a 01                	push   $0x1
  8015f8:	e8 a3 0c 00 00       	call   8022a0 <ipc_find_env>
  8015fd:	a3 00 40 80 00       	mov    %eax,0x804000
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	eb c5                	jmp    8015cc <fsipc+0x12>

00801607 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8b 40 0c             	mov    0xc(%eax),%eax
  801613:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	b8 02 00 00 00       	mov    $0x2,%eax
  80162a:	e8 8b ff ff ff       	call   8015ba <fsipc>
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <devfile_flush>:
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8b 40 0c             	mov    0xc(%eax),%eax
  80163d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 06 00 00 00       	mov    $0x6,%eax
  80164c:	e8 69 ff ff ff       	call   8015ba <fsipc>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_stat>:
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	53                   	push   %ebx
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8b 40 0c             	mov    0xc(%eax),%eax
  801663:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801668:	ba 00 00 00 00       	mov    $0x0,%edx
  80166d:	b8 05 00 00 00       	mov    $0x5,%eax
  801672:	e8 43 ff ff ff       	call   8015ba <fsipc>
  801677:	85 c0                	test   %eax,%eax
  801679:	78 2c                	js     8016a7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	68 00 50 80 00       	push   $0x805000
  801683:	53                   	push   %ebx
  801684:	e8 b8 f2 ff ff       	call   800941 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801689:	a1 80 50 80 00       	mov    0x805080,%eax
  80168e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801694:	a1 84 50 80 00       	mov    0x805084,%eax
  801699:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <devfile_write>:
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016c1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016c7:	53                   	push   %ebx
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	68 08 50 80 00       	push   $0x805008
  8016d0:	e8 5c f4 ff ff       	call   800b31 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	b8 04 00 00 00       	mov    $0x4,%eax
  8016df:	e8 d6 fe ff ff       	call   8015ba <fsipc>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 0b                	js     8016f6 <devfile_write+0x4a>
	assert(r <= n);
  8016eb:	39 d8                	cmp    %ebx,%eax
  8016ed:	77 0c                	ja     8016fb <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016ef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f4:	7f 1e                	jg     801714 <devfile_write+0x68>
}
  8016f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    
	assert(r <= n);
  8016fb:	68 24 2a 80 00       	push   $0x802a24
  801700:	68 2b 2a 80 00       	push   $0x802a2b
  801705:	68 98 00 00 00       	push   $0x98
  80170a:	68 40 2a 80 00       	push   $0x802a40
  80170f:	e8 6a 0a 00 00       	call   80217e <_panic>
	assert(r <= PGSIZE);
  801714:	68 4b 2a 80 00       	push   $0x802a4b
  801719:	68 2b 2a 80 00       	push   $0x802a2b
  80171e:	68 99 00 00 00       	push   $0x99
  801723:	68 40 2a 80 00       	push   $0x802a40
  801728:	e8 51 0a 00 00       	call   80217e <_panic>

0080172d <devfile_read>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8b 40 0c             	mov    0xc(%eax),%eax
  80173b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801740:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	b8 03 00 00 00       	mov    $0x3,%eax
  801750:	e8 65 fe ff ff       	call   8015ba <fsipc>
  801755:	89 c3                	mov    %eax,%ebx
  801757:	85 c0                	test   %eax,%eax
  801759:	78 1f                	js     80177a <devfile_read+0x4d>
	assert(r <= n);
  80175b:	39 f0                	cmp    %esi,%eax
  80175d:	77 24                	ja     801783 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80175f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801764:	7f 33                	jg     801799 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	50                   	push   %eax
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	e8 58 f3 ff ff       	call   800acf <memmove>
	return r;
  801777:	83 c4 10             	add    $0x10,%esp
}
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    
	assert(r <= n);
  801783:	68 24 2a 80 00       	push   $0x802a24
  801788:	68 2b 2a 80 00       	push   $0x802a2b
  80178d:	6a 7c                	push   $0x7c
  80178f:	68 40 2a 80 00       	push   $0x802a40
  801794:	e8 e5 09 00 00       	call   80217e <_panic>
	assert(r <= PGSIZE);
  801799:	68 4b 2a 80 00       	push   $0x802a4b
  80179e:	68 2b 2a 80 00       	push   $0x802a2b
  8017a3:	6a 7d                	push   $0x7d
  8017a5:	68 40 2a 80 00       	push   $0x802a40
  8017aa:	e8 cf 09 00 00       	call   80217e <_panic>

008017af <open>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 1c             	sub    $0x1c,%esp
  8017b7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ba:	56                   	push   %esi
  8017bb:	e8 48 f1 ff ff       	call   800908 <strlen>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c8:	7f 6c                	jg     801836 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	e8 79 f8 ff ff       	call   80104f <fd_alloc>
  8017d6:	89 c3                	mov    %eax,%ebx
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 3c                	js     80181b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	56                   	push   %esi
  8017e3:	68 00 50 80 00       	push   $0x805000
  8017e8:	e8 54 f1 ff ff       	call   800941 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fd:	e8 b8 fd ff ff       	call   8015ba <fsipc>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 19                	js     801824 <open+0x75>
	return fd2num(fd);
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 f4             	pushl  -0xc(%ebp)
  801811:	e8 12 f8 ff ff       	call   801028 <fd2num>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
}
  80181b:	89 d8                	mov    %ebx,%eax
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    
		fd_close(fd, 0);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	6a 00                	push   $0x0
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	e8 1b f9 ff ff       	call   80114c <fd_close>
		return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	eb e5                	jmp    80181b <open+0x6c>
		return -E_BAD_PATH;
  801836:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80183b:	eb de                	jmp    80181b <open+0x6c>

0080183d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801843:	ba 00 00 00 00       	mov    $0x0,%edx
  801848:	b8 08 00 00 00       	mov    $0x8,%eax
  80184d:	e8 68 fd ff ff       	call   8015ba <fsipc>
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80185a:	68 57 2a 80 00       	push   $0x802a57
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	e8 da f0 ff ff       	call   800941 <strcpy>
	return 0;
}
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devsock_close>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
  801872:	83 ec 10             	sub    $0x10,%esp
  801875:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801878:	53                   	push   %ebx
  801879:	e8 61 0a 00 00       	call   8022df <pageref>
  80187e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801886:	83 f8 01             	cmp    $0x1,%eax
  801889:	74 07                	je     801892 <devsock_close+0x24>
}
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801890:	c9                   	leave  
  801891:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	ff 73 0c             	pushl  0xc(%ebx)
  801898:	e8 b9 02 00 00       	call   801b56 <nsipc_close>
  80189d:	89 c2                	mov    %eax,%edx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb e7                	jmp    80188b <devsock_close+0x1d>

008018a4 <devsock_write>:
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 10             	pushl  0x10(%ebp)
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	ff 70 0c             	pushl  0xc(%eax)
  8018b8:	e8 76 03 00 00       	call   801c33 <nsipc_send>
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <devsock_read>:
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 10             	pushl  0x10(%ebp)
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	ff 70 0c             	pushl  0xc(%eax)
  8018d3:	e8 ef 02 00 00       	call   801bc7 <nsipc_recv>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <fd2sockid>:
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018e0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	e8 b7 f7 ff ff       	call   8010a1 <fd_lookup>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 10                	js     801901 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018fa:	39 08                	cmp    %ecx,(%eax)
  8018fc:	75 05                	jne    801903 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018fe:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    
		return -E_NOT_SUPP;
  801903:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801908:	eb f7                	jmp    801901 <fd2sockid+0x27>

0080190a <alloc_sockfd>:
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	56                   	push   %esi
  80190e:	53                   	push   %ebx
  80190f:	83 ec 1c             	sub    $0x1c,%esp
  801912:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	e8 32 f7 ff ff       	call   80104f <fd_alloc>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 43                	js     801969 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 07 04 00 00       	push   $0x407
  80192e:	ff 75 f4             	pushl  -0xc(%ebp)
  801931:	6a 00                	push   $0x0
  801933:	e8 fb f3 ff ff       	call   800d33 <sys_page_alloc>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 28                	js     801969 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80194a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801956:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801959:	83 ec 0c             	sub    $0xc,%esp
  80195c:	50                   	push   %eax
  80195d:	e8 c6 f6 ff ff       	call   801028 <fd2num>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	eb 0c                	jmp    801975 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	56                   	push   %esi
  80196d:	e8 e4 01 00 00       	call   801b56 <nsipc_close>
		return r;
  801972:	83 c4 10             	add    $0x10,%esp
}
  801975:	89 d8                	mov    %ebx,%eax
  801977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <accept>:
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	e8 4e ff ff ff       	call   8018da <fd2sockid>
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 1b                	js     8019ab <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	ff 75 10             	pushl  0x10(%ebp)
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	e8 0e 01 00 00       	call   801aad <nsipc_accept>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 05                	js     8019ab <accept+0x2d>
	return alloc_sockfd(r);
  8019a6:	e8 5f ff ff ff       	call   80190a <alloc_sockfd>
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <bind>:
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	e8 1f ff ff ff       	call   8018da <fd2sockid>
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 12                	js     8019d1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	ff 75 10             	pushl  0x10(%ebp)
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	50                   	push   %eax
  8019c9:	e8 31 01 00 00       	call   801aff <nsipc_bind>
  8019ce:	83 c4 10             	add    $0x10,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <shutdown>:
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	e8 f9 fe ff ff       	call   8018da <fd2sockid>
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 0f                	js     8019f4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	e8 43 01 00 00       	call   801b34 <nsipc_shutdown>
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <connect>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	e8 d6 fe ff ff       	call   8018da <fd2sockid>
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 12                	js     801a1a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	ff 75 10             	pushl  0x10(%ebp)
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	e8 59 01 00 00       	call   801b70 <nsipc_connect>
  801a17:	83 c4 10             	add    $0x10,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <listen>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	e8 b0 fe ff ff       	call   8018da <fd2sockid>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 0f                	js     801a3d <listen+0x21>
	return nsipc_listen(r, backlog);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	e8 6b 01 00 00       	call   801ba5 <nsipc_listen>
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <socket>:

int
socket(int domain, int type, int protocol)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	e8 3e 02 00 00       	call   801c91 <nsipc_socket>
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 05                	js     801a5f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a5a:	e8 ab fe ff ff       	call   80190a <alloc_sockfd>
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a6a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a71:	74 26                	je     801a99 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a73:	6a 07                	push   $0x7
  801a75:	68 00 60 80 00       	push   $0x806000
  801a7a:	53                   	push   %ebx
  801a7b:	ff 35 04 40 80 00    	pushl  0x804004
  801a81:	e8 c2 07 00 00       	call   802248 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a86:	83 c4 0c             	add    $0xc,%esp
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	e8 4b 07 00 00       	call   8021df <ipc_recv>
}
  801a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	6a 02                	push   $0x2
  801a9e:	e8 fd 07 00 00       	call   8022a0 <ipc_find_env>
  801aa3:	a3 04 40 80 00       	mov    %eax,0x804004
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	eb c6                	jmp    801a73 <nsipc+0x12>

00801aad <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801abd:	8b 06                	mov    (%esi),%eax
  801abf:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac9:	e8 93 ff ff ff       	call   801a61 <nsipc>
  801ace:	89 c3                	mov    %eax,%ebx
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	79 09                	jns    801add <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ad4:	89 d8                	mov    %ebx,%eax
  801ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad9:	5b                   	pop    %ebx
  801ada:	5e                   	pop    %esi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	ff 35 10 60 80 00    	pushl  0x806010
  801ae6:	68 00 60 80 00       	push   $0x806000
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	e8 dc ef ff ff       	call   800acf <memmove>
		*addrlen = ret->ret_addrlen;
  801af3:	a1 10 60 80 00       	mov    0x806010,%eax
  801af8:	89 06                	mov    %eax,(%esi)
  801afa:	83 c4 10             	add    $0x10,%esp
	return r;
  801afd:	eb d5                	jmp    801ad4 <nsipc_accept+0x27>

00801aff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	53                   	push   %ebx
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b11:	53                   	push   %ebx
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	68 04 60 80 00       	push   $0x806004
  801b1a:	e8 b0 ef ff ff       	call   800acf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b1f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b25:	b8 02 00 00 00       	mov    $0x2,%eax
  801b2a:	e8 32 ff ff ff       	call   801a61 <nsipc>
}
  801b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b45:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b4a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4f:	e8 0d ff ff ff       	call   801a61 <nsipc>
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <nsipc_close>:

int
nsipc_close(int s)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b64:	b8 04 00 00 00       	mov    $0x4,%eax
  801b69:	e8 f3 fe ff ff       	call   801a61 <nsipc>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	53                   	push   %ebx
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b82:	53                   	push   %ebx
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	68 04 60 80 00       	push   $0x806004
  801b8b:	e8 3f ef ff ff       	call   800acf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b90:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b96:	b8 05 00 00 00       	mov    $0x5,%eax
  801b9b:	e8 c1 fe ff ff       	call   801a61 <nsipc>
}
  801ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bbb:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc0:	e8 9c fe ff ff       	call   801a61 <nsipc>
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bd7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801be0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801be5:	b8 07 00 00 00       	mov    $0x7,%eax
  801bea:	e8 72 fe ff ff       	call   801a61 <nsipc>
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 1f                	js     801c14 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bf5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bfa:	7f 21                	jg     801c1d <nsipc_recv+0x56>
  801bfc:	39 c6                	cmp    %eax,%esi
  801bfe:	7c 1d                	jl     801c1d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	50                   	push   %eax
  801c04:	68 00 60 80 00       	push   $0x806000
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	e8 be ee ff ff       	call   800acf <memmove>
  801c11:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c1d:	68 63 2a 80 00       	push   $0x802a63
  801c22:	68 2b 2a 80 00       	push   $0x802a2b
  801c27:	6a 62                	push   $0x62
  801c29:	68 78 2a 80 00       	push   $0x802a78
  801c2e:	e8 4b 05 00 00       	call   80217e <_panic>

00801c33 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c45:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c4b:	7f 2e                	jg     801c7b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	53                   	push   %ebx
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	68 0c 60 80 00       	push   $0x80600c
  801c59:	e8 71 ee ff ff       	call   800acf <memmove>
	nsipcbuf.send.req_size = size;
  801c5e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c71:	e8 eb fd ff ff       	call   801a61 <nsipc>
}
  801c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    
	assert(size < 1600);
  801c7b:	68 84 2a 80 00       	push   $0x802a84
  801c80:	68 2b 2a 80 00       	push   $0x802a2b
  801c85:	6a 6d                	push   $0x6d
  801c87:	68 78 2a 80 00       	push   $0x802a78
  801c8c:	e8 ed 04 00 00       	call   80217e <_panic>

00801c91 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  801caa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801caf:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb4:	e8 a8 fd ff ff       	call   801a61 <nsipc>
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 6a f3 ff ff       	call   801038 <fd2data>
  801cce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd0:	83 c4 08             	add    $0x8,%esp
  801cd3:	68 90 2a 80 00       	push   $0x802a90
  801cd8:	53                   	push   %ebx
  801cd9:	e8 63 ec ff ff       	call   800941 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cde:	8b 46 04             	mov    0x4(%esi),%eax
  801ce1:	2b 06                	sub    (%esi),%eax
  801ce3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf0:	00 00 00 
	stat->st_dev = &devpipe;
  801cf3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cfa:	30 80 00 
	return 0;
}
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d13:	53                   	push   %ebx
  801d14:	6a 00                	push   $0x0
  801d16:	e8 9d f0 ff ff       	call   800db8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d1b:	89 1c 24             	mov    %ebx,(%esp)
  801d1e:	e8 15 f3 ff ff       	call   801038 <fd2data>
  801d23:	83 c4 08             	add    $0x8,%esp
  801d26:	50                   	push   %eax
  801d27:	6a 00                	push   $0x0
  801d29:	e8 8a f0 ff ff       	call   800db8 <sys_page_unmap>
}
  801d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <_pipeisclosed>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 1c             	sub    $0x1c,%esp
  801d3c:	89 c7                	mov    %eax,%edi
  801d3e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d40:	a1 08 40 80 00       	mov    0x804008,%eax
  801d45:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	57                   	push   %edi
  801d4c:	e8 8e 05 00 00       	call   8022df <pageref>
  801d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d54:	89 34 24             	mov    %esi,(%esp)
  801d57:	e8 83 05 00 00       	call   8022df <pageref>
		nn = thisenv->env_runs;
  801d5c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d62:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	39 cb                	cmp    %ecx,%ebx
  801d6a:	74 1b                	je     801d87 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d6f:	75 cf                	jne    801d40 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d71:	8b 42 58             	mov    0x58(%edx),%eax
  801d74:	6a 01                	push   $0x1
  801d76:	50                   	push   %eax
  801d77:	53                   	push   %ebx
  801d78:	68 97 2a 80 00       	push   $0x802a97
  801d7d:	e8 60 e4 ff ff       	call   8001e2 <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	eb b9                	jmp    801d40 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d87:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8a:	0f 94 c0             	sete   %al
  801d8d:	0f b6 c0             	movzbl %al,%eax
}
  801d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <devpipe_write>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	57                   	push   %edi
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 28             	sub    $0x28,%esp
  801da1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da4:	56                   	push   %esi
  801da5:	e8 8e f2 ff ff       	call   801038 <fd2data>
  801daa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	bf 00 00 00 00       	mov    $0x0,%edi
  801db4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801db7:	74 4f                	je     801e08 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dbc:	8b 0b                	mov    (%ebx),%ecx
  801dbe:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc1:	39 d0                	cmp    %edx,%eax
  801dc3:	72 14                	jb     801dd9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	89 f0                	mov    %esi,%eax
  801dc9:	e8 65 ff ff ff       	call   801d33 <_pipeisclosed>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	75 3b                	jne    801e0d <devpipe_write+0x75>
			sys_yield();
  801dd2:	e8 3d ef ff ff       	call   800d14 <sys_yield>
  801dd7:	eb e0                	jmp    801db9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ddc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de3:	89 c2                	mov    %eax,%edx
  801de5:	c1 fa 1f             	sar    $0x1f,%edx
  801de8:	89 d1                	mov    %edx,%ecx
  801dea:	c1 e9 1b             	shr    $0x1b,%ecx
  801ded:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df0:	83 e2 1f             	and    $0x1f,%edx
  801df3:	29 ca                	sub    %ecx,%edx
  801df5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dfd:	83 c0 01             	add    $0x1,%eax
  801e00:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e03:	83 c7 01             	add    $0x1,%edi
  801e06:	eb ac                	jmp    801db4 <devpipe_write+0x1c>
	return i;
  801e08:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0b:	eb 05                	jmp    801e12 <devpipe_write+0x7a>
				return 0;
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <devpipe_read>:
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 18             	sub    $0x18,%esp
  801e23:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e26:	57                   	push   %edi
  801e27:	e8 0c f2 ff ff       	call   801038 <fd2data>
  801e2c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	be 00 00 00 00       	mov    $0x0,%esi
  801e36:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e39:	75 14                	jne    801e4f <devpipe_read+0x35>
	return i;
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	eb 02                	jmp    801e42 <devpipe_read+0x28>
				return i;
  801e40:	89 f0                	mov    %esi,%eax
}
  801e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
			sys_yield();
  801e4a:	e8 c5 ee ff ff       	call   800d14 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e4f:	8b 03                	mov    (%ebx),%eax
  801e51:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e54:	75 18                	jne    801e6e <devpipe_read+0x54>
			if (i > 0)
  801e56:	85 f6                	test   %esi,%esi
  801e58:	75 e6                	jne    801e40 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e5a:	89 da                	mov    %ebx,%edx
  801e5c:	89 f8                	mov    %edi,%eax
  801e5e:	e8 d0 fe ff ff       	call   801d33 <_pipeisclosed>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 e3                	je     801e4a <devpipe_read+0x30>
				return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	eb d4                	jmp    801e42 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6e:	99                   	cltd   
  801e6f:	c1 ea 1b             	shr    $0x1b,%edx
  801e72:	01 d0                	add    %edx,%eax
  801e74:	83 e0 1f             	and    $0x1f,%eax
  801e77:	29 d0                	sub    %edx,%eax
  801e79:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e81:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e84:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e87:	83 c6 01             	add    $0x1,%esi
  801e8a:	eb aa                	jmp    801e36 <devpipe_read+0x1c>

00801e8c <pipe>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	56                   	push   %esi
  801e90:	53                   	push   %ebx
  801e91:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e97:	50                   	push   %eax
  801e98:	e8 b2 f1 ff ff       	call   80104f <fd_alloc>
  801e9d:	89 c3                	mov    %eax,%ebx
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	0f 88 23 01 00 00    	js     801fcd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 07 04 00 00       	push   $0x407
  801eb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 77 ee ff ff       	call   800d33 <sys_page_alloc>
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	0f 88 04 01 00 00    	js     801fcd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	e8 7a f1 ff ff       	call   80104f <fd_alloc>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 88 db 00 00 00    	js     801fbd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee2:	83 ec 04             	sub    $0x4,%esp
  801ee5:	68 07 04 00 00       	push   $0x407
  801eea:	ff 75 f0             	pushl  -0x10(%ebp)
  801eed:	6a 00                	push   $0x0
  801eef:	e8 3f ee ff ff       	call   800d33 <sys_page_alloc>
  801ef4:	89 c3                	mov    %eax,%ebx
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	0f 88 bc 00 00 00    	js     801fbd <pipe+0x131>
	va = fd2data(fd0);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 f4             	pushl  -0xc(%ebp)
  801f07:	e8 2c f1 ff ff       	call   801038 <fd2data>
  801f0c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0e:	83 c4 0c             	add    $0xc,%esp
  801f11:	68 07 04 00 00       	push   $0x407
  801f16:	50                   	push   %eax
  801f17:	6a 00                	push   $0x0
  801f19:	e8 15 ee ff ff       	call   800d33 <sys_page_alloc>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	85 c0                	test   %eax,%eax
  801f25:	0f 88 82 00 00 00    	js     801fad <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f31:	e8 02 f1 ff ff       	call   801038 <fd2data>
  801f36:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f3d:	50                   	push   %eax
  801f3e:	6a 00                	push   $0x0
  801f40:	56                   	push   %esi
  801f41:	6a 00                	push   $0x0
  801f43:	e8 2e ee ff ff       	call   800d76 <sys_page_map>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 20             	add    $0x20,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 4e                	js     801f9f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f51:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f59:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f68:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 a9 f0 ff ff       	call   801028 <fd2num>
  801f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f82:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f84:	83 c4 04             	add    $0x4,%esp
  801f87:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8a:	e8 99 f0 ff ff       	call   801028 <fd2num>
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f92:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f9d:	eb 2e                	jmp    801fcd <pipe+0x141>
	sys_page_unmap(0, va);
  801f9f:	83 ec 08             	sub    $0x8,%esp
  801fa2:	56                   	push   %esi
  801fa3:	6a 00                	push   $0x0
  801fa5:	e8 0e ee ff ff       	call   800db8 <sys_page_unmap>
  801faa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 fe ed ff ff       	call   800db8 <sys_page_unmap>
  801fba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc3:	6a 00                	push   $0x0
  801fc5:	e8 ee ed ff ff       	call   800db8 <sys_page_unmap>
  801fca:	83 c4 10             	add    $0x10,%esp
}
  801fcd:	89 d8                	mov    %ebx,%eax
  801fcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd2:	5b                   	pop    %ebx
  801fd3:	5e                   	pop    %esi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    

00801fd6 <pipeisclosed>:
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 b9 f0 ff ff       	call   8010a1 <fd_lookup>
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 18                	js     802007 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff5:	e8 3e f0 ff ff       	call   801038 <fd2data>
	return _pipeisclosed(fd, p);
  801ffa:	89 c2                	mov    %eax,%edx
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	e8 2f fd ff ff       	call   801d33 <_pipeisclosed>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	c3                   	ret    

0080200f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802015:	68 af 2a 80 00       	push   $0x802aaf
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	e8 1f e9 ff ff       	call   800941 <strcpy>
	return 0;
}
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <devcons_write>:
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	57                   	push   %edi
  80202d:	56                   	push   %esi
  80202e:	53                   	push   %ebx
  80202f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802035:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80203a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802040:	3b 75 10             	cmp    0x10(%ebp),%esi
  802043:	73 31                	jae    802076 <devcons_write+0x4d>
		m = n - tot;
  802045:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802048:	29 f3                	sub    %esi,%ebx
  80204a:	83 fb 7f             	cmp    $0x7f,%ebx
  80204d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802052:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	53                   	push   %ebx
  802059:	89 f0                	mov    %esi,%eax
  80205b:	03 45 0c             	add    0xc(%ebp),%eax
  80205e:	50                   	push   %eax
  80205f:	57                   	push   %edi
  802060:	e8 6a ea ff ff       	call   800acf <memmove>
		sys_cputs(buf, m);
  802065:	83 c4 08             	add    $0x8,%esp
  802068:	53                   	push   %ebx
  802069:	57                   	push   %edi
  80206a:	e8 08 ec ff ff       	call   800c77 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206f:	01 de                	add    %ebx,%esi
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	eb ca                	jmp    802040 <devcons_write+0x17>
}
  802076:	89 f0                	mov    %esi,%eax
  802078:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    

00802080 <devcons_read>:
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80208b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208f:	74 21                	je     8020b2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802091:	e8 ff eb ff ff       	call   800c95 <sys_cgetc>
  802096:	85 c0                	test   %eax,%eax
  802098:	75 07                	jne    8020a1 <devcons_read+0x21>
		sys_yield();
  80209a:	e8 75 ec ff ff       	call   800d14 <sys_yield>
  80209f:	eb f0                	jmp    802091 <devcons_read+0x11>
	if (c < 0)
  8020a1:	78 0f                	js     8020b2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020a3:	83 f8 04             	cmp    $0x4,%eax
  8020a6:	74 0c                	je     8020b4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ab:	88 02                	mov    %al,(%edx)
	return 1;
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
		return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	eb f7                	jmp    8020b2 <devcons_read+0x32>

008020bb <cputchar>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020c7:	6a 01                	push   $0x1
  8020c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	e8 a5 eb ff ff       	call   800c77 <sys_cputs>
}
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <getchar>:
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020dd:	6a 01                	push   $0x1
  8020df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 27 f2 ff ff       	call   801311 <read>
	if (r < 0)
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 06                	js     8020f7 <getchar+0x20>
	if (r < 1)
  8020f1:	74 06                	je     8020f9 <getchar+0x22>
	return c;
  8020f3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    
		return -E_EOF;
  8020f9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020fe:	eb f7                	jmp    8020f7 <getchar+0x20>

00802100 <iscons>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802109:	50                   	push   %eax
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	e8 8f ef ff ff       	call   8010a1 <fd_lookup>
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	78 11                	js     80212a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802122:	39 10                	cmp    %edx,(%eax)
  802124:	0f 94 c0             	sete   %al
  802127:	0f b6 c0             	movzbl %al,%eax
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <opencons>:
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802132:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802135:	50                   	push   %eax
  802136:	e8 14 ef ff ff       	call   80104f <fd_alloc>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 3a                	js     80217c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 07 04 00 00       	push   $0x407
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	6a 00                	push   $0x0
  80214f:	e8 df eb ff ff       	call   800d33 <sys_page_alloc>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 21                	js     80217c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802164:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	50                   	push   %eax
  802174:	e8 af ee ff ff       	call   801028 <fd2num>
  802179:	83 c4 10             	add    $0x10,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	56                   	push   %esi
  802182:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802183:	a1 08 40 80 00       	mov    0x804008,%eax
  802188:	8b 40 48             	mov    0x48(%eax),%eax
  80218b:	83 ec 04             	sub    $0x4,%esp
  80218e:	68 e0 2a 80 00       	push   $0x802ae0
  802193:	50                   	push   %eax
  802194:	68 d8 25 80 00       	push   $0x8025d8
  802199:	e8 44 e0 ff ff       	call   8001e2 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80219e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021a7:	e8 49 eb ff ff       	call   800cf5 <sys_getenvid>
  8021ac:	83 c4 04             	add    $0x4,%esp
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	56                   	push   %esi
  8021b6:	50                   	push   %eax
  8021b7:	68 bc 2a 80 00       	push   $0x802abc
  8021bc:	e8 21 e0 ff ff       	call   8001e2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021c1:	83 c4 18             	add    $0x18,%esp
  8021c4:	53                   	push   %ebx
  8021c5:	ff 75 10             	pushl  0x10(%ebp)
  8021c8:	e8 c4 df ff ff       	call   800191 <vcprintf>
	cprintf("\n");
  8021cd:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021d4:	e8 09 e0 ff ff       	call   8001e2 <cprintf>
  8021d9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021dc:	cc                   	int3   
  8021dd:	eb fd                	jmp    8021dc <_panic+0x5e>

008021df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021ed:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021ef:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021f7:	83 ec 0c             	sub    $0xc,%esp
  8021fa:	50                   	push   %eax
  8021fb:	e8 e3 ec ff ff       	call   800ee3 <sys_ipc_recv>
	if(ret < 0){
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	78 2b                	js     802232 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802207:	85 f6                	test   %esi,%esi
  802209:	74 0a                	je     802215 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80220b:	a1 08 40 80 00       	mov    0x804008,%eax
  802210:	8b 40 78             	mov    0x78(%eax),%eax
  802213:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802215:	85 db                	test   %ebx,%ebx
  802217:	74 0a                	je     802223 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802219:	a1 08 40 80 00       	mov    0x804008,%eax
  80221e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802221:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802223:	a1 08 40 80 00       	mov    0x804008,%eax
  802228:	8b 40 74             	mov    0x74(%eax),%eax
}
  80222b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    
		if(from_env_store)
  802232:	85 f6                	test   %esi,%esi
  802234:	74 06                	je     80223c <ipc_recv+0x5d>
			*from_env_store = 0;
  802236:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80223c:	85 db                	test   %ebx,%ebx
  80223e:	74 eb                	je     80222b <ipc_recv+0x4c>
			*perm_store = 0;
  802240:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802246:	eb e3                	jmp    80222b <ipc_recv+0x4c>

00802248 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	57                   	push   %edi
  80224c:	56                   	push   %esi
  80224d:	53                   	push   %ebx
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	8b 7d 08             	mov    0x8(%ebp),%edi
  802254:	8b 75 0c             	mov    0xc(%ebp),%esi
  802257:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802261:	0f 44 d8             	cmove  %eax,%ebx
  802264:	eb 05                	jmp    80226b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802266:	e8 a9 ea ff ff       	call   800d14 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80226b:	ff 75 14             	pushl  0x14(%ebp)
  80226e:	53                   	push   %ebx
  80226f:	56                   	push   %esi
  802270:	57                   	push   %edi
  802271:	e8 4a ec ff ff       	call   800ec0 <sys_ipc_try_send>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 1b                	je     802298 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80227d:	79 e7                	jns    802266 <ipc_send+0x1e>
  80227f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802282:	74 e2                	je     802266 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 e7 2a 80 00       	push   $0x802ae7
  80228c:	6a 46                	push   $0x46
  80228e:	68 fc 2a 80 00       	push   $0x802afc
  802293:	e8 e6 fe ff ff       	call   80217e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5f                   	pop    %edi
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    

008022a0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022ab:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022b1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022b7:	8b 52 50             	mov    0x50(%edx),%edx
  8022ba:	39 ca                	cmp    %ecx,%edx
  8022bc:	74 11                	je     8022cf <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022be:	83 c0 01             	add    $0x1,%eax
  8022c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022c6:	75 e3                	jne    8022ab <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cd:	eb 0e                	jmp    8022dd <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022cf:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022da:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    

008022df <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022e5:	89 d0                	mov    %edx,%eax
  8022e7:	c1 e8 16             	shr    $0x16,%eax
  8022ea:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022f1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f6:	f6 c1 01             	test   $0x1,%cl
  8022f9:	74 1d                	je     802318 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022fb:	c1 ea 0c             	shr    $0xc,%edx
  8022fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802305:	f6 c2 01             	test   $0x1,%dl
  802308:	74 0e                	je     802318 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80230a:	c1 ea 0c             	shr    $0xc,%edx
  80230d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802314:	ef 
  802315:	0f b7 c0             	movzwl %ax,%eax
}
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__udivdi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80232b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80232f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802333:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802337:	85 d2                	test   %edx,%edx
  802339:	75 4d                	jne    802388 <__udivdi3+0x68>
  80233b:	39 f3                	cmp    %esi,%ebx
  80233d:	76 19                	jbe    802358 <__udivdi3+0x38>
  80233f:	31 ff                	xor    %edi,%edi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f2                	mov    %esi,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 d9                	mov    %ebx,%ecx
  80235a:	85 db                	test   %ebx,%ebx
  80235c:	75 0b                	jne    802369 <__udivdi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 c1                	mov    %eax,%ecx
  802369:	31 d2                	xor    %edx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	f7 f1                	div    %ecx
  80236f:	89 c6                	mov    %eax,%esi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f7                	mov    %esi,%edi
  802375:	f7 f1                	div    %ecx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	39 f2                	cmp    %esi,%edx
  80238a:	77 1c                	ja     8023a8 <__udivdi3+0x88>
  80238c:	0f bd fa             	bsr    %edx,%edi
  80238f:	83 f7 1f             	xor    $0x1f,%edi
  802392:	75 2c                	jne    8023c0 <__udivdi3+0xa0>
  802394:	39 f2                	cmp    %esi,%edx
  802396:	72 06                	jb     80239e <__udivdi3+0x7e>
  802398:	31 c0                	xor    %eax,%eax
  80239a:	39 eb                	cmp    %ebp,%ebx
  80239c:	77 a9                	ja     802347 <__udivdi3+0x27>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb a2                	jmp    802347 <__udivdi3+0x27>
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	89 fa                	mov    %edi,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	89 eb                	mov    %ebp,%ebx
  8023f1:	d3 e6                	shl    %cl,%esi
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 15                	jb     802420 <__udivdi3+0x100>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 04                	jae    802417 <__udivdi3+0xf7>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	74 09                	je     802420 <__udivdi3+0x100>
  802417:	89 d8                	mov    %ebx,%eax
  802419:	31 ff                	xor    %edi,%edi
  80241b:	e9 27 ff ff ff       	jmp    802347 <__udivdi3+0x27>
  802420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 1d ff ff ff       	jmp    802347 <__udivdi3+0x27>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802447:	89 da                	mov    %ebx,%edx
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 43                	jne    802490 <__umoddi3+0x60>
  80244d:	39 df                	cmp    %ebx,%edi
  80244f:	76 17                	jbe    802468 <__umoddi3+0x38>
  802451:	89 f0                	mov    %esi,%eax
  802453:	f7 f7                	div    %edi
  802455:	89 d0                	mov    %edx,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 fd                	mov    %edi,%ebp
  80246a:	85 ff                	test   %edi,%edi
  80246c:	75 0b                	jne    802479 <__umoddi3+0x49>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f7                	div    %edi
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d8                	mov    %ebx,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f5                	div    %ebp
  80247f:	89 f0                	mov    %esi,%eax
  802481:	f7 f5                	div    %ebp
  802483:	89 d0                	mov    %edx,%eax
  802485:	eb d0                	jmp    802457 <__umoddi3+0x27>
  802487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248e:	66 90                	xchg   %ax,%ax
  802490:	89 f1                	mov    %esi,%ecx
  802492:	39 d8                	cmp    %ebx,%eax
  802494:	76 0a                	jbe    8024a0 <__umoddi3+0x70>
  802496:	89 f0                	mov    %esi,%eax
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	0f bd e8             	bsr    %eax,%ebp
  8024a3:	83 f5 1f             	xor    $0x1f,%ebp
  8024a6:	75 20                	jne    8024c8 <__umoddi3+0x98>
  8024a8:	39 d8                	cmp    %ebx,%eax
  8024aa:	0f 82 b0 00 00 00    	jb     802560 <__umoddi3+0x130>
  8024b0:	39 f7                	cmp    %esi,%edi
  8024b2:	0f 86 a8 00 00 00    	jbe    802560 <__umoddi3+0x130>
  8024b8:	89 c8                	mov    %ecx,%eax
  8024ba:	83 c4 1c             	add    $0x1c,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5f                   	pop    %edi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0xfb>
  802525:	75 10                	jne    802537 <__umoddi3+0x107>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x107>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 da                	mov    %ebx,%edx
  802562:	29 fe                	sub    %edi,%esi
  802564:	19 c2                	sbb    %eax,%edx
  802566:	89 f1                	mov    %esi,%ecx
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	e9 4b ff ff ff       	jmp    8024ba <__umoddi3+0x8a>
