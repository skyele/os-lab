
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
  800051:	e8 9d 0c 00 00       	call   800cf3 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ba:	8b 40 48             	mov    0x48(%eax),%eax
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	50                   	push   %eax
  8000c1:	68 60 25 80 00       	push   $0x802560
  8000c6:	e8 15 01 00 00       	call   8001e0 <cprintf>
	cprintf("before umain\n");
  8000cb:	c7 04 24 7e 25 80 00 	movl   $0x80257e,(%esp)
  8000d2:	e8 09 01 00 00       	call   8001e0 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d7:	83 c4 08             	add    $0x8,%esp
  8000da:	ff 75 0c             	pushl  0xc(%ebp)
  8000dd:	ff 75 08             	pushl  0x8(%ebp)
  8000e0:	e8 4e ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000e5:	c7 04 24 8c 25 80 00 	movl   $0x80258c,(%esp)
  8000ec:	e8 ef 00 00 00       	call   8001e0 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000f1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f6:	8b 40 48             	mov    0x48(%eax),%eax
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	50                   	push   %eax
  8000fd:	68 99 25 80 00       	push   $0x802599
  800102:	e8 d9 00 00 00       	call   8001e0 <cprintf>
	// exit gracefully
	exit();
  800107:	e8 0b 00 00 00       	call   800117 <exit>
}
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5f                   	pop    %edi
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    

00800117 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80011d:	a1 08 40 80 00       	mov    0x804008,%eax
  800122:	8b 40 48             	mov    0x48(%eax),%eax
  800125:	68 c4 25 80 00       	push   $0x8025c4
  80012a:	50                   	push   %eax
  80012b:	68 b8 25 80 00       	push   $0x8025b8
  800130:	e8 ab 00 00 00       	call   8001e0 <cprintf>
	close_all();
  800135:	e8 a4 10 00 00       	call   8011de <close_all>
	sys_env_destroy(0);
  80013a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800141:	e8 6c 0b 00 00       	call   800cb2 <sys_env_destroy>
}
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	53                   	push   %ebx
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800155:	8b 13                	mov    (%ebx),%edx
  800157:	8d 42 01             	lea    0x1(%edx),%eax
  80015a:	89 03                	mov    %eax,(%ebx)
  80015c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800163:	3d ff 00 00 00       	cmp    $0xff,%eax
  800168:	74 09                	je     800173 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80016a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800171:	c9                   	leave  
  800172:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	68 ff 00 00 00       	push   $0xff
  80017b:	8d 43 08             	lea    0x8(%ebx),%eax
  80017e:	50                   	push   %eax
  80017f:	e8 f1 0a 00 00       	call   800c75 <sys_cputs>
		b->idx = 0;
  800184:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb db                	jmp    80016a <putch+0x1f>

0080018f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800198:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019f:	00 00 00 
	b.cnt = 0;
  8001a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ac:	ff 75 0c             	pushl  0xc(%ebp)
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b8:	50                   	push   %eax
  8001b9:	68 4b 01 80 00       	push   $0x80014b
  8001be:	e8 4a 01 00 00       	call   80030d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c3:	83 c4 08             	add    $0x8,%esp
  8001c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d2:	50                   	push   %eax
  8001d3:	e8 9d 0a 00 00       	call   800c75 <sys_cputs>

	return b.cnt;
}
  8001d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e9:	50                   	push   %eax
  8001ea:	ff 75 08             	pushl  0x8(%ebp)
  8001ed:	e8 9d ff ff ff       	call   80018f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	57                   	push   %edi
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
  8001fa:	83 ec 1c             	sub    $0x1c,%esp
  8001fd:	89 c6                	mov    %eax,%esi
  8001ff:	89 d7                	mov    %edx,%edi
  800201:	8b 45 08             	mov    0x8(%ebp),%eax
  800204:	8b 55 0c             	mov    0xc(%ebp),%edx
  800207:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80020d:	8b 45 10             	mov    0x10(%ebp),%eax
  800210:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800213:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800217:	74 2c                	je     800245 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800219:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800223:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800226:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800229:	39 c2                	cmp    %eax,%edx
  80022b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80022e:	73 43                	jae    800273 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800230:	83 eb 01             	sub    $0x1,%ebx
  800233:	85 db                	test   %ebx,%ebx
  800235:	7e 6c                	jle    8002a3 <printnum+0xaf>
				putch(padc, putdat);
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	57                   	push   %edi
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	ff d6                	call   *%esi
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	eb eb                	jmp    800230 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	6a 20                	push   $0x20
  80024a:	6a 00                	push   $0x0
  80024c:	50                   	push   %eax
  80024d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800250:	ff 75 e0             	pushl  -0x20(%ebp)
  800253:	89 fa                	mov    %edi,%edx
  800255:	89 f0                	mov    %esi,%eax
  800257:	e8 98 ff ff ff       	call   8001f4 <printnum>
		while (--width > 0)
  80025c:	83 c4 20             	add    $0x20,%esp
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	85 db                	test   %ebx,%ebx
  800264:	7e 65                	jle    8002cb <printnum+0xd7>
			putch(padc, putdat);
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	57                   	push   %edi
  80026a:	6a 20                	push   $0x20
  80026c:	ff d6                	call   *%esi
  80026e:	83 c4 10             	add    $0x10,%esp
  800271:	eb ec                	jmp    80025f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	83 eb 01             	sub    $0x1,%ebx
  80027c:	53                   	push   %ebx
  80027d:	50                   	push   %eax
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	ff 75 d8             	pushl  -0x28(%ebp)
  800287:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028a:	ff 75 e0             	pushl  -0x20(%ebp)
  80028d:	e8 6e 20 00 00       	call   802300 <__udivdi3>
  800292:	83 c4 18             	add    $0x18,%esp
  800295:	52                   	push   %edx
  800296:	50                   	push   %eax
  800297:	89 fa                	mov    %edi,%edx
  800299:	89 f0                	mov    %esi,%eax
  80029b:	e8 54 ff ff ff       	call   8001f4 <printnum>
  8002a0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	57                   	push   %edi
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	e8 55 21 00 00       	call   802410 <__umoddi3>
  8002bb:	83 c4 14             	add    $0x14,%esp
  8002be:	0f be 80 c9 25 80 00 	movsbl 0x8025c9(%eax),%eax
  8002c5:	50                   	push   %eax
  8002c6:	ff d6                	call   *%esi
  8002c8:	83 c4 10             	add    $0x10,%esp
	}
}
  8002cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002dd:	8b 10                	mov    (%eax),%edx
  8002df:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e2:	73 0a                	jae    8002ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e7:	89 08                	mov    %ecx,(%eax)
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	88 02                	mov    %al,(%edx)
}
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <printfmt>:
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f9:	50                   	push   %eax
  8002fa:	ff 75 10             	pushl  0x10(%ebp)
  8002fd:	ff 75 0c             	pushl  0xc(%ebp)
  800300:	ff 75 08             	pushl  0x8(%ebp)
  800303:	e8 05 00 00 00       	call   80030d <vprintfmt>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <vprintfmt>:
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 3c             	sub    $0x3c,%esp
  800316:	8b 75 08             	mov    0x8(%ebp),%esi
  800319:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031f:	e9 32 04 00 00       	jmp    800756 <vprintfmt+0x449>
		padc = ' ';
  800324:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800328:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80032f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800336:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800344:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80034b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8d 47 01             	lea    0x1(%edi),%eax
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800356:	0f b6 17             	movzbl (%edi),%edx
  800359:	8d 42 dd             	lea    -0x23(%edx),%eax
  80035c:	3c 55                	cmp    $0x55,%al
  80035e:	0f 87 12 05 00 00    	ja     800876 <vprintfmt+0x569>
  800364:	0f b6 c0             	movzbl %al,%eax
  800367:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800371:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800375:	eb d9                	jmp    800350 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800377:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80037e:	eb d0                	jmp    800350 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800380:	0f b6 d2             	movzbl %dl,%edx
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800386:	b8 00 00 00 00       	mov    $0x0,%eax
  80038b:	89 75 08             	mov    %esi,0x8(%ebp)
  80038e:	eb 03                	jmp    800393 <vprintfmt+0x86>
  800390:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039d:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003a0:	83 fe 09             	cmp    $0x9,%esi
  8003a3:	76 eb                	jbe    800390 <vprintfmt+0x83>
  8003a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ab:	eb 14                	jmp    8003c1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b8:	8d 40 04             	lea    0x4(%eax),%eax
  8003bb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c5:	79 89                	jns    800350 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d4:	e9 77 ff ff ff       	jmp    800350 <vprintfmt+0x43>
  8003d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	0f 48 c1             	cmovs  %ecx,%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e7:	e9 64 ff ff ff       	jmp    800350 <vprintfmt+0x43>
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ef:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f6:	e9 55 ff ff ff       	jmp    800350 <vprintfmt+0x43>
			lflag++;
  8003fb:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800402:	e9 49 ff ff ff       	jmp    800350 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8d 78 04             	lea    0x4(%eax),%edi
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	53                   	push   %ebx
  800411:	ff 30                	pushl  (%eax)
  800413:	ff d6                	call   *%esi
			break;
  800415:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800418:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80041b:	e9 33 03 00 00       	jmp    800753 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8d 78 04             	lea    0x4(%eax),%edi
  800426:	8b 00                	mov    (%eax),%eax
  800428:	99                   	cltd   
  800429:	31 d0                	xor    %edx,%eax
  80042b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042d:	83 f8 11             	cmp    $0x11,%eax
  800430:	7f 23                	jg     800455 <vprintfmt+0x148>
  800432:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800439:	85 d2                	test   %edx,%edx
  80043b:	74 18                	je     800455 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80043d:	52                   	push   %edx
  80043e:	68 1d 2a 80 00       	push   $0x802a1d
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 a6 fe ff ff       	call   8002f0 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800450:	e9 fe 02 00 00       	jmp    800753 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800455:	50                   	push   %eax
  800456:	68 e1 25 80 00       	push   $0x8025e1
  80045b:	53                   	push   %ebx
  80045c:	56                   	push   %esi
  80045d:	e8 8e fe ff ff       	call   8002f0 <printfmt>
  800462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800468:	e9 e6 02 00 00       	jmp    800753 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	83 c0 04             	add    $0x4,%eax
  800473:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80047b:	85 c9                	test   %ecx,%ecx
  80047d:	b8 da 25 80 00       	mov    $0x8025da,%eax
  800482:	0f 45 c1             	cmovne %ecx,%eax
  800485:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048c:	7e 06                	jle    800494 <vprintfmt+0x187>
  80048e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800492:	75 0d                	jne    8004a1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800494:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800497:	89 c7                	mov    %eax,%edi
  800499:	03 45 e0             	add    -0x20(%ebp),%eax
  80049c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049f:	eb 53                	jmp    8004f4 <vprintfmt+0x1e7>
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	e8 71 04 00 00       	call   80091e <strnlen>
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 c1                	sub    %eax,%ecx
  8004b2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ba:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	eb 0f                	jmp    8004d2 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	53                   	push   %ebx
  8004c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ca:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	83 ef 01             	sub    $0x1,%edi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7f ed                	jg     8004c3 <vprintfmt+0x1b6>
  8004d6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d9:	85 c9                	test   %ecx,%ecx
  8004db:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e0:	0f 49 c1             	cmovns %ecx,%eax
  8004e3:	29 c1                	sub    %eax,%ecx
  8004e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e8:	eb aa                	jmp    800494 <vprintfmt+0x187>
					putch(ch, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	52                   	push   %edx
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f9:	83 c7 01             	add    $0x1,%edi
  8004fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800500:	0f be d0             	movsbl %al,%edx
  800503:	85 d2                	test   %edx,%edx
  800505:	74 4b                	je     800552 <vprintfmt+0x245>
  800507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050b:	78 06                	js     800513 <vprintfmt+0x206>
  80050d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800511:	78 1e                	js     800531 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800517:	74 d1                	je     8004ea <vprintfmt+0x1dd>
  800519:	0f be c0             	movsbl %al,%eax
  80051c:	83 e8 20             	sub    $0x20,%eax
  80051f:	83 f8 5e             	cmp    $0x5e,%eax
  800522:	76 c6                	jbe    8004ea <vprintfmt+0x1dd>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	53                   	push   %ebx
  800528:	6a 3f                	push   $0x3f
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb c3                	jmp    8004f4 <vprintfmt+0x1e7>
  800531:	89 cf                	mov    %ecx,%edi
  800533:	eb 0e                	jmp    800543 <vprintfmt+0x236>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 ef 01             	sub    $0x1,%edi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 ff                	test   %edi,%edi
  800545:	7f ee                	jg     800535 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 01 02 00 00       	jmp    800753 <vprintfmt+0x446>
  800552:	89 cf                	mov    %ecx,%edi
  800554:	eb ed                	jmp    800543 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800559:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800560:	e9 eb fd ff ff       	jmp    800350 <vprintfmt+0x43>
	if (lflag >= 2)
  800565:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800569:	7f 21                	jg     80058c <vprintfmt+0x27f>
	else if (lflag)
  80056b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80056f:	74 68                	je     8005d9 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800579:	89 c1                	mov    %eax,%ecx
  80057b:	c1 f9 1f             	sar    $0x1f,%ecx
  80057e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	eb 17                	jmp    8005a3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800597:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 40 08             	lea    0x8(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b3:	78 3f                	js     8005f4 <vprintfmt+0x2e7>
			base = 10;
  8005b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005ba:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005be:	0f 84 71 01 00 00    	je     800735 <vprintfmt+0x428>
				putch('+', putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	6a 2b                	push   $0x2b
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d4:	e9 5c 01 00 00       	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e1:	89 c1                	mov    %eax,%ecx
  8005e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f2:	eb af                	jmp    8005a3 <vprintfmt+0x296>
				putch('-', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 2d                	push   $0x2d
  8005fa:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800602:	f7 d8                	neg    %eax
  800604:	83 d2 00             	adc    $0x0,%edx
  800607:	f7 da                	neg    %edx
  800609:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800612:	b8 0a 00 00 00       	mov    $0xa,%eax
  800617:	e9 19 01 00 00       	jmp    800735 <vprintfmt+0x428>
	if (lflag >= 2)
  80061c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800620:	7f 29                	jg     80064b <vprintfmt+0x33e>
	else if (lflag)
  800622:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800626:	74 44                	je     80066c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
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
  800646:	e9 ea 00 00 00       	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800656:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 08             	lea    0x8(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800662:	b8 0a 00 00 00       	mov    $0xa,%eax
  800667:	e9 c9 00 00 00       	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	ba 00 00 00 00       	mov    $0x0,%edx
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 04             	lea    0x4(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800685:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068a:	e9 a6 00 00 00       	jmp    800735 <vprintfmt+0x428>
			putch('0', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	53                   	push   %ebx
  800693:	6a 30                	push   $0x30
  800695:	ff d6                	call   *%esi
	if (lflag >= 2)
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069e:	7f 26                	jg     8006c6 <vprintfmt+0x3b9>
	else if (lflag)
  8006a0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a4:	74 3e                	je     8006e4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c4:	eb 6f                	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 50 04             	mov    0x4(%eax),%edx
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 40 08             	lea    0x8(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e2:	eb 51                	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006fd:	b8 08 00 00 00       	mov    $0x8,%eax
  800702:	eb 31                	jmp    800735 <vprintfmt+0x428>
			putch('0', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 30                	push   $0x30
  80070a:	ff d6                	call   *%esi
			putch('x', putdat);
  80070c:	83 c4 08             	add    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 78                	push   $0x78
  800712:	ff d6                	call   *%esi
			num = (unsigned long long)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800724:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800730:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80073c:	52                   	push   %edx
  80073d:	ff 75 e0             	pushl  -0x20(%ebp)
  800740:	50                   	push   %eax
  800741:	ff 75 dc             	pushl  -0x24(%ebp)
  800744:	ff 75 d8             	pushl  -0x28(%ebp)
  800747:	89 da                	mov    %ebx,%edx
  800749:	89 f0                	mov    %esi,%eax
  80074b:	e8 a4 fa ff ff       	call   8001f4 <printnum>
			break;
  800750:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800753:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800756:	83 c7 01             	add    $0x1,%edi
  800759:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075d:	83 f8 25             	cmp    $0x25,%eax
  800760:	0f 84 be fb ff ff    	je     800324 <vprintfmt+0x17>
			if (ch == '\0')
  800766:	85 c0                	test   %eax,%eax
  800768:	0f 84 28 01 00 00    	je     800896 <vprintfmt+0x589>
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	53                   	push   %ebx
  800772:	50                   	push   %eax
  800773:	ff d6                	call   *%esi
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	eb dc                	jmp    800756 <vprintfmt+0x449>
	if (lflag >= 2)
  80077a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80077e:	7f 26                	jg     8007a6 <vprintfmt+0x499>
	else if (lflag)
  800780:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800784:	74 41                	je     8007c7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a4:	eb 8f                	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8b 50 04             	mov    0x4(%eax),%edx
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c2:	e9 6e ff ff ff       	jmp    800735 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e5:	e9 4b ff ff ff       	jmp    800735 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	83 c0 04             	add    $0x4,%eax
  8007f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	74 14                	je     800810 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007fc:	8b 13                	mov    (%ebx),%edx
  8007fe:	83 fa 7f             	cmp    $0x7f,%edx
  800801:	7f 37                	jg     80083a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800803:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	e9 43 ff ff ff       	jmp    800753 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800810:	b8 0a 00 00 00       	mov    $0xa,%eax
  800815:	bf fd 26 80 00       	mov    $0x8026fd,%edi
							putch(ch, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	50                   	push   %eax
  80081f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800821:	83 c7 01             	add    $0x1,%edi
  800824:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	85 c0                	test   %eax,%eax
  80082d:	75 eb                	jne    80081a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	e9 19 ff ff ff       	jmp    800753 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80083a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80083c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800841:	bf 35 27 80 00       	mov    $0x802735,%edi
							putch(ch, putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	50                   	push   %eax
  80084b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084d:	83 c7 01             	add    $0x1,%edi
  800850:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	85 c0                	test   %eax,%eax
  800859:	75 eb                	jne    800846 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80085b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	e9 ed fe ff ff       	jmp    800753 <vprintfmt+0x446>
			putch(ch, putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	53                   	push   %ebx
  80086a:	6a 25                	push   $0x25
  80086c:	ff d6                	call   *%esi
			break;
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	e9 dd fe ff ff       	jmp    800753 <vprintfmt+0x446>
			putch('%', putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	6a 25                	push   $0x25
  80087c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 f8                	mov    %edi,%eax
  800883:	eb 03                	jmp    800888 <vprintfmt+0x57b>
  800885:	83 e8 01             	sub    $0x1,%eax
  800888:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80088c:	75 f7                	jne    800885 <vprintfmt+0x578>
  80088e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800891:	e9 bd fe ff ff       	jmp    800753 <vprintfmt+0x446>
}
  800896:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5f                   	pop    %edi
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 18             	sub    $0x18,%esp
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bb:	85 c0                	test   %eax,%eax
  8008bd:	74 26                	je     8008e5 <vsnprintf+0x47>
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	7e 22                	jle    8008e5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c3:	ff 75 14             	pushl  0x14(%ebp)
  8008c6:	ff 75 10             	pushl  0x10(%ebp)
  8008c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008cc:	50                   	push   %eax
  8008cd:	68 d3 02 80 00       	push   $0x8002d3
  8008d2:	e8 36 fa ff ff       	call   80030d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e0:	83 c4 10             	add    $0x10,%esp
}
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    
		return -E_INVAL;
  8008e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ea:	eb f7                	jmp    8008e3 <vsnprintf+0x45>

008008ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f5:	50                   	push   %eax
  8008f6:	ff 75 10             	pushl  0x10(%ebp)
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	ff 75 08             	pushl  0x8(%ebp)
  8008ff:	e8 9a ff ff ff       	call   80089e <vsnprintf>
	va_end(ap);

	return rc;
}
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800915:	74 05                	je     80091c <strlen+0x16>
		n++;
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	eb f5                	jmp    800911 <strlen+0xb>
	return n;
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	39 c2                	cmp    %eax,%edx
  80092e:	74 0d                	je     80093d <strnlen+0x1f>
  800930:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800934:	74 05                	je     80093b <strnlen+0x1d>
		n++;
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	eb f1                	jmp    80092c <strnlen+0xe>
  80093b:	89 d0                	mov    %edx,%eax
	return n;
}
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	53                   	push   %ebx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800949:	ba 00 00 00 00       	mov    $0x0,%edx
  80094e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800952:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800955:	83 c2 01             	add    $0x1,%edx
  800958:	84 c9                	test   %cl,%cl
  80095a:	75 f2                	jne    80094e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80095c:	5b                   	pop    %ebx
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	53                   	push   %ebx
  800963:	83 ec 10             	sub    $0x10,%esp
  800966:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800969:	53                   	push   %ebx
  80096a:	e8 97 ff ff ff       	call   800906 <strlen>
  80096f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	01 d8                	add    %ebx,%eax
  800977:	50                   	push   %eax
  800978:	e8 c2 ff ff ff       	call   80093f <strcpy>
	return dst;
}
  80097d:	89 d8                	mov    %ebx,%eax
  80097f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098f:	89 c6                	mov    %eax,%esi
  800991:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800994:	89 c2                	mov    %eax,%edx
  800996:	39 f2                	cmp    %esi,%edx
  800998:	74 11                	je     8009ab <strncpy+0x27>
		*dst++ = *src;
  80099a:	83 c2 01             	add    $0x1,%edx
  80099d:	0f b6 19             	movzbl (%ecx),%ebx
  8009a0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a3:	80 fb 01             	cmp    $0x1,%bl
  8009a6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a9:	eb eb                	jmp    800996 <strncpy+0x12>
	}
	return ret;
}
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ba:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	74 21                	je     8009e4 <strlcpy+0x35>
  8009c3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c9:	39 c2                	cmp    %eax,%edx
  8009cb:	74 14                	je     8009e1 <strlcpy+0x32>
  8009cd:	0f b6 19             	movzbl (%ecx),%ebx
  8009d0:	84 db                	test   %bl,%bl
  8009d2:	74 0b                	je     8009df <strlcpy+0x30>
			*dst++ = *src++;
  8009d4:	83 c1 01             	add    $0x1,%ecx
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009dd:	eb ea                	jmp    8009c9 <strlcpy+0x1a>
  8009df:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e4:	29 f0                	sub    %esi,%eax
}
  8009e6:	5b                   	pop    %ebx
  8009e7:	5e                   	pop    %esi
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 0c                	je     800a06 <strcmp+0x1c>
  8009fa:	3a 02                	cmp    (%edx),%al
  8009fc:	75 08                	jne    800a06 <strcmp+0x1c>
		p++, q++;
  8009fe:	83 c1 01             	add    $0x1,%ecx
  800a01:	83 c2 01             	add    $0x1,%edx
  800a04:	eb ed                	jmp    8009f3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	0f b6 c0             	movzbl %al,%eax
  800a09:	0f b6 12             	movzbl (%edx),%edx
  800a0c:	29 d0                	sub    %edx,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	53                   	push   %ebx
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1a:	89 c3                	mov    %eax,%ebx
  800a1c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1f:	eb 06                	jmp    800a27 <strncmp+0x17>
		n--, p++, q++;
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a27:	39 d8                	cmp    %ebx,%eax
  800a29:	74 16                	je     800a41 <strncmp+0x31>
  800a2b:	0f b6 08             	movzbl (%eax),%ecx
  800a2e:	84 c9                	test   %cl,%cl
  800a30:	74 04                	je     800a36 <strncmp+0x26>
  800a32:	3a 0a                	cmp    (%edx),%cl
  800a34:	74 eb                	je     800a21 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a36:	0f b6 00             	movzbl (%eax),%eax
  800a39:	0f b6 12             	movzbl (%edx),%edx
  800a3c:	29 d0                	sub    %edx,%eax
}
  800a3e:	5b                   	pop    %ebx
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    
		return 0;
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	eb f6                	jmp    800a3e <strncmp+0x2e>

00800a48 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a52:	0f b6 10             	movzbl (%eax),%edx
  800a55:	84 d2                	test   %dl,%dl
  800a57:	74 09                	je     800a62 <strchr+0x1a>
		if (*s == c)
  800a59:	38 ca                	cmp    %cl,%dl
  800a5b:	74 0a                	je     800a67 <strchr+0x1f>
	for (; *s; s++)
  800a5d:	83 c0 01             	add    $0x1,%eax
  800a60:	eb f0                	jmp    800a52 <strchr+0xa>
			return (char *) s;
	return 0;
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a73:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a76:	38 ca                	cmp    %cl,%dl
  800a78:	74 09                	je     800a83 <strfind+0x1a>
  800a7a:	84 d2                	test   %dl,%dl
  800a7c:	74 05                	je     800a83 <strfind+0x1a>
	for (; *s; s++)
  800a7e:	83 c0 01             	add    $0x1,%eax
  800a81:	eb f0                	jmp    800a73 <strfind+0xa>
			break;
	return (char *) s;
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a91:	85 c9                	test   %ecx,%ecx
  800a93:	74 31                	je     800ac6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a95:	89 f8                	mov    %edi,%eax
  800a97:	09 c8                	or     %ecx,%eax
  800a99:	a8 03                	test   $0x3,%al
  800a9b:	75 23                	jne    800ac0 <memset+0x3b>
		c &= 0xFF;
  800a9d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa1:	89 d3                	mov    %edx,%ebx
  800aa3:	c1 e3 08             	shl    $0x8,%ebx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	c1 e0 18             	shl    $0x18,%eax
  800aab:	89 d6                	mov    %edx,%esi
  800aad:	c1 e6 10             	shl    $0x10,%esi
  800ab0:	09 f0                	or     %esi,%eax
  800ab2:	09 c2                	or     %eax,%edx
  800ab4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab9:	89 d0                	mov    %edx,%eax
  800abb:	fc                   	cld    
  800abc:	f3 ab                	rep stos %eax,%es:(%edi)
  800abe:	eb 06                	jmp    800ac6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	fc                   	cld    
  800ac4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac6:	89 f8                	mov    %edi,%eax
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5f                   	pop    %edi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	57                   	push   %edi
  800ad1:	56                   	push   %esi
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800adb:	39 c6                	cmp    %eax,%esi
  800add:	73 32                	jae    800b11 <memmove+0x44>
  800adf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	76 2b                	jbe    800b11 <memmove+0x44>
		s += n;
		d += n;
  800ae6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae9:	89 fe                	mov    %edi,%esi
  800aeb:	09 ce                	or     %ecx,%esi
  800aed:	09 d6                	or     %edx,%esi
  800aef:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af5:	75 0e                	jne    800b05 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af7:	83 ef 04             	sub    $0x4,%edi
  800afa:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b00:	fd                   	std    
  800b01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b03:	eb 09                	jmp    800b0e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b05:	83 ef 01             	sub    $0x1,%edi
  800b08:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b0b:	fd                   	std    
  800b0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0e:	fc                   	cld    
  800b0f:	eb 1a                	jmp    800b2b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	09 ca                	or     %ecx,%edx
  800b15:	09 f2                	or     %esi,%edx
  800b17:	f6 c2 03             	test   $0x3,%dl
  800b1a:	75 0a                	jne    800b26 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1f:	89 c7                	mov    %eax,%edi
  800b21:	fc                   	cld    
  800b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b24:	eb 05                	jmp    800b2b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b26:	89 c7                	mov    %eax,%edi
  800b28:	fc                   	cld    
  800b29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b35:	ff 75 10             	pushl  0x10(%ebp)
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 8a ff ff ff       	call   800acd <memmove>
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b50:	89 c6                	mov    %eax,%esi
  800b52:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b55:	39 f0                	cmp    %esi,%eax
  800b57:	74 1c                	je     800b75 <memcmp+0x30>
		if (*s1 != *s2)
  800b59:	0f b6 08             	movzbl (%eax),%ecx
  800b5c:	0f b6 1a             	movzbl (%edx),%ebx
  800b5f:	38 d9                	cmp    %bl,%cl
  800b61:	75 08                	jne    800b6b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	83 c2 01             	add    $0x1,%edx
  800b69:	eb ea                	jmp    800b55 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b6b:	0f b6 c1             	movzbl %cl,%eax
  800b6e:	0f b6 db             	movzbl %bl,%ebx
  800b71:	29 d8                	sub    %ebx,%eax
  800b73:	eb 05                	jmp    800b7a <memcmp+0x35>
	}

	return 0;
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b87:	89 c2                	mov    %eax,%edx
  800b89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b8c:	39 d0                	cmp    %edx,%eax
  800b8e:	73 09                	jae    800b99 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b90:	38 08                	cmp    %cl,(%eax)
  800b92:	74 05                	je     800b99 <memfind+0x1b>
	for (; s < ends; s++)
  800b94:	83 c0 01             	add    $0x1,%eax
  800b97:	eb f3                	jmp    800b8c <memfind+0xe>
			break;
	return (void *) s;
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba7:	eb 03                	jmp    800bac <strtol+0x11>
		s++;
  800ba9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bac:	0f b6 01             	movzbl (%ecx),%eax
  800baf:	3c 20                	cmp    $0x20,%al
  800bb1:	74 f6                	je     800ba9 <strtol+0xe>
  800bb3:	3c 09                	cmp    $0x9,%al
  800bb5:	74 f2                	je     800ba9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb7:	3c 2b                	cmp    $0x2b,%al
  800bb9:	74 2a                	je     800be5 <strtol+0x4a>
	int neg = 0;
  800bbb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc0:	3c 2d                	cmp    $0x2d,%al
  800bc2:	74 2b                	je     800bef <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bca:	75 0f                	jne    800bdb <strtol+0x40>
  800bcc:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcf:	74 28                	je     800bf9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bd1:	85 db                	test   %ebx,%ebx
  800bd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd8:	0f 44 d8             	cmove  %eax,%ebx
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800be3:	eb 50                	jmp    800c35 <strtol+0x9a>
		s++;
  800be5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bed:	eb d5                	jmp    800bc4 <strtol+0x29>
		s++, neg = 1;
  800bef:	83 c1 01             	add    $0x1,%ecx
  800bf2:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf7:	eb cb                	jmp    800bc4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bfd:	74 0e                	je     800c0d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bff:	85 db                	test   %ebx,%ebx
  800c01:	75 d8                	jne    800bdb <strtol+0x40>
		s++, base = 8;
  800c03:	83 c1 01             	add    $0x1,%ecx
  800c06:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c0b:	eb ce                	jmp    800bdb <strtol+0x40>
		s += 2, base = 16;
  800c0d:	83 c1 02             	add    $0x2,%ecx
  800c10:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c15:	eb c4                	jmp    800bdb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c17:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c1a:	89 f3                	mov    %esi,%ebx
  800c1c:	80 fb 19             	cmp    $0x19,%bl
  800c1f:	77 29                	ja     800c4a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c21:	0f be d2             	movsbl %dl,%edx
  800c24:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c27:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c2a:	7d 30                	jge    800c5c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2c:	83 c1 01             	add    $0x1,%ecx
  800c2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c35:	0f b6 11             	movzbl (%ecx),%edx
  800c38:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c3b:	89 f3                	mov    %esi,%ebx
  800c3d:	80 fb 09             	cmp    $0x9,%bl
  800c40:	77 d5                	ja     800c17 <strtol+0x7c>
			dig = *s - '0';
  800c42:	0f be d2             	movsbl %dl,%edx
  800c45:	83 ea 30             	sub    $0x30,%edx
  800c48:	eb dd                	jmp    800c27 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c4a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c4d:	89 f3                	mov    %esi,%ebx
  800c4f:	80 fb 19             	cmp    $0x19,%bl
  800c52:	77 08                	ja     800c5c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c54:	0f be d2             	movsbl %dl,%edx
  800c57:	83 ea 37             	sub    $0x37,%edx
  800c5a:	eb cb                	jmp    800c27 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c60:	74 05                	je     800c67 <strtol+0xcc>
		*endptr = (char *) s;
  800c62:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c65:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c67:	89 c2                	mov    %eax,%edx
  800c69:	f7 da                	neg    %edx
  800c6b:	85 ff                	test   %edi,%edi
  800c6d:	0f 45 c2             	cmovne %edx,%eax
}
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	89 c3                	mov    %eax,%ebx
  800c88:	89 c7                	mov    %eax,%edi
  800c8a:	89 c6                	mov    %eax,%esi
  800c8c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c99:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca3:	89 d1                	mov    %edx,%ecx
  800ca5:	89 d3                	mov    %edx,%ebx
  800ca7:	89 d7                	mov    %edx,%edi
  800ca9:	89 d6                	mov    %edx,%esi
  800cab:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
  800cb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc8:	89 cb                	mov    %ecx,%ebx
  800cca:	89 cf                	mov    %ecx,%edi
  800ccc:	89 ce                	mov    %ecx,%esi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 03                	push   $0x3
  800ce2:	68 48 29 80 00       	push   $0x802948
  800ce7:	6a 43                	push   $0x43
  800ce9:	68 65 29 80 00       	push   $0x802965
  800cee:	e8 69 14 00 00       	call   80215c <_panic>

00800cf3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfe:	b8 02 00 00 00       	mov    $0x2,%eax
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	89 d3                	mov    %edx,%ebx
  800d07:	89 d7                	mov    %edx,%edi
  800d09:	89 d6                	mov    %edx,%esi
  800d0b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <sys_yield>:

void
sys_yield(void)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d22:	89 d1                	mov    %edx,%ecx
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	89 d7                	mov    %edx,%edi
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
  800d37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3a:	be 00 00 00 00       	mov    $0x0,%esi
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d45:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4d:	89 f7                	mov    %esi,%edi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 04                	push   $0x4
  800d63:	68 48 29 80 00       	push   $0x802948
  800d68:	6a 43                	push   $0x43
  800d6a:	68 65 29 80 00       	push   $0x802965
  800d6f:	e8 e8 13 00 00       	call   80215c <_panic>

00800d74 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	b8 05 00 00 00       	mov    $0x5,%eax
  800d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 05                	push   $0x5
  800da5:	68 48 29 80 00       	push   $0x802948
  800daa:	6a 43                	push   $0x43
  800dac:	68 65 29 80 00       	push   $0x802965
  800db1:	e8 a6 13 00 00       	call   80215c <_panic>

00800db6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 06 00 00 00       	mov    $0x6,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 06                	push   $0x6
  800de7:	68 48 29 80 00       	push   $0x802948
  800dec:	6a 43                	push   $0x43
  800dee:	68 65 29 80 00       	push   $0x802965
  800df3:	e8 64 13 00 00       	call   80215c <_panic>

00800df8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	b8 08 00 00 00       	mov    $0x8,%eax
  800e11:	89 df                	mov    %ebx,%edi
  800e13:	89 de                	mov    %ebx,%esi
  800e15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7f 08                	jg     800e23 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	6a 08                	push   $0x8
  800e29:	68 48 29 80 00       	push   $0x802948
  800e2e:	6a 43                	push   $0x43
  800e30:	68 65 29 80 00       	push   $0x802965
  800e35:	e8 22 13 00 00       	call   80215c <_panic>

00800e3a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e53:	89 df                	mov    %ebx,%edi
  800e55:	89 de                	mov    %ebx,%esi
  800e57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7f 08                	jg     800e65 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	50                   	push   %eax
  800e69:	6a 09                	push   $0x9
  800e6b:	68 48 29 80 00       	push   $0x802948
  800e70:	6a 43                	push   $0x43
  800e72:	68 65 29 80 00       	push   $0x802965
  800e77:	e8 e0 12 00 00       	call   80215c <_panic>

00800e7c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e95:	89 df                	mov    %ebx,%edi
  800e97:	89 de                	mov    %ebx,%esi
  800e99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7f 08                	jg     800ea7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	50                   	push   %eax
  800eab:	6a 0a                	push   $0xa
  800ead:	68 48 29 80 00       	push   $0x802948
  800eb2:	6a 43                	push   $0x43
  800eb4:	68 65 29 80 00       	push   $0x802965
  800eb9:	e8 9e 12 00 00       	call   80215c <_panic>

00800ebe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ecf:	be 00 00 00 00       	mov    $0x0,%esi
  800ed4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eda:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef7:	89 cb                	mov    %ecx,%ebx
  800ef9:	89 cf                	mov    %ecx,%edi
  800efb:	89 ce                	mov    %ecx,%esi
  800efd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7f 08                	jg     800f0b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0b:	83 ec 0c             	sub    $0xc,%esp
  800f0e:	50                   	push   %eax
  800f0f:	6a 0d                	push   $0xd
  800f11:	68 48 29 80 00       	push   $0x802948
  800f16:	6a 43                	push   $0x43
  800f18:	68 65 29 80 00       	push   $0x802965
  800f1d:	e8 3a 12 00 00       	call   80215c <_panic>

00800f22 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f38:	89 df                	mov    %ebx,%edi
  800f3a:	89 de                	mov    %ebx,%esi
  800f3c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f56:	89 cb                	mov    %ecx,%ebx
  800f58:	89 cf                	mov    %ecx,%edi
  800f5a:	89 ce                	mov    %ecx,%esi
  800f5c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f69:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6e:	b8 10 00 00 00       	mov    $0x10,%eax
  800f73:	89 d1                	mov    %edx,%ecx
  800f75:	89 d3                	mov    %edx,%ebx
  800f77:	89 d7                	mov    %edx,%edi
  800f79:	89 d6                	mov    %edx,%esi
  800f7b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	b8 11 00 00 00       	mov    $0x11,%eax
  800f98:	89 df                	mov    %ebx,%edi
  800f9a:	89 de                	mov    %ebx,%esi
  800f9c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb9:	89 df                	mov    %ebx,%edi
  800fbb:	89 de                	mov    %ebx,%esi
  800fbd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
  800fca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	b8 13 00 00 00       	mov    $0x13,%eax
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	7f 08                	jg     800fef <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5f                   	pop    %edi
  800fed:	5d                   	pop    %ebp
  800fee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	50                   	push   %eax
  800ff3:	6a 13                	push   $0x13
  800ff5:	68 48 29 80 00       	push   $0x802948
  800ffa:	6a 43                	push   $0x43
  800ffc:	68 65 29 80 00       	push   $0x802965
  801001:	e8 56 11 00 00       	call   80215c <_panic>

00801006 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	05 00 00 00 30       	add    $0x30000000,%eax
  801011:	c1 e8 0c             	shr    $0xc,%eax
}
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801021:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801026:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801035:	89 c2                	mov    %eax,%edx
  801037:	c1 ea 16             	shr    $0x16,%edx
  80103a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801041:	f6 c2 01             	test   $0x1,%dl
  801044:	74 2d                	je     801073 <fd_alloc+0x46>
  801046:	89 c2                	mov    %eax,%edx
  801048:	c1 ea 0c             	shr    $0xc,%edx
  80104b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801052:	f6 c2 01             	test   $0x1,%dl
  801055:	74 1c                	je     801073 <fd_alloc+0x46>
  801057:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80105c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801061:	75 d2                	jne    801035 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80106c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801071:	eb 0a                	jmp    80107d <fd_alloc+0x50>
			*fd_store = fd;
  801073:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801076:	89 01                	mov    %eax,(%ecx)
			return 0;
  801078:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801085:	83 f8 1f             	cmp    $0x1f,%eax
  801088:	77 30                	ja     8010ba <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80108a:	c1 e0 0c             	shl    $0xc,%eax
  80108d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801092:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801098:	f6 c2 01             	test   $0x1,%dl
  80109b:	74 24                	je     8010c1 <fd_lookup+0x42>
  80109d:	89 c2                	mov    %eax,%edx
  80109f:	c1 ea 0c             	shr    $0xc,%edx
  8010a2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a9:	f6 c2 01             	test   $0x1,%dl
  8010ac:	74 1a                	je     8010c8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b1:	89 02                	mov    %eax,(%edx)
	return 0;
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    
		return -E_INVAL;
  8010ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bf:	eb f7                	jmp    8010b8 <fd_lookup+0x39>
		return -E_INVAL;
  8010c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c6:	eb f0                	jmp    8010b8 <fd_lookup+0x39>
  8010c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cd:	eb e9                	jmp    8010b8 <fd_lookup+0x39>

008010cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 08             	sub    $0x8,%esp
  8010d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010dd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010e2:	39 08                	cmp    %ecx,(%eax)
  8010e4:	74 38                	je     80111e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010e6:	83 c2 01             	add    $0x1,%edx
  8010e9:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	75 ee                	jne    8010e2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8010f9:	8b 40 48             	mov    0x48(%eax),%eax
  8010fc:	83 ec 04             	sub    $0x4,%esp
  8010ff:	51                   	push   %ecx
  801100:	50                   	push   %eax
  801101:	68 74 29 80 00       	push   $0x802974
  801106:	e8 d5 f0 ff ff       	call   8001e0 <cprintf>
	*dev = 0;
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    
			*dev = devtab[i];
  80111e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801121:	89 01                	mov    %eax,(%ecx)
			return 0;
  801123:	b8 00 00 00 00       	mov    $0x0,%eax
  801128:	eb f2                	jmp    80111c <dev_lookup+0x4d>

0080112a <fd_close>:
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 24             	sub    $0x24,%esp
  801133:	8b 75 08             	mov    0x8(%ebp),%esi
  801136:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801139:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80113c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801143:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801146:	50                   	push   %eax
  801147:	e8 33 ff ff ff       	call   80107f <fd_lookup>
  80114c:	89 c3                	mov    %eax,%ebx
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	78 05                	js     80115a <fd_close+0x30>
	    || fd != fd2)
  801155:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801158:	74 16                	je     801170 <fd_close+0x46>
		return (must_exist ? r : 0);
  80115a:	89 f8                	mov    %edi,%eax
  80115c:	84 c0                	test   %al,%al
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	0f 44 d8             	cmove  %eax,%ebx
}
  801166:	89 d8                	mov    %ebx,%eax
  801168:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801176:	50                   	push   %eax
  801177:	ff 36                	pushl  (%esi)
  801179:	e8 51 ff ff ff       	call   8010cf <dev_lookup>
  80117e:	89 c3                	mov    %eax,%ebx
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 1a                	js     8011a1 <fd_close+0x77>
		if (dev->dev_close)
  801187:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80118a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80118d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801192:	85 c0                	test   %eax,%eax
  801194:	74 0b                	je     8011a1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801196:	83 ec 0c             	sub    $0xc,%esp
  801199:	56                   	push   %esi
  80119a:	ff d0                	call   *%eax
  80119c:	89 c3                	mov    %eax,%ebx
  80119e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 0a fc ff ff       	call   800db6 <sys_page_unmap>
	return r;
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	eb b5                	jmp    801166 <fd_close+0x3c>

008011b1 <close>:

int
close(int fdnum)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	ff 75 08             	pushl  0x8(%ebp)
  8011be:	e8 bc fe ff ff       	call   80107f <fd_lookup>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	79 02                	jns    8011cc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011ca:	c9                   	leave  
  8011cb:	c3                   	ret    
		return fd_close(fd, 1);
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	6a 01                	push   $0x1
  8011d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d4:	e8 51 ff ff ff       	call   80112a <fd_close>
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	eb ec                	jmp    8011ca <close+0x19>

008011de <close_all>:

void
close_all(void)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	53                   	push   %ebx
  8011e2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011ea:	83 ec 0c             	sub    $0xc,%esp
  8011ed:	53                   	push   %ebx
  8011ee:	e8 be ff ff ff       	call   8011b1 <close>
	for (i = 0; i < MAXFD; i++)
  8011f3:	83 c3 01             	add    $0x1,%ebx
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	83 fb 20             	cmp    $0x20,%ebx
  8011fc:	75 ec                	jne    8011ea <close_all+0xc>
}
  8011fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	57                   	push   %edi
  801207:	56                   	push   %esi
  801208:	53                   	push   %ebx
  801209:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80120c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80120f:	50                   	push   %eax
  801210:	ff 75 08             	pushl  0x8(%ebp)
  801213:	e8 67 fe ff ff       	call   80107f <fd_lookup>
  801218:	89 c3                	mov    %eax,%ebx
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	0f 88 81 00 00 00    	js     8012a6 <dup+0xa3>
		return r;
	close(newfdnum);
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	ff 75 0c             	pushl  0xc(%ebp)
  80122b:	e8 81 ff ff ff       	call   8011b1 <close>

	newfd = INDEX2FD(newfdnum);
  801230:	8b 75 0c             	mov    0xc(%ebp),%esi
  801233:	c1 e6 0c             	shl    $0xc,%esi
  801236:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80123c:	83 c4 04             	add    $0x4,%esp
  80123f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801242:	e8 cf fd ff ff       	call   801016 <fd2data>
  801247:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801249:	89 34 24             	mov    %esi,(%esp)
  80124c:	e8 c5 fd ff ff       	call   801016 <fd2data>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801256:	89 d8                	mov    %ebx,%eax
  801258:	c1 e8 16             	shr    $0x16,%eax
  80125b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801262:	a8 01                	test   $0x1,%al
  801264:	74 11                	je     801277 <dup+0x74>
  801266:	89 d8                	mov    %ebx,%eax
  801268:	c1 e8 0c             	shr    $0xc,%eax
  80126b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801272:	f6 c2 01             	test   $0x1,%dl
  801275:	75 39                	jne    8012b0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801277:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80127a:	89 d0                	mov    %edx,%eax
  80127c:	c1 e8 0c             	shr    $0xc,%eax
  80127f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	25 07 0e 00 00       	and    $0xe07,%eax
  80128e:	50                   	push   %eax
  80128f:	56                   	push   %esi
  801290:	6a 00                	push   $0x0
  801292:	52                   	push   %edx
  801293:	6a 00                	push   $0x0
  801295:	e8 da fa ff ff       	call   800d74 <sys_page_map>
  80129a:	89 c3                	mov    %eax,%ebx
  80129c:	83 c4 20             	add    $0x20,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 31                	js     8012d4 <dup+0xd1>
		goto err;

	return newfdnum;
  8012a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012a6:	89 d8                	mov    %ebx,%eax
  8012a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ab:	5b                   	pop    %ebx
  8012ac:	5e                   	pop    %esi
  8012ad:	5f                   	pop    %edi
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b7:	83 ec 0c             	sub    $0xc,%esp
  8012ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bf:	50                   	push   %eax
  8012c0:	57                   	push   %edi
  8012c1:	6a 00                	push   $0x0
  8012c3:	53                   	push   %ebx
  8012c4:	6a 00                	push   $0x0
  8012c6:	e8 a9 fa ff ff       	call   800d74 <sys_page_map>
  8012cb:	89 c3                	mov    %eax,%ebx
  8012cd:	83 c4 20             	add    $0x20,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	79 a3                	jns    801277 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	56                   	push   %esi
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 d7 fa ff ff       	call   800db6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012df:	83 c4 08             	add    $0x8,%esp
  8012e2:	57                   	push   %edi
  8012e3:	6a 00                	push   $0x0
  8012e5:	e8 cc fa ff ff       	call   800db6 <sys_page_unmap>
	return r;
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	eb b7                	jmp    8012a6 <dup+0xa3>

008012ef <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	53                   	push   %ebx
  8012f3:	83 ec 1c             	sub    $0x1c,%esp
  8012f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fc:	50                   	push   %eax
  8012fd:	53                   	push   %ebx
  8012fe:	e8 7c fd ff ff       	call   80107f <fd_lookup>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 3f                	js     801349 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801314:	ff 30                	pushl  (%eax)
  801316:	e8 b4 fd ff ff       	call   8010cf <dev_lookup>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 27                	js     801349 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801325:	8b 42 08             	mov    0x8(%edx),%eax
  801328:	83 e0 03             	and    $0x3,%eax
  80132b:	83 f8 01             	cmp    $0x1,%eax
  80132e:	74 1e                	je     80134e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801333:	8b 40 08             	mov    0x8(%eax),%eax
  801336:	85 c0                	test   %eax,%eax
  801338:	74 35                	je     80136f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	ff 75 10             	pushl  0x10(%ebp)
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	52                   	push   %edx
  801344:	ff d0                	call   *%eax
  801346:	83 c4 10             	add    $0x10,%esp
}
  801349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80134e:	a1 08 40 80 00       	mov    0x804008,%eax
  801353:	8b 40 48             	mov    0x48(%eax),%eax
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	53                   	push   %ebx
  80135a:	50                   	push   %eax
  80135b:	68 b5 29 80 00       	push   $0x8029b5
  801360:	e8 7b ee ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136d:	eb da                	jmp    801349 <read+0x5a>
		return -E_NOT_SUPP;
  80136f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801374:	eb d3                	jmp    801349 <read+0x5a>

00801376 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	57                   	push   %edi
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801382:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801385:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138a:	39 f3                	cmp    %esi,%ebx
  80138c:	73 23                	jae    8013b1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80138e:	83 ec 04             	sub    $0x4,%esp
  801391:	89 f0                	mov    %esi,%eax
  801393:	29 d8                	sub    %ebx,%eax
  801395:	50                   	push   %eax
  801396:	89 d8                	mov    %ebx,%eax
  801398:	03 45 0c             	add    0xc(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	57                   	push   %edi
  80139d:	e8 4d ff ff ff       	call   8012ef <read>
		if (m < 0)
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 06                	js     8013af <readn+0x39>
			return m;
		if (m == 0)
  8013a9:	74 06                	je     8013b1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013ab:	01 c3                	add    %eax,%ebx
  8013ad:	eb db                	jmp    80138a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013af:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013b1:	89 d8                	mov    %ebx,%eax
  8013b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5f                   	pop    %edi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 1c             	sub    $0x1c,%esp
  8013c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	53                   	push   %ebx
  8013ca:	e8 b0 fc ff ff       	call   80107f <fd_lookup>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 3a                	js     801410 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dc:	50                   	push   %eax
  8013dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e0:	ff 30                	pushl  (%eax)
  8013e2:	e8 e8 fc ff ff       	call   8010cf <dev_lookup>
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 22                	js     801410 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f5:	74 1e                	je     801415 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8013fd:	85 d2                	test   %edx,%edx
  8013ff:	74 35                	je     801436 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	ff 75 10             	pushl  0x10(%ebp)
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	50                   	push   %eax
  80140b:	ff d2                	call   *%edx
  80140d:	83 c4 10             	add    $0x10,%esp
}
  801410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801413:	c9                   	leave  
  801414:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801415:	a1 08 40 80 00       	mov    0x804008,%eax
  80141a:	8b 40 48             	mov    0x48(%eax),%eax
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	53                   	push   %ebx
  801421:	50                   	push   %eax
  801422:	68 d1 29 80 00       	push   $0x8029d1
  801427:	e8 b4 ed ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801434:	eb da                	jmp    801410 <write+0x55>
		return -E_NOT_SUPP;
  801436:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143b:	eb d3                	jmp    801410 <write+0x55>

0080143d <seek>:

int
seek(int fdnum, off_t offset)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	ff 75 08             	pushl  0x8(%ebp)
  80144a:	e8 30 fc ff ff       	call   80107f <fd_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 0e                	js     801464 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801456:	8b 55 0c             	mov    0xc(%ebp),%edx
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 1c             	sub    $0x1c,%esp
  80146d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	53                   	push   %ebx
  801475:	e8 05 fc ff ff       	call   80107f <fd_lookup>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 37                	js     8014b8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801487:	50                   	push   %eax
  801488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148b:	ff 30                	pushl  (%eax)
  80148d:	e8 3d fc ff ff       	call   8010cf <dev_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 1f                	js     8014b8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a0:	74 1b                	je     8014bd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	8b 52 18             	mov    0x18(%edx),%edx
  8014a8:	85 d2                	test   %edx,%edx
  8014aa:	74 32                	je     8014de <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	ff d2                	call   *%edx
  8014b5:	83 c4 10             	add    $0x10,%esp
}
  8014b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014bd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014c2:	8b 40 48             	mov    0x48(%eax),%eax
  8014c5:	83 ec 04             	sub    $0x4,%esp
  8014c8:	53                   	push   %ebx
  8014c9:	50                   	push   %eax
  8014ca:	68 94 29 80 00       	push   $0x802994
  8014cf:	e8 0c ed ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dc:	eb da                	jmp    8014b8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e3:	eb d3                	jmp    8014b8 <ftruncate+0x52>

008014e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 1c             	sub    $0x1c,%esp
  8014ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	e8 84 fb ff ff       	call   80107f <fd_lookup>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 4b                	js     80154d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801502:	83 ec 08             	sub    $0x8,%esp
  801505:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801508:	50                   	push   %eax
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	ff 30                	pushl  (%eax)
  80150e:	e8 bc fb ff ff       	call   8010cf <dev_lookup>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 33                	js     80154d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801521:	74 2f                	je     801552 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801523:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801526:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80152d:	00 00 00 
	stat->st_isdir = 0;
  801530:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801537:	00 00 00 
	stat->st_dev = dev;
  80153a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	53                   	push   %ebx
  801544:	ff 75 f0             	pushl  -0x10(%ebp)
  801547:	ff 50 14             	call   *0x14(%eax)
  80154a:	83 c4 10             	add    $0x10,%esp
}
  80154d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801550:	c9                   	leave  
  801551:	c3                   	ret    
		return -E_NOT_SUPP;
  801552:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801557:	eb f4                	jmp    80154d <fstat+0x68>

00801559 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	56                   	push   %esi
  80155d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	6a 00                	push   $0x0
  801563:	ff 75 08             	pushl  0x8(%ebp)
  801566:	e8 22 02 00 00       	call   80178d <open>
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 1b                	js     80158f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 65 ff ff ff       	call   8014e5 <fstat>
  801580:	89 c6                	mov    %eax,%esi
	close(fd);
  801582:	89 1c 24             	mov    %ebx,(%esp)
  801585:	e8 27 fc ff ff       	call   8011b1 <close>
	return r;
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 f3                	mov    %esi,%ebx
}
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801594:	5b                   	pop    %ebx
  801595:	5e                   	pop    %esi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    

00801598 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	89 c6                	mov    %eax,%esi
  80159f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015a1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a8:	74 27                	je     8015d1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015aa:	6a 07                	push   $0x7
  8015ac:	68 00 50 80 00       	push   $0x805000
  8015b1:	56                   	push   %esi
  8015b2:	ff 35 00 40 80 00    	pushl  0x804000
  8015b8:	e8 69 0c 00 00       	call   802226 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015bd:	83 c4 0c             	add    $0xc,%esp
  8015c0:	6a 00                	push   $0x0
  8015c2:	53                   	push   %ebx
  8015c3:	6a 00                	push   $0x0
  8015c5:	e8 f3 0b 00 00       	call   8021bd <ipc_recv>
}
  8015ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015d1:	83 ec 0c             	sub    $0xc,%esp
  8015d4:	6a 01                	push   $0x1
  8015d6:	e8 a3 0c 00 00       	call   80227e <ipc_find_env>
  8015db:	a3 00 40 80 00       	mov    %eax,0x804000
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	eb c5                	jmp    8015aa <fsipc+0x12>

008015e5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801603:	b8 02 00 00 00       	mov    $0x2,%eax
  801608:	e8 8b ff ff ff       	call   801598 <fsipc>
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <devfile_flush>:
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8b 40 0c             	mov    0xc(%eax),%eax
  80161b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	b8 06 00 00 00       	mov    $0x6,%eax
  80162a:	e8 69 ff ff ff       	call   801598 <fsipc>
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <devfile_stat>:
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	53                   	push   %ebx
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8b 40 0c             	mov    0xc(%eax),%eax
  801641:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801646:	ba 00 00 00 00       	mov    $0x0,%edx
  80164b:	b8 05 00 00 00       	mov    $0x5,%eax
  801650:	e8 43 ff ff ff       	call   801598 <fsipc>
  801655:	85 c0                	test   %eax,%eax
  801657:	78 2c                	js     801685 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	68 00 50 80 00       	push   $0x805000
  801661:	53                   	push   %ebx
  801662:	e8 d8 f2 ff ff       	call   80093f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801667:	a1 80 50 80 00       	mov    0x805080,%eax
  80166c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801672:	a1 84 50 80 00       	mov    0x805084,%eax
  801677:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <devfile_write>:
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	53                   	push   %ebx
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8b 40 0c             	mov    0xc(%eax),%eax
  80169a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80169f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016a5:	53                   	push   %ebx
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	68 08 50 80 00       	push   $0x805008
  8016ae:	e8 7c f4 ff ff       	call   800b2f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8016bd:	e8 d6 fe ff ff       	call   801598 <fsipc>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 0b                	js     8016d4 <devfile_write+0x4a>
	assert(r <= n);
  8016c9:	39 d8                	cmp    %ebx,%eax
  8016cb:	77 0c                	ja     8016d9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016cd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d2:	7f 1e                	jg     8016f2 <devfile_write+0x68>
}
  8016d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    
	assert(r <= n);
  8016d9:	68 04 2a 80 00       	push   $0x802a04
  8016de:	68 0b 2a 80 00       	push   $0x802a0b
  8016e3:	68 98 00 00 00       	push   $0x98
  8016e8:	68 20 2a 80 00       	push   $0x802a20
  8016ed:	e8 6a 0a 00 00       	call   80215c <_panic>
	assert(r <= PGSIZE);
  8016f2:	68 2b 2a 80 00       	push   $0x802a2b
  8016f7:	68 0b 2a 80 00       	push   $0x802a0b
  8016fc:	68 99 00 00 00       	push   $0x99
  801701:	68 20 2a 80 00       	push   $0x802a20
  801706:	e8 51 0a 00 00       	call   80215c <_panic>

0080170b <devfile_read>:
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
  801710:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8b 40 0c             	mov    0xc(%eax),%eax
  801719:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80171e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 03 00 00 00       	mov    $0x3,%eax
  80172e:	e8 65 fe ff ff       	call   801598 <fsipc>
  801733:	89 c3                	mov    %eax,%ebx
  801735:	85 c0                	test   %eax,%eax
  801737:	78 1f                	js     801758 <devfile_read+0x4d>
	assert(r <= n);
  801739:	39 f0                	cmp    %esi,%eax
  80173b:	77 24                	ja     801761 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80173d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801742:	7f 33                	jg     801777 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	50                   	push   %eax
  801748:	68 00 50 80 00       	push   $0x805000
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	e8 78 f3 ff ff       	call   800acd <memmove>
	return r;
  801755:	83 c4 10             	add    $0x10,%esp
}
  801758:	89 d8                	mov    %ebx,%eax
  80175a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    
	assert(r <= n);
  801761:	68 04 2a 80 00       	push   $0x802a04
  801766:	68 0b 2a 80 00       	push   $0x802a0b
  80176b:	6a 7c                	push   $0x7c
  80176d:	68 20 2a 80 00       	push   $0x802a20
  801772:	e8 e5 09 00 00       	call   80215c <_panic>
	assert(r <= PGSIZE);
  801777:	68 2b 2a 80 00       	push   $0x802a2b
  80177c:	68 0b 2a 80 00       	push   $0x802a0b
  801781:	6a 7d                	push   $0x7d
  801783:	68 20 2a 80 00       	push   $0x802a20
  801788:	e8 cf 09 00 00       	call   80215c <_panic>

0080178d <open>:
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	56                   	push   %esi
  801791:	53                   	push   %ebx
  801792:	83 ec 1c             	sub    $0x1c,%esp
  801795:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801798:	56                   	push   %esi
  801799:	e8 68 f1 ff ff       	call   800906 <strlen>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a6:	7f 6c                	jg     801814 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ae:	50                   	push   %eax
  8017af:	e8 79 f8 ff ff       	call   80102d <fd_alloc>
  8017b4:	89 c3                	mov    %eax,%ebx
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 3c                	js     8017f9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	56                   	push   %esi
  8017c1:	68 00 50 80 00       	push   $0x805000
  8017c6:	e8 74 f1 ff ff       	call   80093f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017db:	e8 b8 fd ff ff       	call   801598 <fsipc>
  8017e0:	89 c3                	mov    %eax,%ebx
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	78 19                	js     801802 <open+0x75>
	return fd2num(fd);
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ef:	e8 12 f8 ff ff       	call   801006 <fd2num>
  8017f4:	89 c3                	mov    %eax,%ebx
  8017f6:	83 c4 10             	add    $0x10,%esp
}
  8017f9:	89 d8                	mov    %ebx,%eax
  8017fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    
		fd_close(fd, 0);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	6a 00                	push   $0x0
  801807:	ff 75 f4             	pushl  -0xc(%ebp)
  80180a:	e8 1b f9 ff ff       	call   80112a <fd_close>
		return r;
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	eb e5                	jmp    8017f9 <open+0x6c>
		return -E_BAD_PATH;
  801814:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801819:	eb de                	jmp    8017f9 <open+0x6c>

0080181b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801821:	ba 00 00 00 00       	mov    $0x0,%edx
  801826:	b8 08 00 00 00       	mov    $0x8,%eax
  80182b:	e8 68 fd ff ff       	call   801598 <fsipc>
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801838:	68 37 2a 80 00       	push   $0x802a37
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	e8 fa f0 ff ff       	call   80093f <strcpy>
	return 0;
}
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <devsock_close>:
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
  801850:	83 ec 10             	sub    $0x10,%esp
  801853:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801856:	53                   	push   %ebx
  801857:	e8 5d 0a 00 00       	call   8022b9 <pageref>
  80185c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80185f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801864:	83 f8 01             	cmp    $0x1,%eax
  801867:	74 07                	je     801870 <devsock_close+0x24>
}
  801869:	89 d0                	mov    %edx,%eax
  80186b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	ff 73 0c             	pushl  0xc(%ebx)
  801876:	e8 b9 02 00 00       	call   801b34 <nsipc_close>
  80187b:	89 c2                	mov    %eax,%edx
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	eb e7                	jmp    801869 <devsock_close+0x1d>

00801882 <devsock_write>:
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 10             	pushl  0x10(%ebp)
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	ff 70 0c             	pushl  0xc(%eax)
  801896:	e8 76 03 00 00       	call   801c11 <nsipc_send>
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <devsock_read>:
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	ff 75 10             	pushl  0x10(%ebp)
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	ff 70 0c             	pushl  0xc(%eax)
  8018b1:	e8 ef 02 00 00       	call   801ba5 <nsipc_recv>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <fd2sockid>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018be:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	e8 b7 f7 ff ff       	call   80107f <fd_lookup>
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 10                	js     8018df <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018d8:	39 08                	cmp    %ecx,(%eax)
  8018da:	75 05                	jne    8018e1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018dc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8018e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e6:	eb f7                	jmp    8018df <fd2sockid+0x27>

008018e8 <alloc_sockfd>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	83 ec 1c             	sub    $0x1c,%esp
  8018f0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	e8 32 f7 ff ff       	call   80102d <fd_alloc>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	78 43                	js     801947 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	68 07 04 00 00       	push   $0x407
  80190c:	ff 75 f4             	pushl  -0xc(%ebp)
  80190f:	6a 00                	push   $0x0
  801911:	e8 1b f4 ff ff       	call   800d31 <sys_page_alloc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 28                	js     801947 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801928:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801934:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	50                   	push   %eax
  80193b:	e8 c6 f6 ff ff       	call   801006 <fd2num>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	eb 0c                	jmp    801953 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	56                   	push   %esi
  80194b:	e8 e4 01 00 00       	call   801b34 <nsipc_close>
		return r;
  801950:	83 c4 10             	add    $0x10,%esp
}
  801953:	89 d8                	mov    %ebx,%eax
  801955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <accept>:
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	e8 4e ff ff ff       	call   8018b8 <fd2sockid>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 1b                	js     801989 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	50                   	push   %eax
  801978:	e8 0e 01 00 00       	call   801a8b <nsipc_accept>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	78 05                	js     801989 <accept+0x2d>
	return alloc_sockfd(r);
  801984:	e8 5f ff ff ff       	call   8018e8 <alloc_sockfd>
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <bind>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	e8 1f ff ff ff       	call   8018b8 <fd2sockid>
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 12                	js     8019af <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	ff 75 10             	pushl  0x10(%ebp)
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	e8 31 01 00 00       	call   801add <nsipc_bind>
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <shutdown>:
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	e8 f9 fe ff ff       	call   8018b8 <fd2sockid>
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 0f                	js     8019d2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	e8 43 01 00 00       	call   801b12 <nsipc_shutdown>
  8019cf:	83 c4 10             	add    $0x10,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <connect>:
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	e8 d6 fe ff ff       	call   8018b8 <fd2sockid>
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 12                	js     8019f8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	e8 59 01 00 00       	call   801b4e <nsipc_connect>
  8019f5:	83 c4 10             	add    $0x10,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <listen>:
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	e8 b0 fe ff ff       	call   8018b8 <fd2sockid>
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 0f                	js     801a1b <listen+0x21>
	return nsipc_listen(r, backlog);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	50                   	push   %eax
  801a13:	e8 6b 01 00 00       	call   801b83 <nsipc_listen>
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <socket>:

int
socket(int domain, int type, int protocol)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a23:	ff 75 10             	pushl  0x10(%ebp)
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	e8 3e 02 00 00       	call   801c6f <nsipc_socket>
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 05                	js     801a3d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a38:	e8 ab fe ff ff       	call   8018e8 <alloc_sockfd>
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a48:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a4f:	74 26                	je     801a77 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a51:	6a 07                	push   $0x7
  801a53:	68 00 60 80 00       	push   $0x806000
  801a58:	53                   	push   %ebx
  801a59:	ff 35 04 40 80 00    	pushl  0x804004
  801a5f:	e8 c2 07 00 00       	call   802226 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a64:	83 c4 0c             	add    $0xc,%esp
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	e8 4b 07 00 00       	call   8021bd <ipc_recv>
}
  801a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	6a 02                	push   $0x2
  801a7c:	e8 fd 07 00 00       	call   80227e <ipc_find_env>
  801a81:	a3 04 40 80 00       	mov    %eax,0x804004
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	eb c6                	jmp    801a51 <nsipc+0x12>

00801a8b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a9b:	8b 06                	mov    (%esi),%eax
  801a9d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	e8 93 ff ff ff       	call   801a3f <nsipc>
  801aac:	89 c3                	mov    %eax,%ebx
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	79 09                	jns    801abb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ab2:	89 d8                	mov    %ebx,%eax
  801ab4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5d                   	pop    %ebp
  801aba:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	ff 35 10 60 80 00    	pushl  0x806010
  801ac4:	68 00 60 80 00       	push   $0x806000
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	e8 fc ef ff ff       	call   800acd <memmove>
		*addrlen = ret->ret_addrlen;
  801ad1:	a1 10 60 80 00       	mov    0x806010,%eax
  801ad6:	89 06                	mov    %eax,(%esi)
  801ad8:	83 c4 10             	add    $0x10,%esp
	return r;
  801adb:	eb d5                	jmp    801ab2 <nsipc_accept+0x27>

00801add <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aef:	53                   	push   %ebx
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	68 04 60 80 00       	push   $0x806004
  801af8:	e8 d0 ef ff ff       	call   800acd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801afd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b03:	b8 02 00 00 00       	mov    $0x2,%eax
  801b08:	e8 32 ff ff ff       	call   801a3f <nsipc>
}
  801b0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b28:	b8 03 00 00 00       	mov    $0x3,%eax
  801b2d:	e8 0d ff ff ff       	call   801a3f <nsipc>
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <nsipc_close>:

int
nsipc_close(int s)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b42:	b8 04 00 00 00       	mov    $0x4,%eax
  801b47:	e8 f3 fe ff ff       	call   801a3f <nsipc>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	53                   	push   %ebx
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b60:	53                   	push   %ebx
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	68 04 60 80 00       	push   $0x806004
  801b69:	e8 5f ef ff ff       	call   800acd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b6e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b74:	b8 05 00 00 00       	mov    $0x5,%eax
  801b79:	e8 c1 fe ff ff       	call   801a3f <nsipc>
}
  801b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b94:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b99:	b8 06 00 00 00       	mov    $0x6,%eax
  801b9e:	e8 9c fe ff ff       	call   801a3f <nsipc>
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bb5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbe:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bc3:	b8 07 00 00 00       	mov    $0x7,%eax
  801bc8:	e8 72 fe ff ff       	call   801a3f <nsipc>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 1f                	js     801bf2 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bd3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bd8:	7f 21                	jg     801bfb <nsipc_recv+0x56>
  801bda:	39 c6                	cmp    %eax,%esi
  801bdc:	7c 1d                	jl     801bfb <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	50                   	push   %eax
  801be2:	68 00 60 80 00       	push   $0x806000
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	e8 de ee ff ff       	call   800acd <memmove>
  801bef:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bf2:	89 d8                	mov    %ebx,%eax
  801bf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5d                   	pop    %ebp
  801bfa:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bfb:	68 43 2a 80 00       	push   $0x802a43
  801c00:	68 0b 2a 80 00       	push   $0x802a0b
  801c05:	6a 62                	push   $0x62
  801c07:	68 58 2a 80 00       	push   $0x802a58
  801c0c:	e8 4b 05 00 00       	call   80215c <_panic>

00801c11 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	53                   	push   %ebx
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c23:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c29:	7f 2e                	jg     801c59 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	53                   	push   %ebx
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	68 0c 60 80 00       	push   $0x80600c
  801c37:	e8 91 ee ff ff       	call   800acd <memmove>
	nsipcbuf.send.req_size = size;
  801c3c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c42:	8b 45 14             	mov    0x14(%ebp),%eax
  801c45:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c4a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c4f:	e8 eb fd ff ff       	call   801a3f <nsipc>
}
  801c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    
	assert(size < 1600);
  801c59:	68 64 2a 80 00       	push   $0x802a64
  801c5e:	68 0b 2a 80 00       	push   $0x802a0b
  801c63:	6a 6d                	push   $0x6d
  801c65:	68 58 2a 80 00       	push   $0x802a58
  801c6a:	e8 ed 04 00 00       	call   80215c <_panic>

00801c6f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c80:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c85:	8b 45 10             	mov    0x10(%ebp),%eax
  801c88:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c8d:	b8 09 00 00 00       	mov    $0x9,%eax
  801c92:	e8 a8 fd ff ff       	call   801a3f <nsipc>
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	ff 75 08             	pushl  0x8(%ebp)
  801ca7:	e8 6a f3 ff ff       	call   801016 <fd2data>
  801cac:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cae:	83 c4 08             	add    $0x8,%esp
  801cb1:	68 70 2a 80 00       	push   $0x802a70
  801cb6:	53                   	push   %ebx
  801cb7:	e8 83 ec ff ff       	call   80093f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cbc:	8b 46 04             	mov    0x4(%esi),%eax
  801cbf:	2b 06                	sub    (%esi),%eax
  801cc1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cc7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cce:	00 00 00 
	stat->st_dev = &devpipe;
  801cd1:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cd8:	30 80 00 
	return 0;
}
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cf1:	53                   	push   %ebx
  801cf2:	6a 00                	push   $0x0
  801cf4:	e8 bd f0 ff ff       	call   800db6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf9:	89 1c 24             	mov    %ebx,(%esp)
  801cfc:	e8 15 f3 ff ff       	call   801016 <fd2data>
  801d01:	83 c4 08             	add    $0x8,%esp
  801d04:	50                   	push   %eax
  801d05:	6a 00                	push   $0x0
  801d07:	e8 aa f0 ff ff       	call   800db6 <sys_page_unmap>
}
  801d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <_pipeisclosed>:
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	57                   	push   %edi
  801d15:	56                   	push   %esi
  801d16:	53                   	push   %ebx
  801d17:	83 ec 1c             	sub    $0x1c,%esp
  801d1a:	89 c7                	mov    %eax,%edi
  801d1c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d1e:	a1 08 40 80 00       	mov    0x804008,%eax
  801d23:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	57                   	push   %edi
  801d2a:	e8 8a 05 00 00       	call   8022b9 <pageref>
  801d2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d32:	89 34 24             	mov    %esi,(%esp)
  801d35:	e8 7f 05 00 00       	call   8022b9 <pageref>
		nn = thisenv->env_runs;
  801d3a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d40:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	39 cb                	cmp    %ecx,%ebx
  801d48:	74 1b                	je     801d65 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d4a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d4d:	75 cf                	jne    801d1e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d4f:	8b 42 58             	mov    0x58(%edx),%eax
  801d52:	6a 01                	push   $0x1
  801d54:	50                   	push   %eax
  801d55:	53                   	push   %ebx
  801d56:	68 77 2a 80 00       	push   $0x802a77
  801d5b:	e8 80 e4 ff ff       	call   8001e0 <cprintf>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	eb b9                	jmp    801d1e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d65:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d68:	0f 94 c0             	sete   %al
  801d6b:	0f b6 c0             	movzbl %al,%eax
}
  801d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <devpipe_write>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 28             	sub    $0x28,%esp
  801d7f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d82:	56                   	push   %esi
  801d83:	e8 8e f2 ff ff       	call   801016 <fd2data>
  801d88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d92:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d95:	74 4f                	je     801de6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d97:	8b 43 04             	mov    0x4(%ebx),%eax
  801d9a:	8b 0b                	mov    (%ebx),%ecx
  801d9c:	8d 51 20             	lea    0x20(%ecx),%edx
  801d9f:	39 d0                	cmp    %edx,%eax
  801da1:	72 14                	jb     801db7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801da3:	89 da                	mov    %ebx,%edx
  801da5:	89 f0                	mov    %esi,%eax
  801da7:	e8 65 ff ff ff       	call   801d11 <_pipeisclosed>
  801dac:	85 c0                	test   %eax,%eax
  801dae:	75 3b                	jne    801deb <devpipe_write+0x75>
			sys_yield();
  801db0:	e8 5d ef ff ff       	call   800d12 <sys_yield>
  801db5:	eb e0                	jmp    801d97 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dbe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dc1:	89 c2                	mov    %eax,%edx
  801dc3:	c1 fa 1f             	sar    $0x1f,%edx
  801dc6:	89 d1                	mov    %edx,%ecx
  801dc8:	c1 e9 1b             	shr    $0x1b,%ecx
  801dcb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dce:	83 e2 1f             	and    $0x1f,%edx
  801dd1:	29 ca                	sub    %ecx,%edx
  801dd3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dd7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ddb:	83 c0 01             	add    $0x1,%eax
  801dde:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801de1:	83 c7 01             	add    $0x1,%edi
  801de4:	eb ac                	jmp    801d92 <devpipe_write+0x1c>
	return i;
  801de6:	8b 45 10             	mov    0x10(%ebp),%eax
  801de9:	eb 05                	jmp    801df0 <devpipe_write+0x7a>
				return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    

00801df8 <devpipe_read>:
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	57                   	push   %edi
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	83 ec 18             	sub    $0x18,%esp
  801e01:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e04:	57                   	push   %edi
  801e05:	e8 0c f2 ff ff       	call   801016 <fd2data>
  801e0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	be 00 00 00 00       	mov    $0x0,%esi
  801e14:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e17:	75 14                	jne    801e2d <devpipe_read+0x35>
	return i;
  801e19:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1c:	eb 02                	jmp    801e20 <devpipe_read+0x28>
				return i;
  801e1e:	89 f0                	mov    %esi,%eax
}
  801e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
			sys_yield();
  801e28:	e8 e5 ee ff ff       	call   800d12 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e2d:	8b 03                	mov    (%ebx),%eax
  801e2f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e32:	75 18                	jne    801e4c <devpipe_read+0x54>
			if (i > 0)
  801e34:	85 f6                	test   %esi,%esi
  801e36:	75 e6                	jne    801e1e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e38:	89 da                	mov    %ebx,%edx
  801e3a:	89 f8                	mov    %edi,%eax
  801e3c:	e8 d0 fe ff ff       	call   801d11 <_pipeisclosed>
  801e41:	85 c0                	test   %eax,%eax
  801e43:	74 e3                	je     801e28 <devpipe_read+0x30>
				return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4a:	eb d4                	jmp    801e20 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e4c:	99                   	cltd   
  801e4d:	c1 ea 1b             	shr    $0x1b,%edx
  801e50:	01 d0                	add    %edx,%eax
  801e52:	83 e0 1f             	and    $0x1f,%eax
  801e55:	29 d0                	sub    %edx,%eax
  801e57:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e62:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e65:	83 c6 01             	add    $0x1,%esi
  801e68:	eb aa                	jmp    801e14 <devpipe_read+0x1c>

00801e6a <pipe>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	56                   	push   %esi
  801e6e:	53                   	push   %ebx
  801e6f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e75:	50                   	push   %eax
  801e76:	e8 b2 f1 ff ff       	call   80102d <fd_alloc>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	85 c0                	test   %eax,%eax
  801e82:	0f 88 23 01 00 00    	js     801fab <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	68 07 04 00 00       	push   $0x407
  801e90:	ff 75 f4             	pushl  -0xc(%ebp)
  801e93:	6a 00                	push   $0x0
  801e95:	e8 97 ee ff ff       	call   800d31 <sys_page_alloc>
  801e9a:	89 c3                	mov    %eax,%ebx
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	0f 88 04 01 00 00    	js     801fab <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ead:	50                   	push   %eax
  801eae:	e8 7a f1 ff ff       	call   80102d <fd_alloc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 88 db 00 00 00    	js     801f9b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	68 07 04 00 00       	push   $0x407
  801ec8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ecb:	6a 00                	push   $0x0
  801ecd:	e8 5f ee ff ff       	call   800d31 <sys_page_alloc>
  801ed2:	89 c3                	mov    %eax,%ebx
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	0f 88 bc 00 00 00    	js     801f9b <pipe+0x131>
	va = fd2data(fd0);
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee5:	e8 2c f1 ff ff       	call   801016 <fd2data>
  801eea:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eec:	83 c4 0c             	add    $0xc,%esp
  801eef:	68 07 04 00 00       	push   $0x407
  801ef4:	50                   	push   %eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	e8 35 ee ff ff       	call   800d31 <sys_page_alloc>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	0f 88 82 00 00 00    	js     801f8b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0f:	e8 02 f1 ff ff       	call   801016 <fd2data>
  801f14:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f1b:	50                   	push   %eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	56                   	push   %esi
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 4e ee ff ff       	call   800d74 <sys_page_map>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	83 c4 20             	add    $0x20,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 4e                	js     801f7d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f2f:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f37:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f46:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 f4             	pushl  -0xc(%ebp)
  801f58:	e8 a9 f0 ff ff       	call   801006 <fd2num>
  801f5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f60:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f62:	83 c4 04             	add    $0x4,%esp
  801f65:	ff 75 f0             	pushl  -0x10(%ebp)
  801f68:	e8 99 f0 ff ff       	call   801006 <fd2num>
  801f6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f70:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f7b:	eb 2e                	jmp    801fab <pipe+0x141>
	sys_page_unmap(0, va);
  801f7d:	83 ec 08             	sub    $0x8,%esp
  801f80:	56                   	push   %esi
  801f81:	6a 00                	push   $0x0
  801f83:	e8 2e ee ff ff       	call   800db6 <sys_page_unmap>
  801f88:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f91:	6a 00                	push   $0x0
  801f93:	e8 1e ee ff ff       	call   800db6 <sys_page_unmap>
  801f98:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 0e ee ff ff       	call   800db6 <sys_page_unmap>
  801fa8:	83 c4 10             	add    $0x10,%esp
}
  801fab:	89 d8                	mov    %ebx,%eax
  801fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    

00801fb4 <pipeisclosed>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbd:	50                   	push   %eax
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	e8 b9 f0 ff ff       	call   80107f <fd_lookup>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 18                	js     801fe5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd3:	e8 3e f0 ff ff       	call   801016 <fd2data>
	return _pipeisclosed(fd, p);
  801fd8:	89 c2                	mov    %eax,%edx
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	e8 2f fd ff ff       	call   801d11 <_pipeisclosed>
  801fe2:	83 c4 10             	add    $0x10,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	c3                   	ret    

00801fed <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ff3:	68 8f 2a 80 00       	push   $0x802a8f
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	e8 3f e9 ff ff       	call   80093f <strcpy>
	return 0;
}
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <devcons_write>:
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	57                   	push   %edi
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802013:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802018:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80201e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802021:	73 31                	jae    802054 <devcons_write+0x4d>
		m = n - tot;
  802023:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802026:	29 f3                	sub    %esi,%ebx
  802028:	83 fb 7f             	cmp    $0x7f,%ebx
  80202b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802030:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	53                   	push   %ebx
  802037:	89 f0                	mov    %esi,%eax
  802039:	03 45 0c             	add    0xc(%ebp),%eax
  80203c:	50                   	push   %eax
  80203d:	57                   	push   %edi
  80203e:	e8 8a ea ff ff       	call   800acd <memmove>
		sys_cputs(buf, m);
  802043:	83 c4 08             	add    $0x8,%esp
  802046:	53                   	push   %ebx
  802047:	57                   	push   %edi
  802048:	e8 28 ec ff ff       	call   800c75 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80204d:	01 de                	add    %ebx,%esi
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	eb ca                	jmp    80201e <devcons_write+0x17>
}
  802054:	89 f0                	mov    %esi,%eax
  802056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5f                   	pop    %edi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    

0080205e <devcons_read>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802069:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206d:	74 21                	je     802090 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80206f:	e8 1f ec ff ff       	call   800c93 <sys_cgetc>
  802074:	85 c0                	test   %eax,%eax
  802076:	75 07                	jne    80207f <devcons_read+0x21>
		sys_yield();
  802078:	e8 95 ec ff ff       	call   800d12 <sys_yield>
  80207d:	eb f0                	jmp    80206f <devcons_read+0x11>
	if (c < 0)
  80207f:	78 0f                	js     802090 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802081:	83 f8 04             	cmp    $0x4,%eax
  802084:	74 0c                	je     802092 <devcons_read+0x34>
	*(char*)vbuf = c;
  802086:	8b 55 0c             	mov    0xc(%ebp),%edx
  802089:	88 02                	mov    %al,(%edx)
	return 1;
  80208b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    
		return 0;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	eb f7                	jmp    802090 <devcons_read+0x32>

00802099 <cputchar>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020a5:	6a 01                	push   $0x1
  8020a7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020aa:	50                   	push   %eax
  8020ab:	e8 c5 eb ff ff       	call   800c75 <sys_cputs>
}
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <getchar>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020bb:	6a 01                	push   $0x1
  8020bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c0:	50                   	push   %eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 27 f2 ff ff       	call   8012ef <read>
	if (r < 0)
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 06                	js     8020d5 <getchar+0x20>
	if (r < 1)
  8020cf:	74 06                	je     8020d7 <getchar+0x22>
	return c;
  8020d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    
		return -E_EOF;
  8020d7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020dc:	eb f7                	jmp    8020d5 <getchar+0x20>

008020de <iscons>:
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e7:	50                   	push   %eax
  8020e8:	ff 75 08             	pushl  0x8(%ebp)
  8020eb:	e8 8f ef ff ff       	call   80107f <fd_lookup>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 11                	js     802108 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802100:	39 10                	cmp    %edx,(%eax)
  802102:	0f 94 c0             	sete   %al
  802105:	0f b6 c0             	movzbl %al,%eax
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <opencons>:
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802113:	50                   	push   %eax
  802114:	e8 14 ef ff ff       	call   80102d <fd_alloc>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 3a                	js     80215a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	68 07 04 00 00       	push   $0x407
  802128:	ff 75 f4             	pushl  -0xc(%ebp)
  80212b:	6a 00                	push   $0x0
  80212d:	e8 ff eb ff ff       	call   800d31 <sys_page_alloc>
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	85 c0                	test   %eax,%eax
  802137:	78 21                	js     80215a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802142:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	50                   	push   %eax
  802152:	e8 af ee ff ff       	call   801006 <fd2num>
  802157:	83 c4 10             	add    $0x10,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	56                   	push   %esi
  802160:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802161:	a1 08 40 80 00       	mov    0x804008,%eax
  802166:	8b 40 48             	mov    0x48(%eax),%eax
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 c0 2a 80 00       	push   $0x802ac0
  802171:	50                   	push   %eax
  802172:	68 b8 25 80 00       	push   $0x8025b8
  802177:	e8 64 e0 ff ff       	call   8001e0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80217c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80217f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802185:	e8 69 eb ff ff       	call   800cf3 <sys_getenvid>
  80218a:	83 c4 04             	add    $0x4,%esp
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	ff 75 08             	pushl  0x8(%ebp)
  802193:	56                   	push   %esi
  802194:	50                   	push   %eax
  802195:	68 9c 2a 80 00       	push   $0x802a9c
  80219a:	e8 41 e0 ff ff       	call   8001e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80219f:	83 c4 18             	add    $0x18,%esp
  8021a2:	53                   	push   %ebx
  8021a3:	ff 75 10             	pushl  0x10(%ebp)
  8021a6:	e8 e4 df ff ff       	call   80018f <vcprintf>
	cprintf("\n");
  8021ab:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  8021b2:	e8 29 e0 ff ff       	call   8001e0 <cprintf>
  8021b7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ba:	cc                   	int3   
  8021bb:	eb fd                	jmp    8021ba <_panic+0x5e>

008021bd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8021c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021cb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021cd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021d2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021d5:	83 ec 0c             	sub    $0xc,%esp
  8021d8:	50                   	push   %eax
  8021d9:	e8 03 ed ff ff       	call   800ee1 <sys_ipc_recv>
	if(ret < 0){
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	78 2b                	js     802210 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021e5:	85 f6                	test   %esi,%esi
  8021e7:	74 0a                	je     8021f3 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ee:	8b 40 74             	mov    0x74(%eax),%eax
  8021f1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021f3:	85 db                	test   %ebx,%ebx
  8021f5:	74 0a                	je     802201 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fc:	8b 40 78             	mov    0x78(%eax),%eax
  8021ff:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802201:	a1 08 40 80 00       	mov    0x804008,%eax
  802206:	8b 40 70             	mov    0x70(%eax),%eax
}
  802209:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5d                   	pop    %ebp
  80220f:	c3                   	ret    
		if(from_env_store)
  802210:	85 f6                	test   %esi,%esi
  802212:	74 06                	je     80221a <ipc_recv+0x5d>
			*from_env_store = 0;
  802214:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80221a:	85 db                	test   %ebx,%ebx
  80221c:	74 eb                	je     802209 <ipc_recv+0x4c>
			*perm_store = 0;
  80221e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802224:	eb e3                	jmp    802209 <ipc_recv+0x4c>

00802226 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802232:	8b 75 0c             	mov    0xc(%ebp),%esi
  802235:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802238:	85 db                	test   %ebx,%ebx
  80223a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80223f:	0f 44 d8             	cmove  %eax,%ebx
  802242:	eb 05                	jmp    802249 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802244:	e8 c9 ea ff ff       	call   800d12 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802249:	ff 75 14             	pushl  0x14(%ebp)
  80224c:	53                   	push   %ebx
  80224d:	56                   	push   %esi
  80224e:	57                   	push   %edi
  80224f:	e8 6a ec ff ff       	call   800ebe <sys_ipc_try_send>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	85 c0                	test   %eax,%eax
  802259:	74 1b                	je     802276 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80225b:	79 e7                	jns    802244 <ipc_send+0x1e>
  80225d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802260:	74 e2                	je     802244 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 c7 2a 80 00       	push   $0x802ac7
  80226a:	6a 46                	push   $0x46
  80226c:	68 dc 2a 80 00       	push   $0x802adc
  802271:	e8 e6 fe ff ff       	call   80215c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802279:	5b                   	pop    %ebx
  80227a:	5e                   	pop    %esi
  80227b:	5f                   	pop    %edi
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    

0080227e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802289:	89 c2                	mov    %eax,%edx
  80228b:	c1 e2 07             	shl    $0x7,%edx
  80228e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802294:	8b 52 50             	mov    0x50(%edx),%edx
  802297:	39 ca                	cmp    %ecx,%edx
  802299:	74 11                	je     8022ac <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80229b:	83 c0 01             	add    $0x1,%eax
  80229e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022a3:	75 e4                	jne    802289 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022aa:	eb 0b                	jmp    8022b7 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022ac:	c1 e0 07             	shl    $0x7,%eax
  8022af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	c1 e8 16             	shr    $0x16,%eax
  8022c4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022d0:	f6 c1 01             	test   $0x1,%cl
  8022d3:	74 1d                	je     8022f2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022d5:	c1 ea 0c             	shr    $0xc,%edx
  8022d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022df:	f6 c2 01             	test   $0x1,%dl
  8022e2:	74 0e                	je     8022f2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022e4:	c1 ea 0c             	shr    $0xc,%edx
  8022e7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ee:	ef 
  8022ef:	0f b7 c0             	movzwl %ax,%eax
}
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
  8022f4:	66 90                	xchg   %ax,%ax
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__udivdi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80230f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802313:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802317:	85 d2                	test   %edx,%edx
  802319:	75 4d                	jne    802368 <__udivdi3+0x68>
  80231b:	39 f3                	cmp    %esi,%ebx
  80231d:	76 19                	jbe    802338 <__udivdi3+0x38>
  80231f:	31 ff                	xor    %edi,%edi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f2                	mov    %esi,%edx
  802325:	f7 f3                	div    %ebx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	89 d9                	mov    %ebx,%ecx
  80233a:	85 db                	test   %ebx,%ebx
  80233c:	75 0b                	jne    802349 <__udivdi3+0x49>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 c1                	mov    %eax,%ecx
  802349:	31 d2                	xor    %edx,%edx
  80234b:	89 f0                	mov    %esi,%eax
  80234d:	f7 f1                	div    %ecx
  80234f:	89 c6                	mov    %eax,%esi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f7                	mov    %esi,%edi
  802355:	f7 f1                	div    %ecx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	77 1c                	ja     802388 <__udivdi3+0x88>
  80236c:	0f bd fa             	bsr    %edx,%edi
  80236f:	83 f7 1f             	xor    $0x1f,%edi
  802372:	75 2c                	jne    8023a0 <__udivdi3+0xa0>
  802374:	39 f2                	cmp    %esi,%edx
  802376:	72 06                	jb     80237e <__udivdi3+0x7e>
  802378:	31 c0                	xor    %eax,%eax
  80237a:	39 eb                	cmp    %ebp,%ebx
  80237c:	77 a9                	ja     802327 <__udivdi3+0x27>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	eb a2                	jmp    802327 <__udivdi3+0x27>
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 c0                	xor    %eax,%eax
  80238c:	89 fa                	mov    %edi,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 f9                	mov    %edi,%ecx
  8023a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023a7:	29 f8                	sub    %edi,%eax
  8023a9:	d3 e2                	shl    %cl,%edx
  8023ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 da                	mov    %ebx,%edx
  8023b3:	d3 ea                	shr    %cl,%edx
  8023b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b9:	09 d1                	or     %edx,%ecx
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 f9                	mov    %edi,%ecx
  8023c3:	d3 e3                	shl    %cl,%ebx
  8023c5:	89 c1                	mov    %eax,%ecx
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	89 f9                	mov    %edi,%ecx
  8023cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023cf:	89 eb                	mov    %ebp,%ebx
  8023d1:	d3 e6                	shl    %cl,%esi
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	d3 eb                	shr    %cl,%ebx
  8023d7:	09 de                	or     %ebx,%esi
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	f7 74 24 08          	divl   0x8(%esp)
  8023df:	89 d6                	mov    %edx,%esi
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	f7 64 24 0c          	mull   0xc(%esp)
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	72 15                	jb     802400 <__udivdi3+0x100>
  8023eb:	89 f9                	mov    %edi,%ecx
  8023ed:	d3 e5                	shl    %cl,%ebp
  8023ef:	39 c5                	cmp    %eax,%ebp
  8023f1:	73 04                	jae    8023f7 <__udivdi3+0xf7>
  8023f3:	39 d6                	cmp    %edx,%esi
  8023f5:	74 09                	je     802400 <__udivdi3+0x100>
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	31 ff                	xor    %edi,%edi
  8023fb:	e9 27 ff ff ff       	jmp    802327 <__udivdi3+0x27>
  802400:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802403:	31 ff                	xor    %edi,%edi
  802405:	e9 1d ff ff ff       	jmp    802327 <__udivdi3+0x27>
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80241b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802423:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802427:	89 da                	mov    %ebx,%edx
  802429:	85 c0                	test   %eax,%eax
  80242b:	75 43                	jne    802470 <__umoddi3+0x60>
  80242d:	39 df                	cmp    %ebx,%edi
  80242f:	76 17                	jbe    802448 <__umoddi3+0x38>
  802431:	89 f0                	mov    %esi,%eax
  802433:	f7 f7                	div    %edi
  802435:	89 d0                	mov    %edx,%eax
  802437:	31 d2                	xor    %edx,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 fd                	mov    %edi,%ebp
  80244a:	85 ff                	test   %edi,%edi
  80244c:	75 0b                	jne    802459 <__umoddi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c5                	mov    %eax,%ebp
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f5                	div    %ebp
  80245f:	89 f0                	mov    %esi,%eax
  802461:	f7 f5                	div    %ebp
  802463:	89 d0                	mov    %edx,%eax
  802465:	eb d0                	jmp    802437 <__umoddi3+0x27>
  802467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246e:	66 90                	xchg   %ax,%ax
  802470:	89 f1                	mov    %esi,%ecx
  802472:	39 d8                	cmp    %ebx,%eax
  802474:	76 0a                	jbe    802480 <__umoddi3+0x70>
  802476:	89 f0                	mov    %esi,%eax
  802478:	83 c4 1c             	add    $0x1c,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    
  802480:	0f bd e8             	bsr    %eax,%ebp
  802483:	83 f5 1f             	xor    $0x1f,%ebp
  802486:	75 20                	jne    8024a8 <__umoddi3+0x98>
  802488:	39 d8                	cmp    %ebx,%eax
  80248a:	0f 82 b0 00 00 00    	jb     802540 <__umoddi3+0x130>
  802490:	39 f7                	cmp    %esi,%edi
  802492:	0f 86 a8 00 00 00    	jbe    802540 <__umoddi3+0x130>
  802498:	89 c8                	mov    %ecx,%eax
  80249a:	83 c4 1c             	add    $0x1c,%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5f                   	pop    %edi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    
  8024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024af:	29 ea                	sub    %ebp,%edx
  8024b1:	d3 e0                	shl    %cl,%eax
  8024b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b7:	89 d1                	mov    %edx,%ecx
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	d3 e8                	shr    %cl,%eax
  8024bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024c9:	09 c1                	or     %eax,%ecx
  8024cb:	89 d8                	mov    %ebx,%eax
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 e9                	mov    %ebp,%ecx
  8024d3:	d3 e7                	shl    %cl,%edi
  8024d5:	89 d1                	mov    %edx,%ecx
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024df:	d3 e3                	shl    %cl,%ebx
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	89 d1                	mov    %edx,%ecx
  8024e5:	89 f0                	mov    %esi,%eax
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 fa                	mov    %edi,%edx
  8024ed:	d3 e6                	shl    %cl,%esi
  8024ef:	09 d8                	or     %ebx,%eax
  8024f1:	f7 74 24 08          	divl   0x8(%esp)
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	89 f3                	mov    %esi,%ebx
  8024f9:	f7 64 24 0c          	mull   0xc(%esp)
  8024fd:	89 c6                	mov    %eax,%esi
  8024ff:	89 d7                	mov    %edx,%edi
  802501:	39 d1                	cmp    %edx,%ecx
  802503:	72 06                	jb     80250b <__umoddi3+0xfb>
  802505:	75 10                	jne    802517 <__umoddi3+0x107>
  802507:	39 c3                	cmp    %eax,%ebx
  802509:	73 0c                	jae    802517 <__umoddi3+0x107>
  80250b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80250f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802513:	89 d7                	mov    %edx,%edi
  802515:	89 c6                	mov    %eax,%esi
  802517:	89 ca                	mov    %ecx,%edx
  802519:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251e:	29 f3                	sub    %esi,%ebx
  802520:	19 fa                	sbb    %edi,%edx
  802522:	89 d0                	mov    %edx,%eax
  802524:	d3 e0                	shl    %cl,%eax
  802526:	89 e9                	mov    %ebp,%ecx
  802528:	d3 eb                	shr    %cl,%ebx
  80252a:	d3 ea                	shr    %cl,%edx
  80252c:	09 d8                	or     %ebx,%eax
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	89 da                	mov    %ebx,%edx
  802542:	29 fe                	sub    %edi,%esi
  802544:	19 c2                	sbb    %eax,%edx
  802546:	89 f1                	mov    %esi,%ecx
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	e9 4b ff ff ff       	jmp    80249a <__umoddi3+0x8a>
